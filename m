Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EC56681E
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfGLIDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:03:01 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:19328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726290AbfGLIDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:03:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKw+z7UxmQYhkya9haDYpW0kG5uGg/0wva7+6Rktw9A60KgxiB1756kAWI8c5FtvN7V2qLlLG3mOFB/4lgtZ+Dq9fcQq2E5fj+MvKNcsMAgGRyg4lMaszgxamtHByKPw/w6kCkTKX4/9BOoJi/6u0h4j7OISbm3WQ+phr6pnB7wJJhgtNVo1GBbQ27EXYbETaojpXhEc82v7WmTJoVbq+o8qy6ooCaSkF9mlfrhbJ2CEv2DOLeR4QninGKQLySk5C8kPy8t8eGVJnnr7E4SFDwuFP4MV9ahb2uYlbRuPyB4uRYkHK7KEUCikKMrqGCSZYmRes1l1xNmEjYAXdXfOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9NVA2PgagpoH4C20jWkrlN/z1nEFiNlRJSCBS3yVrM=;
 b=hWZcZnCi36pPoaJQ7TTXsLMg2EXiUSt4cPZXIay5LJRgDE/QWWhh0I7bGujQSHgIN0ukEl/tMcz4t09+FEPxG6oKyPbzYhpHFw2xpra99rXvFnUaaVS3zka3NJ33yetg4Qhnmhcv28zDvCZdWGUnNZfs5ikdDZbZdzUeBHVlkTqOXi5yd6Q88hEysQQfSMHQT8YAcyCRi7NP/igCN6p/ClrywaVTiopCQYRTSmzjgT3RBCki+nBSzLc6QNwPKt4G9CVdUwyUzzlOTGxGxc0CBYTLTI8XnViDbmq8cj4cPhmv0rTRMbESjllfAjpEkfUc2mhDzmBOXXiKpd4tKbSQkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9NVA2PgagpoH4C20jWkrlN/z1nEFiNlRJSCBS3yVrM=;
 b=VpWU7x6kbCfQIaTMXxOQIqnPK49MPlmlPh7inrSiqirG/oTnv1Oos3OtGb0YWs8uxkvd+iY0ZmO/hzZ83tSy8FW1LWH6O46HLAUXsua+vF19bPMg/Cfz25pcjLvcl5A3vZhRMo/tYUDY3tYRD+pNE6LlIPoE4KwinpueqTtzbgA=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4330.eurprd04.prod.outlook.com (52.134.108.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:54 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 5/8] can: flexcan: add ISO CAN FD feature support
Thread-Topic: [PATCH 5/8] can: flexcan: add ISO CAN FD feature support
Thread-Index: AQHVOIgzAOUvi7LfjUiSTB+At/nJ+A==
Date:   Fri, 12 Jul 2019 08:02:51 +0000
Message-ID: <20190712075926.7357-6-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: 07a7d2ec-53e3-419c-dc63-08d7069f556d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4330;
x-ms-traffictypediagnostic: DB7PR04MB4330:
x-microsoft-antispam-prvs: <DB7PR04MB433039DBDA7C731735BAA0A3E6F20@DB7PR04MB4330.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(110136005)(25786009)(1076003)(54906003)(305945005)(3846002)(6116002)(7736002)(316002)(71200400001)(4326008)(66066001)(2906002)(66446008)(5660300002)(64756008)(66556008)(66476007)(71190400001)(2501003)(6666004)(478600001)(66946007)(2616005)(6506007)(102836004)(26005)(386003)(6436002)(186003)(6486002)(86362001)(50226002)(68736007)(256004)(14444005)(446003)(476003)(11346002)(486006)(8936002)(52116002)(76176011)(36756003)(53936002)(99286004)(14454004)(81156014)(81166006)(6512007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4330;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DzDknfSmTcYAhXmWWGH3L5013Vo/ggwOqdXYC3NkaijbV4ZHij1GPkFupfcSS+Vj6CZr7BvKY/6jKM8H8JNQYdvBhzlFbmHnKq30ETFkJaHdKkoQ11V4vO9tpglK3ZScDAXM3RennU/cXY2vX/axNu0ZYZ8sVc36BtU4zDQYlpBBcVSljJDStFzF+KYXg0c8zfPHAw9vavFPoVgKDD0TA/YKWSXm/TXorb0rFcPCBo3Leq7LpDKSk++kSEpDNM1Ef3r3VywKJ4UhZykttPF4KaNvGgOZAcC/ahEycX9MvQH+dBGqhr0HHFY4XFBqFUm9VhWW7Kd74evtEvfM819xDGUCMenU7tds3Tf2Snp9/3GXY6mFefL3gQISrNIcwSuGQd3BsNYcRjrsQA/lcjVpOa9D/U+0olvrjbZ2RvqgE4U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a7d2ec-53e3-419c-dc63-08d7069f556d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:52.6248
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

ISO CAN FD is introduced to increase the failture detection capability
than non-ISO CAN FD. The non-ISO CAN FD is still supported by FlexCAN so
that it can be used mainly during an intermediate phase, for evaluation
and development purposes.

Therefore, it is strongly recommended to configure FlexCAN to the ISO
CAN FD protocol by setting the ISOCANFDEN field in the CTRL2 register.

NOTE: If you only set "fd on", driver will use ISO FD mode by default.
You should set "fd-non-iso on" after setting "fd on" if you want to use
NON ISO FD mode.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 4956ef64944a..daf4f0e88224 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -92,6 +92,7 @@
 #define FLEXCAN_CTRL2_MRP		BIT(18)
 #define FLEXCAN_CTRL2_RRS		BIT(17)
 #define FLEXCAN_CTRL2_EACEN		BIT(16)
+#define FLEXCAN_CTRL2_ISOCANFDEN	BIT(12)
=20
 /* FLEXCAN memory error control register (MECR) bits */
 #define FLEXCAN_MECR_ECRWRDIS		BIT(31)
@@ -1297,6 +1298,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		reg_fdctrl =3D priv->read(&regs->fdctrl) & ~FLEXCAN_FDCTRL_FDRATE;
 		reg_fdctrl &=3D ~(FLEXCAN_FDCTRL_MBDSR1(0x3) | FLEXCAN_FDCTRL_MBDSR0(0x3=
));
 		reg_mcr =3D priv->read(&regs->mcr) & ~FLEXCAN_MCR_FDEN;
+		reg_ctrl2 =3D priv->read(&regs->ctrl2) & ~FLEXCAN_CTRL2_ISOCANFDEN;
=20
 		/* support BRS when set CAN FD mode
 		 * 64 bytes payload per MB and 7 MBs per RAM block by default
@@ -1306,10 +1308,14 @@ static int flexcan_chip_start(struct net_device *de=
v)
 			reg_fdctrl |=3D FLEXCAN_FDCTRL_FDRATE;
 			reg_fdctrl |=3D FLEXCAN_FDCTRL_MBDSR1(0x3) | FLEXCAN_FDCTRL_MBDSR0(0x3)=
;
 			reg_mcr |=3D FLEXCAN_MCR_FDEN;
+
+			if (!(priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO))
+				reg_ctrl2 |=3D FLEXCAN_CTRL2_ISOCANFDEN;
 		}
=20
 		priv->write(reg_fdctrl, &regs->fdctrl);
 		priv->write(reg_mcr, &regs->mcr);
+		priv->write(reg_ctrl2, &regs->ctrl2);
 	}
=20
 	if ((priv->devtype_data->quirks & FLEXCAN_QUIRK_ENABLE_EACEN_RRS)) {
@@ -1799,7 +1805,7 @@ static int flexcan_probe(struct platform_device *pdev=
)
=20
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_TIMESTAMP_SUPPORT_FD) {
 		if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
-			priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
+			priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON=
_ISO;
 			priv->can.bittiming_const =3D &flexcan_fd_bittiming_const;
 			priv->can.data_bittiming_const =3D &flexcan_fd_data_bittiming_const;
 		} else {
--=20
2.17.1

