Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0405B273E5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfEWBU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:57 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:5421
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbfEWBUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uAzXV8JMOWsId2yIrQ4zG605K6vTgw7EUDy6poptFc=;
 b=CTObZHEYA6+NjiMxzoM8mLCdpNd+ffVNN9yHvpvjxAo0JxKeKCRp2M3DVRJfg1q/ehklKnl/juu3fSBcy9m2TiBvJjbxAeoTSnVFjMGNa3zpLkFT+d0H8jWp2TL0BCuVX/0KBX8G+00Gldxz+T4uHl6mJMKhThD9JAEAEDDuLPE=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:37 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:37 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [RFC PATCH net-next 1/9] net: phy: Add phy_sysfs_create_links helper
 function
Thread-Topic: [RFC PATCH net-next 1/9] net: phy: Add phy_sysfs_create_links
 helper function
Thread-Index: AQHVEQW6ka0B/USdJUSpLPDAdytcPw==
Date:   Thu, 23 May 2019 01:20:37 +0000
Message-ID: <20190523011958.14944-2-ioana.ciornei@nxp.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
In-Reply-To: <20190523011958.14944-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P18901CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::19) To VI1PR0402MB2800.eurprd04.prod.outlook.com
 (2603:10a6:800:b8::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [5.12.225.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 180851e6-2db8-4a5d-2bd8-08d6df1cdc6b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677D8E06DD967DC5C415ECAE0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(5024004)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: haFmn2NygSBuC2FbbQkl0aygB7NWIxvsECIC5wtCF1hmRxaeu68ec/F8/YQ/zdAaHNyZaGj4I4M9qMR9X1jZuwpWqNRwv71oKXUUxZUPUqVj6qT93s3V8W4VHpitBJCJsGFukgVCQeKdESv6slomlHfNKRzpwgFeFtfF7hp1TGjHw0Qu0pLTlfoXWJdCiMn1fRvNGTpiKLH0qyOqiJ33405fcArhNy8mo3M3cp5FSpacsewnecNwLYlMebLsICY4hcDjyu6jo6OuucZnA9BNd32Ut9LXkmefGWquztdNIWNJDvjO4c/flHmQOtBTgppOej+WWeyrjQ3S7KsybUsWWlW4kIitA4prrRFH5VwcQ+Jl8HeKx00qkkJ+sGx3sVrtmqPpA/zeQACt7uFFQ/xSyXouuKZ2Ad904jY/1M73Hkc=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <DEED1443F0075F428C529721059BD460@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180851e6-2db8-4a5d-2bd8-08d6df1cdc6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:37.2685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

This is a cosmetic patch that wraps the operation of creating sysfs
links between the netdev->phydev and the phydev->attached_dev.

This is needed to keep the indentation level in check in a follow-up
patch where this function will be guarded against the existence of a
phydev->attached_dev.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/phy/phy_device.c | 43 ++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index dcc93a873174..5cb01b9db7b5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1133,6 +1133,31 @@ void phy_attached_print(struct phy_device *phydev, c=
onst char *fmt, ...)
 }
 EXPORT_SYMBOL(phy_attached_print);
=20
+static void phy_sysfs_create_links(struct phy_device *phydev)
+{
+	struct net_device *dev =3D phydev->attached_dev;
+	int err;
+
+	err =3D sysfs_create_link(&phydev->mdio.dev.kobj, &dev->dev.kobj,
+				"attached_dev");
+	if (err)
+		return;
+
+	err =3D sysfs_create_link_nowarn(&dev->dev.kobj,
+				       &phydev->mdio.dev.kobj,
+				       "phydev");
+	if (err) {
+		dev_err(&dev->dev, "could not add device link to %s err %d\n",
+			kobject_name(&phydev->mdio.dev.kobj),
+			err);
+		/* non-fatal - some net drivers can use one netdevice
+		 * with more then one phy
+		 */
+	}
+
+	phydev->sysfs_links =3D true;
+}
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device point=
er
  * @dev: network device to attach
@@ -1216,23 +1241,7 @@ int phy_attach_direct(struct net_device *dev, struct=
 phy_device *phydev,
 	 */
 	phydev->sysfs_links =3D false;
=20
-	err =3D sysfs_create_link(&phydev->mdio.dev.kobj, &dev->dev.kobj,
-				"attached_dev");
-	if (!err) {
-		err =3D sysfs_create_link_nowarn(&dev->dev.kobj,
-					       &phydev->mdio.dev.kobj,
-					       "phydev");
-		if (err) {
-			dev_err(&dev->dev, "could not add device link to %s err %d\n",
-				kobject_name(&phydev->mdio.dev.kobj),
-				err);
-			/* non-fatal - some net drivers can use one netdevice
-			 * with more then one phy
-			 */
-		}
-
-		phydev->sysfs_links =3D true;
-	}
+	phy_sysfs_create_links(phydev);
=20
 	phydev->dev_flags =3D flags;
=20
--=20
2.21.0

