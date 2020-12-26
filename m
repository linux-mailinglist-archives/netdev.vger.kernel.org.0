Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09842E2F34
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 22:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgLZVi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 16:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgLZViX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 16:38:23 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1B6C0613ED
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 13:37:43 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id 2so6406332ilg.9
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 13:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RKCfsVGa3InM/ueidbaTHb3IhiqFNjw9eRGba4OKyqE=;
        b=jnaYYcyV6rMMpn6Z7pMxzaSc62h0MO67PatEmPkDJLCA4occu9Weo7eJOOkZNFPmdY
         XUzcpTyNgaEm9qLxw8tHHTrHMNYI7Qriw4+480dBTRnvwrJF7P2TDcjZDd2yuy/mL87G
         +RfKwMGziXKSyTMDOHJ8nV8XDMwW6ucW9UUsuFCtpPll9Q4v+hsccZUVMNxtEGMKLx8Y
         A4hRJBQ5hJaqBaG8XwYQOsFmmgdfSgZ3rfGzbOelMUWdvQTeXwyan4He9GaEbMaWmIKT
         XM+iJMF9r0n0FYhQjiVYPDwhe8GG8qR2O8NBJSkgRF7K3eJ8y6Ithtk+npwLt8G5CLba
         RmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RKCfsVGa3InM/ueidbaTHb3IhiqFNjw9eRGba4OKyqE=;
        b=Jg12+HL/885f2B486lOG/XRVcgx/KXy5qhahEz0/eKvYYxn2SxTevqcNg7tZDaygvp
         dRjXNJv+tzwoXQlwvFCgIdR1miAwvV0lnLjI5wzbEhUAHdtwt+LOWhYbAzFNhuhYeTNB
         w4+0lQKhtybxkHStisgOkt/MDWWawtM6hdZ7uwrCvj8LrGFKx8PUYD1OWlP3+mWDub0r
         4S7YGISB2YLSbnqbTcgfUs5+IHT0OJ5YZNhmxjKSUyIupTrNxFdardFlCzPnILv1+v35
         hFohW9ZIGhXpFuSr+yxeuU7tvc8gjnH1zqhzySunVFGXGU6C/E4XNWcCqkY1jZalHZkC
         J76g==
X-Gm-Message-State: AOAM531f4y1SM5l/gqgyA5L62payuBCR32e3HxnLBOoRqAfS1WTc+aSK
        bLawz8OCDkR5coEd2EhYvSwyWA==
X-Google-Smtp-Source: ABdhPJyHdT5P1KFc+TL5fuJKr9QwoYNjJRND3Figj9Xz1FEnLfu3AAvID4RVB7m237rCXP1a+txESQ==
X-Received: by 2002:a05:6e02:e44:: with SMTP id l4mr38824035ilk.208.1609018662467;
        Sat, 26 Dec 2020 13:37:42 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u8sm30582763iom.22.2020.12.26.13.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 13:37:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net 1/2] net: ipa: don't return a value from gsi_channel_command()
Date:   Sat, 26 Dec 2020 15:37:36 -0600
Message-Id: <20201226213737.338928-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201226213737.338928-1-elder@linaro.org>
References: <20201226213737.338928-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callers of gsi_channel_command() no longer care whether the command
times out, and don't use what gsi_channel_command() returns.  Redefine
that function to have void return type.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 6ffddf3b3d182 ("net: ipa: use state to determine channel command success")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 579cc3e516775..e51a770578990 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -454,7 +454,7 @@ static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 }
 
 /* Issue a channel command and wait for it to complete */
-static int
+static void
 gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 {
 	struct completion *completion = &channel->completion;
@@ -489,12 +489,10 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 
 	if (success)
-		return 0;
+		return;
 
 	dev_err(dev, "GSI command %u for channel %u timed out, state %u\n",
 		opcode, channel_id, gsi_channel_state(channel));
-
-	return -ETIMEDOUT;
 }
 
 /* Allocate GSI channel in NOT_ALLOCATED state */
@@ -503,7 +501,6 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	struct device *dev = gsi->dev;
 	enum gsi_channel_state state;
-	int ret;
 
 	/* Get initial channel state */
 	state = gsi_channel_state(channel);
@@ -513,7 +510,7 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 		return -EINVAL;
 	}
 
-	ret = gsi_channel_command(channel, GSI_CH_ALLOCATE);
+	gsi_channel_command(channel, GSI_CH_ALLOCATE);
 
 	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
@@ -531,7 +528,6 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 {
 	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
-	int ret;
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED &&
@@ -541,7 +537,7 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 		return -EINVAL;
 	}
 
-	ret = gsi_channel_command(channel, GSI_CH_START);
+	gsi_channel_command(channel, GSI_CH_START);
 
 	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
@@ -559,7 +555,6 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 {
 	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
-	int ret;
 
 	state = gsi_channel_state(channel);
 
@@ -576,7 +571,7 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 		return -EINVAL;
 	}
 
-	ret = gsi_channel_command(channel, GSI_CH_STOP);
+	gsi_channel_command(channel, GSI_CH_STOP);
 
 	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
@@ -598,7 +593,6 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 {
 	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
-	int ret;
 
 	msleep(1);	/* A short delay is required before a RESET command */
 
@@ -612,7 +606,7 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 		return;
 	}
 
-	ret = gsi_channel_command(channel, GSI_CH_RESET);
+	gsi_channel_command(channel, GSI_CH_RESET);
 
 	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
@@ -627,7 +621,6 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	struct device *dev = gsi->dev;
 	enum gsi_channel_state state;
-	int ret;
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED) {
@@ -636,7 +629,7 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 		return;
 	}
 
-	ret = gsi_channel_command(channel, GSI_CH_DE_ALLOC);
+	gsi_channel_command(channel, GSI_CH_DE_ALLOC);
 
 	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
-- 
2.27.0

