Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2454394295
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbhE1Mg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:36:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15485 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235852AbhE1MgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622205277; x=1653741277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=12L2LXug2MYD3VjiEdQVsOOunynEimCqa+j2M5tLL1o=;
  b=A6tnmITTg5EM9zTsogiQ8bSGSQHF++XkAIMyHtBWDXyJjHfu8Vm9i+EH
   E1ZWAYbFeqQGWPRpCcbNokdO4cK29/c9NqRD80B1vz9VVNI85Ip/fJeEO
   yem0NJ/RLJ0WUH9bDbR3n7UUx1CqqYIHUIVGIGPDLgGO3C18jfEjCN15d
   Ku7SUVcDNy0WvNCzC0WUw/YOVGNzJLYI+WQ7wq0sFAP2tPPlXrfYPLyyt
   NMII7cgijbh5hNLDJjTOQbHTYS2hxWnmUSvLTMJGgaDMIBtcJx2DOiCct
   QC1BaXq83l8ODwNfkRplnqi6Ay8Qh7gCUdt/X7J0eX0UBcFo59Q8j9DEt
   A==;
IronPort-SDR: lQ/NmEm79jab5eTb9YCkL7GCYHU8hT3pCEl5PaApGa44avpgrAZswUj798leSgfi/S49dmR5xP
 UxPiJ9eJvokRP9Lh+NDvWk79ACZsDv6/HPY9YyhYy7ltmMVbApo0fsVaf+oomr0ZqSsd8mQW1z
 S/zRpsCKGde4dRSzawnW1yUYx3VVQh9m2Lq+5YF1p+m3wPFqSmgNEMFwp8rAaXlTjK1Q9CBhBf
 khXy4W4i/q+l1wZrILWzMkYvh15Oj5BF/AgDMJf9DPEaVn31ls6JlkrQvH9/S3dnSusHnvpCnW
 qiI=
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="122757455"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 May 2021 05:34:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 05:34:35 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 05:34:31 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v2 02/10] net: sparx5: add the basic sparx5 driver
Date:   Fri, 28 May 2021 14:34:11 +0200
Message-ID: <20210528123419.1142290-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528123419.1142290-1-steen.hegelund@microchip.com>
References: <20210528123419.1142290-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the Sparx5 basic SwitchDev driver framework with IO range
mapping, switch device detection and core clock configuration.

Support for ports, phylink, netdev, mactable etc. are in the following
patches.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 drivers/net/ethernet/microchip/Kconfig        |    2 +
 drivers/net/ethernet/microchip/Makefile       |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    9 +
 .../net/ethernet/microchip/sparx5/Makefile    |    8 +
 .../ethernet/microchip/sparx5/sparx5_main.c   |  744 +++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  275 +
 .../microchip/sparx5/sparx5_main_regs.h       | 4642 +++++++++++++++++
 7 files changed, 5682 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index d0f6dfe0dcf3..d54aa164c4e9 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -54,4 +54,6 @@ config LAN743X
 	  To compile this driver as a module, choose M here. The module will be
 	  called lan743x.
 
+source "drivers/net/ethernet/microchip/sparx5/Kconfig"
+
 endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/Makefile b/drivers/net/ethernet/microchip/Makefile
index da603540ca57..c77dc0379bfd 100644
--- a/drivers/net/ethernet/microchip/Makefile
+++ b/drivers/net/ethernet/microchip/Makefile
@@ -8,3 +8,5 @@ obj-$(CONFIG_ENCX24J600) += encx24j600.o encx24j600-regmap.o
 obj-$(CONFIG_LAN743X) += lan743x.o
 
 lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o
+
+obj-$(CONFIG_SPARX5_SWITCH) += sparx5/
diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
new file mode 100644
index 000000000000..a80419d8d4b5
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -0,0 +1,9 @@
+config SPARX5_SWITCH
+	tristate "Sparx5 switch driver"
+	depends on NET_SWITCHDEV
+	depends on HAS_IOMEM
+	select PHYLINK
+	select PHY_SPARX5_SERDES
+	select RESET_CONTROLLER
+	help
+	  This driver supports the Sparx5 network switch device.
diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
new file mode 100644
index 000000000000..41a31843d86f
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Microchip Sparx5 network device drivers.
+#
+
+obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
+
+sparx5-switch-objs  := sparx5_main.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
new file mode 100644
index 000000000000..43a67e5c507e
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -0,0 +1,744 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ *
+ * The Sparx5 Chip Register Model can be browsed at this location:
+ * https://github.com/microchip-ung/sparx-5_reginfo
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/of_mdio.h>
+#include <net/switchdev.h>
+#include <linux/etherdevice.h>
+#include <linux/io.h>
+#include <linux/printk.h>
+#include <linux/iopoll.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+#include <linux/reset.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+#define QLIM_WM(fraction) \
+	((SPX5_BUFFER_MEMORY / SPX5_BUFFER_CELL_SZ - 100) * (fraction) / 100)
+#define IO_RANGES 3
+
+struct initial_port_config {
+	u32 portno;
+	struct device_node *node;
+	struct sparx5_port_config conf;
+	struct phy *serdes;
+};
+
+struct sparx5_ram_config {
+	void __iomem *init_reg;
+	u32 init_val;
+};
+
+struct sparx5_main_io_resource {
+	enum sparx5_target id;
+	phys_addr_t offset;
+	int range;
+};
+
+static const struct sparx5_main_io_resource sparx5_main_iomap[] =  {
+	{ TARGET_CPU,                         0, 0 }, /* 0x600000000 */
+	{ TARGET_FDMA,                  0x80000, 0 }, /* 0x600080000 */
+	{ TARGET_PCEP,                 0x400000, 0 }, /* 0x600400000 */
+	{ TARGET_DEV2G5,             0x10004000, 1 }, /* 0x610004000 */
+	{ TARGET_DEV5G,              0x10008000, 1 }, /* 0x610008000 */
+	{ TARGET_PCS5G_BR,           0x1000c000, 1 }, /* 0x61000c000 */
+	{ TARGET_DEV2G5 +  1,        0x10010000, 1 }, /* 0x610010000 */
+	{ TARGET_DEV5G +  1,         0x10014000, 1 }, /* 0x610014000 */
+	{ TARGET_PCS5G_BR +  1,      0x10018000, 1 }, /* 0x610018000 */
+	{ TARGET_DEV2G5 +  2,        0x1001c000, 1 }, /* 0x61001c000 */
+	{ TARGET_DEV5G +  2,         0x10020000, 1 }, /* 0x610020000 */
+	{ TARGET_PCS5G_BR +  2,      0x10024000, 1 }, /* 0x610024000 */
+	{ TARGET_DEV2G5 +  6,        0x10028000, 1 }, /* 0x610028000 */
+	{ TARGET_DEV5G +  6,         0x1002c000, 1 }, /* 0x61002c000 */
+	{ TARGET_PCS5G_BR +  6,      0x10030000, 1 }, /* 0x610030000 */
+	{ TARGET_DEV2G5 +  7,        0x10034000, 1 }, /* 0x610034000 */
+	{ TARGET_DEV5G +  7,         0x10038000, 1 }, /* 0x610038000 */
+	{ TARGET_PCS5G_BR +  7,      0x1003c000, 1 }, /* 0x61003c000 */
+	{ TARGET_DEV2G5 +  8,        0x10040000, 1 }, /* 0x610040000 */
+	{ TARGET_DEV5G +  8,         0x10044000, 1 }, /* 0x610044000 */
+	{ TARGET_PCS5G_BR +  8,      0x10048000, 1 }, /* 0x610048000 */
+	{ TARGET_DEV2G5 +  9,        0x1004c000, 1 }, /* 0x61004c000 */
+	{ TARGET_DEV5G +  9,         0x10050000, 1 }, /* 0x610050000 */
+	{ TARGET_PCS5G_BR +  9,      0x10054000, 1 }, /* 0x610054000 */
+	{ TARGET_DEV2G5 + 10,        0x10058000, 1 }, /* 0x610058000 */
+	{ TARGET_DEV5G + 10,         0x1005c000, 1 }, /* 0x61005c000 */
+	{ TARGET_PCS5G_BR + 10,      0x10060000, 1 }, /* 0x610060000 */
+	{ TARGET_DEV2G5 + 11,        0x10064000, 1 }, /* 0x610064000 */
+	{ TARGET_DEV5G + 11,         0x10068000, 1 }, /* 0x610068000 */
+	{ TARGET_PCS5G_BR + 11,      0x1006c000, 1 }, /* 0x61006c000 */
+	{ TARGET_DEV2G5 + 12,        0x10070000, 1 }, /* 0x610070000 */
+	{ TARGET_DEV10G,             0x10074000, 1 }, /* 0x610074000 */
+	{ TARGET_PCS10G_BR,          0x10078000, 1 }, /* 0x610078000 */
+	{ TARGET_DEV2G5 + 14,        0x1007c000, 1 }, /* 0x61007c000 */
+	{ TARGET_DEV10G +  2,        0x10080000, 1 }, /* 0x610080000 */
+	{ TARGET_PCS10G_BR +  2,     0x10084000, 1 }, /* 0x610084000 */
+	{ TARGET_DEV2G5 + 15,        0x10088000, 1 }, /* 0x610088000 */
+	{ TARGET_DEV10G +  3,        0x1008c000, 1 }, /* 0x61008c000 */
+	{ TARGET_PCS10G_BR +  3,     0x10090000, 1 }, /* 0x610090000 */
+	{ TARGET_DEV2G5 + 16,        0x10094000, 1 }, /* 0x610094000 */
+	{ TARGET_DEV2G5 + 17,        0x10098000, 1 }, /* 0x610098000 */
+	{ TARGET_DEV2G5 + 18,        0x1009c000, 1 }, /* 0x61009c000 */
+	{ TARGET_DEV2G5 + 19,        0x100a0000, 1 }, /* 0x6100a0000 */
+	{ TARGET_DEV2G5 + 20,        0x100a4000, 1 }, /* 0x6100a4000 */
+	{ TARGET_DEV2G5 + 21,        0x100a8000, 1 }, /* 0x6100a8000 */
+	{ TARGET_DEV2G5 + 22,        0x100ac000, 1 }, /* 0x6100ac000 */
+	{ TARGET_DEV2G5 + 23,        0x100b0000, 1 }, /* 0x6100b0000 */
+	{ TARGET_DEV2G5 + 32,        0x100b4000, 1 }, /* 0x6100b4000 */
+	{ TARGET_DEV2G5 + 33,        0x100b8000, 1 }, /* 0x6100b8000 */
+	{ TARGET_DEV2G5 + 34,        0x100bc000, 1 }, /* 0x6100bc000 */
+	{ TARGET_DEV2G5 + 35,        0x100c0000, 1 }, /* 0x6100c0000 */
+	{ TARGET_DEV2G5 + 36,        0x100c4000, 1 }, /* 0x6100c4000 */
+	{ TARGET_DEV2G5 + 37,        0x100c8000, 1 }, /* 0x6100c8000 */
+	{ TARGET_DEV2G5 + 38,        0x100cc000, 1 }, /* 0x6100cc000 */
+	{ TARGET_DEV2G5 + 39,        0x100d0000, 1 }, /* 0x6100d0000 */
+	{ TARGET_DEV2G5 + 40,        0x100d4000, 1 }, /* 0x6100d4000 */
+	{ TARGET_DEV2G5 + 41,        0x100d8000, 1 }, /* 0x6100d8000 */
+	{ TARGET_DEV2G5 + 42,        0x100dc000, 1 }, /* 0x6100dc000 */
+	{ TARGET_DEV2G5 + 43,        0x100e0000, 1 }, /* 0x6100e0000 */
+	{ TARGET_DEV2G5 + 44,        0x100e4000, 1 }, /* 0x6100e4000 */
+	{ TARGET_DEV2G5 + 45,        0x100e8000, 1 }, /* 0x6100e8000 */
+	{ TARGET_DEV2G5 + 46,        0x100ec000, 1 }, /* 0x6100ec000 */
+	{ TARGET_DEV2G5 + 47,        0x100f0000, 1 }, /* 0x6100f0000 */
+	{ TARGET_DEV2G5 + 57,        0x100f4000, 1 }, /* 0x6100f4000 */
+	{ TARGET_DEV25G +  1,        0x100f8000, 1 }, /* 0x6100f8000 */
+	{ TARGET_PCS25G_BR +  1,     0x100fc000, 1 }, /* 0x6100fc000 */
+	{ TARGET_DEV2G5 + 59,        0x10104000, 1 }, /* 0x610104000 */
+	{ TARGET_DEV25G +  3,        0x10108000, 1 }, /* 0x610108000 */
+	{ TARGET_PCS25G_BR +  3,     0x1010c000, 1 }, /* 0x61010c000 */
+	{ TARGET_DEV2G5 + 60,        0x10114000, 1 }, /* 0x610114000 */
+	{ TARGET_DEV25G +  4,        0x10118000, 1 }, /* 0x610118000 */
+	{ TARGET_PCS25G_BR +  4,     0x1011c000, 1 }, /* 0x61011c000 */
+	{ TARGET_DEV2G5 + 64,        0x10124000, 1 }, /* 0x610124000 */
+	{ TARGET_DEV5G + 12,         0x10128000, 1 }, /* 0x610128000 */
+	{ TARGET_PCS5G_BR + 12,      0x1012c000, 1 }, /* 0x61012c000 */
+	{ TARGET_PORT_CONF,          0x10130000, 1 }, /* 0x610130000 */
+	{ TARGET_DEV2G5 +  3,        0x10404000, 1 }, /* 0x610404000 */
+	{ TARGET_DEV5G +  3,         0x10408000, 1 }, /* 0x610408000 */
+	{ TARGET_PCS5G_BR +  3,      0x1040c000, 1 }, /* 0x61040c000 */
+	{ TARGET_DEV2G5 +  4,        0x10410000, 1 }, /* 0x610410000 */
+	{ TARGET_DEV5G +  4,         0x10414000, 1 }, /* 0x610414000 */
+	{ TARGET_PCS5G_BR +  4,      0x10418000, 1 }, /* 0x610418000 */
+	{ TARGET_DEV2G5 +  5,        0x1041c000, 1 }, /* 0x61041c000 */
+	{ TARGET_DEV5G +  5,         0x10420000, 1 }, /* 0x610420000 */
+	{ TARGET_PCS5G_BR +  5,      0x10424000, 1 }, /* 0x610424000 */
+	{ TARGET_DEV2G5 + 13,        0x10428000, 1 }, /* 0x610428000 */
+	{ TARGET_DEV10G +  1,        0x1042c000, 1 }, /* 0x61042c000 */
+	{ TARGET_PCS10G_BR +  1,     0x10430000, 1 }, /* 0x610430000 */
+	{ TARGET_DEV2G5 + 24,        0x10434000, 1 }, /* 0x610434000 */
+	{ TARGET_DEV2G5 + 25,        0x10438000, 1 }, /* 0x610438000 */
+	{ TARGET_DEV2G5 + 26,        0x1043c000, 1 }, /* 0x61043c000 */
+	{ TARGET_DEV2G5 + 27,        0x10440000, 1 }, /* 0x610440000 */
+	{ TARGET_DEV2G5 + 28,        0x10444000, 1 }, /* 0x610444000 */
+	{ TARGET_DEV2G5 + 29,        0x10448000, 1 }, /* 0x610448000 */
+	{ TARGET_DEV2G5 + 30,        0x1044c000, 1 }, /* 0x61044c000 */
+	{ TARGET_DEV2G5 + 31,        0x10450000, 1 }, /* 0x610450000 */
+	{ TARGET_DEV2G5 + 48,        0x10454000, 1 }, /* 0x610454000 */
+	{ TARGET_DEV10G +  4,        0x10458000, 1 }, /* 0x610458000 */
+	{ TARGET_PCS10G_BR +  4,     0x1045c000, 1 }, /* 0x61045c000 */
+	{ TARGET_DEV2G5 + 49,        0x10460000, 1 }, /* 0x610460000 */
+	{ TARGET_DEV10G +  5,        0x10464000, 1 }, /* 0x610464000 */
+	{ TARGET_PCS10G_BR +  5,     0x10468000, 1 }, /* 0x610468000 */
+	{ TARGET_DEV2G5 + 50,        0x1046c000, 1 }, /* 0x61046c000 */
+	{ TARGET_DEV10G +  6,        0x10470000, 1 }, /* 0x610470000 */
+	{ TARGET_PCS10G_BR +  6,     0x10474000, 1 }, /* 0x610474000 */
+	{ TARGET_DEV2G5 + 51,        0x10478000, 1 }, /* 0x610478000 */
+	{ TARGET_DEV10G +  7,        0x1047c000, 1 }, /* 0x61047c000 */
+	{ TARGET_PCS10G_BR +  7,     0x10480000, 1 }, /* 0x610480000 */
+	{ TARGET_DEV2G5 + 52,        0x10484000, 1 }, /* 0x610484000 */
+	{ TARGET_DEV10G +  8,        0x10488000, 1 }, /* 0x610488000 */
+	{ TARGET_PCS10G_BR +  8,     0x1048c000, 1 }, /* 0x61048c000 */
+	{ TARGET_DEV2G5 + 53,        0x10490000, 1 }, /* 0x610490000 */
+	{ TARGET_DEV10G +  9,        0x10494000, 1 }, /* 0x610494000 */
+	{ TARGET_PCS10G_BR +  9,     0x10498000, 1 }, /* 0x610498000 */
+	{ TARGET_DEV2G5 + 54,        0x1049c000, 1 }, /* 0x61049c000 */
+	{ TARGET_DEV10G + 10,        0x104a0000, 1 }, /* 0x6104a0000 */
+	{ TARGET_PCS10G_BR + 10,     0x104a4000, 1 }, /* 0x6104a4000 */
+	{ TARGET_DEV2G5 + 55,        0x104a8000, 1 }, /* 0x6104a8000 */
+	{ TARGET_DEV10G + 11,        0x104ac000, 1 }, /* 0x6104ac000 */
+	{ TARGET_PCS10G_BR + 11,     0x104b0000, 1 }, /* 0x6104b0000 */
+	{ TARGET_DEV2G5 + 56,        0x104b4000, 1 }, /* 0x6104b4000 */
+	{ TARGET_DEV25G,             0x104b8000, 1 }, /* 0x6104b8000 */
+	{ TARGET_PCS25G_BR,          0x104bc000, 1 }, /* 0x6104bc000 */
+	{ TARGET_DEV2G5 + 58,        0x104c4000, 1 }, /* 0x6104c4000 */
+	{ TARGET_DEV25G +  2,        0x104c8000, 1 }, /* 0x6104c8000 */
+	{ TARGET_PCS25G_BR +  2,     0x104cc000, 1 }, /* 0x6104cc000 */
+	{ TARGET_DEV2G5 + 61,        0x104d4000, 1 }, /* 0x6104d4000 */
+	{ TARGET_DEV25G +  5,        0x104d8000, 1 }, /* 0x6104d8000 */
+	{ TARGET_PCS25G_BR +  5,     0x104dc000, 1 }, /* 0x6104dc000 */
+	{ TARGET_DEV2G5 + 62,        0x104e4000, 1 }, /* 0x6104e4000 */
+	{ TARGET_DEV25G +  6,        0x104e8000, 1 }, /* 0x6104e8000 */
+	{ TARGET_PCS25G_BR +  6,     0x104ec000, 1 }, /* 0x6104ec000 */
+	{ TARGET_DEV2G5 + 63,        0x104f4000, 1 }, /* 0x6104f4000 */
+	{ TARGET_DEV25G +  7,        0x104f8000, 1 }, /* 0x6104f8000 */
+	{ TARGET_PCS25G_BR +  7,     0x104fc000, 1 }, /* 0x6104fc000 */
+	{ TARGET_DSM,                0x10504000, 1 }, /* 0x610504000 */
+	{ TARGET_ASM,                0x10600000, 1 }, /* 0x610600000 */
+	{ TARGET_GCB,                0x11010000, 2 }, /* 0x611010000 */
+	{ TARGET_QS,                 0x11030000, 2 }, /* 0x611030000 */
+	{ TARGET_ANA_ACL,            0x11050000, 2 }, /* 0x611050000 */
+	{ TARGET_LRN,                0x11060000, 2 }, /* 0x611060000 */
+	{ TARGET_VCAP_SUPER,         0x11080000, 2 }, /* 0x611080000 */
+	{ TARGET_QSYS,               0x110a0000, 2 }, /* 0x6110a0000 */
+	{ TARGET_QFWD,               0x110b0000, 2 }, /* 0x6110b0000 */
+	{ TARGET_XQS,                0x110c0000, 2 }, /* 0x6110c0000 */
+	{ TARGET_CLKGEN,             0x11100000, 2 }, /* 0x611100000 */
+	{ TARGET_ANA_AC_POL,         0x11200000, 2 }, /* 0x611200000 */
+	{ TARGET_QRES,               0x11280000, 2 }, /* 0x611280000 */
+	{ TARGET_EACL,               0x112c0000, 2 }, /* 0x6112c0000 */
+	{ TARGET_ANA_CL,             0x11400000, 2 }, /* 0x611400000 */
+	{ TARGET_ANA_L3,             0x11480000, 2 }, /* 0x611480000 */
+	{ TARGET_HSCH,               0x11580000, 2 }, /* 0x611580000 */
+	{ TARGET_REW,                0x11600000, 2 }, /* 0x611600000 */
+	{ TARGET_ANA_L2,             0x11800000, 2 }, /* 0x611800000 */
+	{ TARGET_ANA_AC,             0x11900000, 2 }, /* 0x611900000 */
+	{ TARGET_VOP,                0x11a00000, 2 }, /* 0x611a00000 */
+};
+
+static int sparx5_create_targets(struct sparx5 *sparx5)
+{
+	struct resource *iores[IO_RANGES];
+	void __iomem *iomem[IO_RANGES];
+	void __iomem *begin[IO_RANGES];
+	int range_id[IO_RANGES];
+	int idx, jdx;
+
+	for (idx = 0, jdx = 0; jdx < ARRAY_SIZE(sparx5_main_iomap); jdx++) {
+		const struct sparx5_main_io_resource *iomap = &sparx5_main_iomap[jdx];
+
+		if (idx == iomap->range) {
+			range_id[idx] = jdx;
+			idx++;
+		}
+	}
+	for (idx = 0; idx < IO_RANGES; idx++) {
+		iores[idx] = platform_get_resource(sparx5->pdev, IORESOURCE_MEM,
+						   idx);
+		iomem[idx] = devm_ioremap(sparx5->dev,
+					  iores[idx]->start,
+					  iores[idx]->end - iores[idx]->start
+					  + 1);
+		if (IS_ERR(iomem[idx])) {
+			dev_err(sparx5->dev, "Unable to get switch registers: %s\n",
+				iores[idx]->name);
+			return PTR_ERR(iomem[idx]);
+		}
+		begin[idx] = iomem[idx] - sparx5_main_iomap[range_id[idx]].offset;
+	}
+	for (jdx = 0; jdx < ARRAY_SIZE(sparx5_main_iomap); jdx++) {
+		const struct sparx5_main_io_resource *iomap = &sparx5_main_iomap[jdx];
+
+		sparx5->regs[iomap->id] = begin[iomap->range] + iomap->offset;
+	}
+	return 0;
+}
+
+static int sparx5_create_port(struct sparx5 *sparx5,
+			      struct initial_port_config *config)
+{
+	struct sparx5_port *spx5_port;
+
+	/* netdev creation to be added in later patches */
+	spx5_port = devm_kzalloc(sparx5->dev, sizeof(*spx5_port), GFP_KERNEL);
+	spx5_port->of_node = config->node;
+	spx5_port->serdes = config->serdes;
+	spx5_port->pvid = NULL_VID;
+	spx5_port->signd_internal = true;
+	spx5_port->signd_active_high = true;
+	spx5_port->signd_enable = true;
+	spx5_port->max_vlan_tags = SPX5_PORT_MAX_TAGS_NONE;
+	spx5_port->vlan_type = SPX5_VLAN_PORT_TYPE_UNAWARE;
+	spx5_port->custom_etype = 0x8880; /* Vitesse */
+
+	/* PHYLINK support to be added in later patches */
+
+	return 0;
+}
+
+static int sparx5_init_ram(struct sparx5 *s5)
+{
+	const struct sparx5_ram_config spx5_ram_cfg[] = {
+		{spx5_reg_get(s5, ANA_AC_STAT_RESET), ANA_AC_STAT_RESET_RESET},
+		{spx5_reg_get(s5, ASM_STAT_CFG), ASM_STAT_CFG_STAT_CNT_CLR_SHOT},
+		{spx5_reg_get(s5, QSYS_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, REW_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, VOP_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, ANA_AC_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, ASM_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, EACL_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, VCAP_SUPER_RAM_INIT), QSYS_RAM_INIT_RAM_INIT},
+		{spx5_reg_get(s5, DSM_RAM_INIT), QSYS_RAM_INIT_RAM_INIT}
+	};
+	const struct sparx5_ram_config *cfg;
+	u32 value, pending, jdx, idx;
+
+	for (jdx = 0; jdx < 10; jdx++) {
+		pending = ARRAY_SIZE(spx5_ram_cfg);
+		for (idx = 0; idx < ARRAY_SIZE(spx5_ram_cfg); idx++) {
+			cfg = &spx5_ram_cfg[idx];
+			if (jdx == 0) {
+				writel(cfg->init_val, cfg->init_reg);
+			} else {
+				value = readl(cfg->init_reg);
+				if ((value & cfg->init_val) != cfg->init_val)
+					pending--;
+			}
+		}
+		if (!pending)
+			break;
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+	}
+
+	if (pending > 0) {
+		/* Still initializing, should be complete in
+		 * less than 1ms
+		 */
+		dev_err(s5->dev, "Memory initialization error\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int sparx5_init_switchcore(struct sparx5 *sparx5)
+{
+	u32 value;
+
+	spx5_rmw(EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(1),
+		 EACL_POL_EACL_CFG_EACL_FORCE_INIT,
+		 sparx5,
+		 EACL_POL_EACL_CFG);
+
+	spx5_rmw(EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(0),
+		 EACL_POL_EACL_CFG_EACL_FORCE_INIT,
+		 sparx5,
+		 EACL_POL_EACL_CFG);
+
+	/* Initialize memories, if not done already */
+	value = spx5_rd(sparx5, HSCH_RESET_CFG);
+	if (!(value & HSCH_RESET_CFG_CORE_ENA))
+		sparx5_init_ram(sparx5);
+
+	/* Reset counters */
+	spx5_wr(ANA_AC_STAT_RESET_RESET_SET(1), sparx5, ANA_AC_STAT_RESET);
+	spx5_wr(ASM_STAT_CFG_STAT_CNT_CLR_SHOT_SET(1), sparx5, ASM_STAT_CFG);
+
+	/* Enable switch-core and queue system */
+	spx5_wr(HSCH_RESET_CFG_CORE_ENA_SET(1), sparx5, HSCH_RESET_CFG);
+
+	return 0;
+}
+
+static int sparx5_init_coreclock(struct sparx5 *sparx5)
+{
+	enum sparx5_core_clockfreq freq = sparx5->coreclock;
+	u32 clk_div, clk_period, pol_upd_int, idx;
+
+	/* Verify if core clock frequency is supported on target.
+	 * If 'VTSS_CORE_CLOCK_DEFAULT' then the highest supported
+	 * freq. is used
+	 */
+	switch (sparx5->target_ct) {
+	case SPX5_TARGET_CT_7546:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_250MHZ;
+		else if (sparx5->coreclock != SPX5_CORE_CLOCK_250MHZ)
+			freq = 0; /* Not supported */
+		break;
+	case SPX5_TARGET_CT_7549:
+	case SPX5_TARGET_CT_7552:
+	case SPX5_TARGET_CT_7556:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_500MHZ;
+		else if (sparx5->coreclock != SPX5_CORE_CLOCK_500MHZ)
+			freq = 0; /* Not supported */
+		break;
+	case SPX5_TARGET_CT_7558:
+	case SPX5_TARGET_CT_7558TSN:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_625MHZ;
+		else if (sparx5->coreclock != SPX5_CORE_CLOCK_625MHZ)
+			freq = 0; /* Not supported */
+		break;
+	case SPX5_TARGET_CT_7546TSN:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_625MHZ;
+		break;
+	case SPX5_TARGET_CT_7549TSN:
+	case SPX5_TARGET_CT_7552TSN:
+	case SPX5_TARGET_CT_7556TSN:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_625MHZ;
+		else if (sparx5->coreclock == SPX5_CORE_CLOCK_250MHZ)
+			freq = 0; /* Not supported */
+		break;
+	default:
+		dev_err(sparx5->dev, "Target (%#04x) not supported\n",
+			sparx5->target_ct);
+		return -ENODEV;
+	}
+
+	switch (freq) {
+	case SPX5_CORE_CLOCK_250MHZ:
+		clk_div = 10;
+		pol_upd_int = 312;
+		break;
+	case SPX5_CORE_CLOCK_500MHZ:
+		clk_div = 5;
+		pol_upd_int = 624;
+		break;
+	case SPX5_CORE_CLOCK_625MHZ:
+		clk_div = 4;
+		pol_upd_int = 780;
+		break;
+	default:
+		dev_err(sparx5->dev, "%d coreclock not supported on (%#04x)\n",
+			sparx5->coreclock, sparx5->target_ct);
+		return -EINVAL;
+	}
+
+	/* Update state with chosen frequency */
+	sparx5->coreclock = freq;
+
+	/* Configure the LCPLL */
+	spx5_rmw(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV_SET(clk_div) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA_SET(1),
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA,
+		 sparx5,
+		 CLKGEN_LCPLL1_CORE_CLK_CFG);
+
+	clk_period = sparx5_clk_period(freq);
+
+	spx5_rmw(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_SET(clk_period / 100),
+		 HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS,
+		 sparx5,
+		 HSCH_SYS_CLK_PER);
+
+	spx5_rmw(ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS_SET(clk_period / 100),
+		 ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS,
+		 sparx5,
+		 ANA_AC_POL_BDLB_DLB_CTRL);
+
+	spx5_rmw(ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS_SET(clk_period / 100),
+		 ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS,
+		 sparx5,
+		 ANA_AC_POL_SLB_DLB_CTRL);
+
+	spx5_rmw(LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS_SET(clk_period / 100),
+		 LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS,
+		 sparx5,
+		 LRN_AUTOAGE_CFG_1);
+
+	for (idx = 0; idx < 3; idx++) {
+		spx5_rmw(GCB_SIO_CLOCK_SYS_CLK_PERIOD_SET(clk_period / 100),
+			 GCB_SIO_CLOCK_SYS_CLK_PERIOD,
+			 sparx5,
+			 GCB_SIO_CLOCK(idx));
+	}
+
+	spx5_rmw(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_SET
+		 ((256 * 1000) / clk_period),
+		 HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY,
+		 sparx5,
+		 HSCH_TAS_STATEMACHINE_CFG);
+
+	spx5_rmw(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_SET(pol_upd_int),
+		 ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT,
+		 sparx5,
+		 ANA_AC_POL_POL_UPD_INT_CFG);
+
+	return 0;
+}
+
+static int sparx5_qlim_set(struct sparx5 *sparx5)
+{
+	u32 res, dp, prio;
+
+	for (res = 0; res < 2; res++) {
+		for (prio = 0; prio < 8; prio++)
+			spx5_wr(0xFFF, sparx5,
+				QRES_RES_CFG(prio + 630 + res * 1024));
+
+		for (dp = 0; dp < 4; dp++)
+			spx5_wr(0xFFF, sparx5,
+				QRES_RES_CFG(dp + 638 + res * 1024));
+	}
+
+	/* Set 80,90,95,100% of memory size for top watermarks */
+	spx5_wr(QLIM_WM(80), sparx5, XQS_QLIMIT_SHR_QLIM_CFG(0));
+	spx5_wr(QLIM_WM(90), sparx5, XQS_QLIMIT_SHR_CTOP_CFG(0));
+	spx5_wr(QLIM_WM(95), sparx5, XQS_QLIMIT_SHR_ATOP_CFG(0));
+	spx5_wr(QLIM_WM(100), sparx5, XQS_QLIMIT_SHR_TOP_CFG(0));
+
+	return 0;
+}
+
+/* Some boards needs to map the SGPIO for signal detect explicitly to the
+ * port module
+ */
+static void sparx5_board_init(struct sparx5 *sparx5)
+{
+	int idx;
+
+	if (!sparx5->sd_sgpio_remapping)
+		return;
+
+	/* Enable SGPIO Signal Detect remapping */
+	spx5_rmw(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
+		 GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
+		 sparx5,
+		 GCB_HW_SGPIO_SD_CFG);
+
+	/* Refer to LOS SGPIO */
+	for (idx = 0; idx < SPX5_PORTS; idx++) {
+		if (sparx5->ports[idx]) {
+			if (sparx5->ports[idx]->conf.sd_sgpio != ~0) {
+				spx5_wr(sparx5->ports[idx]->conf.sd_sgpio,
+					sparx5,
+					GCB_HW_SGPIO_TO_SD_MAP_CFG(idx));
+			}
+		}
+	}
+}
+
+static int sparx5_start(struct sparx5 *sparx5)
+{
+	u32 idx;
+
+	/* Setup own UPSIDs */
+	for (idx = 0; idx < 3; idx++) {
+		spx5_wr(idx, sparx5, ANA_AC_OWN_UPSID(idx));
+		spx5_wr(idx, sparx5, ANA_CL_OWN_UPSID(idx));
+		spx5_wr(idx, sparx5, ANA_L2_OWN_UPSID(idx));
+		spx5_wr(idx, sparx5, REW_OWN_UPSID(idx));
+	}
+
+	/* Enable CPU ports */
+	for (idx = SPX5_PORTS; idx < SPX5_PORTS_ALL; idx++) {
+		spx5_rmw(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(1),
+			 QFWD_SWITCH_PORT_MODE_PORT_ENA,
+			 sparx5,
+			 QFWD_SWITCH_PORT_MODE(idx));
+	}
+
+	/* Forwarding masks to be added in later patches */
+	/* CPU copy CPU pgids */
+	spx5_wr(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
+		sparx5, ANA_AC_PGID_MISC_CFG(PGID_CPU));
+	spx5_wr(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
+		sparx5, ANA_AC_PGID_MISC_CFG(PGID_BCAST));
+
+	/* Recalc injected frame FCS */
+	for (idx = SPX5_PORT_CPU_0; idx <= SPX5_PORT_CPU_1; idx++)
+		spx5_rmw(ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA_SET(1),
+			 ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA,
+			 sparx5, ANA_CL_FILTER_CTRL(idx));
+
+	/* MAC/VLAN support to be added in later patches */
+	/* Enable queue limitation watermarks */
+	sparx5_qlim_set(sparx5);
+
+	/* netdev and resource calendar support to be added in later patches */
+
+	sparx5_board_init(sparx5);
+
+	/* Injection/Extraction config to be added in later patches */
+
+	return 0;
+}
+
+static int mchp_sparx5_probe(struct platform_device *pdev)
+{
+	struct initial_port_config *configs, *config;
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *ports, *portnp;
+	struct sparx5 *sparx5;
+	int idx = 0, err = 0;
+	u8 *mac_addr;
+
+	if (!np && !pdev->dev.platform_data)
+		return -ENODEV;
+
+	sparx5 = devm_kzalloc(&pdev->dev, sizeof(*sparx5), GFP_KERNEL);
+	if (!sparx5)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, sparx5);
+	sparx5->pdev = pdev;
+	sparx5->dev = &pdev->dev;
+
+	sparx5->reset = devm_reset_control_get_shared(&pdev->dev, "switch");
+	if (IS_ERR(sparx5->reset)) {
+		dev_warn(sparx5->dev, "Could not obtain reset control: %ld\n",
+			 PTR_ERR(sparx5->reset));
+		sparx5->reset = NULL;
+	} else {
+		reset_control_reset(sparx5->reset);
+	}
+
+	/* Default values, some from DT */
+	sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
+
+	ports = of_get_child_by_name(np, "ethernet-ports");
+	if (!ports) {
+		dev_err(sparx5->dev, "no ethernet-ports child node found\n");
+		return -ENODEV;
+	}
+	sparx5->port_count = of_get_child_count(ports);
+
+	configs = kcalloc(sparx5->port_count,
+			  sizeof(struct initial_port_config), GFP_KERNEL);
+	if (!configs)
+		return -ENOMEM;
+
+	for_each_available_child_of_node(ports, portnp) {
+		struct sparx5_port_config *conf;
+		struct phy *serdes;
+		u32 portno;
+
+		err = of_property_read_u32(portnp, "reg", &portno);
+		if (err) {
+			dev_err(sparx5->dev, "port reg property error\n");
+			continue;
+		}
+		config = &configs[idx];
+		conf = &config->conf;
+		err = of_get_phy_mode(portnp, &conf->phy_mode);
+		if (err) {
+			dev_err(sparx5->dev, "port %u: missing phy-mode\n",
+				portno);
+			continue;
+		}
+		err = of_property_read_u32(portnp, "microchip,bandwidth",
+					   &conf->bandwidth);
+		if (err) {
+			dev_err(sparx5->dev, "port %u: missing bandwidth\n",
+				portno);
+			continue;
+		}
+		err = of_property_read_u32(portnp, "microchip,sd-sgpio", &conf->sd_sgpio);
+		if (err)
+			conf->sd_sgpio = ~0;
+		else
+			sparx5->sd_sgpio_remapping = true;
+		serdes = devm_of_phy_get(sparx5->dev, portnp, NULL);
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			if (err != -EPROBE_DEFER)
+				dev_err(sparx5->dev,
+					"port %u: missing serdes\n",
+					portno);
+			goto cleanup_config;
+		}
+		config->portno = portno;
+		config->node = portnp;
+		config->serdes = serdes;
+
+		conf->media = PHY_MEDIA_DAC;
+		conf->serdes_reset = true;
+		conf->portmode = conf->phy_mode;
+		if (of_find_property(portnp, "sfp", NULL)) {
+			conf->has_sfp = true;
+			conf->power_down = true;
+		}
+		idx++;
+	}
+
+	err = sparx5_create_targets(sparx5);
+	if (err)
+		goto cleanup_config;
+
+	if (of_get_mac_address(np, mac_addr)) {
+		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
+		eth_random_addr(sparx5->base_mac);
+		sparx5->base_mac[5] = 0;
+	} else {
+		ether_addr_copy(sparx5->base_mac, mac_addr);
+	}
+
+	/* Inj/Xtr IRQ support to be added in later patches */
+	/* Read chip ID to check CPU interface */
+	sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
+
+	sparx5->target_ct = (enum spx5_target_chiptype)
+		GCB_CHIP_ID_PART_ID_GET(sparx5->chip_id);
+
+	/* Initialize Switchcore and internal RAMs */
+	if (sparx5_init_switchcore(sparx5)) {
+		dev_err(sparx5->dev, "Switchcore initialization error\n");
+		goto cleanup_config;
+	}
+
+	/* Initialize the LC-PLL (core clock) and set affected registers */
+	if (sparx5_init_coreclock(sparx5)) {
+		dev_err(sparx5->dev, "LC-PLL initialization error\n");
+		goto cleanup_config;
+	}
+
+	for (idx = 0; idx < sparx5->port_count; ++idx) {
+		config = &configs[idx];
+		if (!config->node)
+			continue;
+
+		err = sparx5_create_port(sparx5, config);
+		if (err) {
+			dev_err(sparx5->dev, "port create error\n");
+			goto cleanup_ports;
+		}
+	}
+
+	if (sparx5_start(sparx5)) {
+		dev_err(sparx5->dev, "Start failed\n");
+		goto cleanup_ports;
+	}
+
+	kfree(configs);
+	return err;
+
+cleanup_ports:
+	/* Port cleanup to be added in later patches */
+cleanup_config:
+	kfree(configs);
+	return err;
+}
+
+static const struct of_device_id mchp_sparx5_match[] = {
+	{ .compatible = "microchip,sparx5-switch" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, mchp_sparx5_match);
+
+static struct platform_driver mchp_sparx5_driver = {
+	.probe = mchp_sparx5_probe,
+	.driver = {
+		.name = "sparx5-switch",
+		.of_match_table = mchp_sparx5_match,
+	},
+};
+
+module_platform_driver(mchp_sparx5_driver);
+
+MODULE_DESCRIPTION("Microchip Sparx5 switch driver");
+MODULE_AUTHOR("Steen Hegelund <steen.hegelund@microchip.com>");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
new file mode 100644
index 000000000000..c714af96c5d9
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -0,0 +1,275 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_MAIN_H__
+#define __SPARX5_MAIN_H__
+
+#include <linux/types.h>
+#include <linux/phy/phy.h>
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/if_vlan.h>
+#include <linux/bitmap.h>
+#include <linux/phylink.h>
+
+/* Target chip type */
+enum spx5_target_chiptype {
+	SPX5_TARGET_CT_7546    = 0x7546,  /* SparX-5-64  Enterprise */
+	SPX5_TARGET_CT_7549    = 0x7549,  /* SparX-5-90  Enterprise */
+	SPX5_TARGET_CT_7552    = 0x7552,  /* SparX-5-128 Enterprise */
+	SPX5_TARGET_CT_7556    = 0x7556,  /* SparX-5-160 Enterprise */
+	SPX5_TARGET_CT_7558    = 0x7558,  /* SparX-5-200 Enterprise */
+	SPX5_TARGET_CT_7546TSN = 0x47546, /* SparX-5-64i Industrial */
+	SPX5_TARGET_CT_7549TSN = 0x47549, /* SparX-5-90i Industrial */
+	SPX5_TARGET_CT_7552TSN = 0x47552, /* SparX-5-128i Industrial */
+	SPX5_TARGET_CT_7556TSN = 0x47556, /* SparX-5-160i Industrial */
+	SPX5_TARGET_CT_7558TSN = 0x47558, /* SparX-5-200i Industrial */
+};
+
+enum sparx5_port_max_tags {
+	SPX5_PORT_MAX_TAGS_NONE,  /* No extra tags allowed */
+	SPX5_PORT_MAX_TAGS_ONE,   /* Single tag allowed */
+	SPX5_PORT_MAX_TAGS_TWO    /* Single and double tag allowed */
+};
+
+enum sparx5_vlan_port_type {
+	SPX5_VLAN_PORT_TYPE_UNAWARE, /* VLAN unaware port */
+	SPX5_VLAN_PORT_TYPE_C,       /* C-port */
+	SPX5_VLAN_PORT_TYPE_S,       /* S-port */
+	SPX5_VLAN_PORT_TYPE_S_CUSTOM /* S-port using custom type */
+};
+
+#define SPX5_PORTS             65
+#define SPX5_PORT_CPU          (SPX5_PORTS)  /* Next port is CPU port */
+#define SPX5_PORT_CPU_0        (SPX5_PORT_CPU + 0) /* CPU Port 65 */
+#define SPX5_PORT_CPU_1        (SPX5_PORT_CPU + 1) /* CPU Port 66 */
+#define SPX5_PORT_VD0          (SPX5_PORT_CPU + 2) /* VD0/Port 67 used for IPMC */
+#define SPX5_PORT_VD1          (SPX5_PORT_CPU + 3) /* VD1/Port 68 used for AFI/OAM */
+#define SPX5_PORT_VD2          (SPX5_PORT_CPU + 4) /* VD2/Port 69 used for IPinIP*/
+#define SPX5_PORTS_ALL         (SPX5_PORT_CPU + 5) /* Total number of ports */
+
+#define PGID_BASE              SPX5_PORTS /* Starts after port PGIDs */
+#define PGID_UC_FLOOD          (PGID_BASE + 0)
+#define PGID_MC_FLOOD          (PGID_BASE + 1)
+#define PGID_IPV4_MC_DATA      (PGID_BASE + 2)
+#define PGID_IPV4_MC_CTRL      (PGID_BASE + 3)
+#define PGID_IPV6_MC_DATA      (PGID_BASE + 4)
+#define PGID_IPV6_MC_CTRL      (PGID_BASE + 5)
+#define PGID_BCAST	       (PGID_BASE + 6)
+#define PGID_CPU	       (PGID_BASE + 7)
+
+#define IFH_LEN                9 /* 36 bytes */
+#define NULL_VID               0
+#define SPX5_MACT_PULL_DELAY   (2 * HZ)
+#define SPX5_STATS_CHECK_DELAY (1 * HZ)
+#define SPX5_PRIOS             8     /* Number of priority queues */
+#define SPX5_BUFFER_CELL_SZ    184   /* Cell size  */
+#define SPX5_BUFFER_MEMORY     4194280 /* 22795 words * 184 bytes */
+
+struct sparx5;
+
+struct sparx5_port_config      {
+	phy_interface_t portmode;
+	bool has_sfp;
+	u32 bandwidth;
+	int speed;
+	int duplex;
+	enum phy_media media;
+	bool power_down;
+	bool autoneg;
+	u32 pause;
+	bool serdes_reset;
+	phy_interface_t phy_mode;
+	u32 sd_sgpio;
+};
+
+struct sparx5_port {
+	struct net_device *ndev;
+	struct sparx5 *sparx5;
+	struct device_node *of_node;
+	struct phy *serdes;
+	struct sparx5_port_config conf;
+	u16 portno;
+	/* Ingress default VLAN (pvid) */
+	u16 pvid;
+	/* Egress default VLAN (vid) */
+	u16 vid;
+	bool signd_internal;
+	bool signd_active_high;
+	bool signd_enable;
+	bool flow_control;
+	enum sparx5_port_max_tags max_vlan_tags;
+	enum sparx5_vlan_port_type vlan_type;
+	u32 custom_etype;
+	u32 ifh[IFH_LEN];
+	bool vlan_aware;
+};
+
+enum sparx5_core_clockfreq {
+	SPX5_CORE_CLOCK_DEFAULT,  /* Defaults to the highest supported frequency */
+	SPX5_CORE_CLOCK_250MHZ,   /* 250MHZ core clock frequency */
+	SPX5_CORE_CLOCK_500MHZ,   /* 500MHZ core clock frequency */
+	SPX5_CORE_CLOCK_625MHZ,   /* 625MHZ core clock frequency */
+};
+
+struct sparx5 {
+	struct platform_device *pdev;
+	struct device *dev;
+	u32 chip_id;
+	enum spx5_target_chiptype target_ct;
+	void __iomem *regs[NUM_TARGETS];
+	int port_count;
+	struct reset_control *reset;
+	struct mutex lock; /* MAC reg lock */
+	/* port structures are in net device */
+	struct sparx5_port *ports[SPX5_PORTS];
+	enum sparx5_core_clockfreq coreclock;
+	u8 base_mac[ETH_ALEN];
+	/* Board specifics */
+	bool sd_sgpio_remapping;
+};
+
+/* Clock period in picoseconds */
+static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
+{
+	switch (cclock) {
+	case SPX5_CORE_CLOCK_250MHZ:
+		return 4000;
+	case SPX5_CORE_CLOCK_500MHZ:
+		return 2000;
+	case SPX5_CORE_CLOCK_625MHZ:
+	default:
+		return 1600;
+	}
+}
+
+/* Calculate raw offset */
+static inline __pure int spx5_offset(int id, int tinst, int tcnt,
+				     int gbase, int ginst,
+				     int gcnt, int gwidth,
+				     int raddr, int rinst,
+				     int rcnt, int rwidth)
+{
+	WARN_ON((tinst) >= tcnt);
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+	return gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+/* Read, Write and modify registers content.
+ * The register definition macros start at the id
+ */
+static inline void __iomem *spx5_addr(void __iomem *base[],
+				      int id, int tinst, int tcnt,
+				      int gbase, int ginst,
+				      int gcnt, int gwidth,
+				      int raddr, int rinst,
+				      int rcnt, int rwidth)
+{
+	WARN_ON((tinst) >= tcnt);
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+	return base[id + (tinst)] +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+static inline void __iomem *spx5_inst_addr(void __iomem *base,
+					   int gbase, int ginst,
+					   int gcnt, int gwidth,
+					   int raddr, int rinst,
+					   int rcnt, int rwidth)
+{
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+	return base +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+static inline u32 spx5_rd(struct sparx5 *sparx5, int id, int tinst, int tcnt,
+			  int gbase, int ginst, int gcnt, int gwidth,
+			  int raddr, int rinst, int rcnt, int rwidth)
+{
+	return readl(spx5_addr(sparx5->regs, id, tinst, tcnt, gbase, ginst,
+			       gcnt, gwidth, raddr, rinst, rcnt, rwidth));
+}
+
+static inline u32 spx5_inst_rd(void __iomem *iomem, int id, int tinst, int tcnt,
+			       int gbase, int ginst, int gcnt, int gwidth,
+			       int raddr, int rinst, int rcnt, int rwidth)
+{
+	return readl(spx5_inst_addr(iomem, gbase, ginst,
+				     gcnt, gwidth, raddr, rinst, rcnt, rwidth));
+}
+
+static inline void spx5_wr(u32 val, struct sparx5 *sparx5,
+			   int id, int tinst, int tcnt,
+			   int gbase, int ginst, int gcnt, int gwidth,
+			   int raddr, int rinst, int rcnt, int rwidth)
+{
+	writel(val, spx5_addr(sparx5->regs, id, tinst, tcnt,
+			      gbase, ginst, gcnt, gwidth,
+			      raddr, rinst, rcnt, rwidth));
+}
+
+static inline void spx5_inst_wr(u32 val, void __iomem *iomem,
+				int id, int tinst, int tcnt,
+				int gbase, int ginst, int gcnt, int gwidth,
+				int raddr, int rinst, int rcnt, int rwidth)
+{
+	writel(val, spx5_inst_addr(iomem,
+				   gbase, ginst, gcnt, gwidth,
+				   raddr, rinst, rcnt, rwidth));
+}
+
+static inline void spx5_rmw(u32 val, u32 mask, struct sparx5 *sparx5,
+			    int id, int tinst, int tcnt,
+			    int gbase, int ginst, int gcnt, int gwidth,
+			    int raddr, int rinst, int rcnt, int rwidth)
+{
+	u32 nval;
+	void __iomem *addr =
+		spx5_addr(sparx5->regs, id, tinst, tcnt,
+			  gbase, ginst, gcnt, gwidth,
+			  raddr, rinst, rcnt, rwidth);
+	nval = readl(addr);
+	nval = (nval & ~mask) | (val & mask);
+	writel(nval, addr);
+}
+
+static inline void spx5_inst_rmw(u32 val, u32 mask, void __iomem *iomem,
+				 int id, int tinst, int tcnt,
+				 int gbase, int ginst, int gcnt, int gwidth,
+				 int raddr, int rinst, int rcnt, int rwidth)
+{
+	u32 nval;
+	void __iomem *addr =
+		spx5_inst_addr(iomem,
+			       gbase, ginst, gcnt, gwidth,
+			       raddr, rinst, rcnt, rwidth);
+	nval = readl(addr);
+	nval = (nval & ~mask) | (val & mask);
+	writel(nval, addr);
+}
+
+static inline void __iomem *spx5_inst_get(struct sparx5 *sparx5, int id, int tinst)
+{
+	return sparx5->regs[id + tinst];
+}
+
+static inline void __iomem *spx5_reg_get(struct sparx5 *sparx5,
+					 int id, int tinst, int tcnt,
+					 int gbase, int ginst, int gcnt, int gwidth,
+					 int raddr, int rinst, int rcnt, int rwidth)
+{
+	return spx5_addr(sparx5->regs, id, tinst, tcnt,
+			 gbase, ginst, gcnt, gwidth,
+			 raddr, rinst, rcnt, rwidth);
+}
+
+#endif	/* __SPARX5_MAIN_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
new file mode 100644
index 000000000000..5ab2373a7178
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -0,0 +1,4642 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ * Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc.
+ */
+
+/* This file is autogenerated by cml-utils 2021-05-06 13:06:37 +0200.
+ * Commit ID: 9ae4ec441e25e4b9003f4e514df5cb12a36b84d3
+ */
+
+#ifndef _SPARX5_MAIN_REGS_H_
+#define _SPARX5_MAIN_REGS_H_
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+#include <linux/bug.h>
+
+enum sparx5_target {
+	TARGET_ANA_AC = 1,
+	TARGET_ANA_ACL = 2,
+	TARGET_ANA_AC_POL = 4,
+	TARGET_ANA_CL = 6,
+	TARGET_ANA_L2 = 7,
+	TARGET_ANA_L3 = 8,
+	TARGET_ASM = 9,
+	TARGET_CLKGEN = 11,
+	TARGET_CPU = 12,
+	TARGET_DEV10G = 17,
+	TARGET_DEV25G = 29,
+	TARGET_DEV2G5 = 37,
+	TARGET_DEV5G = 102,
+	TARGET_DSM = 115,
+	TARGET_EACL = 116,
+	TARGET_FDMA = 117,
+	TARGET_GCB = 118,
+	TARGET_HSCH = 119,
+	TARGET_LRN = 122,
+	TARGET_PCEP = 129,
+	TARGET_PCS10G_BR = 132,
+	TARGET_PCS25G_BR = 144,
+	TARGET_PCS5G_BR = 160,
+	TARGET_PORT_CONF = 173,
+	TARGET_QFWD = 175,
+	TARGET_QRES = 176,
+	TARGET_QS = 177,
+	TARGET_QSYS = 178,
+	TARGET_REW = 179,
+	TARGET_VCAP_SUPER = 326,
+	TARGET_VOP = 327,
+	TARGET_XQS = 331,
+	NUM_TARGETS = 332
+};
+
+#define __REG(...)    __VA_ARGS__
+
+/*      ANA_AC:RAM_CTRL:RAM_INIT */
+#define ANA_AC_RAM_INIT           __REG(TARGET_ANA_AC, 0, 1, 839108, 0, 1, 4, 0, 0, 1, 4)
+
+#define ANA_AC_RAM_INIT_RAM_INIT                 BIT(1)
+#define ANA_AC_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(ANA_AC_RAM_INIT_RAM_INIT, x)
+#define ANA_AC_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(ANA_AC_RAM_INIT_RAM_INIT, x)
+
+#define ANA_AC_RAM_INIT_RAM_CFG_HOOK             BIT(0)
+#define ANA_AC_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(ANA_AC_RAM_INIT_RAM_CFG_HOOK, x)
+#define ANA_AC_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(ANA_AC_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      ANA_AC:PS_COMMON:OWN_UPSID */
+#define ANA_AC_OWN_UPSID(r)       __REG(TARGET_ANA_AC, 0, 1, 894472, 0, 1, 352, 52, r, 3, 4)
+
+#define ANA_AC_OWN_UPSID_OWN_UPSID               GENMASK(4, 0)
+#define ANA_AC_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_AC_OWN_UPSID_OWN_UPSID, x)
+#define ANA_AC_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_AC_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_AC:SRC:SRC_CFG */
+#define ANA_AC_SRC_CFG(g)         __REG(TARGET_ANA_AC, 0, 1, 849920, g, 102, 16, 0, 0, 1, 4)
+
+/*      ANA_AC:SRC:SRC_CFG1 */
+#define ANA_AC_SRC_CFG1(g)        __REG(TARGET_ANA_AC, 0, 1, 849920, g, 102, 16, 4, 0, 1, 4)
+
+/*      ANA_AC:SRC:SRC_CFG2 */
+#define ANA_AC_SRC_CFG2(g)        __REG(TARGET_ANA_AC, 0, 1, 849920, g, 102, 16, 8, 0, 1, 4)
+
+#define ANA_AC_SRC_CFG2_PORT_MASK2               BIT(0)
+#define ANA_AC_SRC_CFG2_PORT_MASK2_SET(x)\
+	FIELD_PREP(ANA_AC_SRC_CFG2_PORT_MASK2, x)
+#define ANA_AC_SRC_CFG2_PORT_MASK2_GET(x)\
+	FIELD_GET(ANA_AC_SRC_CFG2_PORT_MASK2, x)
+
+/*      ANA_AC:PGID:PGID_CFG */
+#define ANA_AC_PGID_CFG(g)        __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 0, 0, 1, 4)
+
+/*      ANA_AC:PGID:PGID_CFG1 */
+#define ANA_AC_PGID_CFG1(g)       __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 4, 0, 1, 4)
+
+/*      ANA_AC:PGID:PGID_CFG2 */
+#define ANA_AC_PGID_CFG2(g)       __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 8, 0, 1, 4)
+
+#define ANA_AC_PGID_CFG2_PORT_MASK2              BIT(0)
+#define ANA_AC_PGID_CFG2_PORT_MASK2_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_CFG2_PORT_MASK2, x)
+#define ANA_AC_PGID_CFG2_PORT_MASK2_GET(x)\
+	FIELD_GET(ANA_AC_PGID_CFG2_PORT_MASK2, x)
+
+/*      ANA_AC:PGID:PGID_MISC_CFG */
+#define ANA_AC_PGID_MISC_CFG(g)   __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 12, 0, 1, 4)
+
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_QU         GENMASK(6, 4)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_QU_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_MISC_CFG_PGID_CPU_QU, x)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_QU_GET(x)\
+	FIELD_GET(ANA_AC_PGID_MISC_CFG_PGID_CPU_QU, x)
+
+#define ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA      BIT(1)
+#define ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA, x)
+#define ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA_GET(x)\
+	FIELD_GET(ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA, x)
+
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA   BIT(0)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, x)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_GET(x)\
+	FIELD_GET(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, x)
+
+/*      ANA_AC:STAT_GLOBAL_CFG_PORT:STAT_GLOBAL_EVENT_MASK */
+#define ANA_AC_PORT_SGE_CFG(r)    __REG(TARGET_ANA_AC, 0, 1, 851552, 0, 1, 20, 0, r, 4, 4)
+
+#define ANA_AC_PORT_SGE_CFG_MASK                 GENMASK(15, 0)
+#define ANA_AC_PORT_SGE_CFG_MASK_SET(x)\
+	FIELD_PREP(ANA_AC_PORT_SGE_CFG_MASK, x)
+#define ANA_AC_PORT_SGE_CFG_MASK_GET(x)\
+	FIELD_GET(ANA_AC_PORT_SGE_CFG_MASK, x)
+
+/*      ANA_AC:STAT_GLOBAL_CFG_PORT:STAT_RESET */
+#define ANA_AC_STAT_RESET         __REG(TARGET_ANA_AC, 0, 1, 851552, 0, 1, 20, 16, 0, 1, 4)
+
+#define ANA_AC_STAT_RESET_RESET                  BIT(0)
+#define ANA_AC_STAT_RESET_RESET_SET(x)\
+	FIELD_PREP(ANA_AC_STAT_RESET_RESET, x)
+#define ANA_AC_STAT_RESET_RESET_GET(x)\
+	FIELD_GET(ANA_AC_STAT_RESET_RESET, x)
+
+/*      ANA_AC:STAT_CNT_CFG_PORT:STAT_CFG */
+#define ANA_AC_PORT_STAT_CFG(g, r) __REG(TARGET_ANA_AC, 0, 1, 843776, g, 70, 64, 4, r, 4, 4)
+
+#define ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK       GENMASK(11, 4)
+#define ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK_SET(x)\
+	FIELD_PREP(ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK, x)
+#define ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK_GET(x)\
+	FIELD_GET(ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK, x)
+
+#define ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE    GENMASK(3, 1)
+#define ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE_SET(x)\
+	FIELD_PREP(ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE, x)
+#define ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE_GET(x)\
+	FIELD_GET(ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE, x)
+
+#define ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE        BIT(0)
+#define ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE_SET(x)\
+	FIELD_PREP(ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE, x)
+#define ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE_GET(x)\
+	FIELD_GET(ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE, x)
+
+/*      ANA_AC:STAT_CNT_CFG_PORT:STAT_LSB_CNT */
+#define ANA_AC_PORT_STAT_LSB_CNT(g, r) __REG(TARGET_ANA_AC, 0, 1, 843776, g, 70, 64, 20, r, 4, 4)
+
+/*      ANA_ACL:COMMON:OWN_UPSID */
+#define ANA_ACL_OWN_UPSID(r)      __REG(TARGET_ANA_ACL, 0, 1, 32768, 0, 1, 592, 580, r, 3, 4)
+
+#define ANA_ACL_OWN_UPSID_OWN_UPSID              GENMASK(4, 0)
+#define ANA_ACL_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_ACL_OWN_UPSID_OWN_UPSID, x)
+#define ANA_ACL_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_ACL_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_AC_POL:POL_ALL_CFG:POL_UPD_INT_CFG */
+#define ANA_AC_POL_POL_UPD_INT_CFG __REG(TARGET_ANA_AC_POL, 0, 1, 75968, 0, 1, 1160, 1148, 0, 1, 4)
+
+#define ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT   GENMASK(9, 0)
+#define ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_SET(x)\
+	FIELD_PREP(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT, x)
+#define ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_GET(x)\
+	FIELD_GET(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT, x)
+
+/*      ANA_AC_POL:COMMON_BDLB:DLB_CTRL */
+#define ANA_AC_POL_BDLB_DLB_CTRL  __REG(TARGET_ANA_AC_POL, 0, 1, 79048, 0, 1, 8, 0, 0, 1, 4)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS GENMASK(26, 19)
+#define ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT   GENMASK(18, 4)
+#define ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT, x)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA        BIT(1)
+#define ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA, x)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA     BIT(0)
+#define ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA, x)
+
+/*      ANA_AC_POL:COMMON_BUM_SLB:DLB_CTRL */
+#define ANA_AC_POL_SLB_DLB_CTRL   __REG(TARGET_ANA_AC_POL, 0, 1, 79056, 0, 1, 20, 0, 0, 1, 4)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS  GENMASK(26, 19)
+#define ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT    GENMASK(18, 4)
+#define ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT, x)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA         BIT(1)
+#define ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA, x)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA      BIT(0)
+#define ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA, x)
+
+/*      ANA_CL:PORT:FILTER_CTRL */
+#define ANA_CL_FILTER_CTRL(g)     __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 4, 0, 1, 4)
+
+#define ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS    BIT(2)
+#define ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS, x)
+#define ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS_GET(x)\
+	FIELD_GET(ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS, x)
+
+#define ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS   BIT(1)
+#define ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS, x)
+#define ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS_GET(x)\
+	FIELD_GET(ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS, x)
+
+#define ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA  BIT(0)
+#define ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA, x)
+#define ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA_GET(x)\
+	FIELD_GET(ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA, x)
+
+/*      ANA_CL:PORT:VLAN_FILTER_CTRL */
+#define ANA_CL_VLAN_FILTER_CTRL(g, r) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 8, r, 3, 4)
+
+#define ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA BIT(10)
+#define ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA, x)
+#define ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS    BIT(9)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS         BIT(8)
+#define ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS    BIT(7)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS BIT(6)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS BIT(5)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS BIT(4)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_STAG_DIS         BIT(3)
+#define ANA_CL_VLAN_FILTER_CTRL_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS   BIT(2)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS   BIT(1)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS   BIT(0)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS, x)
+
+/*      ANA_CL:PORT:ETAG_FILTER_CTRL */
+#define ANA_CL_ETAG_FILTER_CTRL(g) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 20, 0, 1, 4)
+
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA BIT(1)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA, x)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA_GET(x)\
+	FIELD_GET(ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA, x)
+
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS         BIT(0)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS, x)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS, x)
+
+/*      ANA_CL:PORT:VLAN_CTRL */
+#define ANA_CL_VLAN_CTRL(g)       __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 32, 0, 1, 4)
+
+#define ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS GENMASK(30, 26)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS, x)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP    GENMASK(25, 23)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP, x)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI    BIT(22)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI, x)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA  BIT(21)
+#define ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA, x)
+#define ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_TAG_SEL            BIT(20)
+#define ANA_CL_VLAN_CTRL_VLAN_TAG_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_TAG_SEL, x)
+#define ANA_CL_VLAN_CTRL_VLAN_TAG_SEL_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_TAG_SEL, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA          BIT(19)
+#define ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA, x)
+#define ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_POP_CNT            GENMASK(18, 17)
+#define ANA_CL_VLAN_CTRL_VLAN_POP_CNT_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_POP_CNT, x)
+#define ANA_CL_VLAN_CTRL_VLAN_POP_CNT_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_POP_CNT, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_TAG_TYPE           BIT(16)
+#define ANA_CL_VLAN_CTRL_PORT_TAG_TYPE_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_TAG_TYPE, x)
+#define ANA_CL_VLAN_CTRL_PORT_TAG_TYPE_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_TAG_TYPE, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_PCP                GENMASK(15, 13)
+#define ANA_CL_VLAN_CTRL_PORT_PCP_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_PCP, x)
+#define ANA_CL_VLAN_CTRL_PORT_PCP_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_PCP, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_DEI                BIT(12)
+#define ANA_CL_VLAN_CTRL_PORT_DEI_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_DEI, x)
+#define ANA_CL_VLAN_CTRL_PORT_DEI_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_DEI, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_VID                GENMASK(11, 0)
+#define ANA_CL_VLAN_CTRL_PORT_VID_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VID, x)
+#define ANA_CL_VLAN_CTRL_PORT_VID_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VID, x)
+
+/*      ANA_CL:PORT:VLAN_CTRL_2 */
+#define ANA_CL_VLAN_CTRL_2(g)     __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 36, 0, 1, 4)
+
+#define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT         GENMASK(1, 0)
+#define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT, x)
+#define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT, x)
+
+/*      ANA_CL:PORT:CAPTURE_BPDU_CFG */
+#define ANA_CL_CAPTURE_BPDU_CFG(g) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 196, 0, 1, 4)
+
+/*      ANA_CL:COMMON:OWN_UPSID */
+#define ANA_CL_OWN_UPSID(r)       __REG(TARGET_ANA_CL, 0, 1, 166912, 0, 1, 756, 0, r, 3, 4)
+
+#define ANA_CL_OWN_UPSID_OWN_UPSID               GENMASK(4, 0)
+#define ANA_CL_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_CL_OWN_UPSID_OWN_UPSID, x)
+#define ANA_CL_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_CL_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_L2:COMMON:AUTO_LRN_CFG */
+#define ANA_L2_AUTO_LRN_CFG       __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 24, 0, 1, 4)
+
+/*      ANA_L2:COMMON:AUTO_LRN_CFG1 */
+#define ANA_L2_AUTO_LRN_CFG1      __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 28, 0, 1, 4)
+
+/*      ANA_L2:COMMON:AUTO_LRN_CFG2 */
+#define ANA_L2_AUTO_LRN_CFG2      __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 32, 0, 1, 4)
+
+#define ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2       BIT(0)
+#define ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2_SET(x)\
+	FIELD_PREP(ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2, x)
+#define ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2_GET(x)\
+	FIELD_GET(ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2, x)
+
+/*      ANA_L2:COMMON:OWN_UPSID */
+#define ANA_L2_OWN_UPSID(r)       __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 672, r, 3, 4)
+
+#define ANA_L2_OWN_UPSID_OWN_UPSID               GENMASK(4, 0)
+#define ANA_L2_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_L2_OWN_UPSID_OWN_UPSID, x)
+#define ANA_L2_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_L2_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_L3:COMMON:VLAN_CTRL */
+#define ANA_L3_VLAN_CTRL          __REG(TARGET_ANA_L3, 0, 1, 493632, 0, 1, 184, 4, 0, 1, 4)
+
+#define ANA_L3_VLAN_CTRL_VLAN_ENA                BIT(0)
+#define ANA_L3_VLAN_CTRL_VLAN_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CTRL_VLAN_ENA, x)
+#define ANA_L3_VLAN_CTRL_VLAN_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CTRL_VLAN_ENA, x)
+
+/*      ANA_L3:VLAN:VLAN_CFG */
+#define ANA_L3_VLAN_CFG(g)        __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 8, 0, 1, 4)
+
+#define ANA_L3_VLAN_CFG_VLAN_MSTP_PTR            GENMASK(30, 24)
+#define ANA_L3_VLAN_CFG_VLAN_MSTP_PTR_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_MSTP_PTR, x)
+#define ANA_L3_VLAN_CFG_VLAN_MSTP_PTR_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_MSTP_PTR, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_FID                 GENMASK(20, 8)
+#define ANA_L3_VLAN_CFG_VLAN_FID_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_FID, x)
+#define ANA_L3_VLAN_CFG_VLAN_FID_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_FID, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA      BIT(6)
+#define ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA         BIT(5)
+#define ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS           BIT(4)
+#define ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS, x)
+#define ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_LRN_DIS             BIT(3)
+#define ANA_L3_VLAN_CFG_VLAN_LRN_DIS_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_LRN_DIS, x)
+#define ANA_L3_VLAN_CFG_VLAN_LRN_DIS_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_LRN_DIS, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_RLEG_ENA            BIT(2)
+#define ANA_L3_VLAN_CFG_VLAN_RLEG_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_RLEG_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_RLEG_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_RLEG_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA         BIT(1)
+#define ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA          BIT(0)
+#define ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA, x)
+
+/*      ANA_L3:VLAN:VLAN_MASK_CFG */
+#define ANA_L3_VLAN_MASK_CFG(g)   __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 16, 0, 1, 4)
+
+/*      ANA_L3:VLAN:VLAN_MASK_CFG1 */
+#define ANA_L3_VLAN_MASK_CFG1(g)  __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 20, 0, 1, 4)
+
+/*      ANA_L3:VLAN:VLAN_MASK_CFG2 */
+#define ANA_L3_VLAN_MASK_CFG2(g)  __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 24, 0, 1, 4)
+
+#define ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2    BIT(0)
+#define ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2, x)
+#define ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2, x)
+
+/*      ASM:DEV_STATISTICS:RX_IN_BYTES_CNT */
+#define ASM_RX_IN_BYTES_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 0, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SYMBOL_ERR_CNT */
+#define ASM_RX_SYMBOL_ERR_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 4, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_PAUSE_CNT */
+#define ASM_RX_PAUSE_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 8, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_UNSUP_OPCODE_CNT */
+#define ASM_RX_UNSUP_OPCODE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 12, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_OK_BYTES_CNT */
+#define ASM_RX_OK_BYTES_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 16, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_BAD_BYTES_CNT */
+#define ASM_RX_BAD_BYTES_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 20, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_UC_CNT */
+#define ASM_RX_UC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 24, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_MC_CNT */
+#define ASM_RX_MC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 28, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_BC_CNT */
+#define ASM_RX_BC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 32, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_CRC_ERR_CNT */
+#define ASM_RX_CRC_ERR_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 36, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_UNDERSIZE_CNT */
+#define ASM_RX_UNDERSIZE_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 40, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_FRAGMENTS_CNT */
+#define ASM_RX_FRAGMENTS_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 44, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_IN_RANGE_LEN_ERR_CNT */
+#define ASM_RX_IN_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 48, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define ASM_RX_OUT_OF_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 52, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_OVERSIZE_CNT */
+#define ASM_RX_OVERSIZE_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 56, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_JABBERS_CNT */
+#define ASM_RX_JABBERS_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 60, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE64_CNT */
+#define ASM_RX_SIZE64_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 64, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE65TO127_CNT */
+#define ASM_RX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 68, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE128TO255_CNT */
+#define ASM_RX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 72, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE256TO511_CNT */
+#define ASM_RX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 76, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE512TO1023_CNT */
+#define ASM_RX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 80, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE1024TO1518_CNT */
+#define ASM_RX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 84, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE1519TOMAX_CNT */
+#define ASM_RX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 88, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_IPG_SHRINK_CNT */
+#define ASM_RX_IPG_SHRINK_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 92, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_OUT_BYTES_CNT */
+#define ASM_TX_OUT_BYTES_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 96, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_PAUSE_CNT */
+#define ASM_TX_PAUSE_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 100, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_OK_BYTES_CNT */
+#define ASM_TX_OK_BYTES_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 104, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_UC_CNT */
+#define ASM_TX_UC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 108, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_MC_CNT */
+#define ASM_TX_MC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 112, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_BC_CNT */
+#define ASM_TX_BC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 116, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE64_CNT */
+#define ASM_TX_SIZE64_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 120, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE65TO127_CNT */
+#define ASM_TX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 124, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE128TO255_CNT */
+#define ASM_TX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 128, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE256TO511_CNT */
+#define ASM_TX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 132, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE512TO1023_CNT */
+#define ASM_TX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 136, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE1024TO1518_CNT */
+#define ASM_TX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 140, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE1519TOMAX_CNT */
+#define ASM_TX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 144, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_ALIGNMENT_LOST_CNT */
+#define ASM_RX_ALIGNMENT_LOST_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 148, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_TAGGED_FRMS_CNT */
+#define ASM_RX_TAGGED_FRMS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 152, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_UNTAGGED_FRMS_CNT */
+#define ASM_RX_UNTAGGED_FRMS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 156, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_TAGGED_FRMS_CNT */
+#define ASM_TX_TAGGED_FRMS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 160, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_UNTAGGED_FRMS_CNT */
+#define ASM_TX_UNTAGGED_FRMS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 164, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SYMBOL_ERR_CNT */
+#define ASM_PMAC_RX_SYMBOL_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 168, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_PAUSE_CNT */
+#define ASM_PMAC_RX_PAUSE_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 172, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_UNSUP_OPCODE_CNT */
+#define ASM_PMAC_RX_UNSUP_OPCODE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 176, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OK_BYTES_CNT */
+#define ASM_PMAC_RX_OK_BYTES_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 180, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_BAD_BYTES_CNT */
+#define ASM_PMAC_RX_BAD_BYTES_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 184, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_UC_CNT */
+#define ASM_PMAC_RX_UC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 188, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_MC_CNT */
+#define ASM_PMAC_RX_MC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 192, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_BC_CNT */
+#define ASM_PMAC_RX_BC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 196, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_CRC_ERR_CNT */
+#define ASM_PMAC_RX_CRC_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 200, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_UNDERSIZE_CNT */
+#define ASM_PMAC_RX_UNDERSIZE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 204, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_FRAGMENTS_CNT */
+#define ASM_PMAC_RX_FRAGMENTS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 208, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_IN_RANGE_LEN_ERR_CNT */
+#define ASM_PMAC_RX_IN_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 212, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define ASM_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 216, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OVERSIZE_CNT */
+#define ASM_PMAC_RX_OVERSIZE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 220, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_JABBERS_CNT */
+#define ASM_PMAC_RX_JABBERS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 224, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE64_CNT */
+#define ASM_PMAC_RX_SIZE64_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 228, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE65TO127_CNT */
+#define ASM_PMAC_RX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 232, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE128TO255_CNT */
+#define ASM_PMAC_RX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 236, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE256TO511_CNT */
+#define ASM_PMAC_RX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 240, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE512TO1023_CNT */
+#define ASM_PMAC_RX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 244, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE1024TO1518_CNT */
+#define ASM_PMAC_RX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 248, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE1519TOMAX_CNT */
+#define ASM_PMAC_RX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 252, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_PAUSE_CNT */
+#define ASM_PMAC_TX_PAUSE_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 256, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_OK_BYTES_CNT */
+#define ASM_PMAC_TX_OK_BYTES_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 260, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_UC_CNT */
+#define ASM_PMAC_TX_UC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 264, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_MC_CNT */
+#define ASM_PMAC_TX_MC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 268, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_BC_CNT */
+#define ASM_PMAC_TX_BC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 272, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE64_CNT */
+#define ASM_PMAC_TX_SIZE64_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 276, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE65TO127_CNT */
+#define ASM_PMAC_TX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 280, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE128TO255_CNT */
+#define ASM_PMAC_TX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 284, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE256TO511_CNT */
+#define ASM_PMAC_TX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 288, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE512TO1023_CNT */
+#define ASM_PMAC_TX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 292, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE1024TO1518_CNT */
+#define ASM_PMAC_TX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 296, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE1519TOMAX_CNT */
+#define ASM_PMAC_TX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 300, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_ALIGNMENT_LOST_CNT */
+#define ASM_PMAC_RX_ALIGNMENT_LOST_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 304, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:MM_RX_ASSEMBLY_ERR_CNT */
+#define ASM_MM_RX_ASSEMBLY_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 308, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:MM_RX_SMD_ERR_CNT */
+#define ASM_MM_RX_SMD_ERR_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 312, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:MM_RX_ASSEMBLY_OK_CNT */
+#define ASM_MM_RX_ASSEMBLY_OK_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 316, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:MM_RX_MERGE_FRAG_CNT */
+#define ASM_MM_RX_MERGE_FRAG_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 320, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:MM_TX_PFRAGMENT_CNT */
+#define ASM_MM_TX_PFRAGMENT_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 324, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_MULTI_COLL_CNT */
+#define ASM_TX_MULTI_COLL_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 328, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_LATE_COLL_CNT */
+#define ASM_TX_LATE_COLL_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 332, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_XCOLL_CNT */
+#define ASM_TX_XCOLL_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 336, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_DEFER_CNT */
+#define ASM_TX_DEFER_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 340, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_XDEFER_CNT */
+#define ASM_TX_XDEFER_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 344, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_BACKOFF1_CNT */
+#define ASM_TX_BACKOFF1_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 348, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_CSENSE_CNT */
+#define ASM_TX_CSENSE_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 352, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_IN_BYTES_MSB_CNT */
+#define ASM_RX_IN_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 356, 0, 1, 4)
+
+#define ASM_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT, x)
+#define ASM_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:RX_OK_BYTES_MSB_CNT */
+#define ASM_RX_OK_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 360, 0, 1, 4)
+
+#define ASM_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT, x)
+#define ASM_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OK_BYTES_MSB_CNT */
+#define ASM_PMAC_RX_OK_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 364, 0, 1, 4)
+
+#define ASM_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT, x)
+#define ASM_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:RX_BAD_BYTES_MSB_CNT */
+#define ASM_RX_BAD_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 368, 0, 1, 4)
+
+#define ASM_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT, x)
+#define ASM_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_BAD_BYTES_MSB_CNT */
+#define ASM_PMAC_RX_BAD_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 372, 0, 1, 4)
+
+#define ASM_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT, x)
+#define ASM_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:TX_OUT_BYTES_MSB_CNT */
+#define ASM_TX_OUT_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 376, 0, 1, 4)
+
+#define ASM_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT, x)
+#define ASM_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:TX_OK_BYTES_MSB_CNT */
+#define ASM_TX_OK_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 380, 0, 1, 4)
+
+#define ASM_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT, x)
+#define ASM_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_OK_BYTES_MSB_CNT */
+#define ASM_PMAC_TX_OK_BYTES_MSB_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 384, 0, 1, 4)
+
+#define ASM_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT GENMASK(3, 0)
+#define ASM_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(ASM_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT, x)
+#define ASM_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(ASM_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT, x)
+
+/*      ASM:DEV_STATISTICS:RX_SYNC_LOST_ERR_CNT */
+#define ASM_RX_SYNC_LOST_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 388, 0, 1, 4)
+
+/*      ASM:CFG:STAT_CFG */
+#define ASM_STAT_CFG              __REG(TARGET_ASM, 0, 1, 33280, 0, 1, 1088, 0, 0, 1, 4)
+
+#define ASM_STAT_CFG_STAT_CNT_CLR_SHOT           BIT(0)
+#define ASM_STAT_CFG_STAT_CNT_CLR_SHOT_SET(x)\
+	FIELD_PREP(ASM_STAT_CFG_STAT_CNT_CLR_SHOT, x)
+#define ASM_STAT_CFG_STAT_CNT_CLR_SHOT_GET(x)\
+	FIELD_GET(ASM_STAT_CFG_STAT_CNT_CLR_SHOT, x)
+
+/*      ASM:CFG:PORT_CFG */
+#define ASM_PORT_CFG(r)           __REG(TARGET_ASM, 0, 1, 33280, 0, 1, 1088, 540, r, 67, 4)
+
+#define ASM_PORT_CFG_CSC_STAT_DIS                BIT(12)
+#define ASM_PORT_CFG_CSC_STAT_DIS_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_CSC_STAT_DIS, x)
+#define ASM_PORT_CFG_CSC_STAT_DIS_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_CSC_STAT_DIS, x)
+
+#define ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA      BIT(11)
+#define ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA, x)
+#define ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA, x)
+
+#define ASM_PORT_CFG_IGN_TAXI_ABORT_ENA          BIT(10)
+#define ASM_PORT_CFG_IGN_TAXI_ABORT_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_IGN_TAXI_ABORT_ENA, x)
+#define ASM_PORT_CFG_IGN_TAXI_ABORT_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_IGN_TAXI_ABORT_ENA, x)
+
+#define ASM_PORT_CFG_NO_PREAMBLE_ENA             BIT(9)
+#define ASM_PORT_CFG_NO_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_NO_PREAMBLE_ENA, x)
+#define ASM_PORT_CFG_NO_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_NO_PREAMBLE_ENA, x)
+
+#define ASM_PORT_CFG_SKIP_PREAMBLE_ENA           BIT(8)
+#define ASM_PORT_CFG_SKIP_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_SKIP_PREAMBLE_ENA, x)
+#define ASM_PORT_CFG_SKIP_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_SKIP_PREAMBLE_ENA, x)
+
+#define ASM_PORT_CFG_FRM_AGING_DIS               BIT(7)
+#define ASM_PORT_CFG_FRM_AGING_DIS_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_FRM_AGING_DIS, x)
+#define ASM_PORT_CFG_FRM_AGING_DIS_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_FRM_AGING_DIS, x)
+
+#define ASM_PORT_CFG_PAD_ENA                     BIT(6)
+#define ASM_PORT_CFG_PAD_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_PAD_ENA, x)
+#define ASM_PORT_CFG_PAD_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_PAD_ENA, x)
+
+#define ASM_PORT_CFG_INJ_DISCARD_CFG             GENMASK(5, 4)
+#define ASM_PORT_CFG_INJ_DISCARD_CFG_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_INJ_DISCARD_CFG, x)
+#define ASM_PORT_CFG_INJ_DISCARD_CFG_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_INJ_DISCARD_CFG, x)
+
+#define ASM_PORT_CFG_INJ_FORMAT_CFG              GENMASK(3, 2)
+#define ASM_PORT_CFG_INJ_FORMAT_CFG_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_INJ_FORMAT_CFG, x)
+#define ASM_PORT_CFG_INJ_FORMAT_CFG_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_INJ_FORMAT_CFG, x)
+
+#define ASM_PORT_CFG_VSTAX2_AWR_ENA              BIT(1)
+#define ASM_PORT_CFG_VSTAX2_AWR_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_VSTAX2_AWR_ENA, x)
+#define ASM_PORT_CFG_VSTAX2_AWR_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_VSTAX2_AWR_ENA, x)
+
+#define ASM_PORT_CFG_PFRM_FLUSH                  BIT(0)
+#define ASM_PORT_CFG_PFRM_FLUSH_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_PFRM_FLUSH, x)
+#define ASM_PORT_CFG_PFRM_FLUSH_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_PFRM_FLUSH, x)
+
+/*      ASM:RAM_CTRL:RAM_INIT */
+#define ASM_RAM_INIT              __REG(TARGET_ASM, 0, 1, 34832, 0, 1, 4, 0, 0, 1, 4)
+
+#define ASM_RAM_INIT_RAM_INIT                    BIT(1)
+#define ASM_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(ASM_RAM_INIT_RAM_INIT, x)
+#define ASM_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(ASM_RAM_INIT_RAM_INIT, x)
+
+#define ASM_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define ASM_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(ASM_RAM_INIT_RAM_CFG_HOOK, x)
+#define ASM_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(ASM_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      CLKGEN:LCPLL1:LCPLL1_CORE_CLK_CFG */
+#define CLKGEN_LCPLL1_CORE_CLK_CFG __REG(TARGET_CLKGEN, 0, 1, 12, 0, 1, 36, 0, 0, 1, 4)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV  GENMASK(7, 0)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV  GENMASK(10, 8)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR  BIT(11)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL  GENMASK(13, 12)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA  BIT(14)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA  BIT(15)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA, x)
+
+/*      CPU:CPU_REGS:PROC_CTRL */
+#define CPU_PROC_CTRL             __REG(TARGET_CPU, 0, 1, 0, 0, 1, 204, 176, 0, 1, 4)
+
+#define CPU_PROC_CTRL_AARCH64_MODE_ENA           BIT(12)
+#define CPU_PROC_CTRL_AARCH64_MODE_ENA_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_AARCH64_MODE_ENA, x)
+#define CPU_PROC_CTRL_AARCH64_MODE_ENA_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_AARCH64_MODE_ENA, x)
+
+#define CPU_PROC_CTRL_L2_RST_INVALIDATE_DIS      BIT(11)
+#define CPU_PROC_CTRL_L2_RST_INVALIDATE_DIS_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_L2_RST_INVALIDATE_DIS, x)
+#define CPU_PROC_CTRL_L2_RST_INVALIDATE_DIS_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_L2_RST_INVALIDATE_DIS, x)
+
+#define CPU_PROC_CTRL_L1_RST_INVALIDATE_DIS      BIT(10)
+#define CPU_PROC_CTRL_L1_RST_INVALIDATE_DIS_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_L1_RST_INVALIDATE_DIS, x)
+#define CPU_PROC_CTRL_L1_RST_INVALIDATE_DIS_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_L1_RST_INVALIDATE_DIS, x)
+
+#define CPU_PROC_CTRL_BE_EXCEP_MODE              BIT(9)
+#define CPU_PROC_CTRL_BE_EXCEP_MODE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_BE_EXCEP_MODE, x)
+#define CPU_PROC_CTRL_BE_EXCEP_MODE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_BE_EXCEP_MODE, x)
+
+#define CPU_PROC_CTRL_VINITHI                    BIT(8)
+#define CPU_PROC_CTRL_VINITHI_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_VINITHI, x)
+#define CPU_PROC_CTRL_VINITHI_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_VINITHI, x)
+
+#define CPU_PROC_CTRL_CFGTE                      BIT(7)
+#define CPU_PROC_CTRL_CFGTE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_CFGTE, x)
+#define CPU_PROC_CTRL_CFGTE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_CFGTE, x)
+
+#define CPU_PROC_CTRL_CP15S_DISABLE              BIT(6)
+#define CPU_PROC_CTRL_CP15S_DISABLE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_CP15S_DISABLE, x)
+#define CPU_PROC_CTRL_CP15S_DISABLE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_CP15S_DISABLE, x)
+
+#define CPU_PROC_CTRL_PROC_CRYPTO_DISABLE        BIT(5)
+#define CPU_PROC_CTRL_PROC_CRYPTO_DISABLE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_PROC_CRYPTO_DISABLE, x)
+#define CPU_PROC_CTRL_PROC_CRYPTO_DISABLE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_PROC_CRYPTO_DISABLE, x)
+
+#define CPU_PROC_CTRL_ACP_CACHE_FORCE_ENA        BIT(4)
+#define CPU_PROC_CTRL_ACP_CACHE_FORCE_ENA_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_ACP_CACHE_FORCE_ENA, x)
+#define CPU_PROC_CTRL_ACP_CACHE_FORCE_ENA_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_ACP_CACHE_FORCE_ENA, x)
+
+#define CPU_PROC_CTRL_ACP_AWCACHE                BIT(3)
+#define CPU_PROC_CTRL_ACP_AWCACHE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_ACP_AWCACHE, x)
+#define CPU_PROC_CTRL_ACP_AWCACHE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_ACP_AWCACHE, x)
+
+#define CPU_PROC_CTRL_ACP_ARCACHE                BIT(2)
+#define CPU_PROC_CTRL_ACP_ARCACHE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_ACP_ARCACHE, x)
+#define CPU_PROC_CTRL_ACP_ARCACHE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_ACP_ARCACHE, x)
+
+#define CPU_PROC_CTRL_L2_FLUSH_REQ               BIT(1)
+#define CPU_PROC_CTRL_L2_FLUSH_REQ_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_L2_FLUSH_REQ, x)
+#define CPU_PROC_CTRL_L2_FLUSH_REQ_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_L2_FLUSH_REQ, x)
+
+#define CPU_PROC_CTRL_ACP_DISABLE                BIT(0)
+#define CPU_PROC_CTRL_ACP_DISABLE_SET(x)\
+	FIELD_PREP(CPU_PROC_CTRL_ACP_DISABLE, x)
+#define CPU_PROC_CTRL_ACP_DISABLE_GET(x)\
+	FIELD_GET(CPU_PROC_CTRL_ACP_DISABLE, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV10G_MAC_ENA_CFG(t)     __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 0, 0, 1, 4)
+
+#define DEV10G_MAC_ENA_CFG_RX_ENA                BIT(4)
+#define DEV10G_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ENA_CFG_RX_ENA, x)
+#define DEV10G_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV10G_MAC_ENA_CFG_TX_ENA                BIT(0)
+#define DEV10G_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ENA_CFG_TX_ENA, x)
+#define DEV10G_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV10G_MAC_MAXLEN_CFG(t)  __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 8, 0, 1, 4)
+
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK    BIT(16)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(x)\
+	FIELD_PREP(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_GET(x)\
+	FIELD_GET(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN            GENMASK(15, 0)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV10G_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV10G_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_NUM_TAGS_CFG */
+#define DEV10G_MAC_NUM_TAGS_CFG(t) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 12, 0, 1, 4)
+
+#define DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS         GENMASK(1, 0)
+#define DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS_SET(x)\
+	FIELD_PREP(DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS, x)
+#define DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS_GET(x)\
+	FIELD_GET(DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_TAGS_CFG */
+#define DEV10G_MAC_TAGS_CFG(t, r) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 16, r, 3, 4)
+
+#define DEV10G_MAC_TAGS_CFG_TAG_ID               GENMASK(31, 16)
+#define DEV10G_MAC_TAGS_CFG_TAG_ID_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TAGS_CFG_TAG_ID, x)
+#define DEV10G_MAC_TAGS_CFG_TAG_ID_GET(x)\
+	FIELD_GET(DEV10G_MAC_TAGS_CFG_TAG_ID, x)
+
+#define DEV10G_MAC_TAGS_CFG_TAG_ENA              BIT(4)
+#define DEV10G_MAC_TAGS_CFG_TAG_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TAGS_CFG_TAG_ENA, x)
+#define DEV10G_MAC_TAGS_CFG_TAG_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_TAGS_CFG_TAG_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV10G_MAC_ADV_CHK_CFG(t) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 28, 0, 1, 4)
+
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA   BIT(24)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA   BIT(20)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA       BIT(16)
+#define DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS   BIT(12)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA       BIT(8)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA       BIT(4)
+#define DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA       BIT(0)
+#define DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_TX_MONITOR_STICKY */
+#define DEV10G_MAC_TX_MONITOR_STICKY(t) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 48, 0, 1, 4)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY BIT(4)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY BIT(3)
+#define DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY BIT(2)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY BIT(1)
+#define DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY BIT(0)
+#define DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY, x)
+
+/*      DEV10G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV10G_DEV_RST_CTRL(t)    __REG(TARGET_DEV10G, t, 12, 436, 0, 1, 52, 0, 0, 1, 4)
+
+#define DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA      BIT(28)
+#define DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+#define DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+
+#define DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(27)
+#define DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS GENMASK(26, 25)
+#define DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+#define DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+
+#define DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL     GENMASK(24, 23)
+#define DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+#define DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+
+#define DEV10G_DEV_RST_CTRL_SPEED_SEL            GENMASK(22, 20)
+#define DEV10G_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV10G_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV10G_DEV_RST_CTRL_PCS_TX_RST           BIT(12)
+#define DEV10G_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV10G_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV10G_DEV_RST_CTRL_PCS_RX_RST           BIT(8)
+#define DEV10G_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV10G_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV10G_DEV_RST_CTRL_MAC_TX_RST           BIT(4)
+#define DEV10G_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV10G_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV10G_DEV_RST_CTRL_MAC_RX_RST           BIT(0)
+#define DEV10G_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV10G_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DEV10G:PCS25G_CFG_STATUS:PCS25G_CFG */
+#define DEV10G_PCS25G_CFG(t)      __REG(TARGET_DEV10G, t, 12, 488, 0, 1, 32, 0, 0, 1, 4)
+
+#define DEV10G_PCS25G_CFG_PCS25G_ENA             BIT(0)
+#define DEV10G_PCS25G_CFG_PCS25G_ENA_SET(x)\
+	FIELD_PREP(DEV10G_PCS25G_CFG_PCS25G_ENA, x)
+#define DEV10G_PCS25G_CFG_PCS25G_ENA_GET(x)\
+	FIELD_GET(DEV10G_PCS25G_CFG_PCS25G_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV25G_MAC_ENA_CFG(t)     __REG(TARGET_DEV25G, t, 8, 0, 0, 1, 60, 0, 0, 1, 4)
+
+#define DEV25G_MAC_ENA_CFG_RX_ENA                BIT(4)
+#define DEV25G_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ENA_CFG_RX_ENA, x)
+#define DEV25G_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV25G_MAC_ENA_CFG_TX_ENA                BIT(0)
+#define DEV25G_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ENA_CFG_TX_ENA, x)
+#define DEV25G_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV25G_MAC_MAXLEN_CFG(t)  __REG(TARGET_DEV25G, t, 8, 0, 0, 1, 60, 8, 0, 1, 4)
+
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK    BIT(16)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(x)\
+	FIELD_PREP(DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_GET(x)\
+	FIELD_GET(DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN            GENMASK(15, 0)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV25G_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV25G_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV25G_MAC_ADV_CHK_CFG(t) __REG(TARGET_DEV25G, t, 8, 0, 0, 1, 60, 28, 0, 1, 4)
+
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA   BIT(24)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA   BIT(20)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA       BIT(16)
+#define DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS   BIT(12)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA       BIT(8)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA       BIT(4)
+#define DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA       BIT(0)
+#define DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+
+/*      DEV10G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV25G_DEV_RST_CTRL(t)    __REG(TARGET_DEV25G, t, 8, 436, 0, 1, 52, 0, 0, 1, 4)
+
+#define DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA      BIT(28)
+#define DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+#define DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+
+#define DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(27)
+#define DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS GENMASK(26, 25)
+#define DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+#define DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+
+#define DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL     GENMASK(24, 23)
+#define DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+#define DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+
+#define DEV25G_DEV_RST_CTRL_SPEED_SEL            GENMASK(22, 20)
+#define DEV25G_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV25G_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV25G_DEV_RST_CTRL_PCS_TX_RST           BIT(12)
+#define DEV25G_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV25G_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV25G_DEV_RST_CTRL_PCS_RX_RST           BIT(8)
+#define DEV25G_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV25G_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV25G_DEV_RST_CTRL_MAC_TX_RST           BIT(4)
+#define DEV25G_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV25G_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV25G_DEV_RST_CTRL_MAC_RX_RST           BIT(0)
+#define DEV25G_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV25G_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DEV10G:PCS25G_CFG_STATUS:PCS25G_CFG */
+#define DEV25G_PCS25G_CFG(t)      __REG(TARGET_DEV25G, t, 8, 488, 0, 1, 32, 0, 0, 1, 4)
+
+#define DEV25G_PCS25G_CFG_PCS25G_ENA             BIT(0)
+#define DEV25G_PCS25G_CFG_PCS25G_ENA_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_CFG_PCS25G_ENA, x)
+#define DEV25G_PCS25G_CFG_PCS25G_ENA_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_CFG_PCS25G_ENA, x)
+
+/*      DEV10G:PCS25G_CFG_STATUS:PCS25G_SD_CFG */
+#define DEV25G_PCS25G_SD_CFG(t)   __REG(TARGET_DEV25G, t, 8, 488, 0, 1, 32, 4, 0, 1, 4)
+
+#define DEV25G_PCS25G_SD_CFG_SD_SEL              BIT(8)
+#define DEV25G_PCS25G_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_SD_CFG_SD_SEL, x)
+#define DEV25G_PCS25G_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_SD_CFG_SD_SEL, x)
+
+#define DEV25G_PCS25G_SD_CFG_SD_POL              BIT(4)
+#define DEV25G_PCS25G_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_SD_CFG_SD_POL, x)
+#define DEV25G_PCS25G_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_SD_CFG_SD_POL, x)
+
+#define DEV25G_PCS25G_SD_CFG_SD_ENA              BIT(0)
+#define DEV25G_PCS25G_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_SD_CFG_SD_ENA, x)
+#define DEV25G_PCS25G_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_SD_CFG_SD_ENA, x)
+
+/*      DEV1G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV2G5_DEV_RST_CTRL(t)    __REG(TARGET_DEV2G5, t, 65, 0, 0, 1, 36, 0, 0, 1, 4)
+
+#define DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(23)
+#define DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV2G5_DEV_RST_CTRL_SPEED_SEL            GENMASK(22, 20)
+#define DEV2G5_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV2G5_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST       BIT(17)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST       BIT(16)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_PCS_TX_RST           BIT(12)
+#define DEV2G5_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_PCS_RX_RST           BIT(8)
+#define DEV2G5_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_MAC_TX_RST           BIT(4)
+#define DEV2G5_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_MAC_RX_RST           BIT(0)
+#define DEV2G5_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV2G5_MAC_ENA_CFG(t)     __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 0, 0, 1, 4)
+
+#define DEV2G5_MAC_ENA_CFG_RX_ENA                BIT(4)
+#define DEV2G5_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_ENA_CFG_RX_ENA, x)
+#define DEV2G5_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV2G5_MAC_ENA_CFG_TX_ENA                BIT(0)
+#define DEV2G5_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_ENA_CFG_TX_ENA, x)
+#define DEV2G5_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_MODE_CFG */
+#define DEV2G5_MAC_MODE_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 4, 0, 1, 4)
+
+#define DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA     BIT(8)
+#define DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA, x)
+#define DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA, x)
+
+#define DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA        BIT(4)
+#define DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA, x)
+#define DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA, x)
+
+#define DEV2G5_MAC_MODE_CFG_FDX_ENA              BIT(0)
+#define DEV2G5_MAC_MODE_CFG_FDX_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MODE_CFG_FDX_ENA, x)
+#define DEV2G5_MAC_MODE_CFG_FDX_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MODE_CFG_FDX_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV2G5_MAC_MAXLEN_CFG(t)  __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 8, 0, 1, 4)
+
+#define DEV2G5_MAC_MAXLEN_CFG_MAX_LEN            GENMASK(15, 0)
+#define DEV2G5_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV2G5_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_TAGS_CFG */
+#define DEV2G5_MAC_TAGS_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 12, 0, 1, 4)
+
+#define DEV2G5_MAC_TAGS_CFG_TAG_ID               GENMASK(31, 16)
+#define DEV2G5_MAC_TAGS_CFG_TAG_ID_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_TAG_ID, x)
+#define DEV2G5_MAC_TAGS_CFG_TAG_ID_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_TAG_ID, x)
+
+#define DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA     BIT(3)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA, x)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA, x)
+
+#define DEV2G5_MAC_TAGS_CFG_PB_ENA               GENMASK(2, 1)
+#define DEV2G5_MAC_TAGS_CFG_PB_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_PB_ENA, x)
+#define DEV2G5_MAC_TAGS_CFG_PB_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_PB_ENA, x)
+
+#define DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA         BIT(0)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_TAGS_CFG2 */
+#define DEV2G5_MAC_TAGS_CFG2(t)   __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 16, 0, 1, 4)
+
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID3             GENMASK(31, 16)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID3_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG2_TAG_ID3, x)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID3_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG2_TAG_ID3, x)
+
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID2             GENMASK(15, 0)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID2_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG2_TAG_ID2, x)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID2_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG2_TAG_ID2, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV2G5_MAC_ADV_CHK_CFG(t) __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 20, 0, 1, 4)
+
+#define DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA      BIT(0)
+#define DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA, x)
+#define DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_IFG_CFG */
+#define DEV2G5_MAC_IFG_CFG(t)     __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 24, 0, 1, 4)
+
+#define DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK BIT(17)
+#define DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK, x)
+#define DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK, x)
+
+#define DEV2G5_MAC_IFG_CFG_TX_IFG                GENMASK(12, 8)
+#define DEV2G5_MAC_IFG_CFG_TX_IFG_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_TX_IFG, x)
+#define DEV2G5_MAC_IFG_CFG_TX_IFG_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_TX_IFG, x)
+
+#define DEV2G5_MAC_IFG_CFG_RX_IFG2               GENMASK(7, 4)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG2_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_RX_IFG2, x)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG2_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_RX_IFG2, x)
+
+#define DEV2G5_MAC_IFG_CFG_RX_IFG1               GENMASK(3, 0)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG1_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_RX_IFG1, x)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG1_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_RX_IFG1, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_HDX_CFG */
+#define DEV2G5_MAC_HDX_CFG(t)     __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 28, 0, 1, 4)
+
+#define DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC       BIT(26)
+#define DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC, x)
+#define DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC, x)
+
+#define DEV2G5_MAC_HDX_CFG_SEED                  GENMASK(23, 16)
+#define DEV2G5_MAC_HDX_CFG_SEED_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_SEED, x)
+#define DEV2G5_MAC_HDX_CFG_SEED_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_SEED, x)
+
+#define DEV2G5_MAC_HDX_CFG_SEED_LOAD             BIT(12)
+#define DEV2G5_MAC_HDX_CFG_SEED_LOAD_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_SEED_LOAD, x)
+#define DEV2G5_MAC_HDX_CFG_SEED_LOAD_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_SEED_LOAD, x)
+
+#define DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA BIT(8)
+#define DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA, x)
+#define DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA, x)
+
+#define DEV2G5_MAC_HDX_CFG_LATE_COL_POS          GENMASK(6, 0)
+#define DEV2G5_MAC_HDX_CFG_LATE_COL_POS_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_LATE_COL_POS, x)
+#define DEV2G5_MAC_HDX_CFG_LATE_COL_POS_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_LATE_COL_POS, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_CFG */
+#define DEV2G5_PCS1G_CFG(t)       __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 0, 0, 1, 4)
+
+#define DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE        BIT(4)
+#define DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE, x)
+#define DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE, x)
+
+#define DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA        BIT(1)
+#define DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA, x)
+#define DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA, x)
+
+#define DEV2G5_PCS1G_CFG_PCS_ENA                 BIT(0)
+#define DEV2G5_PCS1G_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_CFG_PCS_ENA, x)
+#define DEV2G5_PCS1G_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_CFG_PCS_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_MODE_CFG */
+#define DEV2G5_PCS1G_MODE_CFG(t)  __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 4, 0, 1, 4)
+
+#define DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA    BIT(4)
+#define DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA, x)
+#define DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA, x)
+
+#define DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA  BIT(1)
+#define DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA, x)
+#define DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA, x)
+
+#define DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA     BIT(0)
+#define DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA, x)
+#define DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_SD_CFG */
+#define DEV2G5_PCS1G_SD_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 8, 0, 1, 4)
+
+#define DEV2G5_PCS1G_SD_CFG_SD_SEL               BIT(8)
+#define DEV2G5_PCS1G_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_SD_CFG_SD_SEL, x)
+#define DEV2G5_PCS1G_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_SD_CFG_SD_SEL, x)
+
+#define DEV2G5_PCS1G_SD_CFG_SD_POL               BIT(4)
+#define DEV2G5_PCS1G_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_SD_CFG_SD_POL, x)
+#define DEV2G5_PCS1G_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_SD_CFG_SD_POL, x)
+
+#define DEV2G5_PCS1G_SD_CFG_SD_ENA               BIT(0)
+#define DEV2G5_PCS1G_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_SD_CFG_SD_ENA, x)
+#define DEV2G5_PCS1G_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_SD_CFG_SD_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_ANEG_CFG */
+#define DEV2G5_PCS1G_ANEG_CFG(t)  __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 12, 0, 1, 4)
+
+#define DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY        GENMASK(31, 16)
+#define DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY, x)
+#define DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY, x)
+
+#define DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA     BIT(8)
+#define DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA, x)
+#define DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA, x)
+
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT BIT(1)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT, x)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT, x)
+
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA           BIT(0)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA, x)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_LB_CFG */
+#define DEV2G5_PCS1G_LB_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 20, 0, 1, 4)
+
+#define DEV2G5_PCS1G_LB_CFG_RA_ENA               BIT(4)
+#define DEV2G5_PCS1G_LB_CFG_RA_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LB_CFG_RA_ENA, x)
+#define DEV2G5_PCS1G_LB_CFG_RA_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LB_CFG_RA_ENA, x)
+
+#define DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA      BIT(1)
+#define DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA, x)
+#define DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA, x)
+
+#define DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA      BIT(0)
+#define DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA, x)
+#define DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_ANEG_STATUS */
+#define DEV2G5_PCS1G_ANEG_STATUS(t) __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 32, 0, 1, 4)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY  GENMASK(31, 16)
+#define DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY, x)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_PR              BIT(4)
+#define DEV2G5_PCS1G_ANEG_STATUS_PR_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_PR, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_PR_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_PR, x)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY  BIT(3)
+#define DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY, x)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE   BIT(0)
+#define DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_LINK_STATUS */
+#define DEV2G5_PCS1G_LINK_STATUS(t) __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 40, 0, 1, 4)
+
+#define DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR       GENMASK(15, 12)
+#define DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR, x)
+#define DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR, x)
+
+#define DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT   BIT(8)
+#define DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT, x)
+#define DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT, x)
+
+#define DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS     BIT(4)
+#define DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS, x)
+#define DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS, x)
+
+#define DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS     BIT(0)
+#define DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS, x)
+#define DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_STICKY */
+#define DEV2G5_PCS1G_STICKY(t)    __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 48, 0, 1, 4)
+
+#define DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY     BIT(4)
+#define DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY, x)
+#define DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY, x)
+
+#define DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY   BIT(0)
+#define DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY, x)
+#define DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY, x)
+
+/*      DEV1G:PCS_FX100_CONFIGURATION:PCS_FX100_CFG */
+#define DEV2G5_PCS_FX100_CFG(t)   __REG(TARGET_DEV2G5, t, 65, 164, 0, 1, 4, 0, 0, 1, 4)
+
+#define DEV2G5_PCS_FX100_CFG_SD_SEL              BIT(26)
+#define DEV2G5_PCS_FX100_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SD_SEL, x)
+#define DEV2G5_PCS_FX100_CFG_SD_SEL_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SD_SEL, x)
+
+#define DEV2G5_PCS_FX100_CFG_SD_POL              BIT(25)
+#define DEV2G5_PCS_FX100_CFG_SD_POL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SD_POL, x)
+#define DEV2G5_PCS_FX100_CFG_SD_POL_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SD_POL, x)
+
+#define DEV2G5_PCS_FX100_CFG_SD_ENA              BIT(24)
+#define DEV2G5_PCS_FX100_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SD_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SD_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA        BIT(20)
+#define DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA        BIT(16)
+#define DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_RXBITSEL            GENMASK(15, 12)
+#define DEV2G5_PCS_FX100_CFG_RXBITSEL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_RXBITSEL, x)
+#define DEV2G5_PCS_FX100_CFG_RXBITSEL_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_RXBITSEL, x)
+
+#define DEV2G5_PCS_FX100_CFG_SIGDET_CFG          GENMASK(10, 9)
+#define DEV2G5_PCS_FX100_CFG_SIGDET_CFG_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SIGDET_CFG, x)
+#define DEV2G5_PCS_FX100_CFG_SIGDET_CFG_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SIGDET_CFG, x)
+
+#define DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA     BIT(8)
+#define DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER       GENMASK(7, 4)
+#define DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER, x)
+#define DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER, x)
+
+#define DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA     BIT(3)
+#define DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_FEFCHK_ENA          BIT(2)
+#define DEV2G5_PCS_FX100_CFG_FEFCHK_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_FEFCHK_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_FEFCHK_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_FEFCHK_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_FEFGEN_ENA          BIT(1)
+#define DEV2G5_PCS_FX100_CFG_FEFGEN_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_FEFGEN_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_FEFGEN_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_FEFGEN_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_PCS_ENA             BIT(0)
+#define DEV2G5_PCS_FX100_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_PCS_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_PCS_ENA, x)
+
+/*      DEV1G:PCS_FX100_STATUS:PCS_FX100_STATUS */
+#define DEV2G5_PCS_FX100_STATUS(t) __REG(TARGET_DEV2G5, t, 65, 168, 0, 1, 4, 0, 0, 1, 4)
+
+#define DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP     GENMASK(11, 8)
+#define DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP, x)
+#define DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP, x)
+
+#define DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY BIT(7)
+#define DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY BIT(6)
+#define DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY BIT(5)
+#define DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY BIT(4)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_FEF_STATUS       BIT(2)
+#define DEV2G5_PCS_FX100_STATUS_FEF_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_FEF_STATUS, x)
+#define DEV2G5_PCS_FX100_STATUS_FEF_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_FEF_STATUS, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT    BIT(1)
+#define DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT, x)
+#define DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SYNC_STATUS      BIT(0)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SYNC_STATUS, x)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SYNC_STATUS, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV5G_MAC_ENA_CFG(t)      __REG(TARGET_DEV5G, t, 13, 0, 0, 1, 60, 0, 0, 1, 4)
+
+#define DEV5G_MAC_ENA_CFG_RX_ENA                 BIT(4)
+#define DEV5G_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ENA_CFG_RX_ENA, x)
+#define DEV5G_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV5G_MAC_ENA_CFG_TX_ENA                 BIT(0)
+#define DEV5G_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ENA_CFG_TX_ENA, x)
+#define DEV5G_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV5G_MAC_MAXLEN_CFG(t)   __REG(TARGET_DEV5G, t, 13, 0, 0, 1, 60, 8, 0, 1, 4)
+
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK     BIT(16)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(x)\
+	FIELD_PREP(DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_GET(x)\
+	FIELD_GET(DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN             GENMASK(15, 0)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV5G_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV5G_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV5G_MAC_ADV_CHK_CFG(t)  __REG(TARGET_DEV5G, t, 13, 0, 0, 1, 60, 28, 0, 1, 4)
+
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA    BIT(24)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA    BIT(20)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA        BIT(16)
+#define DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS    BIT(12)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA        BIT(8)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA        BIT(4)
+#define DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA        BIT(0)
+#define DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SYMBOL_ERR_CNT */
+#define DEV5G_RX_SYMBOL_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 0, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_PAUSE_CNT */
+#define DEV5G_RX_PAUSE_CNT(t)     __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 4, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_UNSUP_OPCODE_CNT */
+#define DEV5G_RX_UNSUP_OPCODE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 8, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_UC_CNT */
+#define DEV5G_RX_UC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 12, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_MC_CNT */
+#define DEV5G_RX_MC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 16, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_BC_CNT */
+#define DEV5G_RX_BC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 20, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_CRC_ERR_CNT */
+#define DEV5G_RX_CRC_ERR_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 24, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_UNDERSIZE_CNT */
+#define DEV5G_RX_UNDERSIZE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 28, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_FRAGMENTS_CNT */
+#define DEV5G_RX_FRAGMENTS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 32, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_IN_RANGE_LEN_ERR_CNT */
+#define DEV5G_RX_IN_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 36, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define DEV5G_RX_OUT_OF_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 40, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_OVERSIZE_CNT */
+#define DEV5G_RX_OVERSIZE_CNT(t)  __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 44, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_JABBERS_CNT */
+#define DEV5G_RX_JABBERS_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 48, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE64_CNT */
+#define DEV5G_RX_SIZE64_CNT(t)    __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 52, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE65TO127_CNT */
+#define DEV5G_RX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 56, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE128TO255_CNT */
+#define DEV5G_RX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 60, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE256TO511_CNT */
+#define DEV5G_RX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 64, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE512TO1023_CNT */
+#define DEV5G_RX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 68, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE1024TO1518_CNT */
+#define DEV5G_RX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 72, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE1519TOMAX_CNT */
+#define DEV5G_RX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 76, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_IPG_SHRINK_CNT */
+#define DEV5G_RX_IPG_SHRINK_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 80, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_PAUSE_CNT */
+#define DEV5G_TX_PAUSE_CNT(t)     __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 84, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_UC_CNT */
+#define DEV5G_TX_UC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 88, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_MC_CNT */
+#define DEV5G_TX_MC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 92, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_BC_CNT */
+#define DEV5G_TX_BC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 96, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE64_CNT */
+#define DEV5G_TX_SIZE64_CNT(t)    __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 100, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE65TO127_CNT */
+#define DEV5G_TX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 104, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE128TO255_CNT */
+#define DEV5G_TX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 108, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE256TO511_CNT */
+#define DEV5G_TX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 112, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE512TO1023_CNT */
+#define DEV5G_TX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 116, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE1024TO1518_CNT */
+#define DEV5G_TX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 120, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE1519TOMAX_CNT */
+#define DEV5G_TX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 124, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_ALIGNMENT_LOST_CNT */
+#define DEV5G_RX_ALIGNMENT_LOST_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 128, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_TAGGED_FRMS_CNT */
+#define DEV5G_RX_TAGGED_FRMS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 132, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_UNTAGGED_FRMS_CNT */
+#define DEV5G_RX_UNTAGGED_FRMS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 136, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_TAGGED_FRMS_CNT */
+#define DEV5G_TX_TAGGED_FRMS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 140, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_UNTAGGED_FRMS_CNT */
+#define DEV5G_TX_UNTAGGED_FRMS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 144, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SYMBOL_ERR_CNT */
+#define DEV5G_PMAC_RX_SYMBOL_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 148, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_PAUSE_CNT */
+#define DEV5G_PMAC_RX_PAUSE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 152, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_UNSUP_OPCODE_CNT */
+#define DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 156, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_UC_CNT */
+#define DEV5G_PMAC_RX_UC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 160, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_MC_CNT */
+#define DEV5G_PMAC_RX_MC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 164, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_BC_CNT */
+#define DEV5G_PMAC_RX_BC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 168, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_CRC_ERR_CNT */
+#define DEV5G_PMAC_RX_CRC_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 172, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_UNDERSIZE_CNT */
+#define DEV5G_PMAC_RX_UNDERSIZE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 176, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_FRAGMENTS_CNT */
+#define DEV5G_PMAC_RX_FRAGMENTS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 180, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_IN_RANGE_LEN_ERR_CNT */
+#define DEV5G_PMAC_RX_IN_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G,\
+					t, 13, 60, 0, 1, 312, 184, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define DEV5G_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G,\
+					t, 13, 60, 0, 1, 312, 188, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_OVERSIZE_CNT */
+#define DEV5G_PMAC_RX_OVERSIZE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 192, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_JABBERS_CNT */
+#define DEV5G_PMAC_RX_JABBERS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 196, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE64_CNT */
+#define DEV5G_PMAC_RX_SIZE64_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 200, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE65TO127_CNT */
+#define DEV5G_PMAC_RX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 204, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE128TO255_CNT */
+#define DEV5G_PMAC_RX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 208, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE256TO511_CNT */
+#define DEV5G_PMAC_RX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 212, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE512TO1023_CNT */
+#define DEV5G_PMAC_RX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 216, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE1024TO1518_CNT */
+#define DEV5G_PMAC_RX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 220, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE1519TOMAX_CNT */
+#define DEV5G_PMAC_RX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 224, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_PAUSE_CNT */
+#define DEV5G_PMAC_TX_PAUSE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 228, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_UC_CNT */
+#define DEV5G_PMAC_TX_UC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 232, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_MC_CNT */
+#define DEV5G_PMAC_TX_MC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 236, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_BC_CNT */
+#define DEV5G_PMAC_TX_BC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 240, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE64_CNT */
+#define DEV5G_PMAC_TX_SIZE64_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 244, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE65TO127_CNT */
+#define DEV5G_PMAC_TX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 248, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE128TO255_CNT */
+#define DEV5G_PMAC_TX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 252, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE256TO511_CNT */
+#define DEV5G_PMAC_TX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 256, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE512TO1023_CNT */
+#define DEV5G_PMAC_TX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 260, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE1024TO1518_CNT */
+#define DEV5G_PMAC_TX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 264, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE1519TOMAX_CNT */
+#define DEV5G_PMAC_TX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 268, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_ALIGNMENT_LOST_CNT */
+#define DEV5G_PMAC_RX_ALIGNMENT_LOST_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 272, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:MM_RX_ASSEMBLY_ERR_CNT */
+#define DEV5G_MM_RX_ASSEMBLY_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 276, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:MM_RX_SMD_ERR_CNT */
+#define DEV5G_MM_RX_SMD_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 280, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:MM_RX_ASSEMBLY_OK_CNT */
+#define DEV5G_MM_RX_ASSEMBLY_OK_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 284, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:MM_RX_MERGE_FRAG_CNT */
+#define DEV5G_MM_RX_MERGE_FRAG_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 288, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:MM_TX_PFRAGMENT_CNT */
+#define DEV5G_MM_TX_PFRAGMENT_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 292, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_HIH_CKSM_ERR_CNT */
+#define DEV5G_RX_HIH_CKSM_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 296, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_XGMII_PROT_ERR_CNT */
+#define DEV5G_RX_XGMII_PROT_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 300, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_HIH_CKSM_ERR_CNT */
+#define DEV5G_PMAC_RX_HIH_CKSM_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 304, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_XGMII_PROT_ERR_CNT */
+#define DEV5G_PMAC_RX_XGMII_PROT_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 308, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_IN_BYTES_CNT */
+#define DEV5G_RX_IN_BYTES_CNT(t)  __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 0, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_IN_BYTES_MSB_CNT */
+#define DEV5G_RX_IN_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 4, 0, 1, 4)
+
+#define DEV5G_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT, x)
+#define DEV5G_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_RX_IN_BYTES_MSB_CNT_RX_IN_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_OK_BYTES_CNT */
+#define DEV5G_RX_OK_BYTES_CNT(t)  __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 8, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_OK_BYTES_MSB_CNT */
+#define DEV5G_RX_OK_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 12, 0, 1, 4)
+
+#define DEV5G_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT, x)
+#define DEV5G_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_RX_OK_BYTES_MSB_CNT_RX_OK_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_BAD_BYTES_CNT */
+#define DEV5G_RX_BAD_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 16, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_BAD_BYTES_MSB_CNT */
+#define DEV5G_RX_BAD_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 20, 0, 1, 4)
+
+#define DEV5G_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT, x)
+#define DEV5G_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_RX_BAD_BYTES_MSB_CNT_RX_BAD_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:TX_OUT_BYTES_CNT */
+#define DEV5G_TX_OUT_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 24, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:TX_OUT_BYTES_MSB_CNT */
+#define DEV5G_TX_OUT_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 28, 0, 1, 4)
+
+#define DEV5G_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT, x)
+#define DEV5G_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_TX_OUT_BYTES_MSB_CNT_TX_OUT_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:TX_OK_BYTES_CNT */
+#define DEV5G_TX_OK_BYTES_CNT(t)  __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 32, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:TX_OK_BYTES_MSB_CNT */
+#define DEV5G_TX_OK_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 36, 0, 1, 4)
+
+#define DEV5G_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT, x)
+#define DEV5G_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_TX_OK_BYTES_MSB_CNT_TX_OK_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_RX_OK_BYTES_CNT */
+#define DEV5G_PMAC_RX_OK_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 40, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_RX_OK_BYTES_MSB_CNT */
+#define DEV5G_PMAC_RX_OK_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 44, 0, 1, 4)
+
+#define DEV5G_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT, x)
+#define DEV5G_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_PMAC_RX_OK_BYTES_MSB_CNT_PMAC_RX_OK_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_RX_BAD_BYTES_CNT */
+#define DEV5G_PMAC_RX_BAD_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 48, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_RX_BAD_BYTES_MSB_CNT */
+#define DEV5G_PMAC_RX_BAD_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 52, 0, 1, 4)
+
+#define DEV5G_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT, x)
+#define DEV5G_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_PMAC_RX_BAD_BYTES_MSB_CNT_PMAC_RX_BAD_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_TX_OK_BYTES_CNT */
+#define DEV5G_PMAC_TX_OK_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 56, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_TX_OK_BYTES_MSB_CNT */
+#define DEV5G_PMAC_TX_OK_BYTES_MSB_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 60, 0, 1, 4)
+
+#define DEV5G_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT GENMASK(7, 0)
+#define DEV5G_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT_SET(x)\
+	FIELD_PREP(DEV5G_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT, x)
+#define DEV5G_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT_GET(x)\
+	FIELD_GET(DEV5G_PMAC_TX_OK_BYTES_MSB_CNT_PMAC_TX_OK_BYTES_MSB_CNT, x)
+
+/*      DEV10G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV5G_DEV_RST_CTRL(t)     __REG(TARGET_DEV5G, t, 13, 436, 0, 1, 52, 0, 0, 1, 4)
+
+#define DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA       BIT(28)
+#define DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+#define DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+
+#define DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(27)
+#define DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS GENMASK(26, 25)
+#define DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+#define DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+
+#define DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL      GENMASK(24, 23)
+#define DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+#define DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+
+#define DEV5G_DEV_RST_CTRL_SPEED_SEL             GENMASK(22, 20)
+#define DEV5G_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV5G_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV5G_DEV_RST_CTRL_PCS_TX_RST            BIT(12)
+#define DEV5G_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV5G_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV5G_DEV_RST_CTRL_PCS_RX_RST            BIT(8)
+#define DEV5G_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV5G_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV5G_DEV_RST_CTRL_MAC_TX_RST            BIT(4)
+#define DEV5G_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV5G_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV5G_DEV_RST_CTRL_MAC_RX_RST            BIT(0)
+#define DEV5G_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV5G_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DSM:RAM_CTRL:RAM_INIT */
+#define DSM_RAM_INIT              __REG(TARGET_DSM, 0, 1, 0, 0, 1, 4, 0, 0, 1, 4)
+
+#define DSM_RAM_INIT_RAM_INIT                    BIT(1)
+#define DSM_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(DSM_RAM_INIT_RAM_INIT, x)
+#define DSM_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(DSM_RAM_INIT_RAM_INIT, x)
+
+#define DSM_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define DSM_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(DSM_RAM_INIT_RAM_CFG_HOOK, x)
+#define DSM_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(DSM_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      DSM:CFG:BUF_CFG */
+#define DSM_BUF_CFG(r)            __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 0, r, 67, 4)
+
+#define DSM_BUF_CFG_CSC_STAT_DIS                 BIT(13)
+#define DSM_BUF_CFG_CSC_STAT_DIS_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_CSC_STAT_DIS, x)
+#define DSM_BUF_CFG_CSC_STAT_DIS_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_CSC_STAT_DIS, x)
+
+#define DSM_BUF_CFG_AGING_ENA                    BIT(12)
+#define DSM_BUF_CFG_AGING_ENA_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_AGING_ENA, x)
+#define DSM_BUF_CFG_AGING_ENA_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_AGING_ENA, x)
+
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS       BIT(11)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS, x)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS, x)
+
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT   GENMASK(10, 0)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT, x)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT, x)
+
+/*      DSM:CFG:DEV_TX_STOP_WM_CFG */
+#define DSM_DEV_TX_STOP_WM_CFG(r) __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 1360, r, 67, 4)
+
+#define DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA  BIT(9)
+#define DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA, x)
+#define DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA, x)
+
+#define DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA BIT(8)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA, x)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA, x)
+
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM    GENMASK(7, 1)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM, x)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM, x)
+
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR    BIT(0)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR, x)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR, x)
+
+/*      DSM:CFG:RX_PAUSE_CFG */
+#define DSM_RX_PAUSE_CFG(r)       __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 1628, r, 67, 4)
+
+#define DSM_RX_PAUSE_CFG_RX_PAUSE_EN             BIT(1)
+#define DSM_RX_PAUSE_CFG_RX_PAUSE_EN_SET(x)\
+	FIELD_PREP(DSM_RX_PAUSE_CFG_RX_PAUSE_EN, x)
+#define DSM_RX_PAUSE_CFG_RX_PAUSE_EN_GET(x)\
+	FIELD_GET(DSM_RX_PAUSE_CFG_RX_PAUSE_EN, x)
+
+#define DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL           BIT(0)
+#define DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL_SET(x)\
+	FIELD_PREP(DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL, x)
+#define DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL_GET(x)\
+	FIELD_GET(DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL, x)
+
+/*      DSM:CFG:MAC_CFG */
+#define DSM_MAC_CFG(r)            __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 2432, r, 67, 4)
+
+#define DSM_MAC_CFG_TX_PAUSE_VAL                 GENMASK(31, 16)
+#define DSM_MAC_CFG_TX_PAUSE_VAL_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_TX_PAUSE_VAL, x)
+#define DSM_MAC_CFG_TX_PAUSE_VAL_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_TX_PAUSE_VAL, x)
+
+#define DSM_MAC_CFG_HDX_BACKPREASSURE            BIT(2)
+#define DSM_MAC_CFG_HDX_BACKPREASSURE_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_HDX_BACKPREASSURE, x)
+#define DSM_MAC_CFG_HDX_BACKPREASSURE_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_HDX_BACKPREASSURE, x)
+
+#define DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE         BIT(1)
+#define DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE, x)
+#define DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE, x)
+
+#define DSM_MAC_CFG_TX_PAUSE_XON_XOFF            BIT(0)
+#define DSM_MAC_CFG_TX_PAUSE_XON_XOFF_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_TX_PAUSE_XON_XOFF, x)
+#define DSM_MAC_CFG_TX_PAUSE_XON_XOFF_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_TX_PAUSE_XON_XOFF, x)
+
+/*      DSM:CFG:MAC_ADDR_BASE_HIGH_CFG */
+#define DSM_MAC_ADDR_BASE_HIGH_CFG(r) __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 2700, r, 65, 4)
+
+#define DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH GENMASK(23, 0)
+#define DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH_SET(x)\
+	FIELD_PREP(DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH, x)
+#define DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH_GET(x)\
+	FIELD_GET(DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH, x)
+
+/*      DSM:CFG:MAC_ADDR_BASE_LOW_CFG */
+#define DSM_MAC_ADDR_BASE_LOW_CFG(r) __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 2960, r, 65, 4)
+
+#define DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW   GENMASK(23, 0)
+#define DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW_SET(x)\
+	FIELD_PREP(DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW, x)
+#define DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW_GET(x)\
+	FIELD_GET(DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW, x)
+
+/*      DSM:CFG:TAXI_CAL_CFG */
+#define DSM_TAXI_CAL_CFG(r)       __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 3224, r, 9, 4)
+
+#define DSM_TAXI_CAL_CFG_CAL_IDX                 GENMASK(20, 15)
+#define DSM_TAXI_CAL_CFG_CAL_IDX_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_IDX, x)
+#define DSM_TAXI_CAL_CFG_CAL_IDX_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_IDX, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_CUR_LEN             GENMASK(14, 9)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_LEN_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_CUR_LEN, x)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_LEN_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_CUR_LEN, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_CUR_VAL             GENMASK(8, 5)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_VAL_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_CUR_VAL, x)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_VAL_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_CUR_VAL, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_PGM_VAL             GENMASK(4, 1)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_VAL_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_PGM_VAL, x)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_VAL_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_PGM_VAL, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_PGM_ENA             BIT(0)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_ENA_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_PGM_ENA, x)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_ENA_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_PGM_ENA, x)
+
+/*      EACL:POL_CFG:POL_EACL_CFG */
+#define EACL_POL_EACL_CFG         __REG(TARGET_EACL, 0, 1, 150608, 0, 1, 780, 768, 0, 1, 4)
+
+#define EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED BIT(5)
+#define EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED, x)
+#define EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED, x)
+
+#define EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY     BIT(4)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY, x)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY, x)
+
+#define EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY    BIT(3)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY, x)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY, x)
+
+#define EACL_POL_EACL_CFG_EACL_FORCE_CLOSE       BIT(2)
+#define EACL_POL_EACL_CFG_EACL_FORCE_CLOSE_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_FORCE_CLOSE, x)
+#define EACL_POL_EACL_CFG_EACL_FORCE_CLOSE_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_CLOSE, x)
+
+#define EACL_POL_EACL_CFG_EACL_FORCE_OPEN        BIT(1)
+#define EACL_POL_EACL_CFG_EACL_FORCE_OPEN_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_FORCE_OPEN, x)
+#define EACL_POL_EACL_CFG_EACL_FORCE_OPEN_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_OPEN, x)
+
+#define EACL_POL_EACL_CFG_EACL_FORCE_INIT        BIT(0)
+#define EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_FORCE_INIT, x)
+#define EACL_POL_EACL_CFG_EACL_FORCE_INIT_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_INIT, x)
+
+/*      EACL:RAM_CTRL:RAM_INIT */
+#define EACL_RAM_INIT             __REG(TARGET_EACL, 0, 1, 118736, 0, 1, 4, 0, 0, 1, 4)
+
+#define EACL_RAM_INIT_RAM_INIT                   BIT(1)
+#define EACL_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(EACL_RAM_INIT_RAM_INIT, x)
+#define EACL_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(EACL_RAM_INIT_RAM_INIT, x)
+
+#define EACL_RAM_INIT_RAM_CFG_HOOK               BIT(0)
+#define EACL_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(EACL_RAM_INIT_RAM_CFG_HOOK, x)
+#define EACL_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(EACL_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      FDMA:FDMA:FDMA_CH_ACTIVATE */
+#define FDMA_CH_ACTIVATE          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 0, 0, 1, 4)
+
+#define FDMA_CH_ACTIVATE_CH_ACTIVATE             GENMASK(7, 0)
+#define FDMA_CH_ACTIVATE_CH_ACTIVATE_SET(x)\
+	FIELD_PREP(FDMA_CH_ACTIVATE_CH_ACTIVATE, x)
+#define FDMA_CH_ACTIVATE_CH_ACTIVATE_GET(x)\
+	FIELD_GET(FDMA_CH_ACTIVATE_CH_ACTIVATE, x)
+
+/*      FDMA:FDMA:FDMA_CH_RELOAD */
+#define FDMA_CH_RELOAD            __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 4, 0, 1, 4)
+
+#define FDMA_CH_RELOAD_CH_RELOAD                 GENMASK(7, 0)
+#define FDMA_CH_RELOAD_CH_RELOAD_SET(x)\
+	FIELD_PREP(FDMA_CH_RELOAD_CH_RELOAD, x)
+#define FDMA_CH_RELOAD_CH_RELOAD_GET(x)\
+	FIELD_GET(FDMA_CH_RELOAD_CH_RELOAD, x)
+
+/*      FDMA:FDMA:FDMA_CH_DISABLE */
+#define FDMA_CH_DISABLE           __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 8, 0, 1, 4)
+
+#define FDMA_CH_DISABLE_CH_DISABLE               GENMASK(7, 0)
+#define FDMA_CH_DISABLE_CH_DISABLE_SET(x)\
+	FIELD_PREP(FDMA_CH_DISABLE_CH_DISABLE, x)
+#define FDMA_CH_DISABLE_CH_DISABLE_GET(x)\
+	FIELD_GET(FDMA_CH_DISABLE_CH_DISABLE, x)
+
+/*      FDMA:FDMA:FDMA_DCB_LLP */
+#define FDMA_DCB_LLP(r)           __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 52, r, 8, 4)
+
+/*      FDMA:FDMA:FDMA_DCB_LLP1 */
+#define FDMA_DCB_LLP1(r)          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 84, r, 8, 4)
+
+/*      FDMA:FDMA:FDMA_DCB_LLP_PREV */
+#define FDMA_DCB_LLP_PREV(r)      __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 116, r, 8, 4)
+
+/*      FDMA:FDMA:FDMA_DCB_LLP_PREV1 */
+#define FDMA_DCB_LLP_PREV1(r)     __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 148, r, 8, 4)
+
+/*      FDMA:FDMA:FDMA_CH_CFG */
+#define FDMA_CH_CFG(r)            __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 224, r, 8, 4)
+
+#define FDMA_CH_CFG_CH_XTR_STATUS_MODE           BIT(7)
+#define FDMA_CH_CFG_CH_XTR_STATUS_MODE_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_XTR_STATUS_MODE, x)
+#define FDMA_CH_CFG_CH_XTR_STATUS_MODE_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_XTR_STATUS_MODE, x)
+
+#define FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY          BIT(6)
+#define FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY, x)
+#define FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_INTR_DB_EOF_ONLY, x)
+
+#define FDMA_CH_CFG_CH_INJ_PORT                  BIT(5)
+#define FDMA_CH_CFG_CH_INJ_PORT_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_INJ_PORT, x)
+#define FDMA_CH_CFG_CH_INJ_PORT_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_INJ_PORT, x)
+
+#define FDMA_CH_CFG_CH_DCB_DB_CNT                GENMASK(4, 1)
+#define FDMA_CH_CFG_CH_DCB_DB_CNT_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_DCB_DB_CNT, x)
+#define FDMA_CH_CFG_CH_DCB_DB_CNT_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_DCB_DB_CNT, x)
+
+#define FDMA_CH_CFG_CH_MEM                       BIT(0)
+#define FDMA_CH_CFG_CH_MEM_SET(x)\
+	FIELD_PREP(FDMA_CH_CFG_CH_MEM, x)
+#define FDMA_CH_CFG_CH_MEM_GET(x)\
+	FIELD_GET(FDMA_CH_CFG_CH_MEM, x)
+
+/*      FDMA:FDMA:FDMA_CH_TRANSLATE */
+#define FDMA_CH_TRANSLATE(r)      __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 256, r, 8, 4)
+
+#define FDMA_CH_TRANSLATE_OFFSET                 GENMASK(15, 0)
+#define FDMA_CH_TRANSLATE_OFFSET_SET(x)\
+	FIELD_PREP(FDMA_CH_TRANSLATE_OFFSET, x)
+#define FDMA_CH_TRANSLATE_OFFSET_GET(x)\
+	FIELD_GET(FDMA_CH_TRANSLATE_OFFSET, x)
+
+/*      FDMA:FDMA:FDMA_XTR_CFG */
+#define FDMA_XTR_CFG              __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 364, 0, 1, 4)
+
+#define FDMA_XTR_CFG_XTR_FIFO_WM                 GENMASK(15, 11)
+#define FDMA_XTR_CFG_XTR_FIFO_WM_SET(x)\
+	FIELD_PREP(FDMA_XTR_CFG_XTR_FIFO_WM, x)
+#define FDMA_XTR_CFG_XTR_FIFO_WM_GET(x)\
+	FIELD_GET(FDMA_XTR_CFG_XTR_FIFO_WM, x)
+
+#define FDMA_XTR_CFG_XTR_ARB_SAT                 GENMASK(10, 0)
+#define FDMA_XTR_CFG_XTR_ARB_SAT_SET(x)\
+	FIELD_PREP(FDMA_XTR_CFG_XTR_ARB_SAT, x)
+#define FDMA_XTR_CFG_XTR_ARB_SAT_GET(x)\
+	FIELD_GET(FDMA_XTR_CFG_XTR_ARB_SAT, x)
+
+/*      FDMA:FDMA:FDMA_PORT_CTRL */
+#define FDMA_PORT_CTRL(r)         __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 376, r, 2, 4)
+
+#define FDMA_PORT_CTRL_INJ_STOP                  BIT(4)
+#define FDMA_PORT_CTRL_INJ_STOP_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_INJ_STOP, x)
+#define FDMA_PORT_CTRL_INJ_STOP_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_INJ_STOP, x)
+
+#define FDMA_PORT_CTRL_INJ_STOP_FORCE            BIT(3)
+#define FDMA_PORT_CTRL_INJ_STOP_FORCE_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_INJ_STOP_FORCE, x)
+#define FDMA_PORT_CTRL_INJ_STOP_FORCE_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_INJ_STOP_FORCE, x)
+
+#define FDMA_PORT_CTRL_XTR_STOP                  BIT(2)
+#define FDMA_PORT_CTRL_XTR_STOP_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_XTR_STOP, x)
+#define FDMA_PORT_CTRL_XTR_STOP_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_XTR_STOP, x)
+
+#define FDMA_PORT_CTRL_XTR_BUF_IS_EMPTY          BIT(1)
+#define FDMA_PORT_CTRL_XTR_BUF_IS_EMPTY_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_XTR_BUF_IS_EMPTY, x)
+#define FDMA_PORT_CTRL_XTR_BUF_IS_EMPTY_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_XTR_BUF_IS_EMPTY, x)
+
+#define FDMA_PORT_CTRL_XTR_BUF_RST               BIT(0)
+#define FDMA_PORT_CTRL_XTR_BUF_RST_SET(x)\
+	FIELD_PREP(FDMA_PORT_CTRL_XTR_BUF_RST, x)
+#define FDMA_PORT_CTRL_XTR_BUF_RST_GET(x)\
+	FIELD_GET(FDMA_PORT_CTRL_XTR_BUF_RST, x)
+
+/*      FDMA:FDMA:FDMA_INTR_DCB */
+#define FDMA_INTR_DCB             __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 384, 0, 1, 4)
+
+#define FDMA_INTR_DCB_INTR_DCB                   GENMASK(7, 0)
+#define FDMA_INTR_DCB_INTR_DCB_SET(x)\
+	FIELD_PREP(FDMA_INTR_DCB_INTR_DCB, x)
+#define FDMA_INTR_DCB_INTR_DCB_GET(x)\
+	FIELD_GET(FDMA_INTR_DCB_INTR_DCB, x)
+
+/*      FDMA:FDMA:FDMA_INTR_DCB_ENA */
+#define FDMA_INTR_DCB_ENA         __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 388, 0, 1, 4)
+
+#define FDMA_INTR_DCB_ENA_INTR_DCB_ENA           GENMASK(7, 0)
+#define FDMA_INTR_DCB_ENA_INTR_DCB_ENA_SET(x)\
+	FIELD_PREP(FDMA_INTR_DCB_ENA_INTR_DCB_ENA, x)
+#define FDMA_INTR_DCB_ENA_INTR_DCB_ENA_GET(x)\
+	FIELD_GET(FDMA_INTR_DCB_ENA_INTR_DCB_ENA, x)
+
+/*      FDMA:FDMA:FDMA_INTR_DB */
+#define FDMA_INTR_DB              __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 392, 0, 1, 4)
+
+#define FDMA_INTR_DB_INTR_DB                     GENMASK(7, 0)
+#define FDMA_INTR_DB_INTR_DB_SET(x)\
+	FIELD_PREP(FDMA_INTR_DB_INTR_DB, x)
+#define FDMA_INTR_DB_INTR_DB_GET(x)\
+	FIELD_GET(FDMA_INTR_DB_INTR_DB, x)
+
+/*      FDMA:FDMA:FDMA_INTR_DB_ENA */
+#define FDMA_INTR_DB_ENA          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 396, 0, 1, 4)
+
+#define FDMA_INTR_DB_ENA_INTR_DB_ENA             GENMASK(7, 0)
+#define FDMA_INTR_DB_ENA_INTR_DB_ENA_SET(x)\
+	FIELD_PREP(FDMA_INTR_DB_ENA_INTR_DB_ENA, x)
+#define FDMA_INTR_DB_ENA_INTR_DB_ENA_GET(x)\
+	FIELD_GET(FDMA_INTR_DB_ENA_INTR_DB_ENA, x)
+
+/*      FDMA:FDMA:FDMA_INTR_ERR */
+#define FDMA_INTR_ERR             __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 400, 0, 1, 4)
+
+#define FDMA_INTR_ERR_INTR_PORT_ERR              GENMASK(9, 8)
+#define FDMA_INTR_ERR_INTR_PORT_ERR_SET(x)\
+	FIELD_PREP(FDMA_INTR_ERR_INTR_PORT_ERR, x)
+#define FDMA_INTR_ERR_INTR_PORT_ERR_GET(x)\
+	FIELD_GET(FDMA_INTR_ERR_INTR_PORT_ERR, x)
+
+#define FDMA_INTR_ERR_INTR_CH_ERR                GENMASK(7, 0)
+#define FDMA_INTR_ERR_INTR_CH_ERR_SET(x)\
+	FIELD_PREP(FDMA_INTR_ERR_INTR_CH_ERR, x)
+#define FDMA_INTR_ERR_INTR_CH_ERR_GET(x)\
+	FIELD_GET(FDMA_INTR_ERR_INTR_CH_ERR, x)
+
+/*      FDMA:FDMA:FDMA_ERRORS */
+#define FDMA_ERRORS               __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 412, 0, 1, 4)
+
+#define FDMA_ERRORS_ERR_XTR_WR                   GENMASK(31, 30)
+#define FDMA_ERRORS_ERR_XTR_WR_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_XTR_WR, x)
+#define FDMA_ERRORS_ERR_XTR_WR_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_XTR_WR, x)
+
+#define FDMA_ERRORS_ERR_XTR_OVF                  GENMASK(29, 28)
+#define FDMA_ERRORS_ERR_XTR_OVF_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_XTR_OVF, x)
+#define FDMA_ERRORS_ERR_XTR_OVF_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_XTR_OVF, x)
+
+#define FDMA_ERRORS_ERR_XTR_TAXI32_OVF           GENMASK(27, 26)
+#define FDMA_ERRORS_ERR_XTR_TAXI32_OVF_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_XTR_TAXI32_OVF, x)
+#define FDMA_ERRORS_ERR_XTR_TAXI32_OVF_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_XTR_TAXI32_OVF, x)
+
+#define FDMA_ERRORS_ERR_DCB_XTR_DATAL            GENMASK(25, 24)
+#define FDMA_ERRORS_ERR_DCB_XTR_DATAL_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_DCB_XTR_DATAL, x)
+#define FDMA_ERRORS_ERR_DCB_XTR_DATAL_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_DCB_XTR_DATAL, x)
+
+#define FDMA_ERRORS_ERR_DCB_RD                   GENMASK(23, 16)
+#define FDMA_ERRORS_ERR_DCB_RD_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_DCB_RD, x)
+#define FDMA_ERRORS_ERR_DCB_RD_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_DCB_RD, x)
+
+#define FDMA_ERRORS_ERR_INJ_RD                   GENMASK(15, 10)
+#define FDMA_ERRORS_ERR_INJ_RD_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_INJ_RD, x)
+#define FDMA_ERRORS_ERR_INJ_RD_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_INJ_RD, x)
+
+#define FDMA_ERRORS_ERR_INJ_OUT_OF_SYNC          GENMASK(9, 8)
+#define FDMA_ERRORS_ERR_INJ_OUT_OF_SYNC_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_INJ_OUT_OF_SYNC, x)
+#define FDMA_ERRORS_ERR_INJ_OUT_OF_SYNC_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_INJ_OUT_OF_SYNC, x)
+
+#define FDMA_ERRORS_ERR_CH_WR                    GENMASK(7, 0)
+#define FDMA_ERRORS_ERR_CH_WR_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_ERR_CH_WR, x)
+#define FDMA_ERRORS_ERR_CH_WR_GET(x)\
+	FIELD_GET(FDMA_ERRORS_ERR_CH_WR, x)
+
+/*      FDMA:FDMA:FDMA_ERRORS_2 */
+#define FDMA_ERRORS_2             __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 416, 0, 1, 4)
+
+#define FDMA_ERRORS_2_ERR_XTR_FRAG               GENMASK(1, 0)
+#define FDMA_ERRORS_2_ERR_XTR_FRAG_SET(x)\
+	FIELD_PREP(FDMA_ERRORS_2_ERR_XTR_FRAG, x)
+#define FDMA_ERRORS_2_ERR_XTR_FRAG_GET(x)\
+	FIELD_GET(FDMA_ERRORS_2_ERR_XTR_FRAG, x)
+
+/*      FDMA:FDMA:FDMA_CTRL */
+#define FDMA_CTRL                 __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 424, 0, 1, 4)
+
+#define FDMA_CTRL_NRESET                         BIT(0)
+#define FDMA_CTRL_NRESET_SET(x)\
+	FIELD_PREP(FDMA_CTRL_NRESET, x)
+#define FDMA_CTRL_NRESET_GET(x)\
+	FIELD_GET(FDMA_CTRL_NRESET, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:CHIP_ID */
+#define GCB_CHIP_ID               __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 0, 0, 1, 4)
+
+#define GCB_CHIP_ID_REV_ID                       GENMASK(31, 28)
+#define GCB_CHIP_ID_REV_ID_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_REV_ID, x)
+#define GCB_CHIP_ID_REV_ID_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_REV_ID, x)
+
+#define GCB_CHIP_ID_PART_ID                      GENMASK(27, 12)
+#define GCB_CHIP_ID_PART_ID_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_PART_ID, x)
+#define GCB_CHIP_ID_PART_ID_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_PART_ID, x)
+
+#define GCB_CHIP_ID_MFG_ID                       GENMASK(11, 1)
+#define GCB_CHIP_ID_MFG_ID_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_MFG_ID, x)
+#define GCB_CHIP_ID_MFG_ID_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_MFG_ID, x)
+
+#define GCB_CHIP_ID_ONE                          BIT(0)
+#define GCB_CHIP_ID_ONE_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_ONE, x)
+#define GCB_CHIP_ID_ONE_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_ONE, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:SOFT_RST */
+#define GCB_SOFT_RST              __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 8, 0, 1, 4)
+
+#define GCB_SOFT_RST_SOFT_NON_CFG_RST            BIT(2)
+#define GCB_SOFT_RST_SOFT_NON_CFG_RST_SET(x)\
+	FIELD_PREP(GCB_SOFT_RST_SOFT_NON_CFG_RST, x)
+#define GCB_SOFT_RST_SOFT_NON_CFG_RST_GET(x)\
+	FIELD_GET(GCB_SOFT_RST_SOFT_NON_CFG_RST, x)
+
+#define GCB_SOFT_RST_SOFT_SWC_RST                BIT(1)
+#define GCB_SOFT_RST_SOFT_SWC_RST_SET(x)\
+	FIELD_PREP(GCB_SOFT_RST_SOFT_SWC_RST, x)
+#define GCB_SOFT_RST_SOFT_SWC_RST_GET(x)\
+	FIELD_GET(GCB_SOFT_RST_SOFT_SWC_RST, x)
+
+#define GCB_SOFT_RST_SOFT_CHIP_RST               BIT(0)
+#define GCB_SOFT_RST_SOFT_CHIP_RST_SET(x)\
+	FIELD_PREP(GCB_SOFT_RST_SOFT_CHIP_RST, x)
+#define GCB_SOFT_RST_SOFT_CHIP_RST_GET(x)\
+	FIELD_GET(GCB_SOFT_RST_SOFT_CHIP_RST, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:HW_SGPIO_SD_CFG */
+#define GCB_HW_SGPIO_SD_CFG       __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 20, 0, 1, 4)
+
+#define GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA          BIT(1)
+#define GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA_SET(x)\
+	FIELD_PREP(GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA, x)
+#define GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA_GET(x)\
+	FIELD_GET(GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA, x)
+
+#define GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL           BIT(0)
+#define GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL_SET(x)\
+	FIELD_PREP(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL, x)
+#define GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL_GET(x)\
+	FIELD_GET(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:HW_SGPIO_TO_SD_MAP_CFG */
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG(r) __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 24, r, 65, 4)
+
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL GENMASK(8, 0)
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL_SET(x)\
+	FIELD_PREP(GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL, x)
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL_GET(x)\
+	FIELD_GET(GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL, x)
+
+/*      DEVCPU_GCB:SIO_CTRL:SIO_CLOCK */
+#define GCB_SIO_CLOCK(g)          __REG(TARGET_GCB, 0, 1, 876, g, 3, 280, 20, 0, 1, 4)
+
+#define GCB_SIO_CLOCK_SIO_CLK_FREQ               GENMASK(19, 8)
+#define GCB_SIO_CLOCK_SIO_CLK_FREQ_SET(x)\
+	FIELD_PREP(GCB_SIO_CLOCK_SIO_CLK_FREQ, x)
+#define GCB_SIO_CLOCK_SIO_CLK_FREQ_GET(x)\
+	FIELD_GET(GCB_SIO_CLOCK_SIO_CLK_FREQ, x)
+
+#define GCB_SIO_CLOCK_SYS_CLK_PERIOD             GENMASK(7, 0)
+#define GCB_SIO_CLOCK_SYS_CLK_PERIOD_SET(x)\
+	FIELD_PREP(GCB_SIO_CLOCK_SYS_CLK_PERIOD, x)
+#define GCB_SIO_CLOCK_SYS_CLK_PERIOD_GET(x)\
+	FIELD_GET(GCB_SIO_CLOCK_SYS_CLK_PERIOD, x)
+
+/*      HSCH:HSCH_MISC:SYS_CLK_PER */
+#define HSCH_SYS_CLK_PER          __REG(TARGET_HSCH, 0, 1, 163104, 0, 1, 648, 640, 0, 1, 4)
+
+#define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS       GENMASK(7, 0)
+#define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_SET(x)\
+	FIELD_PREP(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS, x)
+#define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_GET(x)\
+	FIELD_GET(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS, x)
+
+/*      HSCH:SYSTEM:FLUSH_CTRL */
+#define HSCH_FLUSH_CTRL           __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 4, 0, 1, 4)
+
+#define HSCH_FLUSH_CTRL_FLUSH_ENA                BIT(27)
+#define HSCH_FLUSH_CTRL_FLUSH_ENA_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_ENA, x)
+#define HSCH_FLUSH_CTRL_FLUSH_ENA_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_ENA, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_SRC                BIT(26)
+#define HSCH_FLUSH_CTRL_FLUSH_SRC_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_SRC, x)
+#define HSCH_FLUSH_CTRL_FLUSH_SRC_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_SRC, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_DST                BIT(25)
+#define HSCH_FLUSH_CTRL_FLUSH_DST_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_DST, x)
+#define HSCH_FLUSH_CTRL_FLUSH_DST_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_DST, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_PORT               GENMASK(24, 18)
+#define HSCH_FLUSH_CTRL_FLUSH_PORT_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_PORT, x)
+#define HSCH_FLUSH_CTRL_FLUSH_PORT_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_PORT, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_QUEUE              BIT(17)
+#define HSCH_FLUSH_CTRL_FLUSH_QUEUE_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_QUEUE, x)
+#define HSCH_FLUSH_CTRL_FLUSH_QUEUE_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_QUEUE, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_SE                 BIT(16)
+#define HSCH_FLUSH_CTRL_FLUSH_SE_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_SE, x)
+#define HSCH_FLUSH_CTRL_FLUSH_SE_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_SE, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_HIER               GENMASK(15, 0)
+#define HSCH_FLUSH_CTRL_FLUSH_HIER_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_HIER, x)
+#define HSCH_FLUSH_CTRL_FLUSH_HIER_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_HIER, x)
+
+/*      HSCH:SYSTEM:PORT_MODE */
+#define HSCH_PORT_MODE(r)         __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 8, r, 70, 4)
+
+#define HSCH_PORT_MODE_DEQUEUE_DIS               BIT(4)
+#define HSCH_PORT_MODE_DEQUEUE_DIS_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_DEQUEUE_DIS, x)
+#define HSCH_PORT_MODE_DEQUEUE_DIS_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_DEQUEUE_DIS, x)
+
+#define HSCH_PORT_MODE_AGE_DIS                   BIT(3)
+#define HSCH_PORT_MODE_AGE_DIS_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_AGE_DIS, x)
+#define HSCH_PORT_MODE_AGE_DIS_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_AGE_DIS, x)
+
+#define HSCH_PORT_MODE_TRUNC_ENA                 BIT(2)
+#define HSCH_PORT_MODE_TRUNC_ENA_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_TRUNC_ENA, x)
+#define HSCH_PORT_MODE_TRUNC_ENA_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_TRUNC_ENA, x)
+
+#define HSCH_PORT_MODE_EIR_REMARK_ENA            BIT(1)
+#define HSCH_PORT_MODE_EIR_REMARK_ENA_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_EIR_REMARK_ENA, x)
+#define HSCH_PORT_MODE_EIR_REMARK_ENA_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_EIR_REMARK_ENA, x)
+
+#define HSCH_PORT_MODE_CPU_PRIO_MODE             BIT(0)
+#define HSCH_PORT_MODE_CPU_PRIO_MODE_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_CPU_PRIO_MODE, x)
+#define HSCH_PORT_MODE_CPU_PRIO_MODE_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_CPU_PRIO_MODE, x)
+
+/*      HSCH:SYSTEM:OUTB_SHARE_ENA */
+#define HSCH_OUTB_SHARE_ENA(r)    __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 288, r, 5, 4)
+
+#define HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA       GENMASK(7, 0)
+#define HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA_SET(x)\
+	FIELD_PREP(HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA, x)
+#define HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA_GET(x)\
+	FIELD_GET(HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA, x)
+
+/*      HSCH:MMGT:RESET_CFG */
+#define HSCH_RESET_CFG            __REG(TARGET_HSCH, 0, 1, 162368, 0, 1, 16, 8, 0, 1, 4)
+
+#define HSCH_RESET_CFG_CORE_ENA                  BIT(0)
+#define HSCH_RESET_CFG_CORE_ENA_SET(x)\
+	FIELD_PREP(HSCH_RESET_CFG_CORE_ENA, x)
+#define HSCH_RESET_CFG_CORE_ENA_GET(x)\
+	FIELD_GET(HSCH_RESET_CFG_CORE_ENA, x)
+
+/*      HSCH:TAS_CONFIG:TAS_STATEMACHINE_CFG */
+#define HSCH_TAS_STATEMACHINE_CFG __REG(TARGET_HSCH, 0, 1, 162384, 0, 1, 12, 8, 0, 1, 4)
+
+#define HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY    GENMASK(7, 0)
+#define HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_SET(x)\
+	FIELD_PREP(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY, x)
+#define HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_GET(x)\
+	FIELD_GET(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY, x)
+
+/*      LRN:COMMON:COMMON_ACCESS_CTRL */
+#define LRN_COMMON_ACCESS_CTRL    __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 0, 0, 1, 4)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL GENMASK(21, 20)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL, x)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE BIT(19)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE, x)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW GENMASK(18, 5)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW, x)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD    GENMASK(4, 1)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD, x)
+
+#define LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT BIT(0)
+#define LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT, x)
+#define LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT, x)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_0 */
+#define LRN_MAC_ACCESS_CFG_0      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 4, 0, 1, 4)
+
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID       GENMASK(28, 16)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID, x)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID, x)
+
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB   GENMASK(15, 0)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB, x)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB, x)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_1 */
+#define LRN_MAC_ACCESS_CFG_1      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 8, 0, 1, 4)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_2 */
+#define LRN_MAC_ACCESS_CFG_2      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 12, 0, 1, 4)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD BIT(28)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL BIT(27)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU    GENMASK(26, 24)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY  BIT(23)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE BIT(22)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR    BIT(21)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG  GENMASK(20, 19)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL GENMASK(18, 17)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED    BIT(16)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD       BIT(15)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE GENMASK(14, 12)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR      GENMASK(11, 0)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR, x)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_3 */
+#define LRN_MAC_ACCESS_CFG_3      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 16, 0, 1, 4)
+
+#define LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX GENMASK(10, 0)
+#define LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX, x)
+#define LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX, x)
+
+/*      LRN:COMMON:SCAN_NEXT_CFG */
+#define LRN_SCAN_NEXT_CFG         __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 20, 0, 1, 4)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL GENMASK(21, 19)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL GENMASK(18, 17)
+#define LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL    GENMASK(16, 15)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA BIT(14)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA BIT(13)
+#define LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA BIT(12)
+#define LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA BIT(11)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA BIT(10)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA BIT(9)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA BIT(8)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA BIT(7)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK GENMASK(6, 3)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK, x)
+
+#define LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA BIT(2)
+#define LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_FID_FILTER_ENA         BIT(1)
+#define LRN_SCAN_NEXT_CFG_FID_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_FID_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_FID_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_FID_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA        BIT(0)
+#define LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA, x)
+
+/*      LRN:COMMON:SCAN_NEXT_CFG_1 */
+#define LRN_SCAN_NEXT_CFG_1       __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 24, 0, 1, 4)
+
+#define LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR   GENMASK(30, 16)
+#define LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR, x)
+#define LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR, x)
+
+#define LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK GENMASK(14, 0)
+#define LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK, x)
+#define LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK, x)
+
+/*      LRN:COMMON:AUTOAGE_CFG */
+#define LRN_AUTOAGE_CFG(r)        __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 36, r, 4, 4)
+
+#define LRN_AUTOAGE_CFG_UNIT_SIZE                GENMASK(29, 28)
+#define LRN_AUTOAGE_CFG_UNIT_SIZE_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_UNIT_SIZE, x)
+#define LRN_AUTOAGE_CFG_UNIT_SIZE_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_UNIT_SIZE, x)
+
+#define LRN_AUTOAGE_CFG_PERIOD_VAL               GENMASK(27, 0)
+#define LRN_AUTOAGE_CFG_PERIOD_VAL_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_PERIOD_VAL, x)
+#define LRN_AUTOAGE_CFG_PERIOD_VAL_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_PERIOD_VAL, x)
+
+/*      LRN:COMMON:AUTOAGE_CFG_1 */
+#define LRN_AUTOAGE_CFG_1         __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 52, 0, 1, 4)
+
+#define LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA     BIT(25)
+#define LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA, x)
+#define LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA, x)
+
+#define LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN GENMASK(24, 15)
+#define LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN, x)
+#define LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN, x)
+
+#define LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS        GENMASK(14, 7)
+#define LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS, x)
+#define LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS, x)
+
+#define LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA    BIT(6)
+#define LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA, x)
+#define LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA, x)
+
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT     GENMASK(5, 2)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT, x)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT, x)
+
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT BIT(1)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT, x)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT, x)
+
+#define LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA         BIT(0)
+#define LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA, x)
+#define LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA, x)
+
+/*      LRN:COMMON:AUTOAGE_CFG_2 */
+#define LRN_AUTOAGE_CFG_2         __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 56, 0, 1, 4)
+
+#define LRN_AUTOAGE_CFG_2_NEXT_ROW               GENMASK(17, 4)
+#define LRN_AUTOAGE_CFG_2_NEXT_ROW_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_2_NEXT_ROW, x)
+#define LRN_AUTOAGE_CFG_2_NEXT_ROW_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_2_NEXT_ROW, x)
+
+#define LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS    GENMASK(3, 0)
+#define LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS, x)
+#define LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS, x)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_REGION_CTRL_2_OFF_OUTBOUND_0 */
+#define PCEP_RCTRL_2_OUT_0        __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 4, 0, 1, 4)
+
+#define PCEP_RCTRL_2_OUT_0_MSG_CODE              GENMASK(7, 0)
+#define PCEP_RCTRL_2_OUT_0_MSG_CODE_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_MSG_CODE, x)
+#define PCEP_RCTRL_2_OUT_0_MSG_CODE_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_MSG_CODE, x)
+
+#define PCEP_RCTRL_2_OUT_0_TAG                   GENMASK(15, 8)
+#define PCEP_RCTRL_2_OUT_0_TAG_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_TAG, x)
+#define PCEP_RCTRL_2_OUT_0_TAG_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_TAG, x)
+
+#define PCEP_RCTRL_2_OUT_0_TAG_SUBSTITUTE_EN     BIT(16)
+#define PCEP_RCTRL_2_OUT_0_TAG_SUBSTITUTE_EN_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_TAG_SUBSTITUTE_EN, x)
+#define PCEP_RCTRL_2_OUT_0_TAG_SUBSTITUTE_EN_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_TAG_SUBSTITUTE_EN, x)
+
+#define PCEP_RCTRL_2_OUT_0_FUNC_BYPASS           BIT(19)
+#define PCEP_RCTRL_2_OUT_0_FUNC_BYPASS_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_FUNC_BYPASS, x)
+#define PCEP_RCTRL_2_OUT_0_FUNC_BYPASS_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_FUNC_BYPASS, x)
+
+#define PCEP_RCTRL_2_OUT_0_SNP                   BIT(20)
+#define PCEP_RCTRL_2_OUT_0_SNP_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_SNP, x)
+#define PCEP_RCTRL_2_OUT_0_SNP_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_SNP, x)
+
+#define PCEP_RCTRL_2_OUT_0_INHIBIT_PAYLOAD       BIT(22)
+#define PCEP_RCTRL_2_OUT_0_INHIBIT_PAYLOAD_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_INHIBIT_PAYLOAD, x)
+#define PCEP_RCTRL_2_OUT_0_INHIBIT_PAYLOAD_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_INHIBIT_PAYLOAD, x)
+
+#define PCEP_RCTRL_2_OUT_0_HEADER_SUBSTITUTE_EN  BIT(23)
+#define PCEP_RCTRL_2_OUT_0_HEADER_SUBSTITUTE_EN_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_HEADER_SUBSTITUTE_EN, x)
+#define PCEP_RCTRL_2_OUT_0_HEADER_SUBSTITUTE_EN_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_HEADER_SUBSTITUTE_EN, x)
+
+#define PCEP_RCTRL_2_OUT_0_CFG_SHIFT_MODE        BIT(28)
+#define PCEP_RCTRL_2_OUT_0_CFG_SHIFT_MODE_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_CFG_SHIFT_MODE, x)
+#define PCEP_RCTRL_2_OUT_0_CFG_SHIFT_MODE_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_CFG_SHIFT_MODE, x)
+
+#define PCEP_RCTRL_2_OUT_0_INVERT_MODE           BIT(29)
+#define PCEP_RCTRL_2_OUT_0_INVERT_MODE_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_INVERT_MODE, x)
+#define PCEP_RCTRL_2_OUT_0_INVERT_MODE_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_INVERT_MODE, x)
+
+#define PCEP_RCTRL_2_OUT_0_REGION_EN             BIT(31)
+#define PCEP_RCTRL_2_OUT_0_REGION_EN_SET(x)\
+	FIELD_PREP(PCEP_RCTRL_2_OUT_0_REGION_EN, x)
+#define PCEP_RCTRL_2_OUT_0_REGION_EN_GET(x)\
+	FIELD_GET(PCEP_RCTRL_2_OUT_0_REGION_EN, x)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_LWR_BASE_ADDR_OFF_OUTBOUND_0 */
+#define PCEP_ADDR_LWR_OUT_0       __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 8, 0, 1, 4)
+
+#define PCEP_ADDR_LWR_OUT_0_LWR_BASE_HW          GENMASK(15, 0)
+#define PCEP_ADDR_LWR_OUT_0_LWR_BASE_HW_SET(x)\
+	FIELD_PREP(PCEP_ADDR_LWR_OUT_0_LWR_BASE_HW, x)
+#define PCEP_ADDR_LWR_OUT_0_LWR_BASE_HW_GET(x)\
+	FIELD_GET(PCEP_ADDR_LWR_OUT_0_LWR_BASE_HW, x)
+
+#define PCEP_ADDR_LWR_OUT_0_LWR_BASE_RW          GENMASK(31, 16)
+#define PCEP_ADDR_LWR_OUT_0_LWR_BASE_RW_SET(x)\
+	FIELD_PREP(PCEP_ADDR_LWR_OUT_0_LWR_BASE_RW, x)
+#define PCEP_ADDR_LWR_OUT_0_LWR_BASE_RW_GET(x)\
+	FIELD_GET(PCEP_ADDR_LWR_OUT_0_LWR_BASE_RW, x)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_UPPER_BASE_ADDR_OFF_OUTBOUND_0 */
+#define PCEP_ADDR_UPR_OUT_0       __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 12, 0, 1, 4)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_LIMIT_ADDR_OFF_OUTBOUND_0 */
+#define PCEP_ADDR_LIM_OUT_0       __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 16, 0, 1, 4)
+
+#define PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_HW        GENMASK(15, 0)
+#define PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_HW_SET(x)\
+	FIELD_PREP(PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_HW, x)
+#define PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_HW_GET(x)\
+	FIELD_GET(PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_HW, x)
+
+#define PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_RW        GENMASK(31, 16)
+#define PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_RW_SET(x)\
+	FIELD_PREP(PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_RW, x)
+#define PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_RW_GET(x)\
+	FIELD_GET(PCEP_ADDR_LIM_OUT_0_LIMIT_ADDR_RW, x)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_LWR_TARGET_ADDR_OFF_OUTBOUND_0 */
+#define PCEP_ADDR_LWR_TGT_OUT_0   __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 20, 0, 1, 4)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_UPPER_TARGET_ADDR_OFF_OUTBOUND_0 */
+#define PCEP_ADDR_UPR_TGT_OUT_0   __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 24, 0, 1, 4)
+
+/*      PCIE_DM_EP:PF0_ATU_CAP:IATU_UPPR_LIMIT_ADDR_OFF_OUTBOUND_0 */
+#define PCEP_ADDR_UPR_LIM_OUT_0   __REG(TARGET_PCEP, 0, 1, 3145728, 0, 1, 130852, 32, 0, 1, 4)
+
+#define PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_RW GENMASK(1, 0)
+#define PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_RW_SET(x)\
+	FIELD_PREP(PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_RW, x)
+#define PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_RW_GET(x)\
+	FIELD_GET(PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_RW, x)
+
+#define PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_HW GENMASK(31, 2)
+#define PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_HW_SET(x)\
+	FIELD_PREP(PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_HW, x)
+#define PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_HW_GET(x)\
+	FIELD_GET(PCEP_ADDR_UPR_LIM_OUT_0_UPPR_LIMIT_ADDR_HW, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_CFG */
+#define PCS10G_BR_PCS_CFG(t)      __REG(TARGET_PCS10G_BR, t, 12, 0, 0, 1, 56, 0, 0, 1, 4)
+
+#define PCS10G_BR_PCS_CFG_PCS_ENA                BIT(31)
+#define PCS10G_BR_PCS_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_PCS_ENA, x)
+#define PCS10G_BR_PCS_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_PCS_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA       BIT(30)
+#define PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+#define PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_SH_CNT_MAX             GENMASK(29, 24)
+#define PCS10G_BR_PCS_CFG_SH_CNT_MAX_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_SH_CNT_MAX, x)
+#define PCS10G_BR_PCS_CFG_SH_CNT_MAX_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_SH_CNT_MAX, x)
+
+#define PCS10G_BR_PCS_CFG_RX_DATA_FLIP           BIT(18)
+#define PCS10G_BR_PCS_CFG_RX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RX_DATA_FLIP, x)
+#define PCS10G_BR_PCS_CFG_RX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RX_DATA_FLIP, x)
+
+#define PCS10G_BR_PCS_CFG_RESYNC_ENA             BIT(15)
+#define PCS10G_BR_PCS_CFG_RESYNC_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RESYNC_ENA, x)
+#define PCS10G_BR_PCS_CFG_RESYNC_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RESYNC_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_LF_GEN_DIS             BIT(14)
+#define PCS10G_BR_PCS_CFG_LF_GEN_DIS_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_LF_GEN_DIS, x)
+#define PCS10G_BR_PCS_CFG_LF_GEN_DIS_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_LF_GEN_DIS, x)
+
+#define PCS10G_BR_PCS_CFG_RX_TEST_MODE           BIT(13)
+#define PCS10G_BR_PCS_CFG_RX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RX_TEST_MODE, x)
+#define PCS10G_BR_PCS_CFG_RX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RX_TEST_MODE, x)
+
+#define PCS10G_BR_PCS_CFG_RX_SCR_DISABLE         BIT(12)
+#define PCS10G_BR_PCS_CFG_RX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+#define PCS10G_BR_PCS_CFG_RX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+
+#define PCS10G_BR_PCS_CFG_TX_DATA_FLIP           BIT(7)
+#define PCS10G_BR_PCS_CFG_TX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_TX_DATA_FLIP, x)
+#define PCS10G_BR_PCS_CFG_TX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_TX_DATA_FLIP, x)
+
+#define PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA       BIT(6)
+#define PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+#define PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_TX_TEST_MODE           BIT(4)
+#define PCS10G_BR_PCS_CFG_TX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_TX_TEST_MODE, x)
+#define PCS10G_BR_PCS_CFG_TX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_TX_TEST_MODE, x)
+
+#define PCS10G_BR_PCS_CFG_TX_SCR_DISABLE         BIT(3)
+#define PCS10G_BR_PCS_CFG_TX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+#define PCS10G_BR_PCS_CFG_TX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_SD_CFG */
+#define PCS10G_BR_PCS_SD_CFG(t)   __REG(TARGET_PCS10G_BR, t, 12, 0, 0, 1, 56, 4, 0, 1, 4)
+
+#define PCS10G_BR_PCS_SD_CFG_SD_SEL              BIT(8)
+#define PCS10G_BR_PCS_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_SD_CFG_SD_SEL, x)
+#define PCS10G_BR_PCS_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_SD_CFG_SD_SEL, x)
+
+#define PCS10G_BR_PCS_SD_CFG_SD_POL              BIT(4)
+#define PCS10G_BR_PCS_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_SD_CFG_SD_POL, x)
+#define PCS10G_BR_PCS_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_SD_CFG_SD_POL, x)
+
+#define PCS10G_BR_PCS_SD_CFG_SD_ENA              BIT(0)
+#define PCS10G_BR_PCS_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_SD_CFG_SD_ENA, x)
+#define PCS10G_BR_PCS_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_SD_CFG_SD_ENA, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_CFG */
+#define PCS25G_BR_PCS_CFG(t)      __REG(TARGET_PCS25G_BR, t, 8, 0, 0, 1, 56, 0, 0, 1, 4)
+
+#define PCS25G_BR_PCS_CFG_PCS_ENA                BIT(31)
+#define PCS25G_BR_PCS_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_PCS_ENA, x)
+#define PCS25G_BR_PCS_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_PCS_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA       BIT(30)
+#define PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+#define PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_SH_CNT_MAX             GENMASK(29, 24)
+#define PCS25G_BR_PCS_CFG_SH_CNT_MAX_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_SH_CNT_MAX, x)
+#define PCS25G_BR_PCS_CFG_SH_CNT_MAX_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_SH_CNT_MAX, x)
+
+#define PCS25G_BR_PCS_CFG_RX_DATA_FLIP           BIT(18)
+#define PCS25G_BR_PCS_CFG_RX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RX_DATA_FLIP, x)
+#define PCS25G_BR_PCS_CFG_RX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RX_DATA_FLIP, x)
+
+#define PCS25G_BR_PCS_CFG_RESYNC_ENA             BIT(15)
+#define PCS25G_BR_PCS_CFG_RESYNC_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RESYNC_ENA, x)
+#define PCS25G_BR_PCS_CFG_RESYNC_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RESYNC_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_LF_GEN_DIS             BIT(14)
+#define PCS25G_BR_PCS_CFG_LF_GEN_DIS_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_LF_GEN_DIS, x)
+#define PCS25G_BR_PCS_CFG_LF_GEN_DIS_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_LF_GEN_DIS, x)
+
+#define PCS25G_BR_PCS_CFG_RX_TEST_MODE           BIT(13)
+#define PCS25G_BR_PCS_CFG_RX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RX_TEST_MODE, x)
+#define PCS25G_BR_PCS_CFG_RX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RX_TEST_MODE, x)
+
+#define PCS25G_BR_PCS_CFG_RX_SCR_DISABLE         BIT(12)
+#define PCS25G_BR_PCS_CFG_RX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+#define PCS25G_BR_PCS_CFG_RX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+
+#define PCS25G_BR_PCS_CFG_TX_DATA_FLIP           BIT(7)
+#define PCS25G_BR_PCS_CFG_TX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_TX_DATA_FLIP, x)
+#define PCS25G_BR_PCS_CFG_TX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_TX_DATA_FLIP, x)
+
+#define PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA       BIT(6)
+#define PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+#define PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_TX_TEST_MODE           BIT(4)
+#define PCS25G_BR_PCS_CFG_TX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_TX_TEST_MODE, x)
+#define PCS25G_BR_PCS_CFG_TX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_TX_TEST_MODE, x)
+
+#define PCS25G_BR_PCS_CFG_TX_SCR_DISABLE         BIT(3)
+#define PCS25G_BR_PCS_CFG_TX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+#define PCS25G_BR_PCS_CFG_TX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_SD_CFG */
+#define PCS25G_BR_PCS_SD_CFG(t)   __REG(TARGET_PCS25G_BR, t, 8, 0, 0, 1, 56, 4, 0, 1, 4)
+
+#define PCS25G_BR_PCS_SD_CFG_SD_SEL              BIT(8)
+#define PCS25G_BR_PCS_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_SD_CFG_SD_SEL, x)
+#define PCS25G_BR_PCS_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_SD_CFG_SD_SEL, x)
+
+#define PCS25G_BR_PCS_SD_CFG_SD_POL              BIT(4)
+#define PCS25G_BR_PCS_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_SD_CFG_SD_POL, x)
+#define PCS25G_BR_PCS_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_SD_CFG_SD_POL, x)
+
+#define PCS25G_BR_PCS_SD_CFG_SD_ENA              BIT(0)
+#define PCS25G_BR_PCS_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_SD_CFG_SD_ENA, x)
+#define PCS25G_BR_PCS_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_SD_CFG_SD_ENA, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_CFG */
+#define PCS5G_BR_PCS_CFG(t)       __REG(TARGET_PCS5G_BR, t, 13, 0, 0, 1, 56, 0, 0, 1, 4)
+
+#define PCS5G_BR_PCS_CFG_PCS_ENA                 BIT(31)
+#define PCS5G_BR_PCS_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_PCS_ENA, x)
+#define PCS5G_BR_PCS_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_PCS_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA        BIT(30)
+#define PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+#define PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_SH_CNT_MAX              GENMASK(29, 24)
+#define PCS5G_BR_PCS_CFG_SH_CNT_MAX_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_SH_CNT_MAX, x)
+#define PCS5G_BR_PCS_CFG_SH_CNT_MAX_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_SH_CNT_MAX, x)
+
+#define PCS5G_BR_PCS_CFG_RX_DATA_FLIP            BIT(18)
+#define PCS5G_BR_PCS_CFG_RX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RX_DATA_FLIP, x)
+#define PCS5G_BR_PCS_CFG_RX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RX_DATA_FLIP, x)
+
+#define PCS5G_BR_PCS_CFG_RESYNC_ENA              BIT(15)
+#define PCS5G_BR_PCS_CFG_RESYNC_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RESYNC_ENA, x)
+#define PCS5G_BR_PCS_CFG_RESYNC_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RESYNC_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_LF_GEN_DIS              BIT(14)
+#define PCS5G_BR_PCS_CFG_LF_GEN_DIS_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_LF_GEN_DIS, x)
+#define PCS5G_BR_PCS_CFG_LF_GEN_DIS_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_LF_GEN_DIS, x)
+
+#define PCS5G_BR_PCS_CFG_RX_TEST_MODE            BIT(13)
+#define PCS5G_BR_PCS_CFG_RX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RX_TEST_MODE, x)
+#define PCS5G_BR_PCS_CFG_RX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RX_TEST_MODE, x)
+
+#define PCS5G_BR_PCS_CFG_RX_SCR_DISABLE          BIT(12)
+#define PCS5G_BR_PCS_CFG_RX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+#define PCS5G_BR_PCS_CFG_RX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+
+#define PCS5G_BR_PCS_CFG_TX_DATA_FLIP            BIT(7)
+#define PCS5G_BR_PCS_CFG_TX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_TX_DATA_FLIP, x)
+#define PCS5G_BR_PCS_CFG_TX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_TX_DATA_FLIP, x)
+
+#define PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA        BIT(6)
+#define PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+#define PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_TX_TEST_MODE            BIT(4)
+#define PCS5G_BR_PCS_CFG_TX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_TX_TEST_MODE, x)
+#define PCS5G_BR_PCS_CFG_TX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_TX_TEST_MODE, x)
+
+#define PCS5G_BR_PCS_CFG_TX_SCR_DISABLE          BIT(3)
+#define PCS5G_BR_PCS_CFG_TX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+#define PCS5G_BR_PCS_CFG_TX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_SD_CFG */
+#define PCS5G_BR_PCS_SD_CFG(t)    __REG(TARGET_PCS5G_BR, t, 13, 0, 0, 1, 56, 4, 0, 1, 4)
+
+#define PCS5G_BR_PCS_SD_CFG_SD_SEL               BIT(8)
+#define PCS5G_BR_PCS_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_SD_CFG_SD_SEL, x)
+#define PCS5G_BR_PCS_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_SD_CFG_SD_SEL, x)
+
+#define PCS5G_BR_PCS_SD_CFG_SD_POL               BIT(4)
+#define PCS5G_BR_PCS_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_SD_CFG_SD_POL, x)
+#define PCS5G_BR_PCS_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_SD_CFG_SD_POL, x)
+
+#define PCS5G_BR_PCS_SD_CFG_SD_ENA               BIT(0)
+#define PCS5G_BR_PCS_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_SD_CFG_SD_ENA, x)
+#define PCS5G_BR_PCS_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_SD_CFG_SD_ENA, x)
+
+/*      PORT_CONF:HW_CFG:DEV5G_MODES */
+#define PORT_CONF_DEV5G_MODES     __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 0, 0, 1, 4)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE      BIT(0)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE      BIT(1)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE      BIT(2)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE      BIT(3)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE      BIT(4)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE      BIT(5)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE      BIT(6)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE      BIT(7)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE      BIT(8)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE      BIT(9)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE     BIT(10)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE     BIT(11)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE     BIT(12)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE, x)
+
+/*      PORT_CONF:HW_CFG:DEV10G_MODES */
+#define PORT_CONF_DEV10G_MODES    __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 4, 0, 1, 4)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE   BIT(0)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE   BIT(1)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE   BIT(2)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE   BIT(3)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE   BIT(4)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE   BIT(5)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE   BIT(6)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE   BIT(7)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE   BIT(8)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE   BIT(9)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE   BIT(10)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE   BIT(11)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE, x)
+
+/*      PORT_CONF:HW_CFG:DEV25G_MODES */
+#define PORT_CONF_DEV25G_MODES    __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 8, 0, 1, 4)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE   BIT(0)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE   BIT(1)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE   BIT(2)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE   BIT(3)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE   BIT(4)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE   BIT(5)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE   BIT(6)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE   BIT(7)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE, x)
+
+/*      PORT_CONF:HW_CFG:QSGMII_ENA */
+#define PORT_CONF_QSGMII_ENA      __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 12, 0, 1, 4)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_0        BIT(0)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_0_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_0, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_0_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_0, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_1        BIT(1)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_1_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_1, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_1_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_1, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_2        BIT(2)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_2_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_2, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_2_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_2, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_3        BIT(3)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_3_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_3, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_3_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_3, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_4        BIT(4)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_4_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_4, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_4_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_4, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_5        BIT(5)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_5_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_5, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_5_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_5, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_6        BIT(6)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_6_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_6, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_6_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_6, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_7        BIT(7)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_7_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_7, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_7_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_7, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_8        BIT(8)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_8_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_8, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_8_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_8, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_9        BIT(9)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_9_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_9, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_9_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_9, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_10       BIT(10)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_10_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_10, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_10_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_10, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_11       BIT(11)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_11_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_11, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_11_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_11, x)
+
+/*      PORT_CONF:USGMII_CFG_STAT:USGMII_CFG */
+#define PORT_CONF_USGMII_CFG(g)   __REG(TARGET_PORT_CONF, 0, 1, 72, g, 6, 8, 0, 0, 1, 4)
+
+#define PORT_CONF_USGMII_CFG_BYPASS_SCRAM        BIT(9)
+#define PORT_CONF_USGMII_CFG_BYPASS_SCRAM_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_BYPASS_SCRAM, x)
+#define PORT_CONF_USGMII_CFG_BYPASS_SCRAM_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_BYPASS_SCRAM, x)
+
+#define PORT_CONF_USGMII_CFG_BYPASS_DESCRAM      BIT(8)
+#define PORT_CONF_USGMII_CFG_BYPASS_DESCRAM_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_BYPASS_DESCRAM, x)
+#define PORT_CONF_USGMII_CFG_BYPASS_DESCRAM_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_BYPASS_DESCRAM, x)
+
+#define PORT_CONF_USGMII_CFG_FLIP_LANES          BIT(7)
+#define PORT_CONF_USGMII_CFG_FLIP_LANES_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_FLIP_LANES, x)
+#define PORT_CONF_USGMII_CFG_FLIP_LANES_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_FLIP_LANES, x)
+
+#define PORT_CONF_USGMII_CFG_SHYST_DIS           BIT(6)
+#define PORT_CONF_USGMII_CFG_SHYST_DIS_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_SHYST_DIS, x)
+#define PORT_CONF_USGMII_CFG_SHYST_DIS_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_SHYST_DIS, x)
+
+#define PORT_CONF_USGMII_CFG_E_DET_ENA           BIT(5)
+#define PORT_CONF_USGMII_CFG_E_DET_ENA_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_E_DET_ENA, x)
+#define PORT_CONF_USGMII_CFG_E_DET_ENA_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_E_DET_ENA, x)
+
+#define PORT_CONF_USGMII_CFG_USE_I1_ENA          BIT(4)
+#define PORT_CONF_USGMII_CFG_USE_I1_ENA_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_USE_I1_ENA, x)
+#define PORT_CONF_USGMII_CFG_USE_I1_ENA_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_USE_I1_ENA, x)
+
+#define PORT_CONF_USGMII_CFG_QUAD_MODE           BIT(1)
+#define PORT_CONF_USGMII_CFG_QUAD_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_QUAD_MODE, x)
+#define PORT_CONF_USGMII_CFG_QUAD_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_QUAD_MODE, x)
+
+/*      QFWD:SYSTEM:SWITCH_PORT_MODE */
+#define QFWD_SWITCH_PORT_MODE(r)  __REG(TARGET_QFWD, 0, 1, 0, 0, 1, 340, 0, r, 70, 4)
+
+#define QFWD_SWITCH_PORT_MODE_PORT_ENA           BIT(19)
+#define QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_PORT_ENA, x)
+#define QFWD_SWITCH_PORT_MODE_PORT_ENA_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_PORT_ENA, x)
+
+#define QFWD_SWITCH_PORT_MODE_FWD_URGENCY        GENMASK(18, 10)
+#define QFWD_SWITCH_PORT_MODE_FWD_URGENCY_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_FWD_URGENCY, x)
+#define QFWD_SWITCH_PORT_MODE_FWD_URGENCY_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_FWD_URGENCY, x)
+
+#define QFWD_SWITCH_PORT_MODE_YEL_RSRVD          GENMASK(9, 6)
+#define QFWD_SWITCH_PORT_MODE_YEL_RSRVD_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_YEL_RSRVD, x)
+#define QFWD_SWITCH_PORT_MODE_YEL_RSRVD_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_YEL_RSRVD, x)
+
+#define QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE  BIT(5)
+#define QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE, x)
+#define QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE, x)
+
+#define QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING     BIT(4)
+#define QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING, x)
+#define QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING, x)
+
+#define QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING     BIT(3)
+#define QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING, x)
+#define QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING, x)
+
+#define QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE   BIT(2)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE, x)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE, x)
+
+#define QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS    BIT(1)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS, x)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS, x)
+
+#define QFWD_SWITCH_PORT_MODE_LEARNALL_MORE      BIT(0)
+#define QFWD_SWITCH_PORT_MODE_LEARNALL_MORE_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_LEARNALL_MORE, x)
+#define QFWD_SWITCH_PORT_MODE_LEARNALL_MORE_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_LEARNALL_MORE, x)
+
+/*      QRES:RES_CTRL:RES_CFG */
+#define QRES_RES_CFG(g)           __REG(TARGET_QRES, 0, 1, 0, g, 5120, 16, 0, 0, 1, 4)
+
+#define QRES_RES_CFG_WM_HIGH                     GENMASK(11, 0)
+#define QRES_RES_CFG_WM_HIGH_SET(x)\
+	FIELD_PREP(QRES_RES_CFG_WM_HIGH, x)
+#define QRES_RES_CFG_WM_HIGH_GET(x)\
+	FIELD_GET(QRES_RES_CFG_WM_HIGH, x)
+
+/*      QRES:RES_CTRL:RES_STAT */
+#define QRES_RES_STAT(g)          __REG(TARGET_QRES, 0, 1, 0, g, 5120, 16, 4, 0, 1, 4)
+
+#define QRES_RES_STAT_MAXUSE                     GENMASK(20, 0)
+#define QRES_RES_STAT_MAXUSE_SET(x)\
+	FIELD_PREP(QRES_RES_STAT_MAXUSE, x)
+#define QRES_RES_STAT_MAXUSE_GET(x)\
+	FIELD_GET(QRES_RES_STAT_MAXUSE, x)
+
+/*      QRES:RES_CTRL:RES_STAT_CUR */
+#define QRES_RES_STAT_CUR(g)      __REG(TARGET_QRES, 0, 1, 0, g, 5120, 16, 8, 0, 1, 4)
+
+#define QRES_RES_STAT_CUR_INUSE                  GENMASK(20, 0)
+#define QRES_RES_STAT_CUR_INUSE_SET(x)\
+	FIELD_PREP(QRES_RES_STAT_CUR_INUSE, x)
+#define QRES_RES_STAT_CUR_INUSE_GET(x)\
+	FIELD_GET(QRES_RES_STAT_CUR_INUSE, x)
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
+#define QS_XTR_GRP_CFG_STATUS_WORD_POS           BIT(1)
+#define QS_XTR_GRP_CFG_STATUS_WORD_POS_SET(x)\
+	FIELD_PREP(QS_XTR_GRP_CFG_STATUS_WORD_POS, x)
+#define QS_XTR_GRP_CFG_STATUS_WORD_POS_GET(x)\
+	FIELD_GET(QS_XTR_GRP_CFG_STATUS_WORD_POS, x)
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
+#define QS_XTR_FLUSH_FLUSH                       GENMASK(1, 0)
+#define QS_XTR_FLUSH_FLUSH_SET(x)\
+	FIELD_PREP(QS_XTR_FLUSH_FLUSH, x)
+#define QS_XTR_FLUSH_FLUSH_GET(x)\
+	FIELD_GET(QS_XTR_FLUSH_FLUSH, x)
+
+/*      DEVCPU_QS:XTR:XTR_DATA_PRESENT */
+#define QS_XTR_DATA_PRESENT       __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 28, 0, 1, 4)
+
+#define QS_XTR_DATA_PRESENT_DATA_PRESENT         GENMASK(1, 0)
+#define QS_XTR_DATA_PRESENT_DATA_PRESENT_SET(x)\
+	FIELD_PREP(QS_XTR_DATA_PRESENT_DATA_PRESENT, x)
+#define QS_XTR_DATA_PRESENT_DATA_PRESENT_GET(x)\
+	FIELD_GET(QS_XTR_DATA_PRESENT_DATA_PRESENT, x)
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
+#define QS_INJ_CTRL_ABORT                        BIT(20)
+#define QS_INJ_CTRL_ABORT_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_ABORT, x)
+#define QS_INJ_CTRL_ABORT_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_ABORT, x)
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
+#define QS_INJ_STATUS_INJ_IN_PROGRESS            GENMASK(1, 0)
+#define QS_INJ_STATUS_INJ_IN_PROGRESS_SET(x)\
+	FIELD_PREP(QS_INJ_STATUS_INJ_IN_PROGRESS, x)
+#define QS_INJ_STATUS_INJ_IN_PROGRESS_GET(x)\
+	FIELD_GET(QS_INJ_STATUS_INJ_IN_PROGRESS, x)
+
+/*      QSYS:PAUSE_CFG:PAUSE_CFG */
+#define QSYS_PAUSE_CFG(r)         __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 0, r, 70, 4)
+
+#define QSYS_PAUSE_CFG_PAUSE_START               GENMASK(25, 14)
+#define QSYS_PAUSE_CFG_PAUSE_START_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_PAUSE_START, x)
+#define QSYS_PAUSE_CFG_PAUSE_START_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_PAUSE_START, x)
+
+#define QSYS_PAUSE_CFG_PAUSE_STOP                GENMASK(13, 2)
+#define QSYS_PAUSE_CFG_PAUSE_STOP_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_PAUSE_STOP, x)
+#define QSYS_PAUSE_CFG_PAUSE_STOP_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_PAUSE_STOP, x)
+
+#define QSYS_PAUSE_CFG_PAUSE_ENA                 BIT(1)
+#define QSYS_PAUSE_CFG_PAUSE_ENA_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_PAUSE_ENA, x)
+#define QSYS_PAUSE_CFG_PAUSE_ENA_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_PAUSE_ENA, x)
+
+#define QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA   BIT(0)
+#define QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA, x)
+#define QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA, x)
+
+/*      QSYS:PAUSE_CFG:ATOP */
+#define QSYS_ATOP(r)              __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 284, r, 70, 4)
+
+#define QSYS_ATOP_ATOP                           GENMASK(11, 0)
+#define QSYS_ATOP_ATOP_SET(x)\
+	FIELD_PREP(QSYS_ATOP_ATOP, x)
+#define QSYS_ATOP_ATOP_GET(x)\
+	FIELD_GET(QSYS_ATOP_ATOP, x)
+
+/*      QSYS:PAUSE_CFG:FWD_PRESSURE */
+#define QSYS_FWD_PRESSURE(r)      __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 564, r, 70, 4)
+
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE           GENMASK(11, 1)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_SET(x)\
+	FIELD_PREP(QSYS_FWD_PRESSURE_FWD_PRESSURE, x)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_GET(x)\
+	FIELD_GET(QSYS_FWD_PRESSURE_FWD_PRESSURE, x)
+
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS       BIT(0)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS_SET(x)\
+	FIELD_PREP(QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS, x)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS_GET(x)\
+	FIELD_GET(QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS, x)
+
+/*      QSYS:PAUSE_CFG:ATOP_TOT_CFG */
+#define QSYS_ATOP_TOT_CFG         __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 844, 0, 1, 4)
+
+#define QSYS_ATOP_TOT_CFG_ATOP_TOT               GENMASK(11, 0)
+#define QSYS_ATOP_TOT_CFG_ATOP_TOT_SET(x)\
+	FIELD_PREP(QSYS_ATOP_TOT_CFG_ATOP_TOT, x)
+#define QSYS_ATOP_TOT_CFG_ATOP_TOT_GET(x)\
+	FIELD_GET(QSYS_ATOP_TOT_CFG_ATOP_TOT, x)
+
+/*      QSYS:CALCFG:CAL_AUTO */
+#define QSYS_CAL_AUTO(r)          __REG(TARGET_QSYS, 0, 1, 2304, 0, 1, 40, 0, r, 7, 4)
+
+#define QSYS_CAL_AUTO_CAL_AUTO                   GENMASK(29, 0)
+#define QSYS_CAL_AUTO_CAL_AUTO_SET(x)\
+	FIELD_PREP(QSYS_CAL_AUTO_CAL_AUTO, x)
+#define QSYS_CAL_AUTO_CAL_AUTO_GET(x)\
+	FIELD_GET(QSYS_CAL_AUTO_CAL_AUTO, x)
+
+/*      QSYS:CALCFG:CAL_CTRL */
+#define QSYS_CAL_CTRL             __REG(TARGET_QSYS, 0, 1, 2304, 0, 1, 40, 36, 0, 1, 4)
+
+#define QSYS_CAL_CTRL_CAL_MODE                   GENMASK(14, 11)
+#define QSYS_CAL_CTRL_CAL_MODE_SET(x)\
+	FIELD_PREP(QSYS_CAL_CTRL_CAL_MODE, x)
+#define QSYS_CAL_CTRL_CAL_MODE_GET(x)\
+	FIELD_GET(QSYS_CAL_CTRL_CAL_MODE, x)
+
+#define QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE        GENMASK(10, 1)
+#define QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE_SET(x)\
+	FIELD_PREP(QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE, x)
+#define QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE_GET(x)\
+	FIELD_GET(QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE, x)
+
+#define QSYS_CAL_CTRL_CAL_AUTO_ERROR             BIT(0)
+#define QSYS_CAL_CTRL_CAL_AUTO_ERROR_SET(x)\
+	FIELD_PREP(QSYS_CAL_CTRL_CAL_AUTO_ERROR, x)
+#define QSYS_CAL_CTRL_CAL_AUTO_ERROR_GET(x)\
+	FIELD_GET(QSYS_CAL_CTRL_CAL_AUTO_ERROR, x)
+
+/*      QSYS:RAM_CTRL:RAM_INIT */
+#define QSYS_RAM_INIT             __REG(TARGET_QSYS, 0, 1, 2344, 0, 1, 4, 0, 0, 1, 4)
+
+#define QSYS_RAM_INIT_RAM_INIT                   BIT(1)
+#define QSYS_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(QSYS_RAM_INIT_RAM_INIT, x)
+#define QSYS_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(QSYS_RAM_INIT_RAM_INIT, x)
+
+#define QSYS_RAM_INIT_RAM_CFG_HOOK               BIT(0)
+#define QSYS_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(QSYS_RAM_INIT_RAM_CFG_HOOK, x)
+#define QSYS_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(QSYS_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      REW:COMMON:OWN_UPSID */
+#define REW_OWN_UPSID(r)          __REG(TARGET_REW, 0, 1, 387264, 0, 1, 1232, 0, r, 3, 4)
+
+#define REW_OWN_UPSID_OWN_UPSID                  GENMASK(4, 0)
+#define REW_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(REW_OWN_UPSID_OWN_UPSID, x)
+#define REW_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(REW_OWN_UPSID_OWN_UPSID, x)
+
+/*      REW:PORT:PORT_VLAN_CFG */
+#define REW_PORT_VLAN_CFG(g)      __REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 0, 0, 1, 4)
+
+#define REW_PORT_VLAN_CFG_PORT_PCP               GENMASK(15, 13)
+#define REW_PORT_VLAN_CFG_PORT_PCP_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_PCP, x)
+#define REW_PORT_VLAN_CFG_PORT_PCP_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_PCP, x)
+
+#define REW_PORT_VLAN_CFG_PORT_DEI               BIT(12)
+#define REW_PORT_VLAN_CFG_PORT_DEI_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_DEI, x)
+#define REW_PORT_VLAN_CFG_PORT_DEI_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_DEI, x)
+
+#define REW_PORT_VLAN_CFG_PORT_VID               GENMASK(11, 0)
+#define REW_PORT_VLAN_CFG_PORT_VID_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_VID, x)
+#define REW_PORT_VLAN_CFG_PORT_VID_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_VID, x)
+
+/*      REW:PORT:TAG_CTRL */
+#define REW_TAG_CTRL(g)           __REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 132, 0, 1, 4)
+
+#define REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED     BIT(13)
+#define REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED, x)
+#define REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED, x)
+
+#define REW_TAG_CTRL_TAG_CFG                     GENMASK(12, 11)
+#define REW_TAG_CTRL_TAG_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_CFG, x)
+#define REW_TAG_CTRL_TAG_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_CFG, x)
+
+#define REW_TAG_CTRL_TAG_TPID_CFG                GENMASK(10, 8)
+#define REW_TAG_CTRL_TAG_TPID_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_TPID_CFG, x)
+#define REW_TAG_CTRL_TAG_TPID_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_TPID_CFG, x)
+
+#define REW_TAG_CTRL_TAG_VID_CFG                 GENMASK(7, 6)
+#define REW_TAG_CTRL_TAG_VID_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_VID_CFG, x)
+#define REW_TAG_CTRL_TAG_VID_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_VID_CFG, x)
+
+#define REW_TAG_CTRL_TAG_PCP_CFG                 GENMASK(5, 3)
+#define REW_TAG_CTRL_TAG_PCP_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_PCP_CFG, x)
+#define REW_TAG_CTRL_TAG_PCP_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_PCP_CFG, x)
+
+#define REW_TAG_CTRL_TAG_DEI_CFG                 GENMASK(2, 0)
+#define REW_TAG_CTRL_TAG_DEI_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_DEI_CFG, x)
+#define REW_TAG_CTRL_TAG_DEI_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_DEI_CFG, x)
+
+/*      REW:RAM_CTRL:RAM_INIT */
+#define REW_RAM_INIT              __REG(TARGET_REW, 0, 1, 378696, 0, 1, 4, 0, 0, 1, 4)
+
+#define REW_RAM_INIT_RAM_INIT                    BIT(1)
+#define REW_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(REW_RAM_INIT_RAM_INIT, x)
+#define REW_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(REW_RAM_INIT_RAM_INIT, x)
+
+#define REW_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define REW_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(REW_RAM_INIT_RAM_CFG_HOOK, x)
+#define REW_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(REW_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      VCAP_SUPER:RAM_CTRL:RAM_INIT */
+#define VCAP_SUPER_RAM_INIT       __REG(TARGET_VCAP_SUPER, 0, 1, 1120, 0, 1, 4, 0, 0, 1, 4)
+
+#define VCAP_SUPER_RAM_INIT_RAM_INIT             BIT(1)
+#define VCAP_SUPER_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(VCAP_SUPER_RAM_INIT_RAM_INIT, x)
+#define VCAP_SUPER_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(VCAP_SUPER_RAM_INIT_RAM_INIT, x)
+
+#define VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK         BIT(0)
+#define VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK, x)
+#define VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      VOP:RAM_CTRL:RAM_INIT */
+#define VOP_RAM_INIT              __REG(TARGET_VOP, 0, 1, 279176, 0, 1, 4, 0, 0, 1, 4)
+
+#define VOP_RAM_INIT_RAM_INIT                    BIT(1)
+#define VOP_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(VOP_RAM_INIT_RAM_INIT, x)
+#define VOP_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(VOP_RAM_INIT_RAM_INIT, x)
+
+#define VOP_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define VOP_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(VOP_RAM_INIT_RAM_CFG_HOOK, x)
+#define VOP_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(VOP_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      XQS:SYSTEM:STAT_CFG */
+#define XQS_STAT_CFG              __REG(TARGET_XQS, 0, 1, 6768, 0, 1, 872, 860, 0, 1, 4)
+
+#define XQS_STAT_CFG_STAT_CLEAR_SHOT             GENMASK(21, 18)
+#define XQS_STAT_CFG_STAT_CLEAR_SHOT_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_CLEAR_SHOT, x)
+#define XQS_STAT_CFG_STAT_CLEAR_SHOT_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_CLEAR_SHOT, x)
+
+#define XQS_STAT_CFG_STAT_VIEW                   GENMASK(17, 5)
+#define XQS_STAT_CFG_STAT_VIEW_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_VIEW, x)
+#define XQS_STAT_CFG_STAT_VIEW_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_VIEW, x)
+
+#define XQS_STAT_CFG_STAT_SRV_PKT_ONLY           BIT(4)
+#define XQS_STAT_CFG_STAT_SRV_PKT_ONLY_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_SRV_PKT_ONLY, x)
+#define XQS_STAT_CFG_STAT_SRV_PKT_ONLY_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_SRV_PKT_ONLY, x)
+
+#define XQS_STAT_CFG_STAT_WRAP_DIS               GENMASK(3, 0)
+#define XQS_STAT_CFG_STAT_WRAP_DIS_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_WRAP_DIS, x)
+#define XQS_STAT_CFG_STAT_WRAP_DIS_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_WRAP_DIS, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_TOP_CFG */
+#define XQS_QLIMIT_SHR_TOP_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 0, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP    GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP, x)
+#define XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_ATOP_CFG */
+#define XQS_QLIMIT_SHR_ATOP_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 4, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP  GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP, x)
+#define XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_CTOP_CFG */
+#define XQS_QLIMIT_SHR_CTOP_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 8, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP  GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP, x)
+#define XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_QLIM_CFG */
+#define XQS_QLIMIT_SHR_QLIM_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 12, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM  GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM, x)
+#define XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM, x)
+
+/*      XQS:STAT:CNT */
+#define XQS_CNT(g)                __REG(TARGET_XQS, 0, 1, 0, g, 1024, 4, 0, 0, 1, 4)
+
+#endif /* _SPARX5_MAIN_REGS_H_ */
-- 
2.31.1

