Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944701BA124
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgD0K2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727052AbgD0K2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A947BC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a5so7352730pjh.2
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qNwXATOGhDdeS1/rXcA9jaTl6hRhMICFL7kaZIXB6hs=;
        b=T/Ik5we4WIHx0dor53RPM/Cy5F2uMgn5P0qfAv96gMNPETugQpduPkbfJUpCrnIO8J
         qiTcC9pZ4jj90KCguodgIspp0a8kRxoC/7DTylbso9uxixTbLExMwa4VlYQxkANdiUCQ
         7za0wXxtLexRYIRqkUJ0qq0M/py6zq8fY0uTsJtxJqWxcRu1B7cSdoulFb/IFqV4jIEH
         L07JQ3Lfvo3ASvccMAW7E/D+eN0/zlT4dtwUYYDLGIEBxk0I2B7o+vjlLU9InbSNsW+Q
         7JjxC+XfgBe9Qy45OSC5CezyVhbSxZb2awwB8/N5y0oYo7j5ozST2CFJIgREl0J/3csd
         EeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qNwXATOGhDdeS1/rXcA9jaTl6hRhMICFL7kaZIXB6hs=;
        b=bxBKgIthdWWMGvb+IgNO7naMY02r8MIfUk1ULZ3R69TAoclJE6dlOi+Joddt+K64Wr
         EmTdXrmmkqG9tDbOFhBV8kltM88oTwGYa+rx115IZGo10Wa5HJfi7v5KZAcCL1l2rELY
         xa3fmFZb2NCls9J8p6ifsuJfGugZR0vMIGf/vFqxTeCP7QQArZO/4ztmehbByaVU+waZ
         g/6SZuH3ECkMZINacH75AUBRaPyM2u/gwhOsKzWY4UT/3sHN26QzE2Wn+sQU1sX2p1NG
         tv9/hsqoKmHNIAyYeaF45dTtksj5hrzG78zrrD+afN68Gh7fvMkS9wA6eqb6T1+X/6j2
         yJtg==
X-Gm-Message-State: AGi0Puaf3JMKAHdvV1ZTixh2mukfJg0Btb1oI9/AQXwLjorv26fPuFwX
        Min42v+t6OoKycW1am5NYzFc2qxh
X-Google-Smtp-Source: APiQypJHOxmjLw/Oi7IhM5JHstVECYhK03lt+aP+dzDwpfwZ1Jz9NEIVU8RRgvsDufJ2BoLVTB6VFA==
X-Received: by 2002:a17:90a:3a81:: with SMTP id b1mr22464877pjc.184.1587983328798;
        Mon, 27 Apr 2020 03:28:48 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm10986410pjr.17.2020.04.27.03.28.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:48 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 6/7] tc: f_flower: add options support for vxlan
Date:   Mon, 27 Apr 2020 18:27:50 +0800
Message-Id: <d5f9f1aac8452f2cf5b03b72c0226a39de33d88d.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0225abc4c546f25972bd31fcab52511c54f96ba1.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <4ae2ca59ac4262b19212a16ee7474189ae5eca72.1587983178.git.lucien.xin@gmail.com>
 <916fda0179fa618e310a672314dc6091452b0d97.1587983178.git.lucien.xin@gmail.com>
 <0225abc4c546f25972bd31fcab52511c54f96ba1.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_FLOWER_KEY_ENC_OPTS_VXLAN's parse and
print to implement vxlan options support in m_tunnel_key, like
Commit 56155d4df86d ("tc: f_flower: add geneve option match
support to flower") for geneve options support.

Option is expressed a 32bit number for gbp only, and vxlan
doesn't support multiple options.

With this patch, users can add and dump vxlan options like:

  # ip link add name vxlan1 type vxlan dstport 0 external
  # tc qdisc add dev vxlan1 ingress
  # tc filter add dev vxlan1 protocol ip parent ffff: \
      flower \
        enc_src_ip 10.0.99.192 \
        enc_dst_ip 10.0.99.193 \
        enc_key_id 11 \
        vxlan_opts 65793/4008635966 \
        ip_proto udp \
        action mirred egress redirect dev eth1
  # tc -s filter show dev vxlan1 parent ffff:

     filter protocol ip pref 49152 flower chain 0 handle 0x1
       eth_type ipv4
       ip_proto udp
       enc_dst_ip 10.0.99.193
       enc_src_ip 10.0.99.192
       enc_key_id 11
       vxlan_opts 65793/4008635966
       not_in_hw
         action order 1: mirred (Egress Redirect to device eth1) stolen
         index 3 ref 1 bind 1
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0

v1->v2:
  - get_u32 with base = 0 for gbp.
v2->v3:
  - implement proper JSON array for opts.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print gbp as uint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-flower.8 |  12 +++++
 tc/f_flower.c        | 130 ++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 126 insertions(+), 16 deletions(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index eb9eb5f..3c7246b 100644
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
+represented as a 32bit number.
 .TP
 .BI ip_flags " IP_FLAGS"
 .I IP_FLAGS
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 9d59d71..502d2ad 100644
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
+		strcpy(mask, "0xffffffff");
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
@@ -1940,10 +2004,29 @@ static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
 	close_json_array(PRINT_JSON, name);
 }
 
-static void flower_print_geneve_parts(const char *name, struct rtattr *attr,
-				      char *key, char *mask)
+static void flower_print_vxlan_opts(const char *name, struct rtattr *attr,
+				    char *strbuf)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	__u32 gbp;
+
+	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX, i, rem);
+	gbp = rta_getattr_u32(tb[TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP]);
+
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "gbp", NULL, gbp);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+
+	sprintf(strbuf, "%u", gbp);
+}
+
+static void flower_print_enc_parts(const char *name, const char *namefrm,
+				   struct rtattr *attr, char *key, char *mask)
 {
-	char *namefrm = "  geneve_opt %s";
 	char *key_token, *mask_token, *out;
 	int len;
 
@@ -1985,14 +2068,29 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
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
+		flower_print_enc_parts(name, "  geneve_opts %s", attr, key,
+				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN]) {
+		flower_print_vxlan_opts("vxlan_opt_key",
+				key_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN], key);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN])
+			flower_print_vxlan_opts("vxlan_opt_mask",
+				msk_tb[TCA_FLOWER_KEY_ENC_OPTS_VXLAN], msk);
+
+		flower_print_enc_parts(name, "  vxlan_opts %s", attr, key,
+				       msk);
+	}
 
 	free(msk);
 err_key_free:
-- 
2.1.0

