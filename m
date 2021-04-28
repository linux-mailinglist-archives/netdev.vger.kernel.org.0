Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DF236DE26
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 19:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhD1RXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 13:23:09 -0400
Received: from mail-bn7nam10on2111.outbound.protection.outlook.com ([40.107.92.111]:12832
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229931AbhD1RXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 13:23:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvbDtT3RPkSIcFK2ygfqnwpEe44h67P0ucjnwhviTMRnJ9Enr6RbgaLL3SvvhIQdTgVxCW5SY+vEarBEaskYt4gVK7Ti1FCSrM6egMMk3Ws9PVzzH3NSxMeevCSNfocZFEeONpwevh28/XZflDbFSZ+Y8prpYMX8BjM1nxpzT+OCGAuux9U3IEW+BYWf4F4xcHb1FBQmmYfWKY2yKogS2ipXsH8AE6YHpOTcYsXnTzfbqRTA7uY6wu5ui8pSewRFMI7UoBHaZXwbu84P64+hpJls7fucF21N1/WG0etgGTyzA+Ra2jAQBAcv6yBO2dlaLt0vysT+suzXDm39nbleLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkywoftbYYF8S8JHbIt0A3Df0QVtqtCjHh5JyntklhI=;
 b=j5GR4cgUwri/Q19A3vF5kF1QocbUXS/IIO3RGbPHAuOmn0pWHAkyz8wopXTF214sH1VgDKyMGv/ZpFEJy0ihYSeVkbvJzRGnm+MoBkmZwDD8bnehyDgI8a9/EUNUuaDiWL8/i+hgtb+fQh29Mh4b+TrTNBP9c6hIX/air3Oe/yEkIJioTSsKdkYE6QdR5s109HyIi95xc2b3wEBFTXQlc/QnmD4fuUJ5J3hT/bty2LDKiF0zw0+Eqzf4gu5EqVfaYfrqUU6Qyaf3VTbeXsAVCPbJ6rdCgF45iPx3QFFViukJTH85yaCtFtQGVglQCAR3DHLMlJBFceqU5eS2e8Pupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkywoftbYYF8S8JHbIt0A3Df0QVtqtCjHh5JyntklhI=;
 b=W+KykLu7JGlAgysC/KisQGKDRuPUJyTwzRLTWoFlaUWMUliPScMZAYq8fuOECk1cwU4OSIpIro44BeOUeYeJwqvnrOaS4BgnOyQZXOCjuLWCc59IsUkIAptjoVp1aeQaTA6z1vExPRVfiVaSeTshjCeLRqJB6Azu3p47PQUhe8E=
Received: from MWHSPR01MB355.namprd10.prod.outlook.com (2603:10b6:301:6c::37)
 by MWHPR1001MB2190.namprd10.prod.outlook.com (2603:10b6:301:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Wed, 28 Apr
 2021 17:22:20 +0000
Received: from MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928]) by MWHSPR01MB355.namprd10.prod.outlook.com
 ([fe80::c559:f270:c9b5:a928%6]) with mapi id 15.20.3999.038; Wed, 28 Apr 2021
 17:22:20 +0000
From:   Colin Foster <colin.Foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
Thread-Topic: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
Thread-Index: Adc7zfpDg2MBQyIURryZ8Ua+ZuZPqAAQbfIAABCl/vA=
Date:   Wed, 28 Apr 2021 17:22:20 +0000
Message-ID: <MWHSPR01MB3550C50AFA0BA60598CE175A4409@MWHSPR01MB355.namprd10.prod.outlook.com>
References: <DM5PR1001MB2345F62260EE8E45D2306A6EA4409@DM5PR1001MB2345.namprd10.prod.outlook.com>
 <20210428092014.4wc46l67eufb2gfi@skbuf>
In-Reply-To: <20210428092014.4wc46l67eufb2gfi@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=in-advantage.com;
x-originating-ip: [96.93.101.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27235ea5-d57d-4d17-0909-08d90a6a2dfc
x-ms-traffictypediagnostic: MWHPR1001MB2190:
x-microsoft-antispam-prvs: <MWHPR1001MB219088AD782E96FF7B430B7EA4409@MWHPR1001MB2190.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELlpPig3v71Ym58Tvvo4wp3esn2yfGI5ynPjI15ayzwDANNzKR1rl4Tz3uOQMCoZLz80HMYQXtbM8p4fpi76boZJOM7boF5I1xHueR32EIJaZMd4mT7QZdtFFh0z8W4cleGCKrrstGp8Zf1klcRbsJTlvouxmpyX4CGTCZ1Piukq+CqTtmLEWlz67hbcn6MKSNwoZvJuFyPsNKKGXSW6t6f+GcvEiz/v/MU3f6vt/A42GS1aY0eNb4PCIncC7+NlkgVW3gH8xxG+2TJup3u8QuIIRFMYFnmKb3RdOiDvjwxoEkZf5l3GO0EegimZh1nWoBx37UEeYo0aypgoExgT8fqh+bx3vJbgiT3HYovB6JRZuJhgWcfqO8mTSBI+W+sKMA4jAOtnqGRa4KroMDWRqXo2Y/EQdt5vPQNTGnWLUPKmsSh46DgRt95Ve9dJjX1lGax/zH1fKYtq1qfxP6jbPksSPPxaiOOQxrxHlua2hVoS9V3eKB+TcVoVPEPymDPA8EhjGq8yskY4S+rPTJLCk8FzBEnCUHxJlDdqYX2RtNCiIus4BFU+Ho1Z44FPA3rs5TGSdF7uGFM1jvGWAvVRmaGgC/SR29x2XtCqcfq35BIlTPCtVaOxfeLUAf9yR7MnRwN6urz+KzjLttSVN7niCra886QcgwkUIXh44MC5ASXFtylOKySucSAINi0s61lD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHSPR01MB355.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39830400003)(366004)(346002)(30864003)(9686003)(83380400001)(53546011)(66946007)(66446008)(64756008)(55016002)(66556008)(66476007)(71200400001)(966005)(122000001)(38100700002)(54906003)(478600001)(7696005)(8936002)(6916009)(316002)(33656002)(76116006)(86362001)(8676002)(26005)(5660300002)(52536014)(2906002)(186003)(6506007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9xobgRo/150zuNTV3HDsAmQal4nSxtEFZKKNYD3nySzr14jJf0GghXmwLn1Q?=
 =?us-ascii?Q?N7ZWZJIacXSkGYWCIG0cTDDj4LMX/yRXIxWOdYyxEynSYkDa8ArQ+GK1gdxB?=
 =?us-ascii?Q?6MbKQvAtSzOWvln4cGrgQ6CHDWeMzlhLfO9enKlj72gslJ7mCEIuUOLMFxLu?=
 =?us-ascii?Q?Q08XltTOR3mI+51/e6wVE/QtmNouvhxrVjlajUJzGb4WRCRQq8Zpd6b7eNv4?=
 =?us-ascii?Q?55qGr7W7mWmyZ94N3Qp7TmLBIa/clBkl9hnLpfD1WdONUUaeDKPA3qL4zPX9?=
 =?us-ascii?Q?A0kmPUIGYSWMuJfD3Y2J1yHjkCNG7m+POGy+dFlHgqdmf4ZZP+Ozg+vuWmms?=
 =?us-ascii?Q?nRPdznA5pDgZ+lCdfmK6DST7+QUENd3GEFffF8f5HpBjVxwp6gsXG1OXtr6C?=
 =?us-ascii?Q?LMinCtsGMBreFFPOxgam6dKmQRFaLkWoo0/ogGqnHVWkDvq8QOwg6KN0Z61y?=
 =?us-ascii?Q?ZSXRGaJ69MYkrdPYP2emjMMibhCKXbhTbWUVygfydkydZ5Ydek1mRtBLZVC3?=
 =?us-ascii?Q?m0k91wUteKXIfCodRDbZO1MLld2toQ9dRdowGXy6u3XfEUAQzj/TXU/h5ktD?=
 =?us-ascii?Q?GK6sxEr2jga3dGRB/cbN4/iTZazGdKb9HbRHFydRbLxIPK+4tqwTpYDCVOX3?=
 =?us-ascii?Q?hGtEZluXuiBAcSRNZYiB6ca9FPZjvoiPeZFgMIvC0iPkrreyqjOYEd4VXbSw?=
 =?us-ascii?Q?ZfQzs/qJI7dmMPjDMW1RJvp/8djfwfVPVLavZe2tNMynH4jjIgOE1F5ge5sC?=
 =?us-ascii?Q?NVEc7K/hMBV0KaA+a1P9fry9tmFoNks3xeCpU/3mlqtWxbpVGotL3O2vsaa0?=
 =?us-ascii?Q?qnXfnbb4Mel61I1bb0cmQxizSCd8fVqhwx6QKRQoULtg7wVRAIL+CxqdJfLF?=
 =?us-ascii?Q?pY0bhZyBo5mBNGrNF4lhiJEgjdSf/dNCW/UTRunXGeekvWFcdEZCUurDWYQT?=
 =?us-ascii?Q?UT3uZlIET4HgNgYiwtnk4e8jFo68vX78TLZxLUsIUe5mOreDRvkTK7GEm5+R?=
 =?us-ascii?Q?jM8XJ9+pSS08Z/kvmyd6W2JA5VNzDKRvXdHioSXko4735mcc+buwdW6neXpV?=
 =?us-ascii?Q?vhRVb/oHV7tRl3hnR6dBxh8UmR8vbs1LKyMbNA7eiwT7RPFYJ9KE0+xHV+Q4?=
 =?us-ascii?Q?lHSF5bPdGBwKtKgYSrTc3mcgaYcUP9YBQFIzSpNqLBKlVZHZLok6WGIaUlaY?=
 =?us-ascii?Q?QVeXsQI9VtMi4mvtfdLXy57t29OKgcUr/ZjFmFfLt0P+QQzYlyfTm9yz1Jim?=
 =?us-ascii?Q?L6xAwiFs06R8Mqtp2dm3bVMdnSXKm6/4wE5VAb7oqRuItiFvQ8qYzXPs2PWA?=
 =?us-ascii?Q?aeo4SWv4xYuGKAne1Ir3UuV5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHSPR01MB355.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27235ea5-d57d-4d17-0909-08d90a6a2dfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 17:22:20.1950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8K5DAfGIxKxu48Z66i6qxexdN5mvg1nspw88bZa6QpR/UrOnRsZ17hdWiVSSfB/qk18TmXuXim9aZugce/0IIsgJsT2bT0gCh39/MoeNCaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> From: Vladimir Oltean <vladimir.oltean@nxp.com>=20
> Sent: Wednesday, April 28, 2021 2:20 AM
> To: Colin Foster <colin.Foster@in-advantage.com>
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; alexandre.belloni@bootlin.co=
m; UNGLinuxDriver@microchip.com; netdev@vger.kernel.org
> Subject: Re: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
>=20
> Hi Colin,
>=20
> On Wed, Apr 28, 2021 at 01:39:36AM +0000, Colin Foster wrote:
> > From 652b52933c59035ddb3f19dcf84e5a683b868115 Mon Sep 17 00:00:00 2001
> > From: Colin Foster <colin.foster@in-advantage.com>
> > Date: Tue, 27 Apr 2021 23:50:36 +0000
> > Subject: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
> >=20
> > Control for external VSC75XX chips can be performed via non-mmio=20
> > interfaces, e.g. SPI. Adding the offets array (one per target) and the=
=20
> > offset element per port allows the ability to track this location that=
=20
> > would otherwise be found in the MMIO regmap resource.
>=20
> Sadly, without more context around what you need for SPI regmaps, I can't=
 judge whether this change is in fact necessary or not (I don't see why it =
would be, you should be able to provide your own SoC integration file ocelo=
t_vsc7514_spi.c file with the regmap array of your liking, unless what you =
want is to just reuse an existing one, which is probably more trouble than =
it's worth). Do you think you can resend when you have a functional port fo=
r the SPI-managed switches, so we can see everything in action?

Thank you for this feedback. I'm working in felix_vsc7512_spi.c, which is m=
ostly a copy of felix_vsc9959.c but with SPI probing instead of PCI. The me=
mory addresses are different, and down-shifted by two so that devm_regmap_i=
nit_spi can be used without defining a new bus. It is not in a state where =
it is worth your time to review yet. Once it is, I'll re-submit with your s=
uggestions.

>=20
> > Tracking this offset in the ocelot driver and allowing the=20
> > ocelot_regmap_init function to be overloaded with a device-specific=20
> > initializer. This driver could update the *offset element to handle=20
> > the value that would otherwise be mapped via resource *res->start.
> > ---
>=20
> Your patch is whitespace damaged and is in fact a multi-part attachment i=
nstead of a single plain-text body.
> Can you please try to send using git-send-email? See Documentation/proces=
s/submitting-patches.rst for more details.
>=20
> Also, some other process-related tips:
> ./scripts/get_maintainer.pl should have shown more people to Cc: than the=
 ones you did.

I'm embarrassed by this blunder. I'll resolve these by my next commit.

>=20
> And in the networking subsystem, we like to tag patches using git-send-em=
ail --subject-prefix=3D"PATCH vN net-next" or --subject-prefix=3D"PATCH vN =
net" depending on whether it targets this tree (for new features):
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> or this tree (for bug fixes):
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
>=20
> We also review patches even if they aren't fully ready for acceptance for=
 whatever reason, just add "RFC PATCH vN net-next" to your commit.
> But the patches need to tell a full story, and be understandable on their=
 own.
> For example, the merge window should open any time now, and during the me=
rge window, maintainers don't accept patches on their "next" trees.
> In the case of networking, you can check here:
> http://vger.kernel.org/~davem/net-next.html
> (it's open but it will close soon)
> When the development trees are closed you can still send patches as RFC.
>=20
> This, and more, mentioned inside Documentation/networking/netdev-FAQ.rst.
>=20
> > drivers/net/dsa/ocelot/felix.c        | 11 ++++++++--
> > drivers/net/dsa/ocelot/felix.h        |  2 ++
> > drivers/net/ethernet/mscc/ocelot_io.c | 29 +++++++++++++++++++--------
> > include/soc/mscc/ocelot.h             |  5 ++++-
> > 4 files changed, 36 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/ocelot/felix.c=20
> > b/drivers/net/dsa/ocelot/felix.c index 628afb47b579..dcd38653447e=20
> > 100644
> > --- a/drivers/net/dsa/ocelot/felix.c
> > +++ b/drivers/net/dsa/ocelot/felix.c
> > @@ -1083,6 +1083,9 @@ static int felix_init_structs(struct felix *felix=
, int num_phys_ports)
> >     phy_interface_t *port_phy_modes;
> >     struct resource res;
> >     int port, i, err;
> > +    struct regmap *(*local_regmap_init)(struct ocelot *ocelot,
> > +                              struct resource *res,
> > +                              u32 *offset);
>=20
> Why don't you just populate ".regmap_init =3D ocelot_regmap_init" for
> VSC9959 and VSC9953 and remove this local function pointer?

Good idea. Thanks.

>=20
> >      ocelot->num_phys_ports =3D num_phys_ports;
> >     ocelot->ports =3D devm_kcalloc(ocelot->dev, num_phys_ports, @@=20
> > -1111,6 +1114,10 @@ static int felix_init_structs(struct felix *felix, =
int num_phys_ports)
> >           return err;
> >     }
> > +    local_regmap_init =3D (felix->info->regmap_init) ?
> > +                        felix->info->regmap_init :
> > +                        ocelot_regmap_init;
> > +
> >     for (i =3D 0; i < TARGET_MAX; i++) {
> >           struct regmap *target;
> > @@ -1122,7 +1129,7 @@ static int felix_init_structs(struct felix *felix=
, int num_phys_ports)
> >           res.start +=3D felix->switch_base;
> >           res.end +=3D felix->switch_base;
> > -          target =3D ocelot_regmap_init(ocelot, &res);
> > +          target =3D local_regmap_init(ocelot, &res,=20
> > + &ocelot->offsets[i]);
> >           if (IS_ERR(target)) {
> >                dev_err(ocelot->dev,
> >                     "Failed to map device memory space\n"); @@ -1159,7=
=20
> > +1166,7 @@ static int felix_init_structs(struct felix *felix, int num_p=
hys_ports)
> >           res.start +=3D felix->switch_base;
> >           res.end +=3D felix->switch_base;
> > -          target =3D ocelot_regmap_init(ocelot, &res);
> > +          target =3D local_regmap_init(ocelot, &res,=20
> > + &ocelot_port->offset);
> >           if (IS_ERR(target)) {
> >                dev_err(ocelot->dev,
> >                     "Failed to map memory space for port %d\n", diff=20
> > --git a/drivers/net/dsa/ocelot/felix.h=20
> > b/drivers/net/dsa/ocelot/felix.h index 4d96cad815d5..8fde304e754f=20
> > 100644
> > --- a/drivers/net/dsa/ocelot/felix.h
> > +++ b/drivers/net/dsa/ocelot/felix.h
> > @@ -47,6 +47,8 @@ struct felix_info {
> >                      enum tc_setup_type type, void *type_data);
> >     void (*port_sched_speed_set)(struct ocelot *ocelot, int port,
> >                           u32 speed);
> > +    struct regmap *(*regmap_init)(struct ocelot *ocelot,
> > +                          struct resource *res, u32 *offset);
> > };
> >  extern const struct dsa_switch_ops felix_switch_ops; diff --git=20
> > a/drivers/net/ethernet/mscc/ocelot_io.c=20
> > b/drivers/net/ethernet/mscc/ocelot_io.c
> > index ea4e83410fe4..2804cd441817 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_io.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_io.c
> > @@ -18,7 +18,9 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, =
u32 offset)
> >     WARN_ON(!target);
> >      regmap_read(ocelot->targets[target],
> > -              ocelot->map[target][reg & REG_MASK] + offset, &val);
> > +              ocelot->offsets[target] +
> > +                   ocelot->map[target][reg & REG_MASK] + offset,
> > +              &val);
> >     return val;
> > }
> > EXPORT_SYMBOL(__ocelot_read_ix);
> > @@ -30,7 +32,9 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val=
, u32 reg, u32 offset)
> >     WARN_ON(!target);
> >      regmap_write(ocelot->targets[target],
> > -               ocelot->map[target][reg & REG_MASK] + offset, val);
> > +               ocelot->offsets[target] +
> > +                    ocelot->map[target][reg & REG_MASK] + offset,
> > +               val);
> > }
> > EXPORT_SYMBOL(__ocelot_write_ix);
> > @@ -42,7 +46,8 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, =
u32 mask, u32 reg,
> >     WARN_ON(!target);
> >      regmap_update_bits(ocelot->targets[target],
> > -                  ocelot->map[target][reg & REG_MASK] + offset,
> > +                  ocelot->offsets[target] +
> > +                       ocelot->map[target][reg & REG_MASK] + offset,
> >                   mask, val);
> > }
> > EXPORT_SYMBOL(__ocelot_rmw_ix);
> > @@ -55,7 +60,8 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 r=
eg)
> >      WARN_ON(!target);
> > -    regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &va=
l);
> > +    regmap_read(port->target,
> > +              port->offset + ocelot->map[target][reg & REG_MASK],=20
> > + &val);
> >     return val;
> > }
> > EXPORT_SYMBOL(ocelot_port_readl);
> > @@ -67,7 +73,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32=
 val, u32 reg)
> >      WARN_ON(!target);
> > -    regmap_write(port->target, ocelot->map[target][reg & REG_MASK], va=
l);
> > +    regmap_write(port->target,
> > +               port->offset + ocelot->map[target][reg & REG_MASK],=20
> > + val);
> > }
> > EXPORT_SYMBOL(ocelot_port_writel);
> > @@ -85,7 +92,8 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, en=
um ocelot_target target,
> >     u32 val;
> >      regmap_read(ocelot->targets[target],
> > -              ocelot->map[target][reg] + offset, &val);
> > +              ocelot->offsets[target] + ocelot->map[target][reg] + off=
set,
> > +              &val);
> >     return val;
> > }
> > @@ -93,7 +101,9 @@ void __ocelot_target_write_ix(struct ocelot *ocelot,=
 enum ocelot_target target,
> >                      u32 val, u32 reg, u32 offset) {
> >     regmap_write(ocelot->targets[target],
> > -               ocelot->map[target][reg] + offset, val);
> > +               ocelot->offsets[target] + ocelot->map[target][reg] +
> > +                    offset,
>=20
> This could have fit on a single line.

I used clang-format to break up the long lines, but it seems like that caus=
es other issues.  I'll keep an eye out for these.

>=20
> > +               val);
> > }
> >  int ocelot_regfields_init(struct ocelot *ocelot, @@ -136,10 +146,13=20
> > @@ static struct regmap_config ocelot_regmap_config =3D {
> >     .reg_stride     =3D 4,
> > };
> > -struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct=20
> > resource *res)
> > +struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resour=
ce *res,
> > +                      u32 *offset)
> > {
> >     void __iomem *regs;
> > +    *offset =3D 0;
> > +
>=20
> Please ensure there is one empty line between variable declarations and t=
he code. I think ./scripts/checkpatch.pl will warn about this.

The script did not issue a warning. I will resolve this.

>=20
> >     regs =3D devm_ioremap_resource(ocelot->dev, res);
> >     if (IS_ERR(regs))
> >           return ERR_CAST(regs);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h=20
> > index 425ff29d9389..ad45c1af4be9 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -591,6 +591,7 @@ struct ocelot_port {
> >     struct ocelot              *ocelot;
> >      struct regmap              *target;
> > +    u32                  offset;
> >      bool                 vlan_aware;
> >     /* VLAN that untagged frames are classified to, on ingress */ @@=20
> > -621,6 +622,7 @@ struct ocelot {
> >     const struct ocelot_ops          *ops;
> >     struct regmap              *targets[TARGET_MAX];
> >     struct regmap_field        *regfields[REGFIELD_MAX];
> > +    u32                  offsets[TARGET_MAX];
> >     const u32 *const      *map;
> >     const struct ocelot_stat_layout  *stats_layout;
> >     unsigned int               num_stats;
> > @@ -780,7 +782,8 @@ static inline void ocelot_drain_cpu_queue(struct=20
> > ocelot *ocelot, int grp)
> > /* Hardware initialization */
> > int ocelot_regfields_init(struct ocelot *ocelot,
> >                  const struct reg_field *const regfields); -struct=20
> > regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource=20
> > *res);
> > +struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resour=
ce *res,
> > +                      u32 *offset);
> > int ocelot_init(struct ocelot *ocelot); void ocelot_deinit(struct=20
> > ocelot *ocelot); void ocelot_init_port(struct ocelot *ocelot, int=20
> > port);
> > --
> > 2.17.1
> >=20
>
