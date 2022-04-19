Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B91506AE3
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351625AbiDSLjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351595AbiDSLix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:38:53 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE21A31534;
        Tue, 19 Apr 2022 04:35:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxSJKDBtDUqwL33TFc9dWoQvHeo4mlSIivtt/tCJQMoGt4TSp3EJ6CEj2G3XNAOx1Mpisn7Bj5eynKbb7NZ2ynMk1Rch4SR0DVQDj/gkDhb5+OTkHBDF6GBJ/RS6WwIPI4zvemw9l6VjpthnQnjEeWMECSmXR+j8Sgi6FQC2FDU+SV3vVWqtWuBepxU1UQrkPue6n4V0ALwdEgTxIKH12IC0qbRoarXij+Eo2zg58MVSSHybKmHWwyy0bAVFnRqbWhUZnNvEEnx7z8JoQypwW/j4OUIHnKLkMfbmwLM7YpC2g9xFjitD/XNMLVZpR5GOtettwoP2ismVAzF6MDZMKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3caNKl2IoTQCwKw/mQew/YX3PzIkfAbqnefH0pp1rs=;
 b=g6gmP5Af4oEYbkiqpnzr+ZW/n6/eOi5A/m4t16K+gMgdPW8Lf9ynm7EIjeQTJdbQ3zyU7EUBmlazR9IWVNNwsMz04TSEqHWxVKZZq6BlmbK1LlDCPGAMppdXgEqhbgPnN2fOLEcXzM2n6ykYOJPNhgNhbotUVbWf9gZqwCpMjkYflVKsrT6we97igU9g58r0dy95MZicqoiFuNWMEhdCL11u+/rsxfowrqiqt2BP8r4sDRvktNW5DdzrcvNriyCp7Sl9K3awpdXQYfkovZmNp4d+dfRFKvCbeuXeA107IdnHTweELnjbR3COtm9kURGovh+PW8KUzsTh/Hy9foIs2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3caNKl2IoTQCwKw/mQew/YX3PzIkfAbqnefH0pp1rs=;
 b=PMUDnIgQQJw2UrGVfjSoNXkiLs9NkjYuXkywyy5hmztCQuhTlDWpH4mio3CaSloIisbADTxAHuCvFJTKAUqYlvFFXhIGzmRaLPU1OfhoXUz4Cy/3SqbM2PkXpQ2OT0daKeWLgjwGLTt1oRPbnYnw9/8ZkI2bjt8RJcpHS8GNzXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:31 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:31 +0000
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
Subject: [PATCH v8 01/13] arm64: dts: freescale: Add the top level dtsi support for imx8dxl
Date:   Tue, 19 Apr 2022 14:35:04 +0300
Message-Id: <20220419113516.1827863-2-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0f49296c-4d26-4d43-8207-08da21f8b5e9
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB305481B94228F19E45C21C7EF6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ylidtks7jC2Dx8YMDCR+pgw2SoCmiOhWUnJrOhDCfuri7PGwPnLUbYVRIlYPTv7JcPuzMCS3dCKk3f+K7CjQuU5dT40VVfzg8Sc4IqXLi4s6/H5i9R38k5ra9RuvYwEsxDzta7C+oXYPw2yDpDsll3aoYEBvjz7tvNVQHcwsIla3sYsZ21pPQotLrvRi7Zfj3xLTbbVo6AXokhapTtj4heAoOfercyQbjBOvDKYuNIBhfMkYwXkIu1ah0na4J5NgcjzOnJZ3iRf290/mSyk9yCZRVNdxd3v+t7g/ulDiPAzzUoQ2KMLfy8C9+CrFa/u4AzkC5KocV9FfTAdZdM7QOaFtlhYlOnS2zvWZGox/i9ZVGBpHzPEn0i5vOMi5N4wPLLIFCXK0RzPNx9a8Hy4ggPDna+QfZWv3eXr5ddXe8mx0p9Ygqxer1JnI0bzgXgv5CtNVfKLyZ4Z7kLPmfNd59IXahUxZ3LWOmIlbxuhTnhMq/XkKQ+FsozrJj10O6YzgO5k+5KUKq4DGkO//jUsM2ePyX6Bjp0XrazwvvsAGRuk5vbmemyVPMapwCSkvGscuYgqmQ9IsBZJqpi+yFXLxjQwDvKRd3I4o0dhh3wP3UcOQjjp8ZnxbrdoVjUyoNbN2hU8yjorBnGGam4s6gaZUJqGdf8F5XfLghFIojQ7FKj5EKlPaWYhZhRoHuBYcmbuoLmZhO57+A5PaiqthEFe4MHjRfl9G+69jkYastXWbP7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ss4Jn2Am3RVy5mNA5UMJA79Lb4Wa5tapqgSdUisRBLzsdB+KpvAAzRVYhAE5?=
 =?us-ascii?Q?VgNIafoXGMBthYgsaNKPJg4u0Snn8rDxPiTVDrb6gWidu/O7r9Dgc8hdCB33?=
 =?us-ascii?Q?fxw2cJThYKYvDQylrdXNxCxHAICa/oeV3zpkuPx49cCOuEtuij+Cg2N5koTF?=
 =?us-ascii?Q?U09/hzj7+s1BSj4Wtwp+aVeeoZ3HQw5gChvc4zdr37iW9jDWymI9pUta5rDq?=
 =?us-ascii?Q?ZJGR7CSHJ/j++uuJqziy5y3XqqgYj9677eBcexFesWNAkYHbEiq23flB/MSa?=
 =?us-ascii?Q?jF0CLhOwQO4U6BehAT6krkujXWAY0PsoB9J1ENnt62E3A3zlljFm+mQyoz7v?=
 =?us-ascii?Q?/da2E0DZlUx8dmcrmdF0yQ4eF/GTkgewqF6o7VSMPJuVf2VekDs2+soh9o3P?=
 =?us-ascii?Q?N+Uo6fVzkgtTMe0x6ASfs+rZeyGbwa/LeS7EM0fonhVQUqICT3GACEHPryL9?=
 =?us-ascii?Q?KwRC0tugpruKljtoAKlYlqJD/+71cUQ9TukBgUAnFwIZwo70nBJo8Gm6Lp2+?=
 =?us-ascii?Q?8BO1nGjboXntuGgR4UKrSB6W0bcjlT2J8HyIUN/cI/ku9c1EjKPsHGoXzEND?=
 =?us-ascii?Q?xzPr94/gNyCBYPRgRGNpRfeQa8ndIgWUh2gwUGo0+PWfqXAKTGpuXLD3itdB?=
 =?us-ascii?Q?vhbrb0UDplxI0EsDAlUxbCq9ll/et6jYSSqb3HPdbyyCocVtknAhFZCE3Tz2?=
 =?us-ascii?Q?MYjuxFip5zHYnsG1f4AZetdiIaSqOVawUQc47IUuMj9U+amjLxwLcE2lDztA?=
 =?us-ascii?Q?GzUd8moqd9ylCVYMNp+in7W5eaRwFGHY5FeIIi7OO6DZyJkReoAlYzhIvFyU?=
 =?us-ascii?Q?6mBUoTB9V5hbQ46IEQlUMSDAGRa092cuYgDZmCXQVOe/MHvrk+jO41ke8j5r?=
 =?us-ascii?Q?ijE+C9WcFPZjmRbKzM/k5PtEgwviEFxrLbDpBmNTIZ79pFxlL+imSR3BQRGz?=
 =?us-ascii?Q?k+yw33XzB+guvyhjsNbTbDG1zEHdATC2yEKqiG7SxL+bHT4yw2NxjRsu0bYa?=
 =?us-ascii?Q?M9+NhTETNqD+tKE1whx1IwHh8KXD8iv4+LNkkL85VRG8pGEL+OHoKSBZhfBD?=
 =?us-ascii?Q?stXmG8zJY1EDnBMibBuv2USnQsTbxbhCvcrsq/ckJe51qWxZEvLcrovB701N?=
 =?us-ascii?Q?9UrIgBsTqYGTui2usFYeh1z7h5LRtGQIVvaiOvjJiKknZjIo06nyd2Wfgq4V?=
 =?us-ascii?Q?xxJMBeHoJvSe7b93Yc6hKbRouqOAi7jOYDy/Rvj0HmQSSFt1ismsAO245WM7?=
 =?us-ascii?Q?ocFjQPKPDkZV6ubPx+BbQPI81vWFO7HF9uNHbT2eWpuYour24wuG685zP5lp?=
 =?us-ascii?Q?B8iIGh28wCpDrhzkI6wZPodmMxSLLY+8/ysQaAc5Te4ckuJw3vSY9H1jTj6Z?=
 =?us-ascii?Q?aPlESa1CyrDHxy5CK5efqCqVZbWw/Tm+cVNV81ebcuoAJLz8CMaymlUjdZf+?=
 =?us-ascii?Q?PmtnE53Qp/XDI+TRlAR1tsLEvNEFnEsGMvpMlRCrcGWUvjQb3LiO4giCrFm9?=
 =?us-ascii?Q?ONbBLGFjxXSgKfU/a9QktpBSy3mN/NdDX5Ty7f96fVRrwKShacdE4xHNaZHy?=
 =?us-ascii?Q?mqv62SRNEKYS2MSajVfXGxbU+e1lgGWu+ATzJN0h1r+a4yraYlWK7NJRH+sb?=
 =?us-ascii?Q?plwrqP6JJw65aK/QOK0ZOM5o6vhnMUvB5w/9fQWAAklHSONWV9Pu0JXcID5u?=
 =?us-ascii?Q?oUD0ZR5BiuoRv6gvs6rTrvg1wqwPyVUOjAgHthwLOfPHaKXDhIi3zmh2HJ7A?=
 =?us-ascii?Q?Atl7y7S2sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f49296c-4d26-4d43-8207-08da21f8b5e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:31.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7+YX9tv2GORL7uoJ1MagzzIrUt4k/OhHwM3tUKUDZ6kPjljLuNqnMw0dFav2lVb8vieKJrdPp1a5ee9lRd20Q==
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

The i.MX8DXL is a device targeting the automotive and industrial
market segments. The flexibility of the architecture allows for
use in a wide variety of general embedded applications. The chip
is designed to achieve both high performance and low power consumption.
The chip relies on the power efficient dual (2x) Cortex-A35 cluster.

Add the reserved memory node property for dsp reserved memory,
the wakeup-irq property for SCU node, the rpmsg and the cm4 rproc
support.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi | 241 +++++++++++++++++++++
 1 file changed, 241 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
new file mode 100644
index 000000000000..716caac1cfe7
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+#include <dt-bindings/clock/imx8-clock.h>
+#include <dt-bindings/firmware/imx/rsrc.h>
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/input/input.h>
+#include <dt-bindings/pinctrl/pads-imx8dxl.h>
+#include <dt-bindings/thermal/thermal.h>
+
+/ {
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	aliases {
+		ethernet0 = &fec1;
+		ethernet1 = &eqos;
+		gpio0 = &lsio_gpio0;
+		gpio1 = &lsio_gpio1;
+		gpio2 = &lsio_gpio2;
+		gpio3 = &lsio_gpio3;
+		gpio4 = &lsio_gpio4;
+		gpio5 = &lsio_gpio5;
+		gpio6 = &lsio_gpio6;
+		gpio7 = &lsio_gpio7;
+		i2c2 = &i2c2;
+		i2c3 = &i2c3;
+		mmc0 = &usdhc1;
+		mmc1 = &usdhc2;
+		mu1 = &lsio_mu1;
+		serial0 = &lpuart0;
+		serial1 = &lpuart1;
+		serial2 = &lpuart2;
+		serial3 = &lpuart3;
+	};
+
+	cpus: cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		/* We have 1 cluster with 2 Cortex-A35 cores */
+		A35_0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a35";
+			reg = <0x0 0x0>;
+			enable-method = "psci";
+			next-level-cache = <&A35_L2>;
+			clocks = <&clk IMX_SC_R_A35 IMX_SC_PM_CLK_CPU>;
+			#cooling-cells = <2>;
+			operating-points-v2 = <&a35_opp_table>;
+		};
+
+		A35_1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a35";
+			reg = <0x0 0x1>;
+			enable-method = "psci";
+			next-level-cache = <&A35_L2>;
+			clocks = <&clk IMX_SC_R_A35 IMX_SC_PM_CLK_CPU>;
+			#cooling-cells = <2>;
+			operating-points-v2 = <&a35_opp_table>;
+		};
+
+		A35_L2: l2-cache0 {
+			compatible = "cache";
+		};
+	};
+
+	a35_opp_table: opp-table {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-900000000 {
+			opp-hz = /bits/ 64 <900000000>;
+			opp-microvolt = <1000000>;
+			clock-latency-ns = <150000>;
+		};
+
+		opp-1200000000 {
+			opp-hz = /bits/ 64 <1200000000>;
+			opp-microvolt = <1100000>;
+			clock-latency-ns = <150000>;
+			opp-suspend;
+		};
+	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		dsp_reserved: dsp@92400000 {
+			reg = <0 0x92400000 0 0x2000000>;
+			no-map;
+		};
+	};
+
+	gic: interrupt-controller@51a00000 {
+		compatible = "arm,gic-v3";
+		reg = <0x0 0x51a00000 0 0x10000>, /* GIC Dist */
+		      <0x0 0x51b00000 0 0xc0000>; /* GICR (RD_base + SGI_base) */
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	psci {
+		compatible = "arm,psci-1.0";
+		method = "smc";
+	};
+
+	scu {
+		compatible = "fsl,imx-scu";
+		mbox-names = "tx0",
+			     "rx0",
+			     "gip3";
+		mboxes = <&lsio_mu1 0 0
+			  &lsio_mu1 1 0
+			  &lsio_mu1 3 3>;
+
+		pd: imx8dxl-pd {
+			compatible = "fsl,imx8dxl-scu-pd", "fsl,scu-pd";
+			#power-domain-cells = <1>;
+		};
+
+		clk: clock-controller {
+			compatible = "fsl,imx8dxl-clk", "fsl,scu-clk";
+			#clock-cells = <2>;
+			clocks = <&xtal32k &xtal24m>;
+			clock-names = "xtal_32KHz", "xtal_24Mhz";
+		};
+
+		iomuxc: pinctrl {
+			compatible = "fsl,imx8dxl-iomuxc";
+		};
+
+		ocotp: imx8qx-ocotp {
+			compatible = "fsl,imx8dxl-scu-ocotp", "fsl,imx8qxp-scu-ocotp";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			fec_mac0: mac@2c4 {
+				reg = <0x2c4 6>;
+			};
+
+			fec_mac1: mac@2c6 {
+				reg = <0x2c6 6>;
+			};
+		};
+
+		watchdog {
+			compatible = "fsl,imx-sc-wdt";
+			timeout-sec = <60>;
+		};
+
+		tsens: thermal-sensor {
+			compatible = "fsl,imx-sc-thermal";
+			#thermal-sensor-cells = <1>;
+		};
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>, /* Physical Secure */
+			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>, /* Physical Non-Secure */
+			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>, /* Virtual */
+			     <GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>; /* Hypervisor */
+	};
+
+	thermal_zones: thermal-zones {
+		cpu-thermal0 {
+			polling-delay-passive = <250>;
+			polling-delay = <2000>;
+			thermal-sensors = <&tsens IMX_SC_R_SYSTEM>;
+
+			trips {
+				cpu_alert0: trip0 {
+					temperature = <107000>;
+					hysteresis = <2000>;
+					type = "passive";
+				};
+
+				cpu_crit0: trip1 {
+					temperature = <127000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
+
+			cooling-maps {
+				map0 {
+					trip = <&cpu_alert0>;
+					cooling-device =
+					<&A35_0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+					<&A35_1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+				};
+			};
+		};
+	};
+
+	clk_dummy: clock-dummy {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+		clock-output-names = "clk_dummy";
+	};
+
+	xtal32k: clock-xtal32k {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+		clock-output-names = "xtal_32KHz";
+	};
+
+	xtal24m: clock-xtal24m {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24000000>;
+		clock-output-names = "xtal_24MHz";
+	};
+
+	/* sorted in register address */
+	#include "imx8-ss-adma.dtsi"
+	#include "imx8-ss-conn.dtsi"
+	#include "imx8-ss-ddr.dtsi"
+	#include "imx8-ss-lsio.dtsi"
+};
+
+#include "imx8dxl-ss-adma.dtsi"
+#include "imx8dxl-ss-conn.dtsi"
+#include "imx8dxl-ss-lsio.dtsi"
+#include "imx8dxl-ss-ddr.dtsi"
-- 
2.34.1

