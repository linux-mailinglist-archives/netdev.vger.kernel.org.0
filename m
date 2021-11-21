Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D971A458588
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbhKURrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:47:21 -0500
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:50912
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237885AbhKURrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:47:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEPpxVqVkgm9qC/QwW1tO6BhMMAfulOLOT88NGHDh8Bc644LaMvgIZUGEuwouccQG05rA9i5uJO2xtVuqTNx4NIzrjzDYz5Ud6A34prcIqrAG/S9rQOaXp9pczxgRNyWLRIC5Eiy3o9GJ1J/YzT7mNJgbinpSmJbbK5i/IY5OaoyLJ83yP9ZsVU67x9qDSncAChs3m9J6wgNzZQBTnn+zV/Uw38cLg97J7B9Nn+L0JZ1e0wowg53TzGy5PK9vTIIj904HUo2yHAoUQJSRlHRHXEMp4nyCmJZtIE449JftyLqThQuygKl1UWkIZxwg65DLk9+Bfw/eNQDnsSM8WHHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X156O4PpW+x6YpLBzI64/5Om/eDmmwL5QmLvfQerGFw=;
 b=TFn/ojLjJRHFXaynn/Mgfbb5aRLe1ZAH93QsOVJ9mb8SqKTFhaHqUZBIarpG0H0a8u4tLzBrzVNLXWc1P59yrWWlwdAbBF+OpUjByy+73ymd+T5mqW3YRwk8Z8VarGKQ1JTBDNZwwiLgqsI2I7wXzV+Ygj3K/rGezJQUkVS2qPa+MyvlYFpQKKOo9Fa5y9fO88oO7Qpyw3CIInieKZJ6rfvwGRD3Yu/QLs+bfqcNBKL54rWVgXJYg6hmspMgygyb+s9Zi7+WmYptTCo9x7JS74XiNBdLMLzowYEi2uYX5z7pKo+DQO9JKcGPrZUEo5lVWClYDWHgoKZ17V7+sHXudg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X156O4PpW+x6YpLBzI64/5Om/eDmmwL5QmLvfQerGFw=;
 b=T9VB1YqCGdWKmBpgk7OuIn5te3/bgrhMSRO0jX4mTR0VJuSNjpanTizCc4faKxxCt07H94sp/wzB997yo05fJ59DKipJgnyjm5Zmogi1Qkr5kLCOe7JXF2Oc0GHz2TyuJOYZ0ZvJ3ddu9CgZN8Fzy5pKkL8AYkBSNRJk4qG8H5g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 17:44:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:44:13 +0000
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 3/3] net: dsa: ocelot: felix: switch to
 mdio-mscc-miim driver for indirect mdio access
Thread-Topic: [PATCH v1 net-next 3/3] net: dsa: ocelot: felix: switch to
 mdio-mscc-miim driver for indirect mdio access
Thread-Index: AQHX3Y3yL6NO46AcK0qxvj6a8yLsFawOQ60A
Date:   Sun, 21 Nov 2021 17:44:13 +0000
Message-ID: <20211121174412.xi4dxw35qrfqyjjv@skbuf>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
 <20211119213918.2707530-4-colin.foster@in-advantage.com>
In-Reply-To: <20211119213918.2707530-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07f0c5ac-4d5e-4960-a36a-08d9ad16885e
x-ms-traffictypediagnostic: VE1PR04MB7327:
x-microsoft-antispam-prvs: <VE1PR04MB7327BB661C1FB804321B7EA3E09E9@VE1PR04MB7327.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OYzDpSgjXiVi+WdFDjRmEGefKwmaYhq7vvweOPC+Illdzogzptu7EEi4XfBxt/3CTEN5GWBrPfBRw+lsEkHBS7/rrIYCoYED04mq8xt6dPaBO2lrot5Z7wBMRSg8/rYQHlP4qesgAOZBSyoq87aykaFaFjudMnt8Aan+M00adRRmMm/yKbjUZfhIvTwbbjWyGh+5FnTpxorZlM/t3T9X/uwiBPSonGQ1nctajgYb/8tMY11YkOpKCmKaBnSV09dmTA+ASdl1eWtqftH3VziZVnq4Y5IDSXTa8AXVfOHPtfDb3K69TawAexdx06jFkn33VlqTZeXqW00FkDQLVUqiXx4RrFOXMWym0ikHfYKPPbpW+OnteOBIg6i1DDNvWOuHEXSq/glhicDtqnB9fL42U61eNVdNvZl2vY43ESVbBM/U3SG1m/8uKOpPIPomTuwkjpMrsjiV7AEkkPD160kY6CrccX1JKXMFwG9xB/Bf56JvLzLQHjNZsYf1xeOJZKjPWzgTv9aa2M1uWCIneFBuenBTvMEqyHd9AB1+tKnpuUJmxQhHZPN3pY5uqkusRzbrsqB9ms2GbgjzDZ5MtKeVQM/7ysRZKxfWEjxK2f+xupmoUCX6XK0d5Lcttmlt9Abr7TS41PpQjb9ecNLU1XTtC/94/GNqKk6grmne04xu9AJM3Gzfr02ay416dsnHE7mLAEa6DsKySw8w5RWxIGnCfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(30864003)(186003)(66446008)(8936002)(508600001)(2906002)(54906003)(6916009)(6506007)(7416002)(38070700005)(83380400001)(316002)(8676002)(4326008)(86362001)(44832011)(122000001)(6486002)(91956017)(76116006)(66476007)(66556008)(66946007)(6512007)(64756008)(5660300002)(1076003)(9686003)(38100700002)(71200400001)(26005)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5oKmlNVI/wajSjHXz2cB5UCgR247dO2CZ9BpKST8ZNLkxX7k6POR9N71I7/2?=
 =?us-ascii?Q?o2BSNOhH5ozwV/H5lS7furZd+10kErxxQiTkakg/J4fn/ZD9ve1ViHrjJQdJ?=
 =?us-ascii?Q?A1W88gQOmsRcNRDQwEDL7YPuXmppjEnVHoRbDXWKz4EqbNQy+ErZIsBpdO0c?=
 =?us-ascii?Q?mMsrXWRVetmC3CelJarjJDGDYJT9enXnv6fLBdiVA7OUzeJ2Gni7SewByKPa?=
 =?us-ascii?Q?lGaVGeHqW7GFZWhmixBNMurCRx44czfVw2hAOM1uSNiBxwLfy/9s7YwSSJl1?=
 =?us-ascii?Q?jZM7phADdFmWODan0ddvGg0sxKDBhePSKegnfwNsF46sVwHCHpuZEmM/fpsG?=
 =?us-ascii?Q?ejjaDdVw132Gf/j3pfdB7zF6Am4Sgr5WwxsfvIyVXf+NZvzYx+WmlRwtr7cH?=
 =?us-ascii?Q?a+YMjRtC4GAKWbVTv1jgsHv/6glC8PsMBfCmifjHEGPuaRCSoTq/3rvTPSin?=
 =?us-ascii?Q?b2ywKIxN6irU7ixyLtltcqF3OxRkKMOsgL2P0bb97c2+9UnEaNEOoTsZoi2x?=
 =?us-ascii?Q?WQFXTPgKbm5EiHkcjiy0T/FwClJz2FxB5GvWUwhU4X3VlmwRM/NDi2uWtfHf?=
 =?us-ascii?Q?eZeXmVpsYhQUaPA9hwRyUQKztNY1yp+4X9/ROSVHg/aXYY5figegWjnF/hyG?=
 =?us-ascii?Q?P+bWXLfpY/CgEnyMNrHWqxdkO6HYg/tJ2QG02NDA4OxK8/9Bbndc/K5K1ktR?=
 =?us-ascii?Q?TVkHmt4ALMbtOfwj4aR3uSx5Cn2paLFpnzEWltTHloqVHcx0awsRWHLF/BR9?=
 =?us-ascii?Q?xv74UXofHW+oliSKCMOm5tGBPpqvIn1WPxhf6ATUQIBheQHXjFQwi1cIYIaq?=
 =?us-ascii?Q?s4FSoQjZjdlnyyztEtznAdDGpaTq9/7JjnxLhVQXR2jw9bqN1XHyFYbsPdah?=
 =?us-ascii?Q?7KeqJ9uz9FJpbAiIbrK/sIPU+Ivl1J47bewpLER3Ep3+SGNOp+pKA3Hzxr4Z?=
 =?us-ascii?Q?fHwyGJXHxEqgnZzq/vlvh1Rq0PXBeu4ngi3/z+jSxelDKDt+7A0R+mjQZw5e?=
 =?us-ascii?Q?UVwGbaiRIe8VMQGw+1lev8VUrQ9zqaFw99Jt3tWzUSUI4hETO0wQN04JkFod?=
 =?us-ascii?Q?POhKsxhzwZGZKH22Ond+XpdSBXeAVloHxD6ZN+iVIzJ06hTuv4ZxWnRcXkfR?=
 =?us-ascii?Q?MI9CYDl/bbhA5fTKMFpvNogYhYfjj3ehgaFNGLvMm5hxD7Am3GSafGDktIcD?=
 =?us-ascii?Q?7hSyMSx0Jroozd4W7nwt2MwnTyXkHAKYDccK6U/KH7OYI1mKH4+3j4Y2m4Tk?=
 =?us-ascii?Q?fJ617RQz8mAjHFJaHRNEifruAdn3iTCxY6zJ2dChun+aECWiTFiIHh2ug2me?=
 =?us-ascii?Q?ZO3Xw/n+lgFQtQLzsmosqur++k4f7yl8j7BdZT02+G6BpR00mc5rRj0fglbC?=
 =?us-ascii?Q?7zoyqUi0Yp+6e1fy+XCVBgBIRZrAWhqEWJF0FKvEI18I6V9+0pGHPBm/2cMo?=
 =?us-ascii?Q?YA2LepxLKg+ZfE06WlXzZldw46omtlT/Wnk6qSL3VrXIo5DvxB0BBbRRK5E1?=
 =?us-ascii?Q?Ibpl7x/5o7IE2cfFj4gi3mQkHLuEnn0DrHobMG/yJ3T9N1y7gRq2CFJ9NhA+?=
 =?us-ascii?Q?hXFLAS1Q2Vboy3AemvAvwPylHXsFTtjlulFzGhlh55Rg7GaepXNUyHJsoEjV?=
 =?us-ascii?Q?FiJHTADnPTJH9SQlbR0LAw0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B94F1AB39A7F984FB401F5DB6AEA97EB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f0c5ac-4d5e-4960-a36a-08d9ad16885e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:44:13.7045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xv0O9clKs5LTxi8Le4K+6u7VW6q2WxSVEMSd+cjd8guCXk2GdQTFPut5psxuB8PUwNwmq1L5PTEtQr4HdwvYWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 01:39:18PM -0800, Colin Foster wrote:
> Switch to a shared MDIO access implementation now provided by
> drivers/net/mdio/mdio-mscc-miim.c
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/dsa/ocelot/Kconfig           |   1 +
>  drivers/net/dsa/ocelot/Makefile          |   1 +
>  drivers/net/dsa/ocelot/felix_mdio.c      |  54 ++++++++++++
>  drivers/net/dsa/ocelot/felix_mdio.h      |  13 +++
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 108 ++---------------------
>  drivers/net/mdio/mdio-mscc-miim.c        |  37 ++++++--
>  include/linux/mdio/mdio-mscc-miim.h      |  19 ++++
>  include/soc/mscc/ocelot.h                |   1 +
>  8 files changed, 125 insertions(+), 109 deletions(-)
>  create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
>  create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
>  create mode 100644 include/linux/mdio/mdio-mscc-miim.h
>=20
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kcon=
fig
> index 9948544ba1c4..220b0b027b55 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -21,6 +21,7 @@ config NET_DSA_MSCC_SEVILLE
>  	depends on NET_VENDOR_MICROSEMI
>  	depends on HAS_IOMEM
>  	depends on PTP_1588_CLOCK_OPTIONAL
> +	select MDIO_MSCC_MIIM
>  	select MSCC_OCELOT_SWITCH_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
>  	select NET_DSA_TAG_OCELOT
> diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Mak=
efile
> index f6dd131e7491..34b9b128efb8 100644
> --- a/drivers/net/dsa/ocelot/Makefile
> +++ b/drivers/net/dsa/ocelot/Makefile
> @@ -8,4 +8,5 @@ mscc_felix-objs :=3D \
> =20
>  mscc_seville-objs :=3D \
>  	felix.o \
> +	felix_mdio.o \
>  	seville_vsc9953.o
> diff --git a/drivers/net/dsa/ocelot/felix_mdio.c b/drivers/net/dsa/ocelot=
/felix_mdio.c
> new file mode 100644
> index 000000000000..34375285756b
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/felix_mdio.c
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Distributed Switch Architecture VSC9953 driver
> + * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
> + * Copyright (C) 2021 Innovative Advantage
> + */
> +#include <linux/of_mdio.h>
> +#include <linux/types.h>
> +#include <soc/mscc/ocelot.h>
> +#include <linux/dsa/ocelot.h>
> +#include <linux/mdio/mdio-mscc-miim.h>
> +#include "felix.h"
> +#include "felix_mdio.h"
> +
> +int felix_of_mdio_register(struct ocelot *ocelot, struct device_node *np=
)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	struct device *dev =3D ocelot->dev;
> +	int rc;
> +
> +	/* Needed in order to initialize the bus mutex lock */
> +	rc =3D of_mdiobus_register(felix->imdio, np);
> +	if (rc < 0) {
> +		dev_err(dev, "failed to register MDIO bus\n");
> +		felix->imdio =3D NULL;
> +	}
> +
> +	return rc;
> +}
> +
> +int felix_mdio_bus_alloc(struct ocelot *ocelot)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	struct device *dev =3D ocelot->dev;
> +	struct mii_bus *bus;
> +	int err;
> +
> +	err =3D mscc_miim_setup(dev, &bus, ocelot->targets[GCB],
> +			      ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
> +			      ocelot->targets[GCB],
> +			      ocelot->map[GCB][GCB_PHY_PHY_CFG & REG_MASK]);
> +
> +	if (!err)
> +		felix->imdio =3D bus;
> +
> +	return err;
> +}

I am a little doubtful of the value added by felix_mdio.c, since very
little is actually common. For example, the T1040 SoC has dpaa-eth
standalone ports (including the DSA master) and an embedded Seville
(VSC9953) switch. To access external PHYs connected to the switch, the
dpaa-eth MDIO bus is used (drivers/net/ethernet/freescale/xgmac_mdio.c).
The Microsemi MIIM MDIO controller from the Seville switch is used to
access only the NXP Lynx PCS, which is MDIO-mapped. That's why we put it
in felix->imdio (i =3D=3D internal).

Whereas in your case, the Microsemi MIIM MDIO controller is used to
actually access the external PHYs. So it won't go in felix->imdio, since
it's not internal.

(yes, I know that NXP's integration of Vitesse switches is strange, but
it is what it is).

So unless I'm missing something, I guess you would be better off leaving
this code in Seville, and just duplicating minor portions of it (the
call to mscc_miim_setup) in your vsc7514 driver. What do you think?

> +
> +void felix_mdio_bus_free(struct ocelot *ocelot)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +
> +	if (felix->imdio)
> +		mdiobus_unregister(felix->imdio);
> +}
> diff --git a/drivers/net/dsa/ocelot/felix_mdio.h b/drivers/net/dsa/ocelot=
/felix_mdio.h
> new file mode 100644
> index 000000000000..93286f598c3b
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/felix_mdio.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/* Shared code for indirect MDIO access for Felix drivers
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + * Copyright (C) 2021 Innovative Advantage
> + */
> +#include <linux/of.h>
> +#include <linux/types.h>
> +#include <soc/mscc/ocelot.h>
> +
> +int felix_mdio_bus_alloc(struct ocelot *ocelot);
> +int felix_of_mdio_register(struct ocelot *ocelot, struct device_node *np=
);
> +void felix_mdio_bus_free(struct ocelot *ocelot);
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/o=
celot/seville_vsc9953.c
> index db124922c374..dd7ae6a1d843 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -10,15 +10,9 @@
>  #include <linux/pcs-lynx.h>
>  #include <linux/dsa/ocelot.h>
>  #include <linux/iopoll.h>
> -#include <linux/of_mdio.h>
>  #include "felix.h"
> +#include "felix_mdio.h"
> =20
> -#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
> -#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
> -#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
> -#define MSCC_MIIM_CMD_REGAD_SHIFT		20
> -#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
> -#define MSCC_MIIM_CMD_VLD			BIT(31)
>  #define VSC9953_VCAP_POLICER_BASE		11
>  #define VSC9953_VCAP_POLICER_MAX		31
>  #define VSC9953_VCAP_POLICER_BASE2		120
> @@ -862,7 +856,6 @@ static struct vcap_props vsc9953_vcap_props[] =3D {
>  #define VSC9953_INIT_TIMEOUT			50000
>  #define VSC9953_GCB_RST_SLEEP			100
>  #define VSC9953_SYS_RAMINIT_SLEEP		80
> -#define VCS9953_MII_TIMEOUT			10000
> =20
>  static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
>  {
> @@ -882,82 +875,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot=
 *ocelot)
>  	return val;
>  }
> =20
> -static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
> -{
> -	int val;
> -
> -	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
> -
> -	return val;
> -}
> -
> -static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
> -{
> -	int val;
> -
> -	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
> -
> -	return val;
> -}
> -
> -static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnu=
m,
> -			      u16 value)
> -{
> -	struct ocelot *ocelot =3D bus->priv;
> -	int err, cmd, val;
> -
> -	/* Wait while MIIM controller becomes idle */
> -	err =3D readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
> -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> -	if (err) {
> -		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
> -		goto out;
> -	}
> -
> -	cmd =3D MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> -	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> -	      MSCC_MIIM_CMD_OPR_WRITE;
> -
> -	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
> -
> -out:
> -	return err;
> -}
> -
> -static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum=
)
> -{
> -	struct ocelot *ocelot =3D bus->priv;
> -	int err, cmd, val;
> -
> -	/* Wait until MIIM controller becomes idle */
> -	err =3D readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
> -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> -	if (err) {
> -		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
> -		goto out;
> -	}
> -
> -	/* Write the MIIM COMMAND register */
> -	cmd =3D MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
> -
> -	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
> -
> -	/* Wait while read operation via the MIIM controller is in progress */
> -	err =3D readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
> -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> -	if (err) {
> -		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
> -		goto out;
> -	}
> -
> -	val =3D ocelot_read(ocelot, GCB_MIIM_MII_DATA);
> -
> -	err =3D val & 0xFFFF;
> -out:
> -	return err;
> -}
> =20
>  /* CORE_ENA is in SYS:SYSTEM:RESET_CFG
>   * MEM_INIT is in SYS:SYSTEM:RESET_CFG
> @@ -1089,7 +1006,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *oc=
elot)
>  {
>  	struct felix *felix =3D ocelot_to_felix(ocelot);
>  	struct device *dev =3D ocelot->dev;
> -	struct mii_bus *bus;
>  	int port;
>  	int rc;
> =20
> @@ -1101,26 +1017,18 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *=
ocelot)
>  		return -ENOMEM;
>  	}
> =20
> -	bus =3D devm_mdiobus_alloc(dev);
> -	if (!bus)
> -		return -ENOMEM;
> -
> -	bus->name =3D "VSC9953 internal MDIO bus";
> -	bus->read =3D vsc9953_mdio_read;
> -	bus->write =3D vsc9953_mdio_write;
> -	bus->parent =3D dev;
> -	bus->priv =3D ocelot;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
> +	rc =3D felix_mdio_bus_alloc(ocelot);
> +	if (rc < 0) {
> +		dev_err(dev, "failed to allocate MDIO bus\n");
> +		return rc;
> +	}
> =20
> -	/* Needed in order to initialize the bus mutex lock */
> -	rc =3D of_mdiobus_register(bus, NULL);
> +	rc =3D felix_of_mdio_register(ocelot, NULL);
>  	if (rc < 0) {
>  		dev_err(dev, "failed to register MDIO bus\n");
>  		return rc;
>  	}
> =20
> -	felix->imdio =3D bus;
> -
>  	for (port =3D 0; port < felix->info->num_ports; port++) {
>  		struct ocelot_port *ocelot_port =3D ocelot->ports[port];
>  		int addr =3D port + 4;
> @@ -1165,7 +1073,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *oc=
elot)
>  		mdio_device_free(pcs->mdio);
>  		lynx_pcs_destroy(pcs);
>  	}
> -	mdiobus_unregister(felix->imdio);
> +	felix_mdio_bus_free(ocelot);
>  }
> =20
>  static const struct felix_info seville_info_vsc9953 =3D {
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-ms=
cc-miim.c
> index f55ad20c28d5..cf3fa7a4459c 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -10,6 +10,7 @@
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
> +#include <linux/mdio/mdio-mscc-miim.h>
>  #include <linux/module.h>
>  #include <linux/of_mdio.h>
>  #include <linux/phy.h>
> @@ -37,7 +38,9 @@
> =20
>  struct mscc_miim_dev {
>  	struct regmap *regs;
> +	int mii_status_offset;
>  	struct regmap *phy_regs;
> +	int phy_reset_offset;
>  };
> =20
>  /* When high resolution timers aren't built-in: we can't use usleep_rang=
e() as
> @@ -56,7 +59,8 @@ static int mscc_miim_status(struct mii_bus *bus)
>  	struct mscc_miim_dev *miim =3D bus->priv;
>  	int val, err;
> =20
> -	err =3D regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
> +	err =3D regmap_read(miim->regs,
> +			  MSCC_MIIM_REG_STATUS + miim->mii_status_offset, &val);
>  	if (err < 0)
>  		WARN_ONCE(1, "mscc miim status read error %d\n", err);
> =20
> @@ -91,7 +95,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_=
id, int regnum)
>  	if (ret)
>  		goto out;
> =20
> -	err =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +	err =3D regmap_write(miim->regs,
> +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> +			   MSCC_MIIM_CMD_VLD |
>  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
>  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
>  			   MSCC_MIIM_CMD_OPR_READ);
> @@ -103,7 +109,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mi=
i_id, int regnum)
>  	if (ret)
>  		goto out;
> =20
> -	err =3D regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> +	err =3D regmap_read(miim->regs,
> +			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);
> =20
>  	if (err < 0)
>  		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);
> @@ -128,7 +135,9 @@ static int mscc_miim_write(struct mii_bus *bus, int m=
ii_id,
>  	if (ret < 0)
>  		goto out;
> =20
> -	err =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +	err =3D regmap_write(miim->regs,
> +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> +			   MSCC_MIIM_CMD_VLD |
>  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
>  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
>  			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> @@ -143,14 +152,17 @@ static int mscc_miim_write(struct mii_bus *bus, int=
 mii_id,
>  static int mscc_miim_reset(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim =3D bus->priv;
> +	int offset =3D miim->phy_reset_offset;
>  	int err;
> =20
>  	if (miim->phy_regs) {
> -		err =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> +		err =3D regmap_write(miim->phy_regs,
> +				   MSCC_PHY_REG_PHY_CFG + offset, 0);
>  		if (err < 0)
>  			WARN_ONCE(1, "mscc reset set error %d\n", err);
> =20
> -		err =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> +		err =3D regmap_write(miim->phy_regs,
> +				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
>  		if (err < 0)
>  			WARN_ONCE(1, "mscc reset clear error %d\n", err);
> =20
> @@ -166,10 +178,12 @@ static const struct regmap_config mscc_miim_regmap_=
config =3D {
>  	.reg_stride	=3D 4,
>  };
> =20
> -static int mscc_miim_setup(struct device *dev, struct mii_bus *bus,
> -			   struct regmap *mii_regmap, struct regmap *phy_regmap)
> +int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> +		    struct regmap *mii_regmap, int status_offset,
> +		    struct regmap *phy_regmap, int reset_offset)
>  {
>  	struct mscc_miim_dev *miim;
> +	struct mii_bus *bus;
> =20
>  	bus =3D devm_mdiobus_alloc_size(dev, sizeof(*miim));
>  	if (!bus)
> @@ -185,10 +199,15 @@ static int mscc_miim_setup(struct device *dev, stru=
ct mii_bus *bus,
>  	miim =3D bus->priv;
> =20
>  	miim->regs =3D mii_regmap;
> +	miim->mii_status_offset =3D status_offset;
>  	miim->phy_regs =3D phy_regmap;
> +	miim->phy_reset_offset =3D reset_offset;
> +
> +	*pbus =3D bus;
> =20
>  	return 0;
>  }
> +EXPORT_SYMBOL(mscc_miim_setup);
> =20
>  static int mscc_miim_probe(struct platform_device *pdev)
>  {
> @@ -225,7 +244,7 @@ static int mscc_miim_probe(struct platform_device *pd=
ev)
>  		return PTR_ERR(dev->phy_regs);
>  	}
> =20
> -	mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
> +	mscc_miim_setup(&pdev->dev, &bus, mii_regmap, 0, phy_regmap, 0);
> =20
>  	ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
>  	if (ret < 0) {
> diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdi=
o-mscc-miim.h
> new file mode 100644
> index 000000000000..3ceab7b6ffc1
> --- /dev/null
> +++ b/include/linux/mdio/mdio-mscc-miim.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * Driver for the MDIO interface of Microsemi network switches.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + * Copyright (C) 2021 Innovative Advantage
> + */
> +#ifndef MDIO_MSCC_MIIM_H
> +#define MDIO_MSCC_MIIM_H
> +
> +#include <linux/device.h>
> +#include <linux/phy.h>
> +#include <linux/regmap.h>
> +
> +int mscc_miim_setup(struct device *device, struct mii_bus **bus,
> +		    struct regmap *mii_regmap, int status_offset,
> +		    struct regmap *phy_regmap, int reset_offset);
> +
> +#endif
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 89d17629efe5..9d6fe8ce9dd1 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -398,6 +398,7 @@ enum ocelot_reg {
>  	GCB_MIIM_MII_STATUS,
>  	GCB_MIIM_MII_CMD,
>  	GCB_MIIM_MII_DATA,
> +	GCB_PHY_PHY_CFG,
>  	DEV_CLOCK_CFG =3D DEV_GMII << TARGET_OFFSET,
>  	DEV_PORT_MISC,
>  	DEV_EVENTS,
> --=20
> 2.25.1
>=
