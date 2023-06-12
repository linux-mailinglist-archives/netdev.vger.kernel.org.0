Return-Path: <netdev+bounces-10052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B0D72BCAF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 992461C20ABD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249A31C763;
	Mon, 12 Jun 2023 09:25:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188C11B8E7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:25:06 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE31C3A80
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-30af159b433so3898795f8f.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561903; x=1689153903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5Kztbbt+Lx+Q6hVK4LvKEHOry/qYQ8OvL9Z8ei/Rso=;
        b=P/Jhfjzh0ruh8aQrw/lvBEWcmDeyZDzd+KU0wuDZSn9r92Pbi5G0y48qPXJTHn5RC4
         kIzNj52wkDwMA68v/kq9zzP3zPaQKZim/cG9i+vNjAzcAMo1M4AcuVkSgWsHGt2DU2LU
         PFrSXKzl06uMIUf7pVrJo4DjNQp8LvcL0gIpifSO0LwHiJsrWKXsQGTWDhllY4QeBTNF
         CNaL9VHRXacLDGSae9qdh7Z++fN1rP4KZe9SPL0P3QQeakYkXnojA+fEt/yIZB3h/PPT
         QNUg7068ipJqt+O5/0maFA8OJzwE+Ya05qCeGA7lNrXRD1vNSDOG0Hl6TSakoutgdRgf
         VzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561903; x=1689153903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5Kztbbt+Lx+Q6hVK4LvKEHOry/qYQ8OvL9Z8ei/Rso=;
        b=Wa9kO9BbJlvAIQDG2WgsbDo+/06Ao4szrDAs6iXYTomwDCJKD4cKPhuLe57dCGhUpY
         1EpRB8DcsEqk0djli8Bvv43NV6HOOZS1eZ/PtVhQ0uMSDJlcuuX+i3EJm3Xhnr6+sSVN
         0qB8tkB2izUzpm3TSH9oYWh/WH8t9xg4HlEnM+fwnHaKZs7dcx9Xw1g+Z+7ZW+vF7YdY
         AKtdCETVuQptUQsnrEw5h+0G18qrZ6bQpGssEA/5FIfHl4IukYbdyJ5+xyqi6+ihCdhp
         +KtzgdMqsb50zsfKkjncGPLJzlVHZVgpQsnkorQFXpL3V5rgl/stnEjspRSDa1KFgk6E
         N9IQ==
X-Gm-Message-State: AC+VfDzJ+S0EP1Fx4rNSiJwN3sYXGlChOSd3DE/0hSxivbAQLWQjKhO/
	5g1ZOBlnVx2CMQxyllDwdwniUQ==
X-Google-Smtp-Source: ACHHUZ6kJTKSQMRxQnmZHKgDHv+8GM+Ey+dfH5KXUQrQ58aTzmadnxCcaM+NOxPdk4JKh+HKGp5Seg==
X-Received: by 2002:a5d:6403:0:b0:307:7e64:4b52 with SMTP id z3-20020a5d6403000000b003077e644b52mr4735283wru.36.1686561903258;
        Mon, 12 Jun 2023 02:25:03 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:25:02 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
To: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 26/26] arm64: dts: qcom: sa8775p-ride: enable ethernet0
Date: Mon, 12 Jun 2023 11:23:55 +0200
Message-Id: <20230612092355.87937-27-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612092355.87937-1-brgl@bgdev.pl>
References: <20230612092355.87937-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Enable the first 1Gb ethernet port on sa8775p-ride development board.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 89 +++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
index dbd9553aa5c7..13508271bca8 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
@@ -261,6 +261,95 @@ vreg_l8e: ldo8 {
 	};
 };
 
+&ethernet0 {
+	phy-mode = "sgmii";
+	phy-handle = <&sgmii_phy>;
+	phy-supply = <&vreg_l5a>;
+
+	pinctrl-0 = <&ethernet0_default>;
+	pinctrl-names = "default";
+
+	snps,mtl-rx-config = <&mtl_rx_setup>;
+	snps,mtl-tx-config = <&mtl_tx_setup>;
+	snps,ps-speed = <1000>;
+
+	status = "okay";
+
+	mdio {
+		compatible = "snps,dwmac-mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		reset-gpios = <&pmm8654au_2_gpios 8 GPIO_ACTIVE_LOW>;
+		reset-delay-us = <11000>;
+		reset-post-delay-us = <70000>;
+
+		sgmii_phy: phy@8 {
+			reg = <0x8>;
+			device_type = "ethernet-phy";
+		};
+	};
+
+	mtl_rx_setup: rx-queues-config {
+		snps,rx-queues-to-use = <4>;
+		snps,rx-sched-sp;
+
+		queue0 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x0>;
+			snps,route-up;
+			snps,priority = <0x1>;
+		};
+
+		queue1 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x1>;
+			snps,route-ptp;
+		};
+
+		queue2 {
+			snps,avb-algorithm;
+			snps,map-to-dma-channel = <0x2>;
+			snps,route-avcp;
+		};
+
+		queue3 {
+			snps,avb-algorithm;
+			snps,map-to-dma-channel = <0x3>;
+			snps,priority = <0xc>;
+		};
+	};
+
+	mtl_tx_setup: tx-queues-config {
+		snps,tx-queues-to-use = <4>;
+		snps,tx-sched-sp;
+
+		queue0 {
+			snps,dcb-algorithm;
+		};
+
+		queue1 {
+			snps,dcb-algorithm;
+		};
+
+		queue2 {
+			snps,avb-algorithm;
+			snps,send_slope = <0x1000>;
+			snps,idle_slope = <0x1000>;
+			snps,high_credit = <0x3e800>;
+			snps,low_credit = <0xffc18000>;
+		};
+
+		queue3 {
+			snps,avb-algorithm;
+			snps,send_slope = <0x1000>;
+			snps,idle_slope = <0x1000>;
+			snps,high_credit = <0x3e800>;
+			snps,low_credit = <0xffc18000>;
+		};
+	};
+};
+
 &i2c11 {
 	clock-frequency = <400000>;
 	pinctrl-0 = <&qup_i2c11_default>;
-- 
2.39.2


