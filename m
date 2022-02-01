Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779D34A5F75
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbiBAPHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240086AbiBAPHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:07:42 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00CBC061749
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:07:42 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p63so20699637iod.11
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H8yp3rbd8JbpM9xzvbWKhE1rf763E53ItSWDuTa2i+Y=;
        b=MmeG2tNbMlUnA5lOOaIe7zg8BrI5FxJPb1n08t1d/6I6N/JTZfEtvt7uzND0fV8aJT
         s89B+6NbWLoWGLKn0QDsNkhAtbtovM8zsXHt66n6N5u/UkBRbzazu8UD+8p7mMEU/LGP
         mBdvE/vdZdC1pL6HTjngXfZvZjbRKNt+lBSeY23MANJmCk2egiwjgKpH0bjORXt0oshl
         asiTFN4HpSVjg8Dftfii4i7d0XLV7vNeBcY4ciaqxANujVS4svJWmmzrBnb6oY6V5ExZ
         URsHBrFy+EB09vUzuYDHRR3FSXUP+HN8bq4FjGr4dlslk0cyZ4cx8QplONSyBbULCF6J
         VYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H8yp3rbd8JbpM9xzvbWKhE1rf763E53ItSWDuTa2i+Y=;
        b=JOoeCj3cS1qrzeVdDaPBen68KDblakIP5FpsAjZLcCo3w3xdHhjQBuqlaYRUTim+KS
         QD3GOAL8qTp4dhR5e6UISoPiQQUlPtBmK4tvqS2hIvdvqKoJEgoxAHlfmj4fLc8QbAnX
         EsAd4JowMfv3fZYkUZ7x0Uhtmt4ZTR6lnZlgvZjqXMhAk4Yhyx6uELRmvgLw1Vf1MWfd
         2IwDM9R09nagZNR1dhK1AiemdwTLm09HcvJ6f9SvACUcQT3C3dRu5kREMuwxsnEDaCZQ
         fjeYoOGVKEKZxV9nMoRAUja1JbKeXX5i3BC7mSKO5ItupWONTGFkPfzTsi5QDRCfdyBJ
         ZwSA==
X-Gm-Message-State: AOAM533ujqw6rF1AHRyhc90g+jcohiM2Lo2uyt0P+cxAVsxQDwFHd441
        sqt5xX9bDeN5wcwoV+JvsF/zaQ==
X-Google-Smtp-Source: ABdhPJw2M1reXF4OuOYCJz65xgdJtTZhb67TTQV7E4ATO7cLleMoJ3tGMo/5T+Z4SslG2TJi4FdWQw==
X-Received: by 2002:a02:85c7:: with SMTP id d65mr13610539jai.60.1643728062245;
        Tue, 01 Feb 2022 07:07:42 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w17sm3517641ilj.1.2022.02.01.07.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:07:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     bjorn.andersson@linaro.org, agross@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] arm64: dts: qcom: add IPA qcom,qmp property
Date:   Tue,  1 Feb 2022 09:07:38 -0600
Message-Id: <20220201150738.468684-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least three platforms require the "qcom,qmp" property to be
specified, so the IPA driver can request register retention across
power collapse.  Update DTS files accordingly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2:  Add devicetree@vger.kernel.org to addressee list.

Dave, Jakub, please let Bjorn take this through the Qualcomm tree.

 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 ++
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 ++
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 2151cd8c8c7ab..e1c46b80f14a0 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1459,6 +1459,8 @@ ipa: ipa@1e40000 {
 					     "imem",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 937c2e0e93eb9..fe5792e7e8d7a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1714,6 +1714,8 @@ ipa: ipa@1e40000 {
 			interconnect-names = "memory",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 53b39e718fb66..5c2866355e352 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1425,6 +1425,8 @@ ipa: ipa@1e40000 {
 			interconnect-names = "memory",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
-- 
2.32.0

