Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DC19783D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 13:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfHULny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 07:43:54 -0400
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:61158
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726386AbfHULnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 07:43:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXbzloVfQ7pN47jljaWm9t49wWmzx6P5X0ge6ZHuysGNuBoOik1qTHzp3FJ0pOy9CfzHCTbEroHRp1uPbQBuYj+FZy2JiU85EK/ljXNCBQHHNppFSBqjDU6+fZjC4/zNXyA0REWiZ21mh4QwUzOQxVw9CffeHu75SGfrmKyy8c4cKfn30mhmSxldwLV1Cw/zaJhulka/ZWnZIf9QSEVH4EEmRnJRpxeJl0MX/h9vsmm1+y1Ka8OQtMJQXt78yYtlCkSoU5xRWd8/HKVxjSwpDU4kkZrfvKm3jQW85Xu7/1rf3RUZ6Pe0YeBoS6ljDVNGkd0NRYm/0KZzaeV84Yb7/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRhN8gi17ug1zrlFAVUIy1Dz/qhP9Aw9LDjtbLxtus0=;
 b=hn9IuWfCzkUo7sHL24isT+BD6JBXlGsLwcZYZjyv3wJ0M9hYPR4uXz6umwRvnfHym3y8tpaGH5LNjlcDJ/aC5YOUfUSdd2NPKZjw9i1apQ+h3yaUe7NK0RthgfTTqKTxjToHZy5ZvKQHtvITDMTfrPM8cewzhZhm0fBZ2zMTpzfGlIAceBRdCS8FeMay5SX2CJwqqXybIbRPC/JFjAlOq9K5HlAOxOx0cjOAxWsXMiDQUUeztB1isrl7ZWoh5UlLLyHmrQljeMMDkmbce993EmlotsSVw3t/9w+EtlB+H6QniC0fdyD3XoV5i7IhTqNpx8m+xeKeD0+dtz88IWLOng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRhN8gi17ug1zrlFAVUIy1Dz/qhP9Aw9LDjtbLxtus0=;
 b=QkNnd30Eq5/4JOCImzImx4y4z3E+2XhO7lartSI0OnyIDnqVpQhBR5Dd4xuqurTpxHnRz42CQU8kBzrnOa2RcimG5qk5eHQnDf86ozPorCn2v6ppiqv9So/574O6xWS4YGw7TLDmWCxckoFOpizJzLzwFfBEIXujaWv5XBBaPAU=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2807.eurprd04.prod.outlook.com (10.172.246.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 11:43:49 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 11:43:49 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        Marco Hartmann <marco.hartmann@nxp.com>
Subject: [PATCH v2 net-next] net: fec: add C45 MDIO read/write support
Thread-Topic: [PATCH v2 net-next] net: fec: add C45 MDIO read/write support
Thread-Index: AQHVWBWy5sM1nf/Z2EaYMo3nP8kt5A==
Date:   Wed, 21 Aug 2019 11:43:49 +0000
Message-ID: <1566387814-7034-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To DB6PR0402MB2936.eurprd04.prod.outlook.com
 (2603:10a6:4:9a::19)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1f8cdcc-9ce0-4896-53d7-08d7262cd50c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0402MB2807;
x-ms-traffictypediagnostic: DB6PR0402MB2807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB2807E762F21C4A6E1AC1B4148CAA0@DB6PR0402MB2807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(189003)(199004)(2501003)(486006)(5660300002)(71190400001)(316002)(110136005)(99286004)(64756008)(44832011)(8936002)(50226002)(476003)(2616005)(8676002)(81166006)(53936002)(81156014)(36756003)(256004)(66556008)(66476007)(71200400001)(66066001)(86362001)(478600001)(6116002)(26005)(386003)(6506007)(7049001)(55236004)(25786009)(102836004)(186003)(14454004)(14444005)(2201001)(7736002)(6436002)(66446008)(305945005)(6512007)(52116002)(66946007)(6486002)(3846002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2807;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q/BPWqbpHlqCdh9m3BGBjEd1SNffPkDwWDeNmaJxSz38pCkc4ITB8Q/E1TkhAkIDbv+3dGRU8ShJoUyYoyW5KtW35jekWDZo7zqabkIivgGFWnrsWC1PuowIu0UxnOopBxEXnr2lu50jQ+qAmboU7EOo6XWuGl4BzzIlASIPL4XluHG3MquR7FU3d645UT0iRUfJifg9ds3/lbcisfqHzbrgo4zNEALmfkEF38LPXXREfXgDKVshFNU79QYJedMmSuRzhkIzYJMqjwCcvE6kg9WZ4+11pASOVbLSAiySw3L5aTFK6ymDoDvH8QDZfJ+RArNlhnqBlU8vyM5AmnGnx5dKO/DQGoim33zuZ1x8W8pzIqdNSv135wNg1CCbyA/tAk0wcLWTer2RJbzEzqh758vUEHVyPkey9nH6cVfaa68=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A14AE377C4ACE8469A68CC666FE6C094@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f8cdcc-9ce0-4896-53d7-08d7262cd50c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 11:43:49.2545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Zo7zrQD1dkhfbkJKrLOAy01ysgiOYNMIfexJA9uXI7QiivvXc+1lZxcJADBT+dndMsL+U+6pj4y03pJpfyCQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.3ae clause 45 defines a modified MDIO protocol that uses a two
staged access model in order to increase the address space.

This patch adds support for C45 MDIO read and write accesses, which are
used whenever the MII_ADDR_C45 flag in the regnum argument is set.
In case it is not set, C22 accesses are used as before.

Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
---
Changes in v2:
- use bool variable is_c45
- add missing goto statements
---
---
 drivers/net/ethernet/freescale/fec_main.c | 70 +++++++++++++++++++++++++++=
+---
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index c01d3ec3e9af..cb3ce27fb27a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -208,8 +208,11 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
=20
 /* FEC MII MMFR bits definition */
 #define FEC_MMFR_ST		(1 << 30)
+#define FEC_MMFR_ST_C45		(0)
 #define FEC_MMFR_OP_READ	(2 << 28)
+#define FEC_MMFR_OP_READ_C45	(3 << 28)
 #define FEC_MMFR_OP_WRITE	(1 << 28)
+#define FEC_MMFR_OP_ADDR_WRITE	(0)
 #define FEC_MMFR_PA(v)		((v & 0x1f) << 23)
 #define FEC_MMFR_RA(v)		((v & 0x1f) << 18)
 #define FEC_MMFR_TA		(2 << 16)
@@ -1767,7 +1770,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus, in=
t mii_id, int regnum)
 	struct fec_enet_private *fep =3D bus->priv;
 	struct device *dev =3D &fep->pdev->dev;
 	unsigned long time_left;
-	int ret =3D 0;
+	int ret =3D 0, frame_start, frame_addr, frame_op;
+	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
=20
 	ret =3D pm_runtime_get_sync(dev);
 	if (ret < 0)
@@ -1775,9 +1779,37 @@ static int fec_enet_mdio_read(struct mii_bus *bus, i=
nt mii_id, int regnum)
=20
 	reinit_completion(&fep->mdio_done);
=20
+	if (is_c45) {
+		frame_start =3D FEC_MMFR_ST_C45;
+
+		/* write address */
+		frame_addr =3D (regnum >> 16);
+		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
+		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		       FEC_MMFR_TA | (regnum & 0xFFFF),
+		       fep->hwp + FEC_MII_DATA);
+
+		/* wait for end of transfer */
+		time_left =3D wait_for_completion_timeout(&fep->mdio_done,
+				usecs_to_jiffies(FEC_MII_TIMEOUT));
+		if (time_left =3D=3D 0) {
+			netdev_err(fep->netdev, "MDIO address write timeout\n");
+			ret =3D -ETIMEDOUT;
+			goto out;
+		}
+
+		frame_op =3D FEC_MMFR_OP_READ_C45;
+
+	} else {
+		/* C22 read */
+		frame_op =3D FEC_MMFR_OP_READ;
+		frame_start =3D FEC_MMFR_ST;
+		frame_addr =3D regnum;
+	}
+
 	/* start a read op */
-	writel(FEC_MMFR_ST | FEC_MMFR_OP_READ |
-		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
+	writel(frame_start | frame_op |
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
 		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
=20
 	/* wait for end of transfer */
@@ -1804,7 +1836,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus, i=
nt mii_id, int regnum,
 	struct fec_enet_private *fep =3D bus->priv;
 	struct device *dev =3D &fep->pdev->dev;
 	unsigned long time_left;
-	int ret;
+	int ret, frame_start, frame_addr;
+	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
=20
 	ret =3D pm_runtime_get_sync(dev);
 	if (ret < 0)
@@ -1814,9 +1847,33 @@ static int fec_enet_mdio_write(struct mii_bus *bus, =
int mii_id, int regnum,
=20
 	reinit_completion(&fep->mdio_done);
=20
+	if (is_c45) {
+		frame_start =3D FEC_MMFR_ST_C45;
+
+		/* write address */
+		frame_addr =3D (regnum >> 16);
+		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
+		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		       FEC_MMFR_TA | (regnum & 0xFFFF),
+		       fep->hwp + FEC_MII_DATA);
+
+		/* wait for end of transfer */
+		time_left =3D wait_for_completion_timeout(&fep->mdio_done,
+			usecs_to_jiffies(FEC_MII_TIMEOUT));
+		if (time_left =3D=3D 0) {
+			netdev_err(fep->netdev, "MDIO address write timeout\n");
+			ret =3D -ETIMEDOUT;
+			goto out;
+		}
+	} else {
+		/* C22 write */
+		frame_start =3D FEC_MMFR_ST;
+		frame_addr =3D regnum;
+	}
+
 	/* start a write op */
-	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
-		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
+	writel(frame_start | FEC_MMFR_OP_WRITE |
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
 		FEC_MMFR_TA | FEC_MMFR_DATA(value),
 		fep->hwp + FEC_MII_DATA);
=20
@@ -1828,6 +1885,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus, i=
nt mii_id, int regnum,
 		ret  =3D -ETIMEDOUT;
 	}
=20
+out:
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
=20
--=20
2.7.4

