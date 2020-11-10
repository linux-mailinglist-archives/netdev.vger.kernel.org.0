Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96322AE250
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 22:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgKJV7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJV73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:59:29 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55042C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:28 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id a20so6783ilk.13
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b313XIRgnpZCmOdeEodrztCA7bDGC/42qLhbfDW7tHo=;
        b=Qr/ZnD0ZeK5uM19V4NOxIJrkXo/LDd4FK2+klpq2/U5cV8OrVFwXdLToMRpffXgSS1
         pbUpz9eqWW5J+/Yre7yWBiwHt+oGD+8oloiRiUcwh7LAQmvOFEjMpiDa1npgV/O/0jjN
         cUfM4/zs0yPPjieBNvcwPTh4ppUOXO8TXUbK0GsmvmK/tvSzvHiga45AXEuY8PQYBKje
         0x8fwPcFuozNlMRXi+dbuYquaom0crzfz6uXO+HQcQn3Puu1qdxdOHQunsChtNC4SNHC
         L9mDN8S5wO4X2LND02zP01vChcH0GlCcTUTj+N+Z7ejMtd5gsNSOBS1KMwlol1XuROwJ
         ntwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b313XIRgnpZCmOdeEodrztCA7bDGC/42qLhbfDW7tHo=;
        b=X2JInbMM0bgu9jRX9WFaXPOp0MDyUMYRJd4IDsogNeUTOQ3AZxPQgSgLVii+Ht5PLC
         cc3get3cZkpfrvxFdZkD5H9NVKS2O9EOFo6elSZ3hZJjOiOc8tKbB7bnW4mxWIcoWXjn
         a0W4B2JF0040qG/GzfaQ89cJW4sOCNY/Jzz1pTdFCS6O/2BxxOaZfuME0m3L7180wUx8
         BMJunW0tGArKGk7snWUB+H39K6sYZZN61dTIfbTou1VkXgFDXLmGj3Onvw/O97in/Lg+
         +4QX+9cufVZipTB/91fu3gCOm1C203qGES78jbcciepmTZuvooCAxSdx1JYZNmyWRN9x
         TFpg==
X-Gm-Message-State: AOAM533ob49No9A2Y7K4mw5OEzTp/249gzruuVlVaLvI6/ie3tEd2PGL
        cjKSPwdOuNGDdXAeLaRc656wgA==
X-Google-Smtp-Source: ABdhPJyyCiIMA496UJJQQBgSG6WfC/UHqkQpJO7zFnbP1ot9FUs/I4i5YESJc4rpsae0vZV/lBPAqA==
X-Received: by 2002:a05:6e02:14ca:: with SMTP id o10mr15508751ilk.143.1605045567689;
        Tue, 10 Nov 2020 13:59:27 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d142sm102010iof.43.2020.11.10.13.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:59:27 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: define GSI interrupt types with enums
Date:   Tue, 10 Nov 2020 15:59:17 -0600
Message-Id: <20201110215922.23514-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201110215922.23514-1-elder@linaro.org>
References: <20201110215922.23514-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the GSI global interrupt types with an enumerated type whose
values are the bit positions representing the global interrupt types.

Similarly, define the GSI general interrupt types with an enumerated
type whose values are the bit positions of general interrupt types.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 20 ++++++++++----------
 drivers/net/ipa/gsi_reg.h | 25 +++++++++++++++----------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 961a11d4fb270..273529b69d39c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -305,7 +305,7 @@ static void gsi_irq_enable(struct gsi *gsi)
 	/* Global interrupts include hardware error reports.  Enable
 	 * that so we can at least report the error should it occur.
 	 */
-	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	iowrite32(BIT(ERROR_INT), gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | BIT(GSI_GLOB_EE));
 
 	/* General GSI interrupts are reported to all EEs; if they occur
@@ -313,9 +313,9 @@ static void gsi_irq_enable(struct gsi *gsi)
 	 * also exists, but we don't support that.  We want to be notified
 	 * of errors so we can report them, even if they can't be handled.
 	 */
-	val = BUS_ERROR_FMASK;
-	val |= CMD_FIFO_OVRFLOW_FMASK;
-	val |= MCS_STACK_OVRFLOW_FMASK;
+	val = BIT(BUS_ERROR);
+	val |= BIT(CMD_FIFO_OVRFLOW);
+	val |= BIT(MCS_STACK_OVRFLOW);
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap | BIT(GSI_GENERAL));
 }
@@ -1145,15 +1145,15 @@ static void gsi_isr_glob_ee(struct gsi *gsi)
 
 	val = ioread32(gsi->virt + GSI_CNTXT_GLOB_IRQ_STTS_OFFSET);
 
-	if (val & ERROR_INT_FMASK)
+	if (val & BIT(ERROR_INT))
 		gsi_isr_glob_err(gsi);
 
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_CLR_OFFSET);
 
-	val &= ~ERROR_INT_FMASK;
+	val &= ~BIT(ERROR_INT);
 
-	if (val & GP_INT1_FMASK) {
-		val ^= GP_INT1_FMASK;
+	if (val & BIT(GP_INT1)) {
+		val ^= BIT(GP_INT1);
 		gsi_isr_gp_int1(gsi);
 	}
 
@@ -1626,7 +1626,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	 * halt a modem channel) and only from this function.  So we
 	 * enable the GP_INT1 IRQ type here while we're expecting it.
 	 */
-	val = ERROR_INT_FMASK | GP_INT1_FMASK;
+	val = BIT(ERROR_INT) | BIT(GP_INT1);
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 
 	/* First zero the result code field */
@@ -1642,7 +1642,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	success = gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val, completion);
 
 	/* Disable the GP_INT1 IRQ type again */
-	iowrite32(ERROR_INT_FMASK, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	iowrite32(BIT(ERROR_INT), gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 
 	if (success)
 		return 0;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index c50464984c6e3..e69ebe4aaf884 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -254,6 +254,7 @@
 #define GSI_USE_RD_WR_ENG_FMASK		GENMASK(30, 30)
 #define GSI_USE_INTER_EE_FMASK		GENMASK(31, 31)
 
+/* IRQ condition for each type is cleared by writing type-specific register */
 #define GSI_CNTXT_TYPE_IRQ_OFFSET \
 			GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(ee) \
@@ -330,11 +331,13 @@ enum gsi_irq_type_id {
 			GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(ee) \
 			(0x0001f110 + 0x4000 * (ee))
-/* The masks below are used for the general IRQ STTS, EN, and CLR registers */
-#define ERROR_INT_FMASK			GENMASK(0, 0)
-#define GP_INT1_FMASK			GENMASK(1, 1)
-#define GP_INT2_FMASK			GENMASK(2, 2)
-#define GP_INT3_FMASK			GENMASK(3, 3)
+/* Values here are bit positions in the GLOB_IRQ_* registers */
+enum gsi_global_irq_id {
+	ERROR_INT				= 0x0,
+	GP_INT1					= 0x1,
+	GP_INT2					= 0x2,
+	GP_INT3					= 0x3,
+};
 
 #define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
 			GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(GSI_EE_AP)
@@ -348,11 +351,13 @@ enum gsi_irq_type_id {
 			GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(ee) \
 			(0x0001f128 + 0x4000 * (ee))
-/* The masks below are used for the general IRQ STTS, EN, and CLR registers */
-#define BREAK_POINT_FMASK		GENMASK(0, 0)
-#define BUS_ERROR_FMASK			GENMASK(1, 1)
-#define CMD_FIFO_OVRFLOW_FMASK		GENMASK(2, 2)
-#define MCS_STACK_OVRFLOW_FMASK		GENMASK(3, 3)
+/* Values here are bit positions in the (general) GSI_IRQ_* registers */
+enum gsi_general_id {
+	BREAK_POINT				= 0x0,
+	BUS_ERROR				= 0x1,
+	CMD_FIFO_OVRFLOW			= 0x2,
+	MCS_STACK_OVRFLOW			= 0x3,
+};
 
 #define GSI_CNTXT_INTSET_OFFSET \
 			GSI_EE_N_CNTXT_INTSET_OFFSET(GSI_EE_AP)
-- 
2.20.1

