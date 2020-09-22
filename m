Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686262745C0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgIVPvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 11:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgIVPvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 11:51:06 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D475C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 08:51:06 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id g10so16385115qto.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 08:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=W6VeNKWwrxtTR2+Tc1T4jXcfmf6mytMKkItZuq8GSuw=;
        b=dOhPhp5bs0jdtoMQdQGCd6N847ZpJfK1VGYsNR1+yCb+KvvXXFOSSNcvw5c3phB/rP
         3Kw1I+RoMqPcke17rhz2cI6Wv66UWwLnXqE/r1wkZh7dDJjoZn6Ok8FNXM2WH3eLL1hp
         wr+BHG2WE34/fJVgAgyac8E8XjLTSIP1JNmDME4MHAkAQKmALnDCQNKG7ZNU8+sWL028
         7LFvhnrnTbqIifibWEGKFe2HPeWOohzxl7qg3PHRFw3uXU3rBj0MAiwf3xpFuFL7jgSf
         NN4LGuUIU1HqP65HAUit5cSxT1SubNj+3IXcDiVe3nkB7XYtXEib612yRJE5rAuDOb2q
         PdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W6VeNKWwrxtTR2+Tc1T4jXcfmf6mytMKkItZuq8GSuw=;
        b=Pm9o01QRM7gvrsaU/ewqPf8kTL3BB4it8XP1NOfn+/WmzIWMgN5gy5jx2Pz2Dtano4
         7XM+7yja5i+ek/Gk6ieKQBIygjPpqclqYuSBLCcu8NRLor9jpT6qSO+TNHjEM7qUNb7l
         IAokYCe3Wskq8hEXmiB6MVKvYnfaTRXOcQgrWXN86qxY54HAM7FspyHKzguAETgpPqJk
         A73wOk4eCXFkLG1BRvONnYIOoLpVCFqxTbtp83bDR9gn3FFua+lWa4JZY17IGL2JEWiW
         cN6nMjywXMA4pGP7ydoq3Pgr7wBkef1Q/x8ufIW8ev0l2Bx/8kCWjvBpWuFVON9bntmJ
         54bQ==
X-Gm-Message-State: AOAM533wwct+4aFL5+Y5GlGy4ar2HHaTGAILh0Nnbe5oWcZlRi3K6Ryl
        rbGjkzew8MyMy8+kzcce/z+Yl/eIA1/Os3DKiwmBU3XXa8v27L1qWspQJV/rDwNaTSwGbwgYAXU
        u1jR3OO3pz5S7k3yFd3LJTf9SNkftCe4WJsTvBcffIy8zlB9gibL638H45dazWLAA1cWXjSXx
X-Google-Smtp-Source: ABdhPJxAItpEfM9oTH+bhyYC+lznjUf73e5fsZ5qwjild7uOer7Q0LspO7Bj/XhLg8kBEC/ilUOojdFqXfb463Fn
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:ad4:45b3:: with SMTP id
 y19mr6546197qvu.59.1600789865171; Tue, 22 Sep 2020 08:51:05 -0700 (PDT)
Date:   Tue, 22 Sep 2020 08:50:58 -0700
In-Reply-To: <20200922155100.1624976-1-awogbemila@google.com>
Message-Id: <20200922155100.1624976-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200922155100.1624976-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next v2 1/3] gve: Add support for raw addressing device option
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add support to describe device for parsing device options. As
the first device option, add raw addressing.

"Raw Addressing" mode (as opposed to the current "qpl" mode) is an
operational mode which allows the driver avoid bounce buffer copies
which it currently performs using pre-allocated qpls (queue_page_lists)
when sending and receiving packets.
For egress packets, the provided skb data addresses will be dma_map'ed and
passed to the device, allowing the NIC can perform DMA directly - the
driver will not have to copy the buffer content into pre-allocated
buffers/qpls (as in qpl mode).
For ingress packets, copies are also eliminated as buffers are handed to
the networking stack and then recycled or re-allocated as
necessary, avoiding the use of skb_copy_to_linear_data().

This patch only introduces the option to the driver.
Subsequent patches will add the ingress and egress functionality.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c | 47 ++++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 +++++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
 4 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index f5c80229ea96..80cdae06ee39 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -199,6 +199,7 @@ struct gve_priv {
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
+	bool raw_addressing; /* true if this dev supports raw addressing */
 
 	struct gve_queue_config tx_cfg;
 	struct gve_queue_config rx_cfg;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 24ae6a28a806..ba2cb38a4c7d 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -460,11 +460,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
 	struct gve_device_descriptor *descriptor;
+	struct gve_device_option *dev_opt;
 	union gve_adminq_command cmd;
 	dma_addr_t descriptor_bus;
+	u16 num_options;
 	int err = 0;
 	u8 *mac;
 	u16 mtu;
+	int i;
 
 	memset(&cmd, 0, sizeof(cmd));
 	descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
@@ -518,6 +521,50 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
+	dev_opt = (struct gve_device_option *)((void *)descriptor +
+							sizeof(*descriptor));
+
+	num_options = be16_to_cpu(descriptor->num_device_options);
+	for (i = 0; i < num_options; i++) {
+		u16 option_length = be16_to_cpu(dev_opt->option_length);
+		u16 option_id = be16_to_cpu(dev_opt->option_id);
+
+		if ((void *)dev_opt + sizeof(*dev_opt) + option_length > (void *)descriptor +
+				      be16_to_cpu(descriptor->total_length)) {
+			dev_err(&priv->dev->dev,
+				"options exceed device_descriptor's total length.\n");
+			err = -EINVAL;
+			goto free_device_descriptor;
+		}
+
+		switch (option_id) {
+		case GVE_DEV_OPT_ID_RAW_ADDRESSING:
+			/* If the length or feature mask doesn't match,
+			 * continue without enabling the feature.
+			 */
+			if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
+			    be32_to_cpu(dev_opt->feat_mask) !=
+			    GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING) {
+				dev_info(&priv->pdev->dev,
+					 "Raw addressing device option not enabled, length or features mask did not match expected.\n");
+				priv->raw_addressing = false;
+			} else {
+				dev_info(&priv->pdev->dev,
+					 "Raw addressing device option enabled.\n");
+				priv->raw_addressing = true;
+			}
+			break;
+		default:
+			/* If we don't recognize the option just continue
+			 * without doing anything.
+			 */
+			dev_info(&priv->pdev->dev,
+				 "Unrecognized device option 0x%hx not enabled.\n",
+				   option_id);
+			break;
+		}
+		dev_opt = (void *)dev_opt + sizeof(*dev_opt) + option_length;
+	}
 
 free_device_descriptor:
 	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 281de8326bc5..af5f586167bd 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -79,12 +79,17 @@ struct gve_device_descriptor {
 
 static_assert(sizeof(struct gve_device_descriptor) == 40);
 
-struct device_option {
-	__be32 option_id;
-	__be32 option_length;
+struct gve_device_option {
+	__be16 option_id;
+	__be16 option_length;
+	__be32 feat_mask;
 };
 
-static_assert(sizeof(struct device_option) == 8);
+static_assert(sizeof(struct gve_device_option) == 8);
+
+#define GVE_DEV_OPT_ID_RAW_ADDRESSING 0x1
+#define GVE_DEV_OPT_LEN_RAW_ADDRESSING 0x0
+#define GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING 0x0
 
 struct gve_adminq_configure_device_resources {
 	__be64 counter_array;
@@ -111,6 +116,8 @@ struct gve_adminq_unregister_page_list {
 
 static_assert(sizeof(struct gve_adminq_unregister_page_list) == 4);
 
+#define GVE_RAW_ADDRESSING_QPL_ID 0xFFFFFFFF
+
 struct gve_adminq_create_tx_queue {
 	__be32 queue_id;
 	__be32 reserved;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 48a433154ce0..70685c10db0e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -678,6 +678,10 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	int i, j;
 	int err;
 
+	/* Raw addressing means no QPLs */
+	if (priv->raw_addressing)
+		return 0;
+
 	priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
 	if (!priv->qpls)
 		return -ENOMEM;
@@ -718,6 +722,10 @@ static void gve_free_qpls(struct gve_priv *priv)
 	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
 	int i;
 
+	/* Raw addressing means no QPLs */
+	if (priv->raw_addressing)
+		return;
+
 	kvfree(priv->qpl_cfg.qpl_id_map);
 
 	for (i = 0; i < num_qpls; i++)
@@ -1078,6 +1086,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 	if (skip_describe_device)
 		goto setup_device;
 
+	priv->raw_addressing = false;
 	/* Get the initial information we need from the device */
 	err = gve_adminq_describe_device(priv);
 	if (err) {
-- 
2.28.0.681.g6f77f65b4e-goog

