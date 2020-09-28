Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D382327AB71
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgI1KDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:03:03 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:20046
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbgI1KDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:03:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDes9E0UgKtk8kYANW4dFpsf255L6nFQNW/699FoDlHoB+guD/ZUlHNpIkRT/i6guZFF6VBtUuUKmpn2RtNvrAZerU9yvr0HgqX9G+mBsew5ZRHBbUWKW0u++Mrs8Ts6/DGCjQdVSWK182f0dq5qLTyCSyRR2LFDaPgATeRlr39OfGiMElpesrSgI2z5YSPc2xTyJFCj/8AtWhKwtwBMIE/2VCCjnlu2arDrehbSibEzlhSmqC2F7cZ9/MNwopDmurwbWL92gjo+v6ROZOPrZST2e0XMGyxoMdboWsrwhxFBT0f1460Gn/L4N4IPKSj5k5rnRnREmnM744pMbWm0ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dCP3tAifiRxz3f8ii2379t+5xtF/4K+kZmSGk8TtS8=;
 b=iDzozL9nXkcRDMgUPDK0jXI48FRI3h1rpOJvVcgvkqZAn0j0eNeAoegq3un6DeqvlsBGQjpkaXiy5RihvAZh4Ev/jmStzw6mCzcFPJQZ3Dn7eaw/t3tI6KjNucVEjNdq/50K6Mk7cu6c9jrwAYSEDsFFWtGLbpteDgoQSL5/6QJQBlTp43g2SOz34O3Kh9Sk8yDzB+AuvKpRt3EfdfvWbuopycpJhYsYZYHX0pyehFxTCnaCmAk/WX8r4Lu0wWRMB8Pgxs1DoU6wzftyeQf9vSBmdx4vdoMWk6eVyw5zqzSK7x73IsoUUot+8op2AHvqheyxquB/IQixWuOY28pQcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dCP3tAifiRxz3f8ii2379t+5xtF/4K+kZmSGk8TtS8=;
 b=bIQs019owDO6ndJxSG/v/wrvQ3PLRNZie5tsPOQVKxz4Dj+Wg33JiEug/4aFCBS+M+9FQ+sOuGlfdvenSJNRW1csy7p8dMlSL3hfePrhWnpIXum9DI/LEPYyCflzP4S+4UeB+czsncx+Gp+k5wcZj2dhbU5viry5eU9th9FdaTQ=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3769.eurprd04.prod.outlook.com (2603:10a6:8:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 10:02:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:02:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for ECC function
Date:   Tue, 29 Sep 2020 02:02:51 +0800
Message-Id: <20200928180253.1454-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Mon, 28 Sep 2020 10:02:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ec75227-4ca2-41cc-6d94-08d86395ad7b
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3769D4FC46E0E566BF49F206E6350@DB3PR0402MB3769.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OtkZpe8so6HlzuLugsvBEFRIuXX0h3nDkcIc9sd6d6CcLYNsw9lEwRUDpWP8mF8aovdBqSM3+DB4S/8+eCXgASeo4FjJEXIOuUOUQ+kzGpXlWAPwCiYsLl3PBFnyu7FyLPF2bES6ee+fi99/m+I1rkXHEfvwM3ssb9u9kAfqejgXat04mxhwLPh0ANknhCH37UU2mRlVNYehrRovathqzF3CC7rg1Mf4Jdo9GLDekoWM9KOEA7rZgWYLlr1UlvkYAj4z5w8XwAL2QgnYPeBRYREJj7W04HSP9M+uJl45WoXXtyFOodkawncRaMh2HSOOwyqALEilpz//ch37C7TZG5vqb9qyic8sPMOs+euej8SrlgF4/xzTCkornWQQMF5jO8rBR8i87bdNsA21dxn5zOUetwxBX7esY48GoqPZ9c2RQc3UR5ouzfj4YnLrJquW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(6506007)(52116002)(2906002)(478600001)(956004)(2616005)(186003)(16526019)(5660300002)(66556008)(6512007)(66476007)(4326008)(316002)(8676002)(83380400001)(8936002)(66946007)(86362001)(36756003)(26005)(69590400008)(6666004)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e6RMz5HDon+HIxYrYh8BZhDRmh1krxUzEQ4k/xM2NYEw72Dga4eMSqtzgkNju2nAQ6CGU/88z3yOajAybMCeqBHufByQBfRt6i9ZX9bBiHa8bu717eAtXVdC0qwk8wiysWHAbj5cfj6gyWjCnq3izxTokg9rCJUEDxgG/5MyPkClju4DB+dHHXag684Cx+Jv/ls/QZOLn0GoX8/5GKAHWODJaEjOUVO0VZDembebfGpAs0RpgxCTyvTuzS6lP+b9BoWYzJ882UFZgmM8Sr/krMa9rR57TrnTPLLR4c4pmzF9FQjkX9VAo9f/IKoXGgq4SA8kkuh47sBEpDJRlo/bwaY9bVx6oZ+AFAkr0YRgwQVoDzNfdIBM/9lk2KATfNN7Ef5IGW4W5FmsoMVI33Tka3Po8Poj7EYa5VvBhwI3wWMYRbc56Udhd0O4N5MPspZGkUUUskKQxJ60Cdixhsc889THSMf8dowXjV649+aaEyUzt4vkkLymEdsphaO7Jm34xe74nbZ1Yr+JU9nChbmG0E9a5oCYT61Hmre4id32cA20qI7FaQ+K5Ose4JFCIPKkDvm+bwSG+XKw034J6ZcCPm816PgmngnPncG6JT8uMJdd1KdprYInQhYl+Hkf9AdFDRa9Q0mC25chHHo8M/LyIA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec75227-4ca2-41cc-6d94-08d86395ad7b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 10:02:58.6939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjooA7ErDGi6zXMXXfgWaMtinffo+nTfCEDwaZeXZ2h6NCzbIaYcfKjHSMQJauiQU0stCyXYqXlpnaCo+ivjGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3769
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One issue was reported at a baremetal environment, which is used for
FPGA verification. "The first transfer will fail for extended ID
format(for both 2.0B and FD format), following frames can be transmitted
and received successfully for extended format, and standard format don't
have this issue. This issue occurred randomly with high possiblity, when
it occurs, the transmitter will detect a BIT1 error, the receiver a CRC
error. According to the spec, a non-correctable error may cause this
transfer failure."

With FLEXCAN_QUIRK_DISABLE_MECR quirk, it supports correctable errors,
disable non-correctable errors interrupt and freeze mode. Platform has
ECC hardware support, but select this quirk, this issue may not come to
light. Initialize all FlexCAN memory before accessing them, at least it
can avoid non-correctable errors detected due to memory uninitialized.
The internal region can't be initialized when the hardware doesn't support
ECC.

According to IMX8MPRM, Rev.C, 04/2020. There is a NOTE at the section
11.8.3.13 Detection and correction of memory errors:
"All FlexCAN memory must be initialized before starting its operation in
order to have the parity bits in memory properly updated. CTRL2[WRMFRZ]
grants write access to all memory positions that require initialization,
ranging from 0x080 to 0xADF and from 0xF28 to 0xFFF when the CAN FD feature
is enabled. The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers need to
be initialized as well. MCR[RFEN] must not be set during memory initialization."

Memory range from 0x080 to 0xADF, there are reserved memory (unimplemented
by hardware, e.g. only configure 64 MBs), these memory can be initialized or not.
In this patch, initialize all flexcan memory which includes reserved memory.

In this patch, create FLEXCAN_QUIRK_SUPPORT_ECC for platforms which has ECC
feature. If you have a ECC platform in your hand, please select this
qurik to initialize all flexcan memory firstly, then you can select
FLEXCAN_QUIRK_DISABLE_MECR to only enable correctable errors.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* update commit messages, add a datasheet reference.
	* initialize block memory instead of trivial memory.
	* inilialize reserved memory.
V2->V3:
	* add FLEXCAN_QUIRK_SUPPORT_ECC quirk.
	* remove init_ram struct.
---
 drivers/net/can/flexcan.c | 50 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e86925134009..0ae7436ee6ef 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -239,6 +239,8 @@
 #define FLEXCAN_QUIRK_SETUP_STOP_MODE BIT(8)
 /* Support CAN-FD mode */
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
+/* support memory detection and correction */
+#define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -1292,6 +1294,51 @@ static void flexcan_set_bittiming(struct net_device *dev)
 		return flexcan_set_bittiming_ctrl(dev);
 }
 
+static void flexcan_init_ram(struct net_device *dev)
+{
+	struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u32 reg_ctrl2;
+
+	/* 11.8.3.13 Detection and correction of memory errors:
+	 * CTRL2[WRMFRZ] grants write access to all memory positions that
+	 * require initialization, ranging from 0x080 to 0xADF and
+	 * from 0xF28 to 0xFFF when the CAN FD feature is enabled.
+	 * The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers need to
+	 * be initialized as well. MCR[RFEN] must not be set during memory
+	 * initialization.
+	 */
+	reg_ctrl2 = priv->read(&regs->ctrl2);
+	reg_ctrl2 |= FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+
+	/* ranging from 0x0080 to 0x0ADF, ram details as below list:
+	 * 0x0080--0x087F:	128 MBs
+	 * 0x0880--0x0A7F:	128 RXIMRs
+	 * 0x0A80--0x0A97:	6 RXFIRs
+	 * 0x0A98--0x0A9F:	Reserved
+	 * 0x0AA0--0x0AA3:	RXMGMASK
+	 * 0x0AA4--0x0AA7:	RXFGMASK
+	 * 0x0AA8--0x0AAB:	RX14MASK
+	 * 0x0AAC--0x0AAF:	RX15MASK
+	 * 0x0AB0--0x0ABF:	TX_SMB
+	 * 0x0AC0--0x0ACF:	RX_SMB0
+	 * 0x0AD0--0x0ADF:	RX_SMB1
+	 */
+	memset_io((void __iomem *)regs + 0x80, 0, 0xadf - 0x80 + 1);
+
+	/* ranging from 0x0F28 to 0x0FFF when CAN FD feature is enabled,
+	 * ram details as below list:
+	 * 0x0F28--0x0F6F:	TX_SMB_FD
+	 * 0x0F70--0x0FB7:	RX_SMB0_FD
+	 * 0x0FB8--0x0FFF:	RX_SMB0_FD
+	 */
+	memset_io((void __iomem *)regs + 0xf28, 0, 0xfff - 0xf28 + 1);
+
+	reg_ctrl2 &= ~FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+}
+
 /* flexcan_chip_start
  *
  * this functions is entered with clocks enabled
@@ -1316,6 +1363,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_ECC)
+		flexcan_init_ram(dev);
+
 	flexcan_set_bittiming(dev);
 
 	/* MCR
-- 
2.17.1

