Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363F76E1E70
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDNIfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDNIfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:35:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693ED30EA
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:35:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id hg12so3242736pjb.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681461335; x=1684053335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZJPqEenc9iFj2xrRO3MdObafS9/2IURmNpR86dnAM8=;
        b=lJZoRyAp3lxDLACsLY77SARqpN9UychliNrIYIOs3XzGWyABI2bpq3cNgRKZnuKM/i
         mhKrAebXSbr5dp3JahxYJoriaxzLLoaz/jBeftkLI0GTqV2dW5CetofoEeLESy43BeaF
         d1ZfVF7J6vQCDFmHLSweZB8sEQ3C4L7PrqojBj8+XSOxZc6uImo3Byd4TjiNxOVx07Se
         6d5PeQsG82Jbep4Hq4h4ZcJadAo+AV4PzkNqUbqR8QvG0Rzj7Tt2SZ3zoh0iYIvW+uj+
         zuT7nw7Ni6qi/LrtQrrdA1ARykUrLtV/s+SLaRHV26LnbrqwuCwD5/A4TxRCzMwqHAtx
         YlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681461335; x=1684053335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ZJPqEenc9iFj2xrRO3MdObafS9/2IURmNpR86dnAM8=;
        b=UU3WEPWUFxr3sFGy93RjQvfVAr4M77/mbgt9ZhIK+Fix9dHZn+Fbus0OqUAojf3jQs
         xd4z8DsCY+4r2y1Lt9N8/8E5AxcFHfSQAY7bx4dXP6iOrMR2/gL7AuwkvPB/PNVXZxhj
         pHmvXLfjeHDZU5RI4J3LNJ15ePggi8Cd1PK1XstmHzAgo4sYc6zh6+tt5Q98fyUPrWVc
         pttv6T9k7rPmnXgrgmqeiZM5nlaCbE+BVmSAa5tpz+Efg/GB7jCtsK8FoT79xTQFqhSY
         O3ytyPq7cUbdVqbB2jaqeUJV8VZCFFXgG+Lq5GF4RNhNYZnnSjdCo3okXgebhteLemF5
         nM8w==
X-Gm-Message-State: AAQBX9dogeOStrEY073rRO7gyhdb9Y/dokxi7BSx/c2OfVxLuILv8TAL
        yq0G/LwSiNdf3IMXTkEgQFg4zg7tLYNzjQ==
X-Google-Smtp-Source: AKy350Yta39qSjjxoe5Uu6mtMaKm2wEMzCH3fJ+GnPs31cm6KKgpxn2EmA5iFoKT7GHOPNOQ4q56aA==
X-Received: by 2002:a05:6a20:671d:b0:d9:dbb6:2e67 with SMTP id q29-20020a056a20671d00b000d9dbb62e67mr4411739pzh.31.1681461335070;
        Fri, 14 Apr 2023 01:35:35 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:7826:7100:99c4:7575:f7e2:a105])
        by smtp.gmail.com with ESMTPSA id t8-20020aa79388000000b0063b6bc2be16sm575933pfe.141.2023.04.14.01.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 01:35:33 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCHv4 net-next] bonding: add software tx timestamping support
Date:   Fri, 14 Apr 2023 16:35:26 +0800
Message-Id: <20230414083526.1984362-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Currently, bonding only obtain the timestamp (ts) information of
the active slave, which is available only for modes 1, 5, and 6.
For other modes, bonding only has software rx timestamping support.

However, some users who use modes such as LACP also want tx timestamp
support. To address this issue, let's check the ts information of each
slave. If all slaves support tx timestamping, we can enable tx
timestamping support for the bond.

Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
    RTNL. Only check _TX_SOFTWARE for the slaves.
v3: remove dev_hold/dev_put. remove the '\' for line continuation.
v2: check each slave's ts info to make sure bond support sw tx
    timestamping
---
 drivers/net/bonding/bond_main.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00646aa315c3..9cf49b61f4b3 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5686,11 +5686,17 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				    struct ethtool_ts_info *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct ethtool_ts_info ts_info;
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
+	bool sw_tx_support = false;
 	struct phy_device *phydev;
+	struct list_head *iter;
+	struct slave *slave;
 	int ret = 0;
 
+	ASSERT_RTNL();
+
 	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
 	dev_hold(real_dev);
@@ -5707,10 +5713,36 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 			ret = ops->get_ts_info(real_dev, info);
 			goto out;
 		}
+	} else {
+		/* Check if all slaves support software tx timestamping */
+		rcu_read_lock();
+		bond_for_each_slave_rcu(bond, slave, iter) {
+			ret = -1;
+			ops = slave->dev->ethtool_ops;
+			phydev = slave->dev->phydev;
+
+			if (phy_has_tsinfo(phydev))
+				ret = phy_ts_info(phydev, &ts_info);
+			else if (ops->get_ts_info)
+				ret = ops->get_ts_info(slave->dev, &ts_info);
+
+			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_TX_SOFTWARE)) {
+				sw_tx_support = true;
+				continue;
+			}
+
+			sw_tx_support = false;
+			break;
+		}
+		rcu_read_unlock();
 	}
 
+	ret = 0;
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
+	if (sw_tx_support)
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE;
+
 	info->phc_index = -1;
 
 out:
-- 
2.38.1

