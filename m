Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D6F6D4E6E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjDCQxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjDCQx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:53:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3F01FC2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680540758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aNnj54KJ3sbCKgW+uG5+7ZfwR/tDYMYsDLk8WGo+8hY=;
        b=b8hTHBxT4GR0PjOTopet1qcUBnoCQ6R7vVAYeckji7HPGpkvUPqh7hMyldlfiBU8Mqeyza
        A+CmnKhbD2wyr8XlcJXZA9BsPVNOT9DNrjEH9dMebsQuA2swSfImDLwm6xPkjXql/tc2cX
        cTFY/gfAj4Bv11xHXMDlgAkExBEcc7U=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-52w_Elh1N-y9kMPJSM6-ug-1; Mon, 03 Apr 2023 12:52:34 -0400
X-MC-Unique: 52w_Elh1N-y9kMPJSM6-ug-1
Received: by mail-ot1-f71.google.com with SMTP id k29-20020a9d701d000000b006a037b882d8so11041331otj.16
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 09:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680540754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNnj54KJ3sbCKgW+uG5+7ZfwR/tDYMYsDLk8WGo+8hY=;
        b=2FMCpzMVRfIkgrgx2v5XZBntNtkrRXry2QwfR0qERguk3WfQNs3fWweMIN9P6lchGx
         KtxUbfF68feg/TlKTAK9B17ON57hgIXIfVbJI7dVKJIhnJiAXKAlAYRJhQPCQIn4cYhy
         By+6EN8n1ixl9brydP+fxFAbpaZ5G7jGnsqsKL4qkfAp8UwPV4NgHdg1Ov7Rf0Y/mJ/F
         KG1BdXS/AYaaOKquarRrz+osuIVIka3jnoV1jkEqhTLX/pi3Q0yXhiikHJSRLcaB8Fcj
         EkyjpBxY6NhTFN40CvESEN6ZtKaqo4td5wr+8nxsosRXDkX0QFn7wQVZxSHvP9d+smJC
         UbbA==
X-Gm-Message-State: AO0yUKWPzhGyLFEMD8BQDfni4DVTCBC+rsNpbE9+alHW+UZZAN4YW/Q9
        OttmrfIAlwPSasjV9hPxeXpu7vWIsmorAHUFZQovQubKakjBfut+Dsls5TbFyI86d8rZ6tT/mlj
        VVfb0b4SLmA8rR24z
X-Received: by 2002:a54:4e0f:0:b0:387:11d6:d48d with SMTP id a15-20020a544e0f000000b0038711d6d48dmr14701104oiy.37.1680540753799;
        Mon, 03 Apr 2023 09:52:33 -0700 (PDT)
X-Google-Smtp-Source: AK7set8nyuqGQ1cBcxKMmZtMf+X7ml0tFy8hvmMAEAn00O8xx7UksN2AreJp5ikhVn74Xutm5tAIaw==
X-Received: by 2002:a54:4e0f:0:b0:387:11d6:d48d with SMTP id a15-20020a544e0f000000b0038711d6d48dmr14701091oiy.37.1680540753503;
        Mon, 03 Apr 2023 09:52:33 -0700 (PDT)
Received: from halaney-x13s (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id w129-20020a4a5d87000000b005414543377asm772820ooa.20.2023.04.03.09.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:52:33 -0700 (PDT)
Date:   Mon, 3 Apr 2023 11:52:29 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: [PATCH net-next v3 12/12] net: stmmac: dwmac-qcom-ethqos: Add EMAC3
 support
Message-ID: <20230403165229.4jhpo2xs7tuclekw@halaney-x13s>
References: <20230331214549.756660-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331214549.756660-1-ahalaney@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new programming sequence needed for EMAC3 based platforms such
as the sc8280xp family.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

This originally did not make it to the list somehow, but was intended
to. Apologies in advance if appending it like this is inappropriate, but
after thinking about it more I think that works better than doing a
RESEND (and making current comments difficult to track) or spinning a
v4, without addressing comments in this version entirely. I'm eager to
get some feedback on this, and I've got some property damage at home
to deal with so I'm sending it this way instead of waiting for further
advice on how to deal with me dropping it on accident.

I know the Qualcomm team has looked at earlier versions of this offlist,
but I'd appreciate any feedback I can get (good or bad) for this patch
since it is a lot of programming that I took entirely from downstream
after modifying to be more upstream appropriate (i.e., I do not have
documentation for the IP, be it this implementation or the generic
docs).

Thanks in advance and sorry again about it getting dropped from the
original submission!

Changes since v2:
    * Adjust to the new method of defining the MTL/DMA offsets in the
      platform glue

Changes since v1:
    * None

 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 121 +++++++++++++++---
 1 file changed, 100 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index ec9e93147716..f47ae62a5662 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -11,6 +11,7 @@
 
 #define RGMII_IO_MACRO_CONFIG		0x0
 #define SDCC_HC_REG_DLL_CONFIG		0x4
+#define SDCC_TEST_CTL			0x8
 #define SDCC_HC_REG_DDR_CONFIG		0xC
 #define SDCC_HC_REG_DLL_CONFIG2		0x10
 #define SDC4_STATUS			0x14
@@ -49,6 +50,7 @@
 #define SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY	GENMASK(26, 21)
 #define SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_CODE	GENMASK(29, 27)
 #define SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN	BIT(30)
+#define SDCC_DDR_CONFIG_TCXO_CYCLES_CNT		GENMASK(11, 9)
 #define SDCC_DDR_CONFIG_PRG_RCLK_DLY		GENMASK(8, 0)
 
 /* SDCC_HC_REG_DLL_CONFIG2 fields */
@@ -79,6 +81,8 @@ struct ethqos_emac_driver_data {
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
 	bool rgmii_config_loopback_en;
+	bool has_emac3;
+	struct dwmac4_addrs dwmac4_addrs;
 };
 
 struct qcom_ethqos {
@@ -92,6 +96,7 @@ struct qcom_ethqos {
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
 	bool rgmii_config_loopback_en;
+	bool has_emac3;
 };
 
 static int rgmii_readl(struct qcom_ethqos *ethqos, unsigned int offset)
@@ -184,6 +189,7 @@ static const struct ethqos_emac_driver_data emac_v2_3_0_data = {
 	.por = emac_v2_3_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_3_0_por),
 	.rgmii_config_loopback_en = true,
+	.has_emac3 = false,
 };
 
 static const struct ethqos_emac_por emac_v2_1_0_por[] = {
@@ -199,6 +205,39 @@ static const struct ethqos_emac_driver_data emac_v2_1_0_data = {
 	.por = emac_v2_1_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_1_0_por),
 	.rgmii_config_loopback_en = false,
+	.has_emac3 = false,
+};
+
+static const struct ethqos_emac_por emac_v3_0_0_por[] = {
+	{ .offset = RGMII_IO_MACRO_CONFIG,	.value = 0x40c01343 },
+	{ .offset = SDCC_HC_REG_DLL_CONFIG,	.value = 0x2004642c },
+	{ .offset = SDCC_HC_REG_DDR_CONFIG,	.value = 0x80040800 },
+	{ .offset = SDCC_HC_REG_DLL_CONFIG2,	.value = 0x00200000 },
+	{ .offset = SDCC_USR_CTL,		.value = 0x00010800 },
+	{ .offset = RGMII_IO_MACRO_CONFIG2,	.value = 0x00002060 },
+};
+
+static const struct ethqos_emac_driver_data emac_v3_0_0_data = {
+	.por = emac_v3_0_0_por,
+	.num_por = ARRAY_SIZE(emac_v3_0_0_por),
+	.rgmii_config_loopback_en = false,
+	.has_emac3 = true,
+	.dwmac4_addrs = {
+		.dma_chan = 0x00008100,
+		.dma_chan_offset = 0x1000,
+		.mtl_chan = 0x00008000,
+		.mtl_chan_offset = 0x1000,
+		.mtl_ets_ctrl = 0x00008010,
+		.mtl_ets_ctrl_offset = 0x1000,
+		.mtl_txq_weight = 0x00008018,
+		.mtl_txq_weight_offset = 0x1000,
+		.mtl_send_slp_cred = 0x0000801c,
+		.mtl_send_slp_cred_offset = 0x1000,
+		.mtl_high_cred = 0x00008020,
+		.mtl_high_cred_offset = 0x1000,
+		.mtl_low_cred = 0x00008024,
+		.mtl_low_cred_offset = 0x1000,
+	},
 };
 
 static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
@@ -222,11 +261,13 @@ static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 	rgmii_updatel(ethqos, SDCC_DLL_CONFIG_DLL_EN,
 		      SDCC_DLL_CONFIG_DLL_EN, SDCC_HC_REG_DLL_CONFIG);
 
-	rgmii_updatel(ethqos, SDCC_DLL_MCLK_GATING_EN,
-		      0, SDCC_HC_REG_DLL_CONFIG);
+	if (!ethqos->has_emac3) {
+		rgmii_updatel(ethqos, SDCC_DLL_MCLK_GATING_EN,
+			      0, SDCC_HC_REG_DLL_CONFIG);
 
-	rgmii_updatel(ethqos, SDCC_DLL_CDR_FINE_PHASE,
-		      0, SDCC_HC_REG_DLL_CONFIG);
+		rgmii_updatel(ethqos, SDCC_DLL_CDR_FINE_PHASE,
+			      0, SDCC_HC_REG_DLL_CONFIG);
+	}
 
 	/* Wait for CK_OUT_EN clear */
 	do {
@@ -261,18 +302,20 @@ static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 	rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DDR_CAL_EN,
 		      SDCC_DLL_CONFIG2_DDR_CAL_EN, SDCC_HC_REG_DLL_CONFIG2);
 
-	rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DLL_CLOCK_DIS,
-		      0, SDCC_HC_REG_DLL_CONFIG2);
+	if (!ethqos->has_emac3) {
+		rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DLL_CLOCK_DIS,
+			      0, SDCC_HC_REG_DLL_CONFIG2);
 
-	rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_MCLK_FREQ_CALC,
-		      0x1A << 10, SDCC_HC_REG_DLL_CONFIG2);
+		rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_MCLK_FREQ_CALC,
+			      0x1A << 10, SDCC_HC_REG_DLL_CONFIG2);
 
-	rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DDR_TRAFFIC_INIT_SEL,
-		      BIT(2), SDCC_HC_REG_DLL_CONFIG2);
+		rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DDR_TRAFFIC_INIT_SEL,
+			      BIT(2), SDCC_HC_REG_DLL_CONFIG2);
 
-	rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DDR_TRAFFIC_INIT_SW,
-		      SDCC_DLL_CONFIG2_DDR_TRAFFIC_INIT_SW,
-		      SDCC_HC_REG_DLL_CONFIG2);
+		rgmii_updatel(ethqos, SDCC_DLL_CONFIG2_DDR_TRAFFIC_INIT_SW,
+			      SDCC_DLL_CONFIG2_DDR_TRAFFIC_INIT_SW,
+			      SDCC_HC_REG_DLL_CONFIG2);
+	}
 
 	return 0;
 }
@@ -327,9 +370,17 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      RGMII_CONFIG2_RX_PROG_SWAP,
 			      RGMII_IO_MACRO_CONFIG2);
 
-		/* Set PRG_RCLK_DLY to 57 for 1.8 ns delay */
-		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
-			      57, SDCC_HC_REG_DDR_CONFIG);
+		/* PRG_RCLK_DLY = TCXO period * TCXO_CYCLES_CNT / 2 * RX delay ns,
+		 * in practice this becomes PRG_RCLK_DLY = 52 * 4 / 2 * RX delay ns
+		 */
+		if (ethqos->has_emac3)
+			/* 0.9 ns */
+			rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
+				      115, SDCC_HC_REG_DDR_CONFIG);
+		else
+			/* 1.8 ns */
+			rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
+				      57, SDCC_HC_REG_DDR_CONFIG);
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
@@ -355,8 +406,15 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      BIT(6), RGMII_IO_MACRO_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_RSVD_CONFIG15,
 			      0, RGMII_IO_MACRO_CONFIG2);
-		rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
-			      0, RGMII_IO_MACRO_CONFIG2);
+
+		if (ethqos->has_emac3)
+			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
+				      RGMII_CONFIG2_RX_PROG_SWAP,
+				      RGMII_IO_MACRO_CONFIG2);
+		else
+			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
+				      0, RGMII_IO_MACRO_CONFIG2);
+
 		/* Write 0x5 to PRG_RCLK_DLY_CODE */
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_CODE,
 			      (BIT(29) | BIT(27)), SDCC_HC_REG_DDR_CONFIG);
@@ -389,8 +447,13 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      RGMII_IO_MACRO_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_RSVD_CONFIG15,
 			      0, RGMII_IO_MACRO_CONFIG2);
-		rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
-			      0, RGMII_IO_MACRO_CONFIG2);
+		if (ethqos->has_emac3)
+			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
+				      RGMII_CONFIG2_RX_PROG_SWAP,
+				      RGMII_IO_MACRO_CONFIG2);
+		else
+			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
+				      0, RGMII_IO_MACRO_CONFIG2);
 		/* Write 0x5 to PRG_RCLK_DLY_CODE */
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_CODE,
 			      (BIT(29) | BIT(27)), SDCC_HC_REG_DDR_CONFIG);
@@ -433,6 +496,17 @@ static int ethqos_configure(struct qcom_ethqos *ethqos)
 	rgmii_updatel(ethqos, SDCC_DLL_CONFIG_PDN,
 		      SDCC_DLL_CONFIG_PDN, SDCC_HC_REG_DLL_CONFIG);
 
+	if (ethqos->has_emac3) {
+		if (ethqos->speed == SPEED_1000) {
+			rgmii_writel(ethqos, 0x1800000, SDCC_TEST_CTL);
+			rgmii_writel(ethqos, 0x2C010800, SDCC_USR_CTL);
+			rgmii_writel(ethqos, 0xA001, SDCC_HC_REG_DLL_CONFIG2);
+		} else {
+			rgmii_writel(ethqos, 0x40010800, SDCC_USR_CTL);
+			rgmii_writel(ethqos, 0xA001, SDCC_HC_REG_DLL_CONFIG2);
+		}
+	}
+
 	/* Clear DLL_RST */
 	rgmii_updatel(ethqos, SDCC_DLL_CONFIG_DLL_RST, 0,
 		      SDCC_HC_REG_DLL_CONFIG);
@@ -452,7 +526,9 @@ static int ethqos_configure(struct qcom_ethqos *ethqos)
 			      SDCC_HC_REG_DLL_CONFIG);
 
 		/* Set USR_CTL bit 26 with mask of 3 bits */
-		rgmii_updatel(ethqos, GENMASK(26, 24), BIT(26), SDCC_USR_CTL);
+		if (!ethqos->has_emac3)
+			rgmii_updatel(ethqos, GENMASK(26, 24), BIT(26),
+				      SDCC_USR_CTL);
 
 		/* wait for DLL LOCK */
 		do {
@@ -547,6 +623,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	ethqos->por = data->por;
 	ethqos->num_por = data->num_por;
 	ethqos->rgmii_config_loopback_en = data->rgmii_config_loopback_en;
+	ethqos->has_emac3 = data->has_emac3;
 
 	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
@@ -566,6 +643,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->fix_mac_speed = ethqos_fix_mac_speed;
 	plat_dat->dump_debug_regs = rgmii_dump;
 	plat_dat->has_gmac4 = 1;
+	plat_dat->dwmac4_addrs = &data->dwmac4_addrs;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
 	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
@@ -603,6 +681,7 @@ static int qcom_ethqos_remove(struct platform_device *pdev)
 
 static const struct of_device_id qcom_ethqos_match[] = {
 	{ .compatible = "qcom,qcs404-ethqos", .data = &emac_v2_3_0_data},
+	{ .compatible = "qcom,sc8280xp-ethqos", .data = &emac_v3_0_0_data},
 	{ .compatible = "qcom,sm8150-ethqos", .data = &emac_v2_1_0_data},
 	{ }
 };
-- 
2.39.2

