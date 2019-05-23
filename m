Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2876E273E3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfEWBUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:52 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm2oYE1rcUJkQj55BQHORYpyZsRACuN8y4ewln+WphY=;
 b=HHoEqwbrj0ibTykziagXE6IXlJQb3oKUAEblq5dqRQRrGBHnRN4jLlq3iK2rw7cvmzLwe9Sc9I0jLI15wbx6OvAQxTX8vbwrIxSIQMsQdKnRPhbbuafV+RGUZTG3ZMORlgp8+RwtTfksjM7cyIDDub3rMsMHp17bCg7yGH9KrxY=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:39 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:39 +0000
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
Subject: [RFC PATCH net-next 4/9] net: phylink: Add phylink_mac_link_{up,down}
 wrapper functions
Thread-Topic: [RFC PATCH net-next 4/9] net: phylink: Add
 phylink_mac_link_{up,down} wrapper functions
Thread-Index: AQHVEQW75UFmDToYo0yQOLuc7h77EA==
Date:   Thu, 23 May 2019 01:20:39 +0000
Message-ID: <20190523011958.14944-5-ioana.ciornei@nxp.com>
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
x-ms-office365-filtering-correlation-id: ecc1ff6e-5b74-4caa-4c65-08d6df1cddee
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677C6A5F2E0A16E21FAFA25E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZUkfXhcp6Tl6S4dIYrpCW9TWeSCxZYAfOfLXfq4FbatoNQO9lfekoSc1dtzWFWTVAZngA2rFwIErh+o4VkMYB1DKzJ0MTooEablF7yy6YGPOszl7H382t6uHo8N7FagIbSdWXLy1F4LsnuzOZmsuSmwjn9GSEMiX10VNmGfdWEOHtPTQVDNojsSom/Kp26mJxu4ZU1fmx1DUmUUQe25H7goDIlaHU0gLK/PEAZIeZgg8bHdQep9SY9uHScG2x0dzCGoTCqVPykeTpJaX1Eh2rUGIs8+QUDxcR3nzm9f5qLmA67R167lqXuW64U1jd5heQ2nsbhOH9OF7jRmkOV0SGJKDRT6x1oIROnRbol8hzaeFWLpcxRQuQxDCRWKMxMRkqlsrWOkl1hCV4AiEopDVrm/RDKkWspiZkhye+XZBx0M=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5B6B6497E921FB42AE4BE7BC86F96F8C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc1ff6e-5b74-4caa-4c65-08d6df1cddee
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:39.8657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch that reduces the clutter in phylink_resolve
around calling the .mac_link_up/.mac_link_down driver callbacks.  In a
further patch this logic will be extended to emit notifications in case
a net device does not exist.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phylink.c | 50 +++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 89750c7dfd6f..68cfe31240cc 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -395,6 +395,34 @@ static const char *phylink_pause_to_str(int pause)
 	}
 }
=20
+static void phylink_mac_link_up(struct phylink *pl,
+				struct phylink_link_state link_state)
+{
+	struct net_device *ndev =3D pl->netdev;
+
+	pl->ops->mac_link_up(ndev, pl->link_an_mode,
+			     pl->phy_state.interface,
+			     pl->phydev);
+
+	netif_carrier_on(ndev);
+
+	netdev_info(ndev,
+		    "Link is Up - %s/%s - flow control %s\n",
+		    phy_speed_to_str(link_state.speed),
+		    phy_duplex_to_str(link_state.duplex),
+		    phylink_pause_to_str(link_state.pause));
+}
+
+static void phylink_mac_link_down(struct phylink *pl)
+{
+	struct net_device *ndev =3D pl->netdev;
+
+	netif_carrier_off(ndev);
+	pl->ops->mac_link_down(ndev, pl->link_an_mode,
+			       pl->phy_state.interface);
+	netdev_info(ndev, "Link is Down\n");
+}
+
 static void phylink_resolve(struct work_struct *w)
 {
 	struct phylink *pl =3D container_of(w, struct phylink, resolve);
@@ -450,24 +478,10 @@ static void phylink_resolve(struct work_struct *w)
 	}
=20
 	if (link_state.link !=3D netif_carrier_ok(ndev)) {
-		if (!link_state.link) {
-			netif_carrier_off(ndev);
-			pl->ops->mac_link_down(ndev, pl->link_an_mode,
-					       pl->phy_state.interface);
-			netdev_info(ndev, "Link is Down\n");
-		} else {
-			pl->ops->mac_link_up(ndev, pl->link_an_mode,
-					     pl->phy_state.interface,
-					     pl->phydev);
-
-			netif_carrier_on(ndev);
-
-			netdev_info(ndev,
-				    "Link is Up - %s/%s - flow control %s\n",
-				    phy_speed_to_str(link_state.speed),
-				    phy_duplex_to_str(link_state.duplex),
-				    phylink_pause_to_str(link_state.pause));
-		}
+		if (!link_state.link)
+			phylink_mac_link_down(pl);
+		else
+			phylink_mac_link_up(pl, link_state);
 	}
 	if (!link_state.link && pl->mac_link_dropped) {
 		pl->mac_link_dropped =3D false;
--=20
2.21.0

