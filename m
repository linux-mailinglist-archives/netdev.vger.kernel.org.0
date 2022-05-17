Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B707529DA5
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbiEQJOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244350AbiEQJNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:13:44 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB237A95
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:13:00 -0700 (PDT)
X-QQ-mid: bizesmtp82t1652778769tmidr5du
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 17 May 2022 17:12:40 +0800 (CST)
X-QQ-SSF: 01400000002000F0O000000A0000000
X-QQ-FEAT: HoyAXBWgsknM92mjpnl9vTIH16NHYS2g9czyotNjLjr9nbAV8SoX6gyjin9Kd
        5rpsTW/LBotQxNS/+rxL+jK6G/wq9u/OmxYD4I4NVkXXH6lUZ/VEUS5T201YDA5x0pJUqRc
        rikwahKTYsXJZeNl3buzp1YWS2NV4CbkypsCFPJOK1huo390lDnkn7Bzc9IZOucz7EQow0x
        6NUjP5zQ7OrM7PsNK9naoBtm6mcbNu8DPw+lqC7mh4XMBq+HYQtmaYFqe0tcFIwdJvUhzPJ
        WYi0bFIg99VsruAYgji2gGPT1v9yXTZk0Bnb8SH5AFJ5TUqh35uNlFE2x+UmpL+evauOCiJ
        1bTJj1UcGSs9K9bkXoZPs4vWuViNgWFYOODBdApbVLQJ8Am9qM=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2] net: txgbe: Add build support for txgbe
Date:   Tue, 17 May 2022 17:21:09 +0800
Message-Id: <20220517092109.8161-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign10
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
 .../device_drivers/ethernet/index.rst         |   1 +
 .../device_drivers/ethernet/wangxun/txgbe.rst |  19 +
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/wangxun/Kconfig          |  34 ++
 drivers/net/ethernet/wangxun/Makefile         |   6 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   9 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  76 ++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 332 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  87 +++++
 11 files changed, 573 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
 create mode 100644 drivers/net/ethernet/wangxun/Kconfig
 create mode 100644 drivers/net/ethernet/wangxun/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 6b5dc203da2b..4766ac9d260e 100644
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
index 000000000000..de5661ba0603
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -0,0 +1,19 @@
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
diff --git a/MAINTAINERS b/MAINTAINERS
index b7b1dfba707c..37d1043d1926 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21207,6 +21207,13 @@ L:	linux-input@vger.kernel.org
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
index 827993022386..e505cb1c171b 100644
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
index 8ef43e0c33c0..82db3b15e421 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
 obj-$(CONFIG_NET_VENDOR_TUNDRA) += tundra/
 obj-$(CONFIG_NET_VENDOR_VERTEXCOM) += vertexcom/
 obj-$(CONFIG_NET_VENDOR_VIA) += via/
+obj-$(CONFIG_NET_VENDOR_WANGXUN) += wangxun/
 obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
 obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/
diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
new file mode 100644
index 000000000000..251f222f84db
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -0,0 +1,34 @@
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
+	depends on PTP_1588_CLOCK_OPTIONAL
+	select PHYLIB
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
index 000000000000..725aa1f721f6
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd.
+#
+# Makefile for the Wangxun(R) 10GbE PCI Express ethernet driver
+#
+
+obj-$(CONFIG_TXGBE) += txgbe.o
+
+txgbe-objs := txgbe_main.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
new file mode 100644
index 000000000000..d51b5a2c5356
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_H_
+#define _TXGBE_H_
+
+#include "txgbe_type.h"
+
+#ifndef MAX_REQUEST_SIZE
+#define MAX_REQUEST_SIZE 256
+#endif
+
+#define TXGBE_MAX_FDIR_INDICES          63
+
+#define MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+
+/* board specific private data structure */
+struct txgbe_adapter {
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
+
+	unsigned long state;
+
+	/* structs defined in txgbe_hw.h */
+	struct txgbe_hw hw;
+	u16 msg_enable;
+
+	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+};
+
+enum txgbe_state_t {
+	__TXGBE_TESTING,
+	__TXGBE_RESETTING,
+	__TXGBE_DOWN,
+	__TXGBE_HANGING,
+	__TXGBE_DISABLED,
+	__TXGBE_REMOVING,
+	__TXGBE_SERVICE_SCHED,
+	__TXGBE_SERVICE_INITED,
+	__TXGBE_IN_SFP_INIT,
+	__TXGBE_PTP_RUNNING,
+	__TXGBE_PTP_TX_IN_PROGRESS,
+};
+
+#define TXGBE_NAME "txgbe"
+
+static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
+{
+	return &pdev->dev;
+}
+
+#define txgbe_dev_info(format, arg...) \
+	dev_info(&adapter->pdev->dev, format, ## arg)
+#define txgbe_dev_warn(format, arg...) \
+	dev_warn(&adapter->pdev->dev, format, ## arg)
+#define txgbe_dev_err(format, arg...) \
+	dev_err(&adapter->pdev->dev, format, ## arg)
+#define txgbe_dev_notice(format, arg...) \
+	dev_notice(&adapter->pdev->dev, format, ## arg)
+#define txgbe_dbg(msglvl, format, arg...) \
+	netif_dbg(adapter, msglvl, adapter->netdev, format, ## arg)
+#define txgbe_info(msglvl, format, arg...) \
+	netif_info(adapter, msglvl, adapter->netdev, format, ## arg)
+#define txgbe_err(msglvl, format, arg...) \
+	netif_err(adapter, msglvl, adapter->netdev, format, ## arg)
+#define txgbe_warn(msglvl, format, arg...) \
+	netif_warn(adapter, msglvl, adapter->netdev, format, ## arg)
+#define txgbe_crit(msglvl, format, arg...) \
+	netif_crit(adapter, msglvl, adapter->netdev, format, ## arg)
+
+#define TXGBE_FAILED_READ_CFG_DWORD 0xffffffffU
+#define TXGBE_FAILED_READ_CFG_WORD  0xffffU
+#define TXGBE_FAILED_READ_CFG_BYTE  0xffU
+
+#endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
new file mode 100644
index 000000000000..17a30629f76a
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
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
+char txgbe_driver_name[32] = TXGBE_NAME;
+static const char txgbe_driver_string[] =
+			"WangXun 10 Gigabit PCI Express Network Driver";
+
+static const char txgbe_copyright[] =
+	"Copyright (c) 2015 -2017 Beijing WangXun Technology Co., Ltd";
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
+	{ PCI_VDEVICE(TRUSTNETIC, TXGBE_DEV_ID_SP1000), 0},
+	{ PCI_VDEVICE(TRUSTNETIC, TXGBE_DEV_ID_WX1820), 0},
+	/* required last entry */
+	{ .device = 0 }
+};
+MODULE_DEVICE_TABLE(pci, txgbe_pci_tbl);
+
+MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@trustnetic.com>");
+MODULE_DESCRIPTION("WangXun(R) 10 Gigabit PCI Express Network Driver");
+MODULE_LICENSE("GPL");
+
+#define DEFAULT_DEBUG_LEVEL_SHIFT 3
+
+static struct workqueue_struct *txgbe_wq;
+
+static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev);
+
+static void txgbe_remove_adapter(struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter = hw->back;
+
+	if (!hw->hw_addr)
+		return;
+	hw->hw_addr = NULL;
+	txgbe_dev_err("Adapter removed\n");
+}
+
+/**
+ * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
+ * @adapter: board private structure to initialize
+ *
+ * txgbe_sw_init initializes the Adapter private data structure.
+ * Fields are initialized based on PCI device information and
+ * OS network device settings (MTU size).
+ **/
+static int txgbe_sw_init(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct pci_dev *pdev = adapter->pdev;
+	int err = 0;
+
+	/* PCI config space info */
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
+	if (hw->revision_id == TXGBE_FAILED_READ_CFG_BYTE &&
+	    txgbe_check_cfg_remove(hw, pdev)) {
+		txgbe_err(probe, "read of revision id failed\n");
+		err = -ENODEV;
+		goto out;
+	}
+	hw->subsystem_vendor_id = pdev->subsystem_vendor;
+	hw->subsystem_device_id = pdev->subsystem_device;
+
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &hw->subsystem_id);
+	if (hw->subsystem_id == TXGBE_FAILED_READ_CFG_WORD) {
+		txgbe_err(probe, "read of subsystem id failed\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
+{
+	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev = adapter->netdev;
+
+	netif_device_detach(netdev);
+
+	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
+		pci_disable_device(pdev);
+
+	return 0;
+}
+
+static void txgbe_shutdown(struct pci_dev *pdev)
+{
+	bool wake;
+
+	__txgbe_shutdown(pdev, &wake);
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
+	struct net_device *netdev;
+	struct txgbe_adapter *adapter = NULL;
+	struct txgbe_hw *hw = NULL;
+	int err, pci_using_dac;
+	unsigned int indices = MAX_TX_QUEUES;
+	bool disable_dev = false;
+
+	err = pci_enable_device_mem(pdev);
+	if (err)
+		return err;
+
+	if (!dma_set_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(64)) &&
+	    !dma_set_coherent_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(64))) {
+		pci_using_dac = 1;
+	} else {
+		err = dma_set_mask(pci_dev_to_dev(pdev), DMA_BIT_MASK(32));
+		if (err) {
+			err = dma_set_coherent_mask(pci_dev_to_dev(pdev),
+						    DMA_BIT_MASK(32));
+			if (err) {
+				dev_err(pci_dev_to_dev(pdev),
+					"No usable DMA configuration, aborting\n");
+				goto err_dma;
+			}
+		}
+		pci_using_dac = 0;
+	}
+
+	err = pci_request_selected_regions(pdev,
+					   pci_select_bars(pdev, IORESOURCE_MEM),
+					   txgbe_driver_name);
+	if (err) {
+		dev_err(pci_dev_to_dev(pdev),
+			"pci_request_selected_regions failed 0x%x\n", err);
+		goto err_pci_reg;
+	}
+
+	hw = vmalloc(sizeof(*hw));
+	if (!hw)
+		return -ENOMEM;
+
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	vfree(hw);
+
+	pci_enable_pcie_error_reporting(pdev);
+	pci_set_master(pdev);
+	/* errata 16 */
+	if (MAX_REQUEST_SIZE == 512) {
+		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
+						   PCI_EXP_DEVCTL_READRQ,
+						   0x2000);
+	} else {
+		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
+						   PCI_EXP_DEVCTL_READRQ,
+						   0x1000);
+	}
+
+	netdev = alloc_etherdev_mq(sizeof(struct txgbe_adapter), indices);
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_alloc_etherdev;
+	}
+
+	SET_NETDEV_DEV(netdev, pci_dev_to_dev(pdev));
+
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->pdev = pdev;
+	hw = &adapter->hw;
+	hw->back = adapter;
+	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
+
+	hw->hw_addr = ioremap(pci_resource_start(pdev, 0),
+			      pci_resource_len(pdev, 0));
+	adapter->io_addr = hw->hw_addr;
+	if (!hw->hw_addr) {
+		err = -EIO;
+		goto err_ioremap;
+	}
+
+	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
+
+	/* setup the private structure */
+	err = txgbe_sw_init(adapter);
+	if (err)
+		goto err_sw_init;
+
+	if (pci_using_dac)
+		netdev->features |= NETIF_F_HIGHDMA;
+
+err_sw_init:
+	iounmap(adapter->io_addr);
+err_ioremap:
+	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
+	free_netdev(netdev);
+err_alloc_etherdev:
+	pci_release_selected_regions(pdev,
+				     pci_select_bars(pdev, IORESOURCE_MEM));
+err_pci_reg:
+err_dma:
+	if (!adapter || disable_dev)
+		pci_disable_device(pdev);
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
+	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev;
+	bool disable_dev;
+
+	/* if !adapter then we already cleaned up in probe */
+	if (!adapter)
+		return;
+
+	netdev = adapter->netdev;
+
+	iounmap(adapter->io_addr);
+	pci_release_selected_regions(pdev,
+				     pci_select_bars(pdev, IORESOURCE_MEM));
+
+	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
+	free_netdev(netdev);
+
+	pci_disable_pcie_error_reporting(pdev);
+
+	if (disable_dev)
+		pci_disable_device(pdev);
+}
+
+static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev)
+{
+	u16 value;
+
+	pci_read_config_word(pdev, PCI_VENDOR_ID, &value);
+	if (value == TXGBE_FAILED_READ_CFG_WORD) {
+		txgbe_remove_adapter(hw);
+		return true;
+	}
+	return false;
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
+/**
+ * txgbe_init_module - Driver Registration Routine
+ *
+ * txgbe_init_module is the first routine called when the driver is
+ * loaded. All it does is register with the PCI subsystem.
+ **/
+static int __init txgbe_init_module(void)
+{
+	int ret;
+
+	pr_info("%s\n", txgbe_driver_string);
+	pr_info("%s\n", txgbe_copyright);
+
+	txgbe_wq = create_singlethread_workqueue(txgbe_driver_name);
+	if (!txgbe_wq) {
+		pr_err("%s: Failed to create workqueue\n", txgbe_driver_name);
+		return -ENOMEM;
+	}
+
+	ret = pci_register_driver(&txgbe_driver);
+	return ret;
+}
+
+module_init(txgbe_init_module);
+
+/**
+ * txgbe_exit_module - Driver Exit Cleanup Routine
+ *
+ * txgbe_exit_module is called just before the driver is removed
+ * from memory.
+ **/
+static void __exit txgbe_exit_module(void)
+{
+	pci_unregister_driver(&txgbe_driver);
+	if (txgbe_wq)
+		destroy_workqueue(txgbe_wq);
+}
+
+module_exit(txgbe_exit_module);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
new file mode 100644
index 000000000000..ba9306982317
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_TYPE_H_
+#define _TXGBE_TYPE_H_
+
+#include <linux/types.h>
+#include <linux/netdevice.h>
+
+/* Little Endian defines */
+#ifndef __le16
+#define __le16  u16
+#endif
+#ifndef __le32
+#define __le32  u32
+#endif
+#ifndef __le64
+#define __le64  u64
+
+#endif
+#ifndef __be16
+/* Big Endian defines */
+#define __be16  u16
+#define __be32  u32
+#define __be64  u64
+
+#endif
+
+/************ txgbe_register.h ************/
+/* Vendor ID */
+#ifndef PCI_VENDOR_ID_TRUSTNETIC
+#define PCI_VENDOR_ID_TRUSTNETIC                0x8088
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
+struct txgbe_hw {
+	u8 __iomem *hw_addr;
+	void *back;
+	u16 device_id;
+	u16 vendor_id;
+	u16 subsystem_device_id;
+	u16 subsystem_vendor_id;
+	u8 revision_id;
+	u16 subsystem_id;
+};
+
+#endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0



