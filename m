Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D568146849D
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 13:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344289AbhLDMED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 07:04:03 -0500
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:23379
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234627AbhLDMEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 07:04:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eszbhlmts13o7b+Ssp3anIKRk3iAZZds+HUXhCZ8hTBzX7OLzHByYz/tS3J1B/cxvFujZefWgh5BK8weaWpIrfaeZb8mrRzstKBPULus6IQ/F87SWkrlEVdeQHIkEyqAsg4RbYiOX02ZsDEEUc9i66wAPOBTM9Kum3wFaUOwrOtx/Rm2bhbpsNXlo849VfvlX9zNO6+cSitplR8BBI6shvGckKQUDfbC4AQCm5CdnAtLorA4VpLTYB5XMW0sPYvCUcasXcDsaspmJ3hPLJCN48QytCcWjvLJ6K4vEjeIfoJ+Bu9YnkGO8rk9L6XxMGlUZuQiYWDsqOFu6RBGrzrfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCkjyoHLcdk2/TyYG0VAqawJVQd9KGJwpY3hG1JFKCE=;
 b=VAS9SNU4hemL60THB2eJAweoT2ZU1dxMnvHvp51uioK8vbil85VuNfU733/bdfi3A/SmKXQlyT7KQJOixGXjDoJ8Rx85cA92/unzL15e41ULtq10RwOE7VpfgpztDPJfI0OH8PtOYVozDhe+LWm0MiJGxNlvyPeW8qdrlIwpvCER+XrpMjPnoQpJI7srWYUrXXFcwkCh+Tfl76V9jIh8vyjyLi8whPp90+pJWvNrRfPb7DccY4QETYvKk91T5/0gZIIlIxIk8JxW0ASVg5VDQasNV7e6m5coBF/TJLUdXwbr4kY/7Ynh1p81384BmqGwx2SBu7pky27ticTNoUKaew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCkjyoHLcdk2/TyYG0VAqawJVQd9KGJwpY3hG1JFKCE=;
 b=Pjv4L4fZDMjSm1LsbUqZDXeeGA4qTzjttq4yxRK/dYAng0t3snCvHSisioVapzcmhaazgbHLNWndVMWNhwjZOyY6w5Qh6C4MaiYCsU/SQf6YznoKGE4+02XE8wHpwBziT06P8DBN6X+xiQ3A9082TiJYAcvSDlkP8rR+/vyaQBc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 12:00:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 12:00:28 +0000
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
        Russell King <linux@armlinux.org.uk>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 net-next 4/5] net: mscc: ocelot: split register
 definitions to a separate file
Thread-Topic: [PATCH v2 net-next 4/5] net: mscc: ocelot: split register
 definitions to a separate file
Thread-Index: AQHX6KpvFCgGsEi6gkyWUdzaZYVwl6wiO7iA
Date:   Sat, 4 Dec 2021 12:00:28 +0000
Message-ID: <20211204120027.vov363wzmk6yngbz@skbuf>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
 <20211204010050.1013718-5-colin.foster@in-advantage.com>
In-Reply-To: <20211204010050.1013718-5-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 094c2b97-13e6-4e30-33a3-08d9b71daa0a
x-ms-traffictypediagnostic: VI1PR0402MB2800:
x-microsoft-antispam-prvs: <VI1PR0402MB280018DD24D03F79A6F61BF0E06B9@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hGBNJZrK9N2kPucJo0RTkbDz7cg6OnAip+4zpHhFRefhuDSRJerSG0rnOm22iQFhXu/3cAK8RGboTi7mmQZcAMWbQwS0Ay9h4A922T0nnkfKyZO4KQPOd9/o/1QszkPnQMHeqCUehWcDLvuaoYQ2K8DG0ru7V+PJ29FrfJsU+ckDeTimQicpLlB5MsWo22Cz+HoUjcNVAd3NrOh2OVLE2CIuZ65lbTXECMoLw3RCatEDmd17aqxkQcrtSWuSYCKcYPozqLPyXE14tkcHEAhxbhGYUthfawM7rU+tTbEXnL33IqlU013H3YR1blu1do7tDdFLhATQZZYxQtQWyIuztP/+JjcVej42eM0S1G0Xd6nj450uVapF/z6/PGugUjBj74uECq8f807kGDAZcwIXMpoi1Scnk3HAS9GBvNTMuMiO8kNkiORZpgRY6Gnq+pNtL5tj7PeWtTTfyRXOt2iyjQfAaoKPyUbwOZcasNvJmSqrbZTnAgQeKg30BKwuqv0GEmYs+CFqvxAo/aSlJalMaJKigomgPrHQ5q6J40+JX74+m0G6ldmBs/0wpQYoq80xQ48ZsLQhcNQn8LP8HIUt4G5qCFI4GP6r6MDUi1qBKDKq6RelZJWF5fVLs/D1qbGYTRI6xlLHdR4eh+mPB3TMxZD9zzCIR5o9i/539CH6KvbKv9rjDfgnLGFC9rC2JefXytsoQOy7fF5L420PkBE1NQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(44832011)(91956017)(7416002)(76116006)(66946007)(316002)(66556008)(64756008)(86362001)(66476007)(66446008)(83380400001)(8936002)(4326008)(6916009)(8676002)(54906003)(1076003)(5660300002)(33716001)(26005)(6506007)(2906002)(38100700002)(6486002)(508600001)(186003)(122000001)(9686003)(966005)(71200400001)(38070700005)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EdUWh+TQNSVtVXzFQzUHXTwf8xgV88rLOBm+57cVNs14wvP1KnuCcOCKeTtM?=
 =?us-ascii?Q?tphzTA+sKmqgo6aCevOHmQtfuIgCXeVI8AVvpDkuoYEv5RgzaWTTdEdR2YdX?=
 =?us-ascii?Q?zuzf9qChY0b4hPUrNMdCUJLvmZzR5J91QRVzlpmRWlazvFXLTv1g5ZvOP6Kr?=
 =?us-ascii?Q?oKjRvWCNNmN3+5QbGiGRxIbWnds2A0LZcgi67aAPDy43ZYnR9LssTfjUmzMC?=
 =?us-ascii?Q?uvoDa37Ua347C5b7SMuDfsS43UljACymMfvXWVJxVDxffVa5jhMcvZ50zaLt?=
 =?us-ascii?Q?QWJ8tS+BbllPXmp+k69xxzHTSLcZH4OWUhb0EodOshC1sfEpw0aZucKgnNMf?=
 =?us-ascii?Q?mBd3JYZfVfL3WjCnoTaJzaq99Ei4FLU603mVfgew6ApwrzkGW+iseq9ajU5k?=
 =?us-ascii?Q?XqcGIHuX0xbQIGBPFNITlu3asgSvjSS5Vn/MPZCVIcuAly8VdTb8sMIOo7lR?=
 =?us-ascii?Q?vw3SoqW3mym+JJTzXI2w0CfQv6s4bzoygEG9gl3ftjqMNq08UyUAJsdG5JYP?=
 =?us-ascii?Q?Aglssw39QSr6W4mfAKthTKrcZUxDVE+o2DwUI8x0M2XzHcvI4O8uE1GIm0Y9?=
 =?us-ascii?Q?m5PknEnkQD4LRxxWP1if9uSDzsZkbDIBFffa7WsBNHUxU59jI9fs1/LsmJ/w?=
 =?us-ascii?Q?e+nwuc8+awr103p1rVxSnole46QmZCnDfNqIgcNURYEPBuK2G8Jiol+o3R7Q?=
 =?us-ascii?Q?lfV8QZLLhZTnRpZFIHs0zQUrpSaB04yxfxCK1Ia7ONoYMpdvrKJdMdw3qpIU?=
 =?us-ascii?Q?Alo7PUkMwsG21HLZMnSzNZvoMz/dnDesFP+XL7nzLQx3sWE5XBjezOyfaIJj?=
 =?us-ascii?Q?RZnVW/RoARJj0npciv4giTOhx/gpFHNA7fCYaJXxgo8lxif58y8SKzUIetIN?=
 =?us-ascii?Q?EuNlTsrFvAzl/crnRPGeu0zkpvUfAb7JOvXJxaSlhMS10ELz90v6gpZcybXl?=
 =?us-ascii?Q?vsSfIj+UG7qOQBE6Nv/0+fT4hw8CiqWOblApKbTdwDaKRfULoYT1U+zmdMay?=
 =?us-ascii?Q?5wxDAzwTLsGAP7mN1tg5K81ju0Hmq0KBnXs9UdkBm7pnIVR3BcV030yTLbCJ?=
 =?us-ascii?Q?xaMOq0bBNQtrjp8TeGPi8vqs+lIw/sVyrCbVOTN/s2NWbuPlHuI0ZWfzJizO?=
 =?us-ascii?Q?VHFDFQ4IL7BvpOIGxv2fxhdmB4XxZS50ZlHZDVXt8Vxc/+D0HpMxiNu9izKq?=
 =?us-ascii?Q?ucHaQArichXioCOQiED3mf6q7LvNcOh//8WooU5mjXIURTiyTsL5zXDU9eGe?=
 =?us-ascii?Q?14s1HGbuWYo2g/FD8mdC1oTI7CtDbPxQmWnCb26SfrRl32j6G9KmizkEncN9?=
 =?us-ascii?Q?IzNfHAcf4yGGc45WscrbBdsYOkUFUit8g8/lD8aHCQ6Iv8hGsV3B3PZalkV4?=
 =?us-ascii?Q?ki6cfkil4lCQZfFAZISGzGB9j2SUZhaPLBTQWGMLhYgV+HhEc4Bax/e0pDHr?=
 =?us-ascii?Q?iwxUubfK37o2JOHPRTAmC31fYG5mBOqLcIF/EeHI9SvQZHQ+g7+ZU9CmAI24?=
 =?us-ascii?Q?P/tE1BEKygu8h3Zd+vYukcrzW8ZpwvHEaqQmt4sOFzc14jo7ivwc24PXOGBz?=
 =?us-ascii?Q?x/g6vIRl/9bpGymQIZQpm2r3U3t+DdCmI3e3WpO0Vm3+9PjVKRiRql23oU4M?=
 =?us-ascii?Q?enNDHlj4GWxV3PgnMmKB1ks=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74FE4A84F4835D43B2B42D31421CB254@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094c2b97-13e6-4e30-33a3-08d9b71daa0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 12:00:28.2959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 271xGjGel0BRUtA0BZLvwM5LYSsTN83bVs1WtaozGHf48H/0OXhFt8u61z5KKPqimvx6uRwjjg7bfH2K5bvIkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 05:00:49PM -0800, Colin Foster wrote:
> Move these to a separate file will allow them to be shared to other
> drivers.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reported-by: kernel test robot <lkp@intel.com>

I wouldn't keep the "Reported-by" tag in this case.

> ---
>  drivers/net/ethernet/mscc/Makefile         |   3 +-
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 520 +-------------------
>  drivers/net/ethernet/mscc/vsc7514_regs.c   | 522 +++++++++++++++++++++
>  include/soc/mscc/vsc7514_regs.h            |  27 ++
>  4 files changed, 562 insertions(+), 510 deletions(-)
>  create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
>  create mode 100644 include/soc/mscc/vsc7514_regs.h
>=20
> diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ether=
net/mscc/vsc7514_regs.c
> new file mode 100644
> index 000000000000..b041756d1b78
> --- /dev/null
> +++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
> @@ -0,0 +1,522 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Microsemi Ocelot Switch driver
> + *
> + * Copyright (c) 2017 Microsemi Corporation
> + * Copyright (c) 2021 Innovative Advantage
> + */
> +#include <soc/mscc/ocelot_vcap.h>

With Jakub's comment to add an include here (which is to resolve these
warnings):
https://patchwork.hopto.org/static/nipa/590203/12656181/build_32bit/stderr
it looks fine, so please change this and then add my:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
