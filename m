Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA144F1665
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357281AbiDDNsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358482AbiDDNsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:48:41 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40040.outbound.protection.outlook.com [40.107.4.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3EB31360;
        Mon,  4 Apr 2022 06:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkPEO/ZXdnk0yVwFHcZykAYOSpnm8wbS8rq+A0WKfAjaXJO9iyAvtkCI1kjzScTSAYGamh7Kgs9DITnHCsGCvF5Kgh1OLDECsHGLs+kj/x2ZWzPENRR7mydiXVhWigk1lei0VxTmwFjo6VLDgJIq+EiEdEYzyUryRjMwZjqD1CO41QBLzfXay+jqWAZ3YPGKZ/bsRY19p6qF+0e4QfH8z5iBCtJNe6IlYPyuuBUpQc0/jVFKEyVLPPqKpG3RcHvSZEdDDmdFECXiuMJ2NEy3gz2RRdPmZ9FwRb18CHv5uVANIcBkCz3wOxhdtZ4SjcydY1juHpl7A1JvfFQmyF87Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWhe3QbAC/6rBIUYHb3n9QD62bziChCgD6oNCRxRwao=;
 b=KMTj2/1mzVfHX8UByqZhHOWA0P68Q9qtLwTwtG57QtmCskG+YMys8ufKK3urqQ2sITxc1oNXs0OfzCEnK8juFOw4pRtKwIphDZ9nfKPXJ5jmk3cny1cnKRJyHaTzIPdw/B0Japiz+AxADAhRnFkS2PnHzGEUKmJiGF4eN1xHjlMH2Amkz0baDM+mRl7eyKZg1a2P8JtS3NtSr0NNeUQdLNnGgvJUm6MKnLsG5QonvP1VCSMStumPkLv1eIzLWNK2XiEvJO7XLbX8ktLN7y6dLryYihWsuQsnVcUsvA0Xe6XWjxI0e3JhPZeO7UlUkwt8IoMFlsDBda9/q18yAZyKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWhe3QbAC/6rBIUYHb3n9QD62bziChCgD6oNCRxRwao=;
 b=QZXr1VyC9U1mfet1W/bPrNlPT5UOzrXp3WVYKq+1KGMLATgFELpwia4g68JoUS/5822bZ4OswsS0TnDaphlssahfJ4YViAYHXYPXDJU4Ot2+DH5i65b618n1xMIE96DkYWro9ycWmDc2OiDJ0gEUnwj0tqxYHWqJce++35ZhWE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:38 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:38 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>, Dong Aisheng <aisheng.dong@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v5 1/8] arm64: dts: freescale: Add the top level dtsi support for imx8dxl
Date:   Mon,  4 Apr 2022 16:46:02 +0300
Message-Id: <20220404134609.2676793-2-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404134609.2676793-1-abel.vesa@nxp.com>
References: <20220404134609.2676793-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::34) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60deffd3-fd44-4393-3f18-08da16418ad0
X-MS-TrafficTypeDiagnostic: PAXPR04MB9218:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB921867F8D68B34160D81E00CF6E59@PAXPR04MB9218.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSk2lBJwwD4lElSD2FlJfbR/4LPLSoT4wn7J31Dm7Fo8ZcuGgbLJZ//h5k014hno3i02ytnisvX4XgKShURdqK6/vWfgillhQjZ1dsJCNbKfRJFuSRJqHTCVWffPgzN1JP8CbgrH3r3VGoORj3c0YnA9H3z55/sy7ILTCOsL8Oi4DCsLEjx8b01/Jiz3GAV8OFCH62X4yGMHcaKXPiH+Mpjr3l+ZPJXD2OtQc5d72LUCPDmX7OUZWTAqwrPJSWJuIec+HRvmWGiSHzv9nbSa6HZGzQYrCjsgRnsPJSwhziRNLiQF10AGZQHctGk9Bg4cV2PmRz3leA6LWxNrjcF0td7IqiFIsbjiQyJh6/3KmsQ67fRGy6v2QwnHFAG/y3R7P0OqkYW7lBx3VuQlPZjyymg/bh4zSgk3uOIdlCovZK6liqnUAra7l5rXHq7tie6Cvh8HE3y38vAIwyqJScqx51MBwexUbpbwwzK++RZI10aqCDauKLvMwgqdFG6BWo2nxV6UddRFflzCSZP6uQ6PUlZxAeXa5V+Apf9Vf5l9jdRWxFuGkDR80RZbhoTsT4g//qBrInCajaJSxbpOze/dUfdFhsS5cWtlp2k9xzoLxmYLRwbiIEsbUM0Do0lTm0PZQCsMVDKptlVlG0U0deRrWqz55CfiBGfOA9u0SfIj5Mi1pASeCvLDcyKDyseBnufky6mbit6fkVZWQN+tBWPhdjVELeYSXAN5dGEuf2/b9ts=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(86362001)(6486002)(2906002)(36756003)(6506007)(6512007)(316002)(66556008)(66946007)(186003)(66476007)(6666004)(5660300002)(44832011)(8676002)(508600001)(110136005)(4326008)(38350700002)(54906003)(8936002)(2616005)(7416002)(1076003)(83380400001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8lMHK35GX22vc3f8h4315go1vaX3L/zlCrIfjJpL2PyC5BPqf+U4r6ot0bD?=
 =?us-ascii?Q?hunkoBlazXqbCt01wvr79HKdelVJEAiQcZw6dWRIGvNGs7JGbT7KmfG2Z9ZN?=
 =?us-ascii?Q?CrlvlzhNWICTp+w/M8pM535TFvwVBboC+c4imHA3A5Ad5ABqOhDiMg+F6ETo?=
 =?us-ascii?Q?6PGhliO18haLRputLyo3koFLNmlCkXLHxHG6p8up6FsyMSfDQmZjKs29BuK8?=
 =?us-ascii?Q?t4RPCELGy4Wtu3I17QV7IC7cHJmYat32NzBoKr+AkQ6ihYVCVMORyN+lYxxF?=
 =?us-ascii?Q?DZE8tHo+Jk2kFtP5ZL7xqFxF845D7zF1mimXDDduVizdZxrP0cseofiOH3Sw?=
 =?us-ascii?Q?61b4SuglpjSS/o5h+TYcg18YSFiMKjwTwyTkvYFTsUDT0LTAfenXr9z8P8x2?=
 =?us-ascii?Q?xyfIdv6O9WFfm1vuVXDJ0aRZkpaxo91KYIfxA1TkLVB9FxnA18OqZG6ufabk?=
 =?us-ascii?Q?PyMSOSk7wKKFTv/2+Tiano+WLEkz6/x22rnO0Ms0uy13tUJ5sLsSm2FfoVJ1?=
 =?us-ascii?Q?6DPPIDnTJX6G+8hgKBwdne0yHeQoKw/GKPcYb2twT76HBWL+gqMUtGKazSVs?=
 =?us-ascii?Q?GHUFJGbsGzvDTaC/OwRV3MiW90MMfgJsKf7Pxb2Q9KqFQGuhuNrwVNEj9WoZ?=
 =?us-ascii?Q?MB6DaUCG5fDwdVrwnbS4W7hkCIQvzSaRDj1VWbotJD4U98MqC/1QusnqPFao?=
 =?us-ascii?Q?G6oWhaAP0XuzsQNetMjynMqgWwM+z97jJXc0O7zps8696mGeAF2I6DbhzQbb?=
 =?us-ascii?Q?d2pqZA1nGsPp7emD5XP/eexQPav7Ai02QLhNRGqicf0MlDFlKrOZEvIQ4KaN?=
 =?us-ascii?Q?kFAlUbhByuNB8z45EGn8+cjUmETQyPx61/MC4nIh2Hpsl8O6AhmU0c6HnvT1?=
 =?us-ascii?Q?8X4TNN6EyQYmKEhrcAStaFFf9l1Yu/QoX75zJm/NGzsNf3NTNwC5zQAeMa9N?=
 =?us-ascii?Q?UuXsjvcDjvMY/P2tTwAm4LbGB5w3lQShc1ySJ10D41zSR9kVveWesv1s5T8q?=
 =?us-ascii?Q?ZdOWlY1+m89vB8uycEbiv3zvY4CizYexS3E0AhSvybOwnoxCIretHrpqOp44?=
 =?us-ascii?Q?Tx2wbsjXR/sHr+aO8Eypnj/y4oXApUoZgksCmuQfNQnGgHlPHfwTO98Aqq6+?=
 =?us-ascii?Q?LuCyD5tq3AFz940iQq8ox3abUZW0Q4NVaGX7D8l6vcAjuV/3ZqYjkE6owZKc?=
 =?us-ascii?Q?RTdoxwph2vZFUiHoVcyatPOIsiQl9DeZd4kJ6yy1Jdl+Ni7BahKTvL+Z7Xb3?=
 =?us-ascii?Q?avCX/OXlgEZCbnMZn6bYPX8pL05kn9FFbE61+THw115kpn2Um4PCE1jLfeGU?=
 =?us-ascii?Q?Tuqbq/c0DYUD8CqoxRSZimKsvLUIjcr/RxGfAQ6sFQgQcTfBiHxEFx+WdPS6?=
 =?us-ascii?Q?GXTP3uztE2RKViSgzwpuE62unpbnB/na9yS+wPb9wJkI7vmLYECY+3HJbYSO?=
 =?us-ascii?Q?IVCEmadoepDUWq12/zmdRLycjdrxgZRSOAWLHeDTOfWLk+EYbRjdtKGWA3Cm?=
 =?us-ascii?Q?RWk/dPoh9C7K1BptLcjiFjC7Z5cYkvnNN3Deh49TpXs3W5jKy6cc/VIYwSmB?=
 =?us-ascii?Q?D5YOGh9Wp19A8NHZt1+Z8ZJju7dknrg26+byhTn7iiVn25CJ61KJ9Llj+e2q?=
 =?us-ascii?Q?kYdSRiXFzvFGphFLkHndFapKCP3SjbvXFTWptyjmNy8Vbkoz0Q31OrSwWlZa?=
 =?us-ascii?Q?XbZNRnFKX7pvItfXrSnup+12aI1KSLsyqfXD8fZz+BAHoNFwMLkej4UJi1PQ?=
 =?us-ascii?Q?27ffrfpbsw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60deffd3-fd44-4393-3f18-08da16418ad0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:38.5497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+Vl10AFUtt7XZuIRLrqhZA0Cs1aHdd3ybSbmYadp+8E+EulE5Hz3qAyqf+QJlowkyJ8GdLZVR6suk1mhK5YnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9218
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi | 247 +++++++++++++++++++++
 1 file changed, 247 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
new file mode 100644
index 000000000000..17a33e54d992
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
@@ -0,0 +1,247 @@
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
+	sc_pwrkey: sc-powerkey {
+		compatible = "fsl,imx8-pwrkey";
+		linux,keycode = <KEY_POWER>;
+		wakeup-source;
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

