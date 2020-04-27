Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D01BA125
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgD0K27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgD0K26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46734C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f7so8799621pfa.9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=kr4Urnjn1CjxS2jwfu9ArvRGJcwZXvIYuLiiU5AR44Q=;
        b=ffAXOJbb7QHGuDoG5B201YCKPkFfROneB8lfF1rRTq/lVUd5sj0srY52tRYFLql/DK
         fp3TuKw8Aaz8xBm5zffdC+1sHS6eTGr++vMau7Uv/46kxw0Vp/v9uxjnlgienU6laFEO
         NlXuuSzndivFacF2mgSQgw2ntaSWffXJQKUto8VJfRYlmPDknQf61Q3tYFS+4/iiE+jY
         jHc5Ak9DQTf/TCxRVqJNB8sfi5z3CUI7vjJ96fLuOBbFVkQ56J3G4pQAzhGgabI4gkVU
         D71esZ9rmxGHjYI/Lp6tyf1OIHQILKd6b5uG93sZIp5Cj5JAxRyx3MGGKEVv7sFfRXIG
         ny8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=kr4Urnjn1CjxS2jwfu9ArvRGJcwZXvIYuLiiU5AR44Q=;
        b=C9mc9ISqRciw4q1ICGTCYz+rOVhJKQ6l81bCO06wpBkIns/KAzQNDFYKQVcT9NXuMq
         7V/H1a1hdO22eCxPs448yvOo1lF8bot2eQSMlbE2j/7KZfZJkKvYhLImfM+RJe1T8RL+
         NmQVdpo3if4U0Rss0MeIBJaga7B1AAizqEDMyxBoPiMO2IPxqvFaKVhw0p9lkLrd8d3t
         iUb4OoonJPqdH+2g7NlR79NYtTsnWItdd6VGAYLsrIC7YPeRvlBHNO23mw1//l+FyK+F
         7Tza95ZtdaqhsFgrgINllqEcc6K0LKwOwJIsn0ZaM274lEx1xNxUOZbnaFrNWHaUaYgK
         ox6A==
X-Gm-Message-State: AGi0PuaZg4EKEZT/C+nYkvNJkRrXXc4CHqX4dnXCNnlMxhDzCfSxdqVK
        gpIA9sF2Q/b+ughOpZctSS+aCHDV
X-Google-Smtp-Source: APiQypLwxp3J4NSKqjoYFVY/2cahmPTFof7jXnTAIwo6K7BAHHci5D4QDwPBy/Wqz0UhCmVOKGn9SQ==
X-Received: by 2002:a62:2783:: with SMTP id n125mr24704959pfn.133.1587983337351;
        Mon, 27 Apr 2020 03:28:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm12115218pfc.194.2020.04.27.03.28.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 7/7] tc: f_flower: add options support for erspan
Date:   Mon, 27 Apr 2020 18:27:51 +0800
Message-Id: <7a76753305795e59f8214d5082f51bb687f52665.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <d5f9f1aac8452f2cf5b03b72c0226a39de33d88d.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
 <4ae2ca59ac4262b19212a16ee7474189ae5eca72.1587983178.git.lucien.xin@gmail.com>
 <916fda0179fa618e310a672314dc6091452b0d97.1587983178.git.lucien.xin@gmail.com>
 <0225abc4c546f25972bd31fcab52511c54f96ba1.1587983178.git.lucien.xin@gmail.com>
 <d5f9f1aac8452f2cf5b03b72c0226a39de33d88d.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add TCA_FLOWER_KEY_ENC_OPTS_ERSPAN's parse and
print to implement erspan options support in m_tunnel_key, like
Commit 56155d4df86d ("tc: f_flower: add geneve option match
support to flower") for geneve options support.

Option is expressed as version:index:dir:hwid, dir and hwid will
be parsed when version is 2, while index will be parsed when
version is 1. erspan doesn't support multiple options.

With this patch, users can add and dump erspan options like:

  # ip link add name erspan1 type erspan external
  # tc qdisc add dev erspan1 ingress
  # tc filter add dev erspan1 protocol ip parent ffff: \
      flower \
        enc_src_ip 10.0.99.192 \
        enc_dst_ip 10.0.99.193 \
        enc_key_id 11 \
        erspan_opts 1:2:0:0/1:255:0:0 \
        ip_proto udp \
        action mirred egress redirect dev eth1
  # tc -s filter show dev erspan1 parent ffff:

     filter protocol ip pref 49152 flower chain 0 handle 0x1
       eth_type ipv4
       ip_proto udp
       enc_dst_ip 10.0.99.193
       enc_src_ip 10.0.99.192
       enc_key_id 11
       erspan_opts 1:2:0:0/1:255:0:0
       not_in_hw
         action order 1: mirred (Egress Redirect to device eth1) stolen
         index 1 ref 1 bind 1
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0

v1->v2:
  - no change.
v2->v3:
  - no change.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print version, index, dir and hwid as uint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-flower.8 |  13 ++++
 tc/f_flower.c        | 171 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 184 insertions(+)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 3c7246b..b3dfcf6 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -85,6 +85,8 @@ flower \- flow based traffic control filter
 .B geneve_opts
 |
 .B vxlan_opts
+|
+.B erspan_opts
 }
 .IR OPTIONS " | "
 .BR ip_flags
@@ -332,6 +334,8 @@ Match the connection zone, and can be masked.
 .BI geneve_opts " OPTIONS"
 .TQ
 .BI vxlan_opts " OPTIONS"
+.TQ
+.BI erspan_opts " OPTIONS"
 Match on IP tunnel metadata. Key id
 .I NUMBER
 is a 32 bit tunnel key id (e.g. VNI for VXLAN tunnel).
@@ -358,6 +362,15 @@ doesn't support multiple options, and it consists of a key followed by a slash
 and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
 match. The option can be described in the form GBP/GBP_MASK, where GBP is
 represented as a 32bit number.
+erspan_opts
+.I OPTIONS
+doesn't support multiple options, and it consists of a key followed by a slash
+and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
+match. The option can be described in the form
+VERSION:INDEX:DIR:HWID/VERSION:INDEX_MASK:DIR_MASK:HWID_MASK, where VERSION is
+represented as a 8bit number, INDEX as an 32bit number, DIR and HWID as a 8bit
+number. Multiple options is not supported. Note INDEX/INDEX_MASK is used when
+VERSION is 1, and DIR/DIR_MASK and HWID/HWID_MASK are used when VERSION is 2.
 .TP
 .BI ip_flags " IP_FLAGS"
 .I IP_FLAGS
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 502d2ad..fc13691 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -82,6 +82,7 @@ static void explain(void)
 		"			enc_ttl MASKED-IP_TTL |\n"
 		"			geneve_opts MASKED-OPTIONS |\n"
 		"			vxlan_opts MASKED-OPTIONS |\n"
+		"                       erspan_opts MASKED-OPTIONS |\n"
 		"			ip_flags IP-FLAGS | \n"
 		"			enc_dst_port [ port_number ] |\n"
 		"			ct_state MASKED_CT_STATE |\n"
@@ -937,6 +938,84 @@ static int flower_parse_vxlan_opt(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_erspan_opt(char *str, struct nlmsghdr *n)
+{
+	struct rtattr *nest;
+	char *token;
+	int i, err;
+
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_FLOWER_KEY_ENC_OPTS_ERSPAN | NLA_F_NESTED);
+
+	i = 1;
+	token = strsep(&str, ":");
+	while (token) {
+		switch (i) {
+		case TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 0);
+			if (err)
+				return err;
+
+			addattr8(n, MAX_MSG, i, opt_type);
+			break;
+		}
+		case TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX:
+		{
+			__be32 opt_index;
+
+			if (!strlen(token))
+				break;
+			err = get_be32(&opt_index, token, 0);
+			if (err)
+				return err;
+
+			addattr32(n, MAX_MSG, i, opt_index);
+			break;
+		}
+		case TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 0);
+			if (err)
+				return err;
+
+			addattr8(n, MAX_MSG, i, opt_type);
+			break;
+		}
+		case TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 0);
+			if (err)
+				return err;
+
+			addattr8(n, MAX_MSG, i, opt_type);
+			break;
+		}
+		default:
+			fprintf(stderr, "Unknown \"geneve_opts\" type\n");
+			return -1;
+		}
+
+		token = strsep(&str, ":");
+		i++;
+	}
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
 static int flower_parse_geneve_opts(char *str, struct nlmsghdr *n)
 {
 	char *token;
@@ -1077,6 +1156,49 @@ static int flower_parse_enc_opts_vxlan(char *str, struct nlmsghdr *n)
 	return 0;
 }
 
+static int flower_parse_enc_opts_erspan(char *str, struct nlmsghdr *n)
+{
+	char key[XATTR_SIZE_MAX], mask[XATTR_SIZE_MAX];
+	struct rtattr *nest;
+	char *slash;
+	int err;
+
+
+	slash = strchr(str, '/');
+	if (slash) {
+		*slash++ = '\0';
+		if (strlen(slash) > XATTR_SIZE_MAX)
+			return -1;
+		strcpy(mask, slash);
+	} else {
+		int index;
+
+		slash = strchr(str, ':');
+		index = (int)(slash - str);
+		memcpy(mask, str, index);
+		strcpy(mask + index, ":0xffffffff:0xff:0xff");
+	}
+
+	if (strlen(str) > XATTR_SIZE_MAX)
+		return -1;
+	strcpy(key, str);
+
+	nest = addattr_nest(n, MAX_MSG, TCA_FLOWER_KEY_ENC_OPTS | NLA_F_NESTED);
+	err = flower_parse_erspan_opt(key, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	nest = addattr_nest(n, MAX_MSG,
+			    TCA_FLOWER_KEY_ENC_OPTS_MASK | NLA_F_NESTED);
+	err = flower_parse_erspan_opt(mask, n);
+	if (err)
+		return err;
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
 static int flower_parse_opt(struct filter_util *qu, char *handle,
 			    int argc, char **argv, struct nlmsghdr *n)
 {
@@ -1571,6 +1693,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"vxlan_opts\"\n");
 				return -1;
 			}
+		} else if (matches(*argv, "erspan_opts") == 0) {
+			NEXT_ARG();
+			ret = flower_parse_enc_opts_erspan(*argv, n);
+			if (ret < 0) {
+				fprintf(stderr, "Illegal \"erspan_opts\"\n");
+				return -1;
+			}
 		} else if (matches(*argv, "action") == 0) {
 			NEXT_ARG();
 			ret = parse_action(&argc, &argv, TCA_FLOWER_ACT, n);
@@ -2024,6 +2153,38 @@ static void flower_print_vxlan_opts(const char *name, struct rtattr *attr,
 	sprintf(strbuf, "%u", gbp);
 }
 
+static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
+				     char *strbuf)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	__u8 ver, hwid, dir;
+	__u32 idx;
+
+	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+	ver = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		idx = rta_getattr_be32(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]);
+		hwid = 0;
+		dir = 0;
+	} else {
+		idx = 0;
+		hwid = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]);
+		dir = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]);
+	}
+
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "ver", NULL, ver);
+	print_uint(PRINT_JSON, "index", NULL, idx);
+	print_uint(PRINT_JSON, "dir", NULL, dir);
+	print_uint(PRINT_JSON, "hwid", NULL, hwid);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+
+	sprintf(strbuf, "%u:%u:%u:%u", ver, idx, dir, hwid);
+}
+
 static void flower_print_enc_parts(const char *name, const char *namefrm,
 				   struct rtattr *attr, char *key, char *mask)
 {
@@ -2090,6 +2251,16 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 
 		flower_print_enc_parts(name, "  vxlan_opts %s", attr, key,
 				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]) {
+		flower_print_erspan_opts("erspan_opt_key",
+				key_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN], key);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN])
+			flower_print_erspan_opts("erspan_opt_mask",
+				msk_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN], msk);
+
+		flower_print_enc_parts(name, "  erspan_opts %s", attr, key,
+				       msk);
 	}
 
 	free(msk);
-- 
2.1.0

