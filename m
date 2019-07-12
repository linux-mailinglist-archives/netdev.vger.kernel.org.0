Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6B66681F
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfGLIDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:03:02 -0400
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:52706
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726264AbfGLIDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:03:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InXIgcjFUdzCSBjnOpPLftqxfUl9Au5Bagppn2k4K6EZAsOgcBdUlHnkaLck5Uomln/N7wUs4F7SfqRQNR8zg8hRooZxOjOyqtLFfkcLF+471JKmzjHRR/Kch5hmOqbaVNGCai3sgxdC2kCENEp8udMgp0YxZJVrXqSkFmmp3UAKutZc4xDPqNCyM6jSPrqeVRalh9wMQw45/6gI7+j4SjpVxbAi+6atdooR37j59I5x/ZW906gvr5JSUfsUAiQCSVi4ifL3hRNUIGJL4N/84C0qpp01WaDCQJoPoDBM5aKZDyHyisRsigiZ6qSUQlG7M6l+N2dcmEKOXPjEwB7iog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaF+kvZB2aW38CbUy3ltyFHbVPONlw05lzL4ZeYAxFY=;
 b=Bk3kzqn2PgbhHf346hak3x+tLM3x1de8E3sDb3CbDFk1mFcboNrS1LFXMqFUFFLJ2PRmBZcIvjleue1JFoenvW3C3N8w09jbqwdCRy8PtSPj1nKnUcf1R0xDYzxmgT/riu0pW/SbRH7fDPDlRj9mu2FQI66UGJcMskSejQ20ucModLSao0cDKWzse8N4xEd8mI5LTvcaQDiUY2n4+CHAJEl8kLWcvnaVurJSLQ5hRwOHPYSdA+UwTT0EVHkE+5yrsFMti8DeEt5aHpcFiiMB0I8iZsTRc+m2LY1g4aCV8TPdp0t+InWPLaZ5vaednZKUWWjIMGgYVXKv3qHRUGUlJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaF+kvZB2aW38CbUy3ltyFHbVPONlw05lzL4ZeYAxFY=;
 b=HVtJkZI99/o+lOmzJsRwfhDL4mYcFWuc0Dq2WfTNPrjBXOhD0u64Vftsuz/mrERkSONxefvCHw5ReCXsdg8+FpkRg0dXTXdS7o08cn5aHmw1NssZfkiXilFivRYbbV04QOkvucL0/Lmqj8tT2opd0A5d0A0XLAoL9pQHR5uKE2Y=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:44 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:44 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 3/8] can: flexcan: add CAN FD mode support
Thread-Topic: [PATCH 3/8] can: flexcan: add CAN FD mode support
Thread-Index: AQHVOIgvT1wj7sZWnESL7zqtJbNCtg==
Date:   Fri, 12 Jul 2019 08:02:44 +0000
Message-ID: <20190712075926.7357-4-qiangqing.zhang@nxp.com>
References: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75ca89d1-f126-4a0d-1f3a-08d7069f51f3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4889;
x-ms-traffictypediagnostic: DB7PR04MB4889:
x-microsoft-antispam-prvs: <DB7PR04MB48895B0AA2F32777B83205ABE6F20@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(50226002)(66066001)(2906002)(71190400001)(2616005)(476003)(71200400001)(30864003)(8936002)(11346002)(25786009)(446003)(1076003)(478600001)(53936002)(305945005)(2501003)(14454004)(486006)(7736002)(6512007)(36756003)(52116002)(76176011)(8676002)(99286004)(102836004)(86362001)(256004)(5660300002)(14444005)(81156014)(81166006)(26005)(64756008)(66556008)(66446008)(66476007)(386003)(6506007)(66946007)(3846002)(110136005)(4326008)(6116002)(54906003)(186003)(316002)(6486002)(68736007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qPNmVS7ckDyNg0X3JaAoZ16TC3wlLhidqgvtjquKnj8WZ+gd9lSvh0uFldKXYv84YYpcIquN/0UOU0d6zWNCuLcaWUDP6G7R+fb6g2vWNgF+/sLpHDi75xy/NX9s+ni7qDgKLdZdE/6udiIIz+Fil3u5vNo/+4fIobBARWfwumecsM8M6h2iJ1I2Mhg8AD3B7mUNwGB84rRcJx9MAHxhBzU/2hWj989In+BiD/pNm/DxoK3Tp7D+xxei/lo+mz08uPEJUPPdDBK2z9Waa0T9d3V828DjprQRmHbAodyXy5twL/dahk+2++Wax10oMhqeQPN/ozpElXCt41G+lp1sTbNONAN+j4Suh0uAlkBhd1shAEsXemru1VlmgKUGsIUclAoc8UKRev8Os8zk+6Ugk5Hj4qruyYRZdnKk9dUOqgQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ca89d1-f126-4a0d-1f3a-08d7069f51f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:44.3597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add CAN FD mode support in driver, it means that
payload size can extend up to 64 bytes.

Bit timing always set in CBT register other than CTRL1 register when CANFD
supports BRS, it will extend the range of all CAN bit timing variables
(PRESDIV, PROPSEG, PSEG1, PSEG2 and RJW), which will improve the bit
timing accuracy.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 255 +++++++++++++++++++++++++++++++++-----
 1 file changed, 225 insertions(+), 30 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 5b0a159daa38..23e9407e33ff 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -52,6 +52,7 @@
 #define FLEXCAN_MCR_IRMQ		BIT(16)
 #define FLEXCAN_MCR_LPRIO_EN		BIT(13)
 #define FLEXCAN_MCR_AEN			BIT(12)
+#define FLEXCAN_MCR_FDEN		BIT(11)
 /* MCR_MAXMB: maximum used MBs is MAXMB + 1 */
 #define FLEXCAN_MCR_MAXMB(x)		((x) & 0x7f)
 #define FLEXCAN_MCR_IDAM_A		(0x0 << 8)
@@ -137,6 +138,26 @@
 	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT | \
 	 FLEXCAN_ESR_WAK_INT)
=20
+/* FLEXCAN Bit Timing register (CBT) bits */
+#define FLEXCAN_CBT_BTF		        BIT(31)
+#define FLEXCAN_CBT_EPRESDIV(x)	        (((x) & 0x3ff) << 21)
+#define FLEXCAN_CBT_ERJW(x)		(((x) & 0x1f) << 16)
+#define FLEXCAN_CBT_EPROPSEG(x)	        (((x) & 0x3f) << 10)
+#define FLEXCAN_CBT_EPSEG1(x)		(((x) & 0x1f) << 5)
+#define FLEXCAN_CBT_EPSEG2(x)		((x) & 0x1f)
+
+/* FLEXCAN FD control register (FDCTRL) bits */
+#define FLEXCAN_FDCTRL_FDRATE		BIT(31)
+#define FLEXCAN_FDCTRL_MBDSR1(x)	(((x) & 0x3) << 19)
+#define FLEXCAN_FDCTRL_MBDSR0(x)	(((x) & 0x3) << 16)
+
+/* FLEXCAN FD Bit Timing register (FDCBT) bits */
+#define FLEXCAN_FDCBT_FPRESDIV(x)	(((x) & 0x3ff) << 20)
+#define FLEXCAN_FDCBT_FRJW(x)		(((x) & 0x07) << 16)
+#define FLEXCAN_FDCBT_FPROPSEG(x)	(((x) & 0x1f) << 10)
+#define FLEXCAN_FDCBT_FPSEG1(x)		(((x) & 0x07) << 5)
+#define FLEXCAN_FDCBT_FPSEG2(x)		((x) & 0x07)
+
 /* FLEXCAN interrupt flag register (IFLAG) bits */
 /* Errata ERR005829 step7: Reserve first valid MB */
 #define FLEXCAN_TX_MB_RESERVED_OFF_FIFO		8
@@ -148,6 +169,10 @@
 #define FLEXCAN_IFLAG_RX_FIFO_AVAILABLE	BIT(5)
=20
 /* FLEXCAN message buffers */
+#define FLEXCAN_MB_CNT_EDL		BIT(31)
+#define FLEXCAN_MB_CNT_BRS		BIT(30)
+#define FLEXCAN_MB_CNT_ESI		BIT(29)
+
 #define FLEXCAN_MB_CODE_MASK		(0xf << 24)
 #define FLEXCAN_MB_CODE_RX_BUSY_BIT	(0x1 << 24)
 #define FLEXCAN_MB_CODE_RX_INACTIVE	(0x0 << 24)
@@ -192,6 +217,7 @@
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE	BIT(6) /* No interrupt for error p=
assive */
 #define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN	BIT(7) /* default to BE register =
access */
 #define FLEXCAN_QUIRK_SETUP_STOP_MODE		BIT(8) /* Setup stop mode to suppor=
t wakeup */
+#define FLEXCAN_QUIRK_TIMESTAMP_SUPPORT_FD	BIT(9) /* Use timestamp then su=
pport can fd mode */
=20
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -225,7 +251,8 @@ struct flexcan_regs {
 	u32 crcr;		/* 0x44 */
 	u32 rxfgmask;		/* 0x48 */
 	u32 rxfir;		/* 0x4c */
-	u32 _reserved3[12];	/* 0x50 */
+	u32 cbt;                /* 0x50 */
+	u32 _reserved3[11];     /* 0x54 */
 	u8 mb[2][512];		/* 0x80 */
 	/* FIFO-mode:
 	 *			MB
@@ -250,6 +277,9 @@ struct flexcan_regs {
 	u32 rerrdr;		/* 0xaf4 */
 	u32 rerrsynr;		/* 0xaf8 */
 	u32 errsr;		/* 0xafc */
+	u32 _reserved7[64];     /* 0xb00 */
+	u32 fdctrl;             /* 0xc00 */
+	u32 fdcbt;              /* 0xc04 */
 };
=20
 struct flexcan_devtype_data {
@@ -337,6 +367,30 @@ static const struct can_bittiming_const flexcan_bittim=
ing_const =3D {
 	.brp_inc =3D 1,
 };
=20
+static const struct can_bittiming_const flexcan_fd_bittiming_const =3D {
+	.name =3D DRV_NAME,
+	.tseg1_min =3D 2,
+	.tseg1_max =3D 96,
+	.tseg2_min =3D 2,
+	.tseg2_max =3D 32,
+	.sjw_max =3D 16,
+	.brp_min =3D 1,
+	.brp_max =3D 1024,
+	.brp_inc =3D 1,
+};
+
+static const struct can_bittiming_const flexcan_fd_data_bittiming_const =
=3D {
+	.name =3D DRV_NAME,
+	.tseg1_min =3D 2,
+	.tseg1_max =3D 39,
+	.tseg2_min =3D 2,
+	.tseg2_max =3D 8,
+	.sjw_max =3D 4,
+	.brp_min =3D 1,
+	.brp_max =3D 1024,
+	.brp_inc =3D 1,
+};
+
 /* FlexCAN module is essentially modelled as a little-endian IP in most
  * SoCs, i.e the registers as well as the message buffer areas are
  * implemented in a little-endian fashion.
@@ -612,7 +666,7 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *s=
kb, struct net_device *de
 	struct canfd_frame *cfd =3D (struct canfd_frame *)skb->data;
 	u32 can_id;
 	u32 data;
-	u32 ctrl =3D FLEXCAN_MB_CODE_TX_DATA | (cfd->len << 16);
+	u32 ctrl =3D FLEXCAN_MB_CODE_TX_DATA | ((can_len2dlc(cfd->len)) << 16);
 	int i;
=20
 	if (can_dropped_invalid_skb(dev, skb))
@@ -630,6 +684,9 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *s=
kb, struct net_device *de
 	if (cfd->can_id & CAN_RTR_FLAG)
 		ctrl |=3D FLEXCAN_MB_CNT_RTR;
=20
+	if (can_is_canfd_skb(skb))
+		ctrl |=3D FLEXCAN_MB_CNT_EDL;
+
 	for (i =3D 0; i < cfd->len; i +=3D sizeof(u32)) {
 		data =3D be32_to_cpup((__be32 *)&cfd->data[i]);
 		priv->write(data, &priv->tx_mb->data[i / sizeof(u32)]);
@@ -828,8 +885,14 @@ static unsigned int flexcan_mailbox_read(struct can_rx=
_offload *offload, bool dr
 		reg_ctrl =3D priv->read(&mb->can_ctrl);
 	}
=20
-	if (!drop)
-		*skb =3D alloc_can_skb(offload->dev, (struct can_frame **)&cfd);
+
+	if (!drop) {
+		if (reg_ctrl & FLEXCAN_MB_CNT_EDL)
+			*skb =3D alloc_canfd_skb(offload->dev, &cfd);
+		else
+			*skb =3D alloc_can_skb(offload->dev,
+					     (struct can_frame **)&cfd);
+	}
=20
 	if (*skb && cfd) {
 		/* increase timstamp to full 32 bit */
@@ -841,9 +904,20 @@ static unsigned int flexcan_mailbox_read(struct can_rx=
_offload *offload, bool dr
 		else
 			cfd->can_id =3D (reg_id >> 18) & CAN_SFF_MASK;
=20
-		if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
-			cfd->can_id |=3D CAN_RTR_FLAG;
-		cfd->len =3D get_can_dlc((reg_ctrl >> 16) & 0x0F);
+
+		if (reg_ctrl & FLEXCAN_MB_CNT_EDL) {
+			cfd->len =3D can_dlc2len(get_canfd_dlc((reg_ctrl >> 16) & 0x0F));
+		} else {
+			cfd->len =3D get_can_dlc((reg_ctrl >> 16) & 0x0F);
+
+			if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
+				cfd->can_id |=3D CAN_RTR_FLAG;
+		}
+
+		if (reg_ctrl & FLEXCAN_MB_CNT_ESI) {
+			cfd->flags |=3D CANFD_ESI;
+			netdev_warn(priv->can.dev, "ESI Error\n");
+		}
=20
 		for (i =3D 0; i < cfd->len; i +=3D sizeof(u32)) {
 			__be32 data =3D cpu_to_be32(priv->read(&mb->data[i / sizeof(u32)]));
@@ -989,27 +1063,14 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id=
)
=20
 static void flexcan_set_bittiming(struct net_device *dev)
 {
-	const struct flexcan_priv *priv =3D netdev_priv(dev);
-	const struct can_bittiming *bt =3D &priv->can.bittiming;
+	struct flexcan_priv *priv =3D netdev_priv(dev);
+	struct can_bittiming *bt =3D &priv->can.bittiming;
+	struct can_bittiming *dbt =3D &priv->can.data_bittiming;
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	u32 reg;
+	u32 reg, reg_cbt, reg_fdcbt;
=20
 	reg =3D priv->read(&regs->ctrl);
-	reg &=3D ~(FLEXCAN_CTRL_PRESDIV(0xff) |
-		 FLEXCAN_CTRL_RJW(0x3) |
-		 FLEXCAN_CTRL_PSEG1(0x7) |
-		 FLEXCAN_CTRL_PSEG2(0x7) |
-		 FLEXCAN_CTRL_PROPSEG(0x7) |
-		 FLEXCAN_CTRL_LPB |
-		 FLEXCAN_CTRL_SMP |
-		 FLEXCAN_CTRL_LOM);
-
-	reg |=3D FLEXCAN_CTRL_PRESDIV(bt->brp - 1) |
-		FLEXCAN_CTRL_PSEG1(bt->phase_seg1 - 1) |
-		FLEXCAN_CTRL_PSEG2(bt->phase_seg2 - 1) |
-		FLEXCAN_CTRL_RJW(bt->sjw - 1) |
-		FLEXCAN_CTRL_PROPSEG(bt->prop_seg - 1);
-
+	reg &=3D ~(FLEXCAN_CTRL_LPB | FLEXCAN_CTRL_SMP | FLEXCAN_CTRL_LOM);
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
 		reg |=3D FLEXCAN_CTRL_LPB;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
@@ -1020,9 +1081,102 @@ static void flexcan_set_bittiming(struct net_device=
 *dev)
 	netdev_dbg(dev, "writing ctrl=3D0x%08x\n", reg);
 	priv->write(reg, &regs->ctrl);
=20
-	/* print chip status */
-	netdev_dbg(dev, "%s: mcr=3D0x%08x ctrl=3D0x%08x\n", __func__,
-		   priv->read(&regs->mcr), priv->read(&regs->ctrl));
+	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
+		reg_cbt =3D priv->read(&regs->cbt);
+		reg_cbt &=3D ~(FLEXCAN_CBT_EPRESDIV(0x3ff) |
+			     FLEXCAN_CBT_EPSEG1(0x1f) |
+			     FLEXCAN_CBT_EPSEG2(0x1f) |
+			     FLEXCAN_CBT_ERJW(0x1f) |
+			     FLEXCAN_CBT_EPROPSEG(0x3f) |
+			     FLEXCAN_CBT_BTF);
+
+		/* CBT[EPSEG1] is 5 bit long and CBT[EPROPSEG] is 6 bit long.
+		 * The can_calc_bittiming tries to divide the tseg1 equally
+		 * between phase_seg1 and prop_seg, which may not fit in CBT
+		 * register. Therefore, if phase_seg1 is more than possible
+		 * value, increase prop_seg and decrease phase_seg1
+		 */
+		if (bt->phase_seg1 > 0x20) {
+			bt->prop_seg +=3D (bt->phase_seg1 - 0x20);
+			bt->phase_seg1 =3D 0x20;
+		}
+
+		reg_cbt =3D FLEXCAN_CBT_EPRESDIV(bt->brp - 1) |
+				FLEXCAN_CBT_EPSEG1(bt->phase_seg1 - 1) |
+				FLEXCAN_CBT_EPSEG2(bt->phase_seg2 - 1) |
+				FLEXCAN_CBT_ERJW(bt->sjw - 1) |
+				FLEXCAN_CBT_EPROPSEG(bt->prop_seg - 1) |
+				FLEXCAN_CBT_BTF;
+		priv->write(reg_cbt, &regs->cbt);
+
+		netdev_dbg(dev, "bt: prediv %d seg1 %d seg2 %d rjw %d propseg %d\n",
+			   bt->brp - 1, bt->phase_seg1 - 1, bt->phase_seg2 - 1,
+			   bt->sjw - 1, bt->prop_seg - 1);
+
+		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+			reg_fdcbt =3D priv->read(&regs->fdcbt);
+			reg_fdcbt &=3D ~(FLEXCAN_FDCBT_FPRESDIV(0x3ff) |
+				       FLEXCAN_FDCBT_FPSEG1(0x07) |
+				       FLEXCAN_FDCBT_FPSEG2(0x07) |
+				       FLEXCAN_FDCBT_FRJW(0x07) |
+				       FLEXCAN_FDCBT_FPROPSEG(0x1f));
+
+			/* FDCBT[FPSEG1] is 3 bit long and FDCBT[FPROPSEG] is 5 bit long.
+			 * The can_calc_bittiming tries to divide the tseg1 equally
+			 * between phase_seg1 and prop_seg, which may not fit in FDCBT
+			 * register. Therefore, if phase_seg1 is more than possible
+			 * value, increase prop_seg and decrease phase_seg1
+			 */
+			if (dbt->phase_seg1 > 0x8) {
+				dbt->prop_seg +=3D (dbt->phase_seg1 - 0x8);
+				dbt->phase_seg1 =3D 0x8;
+			}
+
+			reg_fdcbt =3D FLEXCAN_FDCBT_FPRESDIV(dbt->brp - 1) |
+					FLEXCAN_FDCBT_FPSEG1(dbt->phase_seg1 - 1) |
+					FLEXCAN_FDCBT_FPSEG2(dbt->phase_seg2 - 1) |
+					FLEXCAN_FDCBT_FRJW(dbt->sjw - 1) |
+					FLEXCAN_FDCBT_FPROPSEG(dbt->prop_seg);
+			priv->write(reg_fdcbt, &regs->fdcbt);
+
+			if (bt->brp !=3D dbt->brp)
+				netdev_warn(dev, "Warning!! data brp =3D %d and brp =3D %d don't match=
.\n"
+					    "flexcan may not work. consider using different bitrate or data b=
itrate\n",
+					    dbt->brp, bt->brp);
+
+			netdev_dbg(dev, "fdbt: prediv %d seg1 %d seg2 %d rjw %d propseg %d\n",
+				   dbt->brp - 1, dbt->phase_seg1 - 1, dbt->phase_seg2 - 1,
+				   dbt->sjw - 1, dbt->prop_seg);
+
+			netdev_dbg(dev, "%s: mcr=3D0x%08x ctrl=3D0x%08x cbt=3D0x%08x fdcbt=3D0x=
%08x\n",
+				   __func__, priv->read(&regs->mcr),
+				   priv->read(&regs->ctrl),
+				   priv->read(&regs->cbt),
+				   priv->read(&regs->fdcbt));
+		}
+	} else {
+		reg =3D priv->read(&regs->ctrl);
+		reg &=3D ~(FLEXCAN_CTRL_PRESDIV(0xff) |
+			 FLEXCAN_CTRL_RJW(0x3) |
+			 FLEXCAN_CTRL_PSEG1(0x7) |
+			 FLEXCAN_CTRL_PSEG2(0x7) |
+			 FLEXCAN_CTRL_PROPSEG(0x7));
+
+		reg |=3D FLEXCAN_CTRL_PRESDIV(bt->brp - 1) |
+			FLEXCAN_CTRL_PSEG1(bt->phase_seg1 - 1) |
+			FLEXCAN_CTRL_PSEG2(bt->phase_seg2 - 1) |
+			FLEXCAN_CTRL_RJW(bt->sjw - 1) |
+			FLEXCAN_CTRL_PROPSEG(bt->prop_seg - 1);
+		priv->write(reg, &regs->ctrl);
+
+		netdev_dbg(dev, "bt: prediv %d seg1 %d seg2 %d rjw %d propseg %d\n",
+			   bt->brp - 1, bt->phase_seg1 - 1, bt->phase_seg2 - 1,
+			   bt->sjw - 1, bt->prop_seg - 1);
+
+		/* print chip status */
+		netdev_dbg(dev, "%s: mcr=3D0x%08x ctrl=3D0x%08x\n", __func__,
+			   priv->read(&regs->mcr), priv->read(&regs->ctrl));
+	}
 }
=20
 /* flexcan_chip_start
@@ -1034,7 +1188,7 @@ static int flexcan_chip_start(struct net_device *dev)
 {
 	struct flexcan_priv *priv =3D netdev_priv(dev);
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	u32 reg_mcr, reg_ctrl, reg_ctrl2, reg_mecr;
+	u32 reg_mcr, reg_ctrl, reg_ctrl2, reg_mecr, reg_fdctrl;
 	u64 reg_imask;
 	int err, i;
 	struct flexcan_mb __iomem *mb;
@@ -1131,6 +1285,26 @@ static int flexcan_chip_start(struct net_device *dev=
)
 	netdev_dbg(dev, "%s: writing ctrl=3D0x%08x", __func__, reg_ctrl);
 	priv->write(reg_ctrl, &regs->ctrl);
=20
+	/* FDCTRL */
+	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
+		reg_fdctrl =3D priv->read(&regs->fdctrl) & ~FLEXCAN_FDCTRL_FDRATE;
+		reg_fdctrl &=3D ~(FLEXCAN_FDCTRL_MBDSR1(0x3) | FLEXCAN_FDCTRL_MBDSR0(0x3=
));
+		reg_mcr =3D priv->read(&regs->mcr) & ~FLEXCAN_MCR_FDEN;
+
+		/* support BRS when set CAN FD mode
+		 * 64 bytes payload per MB and 7 MBs per RAM block by default
+		 * enable CAN FD mode
+		 */
+		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+			reg_fdctrl |=3D FLEXCAN_FDCTRL_FDRATE;
+			reg_fdctrl |=3D FLEXCAN_FDCTRL_MBDSR1(0x3) | FLEXCAN_FDCTRL_MBDSR0(0x3)=
;
+			reg_mcr |=3D FLEXCAN_MCR_FDEN;
+		}
+
+		priv->write(reg_fdctrl, &regs->fdctrl);
+		priv->write(reg_mcr, &regs->mcr);
+	}
+
 	if ((priv->devtype_data->quirks & FLEXCAN_QUIRK_ENABLE_EACEN_RRS)) {
 		reg_ctrl2 =3D priv->read(&regs->ctrl2);
 		reg_ctrl2 |=3D FLEXCAN_CTRL2_EACEN | FLEXCAN_CTRL2_RRS;
@@ -1255,6 +1429,12 @@ static int flexcan_open(struct net_device *dev)
 	struct flexcan_priv *priv =3D netdev_priv(dev);
 	int err;
=20
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES) &&
+	    (priv->can.ctrlmode & CAN_CTRLMODE_FD)) {
+		netdev_err(dev, "three samples mode and fd mode can't be used together\n=
");
+		return -EINVAL;
+	}
+
 	err =3D pm_runtime_get_sync(priv->dev);
 	if (err < 0)
 		return err;
@@ -1267,7 +1447,10 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_close;
=20
-	priv->mb_size =3D sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		priv->mb_size =3D sizeof(struct flexcan_mb) + CANFD_MAX_DLEN;
+	else
+		priv->mb_size =3D sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
 	priv->mb_count =3D (sizeof(priv->regs->mb[0]) / priv->mb_size) +
 			 (sizeof(priv->regs->mb[1]) / priv->mb_size);
=20
@@ -1607,6 +1790,18 @@ static int flexcan_probe(struct platform_device *pde=
v)
 	priv->devtype_data =3D devtype_data;
 	priv->reg_xceiver =3D reg_xceiver;
=20
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_TIMESTAMP_SUPPORT_FD) {
+		if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
+			priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
+			priv->can.bittiming_const =3D &flexcan_fd_bittiming_const;
+			priv->can.data_bittiming_const =3D &flexcan_fd_data_bittiming_const;
+		} else {
+			dev_err(&pdev->dev, "can fd mode can't work on fifo mode\n");
+			err =3D -EINVAL;
+			goto failed_register;
+		}
+	}
+
 	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
--=20
2.17.1

