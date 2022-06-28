Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9544C55DCA7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbiF1JtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 05:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344543AbiF1Jro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 05:47:44 -0400
Received: from smtpproxy21.qq.com (smtpbg704.qq.com [203.205.195.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2090B2B25E
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 02:47:33 -0700 (PDT)
X-QQ-mid: bizesmtp62t1656409647tz3djeux
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 28 Jun 2022 17:47:19 +0800 (CST)
X-QQ-SSF: 01400000000000G0Q000B00A0000000
X-QQ-FEAT: pAmd6q8a+CcXcv0aP9JTW8p4dvxYLuw4IxQNVD5wITo1P5hz4KHf6oLzcDK/K
        10a0U9HftwyJInUkJIkdhHpKCvR8vuq1JgPKpIXAEhaHy3YGwOmjHevRm9VeuwFNLU05x9L
        lv5JoqiXiAWnMsp5f9efzuYHYCMVB+w9oMWbhjEskKfqueR0h8smdB+Z/fozEu0tgwWbS2f
        vfLRepPJSZTXMZrbqwvFDNilHCbdJ3myT3nFwDqxH4QY852oXvwLdJxMofQKP8QbMLRpgU/
        03/uUYZZqhp2si/xhPLxSAocAzlVrT7geVIr9Tif/C8niHcMaMa+Le1KXWrfFeGqchbqVS7
        CRWdmns3rOvpXEqIkJFZ968CX10Dw==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v8] net: txgbe: Add build support for txgbe
Date:   Tue, 28 Jun 2022 17:55:30 +0800
Message-Id: <20220628095530.889344-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add doc build infrastructure for txgbe driver.
Initialize PCI memory space for WangXun 10 Gigabit Ethernet devices.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
Change log:
v8: address comments:
    Jakub Kicinski: https://lore.kernel.org/netdev/20220621223716.5b936d93@kernel.org/
v7: address comments:
    Andrew Lunn & Jakub Kicinski: https://lore.kernel.org/netdev/20220616132908.789b9be4@kernel.org/
v6: address comments:
    Jakub Kicinski: make it build cleanly with W=1 C=1
v5: address comments:
    Andrew Lunn: repost the patch
v4: address comments:
    Leon Romanovsky: remove unused data setting, add PCI quirk
    Andrew Lunn: remove devm_iounmap(), use module_pci_driver()
v3: address comments:
    Andrew Lunn: https://lore.kernel.org/netdev/YoRkONdJlIU0ymd6@lunn.ch/
v2: address comments:
    Andrew Lunn & Jakub Kicinski: https://lore.kernel.org/netdev/Yn2E8X6f8PJ0c4CB@lunn.ch/

 .../device_drivers/ethernet/index.rst         |   1 +
 .../device_drivers/ethernet/wangxun/txgbe.rst |  20 +++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/wangxun/Kconfig          |  32 ++++
 drivers/net/ethernet/wangxun/Makefile         |   6 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   9 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  24 +++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 165 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  57 ++++++
 11 files changed, 323 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
 create mode 100644 drivers/net/ethernet/wangxun/Kconfig
 create mode 100644 drivers/net/ethernet/wangxun/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 4e06684d079b..2249ba010d8a 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -52,6 +52,7 @@ Contents:
    ti/am65_nuss_cpsw_switchdev
    ti/tlan
    toshiba/spider_net
+   wangxun/txgbe
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
new file mode 100644
index 000000000000..eaa87dbe8848
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================================================
+Linux Base Driver for WangXun(R) 10 Gigabit PCI Express Adapters
+================================================================
+
+WangXun 10 Gigabit Linux driver.
+Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd.
+
+
+Contents
+========
+
+- Support
+
+
+Support
+=======
+If you got any problem, contact Wangxun support team via support@trustnetic.com
+and Cc: netdev.
diff --git a/MAINTAINERS b/MAINTAINERS
index 6a288d59ff79..3f4970dccc89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21435,6 +21435,13 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/tablet/wacom_serial4.c
 
+WANGXUN ETHERNET DRIVER
+M:	Jiawen Wu <jiawenwu@trustnetic.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+F:	drivers/net/ethernet/wangxun/
+
 WATCHDOG DEVICE DRIVERS
 M:	Wim Van Sebroeck <wim@linux-watchdog.org>
 M:	Guenter Roeck <linux@roeck-us.net>
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 955abbc5490e..9a55c1d5a0a1 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -84,6 +84,7 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
+source "drivers/net/ethernet/wangxun/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 9eb01169957f..c06e75ed4231 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
 obj-$(CONFIG_NET_VENDOR_TUNDRA) += tundra/
 obj-$(CONFIG_NET_VENDOR_VERTEXCOM) += vertexcom/
 obj-$(CONFIG_NET_VENDOR_VIA) += via/
+obj-$(CONFIG_NET_VENDOR_WANGXUN) += wangxun/
 obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
 obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/
diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
new file mode 100644
index 000000000000..baa1f0a5cc37
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wangxun network device configuration
+#
+
+config NET_VENDOR_WANGXUN
+	bool "Wangxun devices"
+	default y
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Intel cards. If you say Y, you will be asked for
+	  your specific card in the following questions.
+
+if NET_VENDOR_WANGXUN
+
+config TXGBE
+	tristate "Wangxun(R) 10GbE PCI Express adapters support"
+	depends on PCI
+	help
+	  This driver supports Wangxun(R) 10GbE PCI Express family of
+	  adapters.
+
+	  More specific information on configuring the driver is in
+	  <file:Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called txgbe.
+
+endif # NET_VENDOR_WANGXUN
diff --git a/drivers/net/ethernet/wangxun/Makefile b/drivers/net/ethernet/wangxun/Makefile
new file mode 100644
index 000000000000..c34db1bead25
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Wangxun network device drivers.
+#
+
+obj-$(CONFIG_TXGBE) += txgbe/
diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
new file mode 100644
index 000000000000..431303ca75b4
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd.
+#
+# Makefile for the Wangxun(R) 10GbE PCI Express ethernet driver
+#
+
+obj-$(CONFIG_TXGBE) += txgbe.o
+
+txgbe-objs := txgbe_main.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
new file mode 100644
index 000000000000..38ddbde0ed0f
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_H_
+#define _TXGBE_H_
+
+#include "txgbe_type.h"
+
+#define TXGBE_MAX_FDIR_INDICES          63
+
+#define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+#define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+
+/* board specific private data structure */
+struct txgbe_adapter {
+	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
+};
+
+extern char txgbe_driver_name[];
+
+#endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
new file mode 100644
index 000000000000..55c3c720b377
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/string.h>
+#include <linux/aer.h>
+#include <linux/etherdevice.h>
+
+#include "txgbe.h"
+
+char txgbe_driver_name[] = "txgbe";
+
+/* txgbe_pci_tbl - PCI Device ID Table
+ *
+ * Wildcard entries (PCI_ANY_ID) should come last
+ * Last entry must be all 0s
+ *
+ * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
+ *   Class, Class Mask, private data (not used) }
+ */
+static const struct pci_device_id txgbe_pci_tbl[] = {
+	{ PCI_VDEVICE(WANGXUN, TXGBE_DEV_ID_SP1000), 0},
+	{ PCI_VDEVICE(WANGXUN, TXGBE_DEV_ID_WX1820), 0},
+	/* required last entry */
+	{ .device = 0 }
+};
+
+#define DEFAULT_DEBUG_LEVEL_SHIFT 3
+
+static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
+{
+	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev = adapter->netdev;
+
+	netif_device_detach(netdev);
+
+	pci_disable_device(pdev);
+}
+
+static void txgbe_shutdown(struct pci_dev *pdev)
+{
+	bool wake;
+
+	txgbe_dev_shutdown(pdev, &wake);
+
+	if (system_state == SYSTEM_POWER_OFF) {
+		pci_wake_from_d3(pdev, wake);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
+}
+
+/**
+ * txgbe_probe - Device Initialization Routine
+ * @pdev: PCI device information struct
+ * @ent: entry in txgbe_pci_tbl
+ *
+ * Returns 0 on success, negative on failure
+ *
+ * txgbe_probe initializes an adapter identified by a pci_dev structure.
+ * The OS initialization, configuring of the adapter private structure,
+ * and a hardware reset occur.
+ **/
+static int txgbe_probe(struct pci_dev *pdev,
+		       const struct pci_device_id __always_unused *ent)
+{
+	struct txgbe_adapter *adapter = NULL;
+	struct net_device *netdev;
+	int err;
+
+	err = pci_enable_device_mem(pdev);
+	if (err)
+		return err;
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev,
+			"No usable DMA configuration, aborting\n");
+		goto err_pci_disable_dev;
+	}
+
+	err = pci_request_selected_regions(pdev,
+					   pci_select_bars(pdev, IORESOURCE_MEM),
+					   txgbe_driver_name);
+	if (err) {
+		dev_err(&pdev->dev,
+			"pci_request_selected_regions failed 0x%x\n", err);
+		goto err_pci_disable_dev;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+	pci_set_master(pdev);
+
+	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
+					 sizeof(struct txgbe_adapter),
+					 TXGBE_MAX_TX_QUEUES,
+					 TXGBE_MAX_RX_QUEUES);
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_pci_release_regions;
+	}
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->pdev = pdev;
+
+	adapter->io_addr = devm_ioremap(&pdev->dev,
+					pci_resource_start(pdev, 0),
+					pci_resource_len(pdev, 0));
+	if (!adapter->io_addr) {
+		err = -EIO;
+		goto err_pci_release_regions;
+	}
+
+	netdev->features |= NETIF_F_HIGHDMA;
+
+	pci_set_drvdata(pdev, adapter);
+
+	return 0;
+
+err_pci_release_regions:
+	pci_release_selected_regions(pdev,
+				     pci_select_bars(pdev, IORESOURCE_MEM));
+err_pci_disable_dev:
+	pci_disable_device(pdev);
+	return err;
+}
+
+/**
+ * txgbe_remove - Device Removal Routine
+ * @pdev: PCI device information struct
+ *
+ * txgbe_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.  The could be caused by a
+ * Hot-Plug event, or because the driver is going to be removed from
+ * memory.
+ **/
+static void txgbe_remove(struct pci_dev *pdev)
+{
+	pci_release_selected_regions(pdev,
+				     pci_select_bars(pdev, IORESOURCE_MEM));
+
+	pci_disable_pcie_error_reporting(pdev);
+
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver txgbe_driver = {
+	.name     = txgbe_driver_name,
+	.id_table = txgbe_pci_tbl,
+	.probe    = txgbe_probe,
+	.remove   = txgbe_remove,
+	.shutdown = txgbe_shutdown,
+};
+
+module_pci_driver(txgbe_driver);
+
+MODULE_DEVICE_TABLE(pci, txgbe_pci_tbl);
+MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@trustnetic.com>");
+MODULE_DESCRIPTION("WangXun(R) 10 Gigabit PCI Express Network Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
new file mode 100644
index 000000000000..b2e329f50bae
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_TYPE_H_
+#define _TXGBE_TYPE_H_
+
+#include <linux/types.h>
+#include <linux/netdevice.h>
+
+/************ txgbe_register.h ************/
+/* Vendor ID */
+#ifndef PCI_VENDOR_ID_WANGXUN
+#define PCI_VENDOR_ID_WANGXUN                   0x8088
+#endif
+
+/* Device IDs */
+#define TXGBE_DEV_ID_SP1000                     0x1001
+#define TXGBE_DEV_ID_WX1820                     0x2001
+
+/* Subsystem IDs */
+/* SFP */
+#define TXGBE_ID_SP1000_SFP                     0x0000
+#define TXGBE_ID_WX1820_SFP                     0x2000
+#define TXGBE_ID_SFP                            0x00
+
+/* copper */
+#define TXGBE_ID_SP1000_XAUI                    0x1010
+#define TXGBE_ID_WX1820_XAUI                    0x2010
+#define TXGBE_ID_XAUI                           0x10
+#define TXGBE_ID_SP1000_SGMII                   0x1020
+#define TXGBE_ID_WX1820_SGMII                   0x2020
+#define TXGBE_ID_SGMII                          0x20
+/* backplane */
+#define TXGBE_ID_SP1000_KR_KX_KX4               0x1030
+#define TXGBE_ID_WX1820_KR_KX_KX4               0x2030
+#define TXGBE_ID_KR_KX_KX4                      0x30
+/* MAC Interface */
+#define TXGBE_ID_SP1000_MAC_XAUI                0x1040
+#define TXGBE_ID_WX1820_MAC_XAUI                0x2040
+#define TXGBE_ID_MAC_XAUI                       0x40
+#define TXGBE_ID_SP1000_MAC_SGMII               0x1060
+#define TXGBE_ID_WX1820_MAC_SGMII               0x2060
+#define TXGBE_ID_MAC_SGMII                      0x60
+
+#define TXGBE_NCSI_SUP                          0x8000
+#define TXGBE_NCSI_MASK                         0x8000
+#define TXGBE_WOL_SUP                           0x4000
+#define TXGBE_WOL_MASK                          0x4000
+#define TXGBE_DEV_MASK                          0xf0
+
+/* Combined interface*/
+#define TXGBE_ID_SFI_XAUI			0x50
+
+/* Revision ID */
+#define TXGBE_SP_MPW  1
+
+#endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0



