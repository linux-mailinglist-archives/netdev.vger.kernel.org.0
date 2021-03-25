Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E68349469
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhCYOpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhCYOoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:44:44 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C87C0613D7
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:44 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t14so2335555ilu.3
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OFHh/4Y8jVjRnIawnWz7b8gv4SH3t1lm96OpuVgl/4=;
        b=PuV1HlY3XahD7LNYk44z+Qaad9JMABq/Cz5WDSu2U/4a2b/yDoyj0SzgKa6Vfn76bq
         ou25L/WSQStxOez/ZxJvfjAK5eS6iRH7IEaTWstOpH7uEc06ROjyl4NOZjAR7aqJXFTE
         pOSknENB6Ol0AmHyYjUF0LDOJpLcEqSGoYtH+kN4ja5lj4AC+O9MpuhzlKOScSLea56p
         nOQaoFfgAUarlkinXQeEGH56hYLh3UBwcXAMSuO7LPRCwvz5EqMJNHJDJdiaStcOXPRX
         F97L5Hki7DccgbHV17RR9DWNixGc2C9cl7bYEyVuHimM2jSfEtEhUD/SKNvYV/enMXI5
         lAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OFHh/4Y8jVjRnIawnWz7b8gv4SH3t1lm96OpuVgl/4=;
        b=UloKtQQMaCerHTfu4zZ2LDrGbOutOb1uNcJJ6da64rB8hjvvJq9Wb3M+BH6tJZjYKb
         i+CzpHFKvjXpyo2DlxS2ecIo7UN2ap+LpZqxDFNFNw+vOPiQIbnGgi0A1roPDb14vu8K
         GFD8Od7/nbrd51lO8uvXks+52g3ZnVxk6wGUEdgdm9JTMYwU4cGBuQxNxsUDrlwhM910
         Xy//QyPB0XHDEZeoHrHM5kL/XJOk8zPDB6VW5Hn7shUcGcwkDHhaZDrjx9d287lCQJcb
         fCsvM5eCleIfheehSVXw/xT5JzBMszArqXT2/BtisLU/0av0G9malML6Wcd93ZHwMRs3
         vPhg==
X-Gm-Message-State: AOAM530lNJ5sa2dygeTiMu0bMwS1qjJOAy/tz6NbbAGUWYhs4fkMnLp1
        Oqx3APDVXFr1eMjbYxcI4yiK/w==
X-Google-Smtp-Source: ABdhPJy09C/8ZjmnLd2mv1UEroJhBMtFCU1iprOlZBs+Wbgc+Y5Eu/3Mrw9Y9ElUYZBqmLUImwFAGw==
X-Received: by 2002:a92:6b0e:: with SMTP id g14mr7229430ilc.246.1616683483931;
        Thu, 25 Mar 2021 07:44:43 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x20sm2879196ilc.88.2021.03.25.07.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:44:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: support IPA interrupt addresses for IPA v4.7
Date:   Thu, 25 Mar 2021 09:44:34 -0500
Message-Id: <20210325144437.2707892-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210325144437.2707892-1-elder@linaro.org>
References: <20210325144437.2707892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with IPA v4.7, registers related to IPA interrupts are
located at a fixed offset 0x1000 above than the addresses used for
earlier versions.  Define and use functions to provide the offset to
use for these registers based on IPA version.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c |  54 +++++++++---
 drivers/net/ipa/ipa_reg.h       | 143 +++++++++++++++++++++++---------
 drivers/net/ipa/ipa_uc.c        |   5 +-
 3 files changed, 150 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 61dd7605bcb66..c46df0b7c4e50 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -54,12 +54,14 @@ static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 	bool uc_irq = ipa_interrupt_uc(interrupt, irq_id);
 	struct ipa *ipa = interrupt->ipa;
 	u32 mask = BIT(irq_id);
+	u32 offset;
 
 	/* For microcontroller interrupts, clear the interrupt right away,
 	 * "to avoid clearing unhandled interrupts."
 	 */
+	offset = ipa_reg_irq_clr_offset(ipa->version);
 	if (uc_irq)
-		iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+		iowrite32(mask, ipa->reg_virt + offset);
 
 	if (irq_id < IPA_IRQ_COUNT && interrupt->handler[irq_id])
 		interrupt->handler[irq_id](interrupt->ipa, irq_id);
@@ -69,7 +71,7 @@ static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
 	 * so defer clearing until after the handler has been called.
 	 */
 	if (!uc_irq)
-		iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+		iowrite32(mask, ipa->reg_virt + offset);
 }
 
 /* Process all IPA interrupt types that have been signaled */
@@ -77,13 +79,15 @@ static void ipa_interrupt_process_all(struct ipa_interrupt *interrupt)
 {
 	struct ipa *ipa = interrupt->ipa;
 	u32 enabled = interrupt->enabled;
+	u32 offset;
 	u32 mask;
 
 	/* The status register indicates which conditions are present,
 	 * including conditions whose interrupt is not enabled.  Handle
 	 * only the enabled ones.
 	 */
-	mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	offset = ipa_reg_irq_stts_offset(ipa->version);
+	mask = ioread32(ipa->reg_virt + offset);
 	while ((mask &= enabled)) {
 		do {
 			u32 irq_id = __ffs(mask);
@@ -92,7 +96,7 @@ static void ipa_interrupt_process_all(struct ipa_interrupt *interrupt)
 
 			ipa_interrupt_process(interrupt, irq_id);
 		} while (mask);
-		mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+		mask = ioread32(ipa->reg_virt + offset);
 	}
 }
 
@@ -115,14 +119,17 @@ static irqreturn_t ipa_isr(int irq, void *dev_id)
 {
 	struct ipa_interrupt *interrupt = dev_id;
 	struct ipa *ipa = interrupt->ipa;
+	u32 offset;
 	u32 mask;
 
-	mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	offset = ipa_reg_irq_stts_offset(ipa->version);
+	mask = ioread32(ipa->reg_virt + offset);
 	if (mask & interrupt->enabled)
 		return IRQ_WAKE_THREAD;
 
 	/* Nothing in the mask was supposed to cause an interrupt */
-	iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+	offset = ipa_reg_irq_clr_offset(ipa->version);
+	iowrite32(mask, ipa->reg_virt + offset);
 
 	dev_err(&ipa->pdev->dev, "%s: unexpected interrupt, mask 0x%08x\n",
 		__func__, mask);
@@ -136,15 +143,22 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 {
 	struct ipa *ipa = interrupt->ipa;
 	u32 mask = BIT(endpoint_id);
+	u32 offset;
 	u32 val;
 
 	/* assert(mask & ipa->available); */
-	val = ioread32(ipa->reg_virt + IPA_REG_IRQ_SUSPEND_EN_OFFSET);
+
+	/* IPA version 3.0 does not support TX_SUSPEND interrupt control */
+	if (ipa->version == IPA_VERSION_3_0)
+		return;
+
+	offset = ipa_reg_irq_suspend_en_offset(ipa->version);
+	val = ioread32(ipa->reg_virt + offset);
 	if (enable)
 		val |= mask;
 	else
 		val &= ~mask;
-	iowrite32(val, ipa->reg_virt + IPA_REG_IRQ_SUSPEND_EN_OFFSET);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Enable TX_SUSPEND for an endpoint */
@@ -165,10 +179,18 @@ ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt, u32 endpoint_id)
 void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 {
 	struct ipa *ipa = interrupt->ipa;
+	u32 offset;
 	u32 val;
 
-	val = ioread32(ipa->reg_virt + IPA_REG_IRQ_SUSPEND_INFO_OFFSET);
-	iowrite32(val, ipa->reg_virt + IPA_REG_IRQ_SUSPEND_CLR_OFFSET);
+	offset = ipa_reg_irq_suspend_info_offset(ipa->version);
+	val = ioread32(ipa->reg_virt + offset);
+
+	/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
+	if (ipa->version == IPA_VERSION_3_0)
+		return;
+
+	offset = ipa_reg_irq_suspend_clr_offset(ipa->version);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Simulate arrival of an IPA TX_SUSPEND interrupt */
@@ -182,13 +204,15 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 		       enum ipa_irq_id ipa_irq, ipa_irq_handler_t handler)
 {
 	struct ipa *ipa = interrupt->ipa;
+	u32 offset;
 
 	/* assert(ipa_irq < IPA_IRQ_COUNT); */
 	interrupt->handler[ipa_irq] = handler;
 
 	/* Update the IPA interrupt mask to enable it */
 	interrupt->enabled |= BIT(ipa_irq);
-	iowrite32(interrupt->enabled, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+	offset = ipa_reg_irq_en_offset(ipa->version);
+	iowrite32(interrupt->enabled, ipa->reg_virt + offset);
 }
 
 /* Remove the handler for an IPA interrupt type */
@@ -196,11 +220,13 @@ void
 ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 {
 	struct ipa *ipa = interrupt->ipa;
+	u32 offset;
 
 	/* assert(ipa_irq < IPA_IRQ_COUNT); */
 	/* Update the IPA interrupt mask to disable it */
 	interrupt->enabled &= ~BIT(ipa_irq);
-	iowrite32(interrupt->enabled, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+	offset = ipa_reg_irq_en_offset(ipa->version);
+	iowrite32(interrupt->enabled, ipa->reg_virt + offset);
 
 	interrupt->handler[ipa_irq] = NULL;
 }
@@ -211,6 +237,7 @@ struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	struct ipa_interrupt *interrupt;
 	unsigned int irq;
+	u32 offset;
 	int ret;
 
 	ret = platform_get_irq_byname(ipa->pdev, "ipa");
@@ -228,7 +255,8 @@ struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
 	interrupt->irq = irq;
 
 	/* Start with all IPA interrupts disabled */
-	iowrite32(0, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+	offset = ipa_reg_irq_en_offset(ipa->version);
+	iowrite32(0, ipa->reg_virt + offset);
 
 	ret = request_threaded_irq(irq, ipa_isr, ipa_isr_thread, IRQF_ONESHOT,
 				   "ipa", interrupt);
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 8a654ccda49eb..8820e08d2535e 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -717,20 +717,46 @@ enum ipa_seq_rep_type {
 #define ROUTER_HASH_MSK_METADATA_FMASK		GENMASK(22, 22)
 #define IPA_REG_ENDP_ROUTER_HASH_MSK_ALL	GENMASK(22, 16)
 
-#define IPA_REG_IRQ_STTS_OFFSET	\
-				IPA_REG_IRQ_STTS_EE_N_OFFSET(GSI_EE_AP)
-#define IPA_REG_IRQ_STTS_EE_N_OFFSET(ee) \
-					(0x00003008 + 0x1000 * (ee))
-
-#define IPA_REG_IRQ_EN_OFFSET \
-				IPA_REG_IRQ_EN_EE_N_OFFSET(GSI_EE_AP)
-#define IPA_REG_IRQ_EN_EE_N_OFFSET(ee) \
-					(0x0000300c + 0x1000 * (ee))
-
-#define IPA_REG_IRQ_CLR_OFFSET \
-				IPA_REG_IRQ_CLR_EE_N_OFFSET(GSI_EE_AP)
-#define IPA_REG_IRQ_CLR_EE_N_OFFSET(ee) \
-					(0x00003010 + 0x1000 * (ee))
+static inline u32 ipa_reg_irq_stts_ee_n_offset(enum ipa_version version,
+					       u32 ee)
+{
+	if (version < IPA_VERSION_4_9)
+		return 0x00003008 + 0x1000 * ee;
+
+	return 0x00004008 + 0x1000 * ee;
+}
+
+static inline u32 ipa_reg_irq_stts_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_stts_ee_n_offset(version, GSI_EE_AP);
+}
+
+static inline u32 ipa_reg_irq_en_ee_n_offset(enum ipa_version version, u32 ee)
+{
+	if (version < IPA_VERSION_4_9)
+		return 0x0000300c + 0x1000 * ee;
+
+	return 0x0000400c + 0x1000 * ee;
+}
+
+static inline u32 ipa_reg_irq_en_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_en_ee_n_offset(version, GSI_EE_AP);
+}
+
+static inline u32 ipa_reg_irq_clr_ee_n_offset(enum ipa_version version, u32 ee)
+{
+	if (version < IPA_VERSION_4_9)
+		return 0x00003010 + 0x1000 * ee;
+
+	return 0x00004010 + 0x1000 * ee;
+}
+
+static inline u32 ipa_reg_irq_clr_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_clr_ee_n_offset(version, GSI_EE_AP);
+}
+
 /**
  * enum ipa_irq_id - Bit positions representing type of IPA IRQ
  * @IPA_IRQ_UC_0:	Microcontroller event interrupt
@@ -806,32 +832,75 @@ enum ipa_irq_id {
 	IPA_IRQ_COUNT,				/* Last; not an id */
 };
 
-#define IPA_REG_IRQ_UC_OFFSET \
-				IPA_REG_IRQ_UC_EE_N_OFFSET(GSI_EE_AP)
-#define IPA_REG_IRQ_UC_EE_N_OFFSET(ee) \
-					(0x0000301c + 0x1000 * (ee))
+static inline u32 ipa_reg_irq_uc_ee_n_offset(enum ipa_version version, u32 ee)
+{
+	if (version < IPA_VERSION_4_9)
+		return 0x0000301c + 0x1000 * ee;
+
+	return 0x0000401c + 0x1000 * ee;
+}
+
+static inline u32 ipa_reg_irq_uc_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_uc_ee_n_offset(version, GSI_EE_AP);
+}
+
 #define UC_INTR_FMASK				GENMASK(0, 0)
 
 /* ipa->available defines the valid bits in the SUSPEND_INFO register */
-#define IPA_REG_IRQ_SUSPEND_INFO_OFFSET \
-				IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(GSI_EE_AP)
-/* This register is at (0x00003098 + 0x1000 * (ee)) for IPA v3.0 */
-#define IPA_REG_IRQ_SUSPEND_INFO_EE_N_OFFSET(ee) \
-					(0x00003030 + 0x1000 * (ee))
-
-/* ipa->available defines the valid bits in the IRQ_SUSPEND_EN register */
-/* This register is present for IPA v3.1+ */
-#define IPA_REG_IRQ_SUSPEND_EN_OFFSET \
-				IPA_REG_IRQ_SUSPEND_EN_EE_N_OFFSET(GSI_EE_AP)
-#define IPA_REG_IRQ_SUSPEND_EN_EE_N_OFFSET(ee) \
-					(0x00003034 + 0x1000 * (ee))
-
-/* ipa->available defines the valid bits in the IRQ_SUSPEND_CLR register */
-/* This register is present for IPA v3.1+ */
-#define IPA_REG_IRQ_SUSPEND_CLR_OFFSET \
-				IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(GSI_EE_AP)
-#define IPA_REG_IRQ_SUSPEND_CLR_EE_N_OFFSET(ee) \
-					(0x00003038 + 0x1000 * (ee))
+static inline u32
+ipa_reg_irq_suspend_info_ee_n_offset(enum ipa_version version, u32 ee)
+{
+	if (version == IPA_VERSION_3_0)
+		return 0x00003098 + 0x1000 * ee;
+
+	if (version < IPA_VERSION_4_9)
+		return 0x00003030 + 0x1000 * ee;
+
+	return 0x00004030 + 0x1000 * ee;
+}
+
+static inline u32
+ipa_reg_irq_suspend_info_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_suspend_info_ee_n_offset(version, GSI_EE_AP);
+}
+
+/* ipa->available defines the valid bits in the SUSPEND_EN register */
+static inline u32
+ipa_reg_irq_suspend_en_ee_n_offset(enum ipa_version version, u32 ee)
+{
+	/* assert(version != IPA_VERSION_3_0); */
+
+	if (version < IPA_VERSION_4_9)
+		return 0x00003034 + 0x1000 * ee;
+
+	return 0x00004034 + 0x1000 * ee;
+}
+
+static inline u32
+ipa_reg_irq_suspend_en_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_suspend_en_ee_n_offset(version, GSI_EE_AP);
+}
+
+/* ipa->available defines the valid bits in the SUSPEND_CLR register */
+static inline u32
+ipa_reg_irq_suspend_clr_ee_n_offset(enum ipa_version version, u32 ee)
+{
+	/* assert(version != IPA_VERSION_3_0); */
+
+	if (version < IPA_VERSION_4_9)
+		return 0x00003038 + 0x1000 * ee;
+
+	return 0x00004038 + 0x1000 * ee;
+}
+
+static inline u32
+ipa_reg_irq_suspend_clr_offset(enum ipa_version version)
+{
+	return ipa_reg_irq_suspend_clr_ee_n_offset(version, GSI_EE_AP);
+}
 
 int ipa_reg_init(struct ipa *ipa);
 void ipa_reg_exit(struct ipa *ipa);
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index dee58a6596d41..2756363e69385 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -192,6 +192,7 @@ void ipa_uc_teardown(struct ipa *ipa)
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
+	u32 offset;
 	u32 val;
 
 	/* Fill in the command data */
@@ -203,8 +204,8 @@ static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 
 	/* Use an interrupt to tell the microcontroller the command is ready */
 	val = u32_encode_bits(1, UC_INTR_FMASK);
-
-	iowrite32(val, ipa->reg_virt + IPA_REG_IRQ_UC_OFFSET);
+	offset = ipa_reg_irq_uc_offset(ipa->version);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 /* Tell the microcontroller the AP is shutting down */
-- 
2.27.0

