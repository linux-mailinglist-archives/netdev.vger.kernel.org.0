Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80B31D806
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBQLPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:15:16 -0500
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:48294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230131AbhBQLPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 06:15:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKH1kFD3U9UFuXjp1nrrCwy1GxUsOJKpmej0qgeaYR9pr191UFvBiuTriSCwInzv2qAl+GKK+oAm0F6RaektU7rYXhiJ/PCSFVUpzQsg7LJDeT5+2wHHrQcn5atgeXJt//DEC7WdPBkDNSKne6X/PaM3knPG+IL3SP/EUUP1VRSkqHpJuv07PLO1xPEMM+hW8ARqt43K95uCU5rNe30Q2KbG6VY/VTAaZQTKP4wfyD7RwZxkxaNZf8oWSMhbGFXF9L5C92c1c4/79orVFdGIqcM7V8k1Z98oY5Q8C43XA9VuiHgfk1ZTpjU+D3VLY68/79NXJ+EwUi45q/nLWfd+NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U78dloJtPyfgGT/aDmLOkmbROcBEVj9Xn9DKVkF4mVI=;
 b=RkfJThs1pP0l9LmEEp0IovPzuUqAvuR+LJrfxKrJgPa89Q9FQ+m93nIkuTElk2B5JjcuzaioKVF1h5/yjvsn/JvuRB3gja3BenXQ1leh4DdlR4YrF+b8NnxkBwDyMXQwg+t0sojowcI+iAQS3pwOXEu89xwFN1Ls91NHeEiDmX5rGzOn84h3sAPLOp8RN7MRazV1ihMZv3pZvzOkGXWefevfpxPyl1I3wBWenHAdbukGU0POPeTK3F/rPW/ofGOOvnOVbNJ3T/M5Nat4Kiucy/x6+dAkxjIKjAPwriTVbjpFhft4PD+YWUNLSCPpROJmgA3yu7amz1awDvIP941xLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U78dloJtPyfgGT/aDmLOkmbROcBEVj9Xn9DKVkF4mVI=;
 b=smuYRyPnKlznneDrsdY+70MAZGu3oXpWplfZyDJklILKMeXrq2nayo3LFDx7X/DNw258n4lRqBOTFOwU8ng6UtDcMX+SMkzg2SCoJ0yc2P+pwYH8kJFfE6GEnKWdtFSXcOfv7Lj7qLJ2MM8kFGy5s3D63iyvnXibPuIbofN75XM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 11:14:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 11:14:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 6/8] net: mscc: ocelot: Add support for MRP
Thread-Topic: [PATCH net-next v4 6/8] net: mscc: ocelot: Add support for MRP
Thread-Index: AQHXBKzGJ1Wg4iFy80u6LZWFFkYv5KpcMq+A
Date:   Wed, 17 Feb 2021 11:14:12 +0000
Message-ID: <20210217111411.plsod67qdzb5ybpm@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-7-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-7-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2d2efa8-74ad-4996-8f0d-08d8d33527b2
x-ms-traffictypediagnostic: VI1PR04MB6942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6942067A4AEEB0183C22B4AAE0869@VI1PR04MB6942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: za6MjXhseL6c4NVxaPPhnE6QFw1xwjgkcYizGHFG7rcVipyF/Tyg7hGDeibwa2Co1778l487I3555XjkReSNwH4k5Vyg7QwAFFICpcuVgs2EgaVt6ycZvYOzYcJBnFR4X2h55lG0IPXoX23OcD8i4Ea8WnG5NAHqL81qbBFo3k5tBw4v7gnmZDEsp3GYvDWPbJ9JTKnmRqbsphMjy9BT5jHFGgTY4NVWQwReJ5gkeeFYjJ0cRsoa2y6FHEEvpNQ/awYVRz+sD/tNJ1C8IApirrK0lSK4TgamJ6XxOxrY8pZxL4JKabGGQntU0i3Rr770xWSuIySZDUhoiJdtpzNwSxxXUbb3x736R//MiPFYrvvoHkVFzVd9S/Iqkn4cy/XXsR5B2s130v0VlFACZy7C+0qII00THRdbFwOWMqgTYcnPSHf0ZCLC1JbyqMVfJSQyI8tR0MVgTWcF29Cau5X769DTWGYCJs9uWQ8DCuKtd9A102F1cGhs506lF3u0PSPmNO1tGWUfo2ua5DUc00QLYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(66446008)(76116006)(316002)(64756008)(91956017)(6506007)(478600001)(66946007)(33716001)(1076003)(66556008)(54906003)(9686003)(44832011)(66476007)(71200400001)(6512007)(83380400001)(6486002)(30864003)(186003)(5660300002)(8676002)(8936002)(26005)(6916009)(7416002)(86362001)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CWvTGMvy6Ulfl9v443rAsk+ke6LdrRj/VNMQcU6NhJj195iKOrRswn0rF2+5?=
 =?us-ascii?Q?3k6SsHQ7cNeFRDbpUYj13Uz2iYdRHdh/nAAM9AHI5EcGTX1xWeVJiUX0R5FC?=
 =?us-ascii?Q?ZKxq5DI8Lypt121L3H8VtVGUXi6kQgKBMaemDpgL17SQ9Ot1V9dQSgphV2rB?=
 =?us-ascii?Q?1GCyKA0ZiqF93/yVqAyP3Au3HNBncrGV8GgryE8Iad5WGVMBfRXhIiGP2rDE?=
 =?us-ascii?Q?b4oh6vcx0s0rCorBhU0p5u55cIv1kDHIVmN8CtukqffdrWsHo7yIyM5LbKSq?=
 =?us-ascii?Q?REJekGWyUSEmhSRFc5ebsCMwTUeDOB1BcswOmEcsLUnEQPHn3c5o+CCzAJIe?=
 =?us-ascii?Q?FlYM6ZVkYg8Mts9lajuJ1Y1MJBFZc5bkLyoNFpxXavSP9uabAL43hRmKXV0Q?=
 =?us-ascii?Q?TgKIhmDZz2+eARY3XcQXUghNxYiIvPCI/MpRFhJyPOFlzRD1TyD6Cpu+tCjN?=
 =?us-ascii?Q?CmPV7F1IFwFa3Ao1HRZecHClhnjtTXSgGMzLxO5SOtmhA49hryTd76jR94ZC?=
 =?us-ascii?Q?ZBxg5cPELGcZS8gsnMuRzDj8Rv5NQQXq2css3SrM7u1WKsnzxIYAXwvgMCnV?=
 =?us-ascii?Q?6+X/5skcK38cGrAnNSjN4GbH597LBznxuD/kJjKIdP6hQ3dEH8sPd3h9AbsO?=
 =?us-ascii?Q?JxeVeZ9EEOo1NHC2fFmz0aiBIIwnnWPPB9T8L+lNiSa68QjLcKjwyRHC+8GM?=
 =?us-ascii?Q?Uf6inq9PYeBed8W2YUvIGbrI44wlU/lVTGYpAa3vZak/1vIOZTAaYwZvTukv?=
 =?us-ascii?Q?7JcMJ0ZJ3loCfRr5NRp9AvwTikYcF9zYgG4dc6izzrlifoFy9NGsGexAvjye?=
 =?us-ascii?Q?wAjlYnSFNxk69+SSM5stYZbPe3G3Dd9gzhrOVecMD2+m7CuhDKVLqiUic4U0?=
 =?us-ascii?Q?yaIODeUqc4NF6ZpjO2jrBuYkWoO8LSViFaqFUCbYhvLlKOTTSmOAFuRXNHUl?=
 =?us-ascii?Q?dI4CuXFj+j9i7pCMJkFcY6ckqA+2a7X3OuHYRC670grQaqfs1GldwlDEDJGt?=
 =?us-ascii?Q?UBuI0nGjzCdMtTMnrCj15EB5dpOIseiLXAcVP30zdnaKWpkwFPGIkO2c3vp4?=
 =?us-ascii?Q?lL76IWX9H9vhdV0Rn+gsYiAK0/AE79PLohdUz9K3U5i+tq503u++PAoV5nL3?=
 =?us-ascii?Q?Vk3eUlpiq7TtGROKgTpH68K2Bp7TrZAet5343eSUf5Sa0isZpBV/rNH3NAlj?=
 =?us-ascii?Q?QiW4PL0Qv0vb0xIcXJ2I6Z9BAR70I7r+sdzfgsEwHQ2ay16GfwyNXCyslEE4?=
 =?us-ascii?Q?4SyDXsAzR3UUPcloZCI4aaZarRzWbWX1zAe8V8OpdOu1LJAQxvpF4DNg4O15?=
 =?us-ascii?Q?PT5kdUGVPbW5/14mzyo/epu1?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B1B2842074C6940ACBAEE144DEED300@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d2efa8-74ad-4996-8f0d-08d8d33527b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 11:14:12.4076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9HchOMGLq1OLdIWrKhPcU89Mtx5oypG33KCcUFRz2SkR2OQtcZj3TbQvefaL4UMhxZ7VvoPK8SEuOOAnlEy9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:42:03PM +0100, Horatiu Vultur wrote:
> Add basic support for MRP. The HW will just trap all MRP frames on the
> ring ports to CPU and allow the SW to process them. In this way it is
> possible to for this node to behave both as MRM and MRC.
>=20
> Current limitations are:
> - it doesn't support Interconnect roles.
> - it supports only a single ring.
> - the HW should be able to do forwarding of MRP Test frames so the SW
>   will not need to do this. So it would be able to have the role MRC
>   without SW support.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/mscc/Makefile     |   1 +
>  drivers/net/ethernet/mscc/ocelot.c     |  10 +-
>  drivers/net/ethernet/mscc/ocelot_mrp.c | 175 +++++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_net.c |  60 +++++++++
>  include/linux/dsa/ocelot.h             |   5 +
>  include/soc/mscc/ocelot.h              |  45 +++++++
>  6 files changed, 295 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_mrp.c
>=20
> diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/ms=
cc/Makefile
> index 346bba2730ad..722c27694b21 100644
> --- a/drivers/net/ethernet/mscc/Makefile
> +++ b/drivers/net/ethernet/mscc/Makefile
> @@ -8,6 +8,7 @@ mscc_ocelot_switch_lib-y :=3D \
>  	ocelot_flower.o \
>  	ocelot_ptp.o \
>  	ocelot_devlink.o
> +mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) +=3D ocelot_mrp.o
>  obj-$(CONFIG_MSCC_OCELOT_SWITCH) +=3D mscc_ocelot.o
>  mscc_ocelot-y :=3D \
>  	ocelot_vsc7514.o \
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 5d13087c85d6..46e5c9136bac 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -687,7 +687,7 @@ static int ocelot_xtr_poll_xfh(struct ocelot *ocelot,=
 int grp, u32 *xfh)
>  int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff=
 **nskb)
>  {
>  	struct skb_shared_hwtstamps *shhwtstamps;
> -	u64 tod_in_ns, full_ts_in_ns;
> +	u64 tod_in_ns, full_ts_in_ns, cpuq;
>  	u64 timestamp, src_port, len;
>  	u32 xfh[OCELOT_TAG_LEN / 4];
>  	struct net_device *dev;
> @@ -704,6 +704,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int =
grp, struct sk_buff **nskb)
>  	ocelot_xfh_get_src_port(xfh, &src_port);
>  	ocelot_xfh_get_len(xfh, &len);
>  	ocelot_xfh_get_rew_val(xfh, &timestamp);
> +	ocelot_xfh_get_cpuq(xfh, &cpuq);
> =20
>  	if (WARN_ON(src_port >=3D ocelot->num_phys_ports))
>  		return -EINVAL;
> @@ -770,6 +771,13 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int=
 grp, struct sk_buff **nskb)
>  		skb->offload_fwd_mark =3D 1;
> =20
>  	skb->protocol =3D eth_type_trans(skb, dev);
> +
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	if (skb->protocol =3D=3D cpu_to_be16(ETH_P_MRP) &&
> +	    cpuq & BIT(OCELOT_MRP_CPUQ))
> +		skb->offload_fwd_mark =3D 0;
> +#endif

Same comment as in DSA, it sounds simpler to me to just do:

	if ((ocelot->bridge_mask & BIT(src_port)) &&
	    !(cpuq & BIT(OCELOT_MRP_CPUQ)))
		skb->offload_fwd_mark =3D 1;

When we add support for more packet traps, this check will be more
amortized anyway.

> +
>  	*nskb =3D skb;
> =20
>  	return 0;
> diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/etherne=
t/mscc/ocelot_mrp.c
> new file mode 100644
> index 000000000000..683da320bfd8
> --- /dev/null
> +++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Microsemi Ocelot Switch driver
> + *
> + * This contains glue logic between the switchdev driver operations and =
the
> + * mscc_ocelot_switch_lib.

Wrong, this _is_ part of the mscc_ocelot_switch_lib. Which is also the
reason why some of the code below will not work.

> + *
> + * Copyright (c) 2017, 2019 Microsemi Corporation
> + * Copyright 2020-2021 NXP Semiconductors
> + */
> +
> +#include <linux/if_bridge.h>
> +#include <linux/mrp_bridge.h>
> +#include <soc/mscc/ocelot_vcap.h>
> +#include <uapi/linux/mrp_bridge.h>
> +#include "ocelot.h"
> +#include "ocelot_vcap.h"
> +
> +static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
> +{
> +	struct ocelot_vcap_block *block_vcap_is2;
> +	struct ocelot_vcap_filter *filter;
> +
> +	block_vcap_is2 =3D &ocelot->block[VCAP_IS2];
> +	filter =3D ocelot_vcap_block_find_filter_by_id(block_vcap_is2, port,
> +						     false);
> +	if (!filter)
> +		return 0;
> +
> +	return ocelot_vcap_filter_del(ocelot, filter);
> +}
> +
> +int ocelot_mrp_add(struct ocelot *ocelot, int port,
> +		   const struct switchdev_obj_mrp *mrp)
> +{
> +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> +	struct ocelot_port_private *priv;
> +	struct net_device *dev;
> +
> +	if (!ocelot_port)
> +		return -EOPNOTSUPP;
> +
> +	priv =3D container_of(ocelot_port, struct ocelot_port_private, port);
> +	dev =3D priv->dev;

No, no, no.
The struct net_device registered by DSA uses a netdev_priv of
struct dsa_slave_priv. You can't just go ahead and assume that the
caller of this function uses struct ocelot_port_private.

Please go to struct ocelot_port and add:
	bool is_mrp_primary;
	bool is_mrp_secondary;

and replace the checks for a net_device with bools.

> +
> +	if (mrp->p_port !=3D dev && mrp->s_port !=3D dev)
> +		return 0;
> +
> +	if (ocelot->mrp_ring_id !=3D 0 &&
> +	    ocelot->mrp_s_port &&
> +	    ocelot->mrp_p_port)
> +		return -EINVAL;
> +
> +	if (mrp->p_port =3D=3D dev)
> +		ocelot->mrp_p_port =3D dev;
> +
> +	if (mrp->s_port =3D=3D dev)
> +		ocelot->mrp_s_port =3D dev;
> +
> +	ocelot->mrp_ring_id =3D mrp->ring_id;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_mrp_add);
> +
> +int ocelot_mrp_del(struct ocelot *ocelot, int port,
> +		   const struct switchdev_obj_mrp *mrp)
> +{
> +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> +	struct ocelot_port_private *priv;
> +	struct net_device *dev;
> +
> +	if (!ocelot_port)
> +		return -EOPNOTSUPP;
> +
> +	priv =3D container_of(ocelot_port, struct ocelot_port_private, port);
> +	dev =3D priv->dev;
> +
> +	if (ocelot->mrp_p_port !=3D dev && ocelot->mrp_s_port !=3D dev)
> +		return 0;
> +
> +	if (ocelot->mrp_ring_id =3D=3D 0 &&
> +	    !ocelot->mrp_s_port &&
> +	    !ocelot->mrp_p_port)
> +		return -EINVAL;
> +
> +	if (ocelot_mrp_del_vcap(ocelot, priv->chip_port))
> +		return -EINVAL;
> +
> +	if (ocelot->mrp_p_port =3D=3D dev)
> +		ocelot->mrp_p_port =3D NULL;
> +
> +	if (ocelot->mrp_s_port =3D=3D dev)
> +		ocelot->mrp_s_port =3D NULL;
> +
> +	ocelot->mrp_ring_id =3D 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_mrp_del);
> +
> +int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
> +			     const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> +	struct ocelot_vcap_filter *filter;
> +	struct ocelot_port_private *priv;
> +	struct net_device *dev;
> +	int err;
> +
> +	if (!ocelot_port)
> +		return -EOPNOTSUPP;
> +
> +	priv =3D container_of(ocelot_port, struct ocelot_port_private, port);
> +	dev =3D priv->dev;
> +
> +	if (ocelot->mrp_ring_id !=3D mrp->ring_id)
> +		return -EINVAL;
> +
> +	if (!mrp->sw_backup)
> +		return -EOPNOTSUPP;
> +
> +	if (ocelot->mrp_p_port !=3D dev && ocelot->mrp_s_port !=3D dev)
> +		return 0;
> +
> +	filter =3D kzalloc(sizeof(*filter), GFP_ATOMIC);
> +	if (!filter)
> +		return -ENOMEM;
> +
> +	filter->key_type =3D OCELOT_VCAP_KEY_ETYPE;
> +	filter->prio =3D 1;
> +	filter->id.cookie =3D priv->chip_port;

You have "port" already. This is also wrong for the reason I stated above:
no "priv" in the common library.

> +	filter->id.tc_offload =3D false;
> +	filter->block_id =3D VCAP_IS2;
> +	filter->type =3D OCELOT_VCAP_FILTER_OFFLOAD;
> +	filter->ingress_port_mask =3D BIT(priv->chip_port);
> +	*(__be16 *)filter->key.etype.etype.value =3D htons(ETH_P_MRP);
> +	*(__be16 *)filter->key.etype.etype.mask =3D htons(0xffff);
> +	filter->action.mask_mode =3D OCELOT_MASK_MODE_PERMIT_DENY;
> +	filter->action.port_mask =3D 0x0;
> +	filter->action.cpu_copy_ena =3D true;
> +	filter->action.cpu_qu_num =3D OCELOT_MRP_CPUQ;
> +
> +	err =3D ocelot_vcap_filter_add(ocelot, filter, NULL);
> +	if (err)
> +		kfree(filter);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(ocelot_mrp_add_ring_role);
> +
> +int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
> +			     const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> +	struct ocelot_port_private *priv;
> +	struct net_device *dev;
> +
> +	if (!ocelot_port)
> +		return -EOPNOTSUPP;
> +
> +	priv =3D container_of(ocelot_port, struct ocelot_port_private, port);
> +	dev =3D priv->dev;
> +
> +	if (ocelot->mrp_ring_id !=3D mrp->ring_id)
> +		return -EINVAL;
> +
> +	if (!mrp->sw_backup)
> +		return -EOPNOTSUPP;
> +
> +	if (ocelot->mrp_p_port !=3D dev && ocelot->mrp_s_port !=3D dev)
> +		return 0;
> +
> +	return ocelot_mrp_del_vcap(ocelot, priv->chip_port);
> +}
> +EXPORT_SYMBOL(ocelot_mrp_del_ring_role);
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index 6518262532f0..12cb6867a2d0 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1010,6 +1010,52 @@ static int ocelot_port_obj_del_mdb(struct net_devi=
ce *dev,
>  	return ocelot_port_mdb_del(ocelot, port, mdb);
>  }
> =20
> +static int ocelot_port_obj_mrp_add(struct net_device *dev,
> +				   const struct switchdev_obj_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +	int port =3D priv->chip_port;
> +
> +	return ocelot_mrp_add(ocelot, port, mrp);
> +}
> +
> +static int ocelot_port_obj_mrp_del(struct net_device *dev,
> +				   const struct switchdev_obj_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +	int port =3D priv->chip_port;
> +
> +	return ocelot_mrp_del(ocelot, port, mrp);
> +}
> +
> +static int
> +ocelot_port_obj_mrp_add_ring_role(struct net_device *dev,
> +				  const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +	int port =3D priv->chip_port;
> +
> +	return ocelot_mrp_add_ring_role(ocelot, port, mrp);
> +}
> +
> +static int
> +ocelot_port_obj_mrp_del_ring_role(struct net_device *dev,
> +				  const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +	int port =3D priv->chip_port;
> +
> +	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
> +}
> +
>  static int ocelot_port_obj_add(struct net_device *dev,
>  			       const struct switchdev_obj *obj,
>  			       struct netlink_ext_ack *extack)
> @@ -1024,6 +1070,13 @@ static int ocelot_port_obj_add(struct net_device *=
dev,
>  	case SWITCHDEV_OBJ_ID_PORT_MDB:
>  		ret =3D ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
> +	case SWITCHDEV_OBJ_ID_MRP:
> +		ret =3D ocelot_port_obj_mrp_add(dev, SWITCHDEV_OBJ_MRP(obj));
> +		break;
> +	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> +		ret =3D ocelot_port_obj_mrp_add_ring_role(dev,
> +							SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -1044,6 +1097,13 @@ static int ocelot_port_obj_del(struct net_device *=
dev,
>  	case SWITCHDEV_OBJ_ID_PORT_MDB:
>  		ret =3D ocelot_port_obj_del_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
> +	case SWITCHDEV_OBJ_ID_MRP:
> +		ret =3D ocelot_port_obj_mrp_del(dev, SWITCHDEV_OBJ_MRP(obj));
> +		break;
> +	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> +		ret =3D ocelot_port_obj_mrp_del_ring_role(dev,
> +							SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
> index c6bc45ae5e03..4265f328681a 100644
> --- a/include/linux/dsa/ocelot.h
> +++ b/include/linux/dsa/ocelot.h
> @@ -160,6 +160,11 @@ static inline void ocelot_xfh_get_src_port(void *ext=
raction, u64 *src_port)
>  	packing(extraction, src_port, 46, 43, OCELOT_TAG_LEN, UNPACK, 0);
>  }
> =20
> +static inline void ocelot_xfh_get_cpuq(void *extraction, u64 *cpuq)
> +{
> +	packing(extraction, cpuq, 28, 20, OCELOT_TAG_LEN, UNPACK, 0);
> +}
> +
>  static inline void ocelot_xfh_get_qos_class(void *extraction, u64 *qos_c=
lass)
>  {
>  	packing(extraction, qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 1f2d90976564..425ff29d9389 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -112,6 +112,8 @@
>  #define REG_RESERVED_ADDR		0xffffffff
>  #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
> =20
> +#define OCELOT_MRP_CPUQ			7
> +
>  enum ocelot_target {
>  	ANA =3D 1,
>  	QS,
> @@ -677,6 +679,12 @@ struct ocelot {
>  	/* Protects the PTP clock */
>  	spinlock_t			ptp_clock_lock;
>  	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
> +
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	u16				mrp_ring_id;
> +	struct net_device		*mrp_p_port;
> +	struct net_device		*mrp_s_port;
> +#endif

I'd rather have this without the ifdeffery, doesn't seem too expensive
to justify compiling it out. We have a 4K array of VLANs in struct
ocelot, for god's sake.=
