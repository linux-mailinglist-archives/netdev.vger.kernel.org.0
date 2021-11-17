Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6145424A
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 09:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhKQIGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 03:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKQIGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 03:06:53 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAD7C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 00:03:55 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 136so1611837pgc.0
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 00:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AodCGRgu4AC9OaqDJZl1T98IHm/S34T2O43d9bWwmoM=;
        b=ecPcsXiCEzdLPwPB6MiEYgig3jtvTHxiaq4dMSuBaVaFav1/SkhqVw4v8FN9FINKok
         fOzj+nrrVrWEF1WLcKnL5kmgr0Yo8+6svynQZACo5PBWJmt6BAxG2/dTnxbwpEHRt+bg
         v2r5oyQI3Nn0lUllXHgHz3Gpo/qCbKxVWWMXH4FDGx3OUggGhIuHOYgcZLFGRy6tCycT
         4p+SL4H2IIc2VVG+4Qc6fTtc9B3AOAHXoFdxTVIdWzSKIDF+6pmp+Wlr9VmcLwudbTVq
         HCaFZmq8IbsTb4L19Y1R/istzij12PN4sq5DRm44w3Vvhoxy4vS50REnBD44aP3FEG0y
         ae1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AodCGRgu4AC9OaqDJZl1T98IHm/S34T2O43d9bWwmoM=;
        b=7aJnFhF3XLqOPfGL7kwk8WqXTXO+NN7QTA7ZKBVBOeVXPLSwxGoYbxjByqNdnUGUWf
         dxNaWwcdNDGevO2pMMU3CnG2mq6P9UDlQsMwi9u7Q9DMtLsuwdBOQQXZFt9yEWp6KldZ
         wucEV+xATRN7L302rxXVTgedSQOeGC61yv3uZrJLZXwmV9d18ArRQfIiXhcMqFwd5Gm7
         yaV+SL7QWhMnoos1GHDhcwxXdGcAid25DMGu5yQEidogN9WgXwqSMO7JTTz3ZyBNQIGQ
         S2fuoJRsZU9OezdddV6bQulCD/JABK9Mg+O/3ZB2s7MQjiGaOTOhAPUwNwJo44XDpjjf
         Nmgw==
X-Gm-Message-State: AOAM533H/9gbIwCJGXLYjJ3st3boIiZrF8pBh2VTOL6DThpyU0losw3B
        9dufYtQ/2FGjeXtnlorhtjyvq2gSKac=
X-Google-Smtp-Source: ABdhPJwDbxG4K1obOQ+cS4A5SQ+F9PwPpnP0VwQMN0vqwmW2eIakm9NG9mXbLSme1PhSpgVAuh0dUg==
X-Received: by 2002:a63:ef52:: with SMTP id c18mr2306835pgk.271.1637136234758;
        Wed, 17 Nov 2021 00:03:54 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c1sm23209667pfv.54.2021.11.17.00.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 00:03:54 -0800 (PST)
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
Subject: [PATCHv2 iproute2-next] bond: add missed_max option
Date:   Wed, 17 Nov 2021 16:03:37 +0800
Message-Id: <20211117080337.1038647-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117080337.1038647-1-liuhangbin@gmail.com>
References: <20211117080337.1038647-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bond missed_max is the maximum number of arp_interval monitor cycle
for missed ARP replies. If this number is exceeded, link is reported as
down.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: use u8 for missed_max
---
 ip/iplink_bond.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 59c9e36d..be5d73b1 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -153,6 +153,7 @@ static void print_explain(FILE *f)
 		"                [ ad_user_port_key PORTKEY ]\n"
 		"                [ ad_actor_sys_prio SYSPRIO ]\n"
 		"                [ ad_actor_system LLADDR ]\n"
+		"                [ missed_max MISSED_MAX ]\n"
 		"\n"
 		"BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb\n"
 		"ARP_VALIDATE := none|active|backup|all|filter|filter_active|filter_backup\n"
@@ -181,6 +182,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
 	__u32 packets_per_slave;
+	__u8 missed_max;
 	unsigned int ifindex;
 
 	while (argc > 0) {
@@ -258,6 +260,12 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("invalid arp_all_targets", *argv);
 			arp_all_targets = get_index(arp_all_targets_tbl, *argv);
 			addattr32(n, 1024, IFLA_BOND_ARP_ALL_TARGETS, arp_all_targets);
+		} else if (strcmp(*argv, "missed_max") == 0) {
+			NEXT_ARG();
+			if (get_u8(&missed_max, *argv, 0))
+				invarg("invalid missed_max", *argv);
+
+			addattr8(n, 1024, IFLA_BOND_MISSED_MAX, missed_max);
 		} else if (matches(*argv, "primary") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
@@ -453,6 +461,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "arp_interval %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_ARP_INTERVAL]));
 
+	if (tb[IFLA_BOND_MISSED_MAX])
+		print_uint(PRINT_ANY,
+			   "missed_max",
+			   "missed_max %u ",
+			   rta_getattr_u8(tb[IFLA_BOND_MISSED_MAX]));
+
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
 		int i;
-- 
2.31.1

