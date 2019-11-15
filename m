Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2814FD3DE
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfKOFDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:03:32 -0500
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:7650
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbfKOFDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 00:03:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8/iuy21UxGQwNaBLxzTLZyyGKPLUgwU3814OlARpkjYyW1nRK9MaaY7m+Cl4PJPiMSVKUnagUeTlC9lzPvK0wwM3YlBEiQmS5aHF3LB33fbejiqnsnnV/zhJnjCHNZS96idiq8cp2+Sw0NbhBuf6AUUTWQW2k2WxQkW8nJYw4PONHgNmSB1TzH5Fq2V5XWTty/o8DAnGEbh6JYkN8TrViWqP56LuY6DX38LL895imF0p7OazL9w8rTX0Du9Q1ugW0duIEyWZ55roEtOQyrJmXkzSnYp2WUYpQF+UcIxQWHPJLp6SOXFbIko85bSMqWejt8A3PbDAwS3C3cjFxcsfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqohjzkJA7Q8QjpDnAhk48228jOjmHqJuETV6dvrBZ4=;
 b=UkuPN7TCq91Av2ypWu5C7uXMiDisCxjajT0koHmWDuLqfCoDAJRUiYYzkIwP8dOZ57oFx7TW+cOpVMQtKrGtidePFCYLBV2MhR3CC/DkfWLdeyKeqJ2AfrsjOAf5XWFOW71x2MPdc4Fx2R5Jayqk9a/OcbV+srBeCSfcirM0TsKt3zsaOIM8XM7tJ86ZuJUMbvEuzbx+UuxgDCVsE9cxtYUVC4nK7f8yJR7jWCpvi3SbPK/PXqLrEgSAqmu6imLiMPLF3GMXm+V8Ij/4scD0Ip573sjXeGoGc97TeTxpqmpyeYUngIMrRA704aUtB6PUtgXm22N2SjVLW8ah+dJK1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqohjzkJA7Q8QjpDnAhk48228jOjmHqJuETV6dvrBZ4=;
 b=d2I9l+vEUBfdwuDyH5wfpIk+CdireMY6Ljx978bUohQwy2PsK7r+/MbFdD6/gly2XReWfTWW1/p0E+F3HJXMiLZsJNalRX126hGxruJeu9qur8iIaaL01CTBY++hFFM78rJ19lHqVo+mSDQM8jXMqeiJCKtRaWUCb1jOQezdS3c=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Fri, 15 Nov 2019 05:03:28 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 05:03:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 2/3] can: flexcan: change the way of stop mode acknowledgment
Thread-Topic: [PATCH 2/3] can: flexcan: change the way of stop mode
 acknowledgment
Thread-Index: AQHVm3IEaKvL71rRkUKvuEX+6gXwAg==
Date:   Fri, 15 Nov 2019 05:03:28 +0000
Message-ID: <20191115050032.25928-2-qiangqing.zhang@nxp.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0143.apcprd06.prod.outlook.com
 (2603:1096:1:1f::21) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3be6560-89e9-4696-e0b4-08d769892736
x-ms-traffictypediagnostic: DB7PR04MB4620:|DB7PR04MB4620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB462012BCE233306140DA29B8E6700@DB7PR04MB4620.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(199004)(189003)(52116002)(316002)(76176011)(305945005)(110136005)(8936002)(66066001)(478600001)(64756008)(66556008)(71190400001)(66946007)(66476007)(50226002)(256004)(66446008)(8676002)(6506007)(36756003)(3846002)(6116002)(14454004)(102836004)(54906003)(26005)(14444005)(71200400001)(2906002)(81156014)(81166006)(386003)(25786009)(99286004)(7736002)(186003)(2501003)(5660300002)(486006)(1076003)(2201001)(6486002)(86362001)(476003)(2616005)(6512007)(6436002)(11346002)(4326008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4620;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iq1GCQrVPlf3GQCPDUDMqztgqpCqmvLoWij4LxOQPTH45hObijpuq2BFaNjp4pl2BWT3gDNveAojG0nirluoromLy/o8oGSMRzrW6T1UqiEFbq6FXAfRSoEcZjq7ITmCrneHJMTPm3JX+U4lFIK8QeuQ0Npl7LcKKjxLQGPmbHa+OkspXh7I/cWFBbzQ90EqTWmmkeH1tcoU1UlN8C6N0gOylpC85AEhQBWFAWtIQtgUd91GlTASt1QN3qIMryjWEptZ84NfnzB+mvY78EkZ1LWGsJ59MrjX7obZf7z7c/xfvnfublHpm5PCsHm9991mCGbv+VLvYyeEYSi++faYSqxjnC1zAIDUSnb/fW4PnG81qOE/IdpH+rZX7PtfQEmtsT0WEF9qwTOTGfjIl959kRUGMyu9ZhRJ/KQ0Ww/Y+ptdKwyG9OjUA8y/a5Zzk590
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3be6560-89e9-4696-e0b4-08d769892736
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 05:03:28.7157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+/KplczgcQ9tsYVa2JcMTeratN2nkjt0uCU+GeoB9SKTF++rcvm3lnrebwIhbx7zghnLQE9cuWDu4LU4GLqKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4620
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop mode is entered when Stop mode is requested at chip level and
MCR[LPM_ACK] is asserted by the FlexCAN.

Double check with IP owner, should poll MCR[LPM_ACK] for stop mode
acknowledgment, not the acknowledgment from chip level.

Fixes: 5f186c257fa4(can: flexcan: fix stop mode acknowledgment)
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 64 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 43fd187768f1..dd91d8d6b5a6 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -388,6 +388,34 @@ static struct flexcan_mb __iomem *flexcan_get_mb(const=
 struct flexcan_priv *priv
 		(&priv->regs->mb[bank][priv->mb_size * mb_index]);
 }
=20
+static int flexcan_enter_low_power_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs =3D priv->regs;
+	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int flexcan_exit_low_power_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs =3D priv->regs;
+	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enab=
le)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
@@ -406,7 +434,6 @@ static void flexcan_enable_wakeup_irq(struct flexcan_pr=
iv *priv, bool enable)
 static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int ackval;
 	u32 reg_mcr;
=20
 	reg_mcr =3D priv->read(&regs->mcr);
@@ -418,35 +445,24 @@ static inline int flexcan_enter_stop_mode(struct flex=
can_priv *priv)
 			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
=20
 	/* get stop acknowledgment */
-	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
-				     ackval, ackval & (1 << priv->stm.ack_bit),
-				     0, FLEXCAN_TIMEOUT_US))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_enter_low_power_ack(priv);
 }
=20
 static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int ackval;
 	u32 reg_mcr;
=20
 	/* remove stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 0);
=20
-	/* get stop acknowledgment */
-	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
-				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
-				     0, FLEXCAN_TIMEOUT_US))
-		return -ETIMEDOUT;
-
 	reg_mcr =3D priv->read(&regs->mcr);
 	reg_mcr &=3D ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
=20
-	return 0;
+	/* get stop acknowledgment */
+	return flexcan_exit_low_power_ack(priv);
 }
=20
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *pri=
v)
@@ -505,39 +521,25 @@ static inline int flexcan_transceiver_disable(const s=
truct flexcan_priv *priv)
 static int flexcan_chip_enable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
=20
 	reg =3D priv->read(&regs->mcr);
 	reg &=3D ~FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
=20
-	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_exit_low_power_ack(priv);
 }
=20
 static int flexcan_chip_disable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs =3D priv->regs;
-	unsigned int timeout =3D FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
=20
 	reg =3D priv->read(&regs->mcr);
 	reg |=3D FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
=20
-	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_enter_low_power_ack(priv);
 }
=20
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
--=20
2.17.1

