Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2665B411244
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbhITJxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:44 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:11429 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbhITJxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131502; x=1663667502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ceHtQV4wksUjkp+UF2+oQrI1Yiac9ttanC9sGh+HWew=;
  b=wHKhbsXLtDEEP+YhuDtwMriAJYyaxzfCGC7P0zfFVA9C26JzR9x99IDX
   ia/KBjbsKuIeaXgG+1ffrwRmcAPvEp65EIaawrE9mAsDP1EQebBM4ts5z
   T9nkanCF0K9xl0IuggoiDj+HscbfQ6jyNyi16BFjBH9k3UXnfV7FC5ptW
   I55QIdW0Mrwjq51QHVWXeB2ABYWIXfnsUKUUHx2HuCOfItIewRTHLE3Xn
   lBy/cuRJ6uT9hnxdOWwk4V3hMjl4nJiTx5myttjCC7cYP+OhHqEmPLUKW
   TDuWddCcSAjTs7HjiifuuzEVNTxFIMCqtLb9rWsdNw2GHixhi90mfA3Op
   g==;
IronPort-SDR: K4mGDpYI/y+3WD+q/c4pjFb6bCoKk4/mIMSVFHFpF6sFX8v4iXUAw+M6t7+dX9f2WfXyD/Wb02
 M/q3wmk0KmMtyv2rUR5uKfLQsmiJmNvgID80tTIOkfoWQBWSL2XFePVI8mGiMsIDDHZBizihj1
 8yQrYzjZAMkpm7Z4Ab1q4PPowobIYwyZYU5eCcKRrr2meQOdIy9SX21G9hLDCEBOMu/3OE54fR
 FBn4PBS5NE9Hko3WQ1cGR0tTfBwPumEs4NaXkyFddw9SH8QI4WHViA7TMiuUMeZlfCPSpLZLJi
 miAaDmv2Xn4yi0NogHjO4k7Y
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="137192406"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:38 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 09/12] net: lan966x: add the basic lan966x driver
Date:   Mon, 20 Sep 2021 11:52:15 +0200
Message-ID: <20210920095218.1108151-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic SwitchDev driver framework for lan966x. It
includes only the IO range mapping and probing of the switch.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   7 +
 .../net/ethernet/microchip/lan966x/Makefile   |   8 +
 .../ethernet/microchip/lan966x/lan966x_main.c | 350 +++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 105 +++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 704 ++++++++++++++++++
 7 files changed, 1176 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Makefile
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_regs.h

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 735eea1dacf1..ed7a35c3ceac 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -55,6 +55,7 @@ config LAN743X
 	  To compile this driver as a module, choose M here. The module will be
 	  called lan743x.
 
+source "drivers/net/ethernet/microchip/lan966x/Kconfig"
 source "drivers/net/ethernet/microchip/sparx5/Kconfig"
 
 endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/Makefile b/drivers/net/ethernet/microchip/Makefile
index c77dc0379bfd..9faa41436198 100644
--- a/drivers/net/ethernet/microchip/Makefile
+++ b/drivers/net/ethernet/microchip/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_LAN743X) += lan743x.o
 
 lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o
 
+obj-$(CONFIG_LAN966X_SWITCH) += lan966x/
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5/
diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
new file mode 100644
index 000000000000..83ac4266b417
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -0,0 +1,7 @@
+config LAN966X_SWITCH
+	tristate "Lan966x switch driver"
+	depends on HAS_IOMEM
+	depends on OF
+	select PHYLINK
+	help
+	  This driver supports the Lan966x network switch device.
diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
new file mode 100644
index 000000000000..7ea90410a0b2
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Microchip Lan966x network device drivers.
+#
+
+obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
+
+lan966x-switch-objs  := lan966x_main.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
new file mode 100644
index 000000000000..2984f510ae27
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -0,0 +1,350 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <asm/memory.h>
+#include <linux/module.h>
+#include <linux/if_bridge.h>
+#include <linux/iopoll.h>
+#include <linux/of_platform.h>
+#include <linux/of_net.h>
+#include <linux/reset.h>
+
+#include "lan966x_main.h"
+
+#define READL_SLEEP_US			10
+#define READL_TIMEOUT_US		100000000
+
+#define IO_RANGES 2
+
+static const struct of_device_id lan966x_match[] = {
+	{ .compatible = "microchip,lan966x-switch" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, mchp_lan966x_match);
+
+struct lan966x_main_io_resource {
+	enum lan966x_target id;
+	phys_addr_t offset;
+	int range;
+};
+
+static const struct lan966x_main_io_resource lan966x_main_iomap[] =  {
+	{ TARGET_CPU,                   0xc0000, 0 }, /* 0xe00c0000 */
+	{ TARGET_ORG,                         0, 1 }, /* 0xe2000000 */
+	{ TARGET_GCB,                    0x4000, 1 }, /* 0xe2004000 */
+	{ TARGET_QS,                     0x8000, 1 }, /* 0xe2008000 */
+	{ TARGET_CHIP_TOP,              0x10000, 1 }, /* 0xe2010000 */
+	{ TARGET_REW,                   0x14000, 1 }, /* 0xe2014000 */
+	{ TARGET_SYS,                   0x28000, 1 }, /* 0xe2028000 */
+	{ TARGET_HSIO,                  0x2c000, 1 }, /* 0xe202c000 */
+	{ TARGET_DEV,                   0x34000, 1 }, /* 0xe2034000 */
+	{ TARGET_DEV +  1,              0x38000, 1 }, /* 0xe2038000 */
+	{ TARGET_DEV +  2,              0x3c000, 1 }, /* 0xe203c000 */
+	{ TARGET_DEV +  3,              0x40000, 1 }, /* 0xe2040000 */
+	{ TARGET_DEV +  4,              0x44000, 1 }, /* 0xe2044000 */
+	{ TARGET_DEV +  5,              0x48000, 1 }, /* 0xe2048000 */
+	{ TARGET_DEV +  6,              0x4c000, 1 }, /* 0xe204c000 */
+	{ TARGET_DEV +  7,              0x50000, 1 }, /* 0xe2050000 */
+	{ TARGET_QSYS,                 0x100000, 1 }, /* 0xe2100000 */
+	{ TARGET_AFI,                  0x120000, 1 }, /* 0xe2120000 */
+	{ TARGET_ANA,                  0x140000, 1 }, /* 0xe2140000 */
+};
+
+static int lan966x_create_targets(struct platform_device *pdev,
+				  struct lan966x *lan966x)
+{
+	struct resource *iores[IO_RANGES];
+	void __iomem *iomem[IO_RANGES];
+	void __iomem *begin[IO_RANGES];
+	int idx;
+
+	for (idx = 0; idx < IO_RANGES; idx++) {
+		iores[idx] = platform_get_resource(pdev, IORESOURCE_MEM,
+						   idx);
+		iomem[idx] = devm_ioremap(&pdev->dev,
+					  iores[idx]->start,
+					  resource_size(iores[idx]));
+		if (IS_ERR(iomem[idx])) {
+			dev_err(&pdev->dev, "Unable to get registers: %s\n",
+				iores[idx]->name);
+			return PTR_ERR(iomem[idx]);
+		}
+
+		begin[idx] = iomem[idx];
+	}
+
+	for (idx = 0; idx < ARRAY_SIZE(lan966x_main_iomap); idx++) {
+		const struct lan966x_main_io_resource *iomap =
+			&lan966x_main_iomap[idx];
+
+		lan966x->regs[iomap->id] = begin[iomap->range] + iomap->offset;
+	}
+
+	return 0;
+}
+
+static int lan966x_probe_port(struct lan966x *lan966x, u8 port,
+			      phy_interface_t phy_mode)
+{
+	struct lan966x_port *lan966x_port;
+
+	if (port >= lan966x->num_phys_ports)
+		return -EINVAL;
+
+	lan966x_port = devm_kzalloc(lan966x->dev, sizeof(*lan966x_port),
+				    GFP_KERNEL);
+
+	lan966x_port->lan966x = lan966x;
+	lan966x_port->chip_port = port;
+	lan966x_port->pvid = PORT_PVID;
+	lan966x->ports[port] = lan966x_port;
+
+	return 0;
+}
+
+static void lan966x_init(struct lan966x *lan966x)
+{
+	u32 port, i;
+
+	/* Flush queues */
+	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
+	       GENMASK(1, 0),
+	       lan966x, QS_XTR_FLUSH);
+
+	/* Allow to drain */
+	mdelay(1);
+
+	/* All Queues normal */
+	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) &
+	       ~(GENMASK(1, 0)),
+	       lan966x, QS_XTR_FLUSH);
+
+	/* Set MAC age time to default value, the entry is aged after
+	 * 2 * AGE_PERIOD
+	 */
+	lan_wr(ANA_AUTOAGE_AGE_PERIOD_SET(BR_DEFAULT_AGEING_TIME / 2 / HZ),
+	       lan966x, ANA_AUTOAGE);
+
+	/* Disable learning for frames discarded by VLAN ingress filtering */
+	lan_rmw(ANA_ADVLEARN_VLAN_CHK_SET(1),
+		ANA_ADVLEARN_VLAN_CHK,
+		lan966x, ANA_ADVLEARN);
+
+	/* Setup frame ageing - "2 sec" - The unit is 6.5 us on lan966x */
+	lan_wr(SYS_FRM_AGING_AGE_TX_ENA_SET(1) |
+	       (20000000 / 65),
+	       lan966x,  SYS_FRM_AGING);
+
+	/* Map the 8 CPU extraction queues to CPU port */
+	lan_wr(0, lan966x, QSYS_CPU_GROUP_MAP);
+
+	/* Do byte-swap and expect status after last data word
+	 * Extraction: Mode: manual extraction) | Byte_swap
+	 */
+	lan_wr(QS_XTR_GRP_CFG_MODE_SET(1) |
+	       QS_XTR_GRP_CFG_BYTE_SWAP_SET(1),
+	       lan966x, QS_XTR_GRP_CFG(0));
+
+	/* Injection: Mode: manual injection | Byte_swap */
+	lan_wr(QS_INJ_GRP_CFG_MODE_SET(1) |
+	       QS_INJ_GRP_CFG_BYTE_SWAP_SET(1),
+	       lan966x, QS_INJ_GRP_CFG(0));
+
+	lan_rmw(QS_INJ_CTRL_GAP_SIZE_SET(0),
+		QS_INJ_CTRL_GAP_SIZE,
+		lan966x, QS_INJ_CTRL(0));
+
+	/* Enable IFH insertion/parsing on CPU ports */
+	lan_wr(SYS_PORT_MODE_INCL_INJ_HDR_SET(1) |
+	       SYS_PORT_MODE_INCL_XTR_HDR_SET(1),
+	       lan966x, SYS_PORT_MODE(CPU_PORT));
+
+	/* Setup flooding PGIDs */
+	lan_wr(ANA_FLOODING_IPMC_FLD_MC4_DATA_SET(PGID_MCIPV4) |
+	       ANA_FLOODING_IPMC_FLD_MC4_CTRL_SET(PGID_MC) |
+	       ANA_FLOODING_IPMC_FLD_MC6_DATA_SET(PGID_MC) |
+	       ANA_FLOODING_IPMC_FLD_MC6_CTRL_SET(PGID_MC),
+	       lan966x, ANA_FLOODING_IPMC);
+
+	/* There are 8 priorities */
+	for (i = 0; i < 8; ++i)
+		lan_rmw(ANA_FLOODING_FLD_MULTICAST_SET(PGID_MC) |
+			ANA_FLOODING_FLD_BROADCAST_SET(PGID_BC),
+			ANA_FLOODING_FLD_MULTICAST |
+			ANA_FLOODING_FLD_BROADCAST,
+			lan966x, ANA_FLOODING(i));
+
+	for (i = 0; i < PGID_ENTRIES; ++i)
+		/* Set all the entries to obey VLAN_VLAN */
+		lan_rmw(ANA_PGID_CFG_OBEY_VLAN_SET(1),
+			ANA_PGID_CFG_OBEY_VLAN,
+			lan966x, ANA_PGID_CFG(i));
+
+	for (port = 0; port < lan966x->num_phys_ports; port++) {
+		/* Disable bridging by default */
+		lan_rmw(ANA_PGID_PGID_SET(0x0),
+			ANA_PGID_PGID,
+			lan966x, ANA_PGID(port + PGID_SRC));
+
+		/* Do not forward BPDU frames to the front ports and copy them
+		 * to CPU
+		 */
+		lan_wr(0xffff, lan966x, ANA_CPU_FWD_BPDU_CFG(port));
+	}
+
+	/* Set source buffer size for each priority and each port to 1500 bytes */
+	for (i = 0; i <= QSYS_Q_RSRV; ++i) {
+		lan_wr(1500 / 64, lan966x, QSYS_RES_CFG(i));
+		lan_wr(1500 / 64, lan966x, QSYS_RES_CFG(512 + i));
+	}
+
+	/* Enable switching to/from cpu port */
+	lan_wr(QSYS_SW_PORT_MODE_PORT_ENA_SET(1) |
+	       QSYS_SW_PORT_MODE_SCH_NEXT_CFG_SET(1) |
+	       QSYS_SW_PORT_MODE_INGRESS_DROP_MODE_SET(1),
+	       lan966x,  QSYS_SW_PORT_MODE(CPU_PORT));
+
+	/* Configure and enable the CPU port */
+	lan_rmw(ANA_PGID_PGID_SET(0),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(CPU_PORT));
+	lan_rmw(ANA_PGID_PGID_SET(BIT(CPU_PORT)),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(PGID_CPU));
+
+	/* Multicast to all other ports */
+	lan_rmw(GENMASK(lan966x->num_phys_ports - 1, 0),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(PGID_MC));
+
+	/* This will be controlled by mrouter ports */
+	lan_rmw(GENMASK(lan966x->num_phys_ports - 1, 0),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(PGID_MCIPV4));
+
+	/* Broadcast to the CPU port and to other ports */
+	lan_rmw(ANA_PGID_PGID_SET(BIT(CPU_PORT) | GENMASK(lan966x->num_phys_ports - 1, 0)),
+		ANA_PGID_PGID,
+		lan966x, ANA_PGID(PGID_BC));
+
+	lan_wr(REW_PORT_CFG_NO_REWRITE_SET(1),
+	       lan966x, REW_PORT_CFG(CPU_PORT));
+
+	lan_rmw(ANA_ANAINTR_INTR_ENA_SET(1),
+		ANA_ANAINTR_INTR_ENA,
+		lan966x, ANA_ANAINTR);
+}
+
+static int lan966x_ram_init(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, SYS_RAM_INIT);
+}
+
+static int lan966x_reset_switch(struct lan966x *lan966x)
+{
+	struct reset_control *reset;
+	int val = 0;
+	int ret;
+
+	reset = devm_reset_control_get_shared(lan966x->dev, "switch");
+	if (IS_ERR(reset))
+		dev_warn(lan966x->dev, "Could not obtain reset control: %ld\n",
+			 PTR_ERR(reset));
+	else
+		reset_control_reset(reset);
+
+	lan_wr(SYS_RESET_CFG_CORE_ENA_SET(0), lan966x, SYS_RESET_CFG);
+	lan_wr(SYS_RAM_INIT_RAM_INIT_SET(1), lan966x, SYS_RAM_INIT);
+	ret = readx_poll_timeout(lan966x_ram_init, lan966x,
+				 val, (val & BIT(1)) == 0, READL_SLEEP_US,
+				 READL_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	lan_wr(SYS_RESET_CFG_CORE_ENA_SET(1), lan966x, SYS_RESET_CFG);
+
+	return 0;
+}
+
+static int lan966x_probe(struct platform_device *pdev)
+{
+	struct fwnode_handle *ports, *portnp;
+	struct lan966x *lan966x;
+	int err, i;
+
+	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
+	if (!lan966x)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, lan966x);
+	lan966x->dev = &pdev->dev;
+
+	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
+	if (!ports) {
+		dev_err(&pdev->dev, "no ethernet-ports child not found\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = lan966x_create_targets(pdev, lan966x);
+	if (err)
+		goto out;
+
+	if (lan966x_reset_switch(lan966x)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	i = 0;
+	fwnode_for_each_available_child_node(ports, portnp)
+		++i;
+
+	lan966x->num_phys_ports = i;
+	lan966x->ports = devm_kcalloc(&pdev->dev, lan966x->num_phys_ports,
+				      sizeof(struct lan966x_port *),
+				      GFP_KERNEL);
+
+	/* There QS system has 32KB of memory */
+	lan966x->shared_queue_sz = LAN966X_BUFFER_MEMORY;
+
+	/* init switch */
+	lan966x_init(lan966x);
+
+	/* go over the child nodes */
+	fwnode_for_each_available_child_node(ports, portnp) {
+		phy_interface_t phy_mode;
+		struct phy *serdes;
+		u32 port;
+
+		if (fwnode_property_read_u32(portnp, "reg", &port))
+			continue;
+
+		phy_mode = fwnode_get_phy_mode(portnp);
+		err = lan966x_probe_port(lan966x, port, phy_mode);
+		if (err)
+			return err;
+	}
+
+	return 0;
+
+out:
+	return err;
+}
+
+static int lan966x_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver lan966x_driver = {
+	.probe = lan966x_probe,
+	.remove = lan966x_remove,
+	.driver = {
+		.name = "lan966x-switch",
+		.of_match_table = lan966x_match,
+	},
+};
+module_platform_driver(lan966x_driver);
+
+MODULE_DESCRIPTION("Microchip LAN966X switch driver");
+MODULE_AUTHOR("Horatiu Vultur <horatiu.vultur@microchip.com>");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
new file mode 100644
index 000000000000..0c5fa14437a5
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __LAN966X_MAIN_H__
+#define __LAN966X_MAIN_H__
+
+#include "lan966x_regs.h"
+
+#define LAN966X_BUFFER_CELL_SZ		64
+#define LAN966X_BUFFER_MEMORY		(160 * 1024)
+#define LAN966X_BUFFER_MIN_SZ		60
+
+#define PGID_AGGR			64
+#define PGID_SRC			80
+#define PGID_ENTRIES			89
+
+#define PORT_PVID			0
+
+/* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
+#define QSYS_Q_RSRV			95
+
+/* Reserved PGIDs */
+#define PGID_CPU			(PGID_AGGR - 6)
+#define PGID_UC				(PGID_AGGR - 5)
+#define PGID_BC				(PGID_AGGR - 4)
+#define PGID_MC				(PGID_AGGR - 3)
+#define PGID_MCIPV4			(PGID_AGGR - 2)
+#define PGID_MCIPV6			(PGID_AGGR - 1)
+
+#define LAN966X_SPEED_NONE		0
+#define LAN966X_SPEED_1000		1
+#define LAN966X_SPEED_100		2
+#define LAN966X_SPEED_10		3
+
+#define CPU_PORT			8
+
+struct lan966x_port;
+
+struct lan966x {
+	struct device *dev;
+
+	u8 num_phys_ports;
+	struct lan966x_port **ports;
+
+	void __iomem *regs[NUM_TARGETS];
+
+	int shared_queue_sz;
+};
+
+struct lan966x_port {
+	struct lan966x *lan966x;
+
+	u8 chip_port;
+	u16 pvid;
+
+	void __iomem *regs;
+};
+
+static inline void __iomem *lan_addr(void __iomem *base[],
+				     int id, int tinst, int tcnt,
+				     int gbase, int ginst,
+				     int gcnt, int gwidth,
+				     int raddr, int rinst,
+				     int rcnt, int rwidth)
+{
+	WARN_ON((tinst) >= tcnt);
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+	return base[id + (tinst)] +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+static inline u32 lan_rd(struct lan966x *lan966x, int id, int tinst, int tcnt,
+			 int gbase, int ginst, int gcnt, int gwidth,
+			 int raddr, int rinst, int rcnt, int rwidth)
+{
+	return readl(lan_addr(lan966x->regs, id, tinst, tcnt, gbase, ginst,
+			      gcnt, gwidth, raddr, rinst, rcnt, rwidth));
+}
+
+static inline void lan_wr(u32 val, struct lan966x *lan966x,
+			  int id, int tinst, int tcnt,
+			  int gbase, int ginst, int gcnt, int gwidth,
+			  int raddr, int rinst, int rcnt, int rwidth)
+{
+	writel(val, lan_addr(lan966x->regs, id, tinst, tcnt,
+			     gbase, ginst, gcnt, gwidth,
+			     raddr, rinst, rcnt, rwidth));
+}
+
+static inline void lan_rmw(u32 val, u32 mask, struct lan966x *lan966x,
+			   int id, int tinst, int tcnt,
+			   int gbase, int ginst, int gcnt, int gwidth,
+			   int raddr, int rinst, int rcnt, int rwidth)
+{
+	u32 nval;
+
+	nval = readl(lan_addr(lan966x->regs, id, tinst, tcnt, gbase, ginst,
+			      gcnt, gwidth, raddr, rinst, rcnt, rwidth));
+	nval = (nval & ~mask) | (val & mask);
+	writel(nval, lan_addr(lan966x->regs, id, tinst, tcnt, gbase, ginst,
+			      gcnt, gwidth, raddr, rinst, rcnt, rwidth));
+}
+
+#endif /* __LAN966X_MAIN_H__ */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
new file mode 100644
index 000000000000..d2ffb4cc122c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -0,0 +1,704 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+
+/* This file is autogenerated by cml-utils 2021-07-23 13:13:18 +0200.
+ * Commit ID: 82017f2e7bc0232de70264fd8a07e1fec9257afa (dirty)
+ */
+
+#ifndef _LAN966X_REGS_H_
+#define _LAN966X_REGS_H_
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+#include <linux/bug.h>
+
+enum lan966x_target {
+	TARGET_AFI = 2,
+	TARGET_ANA = 3,
+	TARGET_CHIP_TOP = 5,
+	TARGET_CPU = 6,
+	TARGET_DEV = 13,
+	TARGET_GCB = 27,
+	TARGET_HSIO = 32,
+	TARGET_ORG = 36,
+	TARGET_QS = 42,
+	TARGET_QSYS = 46,
+	TARGET_REW = 47,
+	TARGET_SYS = 52,
+	NUM_TARGETS = 66
+};
+
+#define __REG(...)    __VA_ARGS__
+
+/*      AFI:PORT_TBL:PORT_FRM_OUT */
+#define AFI_PORT_FRM_OUT(g)       __REG(TARGET_AFI, 0, 1, 98816, g, 10, 8, 0, 0, 1, 4)
+
+#define AFI_PORT_FRM_OUT_FRM_OUT_CNT             GENMASK(26, 16)
+#define AFI_PORT_FRM_OUT_FRM_OUT_CNT_SET(x)\
+	FIELD_PREP(AFI_PORT_FRM_OUT_FRM_OUT_CNT, x)
+#define AFI_PORT_FRM_OUT_FRM_OUT_CNT_GET(x)\
+	FIELD_GET(AFI_PORT_FRM_OUT_FRM_OUT_CNT, x)
+
+/*      AFI:PORT_TBL:PORT_CFG */
+#define AFI_PORT_CFG(g)           __REG(TARGET_AFI, 0, 1, 98816, g, 10, 8, 4, 0, 1, 4)
+
+#define AFI_PORT_CFG_FC_SKIP_TTI_INJ             BIT(16)
+#define AFI_PORT_CFG_FC_SKIP_TTI_INJ_SET(x)\
+	FIELD_PREP(AFI_PORT_CFG_FC_SKIP_TTI_INJ, x)
+#define AFI_PORT_CFG_FC_SKIP_TTI_INJ_GET(x)\
+	FIELD_GET(AFI_PORT_CFG_FC_SKIP_TTI_INJ, x)
+
+#define AFI_PORT_CFG_FRM_OUT_MAX                 GENMASK(9, 0)
+#define AFI_PORT_CFG_FRM_OUT_MAX_SET(x)\
+	FIELD_PREP(AFI_PORT_CFG_FRM_OUT_MAX, x)
+#define AFI_PORT_CFG_FRM_OUT_MAX_GET(x)\
+	FIELD_GET(AFI_PORT_CFG_FRM_OUT_MAX, x)
+
+/*      ANA:ANA:ADVLEARN */
+#define ANA_ADVLEARN              __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 0, 0, 1, 4)
+
+#define ANA_ADVLEARN_VLAN_CHK                    BIT(0)
+#define ANA_ADVLEARN_VLAN_CHK_SET(x)\
+	FIELD_PREP(ANA_ADVLEARN_VLAN_CHK, x)
+#define ANA_ADVLEARN_VLAN_CHK_GET(x)\
+	FIELD_GET(ANA_ADVLEARN_VLAN_CHK, x)
+
+/*      ANA:ANA:ANAINTR */
+#define ANA_ANAINTR               __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 16, 0, 1, 4)
+
+#define ANA_ANAINTR_INTR                         BIT(1)
+#define ANA_ANAINTR_INTR_SET(x)\
+	FIELD_PREP(ANA_ANAINTR_INTR, x)
+#define ANA_ANAINTR_INTR_GET(x)\
+	FIELD_GET(ANA_ANAINTR_INTR, x)
+
+#define ANA_ANAINTR_INTR_ENA                     BIT(0)
+#define ANA_ANAINTR_INTR_ENA_SET(x)\
+	FIELD_PREP(ANA_ANAINTR_INTR_ENA, x)
+#define ANA_ANAINTR_INTR_ENA_GET(x)\
+	FIELD_GET(ANA_ANAINTR_INTR_ENA, x)
+
+/*      ANA:ANA:AUTOAGE */
+#define ANA_AUTOAGE               __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 44, 0, 1, 4)
+
+#define ANA_AUTOAGE_AGE_PERIOD                   GENMASK(20, 1)
+#define ANA_AUTOAGE_AGE_PERIOD_SET(x)\
+	FIELD_PREP(ANA_AUTOAGE_AGE_PERIOD, x)
+#define ANA_AUTOAGE_AGE_PERIOD_GET(x)\
+	FIELD_GET(ANA_AUTOAGE_AGE_PERIOD, x)
+
+/*      ANA:ANA:FLOODING */
+#define ANA_FLOODING(r)           __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 68, r, 8, 4)
+
+#define ANA_FLOODING_FLD_BROADCAST               GENMASK(11, 6)
+#define ANA_FLOODING_FLD_BROADCAST_SET(x)\
+	FIELD_PREP(ANA_FLOODING_FLD_BROADCAST, x)
+#define ANA_FLOODING_FLD_BROADCAST_GET(x)\
+	FIELD_GET(ANA_FLOODING_FLD_BROADCAST, x)
+
+#define ANA_FLOODING_FLD_MULTICAST               GENMASK(5, 0)
+#define ANA_FLOODING_FLD_MULTICAST_SET(x)\
+	FIELD_PREP(ANA_FLOODING_FLD_MULTICAST, x)
+#define ANA_FLOODING_FLD_MULTICAST_GET(x)\
+	FIELD_GET(ANA_FLOODING_FLD_MULTICAST, x)
+
+/*      ANA:ANA:FLOODING_IPMC */
+#define ANA_FLOODING_IPMC         __REG(TARGET_ANA, 0, 1, 29824, 0, 1, 244, 100, 0, 1, 4)
+
+#define ANA_FLOODING_IPMC_FLD_MC4_CTRL           GENMASK(23, 18)
+#define ANA_FLOODING_IPMC_FLD_MC4_CTRL_SET(x)\
+	FIELD_PREP(ANA_FLOODING_IPMC_FLD_MC4_CTRL, x)
+#define ANA_FLOODING_IPMC_FLD_MC4_CTRL_GET(x)\
+	FIELD_GET(ANA_FLOODING_IPMC_FLD_MC4_CTRL, x)
+
+#define ANA_FLOODING_IPMC_FLD_MC4_DATA           GENMASK(17, 12)
+#define ANA_FLOODING_IPMC_FLD_MC4_DATA_SET(x)\
+	FIELD_PREP(ANA_FLOODING_IPMC_FLD_MC4_DATA, x)
+#define ANA_FLOODING_IPMC_FLD_MC4_DATA_GET(x)\
+	FIELD_GET(ANA_FLOODING_IPMC_FLD_MC4_DATA, x)
+
+#define ANA_FLOODING_IPMC_FLD_MC6_CTRL           GENMASK(11, 6)
+#define ANA_FLOODING_IPMC_FLD_MC6_CTRL_SET(x)\
+	FIELD_PREP(ANA_FLOODING_IPMC_FLD_MC6_CTRL, x)
+#define ANA_FLOODING_IPMC_FLD_MC6_CTRL_GET(x)\
+	FIELD_GET(ANA_FLOODING_IPMC_FLD_MC6_CTRL, x)
+
+#define ANA_FLOODING_IPMC_FLD_MC6_DATA           GENMASK(5, 0)
+#define ANA_FLOODING_IPMC_FLD_MC6_DATA_SET(x)\
+	FIELD_PREP(ANA_FLOODING_IPMC_FLD_MC6_DATA, x)
+#define ANA_FLOODING_IPMC_FLD_MC6_DATA_GET(x)\
+	FIELD_GET(ANA_FLOODING_IPMC_FLD_MC6_DATA, x)
+
+/*      ANA:PGID:PGID */
+#define ANA_PGID(g)               __REG(TARGET_ANA, 0, 1, 27648, g, 89, 8, 0, 0, 1, 4)
+
+#define ANA_PGID_PGID                            GENMASK(8, 0)
+#define ANA_PGID_PGID_SET(x)\
+	FIELD_PREP(ANA_PGID_PGID, x)
+#define ANA_PGID_PGID_GET(x)\
+	FIELD_GET(ANA_PGID_PGID, x)
+
+/*      ANA:PGID:PGID_CFG */
+#define ANA_PGID_CFG(g)           __REG(TARGET_ANA, 0, 1, 27648, g, 89, 8, 4, 0, 1, 4)
+
+#define ANA_PGID_CFG_OBEY_VLAN                   BIT(0)
+#define ANA_PGID_CFG_OBEY_VLAN_SET(x)\
+	FIELD_PREP(ANA_PGID_CFG_OBEY_VLAN, x)
+#define ANA_PGID_CFG_OBEY_VLAN_GET(x)\
+	FIELD_GET(ANA_PGID_CFG_OBEY_VLAN, x)
+
+/*      ANA:ANA_TABLES:MACHDATA */
+#define ANA_MACHDATA              __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 40, 0, 1, 4)
+
+/*      ANA:ANA_TABLES:MACLDATA */
+#define ANA_MACLDATA              __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 44, 0, 1, 4)
+
+/*      ANA:ANA_TABLES:MACACCESS */
+#define ANA_MACACCESS             __REG(TARGET_ANA, 0, 1, 27520, 0, 1, 128, 48, 0, 1, 4)
+
+#define ANA_MACACCESS_CHANGE2SW                  BIT(17)
+#define ANA_MACACCESS_CHANGE2SW_SET(x)\
+	FIELD_PREP(ANA_MACACCESS_CHANGE2SW, x)
+#define ANA_MACACCESS_CHANGE2SW_GET(x)\
+	FIELD_GET(ANA_MACACCESS_CHANGE2SW, x)
+
+#define ANA_MACACCESS_VALID                      BIT(12)
+#define ANA_MACACCESS_VALID_SET(x)\
+	FIELD_PREP(ANA_MACACCESS_VALID, x)
+#define ANA_MACACCESS_VALID_GET(x)\
+	FIELD_GET(ANA_MACACCESS_VALID, x)
+
+#define ANA_MACACCESS_ENTRYTYPE                  GENMASK(11, 10)
+#define ANA_MACACCESS_ENTRYTYPE_SET(x)\
+	FIELD_PREP(ANA_MACACCESS_ENTRYTYPE, x)
+#define ANA_MACACCESS_ENTRYTYPE_GET(x)\
+	FIELD_GET(ANA_MACACCESS_ENTRYTYPE, x)
+
+#define ANA_MACACCESS_DEST_IDX                   GENMASK(9, 4)
+#define ANA_MACACCESS_DEST_IDX_SET(x)\
+	FIELD_PREP(ANA_MACACCESS_DEST_IDX, x)
+#define ANA_MACACCESS_DEST_IDX_GET(x)\
+	FIELD_GET(ANA_MACACCESS_DEST_IDX, x)
+
+#define ANA_MACACCESS_MAC_TABLE_CMD              GENMASK(3, 0)
+#define ANA_MACACCESS_MAC_TABLE_CMD_SET(x)\
+	FIELD_PREP(ANA_MACACCESS_MAC_TABLE_CMD, x)
+#define ANA_MACACCESS_MAC_TABLE_CMD_GET(x)\
+	FIELD_GET(ANA_MACACCESS_MAC_TABLE_CMD, x)
+
+/*      ANA:PORT:CPU_FWD_CFG */
+#define ANA_CPU_FWD_CFG(g)        __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 96, 0, 1, 4)
+
+#define ANA_CPU_FWD_CFG_SRC_COPY_ENA             BIT(3)
+#define ANA_CPU_FWD_CFG_SRC_COPY_ENA_SET(x)\
+	FIELD_PREP(ANA_CPU_FWD_CFG_SRC_COPY_ENA, x)
+#define ANA_CPU_FWD_CFG_SRC_COPY_ENA_GET(x)\
+	FIELD_GET(ANA_CPU_FWD_CFG_SRC_COPY_ENA, x)
+
+/*      ANA:PORT:CPU_FWD_BPDU_CFG */
+#define ANA_CPU_FWD_BPDU_CFG(g)   __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 100, 0, 1, 4)
+
+/*      ANA:PORT:PORT_CFG */
+#define ANA_PORT_CFG(g)           __REG(TARGET_ANA, 0, 1, 28672, g, 9, 128, 112, 0, 1, 4)
+
+#define ANA_PORT_CFG_LEARNAUTO                   BIT(6)
+#define ANA_PORT_CFG_LEARNAUTO_SET(x)\
+	FIELD_PREP(ANA_PORT_CFG_LEARNAUTO, x)
+#define ANA_PORT_CFG_LEARNAUTO_GET(x)\
+	FIELD_GET(ANA_PORT_CFG_LEARNAUTO, x)
+
+#define ANA_PORT_CFG_RECV_ENA                    BIT(4)
+#define ANA_PORT_CFG_RECV_ENA_SET(x)\
+	FIELD_PREP(ANA_PORT_CFG_RECV_ENA, x)
+#define ANA_PORT_CFG_RECV_ENA_GET(x)\
+	FIELD_GET(ANA_PORT_CFG_RECV_ENA, x)
+
+#define ANA_PORT_CFG_PORTID_VAL                  GENMASK(3, 0)
+#define ANA_PORT_CFG_PORTID_VAL_SET(x)\
+	FIELD_PREP(ANA_PORT_CFG_PORTID_VAL, x)
+#define ANA_PORT_CFG_PORTID_VAL_GET(x)\
+	FIELD_GET(ANA_PORT_CFG_PORTID_VAL, x)
+
+/*      ANA:PFC:PFC_CFG */
+#define ANA_PFC_CFG(g)            __REG(TARGET_ANA, 0, 1, 30720, g, 8, 64, 0, 0, 1, 4)
+
+#define ANA_PFC_CFG_FC_LINK_SPEED                GENMASK(1, 0)
+#define ANA_PFC_CFG_FC_LINK_SPEED_SET(x)\
+	FIELD_PREP(ANA_PFC_CFG_FC_LINK_SPEED, x)
+#define ANA_PFC_CFG_FC_LINK_SPEED_GET(x)\
+	FIELD_GET(ANA_PFC_CFG_FC_LINK_SPEED, x)
+
+/*      CHIP_TOP:CUPHY_CFG:CUPHY_PORT_CFG */
+#define CHIP_TOP_CUPHY_PORT_CFG(r) __REG(TARGET_CHIP_TOP, 0, 1, 16, 0, 1, 20, 8, r, 2, 4)
+
+#define CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA      BIT(0)
+#define CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA_SET(x)\
+	FIELD_PREP(CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA, x)
+#define CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA_GET(x)\
+	FIELD_GET(CHIP_TOP_CUPHY_PORT_CFG_GTX_CLK_ENA, x)
+
+/*      CHIP_TOP:CUPHY_CFG:CUPHY_COMMON_CFG */
+#define CHIP_TOP_CUPHY_COMMON_CFG __REG(TARGET_CHIP_TOP, 0, 1, 16, 0, 1, 20, 16, 0, 1, 4)
+
+#define CHIP_TOP_CUPHY_COMMON_CFG_RESET_N        BIT(0)
+#define CHIP_TOP_CUPHY_COMMON_CFG_RESET_N_SET(x)\
+	FIELD_PREP(CHIP_TOP_CUPHY_COMMON_CFG_RESET_N, x)
+#define CHIP_TOP_CUPHY_COMMON_CFG_RESET_N_GET(x)\
+	FIELD_GET(CHIP_TOP_CUPHY_COMMON_CFG_RESET_N, x)
+
+/*      CPU:CPU_REGS:RESET_PROT_STAT */
+#define CPU_RESET_PROT_STAT       __REG(TARGET_CPU, 0, 1, 0, 0, 1, 168, 136, 0, 1, 4)
+
+#define CPU_RESET_PROT_STAT_SYS_RST_PROT_VCORE   BIT(5)
+#define CPU_RESET_PROT_STAT_SYS_RST_PROT_VCORE_SET(x)\
+	FIELD_PREP(CPU_RESET_PROT_STAT_SYS_RST_PROT_VCORE, x)
+#define CPU_RESET_PROT_STAT_SYS_RST_PROT_VCORE_GET(x)\
+	FIELD_GET(CPU_RESET_PROT_STAT_SYS_RST_PROT_VCORE, x)
+
+/*      DEV:PORT_MODE:CLOCK_CFG */
+#define DEV_CLOCK_CFG(t)          __REG(TARGET_DEV, t, 8, 0, 0, 1, 28, 0, 0, 1, 4)
+
+#define DEV_CLOCK_CFG_MAC_TX_RST                 BIT(7)
+#define DEV_CLOCK_CFG_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV_CLOCK_CFG_MAC_TX_RST, x)
+#define DEV_CLOCK_CFG_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV_CLOCK_CFG_MAC_TX_RST, x)
+
+#define DEV_CLOCK_CFG_MAC_RX_RST                 BIT(6)
+#define DEV_CLOCK_CFG_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV_CLOCK_CFG_MAC_RX_RST, x)
+#define DEV_CLOCK_CFG_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV_CLOCK_CFG_MAC_RX_RST, x)
+
+#define DEV_CLOCK_CFG_PCS_TX_RST                 BIT(5)
+#define DEV_CLOCK_CFG_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV_CLOCK_CFG_PCS_TX_RST, x)
+#define DEV_CLOCK_CFG_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV_CLOCK_CFG_PCS_TX_RST, x)
+
+#define DEV_CLOCK_CFG_PCS_RX_RST                 BIT(4)
+#define DEV_CLOCK_CFG_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV_CLOCK_CFG_PCS_RX_RST, x)
+#define DEV_CLOCK_CFG_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV_CLOCK_CFG_PCS_RX_RST, x)
+
+#define DEV_CLOCK_CFG_PORT_RST                   BIT(3)
+#define DEV_CLOCK_CFG_PORT_RST_SET(x)\
+	FIELD_PREP(DEV_CLOCK_CFG_PORT_RST, x)
+#define DEV_CLOCK_CFG_PORT_RST_GET(x)\
+	FIELD_GET(DEV_CLOCK_CFG_PORT_RST, x)
+
+#define DEV_CLOCK_CFG_LINK_SPEED                 GENMASK(1, 0)
+#define DEV_CLOCK_CFG_LINK_SPEED_SET(x)\
+	FIELD_PREP(DEV_CLOCK_CFG_LINK_SPEED, x)
+#define DEV_CLOCK_CFG_LINK_SPEED_GET(x)\
+	FIELD_GET(DEV_CLOCK_CFG_LINK_SPEED, x)
+
+/*      DEV:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV_MAC_ENA_CFG(t)        __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 0, 0, 1, 4)
+
+#define DEV_MAC_ENA_CFG_RX_ENA                   BIT(4)
+#define DEV_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_ENA_CFG_RX_ENA, x)
+#define DEV_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV_MAC_ENA_CFG_TX_ENA                   BIT(0)
+#define DEV_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_ENA_CFG_TX_ENA, x)
+#define DEV_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV:MAC_CFG_STATUS:MAC_MODE_CFG */
+#define DEV_MAC_MODE_CFG(t)       __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 4, 0, 1, 4)
+
+#define DEV_MAC_MODE_CFG_GIGA_MODE_ENA           BIT(4)
+#define DEV_MAC_MODE_CFG_GIGA_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV_MAC_MODE_CFG_GIGA_MODE_ENA, x)
+#define DEV_MAC_MODE_CFG_GIGA_MODE_ENA_GET(x)\
+	FIELD_GET(DEV_MAC_MODE_CFG_GIGA_MODE_ENA, x)
+
+/*      DEV:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV_MAC_MAXLEN_CFG(t)     __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 8, 0, 1, 4)
+
+#define DEV_MAC_MAXLEN_CFG_MAX_LEN               GENMASK(15, 0)
+#define DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV:MAC_CFG_STATUS:MAC_IFG_CFG */
+#define DEV_MAC_IFG_CFG(t)        __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 20, 0, 1, 4)
+
+#define DEV_MAC_IFG_CFG_TX_IFG                   GENMASK(12, 8)
+#define DEV_MAC_IFG_CFG_TX_IFG_SET(x)\
+	FIELD_PREP(DEV_MAC_IFG_CFG_TX_IFG, x)
+#define DEV_MAC_IFG_CFG_TX_IFG_GET(x)\
+	FIELD_GET(DEV_MAC_IFG_CFG_TX_IFG, x)
+
+/*      DEV:MAC_CFG_STATUS:MAC_HDX_CFG */
+#define DEV_MAC_HDX_CFG(t)        __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 24, 0, 1, 4)
+
+#define DEV_MAC_HDX_CFG_SEED                     GENMASK(23, 16)
+#define DEV_MAC_HDX_CFG_SEED_SET(x)\
+	FIELD_PREP(DEV_MAC_HDX_CFG_SEED, x)
+#define DEV_MAC_HDX_CFG_SEED_GET(x)\
+	FIELD_GET(DEV_MAC_HDX_CFG_SEED, x)
+
+#define DEV_MAC_HDX_CFG_SEED_LOAD                BIT(12)
+#define DEV_MAC_HDX_CFG_SEED_LOAD_SET(x)\
+	FIELD_PREP(DEV_MAC_HDX_CFG_SEED_LOAD, x)
+#define DEV_MAC_HDX_CFG_SEED_LOAD_GET(x)\
+	FIELD_GET(DEV_MAC_HDX_CFG_SEED_LOAD, x)
+
+/*      DEV:MAC_CFG_STATUS:MAC_FC_MAC_LOW_CFG */
+#define DEV_FC_MAC_LOW_CFG(t)     __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 32, 0, 1, 4)
+
+/*      DEV:MAC_CFG_STATUS:MAC_FC_MAC_HIGH_CFG */
+#define DEV_FC_MAC_HIGH_CFG(t)    __REG(TARGET_DEV, t, 8, 28, 0, 1, 44, 36, 0, 1, 4)
+
+/*      DEV:PCS1G_CFG_STATUS:PCS1G_CFG */
+#define DEV_PCS1G_CFG(t)          __REG(TARGET_DEV, t, 8, 72, 0, 1, 68, 0, 0, 1, 4)
+
+#define DEV_PCS1G_CFG_PCS_ENA                    BIT(0)
+#define DEV_PCS1G_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(DEV_PCS1G_CFG_PCS_ENA, x)
+#define DEV_PCS1G_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(DEV_PCS1G_CFG_PCS_ENA, x)
+
+/*      DEV:PCS1G_CFG_STATUS:PCS1G_SD_CFG */
+#define DEV_PCS1G_SD_CFG(t)       __REG(TARGET_DEV, t, 8, 72, 0, 1, 68, 8, 0, 1, 4)
+
+#define DEV_PCS1G_SD_CFG_SD_ENA                  BIT(0)
+#define DEV_PCS1G_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV_PCS1G_SD_CFG_SD_ENA, x)
+#define DEV_PCS1G_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV_PCS1G_SD_CFG_SD_ENA, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:SOFT_RST */
+#define GCB_SOFT_RST              __REG(TARGET_GCB, 0, 1, 0, 0, 1, 68, 12, 0, 1, 4)
+
+/*      HSIO:HW_CFGSTAT:HW_CFG */
+#define HSIO_HW_CFG               __REG(TARGET_HSIO, 0, 1, 104, 0, 1, 52, 0, 0, 1, 4)
+
+#define HSIO_HW_CFG_RGMII_1_CFG                  BIT(15)
+#define HSIO_HW_CFG_RGMII_1_CFG_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_RGMII_1_CFG, x)
+#define HSIO_HW_CFG_RGMII_1_CFG_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_RGMII_1_CFG, x)
+
+#define HSIO_HW_CFG_RGMII_0_CFG                  BIT(14)
+#define HSIO_HW_CFG_RGMII_0_CFG_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_RGMII_0_CFG, x)
+#define HSIO_HW_CFG_RGMII_0_CFG_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_RGMII_0_CFG, x)
+
+#define HSIO_HW_CFG_RGMII_ENA                    GENMASK(13, 12)
+#define HSIO_HW_CFG_RGMII_ENA_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_RGMII_ENA, x)
+#define HSIO_HW_CFG_RGMII_ENA_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_RGMII_ENA, x)
+
+#define HSIO_HW_CFG_SD6G_0_CFG                   BIT(11)
+#define HSIO_HW_CFG_SD6G_0_CFG_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_SD6G_0_CFG, x)
+#define HSIO_HW_CFG_SD6G_0_CFG_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_SD6G_0_CFG, x)
+
+#define HSIO_HW_CFG_SD6G_1_CFG                   BIT(10)
+#define HSIO_HW_CFG_SD6G_1_CFG_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_SD6G_1_CFG, x)
+#define HSIO_HW_CFG_SD6G_1_CFG_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_SD6G_1_CFG, x)
+
+#define HSIO_HW_CFG_GMII_ENA                     GENMASK(9, 2)
+#define HSIO_HW_CFG_GMII_ENA_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_GMII_ENA, x)
+#define HSIO_HW_CFG_GMII_ENA_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_GMII_ENA, x)
+
+#define HSIO_HW_CFG_QSGMII_ENA                   GENMASK(1, 0)
+#define HSIO_HW_CFG_QSGMII_ENA_SET(x)\
+	FIELD_PREP(HSIO_HW_CFG_QSGMII_ENA, x)
+#define HSIO_HW_CFG_QSGMII_ENA_GET(x)\
+	FIELD_GET(HSIO_HW_CFG_QSGMII_ENA, x)
+
+/*      DEVCPU_QS:XTR:XTR_GRP_CFG */
+#define QS_XTR_GRP_CFG(r)         __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 0, r, 2, 4)
+
+#define QS_XTR_GRP_CFG_MODE                      GENMASK(3, 2)
+#define QS_XTR_GRP_CFG_MODE_SET(x)\
+	FIELD_PREP(QS_XTR_GRP_CFG_MODE, x)
+#define QS_XTR_GRP_CFG_MODE_GET(x)\
+	FIELD_GET(QS_XTR_GRP_CFG_MODE, x)
+
+#define QS_XTR_GRP_CFG_BYTE_SWAP                 BIT(0)
+#define QS_XTR_GRP_CFG_BYTE_SWAP_SET(x)\
+	FIELD_PREP(QS_XTR_GRP_CFG_BYTE_SWAP, x)
+#define QS_XTR_GRP_CFG_BYTE_SWAP_GET(x)\
+	FIELD_GET(QS_XTR_GRP_CFG_BYTE_SWAP, x)
+
+/*      DEVCPU_QS:XTR:XTR_RD */
+#define QS_XTR_RD(r)              __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 8, r, 2, 4)
+
+/*      DEVCPU_QS:XTR:XTR_FLUSH */
+#define QS_XTR_FLUSH              __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 24, 0, 1, 4)
+
+/*      DEVCPU_QS:XTR:XTR_DATA_PRESENT */
+#define QS_XTR_DATA_PRESENT       __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 28, 0, 1, 4)
+
+/*      DEVCPU_QS:INJ:INJ_GRP_CFG */
+#define QS_INJ_GRP_CFG(r)         __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 0, r, 2, 4)
+
+#define QS_INJ_GRP_CFG_MODE                      GENMASK(3, 2)
+#define QS_INJ_GRP_CFG_MODE_SET(x)\
+	FIELD_PREP(QS_INJ_GRP_CFG_MODE, x)
+#define QS_INJ_GRP_CFG_MODE_GET(x)\
+	FIELD_GET(QS_INJ_GRP_CFG_MODE, x)
+
+#define QS_INJ_GRP_CFG_BYTE_SWAP                 BIT(0)
+#define QS_INJ_GRP_CFG_BYTE_SWAP_SET(x)\
+	FIELD_PREP(QS_INJ_GRP_CFG_BYTE_SWAP, x)
+#define QS_INJ_GRP_CFG_BYTE_SWAP_GET(x)\
+	FIELD_GET(QS_INJ_GRP_CFG_BYTE_SWAP, x)
+
+/*      DEVCPU_QS:INJ:INJ_WR */
+#define QS_INJ_WR(r)              __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 8, r, 2, 4)
+
+/*      DEVCPU_QS:INJ:INJ_CTRL */
+#define QS_INJ_CTRL(r)            __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 16, r, 2, 4)
+
+#define QS_INJ_CTRL_GAP_SIZE                     GENMASK(24, 21)
+#define QS_INJ_CTRL_GAP_SIZE_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_GAP_SIZE, x)
+#define QS_INJ_CTRL_GAP_SIZE_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_GAP_SIZE, x)
+
+#define QS_INJ_CTRL_EOF                          BIT(19)
+#define QS_INJ_CTRL_EOF_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_EOF, x)
+#define QS_INJ_CTRL_EOF_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_EOF, x)
+
+#define QS_INJ_CTRL_SOF                          BIT(18)
+#define QS_INJ_CTRL_SOF_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_SOF, x)
+#define QS_INJ_CTRL_SOF_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_SOF, x)
+
+#define QS_INJ_CTRL_VLD_BYTES                    GENMASK(17, 16)
+#define QS_INJ_CTRL_VLD_BYTES_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_VLD_BYTES, x)
+#define QS_INJ_CTRL_VLD_BYTES_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_VLD_BYTES, x)
+
+/*      DEVCPU_QS:INJ:INJ_STATUS */
+#define QS_INJ_STATUS             __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 24, 0, 1, 4)
+
+#define QS_INJ_STATUS_WMARK_REACHED              GENMASK(5, 4)
+#define QS_INJ_STATUS_WMARK_REACHED_SET(x)\
+	FIELD_PREP(QS_INJ_STATUS_WMARK_REACHED, x)
+#define QS_INJ_STATUS_WMARK_REACHED_GET(x)\
+	FIELD_GET(QS_INJ_STATUS_WMARK_REACHED, x)
+
+#define QS_INJ_STATUS_FIFO_RDY                   GENMASK(3, 2)
+#define QS_INJ_STATUS_FIFO_RDY_SET(x)\
+	FIELD_PREP(QS_INJ_STATUS_FIFO_RDY, x)
+#define QS_INJ_STATUS_FIFO_RDY_GET(x)\
+	FIELD_GET(QS_INJ_STATUS_FIFO_RDY, x)
+
+/*      QSYS:SYSTEM:PORT_MODE */
+#define QSYS_PORT_MODE(r)         __REG(TARGET_QSYS, 0, 1, 28008, 0, 1, 216, 0, r, 10, 4)
+
+#define QSYS_PORT_MODE_DEQUEUE_DIS               BIT(1)
+#define QSYS_PORT_MODE_DEQUEUE_DIS_SET(x)\
+	FIELD_PREP(QSYS_PORT_MODE_DEQUEUE_DIS, x)
+#define QSYS_PORT_MODE_DEQUEUE_DIS_GET(x)\
+	FIELD_GET(QSYS_PORT_MODE_DEQUEUE_DIS, x)
+
+/*      QSYS:SYSTEM:SWITCH_PORT_MODE */
+#define QSYS_SW_PORT_MODE(r)      __REG(TARGET_QSYS, 0, 1, 28008, 0, 1, 216, 80, r, 9, 4)
+
+#define QSYS_SW_PORT_MODE_PORT_ENA               BIT(18)
+#define QSYS_SW_PORT_MODE_PORT_ENA_SET(x)\
+	FIELD_PREP(QSYS_SW_PORT_MODE_PORT_ENA, x)
+#define QSYS_SW_PORT_MODE_PORT_ENA_GET(x)\
+	FIELD_GET(QSYS_SW_PORT_MODE_PORT_ENA, x)
+
+#define QSYS_SW_PORT_MODE_SCH_NEXT_CFG           GENMASK(16, 14)
+#define QSYS_SW_PORT_MODE_SCH_NEXT_CFG_SET(x)\
+	FIELD_PREP(QSYS_SW_PORT_MODE_SCH_NEXT_CFG, x)
+#define QSYS_SW_PORT_MODE_SCH_NEXT_CFG_GET(x)\
+	FIELD_GET(QSYS_SW_PORT_MODE_SCH_NEXT_CFG, x)
+
+#define QSYS_SW_PORT_MODE_INGRESS_DROP_MODE      BIT(12)
+#define QSYS_SW_PORT_MODE_INGRESS_DROP_MODE_SET(x)\
+	FIELD_PREP(QSYS_SW_PORT_MODE_INGRESS_DROP_MODE, x)
+#define QSYS_SW_PORT_MODE_INGRESS_DROP_MODE_GET(x)\
+	FIELD_GET(QSYS_SW_PORT_MODE_INGRESS_DROP_MODE, x)
+
+#define QSYS_SW_PORT_MODE_TX_PFC_ENA             GENMASK(11, 4)
+#define QSYS_SW_PORT_MODE_TX_PFC_ENA_SET(x)\
+	FIELD_PREP(QSYS_SW_PORT_MODE_TX_PFC_ENA, x)
+#define QSYS_SW_PORT_MODE_TX_PFC_ENA_GET(x)\
+	FIELD_GET(QSYS_SW_PORT_MODE_TX_PFC_ENA, x)
+
+#define QSYS_SW_PORT_MODE_AGING_MODE             GENMASK(1, 0)
+#define QSYS_SW_PORT_MODE_AGING_MODE_SET(x)\
+	FIELD_PREP(QSYS_SW_PORT_MODE_AGING_MODE, x)
+#define QSYS_SW_PORT_MODE_AGING_MODE_GET(x)\
+	FIELD_GET(QSYS_SW_PORT_MODE_AGING_MODE, x)
+
+/*      QSYS:SYSTEM:SW_STATUS */
+#define QSYS_SW_STATUS(r)         __REG(TARGET_QSYS, 0, 1, 28008, 0, 1, 216, 164, r, 9, 4)
+
+#define QSYS_SW_STATUS_EQ_AVAIL                  GENMASK(7, 0)
+#define QSYS_SW_STATUS_EQ_AVAIL_SET(x)\
+	FIELD_PREP(QSYS_SW_STATUS_EQ_AVAIL, x)
+#define QSYS_SW_STATUS_EQ_AVAIL_GET(x)\
+	FIELD_GET(QSYS_SW_STATUS_EQ_AVAIL, x)
+
+/*      QSYS:SYSTEM:CPU_GROUP_MAP */
+#define QSYS_CPU_GROUP_MAP        __REG(TARGET_QSYS, 0, 1, 28008, 0, 1, 216, 204, 0, 1, 4)
+
+/*      QSYS:RES_CTRL:RES_CFG */
+#define QSYS_RES_CFG(g)           __REG(TARGET_QSYS, 0, 1, 32768, g, 1024, 8, 0, 0, 1, 4)
+
+/*      REW:PORT:PORT_CFG */
+#define REW_PORT_CFG(g)           __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 8, 0, 1, 4)
+
+#define REW_PORT_CFG_NO_REWRITE                  BIT(0)
+#define REW_PORT_CFG_NO_REWRITE_SET(x)\
+	FIELD_PREP(REW_PORT_CFG_NO_REWRITE, x)
+#define REW_PORT_CFG_NO_REWRITE_GET(x)\
+	FIELD_GET(REW_PORT_CFG_NO_REWRITE, x)
+
+/*      SYS:SYSTEM:RESET_CFG */
+#define SYS_RESET_CFG             __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 0, 0, 1, 4)
+
+#define SYS_RESET_CFG_CORE_ENA                   BIT(0)
+#define SYS_RESET_CFG_CORE_ENA_SET(x)\
+	FIELD_PREP(SYS_RESET_CFG_CORE_ENA, x)
+#define SYS_RESET_CFG_CORE_ENA_GET(x)\
+	FIELD_GET(SYS_RESET_CFG_CORE_ENA, x)
+
+/*      SYS:SYSTEM:PORT_MODE */
+#define SYS_PORT_MODE(r)          __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 44, r, 10, 4)
+
+#define SYS_PORT_MODE_INCL_INJ_HDR               GENMASK(5, 4)
+#define SYS_PORT_MODE_INCL_INJ_HDR_SET(x)\
+	FIELD_PREP(SYS_PORT_MODE_INCL_INJ_HDR, x)
+#define SYS_PORT_MODE_INCL_INJ_HDR_GET(x)\
+	FIELD_GET(SYS_PORT_MODE_INCL_INJ_HDR, x)
+
+#define SYS_PORT_MODE_INCL_XTR_HDR               GENMASK(3, 2)
+#define SYS_PORT_MODE_INCL_XTR_HDR_SET(x)\
+	FIELD_PREP(SYS_PORT_MODE_INCL_XTR_HDR, x)
+#define SYS_PORT_MODE_INCL_XTR_HDR_GET(x)\
+	FIELD_GET(SYS_PORT_MODE_INCL_XTR_HDR, x)
+
+/*      SYS:SYSTEM:FRONT_PORT_MODE */
+#define SYS_FRONT_PORT_MODE(r)    __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 84, r, 8, 4)
+
+#define SYS_FRONT_PORT_MODE_HDX_MODE             BIT(1)
+#define SYS_FRONT_PORT_MODE_HDX_MODE_SET(x)\
+	FIELD_PREP(SYS_FRONT_PORT_MODE_HDX_MODE, x)
+#define SYS_FRONT_PORT_MODE_HDX_MODE_GET(x)\
+	FIELD_GET(SYS_FRONT_PORT_MODE_HDX_MODE, x)
+
+/*      SYS:SYSTEM:FRM_AGING */
+#define SYS_FRM_AGING             __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 116, 0, 1, 4)
+
+#define SYS_FRM_AGING_AGE_TX_ENA                 BIT(20)
+#define SYS_FRM_AGING_AGE_TX_ENA_SET(x)\
+	FIELD_PREP(SYS_FRM_AGING_AGE_TX_ENA, x)
+#define SYS_FRM_AGING_AGE_TX_ENA_GET(x)\
+	FIELD_GET(SYS_FRM_AGING_AGE_TX_ENA, x)
+
+/*      SYS:SYSTEM:STAT_CFG */
+#define SYS_STAT_CFG              __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 120, 0, 1, 4)
+
+#define SYS_STAT_CFG_STAT_VIEW                   GENMASK(9, 0)
+#define SYS_STAT_CFG_STAT_VIEW_SET(x)\
+	FIELD_PREP(SYS_STAT_CFG_STAT_VIEW, x)
+#define SYS_STAT_CFG_STAT_VIEW_GET(x)\
+	FIELD_GET(SYS_STAT_CFG_STAT_VIEW, x)
+
+/*      SYS:PAUSE_CFG:PAUSE_CFG */
+#define SYS_PAUSE_CFG(r)          __REG(TARGET_SYS, 0, 1, 4296, 0, 1, 112, 0, r, 9, 4)
+
+#define SYS_PAUSE_CFG_PAUSE_START                GENMASK(18, 10)
+#define SYS_PAUSE_CFG_PAUSE_START_SET(x)\
+	FIELD_PREP(SYS_PAUSE_CFG_PAUSE_START, x)
+#define SYS_PAUSE_CFG_PAUSE_START_GET(x)\
+	FIELD_GET(SYS_PAUSE_CFG_PAUSE_START, x)
+
+#define SYS_PAUSE_CFG_PAUSE_STOP                 GENMASK(9, 1)
+#define SYS_PAUSE_CFG_PAUSE_STOP_SET(x)\
+	FIELD_PREP(SYS_PAUSE_CFG_PAUSE_STOP, x)
+#define SYS_PAUSE_CFG_PAUSE_STOP_GET(x)\
+	FIELD_GET(SYS_PAUSE_CFG_PAUSE_STOP, x)
+
+#define SYS_PAUSE_CFG_PAUSE_ENA                  BIT(0)
+#define SYS_PAUSE_CFG_PAUSE_ENA_SET(x)\
+	FIELD_PREP(SYS_PAUSE_CFG_PAUSE_ENA, x)
+#define SYS_PAUSE_CFG_PAUSE_ENA_GET(x)\
+	FIELD_GET(SYS_PAUSE_CFG_PAUSE_ENA, x)
+
+/*      SYS:PAUSE_CFG:ATOP */
+#define SYS_ATOP(r)               __REG(TARGET_SYS, 0, 1, 4296, 0, 1, 112, 40, r, 9, 4)
+
+/*      SYS:PAUSE_CFG:ATOP_TOT_CFG */
+#define SYS_ATOP_TOT_CFG          __REG(TARGET_SYS, 0, 1, 4296, 0, 1, 112, 76, 0, 1, 4)
+
+/*      SYS:PAUSE_CFG:MAC_FC_CFG */
+#define SYS_MAC_FC_CFG(r)         __REG(TARGET_SYS, 0, 1, 4296, 0, 1, 112, 80, r, 8, 4)
+
+#define SYS_MAC_FC_CFG_FC_LINK_SPEED             GENMASK(27, 26)
+#define SYS_MAC_FC_CFG_FC_LINK_SPEED_SET(x)\
+	FIELD_PREP(SYS_MAC_FC_CFG_FC_LINK_SPEED, x)
+#define SYS_MAC_FC_CFG_FC_LINK_SPEED_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_FC_LINK_SPEED, x)
+
+#define SYS_MAC_FC_CFG_FC_LATENCY_CFG            GENMASK(25, 20)
+#define SYS_MAC_FC_CFG_FC_LATENCY_CFG_SET(x)\
+	FIELD_PREP(SYS_MAC_FC_CFG_FC_LATENCY_CFG, x)
+#define SYS_MAC_FC_CFG_FC_LATENCY_CFG_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_FC_LATENCY_CFG, x)
+
+#define SYS_MAC_FC_CFG_ZERO_PAUSE_ENA            BIT(18)
+#define SYS_MAC_FC_CFG_ZERO_PAUSE_ENA_SET(x)\
+	FIELD_PREP(SYS_MAC_FC_CFG_ZERO_PAUSE_ENA, x)
+#define SYS_MAC_FC_CFG_ZERO_PAUSE_ENA_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_ZERO_PAUSE_ENA, x)
+
+#define SYS_MAC_FC_CFG_TX_FC_ENA                 BIT(17)
+#define SYS_MAC_FC_CFG_TX_FC_ENA_SET(x)\
+	FIELD_PREP(SYS_MAC_FC_CFG_TX_FC_ENA, x)
+#define SYS_MAC_FC_CFG_TX_FC_ENA_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_TX_FC_ENA, x)
+
+#define SYS_MAC_FC_CFG_RX_FC_ENA                 BIT(16)
+#define SYS_MAC_FC_CFG_RX_FC_ENA_SET(x)\
+	FIELD_PREP(SYS_MAC_FC_CFG_RX_FC_ENA, x)
+#define SYS_MAC_FC_CFG_RX_FC_ENA_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_RX_FC_ENA, x)
+
+#define SYS_MAC_FC_CFG_PAUSE_VAL_CFG             GENMASK(15, 0)
+#define SYS_MAC_FC_CFG_PAUSE_VAL_CFG_SET(x)\
+	FIELD_PREP(SYS_MAC_FC_CFG_PAUSE_VAL_CFG, x)
+#define SYS_MAC_FC_CFG_PAUSE_VAL_CFG_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_PAUSE_VAL_CFG, x)
+
+/*      SYS:STAT:CNT */
+#define SYS_CNT(g)                __REG(TARGET_SYS, 0, 1, 0, g, 896, 4, 0, 0, 1, 4)
+
+/*      SYS:RAM_CTRL:RAM_INIT */
+#define SYS_RAM_INIT              __REG(TARGET_SYS, 0, 1, 4432, 0, 1, 4, 0, 0, 1, 4)
+
+#define SYS_RAM_INIT_RAM_INIT                    BIT(1)
+#define SYS_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(SYS_RAM_INIT_RAM_INIT, x)
+#define SYS_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(SYS_RAM_INIT_RAM_INIT, x)
+
+#endif /* _LAN966X_REGS_H_ */
-- 
2.31.1

