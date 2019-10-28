Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93986E6DCE
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 09:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbfJ1IIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 04:08:21 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:49028
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731255AbfJ1IIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 04:08:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/5eXYhBuyVhKzeurhcDxzQApZAlng8oysLixhyMfD3MAsEEigoPYV2F0bHva8OAWVuhLLK3hDzcfY956nsnQfXedUiXgNclRSPk01gMml0XRF2VHDMS1SZdrN/84tQ16SrZej68xFRrmhqbB1G6quOGpqBxRIbae05qnBihwJsx9kYUYyJ0HRCXaOrkm+FqOUTUc3s+drRqMUOmx3hOPqodH6yeqmVCcN28gY7uFhzP+8WSjZ+s0mFwCUi/HSevqzK6KjIsRC1DRX2eKLIGZ/rfSUIfg5EcYUjwsb1G4z2hQk9Dr+zpjIo42RDyVdeEplW+fMVQ2kvOvOjOqfKN8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCzNX7T/nwfDeit6HRfOGuDfULS4nNgEcS0fRiM+dbM=;
 b=kjwcs/NQA0OUcogrP8l2Zw7c/NG472LOdchbjbzDrSjDcbKal1zFlOFrH3FTqadxUd3iFu2oix7k5Uctb/Paum/LhSF1sQ8n/o0XqXpjpVGEcsFh9fxz3NiBqWqsmili63+GMugoeDFuRLJ2D6OJrPlogZ0sGlQGe9VIXro9Cb9bDHkcZVJvsnylIV+iDt2YPQwUbiRRmWKyEreg9ogWl42zE2X35SJsGfoSefBYsG2upgt4PZLNmJ3VxzVdSKD9HD/UQ4hZIgd0v6G5imE4CkvLDr5kAqZR/OmykrtRCGxUD1ru31xzCqE+NRtD1elWxhdRqTbdTyqZapxZqRnfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCzNX7T/nwfDeit6HRfOGuDfULS4nNgEcS0fRiM+dbM=;
 b=BL0bsyH1EMOLCRJVjurSO27lqRRSXVgNkiBMFmwzYEu4WirAFxo6TKogjhC7AxU2qNSSsndJkpTUK7baOY2u5M1PwD5JSADg0jOgvng4ExUz3CQMXQmedMH1eBAB4bE1tkGVfCKS/Tdb97dM955ufBpEbmgGRDzaPwfDuvcsCrs=
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com (52.133.15.144) by
 VI1PR08MB5520.eurprd08.prod.outlook.com (52.133.245.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 08:08:14 +0000
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5]) by VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5%3]) with mapi id 15.20.2387.021; Mon, 28 Oct 2019
 08:08:14 +0000
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
Subject: [PATCH v3] net: phy: dp83867: support Wake on LAN
Thread-Topic: [PATCH v3] net: phy: dp83867: support Wake on LAN
Thread-Index: AQHVjWbZgpWvG4Tvd0qmuRYM0WX6bQ==
Date:   Mon, 28 Oct 2019 08:08:14 +0000
Message-ID: <1572250079-17677-1-git-send-email-thomas.haemmerle@wolfvision.net>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
In-Reply-To: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
Accept-Language: de-AT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::37) To VI1PR08MB3358.eurprd08.prod.outlook.com
 (2603:10a6:803:47::16)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Haemmerle@wolfvision.net; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [91.118.163.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e54800d7-c5f1-4c6f-59bd-08d75b7dfb88
x-ms-traffictypediagnostic: VI1PR08MB5520:|VI1PR08MB5520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB5520416F6680A5CF69FBA518ED660@VI1PR08MB5520.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(396003)(376002)(366004)(346002)(136003)(189003)(199004)(305945005)(86362001)(8936002)(6506007)(81166006)(8676002)(66476007)(446003)(5660300002)(386003)(102836004)(11346002)(2616005)(476003)(26005)(52116002)(99286004)(76176011)(2501003)(14444005)(50226002)(5024004)(64756008)(36756003)(186003)(25786009)(486006)(2906002)(6116002)(3846002)(66066001)(508600001)(1730700003)(256004)(66946007)(45776006)(71200400001)(66556008)(66446008)(71190400001)(5640700003)(316002)(6436002)(54906003)(6486002)(6916009)(107886003)(6512007)(4326008)(2351001)(81156014)(7736002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB5520;H:VI1PR08MB3358.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wolfvision.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8BFqnyWEhCIwEMpfzcB83Ktb+vJuL6Ie2HfVzJL5qOrGzUFbbKBVS+puaxoXkL/tSBg57+rUhLeaB8Mi+o5z3qveJSscxScNMmmC4BKjefeWCK+bBpIaij7cdX6+Fki3Gwck+s5DsKyMa7GB0K6UUY+j1G7ttwIF4+mN4HUC4zKPYzoaeYk6eIG9HzkZ1/WvwE8wNEB2T7FH6tWxnodpErfvaHyXl6KntKURzMkyHJknu8c8j+QSqA2jzkXuV5qcLX367o9ys9fnEIxn9/lm/0b1+3KoSWKnh8iQceV0ITS6dkWouFCtB/hZtcZ52GXdBAGmOg/KkiRxBwCnGUWzQFCJed4P0zC6dMEmkWMJ7fHN3yqDYbAPazKcaMQo1bt+46+i85k1UjhQnWmxErvaxJq+mAgR5JYLm2MEhtwhUK1LTpwg72eAUfXa1+MUhJf5
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: e54800d7-c5f1-4c6f-59bd-08d75b7dfb88
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 08:08:14.7879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qPqea2h+VdNov4OZ0PU+kBJillnTsgdG+w4Nfuq9puWP8kpqpMjI3cbdzlhEvzUL7EAnCrj3s4wl+coE3dvHlkXY+MQ/J7rTsJ1g2Mry0rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5520
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
index 37fceaf..7874271 100644
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
+	u8 *mac;
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
+			mac =3D (u8 *)ndev->dev_addr;
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
+				      (wol->sopass[5] << 8) | wol->sopass[4]);
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

