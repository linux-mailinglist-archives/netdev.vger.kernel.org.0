Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FBA698505
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBOTyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBOTyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:54:04 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A492F3588
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:53:59 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id l128so7573172iof.2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JkFe6uhk5ONIFKOjCNIRbQcHGkvQiSGhIiuc4gXX3aI=;
        b=pDO9ZJlYzKICmrvTZajRUBxqUwY+6g0fd1N5olNvj54UeDb1SXNYaR4WjEBy/J3tCI
         f53AyIHwN7cqZs1HdkR9o8/rnzLGMGBwMzG+jUMAOOUKyNQYNcl3wfyn/MSey/LTJ9yM
         VexnOU4mHrlD00+xXeVjsJQEoLxtadnXu3Rc8WqocO2t9l/abJ6gH7Jcv8YV7KvVOj6a
         oJ0c4Sx+o8xYnQV3NkDO3RhBmKFyyZKsK1Oy/Y7shvcuRg8qZmlThvUy1SJQ4aHj6alP
         dryGnCBle5bHGDOF+0NC+D11BMpxWrYfF7VudfDYsLZtpOxd/S8CfixYtKQAnHEAk4Ar
         wtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkFe6uhk5ONIFKOjCNIRbQcHGkvQiSGhIiuc4gXX3aI=;
        b=Z2pDA2civopKA01WXtOSLwzWguisR1DAK56QrhqoN6LmpjIBqi2+puFcOO6P33MgZr
         daTN4NtlmvmUxIRmTzYuQN+pLr7rYwVGLDKW464lteIoX1o1iKrA97ezHAFxw96LspL5
         0dPUs57NThV5FMGoFMIbL+wI6WCsQqZl5YUD1rLi8HTy7OxMUJG/koJSQUML7qSlBtCq
         C6W/EPfGJRnHeXcapuRBegww/Qhh/Qbxe2TOpdtrgJDcnrNihBDP846qPQHiwVtkxNH8
         3yIfmcXg8DnfeXkB5Slu0ETlKYVRnv8ayiaoOs6lEwRMmNpE9IxPPVdjHIGTa1huh6OV
         YUVQ==
X-Gm-Message-State: AO0yUKW4svew/v/q+7C6n/pGn9ivvbDusYUeseAZsfI0jyXoCN3jlW4m
        TYQeVAsm/3yb8wUv6wG0oalsUQ==
X-Google-Smtp-Source: AK7set9nu1OYd931TxWDPuVHbhAYLpb8q3ldejqRSGI0xkz5AXra4p0bZQp+bJo8aRNQFBjPj/Mhvg==
X-Received: by 2002:a05:6602:14ca:b0:71e:d132:d08f with SMTP id b10-20020a05660214ca00b0071ed132d08fmr326265iow.9.1676490838762;
        Wed, 15 Feb 2023 11:53:58 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n10-20020a5ed90a000000b0073a312aaae5sm6291847iop.36.2023.02.15.11.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:53:58 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
Date:   Wed, 15 Feb 2023 13:53:48 -0600
Message-Id: <20230215195352.755744-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215195352.755744-1-elder@linaro.org>
References: <20230215195352.755744-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting at IPA v4.5, almost all GSI registers had their offsets
changed by a fixed amount (shifted downward by 0xd000).  Rather than
defining offsets for all those registers dependent on version, an
adjustment was applied for most register accesses.  This was
implemented in commit cdeee49f3ef7f ("net: ipa: adjust GSI register
addresses").  It was later modified to be a bit more obvious about
the adjusment, in commit 571b1e7e58ad3 ("net: ipa: use a separate
pointer for adjusted GSI memory").

We now are able to define every GSI register with its own offset, so
there's no need to implement this special adjustment.

So get rid of the "virt_raw" pointer, and just maintain "virt" as
the (non-adjusted) base address of I/O mapped GSI register memory.

Redefine the offsets of all GSI registers (other than the INTER_EE
ones, which were not subject to the adjustment) for IPA v4.5+,
subtracting 0xd000 from their defined offsets instead.

Move the ERROR_LOG and ERROR_LOG_CLR definitions further down in the
register definition files so all registers are defined in order of
their offset.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                |   5 +-
 drivers/net/ipa/gsi.h                |   3 +-
 drivers/net/ipa/gsi_reg.c            |  35 ++-------
 drivers/net/ipa/gsi_reg.h            |   3 +-
 drivers/net/ipa/reg/gsi_reg-v3.1.c   |  14 ++--
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c |  14 ++--
 drivers/net/ipa/reg/gsi_reg-v4.0.c   |  14 ++--
 drivers/net/ipa/reg/gsi_reg-v4.11.c  | 110 +++++++++++++--------------
 drivers/net/ipa/reg/gsi_reg-v4.5.c   |  58 +++++++-------
 drivers/net/ipa/reg/gsi_reg-v4.9.c   |  66 ++++++++--------
 10 files changed, 141 insertions(+), 181 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 05ea2502201da..2ef5509e3c836 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1999,12 +1999,11 @@ static int gsi_irq_setup(struct gsi *gsi)
 
 	/* The inter-EE interrupts are not supported for IPA v3.0-v3.1 */
 	if (gsi->version > IPA_VERSION_3_1) {
-		/* These registers are in the non-adjusted address range */
 		reg = gsi_reg(gsi, INTER_EE_SRC_CH_IRQ_MSK);
-		iowrite32(0, gsi->virt_raw + reg_offset(reg));
+		iowrite32(0, gsi->virt + reg_offset(reg));
 
 		reg = gsi_reg(gsi, INTER_EE_SRC_EV_CH_IRQ_MSK);
-		iowrite32(0, gsi->virt_raw + reg_offset(reg));
+		iowrite32(0, gsi->virt + reg_offset(reg));
 	}
 
 	reg = gsi_reg(gsi, CNTXT_GSI_IRQ_EN);
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index bc5ff617341a7..50bc80cb167c3 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -140,8 +140,7 @@ struct gsi_evt_ring {
 struct gsi {
 	struct device *dev;		/* Same as IPA device */
 	enum ipa_version version;
-	void __iomem *virt_raw;		/* I/O mapped address range */
-	void __iomem *virt;		/* Adjusted for most registers */
+	void __iomem *virt;		/* I/O mapped registers */
 	const struct regs *regs;
 
 	u32 irq;
diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index 0bb70a7ef4e65..1412b67304c8e 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -9,20 +9,6 @@
 #include "reg.h"
 #include "gsi_reg.h"
 
-/* GSI EE registers as a group are shifted downward by a fixed constant amount
- * for IPA versions 4.5 and beyond.  This applies to all GSI registers we use
- * *except* the ones that disable inter-EE interrupts for channels and event
- * channels.
- *
- * The "raw" (not adjusted) GSI register range is mapped, and a pointer to
- * the mapped range is held in gsi->virt_raw.  The inter-EE interrupt
- * registers are accessed using that pointer.
- *
- * Most registers are accessed using gsi->virt, which is a copy of the "raw"
- * pointer, adjusted downward by the fixed amount.
- */
-#define GSI_EE_REG_ADJUST	0x0000d000			/* IPA v4.5+ */
-
 /* Is this register ID valid for the current GSI version? */
 static bool gsi_reg_id_valid(struct gsi *gsi, enum gsi_reg_id reg_id)
 {
@@ -121,13 +107,12 @@ static const struct regs *gsi_regs(struct gsi *gsi)
 	}
 }
 
-/* Sets gsi->virt_raw and gsi->virt, and I/O maps the "gsi" memory range */
+/* Sets gsi->virt and I/O maps the "gsi" memory range for registers */
 int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	resource_size_t size;
-	u32 adjust;
 
 	/* Get GSI memory range and map it */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
@@ -142,27 +127,17 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* Make sure we can make our pointer adjustment if necessary */
-	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
-	if (res->start < adjust) {
-		dev_err(dev, "DT memory resource \"gsi\" too low (< %u)\n",
-			adjust);
-		return -EINVAL;
-	}
-
 	gsi->regs = gsi_regs(gsi);
 	if (!gsi->regs) {
 		dev_err(dev, "unsupported IPA version %u (?)\n", gsi->version);
 		return -EINVAL;
 	}
 
-	gsi->virt_raw = ioremap(res->start, size);
-	if (!gsi->virt_raw) {
+	gsi->virt = ioremap(res->start, size);
+	if (!gsi->virt) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		return -ENOMEM;
 	}
-	/* Most registers are accessed using an adjusted register range */
-	gsi->virt = gsi->virt_raw - adjust;
 
 	return 0;
 }
@@ -170,7 +145,7 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
 /* Inverse of gsi_reg_init() */
 void gsi_reg_exit(struct gsi *gsi)
 {
+	iounmap(gsi->virt);
 	gsi->virt = NULL;
-	iounmap(gsi->virt_raw);
-	gsi->virt_raw = NULL;
+	gsi->regs = NULL;
 }
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 5eda4def7ac40..e85765002aa41 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -351,8 +351,7 @@ const struct reg *gsi_reg(struct gsi *gsi, enum gsi_reg_id reg_id);
  * @pdev:	GSI (IPA) platform device
  *
  * Initialize GSI registers, including looking up and I/O mapping
- * the "gsi" memory space.  This function sets gsi->virt_raw and
- * gsi->virt.
+ * the "gsi" memory space.
  */
 int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev);
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 651c8a7ed6116..8451d3f8e421e 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -8,16 +8,12 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
 REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
     0x0000c020 + 0x1000 * GSI_EE_AP);
 
 REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
     0x0000c024 + 0x1000 * GSI_EE_AP);
 
-/* All other register offsets are relative to gsi->virt */
-
 static const u32 reg_ch_c_cntxt_0_fmask[] = {
 	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
 	[CHTYPE_DIR]					= BIT(3),
@@ -66,10 +62,6 @@ static const u32 reg_error_log_fmask[] = {
 	[ERR_EE]					= GENMASK(31, 28),
 };
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
-
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
-
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
 	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
 
@@ -152,6 +144,7 @@ REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -159,6 +152,7 @@ REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -220,6 +214,10 @@ static const u32 reg_cntxt_intset_fmask[] = {
 
 REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
 
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
 						/* Bits 3-4 reserved */
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index 0b39f8374ec17..87e75cf425135 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -8,16 +8,12 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
 REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
     0x0000c020 + 0x1000 * GSI_EE_AP);
 
 REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
     0x0000c024 + 0x1000 * GSI_EE_AP);
 
-/* All other register offsets are relative to gsi->virt */
-
 static const u32 reg_ch_c_cntxt_0_fmask[] = {
 	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
 	[CHTYPE_DIR]					= BIT(3),
@@ -66,10 +62,6 @@ static const u32 reg_error_log_fmask[] = {
 	[ERR_EE]					= GENMASK(31, 28),
 };
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
-
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
-
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
 	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
 
@@ -152,6 +144,7 @@ REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -159,6 +152,7 @@ REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -231,6 +225,10 @@ static const u32 reg_cntxt_intset_fmask[] = {
 
 REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
 
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
 						/* Bits 3-4 reserved */
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.0.c b/drivers/net/ipa/reg/gsi_reg-v4.0.c
index 5a979ef4caad3..048832e185091 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.0.c
@@ -8,16 +8,12 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
 REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
     0x0000c020 + 0x1000 * GSI_EE_AP);
 
 REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
     0x0000c024 + 0x1000 * GSI_EE_AP);
 
-/* All other register offsets are relative to gsi->virt */
-
 static const u32 reg_ch_c_cntxt_0_fmask[] = {
 	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
 	[CHTYPE_DIR]					= BIT(3),
@@ -67,10 +63,6 @@ static const u32 reg_error_log_fmask[] = {
 	[ERR_EE]					= GENMASK(31, 28),
 };
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
-
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
-
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
 	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
 
@@ -153,6 +145,7 @@ REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -160,6 +153,7 @@ REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -236,6 +230,10 @@ static const u32 reg_cntxt_intset_fmask[] = {
 
 REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
 
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
 						/* Bits 3-4 reserved */
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.11.c b/drivers/net/ipa/reg/gsi_reg-v4.11.c
index d975973306598..ced762ca16f91 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.11.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.11.c
@@ -8,16 +8,12 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
 REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
     0x0000c020 + 0x1000 * GSI_EE_AP);
 
 REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
     0x0000c024 + 0x1000 * GSI_EE_AP);
 
-/* All other register offsets are relative to gsi->virt */
-
 static const u32 reg_ch_c_cntxt_0_fmask[] = {
 	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
 	[CHTYPE_DIR]					= BIT(3),
@@ -31,7 +27,7 @@ static const u32 reg_ch_c_cntxt_0_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
-		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x0000f000 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ch_c_cntxt_1_fmask[] = {
 	[CH_R_LENGTH]					= GENMASK(19, 0),
@@ -39,11 +35,11 @@ static const u32 reg_ch_c_cntxt_1_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
-		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x0000f004 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0000f008 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0000f00c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ch_c_qos_fmask[] = {
 	[WRR_WEIGHT]					= GENMASK(3, 0),
@@ -57,7 +53,7 @@ static const u32 reg_ch_c_qos_fmask[] = {
 						/* Bits 25-31 reserved */
 };
 
-REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0000f05c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_error_log_fmask[] = {
 	[ERR_ARG3]					= GENMASK(3, 0),
@@ -70,21 +66,17 @@ static const u32 reg_error_log_fmask[] = {
 	[ERR_EE]					= GENMASK(31, 28),
 };
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
-
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
-
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
-	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f060 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_1, ch_c_scratch_1,
-	   0x0001c064 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f064 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
-	   0x0001c068 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f068 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
-	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f06c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 	[EV_CHTYPE]					= GENMASK(3, 0),
@@ -97,19 +89,19 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
-	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
-	   0x0001d00c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001000c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
-	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010010 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
 	[EV_MODT]					= GENMASK(15, 0),
@@ -118,55 +110,57 @@ static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
-	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010024 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_10, ev_ch_e_cntxt_10,
-	   0x0001d028 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010028 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_11, ev_ch_e_cntxt_11,
-	   0x0001d02c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001002c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_12, ev_ch_e_cntxt_12,
-	   0x0001d030 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010030 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_13, ev_ch_e_cntxt_13,
-	   0x0001d034 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010034 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_SCRATCH_0, ev_ch_e_scratch_0,
-	   0x0001d048 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010048 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
-	   0x0001d04c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001004c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
-	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
+	   0x00011000 + 0x4000 * GSI_EE_AP, 0x08);
 
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
-	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
+	   0x00011100 + 0x4000 * GSI_EE_AP, 0x08);
 
 static const u32 reg_gsi_status_fmask[] = {
 	[ENABLED]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x00012000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
-REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x00012008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
-REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x00012010 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_generic_cmd_fmask[] = {
 	[GENERIC_OPCODE]				= GENMASK(4, 0),
@@ -176,7 +170,7 @@ static const u32 reg_generic_cmd_fmask[] = {
 	[GENERIC_PARAMS]				= GENMASK(31, 24),
 };
 
-REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x00012018 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_hw_param_2_fmask[] = {
 	[IRAM_SIZE]					= GENMASK(2, 0),
@@ -192,54 +186,58 @@ static const u32 reg_hw_param_2_fmask[] = {
 	[GSI_USE_INTER_EE]				= BIT(31),
 };
 
-REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x00012040 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x00012080 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x00012088 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x0001f090 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x00012090 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x0001f094 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x00012094 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_CH_IRQ_MSK, cntxt_src_ch_irq_msk,
-    0x0001f098 + 0x4000 * GSI_EE_AP);
+    0x00012098 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_EV_CH_IRQ_MSK, cntxt_src_ev_ch_irq_msk,
-    0x0001f09c + 0x4000 * GSI_EE_AP);
+    0x0001209c + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_CH_IRQ_CLR, cntxt_src_ch_irq_clr,
-    0x0001f0a0 + 0x4000 * GSI_EE_AP);
+    0x000120a0 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_EV_CH_IRQ_CLR, cntxt_src_ev_ch_irq_clr,
-    0x0001f0a4 + 0x4000 * GSI_EE_AP);
+    0x000120a4 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x0001f0b0 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x000120b0 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_IEOB_IRQ_MSK, cntxt_src_ieob_irq_msk,
-    0x0001f0b8 + 0x4000 * GSI_EE_AP);
+    0x000120b8 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_IEOB_IRQ_CLR, cntxt_src_ieob_irq_clr,
-    0x0001f0c0 + 0x4000 * GSI_EE_AP);
+    0x000120c0 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x0001f100 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x00012100 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x0001f108 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x00012108 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x0001f110 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x00012110 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x0001f118 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x00012118 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x00012120 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x00012128 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_cntxt_intset_fmask[] = {
 	[INTYPE]					= BIT(0)
 						/* Bits 1-31 reserved */
 };
 
-REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x00012180 + 0x4000 * GSI_EE_AP);
+
+REG_FIELDS(ERROR_LOG, error_log, 0x00012200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x00012210 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
@@ -248,7 +246,7 @@ static const u32 reg_cntxt_scratch_0_fmask[] = {
 						/* Bits 8-31 reserved */
 };
 
-REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x00012400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index 13c66b29840ee..1ede8276824d7 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -8,16 +8,12 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
 REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
     0x0000c020 + 0x1000 * GSI_EE_AP);
 
 REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
     0x0000c024 + 0x1000 * GSI_EE_AP);
 
-/* All other register offsets are relative to gsi->virt */
-
 static const u32 reg_ch_c_cntxt_0_fmask[] = {
 	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
 	[CHTYPE_DIR]					= BIT(3),
@@ -31,7 +27,7 @@ static const u32 reg_ch_c_cntxt_0_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
-		  0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x0000f000 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ch_c_cntxt_1_fmask[] = {
 	[CH_R_LENGTH]					= GENMASK(15, 0),
@@ -39,11 +35,11 @@ static const u32 reg_ch_c_cntxt_1_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
-		  0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x0000f004 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0000f008 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0000f00c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ch_c_qos_fmask[] = {
 	[WRR_WEIGHT]					= GENMASK(3, 0),
@@ -56,7 +52,7 @@ static const u32 reg_ch_c_qos_fmask[] = {
 						/* Bits 24-31 reserved */
 };
 
-REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
+REG_STRIDE_FIELDS(CH_C_QOS, ch_c_qos, 0x0000f05c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_error_log_fmask[] = {
 	[ERR_ARG3]					= GENMASK(3, 0),
@@ -69,21 +65,17 @@ static const u32 reg_error_log_fmask[] = {
 	[ERR_EE]					= GENMASK(31, 28),
 };
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
-
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
-
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
-	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f060 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_1, ch_c_scratch_1,
-	   0x0001c064 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f064 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
-	   0x0001c068 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f068 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
-	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0000f06c + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 	[EV_CHTYPE]					= GENMASK(3, 0),
@@ -96,19 +88,19 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
-	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010008 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
-	   0x0001d00c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001000c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
-	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010010 + 0x4000 * GSI_EE_AP, 0x80);
 
 static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
 	[EV_MODT]					= GENMASK(15, 0),
@@ -117,28 +109,28 @@ static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
 };
 
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+		  0x00010020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
-	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010024 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_10, ev_ch_e_cntxt_10,
-	   0x0001d028 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010028 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_11, ev_ch_e_cntxt_11,
-	   0x0001d02c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001002c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_12, ev_ch_e_cntxt_12,
-	   0x0001d030 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010030 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_13, ev_ch_e_cntxt_13,
-	   0x0001d034 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010034 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_SCRATCH_0, ev_ch_e_scratch_0,
-	   0x0001d048 + 0x4000 * GSI_EE_AP, 0x80);
+	   0x00010048 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
-	   0x0001d04c + 0x4000 * GSI_EE_AP, 0x80);
+	   0x0001004c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
@@ -155,6 +147,7 @@ REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -162,6 +155,7 @@ REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
@@ -239,6 +233,10 @@ static const u32 reg_cntxt_intset_fmask[] = {
 
 REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
 
+REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
 						/* Bits 3-4 reserved */
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index a7d5732b72e90..9374c89609d9a 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -8,16 +8,12 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
-/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
-
 REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
     0x0000c020 + 0x1000 * GSI_EE_AP);
 
 REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
     0x0000c024 + 0x1000 * GSI_EE_AP);
 
-/* All other register offsets are relative to gsi->virt */
-
 static const u32 reg_ch_c_cntxt_0_fmask[] = {
 	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
 	[CHTYPE_DIR]					= BIT(3),
@@ -70,10 +66,6 @@ static const u32 reg_error_log_fmask[] = {
 	[ERR_EE]					= GENMASK(31, 28),
 };
 
-REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
-
-REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
-
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
 	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
 
@@ -142,31 +134,33 @@ REG_STRIDE(EV_CH_E_SCRATCH_1, ev_ch_e_scratch_1,
 	   0x0001d04c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
-	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
+	   0x00011000 + 0x4000 * GSI_EE_AP, 0x08);
 
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
-	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
+	   0x00011100 + 0x4000 * GSI_EE_AP, 0x08);
 
 static const u32 reg_gsi_status_fmask[] = {
 	[ENABLED]					= BIT(0),
 						/* Bits 1-31 reserved */
 };
 
-REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GSI_STATUS, gsi_status, 0x00012000 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ch_cmd_fmask[] = {
 	[CH_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[CH_OPCODE]					= GENMASK(31, 24),
 };
 
-REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CH_CMD, ch_cmd, 0x00012008 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_ev_ch_cmd_fmask[] = {
 	[EV_CHID]					= GENMASK(7, 0),
+						/* Bits 8-23 reserved */
 	[EV_OPCODE]					= GENMASK(31, 24),
 };
 
-REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x00012010 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_generic_cmd_fmask[] = {
 	[GENERIC_OPCODE]				= GENMASK(4, 0),
@@ -175,7 +169,7 @@ static const u32 reg_generic_cmd_fmask[] = {
 						/* Bits 14-31 reserved */
 };
 
-REG_FIELDS(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(GENERIC_CMD, generic_cmd, 0x00012018 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_hw_param_2_fmask[] = {
 	[IRAM_SIZE]					= GENMASK(2, 0),
@@ -191,54 +185,58 @@ static const u32 reg_hw_param_2_fmask[] = {
 	[GSI_USE_INTER_EE]				= BIT(31),
 };
 
-REG_FIELDS(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(HW_PARAM_2, hw_param_2, 0x00012040 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x00012080 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x00012088 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x0001f090 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_CH_IRQ, cntxt_src_ch_irq, 0x00012090 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x0001f094 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_EV_CH_IRQ, cntxt_src_ev_ch_irq, 0x00012094 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_CH_IRQ_MSK, cntxt_src_ch_irq_msk,
-    0x0001f098 + 0x4000 * GSI_EE_AP);
+    0x00012098 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_EV_CH_IRQ_MSK, cntxt_src_ev_ch_irq_msk,
-    0x0001f09c + 0x4000 * GSI_EE_AP);
+    0x0001209c + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_CH_IRQ_CLR, cntxt_src_ch_irq_clr,
-    0x0001f0a0 + 0x4000 * GSI_EE_AP);
+    0x000120a0 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_EV_CH_IRQ_CLR, cntxt_src_ev_ch_irq_clr,
-    0x0001f0a4 + 0x4000 * GSI_EE_AP);
+    0x000120a4 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x0001f0b0 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_SRC_IEOB_IRQ, cntxt_src_ieob_irq, 0x000120b0 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_IEOB_IRQ_MSK, cntxt_src_ieob_irq_msk,
-    0x0001f0b8 + 0x4000 * GSI_EE_AP);
+    0x000120b8 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_SRC_IEOB_IRQ_CLR, cntxt_src_ieob_irq_clr,
-    0x0001f0c0 + 0x4000 * GSI_EE_AP);
+    0x000120c0 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x0001f100 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_STTS, cntxt_glob_irq_stts, 0x00012100 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x0001f108 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_EN, cntxt_glob_irq_en, 0x00012108 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x0001f110 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GLOB_IRQ_CLR, cntxt_glob_irq_clr, 0x00012110 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x0001f118 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_STTS, cntxt_gsi_irq_stts, 0x00012118 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x0001f120 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_EN, cntxt_gsi_irq_en, 0x00012120 + 0x4000 * GSI_EE_AP);
 
-REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x0001f128 + 0x4000 * GSI_EE_AP);
+REG(CNTXT_GSI_IRQ_CLR, cntxt_gsi_irq_clr, 0x00012128 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_cntxt_intset_fmask[] = {
 	[INTYPE]					= BIT(0)
 						/* Bits 1-31 reserved */
 };
 
-REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x0001f180 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_INTSET, cntxt_intset, 0x00012180 + 0x4000 * GSI_EE_AP);
+
+REG_FIELDS(ERROR_LOG, error_log, 0x00012200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x00012210 + 0x4000 * GSI_EE_AP);
 
 static const u32 reg_cntxt_scratch_0_fmask[] = {
 	[INTER_EE_RESULT]				= GENMASK(2, 0),
@@ -247,7 +245,7 @@ static const u32 reg_cntxt_scratch_0_fmask[] = {
 						/* Bits 8-31 reserved */
 };
 
-REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x0001f400 + 0x4000 * GSI_EE_AP);
+REG_FIELDS(CNTXT_SCRATCH_0, cntxt_scratch_0, 0x00012400 + 0x4000 * GSI_EE_AP);
 
 static const struct reg *reg_array[] = {
 	[INTER_EE_SRC_CH_IRQ_MSK]	= &reg_inter_ee_src_ch_irq_msk,
-- 
2.34.1

