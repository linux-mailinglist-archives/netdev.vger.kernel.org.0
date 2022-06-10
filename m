Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409565469BC
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346183AbiFJPqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240913AbiFJPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:46:24 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F325932ECC
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:21 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id f12so21241367ilj.1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S7La6nBk9Cx4BOrsERhSKtFTTEJXNgqXNboxuglpfJg=;
        b=PxMvN8seSWWhuH2UJ7lvFUjHsGE+jwR1lX4BUn8STq/hm4XqYNvgH+lIOdhUYxFbXI
         qUd8Gum0pEV1mw7hUSYPH8UVW9RpfhvX86svQXwrhh9ml6TropR9pqxjyr5yP+t08dDu
         /HM8wf60+VxPH6BH/4cSDRABqcCjyiTkimptZTniLCAo2c2Z6ITZOLBmGzwnBepwVfs0
         A0RVsaDxumAuZnA/qXhrvfry1P5SuPj4G/hkEYeIPsnt/bxwhQljPwJnI0b7iEaYYFo7
         lDb0RQ8t5vVcakzuH0IF/DSVF1bxB1XQLy6hQAZpnRnf0+cGMBb0COGym5SEdIJPZejp
         /8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7La6nBk9Cx4BOrsERhSKtFTTEJXNgqXNboxuglpfJg=;
        b=n8NJlg73SWfIeeoJexQ9kcQLJj7igyfjdnkzWHwVBvk60TMJr/cz/U09t2If/TE1Th
         qCdBnjLf70iP3KnI+hVykpzTq7m/r5vsYgyn4Hr/A5UI8pKCnxvlnfHKVrcfFRuNeZd+
         cWfKdAO+leOQuypEYyaITcBYN+oyXGU/shHQTe5OSxFPIFPOqfjCsOI6k5tca8Mzb+3j
         C1zZeUbF8PqM3Kzze0KkvXESfElCWTMd7FLVZEcAtoFwrqfsY0u5h0Ujtrvkra0bosB9
         DfO+ZqGyxvlRLLnS1IuE9O6z1Y+KqHGcOfzETvPK5XXorusQcfpAHbpcidb+IJ1VyNyP
         PXHA==
X-Gm-Message-State: AOAM5334Ji43k9t9zeo6Uu98PLFzaXrgdUxYgqxTw7TzVOU921F5+Cug
        wkrlY7JFfJQm2YCD9maoHjG1Gg==
X-Google-Smtp-Source: ABdhPJzlXpTG8DdFUCx6d2OvAlPVIBA+7masa5y5JPqmXL69816WafFNg8YVYSOB9yz0mdBxHOn7lA==
X-Received: by 2002:a05:6e02:552:b0:2d1:db28:5434 with SMTP id i18-20020a056e02055200b002d1db285434mr25898979ils.115.1654875981312;
        Fri, 10 Jun 2022 08:46:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y15-20020a92950f000000b002d3adf71893sm12100488ilh.20.2022.06.10.08.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:46:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: rename channel->tlv_count
Date:   Fri, 10 Jun 2022 10:46:11 -0500
Message-Id: <20220610154616.249304-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610154616.249304-1-elder@linaro.org>
References: <20220610154616.249304-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each GSI channel has a TLV FIFO of a certain size, specified in the
configuration data for an AP channel.  That size dictates the
maximum number of TREs that are allowed in a single transaction.

The only way that value is used after initialization is as a limit
on the number of TREs in a transaction; calling it "tlv_count"
isn't helpful, and in fact gsi_channel_trans_tre_max() exists to
sort of abstract it.

Instead, rename the channel->tlv_count field trans_tre_max, and get
rid of the helper function.  Update a couple of comments as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 14 +++-----------
 drivers/net/ipa/gsi.h          | 11 +----------
 drivers/net/ipa/gsi_trans.c    |  8 ++------
 drivers/net/ipa/ipa_cmd.c      |  8 ++++----
 drivers/net/ipa/ipa_endpoint.c |  2 +-
 5 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 65ed5a697577e..b1acc7d36b23b 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -823,7 +823,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 
 	/* Now update the scratch registers for GPI protocol */
 	gpi = &scr.gpi;
-	gpi->max_outstanding_tre = gsi_channel_trans_tre_max(gsi, channel_id) *
+	gpi->max_outstanding_tre = channel->trans_tre_max *
 					GSI_RING_ELEMENT_SIZE;
 	gpi->outstanding_threshold = 2 * GSI_RING_ELEMENT_SIZE;
 
@@ -2095,7 +2095,7 @@ static int gsi_channel_init_one(struct gsi *gsi,
 	channel->gsi = gsi;
 	channel->toward_ipa = data->toward_ipa;
 	channel->command = command;
-	channel->tlv_count = data->channel.tlv_count;
+	channel->trans_tre_max = data->channel.tlv_count;
 	channel->tre_count = tre_count;
 	channel->event_count = data->channel.event_count;
 
@@ -2310,13 +2310,5 @@ u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
 	/* Hardware limit is channel->tre_count - 1 */
-	return channel->tre_count - (channel->tlv_count - 1);
-}
-
-/* Returns the maximum number of TREs in a single transaction for a channel */
-u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id)
-{
-	struct gsi_channel *channel = &gsi->channel[channel_id];
-
-	return channel->tlv_count;
+	return channel->tre_count - (channel->trans_tre_max - 1);
 }
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 5d66116b46b03..89dac7fc8c4cb 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -110,7 +110,7 @@ struct gsi_channel {
 	bool toward_ipa;
 	bool command;			/* AP command TX channel or not */
 
-	u8 tlv_count;			/* # entries in TLV FIFO */
+	u8 trans_tre_max;		/* max TREs in a transaction */
 	u16 tre_count;
 	u16 event_count;
 
@@ -188,15 +188,6 @@ void gsi_teardown(struct gsi *gsi);
  */
 u32 gsi_channel_tre_max(struct gsi *gsi, u32 channel_id);
 
-/**
- * gsi_channel_trans_tre_max() - Maximum TREs in a single transaction
- * @gsi:	GSI pointer
- * @channel_id:	Channel whose limit is to be returned
- *
- * Return:	 The maximum TRE count per transaction on the channel
- */
-u32 gsi_channel_trans_tre_max(struct gsi *gsi, u32 channel_id);
-
 /**
  * gsi_channel_start() - Start an allocated GSI channel
  * @gsi:	GSI pointer
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 55f8fe7d2668e..870a4c1752838 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -340,7 +340,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	struct gsi_trans_info *trans_info;
 	struct gsi_trans *trans;
 
-	if (WARN_ON(tre_count > gsi_channel_trans_tre_max(gsi, channel_id)))
+	if (WARN_ON(tre_count > channel->trans_tre_max))
 		return NULL;
 
 	trans_info = &channel->trans_info;
@@ -745,14 +745,10 @@ int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
 	 * element is used to fill a single TRE when the transaction is
 	 * committed.  So we need as many scatterlist elements as the
 	 * maximum number of TREs that can be outstanding.
-	 *
-	 * All TREs in a transaction must fit within the channel's TLV FIFO.
-	 * A transaction on a channel can allocate as many TREs as that but
-	 * no more.
 	 */
 	ret = gsi_trans_pool_init(&trans_info->sg_pool,
 				  sizeof(struct scatterlist),
-				  tre_max, channel->tlv_count);
+				  tre_max, channel->trans_tre_max);
 	if (ret)
 		goto err_trans_pool_exit;
 
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index e58cd4478fd3d..6dea40259b604 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -353,13 +353,13 @@ int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
 	/* This is as good a place as any to validate build constants */
 	ipa_cmd_validate_build();
 
-	/* Even though command payloads are allocated one at a time,
-	 * a single transaction can require up to tlv_count of them,
-	 * so we treat them as if that many can be allocated at once.
+	/* Command payloads are allocated one at a time, but a single
+	 * transaction can require up to the maximum supported by the
+	 * channel; treat them as if they were allocated all at once.
 	 */
 	return gsi_trans_pool_init_dma(dev, &trans_info->cmd_pool,
 				       sizeof(union ipa_cmd_payload),
-				       tre_max, channel->tlv_count);
+				       tre_max, channel->trans_tre_max);
 }
 
 void ipa_cmd_pool_exit(struct gsi_channel *channel)
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index d3b3255ac3d12..57507a109269b 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1721,7 +1721,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 	if (endpoint->ee_id != GSI_EE_AP)
 		return;
 
-	endpoint->trans_tre_max = gsi_channel_trans_tre_max(gsi, channel_id);
+	endpoint->trans_tre_max = gsi->channel[channel_id].trans_tre_max;
 	if (!endpoint->toward_ipa) {
 		/* RX transactions require a single TRE, so the maximum
 		 * backlog is the same as the maximum outstanding TREs.
-- 
2.34.1

