Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686F14C8ADF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiCALf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiCALfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:35:25 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107D691AD4
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 03:34:45 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id x14so7178302ill.12
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 03:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cwyH7ZYCvlxkzfpPo5L0/LxHzysOdr2qf7q8v1soS3k=;
        b=kIOl7bIGsVLFNMv/BXknkeQPTiy/gkcCOZJnBwFP8cxdutucakq9RYnfvYGFF08Ygc
         RKgQMoo6nOE8nNOpjp7B3OHtLPI9Cmno3sB10VnViM0lv15TZFIJT7biuV6xfYVdiFnE
         SofnK0R2GzmYOJDE0/uSI7/V3XZecKTaOjfIvKzI48pnjSX5pjb94dTk5V3bfQ+4x8bl
         Lm1Raf7OCW0ZAUtMgXlOeu9+fnbrig9emesRvUcb01tCzDPTNq2CxOnlfHFwgybFEQu9
         FWSeLoHcsNElxY7OoZgaEZVx+r9wGRMtHFhwChm7EdaSKjTQwUlkxdEXS6grHkIJzCzR
         YLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cwyH7ZYCvlxkzfpPo5L0/LxHzysOdr2qf7q8v1soS3k=;
        b=Sf1Ir/8b3CxQ3/BIbxhBAnt45VjiT4gbFvkbnLO66ryUtSDlG8c0buNQ8TgSViQyqQ
         DQ0ejOxCAOe/oSjMRU0FshAgz2yhgquSB6zdrb42k5SSeL8p+Pj4xgf8arQowdbL7CfP
         wok2z2CD+H7cjgocxCbKesTXMl6tFuK0w1iZzAQ6epdlshYwNsASCeHBBGzAFdT3Hraw
         XUgJeJAqgISw6dIF75M7Ct2cjYrpCQ/IzaOvnjxJp5DLdoLqtJf8zKkd0skqXDwp2oBJ
         3o9balHxHA8rHojqQcsvqvrozjRqK0HwtEICdnOqGhqVzfd6sryXV7m+PPhY+OH5Im/m
         1B/w==
X-Gm-Message-State: AOAM532rgdQ1e/5pNCqLAfDJ157LmM94uY6Qe1v4S//WE8BvNL6erufI
        pUj7hWcILkv3B65PUKixZmTFKQ==
X-Google-Smtp-Source: ABdhPJx8yMOOHfptYCj2Jy1tgUKGNNI8YILty5etWM3S9F5gJUvU4HPXR4bEwhu1xTEYIoR+9Z8Isg==
X-Received: by 2002:a05:6e02:17c9:b0:2c2:a5b3:36fc with SMTP id z9-20020a056e0217c900b002c2a5b336fcmr20967860ilu.303.1646134484337;
        Tue, 01 Mar 2022 03:34:44 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a2-20020a056e02120200b002c21a18437csm7610374ilq.40.2022.03.01.03.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:34:43 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        lkp@intel.com, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ipa: add an interconnect dependency
Date:   Tue,  1 Mar 2022 05:34:40 -0600
Message-Id: <20220301113440.257916-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
v2: Rebased as requested.

 drivers/net/ipa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index e0164a55c1e66..6782c2cbf542f 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -2,6 +2,7 @@ config QCOM_IPA
 	tristate "Qualcomm IPA support"
 	depends on NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
+	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select QCOM_MDT_LOADER if ARCH_QCOM
-- 
2.32.0

