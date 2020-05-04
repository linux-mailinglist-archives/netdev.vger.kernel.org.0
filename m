Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794411C4A53
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgEDXaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbgEDXaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:30:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BE1C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:30:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s30so562052qth.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPkMK7iLdMkkzq7B8dNOi8WgBwgzdeqkyHYCn9icAjk=;
        b=GLl7hYbGWQotGxTTVaFwadY+z2VHRaszV+DCeuay19Cx+nw75ftmUZHprK5RtIYBqu
         r+eqO6EPZCXKQuzpHL5RamMJGFurJHLvlOMepSuwv7D2YPFdCwANVR6oJaZb5bDzydTt
         yHQoEPUZu8GdhNTZZlBvpVu7FqpjD6iHFcqMQk898tEqAK1EWtpv6IH+8WFXG6OGX7vR
         2I65Mrnaw6JUi+0rLIxXRi2/jq3ny5TO2ESVXsvDqvZh702Q/ExDPpqeb8fDC+BPXiDc
         wZIArxjRK+H5eHIxulGBY0lH8fAX8riUhHYeGzxGnMU/M1U8J6qw6LKnVGuG11GFTjM8
         SURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IPkMK7iLdMkkzq7B8dNOi8WgBwgzdeqkyHYCn9icAjk=;
        b=AaiOp2vbs6PhiBYmp1TrPhROH59lFPBus0JnYmPRIGUlDzvp3Qc1AWpyoN+c/D52mS
         Jl7k+YBB3IMOjPtfFE1hIBhlxECIJIrPOZe5fnQuXX/7y4KDRNFM9HIu2bLi4fI25ST9
         z/v6ODIM7O1JdDL4XgCeTPPme+SG+R8/5t2of4NL+VwaTSsUQo8dRvZHaxNL2K286ft7
         gG9xZQ1XwrxdsKazlVCLzEyhkPBjRRkM0eJD1raTNtbQn0XbzdUje/J5xhvif8Kcn9ek
         L/PfvaaAwZu8vjVqY+Lt9vJjQn7UDF/Cpa4YLBh25PKowGX8edOIQKWqd8MO+2qbwATh
         q32Q==
X-Gm-Message-State: AGi0PuYtAxuzEboobCiWrNsw9nPSA++4MWG+BRnrJGwOMTJ5NjSHfXT6
        z4CVryuWF86covZUdHtE3K70Gw==
X-Google-Smtp-Source: APiQypI9jtjc/LjwUAwQdnuG9KSGn3wiyBefgJFBkHfgLqlzZv86k1zJ9AcRRcV7c1Sk2mG2VDKlvg==
X-Received: by 2002:ac8:3713:: with SMTP id o19mr1614242qtb.371.1588635016829;
        Mon, 04 May 2020 16:30:16 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c41sm253033qta.96.2020.05.04.16.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:30:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: rename db_enable flag
Date:   Mon,  4 May 2020 18:30:02 -0500
Message-Id: <20200504233003.16670-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504233003.16670-1-elder@linaro.org>
References: <20200504233003.16670-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In several places, a Boolean flag is used in the GSI code to
indicate whether the "doorbell engine" should be enabled or not
when a channel is configured.  This is basically done to abstract
this property from the IPA version; the GSI code doesn't otherwise
"know" what the IPA hardware version is.  The doorbell engine is
enabled only for IPA v3.5.1, not for IPA v4.0 and later.

The next patch makes another change that affects behavior during
channel reset (which also involves programming the channel).  It
also distinguishes IPA v3.5.1 hardware from newer hardware.

Rather than creating another flag whose value matches the "db_enable"
value, just rename "db_enable" to be "legacy" so it can be used to
signal more than just the special doorbell handling.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 16 ++++++++--------
 drivers/net/ipa/gsi.h          | 12 ++++++------
 drivers/net/ipa/ipa_endpoint.c | 12 ++++++------
 drivers/net/ipa/ipa_main.c     |  2 +-
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 8184d34124b7..cd5d8045c7e5 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -834,7 +834,7 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 }
 
 /* Reset and reconfigure a channel (possibly leaving doorbell disabled) */
-void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool db_enable)
+void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool legacy)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
@@ -845,7 +845,7 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool db_enable)
 	if (!channel->toward_ipa)
 		gsi_channel_reset_command(channel);
 
-	gsi_channel_program(channel, db_enable);
+	gsi_channel_program(channel, legacy);
 	gsi_channel_trans_cancel_pending(channel);
 
 	mutex_unlock(&gsi->mutex);
@@ -1455,7 +1455,7 @@ static void gsi_evt_ring_teardown(struct gsi *gsi)
 
 /* Setup function for a single channel */
 static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id,
-				 bool db_enable)
+				 bool legacy)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	u32 evt_ring_id = channel->evt_ring_id;
@@ -1474,7 +1474,7 @@ static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id,
 	if (ret)
 		goto err_evt_ring_de_alloc;
 
-	gsi_channel_program(channel, db_enable);
+	gsi_channel_program(channel, legacy);
 
 	if (channel->toward_ipa)
 		netif_tx_napi_add(&gsi->dummy_dev, &channel->napi,
@@ -1545,7 +1545,7 @@ static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 }
 
 /* Setup function for channels */
-static int gsi_channel_setup(struct gsi *gsi, bool db_enable)
+static int gsi_channel_setup(struct gsi *gsi, bool legacy)
 {
 	u32 channel_id = 0;
 	u32 mask;
@@ -1557,7 +1557,7 @@ static int gsi_channel_setup(struct gsi *gsi, bool db_enable)
 	mutex_lock(&gsi->mutex);
 
 	do {
-		ret = gsi_channel_setup_one(gsi, channel_id, db_enable);
+		ret = gsi_channel_setup_one(gsi, channel_id, legacy);
 		if (ret)
 			goto err_unwind;
 	} while (++channel_id < gsi->channel_count);
@@ -1643,7 +1643,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
 }
 
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
-int gsi_setup(struct gsi *gsi, bool db_enable)
+int gsi_setup(struct gsi *gsi, bool legacy)
 {
 	u32 val;
 
@@ -1686,7 +1686,7 @@ int gsi_setup(struct gsi *gsi, bool db_enable)
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
 	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
 
-	return gsi_channel_setup(gsi, db_enable);
+	return gsi_channel_setup(gsi, legacy);
 }
 
 /* Inverse of gsi_setup() */
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 19471017fadf..90a02194e7ad 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -165,14 +165,14 @@ struct gsi {
 /**
  * gsi_setup() - Set up the GSI subsystem
  * @gsi:	Address of GSI structure embedded in an IPA structure
- * @db_enable:	Whether to use the GSI doorbell engine
+ * @legacy:	Set up for legacy hardware
  *
  * @Return:	0 if successful, or a negative error code
  *
  * Performs initialization that must wait until the GSI hardware is
  * ready (including firmware loaded).
  */
-int gsi_setup(struct gsi *gsi, bool db_enable);
+int gsi_setup(struct gsi *gsi, bool legacy);
 
 /**
  * gsi_teardown() - Tear down GSI subsystem
@@ -220,15 +220,15 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
  * gsi_channel_reset() - Reset an allocated GSI channel
  * @gsi:	GSI pointer
  * @channel_id:	Channel to be reset
- * @db_enable:	Whether doorbell engine should be enabled
+ * @legacy:	Legacy behavior
  *
- * Reset a channel and reconfigure it.  The @db_enable flag indicates
- * whether the doorbell engine will be enabled following reconfiguration.
+ * Reset a channel and reconfigure it.  The @legacy flag indicates
+ * that some steps should be done differently for legacy hardware.
  *
  * GSI hardware relinquishes ownership of all pending receive buffer
  * transactions and they will complete with their cancelled flag set.
  */
-void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool db_enable);
+void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool legacy);
 
 int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop);
 int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start);
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6de03be28784..db82ae48e402 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1136,7 +1136,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	bool endpoint_suspended = false;
 	struct gsi *gsi = &ipa->gsi;
 	dma_addr_t addr;
-	bool db_enable;
+	bool legacy;
 	u32 retries;
 	u32 len = 1;
 	void *virt;
@@ -1200,8 +1200,8 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	 * complete the channel reset sequence.  Finish by suspending the
 	 * channel again (if necessary).
 	 */
-	db_enable = ipa->version == IPA_VERSION_3_5_1;
-	gsi_channel_reset(gsi, endpoint->channel_id, db_enable);
+	legacy = ipa->version == IPA_VERSION_3_5_1;
+	gsi_channel_reset(gsi, endpoint->channel_id, legacy);
 
 	msleep(1);
 
@@ -1223,8 +1223,8 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 {
 	u32 channel_id = endpoint->channel_id;
 	struct ipa *ipa = endpoint->ipa;
-	bool db_enable;
 	bool special;
+	bool legacy;
 	int ret = 0;
 
 	/* On IPA v3.5.1, if an RX endpoint is reset while aggregation
@@ -1233,12 +1233,12 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	 *
 	 * IPA v3.5.1 enables the doorbell engine.  Newer versions do not.
 	 */
-	db_enable = ipa->version == IPA_VERSION_3_5_1;
+	legacy = ipa->version == IPA_VERSION_3_5_1;
 	special = !endpoint->toward_ipa && endpoint->data->aggregation;
 	if (special && ipa_endpoint_aggr_active(endpoint))
 		ret = ipa_endpoint_reset_rx_aggr(endpoint);
 	else
-		gsi_channel_reset(&ipa->gsi, channel_id, db_enable);
+		gsi_channel_reset(&ipa->gsi, channel_id, legacy);
 
 	if (ret)
 		dev_err(&ipa->pdev->dev,
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9295a9122e8e..e0b1fe3c34f9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -108,7 +108,7 @@ int ipa_setup(struct ipa *ipa)
 	struct ipa_endpoint *command_endpoint;
 	int ret;
 
-	/* IPA v4.0 and above don't use the doorbell engine. */
+	/* Setup for IPA v3.5.1 has some slight differences */
 	ret = gsi_setup(&ipa->gsi, ipa->version == IPA_VERSION_3_5_1);
 	if (ret)
 		return ret;
-- 
2.20.1

