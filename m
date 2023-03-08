Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD5D6B12B9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjCHUOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCHUN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:13:57 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBECD515B
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:13:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h3-20020a25d003000000b00a1a201a745aso19016891ybg.22
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678306434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JnqspgcqWQcRyq94pP3tyG6zpB1fWfMbeB0rz3J1hXU=;
        b=J1AyvV5oq6WVWip/VUNMCD3B10hlYwXUzDCxVfG1tQDl+xkntBnJXzsfiG/qecvXVx
         kLU/KafFsi3ZwG445EsK3CgHrDy0pK0h+XgzaHmu78T01V9VzGsSVxYrDCZhZM6vsz/G
         Mk53x6/QlYXzY2JvkUoZToE7igfunYLYXUtVcGwShYtQRiErSFyLnbiKUWOXJIaUZjMW
         wyAFuRbUeGDOvRsY4bkRrAMG3tuXUqXt7MOeK6fs4H+czgjroWJ3ZdvAcn9DKmG1vc72
         Ak+kfDl7fVwjPE53d8QmlYbSidww9I8Or19bCbDBoodPwPFMozeSd5gbK1ETvkKLcbbD
         R6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JnqspgcqWQcRyq94pP3tyG6zpB1fWfMbeB0rz3J1hXU=;
        b=BSl4pRXVgRNAK5Q0wa4ELXLf+CHgSa5FnZii+hyoTw/XKC5LLjhGJJM+/j6d8ieZGQ
         HgqfAgEh51Hjj5R8+sXQZZ1NzTACyT5uunyD6ENLOaaJrGuUjqsNhXKYUqg5xHytHRMy
         dL2KYVEgLMUQD+nyD2fUs/xXZOxjPI5vYDi36NhsIKrMlfQjLHiS9xpxxemxjWvw+8Dt
         cDrYqUAQnV2zZOWUvW6weSoQht0V5/IEvFKPLzifHm8KKEOzG8/nAXjSXbMRSCPORkum
         GtkIf+HNkHMpXX+evMz/P0UESvXYPNIrx8uvDwYZnpW9BUi1uKmi33u/Z0fiDicAnU+H
         TIGw==
X-Gm-Message-State: AO0yUKUuFy6g4QtO1+CVWSiLxDM008pRPgcNPGMIjWcoK4dgZPoMyfXF
        per3aBAoP0TMai/4E4yUr2d/oh1tQewu6GTxHiP3xfn/1g9+SSb7h9BGGDPb8EyeYcDPUur6mln
        rfYfxGQGeDMAD+0JVmcSX+5skXiCV4yQ4CLGhmd5irpDrHIOlA3dILJ6VQV7paJpeBRgeAdHMXt
        /WWA==
X-Google-Smtp-Source: AK7set/jjEMp9jpbNojfCNgba/68cIsSjgA9K6rwZYWRxE5U/b+lJl2Cfa6lVjpgRzrRNn3j1NE6a0KT9yPUhQFqn2g=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:cf18:68c8:1237:ef3])
 (user=pkaligineedi job=sendgmr) by 2002:a25:9cc7:0:b0:a28:737a:b933 with SMTP
 id z7-20020a259cc7000000b00a28737ab933mr11881527ybo.9.1678306434000; Wed, 08
 Mar 2023 12:13:54 -0800 (PST)
Date:   Wed,  8 Mar 2023 12:13:24 -0800
In-Reply-To: <20230308201328.3094150-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230308201328.3094150-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230308201328.3094150-2-pkaligineedi@google.com>
Subject: [PATCH net-next v2 1/5] gve: XDP support GQI-QPL: helper function changes
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

This patch adds/modifies helper functions needed to add XDP
support.

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>

---
Changed in v2:
- No changes
---
 drivers/net/ethernet/google/gve/gve.h         |  5 +++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 26 +++++++----
 drivers/net/ethernet/google/gve/gve_main.c    | 27 +++++++-----
 drivers/net/ethernet/google/gve/gve_rx.c      |  2 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  2 +-
 drivers/net/ethernet/google/gve/gve_tx.c      | 43 +++++++++++--------
 drivers/net/ethernet/google/gve/gve_utils.c   |  6 +--
 drivers/net/ethernet/google/gve/gve_utils.h   |  3 +-
 8 files changed, 70 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 64eb0442c82f..f52f23198278 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -855,6 +855,11 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 		priv->queue_format == GVE_GQI_QPL_FORMAT;
 }
 
+static inline u32 gve_num_tx_queues(struct gve_priv *priv)
+{
+	return priv->tx_cfg.num_queues;
+}
+
 /* buffers */
 int gve_alloc_page(struct gve_priv *priv, struct device *dev,
 		   struct page **page, dma_addr_t *dma,
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index ce574d097e28..5b6e31812fae 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -81,8 +81,10 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 	char *s = (char *)data;
+	int num_tx_queues;
 	int i, j;
 
+	num_tx_queues = gve_num_tx_queues(priv);
 	switch (stringset) {
 	case ETH_SS_STATS:
 		memcpy(s, *gve_gstrings_main_stats,
@@ -97,7 +99,7 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 			}
 		}
 
-		for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		for (i = 0; i < num_tx_queues; i++) {
 			for (j = 0; j < NUM_GVE_TX_CNTS; j++) {
 				snprintf(s, ETH_GSTRING_LEN,
 					 gve_gstrings_tx_stats[j], i);
@@ -124,12 +126,14 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 static int gve_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
+	int num_tx_queues;
 
+	num_tx_queues = gve_num_tx_queues(priv);
 	switch (sset) {
 	case ETH_SS_STATS:
 		return GVE_MAIN_STATS_LEN + GVE_ADMINQ_STATS_LEN +
 		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
-		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
+		       (num_tx_queues * NUM_GVE_TX_CNTS);
 	case ETH_SS_PRIV_FLAGS:
 		return GVE_PRIV_FLAGS_STR_LEN;
 	default:
@@ -153,18 +157,20 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	struct gve_priv *priv;
 	bool skip_nic_stats;
 	unsigned int start;
+	int num_tx_queues;
 	int ring;
 	int i, j;
 
 	ASSERT_RTNL();
 
 	priv = netdev_priv(netdev);
+	num_tx_queues = gve_num_tx_queues(priv);
 	report_stats = priv->stats_report->stats;
 	rx_qid_to_stats_idx = kmalloc_array(priv->rx_cfg.num_queues,
 					    sizeof(int), GFP_KERNEL);
 	if (!rx_qid_to_stats_idx)
 		return;
-	tx_qid_to_stats_idx = kmalloc_array(priv->tx_cfg.num_queues,
+	tx_qid_to_stats_idx = kmalloc_array(num_tx_queues,
 					    sizeof(int), GFP_KERNEL);
 	if (!tx_qid_to_stats_idx) {
 		kfree(rx_qid_to_stats_idx);
@@ -195,7 +201,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		}
 	}
 	for (tx_pkts = 0, tx_bytes = 0, tx_dropped = 0, ring = 0;
-	     ring < priv->tx_cfg.num_queues; ring++) {
+	     ring < num_tx_queues; ring++) {
 		if (priv->tx) {
 			do {
 				start =
@@ -232,7 +238,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	i = GVE_MAIN_STATS_LEN;
 
 	/* For rx cross-reporting stats, start from nic rx stats in report */
-	base_stats_idx = GVE_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+	base_stats_idx = GVE_TX_STATS_REPORT_NUM * num_tx_queues +
 		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
 	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
 		base_stats_idx;
@@ -298,7 +304,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 
 	/* For tx cross-reporting stats, start from nic tx stats in report */
 	base_stats_idx = max_stats_idx;
-	max_stats_idx = NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+	max_stats_idx = NIC_TX_STATS_REPORT_NUM * num_tx_queues +
 		max_stats_idx;
 	/* Preprocess the stats report for tx, map queue id to start index */
 	skip_nic_stats = false;
@@ -316,7 +322,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	}
 	/* walk TX rings */
 	if (priv->tx) {
-		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
+		for (ring = 0; ring < num_tx_queues; ring++) {
 			struct gve_tx_ring *tx = &priv->tx[ring];
 
 			if (gve_is_gqi(priv)) {
@@ -355,7 +361,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			}
 		}
 	} else {
-		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
+		i += num_tx_queues * NUM_GVE_TX_CNTS;
 	}
 
 	kfree(rx_qid_to_stats_idx);
@@ -502,7 +508,9 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 	u64 ori_flags, new_flags;
+	int num_tx_queues;
 
+	num_tx_queues = gve_num_tx_queues(priv);
 	ori_flags = READ_ONCE(priv->ethtool_flags);
 	new_flags = ori_flags;
 
@@ -522,7 +530,7 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
 	/* delete report stats timer. */
 	if (!(flags & BIT(0)) && (ori_flags & BIT(0))) {
 		int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
-			priv->tx_cfg.num_queues;
+			num_tx_queues;
 		int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
 			priv->rx_cfg.num_queues;
 
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 07111c241e0e..3cfdeeb74f60 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -90,8 +90,10 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 	struct gve_priv *priv = netdev_priv(dev);
 	unsigned int start;
 	u64 packets, bytes;
+	int num_tx_queues;
 	int ring;
 
+	num_tx_queues = gve_num_tx_queues(priv);
 	if (priv->rx) {
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
 			do {
@@ -106,7 +108,7 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 		}
 	}
 	if (priv->tx) {
-		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
+		for (ring = 0; ring < num_tx_queues; ring++) {
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->tx[ring].statss);
@@ -180,7 +182,7 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
 	int tx_stats_num, rx_stats_num;
 
 	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
-		       priv->tx_cfg.num_queues;
+		       gve_num_tx_queues(priv);
 	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
 		       priv->rx_cfg.num_queues;
 	priv->stats_report_len = struct_size(priv->stats_report, stats,
@@ -622,20 +624,21 @@ static int gve_unregister_qpls(struct gve_priv *priv)
 
 static int gve_create_rings(struct gve_priv *priv)
 {
+	int num_tx_queues = gve_num_tx_queues(priv);
 	int err;
 	int i;
 
-	err = gve_adminq_create_tx_queues(priv, priv->tx_cfg.num_queues);
+	err = gve_adminq_create_tx_queues(priv, num_tx_queues);
 	if (err) {
 		netif_err(priv, drv, priv->dev, "failed to create %d tx queues\n",
-			  priv->tx_cfg.num_queues);
+			  num_tx_queues);
 		/* This failure will trigger a reset - no need to clean
 		 * up
 		 */
 		return err;
 	}
 	netif_dbg(priv, drv, priv->dev, "created %d tx queues\n",
-		  priv->tx_cfg.num_queues);
+		  num_tx_queues);
 
 	err = gve_adminq_create_rx_queues(priv, priv->rx_cfg.num_queues);
 	if (err) {
@@ -675,7 +678,7 @@ static void add_napi_init_sync_stats(struct gve_priv *priv,
 	int i;
 
 	/* Add tx napi & init sync stats*/
-	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+	for (i = 0; i < gve_num_tx_queues(priv); i++) {
 		int ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
 
 		u64_stats_init(&priv->tx[i].statss);
@@ -753,9 +756,10 @@ static int gve_alloc_rings(struct gve_priv *priv)
 
 static int gve_destroy_rings(struct gve_priv *priv)
 {
+	int num_tx_queues = gve_num_tx_queues(priv);
 	int err;
 
-	err = gve_adminq_destroy_tx_queues(priv, priv->tx_cfg.num_queues);
+	err = gve_adminq_destroy_tx_queues(priv, num_tx_queues);
 	if (err) {
 		netif_err(priv, drv, priv->dev,
 			  "failed to destroy tx queues\n");
@@ -784,11 +788,12 @@ static void gve_rx_free_rings(struct gve_priv *priv)
 
 static void gve_free_rings(struct gve_priv *priv)
 {
+	int num_tx_queues = gve_num_tx_queues(priv);
 	int ntfy_idx;
 	int i;
 
 	if (priv->tx) {
-		for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		for (i = 0; i < num_tx_queues; i++) {
 			ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
 			gve_remove_napi(priv, ntfy_idx);
 		}
@@ -1118,7 +1123,7 @@ static void gve_turndown(struct gve_priv *priv)
 		return;
 
 	/* Disable napi to prevent more work from coming in */
-	for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+	for (idx = 0; idx < gve_num_tx_queues(priv); idx++) {
 		int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
 		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
@@ -1146,7 +1151,7 @@ static void gve_turnup(struct gve_priv *priv)
 	netif_tx_start_all_queues(priv->dev);
 
 	/* Enable napi and unmask interrupts for all queues */
-	for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+	for (idx = 0; idx < gve_num_tx_queues(priv); idx++) {
 		int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
 		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
@@ -1306,7 +1311,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
 	be64_add_cpu(&priv->stats_report->written_count, 1);
 	/* tx stats */
 	if (priv->tx) {
-		for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+		for (idx = 0; idx < gve_num_tx_queues(priv); idx++) {
 			u32 last_completion = 0;
 			u32 tx_frames = 0;
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 1f55137722b0..db1c74b1d7d3 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -556,7 +556,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 
 	if (len <= priv->rx_copybreak && is_only_frag)  {
 		/* Just copy small packets */
-		skb = gve_rx_copy(netdev, napi, page_info, len, GVE_RX_PAD);
+		skb = gve_rx_copy(netdev, napi, page_info, len);
 		if (skb) {
 			u64_stats_update_begin(&rx->statss);
 			rx->rx_copied_pkt++;
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 630f42a3037b..e57b73eb70f6 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -568,7 +568,7 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 
 	if (eop && buf_len <= priv->rx_copybreak) {
 		rx->ctx.skb_head = gve_rx_copy(priv->dev, napi,
-					       &buf_state->page_info, buf_len, 0);
+					       &buf_state->page_info, buf_len);
 		if (unlikely(!rx->ctx.skb_head))
 			goto error;
 		rx->ctx.skb_tail = rx->ctx.skb_head;
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 4888bf05fbed..0fb052ce9e0b 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -374,18 +374,18 @@ static int gve_maybe_stop_tx(struct gve_priv *priv, struct gve_tx_ring *tx,
 }
 
 static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
-				 struct sk_buff *skb, bool is_gso,
+				 u16 csum_offset, u8 ip_summed, bool is_gso,
 				 int l4_hdr_offset, u32 desc_cnt,
-				 u16 hlen, u64 addr)
+				 u16 hlen, u64 addr, u16 pkt_len)
 {
 	/* l4_hdr_offset and csum_offset are in units of 16-bit words */
 	if (is_gso) {
 		pkt_desc->pkt.type_flags = GVE_TXD_TSO | GVE_TXF_L4CSUM;
-		pkt_desc->pkt.l4_csum_offset = skb->csum_offset >> 1;
+		pkt_desc->pkt.l4_csum_offset = csum_offset >> 1;
 		pkt_desc->pkt.l4_hdr_offset = l4_hdr_offset >> 1;
-	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+	} else if (likely(ip_summed == CHECKSUM_PARTIAL)) {
 		pkt_desc->pkt.type_flags = GVE_TXD_STD | GVE_TXF_L4CSUM;
-		pkt_desc->pkt.l4_csum_offset = skb->csum_offset >> 1;
+		pkt_desc->pkt.l4_csum_offset = csum_offset >> 1;
 		pkt_desc->pkt.l4_hdr_offset = l4_hdr_offset >> 1;
 	} else {
 		pkt_desc->pkt.type_flags = GVE_TXD_STD;
@@ -393,7 +393,7 @@ static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
 		pkt_desc->pkt.l4_hdr_offset = 0;
 	}
 	pkt_desc->pkt.desc_cnt = desc_cnt;
-	pkt_desc->pkt.len = cpu_to_be16(skb->len);
+	pkt_desc->pkt.len = cpu_to_be16(pkt_len);
 	pkt_desc->pkt.seg_len = cpu_to_be16(hlen);
 	pkt_desc->pkt.seg_addr = cpu_to_be64(addr);
 }
@@ -412,15 +412,16 @@ static void gve_tx_fill_mtd_desc(union gve_tx_desc *mtd_desc,
 }
 
 static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
-				 struct sk_buff *skb, bool is_gso,
+				 u16 l3_offset, u16 gso_size,
+				 bool is_gso_v6, bool is_gso,
 				 u16 len, u64 addr)
 {
 	seg_desc->seg.type_flags = GVE_TXD_SEG;
 	if (is_gso) {
-		if (skb_is_gso_v6(skb))
+		if (is_gso_v6)
 			seg_desc->seg.type_flags |= GVE_TXSF_IPV6;
-		seg_desc->seg.l3_offset = skb_network_offset(skb) >> 1;
-		seg_desc->seg.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
+		seg_desc->seg.l3_offset = l3_offset >> 1;
+		seg_desc->seg.mss = cpu_to_be16(gso_size);
 	}
 	seg_desc->seg.seg_len = cpu_to_be16(len);
 	seg_desc->seg.seg_addr = cpu_to_be64(addr);
@@ -473,9 +474,10 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 	payload_nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, skb->len - hlen,
 					   &info->iov[payload_iov]);
 
-	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
+	gve_tx_fill_pkt_desc(pkt_desc, skb->csum_offset, skb->ip_summed,
+			     is_gso, l4_hdr_offset,
 			     1 + mtd_desc_nr + payload_nfrags, hlen,
-			     info->iov[hdr_nfrags - 1].iov_offset);
+			     info->iov[hdr_nfrags - 1].iov_offset, skb->len);
 
 	skb_copy_bits(skb, 0,
 		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
@@ -494,7 +496,9 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 		next_idx = (tx->req + 1 + mtd_desc_nr + i - payload_iov) & tx->mask;
 		seg_desc = &tx->desc[next_idx];
 
-		gve_tx_fill_seg_desc(seg_desc, skb, is_gso,
+		gve_tx_fill_seg_desc(seg_desc, skb_network_offset(skb),
+				     skb_shinfo(skb)->gso_size,
+				     skb_is_gso_v6(skb), is_gso,
 				     info->iov[i].iov_len,
 				     info->iov[i].iov_offset);
 
@@ -552,8 +556,9 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 	if (mtd_desc_nr)
 		num_descriptors++;
 
-	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
-			     num_descriptors, hlen, addr);
+	gve_tx_fill_pkt_desc(pkt_desc, skb->csum_offset, skb->ip_summed,
+			     is_gso, l4_hdr_offset,
+			     num_descriptors, hlen, addr, skb->len);
 
 	if (mtd_desc_nr) {
 		idx = (idx + 1) & tx->mask;
@@ -569,7 +574,9 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 		addr += hlen;
 		idx = (idx + 1) & tx->mask;
 		seg_desc = &tx->desc[idx];
-		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
+		gve_tx_fill_seg_desc(seg_desc, skb_network_offset(skb),
+				     skb_shinfo(skb)->gso_size,
+				     skb_is_gso_v6(skb), is_gso, len, addr);
 	}
 
 	for (i = 0; i < shinfo->nr_frags; i++) {
@@ -587,7 +594,9 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 		dma_unmap_len_set(&tx->info[idx], len, len);
 		dma_unmap_addr_set(&tx->info[idx], dma, addr);
 
-		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
+		gve_tx_fill_seg_desc(seg_desc, skb_network_offset(skb),
+				     skb_shinfo(skb)->gso_size,
+				     skb_is_gso_v6(skb), is_gso, len, addr);
 	}
 
 	return num_descriptors;
diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index 6ba46adaaee3..26e08d753270 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -49,10 +49,10 @@ void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
 }
 
 struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
-			    struct gve_rx_slot_page_info *page_info, u16 len,
-			    u16 padding)
+			    struct gve_rx_slot_page_info *page_info, u16 len)
 {
-	void *va = page_info->page_address + padding + page_info->page_offset;
+	void *va = page_info->page_address + page_info->page_offset +
+		page_info->pad;
 	struct sk_buff *skb;
 
 	skb = napi_alloc_skb(napi, len);
diff --git a/drivers/net/ethernet/google/gve/gve_utils.h b/drivers/net/ethernet/google/gve/gve_utils.h
index 79595940b351..324fd98a6112 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.h
+++ b/drivers/net/ethernet/google/gve/gve_utils.h
@@ -18,8 +18,7 @@ void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx);
 void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx);
 
 struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
-			    struct gve_rx_slot_page_info *page_info, u16 len,
-			    u16 pad);
+			    struct gve_rx_slot_page_info *page_info, u16 len);
 
 /* Decrement pagecnt_bias. Set it back to INT_MAX if it reached zero. */
 void gve_dec_pagecnt_bias(struct gve_rx_slot_page_info *page_info);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

