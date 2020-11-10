Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C762AE24D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 22:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgKJV7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732054AbgKJV7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:59:35 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DADC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:34 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id x20so29262ilj.8
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wjZ1oTD8iKXhE2RbV6xdsXrZWc/uPcQH/bhvuWmn4Bs=;
        b=oN5mzZTtgvS6864ekD34d8yMOrLpTp5KEFSayYokBIZOT+tMm7BOK6S9F4hzazd9ES
         JfU6NBWOMhC6bSFi8zYWcBx2/9lKg6xV1DFq2Leju7quv9xfr+9hspgElAwe51Sz6taF
         LIhcsE8Xaj7IAoelycDkkQSUvwFKQuMwzAqVQNtQXfk4pwSmlD8naLUfxr/loOkdarhp
         9OuiKx3AspP24HOFAIyzxOsyzY7KkOe4MkbXLmbAIEAcPgm9VxTRGEABjgnKX79M7LqG
         G3uosXkTYV/PgX3Tr2RD92+IgiIxM7KVNC5tsk1PHBcFhHGpIZTw0D9riznC07wRC3Zg
         CAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjZ1oTD8iKXhE2RbV6xdsXrZWc/uPcQH/bhvuWmn4Bs=;
        b=Vf9Bfl9/imTdRdmRSf/6PM95SZ5K2QB2XV/VrA8kiV0JDcV8HXC8Mp1u2pxUQkAqoF
         z7NvnDPx4aYL8aHxRqmwAUTFIkUtjLwQNhm0zAMoDxm/fgMKt9Nq/SrVEcezwZEITN1O
         PJ5HnWxbXiAQ2tKnhXiuZEtxqc+GqidacXGLjPLRwxtwQxB3MBrz5HbIaXw0RvqTQDtG
         dp+hm5fcAEv8RN+8RltN3No+VtMQF/uf3HIZxBG2T4jxxbo9fNK9NCU6h7tT9kpLTMV6
         drmD2KAa3ayDwqPGmuRjwrkA8gNb7VAOPU2vFxm0qnVcYkdUAl7oUo2QzvFjDvtc3kDH
         wXEg==
X-Gm-Message-State: AOAM533Nq8inehs/WWE4z6hUjqTee4mxzDbxHD2Ty3jGXEo9i4PozZqs
        XI7Er29g4qbLNKH8ImtiCe8ewyhpEiki/bd8
X-Google-Smtp-Source: ABdhPJzmCfoLuVDhhhGt0vMwZhExO0r2p4oCvwsn9v0LISK8kimU1Q5wPGSZijJwA33ORMtmdoHQUQ==
X-Received: by 2002:a92:1801:: with SMTP id 1mr2951369ily.142.1605045573426;
        Tue, 10 Nov 2020 13:59:33 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d142sm102010iof.43.2020.11.10.13.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:59:32 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: use enumerated types for GSI field values
Date:   Tue, 10 Nov 2020 15:59:22 -0600
Message-Id: <20201110215922.23514-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201110215922.23514-1-elder@linaro.org>
References: <20201110215922.23514-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace constants defined with an "_FVAL" suffix with values defined
in enumerated types, to be consistent with other usage in the driver.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  2 +-
 drivers/net/ipa/gsi_reg.h | 26 +++++++++++++++++---------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index c6803231bf5db..efa40c6e8281e 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1077,7 +1077,7 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 
 	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
 	result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
-	if (result != GENERIC_EE_SUCCESS_FVAL)
+	if (result != GENERIC_EE_SUCCESS)
 		dev_err(gsi->dev, "global INT1 generic result %u\n", result);
 
 	complete(&gsi->completion);
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index de3d87d278a98..8e3a7ffd19479 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -263,11 +263,6 @@ enum gsi_generic_cmd_opcode {
 #define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
 			(0x0001f040 + 0x4000 * (ee))
 #define IRAM_SIZE_FMASK			GENMASK(2, 0)
-#define IRAM_SIZE_ONE_KB_FVAL			0
-#define IRAM_SIZE_TWO_KB_FVAL			1
-/* The next two values are available for IPA v4.0 and above */
-#define IRAM_SIZE_TWO_N_HALF_KB_FVAL		2
-#define IRAM_SIZE_THREE_KB_FVAL			3
 #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
 #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
 #define GSI_CH_PEND_TRANSLATE_FMASK	GENMASK(13, 13)
@@ -280,6 +275,14 @@ enum gsi_generic_cmd_opcode {
 /* Fields below are present for IPA v4.2 and above */
 #define GSI_USE_RD_WR_ENG_FMASK		GENMASK(30, 30)
 #define GSI_USE_INTER_EE_FMASK		GENMASK(31, 31)
+/** enum gsi_iram_size - IRAM_SIZE field values in HW_PARAM_2 */
+enum gsi_iram_size {
+	IRAM_SIZE_ONE_KB			= 0x0,
+	IRAM_SIZE_TWO_KB			= 0x1,
+/* The next two values are available for IPA v4.0 and above */
+	IRAM_SIZE_TWO_N_HALF_KB			= 0x2,
+	IRAM_SIZE_THREE_KB			= 0x3,
+};
 
 /* IRQ condition for each type is cleared by writing type-specific register */
 #define GSI_CNTXT_TYPE_IRQ_OFFSET \
@@ -432,10 +435,15 @@ enum gsi_err_type {
 			(0x0001f400 + 0x4000 * (ee))
 #define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
 #define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
-#define GENERIC_EE_SUCCESS_FVAL			1
-#define GENERIC_EE_INCORRECT_DIRECTION_FVAL	3
-#define GENERIC_EE_INCORRECT_CHANNEL_FVAL	5
-#define GENERIC_EE_NO_RESOURCES_FVAL		7
+enum gsi_generic_ee_result {
+	GENERIC_EE_SUCCESS			= 0x1,
+	GENERIC_EE_CHANNEL_NOT_RUNNING		= 0x2,
+	GENERIC_EE_INCORRECT_DIRECTION		= 0x3,
+	GENERIC_EE_INCORRECT_CHANNEL_TYPE	= 0x4,
+	GENERIC_EE_INCORRECT_CHANNEL		= 0x5,
+	GENERIC_EE_RETRY			= 0x6,
+	GENERIC_EE_NO_RESOURCES			= 0x7,
+};
 #define USB_MAX_PACKET_FMASK		GENMASK(15, 15)	/* 0: HS; 1: SS */
 #define MHI_BASE_CHANNEL_FMASK		GENMASK(31, 24)
 
-- 
2.20.1

