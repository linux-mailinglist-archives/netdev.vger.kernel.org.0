Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4982F3FE440
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbhIAUsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhIAUsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:48:08 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4473DC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:47:09 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 8so724705pga.7
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FubUooDS2WKMSYk2DOHk3EgWqp53DYzfL986g15sWe4=;
        b=G25M0gwUD74aqihsxJCooO/Id/T+ZQ79GNmWjRK2WZjTFAEmoYVEt81Ubv+GATYUnl
         pZB0nlmY6NEP7tzQANsVcERDn4o2dBnXzAdM1NUL0EEJLi7udT11hJ/nwks+IdT5LoK7
         sqmgyvJQPSTUO9lbMzX2j4l8nOV1HQKKC7U3m1yN3Tx3upcZokMJklZxWEtSt9nnLgNL
         aaqCwyIF3k1owPVrWW+q5/uYC5A9qryezAom+uYAQhZsYxdcaPT2IMzWqX73OOHKXdm8
         tAKf9NyZ3rzyPMkHfnfgYX4Y7ok74jtPip8Gqm3pVCWO8Fg4VtcUr7zKyTSnp/3IT7n1
         DfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FubUooDS2WKMSYk2DOHk3EgWqp53DYzfL986g15sWe4=;
        b=EjLx6DS2UA9oSvNhrxTQq2bbv0gB0nAjPm4CanlrnVYSWaBMAwgCpqKXscBc+8msq8
         F+MuuPTDOi/u2nx74G+0a3XyFky42G5dlWX8ipnuYNCb+U+U56E6zgdo5Ry6ydFzEQuD
         N/YU59u/x7BhLJeoLkn5JyrgfeRIXdXvb+L6X6q7WO8Q8WysGruCJlub+kOfv/eqlQzo
         uFrLRy+xcm7TbsXCHlNVDUwnNoeEE/Orjw1x1sJluKSRIKucHpayh5DeB1rRk4+tNLiZ
         qHnDbQvjsdLX1Ue0hsMVKYMh4c+4+hJzn07OUY0bZ9cfyP6Qkxni/cNwPHCAOqqqSPn1
         OFTw==
X-Gm-Message-State: AOAM532JHoPFJBgAXiZPl+HQ4ja2sFS3nmWaRC7VrdOE/9is2ZiybbTc
        BD+SSdF5IUEW8hE7ABMIH9gF+A/+2XtVbw==
X-Google-Smtp-Source: ABdhPJxm5XH/JYseoOdaSfSKFZeana8XTW5b4KHzfwIMjPtf0arhEAeDTLupj+fL2azoAAXllYaD0A==
X-Received: by 2002:a65:47c6:: with SMTP id f6mr876471pgs.450.1630529228306;
        Wed, 01 Sep 2021 13:47:08 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g26sm565073pgb.45.2021.09.01.13.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:47:07 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 4/4] ip: rewrite routel in python
Date:   Wed,  1 Sep 2021 13:47:01 -0700
Message-Id: <20210901204701.19646-5-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901204701.19646-1-sthemmin@microsoft.com>
References: <20210901204701.19646-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

Not sure if anyone uses the routel script. The script was
a combination of ip route, shell and awk doing command scraping.
It is now possible to do this much better using the JSON
output formats and python.

Rewriting also fixes the bug where the old script could not parse
the current output format.  At the end was getting:
/usr/bin/routel: 48: shift: can't shift that many

The new script also has IPv6 as option.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/routel         | 124 +++++++++++++++++++++-------------------------
 man/man8/routel.8 |  30 ++++++++---
 2 files changed, 79 insertions(+), 75 deletions(-)

diff --git a/ip/routel b/ip/routel
index 7056886d0f94..09a901267fb3 100755
--- a/ip/routel
+++ b/ip/routel
@@ -1,72 +1,62 @@
-#!/bin/sh
+#! /usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
-
-#
-# Script created by: Stephen R. van den Berg <srb@cuci.nl>, 1999/04/18
-# Donated to the public domain.
-#
-# This script transforms the output of "ip" into more readable text.
-# "ip" is the Linux-advanced-routing configuration tool part of the
-# iproute package.
 #
+# This is simple script to process JSON output from ip route
+# command and format it.  Based on earlier shell script version.
+"""Script to parse ip route output into more readable text."""
+
+import sys
+import json
+import getopt
+import subprocess
+
+
+def usage():
+    '''Print usage and exit'''
+    print("Usage: {} [tablenr [raw ip args...]]".format(sys.argv[0]))
+    sys.exit(64)
+
+
+def main():
+    '''Process the arguments'''
+    family = 'inet'
+    try:
+        opts, args = getopt.getopt(sys.argv[1:], "h46f:", ["help", "family="])
+    except getopt.GetoptError as err:
+        print(err)
+        usage()
+
+    for opt, arg in opts:
+        if opt in ["-h", "--help"]:
+            usage()
+        elif opt == '-6':
+            family = 'inet6'
+        elif opt == "-4":
+            family = 'inet'
+        elif opt in ["-f", "--family"]:
+            family = arg
+        else:
+            assert False, "unhandled option"
+
+    if not args:
+        args = ['0']
+
+    cmd = ['ip', '-f', family, '-j', 'route', 'list', 'table'] + args
+    process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
+    tbl = json.load(process.stdout)
+    if family == 'inet':
+        fmt = '{:15} {:15} {:15} {:8} {:8}{:<16} {}'
+    else:
+        fmt = '{:32} {:32} {:32} {:8} {:8}{:<16} {}'
+
+    # ip route json keys
+    keys = ['dst', 'gateway', 'prefsrc', 'protocol', 'scope', 'dev', 'table']
+    print(fmt.format(*map(lambda x: x.capitalize(), keys)))
 
-test "X-h" = "X$1" && echo "Usage: $0 [tablenr [raw ip args...]]" && exit 64
+    for record in tbl:
+        fields = [record[k] if k in record else '' for k in keys]
+        print(fmt.format(*fields))
 
-test -z "$*" && set 0
 
-ip route list table "$@" |
- while read network rest
- do set xx $rest
-    shift
-    proto=""
-    via=""
-    dev=""
-    scope=""
-    src=""
-    table=""
-    case $network in
-       broadcast|local|unreachable) via=$network
-          network=$1
-          shift
-          ;;
-    esac
-    while test $# != 0
-    do
-       case "$1" in
-          proto|via|dev|scope|src|table)
-             key=$1
-             val=$2
-             eval "$key='$val'"
-             shift 2
-             ;;
-          dead|onlink|pervasive|offload|notify|linkdown|unresolved)
-             shift
-             ;;
-          *)
-             # avoid infinite loop on unknown keyword without value at line end
-             shift
-             shift
-             ;;
-       esac
-    done
-    echo "$network	$via	$src	$proto	$scope	$dev	$table"
- done | awk -F '	' '
-BEGIN {
-   format="%15s%-3s %15s %15s %8s %8s%7s %s\n";
-   printf(format,"target","","gateway","source","proto","scope","dev","tbl");
- }
- { network=$1;
-   mask="";
-   if(match(network,"/"))
-    { mask=" "substr(network,RSTART+1);
-      network=substr(network,0,RSTART);
-    }
-   via=$2;
-   src=$3;
-   proto=$4;
-   scope=$5;
-   dev=$6;
-   table=$7;
-   printf(format,network,mask,via,src,proto,scope,dev,table);
- }
-'
+if __name__ == "__main__":
+    main()
diff --git a/man/man8/routel.8 b/man/man8/routel.8
index b32eeafcf69d..b1668e73615a 100644
--- a/man/man8/routel.8
+++ b/man/man8/routel.8
@@ -1,17 +1,31 @@
-.TH "ROUTEL" "8" "3 Jan, 2008" "iproute2" "Linux"
+.TH ROUTEL 8 "1 Sept, 2021" "iproute2" "Linux"
 .SH "NAME"
-.LP
 routel \- list routes with pretty output format
-.SH "SYNTAX"
-.LP
-routel [\fItablenr\fP [\fIraw ip args...\fP]]
+.SH SYNOPSIS
+.B routel
+.RI "[ " OPTIONS " ]"
+.RI "[ " tablenr
+[ \fIip route options...\fR ] ]
+.P
+.ti 8
+.IR OPTIONS " := {"
+\fB-h\fR | \fB--help\fR |
+[{\fB-f\fR | \fB--family\fR }
+{\fBinet\fR | \fBinet6\fR } |
+\fB-4\fR | \fB-6\fR }
+
 .SH "DESCRIPTION"
 .LP
-The routel script will list routes in a format that some might consider easier to interpret
-then the ip route list equivalent.
+The routel script will list routes in a format that some might consider
+easier to interpret then the
+.B ip
+route list equivalent.
+
 .SH "AUTHORS"
 .LP
-The routel script was written by Stephen R. van den Berg <srb@cuci.nl>, 1999/04/18 and donated to the public domain.
+Rewritten by Stephen Hemminger <stephen@networkplumber.org>.
+.br
+Original script by Stephen R. van den Berg <srb@cuci.nl>.
 .br
 This manual page was written by Andreas Henriksson  <andreas@fatal.se>, for the Debian GNU/Linux system.
 .SH "SEE ALSO"
-- 
2.30.2

