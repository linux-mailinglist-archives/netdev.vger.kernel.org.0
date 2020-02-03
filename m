Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E2E150182
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgBCFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:40:24 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:56252 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgBCFkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 00:40:24 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so5786244pjz.5
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 21:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=tYK174oq98JJpZfreUDPjFkK0R5eWCpOYoPe1glzsZw=;
        b=C1ap743xCYg6fRCAwVi8/fvypIzgCpWKbHa4q1IafryKOWeNtMtnINerCwNSULhzzx
         FzgTUkuQ4GTHDKdythZLoJqZhdz+5sbQiYXOTNjO9nbN5pDpBRClhp3+reMxvLwqYUrc
         OUgvazTiC9U5dwkaW87e0Mb9eOEAcYhVHesFk4RY1zv67HozUfgJMPsqE8v5OYyc45+F
         Et8bkpFmVjdBR1p1PFRM7guaQdh36bWVfOUXOct62WIjhnEgZsOb/ZC2Nwvx7y74F1dC
         MiCBuu15t1rvmkpinm7MUkpM1slyRi3orz9E6lSiKlhWDSFWlTWT3127vmA2rXJ3lMxi
         PtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=tYK174oq98JJpZfreUDPjFkK0R5eWCpOYoPe1glzsZw=;
        b=l42Kjdq6jmB2SY2nJ7kyXzO9wZNKPm57eh2Mt2EHH5tXOBbDjjAEMiie3QTnctK3JD
         FwchCuvC0rmM6M63v34Dtj+dWH0dLpZO/XemJIw51UQh3I8j/WUscHBw8d9odWO1YBmF
         VvICRpusXk5c6zCLomNZXDWWmruHnwdFDIFpg4bAxOcf57/gBex8zU+F/BctzhS8Bmg6
         HDO+LOiU3iwcu1B4exmDJ9M1SzvN/+Iu1V3JgcWXhx9UFN2zB2YGypn+goF+r3WHjaed
         6lJL6m5lVAANxVYjVe4b+MZD70E8DCGsq3pYqgISaTvMLRDeQVYLPT8FIDbwcoPlSxuY
         6hIg==
X-Gm-Message-State: APjAAAXXRRQs6oYxsAzXLHsuSioGrLJzx3k3hkn3dF0GCfSA+UYmBMwo
        Vdh1R1vEvQvHafFG23P73yDUfweQ
X-Google-Smtp-Source: APXvYqz+8wwZ96v8N6LmAQPsUjKacvbHUi0kghxi2Qu6aUyOXt7muQ9DZVEnSYbzPcx1QXub3ND+Ww==
X-Received: by 2002:a17:902:830a:: with SMTP id bd10mr501710plb.145.1580708423441;
        Sun, 02 Feb 2020 21:40:23 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fh24sm18454444pjb.24.2020.02.02.21.40.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Feb 2020 21:40:22 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: [PATCH iproute2-next 2/7] iproute_lwtunnel: add options support for vxlan metadata
Date:   Mon,  3 Feb 2020 13:39:53 +0800
Message-Id: <85a6a30aac8eeab7c408fdadfa5419dc1596cf5d.1580708369.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
 <93e7cebfeda666b17c6a1b2bb8b5065bdab4814c.1580708369.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1580708369.git.lucien.xin@gmail.com>
References: <cover.1580708369.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add LWTUNNEL_IP_OPTS_VXLAN's parse and print to implement
vxlan options support in iproute_lwtunnel.

Option is expressed one hex value for gbp only, and vxlan doesn't support
multiple options.

With this patch, users can add and dump vxlan options like:

  # ip net d a; ip net d b; ip net a a; ip net a b
  # ip -n a l a eth0 type veth peer name eth0 netns b
  # ip -n a l s eth0 up; ip -n b link set eth0 up
  # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
  # ip -n b l a vxlan1 type vxlan id 1 local 10.1.0.2 remote 10.1.0.1 \
    dev eth0 ttl 64 gbp
  # ip -n b a a 1.1.1.1/24 dev vxlan1; ip -n b l s vxlan1 up
  # ip -n b r a 2.1.1.0/24 dev vxlan1
  # ip -n a l a vxlan1 type vxlan local 10.1.0.1 dev eth0 ttl 64 \
    gbp external
  # ip -n a a a 2.1.1.1/24 dev vxlan1; ip -n a l s vxlan1 up
  # ip -n a r a 1.1.1.0/24 encap ip id 1 \
    vxlan_opts 456 dst 10.1.0.2 dev vxlan1
  # ip -n a r s; echo ''; ip net exec a ping 1.1.1.1 -c 1

   1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 tos 0
     vxlan_opts 456 dev vxlan1 scope link

   PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
   64 bytes from 1.1.1.1: icmp_seq=1 ttl=64 time=0.111 ms

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index ba3c9e1..741569e 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -321,6 +321,18 @@ static void lwtunnel_print_geneve_opts(struct rtattr *attr, char *opt)
 	print_string(PRINT_FP, "enc_opt", "\n  geneve_opts %s ", opt);
 }
 
+static void lwtunnel_print_vxlan_opts(struct rtattr *attr, char *opt)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
+	__u32 gbp;
+
+	parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+	gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
+	sprintf(opt, "%x", gbp);
+	print_string(PRINT_FP, "enc_opt", "\n  vxlan_opts %s ", opt);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -334,6 +346,8 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 	if (tb_opt[LWTUNNEL_IP_OPTS_GENEVE])
 		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE],
 					   opt);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
+		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN], opt);
 
 	free(opt);
 }
@@ -934,6 +948,22 @@ static int lwtunnel_parse_geneve_opts(char *str, size_t len, struct rtattr *rta)
 	return 0;
 }
 
+static int lwtunnel_parse_vxlan_opts(char *str, size_t len, struct rtattr *rta)
+{
+	struct rtattr *nest;
+	__u32 gbp;
+	int err;
+
+	nest = rta_nest(rta, len, LWTUNNEL_IP_OPTS_VXLAN | NLA_F_NESTED);
+	err = get_u32(&gbp, str, 16);
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
@@ -1005,6 +1035,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -1189,6 +1234,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

