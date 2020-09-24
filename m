Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE977276586
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgIXBBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgIXBBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:01:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C2C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:01:09 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id x20so1042464pgx.11
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ZjyjkhX6h4je588ShEYNacs/BsQvxGVfAHgapVOpiWY=;
        b=QLvX9RJsVlwgXtIi/cnS7k3Rjho6XIZNBm7pVfnJ2aUK2wMTqIWOv+LVW4fpZE78ZY
         ptqfob34axkG2xcon5xPqWzwjAkcmdr6TYI4thpRcgn3315G51/YFoa+taW9WVp5M7jK
         o8vWnRzi5K8lLgUV+OsMAVsuZNwkxXkNihkRBpPuslY4G/wX/ilX4eTuIJp4wdtTj0NX
         wqmP0rgijrh9QJl3Ygr5Ws+aTzfRVMRnRQh2ehC8qGcVkXJ/XskSJJ0xCCNMrlQmyP4/
         EGZAsUWtn775ZM2Wc43hpSuzNXGh5rFy0cMLodu8s0n2OrBPjZgtQxZDsHMkuSNLKiHC
         eUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZjyjkhX6h4je588ShEYNacs/BsQvxGVfAHgapVOpiWY=;
        b=Dr6fg3qKdzhJzUlAMQKhWGZyZ7oDgev20efB6dGyti0Ol9J5Dwcj2/WAXPrwg+xgGd
         NHRAMjV8FvkMioft5alRCDx0dAdHgqDbBPlc1iLivKv/HfbM8MzucfPSxWmfVqNqJrqg
         woPDb4afls8omfEanIoUgJs94EfmOvrPWZW5sin39Ah0Sb7lYsaJkyL08zicWQ8hkMqk
         f9jZoIbhM93yg9Am6phkxdDsBHcBt5V6Pwyn21+6K51M6bxXcgPzrTSnWclW7MkQQDNq
         wtIVWpEhHV9pdJwOUItde1DVBNl3dJH217aV3B5R5mCsBjbvhSHEkEKDled/PtHlFtRQ
         Fn7A==
X-Gm-Message-State: AOAM5314/neBzboW0VaLj1K93Mdx5FPVfnUyJCbvuojS+G3KI1N/JzQr
        dYR8c6d0M1+468L3JlHZVcbvMfCXQoJbUT46JCQgNkGh8H6bQCjIiN4SLkBdPqI4PLLFXxdYZ2O
        Nhn9sKVjy2bUwvNSkCyWWY/46NkujPq+mlacjwIAT1NOmrtgivAHeSK1GvgJr5XHGg67xC/eU
X-Google-Smtp-Source: ABdhPJwa/VPM9P+O7a0QK1fqyi3ZIycV5QNDjC7LYgDF27e0K2sGXg4nTYEnvY7rxwe+YPOK268utThJDYht4W7g
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:ba90:b029:d1:e5e7:be6e with
 SMTP id k16-20020a170902ba90b02900d1e5e7be6emr2222540pls.72.1600909269312;
 Wed, 23 Sep 2020 18:01:09 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:01:01 -0700
In-Reply-To: <20200924010104.3196839-1-awogbemila@google.com>
Message-Id: <20200924010104.3196839-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200924010104.3196839-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next v3 1/4] gve: Add support for raw addressing device option
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
 drivers/net/ethernet/google/gve/gve_adminq.c | 46 ++++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 +++++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
 4 files changed, 67 insertions(+), 4 deletions(-)

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
index 24ae6a28a806..37221e11b5da 100644
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
@@ -518,6 +521,49 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
+	dev_opt = (void *)(descriptor + 1);
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

