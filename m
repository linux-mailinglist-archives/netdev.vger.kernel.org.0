Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2A457939
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhKSXCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhKSXCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 18:02:22 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B96C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:59:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s13so20655094wrb.3
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MfP8OIEMkPVStvP3TNLfOs/Eg7oOaIE4kmMO3DZq8Qw=;
        b=6Bawkn4y2/WyyEruFTRs4N/3zCZtlhgnG5OdOtRmH/RFUFvg8ir9sC4iKppguCsXd1
         qek4Ln2cemeJEVR57oZoHEUYkwC5pVCNkLQ1lR+kbpwN1kQuDwrjW5HHyX+8x2CNnBHJ
         T3+pUjHVm56a+iSC0lSjCMfRwmq+dTOAw86HhW4h1WEWYmsiZelb9nzQ/zEolseACMH+
         IWRpINsx4QB3RXEvKseU4D1NvNCU9EA8WAhn3t62bvnF5TDn8hVUW3pi0vNRmemwOR1v
         GP7fL01HEr2G2VEYPl8BmQC1t5zsJv4UqVdnp2G6ekffjxwKPLD0T6+q5KWtLVyZny9v
         daAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfP8OIEMkPVStvP3TNLfOs/Eg7oOaIE4kmMO3DZq8Qw=;
        b=jjKE6sGIdt/HvkOHYObNrHU+SxshXervoYyxx8noxNBBphtzCE1mCc6mRAgokdY3dn
         Kx6kK8VSmpLVgP5QxQyOLQ4oD8nVvNQnpWY5mkPmibFqhyTc8yTi1fQCFXpQdGli+Fpv
         tlUFIl4dNq58vSDs6KlXiCvrue9LDZ1JnN5njO2gvUfR7Gd599m6+PSx2WYMyNUijlO/
         5R9eoDwRQoarystpQFTVq+kNoo79qhPJRPDO1vHDf+FGIxonGx6Il/EBGVitK84/VF4F
         KuuwvixYuV1roTdgPrTYSZ+ieo4Qv/8MI0nImdZk4Q+EyXa9/fdyJ7ud3iNXD3Po85i6
         5dbg==
X-Gm-Message-State: AOAM530AM4yVUQOYPi+gKJ8/9Or8iJ7CEIIUNyS37yiPqY5v5KUfkmlh
        u0DO5KX6BwtUZEvk3xCI077V7A==
X-Google-Smtp-Source: ABdhPJyHEWgdTNjjdqOCK8BHK2EIQd3C3Gpf3gXOCzvbccmXqH50LCHvMX30XSk/ZrJZL0wh0nPntQ==
X-Received: by 2002:adf:d852:: with SMTP id k18mr11294932wrl.391.1637362757040;
        Fri, 19 Nov 2021 14:59:17 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id n32sm17637377wms.1.2021.11.19.14.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 14:59:16 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v6 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
Date:   Fri, 19 Nov 2021 23:58:26 +0100
Message-Id: <20211119225826.19617-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211119225826.19617-1-gerhard@engleder-embedded.com>
References: <20211119225826.19617-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC is a FPGA based network device for
real-time communication.

It is integrated as Ethernet controller with ethtool and PTP support.
For real-time communcation TC_SETUP_QDISC_TAPRIO is supported.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/engleder/Kconfig         |   38 +
 drivers/net/ethernet/engleder/Makefile        |   10 +
 drivers/net/ethernet/engleder/tsnep.h         |  190 +++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  293 ++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  230 +++
 drivers/net/ethernet/engleder/tsnep_main.c    | 1273 +++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  221 +++
 .../net/ethernet/engleder/tsnep_selftests.c   |  811 +++++++++++
 drivers/net/ethernet/engleder/tsnep_tc.c      |  443 ++++++
 11 files changed, 3511 insertions(+)
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_selftests.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 4601b38f532a..027cbacca1c9 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -73,6 +73,7 @@ config DNET
 source "drivers/net/ethernet/dec/Kconfig"
 source "drivers/net/ethernet/dlink/Kconfig"
 source "drivers/net/ethernet/emulex/Kconfig"
+source "drivers/net/ethernet/engleder/Kconfig"
 source "drivers/net/ethernet/ezchip/Kconfig"
 source "drivers/net/ethernet/faraday/Kconfig"
 source "drivers/net/ethernet/freescale/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index fdd8c6c17451..33d30b619e00 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_DNET) += dnet.o
 obj-$(CONFIG_NET_VENDOR_DEC) += dec/
 obj-$(CONFIG_NET_VENDOR_DLINK) += dlink/
 obj-$(CONFIG_NET_VENDOR_EMULEX) += emulex/
+obj-$(CONFIG_NET_VENDOR_ENGLEDER) += engleder/
 obj-$(CONFIG_NET_VENDOR_EZCHIP) += ezchip/
 obj-$(CONFIG_NET_VENDOR_FARADAY) += faraday/
 obj-$(CONFIG_NET_VENDOR_FREESCALE) += freescale/
diff --git a/drivers/net/ethernet/engleder/Kconfig b/drivers/net/ethernet/engleder/Kconfig
new file mode 100644
index 000000000000..614dcc65c634
--- /dev/null
+++ b/drivers/net/ethernet/engleder/Kconfig
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Engleder network device configuration
+#
+
+config NET_VENDOR_ENGLEDER
+	bool "Engleder devices"
+	default y
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Engleder devices. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_ENGLEDER
+
+config TSNEP
+	tristate "TSN endpoint support"
+	depends on PTP_1588_CLOCK_OPTIONAL
+	select PHYLIB
+	help
+	  Support for the Engleder TSN endpoint Ethernet MAC IP Core.
+
+	  To compile this driver as a module, choose M here. The module will be
+	  called tsnep.
+
+config TSNEP_SELFTESTS
+	bool "TSN endpoint self test support"
+	default n
+	depends on TSNEP
+	help
+	  This enables self test support within the TSN endpoint driver.
+
+	  If unsure, say N.
+
+endif # NET_VENDOR_ENGLEDER
diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
new file mode 100644
index 000000000000..cce2191cb889
--- /dev/null
+++ b/drivers/net/ethernet/engleder/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Engleder Ethernet drivers
+#
+
+obj-$(CONFIG_TSNEP) += tsnep.o
+
+tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
+	      $(tsnep-y)
+tsnep-$(CONFIG_TSNEP_SELFTESTS) += tsnep_selftests.o
diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
new file mode 100644
index 000000000000..d19fa175e3d9
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -0,0 +1,190 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#ifndef _TSNEP_H
+#define _TSNEP_H
+
+#include "tsnep_hw.h"
+
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/phy.h>
+#include <linux/ethtool.h>
+#include <linux/net_tstamp.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/miscdevice.h>
+
+#define TSNEP "tsnep"
+
+#define TSNEP_RING_SIZE 256
+#define TSNEP_RING_ENTRIES_PER_PAGE (PAGE_SIZE / TSNEP_DESC_SIZE)
+#define TSNEP_RING_PAGE_COUNT (TSNEP_RING_SIZE / TSNEP_RING_ENTRIES_PER_PAGE)
+
+#define TSNEP_QUEUES 1
+
+struct tsnep_gcl {
+	void __iomem *addr;
+
+	u64 base_time;
+	u64 cycle_time;
+	u64 cycle_time_extension;
+
+	struct tsnep_gcl_operation operation[TSNEP_GCL_COUNT];
+	int count;
+
+	u64 change_limit;
+
+	u64 start_time;
+	bool change;
+};
+
+struct tsnep_tx_entry {
+	struct tsnep_tx_desc *desc;
+	struct tsnep_tx_desc_wb *desc_wb;
+	dma_addr_t desc_dma;
+	bool owner_user_flag;
+
+	u32 properties;
+
+	struct sk_buff *skb;
+	size_t len;
+	DEFINE_DMA_UNMAP_ADDR(dma);
+};
+
+struct tsnep_tx {
+	struct tsnep_adapter *adapter;
+	void __iomem *addr;
+
+	void *page[TSNEP_RING_PAGE_COUNT];
+	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
+
+	/* TX ring lock */
+	spinlock_t lock;
+	struct tsnep_tx_entry entry[TSNEP_RING_SIZE];
+	int write;
+	int read;
+	u32 owner_counter;
+	int increment_owner_counter;
+
+	u32 packets;
+	u32 bytes;
+	u32 dropped;
+};
+
+struct tsnep_rx_entry {
+	struct tsnep_rx_desc *desc;
+	struct tsnep_rx_desc_wb *desc_wb;
+	dma_addr_t desc_dma;
+
+	u32 properties;
+
+	struct sk_buff *skb;
+	size_t len;
+	DEFINE_DMA_UNMAP_ADDR(dma);
+};
+
+struct tsnep_rx {
+	struct tsnep_adapter *adapter;
+	void __iomem *addr;
+
+	void *page[TSNEP_RING_PAGE_COUNT];
+	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
+
+	struct tsnep_rx_entry entry[TSNEP_RING_SIZE];
+	int read;
+	u32 owner_counter;
+	int increment_owner_counter;
+
+	u32 packets;
+	u32 bytes;
+	u32 dropped;
+	u32 multicast;
+};
+
+struct tsnep_queue {
+	struct tsnep_adapter *adapter;
+
+	struct tsnep_tx *tx;
+	struct tsnep_rx *rx;
+
+	struct napi_struct napi;
+
+	u32 irq_mask;
+};
+
+struct tsnep_adapter {
+	struct net_device *netdev;
+	u8 mac_address[ETH_ALEN];
+	struct mii_bus *mdiobus;
+	bool suppress_preamble;
+	phy_interface_t phy_mode;
+	struct phy_device *phydev;
+	int msg_enable;
+
+	struct platform_device *pdev;
+	struct device *dmadev;
+	void __iomem *addr;
+	unsigned long size;
+	int irq;
+
+	bool gate_control;
+	/* gate control lock */
+	struct mutex gate_control_lock;
+	bool gate_control_active;
+	struct tsnep_gcl gcl[2];
+	int next_gcl;
+
+	struct hwtstamp_config hwtstamp_config;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
+	/* ptp clock lock */
+	spinlock_t ptp_lock;
+
+	int num_tx_queues;
+	struct tsnep_tx tx[TSNEP_MAX_QUEUES];
+	int num_rx_queues;
+	struct tsnep_rx rx[TSNEP_MAX_QUEUES];
+
+	int num_queues;
+	struct tsnep_queue queue[TSNEP_MAX_QUEUES];
+};
+
+extern const struct ethtool_ops tsnep_ethtool_ops;
+
+int tsnep_ptp_init(struct tsnep_adapter *adapter);
+void tsnep_ptp_cleanup(struct tsnep_adapter *adapter);
+int tsnep_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd);
+
+int tsnep_tc_init(struct tsnep_adapter *adapter);
+void tsnep_tc_cleanup(struct tsnep_adapter *adapter);
+int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
+		   void *type_data);
+
+#if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
+int tsnep_ethtool_get_test_count(void);
+void tsnep_ethtool_get_test_strings(u8 *data);
+void tsnep_ethtool_self_test(struct net_device *netdev,
+			     struct ethtool_test *eth_test, u64 *data);
+#else
+static inline int tsnep_ethtool_get_test_count(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void tsnep_ethtool_get_test_strings(u8 *data)
+{
+	/* not enabled */
+}
+
+static inline void tsnep_ethtool_self_test(struct net_device *dev,
+					   struct ethtool_test *eth_test,
+					   u64 *data)
+{
+	/* not enabled */
+}
+#endif /* CONFIG_TSNEP_SELFTESTS */
+
+void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
+
+#endif /* _TSNEP_H */
diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
new file mode 100644
index 000000000000..e6760dc68ddd
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#include "tsnep.h"
+
+static const char tsnep_stats_strings[][ETH_GSTRING_LEN] = {
+	"rx_packets",
+	"rx_bytes",
+	"rx_dropped",
+	"rx_multicast",
+	"rx_phy_errors",
+	"rx_forwarded_phy_errors",
+	"rx_invalid_frame_errors",
+	"tx_packets",
+	"tx_bytes",
+	"tx_dropped",
+};
+
+struct tsnep_stats {
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 rx_dropped;
+	u64 rx_multicast;
+	u64 rx_phy_errors;
+	u64 rx_forwarded_phy_errors;
+	u64 rx_invalid_frame_errors;
+	u64 tx_packets;
+	u64 tx_bytes;
+	u64 tx_dropped;
+};
+
+#define TSNEP_STATS_COUNT (sizeof(struct tsnep_stats) / sizeof(u64))
+
+static const char tsnep_rx_queue_stats_strings[][ETH_GSTRING_LEN] = {
+	"rx_%d_packets",
+	"rx_%d_bytes",
+	"rx_%d_dropped",
+	"rx_%d_multicast",
+	"rx_%d_no_descriptor_errors",
+	"rx_%d_buffer_too_small_errors",
+	"rx_%d_fifo_overflow_errors",
+	"rx_%d_invalid_frame_errors",
+};
+
+struct tsnep_rx_queue_stats {
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 rx_dropped;
+	u64 rx_multicast;
+	u64 rx_no_descriptor_errors;
+	u64 rx_buffer_too_small_errors;
+	u64 rx_fifo_overflow_errors;
+	u64 rx_invalid_frame_errors;
+};
+
+#define TSNEP_RX_QUEUE_STATS_COUNT (sizeof(struct tsnep_rx_queue_stats) / \
+				    sizeof(u64))
+
+static const char tsnep_tx_queue_stats_strings[][ETH_GSTRING_LEN] = {
+	"tx_%d_packets",
+	"tx_%d_bytes",
+	"tx_%d_dropped",
+};
+
+struct tsnep_tx_queue_stats {
+	u64 tx_packets;
+	u64 tx_bytes;
+	u64 tx_dropped;
+};
+
+#define TSNEP_TX_QUEUE_STATS_COUNT (sizeof(struct tsnep_tx_queue_stats) / \
+				    sizeof(u64))
+
+static void tsnep_ethtool_get_drvinfo(struct net_device *netdev,
+				      struct ethtool_drvinfo *drvinfo)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	strscpy(drvinfo->driver, TSNEP, sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, dev_name(&adapter->pdev->dev),
+		sizeof(drvinfo->bus_info));
+}
+
+static int tsnep_ethtool_get_regs_len(struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int len;
+	int num_additional_queues;
+
+	len = TSNEP_MAC_SIZE;
+
+	/* first queue pair is within TSNEP_MAC_SIZE, only queues additional to
+	 * the first queue pair extend the register length by TSNEP_QUEUE_SIZE
+	 */
+	num_additional_queues =
+		max(adapter->num_tx_queues, adapter->num_rx_queues) - 1;
+	len += TSNEP_QUEUE_SIZE * num_additional_queues;
+
+	return len;
+}
+
+static void tsnep_ethtool_get_regs(struct net_device *netdev,
+				   struct ethtool_regs *regs,
+				   void *p)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	regs->version = 1;
+
+	memcpy_fromio(p, adapter->addr, regs->len);
+}
+
+static u32 tsnep_ethtool_get_msglevel(struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	return adapter->msg_enable;
+}
+
+static void tsnep_ethtool_set_msglevel(struct net_device *netdev, u32 data)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	adapter->msg_enable = data;
+}
+
+static void tsnep_ethtool_get_strings(struct net_device *netdev, u32 stringset,
+				      u8 *data)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int rx_count = adapter->num_rx_queues;
+	int tx_count = adapter->num_tx_queues;
+	int i, j;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		memcpy(data, tsnep_stats_strings, sizeof(tsnep_stats_strings));
+		data += sizeof(tsnep_stats_strings);
+
+		for (i = 0; i < rx_count; i++) {
+			for (j = 0; j < TSNEP_RX_QUEUE_STATS_COUNT; j++) {
+				snprintf(data, ETH_GSTRING_LEN,
+					 tsnep_rx_queue_stats_strings[j], i);
+				data += ETH_GSTRING_LEN;
+			}
+		}
+
+		for (i = 0; i < tx_count; i++) {
+			for (j = 0; j < TSNEP_TX_QUEUE_STATS_COUNT; j++) {
+				snprintf(data, ETH_GSTRING_LEN,
+					 tsnep_tx_queue_stats_strings[j], i);
+				data += ETH_GSTRING_LEN;
+			}
+		}
+		break;
+	case ETH_SS_TEST:
+		tsnep_ethtool_get_test_strings(data);
+		break;
+	}
+}
+
+static void tsnep_ethtool_get_ethtool_stats(struct net_device *netdev,
+					    struct ethtool_stats *stats,
+					    u64 *data)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int rx_count = adapter->num_rx_queues;
+	int tx_count = adapter->num_tx_queues;
+	struct tsnep_stats tsnep_stats;
+	struct tsnep_rx_queue_stats tsnep_rx_queue_stats;
+	struct tsnep_tx_queue_stats tsnep_tx_queue_stats;
+	u32 reg;
+	int i;
+
+	memset(&tsnep_stats, 0, sizeof(tsnep_stats));
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		tsnep_stats.rx_packets += adapter->rx[i].packets;
+		tsnep_stats.rx_bytes += adapter->rx[i].bytes;
+		tsnep_stats.rx_dropped += adapter->rx[i].dropped;
+		tsnep_stats.rx_multicast += adapter->rx[i].multicast;
+	}
+	reg = ioread32(adapter->addr + ECM_STAT);
+	tsnep_stats.rx_phy_errors =
+		(reg & ECM_STAT_RX_ERR_MASK) >> ECM_STAT_RX_ERR_SHIFT;
+	tsnep_stats.rx_forwarded_phy_errors =
+		(reg & ECM_STAT_FWD_RX_ERR_MASK) >> ECM_STAT_FWD_RX_ERR_SHIFT;
+	tsnep_stats.rx_invalid_frame_errors =
+		(reg & ECM_STAT_INV_FRM_MASK) >> ECM_STAT_INV_FRM_SHIFT;
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		tsnep_stats.tx_packets += adapter->tx[i].packets;
+		tsnep_stats.tx_bytes += adapter->tx[i].bytes;
+		tsnep_stats.tx_dropped += adapter->tx[i].dropped;
+	}
+	memcpy(data, &tsnep_stats, sizeof(tsnep_stats));
+	data += TSNEP_STATS_COUNT;
+
+	for (i = 0; i < rx_count; i++) {
+		memset(&tsnep_rx_queue_stats, 0, sizeof(tsnep_rx_queue_stats));
+		tsnep_rx_queue_stats.rx_packets = adapter->rx[i].packets;
+		tsnep_rx_queue_stats.rx_bytes = adapter->rx[i].bytes;
+		tsnep_rx_queue_stats.rx_dropped = adapter->rx[i].dropped;
+		tsnep_rx_queue_stats.rx_multicast = adapter->rx[i].multicast;
+		reg = ioread32(adapter->addr + TSNEP_QUEUE(i) +
+			       TSNEP_RX_STATISTIC);
+		tsnep_rx_queue_stats.rx_no_descriptor_errors =
+			(reg & TSNEP_RX_STATISTIC_NO_DESC_MASK) >>
+			TSNEP_RX_STATISTIC_NO_DESC_SHIFT;
+		tsnep_rx_queue_stats.rx_buffer_too_small_errors =
+			(reg & TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_MASK) >>
+			TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_SHIFT;
+		tsnep_rx_queue_stats.rx_fifo_overflow_errors =
+			(reg & TSNEP_RX_STATISTIC_FIFO_OVERFLOW_MASK) >>
+			TSNEP_RX_STATISTIC_FIFO_OVERFLOW_SHIFT;
+		tsnep_rx_queue_stats.rx_invalid_frame_errors =
+			(reg & TSNEP_RX_STATISTIC_INVALID_FRAME_MASK) >>
+			TSNEP_RX_STATISTIC_INVALID_FRAME_SHIFT;
+		memcpy(data, &tsnep_rx_queue_stats,
+		       sizeof(tsnep_rx_queue_stats));
+		data += TSNEP_RX_QUEUE_STATS_COUNT;
+	}
+
+	for (i = 0; i < tx_count; i++) {
+		memset(&tsnep_tx_queue_stats, 0, sizeof(tsnep_tx_queue_stats));
+		tsnep_tx_queue_stats.tx_packets += adapter->tx[i].packets;
+		tsnep_tx_queue_stats.tx_bytes += adapter->tx[i].bytes;
+		tsnep_tx_queue_stats.tx_dropped += adapter->tx[i].dropped;
+		memcpy(data, &tsnep_tx_queue_stats,
+		       sizeof(tsnep_tx_queue_stats));
+		data += TSNEP_TX_QUEUE_STATS_COUNT;
+	}
+}
+
+static int tsnep_ethtool_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int rx_count;
+	int tx_count;
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		rx_count = adapter->num_rx_queues;
+		tx_count = adapter->num_tx_queues;
+		return TSNEP_STATS_COUNT +
+		       TSNEP_RX_QUEUE_STATS_COUNT * rx_count +
+		       TSNEP_TX_QUEUE_STATS_COUNT * tx_count;
+	case ETH_SS_TEST:
+		return tsnep_ethtool_get_test_count();
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int tsnep_ethtool_get_ts_info(struct net_device *dev,
+				     struct ethtool_ts_info *info)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	if (adapter->ptp_clock)
+		info->phc_index = ptp_clock_index(adapter->ptp_clock);
+	else
+		info->phc_index = -1;
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
+const struct ethtool_ops tsnep_ethtool_ops = {
+	.get_drvinfo = tsnep_ethtool_get_drvinfo,
+	.get_regs_len = tsnep_ethtool_get_regs_len,
+	.get_regs = tsnep_ethtool_get_regs,
+	.get_msglevel = tsnep_ethtool_get_msglevel,
+	.set_msglevel = tsnep_ethtool_set_msglevel,
+	.nway_reset = phy_ethtool_nway_reset,
+	.get_link = ethtool_op_get_link,
+	.self_test = tsnep_ethtool_self_test,
+	.get_strings = tsnep_ethtool_get_strings,
+	.get_ethtool_stats = tsnep_ethtool_get_ethtool_stats,
+	.get_sset_count = tsnep_ethtool_get_sset_count,
+	.get_ts_info = tsnep_ethtool_get_ts_info,
+	.get_link_ksettings = phy_ethtool_get_link_ksettings,
+	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+};
diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
new file mode 100644
index 000000000000..71cc8577d640
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+/* Hardware definition of TSNEP and EtherCAT MAC device */
+
+#ifndef _TSNEP_HW_H
+#define _TSNEP_HW_H
+
+#include <linux/types.h>
+
+/* type */
+#define ECM_TYPE 0x0000
+#define ECM_REVISION_MASK 0x000000FF
+#define ECM_REVISION_SHIFT 0
+#define ECM_VERSION_MASK 0x0000FF00
+#define ECM_VERSION_SHIFT 8
+#define ECM_QUEUE_COUNT_MASK 0x00070000
+#define ECM_QUEUE_COUNT_SHIFT 16
+#define ECM_GATE_CONTROL 0x02000000
+
+/* system time */
+#define ECM_SYSTEM_TIME_LOW 0x0008
+#define ECM_SYSTEM_TIME_HIGH 0x000C
+
+/* clock */
+#define ECM_CLOCK_RATE 0x0010
+#define ECM_CLOCK_RATE_OFFSET_MASK 0x7FFFFFFF
+#define ECM_CLOCK_RATE_OFFSET_SIGN 0x80000000
+
+/* interrupt */
+#define ECM_INT_ENABLE 0x0018
+#define ECM_INT_ACTIVE 0x001C
+#define ECM_INT_ACKNOWLEDGE 0x001C
+#define ECM_INT_LINK 0x00000020
+#define ECM_INT_TX_0 0x00000100
+#define ECM_INT_RX_0 0x00000200
+#define ECM_INT_ALL 0x7FFFFFFF
+#define ECM_INT_DISABLE 0x80000000
+
+/* reset */
+#define ECM_RESET 0x0020
+#define ECM_RESET_COMMON 0x00000001
+#define ECM_RESET_CHANNEL 0x00000100
+#define ECM_RESET_TXRX 0x00010000
+
+/* control and status */
+#define ECM_STATUS 0x0080
+#define ECM_LINK_MODE_OFF 0x01000000
+#define ECM_LINK_MODE_100 0x02000000
+#define ECM_LINK_MODE_1000 0x04000000
+#define ECM_NO_LINK 0x01000000
+#define ECM_LINK_MODE_MASK 0x06000000
+
+/* management data */
+#define ECM_MD_CONTROL 0x0084
+#define ECM_MD_STATUS 0x0084
+#define ECM_MD_PREAMBLE 0x00000001
+#define ECM_MD_READ 0x00000004
+#define ECM_MD_WRITE 0x00000002
+#define ECM_MD_ADDR_MASK 0x000000F8
+#define ECM_MD_ADDR_SHIFT 3
+#define ECM_MD_PHY_ADDR_MASK 0x00001F00
+#define ECM_MD_PHY_ADDR_SHIFT 8
+#define ECM_MD_BUSY 0x00000001
+#define ECM_MD_DATA_MASK 0xFFFF0000
+#define ECM_MD_DATA_SHIFT 16
+
+/* statistic */
+#define ECM_STAT 0x00B0
+#define ECM_STAT_RX_ERR_MASK 0x000000FF
+#define ECM_STAT_RX_ERR_SHIFT 0
+#define ECM_STAT_INV_FRM_MASK 0x0000FF00
+#define ECM_STAT_INV_FRM_SHIFT 8
+#define ECM_STAT_FWD_RX_ERR_MASK 0x00FF0000
+#define ECM_STAT_FWD_RX_ERR_SHIFT 16
+
+/* tsnep */
+#define TSNEP_MAC_SIZE 0x4000
+#define TSNEP_QUEUE_SIZE 0x1000
+#define TSNEP_QUEUE(n) ({ typeof(n) __n = (n); \
+			  (__n) == 0 ? \
+			  0 : \
+			  TSNEP_MAC_SIZE + TSNEP_QUEUE_SIZE * ((__n) - 1); })
+#define TSNEP_MAX_QUEUES 8
+#define TSNEP_MAX_FRAME_SIZE (2 * 1024) /* hardware supports actually 16k */
+#define TSNEP_DESC_SIZE 256
+#define TSNEP_DESC_OFFSET 128
+
+/* tsnep register */
+#define TSNEP_INFO 0x0100
+#define TSNEP_INFO_RX_ASSIGN 0x00010000
+#define TSNEP_INFO_TX_TIME 0x00020000
+#define TSNEP_CONTROL 0x0108
+#define TSNEP_CONTROL_TX_RESET 0x00000001
+#define TSNEP_CONTROL_TX_ENABLE 0x00000002
+#define TSNEP_CONTROL_TX_DMA_ERROR 0x00000010
+#define TSNEP_CONTROL_TX_DESC_ERROR 0x00000020
+#define TSNEP_CONTROL_RX_RESET 0x00000100
+#define TSNEP_CONTROL_RX_ENABLE 0x00000200
+#define TSNEP_CONTROL_RX_DISABLE 0x00000400
+#define TSNEP_CONTROL_RX_DMA_ERROR 0x00001000
+#define TSNEP_CONTROL_RX_DESC_ERROR 0x00002000
+#define TSNEP_TX_DESC_ADDR_LOW 0x0140
+#define TSNEP_TX_DESC_ADDR_HIGH 0x0144
+#define TSNEP_RX_DESC_ADDR_LOW 0x0180
+#define TSNEP_RX_DESC_ADDR_HIGH 0x0184
+#define TSNEP_RESET_OWNER_COUNTER 0x01
+#define TSNEP_RX_STATISTIC 0x0190
+#define TSNEP_RX_STATISTIC_NO_DESC_MASK 0x000000FF
+#define TSNEP_RX_STATISTIC_NO_DESC_SHIFT 0
+#define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_MASK 0x0000FF00
+#define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_SHIFT 8
+#define TSNEP_RX_STATISTIC_FIFO_OVERFLOW_MASK 0x00FF0000
+#define TSNEP_RX_STATISTIC_FIFO_OVERFLOW_SHIFT 16
+#define TSNEP_RX_STATISTIC_INVALID_FRAME_MASK 0xFF000000
+#define TSNEP_RX_STATISTIC_INVALID_FRAME_SHIFT 24
+#define TSNEP_RX_STATISTIC_NO_DESC 0x0190
+#define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL 0x0191
+#define TSNEP_RX_STATISTIC_FIFO_OVERFLOW 0x0192
+#define TSNEP_RX_STATISTIC_INVALID_FRAME 0x0193
+#define TSNEP_RX_ASSIGN 0x01A0
+#define TSNEP_RX_ASSIGN_ETHER_TYPE_ACTIVE 0x00000001
+#define TSNEP_RX_ASSIGN_ETHER_TYPE_MASK 0xFFFF0000
+#define TSNEP_RX_ASSIGN_ETHER_TYPE_SHIFT 16
+#define TSNEP_MAC_ADDRESS_LOW 0x0800
+#define TSNEP_MAC_ADDRESS_HIGH 0x0804
+#define TSNEP_RX_FILTER 0x0806
+#define TSNEP_RX_FILTER_ACCEPT_ALL_MULTICASTS 0x0001
+#define TSNEP_RX_FILTER_ACCEPT_ALL_UNICASTS 0x0002
+#define TSNEP_GC 0x0808
+#define TSNEP_GC_ENABLE_A 0x00000002
+#define TSNEP_GC_ENABLE_B 0x00000004
+#define TSNEP_GC_DISABLE 0x00000008
+#define TSNEP_GC_ENABLE_TIMEOUT 0x00000010
+#define TSNEP_GC_ACTIVE_A 0x00000002
+#define TSNEP_GC_ACTIVE_B 0x00000004
+#define TSNEP_GC_CHANGE_AB 0x00000008
+#define TSNEP_GC_TIMEOUT_ACTIVE 0x00000010
+#define TSNEP_GC_TIMEOUT_SIGNAL 0x00000020
+#define TSNEP_GC_LIST_ERROR 0x00000080
+#define TSNEP_GC_OPEN 0x00FF0000
+#define TSNEP_GC_OPEN_SHIFT 16
+#define TSNEP_GC_NEXT_OPEN 0xFF000000
+#define TSNEP_GC_NEXT_OPEN_SHIFT 24
+#define TSNEP_GC_TIMEOUT 131072
+#define TSNEP_GC_TIME 0x080C
+#define TSNEP_GC_CHANGE 0x0810
+#define TSNEP_GCL_A 0x2000
+#define TSNEP_GCL_B 0x2800
+#define TSNEP_GCL_SIZE SZ_2K
+
+/* tsnep gate control list operation */
+struct tsnep_gcl_operation {
+	u32 properties;
+	u32 interval;
+};
+
+#define TSNEP_GCL_COUNT (TSNEP_GCL_SIZE / sizeof(struct tsnep_gcl_operation))
+#define TSNEP_GCL_MASK 0x000000FF
+#define TSNEP_GCL_INSERT 0x20000000
+#define TSNEP_GCL_CHANGE 0x40000000
+#define TSNEP_GCL_LAST 0x80000000
+#define TSNEP_GCL_MIN_INTERVAL 32
+
+/* tsnep TX/RX descriptor */
+#define TSNEP_DESC_SIZE 256
+#define TSNEP_DESC_SIZE_DATA_AFTER 2048
+#define TSNEP_DESC_OFFSET 128
+#define TSNEP_DESC_OWNER_COUNTER_MASK 0xC0000000
+#define TSNEP_DESC_OWNER_COUNTER_SHIFT 30
+#define TSNEP_DESC_LENGTH_MASK 0x00003FFF
+#define TSNEP_DESC_INTERRUPT_FLAG 0x00040000
+#define TSNEP_DESC_EXTENDED_WRITEBACK_FLAG 0x00080000
+#define TSNEP_DESC_NO_LINK_FLAG 0x01000000
+
+/* tsnep TX descriptor */
+struct tsnep_tx_desc {
+	__le32 properties;
+	__le32 more_properties;
+	__le32 reserved[2];
+	__le64 next;
+	__le64 tx;
+};
+
+#define TSNEP_TX_DESC_OWNER_MASK 0xE0000000
+#define TSNEP_TX_DESC_OWNER_USER_FLAG 0x20000000
+#define TSNEP_TX_DESC_LAST_FRAGMENT_FLAG 0x00010000
+#define TSNEP_TX_DESC_DATA_AFTER_DESC_FLAG 0x00020000
+
+/* tsnep TX descriptor writeback */
+struct tsnep_tx_desc_wb {
+	__le32 properties;
+	__le32 reserved1[3];
+	__le64 timestamp;
+	__le32 dma_delay;
+	__le32 reserved2;
+};
+
+#define TSNEP_TX_DESC_UNDERRUN_ERROR_FLAG 0x00010000
+#define TSNEP_TX_DESC_DMA_DELAY_FIRST_DATA_MASK 0x0000FFFC
+#define TSNEP_TX_DESC_DMA_DELAY_FIRST_DATA_SHIFT 2
+#define TSNEP_TX_DESC_DMA_DELAY_LAST_DATA_MASK 0xFFFC0000
+#define TSNEP_TX_DESC_DMA_DELAY_LAST_DATA_SHIFT 18
+#define TSNEP_TX_DESC_DMA_DELAY_NS 64
+
+/* tsnep RX descriptor */
+struct tsnep_rx_desc {
+	__le32 properties;
+	__le32 reserved[3];
+	__le64 next;
+	__le64 rx;
+};
+
+#define TSNEP_RX_DESC_BUFFER_SIZE_MASK 0x00003FFC
+
+/* tsnep RX descriptor writeback */
+struct tsnep_rx_desc_wb {
+	__le32 properties;
+	__le32 reserved[7];
+};
+
+/* tsnep RX inline meta */
+struct tsnep_rx_inline {
+	__le64 reserved;
+	__le64 timestamp;
+};
+
+#define TSNEP_RX_INLINE_METADATA_SIZE (sizeof(struct tsnep_rx_inline))
+
+#endif /* _TSNEP_HW_H */
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
new file mode 100644
index 000000000000..c965744e9530
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -0,0 +1,1273 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+/* TSN endpoint Ethernet MAC driver
+ *
+ * The TSN endpoint Ethernet MAC is a FPGA based network device for real-time
+ * communication. It is designed for endpoints within TSN (Time Sensitive
+ * Networking) networks; e.g., for PLCs in the industrial automation case.
+ *
+ * It supports multiple TX/RX queue pairs. The first TX/RX queue pair is used
+ * by the driver.
+ *
+ * More information can be found here:
+ * - www.embedded-experts.at/tsn
+ * - www.engleder-embedded.com
+ */
+
+#include "tsnep.h"
+#include "tsnep_hw.h"
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/of_mdio.h>
+#include <linux/interrupt.h>
+#include <linux/etherdevice.h>
+#include <linux/phy.h>
+#include <linux/iopoll.h>
+
+#define RX_SKB_LENGTH (round_up(TSNEP_RX_INLINE_METADATA_SIZE + ETH_HLEN + \
+				TSNEP_MAX_FRAME_SIZE + ETH_FCS_LEN, 4))
+#define RX_SKB_RESERVE ((16 - TSNEP_RX_INLINE_METADATA_SIZE) + NET_IP_ALIGN)
+#define RX_SKB_ALLOC_LENGTH (RX_SKB_RESERVE + RX_SKB_LENGTH)
+
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#define DMA_ADDR_HIGH(dma_addr) ((u32)(((dma_addr) >> 32) & 0xFFFFFFFF))
+#else
+#define DMA_ADDR_HIGH(dma_addr) ((u32)(0))
+#endif
+#define DMA_ADDR_LOW(dma_addr) ((u32)((dma_addr) & 0xFFFFFFFF))
+
+static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
+{
+	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
+}
+
+static void tsnep_disable_irq(struct tsnep_adapter *adapter, u32 mask)
+{
+	mask |= ECM_INT_DISABLE;
+	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
+}
+
+static irqreturn_t tsnep_irq(int irq, void *arg)
+{
+	struct tsnep_adapter *adapter = arg;
+	u32 active = ioread32(adapter->addr + ECM_INT_ACTIVE);
+
+	/* acknowledge interrupt */
+	if (active != 0)
+		iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
+
+	/* handle link interrupt */
+	if ((active & ECM_INT_LINK) != 0) {
+		if (adapter->netdev->phydev)
+			phy_mac_interrupt(adapter->netdev->phydev);
+	}
+
+	/* handle TX/RX queue 0 interrupt */
+	if ((active & adapter->queue[0].irq_mask) != 0) {
+		if (adapter->netdev) {
+			tsnep_disable_irq(adapter, adapter->queue[0].irq_mask);
+			napi_schedule(&adapter->queue[0].napi);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct tsnep_adapter *adapter = bus->priv;
+	u32 md;
+	int retval;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	md = ECM_MD_READ;
+	if (!adapter->suppress_preamble)
+		md |= ECM_MD_PREAMBLE;
+	md |= (regnum << ECM_MD_ADDR_SHIFT) & ECM_MD_ADDR_MASK;
+	md |= (addr << ECM_MD_PHY_ADDR_SHIFT) & ECM_MD_PHY_ADDR_MASK;
+	iowrite32(md, adapter->addr + ECM_MD_CONTROL);
+	retval = readl_poll_timeout_atomic(adapter->addr + ECM_MD_STATUS, md,
+					   !(md & ECM_MD_BUSY), 16, 1000);
+	if (retval != 0)
+		return retval;
+
+	return (md & ECM_MD_DATA_MASK) >> ECM_MD_DATA_SHIFT;
+}
+
+static int tsnep_mdiobus_write(struct mii_bus *bus, int addr, int regnum,
+			       u16 val)
+{
+	struct tsnep_adapter *adapter = bus->priv;
+	u32 md;
+	int retval;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	md = ECM_MD_WRITE;
+	if (!adapter->suppress_preamble)
+		md |= ECM_MD_PREAMBLE;
+	md |= (regnum << ECM_MD_ADDR_SHIFT) & ECM_MD_ADDR_MASK;
+	md |= (addr << ECM_MD_PHY_ADDR_SHIFT) & ECM_MD_PHY_ADDR_MASK;
+	md |= ((u32)val << ECM_MD_DATA_SHIFT) & ECM_MD_DATA_MASK;
+	iowrite32(md, adapter->addr + ECM_MD_CONTROL);
+	retval = readl_poll_timeout_atomic(adapter->addr + ECM_MD_STATUS, md,
+					   !(md & ECM_MD_BUSY), 16, 1000);
+	if (retval != 0)
+		return retval;
+
+	return 0;
+}
+
+static void tsnep_phy_link_status_change(struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	u32 mode;
+
+	if (phydev->link) {
+		switch (phydev->speed) {
+		case SPEED_100:
+			mode = ECM_LINK_MODE_100;
+			break;
+		case SPEED_1000:
+			mode = ECM_LINK_MODE_1000;
+			break;
+		default:
+			mode = ECM_LINK_MODE_OFF;
+			break;
+		}
+		iowrite32(mode, adapter->addr + ECM_STATUS);
+	}
+
+	phy_print_status(netdev->phydev);
+}
+
+static int tsnep_phy_open(struct tsnep_adapter *adapter)
+{
+	struct phy_device *phydev;
+	struct ethtool_eee ethtool_eee;
+	int retval;
+
+	retval = phy_connect_direct(adapter->netdev, adapter->phydev,
+				    tsnep_phy_link_status_change,
+				    adapter->phy_mode);
+	if (retval)
+		return retval;
+	phydev = adapter->netdev->phydev;
+
+	/* MAC supports only 100Mbps|1000Mbps full duplex
+	 * SPE (Single Pair Ethernet) is also an option but not implemented yet
+	 */
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+
+	/* disable EEE autoneg, EEE not supported by TSNEP */
+	memset(&ethtool_eee, 0, sizeof(ethtool_eee));
+	phy_ethtool_set_eee(adapter->phydev, &ethtool_eee);
+
+	adapter->phydev->irq = PHY_MAC_INTERRUPT;
+	phy_start(adapter->phydev);
+
+	return 0;
+}
+
+static void tsnep_phy_close(struct tsnep_adapter *adapter)
+{
+	phy_stop(adapter->netdev->phydev);
+	phy_disconnect(adapter->netdev->phydev);
+	adapter->netdev->phydev = NULL;
+}
+
+static void tsnep_tx_ring_cleanup(struct tsnep_tx *tx)
+{
+	struct device *dmadev = tx->adapter->dmadev;
+	int i;
+
+	memset(tx->entry, 0, sizeof(tx->entry));
+
+	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
+		if (tx->page[i]) {
+			dma_free_coherent(dmadev, PAGE_SIZE, tx->page[i],
+					  tx->page_dma[i]);
+			tx->page[i] = NULL;
+			tx->page_dma[i] = 0;
+		}
+	}
+}
+
+static int tsnep_tx_ring_init(struct tsnep_tx *tx)
+{
+	struct device *dmadev = tx->adapter->dmadev;
+	struct tsnep_tx_entry *entry;
+	struct tsnep_tx_entry *next_entry;
+	int i, j;
+	int retval;
+
+	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
+		tx->page[i] =
+			dma_alloc_coherent(dmadev, PAGE_SIZE, &tx->page_dma[i],
+					   GFP_KERNEL);
+		if (!tx->page[i]) {
+			retval = -ENOMEM;
+			goto alloc_failed;
+		}
+		for (j = 0; j < TSNEP_RING_ENTRIES_PER_PAGE; j++) {
+			entry = &tx->entry[TSNEP_RING_ENTRIES_PER_PAGE * i + j];
+			entry->desc_wb = (struct tsnep_tx_desc_wb *)
+				(((u8 *)tx->page[i]) + TSNEP_DESC_SIZE * j);
+			entry->desc = (struct tsnep_tx_desc *)
+				(((u8 *)entry->desc_wb) + TSNEP_DESC_OFFSET);
+			entry->desc_dma = tx->page_dma[i] + TSNEP_DESC_SIZE * j;
+		}
+	}
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		entry = &tx->entry[i];
+		next_entry = &tx->entry[(i + 1) % TSNEP_RING_SIZE];
+		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
+	}
+
+	return 0;
+
+alloc_failed:
+	tsnep_tx_ring_cleanup(tx);
+	return retval;
+}
+
+static void tsnep_tx_activate(struct tsnep_tx *tx, int index, bool last)
+{
+	struct tsnep_tx_entry *entry = &tx->entry[index];
+
+	entry->properties = 0;
+	if (entry->skb) {
+		entry->properties =
+			skb_pagelen(entry->skb) & TSNEP_DESC_LENGTH_MASK;
+		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
+		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
+			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
+
+		/* toggle user flag to prevent false acknowledge
+		 *
+		 * Only the first fragment is acknowledged. For all other
+		 * fragments no acknowledge is done and the last written owner
+		 * counter stays in the writeback descriptor. Therefore, it is
+		 * possible that the last written owner counter is identical to
+		 * the new incremented owner counter and a false acknowledge is
+		 * detected before the real acknowledge has been done by
+		 * hardware.
+		 *
+		 * The user flag is used to prevent this situation. The user
+		 * flag is copied to the writeback descriptor by the hardware
+		 * and is used as additional acknowledge data. By toggeling the
+		 * user flag only for the first fragment (which is
+		 * acknowledged), it is guaranteed that the last acknowledge
+		 * done for this descriptor has used a different user flag and
+		 * cannot be detected as false acknowledge.
+		 */
+		entry->owner_user_flag = !entry->owner_user_flag;
+	}
+	if (last)
+		entry->properties |= TSNEP_TX_DESC_LAST_FRAGMENT_FLAG;
+	if (index == tx->increment_owner_counter) {
+		tx->owner_counter++;
+		if (tx->owner_counter == 4)
+			tx->owner_counter = 1;
+		tx->increment_owner_counter--;
+		if (tx->increment_owner_counter < 0)
+			tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+	}
+	entry->properties |=
+		(tx->owner_counter << TSNEP_DESC_OWNER_COUNTER_SHIFT) &
+		TSNEP_DESC_OWNER_COUNTER_MASK;
+	if (entry->owner_user_flag)
+		entry->properties |= TSNEP_TX_DESC_OWNER_USER_FLAG;
+	entry->desc->more_properties =
+		__cpu_to_le32(entry->len & TSNEP_DESC_LENGTH_MASK);
+
+	/* descriptor properties shall be written last, because valid data is
+	 * signaled there
+	 */
+	dma_wmb();
+
+	entry->desc->properties = __cpu_to_le32(entry->properties);
+}
+
+static int tsnep_tx_desc_available(struct tsnep_tx *tx)
+{
+	if (tx->read <= tx->write)
+		return TSNEP_RING_SIZE - tx->write + tx->read - 1;
+	else
+		return tx->read - tx->write - 1;
+}
+
+static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
+{
+	struct device *dmadev = tx->adapter->dmadev;
+	struct tsnep_tx_entry *entry;
+	unsigned int len;
+	dma_addr_t dma;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
+
+		if (i == 0) {
+			len = skb_headlen(skb);
+			dma = dma_map_single(dmadev, skb->data, len,
+					     DMA_TO_DEVICE);
+		} else {
+			len = skb_frag_size(&skb_shinfo(skb)->frags[i - 1]);
+			dma = skb_frag_dma_map(dmadev,
+					       &skb_shinfo(skb)->frags[i - 1],
+					       0, len, DMA_TO_DEVICE);
+		}
+		if (dma_mapping_error(dmadev, dma))
+			return -ENOMEM;
+
+		entry->len = len;
+		dma_unmap_addr_set(entry, dma, dma);
+
+		entry->desc->tx = __cpu_to_le64(dma);
+	}
+
+	return 0;
+}
+
+static void tsnep_tx_unmap(struct tsnep_tx *tx, int count)
+{
+	struct device *dmadev = tx->adapter->dmadev;
+	struct tsnep_tx_entry *entry;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		entry = &tx->entry[(tx->read + i) % TSNEP_RING_SIZE];
+
+		if (entry->len) {
+			if (i == 0)
+				dma_unmap_single(dmadev,
+						 dma_unmap_addr(entry, dma),
+						 dma_unmap_len(entry, len),
+						 DMA_TO_DEVICE);
+			else
+				dma_unmap_page(dmadev,
+					       dma_unmap_addr(entry, dma),
+					       dma_unmap_len(entry, len),
+					       DMA_TO_DEVICE);
+			entry->len = 0;
+		}
+	}
+}
+
+static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
+					 struct tsnep_tx *tx)
+{
+	unsigned long flags;
+	int count = 1;
+	struct tsnep_tx_entry *entry;
+	int i;
+	int retval;
+
+	if (skb_shinfo(skb)->nr_frags > 0)
+		count += skb_shinfo(skb)->nr_frags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	if (tsnep_tx_desc_available(tx) < count) {
+		/* ring full, shall not happen because queue is stopped if full
+		 * below
+		 */
+		netif_stop_queue(tx->adapter->netdev);
+
+		spin_unlock_irqrestore(&tx->lock, flags);
+
+		return NETDEV_TX_BUSY;
+	}
+
+	entry = &tx->entry[tx->write];
+	entry->skb = skb;
+
+	retval = tsnep_tx_map(skb, tx, count);
+	if (retval != 0) {
+		tsnep_tx_unmap(tx, count);
+		dev_kfree_skb_any(entry->skb);
+		entry->skb = NULL;
+
+		tx->dropped++;
+
+		spin_unlock_irqrestore(&tx->lock, flags);
+
+		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
+
+		return NETDEV_TX_OK;
+	}
+
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	for (i = 0; i < count; i++)
+		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE,
+				  i == (count - 1));
+	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
+
+	skb_tx_timestamp(skb);
+
+	/* descriptor properties shall be valid before hardware is notified */
+	dma_wmb();
+
+	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
+
+	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1)) {
+		/* ring can get full with next frame */
+		netif_stop_queue(tx->adapter->netdev);
+	}
+
+	tx->packets++;
+	tx->bytes += skb_pagelen(entry->skb) + ETH_FCS_LEN;
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	return NETDEV_TX_OK;
+}
+
+static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
+{
+	unsigned long flags;
+	int budget = 128;
+	struct tsnep_tx_entry *entry;
+	int count;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	do {
+		if (tx->read == tx->write)
+			break;
+
+		entry = &tx->entry[tx->read];
+		if ((__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_TX_DESC_OWNER_MASK) !=
+		    (entry->properties & TSNEP_TX_DESC_OWNER_MASK))
+			break;
+
+		/* descriptor properties shall be read first, because valid data
+		 * is signaled there
+		 */
+		dma_rmb();
+
+		count = 1;
+		if (skb_shinfo(entry->skb)->nr_frags > 0)
+			count += skb_shinfo(entry->skb)->nr_frags;
+
+		tsnep_tx_unmap(tx, count);
+
+		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
+		    (__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
+			struct skb_shared_hwtstamps hwtstamps;
+			u64 timestamp =
+				__le64_to_cpu(entry->desc_wb->timestamp);
+
+			memset(&hwtstamps, 0, sizeof(hwtstamps));
+			hwtstamps.hwtstamp = ns_to_ktime(timestamp);
+
+			skb_tstamp_tx(entry->skb, &hwtstamps);
+		}
+
+		napi_consume_skb(entry->skb, budget);
+		entry->skb = NULL;
+
+		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
+
+		budget--;
+	} while (likely(budget));
+
+	if ((tsnep_tx_desc_available(tx) >= ((MAX_SKB_FRAGS + 1) * 2)) &&
+	    netif_queue_stopped(tx->adapter->netdev)) {
+		netif_wake_queue(tx->adapter->netdev);
+	}
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	return (budget != 0);
+}
+
+static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
+			 struct tsnep_tx *tx)
+{
+	dma_addr_t dma;
+	int retval;
+
+	memset(tx, 0, sizeof(*tx));
+	tx->adapter = adapter;
+	tx->addr = addr;
+
+	retval = tsnep_tx_ring_init(tx);
+	if (retval)
+		return retval;
+
+	dma = tx->entry[0].desc_dma | TSNEP_RESET_OWNER_COUNTER;
+	iowrite32(DMA_ADDR_LOW(dma), tx->addr + TSNEP_TX_DESC_ADDR_LOW);
+	iowrite32(DMA_ADDR_HIGH(dma), tx->addr + TSNEP_TX_DESC_ADDR_HIGH);
+	tx->owner_counter = 1;
+	tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+
+	spin_lock_init(&tx->lock);
+
+	return 0;
+}
+
+static void tsnep_tx_close(struct tsnep_tx *tx)
+{
+	u32 val;
+
+	readx_poll_timeout(ioread32, tx->addr + TSNEP_CONTROL, val,
+			   ((val & TSNEP_CONTROL_TX_ENABLE) == 0), 10000,
+			   1000000);
+
+	tsnep_tx_ring_cleanup(tx);
+}
+
+static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
+{
+	struct device *dmadev = rx->adapter->dmadev;
+	struct tsnep_rx_entry *entry;
+	int i;
+
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		entry = &rx->entry[i];
+		if (dma_unmap_addr(entry, dma))
+			dma_unmap_single(dmadev, dma_unmap_addr(entry, dma),
+					 dma_unmap_len(entry, len),
+					 DMA_FROM_DEVICE);
+		if (entry->skb)
+			dev_kfree_skb(entry->skb);
+	}
+
+	memset(rx->entry, 0, sizeof(rx->entry));
+
+	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
+		if (rx->page[i]) {
+			dma_free_coherent(dmadev, PAGE_SIZE, rx->page[i],
+					  rx->page_dma[i]);
+			rx->page[i] = NULL;
+			rx->page_dma[i] = 0;
+		}
+	}
+}
+
+static int tsnep_rx_alloc_and_map_skb(struct tsnep_rx *rx,
+				      struct tsnep_rx_entry *entry)
+{
+	struct device *dmadev = rx->adapter->dmadev;
+	struct sk_buff *skb;
+	dma_addr_t dma;
+
+	skb = __netdev_alloc_skb(rx->adapter->netdev, RX_SKB_ALLOC_LENGTH,
+				 GFP_ATOMIC | GFP_DMA);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, RX_SKB_RESERVE);
+
+	dma = dma_map_single(dmadev, skb->data, RX_SKB_LENGTH,
+			     DMA_FROM_DEVICE);
+	if (dma_mapping_error(dmadev, dma)) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	entry->skb = skb;
+	entry->len = RX_SKB_LENGTH;
+	dma_unmap_addr_set(entry, dma, dma);
+	entry->desc->rx = __cpu_to_le64(dma);
+
+	return 0;
+}
+
+static int tsnep_rx_ring_init(struct tsnep_rx *rx)
+{
+	struct device *dmadev = rx->adapter->dmadev;
+	struct tsnep_rx_entry *entry;
+	struct tsnep_rx_entry *next_entry;
+	int i, j;
+	int retval;
+
+	for (i = 0; i < TSNEP_RING_PAGE_COUNT; i++) {
+		rx->page[i] =
+			dma_alloc_coherent(dmadev, PAGE_SIZE, &rx->page_dma[i],
+					   GFP_KERNEL);
+		if (!rx->page[i]) {
+			retval = -ENOMEM;
+			goto failed;
+		}
+		for (j = 0; j < TSNEP_RING_ENTRIES_PER_PAGE; j++) {
+			entry = &rx->entry[TSNEP_RING_ENTRIES_PER_PAGE * i + j];
+			entry->desc_wb = (struct tsnep_rx_desc_wb *)
+				(((u8 *)rx->page[i]) + TSNEP_DESC_SIZE * j);
+			entry->desc = (struct tsnep_rx_desc *)
+				(((u8 *)entry->desc_wb) + TSNEP_DESC_OFFSET);
+			entry->desc_dma = rx->page_dma[i] + TSNEP_DESC_SIZE * j;
+		}
+	}
+	for (i = 0; i < TSNEP_RING_SIZE; i++) {
+		entry = &rx->entry[i];
+		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
+		entry->desc->next = __cpu_to_le64(next_entry->desc_dma);
+
+		retval = tsnep_rx_alloc_and_map_skb(rx, entry);
+		if (retval)
+			goto failed;
+	}
+
+	return 0;
+
+failed:
+	tsnep_rx_ring_cleanup(rx);
+	return retval;
+}
+
+static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
+{
+	struct tsnep_rx_entry *entry = &rx->entry[index];
+
+	/* RX_SKB_LENGTH is a multiple of 4 */
+	entry->properties = entry->len & TSNEP_DESC_LENGTH_MASK;
+	entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
+	if (index == rx->increment_owner_counter) {
+		rx->owner_counter++;
+		if (rx->owner_counter == 4)
+			rx->owner_counter = 1;
+		rx->increment_owner_counter--;
+		if (rx->increment_owner_counter < 0)
+			rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+	}
+	entry->properties |=
+		(rx->owner_counter << TSNEP_DESC_OWNER_COUNTER_SHIFT) &
+		TSNEP_DESC_OWNER_COUNTER_MASK;
+
+	/* descriptor properties shall be written last, because valid data is
+	 * signaled there
+	 */
+	dma_wmb();
+
+	entry->desc->properties = __cpu_to_le32(entry->properties);
+}
+
+static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
+			 int budget)
+{
+	struct device *dmadev = rx->adapter->dmadev;
+	int done = 0;
+	struct tsnep_rx_entry *entry;
+	struct sk_buff *skb;
+	size_t len;
+	dma_addr_t dma;
+	int length;
+	bool enable = false;
+	int retval;
+
+	while (likely(done < budget)) {
+		entry = &rx->entry[rx->read];
+		if ((__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
+		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
+			break;
+
+		/* descriptor properties shall be read first, because valid data
+		 * is signaled there
+		 */
+		dma_rmb();
+
+		skb = entry->skb;
+		len = dma_unmap_len(entry, len);
+		dma = dma_unmap_addr(entry, dma);
+
+		/* forward skb only if allocation is successful, otherwise
+		 * skb is reused and frame dropped
+		 */
+		retval = tsnep_rx_alloc_and_map_skb(rx, entry);
+		if (!retval) {
+			dma_unmap_single(dmadev, dma, len, DMA_FROM_DEVICE);
+
+			length = __le32_to_cpu(entry->desc_wb->properties) &
+				 TSNEP_DESC_LENGTH_MASK;
+			skb_put(skb, length - ETH_FCS_LEN);
+			if (rx->adapter->hwtstamp_config.rx_filter ==
+			    HWTSTAMP_FILTER_ALL) {
+				struct skb_shared_hwtstamps *hwtstamps =
+					skb_hwtstamps(skb);
+				struct tsnep_rx_inline *rx_inline =
+					(struct tsnep_rx_inline *)skb->data;
+				u64 timestamp =
+					__le64_to_cpu(rx_inline->timestamp);
+
+				memset(hwtstamps, 0, sizeof(*hwtstamps));
+				hwtstamps->hwtstamp = ns_to_ktime(timestamp);
+			}
+			skb_pull(skb, TSNEP_RX_INLINE_METADATA_SIZE);
+			skb->protocol = eth_type_trans(skb,
+						       rx->adapter->netdev);
+
+			rx->packets++;
+			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
+			if (skb->pkt_type == PACKET_MULTICAST)
+				rx->multicast++;
+
+			napi_gro_receive(napi, skb);
+			done++;
+		} else {
+			rx->dropped++;
+		}
+
+		tsnep_rx_activate(rx, rx->read);
+
+		enable = true;
+
+		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
+	}
+
+	if (enable) {
+		/* descriptor properties shall be valid before hardware is
+		 * notified
+		 */
+		dma_wmb();
+
+		iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
+	}
+
+	return done;
+}
+
+static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
+			 struct tsnep_rx *rx)
+{
+	dma_addr_t dma;
+	int i;
+	int retval;
+
+	memset(rx, 0, sizeof(*rx));
+	rx->adapter = adapter;
+	rx->addr = addr;
+
+	retval = tsnep_rx_ring_init(rx);
+	if (retval)
+		return retval;
+
+	dma = rx->entry[0].desc_dma | TSNEP_RESET_OWNER_COUNTER;
+	iowrite32(DMA_ADDR_LOW(dma), rx->addr + TSNEP_RX_DESC_ADDR_LOW);
+	iowrite32(DMA_ADDR_HIGH(dma), rx->addr + TSNEP_RX_DESC_ADDR_HIGH);
+	rx->owner_counter = 1;
+	rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
+
+	for (i = 0; i < TSNEP_RING_SIZE; i++)
+		tsnep_rx_activate(rx, i);
+
+	/* descriptor properties shall be valid before hardware is notified */
+	dma_wmb();
+
+	iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
+
+	return 0;
+}
+
+static void tsnep_rx_close(struct tsnep_rx *rx)
+{
+	u32 val;
+
+	iowrite32(TSNEP_CONTROL_RX_DISABLE, rx->addr + TSNEP_CONTROL);
+	readx_poll_timeout(ioread32, rx->addr + TSNEP_CONTROL, val,
+			   ((val & TSNEP_CONTROL_RX_ENABLE) == 0), 10000,
+			   1000000);
+
+	tsnep_rx_ring_cleanup(rx);
+}
+
+static int tsnep_poll(struct napi_struct *napi, int budget)
+{
+	struct tsnep_queue *queue = container_of(napi, struct tsnep_queue,
+						 napi);
+	bool complete = true;
+	int done = 0;
+
+	if (queue->tx)
+		complete = tsnep_tx_poll(queue->tx, budget);
+
+	if (queue->rx) {
+		done = tsnep_rx_poll(queue->rx, napi, budget);
+		if (done >= budget)
+			complete = false;
+	}
+
+	/* if all work not completed, return budget and keep polling */
+	if (!complete)
+		return budget;
+
+	if (likely(napi_complete_done(napi, done)))
+		tsnep_enable_irq(queue->adapter, queue->irq_mask);
+
+	return min(done, budget - 1);
+}
+
+static int tsnep_netdev_open(struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int i;
+	void __iomem *addr;
+	int tx_queue_index = 0;
+	int rx_queue_index = 0;
+	int retval;
+
+	retval = tsnep_phy_open(adapter);
+	if (retval)
+		return retval;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		adapter->queue[i].adapter = adapter;
+		if (adapter->queue[i].tx) {
+			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
+			retval = tsnep_tx_open(adapter, addr,
+					       adapter->queue[i].tx);
+			if (retval)
+				goto failed;
+			tx_queue_index++;
+		}
+		if (adapter->queue[i].rx) {
+			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
+			retval = tsnep_rx_open(adapter, addr,
+					       adapter->queue[i].rx);
+			if (retval)
+				goto failed;
+			rx_queue_index++;
+		}
+	}
+
+	retval = netif_set_real_num_tx_queues(adapter->netdev,
+					      adapter->num_tx_queues);
+	if (retval)
+		goto failed;
+	retval = netif_set_real_num_rx_queues(adapter->netdev,
+					      adapter->num_rx_queues);
+	if (retval)
+		goto failed;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
+			       tsnep_poll, 64);
+		napi_enable(&adapter->queue[i].napi);
+
+		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
+	}
+
+	return 0;
+
+failed:
+	for (i = 0; i < adapter->num_queues; i++) {
+		if (adapter->queue[i].rx)
+			tsnep_rx_close(adapter->queue[i].rx);
+		if (adapter->queue[i].tx)
+			tsnep_tx_close(adapter->queue[i].tx);
+	}
+	tsnep_phy_close(adapter);
+	return retval;
+}
+
+static int tsnep_netdev_close(struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int i;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
+
+		napi_disable(&adapter->queue[i].napi);
+		netif_napi_del(&adapter->queue[i].napi);
+
+		if (adapter->queue[i].rx)
+			tsnep_rx_close(adapter->queue[i].rx);
+		if (adapter->queue[i].tx)
+			tsnep_tx_close(adapter->queue[i].tx);
+	}
+
+	tsnep_phy_close(adapter);
+
+	return 0;
+}
+
+static netdev_tx_t tsnep_netdev_xmit_frame(struct sk_buff *skb,
+					   struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+
+	if (queue_mapping >= adapter->num_tx_queues)
+		queue_mapping = 0;
+
+	return tsnep_xmit_frame_ring(skb, &adapter->tx[queue_mapping]);
+}
+
+static int tsnep_netdev_ioctl(struct net_device *netdev, struct ifreq *ifr,
+			      int cmd)
+{
+	if (!netif_running(netdev))
+		return -EINVAL;
+	if (cmd == SIOCSHWTSTAMP || cmd == SIOCGHWTSTAMP)
+		return tsnep_ptp_ioctl(netdev, ifr, cmd);
+	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
+}
+
+static void tsnep_netdev_set_multicast(struct net_device *netdev)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	u16 rx_filter = 0;
+
+	/* configured MAC address and broadcasts are never filtered */
+	if (netdev->flags & IFF_PROMISC) {
+		rx_filter |= TSNEP_RX_FILTER_ACCEPT_ALL_MULTICASTS;
+		rx_filter |= TSNEP_RX_FILTER_ACCEPT_ALL_UNICASTS;
+	} else if (!netdev_mc_empty(netdev) || (netdev->flags & IFF_ALLMULTI)) {
+		rx_filter |= TSNEP_RX_FILTER_ACCEPT_ALL_MULTICASTS;
+	}
+	iowrite16(rx_filter, adapter->addr + TSNEP_RX_FILTER);
+}
+
+static void tsnep_netdev_get_stats64(struct net_device *netdev,
+				     struct rtnl_link_stats64 *stats)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	u32 reg;
+	u32 val;
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		stats->tx_packets += adapter->tx[i].packets;
+		stats->tx_bytes += adapter->tx[i].bytes;
+		stats->tx_dropped += adapter->tx[i].dropped;
+	}
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		stats->rx_packets += adapter->rx[i].packets;
+		stats->rx_bytes += adapter->rx[i].bytes;
+		stats->rx_dropped += adapter->rx[i].dropped;
+		stats->multicast += adapter->rx[i].multicast;
+
+		reg = ioread32(adapter->addr + TSNEP_QUEUE(i) +
+			       TSNEP_RX_STATISTIC);
+		val = (reg & TSNEP_RX_STATISTIC_NO_DESC_MASK) >>
+		      TSNEP_RX_STATISTIC_NO_DESC_SHIFT;
+		stats->rx_dropped += val;
+		val = (reg & TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_MASK) >>
+		      TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL_SHIFT;
+		stats->rx_dropped += val;
+		val = (reg & TSNEP_RX_STATISTIC_FIFO_OVERFLOW_MASK) >>
+		      TSNEP_RX_STATISTIC_FIFO_OVERFLOW_SHIFT;
+		stats->rx_errors += val;
+		stats->rx_fifo_errors += val;
+		val = (reg & TSNEP_RX_STATISTIC_INVALID_FRAME_MASK) >>
+		      TSNEP_RX_STATISTIC_INVALID_FRAME_SHIFT;
+		stats->rx_errors += val;
+		stats->rx_frame_errors += val;
+	}
+
+	reg = ioread32(adapter->addr + ECM_STAT);
+	val = (reg & ECM_STAT_RX_ERR_MASK) >> ECM_STAT_RX_ERR_SHIFT;
+	stats->rx_errors += val;
+	val = (reg & ECM_STAT_INV_FRM_MASK) >> ECM_STAT_INV_FRM_SHIFT;
+	stats->rx_errors += val;
+	stats->rx_crc_errors += val;
+	val = (reg & ECM_STAT_FWD_RX_ERR_MASK) >> ECM_STAT_FWD_RX_ERR_SHIFT;
+	stats->rx_errors += val;
+}
+
+static void tsnep_mac_set_address(struct tsnep_adapter *adapter, u8 *addr)
+{
+	iowrite32(*(u32 *)addr, adapter->addr + TSNEP_MAC_ADDRESS_LOW);
+	iowrite16(*(u16 *)(addr + sizeof(u32)),
+		  adapter->addr + TSNEP_MAC_ADDRESS_HIGH);
+
+	ether_addr_copy(adapter->mac_address, addr);
+	netif_info(adapter, drv, adapter->netdev, "MAC address set to %pM\n",
+		   addr);
+}
+
+static int tsnep_netdev_set_mac_address(struct net_device *netdev, void *addr)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	struct sockaddr *sock_addr = addr;
+	int retval;
+
+	retval = eth_prepare_mac_addr_change(netdev, sock_addr);
+	if (retval)
+		return retval;
+	ether_addr_copy(netdev->dev_addr, sock_addr->sa_data);
+	tsnep_mac_set_address(adapter, sock_addr->sa_data);
+
+	return 0;
+}
+
+static const struct net_device_ops tsnep_netdev_ops = {
+	.ndo_open = tsnep_netdev_open,
+	.ndo_stop = tsnep_netdev_close,
+	.ndo_start_xmit = tsnep_netdev_xmit_frame,
+	.ndo_eth_ioctl = tsnep_netdev_ioctl,
+	.ndo_set_rx_mode = tsnep_netdev_set_multicast,
+
+	.ndo_get_stats64 = tsnep_netdev_get_stats64,
+	.ndo_set_mac_address = tsnep_netdev_set_mac_address,
+	.ndo_setup_tc = tsnep_tc_setup,
+};
+
+static int tsnep_mac_init(struct tsnep_adapter *adapter)
+{
+	int retval;
+
+	/* initialize RX filtering, at least configured MAC address and
+	 * broadcast are not filtered
+	 */
+	iowrite16(0, adapter->addr + TSNEP_RX_FILTER);
+
+	/* try to get MAC address in the following order:
+	 * - device tree
+	 * - valid MAC address already set
+	 * - MAC address register if valid
+	 * - random MAC address
+	 */
+	retval = of_get_mac_address(adapter->pdev->dev.of_node,
+				    adapter->mac_address);
+	if (retval == -EPROBE_DEFER)
+		return retval;
+	if (retval && !is_valid_ether_addr(adapter->mac_address)) {
+		*(u32 *)adapter->mac_address =
+			ioread32(adapter->addr + TSNEP_MAC_ADDRESS_LOW);
+		*(u16 *)(adapter->mac_address + sizeof(u32)) =
+			ioread16(adapter->addr + TSNEP_MAC_ADDRESS_HIGH);
+		if (!is_valid_ether_addr(adapter->mac_address))
+			eth_random_addr(adapter->mac_address);
+	}
+
+	tsnep_mac_set_address(adapter, adapter->mac_address);
+	ether_addr_copy(adapter->netdev->dev_addr, adapter->mac_address);
+
+	return 0;
+}
+
+static int tsnep_mdio_init(struct tsnep_adapter *adapter)
+{
+	struct device_node *np = adapter->pdev->dev.of_node;
+	int retval;
+
+	if (np) {
+		np = of_get_child_by_name(np, "mdio");
+		if (!np)
+			return 0;
+
+		adapter->suppress_preamble =
+			of_property_read_bool(np, "suppress-preamble");
+	}
+
+	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
+	if (!adapter->mdiobus) {
+		retval = -ENOMEM;
+
+		goto out;
+	}
+
+	adapter->mdiobus->priv = (void *)adapter;
+	adapter->mdiobus->parent = &adapter->pdev->dev;
+	adapter->mdiobus->read = tsnep_mdiobus_read;
+	adapter->mdiobus->write = tsnep_mdiobus_write;
+	adapter->mdiobus->name = TSNEP "-mdiobus";
+	snprintf(adapter->mdiobus->id, MII_BUS_ID_SIZE, "%s",
+		 adapter->pdev->name);
+
+	/* do not scan broadcast address */
+	adapter->mdiobus->phy_mask = 0x0000001;
+
+	retval = of_mdiobus_register(adapter->mdiobus, np);
+	if (np)
+		of_node_put(np);
+out:
+
+	return retval;
+}
+
+static int tsnep_phy_init(struct tsnep_adapter *adapter)
+{
+	struct device_node *phy_node;
+	int retval;
+
+	retval = of_get_phy_mode(adapter->pdev->dev.of_node,
+				 &adapter->phy_mode);
+	if (retval)
+		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
+
+	phy_node = of_parse_phandle(adapter->pdev->dev.of_node, "phy-handle",
+				    0);
+	adapter->phydev = of_phy_find_device(phy_node);
+	of_node_put(phy_node);
+	if (!adapter->phydev && adapter->mdiobus)
+		adapter->phydev = phy_find_first(adapter->mdiobus);
+	if (!adapter->phydev)
+		return -EIO;
+
+	return 0;
+}
+
+static int tsnep_probe(struct platform_device *pdev)
+{
+	struct tsnep_adapter *adapter;
+	struct net_device *netdev;
+	struct resource *io;
+	u32 type;
+	int revision;
+	int version;
+	int retval;
+
+	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
+					 sizeof(struct tsnep_adapter),
+					 TSNEP_MAX_QUEUES, TSNEP_MAX_QUEUES);
+	if (!netdev)
+		return -ENODEV;
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	adapter = netdev_priv(netdev);
+	platform_set_drvdata(pdev, adapter);
+	adapter->pdev = pdev;
+	adapter->dmadev = &pdev->dev;
+	adapter->netdev = netdev;
+	adapter->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
+			      NETIF_MSG_LINK | NETIF_MSG_IFUP |
+			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
+
+	netdev->min_mtu = ETH_MIN_MTU;
+	netdev->max_mtu = TSNEP_MAX_FRAME_SIZE;
+
+	mutex_init(&adapter->gate_control_lock);
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	adapter->addr = devm_ioremap_resource(&pdev->dev, io);
+	if (IS_ERR(adapter->addr))
+		return PTR_ERR(adapter->addr);
+	adapter->size = io->end - io->start + 1;
+	adapter->irq = platform_get_irq(pdev, 0);
+	netdev->mem_start = io->start;
+	netdev->mem_end = io->end;
+	netdev->irq = adapter->irq;
+
+	type = ioread32(adapter->addr + ECM_TYPE);
+	revision = (type & ECM_REVISION_MASK) >> ECM_REVISION_SHIFT;
+	version = (type & ECM_VERSION_MASK) >> ECM_VERSION_SHIFT;
+	adapter->gate_control = type & ECM_GATE_CONTROL;
+
+	adapter->num_tx_queues = TSNEP_QUEUES;
+	adapter->num_rx_queues = TSNEP_QUEUES;
+	adapter->num_queues = TSNEP_QUEUES;
+	adapter->queue[0].tx = &adapter->tx[0];
+	adapter->queue[0].rx = &adapter->rx[0];
+	adapter->queue[0].irq_mask = ECM_INT_TX_0 | ECM_INT_RX_0;
+
+	tsnep_disable_irq(adapter, ECM_INT_ALL);
+	retval = devm_request_irq(&adapter->pdev->dev, adapter->irq, tsnep_irq,
+				  0, TSNEP, adapter);
+	if (retval != 0) {
+		dev_err(&adapter->pdev->dev, "can't get assigned irq %d.\n",
+			adapter->irq);
+		return retval;
+	}
+	tsnep_enable_irq(adapter, ECM_INT_LINK);
+
+	retval = tsnep_mac_init(adapter);
+	if (retval)
+		goto mac_init_failed;
+
+	retval = tsnep_mdio_init(adapter);
+	if (retval)
+		goto mdio_init_failed;
+
+	retval = tsnep_phy_init(adapter);
+	if (retval)
+		goto phy_init_failed;
+
+	retval = tsnep_ptp_init(adapter);
+	if (retval)
+		goto ptp_init_failed;
+
+	retval = tsnep_tc_init(adapter);
+	if (retval)
+		goto tc_init_failed;
+
+	netdev->netdev_ops = &tsnep_netdev_ops;
+	netdev->ethtool_ops = &tsnep_ethtool_ops;
+	netdev->features = NETIF_F_SG;
+	netdev->hw_features = netdev->features;
+
+	/* carrier off reporting is important to ethtool even BEFORE open */
+	netif_carrier_off(netdev);
+
+	retval = register_netdev(netdev);
+	if (retval)
+		goto register_failed;
+
+	dev_info(&adapter->pdev->dev, "device version %d.%02d\n", version,
+		 revision);
+	if (adapter->gate_control)
+		dev_info(&adapter->pdev->dev, "gate control detected\n");
+
+	return 0;
+
+register_failed:
+	tsnep_tc_cleanup(adapter);
+tc_init_failed:
+	tsnep_ptp_cleanup(adapter);
+ptp_init_failed:
+phy_init_failed:
+	if (adapter->mdiobus)
+		mdiobus_unregister(adapter->mdiobus);
+mdio_init_failed:
+mac_init_failed:
+	tsnep_disable_irq(adapter, ECM_INT_ALL);
+	return retval;
+}
+
+static int tsnep_remove(struct platform_device *pdev)
+{
+	struct tsnep_adapter *adapter = platform_get_drvdata(pdev);
+
+	unregister_netdev(adapter->netdev);
+
+	tsnep_tc_cleanup(adapter);
+
+	tsnep_ptp_cleanup(adapter);
+
+	if (adapter->mdiobus)
+		mdiobus_unregister(adapter->mdiobus);
+
+	tsnep_disable_irq(adapter, ECM_INT_ALL);
+
+	return 0;
+}
+
+static const struct of_device_id tsnep_of_match[] = {
+	{ .compatible = "engleder,tsnep", },
+{ },
+};
+MODULE_DEVICE_TABLE(of, tsnep_of_match);
+
+static struct platform_driver tsnep_driver = {
+	.driver = {
+		.name = TSNEP,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(tsnep_of_match),
+	},
+	.probe = tsnep_probe,
+	.remove = tsnep_remove,
+};
+module_platform_driver(tsnep_driver);
+
+MODULE_AUTHOR("Gerhard Engleder <gerhard@engleder-embedded.com>");
+MODULE_DESCRIPTION("TSN endpoint Ethernet MAC driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/engleder/tsnep_ptp.c b/drivers/net/ethernet/engleder/tsnep_ptp.c
new file mode 100644
index 000000000000..4bfb4d8508f5
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_ptp.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#include "tsnep.h"
+
+void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time)
+{
+	u32 high_before;
+	u32 low;
+	u32 high;
+
+	/* read high dword twice to detect overrun */
+	high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	do {
+		low = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
+		high_before = high;
+		high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	} while (high != high_before);
+	*time = (((u64)high) << 32) | ((u64)low);
+}
+
+int tsnep_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	struct hwtstamp_config config;
+
+	if (!ifr)
+		return -EINVAL;
+
+	if (cmd == SIOCSHWTSTAMP) {
+		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+			return -EFAULT;
+
+		if (config.flags)
+			return -EINVAL;
+
+		switch (config.tx_type) {
+		case HWTSTAMP_TX_OFF:
+		case HWTSTAMP_TX_ON:
+			break;
+		default:
+			return -ERANGE;
+		}
+
+		switch (config.rx_filter) {
+		case HWTSTAMP_FILTER_NONE:
+			break;
+		case HWTSTAMP_FILTER_ALL:
+		case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+		case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+		case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+		case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+		case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+		case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+		case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		case HWTSTAMP_FILTER_PTP_V2_EVENT:
+		case HWTSTAMP_FILTER_PTP_V2_SYNC:
+		case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		case HWTSTAMP_FILTER_NTP_ALL:
+			config.rx_filter = HWTSTAMP_FILTER_ALL;
+			break;
+		default:
+			return -ERANGE;
+		}
+
+		memcpy(&adapter->hwtstamp_config, &config,
+		       sizeof(adapter->hwtstamp_config));
+	}
+
+	if (copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
+			 sizeof(adapter->hwtstamp_config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int tsnep_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
+						     ptp_clock_info);
+	bool negative = false;
+	u64 rate_offset;
+
+	if (scaled_ppm < 0) {
+		scaled_ppm = -scaled_ppm;
+		negative = true;
+	}
+
+	/* convert from 16 bit to 32 bit binary fractional, divide by 1000000 to
+	 * eliminate ppm, multiply with 8 to compensate 8ns clock cycle time,
+	 * simplify calculation because 15625 * 8 = 1000000 / 8
+	 */
+	rate_offset = scaled_ppm;
+	rate_offset <<= 16 - 3;
+	rate_offset = div_u64(rate_offset, 15625);
+
+	rate_offset &= ECM_CLOCK_RATE_OFFSET_MASK;
+	if (negative)
+		rate_offset |= ECM_CLOCK_RATE_OFFSET_SIGN;
+	iowrite32(rate_offset & 0xFFFFFFFF, adapter->addr + ECM_CLOCK_RATE);
+
+	return 0;
+}
+
+static int tsnep_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
+						     ptp_clock_info);
+	u64 system_time;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->ptp_lock, flags);
+
+	tsnep_get_system_time(adapter, &system_time);
+
+	system_time += delta;
+
+	/* high dword is buffered in hardware and synchronously written to
+	 * system time when low dword is written
+	 */
+	iowrite32(system_time >> 32, adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	iowrite32(system_time & 0xFFFFFFFF,
+		  adapter->addr + ECM_SYSTEM_TIME_LOW);
+
+	spin_unlock_irqrestore(&adapter->ptp_lock, flags);
+
+	return 0;
+}
+
+static int tsnep_ptp_gettimex64(struct ptp_clock_info *ptp,
+				struct timespec64 *ts,
+				struct ptp_system_timestamp *sts)
+{
+	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
+						     ptp_clock_info);
+	u32 high_before;
+	u32 low;
+	u32 high;
+	u64 system_time;
+
+	/* read high dword twice to detect overrun */
+	high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	do {
+		ptp_read_system_prets(sts);
+		low = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
+		ptp_read_system_postts(sts);
+		high_before = high;
+		high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	} while (high != high_before);
+	system_time = (((u64)high) << 32) | ((u64)low);
+
+	*ts = ns_to_timespec64(system_time);
+
+	return 0;
+}
+
+static int tsnep_ptp_settime64(struct ptp_clock_info *ptp,
+			       const struct timespec64 *ts)
+{
+	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
+						     ptp_clock_info);
+	u64 system_time = timespec64_to_ns(ts);
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->ptp_lock, flags);
+
+	/* high dword is buffered in hardware and synchronously written to
+	 * system time when low dword is written
+	 */
+	iowrite32(system_time >> 32, adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	iowrite32(system_time & 0xFFFFFFFF,
+		  adapter->addr + ECM_SYSTEM_TIME_LOW);
+
+	spin_unlock_irqrestore(&adapter->ptp_lock, flags);
+
+	return 0;
+}
+
+int tsnep_ptp_init(struct tsnep_adapter *adapter)
+{
+	int retval = 0;
+
+	adapter->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
+	adapter->hwtstamp_config.tx_type = HWTSTAMP_TX_OFF;
+
+	snprintf(adapter->ptp_clock_info.name, 16, "%s", TSNEP);
+	adapter->ptp_clock_info.owner = THIS_MODULE;
+	/* at most 2^-1ns adjustment every clock cycle for 8ns clock cycle time,
+	 * stay slightly below because only bits below 2^-1ns are supported
+	 */
+	adapter->ptp_clock_info.max_adj = (500000000 / 8 - 1);
+	adapter->ptp_clock_info.adjfine = tsnep_ptp_adjfine;
+	adapter->ptp_clock_info.adjtime = tsnep_ptp_adjtime;
+	adapter->ptp_clock_info.gettimex64 = tsnep_ptp_gettimex64;
+	adapter->ptp_clock_info.settime64 = tsnep_ptp_settime64;
+
+	spin_lock_init(&adapter->ptp_lock);
+
+	adapter->ptp_clock = ptp_clock_register(&adapter->ptp_clock_info,
+						&adapter->pdev->dev);
+	if (IS_ERR(adapter->ptp_clock)) {
+		netdev_err(adapter->netdev, "ptp_clock_register failed\n");
+
+		retval = PTR_ERR(adapter->ptp_clock);
+		adapter->ptp_clock = NULL;
+	} else if (adapter->ptp_clock) {
+		netdev_info(adapter->netdev, "PHC added\n");
+	}
+
+	return retval;
+}
+
+void tsnep_ptp_cleanup(struct tsnep_adapter *adapter)
+{
+	if (adapter->ptp_clock) {
+		ptp_clock_unregister(adapter->ptp_clock);
+		netdev_info(adapter->netdev, "PHC removed\n");
+	}
+}
diff --git a/drivers/net/ethernet/engleder/tsnep_selftests.c b/drivers/net/ethernet/engleder/tsnep_selftests.c
new file mode 100644
index 000000000000..1581d6b22232
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_selftests.c
@@ -0,0 +1,811 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#include "tsnep.h"
+
+#include <net/pkt_sched.h>
+
+enum tsnep_test {
+	TSNEP_TEST_ENABLE = 0,
+	TSNEP_TEST_TAPRIO,
+	TSNEP_TEST_TAPRIO_CHANGE,
+	TSNEP_TEST_TAPRIO_EXTENSION,
+};
+
+static const char tsnep_test_strings[][ETH_GSTRING_LEN] = {
+	"Enable timeout        (offline)",
+	"TAPRIO                (offline)",
+	"TAPRIO change         (offline)",
+	"TAPRIO extension      (offline)",
+};
+
+#define TSNEP_TEST_COUNT (sizeof(tsnep_test_strings) / ETH_GSTRING_LEN)
+
+static bool enable_gc_timeout(struct tsnep_adapter *adapter)
+{
+	iowrite8(TSNEP_GC_ENABLE_TIMEOUT, adapter->addr + TSNEP_GC);
+	if (!(ioread32(adapter->addr + TSNEP_GC) & TSNEP_GC_TIMEOUT_ACTIVE))
+		return false;
+
+	return true;
+}
+
+static bool gc_timeout_signaled(struct tsnep_adapter *adapter)
+{
+	if (ioread32(adapter->addr + TSNEP_GC) & TSNEP_GC_TIMEOUT_SIGNAL)
+		return true;
+
+	return false;
+}
+
+static bool ack_gc_timeout(struct tsnep_adapter *adapter)
+{
+	iowrite8(TSNEP_GC_ENABLE_TIMEOUT, adapter->addr + TSNEP_GC);
+	if (ioread32(adapter->addr + TSNEP_GC) &
+	    (TSNEP_GC_TIMEOUT_ACTIVE | TSNEP_GC_TIMEOUT_SIGNAL))
+		return false;
+	return true;
+}
+
+static bool enable_gc(struct tsnep_adapter *adapter, bool a)
+{
+	u8 enable;
+	u8 active;
+
+	if (a) {
+		enable = TSNEP_GC_ENABLE_A;
+		active = TSNEP_GC_ACTIVE_A;
+	} else {
+		enable = TSNEP_GC_ENABLE_B;
+		active = TSNEP_GC_ACTIVE_B;
+	}
+
+	iowrite8(enable, adapter->addr + TSNEP_GC);
+	if (!(ioread32(adapter->addr + TSNEP_GC) & active))
+		return false;
+
+	return true;
+}
+
+static bool disable_gc(struct tsnep_adapter *adapter)
+{
+	iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
+	if (ioread32(adapter->addr + TSNEP_GC) &
+	    (TSNEP_GC_ACTIVE_A | TSNEP_GC_ACTIVE_B))
+		return false;
+
+	return true;
+}
+
+static bool gc_delayed_enable(struct tsnep_adapter *adapter, bool a, int delay)
+{
+	u64 before, after;
+	u32 time;
+	bool enabled;
+
+	if (!disable_gc(adapter))
+		return false;
+
+	before = ktime_get_ns();
+
+	if (!enable_gc_timeout(adapter))
+		return false;
+
+	/* for start time after timeout, the timeout can guarantee, that enable
+	 * is blocked if too late
+	 */
+	time = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
+	time += TSNEP_GC_TIMEOUT;
+	iowrite32(time, adapter->addr + TSNEP_GC_TIME);
+
+	ndelay(delay);
+
+	enabled = enable_gc(adapter, a);
+	after = ktime_get_ns();
+
+	if (delay > TSNEP_GC_TIMEOUT) {
+		/* timeout must have blocked enable */
+		if (enabled)
+			return false;
+	} else if ((after - before) < TSNEP_GC_TIMEOUT * 14 / 16) {
+		/* timeout must not have blocked enable */
+		if (!enabled)
+			return false;
+	}
+
+	if (enabled) {
+		if (gc_timeout_signaled(adapter))
+			return false;
+	} else {
+		if (!gc_timeout_signaled(adapter))
+			return false;
+		if (!ack_gc_timeout(adapter))
+			return false;
+	}
+
+	if (!disable_gc(adapter))
+		return false;
+
+	return true;
+}
+
+static bool tsnep_test_gc_enable(struct tsnep_adapter *adapter)
+{
+	int i;
+
+	iowrite32(0x80000001, adapter->addr + TSNEP_GCL_A + 0);
+	iowrite32(100000, adapter->addr + TSNEP_GCL_A + 4);
+
+	for (i = 0; i < 200000; i += 100) {
+		if (!gc_delayed_enable(adapter, true, i))
+			return false;
+	}
+
+	iowrite32(0x80000001, adapter->addr + TSNEP_GCL_B + 0);
+	iowrite32(100000, adapter->addr + TSNEP_GCL_B + 4);
+
+	for (i = 0; i < 200000; i += 100) {
+		if (!gc_delayed_enable(adapter, false, i))
+			return false;
+	}
+
+	return true;
+}
+
+static void delay_base_time(struct tsnep_adapter *adapter,
+			    struct tc_taprio_qopt_offload *qopt, s64 ms)
+{
+	u64 system_time;
+	u64 base_time = ktime_to_ns(qopt->base_time);
+	u64 n;
+
+	tsnep_get_system_time(adapter, &system_time);
+	system_time += ms * 1000000;
+	n = div64_u64(system_time - base_time, qopt->cycle_time);
+
+	qopt->base_time = ktime_add_ns(qopt->base_time,
+				       (n + 1) * qopt->cycle_time);
+}
+
+static void get_gate_state(struct tsnep_adapter *adapter, u32 *gc, u32 *gc_time,
+			   u64 *system_time)
+{
+	u32 time_high_before;
+	u32 time_low;
+	u32 time_high;
+	u32 gc_time_before;
+
+	time_high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	*gc_time = ioread32(adapter->addr + TSNEP_GC_TIME);
+	do {
+		time_low = ioread32(adapter->addr + ECM_SYSTEM_TIME_LOW);
+		*gc = ioread32(adapter->addr + TSNEP_GC);
+
+		gc_time_before = *gc_time;
+		*gc_time = ioread32(adapter->addr + TSNEP_GC_TIME);
+		time_high_before = time_high;
+		time_high = ioread32(adapter->addr + ECM_SYSTEM_TIME_HIGH);
+	} while ((time_high != time_high_before) ||
+		 (*gc_time != gc_time_before));
+
+	*system_time = (((u64)time_high) << 32) | ((u64)time_low);
+}
+
+static int get_operation(struct tsnep_gcl *gcl, u64 system_time, u64 *next)
+{
+	u64 n = div64_u64(system_time - gcl->base_time, gcl->cycle_time);
+	u64 cycle_start = gcl->base_time + gcl->cycle_time * n;
+	int i;
+
+	*next = cycle_start;
+	for (i = 0; i < gcl->count; i++) {
+		*next += gcl->operation[i].interval;
+		if (*next > system_time)
+			break;
+	}
+
+	return i;
+}
+
+static bool check_gate(struct tsnep_adapter *adapter)
+{
+	u32 gc_time;
+	u32 gc;
+	u64 system_time;
+	struct tsnep_gcl *curr;
+	struct tsnep_gcl *prev;
+	u64 next_time;
+	u8 gate_open;
+	u8 next_gate_open;
+
+	get_gate_state(adapter, &gc, &gc_time, &system_time);
+
+	if (gc & TSNEP_GC_ACTIVE_A) {
+		curr = &adapter->gcl[0];
+		prev = &adapter->gcl[1];
+	} else if (gc & TSNEP_GC_ACTIVE_B) {
+		curr = &adapter->gcl[1];
+		prev = &adapter->gcl[0];
+	} else {
+		return false;
+	}
+	if (curr->start_time <= system_time) {
+		/* GCL is already active */
+		int index;
+
+		index = get_operation(curr, system_time, &next_time);
+		gate_open = curr->operation[index].properties & TSNEP_GCL_MASK;
+		if (index == curr->count - 1)
+			index = 0;
+		else
+			index++;
+		next_gate_open =
+			curr->operation[index].properties & TSNEP_GCL_MASK;
+	} else if (curr->change) {
+		/* operation of previous GCL is active */
+		int index;
+		u64 start_before;
+		u64 n;
+
+		index = get_operation(prev, system_time, &next_time);
+		next_time = curr->start_time;
+		start_before = prev->base_time;
+		n = div64_u64(curr->start_time - start_before,
+			      prev->cycle_time);
+		start_before += n * prev->cycle_time;
+		if (curr->start_time == start_before)
+			start_before -= prev->cycle_time;
+		if (((start_before + prev->cycle_time_extension) >=
+		     curr->start_time) &&
+		    (curr->start_time - prev->cycle_time_extension <=
+		     system_time)) {
+			/* extend */
+			index = prev->count - 1;
+		}
+		gate_open = prev->operation[index].properties & TSNEP_GCL_MASK;
+		next_gate_open =
+			curr->operation[0].properties & TSNEP_GCL_MASK;
+	} else {
+		/* GCL is waiting for start */
+		next_time = curr->start_time;
+		gate_open = 0xFF;
+		next_gate_open = curr->operation[0].properties & TSNEP_GCL_MASK;
+	}
+
+	if (gc_time != (next_time & 0xFFFFFFFF)) {
+		dev_err(&adapter->pdev->dev, "gate control time 0x%x!=0x%llx\n",
+			gc_time, next_time);
+		return false;
+	}
+	if (((gc & TSNEP_GC_OPEN) >> TSNEP_GC_OPEN_SHIFT) != gate_open) {
+		dev_err(&adapter->pdev->dev,
+			"gate control open 0x%02x!=0x%02x\n",
+			((gc & TSNEP_GC_OPEN) >> TSNEP_GC_OPEN_SHIFT),
+			gate_open);
+		return false;
+	}
+	if (((gc & TSNEP_GC_NEXT_OPEN) >> TSNEP_GC_NEXT_OPEN_SHIFT) !=
+	    next_gate_open) {
+		dev_err(&adapter->pdev->dev,
+			"gate control next open 0x%02x!=0x%02x\n",
+			((gc & TSNEP_GC_NEXT_OPEN) >> TSNEP_GC_NEXT_OPEN_SHIFT),
+			next_gate_open);
+		return false;
+	}
+
+	return true;
+}
+
+static bool check_gate_duration(struct tsnep_adapter *adapter, s64 ms)
+{
+	ktime_t start = ktime_get();
+
+	do {
+		if (!check_gate(adapter))
+			return false;
+	} while (ktime_ms_delta(ktime_get(), start) < ms);
+
+	return true;
+}
+
+static bool enable_check_taprio(struct tsnep_adapter *adapter,
+				struct tc_taprio_qopt_offload *qopt, s64 ms)
+{
+	int retval;
+
+	retval = tsnep_tc_setup(adapter->netdev, TC_SETUP_QDISC_TAPRIO, qopt);
+	if (retval)
+		return false;
+
+	if (!check_gate_duration(adapter, ms))
+		return false;
+
+	return true;
+}
+
+static bool disable_taprio(struct tsnep_adapter *adapter)
+{
+	struct tc_taprio_qopt_offload qopt;
+	int retval;
+
+	memset(&qopt, 0, sizeof(qopt));
+	qopt.enable = 0;
+	retval = tsnep_tc_setup(adapter->netdev, TC_SETUP_QDISC_TAPRIO, &qopt);
+	if (retval)
+		return false;
+
+	return true;
+}
+
+static bool run_taprio(struct tsnep_adapter *adapter,
+		       struct tc_taprio_qopt_offload *qopt, s64 ms)
+{
+	if (!enable_check_taprio(adapter, qopt, ms))
+		return false;
+
+	if (!disable_taprio(adapter))
+		return false;
+
+	return true;
+}
+
+static bool tsnep_test_taprio(struct tsnep_adapter *adapter)
+{
+	struct tc_taprio_qopt_offload *qopt;
+	int i;
+
+	qopt = kzalloc(struct_size(qopt, entries, 255), GFP_KERNEL);
+	if (!qopt)
+		return false;
+	for (i = 0; i < 255; i++)
+		qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
+
+	qopt->enable = 1;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 1500000;
+	qopt->cycle_time_extension = 0;
+	qopt->entries[0].gate_mask = 0x02;
+	qopt->entries[0].interval = 200000;
+	qopt->entries[1].gate_mask = 0x03;
+	qopt->entries[1].interval = 800000;
+	qopt->entries[2].gate_mask = 0x07;
+	qopt->entries[2].interval = 240000;
+	qopt->entries[3].gate_mask = 0x01;
+	qopt->entries[3].interval = 80000;
+	qopt->entries[4].gate_mask = 0x04;
+	qopt->entries[4].interval = 70000;
+	qopt->entries[5].gate_mask = 0x06;
+	qopt->entries[5].interval = 60000;
+	qopt->entries[6].gate_mask = 0x0F;
+	qopt->entries[6].interval = 50000;
+	qopt->num_entries = 7;
+	if (!run_taprio(adapter, qopt, 100))
+		goto failed;
+
+	qopt->enable = 1;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 411854;
+	qopt->cycle_time_extension = 0;
+	qopt->entries[0].gate_mask = 0x17;
+	qopt->entries[0].interval = 23842;
+	qopt->entries[1].gate_mask = 0x16;
+	qopt->entries[1].interval = 13482;
+	qopt->entries[2].gate_mask = 0x15;
+	qopt->entries[2].interval = 49428;
+	qopt->entries[3].gate_mask = 0x14;
+	qopt->entries[3].interval = 38189;
+	qopt->entries[4].gate_mask = 0x13;
+	qopt->entries[4].interval = 92321;
+	qopt->entries[5].gate_mask = 0x12;
+	qopt->entries[5].interval = 71239;
+	qopt->entries[6].gate_mask = 0x11;
+	qopt->entries[6].interval = 69932;
+	qopt->entries[7].gate_mask = 0x10;
+	qopt->entries[7].interval = 53421;
+	qopt->num_entries = 8;
+	if (!run_taprio(adapter, qopt, 100))
+		goto failed;
+
+	qopt->enable = 1;
+	qopt->base_time = ktime_set(0, 0);
+	delay_base_time(adapter, qopt, 12);
+	qopt->cycle_time = 125000;
+	qopt->cycle_time_extension = 0;
+	qopt->entries[0].gate_mask = 0x27;
+	qopt->entries[0].interval = 15000;
+	qopt->entries[1].gate_mask = 0x26;
+	qopt->entries[1].interval = 15000;
+	qopt->entries[2].gate_mask = 0x25;
+	qopt->entries[2].interval = 12500;
+	qopt->entries[3].gate_mask = 0x24;
+	qopt->entries[3].interval = 17500;
+	qopt->entries[4].gate_mask = 0x23;
+	qopt->entries[4].interval = 10000;
+	qopt->entries[5].gate_mask = 0x22;
+	qopt->entries[5].interval = 11000;
+	qopt->entries[6].gate_mask = 0x21;
+	qopt->entries[6].interval = 9000;
+	qopt->entries[7].gate_mask = 0x20;
+	qopt->entries[7].interval = 10000;
+	qopt->entries[8].gate_mask = 0x20;
+	qopt->entries[8].interval = 12500;
+	qopt->entries[9].gate_mask = 0x20;
+	qopt->entries[9].interval = 12500;
+	qopt->num_entries = 10;
+	if (!run_taprio(adapter, qopt, 100))
+		goto failed;
+
+	kfree(qopt);
+
+	return true;
+
+failed:
+	disable_taprio(adapter);
+	kfree(qopt);
+
+	return false;
+}
+
+static bool tsnep_test_taprio_change(struct tsnep_adapter *adapter)
+{
+	struct tc_taprio_qopt_offload *qopt;
+	int i;
+
+	qopt = kzalloc(struct_size(qopt, entries, 255), GFP_KERNEL);
+	if (!qopt)
+		return false;
+	for (i = 0; i < 255; i++)
+		qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
+
+	qopt->enable = 1;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 100000;
+	qopt->cycle_time_extension = 0;
+	qopt->entries[0].gate_mask = 0x30;
+	qopt->entries[0].interval = 20000;
+	qopt->entries[1].gate_mask = 0x31;
+	qopt->entries[1].interval = 80000;
+	qopt->num_entries = 2;
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to identical */
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	delay_base_time(adapter, qopt, 17);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to same cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->entries[0].gate_mask = 0x42;
+	qopt->entries[1].gate_mask = 0x43;
+	delay_base_time(adapter, qopt, 2);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->entries[0].gate_mask = 0x54;
+	qopt->entries[0].interval = 33333;
+	qopt->entries[1].gate_mask = 0x55;
+	qopt->entries[1].interval = 66667;
+	delay_base_time(adapter, qopt, 23);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->entries[0].gate_mask = 0x66;
+	qopt->entries[0].interval = 50000;
+	qopt->entries[1].gate_mask = 0x67;
+	qopt->entries[1].interval = 25000;
+	qopt->entries[2].gate_mask = 0x68;
+	qopt->entries[2].interval = 25000;
+	qopt->num_entries = 3;
+	delay_base_time(adapter, qopt, 11);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to multiple of cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 200000;
+	qopt->entries[0].gate_mask = 0x79;
+	qopt->entries[0].interval = 50000;
+	qopt->entries[1].gate_mask = 0x7A;
+	qopt->entries[1].interval = 150000;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 11);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 1000000;
+	qopt->entries[0].gate_mask = 0x7B;
+	qopt->entries[0].interval = 125000;
+	qopt->entries[1].gate_mask = 0x7C;
+	qopt->entries[1].interval = 250000;
+	qopt->entries[2].gate_mask = 0x7D;
+	qopt->entries[2].interval = 375000;
+	qopt->entries[3].gate_mask = 0x7E;
+	qopt->entries[3].interval = 250000;
+	qopt->num_entries = 4;
+	delay_base_time(adapter, qopt, 3);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to shorter cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 333333;
+	qopt->entries[0].gate_mask = 0x8F;
+	qopt->entries[0].interval = 166666;
+	qopt->entries[1].gate_mask = 0x80;
+	qopt->entries[1].interval = 166667;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 11);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 62500;
+	qopt->entries[0].gate_mask = 0x81;
+	qopt->entries[0].interval = 31250;
+	qopt->entries[1].gate_mask = 0x82;
+	qopt->entries[1].interval = 15625;
+	qopt->entries[2].gate_mask = 0x83;
+	qopt->entries[2].interval = 15625;
+	qopt->num_entries = 3;
+	delay_base_time(adapter, qopt, 1);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to longer cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 400000;
+	qopt->entries[0].gate_mask = 0x84;
+	qopt->entries[0].interval = 100000;
+	qopt->entries[1].gate_mask = 0x85;
+	qopt->entries[1].interval = 100000;
+	qopt->entries[2].gate_mask = 0x86;
+	qopt->entries[2].interval = 100000;
+	qopt->entries[3].gate_mask = 0x87;
+	qopt->entries[3].interval = 100000;
+	qopt->num_entries = 4;
+	delay_base_time(adapter, qopt, 7);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 1700000;
+	qopt->entries[0].gate_mask = 0x88;
+	qopt->entries[0].interval = 200000;
+	qopt->entries[1].gate_mask = 0x89;
+	qopt->entries[1].interval = 300000;
+	qopt->entries[2].gate_mask = 0x8A;
+	qopt->entries[2].interval = 600000;
+	qopt->entries[3].gate_mask = 0x8B;
+	qopt->entries[3].interval = 100000;
+	qopt->entries[4].gate_mask = 0x8C;
+	qopt->entries[4].interval = 500000;
+	qopt->num_entries = 5;
+	delay_base_time(adapter, qopt, 6);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	if (!disable_taprio(adapter))
+		goto failed;
+
+	kfree(qopt);
+
+	return true;
+
+failed:
+	disable_taprio(adapter);
+	kfree(qopt);
+
+	return false;
+}
+
+static bool tsnep_test_taprio_extension(struct tsnep_adapter *adapter)
+{
+	struct tc_taprio_qopt_offload *qopt;
+	int i;
+
+	qopt = kzalloc(struct_size(qopt, entries, 255), GFP_KERNEL);
+	if (!qopt)
+		return false;
+	for (i = 0; i < 255; i++)
+		qopt->entries[i].command = TC_TAPRIO_CMD_SET_GATES;
+
+	qopt->enable = 1;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 100000;
+	qopt->cycle_time_extension = 50000;
+	qopt->entries[0].gate_mask = 0x90;
+	qopt->entries[0].interval = 20000;
+	qopt->entries[1].gate_mask = 0x91;
+	qopt->entries[1].interval = 80000;
+	qopt->num_entries = 2;
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to different phase */
+	qopt->base_time = ktime_set(0, 50000);
+	qopt->entries[0].gate_mask = 0x92;
+	qopt->entries[0].interval = 33000;
+	qopt->entries[1].gate_mask = 0x93;
+	qopt->entries[1].interval = 67000;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 2);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to different phase and longer cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 1000000;
+	qopt->cycle_time_extension = 700000;
+	qopt->entries[0].gate_mask = 0x94;
+	qopt->entries[0].interval = 400000;
+	qopt->entries[1].gate_mask = 0x95;
+	qopt->entries[1].interval = 600000;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 7);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 700000);
+	qopt->cycle_time = 2000000;
+	qopt->cycle_time_extension = 1900000;
+	qopt->entries[0].gate_mask = 0x96;
+	qopt->entries[0].interval = 400000;
+	qopt->entries[1].gate_mask = 0x97;
+	qopt->entries[1].interval = 1600000;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 9);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to different phase and shorter cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 1500000;
+	qopt->cycle_time_extension = 700000;
+	qopt->entries[0].gate_mask = 0x98;
+	qopt->entries[0].interval = 400000;
+	qopt->entries[1].gate_mask = 0x99;
+	qopt->entries[1].interval = 600000;
+	qopt->entries[2].gate_mask = 0x9A;
+	qopt->entries[2].interval = 500000;
+	qopt->num_entries = 3;
+	delay_base_time(adapter, qopt, 3);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 100000);
+	qopt->cycle_time = 500000;
+	qopt->cycle_time_extension = 300000;
+	qopt->entries[0].gate_mask = 0x9B;
+	qopt->entries[0].interval = 150000;
+	qopt->entries[1].gate_mask = 0x9C;
+	qopt->entries[1].interval = 350000;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 9);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	/* change to different cycle time */
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 1000000;
+	qopt->cycle_time_extension = 700000;
+	qopt->entries[0].gate_mask = 0xAD;
+	qopt->entries[0].interval = 400000;
+	qopt->entries[1].gate_mask = 0xAE;
+	qopt->entries[1].interval = 300000;
+	qopt->entries[2].gate_mask = 0xAF;
+	qopt->entries[2].interval = 300000;
+	qopt->num_entries = 3;
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 400000;
+	qopt->cycle_time_extension = 100000;
+	qopt->entries[0].gate_mask = 0xA0;
+	qopt->entries[0].interval = 200000;
+	qopt->entries[1].gate_mask = 0xA1;
+	qopt->entries[1].interval = 200000;
+	qopt->num_entries = 2;
+	delay_base_time(adapter, qopt, 19);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 500000;
+	qopt->cycle_time_extension = 499999;
+	qopt->entries[0].gate_mask = 0xB2;
+	qopt->entries[0].interval = 100000;
+	qopt->entries[1].gate_mask = 0xB3;
+	qopt->entries[1].interval = 100000;
+	qopt->entries[2].gate_mask = 0xB4;
+	qopt->entries[2].interval = 100000;
+	qopt->entries[3].gate_mask = 0xB5;
+	qopt->entries[3].interval = 200000;
+	qopt->num_entries = 4;
+	delay_base_time(adapter, qopt, 19);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+	qopt->base_time = ktime_set(0, 0);
+	qopt->cycle_time = 6000000;
+	qopt->cycle_time_extension = 5999999;
+	qopt->entries[0].gate_mask = 0xC6;
+	qopt->entries[0].interval = 1000000;
+	qopt->entries[1].gate_mask = 0xC7;
+	qopt->entries[1].interval = 1000000;
+	qopt->entries[2].gate_mask = 0xC8;
+	qopt->entries[2].interval = 1000000;
+	qopt->entries[3].gate_mask = 0xC9;
+	qopt->entries[3].interval = 1500000;
+	qopt->entries[4].gate_mask = 0xCA;
+	qopt->entries[4].interval = 1500000;
+	qopt->num_entries = 5;
+	delay_base_time(adapter, qopt, 1);
+	if (!enable_check_taprio(adapter, qopt, 100))
+		goto failed;
+
+	if (!disable_taprio(adapter))
+		goto failed;
+
+	kfree(qopt);
+
+	return true;
+
+failed:
+	disable_taprio(adapter);
+	kfree(qopt);
+
+	return false;
+}
+
+int tsnep_ethtool_get_test_count(void)
+{
+	return TSNEP_TEST_COUNT;
+}
+
+void tsnep_ethtool_get_test_strings(u8 *data)
+{
+	memcpy(data, tsnep_test_strings, sizeof(tsnep_test_strings));
+}
+
+void tsnep_ethtool_self_test(struct net_device *netdev,
+			     struct ethtool_test *eth_test, u64 *data)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	eth_test->len = TSNEP_TEST_COUNT;
+
+	if (eth_test->flags != ETH_TEST_FL_OFFLINE) {
+		/* no tests are done online */
+		data[TSNEP_TEST_ENABLE] = 0;
+		data[TSNEP_TEST_TAPRIO] = 0;
+		data[TSNEP_TEST_TAPRIO_CHANGE] = 0;
+		data[TSNEP_TEST_TAPRIO_EXTENSION] = 0;
+
+		return;
+	}
+
+	if (tsnep_test_gc_enable(adapter)) {
+		data[TSNEP_TEST_ENABLE] = 0;
+	} else {
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		data[TSNEP_TEST_ENABLE] = 1;
+	}
+
+	if (tsnep_test_taprio(adapter)) {
+		data[TSNEP_TEST_TAPRIO] = 0;
+	} else {
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		data[TSNEP_TEST_TAPRIO] = 1;
+	}
+
+	if (tsnep_test_taprio_change(adapter)) {
+		data[TSNEP_TEST_TAPRIO_CHANGE] = 0;
+	} else {
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		data[TSNEP_TEST_TAPRIO_CHANGE] = 1;
+	}
+
+	if (tsnep_test_taprio_extension(adapter)) {
+		data[TSNEP_TEST_TAPRIO_EXTENSION] = 0;
+	} else {
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		data[TSNEP_TEST_TAPRIO_EXTENSION] = 1;
+	}
+}
diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
new file mode 100644
index 000000000000..c4c6e1357317
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_tc.c
@@ -0,0 +1,443 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#include "tsnep.h"
+
+#include <net/pkt_sched.h>
+
+/* save one operation at the end for additional operation at list change */
+#define TSNEP_MAX_GCL_NUM (TSNEP_GCL_COUNT - 1)
+
+static int tsnep_validate_gcl(struct tc_taprio_qopt_offload *qopt)
+{
+	int i;
+	u64 cycle_time;
+
+	if (!qopt->cycle_time)
+		return -ERANGE;
+	if (qopt->num_entries > TSNEP_MAX_GCL_NUM)
+		return -EINVAL;
+	cycle_time = 0;
+	for (i = 0; i < qopt->num_entries; i++) {
+		if (qopt->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
+			return -EINVAL;
+		if (qopt->entries[i].gate_mask & ~TSNEP_GCL_MASK)
+			return -EINVAL;
+		if (qopt->entries[i].interval < TSNEP_GCL_MIN_INTERVAL)
+			return -EINVAL;
+		cycle_time += qopt->entries[i].interval;
+	}
+	if (qopt->cycle_time != cycle_time)
+		return -EINVAL;
+	if (qopt->cycle_time_extension >= qopt->cycle_time)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void tsnep_write_gcl_operation(struct tsnep_gcl *gcl, int index,
+				      u32 properties, u32 interval, bool flush)
+{
+	void __iomem *addr = gcl->addr +
+			     sizeof(struct tsnep_gcl_operation) * index;
+
+	gcl->operation[index].properties = properties;
+	gcl->operation[index].interval = interval;
+
+	iowrite32(properties, addr);
+	iowrite32(interval, addr + sizeof(u32));
+
+	if (flush) {
+		/* flush write with read access */
+		ioread32(addr);
+	}
+}
+
+static u64 tsnep_change_duration(struct tsnep_gcl *gcl, int index)
+{
+	u64 duration;
+	int count;
+
+	/* change needs to be triggered one or two operations before start of
+	 * new gate control list
+	 * - change is triggered at start of operation (minimum one operation)
+	 * - operation with adjusted interval is inserted on demand to exactly
+	 *   meet the start of the new gate control list (optional)
+	 *
+	 * additionally properties are read directly after start of previous
+	 * operation
+	 *
+	 * therefore, three operations needs to be considered for the limit
+	 */
+	duration = 0;
+	count = 3;
+	while (count) {
+		duration += gcl->operation[index].interval;
+
+		index--;
+		if (index < 0)
+			index = gcl->count - 1;
+
+		count--;
+	}
+
+	return duration;
+}
+
+static void tsnep_write_gcl(struct tsnep_gcl *gcl,
+			    struct tc_taprio_qopt_offload *qopt)
+{
+	int i;
+	u32 properties;
+	u64 extend;
+	u64 cut;
+
+	gcl->base_time = ktime_to_ns(qopt->base_time);
+	gcl->cycle_time = qopt->cycle_time;
+	gcl->cycle_time_extension = qopt->cycle_time_extension;
+
+	for (i = 0; i < qopt->num_entries; i++) {
+		properties = qopt->entries[i].gate_mask;
+		if (i == (qopt->num_entries - 1))
+			properties |= TSNEP_GCL_LAST;
+
+		tsnep_write_gcl_operation(gcl, i, properties,
+					  qopt->entries[i].interval, true);
+	}
+	gcl->count = qopt->num_entries;
+
+	/* calculate change limit; i.e., the time needed between enable and
+	 * start of new gate control list
+	 */
+
+	/* case 1: extend cycle time for change
+	 * - change duration of last operation
+	 * - cycle time extension
+	 */
+	extend = tsnep_change_duration(gcl, gcl->count - 1);
+	extend += gcl->cycle_time_extension;
+
+	/* case 2: cut cycle time for change
+	 * - maximum change duration
+	 */
+	cut = 0;
+	for (i = 0; i < gcl->count; i++)
+		cut = max(cut, tsnep_change_duration(gcl, i));
+
+	/* use maximum, because the actual case (extend or cut) can be
+	 * determined only after limit is known (chicken-and-egg problem)
+	 */
+	gcl->change_limit = max(extend, cut);
+}
+
+static u64 tsnep_gcl_start_after(struct tsnep_gcl *gcl, u64 limit)
+{
+	u64 start = gcl->base_time;
+	u64 n;
+
+	if (start <= limit) {
+		n = div64_u64(limit - start, gcl->cycle_time);
+		start += (n + 1) * gcl->cycle_time;
+	}
+
+	return start;
+}
+
+static u64 tsnep_gcl_start_before(struct tsnep_gcl *gcl, u64 limit)
+{
+	u64 start = gcl->base_time;
+	u64 n;
+
+	n = div64_u64(limit - start, gcl->cycle_time);
+	start += n * gcl->cycle_time;
+	if (start == limit)
+		start -= gcl->cycle_time;
+
+	return start;
+}
+
+static u64 tsnep_set_gcl_change(struct tsnep_gcl *gcl, int index, u64 change,
+				bool insert)
+{
+	/* previous operation triggers change and properties are evaluated at
+	 * start of operation
+	 */
+	if (index == 0)
+		index = gcl->count - 1;
+	else
+		index = index - 1;
+	change -= gcl->operation[index].interval;
+
+	/* optionally change to new list with additional operation in between */
+	if (insert) {
+		void __iomem *addr = gcl->addr +
+				     sizeof(struct tsnep_gcl_operation) * index;
+
+		gcl->operation[index].properties |= TSNEP_GCL_INSERT;
+		iowrite32(gcl->operation[index].properties, addr);
+	}
+
+	return change;
+}
+
+static void tsnep_clean_gcl(struct tsnep_gcl *gcl)
+{
+	int i;
+	u32 mask = TSNEP_GCL_LAST | TSNEP_GCL_MASK;
+	void __iomem *addr;
+
+	/* search for insert operation and reset properties */
+	for (i = 0; i < gcl->count; i++) {
+		if (gcl->operation[i].properties & ~mask) {
+			addr = gcl->addr +
+			       sizeof(struct tsnep_gcl_operation) * i;
+
+			gcl->operation[i].properties &= mask;
+			iowrite32(gcl->operation[i].properties, addr);
+
+			break;
+		}
+	}
+}
+
+static u64 tsnep_insert_gcl_operation(struct tsnep_gcl *gcl, int ref,
+				      u64 change, u32 interval)
+{
+	u32 properties;
+
+	properties = gcl->operation[ref].properties & TSNEP_GCL_MASK;
+	/* change to new list directly after inserted operation */
+	properties |= TSNEP_GCL_CHANGE;
+
+	/* last operation of list is reserved to insert operation */
+	tsnep_write_gcl_operation(gcl, TSNEP_GCL_COUNT - 1, properties,
+				  interval, false);
+
+	return tsnep_set_gcl_change(gcl, ref, change, true);
+}
+
+static u64 tsnep_extend_gcl(struct tsnep_gcl *gcl, u64 start, u32 extension)
+{
+	int ref = gcl->count - 1;
+	u32 interval = gcl->operation[ref].interval + extension;
+
+	start -= gcl->operation[ref].interval;
+
+	return tsnep_insert_gcl_operation(gcl, ref, start, interval);
+}
+
+static u64 tsnep_cut_gcl(struct tsnep_gcl *gcl, u64 start, u64 cycle_time)
+{
+	u64 sum = 0;
+	int i;
+
+	/* find operation which shall be cutted */
+	for (i = 0; i < gcl->count; i++) {
+		u64 sum_tmp = sum + gcl->operation[i].interval;
+		u64 interval;
+
+		/* sum up operations as long as cycle time is not exceeded */
+		if (sum_tmp > cycle_time)
+			break;
+
+		/* remaining interval must be big enough for hardware */
+		interval = cycle_time - sum_tmp;
+		if (interval > 0 && interval < TSNEP_GCL_MIN_INTERVAL)
+			break;
+
+		sum = sum_tmp;
+	}
+	if (sum == cycle_time) {
+		/* no need to cut operation itself or whole cycle
+		 * => change exactly at operation
+		 */
+		return tsnep_set_gcl_change(gcl, i, start + sum, false);
+	}
+	return tsnep_insert_gcl_operation(gcl, i, start + sum,
+					  cycle_time - sum);
+}
+
+static int tsnep_enable_gcl(struct tsnep_adapter *adapter,
+			    struct tsnep_gcl *gcl, struct tsnep_gcl *curr)
+{
+	u64 system_time;
+	u64 timeout;
+	u64 limit;
+
+	/* estimate timeout limit after timeout enable, actually timeout limit
+	 * in hardware will be earlier than estimate so we are on the safe side
+	 */
+	tsnep_get_system_time(adapter, &system_time);
+	timeout = system_time + TSNEP_GC_TIMEOUT;
+
+	if (curr)
+		limit = timeout + curr->change_limit;
+	else
+		limit = timeout;
+
+	gcl->start_time = tsnep_gcl_start_after(gcl, limit);
+
+	/* gate control time register is only 32bit => time shall be in the near
+	 * future (no driver support for far future implemented)
+	 */
+	if ((gcl->start_time - system_time) >= U32_MAX)
+		return -EAGAIN;
+
+	if (curr) {
+		/* change gate control list */
+		u64 last;
+		u64 change;
+
+		last = tsnep_gcl_start_before(curr, gcl->start_time);
+		if ((last + curr->cycle_time) == gcl->start_time)
+			change = tsnep_cut_gcl(curr, last,
+					       gcl->start_time - last);
+		else if (((gcl->start_time - last) <=
+			  curr->cycle_time_extension) ||
+			 ((gcl->start_time - last) <= TSNEP_GCL_MIN_INTERVAL))
+			change = tsnep_extend_gcl(curr, last,
+						  gcl->start_time - last);
+		else
+			change = tsnep_cut_gcl(curr, last,
+					       gcl->start_time - last);
+
+		WARN_ON(change <= timeout);
+		gcl->change = true;
+		iowrite32(change & 0xFFFFFFFF, adapter->addr + TSNEP_GC_CHANGE);
+	} else {
+		/* start gate control list */
+		WARN_ON(gcl->start_time <= timeout);
+		gcl->change = false;
+		iowrite32(gcl->start_time & 0xFFFFFFFF,
+			  adapter->addr + TSNEP_GC_TIME);
+	}
+
+	return 0;
+}
+
+static int tsnep_taprio(struct tsnep_adapter *adapter,
+			struct tc_taprio_qopt_offload *qopt)
+{
+	struct tsnep_gcl *gcl;
+	struct tsnep_gcl *curr;
+	int retval;
+
+	if (!adapter->gate_control)
+		return -EOPNOTSUPP;
+
+	if (!qopt->enable) {
+		/* disable gate control if active */
+		mutex_lock(&adapter->gate_control_lock);
+
+		if (adapter->gate_control_active) {
+			iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
+			adapter->gate_control_active = false;
+		}
+
+		mutex_unlock(&adapter->gate_control_lock);
+
+		return 0;
+	}
+
+	retval = tsnep_validate_gcl(qopt);
+	if (retval)
+		return retval;
+
+	mutex_lock(&adapter->gate_control_lock);
+
+	gcl = &adapter->gcl[adapter->next_gcl];
+	tsnep_write_gcl(gcl, qopt);
+
+	/* select current gate control list if active */
+	if (adapter->gate_control_active) {
+		if (adapter->next_gcl == 0)
+			curr = &adapter->gcl[1];
+		else
+			curr = &adapter->gcl[0];
+	} else {
+		curr = NULL;
+	}
+
+	for (;;) {
+		/* start timeout which discards late enable, this helps ensuring
+		 * that start/change time are in the future at enable
+		 */
+		iowrite8(TSNEP_GC_ENABLE_TIMEOUT, adapter->addr + TSNEP_GC);
+
+		retval = tsnep_enable_gcl(adapter, gcl, curr);
+		if (retval) {
+			mutex_unlock(&adapter->gate_control_lock);
+
+			return retval;
+		}
+
+		/* enable gate control list */
+		if (adapter->next_gcl == 0)
+			iowrite8(TSNEP_GC_ENABLE_A, adapter->addr + TSNEP_GC);
+		else
+			iowrite8(TSNEP_GC_ENABLE_B, adapter->addr + TSNEP_GC);
+
+		/* done if timeout did not happen */
+		if (!(ioread32(adapter->addr + TSNEP_GC) &
+		      TSNEP_GC_TIMEOUT_SIGNAL))
+			break;
+
+		/* timeout is acknowledged with any enable */
+		iowrite8(TSNEP_GC_ENABLE_A, adapter->addr + TSNEP_GC);
+
+		if (curr)
+			tsnep_clean_gcl(curr);
+
+		/* retry because of timeout */
+	}
+
+	adapter->gate_control_active = true;
+
+	if (adapter->next_gcl == 0)
+		adapter->next_gcl = 1;
+	else
+		adapter->next_gcl = 0;
+
+	mutex_unlock(&adapter->gate_control_lock);
+
+	return 0;
+}
+
+int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
+		   void *type_data)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	switch (type) {
+	case TC_SETUP_QDISC_TAPRIO:
+		return tsnep_taprio(adapter, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int tsnep_tc_init(struct tsnep_adapter *adapter)
+{
+	if (!adapter->gate_control)
+		return 0;
+
+	/* open all gates */
+	iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
+	iowrite32(TSNEP_GC_OPEN | TSNEP_GC_NEXT_OPEN, adapter->addr + TSNEP_GC);
+
+	adapter->gcl[0].addr = adapter->addr + TSNEP_GCL_A;
+	adapter->gcl[1].addr = adapter->addr + TSNEP_GCL_B;
+
+	return 0;
+}
+
+void tsnep_tc_cleanup(struct tsnep_adapter *adapter)
+{
+	if (!adapter->gate_control)
+		return;
+
+	if (adapter->gate_control_active) {
+		iowrite8(TSNEP_GC_DISABLE, adapter->addr + TSNEP_GC);
+		adapter->gate_control_active = false;
+	}
+}
-- 
2.20.1

