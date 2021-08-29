Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2D93FABBB
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 15:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhH2NOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 09:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbhH2NOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 09:14:12 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C40C061760
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:20 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id d16so20717625ljq.4
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lOnAyrBq8epXVQrN/WDXQeiKNCDBNkNLvVnOhj3ua+A=;
        b=ZaYf18QxWsVMzWG6CBkVw0XXu3t/zMW2pUixPk0LjE+/IImlkDEj+POpEj7Ng2IXM8
         V/WLT4pI1wuBXyxaq4fDgRA1q1Bb8oej7fbyHQc4UNqw9wldkBcALlLPedB0TMuFNCla
         PQ+41+z4pNq/TjQbXGdKGeIaXHVsMBRydZXyncyioXfW2os6kVbRcMqXaWCQDBQZNTTW
         yxmrIvNlWnX4aYvLJFVLdr/GqoK0rxsDRPi43f0JSH5oqTsuiIYO8btd4DmGwXfCY8od
         FyUqbFQaPOd/euLOnbc81Yb9s9ttn9pVDjnOryP4XjSMVQZnB2Xspaca5gM+gBQ9N2sB
         9/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOnAyrBq8epXVQrN/WDXQeiKNCDBNkNLvVnOhj3ua+A=;
        b=cgSN/fwgqgZqBemY5VWaQ9hGasZRGc9myYrYTRM86f+oK+i5aR3wde3ii7dRexBLcy
         7ifjeW8mS/ArA2p0MGdIVGliRN75lXWQ29nKE8qMcRGtGH8FlCjI+/3yalEGCBnbfEzb
         Ljg0MZfkRtwc/5hqSOmq5FHOQYwmCgKXmtDNxYw9b2W6norPo+rFDKN0JMDIuU6/pbvL
         hLHAfn59HIPEvaWnBR90l7/8NF9KLfEnNSuBRFduO8xYzQ5WMuqBPRqTIqC84Srzkc3t
         P43WnpPUDFXZG+jYHWr2gVk1f1JzLtCOQYJYh0Bvyq9GTwg0K6XLSTSqtlZcKGLvfbNm
         6kKw==
X-Gm-Message-State: AOAM531Uh8uoCiSR941uUwLcRdPInhN1ZwVJykEsVUibwfSb/AvpVTBM
        XqW4tur9K4Sbx6TJI8PN9g6wLg==
X-Google-Smtp-Source: ABdhPJwas5GqFJEx+SlL+QSRjML4RgZLzDgGX5TZOlcGfqMo26MQAh+FrRI4va8PzqE1egGh7L2xMw==
X-Received: by 2002:a2e:7616:: with SMTP id r22mr16054186ljc.387.1630242798487;
        Sun, 29 Aug 2021 06:13:18 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id x13sm712503lfq.262.2021.08.29.06.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:13:18 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v2 11/13] arm64: dts: qcom: sdm845-db845c: add second channel to qca power sequencer
Date:   Sun, 29 Aug 2021 16:13:03 +0300
Message-Id: <20210829131305.534417-12-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
References: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On DB845c board WiFi/BT chip can use both RF channels/antennas, so add
vddch1-supply property.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index a6a34a959a91..0f3214c60980 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -342,6 +342,12 @@ vreg_l21a_2p95: ldo21 {
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 
+		vreg_l23a_3p3: ldo23 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3312000>;
+			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+		};
+
 		vreg_l24a_3p075: ldo24 {
 			regulator-min-microvolt = <3088000>;
 			regulator-max-microvolt = <3088000>;
@@ -637,6 +643,7 @@ &qca_pwrseq {
 	vddxo-supply = <&vreg_l7a_1p8>;
 	vddrf-supply = <&vreg_l17a_1p3>;
 	vddch0-supply = <&vreg_l25a_3p3>;
+	vddch1-supply = <&vreg_l23a_3p3>;
 };
 
 &sdhc_2 {
-- 
2.33.0

