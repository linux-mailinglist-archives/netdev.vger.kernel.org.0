Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EA6E0486
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbfJVNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 09:06:40 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:63743
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731982AbfJVNGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 09:06:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxSOGR7owXddzDiN4PUdtDWoHEG/BOZV+qEPW8GaijnoPV7/0ELFmeLAwblWcJZ3VZtTe7THQR7pPcKNJ4sQ2h59PcoPQSlwieDIAIMYI671h0hhSRCucRFpigA1kyP3tQt1OFAeTTjvYEhs0VoVTTD/SdrhQrtUgBzIs1hhdLmZppnPqQDwTmrWGzg/hNJUMxDhgPvwsfr3s0M+XzNobNRmYGVm78P04vbNm3aDMiTAa+hHdMdYttANULSR0hS09gccx83yGFy7WVnp7kdouf4R1bsmIL0jlPl9TYTOOpTPjaQYO2OlJxrY4EyXKQrjSTEv1JaL2qj3h+LSNlg4SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QLC/dzBDX7PvevbrFQAWOowNJl85jTKtp0spE1IsoA=;
 b=YbfBIfkV4W64rt2CDfAY5DR5ZXDnRvo9rVlu8Hze93CoV0I/WBAeoDXJBNJK2PJdB6UCUjGiz36omLuIrvNQRKmXj8WGS+C+eXw21pUhJ8wd9Y7a2+qS/C1OYfR3awg/sRLY1qcV24WO2Hyi9gChVX1m5qyZtSb+poFplMA41CzxW95FJPQdEoqXwLrtCYWJRevZIo+8vLBNldHMmgazGNNyZwr0BNgzm5IGW69nIwKhTcXng4T6df8D/4TSHLjaxAOHMk8oZtTfTzbBif+4FWdiahpkCkWqTJB2KGKhMUlpih07a+6ywhINRlZPCkFLVLX+kgtpa/DBWnMF/FTT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QLC/dzBDX7PvevbrFQAWOowNJl85jTKtp0spE1IsoA=;
 b=wHvLsUk/6F4ZD0HtT9/izcHuyHc6rThGy39/lXrutj+hXqvpvzepsO2o3f3dUjbkoJZL3Cr7IdGJWPwAcTSCF/Fb8HTK3TCh9MkpxgySQdczmlcNstnXCn6GDSSKCtT2ds5uxsVjua6HtftatbGxZkNAR+XliTyRDuzOm/W824A=
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com (52.133.15.144) by
 VI1PR08MB4304.eurprd08.prod.outlook.com (20.179.25.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 13:06:35 +0000
Received: from VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5]) by VI1PR08MB3358.eurprd08.prod.outlook.com
 ([fe80::8161:607a:cde6:dc5%3]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 13:06:35 +0000
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
Subject: [PATCH v2] net: phy: dp83867: support Wake on LAN
Thread-Topic: [PATCH v2] net: phy: dp83867: support Wake on LAN
Thread-Index: AQHViNmIBuwAQVqun0KwdtwDQqiwwg==
Date:   Tue, 22 Oct 2019 13:06:35 +0000
Message-ID: <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
In-Reply-To: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
Accept-Language: de-AT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P195CA0015.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::25) To VI1PR08MB3358.eurprd08.prod.outlook.com
 (2603:10a6:803:47::16)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Haemmerle@wolfvision.net; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [91.118.163.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c378c64-8ee3-4843-6ba8-08d756f0aaac
x-ms-traffictypediagnostic: VI1PR08MB4304:|VI1PR08MB4304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB4304C43D6BF728A47BA8702DED680@VI1PR08MB4304.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(366004)(396003)(376002)(136003)(346002)(199004)(189003)(86362001)(8676002)(7736002)(4326008)(50226002)(1730700003)(45776006)(6486002)(305945005)(81156014)(2501003)(81166006)(8936002)(66556008)(66476007)(66946007)(6436002)(6116002)(6916009)(66446008)(6512007)(36756003)(64756008)(107886003)(99286004)(2906002)(5640700003)(3846002)(486006)(476003)(6506007)(11346002)(102836004)(76176011)(66066001)(52116002)(2616005)(5024004)(14444005)(256004)(446003)(26005)(186003)(54906003)(508600001)(14454004)(71200400001)(71190400001)(25786009)(2351001)(386003)(316002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB4304;H:VI1PR08MB3358.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wolfvision.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vgbPHdVHGmME9ZfE5jgR2KEAqm172DEzKa9RRFFAFSjhCJSKQ/6w5sHxOltwSDvvo7GcOJxwISngskysWAvxqUmfZUCVlpTXeL4hmyWxdDpcXtAgWsE+MgPRCxZQGG3gh+3xbagq5iIcJpVEnRELKOo01bmpgueyDeWDH9dCcJZcVbKvqOn0tP1L7HuvoP8gja1oW1sy8zPTimFjEpvOVy6y9dEt138IshFwy2mUViHB16CGKSwjHajfhDiUT7XLYhdsXv5AaEDoOOPcbTBQCyKvoDXkMjlGQzAqytra2WlJPuL645dQBcwzT977fViLHnpal5G53aKeLGk1Htic1S+cF2WevJ6lMWmPPW+cubfGc/Cm4JCO7+enqS+H1Xy/+9owPQBbnn7GPzHuzy5jrQwaw6NV0zDE1v6fEScS+ykuhlcJpRfgBs1DuYLFlCL+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c378c64-8ee3-4843-6ba8-08d756f0aaac
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 13:06:35.4159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MaZX3nCKvJ/zF8JmpMyZw0M9VzZTYnf3m5An+/K3l+cUXRmo997LFbuWpBc4BhBTcYW2o+f9IbPILi0wbSHFkMdd5L8vqm2HkMSM8H+tNqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4304
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
index 37fceaf..1a3f8f1 100644
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

