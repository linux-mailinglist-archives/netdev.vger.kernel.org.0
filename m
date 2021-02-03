Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF49B30DE3F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhBCPd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhBCP3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:29:41 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC49C06178A
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:29:01 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f6so5467096ioz.5
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NnJicAfg3Ex9JmXfJakNzYykElqGIVAtmZeJOEX7nY8=;
        b=WeiQpgikcJrLCIIRrvoKT+fJ4jY6Z0RQYttsgwlaiWDhb9Nyi0QULctbbmad4xFQms
         iVWrDuSwV0HSSWcKHn9bfTEFAxLshr+xynfgxfupmdxLL5G5O6jK+cEufE94WUgzx9rg
         xyIiEXeJKPE8dgR15z4EeaCUwr/Ipo7tI3w3m2YKY63tMYEyNnOhQcqjAUIFnszB3aiB
         MT4bat6Z0dtRAwKlpIxY2EU6dOIFwrg3EWcLDcToJQ3AOo6zAQYp1pHyvF5xM5NLnyYi
         KOo4z5hk89tRTMoLFYcgH1CpQkSE+ryN+aQjlbgYruWhZLhl2E24IK26tLwLYxg1swyR
         Z1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NnJicAfg3Ex9JmXfJakNzYykElqGIVAtmZeJOEX7nY8=;
        b=BgxGNn8IZO1lW5GYNtynUpO++5k1+IDKwTgYNd+3Dz0os2/GIwZINKRz1LMOA8hHO4
         UVdhFiZMuQLqeUsnwKHbyWWKCEDFIJQboOaXPk5EsU+CnGKkReVdkVJbp6jIrl8b7ewg
         EiAz1G7rPZdbH6vpK2Wf8ogYfSke08ipxMG4KGovOkVO9pjsReuRVKwUuLXpnYfLVYfT
         OE1Fn4F27dTFEWeBA2BrNUM9S5eWdGA1fkiIrcvzTQVKI2fwlvOB/NogkifZv8W+elEO
         BIZNV+LsL//i1cNLwtIxbIaupzYhQjFwQxwPdccsQq4VlKwEfayigmr8O7SiXJmo2fO4
         2wXA==
X-Gm-Message-State: AOAM533nqcYyo0a/350R3jKZ+nm9luKjKPVb6+p99Ws9irGLwH8tmvoi
        vJkyx1TTP2do6s8K8AlYb6rWOw==
X-Google-Smtp-Source: ABdhPJxm53FTgLO21S9yKfhXG6tDBqLjkGfZmwQBRkGY0S8r9C6kgi+H2HUsNlpjCU6gj7ULasIA5w==
X-Received: by 2002:a05:6602:1243:: with SMTP id o3mr1622255iou.47.1612366141181;
        Wed, 03 Feb 2021 07:29:01 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a15sm1119774ilb.11.2021.02.03.07.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:29:00 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: ipa: restructure a few functions
Date:   Wed,  3 Feb 2021 09:28:49 -0600
Message-Id: <20210203152855.11866-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203152855.11866-1-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make __gsi_channel_start() and __gsi_channel_stop() more structurally
and semantically similar to each other:
  - Restructure __gsi_channel_start() to always return at the end of
    the function, similar to the way __gsi_channel_stop() does.
  - Move the mutex calls out of gsi_channel_stop_retry() and into
    __gsi_channel_stop().

Restructure gsi_channel_stop() to always return at the end of the
function, like gsi_channel_start() does.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 45 +++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 53640447bf123..2671b76ebcfe3 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -873,17 +873,17 @@ static void gsi_channel_deprogram(struct gsi_channel *channel)
 
 static int __gsi_channel_start(struct gsi_channel *channel, bool start)
 {
-	struct gsi *gsi = channel->gsi;
-	int ret;
+	int ret = 0;
 
-	if (!start)
-		return 0;
+	if (start) {
+		struct gsi *gsi = channel->gsi;
 
-	mutex_lock(&gsi->mutex);
+		mutex_lock(&gsi->mutex);
 
-	ret = gsi_channel_start_command(channel);
+		ret = gsi_channel_start_command(channel);
 
-	mutex_unlock(&gsi->mutex);
+		mutex_unlock(&gsi->mutex);
+	}
 
 	return ret;
 }
@@ -910,11 +910,8 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 static int gsi_channel_stop_retry(struct gsi_channel *channel)
 {
 	u32 retries = GSI_CHANNEL_STOP_RETRIES;
-	struct gsi *gsi = channel->gsi;
 	int ret;
 
-	mutex_lock(&gsi->mutex);
-
 	do {
 		ret = gsi_channel_stop_command(channel);
 		if (ret != -EAGAIN)
@@ -922,19 +919,26 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
 		usleep_range(3 * USEC_PER_MSEC, 5 * USEC_PER_MSEC);
 	} while (retries--);
 
-	mutex_unlock(&gsi->mutex);
-
 	return ret;
 }
 
 static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 {
-	int ret;
+	int ret = 0;
 
 	/* Wait for any underway transactions to complete before stopping. */
 	gsi_channel_trans_quiesce(channel);
 
-	ret = stop ? gsi_channel_stop_retry(channel) : 0;
+	if (stop) {
+		struct gsi *gsi = channel->gsi;
+
+		mutex_lock(&gsi->mutex);
+
+		ret = gsi_channel_stop_retry(channel);
+
+		mutex_unlock(&gsi->mutex);
+	}
+
 	/* Finally, ensure NAPI polling has finished. */
 	if (!ret)
 		napi_synchronize(&channel->napi);
@@ -948,15 +952,14 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
-	/* Only disable the completion interrupt if stop is successful */
 	ret = __gsi_channel_stop(channel, true);
-	if (ret)
-		return ret;
+	if (ret) {
+		/* Disable the completion interrupt and NAPI if successful */
+		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
+		napi_disable(&channel->napi);
+	}
 
-	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
-	napi_disable(&channel->napi);
-
-	return 0;
+	return ret;
 }
 
 /* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */
-- 
2.20.1

