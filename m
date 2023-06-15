Return-Path: <netdev+bounces-11109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DACA7318E4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF9021C20EEA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244451D2AF;
	Thu, 15 Jun 2023 12:15:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197751ACB2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:15:25 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677A72943
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:15:05 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f841b7a697so1135131e87.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686831303; x=1689423303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehfVzvQExF8A0HC8WC/ILIhv/WTmHbal1y8W4TeN1es=;
        b=Wu7sz9no4+E8WobBYLCTxrRQ/ms5cwOJWlPzNtXwqHQMxzmBf5xhIkwHh6m0zZ747E
         Xd8rdNa2gg+7ZwyKASQElj9GxfdetYldiyx+OqRdXH02wPTOy8aPbQW4+Uk80h2jUH4O
         1+qye4b806eH5haBuO/GcTONTvg/RUyUfVowUuLIqaRUA4+z4YouDS4U4UAn8WrBlqxT
         UhKIyOyvnt2b3hS2nx8L1ASe+qeIQGGv25SN/2Qstdr5ZNnoiRgaPs87RWveDl591nAT
         PjCryBJlEXlDJmLud0L8AWDCywY0Mo3IsceqcK4BzuFY9zkl+TXGnaQFVggc4Gw+QotL
         +vbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686831303; x=1689423303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehfVzvQExF8A0HC8WC/ILIhv/WTmHbal1y8W4TeN1es=;
        b=Q/EMBNuV+HpvzzJ5QzGycVMf4i2z/SSum14MsSUh/03dEyFjDSVZ8ocwx+L8H6cA3U
         9LuLCMcGcrvDDcOeHvd6pzRFFKXOG7EaelDko0yaui3DyO1qGvMYRIyHNNa1SRGqeEDn
         JuBSp/JpNnwfAeByMPJer20BGwillcFhCQlfccZ2u/PLKiAnBSZFybF+DcdKpem7Ks24
         irihMj5u5ejE3P9OTcJzDQA7EtEaXad+xbWj+cDSEVvwcAkcLzVHGKFtkzSMD2liEuIi
         OX+5ky5FMwPzkxLxXw+/STzOpOtTEm/hYb3vwIt3pICgyBXdKZDf5zj++NfQZ7R8ABQ7
         CPlQ==
X-Gm-Message-State: AC+VfDzWjF7hViCHW90QfmKCeZaCfm183xOoP7ezH3EMy/7F+xxpBgnG
	VAzCTBSKYChank6d8wCRx5KXwQ==
X-Google-Smtp-Source: ACHHUZ501jOXOdbI2vCoh9Z+8k50wxBJblPlQxddMcmLJtJFW3AHRsWBrNj0ZJXAqwZBC0Y5jwcrWQ==
X-Received: by 2002:a05:6512:44b:b0:4f2:6817:2379 with SMTP id y11-20020a056512044b00b004f268172379mr9064077lfk.23.1686831303698;
        Thu, 15 Jun 2023 05:15:03 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:2ad4:65a7:d9f3:a64e])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d4291000000b003047ea78b42sm20918012wrq.43.2023.06.15.05.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 05:15:03 -0700 (PDT)
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
Subject: [PATCH v2 23/23] arm64: dts: qcom: sa8775p-ride: enable ethernet0
Date: Thu, 15 Jun 2023 14:14:19 +0200
Message-Id: <20230615121419.175862-24-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615121419.175862-1-brgl@bgdev.pl>
References: <20230615121419.175862-1-brgl@bgdev.pl>
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
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 88 +++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
index bf90f825ff67..b2aa16037707 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
@@ -261,6 +261,94 @@ vreg_l8e: ldo8 {
 	};
 };
 
+&ethernet0 {
+	phy-mode = "sgmii";
+	phy-handle = <&sgmii_phy>;
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


