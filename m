Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A224CA261
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiCBKkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbiCBKkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:40:53 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDE1BECEB
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:40:06 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z11so1202040pla.7
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 02:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OW6Vzq0apzZ0AvI5XYyUy01zZckjEhZ83VWyjEGv1M=;
        b=lxb5ga3VT2jhzJzOvy/QTv1oGLd8ZdoJf29WIXqBa7cDDqZcmYiqSfbXwiC+bo484R
         rvULaR6bCyDxTl6cE1/UB6zyP+N2xmjciFjbkjCJULIfn65SIXDSrAKvaBQ9QEMkbifz
         yPHGw41EvzJopM+AGQaPMN8FlmR5ewdhu0Kvmu9osMpAaSFV6MgMlIpBspPlHT6gcsE3
         2WvBiP5tAdfvKeTRciolbdItL/bblTAqpx6KM561EOy0Mk68z8FiXMRELdsYxRP2tnrZ
         DHJfYphDZJVFKiDZsoHu0oNP3lCPreoozlXG5QCyPLEmltUXX4xZWaRuL/aXj7gSWi7j
         B7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OW6Vzq0apzZ0AvI5XYyUy01zZckjEhZ83VWyjEGv1M=;
        b=W5DdO+sTV7wXnKGr+vxd8ST24v7Y8qH/gGOPwMSwjSb/n2Xrpu1TxueyG4SjnLyCKa
         8JPoronzgOB7tzSqrCH+dOQZ7SHaS9NqjT0Fw7Hu/Y/f14z11DdiNoewXbwDyvppSUSD
         N5QzZvP+ywPLG5f6grEw6yVsdlBnbqnR8jRGUK9T+RinNjVVWY3KqCwLlAA21g/MwMxx
         IhpoLBXBPuoipC5qmXwd3PFlH6uINtummmCSLWAcJigK0JawpB6yCbAgvRrjYF3NFkt1
         +bw7wdINLRzsjQIjKGjPvGj0ugcWAw3IOz67xGORkgp4FkJoxyA09BRV4nFHXKOgvk3e
         5VEg==
X-Gm-Message-State: AOAM533WMemNY1JAT++EBHYPC9TXoV6lF0zhiV1IEdJJE68He3mOvuRU
        2EHwL+9n6yX5FU1uCfD2xbcsXBaXFKqR9g==
X-Google-Smtp-Source: ABdhPJxBX9zldaofDMQXAyS43Qk+pwolnE7L6eIRQD0Ydlk47m5P4RU24uvzpKq26vhLtsXNxAIS8g==
X-Received: by 2002:a17:902:ef52:b0:151:84fe:bccb with SMTP id e18-20020a170902ef5200b0015184febccbmr7215972plx.9.1646217605772;
        Wed, 02 Mar 2022 02:40:05 -0800 (PST)
Received: from localhost.localdomain ([171.50.175.145])
        by smtp.gmail.com with ESMTPSA id m20-20020a634c54000000b003739af127c9sm15612308pgl.70.2022.03.02.02.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 02:40:05 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     netdev@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        vkoul@kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: [PATCH v2 2/2 net-next] net: stmmac: dwmac-qcom-ethqos: Adjust rgmii loopback_en per platform
Date:   Wed,  2 Mar 2022 16:09:50 +0530
Message-Id: <20220302103950.30356-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302103950.30356-1-bhupesh.sharma@linaro.org>
References: <20220302103950.30356-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

Not all platforms should have RGMII_CONFIG_LOOPBACK_EN and the result it
about 50% packet loss on incoming messages. So make it possile to
configure this per compatible and enable it for QCS404.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 8cdba9d521ec..0cc28c79cc61 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -78,6 +78,7 @@ struct ethqos_emac_por {
 struct ethqos_emac_driver_data {
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
+	bool rgmii_config_looback_en;
 };
 
 struct qcom_ethqos {
@@ -90,6 +91,7 @@ struct qcom_ethqos {
 
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
+	bool rgmii_config_looback_en;
 };
 
 static int rgmii_readl(struct qcom_ethqos *ethqos, unsigned int offset)
@@ -181,6 +183,7 @@ static const struct ethqos_emac_por emac_v2_3_0_por[] = {
 static const struct ethqos_emac_driver_data emac_v2_3_0_data = {
 	.por = emac_v2_3_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_3_0_por),
+	.rgmii_config_looback_en = true,
 };
 
 static const struct ethqos_emac_por emac_v2_1_0_por[] = {
@@ -195,6 +198,7 @@ static const struct ethqos_emac_por emac_v2_1_0_por[] = {
 static const struct ethqos_emac_driver_data emac_v2_1_0_data = {
 	.por = emac_v2_1_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_1_0_por),
+	.rgmii_config_looback_en = false,
 };
 
 static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
@@ -311,8 +315,12 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
-		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-			      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+		if (ethqos->rgmii_config_looback_en)
+			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+				      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+		else
+			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+				      0, RGMII_IO_MACRO_CONFIG);
 		break;
 
 	case SPEED_100:
@@ -345,8 +353,13 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
-		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-			      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+		if (ethqos->rgmii_config_looback_en)
+			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+				      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+		else
+			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+				      0, RGMII_IO_MACRO_CONFIG);
+
 		break;
 
 	case SPEED_10:
@@ -518,6 +531,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	data = of_device_get_match_data(&pdev->dev);
 	ethqos->por = data->por;
 	ethqos->num_por = data->num_por;
+	ethqos->rgmii_config_looback_en = data->rgmii_config_looback_en;
 
 	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
-- 
2.35.1

