Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4B422D78
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 09:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfETH5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 03:57:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37863 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbfETH5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 03:57:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id p15so6339714pll.4
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 00:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mFwOA2iY1DXfhm5KHyPaJ1neklN1UnTSJgD5oLUJZCk=;
        b=E8W5lCPexkJg8vnhZCrK5xoLNwWc4qvp93FrZPjFk4QwmVqd/KIXwAa8C21FrGbJ2G
         2vPw+Ep/1rdK8VgdFvX6jZotlvz7rTBMKKWiJC+Ahyqjp2+dV2M7W/C9Yds/gSBriW9x
         H0aSoLjYXPYNqGYMbjCITAZ368C9FqaaGYI8bZgEZB/LURAqmlMM2JvpwYLPGb6NVM17
         NFkUZDUVjEkjMJwxEhrQ3Nx1uq3p186aMqCsjCKGXf4cEb5tvzgQzi0q71Cy6PKgBYuy
         xjyEpvtWb0nSLhL88jcWRF2dqGocDvb8uYD3EGfhTUyEV1LvE2/xOoUwud+dZUJjJpTy
         +94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mFwOA2iY1DXfhm5KHyPaJ1neklN1UnTSJgD5oLUJZCk=;
        b=ou6GibiVnOsEtM9zSbpo+vRQsdQz1FKrrWdTe8iKFBPzZbgobLvK/sFDzhyO81ip9v
         3yZg0fn4yTTv8Fce47iw/lflFo9EZ3cxTGYjPU6DOq7rJpTJD72k0JH9mSSF1VITEsKE
         MLnk/6IgJMsEOPa8tBjmbWk+1KA7gwHQHmW6pmTKbDcUoZIjNy4RdcNOdvQaFxKVR/yO
         Lmugt+hIzfUCl+RQWokk97xNQpDo4xU1oWSq28/L/yrawH8DttwLTXX7OMjvw+z+3WRu
         STFrWVb+prPWknoRY2d+n0N9kD/p1WBjb5KLIiTNOIDQ7tTmnXY0mVPc0xfrJh2uC+Y2
         S7eQ==
X-Gm-Message-State: APjAAAVuQCmXYeAxzMINGEEdhZo6zxPEehFaIHMCIk5LOjomDhy1Q3ud
        s2c0ihiJ7nwgN4HJDwXtOeGl7a93a5I=
X-Google-Smtp-Source: APXvYqy4+rsPISIP2AS8zyYbaaD+nEPoeY999bHdqoVDS2RmSji7naMTj+ASGQUBl8IgvfERPHwQTg==
X-Received: by 2002:a17:902:728d:: with SMTP id d13mr31857357pll.337.1558339054114;
        Mon, 20 May 2019 00:57:34 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k6sm20282395pfi.86.2019.05.20.00.57.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 00:57:33 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2 net-next] ip: add a new parameter -Numeric
Date:   Mon, 20 May 2019 15:56:48 +0800
Message-Id: <20190520075648.15882-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calles rtnl_dsfield_n2a(), we get the dsfield name from
/etc/iproute2/rt_dsfield. But different distribution may have
different names. So add a new parameter '-Numeric' to only show
the dsfield number.

This parameter is only used for tos value at present. We could enable
this for other fields if needed in the future.

Suggested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/utils.h | 1 +
 ip/ip.c         | 6 +++++-
 lib/rt_names.c  | 4 +++-
 man/man8/ip.8   | 6 ++++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 8a9c3020..0f57ee97 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -34,6 +34,7 @@ extern int timestamp_short;
 extern const char * _SL_;
 extern int max_flush_loops;
 extern int batch_mode;
+extern int numeric;
 extern bool do_all;
 
 #ifndef CONFDIR
diff --git a/ip/ip.c b/ip/ip.c
index e4131714..2db5bbb0 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -36,6 +36,7 @@ int timestamp;
 int force;
 int max_flush_loops = 10;
 int batch_mode;
+int numeric;
 bool do_all;
 
 struct rtnl_handle rth = { .fd = -1 };
@@ -57,7 +58,8 @@ static void usage(void)
 "                    -4 | -6 | -I | -D | -M | -B | -0 |\n"
 "                    -l[oops] { maximum-addr-flush-attempts } | -br[ief] |\n"
 "                    -o[neline] | -t[imestamp] | -ts[hort] | -b[atch] [filename] |\n"
-"                    -rc[vbuf] [size] | -n[etns] name | -a[ll] | -c[olor]}\n");
+"                    -rc[vbuf] [size] | -n[etns] name | -N[umeric]} | -a[ll] |\n"
+"                    -c[olor]}\n");
 	exit(-1);
 }
 
@@ -287,6 +289,8 @@ int main(int argc, char **argv)
 			NEXT_ARG();
 			if (netns_switch(argv[1]))
 				exit(-1);
+		} else if (matches(opt, "-Numeric") == 0) {
+			++numeric;
 		} else if (matches(opt, "-all") == 0) {
 			do_all = true;
 		} else {
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 66d5f2f0..122bdd74 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -27,6 +27,8 @@
 
 #define NAME_MAX_LEN 512
 
+int numeric;
+
 struct rtnl_hash_entry {
 	struct rtnl_hash_entry	*next;
 	const char		*name;
@@ -480,7 +482,7 @@ const char *rtnl_dsfield_n2a(int id, char *buf, int len)
 		snprintf(buf, len, "%d", id);
 		return buf;
 	}
-	if (!rtnl_rtdsfield_tab[id]) {
+	if (!rtnl_rtdsfield_tab[id] && !numeric) {
 		if (!rtnl_rtdsfield_init)
 			rtnl_rtdsfield_initialize();
 	}
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index f4cbfc03..c2a8a92d 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -47,6 +47,7 @@ ip \- show / manipulate routing, network devices, interfaces and tunnels
 \fB\-t\fR[\fIimestamp\fR] |
 \fB\-ts\fR[\fIhort\fR] |
 \fB\-n\fR[\fIetns\fR] name |
+\fB\-N\fR[\fIumeric\fR] |
 \fB\-a\fR[\fIll\fR] |
 \fB\-c\fR[\fIolor\fR] |
 \fB\-br\fR[\fIief\fR] |
@@ -174,6 +175,11 @@ to
 .RI "-n[etns] " NETNS " [ " OPTIONS " ] " OBJECT " { " COMMAND " | "
 .BR help " }"
 
+.TP
+.BR "\-N" , " \-Numeric"
+Print the dsfield's numeric directly instead of converting to the name from
+/etc/iproute2/rt_dsfield.
+
 .TP
 .BR "\-a" , " \-all"
 executes specified command over all objects, it depends if command
-- 
2.19.2

