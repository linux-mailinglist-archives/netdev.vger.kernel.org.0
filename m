Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BC23EE1BD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhHQA4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbhHQA4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:56:06 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DDBC0612A4
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:24 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y6so13343097lje.2
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YQt/DuSx0bT+fggEeQl7bKu3DF9WLrIbpvPtKTp1n3Q=;
        b=VDg7sgLR5PvBlQfeFtYC652lbHyUalwcdJFv+rouf/RrFSyuQcjGXyE9RXHErNdVHS
         qYGPxJMlLyv3bB2tVrucSjwatYAWM33+Ey7Ag6Mja6333jByHyjvAysGFQm0eLpXTKY1
         j7onx9jAPSxJPFAWf7O19mkHQD7hHKG7LfJ54Awmii3BXn8dCKMtmqxqbbsW1Vw92h4w
         DCnVwPdgnxImZ/OghvlON0r0uaI126uxDcGek3Qi4Ok8/vHc+eUuIyehPiLU2S8Gmp72
         uzNeiSTkrDgWP1xt4Tuj/8HB5wFcRubflkt8itoTdK/D+V1rV+ha9O3hS2Lf2ZwwE4pf
         vhiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQt/DuSx0bT+fggEeQl7bKu3DF9WLrIbpvPtKTp1n3Q=;
        b=IRoRqG+gQg9tuCfqL+IOxwnxQWVUlX81o4WFk0vAkZzoJIWeIeGUAXW7yUPHXFS574
         Lz3lrgE8O9pgx9w8y0Ii8tTj+KDo8HCznwyDpULWHURtmOFyRt5CmhBeeSLtTFCJx/P1
         /AMYo0MA9kvTi2aDtwuvUmPYZDuJ/ORckyQtak0i4L1gg0WVfgRcbi2+d7EWqPgi7QuT
         yw+aC6pUeND+G1Fvh/69tqAY/uXBmlxg6gJv9D6UP7CvEtE2wLkoeNnwlSoBdqRUAIvZ
         sg9MZ0urLmMRIQViRWC1B4LlOcTjwfOT4lTwXcfYTRzTZYUjNzPFzoTHzgGH6AKamP7K
         wJ9w==
X-Gm-Message-State: AOAM533YRd6Ulhh3Did4JCmHFuG/YWFJuXtZnv7U+o0CG+QCEsat3jCX
        twAW3jd24p4h4PAftxq/N9Jgrg==
X-Google-Smtp-Source: ABdhPJyNLUS2dwSRaqJ5H76SvBhAQ9S/S789/Y5Oq9VF9A4kizqCDRIBv075Pxe7Gma8nrJ/Cpt1Eg==
X-Received: by 2002:a05:651c:985:: with SMTP id b5mr797712ljq.78.1629161722852;
        Mon, 16 Aug 2021 17:55:22 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:22 -0700 (PDT)
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
Subject: [RFC PATCH 12/15] arm64: dts: qcom: qrb5165-rb5: add bluetooth support
Date:   Tue, 17 Aug 2021 03:55:04 +0300
Message-Id: <20210817005507.1507580-13-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the bluetooth part of the QCA6391 BT+WiFi chip present
on the RB5 board. WiFi is not supported yet, as it requires separate
handling of the PCIe device power.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 50 ++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index 8ac96f8e79d4..326330f528fc 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -19,6 +19,7 @@ / {
 
 	aliases {
 		serial0 = &uart12;
+		serial1 = &uart6;
 		sdhc2 = &sdhc_2;
 	};
 
@@ -98,6 +99,25 @@ lt9611_3v3: lt9611-3v3 {
 		regulator-always-on;
 	};
 
+	qca_pwrseq: qca-pwrseq {
+		compatible = "qcom,qca6390-pwrseq";
+
+		#pwrseq-cells = <1>;
+
+		vddaon-supply = <&vreg_s6a_0p95>;
+		vddpmu-supply = <&vreg_s2f_0p95>;
+		vddrfa1-supply = <&vreg_s2f_0p95>;
+		vddrfa2-supply = <&vreg_s8c_1p3>;
+		vddrfa3-supply = <&vreg_s5a_1p9>;
+		vddpcie1-supply = <&vreg_s8c_1p3>;
+		vddpcie2-supply = <&vreg_s5a_1p9>;
+		vddio-supply = <&vreg_s4a_1p8>;
+
+		bt-enable-gpios = <&tlmm 21 GPIO_ACTIVE_HIGH>;
+		wifi-enable-gpios = <&tlmm 20 GPIO_ACTIVE_HIGH>;
+		swctrl-gpios = <&tlmm 124 GPIO_ACTIVE_HIGH>;
+	};
+
 	thermal-zones {
 		conn-thermal {
 			polling-delay-passive = <0>;
@@ -804,6 +824,26 @@ lt9611_rst_pin: lt9611-rst-pin {
 	};
 };
 
+&qup_uart6_default {
+	ctsrx {
+		pins = "gpio16", "gpio19";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
+	rts {
+		pins = "gpio17";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
+	tx {
+		pins = "gpio18";
+		drive-strength = <2>;
+		bias-pull-up;
+	};
+};
+
 &qupv3_id_0 {
 	status = "okay";
 };
@@ -1193,6 +1233,16 @@ sdc2_card_det_n: sd-card-det-n {
 	};
 };
 
+&uart6 {
+	status = "okay";
+	bluetooth {
+		compatible = "qcom,qca6390-bt";
+		clocks = <&sleep_clk>;
+
+		bt-pwrseq = <&qca_pwrseq 1>;
+	};
+};
+
 &uart12 {
 	status = "okay";
 };
-- 
2.30.2

