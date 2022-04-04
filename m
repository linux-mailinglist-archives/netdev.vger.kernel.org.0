Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFAE4F1672
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359064AbiDDNtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358515AbiDDNsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:48:42 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C243DDCA;
        Mon,  4 Apr 2022 06:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWzQXVvJyqkgXBGy4XApKPBmJ17BpjBDv44YE2VjOq7nxcyHpHOTjvxipCoK1APHC0GxTJgzQUsmjk2kwH1mUHcd0iPI0DjBjI+TMNE9kDaj2qhAoaicCCQ52cQVwl7Gcjmx69C1tZCrSopTgqTcEKP3xtwi+8MmPWiQRIpPMDvR6pj7k1uOUD7Q4uDbK1wfw2mqLFVra7XkuxpDJIuuxDnOkDgl6oEHODnFmQ6iWQbs1VYZu8dZAKqeS1LYU9oyGJQRI6oIvOYb1gtDdtijlRW2Zh/JtrRr1R/GULbucadrqOK3IihDE55G3OpVdcJn5xcl6JZcHRya8rJwNSYNsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjWqanYARLHUSGK3+zNYOTanko85iIk2qSkhgxWNzwY=;
 b=l5BZ8I69o7QO6Adeb0vBNNrm/E+lX9mlHN7BF4WzHPvRfDYplZNic2AtnBbLLXKgnLmZJTJgGmaB5ciPCXrlSr74EfDB47QlOPbtGVH0T4xBf6meMKbTQIaKEjKtMaF/mdK27hbs+MKnUlrGHuhWusU75CDUDb8a3aZCTz8M9fHtNrEtgSytRYETA0hJUJjiYauaZgW676NPTyyoqhwLtdkT8NEhkTULbnjwUQXu6N23BeVInuELJkubGDxqH92mDIqQceEs38YJbFwX9RFRuB9eGXZBM5rXhAx8rKqOj3IInur7jzx1gK5mr9znavSO2o7V4pZGp2adzvaU3M8GUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjWqanYARLHUSGK3+zNYOTanko85iIk2qSkhgxWNzwY=;
 b=mz+s51nBTAvnCD+h1XlMAYm1abVJ2XzWogMPJnlKXgknvYLXDRYLCm/ZkIhOSNwGcvlWA7wR6XcNA7/iWFwUoAUlfiAWvtLfWBb89N0Xa9sTyQ52UPNAYpsVC0vDE6CY4LIO++tQ0hXQ5r19+0zr1N3tucZvoM0A+8FodUVz6/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB5889.eurprd04.prod.outlook.com (2603:10a6:208:127::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:42 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:42 +0000
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
Subject: [PATCH v5 6/8] arm64: dts: freescale: Add i.MX8DXL evk board support
Date:   Mon,  4 Apr 2022 16:46:07 +0300
Message-Id: <20220404134609.2676793-7-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 20824e17-b73e-4f66-167c-08da16418d3c
X-MS-TrafficTypeDiagnostic: AM0PR04MB5889:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB588959B3B93F17575E12315DF6E59@AM0PR04MB5889.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXHE6Ns0rG0DVBt/w2pQqsFFrT6L5rpB54Ty2RkehFzXW+OeY7ge0e616keUlaoDRCJyjZqyEvZcCIzmfA38I8VHxdA2K9kYSPYGVKVPdiikEVu3BPK5kXcc5nASyHwDVDuWYgpGjW5nKL+pvcGcs7zA/nbswKQnSSCnKBr9WYjqA1HuS8qgb9DZWmSShftE3fHPWkc3zk0NHsB6ZAIDdicq+MMhZAgltcdvxrsqHSi9yYbfCiyjHNZwOSzC4LTzrd6ade2EBDdEPY0xjprI4nYZxOmoM27Cg58gwcHN7DE7WcGNMhC+jNlW/WU/k209zbjJLX59hCra5QmAlZwun+AjBZHIfJV6Y/FyPmKPnesHCHpo2Qtt/DYwTmHWy0HeXc6nKNAXW2F6FK8FAIzVv+MME4rdFD6ci5c4w4ubr7q0CIYxiqc/E9WZlZjt7vl8SgABhxgMOWE2Sro8gp71yPRVW/GD4GB8266J+eSGOXE9Vfo4x602MRS4NsjGXlqsnNf68DEmyxmfJTRqW6kFdXrvseWUKNxISMMc/MV9GHRbQpP5CfetjhWjs6vAWoGxa77DNZBsfwrIHnxfluwMtcS53B6oJ+CBLZ5FhN7nICukPjKuBoAmgMLD8udAfjAq/ok9tUNof5kyLDXbOCBKE5nm3io090Y6ltP0J+ksqg14D8bPecQHI+kPN/9aGEhW1MYAajRDQd4iVk4+gfL+H4RwfSWY66ZIFGNocueG0fI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(38350700002)(38100700002)(54906003)(6486002)(110136005)(6512007)(6506007)(44832011)(8936002)(4326008)(7416002)(86362001)(8676002)(5660300002)(316002)(66946007)(66556008)(66476007)(36756003)(26005)(508600001)(6666004)(52116002)(186003)(2616005)(1076003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xzbuQ+C3DK2imm3BYWgW2SWwYQqNrHYeTgirUzjTY1ePF2JUAl3oj/a1YAVX?=
 =?us-ascii?Q?WjjilmWrF5Qt+7AkK1aIRkIbXlPN5pNbXhPPIBGgb5SycfluETyQnHM/ryFo?=
 =?us-ascii?Q?7Ec+l/u7NRuqvCXCHEpJ+ZXsnZrmATIUisCel6lIts4fUpb6AtRdmBIDxhBJ?=
 =?us-ascii?Q?Mugvc86QmukxFZ2eAuew8NZ0JHR5un4rExYgamJekSm4qCvS2fzoPkPyU4dx?=
 =?us-ascii?Q?REqrWUOM9GvttQelSJX0Do7ea/x6+wUIY+xpHmlEWFXZQ1gvdTuLvNt8BaAG?=
 =?us-ascii?Q?QnFN9wGVV0jrFaxFZejIXcMl0yb4xzuDaxdoA+iSLy+Ji6N432VRQUYaz79P?=
 =?us-ascii?Q?lRySQIb5DiBWsrsJjvb9wjG1CMMLk26G/aNYKfxSOgk75jHTekZyey3Hm0zV?=
 =?us-ascii?Q?JZEamxjXKVcJbEP77TlC7GZDO4aSPWA5ZmEJemrGBQeObCURA6DSP8rElXeM?=
 =?us-ascii?Q?HmEd3Rn0ryC12UgcgYypAsYETGY64DiEYqs5XQyQ7cwQYsdwPSbmzN+xg9Qb?=
 =?us-ascii?Q?Nsr6RYkk89ONOPzYoNVYdkVUzALv9iP3pTUGt4q3+ZUm/e/OLAcToJWKj0UW?=
 =?us-ascii?Q?R4Xte4fobHYRACLuaXIGZvCP2CtVvgUH54emMp0CDAd+PyxaX3bqMmLp9VZA?=
 =?us-ascii?Q?mrK60ov60+7A50I4Gu3DzVMdvwl9V8qyshsuko7Vi07ykdgzqxLL11vA1ss6?=
 =?us-ascii?Q?U/GZdliEsp4Q5+00jblOrkxJ5Bd/nJ39MREzkB2+amPHRVMvjJiJV3bICYbN?=
 =?us-ascii?Q?TFgg1mcbVf1FblOnKeaR0D6zgmnX2YAk8KELVRUj1su/Y8GAH8iHvrjU/bUa?=
 =?us-ascii?Q?THY6/wSxl96JOgemSbH3cN+VPIsuGtqqzeg6qc9zhmMgHCtZXzs1opoRFMQ6?=
 =?us-ascii?Q?97c8jJxyWjVlu58vfWx6D5EQ2x4uq7013TjLqYwJP8T5fHG1R1S8E9oKkbwL?=
 =?us-ascii?Q?59Qjh/Hn37AAyNdLNcr1cuQyPurarVGrmzJ+PvQJ9RgCjO4JKLfsEh3QnBD5?=
 =?us-ascii?Q?upOar72jZiqmze7OEAEYfhjJUWvhCuIDBV7RWprC+tD4hJpLSkkppvhP1PtF?=
 =?us-ascii?Q?h0G3M18TuOHNs/BFOR2W5f1pVKxdzANuAGJ+9eXMIvEB0x3J4M/Hv/kqJEB5?=
 =?us-ascii?Q?PHQa3oIkjKJuFenw6APSYtbQhDQU00tRMch1I9X9f9TpRou85jPjmOLRKUyA?=
 =?us-ascii?Q?Fl09bhHU0x091YFfSfVVDgHWQ7U5q6np1EFe2a1Otw/dO0qGkxmwxquEacSf?=
 =?us-ascii?Q?E7WPvYUmTpiTdGgpPTFJsCueLdRlPjFwqeyE+/eFYkkd/5r37njzRfCNMFL2?=
 =?us-ascii?Q?v427pMf18Nk4bPT4QIS4g0Sp+8/N49zbEx17wUNezItfvvB/2HK3c0ngzt0d?=
 =?us-ascii?Q?kQ96RSnSWvKJ9Dm6A2ryMKm2jLFosgSUkRx+H6+THBvChUPwUqNWjIv9y8Vk?=
 =?us-ascii?Q?JfDfd2ibG6VRrK6kp8qJnQ9EjUqSrkhh9HYrOhDqLIjC2Udu/yT69qR1QMWZ?=
 =?us-ascii?Q?QymjOcZv3tAOMpob8AKmaEDeHe4lwgrZNwN2ApMZLmgzpvfVaPAC87DxNw3/?=
 =?us-ascii?Q?4YztvspK7p+9eU6MzFrh6DUYNnHYP4OM9hb9RM2/Xa+/Mk/i+SxRGP85SOIP?=
 =?us-ascii?Q?oPrTKjGyGyjJmOLAqGHtqTpv8Nb6wxUyjiAPlfZsu4w7PKxMpLWRdgXXgnW+?=
 =?us-ascii?Q?R88HsZuxPovhd0W4+4rZtUN+Nft5PeKw5T/WhSaoQAsWqERqzjWzDxrhX/RW?=
 =?us-ascii?Q?8gef8LQoQw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20824e17-b73e-4f66-167c-08da16418d3c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:42.5963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mw4dTpYEJonB4Jft12KQ5mqPGcr9rBc0tdGJCGLOh/lP6xnksESMqx2UQL/t82x7jVLVZr/rtNtmWTNngoE4Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5889
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

Add i.MX8DXL EVK board support.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
 2 files changed, 267 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index 7f51b537df40..1110209f5625 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -93,6 +93,7 @@ dtb-$(CONFIG_ARCH_MXC) += imx8mq-pico-pi.dtb
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

