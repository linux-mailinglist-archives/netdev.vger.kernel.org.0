Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5877D5BA91E
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiIPJOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiIPJOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:14:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B646918371;
        Fri, 16 Sep 2022 02:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663319677; x=1694855677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umtVYZ+QigwHUoZ+sYktZq77GUx+rkv3vQBWpLtRovI=;
  b=ORc4WZsHYp0OwGlf5yy1QtFALurcV5LzNL7HCiLZM3wtQlFzpaiX0p4J
   ogP6XBZ9dXbYn3PwLHypFHPoR61LpHrSH8IS4P+vsmk73BsoIkDs9ZyPK
   T4KrBu+GLcpn1du6sa3RStM4AwunXXAzLfMZG9TJYNufndMmty0Gmp+gd
   DnlIcilgVqUbEUYHcA1guR5jgNGfiyvIfWQlnLuDVPeDLkinfgp8Jqmuv
   +enV8TVsbAiuyQF0QSOqHmaeRJNMMpnVrCLCMux1IhpE2KoFPANZWPD7/
   e0sCwk1wKCbX9yQCLL0j6WHcW2ezoLBTcG7yXIlWGkja2tlVLdoViwolw
   A==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="180777592"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 02:14:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 02:14:35 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 02:14:29 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v3 2/6] net: dsa: microchip: enable phy interrupts only if interrupt enabled in dts
Date:   Fri, 16 Sep 2022 14:43:44 +0530
Message-ID: <20220916091348.8570-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220916091348.8570-1-arun.ramadoss@microchip.com>
References: <20220916091348.8570-1-arun.ramadoss@microchip.com>
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

