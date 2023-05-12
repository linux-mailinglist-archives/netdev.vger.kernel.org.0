Return-Path: <netdev+bounces-2171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDB57009BB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C46F21C21209
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E441EA83;
	Fri, 12 May 2023 13:59:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DFA1EA6D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:59:02 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029DF13C20
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:58:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-965ddb2093bso1444983866b.2
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1683899936; x=1686491936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uD3Ipvt0NExfmILEv8OKGxIPIOoFOtued5pY1YUMvaA=;
        b=ZPbUlqd510c1ym+w8AeWysEGsU8WE4AvhtiRwFFFnqVDALOh+khbiSvxLg23oSyqZb
         m23j7QATGuiB4u5f77wUiSITvARRigOD9JS+B/tkoTq68F3Xv8HSx5C+8gufqCGb2jjJ
         vfVjzyKT6UxdFfWKSp5p+ftUI4XHKVG3wf6dHJVycvhQkMEdGfMDVCKE6Q9hO5a7wwr4
         faAyGH3z4UyfAob0fREEEbsUpcUmp5EOxCWdfKQsqY0Pp9kfi8jdZs0uKlY7pUej7IV6
         GEgNxH+Bh2Ib7LWsorTTtcuvaEnZz+D04+udrmhsU1TW+sJBVVAmAn82d6dQyBoArZ56
         biYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683899936; x=1686491936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uD3Ipvt0NExfmILEv8OKGxIPIOoFOtued5pY1YUMvaA=;
        b=Ks2ifDyguBQrxmr3uDat5eALI1NamrBM2FaT08UQs0ELjzRJnai/PSXu7nVKWblvXW
         rgHVCjxI3dw49S0BAUsgzSXVbIYX/j6uLn8T753qZgHFYSVguscZFf7g3iC92OJFsEgD
         sIT5f+s0wHQBbIBdqnKbekTJiMAG1Bj20dRwS4xNmntx0eI5IUoHSveaO9aQycyWXfA2
         GaICFRjLO97hgeep06dvFbvN7O6ReDnOPt/tk7n0Gn0ObhyHDAzblcxWGPI9TtNl3UGV
         cNPe6FkUK9cMrhyvJqcDxxoVg4fCKGuoN0gieHLgRkmGXUXSvC9xv2N+Spzlf5ULeSD0
         Z41Q==
X-Gm-Message-State: AC+VfDxBLCbxijIz/+HF+KFe4Wa4n9YJf2bwjJgFOnWHAukD5G00V1Fv
	KrBCl2VIFxvAwL83e2gzjiH66A==
X-Google-Smtp-Source: ACHHUZ5NT+vNCm97DRq7kbKwyyr5lRuNUHvWe9eNLgCczj2xQoRRAEPi7wrQRonSYKHmEGpAR8uEog==
X-Received: by 2002:a17:907:9347:b0:933:3814:e0f4 with SMTP id bv7-20020a170907934700b009333814e0f4mr23139917ejc.16.1683899936411;
        Fri, 12 May 2023 06:58:56 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id mc27-20020a170906eb5b00b00966330021e9sm5399061ejb.47.2023.05.12.06.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:58:55 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 12 May 2023 15:58:26 +0200
Subject: [PATCH v2 4/4] arm64: dts: qcom: sm7225-fairphone-fp4: Add
 Bluetooth
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230421-fp4-bluetooth-v2-4-3de840d5483e@fairphone.com>
References: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 netdev@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The device has a WCN3988 chip for WiFi and Bluetooth. Configure the
Bluetooth node and enable the UART it is connected to, plus the
necessary pinctrl that has been borrowed with comments from
sc7280-idp.dtsi.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 103 ++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 7ae6aba5d2ec..e3dc49951523 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -31,6 +31,7 @@ / {
 
 	aliases {
 		serial0 = &uart9;
+		serial1 = &uart1;
 	};
 
 	chosen {
@@ -524,6 +525,39 @@ adc-chan@644 {
 	};
 };
 
+&qup_uart1_cts {
+	/*
+	 * Configure a bias-bus-hold on CTS to lower power
+	 * usage when Bluetooth is turned off. Bus hold will
+	 * maintain a low power state regardless of whether
+	 * the Bluetooth module drives the pin in either
+	 * direction or leaves the pin fully unpowered.
+	 */
+	bias-bus-hold;
+};
+
+&qup_uart1_rts {
+	/* We'll drive RTS, so no pull */
+	drive-strength = <2>;
+	bias-disable;
+};
+
+&qup_uart1_rx {
+	/*
+	 * Configure a pull-up on RX. This is needed to avoid
+	 * garbage data when the TX pin of the Bluetooth module is
+	 * in tri-state (module powered off or not driving the
+	 * signal yet).
+	 */
+	bias-pull-up;
+};
+
+&qup_uart1_tx {
+	/* We'll drive TX, so no pull */
+	drive-strength = <2>;
+	bias-disable;
+};
+
 &qupv3_id_0 {
 	status = "okay";
 };
@@ -561,6 +595,75 @@ &sdhc_2 {
 
 &tlmm {
 	gpio-reserved-ranges = <13 4>, <56 2>;
+
+	qup_uart1_sleep_cts: qup-uart1-sleep-cts-state {
+		pins = "gpio61";
+		function = "gpio";
+		/*
+		 * Configure a bias-bus-hold on CTS to lower power
+		 * usage when Bluetooth is turned off. Bus hold will
+		 * maintain a low power state regardless of whether
+		 * the Bluetooth module drives the pin in either
+		 * direction or leaves the pin fully unpowered.
+		 */
+		bias-bus-hold;
+	};
+
+	qup_uart1_sleep_rts: qup-uart1-sleep-rts-state {
+		pins = "gpio62";
+		function = "gpio";
+		/*
+		 * Configure pull-down on RTS. As RTS is active low
+		 * signal, pull it low to indicate the BT SoC that it
+		 * can wakeup the system anytime from suspend state by
+		 * pulling RX low (by sending wakeup bytes).
+		 */
+		bias-pull-down;
+	};
+
+	qup_uart1_sleep_rx: qup-uart1-sleep-rx-state {
+		pins = "gpio64";
+		function = "gpio";
+		/*
+		 * Configure a pull-up on RX. This is needed to avoid
+		 * garbage data when the TX pin of the Bluetooth module
+		 * is floating which may cause spurious wakeups.
+		 */
+		bias-pull-up;
+	};
+
+	qup_uart1_sleep_tx: qup-uart1-sleep-tx-state {
+		pins = "gpio63";
+		function = "gpio";
+		/*
+		 * Configure pull-up on TX when it isn't actively driven
+		 * to prevent BT SoC from receiving garbage during sleep.
+		 */
+		bias-pull-up;
+	};
+};
+
+&uart1 {
+	/delete-property/ interrupts;
+	interrupts-extended = <&intc GIC_SPI 602 IRQ_TYPE_LEVEL_HIGH>,
+			      <&tlmm 64 IRQ_TYPE_EDGE_FALLING>;
+
+	pinctrl-names = "default", "sleep";
+	pinctrl-1 = <&qup_uart1_sleep_cts>, <&qup_uart1_sleep_rts>, <&qup_uart1_sleep_tx>, <&qup_uart1_sleep_rx>;
+
+	status = "okay";
+
+	bluetooth {
+		compatible = "qcom,wcn3988-bt";
+
+		vddio-supply = <&vreg_l11a>;
+		vddxo-supply = <&vreg_l7a>;
+		vddrf-supply = <&vreg_l2e>;
+		vddch0-supply = <&vreg_l10e>;
+		swctrl-gpios = <&tlmm 69 GPIO_ACTIVE_HIGH>;
+
+		max-speed = <3200000>;
+	};
 };
 
 &uart9 {

-- 
2.40.1


