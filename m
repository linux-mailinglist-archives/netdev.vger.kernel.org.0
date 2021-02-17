Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE031D55B
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhBQGWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhBQGWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:22:33 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A69C061756
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:21:52 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id k13so7749099pfh.13
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zJAakdj7dfOoViM+qNqJMG6moK66RQqpEKGt63jtwyE=;
        b=ryDwHlP9LAeOeIkxzaEiVBWc+/IIwTBUjaCW/mYtk4Tk/QU5EcaPVw68Qct89j1s0+
         TlkFN2d51kefl2E7pSpdtK1yqVOEnnF/fqo0ag27P+/uo/P724xEZNmgAe+hpvKlkQJq
         M/VSddS/S9VZyptjRlZp95HdXwjWF1fnzOX6+ieuUZeaQW05U17wRkCvhax7xknaHy2q
         3LuZLtw0dKYq1ERShwm2f9ZUMjkvmTXmqE2+sIiJx4NJL8PdEgcde6QDptmt0suCNg7T
         Oy9X2EepcjBCTwRyYbidi2JajFHxEE44dsyl5SGri2s56gznD8TWewtiTKzBJCjYU7PZ
         cqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zJAakdj7dfOoViM+qNqJMG6moK66RQqpEKGt63jtwyE=;
        b=gRr1xBUFnBitSG/QQU4wrGIiXgdqviWRZCeqQzxwJFDGxQVQJ3qWA1oxx75rkN5eee
         mopRCXMOoh9hqD/tdeBNjamyyaaZ8Dggr7E4mZeIApPN73Kdk8SX/wAi+IfEr4HpqPmX
         gkU5T7EkaQySnZUdh3P74d4HsvpDomxyLP3SHB6TyCmpClzrk4qgCDfyonLPkh2ivAiI
         RMNZzAezrSQOFGMQbvoc1cFksAMkxQWcuQ3vSpBAOfn6J39CsWNuHG7qzyGDp0hen7TW
         iMbiZ7Zzv4Tz/EPts/cIe2J3Z/Zktf5ou00Z/5H7D51K95bJ8WoQ5N0t4nKzULVnmtzh
         eKVg==
X-Gm-Message-State: AOAM533lyaGtrn1weOc5CXBhMjqFCLKXbfnRNt4nMJaIdsL4LERxOnDs
        uiFGGZVUnFJC0bVW1DDl6vk=
X-Google-Smtp-Source: ABdhPJzRofMmHqijPCGA3egwayiaXChi3paJ5jMGnwAii5ZH3Om0d2+28gqsiGWTXOQQ6v1oQgKTqQ==
X-Received: by 2002:a05:6a00:884:b029:1b4:440f:bce7 with SMTP id q4-20020a056a000884b02901b4440fbce7mr23902432pfj.20.1613542912239;
        Tue, 16 Feb 2021 22:21:52 -0800 (PST)
Received: from Haswell.lan ([2a09:bac0:23::815:b46])
        by smtp.gmail.com with ESMTPSA id p2sm843233pjv.31.2021.02.16.22.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 22:21:51 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [RFC net-next 2/2] net: dsa: add Realtek RTL8366S switch driver
Date:   Wed, 17 Feb 2021 14:21:39 +0800
Message-Id: <20210217062139.7893-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217062139.7893-1-dqfext@gmail.com>
References: <20210217062139.7893-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support Realtek RTL8366S/SR switch

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/Kconfig            |    1 +
 drivers/net/dsa/Makefile           |    2 +-
 drivers/net/dsa/realtek-smi-core.c |    3 +-
 drivers/net/dsa/realtek-smi-core.h |    1 +
 drivers/net/dsa/rtl8366s.c         | 1165 ++++++++++++++++++++++++++++
 5 files changed, 1169 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/dsa/rtl8366s.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 3af373e90806..52f1df6ef53a 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -75,6 +75,7 @@ config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI Ethernet switch family support"
 	depends on NET_DSA
 	select NET_DSA_TAG_RTL4_A
+	select NET_DSA_TAG_RTL8366S
 	select FIXED_PHY
 	select IRQ_DOMAIN
 	select REALTEK_PHY
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index f3598c040994..8c51c25d8378 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
-realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o
+realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8366s.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index 8e49d4f85d48..e0ced416c362 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -480,9 +480,8 @@ static const struct of_device_id realtek_smi_of_match[] = {
 		.data = &rtl8366rb_variant,
 	},
 	{
-		/* FIXME: add support for RTL8366S and more */
 		.compatible = "realtek,rtl8366s",
-		.data = NULL,
+		.data = &rtl8366s_variant,
 	},
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index fcf465f7f922..a5d45b6f6de3 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -143,5 +143,6 @@ int rtl8366_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void rtl8366_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 
 extern const struct realtek_smi_variant rtl8366rb_variant;
+extern const struct realtek_smi_variant rtl8366s_variant;
 
 #endif /*  _REALTEK_SMI_H */
diff --git a/drivers/net/dsa/rtl8366s.c b/drivers/net/dsa/rtl8366s.c
new file mode 100644
index 000000000000..718e492f8bbd
--- /dev/null
+++ b/drivers/net/dsa/rtl8366s.c
@@ -0,0 +1,1165 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Realtek SMI subdriver for the Realtek RTL8366S ethernet switch
+ *
+ * Copyright (C) 2021 DENG, Qingfang <dqfext@gmail.com>
+ * Copyright (C) 2009-2010 Gabor Juhos <juhosg@openwrt.org>
+ * Copyright (C) 2010 Antti Seppälä <a.seppala@gmail.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
+#include <linux/regmap.h>
+
+#include "realtek-smi-core.h"
+
+#define RTL8366S_PHY_NO_MAX	4
+#define RTL8366S_PHY_PAGE_MAX	7
+#define RTL8366S_PHY_ADDR_MAX	31
+
+/* Switch Global Configuration register */
+#define RTL8366S_SGCR				0x0000
+#define RTL8366S_SGCR_EN_BC_STORM_CTRL		BIT(0)
+#define RTL8366S_SGCR_MAX_LENGTH(_x)		(_x << 4)
+#define RTL8366S_SGCR_MAX_LENGTH_MASK		RTL8366S_SGCR_MAX_LENGTH(0x3)
+#define RTL8366S_SGCR_MAX_LENGTH_1522		RTL8366S_SGCR_MAX_LENGTH(0x0)
+#define RTL8366S_SGCR_MAX_LENGTH_1536		RTL8366S_SGCR_MAX_LENGTH(0x1)
+#define RTL8366S_SGCR_MAX_LENGTH_1552		RTL8366S_SGCR_MAX_LENGTH(0x2)
+#define RTL8366S_SGCR_MAX_LENGTH_16000		RTL8366S_SGCR_MAX_LENGTH(0x3)
+#define RTL8366S_SGCR_EN_VLAN			BIT(13)
+
+/* Port Enable Control register */
+#define RTL8366S_PECR				0x0001
+
+/* Switch Security Control registers */
+#define RTL8366S_SSCR0				0x0002
+#define RTL8366S_SSCR1				0x0003
+#define RTL8366S_SSCR2				0x0004
+#define RTL8366S_SSCR2_DROP_UNKNOWN_DA		BIT(0)
+
+/* Port Mode Control registers */
+#define RTL8366S_PMC0				0x0005
+#define RTL8366S_PMC0_SPI			BIT(0)
+#define RTL8366S_PMC0_EN_AUTOLOAD		BIT(1)
+#define RTL8366S_PMC0_PROBE			BIT(2)
+#define RTL8366S_PMC0_DIS_BISR			BIT(3)
+#define RTL8366S_PMC0_ADCTEST			BIT(4)
+#define RTL8366S_PMC0_SRAM_DIAG			BIT(5)
+#define RTL8366S_PMC0_EN_SCAN			BIT(6)
+#define RTL8366S_PMC0_P4_IOMODE_MASK		GENMASK(9, 7)
+#define RTL8366S_PMC0_P4_IOMODE_PHY_TO_GMAC	\
+	FIELD_PREP(RTL8366S_PMC0_P4_IOMODE_MASK, 0)
+#define RTL8366S_PMC0_P4_IOMODE_GMAC_TO_RGMII	\
+	FIELD_PREP(RTL8366S_PMC0_P4_IOMODE_MASK, 1)
+#define RTL8366S_PMC0_P4_IOMODE_PHY_TO_RGMII	\
+	FIELD_PREP(RTL8366S_PMC0_P4_IOMODE_MASK, 2)
+#define RTL8366S_PMC0_P5_IOMODE_MASK		GENMASK(12, 10)
+#define RTL8366S_PMC0_SDSMODE_MASK		GENMASK(15, 13)
+#define RTL8366S_PMC1				0x0006
+
+/* Port Mirror Control Register */
+#define RTL8366S_PMCR				0x0007
+#define RTL8366S_PMCR_SOURCE_MASK		GENMASK(3, 0)
+#define RTL8366S_PMCR_MINITOR_MASK		GENMASK(7, 4)
+#define RTL8366S_PMCR_MIRROR_RX			BIT(8)
+#define RTL8366S_PMCR_MIRROR_TX			BIT(9)
+#define RTL8366S_PMCR_MIRROR_SPC		BIT(10)
+#define RTL8366S_PMCR_MIRROR_ISO		BIT(11)
+
+/* Keep format on egress */
+#define RTL8366S_EGRESS_KEEP_FORMAT_REG		0x0008
+#define RTL8366S_EGRESS_KEEP_FORMAT_MASK	GENMASK(15, 8)
+#define RTL8366S_EGRESS_KEEP_FORMAT_ALL	\
+	FIELD_PREP(RTL8366S_EGRESS_KEEP_FORMAT_MASK, RTL8366S_PORT_ALL)
+
+/* Green Ethernet Feature (based on GPL_BELKIN_F5D8235-4_v1000 v1.01.24) */
+#define RTL8366S_GREEN_ETHERNET_CTRL_REG	0x000a
+#define RTL8366S_GREEN_ETHERNET_CTRL_MASK	0x0018
+#define RTL8366S_GREEN_ETHERNET_TX		BIT(3)
+#define RTL8366S_GREEN_ETHERNET_RX		BIT(4)
+
+/* bits 0..7 = port 0, bits 8..15 = port 1 */
+#define RTL8366S_PAACR0			0x0011
+/* bits 0..7 = port 2, bits 8..15 = port 3 */
+#define RTL8366S_PAACR1			0x0012
+/* bits 0..7 = port 4, bits 8..15 = port 5 */
+#define RTL8366S_PAACR2			0x0013
+#define RTL8366S_PAACR_SPEED_10M	0
+#define RTL8366S_PAACR_SPEED_100M	1
+#define RTL8366S_PAACR_SPEED_1000M	2
+#define RTL8366S_PAACR_FULL_DUPLEX	BIT(2)
+#define RTL8366S_PAACR_LINK_UP		BIT(4)
+#define RTL8366S_PAACR_TX_PAUSE		BIT(5)
+#define RTL8366S_PAACR_RX_PAUSE		BIT(6)
+#define RTL8366S_PAACR_AN		BIT(7)
+
+#define RTL8366S_PAACR_CPU_PORT	(RTL8366S_PAACR_SPEED_1000M | \
+				 RTL8366S_PAACR_FULL_DUPLEX | \
+				 RTL8366S_PAACR_LINK_UP | \
+				 RTL8366S_PAACR_TX_PAUSE | \
+				 RTL8366S_PAACR_RX_PAUSE)
+
+/* Spanning Tree Protocol register */
+#define RTL8366S_STP_BASE			0x003a
+#define RTL8366S_STP_REG(_p)	\
+		(RTL8366S_STP_BASE + (_p))
+#define RTL8366S_STP_MASK			GENMASK(1, 0)
+
+enum RTL8366S_STP_STATE
+{
+	RTL8366S_STP_DISABLED = 0,
+	RTL8366S_STP_BLOCKING,
+	RTL8366S_STP_LEARNING,
+	RTL8366S_STP_FORWARDING,
+};
+
+#define RTL8366S_CPU_CTRL_REG			0x004f
+#define RTL8366S_CPU_DROP_UNKNOWN_DA		BIT(14)
+#define RTL8366S_CPU_NO_TAG			BIT(15)
+
+#define RTL8366S_PORT_VLAN_CTRL_BASE		0x0058
+#define RTL8366S_PORT_VLAN_CTRL_REG(_p)  \
+		(RTL8366S_PORT_VLAN_CTRL_BASE + (_p) / 4)
+#define RTL8366S_PORT_VLAN_CTRL_MASK		0xf
+#define RTL8366S_PORT_VLAN_CTRL_SHIFT(_p)	(4 * ((_p) % 4))
+
+#define RTL8366S_PORT_LINK_STATUS_BASE		0x0060
+#define RTL8366S_PORT_STATUS_SPEED_MASK		0x0003
+#define RTL8366S_PORT_STATUS_DUPLEX_MASK	0x0004
+#define RTL8366S_PORT_STATUS_LINK_MASK		0x0010
+#define RTL8366S_PORT_STATUS_TXPAUSE_MASK	0x0020
+#define RTL8366S_PORT_STATUS_RXPAUSE_MASK	0x0040
+#define RTL8366S_PORT_STATUS_AN_MASK		0x0080
+
+#define RTL8366S_RESET_CTRL_REG			0x0100
+#define RTL8366S_CHIP_CTRL_RESET_HW		BIT(0)
+#define RTL8366S_CHIP_CTRL_RESET_SW		BIT(1)
+
+#define RTL8366S_CHIP_VERSION_CTRL_REG		0x0104
+#define RTL8366S_CHIP_VERSION_MASK		0xf
+#define RTL8366S_CHIP_ID_REG			0x0105
+#define RTL8366S_CHIP_ID_8366			0x8366
+
+/* VLAN 4K access registers */
+#define RTL8366S_VLAN_TB_CTRL_REG		0x010f
+
+#define RTL8366S_TABLE_ACCESS_CTRL_REG		0x0180
+#define RTL8366S_TABLE_VLAN_READ_CTRL		0x0E01
+#define RTL8366S_TABLE_VLAN_WRITE_CTRL		0x0F01
+
+#define RTL8366S_VLAN_TABLE_READ_BASE		0x018B
+#define RTL8366S_VLAN_TABLE_WRITE_BASE		0x0185
+
+/* VLAN filtering registers */
+#define RTL8366S_VLAN_TAGINGRESS_REG		0x0378
+#define RTL8366S_VLAN_MEMBERINGRESS_REG		0x0379
+
+/* Link aggregation registers */
+#define RTL8366S_LAGCR				0x0380
+#define RTL8366S_LAGCR_MODE_DUMP		BIT(0)
+#define RTL8366S_LAGCR_HASHSEL_MASK		GENMASK(2, 1)
+#define RTL8366S_LAGCR_HASHSEL_DA_SA	\
+	FIELD_PREP(RTL8366S_LAGCR_HASHSEL_MASK, 0)
+#define RTL8366S_LAGCR_HASHSEL_DA	\
+	FIELD_PREP(RTL8366S_LAGCR_HASHSEL_MASK, 1)
+#define RTL8366S_LAGCR_HASHSEL_SA	\
+	FIELD_PREP(RTL8366S_LAGCR_HASHSEL_MASK, 2)
+#define RTL8366S_LAGCR_PORTMAP_MASK		GENMASK(8, 3)
+
+#define RTL8366S_LAG_MAPPING_BASE		0x0381
+#define RTL8366S_LAG_MAPPING_BIT		3
+#define RTL8366S_LAG_MAPPING_MASK		GENMASK(2, 0)
+
+#define RTL8366S_LAG_FC_CTRL_REG		0x0383
+#define RTL8366S_LAG_FC_MASK			GENMASK(5, 0)
+
+#define RTL8366S_LAG_QEMPTY_REG			0x0384
+#define RTL8366S_LAG_QEMPTY_MASK		GENMASK(5, 0)
+
+/* RMA register address */
+#define RTL8366S_RMA_CONTROL_REG		0x0391
+#define RTL8366S_RMA_IGMP			BIT(10)
+#define RTL8366S_RMA_MLD			BIT(11)
+#define RTL8366S_RMA_USER_DEFINED_BASE		0x0392
+
+/* LED control registers */
+#define RTL8366S_LED_BLINKRATE_REG		0x0420
+#define RTL8366S_LED_BLINKRATE_BIT		0
+#define RTL8366S_LED_BLINKRATE_MASK		0x0007
+
+#define RTL8366S_LED_CTRL_REG			0x0421
+#define RTL8366S_LED_0_1_CTRL_REG		0x0422
+#define RTL8366S_LED_2_3_CTRL_REG		0x0423
+
+#define RTL8366S_MIB_COUNT			33
+#define RTL8366S_GLOBAL_MIB_COUNT		1
+#define RTL8366S_MIB_COUNTER_PORT_OFFSET	0x0040
+#define RTL8366S_MIB_COUNTER_BASE		0x1000
+#define RTL8366S_MIB_COUNTER_PORT_OFFSET2	0x0008
+#define RTL8366S_MIB_COUNTER_BASE2		0x1180
+#define RTL8366S_MIB_CTRL_REG			0x11F0
+#define RTL8366S_MIB_CTRL_USER_MASK		0x01FF
+#define RTL8366S_MIB_CTRL_BUSY_MASK		0x0001
+#define RTL8366S_MIB_CTRL_RESET_MASK		0x0002
+
+#define RTL8366S_MIB_CTRL_GLOBAL_RESET_MASK	0x0004
+#define RTL8366S_MIB_CTRL_PORT_RESET_BIT	0x0003
+#define RTL8366S_MIB_CTRL_PORT_RESET_MASK	0x01FC
+
+
+#define RTL8366S_VLAN_MC_BASE(_x)		(0x0016 + (_x) * 2)
+
+#define RTL8366S_MAC_FORCE_CTRL0_REG		0x0F04
+#define RTL8366S_MAC_FORCE_CTRL1_REG		0x0F05
+
+/* PHY registers control */
+#define RTL8366S_PHY_ACCESS_CTRL_REG		0x8028
+#define RTL8366S_PHY_ACCESS_DATA_REG		0x8029
+
+#define RTL8366S_PHY_CTRL_READ			1
+#define RTL8366S_PHY_CTRL_WRITE			0
+
+#define RTL8366S_PORT_NUM_CPU		5
+#define RTL8366S_NUM_PORTS		6
+#define RTL8366S_NUM_VLANS		16
+#define RTL8366S_NUM_LEDGROUPS		4
+#define RTL8366S_NUM_VIDS		4096
+#define RTL8366S_PRIORITYMAX		7
+#define RTL8366S_FIDMAX			7
+
+
+#define RTL8366S_PORT_1			BIT(0) /* In userspace port 0 */
+#define RTL8366S_PORT_2			BIT(1) /* In userspace port 1 */
+#define RTL8366S_PORT_3			BIT(2) /* In userspace port 2 */
+#define RTL8366S_PORT_4			BIT(3) /* In userspace port 3 */
+#define RTL8366S_PORT_5			BIT(4) /* In userspace port 4 */
+#define RTL8366S_PORT_CPU		BIT(5) /* CPU port */
+
+#define RTL8366S_PORT_ALL		(RTL8366S_PORT_1 |	\
+					 RTL8366S_PORT_2 |	\
+					 RTL8366S_PORT_3 |	\
+					 RTL8366S_PORT_4 |	\
+					 RTL8366S_PORT_5 |	\
+					 RTL8366S_PORT_CPU)
+
+#define RTL8366S_PORT_ALL_BUT_CPU	(RTL8366S_PORT_1 |	\
+					 RTL8366S_PORT_2 |	\
+					 RTL8366S_PORT_3 |	\
+					 RTL8366S_PORT_4 |	\
+					 RTL8366S_PORT_5)
+
+#define RTL8366S_PORT_ALL_EXTERNAL	RTL8366S_PORT_ALL_BUT_CPU
+
+#define RTL8366S_PORT_ALL_INTERNAL	RTL8366S_PORT_CPU
+
+#define RTL8366S_VLAN_VID_MASK		0xfff
+#define RTL8366S_VLAN_PRIORITY_SHIFT	12
+#define RTL8366S_VLAN_PRIORITY_MASK	0x7
+#define RTL8366S_VLAN_MEMBER_MASK	0x3f
+#define RTL8366S_VLAN_UNTAG_SHIFT	6
+#define RTL8366S_VLAN_UNTAG_MASK	0x3f
+#define RTL8366S_VLAN_FID_SHIFT		12
+#define RTL8366S_VLAN_FID_MASK		0x7
+
+/* Green Ethernet Feature for PHY ports */
+#define RTL8366S_PHY_POWER_SAVING_CTRL_REG	0x000c
+#define RTL8366S_PHY_POWER_SAVING_MASK		0x1000
+
+#define RTL8366S_PHY_REG_MASK			0x001f
+#define RTL8366S_PHY_PAGE_OFFSET		5
+#define RTL8366S_PHY_PAGE_MASK			GENMASK(7, 5)
+#define RTL8366S_PHY_NO_OFFSET			9
+#define RTL8366S_PHY_NO_MASK			GENMASK(13, 9)
+
+#define RTL8366S_MIB_RXB_ID		0	/* IfInOctets */
+#define RTL8366S_MIB_TXB_ID		20	/* IfOutOctets */
+
+static struct rtl8366_mib_counter rtl8366s_mib_counters[] = {
+	{ 0,  0, 4, "IfInOctets"				},
+	{ 0,  4, 4, "EtherStatsOctets"				},
+	{ 0,  8, 2, "EtherStatsUnderSizePkts"			},
+	{ 0, 10, 2, "EtherFragments"				},
+	{ 0, 12, 2, "EtherStatsPkts64Octets"			},
+	{ 0, 14, 2, "EtherStatsPkts65to127Octets"		},
+	{ 0, 16, 2, "EtherStatsPkts128to255Octets"		},
+	{ 0, 18, 2, "EtherStatsPkts256to511Octets"		},
+	{ 0, 20, 2, "EtherStatsPkts512to1023Octets"		},
+	{ 0, 22, 2, "EtherStatsPkts1024to1518Octets"		},
+	{ 0, 24, 2, "EtherOversizeStats"			},
+	{ 0, 26, 2, "EtherStatsJabbers"				},
+	{ 0, 28, 2, "IfInUcastPkts"				},
+	{ 0, 30, 2, "EtherStatsMulticastPkts"			},
+	{ 0, 32, 2, "EtherStatsBroadcastPkts"			},
+	{ 0, 34, 2, "EtherStatsDropEvents"			},
+	{ 0, 36, 2, "Dot3StatsFCSErrors"			},
+	{ 0, 38, 2, "Dot3StatsSymbolErrors"			},
+	{ 0, 40, 2, "Dot3InPauseFrames"				},
+	{ 0, 42, 2, "Dot3ControlInUnknownOpcodes"		},
+	{ 0, 44, 4, "IfOutOctets"				},
+	{ 0, 48, 2, "Dot3StatsSingleCollisionFrames"		},
+	{ 0, 50, 2, "Dot3StatMultipleCollisionFrames"		},
+	{ 0, 52, 2, "Dot3sDeferredTransmissions"		},
+	{ 0, 54, 2, "Dot3StatsLateCollisions"			},
+	{ 0, 56, 2, "EtherStatsCollisions"			},
+	{ 0, 58, 2, "Dot3StatsExcessiveCollisions"		},
+	{ 0, 60, 2, "Dot3OutPauseFrames"			},
+	{ 0, 62, 2, "Dot1dBasePortDelayExceededDiscards"	},
+
+	/*
+	 * The following counters are accessible at a different
+	 * base address.
+	 */
+	{ 1,  0, 2, "Dot1dTpPortInDiscards"			},
+	{ 1,  2, 2, "IfOutUcastPkts"				},
+	{ 1,  4, 2, "IfOutMulticastPkts"			},
+	{ 1,  6, 2, "IfOutBroadcastPkts"			},
+};
+
+static int rtl8366s_get_mib_counter(struct realtek_smi *smi,
+				    int port,
+				    struct rtl8366_mib_counter *mib,
+				    u64 *mibvalue)
+{
+	u32 addr, val;
+	int ret;
+	int i;
+
+	switch (mib->base) {
+	case 0:
+		addr = RTL8366S_MIB_COUNTER_BASE +
+		       RTL8366S_MIB_COUNTER_PORT_OFFSET * port;
+		break;
+	case 1:
+		addr = RTL8366S_MIB_COUNTER_BASE2 +
+		       RTL8366S_MIB_COUNTER_PORT_OFFSET2 * port;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	addr += mib->offset;
+
+	/*
+	 * Writing access counter address first
+	 * then ASIC will prepare 64bits counter wait for being retrived
+	 */
+	ret = regmap_write(smi->map, addr, 0);
+	if (ret)
+		return ret;
+
+	/* read MIB control register */
+	ret =  regmap_read(smi->map, RTL8366S_MIB_CTRL_REG, &val);
+	if (ret)
+		return -EIO;
+
+	if (val & RTL8366S_MIB_CTRL_BUSY_MASK)
+		return -EBUSY;
+
+	if (val & RTL8366S_MIB_CTRL_RESET_MASK)
+		return -EIO;
+
+	/* Read each individual MIB 16 bits at the time */
+	*mibvalue = 0;
+	for (i = mib->length; i > 0; i--) {
+		ret = regmap_read(smi->map, addr + (i - 1), &val);
+		if (ret)
+			return ret;
+		*mibvalue = (*mibvalue << 16) | (val & 0xFFFF);
+	}
+	return 0;
+}
+
+static int rtl8366s_phy_read(struct realtek_smi *smi, int phy, int regnum)
+{
+	u32 val;
+	u32 reg;
+	int ret;
+
+	if (phy > RTL8366S_PHY_NO_MAX)
+		return -EINVAL;
+
+	ret = regmap_write(smi->map, RTL8366S_PHY_ACCESS_CTRL_REG,
+			   RTL8366S_PHY_CTRL_READ);
+	if (ret)
+		return ret;
+
+	reg = 0x8000 | (1 << (phy + RTL8366S_PHY_NO_OFFSET)) | regnum;
+
+	ret = regmap_write(smi->map, reg, 0);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(smi->map, RTL8366S_PHY_ACCESS_DATA_REG, &val);
+	if (ret)
+		return ret;
+
+	return val;
+}
+
+static int rtl8366s_phy_write(struct realtek_smi *smi, int phy, int regnum,
+			       u16 val)
+{
+	u32 reg;
+	int ret;
+
+	if (phy > RTL8366S_PHY_NO_MAX)
+		return -EINVAL;
+
+	ret = regmap_write(smi->map, RTL8366S_PHY_ACCESS_CTRL_REG,
+			   RTL8366S_PHY_CTRL_WRITE);
+	if (ret)
+		return ret;
+
+	reg = 0x8000 | (1 << (phy + RTL8366S_PHY_NO_OFFSET)) | regnum;
+
+	ret = regmap_write(smi->map, reg, val);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int rtl8366s_reset_chip(struct realtek_smi *smi)
+{
+	int timeout = 10;
+	u32 val;
+	int ret;
+
+	realtek_smi_write_reg_noack(smi, RTL8366S_RESET_CTRL_REG,
+				    RTL8366S_CHIP_CTRL_RESET_HW);
+	do {
+		usleep_range(20000, 25000);
+		ret = regmap_read(smi->map, RTL8366S_RESET_CTRL_REG, &val);
+		if (ret)
+			return ret;
+
+		if (!(val & RTL8366S_CHIP_CTRL_RESET_HW))
+			break;
+	} while (--timeout);
+
+	if (!timeout) {
+		dev_err(smi->dev, "timeout waiting for the switch to reset\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static enum dsa_tag_protocol rtl8366s_get_tag_protocol(struct dsa_switch *ds,
+						       int port,
+						       enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_RTL8366S;
+}
+
+static void
+rtl8366s_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		     phy_interface_t interface, struct phy_device *phydev,
+		     int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
+
+	if (port != RTL8366S_PORT_NUM_CPU)
+		return;
+
+	/* Force the fixed CPU port into 1Gbit mode, no autonegotiation */
+	ret = regmap_update_bits(smi->map, RTL8366S_MAC_FORCE_CTRL1_REG,
+				 BIT(port), BIT(port));
+	if (ret) {
+		dev_err(smi->dev, "failed to force 1Gbit on CPU port\n");
+		return;
+	}
+
+	ret = regmap_update_bits(smi->map, RTL8366S_PAACR2,
+				 0xFF00U,
+				 RTL8366S_PAACR_CPU_PORT << 8);
+	if (ret) {
+		dev_err(smi->dev, "failed to set PAACR on CPU port\n");
+		return;
+	}
+
+	/* Enable the CPU port */
+	ret = regmap_update_bits(smi->map, RTL8366S_PECR, BIT(port),
+				 0);
+	if (ret) {
+		dev_err(smi->dev, "failed to enable the CPU port\n");
+		return;
+	}
+}
+
+static void
+rtl8366s_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+		       phy_interface_t interface)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
+
+	if (port != RTL8366S_PORT_NUM_CPU)
+		return;
+
+	/* Disable the CPU port */
+	ret = regmap_update_bits(smi->map, RTL8366S_PECR, BIT(port),
+				 BIT(port));
+	if (ret) {
+		dev_err(smi->dev, "failed to disable the CPU port\n");
+		return;
+	}
+}
+
+static int rtl8366s_setup(struct dsa_switch *ds)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
+
+	/* Reset chip */
+	ret = rtl8366s_reset_chip(smi);
+	if (ret)
+		return ret;
+
+	/* Set up the "green ethernet" feature */
+	ret = regmap_update_bits(smi->map, RTL8366S_GREEN_ETHERNET_CTRL_REG,
+				 RTL8366S_GREEN_ETHERNET_CTRL_MASK,
+				 RTL8366S_GREEN_ETHERNET_TX |
+				 RTL8366S_GREEN_ETHERNET_RX);
+	if (ret)
+		return ret;
+
+	/* Enable CPU port with custom tag 8899 */
+	ret = regmap_write(smi->map, RTL8366S_CPU_CTRL_REG,
+			   RTL8366S_PORT_CPU);
+	if (ret)
+		return ret;
+
+	/* Make sure we default-enable the fixed CPU port */
+	ret = regmap_update_bits(smi->map, RTL8366S_PECR,
+				 RTL8366S_PORT_CPU, 0);
+	if (ret)
+		return ret;
+
+	/* Enable learning for all ports */
+	ret = regmap_write(smi->map, RTL8366S_SSCR0, 0);
+	if (ret)
+		return ret;
+
+	/* Enable auto ageing for all ports */
+	ret = regmap_write(smi->map, RTL8366S_SSCR1, 0);
+	if (ret)
+		return ret;
+
+	/* Don't drop packets whose DA has not been learned */
+	ret = regmap_update_bits(smi->map, RTL8366S_SSCR2,
+				 RTL8366S_SSCR2_DROP_UNKNOWN_DA, 0);
+	if (ret)
+		return ret;
+
+	/* Connect Port 4 PHY to RGMII
+	 * TODO: Make it configurable in DTS
+	 */
+	ret = regmap_update_bits(smi->map, RTL8366S_PMC0,
+				 RTL8366S_PMC0_P4_IOMODE_MASK,
+				 RTL8366S_PMC0_P4_IOMODE_PHY_TO_RGMII);
+	if (ret)
+		return ret;
+
+	/* Set up port-based VLAN */
+	ret = rtl8366_init_vlan(smi);
+	if (ret)
+		return ret;
+
+	/* Keep original tagged/untagged on egress */
+	ret = regmap_update_bits(smi->map,
+				 RTL8366S_EGRESS_KEEP_FORMAT_REG,
+				 RTL8366S_EGRESS_KEEP_FORMAT_MASK,
+				 RTL8366S_EGRESS_KEEP_FORMAT_ALL);
+	if (ret)
+		return ret;
+
+	/* Enable Link Aggregation "Dump" mode. The switch will
+	 * automatically set hash value mapping to LAG ports.
+	 */
+	ret = regmap_write(smi->map, RTL8366S_LAGCR,
+			   RTL8366S_LAGCR_MODE_DUMP);
+	if (ret)
+		return ret;
+
+	ret = realtek_smi_setup_mdio(smi);
+	if (ret) {
+		dev_info(smi->dev, "could not set up MDIO bus\n");
+		return -ENODEV;
+	}
+
+	ds->mtu_enforcement_ingress = true;
+
+	return 0;
+}
+
+static int rtl8366s_get_vlan_4k(struct realtek_smi *smi, u32 vid,
+				struct rtl8366_vlan_4k *vlan4k)
+{
+	u32 data[2];
+	int ret;
+	int i;
+
+	memset(vlan4k, 0, sizeof(struct rtl8366_vlan_4k));
+
+	if (vid >= RTL8366S_NUM_VIDS)
+		return -EINVAL;
+
+	/* write VID */
+	ret = regmap_write(smi->map, RTL8366S_VLAN_TABLE_WRITE_BASE,
+			   vid & RTL8366S_VLAN_VID_MASK);
+	if (ret)
+		return ret;
+
+	/* write table access control word */
+	ret = regmap_write(smi->map, RTL8366S_TABLE_ACCESS_CTRL_REG,
+			   RTL8366S_TABLE_VLAN_READ_CTRL);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < 2; i++) {
+		ret = regmap_read(smi->map,
+				  RTL8366S_VLAN_TABLE_READ_BASE + i,
+				  &data[i]);
+		if (ret)
+			return ret;
+	}
+
+	vlan4k->vid = vid;
+	vlan4k->untag = (data[1] >> RTL8366S_VLAN_UNTAG_SHIFT) &
+			RTL8366S_VLAN_UNTAG_MASK;
+	vlan4k->member = data[1] & RTL8366S_VLAN_MEMBER_MASK;
+	vlan4k->fid = (data[1] >> RTL8366S_VLAN_FID_SHIFT) &
+			RTL8366S_VLAN_FID_MASK;
+
+	return 0;
+}
+
+static int rtl8366s_set_vlan_4k(struct realtek_smi *smi,
+				const struct rtl8366_vlan_4k *vlan4k)
+{
+	u32 data[2];
+	int ret;
+	int i;
+
+	if (vlan4k->vid >= RTL8366S_NUM_VIDS ||
+	    vlan4k->member > RTL8366S_VLAN_MEMBER_MASK ||
+	    vlan4k->untag > RTL8366S_VLAN_UNTAG_MASK ||
+	    vlan4k->fid > RTL8366S_FIDMAX)
+		return -EINVAL;
+
+	data[0] = vlan4k->vid & RTL8366S_VLAN_VID_MASK;
+	data[1] = (vlan4k->member & RTL8366S_VLAN_MEMBER_MASK) |
+		  ((vlan4k->untag & RTL8366S_VLAN_UNTAG_MASK) <<
+			RTL8366S_VLAN_UNTAG_SHIFT) |
+		  ((vlan4k->fid & RTL8366S_VLAN_FID_MASK) <<
+			RTL8366S_VLAN_FID_SHIFT);
+
+	for (i = 0; i < 2; i++) {
+		ret = regmap_write(smi->map,
+					    RTL8366S_VLAN_TABLE_WRITE_BASE + i,
+					    data[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* write table access control word */
+	ret = regmap_write(smi->map, RTL8366S_TABLE_ACCESS_CTRL_REG,
+				    RTL8366S_TABLE_VLAN_WRITE_CTRL);
+
+	return ret;
+}
+
+static int rtl8366s_get_vlan_mc(struct realtek_smi *smi, u32 index,
+				struct rtl8366_vlan_mc *vlanmc)
+{
+	u32 data[2];
+	int ret;
+	int i;
+
+	memset(vlanmc, 0, sizeof(struct rtl8366_vlan_mc));
+
+	if (index >= RTL8366S_NUM_VLANS)
+		return -EINVAL;
+
+	for (i = 0; i < 2; i++) {
+		ret = regmap_read(smi->map,
+				  RTL8366S_VLAN_MC_BASE(index) + i,
+				  &data[i]);
+		if (ret)
+			return ret;
+	}
+
+	vlanmc->vid = data[0] & RTL8366S_VLAN_VID_MASK;
+	vlanmc->priority = (data[0] >> RTL8366S_VLAN_PRIORITY_SHIFT) &
+			   RTL8366S_VLAN_PRIORITY_MASK;
+	vlanmc->untag = (data[1] >> RTL8366S_VLAN_UNTAG_SHIFT) &
+			RTL8366S_VLAN_UNTAG_MASK;
+	vlanmc->member = data[1] & RTL8366S_VLAN_MEMBER_MASK;
+	vlanmc->fid = (data[1] >> RTL8366S_VLAN_FID_SHIFT) &
+		      RTL8366S_VLAN_FID_MASK;
+
+	return 0;
+}
+
+static int rtl8366s_set_vlan_mc(struct realtek_smi *smi, u32 index,
+				const struct rtl8366_vlan_mc *vlanmc)
+{
+	u32 data[2];
+	int ret;
+	int i;
+
+	if (index >= RTL8366S_NUM_VLANS ||
+	    vlanmc->vid >= RTL8366S_NUM_VIDS ||
+	    vlanmc->priority > RTL8366S_PRIORITYMAX ||
+	    vlanmc->member > RTL8366S_VLAN_MEMBER_MASK ||
+	    vlanmc->untag > RTL8366S_VLAN_UNTAG_MASK ||
+	    vlanmc->fid > RTL8366S_FIDMAX)
+		return -EINVAL;
+
+	data[0] = (vlanmc->vid & RTL8366S_VLAN_VID_MASK) |
+		  ((vlanmc->priority & RTL8366S_VLAN_PRIORITY_MASK) <<
+			RTL8366S_VLAN_PRIORITY_SHIFT);
+	data[1] = (vlanmc->member & RTL8366S_VLAN_MEMBER_MASK) |
+		  ((vlanmc->untag & RTL8366S_VLAN_UNTAG_MASK) <<
+			RTL8366S_VLAN_UNTAG_SHIFT) |
+		  ((vlanmc->fid & RTL8366S_VLAN_FID_MASK) <<
+			RTL8366S_VLAN_FID_SHIFT);
+
+	for (i = 0; i < 2; i++) {
+		ret = regmap_write(smi->map,
+				   RTL8366S_VLAN_MC_BASE(index) + i,
+				   data[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int rtl8366s_get_mc_index(struct realtek_smi *smi, int port, int *val)
+{
+	u32 data;
+	int ret;
+
+	if (port >= RTL8366S_NUM_PORTS)
+		return -EINVAL;
+
+	ret = regmap_read(smi->map, RTL8366S_PORT_VLAN_CTRL_REG(port),
+				   &data);
+	if (ret)
+		return ret;
+
+	*val = (data >> RTL8366S_PORT_VLAN_CTRL_SHIFT(port)) &
+	       RTL8366S_PORT_VLAN_CTRL_MASK;
+
+	return 0;
+}
+
+static int rtl8366s_set_mc_index(struct realtek_smi *smi, int port, int index)
+{
+	if (port >= RTL8366S_NUM_PORTS || index >= RTL8366S_NUM_VLANS)
+		return -EINVAL;
+
+	return regmap_update_bits(smi->map, RTL8366S_PORT_VLAN_CTRL_REG(port),
+				RTL8366S_PORT_VLAN_CTRL_MASK <<
+					RTL8366S_PORT_VLAN_CTRL_SHIFT(port),
+				(index & RTL8366S_PORT_VLAN_CTRL_MASK) <<
+					RTL8366S_PORT_VLAN_CTRL_SHIFT(port));
+}
+
+static int rtl8366s_enable_vlan(struct realtek_smi *smi, bool enable)
+{
+	return regmap_update_bits(smi->map, RTL8366S_SGCR, RTL8366S_SGCR_EN_VLAN,
+				  enable ? RTL8366S_SGCR_EN_VLAN : 0);
+}
+
+static int rtl8366s_enable_vlan4k(struct realtek_smi *smi, bool enable)
+{
+	return regmap_update_bits(smi->map, RTL8366S_VLAN_TB_CTRL_REG,
+				  1, enable);
+}
+
+static bool rtl8366s_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
+{
+	unsigned int max = RTL8366S_NUM_VLANS;
+
+	if (smi->vlan4k_enabled)
+		max = RTL8366S_NUM_VIDS - 1;
+
+	return vlan && vlan < max;
+}
+
+static int
+rtl8366s_port_enable(struct dsa_switch *ds, int port,
+		     struct phy_device *phy)
+{
+	struct realtek_smi *smi = ds->priv;
+
+	return regmap_update_bits(smi->map, RTL8366S_PECR, BIT(port), 0);
+}
+
+static void
+rtl8366s_port_disable(struct dsa_switch *ds, int port)
+{
+	struct realtek_smi *smi = ds->priv;
+
+	regmap_update_bits(smi->map, RTL8366S_PECR, BIT(port), BIT(port));
+}
+
+static int
+rtl8366s_port_bridge_join(struct dsa_switch *ds, int port,
+			  struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_mask = 0;
+	int i;
+
+	for (i = 0; i < RTL8366S_NUM_PORTS; i++) {
+		unsigned int mask;
+		int ret;
+
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+
+		/* Add this port to the portvlan mask of the other ports
+		 * in the bridge
+		 */
+		mask = BIT(port);
+		mask |= mask << RTL8366S_VLAN_UNTAG_SHIFT;
+		ret = regmap_update_bits(smi->map,
+					 RTL8366S_VLAN_MC_BASE(i) + 1,
+					 mask, mask);
+		if (ret)
+			return ret;
+
+		port_mask |= BIT(i);
+	}
+
+	/* Add all other ports to this ports portvlan mask */
+	port_mask |= port_mask << RTL8366S_VLAN_UNTAG_SHIFT;
+	return regmap_update_bits(smi->map, RTL8366S_VLAN_MC_BASE(port) + 1,
+				  port_mask, port_mask);
+}
+
+static void
+rtl8366s_port_bridge_leave(struct dsa_switch *ds, int port,
+			   struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_mask;
+	int i;
+
+	for (i = 0; i < RTL8366S_NUM_PORTS; i++) {
+		unsigned int mask;
+
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+
+		/* Remove this port from the portvlan mask of the other
+		 * ports in the bridge
+		 */
+		mask = BIT(port);
+		mask |= mask << RTL8366S_VLAN_UNTAG_SHIFT;
+		regmap_update_bits(smi->map,
+				   RTL8366S_VLAN_MC_BASE(i) + 1,
+				   mask, 0);
+	}
+
+	/* Set the cpu port to be the only one else in the portvlan mask
+	 * of this port
+	 */
+	port_mask = BIT(port) | BIT(RTL8366S_PORT_NUM_CPU);
+	port_mask |= port_mask << RTL8366S_VLAN_UNTAG_SHIFT;
+	regmap_write(smi->map, RTL8366S_VLAN_MC_BASE(port) + 1,
+		     port_mask);
+}
+
+static void
+rtl8366s_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct realtek_smi *smi = ds->priv;
+	enum RTL8366S_STP_STATE val;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		val = RTL8366S_STP_DISABLED;
+		break;
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		val = RTL8366S_STP_BLOCKING;
+		break;
+	case BR_STATE_LEARNING:
+		val = RTL8366S_STP_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+	default:
+		val = RTL8366S_STP_FORWARDING;
+		break;
+	}
+
+	/* The HW supports 8 MSTIs but we only use 0 */
+	regmap_update_bits(smi->map, RTL8366S_STP_REG(port),
+			   RTL8366S_STP_MASK, val);
+}
+
+static int rtl8366s_port_vlan_filtering(struct dsa_switch *ds, int port,
+					bool vlan_filtering)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int val;
+	int ret;
+
+	/* Enable/Disable VLAN ingress filtering */
+	val = BIT(port);
+	ret = regmap_update_bits(smi->map, RTL8366S_VLAN_MEMBERINGRESS_REG,
+				 val, vlan_filtering ? val : 0);
+	if (ret)
+		return ret;
+
+	/* Disable/Enable keep original tagged/untagged */
+	val = FIELD_PREP(RTL8366S_EGRESS_KEEP_FORMAT_MASK, val);
+	ret = regmap_update_bits(smi->map, RTL8366S_EGRESS_KEEP_FORMAT_REG,
+				 val, vlan_filtering ? 0 : val);
+	if (ret)
+		return ret;
+
+	return rtl8366_vlan_filtering(ds, port, vlan_filtering);
+}
+
+static int rtl8366s_port_mirror_add(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror,
+				    bool ingress)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int val, dir;
+	int ret;
+
+	/* The source and the monitor port cannot be the same */
+	if (port == mirror->to_local_port)
+		return -EOPNOTSUPP;
+
+	ret = regmap_read(smi->map, RTL8366S_PMCR, &val);
+	if (ret)
+		return ret;
+
+	dir = ingress ? RTL8366S_PMCR_MIRROR_RX : RTL8366S_PMCR_MIRROR_TX;
+	/* RTL8366S only supports one port mirror set */
+	if (val & dir)
+	    return -EEXIST;
+
+	/* If the other direction is active, allow setting up both
+	 * directions for the same source and monitor ports
+	 */
+	if (val & (RTL8366S_PMCR_MIRROR_RX | RTL8366S_PMCR_MIRROR_TX)) {
+		int source, monitor;
+
+		source = FIELD_GET(RTL8366S_PMCR_SOURCE_MASK, val);
+		monitor = FIELD_GET(RTL8366S_PMCR_MINITOR_MASK, val);
+
+		if (source != port || monitor != mirror->to_local_port)
+			return -EEXIST;
+	} else {
+		val &= ~RTL8366S_PMCR_SOURCE_MASK;
+		val |= FIELD_PREP(RTL8366S_PMCR_SOURCE_MASK, port);
+		val &= ~RTL8366S_PMCR_MINITOR_MASK;
+		val |= FIELD_PREP(RTL8366S_PMCR_MINITOR_MASK,
+		       mirror->to_local_port);
+	}
+
+	val |= dir;
+
+	return regmap_write(smi->map, RTL8366S_PMCR, val);
+}
+
+static void rtl8366s_port_mirror_del(struct dsa_switch *ds, int port,
+				     struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int dir;
+
+	dir = mirror->ingress ? RTL8366S_PMCR_MIRROR_RX : RTL8366S_PMCR_MIRROR_TX;
+	regmap_update_bits(smi->map, RTL8366S_PMCR, dir, 0);
+}
+
+static int rtl8366s_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct realtek_smi *smi = ds->priv;
+	u32 len;
+
+	/* When a new MTU is set, DSA always set the CPU port's MTU to the
+	 * largest MTU of the slave ports. Because the switch only has a global
+	 * max length register, only allowing CPU port here is enough.
+	 */
+	if (port != RTL8366S_PORT_NUM_CPU)
+		return 0;
+
+	/* Includes Ethernet header and FCS length.
+	 *
+	 * Note that the CPU tag does not count towards its length, the
+	 * same reason why the frame must be padded _before_ inserting
+	 * the CPU tag on xmit.
+	 */
+	new_mtu += ETH_HLEN + ETH_FCS_LEN;
+	if (new_mtu <= 1522)
+		len = RTL8366S_SGCR_MAX_LENGTH_1522;
+	else if (new_mtu <= 1536)
+		len = RTL8366S_SGCR_MAX_LENGTH_1536;
+	else if (new_mtu <= 1552)
+		len = RTL8366S_SGCR_MAX_LENGTH_1552;
+	else
+		len = RTL8366S_SGCR_MAX_LENGTH_16000;
+
+	return regmap_update_bits(smi->map, RTL8366S_SGCR,
+				  RTL8366S_SGCR_MAX_LENGTH_MASK,
+				  len);
+}
+
+static int rtl8366s_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return 16000 - ETH_HLEN - ETH_FCS_LEN;
+}
+
+static int rtl8366s_port_lag_change(struct dsa_switch *ds, int port)
+{
+	const struct dsa_port *dp = dsa_to_port(ds, port);
+	struct realtek_smi *smi = ds->priv;
+	unsigned int val;
+
+	val = FIELD_PREP(RTL8366S_LAGCR_PORTMAP_MASK, BIT(port));
+
+	return regmap_update_bits(smi->map, RTL8366S_LAGCR, val,
+				  dp->lag_tx_enabled ? val : 0);
+}
+
+static int rtl8366s_port_lag_join(struct dsa_switch *ds, int port,
+				  struct net_device *lag,
+				  struct netdev_lag_upper_info *info)
+{
+	struct realtek_smi *smi = ds->priv;
+	const struct dsa_port *dp;
+	unsigned int val;
+	int count = 0;
+
+	/* Only supports hash type */
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(dp, dp->dst->ports, list) {
+		if (dp->lag_dev == lag)
+			count++;
+		/* Only supports 1 LAG set */
+		else if (dp->lag_dev)
+			return -EBUSY;
+	}
+
+	/* Only supports maximum LAG member of 4 */
+	if (count >= 4)
+		return -ENOSPC;
+
+	val = FIELD_PREP(RTL8366S_LAGCR_PORTMAP_MASK, BIT(port));
+
+	return regmap_update_bits(smi->map, RTL8366S_LAGCR, val, val);
+}
+
+static int rtl8366s_port_lag_leave(struct dsa_switch *ds, int port,
+				   struct net_device *lag)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int val;
+
+	val = FIELD_PREP(RTL8366S_LAGCR_PORTMAP_MASK, BIT(port));
+
+	return regmap_update_bits(smi->map, RTL8366S_LAGCR, val, 0);
+}
+
+static int rtl8366s_detect(struct realtek_smi *smi)
+{
+	struct device *dev = smi->dev;
+	unsigned int chip_ver;
+	unsigned int chip_id;
+	int ret;
+
+	ret = regmap_read(smi->map, RTL8366S_CHIP_ID_REG, &chip_id);
+	if (ret) {
+		dev_err(dev, "unable to read chip id (%d)\n", ret);
+		return ret;
+	}
+
+	switch (chip_id) {
+	case RTL8366S_CHIP_ID_8366:
+		break;
+	default:
+		dev_err(dev, "unknown chip id (%04x)\n", chip_id);
+		return -ENODEV;
+	}
+
+	ret = regmap_read(smi->map, RTL8366S_CHIP_VERSION_CTRL_REG,
+			  &chip_ver);
+	if (ret) {
+		dev_err(dev, "unable to read chip version (%d)\n", ret);
+		return ret;
+	}
+
+	chip_ver &= RTL8366S_CHIP_VERSION_MASK;
+	dev_info(dev, "RTL%04x ver. %u chip found\n", chip_id, chip_ver);
+
+	smi->cpu_port = RTL8366S_PORT_NUM_CPU;
+	smi->num_ports = RTL8366S_NUM_PORTS;
+	smi->num_vlan_mc = RTL8366S_NUM_VLANS;
+	smi->mib_counters = rtl8366s_mib_counters;
+	smi->num_mib_counters = ARRAY_SIZE(rtl8366s_mib_counters);
+
+	return 0;
+}
+
+static const struct dsa_switch_ops rtl8366s_switch_ops = {
+	.get_tag_protocol = rtl8366s_get_tag_protocol,
+	.setup = rtl8366s_setup,
+	.phylink_mac_link_down = rtl8366s_mac_link_down,
+	.phylink_mac_link_up = rtl8366s_mac_link_up,
+	.get_strings = rtl8366_get_strings,
+	.get_ethtool_stats = rtl8366_get_ethtool_stats,
+	.get_sset_count = rtl8366_get_sset_count,
+	.port_enable = rtl8366s_port_enable,
+	.port_disable = rtl8366s_port_disable,
+	.port_bridge_join = rtl8366s_port_bridge_join,
+	.port_bridge_leave = rtl8366s_port_bridge_leave,
+	.port_stp_state_set = rtl8366s_port_stp_state_set,
+	.port_vlan_filtering = rtl8366s_port_vlan_filtering,
+	.port_vlan_add = rtl8366_vlan_add,
+	.port_vlan_del = rtl8366_vlan_del,
+	.port_mirror_add = rtl8366s_port_mirror_add,
+	.port_mirror_del = rtl8366s_port_mirror_del,
+	.port_change_mtu = rtl8366s_port_change_mtu,
+	.port_max_mtu = rtl8366s_port_max_mtu,
+	.port_lag_change = rtl8366s_port_lag_change,
+	.port_lag_join = rtl8366s_port_lag_join,
+	.port_lag_leave = rtl8366s_port_lag_leave,
+};
+
+static const struct realtek_smi_ops rtl8366s_smi_ops = {
+	.detect		= rtl8366s_detect,
+	.get_mib_counter = rtl8366s_get_mib_counter,
+	.get_vlan_mc	= rtl8366s_get_vlan_mc,
+	.set_vlan_mc	= rtl8366s_set_vlan_mc,
+	.get_vlan_4k	= rtl8366s_get_vlan_4k,
+	.set_vlan_4k	= rtl8366s_set_vlan_4k,
+	.get_mc_index	= rtl8366s_get_mc_index,
+	.set_mc_index	= rtl8366s_set_mc_index,
+	.is_vlan_valid	= rtl8366s_is_vlan_valid,
+	.enable_vlan	= rtl8366s_enable_vlan,
+	.enable_vlan4k	= rtl8366s_enable_vlan4k,
+	.phy_read	= rtl8366s_phy_read,
+	.phy_write	= rtl8366s_phy_write,
+};
+
+static const struct realtek_smi_variant rtl8366s_variant = {
+	.ds_ops = &rtl8366s_switch_ops,
+	.ops = &rtl8366s_smi_ops,
+	.clk_delay = 10,
+	.cmd_read = 0xa9,
+	.cmd_write = 0xa8,
+};
+EXPORT_SYMBOL_GPL(rtl8366s_variant);
-- 
2.25.1

