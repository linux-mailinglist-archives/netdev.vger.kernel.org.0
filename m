Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048B615D5D0
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgBNKb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:58 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:43855 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgBNKb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:58 -0500
Received: by mail-pl1-f180.google.com with SMTP id p11so3574029plq.10
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ahd5djx9rzPzfZYLdQnyONnAdUODePpkv8yiReyBUK0=;
        b=TZ7IcS8E+4r4UFnCym0zYyQt7CoCoNWtA0gAiQtf9bwLJvdsF0zgSMLeguFMd5p1kx
         GAVxBrW+5bJooFhhPR+8a2FUDTqi6+vvAEk+c/bRaTTu9wFbjpUAlpJDZZjjkJuE0C9p
         iuAIvIKgLYtwI+FiV2FXfRXo2/41Kq9JfdyDVfz9EvF/P8En265L8skIz1AajN6CputT
         N8rpkoylQMmAIf0mQbVG4L1+tJGrJeR4350VR3YMnW/yTSidlVx+J4KD+NqtCad95JaS
         GuzBt0qm+YS8mLaE5Q3rSDWht24mpBdOMzvJEorgRaf5R4Ij9+WPCCwchaaRIm6qB/zl
         UYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ahd5djx9rzPzfZYLdQnyONnAdUODePpkv8yiReyBUK0=;
        b=A3ofscUAkk7PzWxQGprfW9kgGxaQU2yrfmaWuSvydBTy52ZmwJHaJvaZPzO6axOK9q
         iOW5ndxICagEhtXX/kdUHVDsybLOKzMVCZA2LPldAoPxLHt/w56/NpqrxWM5WMSflJf7
         EhLpgPvf2pIa1/xxjtI02HQrTTDPtlg38AD37DVcuw+UkVwvCodxGqMz971WiKyzeVdD
         glqLcPXjNUzPR7j6pv80eRyeQwkwGR+w/D9E/G4qaOmOxVMDPjOlXeMo/bAP4J9XpxRt
         xif78xhSMTkkULC3qWGIRl2VPFvvN+5au+uOHttf24/+VoATpA/GqyvhHPuPQWePJ5wc
         QHwA==
X-Gm-Message-State: APjAAAWnJ9GCWXbBwQBd6XhQKO2Gh0gcFF2x2XQH7e9Rw8jl45jd5Dcj
        VJhcvV4aHhC+7TLa5NBkNGSBjQE2
X-Google-Smtp-Source: APXvYqxYPXV7dksScQW3x+MiCeowNf62Vwxxy/TJIXrC5iFt5I7u5Cya5313LkEux092mkRgwDmaFg==
X-Received: by 2002:a17:902:b909:: with SMTP id bf9mr2561373plb.96.1581676316799;
        Fri, 14 Feb 2020 02:31:56 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g22sm6409472pgk.85.2020.02.14.02.31.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:56 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 7/7] tc: f_flower: add options support for erspan
Date:   Fri, 14 Feb 2020 18:30:51 +0800
Message-Id: <5669edb0bf7edc2b0f29a23db2916e7e9bcd51c7.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <971135c3d60f2a40ed0b9e98850912be2f61c33a.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <2aadee844eb02bd2dd3254f75ff4a008e9f6e294.1581676056.git.lucien.xin@gmail.com>
 <0f971b9706f02adefbd2c6a4495d1ffc8c44310d.1581676056.git.lucien.xin@gmail.com>
 <971135c3d60f2a40ed0b9e98850912be2f61c33a.1581676056.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
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
        erspan_opts 1:2:0:0/01:ffffffff:00:00 \
        ip_proto udp \
        action mirred egress redirect dev eth1
  # tc -s filter show dev erspan1 parent ffff:

     filter protocol ip pref 49152 flower chain 0 handle 0x1
       eth_type ipv4
       ip_proto udp
       enc_dst_ip 10.0.99.193
       enc_src_ip 10.0.99.192
       enc_key_id 11
       erspan_opts 01:00000002:00:00/01:ffffffff:00:00
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/tc-flower.8 |  14 +++++
 tc/f_flower.c        | 171 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 185 insertions(+)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 819932d..5e678ba 100644
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
@@ -358,6 +362,16 @@ doesn't support multiple options, and it consists of a key followed by a slash
 and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
 match. The option can be described in the form GBP/GBP_MASK, where GBP is
 represented as a 32bit hexadecimal value.
+erspan_opts
+.I OPTIONS
+doesn't support multiple options, and it consists of a key followed by a slash
+and corresponding mask. If the mask is missing, \fBtc\fR assumes a full-length
+match. The option can be described in the form
+VERSION:INDEX:DIR:HWID/VERSION:INDEX_MASK:DIR_MASK:HWID_MASK, where VERSION is
+represented as a 8bit hexadecimal value, INDEX as an 32bit hexadecimal value,
+DIR and HWID as a 8bit hexadecimal value. Multiple options is not supported.
+Note INDEX/INDEX_MASK is used when VERSION is 1, and DIR/DIR_MASK and
+HWID/HWID_MASK are used when VERSION is 2.
 .TP
 .BI ip_flags " IP_FLAGS"
 .I IP_FLAGS
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 8b195c5..1281479 100644
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
+			err = get_u8(&opt_type, token, 16);
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
+			err = get_be32(&opt_index, token, 16);
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
+			err = get_u8(&opt_type, token, 16);
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
+			err = get_u8(&opt_type, token, 16);
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
+		strcpy(mask + index, ":ffffffff:ff:ff");
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
 	sprintf(strbuf, "%#x", gbp);
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
+	sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
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

