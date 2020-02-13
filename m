Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4453315BE16
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgBML6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:58:11 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:43234 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:58:11 -0500
Received: by mail-pf1-f169.google.com with SMTP id s1so2965272pfh.10
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=phAVXulgufcGTwfCFBgNmXB80ECLWy0bymVDp5CjFnU=;
        b=WvCwwHRSPTURtMWSAkKnzoEZOtf0au9bPTxIHkdgWdpRb/n/coqcNixbcOAG6S8iR8
         ZEYl+x5H9zVH4DdO7BYJHTd/5EVq7eDYSr0b+Us3o0Cw27bCwp3a09KIz6lgRoI2/L+5
         FHXKkRmiPXmuI+Acq2drSSawCPp1/00tGyPWfXMsmcYOnRagPoMnQS68014NKlCPoY/G
         7MrhCsfg5faRsS8qTsWBIysB1oEfEXck2l62shHTrIt6JFq2QsxQVOg04PK7w0W0yUey
         HC8WBv4y3yJlYFwj8JeSAlUWqAmVOXzio3z/rx/q23o7bKCDjjOqGa1+tJs1Uf8/XSQb
         MVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=phAVXulgufcGTwfCFBgNmXB80ECLWy0bymVDp5CjFnU=;
        b=FnxTtuWnZAA8sLvoUzORhplZvRGFMR9AEN71Wb+T0iQ5xYwRB5H/hI3XXv4kbY8qmY
         7bD2jAgy+NogGcVOnp4Ctzd5rKY9csdPpLY6HM3gq/6GaRTEYfzs0IzG/mzjWJJHRxbU
         P8zKPCHlxsAlZ1yziw807XuyzZgS3ikvD8rK1qnRbs6LtpYtShtLrC2asZaNtqcelZGa
         2B8n9KBCEpvq/KMjhFAnnd1MxVDgGEfEXvleFIVMkwv4svLF8Igu4sCOoXdjxLNWevhq
         pxbv8tILoIOkk3pSj809pT45sDlhljwadOQnp6D/UsEyZukuVmE+Y5u/N/fYjvBH+f/6
         Z1qw==
X-Gm-Message-State: APjAAAXiAMKmwCnzZfOrsPkkysbDRMeRk7AiBDuJS7CbDGbgYtbAxeoZ
        n13gHjtetoOE4fHUUxmtiFOhdMKd
X-Google-Smtp-Source: APXvYqx+qF800JTizDpZilyjKpQppxpX3JRYLqis6MRfutSxO3YKedmYHG4nZE2fcIwgt2l3gbFlFg==
X-Received: by 2002:a63:c748:: with SMTP id v8mr17551490pgg.143.1581595090179;
        Thu, 13 Feb 2020 03:58:10 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s7sm2745969pjk.22.2020.02.13.03.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:58:09 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 7/7] tc: f_flower: add options support for erspan
Date:   Thu, 13 Feb 2020 19:57:05 +0800
Message-Id: <469892597d143250a75a8477980e3aeb3dc4ffd8.1581594682.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fa80f0f8f11e44294f09a93dcb060674e7c481c6.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
 <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
 <0bf376a8304996ec0edf0b14111a2c924a44b5ff.1581594682.git.lucien.xin@gmail.com>
 <f34d6f4b5002bba1433958b73e193843d1b06d86.1581594682.git.lucien.xin@gmail.com>
 <3d2f2000500740cb43fad910253ae5bf1424c776.1581594682.git.lucien.xin@gmail.com>
 <ba3793a7720825210dbd0678c844b173765021cc.1581594682.git.lucien.xin@gmail.com>
 <fa80f0f8f11e44294f09a93dcb060674e7c481c6.1581594682.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
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
       erspan_opt 01:00000002:00:00/01:ffffffff:00:00
       not_in_hw
         action order 1: mirred (Egress Redirect to device eth1) stolen
         index 1 ref 1 bind 1
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0

v1->v2:
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
index 89c89d4..1d29850 100644
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
@@ -2023,6 +2152,38 @@ static void flower_print_vxlan_opts(const char *name, struct rtattr *attr,
 	close_json_array(PRINT_JSON, name);
 }
 
+static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
+				     char *strbuf)
+{
+	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX + 1];
+	__u8 ver, hwid, dir;
+	__u32 idx;
+
+	open_json_array(PRINT_JSON, name);
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
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "ver", NULL, ver);
+	print_uint(PRINT_JSON, "index", NULL, idx);
+	print_uint(PRINT_JSON, "dir", NULL, dir);
+	print_uint(PRINT_JSON, "hwid", NULL, hwid);
+	close_json_object();
+
+	sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
+	close_json_array(PRINT_JSON, name);
+}
+
 static void flower_print_enc_parts(const char *name, const char *namefrm,
 				   struct rtattr *attr, char *key, char *mask)
 {
@@ -2089,6 +2250,16 @@ static void flower_print_enc_opts(const char *name, struct rtattr *attr,
 
 		flower_print_enc_parts(name, "  vxlan_opt %s", attr, key,
 				       msk);
+	} else if (key_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN]) {
+		flower_print_erspan_opts("erspan_opt_key",
+				key_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN], key);
+
+		if (msk_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN])
+			flower_print_erspan_opts("erspan_opt_mask",
+				msk_tb[TCA_FLOWER_KEY_ENC_OPTS_ERSPAN], msk);
+
+		flower_print_enc_parts(name, "\n  erspan_opt %s", attr, key,
+				       msk);
 	}
 
 	free(msk);
-- 
2.1.0

