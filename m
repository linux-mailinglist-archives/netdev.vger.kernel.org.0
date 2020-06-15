Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5CE1F9C3E
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgFOPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:50:15 -0400
Received: from m12-14.163.com ([220.181.12.14]:46513 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgFOPuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 11:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=VbFE9
        pBPE0+LUCXWNZbyiaEtK5o14VIgrm4p2bj0358=; b=SUhiSIq6/mDe5WCeAnftT
        9wtNNW96MTLjzXDGs4tMtk1rle99qHbKb9g12Ni56qEaQNAfc+/VUiaB21kzO/1J
        mLphRqamJhwv07W0rzJYf/PX1QwTPb45cChuR+7MwvURWCw394wQOpHNjIPlCVG0
        BJtj2sqYyTXPbQr64KPYA8=
Received: from SZA191027643-PM.china.huawei.com (unknown [223.74.115.177])
        by smtp10 (Coremail) with SMTP id DsCowABXOli7jOdeQnE4Gw--.52836S3;
        Mon, 15 Jun 2020 22:59:09 +0800 (CST)
From:   yunaixin03610@163.com
To:     netdev@vger.kernel.org
Cc:     yunaixin <yunaixin@huawei.com>
Subject: [PATCH 1/5] Huawei BMA: Adding Huawei BMA driver: host_edma_drv
Date:   Mon, 15 Jun 2020 22:59:02 +0800
Message-Id: <20200615145906.1013-2-yunaixin03610@163.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200615145906.1013-1-yunaixin03610@163.com>
References: <20200615145906.1013-1-yunaixin03610@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowABXOli7jOdeQnE4Gw--.52836S3
X-Coremail-Antispam: 1Uf129KBjvAXoWkGr4kWw4kCFyDXFyxXr1rXrb_yoWDJr4UJo
        WfX3ZxXr4rJw17Aw18Cr17WFyUuFy8Za98Jr4SkFWqv3WkJw15JrWUKFWxZr13Xr4rKF4U
        C3ySvws3XrW8Xr93n29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU73x6UUUUU
X-Originating-IP: [223.74.115.177]
X-CM-SenderInfo: 51xqtxx0lqijqwrqqiywtou0bp/1tbiQB1E5lSIfbXPRAAAsg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yunaixin <yunaixin@huawei.com>

The BMA software is a system management software offered by Huawei. It supports the status monitoring, performance monitoring, and event monitoring of various components, including server CPUs, memory, hard disks, NICs, IB cards, PCIe cards, RAID controller cards, and optical modules.

This host_edma_drv driver is a PCIe driver used by Huawei BMA software. The main function of it is to control the PCIe bus between BMA software and Huawei 1711 chip. The chip will then process the data and display to users. This host_edma_drv driver offers API to send/receive data for other BMA drivers which want to use the PCIe channel in different ways(eg. host_cdev_drv, host_veth_drv).

Signed-off-by: yunaixin <yunaixin@huawei.com>
---
 drivers/net/ethernet/huawei/Kconfig           |    1 +
 drivers/net/ethernet/huawei/Makefile          |    1 +
 drivers/net/ethernet/huawei/bma/Kconfig       |    1 +
 drivers/net/ethernet/huawei/bma/Makefile      |    5 +
 .../net/ethernet/huawei/bma/edma_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/edma_drv/Makefile |    2 +
 .../huawei/bma/edma_drv/bma_devintf.c         |  597 +++++++
 .../huawei/bma/edma_drv/bma_devintf.h         |   40 +
 .../huawei/bma/edma_drv/bma_include.h         |  118 ++
 .../ethernet/huawei/bma/edma_drv/bma_pci.c    |  533 ++++++
 .../ethernet/huawei/bma/edma_drv/bma_pci.h    |   94 ++
 .../ethernet/huawei/bma/edma_drv/edma_host.c  | 1462 +++++++++++++++++
 .../ethernet/huawei/bma/edma_drv/edma_host.h  |  351 ++++
 .../huawei/bma/include/bma_ker_intf.h         |   91 +
 14 files changed, 3307 insertions(+)
 create mode 100644 drivers/net/ethernet/huawei/bma/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_include.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/edma_host.h
 create mode 100644 drivers/net/ethernet/huawei/bma/include/bma_ker_intf.h

diff --git a/drivers/net/ethernet/huawei/Kconfig b/drivers/net/ethernet/huawei/Kconfig
index bdcbface62d7..83ebaee13229 100644
--- a/drivers/net/ethernet/huawei/Kconfig
+++ b/drivers/net/ethernet/huawei/Kconfig
@@ -16,5 +16,6 @@ config NET_VENDOR_HUAWEI
 if NET_VENDOR_HUAWEI
 
 source "drivers/net/ethernet/huawei/hinic/Kconfig"
+source "drivers/net/ethernet/huawei/bma/Kconfig"
 
 endif # NET_VENDOR_HUAWEI
diff --git a/drivers/net/ethernet/huawei/Makefile b/drivers/net/ethernet/huawei/Makefile
index 2549ad5afe6d..555aeee2003c 100644
--- a/drivers/net/ethernet/huawei/Makefile
+++ b/drivers/net/ethernet/huawei/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_HINIC) += hinic/
+obj-$(CONFIG_HINIC) += bma/
diff --git a/drivers/net/ethernet/huawei/bma/Kconfig b/drivers/net/ethernet/huawei/bma/Kconfig
new file mode 100644
index 000000000000..1a92c1dd83f3
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/Kconfig
@@ -0,0 +1 @@
+source "drivers/net/ethernet/huawei/bma/edma_drv/Kconfig"
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
new file mode 100644
index 000000000000..8f589f7986d6
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/Makefile
@@ -0,0 +1,5 @@
+# 
+# Makefile for BMA software driver
+# 
+
+obj-$(CONFIG_BMA) += edma_drv/
\ No newline at end of file
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/Kconfig b/drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
new file mode 100644
index 000000000000..97829c5487c2
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
@@ -0,0 +1,11 @@
+#
+# Huawei BMA software driver configuration
+#
+
+config BMA
+	tristate "Huawei BMA Software Communication Driver"
+
+	---help---
+	  This driver supports Huawei BMA Software. It is used 
+	  to communication between Huawei BMA and BMC software.
+
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/Makefile b/drivers/net/ethernet/huawei/bma/edma_drv/Makefile
new file mode 100644
index 000000000000..46cc51275a71
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BMA) += host_edma_drv.o
+host_edma_drv-y := bma_pci.o bma_devintf.o edma_host.o
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.c b/drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.c
new file mode 100644
index 000000000000..7817f58f8635
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.c
@@ -0,0 +1,597 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <asm/ioctls.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/proc_fs.h>
+#include <linux/notifier.h>
+#include "../include/bma_ker_intf.h"
+#include "bma_include.h"
+#include "bma_devintf.h"
+#include "bma_pci.h"
+#include "edma_host.h"
+
+static struct bma_dev_s *g_bma_dev;
+
+static ATOMIC_NOTIFIER_HEAD(bma_int_notify_list);
+
+static int bma_priv_insert_priv_list(struct bma_priv_data_s *priv, u32 type,
+				     u32 sub_type)
+{
+	unsigned long flags = 0;
+	int ret = 0;
+	struct edma_user_inft_s *user_inft = NULL;
+
+	if (type >= TYPE_MAX || !priv)
+		return -EFAULT;
+
+	user_inft = edma_host_get_user_inft(type);
+
+	if (user_inft && user_inft->user_register) {
+		ret = user_inft->user_register(priv);
+		if (ret) {
+			BMA_LOG(DLOG_ERROR, "register failed\n");
+			return -EFAULT;
+		}
+	} else {
+		if (!g_bma_dev)
+			return -ENXIO;
+
+		if (atomic_dec_and_test(&g_bma_dev->au_count[type]) == 0) {
+			BMA_LOG(DLOG_ERROR,
+				"busy, init_dev_type.type = %d, au_count = %d\n",
+				type,
+				atomic_read(&g_bma_dev->au_count[type]));
+			atomic_inc(&g_bma_dev->au_count[type]);
+			return -EBUSY;	/* already register */
+		}
+
+		priv->user.type = type;
+		priv->user.sub_type = sub_type;
+		priv->user.user_id = 0;
+
+		spin_lock_irqsave(&g_bma_dev->priv_list_lock, flags);
+
+		list_add_rcu(&priv->user.link, &g_bma_dev->priv_list);
+
+		spin_unlock_irqrestore(&g_bma_dev->priv_list_lock, flags);
+	}
+
+	return 0;
+}
+
+static int bma_priv_delete_priv_list(struct bma_priv_data_s *priv)
+{
+	unsigned long flags = 0;
+	struct edma_user_inft_s *user_inft = NULL;
+
+	if (!priv || priv->user.type >= TYPE_MAX)
+		return -EFAULT;
+	user_inft = edma_host_get_user_inft(priv->user.type);
+	if (user_inft && user_inft->user_register) {
+		user_inft->user_unregister(priv);
+	} else {
+		if (!g_bma_dev)
+			return -ENXIO;
+		spin_lock_irqsave(&g_bma_dev->priv_list_lock, flags);
+		list_del_rcu(&priv->user.link);
+		spin_unlock_irqrestore(&g_bma_dev->priv_list_lock, flags);
+		/* release the type */
+		atomic_inc(&g_bma_dev->au_count[priv->user.type]);
+	}
+	return 0;
+}
+
+static int bma_priv_init(struct bma_priv_data_s **bma_priv)
+{
+	struct bma_priv_data_s *priv = NULL;
+
+	if (!bma_priv)
+		return -EFAULT;
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		BMA_LOG(DLOG_ERROR, "malloc priv failed\n");
+		return -ENOMEM;
+	}
+
+	memset(priv, 0, sizeof(struct bma_priv_data_s));
+
+	spin_lock_init(&priv->recv_msg_lock);
+	INIT_LIST_HEAD(&priv->recv_msgs);
+	init_waitqueue_head(&priv->wait);
+
+	priv->user.type = TYPE_UNKNOWN;
+	priv->user.sub_type = 0;
+	priv->user.dma_transfer = 0;
+	priv->user.seq = 0;
+	priv->user.cur_recvmsg_nums = 0;
+	priv->user.max_recvmsg_nums = DEFAULT_MAX_RECV_MSG_NUMS;
+
+	*bma_priv = priv;
+
+	return 0;
+}
+
+static void bma_priv_clean_up(struct bma_priv_data_s *bma_priv)
+{
+	int ret = 0;
+	int i = 0;
+	struct bma_priv_data_s *priv = bma_priv;
+	struct edma_recv_msg_s *msg = NULL;
+
+	if (!priv)
+		return;
+
+	if (priv->user.type == TYPE_UNKNOWN) {
+		BMA_LOG(DLOG_ERROR, "already unknown type\n");
+		return;
+	}
+
+	for (i = 0; i < priv->user.max_recvmsg_nums; i++) {
+		ret = edma_host_recv_msg(&g_bma_dev->edma_host, priv, &msg);
+		if (ret)
+			break;
+
+		kfree(msg);
+	}
+
+	priv->user.type = TYPE_UNKNOWN;
+	priv->user.sub_type = 0;
+	priv->user.dma_transfer = 0;
+	priv->user.seq = 0;
+	priv->user.cur_recvmsg_nums = 0;
+	priv->user.max_recvmsg_nums = DEFAULT_MAX_RECV_MSG_NUMS;
+	kfree(priv);
+}
+
+static irqreturn_t bma_irq_handle(int irq, void *data)
+{
+	struct bma_dev_s *bma_dev = (struct bma_dev_s *)data;
+
+	if (!bma_dev)
+		return IRQ_HANDLED;
+
+	bma_dev->edma_host.statistics.b2h_int++;
+
+	if (!is_edma_b2h_int(&bma_dev->edma_host))
+		return edma_host_irq_handle(&bma_dev->edma_host);
+
+	return (irqreturn_t)atomic_notifier_call_chain(&bma_int_notify_list, 0,
+						       data);
+}
+
+int bma_devinft_init(struct bma_pci_dev_s *bma_pci_dev)
+{
+	int ret = 0;
+	int i = 0;
+	struct bma_dev_s *bma_dev = NULL;
+
+	if (!bma_pci_dev)
+		return -EFAULT;
+
+	bma_dev = kmalloc(sizeof(*bma_dev), (int)GFP_KERNEL);
+	if (!bma_dev)
+		return -ENOMEM;
+
+	memset(bma_dev, 0, sizeof(struct bma_dev_s));
+
+	bma_dev->bma_pci_dev = bma_pci_dev;
+	bma_pci_dev->bma_dev = bma_dev;
+
+	INIT_LIST_HEAD(&bma_dev->priv_list);
+	spin_lock_init(&bma_dev->priv_list_lock);
+
+	for (i = 0; i < TYPE_MAX; i++)
+		atomic_set(&bma_dev->au_count[i], 1);
+
+	ret = edma_host_init(&bma_dev->edma_host);
+	if (ret) {
+		BMA_LOG(DLOG_ERROR, "init edma host failed!err = %d\n", ret);
+		goto err_free_bma_dev;
+	}
+
+	BMA_LOG(DLOG_DEBUG, "irq = %d\n", bma_pci_dev->pdev->irq);
+
+	ret = request_irq(bma_pci_dev->pdev->irq, bma_irq_handle, IRQF_SHARED,
+			  "EDMA_IRQ", (void *)bma_dev);
+	if (ret) {
+		BMA_LOG(DLOG_ERROR, "request_irq failed!err = %d\n", ret);
+		goto err_edma_host_exit;
+	}
+
+	g_bma_dev = bma_dev;
+	BMA_LOG(DLOG_DEBUG, "ok\n");
+
+	return 0;
+
+err_edma_host_exit:
+	edma_host_cleanup(&bma_dev->edma_host);
+
+err_free_bma_dev:
+	kfree(bma_dev);
+	bma_pci_dev->bma_dev = NULL;
+
+	return ret;
+}
+
+void bma_devinft_cleanup(struct bma_pci_dev_s *bma_pci_dev)
+{
+	if (g_bma_dev) {
+		if ((bma_pci_dev) && bma_pci_dev->pdev &&
+		    bma_pci_dev->pdev->irq) {
+			BMA_LOG(DLOG_DEBUG, "irq = %d\n",
+				bma_pci_dev->pdev->irq);
+			free_irq(bma_pci_dev->pdev->irq,
+				 (void *)bma_pci_dev->bma_dev);
+		}
+
+		edma_host_cleanup(&g_bma_dev->edma_host);
+
+		if ((bma_pci_dev) && bma_pci_dev->bma_dev) {
+			kfree(bma_pci_dev->bma_dev);
+			bma_pci_dev->bma_dev = NULL;
+		}
+
+		g_bma_dev = NULL;
+	}
+}
+
+int bma_intf_register_int_notifier(struct notifier_block *nb)
+{
+	if (!nb)
+		return -1;
+
+	return atomic_notifier_chain_register(&bma_int_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(bma_intf_register_int_notifier);
+
+void bma_intf_unregister_int_notifier(struct notifier_block *nb)
+{
+	if (!nb)
+		return;
+
+	atomic_notifier_chain_unregister(&bma_int_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(bma_intf_unregister_int_notifier);
+
+int bma_intf_register_type(u32 type, u32 sub_type, enum intr_mod support_int,
+			   void **handle)
+{
+	int ret = 0;
+	struct bma_priv_data_s *priv = NULL;
+
+	if (!handle)
+		return -EFAULT;
+
+	ret = bma_priv_init(&priv);
+	if (ret) {
+		BMA_LOG(DLOG_ERROR, "bma_priv_init failed! ret = %d\n", ret);
+		return ret;
+	}
+
+	ret = bma_priv_insert_priv_list(priv, type, sub_type);
+	if (ret) {
+		bma_priv_clean_up(priv);
+		BMA_LOG(DLOG_ERROR,
+			"bma_priv_insert_priv_list failed! ret = %d\n", ret);
+		return ret;
+	}
+
+	if (support_int)
+		priv->user.support_int = INTR_ENABLE;
+
+	if (type == TYPE_VETH) {
+		priv->specific.veth.pdev = g_bma_dev->bma_pci_dev->pdev;
+
+		priv->specific.veth.veth_swap_phy_addr =
+		    g_bma_dev->bma_pci_dev->veth_swap_phy_addr;
+		priv->specific.veth.veth_swap_addr =
+		    g_bma_dev->bma_pci_dev->veth_swap_addr;
+		priv->specific.veth.veth_swap_len =
+		    g_bma_dev->bma_pci_dev->veth_swap_len;
+	}
+
+	*handle = priv;
+
+	return 0;
+}
+EXPORT_SYMBOL(bma_intf_register_type);
+
+int bma_intf_unregister_type(void **handle)
+{
+	struct bma_priv_data_s *priv = NULL;
+
+	if (!handle) {
+		BMA_LOG(DLOG_ERROR, "edna_priv is NULL\n");
+		return -EFAULT;
+	}
+
+	priv = (struct bma_priv_data_s *)*handle;
+	*handle = NULL;
+
+	priv->user.cur_recvmsg_nums++;
+	wake_up_interruptible(&priv->wait);
+
+	msleep(500);
+
+	bma_priv_delete_priv_list(priv);
+
+	bma_priv_clean_up(priv);
+
+	return 0;
+}
+EXPORT_SYMBOL(bma_intf_unregister_type);
+
+int bma_intf_check_edma_supported(void)
+{
+	return !(!g_bma_dev);
+}
+EXPORT_SYMBOL(bma_intf_check_edma_supported);
+
+int bma_intf_check_dma_status(enum dma_direction_e dir)
+{
+	return edma_host_check_dma_status(dir);
+}
+EXPORT_SYMBOL(bma_intf_check_dma_status);
+
+void bma_intf_reset_dma(enum dma_direction_e dir)
+{
+	edma_host_reset_dma(&g_bma_dev->edma_host, dir);
+}
+EXPORT_SYMBOL(bma_intf_reset_dma);
+
+void bma_intf_clear_dma_int(enum dma_direction_e dir)
+{
+	if (dir == BMC_TO_HOST)
+		clear_int_dmab2h(&g_bma_dev->edma_host);
+	else if (dir == HOST_TO_BMC)
+		clear_int_dmah2b(&g_bma_dev->edma_host);
+	else
+		return;
+}
+EXPORT_SYMBOL(bma_intf_clear_dma_int);
+
+int bma_intf_start_dma(void *handle, struct bma_dma_transfer_s *dma_transfer)
+{
+	int ret = 0;
+	struct bma_priv_data_s *priv = (struct bma_priv_data_s *)handle;
+
+	if (!handle || !dma_transfer)
+		return -EFAULT;
+
+	ret = edma_host_dma_start(&g_bma_dev->edma_host, priv);
+	if (ret) {
+		BMA_LOG(DLOG_ERROR,
+			"edma_host_dma_start failed! result = %d\n", ret);
+		return ret;
+	}
+
+	ret = edma_host_dma_transfer(&g_bma_dev->edma_host, priv, dma_transfer);
+	if (ret)
+		BMA_LOG(DLOG_ERROR,
+			"edma_host_dma_transfer failed! ret = %d\n", ret);
+
+	ret = edma_host_dma_stop(&g_bma_dev->edma_host, priv);
+	if (ret) {
+		BMA_LOG(DLOG_ERROR,
+			"edma_host_dma_stop failed! result = %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(bma_intf_start_dma);
+
+int bma_intf_int_to_bmc(void *handle)
+{
+	struct bma_priv_data_s *priv = (struct bma_priv_data_s *)handle;
+
+	if (!handle)
+		return -EFAULT;
+
+	if (priv->user.support_int == 0) {
+		BMA_LOG(DLOG_ERROR, "not support int to bmc.\n");
+		return -EFAULT;
+	}
+
+	edma_int_to_bmc(&g_bma_dev->edma_host);
+
+	return 0;
+}
+EXPORT_SYMBOL(bma_intf_int_to_bmc);
+
+int bma_intf_is_link_ok(void)
+{
+	return (g_bma_dev->edma_host.statistics.remote_status ==
+		REGISTERED) ? 1 : 0;
+}
+EXPORT_SYMBOL(bma_intf_is_link_ok);
+
+int bma_cdev_recv_msg(void *handle, char __user *data, size_t count)
+{
+	struct bma_priv_data_s *priv = NULL;
+	struct edma_recv_msg_s *msg = NULL;
+	int result = 0;
+	int len = 0;
+
+	if (!handle || !data || count == 0) {
+		BMA_LOG(DLOG_DEBUG, "input NULL point!\n");
+		return -EFAULT;
+	}
+
+	priv = (struct bma_priv_data_s *)handle;
+
+	result = edma_host_recv_msg(&g_bma_dev->edma_host, priv, &msg);
+	if (result != 0)
+		return -ENODATA;
+
+	if (msg->msg_len > count) {
+		kfree(msg);
+		return -EFAULT;
+	}
+
+	if (copy_to_user(data, (void *)msg->msg_data, msg->msg_len)) {
+		kfree(msg);
+		return -EFAULT;
+	}
+
+	len = msg->msg_len;
+
+	kfree(msg);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(bma_cdev_recv_msg);
+
+int bma_cdev_add_msg(void *handle, const char __user *msg, size_t msg_len)
+{
+	struct bma_priv_data_s *priv = NULL;
+	struct edma_msg_hdr_s *hdr = NULL;
+	unsigned long flags = 0;
+	int total_len = 0;
+	int ret = 0;
+	struct edma_host_s *phost = &g_bma_dev->edma_host;
+
+	if (!handle || !msg || msg_len == 0) {
+		BMA_LOG(DLOG_DEBUG, "input NULL point!\n");
+		return -EFAULT;
+	}
+
+	if (msg_len > CDEV_MAX_WRITE_LEN) {
+		BMA_LOG(DLOG_DEBUG, "input data is overlen!\n");
+		return -EINVAL;
+	}
+
+	priv = (struct bma_priv_data_s *)handle;
+
+	if (priv->user.type >= TYPE_MAX) {
+		BMA_LOG(DLOG_DEBUG, "error type = %d\n", priv->user.type);
+		return -EFAULT;
+	}
+	total_len = SIZE_OF_MSG_HDR + msg_len;
+
+	spin_lock_irqsave(&phost->send_msg_lock, flags);
+
+	if (phost->msg_send_write + total_len <=
+	    HOST_MAX_SEND_MBX_LEN - SIZE_OF_MBX_HDR) {
+		hdr = (struct edma_msg_hdr_s *)(phost->msg_send_buf +
+						phost->msg_send_write);
+		hdr->type = priv->user.type;
+		hdr->sub_type = priv->user.sub_type;
+		hdr->user_id = priv->user.user_id;
+		hdr->datalen = msg_len;
+		BMA_LOG(DLOG_DEBUG, "msg_len is %ld\n", msg_len);
+
+		if (copy_from_user(hdr->data, msg, msg_len)) {
+			BMA_LOG(DLOG_ERROR, "copy_from_user error\n");
+		ret = -EFAULT;
+		goto end;
+		}
+
+		phost->msg_send_write += total_len;
+		phost->statistics.send_bytes += total_len;
+		phost->statistics.send_pkgs++;
+#ifdef EDMA_TIMER
+		(void)mod_timer(&phost->timer, jiffies_64);
+#endif
+		BMA_LOG(DLOG_DEBUG, "msg_send_write = %d\n",
+			phost->msg_send_write);
+
+		ret = msg_len;
+		goto end;
+	} else {
+		BMA_LOG(DLOG_DEBUG,
+			"msg lost,msg_send_write: %d,msg_len:%d,max_len: %d\n",
+			phost->msg_send_write, total_len,
+			HOST_MAX_SEND_MBX_LEN);
+		ret = -ENOSPC;
+		goto end;
+	}
+
+end:
+	spin_unlock_irqrestore(&g_bma_dev->edma_host.send_msg_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bma_cdev_add_msg);
+
+unsigned int bma_cdev_check_recv(void *handle)
+{
+	struct bma_priv_data_s *priv = (struct bma_priv_data_s *)handle;
+	unsigned long flags = 0;
+	unsigned int result = 0;
+
+	if (priv) {
+		spin_lock_irqsave(&priv->recv_msg_lock, flags);
+
+		if (!list_empty(&priv->recv_msgs))
+			result = 1;
+
+		spin_unlock_irqrestore(&priv->recv_msg_lock, flags);
+	}
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(bma_cdev_check_recv);
+
+void *bma_cdev_get_wait_queue(void *handle)
+{
+	struct bma_priv_data_s *priv = (struct bma_priv_data_s *)handle;
+
+	return priv ? ((void *)&priv->wait) : NULL;
+}
+EXPORT_SYMBOL_GPL(bma_cdev_get_wait_queue);
+
+void bma_intf_set_open_status(void *handle, int s)
+{
+	struct bma_priv_data_s *priv = (struct bma_priv_data_s *)handle;
+	int i = 0;
+	int ret = 0;
+	unsigned long flags = 0;
+	char drv_msg[3] = { 0 };
+	struct edma_recv_msg_s *tmp_msg = NULL;
+
+	if (!priv || priv->user.type >= TYPE_MAX)
+		return;
+
+	drv_msg[0] = 1;
+	drv_msg[1] = priv->user.type;
+	drv_msg[2] = s;
+
+	(void)edma_host_send_driver_msg((void *)drv_msg, sizeof(drv_msg),
+						DEV_OPEN_STATUS_ANS);
+
+		spin_lock_irqsave(&priv->recv_msg_lock, flags);
+		g_bma_dev->edma_host.local_open_status[priv->user.type] = s;
+
+		if (s == DEV_CLOSE && priv->user.cur_recvmsg_nums > 0) {
+			for (i = 0; i < priv->user.max_recvmsg_nums; i++) {
+				ret = edma_host_recv_msg(&g_bma_dev->edma_host,
+							 priv, &tmp_msg);
+				if (ret < 0)
+					break;
+
+				kfree(tmp_msg);
+				tmp_msg = NULL;
+			}
+		}
+
+		spin_unlock_irqrestore(&priv->recv_msg_lock, flags);
+}
+EXPORT_SYMBOL_GPL(bma_intf_set_open_status);
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.h b/drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.h
new file mode 100644
index 000000000000..138d1e278479
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _BMA_DEVINTF_H_
+#define _BMA_DEVINTF_H_
+
+#include <linux/mutex.h>
+#include "bma_pci.h"
+#include "edma_host.h"
+
+struct bma_dev_s {
+	/* proc */
+	struct proc_dir_entry *proc_bma_root;
+
+	atomic_t au_count[TYPE_MAX];
+
+	struct list_head priv_list;
+	/* spinlock for priv list */
+	spinlock_t priv_list_lock;
+
+	struct bma_pci_dev_s *bma_pci_dev;
+	struct edma_host_s edma_host;
+};
+
+int bma_devinft_init(struct bma_pci_dev_s *bma_pci_dev);
+void bma_devinft_cleanup(struct bma_pci_dev_s *bma_pci_dev);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/bma_include.h b/drivers/net/ethernet/huawei/bma/edma_drv/bma_include.h
new file mode 100644
index 000000000000..469d2095e00e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/bma_include.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _BMA_INCLUDE_H_
+#define _BMA_INCLUDE_H_
+
+#include <linux/slab.h>
+#include <asm/ioctls.h>
+#include <linux/capability.h>
+#include <linux/uaccess.h>	/* copy_*_user */
+#include <linux/delay.h>	/* udelay */
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>	/*tasklet */
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/semaphore.h>
+#include <linux/sched.h>
+
+#define UNUSED(x) (x = x)
+#define KBOX_FALSE (-1)
+#define KBOX_TRUE 0
+
+#define KBOX_IOC_MAGIC (0xB2)
+
+#define DEFAULT_MAX_RECV_MSG_NUMS   32
+#define MAX_RECV_MSG_NUMS 1024
+
+#define STRFICATION(R) #R
+#define MICRO_TO_STR(R) STRFICATION(R)
+
+enum {
+	DLOG_ERROR = 0,
+	DLOG_DEBUG = 1,
+};
+
+enum {
+	DEV_CLOSE = 0,
+	DEV_OPEN = 1,
+	DEV_OPEN_STATUS_REQ = 0xf0,
+	DEV_OPEN_STATUS_ANS
+};
+
+#define BAD_FUNC_ADDR(x) ((x) == 0xFFFFFFFF || ((x) == 0))
+
+struct bma_user_s {
+	struct list_head link;
+
+	u32 type;
+	u32 sub_type;
+	u8 user_id;
+
+	u8 dma_transfer:1, support_int:1;
+
+	u8 reserve1[2];
+	u32 seq;
+	u16 cur_recvmsg_nums;
+	u16 max_recvmsg_nums;
+};
+
+struct bma_priv_data_veth_s {
+	struct pci_dev *pdev;
+
+	unsigned long veth_swap_phy_addr;
+	void __iomem *veth_swap_addr;
+	unsigned long veth_swap_len;
+};
+
+struct bma_priv_data_s {
+	struct bma_user_s user;
+	/* spinlock for recv msg list */
+	spinlock_t recv_msg_lock;
+	struct list_head recv_msgs;
+	struct file *file;
+	wait_queue_head_t wait;
+
+	union {
+		struct bma_priv_data_veth_s veth;
+	} specific;
+};
+
+#if defined(timer_setup) && defined(from_timer)
+#define HAVE_TIMER_SETUP
+#endif
+
+void __iomem *kbox_get_base_addr(void);
+unsigned long kbox_get_io_len(void);
+unsigned long kbox_get_base_phy_addr(void);
+int edma_param_set_debug(const char *buf, const struct kernel_param *kp);
+
+#define GET_SYS_SECONDS(t) do \
+	{\
+		struct timespec uptime;\
+		get_monotonic_boottime(&uptime);\
+		t = uptime.tv_sec;\
+	} while (0)
+
+#define SECONDS_PER_DAY (24 * 3600)
+#define SECONDS_PER_HOUR (3600)
+#define SECONDS_PER_MINUTE (60)
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c b/drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c
new file mode 100644
index 000000000000..577acaedb0e2
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c
@@ -0,0 +1,533 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pci.h>
+#include <linux/version.h>
+#include <linux/module.h>
+
+#include "bma_include.h"
+#include "bma_devintf.h"
+#include "bma_pci.h"
+
+#define PCI_KBOX_MODULE_NAME		"edma_drv"
+#define PCI_VENDOR_ID_HUAWEI_FPGA	0x19aa
+#define PCI_DEVICE_ID_KBOX_0		0xe004
+
+#define PCI_VENDOR_ID_HUAWEI_PME	0x19e5
+#define PCI_DEVICE_ID_KBOX_0_PME	0x1710
+#define PCI_PME_USEABLE_SPACE		(4 * 1024 * 1024)
+#define PME_DEV_CHECK(device, vendor) ((device) == PCI_DEVICE_ID_KBOX_0_PME && \
+				       (vendor) == PCI_VENDOR_ID_HUAWEI_PME)
+
+#define PCI_BAR0_PME_1710		0x85800000
+#define PCI_BAR0			0
+#define PCI_BAR1			1
+#define PCI_USING_DAC_DEFAULT 0
+
+#define GET_HIGH_ADDR(address)	((sizeof(unsigned long) == 8) ? \
+				 ((u64)(address) >> 32) : 0)
+
+/* The value of the expression is true
+ * only when dma_set_mask and dma_set_coherent_mask failed.
+ */
+#define SET_DMA_MASK(p_dev) \
+	(dma_set_mask((p_dev), DMA_BIT_MASK(64)) && \
+	 dma_set_coherent_mask((p_dev), DMA_BIT_MASK(64)))
+
+int pci_using_dac = PCI_USING_DAC_DEFAULT;
+int debug = DLOG_ERROR;
+MODULE_PARM_DESC(debug, "Debug switch (0=close debug, 1=open debug)");
+
+static struct bma_pci_dev_s *g_bma_pci_dev;
+
+static int bma_pci_suspend(struct pci_dev *pdev, pm_message_t state);
+static int bma_pci_resume(struct pci_dev *pdev);
+static int bma_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void bma_pci_remove(struct pci_dev *pdev);
+
+static const struct pci_device_id bma_pci_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_HUAWEI_FPGA, PCI_DEVICE_ID_KBOX_0)},
+	{PCI_DEVICE(PCI_VENDOR_ID_HUAWEI_PME, PCI_DEVICE_ID_KBOX_0_PME)},
+	{}
+};
+MODULE_DEVICE_TABLE(pci, bma_pci_tbl);
+
+int edma_param_get_statics(char *buf, const struct kernel_param *kp)
+{
+	if (!buf)
+		return 0;
+
+	return edmainfo_show(buf);
+}
+
+module_param_call(statistics, NULL, edma_param_get_statics, &debug, 0444);
+MODULE_PARM_DESC(statistics, "Statistics info of edma driver,readonly");
+
+int edma_param_set_debug(const char *buf, const struct kernel_param *kp)
+{
+	unsigned long val = 0;
+	int ret = 0;
+
+	if (!buf)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 0, &val);
+
+	if (ret)
+		return ret;
+
+	if (val > 1)
+		return -EINVAL;
+
+	return param_set_int(buf, kp);
+}
+EXPORT_SYMBOL_GPL(edma_param_set_debug);
+
+module_param_call(debug, &edma_param_set_debug, &param_get_int, &debug, 0644);
+
+void __iomem *kbox_get_base_addr(void)
+{
+	if (!g_bma_pci_dev || (!(g_bma_pci_dev->kbox_base_addr))) {
+		BMA_LOG(DLOG_ERROR, "kbox_base_addr NULL point\n");
+		return NULL;
+	}
+
+	return g_bma_pci_dev->kbox_base_addr;
+}
+EXPORT_SYMBOL_GPL(kbox_get_base_addr);
+
+unsigned long kbox_get_io_len(void)
+{
+	if (!g_bma_pci_dev) {
+		BMA_LOG(DLOG_ERROR, "kbox_io_len is error,can not get it\n");
+		return 0;
+	}
+
+	return g_bma_pci_dev->kbox_base_len;
+}
+EXPORT_SYMBOL_GPL(kbox_get_io_len);
+
+unsigned long kbox_get_base_phy_addr(void)
+{
+	if (!g_bma_pci_dev || !g_bma_pci_dev->kbox_base_phy_addr) {
+		BMA_LOG(DLOG_ERROR, "kbox_base_phy_addr NULL point\n");
+		return 0;
+	}
+
+	return g_bma_pci_dev->kbox_base_phy_addr;
+}
+EXPORT_SYMBOL_GPL(kbox_get_base_phy_addr);
+
+static struct pci_driver bma_driver = {
+	.name = PCI_KBOX_MODULE_NAME,
+	.id_table = bma_pci_tbl,
+	.probe = bma_pci_probe,
+	.remove = bma_pci_remove,
+	.suspend = bma_pci_suspend,
+	.resume = bma_pci_resume,
+};
+
+s32 __atu_config_H(struct pci_dev *pdev, unsigned int region,
+		   unsigned int hostaddr_h, unsigned int hostaddr_l,
+		   unsigned int bmcaddr_h, unsigned int bmcaddr_l,
+		   unsigned int len)
+{
+	/*  atu index reg,inbound and region*/
+	(void)pci_write_config_dword(pdev, ATU_VIEWPORT,
+		REGION_DIR_INPUT + (region & REGION_INDEX_MASK));
+	(void)pci_write_config_dword(pdev, ATU_BASE_LOW, hostaddr_l);
+	(void)pci_write_config_dword(pdev, ATU_BASE_HIGH, hostaddr_h);
+	(void)pci_write_config_dword(pdev, ATU_LIMIT, hostaddr_l + len - 1);
+	(void)pci_write_config_dword(pdev, ATU_TARGET_LOW, bmcaddr_l);
+	(void)pci_write_config_dword(pdev, ATU_TARGET_HIGH, bmcaddr_h);
+	/*  atu ctrl1 reg   */
+	(void)pci_write_config_dword(pdev, ATU_REGION_CTRL1, ATU_CTRL1_DEFAULT);
+	/*  atu ctrl2 reg   */
+	(void)pci_write_config_dword(pdev, ATU_REGION_CTRL2, REGION_ENABLE);
+
+	return 0;
+}
+
+static void iounmap_bar_mem(struct bma_pci_dev_s *bma_pci_dev)
+{
+	if (bma_pci_dev->kbox_base_addr) {
+		iounmap(bma_pci_dev->kbox_base_addr);
+		bma_pci_dev->kbox_base_addr = NULL;
+	}
+
+	if (bma_pci_dev->bma_base_addr) {
+		iounmap(bma_pci_dev->bma_base_addr);
+		bma_pci_dev->bma_base_addr = NULL;
+		bma_pci_dev->edma_swap_addr = NULL;
+		bma_pci_dev->hostrtc_viraddr = NULL;
+	}
+}
+
+static int ioremap_pme_bar1_mem(struct pci_dev *pdev,
+				struct bma_pci_dev_s *bma_pci_dev)
+{
+	unsigned long bar1_resource_flag = 0;
+	u32 data = 0;
+
+	bma_pci_dev->kbox_base_len = PCI_PME_USEABLE_SPACE;
+	BMA_LOG(DLOG_DEBUG, "1710\n");
+
+	bma_pci_dev->bma_base_phy_addr =
+	    pci_resource_start(pdev, PCI_BAR1);
+	bar1_resource_flag = pci_resource_flags(pdev, PCI_BAR1);
+
+	if (!(bar1_resource_flag & IORESOURCE_MEM)) {
+		BMA_LOG(DLOG_ERROR,
+			"Cannot find proper PCI device base address, aborting\n");
+		return -ENODEV;
+	}
+
+	bma_pci_dev->bma_base_len = pci_resource_len(pdev, PCI_BAR1);
+	bma_pci_dev->edma_swap_len = EDMA_SWAP_DATA_SIZE;
+	bma_pci_dev->veth_swap_len = VETH_SWAP_DATA_SIZE;
+
+	BMA_LOG(DLOG_DEBUG,
+		"bar1: bma_base_len = 0x%lx, edma_swap_len = %ld, veth_swap_len = %ld(0x%lx)\n",
+		bma_pci_dev->bma_base_len, bma_pci_dev->edma_swap_len,
+		bma_pci_dev->veth_swap_len, bma_pci_dev->veth_swap_len);
+
+	bma_pci_dev->hostrtc_phyaddr = bma_pci_dev->bma_base_phy_addr;
+	/* edma */
+	bma_pci_dev->edma_swap_phy_addr =
+		bma_pci_dev->bma_base_phy_addr + EDMA_SWAP_BASE_OFFSET;
+	/* veth */
+	bma_pci_dev->veth_swap_phy_addr =
+		bma_pci_dev->edma_swap_phy_addr + EDMA_SWAP_DATA_SIZE;
+
+	BMA_LOG(DLOG_DEBUG,
+		"bar1: hostrtc_phyaddr = 0x%lx, edma_swap_phy_addr = 0x%lx, veth_swap_phy_addr = 0x%lx\n",
+		bma_pci_dev->hostrtc_phyaddr,
+		bma_pci_dev->edma_swap_phy_addr,
+		bma_pci_dev->veth_swap_phy_addr);
+
+	__atu_config_H(pdev, 0,
+		       GET_HIGH_ADDR(bma_pci_dev->kbox_base_phy_addr),
+			(bma_pci_dev->kbox_base_phy_addr & 0xffffffff),
+		0, PCI_BAR0_PME_1710, PCI_PME_USEABLE_SPACE);
+
+	__atu_config_H(pdev, 1,
+		       GET_HIGH_ADDR(bma_pci_dev->hostrtc_phyaddr),
+			(bma_pci_dev->hostrtc_phyaddr & 0xffffffff),
+			0, HOSTRTC_REG_BASE, HOSTRTC_REG_SIZE);
+
+	__atu_config_H(pdev, 2,
+		       GET_HIGH_ADDR(bma_pci_dev->edma_swap_phy_addr),
+			(bma_pci_dev->edma_swap_phy_addr & 0xffffffff),
+			0, EDMA_SWAP_DATA_BASE, EDMA_SWAP_DATA_SIZE);
+
+	__atu_config_H(pdev, 3,
+		       GET_HIGH_ADDR(bma_pci_dev->veth_swap_phy_addr),
+			(bma_pci_dev->veth_swap_phy_addr & 0xffffffff),
+			0, VETH_SWAP_DATA_BASE, VETH_SWAP_DATA_SIZE);
+
+	if (bar1_resource_flag & IORESOURCE_CACHEABLE) {
+		bma_pci_dev->bma_base_addr =
+		    ioremap(bma_pci_dev->bma_base_phy_addr,
+			    bma_pci_dev->bma_base_len);
+	} else {
+		bma_pci_dev->bma_base_addr =
+		    IOREMAP(bma_pci_dev->bma_base_phy_addr,
+			    bma_pci_dev->bma_base_len);
+	}
+
+	if (!bma_pci_dev->bma_base_addr) {
+		BMA_LOG(DLOG_ERROR,
+			"Cannot map device registers, aborting\n");
+
+		return -ENODEV;
+	}
+
+	bma_pci_dev->hostrtc_viraddr = bma_pci_dev->bma_base_addr;
+	bma_pci_dev->edma_swap_addr =
+	    (unsigned char *)bma_pci_dev->bma_base_addr +
+	    EDMA_SWAP_BASE_OFFSET;
+	bma_pci_dev->veth_swap_addr =
+	    (unsigned char *)bma_pci_dev->edma_swap_addr +
+	    EDMA_SWAP_DATA_SIZE;
+
+	(void)pci_read_config_dword(pdev, 0x78, &data);
+	data = data & 0xfffffff0;
+	(void)pci_write_config_dword(pdev, 0x78, data);
+	(void)pci_read_config_dword(pdev, 0x78, &data);
+
+	return 0;
+}
+
+static int ioremap_bar_mem(struct pci_dev *pdev,
+			   struct bma_pci_dev_s *bma_pci_dev)
+{
+	int err = 0;
+	unsigned long bar0_resource_flag = 0;
+
+	bar0_resource_flag = pci_resource_flags(pdev, PCI_BAR0);
+
+	if (!(bar0_resource_flag & IORESOURCE_MEM)) {
+		BMA_LOG(DLOG_ERROR,
+			"Cannot find proper PCI device base address, aborting\n");
+		err = -ENODEV;
+		return err;
+	}
+
+	bma_pci_dev->kbox_base_phy_addr = pci_resource_start(pdev, PCI_BAR0);
+
+	bma_pci_dev->kbox_base_len = pci_resource_len(pdev, PCI_BAR0);
+
+	BMA_LOG(DLOG_DEBUG,
+		"bar0: kbox_base_phy_addr = 0x%lx, base_len = %ld(0x%lx)\n",
+		bma_pci_dev->kbox_base_phy_addr, bma_pci_dev->kbox_base_len,
+		bma_pci_dev->kbox_base_len);
+
+	if (PME_DEV_CHECK(pdev->device, pdev->vendor)) {
+		err = ioremap_pme_bar1_mem(pdev, bma_pci_dev);
+		if (err != 0)
+			return err;
+	}
+
+	BMA_LOG(DLOG_DEBUG, "remap BAR0 KBOX\n");
+
+	if (bar0_resource_flag & IORESOURCE_CACHEABLE) {
+		bma_pci_dev->kbox_base_addr =
+		    ioremap(bma_pci_dev->kbox_base_phy_addr,
+			    bma_pci_dev->kbox_base_len);
+	} else {
+		bma_pci_dev->kbox_base_addr =
+		    IOREMAP(bma_pci_dev->kbox_base_phy_addr,
+			    bma_pci_dev->kbox_base_len);
+	}
+
+	if (!bma_pci_dev->kbox_base_addr) {
+		BMA_LOG(DLOG_ERROR, "Cannot map device registers, aborting\n");
+
+		iounmap(bma_pci_dev->bma_base_addr);
+		bma_pci_dev->bma_base_addr = NULL;
+		bma_pci_dev->edma_swap_addr = NULL;
+		bma_pci_dev->hostrtc_viraddr = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int pme_pci_enable_msi(struct pci_dev *pdev)
+{
+	int err = 0;
+
+	pci_set_master(pdev);
+
+#ifdef CONFIG_PCI_MSI
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSI) == 0) {
+		BMA_LOG(DLOG_ERROR, "not support msi\n");
+		pci_disable_device(pdev);
+		return err;
+	}
+
+	BMA_LOG(DLOG_DEBUG, "support msi\n");
+
+	err = pci_enable_msi(pdev);
+	if (err) {
+		BMA_LOG(DLOG_ERROR, "pci_enable_msi failed\n");
+		pci_disable_device(pdev);
+		return err;
+	}
+#endif
+
+	return err;
+}
+
+int pci_device_init(struct pci_dev *pdev, struct bma_pci_dev_s *bma_pci_dev)
+{
+	int err = 0;
+
+	if (PME_DEV_CHECK(pdev->device, pdev->vendor)) {
+		err = bma_devinft_init(bma_pci_dev);
+		if (err) {
+			BMA_LOG(DLOG_ERROR, "bma_devinft_init failed\n");
+			bma_devinft_cleanup(bma_pci_dev);
+			iounmap_bar_mem(bma_pci_dev);
+			g_bma_pci_dev = NULL;
+			pci_release_regions(pdev);
+			kfree(bma_pci_dev);
+		#ifdef CONFIG_PCI_MSI
+			pci_disable_msi(pdev);
+		#endif
+			pci_disable_device(pdev);
+
+			return err;
+		}
+	} else {
+		BMA_LOG(DLOG_DEBUG, "edma is not supported on this pcie\n");
+	}
+
+	pci_set_drvdata(pdev, bma_pci_dev);
+
+	return 0;
+}
+
+int pci_device_config(struct pci_dev *pdev)
+{
+	int err = 0;
+	struct bma_pci_dev_s *bma_pci_dev = NULL;
+
+	bma_pci_dev = kmalloc(sizeof(*bma_pci_dev), GFP_KERNEL);
+	if (!bma_pci_dev) {
+		err = -ENOMEM;
+		goto err_out_disable_msi;
+	}
+	memset(bma_pci_dev, 0, sizeof(*bma_pci_dev));
+
+	bma_pci_dev->pdev = pdev;
+
+	err = pci_request_regions(pdev, PCI_KBOX_MODULE_NAME);
+	if (err) {
+		BMA_LOG(DLOG_ERROR, "Cannot obtain PCI resources, aborting\n");
+		goto err_out_free_dev;
+	}
+
+	err = ioremap_bar_mem(pdev, bma_pci_dev);
+	if (err) {
+		BMA_LOG(DLOG_ERROR, "ioremap_edma_io_mem failed\n");
+		goto err_out_release_regions;
+	}
+
+	g_bma_pci_dev = bma_pci_dev;
+
+	if (SET_DMA_MASK(&pdev->dev)) {
+		BMA_LOG(DLOG_ERROR,
+			"No usable DMA ,configuration, aborting,goto failed2!!!\n");
+		goto err_out_unmap_bar;
+	}
+
+	g_bma_pci_dev = bma_pci_dev;
+
+	return pci_device_init(pdev, bma_pci_dev);
+
+err_out_unmap_bar:
+	iounmap_bar_mem(bma_pci_dev);
+	g_bma_pci_dev = NULL;
+err_out_release_regions:
+	pci_release_regions(pdev);
+err_out_free_dev:
+	kfree(bma_pci_dev);
+	bma_pci_dev = NULL;
+err_out_disable_msi:
+#ifdef CONFIG_PCI_MSI
+	pci_disable_msi(pdev);
+#endif
+
+	pci_disable_device(pdev);
+
+	return err;
+}
+
+static int bma_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int err = 0;
+
+	UNUSED(ent);
+
+	if (g_bma_pci_dev)
+		return -EPERM;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		BMA_LOG(DLOG_ERROR, "Cannot enable PCI device,aborting\n");
+		return err;
+	}
+
+	if (PME_DEV_CHECK(pdev->device, pdev->vendor)) {
+		err = pme_pci_enable_msi(pdev);
+		if (err)
+			return err;
+	}
+
+	BMA_LOG(DLOG_DEBUG, "pdev->device = 0x%x\n", pdev->device);
+	BMA_LOG(DLOG_DEBUG, "pdev->vendor = 0x%x\n", pdev->vendor);
+
+	return pci_device_config(pdev);
+}
+
+static void bma_pci_remove(struct pci_dev *pdev)
+{
+	struct bma_pci_dev_s *bma_pci_dev =
+		(struct bma_pci_dev_s *)pci_get_drvdata(pdev);
+
+	g_bma_pci_dev = NULL;
+	(void)pci_set_drvdata(pdev, NULL);
+
+	if (bma_pci_dev) {
+		bma_devinft_cleanup(bma_pci_dev);
+
+		iounmap_bar_mem(bma_pci_dev);
+
+		kfree(bma_pci_dev);
+	}
+
+	pci_release_regions(pdev);
+
+#ifdef CONFIG_PCI_MSI
+	pci_disable_msi(pdev);
+#endif
+	pci_disable_device(pdev);
+}
+
+static int bma_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	UNUSED(pdev);
+	UNUSED(state);
+
+	return 0;
+}
+
+static int bma_pci_resume(struct pci_dev *pdev)
+{
+	UNUSED(pdev);
+
+	return 0;
+}
+
+int __init bma_pci_init(void)
+{
+	int ret = 0;
+
+	BMA_LOG(DLOG_DEBUG, "\n");
+
+	ret = pci_register_driver(&bma_driver);
+	if (ret)
+		BMA_LOG(DLOG_ERROR, "pci_register_driver failed\n");
+
+	return ret;
+}
+
+void __exit bma_pci_cleanup(void)
+{
+	BMA_LOG(DLOG_DEBUG, "\n");
+
+	pci_unregister_driver(&bma_driver);
+}
+
+MODULE_AUTHOR("HUAWEI TECHNOLOGIES CO., LTD.");
+MODULE_DESCRIPTION("HUAWEI EDMA DRIVER");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(BMA_VERSION);
+#ifndef _lint
+
+module_init(bma_pci_init);
+module_exit(bma_pci_cleanup);
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.h b/drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.h
new file mode 100644
index 000000000000..2851e583666a
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _BMA_PCI_H_
+#define _BMA_PCI_H_
+
+#include "bma_devintf.h"
+#include "bma_include.h"
+#include <linux/netdevice.h>
+
+#define EDMA_SWAP_BASE_OFFSET	0x10000
+
+#define HOSTRTC_REG_BASE	0x2f000000
+#define HOSTRTC_REG_SIZE	EDMA_SWAP_BASE_OFFSET
+
+#define EDMA_SWAP_DATA_BASE	0x84810000
+#define EDMA_SWAP_DATA_SIZE	65536
+
+#define VETH_SWAP_DATA_BASE	0x84820000
+#define VETH_SWAP_DATA_SIZE	0xdf000
+
+#define ATU_VIEWPORT		0x900
+#define	ATU_REGION_CTRL1	0x904
+#define ATU_REGION_CTRL2	0x908
+#define ATU_BASE_LOW		0x90C
+#define ATU_BASE_HIGH		0x910
+#define ATU_LIMIT		0x914
+#define	ATU_TARGET_LOW		0x918
+#define ATU_TARGET_HIGH		0x91C
+#define REGION_DIR_OUTPUT	(0x0 << 31)
+#define REGION_DIR_INPUT	(0x1 << 31)
+#define REGION_INDEX_MASK	0x7
+#define	REGION_ENABLE		(0x1 << 31)
+#define	ATU_CTRL1_DEFAULT	0x0
+struct bma_pci_dev_s {
+	unsigned long kbox_base_phy_addr;
+	void __iomem *kbox_base_addr;
+	unsigned long kbox_base_len;
+
+	unsigned long bma_base_phy_addr;
+	void __iomem *bma_base_addr;
+	unsigned long bma_base_len;
+
+	unsigned long hostrtc_phyaddr;
+	void __iomem *hostrtc_viraddr;
+
+	unsigned long edma_swap_phy_addr;
+	void __iomem *edma_swap_addr;
+	unsigned long edma_swap_len;
+
+	unsigned long veth_swap_phy_addr;
+	void __iomem *veth_swap_addr;
+	unsigned long veth_swap_len;
+
+	struct pci_dev *pdev;
+	struct bma_dev_s *bma_dev;
+};
+
+#ifdef DRV_VERSION
+#define BMA_VERSION MICRO_TO_STR(DRV_VERSION)
+#else
+#define BMA_VERSION "0.3.4"
+#endif
+
+#ifdef CONFIG_ARM64
+#define IOREMAP ioremap_wc
+#else
+#define IOREMAP ioremap_nocache
+#endif
+
+extern int debug;
+
+#define BMA_LOG(level, fmt, args...) \
+	do { \
+		if (debug >= (level))\
+			netdev_alert(0, "edma: %s, %d, " fmt, \
+				__func__, __LINE__, ## args); \
+	} while (0)
+
+int edmainfo_show(char *buff);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c b/drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c
new file mode 100644
index 000000000000..2d5f4ffd79d9
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c
@@ -0,0 +1,1462 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/kthread.h>
+#include <linux/mm.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+#include "bma_pci.h"
+#include "edma_host.h"
+
+static struct edma_user_inft_s *g_user_func[TYPE_MAX] = { 0 };
+
+static struct bma_dev_s *g_bma_dev;
+static int edma_host_dma_interrupt(struct edma_host_s *edma_host);
+
+int edmainfo_show(char *buf)
+{
+	struct bma_user_s *user_ptr = NULL;
+	struct edma_host_s *host_ptr = NULL;
+	int len = 0;
+	__kernel_time_t running_time = 0;
+	static const char * const host_status[] = {
+		"deregistered",	"registered", "lost"};
+
+	if (!buf)
+		return 0;
+
+	if (!g_bma_dev) {
+		len += sprintf(buf, "EDMA IS NOT SUPPORTED");
+		return len;
+	}
+
+	host_ptr = &g_bma_dev->edma_host;
+
+	GET_SYS_SECONDS(running_time);
+	running_time -= host_ptr->statistics.init_time;
+	len += sprintf(buf + len,
+		    "============================EDMA_DRIVER_INFO============================\n");
+	len += sprintf(buf + len, "version      :" BMA_VERSION "\n");
+
+	len += sprintf(buf + len, "running_time :%luD %02lu:%02lu:%02lu\n",
+		    running_time / SECONDS_PER_DAY,
+		    running_time % SECONDS_PER_DAY / SECONDS_PER_HOUR,
+		    running_time % SECONDS_PER_HOUR / SECONDS_PER_MINUTE,
+		    running_time % SECONDS_PER_MINUTE);
+
+	len += sprintf(buf + len, "remote_status:%s\n",
+		    host_status[host_ptr->statistics.remote_status]);
+	len += sprintf(buf + len, "lost_count   :%d\n",
+		    host_ptr->statistics.lost_count);
+	len += sprintf(buf + len, "b2h_int      :%d\n",
+		    host_ptr->statistics.b2h_int);
+	len += sprintf(buf + len, "h2b_int      :%d\n",
+		    host_ptr->statistics.h2b_int);
+	len += sprintf(buf + len, "dma_count    :%d\n",
+		    host_ptr->statistics.dma_count);
+	len += sprintf(buf + len, "recv_bytes   :%d\n",
+		    host_ptr->statistics.recv_bytes);
+	len += sprintf(buf + len, "send_bytes   :%d\n",
+		    host_ptr->statistics.send_bytes);
+	len += sprintf(buf + len, "recv_pkgs    :%d\n",
+		    host_ptr->statistics.recv_pkgs);
+	len += sprintf(buf + len, "send_pkgs    :%d\n",
+		    host_ptr->statistics.send_pkgs);
+	len += sprintf(buf + len, "drop_pkgs    :%d\n",
+		    host_ptr->statistics.drop_pkgs);
+	len += sprintf(buf + len, "fail_count   :%d\n",
+		    host_ptr->statistics.failed_count);
+	len += sprintf(buf + len, "debug        :%d\n", debug);
+	len += sprintf(buf + len,
+		    "================================USER_INFO===============================\n");
+
+	list_for_each_entry_rcu(user_ptr, &g_bma_dev->priv_list, link) {
+		len += sprintf(buf + len,
+			    "type: %d\nsub type: %d\nopen:%d\nmax recvmsg nums: %d\ncur recvmsg nums: %d\n",
+			    user_ptr->type, user_ptr->sub_type,
+			    host_ptr->local_open_status[user_ptr->type],
+			    user_ptr->max_recvmsg_nums,
+			    user_ptr->cur_recvmsg_nums);
+		len += sprintf(buf + len,
+			    "========================================================================\n");
+	}
+
+	return len;
+}
+
+int is_edma_b2h_int(struct edma_host_s *edma_host)
+{
+	struct notify_msg *pnm = NULL;
+
+	if (!edma_host)
+		return -1;
+
+	pnm = (struct notify_msg *)edma_host->edma_flag;
+	if (!pnm) {
+		BMA_LOG(DLOG_ERROR, "pnm is 0\n");
+		return -1;
+	}
+
+	if (IS_EDMA_B2H_INT(pnm->int_flag)) {
+		CLEAR_EDMA_B2H_INT(pnm->int_flag);
+		return 0;
+	}
+
+	return -1;
+}
+
+void edma_int_to_bmc(struct edma_host_s *edma_host)
+{
+	unsigned int data = 0;
+
+	if (!edma_host)
+		return;
+
+	edma_host->statistics.h2b_int++;
+
+	data = *(unsigned int *)((char *)edma_host->hostrtc_viraddr +
+							 HOSTRTC_INT_OFFSET);
+
+	data |= 0x00000001;
+
+	*(unsigned int *)((char *)edma_host->hostrtc_viraddr +
+					  HOSTRTC_INT_OFFSET) = data;
+}
+
+static void edma_host_int_to_bmc(struct edma_host_s *edma_host)
+{
+	struct notify_msg *pnm = NULL;
+
+	if (!edma_host)
+		return;
+
+	pnm = (struct notify_msg *)edma_host->edma_flag;
+	if (pnm) {
+		SET_EDMA_H2B_INT(pnm->int_flag);
+		edma_int_to_bmc(edma_host);
+	}
+}
+
+static int check_status_dmah2b(struct edma_host_s *edma_host)
+{
+	unsigned int data = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return 0;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return 0;
+
+	(void)pci_read_config_dword(pdev, REG_PCIE1_DMAREAD_STATUS,
+				    (u32 *)&data);
+
+	if (data & (1 << SHIFT_PCIE1_DMAREAD_STATUS))
+		return 1;	/* ok */
+	else
+		return 0;	/* busy */
+}
+
+static int check_status_dmab2h(struct edma_host_s *edma_host)
+{
+	unsigned int data = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return 0;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return 0;
+
+	(void)pci_read_config_dword(pdev, REG_PCIE1_DMAWRITE_STATUS,
+				    (u32 *)&data);
+
+	if (data & (1 << SHIFT_PCIE1_DMAWRITE_STATUS))
+		return 1;	/* ok */
+	else
+		return 0;	/* busy */
+}
+
+void clear_int_dmah2b(struct edma_host_s *edma_host)
+{
+	unsigned int data = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return;
+
+	(void)pci_read_config_dword(pdev, REG_PCIE1_DMAREADINT_CLEAR,
+				    (u32 *)&data);
+	data = data & (~((1 << SHIFT_PCIE1_DMAREADINT_CLEAR)));
+	data = data | (1 << SHIFT_PCIE1_DMAREADINT_CLEAR);
+	(void)pci_write_config_dword(pdev, REG_PCIE1_DMAREADINT_CLEAR, data);
+}
+
+void clear_int_dmab2h(struct edma_host_s *edma_host)
+{
+	unsigned int data = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return;
+
+	(void)pci_read_config_dword(pdev, REG_PCIE1_DMAWRITEINT_CLEAR,
+				    (u32 *)&data);
+	data = data & (~((1 << SHIFT_PCIE1_DMAWRITEINT_CLEAR)));
+	data = data | (1 << SHIFT_PCIE1_DMAWRITEINT_CLEAR);
+	(void)pci_write_config_dword(pdev, REG_PCIE1_DMAWRITEINT_CLEAR, data);
+}
+
+int edma_host_check_dma_status(enum dma_direction_e dir)
+{
+	int ret = 0;
+
+	switch (dir) {
+	case BMC_TO_HOST:
+		ret = check_status_dmab2h(&g_bma_dev->edma_host);
+		if (ret == 1)
+			clear_int_dmab2h(&g_bma_dev->edma_host);
+
+		break;
+
+	case HOST_TO_BMC:
+		ret = check_status_dmah2b(&g_bma_dev->edma_host);
+		if (ret == 1)
+			clear_int_dmah2b(&g_bma_dev->edma_host);
+
+		break;
+
+	default:
+		BMA_LOG(DLOG_ERROR, "direction failed, dir = %d\n", dir);
+		ret = -EFAULT;
+		break;
+	}
+
+	return ret;
+}
+
+#ifdef USE_DMA
+
+static int start_transfer_h2b(struct edma_host_s *edma_host, unsigned int len,
+			      unsigned int src_h, unsigned int src_l,
+			      unsigned int dst_h, unsigned int dst_l)
+{
+	unsigned long flags = 0;
+	struct pci_dev *pdev = edma_host->pdev;
+
+	spin_lock_irqsave(&edma_host->reg_lock, flags);
+	/*  read engine enable    */
+	(void)pci_write_config_dword(pdev, 0x99c, 0x00000001);
+	/*  read ch,ch index 0   */
+	(void)pci_write_config_dword(pdev, 0xa6c, 0x80000000);
+	/*  ch ctrl,local int enable */
+	(void)pci_write_config_dword(pdev, 0xa70, 0x00000008);
+	/*  size    */
+	(void)pci_write_config_dword(pdev, 0xa78, len);
+	/*  src lower 32b    */
+	(void)pci_write_config_dword(pdev, 0xa7c, src_l);
+	/*  src upper 32b    */
+	(void)pci_write_config_dword(pdev, 0xa80, src_h);
+	/*  dst lower 32b    */
+	(void)pci_write_config_dword(pdev, 0xa84, dst_l);
+	/*  dst upper 32b    */
+	(void)pci_write_config_dword(pdev, 0xa88, dst_h);
+	/*  start read dma,ch 0   */
+	(void)pci_write_config_dword(pdev, 0x9a0, 0x00000000);
+	spin_unlock_irqrestore(&edma_host->reg_lock, flags);
+	return 0;
+}
+
+static int start_transfer_b2h(struct edma_host_s *edma_host, unsigned int len,
+			      unsigned int src_h, unsigned int src_l,
+			      unsigned int dst_h, unsigned int dst_l)
+{
+	unsigned long flags = 0;
+	struct pci_dev *pdev = edma_host->pdev;
+
+	BMA_LOG(DLOG_DEBUG,
+		"len = 0x%8x,src_h = 0x%8x,src_l = 0x%8x,dst_h = 0x%8x,dst_l = 0x%8x\n",
+		len, src_h, src_l, dst_h, dst_l);
+
+	spin_lock_irqsave(&edma_host->reg_lock, flags);
+	/*  write engine enable    */
+	(void)pci_write_config_dword(pdev, 0x97c, 0x00000001);
+	/*  write ch,ch index 0   */
+	(void)pci_write_config_dword(pdev, 0xa6c, 0x00000000);
+	/*  ch ctrl,local int enable */
+	(void)pci_write_config_dword(pdev, 0xa70, 0x00000008);
+	/*  size    */
+	(void)pci_write_config_dword(pdev, 0xa78, len);
+	/*  src lower 32b    */
+	(void)pci_write_config_dword(pdev, 0xa7c, src_l);
+	/*  src upper 32b    */
+	(void)pci_write_config_dword(pdev, 0xa80, src_h);
+	/*  dst lower 32b    */
+	(void)pci_write_config_dword(pdev, 0xa84, dst_l);
+	/*  dst upper 32b    */
+	(void)pci_write_config_dword(pdev, 0xa88, dst_h);
+	/*  start write dma,ch 0   */
+	(void)pci_write_config_dword(pdev, 0x980, 0x00000000);
+	spin_unlock_irqrestore(&edma_host->reg_lock, flags);
+
+	return 0;
+}
+#endif
+
+static void start_listtransfer_h2b(struct edma_host_s *edma_host,
+				   unsigned int list_h, unsigned int list_l)
+{
+	unsigned long flags = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return;
+
+	spin_lock_irqsave(&edma_host->reg_lock, flags);
+
+	/*  write engine enable    */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x29c, 0x00000001);
+	/*  write list err enable   */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x334, 0x00010000);
+	/*  write ch,ch index 0   */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x36c, 0x80000000);
+	/*  ch ctrl,local int enable */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x370, 0x00000300);
+	/*  list lower 32b    */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x38c, list_l);
+	/*  list upper 32b    */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x390, list_h);
+	/*  start write dma,ch 0   */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x2a0, 0x00000000);
+
+	spin_unlock_irqrestore(&edma_host->reg_lock, flags);
+}
+
+static void start_listtransfer_b2h(struct edma_host_s *edma_host,
+				   unsigned int list_h, unsigned int list_l)
+{
+	unsigned long flags = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return;
+
+	spin_lock_irqsave(&edma_host->reg_lock, flags);
+
+	/*  write engine enable    */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x27c, 0x00000001);
+	/*  write list err enable   */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x300, 0x00000001);
+	/*  write ch,ch index 0   */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x36c, 0x00000000);
+	/*  ch ctrl,local int enable */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x370, 0x00000300);
+	/*  list lower 32b    */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x38c, list_l);
+	/*  list upper 32b    */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x390, list_h);
+	/*  start write dma,ch 0   */
+	(void)pci_write_config_dword(pdev, 0x700 + 0x280, 0x00000000);
+
+	spin_unlock_irqrestore(&edma_host->reg_lock, flags);
+}
+
+int edma_host_dma_start(struct edma_host_s *edma_host,
+			struct bma_priv_data_s *priv)
+{
+	struct bma_user_s *puser = NULL;
+	struct bma_dev_s *bma_dev = NULL;
+	unsigned long flags = 0;
+
+	if (!edma_host || !priv)
+		return -EFAULT;
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+
+	spin_lock_irqsave(&bma_dev->priv_list_lock, flags);
+
+	list_for_each_entry_rcu(puser, &bma_dev->priv_list, link) {
+		if (puser->dma_transfer) {
+			spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+			BMA_LOG(DLOG_ERROR, "type = %d dma is started\n",
+				puser->type);
+
+			return -EBUSY;
+		}
+	}
+
+	priv->user.dma_transfer = 1;
+
+	spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+
+	return 0;
+}
+
+#ifdef USE_DMA
+
+static int edma_host_dma_h2b(struct edma_host_s *edma_host,
+			     struct bma_dma_addr_s *host_addr,
+			     struct bma_dma_addr_s *bmc_addr)
+{
+	int ret = 0;
+	struct notify_msg *pnm = (struct notify_msg *)edma_host->edma_flag;
+	unsigned long host_h2b_addr = 0;
+	unsigned long bmc_h2b_addr = 0;
+	unsigned int bmc_h2b_size = 0;
+	unsigned int src_h, src_l, dst_h, dst_l;
+
+	if (!host_addr) {
+		BMA_LOG(DLOG_ERROR, "host_addr is NULL\n");
+		return -EFAULT;
+	}
+
+	BMA_LOG(DLOG_DEBUG, "host_addr->dma_addr = 0x%llx\n",
+		host_addr->dma_addr);
+
+	if (host_addr->dma_addr)
+		host_h2b_addr = (unsigned long)(host_addr->dma_addr);
+	else
+		host_h2b_addr = edma_host->h2b_addr.dma_addr;
+
+	bmc_h2b_addr = pnm->h2b_addr;
+	bmc_h2b_size = pnm->h2b_size;
+
+	BMA_LOG(DLOG_DEBUG,
+		"host_h2b_addr = 0x%lx, dma_data_len = %d, bmc_h2b_addr = 0x%lx, bmc_h2b_size = %d\n",
+		host_h2b_addr, host_addr->dma_data_len, bmc_h2b_addr,
+		bmc_h2b_size);
+
+	if (host_addr->dma_data_len > EDMA_DMABUF_SIZE ||
+	    bmc_h2b_addr == 0 ||
+	    host_addr->dma_data_len > bmc_h2b_size) {
+		BMA_LOG(DLOG_ERROR,
+			"dma_data_len too large = %d, bmc_h2b_size = %d\n",
+			host_addr->dma_data_len, bmc_h2b_size);
+		return -EFAULT;
+	}
+
+	edma_host->h2b_state = H2BSTATE_WAITDMA;
+
+	src_h = (unsigned int)((sizeof(unsigned long) == 8) ?
+					(host_h2b_addr >> 32) : 0);
+	src_l = (unsigned int)(host_h2b_addr & 0xffffffff);
+	dst_h = (unsigned int)((sizeof(unsigned long) == 8) ?
+					(bmc_h2b_addr >> 32) : 0);
+	dst_l = (unsigned int)(bmc_h2b_addr & 0xffffffff);
+	(void)start_transfer_h2b(edma_host,
+		host_addr->dma_data_len, src_h,
+		src_l, dst_h, dst_l);
+
+	(void)mod_timer(&edma_host->dma_timer,
+			jiffies_64 + TIMER_INTERVAL_CHECK);
+
+	ret = wait_event_interruptible_timeout(edma_host->wq_dmah2b,
+					       (edma_host->h2b_state ==
+					      H2BSTATE_IDLE),
+					     EDMA_DMA_TRANSFER_WAIT_TIMEOUT);
+
+	if (ret == -ERESTARTSYS) {
+		BMA_LOG(DLOG_ERROR, "eintr 1\n");
+		ret = -EINTR;
+		goto end;
+	} else if (ret == 0) {
+		BMA_LOG(DLOG_ERROR, "timeout 2\n");
+		ret = -ETIMEDOUT;
+		goto end;
+	} else {
+		ret = 0;
+		BMA_LOG(DLOG_ERROR, "h2b dma successful\n");
+	}
+
+end:
+
+	return ret;
+}
+
+static int edma_host_dma_b2h(struct edma_host_s *edma_host,
+			     struct bma_dma_addr_s *host_addr,
+			     struct bma_dma_addr_s *bmc_addr)
+{
+	int ret = 0;
+	struct notify_msg *pnm = (struct notify_msg *)edma_host->edma_flag;
+	unsigned long bmc_b2h_addr = 0;
+	unsigned long host_b2h_addr = 0;
+	unsigned int src_h, src_l, dst_h, dst_l;
+
+	if (!bmc_addr)
+		return -EFAULT;
+
+	if (host_addr->dma_addr)
+		host_b2h_addr = (unsigned long)(host_addr->dma_addr);
+	else
+		host_b2h_addr = edma_host->b2h_addr.dma_addr;
+
+	if (bmc_addr->dma_addr)
+		bmc_b2h_addr = (unsigned long)(bmc_addr->dma_addr);
+	else
+		bmc_b2h_addr = pnm->b2h_addr;
+
+	BMA_LOG(DLOG_DEBUG,
+		"bmc_b2h_addr = 0x%lx, host_b2h_addr = 0x%lx, dma_data_len = %d\n",
+		bmc_b2h_addr, host_b2h_addr, bmc_addr->dma_data_len);
+
+	if (bmc_addr->dma_data_len > EDMA_DMABUF_SIZE ||
+	    bmc_addr->dma_data_len > edma_host->b2h_addr.len) {
+		BMA_LOG(DLOG_ERROR,
+			"dma_data_len too large = %d, b2h_addr = %d\n",
+			host_addr->dma_data_len, edma_host->b2h_addr.len);
+		return -EFAULT;
+	}
+
+	edma_host->b2h_state = B2HSTATE_WAITDMA;
+
+	src_h = (unsigned int)((sizeof(unsigned long) == 8) ?
+					(bmc_b2h_addr >> 32) : 0);
+	src_l = (unsigned int)(bmc_b2h_addr & 0xffffffff);
+	dst_h = (unsigned int)((sizeof(unsigned long) == 8) ?
+					(host_b2h_addr >> 32) : 0);
+	dst_l = (unsigned int)(host_b2h_addr & 0xffffffff);
+	(void)start_transfer_b2h(edma_host,
+		bmc_addr->dma_data_len, src_h,
+		src_l, dst_h, dst_l);
+
+	(void)mod_timer(&edma_host->dma_timer,
+			jiffies_64 + TIMER_INTERVAL_CHECK);
+
+	ret = wait_event_interruptible_timeout(edma_host->wq_dmab2h,
+					       (edma_host->b2h_state ==
+					      B2HSTATE_IDLE),
+					     EDMA_DMA_TRANSFER_WAIT_TIMEOUT);
+
+	if (ret == -ERESTARTSYS) {
+		BMA_LOG(DLOG_ERROR, "eintr 1\n");
+		ret = -EINTR;
+		goto end;
+	} else if (ret == 0) {
+		BMA_LOG(DLOG_ERROR, "timeout 2\n");
+		ret = -ETIMEDOUT;
+		goto end;
+	} else {
+		BMA_LOG(DLOG_DEBUG, "h2b dma successful\n");
+	}
+
+end:
+
+	return ret;
+}
+#endif
+
+void host_dma_transfer_without_list(struct edma_host_s *edma_host,
+				    struct bma_dma_transfer_s *dma_transfer,
+					int *return_code)
+{
+#ifdef USE_DMA
+	union transfer_u *transfer = &dma_transfer->transfer;
+
+	switch (dma_transfer->dir) {
+	case BMC_TO_HOST:
+		*return_code = edma_host_dma_b2h(edma_host,
+						 &transfer->nolist.host_addr,
+						 &transfer->nolist.bmc_addr);
+		break;
+	case HOST_TO_BMC:
+		*return_code = edma_host_dma_h2b(edma_host,
+						 &transfer->nolist.host_addr,
+						 &transfer->nolist.bmc_addr);
+		break;
+	default:
+		BMA_LOG(DLOG_ERROR, "direction failed, dir = %d\n",
+			dma_transfer->dir);
+		*return_code = -EFAULT;
+		break;
+	}
+#endif
+}
+
+void host_dma_transfer_withlist(struct edma_host_s *edma_host,
+				struct bma_dma_transfer_s *dma_transfer,
+					int *return_code)
+{
+	unsigned int list_h = 0;
+	unsigned int list_l = 0;
+	union transfer_u *transfer = &dma_transfer->transfer;
+
+	list_h = (unsigned int)((sizeof(unsigned long) == 8) ?
+			(transfer->list.dma_addr >> 32) : 0);
+	list_l = (unsigned int)(transfer->list.dma_addr
+				& 0xffffffff);
+
+	switch (dma_transfer->dir) {
+	case BMC_TO_HOST:
+		start_listtransfer_b2h(edma_host, list_h, list_l);
+		break;
+	case HOST_TO_BMC:
+		start_listtransfer_h2b(edma_host, list_h, list_l);
+		break;
+	default:
+		BMA_LOG(DLOG_ERROR, "direction failed, dir = %d\n\n",
+			dma_transfer->dir);
+		*return_code = -EFAULT;
+		break;
+	}
+}
+
+int edma_host_dma_transfer(struct edma_host_s *edma_host,
+			   struct bma_priv_data_s *priv,
+			   struct bma_dma_transfer_s *dma_transfer)
+{
+	int ret = 0;
+	unsigned long flags = 0;
+	struct bma_dev_s *bma_dev = NULL;
+
+	if (!edma_host || !priv || !dma_transfer)
+		return -EFAULT;
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+
+	spin_lock_irqsave(&bma_dev->priv_list_lock, flags);
+
+	if (priv->user.dma_transfer == 0) {
+		spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+		BMA_LOG(DLOG_ERROR, "dma_transfer = %hhd\n",
+			priv->user.dma_transfer);
+		return -EFAULT;
+	}
+
+	spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+
+	edma_host->statistics.dma_count++;
+
+	if (dma_transfer->type == DMA_NOT_LIST) {
+		host_dma_transfer_without_list(edma_host,
+					       dma_transfer, &ret);
+	} else if (dma_transfer->type == DMA_LIST) {
+		host_dma_transfer_withlist(edma_host, dma_transfer, &ret);
+	} else {
+		BMA_LOG(DLOG_ERROR, "type failed! type = %d\n",
+			dma_transfer->type);
+		return -EFAULT;
+	}
+
+	return ret;
+}
+
+void edma_host_reset_dma(struct edma_host_s *edma_host, int dir)
+{
+	u32 data = 0;
+	u32 reg_addr = 0;
+	unsigned long flags = 0;
+	int count = 0;
+	struct pci_dev *pdev = NULL;
+
+	if (!edma_host)
+		return;
+
+	pdev = edma_host->pdev;
+	if (!pdev)
+		return;
+
+	if (dir == BMC_TO_HOST)
+		reg_addr = REG_PCIE1_DMA_READ_ENGINE_ENABLE;
+	else if (dir == HOST_TO_BMC)
+		reg_addr = REG_PCIE1_DMA_WRITE_ENGINE_ENABLE;
+	else
+		return;
+
+	spin_lock_irqsave(&edma_host->reg_lock, flags);
+
+	(void)pci_read_config_dword(pdev, reg_addr, &data);
+	data &= ~(1 << SHIFT_PCIE1_DMA_ENGINE_ENABLE);
+	(void)pci_write_config_dword(pdev, reg_addr, data);
+
+	while (count++ < 10) {
+		(void)pci_read_config_dword(pdev, reg_addr, &data);
+
+		if (0 == (data & (1 << SHIFT_PCIE1_DMA_ENGINE_ENABLE))) {
+			BMA_LOG(DLOG_DEBUG, "reset dma succesfull\n");
+			break;
+		}
+
+		mdelay(100);
+	}
+
+	spin_unlock_irqrestore(&edma_host->reg_lock, flags);
+	BMA_LOG(DLOG_DEBUG, "reset dma reg_addr=0x%x count=%d data=0x%08x\n",
+		reg_addr, count, data);
+}
+
+int edma_host_dma_stop(struct edma_host_s *edma_host,
+		       struct bma_priv_data_s *priv)
+{
+	unsigned long flags = 0;
+	struct bma_dev_s *bma_dev = NULL;
+
+	if (!edma_host || !priv)
+		return -1;
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+
+	spin_lock_irqsave(&bma_dev->priv_list_lock, flags);
+	priv->user.dma_transfer = 0;
+	spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+
+	return 0;
+}
+
+static int edma_host_send_msg(struct edma_host_s *edma_host)
+{
+	void *vaddr = NULL;
+	unsigned long flags = 0;
+	struct edma_mbx_hdr_s *send_mbx_hdr = NULL;
+	static unsigned long last_timer_record;
+
+	if (!edma_host)
+		return 0;
+
+	send_mbx_hdr = (struct edma_mbx_hdr_s *)edma_host->edma_send_addr;
+
+	if (send_mbx_hdr->mbxlen > 0) {
+		if (send_mbx_hdr->mbxlen > HOST_MAX_SEND_MBX_LEN) {
+			/*share memory is disable */
+			send_mbx_hdr->mbxlen = 0;
+			BMA_LOG(DLOG_ERROR, "mbxlen is too long\n");
+			return -EFAULT;
+		}
+
+		if (time_after(jiffies, last_timer_record + 10 * HZ)) {
+			BMA_LOG(DLOG_ERROR, "no response in 10s,clean msg\n");
+			edma_host->statistics.failed_count++;
+			send_mbx_hdr->mbxlen = 0;
+			return -EFAULT;
+		}
+
+		BMA_LOG(DLOG_DEBUG,
+			"still have msg : mbxlen: %d, msg_send_write: %d\n",
+			send_mbx_hdr->mbxlen, edma_host->msg_send_write);
+
+		/*  resend door bell */
+		if (time_after(jiffies, last_timer_record + 5 * HZ))
+			edma_host_int_to_bmc(edma_host);
+
+		return -EFAULT;
+	}
+
+	vaddr =
+		(void *)((unsigned char *)edma_host->edma_send_addr +
+			 SIZE_OF_MBX_HDR);
+
+	last_timer_record = jiffies;
+
+	spin_lock_irqsave(&edma_host->send_msg_lock, flags);
+
+	if (edma_host->msg_send_write == 0) {
+		spin_unlock_irqrestore(&edma_host->send_msg_lock, flags);
+		return 0;
+	}
+
+	if (edma_host->msg_send_write >
+	    HOST_MAX_SEND_MBX_LEN - SIZE_OF_MBX_HDR) {
+		BMA_LOG(DLOG_ERROR,
+			"Length of send message %u is larger than %lu\n",
+			edma_host->msg_send_write,
+			HOST_MAX_SEND_MBX_LEN - SIZE_OF_MBX_HDR);
+		edma_host->msg_send_write = 0;
+		spin_unlock_irqrestore(&edma_host->send_msg_lock, flags);
+		return 0;
+	}
+
+	memcpy(vaddr, edma_host->msg_send_buf,
+	       edma_host->msg_send_write);
+
+	send_mbx_hdr->mbxlen = edma_host->msg_send_write;
+	edma_host->msg_send_write = 0;
+
+	spin_unlock_irqrestore(&edma_host->send_msg_lock, flags);
+
+	edma_host_int_to_bmc(edma_host);
+
+	BMA_LOG(DLOG_DEBUG,
+		"vaddr: %p, mbxlen : %d, msg_send_write: %d\n", vaddr,
+		send_mbx_hdr->mbxlen, edma_host->msg_send_write);
+
+	return -EAGAIN;
+}
+
+#ifdef EDMA_TIMER
+#ifdef HAVE_TIMER_SETUP
+static void edma_host_timeout(struct timer_list *t)
+{
+	struct edma_host_s *edma_host = from_timer(edma_host, t, timer);
+#else
+static void edma_host_timeout(unsigned long data)
+{
+	struct edma_host_s *edma_host = (struct edma_host_s *)data;
+#endif
+	int ret = 0;
+	unsigned long flags = 0;
+
+	ret = edma_host_send_msg(edma_host);
+	if (ret < 0) {
+		spin_lock_irqsave(&g_bma_dev->edma_host.send_msg_lock, flags);
+		(void)mod_timer(&edma_host->timer,
+				jiffies_64 + TIMER_INTERVAL_CHECK);
+		spin_unlock_irqrestore(&edma_host->send_msg_lock, flags);
+	}
+}
+
+#ifdef HAVE_TIMER_SETUP
+static void edma_host_heartbeat_timer(struct timer_list *t)
+{
+	struct edma_host_s *edma_host = from_timer(edma_host, t,
+						    heartbeat_timer);
+#else
+static void edma_host_heartbeat_timer(unsigned long data)
+{
+	struct edma_host_s *edma_host = (struct edma_host_s *)data;
+#endif
+	struct edma_statistics_s *edma_stats = &edma_host->statistics;
+	unsigned int *remote_status = &edma_stats->remote_status;
+	static unsigned int bmc_heartbeat;
+	struct notify_msg *pnm = (struct notify_msg *)edma_host->edma_flag;
+
+	if (pnm) {
+		if (pnm->bmc_registered) {
+			if ((pnm->host_heartbeat & 7) == 0) {
+				if (bmc_heartbeat != pnm->bmc_heartbeat) {
+					if (*remote_status != REGISTERED) {
+						BMA_LOG(DLOG_DEBUG,
+							"bmc is registered\n");
+						*remote_status = REGISTERED;
+					}
+
+					bmc_heartbeat = pnm->bmc_heartbeat;
+				} else {
+					if (*remote_status == REGISTERED) {
+						*remote_status = LOST;
+						edma_stats->lost_count++;
+						BMA_LOG(DLOG_DEBUG,
+							"bmc is lost\n");
+					}
+				}
+			}
+		} else {
+			if (*remote_status == REGISTERED)
+				BMA_LOG(DLOG_DEBUG, "bmc is deregistered\n");
+
+			*remote_status = DEREGISTERED;
+		}
+
+		pnm->host_heartbeat++;
+	}
+
+	(void)mod_timer(&edma_host->heartbeat_timer,
+			jiffies_64 + HEARTBEAT_TIMER_INTERVAL_CHECK);
+}
+
+#ifdef USE_DMA
+#ifdef HAVE_TIMER_SETUP
+static void edma_host_dma_timeout(struct timer_list *t)
+{
+	struct edma_host_s *edma_host = from_timer(edma_host, t, dma_timer);
+#else
+static void edma_host_dma_timeout(unsigned long data)
+{
+	struct edma_host_s *edma_host = (struct edma_host_s *)data;
+#endif
+	int ret = 0;
+
+	ret = edma_host_dma_interrupt(edma_host);
+	if (ret < 0)
+		(void)mod_timer(&edma_host->dma_timer,
+				jiffies_64 + DMA_TIMER_INTERVAL_CHECK);
+}
+#endif
+#else
+
+static int edma_host_thread(void *arg)
+{
+	struct edma_host_s *edma_host = (struct edma_host_s *)arg;
+
+	BMA_LOG(DLOG_ERROR, "edma host thread\n");
+
+	while (!kthread_should_stop()) {
+		wait_for_completion_interruptible_timeout(&edma_host->msg_ready,
+							  1 * HZ);
+		edma_host_send_msg(edma_host);
+		(void)edma_host_dma_interrupt(edma_host);
+	}
+
+	BMA_LOG(DLOG_ERROR, "edma host thread exiting\n");
+
+	return 0;
+}
+
+#endif
+
+int edma_host_send_driver_msg(const void *msg, size_t msg_len, int subtype)
+{
+	int ret = 0;
+	unsigned long flags = 0;
+	struct edma_host_s *edma_host = NULL;
+	struct edma_msg_hdr_s *hdr = NULL;
+	int total_len = msg_len + SIZE_OF_MSG_HDR;
+
+	if (!msg || !g_bma_dev)
+		return -1;
+
+	edma_host = &g_bma_dev->edma_host;
+	if (!edma_host)
+		return -1;
+
+	spin_lock_irqsave(&edma_host->send_msg_lock, flags);
+
+	if (edma_host->msg_send_write + total_len <=
+	    (HOST_MAX_SEND_MBX_LEN - SIZE_OF_MBX_HDR)) {
+		hdr = (struct edma_msg_hdr_s *)(edma_host->msg_send_buf +
+					      edma_host->msg_send_write);
+		hdr->type = TYPE_EDMA_DRIVER;
+		hdr->sub_type = subtype;
+		hdr->datalen = msg_len;
+
+		memcpy(hdr->data, msg, msg_len);
+
+		edma_host->msg_send_write += total_len;
+
+		spin_unlock_irqrestore(&edma_host->send_msg_lock, flags);
+
+		(void)mod_timer(&edma_host->timer, jiffies_64);
+		BMA_LOG(DLOG_DEBUG, "msg_send_write = %d\n",
+			edma_host->msg_send_write);
+	} else {
+		ret = -ENOSPC;
+		spin_unlock_irqrestore(&edma_host->send_msg_lock, flags);
+
+		BMA_LOG(DLOG_DEBUG,
+			"msg lost,msg_send_write: %d,msg_len:%d,max_len: %d\n",
+			edma_host->msg_send_write, total_len,
+			HOST_MAX_SEND_MBX_LEN);
+	}
+
+	return ret;
+}
+
+static int edma_host_insert_recv_msg(struct edma_host_s *edma_host,
+				     struct edma_msg_hdr_s *msg_header)
+{
+	unsigned long flags = 0, msg_flags = 0;
+	struct bma_dev_s *bma_dev = NULL;
+	struct bma_priv_data_s *priv = NULL;
+	struct bma_user_s *puser = NULL;
+	struct list_head *entry = NULL;
+	struct edma_recv_msg_s *msg_tmp = NULL;
+	struct bma_user_s usertmp = { };
+	struct edma_recv_msg_s *recv_msg = NULL;
+
+	if (!edma_host || !msg_header ||
+	    msg_header->datalen > CDEV_MAX_WRITE_LEN) {
+		return -EFAULT;
+	}
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+
+	recv_msg = kmalloc(sizeof(*recv_msg) + msg_header->datalen, GFP_ATOMIC);
+	if (!recv_msg) {
+		BMA_LOG(DLOG_ERROR, "malloc recv_msg failed\n");
+		return -ENOMEM;
+	}
+
+	recv_msg->msg_len = msg_header->datalen;
+	memcpy(recv_msg->msg_data, msg_header->data,
+	       msg_header->datalen);
+
+	spin_lock_irqsave(&bma_dev->priv_list_lock, flags);
+	list_for_each_entry_rcu(puser, &bma_dev->priv_list, link) {
+		if (puser->type != msg_header->type ||
+		    puser->sub_type != msg_header->sub_type)
+			continue;
+
+		priv = list_entry(puser, struct bma_priv_data_s, user);
+
+		memcpy(&usertmp, puser,
+		       sizeof(struct bma_user_s));
+
+		spin_lock_irqsave(&priv->recv_msg_lock, msg_flags);
+
+		if (puser->cur_recvmsg_nums >= puser->max_recvmsg_nums ||
+		    puser->cur_recvmsg_nums >= MAX_RECV_MSG_NUMS) {
+			entry = priv->recv_msgs.next;
+			msg_tmp =
+			    list_entry(entry, struct edma_recv_msg_s,
+				       link);
+			list_del(entry);
+			puser->cur_recvmsg_nums--;
+			kfree(msg_tmp);
+		}
+
+		if (edma_host->local_open_status[puser->type]
+			== DEV_OPEN) {
+			list_add_tail(&recv_msg->link, &priv->recv_msgs);
+			puser->cur_recvmsg_nums++;
+			usertmp.cur_recvmsg_nums =
+			    puser->cur_recvmsg_nums;
+			spin_unlock_irqrestore(&priv->recv_msg_lock,
+					       msg_flags);
+
+		} else {
+			spin_unlock_irqrestore(&priv->recv_msg_lock,
+					       msg_flags);
+			break;
+		}
+
+		wake_up_interruptible(&priv->wait);
+		spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+
+		BMA_LOG(DLOG_DEBUG,
+			"find user, type = %d, sub_type = %d, user_id = %d, insert msg\n",
+			usertmp.type, usertmp.sub_type,
+			usertmp.user_id);
+		BMA_LOG(DLOG_DEBUG,
+			"msg_len = %d, cur_recvmsg_nums: %d, max_recvmsg_nums: %d\n",
+			recv_msg->msg_len, usertmp.cur_recvmsg_nums,
+			usertmp.max_recvmsg_nums);
+
+		return 0;
+	}
+
+	spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+	kfree(recv_msg);
+	edma_host->statistics.drop_pkgs++;
+	BMA_LOG(DLOG_DEBUG,
+		"insert msg failed! not find user, type = %d, sub_type = %d\n",
+		msg_header->type, msg_header->sub_type);
+
+	return -EFAULT;
+}
+
+int edma_host_recv_msg(struct edma_host_s *edma_host,
+		       struct bma_priv_data_s *priv,
+		       struct edma_recv_msg_s **msg)
+{
+	unsigned long flags = 0;
+	struct list_head *entry = NULL;
+	struct edma_recv_msg_s *msg_tmp = NULL;
+	struct bma_dev_s *bma_dev = NULL;
+
+	if (!edma_host || !priv || !msg)
+		return -EAGAIN;
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+
+	spin_lock_irqsave(&bma_dev->priv_list_lock, flags);
+
+	if (list_empty(&priv->recv_msgs)) {
+		priv->user.cur_recvmsg_nums = 0;
+		spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+		BMA_LOG(DLOG_DEBUG, "recv msgs empty\n");
+		return -EAGAIN;
+	}
+
+	entry = priv->recv_msgs.next;
+	msg_tmp = list_entry(entry, struct edma_recv_msg_s, link);
+	list_del(entry);
+
+	if (priv->user.cur_recvmsg_nums > 0)
+		priv->user.cur_recvmsg_nums--;
+
+	spin_unlock_irqrestore(&bma_dev->priv_list_lock, flags);
+
+	*msg = msg_tmp;
+
+	BMA_LOG(DLOG_DEBUG, "msg->msg_len = %d\n", (int)msg_tmp->msg_len);
+
+	return 0;
+}
+
+static int edma_host_msg_process(struct edma_host_s *edma_host,
+				 struct edma_msg_hdr_s *msg_header)
+{
+	struct bma_user_s *user_ptr = NULL;
+	char drv_msg[TYPE_MAX * 2 + 1] = { 0 };
+
+	if (!edma_host || !msg_header)
+		return 0;
+
+	if (msg_header->type != TYPE_EDMA_DRIVER)
+		return -1;
+
+	if (msg_header->sub_type != DEV_OPEN_STATUS_REQ)
+		return 0;
+
+	list_for_each_entry_rcu(user_ptr, &g_bma_dev->priv_list, link) {
+		drv_msg[drv_msg[0] * 2 + 1] = user_ptr->type;
+		drv_msg[drv_msg[0] * 2 + 2] =
+		    edma_host->local_open_status[user_ptr->type];
+		BMA_LOG(DLOG_DEBUG,
+			"send DEV_OPEN_STATUS_ANS index=%d type=%d status=%d\n",
+			drv_msg[0], drv_msg[drv_msg[0] * 2 + 1],
+			drv_msg[drv_msg[0] * 2 + 2]);
+		drv_msg[0]++;
+	}
+
+	if (drv_msg[0]) {
+		(void)edma_host_send_driver_msg((void *)drv_msg,
+						drv_msg[0] * 2 +
+						1,
+						DEV_OPEN_STATUS_ANS);
+		BMA_LOG(DLOG_DEBUG,
+			"send DEV_OPEN_STATUS_ANS %d\n",
+			drv_msg[0]);
+	}
+
+	return 0;
+}
+
+void edma_host_isr_tasklet(unsigned long data)
+{
+	int result = 0;
+	u16 len = 0;
+	u16 off = 0;
+	u16 msg_cnt = 0;
+	struct edma_mbx_hdr_s *recv_mbx_hdr = NULL;
+	struct edma_host_s *edma_host = (struct edma_host_s *)data;
+	struct edma_msg_hdr_s *msg_header = NULL;
+	unsigned char *ptr = NULL;
+
+	if (!edma_host)
+		return;
+
+	recv_mbx_hdr = (struct edma_mbx_hdr_s *)(edma_host->edma_recv_addr);
+	msg_header =
+		(struct edma_msg_hdr_s *)((char *)(edma_host->edma_recv_addr) +
+				SIZE_OF_MBX_HDR + recv_mbx_hdr->mbxoff);
+
+	off = readw((unsigned char *)edma_host->edma_recv_addr
+				+ EDMA_B2H_INT_FLAG);
+	len = readw((unsigned char *)edma_host->edma_recv_addr) - off;
+
+	BMA_LOG(DLOG_DEBUG,
+		" edma_host->edma_recv_addr = %p, len = %d, off = %d, mbxlen = %d\n",
+		edma_host->edma_recv_addr, len, off, recv_mbx_hdr->mbxlen);
+	edma_host->statistics.recv_bytes += (recv_mbx_hdr->mbxlen - off);
+
+	if (len == 0) {
+		writel(0, (void *)(edma_host->edma_recv_addr));
+		return;
+	}
+
+	while (recv_mbx_hdr->mbxlen - off) {
+		if (len == 0) {
+			BMA_LOG(DLOG_DEBUG, " receive done\n");
+			break;
+		}
+
+		if (len < (SIZE_OF_MSG_HDR + msg_header->datalen)) {
+			BMA_LOG(DLOG_ERROR, " len too less, is %d\n", len);
+			break;
+		}
+
+		edma_host->statistics.recv_pkgs++;
+
+		if (edma_host_msg_process(edma_host, msg_header) == -1) {
+			result = edma_host_insert_recv_msg(edma_host,
+							   msg_header);
+			if (result < 0)
+				BMA_LOG(DLOG_DEBUG,
+					"edma_host_insert_recv_msg failed\n");
+		}
+
+		BMA_LOG(DLOG_DEBUG, "len = %d\n", len);
+		BMA_LOG(DLOG_DEBUG, "off = %d\n", off);
+		len -= (msg_header->datalen + SIZE_OF_MSG_HDR);
+		BMA_LOG(DLOG_DEBUG,
+			"msg_header->datalen = %d, SIZE_OF_MSG_HDR=%d\n",
+			msg_header->datalen, (int)SIZE_OF_MSG_HDR);
+		off += (msg_header->datalen + SIZE_OF_MSG_HDR);
+
+		msg_cnt++;
+
+		ptr = (unsigned char *)msg_header;
+		msg_header = (struct edma_msg_hdr_s *)(ptr +
+					      (msg_header->datalen +
+					       SIZE_OF_MSG_HDR));
+
+		if (msg_cnt > 2) {
+			recv_mbx_hdr->mbxoff = off;
+			BMA_LOG(DLOG_DEBUG, "len = %d\n", len);
+			BMA_LOG(DLOG_DEBUG, "off = %d\n", off);
+			BMA_LOG(DLOG_DEBUG, "off works\n");
+
+			tasklet_hi_schedule(&edma_host->tasklet);
+
+			break;
+		}
+
+		if (!len) {
+			writel(0, (void *)(edma_host->edma_recv_addr));
+			recv_mbx_hdr->mbxoff = 0;
+		}
+	}
+}
+
+static int edma_host_dma_interrupt(struct edma_host_s *edma_host)
+{
+	if (!edma_host)
+		return 0;
+
+	if (check_status_dmah2b(edma_host)) {
+		clear_int_dmah2b(edma_host);
+
+		edma_host->h2b_state = H2BSTATE_IDLE;
+		wake_up_interruptible(&edma_host->wq_dmah2b);
+		return 0;
+	}
+
+	if (check_status_dmab2h(edma_host)) {
+		clear_int_dmab2h(edma_host);
+
+		edma_host->b2h_state = B2HSTATE_IDLE;
+		wake_up_interruptible(&edma_host->wq_dmab2h);
+
+		return 0;
+	}
+
+	return -EAGAIN;
+}
+
+irqreturn_t edma_host_irq_handle(struct edma_host_s *edma_host)
+{
+	if (edma_host) {
+		(void)edma_host_dma_interrupt(edma_host);
+
+		tasklet_hi_schedule(&edma_host->tasklet);
+	}
+
+	return IRQ_HANDLED;
+}
+
+struct edma_user_inft_s *edma_host_get_user_inft(u32 type)
+{
+	if (type >= TYPE_MAX) {
+		BMA_LOG(DLOG_ERROR, "type error %d\n", type);
+		return NULL;
+	}
+
+	return g_user_func[type];
+}
+
+int edma_host_user_register(u32 type, struct edma_user_inft_s *func)
+{
+	if (type >= TYPE_MAX) {
+		BMA_LOG(DLOG_ERROR, "type error %d\n", type);
+		return -EFAULT;
+	}
+
+	if (!func) {
+		BMA_LOG(DLOG_ERROR, "func is NULL\n");
+		return -EFAULT;
+	}
+
+	g_user_func[type] = func;
+
+	return 0;
+}
+
+int edma_host_user_unregister(u32 type)
+{
+	if (type >= TYPE_MAX) {
+		BMA_LOG(DLOG_ERROR, "type error %d\n", type);
+		return -EFAULT;
+	}
+
+	g_user_func[type] = NULL;
+
+	return 0;
+}
+
+int edma_host_init(struct edma_host_s *edma_host)
+{
+	int ret = 0;
+	struct bma_dev_s *bma_dev = NULL;
+	struct notify_msg *pnm = NULL;
+
+	if (!edma_host)
+		return -1;
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+	g_bma_dev = bma_dev;
+
+	edma_host->pdev = bma_dev->bma_pci_dev->pdev;
+
+#ifdef EDMA_TIMER
+	#ifdef HAVE_TIMER_SETUP
+		timer_setup(&edma_host->timer, edma_host_timeout, 0);
+	#else
+		setup_timer(&edma_host->timer, edma_host_timeout,
+			    (unsigned long)edma_host);
+	#endif
+	(void)mod_timer(&edma_host->timer, jiffies_64 + TIMER_INTERVAL_CHECK);
+#ifdef USE_DMA
+	#ifdef HAVE_TIMER_SETUP
+		timer_setup(&edma_host->dma_timer, edma_host_dma_timeout, 0);
+
+	#else
+		setup_timer(&edma_host->dma_timer, edma_host_dma_timeout,
+			    (unsigned long)edma_host);
+	#endif
+	(void)mod_timer(&edma_host->dma_timer,
+			jiffies_64 + DMA_TIMER_INTERVAL_CHECK);
+#endif
+
+#else
+	init_completion(&edma_host->msg_ready);
+
+	edma_host->edma_thread =
+	    kthread_run(edma_host_thread, (void *)edma_host, "edma_host_msg");
+
+	if (IS_ERR(edma_host->edma_thread)) {
+		BMA_LOG(DLOG_ERROR, "kernel_run  edma_host_msg failed\n");
+		return PTR_ERR(edma_host->edma_thread);
+	}
+#endif
+
+	edma_host->msg_send_buf = kmalloc(HOST_MAX_SEND_MBX_LEN, GFP_KERNEL);
+	if (!edma_host->msg_send_buf) {
+		BMA_LOG(DLOG_ERROR, "malloc msg_send_buf failed!");
+		ret = -ENOMEM;
+		goto failed1;
+	}
+
+	edma_host->msg_send_write = 0;
+
+	spin_lock_init(&edma_host->send_msg_lock);
+
+	tasklet_init(&edma_host->tasklet,
+		     (void (*)(unsigned long))edma_host_isr_tasklet,
+		     (unsigned long)edma_host);
+
+	edma_host->edma_flag = bma_dev->bma_pci_dev->edma_swap_addr;
+
+	edma_host->edma_send_addr =
+	    (void *)((unsigned char *)bma_dev->bma_pci_dev->edma_swap_addr +
+		     HOST_DMA_FLAG_LEN);
+	memset(edma_host->edma_send_addr, 0, SIZE_OF_MBX_HDR);
+
+	edma_host->edma_recv_addr =
+	    (void *)((unsigned char *)edma_host->edma_send_addr +
+		     HOST_MAX_SEND_MBX_LEN);
+
+	BMA_LOG(DLOG_DEBUG,
+		"edma_flag = %p, edma_send_addr = %p, edma_recv_addr = %p\n",
+		edma_host->edma_flag, edma_host->edma_send_addr,
+		edma_host->edma_recv_addr);
+
+	edma_host->hostrtc_viraddr = bma_dev->bma_pci_dev->hostrtc_viraddr;
+
+	init_waitqueue_head(&edma_host->wq_dmah2b);
+	init_waitqueue_head(&edma_host->wq_dmab2h);
+
+	spin_lock_init(&edma_host->reg_lock);
+
+	edma_host->h2b_state = H2BSTATE_IDLE;
+	edma_host->b2h_state = B2HSTATE_IDLE;
+
+	#ifdef HAVE_TIMER_SETUP
+		timer_setup(&edma_host->heartbeat_timer,
+			    edma_host_heartbeat_timer, 0);
+	#else
+		setup_timer(&edma_host->heartbeat_timer,
+			    edma_host_heartbeat_timer,
+			    (unsigned long)edma_host);
+	#endif
+	(void)mod_timer(&edma_host->heartbeat_timer,
+			jiffies_64 + HEARTBEAT_TIMER_INTERVAL_CHECK);
+
+	pnm = (struct notify_msg *)edma_host->edma_flag;
+	if (pnm)
+		pnm->host_registered = REGISTERED;
+
+	GET_SYS_SECONDS(edma_host->statistics.init_time);
+
+#ifdef EDMA_TIMER
+	BMA_LOG(DLOG_DEBUG, "timer ok\n");
+#else
+	BMA_LOG(DLOG_ERROR, "thread ok\n");
+#endif
+	return 0;
+
+failed1:
+#ifdef EDMA_TIMER
+	(void)del_timer_sync(&edma_host->timer);
+#ifdef USE_DMA
+	(void)del_timer_sync(&edma_host->dma_timer);
+#endif
+#else
+	kthread_stop(edma_host->edma_thread);
+	complete(&edma_host->msg_ready);
+#endif
+	return ret;
+}
+
+void edma_host_cleanup(struct edma_host_s *edma_host)
+{
+	struct bma_dev_s *bma_dev = NULL;
+	struct notify_msg *pnm = NULL;
+
+	if (!edma_host)
+		return;
+
+	bma_dev = list_entry(edma_host, struct bma_dev_s, edma_host);
+	(void)del_timer_sync(&edma_host->heartbeat_timer);
+	pnm = (struct notify_msg *)edma_host->edma_flag;
+
+	if (pnm)
+		pnm->host_registered = DEREGISTERED;
+
+	tasklet_kill(&edma_host->tasklet);
+
+	kfree(edma_host->msg_send_buf);
+	edma_host->msg_send_buf = NULL;
+#ifdef EDMA_TIMER
+	(void)del_timer_sync(&edma_host->timer);
+#ifdef USE_DMA
+	(void)del_timer_sync(&edma_host->dma_timer);
+#endif
+
+#else
+	kthread_stop(edma_host->edma_thread);
+
+	complete(&edma_host->msg_ready);
+#endif
+}
diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/edma_host.h b/drivers/net/ethernet/huawei/bma/edma_drv/edma_host.h
new file mode 100644
index 000000000000..9d86b5b0fdd6
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/edma_drv/edma_host.h
@@ -0,0 +1,351 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _EDMA_HOST_H_
+#define _EDMA_HOST_H_
+
+#include "bma_include.h"
+#include "../include/bma_ker_intf.h"
+
+#define EDMA_TIMER
+
+#ifndef IN
+#define IN
+#endif
+
+#ifndef OUT
+#define OUT
+#endif
+
+#ifndef UNUSED
+#define UNUSED
+#endif
+
+/* vm_flags in vm_area_struct, see mm_types.h. */
+#define VM_NONE		0x00000000
+
+#define VM_READ		0x00000001	/* currently active flags */
+#define VM_WRITE	0x00000002
+#define VM_EXEC		0x00000004
+#define VM_SHARED	0x00000008
+
+#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
+#define VM_MAYWRITE	0x00000020
+#define VM_MAYEXEC	0x00000040
+#define VM_MAYSHARE	0x00000080
+
+#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_PFNMAP	0x00000400
+#define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
+
+#define VM_LOCKED	0x00002000
+#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
+
+					/* Used by sys_madvise() */
+#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
+/* App will not benefit from clustered reads */
+#define VM_RAND_READ	0x00010000
+
+#define VM_DONTCOPY	0x00020000	/* Do not copy this vma on fork */
+#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
+#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
+#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
+#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
+#define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
+#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
+#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
+/* Can contain "struct page" and pure PFN pages */
+#define VM_MIXEDMAP	0x10000000
+
+#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+
+#if defined(CONFIG_X86)
+/* PAT reserves whole VMA at once (x86) */
+#define VM_PAT		VM_ARCH_1
+#elif defined(CONFIG_PPC)
+#define VM_SAO		VM_ARCH_1	/* Strong Access Ordering (powerpc) */
+#elif defined(CONFIG_PARISC)
+#define VM_GROWSUP	VM_ARCH_1
+#elif defined(CONFIG_METAG)
+#define VM_GROWSUP	VM_ARCH_1
+#elif defined(CONFIG_IA64)
+#define VM_GROWSUP	VM_ARCH_1
+#elif !defined(CONFIG_MMU)
+#define VM_MAPPED_COPY	VM_ARCH_1 /* T if mapped copy of data (nommu mmap) */
+#endif
+
+#ifndef VM_GROWSUP
+#define VM_GROWSUP	VM_NONE
+#endif
+
+/* Bits set in the VMA until the stack is in its final location */
+#define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
+
+#ifndef VM_STACK_DEFAULT_FLAGS	/* arch can override this */
+#define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
+#endif
+
+#define VM_READHINTMASK			(VM_SEQ_READ | VM_RAND_READ)
+#define VM_NORMAL_READ_HINT(v)		(!((v)->vm_flags & VM_READHINTMASK))
+#define VM_SEQUENTIAL_READ_HINT(v)	((v)->vm_flags & VM_SEQ_READ)
+#define VM_RANDOM_READ_HINT(v)		((v)->vm_flags & VM_RAND_READ)
+
+#define REG_PCIE1_DMAREAD_ENABLE	0xa18
+#define SHIFT_PCIE1_DMAREAD_ENABLE	0
+
+#define REG_PCIE1_DMAWRITE_ENABLE	0x9c4
+#define SHIFT_PCIE1_DMAWRITE_ENABLE	0
+
+#define REG_PCIE1_DMAREAD_STATUS	0xa10
+#define SHIFT_PCIE1_DMAREAD_STATUS	0
+#define REG_PCIE1_DMAREADINT_CLEAR	0xa1c
+#define SHIFT_PCIE1_DMAREADINT_CLEAR	0
+
+#define REG_PCIE1_DMAWRITE_STATUS	0x9bc
+#define SHIFT_PCIE1_DMAWRITE_STATUS	0
+#define REG_PCIE1_DMAWRITEINT_CLEAR	0x9c8
+#define SHIFT_PCIE1_DMAWRITEINT_CLEAR	0
+
+#define REG_PCIE1_DMA_READ_ENGINE_ENABLE	(0x99c)
+#define SHIFT_PCIE1_DMA_ENGINE_ENABLE		(0)
+#define REG_PCIE1_DMA_WRITE_ENGINE_ENABLE	(0x97C)
+
+#define HOSTRTC_INT_OFFSET		0x10
+
+#define H2BSTATE_IDLE			0
+#define H2BSTATE_WAITREADY		1
+#define H2BSTATE_WAITDMA		2
+#define H2BSTATE_WAITACK		3
+#define H2BSTATE_ERROR			4
+
+#define B2HSTATE_IDLE			0
+#define B2HSTATE_WAITREADY		1
+#define B2HSTATE_WAITRECV		2
+#define B2HSTATE_WAITDMA		3
+#define B2HSTATE_ERROR			4
+
+#define PAGE_ORDER			8
+#define EDMA_DMABUF_SIZE		(1 << (PAGE_SHIFT + PAGE_ORDER))
+
+#define EDMA_DMA_TRANSFER_WAIT_TIMEOUT	(10 * HZ)
+#define TIMEOUT_WAIT_NOSIGNAL		2
+
+#define TIMER_INTERVAL_CHECK		(HZ / 10)
+#define DMA_TIMER_INTERVAL_CHECK	50
+#define HEARTBEAT_TIMER_INTERVAL_CHECK	HZ
+
+#define EDMA_PCI_MSG_LEN		(56 * 1024)
+
+#define HOST_DMA_FLAG_LEN		(64)
+
+#define HOST_MAX_SEND_MBX_LEN		(40 * 1024)
+#define BMC_MAX_RCV_MBX_LEN		HOST_MAX_SEND_MBX_LEN
+
+#define HOST_MAX_RCV_MBX_LEN		(16 * 1024)
+#define BMC_MAX_SEND_MBX_LEN		HOST_MAX_RCV_MBX_LEN
+#define CDEV_MAX_WRITE_LEN		(4 * 1024)
+
+#define HOST_MAX_MSG_LENGTH		272
+
+#define EDMA_MMAP_H2B_DMABUF		0xf1000000
+
+#define EDMA_MMAP_B2H_DMABUF		0xf2000000
+
+#define EDMA_IOC_MAGIC			'e'
+
+#define EDMA_H_REGISTER_TYPE		_IOW(EDMA_IOC_MAGIC, 100, unsigned long)
+
+#define EDMA_H_UNREGISTER_TYPE		_IOW(EDMA_IOC_MAGIC, 101, unsigned long)
+
+#define EDMA_H_DMA_START		_IOW(EDMA_IOC_MAGIC, 102, unsigned long)
+
+#define EDMA_H_DMA_TRANSFER		_IOW(EDMA_IOC_MAGIC, 103, unsigned long)
+
+#define EDMA_H_DMA_STOP			_IOW(EDMA_IOC_MAGIC, 104, unsigned long)
+
+#define U64ADDR_H(addr)			((((u64)addr) >> 32) & 0xffffffff)
+#define U64ADDR_L(addr)			((addr) & 0xffffffff)
+
+struct bma_register_dev_type_s {
+	u32 type;
+	u32 sub_type;
+};
+
+struct edma_mbx_hdr_s {
+	u16 mbxlen;
+	u16 mbxoff;
+	u8 reserve[28];
+} __packed;
+
+#define SIZE_OF_MBX_HDR (sizeof(struct edma_mbx_hdr_s))
+
+struct edma_recv_msg_s {
+	struct list_head link;
+	u32 msg_len;
+	unsigned char msg_data[0];
+};
+
+struct edma_dma_addr_s {
+	void *kvaddr;
+	dma_addr_t dma_addr;
+	u32 len;
+};
+
+struct edma_msg_hdr_s {
+	u32 type;
+	u32 sub_type;
+	u8 user_id;
+	u8 dma_flag;
+	u8 reserve1[2];
+	u32 datalen;
+	u8 data[0];
+};
+
+#define SIZE_OF_MSG_HDR (sizeof(struct edma_msg_hdr_s))
+
+#pragma pack(1)
+
+#define IS_EDMA_B2H_INT(flag)		((flag) & 0x02)
+#define CLEAR_EDMA_B2H_INT(flag)	((flag) = (flag) & 0xfffffffd)
+#define SET_EDMA_H2B_INT(flag)		((flag) = (flag) | 0x01)
+#define EDMA_B2H_INT_FLAG                      0x02
+
+struct notify_msg {
+	unsigned int host_registered;
+	unsigned int host_heartbeat;
+	unsigned int bmc_registered;
+	unsigned int bmc_heartbeat;
+	unsigned int int_flag;
+
+	unsigned int reservrd5;
+	unsigned int h2b_addr;
+	unsigned int h2b_size;
+	unsigned int h2b_rsize;
+	unsigned int b2h_addr;
+	unsigned int b2h_size;
+	unsigned int b2h_rsize;
+};
+
+#pragma pack()
+
+struct edma_statistics_s {
+	unsigned int remote_status;
+	__kernel_time_t init_time;
+	unsigned int h2b_int;
+	unsigned int b2h_int;
+	unsigned int recv_bytes;
+	unsigned int send_bytes;
+	unsigned int send_pkgs;
+	unsigned int recv_pkgs;
+	unsigned int failed_count;
+	unsigned int drop_pkgs;
+	unsigned int dma_count;
+	unsigned int lost_count;
+};
+
+struct edma_host_s {
+	struct pci_dev *pdev;
+
+	struct tasklet_struct tasklet;
+
+	void __iomem *hostrtc_viraddr;
+
+	void __iomem *edma_flag;
+	void __iomem *edma_send_addr;
+	void __iomem *edma_recv_addr;
+#ifdef USE_DMA
+	struct timer_list dma_timer;
+#endif
+
+	struct timer_list heartbeat_timer;
+
+#ifdef EDMA_TIMER
+	struct timer_list timer;
+#else
+	struct completion msg_ready;	/* to sleep thread on      */
+	struct task_struct *edma_thread;
+#endif
+	/* spinlock for send msg buf */
+	spinlock_t send_msg_lock;
+	unsigned char *msg_send_buf;
+	unsigned int msg_send_write;
+
+	/* DMA */
+	wait_queue_head_t wq_dmah2b;
+	wait_queue_head_t wq_dmab2h;
+
+	/* spinlock for read pci register */
+	spinlock_t reg_lock;
+	int h2b_state;
+	int b2h_state;
+	struct edma_dma_addr_s h2b_addr;
+	struct edma_dma_addr_s b2h_addr;
+
+	struct proc_dir_entry *proc_edma_dir;
+
+	struct edma_statistics_s statistics;
+	unsigned char local_open_status[TYPE_MAX];
+	unsigned char remote_open_status[TYPE_MAX];
+};
+
+struct edma_user_inft_s {
+	/* register user */
+	int (*user_register)(struct bma_priv_data_s *priv);
+
+	/* unregister user */
+	void (*user_unregister)(struct bma_priv_data_s *priv);
+
+	/* add msg */
+	int (*add_msg)(void *msg, size_t msg_len);
+};
+
+int is_edma_b2h_int(struct edma_host_s *edma_host);
+void edma_int_to_bmc(struct edma_host_s *edma_host);
+int edma_host_mmap(struct edma_host_s *edma_hos, struct file *filp,
+		   struct vm_area_struct *vma);
+int edma_host_copy_msg(struct edma_host_s *edma_host, void *msg,
+		       size_t msg_len);
+int edma_host_add_msg(struct edma_host_s *edma_host,
+		      struct bma_priv_data_s *priv, void *msg, size_t msg_len);
+int edma_host_recv_msg(struct edma_host_s *edma_host,
+		       struct bma_priv_data_s *priv,
+		       struct edma_recv_msg_s **msg);
+void edma_host_isr_tasklet(unsigned long data);
+int edma_host_check_dma_status(enum dma_direction_e dir);
+int edma_host_dma_start(struct edma_host_s *edma_host,
+			struct bma_priv_data_s *priv);
+int edma_host_dma_transfer(struct edma_host_s *edma_host,
+			   struct bma_priv_data_s *priv,
+			   struct bma_dma_transfer_s *dma_transfer);
+int edma_host_dma_stop(struct edma_host_s *edma_host,
+		       struct bma_priv_data_s *priv);
+irqreturn_t edma_host_irq_handle(struct edma_host_s *edma_host);
+struct edma_user_inft_s *edma_host_get_user_inft(u32 type);
+int edma_host_user_register(u32 type, struct edma_user_inft_s *func);
+int edma_host_user_unregister(u32 type);
+int edma_host_init(struct edma_host_s *edma_host);
+void edma_host_cleanup(struct edma_host_s *edma_host);
+int edma_host_send_driver_msg(const void *msg, size_t msg_len, int subtype);
+void edma_host_reset_dma(struct edma_host_s *edma_host, int dir);
+void clear_int_dmah2b(struct edma_host_s *edma_host);
+void clear_int_dmab2h(struct edma_host_s *edma_host);
+
+enum EDMA_STATUS {
+	DEREGISTERED = 0,
+	REGISTERED = 1,
+	LOST,
+};
+#endif
diff --git a/drivers/net/ethernet/huawei/bma/include/bma_ker_intf.h b/drivers/net/ethernet/huawei/bma/include/bma_ker_intf.h
new file mode 100644
index 000000000000..8617e7e8450e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/bma/include/bma_ker_intf.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Huawei iBMA driver.
+ * Copyright (c) 2017, Huawei Technologies Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _BMA_KER_INTF_H_
+#define _BMA_KER_INTF_H_
+
+enum {
+	/* 0 -127 msg */
+	TYPE_LOGIC_PARTITION = 0,
+	TYPE_UPGRADE = 1,
+	TYPE_CDEV = 2,
+	TYPE_VETH = 0x40,
+	TYPE_MAX = 128,
+
+	TYPE_KBOX = 129,
+	TYPE_EDMA_DRIVER = 130,
+	TYPE_UNKNOWN = 0xff,
+};
+
+enum dma_direction_e {
+	BMC_TO_HOST = 0,
+	HOST_TO_BMC = 1,
+};
+
+enum dma_type_e {
+	DMA_NOT_LIST = 0,
+	DMA_LIST = 1,
+};
+
+enum intr_mod {
+	INTR_DISABLE = 0,
+	INTR_ENABLE = 1,
+};
+
+struct bma_dma_addr_s {
+	dma_addr_t dma_addr;
+	u32 dma_data_len;
+};
+
+struct dma_transfer_s {
+	struct bma_dma_addr_s host_addr;
+	struct bma_dma_addr_s bmc_addr;
+};
+
+struct dmalist_transfer_s {
+	dma_addr_t dma_addr;
+};
+
+union transfer_u {
+	struct dma_transfer_s nolist;
+	struct dmalist_transfer_s list;
+};
+
+struct bma_dma_transfer_s {
+	enum dma_type_e type;
+	enum dma_direction_e dir;
+	union transfer_u transfer;
+};
+
+int bma_intf_register_int_notifier(struct notifier_block *nb);
+void bma_intf_unregister_int_notifier(struct notifier_block *nb);
+int bma_intf_register_type(u32 type, u32 sub_type, enum intr_mod support_int,
+			   void **handle);
+int bma_intf_unregister_type(void **handle);
+int bma_intf_check_dma_status(enum dma_direction_e dir);
+int bma_intf_start_dma(void *handle, struct bma_dma_transfer_s *dma_transfer);
+int bma_intf_int_to_bmc(void *handle);
+void bma_intf_set_open_status(void *handle, int s);
+int bma_intf_is_link_ok(void);
+void bma_intf_reset_dma(enum dma_direction_e dir);
+void bma_intf_clear_dma_int(enum dma_direction_e dir);
+
+int bma_cdev_recv_msg(void *handle, char __user *data, size_t count);
+int bma_cdev_add_msg(void *handle, const char __user *msg, size_t msg_len);
+
+unsigned int bma_cdev_check_recv(void *handle);
+void *bma_cdev_get_wait_queue(void *handle);
+int bma_intf_check_edma_supported(void);
+#endif
-- 
2.26.2.windows.1


