Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AC7306DDE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhA1GrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:47:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10106 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhA1GqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:46:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816373; x=1643352373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BKzC+n/i9bsNW7jW/bhc7j7ObDFEQYi60fijuAISd84=;
  b=ZZuFimR7xVBUnGXc5KBOa7zM94oQUhoBEGX+N1+NzP4BDNyf8AaFsrtJ
   X0FmGpL+BBJb4fNd2YX34oPqTvKQ/HOF+kToS2EazLNXFZFBAhzSVRtza
   OYKfHE/dYNI4/q18hgq4rAy8H32up7g4rV/BNETLh/56Eb7kojew8M9ID
   3NqzFFmbsgHc06FHJPvHZsKyr8iGRJQZYiyBU6YeB7MJCgQSrFluxcX3T
   eftc6kIIx8gVlP2bY0nZ0FP4m04eRTV+qpDEtDw9bLp25jT6g9B1n9xPE
   fFwX5DgB3KioOOTBvBVxcsdfl24xdcfs3p1X3iB7cNDv/nQUbYwZDldVh
   w==;
IronPort-SDR: tgBvDswc6HpZATPFtabZ3/2YrwbnH8H3dHotUBTIATgUsFs0UsUcSTeISxKVrkrkIT4+AD0QXz
 CjoB4CskDXhvQ9mUKMGEHxKk82nQPQUZnFn7Phrz6fERzTji49GE6D8z34EWTOUs24pMbMqNKh
 Cxr5ZalPuykVzB3+f6b4ZcXwZ9fLLE8sDwcuw4uOrFcleeAZMMl/CG7cbg4IJSI4BdLan7IyNb
 iEnEFZgSO3visB82P2K3szegUaMrFVQfyI29Kxw4ufaxn10FQWMAKCKPUVIDenvL/dKw/qmX+8
 Je4=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="107076573"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:24 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:19 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 3/8] net: dsa: microchip: add DSA support for microchip lan937x
Date:   Thu, 28 Jan 2021 12:11:07 +0530
Message-ID: <20210128064112.372883-4-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basic DSA driver support for lan937x and the device will be
configured through SPI interface.

drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
the new files come under this path. Hence no update needed to the
MAINTAINERS

Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
added support for port_stp_state_set() & port_fast_age().

lan937x_flush_dyn_mac_table() which gets called from
port_fast_age() of KSZ common layer, hence added support for it.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig        |  12 +
 drivers/net/dsa/microchip/Makefile       |   5 +
 drivers/net/dsa/microchip/ksz_common.h   |   1 +
 drivers/net/dsa/microchip/lan937x_dev.c  | 859 ++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |  79 ++
 drivers/net/dsa/microchip/lan937x_main.c | 352 +++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  | 955 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_spi.c  | 104 +++
 8 files changed, 2367 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 4ec6a47b7f72..ae2484e3759b 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -3,6 +3,18 @@ config NET_DSA_MICROCHIP_KSZ_COMMON
 	select NET_DSA_TAG_KSZ
 	tristate
 
+config NET_DSA_MICROCHIP_LAN937X
+	tristate "Microchip LAN937X series SPI connected switch support"
+	depends on NET_DSA && SPI
+	select NET_DSA_MICROCHIP_KSZ_COMMON
+	select REGMAP_SPI
+	help
+	  This driver adds support for Microchip LAN937X series
+	  switch chips.
+
+	  Select to enable support for registering switches configured
+	  through SPI.
+
 menuconfig NET_DSA_MICROCHIP_KSZ9477
 	tristate "Microchip KSZ9477 series switch support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 929caa81e782..13f38efdadf0 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -5,3 +5,8 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
+
+obj-$(CONFIG_NET_DSA_MICROCHIP_LAN937X)		+= lan937x.o
+lan937x-objs := lan937x_dev.o
+lan937x-objs += lan937x_main.o
+lan937x-objs += lan937x_spi.o
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f212775372ce..7cc14b72ad39 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -144,6 +144,7 @@ void ksz_switch_remove(struct ksz_device *dev);
 
 int ksz8795_switch_register(struct ksz_device *dev);
 int ksz9477_switch_register(struct ksz_device *dev);
+int lan937x_switch_register(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
new file mode 100644
index 000000000000..84540180ff2f
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -0,0 +1,859 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip lan937x dev ops functions
+ * Copyright (C) 2019-2020 Microchip Technology Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/iopoll.h>
+#include <linux/platform_data/microchip-ksz.h>
+#include <linux/phy.h>
+#include <linux/if_bridge.h>
+#include <net/dsa.h>
+#include <net/switchdev.h>
+
+#include "lan937x_reg.h"
+#include "ksz_common.h"
+#include "lan937x_dev.h"
+
+const struct mib_names lan937x_mib_names[] = {
+	{ 0x00, "rx_hi" },
+	{ 0x01, "rx_undersize" },
+	{ 0x02, "rx_fragments" },
+	{ 0x03, "rx_oversize" },
+	{ 0x04, "rx_jabbers" },
+	{ 0x05, "rx_symbol_err" },
+	{ 0x06, "rx_crc_err" },
+	{ 0x07, "rx_align_err" },
+	{ 0x08, "rx_mac_ctrl" },
+	{ 0x09, "rx_pause" },
+	{ 0x0A, "rx_bcast" },
+	{ 0x0B, "rx_mcast" },
+	{ 0x0C, "rx_ucast" },
+	{ 0x0D, "rx_64_or_less" },
+	{ 0x0E, "rx_65_127" },
+	{ 0x0F, "rx_128_255" },
+	{ 0x10, "rx_256_511" },
+	{ 0x11, "rx_512_1023" },
+	{ 0x12, "rx_1024_1522" },
+	{ 0x13, "rx_1523_2000" },
+	{ 0x14, "rx_2001" },
+	{ 0x15, "tx_hi" },
+	{ 0x16, "tx_late_col" },
+	{ 0x17, "tx_pause" },
+	{ 0x18, "tx_bcast" },
+	{ 0x19, "tx_mcast" },
+	{ 0x1A, "tx_ucast" },
+	{ 0x1B, "tx_deferred" },
+	{ 0x1C, "tx_total_col" },
+	{ 0x1D, "tx_exc_col" },
+	{ 0x1E, "tx_single_col" },
+	{ 0x1F, "tx_mult_col" },
+	{ 0x80, "rx_total" },
+	{ 0x81, "tx_total" },
+	{ 0x82, "rx_discards" },
+	{ 0x83, "tx_discards" },
+};
+
+static const struct lan937x_chip_data lan937x_switch_chips[] = {
+	{
+		.chip_id = 0x00937000,
+		.dev_name = "LAN9370",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x10,
+		/* total port count */
+		.port_cnt = 5,
+	},
+	{
+		.chip_id = 0x00937100,
+		.dev_name = "LAN9371",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x30,
+		/* total port count */
+		.port_cnt = 6,
+	},
+	{
+		.chip_id = 0x00937200,
+		.dev_name = "LAN9372",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x30,
+		/* total port count */
+		.port_cnt = 8,
+	},
+	{
+		.chip_id = 0x00937300,
+		.dev_name = "LAN9373",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x38,
+		/* total port count */
+		.port_cnt = 5,
+	},
+	{
+		.chip_id = 0x00937400,
+		.dev_name = "LAN9374",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		/* can be configured as cpu port */
+		.cpu_ports = 0x30,
+		/* total port count */
+		.port_cnt = 8,
+	},
+
+};
+
+void lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+}
+
+void lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
+		      u8 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+			   bits, set ? bits : 0);
+}
+
+void lan937x_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[2], addr, bits, set ? bits : 0);
+}
+
+void lan937x_pread8(struct ksz_device *dev, int port, int offset,
+		    u8 *data)
+{
+	ksz_read8(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_pread16(struct ksz_device *dev, int port, int offset,
+		     u16 *data)
+{
+	ksz_read16(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_pread32(struct ksz_device *dev, int port, int offset,
+		     u32 *data)
+{
+	ksz_read32(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_pwrite8(struct ksz_device *dev, int port,
+		     int offset, u8 data)
+{
+	ksz_write8(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_pwrite16(struct ksz_device *dev, int port,
+		      int offset, u16 data)
+{
+	ksz_write16(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_pwrite32(struct ksz_device *dev, int port,
+		      int offset, u32 data)
+{
+	ksz_write32(dev, PORT_CTRL_ADDR(port, offset), data);
+}
+
+void lan937x_port_cfg32(struct ksz_device *dev, int port, int offset,
+			u32 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[2], PORT_CTRL_ADDR(port, offset),
+			   bits, set ? bits : 0);
+}
+
+void lan937x_cfg_port_member(struct ksz_device *dev, int port,
+			     u8 member)
+{
+	lan937x_pwrite32(dev, port, REG_PORT_VLAN_MEMBERSHIP__4, member);
+
+	dev->ports[port].member = member;
+}
+
+static void lan937x_flush_dyn_mac_table(struct ksz_device *dev, int port)
+{
+	unsigned int value;
+	u8 data;
+
+	regmap_update_bits(dev->regmap[0], REG_SW_LUE_CTRL_2,
+			   SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S,
+			   SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
+
+	if (port < dev->port_cnt) {
+		/* flush individual port */
+		lan937x_pread8(dev, port, P_STP_CTRL, &data);
+		if (!(data & PORT_LEARN_DISABLE))
+			lan937x_pwrite8(dev, port, P_STP_CTRL,
+					data | PORT_LEARN_DISABLE);
+		lan937x_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_DYN_MAC_TABLE, true);
+
+		regmap_read_poll_timeout(dev->regmap[0],
+					 S_FLUSH_TABLE_CTRL,
+				value, !(value & SW_FLUSH_DYN_MAC_TABLE), 10, 1000);
+
+		lan937x_pwrite8(dev, port, P_STP_CTRL, data);
+	} else {
+		/* flush all */
+		lan937x_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_STP_TABLE, true);
+	}
+}
+
+static void lan937x_port_init_cnt(struct ksz_device *dev, int port)
+{
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+
+	/* flush all enabled port MIB counters */
+	mutex_lock(&mib->cnt_mutex);
+	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4,
+			 MIB_COUNTER_FLUSH_FREEZE);
+	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
+	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
+	mutex_unlock(&mib->cnt_mutex);
+
+	mib->cnt_ptr = 0;
+	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+}
+
+int lan937x_reset_switch(struct ksz_device *dev)
+{
+	u32 data32;
+	u8 data8;
+
+	/* reset switch */
+	lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
+
+	/* default configuration */
+	ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
+	data8 = SW_AGING_ENABLE | SW_LINK_AUTO_AGING |
+	      SW_SRC_ADDR_FILTER;
+	ksz_write8(dev, REG_SW_LUE_CTRL_1, data8);
+
+	/* disable interrupts */
+	ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
+	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
+	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
+
+	/* set broadcast storm protection 10% rate */
+	regmap_update_bits(dev->regmap[1], REG_SW_MAC_CTRL_2,
+			   BROADCAST_STORM_RATE,
+			   (BROADCAST_STORM_VALUE *
+			   BROADCAST_STORM_PROT_RATE) / 100);
+
+	return 0;
+}
+
+static int lan937x_switch_detect(struct ksz_device *dev)
+{
+	u32 id32;
+	int ret;
+
+	/* Read Chip ID */
+	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
+
+	if (ret)
+		return ret;
+
+	if (id32 != 0) {
+		dev->chip_id = id32;
+		dev_info(dev->dev, "Chip ID: 0x%x", id32);
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static void lan937x_switch_exit(struct ksz_device *dev)
+{
+	lan937x_reset_switch(dev);
+}
+
+void lan937x_enable_spi_indirect_access(struct ksz_device *dev)
+{
+	u16 data16;
+	u8 data8;
+
+	ksz_read8(dev, REG_GLOBAL_CTRL_0, &data8);
+
+	/* Check if PHY register is blocked */
+	if (data8 & SW_PHY_REG_BLOCK) {
+		/* Enable Phy access through SPI*/
+		data8 &= ~SW_PHY_REG_BLOCK;
+		ksz_write8(dev, REG_GLOBAL_CTRL_0, data8);
+	}
+
+	ksz_read16(dev, REG_VPHY_SPECIAL_CTRL__2, &data16);
+
+	/* If already the access is not enabled go ahead and allow SPI access */
+	if (!(data16 & VPHY_SPI_INDIRECT_ENABLE)) {
+		data16 |= VPHY_SPI_INDIRECT_ENABLE;
+		ksz_write16(dev, REG_VPHY_SPECIAL_CTRL__2, data16);
+	}
+}
+
+bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is RGMII */
+	if (port == LAN937X_RGMII_1_PORT || port == LAN937X_RGMII_2_PORT)
+		return false;
+
+	/* Check if the port is SGMII */
+	if (port == LAN937X_SGMII_PORT &&
+	    GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_73)
+		return false;
+
+	return true;
+}
+
+static u32 lan937x_get_port_addr(int port, int offset)
+{
+	return PORT_CTRL_ADDR(port, offset);
+}
+
+bool lan937x_is_internal_tx_phy_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is internal tx phy port */
+	if (lan937x_is_internal_phy_port(dev, port) && port == LAN937X_TXPHY_PORT)
+		if ((GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_71) ||
+		    (GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_72))
+			return true;
+
+	return false;
+}
+
+bool lan937x_is_internal_t1_phy_port(struct ksz_device *dev, int port)
+{
+	/* Check if the port is internal t1 phy port */
+	if (lan937x_is_internal_phy_port(dev, port) &&
+	    !lan937x_is_internal_tx_phy_port(dev, port))
+		return true;
+
+	return false;
+}
+
+int lan937x_t1_tx_phy_write(struct ksz_device *dev, int addr,
+			    int reg, u16 val)
+{
+	u16 temp, addr_base;
+	unsigned int value;
+	int ret;
+
+	/* Check for internal phy port */
+	if (!lan937x_is_internal_phy_port(dev, addr))
+		return 0;
+
+	if (lan937x_is_internal_tx_phy_port(dev, addr))
+		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
+	else
+		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
+
+	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
+
+	ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
+
+	/* Write the data to be written to the VPHY reg */
+	ksz_write16(dev, REG_VPHY_IND_DATA__2, val);
+
+	/* Write the Write En and Busy bit */
+	ksz_write16(dev, REG_VPHY_IND_CTRL__2, (VPHY_IND_WRITE
+				| VPHY_IND_BUSY));
+
+	ret = regmap_read_poll_timeout(dev->regmap[1],
+				       REG_VPHY_IND_CTRL__2,
+				value, !(value & VPHY_IND_BUSY), 10, 1000);
+
+	/* failed to write phy register. get out of loop */
+	if (ret) {
+		dev_err(dev->dev, "Failed to write phy register\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+int lan937x_t1_tx_phy_read(struct ksz_device *dev, int addr,
+			   int reg, u16 *val)
+{
+	u16 temp, addr_base;
+	unsigned int value;
+	int ret;
+
+	if (lan937x_is_internal_phy_port(dev, addr)) {
+		if (lan937x_is_internal_tx_phy_port(dev, addr))
+			addr_base = REG_PORT_TX_PHY_CTRL_BASE;
+		else
+			addr_base = REG_PORT_T1_PHY_CTRL_BASE;
+
+		/* get register address based on the logical port */
+		temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
+
+		ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
+		/* Write Read and Busy bit to start the transaction*/
+		ksz_write16(dev, REG_VPHY_IND_CTRL__2, VPHY_IND_BUSY);
+
+		ret = regmap_read_poll_timeout(dev->regmap[1],
+					       REG_VPHY_IND_CTRL__2,
+					value, !(value & VPHY_IND_BUSY), 10, 1000);
+
+		/*  failed to read phy register. get out of loop */
+		if (ret) {
+			dev_err(dev->dev, "Failed to read phy register\n");
+			return ret;
+		}
+		/* Read the VPHY register which has the PHY data*/
+		ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
+	}
+
+	return 0;
+}
+
+static void lan937x_t1_tx_phy_mod_bits(struct ksz_device *dev, int port,
+				       int reg, u16 val, bool set)
+{
+	u16 data;
+
+	/* read phy register */
+	lan937x_t1_tx_phy_read(dev, port, reg, &data);
+
+	/* set/clear the data */
+	if (set)
+		data |= val;
+	else
+		data &= ~val;
+
+	/* write phy register */
+	lan937x_t1_tx_phy_write(dev, port, reg, data);
+}
+
+static u32 lan937x_tx_phy_bank_read(struct ksz_device *dev, int port,
+				    u8 bank, u8 reg)
+{
+	u16 data_hi;
+	u16 data_lo;
+	u16 ctrl;
+
+	ctrl = ((u16)bank & TX_REG_BANK_SEL_M) << TX_REG_BANK_SEL_S;
+	ctrl |= ((u16)reg & TX_READ_ADDR_M) << TX_READ_ADDR_S;
+
+	/* write ctrl register with appropriate value */
+	ctrl |= TX_IND_DATA_READ;
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, ctrl);
+
+	/* if bank is WOL value to be written again to reflect correct bank */
+	if (bank == TX_REG_BANK_SEL_WOL)
+		lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, ctrl);
+
+	/* read data hi & low value */
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_TX_READ_DATA_LO, &data_lo);
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_TX_READ_DATA_HI, &data_hi);
+
+	return ((u32)data_hi << 16) | data_lo;
+}
+
+static void lan937x_tx_phy_bank_write(struct ksz_device *dev, int port,
+				      u8 bank, u8 reg, u16 val)
+{
+	u16 ctrl;
+
+	/* write the value */
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_WRITE_DATA, val);
+	ctrl = ((u16)bank & TX_REG_BANK_SEL_M) << TX_REG_BANK_SEL_S;
+	ctrl |= (reg & TX_WRITE_ADDR_M);
+
+	if (bank == TX_REG_BANK_SEL_DSP || bank == TX_REG_BANK_SEL_BIST)
+		ctrl |= TX_TEST_MODE;
+	/* write ctrl register with write operation bit set */
+	ctrl |= TX_IND_DATA_WRITE;
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, ctrl);
+}
+
+static void tx_phy_setup(struct ksz_device *dev, int port)
+{
+	u16 data_lo;
+
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_TX_SPECIAL_MODES, &data_lo);
+	/* Need to change configuration from 6 to other value. */
+	data_lo &= TX_PHYADDR_M;
+
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_SPECIAL_MODES, data_lo);
+
+	/* Need to toggle test_mode bit to enable DSP access. */
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, TX_TEST_MODE);
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, 0);
+
+	/* Note TX_TEST_MODE is then always enabled so this is not required. */
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, TX_TEST_MODE);
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, 0);
+}
+
+static void tx_phy_port_init(struct ksz_device *dev, int port)
+{
+	u32 data;
+
+	/* Software reset. */
+	lan937x_t1_tx_phy_mod_bits(dev, port, MII_BMCR, BMCR_RESET, true);
+
+	/* tx phy setup */
+	tx_phy_setup(dev, port);
+
+	/* tx phy init sequence */
+	data = lan937x_tx_phy_bank_read(dev, port, TX_REG_BANK_SEL_VMDAC,
+					TX_VMDAC_ZQ_CAL_CTRL);
+	data |= TX_START_ZQ_CAL;
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_VMDAC,
+				  TX_VMDAC_ZQ_CAL_CTRL, data);
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_VMDAC, TX_VMDAC_CTRL0,
+				  TX_VMDAC_CTRL0_VAL);
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_VMDAC, TX_VMDAC_CTRL1,
+				  TX_VMDAC_CTRL1_VAL);
+	data = lan937x_tx_phy_bank_read(dev, port, TX_REG_BANK_SEL_VMDAC,
+					TX_VMDAC_MISC_PCS_CTRL0);
+	data |= TX_MISC_PCS_CTRL0_13;
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_VMDAC,
+				  TX_VMDAC_MISC_PCS_CTRL0, data);
+
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_DSP, TX_DSP_DCBLW,
+				  TX_DSP_DCBLW_VAL);
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_DSP, TX_DSP_A11_CONFIG,
+				  TX_DSP_A11_CONFIG_VAL);
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_DSP, TX_DSP_A10_CONFIG,
+				  TX_DSP_A10_CONFIG_VAL);
+	data = lan937x_tx_phy_bank_read(dev, port, TX_REG_BANK_SEL_DSP,
+					TX_DSP_A5_CONFIG);
+	data &= ~(TX_A5_TXCLKPHSEL_M << TX_A5_TXCLKPHSEL_S);
+	data |= (TX_A5_TXCLK_2_NS << TX_A5_TXCLKPHSEL_S);
+	lan937x_tx_phy_bank_write(dev, port, TX_REG_BANK_SEL_VMDAC,
+				  TX_DSP_A5_CONFIG, data);
+}
+
+static void lan937x_t1_phy_bank_sel(struct ksz_device *dev, int port,
+				    u8 bank, u8 addr, u16 oper)
+{
+	u16 data, ctrl;
+	u8 prev_bank;
+
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_EXT_REG_CTRL, &ctrl);
+	prev_bank = (ctrl >> T1_REG_BANK_SEL_S) & T1_REG_BANK_SEL_M;
+	ctrl &= T1_PCS_STS_CNT_RESET;
+
+	data = ((u16)bank & T1_REG_BANK_SEL_M) << T1_REG_BANK_SEL_S;
+	data |= (addr & T1_REG_ADDR_M);
+	data |= oper;
+	data |= ctrl;
+
+	/* if the bank is DSP need to write twice */
+	if (bank != prev_bank && bank == T1_REG_BANK_SEL_DSP) {
+		u16 t = data & ~T1_REG_ADDR_M;
+
+		t &= ~oper;
+		t |= T1_IND_DATA_READ;
+
+		/* Need to write twice to access correct register. */
+		lan937x_t1_tx_phy_write(dev, port, REG_PORT_T1_EXT_REG_CTRL, t);
+	}
+
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_T1_EXT_REG_CTRL, data);
+}
+
+static void lan937x_t1_phy_bank_read(struct ksz_device *dev, int port,
+				     u8 bank, u8 addr, u16 *val)
+{
+	/* select the bank for read operation */
+	lan937x_t1_phy_bank_sel(dev, port, bank, addr, T1_IND_DATA_READ);
+
+	/* read bank */
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_EXT_REG_RD_DATA, val);
+}
+
+static void lan937x_t1_phy_bank_write(struct ksz_device *dev, int port,
+				      u8 bank, u8 addr, u16 val)
+{
+	/* write the data to be written into the bank */
+	lan937x_t1_tx_phy_write(dev, port, REG_PORT_T1_EXT_REG_WR_DATA, val);
+	/* select the bank for write operation */
+	lan937x_t1_phy_bank_sel(dev, port, bank, addr, T1_IND_DATA_WRITE);
+}
+
+static void t1_phy_port_init(struct ksz_device *dev, int port)
+{
+	u16 val;
+
+	/* Power down the PHY. */
+	lan937x_t1_tx_phy_mod_bits(dev, port, REG_PORT_T1_PHY_BASIC_CTRL,
+				   PORT_T1_POWER_DOWN, true);
+
+	/* Make sure software initialization sequence is used. */
+	lan937x_t1_tx_phy_mod_bits(dev, port, REG_PORT_T1_POWER_DOWN_CTRL,
+				   T1_HW_INIT_SEQ_ENABLE, false);
+
+	/* Configure T1 phy role */
+	lan937x_t1_tx_phy_mod_bits(dev, port, REG_PORT_T1_PHY_M_CTRL,
+				   PORT_T1_M_CFG, true);
+
+	/* Software reset. */
+	lan937x_t1_tx_phy_mod_bits(dev, port, REG_PORT_T1_PHY_BASIC_CTRL,
+				   PORT_T1_PHY_RESET, true);
+
+	/* cdr mode */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x34, 0x0001);
+
+	/* setting lock 3 mufac */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x1B, 0x0B6A);
+
+	/* setting pos lock mufac */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x1C, 0x0B6B);
+
+	/* setting lock1 win config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x11, 0x2A74);
+
+	/* setting lock2 win config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x12, 0x2B70);
+
+	/* setting lock3 win config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x13, 0x2B6C);
+
+	/* setting plock */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x14, 0x2974);
+
+	/* setting lock threshold config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x16, 0xC803);
+
+	/* slv fd stg bmp */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x24, 0x0002);
+
+	/* Blw BW config lock stage 3 */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x2A, 0x003C);
+
+	/* Blw BW config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x56, 0x3CAA);
+
+	/* Blw BW config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x57, 0x1E47);
+
+	/* Blw BW config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x58, 0x1E4E);
+
+	/* Blw BW config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x59, 0x1E56);
+
+	/* disable scrambler lock timeout 0-disable 1- enable */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x32, 0x00F6);
+
+	/* reducing energy detect partial timeout */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x3C, 0x64CC);
+
+	lan937x_t1_tx_phy_read(dev, port, 0x0A, &val);
+
+	if ((val & 0x4000) == 0)
+		lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_PCS, 0x26, 0x1770);
+
+	/* pwr dn Config */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x04, 0x16D7);
+
+	/* scrambler lock hysterisis */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_PCS, 0x00, 0x7FFF);
+
+	/* eq status timer control */
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_PCS, 0x02, 0x07FF);
+
+	/* MANUAL STD POLARITY */
+	lan937x_t1_tx_phy_write(dev, port, 0x17, 0x0080);
+
+	/* disable master mode energy detect */
+	lan937x_t1_tx_phy_mod_bits(dev, port, 0x10, 0x0040, false);
+
+	lan937x_t1_phy_bank_read(dev, port, T1_REG_BANK_SEL_AFE, 0x0B, &val);
+
+	val &= ~0x001E;
+	/* increase tx amp to 0b0101 */
+	val |= 0x000A;
+
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_AFE, 0x0B, val);
+
+	lan937x_t1_phy_bank_write(dev, port, T1_REG_BANK_SEL_DSP, 0x25, 0x23E0);
+
+	/* Set HW_INIT */
+	lan937x_t1_tx_phy_mod_bits(dev, port, REG_PORT_T1_POWER_DOWN_CTRL,
+				   T1_HW_INIT_SEQ_ENABLE, true);
+
+	/* Power up the PHY. */
+	lan937x_t1_tx_phy_mod_bits(dev, port, REG_PORT_T1_PHY_BASIC_CTRL,
+				   PORT_T1_POWER_DOWN, false);
+}
+
+static void lan937x_set_gbit(struct ksz_device *dev, bool gbit, u8 *data)
+{
+	if (gbit)
+		*data &= ~PORT_MII_NOT_1GBIT;
+	else
+		*data |= PORT_MII_NOT_1GBIT;
+}
+
+void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
+{
+	struct ksz_port *p = &dev->ports[port];
+	u8 data8, member;
+
+	/* enable tag tail for host port */
+	if (cpu_port) {
+		lan937x_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_TAIL_TAG_ENABLE,
+				 true);
+		/* Enable jumbo packet in host port so that frames are not
+		 * counted as oversized.
+		 */
+		lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_JUMBO_PACKET,
+				 true);
+		lan937x_pwrite16(dev, port, REG_PORT_MTU__2, FR_SIZE_CPU_PORT);
+	}
+
+	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_FR_CHK_LENGTH,
+			 false);
+
+	lan937x_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_MAC_LOOPBACK, false);
+
+	/* set back pressure */
+	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE, true);
+
+	/* enable broadcast storm limit */
+	lan937x_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
+
+	/* disable DiffServ priority */
+	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_PRIO_ENABLE, false);
+
+	/* replace priority */
+	lan937x_port_cfg(dev, port, REG_PORT_MRI_MAC_CTRL, PORT_USER_PRIO_CEILING,
+			 false);
+	lan937x_port_cfg32(dev, port, REG_PORT_MTI_QUEUE_CTRL_0__4,
+			   MTI_PVID_REPLACE, false);
+
+	/* enable 802.1p priority */
+	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
+
+	/* phy init for internal ports */
+	if (lan937x_is_internal_phy_port(dev, port)) {
+		if (lan937x_is_internal_tx_phy_port(dev, port))
+			tx_phy_port_init(dev, port);
+		else
+			t1_phy_port_init(dev, port);
+
+	} else {
+		/* force flow control off*/
+		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
+				 PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
+			     false);
+
+		lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
+
+		/* clear MII selection & set it based on interface later */
+		data8 &= ~PORT_MII_SEL_M;
+
+		/* configure MAC based on p->interface */
+		switch (p->interface) {
+		case PHY_INTERFACE_MODE_MII:
+			lan937x_set_gbit(dev, false, &data8);
+			data8 |= PORT_MII_SEL;
+			break;
+		case PHY_INTERFACE_MODE_RMII:
+			lan937x_set_gbit(dev, false, &data8);
+			data8 |= PORT_RMII_SEL;
+			break;
+		default:
+			lan937x_set_gbit(dev, true, &data8);
+			data8 |= PORT_RGMII_SEL;
+
+			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
+			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
+
+			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+				data8 |= PORT_RGMII_ID_IG_ENABLE;
+
+			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+				data8 |= PORT_RGMII_ID_EG_ENABLE;
+			break;
+		}
+		lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
+	}
+
+	if (cpu_port)
+		member = dev->port_mask;
+	else
+		member = dev->host_mask | p->vid_member;
+
+	lan937x_cfg_port_member(dev, port, member);
+}
+
+static int lan937x_switch_init(struct ksz_device *dev)
+{
+	int i;
+
+	dev->ds->ops = &lan937x_switch_ops;
+
+	for (i = 0; i < ARRAY_SIZE(lan937x_switch_chips); i++) {
+		const struct lan937x_chip_data *chip = &lan937x_switch_chips[i];
+
+		if (dev->chip_id == chip->chip_id) {
+			dev->name = chip->dev_name;
+			dev->num_vlans = chip->num_vlans;
+			dev->num_alus = chip->num_alus;
+			dev->num_statics = chip->num_statics;
+			dev->port_cnt = chip->port_cnt;
+			dev->cpu_ports = chip->cpu_ports;
+			break;
+		}
+	}
+
+	/* no switch found */
+	if (!dev->port_cnt)
+		return -ENODEV;
+
+	dev->port_mask = (1 << dev->port_cnt) - 1;
+
+	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
+	dev->mib_cnt = ARRAY_SIZE(lan937x_mib_names);
+
+	dev->ports = devm_kzalloc(dev->dev,
+				  dev->port_cnt * sizeof(struct ksz_port),
+				  GFP_KERNEL);
+	if (!dev->ports)
+		return -ENOMEM;
+
+	for (i = 0; i < dev->port_cnt; i++) {
+		mutex_init(&dev->ports[i].mib.cnt_mutex);
+		dev->ports[i].mib.counters =
+			devm_kzalloc(dev->dev,
+				     sizeof(u64) *
+				     (dev->mib_cnt + 1),
+				     GFP_KERNEL);
+		if (!dev->ports[i].mib.counters)
+			return -ENOMEM;
+	}
+
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->port_cnt;
+	return 0;
+}
+
+const struct ksz_dev_ops lan937x_dev_ops = {
+	.get_port_addr = lan937x_get_port_addr,
+	.cfg_port_member = lan937x_cfg_port_member,
+	.flush_dyn_mac_table = lan937x_flush_dyn_mac_table,
+	.port_setup = lan937x_port_setup,
+	.port_init_cnt = lan937x_port_init_cnt,
+	.shutdown = lan937x_reset_switch,
+	.detect = lan937x_switch_detect,
+	.init = lan937x_switch_init,
+	.exit = lan937x_switch_exit,
+};
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
new file mode 100644
index 000000000000..e78483793642
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip lan937x dev ops headers
+ * Copyright (C) 2019-2020 Microchip Technology Inc.
+ */
+
+#ifndef __LAN937X_CFG_H
+#define __LAN937X_CFG_H
+
+void lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set);
+void lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
+		      u8 bits, bool set);
+void lan937x_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set);
+void lan937x_pread8(struct ksz_device *dev, int port, int offset,
+		    u8 *data);
+void lan937x_pread16(struct ksz_device *dev, int port, int offset,
+		     u16 *data);
+void lan937x_pread32(struct ksz_device *dev, int port, int offset,
+		     u32 *data);
+void lan937x_pwrite8(struct ksz_device *dev, int port,
+		     int offset, u8 data);
+void lan937x_pwrite16(struct ksz_device *dev, int port,
+		      int offset, u16 data);
+void lan937x_pwrite32(struct ksz_device *dev, int port,
+		      int offset, u32 data);
+void lan937x_port_cfg32(struct ksz_device *dev, int port, int offset,
+			u32 bits, bool set);
+int lan937x_t1_tx_phy_write(struct ksz_device *dev, int addr,
+			    int reg, u16 val);
+int lan937x_t1_tx_phy_read(struct ksz_device *dev, int addr,
+			   int reg, u16 *val);
+bool lan937x_is_internal_tx_phy_port(struct ksz_device *dev, int port);
+bool lan937x_is_internal_t1_phy_port(struct ksz_device *dev, int port);
+bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port);
+int lan937x_reset_switch(struct ksz_device *dev);
+void lan937x_cfg_port_member(struct ksz_device *dev, int port,
+			     u8 member);
+void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+int lan937x_sw_register(struct ksz_device *dev);
+void lan937x_enable_spi_indirect_access(struct ksz_device *dev);
+
+struct mib_names {
+	int index;
+	char string[ETH_GSTRING_LEN];
+};
+
+struct lan937x_chip_data {
+	u32 chip_id;
+	const char *dev_name;
+	int num_vlans;
+	int num_alus;
+	int num_statics;
+	int cpu_ports;
+	int port_cnt;
+};
+
+struct lan_alu_struct {
+	/* entry 1 */
+	u8	is_static:1;
+	u8	is_src_filter:1;
+	u8	is_dst_filter:1;
+	u8	prio_age:3;
+	u32	_reserv_0_1:23;
+	u8	mstp:3;
+	/* entry 2 */
+	u8	is_override:1;
+	u8	is_use_fid:1;
+	u32	_reserv_1_1:22;
+	u8	port_forward:8;
+	/* entry 3 & 4*/
+	u32	_reserv_2_1:9;
+	u8	fid:7;
+	u8	mac[ETH_ALEN];
+};
+
+extern const struct dsa_switch_ops lan937x_switch_ops;
+extern const struct ksz_dev_ops lan937x_dev_ops;
+extern const struct mib_names lan937x_mib_names[];
+
+#endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
new file mode 100644
index 000000000000..41f7f5f8f435
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -0,0 +1,352 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip LAN937X switch driver main logic
+ * Copyright (C) 2019-2020 Microchip Technology Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/iopoll.h>
+#include <linux/phy.h>
+#include <linux/if_bridge.h>
+#include <net/dsa.h>
+#include <net/switchdev.h>
+
+#include "lan937x_reg.h"
+#include "ksz_common.h"
+#include "lan937x_dev.h"
+
+static enum dsa_tag_protocol lan937x_get_tag_protocol(struct dsa_switch *ds,
+						      int port,
+						      enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_LAN937X_VALUE;
+}
+
+static int lan937x_get_link_status(struct ksz_device *dev, int port)
+{
+	u16 val1, val2;
+
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_PHY_M_STATUS,
+			       &val1);
+
+	lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_MODE_STAT, &val2);
+
+	if (val1 & (PORT_T1_LOCAL_RX_OK | PORT_T1_REMOTE_RX_OK) &&
+	    val2 & (T1_PORT_DSCR_LOCK_STATUS_MSK | T1_PORT_LINK_UP_MSK))
+		return PHY_LINK_UP;
+
+	return PHY_LINK_DOWN;
+}
+
+static int lan937x_phy_read16(struct dsa_switch *ds, int addr, int reg)
+{
+	struct ksz_device *dev = ds->priv;
+	u16 val;
+
+	lan937x_t1_tx_phy_read(dev, addr, reg, &val);
+
+	if (reg == MII_BMSR && lan937x_is_internal_t1_phy_port(dev, addr)) {
+		/* T1 PHY supports only 100 Mb FD, report through BMSR_100FULL bit*/
+		val |= BMSR_100FULL;
+
+		/* T1 Phy link is based on REG_PORT_T1_PHY_M_STATUS & REG_PORT_T1
+		 * _MODE_STAT registers for LAN937x, get the link status
+		 * and report through BMSR_LSTATUS bit
+		 */
+		if (lan937x_get_link_status(dev, addr) == PHY_LINK_UP)
+			val |= BMSR_LSTATUS;
+		else
+			val &= ~BMSR_LSTATUS;
+	}
+
+	return val;
+}
+
+static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
+			       u16 val)
+{
+	struct ksz_device *dev = ds->priv;
+
+	return lan937x_t1_tx_phy_write(dev, addr, reg, val);
+}
+
+static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
+				       u8 state)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
+	int forward = dev->member;
+	int member = -1;
+	u8 data;
+
+	lan937x_pread8(dev, port, P_STP_CTRL, &data);
+	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		data |= PORT_LEARN_DISABLE;
+		if (port != dev->cpu_port)
+			member = 0;
+		break;
+	case BR_STATE_LISTENING:
+		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
+		if (port != dev->cpu_port &&
+		    p->stp_state == BR_STATE_DISABLED)
+			member = dev->host_mask | p->vid_member;
+		break;
+	case BR_STATE_LEARNING:
+		data |= PORT_RX_ENABLE;
+		break;
+	case BR_STATE_FORWARDING:
+		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+
+		/* This function is also used internally. */
+		if (port == dev->cpu_port)
+			break;
+
+		member = dev->host_mask | p->vid_member;
+		mutex_lock(&dev->dev_mutex);
+
+		/* Port is a member of a bridge. */
+		if (dev->br_member & (1 << port)) {
+			dev->member |= (1 << port);
+			member = dev->member;
+		}
+		mutex_unlock(&dev->dev_mutex);
+		break;
+	case BR_STATE_BLOCKING:
+		data |= PORT_LEARN_DISABLE;
+		if (port != dev->cpu_port &&
+		    p->stp_state == BR_STATE_DISABLED)
+			member = dev->host_mask | p->vid_member;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	lan937x_pwrite8(dev, port, P_STP_CTRL, data);
+
+	p->stp_state = state;
+	mutex_lock(&dev->dev_mutex);
+
+	/* Port membership may share register with STP state. */
+	if (member >= 0 && member != p->member)
+		lan937x_cfg_port_member(dev, port, (u8)member);
+
+	/* Check if forwarding needs to be updated. */
+	if (state != BR_STATE_FORWARDING) {
+		if (dev->br_member & (1 << port))
+			dev->member &= ~(1 << port);
+	}
+
+	/* When topology has changed the function ksz_update_port_member
+	 * should be called to modify port forwarding behavior.
+	 */
+	if (forward != dev->member)
+		ksz_update_port_member(dev, port);
+	mutex_unlock(&dev->dev_mutex);
+}
+
+static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
+{
+	phy_interface_t interface;
+	u8 data8;
+
+	if (lan937x_is_internal_phy_port(dev, port))
+		return PHY_INTERFACE_MODE_NA;
+
+	/* read interface from REG_PORT_XMII_CTRL_1 register */
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
+
+	switch (data8 & PORT_MII_SEL_M) {
+	case PORT_RMII_SEL:
+		interface = PHY_INTERFACE_MODE_RMII;
+		break;
+	case PORT_RGMII_SEL:
+		interface = PHY_INTERFACE_MODE_RGMII;
+		if (data8 & PORT_RGMII_ID_EG_ENABLE)
+			interface = PHY_INTERFACE_MODE_RGMII_TXID;
+		if (data8 & PORT_RGMII_ID_IG_ENABLE) {
+			interface = PHY_INTERFACE_MODE_RGMII_RXID;
+			if (data8 & PORT_RGMII_ID_EG_ENABLE)
+				interface = PHY_INTERFACE_MODE_RGMII_ID;
+		}
+		break;
+	case PORT_MII_SEL:
+	default:
+		/* Interface is MII */
+		interface = PHY_INTERFACE_MODE_MII;
+		break;
+	}
+	return interface;
+}
+
+static void lan937x_config_cpu_port(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+	int i;
+
+	ds->num_ports = dev->port_cnt;
+
+	for (i = 0; i < dev->port_cnt; i++) {
+		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
+			phy_interface_t interface;
+			const char *prev_msg;
+			const char *prev_mode;
+
+			dev->cpu_port = i;
+			dev->host_mask = (1 << dev->cpu_port);
+			dev->port_mask |= dev->host_mask;
+			p = &dev->ports[i];
+
+			/* Read from XMII register to determine host port
+			 * interface.  If set specifically in device tree
+			 * note the difference to help debugging.
+			 */
+			interface = lan937x_get_interface(dev, i);
+			if (!p->interface) {
+				if (dev->compat_interface) {
+					dev_warn(dev->dev,
+						 "Using legacy switch \"phy-mode\" property, because it is missing on port %d node. Please update your device tree.\n",
+						 i);
+					p->interface = dev->compat_interface;
+				} else {
+					p->interface = interface;
+				}
+			}
+			if (interface && interface != p->interface) {
+				prev_msg = " instead of ";
+				prev_mode = phy_modes(interface);
+			} else {
+				prev_msg = "";
+				prev_mode = "";
+			}
+			dev_info(dev->dev,
+				 "Port%d: using phy mode %s%s%s\n",
+				 i,
+				 phy_modes(p->interface),
+				 prev_msg,
+				 prev_mode);
+
+			/* enable cpu port */
+			lan937x_port_setup(dev, i, true);
+			p->vid_member = dev->port_mask;
+		}
+	}
+
+	dev->member = dev->host_mask;
+
+	for (i = 0; i < dev->port_cnt; i++) {
+		if (i == dev->cpu_port)
+			continue;
+		p = &dev->ports[i];
+
+		/* Initialize to non-zero so that lan937x_cfg_port_member() will
+		 * be called.
+		 */
+		p->vid_member = (1 << i);
+		p->member = dev->port_mask;
+		lan937x_port_stp_state_set(ds, i, BR_STATE_DISABLED);
+	}
+}
+
+static int lan937x_setup(struct dsa_switch *ds)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret = 0;
+
+	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
+				       dev->num_vlans, GFP_KERNEL);
+	if (!dev->vlan_cache)
+		return -ENOMEM;
+
+	ret = lan937x_reset_switch(dev);
+	if (ret) {
+		dev_err(ds->dev, "failed to reset switch\n");
+		return ret;
+	}
+
+	/* Required for port partitioning. */
+	lan937x_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
+		      true);
+
+	lan937x_config_cpu_port(ds);
+
+	ds->configure_vlan_while_not_filtering = true;
+
+	/* Enable aggressive back off & UNH */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_0, SW_PAUSE_UNH_MODE | SW_NEW_BACKOFF |
+						SW_AGGR_BACKOFF, true);
+
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_1, (MULTICAST_STORM_DISABLE
+							| NO_EXC_COLLISION_DROP), true);
+
+	/* queue based egress rate limit */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_5, SW_OUT_RATE_LIMIT_QUEUE_BASED, true);
+
+	lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
+
+	/* enable global MIB counter freeze function */
+	lan937x_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
+
+	/* enable Indirect Access from SPI to the VPHY registers */
+	lan937x_enable_spi_indirect_access(dev);
+
+	/* start switch */
+	lan937x_cfg(dev, REG_SW_OPERATION, SW_START, true);
+
+	ksz_init_mib_timer(dev);
+
+	return 0;
+}
+
+static int lan937x_change_mtu(struct dsa_switch *ds, int port, int mtu)
+{
+	struct ksz_device *dev = ds->priv;
+	u16 max_size;
+
+	if (mtu >= FR_MIN_SIZE) {
+		lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_JUMBO_EN, true);
+		max_size = FR_MAX_SIZE;
+	} else {
+		lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_JUMBO_EN, false);
+		max_size = FR_MIN_SIZE;
+	}
+	/* Write the frame size in PORT_MAX_FR_SIZE register */
+	lan937x_pwrite16(dev, port, PORT_MAX_FR_SIZE, max_size);
+	return 0;
+}
+
+static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	/* Frame size is 9000 (= 0x2328) if
+	 * jumbo frame support is enabled, PORT_JUMBO_EN bit will be enabled
+	 * based on mtu in lan937x_change_mtu() API
+	 */
+	return FR_MAX_SIZE;
+}
+
+const struct dsa_switch_ops lan937x_switch_ops = {
+	.get_tag_protocol	= lan937x_get_tag_protocol,
+	.setup			= lan937x_setup,
+	.phy_read		= lan937x_phy_read16,
+	.phy_write		= lan937x_phy_write16,
+	.port_enable		= ksz_enable_port,
+	.port_bridge_join	= ksz_port_bridge_join,
+	.port_bridge_leave	= ksz_port_bridge_leave,
+	.port_stp_state_set	= lan937x_port_stp_state_set,
+	.port_fast_age		= ksz_port_fast_age,
+	.port_max_mtu		= lan937x_get_max_mtu,
+	.port_change_mtu	= lan937x_change_mtu,
+};
+
+int lan937x_switch_register(struct ksz_device *dev)
+{
+	return ksz_switch_register(dev, &lan937x_dev_ops);
+}
+EXPORT_SYMBOL(lan937x_switch_register);
+
+MODULE_AUTHOR("Prasanna Vengateshan Varadharajan <Prasanna.Vengateshan@microchip.com>");
+MODULE_DESCRIPTION("Microchip LAN937x Series Switch DSA Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
new file mode 100644
index 000000000000..d899a43f4d8e
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -0,0 +1,955 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Microchip LAN937X switch register definitions
+ * Copyright (C) 2019-2020 Microchip Technology Inc.
+ */
+#ifndef __LAN937X_REG_H
+#define __LAN937X_REG_H
+
+/* 0 - Operation */
+#define REG_CHIP_ID0__1			0x0000
+#define REG_CHIP_ID1__1			0x0001
+#define REG_CHIP_ID2__1			0x0002
+
+#define CHIP_ID_74			0x74
+#define CHIP_ID_73			0x73
+#define CHIP_ID_72			0x72
+#define CHIP_ID_71			0x71
+#define CHIP_ID_70			0x70
+
+#define REG_CHIP_ID3__1			0x0003
+
+#define REG_GLOBAL_CTRL_0		0x0007
+
+#define SW_PHY_REG_BLOCK		BIT(7)
+#define SW_FAST_MODE			BIT(3)
+#define SW_FAST_MODE_OVERRIDE		BIT(2)
+
+#define REG_GLOBAL_OPTIONS		0x000F
+
+#define REG_SW_INT_STATUS__4		0x0010
+#define REG_SW_INT_MASK__4		0x0014
+
+#define LUE_INT				BIT(31)
+#define TRIG_TS_INT			BIT(30)
+#define APB_TIMEOUT_INT			BIT(29)
+#define OVER_TEMP_INT			BIT(28)
+#define HSR_INT				BIT(27)
+#define PIO_INT				BIT(26)
+#define POR_READY_INT			BIT(25)
+
+#define SWITCH_INT_MASK			\
+	(LUE_INT | TRIG_TS_INT | APB_TIMEOUT_INT | OVER_TEMP_INT | HSR_INT | \
+	 PIO_INT | POR_READY_INT)
+
+#define REG_SW_PORT_INT_STATUS__4	0x0018
+#define REG_SW_PORT_INT_MASK__4		0x001C
+
+/* 1 - Global */
+#define REG_SW_GLOBAL_SERIAL_CTRL_0	0x0100
+
+#define SW_LITTLE_ENDIAN		BIT(4)
+#define SPI_AUTO_EDGE_DETECTION		BIT(1)
+#define SPI_CLOCK_OUT_RISING_EDGE	BIT(0)
+
+#define REG_SW_GLOBAL_OUTPUT_CTRL__1	0x0103
+#define SW_ENABLE_REFCLKO		BIT(1)
+#define SW_REFCLKO_IS_125MHZ		BIT(0)
+
+/* 2 - PHY */
+#define REG_SW_POWER_MANAGEMENT_CTRL	0x0201
+
+/* 3 - Operation Control */
+#define REG_SW_OPERATION		0x0300
+
+#define SW_DOUBLE_TAG			BIT(7)
+#define SW_OVER_TEMP_ENABLE		BIT(2)
+#define SW_RESET			BIT(1)
+#define SW_START			BIT(0)
+
+#define REG_SW_LUE_CTRL_0		0x0310
+#define SW_VLAN_ENABLE			BIT(7)
+#define SW_DROP_INVALID_VID		BIT(6)
+#define SW_AGE_CNT_M			0x7
+#define SW_AGE_CNT_S			3
+#define SW_RESV_MCAST_ENABLE		BIT(2)
+
+#define REG_SW_LUE_CTRL_1		0x0311
+
+#define UNICAST_LEARN_DISABLE		BIT(7)
+#define SW_SRC_ADDR_FILTER		BIT(6)
+#define SW_FLUSH_STP_TABLE		BIT(5)
+#define SW_FLUSH_MSTP_TABLE		BIT(4)
+#define SW_FWD_MCAST_SRC_ADDR		BIT(3)
+#define SW_AGING_ENABLE			BIT(2)
+#define SW_FAST_AGING			BIT(1)
+#define SW_LINK_AUTO_AGING		BIT(0)
+
+#define REG_SW_LUE_CTRL_2		0x0312
+
+#define SW_MID_RANGE_AGE		BIT(7)
+#define SW_LINK_DOWN_FLUSH		BIT(6)
+#define SW_EGRESS_VLAN_FILTER_DYN	BIT(5)
+#define SW_EGRESS_VLAN_FILTER_STA	BIT(4)
+#define SW_FLUSH_OPTION_M		0x3
+#define SW_FLUSH_OPTION_S		2
+#define SW_FLUSH_OPTION_DYN_MAC		1
+#define SW_FLUSH_OPTION_STA_MAC		2
+#define SW_FLUSH_OPTION_BOTH		3
+
+#define REG_SW_LUE_CTRL_3		0x0313
+#define REG_SW_AGE_PERIOD__1		0x0313
+
+#define REG_SW_LUE_INT_STATUS__1	0x0314
+#define REG_SW_LUE_INT_MASK__1		0x0315
+
+#define LEARN_FAIL_INT			BIT(2)
+#define WRITE_FAIL_INT			BIT(0)
+
+#define LUE_INT_MASK			(LEARN_FAIL_INT | WRITE_FAIL_INT)
+
+#define REG_SW_LUE_INDEX_0__2		0x0316
+
+#define ENTRY_INDEX_M			0x0FFF
+
+#define REG_SW_LUE_INDEX_1__2		0x0318
+
+#define FAIL_INDEX_M			0x03FF
+
+#define REG_SW_LUE_INDEX_2__2		0x031A
+
+#define REG_SW_STATIC_AVAIL_ENTRY__4	0x031C
+
+#define SW_INGRESS_FILTERING_NO_LEARN	BIT(15)
+#define SW_STATIC_AVAIL_CNT		0x1FF
+
+#define REG_SW_AGE_PERIOD__2		0x0320
+#define SW_AGE_PERIOD_M			0xFFF
+
+#define REG_SW_LUE_UNK_UCAST_CTRL__2	0x0322
+#define REG_SW_LUE_UNK_CTRL_0__4	0x0322
+
+#define SW_UNK_UCAST_ENABLE		BIT(15)
+#define SW_UNK_PORTS_M			0xFF
+
+#define REG_SW_LUE_UNK_MCAST_CTRL__2	0x0324
+#define SW_UNK_MCAST_ENABLE		BIT(15)
+
+#define REG_SW_LUE_UNK_VID_CTRL__2	0x0326
+#define SW_UNK_VID_ENABLE		BIT(15)
+
+#define SW_VLAN_FLUSH_PORTS_M		0xFF
+
+#define REG_SW_STATIC_ENTRY_LIMIT__4	0x032C
+
+#define REG_SW_MAC_CTRL_0			0x0330
+#define SW_NEW_BACKOFF			BIT(7)
+#define SW_PAUSE_UNH_MODE		BIT(1)
+#define SW_AGGR_BACKOFF			BIT(0)
+
+#define REG_SW_MAC_CTRL_1		0x0331
+#define SW_SHORT_IFG			BIT(7)
+#define MULTICAST_STORM_DISABLE		BIT(6)
+#define SW_BACK_PRESSURE		BIT(5)
+#define FAIR_FLOW_CTRL			BIT(4)
+#define NO_EXC_COLLISION_DROP		BIT(3)
+#define SW_LEGAL_PACKET_DISABLE		BIT(1)
+#define SW_PASS_SHORT_FRAME		BIT(0)
+
+#define REG_SW_MAC_CTRL_2		0x0332
+#define SW_REPLACE_VID			BIT(3)
+#define BROADCAST_STORM_RATE_HI		0x07
+
+#define REG_SW_MAC_CTRL_3		0x0333
+#define BROADCAST_STORM_RATE_LO		0xFF
+#define BROADCAST_STORM_RATE		0x07FF
+
+#define REG_SW_MAC_CTRL_4		0x0334
+#define SW_PASS_PAUSE			BIT(3)
+
+#define REG_SW_MAC_CTRL_5		0x0335
+#define SW_OUT_RATE_LIMIT_QUEUE_BASED	BIT(3)
+
+#define REG_SW_MAC_CTRL_6		0x0336
+#define SW_MIB_COUNTER_FLUSH		BIT(7)
+#define SW_MIB_COUNTER_FREEZE		BIT(6)
+
+#define REG_SW_MRI_CTRL_0		0x0370
+#define SW_IGMP_SNOOP			BIT(6)
+#define SW_IPV6_MLD_OPTION		BIT(3)
+#define SW_IPV6_MLD_SNOOP		BIT(2)
+#define SW_MIRROR_RX_TX			BIT(0)
+
+#define REG_SW_MRI_CTRL_1__4		0x0374
+#define REG_SW_MRI_CTRL_2__4		0x0378
+#define REG_SW_CLASS_D_IP_CTRL__4	0x0374
+
+#define SW_CLASS_D_IP_ENABLE		BIT(31)
+
+#define REG_SW_MRI_CTRL_8		0x0378
+#define SW_RED_COLOR_S			4
+#define SW_YELLOW_COLOR_S		2
+#define SW_GREEN_COLOR_S		0
+#define SW_COLOR_M			0x3
+
+#define REG_PTP_EVENT_PRIO_CTRL		0x037C
+#define REG_PTP_GENERAL_PRIO_CTRL	0x037D
+#define PTP_PRIO_ENABLE			BIT(7)
+
+#define REG_SW_QM_CTRL__4		0x0390
+#define PRIO_SCHEME_SELECT_M		KS_PRIO_M
+#define PRIO_SCHEME_SELECT_S		6
+#define PRIO_MAP_3_HI			0
+#define PRIO_MAP_2_HI			2
+#define PRIO_MAP_0_LO			3
+#define UNICAST_VLAN_BOUNDARY		BIT(1)
+
+#define REG_SW_EEE_QM_CTRL__2		0x03C0
+#define REG_SW_EEE_TXQ_WAIT_TIME__2	0x03C2
+
+/* 4 - */
+#define REG_SW_VLAN_ENTRY__4		0x0400
+#define VLAN_VALID			BIT(31)
+#define VLAN_FORWARD_OPTION		BIT(27)
+#define VLAN_PRIO_M			KS_PRIO_M
+#define VLAN_PRIO_S			24
+#define VLAN_MSTP_M			0x7
+#define VLAN_MSTP_S			12
+#define VLAN_FID_M			0x7F
+
+#define REG_SW_VLAN_ENTRY_UNTAG__4	0x0404
+#define REG_SW_VLAN_ENTRY_PORTS__4	0x0408
+#define REG_SW_VLAN_ENTRY_INDEX__2	0x040C
+
+#define VLAN_INDEX_M			0x0FFF
+
+#define REG_SW_VLAN_CTRL		0x040E
+#define VLAN_START			BIT(7)
+#define VLAN_ACTION			0x3
+#define VLAN_WRITE			1
+#define VLAN_READ			2
+#define VLAN_CLEAR			3
+
+#define REG_SW_ALU_INDEX_0		0x0410
+#define ALU_FID_INDEX_S			16
+#define ALU_FID_SIZE			127
+#define ALU_MAC_ADDR_HI			0xFFFF
+
+#define REG_SW_ALU_INDEX_1		0x0414
+#define ALU_DIRECT_INDEX_M		(BIT(12) - 1)
+
+#define REG_SW_ALU_CTRL__4		0x0418
+#define REG_SW_ALU_CTRL(num)	(REG_SW_ALU_CTRL__4 + ((num) * 4))
+
+#define ALU_STA_DYN_CNT			2
+#define ALU_VALID_CNT_M			(BIT(14) - 1)
+#define ALU_VALID_CNT_S			16
+#define ALU_START			BIT(7)
+#define ALU_VALID			BIT(6)
+#define ALU_VALID_OR_STOP		BIT(5)
+#define ALU_DIRECT			BIT(2)
+#define ALU_ACTION			0x3
+#define ALU_WRITE			1
+#define ALU_READ			2
+#define ALU_SEARCH			3
+
+#define REG_SW_ALU_STAT_CTRL__4		0x041C
+#define ALU_STAT_VALID_CNT_M		(BIT(9) - 1)
+#define ALU_STAT_VALID_CNT_S		20
+#define ALU_STAT_INDEX_M		(BIT(8) - 1)
+#define ALU_STAT_INDEX_S		8
+#define ALU_RESV_MCAST_INDEX_M		(BIT(6) - 1)
+#define ALU_STAT_START			BIT(7)
+#define ALU_STAT_VALID			BIT(6)
+#define ALU_STAT_VALID_OR_STOP		BIT(5)
+#define ALU_STAT_USE_FID		BIT(4)
+#define ALU_STAT_DIRECT			BIT(3)
+#define ALU_RESV_MCAST_ADDR		BIT(2)
+#define ALU_STAT_ACTION			0x3
+#define ALU_STAT_WRITE			1
+#define ALU_STAT_READ			2
+#define ALU_STAT_SEARCH			3
+
+#define REG_SW_ALU_VAL_A		0x0420
+#define ALU_V_STATIC_VALID		BIT(31)
+#define ALU_V_SRC_FILTER		BIT(30)
+#define ALU_V_DST_FILTER		BIT(29)
+#define ALU_V_PRIO_AGE_CNT_M		(BIT(3) - 1)
+#define ALU_V_PRIO_AGE_CNT_S		26
+#define ALU_V_MSTP_M			0x7
+
+#define REG_SW_ALU_VAL_B		0x0424
+#define ALU_V_OVERRIDE			BIT(31)
+#define ALU_V_USE_FID			BIT(30)
+#define ALU_V_PORT_MAP			0xFF
+
+#define REG_SW_ALU_VAL_C		0x0428
+#define ALU_V_FID_M			(BIT(16) - 1)
+#define ALU_V_FID_S			16
+#define ALU_V_MAC_ADDR_HI		0xFFFF
+
+#define REG_SW_ALU_VAL_D		0x042C
+
+#define PORT_CTRL_ADDR(port, addr)	((addr) | (((port) + 1)  << 12))
+
+#define REG_GLOBAL_RR_INDEX__1		0x0600
+
+/* VPHY */
+#define REG_VPHY_CTRL__2		0x0700
+#define REG_VPHY_STAT__2		0x0704
+#define REG_VPHY_ID_HI__2		0x0708
+#define REG_VPHY_ID_LO__2		0x070C
+#define REG_VPHY_AUTO_NEG__2		0x0710
+#define REG_VPHY_REMOTE_CAP__2		0x0714
+
+#define REG_VPHY_EXPANSION__2		0x0718
+
+#define REG_VPHY_M_CTRL__2		0x0724
+#define REG_VPHY_M_STAT__2		0x0728
+
+#define REG_VPHY_EXT_STAT__2		0x073C
+#define VPHY_EXT_1000_X_FULL		BIT(15)
+#define VPHY_EXT_1000_X_HALF		BIT(14)
+#define VPHY_EXT_1000_T_FULL		BIT(13)
+#define VPHY_EXT_1000_T_HALF		BIT(12)
+
+#define REG_VPHY_DEVAD_0__2		0x0740
+#define REG_VPHY_DEVAD_1__2		0x0744
+#define REG_VPHY_DEVAD_2__2		0x0748
+#define REG_VPHY_DEVAD_3__2		0x074C
+
+#define VPHY_DEVAD_UPDATE		BIT(7)
+#define VPHY_DEVAD_M			0x1F
+#define VPHY_DEVAD_S			8
+
+#define REG_VPHY_SMI_ADDR__2		0x0750
+#define REG_VPHY_SMI_DATA_LO__2		0x0754
+#define REG_VPHY_SMI_DATA_HI__2		0x0758
+
+#define REG_VPHY_IND_ADDR__2		0x075C
+#define REG_VPHY_IND_DATA__2		0x0760
+#define REG_VPHY_IND_CTRL__2		0x0768
+
+#define VPHY_IND_WRITE			BIT(1)
+#define VPHY_IND_BUSY			BIT(0)
+
+#define REG_VPHY_SPECIAL_CTRL__2	0x077C
+#define VPHY_SMI_INDIRECT_ENABLE	BIT(15)
+#define VPHY_SW_LOOPBACK		BIT(14)
+#define VPHY_MDIO_INTERNAL_ENABLE	BIT(13)
+#define VPHY_SPI_INDIRECT_ENABLE	BIT(12)
+#define VPHY_PORT_MODE_M		0x3
+#define VPHY_PORT_MODE_S		8
+#define VPHY_MODE_RGMII			0
+#define VPHY_MODE_MII_PHY		1
+#define VPHY_MODE_SGMII			2
+#define VPHY_MODE_RMII_PHY		3
+#define VPHY_SW_COLLISION_TEST		BIT(7)
+#define VPHY_SPEED_DUPLEX_STAT_M	0x7
+#define VPHY_SPEED_DUPLEX_STAT_S	2
+#define VPHY_SPEED_1000			BIT(4)
+#define VPHY_SPEED_100			BIT(3)
+#define VPHY_FULL_DUPLEX		BIT(2)
+
+/* 0 - Operation */
+#define REG_PORT_DEFAULT_VID		0x0000
+
+#define REG_PORT_CUSTOM_VID		0x0002
+#define REG_PORT_PME_STATUS		0x0013
+
+#define REG_PORT_PME_CTRL		0x0017
+#define PME_WOL_MAGICPKT		BIT(2)
+#define PME_WOL_LINKUP			BIT(1)
+#define PME_WOL_ENERGY			BIT(0)
+
+#define REG_PORT_INT_STATUS		0x001B
+#define REG_PORT_INT_MASK		0x001F
+
+#define PORT_TAS_INT			BIT(5)
+#define PORT_SGMII_INT			BIT(3)
+#define PORT_PTP_INT			BIT(2)
+#define PORT_PHY_INT			BIT(1)
+#define PORT_ACL_INT			BIT(0)
+
+#define PORT_INT_MASK			\
+	(				\
+	PORT_TAS_INT |			\
+	PORT_SGMII_INT | PORT_PTP_INT | PORT_PHY_INT | PORT_ACL_INT)
+
+#define REG_PORT_CTRL_0			0x0020
+
+#define PORT_MAC_LOOPBACK		BIT(7)
+#define PORT_MAC_REMOTE_LOOPBACK	BIT(6)
+#define PORT_K2L_INSERT_ENABLE		BIT(5)
+#define PORT_K2L_DEBUG_ENABLE		BIT(4)
+#define PORT_TAIL_TAG_ENABLE		BIT(2)
+#define PORT_QUEUE_SPLIT_ENABLE		0x3
+
+#define REG_PORT_CTRL_1			0x0021
+#define PORT_SRP_ENABLE			0x3
+
+#define REG_PORT_STATUS_0		0x0030
+#define PORT_INTF_SPEED_M		0x3
+#define PORT_INTF_SPEED_S		3
+#define PORT_INTF_FULL_DUPLEX		BIT(2)
+#define PORT_TX_FLOW_CTRL		BIT(1)
+#define PORT_RX_FLOW_CTRL		BIT(0)
+
+#define REG_PORT_STATUS_1		0x0034
+
+/* 1 - PHY */
+#define REG_VPHY_SMI_ADDR		0x14
+#define REG_VPHY_SMI_DATA_LO		0x15
+#define REG_VPHY_SMI_DATA_HI		0x16
+
+#define REG_VPHY_SPECIAL_CTRL_STAT	0x1F
+
+#define REG_PORT_T1_PHY_BASIC_CTRL	0x00
+
+#define PORT_T1_PHY_RESET		BIT(15)
+#define PORT_T1_PHY_LOOPBACK		BIT(14)
+#define PORT_T1_SPEED_100MBIT		BIT(13)
+#define PORT_T1_POWER_DOWN		BIT(11)
+#define PORT_T1_ISOLATE			BIT(10)
+#define PORT_T1_FULL_DUPLEX		BIT(8)
+
+#define REG_PORT_T1_PHY_BASIC_STATUS	0x01
+
+#define PORT_T1_MII_SUPPRESS_CAPABLE	BIT(6)
+#define PORT_T1_LINK_STATUS		BIT(2)
+#define PORT_T1_EXTENDED_CAPABILITY	BIT(0)
+
+#define REG_PORT_T1_PHY_ID_HI		0x02
+#define REG_PORT_T1_PHY_ID_LO		0x03
+
+#define LAN937X_T1_ID_HI		0x0007
+#define LAN937X_T1_ID_LO		0xC150
+
+#define REG_PORT_T1_PHY_M_CTRL	0x09
+
+#define PORT_T1_MANUAL_CFG		BIT(12)
+#define PORT_T1_M_CFG		BIT(11)
+
+#define REG_PORT_T1_PHY_M_STATUS	0x0A
+
+#define PORT_T1_LOCAL_M		BIT(14)
+#define PORT_T1_LOCAL_RX_OK		BIT(13)
+#define PORT_T1_REMOTE_RX_OK		BIT(12)
+#define PORT_T1_IDLE_ERR_CNT_M		0xFF
+
+#define REG_PORT_T1_MDIO_CTRL_1		0x0F
+
+#define T1_MDIO_WAKE_OUT_PIN_REQ	BIT(0)
+
+#define REG_PORT_T1_MDIO_CTRL_2		0x10
+
+#define T1_MDIO_MDPREBP			BIT(15)
+#define T1_MDIO_PHYADBP			BIT(14)
+#define T1_MDIO_WAKE_REQ		BIT(13)
+#define T1_MDIO_SLEEP_REQ		BIT(12)
+#define TI_MDIO_CTRL_CLOCK_SKEW		0x0C00
+#define T1_MDIO_TX_TERNARY_SYM			0x0300
+#define T1_MDIO_PCS_SC_RESET			BIT(7)
+#define T1_MDIO_ENERGY_DETECT_M	BIT(6)
+#define T1_MDIO_IGNORE_IDLE			BIT(5)
+#define T1_MDIO_TIME_OUT_CNT			0x001E
+#define T1_MDIO_TIME_OUT_ENABLE		BIT(0)
+
+#define REG_PORT_T1_MODE_STAT			0x11
+#define T1_PORT_DSCR_LOCK_STATUS_MSK	BIT(3)
+#define T1_PORT_LINK_UP_MSK				BIT(0)
+
+#define REG_PORT_T1_LOOPBACK_CTRL	0x12
+
+#define REG_PORT_T1_RESET_CTRL		0x13
+
+#define T1_PHYADDR_S			11
+
+#define REG_PORT_T1_EXT_REG_CTRL	0x14
+
+#define T1_PCS_STS_CNT_RESET		BIT(15)
+#define T1_IND_DATA_READ		BIT(12)
+#define T1_IND_DATA_WRITE		BIT(11)
+#define T1_REG_BANK_SEL_M		0x7
+#define T1_REG_BANK_SEL_S		8
+#define T1_REG_BANK_SEL_INST		5
+#define T1_REG_BANK_SEL_DSP		4
+#define T1_REG_BANK_SEL_AFE		3
+#define T1_REG_BANK_SEL_PCS		2
+#define T1_REG_BANK_SEL_MISC		1
+#define T1_REG_ADDR_M			0xFF
+
+#define REG_PORT_T1_EXT_REG_RD_DATA	0x15
+#define REG_PORT_T1_EXT_REG_WR_DATA	0x16
+
+#define REG_PORT_T1_PCS_CTRL		0x17
+
+#define REG_PORT_T1_PHY_INT_STATUS	0x18
+#define REG_PORT_T1_PHY_INT_ENABLE	0x19
+
+#define T1_PHY_CTRL_MAXWAIT_TIMER_INT	BIT(8)
+#define T1_ZERO_TIMER_INT		BIT(7)
+#define T1_ENERGY_OFF_INT		BIT(6)
+#define T1_IDLE_ERR_THRESH_DET_INT	BIT(4)
+#define T1_LINK_UP_INT			BIT(2)
+#define T1_LINK_DOWN_INT		BIT(1)
+#define T1_ENERGY_ON_INT		BIT(0)
+
+#define REG_PORT_T1_POWER_DOWN_CTRL	0x1A
+
+#define T1_BIST_LINK_UP			BIT(15)
+#define T1_EMERGENCY_STOP		BIT(14)
+#define T1_PTP_ENABLE			BIT(13)
+#define T1_PCS_LINK_CTRL_ENABLE		BIT(12)
+#define T1_DSP_START_EQUALIZER		BIT(11)
+#define T1_START_ZQ_CAL			BIT(10)
+#define T1_FORCE_TX_ENABLE		BIT(9)
+#define T1_HW_INIT_SEQ_ENABLE		BIT(8)
+#define T1_WAKE_ENABLE			BIT(7)
+#define T1_LINK_UP_REQ			BIT(6)
+#define T1_AUTO_CLR_EPDWRDOWN		BIT(5)
+#define T1_ENERGY_DETECT_POWER_DOWN	BIT(4)
+#define T1_FORCE_ENERGY_DETECT		BIT(3)
+#define T1_AUTO_SLEEP_WAKEUP		BIT(2)
+#define T1_ENERGY_DETECT_HW_ENABLE	BIT(1)
+#define T1_ENERGY_DETECT_ENABLE		BIT(0)
+
+#define REG_PORT_T1_BIST_CTRL		0x1B
+#define REG_PORT_T1_BIST_STAT		0x1C
+#define REG_PORT_T1_BIST_ERR_CNT_STS	0x1D
+#define REG_PORT_T1_PCS_RX_ERR_CNT_STS	0x1E
+#define REG_PORT_T1_TS_CTRL_STAT	0x1F
+
+#define REG_PORT_T1_PCS_DESCRM_CTRL_0	0x00
+
+#define T1_PCS_SEND_IDLE_LOC_RCV_STS	BIT(15)
+#define T1_PCS_DESCR_RELOCK_ON_IDLE	BIT(14)
+#define T1_PCS_DESCR_RELOCK_ON_RCV	BIT(13)
+#define T1_PCS_DESCR_RELOCK_ON_EQ	BIT(12)
+#define T1_PCS_DESCR_LOCK_SYM_CNT	0x0FC0
+#define T1_PCS_DESCR_LOCK_CHK_WIN	0x003F
+
+#define REG_PORT_T1_PCS_DESCRM_CTRL_1	0x01
+
+#define T1_PCS_DESCR_PIPE_DELAY		0x0700
+#define T1_PCS_FEED_DESCR_LFSR_WIN	0x003F
+
+#define REG_PORT_T1_PCS_EQ_TIMER_CTRL	0x02
+
+#define REG_PORT_T1_PCS_RX_ERR_CNT	0x0E
+
+#define REG_PORT_T1_PCS_ED_STABILITY	0x26
+
+#define REG_PORT_TX_PHY_CTRL		0x00
+#define REG_PORT_TX_PHY_STATUS		0x01
+#define REG_PORT_TX_PHY_ID_HI		0x02
+#define REG_PORT_TX_PHY_ID_LO		0x03
+#define REG_PORT_TX_PHY_AUTO_NEG	0x04
+#define REG_PORT_TX_PHY_REMOTE_CAP	0x05
+
+#define REG_PORT_TX_6			0x06
+#define REG_PORT_TX_7			0x07
+#define REG_PORT_TX_10			0x10
+#define REG_PORT_TX_11			0x11
+
+#define REG_PORT_TX_SPECIAL_MODES	0x12
+
+#define TX_SPECIAL_CFG_M		0x7
+#define TX_SPECIAL_CFG_S		5
+#define TX_PHYADDR_M			0x1F
+
+#define REG_PORT_TX_13			0x13
+
+#define REG_PORT_TX_IND_CTRL		0x14
+
+#define TX_IND_DATA_READ		BIT(15)
+#define TX_IND_DATA_WRITE		BIT(14)
+#define TX_REG_BANK_SEL_M		0x7
+#define TX_REG_BANK_SEL_S		11
+#define TX_REG_BANK_SEL_VMDAC		7
+#define TX_REG_BANK_SEL_BIST		3
+#define TX_REG_BANK_SEL_WOL		1
+#define TX_REG_BANK_SEL_DSP		0
+#define TX_TEST_MODE			BIT(10)
+#define TX_READ_ADDR_M			0x1F
+#define TX_READ_ADDR_S			5
+#define TX_WRITE_ADDR_M			0x1F
+
+#define REG_PORT_TX_READ_DATA_LO	0x15
+#define REG_PORT_TX_READ_DATA_HI	0x16
+#define REG_PORT_TX_WRITE_DATA		0x17
+
+#define REG_PORT_TX_PHY_INT_STATUS	0x1D
+#define REG_PORT_TX_PHY_INT_ENABLE	0x1E
+
+#define TX_ENERGY_ON_INT		BIT(7)
+#define TX_AUTO_NEG_COMPLETE_INT	BIT(6)
+#define TX_LINK_DOWN_INT		BIT(4)
+#define TX_AUTO_NEG_ACK_INT		BIT(3)
+#define TX_AUTO_NEG_PAGE_RCV_INT	BIT(1)
+
+#define REG_PORT_TX_1F			0x1F
+
+#define TX_DSP_DCBLW			0x00
+
+#define TX_DSP_DCBLW_VAL		0x9aa2
+
+#define TX_DSP_A5_CONFIG		0x16
+
+#define TX_A5_TXCLKPHSEL_M		0x7
+#define TX_A5_TXCLKPHSEL_S		12
+#define TX_A5_TXCLK_0_NS		0
+#define TX_A5_TXCLK_1_NS		1
+#define TX_A5_TXCLK_2_NS		2
+#define TX_A5_TXCLK_3_NS		3
+#define TX_A5_TXCLK_4_NS		4
+#define TX_A5_TXCLK_5_NS		5
+#define TX_A5_TXCLK_6_NS		6
+#define TX_A5_TXCLK_7_NS		7
+
+#define TX_DSP_A10_CONFIG		0x1C
+
+#define TX_DSP_A10_CONFIG_VAL		0x9000
+
+#define TX_DSP_A11_CONFIG		0x1D
+
+#define TX_DSP_A11_CONFIG_VAL		0x7600
+
+#define TX_BIST_FR_PLL_DIV0		0x1C
+#define TX_BIST_FR_PLL_DIV1		0x1D
+
+#define TX_FR_PLL_DIV0			0x0
+#define TX_FR_PLL_DIV1			0x1280
+
+#define TX_VMDAC_ZQ_CAL_CTRL		0x00
+
+#define TX_START_ZQ_CAL			BIT(0)
+#define TX_BYPASS_ZQ_CAL		BIT(1)
+
+#define TX_VMDAC_ZQ_CAL_STAT		0x01
+
+#define TX_VMDAC_CTRL0			0x02
+#define TX_VDVREF_EN			BIT(0)
+#define TX_VDVEXT_EN			BIT(1)
+#define TX_A_ZEN			BIT(11)
+#define TX_A_RXZEN			BIT(12)
+#define TX_VD_INTIR_EN			BIT(15)
+
+#define TX_VMDAC_CTRL0_VAL		0x9783
+#define TX_VMDAC_CTRL1			0x03
+
+#define TX_10BT_VD_EN			BIT(0)
+#define TX_B_ZEN			BIT(11)
+#define TX_B_RXZEN			BIT(12)
+#define TX_VD_PD			BIT(15)
+
+#define TX_VMDAC_CTRL1_VAL		0x7784
+#define TX_VMDAC_MISC_PCS_CTRL0		0x05
+
+#define TX_MISC_PCS_CTRL0_13		BIT(13)
+#define TX_VMDAC_MISC_PCS_CTRL1		0x06
+
+#define REG_PORT_T1_PHY_CTRL_BASE	0x0100
+#define REG_PORT_TX_PHY_CTRL_BASE	0x0280
+#define REG_TX_PHY_CTRL_BASE		0x0980
+
+#define REG_PORT_PHY_CTRL		0x0100
+
+#define PORT_PHY_RESET			BIT(15)
+#define PORT_PHY_LOOPBACK		BIT(14)
+#define PORT_SPEED_100MBIT		BIT(13)
+#define PORT_AUTO_NEG_ENABLE		BIT(12)
+#define PORT_POWER_DOWN			BIT(11)
+#define PORT_ISOLATE			BIT(10)
+#define PORT_AUTO_NEG_RESTART		BIT(9)
+#define PORT_FULL_DUPLEX		BIT(8)
+#define PORT_COLLISION_TEST		BIT(7)
+#define PORT_SPEED_1000MBIT		BIT(6)
+
+#define REG_PORT_PHY_STATUS		0x0102
+
+#define PORT_100BT4_CAPABLE		BIT(15)
+#define PORT_100BTX_FD_CAPABLE		BIT(14)
+#define PORT_100BTX_CAPABLE		BIT(13)
+#define PORT_10BT_FD_CAPABLE		BIT(12)
+#define PORT_10BT_CAPABLE		BIT(11)
+#define PORT_EXTENDED_STATUS		BIT(8)
+#define PORT_MII_SUPPRESS_CAPABLE	BIT(6)
+#define PORT_AUTO_NEG_ACKNOWLEDGE	BIT(5)
+#define PORT_REMOTE_FAULT		BIT(4)
+#define PORT_AUTO_NEG_CAPABLE		BIT(3)
+#define PORT_LINK_STATUS		BIT(2)
+#define PORT_JABBER_DETECT		BIT(1)
+#define PORT_EXTENDED_CAPABILITY	BIT(0)
+
+#define REG_PORT_PHY_ID_HI		0x0104
+#define REG_PORT_PHY_ID_LO		0x0106
+
+#define LAN937X_ID_HI			0x0007
+#define LAN937X_ID_LO			0x1951
+
+#define REG_PORT_PHY_1000_CTRL		0x0112
+#define PORT_AUTO_NEG_MANUAL			BIT(12)
+#define PORT_AUTO_NEG_M		BIT(11)
+#define PORT_AUTO_NEG_M_PREFERRED	BIT(10)
+#define PORT_AUTO_NEG_1000BT_FD		BIT(9)
+#define PORT_AUTO_NEG_1000BT			BIT(8)
+
+#define REG_PORT_PHY_1000_STATUS	0x0114
+
+#define REG_PORT_PHY_RXER_COUNTER	0x012A
+#define REG_PORT_PHY_INT_ENABLE		0x0136
+#define REG_PORT_PHY_INT_STATUS		0x0137
+
+/* Same as PORT_PHY_LOOPBACK */
+#define PORT_PHY_PCS_LOOPBACK		BIT(0)
+
+#define REG_PORT_PHY_DIGITAL_DEBUG_2	0x013A
+
+#define REG_PORT_PHY_DIGITAL_DEBUG_3	0x013C
+#define PORT_100BT_FIXED_LATENCY	BIT(15)
+
+#define REG_PORT_PHY_PHY_CTRL		0x013E
+#define PORT_INT_PIN_HIGH		BIT(14)
+#define PORT_ENABLE_JABBER		BIT(9)
+#define PORT_STAT_SPEED_1000MBIT	BIT(6)
+#define PORT_STAT_SPEED_100MBIT		BIT(5)
+#define PORT_STAT_SPEED_10MBIT		BIT(4)
+#define PORT_STAT_FULL_DUPLEX		BIT(3)
+
+/* Same as PORT_PHY_STAT_M */
+#define PORT_STAT_M		BIT(2)
+#define PORT_RESET			BIT(1)
+#define PORT_LINK_STATUS_FAIL		BIT(0)
+
+/* 3 - xMII */
+#define REG_PORT_XMII_CTRL_0		0x0300
+#define PORT_SGMII_SEL			BIT(7)
+#define PORT_MII_FULL_DUPLEX		BIT(6)
+#define PORT_MII_TX_FLOW_CTRL		BIT(5)
+#define PORT_MII_100MBIT		BIT(4)
+#define PORT_MII_RX_FLOW_CTRL		BIT(3)
+#define PORT_GRXC_ENABLE		BIT(0)
+
+#define REG_PORT_XMII_CTRL_1		0x0301
+#define PORT_MII_NOT_1GBIT		BIT(6)
+#define PORT_MII_SEL_EDGE		BIT(5)
+#define PORT_RGMII_ID_IG_ENABLE		BIT(4)
+#define PORT_RGMII_ID_EG_ENABLE		BIT(3)
+#define PORT_MII_MAC_MODE		BIT(2)
+#define PORT_MII_SEL_M			0x3
+#define PORT_RGMII_SEL			0x0
+#define PORT_RMII_SEL			0x1
+#define PORT_MII_SEL			0x2
+
+#define REG_PORT_XMII_CTRL_2		0x0302
+#define PORT_RGMII_RX_STS_ENABLE	BIT(0)
+
+#define REG_PORT_XMII_CTRL_4		0x0304
+#define REG_PORT_XMII_CTRL_5		0x0305
+
+/* 4 - MAC */
+#define REG_PORT_MAC_CTRL_0		0x0400
+#define PORT_CHECK_LENGTH		BIT(2)
+#define PORT_BROADCAST_STORM		BIT(1)
+#define PORT_JUMBO_PACKET		BIT(0)
+
+#define REG_PORT_MAC_CTRL_1		0x0401
+#define PORT_BACK_PRESSURE		BIT(3)
+#define PORT_PASS_ALL			BIT(0)
+
+#define REG_PORT_MAC_CTRL_2		0x0402
+#define PORT_100BT_EEE_DISABLE		BIT(7)
+#define PORT_1000BT_EEE_DISABLE		BIT(6)
+
+#define REG_PORT_MAC_IN_RATE_LIMIT	0x0403
+
+#define REG_PORT_MTU__2			0x0404
+#define PORT_RATE_LIMIT_M		(BIT(7) - 1)
+
+/* 5 - MIB Counters */
+#define REG_PORT_MIB_CTRL_STAT__4	0x0500
+#define MIB_COUNTER_OVERFLOW		BIT(31)
+#define MIB_COUNTER_VALID		BIT(30)
+#define MIB_COUNTER_READ		BIT(25)
+#define MIB_COUNTER_FLUSH_FREEZE	BIT(24)
+#define MIB_COUNTER_INDEX_M		(BIT(8) - 1)
+#define MIB_COUNTER_INDEX_S		16
+#define MIB_COUNTER_DATA_HI_M		0xF
+
+#define REG_PORT_MIB_DATA		0x0504
+
+/* 8 - Classification and Policing */
+#define REG_PORT_MRI_MIRROR_CTRL	0x0800
+#define PORT_MIRROR_RX			BIT(6)
+#define PORT_MIRROR_TX			BIT(5)
+#define PORT_MIRROR_SNIFFER		BIT(1)
+
+#define REG_PORT_MRI_PRIO_CTRL		0x0801
+#define PORT_HIGHEST_PRIO		BIT(7)
+#define PORT_OR_PRIO			BIT(6)
+#define PORT_MAC_PRIO_ENABLE		BIT(4)
+#define PORT_VLAN_PRIO_ENABLE		BIT(3)
+#define PORT_802_1P_PRIO_ENABLE		BIT(2)
+#define PORT_DIFFSERV_PRIO_ENABLE	BIT(1)
+#define PORT_ACL_PRIO_ENABLE		BIT(0)
+
+#define REG_PORT_MRI_MAC_CTRL		0x0802
+#define PORT_USER_PRIO_CEILING		BIT(7)
+#define PORT_DROP_NON_VLAN		BIT(4)
+#define PORT_DROP_TAG			BIT(3)
+#define PORT_BASED_PRIO_M		KS_PRIO_M
+#define PORT_BASED_PRIO_S		0
+
+#define REG_PORT_MRI_TC_MAP__4		0x0808
+
+/* 9 - Shaping */
+#define REG_PORT_MTI_QUEUE_INDEX__4	0x0900
+
+#define REG_PORT_MTI_QUEUE_CTRL_0__4	0x0904
+#define MTI_PVID_REPLACE		BIT(0)
+
+#define REG_PORT_MTI_QUEUE_CTRL_0	0x0914
+
+/* A - QM */
+#define REG_PORT_QM_CTRL__4		0x0A00
+#define PORT_QM_DROP_PRIO_M		0x3
+
+#define REG_PORT_VLAN_MEMBERSHIP__4	0x0A04
+
+#define REG_PORT_QM_QUEUE_INDEX__4	0x0A08
+#define PORT_QM_QUEUE_INDEX_S		24
+#define PORT_QM_BURST_SIZE_S		16
+#define PORT_QM_MIN_RESV_SPACE_M	(BIT(11) - 1)
+
+#define REG_PORT_QM_WATER_MARK__4	0x0A0C
+#define PORT_QM_HI_WATER_MARK_S		16
+#define PORT_QM_LO_WATER_MARK_S		0
+#define PORT_QM_WATER_MARK_M		(BIT(11) - 1)
+
+#define REG_PORT_QM_TX_CNT_0__4		0x0A10
+#define PORT_QM_TX_CNT_USED_S		0
+#define PORT_QM_TX_CNT_M		(BIT(11) - 1)
+
+#define REG_PORT_QM_TX_CNT_1__4		0x0A14
+#define PORT_QM_TX_CNT_CALCULATED_S	16
+#define PORT_QM_TX_CNT_AVAIL_S		0
+
+/* B - LUE */
+#define REG_PORT_LUE_CTRL		0x0B00
+
+#define PORT_VLAN_LOOKUP_VID_0		BIT(7)
+#define PORT_INGRESS_FILTER		BIT(6)
+#define PORT_DISCARD_NON_VID		BIT(5)
+#define PORT_MAC_BASED_802_1X		BIT(4)
+#define PORT_SRC_ADDR_FILTER		BIT(3)
+
+#define REG_PORT_LUE_MSTP_INDEX		0x0B01
+
+#define REG_PORT_LUE_MSTP_STATE		0x0B04
+
+#define PORT_TX_ENABLE			BIT(2)
+#define PORT_RX_ENABLE			BIT(1)
+#define PORT_LEARN_DISABLE		BIT(0)
+
+#define REG_PORT_LUE_LEARN_CNT__2	0x0B08
+
+#define REG_PORT_LUE_UNK_UCAST_CTRL__2	0x0B0E
+#define REG_PORT_LUE_UNK_MCAST_CTRL__2	0x0B10
+#define REG_PORT_LUE_UNK_VID_CTRL__2	0x0B12
+
+#define PORT_UNK_UCAST_ENABLE		BIT(15)
+#define PORT_UNK_MCAST_ENABLE		BIT(15)
+#define PORT_UNK_VID_ENABLE		BIT(15)
+
+#define PRIO_QUEUES			8
+#define RX_PRIO_QUEUES			8
+#define KS_PRIO_IN_REG			2
+#define TOTAL_PORT_NUM			8
+
+#define LAN937X_COUNTER_NUM		0x20
+#define TOTAL_LAN937X_COUNTER_NUM	(LAN937X_COUNTER_NUM + 2 + 2)
+
+#define SWITCH_COUNTER_NUM		LAN937X_COUNTER_NUM
+
+#define P_BCAST_STORM_CTRL		REG_PORT_MAC_CTRL_0
+#define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
+#define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
+#define P_STP_CTRL			REG_PORT_LUE_MSTP_STATE
+#define P_PHY_CTRL			REG_PORT_PHY_CTRL
+#define P_NEG_RESTART_CTRL		REG_PORT_PHY_CTRL
+#define P_LINK_STATUS			REG_PORT_PHY_STATUS
+#define P_SPEED_STATUS			REG_PORT_PHY_PHY_CTRL
+#define P_RATE_LIMIT_CTRL		REG_PORT_MAC_IN_RATE_LIMIT
+
+#define S_LINK_AGING_CTRL		REG_SW_LUE_CTRL_1
+#define S_MIRROR_CTRL			REG_SW_MRI_CTRL_0
+#define S_REPLACE_VID_CTRL		REG_SW_MAC_CTRL_2
+#define S_802_1P_PRIO_CTRL		REG_SW_MAC_802_1P_MAP_0
+#define S_TOS_PRIO_CTRL			REG_SW_MAC_TOS_PRIO_0
+#define S_FLUSH_TABLE_CTRL		REG_SW_LUE_CTRL_1
+
+#define REG_SWITCH_RESET		REG_RESET_CTRL
+
+#define SW_FLUSH_DYN_MAC_TABLE		SW_FLUSH_MSTP_TABLE
+
+#define MAX_TIMESTAMP_UNIT		2
+#define MAX_TRIG_UNIT			3
+#define MAX_TIMESTAMP_EVENT_UNIT	8
+#define MAX_GPIO			2
+#define MAX_CLOCK			2
+
+#define PTP_TRIG_UNIT_M			(BIT(MAX_TRIG_UNIT) - 1)
+#define PTP_TS_UNIT_M			(BIT(MAX_TIMESTAMP_UNIT) - 1)
+
+#define TAIL_TAG_PTP			BIT(7)
+#define TAIL_TAG_NEXT_CHIP		BIT(6)
+#define TAIL_TAG_K2L			BIT(5)
+#define TAIL_TAG_PTP_1_STEP		BIT(4)
+#define TAIL_TAG_PTP_P2P		BIT(3)
+#define TAIL_TAG_RX_PORTS_M		0x7
+
+/* 148,800 frames * 67 ms / 100 */
+#define BROADCAST_STORM_VALUE		9969
+
+#define SW_CHECK_LENGTH			BIT(3)
+
+#define FR_MIN_SIZE		1522
+#define FR_MAX_SIZE		9000
+
+#define PORT_JUMBO_EN			BIT(0)
+#define PORT_FR_CHK_LENGTH		BIT(2)
+#define PORT_MAX_FR_SIZE		0x404
+
+#define FR_SIZE_CPU_PORT		1540
+
+#define REG_PORT_CTRL_0				0x0020
+#define PORT_MAC_LOOPBACK			BIT(7)
+#define PORT_FORCE_TX_FLOW_CTRL		BIT(5)
+#define PORT_FORCE_RX_FLOW_CTRL		BIT(3)
+
+#define PORT_QUEUE_SPLIT_ENABLE		0x3
+
+/* Get fid from vid, fid 0 is not used if vid is greater than 127 */
+#define LAN937X_GET_FID(vid)	(((vid) % ALU_FID_SIZE) + 1)
+
+/* Driver set switch broadcast storm protection at 10% rate. */
+#define BROADCAST_STORM_PROT_RATE	10
+
+#define MII_BMSR_100BASE_TX_FD		BIT(14)
+
+#define PHY_LINK_UP					1
+#define PHY_LINK_DOWN				0
+
+/*The port number as per the datasheet*/
+#define RGMII_2_PORT_NUM		5
+#define RGMII_1_PORT_NUM		6
+#define SGMII_PORT_NUM			4
+#define TXPHY_PORT_NUM			4
+
+#define GET_CHIP_ID_LSB(chip_id)	(((chip_id) >> 8) & 0xff)
+#define LAN937X_RGMII_2_PORT		(RGMII_2_PORT_NUM - 1)
+#define LAN937X_RGMII_1_PORT		(RGMII_1_PORT_NUM - 1)
+#define LAN937X_SGMII_PORT			(SGMII_PORT_NUM - 1)
+#define LAN937X_TXPHY_PORT			(TXPHY_PORT_NUM - 1)
+
+#endif
diff --git a/drivers/net/dsa/microchip/lan937x_spi.c b/drivers/net/dsa/microchip/lan937x_spi.c
new file mode 100644
index 000000000000..20ee931c448d
--- /dev/null
+++ b/drivers/net/dsa/microchip/lan937x_spi.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Microchip LAN937X switch driver register access through SPI
+ * Copyright (C) 2019-2020 Microchip Technology Inc.
+ */
+#include <asm/unaligned.h>
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+
+#include "ksz_common.h"
+
+#define SPI_ADDR_SHIFT				24
+#define SPI_ADDR_ALIGN				3
+#define SPI_TURNAROUND_SHIFT		5
+
+KSZ_REGMAP_TABLE(lan937x, 32, SPI_ADDR_SHIFT,
+		 SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
+
+static int lan937x_spi_probe(struct spi_device *spi)
+{
+	struct regmap_config rc;
+	struct ksz_device *dev;
+	int i, ret;
+
+	dev = ksz_switch_alloc(&spi->dev, spi);
+	if (!dev)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(lan937x_regmap_config); i++) {
+		rc = lan937x_regmap_config[i];
+		rc.lock_arg = &dev->regmap_mutex;
+		dev->regmap[i] = devm_regmap_init_spi(spi, &rc);
+		if (IS_ERR(dev->regmap[i])) {
+			ret = PTR_ERR(dev->regmap[i]);
+			dev_err(&spi->dev,
+				"Failed to initialize regmap%i: %d\n",
+				lan937x_regmap_config[i].val_bits, ret);
+			return ret;
+		}
+	}
+
+	if (spi->dev.platform_data)
+		dev->pdata = spi->dev.platform_data;
+
+	ret = lan937x_switch_register(dev);
+
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	spi_set_drvdata(spi, dev);
+
+	return 0;
+}
+
+static int lan937x_spi_remove(struct spi_device *spi)
+{
+	struct ksz_device *dev = spi_get_drvdata(spi);
+
+	if (dev)
+		ksz_switch_remove(dev);
+
+	return 0;
+}
+
+static void lan937x_spi_shutdown(struct spi_device *spi)
+{
+	struct ksz_device *dev = spi_get_drvdata(spi);
+
+	if (dev && dev->dev_ops->shutdown)
+		dev->dev_ops->shutdown(dev);
+}
+
+static const struct of_device_id lan937x_dt_ids[] = {
+	{ .compatible = "microchip,lan9370"},
+	{ .compatible = "microchip,lan9371"},
+	{ .compatible = "microchip,lan9372"},
+	{ .compatible = "microchip,lan9373"},
+	{ .compatible = "microchip,lan9374"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, lan937x_dt_ids);
+
+static struct spi_driver lan937x_spi_driver = {
+	.driver = {
+		.name	= "lan937x-switch",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(lan937x_dt_ids),
+	},
+	.probe	= lan937x_spi_probe,
+	.remove	= lan937x_spi_remove,
+	.shutdown = lan937x_spi_shutdown,
+};
+
+module_spi_driver(lan937x_spi_driver);
+
+MODULE_ALIAS("spi:lan937x");
+
+MODULE_AUTHOR("Prasanna Vengateshan Varadharajan <Prasanna.Vengateshan@microchip.com>");
+MODULE_DESCRIPTION("Microchip LAN937x Series Switch SPI access Driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

