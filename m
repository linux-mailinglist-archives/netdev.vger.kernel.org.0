Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D674C57E1
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 20:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiBZT62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 14:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiBZT61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 14:58:27 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8399815AF2F
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 11:57:52 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id t11so10492939ioi.7
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 11:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cv/6Z6+pyAreCkwxMM18g15x+IjlN4OIyfYI1qCYP+Q=;
        b=OwhnfxRdzj0Hp+JnACw0PPwob+Z4ncFgKksYIHuxlwovhizc5I08eToYYduaYrXSxc
         WkX4g/krhGltjacmxQpQ09K1zyZf4JpfkVztpmgMDyPP+aLaM5+2678yfvrEpQnMYj67
         q3d/Xh3DO+HmeVLnSVXXG00nx4xWs1+gfsFNkAyONc+I8Yfmx0C+pFUr86tMTSXfnKFm
         V0MW5pAZ/1WFOkUsWVM5CqynyKzPbg64f5zLWJjA4dfpfXIh6m5NkNl4nBdHsLgYmMUt
         Ls5/vmujwgDmXo5b11HStP7tbV4GX31iOxWInbvBoaAMVPYSCd2xeGAmZ4Q8ZnM2Cy27
         9OPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cv/6Z6+pyAreCkwxMM18g15x+IjlN4OIyfYI1qCYP+Q=;
        b=d2XQoF1z+GwmJZTnXV0BNtyK/QtVu6G4hWc774yyQVOULMtO+xxXCiHC9Og86ilWC2
         JOawpo2Iiw+q3lGqQ/Kdt2NR8TDB3lUQgiFS4tNNfUoVtPWsU4D3ouTjWJ8Q6FUxkGrT
         UsVXoavnA1MX582t8onIc/QVSbxxRXb4luXEe9NPmzLESABtiKN1tXvwIlHSfcZebZVI
         6K9N6PN2Ms85NHoooc+qk/hc3CZUG/WqAMmKkV2eloaYipkCt//7av+iDEgUemIpGIbt
         klb4EgnAVw4bWHfaBJocPvv1QKHtJTnMqSBVoL+WiJ0C0aAnuut1iynyEaKPtPFCa4Pv
         qnqA==
X-Gm-Message-State: AOAM532uH68AM7YkAP5jGUeoBjTJKIiUyJKmp9pIiEPTAi6ZDwM4ufPp
        MrN8tfThwqTR+pNZWT6TqgYHsw==
X-Google-Smtp-Source: ABdhPJyx+KOaFq8OheibXJgQjaSqO3biimUyN7E/0NUIetMdhagfFE8L73g5uLw+XVTxQOjCg1cUnA==
X-Received: by 2002:a05:6602:3409:b0:641:a051:df23 with SMTP id n9-20020a056602340900b00641a051df23mr9965368ioz.98.1645905471736;
        Sat, 26 Feb 2022 11:57:51 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b1-20020a926701000000b002c25d28d378sm3419748ilc.71.2022.02.26.11.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 11:57:50 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        lkp@intel.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: add an interconnect dependency
Date:   Sat, 26 Feb 2022 13:57:47 -0600
Message-Id: <20220226195747.231133-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to function, the IPA driver very clearly requires the
interconnect framework to be enabled in the kernel configuration.
State that dependency in the Kconfig file.

This became a problem when CONFIG_COMPILE_TEST support was added.
Non-Qualcomm platforms won't necessarily enable CONFIG_INTERCONNECT.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 38a4066f593c5 ("net: ipa: support COMPILE_TEST")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index d037682fb7adb..3e0da1e764718 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -2,6 +2,7 @@ config QCOM_IPA
 	tristate "Qualcomm IPA support"
 	depends on NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
+	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM
-- 
2.32.0

