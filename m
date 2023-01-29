Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B239680200
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 22:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbjA2Vwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 16:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbjA2Vwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 16:52:31 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C5B1E5EC
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 13:52:05 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id t19so337611oiw.10
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 13:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yz+FkVg3d7pGHf5kpyEB9/wRCprKyRRYjM/y0EJ+DBw=;
        b=NO5FmqzTPfKQGSAJFuNQXcl2/Qwzk4V6Re/JvCoc2IjaRyulashjR8KWmE/UTwsoDd
         HIVdOJs4TwzSlKFcRg+FdezQD/LAA/vlBxIgoIvrBqC2qLNt+7KYcL7J+Xytu95sr/wo
         tRMx8V5RFrb6ew1gunJew1xwXwyEXUluGp/U7OIfTuTsUDeO74pms6YH6GQALgwbZAeP
         xTD0onQAafrw0xKMlb6ufLPIAHACOQje2ciSL2/3Ya3gVY2sK9oeiLKp/oVAu4QS404C
         Jqn12RYLi22IaL8XBhDhE95svQpiib+eCMduXy1lPLD4to1P/6d4KURs+RwHFJHkgBw4
         hTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yz+FkVg3d7pGHf5kpyEB9/wRCprKyRRYjM/y0EJ+DBw=;
        b=MSqi9x32MJ2nrmitlPYDzuJjHbH7h9dQxMzr28DauqeTYBW8/N3f5o5n6gmcaGNKba
         ShFvX8qW0sOOVtXK2BZH41VkHzjZV5h43m9Cbp6nw/k3iFScEffXt86+1mgZ6iRss/d2
         LR3s+NC3i9imAjLw+wRLB3duFFLEoQm8Mu8FHrbZZVDPIYmYFEoq+pyg1cdMweC2c+MF
         D4tLs8s/6c3G/rp36IlmZ45Cu83Vccql04YgrdW7nPjHSHE5xqj7DL+VfkMuzs0u0ncP
         MyCrAG2Lejhwc+HM5VefgFqj+4c0LXgHVqpHh5jkt+Lhc1c9kneFNlXwDjxqS7jED4eK
         1YwQ==
X-Gm-Message-State: AFqh2krnrzLMk5YPqcqAJvcGuih/3hB5QxZ9AyVgGMG7PpQ/u9AlrvcS
        qn4zxfdNJlY2EhbQcULPkzjDyg==
X-Google-Smtp-Source: AMrXdXvoNs3Xkmc83sz5OAeNDxC7M6qRfUCSu1WdB6CBf96rnsNfFOfqoKDQXJVDudUDlt65txNtvA==
X-Received: by 2002:a05:6808:1144:b0:35e:6a80:5e17 with SMTP id u4-20020a056808114400b0035e6a805e17mr30085582oiu.56.1675029119998;
        Sun, 29 Jan 2023 13:51:59 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id f12-20020a9d7b4c000000b00660e833baddsm4667139oto.29.2023.01.29.13.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 13:51:59 -0800 (PST)
From:   Steev Klimaszewski <steev@kali.org>
To:     steev@kali.org
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
        Sven Peter <sven@svenpeter.dev>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Date:   Sun, 29 Jan 2023 15:51:30 -0600
Message-Id: <20230129215136.5557-5-steev@kali.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230129215136.5557-4-steev@kali.org>
References: <20230129215136.5557-1-steev@kali.org>
 <20230129215136.5557-2-steev@kali.org>
 <20230129215136.5557-3-steev@kali.org>
 <20230129215136.5557-4-steev@kali.org>
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
index e51f93476b8d..a9d653e02a2b 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -25,6 +25,8 @@ / {
 	aliases {
 		i2c4 = &i2c4;
 		i2c21 = &i2c21;
+		serial0 = &uart17;
+		serial1 = &uart2;
 	};
 
 	wcd938x: audio-codec {
@@ -886,6 +888,32 @@ &qup0 {
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
@@ -894,6 +922,12 @@ &qup2 {
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
 
@@ -1154,6 +1188,19 @@ hastings_reg_en: hastings-reg-en-state {
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
@@ -1175,6 +1222,27 @@ i2c4_default: i2c4-default-state {
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

