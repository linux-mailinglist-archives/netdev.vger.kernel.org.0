Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41912C4942
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgKYUpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730411AbgKYUpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:45:35 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071EEC061A56
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:35 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id f5so3342074ilj.9
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t+pcUwa8+uX7Gms8sS8CjhzNwaiGwtdff9tVgXS26NI=;
        b=lD5Wynlj0fgifv8wbn4gAKihh4WsBz9SWasE+bkJ/M3WbDzE1YeIkEclAiC8JcYMIh
         PCCe+twNA3y3cqyo1Jkq4IDjewzTKMh3gXK6fVkPq9cH6bM2DqP0oi/Jvukcuyzxl3lF
         3PneiEIib0I9+lcTCPqN/KajmlAsuDVZ3b8Fd1uERKGxZ3YqVL0T1iU1ZucitNcoYSJ9
         knIQjyUvB4O8k0qZ3hPqHgF1q++uhBVVG0q6z0AdotS8xNcz2tu7BPj7FKZdIzF2Phij
         GVsVDh7X5QMDqDR8+XDt6Mm+OW1AvqLNMeJa5lnCQRlzUYas19RQNzfup/tG29n5dKho
         ZXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t+pcUwa8+uX7Gms8sS8CjhzNwaiGwtdff9tVgXS26NI=;
        b=lfu3X0A7xlmoO9AODgnw11nANJVG8sxEdRR9G9D146BmFPIRwatyE5EkS2xmoKOWet
         yzecqXg834o9kfkcMx0btecR9S/SN1Hz+fEK6I/v2EABPLGvEzwRc7zrJH41UK6xfRpL
         D7Fx9Zp0jChXGnpoP8K5yQ2jAoSJdAmjYDqukjsUaDtSWOawcxQZNpNWdPg1DBH/g+ru
         yKRpui8n/Q21OZSsW8vbpjHCRLdTsCOP6nUmZQLwsEBF1srMILI5eNudNYpagpaE33rz
         xDprmOX+egrqganEFwr8si9o+LDJ0N3v0UcOCOnn/33OlT1tJuMZKXzzGWduvKhA+7eJ
         DRow==
X-Gm-Message-State: AOAM531lTp151/m/Strodw0BEvesMrdfTW6w7KAKnHEir9NJ5EYUDvw9
        L9J4KAR+EM5/Hk8czyrVt8onhg==
X-Google-Smtp-Source: ABdhPJxh/HY/b3nwQzS4NMKwmXzP4GY9lzohhMx8DY+H0i0AXRMGq6vKNJ9ynIwnDbVVYFgMr6CyhQ==
X-Received: by 2002:a92:aa04:: with SMTP id j4mr4432219ili.218.1606337134392;
        Wed, 25 Nov 2020 12:45:34 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm1462225iom.36.2020.11.25.12.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:45:33 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: update gsi registers for IPA v4.5
Date:   Wed, 25 Nov 2020 14:45:21 -0600
Message-Id: <20201125204522.5884-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125204522.5884-1-elder@linaro.org>
References: <20201125204522.5884-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Very few GSI register definitions change for IPA v4.5, however
as a group their position in memory shifts a constant amount
(handled by the next commit).

Add definitions and update comments to the set of GSI registers to
support changes that come with IPA v4.5.

Update the logic in gsi_channel_program() to accommodate the new
(expanded) PREFETCH_MODE field in the CH_C_QOS register.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 10 ++++++++--
 drivers/net/ipa/gsi_reg.h | 13 +++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2cf10c9f0143d..67e9eb8fe3293 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -784,8 +784,14 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	/* v4.0 introduces an escape buffer for prefetch.  We use it
 	 * on all but the AP command channel.
 	 */
-	if (gsi->version != IPA_VERSION_3_5_1 && !channel->command)
-		val |= USE_ESCAPE_BUF_ONLY_FMASK;
+	if (gsi->version != IPA_VERSION_3_5_1 && !channel->command) {
+		/* If not otherwise set, prefetch buffers are used */
+		if (gsi->version < IPA_VERSION_4_5)
+			val |= USE_ESCAPE_BUF_ONLY_FMASK;
+		else
+			val |= u32_encode_bits(GSI_ESCAPE_BUF_ONLY,
+					       PREFETCH_MODE_FMASK);
+	}
 
 	iowrite32(val, gsi->virt + GSI_CH_C_QOS_OFFSET(channel_id));
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index c1799d1e8a837..2aea17f8f5c4e 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -105,6 +105,16 @@ enum gsi_channel_type {
 #define USE_DB_ENG_FMASK		GENMASK(9, 9)
 /* The next field is only present for IPA v4.0, v4.1, and v4.2 */
 #define USE_ESCAPE_BUF_ONLY_FMASK	GENMASK(10, 10)
+/* The next two fields are present for IPA v4.5 and above */
+#define PREFETCH_MODE_FMASK		GENMASK(13, 10)
+#define EMPTY_LVL_THRSHOLD_FMASK	GENMASK(23, 16)
+/** enum gsi_prefetch_mode - PREFETCH_MODE field in CH_C_QOS */
+enum gsi_prefetch_mode {
+	GSI_USE_PREFETCH_BUFS			= 0x0,
+	GSI_ESCAPE_BUF_ONLY			= 0x1,
+	GSI_SMART_PREFETCH			= 0x2,
+	GSI_FREE_PREFETCH			= 0x3,
+};
 
 #define GSI_CH_C_SCRATCH_0_OFFSET(ch) \
 		GSI_EE_N_CH_C_SCRATCH_0_OFFSET((ch), GSI_EE_AP)
@@ -287,6 +297,9 @@ enum gsi_iram_size {
 /* The next two values are available for IPA v4.0 and above */
 	IRAM_SIZE_TWO_N_HALF_KB			= 0x2,
 	IRAM_SIZE_THREE_KB			= 0x3,
+	/* The next two values are available for IPA v4.5 and above */
+	IRAM_SIZE_THREE_N_HALF_KB		= 0x4,
+	IRAM_SIZE_FOUR_KB			= 0x5,
 };
 
 /* IRQ condition for each type is cleared by writing type-specific register */
-- 
2.20.1

