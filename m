Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496FE620A99
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiKHHpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiKHHos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:44:48 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F75D32057;
        Mon,  7 Nov 2022 23:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667893454; x=1699429454;
  h=from:to:cc:subject:date:message-id;
  bh=T7jYiJ8YBdJidKEszRodAoGwDG2x93waptWQVrXdBTY=;
  b=L6BOsDxMrVcqfYzJrASN1FLimz7EjXQx6Dj52MMyP9Eh5CFyaO2G0Boh
   z3MVbhHKDk58TbGb4MUAlRtxUt9vjhqrlAT08GaWmmgLsRHlYhnNR83k9
   HN9WvkBeK1yVHqH2UbhbrS4cPfJr/eJshO9q1Lx9DbtKRVGeR46kFy2r4
   DJJpoQPhQtNvu5SxjiSoc3j6Lcy9Q6fjKDRb7EPMIVFHjzLN1gV8EigHl
   mAbx/ImTKRWxFZPE6UwUR8vUPfZpiMXpnKenHT0/JBqLsWUuZ0+j9xV3G
   YSe95Jgr5x9rPvaX2aHEF3KUlUwZFIM7LIj78s445VjPWAQkm8KYPin94
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311786135"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="311786135"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 23:44:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811147737"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="811147737"
Received: from aminuddin-ilbpg12.png.intel.com ([10.88.229.89])
  by orsmga005.jf.intel.com with ESMTP; 07 Nov 2022 23:44:09 -0800
From:   Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com,
        aminuddin.jamaluddin@intel.com, hong.aun.looi@intel.com
Subject: [PATCH net-next v2] net: phy: marvell: add sleep time after enabling the loopback bit
Date:   Tue,  8 Nov 2022 15:40:05 +0800
Message-Id: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleep time is added to ensure the phy to be ready after loopback
bit was set. This to prevent the phy loopback test from failing.

---
V1: https://patchwork.kernel.org/project/netdevbpf/patch/20220825082238.11056-1-aminuddin.jamaluddin@intel.com/
---

Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
---
 drivers/net/phy/marvell.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a3e810705ce2..860610ba4d00 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2015,14 +2015,16 @@ static int m88e1510_loopback(struct phy_device *phydev, bool enable)
 		if (err < 0)
 			return err;
 
-		/* FIXME: Based on trial and error test, it seem 1G need to have
-		 * delay between soft reset and loopback enablement.
-		 */
-		if (phydev->speed == SPEED_1000)
-			msleep(1000);
+		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+				 BMCR_LOOPBACK);
 
-		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
-				  BMCR_LOOPBACK);
+		if (!err) {
+			/* It takes some time for PHY device to switch
+			 * into/out-of loopback mode.
+			 */
+			msleep(1000);
+		}
+		return err;
 	} else {
 		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
 		if (err < 0)
-- 
2.17.1

