Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB226BC197
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjCOXhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjCOXhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:37:24 -0400
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1333A9DC3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:35:43 -0700 (PDT)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-544539a729cso85910507b3.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678923211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mU/wJTY5HcxlJN4vrrQ0t+FLH2yd5UYinOb/ERKUwT0=;
        b=MHk8z7ELma32wcKKrffxWQBGlzI0YlKVLJrpXkHu1o3AyV1zL7mrDD6c8wIlb+kM86
         kau1A6Vvrg/VgL7esD/72BjzvpZlB5QzsRGheQfho8bpEW2r0ShQwCmgawdiQ9aEiWsr
         1wzcQyDt76zM5sovpOPwG1ngcVDv5wpWXGLyoyIXqXf4RP2P5D4ebk1ckfAr0gEgsxY3
         v/rA1PfhGCvpCZxT12HFmq4p6PPQG1rUg7PkpBKl+gD92HvB2OL820PEpVGja9cy8+/X
         pTmlxNN6q0PgxsJsZJMp02O0Fgpt4GAa1DIEhHqjPG4vmL1+fdrxIJT1Q85EgRFE5S1Z
         N2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mU/wJTY5HcxlJN4vrrQ0t+FLH2yd5UYinOb/ERKUwT0=;
        b=g/55daOOqTXQ0muNxt44bxML0qjjtTVbcYRreLtNbvw7DhZbNjdXNRtaSCnMw8ZLjx
         r9Tg0YsO7mf7Tdc5/WNAeTtzohhlxB6P5aQw+ebhDS43Hv+eAHqBzqJs9JRwSw5NEuZg
         XoedDb2Cd+ey3vfCEnb5wpqrx7CArz5YztJuxCIhlGhquTLiYBAoityrzgrk9t9EPebi
         sVh9lCQI/YjrDy5lM9rH0wZ8icD6h8NJD+3b7bJam4qSYvKjv6iQOIn6tjXeXp+6OKC2
         QpQeW6WrLGx7hvnBdr5n7tPdpilIHbYxac9V9LXRUi5JnEj3CzjlNd4SRtaNj6GSuXyw
         pnNg==
X-Gm-Message-State: AO0yUKUyJuCUgNUlzFB48YXZqBwhsqrDqVsun8XTPDr6r+sTEmu3OsJT
        IuF+Gu4pu5k3QHOSQkukIFs4BcPeJISbEpN/nc6d7Mg1u2rLIvEnH3Wn1lxdZ+HO8kVPfaSSMl4
        4CelOufiKlFFFFyykmXrij3viB3zD17CoufLa7nlUkZvm/aX2vKhCwYTX02zvwonkiJWYdDqx85
        F5gA==
X-Google-Smtp-Source: AK7set+8dy75sioNJJL05CDVV+4Zf6xvtK3L/gl52o18TNgj3T6W9mW87U2LxGJJUH6vQ7E5RGXIu9fyRuvOgTJ+JPc=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:736f:ac28:dd71:480f])
 (user=pkaligineedi job=sendgmr) by 2002:a5b:c4a:0:b0:b31:34ab:5ca0 with SMTP
 id d10-20020a5b0c4a000000b00b3134ab5ca0mr10105567ybr.11.1678923211503; Wed,
 15 Mar 2023 16:33:31 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:33:12 -0700
In-Reply-To: <20230315233312.568731-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230315233312.568731-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315233312.568731-6-pkaligineedi@google.com>
Subject: [PATCH net-next v4 5/5] gve: Add AF_XDP zero-copy support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michal.kubiak@intel.com,
        maciej.fijalkowski@intel.com,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding AF_XDP zero-copy support.

Note: Although these changes support AF_XDP socket in zero-copy
mode, there is still a copy happening within the driver between
XSK buffer pool and QPL bounce buffers in GQI-QPL format.
In GQI-QPL queue format, the driver needs to allocate a fixed size
memory, the size specified by vNIC device, for RX/TX and register this
memory as a bounce buffer with the vNIC device when a queue is
created. The number of pages in the bounce buffer is limited and the
pages need to be made available to the vNIC by copying the RX data out
to prevent head-of-line blocking. Therefore, we cannot pass the XSK
buffer pool to the vNIC.

The number of copies on RX path from the bounce buffer to XSK buffer is 2
for AF_XDP copy mode (bounce buffer -> allocated page frag -> XSK buffer)
and 1 for AF_XDP zero-copy mode (bounce buffer -> XSK buffer).

This patch contains the following changes:
1) Enable and disable XSK buffer pool
2) Copy XDP packets from QPL bounce buffers to XSK buffer on rx
3) Copy XDP packets from XSK buffer to QPL bounce buffers and
   ring the doorbell as part of XDP TX napi poll
4) ndo_xsk_wakeup callback support

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>

---
Changed in v2:
- Register xsk rxq only when XSK buff pool is enabled
- Removed code accessing internal xsk_buff_pool fields
- Removed sleep driven code when disabling XSK buff pool. Disable
napi and re-enable it after disabling XSK pool.
- Make sure that we clean up dma mappings on XSK pool disable
- Use napi_if_scheduled_mark_missed to avoid unnecessary napi move
to the CPU calling ndo_xsk_wakeup()
- Provide an explanation for why the XSK buff pool cannot be passed to
  the NIC.

Changed in v3:
- no changes

Changed in v4:
- Set the supported flags in net_device.xdp_features
---
 drivers/net/ethernet/google/gve/gve.h         |   7 +
 drivers/net/ethernet/google/gve/gve_ethtool.c |  14 +-
 drivers/net/ethernet/google/gve/gve_main.c    | 174 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      |  30 +++
 drivers/net/ethernet/google/gve/gve_tx.c      |  58 +++++-
 5 files changed, 274 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index a3b2aec2c575..e214b51d3c8b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -248,6 +248,8 @@ struct gve_rx_ring {
 
 	/* XDP stuff */
 	struct xdp_rxq_info xdp_rxq;
+	struct xdp_rxq_info xsk_rxq;
+	struct xsk_buff_pool *xsk_pool;
 	struct page_frag_cache page_cache; /* Page cache to allocate XDP frames */
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
index 23db0f3534a8..b18804e934d3 100644
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
@@ -381,13 +381,17 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
index 2e8ea4dd71e8..57ce74315eba 100644
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
@@ -1188,6 +1189,7 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
 	struct gve_rx_ring *rx;
 	int err = 0;
 	int i, j;
+	u32 tx_qid;
 
 	if (!priv->num_xdp_queues)
 		return 0;
@@ -1204,6 +1206,24 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
 						 MEM_TYPE_PAGE_SHARED, NULL);
 		if (err)
 			goto err;
+		rx->xsk_pool = xsk_get_pool_from_qid(dev, i);
+		if (rx->xsk_pool) {
+			err = xdp_rxq_info_reg(&rx->xsk_rxq, dev, i,
+					       napi->napi_id);
+			if (err)
+				goto err;
+			err = xdp_rxq_info_reg_mem_model(&rx->xsk_rxq,
+							 MEM_TYPE_XSK_BUFF_POOL, NULL);
+			if (err)
+				goto err;
+			xsk_pool_set_rxq_info(rx->xsk_pool,
+					      &rx->xsk_rxq);
+		}
+	}
+
+	for (i = 0; i < priv->num_xdp_queues; i++) {
+		tx_qid = gve_xdp_tx_queue_id(priv, i);
+		priv->tx[tx_qid].xsk_pool = xsk_get_pool_from_qid(dev, i);
 	}
 	return 0;
 
@@ -1212,13 +1232,15 @@ static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
 		rx = &priv->rx[j];
 		if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
 			xdp_rxq_info_unreg(&rx->xdp_rxq);
+		if (xdp_rxq_info_is_reg(&rx->xsk_rxq))
+			xdp_rxq_info_unreg(&rx->xsk_rxq);
 	}
 	return err;
 }
 
 static void gve_unreg_xdp_info(struct gve_priv *priv)
 {
-	int i;
+	int i, tx_qid;
 
 	if (!priv->num_xdp_queues)
 		return;
@@ -1227,6 +1249,15 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
 		struct gve_rx_ring *rx = &priv->rx[i];
 
 		xdp_rxq_info_unreg(&rx->xdp_rxq);
+		if (rx->xsk_pool) {
+			xdp_rxq_info_unreg(&rx->xsk_rxq);
+			rx->xsk_pool = NULL;
+		}
+	}
+
+	for (i = 0; i < priv->num_xdp_queues; i++) {
+		tx_qid = gve_xdp_tx_queue_id(priv, i);
+		priv->tx[tx_qid].xsk_pool = NULL;
 	}
 }
 
@@ -1469,6 +1500,140 @@ static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
 	return err;
 }
 
+static int gve_xsk_pool_enable(struct net_device *dev,
+			       struct xsk_buff_pool *pool,
+			       u16 qid)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	struct napi_struct *napi;
+	struct gve_rx_ring *rx;
+	int tx_qid;
+	int err;
+
+	if (qid >= priv->rx_cfg.num_queues) {
+		dev_err(&priv->pdev->dev, "xsk pool invalid qid %d", qid);
+		return -EINVAL;
+	}
+	if (xsk_pool_get_rx_frame_size(pool) <
+	     priv->dev->max_mtu + sizeof(struct ethhdr)) {
+		dev_err(&priv->pdev->dev, "xsk pool frame_len too small");
+		return -EINVAL;
+	}
+
+	err = xsk_pool_dma_map(pool, &priv->pdev->dev,
+			       DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
+	if (err)
+		return err;
+
+	/* If XDP prog is not installed, return */
+	if (!priv->xdp_prog)
+		return 0;
+
+	rx = &priv->rx[qid];
+	napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
+	err = xdp_rxq_info_reg(&rx->xsk_rxq, dev, qid, napi->napi_id);
+	if (err)
+		goto err;
+
+	err = xdp_rxq_info_reg_mem_model(&rx->xsk_rxq,
+					 MEM_TYPE_XSK_BUFF_POOL, NULL);
+	if (err)
+		goto err;
+
+	xsk_pool_set_rxq_info(pool, &rx->xsk_rxq);
+	rx->xsk_pool = pool;
+
+	tx_qid = gve_xdp_tx_queue_id(priv, qid);
+	priv->tx[tx_qid].xsk_pool = pool;
+
+	return 0;
+err:
+	if (xdp_rxq_info_is_reg(&rx->xsk_rxq))
+		xdp_rxq_info_unreg(&rx->xsk_rxq);
+
+	xsk_pool_dma_unmap(pool,
+			   DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
+	return err;
+}
+
+static int gve_xsk_pool_disable(struct net_device *dev,
+				u16 qid)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	struct napi_struct *napi_rx;
+	struct napi_struct *napi_tx;
+	struct xsk_buff_pool *pool;
+	int tx_qid;
+
+	pool = xsk_get_pool_from_qid(dev, qid);
+	if (!pool)
+		return -EINVAL;
+	if (qid >= priv->rx_cfg.num_queues)
+		return -EINVAL;
+
+	/* If XDP prog is not installed, unmap DMA and return */
+	if (!priv->xdp_prog)
+		goto done;
+
+	tx_qid = gve_xdp_tx_queue_id(priv, qid);
+	if (!netif_running(dev)) {
+		priv->rx[qid].xsk_pool = NULL;
+		xdp_rxq_info_unreg(&priv->rx[qid].xsk_rxq);
+		priv->tx[tx_qid].xsk_pool = NULL;
+		goto done;
+	}
+
+	napi_rx = &priv->ntfy_blocks[priv->rx[qid].ntfy_id].napi;
+	napi_disable(napi_rx); /* make sure current rx poll is done */
+
+	napi_tx = &priv->ntfy_blocks[priv->tx[tx_qid].ntfy_id].napi;
+	napi_disable(napi_tx); /* make sure current tx poll is done */
+
+	priv->rx[qid].xsk_pool = NULL;
+	xdp_rxq_info_unreg(&priv->rx[qid].xsk_rxq);
+	priv->tx[tx_qid].xsk_pool = NULL;
+	smp_mb(); /* Make sure it is visible to the workers on datapath */
+
+	napi_enable(napi_rx);
+	if (gve_rx_work_pending(&priv->rx[qid]))
+		napi_schedule(napi_rx);
+
+	napi_enable(napi_tx);
+	if (gve_tx_clean_pending(priv, &priv->tx[tx_qid]))
+		napi_schedule(napi_tx);
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
+		if (!napi_if_scheduled_mark_missed(napi)) {
+			/* Call local_bh_enable to trigger SoftIRQ processing */
+			local_bh_disable();
+			napi_schedule(napi);
+			local_bh_enable();
+		}
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
@@ -1512,6 +1677,11 @@ static int gve_xdp(struct net_device *dev, struct netdev_bpf *xdp)
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
@@ -1713,6 +1883,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_set_features	=	gve_set_features,
 	.ndo_bpf		=	gve_xdp,
 	.ndo_xdp_xmit		=	gve_xdp_xmit,
+	.ndo_xsk_wakeup		=	gve_xsk_wakeup,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
@@ -1838,6 +2009,7 @@ static void gve_set_netdev_xdp_features(struct gve_priv *priv)
 		priv->dev->xdp_features = NETDEV_XDP_ACT_BASIC;
 		priv->dev->xdp_features |= NETDEV_XDP_ACT_REDIRECT;
 		priv->dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
+		priv->dev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
 	} else {
 		priv->dev->xdp_features = 0;
 	}
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index ed4b5a540e6d..d1da7413dc4d 100644
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
index d928c3c79618..e50510b8e784 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -11,6 +11,7 @@
 #include <linux/tcp.h>
 #include <linux/vmalloc.h>
 #include <linux/skbuff.h>
+#include <net/xdp_sock_drv.h>
 
 static inline void gve_tx_put_doorbell(struct gve_priv *priv,
 				       struct gve_queue_resources *q_resources,
@@ -160,6 +161,7 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 	u32 clean_end = tx->done + to_do;
 	u64 pkts = 0, bytes = 0;
 	size_t space_freed = 0;
+	u32 xsk_complete = 0;
 	u32 idx;
 
 	for (; tx->done < clean_end; tx->done++) {
@@ -171,6 +173,7 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 
 		bytes += info->xdp.size;
 		pkts++;
+		xsk_complete += info->xdp.is_xsk;
 
 		info->xdp.size = 0;
 		if (info->xdp_frame) {
@@ -181,6 +184,8 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 	}
 
 	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
+	if (xsk_complete > 0 && tx->xsk_pool)
+		xsk_tx_completed(tx->xsk_pool, xsk_complete);
 	u64_stats_update_begin(&tx->statss);
 	tx->bytes_done += bytes;
 	tx->pkt_done += pkts;
@@ -720,7 +725,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
-			   void *data, int len, void *frame_p)
+			   void *data, int len, void *frame_p, bool is_xsk)
 {
 	int pad, nfrags, ndescs, iovi, offset;
 	struct gve_tx_buffer_state *info;
@@ -732,6 +737,7 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
 	info = &tx->info[reqi & tx->mask];
 	info->xdp_frame = frame_p;
 	info->xdp.size = len;
+	info->xdp.is_xsk = is_xsk;
 
 	nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
 				   &info->iov[0]);
@@ -809,7 +815,7 @@ int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
 	if (!gve_can_tx(tx, len + GVE_TX_MAX_HEADER_SIZE - 1))
 		return -EBUSY;
 
-	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p);
+	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p, false);
 	tx->req += nsegs;
 
 	return 0;
@@ -882,11 +888,43 @@ u32 gve_tx_load_event_counter(struct gve_priv *priv,
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
@@ -897,7 +935,21 @@ bool gve_xdp_poll(struct gve_notify_block *block, int budget)
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
2.40.0.rc1.284.g88254d51c5-goog

