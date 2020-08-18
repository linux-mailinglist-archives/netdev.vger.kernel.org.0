Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55B248EE8
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHRTpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgHRToz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC3AC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:54 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b142so13579517pfb.9
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y2+qRE+LFQJI7tt5mQPQVpc5mJBAldwHxgYDQuWUzro=;
        b=qnyT9tKrwtGw/BPVHtAMyDuq05h7DkAS+h+kFsnueXMFw7WDpTjfo74TtgFKHXjkxF
         +0OPI5Uuhrgswwtj5cUJm/VqkIOshL6gu2YDBhlsX2UNNHMtLL8pk4skGD+JKx+Vnis7
         oXJYjWZdp/gZAj+Wp//q7eKIeMa2m6DU4jPdHpKI6n22kysf6X2H9g41Z91SXB6vL1uf
         dXzuGSbJ84QhuQUhIECcmKA3ohtom6P+/eDIy0gmmNSILILAGQOSocWH6yiNb1yrXqyM
         oKLhk69sx8aHcQ1XLdPq3rwbpV7Xg/H/JabU0RBUcP5nwLMxiKTsAtrLejlyhDuTDQli
         0y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y2+qRE+LFQJI7tt5mQPQVpc5mJBAldwHxgYDQuWUzro=;
        b=RyYo8eBMLoeFFXyNwAokGBQcA6H1UDH3VBs8VL1ngt/zirYrF9lDmjmRXzekL6Ijgb
         H+QnEbjmBsjOrMA3TWduqfDxIwFZCG0ahKxlzuo6gbjXOf1lxRow8M0ECCUmBUwiTEx0
         uk7wkjZ4hf2CITuXPoGJWAMMypyFAFgsKzdCHRN1nnoSXTVjTOLr+RxHbiEG5OHgwbaR
         V+NZj7hIeMh1dRKWuRphjUwyGwCU4kYs/rwqSUgUe1azJVQUS3WmBwPpkXHMpSdbPcdK
         8a3jHp8L69HeCUl7WtFb0EV0p3pHIjRED0U1WWSrJ71Hkix2e8jJD5/QMBULRnohwo0H
         A9Lw==
X-Gm-Message-State: AOAM533NGPmUiGz+ANR17zIzXbVOIWcSE25vPAsYAeRQdmn18z8HH0hW
        TLZdNtovEmzUixe5OOM/E6ZSaqxRONFOPuBlFc/ERdF6LGY0O3zlzUNA9siFCJCMYuKAuP4d0pw
        ODJb4NoY1+v6j2PMnvyg9VApk+75v5SwDICQA2+kmGsgHyzWb0g4o/bbGZkjaYxL7IEt3Vz8E
X-Google-Smtp-Source: ABdhPJylBnXt/XJ42WbST+/u9eYCdIk0WnQroffA2br14sUSE58Bl2ICKF885J8DUJreYomCsMc4Q7drVB0gUNIo
X-Received: by 2002:aa7:9813:: with SMTP id e19mr16503254pfl.285.1597779894215;
 Tue, 18 Aug 2020 12:44:54 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:08 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-10-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 09/18] gve: Add support for raw addressing device option
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add support to describe device for parsing device options. As
the first device option, add raw addressing.

"Raw Addressing" mode (as opposed to the current "qpl" mode) is an
operational mode which allows the driver avoid bounce buffer copies
which it currently performs using pre-allocated qpls (queue_page_lists)
when sending and receiving packets. For egress packets the provided
skb buffer addresses are dma_map'ed and passed to the device. This
means that the device can perform DMA directly from these addresses
and the driver does not have to copy the buffer content into
pre-allocated buffers/qpls (as in qpl mode). For ingress packets copies
are also eliminated as buffers are recycled or newly allocated as
necessary.

Also add the necessary priv field to track the enablement status.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c | 49 +++++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 ++++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
 4 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 0f5871af36af..50565516d1fe 100644
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
index cf5eaab1cb83..cf5d172bec83 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -456,11 +456,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
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
@@ -510,10 +513,54 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
 	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
 		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			priv->rx_pages_per_qpl);
+			  priv->rx_pages_per_qpl);
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
index 685f18697fc1..3e9b69747370 100644
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
@@ -1075,6 +1083,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 	if (skip_describe_device)
 		goto setup_device;
 
+	priv->raw_addressing = false;
 	/* Get the initial information we need from the device */
 	err = gve_adminq_describe_device(priv);
 	if (err) {
-- 
2.28.0.220.ged08abb693-goog

