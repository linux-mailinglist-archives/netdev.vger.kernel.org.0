Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4002EE9D8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbhAGXfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729352AbhAGXfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 18:35:44 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C679C0612A5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 15:34:13 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id q5so8443940ilc.10
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 15:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jp4jA5VOpxCAdanHFN3bi6TajwKIp0Iz6erEpMOg0cE=;
        b=G7cxNq+GNEp76ltapeUdfzfbwkmXQwvIBuF7CJ5zql10JvmpHwE9AA9/xxGXRqAWi3
         9QkFg+MiWsOG/IoQqpkKsSn+Kfb+dyEFbpOuqV1MmnwoC1U2cdiLzZftDmx6e11ienxK
         vbJkvQ4qhHeEGHfEfXxWmahSmAVXPTcbw1cDHSkt4jrEo8jiht8U5JaBcgVQNEAUCWs7
         f0+NwVlTdxO8uEfRDe5zRtVbY30d72Tz37ebFxkZvpKejibIrpKrwvsYkNRoD0fRRi2r
         EsLygg1b6i+tD1nNQ85Nw7yP9ssMOqIgNdg/cJ6xYa6T6ZrML2qsCdouizqpwsRMOLN5
         xhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jp4jA5VOpxCAdanHFN3bi6TajwKIp0Iz6erEpMOg0cE=;
        b=k0ziVUChEflkhdPfiHD4nzg8iDkWpKFpxnLxgnQ4Z7chQTbH7IhViUG03Zxb+LGfAv
         FymbuXlWkTMgQvk2YqJL+sORaCxTT+bncPgzRW+uXASxQqDtRG8JX0/bIHzd+jmLmVRt
         fMRgncsU80ZeAuCbSuUFaSzkVd3Pt4JRD6oq2AtShmhqecogdHPtuQiHR4USOsnmDv8+
         r8DrNFtDXP4saLb9Pa3JRQx3T8N2FdYW82UXQz3p3o+DxU4z8mEuH24T97pmGxEABVHm
         7IZC9KfeDAs+Rr5jd8UY2rEc4Q0IvYZSiHxQNJ3LE0UsmTyTq3vSAsontys2siWUOOhV
         f6dw==
X-Gm-Message-State: AOAM530+t6NUuVDl6sFeGQuE9mic+1F65FlGB1XfAT8VGjC1I67AzErf
        BSIqDKjwQn4jM/t7AFUUog5Ziw==
X-Google-Smtp-Source: ABdhPJwG3GNNIK3srbianIUC1W25DLdDH9iWzkTwJGbge+Xv/NoW4qdFKPzz0woU+/1kXEkxBu3FlQ==
X-Received: by 2002:a92:9e1d:: with SMTP id q29mr1192638ili.289.1610062452573;
        Thu, 07 Jan 2021 15:34:12 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm5648521ila.38.2021.01.07.15.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 15:34:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, ohad@wizery.com,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: support COMPILE_TEST
Date:   Thu,  7 Jan 2021 17:34:04 -0600
Message-Id: <20210107233404.17030-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210107233404.17030-1-elder@linaro.org>
References: <20210107233404.17030-1-elder@linaro.org>
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

