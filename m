Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7248627627
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 07:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbiKNGxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 01:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiKNGxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 01:53:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAF3BE22;
        Sun, 13 Nov 2022 22:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668408789; x=1699944789;
  h=from:to:cc:subject:date:message-id;
  bh=OMAW/EH2o+W96Ahwt8yKZ5v2TWWf93Wuusd98lfZN38=;
  b=nwP3aopwkMfQU2Pr0h78Ia8BeEa8iSMYPM0F24eCCI7VbXtvDaq+0K6m
   R2BDsn3scQ+3gepI8QIykWQgmZ4rKZgUtsLCSD/Ot0ELK81z+6h9/u/Op
   vR1+Gt1IOp6PXBMRGUMwR+wfSY1ojZFf9AQPTSjjLiqz8AOmFmzAQm6Tn
   Kd8CANExA8EXuOsNP0y+jyolDU6Hg1eHepAgIBM29ZUMK4T9909pQ8K+U
   Te2MpEBxdRRtnr1GLLdWaCbPKV7J9G/AzDyTp5AX1TksC5Gy73UR8ZO6g
   8t25TSUXipKAFSNPA1AwfvJCTMkbxzYdFkJnV1ed/sL6agp0vFJjNmoH/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="313701420"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="313701420"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 22:53:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="589257469"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="589257469"
Received: from aminuddin-ilbpg12.png.intel.com ([10.88.229.89])
  by orsmga003.jf.intel.com with ESMTP; 13 Nov 2022 22:53:05 -0800
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
Subject: [PATCH net v3] net: phy: marvell: add sleep time after enabling the loopback bit
Date:   Mon, 14 Nov 2022 14:53:02 +0800
Message-Id: <20221114065302.10625-1-aminuddin.jamaluddin@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleep time is added to ensure the phy to be ready after loopback
bit was set. This to prevent the phy loopback test from failing.

Fixes: 020a45aff119 ("net: phy: marvell: add Marvell specific PHY loopback")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>

---
V2 -> V3: Fix review comments from Jakub
V1: https://patchwork.kernel.org/project/netdevbpf/patch/20220825082238.11056-1-aminuddin.jamaluddin@intel.com/
---
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

