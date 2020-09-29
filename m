Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69FD27CBE1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgI2Maq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:30:46 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:56315
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729378AbgI2Mai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:30:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWZjFGFpKdeKT0PBcRVikVjd2e6GdgMVhkSfpFtS1+TPcXCJ+RKvyz8FG7p6vkCdYh6RCKC2TM4BfsgF3CEH+s/Vuh1BPq8bMACkMK+HfEkIhkhbOEPCGcWOnQOYNnKeazSZxFAje4T+hzNoyzshItv3y2hA0HRfmOIwpw3QWIAKg3HmsShWBhgAmyAM+MzdjyPjfq+GyYW91YHSFQ5Z6Lq0Ef0YZUMwNERQuYTU9JrB8LRdMjQn8Tqfpm945ikkr0kWs+xbpUSFKG/Bc0Rn5eHrJchg6cL4biGFkMn1f97X9F2BgaP9oGDAD0SKKh+XHlHgQHWK83qxfWmAB27S5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1jGA/Rug499M3GnXMIpUE9D2bJ6FU648/0Ho1zGd/s=;
 b=L5VmVQ4zNZCAj2cd8XNzm9VQpSwWEA5bxWVQF4vdvHQOj0sn+4DoUheFFYDXN2JD9OmfuqzoYEH5/1K2KzfWW0iE2yA/A+aiUg65end/p6xQlkvZYOgbnAVqZL64sPDYwXJ1Reha39Dx12yPOnaIY3pQGeuhNhV+WosL1AhLg6AGu8wBg0/zXUbnodN5ZFwEhBfCUHW+OOWY+uFK6/+LMAgtQsQzZ3gSMRUDaeN5iSCTsEzKhfUIJen4fVgkQ82lM+BZhxm5g77x0WQln9PVTt5KNXlqUgcGlGE9eYu6sk9kuvwS0+vjQBsSpwx4wRcDy7X57Qccy918m+ndPq2WiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1jGA/Rug499M3GnXMIpUE9D2bJ6FU648/0Ho1zGd/s=;
 b=JSrY26Tg4lHyD4Ma44iHLBJpdAXERHW4E+BmORKkAMOw7di45jqYxf8NC+PWu9UsYVZjkTnicNITZfsjUjrTLnGyP8m2oVtT/Dh1lmaV/z+fQJDDS7rCVwg4n5THB8Yet1xw1x10R4JeLSRdkQJHb437jGYt8Im0Vv/5ap3YvDI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4778.eurprd04.prod.outlook.com (2603:10a6:10:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 12:30:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 12:30:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 1/3] can: flexcan: initialize all flexcan memory for ECC function
Date:   Wed, 30 Sep 2020 04:30:39 +0800
Message-Id: <20200929203041.29758-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
References: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0063.apcprd02.prod.outlook.com (2603:1096:4:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24 via Frontend Transport; Tue, 29 Sep 2020 12:30:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27c3307e-f36d-4a7a-dea5-08d864737435
X-MS-TrafficTypeDiagnostic: DB7PR04MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB477830AA46B6F5E99252F5B2E6320@DB7PR04MB4778.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ZKXX7zKKX64uzCJJxSXjP6pvPKVyHwYZrA75pv5QkdoEIucEBle8fy9AAepqrmE9cH2UuGDACikCu5gx+GE4AK/6vJCPL//bFqn9VgkjvR10wmri2zcXPZHXx/EI8+PQjXKqlJPpjnMbyd8GQaMCuIn+rQIUIJHTCSyk0mli7Cn3cAoLYQIZgv0ohyzOAQLVUh9AGAsi0MvPRqBZF7bJmtQk/WC+Uod1lmiD8xgeVkjvtMv6u9033a58wDPX0WbaekmSmHfYB4/woKggBihyL3bqYh5kLV5YI+fcwVYrdeEIS4Pbg267f9pTcX9ZUlbuuqlJ44tl75Om0bDcE2l/Vtdba1+H8zS+mUPLGIC0w5IuCEVx/3LH98/n3toxEwd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(5660300002)(36756003)(52116002)(6512007)(69590400008)(8936002)(498600001)(2906002)(4326008)(2616005)(956004)(16526019)(186003)(66556008)(66476007)(66946007)(26005)(86362001)(6486002)(8676002)(1076003)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gwb1yrHzxcodBLG5+ERinZ3JF2FSdS7QTnguq6XTRqTsdcoSEUvK65iY8Dwk6Fa8mgG5QERHRH4gGFJivach5v9xtDUP1xKjYKIUpR1sJnp01qwIu0foFjrhOC8z4pIP21ov+elXMiApD1hj+srnv+vAs0ZSvXuAQ+f8/okuCdhAUXNOaSRdDIoZyQ2dAu46L6U5QIklO88rtaiqrtVT9+4DYV5dsilJLhmuNh9XUHgB3wLSzDiYiQDSD24/VCjAWcCb9XhmVNG5tSuxzsU46sKSi+YlTJNgXXCTq7vUIm/acJ1sp8Pjw+dQjfNJyz5stsAfxZESXcnuu3dG0PQOJ9AQrFWEPBL5ZDf0ZWaSr1du8ONWYCxaAl9xlDxorD0ykEzxDuAjjuzzFf+5Ou4vp7FcEFTsvDosUPJrANiwasIuYOwL6iIdK3Z3qgP8g9t59IKBSPOrh1/juQdsbtB8cY+fjM1oOGEFjGtp6RaCMTtafo1Jb4teEQ6Z9FPSM48LUQM51TexOOmkWjEk8SRgXm9krNMPqU6x3XC+AB0S5PtMT9Bt6TP58FKnLfU8ChSfKFM0ue56qfzMElDRcDeiq4BltfbGot4fgHuxnnwmkptSDyz/7T+NGaQ4YcSv4huncahuB9n1Dk7tvOrRP/wtuw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c3307e-f36d-4a7a-dea5-08d864737435
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 12:30:30.8889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +tf6ProF6exvdbOmup8jyHC6aH26DnQTBSAVqZ3Odyxn3lmW3gQT3cBHTog2NVat4YXHMWJUsj/3SMvRuzUo0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4778
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
---
 drivers/net/can/flexcan.c | 51 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e86925134009..ede25db42e87 100644
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
+		  (u8 *)&regs->rx_smb1[3] - &regs->mb[0][0] + 0x4);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		memset_io(&regs->tx_smb_fd[0], 0,
+			  (u8 *)&regs->rx_smb1_fd[17] - (u8 *)&regs->tx_smb_fd[0] + 0x4);
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

