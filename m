Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B63768E298
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjBGVCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBGVCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:02:07 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F65E402EC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:01:33 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5290f6169fbso64368917b3.10
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 13:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=02K0nQw6yR56XgfB/F6p+mE2TgidSZQyD2tXvmUqdsU=;
        b=c/lfFhY99noiluMal1DRIJ0gF2ez8i5QM8mcC1yzA5B8bFBd1SWsYOBbbKyQ2GDms7
         1zAfyuuYJcJNzdahlSjvC+6X06Rhp3TSIISPOaq4seezGOMCZCQ5fzvNgOe6m3fnUU3b
         UiH14I7SJUrdEhVe4PtqI8NGD7zlNvCbstazEiJ3gsYUyb3vz3ubOmtLngjoBJzIUlrN
         fQdFr2hbQKkBBFjuTbsGvLiWKjCjhO4ra/BzdLEPLtZ2IpDynUYfwMP8ldqizU0G8Tpv
         KSclklwaRlmJpFYtun+SgQWJZlLIxNSDMZHZ1foKo3mR9CXnDuz+b7NJxZ1AvVt6TWGd
         xp4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=02K0nQw6yR56XgfB/F6p+mE2TgidSZQyD2tXvmUqdsU=;
        b=yv4hJnghf599rG1lFRfz0YC7StLFcbAQOlyzDf4T3FQ7/Ftdf1NuMur6LX0lO+T/Oy
         gy/HDDlNZwg3x12lJ1EtR3n0KyUDr2WlRkPWuNXEWedbl+3jXSlXOqhzP46lm/cs+I/4
         p2DEYBkPm5hV7SmQZE4B5zW6Q8RyYLxQabdjQFTYen7m27czdxLGPyrbOfo0FqlTgjTe
         ghPnD7AWAjQJv80IAoLMy4qI5VqtpMbSECHh5nMN5QPWS/t2kNx087cZsMuNvWoNwYWO
         CZjhXVypbNsq6edvPjV4uwsaoVXBiqm6N8Hw5AJ4s/OEuRTKmkZK2cjs9TLp6EUxuKNn
         uhXQ==
X-Gm-Message-State: AO0yUKUC4OjjfzzJyKf8HsM8lSzqlAnyXxa9ikSwfSPvy9uTZVcJUyyM
        tnxD7CZD8QGTPotYeBlBTFKcdsTP3aj9TIAgQfI7KX3HB7UcuQrUMZ74tBT2xNaTs74sbQgElh1
        Dq7GScVSQqWzVWei5P3yZony1r8P8oFI/5N9ErqXhNcuOmdhy4kqddiTiWnyrV+u/IkRiHDYtSj
        oTnQ==
X-Google-Smtp-Source: AK7set+FnZrMcj591shUE88MLOz6uod0UUZDNvZh7i6SaSk43LZGMI2w2TpWpFasgjBKqzJC0HQR3qj724i2nG7nipc=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:966c:8be6:6e77:92b1])
 (user=pkaligineedi job=sendgmr) by 2002:a25:8192:0:b0:855:fafc:7419 with SMTP
 id p18-20020a258192000000b00855fafc7419mr10ybk.0.1675803691879; Tue, 07 Feb
 2023 13:01:31 -0800 (PST)
Date:   Tue,  7 Feb 2023 13:00:58 -0800
In-Reply-To: <20230207210058.2257219-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230207210058.2257219-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230207210058.2257219-5-pkaligineedi@google.com>
Subject: [PATCH net-next 4/4] gve: Add AF_XDP zero-copy support for GQI-QPL format
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

Adding AF_XDP zero-copy support.

Note: Although these changes support AF_XDP socket in zero-copy
mode, there is still a copy happening within the driver between
XSK buffer pool and QPL bounce buffers in GQI-QPL format.

This patch contains the following changes:
1) Enable and disable XSK buffer pool
2) Copy XDP packets from QPL bounce buffers to XSK buffer on rx
3) Copy XDP packets from XSK buffer to QPL bounce buffers and
   ring the doorbell as part of XDP TX napi poll
4) ndo_xsk_wakeup callback support

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |   7 +
 drivers/net/ethernet/google/gve/gve_ethtool.c |  14 +-
 drivers/net/ethernet/google/gve/gve_main.c    | 134 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      |  30 ++++
 drivers/net/ethernet/google/gve/gve_tx.c      |  58 +++++++-
 5 files changed, 233 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index f89b1278db70..793b054580e3 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -248,6 +248,8 @@ struct gve_rx_ring {
 
 	/* XDP stuff */
 	struct xdp_rxq_info xdp_rxq;
+	struct xdp_rxq_info xsk_rxq;
+	struct xsk_buff_pool *xsk_pool;
 	struct page_frag_cache page_cache;
 };
 
@@ -275,6 +277,7 @@ struct gve_tx_buffer_state {
 	};
 	struct {
 		u16 size; /* size of xmitted xdp pkt */
+		u8 is_xsk; /* xsk buff */
 	} xdp;
 	union {
 		struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
@@ -469,6 +472,10 @@ struct gve_tx_ring {
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
 	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
+	struct xsk_buff_pool *xsk_pool;
+	u32 xdp_xsk_wakeup;
+	u32 xdp_xsk_done;
+	u64 xdp_xsk_sent;
 	u64 xdp_xmit;
 	u64 xdp_xmit_errors;
 } ____cacheline_aligned;
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 57940f90c6be..89accad6c13a 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -62,8 +62,8 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
 	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_consumed_desc[%u]", "tx_bytes[%u]",
 	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
-	"tx_dma_mapping_error[%u]",
-	"tx_xdp_xmit[%u]", "tx_xdp_xmit_errors[%u]"
+	"tx_dma_mapping_error[%u]", "tx_xsk_wakeup[%u]",
+	"tx_xsk_done[%u]", "tx_xsk_sent[%u]", "tx_xdp_xmit[%u]", "tx_xdp_xmit_errors[%u]"
 };
 
 static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
@@ -380,13 +380,17 @@ gve_get_ethtool_stats(struct net_device *netdev,
 					data[i++] = value;
 				}
 			}
+			/* XDP xsk counters */
+			data[i++] = tx->xdp_xsk_wakeup;
+			data[i++] = tx->xdp_xsk_done;
 			do {
 				start = u64_stats_fetch_begin(&priv->tx[ring].statss);
-				data[i] = tx->xdp_xmit;
-				data[i + 1] = tx->xdp_xmit_errors;
+				data[i] = tx->xdp_xsk_sent;
+				data[i + 1] = tx->xdp_xmit;
+				data[i + 2] = tx->xdp_xmit_errors;
 			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
-			i += 2; /* XDP tx counters */
+			i += 3; /* XDP tx counters */
 		}
 	} else {
 		i += num_tx_queues * NUM_GVE_TX_CNTS;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 4398e5887f3b..a0edf94d20db 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -17,6 +17,7 @@
 #include <linux/utsname.h>
 #include <linux/version.h>
 #include <net/sch_generic.h>
+#include <net/xdp_sock_drv.h>
 #include "gve.h"
 #include "gve_dqo.h"
 #include "gve_adminq.h"
@@ -983,7 +984,7 @@ static void gve_turnup(struct gve_priv *priv);
 
 static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
 {
-	int err = 0, i;
+	int err = 0, i, tx_qid;
 
 	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
 		struct gve_rx_ring *rx = &priv->rx[i];
@@ -998,6 +999,24 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
 						 MEM_TYPE_PAGE_SHARED, NULL);
 		if (err)
 			goto out;
+		err = xdp_rxq_info_reg(&rx->xsk_rxq, dev, i,
+				       napi->napi_id);
+		if (err)
+			goto out;
+		err = xdp_rxq_info_reg_mem_model(&rx->xsk_rxq,
+						 MEM_TYPE_XSK_BUFF_POOL, NULL);
+		if (err)
+			goto out;
+		rx->xsk_pool = xsk_get_pool_from_qid(dev, i);
+		if (rx->xsk_pool) {
+			xsk_pool_set_rxq_info(rx->xsk_pool,
+					      &rx->xsk_rxq);
+		}
+	}
+
+	for (i = 0; i < priv->num_xdp_queues; i++) {
+		tx_qid = gve_xdp_tx_queue_id(priv, i);
+		priv->tx[tx_qid].xsk_pool = xsk_get_pool_from_qid(dev, i);
 	}
 
 out:
@@ -1006,12 +1025,19 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
 
 static void gve_unreg_xdp_info(struct gve_priv *priv)
 {
-	int i;
+	int i, tx_qid;
 
 	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
 		struct gve_rx_ring *rx = &priv->rx[i];
 
 		xdp_rxq_info_unreg(&rx->xdp_rxq);
+		xdp_rxq_info_unreg(&rx->xsk_rxq);
+		rx->xsk_pool = NULL;
+	}
+
+	for (i = 0; i < priv->num_xdp_queues; i++) {
+		tx_qid = gve_xdp_tx_queue_id(priv, i);
+		priv->tx[tx_qid].xsk_pool = NULL;
 	}
 }
 
@@ -1182,6 +1208,104 @@ static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
 	return 0;
 }
 
+static int gve_xsk_pool_enable(struct net_device *dev,
+			       struct xsk_buff_pool *pool,
+			       u16 qid)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	int tx_qid;
+	int err;
+
+	if (qid >= priv->rx_cfg.num_queues) {
+		dev_err(&priv->pdev->dev, "xsk pool invalid qid %d", qid);
+		return -EINVAL;
+	}
+	if (pool->frame_len < priv->dev->max_mtu + sizeof(struct ethhdr)) {
+		dev_err(&priv->pdev->dev, "xsk pool frame_len too small");
+		return -EINVAL;
+	}
+
+	err = xsk_pool_dma_map(pool, &priv->pdev->dev,
+			       DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
+	if (err)
+		return err;
+	xsk_pool_set_rxq_info(pool, &priv->rx[qid].xsk_rxq);
+	tx_qid = gve_xdp_tx_queue_id(priv, qid);
+	priv->rx[qid].xsk_pool = pool;
+	priv->tx[tx_qid].xsk_pool = pool;
+
+	return 0;
+}
+
+static int gve_xsk_pool_disable(struct net_device *dev,
+				u16 qid)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	struct napi_struct *napi_tx;
+	struct xsk_buff_pool *pool;
+	int sleep = 2000;
+	int tx_qid;
+
+	pool = xsk_get_pool_from_qid(dev, qid);
+	if (!pool)
+		return -EINVAL;
+	if (qid >= priv->rx_cfg.num_queues)
+		return -EINVAL;
+
+	tx_qid = gve_xdp_tx_queue_id(priv, qid);
+	priv->rx[qid].xsk_pool = NULL;
+	priv->tx[tx_qid].xsk_pool = NULL;
+
+	/* Make sure it is visible to the workers on datapath */
+	smp_mb();
+
+	if (!netif_running(dev) || !priv->xdp_prog)
+		goto done;
+
+	napi_tx = &priv->ntfy_blocks[priv->tx[tx_qid].ntfy_id].napi;
+	napi_disable(napi_tx); /* make sure current tx poll is done */
+	napi_enable(napi_tx); /* simply pair with disable */
+	if (gve_tx_clean_pending(priv, &priv->tx[tx_qid]))
+		napi_schedule(napi_tx);
+
+	/* make sure no xdp_buff floating */
+	while (pool->free_heads_cnt < pool->heads_cnt && sleep > 0) {
+		usleep_range(1000, 2000);
+		sleep--;
+	}
+	if (sleep <= 0)
+		return -EBUSY;
+
+done:
+	xsk_pool_dma_unmap(pool,
+			   DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
+	return 0;
+}
+
+static int gve_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	int tx_queue_id = gve_xdp_tx_queue_id(priv, queue_id);
+
+	if (queue_id >= priv->rx_cfg.num_queues || !priv->xdp_prog)
+		return -EINVAL;
+
+	if (flags & XDP_WAKEUP_TX) {
+		struct gve_tx_ring *tx = &priv->tx[tx_queue_id];
+		struct napi_struct *napi =
+			&priv->ntfy_blocks[tx->ntfy_id].napi;
+
+		/* Call local_bh_enable to trigger SoftIRQ processing */
+		local_bh_disable();
+		napi_schedule(napi);
+		local_bh_enable();
+
+		tx->xdp_xsk_wakeup++;
+	}
+
+	return 0;
+}
+
 static int verify_xdp_configuration(struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -1225,6 +1349,11 @@ static int gve_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return gve_set_xdp(priv, xdp->prog, xdp->extack);
+	case XDP_SETUP_XSK_POOL:
+		if (xdp->xsk.pool)
+			return gve_xsk_pool_enable(dev, xdp->xsk.pool, xdp->xsk.queue_id);
+		else
+			return gve_xsk_pool_disable(dev, xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
@@ -1426,6 +1555,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_set_features	=	gve_set_features,
 	.ndo_bpf		=	gve_xdp,
 	.ndo_xdp_xmit		=	gve_xdp_xmit,
+	.ndo_xsk_wakeup		=	gve_xsk_wakeup,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index ea833388f895..1ee95c56ce2b 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 #include <linux/filter.h>
 #include <net/xdp.h>
+#include <net/xdp_sock_drv.h>
 
 static void gve_rx_free_buffer(struct device *dev,
 			       struct gve_rx_slot_page_info *page_info,
@@ -593,6 +594,31 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 	return skb;
 }
 
+static int gve_xsk_pool_redirect(struct net_device *dev,
+				 struct gve_rx_ring *rx,
+				 void *data, int len,
+				 struct bpf_prog *xdp_prog)
+{
+	struct xdp_buff *xdp;
+	int err;
+
+	if (rx->xsk_pool->frame_len < len)
+		return -E2BIG;
+	xdp = xsk_buff_alloc(rx->xsk_pool);
+	if (!xdp) {
+		u64_stats_update_begin(&rx->statss);
+		rx->xdp_alloc_fails++;
+		u64_stats_update_end(&rx->statss);
+		return -ENOMEM;
+	}
+	xdp->data_end = xdp->data + len;
+	memcpy(xdp->data, data, len);
+	err = xdp_do_redirect(dev, xdp, xdp_prog);
+	if (err)
+		xsk_buff_free(xdp);
+	return err;
+}
+
 static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
 			    struct xdp_buff *orig, struct bpf_prog *xdp_prog)
 {
@@ -602,6 +628,10 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
 	void *frame;
 	int err;
 
+	if (rx->xsk_pool)
+		return gve_xsk_pool_redirect(dev, rx, orig->data,
+					     len, xdp_prog);
+
 	total_len = headroom + SKB_DATA_ALIGN(len) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index b5261985a1fc..caaae2fe701e 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -11,6 +11,7 @@
 #include <linux/tcp.h>
 #include <linux/vmalloc.h>
 #include <linux/skbuff.h>
+#include <net/xdp_sock_drv.h>
 
 static inline void gve_tx_put_doorbell(struct gve_priv *priv,
 				       struct gve_queue_resources *q_resources,
@@ -666,7 +667,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
-			   void *data, int len, void *frame_p)
+			   void *data, int len, void *frame_p, bool is_xsk)
 {
 	int pad, nfrags, ndescs, iovi, offset;
 	struct gve_tx_buffer_state *info;
@@ -678,6 +679,7 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
 	info = &tx->info[reqi & tx->mask];
 	info->xdp_frame = frame_p;
 	info->xdp.size = len;
+	info->xdp.is_xsk = is_xsk;
 
 	nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
 				   &info->iov[0]);
@@ -755,7 +757,7 @@ int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
 	if (!gve_can_tx(tx, len))
 		return -EBUSY;
 
-	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p);
+	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p, false);
 	tx->req += nsegs;
 
 	if (flags & XDP_XMIT_FLUSH)
@@ -771,6 +773,7 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 	u32 clean_end = tx->done + to_do;
 	u64 pkts = 0, bytes = 0;
 	size_t space_freed = 0;
+	u32 xsk_complete = 0;
 	u32 idx;
 	int i;
 
@@ -783,6 +786,7 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 
 		bytes += info->xdp.size;
 		pkts++;
+		xsk_complete += info->xdp.is_xsk;
 
 		info->xdp.size = 0;
 		if (info->xdp_frame) {
@@ -799,6 +803,8 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 	}
 
 	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
+	if (xsk_complete > 0 && tx->xsk_pool)
+		xsk_tx_completed(tx->xsk_pool, xsk_complete);
 	u64_stats_update_begin(&tx->statss);
 	tx->bytes_done += bytes;
 	tx->pkt_done += pkts;
@@ -877,11 +883,43 @@ u32 gve_tx_load_event_counter(struct gve_priv *priv,
 	return be32_to_cpu(counter);
 }
 
+static int gve_xsk_tx(struct gve_priv *priv, struct gve_tx_ring *tx,
+		      int budget)
+{
+	struct xdp_desc desc;
+	int sent = 0, nsegs;
+	void *data;
+
+	spin_lock(&tx->xdp_lock);
+	while (sent < budget) {
+		if (!gve_can_tx(tx, GVE_TX_START_THRESH))
+			goto out;
+
+		if (!xsk_tx_peek_desc(tx->xsk_pool, &desc)) {
+			tx->xdp_xsk_done = tx->xdp_xsk_wakeup;
+			goto out;
+		}
+
+		data = xsk_buff_raw_get_data(tx->xsk_pool, desc.addr);
+		nsegs = gve_tx_fill_xdp(priv, tx, data, desc.len, NULL, true);
+		tx->req += nsegs;
+		sent++;
+	}
+out:
+	if (sent > 0) {
+		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
+		xsk_tx_release(tx->xsk_pool);
+	}
+	spin_unlock(&tx->xdp_lock);
+	return sent;
+}
+
 bool gve_xdp_poll(struct gve_notify_block *block, int budget)
 {
 	struct gve_priv *priv = block->priv;
 	struct gve_tx_ring *tx = block->tx;
 	u32 nic_done;
+	bool repoll;
 	u32 to_do;
 
 	/* If budget is 0, do all the work */
@@ -892,7 +930,21 @@ bool gve_xdp_poll(struct gve_notify_block *block, int budget)
 	nic_done = gve_tx_load_event_counter(priv, tx);
 	to_do = min_t(u32, (nic_done - tx->done), budget);
 	gve_clean_xdp_done(priv, tx, to_do);
-	return nic_done != tx->done;
+	repoll = nic_done != tx->done;
+
+	if (tx->xsk_pool) {
+		int sent = gve_xsk_tx(priv, tx, budget);
+
+		u64_stats_update_begin(&tx->statss);
+		tx->xdp_xsk_sent += sent;
+		u64_stats_update_end(&tx->statss);
+		repoll |= (sent == budget);
+		if (xsk_uses_need_wakeup(tx->xsk_pool))
+			xsk_set_tx_need_wakeup(tx->xsk_pool);
+	}
+
+	/* If we still have work we want to repoll */
+	return repoll;
 }
 
 bool gve_tx_poll(struct gve_notify_block *block, int budget)
-- 
2.39.1.581.gbfd45094c4-goog

