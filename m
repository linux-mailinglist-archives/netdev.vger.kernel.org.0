Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434E9298142
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 11:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415165AbgJYKSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 06:18:54 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:56805
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731924AbgJYKSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 06:18:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCmuv2v10JLK0+LPixEbSscMw9+sWbZFREm1y24w0KPubwtZQsAQim3FMQ4zy5HfcnfDOqlgZKQvCy/jMRFEV1BUKx08tYS5H1SWKOJs5G5YusfcPF0kfBm/XjOk3Sxc3e6mIkQfpc7+VmjR1HlEM9UrJXf0j6hfzjCzI8C+rSqfhxdBwz5MLrbKHpRthyR8nDmrXi4bVQ+g3h7+n7N0UnQt39iK9G2vGyha5f99RETyEGx3SxycFXLnYBA2/tMx4d1483xiZZHs+qAJXWCPT9GsCX6mJkcn9/xBW7VcCFwA5+PNvCMknLvQ/lEF64An4F52ajn2FkUgCYx5wBq/EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3IRIkYprnFQi+AoM5VvJgs0CYQ/ohbvk57tNP4vH7Q=;
 b=J7Bhtv5Iu4vJzIJim5XoSnRw4qD1MYgrRw+cC762VyGhqRkIDocMNCkz1j7UcH6/LIe4ONVRyJHfy9dAxbsU9vXzjwdRk/po0XsknREO/R62kb3wrv6oa+LABNOQuVjn4feq9KHZ7WPrRtw2uR7RJE+7sqGnBDveosUkbjaGpUBZOMs8j6UkS0sD7VwnDcP+BM0gYbwx6FDwF6i0tPxOrMCwW5uhcFEa1xYQMG8Jy0CCi+VvvlU/UumwsMl+iHJEITdbHkixa/sqaFVCiTKN879ddoTwIE+oPwxPLjJdgmaEOeG/FbGwC5obF8BiZugz6QqOTn2yrH2AdRyQMtJcNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3IRIkYprnFQi+AoM5VvJgs0CYQ/ohbvk57tNP4vH7Q=;
 b=CI4PiFMbmc9DVs/e7BUejq3fIqG0xZMl9iDGGL9/F36rxN1TyjwmB4N7qbBIGH8FzFkky5ehqJRAfZz1Uj/Sy54yR+jCCkqbsvxoNJl7gyVcn0sEM0cqnnbiC6sbTxDHlTuFAW9CJ6LtvHp3yPJSQEVS2xYBcefVbtEwSzDEZd8=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5005.eurprd04.prod.outlook.com
 (2603:10a6:803:57::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sun, 25 Oct
 2020 10:18:47 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3499.019; Sun, 25 Oct 2020
 10:18:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [RFC net-next 0/5] net: phy: add support for shared interrupts
Thread-Topic: [RFC net-next 0/5] net: phy: add support for shared interrupts
Thread-Index: AQHWqf897amgBiGDU0S3g6psdVpuFqmn+rMAgAAhwAA=
Date:   Sun, 25 Oct 2020 10:18:47 +0000
Message-ID: <20201025101846.tbrap3iw53lmixyx@skbuf>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
 <1b7a22ba10ed5d63743c045a182ce5f9@walle.cc>
In-Reply-To: <1b7a22ba10ed5d63743c045a182ce5f9@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4bec0110-d655-44ec-e0e3-08d878cf5c6b
x-ms-traffictypediagnostic: VI1PR04MB5005:
x-microsoft-antispam-prvs: <VI1PR04MB5005121604E4464F88413DDCE0180@VI1PR04MB5005.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qs6hYe+YObAvyzg6gCnfqMD7ZuARg+4F/XhR6zAezbcHqyJvvd5T0FDxFJWLgLndEd7GfBHv7A40XbXU8lRU4CUIe6PXAJW88mgaYvT7EgQV3lGfD3SBa8Exdn6KZhqIBruoFSuJjJxm8wIZS1oSS67B+BbqRN69w0IPG1Dgd47u1QCxF9ufVo8RVSqo5HN/dIKwpkt8DeaQLj7w1EA84CkKbe0W04KgGLyo0xFsP/nqYcWthDUMLsF0iRJGo7kVZS4fwKS+cbwViingET8+oakcq1v6Y+gz1/7up6oqZj3vdbqAJKchhVzDCUTIzRxMQjWb7AkCv3J/CgLBRXvZIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(396003)(39850400004)(366004)(136003)(66446008)(33716001)(7406005)(186003)(8676002)(8936002)(44832011)(4326008)(6486002)(76116006)(64756008)(66556008)(66476007)(26005)(66946007)(7416002)(478600001)(6916009)(86362001)(6506007)(71200400001)(6512007)(54906003)(5660300002)(1076003)(316002)(2906002)(9686003)(4001150100001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Hel0VUXTe0IqfTOxllrTN/Hx8sWy2nv5sQaRs+kLka9H7CaWTADFeG8eQYDEldIrAfOvpyM61LKp1SJr6CQIknsY7CEg6HfA3cWkzfzStOO9cu7TEMPky3fgL054g9SnREtpflbBG+OtD7aek0+WonsDr94vuj8NQH4MM/u7Npj7Up4sC4kKBSgnRn1B1vZ+Zo1B/Eocq7PFDpnfFCyu0+x8nlzBhr7wd7Ci342oS6yFG/uynS6+DKqFV/X5VMPk4i9L86w1CWnZOaGFcvMQ4sxPRduP+UPIjbnm2TSIOe5j8aU8c9YaByBXwEdgX5b79sonkVYCnFtJtTUHdPiu2pTXSs8NKdHC6nXAJHrBER5OOwsu7ockGv8zQ7RG2ZyLHUmEsfvlZ8Axq5FxZWGAcqauAMm2TuBv7Pc/0o9/ucsBbGGb6e2vMxb3uAhjXMZoJsrXP0w9nx4vtRtMsIhDmqQ9CAQLYRzreKP2WDNJQw/dyOB/YcV3+jvHq0tFUV8MzPy1L8hhfVESif3KSYLeRvQcC+C/VbtQlY9nIh54F7dGNlkaHs1+pYbv5Yz+TQ/djZnkQjT9xSWI1kG2nTlsqk3TxJm63So8Up7zeFNw2ehSVel6eT+9zTMqvq5KX8nDun90wsdz0y6yUJzDOjqtUA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25135717844EA640B3F83A5116614E58@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bec0110-d655-44ec-e0e3-08d878cf5c6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2020 10:18:47.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfpBglJlNIyE1jIJc+ZfluzVYVb6RyxeedSE6Vt+LuewMm7+DzkAU9LMy4Yyaxx40SjrynXCCJRru3o2urkARA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 09:17:58AM +0100, Michael Walle wrote:
> Am 2020-10-24 14:14, schrieb Ioana Ciornei:
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
> Would it make sense to provide this (default) version inside the core?
> Simple PHY drivers then just could set the callback to this function.
> (There must be some property for the INTR_STATUS, which is likely to
> be different between different PHYs, though).

Yes, the interrupt status register's address differs even between PHYs
from the same vendor so making this somehow into a default handler would
mean to add even another callback that actually reads the register.

For simple PHY drivers, the .handle_interrupt() implementation would
mean 15-20 lines of code for a much more straightforward implementation.
I think that's fair.

Ioana=
