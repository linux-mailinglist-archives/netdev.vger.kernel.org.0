Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BC152C98B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 04:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiESCCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 22:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiESCCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 22:02:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCEB488B3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 19:02:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x143so3798855pfc.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 19:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mixIM/X9SqDqcozkIvhX3jb18PG1z7mGFG3QeoXd6QQ=;
        b=foX4lGMsp8Qkvucb3dFYKfFKOcFlzIrj3/SUl2oUryso52aRYNIs/zFMWvCYglULem
         MFXE2EkKQtgQ0T2L5HW9yXzRJYZIiAL6h0WAPRzCdkRPFeOLnWCesdD1ryGw8nSkauBO
         SpTURtcGWoKiK4k4eup9fIpLHbeo5ubjvpJhZjbt8VyXkC4VyGH3urivA2gFrevJh9wu
         L6LHp0Xo7i8F87lNh6IApmW/llZjH7GHRe6tO3kZ4W1stnp/VzUcKiypUxye+s65R2NO
         C+nyBTxI/uxKUOAR0qRC8eXSutTh1UK4xnzTmBRd2toXCg8oDDshrqxldqpVvcOv+Q7L
         L2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mixIM/X9SqDqcozkIvhX3jb18PG1z7mGFG3QeoXd6QQ=;
        b=nOgNmiN0aJqyfLTgIyCbNokQS9FC7EUGQQBU3UMj91xaJxZNmQJmRr+9BTaCDLb5l7
         VSHVRKdzR7q09PJG7bOm0miyHKVhDIS56grsC6wuTp91CW/xU2ibS5wzIXym13o+uX2D
         rvVTtTcWZuSaFtwuYpc5qStnLY3RUY4jABMjmB4EW6Ex9HTFEQsRer1eelkByEo/5J2c
         TbN89hRdsWCuax/Q1cnpWHXg5PNG/n4j2hy1e/HANoPmlzqOobNdlEamyMxqgmeWWD/Z
         mPjvXVCtlXsq6QMAah0wUG0gKT94JvG+lb+pQWnPGHSqVg78iFASifjy6Az7DGLChAcr
         zlwA==
X-Gm-Message-State: AOAM5304MC0gx14tw4f7J3aCSLJjIiv4m5jf5czcWLBplf8nxH2oKW77
        Gc3e8Af6zkoFysB0n050g2iT90cVTIBW9A==
X-Google-Smtp-Source: ABdhPJwbJjgT+DqXnbl7MzZMkAMBDLC6j3Ji7TDO3CRx+ci7ejAIaqTF2jTMMjcSf1Obep7B5ufRDQ==
X-Received: by 2002:a63:6846:0:b0:3c6:cb42:cdb2 with SMTP id d67-20020a636846000000b003c6cb42cdb2mr1940020pgc.511.1652925723466;
        Wed, 18 May 2022 19:02:03 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z7-20020a655a47000000b003c67e472338sm2181215pgs.42.2022.05.18.19.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 19:02:02 -0700 (PDT)
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
Subject: [PATCHv3 net] bonding: fix missed rcu protection
Date:   Thu, 19 May 2022 10:01:48 +0800
Message-Id: <20220519020148.1058344-1-liuhangbin@gmail.com>
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

  stack backtrace:
  CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
Since dev_hold() and dev_put() can take NULL these days, we can
skip checking if real_dev exist.

[1] https://lore.kernel.org/netdev/27565.1642742439@famine/

Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: skip checking if real_dev exist since dev_hold/put could take NULL.
v2: add ref on the real_dev as Jakub and Paolo suggested.
---
 drivers/net/bonding/bond_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..b5c5196e03ee 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,16 +5591,23 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
+	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
+	dev_hold(real_dev);
+	rcu_read_unlock();
+
 	if (real_dev) {
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
 	}
 
@@ -5608,7 +5615,9 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
 
-	return 0;
+out:
+	dev_put(real_dev);
+	return ret;
 }
 
 static const struct ethtool_ops bond_ethtool_ops = {
-- 
2.35.1

