Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6032654F78
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 12:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiLWLKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 06:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLWLKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 06:10:06 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F0E2708;
        Fri, 23 Dec 2022 03:10:02 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2BNB9cLQ044189;
        Fri, 23 Dec 2022 05:09:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1671793778;
        bh=mNCoKE/TWUa09ZiqGjhw7URnQ8IVmhagCy1zNqrAbns=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=sptL37LEIc5HR4T53cRgPFkHDCLj/4mMIeRJYWZ2eOme7IFSt/HrIyH7u1SQxup0l
         qHKhMM/rL+uVf9laBt4ldBt3HFk8aPV8yzMk8Qe5I5l0DxsVm8Hs7IR2DF/uQM4V7D
         V8goG7tNMN9bNVAqw61r3I9pkHipCChgz3pBS+3E=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2BNB9cjc084933
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Dec 2022 05:09:38 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 23
 Dec 2022 05:09:38 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 23 Dec 2022 05:09:38 -0600
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2BNB9b2Q058739;
        Fri, 23 Dec 2022 05:09:37 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 2BNB9aKu001021;
        Fri, 23 Dec 2022 05:09:36 -0600
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Date:   Fri, 23 Dec 2022 16:39:30 +0530
Message-ID: <20221223110930.1337536-3-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221223110930.1337536-1-danishanwar@ti.com>
References: <20221223110930.1337536-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

This is the Ethernet driver for TI AM654 Silicon rev. 2
with the ICSSG PRU Sub-system running dual-EMAC firmware.

The Programmable Real-time Unit and Industrial Communication Subsystem
Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
SoCs. This subsystem is provided for the use cases like implementation of
custom peripheral interfaces, offloading of tasks from the other
processor cores of the SoC, etc.

Every ICSSG core has two Programmable Real-Time Unit(PRUs),
two auxiliary Real-Time Transfer Unit (RT_PRUs), and
two Transmit Real-Time Transfer Units (TX_PRUs). Each one of these runs
its own firmware. Every ICSSG core has two MII ports connect to these
PRUs and also a MDIO port.

The cores can run different firmwares to support different protocols and
features like switch-dev, timestamping, etc.

It uses System DMA to transfer and receive packets and
shared memory register emulation between the firmware and
driver for control and configuration.

This patch adds support for basic EMAC functionality with 1Gbps
and 100Mbps link speed. 10M and half duplex mode are not supported
currently as they require IEP, the support for which will be added later.
Support for switch-dev, timestamp, etc. will be added later
by subsequent patch series.

Signed-off-by: Roger Quadros <rogerq@ti.com>
[Vignesh Raghavendra: add 10M full duplex support]
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
[Grygorii Strashko: add support for half duplex operation]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
---
 drivers/net/ethernet/ti/Kconfig            |   13 +
 drivers/net/ethernet/ti/Makefile           |    2 +
 drivers/net/ethernet/ti/icssg_classifier.c |  368 ++++
 drivers/net/ethernet/ti/icssg_config.c     |  440 +++++
 drivers/net/ethernet/ti/icssg_config.h     |  200 +++
 drivers/net/ethernet/ti/icssg_ethtool.c    |  320 ++++
 drivers/net/ethernet/ti/icssg_mii_cfg.c    |  104 ++
 drivers/net/ethernet/ti/icssg_mii_rt.h     |  151 ++
 drivers/net/ethernet/ti/icssg_prueth.c     | 1882 ++++++++++++++++++++
 drivers/net/ethernet/ti/icssg_prueth.h     |  246 +++
 drivers/net/ethernet/ti/icssg_switch_map.h |  183 ++
 include/linux/pruss.h                      |    1 +
 12 files changed, 3910 insertions(+)
 create mode 100644 drivers/net/ethernet/ti/icssg_classifier.c
 create mode 100644 drivers/net/ethernet/ti/icssg_config.c
 create mode 100644 drivers/net/ethernet/ti/icssg_config.h
 create mode 100644 drivers/net/ethernet/ti/icssg_ethtool.c
 create mode 100644 drivers/net/ethernet/ti/icssg_mii_cfg.c
 create mode 100644 drivers/net/ethernet/ti/icssg_mii_rt.h
 create mode 100644 drivers/net/ethernet/ti/icssg_prueth.c
 create mode 100644 drivers/net/ethernet/ti/icssg_prueth.h
 create mode 100644 drivers/net/ethernet/ti/icssg_switch_map.h

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index fb30bc5d56cb..48eb63816be6 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -182,4 +182,17 @@ config CPMAC
 	help
 	  TI AR7 CPMAC Ethernet support
 
+config TI_ICSSG_PRUETH
+	tristate "TI Gigabit PRU Ethernet driver"
+	select PHYLIB
+	depends on PRU_REMOTEPROC
+	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
+	help
+	  Support dual Gigabit Ethernet ports over the ICSSG PRU Subsystem.
+	  This subsystem is available starting with the AM65 platform.
+
+	  This driver requires firmware binaries which will run on the PRUs
+	  to support the Ethernet operation. Currently, it supports Ethernet
+	  with 1G and 100M link speed.
+
 endif # NET_VENDOR_TI
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index 75f761efbea7..8ef5469dc20c 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -28,3 +28,5 @@ obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o
 ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cpsw_ale.o k3-cppi-desc-pool.o am65-cpsw-qos.o
 ti-am65-cpsw-nuss-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV) += am65-cpsw-switchdev.o
 obj-$(CONFIG_TI_K3_AM65_CPTS) += am65-cpts.o
+obj-$(CONFIG_TI_ICSSG_PRUETH) += icssg-prueth.o
+icssg-prueth-y := icssg_prueth.o icssg_classifier.o icssg_ethtool.o icssg_config.o k3-cppi-desc-pool.o icssg_mii_cfg.o
diff --git a/drivers/net/ethernet/ti/icssg_classifier.c b/drivers/net/ethernet/ti/icssg_classifier.c
new file mode 100644
index 000000000000..26fa7d86e092
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_classifier.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Texas Instruments ICSSG Ethernet Driver
+ *
+ * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/types.h>
+#include <linux/regmap.h>
+
+#include "icssg_prueth.h"
+
+#define ICSSG_NUM_CLASSIFIERS	16
+#define ICSSG_NUM_FT1_SLOTS	8
+#define ICSSG_NUM_FT3_SLOTS	16
+
+#define ICSSG_NUM_CLASSIFIERS_IN_USE	5
+
+/* Filter 1 - FT1 */
+#define FT1_NUM_SLOTS	8
+#define FT1_SLOT_SIZE	0x10	/* bytes */
+
+/* offsets from FT1 slot base i.e. slot 1 start */
+#define FT1_DA0		0x0
+#define FT1_DA1		0x4
+#define FT1_DA0_MASK	0x8
+#define FT1_DA1_MASK	0xc
+
+#define FT1_N_REG(slize, n, reg)	(offs[slice].ft1_slot_base + FT1_SLOT_SIZE * (n) + (reg))
+
+#define FT1_LEN_MASK	GENMASK(19, 16)
+#define FT1_LEN_SHIFT	16
+#define FT1_LEN(len)	(((len) << FT1_LEN_SHIFT) & FT1_LEN_MASK)
+
+#define FT1_START_MASK	GENMASK(14, 0)
+#define FT1_START(start)	((start) & FT1_START_MASK)
+
+#define FT1_MATCH_SLOT(n)	(GENMASK(23, 16) & (BIT(n) << 16))
+
+enum ft1_cfg_type {
+	FT1_CFG_TYPE_DISABLED = 0,
+	FT1_CFG_TYPE_EQ,
+	FT1_CFG_TYPE_GT,
+	FT1_CFG_TYPE_LT,
+};
+
+#define FT1_CFG_SHIFT(n)	(2 * (n))
+#define FT1_CFG_MASK(n)	(0x3 << FT1_CFG_SHIFT((n)))
+
+/* Filter 3 -  FT3 */
+#define FT3_NUM_SLOTS	16
+#define FT3_SLOT_SIZE	0x20	/* bytes */
+
+/* offsets from FT3 slot n's base */
+#define FT3_START	0
+#define FT3_START_AUTO	0x4
+#define FT3_START_OFFSET	0x8
+#define FT3_JUMP_OFFSET	0xc
+#define FT3_LEN		0x10
+#define FT3_CFG		0x14
+#define FT3_T		0x18
+#define FT3_T_MASK	0x1c
+
+#define FT3_N_REG(slize, n, reg)	(offs[slice].ft3_slot_base + FT3_SLOT_SIZE * (n) + (reg))
+
+/* offsets from rx_class n's base */
+#define RX_CLASS_AND_EN	0
+#define RX_CLASS_OR_EN	0x4
+
+#define RX_CLASS_NUM_SLOTS	16
+#define RX_CLASS_EN_SIZE	0x8	/* bytes */
+
+#define RX_CLASS_N_REG(slice, n, reg)	(offs[slice].rx_class_base + RX_CLASS_EN_SIZE * (n) + (reg))
+
+/* RX Class Gates */
+#define RX_CLASS_GATES_SIZE	0x4	/* bytes */
+
+#define RX_CLASS_GATES_N_REG(slice, n)	\
+	(offs[slice].rx_class_gates_base + RX_CLASS_GATES_SIZE * (n))
+
+#define RX_CLASS_GATES_ALLOW_MASK	BIT(6)
+#define RX_CLASS_GATES_RAW_MASK		BIT(5)
+#define RX_CLASS_GATES_PHASE_MASK	BIT(4)
+
+/* RX Class traffic data matching bits */
+#define RX_CLASS_FT_UC		BIT(31)
+#define RX_CLASS_FT_MC		BIT(30)
+#define RX_CLASS_FT_BC		BIT(29)
+#define RX_CLASS_FT_FW		BIT(28)
+#define RX_CLASS_FT_RCV		BIT(27)
+#define RX_CLASS_FT_VLAN	BIT(26)
+#define RX_CLASS_FT_DA_P	BIT(25)
+#define RX_CLASS_FT_DA_I	BIT(24)
+#define RX_CLASS_FT_FT1_MATCH_MASK	GENMASK(23, 16)
+#define RX_CLASS_FT_FT1_MATCH_SHIFT	16
+#define RX_CLASS_FT_FT3_MATCH_MASK	GENMASK(15, 0)
+#define RX_CLASS_FT_FT3_MATCH_SHIFT	0
+
+#define RX_CLASS_FT_FT1_MATCH(slot)	\
+	((BIT(slot) << RX_CLASS_FT_FT1_MATCH_SHIFT) & RX_CLASS_FT_FT1_MATCH_MASK)
+
+enum rx_class_sel_type {
+	RX_CLASS_SEL_TYPE_OR = 0,
+	RX_CLASS_SEL_TYPE_AND = 1,
+	RX_CLASS_SEL_TYPE_OR_AND_AND = 2,
+	RX_CLASS_SEL_TYPE_OR_OR_AND = 3,
+};
+
+#define FT1_CFG_SHIFT(n)	(2 * (n))
+#define FT1_CFG_MASK(n)		(0x3 << FT1_CFG_SHIFT((n)))
+
+#define RX_CLASS_SEL_SHIFT(n)	(2 * (n))
+#define RX_CLASS_SEL_MASK(n)	(0x3 << RX_CLASS_SEL_SHIFT((n)))
+
+#define ICSSG_CFG_OFFSET	0
+#define MAC_INTERFACE_0		0x18
+#define MAC_INTERFACE_1		0x1c
+
+#define ICSSG_CFG_RX_L2_G_EN	BIT(2)
+
+/* these are register offsets per PRU */
+struct miig_rt_offsets {
+	u32 mac0;
+	u32 mac1;
+	u32 ft1_start_len;
+	u32 ft1_cfg;
+	u32 ft1_slot_base;
+	u32 ft3_slot_base;
+	u32 ft3_p_base;
+	u32 ft_rx_ptr;
+	u32 rx_class_base;
+	u32 rx_class_cfg1;
+	u32 rx_class_cfg2;
+	u32 rx_class_gates_base;
+	u32 rx_green;
+	u32 rx_rate_cfg_base;
+	u32 rx_rate_src_sel0;
+	u32 rx_rate_src_sel1;
+	u32 tx_rate_cfg_base;
+	u32 stat_base;
+	u32 tx_hsr_tag;
+	u32 tx_hsr_seq;
+	u32 tx_vlan_type;
+	u32 tx_vlan_ins;
+};
+
+static const struct miig_rt_offsets offs[] = {
+	/* PRU0 */
+	{
+		0x8,
+		0xc,
+		0x80,
+		0x84,
+		0x88,
+		0x108,
+		0x308,
+		0x408,
+		0x40c,
+		0x48c,
+		0x490,
+		0x494,
+		0x4d4,
+		0x4e4,
+		0x504,
+		0x508,
+		0x50c,
+		0x54c,
+		0x63c,
+		0x640,
+		0x644,
+		0x648,
+	},
+	/* PRU1 */
+	{
+		0x10,
+		0x14,
+		0x64c,
+		0x650,
+		0x654,
+		0x6d4,
+		0x8d4,
+		0x9d4,
+		0x9d8,
+		0xa58,
+		0xa5c,
+		0xa60,
+		0xaa0,
+		0xab0,
+		0xad0,
+		0xad4,
+		0xad8,
+		0xb18,
+		0xc08,
+		0xc0c,
+		0xc10,
+		0xc14,
+	},
+};
+
+static void rx_class_ft1_set_start_len(struct regmap *miig_rt, int slice,
+				       u16 start, u8 len)
+{
+	u32 offset, val;
+
+	offset = offs[slice].ft1_start_len;
+	val = FT1_LEN(len) | FT1_START(start);
+	regmap_write(miig_rt, offset, val);
+}
+
+static void rx_class_ft1_set_da(struct regmap *miig_rt, int slice,
+				int n, const u8 *addr)
+{
+	u32 offset;
+
+	offset = FT1_N_REG(slice, n, FT1_DA0);
+	regmap_write(miig_rt, offset, (u32)(addr[0] | addr[1] << 8 |
+		addr[2] << 16 | addr[3] << 24));
+	offset = FT1_N_REG(slice, n, FT1_DA1);
+	regmap_write(miig_rt, offset, (u32)(addr[4] | addr[5] << 8));
+}
+
+static void rx_class_ft1_set_da_mask(struct regmap *miig_rt, int slice,
+				     int n, const u8 *addr)
+{
+	u32 offset;
+
+	offset = FT1_N_REG(slice, n, FT1_DA0_MASK);
+	regmap_write(miig_rt, offset, (u32)(addr[0] | addr[1] << 8 |
+		addr[2] << 16 | addr[3] << 24));
+	offset = FT1_N_REG(slice, n, FT1_DA1_MASK);
+	regmap_write(miig_rt, offset, (u32)(addr[4] | addr[5] << 8));
+}
+
+static void rx_class_ft1_cfg_set_type(struct regmap *miig_rt, int slice, int n,
+				      enum ft1_cfg_type type)
+{
+	u32 offset;
+
+	offset = offs[slice].ft1_cfg;
+	regmap_update_bits(miig_rt, offset, FT1_CFG_MASK(n),
+			   type << FT1_CFG_SHIFT(n));
+}
+
+static void rx_class_sel_set_type(struct regmap *miig_rt, int slice, int n,
+				  enum rx_class_sel_type type)
+{
+	u32 offset;
+
+	offset = offs[slice].rx_class_cfg1;
+	regmap_update_bits(miig_rt, offset, RX_CLASS_SEL_MASK(n),
+			   type << RX_CLASS_SEL_SHIFT(n));
+}
+
+static void rx_class_set_and(struct regmap *miig_rt, int slice, int n,
+			     u32 data)
+{
+	u32 offset;
+
+	offset = RX_CLASS_N_REG(slice, n, RX_CLASS_AND_EN);
+	regmap_write(miig_rt, offset, data);
+}
+
+static void rx_class_set_or(struct regmap *miig_rt, int slice, int n,
+			    u32 data)
+{
+	u32 offset;
+
+	offset = RX_CLASS_N_REG(slice, n, RX_CLASS_OR_EN);
+	regmap_write(miig_rt, offset, data);
+}
+
+void icssg_class_set_host_mac_addr(struct regmap *miig_rt, const u8 *mac)
+{
+	regmap_write(miig_rt, MAC_INTERFACE_0, (u32)(mac[0] | mac[1] << 8 |
+		mac[2] << 16 | mac[3] << 24));
+	regmap_write(miig_rt, MAC_INTERFACE_1, (u32)(mac[4] | mac[5] << 8));
+}
+
+void icssg_class_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac)
+{
+	regmap_write(miig_rt, offs[slice].mac0, (u32)(mac[0] | mac[1] << 8 |
+		mac[2] << 16 | mac[3] << 24));
+	regmap_write(miig_rt, offs[slice].mac1, (u32)(mac[4] | mac[5] << 8));
+}
+
+/* disable all RX traffic */
+void icssg_class_disable(struct regmap *miig_rt, int slice)
+{
+	u32 data, offset;
+	int n;
+
+	/* Enable RX_L2_G */
+	regmap_update_bits(miig_rt, ICSSG_CFG_OFFSET, ICSSG_CFG_RX_L2_G_EN,
+			   ICSSG_CFG_RX_L2_G_EN);
+
+	for (n = 0; n < ICSSG_NUM_CLASSIFIERS; n++) {
+		/* AND_EN = 0 */
+		rx_class_set_and(miig_rt, slice, n, 0);
+		/* OR_EN = 0 */
+		rx_class_set_or(miig_rt, slice, n, 0);
+
+		/* set CFG1 to OR */
+		rx_class_sel_set_type(miig_rt, slice, n, RX_CLASS_SEL_TYPE_OR);
+
+		/* configure gate */
+		offset = RX_CLASS_GATES_N_REG(slice, n);
+		regmap_read(miig_rt, offset, &data);
+		/* clear class_raw so we go through filters */
+		data &= ~RX_CLASS_GATES_RAW_MASK;
+		/* set allow and phase mask */
+		data |= RX_CLASS_GATES_ALLOW_MASK | RX_CLASS_GATES_PHASE_MASK;
+		regmap_write(miig_rt, offset, data);
+	}
+
+	/* FT1 Disabled */
+	for (n = 0; n < ICSSG_NUM_FT1_SLOTS; n++) {
+		const u8 addr[] = { 0, 0, 0, 0, 0, 0, };
+
+		rx_class_ft1_cfg_set_type(miig_rt, slice, n,
+					  FT1_CFG_TYPE_DISABLED);
+		rx_class_ft1_set_da(miig_rt, slice, n, addr);
+		rx_class_ft1_set_da_mask(miig_rt, slice, n, addr);
+	}
+
+	/* clear CFG2 */
+	regmap_write(miig_rt, offs[slice].rx_class_cfg2, 0);
+}
+
+void icssg_class_default(struct regmap *miig_rt, int slice, bool allmulti)
+{
+	int classifiers_in_use = 1;
+	u32 data;
+	int n;
+
+	/* defaults */
+	icssg_class_disable(miig_rt, slice);
+
+	/* Setup Classifier */
+	for (n = 0; n < classifiers_in_use; n++) {
+		/* match on Broadcast or MAC_PRU address */
+		data = RX_CLASS_FT_BC | RX_CLASS_FT_DA_P;
+
+		/* multicast? */
+		if (allmulti)
+			data |= RX_CLASS_FT_MC;
+
+		rx_class_set_or(miig_rt, slice, n, data);
+
+		/* set CFG1 for OR_OR_AND for classifier */
+		rx_class_sel_set_type(miig_rt, slice, n,
+				      RX_CLASS_SEL_TYPE_OR_OR_AND);
+	}
+
+	/* clear CFG2 */
+	regmap_write(miig_rt, offs[slice].rx_class_cfg2, 0);
+}
+
+/* required for SAV check */
+void icssg_ft1_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac_addr)
+{
+	const u8 mask_addr[] = { 0, 0, 0, 0, 0, 0, };
+
+	rx_class_ft1_set_start_len(miig_rt, slice, 0, 6);
+	rx_class_ft1_set_da(miig_rt, slice, 0, mac_addr);
+	rx_class_ft1_set_da_mask(miig_rt, slice, 0, mask_addr);
+	rx_class_ft1_cfg_set_type(miig_rt, slice, 0, FT1_CFG_TYPE_EQ);
+}
diff --git a/drivers/net/ethernet/ti/icssg_config.c b/drivers/net/ethernet/ti/icssg_config.c
new file mode 100644
index 000000000000..16e3436ad560
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_config.c
@@ -0,0 +1,440 @@
+// SPDX-License-Identifier: GPL-2.0
+/* ICSSG Ethernet driver
+ *
+ * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com
+ */
+
+#include <linux/iopoll.h>
+#include <linux/regmap.h>
+#include <uapi/linux/if_ether.h>
+#include "icssg_config.h"
+#include "icssg_prueth.h"
+#include "icssg_switch_map.h"
+#include "icssg_mii_rt.h"
+
+/* TX IPG Values to be set for 100M link speed. These values are
+ * in ocp_clk cycles. So need change if ocp_clk is changed for a specific
+ * h/w design.
+ */
+
+/* IPG is in core_clk cycles */
+#define MII_RT_TX_IPG_100M	0x17
+#define MII_RT_TX_IPG_1G	0xb
+
+#define	ICSSG_QUEUES_MAX		64
+#define	ICSSG_QUEUE_OFFSET		0xd00
+#define	ICSSG_QUEUE_PEEK_OFFSET		0xe00
+#define	ICSSG_QUEUE_CNT_OFFSET		0xe40
+#define	ICSSG_QUEUE_RESET_OFFSET	0xf40
+
+#define	ICSSG_NUM_TX_QUEUES	8
+
+#define	RECYCLE_Q_SLICE0	16
+#define	RECYCLE_Q_SLICE1	17
+
+#define	ICSSG_NUM_OTHER_QUEUES	5	/* port, host and special queues */
+
+#define	PORT_HI_Q_SLICE0	32
+#define	PORT_LO_Q_SLICE0	33
+#define	HOST_HI_Q_SLICE0	34
+#define	HOST_LO_Q_SLICE0	35
+#define	HOST_SPL_Q_SLICE0	40	/* Special Queue */
+
+#define	PORT_HI_Q_SLICE1	36
+#define	PORT_LO_Q_SLICE1	37
+#define	HOST_HI_Q_SLICE1	38
+#define	HOST_LO_Q_SLICE1	39
+#define	HOST_SPL_Q_SLICE1	41	/* Special Queue */
+
+#define MII_RXCFG_DEFAULT	(PRUSS_MII_RT_RXCFG_RX_ENABLE | \
+				 PRUSS_MII_RT_RXCFG_RX_DATA_RDY_MODE_DIS | \
+				 PRUSS_MII_RT_RXCFG_RX_L2_EN | \
+				 PRUSS_MII_RT_RXCFG_RX_L2_EOF_SCLR_DIS)
+
+#define MII_TXCFG_DEFAULT	(PRUSS_MII_RT_TXCFG_TX_ENABLE | \
+				 PRUSS_MII_RT_TXCFG_TX_AUTO_PREAMBLE | \
+				 PRUSS_MII_RT_TXCFG_TX_32_MODE_EN | \
+				 PRUSS_MII_RT_TXCFG_TX_IPG_WIRE_CLK_EN)
+
+#define ICSSG_CFG_DEFAULT	(ICSSG_CFG_TX_L1_EN | \
+				 ICSSG_CFG_TX_L2_EN | ICSSG_CFG_RX_L2_G_EN | \
+				 ICSSG_CFG_TX_PRU_EN | \
+				 ICSSG_CFG_SGMII_MODE)
+
+#define FDB_GEN_CFG1		0x60
+#define SMEM_VLAN_OFFSET	8
+#define SMEM_VLAN_OFFSET_MASK	GENMASK(25, 8)
+
+#define FDB_GEN_CFG2		0x64
+#define FDB_VLAN_EN		BIT(6)
+#define FDB_HOST_EN		BIT(2)
+#define FDB_PRU1_EN		BIT(1)
+#define FDB_PRU0_EN		BIT(0)
+#define FDB_EN_ALL		(FDB_PRU0_EN | FDB_PRU1_EN | \
+				 FDB_HOST_EN | FDB_VLAN_EN)
+
+struct map {
+	int queue;
+	u32 pd_addr_start;
+	u32 flags;
+	bool special;
+};
+
+const struct map hwq_map[2][ICSSG_NUM_OTHER_QUEUES] = {
+	{
+		{ PORT_HI_Q_SLICE0, PORT_DESC0_HI, 0x200000, 0 },
+		{ PORT_LO_Q_SLICE0, PORT_DESC0_LO, 0, 0 },
+		{ HOST_HI_Q_SLICE0, HOST_DESC0_HI, 0x200000, 0 },
+		{ HOST_LO_Q_SLICE0, HOST_DESC0_LO, 0, 0 },
+		{ HOST_SPL_Q_SLICE0, HOST_SPPD0, 0x400000, 1 },
+	},
+	{
+		{ PORT_HI_Q_SLICE1, PORT_DESC1_HI, 0xa00000, 0 },
+		{ PORT_LO_Q_SLICE1, PORT_DESC1_LO, 0x800000, 0 },
+		{ HOST_HI_Q_SLICE1, HOST_DESC1_HI, 0xa00000, 0 },
+		{ HOST_LO_Q_SLICE1, HOST_DESC1_LO, 0x800000, 0 },
+		{ HOST_SPL_Q_SLICE1, HOST_SPPD1, 0xc00000, 1 },
+	},
+};
+
+static void icssg_config_mii_init(struct prueth_emac *emac)
+{
+	struct prueth *prueth = emac->prueth;
+	struct regmap *mii_rt = prueth->mii_rt;
+	int slice = prueth_emac_slice(emac);
+	u32 rxcfg_reg, txcfg_reg, pcnt_reg;
+	u32 rxcfg, txcfg;
+
+	rxcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RXCFG0 :
+				       PRUSS_MII_RT_RXCFG1;
+	txcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_TXCFG0 :
+				       PRUSS_MII_RT_TXCFG1;
+	pcnt_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RX_PCNT0 :
+				       PRUSS_MII_RT_RX_PCNT1;
+
+	rxcfg = MII_RXCFG_DEFAULT;
+	txcfg = MII_TXCFG_DEFAULT;
+
+	if (slice == ICSS_MII1)
+		rxcfg |= PRUSS_MII_RT_RXCFG_RX_MUX_SEL;
+
+	/* In MII mode TX lines swapped inside ICSSG, so TX_MUX_SEL cfg need
+	 * to be swapped also comparing to RGMII mode.
+	 */
+	if (emac->phy_if == PHY_INTERFACE_MODE_MII && slice == ICSS_MII0)
+		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
+	else if (emac->phy_if != PHY_INTERFACE_MODE_MII && slice == ICSS_MII1)
+		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
+
+	regmap_write(mii_rt, rxcfg_reg, rxcfg);
+	regmap_write(mii_rt, txcfg_reg, txcfg);
+	regmap_write(mii_rt, pcnt_reg, 0x1);
+}
+
+static void icssg_miig_queues_init(struct prueth *prueth, int slice)
+{
+	struct regmap *miig_rt = prueth->miig_rt;
+	void __iomem *smem = prueth->shram.va;
+	u8 pd[ICSSG_SPECIAL_PD_SIZE];
+	int queue = 0, i, j;
+	u32 *pdword;
+
+	/* reset hwqueues */
+	if (slice)
+		queue = ICSSG_NUM_TX_QUEUES;
+
+	for (i = 0; i < ICSSG_NUM_TX_QUEUES; i++) {
+		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
+		queue++;
+	}
+
+	queue = slice ? RECYCLE_Q_SLICE1 : RECYCLE_Q_SLICE0;
+	regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
+
+	for (i = 0; i < ICSSG_NUM_OTHER_QUEUES; i++) {
+		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET,
+			     hwq_map[slice][i].queue);
+	}
+
+	/* initialize packet descriptors in SMEM */
+	/* push pakcet descriptors to hwqueues */
+
+	pdword = (u32 *)pd;
+	for (j = 0; j < ICSSG_NUM_OTHER_QUEUES; j++) {
+		struct map *mp;
+		int pd_size, num_pds;
+		u32 pdaddr;
+
+		mp = &hwq_map[slice][j];
+		if (mp->special) {
+			pd_size = ICSSG_SPECIAL_PD_SIZE;
+			num_pds = ICSSG_NUM_SPECIAL_PDS;
+		} else	{
+			pd_size = ICSSG_NORMAL_PD_SIZE;
+			num_pds = ICSSG_NUM_NORMAL_PDS;
+		}
+
+		for (i = 0; i < num_pds; i++) {
+			memset(pd, 0, pd_size);
+
+			pdword[0] &= cpu_to_le32(ICSSG_FLAG_MASK);
+			pdword[0] |= cpu_to_le32(mp->flags);
+			pdaddr = mp->pd_addr_start + i * pd_size;
+
+			memcpy_toio(smem + pdaddr, pd, pd_size);
+			queue = mp->queue;
+			regmap_write(miig_rt, ICSSG_QUEUE_OFFSET + 4 * queue,
+				     pdaddr);
+		}
+	}
+}
+
+void icssg_config_ipg(struct prueth_emac *emac)
+{
+	struct prueth *prueth = emac->prueth;
+	int slice = prueth_emac_slice(emac);
+
+	switch (emac->speed) {
+	case SPEED_1000:
+		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_1G);
+		break;
+	case SPEED_100:
+		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_100M);
+		break;
+	default:
+		/* Other links speeds not supported */
+		netdev_err(emac->ndev, "Unsupported link speed\n");
+		return;
+	}
+}
+
+static void emac_r30_cmd_init(struct prueth_emac *emac)
+{
+	int i;
+	struct icssg_r30_cmd *p;
+
+	p = emac->dram.va + MGR_R30_CMD_OFFSET;
+
+	for (i = 0; i < 4; i++)
+		writel(EMAC_NONE, &p->cmd[i]);
+}
+
+static int emac_r30_is_done(struct prueth_emac *emac)
+{
+	const struct icssg_r30_cmd *p;
+	int i;
+	u32 cmd;
+
+	p = emac->dram.va + MGR_R30_CMD_OFFSET;
+
+	for (i = 0; i < 4; i++) {
+		cmd = readl(&p->cmd[i]);
+		if (cmd != EMAC_NONE)
+			return 0;
+	}
+
+	return 1;
+}
+
+static int prueth_emac_buffer_setup(struct prueth_emac *emac)
+{
+	struct icssg_buffer_pool_cfg *bpool_cfg;
+	struct prueth *prueth = emac->prueth;
+	int slice = prueth_emac_slice(emac);
+	struct icssg_rxq_ctx *rxq_ctx;
+	u32 addr;
+	int i;
+
+	/* Layout to have 64KB aligned buffer pool
+	 * |BPOOL0|BPOOL1|RX_CTX0|RX_CTX1|
+	 */
+
+	addr = lower_32_bits(prueth->msmcram.pa);
+	if (slice)
+		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
+
+	if (addr % SZ_64K) {
+		dev_warn(prueth->dev, "buffer pool needs to be 64KB aligned\n");
+		return -EINVAL;
+	}
+
+	bpool_cfg = emac->dram.va + BUFFER_POOL_0_ADDR_OFFSET;
+	/* workaround for f/w bug. bpool 0 needs to be initilalized */
+	bpool_cfg[0].addr = cpu_to_le32(addr);
+	bpool_cfg[0].len = 0;
+
+	for (i = PRUETH_EMAC_BUF_POOL_START;
+	     i < (PRUETH_EMAC_BUF_POOL_START + PRUETH_NUM_BUF_POOLS);
+	     i++) {
+		bpool_cfg[i].addr = cpu_to_le32(addr);
+		bpool_cfg[i].len = cpu_to_le32(PRUETH_EMAC_BUF_POOL_SIZE);
+		addr += PRUETH_EMAC_BUF_POOL_SIZE;
+	}
+
+	if (!slice)
+		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
+	else
+		addr += PRUETH_EMAC_RX_CTX_BUF_SIZE * 2;
+
+	/* Pre-emptible RX buffer queue */
+	rxq_ctx = emac->dram.va + HOST_RX_Q_PRE_CONTEXT_OFFSET;
+	for (i = 0; i < 3; i++)
+		rxq_ctx->start[i] = cpu_to_le32(addr);
+
+	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
+	rxq_ctx->end = cpu_to_le32(addr);
+
+	/* Express RX buffer queue */
+	rxq_ctx = emac->dram.va + HOST_RX_Q_EXP_CONTEXT_OFFSET;
+	for (i = 0; i < 3; i++)
+		rxq_ctx->start[i] = cpu_to_le32(addr);
+
+	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
+	rxq_ctx->end = cpu_to_le32(addr);
+
+	return 0;
+}
+
+static void icssg_init_emac_mode(struct prueth *prueth)
+{
+	/* When the device is configured as a bridge and it is being brought back
+	 * to the emac mode, the host mac address has to be set as 0.
+	 */
+	u8 mac[ETH_ALEN] = { 0 };
+
+	if (prueth->emacs_initialized)
+		return;
+
+	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK, 0);
+	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, 0);
+	/* Clear host MAC address */
+	icssg_class_set_host_mac_addr(prueth->miig_rt, mac);
+}
+
+int icssg_config(struct prueth *prueth, struct prueth_emac *emac, int slice)
+{
+	void *config = emac->dram.va + ICSSG_CONFIG_OFFSET;
+	u8 *cfg_byte_ptr = config;
+	struct icssg_flow_cfg *flow_cfg;
+	u32 mask;
+	int ret;
+
+	icssg_init_emac_mode(prueth);
+
+	memset_io(config, 0, TAS_GATE_MASK_LIST0);
+	icssg_miig_queues_init(prueth, slice);
+
+	emac->speed = SPEED_1000;
+	emac->duplex = DUPLEX_FULL;
+	if (!phy_interface_mode_is_rgmii(emac->phy_if)) {
+		emac->speed = SPEED_100;
+		emac->duplex = DUPLEX_FULL;
+	}
+	regmap_update_bits(prueth->miig_rt, ICSSG_CFG_OFFSET, ICSSG_CFG_DEFAULT, ICSSG_CFG_DEFAULT);
+	icssg_miig_set_interface_mode(prueth->miig_rt, slice, emac->phy_if);
+	icssg_config_mii_init(emac);
+	icssg_config_ipg(emac);
+	icssg_update_rgmii_cfg(prueth->miig_rt, emac);
+
+	/* set GPI mode */
+	pruss_cfg_gpimode(prueth->pruss, prueth->pru_id[slice],
+			  PRUSS_GPI_MODE_MII);
+
+	/* enable XFR shift for PRU and RTU */
+	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
+	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);
+
+	/* set C28 to 0x100 */
+	pru_rproc_set_ctable(prueth->pru[slice], PRU_C28, 0x100 << 8);
+	pru_rproc_set_ctable(prueth->rtu[slice], PRU_C28, 0x100 << 8);
+	pru_rproc_set_ctable(prueth->txpru[slice], PRU_C28, 0x100 << 8);
+
+	flow_cfg = config + PSI_L_REGULAR_FLOW_ID_BASE_OFFSET;
+	flow_cfg->rx_base_flow = cpu_to_le32(emac->rx_flow_id_base);
+	flow_cfg->mgm_base_flow = 0;
+	*(cfg_byte_ptr + SPL_PKT_DEFAULT_PRIORITY) = 0;
+	*(cfg_byte_ptr + QUEUE_NUM_UNTAGGED) = 0x0;
+
+	ret = prueth_emac_buffer_setup(emac);
+	if (ret)
+		return ret;
+
+	emac_r30_cmd_init(emac);
+
+	return 0;
+}
+
+static const struct icssg_r30_cmd emac_r32_bitmask[] = {
+	{{0xffff0004, 0xffff0100, 0xffff0100, EMAC_NONE}},	/* EMAC_PORT_DISABLE */
+	{{0xfffb0040, 0xfeff0200, 0xfeff0200, EMAC_NONE}},	/* EMAC_PORT_BLOCK */
+	{{0xffbb0000, 0xfcff0000, 0xdcff0000, EMAC_NONE}},	/* EMAC_PORT_FORWARD */
+	{{0xffbb0000, 0xfcff0000, 0xfcff2000, EMAC_NONE}},	/* EMAC_PORT_FORWARD_WO_LEARNING */
+	{{0xffff0001, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT ALL */
+	{{0xfffe0002, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT TAGGED */
+	{{0xfffc0000, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT UNTAGGED and PRIO */
+	{{EMAC_NONE,  0xffff0020, EMAC_NONE, EMAC_NONE}},	/* TAS Trigger List change */
+	{{EMAC_NONE,  0xdfff1000, EMAC_NONE, EMAC_NONE}},	/* TAS set state ENABLE*/
+	{{EMAC_NONE,  0xefff2000, EMAC_NONE, EMAC_NONE}},	/* TAS set state RESET*/
+	{{EMAC_NONE,  0xcfff0000, EMAC_NONE, EMAC_NONE}},	/* TAS set state DISABLE*/
+	{{EMAC_NONE,  EMAC_NONE,  0xffff0400, EMAC_NONE}},	/* UC flooding ENABLE*/
+	{{EMAC_NONE,  EMAC_NONE,  0xfbff0000, EMAC_NONE}},	/* UC flooding DISABLE*/
+	{{EMAC_NONE,  EMAC_NONE,  0xffff0800, EMAC_NONE}},	/* MC flooding ENABLE*/
+	{{EMAC_NONE,  EMAC_NONE,  0xf7ff0000, EMAC_NONE}},	/* MC flooding DISABLE*/
+	{{EMAC_NONE,  0xffff4000, EMAC_NONE, EMAC_NONE}},	/* Preemption on Tx ENABLE*/
+	{{EMAC_NONE,  0xbfff0000, EMAC_NONE, EMAC_NONE}},	/* Preemption on Tx DISABLE*/
+	{{0xffff0010,  EMAC_NONE, 0xffff0010, EMAC_NONE}},	/* VLAN AWARE*/
+	{{0xffef0000,  EMAC_NONE, 0xffef0000, EMAC_NONE}}	/* VLAN UNWARE*/
+};
+
+int emac_set_port_state(struct prueth_emac *emac,
+			enum icssg_port_state_cmd cmd)
+{
+	struct icssg_r30_cmd *p;
+	int ret = -ETIMEDOUT;
+	int done = 0;
+	int i;
+
+	p = emac->dram.va + MGR_R30_CMD_OFFSET;
+
+	if (cmd >= ICSSG_EMAC_PORT_MAX_COMMANDS) {
+		netdev_err(emac->ndev, "invalid port command\n");
+		return -EINVAL;
+	}
+
+	/* only one command at a time allowed to firmware */
+	mutex_lock(&emac->cmd_lock);
+
+	for (i = 0; i < 4; i++)
+		writel(emac_r32_bitmask[cmd].cmd[i], &p->cmd[i]);
+
+	/* wait for done */
+	ret = read_poll_timeout(emac_r30_is_done, done, done == 1,
+				1000, 10000, false, emac);
+
+	if (ret == -ETIMEDOUT)
+		netdev_err(emac->ndev, "timeout waiting for command done\n");
+
+	mutex_unlock(&emac->cmd_lock);
+
+	return ret;
+}
+
+void icssg_config_set_speed(struct prueth_emac *emac)
+{
+	u8 fw_speed;
+
+	switch (emac->speed) {
+	case SPEED_1000:
+		fw_speed = FW_LINK_SPEED_1G;
+		break;
+	case SPEED_100:
+		fw_speed = FW_LINK_SPEED_100M;
+		break;
+	default:
+		/* Other links speeds not supported */
+		netdev_err(emac->ndev, "Unsupported link speed\n");
+		return;
+	}
+
+	writeb(fw_speed, emac->dram.va + PORT_LINK_SPEED_OFFSET);
+}
diff --git a/drivers/net/ethernet/ti/icssg_config.h b/drivers/net/ethernet/ti/icssg_config.h
new file mode 100644
index 000000000000..43eb0922172a
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_config.h
@@ -0,0 +1,200 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Texas Instruments ICSSG Ethernet driver
+ *
+ * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#ifndef __NET_TI_ICSSG_CONFIG_H
+#define __NET_TI_ICSSG_CONFIG_H
+
+struct icssg_buffer_pool_cfg {
+	__le32	addr;
+	__le32	len;
+} __packed;
+
+struct icssg_flow_cfg {
+	__le16 rx_base_flow;
+	__le16 mgm_base_flow;
+} __packed;
+
+#define PRUETH_PKT_TYPE_CMD	0x10
+#define PRUETH_NAV_PS_DATA_SIZE	16	/* Protocol specific data size */
+#define PRUETH_NAV_SW_DATA_SIZE	16	/* SW related data size */
+#define PRUETH_MAX_TX_DESC	512
+#define PRUETH_MAX_RX_DESC	512
+#define PRUETH_MAX_RX_FLOWS	1	/* excluding default flow */
+#define PRUETH_RX_FLOW_DATA	0
+
+#define PRUETH_EMAC_BUF_POOL_SIZE	SZ_8K
+#define PRUETH_EMAC_POOLS_PER_SLICE	24
+#define PRUETH_EMAC_BUF_POOL_START	8
+#define PRUETH_NUM_BUF_POOLS	8
+#define PRUETH_EMAC_RX_CTX_BUF_SIZE	SZ_16K	/* per slice */
+#define MSMC_RAM_SIZE	\
+	(2 * (PRUETH_EMAC_BUF_POOL_SIZE * PRUETH_NUM_BUF_POOLS + \
+	 PRUETH_EMAC_RX_CTX_BUF_SIZE * 2))
+
+struct icssg_rxq_ctx {
+	__le32 start[3];
+	__le32 end;
+} __packed;
+
+/* Load time Fiwmware Configuration */
+
+#define ICSSG_FW_MGMT_CMD_HEADER	0x81
+#define ICSSG_FW_MGMT_FDB_CMD_TYPE	0x03
+#define ICSSG_FW_MGMT_CMD_TYPE		0x04
+#define ICSSG_FW_MGMT_PKT		0x80000000
+
+struct icssg_r30_cmd {
+	u32 cmd[4];
+} __packed;
+
+enum icssg_port_state_cmd {
+	ICSSG_EMAC_PORT_DISABLE = 0,
+	ICSSG_EMAC_PORT_BLOCK,
+	ICSSG_EMAC_PORT_FORWARD,
+	ICSSG_EMAC_PORT_FORWARD_WO_LEARNING,
+	ICSSG_EMAC_PORT_ACCEPT_ALL,
+	ICSSG_EMAC_PORT_ACCEPT_TAGGED,
+	ICSSG_EMAC_PORT_ACCEPT_UNTAGGED_N_PRIO,
+	ICSSG_EMAC_PORT_TAS_TRIGGER,
+	ICSSG_EMAC_PORT_TAS_ENABLE,
+	ICSSG_EMAC_PORT_TAS_RESET,
+	ICSSG_EMAC_PORT_TAS_DISABLE,
+	ICSSG_EMAC_PORT_UC_FLOODING_ENABLE,
+	ICSSG_EMAC_PORT_UC_FLOODING_DISABLE,
+	ICSSG_EMAC_PORT_MC_FLOODING_ENABLE,
+	ICSSG_EMAC_PORT_MC_FLOODING_DISABLE,
+	ICSSG_EMAC_PORT_PREMPT_TX_ENABLE,
+	ICSSG_EMAC_PORT_PREMPT_TX_DISABLE,
+	ICSSG_EMAC_PORT_VLAN_AWARE_ENABLE,
+	ICSSG_EMAC_PORT_VLAN_AWARE_DISABLE,
+	ICSSG_EMAC_PORT_MAX_COMMANDS
+};
+
+#define EMAC_NONE           0xffff0000
+#define EMAC_PRU0_P_DI      0xffff0004
+#define EMAC_PRU1_P_DI      0xffff0040
+#define EMAC_TX_P_DI        0xffff0100
+
+#define EMAC_PRU0_P_EN      0xfffb0000
+#define EMAC_PRU1_P_EN      0xffbf0000
+#define EMAC_TX_P_EN        0xfeff0000
+
+#define EMAC_P_BLOCK        0xffff0040
+#define EMAC_TX_P_BLOCK     0xffff0200
+#define EMAC_P_UNBLOCK      0xffbf0000
+#define EMAC_TX_P_UNBLOCK   0xfdff0000
+#define EMAC_LEAN_EN        0xfff70000
+#define EMAC_LEAN_DI        0xffff0008
+
+#define EMAC_ACCEPT_ALL     0xffff0001
+#define EMAC_ACCEPT_TAG     0xfffe0002
+#define EMAC_ACCEPT_PRIOR   0xfffc0000
+
+/* Config area lies in DRAM */
+#define ICSSG_CONFIG_OFFSET	0x0
+
+/* Config area lies in shared RAM */
+#define ICSSG_CONFIG_OFFSET_SLICE0   0
+#define ICSSG_CONFIG_OFFSET_SLICE1   0x8000
+
+#define ICSSG_NUM_NORMAL_PDS	64
+#define ICSSG_NUM_SPECIAL_PDS	16
+
+#define ICSSG_NORMAL_PD_SIZE	8
+#define ICSSG_SPECIAL_PD_SIZE	20
+
+#define ICSSG_FLAG_MASK		0xff00ffff
+
+struct icssg_setclock_desc {
+	u8 request;
+	u8 restore;
+	u8 acknowledgment;
+	u8 cmp_status;
+	u32 margin;
+	u32 cyclecounter0_set;
+	u32 cyclecounter1_set;
+	u32 iepcount_set;
+	u32 rsvd1;
+	u32 rsvd2;
+	u32 CMP0_current;
+	u32 iepcount_current;
+	u32 difference;
+	u32 cyclecounter0_new;
+	u32 cyclecounter1_new;
+	u32 CMP0_new;
+} __packed;
+
+#define ICSSG_CMD_POP_SLICE0	56
+#define ICSSG_CMD_POP_SLICE1	60
+
+#define ICSSG_CMD_PUSH_SLICE0	57
+#define ICSSG_CMD_PUSH_SLICE1	61
+
+#define ICSSG_RSP_POP_SLICE0	58
+#define ICSSG_RSP_POP_SLICE1	62
+
+#define ICSSG_RSP_PUSH_SLICE0	56
+#define ICSSG_RSP_PUSH_SLICE1	60
+
+#define ICSSG_TS_POP_SLICE0	59
+#define ICSSG_TS_POP_SLICE1	63
+
+#define ICSSG_TS_PUSH_SLICE0	40
+#define ICSSG_TS_PUSH_SLICE1	41
+
+/* FDB FID_C2 flag definitions */
+/* Indicates host port membership.*/
+#define ICSSG_FDB_ENTRY_P0_MEMBERSHIP         BIT(0)
+/* Indicates that MAC ID is connected to physical port 1 */
+#define ICSSG_FDB_ENTRY_P1_MEMBERSHIP         BIT(1)
+/* Indicates that MAC ID is connected to physical port 2 */
+#define ICSSG_FDB_ENTRY_P2_MEMBERSHIP         BIT(2)
+/* Ageable bit is set for learned entries and cleared for static entries */
+#define ICSSG_FDB_ENTRY_AGEABLE               BIT(3)
+/* If set for DA then packet is determined to be a special packet */
+#define ICSSG_FDB_ENTRY_BLOCK                 BIT(4)
+/* If set for DA then the SA from the packet is not learned */
+#define ICSSG_FDB_ENTRY_SECURE                BIT(5)
+/* If set, it means packet has been seen recently with source address + FID
+ * matching MAC address/FID of entry
+ */
+#define ICSSG_FDB_ENTRY_TOUCHED               BIT(6)
+/* Set if entry is valid */
+#define ICSSG_FDB_ENTRY_VALID                 BIT(7)
+
+/**
+ * struct prueth_vlan_tbl - VLAN table entries struct in ICSSG SMEM
+ * @fid_c1: membership and forwarding rules flag to this table. See
+ *          above to defines for bit definitions
+ * @fid: FDB index for this VID (there is 1-1 mapping b/w VID and FID)
+ */
+struct prueth_vlan_tbl {
+	u8 fid_c1;
+	u8 fid;
+} __packed;
+
+/**
+ * struct prueth_fdb_slot - Result of FDB slot lookup
+ * @mac: MAC address
+ * @fid: fid to be associated with MAC
+ * @fid_c2: FID_C2 entry for this MAC
+ */
+struct prueth_fdb_slot {
+	u8 mac[ETH_ALEN];
+	u8 fid;
+	u8 fid_c2;
+} __packed;
+
+enum icssg_ietfpe_verify_states {
+	ICSSG_IETFPE_STATE_UNKNOWN = 0,
+	ICSSG_IETFPE_STATE_INITIAL,
+	ICSSG_IETFPE_STATE_VERIFYING,
+	ICSSG_IETFPE_STATE_SUCCEEDED,
+	ICSSG_IETFPE_STATE_FAILED,
+	ICSSG_IETFPE_STATE_DISABLED
+};
+#endif /* __NET_TI_ICSSG_CONFIG_H */
diff --git a/drivers/net/ethernet/ti/icssg_ethtool.c b/drivers/net/ethernet/ti/icssg_ethtool.c
new file mode 100644
index 000000000000..99eb1b7608ea
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_ethtool.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Texas Instruments ICSSG Ethernet driver
+ *
+ * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#include "icssg_prueth.h"
+#include <linux/regmap.h>
+
+static const u32 stats_base[] = {	0x54c,	/* Slice 0 stats start */
+					0xb18,	/* Slice 1 stats start */
+};
+
+struct miig_stats_regs {
+	/* Rx */
+	u32 rx_good_frames;
+	u32 rx_broadcast_frames;
+	u32 rx_multicast_frames;
+	u32 rx_crc_error_frames;
+	u32 rx_mii_error_frames;
+	u32 rx_odd_nibble_frames;
+	u32 rx_frame_max_size;
+	u32 rx_max_size_error_frames;
+	u32 rx_frame_min_size;
+	u32 rx_min_size_error_frames;
+	u32 rx_overrun_frames;
+	u32 rx_class0_hits;
+	u32 rx_class1_hits;
+	u32 rx_class2_hits;
+	u32 rx_class3_hits;
+	u32 rx_class4_hits;
+	u32 rx_class5_hits;
+	u32 rx_class6_hits;
+	u32 rx_class7_hits;
+	u32 rx_class8_hits;
+	u32 rx_class9_hits;
+	u32 rx_class10_hits;
+	u32 rx_class11_hits;
+	u32 rx_class12_hits;
+	u32 rx_class13_hits;
+	u32 rx_class14_hits;
+	u32 rx_class15_hits;
+	u32 rx_smd_frags;
+	u32 rx_bucket1_size;
+	u32 rx_bucket2_size;
+	u32 rx_bucket3_size;
+	u32 rx_bucket4_size;
+	u32 rx_64B_frames;
+	u32 rx_bucket1_frames;
+	u32 rx_bucket2_frames;
+	u32 rx_bucket3_frames;
+	u32 rx_bucket4_frames;
+	u32 rx_bucket5_frames;
+	u32 rx_total_bytes;
+	u32 rx_tx_total_bytes;
+	/* Tx */
+	u32 tx_good_frames;
+	u32 tx_broadcast_frames;
+	u32 tx_multicast_frames;
+	u32 tx_odd_nibble_frames;
+	u32 tx_underflow_errors;
+	u32 tx_frame_max_size;
+	u32 tx_max_size_error_frames;
+	u32 tx_frame_min_size;
+	u32 tx_min_size_error_frames;
+	u32 tx_bucket1_size;
+	u32 tx_bucket2_size;
+	u32 tx_bucket3_size;
+	u32 tx_bucket4_size;
+	u32 tx_64B_frames;
+	u32 tx_bucket1_frames;
+	u32 tx_bucket2_frames;
+	u32 tx_bucket3_frames;
+	u32 tx_bucket4_frames;
+	u32 tx_bucket5_frames;
+	u32 tx_total_bytes;
+};
+
+#define ICSSG_STATS(field)				\
+{							\
+	#field,						\
+	offsetof(struct miig_stats_regs, field),	\
+}
+
+struct icssg_stats {
+	char name[ETH_GSTRING_LEN];
+	u32 offset;
+};
+
+static const struct icssg_stats icssg_ethtool_stats[] = {
+	/* Rx */
+	ICSSG_STATS(rx_good_frames),
+	ICSSG_STATS(rx_broadcast_frames),
+	ICSSG_STATS(rx_multicast_frames),
+	ICSSG_STATS(rx_crc_error_frames),
+	ICSSG_STATS(rx_mii_error_frames),
+	ICSSG_STATS(rx_odd_nibble_frames),
+	ICSSG_STATS(rx_frame_max_size),
+	ICSSG_STATS(rx_max_size_error_frames),
+	ICSSG_STATS(rx_frame_min_size),
+	ICSSG_STATS(rx_min_size_error_frames),
+	ICSSG_STATS(rx_overrun_frames),
+	ICSSG_STATS(rx_class0_hits),
+	ICSSG_STATS(rx_class1_hits),
+	ICSSG_STATS(rx_class2_hits),
+	ICSSG_STATS(rx_class3_hits),
+	ICSSG_STATS(rx_class4_hits),
+	ICSSG_STATS(rx_class5_hits),
+	ICSSG_STATS(rx_class6_hits),
+	ICSSG_STATS(rx_class7_hits),
+	ICSSG_STATS(rx_class8_hits),
+	ICSSG_STATS(rx_class9_hits),
+	ICSSG_STATS(rx_class10_hits),
+	ICSSG_STATS(rx_class11_hits),
+	ICSSG_STATS(rx_class12_hits),
+	ICSSG_STATS(rx_class13_hits),
+	ICSSG_STATS(rx_class14_hits),
+	ICSSG_STATS(rx_class15_hits),
+	ICSSG_STATS(rx_smd_frags),
+	ICSSG_STATS(rx_bucket1_size),
+	ICSSG_STATS(rx_bucket2_size),
+	ICSSG_STATS(rx_bucket3_size),
+	ICSSG_STATS(rx_bucket4_size),
+	ICSSG_STATS(rx_64B_frames),
+	ICSSG_STATS(rx_bucket1_frames),
+	ICSSG_STATS(rx_bucket2_frames),
+	ICSSG_STATS(rx_bucket3_frames),
+	ICSSG_STATS(rx_bucket4_frames),
+	ICSSG_STATS(rx_bucket5_frames),
+	ICSSG_STATS(rx_total_bytes),
+	ICSSG_STATS(rx_tx_total_bytes),
+	/* Tx */
+	ICSSG_STATS(tx_good_frames),
+	ICSSG_STATS(tx_broadcast_frames),
+	ICSSG_STATS(tx_multicast_frames),
+	ICSSG_STATS(tx_odd_nibble_frames),
+	ICSSG_STATS(tx_underflow_errors),
+	ICSSG_STATS(tx_frame_max_size),
+	ICSSG_STATS(tx_max_size_error_frames),
+	ICSSG_STATS(tx_frame_min_size),
+	ICSSG_STATS(tx_min_size_error_frames),
+	ICSSG_STATS(tx_bucket1_size),
+	ICSSG_STATS(tx_bucket2_size),
+	ICSSG_STATS(tx_bucket3_size),
+	ICSSG_STATS(tx_bucket4_size),
+	ICSSG_STATS(tx_64B_frames),
+	ICSSG_STATS(tx_bucket1_frames),
+	ICSSG_STATS(tx_bucket2_frames),
+	ICSSG_STATS(tx_bucket3_frames),
+	ICSSG_STATS(tx_bucket4_frames),
+	ICSSG_STATS(tx_bucket5_frames),
+	ICSSG_STATS(tx_total_bytes),
+};
+
+static void emac_get_drvinfo(struct net_device *ndev,
+			     struct ethtool_drvinfo *info)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+	struct prueth *prueth = emac->prueth;
+
+	strscpy(info->driver, dev_driver_string(prueth->dev),
+		sizeof(info->driver));
+	strscpy(info->bus_info, dev_name(prueth->dev), sizeof(info->bus_info));
+}
+
+static u32 emac_get_msglevel(struct net_device *ndev)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+
+	return emac->msg_enable;
+}
+
+static void emac_set_msglevel(struct net_device *ndev, u32 value)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+
+	emac->msg_enable = value;
+}
+
+static int emac_get_link_ksettings(struct net_device *ndev,
+				   struct ethtool_link_ksettings *ecmd)
+{
+	return phy_ethtool_get_link_ksettings(ndev, ecmd);
+}
+
+static int emac_set_link_ksettings(struct net_device *ndev,
+				   const struct ethtool_link_ksettings *ecmd)
+{
+	return phy_ethtool_set_link_ksettings(ndev, ecmd);
+}
+
+static int emac_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
+{
+	if (!ndev->phydev)
+		return -EOPNOTSUPP;
+
+	return phy_ethtool_get_eee(ndev->phydev, edata);
+}
+
+static int emac_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
+{
+	if (!ndev->phydev)
+		return -EOPNOTSUPP;
+
+	return phy_ethtool_set_eee(ndev->phydev, edata);
+}
+
+static int emac_nway_reset(struct net_device *ndev)
+{
+	return phy_ethtool_nway_reset(ndev);
+}
+
+#define EMAC_PRIV_IET_FRAME_PREEMPTION  BIT(0)
+#define EMAC_PRIV_IET_MAC_VERIFY        BIT(1)
+
+static const char emac_ethtool_priv_flags[][ETH_GSTRING_LEN] = {
+	"iet-frame-preemption",
+	"iet-mac-verify",
+};
+
+static int emac_get_sset_count(struct net_device *ndev, int stringset)
+{
+	switch (stringset) {
+	case ETH_SS_STATS:
+		return ARRAY_SIZE(icssg_ethtool_stats);
+	case ETH_SS_PRIV_FLAGS:
+		return ARRAY_SIZE(emac_ethtool_priv_flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void emac_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+{
+	u8 *p = data;
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < ARRAY_SIZE(icssg_ethtool_stats); i++) {
+			memcpy(p, icssg_ethtool_stats[i].name,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		for (i = 0; i < ARRAY_SIZE(emac_ethtool_priv_flags); i++) {
+			memcpy(p, emac_ethtool_priv_flags[i],
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void emac_get_ethtool_stats(struct net_device *ndev,
+				   struct ethtool_stats *stats, u64 *data)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+	struct prueth *prueth = emac->prueth;
+	int i;
+	int slice = prueth_emac_slice(emac);
+	u32 base = stats_base[slice];
+	u32 val;
+
+	for (i = 0; i < ARRAY_SIZE(icssg_ethtool_stats); i++) {
+		regmap_read(prueth->miig_rt,
+			    base + icssg_ethtool_stats[i].offset,
+			    &val);
+		data[i] = val;
+	}
+}
+
+static int emac_set_channels(struct net_device *ndev,
+			     struct ethtool_channels *ch)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+
+	/* Check if interface is up. Can change the num queues when
+	 * the interface is down.
+	 */
+	if (netif_running(emac->ndev))
+		return -EBUSY;
+
+	emac->tx_ch_num = ch->tx_count;
+
+	return 0;
+}
+
+static void emac_get_channels(struct net_device *ndev,
+			      struct ethtool_channels *ch)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+
+	ch->max_rx = 1;
+	/* SR1 use high priority channel for management messages */
+	ch->max_tx = PRUETH_MAX_TX_QUEUES;
+	ch->rx_count = 1;
+	ch->tx_count = emac->tx_ch_num;
+}
+
+const struct ethtool_ops icssg_ethtool_ops = {
+	.get_drvinfo = emac_get_drvinfo,
+	.get_msglevel = emac_get_msglevel,
+	.set_msglevel = emac_set_msglevel,
+	.get_sset_count = emac_get_sset_count,
+	.get_ethtool_stats = emac_get_ethtool_stats,
+	.get_strings = emac_get_strings,
+	.get_channels = emac_get_channels,
+	.set_channels = emac_set_channels,
+	.get_link_ksettings = emac_get_link_ksettings,
+	.set_link_ksettings = emac_set_link_ksettings,
+	.get_link = ethtool_op_get_link,
+	.get_eee = emac_get_eee,
+	.set_eee = emac_set_eee,
+	.nway_reset = emac_nway_reset,
+};
diff --git a/drivers/net/ethernet/ti/icssg_mii_cfg.c b/drivers/net/ethernet/ti/icssg_mii_cfg.c
new file mode 100644
index 000000000000..cc640e92aeef
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_mii_cfg.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Texas Instruments ICSSG Ethernet Driver
+ *
+ * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+#include "icssg_mii_rt.h"
+#include "icssg_prueth.h"
+
+void icssg_mii_update_ipg(struct regmap *mii_rt, int mii, u32 ipg)
+{
+	u32 val;
+
+	if (mii == ICSS_MII0) {
+		regmap_write(mii_rt, PRUSS_MII_RT_TX_IPG0, ipg);
+	} else {
+		regmap_read(mii_rt, PRUSS_MII_RT_TX_IPG0, &val);
+		regmap_write(mii_rt, PRUSS_MII_RT_TX_IPG1, ipg);
+		regmap_write(mii_rt, PRUSS_MII_RT_TX_IPG0, val);
+	}
+}
+
+void icssg_update_rgmii_cfg(struct regmap *miig_rt, struct prueth_emac *emac)
+{
+	u32 gig_en_mask, gig_val = 0, full_duplex_mask, full_duplex_val = 0;
+	int slice = prueth_emac_slice(emac);
+	u32 inband_en_mask, inband_val = 0;
+
+	gig_en_mask = (slice == ICSS_MII0) ? RGMII_CFG_GIG_EN_MII0 :
+					RGMII_CFG_GIG_EN_MII1;
+	if (emac->speed == SPEED_1000)
+		gig_val = gig_en_mask;
+	regmap_update_bits(miig_rt, RGMII_CFG_OFFSET, gig_en_mask, gig_val);
+
+	inband_en_mask = (slice == ICSS_MII0) ? RGMII_CFG_INBAND_EN_MII0 :
+					RGMII_CFG_INBAND_EN_MII1;
+	if (emac->speed == SPEED_10 && phy_interface_mode_is_rgmii(emac->phy_if))
+		inband_val = inband_en_mask;
+	regmap_update_bits(miig_rt, RGMII_CFG_OFFSET, inband_en_mask, inband_val);
+
+	full_duplex_mask = (slice == ICSS_MII0) ? RGMII_CFG_FULL_DUPLEX_MII0 :
+					   RGMII_CFG_FULL_DUPLEX_MII1;
+	if (emac->duplex == DUPLEX_FULL)
+		full_duplex_val = full_duplex_mask;
+	regmap_update_bits(miig_rt, RGMII_CFG_OFFSET, full_duplex_mask,
+			   full_duplex_val);
+}
+
+void icssg_miig_set_interface_mode(struct regmap *miig_rt, int mii, phy_interface_t phy_if)
+{
+	u32 val, mask, shift;
+
+	mask = mii == ICSS_MII0 ? ICSSG_CFG_MII0_MODE : ICSSG_CFG_MII1_MODE;
+	shift =  mii == ICSS_MII0 ? ICSSG_CFG_MII0_MODE_SHIFT : ICSSG_CFG_MII1_MODE_SHIFT;
+
+	val = MII_MODE_RGMII;
+	if (phy_if == PHY_INTERFACE_MODE_MII)
+		val = MII_MODE_MII;
+
+	val <<= shift;
+	regmap_update_bits(miig_rt, ICSSG_CFG_OFFSET, mask, val);
+	regmap_read(miig_rt, ICSSG_CFG_OFFSET, &val);
+}
+
+u32 icssg_rgmii_cfg_get_bitfield(struct regmap *miig_rt, u32 mask, u32 shift)
+{
+	u32 val;
+
+	regmap_read(miig_rt, RGMII_CFG_OFFSET, &val);
+	val &= mask;
+	val >>= shift;
+
+	return val;
+}
+
+u32 icssg_rgmii_get_speed(struct regmap *miig_rt, int mii)
+{
+	u32 shift = RGMII_CFG_SPEED_MII0_SHIFT, mask = RGMII_CFG_SPEED_MII0;
+
+	if (mii == ICSS_MII1) {
+		shift = RGMII_CFG_SPEED_MII1_SHIFT;
+		mask = RGMII_CFG_SPEED_MII1;
+	}
+
+	return icssg_rgmii_cfg_get_bitfield(miig_rt, mask, shift);
+}
+
+u32 icssg_rgmii_get_fullduplex(struct regmap *miig_rt, int mii)
+{
+	u32 shift = RGMII_CFG_FULLDUPLEX_MII0_SHIFT;
+	u32 mask = RGMII_CFG_FULLDUPLEX_MII0;
+
+	if (mii == ICSS_MII1) {
+		shift = RGMII_CFG_FULLDUPLEX_MII1_SHIFT;
+		mask = RGMII_CFG_FULLDUPLEX_MII1;
+	}
+
+	return icssg_rgmii_cfg_get_bitfield(miig_rt, mask, shift);
+}
diff --git a/drivers/net/ethernet/ti/icssg_mii_rt.h b/drivers/net/ethernet/ti/icssg_mii_rt.h
new file mode 100644
index 000000000000..96f889661cc9
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_mii_rt.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* PRU-ICSS MII_RT register definitions
+ *
+ * Copyright (C) 2015-2022 Texas Instruments Incorporated - https://www.ti.com
+ */
+
+#ifndef __NET_PRUSS_MII_RT_H__
+#define __NET_PRUSS_MII_RT_H__
+
+#include <linux/if_ether.h>
+#include <linux/phy.h>
+
+/* PRUSS_MII_RT Registers */
+#define PRUSS_MII_RT_RXCFG0		0x0
+#define PRUSS_MII_RT_RXCFG1		0x4
+#define PRUSS_MII_RT_TXCFG0		0x10
+#define PRUSS_MII_RT_TXCFG1		0x14
+#define PRUSS_MII_RT_TX_CRC0		0x20
+#define PRUSS_MII_RT_TX_CRC1		0x24
+#define PRUSS_MII_RT_TX_IPG0		0x30
+#define PRUSS_MII_RT_TX_IPG1		0x34
+#define PRUSS_MII_RT_PRS0		0x38
+#define PRUSS_MII_RT_PRS1		0x3c
+#define PRUSS_MII_RT_RX_FRMS0		0x40
+#define PRUSS_MII_RT_RX_FRMS1		0x44
+#define PRUSS_MII_RT_RX_PCNT0		0x48
+#define PRUSS_MII_RT_RX_PCNT1		0x4c
+#define PRUSS_MII_RT_RX_ERR0		0x50
+#define PRUSS_MII_RT_RX_ERR1		0x54
+
+/* PRUSS_MII_RT_RXCFG0/1 bits */
+#define PRUSS_MII_RT_RXCFG_RX_ENABLE		BIT(0)
+#define PRUSS_MII_RT_RXCFG_RX_DATA_RDY_MODE_DIS	BIT(1)
+#define PRUSS_MII_RT_RXCFG_RX_CUT_PREAMBLE	BIT(2)
+#define PRUSS_MII_RT_RXCFG_RX_MUX_SEL		BIT(3)
+#define PRUSS_MII_RT_RXCFG_RX_L2_EN		BIT(4)
+#define PRUSS_MII_RT_RXCFG_RX_BYTE_SWAP		BIT(5)
+#define PRUSS_MII_RT_RXCFG_RX_AUTO_FWD_PRE	BIT(6)
+#define PRUSS_MII_RT_RXCFG_RX_L2_EOF_SCLR_DIS	BIT(9)
+
+/* PRUSS_MII_RT_TXCFG0/1 bits */
+#define PRUSS_MII_RT_TXCFG_TX_ENABLE		BIT(0)
+#define PRUSS_MII_RT_TXCFG_TX_AUTO_PREAMBLE	BIT(1)
+#define PRUSS_MII_RT_TXCFG_TX_EN_MODE		BIT(2)
+#define PRUSS_MII_RT_TXCFG_TX_BYTE_SWAP		BIT(3)
+#define PRUSS_MII_RT_TXCFG_TX_MUX_SEL		BIT(8)
+#define PRUSS_MII_RT_TXCFG_PRE_TX_AUTO_SEQUENCE	BIT(9)
+#define PRUSS_MII_RT_TXCFG_PRE_TX_AUTO_ESC_ERR	BIT(10)
+#define PRUSS_MII_RT_TXCFG_TX_32_MODE_EN	BIT(11)
+#define PRUSS_MII_RT_TXCFG_TX_IPG_WIRE_CLK_EN	BIT(12)	/* SR2.0 onwards */
+
+#define PRUSS_MII_RT_TXCFG_TX_START_DELAY_SHIFT	16
+#define PRUSS_MII_RT_TXCFG_TX_START_DELAY_MASK	GENMASK(25, 16)
+
+#define PRUSS_MII_RT_TXCFG_TX_CLK_DELAY_SHIFT	28
+#define PRUSS_MII_RT_TXCFG_TX_CLK_DELAY_MASK	GENMASK(30, 28)
+
+/* PRUSS_MII_RT_TX_IPG0/1 bits */
+#define PRUSS_MII_RT_TX_IPG_IPG_SHIFT	0
+#define PRUSS_MII_RT_TX_IPG_IPG_MASK	GENMASK(9, 0)
+
+/* PRUSS_MII_RT_PRS0/1 bits */
+#define PRUSS_MII_RT_PRS_COL	BIT(0)
+#define PRUSS_MII_RT_PRS_CRS	BIT(1)
+
+/* PRUSS_MII_RT_RX_FRMS0/1 bits */
+#define PRUSS_MII_RT_RX_FRMS_MIN_FRM_SHIFT	0
+#define PRUSS_MII_RT_RX_FRMS_MIN_FRM_MASK	GENMASK(15, 0)
+
+#define PRUSS_MII_RT_RX_FRMS_MAX_FRM_SHIFT	16
+#define PRUSS_MII_RT_RX_FRMS_MAX_FRM_MASK	GENMASK(31, 16)
+
+/* Min/Max in MII_RT_RX_FRMS */
+/* For EMAC and Switch */
+#define PRUSS_MII_RT_RX_FRMS_MAX	(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
+#define PRUSS_MII_RT_RX_FRMS_MIN_FRM	(64)
+
+/* for HSR and PRP */
+#define PRUSS_MII_RT_RX_FRMS_MAX_FRM_LRE	(PRUSS_MII_RT_RX_FRMS_MAX + \
+						 ICSS_LRE_TAG_RCT_SIZE)
+/* PRUSS_MII_RT_RX_PCNT0/1 bits */
+#define PRUSS_MII_RT_RX_PCNT_MIN_PCNT_SHIFT	0
+#define PRUSS_MII_RT_RX_PCNT_MIN_PCNT_MASK	GENMASK(3, 0)
+
+#define PRUSS_MII_RT_RX_PCNT_MAX_PCNT_SHIFT	4
+#define PRUSS_MII_RT_RX_PCNT_MAX_PCNT_MASK	GENMASK(7, 4)
+
+/* PRUSS_MII_RT_RX_ERR0/1 bits */
+#define PRUSS_MII_RT_RX_ERR_MIN_PCNT_ERR	BIT(0)
+#define PRUSS_MII_RT_RX_ERR_MAX_PCNT_ERR	BIT(1)
+#define PRUSS_MII_RT_RX_ERR_MIN_FRM_ERR		BIT(2)
+#define PRUSS_MII_RT_RX_ERR_MAX_FRM_ERR		BIT(3)
+
+#define ICSSG_CFG_OFFSET	0
+#define RGMII_CFG_OFFSET	4
+
+/* Constant to choose between MII0 and MII1 */
+#define ICSS_MII0	0
+#define ICSS_MII1	1
+
+/* ICSSG_CFG Register bits */
+#define ICSSG_CFG_SGMII_MODE	BIT(16)
+#define ICSSG_CFG_TX_PRU_EN	BIT(11)
+#define ICSSG_CFG_RX_SFD_TX_SOF_EN	BIT(10)
+#define ICSSG_CFG_RTU_PRU_PSI_SHARE_EN	BIT(9)
+#define ICSSG_CFG_IEP1_TX_EN	BIT(8)
+#define ICSSG_CFG_MII1_MODE	GENMASK(6, 5)
+#define ICSSG_CFG_MII1_MODE_SHIFT	5
+#define ICSSG_CFG_MII0_MODE	GENMASK(4, 3)
+#define ICSSG_CFG_MII0_MODE_SHIFT	3
+#define ICSSG_CFG_RX_L2_G_EN	BIT(2)
+#define ICSSG_CFG_TX_L2_EN	BIT(1)
+#define ICSSG_CFG_TX_L1_EN	BIT(0)
+
+enum mii_mode {
+	MII_MODE_MII = 0,
+	MII_MODE_RGMII,
+	MII_MODE_SGMII
+};
+
+/* RGMII CFG Register bits */
+#define RGMII_CFG_INBAND_EN_MII0	BIT(16)
+#define RGMII_CFG_GIG_EN_MII0	BIT(17)
+#define RGMII_CFG_INBAND_EN_MII1	BIT(20)
+#define RGMII_CFG_GIG_EN_MII1	BIT(21)
+#define RGMII_CFG_FULL_DUPLEX_MII0	BIT(18)
+#define RGMII_CFG_FULL_DUPLEX_MII1	BIT(22)
+#define RGMII_CFG_SPEED_MII0	GENMASK(2, 1)
+#define RGMII_CFG_SPEED_MII1	GENMASK(6, 5)
+#define RGMII_CFG_SPEED_MII0_SHIFT	1
+#define RGMII_CFG_SPEED_MII1_SHIFT	5
+#define RGMII_CFG_FULLDUPLEX_MII0	BIT(3)
+#define RGMII_CFG_FULLDUPLEX_MII1	BIT(7)
+#define RGMII_CFG_FULLDUPLEX_MII0_SHIFT	3
+#define RGMII_CFG_FULLDUPLEX_MII1_SHIFT	7
+#define RGMII_CFG_SPEED_10M	0
+#define RGMII_CFG_SPEED_100M	1
+#define RGMII_CFG_SPEED_1G	2
+
+struct regmap;
+struct prueth_emac;
+
+void icssg_mii_update_ipg(struct regmap *mii_rt, int mii, u32 ipg);
+void icssg_update_rgmii_cfg(struct regmap *miig_rt, struct prueth_emac *emac);
+u32 icssg_rgmii_cfg_get_bitfield(struct regmap *miig_rt, u32 mask, u32 shift);
+u32 icssg_rgmii_get_speed(struct regmap *miig_rt, int mii);
+u32 icssg_rgmii_get_fullduplex(struct regmap *miig_rt, int mii);
+void icssg_miig_set_interface_mode(struct regmap *miig_rt, int mii, phy_interface_t phy_if);
+
+#endif /* __NET_PRUSS_MII_RT_H__ */
diff --git a/drivers/net/ethernet/ti/icssg_prueth.c b/drivers/net/ethernet/ti/icssg_prueth.c
new file mode 100644
index 000000000000..92fa168d68d1
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_prueth.c
@@ -0,0 +1,1882 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Texas Instruments ICSSG Ethernet Driver
+ *
+ * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma/ti-cppi5.h>
+#include <linux/etherdevice.h>
+#include <linux/genalloc.h>
+#include <linux/if_vlan.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/pruss.h>
+#include <linux/regmap.h>
+#include <linux/remoteproc.h>
+
+#include "icssg_prueth.h"
+#include "icssg_mii_rt.h"
+#include "k3-cppi-desc-pool.h"
+
+#define PRUETH_MODULE_DESCRIPTION "PRUSS ICSSG Ethernet driver"
+
+#define PRUETH_MIN_PKT_SIZE	(VLAN_ETH_ZLEN)
+#define PRUETH_MAX_PKT_SIZE	(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
+
+/* Netif debug messages possible */
+#define PRUETH_EMAC_DEBUG	(NETIF_MSG_DRV | \
+				 NETIF_MSG_PROBE | \
+				 NETIF_MSG_LINK | \
+				 NETIF_MSG_TIMER | \
+				 NETIF_MSG_IFDOWN | \
+				 NETIF_MSG_IFUP | \
+				 NETIF_MSG_RX_ERR | \
+				 NETIF_MSG_TX_ERR | \
+				 NETIF_MSG_TX_QUEUED | \
+				 NETIF_MSG_INTR | \
+				 NETIF_MSG_TX_DONE | \
+				 NETIF_MSG_RX_STATUS | \
+				 NETIF_MSG_PKTDATA | \
+				 NETIF_MSG_HW | \
+				 NETIF_MSG_WOL)
+
+#define prueth_napi_to_emac(napi) container_of(napi, struct prueth_emac, napi)
+
+/* CTRLMMR_ICSSG_RGMII_CTRL register bits */
+#define ICSSG_CTRL_RGMII_ID_MODE		BIT(24)
+
+static void prueth_cleanup_rx_chns(struct prueth_emac *emac,
+				   struct prueth_rx_chn *rx_chn,
+				   int max_rflows)
+{
+	if (rx_chn->desc_pool)
+		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
+
+	if (rx_chn->rx_chn)
+		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
+}
+
+static void prueth_cleanup_tx_chns(struct prueth_emac *emac)
+{
+	int i;
+
+	for (i = 0; i < emac->tx_ch_num; i++) {
+		struct prueth_tx_chn *tx_chn = &emac->tx_chns[i];
+
+		if (tx_chn->desc_pool)
+			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
+
+		if (tx_chn->tx_chn)
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
+		/* Assume prueth_cleanup_tx_chns() is called at the
+		 * end after all channel resources are freed
+		 */
+		memset(tx_chn, 0, sizeof(*tx_chn));
+	}
+}
+
+static void prueth_ndev_del_tx_napi(struct prueth_emac *emac, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++) {
+		struct prueth_tx_chn *tx_chn = &emac->tx_chns[i];
+
+		if (tx_chn->irq)
+			free_irq(tx_chn->irq, tx_chn);
+		netif_napi_del(&tx_chn->napi_tx);
+	}
+}
+
+static void prueth_xmit_free(struct prueth_tx_chn *tx_chn,
+			     struct cppi5_host_desc_t *desc)
+{
+	struct cppi5_host_desc_t *first_desc, *next_desc;
+	dma_addr_t buf_dma, next_desc_dma;
+	u32 buf_dma_len;
+
+	first_desc = desc;
+	next_desc = first_desc;
+
+	cppi5_hdesc_get_obuf(first_desc, &buf_dma, &buf_dma_len);
+	k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &buf_dma);
+
+	dma_unmap_single(tx_chn->dma_dev, buf_dma, buf_dma_len,
+			 DMA_TO_DEVICE);
+
+	next_desc_dma = cppi5_hdesc_get_next_hbdesc(first_desc);
+	k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &next_desc_dma);
+	while (next_desc_dma) {
+		next_desc = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
+						       next_desc_dma);
+		cppi5_hdesc_get_obuf(next_desc, &buf_dma, &buf_dma_len);
+		k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &buf_dma);
+
+		dma_unmap_page(tx_chn->dma_dev, buf_dma, buf_dma_len,
+			       DMA_TO_DEVICE);
+
+		next_desc_dma = cppi5_hdesc_get_next_hbdesc(next_desc);
+		k3_udma_glue_tx_cppi5_to_dma_addr(tx_chn->tx_chn, &next_desc_dma);
+
+		k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
+	}
+
+	k3_cppi_desc_pool_free(tx_chn->desc_pool, first_desc);
+}
+
+static int emac_tx_complete_packets(struct prueth_emac *emac, int chn,
+				    int budget)
+{
+	struct net_device *ndev = emac->ndev;
+	struct cppi5_host_desc_t *desc_tx;
+	struct netdev_queue *netif_txq;
+	struct prueth_tx_chn *tx_chn;
+	unsigned int total_bytes = 0;
+	struct sk_buff *skb;
+	dma_addr_t desc_dma;
+	int res, num_tx = 0;
+	void **swdata;
+
+	tx_chn = &emac->tx_chns[chn];
+
+	while (budget) {
+		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
+		if (res == -ENODATA)
+			break;
+
+		/* teardown completion */
+		if (cppi5_desc_is_tdcm(desc_dma)) {
+			if (atomic_dec_and_test(&emac->tdown_cnt))
+				complete(&emac->tdown_complete);
+			break;
+		}
+
+		desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
+						     desc_dma);
+		swdata = cppi5_hdesc_get_swdata(desc_tx);
+
+		skb = *(swdata);
+		prueth_xmit_free(tx_chn, desc_tx);
+
+		ndev = skb->dev;
+		ndev->stats.tx_packets++;
+		ndev->stats.tx_bytes += skb->len;
+		total_bytes += skb->len;
+		napi_consume_skb(skb, budget);
+		num_tx++;
+		budget--;
+	}
+
+	if (!num_tx)
+		return 0;
+
+	netif_txq = netdev_get_tx_queue(ndev, chn);
+	netdev_tx_completed_queue(netif_txq, num_tx, total_bytes);
+
+	if (netif_tx_queue_stopped(netif_txq)) {
+		/* If the TX queue was stopped, wake it now
+		 * if we have enough room.
+		 */
+		__netif_tx_lock(netif_txq, smp_processor_id());
+		if (netif_running(ndev) &&
+		    (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >=
+		     MAX_SKB_FRAGS))
+			netif_tx_wake_queue(netif_txq);
+		__netif_tx_unlock(netif_txq);
+	}
+
+	return num_tx;
+}
+
+static int emac_napi_tx_poll(struct napi_struct *napi_tx, int budget)
+{
+	struct prueth_tx_chn *tx_chn = prueth_napi_to_tx_chn(napi_tx);
+	struct prueth_emac *emac = tx_chn->emac;
+	int num_tx_packets;
+
+	num_tx_packets = emac_tx_complete_packets(emac, tx_chn->id, budget);
+
+	if (num_tx_packets < budget) {
+		napi_complete(napi_tx);
+		enable_irq(tx_chn->irq);
+	}
+
+	return num_tx_packets;
+}
+
+static irqreturn_t prueth_tx_irq(int irq, void *dev_id)
+{
+	struct prueth_tx_chn *tx_chn = dev_id;
+
+	disable_irq_nosync(irq);
+	napi_schedule(&tx_chn->napi_tx);
+
+	return IRQ_HANDLED;
+}
+
+static int prueth_ndev_add_tx_napi(struct prueth_emac *emac)
+{
+	struct prueth *prueth = emac->prueth;
+	int i, ret;
+
+	for (i = 0; i < emac->tx_ch_num; i++) {
+		struct prueth_tx_chn *tx_chn = &emac->tx_chns[i];
+
+		netif_tx_napi_add(emac->ndev, &tx_chn->napi_tx,
+				  emac_napi_tx_poll, NAPI_POLL_WEIGHT);
+		ret = request_irq(tx_chn->irq, prueth_tx_irq,
+				  IRQF_TRIGGER_HIGH, tx_chn->name,
+				  tx_chn);
+		if (ret) {
+			netif_napi_del(&tx_chn->napi_tx);
+			dev_err(prueth->dev, "unable to request TX IRQ %d\n",
+				tx_chn->irq);
+			goto fail;
+		}
+	}
+
+	return 0;
+fail:
+	prueth_ndev_del_tx_napi(emac, i);
+	return ret;
+}
+
+static int prueth_init_tx_chns(struct prueth_emac *emac)
+{
+	struct net_device *ndev = emac->ndev;
+	struct device *dev = emac->prueth->dev;
+	struct k3_udma_glue_tx_channel_cfg tx_cfg;
+	static const struct k3_ring_cfg ring_cfg = {
+		.elm_size = K3_RINGACC_RING_ELSIZE_8,
+		.mode = K3_RINGACC_RING_MODE_RING,
+		.flags = 0,
+		.size = PRUETH_MAX_TX_DESC,
+	};
+	int ret, slice, i;
+	u32 hdesc_size;
+
+	slice = prueth_emac_slice(emac);
+	if (slice < 0)
+		return slice;
+
+	init_completion(&emac->tdown_complete);
+
+	hdesc_size = cppi5_hdesc_calc_size(true, PRUETH_NAV_PS_DATA_SIZE,
+					   PRUETH_NAV_SW_DATA_SIZE);
+	memset(&tx_cfg, 0, sizeof(tx_cfg));
+	tx_cfg.swdata_size = PRUETH_NAV_SW_DATA_SIZE;
+	tx_cfg.tx_cfg = ring_cfg;
+	tx_cfg.txcq_cfg = ring_cfg;
+
+	for (i = 0; i < emac->tx_ch_num; i++) {
+		struct prueth_tx_chn *tx_chn = &emac->tx_chns[i];
+
+		/* To differentiate channels for SLICE0 vs SLICE1 */
+		snprintf(tx_chn->name, sizeof(tx_chn->name),
+			 "tx%d-%d", slice, i);
+
+		tx_chn->emac = emac;
+		tx_chn->id = i;
+		tx_chn->descs_num = PRUETH_MAX_TX_DESC;
+
+		tx_chn->tx_chn =
+			k3_udma_glue_request_tx_chn(dev, tx_chn->name,
+						    &tx_cfg);
+		if (IS_ERR(tx_chn->tx_chn)) {
+			ret = PTR_ERR(tx_chn->tx_chn);
+			tx_chn->tx_chn = NULL;
+			netdev_err(ndev,
+				   "Failed to request tx dma ch: %d\n", ret);
+			goto fail;
+		}
+
+		tx_chn->dma_dev = k3_udma_glue_tx_get_dma_device(tx_chn->tx_chn);
+		tx_chn->desc_pool =
+			k3_cppi_desc_pool_create_name(tx_chn->dma_dev,
+						      tx_chn->descs_num,
+						      hdesc_size,
+						      tx_chn->name);
+		if (IS_ERR(tx_chn->desc_pool)) {
+			ret = PTR_ERR(tx_chn->desc_pool);
+			tx_chn->desc_pool = NULL;
+			netdev_err(ndev, "Failed to create tx pool: %d\n", ret);
+			goto fail;
+		}
+
+		tx_chn->irq = k3_udma_glue_tx_get_irq(tx_chn->tx_chn);
+		if (tx_chn->irq <= 0) {
+			ret = -EINVAL;
+			netdev_err(ndev, "failed to get tx irq\n");
+			goto fail;
+		}
+
+		snprintf(tx_chn->name, sizeof(tx_chn->name), "%s-tx%d",
+			 dev_name(dev), tx_chn->id);
+	}
+
+	return 0;
+
+fail:
+	prueth_cleanup_tx_chns(emac);
+	return ret;
+}
+
+static int prueth_init_rx_chns(struct prueth_emac *emac,
+			       struct prueth_rx_chn *rx_chn,
+			       char *name, u32 max_rflows,
+			       u32 max_desc_num)
+{
+	struct net_device *ndev = emac->ndev;
+	struct device *dev = emac->prueth->dev;
+	struct k3_udma_glue_rx_channel_cfg rx_cfg;
+	u32 fdqring_id;
+	u32 hdesc_size;
+	int i, ret = 0, slice;
+
+	slice = prueth_emac_slice(emac);
+	if (slice < 0)
+		return slice;
+
+	/* To differentiate channels for SLICE0 vs SLICE1 */
+	snprintf(rx_chn->name, sizeof(rx_chn->name), "%s%d", name, slice);
+
+	hdesc_size = cppi5_hdesc_calc_size(true, PRUETH_NAV_PS_DATA_SIZE,
+					   PRUETH_NAV_SW_DATA_SIZE);
+	memset(&rx_cfg, 0, sizeof(rx_cfg));
+	rx_cfg.swdata_size = PRUETH_NAV_SW_DATA_SIZE;
+	rx_cfg.flow_id_num = max_rflows;
+	rx_cfg.flow_id_base = -1; /* udmax will auto select flow id base */
+
+	/* init all flows */
+	rx_chn->dev = dev;
+	rx_chn->descs_num = max_desc_num;
+
+	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, rx_chn->name,
+						     &rx_cfg);
+	if (IS_ERR(rx_chn->rx_chn)) {
+		ret = PTR_ERR(rx_chn->rx_chn);
+		rx_chn->rx_chn = NULL;
+		netdev_err(ndev, "Failed to request rx dma ch: %d\n", ret);
+		goto fail;
+	}
+
+	rx_chn->dma_dev = k3_udma_glue_rx_get_dma_device(rx_chn->rx_chn);
+	rx_chn->desc_pool = k3_cppi_desc_pool_create_name(rx_chn->dma_dev,
+							  rx_chn->descs_num,
+							  hdesc_size,
+							  rx_chn->name);
+	if (IS_ERR(rx_chn->desc_pool)) {
+		ret = PTR_ERR(rx_chn->desc_pool);
+		rx_chn->desc_pool = NULL;
+		netdev_err(ndev, "Failed to create rx pool: %d\n", ret);
+		goto fail;
+	}
+
+	emac->rx_flow_id_base = k3_udma_glue_rx_get_flow_id_base(rx_chn->rx_chn);
+	netdev_dbg(ndev, "flow id base = %d\n", emac->rx_flow_id_base);
+
+	fdqring_id = K3_RINGACC_RING_ID_ANY;
+	for (i = 0; i < rx_cfg.flow_id_num; i++) {
+		struct k3_ring_cfg rxring_cfg = {
+			.elm_size = K3_RINGACC_RING_ELSIZE_8,
+			.mode = K3_RINGACC_RING_MODE_RING,
+			.flags = 0,
+		};
+		struct k3_ring_cfg fdqring_cfg = {
+			.elm_size = K3_RINGACC_RING_ELSIZE_8,
+			.flags = K3_RINGACC_RING_SHARED,
+		};
+		struct k3_udma_glue_rx_flow_cfg rx_flow_cfg = {
+			.rx_cfg = rxring_cfg,
+			.rxfdq_cfg = fdqring_cfg,
+			.ring_rxq_id = K3_RINGACC_RING_ID_ANY,
+			.src_tag_lo_sel =
+				K3_UDMA_GLUE_SRC_TAG_LO_USE_REMOTE_SRC_TAG,
+		};
+
+		rx_flow_cfg.ring_rxfdq0_id = fdqring_id;
+		rx_flow_cfg.rx_cfg.size = max_desc_num;
+		rx_flow_cfg.rxfdq_cfg.size = max_desc_num;
+		rx_flow_cfg.rxfdq_cfg.mode = emac->prueth->pdata.fdqring_mode;
+
+		ret = k3_udma_glue_rx_flow_init(rx_chn->rx_chn,
+						i, &rx_flow_cfg);
+		if (ret) {
+			netdev_err(ndev, "Failed to init rx flow%d %d\n",
+				   i, ret);
+			goto fail;
+		}
+		if (!i)
+			fdqring_id = k3_udma_glue_rx_flow_get_fdq_id(rx_chn->rx_chn,
+								     i);
+		rx_chn->irq[i] = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
+		if (rx_chn->irq[i] <= 0) {
+			netdev_err(ndev, "Failed to get rx dma irq");
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	prueth_cleanup_rx_chns(emac, rx_chn, max_rflows);
+	return ret;
+}
+
+static int prueth_dma_rx_push(struct prueth_emac *emac,
+			      struct sk_buff *skb,
+			      struct prueth_rx_chn *rx_chn)
+{
+	struct cppi5_host_desc_t *desc_rx;
+	struct net_device *ndev = emac->ndev;
+	dma_addr_t desc_dma;
+	dma_addr_t buf_dma;
+	u32 pkt_len = skb_tailroom(skb);
+	void **swdata;
+
+	desc_rx = k3_cppi_desc_pool_alloc(rx_chn->desc_pool);
+	if (!desc_rx) {
+		netdev_err(ndev, "rx push: failed to allocate descriptor\n");
+		return -ENOMEM;
+	}
+	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
+
+	buf_dma = dma_map_single(rx_chn->dma_dev, skb->data, pkt_len, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(rx_chn->dma_dev, buf_dma))) {
+		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
+		netdev_err(ndev, "rx push: failed to map rx pkt buffer\n");
+		return -EINVAL;
+	}
+
+	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
+			 PRUETH_NAV_PS_DATA_SIZE);
+	k3_udma_glue_rx_dma_to_cppi5_addr(rx_chn->rx_chn, &buf_dma);
+	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
+
+	swdata = cppi5_hdesc_get_swdata(desc_rx);
+	*swdata = skb;
+
+	return k3_udma_glue_push_rx_chn(rx_chn->rx_chn, 0,
+					desc_rx, desc_dma);
+}
+
+static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id)
+{
+	struct prueth_rx_chn *rx_chn = &emac->rx_chns;
+	struct net_device *ndev = emac->ndev;
+	struct cppi5_host_desc_t *desc_rx;
+	dma_addr_t desc_dma, buf_dma;
+	u32 buf_dma_len, pkt_len, port_id = 0;
+	int ret;
+	void **swdata;
+	struct sk_buff *skb, *new_skb;
+
+	ret = k3_udma_glue_pop_rx_chn(rx_chn->rx_chn, flow_id, &desc_dma);
+	if (ret) {
+		if (ret != -ENODATA)
+			netdev_err(ndev, "rx pop: failed: %d\n", ret);
+		return ret;
+	}
+
+	if (cppi5_desc_is_tdcm(desc_dma)) /* Teardown ? */
+		return 0;
+
+	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
+
+	swdata = cppi5_hdesc_get_swdata(desc_rx);
+	skb = *swdata;
+
+	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
+	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
+	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
+	/* firmware adds 4 CRC bytes, strip them */
+	pkt_len -= 4;
+	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
+
+	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
+	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
+
+	skb->dev = ndev;
+	if (!netif_running(skb->dev)) {
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
+	new_skb = netdev_alloc_skb_ip_align(ndev, PRUETH_MAX_PKT_SIZE);
+	/* if allocation fails we drop the packet but push the
+	 * descriptor back to the ring with old skb to prevent a stall
+	 */
+	if (!new_skb) {
+		ndev->stats.rx_dropped++;
+		new_skb = skb;
+	} else {
+		/* send the filled skb up the n/w stack */
+		skb_put(skb, pkt_len);
+		skb->protocol = eth_type_trans(skb, ndev);
+		napi_gro_receive(&emac->napi_rx, skb);
+		ndev->stats.rx_bytes += pkt_len;
+		ndev->stats.rx_packets++;
+	}
+
+	/* queue another RX DMA */
+	ret = prueth_dma_rx_push(emac, new_skb, &emac->rx_chns);
+	if (WARN_ON(ret < 0)) {
+		dev_kfree_skb_any(new_skb);
+		ndev->stats.rx_errors++;
+		ndev->stats.rx_dropped++;
+	}
+
+	return ret;
+}
+
+static void prueth_rx_cleanup(void *data, dma_addr_t desc_dma)
+{
+	struct prueth_rx_chn *rx_chn = data;
+	struct cppi5_host_desc_t *desc_rx;
+	struct sk_buff *skb;
+	dma_addr_t buf_dma;
+	u32 buf_dma_len;
+	void **swdata;
+
+	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
+	swdata = cppi5_hdesc_get_swdata(desc_rx);
+	skb = *swdata;
+	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
+	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
+
+	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len,
+			 DMA_FROM_DEVICE);
+	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
+
+	dev_kfree_skb_any(skb);
+}
+
+/**
+ * emac_ndo_start_xmit - EMAC Transmit function
+ * @skb: SKB pointer
+ * @ndev: EMAC network adapter
+ *
+ * Called by the system to transmit a packet  - we queue the packet in
+ * EMAC hardware transmit queue
+ * Doesn't wait for completion we'll check for TX completion in
+ * emac_tx_complete_packets().
+ *
+ * Returns enum netdev_tx
+ */
+static enum netdev_tx emac_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+	struct cppi5_host_desc_t *first_desc, *next_desc, *cur_desc;
+	struct netdev_queue *netif_txq;
+	struct prueth_tx_chn *tx_chn;
+	dma_addr_t desc_dma, buf_dma;
+	int i, ret = 0, q_idx;
+	void **swdata;
+	u32 pkt_len;
+	u32 *epib;
+
+	pkt_len = skb_headlen(skb);
+	q_idx = skb_get_queue_mapping(skb);
+
+	tx_chn = &emac->tx_chns[q_idx];
+	netif_txq = netdev_get_tx_queue(ndev, q_idx);
+
+	/* Map the linear buffer */
+	buf_dma = dma_map_single(tx_chn->dma_dev, skb->data, pkt_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(tx_chn->dma_dev, buf_dma)) {
+		netdev_err(ndev, "tx: failed to map skb buffer\n");
+		ret = NETDEV_TX_BUSY;
+		goto drop_stop_q;
+	}
+
+	first_desc = k3_cppi_desc_pool_alloc(tx_chn->desc_pool);
+	if (!first_desc) {
+		netdev_dbg(ndev, "tx: failed to allocate descriptor\n");
+		dma_unmap_single(tx_chn->dma_dev, buf_dma, pkt_len, DMA_TO_DEVICE);
+		ret = NETDEV_TX_BUSY;
+		goto drop_stop_q_busy;
+	}
+
+	cppi5_hdesc_init(first_desc, CPPI5_INFO0_HDESC_EPIB_PRESENT,
+			 PRUETH_NAV_PS_DATA_SIZE);
+	cppi5_hdesc_set_pkttype(first_desc, 0);
+	epib = first_desc->epib;
+	epib[0] = 0;
+	epib[1] = 0;
+
+	/* set dst tag to indicate internal qid at the firmware which is at
+	 * bit8..bit15. bit0..bit7 indicates port num for directed
+	 * packets in case of switch mode operation
+	 */
+	cppi5_desc_set_tags_ids(&first_desc->hdr, 0, (emac->port_id | (q_idx << 8)));
+	k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &buf_dma);
+	cppi5_hdesc_attach_buf(first_desc, buf_dma, pkt_len, buf_dma, pkt_len);
+	swdata = cppi5_hdesc_get_swdata(first_desc);
+	*swdata = skb;
+
+	if (!skb_is_nonlinear(skb))
+		goto tx_push;
+
+	/* Handle the case where skb is fragmented in pages */
+	cur_desc = first_desc;
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		u32 frag_size = skb_frag_size(frag);
+
+		next_desc = k3_cppi_desc_pool_alloc(tx_chn->desc_pool);
+		if (!next_desc) {
+			netdev_err(ndev,
+				   "tx: failed to allocate frag. descriptor\n");
+			ret = NETDEV_TX_BUSY;
+			goto drop_free_descs;
+		}
+
+		buf_dma = skb_frag_dma_map(tx_chn->dma_dev, frag, 0, frag_size,
+					   DMA_TO_DEVICE);
+		if (dma_mapping_error(tx_chn->dma_dev, buf_dma)) {
+			netdev_err(ndev, "tx: Failed to map skb page\n");
+			k3_cppi_desc_pool_free(tx_chn->desc_pool, next_desc);
+			ret = NETDEV_TX_BUSY;
+			goto drop_free_descs;
+		}
+
+		cppi5_hdesc_reset_hbdesc(next_desc);
+		k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &buf_dma);
+		cppi5_hdesc_attach_buf(next_desc,
+				       buf_dma, frag_size, buf_dma, frag_size);
+
+		desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool,
+						      next_desc);
+		k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &desc_dma);
+		cppi5_hdesc_link_hbdesc(cur_desc, desc_dma);
+
+		pkt_len += frag_size;
+		cur_desc = next_desc;
+	}
+	WARN_ON(pkt_len != skb->len);
+
+tx_push:
+	/* report bql before sending packet */
+	netdev_tx_sent_queue(netif_txq, pkt_len);
+
+	cppi5_hdesc_set_pktlen(first_desc, pkt_len);
+	desc_dma = k3_cppi_desc_pool_virt2dma(tx_chn->desc_pool, first_desc);
+	/* cppi5_desc_dump(first_desc, 64); */
+
+	skb_tx_timestamp(skb);	/* SW timestamp if SKBTX_IN_PROGRESS not set */
+	ret = k3_udma_glue_push_tx_chn(tx_chn->tx_chn, first_desc, desc_dma);
+	if (ret) {
+		netdev_err(ndev, "tx: push failed: %d\n", ret);
+		goto drop_free_descs;
+	}
+
+	if (k3_cppi_desc_pool_avail(tx_chn->desc_pool) < MAX_SKB_FRAGS) {
+		netif_tx_stop_queue(netif_txq);
+		/* Barrier, so that stop_queue visible to other cpus */
+		smp_mb__after_atomic();
+
+		if (k3_cppi_desc_pool_avail(tx_chn->desc_pool) >=
+		    MAX_SKB_FRAGS)
+			netif_tx_wake_queue(netif_txq);
+	}
+
+	return NETDEV_TX_OK;
+
+drop_free_descs:
+	prueth_xmit_free(tx_chn, first_desc);
+drop_stop_q:
+	netif_tx_stop_queue(netif_txq);
+	dev_kfree_skb_any(skb);
+
+	/* error */
+	ndev->stats.tx_dropped++;
+	netdev_err(ndev, "tx: error: %d\n", ret);
+
+	return ret;
+
+drop_stop_q_busy:
+	netif_tx_stop_queue(netif_txq);
+	return NETDEV_TX_BUSY;
+}
+
+static void prueth_tx_cleanup(void *data, dma_addr_t desc_dma)
+{
+	struct prueth_tx_chn *tx_chn = data;
+	struct cppi5_host_desc_t *desc_tx;
+	struct sk_buff *skb;
+	void **swdata;
+
+	desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool, desc_dma);
+	swdata = cppi5_hdesc_get_swdata(desc_tx);
+	skb = *(swdata);
+	prueth_xmit_free(tx_chn, desc_tx);
+
+	dev_kfree_skb_any(skb);
+}
+
+static irqreturn_t prueth_rx_irq(int irq, void *dev_id)
+{
+	struct prueth_emac *emac = dev_id;
+
+	disable_irq_nosync(irq);
+	napi_schedule(&emac->napi_rx);
+
+	return IRQ_HANDLED;
+}
+
+struct icssg_firmwares {
+	char *pru;
+	char *rtu;
+	char *txpru;
+};
+
+static struct icssg_firmwares icssg_emac_firmwares[] = {
+	{
+		.pru = "ti-pruss/am65x-sr2-pru0-prueth-fw.elf",
+		.rtu = "ti-pruss/am65x-sr2-rtu0-prueth-fw.elf",
+		.txpru = "ti-pruss/am65x-sr2-txpru0-prueth-fw.elf",
+	},
+	{
+		.pru = "ti-pruss/am65x-sr2-pru1-prueth-fw.elf",
+		.rtu = "ti-pruss/am65x-sr2-rtu1-prueth-fw.elf",
+		.txpru = "ti-pruss/am65x-sr2-txpru1-prueth-fw.elf",
+	}
+};
+
+static int prueth_emac_start(struct prueth *prueth, struct prueth_emac *emac)
+{
+	struct icssg_firmwares *firmwares;
+	struct device *dev = prueth->dev;
+	int slice, ret;
+
+	firmwares = icssg_emac_firmwares;
+
+	slice = prueth_emac_slice(emac);
+	if (slice < 0) {
+		netdev_err(emac->ndev, "invalid port\n");
+		return -EINVAL;
+	}
+
+	ret = icssg_config(prueth, emac, slice);
+	if (ret)
+		return ret;
+
+	ret = rproc_set_firmware(prueth->pru[slice], firmwares[slice].pru);
+	ret = rproc_boot(prueth->pru[slice]);
+	if (ret) {
+		dev_err(dev, "failed to boot PRU%d: %d\n", slice, ret);
+		return -EINVAL;
+	}
+
+	ret = rproc_set_firmware(prueth->rtu[slice], firmwares[slice].rtu);
+	ret = rproc_boot(prueth->rtu[slice]);
+	if (ret) {
+		dev_err(dev, "failed to boot RTU%d: %d\n", slice, ret);
+		goto halt_pru;
+	}
+
+	ret = rproc_set_firmware(prueth->txpru[slice], firmwares[slice].txpru);
+	ret = rproc_boot(prueth->txpru[slice]);
+	if (ret) {
+		dev_err(dev, "failed to boot TX_PRU%d: %d\n", slice, ret);
+		goto halt_rtu;
+	}
+
+	emac->fw_running = 1;
+	return 0;
+
+halt_rtu:
+	rproc_shutdown(prueth->rtu[slice]);
+
+halt_pru:
+	rproc_shutdown(prueth->pru[slice]);
+
+	return ret;
+}
+
+static void prueth_emac_stop(struct prueth_emac *emac)
+{
+	struct prueth *prueth = emac->prueth;
+	int slice;
+
+	switch (emac->port_id) {
+	case PRUETH_PORT_MII0:
+		slice = ICSS_SLICE0;
+		break;
+	case PRUETH_PORT_MII1:
+		slice = ICSS_SLICE1;
+		break;
+	default:
+		netdev_err(emac->ndev, "invalid port\n");
+		return;
+	}
+
+	emac->fw_running = 0;
+	rproc_shutdown(prueth->txpru[slice]);
+	rproc_shutdown(prueth->rtu[slice]);
+	rproc_shutdown(prueth->pru[slice]);
+}
+
+/* called back by PHY layer if there is change in link state of hw port*/
+static void emac_adjust_link(struct net_device *ndev)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+	struct phy_device *phydev = ndev->phydev;
+	struct prueth *prueth = emac->prueth;
+	bool new_state = false;
+	unsigned long flags;
+
+	if (phydev->link) {
+		/* check the mode of operation - full/half duplex */
+		if (phydev->duplex != emac->duplex) {
+			new_state = true;
+			emac->duplex = phydev->duplex;
+		}
+		if (phydev->speed != emac->speed) {
+			new_state = true;
+			emac->speed = phydev->speed;
+		}
+		if (!emac->link) {
+			new_state = true;
+			emac->link = 1;
+		}
+	} else if (emac->link) {
+		new_state = true;
+		emac->link = 0;
+	}
+
+	if (new_state) {
+		phy_print_status(phydev);
+
+		/* update RGMII and MII configuration based on PHY negotiated
+		 * values
+		 */
+		if (emac->link) {
+			/* Set the RGMII cfg for gig en and full duplex */
+			icssg_update_rgmii_cfg(prueth->miig_rt, emac);
+
+			/* update the Tx IPG based on 100M/1G speed */
+			spin_lock_irqsave(&emac->lock, flags);
+			icssg_config_ipg(emac);
+			spin_unlock_irqrestore(&emac->lock, flags);
+			icssg_config_set_speed(emac);
+			emac_set_port_state(emac, ICSSG_EMAC_PORT_FORWARD);
+
+		} else {
+			emac_set_port_state(emac, ICSSG_EMAC_PORT_DISABLE);
+		}
+	}
+
+	if (emac->link) {
+		/* reactivate the transmit queue */
+		netif_tx_wake_all_queues(ndev);
+	} else {
+		netif_tx_stop_all_queues(ndev);
+	}
+}
+
+static int emac_napi_rx_poll(struct napi_struct *napi_rx, int budget)
+{
+	struct prueth_emac *emac = prueth_napi_to_emac(napi_rx);
+	int num_rx = 0;
+	int flow = PRUETH_MAX_RX_FLOWS;
+	int rx_flow = PRUETH_RX_FLOW_DATA;
+	int cur_budget;
+	int ret;
+
+	while (flow--) {
+		cur_budget = budget - num_rx;
+
+		while (cur_budget--) {
+			ret = emac_rx_packet(emac, flow);
+			if (ret)
+				break;
+			num_rx++;
+		}
+
+		if (num_rx >= budget)
+			break;
+	}
+
+	if (num_rx < budget) {
+		napi_complete(napi_rx);
+		enable_irq(emac->rx_chns.irq[rx_flow]);
+	}
+
+	return num_rx;
+}
+
+static int prueth_prepare_rx_chan(struct prueth_emac *emac,
+				  struct prueth_rx_chn *chn,
+				  int buf_size)
+{
+	struct sk_buff *skb;
+	int i, ret;
+
+	for (i = 0; i < chn->descs_num; i++) {
+		skb = __netdev_alloc_skb_ip_align(NULL, buf_size, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		ret = prueth_dma_rx_push(emac, skb, chn);
+		if (ret < 0) {
+			netdev_err(emac->ndev,
+				   "cannot submit skb for rx chan %s ret %d\n",
+				   chn->name, ret);
+			kfree_skb(skb);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void prueth_reset_tx_chan(struct prueth_emac *emac, int ch_num,
+				 bool free_skb)
+{
+	int i;
+
+	for (i = 0; i < ch_num; i++) {
+		if (free_skb)
+			k3_udma_glue_reset_tx_chn(emac->tx_chns[i].tx_chn,
+						  &emac->tx_chns[i],
+						  prueth_tx_cleanup);
+		k3_udma_glue_disable_tx_chn(emac->tx_chns[i].tx_chn);
+	}
+}
+
+static void prueth_reset_rx_chan(struct prueth_rx_chn *chn,
+				 int num_flows, bool disable)
+{
+	int i;
+
+	for (i = 0; i < num_flows; i++)
+		k3_udma_glue_reset_rx_chn(chn->rx_chn, i, chn,
+					  prueth_rx_cleanup, !!i);
+	if (disable)
+		k3_udma_glue_disable_rx_chn(chn->rx_chn);
+}
+
+static int emac_phy_connect(struct prueth_emac *emac)
+{
+	struct prueth *prueth = emac->prueth;
+	struct net_device *ndev = emac->ndev;
+	/* connect PHY */
+	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
+				      &emac_adjust_link, 0,
+				      emac->phy_if);
+	if (!ndev->phydev) {
+		dev_err(prueth->dev, "couldn't connect to phy %s\n",
+			emac->phy_node->full_name);
+		return -ENODEV;
+	}
+
+	/* remove unsupported modes */
+	phy_remove_link_mode(ndev->phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+	phy_remove_link_mode(ndev->phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(ndev->phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(ndev->phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	phy_remove_link_mode(ndev->phydev, ETHTOOL_LINK_MODE_Pause_BIT);
+	phy_remove_link_mode(ndev->phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
+
+	if (emac->phy_if == PHY_INTERFACE_MODE_MII)
+		phy_set_max_speed(ndev->phydev, SPEED_100);
+
+	return 0;
+}
+
+/**
+ * emac_ndo_open - EMAC device open
+ * @ndev: network adapter device
+ *
+ * Called when system wants to start the interface.
+ *
+ * Returns 0 for a successful open, or appropriate error code
+ */
+static int emac_ndo_open(struct net_device *ndev)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+	int ret, i, num_data_chn = emac->tx_ch_num;
+	struct prueth *prueth = emac->prueth;
+	int slice = prueth_emac_slice(emac);
+	struct device *dev = prueth->dev;
+	int max_rx_flows;
+	int rx_flow;
+
+	/* clear SMEM and MSMC settings for all slices */
+	if (!prueth->emacs_initialized) {
+		memset_io(prueth->msmcram.va, 0, prueth->msmcram.size);
+		memset_io(prueth->shram.va, 0, ICSSG_CONFIG_OFFSET_SLICE1 * PRUETH_NUM_MACS);
+	}
+
+	/* set h/w MAC as user might have re-configured */
+	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
+
+	icssg_class_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
+	icssg_ft1_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
+
+	icssg_class_default(prueth->miig_rt, slice, 0);
+
+	/* Notify the stack of the actual queue counts. */
+	ret = netif_set_real_num_tx_queues(ndev, num_data_chn);
+	if (ret) {
+		dev_err(dev, "cannot set real number of tx queues\n");
+		return ret;
+	}
+
+	init_completion(&emac->cmd_complete);
+	ret = prueth_init_tx_chns(emac);
+	if (ret) {
+		dev_err(dev, "failed to init tx channel: %d\n", ret);
+		return ret;
+	}
+
+	max_rx_flows = PRUETH_MAX_RX_FLOWS;
+	ret = prueth_init_rx_chns(emac, &emac->rx_chns, "rx",
+				  max_rx_flows, PRUETH_MAX_RX_DESC);
+	if (ret) {
+		dev_err(dev, "failed to init rx channel: %d\n", ret);
+		goto cleanup_tx;
+	}
+
+	ret = prueth_ndev_add_tx_napi(emac);
+	if (ret)
+		goto cleanup_rx;
+
+	/* we use only the highest priority flow for now i.e. @irq[3] */
+	rx_flow = PRUETH_RX_FLOW_DATA;
+	ret = request_irq(emac->rx_chns.irq[rx_flow], prueth_rx_irq,
+			  IRQF_TRIGGER_HIGH, dev_name(dev), emac);
+	if (ret) {
+		dev_err(dev, "unable to request RX IRQ\n");
+		goto cleanup_napi;
+	}
+
+	/* reset and start PRU firmware */
+	ret = prueth_emac_start(prueth, emac);
+	if (ret)
+		goto free_rx_irq;
+
+	/* Prepare RX */
+	ret = prueth_prepare_rx_chan(emac, &emac->rx_chns, PRUETH_MAX_PKT_SIZE);
+	if (ret)
+		goto stop;
+
+	ret = k3_udma_glue_enable_rx_chn(emac->rx_chns.rx_chn);
+	if (ret)
+		goto reset_rx_chn;
+
+	for (i = 0; i < emac->tx_ch_num; i++) {
+		ret = k3_udma_glue_enable_tx_chn(emac->tx_chns[i].tx_chn);
+		if (ret)
+			goto reset_tx_chan;
+	}
+
+	/* Enable NAPI in Tx and Rx direction */
+	for (i = 0; i < emac->tx_ch_num; i++)
+		napi_enable(&emac->tx_chns[i].napi_tx);
+	napi_enable(&emac->napi_rx);
+
+	/* start PHY */
+	phy_start(ndev->phydev);
+
+	prueth->emacs_initialized++;
+
+	return 0;
+
+reset_tx_chan:
+	/* Since interface is not yet up, there is wouldn't be
+	 * any SKB for completion. So set false to free_skb
+	 */
+	prueth_reset_tx_chan(emac, i, false);
+reset_rx_chn:
+	prueth_reset_rx_chan(&emac->rx_chns, max_rx_flows, false);
+stop:
+	prueth_emac_stop(emac);
+free_rx_irq:
+	free_irq(emac->rx_chns.irq[rx_flow], emac);
+cleanup_napi:
+	prueth_ndev_del_tx_napi(emac, emac->tx_ch_num);
+cleanup_rx:
+	prueth_cleanup_rx_chns(emac, &emac->rx_chns, max_rx_flows);
+cleanup_tx:
+	prueth_cleanup_tx_chns(emac);
+
+	return ret;
+}
+
+/**
+ * emac_ndo_stop - EMAC device stop
+ * @ndev: network adapter device
+ *
+ * Called when system wants to stop or down the interface.
+ */
+static int emac_ndo_stop(struct net_device *ndev)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+	struct prueth *prueth = emac->prueth;
+	int ret, i;
+	int max_rx_flows;
+	int rx_flow = PRUETH_RX_FLOW_DATA;
+
+	/* inform the upper layers. */
+	netif_tx_stop_all_queues(ndev);
+
+	/* block packets from wire */
+	if (ndev->phydev)
+		phy_stop(ndev->phydev);
+
+	icssg_class_disable(prueth->miig_rt, prueth_emac_slice(emac));
+
+	atomic_set(&emac->tdown_cnt, emac->tx_ch_num);
+	/* ensure new tdown_cnt value is visible */
+	smp_mb__after_atomic();
+	/* tear down and disable UDMA channels */
+	reinit_completion(&emac->tdown_complete);
+	for (i = 0; i < emac->tx_ch_num; i++)
+		k3_udma_glue_tdown_tx_chn(emac->tx_chns[i].tx_chn, false);
+
+	ret = wait_for_completion_timeout(&emac->tdown_complete,
+					  msecs_to_jiffies(1000));
+	if (!ret)
+		netdev_err(ndev, "tx teardown timeout\n");
+
+	prueth_reset_tx_chan(emac, emac->tx_ch_num, true);
+	for (i = 0; i < emac->tx_ch_num; i++)
+		napi_disable(&emac->tx_chns[i].napi_tx);
+
+	max_rx_flows = PRUETH_MAX_RX_FLOWS;
+	k3_udma_glue_tdown_rx_chn(emac->rx_chns.rx_chn, true);
+
+	prueth_reset_rx_chan(&emac->rx_chns, max_rx_flows, true);
+
+	napi_disable(&emac->napi_rx);
+
+	cancel_work_sync(&emac->rx_mode_work);
+	/* stop PRUs */
+	prueth_emac_stop(emac);
+
+	free_irq(emac->rx_chns.irq[rx_flow], emac);
+	prueth_ndev_del_tx_napi(emac, emac->tx_ch_num);
+	prueth_cleanup_tx_chns(emac);
+
+	prueth_cleanup_rx_chns(emac, &emac->rx_chns, max_rx_flows);
+	prueth_cleanup_tx_chns(emac);
+
+	prueth->emacs_initialized--;
+
+	return 0;
+}
+
+static void emac_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+
+	if (netif_msg_tx_err(emac))
+		netdev_err(ndev, "xmit timeout");
+
+	ndev->stats.tx_errors++;
+}
+
+static void emac_ndo_set_rx_mode_work(struct work_struct *work)
+{
+	struct prueth_emac *emac = container_of(work, struct prueth_emac, rx_mode_work);
+	struct net_device *ndev = emac->ndev;
+	bool promisc, allmulti;
+
+	if (!netif_running(ndev))
+		return;
+
+	promisc = ndev->flags & IFF_PROMISC;
+	allmulti = ndev->flags & IFF_ALLMULTI;
+	emac_set_port_state(emac, ICSSG_EMAC_PORT_UC_FLOODING_DISABLE);
+	emac_set_port_state(emac, ICSSG_EMAC_PORT_MC_FLOODING_DISABLE);
+
+	if (promisc) {
+		emac_set_port_state(emac, ICSSG_EMAC_PORT_UC_FLOODING_ENABLE);
+		emac_set_port_state(emac, ICSSG_EMAC_PORT_MC_FLOODING_ENABLE);
+		return;
+	}
+
+	if (allmulti) {
+		emac_set_port_state(emac, ICSSG_EMAC_PORT_MC_FLOODING_ENABLE);
+		return;
+	}
+
+	if (!netdev_mc_empty(ndev)) {
+		emac_set_port_state(emac, ICSSG_EMAC_PORT_MC_FLOODING_ENABLE);
+		return;
+	}
+}
+
+/**
+ * emac_ndo_set_rx_mode - EMAC set receive mode function
+ * @ndev: The EMAC network adapter
+ *
+ * Called when system wants to set the receive mode of the device.
+ *
+ */
+static void emac_ndo_set_rx_mode(struct net_device *ndev)
+{
+	struct prueth_emac *emac = netdev_priv(ndev);
+
+	queue_work(emac->cmd_wq, &emac->rx_mode_work);
+}
+
+static int emac_ndo_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
+{
+	return phy_do_ioctl(ndev, ifr, cmd);
+}
+
+static const struct net_device_ops emac_netdev_ops = {
+	.ndo_open = emac_ndo_open,
+	.ndo_stop = emac_ndo_stop,
+	.ndo_start_xmit = emac_ndo_start_xmit,
+	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_tx_timeout = emac_ndo_tx_timeout,
+	.ndo_set_rx_mode = emac_ndo_set_rx_mode,
+	.ndo_do_ioctl = emac_ndo_ioctl,
+};
+
+/* get emac_port corresponding to eth_node name */
+static int prueth_node_port(struct device_node *eth_node)
+{
+	u32 port_id;
+	int ret;
+
+	ret = of_property_read_u32(eth_node, "reg", &port_id);
+	if (ret)
+		return ret;
+
+	if (port_id == 0)
+		return PRUETH_PORT_MII0;
+	else if (port_id == 1)
+		return PRUETH_PORT_MII1;
+	else
+		return -EINVAL;
+}
+
+/* get MAC instance corresponding to eth_node name */
+static int prueth_node_mac(struct device_node *eth_node)
+{
+	u32 port_id;
+	int ret;
+
+	ret = of_property_read_u32(eth_node, "reg", &port_id);
+	if (ret)
+		return ret;
+
+	if (port_id == 0)
+		return PRUETH_MAC0;
+	else if (port_id == 1)
+		return PRUETH_MAC1;
+	else
+		return -EINVAL;
+}
+
+static int prueth_config_rgmiidelay(struct prueth *prueth,
+				    struct device_node *eth_np,
+				    phy_interface_t phy_if)
+{
+	struct device *dev = prueth->dev;
+	struct regmap *ctrl_mmr;
+	u32 rgmii_tx_id = 0;
+	u32 icssgctrl_reg;
+
+	if (!phy_interface_mode_is_rgmii(phy_if))
+		return 0;
+
+	ctrl_mmr = syscon_regmap_lookup_by_phandle(eth_np, "ti,syscon-rgmii-delay");
+	if (IS_ERR(ctrl_mmr)) {
+		dev_err(dev, "couldn't get ti,syscon-rgmii-delay\n");
+		return -ENODEV;
+	}
+
+	if (of_property_read_u32_index(eth_np, "ti,syscon-rgmii-delay", 1,
+				       &icssgctrl_reg)) {
+		dev_err(dev, "couldn't get ti,rgmii-delay reg. offset\n");
+		return -ENODEV;
+	}
+
+	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
+		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
+
+	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
+
+	return 0;
+}
+
+extern const struct ethtool_ops icssg_ethtool_ops;
+
+static int prueth_netdev_init(struct prueth *prueth,
+			      struct device_node *eth_node)
+{
+	int ret, num_tx_chn = PRUETH_MAX_TX_QUEUES;
+	struct prueth_emac *emac;
+	struct net_device *ndev;
+	enum prueth_port port;
+	enum prueth_mac mac;
+
+	port = prueth_node_port(eth_node);
+	if (port < 0)
+		return -EINVAL;
+
+	mac = prueth_node_mac(eth_node);
+	if (mac < 0)
+		return -EINVAL;
+
+	ndev = alloc_etherdev_mq(sizeof(*emac), num_tx_chn);
+	if (!ndev)
+		return -ENOMEM;
+
+	emac = netdev_priv(ndev);
+	prueth->emac[mac] = emac;
+	emac->prueth = prueth;
+	emac->ndev = ndev;
+	emac->port_id = port;
+	emac->cmd_wq = create_singlethread_workqueue("icssg_cmd_wq");
+	if (!emac->cmd_wq) {
+		ret = -ENOMEM;
+		goto free_ndev;
+	}
+	INIT_WORK(&emac->rx_mode_work, emac_ndo_set_rx_mode_work);
+
+	ret = pruss_request_mem_region(prueth->pruss,
+				       port == PRUETH_PORT_MII0 ?
+				       PRUSS_MEM_DRAM0 : PRUSS_MEM_DRAM1,
+				       &emac->dram);
+	if (ret) {
+		dev_err(prueth->dev, "unable to get DRAM: %d\n", ret);
+		ret = -ENOMEM;
+		goto free_wq;
+	}
+
+	emac->tx_ch_num = 1;
+
+	SET_NETDEV_DEV(ndev, prueth->dev);
+	spin_lock_init(&emac->lock);
+	mutex_init(&emac->cmd_lock);
+
+	emac->phy_node = of_parse_phandle(eth_node, "phy-handle", 0);
+	if (!emac->phy_node && !of_phy_is_fixed_link(eth_node)) {
+		dev_err(prueth->dev, "couldn't find phy-handle\n");
+		ret = -ENODEV;
+		goto free;
+	} else if (of_phy_is_fixed_link(eth_node)) {
+		ret = of_phy_register_fixed_link(eth_node);
+		if (ret) {
+			ret = dev_err_probe(prueth->dev, ret,
+					    "failed to register fixed-link phy\n");
+			goto free;
+		}
+
+		emac->phy_node = eth_node;
+	}
+
+	ret = of_get_phy_mode(eth_node, &emac->phy_if);
+	if (ret) {
+		dev_err(prueth->dev, "could not get phy-mode property\n");
+		goto free;
+	}
+
+	if (emac->phy_if != PHY_INTERFACE_MODE_MII &&
+	    !phy_interface_mode_is_rgmii(emac->phy_if)) {
+		dev_err(prueth->dev, "PHY mode unsupported %s\n", phy_modes(emac->phy_if));
+		goto free;
+	}
+
+	ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
+	if (ret)
+		goto free;
+
+	/* get mac address from DT and set private and netdev addr */
+	ret = of_get_ethdev_address(eth_node, ndev);
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		eth_hw_addr_random(ndev);
+		dev_warn(prueth->dev, "port %d: using random MAC addr: %pM\n",
+			 port, ndev->dev_addr);
+	}
+	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
+
+	ndev->netdev_ops = &emac_netdev_ops;
+	ndev->ethtool_ops = &icssg_ethtool_ops;
+	ndev->hw_features = NETIF_F_SG;
+	ndev->features = ndev->hw_features;
+
+	netif_napi_add(ndev, &emac->napi_rx,
+		       emac_napi_rx_poll, NAPI_POLL_WEIGHT);
+
+	return 0;
+
+free:
+	pruss_release_mem_region(prueth->pruss, &emac->dram);
+free_wq:
+	destroy_workqueue(emac->cmd_wq);
+free_ndev:
+	free_netdev(ndev);
+	prueth->emac[mac] = NULL;
+
+	return ret;
+}
+
+static void prueth_netdev_exit(struct prueth *prueth,
+			       struct device_node *eth_node)
+{
+	struct prueth_emac *emac;
+	enum prueth_mac mac;
+
+	mac = prueth_node_mac(eth_node);
+	if (mac < 0)
+		return;
+
+	emac = prueth->emac[mac];
+	if (!emac)
+		return;
+
+	if (of_phy_is_fixed_link(emac->phy_node))
+		of_phy_deregister_fixed_link(emac->phy_node);
+
+	netif_napi_del(&emac->napi_rx);
+
+	pruss_release_mem_region(prueth->pruss, &emac->dram);
+	destroy_workqueue(emac->cmd_wq);
+	free_netdev(emac->ndev);
+	prueth->emac[mac] = NULL;
+}
+
+static int prueth_get_cores(struct prueth *prueth, int slice)
+{
+	enum pruss_pru_id pruss_id;
+	struct device *dev = prueth->dev;
+	struct device_node *np = dev->of_node;
+	int idx = -1, ret;
+
+	switch (slice) {
+	case ICSS_SLICE0:
+		idx = 0;
+		break;
+	case ICSS_SLICE1:
+		idx = 3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	prueth->pru[slice] = pru_rproc_get(np, idx, &pruss_id);
+	if (IS_ERR(prueth->pru[slice])) {
+		ret = PTR_ERR(prueth->pru[slice]);
+		prueth->pru[slice] = NULL;
+		return dev_err_probe(dev, ret, "unable to get PRU%d\n", slice);
+	}
+	prueth->pru_id[slice] = pruss_id;
+
+	idx++;
+	prueth->rtu[slice] = pru_rproc_get(np, idx, NULL);
+	if (IS_ERR(prueth->rtu[slice])) {
+		ret = PTR_ERR(prueth->rtu[slice]);
+		prueth->rtu[slice] = NULL;
+		return dev_err_probe(dev, ret, "unable to get RTU%d\n", slice);
+	}
+
+	idx++;
+	prueth->txpru[slice] = pru_rproc_get(np, idx, NULL);
+	if (IS_ERR(prueth->txpru[slice])) {
+		ret = PTR_ERR(prueth->txpru[slice]);
+		prueth->txpru[slice] = NULL;
+		return dev_err_probe(dev, ret, "unable to get TX_PRU%d\n", slice);
+	}
+
+	return 0;
+}
+
+static void prueth_put_cores(struct prueth *prueth, int slice)
+{
+	if (prueth->txpru[slice])
+		pru_rproc_put(prueth->txpru[slice]);
+
+	if (prueth->rtu[slice])
+		pru_rproc_put(prueth->rtu[slice]);
+
+	if (prueth->pru[slice])
+		pru_rproc_put(prueth->pru[slice]);
+}
+
+static const struct of_device_id prueth_dt_match[];
+
+static int prueth_probe(struct platform_device *pdev)
+{
+	struct prueth *prueth;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *eth_ports_node;
+	struct device_node *eth_node;
+	struct device_node *eth0_node, *eth1_node;
+	const struct of_device_id *match;
+	struct pruss *pruss;
+	int i, ret;
+	u32 msmc_ram_size;
+	struct genpool_data_align gp_data = {
+		.align = SZ_64K,
+	};
+
+	match = of_match_device(prueth_dt_match, dev);
+	if (!match)
+		return -ENODEV;
+
+	prueth = devm_kzalloc(dev, sizeof(*prueth), GFP_KERNEL);
+	if (!prueth)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, prueth);
+	prueth->pdev = pdev;
+	prueth->pdata = *(const struct prueth_pdata *)match->data;
+
+	prueth->dev = dev;
+	eth_ports_node = of_get_child_by_name(np, "ethernet-ports");
+	if (!eth_ports_node)
+		return -ENOENT;
+
+	for_each_child_of_node(eth_ports_node, eth_node) {
+		u32 reg;
+
+		if (strcmp(eth_node->name, "port"))
+			continue;
+		ret = of_property_read_u32(eth_node, "reg", &reg);
+		if (ret < 0) {
+			dev_err(dev, "%pOF error reading port_id %d\n",
+				eth_node, ret);
+		}
+
+		of_node_get(eth_node);
+
+		if (reg == 0)
+			eth0_node = eth_node;
+		else if (reg == 1)
+			eth1_node = eth_node;
+		else
+			dev_err(dev, "port reg should be 0 or 1\n");
+	}
+
+	of_node_put(eth_ports_node);
+
+	/* At least one node must be present and available else we fail */
+	if (!eth0_node && !eth1_node) {
+		dev_err(dev, "neither port0 nor port1 node available\n");
+		return -ENODEV;
+	}
+
+	if (eth0_node == eth1_node) {
+		dev_err(dev, "port0 and port1 can't have same reg\n");
+		of_node_put(eth0_node);
+		return -ENODEV;
+	}
+
+	prueth->eth_node[PRUETH_MAC0] = eth0_node;
+	prueth->eth_node[PRUETH_MAC1] = eth1_node;
+
+	prueth->miig_rt = syscon_regmap_lookup_by_phandle(np, "ti,mii-g-rt");
+	if (IS_ERR(prueth->miig_rt)) {
+		dev_err(dev, "couldn't get ti,mii-g-rt syscon regmap\n");
+		return -ENODEV;
+	}
+
+	prueth->mii_rt = syscon_regmap_lookup_by_phandle(np, "ti,mii-rt");
+	if (IS_ERR(prueth->mii_rt)) {
+		dev_err(dev, "couldn't get ti,mii-rt syscon regmap\n");
+		return -ENODEV;
+	}
+
+	if (eth0_node) {
+		ret = prueth_get_cores(prueth, ICSS_SLICE0);
+		if (ret)
+			goto put_cores;
+	}
+
+	if (eth1_node) {
+		ret = prueth_get_cores(prueth, ICSS_SLICE1);
+		if (ret)
+			goto put_cores;
+	}
+
+	pruss = pruss_get(eth0_node ?
+			  prueth->pru[ICSS_SLICE0] : prueth->pru[ICSS_SLICE1]);
+	if (IS_ERR(pruss)) {
+		ret = PTR_ERR(pruss);
+		dev_err(dev, "unable to get pruss handle\n");
+		goto put_cores;
+	}
+
+	prueth->pruss = pruss;
+
+	ret = pruss_request_mem_region(pruss, PRUSS_MEM_SHRD_RAM2,
+				       &prueth->shram);
+	if (ret) {
+		dev_err(dev, "unable to get PRUSS SHRD RAM2: %d\n", ret);
+		pruss_put(prueth->pruss);
+	}
+
+	prueth->sram_pool = of_gen_pool_get(np, "sram", 0);
+	if (!prueth->sram_pool) {
+		dev_err(dev, "unable to get SRAM pool\n");
+		ret = -ENODEV;
+
+		goto put_mem;
+	}
+
+	msmc_ram_size = MSMC_RAM_SIZE;
+
+	/* NOTE: FW bug needs buffer base to be 64KB aligned */
+	prueth->msmcram.va =
+		(void __iomem *)gen_pool_alloc_algo(prueth->sram_pool,
+						    msmc_ram_size,
+						    gen_pool_first_fit_align,
+						    &gp_data);
+
+	if (!prueth->msmcram.va) {
+		ret = -ENOMEM;
+		dev_err(dev, "unable to allocate MSMC resource\n");
+		goto put_mem;
+	}
+	prueth->msmcram.pa = gen_pool_virt_to_phys(prueth->sram_pool,
+						   (unsigned long)prueth->msmcram.va);
+	prueth->msmcram.size = msmc_ram_size;
+	memset(prueth->msmcram.va, 0, msmc_ram_size);
+	dev_dbg(dev, "sram: pa %llx va %p size %zx\n", prueth->msmcram.pa,
+		prueth->msmcram.va, prueth->msmcram.size);
+
+	/* setup netdev interfaces */
+	if (eth0_node) {
+		ret = prueth_netdev_init(prueth, eth0_node);
+		if (ret) {
+			dev_err_probe(dev, ret, "netdev init %s failed: %d\n",
+				      eth0_node->name);
+			goto netdev_exit;
+		}
+	}
+
+	if (eth1_node) {
+		ret = prueth_netdev_init(prueth, eth1_node);
+		if (ret) {
+			dev_err_probe(dev, ret, "netdev init %s failed: %d\n",
+				      eth1_node->name);
+			goto netdev_exit;
+		}
+	}
+
+	/* register the network devices */
+	if (eth0_node) {
+		ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
+		if (ret) {
+			dev_err(dev, "can't register netdev for port MII0");
+			goto netdev_exit;
+		}
+
+		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
+
+		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
+		phy_attached_info(prueth->emac[PRUETH_MAC0]->ndev->phydev);
+	}
+
+	if (eth1_node) {
+		ret = register_netdev(prueth->emac[PRUETH_MAC1]->ndev);
+		if (ret) {
+			dev_err(dev, "can't register netdev for port MII1");
+			goto netdev_unregister;
+		}
+
+		prueth->registered_netdevs[PRUETH_MAC1] = prueth->emac[PRUETH_MAC1]->ndev;
+		emac_phy_connect(prueth->emac[PRUETH_MAC1]);
+		phy_attached_info(prueth->emac[PRUETH_MAC1]->ndev->phydev);
+	}
+
+	dev_info(dev, "TI PRU ethernet driver initialized: %s EMAC mode\n",
+		 (!eth0_node || !eth1_node) ? "single" : "dual");
+
+	if (eth1_node)
+		of_node_put(eth1_node);
+	if (eth0_node)
+		of_node_put(eth0_node);
+	return 0;
+
+netdev_unregister:
+	for (i = 0; i < PRUETH_NUM_MACS; i++) {
+		if (!prueth->registered_netdevs[i])
+			continue;
+		if (prueth->emac[i]->ndev->phydev) {
+			phy_disconnect(prueth->emac[i]->ndev->phydev);
+			prueth->emac[i]->ndev->phydev = NULL;
+		}
+		unregister_netdev(prueth->registered_netdevs[i]);
+	}
+
+netdev_exit:
+	for (i = 0; i < PRUETH_NUM_MACS; i++) {
+		struct device_node *eth_node;
+
+		eth_node = prueth->eth_node[i];
+		if (!eth_node)
+			continue;
+
+		prueth_netdev_exit(prueth, eth_node);
+	}
+
+	gen_pool_free(prueth->sram_pool,
+		      (unsigned long)prueth->msmcram.va, msmc_ram_size);
+
+put_mem:
+	pruss_release_mem_region(prueth->pruss, &prueth->shram);
+	pruss_put(prueth->pruss);
+
+put_cores:
+	if (eth1_node) {
+		prueth_put_cores(prueth, ICSS_SLICE1);
+		of_node_put(eth1_node);
+	}
+
+	if (eth0_node) {
+		prueth_put_cores(prueth, ICSS_SLICE0);
+		of_node_put(eth0_node);
+	}
+
+	return ret;
+}
+
+static int prueth_remove(struct platform_device *pdev)
+{
+	struct device_node *eth_node;
+	struct prueth *prueth = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < PRUETH_NUM_MACS; i++) {
+		if (!prueth->registered_netdevs[i])
+			continue;
+		phy_stop(prueth->emac[i]->ndev->phydev);
+		phy_disconnect(prueth->emac[i]->ndev->phydev);
+		prueth->emac[i]->ndev->phydev = NULL;
+		unregister_netdev(prueth->registered_netdevs[i]);
+	}
+
+	for (i = 0; i < PRUETH_NUM_MACS; i++) {
+		eth_node = prueth->eth_node[i];
+		if (!eth_node)
+			continue;
+
+		prueth_netdev_exit(prueth, eth_node);
+	}
+
+	gen_pool_free(prueth->sram_pool,
+		      (unsigned long)prueth->msmcram.va,
+		      MSMC_RAM_SIZE);
+
+	pruss_release_mem_region(prueth->pruss, &prueth->shram);
+
+	pruss_put(prueth->pruss);
+
+	if (prueth->eth_node[PRUETH_MAC1])
+		prueth_put_cores(prueth, ICSS_SLICE1);
+
+	if (prueth->eth_node[PRUETH_MAC0])
+		prueth_put_cores(prueth, ICSS_SLICE0);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int prueth_suspend(struct device *dev)
+{
+	struct prueth *prueth = dev_get_drvdata(dev);
+	struct net_device *ndev;
+	int i, ret;
+
+	for (i = 0; i < PRUETH_NUM_MACS; i++) {
+		ndev = prueth->registered_netdevs[i];
+
+		if (!ndev)
+			continue;
+
+		if (netif_running(ndev)) {
+			netif_device_detach(ndev);
+			ret = emac_ndo_stop(ndev);
+			if (ret < 0) {
+				netdev_err(ndev, "failed to stop: %d", ret);
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int prueth_resume(struct device *dev)
+{
+	struct prueth *prueth = dev_get_drvdata(dev);
+	struct net_device *ndev;
+	int i, ret;
+
+	for (i = 0; i < PRUETH_NUM_MACS; i++) {
+		ndev = prueth->registered_netdevs[i];
+
+		if (!ndev)
+			continue;
+
+		if (netif_running(ndev)) {
+			ret = emac_ndo_open(ndev);
+			if (ret < 0) {
+				netdev_err(ndev, "failed to start: %d", ret);
+				return ret;
+			}
+			netif_device_attach(ndev);
+		}
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops prueth_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(prueth_suspend, prueth_resume)
+};
+
+static const struct prueth_pdata am654_icssg_pdata = {
+	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
+	.quirk_10m_link_issue = 1,
+};
+
+static const struct of_device_id prueth_dt_match[] = {
+	{ .compatible = "ti,am654-icssg-prueth", .data = &am654_icssg_pdata },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, prueth_dt_match);
+
+static struct platform_driver prueth_driver = {
+	.probe = prueth_probe,
+	.remove = prueth_remove,
+	.driver = {
+		.name = "icssg-prueth",
+		.of_match_table = prueth_dt_match,
+		.pm = &prueth_dev_pm_ops,
+	},
+};
+module_platform_driver(prueth_driver);
+
+MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
+MODULE_AUTHOR("Puranjay Mohan <p-mohan@ti.com>");
+MODULE_AUTHOR("Md Danish Anwar <danishanwar@ti.com>");
+MODULE_DESCRIPTION("PRUSS ICSSG Ethernet Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/icssg_prueth.h b/drivers/net/ethernet/ti/icssg_prueth.h
new file mode 100644
index 000000000000..a24e7ec3ad8f
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_prueth.h
@@ -0,0 +1,246 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Texas Instruments ICSSG Ethernet driver
+ *
+ * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ */
+
+#ifndef __NET_TI_ICSSG_PRUETH_H
+#define __NET_TI_ICSSG_PRUETH_H
+
+#include <linux/etherdevice.h>
+#include <linux/genalloc.h>
+#include <linux/if_vlan.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/net_tstamp.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/pruss.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/remoteproc.h>
+
+#include <linux/dma-mapping.h>
+#include <linux/dma/ti-cppi5.h>
+#include <linux/dma/k3-udma-glue.h>
+
+#include <net/devlink.h>
+
+#include "icssg_config.h"
+#include "icssg_switch_map.h"
+
+#define ICSS_SLICE0	0
+#define ICSS_SLICE1	1
+
+#define ICSS_FW_PRU	0
+#define ICSS_FW_RTU	1
+
+#define ICSSG_MAX_RFLOWS	8	/* per slice */
+
+/* Firmware status codes */
+#define ICSS_HS_FW_READY 0x55555555
+#define ICSS_HS_FW_DEAD 0xDEAD0000	/* lower 16 bits contain error code */
+
+/* Firmware command codes */
+#define ICSS_HS_CMD_BUSY 0x40000000
+#define ICSS_HS_CMD_DONE 0x80000000
+#define ICSS_HS_CMD_CANCEL 0x10000000
+
+/* Firmware commands */
+#define ICSS_CMD_SPAD 0x20
+#define ICSS_CMD_RXTX 0x10
+#define ICSS_CMD_ADD_FDB 0x1
+#define ICSS_CMD_DEL_FDB 0x2
+#define ICSS_CMD_SET_RUN 0x4
+#define ICSS_CMD_GET_FDB_SLOT 0x5
+#define ICSS_CMD_ENABLE_VLAN 0x5
+#define ICSS_CMD_DISABLE_VLAN 0x6
+#define ICSS_CMD_ADD_FILTER 0x7
+#define ICSS_CMD_ADD_MAC 0x8
+
+/* In switch mode there are 3 real ports i.e. 3 mac addrs.
+ * however Linux sees only the host side port. The other 2 ports
+ * are the switch ports.
+ * In emac mode there are 2 real ports i.e. 2 mac addrs.
+ * Linux sees both the ports.
+ */
+enum prueth_port {
+	PRUETH_PORT_HOST = 0,	/* host side port */
+	PRUETH_PORT_MII0,	/* physical port RG/SG MII 0 */
+	PRUETH_PORT_MII1,	/* physical port RG/SG MII 1 */
+};
+
+enum prueth_mac {
+	PRUETH_MAC0 = 0,
+	PRUETH_MAC1,
+	PRUETH_NUM_MACS,
+};
+
+struct prueth_tx_chn {
+	struct device *dma_dev;
+	struct napi_struct napi_tx;
+	struct k3_cppi_desc_pool *desc_pool;
+	struct k3_udma_glue_tx_channel *tx_chn;
+	struct prueth_emac *emac;
+	u32 id;
+	u32 descs_num;
+	unsigned int irq;
+	char name[32];
+};
+
+struct prueth_rx_chn {
+	struct device *dev;
+	struct device *dma_dev;
+	struct k3_cppi_desc_pool *desc_pool;
+	struct k3_udma_glue_rx_channel *rx_chn;
+	u32 descs_num;
+	unsigned int irq[ICSSG_MAX_RFLOWS];	/* separate irq per flow */
+	char name[32];
+};
+
+/* There are 4 Tx DMA channels, but the highest priority is CH3 (thread 3)
+ * and lower three are lower priority channels or threads.
+ */
+#define PRUETH_MAX_TX_QUEUES	4
+
+/* data for each emac port */
+struct prueth_emac {
+	bool fw_running;
+	struct prueth *prueth;
+	struct net_device *ndev;
+	u8 mac_addr[6];
+	struct napi_struct napi_rx;
+	u32 msg_enable;
+
+	int link;
+	int speed;
+	int duplex;
+
+	const char *phy_id;
+	struct device_node *phy_node;
+	phy_interface_t phy_if;
+	enum prueth_port port_id;
+
+	/* DMA related */
+	struct prueth_tx_chn tx_chns[PRUETH_MAX_TX_QUEUES];
+	struct completion tdown_complete;
+	atomic_t tdown_cnt;
+	struct prueth_rx_chn rx_chns;
+	int rx_flow_id_base;
+	int tx_ch_num;
+
+	spinlock_t lock;	/* serialize access */
+
+	unsigned long state;
+	struct completion cmd_complete;
+	/* Mutex to serialize access to firmware command interface */
+	struct mutex cmd_lock;
+	struct work_struct rx_mode_work;
+	struct workqueue_struct	*cmd_wq;
+
+	struct pruss_mem_region dram;
+};
+
+/**
+ * struct prueth - PRUeth platform data
+ * @fdqring_mode: Free desc queue mode
+ * @quirk_10m_link_issue: 10M link detect errata
+ */
+struct prueth_pdata {
+	enum k3_ring_mode fdqring_mode;
+	u32	quirk_10m_link_issue:1;
+};
+
+/**
+ * struct prueth - PRUeth structure
+ * @dev: device
+ * @pruss: pruss handle
+ * @pru: rproc instances of PRUs
+ * @rtu: rproc instances of RTUs
+ * @rtu: rproc instances of TX_PRUs
+ * @shram: PRUSS shared RAM region
+ * @sram_pool: MSMC RAM pool for buffers
+ * @msmcram: MSMC RAM region
+ * @eth_node: DT node for the port
+ * @emac: private EMAC data structure
+ * @registered_netdevs: list of registered netdevs
+ * @fw_data: firmware names to be used with PRU remoteprocs
+ * @config: firmware load time configuration per slice
+ * @miig_rt: regmap to mii_g_rt block
+ * @pa_stats: regmap to pa_stats block
+ * @pru_id: ID for each of the PRUs
+ * @pdev: pointer to ICSSG platform device
+ * @pdata: pointer to platform data for ICSSG driver
+ * @icssg_hwcmdseq: seq counter or HWQ messages
+ * @emacs_initialized: num of EMACs/ext ports that are up/running
+ */
+struct prueth {
+	struct device *dev;
+	struct pruss *pruss;
+	struct rproc *pru[PRUSS_NUM_PRUS];
+	struct rproc *rtu[PRUSS_NUM_PRUS];
+	struct rproc *txpru[PRUSS_NUM_PRUS];
+	struct pruss_mem_region shram;
+	struct gen_pool *sram_pool;
+	struct pruss_mem_region msmcram;
+
+	struct device_node *eth_node[PRUETH_NUM_MACS];
+	struct prueth_emac *emac[PRUETH_NUM_MACS];
+	struct net_device *registered_netdevs[PRUETH_NUM_MACS];
+	const struct prueth_private_data *fw_data;
+	struct regmap *miig_rt;
+	struct regmap *mii_rt;
+	struct regmap *pa_stats;
+
+	enum pruss_pru_id pru_id[PRUSS_NUM_PRUS];
+	struct platform_device *pdev;
+	struct prueth_pdata pdata;
+	u8 icssg_hwcmdseq;
+
+	int emacs_initialized;
+};
+
+/* Classifier helpers */
+void icssg_class_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac);
+void icssg_class_set_host_mac_addr(struct regmap *miig_rt, const u8 *mac);
+void icssg_class_disable(struct regmap *miig_rt, int slice);
+void icssg_class_default(struct regmap *miig_rt, int slice, bool allmulti);
+void icssg_ft1_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac_addr);
+
+/* Buffer queue helpers */
+int icssg_queue_pop(struct prueth *prueth, u8 queue);
+void icssg_queue_push(struct prueth *prueth, int queue, u16 addr);
+u32 icssg_queue_level(struct prueth *prueth, int queue);
+
+/* get PRUSS SLICE number from prueth_emac */
+static inline int prueth_emac_slice(struct prueth_emac *emac)
+{
+	switch (emac->port_id) {
+	case PRUETH_PORT_MII0:
+		return ICSS_SLICE0;
+	case PRUETH_PORT_MII1:
+		return ICSS_SLICE1;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* config helpers */
+void icssg_config_ipg(struct prueth_emac *emac);
+int icssg_config(struct prueth *prueth, struct prueth_emac *emac,
+		 int slice);
+int emac_set_port_state(struct prueth_emac *emac,
+			enum icssg_port_state_cmd state);
+void icssg_config_set_speed(struct prueth_emac *emac);
+
+#define prueth_napi_to_tx_chn(pnapi) \
+	container_of(pnapi, struct prueth_tx_chn, napi_tx)
+
+#endif /* __NET_TI_ICSSG_PRUETH_H */
diff --git a/drivers/net/ethernet/ti/icssg_switch_map.h b/drivers/net/ethernet/ti/icssg_switch_map.h
new file mode 100644
index 000000000000..60dd78cc54aa
--- /dev/null
+++ b/drivers/net/ethernet/ti/icssg_switch_map.h
@@ -0,0 +1,183 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Texas Instruments ICSSG Ethernet driver
+ *
+ * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
+ *
+ *
+ */
+
+#ifndef __NET_TI_ICSSG_SWITCH_MAP_H
+#define __NET_TI_ICSSG_SWITCH_MAP_H
+
+/************************* Ethernet Switch Constants *********************/
+
+/* if bucket size is changed in firmware then this too should be changed */
+/* because it directly impacts FDB ageing calculation */
+#define NUMBER_OF_FDB_BUCKET_ENTRIES            (4)
+#define SIZE_OF_FDB                             (2048)  /* This is fixed in ICSSG */
+
+/* Memory Usage of : SHARED_MEMORY
+ *
+ */
+
+#define FW_LINK_SPEED_1G                           (0x00)
+#define FW_LINK_SPEED_100M                         (0x01)
+#define FW_LINK_SPEED_10M                          (0x02)
+#define FW_LINK_SPEED_HD                           (0x80)
+
+/*Time after which FDB entries are checked for aged out values. Value in nanoseconds*/
+#define FDB_AGEING_TIMEOUT_OFFSET                          0x0014
+/*default VLAN tag for Host Port*/
+#define HOST_PORT_DF_VLAN_OFFSET                           0x001C
+/*Same as HOST_PORT_DF_VLAN_OFFSET*/
+#define EMAC_ICSSG_SWITCH_PORT0_DEFAULT_VLAN_OFFSET        HOST_PORT_DF_VLAN_OFFSET
+/*default VLAN tag for P1 Port*/
+#define P1_PORT_DF_VLAN_OFFSET                             0x0020
+/*Same as P1_PORT_DF_VLAN_OFFSET*/
+#define EMAC_ICSSG_SWITCH_PORT1_DEFAULT_VLAN_OFFSET        P1_PORT_DF_VLAN_OFFSET
+/*default VLAN tag for P2 Port*/
+#define P2_PORT_DF_VLAN_OFFSET                             0x0024
+/*Same as P2_PORT_DF_VLAN_OFFSET*/
+#define EMAC_ICSSG_SWITCH_PORT2_DEFAULT_VLAN_OFFSET        P2_PORT_DF_VLAN_OFFSET
+/*VLAN-FID Table offset. 4096 VIDs. 2B per VID = 8KB = 0x2000*/
+#define VLAN_STATIC_REG_TABLE_OFFSET                       0x0100
+/*VLAN-FID Table offset for EMAC*/
+#define EMAC_ICSSG_SWITCH_DEFAULT_VLAN_TABLE_OFFSET        VLAN_STATIC_REG_TABLE_OFFSET
+/*packet descriptor Q reserved memory*/
+#define PORT_DESC0_HI                                      0x2104
+/*packet descriptor Q reserved memory*/
+#define PORT_DESC0_LO                                      0x2F6C
+/*packet descriptor Q reserved memory*/
+#define PORT_DESC1_HI                                      0x3DD4
+/*packet descriptor Q reserved memory*/
+#define PORT_DESC1_LO                                      0x4C3C
+/*packet descriptor Q reserved memory*/
+#define HOST_DESC0_HI                                      0x5AA4
+/*packet descriptor Q reserved memory*/
+#define HOST_DESC0_LO                                      0x5F0C
+/*packet descriptor Q reserved memory*/
+#define HOST_DESC1_HI                                      0x6374
+/*packet descriptor Q reserved memory*/
+#define HOST_DESC1_LO                                      0x67DC
+/*special packet descriptor Q reserved memory*/
+#define HOST_SPPD0                                         0x7AAC
+/*special packet descriptor Q reserved memory*/
+#define HOST_SPPD1                                         0x7EAC
+/*_Small_Description_*/
+#define TIMESYNC_FW_WC_CYCLECOUNT_OFFSET                   0x83EC
+/*IEP count hi roll over count*/
+#define TIMESYNC_FW_WC_HI_ROLLOVER_COUNT_OFFSET            0x83F4
+/*_Small_Description_*/
+#define TIMESYNC_FW_WC_COUNT_HI_SW_OFFSET_OFFSET           0x83F8
+/*Set clock descriptor*/
+#define TIMESYNC_FW_WC_SETCLOCK_DESC_OFFSET                0x83FC
+/*_Small_Description_*/
+#define TIMESYNC_FW_WC_SYNCOUT_REDUCTION_FACTOR_OFFSET     0x843C
+/*_Small_Description_*/
+#define TIMESYNC_FW_WC_SYNCOUT_REDUCTION_COUNT_OFFSET      0x8440
+/*_Small_Description_*/
+#define TIMESYNC_FW_WC_SYNCOUT_START_TIME_CYCLECOUNT_OFFSET 0x8444
+/*Control variable to generate SYNC1*/
+#define TIMESYNC_FW_WC_ISOM_PIN_SIGNAL_EN_OFFSET           0x844C
+/*SystemTime Sync0 periodicity*/
+#define TIMESYNC_FW_ST_SYNCOUT_PERIOD_OFFSET               0x8450
+/*pktTxDelay for P1 = link speed dependent p1 mac delay + p1 phy delay*/
+#define TIMESYNC_FW_WC_PKTTXDELAY_P1_OFFSET                0x8454
+/*pktTxDelay for P2 = link speed dependent p2 mac delay + p2 phy delay*/
+#define TIMESYNC_FW_WC_PKTTXDELAY_P2_OFFSET                0x8458
+/*Set clock operation done signal for next task*/
+#define TIMESYNC_FW_SIG_PNFW_OFFSET                        0x845C
+/*Set clock operation done signal for next task*/
+#define TIMESYNC_FW_SIG_TIMESYNCFW_OFFSET                  0x8460
+
+/* Memory Usage of : MSMC
+ *
+ */
+
+/* Memory Usage of : DMEM0
+ *
+ */
+
+/*New list is copied at this time*/
+#define TAS_CONFIG_CHANGE_TIME                             0x000C
+/*config change error counter*/
+#define TAS_CONFIG_CHANGE_ERROR_COUNTER                    0x0014
+/*TAS List update pending flag*/
+#define TAS_CONFIG_PENDING                                 0x0018
+/*TAS list update trigger flag*/
+#define TAS_CONFIG_CHANGE                                  0x0019
+/*List length for new TAS schedule*/
+#define TAS_ADMIN_LIST_LENGTH                              0x001A
+/*Currently active TAS list index*/
+#define TAS_ACTIVE_LIST_INDEX                              0x001B
+/*Cycle time for the new TAS schedule*/
+#define TAS_ADMIN_CYCLE_TIME                               0x001C
+/*Cycle counts remaining till the TAS list update*/
+#define TAS_CONFIG_CHANGE_CYCLE_COUNT                      0x0020
+/*Base Flow ID for sending packets to Host for Slice0*/
+#define PSI_L_REGULAR_FLOW_ID_BASE_OFFSET                  0x0024
+/*Same as PSI_L_REGULAR_FLOW_ID_BASE_OFFSET*/
+#define EMAC_ICSSG_SWITCH_PSI_L_REGULAR_FLOW_ID_BASE_OFFSET PSI_L_REGULAR_FLOW_ID_BASE_OFFSET
+/*Base Flow ID for sending mgmt and Tx TS to Host for Slice0*/
+#define PSI_L_MGMT_FLOW_ID_OFFSET                          0x0026
+/*Same as PSI_L_MGMT_FLOW_ID_OFFSET*/
+#define EMAC_ICSSG_SWITCH_PSI_L_MGMT_FLOW_ID_BASE_OFFSET   PSI_L_MGMT_FLOW_ID_OFFSET
+/*Queue number for Special packets written here*/
+#define SPL_PKT_DEFAULT_PRIORITY                           0x0028
+/*Express Preemptible Queue Mask*/
+#define EXPRESS_PRE_EMPTIVE_Q_MASK                         0x0029
+/*Port1/Port2 Default Queue number for untagged packets, only 1B is used*/
+#define QUEUE_NUM_UNTAGGED                                 0x002A
+/*Stores the table used for priority regeneration. 1B per PCP/Queue*/
+#define PORT_Q_PRIORITY_REGEN_OFFSET                       0x002C
+/*For marking packet as priority/express (this feature is disabled) or cut-through/S&F.*/
+#define EXPRESS_PRE_EMPTIVE_Q_MAP                          0x0034
+/*Stores the table used for priority mapping. 1B per PCP/Queue*/
+#define PORT_Q_PRIORITY_MAPPING_OFFSET                     0x003C
+/*Used to notify the FW of the current link speed*/
+#define PORT_LINK_SPEED_OFFSET                             0x00A8
+/*TAS gate mask for windows list0*/
+#define TAS_GATE_MASK_LIST0                                0x0100
+/*TAS gate mask for windows list1*/
+#define TAS_GATE_MASK_LIST1                                0x0350
+/*Memory to Enable/Disable Preemption on TX side*/
+#define PRE_EMPTION_ENABLE_TX                              0x05A0
+/*Active State of Preemption on TX side*/
+#define PRE_EMPTION_ACTIVE_TX                              0x05A1
+/*Memory to Enable/Disable Verify State Machine Preemption*/
+#define PRE_EMPTION_ENABLE_VERIFY                          0x05A2
+/*Verify Status of State Machine*/
+#define PRE_EMPTION_VERIFY_STATUS                          0x05A3
+/*Non Final Fragment Size supported by Link Partner*/
+#define PRE_EMPTION_ADD_FRAG_SIZE_REMOTE                   0x05A4
+/*Non Final Fragment Size supported by Firmware*/
+#define PRE_EMPTION_ADD_FRAG_SIZE_LOCAL                    0x05A6
+/*Time in ms the State machine waits for respond packet*/
+#define PRE_EMPTION_VERIFY_TIME                            0x05A8
+/*Memory used for R30 related management commands*/
+#define MGR_R30_CMD_OFFSET                                 0x05AC
+/*HW Buffer Pool0 base address*/
+#define BUFFER_POOL_0_ADDR_OFFSET                          0x05BC
+/*16B for Host Egress MSMC Q (Pre-emptible) context*/
+#define HOST_RX_Q_PRE_CONTEXT_OFFSET                       0x0684
+/*Buffer for 8 FDB entries to be added by 'Add Multiple FDB entries IOCTL*/
+#define FDB_CMD_BUFFER                                     0x0894
+/*TAS queue max sdu length list*/
+#define TAS_QUEUE_MAX_SDU_LIST                             0x08FA
+/*Used by FW to generate random number with the SEED value*/
+#define HD_RAND_SEED_OFFSET                                0x0934
+/*16B for Host Egress MSMC Q (Express) context*/
+#define HOST_RX_Q_EXP_CONTEXT_OFFSET                       0x0940
+
+/* Memory Usage of : DMEM1
+ *
+ */
+
+/* Memory Usage of : PA_STAT
+ *
+ */
+
+/*Start of 32 bits PA_STAT counters*/
+#define PA_STAT_32b_START_OFFSET                           0x0080
+
+#endif /* __NET_TI_ICSSG_SWITCH_MAP_H */
diff --git a/include/linux/pruss.h b/include/linux/pruss.h
index 7e5e904521ac..b4f6a26aac9b 100644
--- a/include/linux/pruss.h
+++ b/include/linux/pruss.h
@@ -73,6 +73,7 @@
 /* PRUSS_SPP register bits */
 #define PRUSS_SPP_XFER_SHIFT_EN			BIT(1)
 #define PRUSS_SPP_PRU1_PAD_HP_EN		BIT(0)
+#define PRUSS_SPP_RTU_XFR_SHIFT_EN		BIT(3)
 
 /*
  * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
-- 
2.25.1
