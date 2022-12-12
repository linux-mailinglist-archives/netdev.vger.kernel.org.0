Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A31E649852
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 04:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiLLD5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 22:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiLLD5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 22:57:08 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F41D2D9
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:57:06 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d7so10768393pll.9
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYnEvbc0JArqsjIIu/AnmmKxqDvktrsaNk+5w9sZk0g=;
        b=f6/2x772ESOh/kbxMgIaXs32mFCYplc9nz+aQZ6wtk3ccxVNzAMdsHn/ah6V2DOtIq
         MG7Wk7rHlYjzwt3cKm9qdKa7A4OzqMZgwaVo9JRv8z3k0BKp8is5Ptn20ACAkOTJisRD
         qRPp0bYtFDkbEQ755ZfsKgLAryVdmPHmMxf7Hep/0wZ+EzRvhu47ktqEVKJH8VturyG9
         h95wiIgR2KJd0cw5HjtDy6/bUwdi0asDr1Mit2VE1pug5wjqRGbSam+y+md5srpi4cXp
         ruOT4Tq4PobOylpdrVNwIAB420QlYbPQdmK7Jzz1srtu2wQK5DVXy2QXkxSv0MBqpq4k
         nw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AYnEvbc0JArqsjIIu/AnmmKxqDvktrsaNk+5w9sZk0g=;
        b=XwzoAIxa0Y7jZQFmo/LMm5V91HkhKlP9HFUYO+0T2XGaibctMyEJeAFs+DTteG3rmh
         2jH3IQe79SedpRSn2+qheDnovQh1gNVrPbEsr3DtOW89mRvCVJ/9Mm2IKN+kcdVM4CPu
         26wX08jOQTIWb7Tssa+4g4WNrv4BPTIi7jZ1NAiO7Uz3k/lpLPfHctLphiwKhbXp8oLh
         5npQUa8cXUIv3PXH8C2JSiNaFWWpmDi8LXt5ykMpbqKREvtsGV/+TnUOAWMCvk7ehcgf
         JaucP8Hmrzg1IDmH9doDUhh3U8mS6nJE6fzBNYlJOSkpAwKVqfeMVzngdF8koLDEf5vw
         MS1w==
X-Gm-Message-State: ANoB5pkOOjzK0KyJCzjqz62WSBKIlNrGHTeWitPwEfbYWIyFKqnqOQVL
        60UoK2CZLFjRj1zMYILglt/xdroaw4aWhYZm
X-Google-Smtp-Source: AA0mqf7+ludukrXl+Ub2hYHN6zBI4bC+aBOKImviLEgtc8y70aq+rWZlh/KEf9Hg4ZBWwPIaqHFycQ==
X-Received: by 2002:a05:6a20:54a5:b0:aa:3e5f:88ab with SMTP id i37-20020a056a2054a500b000aa3e5f88abmr21122111pzk.54.1670817426048;
        Sun, 11 Dec 2022 19:57:06 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w190-20020a6362c7000000b00476dc914262sm4231207pgb.1.2022.12.11.19.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 19:57:05 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/3] bonding: do failover when high prio link up
Date:   Mon, 12 Dec 2022 11:56:46 +0800
Message-Id: <20221212035647.1053865-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212035647.1053865-1-liuhangbin@gmail.com>
References: <20221212035647.1053865-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a high prio link enslaved, or when current link down,
the high prio port could be selected. But when high prio link up, the
new active slave reselection is not triggered. Fix it by checking link's
prio when getting up. Making the do_failover after looping all slaves as
there may be multi high prio slaves up.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 0a2ff7cc8ad4 ("Bonding: add per-port priority for failover re-selection")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: make do_failover after looping all slaves
---
 drivers/net/bonding/bond_main.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0c8a8e0edfca..3bf50e587032 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2644,8 +2644,9 @@ static void bond_miimon_link_change(struct bonding *bond,
 
 static void bond_miimon_commit(struct bonding *bond)
 {
-	struct list_head *iter;
 	struct slave *slave, *primary;
+	bool do_failover = false;
+	struct list_head *iter;
 
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->link_new_state) {
@@ -2689,8 +2690,9 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary)
-				goto do_failover;
+			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary ||
+			    slave->prio > rcu_dereference(bond->curr_active_slave)->prio)
+				do_failover = true;
 
 			continue;
 
@@ -2711,7 +2713,7 @@ static void bond_miimon_commit(struct bonding *bond)
 			bond_miimon_link_change(bond, slave, BOND_LINK_DOWN);
 
 			if (slave == rcu_access_pointer(bond->curr_active_slave))
-				goto do_failover;
+				do_failover = true;
 
 			continue;
 
@@ -2722,8 +2724,9 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			continue;
 		}
+	}
 
-do_failover:
+	if (do_failover) {
 		block_netpoll_tx();
 		bond_select_active_slave(bond);
 		unblock_netpoll_tx();
@@ -3521,6 +3524,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
  */
 static void bond_ab_arp_commit(struct bonding *bond)
 {
+	bool do_failover = false;
 	struct list_head *iter;
 	unsigned long last_tx;
 	struct slave *slave;
@@ -3550,8 +3554,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
 				slave_info(bond->dev, slave->dev, "link status definitely up\n");
 
 				if (!rtnl_dereference(bond->curr_active_slave) ||
-				    slave == rtnl_dereference(bond->primary_slave))
-					goto do_failover;
+				    slave == rtnl_dereference(bond->primary_slave) ||
+				    slave->prio > rtnl_dereference(bond->curr_active_slave)->prio)
+					do_failover = true;
 
 			}
 
@@ -3570,7 +3575,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 
 			if (slave == rtnl_dereference(bond->curr_active_slave)) {
 				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
-				goto do_failover;
+				do_failover = true;
 			}
 
 			continue;
@@ -3594,8 +3599,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
 				  slave->link_new_state);
 			continue;
 		}
+	}
 
-do_failover:
+	if (do_failover) {
 		block_netpoll_tx();
 		bond_select_active_slave(bond);
 		unblock_netpoll_tx();
-- 
2.38.1

