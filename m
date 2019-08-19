Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97A9283C
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfHSPUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:20:02 -0400
Received: from mail-eopbgr140077.outbound.protection.outlook.com ([40.107.14.77]:7136
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726784AbfHSPUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 11:20:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTuNuZW0mm647hHdB6lU0ly9P2gIKWuAHCm4IH6QyvLLZEgyohfngMnv/NnQrpraStDvmSr00FcQa2PVW7vPB2jN2Ac2id51NO5VDLIAg+G0LnF359TriCVyaGKxIewN0BKGr8RrbcH64W9NYbNJhl8NoJYvY0LmSI5YUh3rOuzC3WpFGvJujCZN//IIHDcpRsWYHXHZePT3kMgAw1xaM4nh5FPtoTpwSfWwiVfSGelDxWPkaNuCduyWdENr+RsHhBvYRGiymd5kuo+8/D4tKdDkABnV5h5zmv8+5D/6BLaXwsIwe2TA9zR2A5P6etc1/Nea2TNIGiw+3uqkqExGbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAoPxJ11eI1FQqBLWQkACkRkaKSk7wp/51yCRlsMfEs=;
 b=E6lk2sRNfQBkWHt5Ppyr2vcy1osw07Jb0cZT5xNWSPYAgJzqhRx3b66xyMOb/Oi/5Xczbde8nImuuwQzgmr30sHQcdY+GJqN4NulMo62TRBNGShP1YwPtgErDnyKTzsNJ0KcHlyE8aL25dkBgUHS5DgTGdEixOjdTBCNdUo1+KeO5zy3TqA1Lmul98lPFPeumPmgq3qvR7z+47hewq+xJXZ7COQoJVtd+Dgju6JqiZehphg5w5Pt6Yv/vxmx6xDtRfyo9Jzw1Kwm+ujZE/CbMfzJ/jJuVkADB+CNgo9WoNm5enXkzB0nJ/lvBl0Z4T+YxhEzjNDga9VaBnyAxOo7AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAoPxJ11eI1FQqBLWQkACkRkaKSk7wp/51yCRlsMfEs=;
 b=D9WhFlvY9Tv/WmON2VIuxuPMlMlGUzVAC8U6JklTMnYciJvxK5ySLCZiUx0ycS39FEVhBpkg8AFRy6wzfSreguuXfhWw2DZioDQjtmPu03tymd+Rii6W74/IcmmYslytpc3YhK3OFlLqABLmuFIYCoFcJFBy3VT9oBHcIQAEwSQ=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3896.eurprd04.prod.outlook.com (52.133.29.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 15:19:55 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 15:19:55 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH v2 net-next 1/1] net: phy: Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Topic: [PATCH v2 net-next 1/1] net: phy: Added BASE-T1 PHY support to
 PHY Subsystem
Thread-Index: AQHVVqGOk2AKsdgFn0uKJVDdS5MDRw==
Date:   Mon, 19 Aug 2019 15:19:55 +0000
Message-ID: <20190819151940.27756-2-christian.herber@nxp.com>
References: <20190819151940.27756-1-christian.herber@nxp.com>
In-Reply-To: <20190819151940.27756-1-christian.herber@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM3PR07CA0103.eurprd07.prod.outlook.com
 (2603:10a6:207:7::13) To AM6PR0402MB3798.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae1acb7f-d072-4cb7-dcb8-08d724b8b0ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3896;
x-ms-traffictypediagnostic: AM6PR0402MB3896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB38969BF2BA4ACEEC15F72CAB86A80@AM6PR0402MB3896.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(189003)(199004)(478600001)(305945005)(4326008)(52116002)(26005)(486006)(99286004)(71200400001)(6506007)(30864003)(256004)(14444005)(6512007)(36756003)(76176011)(186003)(53936002)(55236004)(6486002)(386003)(7736002)(44832011)(14454004)(25786009)(71190400001)(2501003)(102836004)(81166006)(81156014)(1076003)(6436002)(19627235002)(5660300002)(8936002)(64756008)(8676002)(54906003)(110136005)(316002)(66946007)(6116002)(3846002)(66446008)(66556008)(66476007)(446003)(2201001)(11346002)(66066001)(2616005)(476003)(2906002)(86362001)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3896;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HtMIMPVwyuUUyH3ODCUMNBwFx9ajvB/uK+ghRWsLrisUTZkAeDSb2g6F1XkWKsvvC5eOb+8qQG0ewgX7Vx3KuFnTEk1LqrfbuRtrnQBh1XY2Z9h7SZio6pLBjhc3IkmpVxyZlMuRtk8fHiHtHQy+UXL2Pmelw2aEsDGinUnvTTMYeYjyk6t77ezM4GNqFZjB/qQ2VL1F0eXzldaG0KiygP/J17BXjYB05Kg21zI3qvNyvjJVTpYtmyG9NX0EF1OoGoFIKlL2HtV5KedPK6O4XibowKFqrhfmnMNmoLxlYvYGGGmgNuWNq2qUKxY3xY1MEROJlh5RhuBPi2cc5rzrUT1bQ9L71edgJfqlcmzZD5xwbBzveKnurHBBSzsXGid4urihMMURk0ufV+PYrUc7hLl18LaXYhtJP24QYEIaP7s=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <706062E8F332AE41ADB5B9DBEB63B445@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1acb7f-d072-4cb7-dcb8-08d724b8b0ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 15:19:55.6643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1xtv6XiL8H94lx3sSA2gZqhDMMmyAS+K9rmpGbJmGkeOGtI4cEg7K3IRHmqC+nT1zYNSqclI8omEcLKiRZgm5wG18gHPBGSWM8tVWTe2OM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3896
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BASE-T1 is a category of Ethernet PHYs.
They use a single copper pair for transmission.
This patch add basic support for this category of PHYs.
It coveres the discovery of abilities and basic configuration.
It includes setting fixed speed and enabling auto-negotiation.
BASE-T1 devices should always Clause-45 managed.
Therefore, this patch extends phy-c45.c.
While for some functions like auto-neogtiation different registers are
used, the layout of these registers is the same for the used fields.
Thus, much of the logic of basic Clause-45 devices can be reused.

Signed-off-by: Christian Herber <christian.herber@nxp.com>
---
Changes in v2:
- Added is_baset1_capable property to phydev
- Reordered functions to remove forward declarations
---
 drivers/net/phy/phy-c45.c    | 106 +++++++++++++++++++++++++++++++----
 drivers/net/phy/phy-core.c   |   4 +-
 drivers/net/phy/phy_device.c |  12 ++++
 include/linux/phy.h          |   1 +
 include/uapi/linux/ethtool.h |   2 +
 include/uapi/linux/mdio.h    |  21 +++++++
 6 files changed, 135 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b9d4145781ca..d673e1413fe6 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -8,13 +8,16 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
=20
+static u32 get_aneg_ctrl(struct phy_device *phydev);
+static u32 get_aneg_stat(struct phy_device *phydev);
+
 /**
  * genphy_c45_setup_forced - configures a forced speed
  * @phydev: target phy_device struct
  */
 int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 {
-	int ctrl1, ctrl2, ret;
+	int ctrl1, ctrl2, base_t1_ctrl =3D 0, ret;
=20
 	/* Half duplex is not supported */
 	if (phydev->duplex !=3D DUPLEX_FULL)
@@ -28,6 +31,16 @@ int genphy_c45_pma_setup_forced(struct phy_device *phyde=
v)
 	if (ctrl2 < 0)
 		return ctrl2;
=20
+	if (phydev->is_baset1_capable) {
+		base_t1_ctrl =3D phy_read_mmd(phydev,
+					    MDIO_MMD_PMAPMD,
+					    MDIO_PMA_BASET1CTRL);
+		if (base_t1_ctrl < 0)
+			return base_t1_ctrl;
+
+		base_t1_ctrl &=3D ~(MDIO_PMA_BASET1CTRL_TYPE);
+	}
+
 	ctrl1 &=3D ~MDIO_CTRL1_SPEEDSEL;
 	/*
 	 * PMA/PMD type selection is 1.7.5:0 not 1.7.3:0.  See 45.2.1.6.1
@@ -41,12 +54,21 @@ int genphy_c45_pma_setup_forced(struct phy_device *phyd=
ev)
 		break;
 	case SPEED_100:
 		ctrl1 |=3D MDIO_PMA_CTRL1_SPEED100;
-		ctrl2 |=3D MDIO_PMA_CTRL2_100BTX;
+		if (phydev->is_baset1_capable) {
+			ctrl2 |=3D MDIO_PMA_CTRL2_BT1;
+			base_t1_ctrl |=3D MDIO_PMA_BASET1CTRL_TYPE_100BT1;
+		} else {
+			ctrl2 |=3D MDIO_PMA_CTRL2_100BTX;
+		}
 		break;
 	case SPEED_1000:
 		ctrl1 |=3D MDIO_PMA_CTRL1_SPEED1000;
-		/* Assume 1000base-T */
-		ctrl2 |=3D MDIO_PMA_CTRL2_1000BT;
+		if (phydev->is_baset1_capable) {
+			ctrl2 |=3D MDIO_PMA_CTRL2_BT1;
+			base_t1_ctrl |=3D MDIO_PMA_BASET1CTRL_TYPE_1000BT1;
+		} else {
+			ctrl2 |=3D MDIO_PMA_CTRL2_1000BT;
+		}
 		break;
 	case SPEED_2500:
 		ctrl1 |=3D MDIO_CTRL1_SPEED2_5G;
@@ -75,10 +97,50 @@ int genphy_c45_pma_setup_forced(struct phy_device *phyd=
ev)
 	if (ret < 0)
 		return ret;
=20
+	if (phydev->is_baset1_capable) {
+		ret =3D phy_write_mmd(phydev,
+				    MDIO_MMD_PMAPMD,
+				    MDIO_PMA_BASET1CTRL,
+				    base_t1_ctrl);
+		if (ret < 0)
+			return ret;
+	}
 	return genphy_c45_an_disable_aneg(phydev);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_forced);
=20
+/**
+ * get_aneg_ctrl - Get the register address for auto-
+ * negotiation control register
+ * @phydev: target phy_device struct
+ *
+ */
+static u32 get_aneg_ctrl(struct phy_device *phydev)
+{
+	u32 ctrl =3D MDIO_CTRL1;
+
+	if (phydev->is_baset1_capable)
+		ctrl =3D MDIO_AN_BT1_CTRL;
+
+	return ctrl;
+}
+
+/**
+ * get_aneg_ctrl - Get the register address for auto-
+ * negotiation status register
+ * @phydev: target phy_device struct
+ *
+ */
+static u32 get_aneg_stat(struct phy_device *phydev)
+{
+	u32 stat =3D MDIO_STAT1;
+
+	if (phydev->is_baset1_capable)
+		stat =3D MDIO_AN_BT1_STAT;
+
+	return stat;
+}
+
 /**
  * genphy_c45_an_config_aneg - configure advertisement registers
  * @phydev: target phy_device struct
@@ -135,8 +197,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);
  */
 int genphy_c45_an_disable_aneg(struct phy_device *phydev)
 {
-
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev),
 				  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
@@ -151,7 +212,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
  */
 int genphy_c45_restart_aneg(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev),
 				MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
@@ -171,7 +232,7 @@ int genphy_c45_check_and_restart_aneg(struct phy_device=
 *phydev, bool restart)
=20
 	if (!restart) {
 		/* Configure and restart aneg if it wasn't set before */
-		ret =3D phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		ret =3D phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev));
 		if (ret < 0)
 			return ret;
=20
@@ -199,7 +260,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg);
  */
 int genphy_c45_aneg_done(struct phy_device *phydev)
 {
-	int val =3D phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	int val =3D phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_stat(phydev));
=20
 	return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;
 }
@@ -385,7 +446,9 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
  * PMA Extended Abilities (1.11) register, indicating 1000BASET an 10G rel=
ated
  * modes. If bit 1.11.14 is set, then the list is also extended with the m=
odes
  * in the 2.5G/5G PMA Extended register (1.21), indicating if 2.5GBASET an=
d
- * 5GBASET are supported.
+ * 5GBASET are supported. If bit 1.11.11 is set, then the list is also ext=
ended
+ * with the modes in the BASE-T1 PMA Extended register (1.18), indicating =
if
+ * 10/100/1000BASET-1 are supported.
  */
 int genphy_c45_pma_read_abilities(struct phy_device *phydev)
 {
@@ -470,6 +533,29 @@ int genphy_c45_pma_read_abilities(struct phy_device *p=
hydev)
 					 phydev->supported,
 					 val & MDIO_PMA_NG_EXTABLE_5GBT);
 		}
+
+		if (val & MDIO_PMA_EXTABLE_BASET1) {
+			val =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
+					   MDIO_PMA_BASET1_EXTABLE);
+			if (val < 0)
+				return val;
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
+					 phydev->supported,
+					 val & MDIO_PMA_BASET1_EXTABLE_100BT1);
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
+					 phydev->supported,
+					 val & MDIO_PMA_BASET1_EXTABLE_1000BT1);
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+					 phydev->supported,
+					 val & MDIO_PMA_BASET1_EXTABLE_10BT1L);
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1S_Full_BIT,
+					 phydev->supported,
+					 val & MDIO_PMA_BASET1_EXTABLE_10BT1S);
+		}
 	}
=20
 	return 0;
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 369903d9b6ec..b50576f7709a 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
=20
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 69,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 71,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -140,6 +140,8 @@ static const struct phy_setting settings[] =3D {
 	/* 10M */
 	PHY_SETTING(     10, FULL,     10baseT_Full		),
 	PHY_SETTING(     10, HALF,     10baseT_Half		),
+	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
+	PHY_SETTING(     10, FULL,     10baseT1S_Full		),
 };
 #undef PHY_SETTING
=20
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b039632de73a..b733a78b7dd5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2249,6 +2249,18 @@ static int phy_probe(struct device *dev)
 			      phydev->supported))
 		phydev->is_gigabit_capable =3D 1;
=20
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
+			      phydev->supported)) {
+		phydev->is_baset1_capable =3D 1;
+		phydev->is_gigabit_capable =3D 1;
+	}
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
+			      phydev->supported))
+		phydev->is_baset1_capable =3D 1;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
+			      phydev->supported))
+		phydev->is_baset1_capable =3D 1;
+
 	of_set_phy_supported(phydev);
 	phy_advertise_supported(phydev);
=20
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5ac7d21375ac..3e815128175b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -370,6 +370,7 @@ struct phy_device {
 	unsigned is_internal:1;
 	unsigned is_pseudo_fixed_link:1;
 	unsigned is_gigabit_capable:1;
+	unsigned is_baset1_capable:1;
 	unsigned has_fixups:1;
 	unsigned suspended:1;
 	unsigned sysfs_links:1;
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dd06302aa93e..e429cc8da31a 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1485,6 +1485,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 =3D 66,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 =3D 67,
 	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 =3D 68,
+	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 =3D 69,
+	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 =3D 70,
=20
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 0a552061ff1c..6fd5ff632b8e 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -43,6 +43,7 @@
 #define MDIO_PKGID1		14	/* Package identifier */
 #define MDIO_PKGID2		15
 #define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
+#define MDIO_PMA_BASET1_EXTABLE	18	/* BASE-T1 PMA/PMD extended ability */
 #define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
 #define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
 #define MDIO_PMA_NG_EXTABLE	21	/* 2.5G/5G PMA/PMD extended ability */
@@ -57,11 +58,16 @@
 #define MDIO_PMA_10GBT_SNR	133	/* 10GBASE-T SNR margin, lane A.
 					 * Lanes B-D are numbered 134-136. */
 #define MDIO_PMA_10GBR_FECABLE	170	/* 10GBASE-R FEC ability */
+#define MDIO_PMA_BASET1CTRL     2100 /* BASE-T1 PMA/PMD control */
 #define MDIO_PCS_10GBX_STAT1	24	/* 10GBASE-X PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT1	32	/* 10GBASE-R/-T PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
 #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
 #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
+#define MDIO_AN_BT1_CTRL	512	/* BASE-T1 auto-negotiation control */
+#define MDIO_AN_BT1_STAT	513	/* BASE-T1 auto-negotiation status */
+#define MDIO_AN_10BT1_CTRL	526	/* 10BASE-T1 auto-negotiation control */
+#define MDIO_AN_10BT1_STAT	527	/* 10BASE-T1 auto-negotiation status */
=20
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -151,6 +157,7 @@
 #define MDIO_PMA_CTRL2_100BTX		0x000e	/* 100BASE-TX type */
 #define MDIO_PMA_CTRL2_10BT		0x000f	/* 10BASE-T type */
 #define MDIO_PMA_CTRL2_2_5GBT		0x0030  /* 2.5GBaseT type */
+#define MDIO_PMA_CTRL2_BT1	        0x003D	/* BASE-T1 type */
 #define MDIO_PMA_CTRL2_5GBT		0x0031  /* 5GBaseT type */
 #define MDIO_PCS_CTRL2_TYPE		0x0003	/* PCS type selection */
 #define MDIO_PCS_CTRL2_10GBR		0x0000	/* 10GBASE-R type */
@@ -205,8 +212,16 @@
 #define MDIO_PMA_EXTABLE_1000BKX	0x0040	/* 1000BASE-KX ability */
 #define MDIO_PMA_EXTABLE_100BTX		0x0080	/* 100BASE-TX ability */
 #define MDIO_PMA_EXTABLE_10BT		0x0100	/* 10BASE-T ability */
+#define MDIO_PMA_EXTABLE_BASET1		0x0800  /* BASE-T1 ability */
 #define MDIO_PMA_EXTABLE_NBT		0x4000  /* 2.5/5GBASE-T ability */
=20
+/* PMA BASE-T1 control register. */
+#define MDIO_PMA_BASET1CTRL_TYPE         0x000f /* PMA/PMD BASE-T1 type se=
l. */
+#define MDIO_PMA_BASET1CTRL_TYPE_100BT1  0x0000 /* 100BASE-T1 */
+#define MDIO_PMA_BASET1CTRL_TYPE_1000BT1 0x0001 /* 1000BASE-T1 */
+#define MDIO_PMA_BASET1CTRL_TYPE_10BT1L  0x0002 /* 10BASE-T1L */
+#define MDIO_PMA_BASET1CTRL_TYPE_10BT1S  0x0003 /* 10BASE-T1S */
+
 /* PHY XGXS lane state register. */
 #define MDIO_PHYXS_LNSTAT_SYNC0		0x0001
 #define MDIO_PHYXS_LNSTAT_SYNC1		0x0002
@@ -281,6 +296,12 @@
 #define MDIO_PMA_NG_EXTABLE_2_5GBT	0x0001	/* 2.5GBASET ability */
 #define MDIO_PMA_NG_EXTABLE_5GBT	0x0002	/* 5GBASET ability */
=20
+/* BASE-T1 Extended abilities register. */
+#define MDIO_PMA_BASET1_EXTABLE_100BT1   0x0001  /* 100BASE-T1 ability */
+#define MDIO_PMA_BASET1_EXTABLE_1000BT1  0x0002  /* 1000BASE-T1 ability */
+#define MDIO_PMA_BASET1_EXTABLE_10BT1L   0x0004  /* 10BASE-T1L ability */
+#define MDIO_PMA_BASET1_EXTABLE_10BT1S   0x0008  /* 10BASE-T1S ability */
+
 /* LASI RX_ALARM control/status registers. */
 #define MDIO_PMA_LASI_RX_PHYXSLFLT	0x0001	/* PHY XS RX local fault */
 #define MDIO_PMA_LASI_RX_PCSLFLT	0x0008	/* PCS RX local fault */
--=20
2.17.1

