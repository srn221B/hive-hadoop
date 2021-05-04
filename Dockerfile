FROM centos:latest

RUN yum -y upgrade
RUN yum -y groupinstall 'Development tools'
RUN yum -y install wget

RUN yum -y install java-1.8.0-openjdk
RUN mv $(rpm -ql java-1.8.0-openjdk | grep jre | head -n 1 | sed 's/\/jre.*//') /usr/lib/jvm/java-1.8.0
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0/jre

RUN wget http://ftp.riken.jp/net/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
RUN mv hadoop-3.2.1.tar.gz /tmp/
RUN tar -xzvf /tmp/hadoop-3.2.1.tar.gz -C /usr/
ENV HADOOP_HOME /usr/hadoop-3.2.1
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin:$PATH

RUN wget http://ftp.riken.jp/net/apache/db/derby/db-derby-10.14.2.0/db-derby-10.14.2.0-bin.tar.gz
RUN mv db-derby-10.14.2.0-bin.tar.gz /tmp/
RUN tar -xzvf /tmp/db-derby-10.14.2.0-bin.tar.gz -C /tmp/
RUN mv /tmp/db-derby-10.14.2.0-bin /usr/derby
ENV DERBY_HOME /usr/derby
ENV PATH $PATH:$DERBY_HOME/bin
ENV CLASSPATH $CLASSPATH:$DERBY_HOME/lib/derby.jar:$DERBY_HOME/lib/derbytools.jar

RUN wget http://ftp.riken.jp/net/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
RUN mv apache-hive-3.1.2-bin.tar.gz /tmp/
RUN tar -xzvf /tmp/apache-hive-3.1.2-bin.tar.gz -C /tmp/
RUN mv /tmp/apache-hive-3.1.2-bin /usr/hive-3.1.2
RUN cp /usr/hive-3.1.2/conf/hive-default.xml.template /usr/hive-3.1.2/conf/hive-site.xml
ENV HIVE_HOME /usr/hive-3.1.2
ENV PATH $PATH:$HIVE_HOME/bin

RUN echo "Delete some sentence to avoid errors"
RUN sed -i -e 's/&#8;//' /usr/hive-3.1.2/conf/hive-site.xml
RUN echo "Add Configuration"
RUN sed -i -e 's/<\/configuration>//' /usr/hive-3.1.2/conf/hive-site.xml
COPY hive-template /tmp/hive-template
RUN cat /tmp/hive-template >> /usr/hive-3.1.2/conf/hive-site.xml
RUN cp $HADOOP_HOME/share/hadoop/common/lib/guava-27.0-jre.jar $HIVE_HOME/lib/
