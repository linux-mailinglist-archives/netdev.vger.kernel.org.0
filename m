Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E056A452D23
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhKPIwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbhKPIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:52:27 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A28DC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 00:49:31 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 200so17017469pga.1
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 00:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7yd7mgLG9zYvX2PF9I9vAhucvZx3Z5npnfu/rDpKO7o=;
        b=DNRVbnEx5MluWTqznK6CGG8yEHq4f1eNo7vea02jTIvj1oQZi/tQvVdCoI1TvzvBpb
         pObdbiwYBmzB2IppiUAjFvU56xEH/lGjeWlUXH+DDZqQSO+xYTCNsT4fcW1IuoY2jFUk
         dqmnmhzj4NH2kNgQjQ8iSwLTjgRSbk56JYjfXSIF3+JXYHBVyRSvVbrPwHi9z6dNBE19
         IHuKIWjebX1C+XTTcrFP431yWxGxV0wYLjcN+ThiKo6Pb7Wx2S+CThRK/qfum75BPfJy
         u0ctAWBzjg1QVeF2MhvBijRqrsTM+RNGgtuhW7+VbzaGzPFLpQhN+UxWN2P+2uvPpuxr
         oQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7yd7mgLG9zYvX2PF9I9vAhucvZx3Z5npnfu/rDpKO7o=;
        b=EjS4J6G+qh9CvxBBr9U2ps/OTMSJC/jwSw/bv/7IEj+3n+23TVAi8YBzAhkeigSnta
         5GjiuFu8i7pBns5bEKRf0zva6mLiDbVhFKpjoelEl8B2l7xPE6OoI1R+92zFaOpx76gI
         ax4P7NmjPLfSReq/leCwtsespga1MBmFPn/HnJHat0gzg0wB6rLZjDVGv2ntF8twZvvv
         96SlbXqvxOrVU6g2eJ4l5b+EpzCVsSjKd8TOoj3fVhcHT+x00UT0yKONdhk/fGFEO7Az
         x3hHzHRkKA2sxc4DeSVMXHxYefWRW/UDU+N2N0uwc5jorUSbG+OE8zXqBnxQ3dBgkKxz
         EuFg==
X-Gm-Message-State: AOAM530ppN2o6i+Ez91igdfWcmVkMa2SA9F7eIbbHD+0Y1MS8RQXi8EE
        bskD1IVyCYAhQ66b0NX9egexqBCTcb8=
X-Google-Smtp-Source: ABdhPJwiNMIMgmd/b78S6F7Bwe9gI82w9baoJws/MS0ueIILqr24fROA2JlFi0qwSe86C8sQvgZ3SA==
X-Received: by 2002:a62:e309:0:b0:4a2:e288:6203 with SMTP id g9-20020a62e309000000b004a2e2886203mr5248635pfh.13.1637052570617;
        Tue, 16 Nov 2021 00:49:30 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm20161456pfe.171.2021.11.16.00.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 00:49:30 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next] bond: add missed_max option
Date:   Tue, 16 Nov 2021 16:49:13 +0800
Message-Id: <20211116084913.978450-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116084840.978383-1-liuhangbin@gmail.com>
References: <20211116084840.978383-1-liuhangbin@gmail.com>
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
 ip/iplink_bond.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 59c9e36d..069e7604 100644
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
@@ -180,7 +181,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u16 ad_user_port_key, ad_actor_sys_prio;
 	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
-	__u32 packets_per_slave;
+	__u32 packets_per_slave, missed_max;
 	unsigned int ifindex;
 
 	while (argc > 0) {
@@ -258,6 +259,12 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("invalid arp_all_targets", *argv);
 			arp_all_targets = get_index(arp_all_targets_tbl, *argv);
 			addattr32(n, 1024, IFLA_BOND_ARP_ALL_TARGETS, arp_all_targets);
+		} else if (strcmp(*argv, "missed_max") == 0) {
+			NEXT_ARG();
+			if (get_u32(&missed_max, *argv, 0))
+				invarg("invalid missed_max", *argv);
+
+			addattr32(n, 1024, IFLA_BOND_MISSED_MAX, missed_max);
 		} else if (matches(*argv, "primary") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
@@ -453,6 +460,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "arp_interval %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_ARP_INTERVAL]));
 
+	if (tb[IFLA_BOND_MISSED_MAX])
+		print_uint(PRINT_ANY,
+			   "missed_max",
+			   "missed_max %u ",
+			   rta_getattr_u32(tb[IFLA_BOND_MISSED_MAX]));
+
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
 		int i;
-- 
2.31.1

