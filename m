Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E23150181
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBCFkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:40:16 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:44107 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgBCFkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 00:40:16 -0500
Received: by mail-pg1-f174.google.com with SMTP id g3so1467626pgs.11
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 21:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=e6JJpD2xb3H2ffEI3f3YarWxwN3CI2pxRRoiPVQzCiI=;
        b=DJ5OFIsW1bZcnAU+9B1kQLrRWJlY17usKWK4gu3uiBoedoJs6VZPmqEwJPqXiIHrZK
         YCvgV49n7QVIcmeFyylZPAj1cq3WizWglby883tka/BpniPfbEjCxLdXSTIBhsfU24xs
         J+qSjwDMbGoaGYQNtd56JrHIblWauZUajkBHwFtV3ny/WAXe1GkQnvFfHJG8hqfvJNsz
         b1kYKnHDi23Sxnec43MkUkq1dV65TOSlXhlU0pxBhIJdgcXqxWem8ACwPQ/yFVtvuJ18
         /ADg08XymlYv9iMLtBBjjxhluSUDc5CBFSN5a9Pvw50hToIs31vTHCMTkNZeHbBPKf09
         6jzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=e6JJpD2xb3H2ffEI3f3YarWxwN3CI2pxRRoiPVQzCiI=;
        b=b4H55Q74ZTVmllFtWpSnF9o55ItjfzK+NFYZM3l4SGxpNYiMkG9xFYg507a8htwUXK
         iw2kXV5S4ceO6CnKTZluFuX2rH86LGzK7QIA7cQaLxniIVSi8tdMZBnUeSH/b8e3t3m5
         +TqGz9/5vV0hMLH+odslKSAXhXVTpz5TGuYUl5aJP3k7OAF053Se7baO5RKE5VBc5TiD
         OE+0siJgg1S4lqC4R2L64jgR0rFc2qkoL5V7nYbm8GrlVg1NqXh9ukWiIOl2hsOucqdU
         Sfu1RaME59YGM8JinznW7j5aFS16jbanBEg8xJ/XRtJtEpxE9zvF8rEm7UKdQr273hb+
         UTxA==
X-Gm-Message-State: APjAAAVVJa1YkAnFdZzveLxVIlcNwrB7t9m//H58vnQ6MKC82qeXM4p2
        E+BXRUgfCynRwf+hKZ76GfJcgDI/
X-Google-Smtp-Source: APXvYqwuYkI8+My90NDv4ab0J7dIOP22iZC3YVB5AnxpNY+XaXSUvMs9Me5z21+E8S/3ZClRWFnq5Q==
X-Received: by 2002:aa7:94b0:: with SMTP id a16mr23103827pfl.35.1580708415064;
        Sun, 02 Feb 2020 21:40:15 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b12sm18857805pfr.26.2020.02.02.21.40.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Feb 2020 21:40:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: [PATCH iproute2-next 1/7] iproute_lwtunnel: add options support for geneve metadata
Date:   Mon,  3 Feb 2020 13:39:52 +0800
Message-Id: <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP(6)_OPTS and LWTUNNEL_IP_OPTS_GENEVE's
parse and print to implement geneve options support in iproute_lwtunnel.

Options are expressed as class:type:data and multiple options may be
listed using a comma delimiter.

With this patch, users can add and dump geneve options like:

  # ip net d a; ip net d b; ip net a a; ip net a b
  # ip -n a l a eth0 type veth peer name eth0 netns b
  # ip -n a l s eth0 up; ip -n b link set eth0 up
  # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
  # ip -n b l a geneve1 type geneve id 1 remote 10.1.0.1 ttl 64
  # ip -n b a a 1.1.1.1/24 dev geneve1; ip -n b l s geneve1 up
  # ip -n b r a 2.1.1.0/24 dev geneve1
  # ip -n a l a geneve1 type geneve external
  # ip -n a a a 2.1.1.1/24 dev geneve1; ip -n a l s geneve1 up
  # ip -n a r a 1.1.1.0/24 encap ip id 1 geneve_opts \
    1:1:1212121234567890,1:1:1212121234567890,1:1:1212121234567890 \
    dst 10.1.0.2 dev geneve1
  # ip -n a r s; echo ''; ip net exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     geneve_opts 0001:01:1212121234567890,0001:01:1212121234567890 ...

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.079 ms

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 170 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 168 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 0d7d714..ba3c9e1 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -294,6 +294,50 @@ static void print_encap_mpls(FILE *fp, struct rtattr *encap)
 			rta_getattr_u8(tb[MPLS_IPTUNNEL_TTL]));
 }
 
+static void lwtunnel_print_geneve_opts(struct rtattr *attr, char *opt)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_GENEVE_MAX + 1];
+	int data_len, offset = 0, slen = 0;
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char data[rem * 2 + 1];
+	__u16 class;
+	__u8 type;
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
+		slen += sprintf(opt + slen, "%04x:%02x:%s", class, type, data);
+		if (rem)
+			slen += sprintf(opt + slen, ",");
+	}
+	print_string(PRINT_FP, "enc_opt", "\n  geneve_opts %s ", opt);
+}
+
+static void lwtunnel_print_opts(struct rtattr *attr)
+{
+	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
+	char *opt;
+
+	opt = malloc(RTA_PAYLOAD(attr) * 2 + 1);
+	if (!opt)
+		return;
+
+	parse_rtattr_nested(tb_opt, LWTUNNEL_IP_OPTS_MAX, attr);
+	if (tb_opt[LWTUNNEL_IP_OPTS_GENEVE])
+		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE],
+					   opt);
+
+	free(opt);
+}
+
 static void print_encap_ip(FILE *fp, struct rtattr *encap)
 {
 	struct rtattr *tb[LWTUNNEL_IP_MAX+1];
@@ -332,6 +376,9 @@ static void print_encap_ip(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP_OPTS]);
 }
 
 static void print_encap_ila(FILE *fp, struct rtattr *encap)
@@ -404,6 +451,9 @@ static void print_encap_ip6(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP6_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP6_OPTS]);
 }
 
 static void print_encap_bpf(FILE *fp, struct rtattr *encap)
@@ -798,11 +848,97 @@ static int parse_encap_mpls(struct rtattr *rta, size_t len,
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
+			err = get_be16(&opt_class, token, 16);
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
+			err = get_u8(&opt_type, token, 16);
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
@@ -854,6 +990,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -969,7 +1120,7 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 			   int *argcp, char ***argvp)
 {
 	int id_ok = 0, dst_ok = 0, src_ok = 0, tos_ok = 0, ttl_ok = 0;
-	int key_ok = 0, csum_ok = 0, seq_ok = 0;
+	int key_ok = 0, csum_ok = 0, seq_ok = 0, opts_ok = 0;
 	char **argv = *argvp;
 	int argc = *argcp;
 	int ret = 0;
@@ -1023,6 +1174,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

