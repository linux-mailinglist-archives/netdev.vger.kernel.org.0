Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F047F55EAC5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiF1RPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiF1RPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:15:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70172CE16;
        Tue, 28 Jun 2022 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436520; x=1687972520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zF/2u1RfKmVqsubVwQwTjOVkYmvzUnki8PVBdFwZHuQ=;
  b=xvdrsmGz6nxIThh7h5HYN97LU0/j6+m7qaApw1cwQN5F4728j7SVELia
   PgvefR+orbIb+l6lYe/NcwkH1xq4S9jR3CVdvlR+JMH3cDN8cE4T/wQq/
   a7lDqh47PYzEFUnazH1Mz6CWl5jPjC7aRSciMdnPhas5oEdNZ8Te2Abo1
   Wc+i0v1ozVbjzDY2WqwZTeSARRrLgJJbvRLyzY+foRYc2sdEdgG6Oswzf
   XvwcycRD7k5imTpbWpAxkFtEnEzzWGnsiETYINSpeTl5LeBncYivHR3+v
   syHzKqbPyJveaqvC5SMeCsXX33OSN03VOT25IDOnsyuZ2E0qQuaUz+NG7
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="102138586"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:15:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:15:17 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:15:06 -0700
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
Subject: [Patch net-next 6/7] net: dsa: microchip: add P_STP_CTRL to ksz_chip_reg
Date:   Tue, 28 Jun 2022 22:43:28 +0530
Message-ID: <20220628171329.25503-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628171329.25503-1-arun.ramadoss@microchip.com>
References: <20220628171329.25503-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the stp_ctrl_reg from the ksz_chip_data to ksz_chip_reg
structure.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 17 +++++++-----
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 -
 drivers/net/dsa/microchip/ksz9477.c     |  7 +++--
 drivers/net/dsa/microchip/ksz9477_reg.h |  1 -
 drivers/net/dsa/microchip/ksz_common.c  | 37 +++++++++++++------------
 drivers/net/dsa/microchip/ksz_common.h  |  1 +
 6 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 264c960f715d..911aace42284 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -809,6 +809,9 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	u8 learn[DSA_MAX_PORTS];
 	int first, index, cnt;
 	struct ksz_port *p;
+	const u16 *regs;
+
+	regs = dev->info->regs;
 
 	if ((uint)port < dev->info->port_cnt) {
 		first = port;
@@ -822,9 +825,9 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 		p = &dev->ports[index];
 		if (!p->on)
 			continue;
-		ksz_pread8(dev, index, P_STP_CTRL, &learn[index]);
+		ksz_pread8(dev, index, regs[P_STP_CTRL], &learn[index]);
 		if (!(learn[index] & PORT_LEARN_DISABLE))
-			ksz_pwrite8(dev, index, P_STP_CTRL,
+			ksz_pwrite8(dev, index, regs[P_STP_CTRL],
 				    learn[index] | PORT_LEARN_DISABLE);
 	}
 	ksz_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_DYN_MAC_TABLE, true);
@@ -833,7 +836,7 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 		if (!p->on)
 			continue;
 		if (!(learn[index] & PORT_LEARN_DISABLE))
-			ksz_pwrite8(dev, index, P_STP_CTRL, learn[index]);
+			ksz_pwrite8(dev, index, regs[P_STP_CTRL], learn[index]);
 	}
 }
 
@@ -1236,11 +1239,11 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 				p->fiber = 1;
 		}
 		if (p->fiber)
-			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
-				     true);
+			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
+				     PORT_FORCE_FLOW_CTRL, true);
 		else
-			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
-				     false);
+			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
+				     PORT_FORCE_FLOW_CTRL, false);
 	}
 }
 
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 32d985296520..a848eb4c54cb 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -766,7 +766,6 @@
 #define P_TAG_CTRL			REG_PORT_CTRL_0
 #define P_MIRROR_CTRL			REG_PORT_CTRL_1
 #define P_802_1P_CTRL			REG_PORT_CTRL_2
-#define P_STP_CTRL			REG_PORT_CTRL_2
 #define P_PASS_ALL_CTRL			REG_PORT_CTRL_12
 #define P_INS_SRC_PVID_CTRL		REG_PORT_CTRL_12
 #define P_DROP_TAG_CTRL			REG_PORT_CTRL_13
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index fa498ad8ca40..0e808d27124c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -338,6 +338,7 @@ void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 
 void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
+	const u16 *regs = dev->info->regs;
 	u8 data;
 
 	regmap_update_bits(dev->regmap[0], REG_SW_LUE_CTRL_2,
@@ -346,12 +347,12 @@ void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 
 	if (port < dev->info->port_cnt) {
 		/* flush individual port */
-		ksz_pread8(dev, port, P_STP_CTRL, &data);
+		ksz_pread8(dev, port, regs[P_STP_CTRL], &data);
 		if (!(data & PORT_LEARN_DISABLE))
-			ksz_pwrite8(dev, port, P_STP_CTRL,
+			ksz_pwrite8(dev, port, regs[P_STP_CTRL],
 				    data | PORT_LEARN_DISABLE);
 		ksz_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_DYN_MAC_TABLE, true);
-		ksz_pwrite8(dev, port, P_STP_CTRL, data);
+		ksz_pwrite8(dev, port, regs[P_STP_CTRL], data);
 	} else {
 		/* flush all */
 		ksz_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_STP_TABLE, true);
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 6be2efe6334a..2ba0f4449130 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1620,7 +1620,6 @@
 #define P_BCAST_STORM_CTRL		REG_PORT_MAC_CTRL_0
 #define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
 #define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
-#define P_STP_CTRL			REG_PORT_LUE_MSTP_STATE
 #define P_PHY_CTRL			REG_PORT_PHY_CTRL
 #define P_RATE_LIMIT_CTRL		REG_PORT_MAC_IN_RATE_LIMIT
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 4992fea208b1..2f336b991d5a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -216,6 +216,7 @@ static const u16 ksz8795_regs[] = {
 	[P_REMOTE_STATUS]		= 0x08,
 	[P_SPEED_STATUS]		= 0x09,
 	[S_TAIL_TAG_CTRL]		= 0x0C,
+	[P_STP_CTRL]			= 0x02,
 };
 
 static const u32 ksz8795_masks[] = {
@@ -266,6 +267,7 @@ static const u16 ksz8863_regs[] = {
 	[P_REMOTE_STATUS]		= 0x0E,
 	[P_SPEED_STATUS]		= 0x0F,
 	[S_TAIL_TAG_CTRL]		= 0x03,
+	[P_STP_CTRL]			= 0x02,
 };
 
 static const u32 ksz8863_masks[] = {
@@ -301,6 +303,11 @@ static u8 ksz8863_shifts[] = {
 	[DYNAMIC_MAC_SRC_PORT]		= 20,
 };
 
+static const u16 ksz9477_regs[] = {
+	[P_STP_CTRL]			= 0x0B04,
+
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
@@ -318,7 +325,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
-		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
 		.start_ctrl_reg = 0x01,
@@ -358,7 +364,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
-		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
 		.start_ctrl_reg = 0x01,
@@ -384,7 +389,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
-		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
 		.start_ctrl_reg = 0x01,
@@ -409,7 +413,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8863_regs,
 		.masks = ksz8863_masks,
 		.shifts = ksz8863_shifts,
-		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
 		.start_ctrl_reg = 0x01,
@@ -431,7 +434,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -458,7 +461,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -484,7 +487,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -507,7 +510,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -532,7 +535,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -553,7 +556,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -574,7 +577,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -599,7 +602,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -624,7 +627,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
-		.stp_ctrl_reg = 0x0B04,
+		.regs = ksz9477_regs,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
 		.start_ctrl_reg = 0x0300,
@@ -1131,12 +1134,12 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
+	const u16 *regs;
 	u8 data;
-	int reg;
 
-	reg = dev->info->stp_ctrl_reg;
+	regs = dev->info->regs;
 
-	ksz_pread8(dev, port, reg, &data);
+	ksz_pread8(dev, port, regs[P_STP_CTRL], &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
 	switch (state) {
@@ -1160,7 +1163,7 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		return;
 	}
 
-	ksz_pwrite8(dev, port, reg, data);
+	ksz_pwrite8(dev, port, regs[P_STP_CTRL], data);
 
 	p = &dev->ports[port];
 	p->stp_state = state;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 18794f571687..2a9b2b59fa79 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -164,6 +164,7 @@ enum ksz_regs {
 	P_REMOTE_STATUS,
 	P_SPEED_STATUS,
 	S_TAIL_TAG_CTRL,
+	P_STP_CTRL,
 };
 
 enum ksz_masks {
-- 
2.36.1

