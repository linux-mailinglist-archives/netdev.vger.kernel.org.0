Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4785B6B82AA
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjCMU1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCMU1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:27:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E459289F2D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:26:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id iw4-20020a170903044400b0019ccafc1fbeso7618696plb.3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678739214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N4PPiltscTM6ZcBh5GVQl+Uy6wve35YctoOqes62kiw=;
        b=C4qPB9wyBkr9udPYM2C2gV7zKP5GnhZbS0T2mNTiVTKgGiTjZ40k7eAIEsPT/rGN12
         JPkJjhCArKxc8tVz0ILxrQ3pbmcnuD7LtsHNSl3Bo18Bx7lBlpYbIdK65/EI1baNq0kp
         NRzLRzpy7hS9/DnmlYEL4F4djH+6JnGl0GWzX2wtr6DS2OJCBev1SAYddMBIgZCOTn6A
         +88s9Ys+Jwhwn/6rW6OVNMNJl3dDeNzZ4y5XNAY7WhWIeZIknHXim1vJmq8Yh4yak+Ey
         5s0qQJlSQOEU4hoege6NxjoAvf6Buj9PQOZCfjjHh4ogHK82/SZtn5WAXkej51Ecdg2L
         4qaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678739214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N4PPiltscTM6ZcBh5GVQl+Uy6wve35YctoOqes62kiw=;
        b=O5jMRARW8HybKdgG0Ws5RnktXRgvjcOiTewo3rAYUyRiukFQa+b+oGCstKuxueq4J5
         YpGxcoYQE2J6zuKZ7oWurDz7AYSp0ZVI1wy7fhHzQ8shX2qkowsxa00wwLoVvx20tVMe
         PiRCfvJlO2TigJz5qWSx65kJa+K946cplYpO7szdSUJEV1fbgM89l5FxkI6SFUAH1QU7
         Ne8bYlcL/ntaPaU+js2L3BGZg7wlp+ws3gT8xp+L1AzsvDgzfkgy8OuE5G/IdiJaZpU0
         Z4ySyTCVZD/8X10dRn0eButxpWrSDqcX//itNji5vPtA0pnPpzr63Kwc/L/XwY6zmDw0
         9MBg==
X-Gm-Message-State: AO0yUKXBbkr0jswy8RF71LYOHJxtcqx/+QMpJ1JrFI1lhjqfpBCo8ETy
        /2y/azhTFi7bJ+4iqYIA/WOpkxkhFnoe2+TmGjM/f/QAN/oAl66CTvnIHHxKVJO51QVGVSzmiUv
        8af5VVUGO3xPWvt656yiwFlRYoRke1J4L0Hp+ebKLxDSDfbfk5TRqOH1jtzEJOBWmz9aMymLanP
        t24g==
X-Google-Smtp-Source: AK7set8xEzWalnr2nrXVae5jJLhzshZeXodUhoORK2KzWVaGztpmNYwqcasiiwkDNmQc6ohDVn/jJse0KNSjYRkDZxM=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:3bf9:461b:3c12:db6d])
 (user=pkaligineedi job=sendgmr) by 2002:a17:90b:3889:b0:233:c921:ab7e with
 SMTP id mu9-20020a17090b388900b00233c921ab7emr4545103pjb.4.1678739214346;
 Mon, 13 Mar 2023 13:26:54 -0700 (PDT)
Date:   Mon, 13 Mar 2023 13:26:39 -0700
In-Reply-To: <20230313202640.4113427-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230313202640.4113427-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313202640.4113427-5-pkaligineedi@google.com>
Subject: [PATCH net-next v3 4/5] gve: Add XDP REDIRECT support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, maciej.fijalkowski@intel.com,
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

This patch contains the following changes:
1) Support for XDP REDIRECT action on rx
2) ndo_xdp_xmit callback support

In GQI-QPL queue format, the driver needs to allocate a fixed size
memory, the size specified by vNIC device, for RX/TX and register this
memory as a bounce buffer with the vNIC device when a queue is created.
The number of pages in the bounce buffer is limited and the pages need to
be made available to the vNIC by copying the RX data out to prevent
head-of-line blocking. The XDP_REDIRECT packets are therefore immediately
copied to a newly allocated page.

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>

---
Changed in v2:
- Moved xdp tx spin lock code from the patch adding XDP_TX support to this
  patch.
- Provide explanation on why packets are copied to a different page on
  XDP_REDIRECT.

Changed in v3:
- no changes
---
 drivers/net/ethernet/google/gve/gve.h         | 15 +++++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 26 ++++++----
 drivers/net/ethernet/google/gve/gve_main.c    | 17 +++++++
 drivers/net/ethernet/google/gve/gve_rx.c      | 47 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_tx.c      | 48 +++++++++++++++++--
 5 files changed, 136 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 8d5234d4ba67..a3b2aec2c575 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -236,6 +236,7 @@ struct gve_rx_ring {
 	u64 rx_frag_alloc_cnt; /* free-running count of rx page allocations */
 	u64 xdp_tx_errors;
 	u64 xdp_redirect_errors;
+	u64 xdp_alloc_fails;
 	u64 xdp_actions[GVE_XDP_ACTIONS];
 	u32 q_num; /* queue index */
 	u32 ntfy_id; /* notification block index */
@@ -247,6 +248,7 @@ struct gve_rx_ring {
 
 	/* XDP stuff */
 	struct xdp_rxq_info xdp_rxq;
+	struct page_frag_cache page_cache; /* Page cache to allocate XDP frames */
 };
 
 /* A TX desc ring entry */
@@ -267,7 +269,10 @@ struct gve_tx_iovec {
  * ring entry but only used for a pkt_desc not a seg_desc
  */
 struct gve_tx_buffer_state {
-	struct sk_buff *skb; /* skb for this pkt */
+	union {
+		struct sk_buff *skb; /* skb for this pkt */
+		struct xdp_frame *xdp_frame; /* xdp_frame */
+	};
 	struct {
 		u16 size; /* size of xmitted xdp pkt */
 	} xdp;
@@ -385,6 +390,8 @@ struct gve_tx_ring {
 		struct {
 			/* Spinlock for when cleanup in progress */
 			spinlock_t clean_lock;
+			/* Spinlock for XDP tx traffic */
+			spinlock_t xdp_lock;
 		};
 
 		/* DQO fields. */
@@ -462,6 +469,8 @@ struct gve_tx_ring {
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
 	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
+	u64 xdp_xmit;
+	u64 xdp_xmit_errors;
 } ____cacheline_aligned;
 
 /* Wraps the info for one irq including the napi struct and the queues
@@ -919,8 +928,10 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
+int gve_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+		 u32 flags);
 int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
-		     void *data, int len);
+		     void *data, int len, void *frame_p);
 void gve_xdp_tx_flush(struct gve_priv *priv, u32 xdp_qid);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
 bool gve_xdp_poll(struct gve_notify_block *block, int budget);
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 067b393ccf9d..23db0f3534a8 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -56,13 +56,14 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 	"rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
 	"rx_xdp_aborted[%u]", "rx_xdp_drop[%u]", "rx_xdp_pass[%u]",
 	"rx_xdp_tx[%u]", "rx_xdp_redirect[%u]",
-	"rx_xdp_tx_errors[%u]", "rx_xdp_redirect_errors[%u]",
+	"rx_xdp_tx_errors[%u]", "rx_xdp_redirect_errors[%u]", "rx_xdp_alloc_fails[%u]",
 };
 
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
 	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_consumed_desc[%u]", "tx_bytes[%u]",
 	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
 	"tx_dma_mapping_error[%u]",
+	"tx_xdp_xmit[%u]", "tx_xdp_xmit_errors[%u]"
 };
 
 static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
@@ -313,9 +314,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
 					data[i + j] = rx->xdp_actions[j];
 				data[i + j++] = rx->xdp_tx_errors;
 				data[i + j++] = rx->xdp_redirect_errors;
+				data[i + j++] = rx->xdp_alloc_fails;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
-			i += GVE_XDP_ACTIONS + 2; /* XDP rx counters */
+			i += GVE_XDP_ACTIONS + 3; /* XDP rx counters */
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
@@ -371,13 +373,21 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			if (skip_nic_stats) {
 				/* skip NIC tx stats */
 				i += NIC_TX_STATS_REPORT_NUM;
-				continue;
-			}
-			for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
-				u64 value =
-				be64_to_cpu(report_stats[tx_qid_to_stats_idx[ring] + j].value);
-				data[i++] = value;
+			} else {
+				stats_idx = tx_qid_to_stats_idx[ring];
+				for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
+					u64 value =
+						be64_to_cpu(report_stats[stats_idx + j].value);
+					data[i++] = value;
+				}
 			}
+			do {
+				start = u64_stats_fetch_begin(&priv->tx[ring].statss);
+				data[i] = tx->xdp_xmit;
+				data[i + 1] = tx->xdp_xmit_errors;
+			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+						       start));
+			i += 2; /* XDP tx counters */
 		}
 	} else {
 		i += num_tx_queues * NUM_GVE_TX_CNTS;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 7d3f15cf79ed..f0fc3b2a91ee 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1230,6 +1230,21 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
 	}
 }
 
+static void gve_drain_page_cache(struct gve_priv *priv)
+{
+	struct page_frag_cache *nc;
+	int i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		nc = &priv->rx[i].page_cache;
+		if (nc->va) {
+			__page_frag_cache_drain(virt_to_page(nc->va),
+						nc->pagecnt_bias);
+			nc->va = NULL;
+		}
+	}
+}
+
 static int gve_open(struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -1313,6 +1328,7 @@ static int gve_close(struct net_device *dev)
 	netif_carrier_off(dev);
 	if (gve_get_device_rings_ok(priv)) {
 		gve_turndown(priv);
+		gve_drain_page_cache(priv);
 		err = gve_destroy_rings(priv);
 		if (err)
 			goto err;
@@ -1677,6 +1693,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_tx_timeout         =       gve_tx_timeout,
 	.ndo_set_features	=	gve_set_features,
 	.ndo_bpf		=	gve_xdp,
+	.ndo_xdp_xmit		=	gve_xdp_xmit,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 3241f6ea29be..ed4b5a540e6d 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -593,6 +593,35 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 	return skb;
 }
 
+static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
+			    struct xdp_buff *orig, struct bpf_prog *xdp_prog)
+{
+	int total_len, len = orig->data_end - orig->data;
+	int headroom = XDP_PACKET_HEADROOM;
+	struct xdp_buff new;
+	void *frame;
+	int err;
+
+	total_len = headroom + SKB_DATA_ALIGN(len) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
+	if (!frame) {
+		u64_stats_update_begin(&rx->statss);
+		rx->xdp_alloc_fails++;
+		u64_stats_update_end(&rx->statss);
+		return -ENOMEM;
+	}
+	xdp_init_buff(&new, total_len, &rx->xdp_rxq);
+	xdp_prepare_buff(&new, frame, headroom, len, false);
+	memcpy(new.data, orig->data, len);
+
+	err = xdp_do_redirect(dev, &new, xdp_prog);
+	if (err)
+		page_frag_free(frame);
+
+	return err;
+}
+
 static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx,
 			 struct xdp_buff *xdp, struct bpf_prog *xprog,
 			 int xdp_act)
@@ -609,8 +638,10 @@ static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx,
 	case XDP_TX:
 		tx_qid = gve_xdp_tx_queue_id(priv, rx->q_num);
 		tx = &priv->tx[tx_qid];
+		spin_lock(&tx->xdp_lock);
 		err = gve_xdp_xmit_one(priv, tx, xdp->data,
-				       xdp->data_end - xdp->data);
+				       xdp->data_end - xdp->data, NULL);
+		spin_unlock(&tx->xdp_lock);
 
 		if (unlikely(err)) {
 			u64_stats_update_begin(&rx->statss);
@@ -619,9 +650,13 @@ static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx,
 		}
 		break;
 	case XDP_REDIRECT:
-		u64_stats_update_begin(&rx->statss);
-		rx->xdp_redirect_errors++;
-		u64_stats_update_end(&rx->statss);
+		err = gve_xdp_redirect(priv->dev, rx, xdp, xprog);
+
+		if (unlikely(err)) {
+			u64_stats_update_begin(&rx->statss);
+			rx->xdp_redirect_errors++;
+			u64_stats_update_end(&rx->statss);
+		}
 		break;
 	}
 	u64_stats_update_begin(&rx->statss);
@@ -841,6 +876,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			     netdev_features_t feat)
 {
+	u64 xdp_redirects = rx->xdp_actions[XDP_REDIRECT];
 	u64 xdp_txs = rx->xdp_actions[XDP_TX];
 	struct gve_rx_ctx *ctx = &rx->ctx;
 	struct gve_priv *priv = rx->gve;
@@ -892,6 +928,9 @@ static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 	if (xdp_txs != rx->xdp_actions[XDP_TX])
 		gve_xdp_tx_flush(priv, rx->q_num);
 
+	if (xdp_redirects != rx->xdp_actions[XDP_REDIRECT])
+		xdp_do_flush();
+
 	/* restock ring slots */
 	if (!rx->data.raw_addressing) {
 		/* In QPL mode buffs are refilled as the desc are processed */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index d37515e6c10c..f047ca0c29d9 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -173,6 +173,10 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 		pkts++;
 
 		info->xdp.size = 0;
+		if (info->xdp_frame) {
+			xdp_return_frame(info->xdp_frame);
+			info->xdp_frame = NULL;
+		}
 		space_freed += gve_tx_clear_buffer_state(info);
 	}
 
@@ -233,6 +237,7 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	/* Make sure everything is zeroed to start */
 	memset(tx, 0, sizeof(*tx));
 	spin_lock_init(&tx->clean_lock);
+	spin_lock_init(&tx->xdp_lock);
 	tx->q_num = idx;
 
 	tx->mask = slots - 1;
@@ -715,7 +720,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
-			   void *data, int len)
+			   void *data, int len, void *frame_p)
 {
 	int pad, nfrags, ndescs, iovi, offset;
 	struct gve_tx_buffer_state *info;
@@ -725,6 +730,7 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
 	if (pad >= GVE_TX_MAX_HEADER_SIZE)
 		pad = 0;
 	info = &tx->info[reqi & tx->mask];
+	info->xdp_frame = frame_p;
 	info->xdp.size = len;
 
 	nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
@@ -759,15 +765,51 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
 	return ndescs;
 }
 
+int gve_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+		 u32 flags)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	struct gve_tx_ring *tx;
+	int i, err = 0, qid;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	qid = gve_xdp_tx_queue_id(priv,
+				  smp_processor_id() % priv->num_xdp_queues);
+
+	tx = &priv->tx[qid];
+
+	spin_lock(&tx->xdp_lock);
+	for (i = 0; i < n; i++) {
+		err = gve_xdp_xmit_one(priv, tx, frames[i]->data,
+				       frames[i]->len, frames[i]);
+		if (err)
+			break;
+	}
+
+	if (flags & XDP_XMIT_FLUSH)
+		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
+
+	spin_unlock(&tx->xdp_lock);
+
+	u64_stats_update_begin(&tx->statss);
+	tx->xdp_xmit += n;
+	tx->xdp_xmit_errors += n - i;
+	u64_stats_update_end(&tx->statss);
+
+	return i ? i : err;
+}
+
 int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
-		     void *data, int len)
+		     void *data, int len, void *frame_p)
 {
 	int nsegs;
 
 	if (!gve_can_tx(tx, len + GVE_TX_MAX_HEADER_SIZE - 1))
 		return -EBUSY;
 
-	nsegs = gve_tx_fill_xdp(priv, tx, data, len);
+	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p);
 	tx->req += nsegs;
 
 	return 0;
-- 
2.40.0.rc1.284.g88254d51c5-goog

