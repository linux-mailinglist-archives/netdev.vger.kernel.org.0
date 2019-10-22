Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6007E0289
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbfJVLLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:11:15 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:23270
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730450AbfJVLLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 07:11:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIot5PElyvtX7sOc0JopzgMfVuBZCyzpkqwGwRXrfz/OwDxjkIA/NE06nyqCkTV9I9tRNixqBbe2n76hs0KDRwCoC6ZiT1xwzNne9eStf/BQYp8/7CDxUDGLRcRKWCwXPwZq0uOv1ULSh0NqJZouI7iRaP0ig0hYjmKGAnDhLOULBCj9IOQSWlqAlEYcYkXj+/44zTznUDPmT7WHqoALN71BUOv4ob2NwwowX47ROCg7+7xQaxzQjCIMv8pOU83Pph81+cFzpb40Xzc8PzcwX3/Dolp2AoQ9G1SZVi3SRxYhlhAuUfTpY8TsEus+V5Cg5Xf2pSvNvBFu8/e/SMmIBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+h8FfZEpHrbd0xnrh9uKNfnwFft4fCzh/UKt6MoBHY=;
 b=P7/SFCZoVbP5nsBMiW6d22UBp3z46lAW8Bbg9luj047Hg9kzSD4jhWNIJbTZeYniFnPZvM1i9FeIA3qjCUoy4xB1uf997CnsOndngksLvpD82MzxYbtV7Ohsb6DM62weWbg4RybEB86B1H9g3+uNou/CW9af4hvLW32R2J2H7nF58kMq8khjyPok4/ilW2nvKmtLSBmt1LA2UGImscqhOOSYt7uFEzevMBkkdcBiuvz2JPgUzlt2xOe13YkT+9gQnrT5jv+J4ChBqZ+0TlPfbm+A3GGOKlalor4PuQdGnp+YB5Cq3EN0p9I6XkBn5H3KmGPOBiiOWdRckG8SxAs6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+h8FfZEpHrbd0xnrh9uKNfnwFft4fCzh/UKt6MoBHY=;
 b=LwCqKgBqpW/M8kluwulL+YLNmeUtMFfuGG4U38IgMpflkjHFO+phrSfkSJToiZg1S/+GBBPMTiBqcSuV8wjHTR20CyH2pz+PmNWTYWJ23R9nYTfB/VBnz/Hk6QK9fTFec8KCzSgA4zyuPCMk9lMj3M43fr5Kneu6sxKp84l6o6w=
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com (52.133.15.144) by
 VI1PR08MB4269.eurprd08.prod.outlook.com (20.179.25.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Tue, 22 Oct 2019 11:11:07 +0000
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5]) by VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5%3]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 11:11:07 +0000
From:   =?iso-8859-1?Q?Thomas_H=E4mmerle?= 
        <Thomas.Haemmerle@wolfvision.net>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.tretter@pengutronix.de" <m.tretter@pengutronix.de>,
        =?iso-8859-1?Q?Thomas_H=E4mmerle?= 
        <Thomas.Haemmerle@wolfvision.net>
Subject: [PATCH] net: phy: dp83867: support Wake on LAN
Thread-Topic: [PATCH] net: phy: dp83867: support Wake on LAN
Thread-Index: AQHViMlm4gfQcaMYWE6CeVTUQVGaSg==
Date:   Tue, 22 Oct 2019 11:11:07 +0000
Message-ID: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
Accept-Language: de-AT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0259.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::26) To VI1PR08MB3358.eurprd08.prod.outlook.com
 (2603:10a6:803:47::16)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Haemmerle@wolfvision.net; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [91.118.163.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 181a725f-b432-40b3-6511-08d756e0891d
x-ms-traffictypediagnostic: VI1PR08MB4269:|VI1PR08MB4269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB42697DDA96C44AF2894D0C36ED680@VI1PR08MB4269.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39840400004)(346002)(396003)(366004)(376002)(189003)(199004)(107886003)(66066001)(2351001)(81156014)(71200400001)(8676002)(25786009)(81166006)(1730700003)(71190400001)(14454004)(486006)(4326008)(508600001)(102836004)(50226002)(6506007)(386003)(52116002)(6116002)(6916009)(8936002)(3846002)(99286004)(5660300002)(305945005)(14444005)(2501003)(5024004)(256004)(7736002)(316002)(36756003)(476003)(26005)(6512007)(2616005)(2906002)(186003)(6486002)(45776006)(66946007)(66446008)(64756008)(66556008)(66476007)(86362001)(54906003)(6436002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB4269;H:VI1PR08MB3358.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wolfvision.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lMlWXb7qd1UFgSHRXIhAZ+Cw57fwolY3asi/Okl6SvmM3B4szALUXJ6NAWRqZke4L9KHrvfwX+EqKEo66i6nV5+RCgiXzrX+3BVn8UxjTdNtUXp52xAhV+Be90Fq2kmUTRmK7EOjLaXxBsmTwkB6YZiKOD0hR6TY0Sji6wOBwglZbGtelxjcKVYHipnoUmEoAKKp5XqR4Dw4qd26mJLfLehnu9MX9XBlADNPRsyIg5TfzPRLZLTRJ6SZ/v2mDQQO3+plgSH2kaTS8d0EeaFwBOK5tsQk13Jmfes1ytUdNHsjUJPZPLj/Z1m2F9440hCJZxQQBQNf7z3fB7aXMOVmwPtj9s4LNegZGvtk6tRWFUXXweiDiEB6YDOjYH/n2WH9Q13CfPI0f1O6CNqtbnGDzz3kDmG9o1hDxcTUJab+uJnEpTFMWee/jRgXD/2B6GQ/
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 181a725f-b432-40b3-6511-08d756e0891d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 11:11:07.2690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: exuPWRatGj2buO5IkNDW85FdBWbPV1W/gW4JiPexjuPcoMHPdnnM2yfrmP0F41WF2iO0FI0xxxUOpx78k6Set8O83sH3Ww3G94ziUPPM4Hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>

This adds WoL support on TI DP83867 for magic, magic secure, unicast and
broadcast.

Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
---
 drivers/net/phy/dp83867.c | 131 ++++++++++++++++++++++++++++++++++++++++++=
+++-
 1 file changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 37fceaf..a3b7ff7 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -12,6 +12,8 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/delay.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
=20
 #include <dt-bindings/net/ti-dp83867.h>
=20
@@ -21,8 +23,9 @@
 #define MII_DP83867_PHYCTRL	0x10
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
-#define DP83867_CTRL		0x1f
+#define DP83867_CFG2		0x14
 #define DP83867_CFG3		0x1e
+#define DP83867_CTRL		0x1f
=20
 /* Extended Registers */
 #define DP83867_CFG4            0x0031
@@ -36,6 +39,13 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_STRAP_STS2	0x006f
 #define DP83867_RGMIIDCTL	0x0086
+#define DP83867_RXFCFG		0x0134
+#define DP83867_RXFPMD1	0x0136
+#define DP83867_RXFPMD2	0x0137
+#define DP83867_RXFPMD3	0x0138
+#define DP83867_RXFSOP1	0x0139
+#define DP83867_RXFSOP2	0x013A
+#define DP83867_RXFSOP3	0x013B
 #define DP83867_IO_MUX_CFG	0x0170
 #define DP83867_SGMIICTL	0x00D3
 #define DP83867_10M_SGMII_CFG   0x016F
@@ -65,6 +75,13 @@
 /* SGMIICTL bits */
 #define DP83867_SGMII_TYPE		BIT(14)
=20
+/* RXFCFG bits*/
+#define DP83867_WOL_MAGIC_EN		BIT(0)
+#define DP83867_WOL_BCAST_EN		BIT(2)
+#define DP83867_WOL_UCAST_EN		BIT(4)
+#define DP83867_WOL_SEC_EN		BIT(5)
+#define DP83867_WOL_ENH_MAC		BIT(7)
+
 /* STRAP_STS1 bits */
 #define DP83867_STRAP_STS1_RESERVED		BIT(11)
=20
@@ -126,6 +143,115 @@ static int dp83867_ack_interrupt(struct phy_device *p=
hydev)
 	return 0;
 }
=20
+static int dp83867_set_wol(struct phy_device *phydev,
+			   struct ethtool_wolinfo *wol)
+{
+	struct net_device *ndev =3D phydev->attached_dev;
+	u16 val_rxcfg, val_micr;
+	const u8 *mac;
+
+	val_rxcfg =3D phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
+	val_micr =3D phy_read(phydev, MII_DP83867_MICR);
+
+	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
+			    WAKE_BCAST)) {
+		val_rxcfg |=3D DP83867_WOL_ENH_MAC;
+		val_micr |=3D MII_DP83867_MICR_WOL_INT_EN;
+
+		if (wol->wolopts & WAKE_MAGIC) {
+			mac =3D (const u8 *)ndev->dev_addr;
+
+			if (!is_valid_ether_addr(mac))
+				return -EINVAL;
+
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD1,
+				      (mac[1] << 8 | mac[0]));
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD2,
+				      (mac[3] << 8 | mac[2]));
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD3,
+				      (mac[5] << 8 | mac[4]));
+
+			val_rxcfg |=3D DP83867_WOL_MAGIC_EN;
+		} else {
+			val_rxcfg &=3D ~DP83867_WOL_MAGIC_EN;
+		}
+
+		if (wol->wolopts & WAKE_MAGICSECURE) {
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+				      (wol->sopass[1] << 8) | wol->sopass[0]);
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+				      (wol->sopass[3] << 8) | wol->sopass[2]);
+			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
+				      (wol->sopass[5] << 8) | wol->sopass[3]);
+
+			val_rxcfg |=3D DP83867_WOL_SEC_EN;
+		} else {
+			val_rxcfg &=3D ~DP83867_WOL_SEC_EN;
+		}
+
+		if (wol->wolopts & WAKE_UCAST)
+			val_rxcfg |=3D DP83867_WOL_UCAST_EN;
+		else
+			val_rxcfg &=3D ~DP83867_WOL_UCAST_EN;
+
+		if (wol->wolopts & WAKE_BCAST)
+			val_rxcfg |=3D DP83867_WOL_BCAST_EN;
+		else
+			val_rxcfg &=3D ~DP83867_WOL_BCAST_EN;
+	} else {
+		val_rxcfg &=3D ~DP83867_WOL_ENH_MAC;
+		val_micr &=3D ~MII_DP83867_MICR_WOL_INT_EN;
+	}
+
+	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG, val_rxcfg);
+	phy_write(phydev, MII_DP83867_MICR, val_micr);
+
+	return 0;
+}
+
+static void dp83867_get_wol(struct phy_device *phydev,
+			    struct ethtool_wolinfo *wol)
+{
+	u16 value, sopass_val;
+
+	wol->supported =3D (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
+			WAKE_MAGICSECURE);
+	wol->wolopts =3D 0;
+
+	value =3D phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
+
+	if (value & DP83867_WOL_UCAST_EN)
+		wol->wolopts |=3D WAKE_UCAST;
+
+	if (value & DP83867_WOL_BCAST_EN)
+		wol->wolopts |=3D WAKE_BCAST;
+
+	if (value & DP83867_WOL_MAGIC_EN)
+		wol->wolopts |=3D WAKE_MAGIC;
+
+	if (value & DP83867_WOL_SEC_EN) {
+		sopass_val =3D phy_read_mmd(phydev, DP83867_DEVADDR,
+					  DP83867_RXFSOP1);
+		wol->sopass[0] =3D (sopass_val & 0xff);
+		wol->sopass[1] =3D (sopass_val >> 8);
+
+		sopass_val =3D phy_read_mmd(phydev, DP83867_DEVADDR,
+					  DP83867_RXFSOP2);
+		wol->sopass[2] =3D (sopass_val & 0xff);
+		wol->sopass[3] =3D (sopass_val >> 8);
+
+		sopass_val =3D phy_read_mmd(phydev, DP83867_DEVADDR,
+					  DP83867_RXFSOP3);
+		wol->sopass[4] =3D (sopass_val & 0xff);
+		wol->sopass[5] =3D (sopass_val >> 8);
+
+		wol->wolopts |=3D WAKE_MAGICSECURE;
+	}
+
+	if (!(value & DP83867_WOL_ENH_MAC))
+		wol->wolopts =3D 0;
+}
+
 static int dp83867_config_intr(struct phy_device *phydev)
 {
 	int micr_status;
@@ -463,6 +589,9 @@ static struct phy_driver dp83867_driver[] =3D {
 		.config_init	=3D dp83867_config_init,
 		.soft_reset	=3D dp83867_phy_reset,
=20
+		.get_wol	=3D dp83867_get_wol,
+		.set_wol	=3D dp83867_set_wol,
+
 		/* IRQ related */
 		.ack_interrupt	=3D dp83867_ack_interrupt,
 		.config_intr	=3D dp83867_config_intr,
--=20
2.7.4

