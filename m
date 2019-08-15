Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D408EF5C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbfHOPcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:32:35 -0400
Received: from mail-eopbgr20044.outbound.protection.outlook.com ([40.107.2.44]:11366
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729770AbfHOPcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 11:32:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Snko4jS7+SXwM2xh3Zh2X1ym1YKAYyeDrg5zpR7b09wRcZyLGUNfiTmJs+DklXS3xtLAReI0TCevhqQ1ds5gdCgzGAUiWWGEE6f1tsBHc63TJ1FRjcig4mfGLhpyHnVbfzh9vpgHzzKVPhhaoyhybH2HJ+7rixXm0xbszi8pyPwIOrUYghyM+sqGrwXLO6e6Lrj9v9QL74yWG2qA0jb6BzpRRldeOP3In6YvxjwErQ8fqw5CRsOIk7RGLcPeBCi1FSx+sro5zXaFrIkpl07tBlNoHhdPVrtW8hJOfoKZiBjt7Pz4phkjdRULKVsDMeLaRBSAlixh1bcikFzel03vLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGfkL1N2FSkG6gR6T0mq7sp2JE5iyymPc8OQKewxENs=;
 b=LdPJ601LR0HH64MgZXO573lvgYMfJmWjRX11g5sEeuZURVW5gF73qyX9C2MwAr1iEGnRCHv1iQ0qQwnh/J04PK/nkBr/tmJq8DNgD7Zyzq02tzdgtnyUDq9dhmlkYD7t1MpACbYuP1S3i9OblKqfkhKCrKJBqVTbQhxHviGhIItbpQjIT1SQ3KKbllS4X7y6ba5sWpgXMohgSqnYyIpZLWk/x8UQxvo6lAMZIK23pC5kVAlCXgqXnQuBTtVfpCIFYCd0D1/MPbQUupPfZAch9co0C+Qlt23pxVf2amHmaCacP1OBhB5MloqOIN3VQLRMdBK0ws6eTSQz5UlpLIUWrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGfkL1N2FSkG6gR6T0mq7sp2JE5iyymPc8OQKewxENs=;
 b=lNJ6vb4pghy+VKybxbcLnD0NZrDv6W3IahDjgjJXT5RPs4ijDhYfocLBebjkAZY36w0H6AJef0GUx/3WZnLKoLvwdz/0LN0Ddz8jJdiYaqIYTkZNBa4jiHi5/+E5gDVGGcAqjWEclGhBtscOFYDpsuUks8nariuVw+bGdioxs9A=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3624.eurprd04.prod.outlook.com (52.133.18.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 15:32:30 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 15:32:29 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY Subsystem
Thread-Topic: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY Subsystem
Thread-Index: AQHVU36mdpwX4yyX/0O62UH8/z+9iA==
Date:   Thu, 15 Aug 2019 15:32:29 +0000
Message-ID: <20190815153209.21529-2-christian.herber@nxp.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
In-Reply-To: <20190815153209.21529-1-christian.herber@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM0PR0102CA0030.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::43) To AM6PR0402MB3798.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40a23acd-685b-4b40-004c-08d72195c8b2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3624;
x-ms-traffictypediagnostic: AM6PR0402MB3624:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB3624F7BCCB3133CED870D68F86AC0@AM6PR0402MB3624.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(199004)(189003)(8676002)(5640700003)(36756003)(2616005)(476003)(8936002)(50226002)(14454004)(54906003)(11346002)(446003)(316002)(7736002)(5660300002)(2351001)(30864003)(66066001)(478600001)(3846002)(6116002)(2906002)(81166006)(81156014)(71190400001)(71200400001)(1730700003)(2501003)(6512007)(1076003)(6486002)(44832011)(66556008)(64756008)(66446008)(66476007)(14444005)(66946007)(53936002)(256004)(486006)(305945005)(6916009)(76176011)(52116002)(6436002)(86362001)(55236004)(25786009)(6506007)(19627235002)(386003)(26005)(102836004)(99286004)(186003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3624;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QTXGtstYiOAA75sMzY0w0u8HqJt7fJAAahe5GzDWBVVASSTHYUNS4DUHF1PjrpxrtkxDbGo00FucnNeY3aIFwr8wV/N6YsXw5SrbsZHAy8ZINiMammnbkzOlEjCLs+qAP7tqIkafj0sUTk20IepsP2PGzkGJ1b0n0dgG4W0nr/qRUt/EiPCSedDpQ+wv54iwbW9Q6uf1c4HWVA+ZwiIIUpLTRP/sdAXJolgNleZJLCMZCG2mBqBZm8bGWjooSNDMAbuMYhDK05J4HBPBxK8cJSET/dKmp+RQqg1j6uVJGLKR+vwymzYiaxMiJkmw4fNy8yUYhMUMZdwzaOIm50WefCmHZLEEpCidJTteGC/LaEjgtf8lwOo+yhmsg98wsLpOkOrbu+WJ+7cv9MNB5JER3zxVIENeFQMDA+TkdzJ+i3E=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4001154895E3D34EAE3DFD7FEE91CD4E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a23acd-685b-4b40-004c-08d72195c8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 15:32:29.8456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GjX8u/Z15SxoXCJTwoLMOgFynwgQGPoLNIFozVH4YI8omqvz/zPh0xfdlu9i1g+3pDoFvKmzADyReL1xoLWBdU7GdtJCTVNdlqsLd3WXgcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3624
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
 drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
 drivers/net/phy/phy-core.c   |   4 +-
 include/uapi/linux/ethtool.h |   2 +
 include/uapi/linux/mdio.h    |  21 +++++++
 4 files changed, 129 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b9d4145781ca..9ff0b8c785de 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -8,13 +8,23 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
=20
+#define IS_100BASET1(phy) (linkmode_test_bit( \
+			   ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \
+			   (phy)->supported))
+#define IS_1000BASET1(phy) (linkmode_test_bit( \
+			    ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \
+			    (phy)->supported))
+
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
@@ -28,6 +38,16 @@ int genphy_c45_pma_setup_forced(struct phy_device *phyde=
v)
 	if (ctrl2 < 0)
 		return ctrl2;
=20
+	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev)) {
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
@@ -41,12 +61,21 @@ int genphy_c45_pma_setup_forced(struct phy_device *phyd=
ev)
 		break;
 	case SPEED_100:
 		ctrl1 |=3D MDIO_PMA_CTRL1_SPEED100;
-		ctrl2 |=3D MDIO_PMA_CTRL2_100BTX;
+		if (IS_100BASET1(phydev)) {
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
+		if (IS_1000BASET1(phydev)) {
+			ctrl2 |=3D MDIO_PMA_CTRL2_BT1;
+			base_t1_ctrl |=3D MDIO_PMA_BASET1CTRL_TYPE_1000BT1;
+		} else {
+			ctrl2 |=3D MDIO_PMA_CTRL2_1000BT;
+		}
 		break;
 	case SPEED_2500:
 		ctrl1 |=3D MDIO_CTRL1_SPEED2_5G;
@@ -75,6 +104,14 @@ int genphy_c45_pma_setup_forced(struct phy_device *phyd=
ev)
 	if (ret < 0)
 		return ret;
=20
+	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev)) {
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
@@ -135,8 +172,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);
  */
 int genphy_c45_an_disable_aneg(struct phy_device *phydev)
 {
-
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev),
 				  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
@@ -151,7 +187,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
  */
 int genphy_c45_restart_aneg(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev),
 				MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
@@ -171,7 +207,7 @@ int genphy_c45_check_and_restart_aneg(struct phy_device=
 *phydev, bool restart)
=20
 	if (!restart) {
 		/* Configure and restart aneg if it wasn't set before */
-		ret =3D phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		ret =3D phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev));
 		if (ret < 0)
 			return ret;
=20
@@ -199,7 +235,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg);
  */
 int genphy_c45_aneg_done(struct phy_device *phydev)
 {
-	int val =3D phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	int val =3D phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_stat(phydev));
=20
 	return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;
 }
@@ -385,7 +421,9 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
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
@@ -470,6 +508,29 @@ int genphy_c45_pma_read_abilities(struct phy_device *p=
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
@@ -509,6 +570,38 @@ int genphy_c45_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_status);
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
+	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))
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
+	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))
+		stat =3D MDIO_AN_BT1_STAT;
+
+	return stat;
+}
+
 /* The gen10g_* functions are the old Clause 45 stub */
=20
 int gen10g_config_aneg(struct phy_device *phydev)
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

