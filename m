Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F112A3259
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgKBRyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgKBRyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:54:13 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA71C061A49
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:54:13 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id q1so13731306ilt.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=inRx9H1T7vReO20GsdvOW3B0eTMy5lZmarlEkrdYr50=;
        b=fAfOp4nVEo3xVkTHEHOTWtOkAf0X5/1dOn765Jd2TuaVzfII00F6yDoN0tu+pZkRxe
         r5Wy7Bf4FCT3M5RW1Ay5JgLo3GPB0UQh6freZ6piHsjM6VzhUZZEAPwv4Y4V79KUJeJm
         gBXtgy8a7aZCIv2BclHSVA1WLlL1HN9Xf+9SUK1LkG86jOWuOyuyIU3WRh6NkEtImH6F
         80YZq0CgvHgQN2A/ly3KSJckHtgB0QYO7gqG4B8wRUnnu7PahnyiBwAihvuNSgyKyGsW
         HWsX7b9Z/Wkrii6Kdgh01tP7OGz7VFYsZvvNMXE9ArUUMYz9c2cbXVP05hRd4l58bU7n
         yKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=inRx9H1T7vReO20GsdvOW3B0eTMy5lZmarlEkrdYr50=;
        b=EVdzv9+ouxaDU38Qceu+GUh6ZdJfkSmM5QtJ2fS/pJ2A3WwQFSFal6AvfkOKXn9CH5
         h+n1q0cAk3FkxtKX2iAxB/iuU8SGqdS//DN+EX7+2/NqCMrXtR8ULlJDwVdmD6KBYgPE
         b/ayYWIkMCgaNpOEjMgEJ3Z16xD/1oUjqZNITmZg46YaUlcW2KjELmcsW9wn7P3qScAV
         V5AhAGJJZW9qr2yJYQUI4ggGd0LdVcXEAOZZOZ1kDCIwUHs/gz6QIPO1RNgPV0R2Pr9z
         HsXVXVaTljfDyx58WR+b/KN5gRLKlQ83c5B1leZ/IszpmBSpMm5WPeYkCQXEVTXVh5EQ
         1efw==
X-Gm-Message-State: AOAM532I4a9zDFSdMPJjZnW0cALd2mrlNGGWf+RFdwmNQ30bI13S+Eke
        fKdzZf/zNLii6x+OvfxP6CxGaw==
X-Google-Smtp-Source: ABdhPJxlqfjyCvupZu5ca/shuvsQHFM+go4CmXV+ncz93VpGJnnYv0ACfGdjy5ufzNZejH8mQDZ/4g==
X-Received: by 2002:a92:d9ca:: with SMTP id n10mr7772408ilq.21.1604339652805;
        Mon, 02 Nov 2020 09:54:12 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r4sm11089591ilj.43.2020.11.02.09.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:54:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: eliminate legacy arguments
Date:   Mon,  2 Nov 2020 11:54:00 -0600
Message-Id: <20201102175400.6282-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201102175400.6282-1-elder@linaro.org>
References: <20201102175400.6282-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We enable a channel doorbell engine only for IPA v3.5.1, and that is
now handled directly by gsi_channel_program().

When initially setting up a channel, we want that doorbell engine
enabled, and we can request that independent of the IPA version.

Doing that makes the "legacy" argument to gsi_channel_setup_one()
unnecessary.  And with that gone we can get rid of the "legacy"
argument to gsi_channel_setup(), and gsi_setup() as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c      | 13 ++++++-------
 drivers/net/ipa/gsi.h      |  3 +--
 drivers/net/ipa/ipa_main.c |  3 +--
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f22b5d2efaf9d..12a2001ee1e9c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1454,8 +1454,7 @@ static void gsi_evt_ring_teardown(struct gsi *gsi)
 }
 
 /* Setup function for a single channel */
-static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id,
-				 bool legacy)
+static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	u32 evt_ring_id = channel->evt_ring_id;
@@ -1474,7 +1473,7 @@ static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id,
 	if (ret)
 		goto err_evt_ring_de_alloc;
 
-	gsi_channel_program(channel, legacy);
+	gsi_channel_program(channel, true);
 
 	if (channel->toward_ipa)
 		netif_tx_napi_add(&gsi->dummy_dev, &channel->napi,
@@ -1551,7 +1550,7 @@ static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 }
 
 /* Setup function for channels */
-static int gsi_channel_setup(struct gsi *gsi, bool legacy)
+static int gsi_channel_setup(struct gsi *gsi)
 {
 	u32 channel_id = 0;
 	u32 mask;
@@ -1563,7 +1562,7 @@ static int gsi_channel_setup(struct gsi *gsi, bool legacy)
 	mutex_lock(&gsi->mutex);
 
 	do {
-		ret = gsi_channel_setup_one(gsi, channel_id, legacy);
+		ret = gsi_channel_setup_one(gsi, channel_id);
 		if (ret)
 			goto err_unwind;
 	} while (++channel_id < gsi->channel_count);
@@ -1649,7 +1648,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
 }
 
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
-int gsi_setup(struct gsi *gsi, bool legacy)
+int gsi_setup(struct gsi *gsi)
 {
 	struct device *dev = gsi->dev;
 	u32 val;
@@ -1693,7 +1692,7 @@ int gsi_setup(struct gsi *gsi, bool legacy)
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
 	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
 
-	return gsi_channel_setup(gsi, legacy);
+	return gsi_channel_setup(gsi);
 }
 
 /* Inverse of gsi_setup() */
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 36f876fb8f5ae..59ace83d404c4 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -166,14 +166,13 @@ struct gsi {
 /**
  * gsi_setup() - Set up the GSI subsystem
  * @gsi:	Address of GSI structure embedded in an IPA structure
- * @legacy:	Set up for legacy hardware
  *
  * Return:	0 if successful, or a negative error code
  *
  * Performs initialization that must wait until the GSI hardware is
  * ready (including firmware loaded).
  */
-int gsi_setup(struct gsi *gsi, bool legacy);
+int gsi_setup(struct gsi *gsi);
 
 /**
  * gsi_teardown() - Tear down GSI subsystem
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 0d3d1a5cf07c1..a580cab794b1c 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -111,8 +111,7 @@ int ipa_setup(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
-	/* Setup for IPA v3.5.1 has some slight differences */
-	ret = gsi_setup(&ipa->gsi, ipa->version == IPA_VERSION_3_5_1);
+	ret = gsi_setup(&ipa->gsi);
 	if (ret)
 		return ret;
 
-- 
2.20.1

