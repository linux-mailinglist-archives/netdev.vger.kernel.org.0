Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203DB6EFFE6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242825AbjD0DjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjD0DjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:39:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC349212D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:20 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b620188aeso9307060b3a.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682566760; x=1685158760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6SMA9y8JQBDxsApK2oZlZlBs4sUItW2ct+DINr1dnM=;
        b=kmVASjCIpjCVMietVi+rU5OzjE2uEYXEi0tthSnXy9buMgDYn5L+42/ZQbB9bYRLnX
         m5U0+oBfZpA3n5KlFoLAgkzYlMlBpuW1cLLXwXhJpFJsbigRp1F7cvSHocNqOapBjkzC
         YcoNVfk2Riy110vD2CACF9qtOHTt6mTlu6iVNSZM9urvjn81OVTNoY5BX3B7z6bNWdT0
         tcRqRNeD/l1j0Wwzng2atytWmYbMruvS/kGlE4F7EK5OKRXOs/K0XlBUIb9gpYh1reL3
         XGWf5ENba/zHYRzfEHiqfwJ6UYQ8+pwotbBflXUBLIfzmV9llfq91LFi05GXoYr0VFJ0
         BWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682566760; x=1685158760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6SMA9y8JQBDxsApK2oZlZlBs4sUItW2ct+DINr1dnM=;
        b=ZWn3/QTTNZKLC2aPUyrwMbitdJD0FvmAQxxBUixf+Pdbw2nVvBQaTatXaKle4vtBZL
         YNuIoJnoRAt2xLih0J2R9Ch38mjeEKXb71lzKvooE2lyGqe354k+pRwY7fuG78Y+t4Ex
         DZQ3nRlZ/Ww9K2iUwoONbU4vzVxZCt/PKCevfl5+LufXpqnHCTspxsjd+2c8OyWIMXyv
         oFb+5kKsoDXJ/uqd9/LNhj6VS4zSkydMFBGnZFYFBe7jDYiYn1RO2nKJcbT4u6bNF+FZ
         iG9fBHn7neKeQGsttdiLBRWkFOe6XXfiTyopbIZE1vBSVlErSByXd2QqRUnGVpkPdkBV
         Nifg==
X-Gm-Message-State: AC+VfDzaGFO7VGdBb+rqMxk/1PjwquuQTSm7FdxUcJUR3RCZ3tBzovo1
        Wa/zShZ/BNi4CeyWpywSXoSbMBDIXuGYPj2f
X-Google-Smtp-Source: ACHHUZ5P0vnupIqkAHLSmqFl1epO01YXXGDAinjx+tYCwacDIOPzVUgrkSXljvJDIm9vEdyUxMoJKQ==
X-Received: by 2002:a05:6a00:190d:b0:636:e52f:631e with SMTP id y13-20020a056a00190d00b00636e52f631emr520961pfi.1.1682566759629;
        Wed, 26 Apr 2023 20:39:19 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b005abc30d9445sm12017743pfv.180.2023.04.26.20.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 20:39:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 1/4] bonding: fix send_peer_notif overflow
Date:   Thu, 27 Apr 2023 11:39:06 +0800
Message-Id: <20230427033909.4109569-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230427033909.4109569-1-liuhangbin@gmail.com>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
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

Bonding send_peer_notif was defined as u8. Since commit 07a4ddec3ce9
("bonding: add an option to specify a delay between peer notifications").
the bond->send_peer_notif will be num_peer_notif multiplied by
peer_notif_delay, which is u8 * u32. This would cause the send_peer_notif
overflow easily. e.g.

  ip link add bond0 type bond mode 1 miimon 100 num_grat_arp 30 peer_notify_delay 1000

To fix the overflow, let's set the send_peer_notif to u32 and limit
peer_notif_delay to 300s.

Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: define send_peer_notif as u32 and limit the peer_notif_delay to 300s
---
 drivers/net/bonding/bond_netlink.c | 6 ++++++
 drivers/net/bonding/bond_options.c | 8 +++++++-
 include/net/bonding.h              | 2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index c2d080fc4fc4..09a501cdea0c 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -244,6 +244,12 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 	if (data[IFLA_BOND_PEER_NOTIF_DELAY]) {
 		int delay = nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
 
+		if (delay > 300000) {
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_BOND_PEER_NOTIF_DELAY],
+					    "peer_notif_delay should be less than 300s");
+			return -EINVAL;
+		}
+
 		bond_opt_initval(&newval, delay);
 		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval,
 				     data[IFLA_BOND_PEER_NOTIF_DELAY], extack);
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index f71d5517f829..5310cb488f11 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -169,6 +169,12 @@ static const struct bond_opt_value bond_num_peer_notif_tbl[] = {
 	{ NULL,      -1,  0}
 };
 
+static const struct bond_opt_value bond_peer_notif_delay_tbl[] = {
+	{ "off",     0,   0},
+	{ "maxval",  300000, BOND_VALFLAG_MAX},
+	{ NULL,      -1,  0}
+};
+
 static const struct bond_opt_value bond_primary_reselect_tbl[] = {
 	{ "always",  BOND_PRI_RESELECT_ALWAYS,  BOND_VALFLAG_DEFAULT},
 	{ "better",  BOND_PRI_RESELECT_BETTER,  0},
@@ -488,7 +494,7 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.id = BOND_OPT_PEER_NOTIF_DELAY,
 		.name = "peer_notif_delay",
 		.desc = "Delay between each peer notification on failover event, in milliseconds",
-		.values = bond_intmax_tbl,
+		.values = bond_peer_notif_delay_tbl,
 		.set = bond_option_peer_notif_delay_set
 	}
 };
diff --git a/include/net/bonding.h b/include/net/bonding.h
index c3843239517d..2d034e07b796 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -233,7 +233,7 @@ struct bonding {
 	 */
 	spinlock_t mode_lock;
 	spinlock_t stats_lock;
-	u8	 send_peer_notif;
+	u32	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
 	struct   proc_dir_entry *proc_entry;
-- 
2.38.1

