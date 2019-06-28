Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893FF5A2DC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF1R4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:56:54 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:47361 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfF1R4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:56:53 -0400
Received: by mail-pg1-f201.google.com with SMTP id o19so3536946pgl.14
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UzxAPuLBb2d/Cqt+I3Petfz4gLTogMEkgQzvLr0IwbI=;
        b=m2hjKFP/UHZk6Hal8h2wuMapb4G3fRsYBRWzY1tTQ8WeYTmaRGMrkR17cdFySnQJdY
         QYgBDuA84XGXgCJIppPw5hxonZ9RXuDLWn9fpFy4+KwgG3ygacPBilBE/FGpmyCaDcJc
         M3bzIIwNRqlzfwKWTfmSfk+Pf7k4EgqKvYg6hxvqnCWyzkGdjl9qgNOkgK12afCU5fo5
         ckCxmx19f4VIwyyjtUS2Tdvo/Tf4o6nx5ZbMAMmoPmjlzp3Ekp7iBtTeJ7A+4stOFj4M
         A7QbW/AzEB6iANreQoX/ZlWveFqJnAEk3D3UJUvDm3/1ymh/IC3MhfYM4Xxt0wLDfj2Y
         6aqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UzxAPuLBb2d/Cqt+I3Petfz4gLTogMEkgQzvLr0IwbI=;
        b=bsdCvaaI2MgCl2q26uw98T8hZYFjXWPuTk0eUiEUB27ceneKGl1fnvRMgPfy8D7CmL
         QeNZBhTl6PjuWMUOWXXIiUu+8pK2zazJXBpibfzv2uZdUtk/EH35AhgQ2OBV2r3wl8SK
         RhjwaqxpygntJeOmWT+6BL7r0VhyU4dYJgHOCXLmmtprprvUb3NUm++zBmLjrXZ0w5Fs
         JGl4CXNBghbLtiq/FunulxH8KoXJHtYKEmRTjQbGMGUx3ilgI/Yf4f0DOiOZtdl8IhNK
         x2XfNuIhgfCcxHnyFq8mtd/OtxQXfGsC5GZj5m2Wix1/cEmQy+XAbc7C9TdI40glBgxL
         4z5g==
X-Gm-Message-State: APjAAAXY1jrLv3IAIrphJyGKtnyA6R73VrlULWbkuWFCTPeax5BtBixY
        52eO2QqU8BfFWWNq/Zk/Gchq+F7JmLrjBMASNotRwHHiwQXcjrVzjCCKQtdrzXd6S/GatozRk03
        81xg4Ul6RkFpBCZj4Qa8sZcpaD6lZ1+oqaq2FHL+n/kz6fDhbTzuCB2lpg3d5jQ==
X-Google-Smtp-Source: APXvYqyNOBm3pPoQ0UIMXQ8Vj2n/76CXREYL7xwkTP/QwiLZsTV3VIWzffnyX9y9O/1oHJRUar3KXjgrQbs=
X-Received: by 2002:a63:db49:: with SMTP id x9mr10184372pgi.93.1561744612286;
 Fri, 28 Jun 2019 10:56:52 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:56:30 -0700
In-Reply-To: <20190628175633.143501-1-csully@google.com>
Message-Id: <20190628175633.143501-2-csully@google.com>
Mime-Version: 1.0
References: <20190628175633.143501-1-csully@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next v2 1/4] gve: Add basic driver framework for Compute
 Engine Virtual NIC
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a driver framework for the Compute Engine Virtual NIC that will be
available in the future.

At this point the only functionality is loading the driver.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Jon Olson <jonolson@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Luigi Rizzo <lrizzo@google.com>
---
 .../networking/device_drivers/google/gve.rst  |  82 ++++
 .../networking/device_drivers/index.rst       |   1 +
 MAINTAINERS                                   |   9 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/google/Kconfig           |  27 ++
 drivers/net/ethernet/google/Makefile          |   5 +
 drivers/net/ethernet/google/gve/Makefile      |   4 +
 drivers/net/ethernet/google/gve/gve.h         | 135 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.c  | 250 ++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  | 133 ++++++
 drivers/net/ethernet/google/gve/gve_main.c    | 446 ++++++++++++++++++
 .../net/ethernet/google/gve/gve_register.h    |  27 ++
 13 files changed, 1121 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/google/gve.rst
 create mode 100644 drivers/net/ethernet/google/Kconfig
 create mode 100644 drivers/net/ethernet/google/Makefile
 create mode 100644 drivers/net/ethernet/google/gve/Makefile
 create mode 100644 drivers/net/ethernet/google/gve/gve.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_adminq.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_adminq.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_main.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_register.h

diff --git a/Documentation/networking/device_drivers/google/gve.rst b/Documentation/networking/device_drivers/google/gve.rst
new file mode 100644
index 000000000000..7397c82f4c8f
--- /dev/null
+++ b/Documentation/networking/device_drivers/google/gve.rst
@@ -0,0 +1,82 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+==============================================================
+Linux kernel driver for Compute Engine Virtual Ethernet (gve):
+==============================================================
+
+Supported Hardware
+===================
+The GVE driver binds to a single PCI device id used by the virtual
+Ethernet device found in some Compute Engine VMs.
+
++--------------+----------+---------+
+|Field         | Value    | Comments|
++==============+==========+=========+
+|Vendor ID     | `0x1AE0` | Google  |
++--------------+----------+---------+
+|Device ID     | `0x0042` |         |
++--------------+----------+---------+
+|Sub-vendor ID | `0x1AE0` | Google  |
++--------------+----------+---------+
+|Sub-device ID | `0x0058` |         |
++--------------+----------+---------+
+|Revision ID   | `0x0`    |         |
++--------------+----------+---------+
+|Device Class  | `0x200`  | Ethernet|
++--------------+----------+---------+
+
+PCI Bars
+========
+The gVNIC PCI device exposes three 32-bit memory BARS:
+- Bar0 - Device configuration and status registers.
+- Bar1 - MSI-X vector table
+- Bar2 - IRQ, RX and TX doorbells
+
+Device Interactions
+===================
+The driver interacts with the device in the following ways:
+ - Registers
+    - A block of MMIO registers
+    - See gve_register.h for more detail
+ - Admin Queue
+    - See description below
+ - Interrupts
+    - See supported interrupts below
+
+Registers
+---------
+All registers are MMIO and big endian.
+
+The registers are used for initializing and configuring the device as well as
+querying device status in response to management interrupts.
+
+Admin Queue (AQ)
+----------------
+The Admin Queue is a PAGE_SIZE memory block, treated as an array of AQ
+commands, used by the driver to issue commands to the device and set up
+resources.The driver and the device maintain a count of how many commands
+have been submitted and executed. To issue AQ commands, the driver must do
+the following (with proper locking):
+
+1)  Copy new commands into next available slots in the AQ array
+2)  Increment its counter by he number of new commands
+3)  Write the counter into the GVE_ADMIN_QUEUE_DOORBELL register
+4)  Poll the ADMIN_QUEUE_EVENT_COUNTER register until it equals
+    the value written to the doorbell, or until a timeout.
+
+The device will update the status field in each AQ command reported as
+executed through the ADMIN_QUEUE_EVENT_COUNTER register.
+
+Interrupts
+----------
+The following interrupts are supported by the driver:
+
+Management Interrupt
+~~~~~~~~~~~~~~~~~~~~
+The management interrupt is used by the device to tell the driver to
+look at the GVE_DEVICE_STATUS register.
+
+Notification Block Interrupts
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The notification block interrupts are used to tell the driver to poll
+the queues associated with that interrupt.
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 24598d5f8ffa..2b7fefe72351 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -21,6 +21,7 @@ Contents:
    intel/i40e
    intel/iavf
    intel/ice
+   google/gve
    mellanox/mlx5
 
 .. only::  subproject
diff --git a/MAINTAINERS b/MAINTAINERS
index b4304d10f14e..449e7cdb3303 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6720,6 +6720,15 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/goodix.c
 
+GOOGLE ETHERNET DRIVERS
+M:	Catherine Sullivan <csully@google.com>
+R:	Sagi Shahar <sagis@google.com>
+R:	Jon Olson <jonolson@google.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/networking/device_drivers/google/gve.txt
+F:	drivers/net/ethernet/google
+
 GPD POCKET FAN DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	platform-driver-x86@vger.kernel.org
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index fe115b7caba0..93a2d4deb27c 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -76,6 +76,7 @@ source "drivers/net/ethernet/ezchip/Kconfig"
 source "drivers/net/ethernet/faraday/Kconfig"
 source "drivers/net/ethernet/freescale/Kconfig"
 source "drivers/net/ethernet/fujitsu/Kconfig"
+source "drivers/net/ethernet/google/Kconfig"
 source "drivers/net/ethernet/hisilicon/Kconfig"
 source "drivers/net/ethernet/hp/Kconfig"
 source "drivers/net/ethernet/huawei/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 7b5bf9682066..fb9155cffcff 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_NET_VENDOR_EZCHIP) += ezchip/
 obj-$(CONFIG_NET_VENDOR_FARADAY) += faraday/
 obj-$(CONFIG_NET_VENDOR_FREESCALE) += freescale/
 obj-$(CONFIG_NET_VENDOR_FUJITSU) += fujitsu/
+obj-$(CONFIG_NET_VENDOR_GOOGLE) += google/
 obj-$(CONFIG_NET_VENDOR_HISILICON) += hisilicon/
 obj-$(CONFIG_NET_VENDOR_HP) += hp/
 obj-$(CONFIG_NET_VENDOR_HUAWEI) += huawei/
diff --git a/drivers/net/ethernet/google/Kconfig b/drivers/net/ethernet/google/Kconfig
new file mode 100644
index 000000000000..888f08f36101
--- /dev/null
+++ b/drivers/net/ethernet/google/Kconfig
@@ -0,0 +1,27 @@
+#
+# Google network device configuration
+#
+
+config NET_VENDOR_GOOGLE
+	bool "Google Devices"
+	default y
+	help
+	  If you have a network (Ethernet) device belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Google devices. If you say Y, you will be asked
+	  for your specific device in the following questions.
+
+if NET_VENDOR_GOOGLE
+
+config GVE
+	tristate "Google Virtual NIC (gVNIC) support"
+	depends on (PCI_MSI && X86)
+	help
+	  This driver supports Google Virtual NIC (gVNIC)"
+
+	  To compile this driver as a module, choose M here.
+	  The module will be called gve.
+
+endif #NET_VENDOR_GOOGLE
diff --git a/drivers/net/ethernet/google/Makefile b/drivers/net/ethernet/google/Makefile
new file mode 100644
index 000000000000..402cc3ba1639
--- /dev/null
+++ b/drivers/net/ethernet/google/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the Google network device drivers.
+#
+
+obj-$(CONFIG_GVE) += gve/
diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
new file mode 100644
index 000000000000..cec03ee6d931
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/Makefile
@@ -0,0 +1,4 @@
+# Makefile for the Google virtual Ethernet (gve) driver
+
+obj-$(CONFIG_GVE) += gve.o
+gve-objs := gve_main.o gve_adminq.o
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
new file mode 100644
index 000000000000..47fb86e5aeff
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -0,0 +1,135 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#ifndef _GVE_H_
+#define _GVE_H_
+
+#include <linux/dma-mapping.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+
+#ifndef PCI_VENDOR_ID_GOOGLE
+#define PCI_VENDOR_ID_GOOGLE	0x1ae0
+#endif
+
+#define PCI_DEV_ID_GVNIC	0x0042
+
+#define GVE_REGISTER_BAR	0
+#define GVE_DOORBELL_BAR	2
+
+/* 1 for management */
+#define GVE_MIN_MSIX 3
+
+struct gve_notify_block {
+	__be32 irq_db_index; /* idx into Bar2 - set by device, must be 1st */
+	char name[IFNAMSIZ + 16]; /* name registered with the kernel */
+	struct napi_struct napi; /* kernel napi struct for this block */
+	struct gve_priv *priv;
+} ____cacheline_aligned;
+
+struct gve_priv {
+	struct net_device *dev;
+	struct gve_notify_block *ntfy_blocks; /* array of num_ntfy_blks */
+	dma_addr_t ntfy_block_bus;
+	struct msix_entry *msix_vectors; /* array of num_ntfy_blks + 1 */
+	char mgmt_msix_name[IFNAMSIZ + 16];
+	u32 mgmt_msix_idx;
+	__be32 *counter_array; /* array of num_event_counters */
+	dma_addr_t counter_array_bus;
+
+	u16 num_event_counters;
+
+	u32 num_ntfy_blks; /* spilt between TX and RX so must be even */
+
+	struct gve_registers __iomem *reg_bar0; /* see gve_register.h */
+	__be32 __iomem *db_bar2; /* "array" of doorbells */
+	u32 msg_enable;	/* level for netif* netdev print macros	*/
+	struct pci_dev *pdev;
+
+	/* Admin queue - see gve_adminq.h*/
+	union gve_adminq_command *adminq;
+	dma_addr_t adminq_bus_addr;
+	u32 adminq_mask; /* masks prod_cnt to adminq size */
+	u32 adminq_prod_cnt; /* free-running count of AQ cmds executed */
+
+	unsigned long state_flags;
+};
+
+enum gve_state_flags {
+	GVE_PRIV_FLAGS_ADMIN_QUEUE_OK		= BIT(1),
+	GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK	= BIT(2),
+	GVE_PRIV_FLAGS_DEVICE_RINGS_OK		= BIT(3),
+	GVE_PRIV_FLAGS_NAPI_ENABLED		= BIT(4),
+};
+
+static inline bool gve_get_admin_queue_ok(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
+}
+
+static inline void gve_set_admin_queue_ok(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
+}
+
+static inline void gve_clear_admin_queue_ok(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
+}
+
+static inline bool gve_get_device_resources_ok(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK, &priv->state_flags);
+}
+
+static inline void gve_set_device_resources_ok(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK, &priv->state_flags);
+}
+
+static inline void gve_clear_device_resources_ok(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK, &priv->state_flags);
+}
+
+static inline bool gve_get_device_rings_ok(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_DEVICE_RINGS_OK, &priv->state_flags);
+}
+
+static inline void gve_set_device_rings_ok(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_DEVICE_RINGS_OK, &priv->state_flags);
+}
+
+static inline void gve_clear_device_rings_ok(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_DEVICE_RINGS_OK, &priv->state_flags);
+}
+
+static inline bool gve_get_napi_enabled(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
+}
+
+static inline void gve_set_napi_enabled(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
+}
+
+static inline void gve_clear_napi_enabled(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
+}
+
+/* Returns the address of the ntfy_blocks irq doorbell
+ */
+static inline __be32 __iomem *gve_irq_doorbell(struct gve_priv *priv,
+					       struct gve_notify_block *block)
+{
+	return &priv->db_bar2[be32_to_cpu(block->irq_db_index)];
+}
+#endif /* _GVE_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
new file mode 100644
index 000000000000..b74c7ff3705a
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/pci.h>
+#include "gve.h"
+#include "gve_adminq.h"
+#include "gve_register.h"
+
+#define GVE_MAX_ADMINQ_RELEASE_CHECK	500
+#define GVE_ADMINQ_SLEEP_LEN		20
+#define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK	100
+
+int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
+{
+	priv->adminq = dma_alloc_coherent(dev, PAGE_SIZE,
+					  &priv->adminq_bus_addr, GFP_KERNEL);
+	if (unlikely(!priv->adminq))
+		return -ENOMEM;
+
+	priv->adminq_mask = (PAGE_SIZE / sizeof(union gve_adminq_command)) - 1;
+	priv->adminq_prod_cnt = 0;
+
+	/* Setup Admin queue with the device */
+	writel(cpu_to_be32(priv->adminq_bus_addr / PAGE_SIZE),
+	       &priv->reg_bar0->adminq_pfn);
+
+	gve_set_admin_queue_ok(priv);
+	return 0;
+}
+
+void gve_adminq_release(struct gve_priv *priv)
+{
+	int i = 0;
+
+	/* Tell the device the adminq is leaving */
+	writel(0x0, &priv->reg_bar0->adminq_pfn);
+	while (readl(&priv->reg_bar0->adminq_pfn)) {
+		/* If this is reached the device is unrecoverable and still
+		 * holding memory. Continue looping to avoid memory corruption,
+		 * but WARN so it is visible what is going on.
+		 */
+		if (i == GVE_MAX_ADMINQ_RELEASE_CHECK)
+			WARN(1, "Unrecoverable platform error!");
+		i++;
+		msleep(GVE_ADMINQ_SLEEP_LEN);
+	}
+	gve_clear_device_rings_ok(priv);
+	gve_clear_device_resources_ok(priv);
+	gve_clear_admin_queue_ok(priv);
+}
+
+void gve_adminq_free(struct device *dev, struct gve_priv *priv)
+{
+	if (!gve_get_admin_queue_ok(priv))
+		return;
+	gve_adminq_release(priv);
+	dma_free_coherent(dev, PAGE_SIZE, priv->adminq, priv->adminq_bus_addr);
+	gve_clear_admin_queue_ok(priv);
+}
+
+static void gve_adminq_kick_cmd(struct gve_priv *priv, u32 prod_cnt)
+{
+	writel(cpu_to_be32(prod_cnt),
+	       &priv->reg_bar0->adminq_doorbell);
+}
+
+static bool gve_adminq_wait_for_cmd(struct gve_priv *priv, u32 prod_cnt)
+{
+	int i;
+
+	for (i = 0; i < GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK; i++) {
+		if (be32_to_cpu(readl(&priv->reg_bar0->adminq_event_counter))
+		    == prod_cnt)
+			return true;
+		msleep(GVE_ADMINQ_SLEEP_LEN);
+	}
+
+	return false;
+}
+
+static int gve_adminq_parse_err(struct device *dev, u32 status)
+{
+	if (status != GVE_ADMINQ_COMMAND_PASSED &&
+	    status != GVE_ADMINQ_COMMAND_UNSET)
+		dev_err(dev, "AQ command failed with status %d\n", status);
+
+	switch (status) {
+	case GVE_ADMINQ_COMMAND_PASSED:
+		return 0;
+	case GVE_ADMINQ_COMMAND_UNSET:
+		dev_err(dev, "parse_aq_err: err and status both unset, this should not be possible.\n");
+		return -EINVAL;
+	case GVE_ADMINQ_COMMAND_ERROR_ABORTED:
+	case GVE_ADMINQ_COMMAND_ERROR_CANCELLED:
+	case GVE_ADMINQ_COMMAND_ERROR_DATALOSS:
+	case GVE_ADMINQ_COMMAND_ERROR_FAILED_PRECONDITION:
+	case GVE_ADMINQ_COMMAND_ERROR_UNAVAILABLE:
+		return -EAGAIN;
+	case GVE_ADMINQ_COMMAND_ERROR_ALREADY_EXISTS:
+	case GVE_ADMINQ_COMMAND_ERROR_INTERNAL_ERROR:
+	case GVE_ADMINQ_COMMAND_ERROR_INVALID_ARGUMENT:
+	case GVE_ADMINQ_COMMAND_ERROR_NOT_FOUND:
+	case GVE_ADMINQ_COMMAND_ERROR_OUT_OF_RANGE:
+	case GVE_ADMINQ_COMMAND_ERROR_UNKNOWN_ERROR:
+		return -EINVAL;
+	case GVE_ADMINQ_COMMAND_ERROR_DEADLINE_EXCEEDED:
+		return -ETIME;
+	case GVE_ADMINQ_COMMAND_ERROR_PERMISSION_DENIED:
+	case GVE_ADMINQ_COMMAND_ERROR_UNAUTHENTICATED:
+		return -EACCES;
+	case GVE_ADMINQ_COMMAND_ERROR_RESOURCE_EXHAUSTED:
+		return -ENOMEM;
+	case GVE_ADMINQ_COMMAND_ERROR_UNIMPLEMENTED:
+		return -ENOTSUPP;
+	default:
+		dev_err(dev, "parse_aq_err: unknown status code %d\n", status);
+		return -EINVAL;
+	}
+}
+
+/* This function is not threadsafe - the caller is responsible for any
+ * necessary locks.
+ */
+int gve_adminq_execute_cmd(struct gve_priv *priv,
+			   union gve_adminq_command *cmd_orig)
+{
+	union gve_adminq_command *cmd;
+	u32 status = 0;
+	u32 prod_cnt;
+
+	cmd = &priv->adminq[priv->adminq_prod_cnt & priv->adminq_mask];
+	priv->adminq_prod_cnt++;
+	prod_cnt = priv->adminq_prod_cnt;
+
+	memcpy(cmd, cmd_orig, sizeof(*cmd_orig));
+
+	gve_adminq_kick_cmd(priv, prod_cnt);
+	if (!gve_adminq_wait_for_cmd(priv, prod_cnt)) {
+		dev_err(&priv->pdev->dev, "AQ command timed out, need to reset AQ\n");
+		return -ENOTRECOVERABLE;
+	}
+
+	memcpy(cmd_orig, cmd, sizeof(*cmd));
+	status = be32_to_cpu(READ_ONCE(cmd->status));
+	return gve_adminq_parse_err(&priv->pdev->dev, status);
+}
+
+/* The device specifies that the management vector can either be the first irq
+ * or the last irq. ntfy_blk_msix_base_idx indicates the first irq assigned to
+ * the ntfy blks. It if is 0 then the management vector is last, if it is 1 then
+ * the management vector is first.
+ *
+ * gve arranges the msix vectors so that the management vector is last.
+ */
+#define GVE_NTFY_BLK_BASE_MSIX_IDX	0
+int gve_adminq_configure_device_resources(struct gve_priv *priv,
+					  dma_addr_t counter_array_bus_addr,
+					  u32 num_counters,
+					  dma_addr_t db_array_bus_addr,
+					  u32 num_ntfy_blks)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CONFIGURE_DEVICE_RESOURCES);
+	cmd.configure_device_resources =
+		(struct gve_adminq_configure_device_resources) {
+		.counter_array = cpu_to_be64(counter_array_bus_addr),
+		.num_counters = cpu_to_be32(num_counters),
+		.irq_db_addr = cpu_to_be64(db_array_bus_addr),
+		.num_irq_dbs = cpu_to_be32(num_ntfy_blks),
+		.irq_db_stride = cpu_to_be32(sizeof(priv->ntfy_blocks[0])),
+		.ntfy_blk_msix_base_idx =
+					cpu_to_be32(GVE_NTFY_BLK_BASE_MSIX_IDX),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
+int gve_adminq_deconfigure_device_resources(struct gve_priv *priv)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES);
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
+int gve_adminq_describe_device(struct gve_priv *priv)
+{
+	struct gve_device_descriptor *descriptor;
+	union gve_adminq_command cmd;
+	dma_addr_t descriptor_bus;
+	int err = 0;
+	u8 *mac;
+	u16 mtu;
+
+	memset(&cmd, 0, sizeof(cmd));
+	descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
+					&descriptor_bus, GFP_KERNEL);
+	if (!descriptor)
+		return -ENOMEM;
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESCRIBE_DEVICE);
+	cmd.describe_device.device_descriptor_addr =
+						cpu_to_be64(descriptor_bus);
+	cmd.describe_device.device_descriptor_version =
+			cpu_to_be32(GVE_ADMINQ_DEVICE_DESCRIPTOR_VERSION);
+	cmd.describe_device.available_length = cpu_to_be32(PAGE_SIZE);
+
+	err = gve_adminq_execute_cmd(priv, &cmd);
+	if (err)
+		goto free_device_descriptor;
+
+	mtu = be16_to_cpu(descriptor->mtu);
+	if (mtu < ETH_MIN_MTU) {
+		netif_err(priv, drv, priv->dev, "MTU %d below minimum MTU\n",
+			  mtu);
+		err = -EINVAL;
+		goto free_device_descriptor;
+	}
+	priv->dev->max_mtu = mtu;
+	priv->num_event_counters = be16_to_cpu(descriptor->counters);
+	ether_addr_copy(priv->dev->dev_addr, descriptor->mac);
+	mac = descriptor->mac;
+	netif_info(priv, drv, priv->dev, "MAC addr: %pM\n", mac);
+
+free_device_descriptor:
+	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
+			  descriptor_bus);
+	return err;
+}
+
+int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_SET_DRIVER_PARAMETER);
+	cmd.set_driver_param = (struct gve_adminq_set_driver_parameter) {
+		.parameter_type = cpu_to_be32(GVE_SET_PARAM_MTU),
+		.parameter_value = cpu_to_be64(mtu),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
new file mode 100644
index 000000000000..7a4ba4b12dc6
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#ifndef _GVE_ADMINQ_H
+#define _GVE_ADMINQ_H
+
+#include <linux/build_bug.h>
+
+/* Admin queue opcodes */
+enum gve_adminq_opcodes {
+	GVE_ADMINQ_DESCRIBE_DEVICE		= 0x1,
+	GVE_ADMINQ_CONFIGURE_DEVICE_RESOURCES	= 0x2,
+	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
+	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
+};
+
+/* Admin queue status codes */
+enum gve_adminq_statuses {
+	GVE_ADMINQ_COMMAND_UNSET			= 0x0,
+	GVE_ADMINQ_COMMAND_PASSED			= 0x1,
+	GVE_ADMINQ_COMMAND_ERROR_ABORTED		= 0xFFFFFFF0,
+	GVE_ADMINQ_COMMAND_ERROR_ALREADY_EXISTS		= 0xFFFFFFF1,
+	GVE_ADMINQ_COMMAND_ERROR_CANCELLED		= 0xFFFFFFF2,
+	GVE_ADMINQ_COMMAND_ERROR_DATALOSS		= 0xFFFFFFF3,
+	GVE_ADMINQ_COMMAND_ERROR_DEADLINE_EXCEEDED	= 0xFFFFFFF4,
+	GVE_ADMINQ_COMMAND_ERROR_FAILED_PRECONDITION	= 0xFFFFFFF5,
+	GVE_ADMINQ_COMMAND_ERROR_INTERNAL_ERROR		= 0xFFFFFFF6,
+	GVE_ADMINQ_COMMAND_ERROR_INVALID_ARGUMENT	= 0xFFFFFFF7,
+	GVE_ADMINQ_COMMAND_ERROR_NOT_FOUND		= 0xFFFFFFF8,
+	GVE_ADMINQ_COMMAND_ERROR_OUT_OF_RANGE		= 0xFFFFFFF9,
+	GVE_ADMINQ_COMMAND_ERROR_PERMISSION_DENIED	= 0xFFFFFFFA,
+	GVE_ADMINQ_COMMAND_ERROR_UNAUTHENTICATED	= 0xFFFFFFFB,
+	GVE_ADMINQ_COMMAND_ERROR_RESOURCE_EXHAUSTED	= 0xFFFFFFFC,
+	GVE_ADMINQ_COMMAND_ERROR_UNAVAILABLE		= 0xFFFFFFFD,
+	GVE_ADMINQ_COMMAND_ERROR_UNIMPLEMENTED		= 0xFFFFFFFE,
+	GVE_ADMINQ_COMMAND_ERROR_UNKNOWN_ERROR		= 0xFFFFFFFF,
+};
+
+#define GVE_ADMINQ_DEVICE_DESCRIPTOR_VERSION 1
+
+/* All AdminQ command structs should be naturally packed. The static_assert
+ * calls make sure this is the case at compile time.
+ */
+
+struct gve_adminq_describe_device {
+	__be64 device_descriptor_addr;
+	__be32 device_descriptor_version;
+	__be32 available_length;
+};
+
+static_assert(sizeof(struct gve_adminq_describe_device) == 16);
+
+struct gve_device_descriptor {
+	__be64 max_registered_pages;
+	__be16 reserved1;
+	__be16 tx_queue_entries;
+	__be16 rx_queue_entries;
+	__be16 default_num_queues;
+	__be16 mtu;
+	__be16 counters;
+	__be16 tx_pages_per_qpl;
+	__be16 rx_pages_per_qpl;
+	u8  mac[ETH_ALEN];
+	__be16 num_device_options;
+	__be16 total_length;
+	u8  reserved2[6];
+};
+
+static_assert(sizeof(struct gve_device_descriptor) == 40);
+
+struct device_option {
+	__be32 option_id;
+	__be32 option_length;
+};
+
+static_assert(sizeof(struct device_option) == 8);
+
+struct gve_adminq_configure_device_resources {
+	__be64 counter_array;
+	__be64 irq_db_addr;
+	__be32 num_counters;
+	__be32 num_irq_dbs;
+	__be32 irq_db_stride;
+	__be32 ntfy_blk_msix_base_idx;
+};
+
+static_assert(sizeof(struct gve_adminq_configure_device_resources) == 32);
+
+/* GVE Set Driver Parameter Types */
+enum gve_set_driver_param_types {
+	GVE_SET_PARAM_MTU	= 0x1,
+};
+
+struct gve_adminq_set_driver_parameter {
+	__be32 parameter_type;
+	__be64 parameter_value;
+};
+
+static_assert(sizeof(struct gve_adminq_set_driver_parameter) == 16);
+
+union gve_adminq_command {
+	struct {
+		__be32 opcode;
+		__be32 status;
+		union {
+			struct gve_adminq_configure_device_resources
+						configure_device_resources;
+			struct gve_adminq_describe_device describe_device;
+			struct gve_adminq_set_driver_parameter set_driver_param;
+		};
+	};
+	u8 reserved[64];
+};
+
+static_assert(sizeof(union gve_adminq_command) == 64);
+
+int gve_adminq_alloc(struct device *dev, struct gve_priv *priv);
+void gve_adminq_free(struct device *dev, struct gve_priv *priv);
+void gve_adminq_release(struct gve_priv *priv);
+int gve_adminq_execute_cmd(struct gve_priv *priv,
+			   union gve_adminq_command *cmd_orig);
+int gve_adminq_describe_device(struct gve_priv *priv);
+int gve_adminq_configure_device_resources(struct gve_priv *priv,
+					  dma_addr_t counter_array_bus_addr,
+					  u32 num_counters,
+					  dma_addr_t db_array_bus_addr,
+					  u32 num_ntfy_blks);
+int gve_adminq_deconfigure_device_resources(struct gve_priv *priv);
+int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
+#endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
new file mode 100644
index 000000000000..168daae77227
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -0,0 +1,446 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#include <linux/cpumask.h>
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <net/sch_generic.h>
+#include "gve.h"
+#include "gve_adminq.h"
+#include "gve_register.h"
+
+#define DEFAULT_MSG_LEVEL	(NETIF_MSG_DRV | NETIF_MSG_LINK)
+#define GVE_VERSION		"1.0.0"
+#define GVE_VERSION_PREFIX	"GVE-"
+
+const char gve_version_str[] = GVE_VERSION;
+const char gve_version_prefix[] = GVE_VERSION_PREFIX;
+
+static int gve_alloc_counter_array(struct gve_priv *priv)
+{
+	priv->counter_array =
+		dma_alloc_coherent(&priv->pdev->dev,
+				   priv->num_event_counters *
+				   sizeof(*priv->counter_array),
+				   &priv->counter_array_bus, GFP_KERNEL);
+	if (!priv->counter_array)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void gve_free_counter_array(struct gve_priv *priv)
+{
+	dma_free_coherent(&priv->pdev->dev,
+			  priv->num_event_counters *
+			  sizeof(*priv->counter_array),
+			  priv->counter_array, priv->counter_array_bus);
+	priv->counter_array = NULL;
+}
+
+static irqreturn_t gve_mgmnt_intr(int irq, void *arg)
+{
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t gve_intr(int irq, void *arg)
+{
+	return IRQ_HANDLED;
+}
+
+static int gve_alloc_notify_blocks(struct gve_priv *priv)
+{
+	int num_vecs_requested = priv->num_ntfy_blks + 1;
+	char *name = priv->dev->name;
+	unsigned int active_cpus;
+	int vecs_enabled;
+	int i, j;
+	int err;
+
+	priv->msix_vectors = kvzalloc(num_vecs_requested *
+				      sizeof(*priv->msix_vectors), GFP_KERNEL);
+	if (!priv->msix_vectors)
+		return -ENOMEM;
+	for (i = 0; i < num_vecs_requested; i++)
+		priv->msix_vectors[i].entry = i;
+	vecs_enabled = pci_enable_msix_range(priv->pdev, priv->msix_vectors,
+					     GVE_MIN_MSIX, num_vecs_requested);
+	if (vecs_enabled < 0) {
+		dev_err(&priv->pdev->dev, "Could not enable min msix %d/%d\n",
+			GVE_MIN_MSIX, vecs_enabled);
+		err = vecs_enabled;
+		goto abort_with_msix_vectors;
+	}
+	if (vecs_enabled != num_vecs_requested) {
+		priv->num_ntfy_blks = (vecs_enabled - 1) & ~0x1;
+		dev_err(&priv->pdev->dev,
+			"Only received %d msix. Lowering number of notification blocks to %d\n",
+			vecs_enabled, priv->num_ntfy_blks);
+	}
+	/* Half the notification blocks go to TX and half to RX */
+	active_cpus = min_t(int, priv->num_ntfy_blks / 2, num_online_cpus());
+
+	/* Setup Management Vector  - the last vector */
+	snprintf(priv->mgmt_msix_name, sizeof(priv->mgmt_msix_name), "%s-mgmnt",
+		 name);
+	err = request_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector,
+			  gve_mgmnt_intr, 0, priv->mgmt_msix_name, priv);
+	if (err) {
+		dev_err(&priv->pdev->dev, "Did not receive management vector.\n");
+		goto abort_with_msix_enabled;
+	}
+	priv->ntfy_blocks =
+		dma_alloc_coherent(&priv->pdev->dev,
+				   priv->num_ntfy_blks *
+				   sizeof(*priv->ntfy_blocks),
+				   &priv->ntfy_block_bus, GFP_KERNEL);
+	if (!priv->ntfy_blocks) {
+		err = -ENOMEM;
+		goto abort_with_mgmt_vector;
+	}
+	/* Setup the other blocks - the first n-1 vectors */
+	for (i = 0; i < priv->num_ntfy_blks; i++) {
+		struct gve_notify_block *block = &priv->ntfy_blocks[i];
+		int msix_idx = i;
+
+		snprintf(block->name, sizeof(block->name), "%s-ntfy-block.%d",
+			 name, i);
+		block->priv = priv;
+		err = request_irq(priv->msix_vectors[msix_idx].vector,
+				  gve_intr, 0, block->name, block);
+		if (err) {
+			dev_err(&priv->pdev->dev,
+				"Failed to receive msix vector %d\n", i);
+			goto abort_with_some_ntfy_blocks;
+		}
+		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+				      get_cpu_mask(i % active_cpus));
+	}
+	return 0;
+abort_with_some_ntfy_blocks:
+	for (j = 0; j < i; j++) {
+		struct gve_notify_block *block = &priv->ntfy_blocks[j];
+		int msix_idx = j;
+
+		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+				      NULL);
+		free_irq(priv->msix_vectors[msix_idx].vector, block);
+	}
+	dma_free_coherent(&priv->pdev->dev, priv->num_ntfy_blks *
+			  sizeof(*priv->ntfy_blocks),
+			  priv->ntfy_blocks, priv->ntfy_block_bus);
+	priv->ntfy_blocks = NULL;
+abort_with_mgmt_vector:
+	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
+abort_with_msix_enabled:
+	pci_disable_msix(priv->pdev);
+abort_with_msix_vectors:
+	kfree(priv->msix_vectors);
+	priv->msix_vectors = NULL;
+	return err;
+}
+
+static void gve_free_notify_blocks(struct gve_priv *priv)
+{
+	int i;
+
+	/* Free the irqs */
+	for (i = 0; i < priv->num_ntfy_blks; i++) {
+		struct gve_notify_block *block = &priv->ntfy_blocks[i];
+		int msix_idx = i;
+
+		irq_set_affinity_hint(priv->msix_vectors[msix_idx].vector,
+				      NULL);
+		free_irq(priv->msix_vectors[msix_idx].vector, block);
+	}
+	dma_free_coherent(&priv->pdev->dev,
+			  priv->num_ntfy_blks * sizeof(*priv->ntfy_blocks),
+			  priv->ntfy_blocks, priv->ntfy_block_bus);
+	priv->ntfy_blocks = NULL;
+	free_irq(priv->msix_vectors[priv->mgmt_msix_idx].vector, priv);
+	pci_disable_msix(priv->pdev);
+	kfree(priv->msix_vectors);
+	priv->msix_vectors = NULL;
+}
+
+static int gve_setup_device_resources(struct gve_priv *priv)
+{
+	int err;
+
+	err = gve_alloc_counter_array(priv);
+	if (err)
+		return err;
+	err = gve_alloc_notify_blocks(priv);
+	if (err)
+		goto abort_with_counter;
+	err = gve_adminq_configure_device_resources(priv,
+						    priv->counter_array_bus,
+						    priv->num_event_counters,
+						    priv->ntfy_block_bus,
+						    priv->num_ntfy_blks);
+	if (unlikely(err)) {
+		dev_err(&priv->pdev->dev,
+			"could not setup device_resources: err=%d\n", err);
+		err = -ENXIO;
+		goto abort_with_ntfy_blocks;
+	}
+	gve_set_device_resources_ok(priv);
+	return 0;
+abort_with_ntfy_blocks:
+	gve_free_notify_blocks(priv);
+abort_with_counter:
+	gve_free_counter_array(priv);
+	return err;
+}
+
+static void gve_teardown_device_resources(struct gve_priv *priv)
+{
+	int err;
+
+	/* Tell device its resources are being freed */
+	if (gve_get_device_resources_ok(priv)) {
+		err = gve_adminq_deconfigure_device_resources(priv);
+		if (err) {
+			dev_err(&priv->pdev->dev,
+				"Could not deconfigure device resources: err=%d\n",
+				err);
+			return;
+		}
+	}
+	gve_free_counter_array(priv);
+	gve_free_notify_blocks(priv);
+	gve_clear_device_resources_ok(priv);
+}
+
+static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
+{
+	int num_ntfy;
+	int err;
+
+	/* Set up the adminq */
+	err = gve_adminq_alloc(&priv->pdev->dev, priv);
+	if (err) {
+		dev_err(&priv->pdev->dev,
+			"Failed to alloc admin queue: err=%d\n", err);
+		return err;
+	}
+
+	if (skip_describe_device)
+		goto setup_device;
+
+	/* Get the initial information we need from the device */
+	err = gve_adminq_describe_device(priv);
+	if (err) {
+		dev_err(&priv->pdev->dev,
+			"Could not get device information: err=%d\n", err);
+		goto err;
+	}
+	if (priv->dev->max_mtu > PAGE_SIZE) {
+		priv->dev->max_mtu = PAGE_SIZE;
+		err = gve_adminq_set_mtu(priv, priv->dev->mtu);
+		if (err) {
+			netif_err(priv, drv, priv->dev, "Could not set mtu");
+			goto err;
+		}
+	}
+	priv->dev->mtu = priv->dev->max_mtu;
+	num_ntfy = pci_msix_vec_count(priv->pdev);
+	if (num_ntfy <= 0) {
+		dev_err(&priv->pdev->dev,
+			"could not count MSI-x vectors: err=%d\n", num_ntfy);
+		err = num_ntfy;
+		goto err;
+	} else if (num_ntfy < GVE_MIN_MSIX) {
+		dev_err(&priv->pdev->dev, "gve needs at least %d MSI-x vectors, but only has %d\n",
+			GVE_MIN_MSIX, num_ntfy);
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* gvnic has one Notification Block per MSI-x vector, except for the
+	 * management vector
+	 */
+	priv->num_ntfy_blks = (num_ntfy - 1) & ~0x1;
+	priv->mgmt_msix_idx = priv->num_ntfy_blks;
+
+setup_device:
+	err = gve_setup_device_resources(priv);
+	if (!err)
+		return 0;
+err:
+	gve_adminq_free(&priv->pdev->dev, priv);
+	return err;
+}
+
+static void gve_teardown_priv_resources(struct gve_priv *priv)
+{
+	gve_teardown_device_resources(priv);
+	gve_adminq_free(&priv->pdev->dev, priv);
+}
+
+static void gve_write_version(u8 __iomem *driver_version_register)
+{
+	const char *c = gve_version_prefix;
+
+	while (*c) {
+		writeb(*c, driver_version_register);
+		c++;
+	}
+
+	c = gve_version_str;
+	while (*c) {
+		writeb(*c, driver_version_register);
+		c++;
+	}
+	writeb('\n', driver_version_register);
+}
+
+static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int max_tx_queues, max_rx_queues;
+	struct net_device *dev;
+	__be32 __iomem *db_bar;
+	struct gve_registers __iomem *reg_bar;
+	struct gve_priv *priv;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		return -ENXIO;
+
+	err = pci_request_regions(pdev, "gvnic-cfg");
+	if (err)
+		goto abort_with_enabled;
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
+		goto abort_with_pci_region;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev,
+			"Failed to set consistent dma mask: err=%d\n", err);
+		goto abort_with_pci_region;
+	}
+
+	reg_bar = pci_iomap(pdev, GVE_REGISTER_BAR, 0);
+	if (!reg_bar) {
+		err = -ENOMEM;
+		goto abort_with_pci_region;
+	}
+
+	db_bar = pci_iomap(pdev, GVE_DOORBELL_BAR, 0);
+	if (!db_bar) {
+		dev_err(&pdev->dev, "Failed to map doorbell bar!\n");
+		err = -ENOMEM;
+		goto abort_with_reg_bar;
+	}
+
+	gve_write_version(&reg_bar->driver_version);
+	/* Get max queues to alloc etherdev */
+	max_rx_queues = be32_to_cpu(readl(&reg_bar->max_tx_queues));
+	max_tx_queues = be32_to_cpu(readl(&reg_bar->max_rx_queues));
+	/* Alloc and setup the netdev and priv */
+	dev = alloc_etherdev_mqs(sizeof(*priv), max_tx_queues, max_rx_queues);
+	if (!dev) {
+		dev_err(&pdev->dev, "could not allocate netdev\n");
+		goto abort_with_db_bar;
+	}
+	SET_NETDEV_DEV(dev, &pdev->dev);
+	pci_set_drvdata(pdev, dev);
+	/* advertise features */
+	dev->hw_features = NETIF_F_HIGHDMA;
+	dev->hw_features |= NETIF_F_SG;
+	dev->hw_features |= NETIF_F_HW_CSUM;
+	dev->hw_features |= NETIF_F_TSO;
+	dev->hw_features |= NETIF_F_TSO6;
+	dev->hw_features |= NETIF_F_TSO_ECN;
+	dev->hw_features |= NETIF_F_RXCSUM;
+	dev->hw_features |= NETIF_F_RXHASH;
+	dev->features = dev->hw_features;
+	dev->min_mtu = ETH_MIN_MTU;
+	netif_carrier_off(dev);
+
+	priv = netdev_priv(dev);
+	priv->dev = dev;
+	priv->pdev = pdev;
+	priv->msg_enable = DEFAULT_MSG_LEVEL;
+	priv->reg_bar0 = reg_bar;
+	priv->db_bar2 = db_bar;
+	priv->state_flags = 0x0;
+
+	err = gve_init_priv(priv, false);
+	if (err)
+		goto abort_with_netdev;
+
+	err = register_netdev(dev);
+	if (err)
+		goto abort_with_netdev;
+
+	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
+	return 0;
+
+abort_with_netdev:
+	free_netdev(dev);
+
+abort_with_db_bar:
+	pci_iounmap(pdev, db_bar);
+
+abort_with_reg_bar:
+	pci_iounmap(pdev, reg_bar);
+
+abort_with_pci_region:
+	pci_release_regions(pdev);
+
+abort_with_enabled:
+	pci_disable_device(pdev);
+	return -ENXIO;
+}
+EXPORT_SYMBOL(gve_probe);
+
+static void gve_remove(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct gve_priv *priv = netdev_priv(netdev);
+	__be32 __iomem *db_bar = priv->db_bar2;
+	void __iomem *reg_bar = priv->reg_bar0;
+
+	unregister_netdev(netdev);
+	gve_teardown_priv_resources(priv);
+	free_netdev(netdev);
+	pci_iounmap(pdev, db_bar);
+	pci_iounmap(pdev, reg_bar);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static const struct pci_device_id gve_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_GOOGLE, PCI_DEV_ID_GVNIC) },
+	{ }
+};
+
+static struct pci_driver gvnic_driver = {
+	.name		= "gvnic",
+	.id_table	= gve_id_table,
+	.probe		= gve_probe,
+	.remove		= gve_remove,
+};
+
+module_pci_driver(gvnic_driver);
+
+MODULE_DEVICE_TABLE(pci, gve_id_table);
+MODULE_AUTHOR("Google, Inc.");
+MODULE_DESCRIPTION("gVNIC Driver");
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_VERSION(GVE_VERSION);
diff --git a/drivers/net/ethernet/google/gve/gve_register.h b/drivers/net/ethernet/google/gve/gve_register.h
new file mode 100644
index 000000000000..84ab8893aadd
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_register.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#ifndef _GVE_REGISTER_H_
+#define _GVE_REGISTER_H_
+
+/* Fixed Configuration Registers */
+struct gve_registers {
+	__be32	device_status;
+	__be32	driver_status;
+	__be32	max_tx_queues;
+	__be32	max_rx_queues;
+	__be32	adminq_pfn;
+	__be32	adminq_doorbell;
+	__be32	adminq_event_counter;
+	u8	reserved[3];
+	u8	driver_version;
+};
+
+enum gve_device_status_flags {
+	GVE_DEVICE_STATUS_RESET_MASK		= BIT(1),
+	GVE_DEVICE_STATUS_LINK_STATUS_MASK	= BIT(2),
+};
+#endif /* _GVE_REGISTER_H_ */
-- 
2.22.0.410.gd8fdbe21b5-goog

