Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB32560CF8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 01:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiF2XIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 19:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiF2XIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 19:08:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60065.outbound.protection.outlook.com [40.107.6.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673149FF5;
        Wed, 29 Jun 2022 16:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=No1CYDjyhKEbvc5tsBd5Vqex7/FCWURIgE59bp1O87Wof9fuaWXNGG9vni9DZcnpgw38Jhg1qsAKqiyFJ3baEgXfU/eGjKm2BXasWpDwqoVPsh87pmlY6zsp4NRkd3E+Ow//G6cGHW1D7/GTrotkE6bobaBSPIXKNtpuggCNlt3t3W2JuXcYTWm8tsrbRNekc6BVX3Czklca2LR+OCE5Cs9xjz9yZ8p4RATxhmggdmsG71kvRpABnpmVgH1Knz6fkZ6p7rFt0BbIE376oiv7/8WSM6fVPKFgRWt64joKV6hp0pwd/caXWd/iqjHPGybAdzUwhtD8GFqGTs/RiL3f4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2BjK5b0tqjz/ZP2nCypkEKnLz5a/JP6UepICIcomQA=;
 b=MHd8tI7m8wZ1vRs+fFchKkVT+4lnac83vFs8sANyMsuFUekzyTFnH6EjF5hf8dcJdUeDbR9kw+/eSVADR1QXn5asnqSGoYTmCrEEGPUsrvpkO+SP03HrCFk1tE8+l4xvmI61/+9nPsSIeXAr2Q6sw7dHQu0Ww2Qt83dPlRh33q6JUjDIjtyMdJQl9juZnLF2+I2pRwoVtYSNKrTwD0QV/7K8Ww1OYUikZUTKJs4tyPPUSnAyjhUYlVeW7qU6BTAOCeYH0ljluTRFYDQ9Gr72GbLN7IR1g4bGsg6MKeXkdnWcqkopI14CMQtEyJphrhibacS4cHKLFwbATjxt2EF82Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2BjK5b0tqjz/ZP2nCypkEKnLz5a/JP6UepICIcomQA=;
 b=Q+kzinNyyyELiERHepkVyrFWo7jPhOFW86EDmEGpbXcu4DxkTvzYo9WhTd8kAVcsHGy2FdSOkDCWO85Tp2ym9p3W8dEYi+HcXv1gOHXaFmg/cHXg/u6Zv5PnkOhBX+VqY3u//0n3u9cBxyk+ao+b4YfWYw8nGYHLP+cenSyEKiI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6895.eurprd04.prod.outlook.com (2603:10a6:803:13b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 23:08:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 23:08:06 +0000
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
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgIAAArIAgAACKICAAA6uAIABb72AgAAuYYCAACmigA==
Date:   Wed, 29 Jun 2022 23:08:05 +0000
Message-ID: <20220629230805.klgcklovkkunn5cm@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf> <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler> <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler>
In-Reply-To: <20220629203905.GA932353@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37f21159-77c6-4f9c-2bad-08da5a2439bb
x-ms-traffictypediagnostic: VI1PR04MB6895:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 38EpNNmua9e6YwtrginrerjVcr0G/TRh7VJKqyhWxDuXjM38ns4RqWm8BSDzKor6J28TtpNtEMDW2Pr7xFPfSTnIyPrrXLf3uXmDlb0/PXowxpfuc5w+dHnARfvITWeiTQIF4mBTFg5mrJQrjVpikPpP8erps7IRCvH5XwbZgPlQ7d0a1dlJUyhs/Wl5+8dOsZ9ZS8BzvVxW2/+WWXKY+aeTIyXMYKjze51O0VntcJUNjH6L7+odctrBtSzPZLcDCGpk9JpBKs2bs5qYjQs/fIL5IwjHjqdQuqHsPXu6e3jjfiJh8FnHSdBhVlflniWIpdjLVDa2sliACGtMoKX9C7ElIQwBrVSGtMDT9fslMV2Y4twmTstzLrTXM0KFAj/AY6uZJT+Nqr5Y6yuNpcq3Vk2y5Yjb1gxL6+wJjfR0CUne46ckX2/bsI/ReqlsUX7ihdcKhBf5lnNd+CDKFUs5WQY6DRDz6CONH/+mvK5oomPKuf199xIYbT6/bK6/LbfeXICKVvBvP3oIDGVaPOqKmW8Tf8NE2Bodz8uOzcRvoWKL1Bvxbe3ZVt/sHEkGX7m33AsHcedBrooLIfyjOsZecUWdmfQBdLE+5csZLyJiTUO2poYREG7A/Jo7ICswgvFPe4tCGje1JWd7GsH6HzzWHdIlfuAEPWU+LzLt8JpFn0hrLPBjKSSy6oxc6K2ptr5cK9Ut32P+zActWsFLxJODBhgPuhy3rTK4VrKpAkwICSMX5vteBtRMruUMFVeVWwMlrJMmmmhyFaaOLkuQ6N248RqVrWMLpt5NobC7ssdLgm8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(8936002)(38100700002)(41300700001)(7416002)(66946007)(44832011)(4326008)(66446008)(64756008)(5660300002)(186003)(86362001)(122000001)(6512007)(76116006)(9686003)(66556008)(38070700005)(1076003)(33716001)(6506007)(8676002)(26005)(54906003)(71200400001)(6486002)(478600001)(66476007)(83380400001)(316002)(91956017)(6916009)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XUoYbmgbLidDJk4H5AlhVkgHSDPNfEHgbpJqu0loc4JoLMOJyxnKnhVNsids?=
 =?us-ascii?Q?xKeH3Xyea+Rw/L+3IQM3KoLbPpQCiIT7naKgSV9I3UBHUstTiui6obuctKVU?=
 =?us-ascii?Q?2sNtgrYnQPMZ1qXVqB57BMoi1uVF67bj6a+iBr/VJL+zxE79HqccgvFxdzM7?=
 =?us-ascii?Q?/HRV3AP/fQVaZxYWxpFY1e88vktvK1zbL4rGzk4zpuMUcpKfHTW9ssftYsyB?=
 =?us-ascii?Q?jNO0gx2MYWaOathDA99yNkg6U33bx2mAf7GXC6in7icTJweYys/pkjJZkkYs?=
 =?us-ascii?Q?/f1P491YcJV21IAxYb4IM31q1k6KAkc4rB6+ntxangUCxPoDfCblNIuK1Ymc?=
 =?us-ascii?Q?E1DYS/OV4E/z9M72FRGCXZlDZvKyLH2tm1XbUf89zE1OpH33p9BP2/dzyD5v?=
 =?us-ascii?Q?wueKZMWLKQb85hfxsSG2o0j18y5FBkP2Zqxt+sBzeq1n2dpp+vHHZxtBTLwk?=
 =?us-ascii?Q?vTr3OOk3HRIJ6221P68egNwbTTGuQEa8dWlZAcwKcyK8ZME0k5lojugNMYaK?=
 =?us-ascii?Q?z+AYYNZtX2O9h8KVOsvxvl9hMUrZEv6thMcgz8LoWRoL+K7TbXYNrdz5wp1S?=
 =?us-ascii?Q?Pf8wkzfax30RK7PqUntfvKb4V9J1IYKSxtNUCwc9FtiHeqcHUPbulIHMNPwR?=
 =?us-ascii?Q?BW14u2H2NmYbOUbXQEdoITwML7Lf+8EvNH2l+I3svR2xROa0VfNUZwG3L0KA?=
 =?us-ascii?Q?D8Tpz4AT40XhfnGwNVx/RkYN0vgZx5UtbFZ8DZHa4j3iTzKAFnLKn/CzeSY4?=
 =?us-ascii?Q?5UgRp12AovTonyJGG3mxWhoRLxJWKjyES/gWUt7yNVjW00DanUaAblHJxSFp?=
 =?us-ascii?Q?vH73qfkBRLTEQqH1/pRcCbikL46K7ehR0Oo6Ogt5TnYDaPuClPuPVhzeOOmm?=
 =?us-ascii?Q?ZpguhJxMuOw3MmbBQtuwHTTUU/eSB+Ur/W0tppES/9eNhJmY2QWRzWPGOWWa?=
 =?us-ascii?Q?eX8vBF2kTO6shBKlT4XRU3Z6pS/bJ+RDtf8NcreK10EV8djs5R43fv51fw7p?=
 =?us-ascii?Q?B+WKtPOCFhtpm2R9ZWAHgTtO49SSLfmN7hELQtxQaUU0/8vFl6uMsh7mjc5s?=
 =?us-ascii?Q?CkohBHrn2RP18uX4Q3DV7qD5hHceHIkOYdqIyYGKymLvTTyC/ZAvzniySN+1?=
 =?us-ascii?Q?Qb9njfXYtT3A8KYEgKzwRh+/O/psldWrweJBNzSUN9zXCYhnJITACwZmEpa/?=
 =?us-ascii?Q?e7D6ODnbyVOBbJOmewNe23PUSMXKOoE0yhF8KOiaNo2Q1x/YLHz3JNunYh5U?=
 =?us-ascii?Q?Hv/kHTvI9MtriMlVroX1Zjvwk2/iPhHWoZwJogSK/qSaBveWnvQ6ymisHS7z?=
 =?us-ascii?Q?SfhGxhp8pbIyQRiBaGEJOJE0Xkd2j2NTYKtkD9fLBaQqIPsZMFVyYs58Nm5l?=
 =?us-ascii?Q?uqzDNJpSqMpc+6sfuv6LF2zODnmELy3kEJ8z+EAP3lDx1jyMukggy7pd+s2v?=
 =?us-ascii?Q?XyLvTnnDUKjTjT/JvoH/jIE1I6ma/y+/7nMlB4rlsy1J7KXq5BV6DdvQ3/ym?=
 =?us-ascii?Q?JjcFaMK2+Av+u42f+XO6lhsxlsxGqVmPLPk5ZvYfWhwqWdTy5UYp83YsBvkU?=
 =?us-ascii?Q?co5ZDJLrR7dqjffJ9S2ei/SYkNX0mmRncOPxtyGK8sdxwz7YghixjSIsqLOx?=
 =?us-ascii?Q?Qg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFF2968197635844963E2E069678A88A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f21159-77c6-4f9c-2bad-08da5a2439bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 23:08:06.0080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ej/RpasrFLbgYdrLA6/uH6h2vN6bmNcfT7OuEgKFBEOrchvo+GbrgBSgkPimYJF3ATqrIgFR/OSH32PgVGg9Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 01:39:05PM -0700, Colin Foster wrote:
> I liked the idea of the MFD being "code complete" so if future regmaps
> were needed for the felix dsa driver came about, it wouldn't require
> changes to the "parent." But I think that was a bad goal - especially
> since MFD requires all the resources anyway.
>=20
> Also at the time, I was trying a hybrid "create it if it doesn't exist,
> return it if was already created" approach. I backed that out after an
> RFC.
>=20
> Focusing only on the non-felix drivers: it seems trivial for the parent
> to create _all_ the possible child regmaps, register them to the parent
> via by way of regmap_attach_dev().
>=20
> At that point, changing things like drivers/pinctrl/pinctrl-ocelot.c to
> initalize like (untested, and apologies for indentation):
>=20
> regs =3D devm_platform_get_and_ioremap_resource(pdev, 0, &res);
> if (IS_ERR(regs)) {
>     map =3D dev_get_regmap(dev->parent, name);
> } else {
>     map =3D devm_regmap_init_mmio(dev, regs, config);
> }

Again, those dev_err(dev, "invalid resource\n"); prints you were
complaining about earlier are self-inflicted IMO, and caused exactly by
this pattern. I get why you prefer to call larger building blocks if
possible, but in this case, devm_platform_get_and_ioremap_resource()
calls exactly 2 sub-functions: platform_get_resource() and
devm_ioremap_resource(). The IS_ERR() that you check for is caused by
devm_ioremap_resource() being passed a NULL pointer, and same goes for
the print. Just call them individually, and put your dev_get_regmap()
hook in case platform_get_resource() returns NULL, rather than passing
NULL to devm_ioremap_resource() and waiting for that to fail.

> In that case, "name" would either be hard-coded to match what is in
> drivers/mfd/ocelot-core.c. The other option is to fall back to
> platform_get_resource(pdev, IORESOURCE_REG, 0), and pass in
> resource->name. I'll be able to deal with that when I try it. (hopefully
> this evening)

I'm not exactly clear on what you'd do with the REG resource once you
get it. Assuming you'd get access to the "reg =3D <0x71070034 0x6c>;"
from the device tree, what next, who's going to set up the SPI regmap
for you?

> This seems to be a solid design that I missed! As you mention, it'll
> require changes to felix dsa... but not as much as I had feared. And I
> think it solves all my fears about modules to boot. This seems too good
> to be true - but maybe I was too deep and needed to take this step back.=
