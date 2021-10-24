Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF22438B7F
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhJXSpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhJXSpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 14:45:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB2DC061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 11:42:58 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mm1-20020a17090b358100b001a0a81b8664so5485479pjb.6
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 11:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4efNYA+fJXkTzMvmqOGZBOMBHDvpro7VjwyYWiUTufo=;
        b=AuyUqlKDfC88zvqU+xMEKLvIpMZPs4C1+paxV/sncc+RqYwnAfcW4kBV9MhFB83Ksb
         y7F/dlqiA907jtrsTQaCFFcsXrfPudP9nQQsS3pUyi086f845dibBoZ7j1f5bvw5blzg
         yG2yCPS6fgoryxw6SG9+J2ODIkPDqmVsT/NM1fAE+zEZdJxfefkMhScPb28eNAcVsv/C
         2VkYUD+JRkQUGdsWTlg5mcPWTIEMHR+AI5lhy9F4GiAnLsTVjxjz1n4it61tD8iROauc
         ZNmd+uMx4+UDDK89P5QnDOcvf1BY5rZ5HNuUn0L5MUbqhrnTWG7MHelJX/CCF60G/YY+
         6eNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4efNYA+fJXkTzMvmqOGZBOMBHDvpro7VjwyYWiUTufo=;
        b=y7lAU1pJJr3HqfU0nR4Z9ooYA6J/hzm/Y1cU18PPNtiqsplYc9Az2STV5d3x0StbIw
         I9oqQJhiVJOadqMRxoGLR/zgjPB1yuEDGdCmSWKe14khZ6h6enYlaxb4P4pTVpOrrCDW
         d8xFNJJqjxsxKgg1+ghRYWNv5a3lhm2ie8YpouQtKOy/HbbLNFwiM/stJNyL5e9b/SC8
         nhSbUTJwAeA786idWFUxRDGy37CMZQmQoDEZM6DX/tgNsjh2Pg86CvGyPhfo7bamC3UD
         0WIwhcQQxsXAIQzyY8estE84pR2ejisNhYUHQjY714rFSnC/OqZdcbImYocenXbI0h0i
         Z2+g==
X-Gm-Message-State: AOAM532Ze5CuHx3GI/cmldEh/hZhtm3vy/lkhVz7Evls62i38IMdCkVS
        CqG3W0JcJfDoEi5zHMp4CNTPKFQvIm8AGbTYGqLeB4TPRFYYxbpoWPfDxQQNe0JP3L/7GyAYrlf
        viC90WRfykSEyaORvaSX1Z9EK0Hp0gwO0KUcRqRBhbXnn9OtMcMbBkeIIKIT7hfsKWpE=
X-Google-Smtp-Source: ABdhPJxfbgMmJ3qbe5d2uS3Msc960nVUecEKd4b3ZSTTwVC8CiavN17t6ussHOrS275DG5Lxb7SvIa5ADmLeXA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:e3d1:fd04:4781:9855])
 (user=jeroendb job=sendgmr) by 2002:a05:6a00:1312:b0:44c:becf:b329 with SMTP
 id j18-20020a056a00131200b0044cbecfb329mr13551155pfu.5.1635100977473; Sun, 24
 Oct 2021 11:42:57 -0700 (PDT)
Date:   Sun, 24 Oct 2021 11:42:38 -0700
In-Reply-To: <20211024184238.409589-1-jeroendb@google.com>
Message-Id: <20211024184238.409589-4-jeroendb@google.com>
Mime-Version: 1.0
References: <20211024184238.409589-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH net-next 3/3] gve: Add a jumbo-frame device option.
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shailend Chand <shailend@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shailend Chand <shailend@google.com>

A widely deployed driver has a bug that will cause the driver not
to load when a max_mtu > 2048 is present in the device descriptor.

To avoid this bug while still enabling jumbo frames, we present a lower
max_mtu in the device descriptor and pass the actual max_mtu in
a separate device option.

The driver supports 2 different queue formats. To enable features
on one queue format, but not the other, a supported_features mask
was added to the device options in the device descriptor.

Signed-off-by: Shailend Chand <shailend@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 58 ++++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_adminq.h | 14 +++++
 2 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 3dfda6da6a96..83ae56c310d3 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -38,7 +38,8 @@ void gve_parse_device_option(struct gve_priv *priv,
 			     struct gve_device_option *option,
 			     struct gve_device_option_gqi_rda **dev_op_gqi_rda,
 			     struct gve_device_option_gqi_qpl **dev_op_gqi_qpl,
-			     struct gve_device_option_dqo_rda **dev_op_dqo_rda)
+			     struct gve_device_option_dqo_rda **dev_op_dqo_rda,
+			     struct gve_device_option_jumbo_frames **dev_op_jumbo_frames)
 {
 	u32 req_feat_mask = be32_to_cpu(option->required_features_mask);
 	u16 option_length = be16_to_cpu(option->option_length);
@@ -111,6 +112,24 @@ void gve_parse_device_option(struct gve_priv *priv,
 		}
 		*dev_op_dqo_rda = (void *)(option + 1);
 		break;
+	case GVE_DEV_OPT_ID_JUMBO_FRAMES:
+		if (option_length < sizeof(**dev_op_jumbo_frames) ||
+		    req_feat_mask != GVE_DEV_OPT_REQ_FEAT_MASK_JUMBO_FRAMES) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT,
+				 "Jumbo Frames",
+				 (int)sizeof(**dev_op_jumbo_frames),
+				 GVE_DEV_OPT_REQ_FEAT_MASK_JUMBO_FRAMES,
+				 option_length, req_feat_mask);
+			break;
+		}
+
+		if (option_length > sizeof(**dev_op_jumbo_frames)) {
+			dev_warn(&priv->pdev->dev,
+				 GVE_DEVICE_OPTION_TOO_BIG_FMT,
+				 "Jumbo Frames");
+		}
+		*dev_op_jumbo_frames = (void *)(option + 1);
+		break;
 	default:
 		/* If we don't recognize the option just continue
 		 * without doing anything.
@@ -126,7 +145,8 @@ gve_process_device_options(struct gve_priv *priv,
 			   struct gve_device_descriptor *descriptor,
 			   struct gve_device_option_gqi_rda **dev_op_gqi_rda,
 			   struct gve_device_option_gqi_qpl **dev_op_gqi_qpl,
-			   struct gve_device_option_dqo_rda **dev_op_dqo_rda)
+			   struct gve_device_option_dqo_rda **dev_op_dqo_rda,
+			   struct gve_device_option_jumbo_frames **dev_op_jumbo_frames)
 {
 	const int num_options = be16_to_cpu(descriptor->num_device_options);
 	struct gve_device_option *dev_opt;
@@ -146,7 +166,7 @@ gve_process_device_options(struct gve_priv *priv,
 
 		gve_parse_device_option(priv, descriptor, dev_opt,
 					dev_op_gqi_rda, dev_op_gqi_qpl,
-					dev_op_dqo_rda);
+					dev_op_dqo_rda, dev_op_jumbo_frames);
 		dev_opt = next_opt;
 	}
 
@@ -661,12 +681,31 @@ gve_set_desc_cnt_dqo(struct gve_priv *priv,
 	return 0;
 }
 
+static void gve_enable_supported_features(struct gve_priv *priv,
+					  u32 supported_features_mask,
+					  const struct gve_device_option_jumbo_frames
+						  *dev_op_jumbo_frames)
+{
+	/* Before control reaches this point, the page-size-capped max MTU from
+	 * the gve_device_descriptor field has already been stored in
+	 * priv->dev->max_mtu. We overwrite it with the true max MTU below.
+	 */
+	if (dev_op_jumbo_frames &&
+	    (supported_features_mask & GVE_SUP_JUMBO_FRAMES_MASK)) {
+		dev_info(&priv->pdev->dev,
+			 "JUMBO FRAMES device option enabled.\n");
+		priv->dev->max_mtu = be16_to_cpu(dev_op_jumbo_frames->max_mtu);
+	}
+}
+
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
+	struct gve_device_option_jumbo_frames *dev_op_jumbo_frames = NULL;
 	struct gve_device_option_gqi_rda *dev_op_gqi_rda = NULL;
 	struct gve_device_option_gqi_qpl *dev_op_gqi_qpl = NULL;
 	struct gve_device_option_dqo_rda *dev_op_dqo_rda = NULL;
 	struct gve_device_descriptor *descriptor;
+	u32 supported_features_mask = 0;
 	union gve_adminq_command cmd;
 	dma_addr_t descriptor_bus;
 	int err = 0;
@@ -690,7 +729,8 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		goto free_device_descriptor;
 
 	err = gve_process_device_options(priv, descriptor, &dev_op_gqi_rda,
-					 &dev_op_gqi_qpl, &dev_op_dqo_rda);
+					 &dev_op_gqi_qpl, &dev_op_dqo_rda,
+					 &dev_op_jumbo_frames);
 	if (err)
 		goto free_device_descriptor;
 
@@ -705,12 +745,19 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->queue_format = GVE_DQO_RDA_FORMAT;
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with DQO RDA queue format.\n");
+		supported_features_mask =
+			be32_to_cpu(dev_op_dqo_rda->supported_features_mask);
 	} else if (dev_op_gqi_rda) {
 		priv->queue_format = GVE_GQI_RDA_FORMAT;
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with GQI RDA queue format.\n");
+		supported_features_mask =
+			be32_to_cpu(dev_op_gqi_rda->supported_features_mask);
 	} else {
 		priv->queue_format = GVE_GQI_QPL_FORMAT;
+		if (dev_op_gqi_qpl)
+			supported_features_mask =
+				be32_to_cpu(dev_op_gqi_qpl->supported_features_mask);
 		dev_info(&priv->pdev->dev,
 			 "Driver is running with GQI QPL queue format.\n");
 	}
@@ -747,6 +794,9 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 
+	gve_enable_supported_features(priv, supported_features_mask,
+				      dev_op_jumbo_frames);
+
 free_device_descriptor:
 	dma_free_coherent(&priv->pdev->dev, PAGE_SIZE, descriptor,
 			  descriptor_bus);
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 3953f6f7a427..83c0b40cd2d9 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -108,6 +108,14 @@ struct gve_device_option_dqo_rda {
 
 static_assert(sizeof(struct gve_device_option_dqo_rda) == 8);
 
+struct gve_device_option_jumbo_frames {
+	__be32 supported_features_mask;
+	__be16 max_mtu;
+	u8 padding[2];
+};
+
+static_assert(sizeof(struct gve_device_option_jumbo_frames) == 8);
+
 /* Terminology:
  *
  * RDA - Raw DMA Addressing - Buffers associated with SKBs are directly DMA
@@ -121,6 +129,7 @@ enum gve_dev_opt_id {
 	GVE_DEV_OPT_ID_GQI_RDA = 0x2,
 	GVE_DEV_OPT_ID_GQI_QPL = 0x3,
 	GVE_DEV_OPT_ID_DQO_RDA = 0x4,
+	GVE_DEV_OPT_ID_JUMBO_FRAMES = 0x8,
 };
 
 enum gve_dev_opt_req_feat_mask {
@@ -128,6 +137,11 @@ enum gve_dev_opt_req_feat_mask {
 	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_RDA = 0x0,
 	GVE_DEV_OPT_REQ_FEAT_MASK_GQI_QPL = 0x0,
 	GVE_DEV_OPT_REQ_FEAT_MASK_DQO_RDA = 0x0,
+	GVE_DEV_OPT_REQ_FEAT_MASK_JUMBO_FRAMES = 0x0,
+};
+
+enum gve_sup_feature_mask {
+	GVE_SUP_JUMBO_FRAMES_MASK = 1 << 2,
 };
 
 #define GVE_DEV_OPT_LEN_GQI_RAW_ADDRESSING 0x0
-- 
2.33.0.1079.g6e70778dc9-goog

