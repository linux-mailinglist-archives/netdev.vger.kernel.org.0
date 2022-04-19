Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FE95069D8
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351135AbiDSLYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351121AbiDSLYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:06 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C032657;
        Tue, 19 Apr 2022 04:21:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ff9seCicoB48xChO/kb+fer4pLxVfHL37DyuyNAlRUDplEI6trujQO3x9mPnr/l+7Qj93FnmUCWlsmIeneen4Pigjih/revUjZTUX40b1oFXZvdYjXpRk8faVJ915wLMPT5zjHORA9nkKLQpGJ/xDp9M0/Dy9vCYy6Q0RTQ3K6MyARVyznluWZQtI1XGg5TomXoDGlldX0czeRnKMQawQPicH07MeT5NRUoZsjWVc7LijCZ/oTEGyyuoyToPrTIMp77xmt2qJwB06tpZL8S5S5IiR7B9xGLfyhj7YuUSeYdhYWAxX89NHhUzpx4uFsPUOaftBkynD5yG+Cc6Y+CAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGhlujPNw3n5+6sBIsiPsew9SiOSF9Rx1Zzfql4V0hc=;
 b=gn7HtAFcWS1Z629qcrF/AaRIYShSnfzaWJOINZCiOr5F4hGtqQirWqeh5XB9z0aeEWnaYzEPMWfmL4vZ0w1/gAIwqZrUBoM09NBXFpCNdZFoh+dK1VryWTALny/qPQNAQPtYJsOUd7DHvYfFswqzN0mOSMdhNWe12R4m6relxilYlr2wL9KwERIHyhYDOoxDL5PhvPg306xulj5OrkYxjS4U2pVMA7Hs7VEp1YbVF8bDcNbNJ5bzQLjhpQRpcL2HhsdoxgXbH3KWd7qnixTWnQx/M6pUN63W7KjgaPNkgj83GMLHMUJVScnrW/AZuhxb1QqugmziFUBeCv76fRl3Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGhlujPNw3n5+6sBIsiPsew9SiOSF9Rx1Zzfql4V0hc=;
 b=Y6mlk++n0HS0vNdqc7iUmg8W+8Y42kVqlUxNRFr7H0BsQSrsqvIJ6h6CBYILKOOv4MZudQCfbUmi4NLmnH5BJoCewkjcW6LICCZQT1DOG1EmD9GvKpE4nhrLSUgtLXuRgdqUw/vYceB2qrQ598JYCmTCkTNx4twa+ZRa+k6xmX4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:20 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:19 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v7 03/13] arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
Date:   Tue, 19 Apr 2022 14:20:46 +0300
Message-Id: <20220419112056.1808009-4-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dfea69d-f22c-4600-5f4b-08da21f6ba1e
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB75387BDA04755F31DE92F4D7F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWldo7BrsulaJEhVSLWVfS814Z6/ZlPdQcwHR6j1jYAMbzDTxcGICUpYdPbPYduP8yM24BzdEHjmKtBVK1KA2F9Ioo40CTjtGpKsRdxeQOkajR2oEzySGMgmsHRhOY161m6/hPKgZTHvnSG15JZ2pIiL6BcLPDFVW/+6osINX5/CAoJbq0SGY6Z8GpBwKQi4pAWDG6P7BRvUuv1UDJIRNR/VGxUsM8wxMZI96s1px1KGWhbmuQxkBVy2zwXyA8vkRjay5mEstQwDrOcMcMhcZWROfVa/okGY4XQKyJ2msiqxXS9+tNNzfIm88upKX9xOlZs0708vwd/mpOhamG8vlXwe1gRSf3KpGhZF/ZiNBzdviYYCKUd/6oaocJyAsSlILvk49glIySwGq1XCn5xeiSaMur8c2Ur03dwBIpVLLoh+O21ZfMz/CqehcIweDytQQG34XjgWt6wDCFnThlVHtDWI4VsNMbfwkU19o4aiVcOCnOBpaPscsNzm6NH0XXGtsKRH7wdWGlV2nkhHleCMhqFSa94pvyYYagGEnVwXVo85Bsb9/URIwpjfUwfzpdjIEta1VVlFT2r1S+l9TfN798gKtuw06wilXbFFOWvEXtW9Bx72u5MvJhb+vaGoBUzsUMVFHMqmSuvDiFy4iRkQg2B4rqSuJLJbE16XYWd2Axbk1EIrC7H+cwBYPiFfmM3vRvcaJkkVNKumABmSQiBYrSTDTtZ+tqwl/4FsUAYDLak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(83380400001)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EVL4R/b4MDHXQBZJcxuCjNwC7JbMlylAaaPr+SAxrDu0TGWi6ROQa00S8/hZ?=
 =?us-ascii?Q?nRI3hNO/IKpJmMlOks23Z68riR3EtxbKTOJjJS091OWwPo2UmFSieYSGBUrH?=
 =?us-ascii?Q?ziWajUuiZ5ODyw2m0hVQ6PjKWqLeuRkqv0MwKgAwBLuuatQkkzZYa7mU25cx?=
 =?us-ascii?Q?1havBIUvlbAWUqbgQ2omctbDT3LNSmhnEZf1Pzbc/aZX6v4kCnuqI6YLn8G3?=
 =?us-ascii?Q?wRl1ExTrFWJfNDUEQ+zWGrSW00aQiLpqUN+PVWlmSLIWo/QHymMRCF8YJc0d?=
 =?us-ascii?Q?3aV9+E4AJU0faUpd6fQzcvAhqSbavbd2GOtr4ebmTFIyHUjUrKt5rQARpLg3?=
 =?us-ascii?Q?fs1AmOTz+X0Z3omwBocNEHynC1v1CVtCOJIuTgnpArl3BG2Eve0PhbuWigst?=
 =?us-ascii?Q?umjt38EtK1N5pKOpCGWNa+F3evSuKoORn8V1nj0LwnVokQ2+9GdSt/lQmq48?=
 =?us-ascii?Q?4M6KtUxd++chTmQw4ZF65xaG5YqmyGdeJl8BVzXwl57ZyiQhVZMPYktsBMSc?=
 =?us-ascii?Q?Tu2Yfp9jX5wKuyMFqw8xC3ud48lov1Er9haBgvg3Etkpvk57dvCWTMVB3n/u?=
 =?us-ascii?Q?GJFzdiaZ9JQho84IIF/SFpfP5c53V6ZMcRatxDCGud0RcvAOY8EolaJD/+BP?=
 =?us-ascii?Q?foDibhm+aIwC/4yYxuRRsyhmwj7G6RX2iyIrQAfw5mnZ9sy0D4qjoTjztjty?=
 =?us-ascii?Q?qpuJyc/6ovYOoNFGxoOjnybXJ68S79N8vTGok+KF1CRyDCMXccztf0SYY4qI?=
 =?us-ascii?Q?s1hvUvMHSqPShcYnAueBTXT+dt7/HAlG3w2+TrVUZ6deV35Zg4m84wJh0FZM?=
 =?us-ascii?Q?wdGnlEX9d0EmzfqNGZCX9WSSRMyG33huwvui1SFXlG1HQBR421taizo1lOuS?=
 =?us-ascii?Q?ypCVmR+gpSzoQCuYTULVHR4pa/aLPTUgf5Aq/WirFLXu2a10xGoasbXtN3B1?=
 =?us-ascii?Q?VSH+HKdbz9QZ9m67NFh3UDnJe6LxIsWbMNDWlPFShptIh5s2SnTx3mPXZy9Z?=
 =?us-ascii?Q?TBytQDv6EmTTr5x24alxB8Q1ivhUzFDHC8VeevYMB28kO/Yp6+jTZ5m4sZwk?=
 =?us-ascii?Q?VySjuNiQ6BcBnZh0GLtpO9bZ7pBamtsSjyakBkyEitSqgLXHWvweKYsdlFaR?=
 =?us-ascii?Q?2USXqcf6PIRW2sd4P+zUhe9rveW1EIrzL1ahS/Rwyyp9wODZ9GVUGD2ks2ZF?=
 =?us-ascii?Q?6msecARr8AUa0Ik4RpoOxuTsep63F0u9H9JHqZuhSwwPM75AOVXrpQr56JMf?=
 =?us-ascii?Q?eUW9Fd+8v6WoUqLDH/wXWqqh6b9vqrrEYTPpAL9a5dNeHVpFlzVz7Mr1/Iee?=
 =?us-ascii?Q?Xlu2aHKqrEyhjYz2Y4TbL4GyFNcy2/XyeWTzEje9tLxN0XEvzlxBVxOmfiW0?=
 =?us-ascii?Q?9aBGgrBtv7fRjBuws8ldMFdHiO6Zv6DcXdi7tY8eYSUZnSjo4lv3BiNVPz7t?=
 =?us-ascii?Q?CoeHNf1r8DlrNRYTu9pdbIihcwRgg8vhUSCSrD7Ptb8dgyiCa8LkSMtpMJ0j?=
 =?us-ascii?Q?xKBvPrv2FABvZ+p0YLyl3ohGPDpYP7OCbFLQd+q15CbSwsAv3bzmY4YAuBd8?=
 =?us-ascii?Q?zmboXl9rBiY2xf9J5kjgoZpseJTJ1Z+tglP4VC5/mc88+cCzo3uSBo5gsJHT?=
 =?us-ascii?Q?ZeqlFIqTTU3SwQZNjg0YZHfhrNAxTXwhXBUPu/r+8ZONry3OzTSzMjPhyrQ+?=
 =?us-ascii?Q?AnCEeayDa/U3McFpSenkGXsDkFLrwIdlVJ+k+ZOvjDU1JQpPJSJUvXXxW/3v?=
 =?us-ascii?Q?On4mr1Ymdg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfea69d-f22c-4600-5f4b-08da21f6ba1e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:19.7070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/azTe+X9gR8OEYd+KP2ekwrDn347C3CEN+qLzzWpjHyXMyJo2r+vk2pKEt3tq+O0G2P786TxH/wCI6meItBPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

On i.MX8DXL, the Connectivity subsystem includes below peripherals:
1x ENET with AVB support, 1x ENET with TSN support, 2x USB OTG,
1x eMMC, 2x SD, 1x NAND.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 ++++++++++++++++++
 1 file changed, 134 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
new file mode 100644
index 000000000000..e9bfcc2afa02
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+/delete-node/ &enet1_lpcg;
+/delete-node/ &fec2;
+
+&conn_subsys {
+	conn_enet0_root_clk: clock-conn-enet0-root@0 {
+		compatible = "fixed-clock";
+		reg = <0 0>;
+		#clock-cells = <0>;
+		clock-frequency = <250000000>;
+		clock-output-names = "conn_enet0_root_clk";
+	};
+
+	eqos: ethernet@5b050000 {
+		compatible = "nxp,imx8dxl-dwmac-eqos", "snps,dwmac-5.10a";
+		reg = <0x5b050000 0x10000>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 163 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "eth_wake_irq", "macirq";
+		clocks = <&eqos_lpcg IMX_LPCG_CLK_2>,
+			 <&eqos_lpcg IMX_LPCG_CLK_4>,
+			 <&eqos_lpcg IMX_LPCG_CLK_0>,
+			 <&eqos_lpcg IMX_LPCG_CLK_3>,
+			 <&eqos_lpcg IMX_LPCG_CLK_1>;
+		clock-names = "stmmaceth", "pclk", "ptp_ref", "tx", "mem";
+		assigned-clocks = <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>;
+		assigned-clock-rates = <125000000>;
+		power-domains = <&pd IMX_SC_R_ENET_1>;
+		status = "disabled";
+	};
+
+	usbotg2: usb@5b0e0000 {
+		compatible = "fsl,imx8dxl-usb", "fsl,imx7ulp-usb";
+		reg = <0x5b0e0000 0x200>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 166 IRQ_TYPE_LEVEL_HIGH>;
+		fsl,usbphy = <&usbphy2>;
+		fsl,usbmisc = <&usbmisc2 0>;
+		/*
+		 * usbotg1 and usbotg2 share one clock
+		 * scfw disable clock access and keep it always on
+		 * in case other core (M4) use one of these.
+		 */
+		clocks = <&clk_dummy>;
+		ahb-burst-config = <0x0>;
+		tx-burst-size-dword = <0x10>;
+		rx-burst-size-dword = <0x10>;
+		power-domains = <&pd IMX_SC_R_USB_1>;
+		status = "disabled";
+	};
+
+	usbmisc2: usbmisc@5b0e0200 {
+		#index-cells = <1>;
+		compatible = "fsl,imx8dxl-usbmisc", "fsl,imx7ulp-usbmisc";
+		reg = <0x5b0e0200 0x200>;
+	};
+
+	usbphy2: usbphy@5b110000 {
+		compatible = "fsl,imx8dxl-usbphy", "fsl,imx7ulp-usbphy";
+		reg = <0x5b110000 0x1000>;
+		clocks = <&usb2_2_lpcg IMX_LPCG_CLK_7>;
+		status = "disabled";
+	};
+
+	eqos_lpcg: clock-controller@5b240000 {
+		compatible = "fsl,imx8qxp-lpcg";
+		reg = <0x5b240000 0x10000>;
+		#clock-cells = <1>;
+		clocks = <&conn_enet0_root_clk>,
+			 <&conn_axi_clk>,
+			 <&conn_axi_clk>,
+			 <&clk IMX_SC_R_ENET_1 IMX_SC_PM_CLK_PER>,
+			 <&conn_ipg_clk>;
+		clock-indices = <IMX_LPCG_CLK_0>,
+				<IMX_LPCG_CLK_2>,
+				<IMX_LPCG_CLK_4>,
+				<IMX_LPCG_CLK_5>,
+				<IMX_LPCG_CLK_6>;
+		clock-output-names = "eqos_ptp",
+				     "eqos_mem_clk",
+				     "eqos_aclk",
+				     "eqos_clk",
+				     "eqos_csr_clk";
+		power-domains = <&pd IMX_SC_R_ENET_1>;
+	};
+
+	usb2_2_lpcg: clock-controller@5b280000 {
+		compatible = "fsl,imx8qxp-lpcg";
+		reg = <0x5b280000 0x10000>;
+		#clock-cells = <1>;
+		clock-indices = <IMX_LPCG_CLK_7>;
+		clocks = <&conn_ipg_clk>;
+		clock-output-names = "usboh3_2_phy_ipg_clk";
+	};
+};
+
+&enet0_lpcg {
+	clocks = <&conn_enet0_root_clk>,
+		 <&conn_enet0_root_clk>,
+		 <&conn_axi_clk>,
+		 <&clk IMX_SC_R_ENET_0 IMX_SC_C_TXCLK>,
+		 <&conn_ipg_clk>,
+		 <&conn_ipg_clk>;
+};
+
+&fec1 {
+	compatible = "fsl,imx8dxl-fec", "fsl,imx8qm-fec";
+	interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 161 IRQ_TYPE_LEVEL_HIGH>;
+	assigned-clocks = <&clk IMX_SC_R_ENET_0 IMX_SC_C_CLKDIV>;
+	assigned-clock-rates = <125000000>;
+};
+
+&usdhc1 {
+	compatible = "fsl,imx8dxl-usdhc", "fsl,imx8qxp-usdhc";
+	interrupts = <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&usdhc2 {
+	compatible = "fsl,imx8dxl-usdhc", "fsl,imx8qxp-usdhc";
+	interrupts = <GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&usdhc3 {
+	compatible = "fsl,imx8dxl-usdhc", "fsl,imx8qxp-usdhc";
+	interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.1

