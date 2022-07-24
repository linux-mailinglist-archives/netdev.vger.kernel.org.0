Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200F057F47B
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiGXJih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiGXJig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:38:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A6D1ADA1;
        Sun, 24 Jul 2022 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658655516; x=1690191516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WkLG4cHTgadqgxb/s+E1aYpqC0zcx5vUo/Uh+lTZzaE=;
  b=geU1fM/aQ8N2sFAtRTR7Lk2VdgbOcwuIbhwOH9nIqnxkLKdMALFWNlHG
   G5VMG2kiiTY53Xh3mlO3dv7Xvq21UKy0dJz6bihmxV7r/VWTaaAWB3ZIm
   G1kTi2niMxNjxby8nk9diE31fp2MBi8lldfeRwOhyc3O3vtbX5PTFtsiw
   u4NGZCiIjc7EhOKxZvrupdnecYgnqcsZpN6a/gMlNAjJbY54zVJGMr1Le
   1Ghczn2ptcbaSuQnX3J64xRI2d6yKgBGYdZ8wDkPMfjz1GDCdCj0ivd1h
   6D36KXKef0jmWqe7y/fDD/Oz8MBth0xlMxrFgLRMo36or0U8yMQ1mNonF
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="173397189"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:38:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Jul 2022 02:38:34 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:38:23 -0700
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
Subject: [Patch net-next v2 9/9] net: dsa: microchip: add support for phylink mac config
Date:   Sun, 24 Jul 2022 15:08:12 +0530
Message-ID: <20220724093812.30729-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724092823.24567-1-arun.ramadoss@microchip.com>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/microchip/ksz_common.c   | 18 ++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h   |  6 +++++-
 drivers/net/dsa/microchip/lan937x.h      |  3 ---
 drivers/net/dsa/microchip/lan937x_main.c | 16 ----------------
 6 files changed, 21 insertions(+), 33 deletions(-)

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
index 86a2a40cacb4..ed7d137cba99 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -222,7 +222,6 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = lan937x_phylink_get_caps,
-	.phylink_mac_config = lan937x_phylink_mac_config,
 	.setup_rgmii_delay = lan937x_setup_rgmii_delay,
 	.fdb_dump = ksz9477_fdb_dump,
 	.fdb_add = ksz9477_fdb_add,
@@ -1409,7 +1408,8 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	return dev->dev_ops->max_mtu(dev, port);
 }
 
-void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
+static void ksz_set_xmii(struct ksz_device *dev, int port,
+			 phy_interface_t interface)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
 	struct ksz_port *p = &dev->ports[port];
@@ -1495,6 +1495,20 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
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
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0b5c565d1ff4..764ada3a0f42 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -319,7 +319,6 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
-void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface);
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
@@ -447,6 +446,11 @@ static inline void ksz_regmap_unlock(void *__mtx)
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
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 423521a13c9e..4e0b1dccec27 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -17,8 +17,5 @@ void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config);
-void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
-				unsigned int mode,
-				const struct phylink_link_state *state);
 void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 797fe7f62394..daedd2bf20c1 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -383,22 +383,6 @@ void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port)
 	}
 }
 
-void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
-				unsigned int mode,
-				const struct phylink_link_state *state)
-{
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
-}
-
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-- 
2.36.1

