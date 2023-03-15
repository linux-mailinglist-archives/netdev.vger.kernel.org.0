Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ECF6BC18F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjCOXgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjCOXgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:36:31 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FBC3B645
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:34:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54352648c1eso96872767b3.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678923208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8w72oZ5vcqjUfcnttVPt8uquc8iGWfiqAhXmr/DCdA=;
        b=qgoE0uZKqMUv3EAiG/WejWjzQKmVW/ckDPuZjOnbDbPQdB9f4SB6adnqDpEdnrtn/t
         oCbcwsRk+Om/4NDTmykqnbq/zD2TF+4dFDEbL/cKDRU+35kyYR8lW0vqwwFcZYyDuisd
         8qBmlhOYB2sskz1qRbJBY9K75RgMOd29lC9ZFX3B4Ljt62KWnAfh/ksNT6Pg+rlQhA/b
         AlSt0uwYZ92lErqZ1NAV2lOp+nI3o62JI+swXs/clPGigOtfRD8zgPFU29uMqDpbu+0e
         K69I3VaG6fm08rmcQiTRAPTT2+ECJa4N5SUBI7USjmFjx0u/l42+efIg6lB420SiMgKU
         9YfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8w72oZ5vcqjUfcnttVPt8uquc8iGWfiqAhXmr/DCdA=;
        b=2l3+11uAJo9CSqRVEABTbBUOp9U3tRRIz1j4uGG+LNEQrSyBXibUjqmm04CQPlKHZc
         4PZz+3wwyUXR+Na+OGb3V9YzBhELNkikTL3B5qw5y+doQqQ9vp/pkCaW2P9GNauVsRkr
         wHcjIzLrUstfHgKZ8l7RTS87hnYZDQLmLpQ2cWlRtO88Y6H4CDfl0wOTHsfokVNiQzwr
         X9ihdJMH0xCBhwjN8FFlcnBzW1ou/5gyoN0jR8cb34n7i61Z2ain4wPinc92h0NW3BHH
         mtZ20njz819b2tVOOmhffn108Kq50Ph/+1APr2od5eKtNYfw0VnWQTnCiBmzPYI6kjjt
         Rrkg==
X-Gm-Message-State: AO0yUKVPVVhAqAFnoSFARJyFmITn1A78Re4bWABGxnraBHyfj2WhOHgl
        x/u36Cp+ATsUQ9+e7syRInbUenzLOyhPCzHcvNr4jWonYW7K/X+E36Vhr4VNDOumWjXjy8dMY82
        zrLK2olg60aOEMmKw20JlTxhQ3cDZk2usIH5umM9jBhKCUtusJ41eKM9MTmMOUsrMKqsxU9qTuX
        KT0Q==
X-Google-Smtp-Source: AK7set9ff9bm1MLQqLYiO8MlksbMrOvp9mk5Ry8pfoFBoiFPuNgGqRwfE7GAcP7kfYHSyTeJAC/+FZ1wSwW6vU3ezyA=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:736f:ac28:dd71:480f])
 (user=pkaligineedi job=sendgmr) by 2002:a5b:bc7:0:b0:b3b:6452:6a0d with SMTP
 id c7-20020a5b0bc7000000b00b3b64526a0dmr7362320ybr.1.1678923207945; Wed, 15
 Mar 2023 16:33:27 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:33:11 -0700
In-Reply-To: <20230315233312.568731-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230315233312.568731-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315233312.568731-5-pkaligineedi@google.com>
Subject: [PATCH net-next v4 4/5] gve: Add XDP REDIRECT support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michal.kubiak@intel.com,
        maciej.fijalkowski@intel.com,
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

Changed in v4:
- Set the supported flags in net_device.xdp_features
---
 drivers/net/ethernet/google/gve/gve.h         | 15 +++++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 26 ++++++----
 drivers/net/ethernet/google/gve/gve_main.c    | 19 ++++++++
 drivers/net/ethernet/google/gve/gve_rx.c      | 47 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_tx.c      | 48 +++++++++++++++++--
 5 files changed, 138 insertions(+), 17 deletions(-)

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
index f49398857921..2e8ea4dd71e8 100644
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
@@ -1696,6 +1712,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_tx_timeout         =       gve_tx_timeout,
 	.ndo_set_features	=	gve_set_features,
 	.ndo_bpf		=	gve_xdp,
+	.ndo_xdp_xmit		=	gve_xdp_xmit,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
@@ -1819,6 +1836,8 @@ static void gve_set_netdev_xdp_features(struct gve_priv *priv)
 {
 	if (priv->queue_format == GVE_GQI_QPL_FORMAT) {
 		priv->dev->xdp_features = NETDEV_XDP_ACT_BASIC;
+		priv->dev->xdp_features |= NETDEV_XDP_ACT_REDIRECT;
+		priv->dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
 	} else {
 		priv->dev->xdp_features = 0;
 	}
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
index 3e96ee7537ce..d928c3c79618 100644
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

