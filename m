Return-Path: <netdev+bounces-8452-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9B672422D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EB3E1C20FE7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B85017FE6;
	Tue,  6 Jun 2023 12:31:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C04917AAA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:31:32 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C9A10CA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:31:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b02085bf8dso26481445ad.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686054690; x=1688646690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bR4/JDXMxihfPEGKcTXFJHlKlbGf1Imp+ICKaG0tKk=;
        b=Lsv9Pjc/J5JCZCZkwVIv1r9X0WEbg5FRCdvenElvxxx0PTZEf8gbj9362LLy1ehymJ
         zociLJ2QXW/iA3xrTvZhEf4OI/piTJrkwU50aY/wvDIRfdpS+PJFBI1UsP2nNOYucREf
         DmI0QD+5EalV8fer6j1blh9WOsYETWSKzCucZTrgBt/wWL4a/WIdMiqcMJMgLobqUPCm
         HR6QFWMgbTQt/ljD2zy99UUFzpG4lZASRyrakL2irja6MtwiAxZ/LN8DSB85cw3lcm8h
         2vWjo6QjCntgUNa/2pDm5kka+8vrmidC7NKtfxHtRgOshQ+CmVxfDSlHGgc161kaOkXy
         TwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686054690; x=1688646690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4bR4/JDXMxihfPEGKcTXFJHlKlbGf1Imp+ICKaG0tKk=;
        b=QnsdOV78ia/7W+buYdt8wWwqoYchb7hhEZISCrglnIKIYKV5kDHtXbOA76nS7EBnVM
         dxcrUIG774MtXV6mGFIHr75kjhGnBhFtGnmsCTa5C020eHtlAqgvL10ymfvgsPIwHgXn
         RDZgI10oyFc8c4NH6qepmLu0te+/MJo0UL1J7r5tqJuvQ/ZHL2nvgWRW2zDNey6WwceD
         SD70DXRnQpyceaakt/s9nYgL3evtB7Z5T5c/DGtctnB0YFwWvoYaWSHt9A9GoLX5zOpn
         OI4xVyVsvqHAudsu4IGd3jamTMu8TNKriZK+YRInv2MmQWC0rL2p7Ggcq1ebBm+3ksaZ
         3FhA==
X-Gm-Message-State: AC+VfDxremf3mEe2OXYexAdfuIbXhEJTZysz92WzV4rHwf0sSebekHWR
	4LLcYNQkGC/FZABlMiPWmzlBq2bVD83RRXFvJA==
X-Google-Smtp-Source: ACHHUZ4wOgD8oZXJOUzfrt5cyuhOiIytzpywDtwkmMEz/ZhifHxmQ+jj+TpidcYSbsz6Q9nB3rZQNw==
X-Received: by 2002:a17:903:1250:b0:1b0:4680:3f with SMTP id u16-20020a170903125000b001b04680003fmr764540plh.41.1686054689929;
        Tue, 06 Jun 2023 05:31:29 -0700 (PDT)
Received: from localhost.localdomain ([117.202.186.178])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902c74500b001ae59169f05sm8446431plq.182.2023.06.06.05.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 05:31:29 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loic.poulain@linaro.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 1/3] net: Add MHI Endpoint network driver
Date: Tue,  6 Jun 2023 18:01:17 +0530
Message-Id: <20230606123119.57499-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a network driver for the Modem Host Interface (MHI) endpoint devices
that provides network interfaces to the PCIe based Qualcomm endpoint
devices supporting MHI bus. This driver allows the MHI endpoint devices to
establish IP communication with the host machines (x86, ARM64) over MHI
bus.

The driver currently supports only IP_SW0 MHI channel that can be used
to route IP traffic from the endpoint CPU to host machine.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/net/Kconfig      |   9 ++
 drivers/net/Makefile     |   1 +
 drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 341 insertions(+)
 create mode 100644 drivers/net/mhi_ep_net.c

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 368c6f5b327e..ec1382d7fcbd 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -452,6 +452,15 @@ config MHI_NET
 	  QCOM based WWAN modems for IP or QMAP/rmnet protocol (like SDX55).
 	  Say Y or M.
 
+config MHI_EP_NET
+	tristate "MHI Endpoint network driver"
+	depends on MHI_BUS_EP
+	help
+	  This is the network driver for MHI bus implementation in endpoint
+	  devices. It is used provide the network interface for QCOM modems
+	  such as SDX55.
+	  Say Y or M.
+
 endif # NET_CORE
 
 config SUNGEM_PHY
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index e26f98f897c5..b8e706a4150e 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_NLMON) += nlmon.o
 obj-$(CONFIG_NET_VRF) += vrf.o
 obj-$(CONFIG_VSOCKMON) += vsockmon.o
 obj-$(CONFIG_MHI_NET) += mhi_net.o
+obj-$(CONFIG_MHI_EP_NET) += mhi_ep_net.o
 
 #
 # Networking Drivers
diff --git a/drivers/net/mhi_ep_net.c b/drivers/net/mhi_ep_net.c
new file mode 100644
index 000000000000..b3960814c879
--- /dev/null
+++ b/drivers/net/mhi_ep_net.c
@@ -0,0 +1,331 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * MHI Endpoint Network driver
+ *
+ * Based on drivers/net/mhi_net.c
+ *
+ * Copyright (c) 2023, Linaro Ltd.
+ * Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
+ */
+
+#include <linux/if_arp.h>
+#include <linux/mhi_ep.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/u64_stats_sync.h>
+
+#define MHI_NET_MIN_MTU		ETH_MIN_MTU
+#define MHI_NET_MAX_MTU		0xffff
+
+struct mhi_ep_net_stats {
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t rx_errors;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	u64_stats_t tx_errors;
+	u64_stats_t tx_dropped;
+	struct u64_stats_sync tx_syncp;
+	struct u64_stats_sync rx_syncp;
+};
+
+struct mhi_ep_net_dev {
+	struct mhi_ep_device *mdev;
+	struct net_device *ndev;
+	struct mhi_ep_net_stats stats;
+	struct workqueue_struct *xmit_wq;
+	struct work_struct xmit_work;
+	struct sk_buff_head tx_buffers;
+	spinlock_t tx_lock; /* Lock for protecting tx_buffers */
+	u32 mru;
+};
+
+static void mhi_ep_net_dev_process_queue_packets(struct work_struct *work)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = container_of(work,
+			struct mhi_ep_net_dev, xmit_work);
+	struct mhi_ep_device *mdev = mhi_ep_netdev->mdev;
+	struct sk_buff_head q;
+	struct sk_buff *skb;
+	int ret;
+
+	if (mhi_ep_queue_is_empty(mdev, DMA_FROM_DEVICE)) {
+		netif_stop_queue(mhi_ep_netdev->ndev);
+		return;
+	}
+
+	__skb_queue_head_init(&q);
+
+	spin_lock_bh(&mhi_ep_netdev->tx_lock);
+	skb_queue_splice_init(&mhi_ep_netdev->tx_buffers, &q);
+	spin_unlock_bh(&mhi_ep_netdev->tx_lock);
+
+	while ((skb = __skb_dequeue(&q))) {
+		ret = mhi_ep_queue_skb(mdev, skb);
+		if (ret) {
+			kfree(skb);
+			goto exit_drop;
+		}
+
+		u64_stats_update_begin(&mhi_ep_netdev->stats.tx_syncp);
+		u64_stats_inc(&mhi_ep_netdev->stats.tx_packets);
+		u64_stats_add(&mhi_ep_netdev->stats.tx_bytes, skb->len);
+		u64_stats_update_end(&mhi_ep_netdev->stats.tx_syncp);
+
+		/* Check if queue is empty */
+		if (mhi_ep_queue_is_empty(mdev, DMA_FROM_DEVICE)) {
+			netif_stop_queue(mhi_ep_netdev->ndev);
+			break;
+		}
+
+		consume_skb(skb);
+		cond_resched();
+	}
+
+	return;
+
+exit_drop:
+	u64_stats_update_begin(&mhi_ep_netdev->stats.tx_syncp);
+	u64_stats_inc(&mhi_ep_netdev->stats.tx_dropped);
+	u64_stats_update_end(&mhi_ep_netdev->stats.tx_syncp);
+}
+
+static int mhi_ndo_open(struct net_device *ndev)
+{
+	netif_carrier_on(ndev);
+	netif_start_queue(ndev);
+
+	return 0;
+}
+
+static int mhi_ndo_stop(struct net_device *ndev)
+{
+	netif_stop_queue(ndev);
+	netif_carrier_off(ndev);
+
+	return 0;
+}
+
+static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = netdev_priv(ndev);
+
+	spin_lock(&mhi_ep_netdev->tx_lock);
+	skb_queue_tail(&mhi_ep_netdev->tx_buffers, skb);
+	spin_unlock(&mhi_ep_netdev->tx_lock);
+
+	queue_work(mhi_ep_netdev->xmit_wq, &mhi_ep_netdev->xmit_work);
+
+	return NETDEV_TX_OK;
+}
+
+static void mhi_ndo_get_stats64(struct net_device *ndev,
+				struct rtnl_link_stats64 *stats)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = netdev_priv(ndev);
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin(&mhi_ep_netdev->stats.rx_syncp);
+		stats->rx_packets = u64_stats_read(&mhi_ep_netdev->stats.rx_packets);
+		stats->rx_bytes = u64_stats_read(&mhi_ep_netdev->stats.rx_bytes);
+		stats->rx_errors = u64_stats_read(&mhi_ep_netdev->stats.rx_errors);
+	} while (u64_stats_fetch_retry(&mhi_ep_netdev->stats.rx_syncp, start));
+
+	do {
+		start = u64_stats_fetch_begin(&mhi_ep_netdev->stats.tx_syncp);
+		stats->tx_packets = u64_stats_read(&mhi_ep_netdev->stats.tx_packets);
+		stats->tx_bytes = u64_stats_read(&mhi_ep_netdev->stats.tx_bytes);
+		stats->tx_errors = u64_stats_read(&mhi_ep_netdev->stats.tx_errors);
+		stats->tx_dropped = u64_stats_read(&mhi_ep_netdev->stats.tx_dropped);
+	} while (u64_stats_fetch_retry(&mhi_ep_netdev->stats.tx_syncp, start));
+}
+
+static const struct net_device_ops mhi_ep_netdev_ops = {
+	.ndo_open               = mhi_ndo_open,
+	.ndo_stop               = mhi_ndo_stop,
+	.ndo_start_xmit         = mhi_ndo_xmit,
+	.ndo_get_stats64	= mhi_ndo_get_stats64,
+};
+
+static void mhi_ep_net_setup(struct net_device *ndev)
+{
+	ndev->header_ops = NULL;  /* No header */
+	ndev->type = ARPHRD_RAWIP;
+	ndev->hard_header_len = 0;
+	ndev->addr_len = 0;
+	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	ndev->netdev_ops = &mhi_ep_netdev_ops;
+	ndev->mtu = MHI_EP_DEFAULT_MTU;
+	ndev->min_mtu = MHI_NET_MIN_MTU;
+	ndev->max_mtu = MHI_NET_MAX_MTU;
+	ndev->tx_queue_len = 1000;
+}
+
+static void mhi_ep_net_ul_callback(struct mhi_ep_device *mhi_dev,
+				   struct mhi_result *mhi_res)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = dev_get_drvdata(&mhi_dev->dev);
+	struct net_device *ndev = mhi_ep_netdev->ndev;
+	struct sk_buff *skb;
+	size_t size;
+
+	size = mhi_ep_netdev->mru ? mhi_ep_netdev->mru : READ_ONCE(ndev->mtu);
+
+	skb = netdev_alloc_skb(ndev, size);
+	if (unlikely(!skb)) {
+		u64_stats_update_begin(&mhi_ep_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_ep_netdev->stats.rx_errors);
+		u64_stats_update_end(&mhi_ep_netdev->stats.rx_syncp);
+		return;
+	}
+
+	skb_copy_to_linear_data(skb, mhi_res->buf_addr, mhi_res->bytes_xferd);
+	skb->len = mhi_res->bytes_xferd;
+	skb->dev = mhi_ep_netdev->ndev;
+
+	if (unlikely(mhi_res->transaction_status)) {
+		switch (mhi_res->transaction_status) {
+		case -ENOTCONN:
+			/* MHI layer stopping/resetting the UL channel */
+			dev_kfree_skb_any(skb);
+			return;
+		default:
+			/* Unknown error, simply drop */
+			dev_kfree_skb_any(skb);
+			u64_stats_update_begin(&mhi_ep_netdev->stats.rx_syncp);
+			u64_stats_inc(&mhi_ep_netdev->stats.rx_errors);
+			u64_stats_update_end(&mhi_ep_netdev->stats.rx_syncp);
+		}
+	} else {
+		skb_put(skb, mhi_res->bytes_xferd);
+
+		switch (skb->data[0] & 0xf0) {
+		case 0x40:
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case 0x60:
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			skb->protocol = htons(ETH_P_MAP);
+			break;
+		}
+
+		u64_stats_update_begin(&mhi_ep_netdev->stats.rx_syncp);
+		u64_stats_inc(&mhi_ep_netdev->stats.rx_packets);
+		u64_stats_add(&mhi_ep_netdev->stats.rx_bytes, skb->len);
+		u64_stats_update_end(&mhi_ep_netdev->stats.rx_syncp);
+		netif_rx(skb);
+	}
+}
+
+static void mhi_ep_net_dl_callback(struct mhi_ep_device *mhi_dev,
+				   struct mhi_result *mhi_res)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = dev_get_drvdata(&mhi_dev->dev);
+
+	if (unlikely(mhi_res->transaction_status == -ENOTCONN))
+		return;
+
+	/* Since we got enough buffers to queue, wake the queue if stopped */
+	if (netif_queue_stopped(mhi_ep_netdev->ndev)) {
+		netif_wake_queue(mhi_ep_netdev->ndev);
+		queue_work(mhi_ep_netdev->xmit_wq, &mhi_ep_netdev->xmit_work);
+	}
+}
+
+static int mhi_ep_net_newlink(struct mhi_ep_device *mhi_dev, struct net_device *ndev)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev;
+	int ret;
+
+	mhi_ep_netdev = netdev_priv(ndev);
+
+	dev_set_drvdata(&mhi_dev->dev, mhi_ep_netdev);
+	mhi_ep_netdev->ndev = ndev;
+	mhi_ep_netdev->mdev = mhi_dev;
+	mhi_ep_netdev->mru = mhi_dev->mhi_cntrl->mru;
+
+	skb_queue_head_init(&mhi_ep_netdev->tx_buffers);
+	spin_lock_init(&mhi_ep_netdev->tx_lock);
+
+	u64_stats_init(&mhi_ep_netdev->stats.rx_syncp);
+	u64_stats_init(&mhi_ep_netdev->stats.tx_syncp);
+
+	mhi_ep_netdev->xmit_wq = alloc_workqueue("mhi_ep_net_xmit_wq", 0, WQ_HIGHPRI);
+	INIT_WORK(&mhi_ep_netdev->xmit_work, mhi_ep_net_dev_process_queue_packets);
+
+	ret = register_netdev(ndev);
+	if (ret) {
+		destroy_workqueue(mhi_ep_netdev->xmit_wq);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void mhi_ep_net_dellink(struct mhi_ep_device *mhi_dev, struct net_device *ndev)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = netdev_priv(ndev);
+
+	destroy_workqueue(mhi_ep_netdev->xmit_wq);
+	unregister_netdev(ndev);
+	free_netdev(ndev);
+	dev_set_drvdata(&mhi_dev->dev, NULL);
+}
+
+static int mhi_ep_net_probe(struct mhi_ep_device *mhi_dev, const struct mhi_device_id *id)
+{
+	struct net_device *ndev;
+	int ret;
+
+	ndev = alloc_netdev(sizeof(struct mhi_ep_net_dev), (const char *)id->driver_data,
+			    NET_NAME_PREDICTABLE, mhi_ep_net_setup);
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
+
+	ret = mhi_ep_net_newlink(mhi_dev, ndev);
+	if (ret) {
+		free_netdev(ndev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void mhi_ep_net_remove(struct mhi_ep_device *mhi_dev)
+{
+	struct mhi_ep_net_dev *mhi_ep_netdev = dev_get_drvdata(&mhi_dev->dev);
+
+	mhi_ep_net_dellink(mhi_dev, mhi_ep_netdev->ndev);
+}
+
+static const struct mhi_device_id mhi_ep_net_id_table[] = {
+	/* Software data PATH (from endpoint CPU) */
+	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)"mhi_swip%d" },
+	{}
+};
+MODULE_DEVICE_TABLE(mhi, mhi_ep_net_id_table);
+
+static struct mhi_ep_driver mhi_ep_net_driver = {
+	.probe = mhi_ep_net_probe,
+	.remove = mhi_ep_net_remove,
+	.dl_xfer_cb = mhi_ep_net_dl_callback,
+	.ul_xfer_cb = mhi_ep_net_ul_callback,
+	.id_table = mhi_ep_net_id_table,
+	.driver = {
+		.name = "mhi_ep_net",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_mhi_ep_driver(mhi_ep_net_driver);
+
+MODULE_AUTHOR("Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>");
+MODULE_DESCRIPTION("MHI Endpoint Network driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1


