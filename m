Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5384E4FF4E3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiDMKhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiDMKhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:03 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E9FBE36;
        Wed, 13 Apr 2022 03:34:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=au5/F2QuRH96K6pSILaEs7sDbnjGqI4phoiduEKJf2cstyNA0NQ9FqqgbyBJDErQWo5bfO4zdsTgxWesoD5pq3vkuMpFj6nhhgRLRanaMEcOMuWs/Qi6QwpmrTnqEyp4hCXJk9H/bsMnW9KNOTBYJ2/12ckCkE1HJ+IGBl61cqsrEC8j1RLsX/IO9sf8gYOZrFIBToYd2EFWiJ1IhgoNsQdtS8ujzCX02/UjilK3+QckVbupqXQ1RdPOQBf1AO37l57i9lINWvfeT4clcsLdnjD2qUM7Gv03uZ483TaDgoM22SXXt1uhtqDlzTQKg6tMpFvHcAxlEY12SP8ovJO3BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3caNKl2IoTQCwKw/mQew/YX3PzIkfAbqnefH0pp1rs=;
 b=Hl22clZsVndnSZNVOpErGU3rVJEzqPaqpzRAykato9UxRanGXnkFooPxiDtEaWYmDOnGBQC1MgoRbdgN+R9J7f/5knlbHKJqLrPe4OaQysRABbDDTAqEBszTPhc+zxj42I/DOIUsmVPCJ6S9pquDPtnqojvnJD+l2sT1k/UJlhCWchQF6160COvfz/s2IXCqSoi9DwXlU4jH7nRu/MHe2CSJMEr8hODMERAxR+EGjbil091/ZiKinvasLjUbdyV/hQdJe1o2939XUszDpi1XXZdC1apCsFMkgXBNCo2wGUX66abGlb/yFUTxKmKtQVtrdNjr1D8GXFxrnJVGAX19Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3caNKl2IoTQCwKw/mQew/YX3PzIkfAbqnefH0pp1rs=;
 b=qJ1iKEf61uGAfyLH49M9g2QKivJMEiRFpheJZVOiEId4IgPBlTcVuLaAWC6nVOIePU5Rpsa0e68FeW82GDEUJqD97N3WFIFEXeWPimCv9M+8Zt/Ert9U475KJFt5EMap29+rpoMI9gw23kQu1q6orSvzECUtsrO6ORR5F0HdLGE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:38 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:38 +0000
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
Subject: [PATCH v6 01/13] arm64: dts: freescale: Add the top level dtsi support for imx8dxl
Date:   Wed, 13 Apr 2022 13:33:44 +0300
Message-Id: <20220413103356.3433637-2-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17fd68fc-7346-4e90-97b8-08da1d3935c7
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB86912D1A4425266F032A4709F6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzvsUIkgMsvRrdTnXKZBYgF83FRUEefTz1TZdDNx0rHkrUBfMn2bGcRA6EDocvCcX3eZYp6ZKlafN2YUl+ifxRV/TNlMTjjvI4dqpSc6BovG8t1mj/Ml7XEjRrPSdgpo9+ynU8GmzcSITc7t4CbiQPVj3bCBlveu2Fux4jZfHoheUUfOWjhqb7NLYFd0W+lcHmNX7odZ9TJfFRjeZgANC6DyoGG+dgcF2bMYTrO+RJ8rlb4v89l/i69nud7j+tsM1zLUJPb/omXDF0BZYRQbFp+tvJuyotGM3IM27ehmJ+wbI/skspe52JInFiYI6fifNeqrDqau6SyQksTsvI9r/eHiSeTfNhfleORJEEZUi/LnXdV0xMO28uYJnutm78I+doo6pSy0slZE3N/2EzZaLyJeS+BjY/g6QbXNtjSuUsPCM2lK0rqV4pXPl/5fuCjRfHHwypOSk5NsMlaE5am5ee7kkJu6jv7cl6fxInIpmNp6Lel83mon2H0I2K4IS2OD/VmInm7Eyab0MUyQMIEz8npWewJOdsggf4ccpWMcw+pvg2LwiKxIVsTn+qGW1gV7D4YaSBnWtbpr9QjAXI7uVDTXPgDqzIMMm5WpCgGUvObXnaLOdcC/T6yWT/dAoZ66S51Z8JJlFgJaCQ/+xOqGECykno0hVSDJxiLx8ijY/1dyhfAhRU/LISpMcOQxsXV5zcFamGQBd5l6DlMCPh+cGnltf/vZxBmO39SkCGf1JoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(6666004)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OF5leYegq+WkdeYkDZ8ffFgUXYIbUrRFhOGIvcG3OClKNFjnUmmCmucN1hYI?=
 =?us-ascii?Q?tsmR2Hri7oqZtKu1BbIA7giCcDnHCXbEgUYvTzPnEb1A44QUOpeWQZOTd3Th?=
 =?us-ascii?Q?ojEARMIucEqNQ73l/gtgSy3i3YfiI7vCZ5JO3Zp/o6G5ymecSA4aNd+ZXhYT?=
 =?us-ascii?Q?SeEgPHGPr5wEhxxCn/G2MtHhDQvw4mcRNUboglmMj5HvQqPSP/5xGilFEXUi?=
 =?us-ascii?Q?0TXRka0hJluUE9IOesbtci3gXoIQl7lQrglK9E+FyoIvoIPgGzpq3uoOnQBK?=
 =?us-ascii?Q?R4G2FZrXNkYE9XyyefuHYu8+zPGSo7u7ypEid3H5SnkDZJ2N/zcHJOpCL3lc?=
 =?us-ascii?Q?RloVqYZtAV/4BbCRi3n2UoC/7xENaee8ZLVFGmODja6N4CHUPUt8cGB4aTPv?=
 =?us-ascii?Q?u8NqIxELqOvgNYK7M/+WddBTuCpS7isAamVRcLmv1ahu923+16jlde6KYtEc?=
 =?us-ascii?Q?b//C/9Xlkpj40hhV3MO8wfTs3uBL9mqpYRteUH7DuYWbvnc0pLpPq/eHaKUy?=
 =?us-ascii?Q?sOeI3GmKeEyx7uFa9UZwZzIUzc4M6C5v3gFoTnHsCkhJxm3foLxcEA9cbRkz?=
 =?us-ascii?Q?wpAKaAU1xwbY4oTBZdkdR5085XauDLHHUNn6W9IBvsQRQA2RvLTYdktc9Noi?=
 =?us-ascii?Q?c6YvRWQMMVuKaUXEAASnjUQv6XnztC4xFlbKAnSfn2VZajputmo2+vYnSMpU?=
 =?us-ascii?Q?oLiTrW7Xv/rVrKrfz0AA8bTMM1E4DYIXZx2KRtslMBO7ode9jYNM18/i87nJ?=
 =?us-ascii?Q?OGs7YRhb+eXTy9qaYvm13pY0FXFHuNRCbn95LYnkT20zCb3wZesVON5BFLcT?=
 =?us-ascii?Q?VK4k6PGfGnpqbb/mXEsMrFpdjbApm3DUoeQ9rcM1D5TxiSMnHbWAPN8r74KZ?=
 =?us-ascii?Q?J7CQpiYIKMvEZ8L/ug9EE1nzd6bwzlbPu9biMIRmSxfZP0Z8F8DuKhBQbDlt?=
 =?us-ascii?Q?0QiiTFLb7IdTVge/2SzZqSx0iERl6Lr/Aq+6noC3oVGAet9EQ6mDF7tx4Lvl?=
 =?us-ascii?Q?K1ov3kXWS/aonhN4NNxt0EvVuzgjRvO/b/iEcasjbg/Ysv+IiZiB/As7V/qW?=
 =?us-ascii?Q?YJHNY83E6V2TmVffW7n09pvCIqmoqU8tMT/1tJYLAd/YOKKoP4A/Q6O5Hww3?=
 =?us-ascii?Q?AbPN2nHPH4wh0ebxhSrKPCbKJgpgj7vS3jBeSo5hgjoOWIdJxw/owbzBgb56?=
 =?us-ascii?Q?8+/8R3wpxvqa+anX1SXJHGtyocR6mSZwxtuNQbPy9iTgP8NaAIWd9J+s+iLA?=
 =?us-ascii?Q?YyLa7ODz0kKulelSjtLNl3jN950y5tZJwDraGNOfalg9vS2Fenj/DMGe8bAK?=
 =?us-ascii?Q?hl/BRImmi6UmKfTnh+eOq1/ASFebURvtq6mUW6F/ApMEsGD9XhQJjThirxRF?=
 =?us-ascii?Q?wy68v/aQyn7EGLgqyrcr+BtnjUT8bdtCFapB6XzUxMSmiiaM9J5vomQI2DPL?=
 =?us-ascii?Q?593DNsR1lXeD7OIVCr1Df2+pKP3vw/1MIGRjS6ICU/DtK6RTgF3XeNGFEf/g?=
 =?us-ascii?Q?R8we4Fg+QtybHMbZShUYHrmVuU3XtRzaPa/DisDVNX53xuUO0Qbi594aJjGZ?=
 =?us-ascii?Q?l3vlPW+x648HkUmaOCyPAm3Kk1TWN05lcXkOYaAd/ddCmM+ibOHuZeoqqmV4?=
 =?us-ascii?Q?Mqi30gDVjb8icgNbT4fZ1EKoR5vnjV/12CEi0L9gQcyWiV1TQ/geMPHcF6ZJ?=
 =?us-ascii?Q?EDvC0v5PkZgMp8GgDt9WC/xiPxXY359fyFcS+VXuKpfqHo3vIWCJu5omzC8b?=
 =?us-ascii?Q?v5nFU1GLQQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17fd68fc-7346-4e90-97b8-08da1d3935c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:38.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzpFVzgNkMB1wBpRcK2GhZ05gEcbxWdkxqLoJIX93rHFnieUfc4Xan2jK0cBNifWKS4YxT0PG4Tjy4TySGZiJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
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

