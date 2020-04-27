Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B67B1BA118
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgD0K2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgD0K2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:32 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5068AC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:32 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c21so6026586plz.4
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=olpgY8dVdzd9SfDaKpdd6QG218jgqOl+DuD6TC24PL4=;
        b=CzH9o7/s10NWksVrkEgKl0A8yAhJMjcupkNcPZlS/kI+aqg6wk1qGYqAid++M4dFKL
         eqyy6f+QsQdvBPVIXtB7fQZUJUBOSTrWhKt7grP9fuUGC4JevcYM8Dko+2hBBkg7oTSF
         lOSaV0AT+ERgfqjK8JM2oTCGYNpNkPn4DXdi3m1VEgqKcEXleHuu4UglX3S8mt0hc1Dq
         777GqrImFoF3/yZmeyWw1442KW9iaGZFjUMbh84DmmKWNQrw333Axdn2HkB+wDklZVWE
         7fS8vxShoS4e7lBvKOG5wwpa5DdLD6/Sq/Yacbn9ttgbUDFVLp+fzh513bRU901nRjpX
         7Gxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=olpgY8dVdzd9SfDaKpdd6QG218jgqOl+DuD6TC24PL4=;
        b=N+M21fzx08FjZjb0vYg9QDAmq7vLqtZpRZD3YWeQvLAxZlt6iayBYWxB9Uuxb+3nUo
         KXSHbLnaFMfnM6/NLocXDYzgsqBZK03aM5fPUin2H0+D8pAiymk/wZvfy3TZ2fqhW1Og
         RuWZVNGMeCp201YHmwYxJ68Kt1VFMLmdQ9Hf7UxNNkJy/TEZs5wwrIm4KqFZX10dznAB
         hl4u/LeLkIkwWUvVVopff7xNnmXVdVanISE9nh5LCv/+lzWEu/u/QWGHINi4HxTGQDIk
         TeQDxVlkGKuYelWuVw+56GAKMWv2eqX1mRvrMq6WUwvSY0EgFsMZYHm9YFzPLxi+PpQI
         rFUQ==
X-Gm-Message-State: AGi0PubkyEky2e22A3posca4OMrRReaWnqhRMNx2rXiWmBh0S5tUdhKh
        c3p43P0XBHUSPfwY5x3xbp/eREsf
X-Google-Smtp-Source: APiQypLWjYPahN5ATmo96sspm6Wriapg7oIAJFIrJK/Lf3f1aSIX+PjGBRnV2zdV9lPEFx0kZ87HRQ==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr6836330plt.27.1587983311422;
        Mon, 27 Apr 2020 03:28:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p16sm10949664pjz.2.2020.04.27.03.28.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 4/7] tc: m_tunnel_key: add options support for vxlan
Date:   Mon, 27 Apr 2020 18:27:48 +0800
Message-Id: <916fda0179fa618e310a672314dc6091452b0d97.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4ae2ca59ac4262b19212a16ee7474189ae5eca72.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <4ae2ca59ac4262b19212a16ee7474189ae5eca72.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_TUNNEL_KEY_ENC_OPTS_VXLAN's parse and
print to implement vxlan options support in m_tunnel_key, like
Commit 6217917a3826 ("tc: m_tunnel_key: Add tunnel option support
to act_tunnel_key") for geneve options support.

Option is expressed a 32bit number for gbp only, and vxlan
doesn't support multiple options.

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
          vxlan_opts 65793 \
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
         vxlan_opts 65793
         ...

v1->v2:
  - get_u32 with base = 0 for gbp.
  - use to print_unint("0x%x") to print gbp.
v2->v3:
  - implement proper JSON array for opts.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print gbp as uint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-tunnel_key.8 | 10 +++++-
 tc/m_tunnel_key.c        | 84 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index 2145eb6..c208e2c 100644
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
+is specified in the form GBP, as a 32bit number. Multiple options is not
+supported.
+.TP
 .B tos
 Outer header TOS
 .TP
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 8fde689..11ec55d 100644
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
@@ -454,7 +497,27 @@ static void tunnel_key_print_geneve_options(const char *name,
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
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_ANY, "gdp", "%u", gbp);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+}
+
+static void tunnel_key_print_key_opt(struct rtattr *attr)
 {
 	struct rtattr *tb[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1];
 
@@ -462,8 +525,12 @@ static void tunnel_key_print_key_opt(const char *name, struct rtattr *attr)
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
@@ -519,8 +586,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
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

