Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A415BE13
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgBML5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:57:54 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:38508 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:57:54 -0500
Received: by mail-pf1-f180.google.com with SMTP id x185so2975707pfc.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=lx1kG99lXDKChGuS8NWNEUTReFd8GUkXzj5L5xWy8hk=;
        b=gTWrWBgvenW1B7FovZhJ6RBJt5/OdPN8FQGF6nregKJvxtP7nDppi6rNE7ZlJgXbsz
         7u3bJ426HNysWvTYLU1RqZLCsP26EYFIUCdqm4wv0P0uB4XMK4rdDCuuG1GxblsaC3rc
         MFuhUMEL7Fk0hVxpQ/vvcD7Cj5I0nGbbNQwxKlt7FNNPcd8gYssqQ2NB42Ba3Lvzm5u1
         hX5jurGvP86cozPvtG8/GRBQGaIB6rbhaOgeVyP+AeAdaL8q4derWc1Jfm/GDi6uu6J6
         bfIvLqAGh2ltv0ZwwY5kaw0qrr2t9kExsMZCWT4gEsrx7Nlh6/IGteMAfAY+lArC70EM
         +JXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=lx1kG99lXDKChGuS8NWNEUTReFd8GUkXzj5L5xWy8hk=;
        b=QE0BG9zJX+X3liRGuggcfpkxf9wX0vBGbdnMSRRQF/bv7pDnGz+d4OAReUcdGpYxg2
         Z8QG6xFLQbTlVZ95XH89/5gfNk8f2NnUKKYUG9ezqeqZtrEefNqwjCoC1OYW+TETZJKX
         MnBX7y5kqO8HXcESesM86Y/TgXTghc15Mq+AxTCcIc724rivxwZUlFRQtr2tO1plLqXP
         74gMqHMplnf2Sl3C6vewFqp3HuQdKxM4vlaTkrU5nOlaTM6kWHHi4HyMwtMtTix0+b+A
         yvPP6HkVjuHmBhFEO64axva83kiUHHOTUfQCd5850A6XR/OCmCwhfrWyrDWb2D2/ust2
         dggg==
X-Gm-Message-State: APjAAAVdjUaqDpT8i6j6812s9cwPS3HZVeK9QhIWkF/lb0IXm+O/ogeZ
        AHqgKbYPosbnlHQ6OL3evZa36+oh
X-Google-Smtp-Source: APXvYqzGmIuL3pbZHHgydsgJu1E0qnchop5RlTZRNti6rFudy89Wia8y0K3Oda9HYyO8ZAsQhvfKFQ==
X-Received: by 2002:a63:d710:: with SMTP id d16mr17548313pgg.393.1581595073506;
        Thu, 13 Feb 2020 03:57:53 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cx18sm2583383pjb.26.2020.02.13.03.57.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:57:52 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 5/7] tc: m_tunnel_key: add options support for erpsan
Date:   Thu, 13 Feb 2020 19:57:03 +0800
Message-Id: <ba3793a7720825210dbd0678c844b173765021cc.1581594682.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <3d2f2000500740cb43fad910253ae5bf1424c776.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
 <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
 <0bf376a8304996ec0edf0b14111a2c924a44b5ff.1581594682.git.lucien.xin@gmail.com>
 <f34d6f4b5002bba1433958b73e193843d1b06d86.1581594682.git.lucien.xin@gmail.com>
 <3d2f2000500740cb43fad910253ae5bf1424c776.1581594682.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN's parse and
print to implement erspan options support in m_tunnel_key, like
Commit 6217917a3826 ("tc: m_tunnel_key: Add tunnel option support
to act_tunnel_key") for geneve options support.

Option is expressed as version:index:dir:hwid, dir and hwid will
be parsed when version is 2, while index will be parsed when
version is 1. erspan doesn't support multiple options.

With this patch, users can add and dump erspan options like:

  # ip link add name erspan1 type erspan external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
      flower indev eth0 \
        ip_proto udp \
        action tunnel_key \
          set src_ip 10.0.99.192 \
          dst_ip 10.0.99.193 \
          dst_port 6081 \
          id 11 \
          erspan_opts 1:2:0:0 \
      action mirred egress redirect dev erspan1
  # tc -s filter show dev eth0 parent ffff:

     filter protocol ip pref 49151 flower chain 0 handle 0x1
       indev eth0
       eth_type ipv4
       ip_proto udp
       not_in_hw
         action order 1: tunnel_key  set
         src_ip 10.0.99.192
         dst_ip 10.0.99.193
         key_id 11
         dst_port 6081
         erspan_opts 01:00000002:00:00
         csum pipe
           index 2 ref 1 bind 1
         ...
v1->v2:
  - no change.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-tunnel_key.8 |  12 ++++-
 tc/m_tunnel_key.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index f78227c..bf2ebaa 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -68,8 +68,10 @@ options.
 .B dst_port
 ,
 .B geneve_opts
-and
+,
 .B vxlan_opts
+and
+.B erspan_opts
 are optional.
 .RS
 .TP
@@ -99,6 +101,14 @@ Vxlan metatdata options.
 is specified in the form GBP, as a 32bit hexadecimal value. Multiple options
 is not supported.
 .TP
+.B erspan_opts
+Erspan metatdata options.
+.B erspan_opts
+is specified in the form VERSION:INDEX:DIR:HWID, where VERSION is represented
+as a 8bit hexadecimal value, INDEX as an 32bit hexadecimal value, DIR and HWID
+as a 8bit hexadecimal value. Multiple options is not supported. Note INDEX is
+used when VERSION is 1, and DIR and HWID are used when VERSION is 2.
+.TP
 .B tos
 Outer header TOS
 .TP
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 0b99cee..ccc7598 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -29,7 +29,7 @@ static void explain(void)
 		"src_ip <IP> (mandatory)\n"
 		"dst_ip <IP> (mandatory)\n"
 		"dst_port <UDP_PORT>\n"
-		"geneve_opts | vxlan_opts <OPTIONS>\n"
+		"geneve_opts | vxlan_opts | erspan_opts <OPTIONS>\n"
 		"csum | nocsum (default is \"csum\")\n");
 }
 
@@ -97,6 +97,21 @@ static int tunnel_key_parse_be16(char *str, int base, int type,
 	return 0;
 }
 
+static int tunnel_key_parse_be32(char *str, int base, int type,
+				 struct nlmsghdr *n)
+{
+	__be32 value;
+	int ret;
+
+	ret = get_be32(&value, str, base);
+	if (ret)
+		return ret;
+
+	addattr32(n, MAX_MSG, type, value);
+
+	return 0;
+}
+
 static int tunnel_key_parse_u8(char *str, int base, int type,
 			       struct nlmsghdr *n)
 {
@@ -226,6 +241,63 @@ static int tunnel_key_parse_vxlan_opt(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int tunnel_key_parse_erspan_opt(char *str, struct nlmsghdr *n)
+{
+	char *token, *saveptr = NULL;
+	struct rtattr *encap, *nest;
+	int i, ret;
+
+	encap = addattr_nest(n, MAX_MSG,
+			     TCA_TUNNEL_KEY_ENC_OPTS | NLA_F_NESTED);
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN | NLA_F_NESTED);
+
+	token = strtok_r(str, ":", &saveptr);
+	i = 1;
+	while (token) {
+		switch (i) {
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER:
+		{
+			ret = tunnel_key_parse_u8(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX:
+		{
+			ret = tunnel_key_parse_be32(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR:
+		{
+			ret = tunnel_key_parse_u8(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		case TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID:
+		{
+			ret = tunnel_key_parse_u8(token, 16, i, n);
+			if (ret)
+				return ret;
+			break;
+		}
+		default:
+			return -1;
+		}
+
+		token = strtok_r(NULL, ":", &saveptr);
+		i++;
+	}
+
+	addattr_nest_end(n, nest);
+	addattr_nest_end(n, encap);
+
+	return 0;
+}
+
 static int tunnel_key_parse_tos_ttl(char *str, int type, struct nlmsghdr *n)
 {
 	int ret;
@@ -330,6 +402,13 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 				fprintf(stderr, "Illegal \"vxlan_opts\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "erspan_opts") == 0) {
+			NEXT_ARG();
+
+			if (tunnel_key_parse_erspan_opt(*argv, n)) {
+				fprintf(stderr, "Illegal \"erspan_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "tos") == 0) {
 			NEXT_ARG();
 			ret = tunnel_key_parse_tos_ttl(*argv,
@@ -520,6 +599,44 @@ static void tunnel_key_print_vxlan_options(struct rtattr *attr)
 	close_json_array(PRINT_JSON, name);
 }
 
+static void tunnel_key_print_erspan_options(struct rtattr *attr)
+{
+	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "erspan_opts";
+	char strbuf[rem * 2 + 1];
+	__u8 ver, hwid, dir;
+	__u32 idx;
+
+	open_json_array(PRINT_JSON, name);
+	print_string(PRINT_FP, name, "\n\t%s ", name);
+
+	parse_rtattr(tb, TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_MAX, i, rem);
+	ver = rta_getattr_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		idx = rta_getattr_be32(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_INDEX]);
+		dir = 0;
+		hwid = 0;
+	} else {
+		idx = 0;
+		dir = rta_getattr_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_DIR]);
+		hwid = rta_getattr_u8(tb[TCA_TUNNEL_KEY_ENC_OPT_ERSPAN_HWID]);
+	}
+
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "ver", NULL, ver);
+	print_uint(PRINT_JSON, "index", NULL, idx);
+	print_uint(PRINT_JSON, "dir", NULL, dir);
+	print_uint(PRINT_JSON, "hwid", NULL, hwid);
+	close_json_object();
+
+	sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
+	print_string(PRINT_FP, NULL, "%s", strbuf);
+
+	close_json_array(PRINT_JSON, name);
+}
+
 static void tunnel_key_print_key_opt(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1];
@@ -534,6 +651,9 @@ static void tunnel_key_print_key_opt(struct rtattr *attr)
 	else if (tb[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN])
 		tunnel_key_print_vxlan_options(
 			tb[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]);
+	else if (tb[TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN])
+		tunnel_key_print_erspan_options(
+			tb[TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN]);
 }
 
 static void tunnel_key_print_tos_ttl(FILE *f, char *name,
-- 
2.1.0

