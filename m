Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA41273E8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbfEWBVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:21:03 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKXLI8LZP3mvoxWJLTOYXXX5jX8l4mVBtl3lhiuTu3E=;
 b=XS9UBe0Iq7FcGrB41ljRRrpKyqfWbKLwp7gbGN5pV0WbnDxCnbbXeLFH3GDr+lEsVQ3BHx6qB3JF/a2et+AAbpygpzrDMUIjBPu09MgTJUKKi9vrko1O/RBZgcgwBGbA/+DpbCwl+aAyi5TZmvxp7OVjuyb5CPd9rEjMWoH998E=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:43 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:43 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC PATCH net-next 9/9] net: dsa: sja1105: Fix broken fixed-link
 interfaces on user ports
Thread-Topic: [RFC PATCH net-next 9/9] net: dsa: sja1105: Fix broken
 fixed-link interfaces on user ports
Thread-Index: AQHVEQW9DS1DMtkTyEezAnqhFkmpow==
Date:   Thu, 23 May 2019 01:20:43 +0000
Message-ID: <20190523011958.14944-10-ioana.ciornei@nxp.com>
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
x-ms-office365-filtering-correlation-id: e59ca706-0b43-41d2-260e-08d6df1ce013
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677097D5A29F139FF637D05E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jx4AVBYmDt9Lx0gp55sknhQDHtYskdM+5YB///cHTuwJ2H2XFt3kEIWlYhFQuYZ77IHS5dVLCH7feVpLF70bEWM3PxaEP0ynrDZZMMpzuDFYETzXC5dTDzL9nltxmWOYWU+P1FAJOn/djq9PE3VQrGZAtUC9ZGiaeEISA4GDxUfo23aV3uMsPRpKyra99gTrT2tQOkz1Mmcw7G1JTAFl/dl3qv958zpwZvRbwc9tFvxA8UEcFi1LGGr1U5Ra64Tq9WFIbQttOzyUSI4mLRBJ+fFJ5a8GHSOX/pZJ/AsVepty1YsbPq11UdYqG1AE3n4bXZQcEBQpC1o3VIF7Bz2so+pGzeEEEZhSqR/YmWzTtN0tQ1mqG2bHnh8543hESBjRc2ii6Ey+nr5Vg6/QgKAHOaA6pP38QurXzUS+TH4IsTM=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <8815CBCC343E864B8EEE7ABCAD9B6F3A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59ca706-0b43-41d2-260e-08d6df1ce013
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:43.3935
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

PHYLIB and PHYLINK handle fixed-link interfaces differently. PHYLIB
wraps them in a software PHY ("pseudo fixed link") phydev construct such
that .adjust_link driver callbacks see an unified API. Whereas PHYLINK
simply creates a phylink_link_state structure and passes it to
.mac_config.

At the time the driver was introduced, DSA was using PHYLIB for the
CPU/cascade ports (the ones with no net devices) and PHYLINK for
everything else.

As explained below:

commit aab9c4067d2389d0adfc9c53806437df7b0fe3d5
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Thu May 10 13:17:36 2018 -0700

  net: dsa: Plug in PHYLINK support

  Drivers that utilize fixed links for user-facing ports (e.g: bcm_sf2)
  will need to implement phylink_mac_ops from now on to preserve
  functionality, since PHYLINK *does not* create a phy_device instance
  for fixed links.

In the above patch, DSA guards the .phylink_mac_config callback against
a NULL phydev pointer.  Therefore, .adjust_link is not called in case of
a fixed-link user port.

This patch fixes the situation by converting the driver from using
.adjust_link to .phylink_mac_config.  This can be done now in a unified
fashion for both slave and CPU/cascade ports because DSA now uses
PHYLINK for all ports.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja11=
05/sja1105_main.c
index 0663b78a2f6c..cfdefd9f1905 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -734,15 +734,16 @@ static int sja1105_adjust_port_config(struct sja1105_=
private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
=20
-static void sja1105_adjust_link(struct dsa_switch *ds, int port,
-				struct phy_device *phydev)
+static void sja1105_mac_config(struct dsa_switch *ds, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
 {
 	struct sja1105_private *priv =3D ds->priv;
=20
-	if (!phydev->link)
+	if (!state->link)
 		sja1105_adjust_port_config(priv, port, 0, false);
 	else
-		sja1105_adjust_port_config(priv, port, phydev->speed, true);
+		sja1105_adjust_port_config(priv, port, state->speed, true);
 }
=20
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
@@ -1515,9 +1516,9 @@ static int sja1105_set_ageing_time(struct dsa_switch =
*ds,
 static const struct dsa_switch_ops sja1105_switch_ops =3D {
 	.get_tag_protocol	=3D sja1105_get_tag_protocol,
 	.setup			=3D sja1105_setup,
-	.adjust_link		=3D sja1105_adjust_link,
 	.set_ageing_time	=3D sja1105_set_ageing_time,
 	.phylink_validate	=3D sja1105_phylink_validate,
+	.phylink_mac_config	=3D sja1105_mac_config,
 	.get_strings		=3D sja1105_get_strings,
 	.get_ethtool_stats	=3D sja1105_get_ethtool_stats,
 	.get_sset_count		=3D sja1105_get_sset_count,
--=20
2.21.0

