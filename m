Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866285069DE
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351229AbiDSLYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351181AbiDSLYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:09 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B822654C;
        Tue, 19 Apr 2022 04:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8kwDDKv0Ta/GQ5w8SdVWTb/n2eYbYrykXhvone5OJxn3i+MR+GJKSgzizz+4Y/fD0U3jU0ZRnwkpDMXzrUc4c2Q4NOiM3rWtHTnay2VZ8R5pMQGZbpX3wHIaywbICEOncyVMtTshjf0NyKY1MCEjzsggZbUsw/gVgeCptdCLpyp7WBEdkNiatYlLaQYp1BXBUTZ7VyoPu1qLyWcwO6+u2tjVPzmSqv6EFT2EIIk/54j5VqdRoTsnR8Es4WfRgPQsYn04QplhXmzAmYUISo+X9Qsnc1QrLvC9M1jLmrw3yL3Y1dkzMmH/oxre+Y2VA1+QSQxuyZyM93+lUhGLmut8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLAqsqP2HP/ogGw5fo5/9U3801i+6GWjID+HvYjaxZ4=;
 b=lTc/EoBfXyCcM9nUHpSTgYzBUXSjKNYkzjz3UUycE2oez8vbltirT9bueCLEUmUQdXnlORnzr6MFJ2X7emVr9YUBACDdiW+Wa2xNGVzzgMwoFmqv7sjITEGKpoBcbIILY6Nvr3EWsV2cG5lLPbLSvX5DeWaK6UlRYvAsAfNEH+fKB03XyGBoSs8k+ovGSixfPjKD58wyNl7oQ552ACsK9gvQifeRUdXpOVs+zcakhoBe0FH7cxdwaBtW+e1DJt1nG6llkBLGnyM/3ly8tK5FWGEREc9JYQtal6LmmPZ5mIxZ4lFAT8Dk4W6YGbXloBzRU6IiK0yXUX5ZlTQ2dSYhqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLAqsqP2HP/ogGw5fo5/9U3801i+6GWjID+HvYjaxZ4=;
 b=al2u9j/xuXtiX8m6IzRjDYIRUd1SqSf6LeLFxrpdRTg45uOZ1ZCF0JIBGiX6K+WI3L8kvyYJ3S8Yv13jfbtBCItF5HMnQmTtzoKip60vUgrarZpgkynf3+7biZS3crHuJjhlUcU+erGcqE31+sQgHKIiTp3hSMuIa0VazDpwC1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:23 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:23 +0000
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
Subject: [PATCH v7 06/13] arm64: dts: freescale: Add i.MX8DXL evk board support
Date:   Tue, 19 Apr 2022 14:20:49 +0300
Message-Id: <20220419112056.1808009-7-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: dc042733-3bd4-418f-a138-08da21f6bc10
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB753821A8C264C8FE666D22AFF6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nY94H7hyp+PiM2KXZ+SdgsF4CA8aLkLqye3RnLvFZzJ6gBdhPEAjpdH9iWOWLJTs5kVc0rHW2gtXZ+MJJ8GarkPLsGNSKFufEbL17n/Jq1pvlO3MXzMkVGrxJWyl75ByUbfTgVpXwnfcekRMEtaaHUABail+CbOTXdipVE6H+t7TdzXCh+mzEsJ/yLVyCGMK8lmYbL8gBYaYHZYvEPxoBvAZiuhV7lhKkIqzeA9a2qyWj59AjjcUaDNDwV+3/Osp90G9Bw6LoHRr4OnTcIzOpyaS3R/IQYPHXbp3+PlIkrdcMqaJH+NffnFSsLkDJvTdMcnszGeD+lCLYqud+2IRO7sMbKgAeblK+Hmsbx54hOEHWLIrf/63FelMviL+fBERPucjrQjyDzQs0/BvDXLu7cYtCuQs+CI2EEMIMxLS5phAaF/yltEROF8lKEA/bIOtXAnTc6mizzXfugzeShL93A+gonjBfyHzP/aI4HC9YR5W/6VPUgoNWfSKAN/BTpqDERZWSC5yecUJKTmSNFjP1pLDX0P4Ag3WRaewcakdSqsx8T1r0xOnPjm4Y3o3tnpTlVR3mnByXlXhcPXhHyT6yQ0or5ICjzwE9dMneVlU9Ul+2BGfbrHJANtuIYmxlGB2hPauOPnaz2Y9eoecvTTrVCEDjmXqfYP/9tCrH8XpNjUlsohW4yLd8f7gQ4pJhD346fIQ75H5nbxLIY3yb1xYGi42dO73cAd0MUgu7sspATg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(83380400001)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kVlH7Yni4fds3HPGWi04ytWtBlM5he15siz16ZUtCtMT7sV2DqYxj+1SC0//?=
 =?us-ascii?Q?SHGVi09T/JVorbBacQngiak4Rreg6LUlWHSoz/KdN+tvvs3yeibLTSk91iSD?=
 =?us-ascii?Q?u0InMHQcQsrob0Co8pZCSMwNzN9cdVMpdctWunwFhmFnRYBpOMvlkg1Lkjwk?=
 =?us-ascii?Q?jIeOzZc5+hArC4hq3bLq7BSkMCpTl8AD8AX89VOX7cidN5qub2hmM9x4fMQX?=
 =?us-ascii?Q?fHNOfZyRMf5aN1NKIybWUqh5fqnk1tKCGfLN7a7D+MXKOx7CH3wxo8GZ4V+L?=
 =?us-ascii?Q?Jnwxyp9S+cSSnERJf6awJfqGrbAmqX5d0Pd5+a2kpTdKzLiy21L1KuhPRKxD?=
 =?us-ascii?Q?Dl24YsLy9qITerwgdvEd6zF1FiHy5IM+RLXd4MypVE/WeQhAYu+ESmghOFfe?=
 =?us-ascii?Q?PgpZAqs2vusnXj05VJsf5At4AUzikjbdN+PHCSEFmjNGO/xN6I2l0+T4ecWJ?=
 =?us-ascii?Q?eZBi/TX70fPy2LENHw/uqqnB38cHAII7UmfT4by4aQ0DLP1k/+AVlBFVy9/b?=
 =?us-ascii?Q?ycwSAJ6pUoY308gqAYPcS/gUJVkfuVLF5hNFlEmPhVriRJpN0jG6jMGUGAkd?=
 =?us-ascii?Q?S6r7ZN11CnQfN3NjjZ0WKd6m8TtIT7lt1899SRxpZSQii2oUSFIyvSt2OK2e?=
 =?us-ascii?Q?gNhsZFg06KSjpZPT8RsMbfRWckSWJtyC9v5CF3O6x0rtaSuoxv0MGxSATtnq?=
 =?us-ascii?Q?S4Qpc0OG3ve/Ric4bnCSxk5nWpO2I0JAtXGMd0lP0kHfoj8zIvPJDX+7VuMC?=
 =?us-ascii?Q?Yxr2yVDnN1hr0SqEUZ/eq2aoXBiBYuoNtWdi+3I2ypjlN2pELNEv/oDd4QHw?=
 =?us-ascii?Q?wEgGdWMYssi2WFAf1XWGergPNHmMEOLUph0yq6ty3reNxqh8I13zJyTIF3n9?=
 =?us-ascii?Q?DJ1hr9sYteiXW8tPxy3XV+5PGfRfB5QOxMwnAHkwPuOa4/EldvoxkR5VXFU4?=
 =?us-ascii?Q?7SRtlZJ4rf9ClR12CjXkFUYws29FREqfl4GSfNdsH1ZoTiej1peApbn9Igz3?=
 =?us-ascii?Q?ZT1S0/oBkOCkC+aTQ2Y5vfD0A+cSyrGLM2/UCMmQXo0I6PWmKuCEvw4Mb0AJ?=
 =?us-ascii?Q?Z19J37/RCR34kyyK5+gxtABNmWs/LnOIHllpjDmzrwTRh0yIjnZMR6c+pZD+?=
 =?us-ascii?Q?ArXn9Mkl42m1OWtEhLFNK4fhqK2NzBDLNKEkCEvhGH9NOjOVHYCIH2Ua1DQH?=
 =?us-ascii?Q?ZqMT3ncQAZZEkQF8ypLS1yCucewR0o8/gT7QELW9uCPXbiS5GV/Xvu4owtP5?=
 =?us-ascii?Q?CayTKKOnvMGtauT/ZvUu75xXZ39HGkbHzrgstedHuSr9aqdZmisHHPkH2MkG?=
 =?us-ascii?Q?vVxnY8vFPTyt3XRHshiLIiLC8vbv3Rx9oxIlkv5z2a+9EJfit1G2dHadHX8U?=
 =?us-ascii?Q?y+STA8XdtC75WmW1P4clowdodz3AuilJnqHEBIoTWjj64ykHwLR4sCn4ZZ7W?=
 =?us-ascii?Q?6OwpCiSkk6gVj0LLZENC9Zystr1o69jhfNosdHHFarRhU0t20DwaanRe6epo?=
 =?us-ascii?Q?u2OYIVbC//0zqtZiLbNHb43CBjb1v+nl1oeaHcQM2hENSY03Kh2nF9kwFWrG?=
 =?us-ascii?Q?svwBqVUtuhMoOefJCqsWf04cp+OHm/oBvuB7r2su+zW3Z2zh3QkpTFmMDdvY?=
 =?us-ascii?Q?wIWCRV+QKyBgxrDUpOoNZzroM2vooaQSV71dYKDNxBTs0wLCrlUhgeCpURPP?=
 =?us-ascii?Q?SO3ya8b2i9ouzjTUeWfMCf+IZOJ1QdgNaM2rDfh8Sv7Ld231LwkDmvFPZemG?=
 =?us-ascii?Q?OnhNKRdkRg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc042733-3bd4-418f-a138-08da21f6bc10
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:22.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbc+H0FrQT6itk/VHwq0ArZupdwmraZX9le1jAtDsM7ggAZaECXfqzPwB8eogrX2ymXTbE4lDWa7sd4/v0asEQ==
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

Add i.MX8DXL EVK board support.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
 2 files changed, 267 insertions(+)
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

