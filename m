Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47756BC18E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjCOXgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbjCOXgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:36:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6487537F22
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:34:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id ch1-20020a0569020b0100b00b3cc5b4fa9dso11626196ybb.12
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678923203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h+UC4B1hk4ubXi6e7WXoHu7FLFvA6KsiCuey4YbuRMM=;
        b=nRTAu5yn4oGMR55UtXvJuYwfJwLI0UAf94FqcSlI3gm/OhfsKOqinqMPlfJpVMVCza
         Qmmdpi0xBHVWUUexQnIvz3plalphXzduv7jSzYlDVdBc2DTYDUScreDNKm0Yqxmr+k4j
         biXmdJx4muEcN2sefpLdqBKmLkx2yinZuoe8e53npCs76MGG5mXLdBGJqcFSkHCTe3OB
         ENRSBnOCS4HxSHx2nGlQEpCzVaQ28mUEgNvFilm/ZnUEDa8ufNN6HR9EFesRxCo1Fz2i
         toHkbc9iuHhnJi+WhGpZI/geRyZMcnRixCAJ6UJfy/Va5DBls84sC9/Z07nxvlj87Uwk
         CLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+UC4B1hk4ubXi6e7WXoHu7FLFvA6KsiCuey4YbuRMM=;
        b=ctZPxirQTRXVsGJ+GtAryIC4icsBHD4XOOV7zOlK7kPFIAv2duq3D6jCpCDdYZOvw7
         dX1Vk8r9u+QBvYlpyg/LYaf5oP6tNa2SWB8DRJPJBDEbCZQiPjaJWXNfwV61c1NyjYYN
         2vaP3dY3QCqDnXw1skmgIJz3AVaqu44vRUlQoYWjTTGc2rAXNCcwWT1HP8De8V6NQRZW
         bbuBXXg3IBwadhCfQlyMIYPTVVFpQv8zV0Sqkd+i6ZHZYtUtN5sfmVzUCv+3tugz9H8q
         B+9Iqa5BBg63u865/yq+Er/OOUtQr+GEvh4se3gmKPBAbYViE/DiYL3XcEq8jlVXn4ml
         CDbg==
X-Gm-Message-State: AO0yUKW+dioolwYpKdZA/DU1++lkqWKIryTB6gHcDwyZZuin1hsOB5Ca
        tj4I5DLQJs3aGZlMOvP5R1u5ytnl/VGZ2tq6Z45nepoS4SdDXj7+pntT6PE0SWIkHeIiCBWZSAa
        yL7HFXwzEIBfHju+dqRIlfTKfSnGXecW02UWp5jU+PWJ6lwYllhGEoWm5H8jYZYUBtu6xwyIJNi
        ERWQ==
X-Google-Smtp-Source: AK7set8eMRpo3WeDZJgWVRFz8iRJItJdL9VGgaEvolSsa7GBCyv1WGaV5NNrCT5hf62uIaE6QiFM7ovNfc9yauqwMxU=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:736f:ac28:dd71:480f])
 (user=pkaligineedi job=sendgmr) by 2002:a5b:c48:0:b0:b1a:64ba:9cac with SMTP
 id d8-20020a5b0c48000000b00b1a64ba9cacmr8156969ybr.4.1678923203194; Wed, 15
 Mar 2023 16:33:23 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:33:09 -0700
In-Reply-To: <20230315233312.568731-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230315233312.568731-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315233312.568731-3-pkaligineedi@google.com>
Subject: [PATCH net-next v4 2/5] gve: Changes to add new TX queues
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

Changes to enable adding and removing TX queues without calling
gve_close() and gve_open().

Made the following changes:
1) priv->tx, priv->rx and priv->qpls arrays are allocated based on
   max tx queues and max rx queues
2) Changed gve_adminq_create_tx_queues(), gve_adminq_destroy_tx_queues(),
gve_tx_alloc_rings() and gve_tx_free_rings() functions to add/remove a
subset of TX queues rather than all the TX queues.

Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>

---
Changed in v2:
- Added this patch to address the issue raised by Jakub Kicinski about
  implications of resource allocation failing after reconfig.

Changed in v3:
- No changes

Changed in v4:
- No changes
---
 drivers/net/ethernet/google/gve/gve.h        | 45 +++++++----
 drivers/net/ethernet/google/gve/gve_adminq.c |  8 +-
 drivers/net/ethernet/google/gve/gve_adminq.h |  4 +-
 drivers/net/ethernet/google/gve/gve_main.c   | 83 ++++++++++++++------
 drivers/net/ethernet/google/gve/gve_rx.c     |  2 +-
 drivers/net/ethernet/google/gve/gve_tx.c     | 12 +--
 6 files changed, 104 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index f52f23198278..f354a6448c25 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -798,16 +798,35 @@ static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
 	return priv->rx_cfg.num_queues;
 }
 
+static inline u32 gve_tx_qpl_id(struct gve_priv *priv, int tx_qid)
+{
+	return tx_qid;
+}
+
+static inline u32 gve_rx_qpl_id(struct gve_priv *priv, int rx_qid)
+{
+	return priv->tx_cfg.max_queues + rx_qid;
+}
+
+static inline u32 gve_tx_start_qpl_id(struct gve_priv *priv)
+{
+	return gve_tx_qpl_id(priv, 0);
+}
+
+static inline u32 gve_rx_start_qpl_id(struct gve_priv *priv)
+{
+	return gve_rx_qpl_id(priv, 0);
+}
+
 /* Returns a pointer to the next available tx qpl in the list of qpls
  */
 static inline
-struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv)
+struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv, int tx_qid)
 {
-	int id = find_first_zero_bit(priv->qpl_cfg.qpl_id_map,
-				     priv->qpl_cfg.qpl_map_size);
+	int id = gve_tx_qpl_id(priv, tx_qid);
 
-	/* we are out of tx qpls */
-	if (id >= gve_num_tx_qpls(priv))
+	/* QPL already in use */
+	if (test_bit(id, priv->qpl_cfg.qpl_id_map))
 		return NULL;
 
 	set_bit(id, priv->qpl_cfg.qpl_id_map);
@@ -817,14 +836,12 @@ struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv)
 /* Returns a pointer to the next available rx qpl in the list of qpls
  */
 static inline
-struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv)
+struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv, int rx_qid)
 {
-	int id = find_next_zero_bit(priv->qpl_cfg.qpl_id_map,
-				    priv->qpl_cfg.qpl_map_size,
-				    gve_num_tx_qpls(priv));
+	int id = gve_rx_qpl_id(priv, rx_qid);
 
-	/* we are out of rx qpls */
-	if (id == gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv))
+	/* QPL already in use */
+	if (test_bit(id, priv->qpl_cfg.qpl_id_map))
 		return NULL;
 
 	set_bit(id, priv->qpl_cfg.qpl_id_map);
@@ -843,7 +860,7 @@ static inline void gve_unassign_qpl(struct gve_priv *priv, int id)
 static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
 						      int id)
 {
-	if (id < gve_num_tx_qpls(priv))
+	if (id < gve_rx_start_qpl_id(priv))
 		return DMA_TO_DEVICE;
 	else
 		return DMA_FROM_DEVICE;
@@ -869,8 +886,8 @@ void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 /* tx handling */
 netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
-int gve_tx_alloc_rings(struct gve_priv *priv);
-void gve_tx_free_rings_gqi(struct gve_priv *priv);
+int gve_tx_alloc_rings(struct gve_priv *priv, int start_id, int num_rings);
+void gve_tx_free_rings_gqi(struct gve_priv *priv, int start_id, int num_rings);
 u32 gve_tx_load_event_counter(struct gve_priv *priv,
 			      struct gve_tx_ring *tx);
 bool gve_tx_clean_pending(struct gve_priv *priv, struct gve_tx_ring *tx);
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 60061288ad9d..252974202a3f 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -516,12 +516,12 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 	return gve_adminq_issue_cmd(priv, &cmd);
 }
 
-int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues)
+int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues)
 {
 	int err;
 	int i;
 
-	for (i = 0; i < num_queues; i++) {
+	for (i = start_id; i < start_id + num_queues; i++) {
 		err = gve_adminq_create_tx_queue(priv, i);
 		if (err)
 			return err;
@@ -604,12 +604,12 @@ static int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
 	return 0;
 }
 
-int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 num_queues)
+int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues)
 {
 	int err;
 	int i;
 
-	for (i = 0; i < num_queues; i++) {
+	for (i = start_id; i < start_id + num_queues; i++) {
 		err = gve_adminq_destroy_tx_queue(priv, i);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index cf29662e6ad1..f894beb3deaf 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -410,8 +410,8 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
 					  dma_addr_t db_array_bus_addr,
 					  u32 num_ntfy_blks);
 int gve_adminq_deconfigure_device_resources(struct gve_priv *priv);
-int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues);
-int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues);
+int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 start_id, u32 num_queues);
 int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues);
 int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 queue_id);
 int gve_adminq_register_page_list(struct gve_priv *priv,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 3cfdeeb74f60..160ca77c2751 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -584,11 +584,26 @@ static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
 
 static int gve_register_qpls(struct gve_priv *priv)
 {
-	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int start_id;
 	int err;
 	int i;
 
-	for (i = 0; i < num_qpls; i++) {
+	start_id = gve_tx_start_qpl_id(priv);
+	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
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
+
+	start_id = gve_rx_start_qpl_id(priv);
+	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
 		err = gve_adminq_register_page_list(priv, &priv->qpls[i]);
 		if (err) {
 			netif_err(priv, drv, priv->dev,
@@ -605,11 +620,24 @@ static int gve_register_qpls(struct gve_priv *priv)
 
 static int gve_unregister_qpls(struct gve_priv *priv)
 {
-	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int start_id;
 	int err;
 	int i;
 
-	for (i = 0; i < num_qpls; i++) {
+	start_id = gve_tx_start_qpl_id(priv);
+	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
+		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
+		/* This failure will trigger a reset - no need to clean up */
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to unregister queue page list %d\n",
+				  priv->qpls[i].id);
+			return err;
+		}
+	}
+
+	start_id = gve_rx_start_qpl_id(priv);
+	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
 		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
 		/* This failure will trigger a reset - no need to clean up */
 		if (err) {
@@ -628,7 +656,7 @@ static int gve_create_rings(struct gve_priv *priv)
 	int err;
 	int i;
 
-	err = gve_adminq_create_tx_queues(priv, num_tx_queues);
+	err = gve_adminq_create_tx_queues(priv, 0, num_tx_queues);
 	if (err) {
 		netif_err(priv, drv, priv->dev, "failed to create %d tx queues\n",
 			  num_tx_queues);
@@ -695,10 +723,10 @@ static void add_napi_init_sync_stats(struct gve_priv *priv,
 	}
 }
 
-static void gve_tx_free_rings(struct gve_priv *priv)
+static void gve_tx_free_rings(struct gve_priv *priv, int start_id, int num_rings)
 {
 	if (gve_is_gqi(priv)) {
-		gve_tx_free_rings_gqi(priv);
+		gve_tx_free_rings_gqi(priv, start_id, num_rings);
 	} else {
 		gve_tx_free_rings_dqo(priv);
 	}
@@ -709,20 +737,20 @@ static int gve_alloc_rings(struct gve_priv *priv)
 	int err;
 
 	/* Setup tx rings */
-	priv->tx = kvcalloc(priv->tx_cfg.num_queues, sizeof(*priv->tx),
+	priv->tx = kvcalloc(priv->tx_cfg.max_queues, sizeof(*priv->tx),
 			    GFP_KERNEL);
 	if (!priv->tx)
 		return -ENOMEM;
 
 	if (gve_is_gqi(priv))
-		err = gve_tx_alloc_rings(priv);
+		err = gve_tx_alloc_rings(priv, 0, gve_num_tx_queues(priv));
 	else
 		err = gve_tx_alloc_rings_dqo(priv);
 	if (err)
 		goto free_tx;
 
 	/* Setup rx rings */
-	priv->rx = kvcalloc(priv->rx_cfg.num_queues, sizeof(*priv->rx),
+	priv->rx = kvcalloc(priv->rx_cfg.max_queues, sizeof(*priv->rx),
 			    GFP_KERNEL);
 	if (!priv->rx) {
 		err = -ENOMEM;
@@ -747,7 +775,7 @@ static int gve_alloc_rings(struct gve_priv *priv)
 	kvfree(priv->rx);
 	priv->rx = NULL;
 free_tx_queue:
-	gve_tx_free_rings(priv);
+	gve_tx_free_rings(priv, 0, gve_num_tx_queues(priv));
 free_tx:
 	kvfree(priv->tx);
 	priv->tx = NULL;
@@ -759,7 +787,7 @@ static int gve_destroy_rings(struct gve_priv *priv)
 	int num_tx_queues = gve_num_tx_queues(priv);
 	int err;
 
-	err = gve_adminq_destroy_tx_queues(priv, num_tx_queues);
+	err = gve_adminq_destroy_tx_queues(priv, 0, num_tx_queues);
 	if (err) {
 		netif_err(priv, drv, priv->dev,
 			  "failed to destroy tx queues\n");
@@ -797,7 +825,7 @@ static void gve_free_rings(struct gve_priv *priv)
 			ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
 			gve_remove_napi(priv, ntfy_idx);
 		}
-		gve_tx_free_rings(priv);
+		gve_tx_free_rings(priv, 0, num_tx_queues);
 		kvfree(priv->tx);
 		priv->tx = NULL;
 	}
@@ -894,40 +922,46 @@ static void gve_free_queue_page_list(struct gve_priv *priv, u32 id)
 			      qpl->page_buses[i], gve_qpl_dma_dir(priv, id));
 
 	kvfree(qpl->page_buses);
+	qpl->page_buses = NULL;
 free_pages:
 	kvfree(qpl->pages);
+	qpl->pages = NULL;
 	priv->num_registered_pages -= qpl->num_entries;
 }
 
 static int gve_alloc_qpls(struct gve_priv *priv)
 {
-	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int max_queues = priv->tx_cfg.max_queues + priv->rx_cfg.max_queues;
+	int start_id;
 	int i, j;
 	int err;
 
-	if (num_qpls == 0)
+	if (priv->queue_format != GVE_GQI_QPL_FORMAT)
 		return 0;
 
-	priv->qpls = kvcalloc(num_qpls, sizeof(*priv->qpls), GFP_KERNEL);
+	priv->qpls = kvcalloc(max_queues, sizeof(*priv->qpls), GFP_KERNEL);
 	if (!priv->qpls)
 		return -ENOMEM;
 
-	for (i = 0; i < gve_num_tx_qpls(priv); i++) {
+	start_id = gve_tx_start_qpl_id(priv);
+	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
 		err = gve_alloc_queue_page_list(priv, i,
 						priv->tx_pages_per_qpl);
 		if (err)
 			goto free_qpls;
 	}
-	for (; i < num_qpls; i++) {
+
+	start_id = gve_rx_start_qpl_id(priv);
+	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
 		err = gve_alloc_queue_page_list(priv, i,
 						priv->rx_data_slot_cnt);
 		if (err)
 			goto free_qpls;
 	}
 
-	priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(num_qpls) *
+	priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(max_queues) *
 				     sizeof(unsigned long) * BITS_PER_BYTE;
-	priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(num_qpls),
+	priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(max_queues),
 					    sizeof(unsigned long), GFP_KERNEL);
 	if (!priv->qpl_cfg.qpl_id_map) {
 		err = -ENOMEM;
@@ -940,23 +974,26 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	for (j = 0; j <= i; j++)
 		gve_free_queue_page_list(priv, j);
 	kvfree(priv->qpls);
+	priv->qpls = NULL;
 	return err;
 }
 
 static void gve_free_qpls(struct gve_priv *priv)
 {
-	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int max_queues = priv->tx_cfg.max_queues + priv->rx_cfg.max_queues;
 	int i;
 
-	if (num_qpls == 0)
+	if (!priv->qpls)
 		return;
 
 	kvfree(priv->qpl_cfg.qpl_id_map);
+	priv->qpl_cfg.qpl_id_map = NULL;
 
-	for (i = 0; i < num_qpls; i++)
+	for (i = 0; i < max_queues; i++)
 		gve_free_queue_page_list(priv, i);
 
 	kvfree(priv->qpls);
+	priv->qpls = NULL;
 }
 
 /* Use this to schedule a reset when the device is capable of continuing
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index db1c74b1d7d3..051a15e4f1af 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -124,7 +124,7 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 		return -ENOMEM;
 
 	if (!rx->data.raw_addressing) {
-		rx->data.qpl = gve_assign_rx_qpl(priv);
+		rx->data.qpl = gve_assign_rx_qpl(priv, rx->q_num);
 		if (!rx->data.qpl) {
 			kvfree(rx->data.page_info);
 			rx->data.page_info = NULL;
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 0fb052ce9e0b..e24e73e74e33 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -195,7 +195,7 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	tx->raw_addressing = priv->queue_format == GVE_GQI_RDA_FORMAT;
 	tx->dev = &priv->pdev->dev;
 	if (!tx->raw_addressing) {
-		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
+		tx->tx_fifo.qpl = gve_assign_tx_qpl(priv, idx);
 		if (!tx->tx_fifo.qpl)
 			goto abort_with_desc;
 		/* map Tx FIFO */
@@ -233,12 +233,12 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 	return -ENOMEM;
 }
 
-int gve_tx_alloc_rings(struct gve_priv *priv)
+int gve_tx_alloc_rings(struct gve_priv *priv, int start_id, int num_rings)
 {
 	int err = 0;
 	int i;
 
-	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+	for (i = start_id; i < start_id + num_rings; i++) {
 		err = gve_tx_alloc_ring(priv, i);
 		if (err) {
 			netif_err(priv, drv, priv->dev,
@@ -251,17 +251,17 @@ int gve_tx_alloc_rings(struct gve_priv *priv)
 	if (err) {
 		int j;
 
-		for (j = 0; j < i; j++)
+		for (j = start_id; j < i; j++)
 			gve_tx_free_ring(priv, j);
 	}
 	return err;
 }
 
-void gve_tx_free_rings_gqi(struct gve_priv *priv)
+void gve_tx_free_rings_gqi(struct gve_priv *priv, int start_id, int num_rings)
 {
 	int i;
 
-	for (i = 0; i < priv->tx_cfg.num_queues; i++)
+	for (i = start_id; i < start_id + num_rings; i++)
 		gve_tx_free_ring(priv, i);
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

