Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE755C6BB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGBBpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 21:45:44 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:43662
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726347AbfGBBpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 21:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9f6Cba8MWxLipm3J7aqw6G4BWTpjPbM4fJz55MeNllM=;
 b=XsCue82d0M91hjRmttoPow9EwEw++YlIIv4E9TX+lHJl0BN2ceBIyVbGkVNMe+VlDkuY2KgxTZjDlIWJil44d3scUJ5oCBSIW2x2fIEoYwdB38DHEwi7rMLXA4Zd17CMoVx/HypbKbd/69BNogOnGKheTLk8KsPJp118XHvtCXM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB4746.eurprd04.prod.outlook.com (20.176.233.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 01:45:41 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::58d4:6713:ac7d:83d2]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::58d4:6713:ac7d:83d2%3]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 01:45:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V4] can: flexcan: fix stop mode acknowledgment
Thread-Topic: [PATCH V4] can: flexcan: fix stop mode acknowledgment
Thread-Index: AQHVMHfaCqKrzVTOS0G/H4Ie2l5GYA==
Date:   Tue, 2 Jul 2019 01:45:41 +0000
Message-ID: <20190702014316.26444-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR03CA0112.apcprd03.prod.outlook.com
 (2603:1096:4:91::16) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02189176-a006-4fc4-7834-08d6fe8efd41
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4746;
x-ms-traffictypediagnostic: DB7PR04MB4746:
x-microsoft-antispam-prvs: <DB7PR04MB4746CB06C98F65DA8A95E410E6F80@DB7PR04MB4746.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(54534003)(199004)(189003)(478600001)(186003)(8936002)(2906002)(52116002)(50226002)(64756008)(68736007)(305945005)(81156014)(86362001)(6486002)(81166006)(5660300002)(8676002)(25786009)(3846002)(102836004)(6116002)(6436002)(1076003)(386003)(256004)(71200400001)(14444005)(71190400001)(2616005)(99286004)(476003)(73956011)(66066001)(486006)(53936002)(316002)(66446008)(2501003)(110136005)(66476007)(14454004)(54906003)(26005)(7736002)(66946007)(66556008)(6506007)(6512007)(4326008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4746;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mF3o1Nzi4WEEO3HnGnINSe1xTIcPUHkb0QiO0F2Y9/n7lvJIU7sAqPIKA4YbOZSDmIOwh4b74ncN3m6ouiJMcgAtCwYZFvRZeevl5dt6FM8V4X0FMrBXNbv6y1yBSKBM8RHefed5rpSFEs0sTbDaGr1VEG1pe45IevlVOfrkskYfXIsclBJuAM0mlz/dEE8dowLyBBFYILpB/KiR0LZKHEpIuxhXY0SFtjXhJvuBPXTEOs7fgWXQb2arY4J2ZPOGva1yDaolqOtMHKXBpVluXxRiyfhn4vyw/gBmOBaAgeIFjZiKzS/WvBy14Y2qYNVABvNSFJkD8SD3mVDeY37frAtNVKYZbNmtooevcQVWaTUSLPuv2bhHUfWTvIPxF9KLbz95eP3bVki/H/RjWY2/xB32/zYcJqSPdTpA1IVHUCM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02189176-a006-4fc4-7834-08d6fe8efd41
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 01:45:41.1358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4746
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enter stop mode, the CPU should manually assert a global Stop Mode
request and check the acknowledgment asserted by FlexCAN. The CPU must
only consider the FlexCAN in stop mode when both request and
acknowledgment conditions are satisfied.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

ChangeLog:
V1->V2:
	* regmap_read()-->regmap_read_poll_timeout()
V2->V3:
	* change the way of error return, it will make easy for function
	extension.
V3->V4:
	* rebase to linux-next/master, as this is a fix.
---
 drivers/net/can/flexcan.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1c66fb2ad76b..bf1bd6f5dbb1 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -400,9 +400,10 @@ static void flexcan_enable_wakeup_irq(struct flexcan_p=
riv *priv, bool enable)
 	priv->write(reg_mcr, &regs->mcr);
 }
=20
-static inline void flexcan_enter_stop_mode(struct flexcan_priv *priv)
+static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
+	unsigned int ackval;
 	u32 reg_mcr;
=20
 	reg_mcr =3D priv->read(&regs->mcr);
@@ -412,20 +413,37 @@ static inline void flexcan_enter_stop_mode(struct fle=
xcan_priv *priv)
 	/* enable stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+
+	/* get stop acknowledgment */
+	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
+				     ackval, ackval & (1 << priv->stm.ack_bit),
+				     0, FLEXCAN_TIMEOUT_US))
+		return -ETIMEDOUT;
+
+	return 0;
 }
=20
-static inline void flexcan_exit_stop_mode(struct flexcan_priv *priv)
+static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
+	unsigned int ackval;
 	u32 reg_mcr;
=20
 	/* remove stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 0);
=20
+	/* get stop acknowledgment */
+	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
+				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
+				     0, FLEXCAN_TIMEOUT_US))
+		return -ETIMEDOUT;
+
 	reg_mcr =3D priv->read(&regs->mcr);
 	reg_mcr &=3D ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
+
+	return 0;
 }
=20
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *pri=
v)
@@ -1615,7 +1633,9 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 		 */
 		if (device_may_wakeup(device)) {
 			enable_irq_wake(dev->irq);
-			flexcan_enter_stop_mode(priv);
+			err =3D flexcan_enter_stop_mode(priv);
+			if (err)
+				return err;
 		} else {
 			err =3D flexcan_chip_disable(priv);
 			if (err)
@@ -1665,10 +1685,13 @@ static int __maybe_unused flexcan_noirq_resume(stru=
ct device *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
+	int err;
=20
 	if (netif_running(dev) && device_may_wakeup(device)) {
 		flexcan_enable_wakeup_irq(priv, false);
-		flexcan_exit_stop_mode(priv);
+		err =3D flexcan_exit_stop_mode(priv);
+		if (err)
+			return err;
 	}
=20
 	return 0;
--=20
2.17.1

