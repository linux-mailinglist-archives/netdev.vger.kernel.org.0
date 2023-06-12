Return-Path: <netdev+bounces-10051-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5390C72BCA6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 943471C20AFB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7286A1C755;
	Mon, 12 Jun 2023 09:25:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A161B8E7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:25:04 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396CA3A80
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f7378a75c0so29531865e9.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561901; x=1689153901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLaMx9+e4iuA9k0HKzXztUaaZBEZ9bpdRm0ATPtxSFs=;
        b=Z0vGtlAOr73GZC/Gj6eNFC/9k2Sm7GthQ5ThOHdTEND/fWcqoz9SHGZU7g4Oejo0+B
         RaV6BZ/igQvP2b+/IrEGbCH17+t+nX1v97JhXRnct3KrN+NH+rKKSmNU5mCdV4b8VRdx
         LxPR1YJ1FiMBcCV/4psL9l/br0kTlIiTM9S2TXH8Yt5k/l/Yji6lXbMjA3yDLYaN1t5F
         yTkATjmoZYcy0mVncUpNLUH8UkjQNLy9HERgoOXFhfpbFPFdkrhehA7+aktL68oKI3fc
         VfoghKsM37C8k9q6fKStc7pJd2JFqcOuHZ/fiUcQndVgIGO+EMPW0QhTOi40Ae765TFr
         GNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561901; x=1689153901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CLaMx9+e4iuA9k0HKzXztUaaZBEZ9bpdRm0ATPtxSFs=;
        b=iMHGXugKhmDTauEPmgOcQT2RTwU0vztivgd5THD93Idm9BP8yp8jNjNSrlmGUGOIPa
         uqr/TjNnKoLZ6ibBP37THhNKbttN6O+ku1mryI5bJApdODZ5FAhTK7B7FfjuaF9hKC0y
         4imXK9C/zw5pAru6JNlFeXnprlYEp8MxOEDjNx6XOBN/xr/uLV5leZdBUvSprIfkwB6+
         FRTg7z+EzZDh3/+zoRpOo0djo3jj8eIsLUB7Tzr0I77nqjbHKPH0jxOPHvBz2/Kx7iuq
         YHnFaJK7wnLd9qWji26jmzosMtqDmbCKEdWgaOoD7cVfrcZeJqbHtV+2bKdX2PHAd76g
         Br1A==
X-Gm-Message-State: AC+VfDzhHPoWhId4Cgq5iDvmW2vQOuxOYouKDu3pdMtbKZ4GRxu+SNti
	nR2fMcx3m0Mi2QwiCK8x/wmEVw==
X-Google-Smtp-Source: ACHHUZ7qP7/SyTOU8/DDIX68G7BFQneP8olbAA34G/JnNTqmm2c9ABxgMYXONRfwTSOTiB3F/nspiw==
X-Received: by 2002:a05:600c:284a:b0:3f7:e818:1eb with SMTP id r10-20020a05600c284a00b003f7e81801ebmr5507867wmb.40.1686561901784;
        Mon, 12 Jun 2023 02:25:01 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:25:01 -0700 (PDT)
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
Subject: [PATCH 25/26] arm64: dts: qcom: sa8775p-ride: add pin functions for ethernet0
Date: Mon, 12 Jun 2023 11:23:54 +0200
Message-Id: <20230612092355.87937-26-brgl@bgdev.pl>
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

Add the MDC and MDIO pin functions for ethernet0 on sa8775p-ride.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
index 7754788ea775..dbd9553aa5c7 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
@@ -370,6 +370,22 @@ &spi16 {
 };
 
 &tlmm {
+	ethernet0_default: ethernet0-default-state {
+		ethernet0_mdc: ethernet0-mdc-pins {
+			pins = "gpio8";
+			function = "emac0_mdc";
+			drive-strength = <16>;
+			bias-pull-up;
+		};
+
+		ethernet0_mdio: ethernet0-mdio-pins {
+			pins = "gpio9";
+			function = "emac0_mdio";
+			drive-strength = <16>;
+			bias-pull-up;
+		};
+	};
+
 	qup_uart10_default: qup-uart10-state {
 		pins = "gpio46", "gpio47";
 		function = "qup1_se3";
-- 
2.39.2


