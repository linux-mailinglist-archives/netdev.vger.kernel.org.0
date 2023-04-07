Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366BF6DA8C8
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 08:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjDGGMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 02:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbjDGGMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 02:12:44 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E342976D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 23:12:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id ix20so39322059plb.3
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 23:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680847959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpJgk8U3UHJCWTgJkiRH7igjtd0+UtUKprsISkm8p+g=;
        b=nQ73Y1SmVhTWx4B7NM/ggy6VE0EeryVPvJRovEsGF5xmLubwkTOW7Zdy+P6LySRYGq
         BF3jAigCcc0pta+ZcPm4rq9yu1pqSPgR6HJz1AtfLYU1HOjrUu3xLpLXEtIYClltwwxN
         Fph0JHOyj3KXd0lplRfca1cqQge9rBdyAiGwk2Ic9WlWIe9EsX5CQrvmHD4PBrCiqWTr
         oNSb47GePUnJUx8d3iBx/5dJ9jKB+F2leTvYxoIhpxeFH3xlr4gO3LTPiN6cdqvvjSRN
         Fcd3X1h2SngA+VhDyZ3uii3VwnBVnfSeL3c7lQzK2YH7N491vy9O+nJdp5G0Bz3cD1hz
         6ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680847959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZpJgk8U3UHJCWTgJkiRH7igjtd0+UtUKprsISkm8p+g=;
        b=XpZFlJ1N4N+UK7NvFvBtXZ28JDTpgjZI3SYJD9fTpDnuXYmZRoohfsPFpjihlvzVY0
         Y/m+fZNsp3kvPLnKCHBmKv22MMMHJvCYSHynL6E+HQLJ8kvd61MKpHYshjaGeJDqUNkd
         KWZw/EpDnj2qGFPyDgBOYxb9WJa4bt5OMYPfP84slxXItZOnFoDwMfQTbI9Dq6D7VtYd
         5z3tvCLM7fKEv4POS6zRjouqRM2IJZq8ngDUTBiKOC8k1mea/PAlqPSnEIpZnM2sUG6X
         xfyUWlIwZWY73HBV+HhEEsDQCVLmIIDNZY6DzNHvklnn9Sg1xWBc/4GsIUugMZGCRMWQ
         xAAQ==
X-Gm-Message-State: AAQBX9fAc7pouB29MrVBh+f45x8DG2XQZ7Z+S4J8c2CNHhAWVOS0OPws
        Sd/q1dzdLXs/q3Owvd1PdjqtShcM9ez0AA==
X-Google-Smtp-Source: AKy350a9RMKAGqWkJgGTlRBXuJDvTGh2f3IHNPdx4TGV95yiSLL9OyA8ZmdaLOQbVyp0p7ZEOfvlJA==
X-Received: by 2002:a17:90b:1d88:b0:23d:2415:c9a9 with SMTP id pf8-20020a17090b1d8800b0023d2415c9a9mr1294895pjb.34.1680847959277;
        Thu, 06 Apr 2023 23:12:39 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id h1-20020a17090a9c0100b00244b13111e6sm645838pjp.38.2023.04.06.23.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 23:12:38 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCHv2 net-next] bonding: add software tx timestamping support
Date:   Fri,  7 Apr 2023 14:12:28 +0800
Message-Id: <20230407061228.1035431-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++++++++++++--
 include/uapi/linux/net_tstamp.h |  3 +++
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00646aa315c3..994efc777a77 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5686,9 +5686,13 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				    struct ethtool_ts_info *info)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct ethtool_ts_info ts_info;
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	bool soft_support = false;
+	struct list_head *iter;
+	struct slave *slave;
 	int ret = 0;
 
 	rcu_read_lock();
@@ -5707,10 +5711,41 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 			ret = ops->get_ts_info(real_dev, info);
 			goto out;
 		}
+	} else {
+		/* Check if all slaves support software rx/tx timestamping */
+		rcu_read_lock();
+		bond_for_each_slave_rcu(bond, slave, iter) {
+			ret = -1;
+			dev_hold(slave->dev);
+			ops = slave->dev->ethtool_ops;
+			phydev = slave->dev->phydev;
+
+			if (phy_has_tsinfo(phydev))
+				ret = phy_ts_info(phydev, &ts_info);
+			else if (ops->get_ts_info)
+				ret = ops->get_ts_info(slave->dev, &ts_info);
+
+			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) == \
+				    SOF_TIMESTAMPING_SOFTRXTX) {
+				dev_put(slave->dev);
+				soft_support = true;
+				continue;
+			}
+
+			soft_support = false;
+			dev_put(slave->dev);
+			break;
+		}
+		rcu_read_unlock();
 	}
 
-	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-				SOF_TIMESTAMPING_SOFTWARE;
+	ret = 0;
+	if (soft_support) {
+		info->so_timestamping = SOF_TIMESTAMPING_SOFTRXTX;
+	} else {
+		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+					SOF_TIMESTAMPING_SOFTWARE;
+	}
 	info->phc_index = -1;
 
 out:
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index a2c66b3d7f0f..2adaa0008434 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -48,6 +48,9 @@ enum {
 					 SOF_TIMESTAMPING_TX_SCHED | \
 					 SOF_TIMESTAMPING_TX_ACK)
 
+#define SOF_TIMESTAMPING_SOFTRXTX (SOF_TIMESTAMPING_TX_SOFTWARE | \
+				   SOF_TIMESTAMPING_RX_SOFTWARE | \
+				   SOF_TIMESTAMPING_SOFTWARE)
 /**
  * struct so_timestamping - SO_TIMESTAMPING parameter
  *
-- 
2.38.1

