Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD032A0314
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 11:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJ3Kmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 06:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJ3Kmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 06:42:31 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A221C0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 03:42:31 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e2so2504794wme.1
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 03:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=7SKRcpJBDvushs/+KG/I886TAzE11R66+iefP6d6//k=;
        b=EHkwB/eciqRteK4HAhD6P/7oTDJmvnFmSsaez+AhbmGfrRV9kULlnghrMcq+YP6q33
         s5LOqOBhIrwzTlqyxfLKP6Ozf995HBZyN3Ulhg3PjzmvoOpms/EmJM/l/7xx/ERxAQ8o
         Gw6emh2q3TmCEtNtuqM7zaxSjJ2VNuM2UmLTL+A6rlGnfI36QxA8ShT/cQbiTm/WS7XL
         EbaWS17SLMPKi4rquG7OZVbqwYLzAJncV5oVsDt6zeZVJgIMnoyVSj0Dyakw7yY/LxOh
         CqmhA0nIaCFGJhP0mCmXTt7OYpaNCfikjcZA9N8Cma5RUVeSs4Uy/0rzx2TnXhHPUh/W
         SI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7SKRcpJBDvushs/+KG/I886TAzE11R66+iefP6d6//k=;
        b=LnMZiflDtxVY++AYgoK0RCmLhnZ4yF5NboU/caCm7IV1sY2+2bPygs1ny+filqg/Fq
         j4rBpG9BDzq7S4Jk/ckQ/PKqCoBBO8ivE8BW+Vjd9azN7Bi7Ku9Zq5vLO8oLGIAuERv2
         6gWQNx6pAZC9H84s+SW2HYZopEWmhs+/MTq09Yy0xhCQ/bZzqz/o57NpzSRwguPgwVOr
         0AAJ6xGQ5yp6HiOiBnn5PdM6/+leYUpDmm8rZZEpzhj85J2AaeftOepc61WPBzrFBxfV
         JauZV6yZ0WpIeSSXD78xQKli8egDhzuDs76fcXs6Q1vgFMS42v5XXNT8cOm1VRttHeQb
         HPeg==
X-Gm-Message-State: AOAM531dJO6Dk/fkwshgbRvCArVmoTsi5YW1DEEFYBjaKHF8M1hFt4pz
        LUgusS89Bjll0VS6g2NO8XZ1cA==
X-Google-Smtp-Source: ABdhPJx0Kj4GfYsccW1P4lggo0r5MHZGosTnyD2u8T618g+U7exPgFvDZLMpzVmO7D+5Dhp7qYQdDw==
X-Received: by 2002:a1c:740f:: with SMTP id p15mr1898330wmc.106.1604054549973;
        Fri, 30 Oct 2020 03:42:29 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id l26sm4060567wmi.39.2020.10.30.03.42.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2020 03:42:29 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v9 2/2] net: Add mhi-net driver
Date:   Fri, 30 Oct 2020 11:48:15 +0100
Message-Id: <1604054895-29137-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new network driver implementing MHI transport for
network packets. Packets can be in any format, though QMAP (rmnet)
is the usual protocol (flow control + PDN mux).

It support two MHI devices, IP_HW0 which is, the path to the IPA
(IP accelerator) on qcom modem, And IP_SW0 which is the software
driven IP path (to modem CPU).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 v2: - rebase on net-next
      - remove useless skb_linearize
      - check error type on mhi_queue return
      - rate limited errors
      - Schedule RX refill only on 'low' buf level
      - SET_NETDEV_DEV in probe
      - reorder device remove sequence
  v3: - Stop channels on net_register error
      - Remove useles parentheses
      - Add driver .owner
  v4: - prevent potential cpu hog in rx-refill loop
      - Access mtu via READ_ONCE
  v5: - Fix access to u64 stats
  v6: - Stop TX queue earlier if queue is full
      - Preventing 'abnormal' NETDEV_TX_BUSY path
  v7: - Stop dl/ul cb operations on channel resetting
  v8: - remove premature comment about TX threading gain
      - check rx_queued to determine queuing limits
      - fix probe error path (unified goto usage)
  v9: - fix coding style and comments for MHI bus
      - remove useless mhi_unprepare in probe (done by mhi core)

 drivers/net/Kconfig   |   7 ++
 drivers/net/Makefile  |   1 +
 drivers/net/mhi_net.c | 311 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 319 insertions(+)
 create mode 100644 drivers/net/mhi_net.c

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 1368d1d..ef830ed 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -426,6 +426,13 @@ config VSOCKMON
 	  mostly intended for developers or support to debug vsock issues. If
 	  unsure, say N.
 
+config MHI_NET
+	tristate "MHI network driver"
+	depends on MHI_BUS
+	help
+	  This is the network driver for MHI bus.  It can be used with
+	  QCOM based WWAN modems (like SDX55).  Say Y or M.
+
 endif # NET_CORE
 
 config SUNGEM_PHY
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 94b6080..8312037 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_GTP) += gtp.o
 obj-$(CONFIG_NLMON) += nlmon.o
 obj-$(CONFIG_NET_VRF) += vrf.o
 obj-$(CONFIG_VSOCKMON) += vsockmon.o
+obj-$(CONFIG_MHI_NET) += mhi_net.o
 
 #
 # Networking Drivers
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
new file mode 100644
index 0000000..9136085
--- /dev/null
+++ b/drivers/net/mhi_net.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* MHI Network driver - Network over MHI bus
+ *
+ * Copyright (C) 2020 Linaro Ltd <loic.poulain@linaro.org>
+ */
+
+#include <linux/if_arp.h>
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/u64_stats_sync.h>
+
+#define MHI_NET_MIN_MTU		ETH_MIN_MTU
+#define MHI_NET_MAX_MTU		0xffff
+#define MHI_NET_DEFAULT_MTU	0x4000
+
+struct mhi_net_stats {
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t rx_errors;
+	u64_stats_t rx_dropped;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	u64_stats_t tx_errors;
+	u64_stats_t tx_dropped;
+	atomic_t rx_queued;
+	struct u64_stats_sync tx_syncp;
+	struct u64_stats_sync rx_syncp;
+};
+
+struct mhi_net_dev {
+	struct mhi_device *mdev;
+	struct net_device *ndev;
+	struct delayed_work rx_refill;
+	struct mhi_net_stats stats;
+	u32 rx_queue_sz;
+};
+
+static int mhi_ndo_open(struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	/* Feed the rx buffer pool */
+	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+
+	/* Carrier is established via out-of-band channel (e.g. qmi) */
+	netif_carrier_on(ndev);
+
+	netif_start_queue(ndev);
+
+	return 0;
+}
+
+static int mhi_ndo_stop(struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+
+	netif_stop_queue(ndev);
+	netif_carrier_off(ndev);
+	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
+
+	return 0;
+}
+
+static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int err;
+
+	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
+	if (unlikely(err)) {
+		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
+				    ndev->name, err);
+
+		u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.tx_dropped);
+		u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+
+		/* drop the packet */
+		kfree_skb(skb);
+	}
+
+	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
+		netif_stop_queue(ndev);
+
+	return NETDEV_TX_OK;
+}
+
+static void mhi_ndo_get_stats64(struct net_device *ndev,
+				struct rtnl_link_stats64 *stats)
+{
+	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
+		stats->rx_packets = u64_stats_read(&mhi_netdev->stats.rx_packets);
+		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
+		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
+		stats->rx_dropped = u64_stats_read(&mhi_netdev->stats.rx_dropped);
+	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
+
+	do {
+		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.tx_syncp);
+		stats->tx_packets = u64_stats_read(&mhi_netdev->stats.tx_packets);
+		stats->tx_bytes = u64_stats_read(&mhi_netdev->stats.tx_bytes);
+		stats->tx_errors = u64_stats_read(&mhi_netdev->stats.tx_errors);
+		stats->tx_dropped = u64_stats_read(&mhi_netdev->stats.tx_dropped);
+	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
+}
+
+static const struct net_device_ops mhi_netdev_ops = {
+	.ndo_open               = mhi_ndo_open,
+	.ndo_stop               = mhi_ndo_stop,
+	.ndo_start_xmit         = mhi_ndo_xmit,
+	.ndo_get_stats64	= mhi_ndo_get_stats64,
+};
+
+static void mhi_net_setup(struct net_device *ndev)
+{
+	ndev->header_ops = NULL;  /* No header */
+	ndev->type = ARPHRD_NONE; /* QMAP... */
+	ndev->hard_header_len = 0;
+	ndev->addr_len = 0;
+	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	ndev->netdev_ops = &mhi_netdev_ops;
+	ndev->mtu = MHI_NET_DEFAULT_MTU;
+	ndev->min_mtu = MHI_NET_MIN_MTU;
+	ndev->max_mtu = MHI_NET_MAX_MTU;
+	ndev->tx_queue_len = 1000;
+}
+
+static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct sk_buff *skb = mhi_res->buf_addr;
+	int remaining;
+
+	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
+
+	if (unlikely(mhi_res->transaction_status)) {
+		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.rx_errors);
+		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+
+		kfree_skb(skb);
+
+		/* MHI layer resetting the DL channel */
+		if (mhi_res->transaction_status == -ENOTCONN)
+			return;
+	} else {
+		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_netdev->stats.rx_packets);
+		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
+		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
+
+		skb->protocol = htons(ETH_P_MAP);
+		skb_put(skb, mhi_res->bytes_xferd);
+		netif_rx(skb);
+	}
+
+	/* Refill if RX buffers queue becomes low */
+	if (remaining <= mhi_netdev->rx_queue_sz / 2)
+		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+}
+
+static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
+				struct mhi_result *mhi_res)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct sk_buff *skb = mhi_res->buf_addr;
+
+	/* Hardware has consumed the buffer, so free the skb (which is not
+	 * freed by the MHI stack) and perform accounting.
+	 */
+	consume_skb(skb);
+
+	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
+	if (unlikely(mhi_res->transaction_status)) {
+		u64_stats_inc(&mhi_netdev->stats.tx_errors);
+
+		/* MHI layer resetting the UL channel */
+		if (mhi_res->transaction_status == -ENOTCONN)
+			return;
+	} else {
+		u64_stats_inc(&mhi_netdev->stats.tx_packets);
+		u64_stats_add(&mhi_netdev->stats.tx_bytes, mhi_res->bytes_xferd);
+	}
+	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+
+	if (netif_queue_stopped(ndev))
+		netif_wake_queue(ndev);
+}
+
+static void mhi_net_rx_refill_work(struct work_struct *work)
+{
+	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
+						      rx_refill.work);
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int size = READ_ONCE(ndev->mtu);
+	struct sk_buff *skb;
+	int err;
+
+	do {
+		skb = netdev_alloc_skb(ndev, size);
+		if (unlikely(!skb))
+			break;
+
+		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
+		if (unlikely(err)) {
+			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
+					    ndev->name, err);
+			kfree_skb(skb);
+			break;
+		}
+
+		/* Do not hog the CPU if rx buffers are consumed faster than
+		 * queued (unlikely).
+		 */
+		cond_resched();
+	} while (atomic_inc_return(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz);
+
+	/* If we're still starved of rx buffers, reschedule later */
+	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
+		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
+}
+
+static int mhi_net_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	const char *netname = (char *)id->driver_data;
+	struct device *dev = &mhi_dev->dev;
+	struct mhi_net_dev *mhi_netdev;
+	struct net_device *ndev;
+	int err;
+
+	ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
+			    mhi_net_setup);
+	if (!ndev)
+		return -ENOMEM;
+
+	mhi_netdev = netdev_priv(ndev);
+	dev_set_drvdata(dev, mhi_netdev);
+	mhi_netdev->ndev = ndev;
+	mhi_netdev->mdev = mhi_dev;
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+
+	/* All MHI net channels have 128 ring elements (at least for now) */
+	mhi_netdev->rx_queue_sz = 128;
+
+	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
+	u64_stats_init(&mhi_netdev->stats.rx_syncp);
+	u64_stats_init(&mhi_netdev->stats.tx_syncp);
+
+	/* Start MHI channels */
+	err = mhi_prepare_for_transfer(mhi_dev);
+	if (err)
+		goto out_err;
+
+	err = register_netdev(ndev);
+	if (err)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	free_netdev(ndev);
+	return err;
+}
+
+static void mhi_net_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+
+	unregister_netdev(mhi_netdev->ndev);
+
+	mhi_unprepare_from_transfer(mhi_netdev->mdev);
+
+	free_netdev(mhi_netdev->ndev);
+}
+
+static const struct mhi_device_id mhi_net_id_table[] = {
+	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)"mhi_hwip%d" },
+	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)"mhi_swip%d" },
+	{}
+};
+MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
+
+static struct mhi_driver mhi_net_driver = {
+	.probe = mhi_net_probe,
+	.remove = mhi_net_remove,
+	.dl_xfer_cb = mhi_net_dl_callback,
+	.ul_xfer_cb = mhi_net_ul_callback,
+	.id_table = mhi_net_id_table,
+	.driver = {
+		.name = "mhi_net",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_mhi_driver(mhi_net_driver);
+
+MODULE_AUTHOR("Loic Poulain <loic.poulain@linaro.org>");
+MODULE_DESCRIPTION("Network over MHI");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

