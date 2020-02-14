Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433B715D5C6
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgBNKbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:32 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:36680 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbgBNKbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:32 -0500
Received: by mail-pl1-f175.google.com with SMTP id a6so3591121plm.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=sBhHfPqYkd4KWfTysjyQAugFXeDuWhgjyoLnJhRES1I=;
        b=pHxC8rREWHmN5IiDhCJdXF1ygCazAI6EIBOzsK3I8qUFmjpFWB9vZACCb9GtZ4AWze
         rlAXRgq81lvDpk1HToC8nIIfPQBw7J0SuJhoUircVxE/jYRYqMVCGnzi32HpINx9h2lM
         Pc+xvxaazGpNLGNxhNrbj3cnvLa+oGgEvHKgtlaK8zBbQuneGTAU/7NOopIPINwDsOLd
         MIURG0lCjQahK+15V2cJjtKmqvHjCfhbyVo6L80lcqy3eqbIpkRc9sJsB3A83HFK4BzH
         JUOwPakJlapK5waD9DbRj03n4UqndsjICbpLxuEg7kLBsBKTDKfFW18V6y0TkmabrLFS
         t+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=sBhHfPqYkd4KWfTysjyQAugFXeDuWhgjyoLnJhRES1I=;
        b=qOKdIho+kIZ7rk4Ta+JdPzIIloNWJlrhNX6xvsQN9oN8W0gYG/PlgtdoMeouJBSvhp
         A8rV61oXYW8NGrrcD7nhasJeuJ8/wmImYCbz/OpcA8lnUA0ar3FGI9uiwvEoILG3EdpC
         mb/qmXzX96Io75PAMz2GZluYcK4VzGcFVKTIwbOyqUkUNdeRXu0p1CBabp62LdIHm4c6
         gi+ZVygL1hvnT7F0o8Z1G9H9o4xtWcLpb394NXt4e7J+TV6U6sVW7qIC/gXCGM+FXh4W
         EeHe9gfke2ahjxyOwSDVjutS5maI006aSQ5K2qQ+jYSoVRE4x6WkNagFv5mnKIuwzHK6
         TINw==
X-Gm-Message-State: APjAAAVuDmmcPPFPoQDFG71Wz3ad27SXltgfpcu2EJ7yqe2VKs28jBmM
        V+wnyrjxS1me9xTCTEFtml5fxYe9
X-Google-Smtp-Source: APXvYqz3iOY2+QXLgdlYVts0nwEfi0AzoJCtUb7tRRvc9Uw4Zia9JULJ9oMclZAxPbzJiHqysWLbIw==
X-Received: by 2002:a17:90a:8902:: with SMTP id u2mr2758071pjn.79.1581676291286;
        Fri, 14 Feb 2020 02:31:31 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm6281434pff.143.2020.02.14.02.31.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:30 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 4/7] tc: m_tunnel_key: add options support for vxlan
Date:   Fri, 14 Feb 2020 18:30:48 +0800
Message-Id: <2aadee844eb02bd2dd3254f75ff4a008e9f6e294.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
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
          vxlan_opts 0x10101 \
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
         vxlan_opts 0x10101
         ...

v1->v2:
  - get_u32 with base = 0 for gbp.
  - use to print_unint("0x%x") to print gbp.
v2->v3:
  - implement proper JSON array for opts.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-tunnel_key.8 | 10 +++++-
 tc/m_tunnel_key.c        | 86 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 86 insertions(+), 10 deletions(-)

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
index 8fde689..e9c2a5a 100644
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
+	ret = tunnel_key_parse_u32(str, 0,
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
@@ -454,7 +497,29 @@ static void tunnel_key_print_geneve_options(const char *name,
 	close_json_array(PRINT_JSON, name);
 }
 
-static void tunnel_key_print_key_opt(const char *name, struct rtattr *attr)
+static void tunnel_key_print_vxlan_options(struct rtattr *attr)
+{
+	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "vxlan_opts";
+	__u32 gbp;
+
+	parse_rtattr(tb, TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX, i, rem);
+	gbp = rta_getattr_u32(tb[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]);
+
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "gbp", NULL, gbp);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	print_uint(PRINT_FP, NULL, "0x%x", gbp);
+}
+
+static void tunnel_key_print_key_opt(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1];
 
@@ -462,8 +527,12 @@ static void tunnel_key_print_key_opt(const char *name, struct rtattr *attr)
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
@@ -519,8 +588,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
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

