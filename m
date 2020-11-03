Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964B52A4D6D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgKCRq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCRq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:46:57 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A88FC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:46:57 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id l16so9574653qvt.17
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=8g52K0cJFBVuvRZ/Kuf+ftq8TI+Voabo2HysgByQvPE=;
        b=o6KWEUcO4LbNXkk2h+MHC9p0xkMNToDW+dg4Ku2x4ZceKRL2D1psMo8Hw1s68IFG1Y
         e9DIcw6WJo5gTRL30ji0qp65Um6LUCkjaWDH4IeIXcZ9s3mwiuHBDcmQNLRWyWQbMKg4
         c14CXk9bbp7eNwCoBf33PIEQFqf2AzfnObybOFd93EJGx2/5kbMg+ZkMTrCwOT6NnIrU
         ObW+wUlq2Sywv8kDKQmna+dBFXKTZ9uBgSh5DxLFDR2htB3Af2TkzB+3/51+JmlXMZ5Y
         KZ2Hvmkwwa66kQMy8X6hwscipifRw0EyOR92WjEjGCwpsjluudc/A2DTZJOgK5YEnNUt
         TuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8g52K0cJFBVuvRZ/Kuf+ftq8TI+Voabo2HysgByQvPE=;
        b=DG81x/LQ+LXykNINbrsVDgJuWQr9006pKpoeSfeYjMt3Xrzwogb/FhWZIYRvuKucMF
         y7gwkWouUUKpQ/uMf6sOVCyElB80SHJ3gxjQHeHT1C6bCr2ke6MrhHDHwXPx9GlJXbDF
         +xBMcnSg69PIUMxyxh5qgPynVopF7oO0yUagNXbIBHv1HcPN1XvJqpcIRP3nXSICbQxS
         J4Gg5Na1ac1pvqKpGJ1i+D1+EszAbeCppqSO/6+X9LCKOXctluX6LyYbTkuQSW6atByT
         gqHgWhXUUTE2Jzx9tpqzp2tDXTbxlB8aoctglku0QWLxzOnotUPPEX83sef9EL/OTvX+
         wV7A==
X-Gm-Message-State: AOAM531IzcXw+hJ0N2o4mqiMmowtc7aIEC7lpq37HtVm94fpd6y5tDHC
        QgZeYOesrYRDbSale/UjGuzI6VN5mwiVX53KVEpANEmDVfbn8ypMv8XkN8HxxRzWpav9Pds/ix8
        9vJFKdu1BHSCNxJXFlPs1qbG5BLhW0rmEssxtgjDF3hG4mMWxopjk8U9JlfO12PKp0edR2nra
X-Google-Smtp-Source: ABdhPJzTroEwKsjUrXUm7qmgwVYaWgKuW791ptpIOkll1SI1i4c65C5B+PgvnG+rJGWML5VbSdVUyOQAGnLVVjBV
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:ad4:456c:: with SMTP id
 o12mr28780143qvu.48.1604425616479; Tue, 03 Nov 2020 09:46:56 -0800 (PST)
Date:   Tue,  3 Nov 2020 09:46:48 -0800
In-Reply-To: <20201103174651.590586-1-awogbemila@google.com>
Message-Id: <20201103174651.590586-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20201103174651.590586-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH 1/4] gve: Add support for raw addressing device option
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
 drivers/net/ethernet/google/gve/gve_adminq.c | 52 ++++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 ++++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
 4 files changed, 73 insertions(+), 4 deletions(-)

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
index 24ae6a28a806..0b7a2653fe33 100644
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
@@ -518,6 +521,55 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
+	dev_opt = (void *)(descriptor + 1);
+
+	num_options = be16_to_cpu(descriptor->num_device_options);
+	for (i = 0; i < num_options; i++) {
+		u16 option_length = be16_to_cpu(dev_opt->option_length);
+		u16 option_id = be16_to_cpu(dev_opt->option_id);
+		void *option_end;
+
+		option_end = (void *)dev_opt + sizeof(*dev_opt) + option_length;
+		if (option_end > (void *)descriptor + be16_to_cpu(descriptor->total_length)) {
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
+			    dev_opt->feat_mask !=
+			    cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING)) {
+				dev_warn(&priv->pdev->dev,
+					 "Raw addressing option error:\n"
+					 "	Expected: length=%d, feature_mask=%x.\n"
+					 "	Actual: length=%d, feature_mask=%x.\n",
+					 GVE_DEV_OPT_LEN_RAW_ADDRESSING,
+					 cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING),
+					 option_length, dev_opt->feat_mask);
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
+			dev_dbg(&priv->pdev->dev,
+				"Unrecognized device option 0x%hx not enabled.\n",
+				option_id);
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
2.29.1.341.ge80a0c044ae-goog

