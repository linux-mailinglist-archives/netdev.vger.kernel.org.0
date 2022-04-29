Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A536515114
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376610AbiD2Qq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiD2Qq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:46:26 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266476AA6E;
        Fri, 29 Apr 2022 09:43:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p6so7593785pjm.1;
        Fri, 29 Apr 2022 09:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qa2sNF9UVsyenIFG9k1mMvPa48cGU1jWUY2xTbU/3nA=;
        b=FeNO2ZuS04djKaLsxq/ccp5hGY6CoX7D8qNqiA07bsdCCCbPUOTruq8/RCkkWKdeDE
         ozjGNXaAb2Akw03MG/yp9lR0ewYzFP9sfzRMC2QnHaaeyzWZW1Cdgo/RFcftGManYJwe
         +EwWMFuxV/j0a5WuaqY6IEsPhdkHA6+bY9onnbC9iA+lVbpuLKL9STIR6nagBFdqjDj9
         t1SRFkflD9avBbZF4WGFVrkw16Axe7uEtdZldjEniHVCNPo6dgeFsOeVuwytZlf+zJPg
         FLr28BgDio7M3AgMhbHB510KsPR7t/X3YHv21+hwuhu1ujIIpiaT9CLbvGTrzJA3E4Kt
         9lPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qa2sNF9UVsyenIFG9k1mMvPa48cGU1jWUY2xTbU/3nA=;
        b=0gMRHVz/DfjqtSGZzieUF/op7eq8HhcLhf5S13dJjfnoOR5l2Q8YaTJ6lW5jpMZifi
         aEgLvzEmaM5/tnCRDU0LrQV0grtjYTMX2dxVNaWbdwUnuuqaCNLh/h30e3EVtoNzB3GR
         7TpvzCCq3rClSwxiesLNNrdGh4WmyYmfed+VWvPltXEmrKj1Eh/C6sxcxYQS95vVAl9K
         QPaQQC5mPoRbBtTFTQl6seSsSyRjhKjxyG1Syhjd4pIAdLHVLUVmaQragMEJ//FEtz7v
         oordnsMWf2fscEe8A9Hq7ahu07TwpVQL0n7kfRbR9ZyFKu3l033lN+8P/l41p/DOa8Ho
         flYA==
X-Gm-Message-State: AOAM533RBKfIN4O0OYwZMVd5CyxKqr84pVVcF96fiKMU6XJfD0IMGk7S
        GeQYFVDoC5qTLS+UtxY8efXmI9NGCCs=
X-Google-Smtp-Source: ABdhPJyxu+zk7mM9kUqVXuS5CwlY0+A9ms13R+hjY6LvqU3KUMwLWAYq2S1T9OicDMYsnKWwr1/PhQ==
X-Received: by 2002:a17:90b:3e82:b0:1c7:2920:7c54 with SMTP id rj2-20020a17090b3e8200b001c729207c54mr4956401pjb.2.1651250586354;
        Fri, 29 Apr 2022 09:43:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i62-20020a639d41000000b003c14af50627sm6391333pgd.63.2022.04.29.09.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 09:43:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: convert to phylink_pcs
Date:   Fri, 29 Apr 2022 09:43:03 -0700
Message-Id: <20220429164303.712695-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

Convert B53 to use phylink_pcs for the serdes rather than hooking it
into the MAC-layer callbacks.

Fixes: 81c1681cbb9f ("net: dsa: b53: mark as non-legacy")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 36 +++-------------
 drivers/net/dsa/b53/b53_priv.h   | 24 ++++++-----
 drivers/net/dsa/b53/b53_serdes.c | 74 ++++++++++++++++++++++----------
 drivers/net/dsa/b53/b53_serdes.h |  9 ++--
 drivers/net/dsa/b53/b53_srab.c   |  4 +-
 5 files changed, 75 insertions(+), 72 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 77501f9c5915..fbb32aa49b24 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1354,46 +1354,25 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	config->legacy_pre_march2020 = false;
 }
 
-int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			       struct phylink_link_state *state)
+static struct phylink_pcs *b53_phylink_mac_select_pcs(struct dsa_switch *ds,
+						      int port,
+						      phy_interface_t interface)
 {
 	struct b53_device *dev = ds->priv;
-	int ret = -EOPNOTSUPP;
 
-	if ((phy_interface_mode_is_8023z(state->interface) ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII) &&
-	     dev->ops->serdes_link_state)
-		ret = dev->ops->serdes_link_state(dev, port, state);
+	if (!dev->ops->phylink_mac_select_pcs)
+		return NULL;
 
-	return ret;
+	return dev->ops->phylink_mac_select_pcs(dev, port, interface);
 }
-EXPORT_SYMBOL(b53_phylink_mac_link_state);
 
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
 			    const struct phylink_link_state *state)
 {
-	struct b53_device *dev = ds->priv;
-
-	if (mode == MLO_AN_PHY || mode == MLO_AN_FIXED)
-		return;
-
-	if ((phy_interface_mode_is_8023z(state->interface) ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII) &&
-	     dev->ops->serdes_config)
-		dev->ops->serdes_config(dev, port, mode, state);
 }
 EXPORT_SYMBOL(b53_phylink_mac_config);
 
-void b53_phylink_mac_an_restart(struct dsa_switch *ds, int port)
-{
-	struct b53_device *dev = ds->priv;
-
-	if (dev->ops->serdes_an_restart)
-		dev->ops->serdes_an_restart(dev, port);
-}
-EXPORT_SYMBOL(b53_phylink_mac_an_restart);
-
 void b53_phylink_mac_link_down(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       phy_interface_t interface)
@@ -2269,9 +2248,8 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.phy_write		= b53_phy_write16,
 	.adjust_link		= b53_adjust_link,
 	.phylink_get_caps	= b53_phylink_get_caps,
-	.phylink_mac_link_state	= b53_phylink_mac_link_state,
+	.phylink_mac_select_pcs	= b53_phylink_mac_select_pcs,
 	.phylink_mac_config	= b53_phylink_mac_config,
-	.phylink_mac_an_restart	= b53_phylink_mac_an_restart,
 	.phylink_mac_link_down	= b53_phylink_mac_link_down,
 	.phylink_mac_link_up	= b53_phylink_mac_link_up,
 	.port_enable		= b53_enable_port,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 3085b6cc7d40..795cbffd5c2b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -21,7 +21,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mutex.h>
-#include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/etherdevice.h>
 #include <net/dsa.h>
 
@@ -29,7 +29,6 @@
 
 struct b53_device;
 struct net_device;
-struct phylink_link_state;
 
 struct b53_io_ops {
 	int (*read8)(struct b53_device *dev, u8 page, u8 reg, u8 *value);
@@ -48,13 +47,10 @@ struct b53_io_ops {
 	void (*irq_disable)(struct b53_device *dev, int port);
 	void (*phylink_get_caps)(struct b53_device *dev, int port,
 				 struct phylink_config *config);
+	struct phylink_pcs *(*phylink_mac_select_pcs)(struct b53_device *dev,
+						      int port,
+						      phy_interface_t interface);
 	u8 (*serdes_map_lane)(struct b53_device *dev, int port);
-	int (*serdes_link_state)(struct b53_device *dev, int port,
-				 struct phylink_link_state *state);
-	void (*serdes_config)(struct b53_device *dev, int port,
-			      unsigned int mode,
-			      const struct phylink_link_state *state);
-	void (*serdes_an_restart)(struct b53_device *dev, int port);
 	void (*serdes_link_set)(struct b53_device *dev, int port,
 				unsigned int mode, phy_interface_t interface,
 				bool link_up);
@@ -85,8 +81,15 @@ enum {
 	BCM7278_DEVICE_ID = 0x7278,
 };
 
+struct b53_pcs {
+	struct phylink_pcs pcs;
+	struct b53_device *dev;
+	u8 lane;
+};
+
 #define B53_N_PORTS	9
 #define B53_N_PORTS_25	6
+#define B53_N_PCS	2
 
 struct b53_port {
 	u16		vlan_ctl_mask;
@@ -143,6 +146,8 @@ struct b53_device {
 	bool vlan_enabled;
 	unsigned int num_ports;
 	struct b53_port *ports;
+
+	struct b53_pcs pcs[B53_N_PCS];
 };
 
 #define b53_for_each_port(dev, i) \
@@ -336,12 +341,9 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
-int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			       struct phylink_link_state *state);
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
 			    const struct phylink_link_state *state);
-void b53_phylink_mac_an_restart(struct dsa_switch *ds, int port);
 void b53_phylink_mac_link_down(struct dsa_switch *ds, int port,
 			       unsigned int mode,
 			       phy_interface_t interface);
diff --git a/drivers/net/dsa/b53/b53_serdes.c b/drivers/net/dsa/b53/b53_serdes.c
index 555e5b372321..0690210770ff 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -17,6 +17,11 @@
 #include "b53_serdes.h"
 #include "b53_regs.h"
 
+static inline struct b53_pcs *pcs_to_b53_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct b53_pcs, pcs);
+}
+
 static void b53_serdes_write_blk(struct b53_device *dev, u8 offset, u16 block,
 				 u16 value)
 {
@@ -60,51 +65,47 @@ static u16 b53_serdes_read(struct b53_device *dev, u8 lane,
 	return b53_serdes_read_blk(dev, offset, block);
 }
 
-void b53_serdes_config(struct b53_device *dev, int port, unsigned int mode,
-		       const struct phylink_link_state *state)
+static int b53_serdes_config(struct phylink_pcs *pcs, unsigned int mode,
+			     phy_interface_t interface,
+			     const unsigned long *advertising,
+			     bool permit_pause_to_mac)
 {
-	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_device *dev = pcs_to_b53_pcs(pcs)->dev;
+	u8 lane = pcs_to_b53_pcs(pcs)->lane;
 	u16 reg;
 
-	if (lane == B53_INVALID_LANE)
-		return;
-
 	reg = b53_serdes_read(dev, lane, B53_SERDES_DIGITAL_CONTROL(1),
 			      SERDES_DIGITAL_BLK);
-	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+	if (interface == PHY_INTERFACE_MODE_1000BASEX)
 		reg |= FIBER_MODE_1000X;
 	else
 		reg &= ~FIBER_MODE_1000X;
 	b53_serdes_write(dev, lane, B53_SERDES_DIGITAL_CONTROL(1),
 			 SERDES_DIGITAL_BLK, reg);
+
+	return 0;
 }
-EXPORT_SYMBOL(b53_serdes_config);
 
-void b53_serdes_an_restart(struct b53_device *dev, int port)
+static void b53_serdes_an_restart(struct phylink_pcs *pcs)
 {
-	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_device *dev = pcs_to_b53_pcs(pcs)->dev;
+	u8 lane = pcs_to_b53_pcs(pcs)->lane;
 	u16 reg;
 
-	if (lane == B53_INVALID_LANE)
-		return;
-
 	reg = b53_serdes_read(dev, lane, B53_SERDES_MII_REG(MII_BMCR),
 			      SERDES_MII_BLK);
 	reg |= BMCR_ANRESTART;
 	b53_serdes_write(dev, lane, B53_SERDES_MII_REG(MII_BMCR),
 			 SERDES_MII_BLK, reg);
 }
-EXPORT_SYMBOL(b53_serdes_an_restart);
 
-int b53_serdes_link_state(struct b53_device *dev, int port,
-			  struct phylink_link_state *state)
+static void b53_serdes_get_state(struct phylink_pcs *pcs,
+				  struct phylink_link_state *state)
 {
-	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_device *dev = pcs_to_b53_pcs(pcs)->dev;
+	u8 lane = pcs_to_b53_pcs(pcs)->lane;
 	u16 dig, bmsr;
 
-	if (lane == B53_INVALID_LANE)
-		return 1;
-
 	dig = b53_serdes_read(dev, lane, B53_SERDES_DIGITAL_STATUS,
 			      SERDES_DIGITAL_BLK);
 	bmsr = b53_serdes_read(dev, lane, B53_SERDES_MII_REG(MII_BMSR),
@@ -133,10 +134,7 @@ int b53_serdes_link_state(struct b53_device *dev, int port,
 		state->pause |= MLO_PAUSE_RX;
 	if (dig & PAUSE_RESOLUTION_TX_SIDE)
 		state->pause |= MLO_PAUSE_TX;
-
-	return 0;
 }
-EXPORT_SYMBOL(b53_serdes_link_state);
 
 void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up)
@@ -158,6 +156,12 @@ void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 }
 EXPORT_SYMBOL(b53_serdes_link_set);
 
+static const struct phylink_pcs_ops b53_pcs_ops = {
+	.pcs_get_state = b53_serdes_get_state,
+	.pcs_config = b53_serdes_config,
+	.pcs_an_restart = b53_serdes_an_restart,
+};
+
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 				 struct phylink_config *config)
 {
@@ -187,9 +191,28 @@ void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 }
 EXPORT_SYMBOL(b53_serdes_phylink_get_caps);
 
+struct phylink_pcs *b53_serdes_phylink_mac_select_pcs(struct b53_device *dev,
+						      int port,
+						      phy_interface_t interface)
+{
+	u8 lane = b53_serdes_map_lane(dev, port);
+
+	if (lane == B53_INVALID_LANE || lane >= B53_N_PCS ||
+	    !dev->pcs[lane].dev)
+		return NULL;
+
+	if (!phy_interface_mode_is_8023z(interface) &&
+	    interface != PHY_INTERFACE_MODE_SGMII)
+		return NULL;
+
+	return &dev->pcs[lane].pcs;
+}
+EXPORT_SYMBOL(b53_serdes_phylink_mac_select_pcs);
+
 int b53_serdes_init(struct b53_device *dev, int port)
 {
 	u8 lane = b53_serdes_map_lane(dev, port);
+	struct b53_pcs *pcs;
 	u16 id0, msb, lsb;
 
 	if (lane == B53_INVALID_LANE)
@@ -212,6 +235,11 @@ int b53_serdes_init(struct b53_device *dev, int port)
 		 (id0 >> SERDES_ID0_REV_NUM_SHIFT) & SERDES_ID0_REV_NUM_MASK,
 		 (u32)msb << 16 | lsb);
 
+	pcs = &dev->pcs[lane];
+	pcs->dev = dev;
+	pcs->lane = lane;
+	pcs->pcs.ops = &b53_pcs_ops;
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_serdes_init);
diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index f47d5caa7557..ef81f5da5f81 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -107,14 +107,11 @@ static inline u8 b53_serdes_map_lane(struct b53_device *dev, int port)
 	return dev->ops->serdes_map_lane(dev, port);
 }
 
-int b53_serdes_get_link(struct b53_device *dev, int port);
-int b53_serdes_link_state(struct b53_device *dev, int port,
-			  struct phylink_link_state *state);
-void b53_serdes_config(struct b53_device *dev, int port, unsigned int mode,
-		       const struct phylink_link_state *state);
-void b53_serdes_an_restart(struct b53_device *dev, int port);
 void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up);
+struct phylink_pcs *b53_serdes_phylink_mac_select_pcs(struct b53_device *dev,
+						      int port,
+						      phy_interface_t interface);
 void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
 				 struct phylink_config *config);
 #if IS_ENABLED(CONFIG_B53_SERDES)
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index c51b716657db..da0b889880f6 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -491,10 +491,8 @@ static const struct b53_io_ops b53_srab_ops = {
 	.irq_disable = b53_srab_irq_disable,
 	.phylink_get_caps = b53_srab_phylink_get_caps,
 #if IS_ENABLED(CONFIG_B53_SERDES)
+	.phylink_mac_select_pcs = b53_serdes_phylink_mac_select_pcs,
 	.serdes_map_lane = b53_srab_serdes_map_lane,
-	.serdes_link_state = b53_serdes_link_state,
-	.serdes_config = b53_serdes_config,
-	.serdes_an_restart = b53_serdes_an_restart,
 	.serdes_link_set = b53_serdes_link_set,
 #endif
 };
-- 
2.25.1

