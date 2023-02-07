Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BC68E297
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBGVC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjBGVB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:01:57 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2EF402C9
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:01:28 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id i3-20020a170902cf0300b00198bc9ba4edso8801223plg.21
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 13:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UWqNe/uaHchQSm+EZOL2F9plas3JzhtYEeSF1pDLaCI=;
        b=W4gA3aZbTS1VYwwWpbvSVDPxFsf9LlZ90zxcprKCgZlRPcor3HuaX5xYMwiWIdN9LM
         CzLU92nDYavuIVG4BbMMsyqbx5lRxK+lGvHfScc7pncVt5VG2j2gIN484sEodmatB2xG
         MDD1CQAOUtHvnXScQD++9qtfRwSvGg7XLeMB5IuBElX1vs1sBny8Ttfy/pbg6y0ptTy1
         1c09ZRnPgVmw5Xi3P/L4Xqh6SqwoVUSlPtjyyML2/n8EU6Qm91CCQEmq8XWhS++vnv2W
         ByhthpZtQjMbwyjb3q2K/hDUGjo4RPj3+ySrkrHK/CrzfPpmk59Wf2m9k1HcctcVcN6Z
         KOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWqNe/uaHchQSm+EZOL2F9plas3JzhtYEeSF1pDLaCI=;
        b=FT3EY9tcJZuM9EwEJMrl30EQUsKi0oIJwgj+vy7N+eZRtmJBPogZL3DTOHNPY2qpCo
         Dn6wTUrqVDDd/LMghNn+Xf3IQJza82IpX3HL1mU43PeDELzKQC2zcyxUOJEwjpC91/ym
         Z0Bo/66DPAwczk2t97uRCaw3yTQxGHZYT2RYWeRC5uJGNliczWI//hj5+avhe4+03og/
         uMHJouTinvdIWmNPQftKcC9BYpAFCT6ek0m5bp8BOaVkT1F/EHO/dgSOt30ZYNJVIgu2
         lgX9Tt8yOCSr0a6xdMwrk8Kg9IfwtlY3MGh+xTQOv4M8oRo3u80qnP4hTbP6SLs+IiiU
         YmBw==
X-Gm-Message-State: AO0yUKV7ojzHhjj1kSrKPwFfe7acIhDz4fE/yVZtSBbB69VrC3r1djBu
        MEu38kBGSR3msFa+SyQH/LV0thf/bb/ZEoeQMleCmuFCtxawlB11GhASTUbVw4GThemTZt93wtB
        QDCD7OLgipEZlCEzTTMUbBdZXa0w5SFObYdMw+DWEljaLnODI/mKZZ1dAR+HY9as9Z//xkFndDY
        7xUg==
X-Google-Smtp-Source: AK7set8zBwuwC3tC9DVSNHfaZ+J1pKHltEm42hYGfUeYEBbieLH/8x9lpbh2fmcE9DNlYQuybQZdtBFTS8LqnsET/fQ=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:966c:8be6:6e77:92b1])
 (user=pkaligineedi job=sendgmr) by 2002:a17:90a:3da2:b0:22b:b832:4125 with
 SMTP id i31-20020a17090a3da200b0022bb8324125mr52406pjc.146.1675803687580;
 Tue, 07 Feb 2023 13:01:27 -0800 (PST)
Date:   Tue,  7 Feb 2023 13:00:57 -0800
In-Reply-To: <20230207210058.2257219-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230207210058.2257219-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230207210058.2257219-4-pkaligineedi@google.com>
Subject: [PATCH net-next 3/4] gve: Add XDP REDIRECT support for GQI-QPL format
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

Add support for XDP REDIRECT action.

This patch contains the following changes:
1) Support for XDP REDIRECT action on rx
2) ndo_xdp_xmit callback support

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         | 13 ++++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 26 ++++++----
 drivers/net/ethernet/google/gve/gve_main.c    | 17 +++++++
 drivers/net/ethernet/google/gve/gve_rx.c      | 45 +++++++++++++++--
 drivers/net/ethernet/google/gve/gve_tx.c      | 48 +++++++++++++++++--
 5 files changed, 132 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 8352f4c0e8d1..f89b1278db70 100644
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
+	struct page_frag_cache page_cache;
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
@@ -464,6 +469,8 @@ struct gve_tx_ring {
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
 	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
+	u64 xdp_xmit;
+	u64 xdp_xmit_errors;
 } ____cacheline_aligned;
 
 /* Wraps the info for one irq including the napi struct and the queues
@@ -889,8 +896,10 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
+int gve_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+		 u32 flags);
 int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
-		     void *data, int len, u32 flags);
+		     void *data, int len, void *frame_p, u32 flags);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
 bool gve_xdp_poll(struct gve_notify_block *block, int budget);
 int gve_tx_alloc_rings(struct gve_priv *priv);
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index d2f0b53eacbb..57940f90c6be 100644
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
@@ -312,9 +313,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
@@ -370,13 +372,21 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
index 5050aa3aa1c3..4398e5887f3b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1015,6 +1015,21 @@ static void gve_unreg_xdp_info(struct gve_priv *priv)
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
@@ -1098,6 +1113,7 @@ static int gve_close(struct net_device *dev)
 	netif_carrier_off(dev);
 	if (gve_get_device_rings_ok(priv)) {
 		gve_turndown(priv);
+		gve_drain_page_cache(priv);
 		err = gve_destroy_rings(priv);
 		if (err)
 			goto err;
@@ -1409,6 +1425,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_tx_timeout         =       gve_tx_timeout,
 	.ndo_set_features	=	gve_set_features,
 	.ndo_bpf		=	gve_xdp,
+	.ndo_xdp_xmit		=	gve_xdp_xmit,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 3785bc150546..ea833388f895 100644
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
@@ -611,7 +640,7 @@ static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx,
 		tx = &priv->tx[tx_qid];
 		spin_lock(&tx->xdp_lock);
 		err = gve_xdp_xmit_one(priv, tx, xdp->data,
-				       xdp->data_end - xdp->data,
+				       xdp->data_end - xdp->data, NULL,
 				       XDP_XMIT_FLUSH);
 		spin_unlock(&tx->xdp_lock);
 
@@ -622,9 +651,13 @@ static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx,
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
@@ -844,6 +877,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			     netdev_features_t feat)
 {
+	u64 xdp_redirects = rx->xdp_actions[XDP_REDIRECT];
 	struct gve_rx_ctx *ctx = &rx->ctx;
 	struct gve_priv *priv = rx->gve;
 	struct gve_rx_cnts cnts = {0};
@@ -891,6 +925,9 @@ static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		u64_stats_update_end(&rx->statss);
 	}
 
+	if (xdp_redirects != rx->xdp_actions[XDP_REDIRECT])
+		xdp_do_flush();
+
 	/* restock ring slots */
 	if (!rx->data.raw_addressing) {
 		/* In QPL mode buffs are refilled as the desc are processed */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index a2fc4b074f52..b5261985a1fc 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -666,7 +666,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
-			   void *data, int len)
+			   void *data, int len, void *frame_p)
 {
 	int pad, nfrags, ndescs, iovi, offset;
 	struct gve_tx_buffer_state *info;
@@ -676,6 +676,7 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
 	if (pad >= GVE_XDP_PADDING)
 		pad = 0;
 	info = &tx->info[reqi & tx->mask];
+	info->xdp_frame = frame_p;
 	info->xdp.size = len;
 
 	nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
@@ -710,15 +711,51 @@ static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
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
+				       frames[i]->len, frames[i], 0);
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
-		     void *data, int len, u32 flags)
+		     void *data, int len, void *frame_p, u32 flags)
 {
 	int nsegs;
 
 	if (!gve_can_tx(tx, len))
 		return -EBUSY;
 
-	nsegs = gve_tx_fill_xdp(priv, tx, data, len);
+	nsegs = gve_tx_fill_xdp(priv, tx, data, len, frame_p);
 	tx->req += nsegs;
 
 	if (flags & XDP_XMIT_FLUSH)
@@ -748,6 +785,11 @@ static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 		pkts++;
 
 		info->xdp.size = 0;
+		if (info->xdp_frame) {
+			xdp_return_frame(info->xdp_frame);
+			info->xdp_frame = NULL;
+		}
+
 		/* FIFO free */
 		for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
 			space_freed += info->iov[i].iov_len + info->iov[i].iov_padding;
-- 
2.39.1.581.gbfd45094c4-goog

