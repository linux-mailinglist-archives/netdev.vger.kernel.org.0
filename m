Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE4C68236D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjAaEj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjAaEjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:39:06 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797DD3C2A6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:38:31 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id d188so11903312oia.3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVFjUAudhz48B1PG37PF0oDcvMhXp172jIwuWPlj7hM=;
        b=WxKR1qFCYmq75yM8ksUFDRSsFWXpnPcTkqYKr/NifhNqXlx+tnPSHWA/IqxgveYdHa
         qcGsxnQdHae2UyazsMBt6XhYQAy+fGBPn7rR7N7t/PpyTTwKbA9KYbRrtYpHMHPwQYxa
         I0wYi3HqYWr6l8ejdFryo9/Pbe0UW5pbpP2y8uuz58a0TqUgGOyLuUy2euTmy2MlqMxW
         4p/gnpw+B40IBjEY6IGQ2ODiCaNOs1jroe7eP73Wh3LtVg1IR2122ooawoFA5p85TRfA
         BC3EcovRFWsbDd43Kkv/4P++7ZcZxQEPQ+rgmTXuE0wkAaiWHLJFyiqZsDV7orw2Dwi9
         g8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eVFjUAudhz48B1PG37PF0oDcvMhXp172jIwuWPlj7hM=;
        b=r8o/MQg8uO/owdVXtGnI7bjjiLIdGCJxf2Y33oAb7XCxh5wGRhvn1Ci65EbsnG+7dM
         np8D0bmwFRjeyo+2MZ8TxqkT5dK1AWyVOr7FEBxcBUUKdEwxvbMSL0eAXlyQBAZdwDnY
         1j5Pk0s7MhhDOCi/a60VYkRNDOSJW4SwJR8r0XQSo6NpKRtaZ/kohfarzqFtBgnnLR4Y
         km7AAQoRcYoJCu3krXfyki59/amC+9beZlwpr4IFP3JxtfvEwQKGyExeoDyNpV6wRV6S
         dJ4pdKQvjmUXJjJv4rAH3TYnhjoJ0oZoVi5qMan8sgePUkRl/g/BZW/mbn2VobUFWDFi
         XOSw==
X-Gm-Message-State: AFqh2kom6DXwDrFloQVq3Liww+bQ3GsCb+Zzc/W3Ie+cOGu4d9ScTTEL
        /c25Pp2t0Fps3+DGJszY4HUIDA==
X-Google-Smtp-Source: AMrXdXvaEIEHQxmGGUSLDqOZjf++5rSIBsjsT19PE0dlt7VSbc4D+DUnkT6Qp/lNws2gihhJ93yCeA==
X-Received: by 2002:a05:6808:1247:b0:360:e643:7e27 with SMTP id o7-20020a056808124700b00360e6437e27mr30333622oiv.36.1675139904792;
        Mon, 30 Jan 2023 20:38:24 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id u14-20020a056808150e00b0035418324b78sm4276083oiw.11.2023.01.30.20.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 20:38:24 -0800 (PST)
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
        Mark Pearson <markpearson@lenovo.com>
Subject: [PATCH v2 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Date:   Mon, 30 Jan 2023 22:38:16 -0600
Message-Id: <20230131043816.4525-5-steev@kali.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131043816.4525-1-steev@kali.org>
References: <20230131043816.4525-1-steev@kali.org>
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

Signed-off-by: Steev Klimaszewski <steev@kali.org>
---
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index f936b020a71d..951438ac5946 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -24,6 +24,8 @@ / {
 	aliases {
 		i2c4 = &i2c4;
 		i2c21 = &i2c21;
+		serial0 = &uart17;
+		serial1 = &uart2;
 	};
 
 	wcd938x: audio-codec {
@@ -712,6 +714,32 @@ &qup0 {
 	status = "okay";
 };
 
+&uart2 {
+	status = "okay";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_state>;
+
+	bluetooth {
+		compatible = "qcom,wcn6855-bt";
+
+/*
+		vddio-supply = <&vreg_s4a_1p8>;
+		vddxo-supply = <&vreg_l7a_1p8>;
+		vddrf-supply = <&vreg_l17a_1p3>;
+		vddch0-supply = <&vreg_l25a_3p3>;
+		vddch1-supply = <&vreg_l23a_3p3>;
+*/
+		max-speed = <3200000>;
+
+		enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
+		swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&bt_en>;
+	};
+};
+
 &qup1 {
 	status = "okay";
 };
@@ -720,6 +748,12 @@ &qup2 {
 	status = "okay";
 };
 
+&uart17 {
+	compatible = "qcom,geni-debug-uart";
+
+	status = "okay";
+};
+
 &remoteproc_adsp {
 	firmware-name = "qcom/sc8280xp/LENOVO/21BX/qcadsp8280.mbn";
 
@@ -980,6 +1014,19 @@ hastings_reg_en: hastings-reg-en-state {
 &tlmm {
 	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
 
+	bt_en: bt-en-state {
+		hstp-sw-ctrl {
+			pins = "gpio132";
+			function = "gpio";
+		};
+
+		hstp-bt-en {
+			pins = "gpio133";
+			function = "gpio";
+			drive-strength = <16>;
+		};
+	};
+
 	edp_reg_en: edp-reg-en-state {
 		pins = "gpio25";
 		function = "gpio";
@@ -1001,6 +1048,27 @@ i2c4_default: i2c4-default-state {
 		bias-disable;
 	};
 
+	uart2_state: uart2-state {
+		cts {
+			pins = "gpio122";
+			function = "qup2";
+			bias-disable;
+		};
+
+		rts-tx {
+			pins = "gpio122", "gpio123";
+			function = "qup2";
+			drive-strength = <2>;
+			bias-disable;
+		};
+
+		rx {
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
2.39.0

