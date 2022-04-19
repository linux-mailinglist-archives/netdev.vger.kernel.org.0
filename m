Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C03506ADD
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiDSLjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351616AbiDSLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CECE32996;
        Tue, 19 Apr 2022 04:35:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZbef+ob4UTOzJfs4iowOl1RzkmMvi4vOy9FaBcdjje1qQ93PKCrwcKrOx7HHM2S67RIprLhfq2sNsiau8QbXb5C+nlm03UtCfMWBtvqYDimMbdEKm6zcg0uF0k1fxGSVkKZMw+PvcHIiNwq2uvinvZw4weFFZAZcbP4zfajIa5LStIQy2fEgAcPQVdfOOvOJK4qth5U2ykv9KUFc8niqoTCKSrtbR4ZWM5SBtGoMbuzo8/HyNVemZcT+0mMP7SNAqxmXzi+U8sAxpU+R0EZ7+eaoRC6XdK4YPxs8m6gavEAXtMLab1KR0vt8lOceJMAbd2pKyc94ReRf1KHF5Omjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=JaWHigKsKxKl3Ka460nyGDcAvWZTBcAjndAiwhGujCc2f1C9szdA7nl81A39Q5Soh7Bf0MkCcp+HussuR6vqocZW0VjS01XORbnVGeVqSphapEwd+lsg2T3wEwkcUwOdNZ68YRmhkAC7e8ssATutpES2wMD/vhXFUbql6aRWIYw5x3Ha4j5xTGxetzbG53OUvpnq5sXiUBtFVBOpMB+fwfXINlXw+z3Ax7G55y69FILOoBHOF0ZQvCbrG4PVVWcZwgqj1sACmMW0/h3VorWuPzkgiJ/qJp74pd/FeSnv17dSdR6ky3JlsHTj3v0aC8zbPhPiUvSyykRHInFMTO3QaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQHTsT2sINIWmo6XZFNIWNkEQkLYeh03JwRb243M0s0=;
 b=EvFtr6OwoOcw7S9OeugZBF+ImXwosAj+emT3efl11orFbxfw429fx3tqzw77eLg/NTcyFThRpH2ccIpRCOQGGceciW/K9Q6Wm7iz8FxSPxSH4ka6CMUMhth9jfl85IJ5guSOagehE8nsuEYuXfY8wFxqbz9tRgpen52G3+a8u8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:32 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:32 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Clark Wang <xiaoning.wang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v8 02/13] arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
Date:   Tue, 19 Apr 2022 14:35:05 +0300
Message-Id: <20220419113516.1827863-3-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419113516.1827863-1-abel.vesa@nxp.com>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31bc7606-630b-4df1-1789-08da21f8b663
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB30549BB35703767267D881F4F6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAmsoKawnDKdbhUJNdU3QSoqnHYl97vs43738lI43BURihubgD0w4rkRY3CdyZ2H3A2qHuAP/VvXMRX3h6zLpSUWZf9GyXwZuuhlnJ6f4oPAK9W5VlLAr9VinB7n+yA/HCQY6z/jRRHXv/6aAe/2Grl2DFxAaHnfb+Aga/MuYqe0p0iiwkMB3QFWtr1csF6VEfXT/h6w5pNOBfL6UEm2ShKGfEjBIbno/H2FTjCzPm85pW+B5kswxS5SZnY7zXoGjmLXs2ccK1HLJ/HgCv0AiwwnQR4o/HEoyEvrnMjAMCcrr4PTHu5aAgpQxy3HOl89JzwixaVz7eUrc5uasIdeJK0KODczZuAl1q5gyn8frs+GtWvJdMFgtTI+2+E86sU5tlI3upPuvTc1Dt7G4FLKr2RNOf/43TcD7wwWsFHlOcHP650gtRAQfzcTUg4+u/6r9fx2Ix+TGvioL5cw9TiW6bdKS/k4uzMeZExyx2Kl+EuoshQkLnF56Pan0gJK6t1x1vyPVcByZVx1SNgsNLVF6Q7YFj2lmDVBhF13jonH+OwJTAJQxaI5dx5E3VEI3duD3urRuPKCaePCGCMipB1XACUV71x+voaPrJSKJYOl1/wX08I9C47WdFvl26tVn4NaCtbKk6CWvzhAgqNUsfyqGleFcvrw49Ph3KOZi8norfhPSqngob/n5Tp3hSMQdlwl13Kp2n6sZJozTK9YrpZ7FiJ4VmjYioIt+PUkr+200z0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZRf1+j97n5E7NcpRo+p8hYvQ4I0R/2rzNP8RZGic9AFwdhHMRUEmWA8Vnm3X?=
 =?us-ascii?Q?BSJe/GBFfGyp9uQSOgnztAZPB50hPtn6nDVjYc0D87c+wSiDlAnMZ7bsAq0e?=
 =?us-ascii?Q?+8zt33FVFx7NrizCrsay+5n6VNKjgnDCpr9dzwWpjBwkjlmr/8L+naffOhkS?=
 =?us-ascii?Q?92SUnuHlUqsjly4sZEHB9pQPezMf/wk4askrIxTp6yaau7HKgVbiccU0b5FJ?=
 =?us-ascii?Q?8LaKhsl5YZARTajtxSZL/v5xCFCNgsnlsRJZpbynQgIZ/+Xjlxt2mM5NleWg?=
 =?us-ascii?Q?96Vp8xcOuXIDrFcg3W2IJlmv+yP1ly7Is6uqq1JmgSLjzzxaMBmgdcNFOx8b?=
 =?us-ascii?Q?qfynbpmvdOjbk0l9UAMM7ownq1HdEYreSv+LAlu+4lolJsXyKx2MpMIiV2VS?=
 =?us-ascii?Q?C7G5AtJTf2sRpUjRFDWO/+/Htaf1vNznpagLJfiCzW3qtHTuhDsdslWzgYYd?=
 =?us-ascii?Q?KnK3XJSyoUorm9eDH54g1vX4tAFB7R3iC9qu9v1v3McUvej1Rltf+2nqNs5w?=
 =?us-ascii?Q?v50TZpA7uVpdZhY4j/fc1Nm+RWUkohAyhIcN0Y1Q+I/cYDGYrzM97Cha+bfL?=
 =?us-ascii?Q?kXeT/uPvY4GkT373Sii8+hzAps93pLfUYGozOOdT2soAASIO8/9KVcm4Bnzo?=
 =?us-ascii?Q?A+x2Vm8zttKaP4J1IPQ8Non8p3Ae4gjjm7QkFIC6SmQhv0wyXpuCbPJ9n2ck?=
 =?us-ascii?Q?Xq5yr7JAkcz29JldBpGEcpn6EghRBlG8TuZOLIIOlpd1iwqoXl0iErkUlWb5?=
 =?us-ascii?Q?jnmeA2maHLVzEBIv/7m45LDdk9Ep/jTBgCS8KsbpQtomVU4lOvyUlUQrckSG?=
 =?us-ascii?Q?v4MynSaNK5RKMEH1k6XEC8gW8tsSL2jKXhBsf316FwQSSHltI2NsP/FJnCF4?=
 =?us-ascii?Q?UyYSkgDInnrXHc3b5uDI6qxxpr/wgYC73Rqd/snnxYvvQu7jzaAnZ6fOLD9o?=
 =?us-ascii?Q?+GjGd4dAQSojKVX+g9kutklrL6Ysz+iAY6F11PEpBGjhW7ZtIDRhTOvDwKEp?=
 =?us-ascii?Q?Xym5sKqEXKQVoqeI/8uvxjht0UVUhQ03nbA3vFi7rmh59oMiLhPzN9JNisH7?=
 =?us-ascii?Q?Vwd01PW2Mm6uCGQi2UAZjzwf8/jNEGj+nncspeIU71SiLbzYH2LmwZ8TWTEH?=
 =?us-ascii?Q?N2n1lAoFQWHnmg3A7roHsM5CzkkWp2MtlUmN06IdMS1+YRlPd8UvhAO3kC2K?=
 =?us-ascii?Q?wnQ8TvRC7SgUoMDHCs3rDGsZj3MNNVaVeReCJ5FJ77js7J5Awhb/GOrzxfJ4?=
 =?us-ascii?Q?OO4hDjApFar9WsMqy02kX0xGPKuVOCwpi7iTejvtUnqI79xwA5LM9haWWtjX?=
 =?us-ascii?Q?WPzJDrlSDfqFwrW6Ch7P/4rS72EdgyoDFiTOes/+tgEPuTKobJbiPoDlY000?=
 =?us-ascii?Q?2o7T8WzEcL3yf9gcc6LD+H0QdhJeIyuqJavuBMpe2XsRMKINIYu8tvMUW0eD?=
 =?us-ascii?Q?8dD5sUZs0JiaaNhygDkg0dMySwismZal4gO9wOP18M3ZX1Acf3D7uTb+Z5VL?=
 =?us-ascii?Q?Bop0RglYvfxdMJc+atgJbEiWZPt08gwI5pt+B5c63q53IdRzf7W50FZCCIEy?=
 =?us-ascii?Q?0Fq7u5gd67p9RoUhHQSzTv0yorxowrZ2woNNLlcQiT17Bvd6FM2HlVRjFU/u?=
 =?us-ascii?Q?xY1AnGdGGFSXeiilafKgvBtc/8qZ4JUr7XDcsQXHmci21Z6Sw5MG4fROr25r?=
 =?us-ascii?Q?pP6RSKv5xRP7LM4TOcw+gV2ExylcUHhdcKUyoYAajseuMdx8L31IqSR/E61+?=
 =?us-ascii?Q?5sPWITqWKA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31bc7606-630b-4df1-1789-08da21f8b663
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:32.3462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvD55E0JBCbAt1uzAu+MsAGGxQyRzkRe/pfH+0TQj6+5uiRDuaejNDfPTWwZREJyGOtnJMFrrFujcvxSs69EkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3054
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Override the I2Cs, LPUARTs, audio_ipg_clk and dma_ipg_clk with
the i.MX8DXL specific properties.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
new file mode 100644
index 000000000000..4d0c75bad74c
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+&audio_ipg_clk {
+	clock-frequency = <160000000>;
+};
+
+&dma_ipg_clk {
+	clock-frequency = <160000000>;
+};
+
+&i2c0 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 222 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c1 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c2 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c3 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart0 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 228 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart1 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart2 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 230 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart3 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.1

