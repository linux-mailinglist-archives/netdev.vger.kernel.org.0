Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9322EB826
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 03:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbhAFCj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 21:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbhAFCj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 21:39:27 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A33C061349
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 18:38:19 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id r9so1398800ioo.7
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 18:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jp4jA5VOpxCAdanHFN3bi6TajwKIp0Iz6erEpMOg0cE=;
        b=rFAwaVSdLbBQiw6Kmmz1bVo0cshRtSGy6SrHqayvtCZ+SAXxc/2kt7Xfij6fwvj0gy
         K1Gr2dRFvZ7ninidIi5m/zsInBqSCo7kQ0Zi7jdm0QbQJYhxmYbXymccCcOErNHnljuW
         XcqAOBH4rsuph9FFqxpNXoTm3uA4Kp1ip6X+Q7Ah9i/bBiPt4kZJnXyBneulaYYNJ132
         qLPOnkeg6AkaaG+3Nsk9szYSjZMevnmTEzr3XgfMoEwI0AiQqsylTAM4rcCcg04ucv6f
         Mu9fvxDc5fY2ynK7PlnamlnMqt6utThhUPMrc/ymd71zuj49yee+0Bhodx2Ro2yMes0Y
         KDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jp4jA5VOpxCAdanHFN3bi6TajwKIp0Iz6erEpMOg0cE=;
        b=a4Vk92Qm9hUhnxOPSxm0IcheHx0yfpTAMOpeQop0Uz6ELe63OUPZddO0LvBKUbJF9Y
         aivhKIaTkLOcY+xh9S2HISHcbiK68DuMnwpbVUbVUvO8IkwZQqBx/rP2NNqP6gr8LYKI
         TTO1deKkcdJln0K23GeeI2+ZI7i8TxL75IpusN/caIDRswMEzuG8EHsr0EB+yPMhCLp4
         IU0CLvVNyGPr16RH+Ia1Z9SEy204po+dJcYrePlak0eFzi4SAitv1qJ56h1rfkTkG2/o
         RGoJa8bYc0jO4x1rVris/Vwcp2HRdssLlqfiil3/SE0ozz7FN0ImEHtz+o3pIme3BLui
         8pWw==
X-Gm-Message-State: AOAM532yG+ENujYWVn3Ki/8mujQaXr/4V7g/Z2iSXCtvDSXislbo3kDV
        xhQqjAGS5LO1jPxeojIEG11C9A==
X-Google-Smtp-Source: ABdhPJzSLxMjstBlx99fWxDr2h+/Ajt+Uj5J8I3vGJRM4+L5cn3Sijho6Y2AgshvvWdkscHBeCCyWg==
X-Received: by 2002:a6b:5f0e:: with SMTP id t14mr1556852iob.80.1609900699177;
        Tue, 05 Jan 2021 18:38:19 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm631755ior.42.2021.01.05.18.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 18:38:18 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, ohad@wizery.com,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ipa: support COMPILE_TEST
Date:   Tue,  5 Jan 2021 20:38:12 -0600
Message-Id: <20210106023812.2542-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210106023812.2542-1-elder@linaro.org>
References: <20210106023812.2542-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arrange for the IPA driver to be built when COMPILE_TEST is enabled.

Update the help text to reflect that we support two Qualcomm SoCs.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Kconfig | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index 9f0d2a93379c5..10a0e041ee775 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -1,9 +1,10 @@
 config QCOM_IPA
 	tristate "Qualcomm IPA support"
-	depends on ARCH_QCOM && 64BIT && NET
-	depends on QCOM_Q6V5_MSS
+	depends on 64BIT && NET
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
+	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_QMI_HELPERS
-	select QCOM_MDT_LOADER
 	help
 	  Choose Y or M here to include support for the Qualcomm
 	  IP Accelerator (IPA), a hardware block present in some
@@ -11,7 +12,8 @@ config QCOM_IPA
 	  that is capable of generic hardware handling of IP packets,
 	  including routing, filtering, and NAT.  Currently the IPA
 	  driver supports only basic transport of network traffic
-	  between the AP and modem, on the Qualcomm SDM845 SoC.
+	  between the AP and modem, on the Qualcomm SDM845 and SC7180
+	  SoCs.
 
 	  Note that if selected, the selection type must match that
 	  of QCOM_Q6V5_COMMON (Y or M).
-- 
2.20.1

