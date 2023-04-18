Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E706E6F3D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 00:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjDRWOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 18:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjDRWNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 18:13:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763854C13
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 15:13:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54fba72c1adso147782887b3.18
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 15:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681856010; x=1684448010;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+E0NNi/3ErpI/jsTHhMI1yP8O4892F+5zYcSjcyv2GY=;
        b=lI1sbZvCAkTun/2mmf2uZ/K+OVTKLC2M/tRDT+8+G3SrvtfINBBnQaocd5E/sSJx7i
         2IdZ62iy0IVmpXGb2sVvhf4nNhQecx7Fg3q7WQg1cUTjneyjUP+Qj3Z+qNkMRF+TNpg0
         0HCP5FMErRctbqudJcQzK1dgA2Nj5jNK/qr9HPkKmSNf/na/EGw5ExU/ztGufmFx6fkX
         oGiJoBW9ao5/y0HPvAsksLouWvpI61iw1ZHo0S4oR1qcSn4JK9zeygDa5ips/6d2YyYq
         g3wfODlZ6gWwWuHKY+f8GfIbTb6qTbXRg4LM97tK+ba9I0cuWFFxoKhi74dnM6i77PS0
         51SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681856010; x=1684448010;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+E0NNi/3ErpI/jsTHhMI1yP8O4892F+5zYcSjcyv2GY=;
        b=SdgzE778qL3Rv5nits2T5t/425FXTiHvPubWNN7ZAskjUK4wvyb+OwdTBq8CJ6SKoP
         ZqHKaV+S+k6JnQRtJxR+b6HcTsGgdjHwpyoMMIFOhVnemL2giU2OLKT65MEwIpXxPQml
         s9Pb2YWsGYcM+mebinXwiyGtNWpA9gkN0TFHAfuJMY4lJ2PI4QjRWbAJ2/v6kpmasucK
         YljNjQMvfy2OtTz0tkt7T0oSFzDpv9PldUIkhHiYhy3op/Lce0pIEUPDdHbwiUgxHgsS
         fhWEQEoFcE1KLcWAFA7qYJNfu1kvMfw6RqzNSXHE5WJDBBUvZ7nB5Bctue7FhtE6BI6b
         X5Gg==
X-Gm-Message-State: AAQBX9e3zwuOpAiKRvsX7zHW3rcqD+OvBqti/hyJxq+veAmg0ddMxFPL
        5/WvYEsrvhV9JOivKzOvo1vwUIhhe+i1LL0CYMr32TwaHk0AnKf2Evc2vxcr/bqb68yOFPBHJDy
        simO8LQcBnjqCLOvlhYKA8N7nBzl5tIwpRFlZtl4yUVdxSx+sDTK0ftMxexpk3BrYDL96M2Ehro
        AXOA==
X-Google-Smtp-Source: AKy350YiRHG/n2QDil0KSMKa2r+dQqzUxQD+i7RDcP+tf0Z4gOLYHmDfPr3+agkppeedPXJyIVyOXQzMEoHxyHIC/fA=
X-Received: from alexberlinerc.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1bc0])
 (user=alexberliner job=sendgmr) by 2002:a05:690c:2787:b0:54f:e2ca:3085 with
 SMTP id dz7-20020a05690c278700b0054fe2ca3085mr276217ywb.1.1681856010730; Tue,
 18 Apr 2023 15:13:30 -0700 (PDT)
Date:   Tue, 18 Apr 2023 22:13:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418221313.39112-1-alexberliner@google.com>
Subject: [PATCH net-next] gve: Add modify ring size support
From:   Alex Berliner <alexberliner@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Alex Berliner <alexberliner@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver support and ethtool bindings for changing the size of the
driver's descriptor rings.

- Add logic to change ring size via ethtool
- Handle ring sizes being provided by ring size device option
- Add structures to store max ring size
- Consolidate duplicate variables for storing ring size

Signed-off-by: Alex Berliner <alexberliner@google.com>
Reviewed-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         | 26 ++++--
 drivers/net/ethernet/google/gve/gve_adminq.c  | 85 +++++++++++++------
 drivers/net/ethernet/google/gve/gve_adminq.h  | 18 +++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 79 ++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_main.c    | 43 ++++++++--
 drivers/net/ethernet/google/gve/gve_rx.c      | 10 +--
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  3 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  2 +-
 8 files changed, 206 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index e214b51d3c8b..e2196646554f 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -40,6 +40,18 @@
 #define NIC_TX_STATS_REPORT_NUM	0
 #define NIC_RX_STATS_REPORT_NUM	4
 
+/* Experiment derived */
+#define GVE_TX_PAGE_COUNT 64
+
+/* Minimum descriptor ring size in bytes */
+#define GVE_RING_SIZE_MIN 4096
+
+/* Sanity check min ring element length for tx and rx queues */
+#define GVE_RING_LENGTH_LIMIT_MIN 64
+
+/* Sanity check max ring element length for tx and rx queues */
+#define GVE_RING_LENGTH_LIMIT_MAX 2048
+
 #define GVE_DATA_SLOT_ADDR_PAGE_MASK (~(PAGE_SIZE - 1))
 
 /* PTYPEs are always 10 bits. */
@@ -504,11 +516,6 @@ struct gve_qpl_config {
 	unsigned long *qpl_id_map; /* bitmap of used qpl ids */
 };
 
-struct gve_options_dqo_rda {
-	u16 tx_comp_ring_entries; /* number of tx_comp descriptors */
-	u16 rx_buff_ring_entries; /* number of rx_buff descriptors */
-};
-
 struct gve_irq_db {
 	__be32 index;
 } ____cacheline_aligned;
@@ -550,13 +557,14 @@ struct gve_priv {
 	u16 num_event_counters;
 	u16 tx_desc_cnt; /* num desc per ring */
 	u16 rx_desc_cnt; /* num desc per ring */
-	u16 tx_pages_per_qpl; /* tx buffer length */
-	u16 rx_data_slot_cnt; /* rx buffer length */
+	u16 max_rx_desc_cnt; /* max num desc per rx ring */
+	u16 max_tx_desc_cnt; /* max num desc per tx ring */
 	u64 max_registered_pages;
 	u64 num_registered_pages; /* num pages registered with NIC */
 	struct bpf_prog *xdp_prog; /* XDP BPF program */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
+	bool modify_ringsize_enabled;
 
 	u16 num_xdp_queues;
 	struct gve_queue_config tx_cfg;
@@ -622,7 +630,6 @@ struct gve_priv {
 	u64 link_speed;
 	bool up_before_suspend; /* True if dev was up before suspend */
 
-	struct gve_options_dqo_rda options_dqo_rda;
 	struct gve_ptype_lut *ptype_lut_dqo;
 
 	/* Must be a power of two. */
@@ -961,6 +968,9 @@ int gve_adjust_queues(struct gve_priv *priv,
 		      struct gve_queue_config new_tx_config);
 /* report stats handling */
 void gve_handle_report_stats(struct gve_priv *priv);
+int gve_adjust_ring_sizes(struct gve_priv *priv,
+			  int new_tx_desc_cnt,
+			  int new_rx_desc_cnt);
 /* exported by ethtool.c */
 extern const struct ethtool_ops gve_ethtool_ops;
 /* needed by ethtool */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 252974202a3f..339e187a070a 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -39,6 +39,7 @@ void gve_parse_device_option(struct gve_priv *priv,
 			     struct gve_device_option_gqi_rda **dev_op_gqi_rda,
 			     struct gve_device_option_gqi_qpl **dev_op_gqi_qpl,
 			     struct gve_device_option_dqo_rda **dev_op_dqo_rda,
+			     struct gve_device_option_modify_ring **dev_op_modify_ring,
 			     struct gve_device_option_jumbo_frames **dev_op_jumbo_frames)
 {
 	u32 req_feat_mask = be32_to_cpu(option->required_features_mask);
@@ -112,6 +113,23 @@ void gve_parse_device_option(struct gve_priv *priv,
 		}
 		*dev_op_dqo_rda = (void *)(option + 1);
 		break;
+	case GVE_DEV_OPT_ID_MODIFY_RING:
+		if (option_length < sizeof(**dev_op_modify_ring) ||
+		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_MODIFY_RING) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT,
+				 "Modify Ring",
+				 (int)sizeof(**dev_op_modify_ring),
+				 GVE_DEV_OPT_REQ_FEAT_MASK_MODIFY_RING,
+				 option_length, req_feat_mask);
+			break;
+		}
+
+		if (option_length > sizeof(**dev_op_modify_ring)) {
+			dev_warn(&priv->pdev->dev,
+				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "Modify Ring");
+		}
+		*dev_op_modify_ring = (void *)(option + 1);
+		break;
 	case GVE_DEV_OPT_ID_JUMBO_FRAMES:
 		if (option_length < sizeof(**dev_op_jumbo_frames) ||
 		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_JUMBO_FRAMES) {
@@ -146,6 +164,7 @@ gve_process_device_options(struct gve_priv *priv,
 			   struct gve_device_option_gqi_rda **dev_op_gqi_rda,
 			   struct gve_device_option_gqi_qpl **dev_op_gqi_qpl,
 			   struct gve_device_option_dqo_rda **dev_op_dqo_rda,
+			   struct gve_device_option_modify_ring **dev_op_modify_ring,
 			   struct gve_device_option_jumbo_frames **dev_op_jumbo_frames)
 {
 	const int num_options = be16_to_cpu(descriptor->num_device_options);
@@ -166,7 +185,8 @@ gve_process_device_options(struct gve_priv *priv,
 
 		gve_parse_device_option(priv, descriptor, dev_opt,
 					dev_op_gqi_rda, dev_op_gqi_qpl,
-					dev_op_dqo_rda, dev_op_jumbo_frames);
+					dev_op_dqo_rda, dev_op_modify_ring,
+					dev_op_jumbo_frames);
 		dev_opt = next_opt;
 	}
 
@@ -496,7 +516,9 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_resources_addr =
 			cpu_to_be64(tx->q_resources_bus),
 		.tx_ring_addr = cpu_to_be64(tx->bus),
+		.tx_comp_ring_addr = cpu_to_be64(tx->complq_bus_dqo),
 		.ntfy_id = cpu_to_be32(tx->ntfy_id),
+		.tx_ring_size = cpu_to_be16(priv->tx_desc_cnt),
 	};
 
 	if (gve_is_gqi(priv)) {
@@ -505,12 +527,10 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 
 		cmd.create_tx_queue.queue_page_list_id = cpu_to_be32(qpl_id);
 	} else {
-		cmd.create_tx_queue.tx_ring_size =
-			cpu_to_be16(priv->tx_desc_cnt);
 		cmd.create_tx_queue.tx_comp_ring_addr =
 			cpu_to_be64(tx->complq_bus_dqo);
 		cmd.create_tx_queue.tx_comp_ring_size =
-			cpu_to_be16(priv->options_dqo_rda.tx_comp_ring_entries);
+			cpu_to_be16(priv->tx_desc_cnt);
 	}
 
 	return gve_adminq_issue_cmd(priv, &cmd);
@@ -541,6 +561,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_id = cpu_to_be32(queue_index),
 		.ntfy_id = cpu_to_be32(rx->ntfy_id),
 		.queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
+		.rx_ring_size = cpu_to_be16(priv->rx_desc_cnt),
 	};
 
 	if (gve_is_gqi(priv)) {
@@ -555,8 +576,6 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		cmd.create_rx_queue.queue_page_list_id = cpu_to_be32(qpl_id);
 		cmd.create_rx_queue.packet_buffer_size = cpu_to_be16(rx->packet_buffer_size);
 	} else {
-		cmd.create_rx_queue.rx_ring_size =
-			cpu_to_be16(priv->rx_desc_cnt);
 		cmd.create_rx_queue.rx_desc_ring_addr =
 			cpu_to_be64(rx->dqo.complq.bus);
 		cmd.create_rx_queue.rx_data_ring_addr =
@@ -564,7 +583,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		cmd.create_rx_queue.packet_buffer_size =
 			cpu_to_be16(priv->data_buffer_size_dqo);
 		cmd.create_rx_queue.rx_buff_ring_size =
-			cpu_to_be16(priv->options_dqo_rda.rx_buff_ring_entries);
+			cpu_to_be16(priv->rx_desc_cnt);
 		cmd.create_rx_queue.enable_rsc =
 			!!(priv->dev->features & NETIF_F_LRO);
 	}
@@ -654,14 +673,14 @@ static int gve_set_desc_cnt(struct gve_priv *priv,
 			    struct gve_device_descriptor *descriptor)
 {
 	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
-	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < PAGE_SIZE) {
+	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < GVE_RING_SIZE_MIN) {
 		dev_err(&priv->pdev->dev, "Tx desc count %d too low\n",
 			priv->tx_desc_cnt);
 		return -EINVAL;
 	}
 	priv->rx_desc_cnt = be16_to_cpu(descriptor->rx_queue_entries);
 	if (priv->rx_desc_cnt * sizeof(priv->rx->desc.desc_ring[0])
-	    < PAGE_SIZE) {
+	    < GVE_RING_SIZE_MIN) {
 		dev_err(&priv->pdev->dev, "Rx desc count %d too low\n",
 			priv->rx_desc_cnt);
 		return -EINVAL;
@@ -671,24 +690,34 @@ static int gve_set_desc_cnt(struct gve_priv *priv,
 
 static int
 gve_set_desc_cnt_dqo(struct gve_priv *priv,
-		     const struct gve_device_descriptor *descriptor,
-		     const struct gve_device_option_dqo_rda *dev_op_dqo_rda)
+		     const struct gve_device_descriptor *descriptor)
 {
 	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
-	priv->options_dqo_rda.tx_comp_ring_entries =
-		be16_to_cpu(dev_op_dqo_rda->tx_comp_ring_entries);
 	priv->rx_desc_cnt = be16_to_cpu(descriptor->rx_queue_entries);
-	priv->options_dqo_rda.rx_buff_ring_entries =
-		be16_to_cpu(dev_op_dqo_rda->rx_buff_ring_entries);
 
 	return 0;
 }
 
-static void gve_enable_supported_features(struct gve_priv *priv,
-					  u32 supported_features_mask,
-					  const struct gve_device_option_jumbo_frames
-						  *dev_op_jumbo_frames)
-{
+static void gve_enable_supported_features(
+	struct gve_priv *priv,
+	u32 supported_features_mask,
+	const struct gve_device_option_modify_ring *dev_op_modify_ring,
+	const struct gve_device_option_jumbo_frames *dev_op_jumbo_frames)
+{
+	if (dev_op_modify_ring &&
+	    (supported_features_mask & GVE_SUP_MODIFY_RING_MASK)) {
+		priv->modify_ringsize_enabled = true;
+		dev_info(&priv->pdev->dev, "MODIFY RING device option enabled.\n");
+		priv->max_rx_desc_cnt = min_t(
+			int,
+			be16_to_cpu(dev_op_modify_ring->max_rx_ring_size),
+			GVE_RING_LENGTH_LIMIT_MAX);
+		priv->max_tx_desc_cnt = min_t(
+			int,
+			be16_to_cpu(dev_op_modify_ring->max_tx_ring_size),
+			GVE_RING_LENGTH_LIMIT_MAX);
+	}
+
 	/* Before control reaches this point, the page-size-capped max MTU from
 	 * the gve_device_descriptor field has already been stored in
 	 * priv->dev->max_mtu. We overwrite it with the true max MTU below.
@@ -703,6 +732,7 @@ static void gve_enable_supported_features(struct gve_priv *priv,
 
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
+	struct gve_device_option_modify_ring *dev_op_modify_ring = NULL;
 	struct gve_device_option_jumbo_frames *dev_op_jumbo_frames = NULL;
 	struct gve_device_option_gqi_rda *dev_op_gqi_rda = NULL;
 	struct gve_device_option_gqi_qpl *dev_op_gqi_qpl = NULL;
@@ -733,6 +763,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 
 	err = gve_process_device_options(priv, descriptor, &dev_op_gqi_rda,
 					 &dev_op_gqi_qpl, &dev_op_dqo_rda,
+					 &dev_op_modify_ring,
 					 &dev_op_jumbo_frames);
 	if (err)
 		goto free_device_descriptor;
@@ -769,11 +800,15 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	} else {
 		/* DQO supports LRO. */
 		priv->dev->hw_features |= NETIF_F_LRO;
-		err = gve_set_desc_cnt_dqo(priv, descriptor, dev_op_dqo_rda);
+		err = gve_set_desc_cnt_dqo(priv, descriptor);
 	}
 	if (err)
 		goto free_device_descriptor;
 
+	/* Default max to current in case modify ring size option is disabled */
+	priv->max_rx_desc_cnt = priv->rx_desc_cnt;
+	priv->max_tx_desc_cnt = priv->tx_desc_cnt;
+
 	priv->max_registered_pages =
 				be64_to_cpu(descriptor->max_registered_pages);
 	mtu = be16_to_cpu(descriptor->mtu);
@@ -787,17 +822,11 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	eth_hw_addr_set(priv->dev, descriptor->mac);
 	mac = descriptor->mac;
 	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
-	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
-	priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
 
-	if (gve_is_gqi(priv) && priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
-		dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			priv->rx_data_slot_cnt);
-		priv->rx_desc_cnt = priv->rx_data_slot_cnt;
-	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 
 	gve_enable_supported_features(priv, supported_features_mask,
+				      dev_op_modify_ring,
 				      dev_op_jumbo_frames);
 
 free_device_descriptor:
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index f894beb3deaf..1ff55f957427 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -71,12 +71,12 @@ struct gve_device_descriptor {
 	__be16 default_num_queues;
 	__be16 mtu;
 	__be16 counters;
-	__be16 tx_pages_per_qpl;
+	__be16 reserved2;
 	__be16 rx_pages_per_qpl;
 	u8  mac[ETH_ALEN];
 	__be16 num_device_options;
 	__be16 total_length;
-	u8  reserved2[6];
+	u8  reserved3[6];
 };
 
 static_assert(sizeof(struct gve_device_descriptor) == 40);
@@ -103,12 +103,19 @@ static_assert(sizeof(struct gve_device_option_gqi_qpl) == 4);
 
 struct gve_device_option_dqo_rda {
 	__be32 supported_features_mask;
-	__be16 tx_comp_ring_entries;
-	__be16 rx_buff_ring_entries;
+	__be32 reserved;
 };
 
 static_assert(sizeof(struct gve_device_option_dqo_rda) == 8);
 
+struct gve_device_option_modify_ring {
+	__be32 supported_features_mask;
+	__be16 max_rx_ring_size;
+	__be16 max_tx_ring_size;
+};
+
+static_assert(sizeof(struct gve_device_option_modify_ring) == 8);
+
 struct gve_device_option_jumbo_frames {
 	__be32 supported_features_mask;
 	__be16 max_mtu;
@@ -130,6 +137,7 @@ enum gve_dev_opt_id {
 	GVE_DEV_OPT_ID_GQI_RDA = 0x2,
 	GVE_DEV_OPT_ID_GQI_QPL = 0x3,
 	GVE_DEV_OPT_ID_DQO_RDA = 0x4,
+	GVE_DEV_OPT_ID_MODIFY_RING = 0x6,
 	GVE_DEV_OPT_ID_JUMBO_FRAMES = 0x8,
 };
 
@@ -138,10 +146,12 @@ enum gve_dev_opt_req_feat_mask {
 	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RDA = 0x0,
 	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_QPL = 0x0,
 	GVE_DEV_OPT_REQ_FEAT_MASK_DQO_RDA = 0x0,
+	GVE_DEV_OPT_REQ_FEAT_MASK_MODIFY_RING = 0x0,
 	GVE_DEV_OPT_REQ_FEAT_MASK_JUMBO_FRAMES = 0x0,
 };
 
 enum gve_sup_feature_mask {
+	GVE_SUP_MODIFY_RING_MASK  = 1 << 0,
 	GVE_SUP_JUMBO_FRAMES_MASK = 1 << 2,
 };
 
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index cfd4b8d284d1..e25c1bc07172 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -475,13 +475,85 @@ static void gve_get_ringparam(struct net_device *netdev,
 			      struct netlink_ext_ack *extack)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-
-	cmd->rx_max_pending = priv->rx_desc_cnt;
-	cmd->tx_max_pending = priv->tx_desc_cnt;
+	cmd->rx_max_pending = priv->max_rx_desc_cnt;
+	cmd->tx_max_pending = priv->max_tx_desc_cnt;
 	cmd->rx_pending = priv->rx_desc_cnt;
 	cmd->tx_pending = priv->tx_desc_cnt;
 }
 
+static int gve_set_ringparam(struct net_device *netdev,
+			     struct ethtool_ringparam *cmd,
+			     struct kernel_ethtool_ringparam *kernel_cmd,
+			     struct netlink_ext_ack *extack)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	int old_rx_desc_cnt = priv->rx_desc_cnt;
+	int old_tx_desc_cnt = priv->tx_desc_cnt;
+	int new_tx_desc_cnt = cmd->tx_pending;
+	int new_rx_desc_cnt = cmd->rx_pending;
+	int new_max_registered_pages =
+		new_rx_desc_cnt * gve_num_rx_qpls(priv) +
+			GVE_TX_PAGE_COUNT * gve_num_tx_qpls(priv);
+
+	if (!priv->modify_ringsize_enabled) {
+		dev_err(&priv->pdev->dev, "Modify ringsize disabled\n");
+		return -EINVAL;
+	}
+
+	if (new_tx_desc_cnt < GVE_RING_LENGTH_LIMIT_MIN ||
+		new_rx_desc_cnt < GVE_RING_LENGTH_LIMIT_MIN) {
+		dev_err(&priv->pdev->dev, "Ring size cannot be less than %d\n",
+			GVE_RING_LENGTH_LIMIT_MIN);
+		return -EINVAL;
+	}
+
+	if (new_tx_desc_cnt > GVE_RING_LENGTH_LIMIT_MAX ||
+		new_rx_desc_cnt > GVE_RING_LENGTH_LIMIT_MAX) {
+		dev_err(&priv->pdev->dev,
+			"Ring size cannot be greater than %d\n",
+			GVE_RING_LENGTH_LIMIT_MAX);
+		return -EINVAL;
+	}
+
+	/* Ring size must be a power of 2, will fail if passed values are not
+	 * In the future we may want to update to round down to the
+	 * closest valid ring size
+	 */
+	if ((new_tx_desc_cnt & (new_tx_desc_cnt - 1)) != 0 ||
+		(new_rx_desc_cnt & (new_rx_desc_cnt - 1)) != 0) {
+		dev_err(&priv->pdev->dev, "Ring size must be a power of 2\n");
+		return -EINVAL;
+	}
+
+	if (new_tx_desc_cnt > priv->max_tx_desc_cnt) {
+		dev_err(&priv->pdev->dev,
+			"Tx ring size passed %d is larger than max tx ring size %u\n",
+			new_tx_desc_cnt, priv->max_tx_desc_cnt);
+		return -EINVAL;
+	}
+
+	if (new_rx_desc_cnt > priv->max_rx_desc_cnt) {
+		dev_err(&priv->pdev->dev,
+			"Rx ring size passed %d is larger than max rx ring size %u\n",
+			new_rx_desc_cnt, priv->max_rx_desc_cnt);
+		return -EINVAL;
+	}
+
+	if (new_max_registered_pages > priv->max_registered_pages) {
+		dev_err(&priv->pdev->dev,
+				"Allocating too many pages %d; max %llu",
+				new_max_registered_pages,
+				priv->max_registered_pages);
+		return -EINVAL;
+	}
+
+	// Nothing to change return success
+	if (new_tx_desc_cnt == old_tx_desc_cnt && new_rx_desc_cnt == old_rx_desc_cnt)
+		return 0;
+
+	return gve_adjust_ring_sizes(priv, new_tx_desc_cnt, new_rx_desc_cnt);
+}
+
 static int gve_user_reset(struct net_device *netdev, u32 *flags)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
@@ -664,6 +736,7 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.get_coalesce = gve_get_coalesce,
 	.set_coalesce = gve_set_coalesce,
 	.get_ringparam = gve_get_ringparam,
+	.set_ringparam = gve_set_ringparam,
 	.reset = gve_user_reset,
 	.get_tunable = gve_get_tunable,
 	.set_tunable = gve_set_tunable,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 57ce74315eba..13ed755908c7 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1077,8 +1077,7 @@ static int gve_alloc_xdp_qpls(struct gve_priv *priv)
 
 	start_id = gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv));
 	for (i = start_id; i < start_id + gve_num_xdp_qpls(priv); i++) {
-		err = gve_alloc_queue_page_list(priv, i,
-						priv->tx_pages_per_qpl);
+		err = gve_alloc_queue_page_list(priv, i, GVE_TX_PAGE_COUNT);
 		if (err)
 			goto free_qpls;
 	}
@@ -1107,16 +1106,14 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 
 	start_id = gve_tx_start_qpl_id(priv);
 	for (i = start_id; i < start_id + gve_num_tx_qpls(priv); i++) {
-		err = gve_alloc_queue_page_list(priv, i,
-						priv->tx_pages_per_qpl);
+		err = gve_alloc_queue_page_list(priv, i, GVE_TX_PAGE_COUNT);
 		if (err)
 			goto free_qpls;
 	}
 
 	start_id = gve_rx_start_qpl_id(priv);
 	for (i = start_id; i < start_id + gve_num_rx_qpls(priv); i++) {
-		err = gve_alloc_queue_page_list(priv, i,
-						priv->rx_data_slot_cnt);
+		err = gve_alloc_queue_page_list(priv, i, priv->rx_desc_cnt);
 		if (err)
 			goto free_qpls;
 	}
@@ -1387,6 +1384,38 @@ static int gve_close(struct net_device *dev)
 	return gve_reset_recovery(priv, false);
 }
 
+int gve_adjust_ring_sizes(struct gve_priv *priv,
+			  int new_tx_desc_cnt,
+			  int new_rx_desc_cnt)
+{
+	int err;
+
+	if (netif_carrier_ok(priv->dev)) {
+		err = gve_close(priv->dev);
+		if (err)
+			return err;
+		priv->tx_desc_cnt = new_tx_desc_cnt;
+		priv->rx_desc_cnt = new_rx_desc_cnt;
+
+		err = gve_open(priv->dev);
+		if (err)
+			goto err;
+		return 0;
+	}
+
+	priv->tx_desc_cnt = new_tx_desc_cnt;
+	priv->rx_desc_cnt = new_rx_desc_cnt;
+
+	return 0;
+
+err:
+	dev_err(&priv->pdev->dev,
+		"Failed to adjust ring sizes: err=%d. Disabling all queues.\n",
+		err);
+	gve_turndown(priv);
+	return err;
+}
+
 static int gve_remove_xdp_queues(struct gve_priv *priv)
 {
 	int err;
@@ -2039,6 +2068,8 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		goto setup_device;
 
 	priv->queue_format = GVE_QUEUE_FORMAT_UNSPECIFIED;
+	priv->modify_ringsize_enabled = false;
+
 	/* Get the initial information we need from the device */
 	err = gve_adminq_describe_device(priv);
 	if (err) {
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index d1da7413dc4d..e52c048fc846 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -197,9 +197,9 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_rx_ring *rx = &priv->rx[idx];
 	struct device *hdev = &priv->pdev->dev;
-	u32 slots, npages;
 	int filled_pages;
 	size_t bytes;
+	u32 slots;
 	int err;
 
 	netif_dbg(priv, drv, priv->dev, "allocating rx ring\n");
@@ -209,7 +209,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 	rx->gve = priv;
 	rx->q_num = idx;
 
-	slots = priv->rx_data_slot_cnt;
+	slots = priv->rx_desc_cnt;
 	rx->mask = slots - 1;
 	rx->data.raw_addressing = priv->queue_format == GVE_GQI_RDA_FORMAT;
 
@@ -256,12 +256,6 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 
 	/* alloc rx desc ring */
 	bytes = sizeof(struct gve_rx_desc) * priv->rx_desc_cnt;
-	npages = bytes / PAGE_SIZE;
-	if (npages * PAGE_SIZE != bytes) {
-		err = -EIO;
-		goto abort_with_q_resources;
-	}
-
 	rx->desc.desc_ring = dma_alloc_coherent(hdev, bytes, &rx->desc.bus,
 						GFP_KERNEL);
 	if (!rx->desc.desc_ring) {
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index e57b73eb70f6..90344e6fdff7 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -228,8 +228,7 @@ static int gve_rx_alloc_ring_dqo(struct gve_priv *priv, int idx)
 	size_t size;
 	int i;
 
-	const u32 buffer_queue_slots =
-		priv->options_dqo_rda.rx_buff_ring_entries;
+	const u32 buffer_queue_slots = priv->rx_desc_cnt;
 	const u32 completion_queue_slots = priv->rx_desc_cnt;
 
 	netif_dbg(priv, drv, priv->dev, "allocating rx ring DQO\n");
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index b76143bfd594..107eca0b5c1c 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -154,7 +154,7 @@ static int gve_tx_alloc_ring_dqo(struct gve_priv *priv, int idx)
 
 	/* Queue sizes must be a power of 2 */
 	tx->mask = priv->tx_desc_cnt - 1;
-	tx->dqo.complq_mask = priv->options_dqo_rda.tx_comp_ring_entries - 1;
+	tx->dqo.complq_mask = priv->tx_desc_cnt - 1;
 
 	/* The max number of pending packets determines the maximum number of
 	 * descriptors which maybe written to the completion queue.
-- 
2.40.0.634.g4ca3ef3211-goog

