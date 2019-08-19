Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4AA94B60
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfHSRLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:11:21 -0400
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:20964
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfHSRLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:11:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIifoybuavI02MPOrRcI5yshEepivaWREPjIHpFXBNadTdRpkEWovVwcHnIZ79NXuX6HpZY2v47k9KcKjsEd8bz7Wl+E0+2PhwTMMEO1RAJzvUi6T04LRrVoCVktJvM4tjFsYZ8XqGHH0ZnoJUZldmlhOwdLT7o08AZq3cD4FaBfrpI9ZvylcillMME2u/DY1iUOh12Htt2QRj0xaZhH8B+B3BdZmlKgBxcA5MCAy0htK5CzSZBC5EBtT32TzgkjIw5e8O/1ABvRb85XHDQWdgquGgFRj7iSGY2Psb90Pvqpg5Zhc8hpXYLVGeZzHdPAkl5d+uAL9yyMGd64eslqiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFGqa4DfypwVWpkFRp7ZAYGqO7CtAsgmgJduf3zUHPI=;
 b=hEOAoxetjJMmZvvkv4ozbnN1gFflRDqp8NkY/WJDJK94BsypZHH4c5PsIkaH27OXcgI5l+25BpyjdynKsoFKB1hIpVvoZWGjmz36uvrxmYVVAM3qUmXl7ig6zCIC+uvxxZJ5wOwVW4UhxM9kMYYp0FbXrNxeKR6rH+IwSHJdvgHFJh9Q+Zae+vbPYaTDv7KNc7xszsM7CBXNQ31noIyQTkKqOF605u2vMM3NjHs/hsUe/G4yki77kg0AK+wlnP3o6frnWUElGlqXYPsj0DK0ggYUxAR1pj/uarN99+S0ssLOoOWZt+zCEcXURzeMIQ+LnMNnOWhaxCLmwB7nomLE2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFGqa4DfypwVWpkFRp7ZAYGqO7CtAsgmgJduf3zUHPI=;
 b=mZQUOZQSL1/d5B+fazjtrr++vNerPWb2LtEHSrWpVJ6mrwd1/Ep390TpllaEm6cbJd178TfyEhWCMr35L9ZPypNrY6AFlOj23aGprc0fGS38DXrsnvJo9/hxICZ7k1E4X7ZtthrdYQLBdpdOj8+MYOGssxCWZ/ak/om5Htl57rU=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2888.eurprd04.prod.outlook.com (10.172.248.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 17:11:15 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 17:11:15 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     Marco Hartmann <marco.hartmann@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH net-next 1/1] fec: add C45 MDIO read/write support
Thread-Topic: [PATCH net-next 1/1] fec: add C45 MDIO read/write support
Thread-Index: AQHVVrEbELPNNXpxt0CfMgo+jLB/5Q==
Date:   Mon, 19 Aug 2019 17:11:14 +0000
Message-ID: <1566234659-7164-2-git-send-email-marco.hartmann@nxp.com>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
In-Reply-To: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0109.eurprd05.prod.outlook.com
 (2603:10a6:207:2::11) To DB6PR0402MB2936.eurprd04.prod.outlook.com
 (2603:10a6:4:9a::19)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9446a763-53d1-461b-e743-08d724c83dfa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0402MB2888;
x-ms-traffictypediagnostic: DB6PR0402MB2888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB28888274CA1F506680264CCE8CA80@DB6PR0402MB2888.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(199004)(189003)(66066001)(25786009)(66556008)(478600001)(66446008)(14454004)(64756008)(66476007)(53936002)(3846002)(6116002)(2906002)(446003)(52116002)(76176011)(5660300002)(6506007)(6486002)(386003)(7736002)(14444005)(55236004)(256004)(26005)(305945005)(66946007)(44832011)(86362001)(2201001)(71190400001)(71200400001)(2501003)(6636002)(102836004)(99286004)(186003)(316002)(81156014)(81166006)(110136005)(8936002)(36756003)(8676002)(50226002)(6512007)(486006)(6436002)(476003)(11346002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2888;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X+Gh0Idi5CfZMLW4r8SMeqmzFNUoTghzgNcS6C05Y1W2IDGOEtB8LPjSQFnoBQ7ItO9w84BdEvG9g5OPt1LgZZ5+7X83ii5+l8gbk0AtAsYPi6qoFBaD+CatXwDphtMi2Hk9kxF5AdG/YvOAaPH3P72NOTthynTzZHKj888/0L743EEodVq6A2/eabOnVD2HnVvj2cpqIHwZeniRdc0NNW5Wh9LuOxup0bGy3E8nvNgZreiOktbW+nVu4mIxrVmnBa3OdvjjwtDopu0fXSWbEOypS20WuslEMN1wzCeBGElSSxNBHgoYF/hr2PTN03wuWYtr32w/7jYfaa8R8a6Y46ViL6TTn3S8H3ubipD5/ENh5XIToKDUY29csBnvLIzYjH+H5Qvv+PLElJ+ScoNq2+3OQqDwgAg99kThUxF8XOE=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <11F7CB2CF01A814AAF50B3A7F203480A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9446a763-53d1-461b-e743-08d724c83dfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 17:11:14.9996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rI9CTuv/Lbx82TcvCfmYqxKs7GLGU1qSpWO6SaBWsPQKpzoW0yVl6D881kvnIFpqsimFW2zut727cQtScQrW4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2888
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.3ae clause 45 defines a modified MDIO protocol that uses a two
staged access model in order to increase the address space.

This patch adds support for C45 MDIO read and write accesses, which are
used whenever the MII_ADDR_C45 flag in the regnum argument is set.
In case it is not set, C22 accesses are used as before.

Co-developed-by: Christian Herber <christian.herber@nxp.com>
Signed-off-by: Christian Herber <christian.herber@nxp.com>
Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 65 +++++++++++++++++++++++++++=
+---
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index c01d3ec3e9af..73f8f9a149a1 100644
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
@@ -1767,7 +1770,7 @@ static int fec_enet_mdio_read(struct mii_bus *bus, in=
t mii_id, int regnum)
 	struct fec_enet_private *fep =3D bus->priv;
 	struct device *dev =3D &fep->pdev->dev;
 	unsigned long time_left;
-	int ret =3D 0;
+	int ret =3D 0, frame_start, frame_addr, frame_op;
=20
 	ret =3D pm_runtime_get_sync(dev);
 	if (ret < 0)
@@ -1775,9 +1778,36 @@ static int fec_enet_mdio_read(struct mii_bus *bus, i=
nt mii_id, int regnum)
=20
 	reinit_completion(&fep->mdio_done);
=20
+	if (MII_ADDR_C45 & regnum) {
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
+			ret  =3D -ETIMEDOUT;
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
@@ -1804,7 +1834,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus, i=
nt mii_id, int regnum,
 	struct fec_enet_private *fep =3D bus->priv;
 	struct device *dev =3D &fep->pdev->dev;
 	unsigned long time_left;
-	int ret;
+	int ret, frame_start, frame_addr;
=20
 	ret =3D pm_runtime_get_sync(dev);
 	if (ret < 0)
@@ -1814,9 +1844,32 @@ static int fec_enet_mdio_write(struct mii_bus *bus, =
int mii_id, int regnum,
=20
 	reinit_completion(&fep->mdio_done);
=20
+	if (MII_ADDR_C45 & regnum) {
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
+			ret  =3D -ETIMEDOUT;
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
--=20
2.7.4

