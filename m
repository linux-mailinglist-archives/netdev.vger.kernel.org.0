Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397582C4945
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgKYUph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730411AbgKYUpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:45:36 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E13AC061A54
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:36 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id p5so1869329iln.8
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/upjsjCvyzOg9GBdsHQFUu14Ofl+KQlS4nrUSr/KaPg=;
        b=E+i7WsXm6Y7oURsktvENeeZaTN4Ztia3P6CWNkL6EakTOis82LfETd3aOphBHLPmRR
         gIMAp8PRpCVrxxZi7WRQPeFdx7CDAbyAoNdMnh1ZwIIohok0OVh4q7Ugq0ROJVDvxaBG
         fn4mhBGs8rMaHey2HCywjLks6IvJvvBsbEeJ7PbJav7B069LvoBeQtguiHa4w+h0vUcf
         rwM7EXQV8+PsIJiB/4vNVZTaazetpsUaVrVkkOBDvIftp5qWF210KuUpTcAgy0UkgI2y
         ElHoNreosnqIhFsh0k+lU71O22011xUm6YaBDkrF89Zu/Gxkb0M9S3P0Ppo0TkZzER8j
         RaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/upjsjCvyzOg9GBdsHQFUu14Ofl+KQlS4nrUSr/KaPg=;
        b=eSESJiUK84RlHyilYl5+/svLjIJYLHKdNsegZr6/znUgG5A9tIF6OyzzYn+hh7tVHy
         Ro+D/2kdqHlhT6tRYSqEyPidne/nTQQfN6MPaCIxyT9uG0RbqPtBJY4o226kk48dCWrR
         Hm8tRJ0xQm7qzavSAzsgePtr3NFaZw/pu4U0ObRGqKSOqk2ed/KoRhmIr+E+Hsmg6aKK
         529sZ5ed7HQ0aMUfQDEHk3RgZw3wDGkb0/Os87fOtURwrbHHd55aCFooSLudo58RmjST
         TkDTt+pARDhecVQq75V8jMkxtKgSWAMVEY0UuHcJYTXSfNXOhfl3i5oehk2msvDguJQ2
         5eAQ==
X-Gm-Message-State: AOAM531cNcQkK74jrjIKHNrC8TqhyII+yLiRO7WROpdR1K787lb7SZRD
        k7ycKkoOzOMi+daLNV7pdCVoKSjQT82KAQ==
X-Google-Smtp-Source: ABdhPJwJiAwYxtZqgooyC9k8yliQumd46KdUHgTeWyOp+1jwNlcFoW1rvj5AzQfW+8vUi6e6tjr1ZQ==
X-Received: by 2002:a92:cc90:: with SMTP id x16mr1650255ilo.153.1606337135398;
        Wed, 25 Nov 2020 12:45:35 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm1462225iom.36.2020.11.25.12.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:45:34 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: adjust GSI register addresses
Date:   Wed, 25 Nov 2020 14:45:22 -0600
Message-Id: <20201125204522.5884-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125204522.5884-1-elder@linaro.org>
References: <20201125204522.5884-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offsets for almost all GSI registers we use have different
offsets starting at IPA version 4.5.  Only two registers remain
in their original location.

In a way though, the new register locations are not *that*
different.  The entire group of affected registers has simply
been shifted down in memory by a fixed amount (0xd000).  So for
example, the channel context 0 register that has a base offset of
0x0001c000 for "older" hardware now has a base offset of 0x0000f000.

This patch aims to add support for IPA v4.5 registers at their new
offets in a way that minimizes the amount of code that needs to
change.  It is not ideal, but it avoids the need to maintain
a nearly complete set of additional register offset definitions.

The approach takes advantage of the fact that when accessing GSI
registers we do not access any of memory at lower end of the "gsi"
memory range (with two exceptions already noted).  In particular,
we do not access anything within the bottom 0xd000 bytes of the
GSI memory range.

For IPA version 4.5, after we map the GSI memory, we adjust the
virtual memory pointer downward by the fixed amount (0xd000).
That way, register accesses using the offsets defined by the
existing GSI_REG_*() macros will resolve to the proper locations
for IPA version 4.5.

The two registers *not* affected by this offset are accessed only
in gsi_irq_setup().  There, for IPA version 4.5, we undo the general
register adjustment by adding the fixed amount back to the virtual
address to access these registers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 21 +++++++++++++++++++--
 drivers/net/ipa/gsi_reg.h | 11 +++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 67e9eb8fe3293..c4795249719d4 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -195,6 +195,8 @@ static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 /* Turn off all GSI interrupts initially */
 static void gsi_irq_setup(struct gsi *gsi)
 {
+	u32 adjust;
+
 	/* Disable all interrupt types */
 	gsi_irq_type_update(gsi, 0);
 
@@ -203,8 +205,12 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
-	iowrite32(0, gsi->virt + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+
+	/* Reverse the offset adjustment for inter-EE register offsets */
+	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
+	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
 
@@ -2089,6 +2095,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	resource_size_t size;
+	u32 adjust;
 	int ret;
 
 	gsi_validate_build();
@@ -2115,11 +2122,21 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 		return -EINVAL;
 	}
 
+	/* Make sure we can make our pointer adjustment if necessary */
+	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
+	if (res->start < adjust) {
+		dev_err(dev, "DT memory resource \"gsi\" too low (< %u)\n",
+			adjust);
+		return -EINVAL;
+	}
+
 	gsi->virt = ioremap(res->start, size);
 	if (!gsi->virt) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		return -ENOMEM;
 	}
+	/* Adjust register range pointer downward for newer IPA versions */
+	gsi->virt -= adjust;
 
 	init_completion(&gsi->completion);
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 2aea17f8f5c4e..0e138bbd82053 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -38,6 +38,17 @@
  * (though the actual limit is hardware-dependent).
  */
 
+/* GSI EE registers as a group are shifted downward by a fixed
+ * constant amount for IPA versions 4.5 and beyond.  This applies
+ * to all GSI registers we use *except* the ones that disable
+ * inter-EE interrupts for channels and event channels.
+ *
+ * We handle this by adjusting the pointer to the mapped GSI memory
+ * region downward.  Then in the one place we use them (gsi_irq_setup())
+ * we undo that adjustment for the inter-EE interrupt registers.
+ */
+#define GSI_EE_REG_ADJUST			0x0000d000	/* IPA v4.5+ */
+
 #define GSI_INTER_EE_SRC_CH_IRQ_OFFSET \
 			GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
 #define GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(ee) \
-- 
2.20.1

