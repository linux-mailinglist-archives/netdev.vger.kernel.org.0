Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF00506AFD
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351806AbiDSLkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351680AbiDSLjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:15 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF033E3B;
        Tue, 19 Apr 2022 04:35:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNV72Lzgb+FZw+tmXBVeFkmkpJQ7mphfXiIAB7R8HE2uWj6WJFnI1Kzo9taAmQACfjG2w/he24I+LoHMBinxrlnzyL/znTaiz52LBjHbqwMWG6Z7XuMEVcSdjvgjcL/ac1y6t3qOdCUQePpf6JCjnjfOr7UH2weZk8AR8+naf6yK5qYd89K1aU6Ee1lpsWQbAjfDjho+voG/JjJU5i4SvH7opyIqSGHlRrzH0ZqVtrgguAylkQ3/rPokIZKKXw5c0v03GENGjvNRGmVirtEK5rFdDDdc3SDV0Jzlq0dbAJgFJAq1kHVU8Lm5Jlw1/EGmVOTAGrSJpeHdXT2GGSmNMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAjF8vmSEdU2fUZPos1n2fJDBcmLIVE30k4RMlvHFww=;
 b=Iwxc5vgPpBuh+9m2sO2Vu/cze+AR1p4WNHwWigp398wiZWtebo0AJBHsbqiKAQO7lyWAK0OOjG+7Wc2G7YiVuVg/vp5GrSVsclaZMDe33xggVlKdOIopTcfKqKRa6fUKYjWbXgyaLLVWUN2pH0srvw5t4mSdrD9OEIROA8uJ3F11zWFhF9q2olQCy+dUGQV2FFLLgPXBnH85vWQ1eMGrhSWc+lhIejVKwtMkBbA3lxkY2bkt453JdN4rj2xO21zD8H7MygR7J0kQaElMGV7oTS/GbClGW1UXN13EzumqQWE9yDTVkTSty0D5iI3fJdhsGR04uCO8AxhZAubaE6nj6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAjF8vmSEdU2fUZPos1n2fJDBcmLIVE30k4RMlvHFww=;
 b=EQwy4e4O5N+viXrT/4KZfieUgQfYQ1ZOIle0OUsraVdz5BGdg+WHENu5R29LGn8CGJTkOYonyHVPEvtIjLiLSH9S49MtBo2Wf3Ya72MEJn3vXUlCd+HOLPiGI17cW76aeoWXcv8RVjwE+/+I4CfEt4X/swBXQMfmwri3cCanhMg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:35 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:35 +0000
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
Subject: [PATCH v8 06/13] arm64: dts: freescale: Add i.MX8DXL evk board support
Date:   Tue, 19 Apr 2022 14:35:09 +0300
Message-Id: <20220419113516.1827863-7-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a73d9bf3-d9f6-4d88-805e-08da21f8b85c
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB305420C044C7C5AE4898FB5AF6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tOmLfH/KiiHjzFcn5E/qEMPKH89fwyjb5vNMl2y9pNlHY+Cwj9nOqEuUYLbIZvuuDgpVGa/TakhvQPUibpyYswxf0RQYzL19teWn9Ddluggz4C3yCwDF9xJlGN0MraDlzSeMR4BPuqI7Z8g7K6Csh70Ub1yLwiauLHpR+JRYH5JNQNp5QlomZEl/6apQSYeprjD10hLSM3woaJ+5XwL44Lg6AiEibGxczP2LA+wpsBodiZkgClQLq0ofSX9jaFT/6cz4Bks5qOJloNK2B7ujaE+N7cLqSpy8oaX6AqtIYoh8dExhd/zcCVDbl2xXmqQoieANHGCZ3yXmt0HjHxatnS3LvhpzWZ8U2O1Jom4u2vGTQPqZ4PhpnB7NLFElf//HKU0Vtz0i08DUiy/sLIp8vUdMpMnHmNLfuddgNktxInpwtVZu6Ge3myFpgdPvlIl9MoNbXMpJDsfJVmaPf3eZbG/bwDIRqB3xhx2ESpCJFQvJ7HzlGuzYrk0m5RTSGvqZYEypIi/JYRGm6R22Y6m9goqltbLdHOZiX+/nOnNGwgVbJ3mL55mz/w1CDPZAJd+qbtWC+1jLinBb9sgeHswM7bdZvdwgTFaBYoKR9t8T8weXVBihia8gFhsQQkt0XiLQdSkLfXL80KQnnU1bfW0G19c0BHigpqb0Yin4aN9lp/DP1kuk/4rMn79pBqASi/5nf2v3G0CGqrgm8CE0zDdL5nbsjP1RR3TOkJyaZI4HrBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lST8HeDhZbD82NdNJqAhAthV0zvPOINL1/elmYtewqMJ0cZ3SnxcYZlHDrlY?=
 =?us-ascii?Q?DRVg57GHa39nKWOFobQ14C6UQwrqlE5wt4LV52RU/cuxML7YejsXL9cof9AC?=
 =?us-ascii?Q?8kG/nJft9W/pFFaIYFUatD7is+2zMpKA1QgxEvxzBLEW/zX2gPVgD+xVrBKK?=
 =?us-ascii?Q?cNYELrI6eYAFWaVNDF+KpdgyRUmyjLdDUCSgj/8WUCd3Dc9r5h3F3VSfC6Sd?=
 =?us-ascii?Q?W+UwnOLgYK6cDSV73mdiXXIVR5qUIhv+Sn2Rp4HdhgQBNLnvbHmu2DRfNt61?=
 =?us-ascii?Q?Q8Frcnux3Ze2j+8b/9Fn6vCOc6DZyCQXIvyQw0GAaHaIqLxcMCawdnwMSfaa?=
 =?us-ascii?Q?mr/t74RcEG9jXNQZ03I6t4thkTUI3AIkmbG/Zs96jxav+IR/ZX0i2b02XAwF?=
 =?us-ascii?Q?mV3o+PXlNRQ5LdXNeaodV0X7YZKh6//fWMNM91w5cu/GFKz7nekgehRJrE2C?=
 =?us-ascii?Q?rAn80EZ0iIRVI7LXqx4cW3632iU9zjrLcMYTXTXf4WPa6N+9KY48sKeunZ+f?=
 =?us-ascii?Q?t87S0TewxiTRpUL91xOG2PHkJv0M8zM+11EjJ8RHqVHehAydyEm5gTomR9XA?=
 =?us-ascii?Q?enT74HrdpRpisjYJGVYx7CikXxrEupsKSFIUiwUjot10vEGqr9Pp9mcdEtoW?=
 =?us-ascii?Q?mkRSO5AEckRYJRlXZRL9b1Sf5/Oio+xXXCho3bXsfU0Phrwwduwlxt4JoR8s?=
 =?us-ascii?Q?PNZ1gJkJL12yrRqrXVzcG9evcc8ll1tIL7bVa/uAY4FSIv7vt3FSofRzFW1d?=
 =?us-ascii?Q?KUomBQKuLhghnnT+sO120ENb/gfRHMeyq9J1xBVsB4bjYRV86Ogaghv5LH1E?=
 =?us-ascii?Q?3BemY/M6JngARz2CJON87ikRIS3D/mJLqfSlSEw+VCJ+20DFc2iIhFKc29c9?=
 =?us-ascii?Q?KmcIO7vJc2h2fXvsa8ef0SgnZm+CREGEA9fE5zDAEbIG19RecdOtSPGALTN1?=
 =?us-ascii?Q?RrNAhXsaZ6f+O/G8Hr+vQEKPhn3lmEafDdpKnb2h8QF+mwlVNE7Se6hHZro+?=
 =?us-ascii?Q?VPmThv7Si10zZN1ZtVk46RoUGMJrX7FwzPZt8M5C/d1aNv5dVpilkdgKVHTB?=
 =?us-ascii?Q?HXbxc4JL4d0Fspv2uEMc3wDjssZIojoA0sG5UuNwAeY3/OvvXK6/EcRLk1+J?=
 =?us-ascii?Q?SewpLyJweamlViuEKwtOY1Oj937jdf4DJMrdJ7fILUE1wq4Cczzlw5NYNnNA?=
 =?us-ascii?Q?ziWMulsX/YgPbJKwq90X4Fedw+kNRPUg8qN1uBqbhwIOB/VThVSNjtRrj3Fe?=
 =?us-ascii?Q?weHp5tEFBEQ6id8sYpkOGs1AmepIzevtONItZt+p5NJ6BIHtHD1Vo/kzCyTd?=
 =?us-ascii?Q?e+gGhNTOw4vIJfYHZWvBpXazTN+zgxhp86CY1X1ZRqvVu3wQEiugsdgNEP4V?=
 =?us-ascii?Q?L9AwxzT5uttHccg8AF3E+qVqQIfanyUL4AELYR2VPg/GAuUbZ2bmWlsINjcV?=
 =?us-ascii?Q?TrqJCBxQzLsuomF1t/Kg/rV0c3VDNuOje8u35kYiQvFL92/zysrE72Uo1l9c?=
 =?us-ascii?Q?Ah9U4oPHUmDhcJHCpVE6/kSlzNb8roBULh0yxgrUIsk0NMRQJFfHNvSJKN14?=
 =?us-ascii?Q?dfg8mIIOvUiZbx/qjcVkfHiWliZ+vIrvg1M6fIc74MMAz/SaMqUr1xU6pLcX?=
 =?us-ascii?Q?APfti3dT3pEhotdfp+Zmv2iTLcLdDDk+tVmFHkzSbNqI6IDHwF+9oS0ePAl5?=
 =?us-ascii?Q?nueokA6F+cI6nk7jJO8oG8bOFwaXwwwd0JfdJOUtc6ULKH0gg3Y2COsa/Y+U?=
 =?us-ascii?Q?tp9DW1kKpA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73d9bf3-d9f6-4d88-805e-08da21f8b85c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:35.6272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqAPXdRMrXkfE415tAsu2xPspu7/S/0Yo67pq0j4L0LgY+OsVcBRcCpfnsBZhGsNHeD3W0mm6E8sBuY2orTNTQ==
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

Add i.MX8DXL EVK board support.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 269 ++++++++++++++++++
 2 files changed, 270 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index 851e6faf8c05..e6ccfee3371f 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -48,6 +48,7 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-qds-85bb.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-qds-899b.dtb
 dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-ls1028a-qds-9999.dtb
 
+dtb-$(CONFIG_ARCH_MXC) += imx8dxl-evk.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-beacon-kit.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-data-modul-edm-sbc.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-ddr4-evk.dtb
diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
new file mode 100644
index 000000000000..108f4420ffd3
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+/dts-v1/;
+
+#include "imx8dxl.dtsi"
+
+/ {
+	model = "Freescale i.MX8DXL EVK";
+	compatible = "fsl,imx8dxl-evk", "fsl,imx8dxl";
+
+	chosen {
+		stdout-path = &lpuart0;
+	};
+
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0x00000000 0x80000000 0 0x40000000>;
+	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		/*
+		 * 0x8800_0000 ~ 0x8FFF_FFFF is reserved for M4
+		 * Shouldn't be used at A core and Linux side.
+		 *
+		 */
+		m4_reserved: m4@88000000 {
+			no-map;
+			reg = <0 0x88000000 0 0x8000000>;
+		};
+
+		/* global autoconfigured region for contiguous allocations */
+		linux,cma {
+			compatible = "shared-dma-pool";
+			reusable;
+			size = <0 0x14000000>;
+			alloc-ranges = <0 0x98000000 0 0x14000000>;
+			linux,cma-default;
+		};
+	};
+
+	reg_usdhc2_vmmc: usdhc2-vmmc {
+		compatible = "regulator-fixed";
+		regulator-name = "SD1_SPWR";
+		regulator-min-microvolt = <3000000>;
+		regulator-max-microvolt = <3000000>;
+		gpio = <&lsio_gpio4 30 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		off-on-delay-us = <3480>;
+	};
+};
+
+&lpuart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_lpuart0>;
+	status = "okay";
+};
+
+&lpuart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_lpuart1>;
+	status = "okay";
+};
+
+&lsio_gpio4 {
+	status = "okay";
+};
+
+&lsio_gpio5 {
+	status = "okay";
+};
+
+&thermal_zones {
+	pmic-thermal0 {
+		polling-delay-passive = <250>;
+		polling-delay = <2000>;
+		thermal-sensors = <&tsens IMX_SC_R_PMIC_0>;
+
+		trips {
+			pmic_alert0: trip0 {
+				temperature = <110000>;
+				hysteresis = <2000>;
+				type = "passive";
+			};
+
+			pmic_crit0: trip1 {
+				temperature = <125000>;
+				hysteresis = <2000>;
+				type = "critical";
+			};
+		};
+
+		cooling-maps {
+			map0 {
+				trip = <&pmic_alert0>;
+				cooling-device =
+					<&A35_0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+					<&A35_1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+			};
+		};
+	};
+};
+
+&usdhc1 {
+	pinctrl-names = "default", "state_100mhz", "state_200mhz";
+	pinctrl-0 = <&pinctrl_usdhc1>;
+	pinctrl-1 = <&pinctrl_usdhc1_100mhz>;
+	pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
+	bus-width = <8>;
+	no-sd;
+	no-sdio;
+	non-removable;
+	status = "okay";
+};
+
+&usdhc2 {
+	pinctrl-names = "default", "state_100mhz", "state_200mhz";
+	pinctrl-0 = <&pinctrl_usdhc2>, <&pinctrl_usdhc2_gpio>;
+	pinctrl-1 = <&pinctrl_usdhc2_100mhz>, <&pinctrl_usdhc2_gpio>;
+	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
+	bus-width = <4>;
+	vmmc-supply = <&reg_usdhc2_vmmc>;
+	cd-gpios = <&lsio_gpio5 1 GPIO_ACTIVE_LOW>;
+	wp-gpios = <&lsio_gpio5 0 GPIO_ACTIVE_HIGH>;
+	max-frequency = <100000000>;
+	status = "okay";
+};
+
+&iomuxc {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_hog>;
+
+	pinctrl_hog: hoggrp {
+		fsl,pins = <
+			IMX8DXL_COMP_CTL_GPIO_1V8_3V3_GPIORHB_PAD	0x000514a0
+			IMX8DXL_COMP_CTL_GPIO_1V8_3V3_GPIORHK_PAD	0x000014a0
+			IMX8DXL_SPI3_CS0_ADMA_ACM_MCLK_OUT1		0x0600004c
+			IMX8DXL_SNVS_TAMPER_OUT1_LSIO_GPIO2_IO05_IN	0x0600004c
+		>;
+	};
+
+	pinctrl_i2c2: i2c2grp {
+		fsl,pins = <
+			IMX8DXL_SPI1_SCK_ADMA_I2C2_SDA		0x06000021
+			IMX8DXL_SPI1_SDO_ADMA_I2C2_SCL		0x06000021
+		>;
+	};
+
+	pinctrl_i2c3: i2c3grp {
+		fsl,pins = <
+			IMX8DXL_SPI1_CS0_ADMA_I2C3_SDA		0x06000021
+			IMX8DXL_SPI1_SDI_ADMA_I2C3_SCL		0x06000021
+		>;
+	};
+
+	pinctrl_lpuart0: lpuart0grp {
+		fsl,pins = <
+			IMX8DXL_UART0_RX_ADMA_UART0_RX		0x06000020
+			IMX8DXL_UART0_TX_ADMA_UART0_TX		0x06000020
+		>;
+	};
+
+	pinctrl_lpuart1: lpuart1grp {
+		fsl,pins = <
+			IMX8DXL_UART1_TX_ADMA_UART1_TX          0x06000020
+			IMX8DXL_UART1_RX_ADMA_UART1_RX          0x06000020
+			IMX8DXL_UART1_RTS_B_ADMA_UART1_RTS_B    0x06000020
+			IMX8DXL_UART1_CTS_B_ADMA_UART1_CTS_B    0x06000020
+		>;
+	};
+
+	pinctrl_usdhc1: usdhc1grp {
+		fsl,pins = <
+			IMX8DXL_EMMC0_CLK_CONN_EMMC0_CLK	0x06000041
+			IMX8DXL_EMMC0_CMD_CONN_EMMC0_CMD	0x00000021
+			IMX8DXL_EMMC0_DATA0_CONN_EMMC0_DATA0	0x00000021
+			IMX8DXL_EMMC0_DATA1_CONN_EMMC0_DATA1	0x00000021
+			IMX8DXL_EMMC0_DATA2_CONN_EMMC0_DATA2	0x00000021
+			IMX8DXL_EMMC0_DATA3_CONN_EMMC0_DATA3	0x00000021
+			IMX8DXL_EMMC0_DATA4_CONN_EMMC0_DATA4	0x00000021
+			IMX8DXL_EMMC0_DATA5_CONN_EMMC0_DATA5	0x00000021
+			IMX8DXL_EMMC0_DATA6_CONN_EMMC0_DATA6	0x00000021
+			IMX8DXL_EMMC0_DATA7_CONN_EMMC0_DATA7	0x00000021
+			IMX8DXL_EMMC0_STROBE_CONN_EMMC0_STROBE	0x00000041
+		>;
+	};
+
+	pinctrl_usdhc1_100mhz: usdhc1grp100mhz {
+		fsl,pins = <
+			IMX8DXL_EMMC0_CLK_CONN_EMMC0_CLK	0x06000041
+			IMX8DXL_EMMC0_CMD_CONN_EMMC0_CMD	0x00000021
+			IMX8DXL_EMMC0_DATA0_CONN_EMMC0_DATA0	0x00000021
+			IMX8DXL_EMMC0_DATA1_CONN_EMMC0_DATA1	0x00000021
+			IMX8DXL_EMMC0_DATA2_CONN_EMMC0_DATA2	0x00000021
+			IMX8DXL_EMMC0_DATA3_CONN_EMMC0_DATA3	0x00000021
+			IMX8DXL_EMMC0_DATA4_CONN_EMMC0_DATA4	0x00000021
+			IMX8DXL_EMMC0_DATA5_CONN_EMMC0_DATA5	0x00000021
+			IMX8DXL_EMMC0_DATA6_CONN_EMMC0_DATA6	0x00000021
+			IMX8DXL_EMMC0_DATA7_CONN_EMMC0_DATA7	0x00000021
+			IMX8DXL_EMMC0_STROBE_CONN_EMMC0_STROBE	0x00000041
+		>;
+	};
+
+	pinctrl_usdhc1_200mhz: usdhc1grp200mhz {
+		fsl,pins = <
+			IMX8DXL_EMMC0_CLK_CONN_EMMC0_CLK	0x06000041
+			IMX8DXL_EMMC0_CMD_CONN_EMMC0_CMD	0x00000021
+			IMX8DXL_EMMC0_DATA0_CONN_EMMC0_DATA0	0x00000021
+			IMX8DXL_EMMC0_DATA1_CONN_EMMC0_DATA1	0x00000021
+			IMX8DXL_EMMC0_DATA2_CONN_EMMC0_DATA2	0x00000021
+			IMX8DXL_EMMC0_DATA3_CONN_EMMC0_DATA3	0x00000021
+			IMX8DXL_EMMC0_DATA4_CONN_EMMC0_DATA4	0x00000021
+			IMX8DXL_EMMC0_DATA5_CONN_EMMC0_DATA5	0x00000021
+			IMX8DXL_EMMC0_DATA6_CONN_EMMC0_DATA6	0x00000021
+			IMX8DXL_EMMC0_DATA7_CONN_EMMC0_DATA7	0x00000021
+			IMX8DXL_EMMC0_STROBE_CONN_EMMC0_STROBE	0x00000041
+		>;
+	};
+
+	pinctrl_usdhc2_gpio: usdhc2gpiogrp {
+		fsl,pins = <
+			IMX8DXL_ENET0_RGMII_TX_CTL_LSIO_GPIO4_IO30	0x00000040 /* RESET_B */
+			IMX8DXL_ENET0_RGMII_TXD1_LSIO_GPIO5_IO00	0x00000021 /* WP */
+			IMX8DXL_ENET0_RGMII_TXD2_LSIO_GPIO5_IO01	0x00000021 /* CD */
+		>;
+	};
+
+	pinctrl_usdhc2: usdhc2grp {
+		fsl,pins = <
+			IMX8DXL_ENET0_RGMII_RXC_CONN_USDHC1_CLK		0x06000041
+			IMX8DXL_ENET0_RGMII_RX_CTL_CONN_USDHC1_CMD	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD0_CONN_USDHC1_DATA0	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD1_CONN_USDHC1_DATA1	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD2_CONN_USDHC1_DATA2	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD3_CONN_USDHC1_DATA3	0x00000021
+			IMX8DXL_ENET0_RGMII_TXD0_CONN_USDHC1_VSELECT	0x00000021
+		>;
+	};
+
+	pinctrl_usdhc2_100mhz: usdhc2grp100mhz {
+		fsl,pins = <
+			IMX8DXL_ENET0_RGMII_RXC_CONN_USDHC1_CLK		0x06000041
+			IMX8DXL_ENET0_RGMII_RX_CTL_CONN_USDHC1_CMD	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD0_CONN_USDHC1_DATA0	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD1_CONN_USDHC1_DATA1	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD2_CONN_USDHC1_DATA2	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD3_CONN_USDHC1_DATA3	0x00000021
+			IMX8DXL_ENET0_RGMII_TXD0_CONN_USDHC1_VSELECT	0x00000021
+		>;
+	};
+
+	pinctrl_usdhc2_200mhz: usdhc2grp200mhz {
+		fsl,pins = <
+			IMX8DXL_ENET0_RGMII_RXC_CONN_USDHC1_CLK		0x06000041
+			IMX8DXL_ENET0_RGMII_RX_CTL_CONN_USDHC1_CMD	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD0_CONN_USDHC1_DATA0	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD1_CONN_USDHC1_DATA1	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD2_CONN_USDHC1_DATA2	0x00000021
+			IMX8DXL_ENET0_RGMII_RXD3_CONN_USDHC1_DATA3	0x00000021
+			IMX8DXL_ENET0_RGMII_TXD0_CONN_USDHC1_VSELECT	0x00000021
+		>;
+	};
+};
-- 
2.34.1

