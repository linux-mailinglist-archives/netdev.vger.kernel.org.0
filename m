Return-Path: <netdev+bounces-11094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 991A27318C6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B13611C20E68
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4352F1772D;
	Thu, 15 Jun 2023 12:14:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C8117AAC
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:14:48 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B676F2695
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:14:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-30c4775d05bso5764841f8f.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686831284; x=1689423284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cX9gh1Qiyxf8dBz8QJPkiT5qyQqbjJsIR5XZjH6yJKE=;
        b=4UidRm4NNnXMzbr03wDLiofz3gX/tDVsDRsFiIt2GCKZr9xu3kI3P/1iiyrEJ5Id0l
         EzcZmwPFk4KIx5xPw9EDsNFkzGrWlKEz2/lL9Scukx1QVBxwkHGKqQO7qqWiYFEy9gAX
         gMXHPGdLbhLTwfinx9c/Iihysp3xzIJADktLaJXZXyVMVMmCCzwFDqfT46YWevyF0Gw4
         3jcMVKq/yipZ4k9KzmgWDKWJZ2sls3WArB4uKiSLIMYUJcuEt3HFTdyPZPiPhRZhQzd2
         mrk/2WuFpO2/FFs9d9Z1XS0rK4NA+ZYPTfWUp1ynrCJugfErdrCLs3OENDmtHRFMJ9vP
         IuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686831284; x=1689423284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cX9gh1Qiyxf8dBz8QJPkiT5qyQqbjJsIR5XZjH6yJKE=;
        b=AadPI++fjQpa2vphG6+jTJpwOFfBjXlaGGdYQVvX9k0QzBHg/0EB68Cimlk8SuSQI1
         EHq5/0oP319OGrsnqT6P/q1vsqoTf5ebrjl/q/U4kjBhQuYMHNEKP2wTp6cZNomWX32x
         to7NFaAiVD9TBZtS74P1S3kQc2zyETFSMd2dI5hZ0VUYVLWqMEU1uQSGfqR05yziS6pk
         OgVr2F1rQJUrqKMKy1SqBBQwH48CZbeY5GOC2Oh7kfrUHF0vs4oXLY8poO5zgJ+QS1QT
         rry9qJDYka8o13occC34bTcDwsnmmXOnkpriqk2sGjNCdikUPR3I8t28QdVkHZBEFTq7
         C26w==
X-Gm-Message-State: AC+VfDyLDAbuTAC5HBwhtIexkxGnVS4obvnnBZtZBAqx0xzojN3+gXQI
	xJTKgQw8EDMhF9yv9WBt9/Jz4A==
X-Google-Smtp-Source: ACHHUZ4kkzeyF5iFPaPt1a1Bfq+qLf+3zfTeM2Z6V1K2TWdpT7Rg5m3uWYN1Eu2tqs3PLNAhAI/vmw==
X-Received: by 2002:a5d:668c:0:b0:311:13e6:6504 with SMTP id l12-20020a5d668c000000b0031113e66504mr1501402wru.47.1686831283884;
        Thu, 15 Jun 2023 05:14:43 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:2ad4:65a7:d9f3:a64e])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d4291000000b003047ea78b42sm20918012wrq.43.2023.06.15.05.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 05:14:43 -0700 (PDT)
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v2 08/23] net: stmmac: dwmac-qcom-ethqos: use a helper variable for &pdev->dev
Date: Thu, 15 Jun 2023 14:14:04 +0200
Message-Id: <20230615121419.175862-9-brgl@bgdev.pl>
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

Shrink code and avoid line breaks by using a helper variable for
&pdev->dev.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 49 ++++++++++---------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 28d2514a8795..f0776ddea3ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -123,25 +123,26 @@ static void rgmii_updatel(struct qcom_ethqos *ethqos,
 static void rgmii_dump(void *priv)
 {
 	struct qcom_ethqos *ethqos = priv;
+	struct device *dev = &ethqos->pdev->dev;
 
-	dev_dbg(&ethqos->pdev->dev, "Rgmii register dump\n");
-	dev_dbg(&ethqos->pdev->dev, "RGMII_IO_MACRO_CONFIG: %x\n",
+	dev_dbg(dev, "Rgmii register dump\n");
+	dev_dbg(dev, "RGMII_IO_MACRO_CONFIG: %x\n",
 		rgmii_readl(ethqos, RGMII_IO_MACRO_CONFIG));
-	dev_dbg(&ethqos->pdev->dev, "SDCC_HC_REG_DLL_CONFIG: %x\n",
+	dev_dbg(dev, "SDCC_HC_REG_DLL_CONFIG: %x\n",
 		rgmii_readl(ethqos, SDCC_HC_REG_DLL_CONFIG));
-	dev_dbg(&ethqos->pdev->dev, "SDCC_HC_REG_DDR_CONFIG: %x\n",
+	dev_dbg(dev, "SDCC_HC_REG_DDR_CONFIG: %x\n",
 		rgmii_readl(ethqos, SDCC_HC_REG_DDR_CONFIG));
-	dev_dbg(&ethqos->pdev->dev, "SDCC_HC_REG_DLL_CONFIG2: %x\n",
+	dev_dbg(dev, "SDCC_HC_REG_DLL_CONFIG2: %x\n",
 		rgmii_readl(ethqos, SDCC_HC_REG_DLL_CONFIG2));
-	dev_dbg(&ethqos->pdev->dev, "SDC4_STATUS: %x\n",
+	dev_dbg(dev, "SDC4_STATUS: %x\n",
 		rgmii_readl(ethqos, SDC4_STATUS));
-	dev_dbg(&ethqos->pdev->dev, "SDCC_USR_CTL: %x\n",
+	dev_dbg(dev, "SDCC_USR_CTL: %x\n",
 		rgmii_readl(ethqos, SDCC_USR_CTL));
-	dev_dbg(&ethqos->pdev->dev, "RGMII_IO_MACRO_CONFIG2: %x\n",
+	dev_dbg(dev, "RGMII_IO_MACRO_CONFIG2: %x\n",
 		rgmii_readl(ethqos, RGMII_IO_MACRO_CONFIG2));
-	dev_dbg(&ethqos->pdev->dev, "RGMII_IO_MACRO_DEBUG1: %x\n",
+	dev_dbg(dev, "RGMII_IO_MACRO_DEBUG1: %x\n",
 		rgmii_readl(ethqos, RGMII_IO_MACRO_DEBUG1));
-	dev_dbg(&ethqos->pdev->dev, "EMAC_SYSTEM_LOW_POWER_DEBUG: %x\n",
+	dev_dbg(dev, "EMAC_SYSTEM_LOW_POWER_DEBUG: %x\n",
 		rgmii_readl(ethqos, EMAC_SYSTEM_LOW_POWER_DEBUG));
 }
 
@@ -242,6 +243,7 @@ static const struct ethqos_emac_driver_data emac_v3_0_0_data = {
 
 static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 {
+	struct device *dev = &ethqos->pdev->dev;
 	unsigned int val;
 	int retry = 1000;
 
@@ -279,7 +281,7 @@ static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 		retry--;
 	} while (retry > 0);
 	if (!retry)
-		dev_err(&ethqos->pdev->dev, "Clear CK_OUT_EN timedout\n");
+		dev_err(dev, "Clear CK_OUT_EN timedout\n");
 
 	/* Set CK_OUT_EN */
 	rgmii_updatel(ethqos, SDCC_DLL_CONFIG_CK_OUT_EN,
@@ -296,7 +298,7 @@ static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 		retry--;
 	} while (retry > 0);
 	if (!retry)
-		dev_err(&ethqos->pdev->dev, "Set CK_OUT_EN timedout\n");
+		dev_err(dev, "Set CK_OUT_EN timedout\n");
 
 	/* Set DDR_CAL_EN */
 	rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DDR_CAL_EN,
@@ -322,12 +324,13 @@ static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 
 static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 {
+	struct device *dev = &ethqos->pdev->dev;
 	int phase_shift;
 	int phy_mode;
 	int loopback;
 
 	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
-	phy_mode = device_get_phy_mode(&ethqos->pdev->dev);
+	phy_mode = device_get_phy_mode(dev);
 	if (phy_mode == PHY_INTERFACE_MODE_RGMII_ID ||
 	    phy_mode == PHY_INTERFACE_MODE_RGMII_TXID)
 		phase_shift = 0;
@@ -468,8 +471,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 	default:
-		dev_err(&ethqos->pdev->dev,
-			"Invalid speed %d\n", ethqos->speed);
+		dev_err(dev, "Invalid speed %d\n", ethqos->speed);
 		return -EINVAL;
 	}
 
@@ -478,6 +480,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 
 static int ethqos_configure(struct qcom_ethqos *ethqos)
 {
+	struct device *dev = &ethqos->pdev->dev;
 	volatile unsigned int dll_lock;
 	unsigned int i, retry = 1000;
 
@@ -540,8 +543,7 @@ static int ethqos_configure(struct qcom_ethqos *ethqos)
 			retry--;
 		} while (retry > 0);
 		if (!retry)
-			dev_err(&ethqos->pdev->dev,
-				"Timeout while waiting for DLL lock\n");
+			dev_err(dev, "Timeout while waiting for DLL lock\n");
 	}
 
 	if (ethqos->speed == SPEED_1000)
@@ -597,6 +599,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	const struct ethqos_emac_driver_data *data;
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
+	struct device *dev = &pdev->dev;
 	struct qcom_ethqos *ethqos;
 	int ret;
 
@@ -606,13 +609,13 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 
 	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat)) {
-		dev_err(&pdev->dev, "dt configuration failed\n");
+		dev_err(dev, "dt configuration failed\n");
 		return PTR_ERR(plat_dat);
 	}
 
 	plat_dat->clks_config = ethqos_clks_config;
 
-	ethqos = devm_kzalloc(&pdev->dev, sizeof(*ethqos), GFP_KERNEL);
+	ethqos = devm_kzalloc(dev, sizeof(*ethqos), GFP_KERNEL);
 	if (!ethqos) {
 		ret = -ENOMEM;
 		goto out_config_dt;
@@ -625,13 +628,13 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 		goto out_config_dt;
 	}
 
-	data = of_device_get_match_data(&pdev->dev);
+	data = of_device_get_match_data(dev);
 	ethqos->por = data->por;
 	ethqos->num_por = data->num_por;
 	ethqos->rgmii_config_loopback_en = data->rgmii_config_loopback_en;
 	ethqos->has_emac3 = data->has_emac3;
 
-	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
+	ethqos->rgmii_clk = devm_clk_get(dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
 		ret = PTR_ERR(ethqos->rgmii_clk);
 		goto out_config_dt;
@@ -641,7 +644,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_config_dt;
 
-	ret = devm_add_action_or_reset(&pdev->dev, ethqos_clks_disable, ethqos);
+	ret = devm_add_action_or_reset(dev, ethqos_clks_disable, ethqos);
 	if (ret)
 		goto out_config_dt;
 
@@ -660,7 +663,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
 		plat_dat->rx_clk_runs_in_lpi = 1;
 
-	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
+	ret = stmmac_dvr_probe(dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto out_config_dt;
 
-- 
2.39.2


