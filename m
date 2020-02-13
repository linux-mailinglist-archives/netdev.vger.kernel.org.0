Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658EB15BE0F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgBML5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:57:23 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44136 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:57:23 -0500
Received: by mail-pl1-f180.google.com with SMTP id d9so2254894plo.11
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OsJS07YJ3JWn/OfcYGqQmGUczE+7TMC7xP+TXu7oiqc=;
        b=DmkvXNoBNjR8vRvTxct61cLyLcHoG7hKX6Dhuf+j/81GLox7QWjn01H+4yGJM+ZZQO
         8LSpLZHbjU9Aw+DMeOUzUPKNdFm0VclJbnZe1wMyBtpEWwopz00neheeYZbsvtmprT6E
         9p35akI6BZckDF3GhLQ6OCAcZe5KjZsQRCmTuK2aro76nDSRTS6b6fIBI6Nj+GFA8pNX
         RThOzUQbEWSkUKfoiIgUoznkHMBJrB3ZjqeqHqP4WT/UzFo9M/YqmfqTffIqUzUSjF5i
         /418AVvilGi2rInAfPgneNvhDaz35k2d8ubgKz+gb++w/9Ob1OS3FNzCUxrbuOEUb/Ln
         SgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OsJS07YJ3JWn/OfcYGqQmGUczE+7TMC7xP+TXu7oiqc=;
        b=aEO8MseLB1qGdaBdD6kNIoFSePOsr9EbxYQzvyNYqYJLDj2tFUD2vJ12Il+tKg2C90
         0iWcEG4EeA3gfoBCpUN8SXxhVQolmb0s8iHm7yg2zB3NvyGwKj/sJ0H1cLRs/g7i6bFj
         O3hmXMSIBcgxAEzWCTVJOAb1qqbDbKYDY4fiJIdzUXoGSRajMZfB6pZ8ZKFTQI0V6Uqp
         xfgc4BnOh44V39j3vuPiogE6fJAVNynf4mDB7ncfrKwJslBN1NntgQSFpDs4vvRBqOSb
         rkCunYCZtvtiHqbrj02wx3HaMc6l8xaSIPIwgv3r0gNwVY7a8FBXGGOh9yUTugYhObyW
         eeCw==
X-Gm-Message-State: APjAAAUxKfFeMs5++oY/i6up59MlGXS01dzy5WQF/DNBglZA6L5Kfbak
        za/eXGjbBuDAUI/eYtT57PcNYLqL
X-Google-Smtp-Source: APXvYqwzp9z4d36A2maQYi48iKCR4mzDdqmwjxzyHSiykBwRuTFCyj+e7kKnZjnU314yzBEVwMDM2A==
X-Received: by 2002:a17:902:9698:: with SMTP id n24mr13265428plp.312.1581595042039;
        Thu, 13 Feb 2020 03:57:22 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r7sm2958529pfg.34.2020.02.13.03.57.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:57:21 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 1/7] iproute_lwtunnel: add options support for geneve metadata
Date:   Thu, 13 Feb 2020 19:56:59 +0800
Message-Id: <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP(6)_OPTS and LWTUNNEL_IP_OPTS_GENEVE's
parse and print to implement geneve options support in iproute_lwtunnel.

Options are expressed as class:type:data and multiple options may be
listed using a comma delimiter.

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
     geneve_opts 0001:01:1212121234567890,0001:01:1212121234567890 ...

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.079 ms

v1->v2:
  - improve the changelog.
  - use PRINT_ANY to support dumping with json format.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 171 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 0d7d714..e3c5ad2 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -294,6 +294,51 @@ static void print_encap_mpls(FILE *fp, struct rtattr *encap)
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
+	print_nl();
+	print_string(PRINT_ANY, "geneve_opts", "  geneve_opts %s ", opt);
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
@@ -332,6 +377,9 @@ static void print_encap_ip(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP_OPTS]);
 }
 
 static void print_encap_ila(FILE *fp, struct rtattr *encap)
@@ -404,6 +452,9 @@ static void print_encap_ip6(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP6_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP6_OPTS]);
 }
 
 static void print_encap_bpf(FILE *fp, struct rtattr *encap)
@@ -798,11 +849,97 @@ static int parse_encap_mpls(struct rtattr *rta, size_t len,
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
@@ -854,6 +991,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -969,7 +1121,7 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 			   int *argcp, char ***argvp)
 {
 	int id_ok = 0, dst_ok = 0, src_ok = 0, tos_ok = 0, ttl_ok = 0;
-	int key_ok = 0, csum_ok = 0, seq_ok = 0;
+	int key_ok = 0, csum_ok = 0, seq_ok = 0, opts_ok = 0;
 	char **argv = *argvp;
 	int argc = *argcp;
 	int ret = 0;
@@ -1023,6 +1175,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

