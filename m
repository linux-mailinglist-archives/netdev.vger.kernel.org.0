Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86999564017
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 14:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiGBMmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 08:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGBMmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 08:42:12 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130052.outbound.protection.outlook.com [40.107.13.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DDD10FC2;
        Sat,  2 Jul 2022 05:42:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+7IzL9fip1ex6XwZ0jhqwU5fOQuDRfeABIepV/T+RI1Bg7S0XMW/hug+Wsay7mwZWuSwesvZyFm3qjrTWZ8ViWRDgCnpcHm/OFa47+GUCR0fBNYiQHAncRRk4+iU5zquO0bAURfPwjG4jdi8/BBSq8Krc6ipCNhR6LbHteKioMEavM0KqGpzAYle8NSoFH5jaYTy6vST0zu81BC0AV9wPsExkXhRkeOKkk/BLJzjDqXYuhPrLgVH5gPenlbWOXgTm1mA/CoerdOlt8CTOnGeZ5I0zZVI979tr4HQcQdENRqqTxeT5DUPBBgh0jM4teNs+/VZ/mShdHsAI3TtCzQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tXR8ttAO/zvu3ta07Ax1Wg54ARjsYZ3u/q2zHVnu74=;
 b=NLXZ/z4JWWpH0aL85eHWl7RL6AWDhokRrJ+03x8shcbq7b2I+7S8kkir2HAiCoN/GbiB2lQQ/vzoiyAwiCxzpYjgB0wcBSq601cx+CeuN/+M+dfFmg2+rjKhbgsQTzFktSPS178ytP+5bMWiQfrxEHSiuf+iKZvhp+i+RFe1ze0I8wUKij6Gz+IDrP9gl3O3Xs/H03tABHrWYhG9Mg4/6DMDbnvfk+XY4gHD+ceeNx43hpyaAAegQ8O7YxMUEPpXg7FzkIODtC7dSJHw8RMVgnYdX1VzBzH2YtstIBeN+Qngt5YfPhiiEBi6mVjtrloFYcEiRtbiuhwbY9sLPvCgLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tXR8ttAO/zvu3ta07Ax1Wg54ARjsYZ3u/q2zHVnu74=;
 b=esZFJ39fY/Xn+isFFaa2nXRmxuVweldSJpy7nt7s5kXFyZ9xIRT9xvvAIITQf0yfHYAD44B27kVG+owWPydEWxRSHd0bML0FSMJbimXwwzxsH6M8LnUX3EvJrYISHwm9y5oNYuhoaxPcUCCZmQGDz3K3t/PRfVTTsYYd8nGwrDE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3373.eurprd04.prod.outlook.com (2603:10a6:803:a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sat, 2 Jul
 2022 12:42:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.017; Sat, 2 Jul 2022
 12:42:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Topic: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgIAAArIAgAACKICAAA6uAIABb72AgAAuYYCAACmigIAADP6AgADexYCAAHTFgIABUoQAgAAP8oCAAUUZgA==
Date:   Sat, 2 Jul 2022 12:42:06 +0000
Message-ID: <20220702124205.53fqq65b24im2ilv@skbuf>
References: <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler> <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler> <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler> <20220630131155.hs7jzehiyw7tpf5f@skbuf>
 <20220630200951.GB2152027@euler> <20220701162126.wbembm47snbggxwv@skbuf>
 <20220701171831.GA3327062@euler>
In-Reply-To: <20220701171831.GA3327062@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f81cd43a-1d1d-42da-a43e-08da5c2845ec
x-ms-traffictypediagnostic: VI1PR0402MB3373:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Czidw4C/n5VNTlzuSuiJ7UqZGS2BCxdTU77iud+Y313dq86Jj7BVM1WY+vzFLv5xuL6fnbVWDIxicfSQV1CDXAmWZMr1+dtMm4I3qA8dO/RdpJXnJR10FPmKr9rEm2T5ewVqd5ZwLo4rEDwLYfCgzY9mWxiQHxFAP/SOjAFLFs5aromBvQEVwdY1Fsx0JiAs3vaz5YrlK3ZBDnCJBkcdQMR9O+vhG8GuQ0zpqyH8PL4sELclZQbTLoUUK41jrGQn+JTePadtn2jTaEB7IpEx1bLK58DyKS1kmqK2cLsH4ViKvMpkP0EXwXAka6l65kW7xls4cU4rdbf9+rGk14a2dhfEaJySpU/Vyxt24aRHrf+Gxp65ViWLvchIA2MBl4H4ZNwR7XXDo2b4LzoCjv4YwUaAp2S5JjYLm2HFeMb6ehqD7iEemOwZ7cjk+zux1tZkKFYCFvfoBGe89/iuM7OGhDYPdKaiPy1eh1pqZWJZ7EyYrUz3YMfnKetwiOX4jYN2kzd4yH9rtnRoq5pkhyzU9mQ7FTI8v7MkvSnFL5pDV+mDagYSCQCSoPW3+9Rssz7G2BUrtTD3u9OjviVFBpY4Xv48oMl+I7yoZIH0QEJpVfBwO61MemWZebt2TOh2S9tc2U5QpmuJsYEMhPhRH5DPhuEn0Zn+W7G8C86+IzaUPyyjCEYhSFeWrYwwgJtEX/XSan05I/WXE9cI5/T76zvfzW+FQR1fzUUhXuDna4AUm+Pk6lenISxQw4eE5AfW4wmFoQkwcWQte2qkrrDwklzcIk6oV0EiJ0ix5M2NSobbvNI5k5suw9XPlD/0Lz4FgFWU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(316002)(6916009)(54906003)(66946007)(64756008)(4326008)(86362001)(8676002)(66446008)(186003)(66556008)(66476007)(6506007)(91956017)(33716001)(9686003)(478600001)(76116006)(6486002)(6512007)(44832011)(38100700002)(26005)(41300700001)(2906002)(122000001)(71200400001)(38070700005)(8936002)(1076003)(7416002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eHStUH/ubpNc5kU0NAIpkqMmoxcOUKKV9DZF80RUAKx+YpwYEOmPnHP2sagL?=
 =?us-ascii?Q?yywMGO6ruu35ONaJMbQ2Yqyk8o+01nAYSvn24ySc3roaWfj5V1Y+VS8wk0lz?=
 =?us-ascii?Q?B4+iN2H74Fafb71ClBBUY9xhRjtlpituOe92IBChoDUEpHoit4eaGZpJOLFK?=
 =?us-ascii?Q?E2/AcLILKl0cT6CCOfOIkrZpPQXQ7khMVFsuwENhraHyLYCzMy0OmplBvXdl?=
 =?us-ascii?Q?YQCURz4PnYjwPyiUMJ2AD4Us6ujirhDujDg0Av3lBAiIt7nKtSTM0s05DxiM?=
 =?us-ascii?Q?Xpiv7/POKBZtTubVsifU+fWA/kRCpjTcVXIyHshjuF/snmMIVA6UY2PvRTy3?=
 =?us-ascii?Q?aF6ytYDmN/+yYBeL4D1MOBER4MgBC1ni0Y0AofHNXHAhGs+68+Bxb6BPMHFF?=
 =?us-ascii?Q?O0SfjBK1MMHodlrhpciLUEV7yMFLuT1cJ/YguQvYiivy6sigAUd8/0Ib51XE?=
 =?us-ascii?Q?Tzu479VCjEX/YABkwJeL9oJqisY1VAeSA9OXMLB6v13CUQqzJ5QjnxyymIYz?=
 =?us-ascii?Q?gage+inbYhtJE49PHB6nlANgsrn7by0yjzKwcttRv2YiO8NBh/C47Nz7MW2b?=
 =?us-ascii?Q?YnSG4OPhVgrji0P9zzEa7OEcLSLAnXvzNOG5Hhmng7GU3H2rEDbSKoY8rLhB?=
 =?us-ascii?Q?YXWqZrTVC2SA5Xmr7peGeAy/OhX84x2VbvkY63talFr3Ej4JFikSKr/74vdm?=
 =?us-ascii?Q?n8W4RTwTkvObQeqVX7uHbbTqPU3OBbLWAjSnx4TZ2wf9PW+iun4xWhuib3Sz?=
 =?us-ascii?Q?5Q91TD6aBWZJ6p1lDCRDW5fMPaV+7jE5PoNPVLMW7RG9liqFtdFuZ5EgEm1G?=
 =?us-ascii?Q?R9R60fSzAU6Kx4ZVo/Kgfd04D6I/qDPILQGDGGn3+cxSh/EvQzbLTbFNrBl1?=
 =?us-ascii?Q?CtnbaSgNXDiKC3GcN745jj7iKWpH2xXJBYM1U9uU/9wOaGHOOk+m2rRbgZ0r?=
 =?us-ascii?Q?vW01IrN+IpgS6D+8lZ3ByJYhTSyLhkobAsXAC7ZxhH0UGpYIMLjyody63l53?=
 =?us-ascii?Q?H3KtKKfQWj+tqYt1vepbyfASVPzG/YgWWItMRNfUnxy525Qc3WzIsIIyd1TB?=
 =?us-ascii?Q?tBRG8iGhtJ0IORhhPIkzGy6XeRpafZ7szvm17cmG6+VCrWxssyou/wQE9O9E?=
 =?us-ascii?Q?Ew/WnSSVtT8PTBxXB4QtkPNKkFIXukuvytvSihtw865D8ra620fbFCXSx+iB?=
 =?us-ascii?Q?C2nPoTDFUNhzioRpN3nucMHtGBkXbfCSPCGtqLOvk8iMUy5FnJEd0x843729?=
 =?us-ascii?Q?tG7Qe1KXPN6ZbFM1/0MVyys+GIviA+PJQjecG9v7AD0JShCX7Bo+LHWI0TD7?=
 =?us-ascii?Q?5yEuPlfNv7edZYIv5aWwd+dXv2EqfMA67OgXzelftMIs9ttUyUsjd+dMr25t?=
 =?us-ascii?Q?PbKtAkL66F7uYfA6vjSUcbpBlrkJOY7qA12lCDjyUI03CZbPmR3piSJjrGBG?=
 =?us-ascii?Q?6p1uomyuVUCGZ9wusnhg/iON4K9zFfqR21n5nG5W71424/r4rAUp7Su1BTQe?=
 =?us-ascii?Q?aCURacRou669jIQXYE2IFk7P1QIFmK5K/iv6Cev1tRsi+mdOL0W/MhbKMupe?=
 =?us-ascii?Q?nvUTrqnvTAQDhT8mQOqW1/lU8dh83tCB9i/3eFR6S3w/QS1gvgzcJBuaOhyR?=
 =?us-ascii?Q?ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <891D3C99614E0A40AF3AAEF71FD2994A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81cd43a-1d1d-42da-a43e-08da5c2845ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 12:42:06.7305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3LkqqO3VQ/nZlRlqiGXWQty2VkZwAMhmyr4a7Sj56sYW6EhKezd6ARQNCojVv9ZX26ItCZ4L55D+1EXvks6rAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3373
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:18:31AM -0700, Colin Foster wrote:
> While I have your ear: do I need to check for dev->parent =3D=3D NULL bef=
ore
> calling dev_get_regmap? I see find_dr will call
> (dev->parent)->devres_head... but specifically "does every device have a
> valid parent?"

While the technical answer is "no", the practical answer is "pretty much".
Platform devices sit at least on the "platform" bus created in drivers/base=
/platform.c,
and they are reparented to the "platform_bus" struct device named "platform=
"
within platform_device_add(), if they don't have a parent.

Additionally, for MMIO-controlled platform devices in Ocelot, these have
as parent a platform device probed by the drivers/bus/simple-pm-bus.c
driver on the "ahb@70000000" simple-bus OF node. That simple-bus
platform device has as parent the "platform_bus" device mentioned above.

So it's a pretty long way to the top in the device hierarchy, I wouldn't
concern myself too much with checking for NULL, unless you intend to
call dev_get_regmap() on a parent's parent's parent, or things like that.

> > > }
> > >=20
> > > So now there's no need for #if (CONFIG_MFD_OCELOT) - it can just rema=
in
> > > an inline helper function. And so long as ocelot_core_init does this:
> > >=20
> > > static void ocelot_core_try_add_regmap(struct device *dev,
> > >                                        const struct resource *res)
> > > {
> > >         if (!dev_get_regmap(dev, res->name)) {
> > >                 ocelot_spi_init_regmap(dev, res);
> > >         }
> > > }
> > >=20
> > > static void ocelot_core_try_add_regmaps(struct device *dev,
> > >                                         const struct mfd_cell *cell)
> > > {
> > >         int i;
> > >=20
> > >         for (i =3D 0; i < cell->num_resources; i++) {
> > >                 ocelot_core_try_add_regmap(dev, &cell->resources[i]);
> > >         }
> > > }
> > >=20
> > > int ocelot_core_init(struct device *dev)
> > > {
> > >         int i, ndevs;
> > >=20
> > >         ndevs =3D ARRAY_SIZE(vsc7512_devs);
> > >=20
> > >         for (i =3D 0; i < ndevs; i++)
> > >                 ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> >=20
> > Dumb question, why just "try"?
>=20
> Because of this conditional:
> > >         if (!dev_get_regmap(dev, res->name)) {
> Don't add it if it is already there.

Hmm. So that's because you add regmaps iterating by the resource table
of each device. What if you keep a single resource table for regmap
creation purposes, and the device resource tables as separate?

> This might get interesting... The soc uses the HSIO regmap by way of
> syscon. Among other things, drivers/phy/mscc/phy-ocelot-serdes.c. If
> dev->parent has all the regmaps, what role does syscon play?
>=20
> But that's a problem for another day...

Interesting question. I think part of the reason why syscon exists is to
not have OF nodes with overlapping address regions. In that sense, its
need does not go away here - I expect the layout of OF nodes beneath the
ocelot SPI device to be the same as their AHB variants. But in terms of
driver implementation, I don't know. Even if the OF nodes for your MFD
functions will contain all the regs that their AHB variants do, I'd
personally still be inclined to also hardcode those as resources in the
ocelot mfd parent driver and use those - case in which the OF regs will
more or less exist just as a formality. Maybe because the HSIO syscon is
already compatible with "simple-mfd", devices beneath it should just
probe. I haven't studied how syscon_node_to_regmap() behaves when the
syscon itself is probed as a MFD function. If that "just works", then
the phy-ocelot-serdes.c driver might not need to be modified.=
