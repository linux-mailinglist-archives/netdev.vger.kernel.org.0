Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EAB529C47
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiEQIXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiEQIXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:23:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FFF31533
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:23:38 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gg20so6668113pjb.1
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5K4eCNob39YXKtKuikmIRaukZjZAKrammohCk/UyOMs=;
        b=S4OMOfNspNL7OLIpBifgmG4wUohTQ2ghuip5H55CwDnmnulf2Y1FwGHMyfNZYv1Gdp
         oqXvuThcZ+aJ4q1Szu1tGv5yrExGOeh12GqErc7h1U0bmfGqxoH7MHowvubh1ozVh4Ef
         X4EP/Svya/yO94lVyk73sW9rBv+wB0tJVL365HidEEy8NIKTQbbdgpqB+QQOMjQTof4K
         6iZFbTfdF7tF8l0JKTIeo/xLI7C1ashQQxGBNG5IH2WPBgPDM5CW06+7RNv/MvpgNYRd
         FGAiPo7JlIHZ2dYyZTE0Sti6ejn/g7f12TRzZJ7Jzaq47wIwqKrUB44HyUbECRRdOzcd
         O+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5K4eCNob39YXKtKuikmIRaukZjZAKrammohCk/UyOMs=;
        b=iEJCoqE4uo4v65vnXcAesnwDpi52Y27s/n1oab0thnAAIH4t57rXP2gYdXoF/RsIsP
         vRyGqa4BDcsvPHJpwRwSvLzTN2aZV9z8GhHOHF8xdGeNdwZDckG4Njc6BDeOfvvzMoj2
         5T3R0eKnCYeaymDq9Gg2dp7oLQScbBAjnMmi86P566w1mJnzvyIT6HjRDRJkD7SOEcVA
         xMbtYQT1VfuUHcZrkaUrXfOoodkettr70Zl7tVCwyMuWrgtDRZAiBvEfeuXn37hd6Rr5
         26pbTkLujsc4JT49ue2YQ8wfngwkh21LUCt/m5jQlZkxbaNK0GtbE7b7dRtIhoUpWnxx
         6SpQ==
X-Gm-Message-State: AOAM530XI/ulIzdoWjKykXLkeIX8CWLEsnygfd1CtkM+URL05tYnBhkF
        SGJHWnJdKgGFVqA9DIWp/7P9+SFEWwO3Yg==
X-Google-Smtp-Source: ABdhPJz6QNFVa0ufrLV9YDKmWBr09Ofx4ri8zoYbErORVd6JaPnBKlpZtwaKcCCTezKSqlFbSSJ86g==
X-Received: by 2002:a17:90b:1e09:b0:1dc:6d9a:4f57 with SMTP id pg9-20020a17090b1e0900b001dc6d9a4f57mr34553474pjb.17.1652775817652;
        Tue, 17 May 2022 01:23:37 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w18-20020a62c712000000b0050dc7628166sm8263027pfg.64.2022.05.17.01.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:23:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCHv2 net] bonding: fix missed rcu protection
Date:   Tue, 17 May 2022 16:23:12 +0800
Message-Id: <20220517082312.805824-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

When removing the rcu_read_lock in bond_ethtool_get_ts_info() as
discussed [1], I didn't notice it could be called via setsockopt,
which doesn't hold rcu lock, as syzbot pointed:

  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
   bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
   bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5595
   __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
   ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
   sock_timestamping_bind_phc net/core/sock.c:869 [inline]
   sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
   sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
   __sys_setsockopt+0x55e/0x6a0 net/socket.c:2223
   __do_sys_setsockopt net/socket.c:2238 [inline]
   __se_sys_setsockopt net/socket.c:2235 [inline]
   __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7f8902c8eb39

Fix it by adding rcu_read_lock and take a ref on the real_dev.

[1] https://lore.kernel.org/netdev/27565.1642742439@famine/

Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v2: add ref on the real_dev as Jakub and Paolo suggested.
---
 drivers/net/bonding/bond_main.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..fcaa5ccea7af 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,24 +5591,35 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
+	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
 	if (real_dev) {
+		dev_hold(real_dev);
+		rcu_read_unlock();
 		ops = real_dev->ethtool_ops;
 		phydev = real_dev->phydev;
 
 		if (phy_has_tsinfo(phydev)) {
-			return phy_ts_info(phydev, info);
+			ret = phy_ts_info(phydev, info);
+			goto out;
 		} else if (ops->get_ts_info) {
-			return ops->get_ts_info(real_dev, info);
+			ret = ops->get_ts_info(real_dev, info);
+			goto out;
 		}
+	} else {
+		rcu_read_unlock();
 	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
 
-	return 0;
+out:
+	if (real_dev)
+		dev_put(real_dev);
+	return ret;
 }
 
 static const struct ethtool_ops bond_ethtool_ops = {
-- 
2.35.1

