Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A664520270
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbiEIQbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239110AbiEIQbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:31:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F702246A2;
        Mon,  9 May 2022 09:27:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idjWLR3u16pC6VvL/vGKfvsCbs9vZvmyJk2XSElKTFxkcB4Oh+4gkc+yjsBrGvl/9zAGxV7XMVDm8khovB5wUXqDZkgkPEHhiL2/CotqhnlmBTWdSpUY1AVtg5SrGRTtxFabDmAWQDHiDcTcNQrRQzci/LyoS0r9YM0uB1mNkPtTaMfxUuFeXNj0jrx652+X0JDX7fOaskhfsVEybUELFV07DG6LGtLgQifMxP4CbBhayLts0mz3Nn0PNOBaUqLXpUOzn7E+dcdCPaFSyci8xj0kJ12waUuLNb7egmRVg1ih6Y2UpLImTparDtaMTLqN4+OlzhgVAuZ/XhFTI9SlnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CChAwTZ8LfTqr37IZuIBNYn8UUmDwK3yZ6satN7FxI=;
 b=XdPxANRAie6ZPdGuHCgVMfycuMbHr0q9IBrMdzPWWFTPmbn4Tj9E9BnrPJO7aAaCdlNgDCT/TrEhM6+dfiedB4ZMUGAmEM5oBZFoUGDIc2GzSo07ED0XQ9+CiC1D3H6+7HK6NQSnwg2X8vpDs2NctIMykgvbkWjZPQ3RYOoIP+pdun9UjG2h5zqzsZv7/SVmHTYjqwkGA2RFqbNJEqyvjD+OXsdfSrOU/yyzBK7EVI3awmJmghPrgwiuVJjN5aW6Gq+/5qqyNTi2XWzRYCDwS/PpbWuhcOzV34qpzorpC2HXQnmMo2GMgtx1opnF8f3K6G0k0i71BZvp8fsa9MyYDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CChAwTZ8LfTqr37IZuIBNYn8UUmDwK3yZ6satN7FxI=;
 b=dEiUY6M1oQ8TTDMZQz0uOUnhgmDZOhJghvL6P5mSjfTZZOabYbXfMeMO7rKvAUYcAy1g1GAS6XYryykpEZI0OXikgs2rRaWq27LmpNnrw3R/3PQ6Uw0D/6X3stLPlYwDd8NkAkkt965nnWOa/IpnoqK6VhqhO4o0l4Tn12NIKtc=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB9PR04MB8076.eurprd04.prod.outlook.com (2603:10a6:10:246::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 16:27:23 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 16:27:22 +0000
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
Subject: Re: [RFC v8 net-next 14/16] net: dsa: ocelot: add external ocelot
 switch control
Thread-Topic: [RFC v8 net-next 14/16] net: dsa: ocelot: add external ocelot
 switch control
Thread-Index: AQHYYwz+URPlRDP8g0KdVWIsv3mUya0WvTaA
Date:   Mon, 9 May 2022 16:27:22 +0000
Message-ID: <20220509162721.jksbziznaxdwgogd@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-15-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-15-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de2e5388-8d73-4314-a2b8-08da31d8cbd7
x-ms-traffictypediagnostic: DB9PR04MB8076:EE_
x-microsoft-antispam-prvs: <DB9PR04MB807683122671C398787803ACE0C69@DB9PR04MB8076.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BmnzgEgIjElK5IstIKsDmQdvSb6dUAXdoAofZiQc88dO2+orLN2kh7RPvNGbVz7HAMOg9hw8KUaXbfgC6A3w1nGgPFXZeH7TRGOOpm5icztsEOysykUBdhP7uYk7FSZpUpD/SDX3oK+DWAow1C0LXi3KlgZr8iD23BeKToorXqsuluKo8/OUVx60I1UoLfClgSl+eTOStQh5+6ie5ZGneOiLZWTdYv9xzGVuBgnGc0bF9mV+axJlSW1u8AkLG3aUMcxso0JWTHeMyoO+yGx9gH5UnUo8zq5jc5gjS4gzhqLKQY7rp1eu/UQMz3sKFBfUQuOU1VNrx+E1tldhg/mkb7pr+5yvL0aNaP2NBu857rH6Iplg00+gR69ZBgrK7n0VaYglcF/P2UYKnPvm1M+7U+3SAxjqgBQS7YdXqvB0WBDVado0xAGr1eG+RNdKrBj2/pdc87QYTe72u2fCKt2WDbOfFoZjwMx0ixRyE3NpZxu/fsSpT8hhnZ5uppbOERx+2UkVfjJBVKWVyqH1hQ7LE5XIBUHafAo+9Jo8i+1MQ2DbHxfLRCQ6mftY6GQuU3P2OVbGE9CIR7mVAy6q9EXh0A3uv2rbySlpoakcqpGtCzzZkUzWZEpKbFqIppo1G8ththpPhG7k87kMLo/oNrP5G/8MFnz5OsrJa007TCdxqOZxbeR1aIvDA4WLqapG/ja2I8aPzLVcFDoeE172RrNSdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(66946007)(76116006)(66476007)(91956017)(64756008)(66446008)(8676002)(508600001)(66556008)(1076003)(4326008)(186003)(83380400001)(8936002)(9686003)(26005)(6486002)(86362001)(71200400001)(6512007)(54906003)(316002)(6916009)(6506007)(122000001)(3716004)(2906002)(44832011)(30864003)(7416002)(5660300002)(38070700005)(38100700002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?69yoIcAlOKDmYgewSqYe0nL1T5IFGpgfmfZvziZJmvX+ZwqSE3B8BVgIVptf?=
 =?us-ascii?Q?xrB8Qqoctz4MLLHBS1IE9pJ8q6v8DNFzkWJcbej58tegXdQo6Bw5qFcE/AO5?=
 =?us-ascii?Q?IRlDfWhu04LSN0mQ3RJ5p2Iq8KylsCwl08uQmkYJbUKI3QwyoN7m3tVOu/GD?=
 =?us-ascii?Q?4jj7WDoFu7ZOP9yw+iY9uKOcNh+13/FnZ86/dTf4Slybb86s4uPBMEYONIUJ?=
 =?us-ascii?Q?1kx89qcn32aPJcacss5x6GD1mGzQMFXBdS2mEAs6Ue/GpLBakkj8XaR6VoYw?=
 =?us-ascii?Q?KJdxACDuYIOuuSXeQHAKpoxTkKvtMPMAE+ZtIFJjPRFhK+TN8nRLz73NudJM?=
 =?us-ascii?Q?8YiMsgFwWMCFvHrKwqAzXQxIAPhGAZNmWag+ZmtZQZG7ITusahhqjuSy/qi5?=
 =?us-ascii?Q?l9xEg8mQ8yAnR94YlWsYoN1NwLwCDEIg/7QJLAKloWnMPfy3PvPtipAmu+LF?=
 =?us-ascii?Q?My6nTtQt5eJtiWm8vDPtU0NR/KeOiCyKdQ9JjOGhK4qw7oqtJrbgiy11Rdlf?=
 =?us-ascii?Q?zmWl+VrmeWSLIaNcSUH7EircG2F31dAd0IhEnWl0kRmtgX2NANBs5R4e1uvO?=
 =?us-ascii?Q?/DpDoYUZ6uvyciUMCZGodyVKUWNb7Zqc3hfribcNlBwCoFvWwLYY/91ZQM/Z?=
 =?us-ascii?Q?1IGgDkpOeyqx48/dHFmpYmDCZhThy7HUus8phDVHlLSLp+8yv/O+f9K9SWUW?=
 =?us-ascii?Q?sIR1uR7BxjRfUFmQvU2p485/S7DACMvAk1Q4JQ3EXAER42Qu1bhM3EITnA8k?=
 =?us-ascii?Q?om3dPxylsQiAvEZy/1W8qe0PdrzSkhvdHwkz8Dmoz07g8kwV7HyPLWlUD/If?=
 =?us-ascii?Q?OQ+Yqbh716R8CpMy9Hby+kCJpTbXEksg6Ec+79E7NRX7dRQeKiPngU28QiEW?=
 =?us-ascii?Q?2osMRDCtfPaVyBeM7SG1fdp0ZG6viCZAtgyGD+sF8k45yxKtf8N7D5D/8E3o?=
 =?us-ascii?Q?DmfLJeR9L1LY6ABs1NcGJAagPfssFA/SGuYZhdwUMcpdDUJUFD2G0+h/yUnn?=
 =?us-ascii?Q?jzam8fgw2ScszCDUdb0gKzPUabghx2jnH81ZS7Ymwm+sDri73xR+in/aXOSY?=
 =?us-ascii?Q?DKpM7MN1UlOA3in1u+KjFBMxy9Dxozpa8UTjaTVXleev7aIPlUPXE5zANWEQ?=
 =?us-ascii?Q?KpK2BVVekQzZsRrwkdXhQ+zk6bIWMDtkVK+ytQcTorw7cdoQGjHkvgLyEFe1?=
 =?us-ascii?Q?4o/xyB4Rg24oM33wgwBKX2LFVR+nJkAKDoV+ox6x3skpmH0I0nbujkbpeNkz?=
 =?us-ascii?Q?lqcsTiko3G34Cp0qLBV9zTXPkL+GmRmixG4u/mIspR39wF6+aD6fRrIrxFf8?=
 =?us-ascii?Q?NKAIGcgxjgWgU5ZeXkFjfxSf7s8rcYEsWt1aracQE6zvSMQ5y1I6WoB8yec2?=
 =?us-ascii?Q?YmgeTfLGLC88gBZ8oFlUqh/98/EeqCDqjKm7ItuOEV1/17iPgnu6FWi4ygDh?=
 =?us-ascii?Q?20lUpe5DukWl87I2XUEQSc788sXz/g8JZpLWa2cV53vWe5yUAZrLPE7Hqeh4?=
 =?us-ascii?Q?Ka0OvIXjDnhJ4iaObV4rgsrc1bZ/j220Fso5q5eD/5V4KFS9y8etXHNaiLg0?=
 =?us-ascii?Q?sc6S40n+Vz1bb7kBM+mvO1Mwl4ADYUzJWZgUIBjD8fu7Woqmiy2wTFjFN8c+?=
 =?us-ascii?Q?5xMYTwRypmY0ckos492orXW09UEl/nHPuIQNMQI5LvCM+EypgK42kJppQTVo?=
 =?us-ascii?Q?ygfLPxriXnqqdYHzkJp8Td1zfPVZaYQ3vdq7dgLszA7jCvPuaRMyMxt0Y2mS?=
 =?us-ascii?Q?dG/4WUBOCwBIX8yd1Ub78terbfMLZDw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3F454095E62DF34387276475955F9595@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de2e5388-8d73-4314-a2b8-08da31d8cbd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 16:27:22.8325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X7c3BRSY7rhhLNSY1QZS70wzEnw+7XWYAyuvR6t/x9Mki+DJsMN3IVmFpRyLEW3v7qcJ2kigs0kH99iymb/+pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:53:11AM -0700, Colin Foster wrote:
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
>  drivers/mfd/ocelot-core.c           |   3 +
>  drivers/net/dsa/ocelot/Kconfig      |  14 ++
>  drivers/net/dsa/ocelot/Makefile     |   5 +
>  drivers/net/dsa/ocelot/ocelot_ext.c | 368 ++++++++++++++++++++++++++++
>  include/soc/mscc/ocelot.h           |   2 +
>  5 files changed, 392 insertions(+)
>  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
>=20
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index 117028f7d845..c582b409a9f3 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -112,6 +112,9 @@ static const struct mfd_cell vsc7512_devs[] =3D {
>  		.of_compatible =3D "mscc,ocelot-miim",
>  		.num_resources =3D ARRAY_SIZE(vsc7512_miim1_resources),
>  		.resources =3D vsc7512_miim1_resources,
> +	}, {
> +		.name =3D "ocelot-ext-switch",
> +		.of_compatible =3D "mscc,vsc7512-ext-switch",
>  	},
>  };
> =20
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
> index 000000000000..ba924f6b8d12
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> @@ -0,0 +1,368 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Copyright 2021-2022 Innovative Advantage Inc.
> + */
> +
> +#include <asm/byteorder.h>
> +#include <linux/iopoll.h>
> +#include <linux/kconfig.h>
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
> +static const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] =3D {
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> +	OCELOT_PORT_MODE_SGMII,
> +	OCELOT_PORT_MODE_SGMII | OCELOT_PORT_MODE_QSGMII,
> +};
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
> +static void ocelot_ext_reset_phys(struct ocelot *ocelot)
> +{
> +	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
> +	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
> +	mdelay(500);
> +}
> +
> +static int ocelot_ext_reset(struct ocelot *ocelot)
> +{
> +	int retries =3D 100;
> +	int err, val;
> +
> +	ocelot_ext_reset_phys(ocelot);
> +
> +	/* Initialize chip memories */
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1)=
;
> +	if (err)
> +		return err;
> +
> +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1=
);
> +	if (err)
> +		return err;
> +
> +	/* MEM_INIT is a self-clearing bit. Wait for it to be clear (should be
> +	 * 100us) before enabling the switch core
> +	 */
> +	do {
> +		msleep(1);
> +		err =3D regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> +					&val);
> +		if (err)
> +			return err;
> +	} while (val && --retries);

Can you use readx_poll_timeout() here?

> +
> +	if (!retries)
> +		return -ETIMEDOUT;
> +
> +	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1)=
;
> +}
> +
> +static const struct ocelot_ops ocelot_ext_ops =3D {
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
> +static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
> +					unsigned long *supported,
> +					struct phylink_link_state *state)
> +{
> +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> +
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> +
> +	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&

This check is no longer necessary, please look again at the other
phylink validation functions.

> +	    state->interface !=3D ocelot_port->phy_mode) {

Also, I don't see what is the point of providing one phylink validation
method only to replace it later in the patchset with the generic one.
Please squash "net: dsa: ocelot: utilize phylink_generic_validate" into
this.

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
> +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> +					     struct resource *res)
> +{
> +	return ocelot_init_regmap_from_resource(ocelot->dev, res);
> +}
> +
> +static const struct felix_info vsc7512_info =3D {
> +	.target_io_res			=3D vsc7512_target_io_res,
> +	.port_io_res			=3D vsc7512_port_io_res,
> +	.regfields			=3D vsc7514_regfields,
> +	.map				=3D vsc7512_regmap,
> +	.ops				=3D &ocelot_ext_ops,
> +	.stats_layout			=3D vsc7514_stats_layout,
> +	.vcap				=3D vsc7514_vcap_props,
> +	.num_mact_rows			=3D 1024,
> +	.num_ports			=3D VSC7512_NUM_PORTS,
> +	.num_tx_queues			=3D OCELOT_NUM_TC,
> +	.phylink_validate		=3D ocelot_ext_phylink_validate,
> +	.port_modes			=3D vsc7512_port_modes,
> +	.init_regmap			=3D ocelot_ext_regmap_init,
> +};
> +
> +static int ocelot_ext_probe(struct platform_device *pdev)
> +{
> +	struct dsa_switch *ds;
> +	struct ocelot *ocelot;
> +	struct felix *felix;
> +	struct device *dev;
> +	int err;
> +
> +	dev =3D &pdev->dev;

I would prefer if this assignment was part of the variable declaration.

> +
> +	felix =3D kzalloc(sizeof(*felix), GFP_KERNEL);
> +	if (!felix)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, felix);
> +
> +	ocelot =3D &felix->ocelot;
> +	ocelot->dev =3D dev;
> +
> +	ocelot->num_flooding_pgids =3D 1;
> +
> +	felix->info =3D &vsc7512_info;
> +
> +	ds =3D kzalloc(sizeof(*ds), GFP_KERNEL);
> +	if (!ds) {
> +		err =3D -ENOMEM;
> +		dev_err(dev, "Failed to allocate DSA switch\n");
> +		goto err_free_felix;
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
> +	if (err) {
> +		dev_err(dev, "Failed to register DSA switch: %d\n", err);

dev_err_probe please (look at the other drivers)

> +		goto err_free_ds;
> +	}
> +
> +	return 0;
> +
> +err_free_ds:
> +	kfree(ds);
> +err_free_felix:
> +	kfree(felix);
> +	return err;
> +}
> +
> +static int ocelot_ext_remove(struct platform_device *pdev)
> +{
> +	struct felix *felix =3D dev_get_drvdata(&pdev->dev);
> +
> +	if (!felix)
> +		return 0;
> +
> +	dsa_unregister_switch(felix->ds);
> +
> +	kfree(felix->ds);
> +	kfree(felix);
> +
> +	dev_set_drvdata(&pdev->dev, NULL);
> +
> +	return 0;
> +}
> +
> +static void ocelot_ext_shutdown(struct platform_device *pdev)
> +{
> +	struct felix *felix =3D dev_get_drvdata(&pdev->dev);
> +
> +	if (!felix)
> +		return;
> +
> +	dsa_switch_shutdown(felix->ds);
> +
> +	dev_set_drvdata(&pdev->dev, NULL);
> +}
> +
> +const struct of_device_id ocelot_ext_switch_of_match[] =3D {

static

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
> +	.shutdown =3D ocelot_ext_shutdown,
> +};
> +module_platform_driver(ocelot_ext_switch_driver);
> +
> +MODULE_DESCRIPTION("External Ocelot Switch driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 61888453f913..ade84e86741e 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -402,6 +402,8 @@ enum ocelot_reg {
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
