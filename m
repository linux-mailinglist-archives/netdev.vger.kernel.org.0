Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7655F6BC4EE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCPDsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCPDsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:48:13 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0819897FD5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:10 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id p8-20020a4a3c48000000b0052527a9d5f0so56537oof.1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678938489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MviEEWSTJxxSnXQ8MTU0qt5CxziP8W4MnnoSp2fynjs=;
        b=XWl8vLRg8SWI+k7I74n/oowWqeKyPcjyMWA1lH1QzC2rDjJLZXfwRheUyKbLXuiN2e
         /iOUiLF7OQcqv2an0KOFsoh5jUVWiJMRSlcNzV/sWLhjc00F8twiykhe4mncckWWyMBU
         bikDI/5mXlnBz+Cmbrh3a5W56A6f5R1OEr/xF8nDQ8U4rSd68bwvWiGhloB/4PILWup9
         ylD8uXJk2lvidmyjGn9YfGsAiKF/flB8o1QWdaHka8hyOhL9zjBgi7FO48x6Z5KRn1ec
         y2ybe9MSGq91TQKPuqIw3+4H6spkIvl/fEtetMp2I0GRsE5HlTy+PXmtd/aGptkV+aiW
         o0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MviEEWSTJxxSnXQ8MTU0qt5CxziP8W4MnnoSp2fynjs=;
        b=MaW4fVSwBs1XvIfrBmdaCPBzLLN/hKhsVqCGoTaHxr4Zo3NRytwgGU1nkrcCXafFgN
         zmcRaI55YmYUj7TyfkxtVUGyYv8pN4OgSZPIsp4COAhyoVs/fUXVQ0JbdPdi9UyjFFho
         3rjkIXDy/yShopie1W9qdroZCJBY/DxCJ37MtrRrMA5A7JX/w5U+Bzpq3Dmyc+ogR53h
         rYmr13g9qovfYtcsagEOGBy+dJtPHUWwsP/x6urbwHyNpQmv8LDqBDZD310r+xwA4hgZ
         FJcyzitp1WZQiZ1+DjXZOopPruO0aCwxQMPwXSyAmoLQdpNs1/kG54rTO03eJH5MZgwQ
         nWgA==
X-Gm-Message-State: AO0yUKWekmIFVKF7SvR4lhzS/DuybHPZNRRn5ypp8omoL9hYoTU6FCwP
        4B9VoLmi7jwI00F0BXe00saAmQ==
X-Google-Smtp-Source: AK7set+5yVTtbc+9dBUUCDW5xTHgd8ufHL8cPwAZ0n2vsAuStk3stYLCvHf+RRuXDZIsnLHWOvywQA==
X-Received: by 2002:a4a:d286:0:b0:525:3dc9:c39b with SMTP id h6-20020a4ad286000000b005253dc9c39bmr11389658oos.0.1678938489411;
        Wed, 15 Mar 2023 20:48:09 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id b3-20020a9d4783000000b0068bc48c61a5sm3054659otf.19.2023.03.15.20.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:48:09 -0700 (PDT)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH v6 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Date:   Wed, 15 Mar 2023 22:47:58 -0500
Message-Id: <20230316034759.73489-5-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316034759.73489-1-steev@kali.org>
References: <20230316034759.73489-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
add this.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
---
Changes since v5:
 * Update patch subject
 * Specify initial mode (via guess) for vreg_s1c
 * Drop uart17 definition
 * Rename bt_en to bt_default because configuring more than one pin
 * Correct (maybe) bias configurations
 * Correct cts gpio
 * Split rts-tx into two nodes
 * Drop incorrect link in the commit message

Changes since v4:
 * Address Konrad's review comments.

Changes since v3:
 * Add vreg_s1c
 * Add regulators and not dead code
 * Fix commit message changelog

Changes since v2:
 * Remove dead code and add TODO comment
 * Make dtbs_check happy with the pin definitions

 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 53ae75fb52ed..b3221c27903a 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -24,6 +24,7 @@ / {
 	aliases {
 		i2c4 = &i2c4;
 		i2c21 = &i2c21;
+		serial1 = &uart2;
 	};
 
 	wcd938x: audio-codec {
@@ -431,6 +432,16 @@ regulators-1 {
 		qcom,pmic-id = "c";
 		vdd-bob-supply = <&vreg_vph_pwr>;
 
+		vreg_s1c: smps1 {
+			regulator-name = "vreg_s1c";
+			regulator-min-microvolt = <1880000>;
+			regulator-max-microvolt = <1900000>;
+			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>,
+						  <RPMH_REGULATOR_MODE_RET>;
+			regulator-allow-set-load;
+		};
+
 		vreg_l1c: ldo1 {
 			regulator-name = "vreg_l1c";
 			regulator-min-microvolt = <1800000>;
@@ -901,6 +912,32 @@ &qup0 {
 	status = "okay";
 };
 
+&uart2 {
+	pinctrl-0 = <&uart2_default>;
+	pinctrl-names = "default";
+
+	status = "okay";
+
+	bluetooth {
+		compatible = "qcom,wcn6855-bt";
+
+		vddio-supply = <&vreg_s10b>;
+		vddbtcxmx-supply = <&vreg_s12b>;
+		vddrfacmn-supply = <&vreg_s12b>;
+		vddrfa0p8-supply = <&vreg_s12b>;
+		vddrfa1p2-supply = <&vreg_s11b>;
+		vddrfa1p7-supply = <&vreg_s1c>;
+
+		max-speed = <3200000>;
+
+		enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
+		swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-0 = <&bt_default>;
+		pinctrl-names = "default";
+	};
+};
+
 &qup1 {
 	status = "okay";
 };
@@ -1175,6 +1212,21 @@ hastings_reg_en: hastings-reg-en-state {
 &tlmm {
 	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
 
+	bt_default: bt-default-state {
+		hstp-sw-ctrl-pins {
+			pins = "gpio132";
+			function = "gpio";
+			bias-pull-down;
+		};
+
+		hstp-bt-en-pins {
+			pins = "gpio133";
+			function = "gpio";
+			drive-strength = <16>;
+			bias-disable;
+		};
+	};
+
 	edp_reg_en: edp-reg-en-state {
 		pins = "gpio25";
 		function = "gpio";
@@ -1196,6 +1248,34 @@ i2c4_default: i2c4-default-state {
 		bias-disable;
 	};
 
+	uart2_default: uart2-default-state {
+		cts-pins {
+			pins = "gpio121";
+			function = "qup2";
+			bias-pull-down;
+		};
+
+		rts-pins {
+			pins = "gpio122";
+			function = "qup2";
+			drive-strength = <2>;
+			bias-disable;
+		};
+
+		tx-pins {
+			pins = "gpio123";
+			function = "qup2";
+			drive-strength = <2>;
+			bias-disable;
+		};
+
+		rx-pins {
+			pins = "gpio124";
+			function = "qup2";
+			bias-pull-up;
+		};
+	};
+
 	i2c21_default: i2c21-default-state {
 		pins = "gpio81", "gpio82";
 		function = "qup21";
-- 
2.39.2

