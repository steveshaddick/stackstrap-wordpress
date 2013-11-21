#
# Wordpress state file
# 
# Deploys wordpress on nginx + mysql
#

include:
  - avahi
  - nginx
  - mysql.server
  - php5.fpm

{% from "utils/users.sls" import skeleton %}
{% from "mysql/macros.sls" import mysql_user_db %}
{% from "nginx/macros.sls" import nginxsite %}
{% from "php5/macros.sls" import php5_fpm_instance %}

{% set short_name = pillar['project']['short_name'] -%}
{% set home = "/home/" + short_name -%}
{% set appdir = home + "/current" -%}

{{ skeleton(short_name, 6000, 6000) }}
{{ mysql_user_db(short_name, short_name) }}
{{ php5_fpm_instance(short_name, 6000, short_name, short_name) }}
{{ nginxsite(short_name, short_name, short_name,
             template="php-fastcgi.conf",
             server_name="_",
             create_root=False,
             defaults={
              'port': 6000,
              'try_files': '/index.php'
             })
}}

/home/{{ short_name }}/domains/{{ short_name }}/public:
  file:
    - symlink
    - target: {{ appdir }}/public

# vim: set ft=yaml ts=2 sw=2 sts=2 et ai :
