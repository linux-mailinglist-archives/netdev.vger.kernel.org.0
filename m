Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3926B459FFC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 11:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhKWKW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 05:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbhKWKWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 05:22:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171DEC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 02:19:12 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v23so16220163pjr.5
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 02:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CF/bCOmHqCjXFGpttpqyKxqtJSF4Ix5l/veYvhKIT9o=;
        b=oDvUyAuqjzrhr+gNHrH6n9F0x6leDyNZNy0exUhjg4Y037azrt82NC3e1uS4hRRjGH
         nHLo5+WRb+/qHd35hE6a02bF+nn85owkiAJn3um6wTIlJL3v2t7YVE4DFUE7scDiW6y1
         lO/VIXNOLFS29pEV6WW5QXpwF9v7USYIrvVn2JyuGiE6YwgUIhoDREmQ6JUo9MkwSDfs
         4aHbqmBsiBsifUEJyuSfhiglp+HpizCTE1WjLCzUhv+6H1khk++X9/OXyILZVs0hPtU5
         541LRKrZa/ajtpCaqYk+rL0sBzA+I8pc4opfh5BKIkhlTNqOqzkP5jkvM7vhQ1i9Ba67
         glGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CF/bCOmHqCjXFGpttpqyKxqtJSF4Ix5l/veYvhKIT9o=;
        b=wK64OmmgtK0l3GNr5xonHiMroOArnhbYHYf6cF6IM2Q3/ACfvzw6gAs3BK3jA+ucA2
         lKwrXq6GR45BPLy6J36Vn9Zjw4H6Aytl1fy+WkLcTxxC6IWEZljZ64xdBi9JNNB2BPiu
         CDGhySkaM0ppPgVs8YOvcbMuitLgaRD7dd8yE9IYoYE4O1/eCu1Zn6OzXbI0PjGFcATr
         KY/Q7+hdO6E1eMo32df4maRPQ9YoVSnu/UgHQI12fxQz4FCerQe63sg2XuJIZ4UFq7ES
         3ugP4xrCDdaHm5/Ko9XlukC4qWkYztpZ9meWhwSJ8q1YDc341cYGtsz1NErcvjdhLa7L
         pIbQ==
X-Gm-Message-State: AOAM531p4XPPDG7qOuwl5AgYF1AXt9mlMRh89prYw4oQMAiNf06UWSbh
        gNBG0jrZi5B3On2mQnAX+ilROJUhNj8=
X-Google-Smtp-Source: ABdhPJyer3QjXPSmPqQ85pitbbe9/91Pv+XnmNXu2qDx0JYj0l71eNVlWF0Y5Yj8DXs2r9ttBwiU6A==
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr1464227pjb.232.1637662751441;
        Tue, 23 Nov 2021 02:19:11 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c1sm13854551pfv.54.2021.11.23.02.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 02:19:11 -0800 (PST)
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
Subject: [PATCHv3 iproute2-next] bond: add arp_missed_max option
Date:   Tue, 23 Nov 2021 18:18:54 +0800
Message-Id: <20211123101854.1366731-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123101854.1366731-1-liuhangbin@gmail.com>
References: <20211123101854.1366731-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bond arp_missed_max is the maximum number of arp_interval monitor cycle
for missed ARP replies. If this number is exceeded, link is reported as
down.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v2: use u8 for missed_max
v3: rename the option name to arp_missed_max
---
 ip/iplink_bond.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 59c9e36d..2bfdf82f 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -153,6 +153,7 @@ static void print_explain(FILE *f)
 		"                [ ad_user_port_key PORTKEY ]\n"
 		"                [ ad_actor_sys_prio SYSPRIO ]\n"
 		"                [ ad_actor_system LLADDR ]\n"
+		"                [ arp_missed_max MISSED_MAX ]\n"
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
+		} else if (strcmp(*argv, "arp_missed_max") == 0) {
+			NEXT_ARG();
+			if (get_u8(&missed_max, *argv, 0))
+				invarg("invalid arp_missed_max", *argv);
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
+			   "arp_missed_max",
+			   "arp_missed_max %u ",
+			   rta_getattr_u8(tb[IFLA_BOND_MISSED_MAX]));
+
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
 		int i;
-- 
2.31.1

