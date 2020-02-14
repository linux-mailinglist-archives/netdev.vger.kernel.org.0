Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1799315D5B2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgBNKbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:09 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:53399 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgBNKbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:09 -0500
Received: by mail-pj1-f43.google.com with SMTP id n96so3711335pjc.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=YASax5RIeYE79TQa9is1Bzw9ABj7eXhV0Q6K4AwPWvc=;
        b=jabrKpSMeXOneN7lk9GMGvztPek3mGMvvcOOIdLKyRLlhKeeMezqe/S+ZolSlUIfhK
         boGvOsZnsFfHwGGs0GkkQXdQwChdhxzH0WPze7Cs1B4rqqquT1JTtsm0p+HvngH8P4Nx
         v2coEbKkH5RWvkkchf5h6jPSzmQC+BbmtTZ4apg4TWscbjQgfvG7JZFxaQADsCpmGJDr
         5zjj+tL4D601Pb2J1I0Sdr4He4JoUnnGs6SjAvDlbf7uie8GR0DYrWDIrugoYlwIZ6gm
         fmTsakC++6pJYACgW645Wwp2tgUqxzqwXpm+kyRepkPKb6YLX+HASXPncVoF3uqQ9WIp
         fdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=YASax5RIeYE79TQa9is1Bzw9ABj7eXhV0Q6K4AwPWvc=;
        b=dIsA6k3l95t89JrMHS0mTwshqcpnotoamfH6hi+BmwEtD1Toaq+hkycVUEjjpQWV79
         kE3Ii2Ycf7N9/7gXHTKWx06Cb8XHyf+1jrVHRKDl6oJ18AK2BsRPHQTyCNAYU7R/GOUR
         rDY3/NUho2q1gZqWmKKW+JmVn1K34aRR706LAgMEwaX0h+VQa6LVw+6xl7j3yoAjS0Br
         QEHRNXDqWGjR+EmN9dpf2Gqht9oiY8+yH4XB/ZJQWOnSlRPlvwqxl0OINk7S5I9uygYM
         N4tyxGADzRxQkpo3X0Ax6g+X+oQx3aoHJVdeEv288LPq2pGdsTTmBjj6KbQaR5MI8y8V
         YNyA==
X-Gm-Message-State: APjAAAUS9sD4SqRAOvgcy3LZ5WU45HFtM1G7D/Lk6xaCZwobGaQybP14
        /EWjTgL4cn6eYcQn9ueCd6ehWUXg
X-Google-Smtp-Source: APXvYqwJ4e+PF6WLhnszcT6H5lXC1TWPgMJtF3NNomRJlDV1Y/wt6nWSEHm0xFqXn26rjRPT7Rhseg==
X-Received: by 2002:a17:90a:d804:: with SMTP id a4mr2716200pjv.11.1581676268304;
        Fri, 14 Feb 2020 02:31:08 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d14sm6074710pjz.12.2020.02.14.02.31.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:07 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 1/7] iproute_lwtunnel: add options support for geneve metadata
Date:   Fri, 14 Feb 2020 18:30:45 +0800
Message-Id: <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
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
v2->v3:
  - implement proper JSON array for opts instead of just bunch of strings.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 183 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 181 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 0d7d714..737d7da 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -294,6 +294,63 @@ static void print_encap_mpls(FILE *fp, struct rtattr *encap)
 			rta_getattr_u8(tb[MPLS_IPTUNNEL_TTL]));
 }
 
+static void lwtunnel_print_geneve_opts(struct rtattr *attr)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_GENEVE_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int ii, data_len, offset = 0;
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "geneve_opts";
+	char strbuf[rem * 2 + 1];
+	char data[rem * 2 + 1];
+	uint8_t data_r[rem];
+	__u16 class;
+	__u8 type;
+
+	open_json_array(PRINT_JSON, name);
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+
+	while (rem) {
+		parse_rtattr(tb, LWTUNNEL_IP_OPT_GENEVE_MAX, i, rem);
+		class = rta_getattr_be16(tb[LWTUNNEL_IP_OPT_GENEVE_CLASS]);
+		type = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_GENEVE_TYPE]);
+		data_len = RTA_PAYLOAD(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]);
+		hexstring_n2a(RTA_DATA(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]),
+			      data_len, data, sizeof(data));
+		hex2mem(data, data_r, data_len);
+		offset += data_len + 20;
+		rem -= data_len + 20;
+		i = RTA_DATA(attr) + offset;
+
+		open_json_object(NULL);
+		print_uint(PRINT_JSON, "class", NULL, class);
+		print_uint(PRINT_JSON, "type", NULL, type);
+		open_json_array(PRINT_JSON, "data");
+		for (ii = 0; ii < data_len; ii++)
+			print_uint(PRINT_JSON, NULL, NULL, data_r[ii]);
+		close_json_array(PRINT_JSON, "data");
+		close_json_object();
+
+		sprintf(strbuf, "%04x:%02x:%s", class, type, data);
+		if (rem)
+			print_string(PRINT_FP, NULL, "%s,", strbuf);
+		else
+			print_string(PRINT_FP, NULL, "%s ", strbuf);
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
@@ -332,6 +389,9 @@ static void print_encap_ip(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP_OPTS]);
 }
 
 static void print_encap_ila(FILE *fp, struct rtattr *encap)
@@ -404,6 +464,9 @@ static void print_encap_ip6(FILE *fp, struct rtattr *encap)
 		if (flags & TUNNEL_SEQ)
 			print_bool(PRINT_ANY, "seq", "seq ", true);
 	}
+
+	if (tb[LWTUNNEL_IP6_OPTS])
+		lwtunnel_print_opts(tb[LWTUNNEL_IP6_OPTS]);
 }
 
 static void print_encap_bpf(FILE *fp, struct rtattr *encap)
@@ -798,11 +861,97 @@ static int parse_encap_mpls(struct rtattr *rta, size_t len,
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
@@ -854,6 +1003,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -969,7 +1133,7 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 			   int *argcp, char ***argvp)
 {
 	int id_ok = 0, dst_ok = 0, src_ok = 0, tos_ok = 0, ttl_ok = 0;
-	int key_ok = 0, csum_ok = 0, seq_ok = 0;
+	int key_ok = 0, csum_ok = 0, seq_ok = 0, opts_ok = 0;
 	char **argv = *argvp;
 	int argc = *argcp;
 	int ret = 0;
@@ -1023,6 +1187,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

