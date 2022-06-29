Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4075607C8
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiF2RxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiF2RxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:53:11 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70052.outbound.protection.outlook.com [40.107.7.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9560647A;
        Wed, 29 Jun 2022 10:53:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEEVJWjciPMH5c9bR/BYBR4YOPyHc6GD/z+FjqAUo8q5ZkrVvhdGv6oDV4MkR9L5ZbLiPZYcEDMBEuVyEranxPOxAHv18pt4O7KCV8CQWUFs4UTaOxEOHGrZgmYCO30fgfwyuOVvtMeIbB1gs2HO3jxoRHa97eZQjcFL4JBcDvt3ZsqUo0DLoHB0zMfTNaOkbEBsVos63Ze1ZK7LZPC9sBlZ8720FNaLNVG8uTGSbzuWAyqlsOoYxKkysL9f3pOgbfrVw4vgGwaxi72+jNS4TqN4CHOdy8ex7W4oU1Sqwot6R9KG6D92I8kNXK0/P8HXdFxITSEVteyX/gMagp60PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCoGnqOHzo/0Z9RgXIVWZ6R4tqzVymiExfh1KnYrfko=;
 b=IEM6vhFnFtuTTiJ2RZ8DDD2ePUKVDghqNGMWZqM5PH/p250i2XY6xKL3wPAcIppqnbttS7FR4M9tv5ibOtGXHMKyg5L9YMhlQ1SZzODU8jmTmfS6uILQTZUv8m+aPxCaqAVzjVZk2uYJvSIHLvwyz0hvblMAj/BTm8pKiXt7WgDdaaj3UZvJHB2qJ5S7VYQ048fqbamQ0Pv8KCI59OEeNeJok3SZPkalmP08ipRKYv6ovOxYshQTrZrDOind53cCEYCEZ8J+v+o6pt8QhA8Z73Ef57mOrpaKvd+Goc2SEjrCAaUZoNV3PUMtKmE8cgdwhAFo3DKI0jb5trY9ro94Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCoGnqOHzo/0Z9RgXIVWZ6R4tqzVymiExfh1KnYrfko=;
 b=EMdCQNTTEjj+O2L6f770uQjwcrdmgXOQtdFppp1dAaWzhMnIgJAf+zSd4ndKHJvVrxAdCtTp023cznJd9gw5M3lKciMm1eh5j6upViEtyOiCc3EAcN/U3rEaP2EcpcGoxt0brIbeCBIVzNl56uQ3DLIhrMU6tWls/yv87/IclRo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4536.eurprd04.prod.outlook.com (2603:10a6:20b:16::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 17:53:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 17:53:06 +0000
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
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgIAAArIAgAACKICAAA6uAIABb72A
Date:   Wed, 29 Jun 2022 17:53:06 +0000
Message-ID: <20220629175305.4pugpbmf5ezeemx3@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf> <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler>
In-Reply-To: <20220628195654.GE855398@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ff28527-5615-4105-0082-08da59f838b8
x-ms-traffictypediagnostic: AM6PR04MB4536:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ctbobDDnJ4hKRD99oRKT6haLE6GSycGoJWteu/ZxQcVyx7vSsTChg44ET0WGGoSyawdRJ3nDV85ET8z9vqNbV31p6yhu82pMnIraTHYT9L5gpQXwMZlJXggK8pRHNh8YcjRIhe3uri/TuCjtcR2n+GOappxPzml3txpG69ucQxWtmwVgydCeG2rHk39QPdgZked1PI07j9+hXMO0+LljMYRJV3+PqobdV3IKme7vhazM1hZjdmOilx6wSsY0X2SXKStLx61wngF/dyd0qrBpiYCIC7NyaJncv/4zPTSruFl6UTGt4MSInDWVZSxFjExLUtlJmbHg8jhXS/giJTvwYvcA2TeX4nHPgUejvXF7KeCGkcHz2BLmo7qPIKjVBijx/JBaXd9+hONkaxdgEfGEcQ4RukGhDhobeIO0fTiUVszsVeLFTTKkgfj8a/djQXdpT5pWE97MgEO438zwIMbfArCXOuT3QLN8Zq+I0nUjSUlBfFJvL53dMiHyBIici+dsC2gIaWdGtsdXEW98F2ntjhlYRzji1Et5uxTP1++o5jYDUJ3dmIarfWEiKQZgMoQwdIZnrRvWftoM/M49wO3oPaMAaq0YBLIPRTCwPUW2e8QDQfhzSrbaat769sZny1XIamRCDGUK0fktDmGJgM13r1DocTBCxTaQc7AnnrrNHDEeXwceuBcMxXx9KZWZOMHBd4NPBBGwhtr/8SJx5B8Q/jwlEiwJlNJ4FMb3HTTZIT8/i/VG17ikUkuOAAZ8dH7WCz3o98hVLh24gNMi+DRMboSogQFnmHD3OfEIr3YxkU8e3FBZ+1UlCxOdgbWiZ0nhb38wsgtJh5i47qjnPspOl65OENn01qkDstfhzalpeh1fmnxaWUfdzZWBImMNn+b4wEjCIdVYiB49x/EYTfiOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(136003)(376002)(346002)(39860400002)(366004)(478600001)(54906003)(86362001)(122000001)(44832011)(316002)(6916009)(83380400001)(38070700005)(38100700002)(91956017)(41300700001)(1076003)(186003)(5660300002)(7416002)(8936002)(4326008)(6486002)(966005)(71200400001)(64756008)(2906002)(9686003)(66556008)(6506007)(33716001)(8676002)(26005)(53546011)(66446008)(6512007)(66476007)(76116006)(66946007)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BsesfSw6VkMIe4E3xHMHNU96T7MzVDOPUsNOa7qVRPosV9bqBZhfEH0JszG4?=
 =?us-ascii?Q?xL5yas/lBsLiQsCXqRGD/84JVZwdyi0iwv1wmE2wjb+oLn1v+ALNcWRgezbk?=
 =?us-ascii?Q?q3LFzbuLe8gSMQeioOQTipRFJni088j+AfO0m3DKWVEf1m+QPGBl4UN2lPEt?=
 =?us-ascii?Q?Rjo7qnsOwiSXeffeqFdTAbJEN6YoOGM6QSFXYBvIHmwZLqdv1Od14DniZXdq?=
 =?us-ascii?Q?svT0TcQsS4+88FTW5uZW23V8mKiF4XZ5GlO4Drn8sNsuh23h+4Y1JN42nc6x?=
 =?us-ascii?Q?UT++M65LMoWLHSg68tt5nvfG+SjQRQeR6vLGuwg4gdXwI8jcd770Iqrv2brl?=
 =?us-ascii?Q?9So9IBI18FwLy+Cy2GUxPqX6L07pxA6fSb3zdlvW2sugAHhomZaRTbwv53OC?=
 =?us-ascii?Q?OHt6L7w3CCVCdeKS0ZTJQ4YRz8InZ94bhWM8R+UjhnER726SQccR2X+nAOsW?=
 =?us-ascii?Q?RLZLAR8AmKKIuh603ZvlgddOtUPTLeSGQ9xrLKiL4/cKDYYYG1O2z92ErkrX?=
 =?us-ascii?Q?Dgl29bXu1wUh/c2SgV9YT9VNJAByEH+KHAsf4n1H7wCdjQNl8MGUSkGA9cey?=
 =?us-ascii?Q?wcTmvsfqg0Kbfqmhz6yrwZWXe8Wp34pg2tCFwBLKtI+bdVnFQ6FNsi5VW2lQ?=
 =?us-ascii?Q?BVTWyyBazUtjPCaryZqeYEmkBmCRNDDQRPGaG35mnvH550Cc8V3iFRcfcJXA?=
 =?us-ascii?Q?9vDsAF4BCFA+gkil5RtaoQ9ZMpMZyqqE3mEMZuXgHW+K2L+q8Q2DDvWioI9s?=
 =?us-ascii?Q?fwhSAm3D1wYJljBXkLnfuclhs26pK13uMZTt2Pxhi6B9GYwvid3hHKqnS8yR?=
 =?us-ascii?Q?1ZM3SqbXF6VkYUorqMrZ3I9beWw+oI5AUqs3VBs4TkAmQVBGOD5anNpNQQih?=
 =?us-ascii?Q?OK9rom2Zx5BMIHaOhqrbGtnBvF3hl2YZyMHWP42uBR2uL2DGYmnGWBCKkidA?=
 =?us-ascii?Q?BSXFjAb1o1NYqZhHP/iX3RJ1Mm94CxtDaLo4JaoLnsecJiPLnlsla1F0wxka?=
 =?us-ascii?Q?G0q4fs3sEtBKTzTyRUqcqPNzQ9ebw3OyRGn+QtG85RH83WEd2SYw7MlwX/8A?=
 =?us-ascii?Q?H4tyfe//UZcFdII/jbVVl/5m6WqeTpVPM5F48V/rjWjiYEGDobuy2U6m3FGq?=
 =?us-ascii?Q?4wFRL5BTx4HiJysgIoxrriJownbbQTKfKscjhXr9IbKlo/NpgQC6vP901Gcb?=
 =?us-ascii?Q?HGIwg2OZ3wA5BKN3VSifBgtiXRHCDn4bAcjqaMPS8ccuFxVNaaiq9duFkItD?=
 =?us-ascii?Q?BDsobojpmcFlWCNkMXOVaAeEtG6X5gqIy6Sf6J6TFNWpw/TVCbDKa7wxJzcs?=
 =?us-ascii?Q?bQeyb7xolFKniFVEaINyvhRtCDxwa5x+1Mu7bl2lMs9BKy/NV8mnTJIBcx9k?=
 =?us-ascii?Q?VApJARgfwoanARwOyuKu7xFiFyTjnuHZZw2D/3s6s79fLxdjiUwdrVWIEjpV?=
 =?us-ascii?Q?72GkeeA+sggLQH+OJn8ftUs4rxY633uzQhqr9n4JuJTyFEl1mK+lIjBdFrQ6?=
 =?us-ascii?Q?utJ+N3qm51tEV09nfFL2HlOTsEd4UP5wpQPTzEUeYk4HF/CPXMITE4tUOSWr?=
 =?us-ascii?Q?G7w0PtrdB05LqDPlusx3q27RregYJ/x8jUhCXagdDTP04NkH4aDL0NdM6CTw?=
 =?us-ascii?Q?4Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D480E9C594C281429D356121AB162F21@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff28527-5615-4105-0082-08da59f838b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 17:53:06.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y3e2YGMzc2UQGZy213kH+24R0qTIucD0lYvlmx6cxqJxRZe5gc8WNZnUDKwGERTqdaJ107zEQyiAofNejVeJOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4536
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 12:56:54PM -0700, Colin Foster wrote:
> On Tue, Jun 28, 2022 at 09:04:21PM +0200, Andy Shevchenko wrote:
> > On Tue, Jun 28, 2022 at 8:56 PM Vladimir Oltean <vladimir.oltean@nxp.co=
m> wrote:
> > >
> > > On Tue, Jun 28, 2022 at 09:46:59PM +0300, Vladimir Oltean wrote:
> > > > I searched for 5 minutes or so, and I noticed regmap_attach_dev() a=
nd
> > > > dev_get_regmap(), maybe those could be of help?
> > >
> > > ah, I see I haven't really brought anything of value to the table,
> > > dev_get_regmap() was discussed around v1 or so. I'll read the
> > > discussions again in a couple of hours to remember what was wrong wit=
h
> > > it such that you aren't using it anymore.
> >=20
> > It would be nice if you can comment after here to clarify that.
> > Because in another series (not related to this anyhow) somebody
> > insisted to use dev_get_regmap().
>=20
> To add some info: The main issue at that time was "how do I get a spi
> regmap instead of an mmio regmap from the device". V1 was very early,
> and was before I knew about the pinctrl / mdio drivers that were to
> come, so that led to the existing MFD implementation.
>=20
> I came across the IORESOURCE_REG, which seems to be created for exactly
> this purpose. Seemingly I'm pretty unique though, since IORESOURCE_REG
> doesn't get used much compared to IORESOURCE_MEM.
>=20
> Though I'll revisit this again. The switch portion of this driver (no
> longer included in this patch set) is actually quite different from the
> rest of the MFD in how it allocates regmaps, and that might have been
> a major contributor at the time. So maybe I dismissed it at the time,
> but it actually makes sense for the MFD portion now.

I'm sorry, I can't actually understand what went wrong, I'll need some
help from you, Colin.

So during your RFC v1 and then v1 proper (Nov. 19, 2021), you talked
about dev_get_regmap(dev->parent, res->name) yourself and proposed a
relatively simple interface where the mfd child drivers would just
request a regmap by its name:
https://patchwork.kernel.org/project/netdevbpf/patch/20211119224313.2803941=
-4-colin.foster@in-advantage.com/

In fact you implemented just this (Dec. 6, 2021):
https://patchwork.kernel.org/project/netdevbpf/patch/20211203211611.946658-=
1-colin.foster@in-advantage.com/#24637477
it's just that the pattern went something like:

@@ -1368,7 +1369,11 @@ static int ocelot_pinctrl_probe(struct platform_devi=
ce *pdev)
 	regmap_config.max_register =3D OCELOT_GPIO_SD_MAP * info->stride + 15 * 4=
;

-	info->map =3D devm_regmap_init_mmio(dev, base, &regmap_config);
+	if (device_is_mfd(pdev))
+		info->map =3D dev_get_regmap(dev->parent, "GCB");
+	else
+		info->map =3D devm_regmap_init_mmio(dev, base, &regmap_config);

where Lee Jones (rightfully) commented asking why can't you just first
check whether dev->parent has any GCB regmap to give you, and only then
resort to call devm_regmap_init_mmio? A small comment with a small
and pretty actionable change to be made.


As best as I can tell, RFC v5 (Dec. 18, 2021) is the first version after
v1 where you came back with proposed mfd patches:
https://patchwork.kernel.org/project/netdevbpf/patch/20211218214954.109755-=
2-colin.foster@in-advantage.com/

And while dev_get_regmap() was technically still there, its usage
pattern changed radically. It was now just used as a sort of
optimization in ocelot_mfd_regmap_init() to not create twice a regmap
that already existed.
What you introduced in RFC v5 instead was this "interface for MFD
children to get regmaps":
https://patchwork.kernel.org/project/netdevbpf/patch/20211218214954.109755-=
3-colin.foster@in-advantage.com/

to which Lee replied that "This is almost certainly not the right way to
do whatever it is you're trying to do!"

And rightfully so. What happened to dev_get_regmap() as the "interface
for MFD children to get regmaps" I wonder?
dev_get_regmap() just wants a name, not a full blown resource.
When you're a mfd child, you don't have a full resource, you just know
the name of the regmap you want to use. Only the top dog needs to have
access to the resources. And DSA as a MFD child is not top dog.
So of course I expect it to change. Otherwise said, what is currently
done in felix_init_structs() needs to be more or less replicated in its
entirety in drivers/mfd/ocelot-core.c.
All the regmaps of the switch SoC, created at mfd parent probe time, not
on demand, and attached via devres to the mfd parent device, so that
children can get them via dev_get_regmap.

Next thing would be to modify the felix DSA driver so that it only
attempts to create regmaps if it can do so (if it has the resource
structures). If it doesn't have the resource structures, it calls
dev_get_regmap(ocelot->dev->parent, target->name) and tries to get the
regmaps that way. If that fails =3D> so sad, too bad, fail to probe, bye.

The point is that the ocelot-ext driver you're trying to introduce
should have no resources in struct resource *target_io_res, *port_io_res,
*imdio_res, etc. I really don't know why you're so fixated on this
"regmap from resource" thing when the resource shouldn't even be of
concern to the driver when used as a mfd child.

The contract is _not_ "here's the resource, give me the regmap".
The contract is "I want the regmap named XXX". And in order to fulfill
that contract, a mfd child driver should _not_ call a symbol exported by
the ocelot parent driver directly (for the builtin vs module dependency
reasons you've mentioned yourself), but get the regmap from the list of
regmaps managed by devres using devm_regmap_init().

Yes, there would need to exist a split between the target strings and
their start and end offsets, because the ocelot-ext driver would still
call dev_get_regmap() by the name. But that's a fairly minor rework, and
by the way, it turns out that the introduction of felix->info->init_regmap(=
)
was indeed not the right thing to do, so you'll need to change that again.

I am really not sure what went with the plan above. You said a while ago
that you don't like the fact that regmaps exist in the parent
independently of the drivers that use them and continue to do so even
after the children unbind, and that feels "wrong". Yes, because?=
