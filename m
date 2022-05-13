Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD5525FFE
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378752AbiEMKbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379440AbiEMKaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:30:46 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E820541A9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 03:30:25 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id x12so7114078pgj.7
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 03:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2k1p+tJKo6hHCtl9mPxapyF4tgIaC2/id87nCDxI8Pg=;
        b=CP6C+SXyVMJ/Xe3yySBmr6Ooujkui4xpT/PAcheqq7o1JAqOaHuolsEKlhiwtRLDZp
         hbvqymoaMWPDPhoWEnHFcrGfalHsX3uxhVbLEYJ4vLy8tay8Iy0P5+/SVex3Rm/JGxfs
         JIhCUDTe28A4PpS5syOJ486UznFRYn1M/NsRQtGHeM+NIZlPnUprzIJzt9Bpz6H/yobq
         WZzhTBoeJkb/xHtjYyZvM8zfgPz8yOyHKjLFDYEbl18tquxC0R0YzdSQytveGAwq9KnH
         iuvYNLAW6cAsxdR8FXrujS7hkE47JRRmouDFpw19bz3E2RO1mINZ9dRAgryCEEcllprM
         /3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2k1p+tJKo6hHCtl9mPxapyF4tgIaC2/id87nCDxI8Pg=;
        b=T9g216MWVOgum9SHfm348yWULjLiMijsWO5oPtGTECOFh9/GjpaDK2xbI3MPJYxP0O
         vZGzgOMPwscU80ZyrieExrC1JSem4kBLTrzGiqtuqWVF/EvxRNRQMs+nQeuRqCzOBIWj
         +4n7KvAR7n5xkllEOjm9jOW61KoAK6dET9u29RQ5wgVLCEEFBi2kCjMp5O7jkYz1pCiX
         1vNGMNN0oLb96r+Q1aLzZKHVib88JARh3KQkBjwPU11EjRH274zOra6eQKkb1gOwZMvl
         NZdydigIjbZ43iHgDF1furdrBcboJSnUjOj1YoNyvicBHfwiVaCRqIOwPRkLkbXH7Lt4
         oiZQ==
X-Gm-Message-State: AOAM530eq8F+6fA7UiTfZ9xFq9vWfnCSX9ro/sGmlpLbUhj90qQIsqJq
        kfm5Ki5WWOW2+7k/xNhGr3EgUfWz5nYlmg==
X-Google-Smtp-Source: ABdhPJzXhpvT3AiIahaf0ESLo7kcEj1FJCBTjir5DHA6BFTQK5AafDu7cOty7Vgjp13HQbdmmWFFlQ==
X-Received: by 2002:a63:81c6:0:b0:3ab:616b:35b with SMTP id t189-20020a6381c6000000b003ab616b035bmr3504067pgd.256.1652437824521;
        Fri, 13 May 2022 03:30:24 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903305100b0015e8d4eb212sm1483470pla.92.2022.05.13.03.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 03:30:23 -0700 (PDT)
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
Subject: [PATCH] bond: fix missed rcu protection
Date:   Fri, 13 May 2022 18:30:08 +0800
Message-Id: <20220513103008.384019-1-liuhangbin@gmail.com>
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

When removing the rcu_read_lock in bond_ethtool_get_ts_info(), I didn't
notice it could be called via setsockopt, which doesn't hold rcu lock,
as syzbot pointed:

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

Fix it by adding rcu_read_lock during the whole slave dev get_ts_info period.

Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..3a6f879ad7a9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,16 +5591,20 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
+	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
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
 
@@ -5608,7 +5612,9 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
 
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static const struct ethtool_ops bond_ethtool_ops = {
-- 
2.35.1

