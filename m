Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2B05069D5
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351087AbiDSLYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351035AbiDSLYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:02 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE612657;
        Tue, 19 Apr 2022 04:21:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aioQHGrudKHwZ3tYuAx1keP3sbWWwF8Ln2tE2+GmzEd0Q+u3+fbc5tduH6YJgaNR4/tif1mvwTxUz/xU6qHKJbPM9vkDSb+MoefwQSdCQK9UXaHATO1uhxTA6+R/baahQHbK+pYC/cbYVWGW8eHd96fe/OB7tk2z/reGoWTAnmb8GngBevJ1l2lI2DXC6k27RP9Q20oswHROEC2JvDDMrFO/7TEWqUTChY4zXX/2yroklwWWNP2TgUTtyfmc4Hz2SY+SX7e5jYpJc8klsltI7IS2qHoV8HN3zje7krGOQMQxZtfAMtatuTtdgVvyRYWEiYvNtoB+RbH95Dbn5HwKSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3caNKl2IoTQCwKw/mQew/YX3PzIkfAbqnefH0pp1rs=;
 b=ecncBVBG+xVKXZ9KLcieMnh0N3GxdY6H7LEd1SGJte8IRBaL2QQwZlC8aRrGt+o7tFN1m9i3lrDczltYH/7gSEEXK7dWY1/iJAf027sk48Tork3MFbSi20qZA3k/JV1jtWo/ETwq1MqshqDKw0L+rQvdzvyj+mn6AMV3Qv1KU1umMcaeb8mCIokvY9iqaDOG6UWTRvpR0aXpY3lSQhuKR+aHjGpi0gQWTTO2PO+VDJz7hPDeHXgDJprwqHTlq8IFQK+LqgX8YPr48fBt2F5q8CRxoH3AmH3KrlyTwOw7nyjeAUBhvHsBOkmY7J0Iqp8es1FuBB1a7EOaoLczZg7OgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3caNKl2IoTQCwKw/mQew/YX3PzIkfAbqnefH0pp1rs=;
 b=Ys/6v65ueA7I4GbGkq7jdNs/GqZmFZuB4McrOqqgY1+EMeq1GBZUZ7TqYoEKIzMnxkaZsvpgdRAndR7QC95UJW+/y9eH8Y0sfQC24/i5iM8yVKiCT9kWBilKlP0f283VjEHjB+mE2kqwEfBgNV6efEIr5rlfBuYcBhqWQzxn0aI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB8PR04MB5931.eurprd04.prod.outlook.com (2603:10a6:10:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:18 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:18 +0000
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
Subject: [PATCH v7 01/13] arm64: dts: freescale: Add the top level dtsi support for imx8dxl
Date:   Tue, 19 Apr 2022 14:20:44 +0300
Message-Id: <20220419112056.1808009-2-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e71157e2-6b52-4a59-83f1-08da21f6b91a
X-MS-TrafficTypeDiagnostic: DB8PR04MB5931:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB593152ABCDE35E16858CEE7BF6F29@DB8PR04MB5931.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LX41HCBf0ziV8za6sAKjp8tlPtx54ma8+WBZBIAQAHsOutT2UdZU3WvJ46urFTqt6uvr0XBQZrt6kvMt/1MKMlY/t68RfRC0QdrN8OWX6VEzHgVocrvDAj1oxq0RTrSXxr2JAytxMI0AUjSLSSZS2dXaSKZYQw4SzsBBhSPAa6XvPNsNdcFlCPXjB3xAbsAeVkJEZGMr8hyEK+1yKidn1LBwUQLw6+a/FKHC3BoTL09AfL9Jd5f8BgtGmM/QIYWOnXJhCyaJMrMl9e8mYP6FWhM9iK8NNa+8jbk4D6BaKLLsSbLWMmMmiuvGvxj8j1sidKcgfTCJZ7uj9iSdmcvaR6QH5MHNMnOAmlrhTplI7BDTmO4rDe1lWiRqXUOjr+HFheeEDyIx7NpgCrsT9xP8U3QOtAgdb6VTrDdHYadqf+KXrfA9nBf/yefClIvy3bGlcS8h8eUOuAizgjmYLLIyeBQE1Zly89EKjD6+CKj/OCQDawRVCH1OIVrb0nqiZwGZ74rzRYFCyUTg1Ft4Oy3Wnf0gNXvdbIxpNuDiSfOYtUIW8Q/PUbkb0Ixnh1j89q1VVBbA6EO6clD5aGXFY7yaAaUoLdvZBZruymRlZxsLnBPKdr0NjFfc2SqeLSGStpf4XLYBZQOw5upN5nDHupTbtfUwRmcztAV5Q3SEqTzRuF/VH9H19++ErGZSzRYiOpVxLwfekX0veYv/IbboIdCLLe43qpURzyI5n5XmPtunvrI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(26005)(6512007)(6666004)(8936002)(8676002)(110136005)(186003)(52116002)(38350700002)(38100700002)(6506007)(2616005)(86362001)(44832011)(5660300002)(7416002)(83380400001)(4326008)(66946007)(66476007)(66556008)(36756003)(2906002)(316002)(54906003)(508600001)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T3GRG/cOOMwy8OD6YcbH4gmpUOUrooMClvUCuF6VT78tjco2vXHAk/vXnC7m?=
 =?us-ascii?Q?84E6S1/xPvKN8g0zpSIcMv6Q/FztJXCpyJOkoNcKAzhUDLFviGwKnuS8GQHU?=
 =?us-ascii?Q?FukRXWUuWybCS6HJTuJMtL6SDXG5C4Gyp9sJ5GhEfuoX1uHllC2/HsFh6v8Y?=
 =?us-ascii?Q?FpKRLX+FyoAn5O5WrfNG8IlKkts3X47Sx4vk5oSjHUXcgMFdVvFbK3NhLB10?=
 =?us-ascii?Q?qcgK5pNX2at/FlIL1CjPEzRWfF33y+SNIXhWs7GhyTj9osSUiLE+uhShGq9B?=
 =?us-ascii?Q?CoQs9I/9dqYHxS6TSRvJKCdERiS7H4INXA9bMzGyCVdndkwHQ0zue1/Eqcrw?=
 =?us-ascii?Q?92iLiHXkQ81lipdSiqqEAvmJtJKip9KrLfCbBpvEXBPmxZJpjIHcEivaVH9Q?=
 =?us-ascii?Q?ZJd0FAfGbYp10VwWdJn5tusYOpSCaCib8N1tGBeu2apx4E4ZStc0Jetol9hF?=
 =?us-ascii?Q?njhz7uyncy6xzv1QvLEptqVTqVyYzD1t3Sjdya+f1dAfw6ebgteufFlgIRG1?=
 =?us-ascii?Q?/+ezkAQkP5wysbw71WboV0IQWVwEr5iR6VM0zn21q0QeTbnk5k6z/TDpVgA9?=
 =?us-ascii?Q?RluoMvb0hWtFLei9sK4Zc5oHbCJm3qSZ683fP06hl1dDrY76cC02cw7fgNDS?=
 =?us-ascii?Q?bSIgHSUzB5T+4IecnHTINzM2zLAI5ZBsPw9MpitCn6GOseTaCvlSJ4L6fs65?=
 =?us-ascii?Q?8OIih84jlOmplcYdpECmpk/Wk1sKVvqQ6Cj0e1Dlz8/I+GiF86LIIlEcgNWZ?=
 =?us-ascii?Q?+JT4HwQH88+km/kesYtYYM/hFqYMkIeRC7/dXjF9FYZRsq3HxccymxsEci48?=
 =?us-ascii?Q?YvShFIcbpEKHWY8tVoway0QnSmCQpl7kan819oMOjtuHhOeFUkyy/eXJ5Mo+?=
 =?us-ascii?Q?gUcaRfJ5r+lsrWo8vefFjiA4IU8MPBLVYA2b6YyRxpaV/Wj0+JNx9iq2k5Vi?=
 =?us-ascii?Q?rbb+Zzdm6z+S7iNHILUMrjHx514v6o3aWEL1H9HwwxJBGd6Wjvkvwf4Y/yd6?=
 =?us-ascii?Q?ehBXYJ8ztMSA4PkcgjMjhzXW7Kj/pqKLueltDZLe2c8PcW2CQVyBIXaG1Q0A?=
 =?us-ascii?Q?mJ21WIS53TyL4GKu38lsyYZHOmaB8UfIkwDs+UzZOVMJzeAMgnq9thBSnY/h?=
 =?us-ascii?Q?WmbuRWOsDUMWAV/KBkcxiv5rvxWGZnukLy5hBgckfQabLrGzH0oJn5XHYUYZ?=
 =?us-ascii?Q?9uUIGrPVck57rpZrNJT/HpubadTJhWxffzkyeLmPg/6xl8IwEnfphlwy4NS0?=
 =?us-ascii?Q?jLdg0O3XIBGrTlvHqip7qIFwus6hMx1BVMWtzavl+fyMcta3ZgKv//f3ZY9c?=
 =?us-ascii?Q?DsVXY3W8Gl9xTL/eRXkZDUgOSTucPQHD/07biLy5sFzUNN36dYzSIYrNgBqQ?=
 =?us-ascii?Q?LJwV+Zu71D6oAhZY70JQFp1woMkrVEnMsNNy1mSzbplo/cQicYOlQOHundQG?=
 =?us-ascii?Q?t3L6wKJ0ot07Yk3sbJyDxVEFPDrlY6VjI49+6QOSX/qmX4mlgcRJdR+GdBkN?=
 =?us-ascii?Q?Wre7/nE4xjESIRLtAOLYBh/23r7VlyRoirmW2ZRCyAbipo4ZT2KuZkMBXqYm?=
 =?us-ascii?Q?JQLZHHO/JzE7RfstbLzQ7VgNzzA080zeob23GSANBwJeL4GYxPRwPk8EeCka?=
 =?us-ascii?Q?F59jGxArTkA86RImBs9b2QMNxV+X1vnRYKYX3CQlxlkdWhWsnroP6VXB/2/a?=
 =?us-ascii?Q?Gzr4TLDtDyF5lgDHhhg0x0kFZchUk6SZQXCKR2rs1QtQQ0WeldFFmCQaZAWF?=
 =?us-ascii?Q?N5WJdWa/Dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71157e2-6b52-4a59-83f1-08da21f6b91a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:17.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VGmCFhoxP9tc3ZJ7JW4HOwu4dkzHDS1qURzVZ9LCcbyCGYponc1ZEy6qqLQ00gG9x2pMPzaxypXz+NoS5a/Z2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5931
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

