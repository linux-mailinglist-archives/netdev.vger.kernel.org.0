Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447FC4FF4DD
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiDMKhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiDMKhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F02DF6D;
        Wed, 13 Apr 2022 03:34:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYuXHbgHODzwII6RMQT2Sr79ABfO4p1rSI2aEbB+NxBBDUiGEbD+yIvhIDzLHSLrEEOzmididP3YikrSB7o1QFILMW60O4XgP17Zb3oZK0OhebQwbzK1YAERmzip1chnrI9bsrP3QeXWhhorys03JVKOZL3oGp2huUfHbnXnPA6kc6+9VIKtj3O39FSLl3DB4yBr8G9/gwRRfOjWcmaa4bZLu8O3OGFQNVkv01lHp3o37AbDp1XLQMeTLtm6MsevoDjz9+pSfi6V6NQC+zQb+UaKkmNQzmi78rQLb7fWsAtiMR8Y/dgVdbGcWahhxzZ0R2ZZadOeLgv+i9BMlFoeww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uphKrr8wjvswpgZkUK1txe0wQqZYadw1yk1+VSXez4A=;
 b=M/HadD4uIysn1ENDPvUsjVr+cY46ThWMNMB59Ck1MlNeBwreif7OyJ8p5zfsNv04Y7p8h/pHluj+NbigcwV3D6bZrw+phFhuO0KSRekSm43uggQ3bBNzBaBkCZt3n3W7m1ucDtCZ5gyfvOd+f0AFcCde2gDLePwImogPrqGd8TVjtQ7dOSf4JQwNsA2ra0f8ZzxEz4T5YKptSSas18v/m2bfjTU6fbTFvUpyUhpUDbcRR4Jzdijhmfep8Wsu+Cdyfa5XMlXUwmBS6Pk7SSOiVhY/mjChrkX7iY7hbkyEOsWRH36bwIVLU+/AJrO0V9LIQPfRqG/AdqgX3WDtw+TKaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uphKrr8wjvswpgZkUK1txe0wQqZYadw1yk1+VSXez4A=;
 b=qtBrV+Y9mTNcrjJ9j1GP3cDbkrM+cZEmhPXNdzAxZWlYiopf5+hMZXvQps1EGI5KtRf8Cn/TWQwpFsWw8tfWQbbwpeXgVrdo8OGVA4OCWKcr7PvXCmbbt1NgJ5QE0XVt9u//MI5BdGyesSNH2l3rjWQpfrCtGjCykbfMSwhDMvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:41 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:41 +0000
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
Subject: [PATCH v6 03/13] arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
Date:   Wed, 13 Apr 2022 13:33:46 +0300
Message-Id: <20220413103356.3433637-4-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f0029321-0851-4174-526c-08da1d393791
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8691CDA870028EA266B10FEDF6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+JWLsBOWO+0Lzf0vM3M22sBB95X9s4X8vdFjDtuihweLkHdFQgkFi/sFG/ffX/2S37Lr9/iEWpDJ7reS8v4Z/JQSRr98DAbZzvxCfNuViEdEYBkAoBL00f/GuBfdH7ldeZ0k7xtrpE22EDPs9Pk4RmXn1Xd2bbCD1LfVNFZUu/ou+X6BymT0bUcMZ0Bb32qv8tG7B6YfmtghERjfjSpi9bRS5J0x/DsTxmcrVEFm8ggNDfJbCb6fAZj+GG42moNDvavknh9ICuMwUfjf1UXu2INpfJVQZ5a5WVwfgpoRmWkRKVGLRsxBExtMLyfud7GQeXjjfTsAvS8fsD56Y8qfxXgwut2rF8j5i5GdUl4Q5B02QtM34z/2Awe6qPXIHTk8XDZ1uGwOvopE4c/eiCxhr99VYh1zyUGsKH+9FYIthcsJ9aoQYiEaHJN/+2+8dC8LmVmbbMnF2ZKBL1F6tjCnNgeDtlJFUnKBvDAior0Hwz+ISeBW3K9tHrCJ2hSXGA7EeW8FQDZcXevEcXalFK06cJMLriPPLk1N7MjafdZdPYyomO1yOI2Y3+bpbZEvetHBqHJpxc0XXS8K2SM9HqrwBPYE8CnEi2+KAuBcarXJWWGto+CL4Cpv40TifZzzSi0uTK7jhDbZmra77Vmp2upa3Q43no2xLkI3jvWBi995kj0qwUlID39uKJhbHkj/P7usRbDNniIMZ1whrervYVYDmQ87a5OL7x8yJbKdL1duMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQ5nYHgUVybpcu45fj7mf3I/HXDjB0fg2v64INlX75CoHCl24P7mMMEdlsxf?=
 =?us-ascii?Q?uSQdLAdiBcsi4yuoHCJJhr6+8/WedQoCmNaa3WfyYOBr6Puh07dMZg8lK2ii?=
 =?us-ascii?Q?3J/xZpjrSx3X14jlGY0Ubc+j1sUi82KpcLRrT2znHKvaihE7qz8Z0PctvBOu?=
 =?us-ascii?Q?VnlPaoLh/rnHwmo4th40lelymusxY9dZFgiqH/oy8fMrD1W8bQ2vgY8OKo9M?=
 =?us-ascii?Q?zBKRE6Qt5Arjo6to4uoXPRyYELjp4Mv79fdp+cl7QEGJIv+pXQKQHVjJ8lDG?=
 =?us-ascii?Q?Y3qvHs6rbcfer4eigBcn0zEGNxwMrLRQ33Yc5hVnLny96bEi2pMSitKp5Joq?=
 =?us-ascii?Q?DX+xRNNzzdF5IOuviwSN9ZzSrsPS3k1ZNd27ePbSZS4TuPC6r3fOY9R5vjMj?=
 =?us-ascii?Q?PkIQSQV7oFE5QmI3sOKqUwQ6j8gWSh2i91LXTnZHFxeIZgkJBKZYlvVg5TDg?=
 =?us-ascii?Q?SeEDKjulHSdJXaEkkQoKyOFktC4W6XHMBmpy7M+rBb9I4eWcnIl9rSzCZmCw?=
 =?us-ascii?Q?zRQErv81RtO1V1DyJcFFXvvzeGgodB6tP/nUVxdjeWbWfFBsq6rPkLxHX8XR?=
 =?us-ascii?Q?WeOiLU2wH02fNZHR7dVgXAYwqR3XA252Yf3HCItHYhu3DcosmRN2+dwDeTBu?=
 =?us-ascii?Q?84Dlxd7qMra/zAAzcfoXKv/iEX3KO2VfQDhX06X44hQT1+1B/tidLUDnCm6V?=
 =?us-ascii?Q?2mbKBzuC9D28eYi+v418GNM+mfWatjsOt7l3gPczZOZW1Td+JIbJ8raPhs1a?=
 =?us-ascii?Q?A0CTvveCA6K25XX8uay49CdrAwVSQ6P4zeMTmwNoVXnLRCurymReZJejx7JM?=
 =?us-ascii?Q?3ePuQpvGe7TJJqieiMz66n9mtFMMg/WcAlkRZdtkRkxRJN1MiwO+AOQTlIQe?=
 =?us-ascii?Q?8JLfpB615ImC3181/84jMkcIyIyAJU8rSlXj2lLTPy/n2GWWzXzuLVSAmKhn?=
 =?us-ascii?Q?ixWVjmSllxx/izqX2zTgaPsAR12hlQNn7G4QlUE7pcxM5p06K++fX/Wrfgsf?=
 =?us-ascii?Q?0cbwcvUDTROe8YXa/N51kwdVj3sToZSLAPku7shFw8CoYUD+H0ftGSMWr7Lg?=
 =?us-ascii?Q?N+InSrk+HLBK7uytwTuVfNmZEdjJZ1j6ON6sorp0I3+kaXPHHSRr95X6F9tZ?=
 =?us-ascii?Q?At1hm+9WA5FD3KWxEJNlRWcsk9dhRUQ2yaLZpQpEARXIePaxlZ2MKd/U2aHs?=
 =?us-ascii?Q?AGfdw237xEUJQ0eMBuNbi5OOuSfrf64Z8xbhpvMsTf4lM7CkkFJqnU+WIQQQ?=
 =?us-ascii?Q?6KSwl8BCTZZAPzdZ6Zxt00anRtt346fsAbVDMSRdRNzX6HY2o/cbo4LoO1DJ?=
 =?us-ascii?Q?PEgvtDYoElhFlDS1uTYd44q52MhQrKJyZ5xmEyVIucm1uNfmWqQgNUUS9mIg?=
 =?us-ascii?Q?uwgcbqDcUWEtxNaSXM+y0UsUXIWSEuHhsOjfUXChTGsuHDWKl9yc24lYM8gd?=
 =?us-ascii?Q?sWgX05WSvAl+d1yH1tXO7fzPq/8lhKa2orTr4syGmYuLiHDbCTLsNvAUDdwz?=
 =?us-ascii?Q?SK37RxT/Io6TOumd6WpK9OvtqssWgCFUeWSIT4PAHyVCjSCJsMEW8HMtHmLC?=
 =?us-ascii?Q?OF5go+Vsbr/0pvgMvDW393q2+6uZp9Qk96y0NIG0EzboubCvERADOnsq/zWJ?=
 =?us-ascii?Q?Nxc0B8nFLjplWxzN0J+0RgPOWcyn+LYAEIsevLCMIMof0iJRz3ZhOjNCtTvC?=
 =?us-ascii?Q?wsw0L/aIRPbHF5ue+3s78zCIT2VAkNAQMoFU0mC7pZlL/9hGrRLK1bfFNkCk?=
 =?us-ascii?Q?sg51nwfTkA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0029321-0851-4174-526c-08da1d393791
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:41.0208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6jpgDeVZqFJLdhcn/NSg2mduWfbMpx1nCpKWeQjdNBs0k1pvpEU+CDLHrAEAy8ESu7DEucS+QkmU7S7uxuBqg==
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
index 000000000000..b776d0ed42b4
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
+	conn_enet0_root_clk: clock-conn-enet0-root {
+		compatible = "fixed-clock";
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
+		#stream-id-cells = <1>;
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
+	usbphy2: usbphy@0x5b110000 {
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

