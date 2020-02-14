Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F5615D5C4
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbgBNKb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:26 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:40576 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgBNKb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:26 -0500
Received: by mail-pg1-f182.google.com with SMTP id z7so4747063pgk.7
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zcQLBI5IKdqCpH+4Sz/ddgGw4iXFyOAY54NLSFlpnSw=;
        b=hW0GJfkZ7z/N3qTxMPrU/RkTwbXF5UO+yl8WEH2cW/87qxS+PIgGqmbweaLm+9T77q
         ikf7hR7SlxKmNgMcea6ufNOFTeFx6lIDjQ4O1+Xo+36mxxh/6b8gjRkj4vkgvp5s4u6w
         JKq4LulbGAwLy2hcTVOI8FLt1aJ/l71vQb8NMFlc2JzoQRWn7JQei9YCCk0iPC0UJrje
         aAFbTqrrUnanZztvrRKgnOnmoc5hsUTgvSGuAvbKM+OHqigExAFfkgcej/9G7cpglrii
         dAmqVZgEMBdPTSTcTrY1Id0lqU9LP2VXDQvSI458wIHTD+RB2vhtYge+DsSUNurQpdh1
         Iytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zcQLBI5IKdqCpH+4Sz/ddgGw4iXFyOAY54NLSFlpnSw=;
        b=prDX/7ugPbY6t36vtGz07CGY6XUv54JtYOUCCU7KGmVzdi+vFA/qEdlgS9w1muHsu7
         3o+VdJjNZxhfwu8lRxCTbhn0w4iT4HFJc2txPqx5DRrEChtFNR94zJjL7uVYvMGJUUfd
         /QQzyc/BRr7m9O0XaBvyMUo+oFE/GNyjiMQBRwPSVxJ0QIrk9NJkPzsWs+GXwi8MUo+m
         FLfW8zA1AUoKxADiHaploNK5oh/vlyPQwYG8iuvSLSwGpZOxZ/zafutZcGF/zT6snUUp
         snXT7j4M36usN1L4FOWBqv8adJ4IBz4ptbJbEnoiBf2GZt3jeZVGgmxkZkUUN8emQIQj
         kOww==
X-Gm-Message-State: APjAAAV70UZK66Uk+xJknFFUoLpuL+uaagOUkRjWwguz1YxnYhKOtRNf
        T8qW+T5uziQs2LyC7th0uSbi3bJM
X-Google-Smtp-Source: APXvYqwzosBPx7MLnaApsaTUXu1btU3M43iLynfJTi077D9iNAB2RSlWRVSneGrnwBAQhrjd2Os7mQ==
X-Received: by 2002:aa7:9a01:: with SMTP id w1mr2666383pfj.231.1581676284924;
        Fri, 14 Feb 2020 02:31:24 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d14sm6668351pfq.117.2020.02.14.02.31.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:24 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support for erspan metadata
Date:   Fri, 14 Feb 2020 18:30:47 +0800
Message-Id: <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS_ERSPAN's parse and print to implement
erspan options support in iproute_lwtunnel.

Option is expressed as version:index:dir:hwid, dir and hwid will be parsed
when version is 2, while index will be parsed when version is 1. erspan
doesn't support multiple options.

With this patch, users can add and dump erspan options like:

  # ip netns add a
  # ip netns add b
  # ip -n a link add eth0 type veth peer name eth0 netns b
  # ip -n a link set eth0 up
  # ip -n b link set eth0 up
  # ip -n a addr add 10.1.0.1/24 dev eth0
  # ip -n b addr add 10.1.0.2/24 dev eth0
  # ip -n b link add erspan1 type erspan key 1 seq erspan 123 \
    local 10.1.0.2 remote 10.1.0.1
  # ip -n b addr add 1.1.1.1/24 dev erspan1
  # ip -n b link set erspan1 up
  # ip -n b route add 2.1.1.0/24 dev erspan1
  # ip -n a link add erspan1 type erspan key 1 seq local 10.1.0.1 external
  # ip -n a addr add 2.1.1.1/24 dev erspan1
  # ip -n a link set erspan1 up
  # ip -n a route add 1.1.1.0/24 encap ip id 1 \
    erspan_opts 2:123:1:2 dst 10.1.0.2 dev erspan1
  # ip -n a route show
  # ip netns exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     erspan_opts 02:00000000:01:02 dev erspan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.124 ms

v1->v2:
  - improve the changelog.
  - use PRINT_ANY to support dumping with json format.
v2->v3:
  - implement proper JSON object for opts instead of just bunch of strings.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 7691002..f64ccb1 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -364,6 +364,43 @@ static void lwtunnel_print_vxlan_opts(struct rtattr *attr)
 	print_uint(PRINT_FP, NULL, "0x%x ", gbp);
 }
 
+static void lwtunnel_print_erspan_opts(struct rtattr *attr)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
+        struct rtattr *i = RTA_DATA(attr);
+        int rem = RTA_PAYLOAD(attr);
+        char *name = "erspan_opts";
+        char strbuf[rem * 2 + 1];
+	__u8 ver, hwid, dir;
+	__u32 idx;
+
+	parse_rtattr(tb, LWTUNNEL_IP_OPT_ERSPAN_MAX, i, RTA_PAYLOAD(attr));
+	ver = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_VER]);
+	if (ver == 1) {
+		idx = rta_getattr_be32(tb[LWTUNNEL_IP_OPT_ERSPAN_INDEX]);
+		dir = 0;
+		hwid = 0;
+	} else {
+		idx = 0;
+		dir = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_DIR]);
+		hwid = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_ERSPAN_HWID]);
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
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
+	print_string(PRINT_FP, NULL, "%s ", strbuf);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -373,6 +410,8 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE]);
 	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
 		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN]);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_ERSPAN])
+		lwtunnel_print_erspan_opts(tb_opt[LWTUNNEL_IP_OPTS_ERSPAN]);
 }
 
 static void print_encap_ip(FILE *fp, struct rtattr *encap)
@@ -987,6 +1026,82 @@ static int lwtunnel_parse_vxlan_opts(char *str, size_t len, struct rtattr *rta)
 	return 0;
 }
 
+static int lwtunnel_parse_erspan_opts(char *str, size_t len, struct rtattr *rta)
+{
+	struct rtattr *nest;
+	char *token;
+	int i, err;
+
+	nest = rta_nest(rta, len, LWTUNNEL_IP_OPTS_ERSPAN | NLA_F_NESTED);
+	i = 1;
+	token = strsep(&str, ":");
+	while (token) {
+		switch (i) {
+		case LWTUNNEL_IP_OPT_ERSPAN_VER:
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
+		case LWTUNNEL_IP_OPT_ERSPAN_INDEX:
+		{
+			__be32 opt_class;
+
+			if (!strlen(token))
+				break;
+			err = get_be32(&opt_class, token, 16);
+			if (err)
+				return err;
+
+			rta_addattr32(rta, len, i, opt_class);
+			break;
+		}
+		case LWTUNNEL_IP_OPT_ERSPAN_DIR:
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
+		case LWTUNNEL_IP_OPT_ERSPAN_HWID:
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
+		default:
+			fprintf(stderr, "Unknown \"geneve_opts\" type\n");
+			return -1;
+		}
+
+		token = strsep(&str, ":");
+		i++;
+	}
+
+	rta_nest_end(rta, nest);
+	return 0;
+}
+
 static int parse_encap_ip(struct rtattr *rta, size_t len,
 			  int *argcp, char ***argvp)
 {
@@ -1073,6 +1188,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
 				invarg("\"vxlan_opts\" value is invalid\n",
 				       *argv);
 			rta_nest_end(rta, nest);
+		} else if (strcmp(*argv, "erspan_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_erspan_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"erspan_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
@@ -1272,6 +1402,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 				invarg("\"vxlan_opts\" value is invalid\n",
 				       *argv);
 			rta_nest_end(rta, nest);
+		} else if (strcmp(*argv, "erspan_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_erspan_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"erspan_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
-- 
2.1.0

