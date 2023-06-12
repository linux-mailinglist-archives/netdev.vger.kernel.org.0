Return-Path: <netdev+bounces-10050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D80472BC9E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ECD3280F94
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6530D1C747;
	Mon, 12 Jun 2023 09:25:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B491B8E7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:25:03 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E23420E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f63ab1ac4aso4691520e87.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561899; x=1689153899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GgOU29bwSmA1xmnYvgN48ffEdaMQtMdjrdVTUnvg0aY=;
        b=vyX9Q+kD9G1p5rZ6oHppIAZRDTqqLuaLmmx8ER/1w9clbWGVKsqSzOZIssSGm8lUKA
         dlBs3V+g8fkc6+a3VNSEJc5CAKqMBwCpBJobp58ZPlkjDf4gYm8MeEiyGt0H3nYapjdU
         rLNaG8AWbRv39nWwT4gHrrsq2bGBt/mjyDGKhCQVoeiOFWfkZWRsJ8TQOz31yUf3AvL5
         nw3BwJ8ocxS+TzBLzPUgr5JBsXuA1EbH4qK8yPDA2P/kQJF+Z+Aujhld1mA4LMr+t/W/
         D+y18SR7STIM5gSDK9/lewz4exGG34D7uUb6LQAITMMCYN23tDt0IYL700rjOgmkyHSJ
         iMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561899; x=1689153899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GgOU29bwSmA1xmnYvgN48ffEdaMQtMdjrdVTUnvg0aY=;
        b=hCnpaVcM5+XaA6Dk8tWE9SbAITy7lwdjXSJi50a9iITtLxUO8WP5kfojklOcNLyvj1
         Uv7CpbD8SkjPzxMvDgS1Mr9IgFNnuY45CSkaVqCD5n1fSrTrogn3ef0H9gfSXUoWlMZS
         Blg+ent31UnRatBEeeHc+YmNy8AZk0L5tBmJDT1/WB8n08mE3fkQUi+mV0uDwPA+fukw
         OGHznHUY6kUoQLgI6ijIaBe58cMgT5oBgY7UC13WE/Dc4xxfBUHWgiKfQAUF7y1J971H
         g4wMQ3le+RavcRATDeBQ+QvcA21H7VYR1RSJtBwwkjPLZkpTxlTE/+icw/9TPaPQt3c+
         N9/Q==
X-Gm-Message-State: AC+VfDyoMX5ZS0u/BRfMBM/2fgbHXycZJU3x8P0emlRTIEbhW1R5+j+s
	177OYRttW80mMfrU4lRtojPpfQ==
X-Google-Smtp-Source: ACHHUZ4zEjuyJv27H7TYosddbPT1hcVmJ0AeF5dGbiGkRiAcC5SK9xkn5i3NEKXynfbxTRLbQZV0aQ==
X-Received: by 2002:a19:6550:0:b0:4f4:b218:e85f with SMTP id c16-20020a196550000000b004f4b218e85fmr2780825lfj.31.1686561899243;
        Mon, 12 Jun 2023 02:24:59 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:58 -0700 (PDT)
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
Subject: [PATCH 23/26] arm64: dts: qcom: sa8775p: add the first 1Gb ethernet interface
Date: Mon, 12 Jun 2023 11:23:52 +0200
Message-Id: <20230612092355.87937-24-brgl@bgdev.pl>
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
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add the node for the first ethernet interface on sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 30 +++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 0e59000a0c82..f43a2a5d1d11 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2315,6 +2315,36 @@ cpufreq_hw: cpufreq@18591000 {
 
 			#freq-domain-cells = <1>;
 		};
+
+		ethernet0: ethernet@23040000 {
+			compatible = "qcom,sa8775p-ethqos";
+			reg = <0x0 0x23040000 0x0 0x10000>,
+			      <0x0 0x23056000 0x0 0x100>;
+			reg-names = "stmmaceth", "rgmii";
+
+			clocks = <&gcc GCC_EMAC0_AXI_CLK>,
+				 <&gcc GCC_EMAC0_SLV_AHB_CLK>,
+				 <&gcc GCC_EMAC0_PTP_CLK>,
+				 <&gcc GCC_EMAC0_PHY_AUX_CLK>;
+			clock-names = "stmmaceth", "pclk", "ptp_ref", "phyaux";
+
+			power-domains = <&gcc EMAC0_GDSC>;
+
+			interrupts = <GIC_SPI 946 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "macirq";
+
+			phys = <&serdes_phy>;
+			phy-names = "serdes";
+
+			iommus = <&apps_smmu 0x120 0xf>;
+
+			snps,tso;
+			snps,pbl = <32>;
+			rx-fifo-depth = <16384>;
+			tx-fifo-depth = <16384>;
+
+			status = "disabled";
+		};
 	};
 
 	arch_timer: timer {
-- 
2.39.2


