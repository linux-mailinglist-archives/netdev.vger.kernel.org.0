Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CA34946E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYOpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhCYOor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:44:47 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADC4C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:47 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k25so2164573iob.6
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TR+eOD1Sgv6krEGwGa1mtPA/u4GDIWcIjsff8kozm8o=;
        b=tDAQenlYVwlmpL4ZUJ9Y6cbL8CXxt0xiYcXnquAVRHvmZ3Oql6E/kn2Ug3JN84wT8y
         x50z523MBQsMJfockIMY1vBk41CsMpRKxWxqL33lxgiBEdtj/hof9GDYvPfyKhE1z8JU
         qFhkfVNicc607XTd5TALFsPzUaXPGTA74MgAMPLQjUnCRijPwIYoZXvwJSHHSmU/XIoJ
         tXVpy+/i32ADw3MJIAzuFOIkhSelAuFO0mvxgMZlQtrcxRSE3xphibL4bVQYtXUfphnQ
         lo/s73XXx8uYxs3xxxMdcRsFL3n4saz6ujARSn63sNWDy7MHUqedOM3oQSCoQVZOrH7s
         t0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TR+eOD1Sgv6krEGwGa1mtPA/u4GDIWcIjsff8kozm8o=;
        b=qbI0I+oj8khpqvcBXi4OXP9bRACdUnFOVanWjzRspIv9r0l54tJSwM/Mu8haWSLWGV
         wWheyvckK4RnENt4fA5jI4V5TaxM8sQHHvhh27qqJ9HOgPqbL1RdXqUnpVmpBoHj6SSH
         r4wnr69uHod3Carbutb0oxPCbt3SMNcAKSa5ntFuK5/acGrOEU9dLqpDnl4B3I0FeaOJ
         N3O1XAcCwn3YELuPM/d/3HbgDLAubxTOd+rFOizINH0uEzD5k0ZhYimfTu53ja75KYqr
         ayLm/wSnUuEXtnWFR4iGMkZfsHneUGk/3nt1moll6RNdnpzn0qWkuzkHajH1TqPsvVgZ
         MIpA==
X-Gm-Message-State: AOAM5302rTX6xVWuBqz1tDyD7xViO1AJ0z9RaV8s+VUWmKULOzSPJCPp
        HtnxbA/QbxWlkE2huSuJSJCmMg==
X-Google-Smtp-Source: ABdhPJxB4NBLU22knFnVy9dEq5OZxY9TaoUIKsxCD6RHYe8eXiaE2g25OfK5vNeUOPDp6fddTjwi0A==
X-Received: by 2002:a05:6602:2287:: with SMTP id d7mr6729223iod.42.1616683486761;
        Thu, 25 Mar 2021 07:44:46 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x20sm2879196ilc.88.2021.03.25.07.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:44:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: expand GSI channel types
Date:   Thu, 25 Mar 2021 09:44:37 -0500
Message-Id: <20210325144437.2707892-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210325144437.2707892-1-elder@linaro.org>
References: <20210325144437.2707892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.5 (GSI v2.5) supports a larger set of channel protocols, and
adds an additional field to hold the most-significant bits of the
protocol identifier on a channel.

Add an inline function that encodes the protocol (including the
extra bits for newer versions of IPA), and define some additional
protocols.  At this point we still use only GPI protocol.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  2 +-
 drivers/net/ipa/gsi_reg.h | 38 +++++++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 6f146288f9e41..585574af36ecd 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -801,7 +801,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	channel->tre_ring.index = 0;
 
 	/* We program all channels as GPI type/protocol */
-	val = u32_encode_bits(GSI_CHANNEL_TYPE_GPI, CHTYPE_PROTOCOL_FMASK);
+	val = chtype_protocol_encoded(gsi->version, GSI_CHANNEL_TYPE_GPI);
 	if (channel->toward_ipa)
 		val |= CHTYPE_DIR_FMASK;
 	val |= u32_encode_bits(channel->evt_ring_id, ERINDEX_FMASK);
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index d964015a4409f..b4ac0258d6e10 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -64,6 +64,21 @@
 			(0x0000c01c + 0x1000 * (ee))
 
 /* All other register offsets are relative to gsi->virt */
+
+/** enum gsi_channel_type - CHTYPE_PROTOCOL field values in CH_C_CNTXT_0 */
+enum gsi_channel_type {
+	GSI_CHANNEL_TYPE_MHI			= 0x0,
+	GSI_CHANNEL_TYPE_XHCI			= 0x1,
+	GSI_CHANNEL_TYPE_GPI			= 0x2,
+	GSI_CHANNEL_TYPE_XDCI			= 0x3,
+	GSI_CHANNEL_TYPE_WDI2			= 0x4,
+	GSI_CHANNEL_TYPE_GCI			= 0x5,
+	GSI_CHANNEL_TYPE_WDI3			= 0x6,
+	GSI_CHANNEL_TYPE_MHIP			= 0x7,
+	GSI_CHANNEL_TYPE_AQC			= 0x8,
+	GSI_CHANNEL_TYPE_11AD			= 0x9,
+};
+
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
 #define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
@@ -78,13 +93,22 @@
 #define CHSTATE_FMASK			GENMASK(23, 20)
 #define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
 
-/** enum gsi_channel_type - CHTYPE_PROTOCOL field values in CH_C_CNTXT_0 */
-enum gsi_channel_type {
-	GSI_CHANNEL_TYPE_MHI			= 0x0,
-	GSI_CHANNEL_TYPE_XHCI			= 0x1,
-	GSI_CHANNEL_TYPE_GPI			= 0x2,
-	GSI_CHANNEL_TYPE_XDCI			= 0x3,
-};
+/* Encoded value for CH_C_CNTXT_0 register channel protocol fields */
+static inline u32
+chtype_protocol_encoded(enum ipa_version version, enum gsi_channel_type type)
+{
+	u32 val;
+
+	val = u32_encode_bits(type, CHTYPE_PROTOCOL_FMASK);
+	if (version < IPA_VERSION_4_5)
+		return val;
+
+	/* Encode upper bit(s) as well */
+	type >>= hweight32(CHTYPE_PROTOCOL_FMASK);
+	val |= u32_encode_bits(type, CHTYPE_PROTOCOL_MSB_FMASK);
+
+	return val;
+}
 
 #define GSI_CH_C_CNTXT_1_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_1_OFFSET((ch), GSI_EE_AP)
-- 
2.27.0

