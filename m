Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216993E83AE
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhHJT14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbhHJT1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:27:35 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74879C0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:13 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i7so440086iow.1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MR4KCI2yYpZ9otoweP9rpmQowf+z82KBy/Idz2Qlj/0=;
        b=mefo2O63gy+ObFFjRU56/Lf4YYjX7qPvTBcZFAFkrC0V6Lg2lTrXRZFlioULpqQrhL
         TRJJ0/ksQUy11b+fvz8hzUmH0viq0CoTjXp/hbLUmvI/Ckf451vL0suUHJLbcA1bEJZC
         GIz+Er0hnAxKR1+HcBp/Sfm6mn/8RMR7PBanazy52m7yCw2aDW4rnGkMzTm6Da2otcVK
         oFymNzFpcB/Ty+mdrMOW5YUtGfYSePXXdk5+iwYABV/giHCq4aY9QzEKkV136VBGR0wk
         tfgAW6fNPtTr1wYFP+B97a+dL3xZ2oncoLXYgBuj9YpjLVvUFPsM9+ZPn+cjGiKFuC1X
         xzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MR4KCI2yYpZ9otoweP9rpmQowf+z82KBy/Idz2Qlj/0=;
        b=XQpTba4aHS9bge//XZdN99oyeZfhR3G3dT7P6w+SBoQHtJZs5dSk3hrou/22SJ5OAH
         4e346shnTmefZDcrq40JwgLKQr/7QudtRCfnDH9J2lSDsmUGaytrJNdQAsrWD5O4iDAD
         pyop/wrhXQ6LNamS5/b/63LfxGCzFAz4k9syk/iBrnryV0CEqNg3lHRLBK9su5Nw3bTe
         r2etcrOWBYYVI9okgmeNzXWoKh6n1bpKQp631C4/VrIbdtaQAk84OeoTCKGqNFeN2arl
         Mx3ALJJzYbx8JA0m/E2gCjVrWFIJGElMKfBk0j+yYunvFoFONlqywXI9bSjhOQnYYvyN
         ywOQ==
X-Gm-Message-State: AOAM531zWWX5ZnjjBg413Cbg/0Ghi3Fkwk+tzpxBqS2cJ+fbOyWxZThM
        eTuwEZ2WXzdOMyywsf83/rKrKw==
X-Google-Smtp-Source: ABdhPJxipRJzXvqCnOaqwebV0TK4ZIjAllrANcyjce4XYc/sl+qO44AQwVCAsUzk2Q7aUGrbzFGoBA==
X-Received: by 2002:a5d:91c2:: with SMTP id k2mr56591ior.117.1628623632939;
        Tue, 10 Aug 2021 12:27:12 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c5sm3025356ioz.25.2021.08.10.12.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:27:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: kill ipa_clock_get_additional()
Date:   Tue, 10 Aug 2021 14:27:04 -0500
Message-Id: <20210810192704.2476461-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210810192704.2476461-1-elder@linaro.org>
References: <20210810192704.2476461-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that ipa_clock_get_additional() is a trivial wrapper around
pm_runtime_get_if_active(), just open-code it in its only caller
and delete the function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c |  9 ---------
 drivers/net/ipa/ipa_clock.h | 10 ----------
 drivers/net/ipa/ipa_smp2p.c |  5 ++++-
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index ab6626c617b91..6df66c574d594 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -264,15 +264,6 @@ static int ipa_runtime_idle(struct device *dev)
 	return -EAGAIN;
 }
 
-/* Get an IPA clock reference, but only if the reference count is
- * already non-zero.  Returns true if the additional reference was
- * added successfully, or false otherwise.
- */
-bool ipa_clock_get_additional(struct ipa *ipa)
-{
-	return pm_runtime_get_if_active(&ipa->pdev->dev, true) > 0;
-}
-
 /* Get an IPA clock reference.  If the reference count is non-zero, it is
  * incremented and return is immediate.  Otherwise the IPA clock is
  * enabled.
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 8692c0d98bd1c..5c118f2c42e7a 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -62,16 +62,6 @@ void ipa_clock_exit(struct ipa_clock *clock);
  */
 int ipa_clock_get(struct ipa *ipa);
 
-/**
- * ipa_clock_get_additional() - Get an IPA clock reference if not first
- * @ipa:	IPA pointer
- *
- * Return:	true if reference taken, false otherwise
- *
- * This returns immediately, and only takes a reference if not the first
- */
-bool ipa_clock_get_additional(struct ipa *ipa);
-
 /**
  * ipa_clock_put() - Drop an IPA clock reference
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index f84d6523636e3..04b977cf91593 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/panic_notifier.h>
+#include <linux/pm_runtime.h>
 #include <linux/soc/qcom/smem.h>
 #include <linux/soc/qcom/smem_state.h>
 
@@ -84,13 +85,15 @@ struct ipa_smp2p {
  */
 static void ipa_smp2p_notify(struct ipa_smp2p *smp2p)
 {
+	struct device *dev;
 	u32 value;
 	u32 mask;
 
 	if (smp2p->notified)
 		return;
 
-	smp2p->clock_on = ipa_clock_get_additional(smp2p->ipa);
+	dev = &smp2p->ipa->pdev->dev;
+	smp2p->clock_on = pm_runtime_get_if_active(dev, true) > 0;
 
 	/* Signal whether the clock is enabled */
 	mask = BIT(smp2p->enabled_bit);
-- 
2.27.0

