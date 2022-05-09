Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60D651FA8F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiEIK4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiEIK4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:56:42 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D357A1A6ACB;
        Mon,  9 May 2022 03:52:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZqhlKwCtLOzXArkwWBWwAWttQMPgdJLUEU0i8ki1mdgGOqrgH6NFxmg53ZhblknB8Ibh/iV3jPY2UrHNXP5VrVQAGS1T9jtm2BmmDzuvrCRwC5xdX+82mmg2d/3lbZm3PZHDLn8M2a7CwPkQqSQCHLUv/NhPbFhm00rO/Hcq+eQNgJ5Lo9WW9hRqciCbSqqpQX36Lyr4XUxTo82QQKcROSStHa5vy96ExQ/KmAoWmYEiG2wlf04PU1W/TEW3PfRdKBfjSVicLoISJTc35BpXM//Bswvs24K0ah7LLkQuTy/+37p6GVFIVUb9XsKcedtI7zlBTyHbT02VTrCaZYOCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mwl+0HEzxmhbyuGKHGtBZPdJbW6qqGhV5wNTQR8dP2g=;
 b=Q/5tpiUuFXDjtL8VjbTe6cOAWCtmWdQRoI9C5ROcGceGcVN9VAniqKIoWl1aPfiFZ+/Hm8jsJtVT5ItwmPYOW+TG7xr78jM+a6SNxEtEjJHyC9BO9VjRc9RkPTjX71RuvjKRkF+zB56CJsvumfiHPdf2ATnHQzisXDz7xjPL5PSOKXhK41D8H/gKz9rkZbBTmkYeajKsHuG03e6Ppqe9iaV78Ev5YZiFNTO38mIwhiB7iazTq4AM5QbgOoNzpiQx7t2Eok/4Bg3NeqmGFBeALMveR20+cvuZCJUeB/4BRrW9qQyMYLbunCT5n4a+KUZnS3nIPNl3tcLWOKYhsSN8tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mwl+0HEzxmhbyuGKHGtBZPdJbW6qqGhV5wNTQR8dP2g=;
 b=fNCekqeGg+baNtOBmFMqqK+IckzuWucnXKe/LktS74muqTS8uDgzRwDMnRe2NtM+4p105g63QwQrQ0kODmD2VuZjKvXmk/cMILAjmUWGHArwkUoPx+8fxtRNt+gjcbk3mh4ztLigniOLk+N7lAmxqJUuPr01t84nEgo97SiOg7M=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB7PR04MB4411.eurprd04.prod.outlook.com (2603:10a6:5:32::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 10:52:41 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 10:52:41 +0000
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
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Topic: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Index: AQHYYwz1YnOGgXOqGkauFg8TINDh2q0WX7KA
Date:   Mon, 9 May 2022 10:52:40 +0000
Message-ID: <20220509105239.wriaryaclzsq5ia3@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-9-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cb3ef41-e061-4f57-162e-08da31aa0a1b
x-ms-traffictypediagnostic: DB7PR04MB4411:EE_
x-microsoft-antispam-prvs: <DB7PR04MB4411A6FB4945258A3452676EE0C69@DB7PR04MB4411.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DiQWgmIKizQbmW2eS4LgCu92zl5Y9H5C74ZEaErpCN4VsHPc3XVrzedim9hKHlVEsKsBYR6nzmN924+Wo9o+zNXLJeB68OF7a31qDRax4flDDpG0fyLBiY5fQAV+JP5Di3gqVlV3HTNAHbJOUOkLoU0ydVzuRWN5wBRmmupxoXSeKnmt9ViODeNqeIrxNztfQIYKf69EG5U/dUZHf34aH5uv6LcPwwK2Zyfk39SBxQwWFpvL6xwxN1O7EJZzXnUOB+SPvtLvwginFy1OY1tthPvWSDso3eQMiPmoKdk/51oxYnMBh9ijZEXs+xWMG6HdUu4ttjKAIEK9XNwIu7lM1u+lFBMuKBXpwzeGZhTEHcPHo1kEClP7W8ftDO8y9npmopbIPkmP9aaMideRQ3c8AkyxXIY1BaO4lYkXlR52FzQ3xBB8eZzOFTdBhLIrvnuIDRilQpBvOdLmtxllHOrMlJgVFX8sTzW6rVAEtf67AdIVkEC4mtxEYKkz+PnzuSrVjfSqehRTtNgGM6/Ot5mwkGwgCCnXymL4jnf7v0FnJBvvuFOY29ov5dhhVzCP6i/LEB12XDbgy65nVavL6132furdE/yLuYDN/u20SYcC1QE9RJbrsuZuDgsJljzcLtZebzZBIjY6FwVfslWrUINdb/q09FkRlxg4hDzyuVeqJSItpZoMi/brzKriAz7m12ADSFD753mxogOmgG01VgFBgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6512007)(33716001)(66946007)(9686003)(26005)(186003)(6506007)(122000001)(38070700005)(38100700002)(71200400001)(1076003)(6486002)(86362001)(5660300002)(508600001)(7416002)(44832011)(8936002)(30864003)(54906003)(66476007)(64756008)(4326008)(8676002)(316002)(6916009)(76116006)(66556008)(66446008)(2906002)(83380400001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6e82aUcQ27wBBDBt2GA+RBhVeuMl1arRXl7D4ewAsSIzo3g6w/O0SAy9JS/l?=
 =?us-ascii?Q?u0t9HH6NUbIt9vITw1vxtAyi+zFoR5NqwQLMgh9ROWkn0QXqFWF99sg55b+j?=
 =?us-ascii?Q?EYFeGO64REbBCSjuVD4vFzLXdjJF6XqZmirclNFtZefDIA1fTpdpAJS9IIGZ?=
 =?us-ascii?Q?tUfaBF6YL4KBZr/lNX9YwgW1TSViLC7Sy6ulBXYNevJShgle4aZ+HnC3eXzk?=
 =?us-ascii?Q?E1mCPY3xyF1vTIzVZDxaOSdPAvnNjoB+OOdLi2kb2fb8+16+RcRNXzjoz+Od?=
 =?us-ascii?Q?uGQNr/f+dskH2yzfdlmXAW4SFP9GMCNCUFzVQXsiUf2D8NZnak34XmlEbUBj?=
 =?us-ascii?Q?FFeHTFWpqt2vPlIGSgDdzko7rWUXRZRYF79XmWUG39w85WXtU18z1vHDsWJH?=
 =?us-ascii?Q?XZSmCmA5Hr5zUyHSUnyGwd5P1IOfh96tcN5qqU72Sj5F0yoyePRNw1Q3BtgP?=
 =?us-ascii?Q?TTCQcD+mPbf2NREtu5nPKSvnuo03xMtsj3V9KiGWbPscS5wlJfkT/JWQ3KZH?=
 =?us-ascii?Q?UPoJWjgoXYQtCZasNoiLC3/YAJYmxNuDJ2ZaILj0cfKOdo0klfaHiAaO/SDq?=
 =?us-ascii?Q?FP9WJcKlqmeruj+T/XWSDmkNPXvwebzfSUbHKOWRCQuv9WmS5BeJDN+5L96e?=
 =?us-ascii?Q?EZZ1jywnJDdkKHSek8oPsp+ZxsRpFb4jhnZCaizGdbnoHebpeIYyjhkJidm2?=
 =?us-ascii?Q?7AghD3uWyrvAR2T6mQJ3L68OQR629cMBNBkKTy7GEziOxgXpsT77xSOtpEZD?=
 =?us-ascii?Q?Zu/cdYMJfmxoLKZ439pYjt6fvcQ5D2LafSTKrvpl/KgoTovlQFeQISw2Nzg6?=
 =?us-ascii?Q?H7Pevr+mKDzIsqlzfQFdJqLLyih/mw+B/Hvp++C+iyRO0pG1fTv/J3oROqxi?=
 =?us-ascii?Q?8ZxI7kCMXSYC68vr/sxrwgNoqFwCyLLG42wdqCkZvYmWc/X3OqibuuC2xdzv?=
 =?us-ascii?Q?l9t7cFHswn+XYADYUfHPTegBQLdn4mRtxTe5mT5knbn6VZi8CXFDH0qPu7tK?=
 =?us-ascii?Q?W7I2B2V+TWziihTrUfRTnjouVINOEwQLrTJ0JCpwEWQ2pRRfQbc6FpA3Zuxb?=
 =?us-ascii?Q?inkP+PRJm4dI+CjL8aGN+VP/0SAICuzRE3KimPjQP7WHBIeO0UpShcBl3Ywi?=
 =?us-ascii?Q?RFCDORVYTYW+6cqNbQ58lc1EuWSZqx4hqtMfPl4ECfxJpcn5yuFreZVA4TQN?=
 =?us-ascii?Q?TBTHvLuMHxalWCGIZ/vf5UqFUCu4V6lPI19gbSiEKx6ny30DkPbCWGHGlbA5?=
 =?us-ascii?Q?9GdBUh/KPPCRKi7UUj9MLTZ+a2QEnCXY62+12j/3H2Y3hUaEX7l8URuexDL3?=
 =?us-ascii?Q?edLxeIZcnaqM3U8NCptPqLC3vM4hPzvxDiuXgUESY6NiI4JoEs13+4YuEoiV?=
 =?us-ascii?Q?v042ld3NKrSy0pWB7OJRBixeDyHj4DK/X5pwE9SfizMQdf2HIjoyIAoplAuj?=
 =?us-ascii?Q?zeglxuD8uLMP5wMrul8/akiwn8Jn2pKc6hi5PFTXuSDtWifXwx+L0YisCMNS?=
 =?us-ascii?Q?ZVRT3EzUyVRafhSWjuT1xuWQwp+yi6rgFTJxgiLSvhZuzDgxBpNtMpw0XyMF?=
 =?us-ascii?Q?a8r/AMIuhGqJeskXwJR8Z5FfmMeJ8o/+u/5DSEkUGxfkWVE3PaDBJYA9hktF?=
 =?us-ascii?Q?gSz6CBEVAR/jCPKspVRzZNnA27m+tIhYHuVVuhVR5LskiHInFdTrOFPT2NHb?=
 =?us-ascii?Q?H1anf060UeRwJy9Cm8cVy627pabX351g57vapuibJ6knHCuNPY/Yhqew9xEA?=
 =?us-ascii?Q?P+P9pgE8dK2tfrCdItrdW62QkctPdpg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7E46B7EC918F4148B0CC1CC4B798C5AA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb3ef41-e061-4f57-162e-08da31aa0a1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 10:52:40.9470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F+LMLaBBKQohK4Dtgi38O5/C5FLwzW0M7OaxCZVjaZsNeVljlmKsB221dFXAmiDNHvU1w+DIrzxeEBGFLDx4jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4411
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:53:05AM -0700, Colin Foster wrote:
> The VSC7512 is a networking chip that contains several peripherals. Many =
of
> these peripherals are currently supported by the VSC7513 and VSC7514 chip=
s,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
>=20
> Utilize the existing drivers by referencing the chip as an MFD. Add suppo=
rt
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/Kconfig       |  18 +++
>  drivers/mfd/Makefile      |   2 +
>  drivers/mfd/ocelot-core.c | 135 +++++++++++++++++
>  drivers/mfd/ocelot-spi.c  | 311 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/ocelot.h      |  34 +++++
>  include/soc/mscc/ocelot.h |   5 +
>  6 files changed, 505 insertions(+)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-spi.c
>  create mode 100644 drivers/mfd/ocelot.h
>=20
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3b59456f5545..ff177173ca11 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -962,6 +962,24 @@ config MFD_MENF21BMC
>  	  This driver can also be built as a module. If so the module
>  	  will be called menf21bmc.
> =20
> +config MFD_OCELOT
> +	tristate "Microsemi Ocelot External Control Support"
> +	depends on SPI_MASTER
> +	select MFD_CORE
> +	select REGMAP_SPI
> +	help
> +	  Ocelot is a family of networking chips that support multiple ethernet
> +	  and fibre interfaces. In addition to networking, they contain several
> +	  other functions, including pictrl, MDIO, and communication with
> +	  external chips. While some chips have an internal processor capable o=
f
> +	  running an OS, others don't. All chips can be controlled externally
> +	  through different interfaces, including SPI, I2C, and PCIe.
> +
> +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +	  VSC7513, VSC7514) controlled externally.
> +
> +	  If unsure, say N
> +
>  config EZX_PCAP
>  	bool "Motorola EZXPCAP Support"
>  	depends on SPI_MASTER
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 858cacf659d6..bc517632ba5f 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -120,6 +120,8 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+=3D mc13xxx-i2c.o
> =20
>  obj-$(CONFIG_MFD_CORE)		+=3D mfd-core.o
> =20
> +obj-$(CONFIG_MFD_OCELOT)	+=3D ocelot-core.o ocelot-spi.o
> +
>  obj-$(CONFIG_EZX_PCAP)		+=3D ezx-pcap.o
>  obj-$(CONFIG_MFD_CPCAP)		+=3D motorola-cpcap.o
> =20
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> new file mode 100644
> index 000000000000..117028f7d845
> --- /dev/null
> +++ b/drivers/mfd/ocelot-core.c
> @@ -0,0 +1,135 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Core driver for the Ocelot chip family.
> + *
> + * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
> + * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core d=
river is
> + * intended to be the bus-agnostic glue between, for example, the SPI bu=
s and
> + * the child devices.
> + *
> + * Copyright 2021, 2022 Innovative Advantage Inc.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <soc/mscc/ocelot.h>
> +
> +#include <asm/byteorder.h>
> +
> +#include "ocelot.h"
> +
> +#define GCB_SOFT_RST		0x0008
> +
> +#define SOFT_CHIP_RST		0x1
> +
> +#define VSC7512_MIIM0_RES_START	0x7107009c
> +#define VSC7512_MIIM0_RES_SIZE	0x24
> +
> +#define VSC7512_MIIM1_RES_START	0x710700c0
> +#define VSC7512_MIIM1_RES_SIZE	0x24
> +
> +#define VSC7512_PHY_RES_START	0x710700f0
> +#define VSC7512_PHY_RES_SIZE	0x4
> +
> +#define VSC7512_GPIO_RES_START	0x71070034
> +#define VSC7512_GPIO_RES_SIZE	0x6c
> +
> +#define VSC7512_SIO_RES_START	0x710700f8
> +#define VSC7512_SIO_RES_SIZE	0x100
> +
> +int ocelot_chip_reset(struct device *dev)
> +{
> +	struct ocelot_ddata *ddata =3D dev_get_drvdata(dev);
> +	int ret;
> +
> +	/*
> +	 * Reset the entire chip here to put it into a completely known state.
> +	 * Other drivers may want to reset their own subsystems. The register
> +	 * self-clears, so one write is all that is needed
> +	 */
> +	ret =3D regmap_write(ddata->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
> +	if (ret)
> +		return ret;
> +
> +	msleep(100);

Isn't this a bit too long?

> +
> +	return ret;

return 0

> +}
> +EXPORT_SYMBOL(ocelot_chip_reset);
> +
> +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> +						const struct resource *res)
> +{
> +	struct device *dev =3D child->parent;
> +
> +	return ocelot_spi_devm_init_regmap(dev, child, res);

So much for being bus-agnostic :-/
Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
via a function pointer which is populated by ocelot-spi.c? If you do
that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.

> +}
> +EXPORT_SYMBOL(ocelot_init_regmap_from_resource);
> +
> +static const struct resource vsc7512_miim0_resources[] =3D {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM0_RES_SIZE,
> +			     "gcb_miim0"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE,
> +			     "gcb_phy"),
> +};
> +
> +static const struct resource vsc7512_miim1_resources[] =3D {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM1_RES_SIZE,
> +			     "gcb_miim1"),
> +};
> +
> +static const struct resource vsc7512_pinctrl_resources[] =3D {
> +	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
> +			     "gcb_gpio"),
> +};
> +
> +static const struct resource vsc7512_sgpio_resources[] =3D {
> +	DEFINE_RES_REG_NAMED(VSC7512_SIO_RES_START, VSC7512_SIO_RES_SIZE,
> +			     "gcb_sio"),
> +};
> +
> +static const struct mfd_cell vsc7512_devs[] =3D {
> +	{
> +		.name =3D "ocelot-pinctrl",
> +		.of_compatible =3D "mscc,ocelot-pinctrl",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_pinctrl_resources),
> +		.resources =3D vsc7512_pinctrl_resources,
> +	}, {
> +		.name =3D "ocelot-sgpio",
> +		.of_compatible =3D "mscc,ocelot-sgpio",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_sgpio_resources),
> +		.resources =3D vsc7512_sgpio_resources,
> +	}, {
> +		.name =3D "ocelot-miim0",
> +		.of_compatible =3D "mscc,ocelot-miim",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_miim0_resources),
> +		.resources =3D vsc7512_miim0_resources,
> +	}, {
> +		.name =3D "ocelot-miim1",
> +		.of_compatible =3D "mscc,ocelot-miim",
> +		.num_resources =3D ARRAY_SIZE(vsc7512_miim1_resources),
> +		.resources =3D vsc7512_miim1_resources,
> +	},
> +};
> +
> +int ocelot_core_init(struct device *dev)
> +{
> +	int ret;
> +
> +	ret =3D devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_core_init);
> +
> +MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> new file mode 100644
> index 000000000000..95754deb0b57
> --- /dev/null
> +++ b/drivers/mfd/ocelot-spi.c
> @@ -0,0 +1,311 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * SPI core driver for the Ocelot chip family.
> + *
> + * This driver will handle everything necessary to allow for communicati=
on over
> + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main func=
tions
> + * are to prepare the chip's SPI interface for a specific bus speed, and=
 a host
> + * processor's endianness. This will create and distribute regmaps for a=
ny
> + * children.
> + *
> + * Copyright 2021 Innovative Advantage Inc.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/iopoll.h>
> +#include <linux/kconfig.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/regmap.h>
> +#include <linux/spi/spi.h>
> +
> +#include <asm/byteorder.h>
> +
> +#include "ocelot.h"
> +
> +#define DEV_CPUORG_IF_CTRL	0x0000
> +#define DEV_CPUORG_IF_CFGSTAT	0x0004
> +
> +#define CFGSTAT_IF_NUM_VCORE	(0 << 24)
> +#define CFGSTAT_IF_NUM_VRAP	(1 << 24)
> +#define CFGSTAT_IF_NUM_SI	(2 << 24)
> +#define CFGSTAT_IF_NUM_MIIM	(3 << 24)
> +
> +#define VSC7512_CPUORG_RES_START	0x71000000
> +#define VSC7512_CPUORG_RES_SIZE		0x2ff
> +
> +#define VSC7512_GCB_RES_START	0x71070000
> +#define VSC7512_GCB_RES_SIZE	0x14
> +
> +static const struct resource vsc7512_dev_cpuorg_resource =3D
> +	DEFINE_RES_REG_NAMED(VSC7512_CPUORG_RES_START, VSC7512_CPUORG_RES_SIZE,
> +			     "devcpu_org");
> +
> +static const struct resource vsc7512_gcb_resource =3D
> +	DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE,
> +			     "devcpu_gcb_chip_regs");
> +
> +int ocelot_spi_initialize(struct device *dev)

Should be static and unexported.

> +{
> +	struct ocelot_ddata *ddata =3D dev_get_drvdata(dev);
> +	u32 val, check;
> +	int err;
> +
> +	val =3D OCELOT_SPI_BYTE_ORDER;
> +
> +	/*
> +	 * The SPI address must be big-endian, but we want the payload to match
> +	 * our CPU. These are two bits (0 and 1) but they're repeated such that
> +	 * the write from any configuration will be valid. The four
> +	 * configurations are:
> +	 *
> +	 * 0b00: little-endian, MSB first
> +	 * |            111111   | 22221111 | 33222222 |
> +	 * | 76543210 | 54321098 | 32109876 | 10987654 |
> +	 *
> +	 * 0b01: big-endian, MSB first
> +	 * | 33222222 | 22221111 | 111111   |          |
> +	 * | 10987654 | 32109876 | 54321098 | 76543210 |
> +	 *
> +	 * 0b10: little-endian, LSB first
> +	 * |              111111 | 11112222 | 22222233 |
> +	 * | 01234567 | 89012345 | 67890123 | 45678901 |
> +	 *
> +	 * 0b11: big-endian, LSB first
> +	 * | 22222233 | 11112222 |   111111 |          |
> +	 * | 45678901 | 67890123 | 89012345 | 01234567 |
> +	 */
> +	err =3D regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * Apply the number of padding bytes between a read request and the dat=
a
> +	 * payload. Some registers have access times of up to 1us, so if the
> +	 * first payload bit is shifted out too quickly, the read will fail.
> +	 */
> +	val =3D ddata->spi_padding_bytes;
> +	err =3D regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * After we write the interface configuration, read it back here. This
> +	 * will verify several different things. The first is that the number o=
f
> +	 * padding bytes actually got written correctly. These are found in bit=
s
> +	 * 0:3.
> +	 *
> +	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
> +	 * and will be set if the register access is too fast. This would be in
> +	 * the condition that the number of padding bytes is insufficient for
> +	 * the SPI bus frequency.
> +	 *
> +	 * The last check is for bits 31:24, which define the interface by whic=
h
> +	 * the registers are being accessed. Since we're accessing them via the
> +	 * serial interface, it must return IF_NUM_SI.
> +	 */
> +	check =3D val | CFGSTAT_IF_NUM_SI;
> +
> +	err =3D regmap_read(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
> +	if (err)
> +		return err;
> +
> +	if (check !=3D val)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_spi_initialize);
> +
> +static const struct regmap_config ocelot_spi_regmap_config =3D {
> +	.reg_bits =3D 24,
> +	.reg_stride =3D 4,
> +	.reg_downshift =3D 2,
> +	.val_bits =3D 32,
> +
> +	.write_flag_mask =3D 0x80,
> +
> +	.max_register =3D 0xffffffff,
> +	.use_single_write =3D true,
> +	.can_multi_write =3D false,
> +
> +	.reg_format_endian =3D REGMAP_ENDIAN_BIG,
> +	.val_format_endian =3D REGMAP_ENDIAN_NATIVE,
> +};
> +
> +static int ocelot_spi_regmap_bus_read(void *context,
> +				      const void *reg, size_t reg_size,
> +				      void *val, size_t val_size)
> +{
> +	static const u8 dummy_buf[16] =3D {0};
> +	struct spi_transfer tx, padding, rx;
> +	struct ocelot_ddata *ddata =3D context;
> +	struct spi_device *spi =3D ddata->spi;
> +	struct spi_message msg;
> +
> +	spi =3D ddata->spi;
> +
> +	spi_message_init(&msg);
> +
> +	memset(&tx, 0, sizeof(tx));
> +
> +	tx.tx_buf =3D reg;
> +	tx.len =3D reg_size;
> +
> +	spi_message_add_tail(&tx, &msg);
> +
> +	if (ddata->spi_padding_bytes > 0) {
> +		memset(&padding, 0, sizeof(padding));
> +
> +		padding.len =3D ddata->spi_padding_bytes;
> +		padding.tx_buf =3D dummy_buf;
> +		padding.dummy_data =3D 1;
> +
> +		spi_message_add_tail(&padding, &msg);
> +	}
> +
> +	memset(&rx, 0, sizeof(rx));
> +	rx.rx_buf =3D val;
> +	rx.len =3D val_size;
> +
> +	spi_message_add_tail(&rx, &msg);
> +
> +	return spi_sync(spi, &msg);
> +}
> +
> +static int ocelot_spi_regmap_bus_write(void *context, const void *data,
> +				       size_t count)
> +{
> +	struct ocelot_ddata *ddata =3D context;
> +	struct spi_device *spi =3D ddata->spi;
> +
> +	return spi_write(spi, data, count);
> +}
> +
> +static const struct regmap_bus ocelot_spi_regmap_bus =3D {
> +	.write =3D ocelot_spi_regmap_bus_write,
> +	.read =3D ocelot_spi_regmap_bus_read,
> +};
> +
> +struct regmap *
> +ocelot_spi_devm_init_regmap(struct device *dev, struct device *child,
> +			    const struct resource *res)
> +{
> +	struct ocelot_ddata *ddata =3D dev_get_drvdata(dev);
> +	struct regmap_config regmap_config;
> +
> +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> +	       sizeof(ocelot_spi_regmap_config));
> +
> +	regmap_config.name =3D res->name;
> +	regmap_config.max_register =3D res->end - res->start;
> +	regmap_config.reg_base =3D res->start;
> +
> +	return devm_regmap_init(child, &ocelot_spi_regmap_bus, ddata,
> +				&regmap_config);
> +}
> +
> +static int ocelot_spi_probe(struct spi_device *spi)
> +{
> +	struct device *dev =3D &spi->dev;
> +	struct ocelot_ddata *ddata;
> +	int err;
> +
> +	ddata =3D devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
> +	if (!ddata)
> +		return -ENOMEM;
> +
> +	ddata->dev =3D dev;
> +	dev_set_drvdata(dev, ddata);
> +
> +	if (spi->max_speed_hz <=3D 500000) {
> +		ddata->spi_padding_bytes =3D 0;
> +	} else {
> +		/*
> +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> +		 * Register access time is 1us, so we need to configure and send
> +		 * out enough padding bytes between the read request and data
> +		 * transmission that lasts at least 1 microsecond.
> +		 */
> +		ddata->spi_padding_bytes =3D 1 +
> +			(spi->max_speed_hz / 1000000 + 2) / 8;
> +	}
> +
> +	ddata->spi =3D spi;
> +
> +	spi->bits_per_word =3D 8;
> +
> +	err =3D spi_setup(spi);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> +		return err;
> +	}
> +

Personally I'd prefer:

	struct regmap *r;

	r =3D ocelot_spi_devm_init_regmap(dev, dev,
					&vsc7512_dev_cpuorg_resource);
	if (IS_ERR(r))
		return ERR_PTR(r);

	ddata->cpuorg_regmap =3D r;

and so on.

> +	ddata->cpuorg_regmap =3D
> +		ocelot_spi_devm_init_regmap(dev, dev,
> +					    &vsc7512_dev_cpuorg_resource);
> +	if (IS_ERR(ddata->cpuorg_regmap))
> +		return -ENOMEM;
> +
> +	ddata->gcb_regmap =3D ocelot_spi_devm_init_regmap(dev, dev,
> +							&vsc7512_gcb_resource);
> +	if (IS_ERR(ddata->gcb_regmap))
> +		return -ENOMEM;
> +
> +	/*
> +	 * The chip must be set up for SPI before it gets initialized and reset=
.
> +	 * This must be done before calling init, and after a chip reset is
> +	 * performed.
> +	 */
> +	err =3D ocelot_spi_initialize(dev);
> +	if (err) {
> +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);

Maybe showing the symbolic value behind the error number would be
helpful?

		dev_err(dev, "Initializing SPI bus returned %pe\n", ERR_PTR(err));

Similar for other places where you print the error using %d, I won't
repeat this comment.

> +		return err;
> +	}
> +
> +	err =3D ocelot_chip_reset(dev);
> +	if (err) {
> +		dev_err(dev, "Failed to reset device: %d\n", err);
> +		return err;
> +	}
> +
> +	/*
> +	 * A chip reset will clear the SPI configuration, so it needs to be don=
e
> +	 * again before we can access any registers
> +	 */
> +	err =3D ocelot_spi_initialize(dev);
> +	if (err) {
> +		dev_err(dev,
> +			"Failed to initialize Ocelot SPI bus after reset: %d\n",
> +			err);
> +		return err;
> +	}
> +
> +	err =3D ocelot_core_init(dev);
> +	if (err < 0) {
> +		dev_err(dev, "Error %d initializing Ocelot core\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +const struct of_device_id ocelot_spi_of_match[] =3D {

static

> +	{ .compatible =3D "mscc,vsc7512_mfd_spi" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> +
> +static struct spi_driver ocelot_spi_driver =3D {
> +	.driver =3D {
> +		.name =3D "ocelot_mfd_spi",
> +		.of_match_table =3D of_match_ptr(ocelot_spi_of_match),
> +	},
> +	.probe =3D ocelot_spi_probe,
> +};
> +module_spi_driver(ocelot_spi_driver);
> +
> +MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("Dual MIT/GPL");
> diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> new file mode 100644
> index 000000000000..b68e6343caca
> --- /dev/null
> +++ b/drivers/mfd/ocelot.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright 2021 Innovative Advantage Inc.
> + */
> +
> +#include <linux/regmap.h>
> +
> +#include <asm/byteorder.h>
> +
> +struct ocelot_ddata {
> +	struct device *dev;
> +	struct regmap *gcb_regmap;
> +	struct regmap *cpuorg_regmap;
> +	int spi_padding_bytes;
> +	struct spi_device *spi;
> +};
> +
> +int ocelot_chip_reset(struct device *dev);
> +int ocelot_core_init(struct device *dev);
> +
> +/* SPI-specific routines that won't be necessary for other interfaces */
> +struct regmap *ocelot_spi_devm_init_regmap(struct device *dev,
> +					   struct device *child,
> +					   const struct resource *res);
> +int ocelot_spi_initialize(struct device *dev);
> +
> +#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
> +#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
> +
> +#ifdef __LITTLE_ENDIAN
> +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
> +#else
> +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
> +#endif
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 1897119ebb9a..f9124a66e386 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -1039,11 +1039,16 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, i=
nt port,
>  }
>  #endif
> =20
> +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> +						const struct resource *res);
> +#else
>  static inline struct regmap *
>  ocelot_init_regmap_from_resource(struct device *child,
>  				 const struct resource *res)
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
> +#endif
> =20
>  #endif
> --=20
> 2.25.1
>=
