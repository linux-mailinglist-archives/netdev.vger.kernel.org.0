Return-Path: <netdev+bounces-10037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFF672BC4A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B72C4280A76
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A7118C14;
	Mon, 12 Jun 2023 09:24:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BD618AE4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:44 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2F273D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:43 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f739ec88b2so29382845e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561882; x=1689153882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNG+hKxvwpveqfTw49rcUFiC9HYNGdqxVXCMwf/CgoQ=;
        b=Sjg97FxEsWi1+NhQKvwlVEh51XvKpb7L8qjO3eSPmnCp+RHYjPs6m0g4elcX7e4Gmk
         q3U1vLjkmrqHZnROyBs/n7xJkk00XMII9dTC69A/BMsdgUAKh6CQ1iVENWho3ieFJxOn
         kpyrUeEyJN+JmDe79C2O+6cXxwvHb2t7vltcUEEX9l5t3wSl7DONd9L87ujMUkqnmc3f
         QLazLkrv1GDOV/9vOl0n3uQDl7CvHNk+dcol5Iwbbh8SCOOuXpQsG0n4CHEkKYj0lKtl
         KjhlWUbdcnrDvJneJ/NH/roITps7vNV+XakPuvBg42ntql0DPxtDl5zempMyWZOl9HON
         Bzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561882; x=1689153882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNG+hKxvwpveqfTw49rcUFiC9HYNGdqxVXCMwf/CgoQ=;
        b=CNiJMB156ya6vHBWMtd5AId9lXN/A7mpjk5TAGUgJl1CmEndMfm4eTkUs3cjkLgBEK
         2/OyQhxj62yAh91+xMJ4jUGXIEGnkenNBL+U+fAH5kuPngbcq8M97hkLmKjf68hExXnt
         odjF3BTgrQKEsdI9XWMkSv4As8mR75kzYU+O8Ub/gTsdoMoBZMyzbTtjOksZ2eoNGLFR
         yv2lyelwgHFZfiR62HH4nO1TYpZLbzr+o+BLwAG2vp9UJkMIu5liOa9XuoJ2ALTl8BlW
         cR6GcpWQ+AOkxLS8YplkgZA1TRsxidRvtRhv+AxJBekZMD2wrfj22cRGq2GryxmbzAOX
         mgMg==
X-Gm-Message-State: AC+VfDwJ5Ax9LN1T1mExKFBh6SyjkglHfTuKxtw4IJ0Toxjzat1q+3it
	btRmzmSoemmdw4Pas5dgNOaWWA==
X-Google-Smtp-Source: ACHHUZ7VSDx8D3GXZ4VcJcb/TSs+3b96OTltaJznbz319l8jyj/BU/MtAxrNF5k8MF/YomUni4Onnw==
X-Received: by 2002:a1c:4c0c:0:b0:3f7:3699:c294 with SMTP id z12-20020a1c4c0c000000b003f73699c294mr5458505wmf.29.1686561882035;
        Mon, 12 Jun 2023 02:24:42 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:41 -0700 (PDT)
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
Subject: [PATCH 11/26] net: stmmac: dwmac-qcom-ethqos: remove stray space
Date: Mon, 12 Jun 2023 11:23:40 +0200
Message-Id: <20230612092355.87937-12-brgl@bgdev.pl>
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

There's an unnecessary space in the rgmii_updatel() function, remove it.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 5b56abacbf6b..8ed05f29fe8b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -117,7 +117,7 @@ static void rgmii_updatel(struct qcom_ethqos *ethqos,
 {
 	unsigned int temp;
 
-	temp =  rgmii_readl(ethqos, offset);
+	temp = rgmii_readl(ethqos, offset);
 	temp = (temp & ~(mask)) | val;
 	rgmii_writel(ethqos, temp, offset);
 }
-- 
2.39.2


