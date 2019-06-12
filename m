Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C84209E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437377AbfFLJVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:21:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43166 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436698AbfFLJVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:21:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so9285527pfg.10
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 02:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zxCQw3cFVWfgycl1VwK01RtAPmQqPKnfCz5Q7pMMsHI=;
        b=BRuueEcBzRnB8tsCfisQRxmBblJj/2BcQj4ebOIKO836RCaWjnn2jQP8sfPEfxPODP
         ARThB56Yqs5V0iuSSFlwff/dCW3wdEEWGhbvZ93Kq3TgNKl20zxO4sPcyIdGhnKCR8sc
         KJc9pQ7phlPhDmZgX8NQl5rcNmVZ2wBxnWCvRJhfY29ROs1CRFaXhv/u8bNQYSc7dhXG
         cNm54kLt6DptVWc8GoLkbX4ZxsVGO77Jew5tw7NDooW4QsX4h/OO7AYtbrGtE7+gkItX
         P1fOf2Bwf9s0LsmZCVSZQAHtR72GbmdJXQSLkwO+kN8tLYIFFCZGt8jnKgI9bXHpOYCy
         ipuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zxCQw3cFVWfgycl1VwK01RtAPmQqPKnfCz5Q7pMMsHI=;
        b=Fkjk1Hr02sCzZy73uOMWUWBeCpl418QlO/nlK7zGOdGZlmNnkkidVH6cTj547RNuVp
         bBzs4AnC+qk9jpKXeY0XuJyYUCcN1SAdRlZYY5QPcmcnsVbeHhEtpRuxiw8ES3Y4ibL6
         c8bMzyKBxgZfabu9T13kGtQe37Nu6zFs3N3t/5j0kA/ceWH6/QjiBOGkRMt2BNqvx/bc
         BYB9vcCy71pd5bwzAUexrVFvTluTezVF4P0ZmoAxslAM1Kc1iaLxDfTsnQoirKAWVijf
         UGcpdiCiwYCkMn3dfagP2E5mpRAdglLzkA0OeUZPh2R38RjwUuEAfgUgyMBA0HWa1AE8
         L+3A==
X-Gm-Message-State: APjAAAUnoOxL/ebtUf28zZGmjkTP//jXNOi1yuoiY9HArXVfrmScIe60
        Tb9Fs8Q98Ly56lVAIaS/2iZDloDI4to=
X-Google-Smtp-Source: APXvYqwvMWu51VeggWfGmp0K4rXN3MLymrk6SuTds9N9WgpSfi6fbfwlyVJsIumzbXHYEccec1XJbw==
X-Received: by 2002:a17:90a:b94c:: with SMTP id f12mr31308555pjw.64.1560331292048;
        Wed, 12 Jun 2019 02:21:32 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b26sm14399257pfo.129.2019.06.12.02.21.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 02:21:31 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
Date:   Wed, 12 Jun 2019 17:21:15 +0800
Message-Id: <20190612092115.30043-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new parameter '-Numeric' to show the number of protocol, scope,
dsfield, etc directly instead of converting it to human readable name.
Do the same on tc and ss.

This patch is based on David Ahern's previous patch.

Suggested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/utils.h  |  1 +
 ip/ip.c          |  6 +++++-
 ip/rtm_map.c     |  6 ++++++
 lib/inet_proto.c |  2 +-
 lib/ll_proto.c   |  2 +-
 lib/ll_types.c   |  3 ++-
 lib/rt_names.c   | 18 ++++++++++--------
 man/man8/ip.8    |  6 ++++++
 man/man8/tc.8    |  6 ++++++
 misc/ss.c        | 15 ++++++---------
 tc/tc.c          |  5 ++++-
 11 files changed, 48 insertions(+), 22 deletions(-)

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
index b46fd8dd..fed26f8d 100644
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
-		"                    -rc[vbuf] [size] | -n[etns] name | -a[ll] | -c[olor]}\n");
+		"                    -rc[vbuf] [size] | -n[etns] name | -N[umeric] | -a[ll] |\n"
+		"                    -c[olor]}\n");
 	exit(-1);
 }
 
@@ -288,6 +290,8 @@ int main(int argc, char **argv)
 			NEXT_ARG();
 			if (netns_switch(argv[1]))
 				exit(-1);
+		} else if (matches(opt, "-Numeric") == 0) {
+			++numeric;
 		} else if (matches(opt, "-all") == 0) {
 			do_all = true;
 		} else {
diff --git a/ip/rtm_map.c b/ip/rtm_map.c
index 76f93780..8d8eafe0 100644
--- a/ip/rtm_map.c
+++ b/ip/rtm_map.c
@@ -23,6 +23,12 @@
 
 char *rtnl_rtntype_n2a(int id, char *buf, int len)
 {
+
+	if (numeric) {
+		snprintf(buf, len, "%d", id);
+		return buf;
+	}
+
 	switch (id) {
 	case RTN_UNSPEC:
 		return "none";
diff --git a/lib/inet_proto.c b/lib/inet_proto.c
index 0836a4c9..41e2e8b8 100644
--- a/lib/inet_proto.c
+++ b/lib/inet_proto.c
@@ -32,7 +32,7 @@ const char *inet_proto_n2a(int proto, char *buf, int len)
 		return ncache;
 
 	pe = getprotobynumber(proto);
-	if (pe) {
+	if (pe && !numeric) {
 		if (icache != -1)
 			free(ncache);
 		icache = proto;
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 8316a755..78c39616 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -92,7 +92,7 @@ const char * ll_proto_n2a(unsigned short id, char *buf, int len)
 
 	id = ntohs(id);
 
-        for (i=0; i<sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
+        for (i=0; !numeric && i<sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
                  if (llproto_names[i].id == id)
 			return llproto_names[i].name;
 	}
diff --git a/lib/ll_types.c b/lib/ll_types.c
index 32d04b5a..49da15df 100644
--- a/lib/ll_types.c
+++ b/lib/ll_types.c
@@ -24,6 +24,7 @@
 #include <linux/sockios.h>
 
 #include "rt_names.h"
+#include "utils.h"
 
 const char * ll_type_n2a(int type, char *buf, int len)
 {
@@ -112,7 +113,7 @@ __PF(VOID,void)
 #undef __PF
 
         int i;
-        for (i=0; i<sizeof(arphrd_names)/sizeof(arphrd_names[0]); i++) {
+        for (i=0; !numeric && i<sizeof(arphrd_names)/sizeof(arphrd_names[0]); i++) {
                  if (arphrd_names[i].type == type)
 			return arphrd_names[i].name;
 	}
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 66d5f2f0..41cccfb8 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -27,6 +27,8 @@
 
 #define NAME_MAX_LEN 512
 
+int numeric;
+
 struct rtnl_hash_entry {
 	struct rtnl_hash_entry	*next;
 	const char		*name;
@@ -180,7 +182,7 @@ static void rtnl_rtprot_initialize(void)
 
 const char *rtnl_rtprot_n2a(int id, char *buf, int len)
 {
-	if (id < 0 || id >= 256) {
+	if (id < 0 || id >= 256 || numeric) {
 		snprintf(buf, len, "%u", id);
 		return buf;
 	}
@@ -246,7 +248,7 @@ static void rtnl_rtscope_initialize(void)
 
 const char *rtnl_rtscope_n2a(int id, char *buf, int len)
 {
-	if (id < 0 || id >= 256) {
+	if (id < 0 || id >= 256 || numeric) {
 		snprintf(buf, len, "%d", id);
 		return buf;
 	}
@@ -311,7 +313,7 @@ static void rtnl_rtrealm_initialize(void)
 
 const char *rtnl_rtrealm_n2a(int id, char *buf, int len)
 {
-	if (id < 0 || id >= 256) {
+	if (id < 0 || id >= 256 || numeric) {
 		snprintf(buf, len, "%d", id);
 		return buf;
 	}
@@ -419,7 +421,7 @@ const char *rtnl_rttable_n2a(__u32 id, char *buf, int len)
 	entry = rtnl_rttable_hash[id & 255];
 	while (entry && entry->id != id)
 		entry = entry->next;
-	if (entry)
+	if (!numeric && entry)
 		return entry->name;
 	snprintf(buf, len, "%u", id);
 	return buf;
@@ -484,7 +486,7 @@ const char *rtnl_dsfield_n2a(int id, char *buf, int len)
 		if (!rtnl_rtdsfield_init)
 			rtnl_rtdsfield_initialize();
 	}
-	if (rtnl_rtdsfield_tab[id])
+	if (!numeric && rtnl_rtdsfield_tab[id])
 		return rtnl_rtdsfield_tab[id];
 	snprintf(buf, len, "0x%02x", id);
 	return buf;
@@ -584,7 +586,7 @@ const char *rtnl_group_n2a(int id, char *buf, int len)
 	if (!rtnl_group_init)
 		rtnl_group_initialize();
 
-	for (i = 0; i < 256; i++) {
+	for (i = 0; !numeric && i < 256; i++) {
 		entry = rtnl_group_hash[i];
 
 		while (entry) {
@@ -633,8 +635,8 @@ static void nl_proto_initialize(void)
 
 const char *nl_proto_n2a(int id, char *buf, int len)
 {
-	if (id < 0 || id >= 256) {
-		snprintf(buf, len, "%u", id);
+	if (id < 0 || id >= 256 || numeric) {
+		snprintf(buf, len, "%d", id);
 		return buf;
 	}
 
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index f4cbfc03..e2bda2a2 100644
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
+Print the number of protocol, scope, dsfield, etc directly instead of
+converting it to human readable name.
+
 .TP
 .BR "\-a" , " \-all"
 executes specified command over all objects, it depends if command
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index ab0bad8a..b81a396f 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -119,6 +119,7 @@ tc \- show / manipulate traffic control settings
 .IR OPTIONS " := {"
 \fB[ -force ] -b\fR[\fIatch\fR] \fB[ filename ] \fR|
 \fB[ \fB-n\fR[\fIetns\fR] name \fB] \fR|
+\fB[ \fB-N\fR[\fIumeric\fR] \fB] \fR|
 \fB[ \fB-nm \fR| \fB-nam\fR[\fIes\fR] \fB] \fR|
 \fB[ \fR{ \fB-cf \fR| \fB-c\fR[\fIonf\fR] \fR} \fB[ filename ] \fB] \fR
 \fB[ -t\fR[imestamp\fR] \fB\] \fR| \fB[ -t\fR[short\fR] \fR| \fB[
@@ -707,6 +708,11 @@ to
 .RI "-n[etns] " NETNS " [ " OPTIONS " ] " OBJECT " { " COMMAND " | "
 .BR help " }"
 
+.TP
+.BR "\-N" , " \-Numeric"
+Print the number of protocol, scope, dsfield, etc directly instead of
+converting it to human readable name.
+
 .TP
 .BR "\-cf" , " \-conf " <FILENAME>
 specifies path to the config file. This option is used in conjunction with other options (e.g.
diff --git a/misc/ss.c b/misc/ss.c
index 99c06d31..e01ebf4d 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -106,7 +106,6 @@ static int security_get_initial_context(char *name,  char **context)
 }
 #endif
 
-static int resolve_services = 1;
 int preferred_family = AF_UNSPEC;
 static int show_options;
 int show_details;
@@ -121,6 +120,7 @@ static int follow_events;
 static int sctp_ino;
 static int show_tipcinfo;
 static int show_tos;
+int numeric;
 int oneline;
 
 enum col_id {
@@ -1553,7 +1553,7 @@ static const char *resolve_service(int port)
 		return buf;
 	}
 
-	if (!resolve_services)
+	if (numeric)
 		goto do_numeric;
 
 	if (dg_proto == RAW_PROTO)
@@ -4296,14 +4296,11 @@ static int netlink_show_one(struct filter *f,
 
 	sock_state_print(&st);
 
-	if (resolve_services)
-		prot_name = nl_proto_n2a(prot, prot_buf, sizeof(prot_buf));
-	else
-		prot_name = int_to_str(prot, prot_buf);
+	prot_name = nl_proto_n2a(prot, prot_buf, sizeof(prot_buf));
 
 	if (pid == -1) {
 		procname[0] = '*';
-	} else if (resolve_services) {
+	} else if (!numeric) {
 		int done = 0;
 
 		if (!pid) {
@@ -5050,7 +5047,7 @@ int main(int argc, char *argv[])
 				 long_opts, NULL)) != EOF) {
 		switch (ch) {
 		case 'n':
-			resolve_services = 0;
+			numeric = 1;
 			break;
 		case 'r':
 			resolve_hosts = 1;
@@ -5268,7 +5265,7 @@ int main(int argc, char *argv[])
 	filter_states_set(&current_filter, state_filter);
 	filter_merge_defaults(&current_filter);
 
-	if (resolve_services && resolve_hosts &&
+	if (!numeric && resolve_hosts &&
 	    (current_filter.dbs & (UNIX_DBM|INET_L4_DBM)))
 		init_service_resolver();
 
diff --git a/tc/tc.c b/tc/tc.c
index e08f322a..64e342dd 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -43,6 +43,7 @@ bool use_names;
 int json;
 int color;
 int oneline;
+int numeric;
 
 static char *conf_file;
 
@@ -200,7 +201,7 @@ static void usage(void)
 		"		    action | monitor | exec }\n"
 		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |\n"
 		"		    -o[neline] | -j[son] | -p[retty] | -c[olor]\n"
-		"		    -b[atch] [filename] | -n[etns] name |\n"
+		"		    -b[atch] [filename] | -n[etns] name | -N[umeric] |\n"
 		"		     -nm | -nam[es] | { -cf | -conf } path }\n");
 }
 
@@ -486,6 +487,8 @@ int main(int argc, char **argv)
 			NEXT_ARG();
 			if (netns_switch(argv[1]))
 				return -1;
+		} else if (matches(argv[1], "-Numeric") == 0) {
+			++numeric;
 		} else if (matches(argv[1], "-names") == 0 ||
 				matches(argv[1], "-nm") == 0) {
 			use_names = true;
-- 
2.19.2

