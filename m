Return-Path: <netdev+bounces-10048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AEC72BC8E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC228281143
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BDD1B8F6;
	Mon, 12 Jun 2023 09:25:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98971B8E7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:25:00 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7286635BB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f70fc4682aso27842835e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561898; x=1689153898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dryPugxzZVkqmEr4Pa67GWmkXSnMJtg4EXukR1I6igY=;
        b=M5U/hsARaGla6BtHBrfakRsf8bgC4Xv7LPP5Nj/IRwkteEW4yhKwcSaFwSQ1iHYbWm
         Q0yiPLZAjS9ogGsUnUy/dhShfi9KcDvvB2h2CuruXjTqQF5VmqHPzqtBqySGi24k9f7c
         ZzcFGICrp8SyArBAwoabUFjTt474+VBi0upbh1KdppDpS2YwuCJH863C6jTtvXX93E3O
         RwShAOBQ99lfLQ8gcI9PTAVl4liqjyOogX/Z4fLNTj7ZrvRel3u6DlbW+ZTFUyxj/e0d
         +zcpbnQHWCVagDqk6GjVif26k6GX9dlAwxw6XZWdkX1DKUWy9b1/JZjtUV/uxvFF871x
         WYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561898; x=1689153898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dryPugxzZVkqmEr4Pa67GWmkXSnMJtg4EXukR1I6igY=;
        b=HuSu0MRLaTaN3O4YaWeq78WtBIJ+yrrosKz685xJRIHJO2h6erALb7NMHorVGLF3vz
         lEM+AgMTIJQGbq0uuMl/BT76Nf1qeRreLLjTqZ6uVIPa5w5BnO1YCSbNwuLxwM9QOEzU
         KKRT+8PXQbmCNTJmRsJpvZHjp6lNJPSZKK+9LCcEezWizTk69N0/ih7mdXs/wzu7NiyO
         H32Kzq1RWGVJrJSvAvGLYa9ZyxKS4nlsSxcJxCICu9as83/5OC8GlM58lQBljigd9S2D
         YYKzv6cQ5BhvDqb/Ssdj2OmjPVPfBzK4Q9Ie0/XpjJrk3gNYb+UuO/ovwGAhEYsuMTVY
         IThQ==
X-Gm-Message-State: AC+VfDxVUcpsHUkw2Sc769fbarCLJnvs9ZduEhTDghfy2SJ4rAm99jmL
	dJ0t+0iHFg9JI4iI/m+iZTPopA==
X-Google-Smtp-Source: ACHHUZ6/WgeRAlOckrgLS0zRMcfX+zZiAUsCI9uNIKrNeiHrfd9lAY0ak9xFNLSV6WJDRUU7Ceefcg==
X-Received: by 2002:a7b:cd19:0:b0:3f7:536e:fff3 with SMTP id f25-20020a7bcd19000000b003f7536efff3mr5410313wmj.25.1686561897926;
        Mon, 12 Jun 2023 02:24:57 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:57 -0700 (PDT)
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
Subject: [PATCH 22/26] arm64: dts: qcom: sa8775p-ride: add the SGMII PHY node
Date: Mon, 12 Jun 2023 11:23:51 +0200
Message-Id: <20230612092355.87937-23-brgl@bgdev.pl>
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

Add the internal SGMII/SerDes PHY node for sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index b130136acffe..0e59000a0c82 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -1837,6 +1837,15 @@ adreno_smmu: iommu@3da0000 {
 				     <GIC_SPI 687 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		serdes_phy: phy@8901000 {
+			compatible = "qcom,sa8775p-dwmac-sgmii-phy";
+			reg = <0 0x08901000 0 0xe10>;
+			clocks = <&gcc GCC_SGMI_CLKREF_EN>;
+			clock-names = "sgmi_ref";
+			#phy-cells = <0>;
+			status = "disabled";
+		};
+
 		pdc: interrupt-controller@b220000 {
 			compatible = "qcom,sa8775p-pdc", "qcom,pdc";
 			reg = <0x0 0x0b220000 0x0 0x30000>,
-- 
2.39.2


