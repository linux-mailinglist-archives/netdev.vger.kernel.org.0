Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85916B12BA
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCHUO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjCHUOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:14:11 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98060D5141
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:13:57 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id i11-20020a256d0b000000b0086349255277so18825083ybc.8
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678306436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1xLPIxexlu9L2FCO2kte3/FKwBuHvxBalS/Y9vTFTVE=;
        b=axoN4aw/runc5PgFvRirTEjPiuMJPneC5U1R7Iz6sXyQcdRraITLGrnUOjDyg2kFQt
         Kgg6DIfGm8ILmWUYSMJCM/DDmxd0b+5+3ZuO4YJI9KqZFCRDOTM/F/cv0YQE4VJ8XuCk
         xASqbbkN8TQoeZy4jSbzGX6DmvIsxY5RA9BJlHmkOD0ZMa/+mL1eELtchjxfYkpu41EV
         9ItUEA4BIIKkZqe7Net+0K7VPXRAqkvkFCTPNumLQovDViAp212R9cvw4wHlXre/lKue
         cHnMqJgAPc3GLNA/xwhHytNNB867bZQmiMrZkabxtoIhCz3I7zNFmYdq3R9IjqoLoO0T
         Lv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xLPIxexlu9L2FCO2kte3/FKwBuHvxBalS/Y9vTFTVE=;
        b=zmPxloFxBa2oip3mX72oNJL0C5Rm88P9Vh18FV7Fhd10QFPlq4w+ThTG7H2JwMzdpd
         smYIhwZk+luakXWN0Wx2Nu0FzdZbuvKQQkoQfKK741mh4hYFsuj9G9HqEj752tGVjav+
         gLFmX1ZSqfus7/zsGYbt8QSnIanpZYN1TrVcnDBVV+p/erhjZc7xU+ztov+kV7DZXdNy
         3uA1sD6oRm1lws89KoPPF1qJQ370fgqukP+CjVhpbS1F1W2OnL1ewPPcdQfBTve17roN
         fBzfYQMeEkCsZrXOzE3/i03aTnR+hpg+1+k21F4YuqGa+2cMU80X1tgeoS915IV0JOz1
         DnHQ==
X-Gm-Message-State: AO0yUKVn1QKLghhoNSMLOZ+wRtGwpKDmWn0eePAMbsmfvh/QIJDik4V/
        1bkntNeIjw4KiYxvttLgmodT2Drk6iGZ/zS+fGHJWGCE20t+CULRZnD6w24HKuAVrji8nvDTKnq
        Y0tWgHluiFGeHWdCxjrgKIAkgK+1QHWrXnu5qS7Yzme89QpXdQXfVjwbgl+FoZ4OlaSEI+hiCg2
        wvXQ==
X-Google-Smtp-Source: AK7set/0JTTzG3HkDIKOD208/K2yB5qC/On9XvL6/0QyDEzmncXrpe2QGm+qZxtfP1DlgCLREYbR48B/JtJQLZif9vU=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:cf18:68c8:1237:ef3])
 (user=pkaligineedi job=sendgmr) by 2002:a05:6902:504:b0:975:2b10:675f with
 SMTP id x4-20020a056902050400b009752b10675fmr11850400ybs.3.1678306436538;
 Wed, 08 Mar 2023 12:13:56 -0800 (PST)
Date:   Wed,  8 Mar 2023 12:13:25 -0800
In-Reply-To: <20230308201328.3094150-1-pkaligineedi@google.com>
Mime-Version: 1.0
References: <20230308201328.3094150-1-pkaligineedi@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230308201328.3094150-3-pkaligineedi@google.com>
Subject: [PATCH net-next v2 2/5] gve: Changes to add new TX queues
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
2.40.0.rc0.216.gc4246ad0f0-goog

