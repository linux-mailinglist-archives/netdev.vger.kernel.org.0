Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD31506B15
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344578AbiDSLjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351455AbiDSLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A498032EF9;
        Tue, 19 Apr 2022 04:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5hMARIfKTyRFRcS9A3fspzpH3Z0yS1qeEayeg8vIxxp1PJtBM1C3vpcfDBWHw5zTQN9YcbztkGFmzBRvO/0Nh953Tvhi//1DaktALwo5cRai7p0XnzyoJ1AT0hHJvPderYhHU+189JtqBjOrtPQC8tVEFukqArqUMcN+rVQ66zXHvAcefKoie7M2UleIAJyU5Dq64wtRhmWFH/Ez+VmR1oVOTm41uJcgdB3kc4CqhPSLW1JjCjhxJIvuUiXbBaNPjCr8BInhvvXMDVuAaQCTOcAhKobMbwC32mq13AYyDTHr8/z2A+x3+XkEvA+LJtlOyPdeJxn2vJ7DpfNxG+rTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGhlujPNw3n5+6sBIsiPsew9SiOSF9Rx1Zzfql4V0hc=;
 b=NLvNGvtiRyxgqaGX1DGrnVJxs5eFhMCN23WwoTBOSvay8VYKtcvIHYxiJr9U7dIH6oJjO6SUqMrXyDDdMnZlSTcoNzxgkckPhi5IUydxk3uXMpwhTlmgcAzc7B5EI2s5vnSSOjGZgZt+Otc1gSkgxyr/kkrqyZ+hdH3JlFrjqiooZX7bkllaq03KJ5LkSlSVBAyI4PfhQXDcKjnwrXVUF6jq/5bhJpI+7wAsHBmcC1mpQr5OIvMfTHh31yzOUfQdQ4S+neiHsWhUrl5THk+g8umHDHS3HUd+D+hZIyhWmykdYR1xZ3hVRCeQ704SZLQx64Qq2QU4wP7gbzC6+W15Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGhlujPNw3n5+6sBIsiPsew9SiOSF9Rx1Zzfql4V0hc=;
 b=csJHXNkc4YBE6bUxrTt/yx3RsNWSqppYQpmfpR9pTeOXppQ80zK+dciJF7x9NfEybhe5ESoY8Mma6ypVT3zjsR70GcCH354xEVRM3+LQVsC7YQ61XgSrmJlBfNaubwtg2rEeqx7+dmTH2rX0rcDyYQD5mV1DHdSCJCsDZ91y244=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:33 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:33 +0000
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
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v8 03/13] arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
Date:   Tue, 19 Apr 2022 14:35:06 +0300
Message-Id: <20220419113516.1827863-4-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: dac4779c-5415-4410-862a-08da21f8b6d5
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3054878C198A88911C031E95F6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+l+bywT01KiT/xBqdx52zh0WwxVGOCBRrfgbiHQxR8ZM+FLhP0E5dpeBF375c0TYYm4508wYPRiuzfRTKyFgAWelDJQHzuOJsHUOInVyjr4GzYutqt0KUl4UZ7rT31/dk5o6oQXOfI78505V+FRF9/KcE4Sm4zjLCgVO4R01nfFCbL+6gehIlh6MKfugnq9nLPbuV5E7fpqBZnAbcBZYYmlF9761O1l4O0o/Zk7HmSISRfV4x2Tgw6cEvtIDqT2V6w70Mq2jZ7xKol1EscxkuZvz6PrxRO3zjnaB9dQ7LAKX8IZjMnsARkABWVP3HMUB7cAjP7YXp+A6y7kY1vjj3L8+S0mpBIA3NGtd78E3CELIcVwNSEpo3NrVSGj3PMcMycwUJ0U5V+1MxmqIeDXAjhCz3Ap7PiAd5HkHpCnbWqBD+IPzWjhsxsn3IbZgm3nf34mAxvmh6Uhaw/Chd7+xD+00xqPif9BacH9QQPgwJiEuSHL7Ps9+e5kpF9kOX7jhxmoBJamx+Cl0B6JotvDOf/3ykrgFziZblJilPVZVj1QTFHfMBo7ROSv2N2Jxs/mBRuUvhk9ajRWzX66khpYJD3/rjrgNP2rIAYaPiLhFwPW24Lzdy5cvY2AtM41+iW2IW6zRrfhUK08reyOHN471fWi9dJpztjP+GZ21IOBtCxcqVuyBBS2D6ZHTnmXKPmbxDs2CfYsfIWJULUt+uItKVeC3Dhz3Y/18QYVGs+mXt0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7eb3MFsWMAB/LKRejbhjA+iIaNfNuos+IpHKp4R1Co4sr+8/iKH1z+zvggjz?=
 =?us-ascii?Q?llzrd9XhNHzP9X+XOdtyNbun92Comps/L4pxQtYkjsnzC0gEstl9A71/B8wU?=
 =?us-ascii?Q?R8yX7EwmiivbkJDQAAQ0CzYHy+yphCtD7UQcQm//RlRChzaWQJu97Z5N2/Zh?=
 =?us-ascii?Q?iVptakrCaq3anlCT1OxwO7ikcyPahvn0J/xLgARshF6CtxcJBCfOPr5YfMds?=
 =?us-ascii?Q?5QIhyWvzChA5BtYVkXHWr6k/wny4OcOVTb17cXOKeKRkJcdFzFoTvXWLO0Td?=
 =?us-ascii?Q?u7EmGbOX5Q7/+dni8cCqWQFPn3+m33zo7QBOirgs2602IOxZX83v6lf/L2KL?=
 =?us-ascii?Q?oNwvSQlv0XsOhBAdT9+HMW+bnzY0f0XNMiwEbgjea1LyLO10TO+TnebuldQ2?=
 =?us-ascii?Q?OFbFGleWFB7y+SyqL8WbjL51EqsNVxmyWq9HL7G4pOSsKViX2bw1T4qEsESz?=
 =?us-ascii?Q?yDMNJAima+hrlQijAx6n/c7njwqCaWm05w2CuaGhvAYDx4qNpKBedraP/IRq?=
 =?us-ascii?Q?R2uzJImc0YTX8yAruZ4BKOW0IWjNilD/w+2ZJ7Kqy/dLGhNWNwqz1REJXFgs?=
 =?us-ascii?Q?fznhPRqn73UTjX/zbmsWv5RG4upndgk5iBi0d/97yOGqutCMe3Rd2uscu3b9?=
 =?us-ascii?Q?fANpPuth0BGg8aWAVZGI33gra6OElAclNru3Ty+8xP5CiP/dEBkH/WhiulNz?=
 =?us-ascii?Q?rHd91LPsSDLFjrZo/ii+x9Y3WKXPQWNpYM5lXZ8nQCSHfGwDCP+R2SEzuUQK?=
 =?us-ascii?Q?ZjMWJUXdKY5IsRRyR1o/ZEtUa7SA0dN9BMtlroU4fMKddDtCSrIPCcq7R2+u?=
 =?us-ascii?Q?VDDgLIECjkLgueFzUBbklrDMd6A+POIWlKGN2cd/rdI28CxlOOBZ+E5eCXn6?=
 =?us-ascii?Q?3m9y0+d11KYDS6/7+1NXrgvdhj40kZRU6nfWqW5fidfgbWI7BNN87H5TOdx1?=
 =?us-ascii?Q?rxLOWC9RSauZ0w+AhSSdiloik31X925lfu+QohIZG640ELJqYGMHV10efEp8?=
 =?us-ascii?Q?21M959e4XNjURpYO5BN8ZIBDaTVCwCE5mS3xFVrCqlH9ES4fNVsQ5OKxUylQ?=
 =?us-ascii?Q?pWQROTRZ0Dl/Qm/z0VIYoToPiv66y/og4g6U6BLGoPY+hp1Jke89HPseNa9g?=
 =?us-ascii?Q?oyvlZ9ciPEtJHhaDjoOJqMDbNQLtXWoUlzFkt48ejE1+o4gG5CPGMUFZLsq3?=
 =?us-ascii?Q?iUPkX48kukhJW9qe4H26Xbf6ncRmpJrJTYCOrv1fpgqWDQTVTnS9ZQ51N0sE?=
 =?us-ascii?Q?j0LazIPCRttTd2OV5rpj956Z9obwrwof/0e5u1yl6jrX3Th80qeHAXr7k6uK?=
 =?us-ascii?Q?T2GrkIMaF4R4H1v/5Xc3CWbQ1vM75HhUg03znngoLi4W2Tm+7UO2fVQiq9Ae?=
 =?us-ascii?Q?+dfbqCKL9idElcz7uKuWbw2/9hGw7hMZTqgHZ1M716BeLPI+8beL1TBEugGX?=
 =?us-ascii?Q?nNc4QEHMVoZ4MjvWqqAzm+YZoHF4wO3VBIpQQT9lS3ilC/V7LGAYjyGXXw7v?=
 =?us-ascii?Q?018/QlauGXmS6YifX+No4uslF3+BfI8dnSELc9p1H1BOo2rdPbjc8RUq+Jwk?=
 =?us-ascii?Q?vNHyumCDiiDWYg+ZldhU1UvGG66WVBteGSumdzq9x+EXJrJNQolBdUoPLNbe?=
 =?us-ascii?Q?LTN8XCOEB1+o4mjaMNY1cBEl9/dMN1P8vsRpXRCmN5Ks42Zv/t1zaNsIpu2D?=
 =?us-ascii?Q?E3cMl4V3ETd6OBQq5gtbyqWBbXcJkq08wCVUJJyJ6rh1SNQKb/lZGy9p5F+p?=
 =?us-ascii?Q?7ZK8Z58C8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac4779c-5415-4410-862a-08da21f8b6d5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:33.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCIVRiC3z/Ifozdn7cqOkFNlqHxOwRWiI+hQO1UgcVjWp1ndjaUZfSyalbcQrFQ96E1wpz92za5CTU+3zJ8aug==
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

