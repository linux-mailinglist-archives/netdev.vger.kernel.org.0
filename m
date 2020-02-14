Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D4F15D5BE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgBNKbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:19 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33277 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgBNKbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:19 -0500
Received: by mail-pj1-f66.google.com with SMTP id m7so716524pjs.0
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=R+sHfr+ra+Ds9L/SR6E7HWRMq8SFWqBolKDkeT0EeTI=;
        b=YlNITZmyV6hIv6O3s6M2XFasZkI4+HsHWAqNWNGXMzJyiKjA4YzUaFg672V+Xba0RX
         Ls0TRk3uhkl/gEq4YEBCtehcGyMYxmHiSiZKo84w5xZP43cL4OIOod0R4AteO/neCttP
         eTsN17hWxJB0H7K+Ye8HSNXZ5YQjTuN7Ah8xXnrjCnRXlNUGDTPUs9h8Kh6EEq4nayrK
         Cmx8ltOCmToCZ2XHIW+C8y3rQNR+LSw3StJKHNOeM3DIfVa97a4AsRxrFXBJBfEKGBA8
         QqRaNfcwre9Ot/DfhRYAs3+D2KMVtRDd3zh/tiG3TTCd27j5H5hRijRiQLr3heNSUAx3
         E0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=R+sHfr+ra+Ds9L/SR6E7HWRMq8SFWqBolKDkeT0EeTI=;
        b=ZeOqU8IbdnXQ8/5hT76yHX5BPwA3OwcBqBIMZezFksrN34ZBHG68M39B9GQZKoEcIL
         zUdJECgOWsRrDa5x5OXlfJPREWPiJFLD9TvclqNH/CPd6yy4/NMU37Aqv1wYyqUzYvv/
         YhwCmpJu8A5xsmP8wF13Re/ipJ9fW/GU8q6sDb/5pHGvic0+xJDZ1u348CGLc7Ss7b3K
         wmb2J3CI6zPK3u7GLxOtWZ/P+v7l08fAdB850GzFOqEieSwermNX7YdMCYmuAS4RjLi5
         IhKp7aRWRYDn1AW2UQRgfjpyVZG8VqcOjGGdP2mRLamCwvJcMelifh2JRM/yVavHLrUW
         z3Xw==
X-Gm-Message-State: APjAAAXyp2VRrGRDiEkUKXaKDwT/GPiXgd1f/z0vqpCgxpY7/pbJL7So
        EjMKatzPbEmV/6sGiQpWUu1c4Xht
X-Google-Smtp-Source: APXvYqzM/bPiwusjGhU+RHn5Af5sa4oUpxcJs1tNot4KPhpCq6X3MwNOfwaDqPZ0VRHTUl+LZN43JA==
X-Received: by 2002:a17:902:8486:: with SMTP id c6mr2743203plo.147.1581676276624;
        Fri, 14 Feb 2020 02:31:16 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 23sm6413407pfh.28.2020.02.14.02.31.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:31:16 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 2/7] iproute_lwtunnel: add options support for vxlan metadata
Date:   Fri, 14 Feb 2020 18:30:46 +0800
Message-Id: <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS_VXLAN's parse and print to implement
vxlan options support in iproute_lwtunnel.

Option is expressed one hex value for gbp only, and vxlan doesn't support
multiple options.

With this patch, users can add and dump vxlan options like:

  # ip netns add a
  # ip netns add b
  # ip -n a link add eth0 type veth peer name eth0 netns b
  # ip -n a link set eth0 up
  # ip -n b link set eth0 up
  # ip -n a addr add 10.1.0.1/24 dev eth0
  # ip -n b addr add 10.1.0.2/24 dev eth0
  # ip -n b link add vxlan1 type vxlan id 1 local 10.1.0.2 remote 10.1.0.1 \
    dev eth0 ttl 64 gbp
  # ip -n b addr add 1.1.1.1/24 dev vxlan1
  # ip -n b link set vxlan1 up
  # ip -n b route add 2.1.1.0/24 dev vxlan1
  # ip -n a link add vxlan1 type vxlan local 10.1.0.1 dev eth0 ttl 64 \
    gbp external
  # ip -n a addr add 2.1.1.1/24 dev vxlan1
  # ip -n a link set vxlan1 up
  # ip -n a route add 1.1.1.0/24 encap ip id 1 \
    vxlan_opts 0x456 dst 10.1.0.2 dev vxlan1
  # ip -n a route show
  # ip netns exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     vxlan_opts 0x456 dev vxlan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.111 ms

v1->v2:
  - improve the changelog.
  - get_u32 with base = 0 for gbp.
  - use PRINT_ANY to support dumping with json format.
v2->v3:
  - implement proper JSON array for opts.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 737d7da..7691002 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -342,6 +342,28 @@ static void lwtunnel_print_geneve_opts(struct rtattr *attr)
 	close_json_array(PRINT_JSON, name);
 }
 
+static void lwtunnel_print_vxlan_opts(struct rtattr *attr)
+{
+        struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
+        struct rtattr *i = RTA_DATA(attr);
+        int rem = RTA_PAYLOAD(attr);
+        char *name = "vxlan_opts";
+        __u32 gbp;
+
+	parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, i, rem);
+	gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
+
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_JSON, "gbp", NULL, gbp);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	print_uint(PRINT_FP, NULL, "0x%x ", gbp);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -349,6 +371,8 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 	parse_rtattr_nested(tb_opt, LWTUNNEL_IP_OPTS_MAX, attr);
 	if (tb_opt[LWTUNNEL_IP_OPTS_GENEVE])
 		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE]);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
+		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN]);
 }
 
 static void print_encap_ip(FILE *fp, struct rtattr *encap)
@@ -947,6 +971,22 @@ static int lwtunnel_parse_geneve_opts(char *str, size_t len, struct rtattr *rta)
 	return 0;
 }
 
+static int lwtunnel_parse_vxlan_opts(char *str, size_t len, struct rtattr *rta)
+{
+	struct rtattr *nest;
+	__u32 gbp;
+	int err;
+
+	nest = rta_nest(rta, len, LWTUNNEL_IP_OPTS_VXLAN | NLA_F_NESTED);
+	err = get_u32(&gbp, str, 0);
+	if (err)
+		return err;
+	rta_addattr32(rta, len, LWTUNNEL_IP_OPT_VXLAN_GBP, gbp);
+
+	rta_nest_end(rta, nest);
+	return 0;
+}
+
 static int parse_encap_ip(struct rtattr *rta, size_t len,
 			  int *argcp, char ***argvp)
 {
@@ -1018,6 +1058,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
 				invarg("\"geneve_opts\" value is invalid\n",
 				       *argv);
 			rta_nest_end(rta, nest);
+		} else if (strcmp(*argv, "vxlan_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_vxlan_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"vxlan_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
@@ -1202,6 +1257,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
 				invarg("\"geneve_opts\" value is invalid\n",
 				       *argv);
 			rta_nest_end(rta, nest);
+		} else if (strcmp(*argv, "vxlan_opts") == 0) {
+			struct rtattr *nest;
+
+			if (opts_ok++)
+				duparg2("opts", *argv);
+
+			NEXT_ARG();
+
+			nest = rta_nest(rta, len,
+					LWTUNNEL_IP_OPTS | NLA_F_NESTED);
+			ret = lwtunnel_parse_vxlan_opts(*argv, len, rta);
+			if (ret)
+				invarg("\"vxlan_opts\" value is invalid\n",
+				       *argv);
+			rta_nest_end(rta, nest);
 		} else if (strcmp(*argv, "key") == 0) {
 			if (key_ok++)
 				duparg2("key", *argv);
-- 
2.1.0

