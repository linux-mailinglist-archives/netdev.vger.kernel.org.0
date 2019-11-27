Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAF210AA73
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfK0F4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:56:55 -0500
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:58850
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfK0F4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 00:56:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLA4qH/RxlBFsR4P4BPwJjfFQtqqqqg96K+KxYBgHpC8JorYUpMsUJE0EQyAYPND7gYOMDMsHjJxvJX7Ez/RlEgce5bJcvKPRnpu6Qy35vaGlYuIOcnb8f6j59bTh8MFxwNvnIl2hM8wuICg6wO6iLhRj+GoBcu6MWX6fR8CCn2koO6xjdFOgEUiIIzebrcjni2GA/+uEQrw1zg4qrpA4CYbufZqSyIDpxufoZXlStUzmqce7CaVU+CpTlRUeIkMfc0OD7Ipg77P6buWdgy0jjIJ+g3AK1rNVo7CpXdjgDkGqg/nP+lCgRW7CPT23/MgTN5YbMbZmzxQdmfogBk0CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRlPwnzKqWrpFULnGMLeRW9rtTxzVtqv21c0zoJ7GwY=;
 b=liS4gBQkaGGaLxnPr4+Ich4jKKWWqwp2/qdGqYskAJd6PWH04/23irnL1HK97/PoV00wsTUSc1MP4b06Ms+BnjRMoO3W9ciO1tG3XTymOKrz8b5czhf+Tr9SNI7V/c2+L9+fXQha9cPGBqFUaUENJ6O7CK9rkmDprUPLTgURQgFrksiRYtUCtwXO1cBBUN8uIgGbAAAhDOZqLeOVbkMebM6kdHVrdHbCo2Rnv9h44V4R2YvfzOE+yHuszqU+1uf3oFk2y14YsweMaQPomhLFEIdtHpZa9HEkG8oD6+KklQ1wH6C9DHvtgpFL0ITOGM4JxFZZ505A547Id1Jrmo5u6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRlPwnzKqWrpFULnGMLeRW9rtTxzVtqv21c0zoJ7GwY=;
 b=O3YBbGX9ZOWfOVyuo+oK3V5/r/T+5ITaXSBnzcISiaqBhdU/JlZv/94Nyu0WzruV1yxuHpoxc4kl27PDu4U74NbaKOPLZXefMC2EVrcuEmGFQZh24EKPvgcWw0d9mtiON0XZzgwGbeCwjIL+iuKdoGfOoekNPOdZQoCEeVxObkc=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4409.eurprd04.prod.outlook.com (52.135.137.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Wed, 27 Nov 2019 05:56:50 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 05:56:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 3/4] can: flexcan: change the way of stop mode
 acknowledgment
Thread-Topic: [PATCH V2 3/4] can: flexcan: change the way of stop mode
 acknowledgment
Thread-Index: AQHVpOd2DKhlfII7e0yJDtRHRUlwXw==
Date:   Wed, 27 Nov 2019 05:56:50 +0000
Message-ID: <20191127055334.1476-4-qiangqing.zhang@nxp.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 332c5cc6-80c9-4a21-f168-08d772fe9866
x-ms-traffictypediagnostic: DB7PR04MB4409:|DB7PR04MB4409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4409F579B34F25CB9CE018EEE6440@DB7PR04MB4409.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(54534003)(199004)(189003)(26005)(36756003)(110136005)(316002)(386003)(2906002)(66066001)(25786009)(446003)(50226002)(8676002)(2616005)(81156014)(8936002)(11346002)(2501003)(66476007)(64756008)(66556008)(66446008)(99286004)(14454004)(256004)(14444005)(7736002)(52116002)(76176011)(1076003)(4326008)(66946007)(102836004)(2201001)(3846002)(478600001)(86362001)(5660300002)(81166006)(305945005)(6436002)(6116002)(71200400001)(71190400001)(186003)(54906003)(6506007)(6486002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4409;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z5E/NUlusvyTghBA1rNcVVPyl+6Fe6TNIfU4Mj2+I6EZTMCGS2zYqnZqsekBHJdv5BWp+vNV+NRqxraqtdmJOZrEJQB3D8vNcyWoceZ5v3aLVWVwrqG6eK0zFkMRWWTRKM8shhrpKrO5opV7hQndx75cwSSuNXuaAV761xU9Mudxr+y76Yp6uFZth2eKtiI3Yin3/UJS+4xKD1nG+3q5ZYcAKLu8VAiTmz8MGBpBGdtxdthPDPDSt6toThrDu82TYGG8iBY6x9dr5gutllEuHEI+SiitOODqQEUCBnpQ3ESjfv0ASwCcKRFnySo3t1Vs+86QqmCsY4OG+5ZxC9pQLA1RL7fijfd88cCnEgx2qW+GEGyeTfhZ+meBpY1dawLIkXaCThewkRXlPlUczvxfoFAHzLNUh2SbwuAT5a7GH2oxQySk7LKZIcZ9wECgieDk
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 332c5cc6-80c9-4a21-f168-08d772fe9866
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 05:56:50.2296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: afxbLIsCrYJBbct9pTcoKAl0X3jWlzTwVn9S8GSsAzgEE+p9CDiieSE/IjHorq942RwvOeOSz+ThXD2kuyV6CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4409
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop mode is entered when Stop mode is requested at chip level and
MCR[LPM_ACK] is asserted by the FlexCAN.

Double check with IP owner, should poll MCR[LPM_ACK] for stop mode
acknowledgment, not the acknowledgment from chip level which is used
for glitch filter.

Fixes: 5f186c257fa4(can: flexcan: fix stop mode acknowledgment)
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
------
ChangeLog:
	V1->V2: no change.
---
 drivers/net/can/flexcan.c | 64 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 5d5ed28d3005..d178146b3da5 100644
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
 static void flexcan_try_exit_stop_mode(struct flexcan_priv *priv)
@@ -512,39 +528,25 @@ static inline int flexcan_transceiver_disable(const s=
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

