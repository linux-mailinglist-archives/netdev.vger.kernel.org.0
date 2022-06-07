Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5E53FD2E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbiFGLQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240348AbiFGLQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:16:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E125B396A2;
        Tue,  7 Jun 2022 04:16:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ab2jAG/Uj59x/CnVxoHDKQHptbOqUpiL2gxwhR2uMx6l3Hu99wSM/Vc0CK0XHrSjYhIFcuoniVxzBhBQ83o88ypUzBbnJJaUfvom9wyFP0yeFoMQicqLc7rSNz6T4DeGJFoseKCbWG/gU5scBqDa3UAx+14aS0qFyYpRTLbQ5GHmrjvahfMozQG2A0Yih2KCOqOV9Je2Uh+70PBHHy2MtVdf6bccfUdBcVy0zIygpCccbwf1JWKLqgs3lWpPuh612ixtnGL1ZQjNbyuGByGqnVrVLLUrXJPGSHCGQrULV0Yc+xAMNNOmQIPSAXc3iNICms/g4L4/O2rQOleyMjpkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzgF+hCnaMVluIeAyOmJlFhKygFVr+FUMvTwLJomHuw=;
 b=FJzESoLbxQsfC5Issby5Uyy9oVPC7U5wgeTQZBWrMbvqbUFo9he0kESxo/EJXa3PRl2T40ZWunnCVU5nL4XLZzjMXTzhgUiBxU4ZKtwGbeCGdboyLzrDp9kgORL/84bYbvoIZkHwKe/NgEiI5ZpLcfEE2mA5sd7nVkj1l6S/Y6f2SUckB1Ag9Chn/Hlu78jfuODOpbQBNcpS2TUWG7W/vx0NKzZgejqsGKJ26SJM+IGmwNwyg4Ah5TwCcemmTC8nvTpWro03hNjXQ5ytfQcvDboA00wXg1ImaKRv3QGcRNYkKGNn+fvFFFZ25TCj9NKNVVaMOoDfsB/bARSmRZXzcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzgF+hCnaMVluIeAyOmJlFhKygFVr+FUMvTwLJomHuw=;
 b=HjgZanKb0gyxKebv5taZh/fGh0o/0KnjEq4HIukGptRXmT8MkTcWw+bO1W2gjx4HS7lGfNuRddX3fQ0QNPNvFSnf7+Pa2cS9tCzuoPhZAfNkP9ucxyRoyueTQRRPxGXzG3pUYBB+LIhuoHU+D6cuwxHEVPsJuHm/5gTfg+Fq2pk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:16:51 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:16:51 +0000
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
        Clark Wang <xiaoning.wang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v9 01/12] arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
Date:   Tue,  7 Jun 2022 14:16:14 +0300
Message-Id: <20220607111625.1845393-2-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d2042837-7ec6-4571-c2e3-08da4877388c
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4890E9A60C01EDA669A304EBF6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiWTTyafEhYvNBp10d2EJt2f+H+E/eCl0WUWzmI+rOi1Zfl6s1hUA7O05+KNYSI33ZB4VG0u5mLZtxmi8Vy34txuLP6nLkCJjifNo1GMRTw5iv2ODSmbiadataOT3vlZ8dL3iTKj6i54+PZR7RcD5jkB3dwWDC5i7MJ8DbqvEwECV51JWkx9fKdddc+O6kQ9SXGcou2MgZvU8DCWzDMlr+PeHWtUffFe7PPXt6grM0kR6eWnYYc74hwDxXwAAhTQ3Z5pdusytQmoovTvo69muX8/IJ1nc+rTwiezCL30zF9UIqzZ9YReDpBe8wbm04/FGVWu+8wa4OEfLvFsNLBpBP283b5FzBKdS4zyrzZVi6SyJurJmHCyrydjRze5K/OWXhBNVa1axiIaSsjMJOOpepTGijo2doB6lFodkx+5wDCJ5ke1k2aLdxwzgpxVrZjAhUlx7cudTuuWEu/2ojHyIoglIwKOk6XemweU5evLKlHk8MLSdL2TGZAe9F0KZVVj36m33FQcvqeHvCIYfzKqLeCTRhM4sXne3ad8SsBVrdfNhHwRHKI3kwWJUTjS9r7Bnn7x4BdhOWbxBCXwUBWWNmEU6uqbD/eTE8VFUad94FhmShrXc7QK8DpxgVcW7c1niDIelTWJ6tQjeSpgMCvYuPVN6amuOgu0tV6/utcA6FFjqe3BSgvfYl4Jj/X1diZdxcbJ++CnusUSP65bvnT4om0GpIXzBxflh6BcUpL88YCCsGt+GUcvrljQ/AyN8JOE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(83380400001)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hLZ+0Xuzb1KXQZn5Is8mXChWGAemZm1yd8OdQ1LtdosWHsZ7N/O9tGJmCkER?=
 =?us-ascii?Q?bzoo3oR3VD1p731dQfH7u4GCiOjjzaI0FOmvNt67e2PNp4d3mXnyz3/y+aK0?=
 =?us-ascii?Q?woLHQsTruA6U3k0WYLepL1POOKEbiZSvKax8dC9PwGyQQXezdI5q+XI2eEHr?=
 =?us-ascii?Q?lkH5fbL8681Cai2tKjZAbQ85woZ/OER7MB3DNcyDs2NazC/B5uJbtAMHt/9f?=
 =?us-ascii?Q?7Ipwc7mzGNAYaqddcTb0jwXc3XBONjAiKs739W4YJH2Nx4kp8xuzUDGcKGJF?=
 =?us-ascii?Q?11b/EKbjSfocSsjU3TJUFXU5j0g+vapYANMXY7JSaedO8ml4alX3ivgb7tFM?=
 =?us-ascii?Q?apn8fckjmQ+cQPZgrG1E4yFzDyv6erUtjS9Y6IH3r8q+vs8Exa4rrIbdlbWu?=
 =?us-ascii?Q?ghE0R6jGZkuwrPgis+JkO8DT3yDJMm/IDqRCOtYfFYAcLL2B9PDw/zhLxYYR?=
 =?us-ascii?Q?ia+OD3WH9cgRao5Xb6WqRCNkEwpupBLg7TC1oW6aUE2KtqaMWxyBHA+QffA/?=
 =?us-ascii?Q?TMwlHBUOiBPt2rIhV1rHkjlsJMY3mOZn/CND01YFIpoOdmfinwqSt8oZV7lq?=
 =?us-ascii?Q?hSjrS9l4z/G2B4589TP9d0jIqXHldWL3p+c03HS35Wl6Af8dmZLc37WnMeQX?=
 =?us-ascii?Q?K/V7WN2RKsHXxaCSPE8PkThvIgWo27ujTa7U+VZscpLrPeHcshrCXrQs98EN?=
 =?us-ascii?Q?jnGUjIjWegeeBOx8HsIryEVg4w+oCfvLX9VG6byUf750P+5SeaEDp18GzwuY?=
 =?us-ascii?Q?ZjRm5+lC8R5iuSvkXAkbI87yV5SfEOAqY1Dep9WgTqOkHcnQZOoYK3matnWt?=
 =?us-ascii?Q?Bx2xkZhc70UP9WGkYhO657gDGUzG1sQ8MUUctvVtWqQeGMGjrUCDyHk7GrIQ?=
 =?us-ascii?Q?ea6fr1SS3di/vr+c8sr0RjSmyTleObJq24lYe1Bw8sHPlkGLnSG3Caug2WlJ?=
 =?us-ascii?Q?1tbAI8jdav8uA8gbQ4o+B3Rppe5THpksD8DfwiOwsTLupTPSNx1eQLt46BSm?=
 =?us-ascii?Q?X9rooLNGPSvT+aSzC3xt2rmeCXlzxtib+0hGPmKb0ov6lxvUEAUkVbTnXs5m?=
 =?us-ascii?Q?OQhyBT9Q6qDN0W4npgPAOBYkanTcJ/B+yf4MfR9DfJ4gM1hWHmxtIgKQWnXQ?=
 =?us-ascii?Q?PlbDNHzapHApi9ZHl3BcK+LTm+HG6wvIAuARzjBC62scCSGe7dmbpWZcy1rh?=
 =?us-ascii?Q?yED8VWS7ig/J4g//gUCANH20cJH3NFVSglJz7zFRQ+43cVans4VgjPskHSub?=
 =?us-ascii?Q?TN1C8W5/l2r/BaoGMVTwYU6X+3CU4DpJ72nTgf0M8lFjWJHAYWdmnXuWkSCA?=
 =?us-ascii?Q?ZZl7S2JLDX2WeHOaGBRQFadLy7XKOi1cpuTIHQ3mNlo5Z5y0TtVsDqj5m4UU?=
 =?us-ascii?Q?AeQiXCM5Ji9D+aEVUIs1MJFl5owoSIgur9TondJuoB7KX9joYPHViyTq8npv?=
 =?us-ascii?Q?0lasAEgDrRpBcNhd9i3ivP/7/p76elw5BiblNCRc4gOLWuGeO87mzIWdokpc?=
 =?us-ascii?Q?wFmccklOMkuFj1T4bBiNEVtSNUaeu/9kz1ZZozxuGEgPESQI1x4qYSxbuRhF?=
 =?us-ascii?Q?SnTQHEl+Rr/3J+Zv3u4ySN00Kk6G0sVSff/NiyWFK8vxdjg4tTfyHDpn8j65?=
 =?us-ascii?Q?IHcbcYYPWlfnoAlhvvFxNNS3GBBNn7h5AkHy7UssNs/8RSnHKPBzeQrLe1sf?=
 =?us-ascii?Q?+ooQ96Qbyk7lUocQD5/DRi7jOIHWoUHtCv5IVKiCLeUm2VkwOU6tUpzwnjQB?=
 =?us-ascii?Q?ZyMKcrtAeQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2042837-7ec6-4571-c2e3-08da4877388c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:16:51.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iE+9NGT3vKQPVcLQx+KeUqOBryKNsl/7znfG5VKmyHgfzyyEWP9obvhpa6w+LmqFAdDIdMm71ezxtUt0CboD3g==
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

Override the I2Cs, LPUARTs, audio_ipg_clk and dma_ipg_clk with
the i.MX8DXL specific properties.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
new file mode 100644
index 000000000000..4d0c75bad74c
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2019-2021 NXP
+ */
+
+&audio_ipg_clk {
+	clock-frequency = <160000000>;
+};
+
+&dma_ipg_clk {
+	clock-frequency = <160000000>;
+};
+
+&i2c0 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 222 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c1 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c2 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&i2c3 {
+	compatible = "fsl,imx8dxl-lpi2c", "fsl,imx7ulp-lpi2c";
+	interrupts = <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart0 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 228 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart1 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart2 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 230 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&lpuart3 {
+	compatible = "fsl,imx8dxl-lpuart", "fsl,imx8qxp-lpuart";
+	interrupts = <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.34.3

