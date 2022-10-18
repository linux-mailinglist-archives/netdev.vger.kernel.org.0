Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9911B6024B6
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJRGqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJRGqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:46:00 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2064.outbound.protection.outlook.com [40.107.20.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C99F7C30E;
        Mon, 17 Oct 2022 23:45:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yt2WendOwY5LvDD0i+XZCXfLXL1cYyJyt7QIzMGRgu29XsCPqruYi8NP8h8ekFReYZpBDF3ZF6zFKcPrQJZEeC1r/gDnxIQhlr9dLv9COm0BUQD4RWYq3dLTvQZ10zjuSZzkPVBeCcu9/u3lw4EaT0IcQsj5ZDJg+/Cw5xSLJuQhpBgXlHvAjUa3kXkEuqhc95W7KkuxzpVNcMNKhUwaB7op8VjruThv0vJXC2SRgykTzaKojOINg4rye36fEo4lOU9qbR+FLapX5rpalOU8oaAzNa0vMKaFbnfb66L4UGwtHRdgwxsORM10Cf76k94WyX0p6zZL0UCvYfYG7bvNGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9cVTAcwPTqnIrttdHACckAKJ5EkfiiJPyIfEEMq+2U=;
 b=QGEgaTEWYYYEDCaQG6bB1icLJhwR265E3FNT1/uBw1DkpBeF7FRuPEAYfTWJQrFg4Kk5PbfdQQurGZzgY/X8GC9mN3TMpiNLTGRDacdHNvEO+qvhRrEjDnBm8uEbJ7N0TdGDDjCI0sMTkqGFqIMUM2HTmleLf99SAl+CkJoEEMQX1pkXhjYrmLOGP3xRTRDtnapTodqnGO7VGZ8NebQiTEo95sIVwyyT+nMDNnYn1IrJQjdKy4XnW0cIW06k2Zft/frQrg+6chuTWftF9vr5oafrCQo+Mo4s0Suw7z6aESZVOgk2KgH/ogVTw3D6k3XGbaZ/nViHB5At7Qk9UAeByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9cVTAcwPTqnIrttdHACckAKJ5EkfiiJPyIfEEMq+2U=;
 b=AgRJQ0lq7EPmmWwzauOnyuOOak2K3F3IxK0hu7QqFwQwEbadIacrxXlbYk58SHatRTMu8exvBmXm7qCMgNqhbDAMymU/nogXvkdt2/aP/Zj1jBrV/G8axkH9oAoxu3X1KiRp3vXeIaVurELf1e6wvoU9PWKGfMmJbnDnClfkfJo=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AS8PR04MB8532.eurprd04.prod.outlook.com (2603:10a6:20b:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 06:45:57 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::d607:898d:a3eb:4e06]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::d607:898d:a3eb:4e06%4]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:45:57 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Thread-Topic: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Thread-Index: AQHY4kV4CTBQ6TpejkOf0p9IZqtcYq4TtZCQ
Date:   Tue, 18 Oct 2022 06:45:56 +0000
Message-ID: <AM6PR04MB3976D736CB1EFD55F0224E0BEC289@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
In-Reply-To: <20221017162807.1692691-1-sean.anderson@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|AS8PR04MB8532:EE_
x-ms-office365-filtering-correlation-id: ff898856-0b48-4357-0ea8-08dab0d4691f
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wto+bLbiyfTBuv/9N8c/lLI++UvH/+OWhTO9uDdIzq2k0EfSL3vp82tMRo/WWomhrvPwObgSskDJAWzKaOgNiHCxvOr0/tu7Wt0SgnBYV8U6Jun9CF9+oX2VhKMkNJ0N4cxwu8gpPJyDs7ldTREG1rDomAmc0I7faU2IgBAzmn3RI3Ue366uWmjeByNWecPCbPRJH9YEjlHnDChvXiB5YHjGTw1kUoTesrSOhqLcwk8c7yqQzJmLgJ/KTwHyvYs1upwDqtGU5qJnei1axxlpYP/XQCpq2Y/g8vcwSPGahwJwJRjOIWpLLQvpUeHh8J6rt/ZEhBaBEYjTlUjz0PpHsZT+bSQbD/3ksT0yx19YfiuiWUAIezWUfxXzbGy9NNemim74PwveNwGHslJunw70wQJuVOXUjMy/MzL8mZo1N/vTdtAMfaXAe9ODjqggRUrDF7Dqbjf8WaVLviXymXSPNkdYozG6D4Qgr8RMx1bc5TJn8iJHCpXMUQg4tE9gtXOZheFKTcQnsp5m2oic/AOL/tfw/yxLaQIHabmmYShEoRNn4BDYF3OkVeoknE3XRno29209bksbbnIc0yx+Gp0JsHvKN3dtIBC95gzY+IellvNEVYwscAfXWGXyQzfqD5jWJooakBWaCBaOotunp7HljhNQ+ZHiDeC8ZOhWZFkPRmchcferBX9oQC7sebTJOMGxfrvRWV3BJzesk7z5URKNx950ULMEhLUpCcwJr6WeiqgL607PzD69lgXTMo1gzMiGtrplvHsu3wV2481p1Yl/jQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(38100700002)(38070700005)(86362001)(122000001)(4326008)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(71200400001)(316002)(110136005)(54906003)(44832011)(5660300002)(2906002)(41300700001)(8936002)(52536014)(186003)(83380400001)(478600001)(9686003)(7696005)(6506007)(53546011)(26005)(55016003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gIWs/Oqi72FqMTdmCuKjE4K5LwR+rqjqE1xGxkgOVI0M+b7iWcB0AYDvVM2M?=
 =?us-ascii?Q?2S2H1x905X/rgWOpoEBrnOD90bJ1u0JOWzP5HzasCLUUHAUUYFNNgyKbj1da?=
 =?us-ascii?Q?KOblq/jUCrMYAAuH+an2UIVMFqo+KM54Wgu6X21M5BGZt7LwFtz7DB+rvbWg?=
 =?us-ascii?Q?y5sjjfkyusq5sBa8Pnwa1XXYmaSqeN+p/11YO04SHvBq75wnoiN06Syuecjj?=
 =?us-ascii?Q?RDrG+jdbUoubpseXh+HOwCAND9JdLvBZ7ngkP9L+VkkYwA1nqQHTUJ7RTcHC?=
 =?us-ascii?Q?2RQu/98mDTNPlmDQJgmh0Ogm87rUexmvsWqwBEHYHltw6EDU2Ki/7J37E/vz?=
 =?us-ascii?Q?ebuZJXptUe/M2AAU75veHKRND3EuOnsLIufasQ/SH8/Um+I8/TtAjIceiu3u?=
 =?us-ascii?Q?jTeH2GZY4xs/BUxWNGzvTlIGiOhYeexmSedo9F0ODTGXYsSqPdMULQO1CdRA?=
 =?us-ascii?Q?7OUq4lYmu11/e25YNbXwxVDsrB//EhUNWv7qdeY5ZVLy60xIU5GAbWHTRYP4?=
 =?us-ascii?Q?xGhjoMeKei7y+f5s3qJQY7baKuGwEULQzgOv8ZSfq+BNvBMFvMhc3GjB9XOp?=
 =?us-ascii?Q?qv7l/zNcyhF/FydwR6zPxYOfXP8HeMjAZlyb+h4CC4VF7hyqeBnZypMpXVzA?=
 =?us-ascii?Q?r5mZJmJOkfbQxt0867G5KQmzVCYhT3Y34T2b3b7kryzz4d4t3O2qqyERe/uR?=
 =?us-ascii?Q?IgQ0q0EnwUdJ9GSFDCebkcNz3k1qjMHgQ1Exl2ERhVMyBtKc+AV2bq83et8Y?=
 =?us-ascii?Q?hhpVK+ddjo0XpSwVAfBGc9TrmjZreMrt/cjb04N2s/OGgcSbSOu0eE1kCk9z?=
 =?us-ascii?Q?pJyyq9jM/ovFlQHp33NM/RhgblumKxEN40MFG4LXrCcIqq3q7jVdajBO1wh9?=
 =?us-ascii?Q?yrNJnTwIcgbheRCw783qHBdct5xh7ZU67vSG26H9isIPpBD0OH42D62fmWVu?=
 =?us-ascii?Q?Tj30bT3cwN473WHbJ3WAeBDCt2XoKkn3QF0G4NiVEBWC9/ivWxaOj8Gezj5X?=
 =?us-ascii?Q?Ymw+025PPQzU/dnde4OII6pHXefHiOTiVFtKOn0dkDMoRCm61EjzsD+ZU2US?=
 =?us-ascii?Q?E4hconJxmeeuZF2QHCNiZ0GDwj+UhkQl/pDqTUjRqv+01IjxM4OzUO1sKrHS?=
 =?us-ascii?Q?PH4FT+N22uDV//zlZO62AcX2co/107ZUiVUVQfLaZxAIWE7w+uiJObjTfs3j?=
 =?us-ascii?Q?ttsivi2iPs7DJYBXsVz/aKkTf4mpr4phai+K0Srdvzd8c88K+MrmEKcw+SXG?=
 =?us-ascii?Q?KAgclcoHJNqXXuGZ2+XLeJKtuj24Jvc2W6lnQ2rEzG0PnDM/cJqUxPX9+4nk?=
 =?us-ascii?Q?Y0cjCbG1MSZyJpsVLo4S1WXuFM+zR+onjWIeDZ4TQhw+McTHi17lTe+NdRVs?=
 =?us-ascii?Q?GFz6q+4yDEJ1OCIuq339fnN9KfgqrkkazUNsbYIVWnfojDubwlA748GktzX9?=
 =?us-ascii?Q?pDv0xWF+Kkoh8QPrSjB7aA2Fq8pa4GMswDKUwiwJLsZky0IYccK/WtEp1tUG?=
 =?us-ascii?Q?7oDOJIwm58feGPoN8qutZfntO1VBlgSMkbsLu8LwuHF4tEhsK6n0EOvdESxp?=
 =?us-ascii?Q?HEGe6G4wFBRZxCkaB5bf/iHD3wkW/BWYiwbNawCq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff898856-0b48-4357-0ea8-08dab0d4691f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 06:45:56.9076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBdqOfmFPkxBgP7W+TpaRIQYfOD4i+dKjKEhSQyjdP+ChDCBzC82z011ftRi/BrYir8i2IhLOYTSR1Zs5CLitQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8532
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: 17 October 2022 19:28
> To: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Madalin Bucur <madalin.bucur@nxp.com>;
> Jakub Kicinski <kuba@kernel.org>; Eric Dumazet <edumazet@google.com>;
> Paolo Abeni <pabeni@redhat.com>; Camelia Alexandra Groza
> <camelia.groza@nxp.com>; Geert Uytterhoeven <geert@linux-m68k.org>; Sean
> Anderson <sean.anderson@seco.com>
> Subject: [PATCH net] net: fman: Use physical address for userspace
> interfaces
>=20
> For whatever reason, the address of the MAC is exposed to userspace in
> several places. We need to use the physical address for this purpose to
> avoid leaking information about the kernel's memory layout, and to keep
> backwards compatibility.
>=20
> Fixes: 262f2b782e25 ("net: fman: Map the base address once")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c       |  4 ++--
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c |  2 +-
>  drivers/net/ethernet/freescale/fman/mac.c            | 12 ++++++------
>  drivers/net/ethernet/freescale/fman/mac.h            |  2 +-
>  4 files changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 31cfa121333d..fc68a32ce2f7 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -221,8 +221,8 @@ static int dpaa_netdev_init(struct net_device *net_de=
v,
>  	net_dev->netdev_ops =3D dpaa_ops;
>  	mac_addr =3D mac_dev->addr;
>=20
> -	net_dev->mem_start =3D (unsigned long)mac_dev->vaddr;
> -	net_dev->mem_end =3D (unsigned long)mac_dev->vaddr_end;
> +	net_dev->mem_start =3D (unsigned long)priv->mac_dev->res->start;
> +	net_dev->mem_end =3D (unsigned long)priv->mac_dev->res->end;
>=20
>  	net_dev->min_mtu =3D ETH_MIN_MTU;
>  	net_dev->max_mtu =3D dpaa_get_max_mtu();
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> index 258eb6c8f4c0..4fee74c024bd 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> @@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
>=20
>  	if (mac_dev)
>  		return sprintf(buf, "%llx",
> -				(unsigned long long)mac_dev->vaddr);
> +				(unsigned long long)mac_dev->res->start);
>  	else
>  		return sprintf(buf, "none");
>  }
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c
> b/drivers/net/ethernet/freescale/fman/mac.c
> index 7b7526fd7da3..65df308bad97 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -279,7 +279,6 @@ static int mac_probe(struct platform_device *_of_dev)
>  	struct device_node	*mac_node, *dev_node;
>  	struct mac_device	*mac_dev;
>  	struct platform_device	*of_dev;
> -	struct resource		*res;
>  	struct mac_priv_s	*priv;
>  	struct fman_mac_params	 params;
>  	u32			 val;
> @@ -338,24 +337,25 @@ static int mac_probe(struct platform_device *_of_de=
v)
>  	of_node_put(dev_node);
>=20
>  	/* Get the address of the memory mapped registers */
> -	res =3D platform_get_mem_or_io(_of_dev, 0);
> -	if (!res) {
> +	mac_dev->res =3D platform_get_mem_or_io(_of_dev, 0);
> +	if (!mac_dev->res) {
>  		dev_err(dev, "could not get registers\n");
>  		return -EINVAL;
>  	}
>=20
> -	err =3D devm_request_resource(dev, fman_get_mem_region(priv->fman),
> res);
> +	err =3D devm_request_resource(dev, fman_get_mem_region(priv->fman),
> +				    mac_dev->res);
>  	if (err) {
>  		dev_err_probe(dev, err, "could not request resource\n");
>  		return err;
>  	}
>=20
> -	mac_dev->vaddr =3D devm_ioremap(dev, res->start, resource_size(res));
> +	mac_dev->vaddr =3D devm_ioremap(dev, mac_dev->res->start,
> +				      resource_size(mac_dev->res));
>  	if (!mac_dev->vaddr) {
>  		dev_err(dev, "devm_ioremap() failed\n");
>  		return -EIO;
>  	}
> -	mac_dev->vaddr_end =3D mac_dev->vaddr + resource_size(res);
>=20
>  	if (!of_device_is_available(mac_node))
>  		return -ENODEV;
> diff --git a/drivers/net/ethernet/freescale/fman/mac.h
> b/drivers/net/ethernet/freescale/fman/mac.h
> index b95d384271bd..13b69ca5f00c 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.h
> +++ b/drivers/net/ethernet/freescale/fman/mac.h
> @@ -20,8 +20,8 @@ struct mac_priv_s;
>=20
>  struct mac_device {
>  	void __iomem		*vaddr;
> -	void __iomem		*vaddr_end;
>  	struct device		*dev;
> +	struct resource		*res;
>  	u8			 addr[ETH_ALEN];
>  	struct fman_port	*port[2];
>  	u32			 if_support;
> --
> 2.35.1.1320.gc452695387.dirty

Thanks for the fix,

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>=20
