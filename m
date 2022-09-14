Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA45B7FE0
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 05:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiINDzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 23:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiINDyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 23:54:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6287DEA1;
        Tue, 13 Sep 2022 20:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663127682; x=1694663682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umtVYZ+QigwHUoZ+sYktZq77GUx+rkv3vQBWpLtRovI=;
  b=BNqldzNfgKF3wxizO2N0igQgAgL0WOcSmuldMUvKg2ego1JL1rT6Rp1y
   eGk8J9xaqepUbLTCt61vZFHGwB3fq5HxaIm7A4kmG3F6Nm2azdioYNAfj
   JZGpE+DiiNrZi6w+zaZqROIbVjt2W1CHSQM2HfNxAU8S4VXGzalEOwkKH
   mXFeHMHqiApIe3Vqi6KQDUoJeeVc4E+oRWATUl9NoLQbXQx78qoP86iDM
   gt/zHsw67jW0yQE4yS+NOkUUUTp2rZ1/Zwc3UKuX5AQfUwuKUVDUoIRCW
   Csgvmru77hLUF3FNJVsNwvJDayloF4QOFl61p6AwjHlFBERt5xZonMUMp
   w==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="173755939"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 20:54:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 20:54:28 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 20:54:22 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v2 2/5] net: dsa: microchip: enable phy interrupts only if interrupt enabled in dts
Date:   Wed, 14 Sep 2022 09:22:20 +0530
Message-ID: <20220914035223.31702-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220914035223.31702-1-arun.ramadoss@microchip.com>
References: <20220914035223.31702-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the lan937x_mdio_register function, phy interrupts are enabled
irrespective of irq is enabled in the switch. Now, the check is added to
enable the phy interrupt only if the irq is enabled in the switch.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/microchip/lan937x_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 7136d9c55315..1f4472c90a1f 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -235,15 +235,18 @@ static int lan937x_mdio_register(struct ksz_device *dev)
 
 	ds->slave_mii_bus = bus;
 
-	ret = lan937x_irq_phy_setup(dev);
-	if (ret)
-		return ret;
+	if (dev->irq > 0) {
+		ret = lan937x_irq_phy_setup(dev);
+		if (ret)
+			return ret;
+	}
 
 	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
 	if (ret) {
 		dev_err(ds->dev, "unable to register MDIO bus %s\n",
 			bus->id);
-		lan937x_irq_phy_free(dev);
+		if (dev->irq > 0)
+			lan937x_irq_phy_free(dev);
 	}
 
 	of_node_put(mdio_np);
-- 
2.36.1

