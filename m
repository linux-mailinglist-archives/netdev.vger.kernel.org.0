Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A0615BE10
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgBML5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:57:33 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36297 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:57:33 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so2995734pgu.3
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Rsv2IfE9PrGfZji0MOkcbMAHCHDN1aMFFjyQsPa62ao=;
        b=pf5hdG6ICVHCiseKoSyyzJaDPuQQ6XeZ0Y+Rv3Cbnjf/d8GD27NtPud9vbUgnKTzCB
         TRPkSvI90wtWmdn+9qKfcqSd3a7cOHnidO3QK2OITxW3DBOd/L77Xg0B928oM6y9W9HB
         05J4ifq9GO9RAAHumJzQEk4S27+GElgkJaE2D+5EgAGvkPqsw47gPL6rWI6dMch1TR6T
         aE+2mrvh39Dj3nP/fTvUKmAqvXpiLy+nKmjSsa0SswqnXOxB/T3N6xPp9V9BuSRx6LLy
         ULekbO4RawDU7fHKj03x0wKixMu5LABgSjlfqqaqH9lFbscEwhajnFZBeWIsOtNdu58A
         vRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Rsv2IfE9PrGfZji0MOkcbMAHCHDN1aMFFjyQsPa62ao=;
        b=ZX0YPA+NJSuiq7cydVdL1M/6kEneATV1hefOzRttCAclFYuZnwpsEpO2pmeFUepeeJ
         A+NxEBsE629IcwkekOECZv7tIWpR2je2ZqEXJwC5g7EGiaCH8S1VVCRv6cpw3Jk95sLt
         w53ygAZ7WhYbnertAtUNhXI0PW+Csv/0oTICC8xhwkLnY28Ho4lhCGk2yS1nmLERE4qb
         uL/b6vtux7TTZ3FbDhx4z3kdZUYLoaNlkfePfBD5LVXE/AGR/MzDVmc273rRVFLlaQtg
         izwm4AzTr1nCFd16uadp6a78QkijLSZMFbUBpYtob8Xeg9nnWK9UwEPdSMijjZbavMxY
         ZJ5w==
X-Gm-Message-State: APjAAAUYMn2cH7jb3QdSsQHkGe2E6BwhaauLoLxo4PGa9jR2GWRNcxlH
        jkp8t572oTt98DgLGEAzJXHTo6zI
X-Google-Smtp-Source: APXvYqwQfjUWKLYwIAUZ52Vov+Q8a96g+mCtN8c5d0vQasax/T4z62GmhEHACSqg6gBTHzUTuBNPlQ==
X-Received: by 2002:a62:7945:: with SMTP id u66mr13818953pfc.82.1581595050426;
        Thu, 13 Feb 2020 03:57:30 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 199sm3039296pfu.71.2020.02.13.03.57.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:57:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 2/7] iproute_lwtunnel: add options support for vxlan metadata
Date:   Thu, 13 Feb 2020 19:57:00 +0800
Message-Id: <0bf376a8304996ec0edf0b14111a2c924a44b5ff.1581594682.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
 <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/iproute_lwtunnel.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index e3c5ad2..14224b7 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -322,6 +322,18 @@ static void lwtunnel_print_geneve_opts(struct rtattr *attr, char *opt)
 	print_string(PRINT_ANY, "geneve_opts", "  geneve_opts %s ", opt);
 }
 
+static void lwtunnel_print_vxlan_opts(struct rtattr *attr, char *opt)
+{
+	struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
+	__u32 gbp;
+
+	parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+	gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
+	print_nl();
+	print_uint(PRINT_ANY, "vxlan_opts", "  vxlan_opts 0x%x ", gbp);
+}
+
 static void lwtunnel_print_opts(struct rtattr *attr)
 {
 	struct rtattr *tb_opt[LWTUNNEL_IP_OPTS_MAX + 1];
@@ -335,6 +347,8 @@ static void lwtunnel_print_opts(struct rtattr *attr)
 	if (tb_opt[LWTUNNEL_IP_OPTS_GENEVE])
 		lwtunnel_print_geneve_opts(tb_opt[LWTUNNEL_IP_OPTS_GENEVE],
 					   opt);
+	else if (tb_opt[LWTUNNEL_IP_OPTS_VXLAN])
+		lwtunnel_print_vxlan_opts(tb_opt[LWTUNNEL_IP_OPTS_VXLAN], opt);
 
 	free(opt);
 }
@@ -935,6 +949,22 @@ static int lwtunnel_parse_geneve_opts(char *str, size_t len, struct rtattr *rta)
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
@@ -1006,6 +1036,21 @@ static int parse_encap_ip(struct rtattr *rta, size_t len,
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
@@ -1190,6 +1235,21 @@ static int parse_encap_ip6(struct rtattr *rta, size_t len,
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

