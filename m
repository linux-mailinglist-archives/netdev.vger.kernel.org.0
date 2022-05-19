Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5552D65E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiESOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiESOop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:44:45 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140048.outbound.protection.outlook.com [40.107.14.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C35D0295;
        Thu, 19 May 2022 07:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYc7thVRmr+me3RkLmE8SHLOrl5/0uMhrcGRr5tMj9lJt1RtvgqAGWGPEEqZZNrD8jDVNiSq2EqKJ3xfUjdYA1y2rsaQkdubTszYpwkxxY3Kh3GnsOKkG1VQCCuZ9ZiLp9uM7GbifWhCHEDSbCLMMVOMep+cOphlie8RO6EZnk4Qd7nQp/bVxNtvEwCRruXTdIXbMX5SwDK/HnTm2tHhZlYz73gRFeOfVeXcJI0ABzfmWAEY1/XGHG+e7AeWn1LNEY7DOc7tJs/zob0x90uFEj1rmrXEWYPGVoWrKLIpxFd78Jg2UDQTTEVvJ+XbIlKLvELb8Q4FBx3wkkvjPAz+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WYWoMfe97xeO0NXR+M5FsutwqpyloMd0DHgVIIAo9w=;
 b=gzrmpsDw84dQ69PncQctU8p8q+Da+yNe0OSgg8ED3fonYEEuilLycXWM72LsXFplmp6QXB0mwxDebYr7gahKz+R+Q1R7OYnAl0IvVhkNmVzSiM0zGdy4NyQcIw+aS7lwPs8xEM2tMJWtjQ3KG4LlBsZbrnwXLPMvyPoJQJE+FrNNJuhFTVqdHel1N3dGkp/SdKN4BnTOPXCklljx7/0iOizTSdj3edZp0vxFoKtBKvEuqWwmfPTQhwQ2lLsDw7D8+2PEpDFzXrQG0IaTjEWnImK8vCUk1toUPc20q603Pb0OplSSt6c6PgVNilZ+QgJXV7B17jtv5B65hmlKEoiEbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WYWoMfe97xeO0NXR+M5FsutwqpyloMd0DHgVIIAo9w=;
 b=DdXiY2hUX3DkDMMXnSDK+xYDt/poCXXKW4pkafuAtYX2+r/C/cGBj3yWkpu12OxVFz1ulK98OaRwIAKnZCAk2SNBqLb6p7aL53Xd7zJTAMO54JV54SYmNTp9yIIMQko2V6zC8djL1nahKTllCkuSV4nR54A7U2a6+qbvtYAARWk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6034.eurprd04.prod.outlook.com (2603:10a6:208:143::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 14:44:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 14:44:42 +0000
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
Thread-Index: AQHYYwzpO7u0NDHwdU2qDb+lARh+Pa0WyfwAgAgr3wCAB2H8gA==
Date:   Thu, 19 May 2022 14:44:41 +0000
Message-ID: <20220519144441.tqhihlaq6vbmpmvd@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf> <20220514220010.GB3629122@euler>
In-Reply-To: <20220514220010.GB3629122@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12507f4c-ad86-40fd-717b-08da39a61bcb
x-ms-traffictypediagnostic: AM0PR04MB6034:EE_
x-microsoft-antispam-prvs: <AM0PR04MB603453DE93816937EAB58F85E0D09@AM0PR04MB6034.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3yBBEViEndQfGImISI9lXunb2RhluLrHVeR2VpZIZK+HEUQkCqETjVKzEBQZtcuG7AZs/l22p9MY7cZ1/Vy9bL7rxSr3yr5aZBk3SbFgBMlYkkdmZdaDQcoESVKi6y/uPvy6e/pVutyETWCIztY0iUPYXnBGvxAyuH+/hTP4OCy+tZ3z1xzyBuLT0a5M1Yy1DH/5ZrBvogdWcnYRy1ghetnG4Ys3qUoIaHyLwH/3InjJUvIxEBdV8JwlvsqXX/dW1UUNmc7eKJh8ePj+k8X7k7/YiKitIdRi/kyHBCGZSPhsSH9PknBxhPjfb4KcA2JJ3NeevXvOdu4mxxvZbto3aGVWhgiicslqImIIQgJ6gSjNUhauRBKYSygWzp0tktUMPujAsTFoeFffPpx4DTNpienL236dx6eO6pn0FF9p6lvkQ88L6YqUnrJ1AHOGfaF/THrlerMw2FrkK8W/nQ5mR0YV46fVYre2954uiVXwodV36rAxifCxjgfXjHdsKMLqqUqXqr4+itox7pS9SLQimc8tIYweax1N7UcEg17oc50mqoQz2OLwxtVLuFChnIWXjxVaeR7Kz8WLTHijBj8c615ABhjON00V77qzORuVgHdkbX+njajtemD2JCpxoWFypEuFcHcXt6i7Wi+O3amQ2syztM8oX/AmFAhsI5d4lasJNrqph+EcQMrR+DzlHm4rOMpoTccsSkCiZ782eTcWDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(33716001)(8936002)(66946007)(6916009)(76116006)(54906003)(6486002)(6512007)(26005)(9686003)(5660300002)(44832011)(316002)(6506007)(71200400001)(7416002)(2906002)(508600001)(186003)(1076003)(38100700002)(38070700005)(8676002)(4326008)(66556008)(66476007)(66446008)(64756008)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h+2VP3v8TbhHWLJBgXv/1NqzuOxOgvOfOMSLF2CXbDOtZbvnVIquwv9etbGN?=
 =?us-ascii?Q?2TSmuUbMsIoYUmuKcb/RxAf1RLf+e6vf94KUmLc9foWm6f/i9fLHCKJ6de8m?=
 =?us-ascii?Q?9snh+rWxZEFfafXlnCYvnwE27Y3qZRzBZY2XUTdBhq7tZNdXpr9GIOS54TKW?=
 =?us-ascii?Q?DQAy/GLDjk454AAB3HiWNZR3fCPmzly1yh+fMpWBv2nMuhuyLRSkIjsjIFVB?=
 =?us-ascii?Q?Cf6RvUpPlj5yG5P+/9XS5RQ62+1xLY02Hk+EnhySpFoxfJm2NAaJXz+bD8Om?=
 =?us-ascii?Q?d+gcn0Vtv/8MXDliIoOd6qEBumQrZCABzXwLpU13i8pxpkxqT+pNw9PHchkO?=
 =?us-ascii?Q?pObjcuH9sqoP5qiouLWtJUNjX/dMS+LBYeGyj9F5jwhOEcS6R6b+lkJRFtY4?=
 =?us-ascii?Q?SIWrO57T+ooNHVGEugRCZmYTfmewlx3DRKgqaCdjEsob7CFoFNfbXmuCiirJ?=
 =?us-ascii?Q?66ay3tKKHSxO3H+MdNWoOpJgYpAl6T5PxNXX/jEerd2nEW/bkiA/QZMkUfko?=
 =?us-ascii?Q?Xx/Nt6GOvb2oBv7TOFA3BQzX8EL+W1BnNilj+44/KV7F7IMYE0BMFX7yisWS?=
 =?us-ascii?Q?kPCnJ7OZHHJUvRzWGchyytH07YywhUyq7zB0aopFh3PlCQSpzf2mofAibmSz?=
 =?us-ascii?Q?Oel80dH+3Rj4qeVG70JsVdsw4a57Yc9GEQxGoC69hfIyWZwt/pqSHkte5hSS?=
 =?us-ascii?Q?TTtPMOxT9AZxqOcUXBrXaABIiDdZ8fZdXBcmstKOJdSZja+bJDC5r+C4VeFu?=
 =?us-ascii?Q?oyO6vlbalV8BJvslP1u8Gu+NCOjr0acz5OIiAdpyy87kyds8jY5uaMqH6FU7?=
 =?us-ascii?Q?6ZOHB2jWEiVTZomTNmJ1yWPgv5ATjgryHhWkZXU+wq2txIoHQvhh1029S5QB?=
 =?us-ascii?Q?uMr9bO1rsb82AJ2peP5x7wn31MPXrANKzGpCj4pfJoJ/Xv2MBOcPjQbautJ2?=
 =?us-ascii?Q?gMfbMAxq/+QsEgmfq5pYKL99T8auMphr/Blu32a8HB/hUTS1+YniNb+vC5T0?=
 =?us-ascii?Q?GaxapvWDy6FazjT5yl/sny79l1VDwJbLRmb6Li9ANYU5CV1giQNSK2TUJm2E?=
 =?us-ascii?Q?fWXJv9etqSh9QFNyar9MpzOvroffHLFVx1SBzwRZrZXrpfNDnM/rjBSYZWe5?=
 =?us-ascii?Q?o/SLUlSsma6Zf2sF4WwlzkP8IZTOw/bizWBS9M66uPGzz393KiyqbKnsw7aS?=
 =?us-ascii?Q?z2U9iJSmUOHEQnGsOBbr7csaX3ZnvvxVGX4fW8N1YTDSHtJKKvNeNugJhTAS?=
 =?us-ascii?Q?R1EQT1nFU/+WLM41oN4isJ/na0NUJudp70fxRnV+3BKDtWltJVhSS7wXO2Aj?=
 =?us-ascii?Q?xC2m9a+s9DoCf0jG6QzlizZkPtyFVYytjk5cKr+oXouVP5NXE38WMm4ZPeJN?=
 =?us-ascii?Q?RhGsBdGMJEw+cQ/LxqrnqeYl8Fnw3hAB9WcZwrhiKdCo68mAxb7+EUlYn+vc?=
 =?us-ascii?Q?8+5LiqdeuFEQr0q5VlwhEp/c5VwcjK5yRTpq03HrsldYjsA5t7sKX7q4SG2T?=
 =?us-ascii?Q?CVlwrwUHP+uvKCZ4OwFif8UPcGiQbAI0O/s1DzGpcav9u81rqz1/V1sxfxK+?=
 =?us-ascii?Q?Cn3Ocldt9dROio6w/r8GHm5qiQfMFsLI47T/9RqB0+tAOpe6hjzM3jydEW8G?=
 =?us-ascii?Q?QWECN2WYoq7/Ni/hGtFjBqZqi/nv3psvABkPyXUFXS0I6MQG8Z3psdx0KVs5?=
 =?us-ascii?Q?jSI24tw2TlXa8vo8jAvk/213Dl7fuXMkESzVh5CheHcvYDRYoFNmk/VQ4lUo?=
 =?us-ascii?Q?PVhOrSp+8Np+U1Ne1Hf2t5EUlYjWpJE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5AB5B0067387D48B2BE5ECFC5EF3257@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12507f4c-ad86-40fd-717b-08da39a61bcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 14:44:41.9393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ldxs32fcOtbZyC/wI7OmaqOHCeS4qdae6cbPCYvpxDoEg000XYrrh4agjzRmdFntTBopIgaPLjXJcGw6odszKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6034
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Sat, May 14, 2022 at 03:00:10PM -0700, Colin Foster wrote:
> On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> > Hi Colin,
> >=20
> > On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> > >=20
> > > 		mdio0: mdio0@0 {
> >=20
> > This is going to be interesting. Some drivers with multiple MDIO buses
> > create an "mdios" container with #address-cells =3D <1> and put the MDI=
O
> > bus nodes under that. Others create an "mdio" node and an "mdio0" node
> > (and no address for either of them).
> >=20
> > The problem with the latter approach is that
> > Documentation/devicetree/bindings/net/mdio.yaml does not accept the
> > "mdio0"/"mdio1" node name for an MDIO bus.
>=20
> I'm starting this implementation. Yep - it is interesting.
>=20
> A quick grep for "mdios" only shows one hit:
> arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
>=20
> While that has an mdios field (two, actually), each only has one mdio
> bus, and they all seem to get parsed / registered through
> sja1105_mdiobus_.*_register.
>=20
>=20
> Is this change correct (I have a feeling it isn't):
>=20
> ocelot-chip@0 {
>     #address-cells =3D <1>;
>     #size-cells =3D <0>;
>=20
>     ...
>=20
>     mdio0: mdio@0 {
>         reg=3D<0>;
>         ...
>     };
>=20
>     mdio1: mdio@1 {
>         reg =3D <1>;
>         ...
>     };
>     ...
> };
>=20
> When I run this with MFD's (use,)of_reg, things work as I'd expect. But
> I don't directly have the option to use an "mdios" container here
> because MFD runs "for_each_child_of_node" doesn't dig into
> mdios->mdio0...

Sorry for the delayed response. I think you can avoid creating an
"mdios" container node, but you need to provide some "reg" values based
on which the MDIO controllers can be distinguished. What is your convention
for "reg" values of MFD cells? Maybe pass the base address/size of this
device's regmap as the "reg", even if the driver itself won't use it?=
