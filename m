Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40027CED1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgI2NP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:15:56 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:52705
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729532AbgI2NPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:15:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k54g+0+7YsXO1Fwh9h9YYM6tX53rcvkaDbguRLQO4SWZtzgJ9xbusg+979kdr4wvRvTwP9VoFPscM8pgbdcsmBQGYOfl6kQNEkK/KB8P0yfoXi5ZnRoc6/bWMUYEtK3zFio4c/elpIkbndEcgDCBRO6ujg9XMGmM8TffATuJmL1KGjP0ggXxfjnMDCYmpkCJ1MKItd83enSE/a3flQQ3iS607lCa676EGeFjZkwi/wk/9aNAIxFgm57T8SFsx7L5AaJ7NyoGDQMKJjsuv2wce41t5fhgBsanw9+0ZD++NpCAXQlLjYtzqF9mIKBB4farHKGxFT3oLn3aVRw701gCXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DYWCvDiEz8KOFy9XGfuRH5656gDSbnLgj3VR4w0Pnw=;
 b=TWuxgOHraOEAztRerMQtYjqU8cctNx/OuYJIAaEbFgVogWVlH2ZPYxMuGzzpneBTcjeMQ5bPmiKb31M8W8QtXkA/nf9ZTfoTRrsgT/ow5ZRC3kPnZpuOQ9D+bUqVYyfQ47e3pd9ii/omTdStL8/X1lIpBNOTWgwjl3SrNYkMfL4gOMe58MTCwgST54pFS4GwRc+MqhkoV/3jvEolRqovdZxtkth1PlMQnqNp/28PugtoVSqjlnFgAcM0cwVBD+BHJENh1LctMA+606u8kYg0hqwk9exXVvaPuxP7rLaU9jJ5+shWP8q1j/cG6RZf3zuARv79I061hFNqUR10w/32mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DYWCvDiEz8KOFy9XGfuRH5656gDSbnLgj3VR4w0Pnw=;
 b=VuJYVyRFcVdusB6U9Eb/xrn1Qk9mRgYRjgXpUt0EfCKJ1Ggkv78xM9giq2EHjYhqqD0cVunhvzv7MjGmHdmFlcoQUW5+5XSGMauEfzOL10muBwiMfMkiwRyjh11XK8eV9d/SJIqBpCcT/0njQgjhzdpl12fvyFr2jDQv6UWeyko=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB2967.eurprd04.prod.outlook.com (2603:10a6:6:a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.28; Tue, 29 Sep 2020 13:15:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 13:15:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 1/3] can: flexcan: initialize all flexcan memory for ECC function
Date:   Wed, 30 Sep 2020 05:15:55 +0800
Message-Id: <20200929211557.14153-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
References: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Tue, 29 Sep 2020 13:15:46 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c1babf27-555b-4250-0c20-08d86479c798
X-MS-TrafficTypeDiagnostic: DB6PR04MB2967:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB2967710987E5F48F4274EA96E6320@DB6PR04MB2967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6AsR9qFGtGUPpX47tgfeqSa7TjTHVGM3LBCWXNw2kJ6p/jxX3OBgAZ+l87Kd1ZJ4mMhE4xf53kB8DoiwzN0cyQDmI+RgZVsO2YKok70mCqoC1iGQQcjBjY0c3qWD6ZHDJBeAQvYXLQJgjvPoz34G3Aj3n8teH9w2ETPU1S+FOFp4YzH1PH3/HSrdrj6RUUafnHXd++NjVzoIznmcqES7ceuwanNZ8fLIsJe8RbamDt6veWYgJnX0d13Uwx4qpurdqZkV7L4WLUv7JG8VoH70w6U4+/pTElisuUgLBqcMUl9op7fDnxBxX1QMVHmXzHU7ltHgcjS6FvMLZDFwPsGz70y+1LTEmm81T3zITSVAwFKHMTIMKh3WYY6S0cSUYGGL7jAm9tfsiCfvPsQV9iwbuI12pK1ZXufaIg5gch/jY3qzQLXUo1CMZ0Lb7dvukPo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(8936002)(4326008)(6486002)(26005)(6666004)(66476007)(2616005)(956004)(66946007)(36756003)(5660300002)(6512007)(66556008)(2906002)(1076003)(16526019)(186003)(86362001)(83380400001)(478600001)(8676002)(316002)(69590400008)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /SE+LbrkmveeUrJUiqAhCZmjRPc5UAaXleSlwOEyCZrB1X51szKaQuV3AKwccOtXgHCarkAQvQSv+OoIBAfHV00ZO30OdjNgmv5RwaFD2Jt7X4hpQpMX6ss6s/rRgWCUV/1MV2jZVdIsxuqIy8wPCOpU810Olc5dQDjoH88pVpx4ik7opJGVCayYAsruQxEzj90kdqXXJBo+7nzMsTjuE84p50G53b6E2NY+kluh9Xu7DSFmckI/TdhNGtHfZsNiAD2rmkOUafO0Zo+e5gY2Yd8zlIyaex16RjZGt5qYKc/ZiIKzooCuLnFFVsibRMRse8mN2bHQhCH/eOFKlO9WBF2zW8P6T7UTJKDcttzy89qUK+lue+PnCBfuYDc7vaq1rYe3EyjMqQmNPX9OgNYvZer8pbSk8e3X9NH8VNq1xcjvzS97na89j0sfDtQ0XiJHgrDXv9bvPsp6u5irkADaN3YeiO1wxDaXeA3pPjSHE9z0rifjJ5xwiqBadMrLnCX9E18zyRYn0KvXuVvMdGc41fJDXyaQYZmhgNCkmRyPvIlFyjxFEvp52l0pwxb6vi9N4yRQXjJiJmElD98xUOIT0iZTOFMAqNBKI0jYuZ1yIvxVNAyf5TXM4i/0pzlL8pPWG4d/+sLKnGKqwTS66r03CQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1babf27-555b-4250-0c20-08d86479c798
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 13:15:47.8840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWG+0AL3wpdZ/5XkYIT/ezcwHUFaj3d3h7yU6z8kpEolxy0GY2WLA1YUluq7OiQUolcbyoq3/J8CcBxDjQ6tsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2967
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
V3->V4:
	* move register definition into flexcan_reg.
V4->V5:
	* use offsetof instead of cast
---
 drivers/net/can/flexcan.c | 51 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e86925134009..8e4c27d9e1b7 100644
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
@@ -292,7 +294,16 @@ struct flexcan_regs {
 	u32 rximr[64];		/* 0x880 - Not affected by Soft Reset */
 	u32 _reserved5[24];	/* 0x980 */
 	u32 gfwr_mx6;		/* 0x9e0 - MX6 */
-	u32 _reserved6[63];	/* 0x9e4 */
+	u32 _reserved6[39];	/* 0x9e4 */
+	u32 _rxfir[6];		/* 0xa80 */
+	u32 _reserved8[2];	/* 0xa98 */
+	u32 _rxmgmask;		/* 0xaa0 */
+	u32 _rxfgmask;		/* 0xaa4 */
+	u32 _rx14mask;		/* 0xaa8 */
+	u32 _rx15mask;		/* 0xaac */
+	u32 tx_smb[4];		/* 0xab0 */
+	u32 rx_smb0[4];		/* 0xac0 */
+	u32 rx_smb1[4];		/* 0xad0 */
 	u32 mecr;		/* 0xae0 */
 	u32 erriar;		/* 0xae4 */
 	u32 erridpr;		/* 0xae8 */
@@ -305,9 +316,13 @@ struct flexcan_regs {
 	u32 fdctrl;		/* 0xc00 - Not affected by Soft Reset */
 	u32 fdcbt;		/* 0xc04 - Not affected by Soft Reset */
 	u32 fdcrc;		/* 0xc08 */
+	u32 _reserved9[199];	/* 0xc0c */
+	u32 tx_smb_fd[18];	/* 0xf28 */
+	u32 rx_smb0_fd[18];	/* 0xf70 */
+	u32 rx_smb1_fd[18];	/* 0xfb8 */
 };
 
-static_assert(sizeof(struct flexcan_regs) == 0x4 + 0xc08);
+static_assert(sizeof(struct flexcan_regs) ==  0x4 * 18 + 0xfb8);
 
 struct flexcan_devtype_data {
 	u32 quirks;		/* quirks needed for different IP cores */
@@ -1292,6 +1307,35 @@ static void flexcan_set_bittiming(struct net_device *dev)
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
+	memset_io(&regs->mb[0][0], 0,
+		  offsetof(struct flexcan_regs, rx_smb1[3]) - offsetof(struct flexcan_regs, mb[0][0]) + 0x4);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		memset_io(&regs->tx_smb_fd[0], 0,
+			  offsetof(struct flexcan_regs, rx_smb1_fd[17]) - offsetof(struct flexcan_regs, tx_smb_fd[0]) + 0x4);
+
+	reg_ctrl2 &= ~FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+}
+
 /* flexcan_chip_start
  *
  * this functions is entered with clocks enabled
@@ -1316,6 +1360,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_ECC)
+		flexcan_init_ram(dev);
+
 	flexcan_set_bittiming(dev);
 
 	/* MCR
-- 
2.17.1

