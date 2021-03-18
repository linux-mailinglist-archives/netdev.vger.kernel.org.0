Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A15340DB0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhCRTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhCRS7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:59:38 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28EEC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:59:37 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id x16so3431775iob.1
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1vkQNGymFwLks9UB15v9pfiGh7bDRvcY3otglQibLg=;
        b=pfH5ler1whahhR7+Rbq/Yg+pGdofKAwCexk6XT2t/2TWybTCB0lpcWaT3m1Mc4mpcA
         TQXlJHkxjKuJjLxJ1byok/7EoaMoC34AZHIkev0kYH2lR/dTCN5/0USvcdT0jhUa6QEo
         dfbEpM/L8+5ls/Dz+Y03cFa23R7Ry1p5gTgbqcJ9/d6CYrul3HjO+p+L+pnOVI+++Yqf
         etF9fgoDw+HB8pbMI8mBmeKKXLVu9ij/KAcHOgeSGw8UcqWRYS1xUpVr9rZP0KgyTzi1
         dINpVZOlSCzuWLVj8n4he154qSbM6dHIi0q6rECGjCDomPUJC2xSBYKwzaesvIyjuE0U
         Pwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1vkQNGymFwLks9UB15v9pfiGh7bDRvcY3otglQibLg=;
        b=TAoAlBKRJoNoqHkE9jgWXwvhaiM+UboCZ2cY5wMRsaGxEreO29d31h87QYDUv5bvKu
         HXvwNqB0Vus3mjsTBaHUZdWD1SmParcF0KKjoh9t4/K/LNQe5qFI0KByKt48Ty7eMap2
         2nO1W0eoszucmxBDHo89XabuPY4vVjO613OtwDUR/5V3/F4oO2i/UFA98MYYd0sE/1fP
         zKcNafdp3nVVVysgwAMnNsUxWDfAjoV1wvU7ARqsUkJWy61TzqRl7B7hGwCTqkExvZlF
         1V/Kg8rCEivDtcjwHwvH0WYQ1lOEa4K3Uh7cEgsIEZq8XaDeiO70ON1oWeJ7PJGXY1mF
         AmqA==
X-Gm-Message-State: AOAM532cVs/O0Bmpj08gY/iMVirMK209ZCrfjuD6cLOnWYeCVfLW0/mc
        mDlmoeQFoDs3/C5wfSC2oR+yAg==
X-Google-Smtp-Source: ABdhPJyBJfnLmpJKvapKx8C9fJLQoE8XgYgXus7U9uis/zT26DgabEC/bTzfh+hmpv0ogwzs6A0Urw==
X-Received: by 2002:a5e:d908:: with SMTP id n8mr6640iop.121.1616093977333;
        Thu, 18 Mar 2021 11:59:37 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k7sm770359ils.35.2021.03.18.11.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 11:59:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/4] net: ipa: relax 64-bit build requirement
Date:   Thu, 18 Mar 2021 13:59:30 -0500
Message-Id: <20210318185930.891260-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318185930.891260-1-elder@linaro.org>
References: <20210318185930.891260-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently assume the IPA driver is built only for a 64 bit kernel.

When this constraint was put in place it eliminated some do_div()
calls, replacing them with the "/" and "%" operators.  We now only
use these operations on u32 and size_t objects.  In a 32-bit kernel
build, size_t will be 32 bits wide, so there remains no reason to
use do_div() for divide and modulo.

A few recent commits also fix some code that assumes that DMA
addresses are 64 bits wide.

With that, we can get rid of the 64-bit build requirement.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Kconfig    |  2 +-
 drivers/net/ipa/ipa_main.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index b68f1289b89ef..90a90262e0d07 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -1,6 +1,6 @@
 config QCOM_IPA
 	tristate "Qualcomm IPA support"
-	depends on 64BIT && NET && QCOM_SMEM
+	depends on NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	select QCOM_MDT_LOADER if ARCH_QCOM
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 97c1b55405cbf..d354e3e65ec50 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -735,8 +735,14 @@ MODULE_DEVICE_TABLE(of, ipa_match);
 static void ipa_validate_build(void)
 {
 #ifdef IPA_VALIDATE
-	/* We assume we're working on 64-bit hardware */
-	BUILD_BUG_ON(!IS_ENABLED(CONFIG_64BIT));
+	/* At one time we assumed a 64-bit build, allowing some do_div()
+	 * calls to be replaced by simple division or modulo operations.
+	 * We currently only perform divide and modulo operations on u32,
+	 * u16, or size_t objects, and of those only size_t has any chance
+	 * of being a 64-bit value.  (It should be guaranteed 32 bits wide
+	 * on a 32-bit build, but there is no harm in verifying that.)
+	 */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_64BIT) && sizeof(size_t) != 4);
 
 	/* Code assumes the EE ID for the AP is 0 (zeroed structure field) */
 	BUILD_BUG_ON(GSI_EE_AP != 0);
-- 
2.27.0

