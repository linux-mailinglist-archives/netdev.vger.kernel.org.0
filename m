Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F048B66821
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGLIDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:03:04 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:19328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbfGLIDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:03:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oqd1uWS5qX2Hk7Qa/ArIYn+Fp9V6GVqdOPzaa7d4IHojmjrWy+6IIv1awxaefwvKQPEu6M9ffK20p3hWbdk/diNSrXE8am7UxRk9ushwzJQkNrws/4rA4qTEMcPA/zuVc4k8dyPMeycuPyyiod5bI+I6rsOfz7NJLVt/5KUhSsZCFL1hvodBdxCuDG5BYiVEfsloaTIFw9G+MCPIackmZV+k7R3Mr4AHXvVuZwIuBLk6f/s2ta4GWYHqwLMDoh3jG7fI7Zo/bIvZQ0F4Sb+MIwOi0l7+2ExnCfaGkfbQecChzNGmHYXh7lZZoEsFQGdcLFcmKVG7DBPajzdVy0Xn3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNItnYTrcCC/OtR1nwrCWagIrmKeGVYxn8+8AhRF0mQ=;
 b=CI+6HALNQxCa9BQeEOeOC9ubGHnBARBqkAUYebV89oUFcpz+bwzHyu52sYH7av/d7y0pothNaXpnuzxW/zRqLLlZ4wYznsX6GoR5FVA8b/WWuVoS/7BWOhs8X9P6jIvQTVOQSK09bDxaXY4G1aP7KIbahDxnUj06WXk76b2LYBuwqdcBj+TQ+7CO5HCyRfF9PnPnOQEA614JOyXhyjTwcwT73o7SQx6/QeX+/cEUE97+u2GRZCrkNlqUL6F2kX/7h+rHB95IXZFpcYz/Zhsqlki4zJpDMvpkxbB2lI2YPcNQwBXnhC5CzRTBY6MvHgmr1JyARKq0V+O+xHgyaPKO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNItnYTrcCC/OtR1nwrCWagIrmKeGVYxn8+8AhRF0mQ=;
 b=ANLYD2Y02kIA8ZgQ8sK8283zAUwkhMhAJt5kxO+FEZI1HjZscnXYnHTLE7GK/v1xdEUuWDp7Dyi9KZIdqFmY1s7jrfPmSyFM1HO0FQRvTpgcPLXeeCW+t60S4s66vgUK2JNz+CGkpR065XlrJU80KzjllBl7GhrJB/diz4sBJyE=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4330.eurprd04.prod.outlook.com (52.134.108.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:56 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 6/8] can: flexcan: add Transceiver Delay Compensation suopport
Thread-Topic: [PATCH 6/8] can: flexcan: add Transceiver Delay Compensation
 suopport
Thread-Index: AQHVOIg2hBizvekVCESHJ7kllz9hiQ==
Date:   Fri, 12 Jul 2019 08:02:56 +0000
Message-ID: <20190712075926.7357-7-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: 694f8656-ab6b-4411-5ea2-08d7069f590b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4330;
x-ms-traffictypediagnostic: DB7PR04MB4330:
x-microsoft-antispam-prvs: <DB7PR04MB4330F03BD9991FE1D970D948E6F20@DB7PR04MB4330.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(110136005)(25786009)(1076003)(54906003)(305945005)(3846002)(6116002)(7736002)(316002)(71200400001)(4326008)(66066001)(2906002)(66446008)(5660300002)(64756008)(66556008)(66476007)(71190400001)(2501003)(478600001)(66946007)(2616005)(6506007)(102836004)(26005)(386003)(6436002)(186003)(6486002)(86362001)(50226002)(68736007)(256004)(14444005)(446003)(476003)(11346002)(486006)(8936002)(52116002)(76176011)(36756003)(53936002)(99286004)(14454004)(81156014)(81166006)(6512007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4330;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hgmvGpZS3oxgbutviqxI5xCLxKuBpYK0539T6cPDI1tWJ/IMiishbdjpcpLmEoer/PA7CTStaWjSGdeGARyQyrnGdgzYpkASatSsRKQumvO8Ci6vPEgZZ7TN6MLKfRqWzlQqTdMr3ikMxzzdvE+Y6o4ig4y0XUsLoDJwG3VIQui1mLBBMLJ6WVLWUAfHOtGu9pzJ1OB0VBFNshFFSKDOEJAt2dcVvuRCgi02U1hwGuuvgVJzdPHD9/lEVKfMC8SgOoIaj7tA6v/4/eSg+jynnyHj7Vg+NG0H82gQkcWifjA3ulhENVz6VeLU2uqEpZa1o17tOGpt6qaPbqsE90JbirSRGhTEMOUDib6xtCXff5kGJGi5g2QpuTdhrvT7qObEleNvaDOmpNlr8cmkqvUWZKCoGMsQyCYKzvYslzrI75E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694f8656-ab6b-4411-5ea2-08d7069f590b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:56.2287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4330
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAN FD protocol allows the transmission and reception of data at a high=
er
bit rate than the nominal rate used in the arbitration phase when the messa=
ge's
BRS bit is set.

The TDC mechanism is effective only during the data phase of FD frames
having BRS bit set. It has no effect either on non-FD frames, or on FD
frames transmitted at normal bit rate.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index daf4f0e88224..2c48151e431f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -149,8 +149,10 @@
=20
 /* FLEXCAN FD control register (FDCTRL) bits */
 #define FLEXCAN_FDCTRL_FDRATE		BIT(31)
+#define FLEXCAN_FDCTRL_TDCEN		BIT(15)
 #define FLEXCAN_FDCTRL_MBDSR1(x)	(((x) & 0x3) << 19)
 #define FLEXCAN_FDCTRL_MBDSR0(x)	(((x) & 0x3) << 16)
+#define FLEXCAN_FDCTRL_TDCOFF(x)	(((x) & 0x1f) << 8)
=20
 /* FLEXCAN FD Bit Timing register (FDCBT) bits */
 #define FLEXCAN_FDCBT_FPRESDIV(x)	(((x) & 0x3ff) << 20)
@@ -1075,7 +1077,7 @@ static void flexcan_set_bittiming(struct net_device *=
dev)
 	struct can_bittiming *bt =3D &priv->can.bittiming;
 	struct can_bittiming *dbt =3D &priv->can.data_bittiming;
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	u32 reg, reg_cbt, reg_fdcbt;
+	u32 reg, reg_cbt, reg_fdcbt, reg_fdctrl;
=20
 	reg =3D priv->read(&regs->ctrl);
 	reg &=3D ~(FLEXCAN_CTRL_LPB | FLEXCAN_CTRL_SMP | FLEXCAN_CTRL_LOM);
@@ -1147,6 +1149,19 @@ static void flexcan_set_bittiming(struct net_device =
*dev)
 					FLEXCAN_FDCBT_FPROPSEG(dbt->prop_seg);
 			priv->write(reg_fdcbt, &regs->fdcbt);
=20
+			/* enable transceiver delay compensation(TDC) for fd frame.
+			 * TDC must be disabled when Loop Back mode is enabled.
+			 */
+			reg_fdctrl =3D priv->read(&regs->fdctrl);
+			if (!(reg & FLEXCAN_CTRL_LPB)) {
+				reg_fdctrl |=3D FLEXCAN_FDCTRL_TDCEN;
+				reg_fdctrl &=3D ~FLEXCAN_FDCTRL_TDCOFF(0x1f);
+				/* for the TDC to work reliably, the offset has to use optimal setting=
s */
+				reg_fdctrl |=3D FLEXCAN_FDCTRL_TDCOFF(((dbt->phase_seg1 - 1) + dbt->pr=
op_seg + 2) *
+								    ((dbt->brp -1) + 1));
+			}
+			priv->write(reg_fdctrl, &regs->fdctrl);
+
 			if (bt->brp !=3D dbt->brp)
 				netdev_warn(dev, "Warning!! data brp =3D %d and brp =3D %d don't match=
.\n"
 					    "flexcan may not work. consider using different bitrate or data b=
itrate\n",
@@ -1296,6 +1311,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	/* FDCTRL */
 	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
 		reg_fdctrl =3D priv->read(&regs->fdctrl) & ~FLEXCAN_FDCTRL_FDRATE;
+		reg_fdctrl &=3D ~FLEXCAN_FDCTRL_TDCEN;
 		reg_fdctrl &=3D ~(FLEXCAN_FDCTRL_MBDSR1(0x3) | FLEXCAN_FDCTRL_MBDSR0(0x3=
));
 		reg_mcr =3D priv->read(&regs->mcr) & ~FLEXCAN_MCR_FDEN;
 		reg_ctrl2 =3D priv->read(&regs->ctrl2) & ~FLEXCAN_CTRL2_ISOCANFDEN;
--=20
2.17.1

