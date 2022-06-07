Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA553FD32
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242714AbiFGLQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbiFGLQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:16:56 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2057.outbound.protection.outlook.com [40.107.104.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D08396A2;
        Tue,  7 Jun 2022 04:16:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+WTXod/rWZcd9Jkjs5piW9DQKXv3rS60ZbIizJJk5ur87X7PaVxVZcUREnc3PhTeHYDg25lNE0rE0Y7Q+6YKdsOj8rFQWH6UcAxJwaq+bMUBX2Zpbi2wfCb1HQ3TRW5nzrqOGgYpM6YXqmVEZkID8z2DX6GnClB/Fi9iqNFifMUXFmAm7gJmk6Orn5+RyUBAgsKmumK5sTsjC5l8SViG+Z7+rNBJqmJwws5VbUgQ1afGcFTcypk9mICBk/N/KK74Zmdaqiy5mAEByx6pHWAV1xhkebt8Lvs32ksYPw5PDG7VfkoSjNHWw6xlu03ci15vKl22g8wB7VTKLZ/gusmYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFaEyra3A++7M8tEw1ED/oqq14fyI83NxlN7Q/eoKrI=;
 b=MwH1WUjdmZRPby0Qg+qUGjn8bEsbdIPbbNk2AwaK/SXajCZSqfyvPGzzqsEa7j33X2PehfIWmOKEKeMXkBrPNqiciswgzWvyi0u0FIewB2XVVhQ31ULMoiMDki1jXWYMykM3YX/Ga6BsnHJxLv36MU1yZwAI/PwV6lc7agv4AxryPAG8HkSz4xrwmDXsFfepdW2r+9mdIn808wKqiRGPeb+oTlEc0o540Lz2AqpRUcjgycAI2/3gY/OUwvIkPiR8abzQPIkQPYw/ipQbmb3ubfA45Lj26PhzHgOwympAdFtppbHVmb0BkwhvnwIJDzjfrAF0+iGaxFdBT5iH/eHkvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFaEyra3A++7M8tEw1ED/oqq14fyI83NxlN7Q/eoKrI=;
 b=Of/lyU0C6OlvrjpBJcyFHWvG8MvKIOQ8sex0PioKRAhPWwHwAKgeJb41vAjBVShPRPUm/J5ppZ2dqaNFkMI+24iP+JBlbjFyYpsK5KIQpoqg9JufX08ad3EsWXYSvmKTDQR3Eu/8jw1YUSvsQ9EMFh421oOvNW8+4TSUR4PfMOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:16:53 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:16:53 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v9 02/12] arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
Date:   Tue,  7 Jun 2022 14:16:15 +0300
Message-Id: <20220607111625.1845393-3-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08aaf3d4-8067-4074-fe7b-08da487739b1
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB48901B9B0036DE26AB80285CF6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OkliXsV90AtY/z22fK/UmSKGm5kTM2vBM4dV0jLf2OB3mgsOVc9f9+uv+1Ayu/Yel5GsAW/K6929y2nzQl5HXHoveSz5gAbqw5EP4RoWjZ7CbKTwtaMlUesLzmgAcaqzYbzkO5SEfi7cJADul/dEpLSu3ju30u+K795dIKraj7papgHLrQKqz5CePQndFY8gc5HTwMaq8jEYG4VJNcv+hLmfjIKjGLFEijR8okWTWheKHoqSUDy9LsTm2KvrtsZdNlwmeZE5dwOTvEzS9s9/v8wh0K4csmqLq20gHz7+kWbi8n5fF8fhQSJ/r88e8crRIB1HtFchPm5UHYFc9yyhGeUkC4FSbDgEGGmeyZaMsBybz8rYUsvf6avGSTjZg6RrR4K4wjwDVba6jWYDFIgZQkcsXMtb8SOb4fHrPoySqTJbBg1UhtoD04/QkmbXvVjgF1aAORVUW5o88pvV8AABJJcjPTZKLboKV051PJKbemjwbtqtWF74WNwT52/bcUCoaNMYnOHGhqDBa+BXwx4SCMzQ7YvymRDRRW+JffQdiEwjGRVc9AI+hyWQA++OEkDFOFF0cVnxsPzUgktYd+rEGzP9hc8RL1fFd5i4Nwyilv/qvTq9wbCVhfb9DxGXI6evR+P5ZpDHGr8mrD5NiOwycA6bUMUtcO1LA7mksDCTb5sMev5uNwBxp4nOodOlhLu0zjO8khLWzqoJDoo3LzU5iP4r176NQNZrq9L04yVSQR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(83380400001)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MB2Qmicrq6l2e5nIbgh9VGmFeACHTXhWEU54PD/O7/Wgl9Qb18i8JVH+/uCM?=
 =?us-ascii?Q?zWsJoi/F7jznmaObF7HAbF2cdLjf6gAIz5UFMEjcB/eS3L9nELdWNo2fISIZ?=
 =?us-ascii?Q?kD+aBnWlI2oRp8k4/XB3w9YTTUIwlYHbDXDxZF0aoyKLGcsX2pUsRTatMGdk?=
 =?us-ascii?Q?bZSzp9yhGJTvdNrv/4Vl5LSCo+AGQerhZD0cSLf4c46kciOAiTgZCppz78OH?=
 =?us-ascii?Q?RvqpHJHIGqWGChZxwzD8qJb43rH1O7YtcMLaIohKqiJzdnJj2zQnSGHTLOWe?=
 =?us-ascii?Q?Bp1R2/Tho5eZvEPYvnuPiwUVLcTAqotdEa5kQMfsRFpAv9+A0usltvChSzXl?=
 =?us-ascii?Q?Bpf5dgm+pIuts48kdUkuEZHh0FqnG9N03CfXh3eLWAylj7pYV1mS2lneLnLI?=
 =?us-ascii?Q?xzs4h2LBST4hKOzcVbB1LuluHeYSYpGMC54rzMbIePLhNiErxpqKTEUviaF6?=
 =?us-ascii?Q?ee7jPpcf7qjPtV74FSkbGYxsIJB9yGlt8abm4ZLZ5RmHGxl/9YlFraF+R/ns?=
 =?us-ascii?Q?PE7+UYyv5MnpQActJemfsUvSXkq+M2NTk7RNNDNRrDgexJGk5wMJRw0TmVrh?=
 =?us-ascii?Q?+a+OiosBWy8OKbnsZqWlQW2w9MriU18Lw04vo4Nj4T3H+rMVvCz3CMmxwZl3?=
 =?us-ascii?Q?jXEm1yqcY4h5RiHOlH5Fld0XAe47RPoJvBoY/dTHlRwerIKl1/TkJty1hRTA?=
 =?us-ascii?Q?pA7JBbWT2QFY8nVqoJJvl6if9Yml20a4SV8F7l/bx2v/oAYB5ZrY8k0Qz61E?=
 =?us-ascii?Q?Tos282riybqKCaI/ujhGvOgBopWkB3ntPDsj/gVhJtUT79O1V4Wh1nsLVGXK?=
 =?us-ascii?Q?xAzfJHcbvPpyDMEG5J1fXg8JFLMMPtYN8UMoKIs3WhYauc878MXxdlkQYD88?=
 =?us-ascii?Q?9jzrsK7vnbq84RKZgY+mIcN9SiAuRmCeLhbzRCjybqggaAUfxDitXvmzhI0y?=
 =?us-ascii?Q?sLyq1J7+BPelcaZmU/xHxV64G4xpna9GLwOFV4mhf/MFbfJC3LDVMZVPiOhb?=
 =?us-ascii?Q?Lh/T9+cENBD9Ctr3WehbonkyaLZLWMZ/V9Etw4z0EZKpS6hv+5FwZq4LxBsJ?=
 =?us-ascii?Q?/1tqJF6P57lVmBleUC/5msyxPEkd7PD++00A4infMJAJXGRyAvO9ZSk0Svyw?=
 =?us-ascii?Q?dEkk3nGDAeJbrDXhl+rzk8iGYZFcvaBhG31Njc19Nm5FEMh716UVj1bbRjNE?=
 =?us-ascii?Q?s6oPfaVdLa9WSzaUAzlaooxO6M5l/kFhPH0UbHlOR5Hvz9aUbjY7Mj77hjaP?=
 =?us-ascii?Q?RJq9KJtfv6HCif+/BQfiHAWDOTYMoHisCKhlFcmFF0KHTihVuzJH2jl/xMHG?=
 =?us-ascii?Q?UE1Z2CsRqInXGqHVWV81143xQEMreQ7ucwuQC4LbV02orFa8f00FSj0qz5gp?=
 =?us-ascii?Q?wgLvnKJPOx9mVpqwuDYZboBSK5JVvTWB8xxvNfTL7jvUbKnM72p2E/KeWf6s?=
 =?us-ascii?Q?MPFXmdkylkkVMDk8glGjMq3rQEYs2V6ooJK0+vTg7xO6KTkvSWgsMt0tkDHQ?=
 =?us-ascii?Q?T7nzJ7UXjWNC5TTnao5T3sceGrn8f0YHf+Br1MHdwEeyybY5I7+s/3LaSMN1?=
 =?us-ascii?Q?+ijUu3UAOcuJtEi9vRn7YHdd1uXu0VH1PcIdm81uQdzTNoVHBy+cmQ349uMe?=
 =?us-ascii?Q?rlFdLiYdrAt+PIx5hsnfJXFMYlyYHpYHMarxcTEG7O7/lRf5RB5QSVVP5Rs3?=
 =?us-ascii?Q?o931+soovFjZ/cEURfXCnIMGC+BOXWjiMrqhSEIwsY6ByIRGNOlqlxMGA1NI?=
 =?us-ascii?Q?G+a8vzNlvg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aaf3d4-8067-4074-fe7b-08da487739b1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:16:53.4183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmSeAMwRQsfL4OFOrjVjN6AKAsl4WvEg/FqhkeEsd4nwt55QigYs1vTkfLMgw0sUSMk2zmImyd8ag0ekdCAMOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
index 000000000000..d10d1bf76df7
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
+	conn_enet0_root_clk: clock-conn-enet0-root@0 {
+		compatible = "fixed-clock";
+		reg = <0 0>;
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
+		power-domains = <&pd IMX_SC_R_USB_1>;
+		status = "disabled";
+	};
+
+	usbmisc2: usb@5b0e0200 {
+		#index-cells = <1>;
+		compatible = "fsl,imx8dxl-usbmisc", "fsl,imx7ulp-usbmisc";
+		reg = <0x5b0e0200 0x200>;
+	};
+
+	usbphy2: phy@5b110000 {
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
2.34.3

