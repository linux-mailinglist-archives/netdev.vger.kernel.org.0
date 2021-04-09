Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C93635A542
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhDISHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbhDISHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:07:45 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12881C061762
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 11:07:32 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id x12so2585239ilm.2
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 11:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sHzvGlbUFXBWwssGYe1pEFogW44sTlKM1YL3uj6aQc4=;
        b=XjGc3ald4VGom04aNWVGY4iCpi8QkGiJVvQuhe0xs/RapYnViYhgFuEEGdvZ6G8W64
         RXxQygFTdfoNmYeyReTZHBAoqsuZsRz4ccZao0OeWS0Fs/mowd873+Wz8Ag+gh7NNbXi
         0D3q9vM2caHs7WnH13OHP44OSKJVXlezVwo6oKmKAONaB3pc4j61PHz2RbDIfnezftgr
         GTqZSmESi+DFtXB+tT6GsaCtoaMh8SjQSFUmi8OvOqEB+iXydaj1opg1+HocYf1pn8jO
         ZyzSbcJ//c4WPY9/8RmGY/onx6afL5otiSa3QYvnXoUEU2PFBb2x9/jlKj0wSioTIu8p
         wkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sHzvGlbUFXBWwssGYe1pEFogW44sTlKM1YL3uj6aQc4=;
        b=iP0dc+Ey4cOlkb+Dtg2SVU2Pv2xfiqy8rp3Fg8+ws0rpdpCA0Odh4T5ZreZ2bGMbMe
         rluzOc+0MZkp7uZgdF3UWogbXlxqCXhtMNY2t/61Wu5INtb7yeOzByinCax67xYAW4GA
         sPX8h5RWpYc40HUgIpdwH9OtI4dw9hV+3fKkj2BrgGFNyhulYeZLfLrHvQgtBCfQQX7c
         PgeWgygLCbZnFcu32w/u3Z9mNqI1JfDAkbijUiXrRSfRAE98Z+X0TN7d+qJwZLLOR1LI
         MgOdiRAgr1UcyoW8pXAUnv+ZWhCQBi0JgNivGGFh5GEmFevmsniJmgVM/udwvzY5rNMC
         QgUQ==
X-Gm-Message-State: AOAM532EUo1eZch/P1vZgQxUHa5XThBne1ywRDU6pEaUKoFfbhQtpw43
        VbqwM1fqdEKZcW+hw9MTeQt/Cw==
X-Google-Smtp-Source: ABdhPJxbVWsm9LXsP3VfWbf142j+QDU6N/1d1P87Ld/sUbec1oUP2Y+IB6CQtRfhz7cKe5WXuO19yw==
X-Received: by 2002:a05:6e02:12ad:: with SMTP id f13mr12278147ilr.44.1617991651474;
        Fri, 09 Apr 2021 11:07:31 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g12sm1412786ile.71.2021.04.09.11.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:07:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: get rid of empty GSI functions
Date:   Fri,  9 Apr 2021 13:07:21 -0500
Message-Id: <20210409180722.1176868-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180722.1176868-1-elder@linaro.org>
References: <20210409180722.1176868-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are place holder functions in the GSI code that do nothing.
Remove these, knowing we can add something back in their place if
they're really needed someday.

Some of these are inverse functions (such as teardown to match setup).
Explicitly comment that there is no inverse in these cases.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 54 +++++--------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 1c835b3e1a437..9f06663cef263 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -198,7 +198,7 @@ static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap & ~BIT(type_id));
 }
 
-/* Turn off all GSI interrupts initially */
+/* Turn off all GSI interrupts initially; there is no gsi_irq_teardown() */
 static void gsi_irq_setup(struct gsi *gsi)
 {
 	/* Disable all interrupt types */
@@ -217,12 +217,6 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
 
-/* Turn off all GSI interrupts when we're all done */
-static void gsi_irq_teardown(struct gsi *gsi)
-{
-	/* Nothing to do */
-}
-
 /* Event ring commands are performed one at a time.  Their completion
  * is signaled by the event ring control GSI interrupt type, which is
  * only enabled when we issue an event ring command.  Only the event
@@ -786,7 +780,7 @@ static void gsi_channel_trans_quiesce(struct gsi_channel *channel)
 	}
 }
 
-/* Program a channel for use */
+/* Program a channel for use; there is no gsi_channel_deprogram() */
 static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 {
 	size_t size = channel->tre_ring.count * GSI_RING_ELEMENT_SIZE;
@@ -874,11 +868,6 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	/* All done! */
 }
 
-static void gsi_channel_deprogram(struct gsi_channel *channel)
-{
-	/* Nothing to do */
-}
-
 static int __gsi_channel_start(struct gsi_channel *channel, bool start)
 {
 	struct gsi *gsi = channel->gsi;
@@ -1623,18 +1612,6 @@ static u32 gsi_event_bitmap_init(u32 evt_ring_max)
 	return event_bitmap;
 }
 
-/* Setup function for event rings */
-static void gsi_evt_ring_setup(struct gsi *gsi)
-{
-	/* Nothing to do */
-}
-
-/* Inverse of gsi_evt_ring_setup() */
-static void gsi_evt_ring_teardown(struct gsi *gsi)
-{
-	/* Nothing to do */
-}
-
 /* Setup function for a single channel */
 static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
 {
@@ -1684,7 +1661,6 @@ static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
 
 	netif_napi_del(&channel->napi);
 
-	gsi_channel_deprogram(channel);
 	gsi_channel_de_alloc_command(gsi, channel_id);
 	gsi_evt_ring_reset_command(gsi, evt_ring_id);
 	gsi_evt_ring_de_alloc_command(gsi, evt_ring_id);
@@ -1759,7 +1735,6 @@ static int gsi_channel_setup(struct gsi *gsi)
 	u32 mask;
 	int ret;
 
-	gsi_evt_ring_setup(gsi);
 	gsi_irq_enable(gsi);
 
 	mutex_lock(&gsi->mutex);
@@ -1819,7 +1794,6 @@ static int gsi_channel_setup(struct gsi *gsi)
 	mutex_unlock(&gsi->mutex);
 
 	gsi_irq_disable(gsi);
-	gsi_evt_ring_teardown(gsi);
 
 	return ret;
 }
@@ -1848,7 +1822,6 @@ static void gsi_channel_teardown(struct gsi *gsi)
 	mutex_unlock(&gsi->mutex);
 
 	gsi_irq_disable(gsi);
-	gsi_evt_ring_teardown(gsi);
 }
 
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
@@ -1856,7 +1829,6 @@ int gsi_setup(struct gsi *gsi)
 {
 	struct device *dev = gsi->dev;
 	u32 val;
-	int ret;
 
 	/* Here is where we first touch the GSI hardware */
 	val = ioread32(gsi->virt + GSI_GSI_STATUS_OFFSET);
@@ -1865,7 +1837,7 @@ int gsi_setup(struct gsi *gsi)
 		return -EIO;
 	}
 
-	gsi_irq_setup(gsi);
+	gsi_irq_setup(gsi);		/* No matching teardown required */
 
 	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
 
@@ -1899,18 +1871,13 @@ int gsi_setup(struct gsi *gsi)
 	/* Writing 1 indicates IRQ interrupts; 0 would be MSI */
 	iowrite32(1, gsi->virt + GSI_CNTXT_INTSET_OFFSET);
 
-	ret = gsi_channel_setup(gsi);
-	if (ret)
-		gsi_irq_teardown(gsi);
-
-	return ret;
+	return gsi_channel_setup(gsi);
 }
 
 /* Inverse of gsi_setup() */
 void gsi_teardown(struct gsi *gsi)
 {
 	gsi_channel_teardown(gsi);
-	gsi_irq_teardown(gsi);
 }
 
 /* Initialize a channel's event ring */
@@ -1952,7 +1919,7 @@ static void gsi_channel_evt_ring_exit(struct gsi_channel *channel)
 	gsi_evt_ring_id_free(gsi, evt_ring_id);
 }
 
-/* Init function for event rings */
+/* Init function for event rings; there is no gsi_evt_ring_exit() */
 static void gsi_evt_ring_init(struct gsi *gsi)
 {
 	u32 evt_ring_id = 0;
@@ -1964,12 +1931,6 @@ static void gsi_evt_ring_init(struct gsi *gsi)
 	while (++evt_ring_id < GSI_EVT_RING_COUNT_MAX);
 }
 
-/* Inverse of gsi_evt_ring_init() */
-static void gsi_evt_ring_exit(struct gsi *gsi)
-{
-	/* Nothing to do */
-}
-
 static bool gsi_channel_data_valid(struct gsi *gsi,
 				   const struct ipa_gsi_endpoint_data *data)
 {
@@ -2114,7 +2075,7 @@ static int gsi_channel_init(struct gsi *gsi, u32 count,
 	/* IPA v4.2 requires the AP to allocate channels for the modem */
 	modem_alloc = gsi->version == IPA_VERSION_4_2;
 
-	gsi_evt_ring_init(gsi);
+	gsi_evt_ring_init(gsi);			/* No matching exit required */
 
 	/* The endpoint data array is indexed by endpoint name */
 	for (i = 0; i < count; i++) {
@@ -2148,7 +2109,6 @@ static int gsi_channel_init(struct gsi *gsi, u32 count,
 		}
 		gsi_channel_exit_one(&gsi->channel[data->channel_id]);
 	}
-	gsi_evt_ring_exit(gsi);
 
 	return ret;
 }
@@ -2162,8 +2122,6 @@ static void gsi_channel_exit(struct gsi *gsi)
 		gsi_channel_exit_one(&gsi->channel[channel_id]);
 	while (channel_id--);
 	gsi->modem_channel_bitmap = 0;
-
-	gsi_evt_ring_exit(gsi);
 }
 
 /* Init function for GSI.  GSI hardware does not need to be "ready" */
-- 
2.27.0

