Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2924538AC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbhKPRoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:44:17 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:7975
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238906AbhKPRoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 12:44:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYtHZkeiv/w6+XgyaprSRGTQjwdB4Cps6bXAb9neWrMNsVrxLRZvGkP4SV6/Y+goD1bYCrF5tEhHlx7Gabqrh+KxpGaCkVsrQcr3ht3hx80RveyrOgNEAxkU13t2xBtARnfC5Iiv7U9a7CkodzNZKhkKQmNiJF0KyE2P5JC7KNE/grj2xA5PuUaaVja+QKstYBzxR6gtXTuBWE6JeajrX/jZxqFjy/JCxD865vsMxtkO+xduOxz7Q8cIZy+e2pW0Z8UIFqhCvSRpal9+1lULm+ESjBBbnD6pCAaQiwlg6YyxUFybssndgGSW9CvZ343TTVceEiGEyqKbzOgRWHY6JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+fNLiITe9GOLW7z46etWuvKZW4IAoOOv1r+hR/r0HA=;
 b=YHkcw0y6aB3vMsrMOw+7k+iEExgzfyB3PMPBRtjFEr8f7KkBXbhghofyuzbmSLAc1DpvIFkW1xEILvnsePews7IOSpIjQxVcQy/mHnzOi/e4xxoAdIYlKa527gO9IpYr/ytVF246G0q6b7zlNpJC7UgBrR3cR4lAMZ8oPXfBXjYjvh0iC9GOoCD9So6LqHVncnlw6lG+iyZiOHncUDUsA3jrv5Ltm6wlaY+vchPd1wHGVNUGZJn1jz7M2DV7nnvL0/4IqrvU5aJZDkZi/s3hrO1xagOYb2OI+8MIcP8DQOg0+27l4reMJCmd7GHrD8pJqQ4BlaQezp7+PR5j6vuhHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+fNLiITe9GOLW7z46etWuvKZW4IAoOOv1r+hR/r0HA=;
 b=gLsQ/jZhXTnZqt71eayBOLuHuo6XstAb0/4J4Up4ylIVjbED+VfnImiWnXHmX2cd6z5vfbPoF67B1g6WVe6DZDWW9XS21VoQ8B3R+y8ellEMxCOQy/rRJYGUhehJXAfYhBYGOcNigU47UGjbHL8lZ0ZBYx7n+fdvf6TtZKWyUwU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4911.eurprd04.prod.outlook.com (2603:10a6:803:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 17:41:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Tue, 16 Nov 2021
 17:41:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Thread-Topic: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Thread-Index: AQHX2rKEbcpEShKMr0uAL3+1lm3+rawF/9+AgABI9wCAACQTgA==
Date:   Tue, 16 Nov 2021 17:41:16 +0000
Message-ID: <20211116174115.wft626rue2ya2sqv@skbuf>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116111059.sqthwmkiq2ng3t2l@skbuf>
 <20211116153208.GB8651@DESKTOP-LAINLKC.localdomain>
In-Reply-To: <20211116153208.GB8651@DESKTOP-LAINLKC.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5195ee51-6c5e-44c3-0bba-08d9a9284ac2
x-ms-traffictypediagnostic: VI1PR04MB4911:
x-microsoft-antispam-prvs: <VI1PR04MB4911E901D513E2F151A37789E0999@VI1PR04MB4911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jc1OpRCykAs8XfPrklbAAkSJP1NbpeYvzF1+fMQSE92Xf/WO6d79lmzdiTuU7DBbZaBxXVtEnbTwWiIkzFMHBlOM6YpXcgTftEq74A/wBYpS6LaqebEM4zhzMgiZsTTDglVHDcztDKnPhMY5/pTsEwg9/vkDkT6f1wSkgCocKG4A81NZdKq+u9tkAv6tBX8qJW5R3WhtXSO6BtFljbBvDSs7E9rDy1QCYgyDzyFT7424RGeF1CBr3zwRIpueBVMPNQn9SEGSDYQQwsqZxx+4ow102sou2AI8DALhXlXi/7p1LihturWPyyEcm87U+8lAs53SEcf3AKhFAxBQoUqlCQFp/5+nsHwvJdYMsEdvBFBsupIcJbj85RoJRCz2Rls2OtfJG7cLxJvlnKEPPpmi6h9gSIG9fHffASMLKTgX+2dNI9sWU1qE0KVSOaZfEDH3mQEXWiuwtN4fNdEK/TXH5SDvRPU9ke2y16ZVHIOZgXAeIEH6OIqhk2MLXDmyaxQ0x7HYLCWOKOI15MTq9X+Z1pVciPNdXgM6k/AYSWBTaQVi5uZx0FKDUkceSk2GPeVL6NW1bYf0sCNgPCkvHygObcsweNvItJNO3kXK9c6jMXICHh43RzUR9DIs+2syxyEJXUhFl51QW8VQ/onuMooojUNWPsexpjjzzrlQ2HozoEelAYSEut28lxf5hwnTQkTn2/G4NZw/GUq1x8uhPtW8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6486002)(66556008)(316002)(83380400001)(66446008)(64756008)(8676002)(1076003)(6506007)(66946007)(122000001)(4326008)(44832011)(38070700005)(38100700002)(66476007)(5660300002)(186003)(91956017)(508600001)(76116006)(9686003)(6916009)(86362001)(71200400001)(7416002)(2906002)(33716001)(54906003)(6512007)(8936002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EppwEQ1csQlTLSIv9W9WXoHddmNPgcLe8fmSXI4OyEePJaKoy3U0RWIKPzOs?=
 =?us-ascii?Q?Ucxy58HjSja0P1vPwhbWNEL02ai/31HB9SknL/bE1wpCyI8fm8xQ2ft93C26?=
 =?us-ascii?Q?3ccpWHX5tWStBV0lymY+A7wdDBdpx7YXpx+P6+h6MpXveIdNjb4jnF9V0Zu+?=
 =?us-ascii?Q?hFKCJ0LXuhFJkMDbesnAVYCjzdE6Ds9MLIgOl5phZU/Mx9wsRpwkHBhc09lD?=
 =?us-ascii?Q?RELYDucJ0XuuIVNSRdvvDkll3q/PdsVU6hR/1ZOWCyYTG6tKaj1YymV20tsJ?=
 =?us-ascii?Q?LxPkrwHyGGDyBF93qFuef+zB+4fLYI7wtKMos664JgnXRvh19iGyQSIEyg7W?=
 =?us-ascii?Q?TirigmcR223F0DZMIW9mKXScgzIOdcSO4ZERYAk5uHNUmQk5iTApHT4LT8sr?=
 =?us-ascii?Q?Y60z22xFQZ7VLStdWW8x821xujD4yRPyl4/CMn7muZY2WiRO4wTP5bO4O4HC?=
 =?us-ascii?Q?OLX8wGOt+Ly+IkxXcbR0OvI6ux3Rp3Z5/rp/tZrNC3L46lJEA4uOeejfwkNw?=
 =?us-ascii?Q?nJJ01MGun9vQXcULHAjSiBA6xT+qayKDahcE67u712frY3OcPaVliO+b26sj?=
 =?us-ascii?Q?WdNn+G5lzORGwdf9vMy62oKNYSEcqvYLfNGUi5fdZJJ3220/TrandF8LOgls?=
 =?us-ascii?Q?sW6brah/b8R5DjMehBKrm3OcYzykGtpobMCVN70MDCQjTgxo1Wvkwky8l8xn?=
 =?us-ascii?Q?VdSgdq9URpiOHb8To+QQTAMq/eM83LXbnMun/wViEXvOKsfRoCJva4DRkkZ+?=
 =?us-ascii?Q?FvQVQE1aIY00Sh979FOwUubAgIfL+NigveYZd8mrnefpCM9Mi7TV+BPIdR8E?=
 =?us-ascii?Q?3W9IQ7IRtUxn4b2tX+g3YKumQ15mVx37Wi+F5fLpzknlZHYME4SmhkJuVMtm?=
 =?us-ascii?Q?K0BSRQlFySc81lCCdiZpy+gcP3e5qrQv9WRXSiaW4U3UTCUo9P2wtTvxwDGe?=
 =?us-ascii?Q?/3wkrWm5d8ouRqE6TaGWlZzgdJiPLry3RLHdz6u8Li2/rjxQp43I/fCE3eOM?=
 =?us-ascii?Q?+85cBYAKKpFgT/y4kzct9JaFqMe5ifgAN+nIz+5hrJ17sXERBUDPy0doCIrR?=
 =?us-ascii?Q?AbP0zpB1M83o6oCq4+7gTKzMnytR021CkKsKd4gFkld/bB4NsiIlueYitN+x?=
 =?us-ascii?Q?s1Fs4/zDwUM8VMk2Fa2OgxXLF3ieRr02C7N7popO3BL2Sb9D0S9f7MKsViO9?=
 =?us-ascii?Q?qm0uAJcz6po8nRWsTJ7rBvXweCIKzZdb0VaoqdWQ+FMqN5NFOzR+Rk+mUvgE?=
 =?us-ascii?Q?KZM5W2P2Ca9Ii4wjTG19Rrmey88/qB+yWwPO59JLP6XSaOG7SHWGLN8ZvZIX?=
 =?us-ascii?Q?mD4KcAzasF3Og5QuC2+dHRDkzoOWGWjNbSYAQPRp8xwrjq9RrfGqKP3zpRuO?=
 =?us-ascii?Q?BJDVD5PnN9h90MzHYQIPb0PYYwakLl2G1uPPMDBAIuWhrV3sfSZUmjfQEkG9?=
 =?us-ascii?Q?oK7D/sd7AXcmdO/ngHcs1To9MwjhWia92Iuorr6LiJPesWi5hA+ZubIzc7AZ?=
 =?us-ascii?Q?sg+wG7ZOTGHTp67nw8AJXlzxQ8w9AnrK7+f0TWrmn8MCTA4BVx5cbb8HwX8d?=
 =?us-ascii?Q?AAr5aoozwFZzWaWFLawDiSEsmU5Jtv2Z5Hv3YCYycUar1YRqik4DQ8GDSDVo?=
 =?us-ascii?Q?6ei5VvVTQQczk/1wqN2w3wsCr7EMzYv/ZjFHNt65E4Xy?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA4043738369AD4EBFBEE82854758AE3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5195ee51-6c5e-44c3-0bba-08d9a9284ac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 17:41:16.6143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GJDgUorv6uarBjNWQ5qg3xPHZ16xyPuwsdsQqbqW9wN8Qi3nDDiUiTNGXcU9SkwLO2NvzMY0EfQNG0JoZ7Qrnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 07:32:08AM -0800, Colin Foster wrote:
> > > One thing to note: I've been following a pattern of adding "offset"
> > > variables to these drivers. I'm looking for feedback here, because I
> > > don't like it - however I feel like it is the "least bad" interface I
> > > could come up with.=20
> > >=20
> > > Specifically, ocelot has a regmap for GCB. ocelot-pinctrl would creat=
e a
> > > smaller regmap at an address of "GCB + 0x34".
> > >=20
> > > There are three options I saw here:
> > > 1. Have vsc7512_spi create a new regmap at GCB + 0x34 and pass that t=
o
> > > ocelot-pinctrl
> > > 2. Give ocelot-pinctrl the concept of a "parent bus" by which it coul=
d
> > > request a regmap.=20
> > > 3. Keep the same GCB regmap, but pass in 0x34 as an offset.
> > >=20
> > >=20
> > > I will admit that option 2 sounds very enticing, but I don't know if
> > > that type of interaction exists. If not, implementing it is probably
> > > outside the scope of a first patch set. As such, I opted for option 3=
.
> >=20
> > I think that type of interaction is called "mfd", potentially even "sys=
con".
>=20
> Before diving in, I'd come across mfd and thought that might be the
> answer. I'll reconsider it now that I have several months of staring at
> kernel code under my belt. Maybe an mfd that does SPI setup and chip
> resetting. Then I could remove all SPI code from ocelot_vsc7512_spi.

That sounds acceptable to me.=
