Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4800033FB38
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhCQWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhCQW3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:29:54 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A97C06175F
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:54 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id v3so235333ioq.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1vkQNGymFwLks9UB15v9pfiGh7bDRvcY3otglQibLg=;
        b=vpbFLeMRuTRlxQmt7mwB1X/oaGFaWym8vUPh8Nt5PAmxVH+3wxIqjd5ADo0z/cwnyw
         XOWGsvl2iYrFkuSi6VKM2oVkWwasB1q4xJwv0obRePsrEMZwy/a3VLOZNx/3hawk53Dn
         jLHvSp0aApANuCb5vyRY/UL3ZrR9xZ1X2A9srf7XGj+8hqJGGVylxahyeVRJu8lc6Xib
         8pERSjbLNcJuD/aqYOhoaCLaVDV2DRscTTB9wUU3dErruFni8EEXJYggpcsxLEvINwys
         S43AvfRUeSzwJuwwGB2rGiNxOBRIH92mOOmsvoOO1KTkZFLxMFZecNutlM46KybSlEj8
         Ri3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1vkQNGymFwLks9UB15v9pfiGh7bDRvcY3otglQibLg=;
        b=gT2UaoEyeEjZroRbnyQFLNSc4m+XPG3P9vVNQcZ1ZZ8dfvxveFmJauQUrcq4xhfL3Q
         LK1wZb1wg3KQlLcvlDYj1FHjBDUFyHg3cJQ+zdcYkCLtIi8OV+J0D1e81Y557Jkiz73S
         SkhNw7IFJtaks/0EzuEkmhAO32nFkAst+/dWVDkH7JGARl8HCf9lzu66GJrCG43MhvBd
         g5PfsOtW1cYFh/bO+GVN+Whm+0mE/a4TPkJa8fGiGPh9gkpYMHIRRRdL+4c+0njaAKl8
         u6mBND+J1L7FVAAhev7H8FcggB7AyIin0Fcfc9kvIXeo6YWLS8OPzeWZpsIaHXVS/kra
         e7Qw==
X-Gm-Message-State: AOAM530qUp0d/UmUti0zOu0DO81CqkqAcSPRStYUFDI3/ZjIruUOqUSB
        Lp2YS9yk1ERDtrAdXqwJlJ66jg==
X-Google-Smtp-Source: ABdhPJynFxdQpp2CnjvCau6E19WPbDsDxzdxayK/IbIcdfWTj+vlDOCceh5FX5AxCP6eeBulddKLlA==
X-Received: by 2002:a05:6638:e93:: with SMTP id p19mr4610398jas.10.1616020194041;
        Wed, 17 Mar 2021 15:29:54 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f3sm176405ilk.74.2021.03.17.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:29:53 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: relax 64-bit build requirement
Date:   Wed, 17 Mar 2021 17:29:46 -0500
Message-Id: <20210317222946.118125-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317222946.118125-1-elder@linaro.org>
References: <20210317222946.118125-1-elder@linaro.org>
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

