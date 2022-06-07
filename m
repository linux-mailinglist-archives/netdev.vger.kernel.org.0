Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C4053FD46
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242873AbiFGLRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242791AbiFGLRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:32 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D352E1DC;
        Tue,  7 Jun 2022 04:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8WtYWG+Nvm7PlL9KD4zgXfW+g5+Ym39fuA8nXOHZDrOXyzMoM8QqTIz2hOQocWtFqNl2CRXZTER6ryjLEQ16/bqYe3ADyAX+OLawCEINRIW1L96VQDeO9Z6d9eRON5OQqeHrNidIbKQAKvtXI8lbz7hX9OhHNM6bTm/2dJq/Fh31n1DllXvuGHWvJtvr46nzpj2g9sEIK7aZVYQi8S59Ti93pKiD+j8d0pGa6ch3Ub0knm55s7zWoajVN0CEzYmmumbBMWqGb2zAfXaSWt3zMTSIkV3nMKKW8HXkG9qgfBB2Y6AR3r4yZKSJi2JW+fkN674GX5oplm0Po+habRjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIKtgTrnblYvuBmzsLTxCXujPVJ2tJzxyGZVvN344U0=;
 b=iq1dmmAiiWL7Lfz7gJaNTClZFmgkKp0E3J8ESzRqssLatEnO7YsAl1FF/PdalawzVUqKaYFZUTnuotjs58LqTeeRkCrRpUFImt5+W0wv9HLcHZSegqVu34D+F/bor1JJ2tztuRTUIH1IRlOzmoUdl4anP4e49e2qCXYqA8C1SHNiHw2kgErLFCMkmbO1n1/WdFyEGL2FZHEHTtocEtla44Nlt2frZEtbzdHqzTijGUOcCp8FH7YUYVSD4LEyVnClLSW/WTbsH8OGXQi5cuW7qxwZfaFqk/6JC9T24aij8k3g5+Llv8mnOBxZnQ4tHvMJV7TusfNvkwzVDdGvRlVrAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIKtgTrnblYvuBmzsLTxCXujPVJ2tJzxyGZVvN344U0=;
 b=FYh1cUa/2L4IHbInLTmddgcIhA+cGi+UNrJ9b5hLce7Zz0jFQiOGtP3YX4hg+p3QZ63xG4HisjvQwToO4sbCRLPkSGyDf1I/nk2ZICbdl6k6IXu3QELl6ztu23vCyH3dUdYz1/eL5f5JYyEhPFeWs5TNQBAZNa///ZOf8U7kK80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB5084.eurprd04.prod.outlook.com (2603:10a6:10:1c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:07 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:07 +0000
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
Subject: [PATCH v9 04/12] arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
Date:   Tue,  7 Jun 2022 14:16:17 +0300
Message-Id: <20220607111625.1845393-5-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f7a2d4a2-e8c2-4b87-b264-08da487741c9
X-MS-TrafficTypeDiagnostic: DB7PR04MB5084:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5084F10C57AAA06C7911DB48F6A59@DB7PR04MB5084.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZMlHCLQWlM4k0vam3vgBwC4OfjGbrDNkf2XWpov1zVl5UTpm2Q+8mnaGpE+qDvZGcSlVWgffEvSBzJhpUibd5vIWW5mW3wQpYY6cEuF1T8lh/fE69SKoLjZODkOKLCBROQsZdnVmOWfjZgMFiHBh7FR+dVVHx8z39dGhIrdPnhhOql1LQp6RcknHPLMT1L2K7AiLEAiB96mc7Wuz6OGxBYy/ayZBfhrfpRhTvPdB8wMbV7C/uF6JEdA+7WubptOGGrTSi+Vq9dsZdgiA8zOXCUv9lrFrkza9LL1mQ6uZF7gIq/513XRAY+svji9/JlUa/Waex31w7XiK+ChXri8BbY0rFV5nTIu972JfGRYVMPKwU1Gh4u0lClDyblCHbB8p/bRiGbeUILnWL3PEiF4JRJVwJxfxcp0AyzS+jgMh7VSyepGzMKiREO+9Vmw/6TTRR7d1yBAbBWf4qotTGP9EDJ51/9S8OMwhoBVCDhT2AO3HYcTGMP2v8ypAiLKCZ4CZr9YEOyrSi/F4Y11Cdo4kxhRLt2bBVRJQsyZq2l24pEoLGlsUAGumPjjXQ7xvTb/jUfQy8xsIaiabLFy2e/99BLQkfH2G+lzOHIpNNMVKsZhnDVLFhGqdjHF14qKImGY2tSVMxLxDPl3lZbxudNJFQhWpAbEMhfmKgI9uX68VfuadSfyF9qgZRr78Dmd/j+KbSu56Yl5gQauQG9GZrnUXMhXg+z6fGDDks7QFQmaf20uzddny6ESNZ0ayBrYuuH+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(508600001)(186003)(86362001)(8936002)(6666004)(921005)(26005)(6512007)(6506007)(2906002)(52116002)(5660300002)(44832011)(1076003)(4326008)(38100700002)(316002)(36756003)(8676002)(7416002)(2616005)(83380400001)(110136005)(54906003)(6636002)(66946007)(66476007)(66556008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ERtEsZGptd1WCSNMiz2gPvzzfYXhPn+ecDmFoeLytK8ZpkS5dj8Td0pLBKz?=
 =?us-ascii?Q?R9IqOqrecOL8FGpEH3UWtqDkYPBuv4UM70Efqa1NNwFoSQBglx7zW9oeGgiH?=
 =?us-ascii?Q?yT9QIHpT+KQd6RkOwumX7kCCXxC19mJ/W/TCyzqC/z8O4mMCo/1jOrVv9sMD?=
 =?us-ascii?Q?I7JNo1KaHmktjdBEyg83KxsNNuvMXUtOU05cO1Lr8Fcvd01wfBvgWh4jZNEl?=
 =?us-ascii?Q?R/hWTQwvMCsrqpFBBjC8dZIL9361/jG6kmX6G4nXvUcqGxmOEtFSCaI/1EMF?=
 =?us-ascii?Q?kplNX3m+AaoI3xpk6Da1gtEUKbaV7lt2a1UOQ3jp/j36iYiVN4iUDiHcG+r4?=
 =?us-ascii?Q?ItylI7UqwHJzPyNCGr5ioF1lzeZlfflpCXO86km0FHGlUF3+mt0ORRVV/JNk?=
 =?us-ascii?Q?7ICus1KdfEbMClG18l5OfacqKYj1OBvH7/R/GaYtKTHKRc8s9HU0O14VjscB?=
 =?us-ascii?Q?dNvS9dYFjBIUzmzMltADA8Wngn0cZZ1RlBlbidbSleM9nPFutuzVpL2RcGlv?=
 =?us-ascii?Q?Axe6oqhYvGCagfcO7CCsoL38EsKePfP7BMCpOqcnLiIbLaOOBrD5c1Tj7mge?=
 =?us-ascii?Q?dYJincQV+MBFgkw9C8JjpsGW3V3y33ohp4uKEp24+Wm3eyfSTgS2grGf1xbp?=
 =?us-ascii?Q?ooIdnanB5UQRM17xJ/X8ZuUvQ1WDJBlVuSb078nY9VB/J/wiCL3FGz55uKX1?=
 =?us-ascii?Q?B5swvcAck+vHtWnyPLpOQWAnlZwfqHzLhUxSezysJMcg7vfAXV02gneJhhsW?=
 =?us-ascii?Q?Z/L6eMEt8TQ+UAdPI3QCA0Bk+e35OsR0i8SRxFvoP/4sjjy59cf2yZbFgTfR?=
 =?us-ascii?Q?sV4G12WsbpVO0JqP0esLNEziBglooQ+8eaZAfeyhmI0l5+kkfIlixLKMGonO?=
 =?us-ascii?Q?A2QSSkig9AOAyqrqEoo57irwEp7cFm8iUVIcwxRi13HyOCxX2WOs+8I0vwbg?=
 =?us-ascii?Q?Qvl7f650QiZ3VXrYnr6qeKWMmF7/DUxfm4/NZF7FqYKvyraTYJeJWN+ZsMLN?=
 =?us-ascii?Q?WtyMmOqMdgmKYE4tqIDfj0tnOvioOF1Bw5zWGOc7ERTXEioHCZ0qJF4NgTh7?=
 =?us-ascii?Q?s3Us+R1wvLS/cuhq6jz8JQU9lDPjzSS7YnPF0+MWUpbZwvDLC7L7rPiO7piQ?=
 =?us-ascii?Q?YphlBcjd8ZlT74bQzC7nuSlJKRhANdgmUXZ6HwgqN5vtldfls/rVIUaOFb6F?=
 =?us-ascii?Q?o4kfT0BxFufvUAdy0pwZI8uBdYbcH9m1nEi9/xnSd1ZXwaebQjsFV1O88xW+?=
 =?us-ascii?Q?CP/5FX8C8uRaTjrgTcn9Xs9zped0jVbYC448HDjCQ4MyV5LbzN8K6jamDKoF?=
 =?us-ascii?Q?jZCu29bw5Dw9zYcxSFq5VYEn3tOHSX5Gov2pakG6WUobfKPWnMKcxlG65IIQ?=
 =?us-ascii?Q?YT/aYI/JyBILfxTp7Fo6OIte9XLRMpow2gIVRaFA89xUlGg4yAT8JLdoFkB0?=
 =?us-ascii?Q?UnuWtrfApvWLuENzE4Fb5iIRc+SKgPBz85ebPrT/ZJSiEzRfey9yBx/I4HCH?=
 =?us-ascii?Q?dEgYql+KhsTz2Rhl7Y/oR6lXFB5Zi/k1eFMIB4IPzO40A4nO0Go2uyGf+gEB?=
 =?us-ascii?Q?3aZzMup1RmJQC556oqICGIZVc21YPK4DPfd3lU4PwCn1MKzaijDpolQWAscD?=
 =?us-ascii?Q?15nQQ9xGZGklUG7/VL+XXHKC8lmeQf8RryLFF5mnqh7+RcW1jf4RWbTrs0d9?=
 =?us-ascii?Q?Im+v+eBhkyIf3H4Sr3J7o9A6gwbQvjssD5FAFwhtCZMGR6+F72Uq3wlV62tD?=
 =?us-ascii?Q?wflfEedtGQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a2d4a2-e8c2-4b87-b264-08da487741c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:07.0266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YY+2Rw1Kg+iyyTzjaC5+t7mKC2J7ti81o/ceE6ecjfxKOVXgJEPXzs+DSNV65I7uWgvN9fscjrv5OAuKh7TjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5084
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

On i.MX8DXL, the LSIO subsystem includes below devices:

1x Inline Encryption Engine (IEE)
1x FlexSPI
4x Pulse Width Modulator (PWM)
5x General Purpose Timer (GPT)
8x GPIO
14x Message Unit (MU)
256KB On-Chip Memory (OCRAM)

compared to the common imx8-ss-lsio dtsi, some nodes' interrupt
property need to be updated.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
new file mode 100644
index 000000000000..6aec2ec3a848
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+&lsio_gpio0 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio1 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio2 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio3 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio4 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio5 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio6 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_gpio7 {
+	compatible = "fsl,imx8dxl-gpio", "fsl,imx35-gpio";
+	interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu0 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu1 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu2 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu3 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu4 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu5 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lsio_mu13 {
+	compatible = "fsl,imx8-mu-scu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
+	interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.3

