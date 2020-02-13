Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E1B15BE15
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgBML6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:58:03 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:38326 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:58:03 -0500
Received: by mail-pl1-f170.google.com with SMTP id t6so2265646plj.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=QurmJ2I2hSZ/BHGKiJT/hb2+hKbE/42XEilQI0WW2yE=;
        b=BNVbpCCmIjMp7fZSTbRP0/iIffXTptzf5ls0ya0JFH5GsDek7SjKMaGv070FONAosL
         DZYOZZwUIO4DdtbQjaDMZnY1hHP7lAsS1B5lC101ihJzjXP9vAd6C+EnjtUKOmSlRoiP
         0tBleG7QMXGZKSNQ+c9SvCF75kcW9p0Qi2Mu4JKr3wL12E548FII8PnfwkIn5sYAF9IM
         WgYHk1FxVyp15DSEAm/NhmCO1ZJLDdSX/prbyQUGxnOGJAG24+0AM3OeLKIXByVsZxOt
         FbuqosOCxiQEV+yZwSbh+56FyYIjWbu6Zn2nA9+P2msbLht2eVYodH5iqVtqCbw2T7+z
         IlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=QurmJ2I2hSZ/BHGKiJT/hb2+hKbE/42XEilQI0WW2yE=;
        b=IVav6NOW02/Wwa7vVGZvaXGTGHg2ScoIZi5v6SIdvgn5My1oQ9NGedYmafNHjPTx2A
         VAfDDapSKP6TucdQXR6XHrcdt9J3zS7iA7VpFU0pBeoGmdWdq/4YVh8I8C/skrghl6X6
         HJ9JhWpJ4o5WseMmubKg/eLHGaIVRG7Y4kNKRS0H4eY+0/y2NY7Btqp7nlstrlIlRAJF
         RXDXmhd/fANLfGDl00ZgAiDZcAjAvm8XbDO63iAihbl0FrkPXBqfDm6hKo9L4KTE/DF6
         OPrxXVUGpyeLv210Xb2gSHEM4aRmnEJ/7oul71MXvGKfA3ps+Xu3gXQQVSD2faMbKonU
         l7nA==
X-Gm-Message-State: APjAAAW/84J4Uq/QyXNVrxsmBcThnQ8wvN1+oUWpLBb3xojss0JnFAHR
        gZ/J2yC9oFQE44yqCufLa9kKxEsP
X-Google-Smtp-Source: APXvYqwzJmYRsAL6/kabnLGgd0qG1lFmELLAnAKCN/EWxCn0cH2aSjiGXl3MrLmhTeDhCX8ZY26D0Q==
X-Received: by 2002:a17:902:bd88:: with SMTP id q8mr26765124pls.13.1581595081818;
        Thu, 13 Feb 2020 03:58:01 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a69sm2983746pfa.129.2020.02.13.03.58.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:58:01 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 6/7] tc: f_flower: add options support for vxlan
Date:   Thu, 13 Feb 2020 19:57:04 +0800
Message-Id: <fa80f0f8f11e44294f09a93dcb060674e7c481c6.1581594682.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ba3793a7720825210dbd0678c844b173765021cc.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
 <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
 <0bf376a8304996ec0edf0b14111a2c924a44b5ff.1581594682.git.lucien.xin@gmail.com>
 <f34d6f4b5002bba1433958b73e193843d1b06d86.1581594682.git.lucien.xin@gmail.com>
 <3d2f2000500740cb43fad910253ae5bf1424c776.1581594682.git.lucien.xin@gmail.com>
 <ba3793a7720825210dbd0678c844b173765021cc.1581594682.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_FLOWER_KEY_ENC_OPTS_VXLAN's parse and
print to implement vxlan options support in m_tunnel_key, like
Commit 56155d4df86d ("tc: f_flower: add geneve option match
support to flower") for geneve options support.

Option is expressed a 32bit hexadecimal value for gbp only, and
vxlan doesn't support multiple options.

With this patch, users can add and dump vxlan options like:

  # ip link add name vxlan1 type vxlan dstport 0 external
  # tc qdisc add dev vxlan1 ingress
  # tc filter add dev vxlan1 protocol ip parent ffff: \
      flower \
        enc_src_ip 10.0.99.192 \
        enc_dst_ip 10.0.99.193 \
        enc_key_id 11 \
        vxlan_opts 0x10101/0xeeeeee3e \
        ip_proto udp \
        action mirred egress redirect dev eth1
  # tc -s filter show dev vxlan1 parent ffff:

     filter protocol ip pref 49152 flower chain 0 handle 0x1
       eth_type ipv4
       ip_proto udp
       enc_dst_ip 10.0.99.193
       enc_src_ip 10.0.99.192
       enc_key_id 11
       vxlan_opt 0x10101/0xeeeeee3e
       not_in_hw
         action order 1: mirred (Egress Redirect to device eth1) stolen
         index 3 ref 1 bind 1
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0

v1->v2:
  - get_u32 with base = 0 for gbp.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-flower.8 |  12 +++++
 tc/f_flower.c        | 129 ++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index eb9eb5f..819932d 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -81,7 +81,11 @@ flower \- flow based traffic control filter
 .IR TOS " | "
 .B enc_ttl
 .IR TTL " | "
+{
 .B geneve_opts
+|
+.B vxlan_opts
+}
 .IR OPTIONS " | "
 .BR ip_flags
 .IR IP_FLAGS
@@ -326,6 +330,8 @@ Match the connection zone, and can be masked.
 .RE
 .TP
 .BI geneve_opts " OPTIONS"
+.TQ
+.BI vxlan_opts " OPTIONS"
 Match on IP tunnel metadata. Key id
 .I NUMBER
 is a 32 bit tunnel key id (e.g. VNI for VXLAN tunnel).
@@ -346,6 +352,12 @@ the masks is missing, \fBtc\fR assumes a full-length match. The options can
 be described in the form CLASS:TYPE:DATA/CLASS_MASK:TYPE_MASK:DATA_MASK,
 where CLASS is represented as a 16bit hexadecimal value, TYPE as an 8bit
 hexadecimal value and DATA as a variable length hexadecimal value.
+vxlan_opts
+.I OPTIONS
+doesn't support multiple options, and it consists of a key followed by a slash
+and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
+match. The option can be described in the form GBP/GBP_MASK, where GBP is
+represented as a 32bit hexadecimal value.
 .TP
 .BI ip_flags " IP_FLAGS"
 .I IP_FLAGS
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 9d59d71..89c89d4 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -81,6 +81,7 @@ static void explain(void)
 		"			enc_tos MASKED-IP_TOS |\n"
 		"			enc_ttl MASKED-IP_TTL |\n"
 		"			geneve_opts MASKED-OPTIONS |\n"
+		"			vxlan_opts MASKED-OPTIONS |\n"
 		"			ip_flags IP-FLAGS | \n"
 		"			enc_dst_port [ port_number ] |\n"
 		"			ct_state MASKED_CT_STATE |\n"
@@ -847,7 +848,7 @@ static int flower_parse_enc_port(char *str, int type, struct nlmsghdr *n)
 	return 0;
 }
 
-static int flower_parse_geneve_opts(char *str, struct nlmsghdr *n)
+static int flower_parse_geneve_opt(char *str, struct nlmsghdr *n)
 {
 	struct rtattr *nest;
 	char *token;
@@ -917,14 +918,33 @@ static int flower_parse_geneve_opts(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
-static int flower_parse_enc_opt_part(char *str, struct nlmsghdr *n)
+static int flower_parse_vxlan_opt(char *str, struct nlmsghdr *n)
+{
+	struct rtattr *nest;
+	__u32 gbp;
+	int err;
+
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_FLOWER_KEY_ENC_OPTS_VXLAN | NLA_F_NESTED);
+
+	err = get_u32(&gbp, str, 0);
+	if (err)
+		return err;
+	addattr32(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP, gbp);
+
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
+static int flower_parse_geneve_opts(char *str, struct nlmsghdr *n)
 {
 	char *token;
 	int err;
 
 	token = strsep(&str, ",");
 	while (token) {
-		err = flower_parse_geneve_opts(token, n);
+		err = flower_parse_geneve_opt(token, n);
 		if (err)
 			return err;
 
@@ -954,7 +974,7 @@ static int flower_check_enc_opt_key(char *key)
 	return 0;
 }
 
-static int flower_parse_enc_opts(char *str, struct nlmsghdr *n)
+static int flower_parse_enc_opts_geneve(char *str, struct nlmsghdr *n)
 {
 	char key[XATTR_SIZE_MAX], mask[XATTR_SIZE_MAX];
 	int data_len, key_len, mask_len, err;
@@ -1006,13 +1026,50 @@ static int flower_parse_enc_opts(char *str, struct nlmsghdr *n)
 	mask[mask_len - 1] = '\0';
 
 	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS);
-	err = flower_parse_enc_opt_part(key, n);
+	err = flower_parse_geneve_opts(key, n);
 	if (err)
 		return err;
 	addattr_nest_end(n, nest);
 
 	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS_MASK);
-	err = flower_parse_enc_opt_part(mask, n);
+	err = flower_parse_geneve_opts(mask, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
+static int flower_parse_enc_opts_vxlan(char *str, struct nlmsghdr *n)
+{
+	char key[XATTR_SIZE_MAX], mask[XATTR_SIZE_MAX];
+	struct rtattr *nest;
+	char *slash;
+	int err;
+
+	slash = strchr(str, '/');
+	if (slash) {
+		*slash++ = '\0';
+		if (strlen(slash) > XATTR_SIZE_MAX)
+			return -1;
+		strcpy(mask, slash);
+	} else {
+		strcpy(mask, "ffffffff");
+	}
+
+	if (strlen(str) > XATTR_SIZE_MAX)
+		return -1;
+	strcpy(key, str);
+
+	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS | NLA_F_NESTED);
+	err = flower_parse_vxlan_opt(str, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_FLOWER_KEY_ENC_OPTS_MASK | NLA_F_NESTED);
+	err = flower_parse_vxlan_opt(mask, n);
 	if (err)
 		return err;
 	addattr_nest_end(n, nest);
@@ -1502,11 +1559,18 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "geneve_opts") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_enc_opts(*argv, n);
+			ret = flower_parse_enc_opts_geneve(*argv, n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"geneve_opts\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "vxlan_opts") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_enc_opts_vxlan(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"vxlan_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "action") == 0) {
 			NEXT_ARG();
 			ret = parse_action(&argc, &argv, TCA_FLOWER_ACT, n);
@@ -1940,10 +2004,28 @@ static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
 	close_json_array(PRINT_JSON, name);
 }
 
-static void flower_print_geneve_parts(const char *name, struct rtattr *attr,
-				      char *key, char *mask)
+static void flower_print_vxlan_opts(const char *name, struct rtattr *attr,
+				    char *strbuf)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
+	__u32 gbp;
+
+	open_json_array(PRINT_JSON, name);
+	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX, RTA_DATA(attr),
+			RTA_PAYLOAD(attr));
+	gbp = rta_getattr_u32(tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]);
+
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "gbp", NULL, gbp);
+	close_json_object();
+
+	sprintf(strbuf, "0x%x", gbp);
+	close_json_array(PRINT_JSON, name);
+}
+
+static void flower_print_enc_parts(const char *name, const char *namefrm,
+				   struct rtattr *attr, char *key, char *mask)
 {
-	char *namefrm = "  geneve_opt %s";
 	char *key_token, *mask_token, *out;
 	int len;
 
@@ -1985,14 +2067,29 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 		goto err_key_free;
 
 	parse_rtattr_nested(key_tb, TCA_FLOWER_KEY_ENC_OPTS_MAX, attr);
-	flower_print_geneve_opts("geneve_opt_key",
-				 key_tb[TCA_FLOWER_KEY_ENC_OPTS_GENEVE], key);
-
 	parse_rtattr_nested(msk_tb, TCA_FLOWER_KEY_ENC_OPTS_MAX, mask_attr);
-	flower_print_geneve_opts("geneve_opt_mask",
-				 msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GENEVE], msk);
 
-	flower_print_geneve_parts(name, attr, key, msk);
+	if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_GENEVE]) {
+		flower_print_geneve_opts("geneve_opt_key",
+				key_tb[TCA_FLOWER_KEY_ENC_OPTS_GENEVE], key);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GENEVE])
+			flower_print_geneve_opts("geneve_opt_mask",
+				msk_tb[TCA_FLOWER_KEY_ENC_OPTS_GENEVE], msk);
+
+		flower_print_enc_parts(name, "  geneve_opt %s", attr, key,
+				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]) {
+		flower_print_vxlan_opts("vxlan_opt_key",
+				key_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN], key);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN])
+			flower_print_vxlan_opts("vxlan_opt_mask",
+				msk_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN], msk);
+
+		flower_print_enc_parts(name, "  vxlan_opt %s", attr, key,
+				       msk);
+	}
 
 	free(msk);
 err_key_free:
-- 
2.1.0

