Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F766E57E8
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 05:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjDRDsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 23:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRDsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 23:48:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2385635B7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 20:48:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a66e7a52d3so8769365ad.0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 20:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681789730; x=1684381730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0MQPcu/3DRhhogPAtdnzND4rVzHm/i+lV8ZUFPSTjNg=;
        b=aKoDiJvaCdgYyxzNsZ5KCap64TrjxWMeV51nkYjthup3nc2CuIRpsMIUE4lUf2fJBi
         703Bf0dFkYXPQLzYTGZXINulOHFaVm5q6xmUgf4bljRYMms2bO+thHBi1VcKmBBoTsJq
         5xMi2dymOre1z/JAOhfjWVYb8wHa6k1N3WzpeyJ2vKt7jk6nbJk7EKEnOb2CEIHn1sQS
         Og+hjnLbgcJ5ycWKO0KuyX6jM4q8lO6cSc13Mq2iUCeZcplCzBbVE1fCmo9r480ufyA0
         eLpGXxJTftQxGY53gSLx4Vn8rin8Nd2NMoVuTQibi1NvZZ1W6zDyTZNBEPq+sfMv+prV
         sHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681789730; x=1684381730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0MQPcu/3DRhhogPAtdnzND4rVzHm/i+lV8ZUFPSTjNg=;
        b=PDnu3KFSuPOyIgFIAIqNqTm5eDE/ecEmqayvJYt9RVudL125gbftX6sjcJJKDtdq9C
         2axkJx5o8sI/bLRGzVNrRPrsy2JSX2SYvFmIyocLC/Vpo5bzx5w1tfv9frr4UFWr6i6A
         2rJUePM0sWnd0bbw4BWFNGe7ZwOzUyJUlqckLxX/HENF8DDaVsOss8wI+CMl8nMAD55Z
         dkLIQJWxByDyrL3j2q3+A+20mZUJW7ZW3b1NOvYtGscB6aks5PkS5c5ofCe0JcuSyxa5
         wQWA+SuMd1vNXcEdAGsugJztTxE4SYVoLxAgcO6sHGomCK9ew/HU2n4qKbCQU5rdI7T0
         KxMA==
X-Gm-Message-State: AAQBX9fysA2dY4O/kcxm/P/DR+c8KzyxBfaQHeBLv3V7en/a+FHt9dP8
        nLmhQQ1ih46NpXVCHW3dnRR9DhoCXRnM0ZDqZ7A=
X-Google-Smtp-Source: AKy350Ya3E3EZzAZ08AYV9e5vUk3pAOTnIfoUSeu4/b1fJlvxWDCiwWT6T0Q87U4pVPrFHL/wfgg7w==
X-Received: by 2002:a17:903:1250:b0:1a6:46e0:6a15 with SMTP id u16-20020a170903125000b001a646e06a15mr945179plh.44.1681789729842;
        Mon, 17 Apr 2023 20:48:49 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jw18-20020a170903279200b001a6d4ffc760sm3088806plb.244.2023.04.17.20.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 20:48:48 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCHv5 net-next] bonding: add software tx timestamping support
Date:   Tue, 18 Apr 2023 11:48:41 +0800
Message-Id: <20230418034841.2566262-1-liuhangbin@gmail.com>
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

Add a note that the get_ts_info may be called with RCU, or rtnl or
reference on the device in ethtool.h>

Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v5: remove ASSERT_RTNL since bond_ethtool_get_ts_info could be called
    without RTNL. Update ethtool kdoc.
v4: add ASSERT_RTNL to make sure bond_ethtool_get_ts_info() called via
    RTNL. Only check _TX_SOFTWARE for the slaves.
v3: remove dev_hold/dev_put. remove the '\' for line continuation.
v2: check each slave's ts info to make sure bond support sw tx
    timestamping
---
 drivers/net/bonding/bond_main.c | 30 ++++++++++++++++++++++++++++++
 include/linux/ethtool.h         |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8cc9a74789b7..db7e650d9ebb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5696,9 +5696,13 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
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
 
 	rcu_read_lock();
@@ -5717,10 +5721,36 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
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
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 798d35890118..62b61527bcc4 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -711,6 +711,7 @@ struct ethtool_mm_stats {
  * @get_dump_data: Get dump data.
  * @set_dump: Set dump specific flags to the device.
  * @get_ts_info: Get the time stamping and PTP hardware clock capabilities.
+ *	It may be called with RCU, or rtnl or reference on the device.
  *	Drivers supporting transmit time stamps in software should set this to
  *	ethtool_op_get_ts_info().
  * @get_module_info: Get the size and type of the eeprom contained within
-- 
2.38.1

