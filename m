Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244A6572054
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGLQGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbiGLQGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:06:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C068ECB454;
        Tue, 12 Jul 2022 09:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641960; x=1689177960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HfrLtQARUfLYvl2smrDtks/GlGY3cF5j+xJYbIT4q+I=;
  b=WysiZZ+wxrMoCRSvYSZtHxMuzmhccNGDCnX70yOGuASobJb3jZORLcNJ
   LoqYnLMKSDQKro42L1W81HCc0I+UBqJezSGs5O2g6yVoavMv4L4wNw8sz
   mOpdaO0V0OI1+RV09bqhGPUWbYyp3kSef+aru/TsczyDEpmcc4u309eF2
   8jlqRCVNQqblDK2aoyVvQAuxDTFin9LKw2ie2h0KAPgA7Xe0YENnxBrCJ
   lGzwa7dcNd5PaKpW3i7ysKvc4DzGe0FV1tRF1xgmTu/SwU00dY1/uGsX/
   aMYCovmqY0QBQzzz3GIMJP8YHGSluJQi4/KU+KraNH/ZNBnpWFWj7sp+X
   w==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="164388118"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:05:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:05:52 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:05:42 -0700
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
Subject: [RFC Patch net-next 10/10] net: dsa: microchip: add support for phylink mac config
Date:   Tue, 12 Jul 2022 21:33:08 +0530
Message-ID: <20220712160308.13253-11-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220712160308.13253-1-arun.ramadoss@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
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

This patch add support for phylink mac config for ksz series of
switches. All the files ksz8795, ksz9477 and lan937x uses the ksz common
xmii function. Instead of calling from the individual files, it is moved
to the ksz common phylink mac config function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c      |  7 -------
 drivers/net/dsa/microchip/ksz9477.c      |  4 ----
 drivers/net/dsa/microchip/ksz_common.c   | 17 ++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |  6 +++++-
 drivers/net/dsa/microchip/lan937x_main.c | 11 -----------
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8f807d8eace5..c79a5128235f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -26,11 +26,6 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
-static bool ksz_is_ksz88x3(struct ksz_device *dev)
-{
-	return dev->chip_id == 0x8830;
-}
-
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -1124,8 +1119,6 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 			 port);
 		p->interface = dev->compat_interface;
 	}
-
-	ksz_set_xmii(dev, port, p->interface);
 }
 
 void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 301283d1ba82..4b14d80d27ed 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -944,7 +944,6 @@ void ksz9477_get_caps(struct ksz_device *dev, int port,
 
 void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
-	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
 	u16 data16;
 	u8 member;
@@ -987,9 +986,6 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
 			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
 			     true);
-
-		/* configure MAC to 1G & RGMII mode */
-		ksz_set_xmii(dev, port, p->interface);
 	}
 
 	if (cpu_port)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 43c85ff8be5f..2aee4d31af5f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1402,7 +1402,8 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	return dev->dev_ops->max_mtu(dev, port);
 }
 
-void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
+static void ksz_set_xmii(struct ksz_device *dev, int port,
+			 phy_interface_t interface)
 {
 	const u8 *bitval = dev->info->bitval;
 	const u16 *regs = dev->info->regs;
@@ -1489,6 +1490,20 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (ksz_is_ksz88x3(dev))
+		return;
+
+	/* Internal PHYs */
+	if (dev->info->internal_phy[port])
+		return;
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(dev->dev, "In-band AN not supported!\n");
+		return;
+	}
+
+	ksz_set_xmii(dev, port, state->interface);
+
 	if (dev->dev_ops->phylink_mac_config)
 		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 364e5859139d..bd057a87c7e7 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -314,7 +314,6 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
-void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface);
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
@@ -434,6 +433,11 @@ static inline void ksz_regmap_unlock(void *__mtx)
 	mutex_unlock(mtx);
 }
 
+static inline bool ksz_is_ksz88x3(struct ksz_device *dev)
+{
+	return dev->chip_id == KSZ8830_CHIP_ID;
+}
+
 static inline int is_lan937x(struct ksz_device *dev)
 {
 	return dev->chip_id == LAN9370_CHIP_ID ||
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index db88ea567ba6..89f8282961a5 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -373,17 +373,6 @@ void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 	phy_interface_t interface = state->interface;
 	struct ksz_port *p = &dev->ports[port];
 
-	/* Internal PHYs */
-	if (dev->info->internal_phy[port])
-		return;
-
-	if (phylink_autoneg_inband(mode)) {
-		dev_err(dev->dev, "In-band AN not supported!\n");
-		return;
-	}
-
-	ksz_set_xmii(dev, port, state->interface);
-
 	/* if the delay is 0, do not enable DLL */
 	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    interface == PHY_INTERFACE_MODE_RGMII_RXID) {
-- 
2.36.1

