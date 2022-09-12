Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BA65B5F27
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiILRVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILRVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:21:17 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-he1eur02on0613.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe05::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25C96418;
        Mon, 12 Sep 2022 10:21:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rj4So4nJi0R+1ArGwmj/KltmZ48xs0vQ9aPSkqU1SUmYzRvA5D/zX6pKR5RPkC1m7dp/0DbMTQ4YoJ7qGAZ/0aWJTCjZ9SQiGYNAm2dzHH34MCA1Ldj04zQT2Ki3hFHHNOfyVryxb9sbLIYflLReukCECgB8gkbp/GJv1SZumQeADFAtccTZ6jndmoN6RTdHFQ0dZoA+2QHZ9VKrJxiXltN3c6G6Tm+e5kFoQOtTftiolxnra+OrFw549D6bZv8zSUUTP5ryrTmZIvtuXaMAJIK7ttmnj8/mZFUd9t2IAxe2cZCn4XpLWmUWsBMSMyYTS+VRcRn9OjUEszUJfZUUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7OixH6B23GyW7BsmnyEuotqfqBM23slwbeKe1MnmvA=;
 b=cojJAtekjV4nFNvIkUWijUjSiB31CtGyuADE5w4oRdCa/7cSZYszy1kM+kLvmNDEgb6wzP6r88+6AFfR2q/nfp1Y8se5oszSsNd1X8sN9LJ0UzKeob9Ev7l3ryK+IDs429JFEifY9cR3FILSO6Yi6xaXpcrSJ6rf3NMpqeHL4St6kk734HrFHjIAJlzwZjthq7kPnsAqMKvuN4i2w7ZfZiOozAJGw9PggWshE36UVfJdqOvjjkLIUnd68JAzjEQr/OwfRDt5PAc9p4wwzFsKYdU5OM22H5nDaJxuC9vmCD2zYuOb2JCftHolGa6YLEfs/qTtaJn0NSXD9MoC6lyB+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7OixH6B23GyW7BsmnyEuotqfqBM23slwbeKe1MnmvA=;
 b=YdcvrIIVQ/dqT5glABxvpgTFic+0DUcfFg1G65uLBGjZoN7SvQCTCJBH3mfYjSvRkjUHc6OMJaTT/KxhOMGfe59JpgJFM5x1+P4nwfQzZJn/ZGPrz/kU2SFDE5Cb+L7xJa5NHoyltEH6HW7uyfM6rUZwWpenBDfHfo/Pds37Ajk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7656.eurprd04.prod.outlook.com (2603:10a6:20b:29b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:21:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:21:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
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
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Thread-Topic: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Thread-Index: AQHYxhmB6n7Dh7/720qmqJ9m50DC1Q==
Date:   Mon, 12 Sep 2022 17:21:10 +0000
Message-ID: <20220912172109.ezilo6su5w6dihrk@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
In-Reply-To: <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7656:EE_
x-ms-office365-filtering-correlation-id: aa18f0c6-3b96-4c6c-2ef8-08da94e32fc8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /06qCfT6wOoUtxZu6tnGNhsOyfME1o+UGetwSHLavrHuQmIdJ8aUyMcxZTZHIKCpa15DgYKri3m2MDYoeRj7a/XVaUputm2qXDMVytVST/C7DugIupVqFc2XzelC+xA0GlfYp+OimUqWyOJ2GfvcE8fm7fiRo7IWrsq/RWWjll5ODoRhExXLzsT/pp+5G3gHH8ZdD+7Msy43ZIGpd9YsWBfcJPrC/b7vjfy3NrI8Ctv4RiAp1yIR9rk5yTprQWGRfX8dA60roKb3QFfH3DMcwKe/0q89hz/X3857mK79vIUIKNe9F/DxOdo5uSgrn6ycZ1oYGeoev+HBo+GFzQ304myRS2k5cF9Cg19Tf3WpOoPqt08TxcbAdlAyB484gWby+HzpXKQYPihEHk5YpjFB+3E1Efh0LAF7nMbRpeSCu6pZqbG5T92qJsezNcMxEOjJ79PFg+0DfgWBuVsUuoMw78Osx3ThO378SFcuUXm5FYV55TACqgTOOhpGVcAcngHUnR2pNPiWsbXIm5f3YNPNDfEf25XkWE1NAH5GUTyXPL7n3PZq0ZkblsbAuiV54HDGYNkkLDTdn37uxS9lz1epRgwSVu3MlC53r0wDo1Ur83CjkuVsvVvQ5nTY2fyby04hb55NZvWaZKEQTjnobnWSS2mu5A0cVXdQo9bWW+BnXquW/mImC6qOCVuqKJ/f8B0H9X5IeooFq6XOpvzteEQJ54h+ljteiSHD1sURdZAIDcfEbKNEPEYuRoTQJHn9ubqzz/EjdkjhAMq7p65TL0WYQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230019)(7916004)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199012)(33716001)(38100700002)(9686003)(122000001)(1076003)(26005)(316002)(64756008)(66476007)(66946007)(6512007)(6916009)(91956017)(71200400001)(6486002)(66446008)(8676002)(76116006)(44832011)(4326008)(66556008)(2906002)(6506007)(54906003)(83380400001)(186003)(38070700005)(86362001)(8936002)(5660300002)(7416002)(41300700001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o0iuUDKGntDQvwgHrDdPIVnpXVsfAImrNJ2had4Y4WwN+pWXjCtxHbG/U0QQ?=
 =?us-ascii?Q?nH6W8J0YNg74IZuDnUfhRk8/+JiIHK4lrZhw7qzehzsk+l6SYEaLlQv10VHJ?=
 =?us-ascii?Q?tBIHrCgm7r9TyhiiU7l4mTtIGYYP4V1whbZXNKv9m5VWXJWe+jKmxwyG4XRG?=
 =?us-ascii?Q?U8uyzAXoSij/3NLDsoUEUDq5vdCsJtr5Q/3bG8s2U74+5xFwwo8JznGucsbE?=
 =?us-ascii?Q?vA7xMzIMfM/qiahJpjbGBUAJuCT0ahKvyrWWg9lBPpkSmP1UTL7t95y2tEKD?=
 =?us-ascii?Q?B/oNRnkIzx9II+TizmAKTtR07LJgsIdNdWVStc45+OPI981MYD1lrIqFE42E?=
 =?us-ascii?Q?UTbuHohqyLAGUIuc5sCoy9EBspvCZiJdqDa83CiL6NG5ltow8fLQxgFvAr9q?=
 =?us-ascii?Q?Lj0rkA7aYv3gEf+y/w37PJ/8krByxLSOVvZzG6Q5HyLc85d8lNBMJ5DlK+ot?=
 =?us-ascii?Q?gO6v6lDVJgX8JiIuxhI9O2l9Rnx2635QknZM3WWi+MoKOAJK1DL25NgKsKfd?=
 =?us-ascii?Q?5vUYJxDl+KR4rM/UISuUYmczyLhlx6o0iQ+3IhZZxxHBq+WtErUxsP44U0pP?=
 =?us-ascii?Q?AuU/p3Ef1RoIJMkxcl15ejQ10foFxIDZ0fJhDmgEin1RgfXxMu7BwRlS0Lza?=
 =?us-ascii?Q?HRwtxoQbVrxELRyAbWTnf/KLtGiMrYXZu7dBTUK2PwzZbh7ZcIBACitsl0Cy?=
 =?us-ascii?Q?IeWRowsiZoRtSaou6HkErIn9CK+6LWR55mtq6+0btX01hygid91l/+wMGvbG?=
 =?us-ascii?Q?7AGirRD+dxNxk12iaObSFud2oMjVf+moS8Rq18Cn4xa9wU1YTLE4x0WCHtUc?=
 =?us-ascii?Q?lwV7Yn0xoUcNBxOaQGffHZzS6Zal8ZhXx0aN45xayUkzVdnLrXCHmQ6PJgLm?=
 =?us-ascii?Q?SlEtaWkXAeqxw8k81aMioZV9cqDaynlRkSP0R7CmfxDZh/tUZTg5bnb9qpE+?=
 =?us-ascii?Q?u58pE3OzpLUTw4pj0JMru+kwcsCj7w78o4ZJ7nzOKNUB9RHwFgyIpqXNLBvO?=
 =?us-ascii?Q?WgPj4jm0sRgPBMDsBOPQm+uPYvot2kyxEw7R4CvD58g65yDnu6woAGm09W9m?=
 =?us-ascii?Q?GUSPtF80y/cnNl8hJwZMSigRLYPaqwSEAKrj2ma8xAS9XKwJQtvI4BpeeSfI?=
 =?us-ascii?Q?4WpLv+kJ2gPsKKUEJXPlLxijkrHub1KV3oBDfXbKcSftJ1uq51jJ/JYP+LNC?=
 =?us-ascii?Q?6LXsiBqMhGk4kbVxDl0phi5eLm6fGaMHNNdUu4+cy0eIgU5UO1NYm3GeSgn1?=
 =?us-ascii?Q?uGjYg8XwsxxrL6t2NvGwsLXg4OTjP8kPBtQY4UpBchSybOllBite0FunO4n+?=
 =?us-ascii?Q?ahpz2fcz0vMjR+DFq6tExemNvwAhcjm1fEBnXHw9bhspqDCDWRIh5qxOck3u?=
 =?us-ascii?Q?32FirkAi8+VnS0rVtGBo4ZKgeu+BpMGJSGa1C5EcLpm7abHD7ELETuiMH616?=
 =?us-ascii?Q?r8Z70ZeMdUKCheXhOgdAVgK5uSTjT6S7Fdt8F0dFsEToVFb649zYt482Ls8p?=
 =?us-ascii?Q?r0ZhMaPBTBmNwo14XZvvGCOysrMk5iJfQGPxsuMVwWrRVOC8I8SGfXH4wRq4?=
 =?us-ascii?Q?ZcXGG0vwaNIIESCRNgen8vT8Y5H7BGzHnTHqzQtBMritLiAAdG3CozHiK94Z?=
 =?us-ascii?Q?ew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBCCB19F5884DC4C9EA9FAB14B628551@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa18f0c6-3b96-4c6c-2ef8-08da94e32fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 17:21:10.6169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YAV87rDZvTuFqg4+Mi6aAVHPsanzstG/PkU090/GnSSkbIqT1vijVhRr04EQG08P+Q+ARRoqdpdgimsSwebrUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7656
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 01:02:44PM -0700, Colin Foster wrote:
> index 08db9cf76818..d8b224f8dc97 100644
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

I would drop the sentence about Microsemi dev boards or custom hardware.

> diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot=
/ocelot_ext.c
> new file mode 100644
> index 000000000000..c821cc963787
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> @@ -0,0 +1,254 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Copyright 2021-2022 Innovative Advantage Inc.
> + */
> +
> +#include <linux/iopoll.h>
> +#include <linux/mfd/ocelot.h>
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
> +#define OCELOT_EXT_MEM_INIT_SLEEP_US	1000
> +#define OCELOT_EXT_MEM_INIT_TIMEOUT_US	100000
> +
> +#define OCELOT_EXT_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
> +					 OCELOT_PORT_MODE_QSGMII)

There are places where OCELOT_EXT doesn't make too much sense, like here.
The capabilities of the SERDES ports do not change depending on whether
the switch is controlled externally or not. Same for the memory init
delays. Maybe OCELOT_MEM_INIT_*, OCELOT_PORT_MODE_SERDES etc?

There are more places as well below in function names, I'll let you be
the judge if whether ocelot is controlled externally is relevant to what
they do in any way.

> +static int ocelot_ext_reset(struct ocelot *ocelot)
> +{
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
> +	err =3D readx_poll_timeout(ocelot_ext_mem_init_status, ocelot, val, !va=
l,
> +				 OCELOT_EXT_MEM_INIT_SLEEP_US,
> +				 OCELOT_EXT_MEM_INIT_TIMEOUT_US);
> +

I think you can eliminate the newline between the err assignment and
checking for it.

> +	if (IS_ERR_VALUE(err))
> +		return err;
> +
> +	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1)=
;
> +}
> +
> +static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
> +					unsigned long *supported,
> +					struct phylink_link_state *state)
> +{
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	struct dsa_switch *ds =3D felix->ds;
> +	struct phylink_config *pl_config;
> +	struct dsa_port *dp;
> +
> +	dp =3D dsa_to_port(ds, port);
> +	pl_config =3D &dp->pl_config;
> +
> +	phylink_generic_validate(pl_config, supported, state);

You could save 2 lines here (defining *pl_config and assigning it) if
you would just call phylink_generic_validate(&dp->pl_config, ...);

> +}
> +
> +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> +					     struct resource *res)
> +{
> +	return dev_get_regmap(ocelot->dev->parent, res->name);
> +}

I have more fundamental questions about this one, which I've formulated
on your patch 7/8. If nothing changes, at least I'd expect some comments
here explaining where the resources actually come from, and the regmaps.

> +static const struct of_device_id ocelot_ext_switch_of_match[] =3D {
> +	{ .compatible =3D "mscc,vsc7512-ext-switch" },

I think I've raised this before. How about removing "external" from the
compatible string? You can figure out it's external, because it's on a
SPI bus.

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
> +module_platform_driver(ocelot_ext_switch_driver);=
