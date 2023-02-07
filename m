Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AF168E296
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBGVC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjBGVB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:01:57 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD383FF3F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:01:25 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 31-20020a630c5f000000b004fb0bd64941so2000135pgm.16
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 13:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRlj9+M+v66Mv6jnt/3vB/RwTH4VGxLXv/LOzOwjZGw=;
        b=C6Wg9+6krMjGAcq7BKQ/LGaJ4L9MM/elaDKNODRKyOdZRQlY7QpKIZRg8ePwWotMXH
         xHHZfQqd2gYZLKqhb1HJGBGd5rwqB2twJcoGSkVbb7qCoFQJyh9B6p9fFg5jhtCl7SRu
         8oBU+mfQXnYy/CiXBlytJv9EjPSkq6JGIvAXvDkMCNjHZ7V4M/AvkcKQ++uFP/XAkMJg
         gVD3FnwZh4+0t/oZ2O1yjRd8A0DC9Zyhuxpz89VDjb7l4Uhy/9bdEwbGBqXikWpOHWO8
         LaWGikJoZyPkKuiEH6Ge0HEVbnDBZeB9k2LA5nBoxjHjzYUYWbJA214vqsOyz/7lcyqY
         +fdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRlj9+M+v66Mv6jnt/3vB/RwTH4VGxLXv/LOzOwjZGw=;
        b=iFjE3guKFwj8k4VQORDiUa3/MpW7OYRpaFbOgsexfZu2Vr6H2H3Z2yXcMF83vc2Y7m
         ZPrRwq/U9gWdLz4lXQqfkWkY0gy1qX+M/5Ah9WPNiyZleCVpulIvHu6I4QW2pRFUmE+0
         6bvhwubvFIo9Mi709aeJ+Iah8Pf95KVVPCQKOTy++Sy7o26X88LxS8svo7uQ3g7TBWlZ
         Fys+EhQ/yfyNEGKKWc/LeAalUuXAyAfuYr066N7ndztASpGc55FDA2PaA5/3Pw+VxqMI
         5oIFd2DMgcOrGu9+ZnDqY/nRCFES1mFe8V7iyamvmS5JyoEbrT4sxs6XLGcBUvCI0Eov
         HsdA==
X-Gm-Message-State: AO0yUKUsd7MYXqPhF5aD9fmP1ymPjikRlDRBTE2BDaEqUpsSkeFxYqeL
        //OU2NU3tmQzy3PZFxqS0Bgit+zegwyKRrv7wzDUU+8Aua9+EjqHB0HZ+rqL7P0822IkvKXF6gp
        vANjq1+eQyTsEhmycC75mnYK0MlMDkkU9NDT//ICMBEdlqRKe+YfeK7L0Bqn5Iq8mBxbE202Qfo
        qLtg==
X-Google-Smtp-Source: AK7set9sEahppsBYbFi2C82tADlvVWwKQ+BovjAdlIoi2aI9VWsLkigMBy10v60iHDLg+66L6LpvUttMYlSR3A4P85k=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:966c:8be6:6e77:92b1])
 (user=pkaligineedi job=sendgmr) by 2002:aa7:98db:0:b0:593:f41a:fc78 with SMTP
 id e27-20020aa798db000000b00593f41afc78mr1108097pfm.25.1675803683918; Tue, 07
 Feb 2023 13:01:23 -0800 (PST)
Date:   Tue,  7 Feb 2023 13:00:56 -0800
In-Reply-To: <20230207210058.2257219-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230207210058.2257219-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230207210058.2257219-3-pkaligineedi@google.com>
Subject: [PATCH net-next 2/4] gve: Add XDP DROP and TX support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for XDP PASS, DROP and TX actions.

This patch contains the following changes:
1) Support installing/uninstalling XDP program
2) Add dedicated XDP TX queues
3) Add support for XDP DROP action
4) Add support for XDP TX action

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  30 +++-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  37 ++++-
 drivers/net/ethernet/google/gve/gve_main.c    | 145 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      |  73 ++++++++-
 drivers/net/ethernet/google/gve/gve_tx.c      | 130 +++++++++++++++-
 5 files changed, 399 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 770e87e3ec5e..8352f4c0e8d1 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -47,6 +47,10 @@
 
 #define GVE_RX_BUFFER_SIZE_DQO 2048
 
+#define GVE_XDP_ACTIONS 5
+
+#define GVE_XDP_PADDING 64
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
@@ -230,7 +234,9 @@ struct gve_rx_ring {
 	u64 rx_frag_flip_cnt; /* free-running count of rx segments where page_flip was used */
 	u64 rx_frag_copy_cnt; /* free-running count of rx segments copied */
 	u64 rx_frag_alloc_cnt; /* free-running count of rx page allocations */
-
+	u64 xdp_tx_errors;
+	u64 xdp_redirect_errors;
+	u64 xdp_actions[GVE_XDP_ACTIONS];
 	u32 q_num; /* queue index */
 	u32 ntfy_id; /* notification block index */
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
@@ -238,6 +244,9 @@ struct gve_rx_ring {
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
 
 	struct gve_rx_ctx ctx; /* Info for packet currently being processed in this ring. */
+
+	/* XDP stuff */
+	struct xdp_rxq_info xdp_rxq;
 };
 
 /* A TX desc ring entry */
@@ -259,6 +268,9 @@ struct gve_tx_iovec {
  */
 struct gve_tx_buffer_state {
 	struct sk_buff *skb; /* skb for this pkt */
+	struct {
+		u16 size; /* size of xmitted xdp pkt */
+	} xdp;
 	union {
 		struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
 		struct {
@@ -373,6 +385,8 @@ struct gve_tx_ring {
 		struct {
 			/* Spinlock for when cleanup in progress */
 			spinlock_t clean_lock;
+			/* Spinlock for XDP tx traffic */
+			spinlock_t xdp_lock;
 		};
 
 		/* DQO fields. */
@@ -526,9 +540,11 @@ struct gve_priv {
 	u16 rx_data_slot_cnt; /* rx buffer length */
 	u64 max_registered_pages;
 	u64 num_registered_pages; /* num pages registered with NIC */
+	struct bpf_prog __rcu *xdp_prog; /* XDP BPF program */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
 
+	u16 num_xdp_queues;
 	struct gve_queue_config tx_cfg;
 	struct gve_queue_config rx_cfg;
 	struct gve_qpl_config qpl_cfg; /* map used QPL ids */
@@ -785,7 +801,7 @@ static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
 	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
 		return 0;
 
-	return priv->tx_cfg.num_queues;
+	return priv->tx_cfg.num_queues + priv->num_xdp_queues;
 }
 
 /* Returns the number of rx queue page lists
@@ -857,7 +873,12 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 
 static inline int gve_num_tx_queues(struct gve_priv *priv)
 {
-	return priv->tx_cfg.num_queues;
+	return priv->tx_cfg.num_queues + priv->num_xdp_queues;
+}
+
+static inline int gve_xdp_tx_queue_id(struct gve_priv *priv, u32 queue_id)
+{
+	return priv->tx_cfg.num_queues + queue_id;
 }
 
 /* buffers */
@@ -868,7 +889,10 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
+int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
+		     void *data, int len, u32 flags);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
+bool gve_xdp_poll(struct gve_notify_block *block, int budget);
 int gve_tx_alloc_rings(struct gve_priv *priv);
 void gve_tx_free_rings_gqi(struct gve_priv *priv);
 u32 gve_tx_load_event_counter(struct gve_priv *priv,
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index a27cc314e799..d2f0b53eacbb 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -34,6 +34,11 @@ static u32 gve_get_msglevel(struct net_device *netdev)
 	return priv->msg_enable;
 }
 
+/* For the following stats column string names, make sure the order
+ * matches how it is filled in the code. For xdp_aborted, xdp_drop,
+ * xdp_pass, xdp_tx, xdp_redirect, make sure it also matches the order
+ * as declared in enum xdp_action inside file uapi/linux/bpf.h .
+ */
 static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 	"rx_packets", "tx_packets", "rx_bytes", "tx_bytes",
 	"rx_dropped", "tx_dropped", "tx_timeouts",
@@ -49,6 +54,9 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 	"rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]",
 	"rx_queue_drop_cnt[%u]", "rx_no_buffers_posted[%u]",
 	"rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
+	"rx_xdp_aborted[%u]", "rx_xdp_drop[%u]", "rx_xdp_pass[%u]",
+	"rx_xdp_tx[%u]", "rx_xdp_redirect[%u]",
+	"rx_xdp_tx_errors[%u]", "rx_xdp_redirect_errors[%u]",
 };
 
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
@@ -289,14 +297,24 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			if (skip_nic_stats) {
 				/* skip NIC rx stats */
 				i += NIC_RX_STATS_REPORT_NUM;
-				continue;
-			}
-			for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
-				u64 value =
-				be64_to_cpu(report_stats[rx_qid_to_stats_idx[ring] + j].value);
-
-				data[i++] = value;
+			} else {
+				stats_idx = rx_qid_to_stats_idx[ring];
+				for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
+					u64 value =
+						be64_to_cpu(report_stats[stats_idx + j].value);
+					data[i++] = value;
+				}
 			}
+			/* XDP rx counters */
+			do {
+				start =	u64_stats_fetch_begin(&priv->rx[ring].statss);
+				for (j = 0; j < GVE_XDP_ACTIONS; j++)
+					data[i + j] = rx->xdp_actions[j];
+				data[i + j++] = rx->xdp_tx_errors;
+				data[i + j++] = rx->xdp_redirect_errors;
+			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+						       start));
+			i += GVE_XDP_ACTIONS + 2; /* XDP rx counters */
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
@@ -418,6 +436,11 @@ static int gve_set_channels(struct net_device *netdev,
 	if (!new_rx || !new_tx)
 		return -EINVAL;
 
+	if (priv->xdp_prog &&
+	    (new_tx != new_rx || (2 * new_tx > priv->tx_cfg.max_queues))) {
+		return -EINVAL;
+	}
+
 	if (!netif_carrier_ok(netdev)) {
 		priv->tx_cfg.num_queues = new_tx;
 		priv->rx_cfg.num_queues = new_rx;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index e69d21facd29..5050aa3aa1c3 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -4,8 +4,10 @@
  * Copyright (C) 2015-2021 Google, Inc.
  */
 
+#include <linux/bpf.h>
 #include <linux/cpumask.h>
 #include <linux/etherdevice.h>
+#include <linux/filter.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -247,8 +249,13 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 	block = container_of(napi, struct gve_notify_block, napi);
 	priv = block->priv;
 
-	if (block->tx)
-		reschedule |= gve_tx_poll(block, budget);
+	if (block->tx) {
+		if (block->tx->q_num < priv->tx_cfg.num_queues)
+			reschedule |= gve_tx_poll(block, budget);
+		else
+			reschedule |= gve_xdp_poll(block, budget);
+	}
+
 	if (block->rx) {
 		work_done = gve_rx_poll(block, budget);
 		reschedule |= work_done == budget;
@@ -974,11 +981,50 @@ static int gve_reset_recovery(struct gve_priv *priv, bool was_up);
 static void gve_turndown(struct gve_priv *priv);
 static void gve_turnup(struct gve_priv *priv);
 
+static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
+{
+	int err = 0, i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		struct gve_rx_ring *rx = &priv->rx[i];
+		struct napi_struct *napi =
+			&priv->ntfy_blocks[rx->ntfy_id].napi;
+
+		err = xdp_rxq_info_reg(&rx->xdp_rxq, dev, i,
+				       napi->napi_id);
+		if (err)
+			goto out;
+		err = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq,
+						 MEM_TYPE_PAGE_SHARED, NULL);
+		if (err)
+			goto out;
+	}
+
+out:
+	return err;
+}
+
+static void gve_unreg_xdp_info(struct gve_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		struct gve_rx_ring *rx = &priv->rx[i];
+
+		xdp_rxq_info_unreg(&rx->xdp_rxq);
+	}
+}
+
 static int gve_open(struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	int err;
 
+	if (priv->xdp_prog)
+		priv->num_xdp_queues = priv->tx_cfg.num_queues;
+	else
+		priv->num_xdp_queues = 0;
+
 	err = gve_alloc_qpls(priv);
 	if (err)
 		return err;
@@ -994,6 +1040,10 @@ static int gve_open(struct net_device *dev)
 	if (err)
 		goto free_rings;
 
+	err = gve_reg_xdp_info(priv, dev);
+	if (err)
+		goto free_rings;
+
 	err = gve_register_qpls(priv);
 	if (err)
 		goto reset;
@@ -1058,6 +1108,7 @@ static int gve_close(struct net_device *dev)
 	}
 	del_timer_sync(&priv->stats_report_timer);
 
+	gve_unreg_xdp_info(priv);
 	gve_free_rings(priv);
 	gve_free_qpls(priv);
 	priv->interface_down_cnt++;
@@ -1074,6 +1125,95 @@ static int gve_close(struct net_device *dev)
 	return gve_reset_recovery(priv, false);
 }
 
+static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
+		       struct netlink_ext_ack *extack)
+{
+	struct bpf_prog *old_prog;
+	struct napi_struct *napi;
+	int q;
+	int err;
+
+	old_prog = rtnl_dereference(priv->xdp_prog);
+	if (!!prog != !!old_prog) {
+		// Adding/removing a program, need to recreate the queues.
+		if (!netif_carrier_ok(priv->dev)) {
+			rcu_assign_pointer(priv->xdp_prog, prog);
+			goto out;
+		}
+		err = gve_close(priv->dev);
+		if (err)
+			return err;
+
+		rcu_assign_pointer(priv->xdp_prog, prog);
+		gve_open(priv->dev);
+	} else {
+		// Changing the XDP program. Flush the queues.
+		rcu_assign_pointer(priv->xdp_prog, prog);
+		if (netif_carrier_ok(priv->dev)) {
+			for (q = 0; q < priv->rx_cfg.num_queues; q++) {
+				napi = &priv->ntfy_blocks[priv->rx[q].ntfy_id].napi;
+				napi_disable(napi);
+				napi_enable(napi);
+				if (gve_rx_work_pending(&priv->rx[q]))
+					napi_schedule(napi);
+			}
+		}
+	}
+
+out:
+	if (old_prog)
+		bpf_prog_put(old_prog);
+	return 0;
+}
+
+static int verify_xdp_configuration(struct net_device *dev)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+
+	if (dev->features & NETIF_F_LRO) {
+		netdev_warn(dev, "XDP is not supported when LRO is on.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (priv->queue_format != GVE_GQI_QPL_FORMAT) {
+		netdev_warn(dev, "XDP is not supported in mode %d.\n",
+			    priv->queue_format);
+		return -EOPNOTSUPP;
+	}
+
+	if (dev->mtu > (PAGE_SIZE / 2) - sizeof(struct ethhdr) - GVE_RX_PAD) {
+		netdev_warn(dev, "XDP is not working with mtu %d.\n",
+			    dev->mtu);
+		return -EOPNOTSUPP;
+	}
+
+	if (priv->rx_cfg.num_queues != priv->tx_cfg.num_queues ||
+	    (2 * priv->tx_cfg.num_queues > priv->tx_cfg.max_queues)) {
+		netdev_warn(dev, "XDP load failed: The number of configured RX queues %d should be equal to the number of configured TX queues %d and the number of configured RX/TX queues should be less than or equal to half the maximum number of RX/TX queues %d",
+			    priv->rx_cfg.num_queues,
+			    priv->tx_cfg.num_queues,
+			    priv->tx_cfg.max_queues);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int gve_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	int err;
+
+	err = verify_xdp_configuration(dev);
+	if (err)
+		return err;
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return gve_set_xdp(priv, xdp->prog, xdp->extack);
+	default:
+		return -EINVAL;
+	}
+}
+
 int gve_adjust_queues(struct gve_priv *priv,
 		      struct gve_queue_config new_rx_config,
 		      struct gve_queue_config new_tx_config)
@@ -1268,6 +1408,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_get_stats64	=	gve_get_stats,
 	.ndo_tx_timeout         =       gve_tx_timeout,
 	.ndo_set_features	=	gve_set_features,
+	.ndo_bpf		=	gve_xdp,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index db1c74b1d7d3..3785bc150546 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -8,6 +8,8 @@
 #include "gve_adminq.h"
 #include "gve_utils.h"
 #include <linux/etherdevice.h>
+#include <linux/filter.h>
+#include <net/xdp.h>
 
 static void gve_rx_free_buffer(struct device *dev,
 			       struct gve_rx_slot_page_info *page_info,
@@ -591,6 +593,46 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 	return skb;
 }
 
+static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx,
+			 struct xdp_buff *xdp, struct bpf_prog *xprog,
+			 int xdp_act)
+{
+	struct gve_tx_ring *tx;
+	int tx_qid;
+	int err;
+
+	switch (xdp_act) {
+	case XDP_ABORTED:
+	case XDP_DROP:
+	default:
+		break;
+	case XDP_TX:
+		tx_qid = gve_xdp_tx_queue_id(priv, rx->q_num);
+		tx = &priv->tx[tx_qid];
+		spin_lock(&tx->xdp_lock);
+		err = gve_xdp_xmit_one(priv, tx, xdp->data,
+				       xdp->data_end - xdp->data,
+				       XDP_XMIT_FLUSH);
+		spin_unlock(&tx->xdp_lock);
+
+		if (unlikely(err)) {
+			u64_stats_update_begin(&rx->statss);
+			rx->xdp_tx_errors++;
+			u64_stats_update_end(&rx->statss);
+		}
+		break;
+	case XDP_REDIRECT:
+		u64_stats_update_begin(&rx->statss);
+		rx->xdp_redirect_errors++;
+		u64_stats_update_end(&rx->statss);
+		break;
+	}
+	u64_stats_update_begin(&rx->statss);
+	if ((u32)xdp_act < GVE_XDP_ACTIONS)
+		rx->xdp_actions[xdp_act]++;
+	u64_stats_update_end(&rx->statss);
+}
+
 #define GVE_PKTCONT_BIT_IS_SET(x) (GVE_RXF_PKT_CONT & (x))
 static void gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 		   struct gve_rx_desc *desc, u32 idx,
@@ -603,9 +645,12 @@ static void gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 	union gve_rx_data_slot *data_slot;
 	struct gve_priv *priv = rx->gve;
 	struct sk_buff *skb = NULL;
+	struct bpf_prog *xprog;
+	struct xdp_buff xdp;
 	dma_addr_t page_bus;
 	void *va;
 
+	u16 len = frag_size;
 	struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
 	bool is_first_frag = ctx->frag_cnt == 0;
 
@@ -645,9 +690,35 @@ static void gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
 				PAGE_SIZE, DMA_FROM_DEVICE);
 	page_info->pad = is_first_frag ? GVE_RX_PAD : 0;
+	len -= page_info->pad;
 	frag_size -= page_info->pad;
 
-	skb = gve_rx_skb(priv, rx, page_info, napi, frag_size,
+	xprog = rcu_dereference(priv->xdp_prog);
+	if (xprog && is_only_frag) {
+		void *old_data;
+		int xdp_act;
+
+		xdp_init_buff(&xdp, rx->packet_buffer_size, &rx->xdp_rxq);
+		xdp_prepare_buff(&xdp, page_info->page_address +
+				 page_info->page_offset, GVE_RX_PAD,
+				 len, false);
+		old_data = xdp.data;
+		xdp_act = bpf_prog_run_xdp(xprog, &xdp);
+		if (xdp_act != XDP_PASS) {
+			gve_xdp_done(priv, rx, &xdp, xprog, xdp_act);
+			ctx->total_size += frag_size;
+			goto finish_ok_pkt;
+		}
+
+		page_info->pad += xdp.data - old_data;
+		len = xdp.data_end - xdp.data;
+
+		u64_stats_update_begin(&rx->statss);
+		rx->xdp_actions[XDP_PASS]++;
+		u64_stats_update_end(&rx->statss);
+	}
+
+	skb = gve_rx_skb(priv, rx, page_info, napi, len,
 			 data_slot, is_only_frag);
 	if (!skb) {
 		u64_stats_update_begin(&rx->statss);
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 429b159ac61a..a2fc4b074f52 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -135,6 +135,9 @@ static void gve_tx_free_fifo(struct gve_tx_fifo *fifo, size_t bytes)
 static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			     u32 to_do, bool try_to_wake);
 
+static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
+			      u32 to_do);
+
 static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_tx_ring *tx = &priv->tx[idx];
@@ -144,8 +147,12 @@ static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 
 	gve_tx_remove_from_block(priv, idx);
 	slots = tx->mask + 1;
-	gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
-	netdev_tx_reset_queue(tx->netdev_txq);
+	if (tx->q_num < priv->tx_cfg.num_queues) {
+		gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
+		netdev_tx_reset_queue(tx->netdev_txq);
+	} else {
+		gve_clean_xdp_done(priv, tx, priv->tx_desc_cnt);
+	}
 
 	dma_free_coherent(hdev, sizeof(*tx->q_resources),
 			  tx->q_resources, tx->q_resources_bus);
@@ -177,6 +184,7 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	/* Make sure everything is zeroed to start */
 	memset(tx, 0, sizeof(*tx));
 	spin_lock_init(&tx->clean_lock);
+	spin_lock_init(&tx->xdp_lock);
 	tx->q_num = idx;
 
 	tx->mask = slots - 1;
@@ -657,8 +665,106 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-#define GVE_TX_START_THRESH	PAGE_SIZE
+static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
+			   void *data, int len)
+{
+	int pad, nfrags, ndescs, iovi, offset;
+	struct gve_tx_buffer_state *info;
+	u32 reqi = tx->req;
+
+	pad = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo, len);
+	if (pad >= GVE_XDP_PADDING)
+		pad = 0;
+	info = &tx->info[reqi & tx->mask];
+	info->xdp.size = len;
+
+	nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
+				   &info->iov[0]);
+	iovi = pad > 0;
+	ndescs = nfrags - iovi;
+	offset = 0;
+
+	while (iovi < nfrags) {
+		if (!offset)
+			gve_tx_fill_pkt_desc(&tx->desc[reqi & tx->mask], 0,
+					     CHECKSUM_NONE, false, 0, ndescs,
+					     info->iov[iovi].iov_len,
+					     info->iov[iovi].iov_offset, len);
+		else
+			gve_tx_fill_seg_desc(&tx->desc[reqi & tx->mask],
+					     0, 0, false, false,
+					     info->iov[iovi].iov_len,
+					     info->iov[iovi].iov_offset);
+
+		memcpy(tx->tx_fifo.base + info->iov[iovi].iov_offset,
+		       data + offset, info->iov[iovi].iov_len);
+		gve_dma_sync_for_device(&priv->pdev->dev,
+					tx->tx_fifo.qpl->page_buses,
+					info->iov[iovi].iov_offset,
+					info->iov[iovi].iov_len);
+		offset += info->iov[iovi].iov_len;
+		iovi++;
+		reqi++;
+	}
+
+	return ndescs;
+}
+
+int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
+		     void *data, int len, u32 flags)
+{
+	int nsegs;
+
+	if (!gve_can_tx(tx, len))
+		return -EBUSY;
+
+	nsegs = gve_tx_fill_xdp(priv, tx, data, len);
+	tx->req += nsegs;
+
+	if (flags & XDP_XMIT_FLUSH)
+		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
+
+	return 0;
+}
 
+static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
+			      u32 to_do)
+{
+	struct gve_tx_buffer_state *info;
+	u32 clean_end = tx->done + to_do;
+	u64 pkts = 0, bytes = 0;
+	size_t space_freed = 0;
+	u32 idx;
+	int i;
+
+	for (; tx->done < clean_end; tx->done++) {
+		idx = tx->done & tx->mask;
+		info = &tx->info[idx];
+
+		if (unlikely(!info->xdp.size))
+			continue;
+
+		bytes += info->xdp.size;
+		pkts++;
+
+		info->xdp.size = 0;
+		/* FIFO free */
+		for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
+			space_freed += info->iov[i].iov_len + info->iov[i].iov_padding;
+			info->iov[i].iov_len = 0;
+			info->iov[i].iov_padding = 0;
+		}
+	}
+
+	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
+	u64_stats_update_begin(&tx->statss);
+	tx->bytes_done += bytes;
+	tx->pkt_done += pkts;
+	u64_stats_update_end(&tx->statss);
+	return pkts;
+}
+
+#define GVE_TX_START_THRESH	PAGE_SIZE
 static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			     u32 to_do, bool try_to_wake)
 {
@@ -729,6 +835,24 @@ u32 gve_tx_load_event_counter(struct gve_priv *priv,
 	return be32_to_cpu(counter);
 }
 
+bool gve_xdp_poll(struct gve_notify_block *block, int budget)
+{
+	struct gve_priv *priv = block->priv;
+	struct gve_tx_ring *tx = block->tx;
+	u32 nic_done;
+	u32 to_do;
+
+	/* If budget is 0, do all the work */
+	if (budget == 0)
+		budget = INT_MAX;
+
+	/* Find out how much work there is to be done */
+	nic_done = gve_tx_load_event_counter(priv, tx);
+	to_do = min_t(u32, (nic_done - tx->done), budget);
+	gve_clean_xdp_done(priv, tx, to_do);
+	return nic_done != tx->done;
+}
+
 bool gve_tx_poll(struct gve_notify_block *block, int budget)
 {
 	struct gve_priv *priv = block->priv;
-- 
2.39.1.581.gbfd45094c4-goog

