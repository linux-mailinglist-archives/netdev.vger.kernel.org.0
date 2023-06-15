Return-Path: <netdev+bounces-11105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1801E7318D7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49DCB1C2011F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3842519BAB;
	Thu, 15 Jun 2023 12:15:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1CC19E7E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:15:21 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6732D54
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:15:00 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-31110aea814so1114363f8f.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686831298; x=1689423298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+oBibPPOnuqccu7L9IO5LremAvXDtWRNvYzcCujyNTk=;
        b=tuEqi9i4Ph0PSiSFj08V9Ld+yK5DeaItEf2lQNOedOGslQF3uqYXEIqE70Q2LpkK8V
         yJcgyYU/xK27048sC68CaWAHZknJAsVoe4Ifz8sqfL1E8QeFA32UQMc/kTkXNiDI6tP4
         uhKiOYTZaVgCaPQ6E+9+iZZw2gHTEO6t8q298WJsxmMcT8hwXjAAMY/MB1iFJTD56Fca
         FIhjKR8+mGKE0Q8k2kMWsA7TWRlweVbHUKV0W3CTHurh7q4Q1NXjQl+ssAVBecumlsvb
         p1DZlxIGK8GtyCfRUGic2jvpUnq/AzONaJdAZMcB//LJ6mxtQXNbXgwocvOqHc0AnOQn
         kTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686831298; x=1689423298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+oBibPPOnuqccu7L9IO5LremAvXDtWRNvYzcCujyNTk=;
        b=OhMvHn3di8/u7ddVpGHtpUp8+Zd7NxwgVWEou0uSUOQkQGbAshWuNabVNkY47ftjLb
         jS3vGrxrI5nrQwalMPAfhovtFtAKlPVjXn8yMGM7ke2p126oG0vUfoINhK1VodkjoKdA
         gJG0hH9GajCztgGxTfSFrn1VSwkRGaMZiNGH+9unj1a3WBWj3Nx9K+7fdVwBR8EUaPk2
         5TZMEDws1iYA9bJU52j0nwWCsonloXMS5Cjbgyp4V6mJRgMquI/Jk1axwW/M6I5wQJgd
         rlAvTR1lNQh1Q/kYDFanDbg45FBXBz3v7zCJ//o9trw1aV+HIjKwoLufYN3mqEJl/qcf
         WW4Q==
X-Gm-Message-State: AC+VfDyOgOQ6cYNZmxK3Yi1tjGx+4MrmT+IgqI+ZMDZArV6ocoYFjwWU
	5x5OyzlJLDxoxnBkCZoL2yIzCQ==
X-Google-Smtp-Source: ACHHUZ6ZWQodqVPUoqZH+ejZVeVQzNWRZZfR2DFh8LleB/UOHED1PVt1RXk6g4EJuRbGiVA2Fh4hFQ==
X-Received: by 2002:adf:ed03:0:b0:30f:bff8:3f67 with SMTP id a3-20020adfed03000000b0030fbff83f67mr11881348wro.38.1686831298705;
        Thu, 15 Jun 2023 05:14:58 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:2ad4:65a7:d9f3:a64e])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d4291000000b003047ea78b42sm20918012wrq.43.2023.06.15.05.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 05:14:58 -0700 (PDT)
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
Subject: [PATCH v2 19/23] arm64: dts: qcom: sa8775p: add the SGMII PHY node
Date: Thu, 15 Jun 2023 14:14:15 +0200
Message-Id: <20230615121419.175862-20-brgl@bgdev.pl>
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
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add the internal SGMII/SerDes PHY node for sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index b130136acffe..b6d95813c98c 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -1837,6 +1837,15 @@ adreno_smmu: iommu@3da0000 {
 				     <GIC_SPI 687 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		serdes0: phy@8901000 {
+			compatible = "qcom,sa8775p-dwmac-sgmii-phy";
+			reg = <0x0 0x08901000 0x0 0xe10>;
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


