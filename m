Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62E545B53B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 08:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240982AbhKXHWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbhKXHWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 02:22:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D692C061714
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 23:19:09 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s137so1341240pgs.5
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 23:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hCuyQ7Pphun0p006yhJKjeekaISZ40snzS/vQNR7Bqg=;
        b=J2yWQbd0+NlKjgNLKgnSOfzVAPDi10rh1Xfr0J+LSdI5ky4skKkmgQ269TF307MN1X
         wdwffDtop3AZSr1BghdqDaPrZ3q/daUWYwqSQ6JAOOK+OhViKisGT5N1PDfFruVgp+cP
         OniqwTEOKfDEB4Cvo3LSo99Ob9solTbrk8JnWeppPHHCROW7sUdhTcQSOm10AYgAnbfK
         LyT7fUwwWFIh9Zg2uETaOpWeEvKfPuxWLi8pxwaoNCqO57ZBlxHlCi3ehAqHy5cuKiPv
         WSzIB50yhAixyoowqXJdns2w+jE+pDTJaM2wO06wNKZT9kXgUNtv0kYtdZ5B+MvkU5T5
         1usw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCuyQ7Pphun0p006yhJKjeekaISZ40snzS/vQNR7Bqg=;
        b=EyeXeFYlDYR5EdHyj9Dyr5SkKAHEGZuqbDoDWb0dvHGfgIyxWtMBKwY/P8xV3sPpdk
         +01dgRO5/45dKnHSTlKdXKS+ILpwQ28rRNhpvcj/1rfNgLyBjTfEhRG7nCF6E7PB3BIi
         mT/ehHS/hzJu/WxihnaeZN0/J1bvPNR80vXFSbk8iFq2fvv/3/cp53i5ksHV6Y070vi/
         Td1l9YkOUQ+WVxiaTfcXhp2+gYacGMqNYA3GQDKfsugYVqG7yrthCu24gimwIDK+0Vyg
         5xXDHY5SNhPq9kmtfB7gt46XkdcmM1PfWLyWG/jzryVHedq3K+7QaHkYnDDxfRU38WZD
         DwZg==
X-Gm-Message-State: AOAM530D0Cm9vYCitS+BU5gKv+0OAkATmlBso9FLVB4L2FHmK9nJfhyQ
        TTTCBlJZg11PrbVaZI9K5xJjNrasExo=
X-Google-Smtp-Source: ABdhPJyIDzktQMU+6h3i9qHTtcFFddDyTH7y+dXYY1p5MBiRCOOrt9tgdKyt08jy8kBVXLJMKDbZ1w==
X-Received: by 2002:a05:6a00:1946:b0:492:64f1:61b5 with SMTP id s6-20020a056a00194600b0049264f161b5mr3991482pfk.52.1637738348431;
        Tue, 23 Nov 2021 23:19:08 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p16sm3579736pfh.97.2021.11.23.23.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 23:19:08 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH draft] bond: add ns_ip6_target option
Date:   Wed, 24 Nov 2021 15:18:54 +0800
Message-Id: <20211124071854.1400032-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124071854.1400032-1-liuhangbin@gmail.com>
References: <20211124071854.1400032-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar with arp_ip_target, this option add bond IPv6 NS/NA monitor
support. When IPv6 target was set, the ARP target will be disabled.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 ip/iplink_bond.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 2bfdf82f..c795c6d7 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -136,6 +136,7 @@ static void print_explain(FILE *f)
 		"                [ arp_validate ARP_VALIDATE ]\n"
 		"                [ arp_all_targets ARP_ALL_TARGETS ]\n"
 		"                [ arp_ip_target [ ARP_IP_TARGET, ... ] ]\n"
+		"                [ ns_ip6_target [ NS_IP6_TARGET, ... ] ]\n"
 		"                [ primary SLAVE_DEV ]\n"
 		"                [ primary_reselect PRIMARY_RESELECT ]\n"
 		"                [ fail_over_mac FAIL_OVER_MAC ]\n"
@@ -248,6 +249,25 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
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
+				for (i = 0; target && i < BOND_MAX_ARP_TARGETS; i++) {
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
@@ -404,6 +424,8 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
+	int i;
+
 	if (!tb)
 		return;
 
@@ -469,7 +491,6 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
-		int i;
 
 		parse_rtattr_nested(iptb, BOND_MAX_ARP_TARGETS,
 				    tb[IFLA_BOND_ARP_IP_TARGET]);
@@ -497,6 +518,35 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		}
 	}
 
+	if (tb[IFLA_BOND_NS_IP6_TARGET]) {
+		struct rtattr *ip6tb[BOND_MAX_ARP_TARGETS + 1];
+
+		parse_rtattr_nested(ip6tb, BOND_MAX_ARP_TARGETS,
+				    tb[IFLA_BOND_NS_IP6_TARGET]);
+
+		if (ip6tb[0]) {
+			open_json_array(PRINT_JSON, "ns_ip6_target");
+			print_string(PRINT_FP, NULL, "ns_ip6_target ", NULL);
+		}
+
+		for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
+			if (ip6tb[i])
+				print_string(PRINT_ANY,
+					     NULL,
+					     "%s",
+					     rt_addr_n2a_rta(AF_INET6, ip6tb[i]));
+			if (!is_json_context()
+			    && i < BOND_MAX_ARP_TARGETS-1
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

