Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C384F1671
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376436AbiDDNtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358541AbiDDNsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:48:42 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40040.outbound.protection.outlook.com [40.107.4.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097383E5DF;
        Mon,  4 Apr 2022 06:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GV4YTc1fR1ke6d/Edd+pWQRhO+n7ja82MDdp3IS53nxhOwyAZOf4ZHtkUSQeA9e6Yp6FMAXSfFvbLZfaQlYLVhpZ8DG513uXpjXyQ47eLvEymH/h3LnRz4jyDGPvQBZ/4cpC61R0qziGivx483fCTpsgiicHNMmYaQwi+fsFkBHAROLCoApDdlwoWoOEm6A2ZJJ1FZrjqEXWVj2t0yGR8Y4e97UOwHuULJM+pwawlxCYnHcEzhrbLlEUN5x7Yi2VXPcson/QX5C35m6jItTcrmEHg3YUComH09r8N+X2mu4wsIM69GNYN4wVDXUZUKdefkJi4QVMcXnqbZaYrYBt0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNZai1wn7CoNeZUICROLA5LABbSFJ2i+Z2KmJLNb+9g=;
 b=kaptj0wvxtOeLTwL6EXM5JWDNFyR/T4g/innJoyF5vQy0ImZGpGjajZDT2LQXiZ4OPBtdfaTXBCK2Ike/Wv1J6GrxhobDG5R6U+ah4gPGsvvCpAE7Z9uYH+sHk31gCYzc2zi2Pje0XKXVX3Co9s2ihPPslcQYDEbpQhunzRYsHHEA0tnZRcOxFuPijwreGss1eus7KB7QbCaMFryqv1TWaMMqh3Tco1gk/mdriXDHVYFEOQoXg0zxbBfz023xTl9833IQ0izDs3yZbG+LptmVf7GzFh99rGN9CjTMLt85PqGnJS0itSr5AXjPA8LKKH4oMgFZohS1CTI200oG+7aHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNZai1wn7CoNeZUICROLA5LABbSFJ2i+Z2KmJLNb+9g=;
 b=AoQIemLx50nohAmoO3Og6CCVSSPVe303vsDCoHmhO14fi2v9595F2eIT6oGxM4ZEyP9b+OMn5MlaYX6lce//wXUw7oAEIwEyrvHyGgNABnNKQrAxnOQOH68IbFhSrGrwS9RBCBJsuWCeOsIqOsOWtNdZ5KrVfQ2qKnrJaZqSUSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:40 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:40 +0000
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
Subject: [PATCH v5 3/8] arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
Date:   Mon,  4 Apr 2022 16:46:04 +0300
Message-Id: <20220404134609.2676793-4-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1fe3a879-c8f2-4a2f-07eb-08da16418bc1
X-MS-TrafficTypeDiagnostic: PAXPR04MB9218:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9218AB388918E9FF15C55A48F6E59@PAXPR04MB9218.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OmY7m+wQWy0UYpFussjucRNJ8EElwE2lG0ysqX99hELBGrftJrMTgK8/+S/QuN+yaKQwYB+maYV8EuVMy9oad6R4vPlMbtxGj1CMLsWMEcm5JJOEXH+ySx9kWVHtaWGranUv8mJoGqHCZcRKFadVoYKMVAFxkNQOOZPOJFdN0yq4JbQHCZ805wuewrJ3flwSPDfBsOSblqLvxTGK4K6ZqszwMWbWxXajlBR4CZbDL+QvvUjMNcc5ylCVpkVH2CyBp1hn4VEpJTb1u+/PyUnS0O/QjJ5VQolIkb4mvrepUSoiy5lCuLqoDDSO9Z00A2jDzlzy5PSLXHdUeu8upf/aoYWnXZangnL0kHdVKYRnSOCLnPsT36DZac6uqmAvU9stPm4QYx7TlknuYGXh9cuRWAmiFSMrJvMco7of8YHXt9992ro3ZOagq4LarCwYi66QBdQzzeNkRghAqBwjeR5eBpNVBB5KA3JRMwvGrcXY4uFm/P1nMQ/JJGfJtAwjzXHR6XQmd4I/4lAwnnZEVGbAqwxOPNWue2GIKcqp6sfC2xsr/LGArdMO0oHn2Bv5CbhV2saXYvhvNmKJq8MxBIhgt930bIxty2hUGeTmuVJ3gllPx3Sppk+sZ8A73m8UfhJ00dQe/KvLAnUx9oXgZuBMjNoOfb5BH5kSPcdywp+Sfj9mWL9ab1byRNYz2ACdJPufwJJnYdvkZjdpEHryNsA/4GiV0E8glc5M1s5ciSLrXPg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(86362001)(6486002)(2906002)(36756003)(6506007)(6512007)(316002)(66556008)(66946007)(186003)(66476007)(6666004)(5660300002)(44832011)(8676002)(508600001)(110136005)(4326008)(38350700002)(54906003)(8936002)(2616005)(7416002)(1076003)(83380400001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wgt4QC1OMtHaxNwNpliVRlJLugdRHGiY6/z0TRpdCS8TDtGEBRZXXPSaNJq?=
 =?us-ascii?Q?GT/Yj4RENYDpYm27Pkns0a2JjwgKAsUrdP8klfXjp70GlupmVnsl8bfrD8ZI?=
 =?us-ascii?Q?CAAOlJsXc4oVltoN52xfea7bglYfv4z3m9t8rJ8IryITkzMEBgs9zhnmvLiz?=
 =?us-ascii?Q?vUUcb19oLEqxgh9ah3W2mhaIR349LnhJaotJTDw2utHjLUdRYOFfyVmPQjNs?=
 =?us-ascii?Q?sF9EZKeVSWrcSqgKjfcXfi6sCmNOOEfROJwzbVotxLlWGtbgvTzMPom1EiQ+?=
 =?us-ascii?Q?di8oScJ0NZCFwZWDpXsQLRh9lg94jpQjaguo64I6RYUuZG8AOhBlPu+MetiW?=
 =?us-ascii?Q?NTdHr2GhDKzTGgo29+wA3Hc9Yi1CwUYo21nO5OZ+kNN3P0WZ3gNrrksjrlZd?=
 =?us-ascii?Q?rRc+G52XJADYJLNDjDWJuDN9vnXOEGFP3e4JQo8YH/HY7pzpmeod+3/hvQqw?=
 =?us-ascii?Q?MukWBRiUKw5HmAbyNrNtQsWX0ldWeZlkxmDQ7ssTozpHMP0NaLX08eVlsYU+?=
 =?us-ascii?Q?dllasa49xQa2fv7fizp+bD/740kj/Y/pj6mbRhtp33qIKqnDEGkOZ6fMmJo/?=
 =?us-ascii?Q?6ZNvi47ID0DjK4ZxhnYKzsI5IkbMlBsdxXEXJZUt39nk9N9OvDbDJxBrvAWa?=
 =?us-ascii?Q?rgMs8SIpXx5B5chBc3f1pVq/s5KQWIiyiISJ9XImBeE/8DGfFZhmhfX899nW?=
 =?us-ascii?Q?Qe+dHLx9FIabh0uSAZWNUQaKORCAGlngCrZ+zCg/1MUH/9U6SwxF40EM0t3v?=
 =?us-ascii?Q?kLAaLrig/5uOpVvnaH/5ff1zTcegjLsZK1XJtzFg66tgTdyfONQnYoW+Bzf1?=
 =?us-ascii?Q?ZN5CWYQRQTvSTwyldQKwAGnLXWdyCuDi5TUj381EzKJWI72a8B3UUe0czHT6?=
 =?us-ascii?Q?hVKMyPONWvznjq9VG2dWgIYjxudEvsQzlcHuTDpzNLDA19Rwa0kfwsRfyxpu?=
 =?us-ascii?Q?vUbwYtocdulq9S3FX+AH5EsJx2SRo2Toyp+2vpHv06J1vwereoFyV79Z/64T?=
 =?us-ascii?Q?7z9BLJDjhG0Rtwod1NVM8ViuPIi5sTEV05q+Ey9EE7UjUvCTPT0/+Kdggmz7?=
 =?us-ascii?Q?hCsCx7IZx8AEP2gPA411Jbh68qd1G7MxaOYRWSObyjSlGM8Vf68rzhACY3WE?=
 =?us-ascii?Q?b/cMRLvVvmVZsjTVbwVuAmeHjVtrnJMRa7DgJgV0mZhkq/r+OZx9A//HjHFz?=
 =?us-ascii?Q?LO1QmiBEHyeJHMYRDby9j3j6/D2VxyDwCUoET2AnFgJSAyT31iu0/6BNcX+d?=
 =?us-ascii?Q?R45L+wD0zLDvWwXdrUGDnSrwRp6OqjRtexCS9QJGtITmdbleLtdjMz4djRKh?=
 =?us-ascii?Q?wLuNwif2pHrs9tLKJ7v+T6zfiQCj5ZBavpomDerlNlR7sJHoXhUNly8GI7lC?=
 =?us-ascii?Q?N5CYuzXt5Xg8OXLWggAOxkYYvYVjYxaNviyH46SzGjAugP08oDciTBxe2QTQ?=
 =?us-ascii?Q?gpNQ4J4esrvm2unBB8yxRAC8+cwpTrvFrj+jzLmrnqxNuwKT6UnX19yUTRdw?=
 =?us-ascii?Q?afS+xAjy9HpSVf43jj8SoXhmKQuovU7smvw0uE3c3ldj3DE4NwxsPVd4NOTn?=
 =?us-ascii?Q?Mv2xTq3YR3gt6+WoiIrRenpS1kXTd+8vzzAVKPSBoZt8Nr4ZjhObjsD8bArU?=
 =?us-ascii?Q?kuj0WSE0B94doFVp4ulFE/PJhQkPT7CKeAMkMsm62Q90MemMQ7dCcDbXBqZp?=
 =?us-ascii?Q?XDOEWeLxpVRM6TSxGX2M25HWEpshvFUh4QfDPsMUFYsWMgYUBdsTiTNsxjtb?=
 =?us-ascii?Q?gsP4csRRNA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe3a879-c8f2-4a2f-07eb-08da16418bc1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:40.1902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hK1N3MCV9gyMda11LmohafyQ7QKTyVy1zM+BmxPXjLaxE+aCaqVrBDet/BBrCxu1f3z2uRUdwbwaSBTBTfTrgg==
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

On i.MX8DXL, the Connectivity subsystem includes below peripherals:
1x ENET with AVB support, 1x ENET with TSN support, 2x USB OTG,
1x eMMC, 2x SD, 1x NAND.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 135 ++++++++++++++++++
 1 file changed, 135 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
new file mode 100644
index 000000000000..8dcf8c9056a4
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
@@ -0,0 +1,135 @@
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
+		clk_csr = <0>;
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

