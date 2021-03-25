Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B1C349470
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhCYOpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCYOoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:44:46 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E452C06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:46 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e8so2165553iok.5
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3VirIXAeB4f2dKLDp5bud7M6HOni4dIzSo0fxk6H7CU=;
        b=nqOvhNX9a2LkkXBKc5COBPTYuoWAldwfGAnaxhkm5HmOzpKQ3c9iA/IYP7lRV+Orig
         HH+UROtYD42sf2uE3YVaSlD6gJ6T8FCnzXPCECbjziy9iUZYIiNEaiv3nhWzi139bGhh
         /gBokESO9iMIQ/+RBXZyVDlJQMzmgjFArvWYJ/PJUJm7WFM7+97ea35fniMA2hyvCRek
         Ze/ghPiVIExn4DYaIBE5BOlO/gcdEUqH+ilXd0HHqrvF790pTCYWss9y7URH5rZ/KtTZ
         foxYbfFf2NzdtCEv30tC5YUMt9aF1PegAqaPGwUpWYnV10Kedpv4MSfLP40u7NE+MSKQ
         MVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3VirIXAeB4f2dKLDp5bud7M6HOni4dIzSo0fxk6H7CU=;
        b=IIRejNKhHjJccqnNS01sd4zkuBMBuN+hphtKbJ77dUw6mhTYpj61nr0AaQDPqjlo3R
         qQrWOX/JdhKRIL0bOyUsPse7IMwINGFe97lLwi7AYf1va867f7GJnuuikPTkrUXyzs45
         mvoBR9biT80gBcR2bLzkXVcPPORMAp5XEBFheJGuFj5foZw7GsxKgxNJzaGn9tn5uC0Z
         GxDw3TCAP+4M3NfX99Lhk81CuUpFJFNh+/2bhpSjcUYsjnQKi/1fziNzRgtLsDMUMCfz
         o0fUe/JRn7WBQDpIJJXT2y7oS0mzLlOLWPKxM5fUyBwyGOE+vUyg5i4cooXj1hD7dCLQ
         mCfQ==
X-Gm-Message-State: AOAM532l+zgrVNIE1dzHnxnjF9L5RAgLf+vAcJ5AONOtO6z7AkZayglh
        Eu9F+cg6t3i8KFSgVOwVYkOb2w==
X-Google-Smtp-Source: ABdhPJwFjLGTDCmUi5S21jtVtNXh5iS5qNYJaue4P6ir4GSk6MpZ7Zyfljo6Xgh2DqieQzixmuBPmA==
X-Received: by 2002:a02:662b:: with SMTP id k43mr7676194jac.139.1616683485895;
        Thu, 25 Mar 2021 07:44:45 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x20sm2879196ilc.88.2021.03.25.07.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:44:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: update GSI ring size registers
Date:   Thu, 25 Mar 2021 09:44:36 -0500
Message-Id: <20210325144437.2707892-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210325144437.2707892-1-elder@linaro.org>
References: <20210325144437.2707892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each GSI channel has a CNTXT_1 register that encodes the size of its
ring buffer.  The size of the field that records that is increased
starting at IPA v4.9.  Replace the use of a fixed-size field mask
with a new inline function that encodes that size value.

Similarly, the size of GSI event rings can be larger starting with
IPA v4.9, so create a function to encode that as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  7 +++++--
 drivers/net/ipa/gsi_reg.h | 17 +++++++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 7f2a8fce5e0db..6f146288f9e41 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -701,7 +701,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, EV_ELEMENT_SIZE_FMASK);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_0_OFFSET(evt_ring_id));
 
-	val = u32_encode_bits(size, EV_R_LENGTH_FMASK);
+	val = ev_r_length_encoded(gsi->version, size);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_1_OFFSET(evt_ring_id));
 
 	/* The context 2 and 3 registers store the low-order and
@@ -808,7 +808,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, ELEMENT_SIZE_FMASK);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
 
-	val = u32_encode_bits(size, R_LENGTH_FMASK);
+	val = r_length_encoded(gsi->version, size);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_1_OFFSET(channel_id));
 
 	/* The context 2 and 3 registers store the low-order and
@@ -842,6 +842,9 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 			val |= u32_encode_bits(GSI_ESCAPE_BUF_ONLY,
 					       PREFETCH_MODE_FMASK);
 	}
+	/* All channels set DB_IN_BYTES */
+	if (gsi->version >= IPA_VERSION_4_9)
+		val |= DB_IN_BYTES;
 
 	iowrite32(val, gsi->virt + GSI_CH_C_QOS_OFFSET(channel_id));
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 6b53adbc667af..d964015a4409f 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -90,7 +90,14 @@ enum gsi_channel_type {
 		GSI_EE_N_CH_C_CNTXT_1_OFFSET((ch), GSI_EE_AP)
 #define GSI_EE_N_CH_C_CNTXT_1_OFFSET(ch, ee) \
 		(0x0001c004 + 0x4000 * (ee) + 0x80 * (ch))
-#define R_LENGTH_FMASK			GENMASK(15, 0)
+
+/* Encoded value for CH_C_CNTXT_1 register R_LENGTH field */
+static inline u32 r_length_encoded(enum ipa_version version, u32 length)
+{
+	if (version < IPA_VERSION_4_9)
+		return u32_encode_bits(length, GENMASK(15, 0));
+	return u32_encode_bits(length, GENMASK(19, 0));
+}
 
 #define GSI_CH_C_CNTXT_2_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_2_OFFSET((ch), GSI_EE_AP)
@@ -161,7 +168,13 @@ enum gsi_prefetch_mode {
 		GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET((ev), GSI_EE_AP)
 #define GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET(ev, ee) \
 		(0x0001d004 + 0x4000 * (ee) + 0x80 * (ev))
-#define EV_R_LENGTH_FMASK		GENMASK(15, 0)
+/* Encoded value for EV_CH_C_CNTXT_1 register EV_R_LENGTH field */
+static inline u32 ev_r_length_encoded(enum ipa_version version, u32 length)
+{
+	if (version < IPA_VERSION_4_9)
+		return u32_encode_bits(length, GENMASK(15, 0));
+	return u32_encode_bits(length, GENMASK(19, 0));
+}
 
 #define GSI_EV_CH_E_CNTXT_2_OFFSET(ev) \
 		GSI_EE_N_EV_CH_E_CNTXT_2_OFFSET((ev), GSI_EE_AP)
-- 
2.27.0

