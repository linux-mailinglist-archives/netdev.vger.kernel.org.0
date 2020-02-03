Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85F150184
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgBCFkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:40:39 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33423 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgBCFkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 00:40:39 -0500
Received: by mail-pl1-f171.google.com with SMTP id ay11so5392053plb.0
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 21:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=o8Smn+G1eM/m+n2gogIAWZ2FwoGJ8qsld+p+ljzdYFI=;
        b=EPvb4O/OMxG7m0laMUwlucgkEDZmM8VQuAqfSDJ0ShFe3y+xErF+7hEIjODv0fe3QF
         RNGCBhGbH43nR2KQIssbJiWKGh2lI5ZQWEc+fEyZ9U+LJ5pKedT6rjtO7zMPCcHz2b9u
         0S7JTYTLLejlwbwt1hZQYzoVz+bMBg4hd6QbH4JAQEDp4wyGnJvBOZh4teHSOdAMvYT0
         R+w4qe98s87o1i3O2lHewO94XunIRDzXmD7wZjCCyYyVvLL4ZiMgITHNF+hQceoUEiws
         G1n6v8/EIckw5eOr97/eF/QkDbwgsIzUzcO8bIuruhl3wHItUw/zK2seBBNB2Jm/HxjE
         Edpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=o8Smn+G1eM/m+n2gogIAWZ2FwoGJ8qsld+p+ljzdYFI=;
        b=un9Zjc9juA19MdaNkpubJhfDpOW3UsvFzoMaCMCq/YNfl8ypX7vixGdo/G5A9S9/q+
         Aa5kwI50ePwZHiBSRyopN0+MSGd6tBpL4wV22mn/kxzzygrMJk6dhE2/g+2MN3dsqGdg
         0Xxl5aRiwpNf+d5FihbjlhYMZLsVVF+ax1Aec1u1u5IF9iAyTpI5VPxBuTjFVWK8oPgd
         T0p9WljtyVbw2w5RQRzOU/qlGdAHDJCeOc8aGbqkW0lX2a9lOtjVy8Ha/ZKLm+U9Lne3
         tjZUfdGpPsBHLeDdna3iDJpPO31w5/3Pln/TbYsKcqyBbGb7KU3/PcL6LH0MCLiyfUce
         Z8kQ==
X-Gm-Message-State: APjAAAX9AXS1e9P2/GK0sugmkDFFuKRu0CIsvH8MRUqorgR81ZQeLZFa
        LKrDFRxnT5avxdrrkGGw4Mue5KIY
X-Google-Smtp-Source: APXvYqxnc57KiuDfPXzwlNn7ruovR/KmOWzmt37TYgD/RB4uvbyPvu/t/D9YrvfdpBKQT79o2uepFw==
X-Received: by 2002:a17:90a:102:: with SMTP id b2mr19377128pjb.64.1580708438159;
        Sun, 02 Feb 2020 21:40:38 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm17864954pgk.24.2020.02.02.21.40.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Feb 2020 21:40:37 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: [PATCH iproute2-next 4/7] tc: m_tunnel_key: add options support for vxlan
Date:   Mon,  3 Feb 2020 13:39:55 +0800
Message-Id: <6c1ec9335ab088dbc7befbd395cf836351097ca9.1580708369.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7d0842940d1d0eb6bc6d39707a378facd8ecb456.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
 <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
 <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
 <7d0842940d1d0eb6bc6d39707a378facd8ecb456.1580708369.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_TUNNEL_KEY_ENC_OPTS_VXLAN's parse and
print to implement vxlan options support in m_tunnel_key, like
Commit 6217917a3826 ("tc: m_tunnel_key: Add tunnel option support
to act_tunnel_key") for geneve options support.

Option is expressed a 32bit hexadecimal value for gbp only, and
vxlan doesn't support multiple options.

With this patch, users can add and dump vxlan options like:

  # ip link add name vxlan1 type vxlan dstport 0 external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
      flower indev eth0 \
        ip_proto udp \
        action tunnel_key \
          set src_ip 10.0.99.192 \
          dst_ip 10.0.99.193 \
          dst_port 6081 \
          id 11 \
          vxlan_opts 010101 \
      action mirred egress redirect dev vxlan1
  # tc -s filter show dev eth0 parent ffff:

     filter protocol ip pref 49152 flower chain 0 handle 0x1
       indev eth0
       eth_type ipv4
       ip_proto udp
       not_in_hw
         action order 1: tunnel_key  set
         src_ip 10.0.99.192
         dst_ip 10.0.99.193
         key_id 11
         dst_port 6081
         vxlan_opts 00010101
         ...

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-tunnel_key.8 | 10 +++++-
 tc/m_tunnel_key.c        | 89 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index 2145eb6..f78227c 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -66,8 +66,10 @@ options.
 .B id
 ,
 .B dst_port
-and
+,
 .B geneve_opts
+and
+.B vxlan_opts
 are optional.
 .RS
 .TP
@@ -91,6 +93,12 @@ is specified in the form CLASS:TYPE:DATA, where CLASS is represented as a
 variable length hexadecimal value. Additionally multiple options may be
 listed using a comma delimiter.
 .TP
+.B vxlan_opts
+Vxlan metatdata options.
+.B vxlan_opts
+is specified in the form GBP, as a 32bit hexadecimal value. Multiple options
+is not supported.
+.TP
 .B tos
 Outer header TOS
 .TP
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 8fde689..1698a42 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -29,7 +29,7 @@ static void explain(void)
 		"src_ip <IP> (mandatory)\n"
 		"dst_ip <IP> (mandatory)\n"
 		"dst_port <UDP_PORT>\n"
-		"geneve_opts <OPTIONS>\n"
+		"geneve_opts | vxlan_opts <OPTIONS>\n"
 		"csum | nocsum (default is \"csum\")\n");
 }
 
@@ -112,6 +112,21 @@ static int tunnel_key_parse_u8(char *str, int base, int type,
 	return 0;
 }
 
+static int tunnel_key_parse_u32(char *str, int base, int type,
+				struct nlmsghdr *n)
+{
+	__u32 value;
+	int ret;
+
+	ret = get_u32(&value, str, base);
+	if (ret)
+		return ret;
+
+	addattr32(n, MAX_MSG, type, value);
+
+	return 0;
+}
+
 static int tunnel_key_parse_geneve_opt(char *str, struct nlmsghdr *n)
 {
 	char *token, *saveptr = NULL;
@@ -190,6 +205,27 @@ static int tunnel_key_parse_geneve_opts(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int tunnel_key_parse_vxlan_opt(char *str, struct nlmsghdr *n)
+{
+	struct rtattr *encap, *nest;
+	int ret;
+
+	encap = addattr_nest(n, MAX_MSG,
+			     TCA_TUNNEL_KEY_ENC_OPTS | NLA_F_NESTED);
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_TUNNEL_KEY_ENC_OPTS_VXLAN | NLA_F_NESTED);
+
+	ret = tunnel_key_parse_u32(str, 16,
+				   TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP, n);
+	if (ret)
+		return ret;
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
@@ -287,6 +323,13 @@ static int parse_tunnel_key(struct action_util *a, int *argc_p, char ***argv_p,
 				fprintf(stderr, "Illegal \"geneve_opts\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "vxlan_opts") == 0) {
+			NEXT_ARG();
+
+			if (tunnel_key_parse_vxlan_opt(*argv, n)) {
+				fprintf(stderr, "Illegal \"vxlan_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "tos") == 0) {
 			NEXT_ARG();
 			ret = tunnel_key_parse_tos_ttl(*argv,
@@ -406,13 +449,13 @@ static void tunnel_key_print_flag(FILE *f, const char *name_on,
 		     rta_getattr_u8(attr) ? name_on : name_off);
 }
 
-static void tunnel_key_print_geneve_options(const char *name,
-					    struct rtattr *attr)
+static void tunnel_key_print_geneve_options(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1];
 	struct rtattr *i = RTA_DATA(attr);
 	int ii, data_len = 0, offset = 0;
 	int rem = RTA_PAYLOAD(attr);
+	char *name = "geneve_opts";
 	char strbuf[rem * 2 + 1];
 	char data[rem * 2 + 1];
 	uint8_t data_r[rem];
@@ -421,7 +464,7 @@ static void tunnel_key_print_geneve_options(const char *name,
 
 	open_json_array(PRINT_JSON, name);
 	print_nl();
-	print_string(PRINT_FP, name, "\t%s ", "geneve_opt");
+	print_string(PRINT_FP, name, "\t%s ", name);
 
 	while (rem) {
 		parse_rtattr(tb, TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX, i, rem);
@@ -454,7 +497,32 @@ static void tunnel_key_print_geneve_options(const char *name,
 	close_json_array(PRINT_JSON, name);
 }
 
-static void tunnel_key_print_key_opt(const char *name, struct rtattr *attr)
+static void tunnel_key_print_vxlan_options(struct rtattr *attr)
+{
+	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "vxlan_opts";
+	char strbuf[rem * 2 + 1];
+	__u32 gbp;
+
+	open_json_array(PRINT_JSON, name);
+	print_string(PRINT_FP, name, "\n\t%s ", name);
+
+	parse_rtattr(tb, TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX, i, rem);
+	gbp = rta_getattr_u32(tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]);
+
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "gbp", NULL, gbp);
+	close_json_object();
+
+	sprintf(strbuf, "%08x", gbp);
+	print_string(PRINT_FP, NULL, "%s", strbuf);
+
+	close_json_array(PRINT_JSON, name);
+}
+
+static void tunnel_key_print_key_opt(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1];
 
@@ -462,8 +530,12 @@ static void tunnel_key_print_key_opt(const char *name, struct rtattr *attr)
 		return;
 
 	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_ENC_OPTS_MAX, attr);
-	tunnel_key_print_geneve_options(name,
-					tb[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]);
+	if (tb[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE])
+		tunnel_key_print_geneve_options(
+			tb[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]);
+	else if (tb[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN])
+		tunnel_key_print_vxlan_options(
+			tb[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]);
 }
 
 static void tunnel_key_print_tos_ttl(FILE *f, char *name,
@@ -519,8 +591,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 					tb[TCA_TUNNEL_KEY_ENC_KEY_ID]);
 		tunnel_key_print_dst_port(f, "dst_port",
 					  tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
-		tunnel_key_print_key_opt("geneve_opts",
-					 tb[TCA_TUNNEL_KEY_ENC_OPTS]);
+		tunnel_key_print_key_opt(tb[TCA_TUNNEL_KEY_ENC_OPTS]);
 		tunnel_key_print_flag(f, "nocsum", "csum",
 				      tb[TCA_TUNNEL_KEY_NO_CSUM]);
 		tunnel_key_print_tos_ttl(f, "tos",
-- 
2.1.0

