Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A911BA115
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgD0K21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgD0K21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C12C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a31so5389889pje.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=USkkXEPoOKED/JJ4CrOpmmsSHb2eVX4V2P7UD7R62BY=;
        b=nQv2pqc7H9fO7elEHAjP9CZVls3sQKXQ42JChK8gLKQbHdj4OY5pTtaIQ17Sy4d77T
         u3dDfiGy9aC0Ai4KpvoJcvExCEveQwTaz7Vk7vH3/EyaTKC8EDmStGZX6o9bCqAk1vUF
         GJ0nAKoGt80gS0qQhyn7IhDKF6L5TVSP5Kt3F7SYulzeaz63Nc29yM2L24hXVkjeUEAZ
         nNjRB/I0bMjr3bkyEw/nbEn1zrkHPgvflwNF95Xy14bAaagWejhuCXeDFNx3CVMn6l4z
         Xx3Q1hJ6Y9BOzPB2CHVRupWc2fyH6mRJ5Le2P0AViF1lZavZF67xohPyhsxTMlCSeLHL
         BWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=USkkXEPoOKED/JJ4CrOpmmsSHb2eVX4V2P7UD7R62BY=;
        b=jM84XKUucrZ/hVnIagRt2yAb4hHF6Ybgn4YLJeI8UHidzqPv4vaJx+s0StWZuRHq3G
         3J9zpOzRpqVlohtxz5i21FGuGXrqTsiuMMMUkWZm8ZzR5tOhytCkSl141tPbb8NU5zGU
         GMbjpF3ECBZtQcyn8s8zZ0V5H500o+S9TtovVwnNqbFyFF6JDC+8bdnMU+Z7vNzJotGj
         SzHvLzcQyCUY/sYnUKIJCTHzwAbLUjeSBEQ/hiDqTLidDrHtaM8a8O/P8GsepshuWvhe
         d8VAGAhOvR/AN/ksyqgZJ6F43NLqy9RVGYo7DE72hxbMt6lgSk2OCItL235q2hbCkQK9
         JSGg==
X-Gm-Message-State: AGi0PubAlxLkeGj3mAQUfJyZBQb9Rcp0l3cbCBtoT+emwtOrknGZegzH
        Huo6p1JOGibJ/doKQfbUJU08WZV4
X-Google-Smtp-Source: APiQypIZ/b0claxdw+oHzIsxlfAImCdCy4Bp/ob3jxaHFLcPVleouj4q1imFA41HriKQFtEkirAa7A==
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr24100912pjy.143.1587983306157;
        Mon, 27 Apr 2020 03:28:26 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2sm12254090pfp.118.2020.04.27.03.28.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 3/7] iproute_lwtunnel: add options support for erspan metadata
Date:   Mon, 27 Apr 2020 18:27:47 +0800
Message-Id: <4ae2ca59ac4262b19212a16ee7474189ae5eca72.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS_ERSPAN's parse and print to implement
erspan options support in iproute_lwtunnel.

Option is expressed as version:index:dir:hwid, dir and hwid will be parsed
when version is 2, while index will be parsed when version is 1. All of
these are numbers. erspan doesn't support multiple options.

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
     erspan_opts 2:0:1:2 dev erspan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.124 ms

v1->v2:
  - improve the changelog.
  - use PRINT_ANY to support dumping with json format.
v2->v3:
  - implement proper JSON object for opts instead of just bunch of strings.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print version, index, dir and hwid as uint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 9945c86..d413e19 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -353,6 +353,38 @@ static void lwtunnel_print_vxlan_opts(struct rtattr *attr)
 	close_json_array(PRINT_JSON, name);
 }
 
+static void lwtunnel_print_erspan_opts(struct rtattr *attr)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_ERSPAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	char *name = "erspan_opts";
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
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_ANY, "ver", "%u", ver);
+	print_uint(PRINT_ANY, "index", ":%u", idx);
+	print_uint(PRINT_ANY, "dir", ":%u", dir);
+	print_uint(PRINT_ANY, "hwid", ":%u ", hwid);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -362,6 +394,8 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE]);
 	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
 		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN]);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_ERSPAN])
+		lwtunnel_print_erspan_opts(tb_opt[LWTUNNEL_IP_OPTS_ERSPAN]);
 }
 
 static void print_encap_ip(FILE *fp, struct rtattr *encap)
@@ -976,6 +1010,82 @@ static int lwtunnel_parse_vxlan_opts(char *str, size_t len, struct rtattr *rta)
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
+			err = get_u8(&opt_type, token, 0);
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
+			err = get_be32(&opt_class, token, 0);
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
+			err = get_u8(&opt_type, token, 0);
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
+			err = get_u8(&opt_type, token, 0);
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
@@ -1062,6 +1172,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -1261,6 +1386,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

