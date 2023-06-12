Return-Path: <netdev+bounces-10042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82CE572BC64
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C29191C2093A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707E11992D;
	Mon, 12 Jun 2023 09:24:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633DA1992C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:53 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B2430F4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:51 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f78a32266bso41291815e9.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561889; x=1689153889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WtiGUP9ra+nN5+GqOB+XAIPugwOoW0PwoEeYaWXDQls=;
        b=ewW4ilPWNv7194ancCa8h4Y2nB9YHWmOOTZiAPChRO1LOfZRRdXY/Q3X6OjGm5QyED
         tzZCF5qaleZ00eF4KQLSjPLPk0TNPsnKTOsx1fxBzPooOeCLgmEZO5nQjr7l6tFLgkGG
         1LOt8o7G8ubTSO0VPXoauA3uLBTwM2nytfqbwwophk78EeKKzwtErTWeIxU2wLFl7y2j
         KwWADOmvCOeU5Rm1K6AjUUnsQsZ/qLncaNkUlaE3uC/dgn61R0oY2Htjc0phFZVhW6va
         P1mlE2HiQxyKUAfTNmtu+HrwE7ov3+pP2vTpYOFzD2ppmg7FNeZ+c8ipUBfuQsficczr
         85+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561889; x=1689153889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WtiGUP9ra+nN5+GqOB+XAIPugwOoW0PwoEeYaWXDQls=;
        b=Tr9mcLj6Jrw7QE9oe+sTyuhM/30zl4kV6+qAal/1U/5/w9S52pXH6iDtmcv431XBYS
         4uhOjywa82eJEIZYjwN6SQngKQAYpaf5oKf5USy9EmKGmexD4BLpNKva7KzpMfTGiLlU
         oCZRfZf73HZ2DqRrFeCtg8dbHkLQt9sGNFiTZV75aRFItBwf8M8tcDQGYuI4xsToMKrL
         QKgaeajVXgk2h1edrE8SXyQ7sRDVevjzig2ZTET6SMw37b0vrp2i4pQvT9q10N8aqiN5
         OUB9BZVD4d6yXlgBAm3ebSTFAuS7q0ykUBddwarNXdzGyQPT2Ln31MiA0I/LT7BjDOu+
         3gDw==
X-Gm-Message-State: AC+VfDxLZ0eyYCvMXExBj4zEJFg7ZBeGA1USQab96HLtYUp5kGQOD33V
	TrhBH5E/crzXOKSvjX7JTDrU8Q==
X-Google-Smtp-Source: ACHHUZ7G+zYHl342266e7renMY1/jG2Z7MG3iQRcKeI8tKXg+RpONFzFBLeozTMO3uKFJ5OCB8zY3Q==
X-Received: by 2002:a05:600c:2204:b0:3f7:35a9:dfdf with SMTP id z4-20020a05600c220400b003f735a9dfdfmr6517067wml.24.1686561889654;
        Mon, 12 Jun 2023 02:24:49 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:48 -0700 (PDT)
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
Subject: [PATCH 16/26] net: stmmac: dwmac-qcom-ethqos: prepare the driver for more PHY modes
Date: Mon, 12 Jun 2023 11:23:45 +0200
Message-Id: <20230612092355.87937-17-brgl@bgdev.pl>
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

In preparation for supporting SGMII, let's make the code a bit more
generic. Add a new callback for MAC configuration so that we can assign
a different variant of it in the future.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 31 ++++++++++++++++---
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 21f329d2f7eb..2f96f2c11278 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -92,12 +92,14 @@ struct ethqos_emac_driver_data {
 struct qcom_ethqos {
 	struct platform_device *pdev;
 	void __iomem *rgmii_base;
+	int (*configure_func)(struct qcom_ethqos *ethqos);
 
 	unsigned int rgmii_clk_rate;
 	struct clk *rgmii_clk;
 	struct clk *phyaux_clk;
 	struct phy *serdes_phy;
 	unsigned int speed;
+	int phy_mode;
 
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
@@ -332,13 +334,11 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 {
 	struct device *dev = &ethqos->pdev->dev;
 	int phase_shift;
-	int phy_mode;
 	int loopback;
 
 	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
-	phy_mode = device_get_phy_mode(dev);
-	if (phy_mode == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phy_mode == PHY_INTERFACE_MODE_RGMII_TXID)
+	if (ethqos->phy_mode == PHY_INTERFACE_MODE_RGMII_ID ||
+	    ethqos->phy_mode == PHY_INTERFACE_MODE_RGMII_TXID)
 		phase_shift = 0;
 	else
 		phase_shift = RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN;
@@ -485,7 +485,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 	return 0;
 }
 
-static int ethqos_configure(struct qcom_ethqos *ethqos)
+static int ethqos_configure_rgmii(struct qcom_ethqos *ethqos)
 {
 	struct device *dev = &ethqos->pdev->dev;
 	volatile unsigned int dll_lock;
@@ -561,6 +561,11 @@ static int ethqos_configure(struct qcom_ethqos *ethqos)
 	return 0;
 }
 
+static int ethqos_configure(struct qcom_ethqos *ethqos)
+{
+	return ethqos->configure_func(ethqos);
+}
+
 static void ethqos_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct qcom_ethqos *ethqos = priv;
@@ -660,6 +665,22 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		goto out_config_dt;
 	}
 
+	ethqos->phy_mode = device_get_phy_mode(dev);
+	switch (ethqos->phy_mode) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		ethqos->configure_func = ethqos_configure_rgmii;
+		break;
+	case -ENODEV:
+		ret = -ENODEV;
+		goto out_config_dt;
+	default:
+		ret = -EINVAL;
+		goto out_config_dt;
+	}
+
 	ethqos->pdev = pdev;
 	ethqos->rgmii_base = devm_platform_ioremap_resource_byname(pdev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_base)) {
-- 
2.39.2


