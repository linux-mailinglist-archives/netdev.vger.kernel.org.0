Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94355561B13
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiF3NMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbiF3NMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:12:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20056.outbound.protection.outlook.com [40.107.2.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B257A29CB1;
        Thu, 30 Jun 2022 06:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gE2M+7VubWUy34/xtoRWpaBLC/bPTAoZ0AfYTdaj1EH5POv2gWvWl3mKQd4L4DykKIA4HRVvz+fgVGyBTLTh2odF54ehCrAIz2c4MJSz5Lpx0Nf/EVd0EoFEzF5bNxMdcDSSaL10aZjIKiYquBYW0AMilb0lU5M78mZ2nBqDC51x87Mx6IGT9Cqov3Sxs5UPXTgwAyspEPx4xUbyQkh3gc5oap7olH37WnLESVMjKf9eS8slBkQamoivRxXmsXbnGiXQGFlqT73IoepvxnxBSCXbv6/o1fKPLpsC/twgkOLLw5spxc2McgQUtNR64JLhuixMwlwLEZ2589sV1FHVAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1jEadsenryQHigyrAq8w9MtfMXL+313jw4oxDI2Jn8=;
 b=Ve2+9415lGWxjmroJPUNmN/vrc3Q8sljsAyE2yGdviXbyq/Ao4WE3mFR944EkmHSOcm7S9gUQTLmPeIiY6mqLw/2jLYgvo2VCSlMqKBnYUJ4glCgmViiQwwctsBVcEMAGtPhT9DzEYqOn24uLQ9Bv6vVCcGMAZL49kAUKqSGhEls5LvC4DodMJvN05LdibYqUvJUSiCzIf2OX8U3w0yScXvqITG9nDNVkpXPAq40Rv8VPwUYcbsaCkixg4GXIkTDx2NS/K4vTsiqSvufGaWNkvkFClV9UT/3jjXs3FhoapPEZhirFFaAXMBssGg0e614DTmIbHi2ZwBcqiLZCBWUgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1jEadsenryQHigyrAq8w9MtfMXL+313jw4oxDI2Jn8=;
 b=YEPIYf7uqXiP07vJjslCI/fONJWkg4hOp/e37mMumgRYZPlcA3oqy7UWXWpSQChcrnXPcoYeN4CjzV2Wr7gAE9/6pe5YT11vWgyB6ogBfGNgGFhTE/DK/8GgQ3qwelAhm5bizm77ebdylyfxM8XQBvhZrbQQm1rMd2PCrwbjMno=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4500.eurprd04.prod.outlook.com (2603:10a6:208:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 13:11:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 13:11:56 +0000
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
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgIAAArIAgAACKICAAA6uAIABb72AgAAuYYCAACmigIAADP6AgADexYA=
Date:   Thu, 30 Jun 2022 13:11:56 +0000
Message-ID: <20220630131155.hs7jzehiyw7tpf5f@skbuf>
References: <20220628160809.marto7t6k24lneau@skbuf>
 <20220628172518.GA855398@euler> <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler> <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler> <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler>
In-Reply-To: <20220629235435.GA992734@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04f4cdaf-dbdc-41aa-541a-08da5a9a1bc1
x-ms-traffictypediagnostic: AM0PR04MB4500:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bwe5bMNoy20Zg6veV8ivLgUhwfPr1WnJjgtZg1yAJHDaf98k7ej1RFuiGtXSFXNqlOiQEB0J3ZSaEtlz9Ft7kFeP9GUqAt91l3BEaZNIXnmiP1RqbsDjYv7g/+C9nx7Sqo169giEmTXFFhZBLX1oaOPIPLlDlnBG2zGj+4rKrh0q2MJZpZS7/cZVh4kH/FSssHvq3zrT/DdTrCCNIkjIxE/9HAIJhE1Ro31OZZyvftCo3MlFoeXRd5lU18iDvFSf3IlPOLamgOa+ML2nGBmDb68aPnUnFZRA6eUpgSZsgoyJKNaYMHPn/i6dQw61VVsbI8x1jY6vhw1ux/E8LHTGJExsoENs0lSK8v/Gk9hPBXd2VipbHI63m1CyWdcAXoc7yCqBU0OOGLkRxx76alw7T7+bBL/CodYSjYnOvIhU719q12v47K1aeR/C8RwwqqIoX3/5Wrhp5zDxO5LI6Q51rfxsDj/JjuR6rURp1LKAyOA/X3D1F6WtYj462KDRKsTMvKxitMbUIYbi1tI6fu4Qhp5e7rpondaSey/pw597caxttFIy773lZSmNC9eNWl2pYnH6tpx0l0RxqOiWJycpChQQeOX4D/nGt7hrK1kE3vY6Jkd3T9cmSJHPxVwVw0NMIlhujjLKWl6KcnKfgNGQeR+dGp9HnbZtQ4xdU8ek+gd4ALYOQzU7Y/d5Rs8VucFcGVtbSxTaIhYnTBI8qeBQeOmKVRKkQrJANjCBlKGr1DNwDIv2Nrui8ke4jtNWuscu57HUtwyHxfLlR/bpeEP1OUvQxdv3dUSSscVfJcE5g1NR1XpGXRhhB3PkpTX7uwN6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(376002)(346002)(366004)(136003)(39860400002)(26005)(478600001)(5660300002)(7416002)(9686003)(8936002)(6512007)(186003)(6506007)(41300700001)(86362001)(6486002)(44832011)(2906002)(1076003)(122000001)(316002)(83380400001)(76116006)(66556008)(38100700002)(4326008)(66946007)(8676002)(64756008)(66476007)(54906003)(38070700005)(6916009)(71200400001)(66446008)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OR0JU9ix2LwFFmIlB4RPbbo41Wepd6QUHjYIJ2Z6As7+XtP0BYZUj3fc9GgE?=
 =?us-ascii?Q?mZAu5SKVpJiibXli4G1CrS5GiW638IBIUGKvaevtwFqvhZIXBCHfecapEIAc?=
 =?us-ascii?Q?l9cXobBDiKYN6eNUznHtIYMjY3wX0SHyO9/L9odAu+ZQQraoP8yOa1nF2oaC?=
 =?us-ascii?Q?xXjrMjHLy/omZn/JITN6PxZWYI8HSJw5ECz+DZS9sPyfm2CpN6nP16lNbmrm?=
 =?us-ascii?Q?SvOHDmUyFEyo/PwHw7kHleZyuqw5bwRis5wwUtw6YQ1EysBhVeC55SE6f8yr?=
 =?us-ascii?Q?Qde6+ULW7GCRuvSA/lpfmspHgrlxm2CnzPpRIKKAg1UyUQaf6OMh4MlSDPE/?=
 =?us-ascii?Q?lXWCpSeoI/G5Z1HUxbRKX5tHGLhcvyNvU7Bl6z6CaJ9xdLY0WM/kd0oSpcNG?=
 =?us-ascii?Q?WaWyjlO52oxzWPeIVlxMmLlk+hxlsFZSb8JA+BsF7szkSM7/LoUwtMR7fXve?=
 =?us-ascii?Q?kYLERKmt5SCE2/ed9sJ+m+jpjsMmRwPjTB6g9RojwX25ShCSwaYTbUyHFqtB?=
 =?us-ascii?Q?ngDGezU5GnOaCj4i6CwB6a4TSaAVqd6iRv6xoBgB+ZPPSpzbizuuMtxT4zt+?=
 =?us-ascii?Q?HOcBPlOOnS5/yWJr6aosZqR8IKSqHAMrztr9IZO5MHlJgIrhjP+QDIXfrvh1?=
 =?us-ascii?Q?yJ9QOdn/ulhI176xfioTI7ev3H5CjEpJeB5SKPWkosZAnYE373Cgx+Ulq+zi?=
 =?us-ascii?Q?XCDtC9ujqHwErNFo0gr3MnFdR/la3gs0OlWeYy5/Md05fbKliEPmCuhnCm29?=
 =?us-ascii?Q?ljICX4KVJ3ne+dq7DPtrpjCoea85Qjkk3iVgMh92GdglzAzwRumatyknDYn6?=
 =?us-ascii?Q?9Eg730dtAo3igB8pZkUNoVcrJB39jE/qfCPucjcmuNSjSXWfh+r+7wBTzptK?=
 =?us-ascii?Q?8do6nIARUOv8O7elA9lPjDSBk4o3v/7NbcAQI+knjNaC813bVtjr3jp3Isgb?=
 =?us-ascii?Q?S/DuOFEMuEJBKsF9dvkccBzUMiuwpILHfgm7Z+7LEGpwUdQceblfd31xbaPr?=
 =?us-ascii?Q?lO7Rqyc2QJNyXufFU6BtJomULLLUsozYzYFc+yhAdi5ccJbrDDT+O6wKwWPx?=
 =?us-ascii?Q?18JiCAdmYin7g24eo75hgWEVONGw5lI7n6CQKKhPDBtWGRXcuAdmYehhj4HP?=
 =?us-ascii?Q?8mBHaGwC5qM7dYci3kw5hfm+B4dQRJ0kaKzBGo6rZcOesKpbsF+UqtBP+ckE?=
 =?us-ascii?Q?2R5q/NgybP7rhD5pdKXNwHZqM2Ud/NhdqXw+lZYYTXmArOIj7fGJLlJNoWYT?=
 =?us-ascii?Q?HZqgqaV6wIvrccBMkIaCKhIWpysJ/jeM98QgG9niwY1qTTiUtp2QyOSu3hUF?=
 =?us-ascii?Q?HOcSB6YItzBWRiJEux6RFBmnozN8Hcq0Gv++sj/3ZHEsh6lVwEk090AfF0xx?=
 =?us-ascii?Q?T3IW87T4YITERyOqViaupBhkVDFBcahgfb+y1yGndG2eNW3lTqGN6Z8waB4U?=
 =?us-ascii?Q?O37MNFEJAMybptph8Fhf4w0wGlrojnag4vdCAFAqb8Qny4T/SXuTInpWXgNK?=
 =?us-ascii?Q?d9KWZYjWF23CODH7OSx8a14RHWjiAEexnWDyPT0EjQslBNurEW0EHZUHztn4?=
 =?us-ascii?Q?dyli/ktaXrxknn0wgOmJVE4XB3ZHJlyCdcDhkEz2D/b8Yiau36xEOa0J9DRS?=
 =?us-ascii?Q?DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B429FD48E42A174BB0BD3701B8CE8283@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f4cdaf-dbdc-41aa-541a-08da5a9a1bc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 13:11:56.3152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CpwWBYafQ6Zewu4hztousFcz5qEqQkdkwTm8XnQeWpIMLTa3aRJjY7BvlE/dEX9QftsYfdbwHsAXZm8V1UHknQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4500
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 04:54:35PM -0700, Colin Foster wrote:
> > > In that case, "name" would either be hard-coded to match what is in
> > > drivers/mfd/ocelot-core.c. The other option is to fall back to
> > > platform_get_resource(pdev, IORESOURCE_REG, 0), and pass in
> > > resource->name. I'll be able to deal with that when I try it. (hopefu=
lly
> > > this evening)
> >=20
> > I'm not exactly clear on what you'd do with the REG resource once you
> > get it. Assuming you'd get access to the "reg =3D <0x71070034 0x6c>;"
> > from the device tree, what next, who's going to set up the SPI regmap
> > for you?
>=20
> The REG resource would only get the resource name, while the MFD core
> driver would set up the regmaps.
>=20
> e.g. drivers/mfd/ocelot-core.c has (annotated):
> static const struct resource vsc7512_sgpio_resources[] =3D {
>     DEFINE_RES_REG_NAMED(start, size, "gcb_gpio") };
>=20
> Now, the drivers/pinctrl/pinctrl-ocelot.c expects resource 0 to be the
> gpio resource, and gets the resource by index.
>=20
> So for this there seem to be two options:
> Option 1:
> drivers/pinctrl/pinctrl-ocelot.c:
> res =3D platform_get_resource(pdev, IORESOURCE_REG, 0);
> map =3D dev_get_regmap(dev->parent, res->name);
>=20
>=20
> OR Option 2:
> include/linux/mfd/ocelot.h has something like:
> #define GCB_GPIO_REGMAP_NAME "gcb_gpio"
>=20
> and drivers/pinctrl/pinctrl-ocelot.c skips get_resource and jumps to:
> map =3D dev_get_regmap(dev->parent, GCB_GPIO_REGMAP_NAME);
>=20
> (With error checking, macro reuse, etc.)
>=20
>=20
> I like option 1, since it then makes ocelot-pinctrl.c have no reliance
> on include/linux/mfd/ocelot.h. But in both cases, all the regmaps are
> set up in advance during the start of ocelot_core_init, just before
> devm_mfd_add_devices is called.
>=20
>=20
> I should be able to test this all tonight.

I see what you mean now with the named resources from drivers/mfd/ocelot-co=
re.c.
I don't particularly like the platform_get_resource(0) option, because
it's not as obvious/searchable what resource the pinctrl driver is
asking for.

I suppose a compromise variant might be to combine the 2 options.
Put enum ocelot_target in a header included by both drivers/mfd/ocelot-core=
.c,
then create a _single_ resource table in the MFD driver, indexed by enum
ocelot_target:

static const struct resource vsc7512_resources[TARGET_MAX] =3D {
	[ANA] =3D DEFINE_RES_REG_NAMED(start, end, "ana"),
	...
};

then provide the exact same resource table to all children.

In the pinctrl driver you can then do:
	res =3D platform_get_resource(pdev, IORESOURCE_REG, GPIO);
	map =3D dev_get_regmap(dev->parent, res->name);

and you get both the benefit of not hardcoding the string twice, and the
benefit of having some obvious keyword which can be used to link the mfd
driver to the child driver via grep, for those trying to understand what
goes on.

In addition, if there's a single resource table used for all peripherals,
theoretically you need to modify less code in mfd/ocelot-core.c in case
one driver or another needs access to one more regmap, if that regmap
happened to be needed by some other driver already. Plus fewer tables to
lug around, in general.=
