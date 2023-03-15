Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D16BAF16
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjCOLUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjCOLUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:20:23 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11A16286A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:19:55 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id z42so19000483ljq.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678879192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NBmPi2I5Np5cW8dxFdwaa0iZFaIC/6OvueBCLjhA4g=;
        b=1lCdvO1Z+7G1wHmRM5/28F006oTE28LC2fqkWXouAT8regZEzbjgIbudQVGAwDW7c9
         L/tP4UbH006zoTcBFmhG4O/H14iJ+o7Gvkrg0Br0ASUOKjRrpee8AnYnO9Y2sKiv9YuP
         QzrJYaxyzidPUSGq6UZyOYsCtvl96VjvRp8YaKiD+kOdogZJQmXN6Oda9+RAgPFhngbP
         ccTvYsR1d7hmnp8p2j6F3KQDC12F5DugoZ1K1Hd7OVMM8K9swUNKu0TxQ+N3qv9Q24xo
         7Y8FVhIM5/WhvxZSGquPqbDcUAqSSK/kZ5IqCfudKplSms4UcOZF0uf5sSqtODsFFeWn
         qNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678879192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NBmPi2I5Np5cW8dxFdwaa0iZFaIC/6OvueBCLjhA4g=;
        b=u6+PekyJzZo/JeyFf+st5zqmsoBkDt+uPMLhTfo2Ip3TTwRHKK3eWPQ58UT8Y7LQQ4
         a6BCfeEA86GksD8JJX1nbKuhKxZ+9SBo5pDZOVTyiUg4Xwhgn0TTWXSPRlZgafJW7Ict
         WmzTHFUQZtm0J7rTEhZn9lY0JUzXIPKBSH1zAC+wZ+FnQV7dIapHTohZj23Fx3CGT9oW
         9x90yKEyJqGTmssWRJPbhZsa7YvTIKjbrCfHeNXa/Okil40392xndh45joJT/zFY5Eat
         x5KC4f9dYlCBhKehw/O22vK3d/dbZXPlyJYXnwf7usGnMNtauT6NwBCsCvbBCo2Xlw/4
         jngA==
X-Gm-Message-State: AO0yUKWAJ5eG6MP9i2Efm0ILh1iwySDg8MqMcHRv8EYA7vep0aE/zsN/
        KcfRergZp0dfitwXf3ZsWS56hQKSuivFuYXBOuw+ww==
X-Google-Smtp-Source: AK7set8WORiTaSej55tXBQkXi4S2W6IM5z/ctLiAqjEmD5+IOPDV923sraCYmE5omSf3QonvwPuwHQ==
X-Received: by 2002:a05:651c:510:b0:293:4b8d:daeb with SMTP id o16-20020a05651c051000b002934b8ddaebmr1051473ljp.34.1678879192529;
        Wed, 15 Mar 2023 04:19:52 -0700 (PDT)
Received: from kofa.. ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id 20-20020a2e1654000000b00295a8d1ecc7sm829218ljw.18.2023.03.15.04.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:19:52 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        michal.kubiak@intel.com, jtoppins@redhat.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v3 1/3] bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change
Date:   Wed, 15 Mar 2023 13:18:40 +0200
Message-Id: <20230315111842.1589296-2-razor@blackwall.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230315111842.1589296-1-razor@blackwall.org>
References: <20230315111842.1589296-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bond_ether_setup helper which is used to fix ether_setup() calls in the
bonding driver. It takes care of both IFF_MASTER and IFF_SLAVE flags, the
former is always restored and the latter only if it was set.
If the bond enslaves non-ARPHRD_ETHER device (changes its type), then
releases it and enslaves ARPHRD_ETHER device (changes back) then we
use ether_setup() to restore the bond device type but it also resets its
flags and removes IFF_MASTER and IFF_SLAVE[1]. Use the bond_ether_setup
helper to restore both after such transition.

[1] reproduce (nlmon is non-ARPHRD_ETHER):
 $ ip l add nlmon0 type nlmon
 $ ip l add bond2 type bond mode active-backup
 $ ip l set nlmon0 master bond2
 $ ip l set nlmon0 nomaster
 $ ip l add bond1 type bond
 (we use bond1 as ARPHRD_ETHER device to restore bond2's mode)
 $ ip l set bond1 master bond2
 $ ip l sh dev bond2
 37: bond2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether be:d7:c5:40:5b:cc brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
 (notice bond2's IFF_MASTER is missing)

Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v3: squashed patch 01 with the helper into this one, adjusted the
comment to be more explicit, no code changes

 drivers/net/bonding/bond_main.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00646aa315c3..4bd911f9d3f9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1775,6 +1775,19 @@ void bond_lower_state_changed(struct slave *slave)
 		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
 } while (0)
 
+/* The bonding driver uses ether_setup() to convert a master bond device
+ * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ */
+static void bond_ether_setup(struct net_device *bond_dev)
+{
+	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+
+	ether_setup(bond_dev);
+	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
+}
+
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack)
@@ -1866,10 +1879,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 			if (slave_dev->type != ARPHRD_ETHER)
 				bond_setup_by_slave(bond_dev, slave_dev);
-			else {
-				ether_setup(bond_dev);
-				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-			}
+			else
+				bond_ether_setup(bond_dev);
 
 			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
 						 bond_dev);
-- 
2.39.1

