Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B9525FB9
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379492AbiEMKeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379493AbiEMKeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:34:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1A01A8DD5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 03:34:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c9so7555705plh.2
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 03:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPOtL3FNU2LUJ0OfoRblNlQsAquSWMh4eol92KkQ/eA=;
        b=WWs1lxfbNUWZ5uu6jyHdqctRZCZD3WLHhlSLVwaCcU1Tx8AQfSOKq6RB27dyWdqCI7
         y5+MtUSBe5ApFWA0Snu/bbsAnMkvio0V5IZ7QlmNRQcbxIC+GCuEVj8h9/lx8+ZDbCP7
         ox2rn5DBIOHJU9N3jkMf7q4GgHb20k4RBKK6wQR4+Jw3uajLgsvQiFpz5ngzN3g5HyxK
         hkh+N14rPK38OErdT4ukDxEX/4xMtv/SO6RMMU5JPsOF+OyodXl+qzEj4RnmWwM9HJ1A
         9hzrX3a6osiq+pwn8wpz2weOg7H4zMEEOL83tzrd3pLHss80R7CkR/DojrduajQ1l/5W
         N/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPOtL3FNU2LUJ0OfoRblNlQsAquSWMh4eol92KkQ/eA=;
        b=SoJE4aR6i1eP6WuwBmGZVURX/HaBqe4fHJJ7VBHwniLk1/aYWXC49LJvcgMTvN+xT4
         XDZMlOLZrpv2MrkxPmCQ/pX9AxVF/MG7bVgP/rOzHEvnA9p0i+kyN5RMne8hnNGC/m5r
         72G1XufimRIm/zgNNazZYzN8nbzfNxLk6r3sPvm82xQSHHSQtnJjanIjlHGQlQjky5wW
         +//kmnQ08xXGS/qd9vwFNjEMOMGUxwTf2d9wG8zBoprcUQIkw+xCW7+zoBJnRRPn3Km3
         0l0O6aKdzfwuDZ4bA5MqzNi9MJqeNzHn/5qOVttvfJAqT4yKwIFvOQ8YW7Qq6BY023L+
         8q4g==
X-Gm-Message-State: AOAM532i0Ll6XvhystUesCxqduLMOUsOXB//fyJ8bg3XAaVVA0NTYTpk
        YsPvvrfx90pbBdag0ov9V2iI/cse/EFSVw==
X-Google-Smtp-Source: ABdhPJyXxmfK3OgxURsoZ4QoVY5eSz7Djzx1+sj/Qj7Fa5/s6kvxRBlk9ToytVQmr0DU64AqCCRHBQ==
X-Received: by 2002:a17:903:246:b0:153:84fe:a9b0 with SMTP id j6-20020a170903024600b0015384fea9b0mr4210509plh.163.1652438041744;
        Fri, 13 May 2022 03:34:01 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090332c200b0015e8d4eb2c0sm1487370plr.266.2022.05.13.03.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 03:34:01 -0700 (PDT)
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
Subject: [PATCH RESEND net] bonding: fix missed rcu protection
Date:   Fri, 13 May 2022 18:33:50 +0800
Message-Id: <20220513103350.384771-1-liuhangbin@gmail.com>
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

Sorry, I hit send too quick in last patch and forgot to add net prefix.
So resend the patch in this mail.

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

