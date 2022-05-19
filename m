Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328E052DAE1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiESRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiESRJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:09:39 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30048.outbound.protection.outlook.com [40.107.3.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE59E9C2CD;
        Thu, 19 May 2022 10:09:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2ayU21rt9Wi3BkfuyMYlHTQbIT4fHUFuhB3oNBf2AHTAHfTNZC3QhJbhmf6wO9DtGDei/Ln8kXluZSm3SsvKRI3aTLob8sCFB4G9pLprh6ve5A2KG1CSjgiKjpIsWTQ0ZwMqZOz579KXZLuXZiuofS9pK3XpnWoUP1yZuBwAVbqeOc57z/nzGE6NaUxsqrpEW/ekrL9ul4/43eZfGfTM5SM6Zwxkl4zOCqwP90DfEmy6f0iQTRaR0zkleKGTtqtoU8Y5WBuaOkLNchIPQeVIYzu+RV3ysHnu705OErCCuxH8w7eWwH57jXqrcU85dbHAgs7cDFzonJjzYdi2GlbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXpbLzb7ES0RFsJz5h5AceM3J/5ytbaw20Bkh1/rttc=;
 b=leimF9P5uBmrImTiaXP/m3nKHVzWvssVH1TbQp8lFzVn6iA2I2IuwgkpJqpGESkrG/pzVgOTT8GhoDlJfs2VfoFagKQ7dtLCQMflebnfsfx+kZGgJSFkIK1Y5qwjBA+LXyTZ+OpGV67yp8+pUtO4GiwkPbTbh8xesljctK/kYv0k1ySs7AwoIoBX0CbCPuSanymhvR0DCPwLCRiXuifyvjK4HoWjrnOKb1fm2Y4avGTxYm8PjoHL+PoxESAcf+4jG+kHMSM99KOxbdYMJIfx6H9tRZNPTESHoC8Ffi5VBWQn233/Axmxbf9brJN/DOAZnLoIQ75m6SSJY/e5nuiz9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXpbLzb7ES0RFsJz5h5AceM3J/5ytbaw20Bkh1/rttc=;
 b=o2wYDDfwZd/FGc6PGRKzdocHUT3mIkyzA8I0nBgm76Sx833gNK/Hp1a1zMYZDo73dRSqwNcYV+kCm5xItPTMB+ftWGsTgZrLp5csuDvnnUf3XXNb4Ra6qJF2EtjbSr4ak3/BBMq3zQf6s01WIviTDOnW80xD9G29p6Cc4/GsNok=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4423.eurprd04.prod.outlook.com (2603:10a6:20b:20::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Thu, 19 May
 2022 17:09:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 17:09:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Thread-Topic: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Thread-Index: AQHYYwzpO7u0NDHwdU2qDb+lARh+Pa0WyfwAgAgr3wCAB2H8gIAAGTwAgAAPOAA=
Date:   Thu, 19 May 2022 17:09:29 +0000
Message-ID: <20220519170928.qv6mn6arjgzq7doh@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf> <20220514220010.GB3629122@euler>
 <20220519144441.tqhihlaq6vbmpmvd@skbuf>
 <20220519161500.GA51431@colin-ia-desktop>
In-Reply-To: <20220519161500.GA51431@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f379401-646d-4502-cf9f-08da39ba55e5
x-ms-traffictypediagnostic: AM6PR04MB4423:EE_
x-microsoft-antispam-prvs: <AM6PR04MB442336009C34E741F8DDA02DE0D09@AM6PR04MB4423.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y1Y4i9rfchvru5KhgsBOtPPR6dXxtZVvheCnNh+na3TcANaqvLkPI8LeeJvc+RaCs4Fo5WdgUls0CojdVxV82jHhonNds1nVJ/zfvCq1p4k7WNQDINETzChagYY+UoscNV2Mx4sMeVidstkjXx574XhxFY3Sh1QxHiTIQf83q3m35evav+0geXKBfD2jppUZr5uPjO7zwgQBlE4wCnJuRYC/Nqn36LV0G8xD2w2T8SAvm2FCWXTSE7KqUhN69Aj77U5ixYq31s0kKJQHw2GY4ZEWGZvXZhOhnC6QijAhMT1xQvVzINalLInM2+eDnDnbafDuy7yRf+a0LOrDTTnYFVux2YKocRqxxffDOOhq5GZCTarGIVTLiZmNb7zarRWvRg02k1s5f2Da9sywv25ycA6mV7DFBJ1XypK8+Y7uEos+PqXsgIuU0XIuYWXFAhYuTdl/MFOwMnwyiKUMurzYvET4tIg+PL1qQ9z4XV/oFKzH7DXMtYioYOYYwuE+TqbRbovLgpBjGAud1snCqIeygTphhczkPt82PEKpeel9I9tbjG4yiO83cvWA85fjZigvIoVoTjBs3/RS9vdUzH/Aqn2nQ0tz8+9rWvNTyJ9GbmVQRxKwSAG30xbB9uXWGmhJ4hqDM7EQftwa3WHGrqp/zBHTeDS2Mrpyt7t9kZENxhjFkOQxlDNTtCYgFB9CdtyZsC4KvaUCsFS2UFMQ16FqZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6512007)(91956017)(8936002)(76116006)(66946007)(316002)(9686003)(508600001)(64756008)(66446008)(66476007)(66556008)(8676002)(4326008)(7416002)(33716001)(6916009)(44832011)(38100700002)(2906002)(54906003)(71200400001)(6486002)(26005)(6506007)(83380400001)(38070700005)(122000001)(186003)(1076003)(86362001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JVU9C3k3PhqmrmVOaFcIVcOPtWM+I8Th7aa389xeJHFpREXqAV1bHV2hQWPq?=
 =?us-ascii?Q?HCZt7vDezdJ3v4DzReqOG3xTzRM/dYnLgU9NyVmqRvx/oBF9+wxpWHvQp5Mn?=
 =?us-ascii?Q?EVgNuH4bEsSuvjQDtBRqviyhSkDWW1Xfd9jvw8aru7PcHW1g3oBrquwTsCex?=
 =?us-ascii?Q?HPqRsT+H2kbHw5QZb+CXwcz+8CGN0+5j1PPnurVln9e0W3UG+QnQ5eT+YiA4?=
 =?us-ascii?Q?28z/lo83om62KEAzBnIOHjViq/XeTjqKVHd9Aq98GOaThJzgyJ6pWqcyPCxo?=
 =?us-ascii?Q?l5Bv2rTtEV9dHcwKQhC/yaNS4nnEWs3Ol0bYdqzEpMVpxpzd8JT/aekMQzlH?=
 =?us-ascii?Q?Ao/KIqQlGP1yQ6innf/Xg0w3dw8PtRXUINRi0s84iTSV8vkkhPzVoWuDOu3F?=
 =?us-ascii?Q?bGepvQgDUAzT12C7SaLkpN0RkPKEbU8uOo0G7q3twiSH8RsrgRmMDqjXGCrF?=
 =?us-ascii?Q?G8qYSYXSIY+se34pbYUu24WNOfcUpQfvaKWGFo/MCklTg7PyOtosyh/e5M2h?=
 =?us-ascii?Q?7O5pg3E226H+oQMtOkjDvuO6AHLlf0dnSogS2HUf9YjEsW+t+PRkSbdJVjz/?=
 =?us-ascii?Q?b+uT4CN821G0H05myAqwPcXqJ2jdit+ZDG3yYR3eDCNVH9E2EdCZPtMI2w4C?=
 =?us-ascii?Q?TemQucVozTWqlBdwickK/Nh0Ojbs3AJC7hzpBVik0TQXO+YeW9C+HjRCzotC?=
 =?us-ascii?Q?YYTz3qXg9laoTMdWjuYACKf9UoZT+OQJhMn7BZ6wprFuzfLlqIIHueGSd2i2?=
 =?us-ascii?Q?T1zYrrJGKcmcvc2semV2jsyckOA8gdKGN4FgCeDgmZMplvr8ES2dHgbQ9I8o?=
 =?us-ascii?Q?kIasoJzcXHwf+XwFt63gLdizXwiMmwRM4Z8frFWa7xH3owiwz3n8gBdwQj+p?=
 =?us-ascii?Q?IdOgNTzo81qiWf5lpeSbdaX0H5Y6PB+iPrR0uwL9pUHkypgppniUrlEPrpEK?=
 =?us-ascii?Q?OlLdPgktb1cFqHLFLPr0vwlzFAxhRmZQ8/tihqfbP3veLMHpwXIB+OA48SfB?=
 =?us-ascii?Q?cUQgd8uKaiQxPSIus6+UBU7Hk3PcyRVJ8ZXYo4yc8f+c3xWXMoghfUne1o39?=
 =?us-ascii?Q?H3e8DjGNIHV1w1NdQ8jBD6BzLSd4/JCrQvWItWY6YRi2u81cIaKwIuhKqn75?=
 =?us-ascii?Q?qqksG9vSl/hlx5WW5wTUj3as7eYHvksVpnimlOyJoTTYaCohaI0qWNtN3Gxj?=
 =?us-ascii?Q?N4srMLh91wSAs8a0ZIS8PDOueIZevOB4mM1jpzS2CxUqM7baRHsc1zmL8UiV?=
 =?us-ascii?Q?5/GnYQ4CiLLmSUYQ40UbGKH6FhqFyl04u7XCamGF9Lb58tmewiJmLNaNFLAh?=
 =?us-ascii?Q?3zAMhL0gH8QDoOqy/ReWVF+Iyqyrq0RXuPWiVx8+6yMV++6YPr3CzuZ01OHh?=
 =?us-ascii?Q?kH+nPrgs1wgDcIY+s3Tt9uamcecR2eezxxzL8UvoTLKuN4V/G1YBPVrQYmmf?=
 =?us-ascii?Q?AtmdLFv1sETTsYTtgX1l1EEyMjCyNLIJLA1T80ZD8qR7eOFa1/Da3Xl0SQ9T?=
 =?us-ascii?Q?B7ssCt+0g1rLjIbL5zuAbuP++fAoJnMCEUEUCQ3bNw1uRW/dkiesX8kvcmAo?=
 =?us-ascii?Q?eXVXWsqitVHi269ghcRuqVXNesWDZWjpvFPnSzPRzIoO47k/f3iyvia8y5Pj?=
 =?us-ascii?Q?Bv0gU5C/Gt/+YxJ59WwppUNCzoUo9Z2+xJlZzxJ8ebMGYFqY2Q3T3NYfj4tu?=
 =?us-ascii?Q?wkg0FRC/OcG0UnzgWRML56acNhAZDrzCjNZ+bsMNombaOxiFpBVovG3Z3n6n?=
 =?us-ascii?Q?s2RrcCtrNE2SlxTRmCrEvGcPJl/ikao=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9304FE69D7328439E7A383A6FB68C29@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f379401-646d-4502-cf9f-08da39ba55e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 17:09:29.4014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bh9wvc1DAhsYmpwx9OsRpjLU75zhB7xif7g0g2lE0DPOIOlICyyOgG+KHXHgPwwRabxz9TUXV9HPL8CEA8CnDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4423
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 09:15:00AM -0700, Colin Foster wrote:
> Hi Vladimir,
>=20
> On Thu, May 19, 2022 at 02:44:41PM +0000, Vladimir Oltean wrote:
> > Hi Colin,
> >=20
> > On Sat, May 14, 2022 at 03:00:10PM -0700, Colin Foster wrote:
> > > On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> > > > Hi Colin,
> > > >=20
> > > > On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> > > > >=20
> > > > > 		mdio0: mdio0@0 {
> > > >=20
> > > > This is going to be interesting. Some drivers with multiple MDIO bu=
ses
> > > > create an "mdios" container with #address-cells =3D <1> and put the=
 MDIO
> > > > bus nodes under that. Others create an "mdio" node and an "mdio0" n=
ode
> > > > (and no address for either of them).
> > > >=20
> > > > The problem with the latter approach is that
> > > > Documentation/devicetree/bindings/net/mdio.yaml does not accept the
> > > > "mdio0"/"mdio1" node name for an MDIO bus.
> > >=20
> > > I'm starting this implementation. Yep - it is interesting.
> > >=20
> > > A quick grep for "mdios" only shows one hit:
> > > arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
> > >=20
> > > While that has an mdios field (two, actually), each only has one mdio
> > > bus, and they all seem to get parsed / registered through
> > > sja1105_mdiobus_.*_register.
> > >=20
> > >=20
> > > Is this change correct (I have a feeling it isn't):
> > >=20
> > > ocelot-chip@0 {
> > >     #address-cells =3D <1>;
> > >     #size-cells =3D <0>;
> > >=20
> > >     ...
> > >=20
> > >     mdio0: mdio@0 {
> > >         reg=3D<0>;
> > >         ...
> > >     };
> > >=20
> > >     mdio1: mdio@1 {
> > >         reg =3D <1>;
> > >         ...
> > >     };
> > >     ...
> > > };
> > >=20
> > > When I run this with MFD's (use,)of_reg, things work as I'd expect. B=
ut
> > > I don't directly have the option to use an "mdios" container here
> > > because MFD runs "for_each_child_of_node" doesn't dig into
> > > mdios->mdio0...
> >=20
> > Sorry for the delayed response. I think you can avoid creating an
> > "mdios" container node, but you need to provide some "reg" values based
> > on which the MDIO controllers can be distinguished. What is your conven=
tion
> > for "reg" values of MFD cells? Maybe pass the base address/size of this
> > device's regmap as the "reg", even if the driver itself won't use it?
>=20
> No worries. Everyone is busy.
>=20
> Right now it looks like this:
>=20
> }, {
>     .name =3D "ocelot-miim0",
>     .of_compatible =3D "mscc,ocelot-miim",
>     .of_reg =3D 0,
>     .use_of_reg =3D true,
>     .num_resources =3D ARRAY_SIZE(vsc7512_miim0_resources),
>     .resources =3D vsc7512_miim0_resources,
> }, {
>     .name =3D "ocelot-miim1",
>     .of_compatible =3D "mscc,ocelot-miim",
>     .num_resources =3D ARRAY_SIZE(vsc7512_miim1_resources),
>     .of_reg =3D 1,
>     .use_of_reg =3D true,
>     .resources =3D vsc7512_miim1_resources,
> }, {
>=20
> "0" and "1" being somewhat arbitrary... although they are named as such
> in the datasheet.
>=20
>=20
> So you're thinking it might look more like:
>=20
> .of_reg =3D vsc7512_miim0_resources[0].start,
>=20
> and the device tree would be:
>=20
> mdio0: mdio@0x7107009c {
>     reg =3D <0x7107009c>;
> };

Yeah, this is what I was thinking.

> I could see that making sense. The main thing I don't like is applying
> the address-cells to every peripheral in the switch. It seems incorrect
> to have:
>=20
> switch {
>     address-cells =3D <1>;
>     mdio0: mdio@7107009c {
>         reg =3D <0x7107009c>;
>     };
>     gpio: pinctrl {
>         /* No reg parameter */
>     };
> };
>=20
> That's what I currently have. To my surprise it actually doesn't throw
> any warnings, which I would've expected.

I tried mangling some device trees and indeed it looks like dtc won't
warn, but I still think it's invalid to mix node address conventions
with the same #address-cells. Maybe if that wasn't the case things would
be easier.

> I could see either 0/1 or the actual base addresses making sense.
> Whichever you'd suggest.

The idea with putting the actual base addresses was that you could then
do that for all cells, like the pinctrl node, too, and they'd have a
coherent meaning.

> I've got another day or two to button things up, so it looks like I
> missed the boat for this release. This should be ready to go on day 1
> after the window.=
