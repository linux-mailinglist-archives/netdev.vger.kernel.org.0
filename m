Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AD76B7E79
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCMRA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjCMRAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:00:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B837C3D2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678726693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=froEIgd/jTK8vMet67sF4Svy58nAbygAJuDZdwZXRoo=;
        b=bUXgj8S8YumsAln3yZzgCEgIc9ixPEjmLDbxyT1T+pE/MNCqP0R5eW0GO1Ia04Ija7rR39
        7Q55D/ANfaJLg5g7zHnRTYxtsUzAqrdO/LMqoWYdj0jPnT5jjXzAQ8N2h0inVjVArqBZIg
        AfiVK7a27CXARRZZ1GgR5cJp6IztJK0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-txtBeXI_OA66S1P0Am7zZA-1; Mon, 13 Mar 2023 12:58:11 -0400
X-MC-Unique: txtBeXI_OA66S1P0Am7zZA-1
Received: by mail-ot1-f70.google.com with SMTP id o8-20020a9d5c08000000b00693d403480aso6352310otk.3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=froEIgd/jTK8vMet67sF4Svy58nAbygAJuDZdwZXRoo=;
        b=TsNeIRYgnLfuAIp+98RREkVb1542Q3XqyPbPf+mq5qPfx/uasLpd+v05+Z154By6Vy
         yd+qVzfmdLKEhs/UQDzM9A/YTcX3a68PXz/aHaKv1F0jhXhdC/PMLj+VCz+q3FqzozrR
         ZNbshwdiGcNCwmyPaRpZVUtPf9TbFo39QaBTeliBtKl6pyQ12U1tncFNPieHI0L74UsB
         T9yDt5MGXTt/y57WmoT+Fi7ysmIFuvc0J1GoJbuAMTBL0IUO8JlstGgODlXwwTLk17hW
         mgWmIuQXN2/lEqponhUUjaJFVdZwy69OD1jwzJyWhmj7DNwj57hx5qdswXXq1vxfVKgk
         JcMA==
X-Gm-Message-State: AO0yUKW+SSOC2GsFqb+AZpF4g84GYkVUOINXIOG3PtwKgJ4U1PgHuWjY
        l4x3qTX3Q11QisIv6pIocSY4sRsriVAJe73N1Wfwqv39lDk8D+n6pOubNm6L5ZzS05fKAhP3PvC
        YOE6Xeporex9xIHoI
X-Received: by 2002:a54:4581:0:b0:378:2e00:6059 with SMTP id z1-20020a544581000000b003782e006059mr15770433oib.1.1678726690908;
        Mon, 13 Mar 2023 09:58:10 -0700 (PDT)
X-Google-Smtp-Source: AK7set8X44l7dingJY4lbAaZ9yFhn0nDh44RPwEhNJsvKqOkTtMVNPiHzSyxK0fYFUg/FLZGJbjJZw==
X-Received: by 2002:a54:4581:0:b0:378:2e00:6059 with SMTP id z1-20020a544581000000b003782e006059mr15770404oib.1.1678726690652;
        Mon, 13 Mar 2023 09:58:10 -0700 (PDT)
Received: from halaney-x13s.attlocal.net ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id o2-20020acad702000000b00384d3003fa3sm3365273oig.26.2023.03.13.09.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:58:10 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next 10/11] net: ethernet: stmmac: dwmac-qcom-ethqos: Use loopback_en for all speeds
Date:   Mon, 13 Mar 2023 11:56:19 -0500
Message-Id: <20230313165620.128463-11-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313165620.128463-1-ahalaney@redhat.com>
References: <20230313165620.128463-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that this variable should be used for all speeds, not just
1000/100.

While at it refactor it slightly to be more readable, including fixing
the typo in the variable name.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 6f272cae330d..778852934e36 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -78,7 +78,7 @@ struct ethqos_emac_por {
 struct ethqos_emac_driver_data {
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
-	bool rgmii_config_looback_en;
+	bool rgmii_config_loopback_en;
 };
 
 struct qcom_ethqos {
@@ -91,7 +91,7 @@ struct qcom_ethqos {
 
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
-	bool rgmii_config_looback_en;
+	bool rgmii_config_loopback_en;
 };
 
 static int rgmii_readl(struct qcom_ethqos *ethqos, unsigned int offset)
@@ -183,7 +183,7 @@ static const struct ethqos_emac_por emac_v2_3_0_por[] = {
 static const struct ethqos_emac_driver_data emac_v2_3_0_data = {
 	.por = emac_v2_3_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_3_0_por),
-	.rgmii_config_looback_en = true,
+	.rgmii_config_loopback_en = true,
 };
 
 static const struct ethqos_emac_por emac_v2_1_0_por[] = {
@@ -198,7 +198,7 @@ static const struct ethqos_emac_por emac_v2_1_0_por[] = {
 static const struct ethqos_emac_driver_data emac_v2_1_0_data = {
 	.por = emac_v2_1_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_1_0_por),
-	.rgmii_config_looback_en = false,
+	.rgmii_config_loopback_en = false,
 };
 
 static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
@@ -281,6 +281,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 {
 	int phy_mode;
 	int phase_shift;
+	int loopback;
 
 	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
 	phy_mode = device_get_phy_mode(&ethqos->pdev->dev);
@@ -293,6 +294,12 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 	rgmii_updatel(ethqos, RGMII_CONFIG2_TX_TO_RX_LOOPBACK_EN,
 		      0, RGMII_IO_MACRO_CONFIG2);
 
+	/* Determine if this platform wants loopback enabled after programming */
+	if (ethqos->rgmii_config_loopback_en)
+		loopback = RGMII_CONFIG_LOOPBACK_EN;
+	else
+		loopback = 0;
+
 	/* Select RGMII, write 0 to interface select */
 	rgmii_updatel(ethqos, RGMII_CONFIG_INTF_SEL,
 		      0, RGMII_IO_MACRO_CONFIG);
@@ -325,12 +332,8 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
-		if (ethqos->rgmii_config_looback_en)
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
-		else
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      0, RGMII_IO_MACRO_CONFIG);
+		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 
 	case SPEED_100:
@@ -362,13 +365,8 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
-		if (ethqos->rgmii_config_looback_en)
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
-		else
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      0, RGMII_IO_MACRO_CONFIG);
-
+		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 
 	case SPEED_10:
@@ -402,7 +400,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-			      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 	default:
 		dev_err(&ethqos->pdev->dev,
@@ -547,7 +545,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	data = of_device_get_match_data(&pdev->dev);
 	ethqos->por = data->por;
 	ethqos->num_por = data->num_por;
-	ethqos->rgmii_config_looback_en = data->rgmii_config_looback_en;
+	ethqos->rgmii_config_loopback_en = data->rgmii_config_loopback_en;
 
 	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
-- 
2.39.2

