Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA009148D2B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390851AbgAXRqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:06 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44694 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390021AbgAXRqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:06 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so1075576plo.11
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zc0El/tSao4utC8ALPz3MjLbn8m5+Vgx33vACaxMO1s=;
        b=qjghbMTMzs2XYMWFdv4EGr0KoU5gpphzohxRf80dTP2I6gmwqBGf523VABRAmw6U8F
         30XyhLO9mImmIivuNwPjn0qi1NR7eRnxWdIsNUTedX0zSBI0MqFR6umX0KD9yDn1Uhwh
         Bj8gu7zbO+mCtzeDTgDO5/bqsICP81dbE0OIYOX0mJ6Q3YeLEjXl7S+ZWNGdgaMpp+Ia
         rNfGtPghok4rpxsoXg0ezOoaZ2aD2fzj3384OmRvG2hvNaY7ffjPt/eCHqSLGW7gk1Bt
         5+vwEHsr7kBcFtp4tiMfDiNlfIX1xH8qYXMrhjm2IRkPNltUjrTzE9IUsInInxh36hsX
         yQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zc0El/tSao4utC8ALPz3MjLbn8m5+Vgx33vACaxMO1s=;
        b=BQmLe1vi0nzWeGdevz98JSZgpXCAb8tOgxONLJgrdsP3ADAPtB5CO92BMr81Sjry6S
         eVDrbDx3JUq3JnZR/pRFYPHwRZ80UT6Y6uHYJkJAzETora4Nei3P8rfnSzNyv3kUys2i
         IKMJzDM8hBt9FYMLqZhgZfvm2kneQn2/Fj3Vg22UUlWjDC9vfS+W3CCxOC3xmiJwr7Hg
         JmjJI6QGtJZt+TnGcwkqdIXtslV2ex5vfySik3pHtgdl5bde3g4IA+W1e5ZklWfcyDke
         QrE1kfZD4GA52OEYBpYo42S9uvn7Penaj5tlil/CdkrWml9bM9NBf5BzcwRZDrW42Oil
         ERYA==
X-Gm-Message-State: APjAAAXetsCSM6FthkEuukLruGAzeyk8/S7YRZJ7p9KtaBTyIq9/9m+O
        g6KDj630FYa86Q9VrQ7urINDMsGat1k=
X-Google-Smtp-Source: APXvYqzsrbSotIDbkEdhT2rWLAymwvdBU0ivUcM6pwK68PV3qWaGr8f64De/ECzoYgy0ZfARotQwfA==
X-Received: by 2002:a17:902:bd41:: with SMTP id b1mr4790801plx.82.1579887965216;
        Fri, 24 Jan 2020 09:46:05 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:04 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 01/17] octeontx2-pf: Add Marvell OcteonTX2 NIC driver
Date:   Fri, 24 Jan 2020 23:15:39 +0530
Message-Id: <1579887955-22172-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch adds template for the Marvell's OcteonTX2 network
controller's physical function driver. Just the probe, PCI
specific initialization and netdev registration.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   8 +
 drivers/net/ethernet/marvell/octeontx2/Makefile    |   2 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |  10 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  77 ++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 214 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  51 +++++
 6 files changed, 362 insertions(+)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index fb34fbd..ced514c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -25,3 +25,11 @@ config NDC_DIS_DYNAMIC_CACHING
 	  This config option disables caching of dynamic entries such as NIX SQEs
 	  , NPA stack pages etc in NDC. Also locks down NIX SQ/CQ/RQ/RSS and
 	  NPA Aura/Pool contexts.
+
+config OCTEONTX2_PF
+	tristate "Marvell OcteonTX2 NIC Physical Function driver"
+	select OCTEONTX2_MBOX
+	depends on (64BIT && COMPILE_TEST) || ARM64
+	depends on PCI
+	help
+	  This driver supports Marvell's OcteonTX2 NIC physical function.
diff --git a/drivers/net/ethernet/marvell/octeontx2/Makefile b/drivers/net/ethernet/marvell/octeontx2/Makefile
index e579dcd..0064a69 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/Makefile
@@ -3,4 +3,6 @@
 # Makefile for Marvell OcteonTX2 device drivers.
 #
 
+obj-$(CONFIG_OCTEONTX2_MBOX) += af/
 obj-$(CONFIG_OCTEONTX2_AF) += af/
+obj-$(CONFIG_OCTEONTX2_PF) += nic/
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
new file mode 100644
index 0000000..622b803
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for Marvell's OcteonTX2 ethernet device drivers
+#
+
+obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
+
+octeontx2_nicpf-y := otx2_pf.o
+
+ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
new file mode 100644
index 0000000..9d52ab3
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef OTX2_COMMON_H
+#define OTX2_COMMON_H
+
+#include <linux/pci.h>
+
+#include "otx2_reg.h"
+
+/* PCI device IDs */
+#define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
+
+/* PCI BAR nos */
+#define PCI_CFG_REG_BAR_NUM                     2
+
+struct otx2_hw {
+	struct pci_dev		*pdev;
+	u16                     rx_queues;
+	u16                     tx_queues;
+	u16			max_queues;
+};
+
+struct otx2_nic {
+	void __iomem		*reg_base;
+	struct net_device	*netdev;
+
+	struct otx2_hw		hw;
+	struct pci_dev		*pdev;
+	struct device		*dev;
+};
+
+/* Register read/write APIs */
+static inline void __iomem *otx2_get_regaddr(struct otx2_nic *nic, u64 offset)
+{
+	u64 blkaddr;
+
+	switch ((offset >> RVU_FUNC_BLKADDR_SHIFT) & RVU_FUNC_BLKADDR_MASK) {
+	case BLKTYPE_NIX:
+		blkaddr = BLKADDR_NIX0;
+		break;
+	case BLKTYPE_NPA:
+		blkaddr = BLKADDR_NPA;
+		break;
+	default:
+		blkaddr = BLKADDR_RVUM;
+		break;
+	};
+
+	offset &= ~(RVU_FUNC_BLKADDR_MASK << RVU_FUNC_BLKADDR_SHIFT);
+	offset |= (blkaddr << RVU_FUNC_BLKADDR_SHIFT);
+
+	return nic->reg_base + offset;
+}
+
+static inline void otx2_write64(struct otx2_nic *nic, u64 offset, u64 val)
+{
+	void __iomem *addr = otx2_get_regaddr(nic, offset);
+
+	writeq(val, addr);
+}
+
+static inline u64 otx2_read64(struct otx2_nic *nic, u64 offset)
+{
+	void __iomem *addr = otx2_get_regaddr(nic, offset);
+
+	return readq(addr);
+}
+
+#endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
new file mode 100644
index 0000000..d3af200
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/etherdevice.h>
+#include <linux/of.h>
+#include <linux/if_vlan.h>
+#include <linux/iommu.h>
+#include <net/ip.h>
+
+#include "otx2_common.h"
+
+#define DRV_NAME	"octeontx2-nicpf"
+#define DRV_STRING	"Marvell OcteonTX2 NIC Physical Function Driver"
+#define DRV_VERSION	"1.0"
+
+/* Supported devices */
+static const struct pci_device_id otx2_pf_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_PF) },
+	{ 0, }  /* end of table */
+};
+
+MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_DESCRIPTION(DRV_STRING);
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, otx2_pf_id_table);
+
+static int otx2_set_real_num_queues(struct net_device *netdev,
+				    int tx_queues, int rx_queues)
+{
+	int err;
+
+	err = netif_set_real_num_tx_queues(netdev, tx_queues);
+	if (err) {
+		netdev_err(netdev,
+			   "Failed to set no of Tx queues: %d\n", tx_queues);
+		return err;
+	}
+
+	err = netif_set_real_num_rx_queues(netdev, rx_queues);
+	if (err)
+		netdev_err(netdev,
+			   "Failed to set no of Rx queues: %d\n", rx_queues);
+	return err;
+}
+
+static int otx2_open(struct net_device *netdev)
+{
+	netif_carrier_off(netdev);
+
+	return 0;
+}
+
+static int otx2_stop(struct net_device *netdev)
+{
+	return 0;
+}
+
+static const struct net_device_ops otx2_netdev_ops = {
+	.ndo_open		= otx2_open,
+	.ndo_stop		= otx2_stop,
+};
+
+static int otx2_check_pf_usable(struct otx2_nic *nic)
+{
+	u64 rev;
+
+	rev = otx2_read64(nic, RVU_PF_BLOCK_ADDRX_DISC(BLKADDR_RVUM));
+	rev = (rev >> 12) & 0xFF;
+	/* Check if AF has setup revision for RVUM block,
+	 * otherwise this driver probe should be deferred
+	 * until AF driver comes up.
+	 */
+	if (!rev) {
+		dev_warn(nic->dev,
+			 "AF is not initialized, deferring probe\n");
+		return -EPROBE_DEFER;
+	}
+	return 0;
+}
+
+static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct device *dev = &pdev->dev;
+	struct net_device *netdev;
+	struct otx2_nic *pf;
+	struct otx2_hw *hw;
+	int err, qcount;
+
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		return err;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(dev, "PCI request regions failed 0x%x\n", err);
+		return err;
+	}
+
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "DMA mask config failed, abort\n");
+		goto err_release_regions;
+	}
+
+	pci_set_master(pdev);
+
+	/* Set number of queues */
+	qcount = min_t(int, num_online_cpus(), num_online_cpus());
+
+	netdev = alloc_etherdev_mqs(sizeof(*pf), qcount, qcount);
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_release_regions;
+	}
+
+	pci_set_drvdata(pdev, netdev);
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	pf = netdev_priv(netdev);
+	pf->netdev = netdev;
+	pf->pdev = pdev;
+	pf->dev = dev;
+
+	hw = &pf->hw;
+	hw->pdev = pdev;
+	hw->rx_queues = qcount;
+	hw->tx_queues = qcount;
+	hw->max_queues = qcount;
+
+	/* Map CSRs */
+	pf->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
+	if (!pf->reg_base) {
+		dev_err(dev, "Unable to map physical function CSRs, aborting\n");
+		err = -ENOMEM;
+		goto err_free_netdev;
+	}
+
+	err = otx2_check_pf_usable(pf);
+	if (err)
+		goto err_free_netdev;
+
+	err = otx2_set_real_num_queues(netdev, hw->tx_queues, hw->rx_queues);
+	if (err)
+		goto err_free_netdev;
+
+	netdev->netdev_ops = &otx2_netdev_ops;
+
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(dev, "Failed to register netdevice\n");
+		goto err_free_netdev;
+	}
+
+	return 0;
+
+err_free_netdev:
+	pci_set_drvdata(pdev, NULL);
+	free_netdev(netdev);
+err_release_regions:
+	pci_release_regions(pdev);
+	return err;
+}
+
+static void otx2_remove(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct otx2_nic *pf;
+
+	if (!netdev)
+		return;
+
+	pf = netdev_priv(netdev);
+
+	unregister_netdev(netdev);
+	pci_free_irq_vectors(pf->pdev);
+	pci_set_drvdata(pdev, NULL);
+	free_netdev(netdev);
+	pci_release_regions(pdev);
+}
+
+static struct pci_driver otx2_pf_driver = {
+	.name = DRV_NAME,
+	.id_table = otx2_pf_id_table,
+	.probe = otx2_probe,
+	.shutdown = otx2_remove,
+	.remove = otx2_remove,
+};
+
+static int __init otx2_rvupf_init_module(void)
+{
+	pr_info("%s: %s\n", DRV_NAME, DRV_STRING);
+
+	return pci_register_driver(&otx2_pf_driver);
+}
+
+static void __exit otx2_rvupf_cleanup_module(void)
+{
+	pci_unregister_driver(&otx2_pf_driver);
+}
+
+module_init(otx2_rvupf_init_module);
+module_exit(otx2_rvupf_cleanup_module);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
new file mode 100644
index 0000000..d0bd64a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef OTX2_REG_H
+#define OTX2_REG_H
+
+#include <rvu_struct.h>
+
+/* RVU PF registers */
+#define	RVU_PF_VFX_PFVF_MBOX0		    (0x00000)
+#define	RVU_PF_VFX_PFVF_MBOX1		    (0x00008)
+#define RVU_PF_VFX_PFVF_MBOXX(a, b)         (0x0 | (a) << 12 | (b) << 3)
+#define RVU_PF_VF_BAR4_ADDR                 (0x10)
+#define RVU_PF_BLOCK_ADDRX_DISC(a)          (0x200 | (a) << 3)
+#define RVU_PF_VFME_STATUSX(a)              (0x800 | (a) << 3)
+#define RVU_PF_VFTRPENDX(a)                 (0x820 | (a) << 3)
+#define RVU_PF_VFTRPEND_W1SX(a)             (0x840 | (a) << 3)
+#define RVU_PF_VFPF_MBOX_INTX(a)            (0x880 | (a) << 3)
+#define RVU_PF_VFPF_MBOX_INT_W1SX(a)        (0x8A0 | (a) << 3)
+#define RVU_PF_VFPF_MBOX_INT_ENA_W1SX(a)    (0x8C0 | (a) << 3)
+#define RVU_PF_VFPF_MBOX_INT_ENA_W1CX(a)    (0x8E0 | (a) << 3)
+#define RVU_PF_VFFLR_INTX(a)                (0x900 | (a) << 3)
+#define RVU_PF_VFFLR_INT_W1SX(a)            (0x920 | (a) << 3)
+#define RVU_PF_VFFLR_INT_ENA_W1SX(a)        (0x940 | (a) << 3)
+#define RVU_PF_VFFLR_INT_ENA_W1CX(a)        (0x960 | (a) << 3)
+#define RVU_PF_VFME_INTX(a)                 (0x980 | (a) << 3)
+#define RVU_PF_VFME_INT_W1SX(a)             (0x9A0 | (a) << 3)
+#define RVU_PF_VFME_INT_ENA_W1SX(a)         (0x9C0 | (a) << 3)
+#define RVU_PF_VFME_INT_ENA_W1CX(a)         (0x9E0 | (a) << 3)
+#define RVU_PF_PFAF_MBOX0                   (0xC00)
+#define RVU_PF_PFAF_MBOX1                   (0xC08)
+#define RVU_PF_PFAF_MBOXX(a)                (0xC00 | (a) << 3)
+#define RVU_PF_INT                          (0xc20)
+#define RVU_PF_INT_W1S                      (0xc28)
+#define RVU_PF_INT_ENA_W1S                  (0xc30)
+#define RVU_PF_INT_ENA_W1C                  (0xc38)
+#define RVU_PF_MSIX_VECX_ADDR(a)            (0x000 | (a) << 4)
+#define RVU_PF_MSIX_VECX_CTL(a)             (0x008 | (a) << 4)
+#define RVU_PF_MSIX_PBAX(a)                 (0xF0000 | (a) << 3)
+
+#define RVU_FUNC_BLKADDR_SHIFT		20
+#define RVU_FUNC_BLKADDR_MASK		0x1FULL
+
+#endif /* OTX2_REG_H */
-- 
2.7.4

