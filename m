Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A671128EAB7
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 04:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbgJOCEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 22:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgJOCEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 22:04:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7819C0610E0
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:27:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h64so1033119ybc.1
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=CQ5VwDO7HsTaOCeMFyBxM7MOxFkC0nfS6IMXMGCfKvE=;
        b=a7cyAHS6XJdvKI/uCDD1SxCx6Mov2EPWCg342+yt1MinNGnjFXIhu1hso3cbO7kui5
         WIQ6euP0YhOCrpQ9pJytT4eC5717BKw4guCQbdIwaqswAchnQ3HgQxIJ7IPT0C2dWf3A
         zs/ZbKR+Jq12qnWEtaJm37FiXqAQXwrDWy/mdHRxzGGgkDYugL2zHzl2s9BWykGT7AaI
         iGOsImpw/sHSycy0aaz8TP4iKmsiUSu/ex/ZNH2qgRfFbS6qyUMGgsrBW+CY8RL7gx9k
         sTmzNeticHv/fuTdA7Uy/tCq0v/Rfy1LFarxJ7gpxRH2dL0ljVlMEIoxa5AB3D3Gs+Ho
         5P2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CQ5VwDO7HsTaOCeMFyBxM7MOxFkC0nfS6IMXMGCfKvE=;
        b=P/mJ7k2ZR6yl0rEo0fkU6/Xv/lHLDy8bkhwnwzsGRnlqADfo93PGpDaVs7cPJZKNZP
         Dz096H8e3QfvGuH+XR6NjHPCCrRwFgVkTjTCPw8Jmz/GPShf+6WwzlEu8rDX3+XCR5NX
         B+ES96fobrFDe85lyR7CFpG+KJV/S4Iz2sny8K7wmB25IMyupD7m/69a8Yz0LO69fRBg
         E96AOob2PJSNmIMxEwtrbspfUanJBUl2RugLfS1Pi9JkvRqufAgNf73u0IjlJGaM2SiX
         K8ktFP5oopmGWxFF2kh8Sp8VLVLCisXEajLoRATnhZuS5zvGdPHXY66tTD+sxp69JGhP
         QY5Q==
X-Gm-Message-State: AOAM533s10hB/zqwCcLemydwSmrloczh7EZ6OgZol5OUDfEe1zi2PYxz
        yFttOtBzJXKAPBKzIGC5wBjKIXb7BOrf4/6zqTngUmmeGq3cC0dxGqAsWQy0nI9N53EEcr9zU1m
        Iy626qi5KytE/gXOLx5/n/Itmlw+Yn5hpYh/bYkeYWntL+sflGO23fR3MHuiQTEQ4m1YU2xG7
X-Google-Smtp-Source: ABdhPJw3fS2fOfPcszgGnmSuncBhs3diRjM9WbBzd9uL/YB0b3lARyOCOTha8fkHNvI0x82W38PiqeOdGnZcexD+
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:32c1:: with SMTP id
 y184mr1268608yby.298.1602714441727; Wed, 14 Oct 2020 15:27:21 -0700 (PDT)
Date:   Wed, 14 Oct 2020 15:27:12 -0700
In-Reply-To: <20201014222715.83445-1-awogbemila@google.com>
Message-Id: <20201014222715.83445-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20201014222715.83445-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH net-next v4 1/4] gve: Add support for raw addressing device option
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
2.28.0.1011.ga647a8990f-goog

