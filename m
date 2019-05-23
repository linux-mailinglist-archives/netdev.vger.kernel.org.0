Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF3273E6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfEWBU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:59 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZE1HEs855IKvG1tej4rexC+BzZUTipRRpFOrexWja8=;
 b=FOXQv8tRZ1x6fEQpYOUStxHb8Y+8nBVEjLQxFJlMULkOpe2zzhvgUKoVa854AdBoknhVpDf7PutEqbX23qTHVyjUmqLvppM8Qmv2wNgVpmT7xnBNin46NmEgMr/8c66a0ORJZgFLDqPDjfzNfI9BuWlWuM5sdTWNlQ124PjZ+/E=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:41 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:41 +0000
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
Subject: [RFC PATCH net-next 6/9] net: phylink: Make fixed link notifier calls
 edge-triggered
Thread-Topic: [RFC PATCH net-next 6/9] net: phylink: Make fixed link notifier
 calls edge-triggered
Thread-Index: AQHVEQW8B3YiCXx0IE+aCfWuomIaRw==
Date:   Thu, 23 May 2019 01:20:41 +0000
Message-ID: <20190523011958.14944-7-ioana.ciornei@nxp.com>
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
x-ms-office365-filtering-correlation-id: 04584d4d-8581-4cb1-9fa5-08d6df1cdec5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB367716AB0B13845940E14E3EE0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(14444005)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: em1czy2CJZLfzmplp/W0u5biNfo4CGul8Gf/XflxfK7ODVYgcFYgiMO2Gz7LQ5ktRs8WWZ12SLZBDRpU34b2V3pCl9+xrroFPe0FVmviC4Po9R+6CV4Z6StZ7GCuRWHtzpES3OKvHzO+/S2guTnRbdrZkY5TMcD/74tarT0fspf6dmg6Mgf5PwEcdqBjmbjkBHK+vxR4nyOBApPZRHx3xXLxuj9eMfk+CRd9PiE0WV2vKRkp3DjaQVlK3v+PTBjo5r7WMnXAzys/CVlmTB3x8nKvcrHgM7s4zu6uxZck7ea6DtQ1UeWLnuElHoxBlRC1qr233jiJJqCCE428SNrptyhAqLAVORNkUpglJSp53WhWBWTPRYZ/bcxFkhr+e0w5rlaTVmsRpdU16WNrTRv4ylZVLIVeNDpdsMXmDt9pCvg=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9BA0AA7583D09644B887C91BA1B62D6A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04584d4d-8581-4cb1-9fa5-08d6df1cdec5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:41.2318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise .mac_link_up and .mac_link_down on fixed-link interfaces are
called every second.

On a raw phylink instance we cannot call netdev_carrier_ok for an
indication of the last state of the link, so keep track and update this
in a new field of the phylink structure.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phylink.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7b6b233c1a07..3bc91b249990 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -44,6 +44,7 @@ struct phylink {
 	const struct phylink_mac_ops *ops;
 	struct notifier_block *nb;
 	struct blocking_notifier_head notifier_chain;
+	unsigned int old_link_state:1;
=20
 	unsigned long phylink_disable_state; /* bitmask of disables */
 	struct phy_device *phydev;
@@ -499,6 +500,7 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink *pl =3D container_of(w, struct phylink, resolve);
 	struct phylink_link_state link_state;
 	struct net_device *ndev =3D pl->netdev;
+	int link_changed;
=20
 	mutex_lock(&pl->state_mutex);
 	if (pl->phylink_disable_state) {
@@ -548,10 +550,13 @@ static void phylink_resolve(struct work_struct *w)
 		}
 	}
=20
-	/* Take the branch without checking the carrier status
-	 * if there is no netdevice.
-	 */
-	if (!pl->ops || link_state.link !=3D netif_carrier_ok(ndev)) {
+	if (pl->ops)
+		link_changed =3D (link_state.link !=3D netif_carrier_ok(ndev));
+	else
+		link_changed =3D (link_state.link !=3D pl->old_link_state);
+
+	if (link_changed) {
+		pl->old_link_state =3D link_state.link;
 		if (!link_state.link)
 			phylink_mac_link_down(pl);
 		else
--=20
2.21.0

