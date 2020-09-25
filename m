Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6472627813F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgIYHKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:10:31 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:22663
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbgIYHKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:10:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGa/dVGF5Df0xcs0w6gB7T+XJQS2E/EbfA4wDQ/E7U83nfsJfGG0duuJ7T2GoeFYGLOqFq1aMioh71sLMGgH1Xm7T7uYBMrznEAgIEoSjS509k+UfemiFNZe/N+TTsMWyTMSTzpiatNmKcNoVEZlX4aTFkJdvJ491QIuOGi0ieYCqZuD3MUo6ozw9Ltp5idZemplqiIA08l7uvkEE5TJ80ja3IMAd+8CoSc1cBJfa1FuCTGgmXua6/eqV9EVH3HirO+0FZCNtzIIA9HP7oCRA6m4Y/XlbiNW5cbNEOo63orvd0D0asEsWV45gYcFEfEG+np8VdemPfZPNUNGDtHngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN8X8CaDGNmuvhcZ6eiPqwAJN/Xx4Zy0j63Fr4xiSSE=;
 b=LI1Az20esTmEWv3zqaW6Trqu94FBOq5MEio2JkrcH5P7Az8qORT/QIzVs5QAw2IRpfNeRP0pB5x6A2ZOwJugyREZC+B1zvbEWquX86n8CMXMK70WsSRxW6zYmKmdF+BEh8iJqnAfPLNAZmEqG6xh+Egu0DjadJN4meZs2ydWazmqL81q285bXD9talwgy97fcSX6Y30whJNx1wrAUMh0OW0NwV1LXYXf1aQqDPhmTzvj547nMEofTS/K4xXDq2gLjziBtCq166y0khNyj5UxjdK+SOZ0dnamzA1Q6Ta2XrLDhgF5A9jn1X/5mPlFGkGKT/8x56zM6K3SbPyNYbTu8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN8X8CaDGNmuvhcZ6eiPqwAJN/Xx4Zy0j63Fr4xiSSE=;
 b=q+6p6WO+x85R/hdHZXxykju1Vw4Dl7FjQQTsCVZfXqhsZp66GZJCZ7IGncZdG5GeAfI1cbELfTPTn7TSlvV86YUkJqQPwIeEXquE6uWZgcgWaY9mow1R7wdqZeWLONRIrzHJrHZu7EHR/xkTBkWzmU76RD539aTWXKCGjDDYakA=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 07:10:26 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:10:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all flexcan memory for ECC function
Date:   Fri, 25 Sep 2020 23:10:25 +0800
Message-Id: <20200925151028.11004-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0240.apcprd06.prod.outlook.com (2603:1096:4:ac::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 07:10:24 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1275d1e6-f024-4109-0390-08d8612213b2
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971974BDAAD8D2074F3685DE6360@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/fnKuQs2Rs/fwZPEMy3rsrdxo0lf4txQDbtqJgD3EyZMtGiTR0L2AHzPLPCTp9fnD86FHsipAfbSugce6hj/lmEhLkV+LFSCq47DkLEt/AcLy5vynPhCiof1+Ub3IbzBAJn3TFnTHm39cBavk3PxefhOj14mD8yEmkb00kaATsIS6oJM8YM6b9ONix79ZTzWQzPdGdtMp/UvDPoqxgjCgA7Sk5MrueRZ1Z7IAZxbJ7+810kenQB1EcKwTqg1/LjW7pqN5eoEJYdYkns1DACo4dTReC/IN8vgPymT3yf8p3vjZPhyLVzyWd5wToFomZyBNK6SMkPhn7Q5TnsFClT84i0MNSmmpmf4RJAeTKDCKYVF6TDGYqH5606gRA9JPx/SLAUBzpPXCqgcG16I+ZxxBYFjyncnGqXKZ6tviiBgGzdUombca57VOSDc3TyvlO9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(478600001)(6486002)(66556008)(956004)(2616005)(1076003)(66476007)(36756003)(16526019)(186003)(5660300002)(26005)(66946007)(69590400008)(316002)(8936002)(6506007)(4326008)(2906002)(86362001)(6512007)(83380400001)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VQwN31HBTJ9jb2xjOh7DsCq3eqL9Pu9jsE6WdUiUnPRy9wdu096ae98QB+ozVLDKWth4Oha3y3rkoUp761LSfMpBbEWo0u1hIT6qIhLZCNY2KXQ7zwj28Tk1rfbI51GoLtjT16x0Mg0aXSo4H+QTYkysVWJ4KAPKFPlCxw1prbLaxWrSgOg8qA7Esw5jFOz11N0q53LiQEqZC16mSwgGCVDDUEnGTtljW3ns6iOjBk9ddrFTBu95+3hUdJujpUYfnVTUX/I6ye9AM/nG4m/lWxTWl7oPidqGXh7hNDKKPUlKDYO3ioCIMfGmXs/HGIvKlwMj2vyvQPSUytUjbIKsrjy595RngAokjFV2gjLEDWiTJUGor/9sY3+JMPBghPP8otjS2MyyioY1YVSm2S30azB9f5AviSxDALgq/GV+IavobXtsj58kmslFGi+d08JOD5rRo7TKA81++aNegCcbudv7jm/5YrP06TT1VFmiNKD9fLwS4F65o26Jr+u+umxRRKLmWIwLyVTLhSZ0KPRAxQOz/EvrDkfDMPPn/GWvGDlXe0NCqbvnfGyTrK4BZQtrgjsKLCXvumezfDRP4/4nOQ/ANo5F3zMaHjyOUtRbv5mR0uwxeicrEpcB4kkWBii9/h1w0ujnBqYrEMiVrvYaQg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1275d1e6-f024-4109-0390-08d8612213b2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 07:10:26.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9SVUGx0xt/gHmM2zroqxdHXuLGeuMsc+xVRwTK1XatzEG7+ZY4cKqTPS1j289ecxk2u+qV3o+phxZ3RGy7biMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a NOTE at the section "Detection and correction of memory errors":
All FlexCAN memory must be initialized before starting its operation in
order to have the parity bits in memory properly updated. CTRL2[WRMFRZ]
grants write access to all memory positions that require initialization,
ranging from 0x080 to 0xADF and from 0xF28 to 0xFFF when the CAN FD feature
is enabled. The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers need to
be initialized as well. MCR[RFEN] must not be set during memory initialization.

Memory range from 0x080 to 0xADF, there are reserved memory (unimplemented
by hardware), these memory can be initialized or not.

Initialize all FlexCAN memory before accessing them, otherwise, memory
errors may be detected. The internal region cannot be initialized when
the hardware does not support ECC.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 92 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 286c67196592..f02f1de2bbca 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -292,7 +292,16 @@ struct flexcan_regs {
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
@@ -305,9 +314,13 @@ struct flexcan_regs {
 	u32 fdctrl;		/* 0xc00 - Not affected by Soft Reset */
 	u32 fdcbt;		/* 0xc04 - Not affected by Soft Reset */
 	u32 fdcrc;		/* 0xc08 */
+	u32 _reserved9[199];	/* 0xc0c */
+	u32 tx_smb_fd[18];	/* 0xf28 */
+	u32 rx_smb0_fd[18];	/* 0xf70 */
+	u32 rx_smb1_fd[18];	/* 0xfb8 */
 };
 
-static_assert(sizeof(struct flexcan_regs) == 0x4 + 0xc08);
+static_assert(sizeof(struct flexcan_regs) == 0x4 * 18 + 0xfb8);
 
 struct flexcan_devtype_data {
 	u32 quirks;		/* quirks needed for different IP cores */
@@ -1292,6 +1305,78 @@ static void flexcan_set_bittiming(struct net_device *dev)
 		return flexcan_set_bittiming_ctrl(dev);
 }
 
+static void flexcan_init_ram(struct net_device *dev)
+{
+	struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u32 reg_ctrl2;
+	int i, size;
+
+	/* CTRL2[WRMFRZ] grants write access to all memory positions that
+	 * require initialization. MCR[RFEN] must not be set during FlexCAN
+	 * memory initialization.
+	 */
+	reg_ctrl2 = priv->read(&regs->ctrl2);
+	reg_ctrl2 |= FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+
+	/* initialize MBs RAM */
+	size = sizeof(regs->mb) / sizeof(u32);
+	for (i = 0; i < size; i++)
+		priv->write(0, &regs->mb[0][0] + sizeof(u32) * i);
+
+	/* initialize RXIMRs RAM */
+	size = sizeof(regs->rximr) / sizeof(u32);
+	for (i = 0; i < size; i++)
+		priv->write(0, &regs->rximr[i]);
+
+	/* initialize RXFIRs RAM */
+	size = sizeof(regs->_rxfir) / sizeof(u32);
+	for (i = 0; i < size; i++)
+		priv->write(0, &regs->_rxfir[i]);
+
+	/* initialize RXMGMASK, RXFGMASK, RX14MASK, RX15MASK RAM */
+	priv->write(0, &regs->_rxmgmask);
+	priv->write(0, &regs->_rxfgmask);
+	priv->write(0, &regs->_rx14mask);
+	priv->write(0, &regs->_rx15mask);
+
+	/* initialize TX_SMB RAM */
+	size = sizeof(regs->tx_smb) / sizeof(u32);
+	for (i = 0; i < size; i++)
+		priv->write(0, &regs->tx_smb[i]);
+
+	/* initialize RX_SMB0 RAM */
+	size = sizeof(regs->rx_smb0) / sizeof(u32);
+	for (i = 0; i < size; i++)
+		priv->write(0, &regs->rx_smb0[i]);
+
+	/* initialize RX_SMB1 RAM */
+	size = sizeof(regs->rx_smb1) / sizeof(u32);
+	for (i = 0; i < size; i++)
+		priv->write(0, &regs->rx_smb1[i]);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+		/* initialize TX_SMB_FD RAM */
+		size = sizeof(regs->tx_smb_fd) / sizeof(u32);
+		for (i = 0; i < size; i++)
+			priv->write(0, &regs->tx_smb_fd[i]);
+
+		/* initialize RX_SMB0_FD RAM */
+		size = sizeof(regs->rx_smb0_fd) / sizeof(u32);
+		for (i = 0; i < size; i++)
+			priv->write(0, &regs->rx_smb0_fd[i]);
+
+		/* initialize RX_SMB1_FD RAM */
+		size = sizeof(regs->rx_smb1_fd) / sizeof(u32);
+		for (i = 0; i < size; i++)
+			priv->write(0, &regs->rx_smb0_fd[i]);
+	}
+
+	reg_ctrl2 &= ~FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+}
+
 /* flexcan_chip_start
  *
  * this functions is entered with clocks enabled
@@ -1316,6 +1401,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR)
+		flexcan_init_ram(dev);
+
 	flexcan_set_bittiming(dev);
 
 	/* MCR
-- 
2.17.1

