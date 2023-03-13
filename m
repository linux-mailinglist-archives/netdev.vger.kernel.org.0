Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762126B82A9
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCMU1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjCMU04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:26:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8272898EC
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:26:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536cb268ab8so144278297b3.17
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678739212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zeUek9mmoGT2j8J2Ur1j/b756N3ob+Uf1ZRzRkNHQh8=;
        b=aJkOURMa7MTnfgSSiKi5MosJdaebPZ/EP37IxIREMeQ1iv2Wz1X5bFpm3ydAiwMWRM
         2JGnO1n/UxW6TswxyWytKV+Y1FP+M/wOwWv8k/7euYTP+KhFcMG1Xd4zhnlQFOJfXYKJ
         2D6+wUelAfBltFdwlJV/gdUuHmcInNInWRk8G/vLoio3jG5pqWZ58dh/ZRE8yfw3uDb0
         Jb3aeSf4d/3+MxUmZOoiYtSk0ChDuYLyBsh/ljRYr4sDcPFjG4LOtXKyINqdfY0y/Cyh
         vEVpnvsE9W1bx2TRkFkZ5YlFNdubml+qL+pqcoN6FCqVlx55LQQ0Ws/1B1EDkN6WTVYr
         WIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678739212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeUek9mmoGT2j8J2Ur1j/b756N3ob+Uf1ZRzRkNHQh8=;
        b=S3pQLtzZlNiwF0Q1DoWImmSaCFvBPIO9Xhk5YJZnGCJeBTBo/DGWEK6cLuX4omEfGB
         0UK70QeUq0Lpl2PZdZQ3sj8vt9kgt6DUQI8fcDuPkHw9a089wbhojBE813np0xHVHfRj
         jI9/G3Ex5BGXCW+XmWZYCp4owO4OgekdVDZ3I/cr8Ktf+P/NyWP1XJU1ucDn1mogBSs2
         k+JNe+pW9ZWB99dyhmTrzDVQOwX1FfQFr0SyP38QymMyJ4XrLupCVv+1eR4gu8jfltTx
         6o2GCCpgivewkGFfAu9dXrtO5gQBdx0dk8BQ8Lq+bE/yz4/MQUcXsCIuxjqmtkzuVLz9
         AozA==
X-Gm-Message-State: AO0yUKWosX4uH2ZnGp7JLmGbVGK3DpSQG0cEbeXmTdnJYnEAQUjANVfp
        pOS0VjQrP9YhTcwTcEP7Zqgeef8iC3fJQYZ9a93GPLWA/H9RYMrC/pGPWGcmSAZaz9InVanRDJm
        S/CQTtfmla+UPoh/bhPmSAQIB27jInk6IEtNrpGsUwfUGO4VtUme/FuJgtY84jFnlYJWW7P5Tju
        a49w==
X-Google-Smtp-Source: AK7set8RlDjKR8dIwnSxTR8yDFbVK1bso4TFhVYxCbGjTdqVXVp+7VzkrtN1hOxUZzujAHNOt4OSi3GM8F532PqR6uM=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:3bf9:461b:3c12:db6d])
 (user=pkaligineedi job=sendgmr) by 2002:a05:6902:524:b0:ab8:1ed9:cfc5 with
 SMTP id y4-20020a056902052400b00ab81ed9cfc5mr22148810ybs.6.1678739212116;
 Mon, 13 Mar 2023 13:26:52 -0700 (PDT)
Date:   Mon, 13 Mar 2023 13:26:38 -0700
In-Reply-To: <20230313202640.4113427-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230313202640.4113427-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313202640.4113427-4-pkaligineedi@google.com>
Subject: [PATCH net-next v3 3/5] gve: Add XDP DROP and TX support for GQI-QPL format
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

Add support for XDP PASS, DROP and TX actions.

This patch contains the following changes:
1) Support installing/uninstalling XDP program
2) Add dedicated XDP TX queues
3) Add support for XDP DROP action
4) Add support for XDP TX action

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>

---
Changed in v2:
- Removed gve_close/gve_open when adding XDP dedicated queues. Instead
we add and register additional TX queues when the XDP program is
installed. If the allocation/registration fails we return error and do
not install the XDP program.
- Removed xdp tx spin lock from this patch. It is needed for XDP_REDIRECT
support as both XDP_REDIRECT and XDP_TX traffic share the dedicated XDP
queues. Moved the code to add xdp tx spinlock to the subsequent patch
that adds XDP_REDIRECT support.
- Added netdev_err when the user tries to set rx/tx queues to the values
not supported when XDP is enabled.
- Removed rcu annotation for xdp_prog. We disable the napi prior to
adding/removing the xdp_prog and reenable it after the program has
been installed for all the queues.
- Ring the tx doorbell once for napi instead of every XDP TX packet.
- Added a new helper function for freeing the FIFO buffer
- Unregister xdp rxq for all the queues when the registration
fails during XDP program installation

Changed in v3:
- Padding bytes are used if the XDP TX packet headers do not
fit at tail of TX FIFO. Taking these padding bytes into account
while checking if enough space is available in TX FIFO.
---
 drivers/net/ethernet/google/gve/gve.h         |  44 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  37 +-
 drivers/net/ethernet/google/gve/gve_main.c    | 376 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      |  74 +++-
 drivers/net/ethernet/google/gve/gve_tx.c      | 149 ++++++-
 5 files changed, 658 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index f354a6448c25..8d5234d4ba67 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -47,6 +47,10 @@
 
 #define GVE_RX_BUFFER_SIZE_DQO 2048
 
+#define GVE_XDP_ACTIONS 5
+
+#define GVE_TX_MAX_HEADER_SIZE 182
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
@@ -526,9 +538,11 @@ struct gve_priv {
 	u16 rx_data_slot_cnt; /* rx buffer length */
 	u64 max_registered_pages;
 	u64 num_registered_pages; /* num pages registered with NIC */
+	struct bpf_prog *xdp_prog; /* XDP BPF program */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
 
+	u16 num_xdp_queues;
 	struct gve_queue_config tx_cfg;
 	struct gve_queue_config rx_cfg;
 	struct gve_qpl_config qpl_cfg; /* map used QPL ids */
@@ -785,7 +799,17 @@ static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
 	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
 		return 0;
 
-	return priv->tx_cfg.num_queues;
+	return priv->tx_cfg.num_queues + priv->num_xdp_queues;
+}
+
+/* Returns the number of XDP tx queue page lists
+ */
+static inline u32 gve_num_xdp_qpls(struct gve_priv *priv)
+{
+	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
+		return 0;
+
+	return priv->num_xdp_queues;
 }
 
 /* Returns the number of rx queue page lists
@@ -874,7 +898,17 @@ static inline bool gve_is_gqi(struct gve_priv *priv)
 
 static inline u32 gve_num_tx_queues(struct gve_priv *priv)
 {
-	return priv->tx_cfg.num_queues;
+	return priv->tx_cfg.num_queues + priv->num_xdp_queues;
+}
+
+static inline u32 gve_xdp_tx_queue_id(struct gve_priv *priv, u32 queue_id)
+{
+	return priv->tx_cfg.num_queues + queue_id;
+}
+
+static inline u32 gve_xdp_tx_start_queue_id(struct gve_priv *priv)
+{
+	return gve_xdp_tx_queue_id(priv, 0);
 }
 
 /* buffers */
@@ -885,7 +919,11 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
 /* tx handling */
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
+int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
+		     void *data, int len);
+void gve_xdp_tx_flush(struct gve_priv *priv, u32 xdp_qid);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
+bool gve_xdp_poll(struct gve_notify_block *block, int budget);
 int gve_tx_alloc_rings(struct gve_priv *priv, int start_id, int num_rings);
 void gve_tx_free_rings_gqi(struct gve_priv *priv, int start_id, int num_rings);
 u32 gve_tx_load_event_counter(struct gve_priv *priv,
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 5b6e31812fae..067b393ccf9d 100644
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
@@ -289,14 +297,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			if (skip_nic_stats) {
 				/* skip NIC rx stats */
 				i += NIC_RX_STATS_REPORT_NUM;
-				continue;
-			}
-			for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
-				u64 value =
-				be64_to_cpu(report_stats[rx_qid_to_stats_idx[ring] + j].value);
+			} else {
+				stats_idx = rx_qid_to_stats_idx[ring];
+				for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
+					u64 value =
+						be64_to_cpu(report_stats[stats_idx + j].value);
 
-				data[i++] = value;
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
@@ -418,6 +437,12 @@ static int gve_set_channels(struct net_device *netdev,
 	if (!new_rx || !new_tx)
 		return -EINVAL;
 
+	if (priv->num_xdp_queues &&
+	    (new_tx != new_rx || (2 * new_tx > priv->tx_cfg.max_queues))) {
+		dev_err(&priv->pdev->dev, "XDP load failed: The number of configured RX queues should be equal to the number of configured TX queues and the number of configured RX/TX queues should be less than or equal to half the maximum number of RX/TX queues");
+		return -EINVAL;
+	}
+
 	if (!netif_carrier_ok(netdev)) {
 		priv->tx_cfg.num_queues = new_tx;
 		priv->rx_cfg.num_queues = new_rx;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 160ca77c2751..7d3f15cf79ed 100644
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
@@ -582,6 +589,28 @@ static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
 	netif_napi_del(&block->napi);
 }
 
+static int gve_register_xdp_qpls(struct gve_priv *priv)
+{
+	int start_id;
+	int err;
+	int i;
+
+	start_id = gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv));
+	for (i = start_id; i < start_id + gve_num_xdp_qpls(priv); i++) {
+		err = gve_adminq_register_page_list(priv, &priv->qpls[i]);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "failed to register queue page list %d\n",
+				  priv->qpls[i].id);
+			/* This failure will trigger a reset - no need to clean
+			 * up
+			 */
+			return err;
+		}
+	}
+	return 0;
+}
+
 static int gve_register_qpls(struct gve_priv *priv)
 {
 	int start_id;
@@ -618,6 +647,26 @@ static int gve_register_qpls(struct gve_priv *priv)
 	return 0;
 }
 
+static int gve_unregister_xdp_qpls(struct gve_priv *priv)
+{
+	int start_id;
+	int err;
+	int i;
+
+	start_id = gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv));
+	for (i = start_id; i < start_id + gve_num_xdp_qpls(priv); i++) {
+		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
+		/* This failure will trigger a reset - no need to clean up */
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to unregister queue page list %d\n",
+				  priv->qpls[i].id);
+			return err;
+		}
+	}
+	return 0;
+}
+
 static int gve_unregister_qpls(struct gve_priv *priv)
 {
 	int start_id;
@@ -650,6 +699,27 @@ static int gve_unregister_qpls(struct gve_priv *priv)
 	return 0;
 }
 
+static int gve_create_xdp_rings(struct gve_priv *priv)
+{
+	int err;
+
+	err = gve_adminq_create_tx_queues(priv,
+					  gve_xdp_tx_start_queue_id(priv),
+					  priv->num_xdp_queues);
+	if (err) {
+		netif_err(priv, drv, priv->dev, "failed to create %d XDP tx queues\n",
+			  priv->num_xdp_queues);
+		/* This failure will trigger a reset - no need to clean
+		 * up
+		 */
+		return err;
+	}
+	netif_dbg(priv, drv, priv->dev, "created %d XDP tx queues\n",
+		  priv->num_xdp_queues);
+
+	return 0;
+}
+
 static int gve_create_rings(struct gve_priv *priv)
 {
 	int num_tx_queues = gve_num_tx_queues(priv);
@@ -699,6 +769,23 @@ static int gve_create_rings(struct gve_priv *priv)
 	return 0;
 }
 
+static void add_napi_init_xdp_sync_stats(struct gve_priv *priv,
+					 int (*napi_poll)(struct napi_struct *napi,
+							  int budget))
+{
+	int start_id = gve_xdp_tx_start_queue_id(priv);
+	int i;
+
+	/* Add xdp tx napi & init sync stats*/
+	for (i = start_id; i < start_id + priv->num_xdp_queues; i++) {
+		int ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
+
+		u64_stats_init(&priv->tx[i].statss);
+		priv->tx[i].ntfy_id = ntfy_idx;
+		gve_add_napi(priv, ntfy_idx, napi_poll);
+	}
+}
+
 static void add_napi_init_sync_stats(struct gve_priv *priv,
 				     int (*napi_poll)(struct napi_struct *napi,
 						      int budget))
@@ -732,6 +819,23 @@ static void gve_tx_free_rings(struct gve_priv *priv, int start_id, int num_rings
 	}
 }
 
+static int gve_alloc_xdp_rings(struct gve_priv *priv)
+{
+	int start_id;
+	int err = 0;
+
+	if (!priv->num_xdp_queues)
+		return 0;
+
+	start_id = gve_xdp_tx_start_queue_id(priv);
+	err = gve_tx_alloc_rings(priv, start_id, priv->num_xdp_queues);
+	if (err)
+		return err;
+	add_napi_init_xdp_sync_stats(priv, gve_napi_poll);
+
+	return 0;
+}
+
 static int gve_alloc_rings(struct gve_priv *priv)
 {
 	int err;
@@ -782,6 +886,26 @@ static int gve_alloc_rings(struct gve_priv *priv)
 	return err;
 }
 
+static int gve_destroy_xdp_rings(struct gve_priv *priv)
+{
+	int start_id;
+	int err;
+
+	start_id = gve_xdp_tx_start_queue_id(priv);
+	err = gve_adminq_destroy_tx_queues(priv,
+					   start_id,
+					   priv->num_xdp_queues);
+	if (err) {
+		netif_err(priv, drv, priv->dev,
+			  "failed to destroy XDP queues\n");
+		/* This failure will trigger a reset - no need to clean up */
+		return err;
+	}
+	netif_dbg(priv, drv, priv->dev, "destroyed XDP queues\n");
+
+	return 0;
+}
+
 static int gve_destroy_rings(struct gve_priv *priv)
 {
 	int num_tx_queues = gve_num_tx_queues(priv);
@@ -814,6 +938,21 @@ static void gve_rx_free_rings(struct gve_priv *priv)
 		gve_rx_free_rings_dqo(priv);
 }
 
+static void gve_free_xdp_rings(struct gve_priv *priv)
+{
+	int ntfy_idx, start_id;
+	int i;
+
+	start_id = gve_xdp_tx_start_queue_id(priv);
+	if (priv->tx) {
+		for (i = start_id; i <  start_id + priv->num_xdp_queues; i++) {
+			ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
+			gve_remove_napi(priv, ntfy_idx);
+		}
+		gve_tx_free_rings(priv, start_id, priv->num_xdp_queues);
+	}
+}
+
 static void gve_free_rings(struct gve_priv *priv)
 {
 	int num_tx_queues = gve_num_tx_queues(priv);
@@ -929,6 +1068,28 @@ static void gve_free_queue_page_list(struct gve_priv *priv, u32 id)
 	priv->num_registered_pages -= qpl->num_entries;
 }
 
+static int gve_alloc_xdp_qpls(struct gve_priv *priv)
+{
+	int start_id;
+	int i, j;
+	int err;
+
+	start_id = gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv));
+	for (i = start_id; i < start_id + gve_num_xdp_qpls(priv); i++) {
+		err = gve_alloc_queue_page_list(priv, i,
+						priv->tx_pages_per_qpl);
+		if (err)
+			goto free_qpls;
+	}
+
+	return 0;
+
+free_qpls:
+	for (j = start_id; j <= i; j++)
+		gve_free_queue_page_list(priv, j);
+	return err;
+}
+
 static int gve_alloc_qpls(struct gve_priv *priv)
 {
 	int max_queues = priv->tx_cfg.max_queues + priv->rx_cfg.max_queues;
@@ -978,6 +1139,16 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	return err;
 }
 
+static void gve_free_xdp_qpls(struct gve_priv *priv)
+{
+	int start_id;
+	int i;
+
+	start_id = gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv));
+	for (i = start_id; i < start_id + gve_num_xdp_qpls(priv); i++)
+		gve_free_queue_page_list(priv, i);
+}
+
 static void gve_free_qpls(struct gve_priv *priv)
 {
 	int max_queues = priv->tx_cfg.max_queues + priv->rx_cfg.max_queues;
@@ -1011,11 +1182,64 @@ static int gve_reset_recovery(struct gve_priv *priv, bool was_up);
 static void gve_turndown(struct gve_priv *priv);
 static void gve_turnup(struct gve_priv *priv);
 
+static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *dev)
+{
+	struct napi_struct *napi;
+	struct gve_rx_ring *rx;
+	int err = 0;
+	int i, j;
+
+	if (!priv->num_xdp_queues)
+		return 0;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		rx = &priv->rx[i];
+		napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
+
+		err = xdp_rxq_info_reg(&rx->xdp_rxq, dev, i,
+				       napi->napi_id);
+		if (err)
+			goto err;
+		err = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq,
+						 MEM_TYPE_PAGE_SHARED, NULL);
+		if (err)
+			goto err;
+	}
+	return 0;
+
+err:
+	for (j = i; j >= 0; j--) {
+		rx = &priv->rx[j];
+		if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
+			xdp_rxq_info_unreg(&rx->xdp_rxq);
+	}
+	return err;
+}
+
+static void gve_unreg_xdp_info(struct gve_priv *priv)
+{
+	int i;
+
+	if (!priv->num_xdp_queues)
+		return;
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
@@ -1031,6 +1255,10 @@ static int gve_open(struct net_device *dev)
 	if (err)
 		goto free_rings;
 
+	err = gve_reg_xdp_info(priv, dev);
+	if (err)
+		goto free_rings;
+
 	err = gve_register_qpls(priv);
 	if (err)
 		goto reset;
@@ -1095,6 +1323,7 @@ static int gve_close(struct net_device *dev)
 	}
 	del_timer_sync(&priv->stats_report_timer);
 
+	gve_unreg_xdp_info(priv);
 	gve_free_rings(priv);
 	gve_free_qpls(priv);
 	priv->interface_down_cnt++;
@@ -1111,6 +1340,148 @@ static int gve_close(struct net_device *dev)
 	return gve_reset_recovery(priv, false);
 }
 
+static int gve_remove_xdp_queues(struct gve_priv *priv)
+{
+	int err;
+
+	err = gve_destroy_xdp_rings(priv);
+	if (err)
+		return err;
+
+	err = gve_unregister_xdp_qpls(priv);
+	if (err)
+		return err;
+
+	gve_unreg_xdp_info(priv);
+	gve_free_xdp_rings(priv);
+	gve_free_xdp_qpls(priv);
+	priv->num_xdp_queues = 0;
+	return 0;
+}
+
+static int gve_add_xdp_queues(struct gve_priv *priv)
+{
+	int err;
+
+	priv->num_xdp_queues = priv->tx_cfg.num_queues;
+
+	err = gve_alloc_xdp_qpls(priv);
+	if (err)
+		goto err;
+
+	err = gve_alloc_xdp_rings(priv);
+	if (err)
+		goto free_xdp_qpls;
+
+	err = gve_reg_xdp_info(priv, priv->dev);
+	if (err)
+		goto free_xdp_rings;
+
+	err = gve_register_xdp_qpls(priv);
+	if (err)
+		goto free_xdp_rings;
+
+	err = gve_create_xdp_rings(priv);
+	if (err)
+		goto free_xdp_rings;
+
+	return 0;
+
+free_xdp_rings:
+	gve_free_xdp_rings(priv);
+free_xdp_qpls:
+	gve_free_xdp_qpls(priv);
+err:
+	priv->num_xdp_queues = 0;
+	return err;
+}
+
+static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
+		       struct netlink_ext_ack *extack)
+{
+	struct bpf_prog *old_prog;
+	int err = 0;
+
+	old_prog = READ_ONCE(priv->xdp_prog);
+	if (!netif_carrier_ok(priv->dev)) {
+		WRITE_ONCE(priv->xdp_prog, prog);
+		if (old_prog)
+			bpf_prog_put(old_prog);
+		return 0;
+	}
+
+	gve_turndown(priv);
+	if (!old_prog && prog) {
+		// Allocate XDP TX queues if an XDP program is
+		// being installed
+		err = gve_add_xdp_queues(priv);
+		if (err)
+			goto out;
+	} else if (old_prog && !prog) {
+		// Remove XDP TX queues if an XDP program is
+		// being uninstalled
+		err = gve_remove_xdp_queues(priv);
+		if (err)
+			goto out;
+	}
+	WRITE_ONCE(priv->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+out:
+	gve_turnup(priv);
+	queue_work(priv->gve_wq, &priv->service_task);
+	return err;
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
+		netdev_warn(dev, "XDP is not supported for mtu %d.\n",
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
@@ -1305,6 +1676,7 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_get_stats64	=	gve_get_stats,
 	.ndo_tx_timeout         =       gve_tx_timeout,
 	.ndo_set_features	=	gve_set_features,
+	.ndo_bpf		=	gve_xdp,
 };
 
 static void gve_handle_status(struct gve_priv *priv, u32 status)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 051a15e4f1af..3241f6ea29be 100644
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
@@ -591,6 +593,43 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
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
+		err = gve_xdp_xmit_one(priv, tx, xdp->data,
+				       xdp->data_end - xdp->data);
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
@@ -603,9 +642,12 @@ static void gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
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
 
@@ -645,9 +687,35 @@ static void gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 	dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
 				PAGE_SIZE, DMA_FROM_DEVICE);
 	page_info->pad = is_first_frag ? GVE_RX_PAD : 0;
+	len -= page_info->pad;
 	frag_size -= page_info->pad;
 
-	skb = gve_rx_skb(priv, rx, page_info, napi, frag_size,
+	xprog = READ_ONCE(priv->xdp_prog);
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
@@ -773,6 +841,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			     netdev_features_t feat)
 {
+	u64 xdp_txs = rx->xdp_actions[XDP_TX];
 	struct gve_rx_ctx *ctx = &rx->ctx;
 	struct gve_priv *priv = rx->gve;
 	struct gve_rx_cnts cnts = {0};
@@ -820,6 +889,9 @@ static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		u64_stats_update_end(&rx->statss);
 	}
 
+	if (xdp_txs != rx->xdp_actions[XDP_TX])
+		gve_xdp_tx_flush(priv, rx->q_num);
+
 	/* restock ring slots */
 	if (!rx->data.raw_addressing) {
 		/* In QPL mode buffs are refilled as the desc are processed */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index e24e73e74e33..d37515e6c10c 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -19,6 +19,14 @@ static inline void gve_tx_put_doorbell(struct gve_priv *priv,
 	iowrite32be(val, &priv->db_bar2[be32_to_cpu(q_resources->db_index)]);
 }
 
+void gve_xdp_tx_flush(struct gve_priv *priv, u32 xdp_qid)
+{
+	u32 tx_qid = gve_xdp_tx_queue_id(priv, xdp_qid);
+	struct gve_tx_ring *tx = &priv->tx[tx_qid];
+
+	gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
+}
+
 /* gvnic can only transmit from a Registered Segment.
  * We copy skb payloads into the registered segment before writing Tx
  * descriptors and ringing the Tx doorbell.
@@ -132,6 +140,50 @@ static void gve_tx_free_fifo(struct gve_tx_fifo *fifo, size_t bytes)
 	atomic_add(bytes, &fifo->available);
 }
 
+static size_t gve_tx_clear_buffer_state(struct gve_tx_buffer_state *info)
+{
+	size_t space_freed = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
+		space_freed += info->iov[i].iov_len + info->iov[i].iov_padding;
+		info->iov[i].iov_len = 0;
+		info->iov[i].iov_padding = 0;
+	}
+	return space_freed;
+}
+
+static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_ring *tx,
+			      u32 to_do)
+{
+	struct gve_tx_buffer_state *info;
+	u32 clean_end = tx->done + to_do;
+	u64 pkts = 0, bytes = 0;
+	size_t space_freed = 0;
+	u32 idx;
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
+		space_freed += gve_tx_clear_buffer_state(info);
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
 static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			     u32 to_do, bool try_to_wake);
 
@@ -144,8 +196,12 @@ static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 
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
@@ -213,7 +269,8 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 
 	netif_dbg(priv, drv, priv->dev, "tx[%d]->bus=%lx\n", idx,
 		  (unsigned long)tx->bus);
-	tx->netdev_txq = netdev_get_tx_queue(priv->dev, idx);
+	if (idx < priv->tx_cfg.num_queues)
+		tx->netdev_txq = netdev_get_tx_queue(priv->dev, idx);
 	gve_tx_add_to_block(priv, idx);
 
 	return 0;
@@ -657,6 +714,65 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *tx,
+			   void *data, int len)
+{
+	int pad, nfrags, ndescs, iovi, offset;
+	struct gve_tx_buffer_state *info;
+	u32 reqi = tx->req;
+
+	pad = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo, len);
+	if (pad >= GVE_TX_MAX_HEADER_SIZE)
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
+		     void *data, int len)
+{
+	int nsegs;
+
+	if (!gve_can_tx(tx, len + GVE_TX_MAX_HEADER_SIZE - 1))
+		return -EBUSY;
+
+	nsegs = gve_tx_fill_xdp(priv, tx, data, len);
+	tx->req += nsegs;
+
+	return 0;
+}
+
 #define GVE_TX_START_THRESH	PAGE_SIZE
 
 static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
@@ -666,7 +782,7 @@ static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 	u64 pkts = 0, bytes = 0;
 	size_t space_freed = 0;
 	struct sk_buff *skb;
-	int i, j;
+	int j;
 	u32 idx;
 
 	for (j = 0; j < to_do; j++) {
@@ -689,12 +805,7 @@ static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			dev_consume_skb_any(skb);
 			if (tx->raw_addressing)
 				continue;
-			/* FIFO free */
-			for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
-				space_freed += info->iov[i].iov_len + info->iov[i].iov_padding;
-				info->iov[i].iov_len = 0;
-				info->iov[i].iov_padding = 0;
-			}
+			space_freed += gve_tx_clear_buffer_state(info);
 		}
 	}
 
@@ -729,6 +840,24 @@ u32 gve_tx_load_event_counter(struct gve_priv *priv,
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
2.40.0.rc1.284.g88254d51c5-goog

