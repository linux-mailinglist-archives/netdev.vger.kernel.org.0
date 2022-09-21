Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B0D5BF6AD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiIUGvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiIUGuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:50:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA6E62ED;
        Tue, 20 Sep 2022 23:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663743023; x=1695279023;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F0izjSUxDVeayqAB/0pmEcpo0FNEGPrPQXnhaxmAic8=;
  b=I+MztIhsKxPZ/p+Va8Zu6n7FJ7jNvBeUi/8b9q3ImWl26fXhOgxDifER
   jHM3kkVB2yqhq+pebi/UNS3ND/edQAU7NisT/lVfSVyhhjDq97ujvuSlb
   cYZjx4H56TF0djzW98f/iLbVR4YdTle8DhenBjP5yrrsxrKwg/AluQFBE
   eiWrUsgdfXCMa9+gCywCw0DP8O5PZWdOtkwunttfWVHauuTUGj7QyHpnV
   zah2MOBY1RQTfB5FwXjt5YNfir29GPx24MkuAgyhQZ/8YIJmc5RGeLwu5
   Vb2olBfivGxfqE5S82vbk1Kw1y80KG9EwiOm0Wi+/kDeDK08ExRDmI3UL
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="174863270"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 23:50:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 23:50:21 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 23:50:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Fix double spaces inside lan8814_config_intr
Date:   Wed, 21 Sep 2022 08:54:44 +0200
Message-ID: <20220921065444.637067-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inside the function lan8814_config_intr, there are double spaces when
assigning the return value of phy_write to err.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c225df56b7d26..f5c3c5c2fe11f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2874,9 +2874,9 @@ static int lan8814_config_intr(struct phy_device *phydev)
 		if (err)
 			return err;
 
-		err =  phy_write(phydev, LAN8814_INTC, LAN8814_INT_LINK);
+		err = phy_write(phydev, LAN8814_INTC, LAN8814_INT_LINK);
 	} else {
-		err =  phy_write(phydev, LAN8814_INTC, 0);
+		err = phy_write(phydev, LAN8814_INTC, 0);
 		if (err)
 			return err;
 
-- 
2.33.0

