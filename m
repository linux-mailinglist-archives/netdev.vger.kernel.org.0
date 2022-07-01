Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0635637AF
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiGAQVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiGAQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:21:33 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20082.outbound.protection.outlook.com [40.107.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAAE3C4A6;
        Fri,  1 Jul 2022 09:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enWAgNOk0eJFXsNBIXtmK4VGaw38Umh8KL/C5u9+Y46XAD8BqorHhSC13Iy2zLuE+k/YFCmjyMH6zgrsR5KuU7g4Jc/gCECY3gyuI0rdUTYko8Ui2+81UKy3Sg+ZnHFfin+oEvD/zIvNSzxyDVs4Zraav91NykGC2PjfJstiWSZHDlMn3/vfBFCOY/xkFPqazeQ0CAIGcae8R8KAAsBacURjrWwmIGPrpQWbedGOeFAoGG0VYnxHwX25gZM9Fs6E+EjMYUZtVMpEKMRifHKtR3jJEP6K50fNPUsyMNqvI5pvQi11ix+N2DWnnxLMb74Pg/cpDBrLxDV2G1BJA2Y4xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5xHKbbAIDDplNcU+amElv4mYDQ2iI0mp9+7mrNOB8A=;
 b=QM2JVU9hqrMDXr/c1UzpqTJBi/0AiK1uFWe4XmcumU9q6AZskQVDEUYXu2fa8qBasOborpg2q2GZsqeUY6VT8nwJaykEkM08tbCpVryJ68qG50toFSyvkIDoPC8/4eSIxUcOrv0fvPnZk9cT+0ocMWPTNwsg3XA2OoXNUUv9wlfk0XsMgD7UbvWuXMxMTHmKEPZYCGgJUIMMUqPExAVoLreMV9o8M+wqs10JoAu8qhje1YA2lVOmAAGuGWBICBPUHy5bEMXhq9AjKsRZtIAMuT3HSCHZed0ikGuWRwLrtWDxFI17h8gL47PdjJj5oMyZYFs/ByoLM3GW2P+CrHsPxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5xHKbbAIDDplNcU+amElv4mYDQ2iI0mp9+7mrNOB8A=;
 b=qe4PFQFcKlY2QOasITHGrIxLLmHkYV19fCSGwkLa8g0BFwMzHdlyYnwJjWJCKFL1WnMhfqlMJ4/sZcVvvEJfDKltfjDy7/w0Gpr1Z1cmKty6NgIoB2Wz3HzKdL9Ib03N+i+cDE4vF85xPBGW+14ijsf/b08PPlVIzzo+ZimHp1c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB2825.eurprd04.prod.outlook.com (2603:10a6:3:d4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 16:21:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 16:21:28 +0000
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
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgIAAArIAgAACKICAAA6uAIABb72AgAAuYYCAACmigIAADP6AgADexYCAAHTFgIABUoQA
Date:   Fri, 1 Jul 2022 16:21:28 +0000
Message-ID: <20220701162126.wbembm47snbggxwv@skbuf>
References: <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler> <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler> <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler> <20220630131155.hs7jzehiyw7tpf5f@skbuf>
 <20220630200951.GB2152027@euler>
In-Reply-To: <20220630200951.GB2152027@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a362777-3dd2-4457-2734-08da5b7dc054
x-ms-traffictypediagnostic: HE1PR0402MB2825:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJEgJPVtUroIVrKvl1Db9NlyQZa+gMgiHCiYFlJoNjNWM6XZTCGxyB2i+6r5tc7NnSLrPcNRTHFofGTcdtEXOoD+FgePXhQPjs6ZGCVFtjJZn+Nqb7AyxRmIDUlFXZvFNp2HjQ6I4l22aU1x63yOY+8b9TKsVx+woIjrtlnlxKyK3wbzw5jXXKPXLqpww6o54hy0iFalxFtJAeG625NzfjG3pA8r0KfWt6Z30tYAePsvEU89mCw6eGbE1o8I/7WPZHPytre3HKhjBlnmGA5N35qbFiKWngdwVFQNTXMs8Zg+ButDAMmp0OFVaiTSRdn2u4iY4xvE0lAwG4Fz6bO9UeneAKZO+1CQlAb+5G5OAIMw25MZ4YOmPp9U9dWc+xlXQOk1QServ1PGLIOgkNg/Loyatk9Em3TYAisfKeoPhuRW9uF6F7Cvk/W3GQ4Fa3P8fmOLVEnjAtPL9lMfN6WR4JgUFWjT68gS/FOEBqAVJ3rpvlrRyrARyGf++va7pSo4a1A2ByMeq+3sQA07eieKB6r0Z46mlRZ7dgTmyZ5V0IOh7wdym3OLLUexpPkyd8PwRaoZoXS6LWlOO9L70b9jsYpaa98F7GjzM8YLXqaF7rQnpPi1eQ9aQXL2SRdgKMvlCSomoiK6SV3+roENS9/riz+zEffKgIh199ArJc4lEDP6cpOauxkvfoUFaSFaty2mKSXw3pcBYpZrQTn/NK8vAQpd+4pFUcWdJOVM5Pp9MRRU67XzllJngSA3ZeOSLyiB+SHFX1WxtHre+VOHFPWEL6qY8G4cjXUBrq3KQb+0krKQzs8UIkw+nQnCDYEMuIpG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(396003)(376002)(136003)(39860400002)(4326008)(8676002)(44832011)(5660300002)(2906002)(186003)(64756008)(83380400001)(41300700001)(38070700005)(122000001)(91956017)(66476007)(66946007)(66446008)(54906003)(316002)(6916009)(76116006)(71200400001)(66556008)(6486002)(38100700002)(33716001)(478600001)(7416002)(26005)(6506007)(6512007)(1076003)(9686003)(86362001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zyPXCzLP9eGidDgtuDo8UTXZjOXEMLVMzt4ejBGFUV5wQpCw92qUnr+uxfHC?=
 =?us-ascii?Q?FnYVSo6d+mJstND4y/M2qj35XJE+7Z3+dKlNTN8/zjlUYJ63MjcSo/Folv6T?=
 =?us-ascii?Q?1k/RtJJnIbjUjHsrKSJPqg3T1aMk2tqz3mW1Wa97Djouc4KJmUIJsNRPHbZx?=
 =?us-ascii?Q?v82zfmEZNY8YH+u9Z+hsExyUA7FR0aPdmVFt6nvOHVFFxIkzwCpoIP36wXZv?=
 =?us-ascii?Q?MD2UC1t1uFsPpEy2bUE/DWhKYodqtFAULqy0wM2n9TgZxz2JKeLfkDuUTJA2?=
 =?us-ascii?Q?XwNPYtP4K88UkSrzDMioImKza1pNLQ52VTk9cNu9WXNawwtlZpF318HRC1fi?=
 =?us-ascii?Q?/mzJ4NjTMxwD3hWo7jRK7FF/Xklz/hA5d8BI1lZWa75zOqxRYKhDlzSRw/8W?=
 =?us-ascii?Q?rIadY6WI4p+gxJDZAOhR63w+lJmXNYQi39iPIhenc3Ua8m7JpjLS2L2Ym0f9?=
 =?us-ascii?Q?bO9w5tCVyxZmpks7Wb49rGr4DA3EzzKn9iGpHz3/GHEjWQWVEm+AuggTjKXA?=
 =?us-ascii?Q?rM+0FuJaTrLAz+wN2NM9Ic4k31mkwJLerfXq3+a9l+Nj4SX3OohENzuJTTXO?=
 =?us-ascii?Q?Kb/5E6YGtndb8hNBnb2MkSYNjRZq9BWI+qRXTdh0sH8yyefJrKmgz6NrMTTL?=
 =?us-ascii?Q?PMgSIMH88FYrhzc8J5ug7iaJRDHPHz9kunpV0N6edjAw5JHfpMR2J1TPdWP5?=
 =?us-ascii?Q?WFbqMQeWk2wk20XfHSD3dJRjZG923UzYtCxGihb4AGsmvi4A15+kScS3STUz?=
 =?us-ascii?Q?FU/Him2ShLA5C8QsDDGtJ16wulF42l09mEb7BOGhCu/L0yOMO/CEFONZ9Q5A?=
 =?us-ascii?Q?dJ8+L4h/xQe5yZUS/OQWDVAITqriM+2bY26wVEyWl5QuoYivR7Dn1uBCk9Gv?=
 =?us-ascii?Q?Jd0xOiDb282LIiJvecq5nQOGon7cPeJibpVI0U5Rhjge5O6MKLN3S2HaoL2E?=
 =?us-ascii?Q?5IPaPdUrasXQBSx1+CygM2aXYWlPCkk3zgvH5l1mjAEZ8To2EweiKMLIFZHg?=
 =?us-ascii?Q?fuFeM8XEceAQgh59gZ/w7PRZdQTPh23QoKnIwCLjVQFYN+CT1GWgPF+2do/D?=
 =?us-ascii?Q?eZxv+cVXa8WGnvlWPCWISFatoMV9DiTxntlAgcDr7gJMzk4oB+eGzsLmHK3e?=
 =?us-ascii?Q?yIyPygMMYnv5FxoxpHhxEuwxVwLmbeg7xweSuMJ0tuO2b/OPf4MFkKeHuipm?=
 =?us-ascii?Q?9A6nxzOHL5BNQyIF0VUnFxxcV5+nw3E9hDL2mkU/HiPFhDRUtyHjjSQro/Ai?=
 =?us-ascii?Q?VykEBZKB6SkrjgfCgF2YLx7aX3cdpmSAFL/GUsffhX0RxWQdyEuNDskSqpA5?=
 =?us-ascii?Q?SLNLQ1j8thh+acc0jcPezRaN+r/bOAdcT7VEdu8kwr9yXCZQGrNgIV831hdj?=
 =?us-ascii?Q?b4l3JPpt/2OopvREgseZLxIiAyPo1TshtPES9nufPYBgQ0nPyXi3NRGcwfHq?=
 =?us-ascii?Q?S+3ZlHFOrhxeQboQJCuWDqQq9RQS8tUbpA9rUcORxp453qBl5ymM4iahKUhR?=
 =?us-ascii?Q?EqrXrJhAYO77E2/lI5ZKLdxtg8cZGbx9CtNSkygIGc+chQgSyyiS+2chNhkD?=
 =?us-ascii?Q?r2MIxMYpF+ZOlk1UfP43JJtl8+KhawL/6BxJCIU4V8JXG37C1YgHG/+FfEAo?=
 =?us-ascii?Q?yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <843517A368FDDB4EA629BAD30DC9EB38@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a362777-3dd2-4457-2734-08da5b7dc054
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 16:21:28.1814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7X2MLF3qlohhWCAUTNHAERuLS99ZgduF45RcWwDGPvO14PwWYWPBQQ/jA+PwiZKqAs3HHyUMc1tX4exKgjjx/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 01:09:51PM -0700, Colin Foster wrote:
> Ok... so I haven't yet changed any of the pinctrl / mdio drivers yet,
> but I'm liking this:
>=20
> static inline struct regmap *
> ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int in=
dex,
>                             const struct regmap_config *config)
> {
>         struct device *dev =3D &pdev->dev;
>         struct resource *res;
>         u32 __iomem *regs;
>=20
>         res =3D platform_get_resource(pdev, IORESOURCE_MEM, index);
>         if (res) {
>                 regs =3D devm_ioremap_resource(dev, res);
>                 if (IS_ERR(regs))
>                         return ERR_CAST(regs);
>                 return devm_regmap_init_mmio(dev, regs, config);
>         }
>=20
>         /*
>          * Fall back to using REG and getting the resource from the paren=
t
>          * device, which is possible in an MFD configuration
>          */
>         res =3D platform_get_resource(pdev, IORESOURCE_REG, index);
>         if (!res)
>                 return ERR_PTR(-ENOENT);
>=20
>         return (dev_get_regmap(dev->parent, res->name));

parentheses not needed around dev_get_regmap.

> }
>=20
> So now there's no need for #if (CONFIG_MFD_OCELOT) - it can just remain
> an inline helper function. And so long as ocelot_core_init does this:
>=20
> static void ocelot_core_try_add_regmap(struct device *dev,
>                                        const struct resource *res)
> {
>         if (!dev_get_regmap(dev, res->name)) {
>                 ocelot_spi_init_regmap(dev, res);
>         }
> }
>=20
> static void ocelot_core_try_add_regmaps(struct device *dev,
>                                         const struct mfd_cell *cell)
> {
>         int i;
>=20
>         for (i =3D 0; i < cell->num_resources; i++) {
>                 ocelot_core_try_add_regmap(dev, &cell->resources[i]);
>         }
> }
>=20
> int ocelot_core_init(struct device *dev)
> {
>         int i, ndevs;
>=20
>         ndevs =3D ARRAY_SIZE(vsc7512_devs);
>=20
>         for (i =3D 0; i < ndevs; i++)
>                 ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);

Dumb question, why just "try"?

>=20
>         return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_dev=
s,
>                                     ndevs, NULL, 0, NULL);
> }
> EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
>=20
> we're good! (sorry about spaces / tabs... I have to up my mutt/vim/tmux
> game still)
>=20
>=20
> I like the enum / macro idea for cleanup, but I think that's a different
> problem I can address. The main question I have now is this:
>=20
> The ocelot_regmap_from_resource now has nothing to do with the ocelot
> MFD system. It is generic. (If you listen carefully, you might hear me
> cheering)
>=20
> I can keep this in linux/mfd/ocelot.h, but is this actually something
> that belongs elsewhere? platform? device? mfd-core?

Sounds like something which could be named devm_platform_get_regmap_from_re=
source_or_parent(),
but I'm not 100% clear where it should sit. Platform devices are independen=
t
of regmap, regmap is independent of platform devices, device core of both.

FWIW platform devices are always built-in and have no config option;
regmap is bool and is selected by others.

Logically, the melting pot of regmaps and platform devices is mfd.
However, it seems that include/linux/mfd/core.h only provides API for
mfd parent drivers, not children. So a new header would be needed?

Alternatively, you could just duplicate this logic in the drivers
(by the way, only spelling out the function name takes up half of the
implementation). How many times would it be needed? Felix DSA would roll
its own thing, as mentioned. I'm thinking, let it be open coded for now,
let's agree on the entire solution in terms of operations that are
actually being done, and we can revisit proper placement for this later.

> And yes, I like the idea of changing the driver to
> "ocelot_regmap_from_resource(pdev, GPIO, config);" from
> "ocelot_regmap_from_resource(pdev, 0, config);"

Sorry, I just realized we need to junk this idea with GPIO instead of 0.
Presenting the entire resource table to all peripherals implies that
there is no more than one single peripheral of each kind. This is not
true for the MDIO controllers, where the driver would need to know it
has to request the region corresponding to MIIM1 or MIIM2 according to
some crystal ball.=
