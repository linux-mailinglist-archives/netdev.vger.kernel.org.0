Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C146E96AD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 07:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfJ3GqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 02:46:11 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:55276
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbfJ3Gp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 02:45:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a958T7kWkZ1qz62I5A0qOAjugdNJtrGZYenCQWkBdE70ur8SUgptAwLl7GmHRRuEfSp/oC0kTE3Z6TjZ2/5aMkUA8wo7lWuxIgYBHE5M0ExCHB496I/n2z79WKs+arZU4Xx/A2R6kQScqagsBw33YXLokUqXnEo600Pu1AmS+WFOe5M4QEjTC5/Byiod72YGv/ktJ4ErtkpluMIR+5AyOyqqMNVqcXesJ1nMzy6QFab9uPVFvEHFjl3IktOi7RJg86lVQRI9fifLTf7GCwe3lXV+Uv8TYn+UWiA8znrF9WahEdhvfSpPogeJ8JUimpq3b5/o/cTFOnluZCUc3LWyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8C/1PYWRCO4sHPCmyAt7nANIhX8Oh3mI0PmMRsM7+Q=;
 b=gi9i7nHzI+/hYzTufsdOsKRD2976s59Q0xOhssAvW6HQt2lXlvEJLAgGTaKEudMLLq958U24JX8X58aBqRATQ66fwVU9b0XtfHXwHaL04o2SYPZPJDOUN1O/6+EaNxRl76FC4uPPBzCJpGpAR1n9MwyPUC6Uaa6JHl24d2yQe7qmrPlaJYuLltuIs9V1OcP7GxrfmvhPbVXTIvzm20EmL89dXbGoACoa4nKIyseCio4BJKftG2CSwi+Zuy9rBn3Xt58NJqdQxYi81gFjVRKVeR+4QiRYyjXYIReMZ6gG0lK7/42z05ttNeziCcErvQTtLliKXH3McVjx9n52yiA+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8C/1PYWRCO4sHPCmyAt7nANIhX8Oh3mI0PmMRsM7+Q=;
 b=JZgQAnQPsoQW4UM6nyL7I/gJfn0olMDjAnABV6l2uzh3wWd+bRj+EK4Z537+F2xYz3dfhx+1VoE5ltgc30RvBWEjTNUPdtihYuzDmMFpX8GdtmGESloPPBGIAOH/UBLhxOAzLjPOIE3f7iafFNnz+/RXa6HnQntjv2tSqiZ1U4k=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4666.eurprd04.prod.outlook.com (52.135.133.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 06:45:54 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679%3]) with mapi id 15.20.2367.031; Wed, 30 Oct 2019
 06:45:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [RFC PATCH] can: dev: Add check for the minimum value of a bit time
Thread-Topic: [RFC PATCH] can: dev: Add check for the minimum value of a bit
 time
Thread-Index: AQHVju2tAMAfAIze9E+YwIGuZQPJNg==
Date:   Wed, 30 Oct 2019 06:45:54 +0000
Message-ID: <20191030064245.12923-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:3:18::30) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 521b00a7-18be-4cdb-ace3-08d75d04cfc5
x-ms-traffictypediagnostic: DB7PR04MB4666:|DB7PR04MB4666:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB46669672F561362444F1BAB2E6600@DB7PR04MB4666.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(189003)(199004)(81166006)(2501003)(486006)(99286004)(8676002)(86362001)(66446008)(2616005)(66556008)(5660300002)(476003)(7736002)(66476007)(50226002)(64756008)(81156014)(4326008)(305945005)(66946007)(6506007)(26005)(386003)(14444005)(25786009)(256004)(316002)(36756003)(102836004)(66066001)(6512007)(186003)(3846002)(54906003)(6436002)(1076003)(71190400001)(6486002)(110136005)(14454004)(2906002)(478600001)(52116002)(66574012)(8936002)(71200400001)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4666;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8yF72A6FvZ7/O2sOnoCmggy41TC6bXz/F1dmaehXpYaTghqAIkfIiyPADGN/zakORakyTkIGA4CxrDMPmH0DowlpNNnpV02Sq8y3g5SP2rTZKmaPMbE1wlfqJHIxGxvqEvUsmPoMdEzBvaETMnKA8vGEXkXMZxTdTRil1HaX8ZO8y7hN21W5mBL1tcKxpXsbBRkyXaKCHCpqwR6w2DgCGBLy3jXgd5tMmXY9yWM/FGDC7uoorXSsVifO5jxfOtxcPyVDwehSrH3Q9jvSLoaIQAdLdz5EAlMk37BZW+hfL4KU+dzzJFAltuKJriGrTx9PJWAumMVHvO2y+F0K7iiyuTTNrOM0F7PRcrsCouggbXm7hZWANXGRwQ5vYCB3liWNB99G+27kvk1wuYImI2AO4r0omlVKcNw09WE7FkYp8zHFkxjfisVAfK/FvsRVMorp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521b00a7-18be-4cdb-ace3-08d75d04cfc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 06:45:54.6063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lf+qB9E+ZLkOAn59kq/0w1TVWhMz8Sb9kTqGxYiB7NvHTkRifn1C5DlGQU9SGKF+AApZnBR1s0C+YrpS2FWMQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As ISO 11898-1 said: The total number of time quanta in a nominal bit
time shall be programmable at least from 8 to 25 for implementation that
are not FD enabled. For implementations that are FD enabled, the total
number of time quanta in a data bit time shall be programmable at least
from 5 to 25 and in a nominal bit time at least from 8 to 80.

So the minimum value for nominal bit time is 8 and for data bit time is
5, had better ensure the minimum value of a bit time.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/dev.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index ac86be52b461..69e693c79579 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -115,7 +115,8 @@ can_update_sample_point(const struct can_bittiming_cons=
t *btc,
 	return best_sample_point;
 }
=20
-static int can_calc_bittiming(struct net_device *dev, struct can_bittiming=
 *bt,
+static int can_calc_bittiming(struct net_device *dev, bool is_data_bt,
+			      struct can_bittiming *bt,
 			      const struct can_bittiming_const *btc)
 {
 	struct can_priv *priv =3D netdev_priv(dev);
@@ -147,6 +148,14 @@ static int can_calc_bittiming(struct net_device *dev, =
struct can_bittiming *bt,
 	     tseg >=3D (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
 		tsegall =3D CAN_CALC_SYNC_SEG + tseg / 2;
=20
+		/* the total number of time quanta in a data bit time
+		 * (SYNC_SEG + TSEG1 + TSEG2) shall be programmable at least 5.
+		 * the total number of time quanta in a nominal bit time
+		 * (SYNC_SEG + TSEG1 + TSEG2) shall be programmable at least 8.
+		 */
+		if ((is_data_bt && tsegall < 5) || (!is_data_bt && tsegall < 8))
+			continue;
+
 		/* Compute all possible tseg choices (tseg=3Dtseg1+tseg2) */
 		brp =3D priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
=20
@@ -228,7 +237,8 @@ static int can_calc_bittiming(struct net_device *dev, s=
truct can_bittiming *bt,
 	return 0;
 }
 #else /* !CONFIG_CAN_CALC_BITTIMING */
-static int can_calc_bittiming(struct net_device *dev, struct can_bittiming=
 *bt,
+static int can_calc_bittiming(struct net_device *dev, bool is_data_bt,
+			      struct can_bittiming *bt,
 			      const struct can_bittiming_const *btc)
 {
 	netdev_err(dev, "bit-timing calculation not available\n");
@@ -241,7 +251,8 @@ static int can_calc_bittiming(struct net_device *dev, s=
truct can_bittiming *bt,
  * prescaler value brp. You can find more information in the header
  * file linux/can/netlink.h.
  */
-static int can_fixup_bittiming(struct net_device *dev, struct can_bittimin=
g *bt,
+static int can_fixup_bittiming(struct net_device *dev, bool is_data_bt,
+			       struct can_bittiming *bt,
 			       const struct can_bittiming_const *btc)
 {
 	struct can_priv *priv =3D netdev_priv(dev);
@@ -269,6 +280,15 @@ static int can_fixup_bittiming(struct net_device *dev,=
 struct can_bittiming *bt,
 		return -EINVAL;
=20
 	alltseg =3D bt->prop_seg + bt->phase_seg1 + bt->phase_seg2 + 1;
+
+	/* the total number of time quanta in a data bit time
+	 * (SYNC_SEG + TSEG1 + TSEG2) shall be programmable at least 5.
+	 * the total number of time quanta in a nominal bit time
+	 * (SYNC_SEG + TSEG1 + TSEG2) shall be programmable at least 8.
+	 */
+	if ((is_data_bt && alltseg < 5) || (!is_data_bt && alltseg < 8))
+		return -EINVAL;
+
 	bt->bitrate =3D priv->clock.freq / (bt->brp * alltseg);
 	bt->sample_point =3D ((tseg1 + 1) * 1000) / alltseg;
=20
@@ -295,7 +315,8 @@ can_validate_bitrate(struct net_device *dev, struct can=
_bittiming *bt,
 	return 0;
 }
=20
-static int can_get_bittiming(struct net_device *dev, struct can_bittiming =
*bt,
+static int can_get_bittiming(struct net_device *dev, bool is_data_bt,
+			     struct can_bittiming *bt,
 			     const struct can_bittiming_const *btc,
 			     const u32 *bitrate_const,
 			     const unsigned int bitrate_const_cnt)
@@ -308,9 +329,9 @@ static int can_get_bittiming(struct net_device *dev, st=
ruct can_bittiming *bt,
 	 * provided directly which are then checked and fixed up.
 	 */
 	if (!bt->tq && bt->bitrate && btc)
-		err =3D can_calc_bittiming(dev, bt, btc);
+		err =3D can_calc_bittiming(dev, is_data_bt, bt, btc);
 	else if (bt->tq && !bt->bitrate && btc)
-		err =3D can_fixup_bittiming(dev, bt, btc);
+		err =3D can_fixup_bittiming(dev, is_data_bt, bt, btc);
 	else if (!bt->tq && bt->bitrate && bitrate_const)
 		err =3D can_validate_bitrate(dev, bt, bitrate_const,
 					   bitrate_const_cnt);
@@ -944,7 +965,7 @@ static int can_changelink(struct net_device *dev, struc=
t nlattr *tb[],
 			return -EOPNOTSUPP;
=20
 		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
-		err =3D can_get_bittiming(dev, &bt,
+		err =3D can_get_bittiming(dev, false, &bt,
 					priv->bittiming_const,
 					priv->bitrate_const,
 					priv->bitrate_const_cnt);
@@ -1035,7 +1056,7 @@ static int can_changelink(struct net_device *dev, str=
uct nlattr *tb[],
=20
 		memcpy(&dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
 		       sizeof(dbt));
-		err =3D can_get_bittiming(dev, &dbt,
+		err =3D can_get_bittiming(dev, true, &dbt,
 					priv->data_bittiming_const,
 					priv->data_bitrate_const,
 					priv->data_bitrate_const_cnt);
--=20
2.17.1

