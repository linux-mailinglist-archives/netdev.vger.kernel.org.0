Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C384F1673
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358768AbiDDNtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358744AbiDDNtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:49:04 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40040.outbound.protection.outlook.com [40.107.4.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568273EA8F;
        Mon,  4 Apr 2022 06:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwG5rAht2xuJtYFtS/8ejETARX+Y0pMa6/5t1qWnyFqFtjOwIUH41EJpjHdUH/n4+VeE4DmCqOS12LtgkY+K0h6D7XRKwZguo0k7q2a5G78mmufPoRP6JTcfZEgZJPpvOPWFqk7KIWIezHPGzEMNYMcGPHcSwwZAtgxlg/qv/s69W84wCw43jZdnekOT8adZeGBdoNtDhbW7/MhhE9OjmKR+ol7gNrRPV6OhUbT2zBmDLC02+2mAXbYH8XELtjnoCOliexYF8wYpe4cfO0NU60GA4bzmPokUJbq9FnH82+M4mRdJhrXpeSQVzISoqICZ4PPAgMN4m5lTbvdjeKKEOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrvOL/YvVa8Wzn+G/TTec9zgBEcDk3Bpou98FWiloWk=;
 b=kkofMr50ansDeO1rtnDM2YXfCQuNC+AXnpsbcA6Kp2b1Xu1W+pdc3pEyqdhyXejCQY1LOBphh9KfxgY01dLSwZxXVVSSAO41KpdajFvIBM0JV9QoSfuN3+cSab9uu2CXYDTjG7Y2zqvSZPkIG40I4Myg153+g3CTOxmtcv/gePAHjrL/brhqX2k+wKqL6zNQwwoaRdKO7KcCNckbEz19FBcc9BO/kFxnD+OhP/CU1aD0bq9flJT6M/vkdgejk4OWMGBC6Ac95CygRznuAP+YKK8LFWHjKB/zKmUNXFdWl7T1Bzfxur7ld5mdIHtpqucltK+Jd1DUAxvraJS6+GMtaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrvOL/YvVa8Wzn+G/TTec9zgBEcDk3Bpou98FWiloWk=;
 b=NWwtucYdRkaInJaeFB6R8At5cHo7sTYXGME5YoAA/ns1LEpqZMq6Hilzf2kKOTOksFFjxOTfD8iyM/K6r+q99C8df5zsG5I3PQz6eZ3Vc6WdHi/A6FtopBFURUBZc8d7cxVWVW+lOPsypllRivFK+f+SdqbO+1vXFD/ODDy6SVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:41 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:41 +0000
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
Subject: [PATCH v5 5/8] arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
Date:   Mon,  4 Apr 2022 16:46:06 +0300
Message-Id: <20220404134609.2676793-6-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5e56526b-1ec2-417a-f7bc-08da16418cb8
X-MS-TrafficTypeDiagnostic: PAXPR04MB9218:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9218E702B64C0929A2A504B1F6E59@PAXPR04MB9218.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxMczNbgtuIK9MMSLIWc+kzbhch2q9StWx9eHBRc5B4ffyxA2Pd94ZUVRxb6ovIy/qLW36glxWJWi5TOu0bapC9WFFHo9AawSyuQ5vzYAQXRUsEqnNS5owMoKi/GN3mM19+us5CaTjXBCLKMXUlBtxlW112j2+mvYYNVz2C0pyp5Ua1kCeVqLwXq2/j4bAFfng7oByTKt/J3oyUWPKqd3BbLcO0ERmAwSZSmEGs9nn2/biWjuCqnygVW8tD7qukXq/sRPUcgROgeqaeKPibLIRIzuFOOctswPymjIUEiB+/1/96I/EQ008wmk2o7Cnt+lUtAcWdbnTGCnG4ZQqWnJZT6Iz8aU5B2yo+t4fgXq8lGYgU9myofIDe8uNxcSAIkJI2g62xVJI/nYyQUfUwr0ke1BTDHKoxCjNnCFYsryRqWy+OtMAPOt6E/4jbnNXOGIW2L6m2VRdQeUNDJF+Rx8CWtgNgnYfImgQZsEAIuSlOmjoZl7I3EP1m3TkbBYT7cKPQHKIZ8P925RRQFceI3FN6MNXmHHEORZyqnn95zeVeyNR+rItNyYMNqKhUP6iu2iRViu1HdusTV5iBUtbLf/YiYRvDxekbkyPOAawnRAzhOX2xmJ4yjeF1DyDGIhSFozZqEBBtleZ/cc5/RAMMlftKpHV2BMTYDWxRTgc7rtlxkAqwKAvUChbfSJQcvoKPfR+GP7IZyGo2a94cvKn6xxqud1zNdsi5ejA4fwHJO/lY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(86362001)(6486002)(2906002)(36756003)(6506007)(6512007)(316002)(66556008)(66946007)(186003)(66476007)(6666004)(5660300002)(44832011)(8676002)(508600001)(110136005)(4326008)(38350700002)(54906003)(8936002)(2616005)(7416002)(1076003)(83380400001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WPGEJ7N3mZsU9/TK2lh85ERBaxkTTqspLsG9z546h4vKtFOVbniZWU3UcvHI?=
 =?us-ascii?Q?BPQLXDfnhHZGZZKlCU7KrRPY35WZqwGjt5FN5jVAn5yi4y6RNHAijXHmvGj0?=
 =?us-ascii?Q?AjXnsRR5NzYj7NINfIsubJGJf+YLu+/kw8BngSqzCMgHqlbmjKlVrctOmDUK?=
 =?us-ascii?Q?fmtrO0Aotrq4QRnPRHZSk9FJlCA8OT1Ft3mdtzweQDzUxD/RssGlYFWpGTL3?=
 =?us-ascii?Q?P48YabE5b8pl4hHtH2tUeNhszF3ThAS8XdsuB/XKVmy245ilx2r/TzIrEXRO?=
 =?us-ascii?Q?zEatipxHMx7p5QRm7ApCnEkQsg5uZYalPUr7Tr6Mmj/fMXglPyIgMapW5Qnj?=
 =?us-ascii?Q?hBEBT6M28iRMRREw4GWuM5EpZvS/U3si078KWe5Tdn0pWgF+TxurT3O2smMQ?=
 =?us-ascii?Q?seFwebcFwubEM1H49VUtfrGvpQRBCdCqrxOrmiHS5/ik7acYlo3o5CcOw78R?=
 =?us-ascii?Q?liBTt96pp0+XOF1lj05wnzD8KP6Zq0E3Ddq8W5pAKSXfsUQRnjzUuRMxqAel?=
 =?us-ascii?Q?j3ix51W8d6P4PwCQZzVGaiTWDXBvs/vx2ACj/9nHVzQA06QPdhD3bey2OmOI?=
 =?us-ascii?Q?RD8rFCTyazZVBTtKI4nzqB/mUCRhIRKfehf1efHgd0e/jtsxSxZ4vMFGXUNZ?=
 =?us-ascii?Q?IKYZryZ/jL+LynIlqUg2HG9Drb5IUNWNcN0YFwFLDHXJGoF0dnQknIkdfwXD?=
 =?us-ascii?Q?NmJSYcyEyDjVgZR6h3xv1QcJ5p4t0Q8+6AEUUQqAqH1jAEYKPF6lXlQWf5Da?=
 =?us-ascii?Q?Bgyz4Be5x0Trp3RDJ1WCF3/iNnRtnrCIEdlHQlZAmR6Y0ujs8D8ad31VpCNk?=
 =?us-ascii?Q?EUdNvsanycDSt2zXzTFt/ct7sWvo/5HQ+ziY3S5VAxNJb9Uy7nXJjVdR4Fif?=
 =?us-ascii?Q?n6ixwf4LbK5NjSTSaG3V46g9hkSL4Sbshu9KeApzc3d8k/P4EYxeE1WHaJmG?=
 =?us-ascii?Q?TQ1QITYcVFdKNtC2bP6puXtGaLX1fZKWNexktmTIwXXU35O28ZL4RDOfUfk7?=
 =?us-ascii?Q?oxdNI1/OS6sNdOKbdpzFeNa8OajcIfdnIOCjvCa/uUQ6/rX6+E29OuBcHXKu?=
 =?us-ascii?Q?PmPz/d0BnjydHnvqbJ3lfW7w3z1AiTA8XK/Gmmt8JZEHh+ALEIGueYpGIcS4?=
 =?us-ascii?Q?mZ1eIoT2ybWEmBM6AnwQFsgIzOttmfBzAkuQdKD6CG9ry31BbuU6pigk5jjC?=
 =?us-ascii?Q?CRq607Epd1YOya/oG22YmokVMltNRxKfc0ozSErpNQyDSWVec2PokPFASVk3?=
 =?us-ascii?Q?5tYfuOc1Jdo0vgpv8KEbS/PzqhTG9PfnoKaKLTG/RfOOww7+Sko89pzjSpyZ?=
 =?us-ascii?Q?wlNmiQh2ZOeKI/hLEr5vSx3k1pfl9iUPwwmzDRBI41bFLh+tgVzeup8oxTGp?=
 =?us-ascii?Q?zpjt5GGZ5znNZhX06p91G56XnFmdu0tpC1uj0GPg82P66wy8vSLBJEgXTXCE?=
 =?us-ascii?Q?etK+OyvDCn599LW1NxdjKtqNFyrBNsh0KvM3Nw172jgAYC4wPL1zhqquzmMZ?=
 =?us-ascii?Q?zzybC8I/J5+Ws4bAnTFC9YTEolQ3bVsuztAtb10VaSPbL8yLunXTZe9WkmOq?=
 =?us-ascii?Q?unhXAk0xzP6SyMdEzZLn9XQ2djV4ngYw2DNXSw/yTPG8db1fw5dq6lumSecJ?=
 =?us-ascii?Q?wyd+boLWWN1lc7ipBN9z4V0EbTuadOT5BDCb/6D0bMWGLV16SKpB9BRi+b57?=
 =?us-ascii?Q?XmsiDDdjSjoc2g5bU3h1zAEzbukjntzgK3FqUD5Uk1tBFx6gkiMulvVYDpXY?=
 =?us-ascii?Q?wiLH15DPJA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e56526b-1ec2-417a-f7bc-08da16418cb8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:41.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9PgbXALDccvXeHPPgpQxmzFaUulw2SCZbAgPDO92/hkrk7S4TzU4WZO+Drp5ybgu1sEwLFZ1ogGtDjHBvoN6A==
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
index 000000000000..d90602bab384
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
+	compatible = "fsl,imx8dxl-mu", "fsl,imx8qxp-mu", "fsl,imx6sx-mu";
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
2.34.1

