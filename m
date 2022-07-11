Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C16F56D2C1
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiGKBuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiGKBuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:50:06 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130073.outbound.protection.outlook.com [40.107.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338CB17E3F;
        Sun, 10 Jul 2022 18:49:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THUxVwWPLslXQs6xgHTp9M1+y+B59cSKlumQmE+9Lte3K9iSg7soPfyOLWz0tepuMu8k0aJoMyJEVkueNjIq17U7I0dDKCbKjVoE94sv+9bL5gorwlgomI+G//Bs0N1AUsIlRh/79rLyFEx2vyrJjLLdpStyOluaS0lbZrlNmfArnli9K2l7JIm60XGzhiuOc2rjl58hkOVUnMC+58OCV4WjchAWWSbRUVhT2FvUGwERIw8OIl0ZfuV4pnj9JySNMg2KQDBMrRHVMpDu9/OEl3Kcsf8yqV8X3l86xxwfJPjUSfS92MKlm/9g2ZThrbs3y2YfD1hlx7ScOlChxX73dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++vzzoHUBPEz0JcpnLfXgF8FkXFMzL3Qeb+EbxvQ0so=;
 b=GUo0k7rsYFxryCa7toqQWgdfuIwCcVbzwrTtigWnKbYmk1O8llhLPQm+2tiz/arw/jUsRCaU3lXd5WvzF8/Qn/Hz/b5Hf5v5PW2PTKL/vpC/UM3O64Df6y+e1k2WwC0nDsTl8WpS6rI7ffr4culmYlpvHElduQUU1TVUwGnXQFx0XQFANvHZm0/5R2J2dijM1K+SRMKPcqIJyQEpIeEtxROelGPmxGgafv02cHszijj4ZawturkNLPvL1Mgz4yEnIVM81mN4KX/JLxfkS3PD3VBNaF4EqoMzPgKiy+IQNVNh3rR/w9r0AkJ0XZdma2L3DvtUatVe01DlbF+XGomrtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++vzzoHUBPEz0JcpnLfXgF8FkXFMzL3Qeb+EbxvQ0so=;
 b=cJvKBT4I1AX1FyunyFpgViQYJElTj/GQscBjxcvZphFzTiv4zHtuzSECW+V9trEBdbs2WR1ROJR+qgB9vXlv4+gcfxCgVfGEeRcM+ggTUAfgGO0Nm0+xsM/f8RC/Z3cCD+LSzIz7EajUs3kNvjok3naeecJoB0qTgS50HWSoRic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6673.eurprd04.prod.outlook.com (2603:10a6:208:16a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 01:49:52 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 01:49:52 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V2 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Date:   Mon, 11 Jul 2022 19:44:34 +1000
Message-Id: <20220711094434.369377-4-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711094434.369377-1-wei.fang@nxp.com>
References: <20220711094434.369377-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcad9f76-6263-4bc4-530c-08da62dfa5bf
X-MS-TrafficTypeDiagnostic: AM0PR04MB6673:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50zlnbtipqRdHsr+xfEwagu3Ygw5RC/sxkN5/Qtt/Y2cFNLCFS2ed8ygWTtZfPmw7Qi9SxR1wx0B7g0Jai6AJFdfKpkr8ZdyJ+CVE3aM4SKqa0QEQBiUOc+of5KR4dYdrSktE2fiyQsVE1z1JUSYvovoTG/yZLfY/qAxNF+Ic87My5ISpyXqpX/h82Eplx02r2eF2Dpo6hdreo3lr6Aegk26o2dDmypBMt3WVx04ylypPnI4ywT0TFzalpnWkb5WHDuqYnl0DZdl+ABqnltXh2aQCVfVEGBN5KM33QKHSdG/ACQvv++ZL9crs3Zi+woWkPaIAQRUNYLAunLtzVwV+OEDCpvfllhIIx2HV5N5kglLOglpjCXgLFYlCoiqJG/+aKDI2GzV7C3cn68zPnOuwOD0lzzAHi/YOyBJ5X47OsJ0yfbfC7gV1eiP5sU8vUqMVLeXgo3wdllFGp3uOLBzYd7CVv+zLmMy/JrRvptUMqh3csR4BXTFfxIreCjT1TRXPfcVwJAndqFHL0I2JeBFw480W+0Ub4+2LLLwRkh8xPkEgxIPb7F4nS6zMzSDjMsgBU5rjjLAc7L2rWNOxzLr8J0Bk820YZt1rFa8f8asuDoHKFV+zR6KfLMv7LmaT7sxHd+iYsZtOGmheA7anc+ZacdTOJ+wOuq/A1HNJo7iDmnI1E78D9Gfj3fTpT3f/vwYPwR76OQU/l/hEnSAJrvb3RWOrqtlOUntKXjC/zaWyp6qFT1Znh67WbUWKz7BZgoYP7Jd3ZzB2uSUE4VlLF4xOriUiuw+RjW3560D+AWVM/rWg5xJS7D6Mq+KpZFlH7O80H/T8LWLLsvNIVaaMrIgPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(66946007)(66476007)(66556008)(6512007)(86362001)(8936002)(186003)(6666004)(8676002)(1076003)(4326008)(52116002)(6506007)(41300700001)(26005)(478600001)(6486002)(2616005)(38350700002)(316002)(38100700002)(2906002)(36756003)(44832011)(5660300002)(83380400001)(7416002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nzHfAQjKmaPTOkarn3yxup1SGWWGNL9dLTSZYZQl62xusICxCdjHzX8rXEXF?=
 =?us-ascii?Q?vDhpkWt9Ag2PgFwg7w5wtTAGA55uSUbsXBGqZ8YVQUQzQosmZXc4CjH87TI+?=
 =?us-ascii?Q?5bcd6mPNfdfT2Z+lQA+1+5/jAil3VLdH9mP1otBeJWONwCOQrSDwAWwzZeA2?=
 =?us-ascii?Q?YtCpX7FsKP5LgDuXsNe/HG9UdjmDLITdp430JFXyoV9oe2jzPWlPssFyTIHj?=
 =?us-ascii?Q?sQtw7o+9vmV0UOvZTKsrVxjeMe7lRpLBR6I4g8qfQ3HDO3erGtyLqp0DBIFU?=
 =?us-ascii?Q?MMmmWeWHohoC3kVsgKBKnjBAUSVLyTqjhqp1QOkZVbFkyQNjBW7TnMLXgYmZ?=
 =?us-ascii?Q?UznUaM7l9PVctrXdRwyVW1qrAPuww/PDwRrMGVuuzcUbVR7JbK8/h1yQNXPc?=
 =?us-ascii?Q?30mrJfkwkgNb9XjEaV0/jGZNfrwMpCX50r020hwAWU7tLpHEG0vFhF0p0X8w?=
 =?us-ascii?Q?uXwlIIhqXcPf3t3V0l7vuhzGQdW4RnEQ4mJH8TU1a//SMlgahwoupzRTZ8cp?=
 =?us-ascii?Q?NF+YV+8UPqGLHVAVaU8Ca/F9DroxMxQmGZEM8PCuaVHUbPV9XQ+lrmB7BzxE?=
 =?us-ascii?Q?O/4tnHZ+Jblji5a6cDNcebeDz0mxsyGvPw3AccPG3JkuvfGMfJpOj5Ul2W7M?=
 =?us-ascii?Q?NNe8vRC8Wwh7FjOwD+AHIuH11Drmh594v20KC0O1B0iUGM+CU8EVQTZEwCpy?=
 =?us-ascii?Q?OI+AWSS7/vswHQiDQPMlHi64FE+aNvk4t2FuFKt82vFqQX2DB9Xjd5WRWNWC?=
 =?us-ascii?Q?0+6jO+EhZIeZEfDCn5vdC0ZwNqfRJyiF8/TThmQT/isDdqx3cK/G86WlGkYr?=
 =?us-ascii?Q?VTiXeLz89Dt/Soq9qfWWvXJR8tvv+4G44N08muHZNn7xsTX5onk//D7OT7al?=
 =?us-ascii?Q?XGNiVnQsXHtGRcvVlNGp+uukeSG1VGGrStinqAG1/jsWFFBTxQmDYotH9X/T?=
 =?us-ascii?Q?Nu6w/J3HVmr09NJ+5iDZi0BsPSNyIGlai5JjDZarE/w+9wwOddDG2V6R11J4?=
 =?us-ascii?Q?fqQsJCS53LNxyXVxUOX5GuDZzFs7sRhBHAqNEzQyiaMuKhbnSWTK1uRkDU1K?=
 =?us-ascii?Q?i5+pDWAT/BqaMJsdicCLwcAPpLRKotD35efYgPbSoEdMDpCmlpEeGWZynkva?=
 =?us-ascii?Q?dxVvNCWXuljG9KiG8DTZn/gAJcqmmeSm+d5K+3ghPzvDPoijcDAHxvopZ0OH?=
 =?us-ascii?Q?g5c2IaomMD33rfaSvZ7i4sdPs3yp5etlEbplbbxiOqT7U5avpTqCuujvY3U2?=
 =?us-ascii?Q?c6k7eSOr0cU3Em00d68tXt1nOFpQUXJ/UXrKh2ZycBQV3LNb85r+dC8z9P34?=
 =?us-ascii?Q?TwLgtG/twmotBCeFrI9XpR6p0yZTVoUVbgyNcs9MzX4b6xNta0MKm4OAYo6h?=
 =?us-ascii?Q?YzIGzZ2uw3bGt54wg44zYefqFYqftKkVp/3/wnwC2GH8JFAZntUPrugH9hBz?=
 =?us-ascii?Q?lsHWDeCRYxejJOHlWb0OxClgJVnVK1Ew5BGLqO6McVMg/tMIQ5b/R/RFfK1E?=
 =?us-ascii?Q?oJvx0x0np/AEwx0RGxtRUS/s8VhaLNUXYQ/vRUTyaj+fKbGbTL3JRJW+E/M+?=
 =?us-ascii?Q?3+JMUbcNPwttJCFFAwZUBc82JefxZNuBVegaTttx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcad9f76-6263-4bc4-530c-08da62dfa5bf
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 01:49:52.6698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CA41/KAYupzJXDQXdA+XdmbXBuxOSL/386j3Ik4vaRqNf/j0nfAvSwQ5hjAMAwCeDBSb4YY9MNAOcc+v5/67Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6673
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the fec on i.MX8ULP EVK board.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Add clock_ext_rmii and clock_ext_ts. They are both related to EVK board.
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 33e84c4e9ed8..ebce716b10e6 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -19,6 +19,21 @@ memory@80000000 {
 		device_type = "memory";
 		reg = <0x0 0x80000000 0 0x80000000>;
 	};
+
+	clock_ext_rmii: clock-ext-rmii {
+		compatible = "fixed-clock";
+		clock-frequency = <50000000>;
+		clock-output-names = "ext_rmii_clk";
+		#clock-cells = <0>;
+	};
+
+	clock_ext_ts: clock-ext-ts {
+		compatible = "fixed-clock";
+		/* External ts clock is 50MHZ from PHY on EVK board. */
+		clock-frequency = <50000000>;
+		clock-output-names = "ext_ts_clk";
+		#clock-cells = <0>;
+	};
 };
 
 &lpuart5 {
@@ -38,7 +53,49 @@ &usdhc0 {
 	status = "okay";
 };
 
+&fec {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&pinctrl_enet>;
+	pinctrl-1 = <&pinctrl_enet>;
+	clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
+		 <&pcc4 IMX8ULP_CLK_ENET>,
+		 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
+		 <&clock_ext_rmii>;
+	clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
+	assigned-clocks = <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>;
+	assigned-clock-parents = <&clock_ext_ts>;
+	phy-mode = "rmii";
+	phy-handle = <&ethphy>;
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			reg = <1>;
+			micrel,led-mode = <1>;
+		};
+	};
+};
+
 &iomuxc1 {
+	pinctrl_enet: enetgrp {
+		fsl,pins = <
+			MX8ULP_PAD_PTE15__ENET0_MDC     0x43
+			MX8ULP_PAD_PTE14__ENET0_MDIO    0x43
+			MX8ULP_PAD_PTE17__ENET0_RXER    0x43
+			MX8ULP_PAD_PTE18__ENET0_CRS_DV  0x43
+			MX8ULP_PAD_PTF1__ENET0_RXD0     0x43
+			MX8ULP_PAD_PTE20__ENET0_RXD1    0x43
+			MX8ULP_PAD_PTE16__ENET0_TXEN    0x43
+			MX8ULP_PAD_PTE23__ENET0_TXD0    0x43
+			MX8ULP_PAD_PTE22__ENET0_TXD1    0x43
+			MX8ULP_PAD_PTE19__ENET0_REFCLK  0x43
+			MX8ULP_PAD_PTF10__ENET0_1588_CLKIN 0x43
+		>;
+	};
+
 	pinctrl_lpuart5: lpuart5grp {
 		fsl,pins = <
 			MX8ULP_PAD_PTF14__LPUART5_TX	0x3
-- 
2.25.1

