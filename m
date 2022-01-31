Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD54A4EE3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357622AbiAaSut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:50:49 -0500
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:23489
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232607AbiAaSur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:50:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj79xYGsVWLkLL//nwjCHgwWDU7bL572SA3ZXsRfeXQk3kQyB8FRtHdizRag5gUkdAurNShKPxVL02YYIQMvPTIZD/tN/1BmPvpy3PaE8pEzvKvkcVSvMe8myh9BN/fG/qFsEmJ7v8GKRhutxj+53rdjAiJFzWmhogGwL8qQ3RZClZbLrrTrQvzKNlLTIu7l6CrXznTFFXD/JmqLtflwwN/t5NEntFXbfze6GScPMdsZihI2jx7XffWHhAHjRsruVbccgck/T7PL4Q/iXfJ9X7pyXTMtew6BLmXDMTHPjarl1FAKu1QyedWAJOYvZaDXuj3r3mgm1zYS/LF2eTE5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfCPpgFe4hwHi2qMRVcQXKn4mrngQV0H/Jy4hlO0b8s=;
 b=JKU7egENlKFGub0pxaQuHkg+lA2GUuBnw4xlNMqMSoS2Rb1m0KMQa+BlF7JUSH02HA4QKRxZRCbRx7SBWeLO3eCCf/65cchqT1XN0xWviAA7NhESgE4QkQruP3cgm4bWFuiudhKJTmFs/HpWIK7Xio/wdzEIDSAKsfjcXW/EDxFFwJKCZ0Nw52zccdpuN/afh4fhVPfAxSjgjEHT7pGfKzgE8SrEbj9rqjtvYCnx7zSq1h7kyUhGvQV4jk+NKsQARyFW8LZVjlSPADsQdxWg5K3Bc1uZmL7BgSwrbVR63fxDBpg5bdbIM/u5j+GsMo3uO5uj5iIRBlAUF4uwgYRtTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfCPpgFe4hwHi2qMRVcQXKn4mrngQV0H/Jy4hlO0b8s=;
 b=e2IW7lnNbAM4doAelyop0CnbhVXrnpBQP9gbDWwqL28Ch+RZ3uBZu0tJqil7V7u5CCAdbxe8s0HdgMtBdPRDGZjv817OGBD5wFo85c1uNBPm041NO2F4uy0aTr70oi0dO2+3WamESC9bj5Epv+GuSfIrpG/80GNdQJWfAPwU++g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6231.eurprd04.prod.outlook.com (2603:10a6:20b:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Mon, 31 Jan
 2022 18:50:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 18:50:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 9/9] net: dsa: ocelot: add external ocelot
 switch control
Thread-Topic: [RFC v6 net-next 9/9] net: dsa: ocelot: add external ocelot
 switch control
Thread-Index: AQHYFVv2OFzTH6NzTEqZzYsfychF3ax9fC2A
Date:   Mon, 31 Jan 2022 18:50:44 +0000
Message-ID: <20220131185043.tbp6uhpcsvyoeglp@skbuf>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-10-colin.foster@in-advantage.com>
In-Reply-To: <20220129220221.2823127-10-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26245af8-55d5-43dd-3120-08d9e4ea9674
x-ms-traffictypediagnostic: AM6PR04MB6231:EE_
x-microsoft-antispam-prvs: <AM6PR04MB6231325A9B083CD4E359F5F3E0259@AM6PR04MB6231.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDidQHfZ3PwkMv9MdwoMoIwdx8wT33PWoUzcF3FZCHPyI+++xVlj6DRcO6C2AKvmpxA/MUxxkXSckFyIUTyWs+uYfImNyqL1QWJTGgfxsUlPekkrZ8E5uNm5wB6sfFIUWUNCIj9gTHXD96rqWH5X+2rwvO442SJ5tNETKOrB1h+fjjC0/NJYMYhK8SSlRp6clY835X3rV16Vnc2FZx4WS5zB+UM9KKt9Oov8AcTH/E1/zXAwZXJ1y/x2kUgO7y1QC/VECZpyYAcaFXNDjLNHJWrwl0N+Q1mVJTzh1jf6MF3nxv+h6gpxtlyD1TYmjZHslH1KRzN0bxJ3jUm9IRf/z3QgxDR5hEbHCGlCP22Dr4CqlF+uLmqHt5XX/fav9SSGwawb1JdkQgirJE3cEf4tDcO+jqlhnKBh8Lr00zjmvpOnYaQmTzP+mw7MQXB+qKk0Q1V47UqrPG2hwwVHhqbyTQdf/yAk7xu6UkB4Yv1+AF65akKCN3cV8WoCo5byS9Bu/Sny+jOyCtQRUS2iMdKsDMxe9sqZvn5s7xVuQMt3gxLI2WK8Esu8ufgVqkg6lTzxOvhEg4L6erxzIPJoVlnzBvIYKNYfEQuM6gLYFlupz+1vzlbKk4oM/d0bctpY6UKbEYfOxTvTxx4F99PZpVN/Sj/JGJ9CNYEXr7OTavUYdm1yLIH+mZEstVVcjjR7G2vxefQyjC8nRIJv4UYAh0Eovw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(86362001)(91956017)(66556008)(83380400001)(66476007)(66946007)(66446008)(38070700005)(76116006)(64756008)(122000001)(2906002)(5660300002)(4326008)(8936002)(8676002)(6512007)(186003)(30864003)(7416002)(9686003)(6486002)(33716001)(54906003)(6916009)(44832011)(6506007)(71200400001)(38100700002)(508600001)(1076003)(26005)(316002)(579004)(559001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kzHJXwIgJQpzMtCwG0ZI+0bFt1v4gH8wUJwnFvFsKQc42lC4DgMsLLwosqow?=
 =?us-ascii?Q?HNoEvvXg/z4DCkzPM8VleOG8u+YIV50uQTlx34xZ3iIIH7DGoOqNVV2DNNxv?=
 =?us-ascii?Q?y+LIvZzk/BYnkhWOJnshnMYIoWjE1cCl19N3xcpBOdZwD7ILENxFrpZanXuI?=
 =?us-ascii?Q?sidexwgH7oQ4EF75DBLvogUOQjc13tKQvpyz6UvBFHSUsN4yPLgJXK9ZM53E?=
 =?us-ascii?Q?t13Akx4Mah7XZUMvV9W4JF+1qyCe33mGco7vIBjrlOihxuEtbGM+mvAiJ6oM?=
 =?us-ascii?Q?ACN7uzh6nAaEQpmWV/zm/Yr/ZMi6nR+vA8taS5Z9FRGVV5k30MBxA6Xq6Wgx?=
 =?us-ascii?Q?ZMpHfy5xpwUois2Huqu/deRVZt/rp0Q3ZiBwsU2qXRDH+UZsaot3HtyLe9cH?=
 =?us-ascii?Q?pHaVC92OCWIaJOh401lsjqmgG/DKXpXULiOpSkkO4f62XnyZKl9ykz2Bsd72?=
 =?us-ascii?Q?N7kKO+9eoG9unitF/nt2VASe7teePVlEsL/pYdtnuLrmdIVRUjCSynXDM5TN?=
 =?us-ascii?Q?84+Pg6XtD33JepC2hzx9g7tN2D7JoSHyt9i6IK0x2OfzVa8I2DNc2XP5SJDp?=
 =?us-ascii?Q?OGzS9Qzh7uP6tjRfWoUxOeUHbXqualXf49bkmtLbXYYKYnl1BJFSFU24vk7B?=
 =?us-ascii?Q?wadQ6p/ojaRlkCOte5kse0FINMm5jNRQH9+FLpkdOb6qKQyMW2ByBsUOBZLv?=
 =?us-ascii?Q?CCjLrx1010mPBBfwfAy8l15Dvz3TbZfw0OK+Vj95M2pQOiflu5EdjhkCSsH3?=
 =?us-ascii?Q?m3jNQ1T9cJ+nMjkNuDduTgMyNPYWAAej7632IJ53u6v3cGzbMzHOhMwJYmic?=
 =?us-ascii?Q?viD9GQzk612f+RsUjDAWkxk0E+BA2mic+jiIqfj8+p+dRDIWfyU0c6eKbsff?=
 =?us-ascii?Q?zFnHn67Awm9k3DU+vnLWDqmuidNhqDKGrgk2OWMlC7m0NK9U2e+kjkjx7m6a?=
 =?us-ascii?Q?t3c6R6XHB0aHEIfsGk6k3iNWhLAi/3yRbwhs+nIRdL8PHTj0f6N/dya8RzxL?=
 =?us-ascii?Q?fiXNE6uFI6oFqPLqSjz3FHUPEIXKgTsaXo3cz8gg80LJVhJU7MCuxZ7cK9ly?=
 =?us-ascii?Q?LQtWkQzaUJczvpDMsG4MEwq05PzWZGsAzoExCGb7N4bKRButd+qSR/m63RDi?=
 =?us-ascii?Q?isNYWtTrtWyK/gqSjk4BtTJg0K8+Gl+fs2N3qzLDlMh64vD2XqblCQrsEUA8?=
 =?us-ascii?Q?aP4lEjPbj1O7JE9kkGjHyx9sxFMhY6+zIINCWYSyiLCDTKtSEBWvT900r0m7?=
 =?us-ascii?Q?1EU2q9Qc1p4mAEI1EYAQPRzdnkMdWalPgTxcRRzVDFXJtBrdiYx4UR3WYtge?=
 =?us-ascii?Q?eyBbodEo7Hy6/Z3DPMb7jb0hg2hz6rpvK5noQ3yC/mXyFCNDXOfjvgDYnMEk?=
 =?us-ascii?Q?iYGdi16yrV6qD1jG7z0tmIokPch5432jhnXmk4xWZXCsaHa/T/5FSjeG8YWB?=
 =?us-ascii?Q?+sMp01LIhniqi0TO1WmWPG2lzsa4BgVEs9mgkNYc4dr4KM2v5Ef2MYjwSXuu?=
 =?us-ascii?Q?4uZWYrPPDg2T1iYCuHlkP/OiibTMatubnkLV7pGr5+42s9jOGsM1DJP5OPq9?=
 =?us-ascii?Q?NSg5ofnItphbjEBgwqIfaLqCX78TQKTtxbjCNlSj/S5QMrO4MzubckgZWXIx?=
 =?us-ascii?Q?czMqte1Z/Nsd8/mmF2lmPnM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1B9958DE9DA73246A3B5DAFFCB83EE77@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26245af8-55d5-43dd-3120-08d9e4ea9674
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 18:50:44.6063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/CWgSgrxuWxkc50+mD3L6ljHHA4XVP5A6BvqsDADgi9+J9oxglKbhN2jSZbohQDzCMwtiJ7UyR5V1b8dG276w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6231
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 02:02:21PM -0800, Colin Foster wrote:
> Add control of an external VSC7512 chip by way of the ocelot-mfd interfac=
e.
>=20
> Currently the four copper phy ports are fully functional. Communication t=
o
> external phys is also functional, but the SGMII / QSGMII interfaces are
> currently non-functional.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/ocelot-core.c           |   4 +
>  drivers/net/dsa/ocelot/Kconfig      |  14 +
>  drivers/net/dsa/ocelot/Makefile     |   5 +
>  drivers/net/dsa/ocelot/ocelot_ext.c | 681 ++++++++++++++++++++++++++++
>  include/soc/mscc/ocelot.h           |   2 +
>  5 files changed, 706 insertions(+)
>  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
>=20
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index 590489481b8c..17a77d618e92 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -122,6 +122,10 @@ static const struct mfd_cell vsc7512_devs[] =3D {
>  		.num_resources =3D ARRAY_SIZE(vsc7512_miim1_resources),
>  		.resources =3D vsc7512_miim1_resources,
>  	},
> +	{
> +		.name =3D "ocelot-ext-switch",
> +		.of_compatible =3D "mscc,vsc7512-ext-switch",
> +	},
>  };
> =20
>  int ocelot_core_init(struct ocelot_core *core)
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kcon=
fig
> index 220b0b027b55..f40b2c7171ad 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -1,4 +1,18 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +config NET_DSA_MSCC_OCELOT_EXT
> +	tristate "Ocelot External Ethernet switch support"
> +	depends on NET_DSA && SPI
> +	depends on NET_VENDOR_MICROSEMI
> +	select MDIO_MSCC_MIIM
> +	select MFD_OCELOT_CORE
> +	select MSCC_OCELOT_SWITCH_LIB
> +	select NET_DSA_TAG_OCELOT_8021Q
> +	select NET_DSA_TAG_OCELOT
> +	help
> +	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
> +	  when controlled through SPI. It can be used with the Microsemi dev
> +	  boards and an external CPU or custom hardware.
> +
>  config NET_DSA_MSCC_FELIX
>  	tristate "Ocelot / Felix Ethernet switch support"
>  	depends on NET_DSA && PCI
> diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Mak=
efile
> index f6dd131e7491..d7f3f5a4461c 100644
> --- a/drivers/net/dsa/ocelot/Makefile
> +++ b/drivers/net/dsa/ocelot/Makefile
> @@ -1,11 +1,16 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NET_DSA_MSCC_FELIX) +=3D mscc_felix.o
> +obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) +=3D mscc_ocelot_ext.o
>  obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) +=3D mscc_seville.o
> =20
>  mscc_felix-objs :=3D \
>  	felix.o \
>  	felix_vsc9959.o
> =20
> +mscc_ocelot_ext-objs :=3D \
> +	felix.o \
> +	ocelot_ext.o
> +
>  mscc_seville-objs :=3D \
>  	felix.o \
>  	seville_vsc9953.o
> diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot=
/ocelot_ext.c
> new file mode 100644
> index 000000000000..6fdff016673e
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/ocelot_ext.c

How about ocelot_vsc7512.c for a name?

> @@ -0,0 +1,681 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Copyright 2021 Innovative Advantage Inc.
> + */
> +
> +#include <asm/byteorder.h>
> +#include <linux/iopoll.h>
> +#include <linux/kconfig.h>
> +#include <linux/mdio/mdio-mscc-miim.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phylink.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <soc/mscc/ocelot_ana.h>
> +#include <soc/mscc/ocelot_dev.h>
> +#include <soc/mscc/ocelot_qsys.h>
> +#include <soc/mscc/ocelot_vcap.h>
> +#include <soc/mscc/ocelot_ptp.h>
> +#include <soc/mscc/ocelot_sys.h>
> +#include <soc/mscc/ocelot.h>
> +#include <soc/mscc/vsc7514_regs.h>
> +#include "felix.h"
> +
> +#define VSC7512_NUM_PORTS		11
> +
> +#define OCELOT_SPI_PORT_MODE_INTERNAL	(1 << 0)
> +#define OCELOT_SPI_PORT_MODE_SGMII	(1 << 1)
> +#define OCELOT_SPI_PORT_MODE_QSGMII	(1 << 2)
> +
> +const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] =3D {

missing "static"?

> +	OCELOT_SPI_PORT_MODE_INTERNAL,

Why is "_SPI_" in the name?

> +	OCELOT_SPI_PORT_MODE_INTERNAL,
> +	OCELOT_SPI_PORT_MODE_INTERNAL,
> +	OCELOT_SPI_PORT_MODE_INTERNAL,
> +	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
> +	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
> +	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
> +	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
> +	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
> +	OCELOT_SPI_PORT_MODE_SGMII,
> +	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
> +};
> +
> +struct ocelot_ext_data {
> +	struct felix felix;
> +	const u32 *port_modes;
> +};

I don't mind at all if you extend/generalize the pre-validation to all
Felix drivers and put "port_modes" inside struct felix_info.

felix_vsc9959.c would be:

#define VSC9959_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
					 OCELOT_PORT_MODE_QSGMII | \
					 OCELOT_PORT_MODE_2500BASEX | \
					 OCELOT_PORT_MODE_USXGMII)

static const u32 vsc9959_port_modes[] =3D {
	VSC9959_PORT_MODE_SERDES,
	VSC9959_PORT_MODE_SERDES,
	VSC9959_PORT_MODE_SERDES,
	VSC9959_PORT_MODE_SERDES,
	OCELOT_PORT_MODE_INTERNAL,
	OCELOT_PORT_MODE_INTERNAL,
};

seville_vsc9953.c would be:

#define VSC9953_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
					 OCELOT_PORT_MODE_QSGMII)

static const u32 vsc9959_port_modes[] =3D {
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	VSC9953_PORT_MODE_SERDES,
	OCELOT_PORT_MODE_INTERNAL,
	OCELOT_PORT_MODE_INTERNAL,
};

and no more felix_info :: prevalidate_phy_mode function pointer.

> +
> +static const u32 vsc7512_gcb_regmap[] =3D {
> +	REG(GCB_SOFT_RST,			0x0008),
> +	REG(GCB_MIIM_MII_STATUS,		0x009c),
> +	REG(GCB_PHY_PHY_CFG,			0x00f0),
> +	REG(GCB_PHY_PHY_STAT,			0x00f4),
> +};
> +
> +static const u32 *vsc7512_regmap[TARGET_MAX] =3D {
> +	[ANA] =3D vsc7514_ana_regmap,
> +	[QS] =3D vsc7514_qs_regmap,
> +	[QSYS] =3D vsc7514_qsys_regmap,
> +	[REW] =3D vsc7514_rew_regmap,
> +	[SYS] =3D vsc7514_sys_regmap,
> +	[S0] =3D vsc7514_vcap_regmap,
> +	[S1] =3D vsc7514_vcap_regmap,
> +	[S2] =3D vsc7514_vcap_regmap,
> +	[PTP] =3D vsc7514_ptp_regmap,
> +	[GCB] =3D vsc7512_gcb_regmap,
> +	[DEV_GMII] =3D vsc7514_dev_gmii_regmap,
> +};
> +
> +#define VSC7512_BYTE_ORDER_LE 0x00000000
> +#define VSC7512_BYTE_ORDER_BE 0x81818181
> +#define VSC7512_BIT_ORDER_MSB 0x00000000
> +#define VSC7512_BIT_ORDER_LSB 0x42424242

Unused.

> +
> +static struct ocelot_ext_data *felix_to_ocelot_ext(struct felix *felix)
> +{
> +	return container_of(felix, struct ocelot_ext_data, felix);
> +}
> +
> +static struct ocelot_ext_data *ocelot_to_ocelot_ext(struct ocelot *ocelo=
t)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +
> +	return felix_to_ocelot_ext(felix);
> +}

I wouldn't mind a "ds_to_felix()" helper, but as mentioned, it would be
good if you could use struct felix instead of introducing yet one more
container.

> +
> +static void ocelot_ext_reset_phys(struct ocelot *ocelot)
> +{
> +	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
> +	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
> +	mdelay(500);
> +}
> +
> +static int ocelot_ext_reset(struct ocelot *ocelot)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	struct device *dev =3D ocelot->dev;
> +	struct device_node *mdio_node;
> +	int retries =3D 100;
> +	int err, val;
> +
> +	ocelot_ext_reset_phys(ocelot);
> +
> +	mdio_node =3D of_get_child_by_name(dev->of_node, "mdio");

 * Return: A node pointer if found, with refcount incremented, use
 * of_node_put() on it when done.

There's no "of_node_put()" below.

> +	if (!mdio_node)
> +		dev_info(ocelot->dev,
> +			 "mdio children not found in device tree\n");
> +
> +	err =3D of_mdiobus_register(felix->imdio, mdio_node);
> +	if (err) {
> +		dev_err(ocelot->dev, "error registering MDIO bus\n");
> +		return err;
> +	}
> +
> +	felix->ds->slave_mii_bus =3D felix->imdio;

A bit surprised to see MDIO bus registration in ocelot_ops :: reset and
not in felix_info :: mdio_bus_alloc.

> +
> +	/* We might need to reset the switch core here, if that is possible */
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1=
);
> +	if (err)

of_mdiobus_register() needs mdiobus_unregister() on error.

> +		return err;
> +
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1)=
;
> +	if (err)
> +		return err;
> +
> +	do {
> +		msleep(1);
> +		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> +				  &val);
> +	} while (val && --retries);
> +
> +	if (!retries)
> +		return -ETIMEDOUT;
> +
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1=
);
> +
> +	return err;

"err =3D ...; return err" can be turned into "return ..." if it weren't
for error handling. But you need to handle errors.

> +}
> +
> +static u32 ocelot_offset_from_reg_base(struct ocelot *ocelot, u32 target=
,
> +				       u32 reg)
> +{
> +	return ocelot->map[target][reg & REG_MASK];
> +}
> +
> +static const struct ocelot_ops vsc7512_ops =3D {
> +	.reset		=3D ocelot_ext_reset,
> +	.wm_enc		=3D ocelot_wm_enc,
> +	.wm_dec		=3D ocelot_wm_dec,
> +	.wm_stat	=3D ocelot_wm_stat,
> +	.port_to_netdev	=3D felix_port_to_netdev,
> +	.netdev_to_port	=3D felix_netdev_to_port,
> +};
> +
> +static const struct resource vsc7512_target_io_res[TARGET_MAX] =3D {
> +	[ANA] =3D {
> +		.start	=3D 0x71880000,
> +		.end	=3D 0x7188ffff,
> +		.name	=3D "ana",
> +	},
> +	[QS] =3D {
> +		.start	=3D 0x71080000,
> +		.end	=3D 0x710800ff,
> +		.name	=3D "qs",
> +	},
> +	[QSYS] =3D {
> +		.start	=3D 0x71800000,
> +		.end	=3D 0x719fffff,
> +		.name	=3D "qsys",
> +	},
> +	[REW] =3D {
> +		.start	=3D 0x71030000,
> +		.end	=3D 0x7103ffff,
> +		.name	=3D "rew",
> +	},
> +	[SYS] =3D {
> +		.start	=3D 0x71010000,
> +		.end	=3D 0x7101ffff,
> +		.name	=3D "sys",
> +	},
> +	[S0] =3D {
> +		.start	=3D 0x71040000,
> +		.end	=3D 0x710403ff,
> +		.name	=3D "s0",
> +	},
> +	[S1] =3D {
> +		.start	=3D 0x71050000,
> +		.end	=3D 0x710503ff,
> +		.name	=3D "s1",
> +	},
> +	[S2] =3D {
> +		.start	=3D 0x71060000,
> +		.end	=3D 0x710603ff,
> +		.name	=3D "s2",
> +	},
> +	[GCB] =3D	{
> +		.start	=3D 0x71070000,
> +		.end	=3D 0x7107022b,
> +		.name	=3D "devcpu_gcb",
> +	},
> +};
> +
> +static const struct resource vsc7512_port_io_res[] =3D {
> +	{
> +		.start	=3D 0x711e0000,
> +		.end	=3D 0x711effff,
> +		.name	=3D "port0",
> +	},
> +	{
> +		.start	=3D 0x711f0000,
> +		.end	=3D 0x711fffff,
> +		.name	=3D "port1",
> +	},
> +	{
> +		.start	=3D 0x71200000,
> +		.end	=3D 0x7120ffff,
> +		.name	=3D "port2",
> +	},
> +	{
> +		.start	=3D 0x71210000,
> +		.end	=3D 0x7121ffff,
> +		.name	=3D "port3",
> +	},
> +	{
> +		.start	=3D 0x71220000,
> +		.end	=3D 0x7122ffff,
> +		.name	=3D "port4",
> +	},
> +	{
> +		.start	=3D 0x71230000,
> +		.end	=3D 0x7123ffff,
> +		.name	=3D "port5",
> +	},
> +	{
> +		.start	=3D 0x71240000,
> +		.end	=3D 0x7124ffff,
> +		.name	=3D "port6",
> +	},
> +	{
> +		.start	=3D 0x71250000,
> +		.end	=3D 0x7125ffff,
> +		.name	=3D "port7",
> +	},
> +	{
> +		.start	=3D 0x71260000,
> +		.end	=3D 0x7126ffff,
> +		.name	=3D "port8",
> +	},
> +	{
> +		.start	=3D 0x71270000,
> +		.end	=3D 0x7127ffff,
> +		.name	=3D "port9",
> +	},
> +	{
> +		.start	=3D 0x71280000,
> +		.end	=3D 0x7128ffff,
> +		.name	=3D "port10",
> +	},
> +};
> +
> +static const struct reg_field vsc7512_regfields[REGFIELD_MAX] =3D {
> +	[ANA_ADVLEARN_VLAN_CHK] =3D REG_FIELD(ANA_ADVLEARN, 11, 11),
> +	[ANA_ADVLEARN_LEARN_MIRROR] =3D REG_FIELD(ANA_ADVLEARN, 0, 10),
> +	[ANA_ANEVENTS_MSTI_DROP] =3D REG_FIELD(ANA_ANEVENTS, 27, 27),
> +	[ANA_ANEVENTS_ACLKILL] =3D REG_FIELD(ANA_ANEVENTS, 26, 26),
> +	[ANA_ANEVENTS_ACLUSED] =3D REG_FIELD(ANA_ANEVENTS, 25, 25),
> +	[ANA_ANEVENTS_AUTOAGE] =3D REG_FIELD(ANA_ANEVENTS, 24, 24),
> +	[ANA_ANEVENTS_VS2TTL1] =3D REG_FIELD(ANA_ANEVENTS, 23, 23),
> +	[ANA_ANEVENTS_STORM_DROP] =3D REG_FIELD(ANA_ANEVENTS, 22, 22),
> +	[ANA_ANEVENTS_LEARN_DROP] =3D REG_FIELD(ANA_ANEVENTS, 21, 21),
> +	[ANA_ANEVENTS_AGED_ENTRY] =3D REG_FIELD(ANA_ANEVENTS, 20, 20),
> +	[ANA_ANEVENTS_CPU_LEARN_FAILED] =3D REG_FIELD(ANA_ANEVENTS, 19, 19),
> +	[ANA_ANEVENTS_AUTO_LEARN_FAILED] =3D REG_FIELD(ANA_ANEVENTS, 18, 18),
> +	[ANA_ANEVENTS_LEARN_REMOVE] =3D REG_FIELD(ANA_ANEVENTS, 17, 17),
> +	[ANA_ANEVENTS_AUTO_LEARNED] =3D REG_FIELD(ANA_ANEVENTS, 16, 16),
> +	[ANA_ANEVENTS_AUTO_MOVED] =3D REG_FIELD(ANA_ANEVENTS, 15, 15),
> +	[ANA_ANEVENTS_DROPPED] =3D REG_FIELD(ANA_ANEVENTS, 14, 14),
> +	[ANA_ANEVENTS_CLASSIFIED_DROP] =3D REG_FIELD(ANA_ANEVENTS, 13, 13),
> +	[ANA_ANEVENTS_CLASSIFIED_COPY] =3D REG_FIELD(ANA_ANEVENTS, 12, 12),
> +	[ANA_ANEVENTS_VLAN_DISCARD] =3D REG_FIELD(ANA_ANEVENTS, 11, 11),
> +	[ANA_ANEVENTS_FWD_DISCARD] =3D REG_FIELD(ANA_ANEVENTS, 10, 10),
> +	[ANA_ANEVENTS_MULTICAST_FLOOD] =3D REG_FIELD(ANA_ANEVENTS, 9, 9),
> +	[ANA_ANEVENTS_UNICAST_FLOOD] =3D REG_FIELD(ANA_ANEVENTS, 8, 8),
> +	[ANA_ANEVENTS_DEST_KNOWN] =3D REG_FIELD(ANA_ANEVENTS, 7, 7),
> +	[ANA_ANEVENTS_BUCKET3_MATCH] =3D REG_FIELD(ANA_ANEVENTS, 6, 6),
> +	[ANA_ANEVENTS_BUCKET2_MATCH] =3D REG_FIELD(ANA_ANEVENTS, 5, 5),
> +	[ANA_ANEVENTS_BUCKET1_MATCH] =3D REG_FIELD(ANA_ANEVENTS, 4, 4),
> +	[ANA_ANEVENTS_BUCKET0_MATCH] =3D REG_FIELD(ANA_ANEVENTS, 3, 3),
> +	[ANA_ANEVENTS_CPU_OPERATION] =3D REG_FIELD(ANA_ANEVENTS, 2, 2),
> +	[ANA_ANEVENTS_DMAC_LOOKUP] =3D REG_FIELD(ANA_ANEVENTS, 1, 1),
> +	[ANA_ANEVENTS_SMAC_LOOKUP] =3D REG_FIELD(ANA_ANEVENTS, 0, 0),
> +	[ANA_TABLES_MACACCESS_B_DOM] =3D REG_FIELD(ANA_TABLES_MACACCESS, 18, 18=
),
> +	[ANA_TABLES_MACTINDX_BUCKET] =3D REG_FIELD(ANA_TABLES_MACTINDX, 10, 11)=
,
> +	[ANA_TABLES_MACTINDX_M_INDEX] =3D REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
> +	[GCB_SOFT_RST_SWC_RST] =3D REG_FIELD(GCB_SOFT_RST, 1, 1),
> +	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] =3D REG_FIELD(QSYS_TIMED_FRAME_ENTRY,=
 20, 20),
> +	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] =3D REG_FIELD(QSYS_TIMED_FRAME_ENTRY, =
8, 19),
> +	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] =3D REG_FIELD(QSYS_TIMED_FRAME_ENT=
RY, 4, 7),
> +	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] =3D REG_FIELD(QSYS_TIMED_FRAME_ENT=
RY, 1, 3),
> +	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] =3D REG_FIELD(QSYS_TIMED_FRAME_ENTRY=
, 0, 0),
> +	[SYS_RESET_CFG_CORE_ENA] =3D REG_FIELD(SYS_RESET_CFG, 2, 2),
> +	[SYS_RESET_CFG_MEM_ENA] =3D REG_FIELD(SYS_RESET_CFG, 1, 1),
> +	[SYS_RESET_CFG_MEM_INIT] =3D REG_FIELD(SYS_RESET_CFG, 0, 0),
> +	/* Replicated per number of ports (12), register size 4 per port */
> +	[QSYS_SWITCH_PORT_MODE_PORT_ENA] =3D REG_FIELD_ID(QSYS_SWITCH_PORT_MODE=
, 14, 14, 12, 4),
> +	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] =3D REG_FIELD_ID(QSYS_SWITCH_PORT_=
MODE, 11, 13, 12, 4),
> +	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] =3D REG_FIELD_ID(QSYS_SWITCH_PORT_MOD=
E, 10, 10, 12, 4),
> +	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] =3D REG_FIELD_ID(QSYS_SWITCH_=
PORT_MODE, 9, 9, 12, 4),
> +	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] =3D REG_FIELD_ID(QSYS_SWITCH_PORT_MO=
DE, 1, 8, 12, 4),
> +	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] =3D REG_FIELD_ID(QSYS_SWITCH_PORT_M=
ODE, 0, 0, 12, 4),
> +	[SYS_PORT_MODE_DATA_WO_TS] =3D REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4)=
,
> +	[SYS_PORT_MODE_INCL_INJ_HDR] =3D REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, =
4),
> +	[SYS_PORT_MODE_INCL_XTR_HDR] =3D REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, =
4),
> +	[SYS_PORT_MODE_INCL_HDR_ERR] =3D REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, =
4),
> +	[SYS_PAUSE_CFG_PAUSE_START] =3D REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12,=
 4),
> +	[SYS_PAUSE_CFG_PAUSE_STOP] =3D REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4)=
,
> +	[SYS_PAUSE_CFG_PAUSE_ENA] =3D REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
> +};
> +
> +static const struct ocelot_stat_layout vsc7512_stats_layout[] =3D {
> +	{ .offset =3D 0x00,	.name =3D "rx_octets", },
> +	{ .offset =3D 0x01,	.name =3D "rx_unicast", },
> +	{ .offset =3D 0x02,	.name =3D "rx_multicast", },
> +	{ .offset =3D 0x03,	.name =3D "rx_broadcast", },
> +	{ .offset =3D 0x04,	.name =3D "rx_shorts", },
> +	{ .offset =3D 0x05,	.name =3D "rx_fragments", },
> +	{ .offset =3D 0x06,	.name =3D "rx_jabbers", },
> +	{ .offset =3D 0x07,	.name =3D "rx_crc_align_errs", },
> +	{ .offset =3D 0x08,	.name =3D "rx_sym_errs", },
> +	{ .offset =3D 0x09,	.name =3D "rx_frames_below_65_octets", },
> +	{ .offset =3D 0x0A,	.name =3D "rx_frames_65_to_127_octets", },
> +	{ .offset =3D 0x0B,	.name =3D "rx_frames_128_to_255_octets", },
> +	{ .offset =3D 0x0C,	.name =3D "rx_frames_256_to_511_octets", },
> +	{ .offset =3D 0x0D,	.name =3D "rx_frames_512_to_1023_octets", },
> +	{ .offset =3D 0x0E,	.name =3D "rx_frames_1024_to_1526_octets", },
> +	{ .offset =3D 0x0F,	.name =3D "rx_frames_over_1526_octets", },
> +	{ .offset =3D 0x10,	.name =3D "rx_pause", },
> +	{ .offset =3D 0x11,	.name =3D "rx_control", },
> +	{ .offset =3D 0x12,	.name =3D "rx_longs", },
> +	{ .offset =3D 0x13,	.name =3D "rx_classified_drops", },
> +	{ .offset =3D 0x14,	.name =3D "rx_red_prio_0", },
> +	{ .offset =3D 0x15,	.name =3D "rx_red_prio_1", },
> +	{ .offset =3D 0x16,	.name =3D "rx_red_prio_2", },
> +	{ .offset =3D 0x17,	.name =3D "rx_red_prio_3", },
> +	{ .offset =3D 0x18,	.name =3D "rx_red_prio_4", },
> +	{ .offset =3D 0x19,	.name =3D "rx_red_prio_5", },
> +	{ .offset =3D 0x1A,	.name =3D "rx_red_prio_6", },
> +	{ .offset =3D 0x1B,	.name =3D "rx_red_prio_7", },
> +	{ .offset =3D 0x1C,	.name =3D "rx_yellow_prio_0", },
> +	{ .offset =3D 0x1D,	.name =3D "rx_yellow_prio_1", },
> +	{ .offset =3D 0x1E,	.name =3D "rx_yellow_prio_2", },
> +	{ .offset =3D 0x1F,	.name =3D "rx_yellow_prio_3", },
> +	{ .offset =3D 0x20,	.name =3D "rx_yellow_prio_4", },
> +	{ .offset =3D 0x21,	.name =3D "rx_yellow_prio_5", },
> +	{ .offset =3D 0x22,	.name =3D "rx_yellow_prio_6", },
> +	{ .offset =3D 0x23,	.name =3D "rx_yellow_prio_7", },
> +	{ .offset =3D 0x24,	.name =3D "rx_green_prio_0", },
> +	{ .offset =3D 0x25,	.name =3D "rx_green_prio_1", },
> +	{ .offset =3D 0x26,	.name =3D "rx_green_prio_2", },
> +	{ .offset =3D 0x27,	.name =3D "rx_green_prio_3", },
> +	{ .offset =3D 0x28,	.name =3D "rx_green_prio_4", },
> +	{ .offset =3D 0x29,	.name =3D "rx_green_prio_5", },
> +	{ .offset =3D 0x2A,	.name =3D "rx_green_prio_6", },
> +	{ .offset =3D 0x2B,	.name =3D "rx_green_prio_7", },
> +	{ .offset =3D 0x40,	.name =3D "tx_octets", },
> +	{ .offset =3D 0x41,	.name =3D "tx_unicast", },
> +	{ .offset =3D 0x42,	.name =3D "tx_multicast", },
> +	{ .offset =3D 0x43,	.name =3D "tx_broadcast", },
> +	{ .offset =3D 0x44,	.name =3D "tx_collision", },
> +	{ .offset =3D 0x45,	.name =3D "tx_drops", },
> +	{ .offset =3D 0x46,	.name =3D "tx_pause", },
> +	{ .offset =3D 0x47,	.name =3D "tx_frames_below_65_octets", },
> +	{ .offset =3D 0x48,	.name =3D "tx_frames_65_to_127_octets", },
> +	{ .offset =3D 0x49,	.name =3D "tx_frames_128_255_octets", },
> +	{ .offset =3D 0x4A,	.name =3D "tx_frames_256_511_octets", },
> +	{ .offset =3D 0x4B,	.name =3D "tx_frames_512_1023_octets", },
> +	{ .offset =3D 0x4C,	.name =3D "tx_frames_1024_1526_octets", },
> +	{ .offset =3D 0x4D,	.name =3D "tx_frames_over_1526_octets", },
> +	{ .offset =3D 0x4E,	.name =3D "tx_yellow_prio_0", },
> +	{ .offset =3D 0x4F,	.name =3D "tx_yellow_prio_1", },
> +	{ .offset =3D 0x50,	.name =3D "tx_yellow_prio_2", },
> +	{ .offset =3D 0x51,	.name =3D "tx_yellow_prio_3", },
> +	{ .offset =3D 0x52,	.name =3D "tx_yellow_prio_4", },
> +	{ .offset =3D 0x53,	.name =3D "tx_yellow_prio_5", },
> +	{ .offset =3D 0x54,	.name =3D "tx_yellow_prio_6", },
> +	{ .offset =3D 0x55,	.name =3D "tx_yellow_prio_7", },
> +	{ .offset =3D 0x56,	.name =3D "tx_green_prio_0", },
> +	{ .offset =3D 0x57,	.name =3D "tx_green_prio_1", },
> +	{ .offset =3D 0x58,	.name =3D "tx_green_prio_2", },
> +	{ .offset =3D 0x59,	.name =3D "tx_green_prio_3", },
> +	{ .offset =3D 0x5A,	.name =3D "tx_green_prio_4", },
> +	{ .offset =3D 0x5B,	.name =3D "tx_green_prio_5", },
> +	{ .offset =3D 0x5C,	.name =3D "tx_green_prio_6", },
> +	{ .offset =3D 0x5D,	.name =3D "tx_green_prio_7", },
> +	{ .offset =3D 0x5E,	.name =3D "tx_aged", },
> +	{ .offset =3D 0x80,	.name =3D "drop_local", },
> +	{ .offset =3D 0x81,	.name =3D "drop_tail", },
> +	{ .offset =3D 0x82,	.name =3D "drop_yellow_prio_0", },
> +	{ .offset =3D 0x83,	.name =3D "drop_yellow_prio_1", },
> +	{ .offset =3D 0x84,	.name =3D "drop_yellow_prio_2", },
> +	{ .offset =3D 0x85,	.name =3D "drop_yellow_prio_3", },
> +	{ .offset =3D 0x86,	.name =3D "drop_yellow_prio_4", },
> +	{ .offset =3D 0x87,	.name =3D "drop_yellow_prio_5", },
> +	{ .offset =3D 0x88,	.name =3D "drop_yellow_prio_6", },
> +	{ .offset =3D 0x89,	.name =3D "drop_yellow_prio_7", },
> +	{ .offset =3D 0x8A,	.name =3D "drop_green_prio_0", },
> +	{ .offset =3D 0x8B,	.name =3D "drop_green_prio_1", },
> +	{ .offset =3D 0x8C,	.name =3D "drop_green_prio_2", },
> +	{ .offset =3D 0x8D,	.name =3D "drop_green_prio_3", },
> +	{ .offset =3D 0x8E,	.name =3D "drop_green_prio_4", },
> +	{ .offset =3D 0x8F,	.name =3D "drop_green_prio_5", },
> +	{ .offset =3D 0x90,	.name =3D "drop_green_prio_6", },
> +	{ .offset =3D 0x91,	.name =3D "drop_green_prio_7", },
> +};
> +
> +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> +				     unsigned long *supported,
> +				     struct phylink_link_state *state)
> +{
> +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> +
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> +
> +	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> +	    state->interface !=3D ocelot_port->phy_mode) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> +
> +	phylink_set_port_modes(mask);
> +
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, Asym_Pause);
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +	phylink_set(mask, 1000baseT_Half);
> +	phylink_set(mask, 1000baseT_Full);
> +
> +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
> +static int vsc7512_prevalidate_phy_mode(struct ocelot *ocelot, int port,
> +					phy_interface_t phy_mode)
> +{
> +	struct ocelot_ext_data *ocelot_ext =3D ocelot_to_ocelot_ext(ocelot);
> +
> +	switch (phy_mode) {
> +	case PHY_INTERFACE_MODE_INTERNAL:
> +		if (ocelot_ext->port_modes[port] &
> +				OCELOT_SPI_PORT_MODE_INTERNAL)
> +			return 0;
> +		return -EOPNOTSUPP;
> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (ocelot_ext->port_modes[port] & OCELOT_SPI_PORT_MODE_SGMII)
> +			return 0;
> +		return -EOPNOTSUPP;
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		if (ocelot_ext->port_modes[port] & OCELOT_SPI_PORT_MODE_QSGMII)
> +			return 0;
> +		return -EOPNOTSUPP;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int vsc7512_port_setup_tc(struct dsa_switch *ds, int port,
> +				 enum tc_setup_type type, void *type_data)
> +{
> +	return -EOPNOTSUPP;
> +}

The absence of this callback should return -EOPNOTSUPP as well, from
felix_port_setup_tc().

> +
> +static struct vcap_props vsc7512_vcap_props[] =3D {
> +	[VCAP_ES0] =3D {
> +		.action_type_width =3D 0,
> +		.action_table =3D {
> +			[ES0_ACTION_TYPE_NORMAL] =3D {
> +				.width =3D 73,
> +				.count =3D 1,
> +			},
> +		},
> +		.target =3D S0,
> +		.keys =3D vsc7514_vcap_es0_keys,
> +		.actions =3D vsc7514_vcap_es0_actions,
> +	},
> +	[VCAP_IS1] =3D {
> +		.action_type_width =3D 0,
> +		.action_table =3D {
> +			[IS1_ACTION_TYPE_NORMAL] =3D {
> +				.width =3D 78,
> +				.count =3D 4,
> +			},
> +		},
> +		.target =3D S1,
> +		.keys =3D vsc7514_vcap_is1_keys,
> +		.actions =3D vsc7514_vcap_is1_actions,
> +	},
> +	[VCAP_IS2] =3D {
> +		.action_type_width =3D 1,
> +		.action_table =3D {
> +			[IS2_ACTION_TYPE_NORMAL] =3D {
> +				.width =3D 49,
> +				.count =3D 2,
> +			},
> +			[IS2_ACTION_TYPE_SMAC_SIP] =3D {
> +				.width =3D 6,
> +				.count =3D 4,
> +			},
> +		},
> +		.target =3D S2,
> +		.keys =3D vsc7514_vcap_is2_keys,
> +		.actions =3D vsc7514_vcap_is2_actions,
> +	},
> +};
> +
> +static struct regmap *vsc7512_regmap_init(struct ocelot *ocelot,
> +					  struct resource *res)
> +{
> +	struct device *dev =3D ocelot->dev;
> +	struct regmap *regmap;
> +
> +	regmap =3D ocelot_get_regmap_from_resource(dev->parent, res);
> +	if (IS_ERR(regmap))
> +		return ERR_CAST(regmap);
> +
> +	return regmap;

Seems like a long-winded way of typing "return ocelot_get_regmap_from_resou=
rce(...)"?

> +}
> +
> +static int vsc7512_mdio_bus_alloc(struct ocelot *ocelot)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	struct device *dev =3D ocelot->dev;
> +	u32 mii_offset, phy_offset;
> +	struct mii_bus *bus;
> +	int err;
> +
> +	mii_offset =3D ocelot_offset_from_reg_base(ocelot, GCB,
> +						 GCB_MIIM_MII_STATUS);
> +
> +	phy_offset =3D ocelot_offset_from_reg_base(ocelot, GCB, GCB_PHY_PHY_CFG=
);
> +
> +	err =3D mscc_miim_setup(dev, &bus, "ocelot_ext MDIO bus",
> +			       ocelot->targets[GCB], mii_offset,
> +			       ocelot->targets[GCB], phy_offset);
> +	if (err) {
> +		dev_err(dev, "failed to setup MDIO bus\n");
> +		return err;
> +	}
> +
> +	felix->imdio =3D bus;
> +
> +	return err;
> +}
> +
> +
> +static void vsc7512_mdio_bus_free(struct ocelot *ocelot)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +
> +	if (felix->imdio)

I don't think the conditional is warranted here? Did you notice a call
path where you were called while felix->imdio was NULL?

> +		mdiobus_unregister(felix->imdio);
> +}
> +
> +static const struct felix_info ocelot_ext_info =3D {
> +	.target_io_res			=3D vsc7512_target_io_res,
> +	.port_io_res			=3D vsc7512_port_io_res,
> +	.regfields			=3D vsc7512_regfields,
> +	.map				=3D vsc7512_regmap,
> +	.ops				=3D &vsc7512_ops,
> +	.stats_layout			=3D vsc7512_stats_layout,
> +	.num_stats			=3D ARRAY_SIZE(vsc7512_stats_layout),
> +	.vcap				=3D vsc7512_vcap_props,
> +	.num_mact_rows			=3D 1024,
> +	.num_ports			=3D VSC7512_NUM_PORTS,
> +	.num_tx_queues			=3D OCELOT_NUM_TC,
> +	.mdio_bus_alloc			=3D vsc7512_mdio_bus_alloc,
> +	.mdio_bus_free			=3D vsc7512_mdio_bus_free,
> +	.phylink_validate		=3D vsc7512_phylink_validate,
> +	.prevalidate_phy_mode		=3D vsc7512_prevalidate_phy_mode,
> +	.port_setup_tc			=3D vsc7512_port_setup_tc,
> +	.init_regmap			=3D vsc7512_regmap_init,
> +};
> +
> +static int ocelot_ext_probe(struct platform_device *pdev)
> +{
> +	struct ocelot_ext_data *ocelot_ext;
> +	struct dsa_switch *ds;
> +	struct ocelot *ocelot;
> +	struct felix *felix;
> +	struct device *dev;
> +	int err;
> +
> +	dev =3D &pdev->dev;
> +
> +	ocelot_ext =3D devm_kzalloc(dev, sizeof(struct ocelot_ext_data),
> +				  GFP_KERNEL);
> +
> +	if (!ocelot_ext)

Try to omit blank lines between an assignment and the proceeding sanity
checks. Also, try to stick to either using devres everywhere, or nowhere,
within the same function at least.

> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, ocelot_ext);
> +
> +	ocelot_ext->port_modes =3D vsc7512_port_modes;
> +	felix =3D &ocelot_ext->felix;
> +
> +	ocelot =3D &felix->ocelot;
> +	ocelot->dev =3D dev;
> +
> +	ocelot->num_flooding_pgids =3D 1;
> +
> +	felix->info =3D &ocelot_ext_info;
> +
> +	ds =3D kzalloc(sizeof(*ds), GFP_KERNEL);
> +	if (!ds) {
> +		err =3D -ENOMEM;
> +		dev_err(dev, "Failed to allocate DSA switch\n");
> +		return err;
> +	}
> +
> +	ds->dev =3D dev;
> +	ds->num_ports =3D felix->info->num_ports;
> +	ds->num_tx_queues =3D felix->info->num_tx_queues;
> +
> +	ds->ops =3D &felix_switch_ops;
> +	ds->priv =3D ocelot;
> +	felix->ds =3D ds;
> +	felix->tag_proto =3D DSA_TAG_PROTO_OCELOT;
> +
> +	err =3D dsa_register_switch(ds);
> +
> +	if (err) {
> +		dev_err(dev, "Failed to register DSA switch: %d\n", err);
> +		goto err_register_ds;
> +	}
> +
> +	return 0;
> +
> +err_register_ds:
> +	kfree(ds);
> +	return err;
> +}
> +
> +static int ocelot_ext_remove(struct platform_device *pdev)
> +{
> +	struct ocelot_ext_data *ocelot_ext;
> +	struct felix *felix;
> +
> +	ocelot_ext =3D dev_get_drvdata(&pdev->dev);
> +	felix =3D &ocelot_ext->felix;
> +
> +	dsa_unregister_switch(felix->ds);
> +
> +	kfree(felix->ds);
> +
> +	devm_kfree(&pdev->dev, ocelot_ext);

What is the point of devm_kfree?

> +
> +	return 0;
> +}
> +
> +const struct of_device_id ocelot_ext_switch_of_match[] =3D {
> +	{ .compatible =3D "mscc,vsc7512-ext-switch" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
> +
> +static struct platform_driver ocelot_ext_switch_driver =3D {
> +	.driver =3D {
> +		.name =3D "ocelot-ext-switch",
> +		.of_match_table =3D of_match_ptr(ocelot_ext_switch_of_match),
> +	},
> +	.probe =3D ocelot_ext_probe,
> +	.remove =3D ocelot_ext_remove,

Please blindly follow the pattern of every other DSA driver, with a
->remove and ->shutdown method that run either one, or the other, by
checking whether dev_get_drvdata() has been set to NULL by the other one
or not. And call dsa_switch_shutdown() from ocelot_ext_shutdown() (or
vsc7512_shutdown, or whatever you decide to call it).

> +};
> +module_platform_driver(ocelot_ext_switch_driver);
> +
> +MODULE_DESCRIPTION("External Ocelot Switch driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 8b8ebede5a01..62cd61d4142e 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -399,6 +399,8 @@ enum ocelot_reg {
>  	GCB_MIIM_MII_STATUS,
>  	GCB_MIIM_MII_CMD,
>  	GCB_MIIM_MII_DATA,
> +	GCB_PHY_PHY_CFG,
> +	GCB_PHY_PHY_STAT,
>  	DEV_CLOCK_CFG =3D DEV_GMII << TARGET_OFFSET,
>  	DEV_PORT_MISC,
>  	DEV_EVENTS,
> --=20
> 2.25.1
>=
