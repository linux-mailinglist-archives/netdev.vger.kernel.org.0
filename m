Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158A11BA110
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgD0K2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgD0K2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1AEC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fu13so6683101pjb.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HGmAurgiw7FOggcadAdXMkYsyzuikCAgMNna3+Rzf6o=;
        b=WGakBinn5W8o5UvaSrF7PCZz5kY8bexnfe+mS/mHF28Tcb44Q4ujuS2Tts4x79BZYy
         hWm5rJOwmDCFgifQCzZgBKGhPGlZHEt6zXfir8x2k3/hY7rWKpIESeT7kLw4ybVs6uyE
         c3mMyJzOw4r5kXz38pbequIzdcge8lvUewU4dseqO/9koCW67XGYw86zA2ThKDOEMcTx
         zhImmysstl6CR2QUAKJ6TNtWa3nBfdLm0H0YL0FnnYmloqbcMdwYhb6Kgl5T+prCXXb0
         znhAgSRjMtgObce8i4sH6NNn6EXyPA4hQllvjapH3se/GJxcShMYxrpCSmSjIChwW+Fc
         pztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HGmAurgiw7FOggcadAdXMkYsyzuikCAgMNna3+Rzf6o=;
        b=tqTSD0cIhda93xe3lhDj5IzID447WKjI61s+r35XS7CtqgguiibW0/xtSRG/BoQKZ4
         ciFfwmGQt4W1Vf4zCPmJ9ovoxAzuo/tjPScaWz3wOzunxpUSuCJDUTGnTrjQl8w3qpXJ
         /NfBEotR2KIuuzOf/jRuErNGEW1Gth1liI0k5RtfBxXVWjufhZSZybBzT/X8K/Pja/EE
         5O6dcfw5PREqZhGd29RIpjbUI2QFmsw4HX5Vo65iYIIc0ZkXgeWnLeAtA1KPafUV3OZ6
         9Vqsc4M72nlCXSlEvFQgpVls4iFr8asa3EZZn37+n4JR9EzD16fKtgITtUE4bycSGf1W
         3PSw==
X-Gm-Message-State: AGi0PuafnCAAqLtHz3UoEx+rTK4GttTuBcEqDObdtW1a0TTsCqsNqsB2
        ylrE1iPR95BY0J/MxykLRsDZmTEo
X-Google-Smtp-Source: APiQypLSyjkyNT43VfVf6jzzdkjKSVOtGe2R6UA3KgNuUoN2lRHqVAJRP2ILfnfy2tBqVkxRgL361A==
X-Received: by 2002:a17:90a:23e2:: with SMTP id g89mr23078791pje.105.1587983289043;
        Mon, 27 Apr 2020 03:28:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j7sm3053829pfi.160.2020.04.27.03.28.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:08 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 1/7] iproute_lwtunnel: add options support for geneve metadata
Date:   Mon, 27 Apr 2020 18:27:45 +0800
Message-Id: <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP(6)_OPTS and LWTUNNEL_IP_OPTS_GENEVE's
parse and print to implement geneve options support in iproute_lwtunnel.

Options are expressed as class:type:data and multiple options may be
listed using a comma delimiter, class and type are numbers and data
is a hex string.

With this patch, users can add and dump geneve options like:

  # ip netns add a
  # ip netns add b
  # ip -n a link add eth0 type veth peer name eth0 netns b
  # ip -n a link set eth0 up; ip -n b link set eth0 up
  # ip -n a addr add 10.1.0.1/24 dev eth0
  # ip -n b addr add 10.1.0.2/24 dev eth0
  # ip -n b link add geneve1 type geneve id 1 remote 10.1.0.1 ttl 64
  # ip -n b addr add 1.1.1.1/24 dev geneve1
  # ip -n b link set geneve1 up
  # ip -n b route add 2.1.1.0/24 dev geneve1
  # ip -n a link add geneve1 type geneve external
  # ip -n a addr add 2.1.1.1/24 dev geneve1
  # ip -n a link set geneve1 up
  # ip -n a route add 1.1.1.0/24 encap ip id 1 geneve_opts \
    1:1:1212121234567890,1:1:1212121234567890,1:1:1212121234567890 \
    dst 10.1.0.2 dev geneve1
  # ip -n a route show
  # ip netns exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     geneve_opts 1:1:1212121234567890,1:1:1212121234567890 ...

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.079 ms

v1->v2:
  - improve the changelog.
  - use PRINT_ANY to support dumping with json format.
v2->v3:
  - implement proper JSON array for opts instead of just bunch of strings.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print class and type as uint and print data as hex string.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 174 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 172 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 0d7d714..8599853 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -294,6 +294,54 @@ static void print_encap_mpls(FILE *fp, struct rtattr *encap)
 			rta_getattr_u8(tb[MPLS_IPTUNNEL_TTL]));
 }
 
+static void lwtunnel_print_geneve_opts(struct rtattr *attr)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_GENEVE_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "geneve_opts";
+	int data_len, offset = 0;
+	char data[rem * 2 + 1];
+	__u16 class;
+	__u8 type;
+
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	open_json_array(PRINT_JSON, name);
+
+	while (rem) {
+		parse_rtattr(tb, LWTUNNEL_IP_OPT_GENEVE_MAX, i, rem);
+		class = rta_getattr_be16(tb[LWTUNNEL_IP_OPT_GENEVE_CLASS]);
+		type = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_GENEVE_TYPE]);
+		data_len = RTA_PAYLOAD(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]);
+		hexstring_n2a(RTA_DATA(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]),
+			      data_len, data, sizeof(data));
+		offset += data_len + 20;
+		rem -= data_len + 20;
+		i = RTA_DATA(attr) + offset;
+
+		open_json_object(NULL);
+		print_uint(PRINT_ANY, "class", "%u", class);
+		print_uint(PRINT_ANY, "type", ":%u", type);
+		if (rem)
+			print_string(PRINT_ANY, "data", ":%s,", data);
+		else
+			print_string(PRINT_ANY, "data", ":%s ", data);
+		close_json_object();
+	}
+
+	close_json_array(PRINT_JSON, name);
+}
+
+static void lwtunnel_print_opts(struct rtattr *attr)
+{
+	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
+
+	parse_rtattr_nested(tb_opt, LWTUNNEL_IP_OPTS_MAX, attr);
+	if (tb_opt[LWTUNNEL_IP_OPTS_GENEVE])
+		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE]);
+}
+
 static void print_encap_ip(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[LWTUNNEL_IP_MAX+1];
@@ -332,6 +380,9 @@ static void print_encap_ip(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP_OPTS]);
 }
 
 static void print_encap_ila(FILE *fp, struct rtattr *encap)
@@ -404,6 +455,9 @@ static void print_encap_ip6(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP6_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP6_OPTS]);
 }
 
 static void print_encap_bpf(FILE *fp, struct rtattr *encap)
@@ -798,11 +852,97 @@ static int parse_encap_mpls(struct rtattr *rta, size_t len,
 	return 0;
 }
 
+static int lwtunnel_parse_geneve_opt(char *str, size_t len, struct rtattr *rta)
+{
+	struct rtattr *nest;
+	char *token;
+	int i, err;
+
+	nest = rta_nest(rta, len, LWTUNNEL_IP_OPTS_GENEVE | NLA_F_NESTED);
+	i = 1;
+	token = strsep(&str, ":");
+	while (token) {
+		switch (i) {
+		case LWTUNNEL_IP_OPT_GENEVE_CLASS:
+		{
+			__be16 opt_class;
+
+			if (!strlen(token))
+				break;
+			err = get_be16(&opt_class, token, 0);
+			if (err)
+				return err;
+
+			rta_addattr16(rta, len, i, opt_class);
+			break;
+		}
+		case LWTUNNEL_IP_OPT_GENEVE_TYPE:
+		{
+			__u8 opt_type;
+
+			if (!strlen(token))
+				break;
+			err = get_u8(&opt_type, token, 0);
+			if (err)
+				return err;
+
+			rta_addattr8(rta, len, i, opt_type);
+			break;
+		}
+		case LWTUNNEL_IP_OPT_GENEVE_DATA:
+		{
+			size_t token_len = strlen(token);
+			__u8 *opts;
+
+			if (!token_len)
+				break;
+			opts = malloc(token_len / 2);
+			if (!opts)
+				return -1;
+			if (hex2mem(token, opts, token_len / 2) < 0) {
+				free(opts);
+				return -1;
+			}
+			rta_addattr_l(rta, len, i, opts, token_len / 2);
+			free(opts);
+
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
+	rta_nest_end(rta, nest);
+
+	return 0;
+}
+
+static int lwtunnel_parse_geneve_opts(char *str, size_t len, struct rtattr *rta)
+{
+	char *token;
+	int err;
+
+	token = strsep(&str, ",");
+	while (token) {
+		err = lwtunnel_parse_geneve_opt(token, len, rta);
+		if (err)
+			return err;
+
+		token = strsep(&str, ",");
+	}
+
+	return 0;
+}
+
 static int parse_encap_ip(struct rtattr *rta, size_t len,
 			  int *argcp, char ***argvp)
 {
 	int id_ok = 0, dst_ok = 0, src_ok = 0, tos_ok = 0, ttl_ok = 0;
-	int key_ok = 0, csum_ok = 0, seq_ok = 0;
+	int key_ok = 0, csum_ok = 0, seq_ok = 0, opts_ok = 0;
 	char **argv = *argvp;
 	int argc = *argcp;
 	int ret = 0;
@@ -854,6 +994,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
 			if (get_u8(&ttl, *argv, 0))
 				invarg("\"ttl\" value is invalid\n", *argv);
 			ret = rta_addattr8(rta, len, LWTUNNEL_IP_TTL, ttl);
+		} else if (strcmp(*argv, "geneve_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_geneve_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"geneve_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
@@ -969,7 +1124,7 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 			   int *argcp, char ***argvp)
 {
 	int id_ok = 0, dst_ok = 0, src_ok = 0, tos_ok = 0, ttl_ok = 0;
-	int key_ok = 0, csum_ok = 0, seq_ok = 0;
+	int key_ok = 0, csum_ok = 0, seq_ok = 0, opts_ok = 0;
 	char **argv = *argvp;
 	int argc = *argcp;
 	int ret = 0;
@@ -1023,6 +1178,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 				       *argv);
 			ret = rta_addattr8(rta, len, LWTUNNEL_IP6_HOPLIMIT,
 					   hoplimit);
+		} else if (strcmp(*argv, "geneve_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_geneve_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"geneve_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
-- 
2.1.0

