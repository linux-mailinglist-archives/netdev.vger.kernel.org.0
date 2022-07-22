Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D29657DF2A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbiGVJim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiGVJiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:38:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CA6C9E66;
        Fri, 22 Jul 2022 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658482019; x=1690018019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MM1cMaFcLeUQ5sGlQpe1ZK4RujwLzQviZH7va91CasE=;
  b=AV7x10IhewzTQpHSA5Wa9H+keCGUHlrYkWcWBMEoIP0lxVJCtcJ0b1eS
   PsVH1XIVrtRb4Tryb6UPhkK/haS+7l3vBQBIJKSSdNRdNuUSOr3gZzIem
   +8XbyLFie+820LaAPhkGHXt0fmOi6Y0vO0lky1a3vfSI9hOAlm4bNLI4C
   Hyl7628Ujgd5aY/DLE2n/7Ttx+20ah+wYiSi4G8NB8Js5B37dJPXM6o++
   bHdmB32I7JiiTjUH/7ImdGgXTqJ4ddmrXwn4vQFWE9aoFNb5MfuhHjZcl
   qDfAk+Q6RNuNo3xcHaWcL+DBO1IB8ZH+/UVeH4zxVEwYPjr6NwVJ8sUj/
   w==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="173385095"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:26:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 22 Jul 2022 02:26:58 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 22 Jul 2022 02:26:53 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Arun Ramadoss" <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [Patch net-next v1 8/9] net: dsa: microchip: ksz8795: use common xmii function
Date:   Fri, 22 Jul 2022 14:54:58 +0530
Message-ID: <20220722092459.18653-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722092459.18653-1-arun.ramadoss@microchip.com>
References: <20220722092459.18653-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the ksz8795 cpu configuration to use the ksz common
xmii set functions.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 35 +------------------------
 drivers/net/dsa/microchip/ksz8795_reg.h |  8 ------
 2 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 911aace42284..8f807d8eace5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1116,7 +1116,6 @@ void ksz8_port_mirror_del(struct ksz_device *dev, int port,
 static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 {
 	struct ksz_port *p = &dev->ports[port];
-	u8 data8;
 
 	if (!p->interface && dev->compat_interface) {
 		dev_warn(dev->dev,
@@ -1126,39 +1125,7 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 		p->interface = dev->compat_interface;
 	}
 
-	/* Configure MII interface for proper network communication. */
-	ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
-	data8 &= ~PORT_INTERFACE_TYPE;
-	data8 &= ~PORT_GMII_1GPS_MODE;
-	switch (p->interface) {
-	case PHY_INTERFACE_MODE_MII:
-		p->phydev.speed = SPEED_100;
-		break;
-	case PHY_INTERFACE_MODE_RMII:
-		data8 |= PORT_INTERFACE_RMII;
-		p->phydev.speed = SPEED_100;
-		break;
-	case PHY_INTERFACE_MODE_GMII:
-		data8 |= PORT_GMII_1GPS_MODE;
-		data8 |= PORT_INTERFACE_GMII;
-		p->phydev.speed = SPEED_1000;
-		break;
-	default:
-		data8 &= ~PORT_RGMII_ID_IN_ENABLE;
-		data8 &= ~PORT_RGMII_ID_OUT_ENABLE;
-		if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-		    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-			data8 |= PORT_RGMII_ID_IN_ENABLE;
-		if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-		    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-			data8 |= PORT_RGMII_ID_OUT_ENABLE;
-		data8 |= PORT_GMII_1GPS_MODE;
-		data8 |= PORT_INTERFACE_RGMII;
-		p->phydev.speed = SPEED_1000;
-		break;
-	}
-	ksz_write8(dev, REG_PORT_5_CTRL_6, data8);
-	p->phydev.duplex = 1;
+	ksz_set_xmii(dev, port, p->interface);
 }
 
 void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index a848eb4c54cb..77487d611824 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -170,15 +170,7 @@
 #define REG_PORT_5_CTRL_6		0x56
 
 #define PORT_MII_INTERNAL_CLOCK		BIT(7)
-#define PORT_GMII_1GPS_MODE		BIT(6)
-#define PORT_RGMII_ID_IN_ENABLE		BIT(4)
-#define PORT_RGMII_ID_OUT_ENABLE	BIT(3)
 #define PORT_GMII_MAC_MODE		BIT(2)
-#define PORT_INTERFACE_TYPE		0x3
-#define PORT_INTERFACE_MII		0
-#define PORT_INTERFACE_RMII		1
-#define PORT_INTERFACE_GMII		2
-#define PORT_INTERFACE_RGMII		3
 
 #define REG_PORT_1_CTRL_7		0x17
 #define REG_PORT_2_CTRL_7		0x27
-- 
2.36.1

