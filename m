Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876D03F22F6
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhHSWUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhHSWUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:20:11 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964EFC061757
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:34 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id x5so7535043ill.3
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bOryrdzD3qCC5WFsDKYio83PoI6w7fQiXhMMT5rIdTM=;
        b=O0YMdz8y55fYcCHLECiTAc5PuhOOg1smSjJ4C/IMgLibk8+DTlgv/qnjwqIMJwEt2U
         tqk6W5GEigGoJT4CkFhkT5LYSJ+BVf1Tr0BL4rrgm5ifITnVN3fCsBjaFB9sKrC5AoHt
         q8diyS/jL4RvOUkB8n+UbRQhdOMpkBSqlOCXv1q90S3ZTpNlzuKvJnfDcCT5wpRGi+Kb
         bvVqXzMiXh3kkrwoNWxRGLhYgt0jWaxJURQrGJcDeoF2teljuElbjRdEdNZ5iq/PL3py
         FoicmVQMKyepjbg9qcSETcPgUnozLIkayQz9oLNo8Oq74ZjI3DLjFd9E3syL40hgKph4
         BY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bOryrdzD3qCC5WFsDKYio83PoI6w7fQiXhMMT5rIdTM=;
        b=XVqSqI2W0uDdjLPr/qDUmxhW3EbWJ1BGTW85etxeORB1GaszOBobGmOyl6+BN9Js8c
         aY4nFIqBQ51fpMcPZpmjBa0fZo06jX5qg61yyC9hnooK4WWTKRw+1ikydLvbYEmzGFmG
         qr2Mu4SvCWJYiNqF8gPTWLdhMi/WrJArMJ8aJlTB/CBrk02F2f2olowuMhRmmLOrFAl5
         wDFCbAcb9haA4bbzMXLmFJ04E1xt10Q09YJkn3hXNR2OBj/D8M0MPSOx1mZADNsCAOVd
         Paf/e5g31YWycFVGwc4B4BLejZAPU3wOIeCpMTf4mx4EuTK0dO/IKKUPaMFKP+ie6GAu
         QeXA==
X-Gm-Message-State: AOAM531DRuiY3j1G0kdOlSEKZSRgnlXQbKWc836YKoaZTuMmWkS+PzkV
        PZQI/Et31Riw21ZvA+4sqfO47A==
X-Google-Smtp-Source: ABdhPJzCUT2nFMM9/U4tP1sDyybeRJByki72pPXQJtcSi8ZIzGhKM+oIk2cobdLtv+69NdSRUedHBw==
X-Received: by 2002:a92:b112:: with SMTP id t18mr11377156ilh.36.1629411573983;
        Thu, 19 Aug 2021 15:19:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o15sm2245188ilo.73.2021.08.19.15.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:19:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: kill ipa_clock_get()
Date:   Thu, 19 Aug 2021 17:19:27 -0500
Message-Id: <20210819221927.3286267-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210819221927.3286267-1-elder@linaro.org>
References: <20210819221927.3286267-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only remaining user of the ipa_clock_{get,put}() interface is
ipa_isr_thread().  Replace calls to ipa_clock_get() there calling
pm_runtime_get_sync() instead.  And call pm_runtime_put() there
rather than ipa_clock_put().  Warn if we ever get an error.

With that, we can get rid of ipa_clock_get() and ipa_clock_put().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c     | 17 -----------------
 drivers/net/ipa/ipa_clock.h     | 24 ------------------------
 drivers/net/ipa/ipa_interrupt.c | 14 +++++++-------
 3 files changed, 7 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 8f25107c1f1e7..357be73a45834 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -266,23 +266,6 @@ static int ipa_runtime_idle(struct device *dev)
 	return -EAGAIN;
 }
 
-/* Get an IPA clock reference.  If the reference count is non-zero, it is
- * incremented and return is immediate.  Otherwise the IPA clock is
- * enabled.
- */
-int ipa_clock_get(struct ipa *ipa)
-{
-	return pm_runtime_get_sync(&ipa->pdev->dev);
-}
-
-/* Attempt to remove an IPA clock reference.  If this represents the
- * last reference, disable the IPA clock.
- */
-int ipa_clock_put(struct ipa *ipa)
-{
-	return pm_runtime_put(&ipa->pdev->dev);
-}
-
 static int ipa_suspend(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 5c53241336a1a..8c21a007c4375 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -52,28 +52,4 @@ struct ipa_clock *ipa_clock_init(struct device *dev,
  */
 void ipa_clock_exit(struct ipa_clock *clock);
 
-/**
- * ipa_clock_get() - Get an IPA clock reference
- * @ipa:	IPA pointer
- *
- * Return:	0 if clock started, 1 if clock already running, or a negative
- *		error code
- *
- * This call blocks if this is the first reference.  A reference is
- * taken even if an error occurs starting the IPA clock.
- */
-int ipa_clock_get(struct ipa *ipa);
-
-/**
- * ipa_clock_put() - Drop an IPA clock reference
- * @ipa:	IPA pointer
- *
- * Return:	0 if successful, or a negative error code
- *
- * This drops a clock reference.  If the last reference is being dropped,
- * the clock is stopped and RX endpoints are suspended.  This call will
- * not block unless the last reference is dropped.
- */
-int ipa_clock_put(struct ipa *ipa);
-
 #endif /* _IPA_CLOCK_H_ */
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 934c14e066a0a..3fecaadb4a37e 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -21,9 +21,9 @@
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include "ipa.h"
-#include "ipa_clock.h"
 #include "ipa_reg.h"
 #include "ipa_endpoint.h"
 #include "ipa_interrupt.h"
@@ -80,14 +80,16 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	struct ipa_interrupt *interrupt = dev_id;
 	struct ipa *ipa = interrupt->ipa;
 	u32 enabled = interrupt->enabled;
+	struct device *dev;
 	u32 pending;
 	u32 offset;
 	u32 mask;
 	int ret;
 
-	ret = ipa_clock_get(ipa);
+	dev = &ipa->pdev->dev;
+	ret = pm_runtime_get_sync(dev);
 	if (WARN_ON(ret < 0))
-		goto out_clock_put;
+		goto out_power_put;
 
 	/* The status register indicates which conditions are present,
 	 * including conditions whose interrupt is not enabled.  Handle
@@ -108,15 +110,13 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 
 	/* If any disabled interrupts are pending, clear them */
 	if (pending) {
-		struct device *dev = &ipa->pdev->dev;
-
 		dev_dbg(dev, "clearing disabled IPA interrupts 0x%08x\n",
 			pending);
 		offset = ipa_reg_irq_clr_offset(ipa->version);
 		iowrite32(pending, ipa->reg_virt + offset);
 	}
-out_clock_put:
-	(void)ipa_clock_put(ipa);
+out_power_put:
+	(void)pm_runtime_put(dev);
 
 	return IRQ_HANDLED;
 }
-- 
2.27.0

