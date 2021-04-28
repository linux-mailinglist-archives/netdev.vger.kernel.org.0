Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904DA36D4A8
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhD1JVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:21:02 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:8960
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230113AbhD1JVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 05:21:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CraQTQzbz9ItqVWJIN0OFQVVLZkhXG124d+SApSdkSSCVKJGKwsa5dloSqW9uXngk/Kptz7EPRg/TZ6wzAA6OpRmJmpDG24qkF7PO7+V9zOc6eX6r0WYCPoUzCx25a7MCExy+d9SuK3t7+545afgYPTaJGCi9CEZcgBufmIHJtJNXiYh6XRT0qP8TicVJtKFhq8hrr4TIOD9yAJZMT7f+TM463pcfZbO/PWk70mQaT2GfihYgSVwboBb3R9GJ9xApH/SHiv2oCDYvhhsQTZKqUgBKT11MoKD+3e5Km3Xvd9DIOeqceianxSv5sfiWmoYt+g0WZ8AyiDxIxbW/7dYcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsMqq3Ny0cUsDBDanzdkBdnDTMo+qfFy1Tj2k7fdqYM=;
 b=JfMGv1rFj9Rt3CLCfCe5n5P4OxdA2GInUiEFEomxZ76fTgz3N2sfPRSEcw9aUD/CWO4kmuQ3aG1XkY+cc3hjJRwrUjOQXFJe5g9S52ibrH4z2SQZe6nBaUWnFuEQz0qdggLAGmp0Spw8Vpg8VDayIUgG4uHK59MxkndG9lfDt22BK9aQCELutMkN5s9pyTrng8fvroCBtZ3ttMdhKVrcDbfM/p7Nq8w93X5vQTdiuQmj4Pp9wEGVldo2xzm5gEna79xTWfF+1fP3txsIBXcMOYSufZF3mnAHkPehsLIXjMKl9KP1nc3DaONZ0W0I4Xmlc2MV8qsgPMATLs8NKd5Prg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsMqq3Ny0cUsDBDanzdkBdnDTMo+qfFy1Tj2k7fdqYM=;
 b=KnL8CwY4N4fZnisvzSvd+SXOL21oALxDQ5suCgtSay03gloKxjptXUTNzHzW22REhc2zMDiusSIVpQiDnBZDcAq/ImI+QZcHPIoTa23JFm4+8p2o1xT1bJy+YTPF7cHS1j3CQu8HD3Kfvc74RwRzEh2MiYeOZD9E+2C7w+UMj5E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7326.eurprd04.prod.outlook.com (2603:10a6:800:1b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 09:20:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 09:20:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.Foster@in-advantage.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
Thread-Topic: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
Thread-Index: Adc7zfpDg2MBQyIURryZ8Ua+ZuZPqAAQbfIA
Date:   Wed, 28 Apr 2021 09:20:15 +0000
Message-ID: <20210428092014.4wc46l67eufb2gfi@skbuf>
References: <DM5PR1001MB2345F62260EE8E45D2306A6EA4409@DM5PR1001MB2345.namprd10.prod.outlook.com>
In-Reply-To: <DM5PR1001MB2345F62260EE8E45D2306A6EA4409@DM5PR1001MB2345.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.127.41.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afa9ac1d-51b8-4c70-4ac0-08d90a26d557
x-ms-traffictypediagnostic: VE1PR04MB7326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB73267F1AD8762FBB12E59427E0409@VE1PR04MB7326.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1CWxaPXFpYWY1u3nnx81Bq/+QbYu+eqoKR+B+XgHx8VWdvgdrFWQepebjXoXHyeOaegjfQQbivpgNBc6c2ITaQSGH7Vb8T8W6fmpASJqKwvcPU6cYFtlKd0tvORxvCBoSPEr2x9R/WxcWQVdtnGSGRtmpLewWibLpNIHbgO2FbhDs1x8DVEBZYSqsm3dzXgrayijSt1hnKqu8uT0hdJEAzvCiIPM9GKASD6zXWKVARD/Y4ydDeSXBcPjCXkNz5kLqW1q3dJiX001e4dJUa+IbCwVltpf86fnjFn+KboqFWGZFdcJTxL9ZunNuKYe59kAacG84slMVSoz1LURXKTve9axYxGs0TlttQ+Qd+3MD4LyPCJmU7knEjQK1NLZ/U1WWzQ2m6QTd/1Ban6hKEAhiroqNSmM/MTUMIyPY0rOfJOlA1hb9uteFEE5BHxIkgyOZX/ckuO8PIFcAS9bzLmB94GkuF5n6ah1XEwBZa6esJWFcUr7p2lvVVVZ54WquVsQq8l778jY4KWb2QTyelBKSAKDMXFR7wsyXiB7AwiGEXPyovNM8tGYkV+H2uTodPHTFqI9abEIr4tiJ+4itTEcJPTZcq8aNIOZPJek7llHWx7fY09i7aEj23Dnje3r2fQ8e9e4ew/ogMLEAY0PP07FC9F9ndhnWscpJePQcNYxGdS3nczMU6fkDJv2VW1ABHNg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(86362001)(44832011)(8936002)(54906003)(53546011)(6486002)(1076003)(478600001)(186003)(122000001)(6506007)(6916009)(316002)(8676002)(6512007)(9686003)(33716001)(2906002)(26005)(64756008)(966005)(66946007)(4326008)(5660300002)(38100700002)(66446008)(71200400001)(66556008)(76116006)(91956017)(83380400001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?guVLM89AspnLJ6an8D16YI3+UACm/CPw0+ixEOh2Bc4ASa5zkj4Cd1RwWmBi?=
 =?us-ascii?Q?57jVR45Xpg4XrBbw6B+QICNftClkWzeDyM2/iA+lZkf7Bpyx3WXn8V19cuz7?=
 =?us-ascii?Q?3HnXRRmLHkL6mhYqcgABxXsh6aN4/fUHPllTXPlCFXcQr0lN7LhP37LcwNJ1?=
 =?us-ascii?Q?iHb0XrF8gb7V21CWotZmsPy/XYpNqF5dqN0Vur5sKwjrzAXBavAHqG0lyVng?=
 =?us-ascii?Q?BJdF+ZODvaTKsK+kKeTr8qS3sDwtM5jHVoak0jujCKkA0n7rEH3npbk3pRG/?=
 =?us-ascii?Q?Rrh2g7Ys7QkKTtEx18OB1ONEHN5mCatH4JewkD4BLPpYqOO5+ZZHxzHRJDQX?=
 =?us-ascii?Q?Q8MTlUojSdbCH0zTp8729TACCAii2p1z7/x/xQpYJaamVRg6fndjqjz6P/oS?=
 =?us-ascii?Q?a4I48yfJNABusAUT3GvfcdLy5XivTxQwPu7cY/Vlj/v9TbOOBaqK97RshcUm?=
 =?us-ascii?Q?udRKyfc/ZE1W/X3X8+Xayd7NSXSxc+VuTPOkIzOC3ZnfK08N7one+OuVTFoq?=
 =?us-ascii?Q?gDDQditpAhN+CEA4MVNGxBScRQSY8ij3qX5l93l3xz36q3S94rGg8uSo53eu?=
 =?us-ascii?Q?U9cYDiCQs+JKlU50GcbX5Z2ncGQUesn3H+utic54gdaDTJDMjNDHxlTqtzR6?=
 =?us-ascii?Q?+aB8lc+RHjgJIb0GdOSMXklb9FIra1aKqGAGRNAh0QB1nIa2AFH/ujfNAsVT?=
 =?us-ascii?Q?e3YROOWtH3QF+mYgbjndEcuUvbhizyXXDft81+XbqaJ+wd0IKceV1jZw/2uG?=
 =?us-ascii?Q?XDzCXZHLUKRA5mfANLewGz54FAfCf7u2Yed2F1pmP1sOu4fV3Oy4bjPrXpaw?=
 =?us-ascii?Q?+Lw1T283LVRcqREuloEXVIr0rX3r0eEf0y+q1peS3SSzMLH9ZHU6cYrvcSuS?=
 =?us-ascii?Q?ZkWTDbvXMcJOj6b42+tc1zKka9XRhelOWDaGb+JN3drRRQZk03Lko5kwT6zo?=
 =?us-ascii?Q?c2Tai8rLosZmFHtxRKyVXAhPjYw9uHsWYcAJDArX5T/grNcTaB3ApEEi7s1V?=
 =?us-ascii?Q?zqN0yNUDCQcx8FhjuvnjEW2Vtdo98uqRFl6GteS0PELYyUUi2m3btEjg8YWM?=
 =?us-ascii?Q?XlT92lkkYhZRDUKM0fv0GAEKH62p98kchikvBYbbL2srrvzOExiyhbhHVB9j?=
 =?us-ascii?Q?eG0vzO2clkBIc0B+jTC5XVyB3xEM0INTrb9KER8B3fHx1fqBBN9pTslTyDMC?=
 =?us-ascii?Q?GF9b9cWtbCXFueni+zBBuzByf+QEGU4JuXGMEY6vbKRMcRcl8QIWnK3/I59R?=
 =?us-ascii?Q?89QdOSZoL87uoeScf85o9qduqdCq6GRhwPY8F/Sof+h7j4oKj+atY9mlxll9?=
 =?us-ascii?Q?q2sX7IttoTePsH6htv1dYCda?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35F9B35C6C1FA84EBE8950610B781239@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa9ac1d-51b8-4c70-4ac0-08d90a26d557
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 09:20:15.2639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +UdbvY6TZkc24G6Q9Ji800ArKVCCnNIOHxO97ddAuqvUArPgTAXH6gmsGf+uMFp2k7RnmDm5OX9eH9a0xjQ6/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Wed, Apr 28, 2021 at 01:39:36AM +0000, Colin Foster wrote:
> From 652b52933c59035ddb3f19dcf84e5a683b868115 Mon Sep 17 00:00:00 2001
> From: Colin Foster <colin.foster@in-advantage.com>
> Date: Tue, 27 Apr 2021 23:50:36 +0000
> Subject: [PATCH] net: mscc: ocelot: add support for non-mmio regmaps
>=20
> Control for external VSC75XX chips can be performed via non-mmio
> interfaces, e.g. SPI. Adding the offets array (one per target) and
> the offset element per port allows the ability to track this
> location that would otherwise be found in the MMIO regmap resource.

Sadly, without more context around what you need for SPI regmaps, I
can't judge whether this change is in fact necessary or not (I don't see
why it would be, you should be able to provide your own SoC integration
file ocelot_vsc7514_spi.c file with the regmap array of your liking,
unless what you want is to just reuse an existing one, which is probably
more trouble than it's worth). Do you think you can resend when you have
a functional port for the SPI-managed switches, so we can see everything
in action?

> Tracking this offset in the ocelot driver and allowing the
> ocelot_regmap_init function to be overloaded with a device-specific
> initializer. This driver could update the *offset element to handle the
> value that would otherwise be mapped via resource *res->start.
> ---

Your patch is whitespace damaged and is in fact a multi-part attachment
instead of a single plain-text body.
Can you please try to send using git-send-email? See
Documentation/process/submitting-patches.rst for more details.

Also, some other process-related tips:
./scripts/get_maintainer.pl should have shown more people to Cc: than
the ones you did.

And in the networking subsystem, we like to tag patches using
git-send-email --subject-prefix=3D"PATCH vN net-next" or
--subject-prefix=3D"PATCH vN net" depending on whether it targets this
tree (for new features):
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
or this tree (for bug fixes):
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

We also review patches even if they aren't fully ready for acceptance
for whatever reason, just add "RFC PATCH vN net-next" to your commit.
But the patches need to tell a full story, and be understandable on
their own.
For example, the merge window should open any time now, and during the
merge window, maintainers don't accept patches on their "next" trees.
In the case of networking, you can check here:
http://vger.kernel.org/~davem/net-next.html
(it's open but it will close soon)
When the development trees are closed you can still send patches as RFC.

This, and more, mentioned inside Documentation/networking/netdev-FAQ.rst.

> drivers/net/dsa/ocelot/felix.c        | 11 ++++++++--
> drivers/net/dsa/ocelot/felix.h        |  2 ++
> drivers/net/ethernet/mscc/ocelot_io.c | 29 +++++++++++++++++++--------
> include/soc/mscc/ocelot.h             |  5 ++++-
> 4 files changed, 36 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index 628afb47b579..dcd38653447e 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -1083,6 +1083,9 @@ static int felix_init_structs(struct felix *felix, =
int num_phys_ports)
>     phy_interface_t *port_phy_modes;
>     struct resource res;
>     int port, i, err;
> +    struct regmap *(*local_regmap_init)(struct ocelot *ocelot,
> +                              struct resource *res,
> +                              u32 *offset);

Why don't you just populate ".regmap_init =3D ocelot_regmap_init" for
VSC9959 and VSC9953 and remove this local function pointer?

>      ocelot->num_phys_ports =3D num_phys_ports;
>     ocelot->ports =3D devm_kcalloc(ocelot->dev, num_phys_ports,
> @@ -1111,6 +1114,10 @@ static int felix_init_structs(struct felix *felix,=
 int num_phys_ports)
>           return err;
>     }
> +    local_regmap_init =3D (felix->info->regmap_init) ?
> +                        felix->info->regmap_init :
> +                        ocelot_regmap_init;
> +
>     for (i =3D 0; i < TARGET_MAX; i++) {
>           struct regmap *target;
> @@ -1122,7 +1129,7 @@ static int felix_init_structs(struct felix *felix, =
int num_phys_ports)
>           res.start +=3D felix->switch_base;
>           res.end +=3D felix->switch_base;
> -          target =3D ocelot_regmap_init(ocelot, &res);
> +          target =3D local_regmap_init(ocelot, &res, &ocelot->offsets[i]=
);
>           if (IS_ERR(target)) {
>                dev_err(ocelot->dev,
>                     "Failed to map device memory space\n");
> @@ -1159,7 +1166,7 @@ static int felix_init_structs(struct felix *felix, =
int num_phys_ports)
>           res.start +=3D felix->switch_base;
>           res.end +=3D felix->switch_base;
> -          target =3D ocelot_regmap_init(ocelot, &res);
> +          target =3D local_regmap_init(ocelot, &res, &ocelot_port->offse=
t);
>           if (IS_ERR(target)) {
>                dev_err(ocelot->dev,
>                     "Failed to map memory space for port %d\n",
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/feli=
x.h
> index 4d96cad815d5..8fde304e754f 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -47,6 +47,8 @@ struct felix_info {
>                      enum tc_setup_type type, void *type_data);
>     void (*port_sched_speed_set)(struct ocelot *ocelot, int port,
>                           u32 speed);
> +    struct regmap *(*regmap_init)(struct ocelot *ocelot,
> +                          struct resource *res, u32 *offset);
> };
>  extern const struct dsa_switch_ops felix_switch_ops;
> diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet=
/mscc/ocelot_io.c
> index ea4e83410fe4..2804cd441817 100644
> --- a/drivers/net/ethernet/mscc/ocelot_io.c
> +++ b/drivers/net/ethernet/mscc/ocelot_io.c
> @@ -18,7 +18,9 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u3=
2 offset)
>     WARN_ON(!target);
>      regmap_read(ocelot->targets[target],
> -              ocelot->map[target][reg & REG_MASK] + offset, &val);
> +              ocelot->offsets[target] +
> +                   ocelot->map[target][reg & REG_MASK] + offset,
> +              &val);
>     return val;
> }
> EXPORT_SYMBOL(__ocelot_read_ix);
> @@ -30,7 +32,9 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, =
u32 reg, u32 offset)
>     WARN_ON(!target);
>      regmap_write(ocelot->targets[target],
> -               ocelot->map[target][reg & REG_MASK] + offset, val);
> +               ocelot->offsets[target] +
> +                    ocelot->map[target][reg & REG_MASK] + offset,
> +               val);
> }
> EXPORT_SYMBOL(__ocelot_write_ix);
> @@ -42,7 +46,8 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u3=
2 mask, u32 reg,
>     WARN_ON(!target);
>      regmap_update_bits(ocelot->targets[target],
> -                  ocelot->map[target][reg & REG_MASK] + offset,
> +                  ocelot->offsets[target] +
> +                       ocelot->map[target][reg & REG_MASK] + offset,
>                   mask, val);
> }
> EXPORT_SYMBOL(__ocelot_rmw_ix);
> @@ -55,7 +60,8 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg=
)
>      WARN_ON(!target);
> -    regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &val)=
;
> +    regmap_read(port->target,
> +              port->offset + ocelot->map[target][reg & REG_MASK], &val);
>     return val;
> }
> EXPORT_SYMBOL(ocelot_port_readl);
> @@ -67,7 +73,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32 v=
al, u32 reg)
>      WARN_ON(!target);
> -    regmap_write(port->target, ocelot->map[target][reg & REG_MASK], val)=
;
> +    regmap_write(port->target,
> +               port->offset + ocelot->map[target][reg & REG_MASK], val);
> }
> EXPORT_SYMBOL(ocelot_port_writel);
> @@ -85,7 +92,8 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum=
 ocelot_target target,
>     u32 val;
>      regmap_read(ocelot->targets[target],
> -              ocelot->map[target][reg] + offset, &val);
> +              ocelot->offsets[target] + ocelot->map[target][reg] + offse=
t,
> +              &val);
>     return val;
> }
> @@ -93,7 +101,9 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, e=
num ocelot_target target,
>                      u32 val, u32 reg, u32 offset)
> {
>     regmap_write(ocelot->targets[target],
> -               ocelot->map[target][reg] + offset, val);
> +               ocelot->offsets[target] + ocelot->map[target][reg] +
> +                    offset,

This could have fit on a single line.

> +               val);
> }
>  int ocelot_regfields_init(struct ocelot *ocelot,
> @@ -136,10 +146,13 @@ static struct regmap_config ocelot_regmap_config =
=3D {
>     .reg_stride     =3D 4,
> };
> -struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource=
 *res)
> +struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource=
 *res,
> +                      u32 *offset)
> {
>     void __iomem *regs;
> +    *offset =3D 0;
> +

Please ensure there is one empty line between variable declarations and
the code. I think ./scripts/checkpatch.pl will warn about this.

>     regs =3D devm_ioremap_resource(ocelot->dev, res);
>     if (IS_ERR(regs))
>           return ERR_CAST(regs);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 425ff29d9389..ad45c1af4be9 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -591,6 +591,7 @@ struct ocelot_port {
>     struct ocelot              *ocelot;
>      struct regmap              *target;
> +    u32                  offset;
>      bool                 vlan_aware;
>     /* VLAN that untagged frames are classified to, on ingress */
> @@ -621,6 +622,7 @@ struct ocelot {
>     const struct ocelot_ops          *ops;
>     struct regmap              *targets[TARGET_MAX];
>     struct regmap_field        *regfields[REGFIELD_MAX];
> +    u32                  offsets[TARGET_MAX];
>     const u32 *const      *map;
>     const struct ocelot_stat_layout  *stats_layout;
>     unsigned int               num_stats;
> @@ -780,7 +782,8 @@ static inline void ocelot_drain_cpu_queue(struct ocel=
ot *ocelot, int grp)
> /* Hardware initialization */
> int ocelot_regfields_init(struct ocelot *ocelot,
>                  const struct reg_field *const regfields);
> -struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource=
 *res);
> +struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource=
 *res,
> +                      u32 *offset);
> int ocelot_init(struct ocelot *ocelot);
> void ocelot_deinit(struct ocelot *ocelot);
> void ocelot_init_port(struct ocelot *ocelot, int port);
> --
> 2.17.1
> =
