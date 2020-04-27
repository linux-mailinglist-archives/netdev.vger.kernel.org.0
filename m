Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F34F1BA113
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgD0K2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgD0K2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9141C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w3so6848848plz.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Y6y0CCDuBJg7Nt2VXHsUzc8ABEjTZQBhhjplG+ZTJh4=;
        b=dUTdMWQ6a5DCpredhO/F3XsFciduXZkn4okWtu/E9hhhzGSdKmGIwlpirW/OpeMUU4
         KFXZ66gfgY9C8M23q7q/afLErT9fkBt5INrWiaayJyDJ9tbQMTVjfaoBe9zLLmdExu0k
         5RM3qFjT/oHv5IbDUGRmHf9CiRUftcyv+ij1AAemQXniVsVOt7FXPyfMZtZLTikWvWwE
         kmPwNJDQvIY23ocb6EB3fYFWl5l4WSDfa7PE4oXwg3lsoIyhPZCC3p42M3c5ZI8kQ6ak
         ycgnhJ+Q5JXxqQvHqUqvQtGbg8HvhHFObAHSwWHFA5E8jLZSi/kppPpisxj8DZeW+Sb2
         fezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Y6y0CCDuBJg7Nt2VXHsUzc8ABEjTZQBhhjplG+ZTJh4=;
        b=SYaI67MsNUDT9ATB8M2zzzFnb8ZSVlCh844SnXuVbFLNk4UHgzYGgw7cq0d44Q26TX
         tsrHOI0gZ9dEx8sB8cwHV3KIh+eh2p8ps6agaXrU4ZyIAkNn0JsEQ9SlQauhN4q3mXMb
         PZHXuMU3cEpnswMjl8gyDX+kZ2So5te/6MAdnePpYJ3sLxQjM706LoTnxE2aRSK50a6Q
         uzDIQU9WRPJvWZLFOjgtbZ7EHe/Y74BHrjDbfwdSeqbke8UJjxf8LmXDqxBJwIH6qGb/
         mmtPqihsk+wt2/HfpHW72skqLDhSP0qCQMAw7z44XWAYE/xE074K2lL2Rc1VtXlDWI0E
         nweQ==
X-Gm-Message-State: AGi0PuYDT8Lb8WzXB9ijOO3pBvuxkpqJtosWnNhm722s+gvPlTu3a+wF
        Q+fKhuPXM3884IBbfGG5S7qxlDZM
X-Google-Smtp-Source: APiQypJAl9NkGnRIojGRZq5ZWtZCjJVzKqbaFZiqQKyvn1KEQ2tW8uGRRFEDIQNgkVWgL0kS4ZIQDQ==
X-Received: by 2002:a17:90a:ac02:: with SMTP id o2mr14719070pjq.140.1587983297573;
        Mon, 27 Apr 2020 03:28:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z190sm12109612pfz.84.2020.04.27.03.28.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:28:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 2/7] iproute_lwtunnel: add options support for vxlan metadata
Date:   Mon, 27 Apr 2020 18:27:46 +0800
Message-Id: <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1587983178.git.lucien.xin@gmail.com>
References: <cover.1587983178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS_VXLAN's parse and print to implement
vxlan options support in iproute_lwtunnel.

Option is expressed a number for gbp only, and vxlan doesn't support
multiple options.

With this patch, users can add and dump vxlan options like:

  # ip netns add a
  # ip netns add b
  # ip -n a link add eth0 type veth peer name eth0 netns b
  # ip -n a link set eth0 up
  # ip -n b link set eth0 up
  # ip -n a addr add 10.1.0.1/24 dev eth0
  # ip -n b addr add 10.1.0.2/24 dev eth0
  # ip -n b link add vxlan1 type vxlan id 1 local 10.1.0.2 \
    remote 10.1.0.1 dev eth0 ttl 64 gbp
  # ip -n b addr add 1.1.1.1/24 dev vxlan1
  # ip -n b link set vxlan1 up
  # ip -n b route add 2.1.1.0/24 dev vxlan1
  # ip -n a link add vxlan1 type vxlan local 10.1.0.1 dev eth0 ttl 64 \
    gbp external
  # ip -n a addr add 2.1.1.1/24 dev vxlan1
  # ip -n a link set vxlan1 up
  # ip -n a route add 1.1.1.0/24 encap ip id 1 \
    vxlan_opts 1110 dst 10.1.0.2 dev vxlan1
  # ip -n a route show
  # ip netns exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     vxlan_opts 1110 dev vxlan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.111 ms

v1->v2:
  - improve the changelog.
  - get_u32 with base = 0 for gbp.
  - use PRINT_ANY to support dumping with json format.
v2->v3:
  - implement proper JSON array for opts.
v3->v4:
  - keep the same format between input and output, json and non json.
  - print gbp as uint.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 8599853..9945c86 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -333,6 +333,26 @@ static void lwtunnel_print_geneve_opts(struct rtattr *attr)
 	close_json_array(PRINT_JSON, name);
 }
 
+static void lwtunnel_print_vxlan_opts(struct rtattr *attr)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
+	struct rtattr *i = RTA_DATA(attr);
+	int rem = RTA_PAYLOAD(attr);
+	char *name = "vxlan_opts";
+	__u32 gbp;
+
+	parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, i, rem);
+	gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
+
+	print_nl();
+	print_string(PRINT_FP, name, "\t%s ", name);
+	open_json_array(PRINT_JSON, name);
+	open_json_object(NULL);
+	print_uint(PRINT_ANY, "gdp", "%u ", gbp);
+	close_json_object();
+	close_json_array(PRINT_JSON, name);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -340,6 +360,8 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 	parse_rtattr_nested(tb_opt, LWTUNNEL_IP_OPTS_MAX, attr);
 	if (tb_opt[LWTUNNEL_IP_OPTS_GENEVE])
 		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE]);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
+		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN]);
 }
 
 static void print_encap_ip(FILE *fp, struct rtattr *encap)
@@ -938,6 +960,22 @@ static int lwtunnel_parse_geneve_opts(char *str, size_t len, struct rtattr *rta)
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
@@ -1009,6 +1047,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -1193,6 +1246,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

