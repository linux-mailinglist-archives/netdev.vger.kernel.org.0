Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A9E4BD5BE
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344812AbiBUF4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:56:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344800AbiBUF4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:56:00 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234AE51333
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:38 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b8so14145295pjb.4
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+5d0iSx8AF6H8SJ6oCx+67IU54vbThPOqxmfmTHiHg=;
        b=SQ4tA1PjRY9grNFQUW4htFy7spwumTS9tcCSXnPpo/wGbpEswtZ+jd1bJwPbjQMLOb
         OfArqORfstCgQoTm3TiQr0E+mLedkp3dLf2pluFw1Yi1x610SVdGDgOzjt83RzoqbUJf
         RA/Xathe4EQQnKHdmWQhPOt6Us38MwIUBy2cooNxDqPbqkHNxmCLaZiYxXn0SUf05A11
         8zybx+kaNg1PGPCmrLGmTReNWYn8G3anCfrXNU4s/B3FIPO2heTlifHgS7rLaP+qds8c
         tOInvicXVmuOFNY3pXy41ixb9rFHcNHIfPTB+Zhn6mcsJgwWwMxdZx34adoRXlNYMOrQ
         rtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+5d0iSx8AF6H8SJ6oCx+67IU54vbThPOqxmfmTHiHg=;
        b=WKrGQlyU6aCp/UUTU6CHU2KHgovScuw7EHAi7oe5kZHsiu64bzEQ5B/rPkedZAmu0p
         uyud6gP0rPIAuFKxl2IbSwtmoMc0FNhSByoLQQUqhgjXgNtz/l0FcejbklJucKe2Do9g
         0CDNLvGTDtrTpNVO7wDIbJwPOAmnFpR6J7g/UqaUJ1pxklXU3oKXY97tZEHFuQyhjf2+
         diSma00dY4iQdUmy0/cnoE+QDTajw+px8h3CCR1dSVGCS3HC9d+bL7uTKbQ6Wxicb6A0
         3yo5ooERkjnoQq58iwHJPnYr5fK7xiegUiMRx7D49qdhmSuI7I1l2GqOoC8dJ1ypHt4i
         q/9A==
X-Gm-Message-State: AOAM532Qyv8vAjSKuiQJQ79d9COzTRgxkU+A0QOIz57oKuN1Ii7mkyE7
        cP3nRU7qe3buLRysnFtXqITBHq1uZVc=
X-Google-Smtp-Source: ABdhPJxEOcOa/CsMNVKDbKzXLz+eA972VV8hvnXr6KmP65EHu7WcUKwXMGvE3y5EvW+P6aqZwrtgZA==
X-Received: by 2002:a17:90a:d30f:b0:1bc:2cb4:bef6 with SMTP id p15-20020a17090ad30f00b001bc2cb4bef6mr4702607pju.186.1645422937488;
        Sun, 20 Feb 2022 21:55:37 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm17359767pgn.30.2022.02.20.21.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 21:55:37 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2-next] bond: add ns_ip6_target option
Date:   Mon, 21 Feb 2022 13:54:58 +0800
Message-Id: <20220221055458.18790-7-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221055458.18790-1-liuhangbin@gmail.com>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar with arp_ip_target, this option add bond IPv6 NS/NA monitor
support. When IPv6 target was set, the ARP target will be disabled.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: define BOND_MAX_NS_TARGETS
---
 ip/iplink_bond.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 2bfdf82f..a9a81227 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -21,6 +21,7 @@
 #include "json_print.h"
 
 #define BOND_MAX_ARP_TARGETS    16
+#define BOND_MAX_NS_TARGETS     BOND_MAX_ARP_TARGETS
 
 static unsigned int xstats_print_attr;
 static int filter_index;
@@ -136,6 +137,7 @@ static void print_explain(FILE *f)
 		"                [ arp_validate ARP_VALIDATE ]\n"
 		"                [ arp_all_targets ARP_ALL_TARGETS ]\n"
 		"                [ arp_ip_target [ ARP_IP_TARGET, ... ] ]\n"
+		"                [ ns_ip6_target [ NS_IP6_TARGET, ... ] ]\n"
 		"                [ primary SLAVE_DEV ]\n"
 		"                [ primary_reselect PRIMARY_RESELECT ]\n"
 		"                [ fail_over_mac FAIL_OVER_MAC ]\n"
@@ -248,6 +250,25 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 				addattr_nest_end(n, nest);
 			}
 			addattr_nest_end(n, nest);
+		} else if (matches(*argv, "ns_ip6_target") == 0) {
+			struct rtattr *nest = addattr_nest(n, 1024,
+				IFLA_BOND_NS_IP6_TARGET);
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG();
+				char *targets = strdupa(*argv);
+				char *target = strtok(targets, ",");
+				int i;
+
+				for (i = 0; target && i < BOND_MAX_NS_TARGETS; i++) {
+					inet_prefix ip6_addr;
+
+					get_addr(&ip6_addr, target, AF_INET6);
+					addattr_l(n, 1024, i, ip6_addr.data, sizeof(struct in6_addr));
+					target = strtok(NULL, ",");
+				}
+				addattr_nest_end(n, nest);
+			}
+			addattr_nest_end(n, nest);
 		} else if (matches(*argv, "arp_validate") == 0) {
 			NEXT_ARG();
 			if (get_index(arp_validate_tbl, *argv) < 0)
@@ -404,6 +425,8 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
+	int i;
+
 	if (!tb)
 		return;
 
@@ -469,7 +492,6 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
-		int i;
 
 		parse_rtattr_nested(iptb, BOND_MAX_ARP_TARGETS,
 				    tb[IFLA_BOND_ARP_IP_TARGET]);
@@ -497,6 +519,35 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_BOND_NS_IP6_TARGET]) {
+		struct rtattr *ip6tb[BOND_MAX_NS_TARGETS + 1];
+
+		parse_rtattr_nested(ip6tb, BOND_MAX_NS_TARGETS,
+				    tb[IFLA_BOND_NS_IP6_TARGET]);
+
+		if (ip6tb[0]) {
+			open_json_array(PRINT_JSON, "ns_ip6_target");
+			print_string(PRINT_FP, NULL, "ns_ip6_target ", NULL);
+		}
+
+		for (i = 0; i < BOND_MAX_NS_TARGETS; i++) {
+			if (ip6tb[i])
+				print_string(PRINT_ANY,
+					     NULL,
+					     "%s",
+					     rt_addr_n2a_rta(AF_INET6, ip6tb[i]));
+			if (!is_json_context()
+			    && i < BOND_MAX_NS_TARGETS-1
+			    && ip6tb[i+1])
+				fprintf(f, ",");
+		}
+
+		if (ip6tb[0]) {
+			print_string(PRINT_FP, NULL, " ", NULL);
+			close_json_array(PRINT_JSON, NULL);
+		}
+	}
+
 	if (tb[IFLA_BOND_ARP_VALIDATE]) {
 		__u32 arp_v = rta_getattr_u32(tb[IFLA_BOND_ARP_VALIDATE]);
 		const char *arp_validate = get_name(arp_validate_tbl, arp_v);
-- 
2.31.1

