Return-Path: <netdev+bounces-11879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8842735000
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 073501C209A8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2993ED539;
	Mon, 19 Jun 2023 09:24:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E023D517
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:27 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7872812B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:25 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f900cd3f96so19578635e9.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166664; x=1689758664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePekGJ8XieE9NixEVRESpLaa1JhvD/weUEjagHex2MA=;
        b=stXeyAKFiBma9MHM5czXcrssZRC1jErp8AXW2Fa8I2556gbnr9ZR3eAm7LWOkt9U/J
         yDg1VDJ1jLiK1sHFJM7IN9YEToCipDXUUoeVD87J25vlIPosjONHyv7awdWlH0488U3g
         /okd2MFXSWmg+CD44rJvSFCylpjUoIzjCdWH5eXuyZm3yXnnN4Hmi7e+Bgoy8htaDRPl
         KMVq59xLm8pPOr1zcnH+S/WEssULK3T1SoJfubLXdxqJrjhhffoJi2NiVJYpJCYZXQul
         GpinTFwqcwT/89/3sdLeJQOkzTVNFdZ859QRai9ckSu9WQoJQyIX75eP5pqcTZ3UAaZV
         3sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166664; x=1689758664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePekGJ8XieE9NixEVRESpLaa1JhvD/weUEjagHex2MA=;
        b=CIevc9cuhpnFO6eHPQqQ502+aF3jgxaaRT8y2q0dzCPn4TG/BJZD84oCuRWC9IJUDe
         vtB/aa/6SCbVABQF3Ogc9h+3ItIhxzKVOqoDprH/hJ58NRjkAAYWTArbPD4eOAlVJkbD
         L1EjGTXN2ra8Y1n3Zm+91yNcIDv59tE9Gy0WKMLDzbmjQarYUJI+ET9Hc8DN7ffWFXJw
         E7HPsAZociilJKRGQwSCL6Vlkq7Pgq0YC9CRrCl+Bre5XDp758PgAABMqCSO7mviA+zc
         MmFUcHq7rPikaCXnY1rdoPQr7NelMJ2rz+a7lnYX0SeByLWj/afOnwWw27MJIeSGdzRl
         WbTw==
X-Gm-Message-State: AC+VfDx1ZrmMDbLTMzBfqKNVQhPpp5KFrzO9FM+sElApuxD/uYvy9DCY
	4XDuHXuWgoMmLD+4hQ08f7ZW4Q==
X-Google-Smtp-Source: ACHHUZ5R1zDalBxWMKNRehWDbQ8lRVG8zvqY54EpY1znGP+JKZfcPzxZW9HPRXLQpSbxiRtKcSldkg==
X-Received: by 2002:a7b:c014:0:b0:3f8:f1db:d206 with SMTP id c20-20020a7bc014000000b003f8f1dbd206mr6380789wmb.25.1687166664061;
        Mon, 19 Jun 2023 02:24:24 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:23 -0700 (PDT)
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
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [RESEND PATCH v2 10/14] net: stmmac: dwmac-qcom-ethqos: prepare the driver for more PHY modes
Date: Mon, 19 Jun 2023 11:23:58 +0200
Message-Id: <20230619092402.195578-11-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230619092402.195578-1-brgl@bgdev.pl>
References: <20230619092402.195578-1-brgl@bgdev.pl>
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
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 31 ++++++++++++++++---
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index a739e1d5c046..0ececc951528 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -92,11 +92,13 @@ struct ethqos_emac_driver_data {
 struct qcom_ethqos {
 	struct platform_device *pdev;
 	void __iomem *rgmii_base;
+	int (*configure_func)(struct qcom_ethqos *ethqos);
 
 	unsigned int link_clk_rate;
 	struct clk *link_clk;
 	struct phy *serdes_phy;
 	unsigned int speed;
+	int phy_mode;
 
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
@@ -331,13 +333,11 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
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
@@ -483,7 +483,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 	return 0;
 }
 
-static int ethqos_configure(struct qcom_ethqos *ethqos)
+static int ethqos_configure_rgmii(struct qcom_ethqos *ethqos)
 {
 	struct device *dev = &ethqos->pdev->dev;
 	volatile unsigned int dll_lock;
@@ -559,6 +559,11 @@ static int ethqos_configure(struct qcom_ethqos *ethqos)
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
@@ -650,6 +655,22 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
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


