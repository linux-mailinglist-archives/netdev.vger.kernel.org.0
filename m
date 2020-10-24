Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD4297DFD
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 20:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763823AbgJXSTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 14:19:52 -0400
Received: from mail-vi1eur05on2067.outbound.protection.outlook.com ([40.107.21.67]:31393
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1763816AbgJXSTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 14:19:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2I9c5fk9w4lIN1JcTe8UxAPJcsD4j1mxIzlAdTSLB5f03DnfxyW7u1QJJmcSFN1sdzl33N9vyq0OQqyQGQMVLRbf7pBE7TPnM4iai6zMFy+iTiu2mzyDTC34Esps2NyTw9Iy20X91oMOjh/brW0ask9jZiGVmIRCzzpFMISkXM2Hkj/f6eg9Z2clmUyv+ht2P3JevDgf6JRhY/3mthaql6Z81rVuvOm+Iog9KjWZ6PbJuYRJiWFTNEQItxqLI4Xd6VMl2xfOaX//G1Cb6jQx01DO+lg8dQLGaDUYpmTyaObxU9Nm8U2kvRC9Q4jLxDdWQ8mmkDdxiGxGVS3zXLKWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifBW5QnkknCNV87SMODOWAf7SWTI4EA1SDX6C+NMtj0=;
 b=GIhKgUWejJFXTXAf/yppOWPmKe1hPyRWo0ys3M0vaCabuDfYd2kX0L+OWJ/N5mgdNGl3CQa+njPF/y6MVvkMCI2qU5jiLJl4/y8Motz9kvhPRPW/XEGcfhkoH8fE1Zz+gcCg13KzgY5EPPCuGlLYDcaaawMOjpGn9v3Ymr/vprJwHk9bAObSigpdrDovZJFefJS6Che9bYRFrpU7sE2jdGPf7YlmneWJlrMvvmxLo/6o1urL0ZWJEyLi58EfREBTQHFHhLiV31xQC6eQc6PCNB0lK+9Q5Oank2H6CjZf11h4iK7FyH+HhYxoSzK1uAc/B5rASt9rttr0MAt/s5IdQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifBW5QnkknCNV87SMODOWAf7SWTI4EA1SDX6C+NMtj0=;
 b=WisfQI09EfSIzdS5AZGGIliuJZryAAiBMCQu6AEPxXusDBgixrpTsgLjEFW5u8OzWhl8DMin1aveW/UmBkI9jk8kY2MiK8NloU2z9dyNfpvMqrTOh7Rj7kgyFDtE5k0LvtAKMpgZ71q662F9qb5s155MKYvKO16WYQ9vgswJ834=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB7007.eurprd04.prod.outlook.com
 (2603:10a6:803:13e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sat, 24 Oct
 2020 18:19:47 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3499.019; Sat, 24 Oct 2020
 18:19:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [RFC net-next 0/5] net: phy: add support for shared interrupts
Thread-Topic: [RFC net-next 0/5] net: phy: add support for shared interrupts
Thread-Index: AQHWqf897amgBiGDU0S3g6psdVpuFqmm/v6AgAARg4A=
Date:   Sat, 24 Oct 2020 18:19:46 +0000
Message-ID: <20201024181945.pip6sdal6hpa6fns@skbuf>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
 <20201024171705.GK745568@lunn.ch>
In-Reply-To: <20201024171705.GK745568@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d498649-7e5e-4fb1-6c41-08d878496392
x-ms-traffictypediagnostic: VI1PR04MB7007:
x-microsoft-antispam-prvs: <VI1PR04MB70075F4F68BBFFA2154BD4B5E01B0@VI1PR04MB7007.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HGCTnB3PLMEn2dKZXu3bJZm6QVOtZ0wioowy3+43xB9bAg/nKqyb5D38zKkTwhPMlOggGiMVaEmwoftf3jtCgdFU+ChL1mf0Al4lR1qa/epKnJ+D69NPJiDLCbBcsfq4fKQ3t80JHpS2Yut8a1tWDcF9U34RXfBeu79QRF1Zck6SF8mtjfOdDM03D5l7QgBacIYFa3hasElMbgWS0WV2LPWeR+vuDLEsdoE4rxS6hyi8rYQk+iDvGaXQ5J78SOuh8XoeiMHBlhDeL+A5IqfjR/S4KoRXs6axfXDNHoTFN/SiYvz2w8YOUXO7A08r7l1gKXqmNxMMZLOqCI3a18yuyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(366004)(376002)(396003)(39860400002)(346002)(66446008)(186003)(66556008)(66476007)(8936002)(66946007)(76116006)(54906003)(64756008)(8676002)(316002)(26005)(33716001)(86362001)(6916009)(1076003)(6486002)(478600001)(44832011)(7416002)(5660300002)(9686003)(6512007)(71200400001)(6506007)(4326008)(7406005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wCQneeDgBeRCDrJr5Fc8+2tyW1ywy6Ja0r9tVhGzIPjChR5IhmVcP02TfHmmvH9Hd/Z3oCGDZp/39aDdokgKNKxFKTZpG/s7q/uak/aaXcwe52WEpUVaU9mqbqtY4tttg4/X/Frn7bO7k5UZCBYAUmO3BsWAo2vTmn6oYvTPeQzvqYpEYfMeS3RxRRmmKxhDypikEdXrAE8amwQF1Xml4g6F0qZ+jekPsYgxrY+ytwQocWcjT7Kbu2kpNlvuCBsWVcFd/mWXFjjJcmkdRDHsWe9xfkxy22OMAn/flJhweF7s18zGoqO6XcEXrlDXhdIL+HBiAm3seiq6iFeIJArWLA5FyipmMQuu8TpXsvBLkQHdFSVUxYmxkjgojVTIw8m0DohnSet3eCJJIniMgV4dU+Q9ck1MFfpk3N5O1JmIWRSIY57lOPfeNWzqpoZ+slxaUwUypJDvohHkpANWI+18aEo7xNYE6PM70jsbBCu66EKVbQtMk/sU3QXdsdJiF7tckosBiCui+7kUwjFxCw70mpxBH4nZNyXSoSWYPrrw/BDach1Q12/6FHWjfCEjZT2fQUJHi6ITUttylMm/D/si5SqUZWelS7mpcqL/qeYdKoWJg2/FNvPwGW1q59XBfKRUhFhSKkPWHELkH8DzKwIjeQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <34C67A79BAD7CF4E9A26C0FED74E9995@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d498649-7e5e-4fb1-6c41-08d878496392
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2020 18:19:46.9132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkoVdVvfzu7nBz6rlgR6EmMCY0JIEpee0heR2W4EkLhKLBkuw9oxY1JxRzi5QFGFHkn7Japuq8Ola0Z75wMQJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 24, 2020 at 07:17:05PM +0200, Andrew Lunn wrote:
> > - Every PHY driver gains a .handle_interrupt() implementation that, for
> >   the most part, would look like below:
> >=20
> > 	irq_status =3D phy_read(phydev, INTR_STATUS);
> > 	if (irq_status < 0) {
> > 		phy_error(phydev);
> > 		return IRQ_NONE;
> > 	}
> >=20
> > 	if (irq_status =3D=3D 0)
> > 		return IRQ_NONE;
> >=20
> > 	phy_trigger_machine(phydev);
> >=20
> > 	return IRQ_HANDLED;
>=20
> Hi Ioana
>=20
> It looks like phy_trigger_machine(phydev) could be left in the core,
> phy_interrupt(). It just needs to look at the return code, IRQ_HANDLED
> means trigger the state machine.

I tend to disagree that this would bring us any benefit.

Keeping the phy_trigger_machine() inside the phy_interrupt() would mean
that we are changing the convention of what the implementation of
.handle_interrupt() should do.

At the moment, there are drivers which use it to handle multiple
interrupt sources within the same PHY device (e.g. MACSEC, 1588, link
state). With your suggestion, when a MACSEC interrupt is received, the
PHY driver would be forced to return IRQ_NONE just so phylib does not
trigger the link state machine. I think this would eventually lead to
some "irq X: nobody cared".

Also, the vsc8584_handle_interrupt() already calls a wrapper over
phy_trigger_machine() called phy_mac_interrupt() which was intended for
MAC driver use only.

Ioana
