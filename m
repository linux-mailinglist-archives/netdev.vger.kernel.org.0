Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6905AFD4C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiIGHWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiIGHWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:22:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ED29083E;
        Wed,  7 Sep 2022 00:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662535353; x=1694071353;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fUbcDpJ+PgoVRwfF+BmStAsXm74LtHyJMVudALJLaoc=;
  b=Jqh6JqiAuQXrVRmvRYpkNRW4EAkgGC10H96i8JQgoErOtZtTlQBHmHeL
   qRcAjZ5faTj16WcbxaP3YPg+yWu0Vhd0vfe9pC5uTPeeRePQOXArmPmRM
   1DKwO+vgY93RVe4o+tVC/R1ZoCBCT7M3BUzJA1WZF4nxuMnv3gsqw6wji
   gZGMbAoyEe8uUJ1kK8NXET6dlSlXSuMq+b6w0ARqoQf4nEvdc5diwVUhR
   VCvW13BdnbJ8wJ96f20j3UrNsA7kc4N9lEN1Px8FicK4J/hgpqO/Df2xg
   L+mQiYRQeiXTOoy/vbi2EImW7In238k3c3ZbtzgnvjzQ8XPrrh4ilXgx3
   g==;
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="179353148"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2022 00:22:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Sep 2022 00:22:32 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 7 Sep 2022 00:22:27 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [Patch net-next] net: dsa: microchip: add the support for set_ageing_time
Date:   Wed, 7 Sep 2022 12:50:39 +0530
Message-ID: <20220907072039.24833-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
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

KSZ9477 has the 11 bit ageing count value which is split across the two
registers. And LAN937x has the 20 bit ageing count which is also split
into two registers. Each count in the registers represents 1 second.
This patch add the support for ageing time for KSZ9477 and LAN937x
series of switch.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c      | 25 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477.h      |  1 +
 drivers/net/dsa/microchip/ksz9477_reg.h  |  4 +++-
 drivers/net/dsa/microchip/ksz_common.c   | 13 ++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  1 +
 drivers/net/dsa/microchip/lan937x.h      |  1 +
 drivers/net/dsa/microchip/lan937x_main.c | 17 ++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  |  6 ++++++
 8 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 42d7e4c12459..a6a0321a8931 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -963,6 +963,31 @@ void ksz9477_get_caps(struct ksz_device *dev, int port,
 		config->mac_capabilities |= MAC_1000FD;
 }
 
+int ksz9477_set_ageing_time(struct ksz_device *dev, unsigned int msecs)
+{
+	u32 secs = msecs / 1000;
+	u8 value;
+	u8 data;
+	int ret;
+
+	value = FIELD_GET(SW_AGE_PERIOD_7_0_M, secs);
+
+	ret = ksz_write8(dev, REG_SW_LUE_CTRL_3, value);
+	if (ret < 0)
+		return ret;
+
+	data = FIELD_GET(SW_AGE_PERIOD_10_8_M, secs);
+
+	ret = ksz_read8(dev, REG_SW_LUE_CTRL_0, &value);
+	if (ret < 0)
+		return ret;
+
+	value &= ~SW_AGE_CNT_M;
+	value |= FIELD_PREP(SW_AGE_CNT_M, data);
+
+	return ksz_write8(dev, REG_SW_LUE_CTRL_0, value);
+}
+
 void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct dsa_switch *ds = dev->ds;
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index ce87e4e09ada..00862c4cfb7f 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -16,6 +16,7 @@ u32 ksz9477_get_port_addr(int port, int offset);
 void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member);
 void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port);
 void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+int ksz9477_set_ageing_time(struct ksz_device *dev, unsigned int msecs);
 int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
 int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt);
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index ddf99d1e4bbd..53c68d286dd3 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -189,8 +189,9 @@
 
 #define SW_VLAN_ENABLE			BIT(7)
 #define SW_DROP_INVALID_VID		BIT(6)
-#define SW_AGE_CNT_M			0x7
+#define SW_AGE_CNT_M			GENMASK(5, 3)
 #define SW_AGE_CNT_S			3
+#define SW_AGE_PERIOD_10_8_M		GENMASK(10, 8)
 #define SW_RESV_MCAST_ENABLE		BIT(2)
 #define SW_HASH_OPTION_M		0x03
 #define SW_HASH_OPTION_CRC		1
@@ -225,6 +226,7 @@
 #define SW_PRIO_LOWEST_DA_SA		3
 
 #define REG_SW_LUE_CTRL_3		0x0313
+#define SW_AGE_PERIOD_7_0_M		GENMASK(7, 0)
 
 #define REG_SW_LUE_INT_STATUS		0x0314
 #define REG_SW_LUE_INT_ENABLE		0x0315
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ec2896a23834..c77cdcef1786 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -176,6 +176,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = ksz9477_port_setup,
+	.set_ageing_time = ksz9477_set_ageing_time,
 	.r_phy = ksz9477_r_phy,
 	.w_phy = ksz9477_w_phy,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
@@ -210,6 +211,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = lan937x_port_setup,
+	.set_ageing_time = lan937x_set_ageing_time,
 	.r_phy = lan937x_r_phy,
 	.w_phy = lan937x_w_phy,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
@@ -1639,6 +1641,16 @@ static void ksz_port_fast_age(struct dsa_switch *ds, int port)
 	dev->dev_ops->flush_dyn_mac_table(dev, port);
 }
 
+static int ksz_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (!dev->dev_ops->set_ageing_time)
+		return -EOPNOTSUPP;
+
+	return dev->dev_ops->set_ageing_time(dev, msecs);
+}
+
 static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
 			    const unsigned char *addr, u16 vid,
 			    struct dsa_db db)
@@ -2210,6 +2222,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.phylink_mac_link_up	= ksz_phylink_mac_link_up,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
+	.set_ageing_time	= ksz_set_ageing_time,
 	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 35346b39ce54..bf5efc0ef249 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -279,6 +279,7 @@ struct ksz_dev_ops {
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
 	void (*port_cleanup)(struct ksz_device *dev, int port);
 	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
+	int (*set_ageing_time)(struct ksz_device *dev, unsigned int msecs);
 	int (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 	int (*w_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 	void (*r_mib_cnt)(struct ksz_device *dev, int port, u16 addr,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 1b7f077946f3..8e9e66d6728d 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -19,4 +19,5 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config);
 void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port);
+int lan937x_set_ageing_time(struct ksz_device *dev, unsigned int msecs);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 4867aa62dd4c..9b6760b1e572 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -367,6 +367,23 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	return 0;
 }
 
+int lan937x_set_ageing_time(struct ksz_device *dev, unsigned int msecs)
+{
+	u32 secs = msecs / 1000;
+	u32 value;
+	int ret;
+
+	value = FIELD_GET(SW_AGE_PERIOD_7_0_M, secs);
+
+	ret = ksz_write8(dev, REG_SW_AGE_PERIOD__1, value);
+	if (ret < 0)
+		return ret;
+
+	value = FIELD_GET(SW_AGE_PERIOD_19_8_M, secs);
+
+	return ksz_write16(dev, REG_SW_AGE_PERIOD__2, value);
+}
+
 static void lan937x_set_tune_adj(struct ksz_device *dev, int port,
 				 u16 reg, u8 val)
 {
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index a3c669d86e51..5bc16a4c4441 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -62,6 +62,12 @@
 #define SW_FAST_AGING			BIT(1)
 #define SW_LINK_AUTO_AGING		BIT(0)
 
+#define REG_SW_AGE_PERIOD__1		0x0313
+#define SW_AGE_PERIOD_7_0_M		GENMASK(7, 0)
+
+#define REG_SW_AGE_PERIOD__2		0x0320
+#define SW_AGE_PERIOD_19_8_M		GENMASK(19, 8)
+
 #define REG_SW_MAC_CTRL_0		0x0330
 #define SW_NEW_BACKOFF			BIT(7)
 #define SW_PAUSE_UNH_MODE		BIT(1)

base-commit: 2786bcff28bd88955fc61adf9cb7370fbc182bad
-- 
2.36.1

