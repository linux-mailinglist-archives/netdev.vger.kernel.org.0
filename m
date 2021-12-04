Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D41F4684A5
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 13:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384872AbhLDMKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 07:10:50 -0500
Received: from mail-db8eur05on2064.outbound.protection.outlook.com ([40.107.20.64]:11584
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355048AbhLDMKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 07:10:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLfgcxkHkjY5NiUVJum7Pwfu7je0sK9IIX0FAm5BVY/+eR8PkO/xp9NFO7acCnjm2GSYIPsG4HGUPe6lE3DCFho7mHfOWJHzX+cSZhVZAOUe3oywm6dElsxlWZTC15uofJ8mqQtN3L541wtZi7XbZv7J0UpV7AM+n7O3Du/ZucNdoMULj7E7y6frEsM8LS4A84LrYfTDeB8oqft/oWd9bxe4aEn284OnI59hFbPTezJoKSPftHYNfcJuzRkjzXBjd6Y9/QwEDWZOGvfE9D1/W2uN/zNXIRHSnnKsdjsxQY1jpYB4iD3Pu73BDRyLXG+j5AdomhldbSJO7Ju/opsq5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYwAGONAFAe7xvIJ79TLdMMdOdynqR+ScRWP98+XVQs=;
 b=OkEXNfDj6IDZ7PQLj4367c4N8KLeiNmXGbUxR2uqGnkWKNIyCIHP8yyxXI6lglYShLUy/W9mYWzn67UfWz217W/Ai9+1xWYeRD//GvCo/eXCRKCd9x/3u/zWK53TrhbYG1SSCie1CuGvRwS8fvOpYo1uyYKQFwg4Ml1pEL7s+UsQxMGWl3EiUhrq9tLhX12GQ2wIE/qFyrgfw5uH8CkKNIWOfvPA3+8B6jV1WaFbUN3irrFyf+FMX61i4ybtbDXgzHApGb1EZf7QF73yXsciUIrgFi54XDf2fC9Y6t7tSTMp2OgyfM4Ff8avqjKn8pHZdaZ0jDPbE0HIEE4hSyGyVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYwAGONAFAe7xvIJ79TLdMMdOdynqR+ScRWP98+XVQs=;
 b=P8i8i5zgPLUqsGIt5OiV2BQxccSHBD2v2LAYuxcN1iHReC9N61kxwSLjQ5juwmKgM1erFjvO2zfe5MiTJsw0fwnPdbx9uNUvAnb6noisqmo4l4aOKG7OlT1CBirIAafchWLCm9pTkWdMJnU/V78WfKts9H7h82z6AoxAvb66Sz0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 12:07:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 12:07:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface
 for custom regmaps
Thread-Topic: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface
 for custom regmaps
Thread-Index: AQHX3ZbhuZ+MuOcG/UKDWCVExhOGcawOPJKAgAGJFwCAEcYuAIAAx/OA
Date:   Sat, 4 Dec 2021 12:07:20 +0000
Message-ID: <20211204120719.fd7t3zsj7yk4dq2v@skbuf>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-4-colin.foster@in-advantage.com>
 <20211121171901.nodvawmwxp6uwnim@skbuf>
 <20211122164556.GC29931@DESKTOP-LAINLKC.localdomain>
 <20211204001140.GA953373@euler>
In-Reply-To: <20211204001140.GA953373@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d97e9e4-ded0-4925-4b81-08d9b71e9fd8
x-ms-traffictypediagnostic: VI1PR0402MB2800:
x-microsoft-antispam-prvs: <VI1PR0402MB2800A849BC239C15158962E1E06B9@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RhYB9dT9zc6K4nnHnH5lNzED7rqEusdmN5SiDWUdmu8Ll4iD2NeJ4Td7+4wHqGUwh3abfhcTG+xrF0w8Iijd6hLQELorzDuibaPwJxgrcPMAVd9jRuguEV/pnFq+gO2EQVqnukuni1kiqvyL5O3rxf3YdEmz8B5CQHd4QVuu7pEYIRVVEeWmgO39rgmd+5AFrN862GNV+uSSxzmSCgMLAUb9PaKbLoaHXiosjovrwCgU4k3N4eb65mQz2acAfHYm1puxddUrDnKQWBqhzqsVtsimwTOctCvBISUYyH9mWhHWnC+M+BQvdRVDw1XfVytaHuyBtJaTyMBlKRIFILu3bBkZsdoyQ3BOqvj5n/THaSpEbAsbia1dwOKYf5/FZi1qcIXuqfFQgT7UfZ2dOAc4+pNvH7IqaJekdo9Kc+NT0cbBNNi6Wq83VPvopWBQ3PHB6nCwqeLjTqd2yeoQHmqA2uihnRRjnwAXi8Zt9YU1euViU5QDoa24w6L44pJA/rFftEZmekKFkKE4mWhv1hF3BXTOLeOm1SFkiaOQ+Mi00FrRy7T9e7NOsStfxvyRU8RSwmp9ZzynXy1GO4uSNxv4s1KnqslxYgFXO/0SxtoUWCtlqdDD/IWzE90WWIkZIaS8JfqqMza0dBlKRHHt0GgnRx+qYObE7EpapMFw0XAjUnEXFasONnZYFh8AsLNp/40QikcZXL7PKGZKGuAue9kdfBPPae3snxJQ7B6sazSK8vEzn+lqUnI5L9G9bgLPe9eZlpoXqcpSeK3A5XOfoQRkTmAeIuYdr3k7PSfQR9Lnv6k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(186003)(6486002)(38100700002)(966005)(71200400001)(122000001)(9686003)(6512007)(38070700005)(66446008)(66556008)(64756008)(86362001)(66476007)(83380400001)(316002)(7416002)(76116006)(91956017)(44832011)(66946007)(33716001)(6506007)(2906002)(26005)(4326008)(8936002)(8676002)(54906003)(1076003)(5660300002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uDnDb9QzsBFAZ7qaKWMm9sysXaHJ9R3x7yhCBbezILWtOB7sWhPh7MWMoXh+?=
 =?us-ascii?Q?7CvEwMdQTq52e7uBTdSY/NEGvgnFqnHXmcVEuMXlXk3aWA5BFcLoVpl3Z9gP?=
 =?us-ascii?Q?qe4nFtY03IlD/Obc50vfOvmnDXdTPQaGHgCyliAxGwg68puH9rUbD+erLcO6?=
 =?us-ascii?Q?0F+7U3w1VoPOYRora5NCAWKm/bTJsdpXUOHKyftwbWKfx8ydUR0j/2rbQ6ti?=
 =?us-ascii?Q?TphwzHPQEPjiZ08AJe188Hilz/Ny1mM+0NUY6Dw7LOuE5Fp22DbGaBbHlsT+?=
 =?us-ascii?Q?AeUEO9Cc5yLFJr+U6NCjv0HyALzaOdhUbqw+HBapwEGz3el3khMdmRnIsdLf?=
 =?us-ascii?Q?ns9OAwdvmB1XBHXPInprAoGzKHzNT2SOI2w7h3F14dDd61BczEZMiiv9lueQ?=
 =?us-ascii?Q?tKJNUGLcS2mdMtddMo1T0fh+3CWOjEwH2U3ixPKlcfxQ96+t9Vb5NGSqygnG?=
 =?us-ascii?Q?0eYRjYUTsWuaLDrNQ0yrPyCKrN4ldOy64wE888DPlljsJzBVa5WRhXLRcoRl?=
 =?us-ascii?Q?FvZdbZw11lrG4T/Yb8ElWiPn+k9TpKbr59uobLlCZp1gE3LcaVaEbxVvQI3o?=
 =?us-ascii?Q?E6P0zfM/Y+dLbpVfLTrWSIRVwXq6bQZMWOUBqXIrCNCWHHKyhVR3AoLj2NyO?=
 =?us-ascii?Q?r2Qg6uBFyy0CCfVpCinrB2gZxCiAEBvVmrb5vC1PaBFmUS0n2HieY7Vgw3x2?=
 =?us-ascii?Q?hj4vuL+WYrUQ/QYN4rWxlyJELW9fDZJhtmEycjxHrlPw9Yjo/5vI7qLi+ZVE?=
 =?us-ascii?Q?mzn/m7DwFFR7Nm1qei3HaT8191Sp/EhCEWp8R/GbuG3PNnZGw62H8mAkVhkC?=
 =?us-ascii?Q?9qO/+YyS48wJzpbhNiTpGQQjjwueiTo+qfVn6wEajft8VhI9ol4BoQBjo6nJ?=
 =?us-ascii?Q?Cpv+vkwdslhbK4YSY4My2CKmGI2XbI71kv6NG3lB6DtMhbczr4eSNs3wI3VA?=
 =?us-ascii?Q?Eki+WgAF3wDFvVYRLrDoYazmKrG+4aYKUQF9LmFc7tMz7wHfZ4odcOShNBkz?=
 =?us-ascii?Q?fqKqAfScAXeg0bjKT33RvDmRnKYt+Uf9j8VmIznnlJOddcV9onZfhTn1LZ6f?=
 =?us-ascii?Q?DUwVaorsxtq60yWFzSCkBwQ0UiylR+1WZXs/xZzdPQQqHSUlmioXt+kXGKBZ?=
 =?us-ascii?Q?lKdF1CEYNMs3hMRcVf4iMtPB3+W9KkBfA2s4B8ws/yT0tOQ0M8UUwTGx1FqQ?=
 =?us-ascii?Q?5YE5/ERQ0P+ZpFxZvloPpbONm4Q7RolXaxiRWtRPeXyGrTdoGcr0Bd2+VSPP?=
 =?us-ascii?Q?f7bc8wMcbhyInnldZP3UaZTBP2bbzE7u3UB9mGlqraUxaUUiLMYLZvR68rCX?=
 =?us-ascii?Q?HS/4PCa0pWhXMZUq1PrdWYyfDYSNS6BBfsABDw6Zb0vQpe0mNpHlhsLiSPw7?=
 =?us-ascii?Q?tnDDgJKAkcf2O81DIewSQHS3l/1J8Zpr+yC0M8PTSGyzwTGpDkHBbIYvl0nn?=
 =?us-ascii?Q?5fpKfFTmgL5Muie/gmhHaxrS5yDNgtYiZY6O5TOqolDbNCBgQGgkkph3ySSp?=
 =?us-ascii?Q?n1yR83em8IwQkSuGFlgPUGd+8oranVybbsw7qiVcr9YSAMJ2J/Ei9UsuYOA+?=
 =?us-ascii?Q?mjqGtYOcFDfoXwlh5+Z+Cr9jjF97cCCBHcOTdQl6AFZcwoLba5koCN0cYvU2?=
 =?us-ascii?Q?LpkUmkagC9UcbpWCBRXLZmk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCCBBD87C86E0647A17E553EE3FC812F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d97e9e4-ded0-4925-4b81-08d9b71e9fd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 12:07:20.6884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gv0Gk/idtd3CwWd8XCzdkz8f14GT/ZVbdBGrrJ/K60m7TdrAJY3A+wbcYqvzjSrRowfCvgrbmXVE6Yd4qTSqqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 04:11:40PM -0800, Colin Foster wrote:
> On Mon, Nov 22, 2021 at 08:45:56AM -0800, Colin Foster wrote:
> > On Sun, Nov 21, 2021 at 05:19:02PM +0000, Vladimir Oltean wrote:
> > > On Fri, Nov 19, 2021 at 02:43:10PM -0800, Colin Foster wrote:
> > > > Add an interface so that non-mmio regmaps can be used
> > > >=20
> > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > ---
> > >=20
> > > What is your plan with treating the vsc7514 spi chip as a multi funct=
ion
> > > device, of which the DSA driver would probe only on the Ethernet swit=
ch
> > > portion of it? Would this patch still be needed in its current form?
> >=20
> > I don't have this fully mapped out, so I'm not positive. I think it
> > would be needed though. Felix and Ocelot need regmaps and will need to
> > get them from somewhere. The VSC7512 switch driver will need to provide
> > the regmap directly (current form) or indirectly (by requesting it from
> > the MFD parent).
> >=20
> > I'll be looking more into MFD devices as well. The madera driver seems
> > like one I'd use to model the VSC751X MFD after - just from a brief loo=
k
> > around the drivers/mfd directory.
>=20
> As you can infer from my RFC today - I've looked more into what the MFD
> implementation will be. I believe that will have no effect on this
> patch. Felix needs "ANA", so if it gets that regmap from the resource

Oh, Felix needs much more than just the analyzer target. But I get the
overall point, having the DSA driver get the regmaps from the MFD parent
should be fine.

> (felix / seville), by "devm_regmap_init" (current implementation) or
> "dev_get_regmap(dev->parent, res->name);" should make no difference from
> the Felix driver standpoint.
>=20
> That said, I'm fine holding this one off until that's proven out. I'd
> like to get feedback on my general RFC before skinking a couple days
> into that restructure.

Some feedback given:
https://lore.kernel.org/all/20211204022037.dkipkk42qet4u7go@skbuf/T/
TL;DR: my current opinion is that MFD is the way to go. Andrew, Florian,
Vivien, please chime in and share your opinion too, because this has
potential implications on the design of future DSA switch drivers too,
once a model like Colin's gets established.=
