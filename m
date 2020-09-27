Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4C8279F7A
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgI0IH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:07:59 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:61957
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730358AbgI0IH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:07:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gryz/iAXFE2wzMrld8yM8NmAXlxtvu5KZM03iu/VmGil+HQhaGqxUjqp93MGB9KBvEItmEBIjTe+Cl+LvSDpmmSdmoZBvJ5Lnwvti5gpTKyKVyidt40BfxTljmhitjWLb+kLttC+coL+HNbn6HzofK+6PVAWUdu1lPnrPtiMP/dlvtKGQiFJ/8E7OESdm+OUGuo+37HPR+Zu0ogx445boRgAvWU0Q9nipgiJ0edx2EM/4V2HMERBw8goZL6drzCudIVtAPVRoLoAGuTRfubL7X5Ia+v5dPZoXrUB3KALrPOvmkmQcNIioo8fQVegBwtFF9l4pBc9X58LbG28h3m7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTbtTu/8cQIUeSHoYbNh3Q/39S8DBuZsEbmdxyE8TNI=;
 b=fscy6peV7vRWmWCfYUUQSsa4Mi1pOBKRL41GTqcTW9Zis4KmuM1f2vGTJM96qrER5Qvt1TDyvi2WiNOTRZK5Ma/PSC7aNEo9gTM6HYOlC8tZCNS6HXs6y0i8yKVDi6ZtW5j2ufiQsL85NLYYSEOuMHmi4MhSUtHFNnMmg/xgF+pAkMtbQhCqM1pP5R5PCf59BftgRN6tQpjxNwC9HgrpLit/Dv/rDdAqR/eJ80Xjg2+jbQp4KuAF7Rl0uDJTjQrv0/8tlvQm2cfCWvSCUIiAjid9p4Tu6i/PxWgRrVHgnpH620k6khRIAeZUnpwRLX7OFbAzoF2m25+VaM8OcH24kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTbtTu/8cQIUeSHoYbNh3Q/39S8DBuZsEbmdxyE8TNI=;
 b=LwOe63CN+uibdp3soyLd9Yo19r0e+w1CDgRG5pF+BHJzdHibtbruQUxHZvWIn4+UhGL7Uv8e+e/xhQaWrHTPE8Kw17BOnvGB9hOMtBS/C52UECRA4vdCuNxh0wXRWGaLP1wm0zbpC4Cec2igY0mdjWPCYz4k8td4FcfQmcA04TA=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Sun, 27 Sep
 2020 08:07:55 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 08:07:55 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH V2 1/3] can: flexcan: initialize all flexcan memory for ECC function
Date:   Mon, 28 Sep 2020 00:07:59 +0800
Message-Id: <20200927160801.28569-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
References: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0012.apcprd04.prod.outlook.com
 (2603:1096:3:1::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0401CA0012.apcprd04.prod.outlook.com (2603:1096:3:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sun, 27 Sep 2020 08:07:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dfd08f06-a9e0-47d1-674d-08d862bc7032
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4953A48B47F267E9F1156DCAE6340@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: obDGq/hzfYfNRTzUwwJoYpOqjVo/tesOxdndEupVMLkAIX1IXm3x56Y43rKhGjsPH2LC0eueAN1lnlQ4ktXAmMR+qKXF83l6OnzLLFwIHiwxUaZR1BnEF2Zdu8N80L6ttJ8Al6UajaiO8NtnTEAAMvUojxmrF0nBx00HakzrFTrafpqB7HVo3jybZrA8jBL5rE1WVsnmJPPoGFyBmgJWhwNa7zpcisw9ZgyCxchW6Aa/hDtPssOC+8GM3eH6EY+Kh/2kMKKH5to7EbLRSaZnf1FgDZ8Hh/T7IPssg2gOBrndZSVfJBpJBdP3nupvxx9F9XodMSpSnd4Li1kCffqN/54vjNydqcfflLslak5ievBCKMXX5yFTxHMRVfTMCzSQ+G2CDhNAbU90k3iwpbRXmi9J6Swi+qxpZPoRQJeKq7D+bl9++yeTn4VWG/PhOcLD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39850400004)(366004)(396003)(4326008)(2616005)(2906002)(69590400008)(66556008)(66946007)(66476007)(5660300002)(16526019)(36756003)(186003)(26005)(6512007)(83380400001)(86362001)(6506007)(8676002)(6486002)(478600001)(8936002)(52116002)(1076003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k/Bssyc14eAJRjXVvKZZItZktd9W5uK+NTL7JTGeYgCdHxhxBUtQv9Tw0a9jNAr2txMmFie7vRo4rxqV2i/31D1NO5jQwqh9cnflcoBBl/DI9/FuC0FupesQO2/InnAN1okInBKVB3fTK3tvSUYSkdgyA+rm4ks76ekKxGi38VYEATx7ilKOK76to3fo/booR/XgMhUrc0hrngI7r79hHvxilrXsNnbExQCL7zpcWY2SJ7Q6cYbDpoHRqUfRWLtkO7YNJ6jnJcmmXHeU0/TfTdkYtDe7vUlEfmx1+DvysdXv7ApiywFriF3CX03uQIOeq4W74MTYa7Ym1ES4kniXJxpR3yY49w744p8F7j4PudkvslRSLR74ZhlUxw7bl6d87zyGtq3vw+fTdrQ4ko0aPLoT3hdUpGEoi5Wy7FnwpuPDanfyuRA+0QxZtfR3WBxZaznCPQhBoJ4Nk6VJ++gfbFYCYG1eFPDx9ouL+tWixSNq+Y+JW6A6WMojzWK9HJ3bDf65x0yXPhCWV0YFVQI1tCO38uAOTj3TRj7jMEV+h02h7+xTU0JOtG/elkPqbjTVozaCDGdxatSJqEppliKoT48dT5y035Sqv3bQY8BtqRX020/aGeOF02q8SvYQ0Xrn02mDNNpjXoGIQAtiM4Hp3g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd08f06-a9e0-47d1-674d-08d862bc7032
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2020 08:07:55.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzb9zUg8KHppV2zbB3j4c0Q7yAGR5LRGhjnBS9hUFPLYEYalOybzTNXWFOkWgl2/nCM/lkKw2UmDiCe3Zxbg/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
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
disable non-correctable errors interrupt and freeze mode. Initialize all
FlexCAN memory before accessing them, at least it can avoid non-correctable
errors detected due to memory uninitialized. The internal region can't be
initialized when the hardware doesn't support ECC.

According to IMX8MPRM, Rev.C, 04/2020. There is a NOTE at the section
"11.8.3.13 Detection and correction of memory errors":
All FlexCAN memory must be initialized before starting its operation in
order to have the parity bits in memory properly updated. CTRL2[WRMFRZ]
grants write access to all memory positions that require initialization,
ranging from 0x080 to 0xADF and from 0xF28 to 0xFFF when the CAN FD feature
is enabled. The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers need to
be initialized as well. MCR[RFEN] must not be set during memory initialization.

Memory range from 0x080 to 0xADF, there are reserved memory (unimplemented
by hardware, e.g. only configure 64 MBs), these memory can be initialized or not.
In this patch, initialize all flexcan memory which includes reserved memory.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* update commit messages, add a datasheet reference.
	* initialize block memory instead of trivial memory.
	* inilialize reserved memory.
---
 drivers/net/can/flexcan.c | 67 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e86925134009..aca0fc40ae9b 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -309,6 +309,40 @@ struct flexcan_regs {
 
 static_assert(sizeof(struct flexcan_regs) == 0x4 + 0xc08);
 
+/* Structure of memory need be initialized for ECC feature */
+static const struct flexcan_ram_int {
+	u32 offset;
+	u16 len;
+} ram_init[] = {
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
+	{
+		.offset = 0x80,
+		.len = (0xadf - 0x80) / sizeof(u32) + 1,
+	},
+	/* ranging from 0x0F28 to 0x0FFF when CAN FD feature is enabled,
+	 * ram details as below list:
+	 * 0x0F28--0x0F6F:	TX_SMB_FD
+	 * 0x0F70--0x0FB7:	RX_SMB0_FD
+	 * 0x0FB8--0x0FFF:	RX_SMB0_FD
+	 */
+	{
+		.offset = 0xf28,
+		.len = (0xfff - 0xf28) / sizeof(u32) + 1,
+	},
+};
+
 struct flexcan_devtype_data {
 	u32 quirks;		/* quirks needed for different IP cores */
 };
@@ -1292,6 +1326,36 @@ static void flexcan_set_bittiming(struct net_device *dev)
 		return flexcan_set_bittiming_ctrl(dev);
 }
 
+static void flexcan_init_ram(struct net_device *dev)
+{
+	struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u32 reg_ctrl2;
+	int i;
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
+	for (i = 0; i < ram_init[0].len; i++)
+		priv->write(0, (void __iomem *)regs + ram_init[0].offset + sizeof(u32) * i);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		for (i = 0; i < ram_init[1].len; i++)
+			priv->write(0, (void __iomem *)regs + ram_init[1].offset + sizeof(u32) * i);
+
+	reg_ctrl2 &= ~FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+}
+
 /* flexcan_chip_start
  *
  * this functions is entered with clocks enabled
@@ -1316,6 +1380,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR)
+		flexcan_init_ram(dev);
+
 	flexcan_set_bittiming(dev);
 
 	/* MCR
-- 
2.17.1

