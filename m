Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83974FF4DB
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiDMKh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbiDMKhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:17 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581FC19C0D;
        Wed, 13 Apr 2022 03:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFBPvzzb5ENbBoXXFKgidP2LSCYcygPcCkSIDA8wLsKFZNIryzwB2BWxwEkkIK3z6l0jNdSY5Iozy/JHrqY2HSUWRX+ddFQNb5fXXwyV2/GX9IBFd8gTwZYxg5VWesL9K1l5IryLH3hlDgLhLL/oOav8T3lJ8VvE9MHO09/akQerWcxaF64aeYtLwCjb1Q0QPeIaVUX5kTnzvt98HmSIu1mpzTWEOmEfMtxWO4GyGGIFQ/pEvRqrDatUjff8ucl1rCOa0ubU8cw39cr0PeBjXt5b+uzcqwcbrvdhCE85dOAkTe5ZDEqMCPOyV5s0tu3A2SK0oi8AfaMqP27QqdIY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUcHEUA/XkrMjgttMoIePN10JaJBbj91sbOCp4lP2uQ=;
 b=YfCldRJw1Pnc5eVNCrYrxfrat2WwY6wMBuZ0Z0RGNeH1Or9LCvNd6roKLbNSBpgh1RiG2J+zvYOGrns7ZDfX1HU+Hp1xjpHVziUBeyqOUcfW4Fwi9mYjyoygyj0gjaeKbHjdWnletVOcGO5CSJxyaLiesq9jeyTlkXqzj30ddWRO0F3gLd0eIrHFYICSCPGp0v9B8/X21PBm8Ej3SThx8ytbOVWzLOWXMbi3KLrcWsVqx7iIwY8k7LfXq4Q2Ti4nwVt+J0TIIhSrMGNYZxxDoAzjsrwpot1c835PbZBOQjESK3K9Zd2jxOB+en/Cf+4X278yASKmSNJBnMBrdb9H9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUcHEUA/XkrMjgttMoIePN10JaJBbj91sbOCp4lP2uQ=;
 b=c1VPA5yXFdNxSbRV9wP1kSDH0GaGN2m92JIL/UpBrCK14vGFvp8geFRQZS7+bu9sOhpVIVWRWd0kVE1V4oLTMRkZzuIP8lOTNUbw+FwqUN7XQBIT9XkKx9iJdXSMLlSkzd2b5qQOa2RH3YeLU/GFUNKT17nARO02nZ7/bskNz1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:45 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:45 +0000
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
Subject: [PATCH v6 06/13] arm64: dts: freescale: Add i.MX8DXL evk board support
Date:   Wed, 13 Apr 2022 13:33:49 +0300
Message-Id: <20220413103356.3433637-7-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 52bafac4-94c3-4cab-1576-08da1d393a09
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB869166CC7F4C0D49884A42FFF6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6RhLWb4LnLepZh+s25SedBIGQiUBDyPb+XEHc/pkYhvnmvwl9J/tXc7j08ZFWxBjI6RCc53o451dIt4rV7j25jMU9MdZo+N7mIPvtaMCtFhd1AmVgG+j46CwWxCavGIn28jWdrYyF+ZRvhEZAaBhCPGkllgaYU3QEPy0FPmVV/ZSbhCH6Lsl4RztVBxWLk0J0cm9CSG00bidngIRpjjgRW4VYshjPjWFZ11bVKgBplnv/Pdt1VeI6bLoHip+LjAsjyI8nIip69u9jMdvjC2QsCpAziWuz/r4hayigFhpqJ1Ex0YuPCNdjBRWngrq+Tdsd3t2HpgbyA4NQOWljJOZiPLtNfovnD42ScyM9YZ16aZyMrGO8om2AbXoqhG2b49RmRY5VSf0WjBNe3KnIiLv56AieBMUfSd6K74C5E0IkGgTjF2XUJHZNhUhQ+5Ic7ZdQyBkEjH9ow669zOrqDu7AHYLHWCtWHN3ibTv8w5J9J/qKDpAju/7TszujTtM8/T4h/BkWcbQFzoxgVkN0GyeQwcb4fnX3+tTRjjMt9vmxQANWy4WrPDFpf5GU2OXj1UO4DmoPTt4hudA9yL4WpcTBqcyYUcbPwJsWI36Nto+Xemtd+fXo/fXPdaDkb0xzR3gyKEKRFhGysF5b5+JFfyyw+Q8T2twyOwyiql9RcyIlx8CvDA89RLBzq7Gfd1HmZohF+roeYOLDopt9qOJqdd49YoupZYrWcJO5m/GHR+NWs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QIgk3dg9IfSqjkhBodzW/h10U8OmfirfLKLpgsM6s8oFWn7N6bnyx3yHcEMt?=
 =?us-ascii?Q?nU+V5HnX5GwvcI9H4Qy1+MEc06uoZ6+M2qejUHNVBaMPbToS8SIeQlJkBJMV?=
 =?us-ascii?Q?yZXmtbRZ+ENvgHtmaP7koypd7ihNVF4334dMk20SMKMui8isdQlgEOb2ORsx?=
 =?us-ascii?Q?W5zVQts7LAg9Re/XQNFGtVKGLoZjPMfskh2Nmx2Et+uV/Gq4ZmVLkJEZVj1y?=
 =?us-ascii?Q?nQMjkTKABWd7dLQPpHUNNq8HjCAML6PJb+BE99yEwjD60N2GpbrMI8KUaT4d?=
 =?us-ascii?Q?OuXEedmLOOdyCCcWyg7gvC7ER7E9O+WleFuPK+dttxtuZ2U8rIWRyk2/OwcV?=
 =?us-ascii?Q?PRnwlqDBRy8rgG35B+Av3dy1duyJGzSr6eqdz05nv62ia8mnq4FgWTQlQH27?=
 =?us-ascii?Q?KTyfNkr6yP87yPwOoj3hPxp7UmbnZEeyg04ox1rs8waqqR7+J+xodMGCvy3N?=
 =?us-ascii?Q?6CQ3OsNaKD2aMs7qwVqFxQ+Gi4zEFEpobRe0rc+7r54yGunIOmUydgdIvovW?=
 =?us-ascii?Q?LXTB3PxQGs2EbpoEh16LQg7ijAv8lKf0XCP3jZLOHL4it/PfQw8PLoSTdWNN?=
 =?us-ascii?Q?/hcHMHdp9ijtrb+VQEKec/l6iaZ19EUvWxeRv6bV8l8bntgnRxwzYd2EiUTh?=
 =?us-ascii?Q?97loS4C8MEHkI3bDi9i2s7vo8vWb5K239KxH/NSoxQYR4MJRrMpnF1C5341o?=
 =?us-ascii?Q?wK8jWf7H6fkZ9q7ySWN+wI0uNLVkci5dtn7SK1nIYSB8bxKqyacqizhhRBdd?=
 =?us-ascii?Q?ho79yncJpwkLSyCTUld0aJuL5xS2ntQ1xp16VM4uhtxQ0m8Idgk2d7Jnr++t?=
 =?us-ascii?Q?VpFuPHYAGT2Ywq8Ypc7+LsHRkbUP5KIM2PkEBYOK+H7zGKN+v1/eFlFFVMo0?=
 =?us-ascii?Q?y6Y1oHcp7JtNB6UFrEaxr7uAw9ZrPxyPaD1tAt9JJ7ZBCtgRT8jfdKQuS3eK?=
 =?us-ascii?Q?79fQPXvOb+KhWG52akzZ9Kcjf4ox04WumdvwhC+8T9iWF8SABCyL41H39gIL?=
 =?us-ascii?Q?bdG/A7S2nSfX12TjnMRJRe6LykL8DQX+LCQFykUvjj0wKNYsqcluY9CIpT2L?=
 =?us-ascii?Q?1NLvSym8IGXp0MA5b2bQjsY4dA+drM9dFvdbM22LgmCBzWmwnvJ8hVI7D1r0?=
 =?us-ascii?Q?aJmYwHLo7p7QOWHAdzmBzLHT0SAtzzZ5PzSBk2r36K5d/QX9Kh01zfgIbVvY?=
 =?us-ascii?Q?iRKfF7I9V0Qbld173GAugq3CbbFoGaDBi0Nhv/RuYYzjLxnJJCy36KqdNPkB?=
 =?us-ascii?Q?Bp2xtR1R9KztSro+j4YJT1SFq+4s/UVdmXL+9eWudD+OcfapwGaUQSQdoHMh?=
 =?us-ascii?Q?TqyWgIFOkh/XKPRUBYuK0QL8lyM52XfTsRPPUspJnwK6caxOocAwXUzRp6xW?=
 =?us-ascii?Q?O1IOseJ4Cu0lysJozq4eo2bzdP0TRSxY4gGz4uOpD7I1ilgV3mjUHzJ028JE?=
 =?us-ascii?Q?2lh2bn7HcIBx22Laj+lLP5IiojXflvGWMIU8emHCYcDSxa9AhWdssG4aEdNM?=
 =?us-ascii?Q?5CjsnSsxf+vieu3mHcrQtgv1pk+NhuoAvWzy+yWqUrSwNA2zaz2SzwfJ+WSe?=
 =?us-ascii?Q?rm+qxOf3U+IE9cLx1v+wimVSLX1+H8W1+e5IrUUFMs7Jap5946RsVEnBHfCY?=
 =?us-ascii?Q?pUk+wJlqsZ+tN7AjiR4rN05oY+CU8mkqMOlrf4W0GbfapNSAm4acqECQYung?=
 =?us-ascii?Q?eltOqmq3b41UFYu7Ly8Rh/Wen+LUrhjW/hesaWu9sdK9UJ+U+CLTBaPqdLYf?=
 =?us-ascii?Q?icNR1ky2Yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bafac4-94c3-4cab-1576-08da1d393a09
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:45.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTmhGGbcegQvMMws4XKawZ0TJdGB7mIZjIKmUJYe6LhRh00kRYOCH9Jt0iYvJ1TGbcn1fFp4BRf9Ikmsb4WFpQ==
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

Add i.MX8DXL EVK board support.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
 2 files changed, 267 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index 85c2c9ba5110..d6be4e8ff3c2 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -98,6 +98,7 @@ dtb-$(CONFIG_ARCH_MXC) += imx8mq-pico-pi.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mq-thor96.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mq-zii-ultra-rmb3.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mq-zii-ultra-zest.dtb
+dtb-$(CONFIG_ARCH_MXC) += imx8dxl-evk.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8qm-mek.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8qxp-ai_ml.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8qxp-colibri-eval-v3.dtb
diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
new file mode 100644
index 000000000000..68dfe722af6d
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -0,0 +1,266 @@
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
+		trips {
+			pmic_alert0: trip0 {
+				temperature = <110000>;
+				hysteresis = <2000>;
+				type = "passive";
+			};
+			pmic_crit0: trip1 {
+				temperature = <125000>;
+				hysteresis = <2000>;
+				type = "critical";
+			};
+		};
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
+		pinctrl-names = "default", "state_100mhz", "state_200mhz";
+		pinctrl-0 = <&pinctrl_usdhc1>;
+		pinctrl-1 = <&pinctrl_usdhc1_100mhz>;
+		pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
+		bus-width = <8>;
+		no-sd;
+		no-sdio;
+		non-removable;
+		status = "okay";
+};
+
+&usdhc2 {
+		pinctrl-names = "default", "state_100mhz", "state_200mhz";
+		pinctrl-0 = <&pinctrl_usdhc2>, <&pinctrl_usdhc2_gpio>;
+		pinctrl-1 = <&pinctrl_usdhc2_100mhz>, <&pinctrl_usdhc2_gpio>;
+		pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
+		bus-width = <4>;
+		vmmc-supply = <&reg_usdhc2_vmmc>;
+		cd-gpios = <&lsio_gpio5 1 GPIO_ACTIVE_LOW>;
+		wp-gpios = <&lsio_gpio5 0 GPIO_ACTIVE_HIGH>;
+		max-frequency = <100000000>;
+		status = "okay";
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

