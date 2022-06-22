Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD349554693
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357465AbiFVJLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiFVJLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:11:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02F734BBF;
        Wed, 22 Jun 2022 02:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888978; x=1687424978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c+k1q+KXw+SXhUb+5wE0zhc4M7ZwXfXg+K14YzomTJg=;
  b=YRUZt7DVBhq3UM7PO/RtLn+NzjZAdqWNUPFskOZtnk0jRlkBbiotpaJM
   704n9W5QoUON2Q61DnSRaWx0/dT1E1aE185IEDRehoutCR4Hj3Y7kzIrA
   FzEWvkoE6VjSaA2uNl6iR0B/GqueIPYG4jzc2BHudsqwG7ECD+MbeAuJR
   3Y4PCGyk3E4kfLW1scjE8jHycfY9CInNIEfEMdMxxFofFwHO4dt6dv4zV
   LguUw/rORKH8d4oR/dOQ90jVj2zBb/W9vnFpOZIE4hxEgPsg+J88gRCSM
   k1rNgkgAasYug4K6MOP8Y0GcQ4Xps3t6r9NGEN1Bs5xrH/SZWcddve1MR
   A==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="101185567"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:09:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:09:37 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:09:32 -0700
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
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 12/13] net: dsa: microchip: remove the ksz8/ksz9477_switch_register
Date:   Wed, 22 Jun 2022 14:34:24 +0530
Message-ID: <20220622090425.17709-13-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch delete the ksz8_switch_register and ksz9477_switch_register
since both are calling the ksz_switch_register function. Instead the
ksz_switch_register is called from the probe function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 6 ------
 drivers/net/dsa/microchip/ksz8795_spi.c | 2 +-
 drivers/net/dsa/microchip/ksz8863_smi.c | 2 +-
 drivers/net/dsa/microchip/ksz9477.c     | 6 ------
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 drivers/net/dsa/microchip/ksz9477_spi.c | 2 +-
 drivers/net/dsa/microchip/ksz_common.h  | 3 ---
 7 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 78fa33a23b4e..df7d782e3fcd 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1475,12 +1475,6 @@ void ksz8_switch_exit(struct ksz_device *dev)
 	ksz8_reset_switch(dev);
 }
 
-int ksz8_switch_register(struct ksz_device *dev)
-{
-	return ksz_switch_register(dev);
-}
-EXPORT_SYMBOL(ksz8_switch_register);
-
 MODULE_AUTHOR("Tristram Ha <Tristram.Ha@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ8795 Series Switch DSA Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
index 3f27aee9b6d3..9d74e59624a6 100644
--- a/drivers/net/dsa/microchip/ksz8795_spi.c
+++ b/drivers/net/dsa/microchip/ksz8795_spi.c
@@ -82,7 +82,7 @@ static int ksz8795_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	ret = ksz8_switch_register(dev);
+	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index b6f99e641dca..d71df05b8b7b 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -174,7 +174,7 @@ static int ksz8863_smi_probe(struct mdio_device *mdiodev)
 	if (mdiodev->dev.platform_data)
 		dev->pdata = mdiodev->dev.platform_data;
 
-	ret = ksz8_switch_register(dev);
+	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index fe471626350f..fa498ad8ca40 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1343,12 +1343,6 @@ void ksz9477_switch_exit(struct ksz_device *dev)
 	ksz9477_reset_switch(dev);
 }
 
-int ksz9477_switch_register(struct ksz_device *dev)
-{
-	return ksz_switch_register(dev);
-}
-EXPORT_SYMBOL(ksz9477_switch_register);
-
 MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch DSA Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 4ade64387f3a..99966514d444 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -41,7 +41,7 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.platform_data)
 		dev->pdata = i2c->dev.platform_data;
 
-	ret = ksz9477_switch_register(dev);
+	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 1bc8b0cbe458..2ee0601bc014 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -54,7 +54,7 @@ static int ksz9477_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	ret = ksz9477_switch_register(dev);
+	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
 	if (ret)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 4d8f09b67c5f..0e7f15efbb79 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -220,9 +220,6 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
 int ksz_switch_register(struct ksz_device *dev);
 void ksz_switch_remove(struct ksz_device *dev);
 
-int ksz8_switch_register(struct ksz_device *dev);
-int ksz9477_switch_register(struct ksz_device *dev);
-
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
-- 
2.36.1

