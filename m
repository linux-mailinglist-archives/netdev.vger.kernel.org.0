Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866A0316399
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhBJKVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:21:08 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:60071
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230295AbhBJKSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 05:18:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3KfUygKdo/W8oH6ZnUgIAoYGqcD3LDvLkrYimKsnwf0WGmNR5vmJOIFSQ2zodCbNzyCYM3hcbqNAipA/824vX/P7DFn0CZdwKXtJ+vQqJumBtBqOKt3R1w5fghvv9Em1U/JxZLJgBtpX1DviFRkldRS3GaBpUj/qh0pTIfhRn6ivlS/ZNmWPWQFnS18xhOSGC73urj8ZB8G/SlH1Q93J53LKS8bWUC6S7y5tE2b0vDmnQY+38mRGLwZPan0So+isZwthTUjxvsf0WtRnhKkNidv1je4a/gPcCpl4PCIJGpLwdIOSnVZpKrTuxy0+3wV+k/WPZNgkNBzX/LhJb3b9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQqkwuGhjNFmZNNnJKe3Hlp7DMCDgZNrDutJq2Gi424=;
 b=CtaeB6/VgYMBzBeQ9+lbA/T2cdED5/C/TqUcbuhbOpFwMWD28qIQxj6rglQ5uNFf0a4e+9qqF2dVTpGkLGR2NdYJL085LZtP/wsEPpVQXy5kU7Z3+9FIj7DzAyz51wjGE974jMLhTLwex715OE6tM8FJ+f1jjIkNOJzGYevVlUk1zlV5lURC+JK/jnzGfI93F+yMUd8fJTfap1QLzHtpSsENapYiObAJO41+yguzK5TGJcYO7F6e0+Fv5ln7Kmxhd6zivNMKcdmMMGreU67RwW8jlhS+7Rw3qWENkA/wLg88IcdlxU2rwKYxBdqO81c+h71iMAu74NeFY1gEDZvezw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQqkwuGhjNFmZNNnJKe3Hlp7DMCDgZNrDutJq2Gi424=;
 b=UG4QyeqINyGvXpUwzhuQTDeMKsVy+VCPWugyat1TRq/COotvpxYmpx5EjkFOhobfl9LN76T/BIlcHxk3MWkrME1IIaBj40haZkwyAxJcMYRTzBFO6OMdFea9JqaSt4jHQtRJjIDj3kAUDKGx/ZiIATczEHe/Xizknkmmw5PWhVQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3965.eurprd04.prod.outlook.com (2603:10a6:803:3e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 10 Feb
 2021 10:18:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 10:18:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v3 5/5] net: mscc: ocelot: Add support for MRP
Thread-Topic: [PATCH net-next v3 5/5] net: mscc: ocelot: Add support for MRP
Thread-Index: AQHW/yGZdqaCj30jN0m/BawIxR2lh6pRLcMA
Date:   Wed, 10 Feb 2021 10:18:03 +0000
Message-ID: <20210210101802.6ztf6c3ifldfa5fw@skbuf>
References: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
 <20210209202112.2545325-6-horatiu.vultur@microchip.com>
In-Reply-To: <20210209202112.2545325-6-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 963e63e8-1ac6-4a50-8695-08d8cdad268b
x-ms-traffictypediagnostic: VI1PR04MB3965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3965FF3E663D9180E03A9972E08D9@VI1PR04MB3965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1YnUtedK3HGxcAMQ2zCJQ0fY7BByjbTLTUOc3MXGaf8kE6Sw52LDSmZS1FS3OQdLiYlzasLDe9Q4enInpMVFZksJXRQBaG1koxGTI54GjZsm92rx6iMEyYV2ZUmiDW1Bm5VBN/PcMm2XhFmaZlMOJ61LxLObaWLqCuaCLQ4TbVRWWuaDv3spSs5aVulMo59ppYo5lDtV9rJ92TjvTYBGq9IZM4yrSMhFR8F9nA/91H5luVvTWxghTmL/efWBVvE1APtfqZTd2KGzjJiwohxNIBCZc+NHr9RZ1Ee3HB/6l9rhf6oEz4gKJ5eAR6g9icjY7d0sKD4uixisJSsfcSn7JXpnoGAqHNm3SEqSirqRV5IUFHHVan2bcOwutCJu2ZE5qB+7kxn8v6VRRxP99KXxdnfk1c3Sbz52AJIrhT9rWelJz08l35ny2X79gKqAo6bKdTNwD/hcx19Aa2/2PiXn5GubZYXaI/GqU/yHDJQsxC9w+neFAdwnNnYplcT+2IXJ/oBp32IKGJhQmp9/1fKqBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(44832011)(8936002)(7416002)(54906003)(186003)(2906002)(76116006)(66446008)(6486002)(6512007)(478600001)(83380400001)(33716001)(9686003)(6916009)(6506007)(5660300002)(71200400001)(1076003)(66556008)(64756008)(86362001)(66946007)(66476007)(8676002)(26005)(316002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7D7FRo/bE4HBZ/V2jBerlrQ760xo/AVNJ9wTcsPbtggdJYPso4k8eUHjxVor?=
 =?us-ascii?Q?ShW5W4pyy45BmZenvHffHR6y9WPis3TWI9gbgPFJFt117F2NiwAZfHrciK84?=
 =?us-ascii?Q?tV6t+KhEtQ88LilbAZICMk3dd+QxiPvc837sgWgq5ZDqTCNwRfk8jh1hxZ06?=
 =?us-ascii?Q?Hapd6lsQZw8hEdqACJHjb6c9RkkytXj/YtKQi/WIVJZlIh5HFdbqVnb0zZxf?=
 =?us-ascii?Q?p0VRkyOUW6NQRiApe3V0Eq4LEEHx8p8SRY0TmY+4pqgndYt45Lt4vxl6gUSq?=
 =?us-ascii?Q?WvOmFHThHqiJe2CERp/1BcGpB3iAa3OWMF5VGptSi/6GkbgWcCLqGg96I1tz?=
 =?us-ascii?Q?y0YDBGGm+wQ83tx9abo89gct5gHndqNtPrTBseD5HcWM1MhbBlPXnmhLEjtJ?=
 =?us-ascii?Q?2DG0UEE9udnQzfIXi1iXei+ItOKNPsIoy6abcPKVpyf3j4sfTN9kRGP62m1t?=
 =?us-ascii?Q?Yq/eB10seEiFL+jCEbHa6zzEKGE2shIJcsE7PqQEtSOLx6kl5PZ+o9Df+w7O?=
 =?us-ascii?Q?yjh2BzxBnl1f4WE/JGNSBILfOgzlhqzY8wrfn56jUmVg8/oRo+ssFMA/t92V?=
 =?us-ascii?Q?SjJVNO9/rj2hwuHqM3DYzHbM0mu3/28i7GoVncWVSHgizr5q5DbmO4ybbtC4?=
 =?us-ascii?Q?2VPnq91jvV+xQNqiBGqe0Qb+eakiVUncElZ7Yq78aGDCU7vRed632E4cdr/f?=
 =?us-ascii?Q?+XwnTVV7QSIY9ksVykW6TafgyoMgRjZ+brNwZz4JgK2Ijq4FzABIm5KG7Yjv?=
 =?us-ascii?Q?2YA/n/fWgyYSGkE1nNFerleiczoHBeFq5yDTKSzJGLsxgcbj3teUbc8z26E6?=
 =?us-ascii?Q?XzC2Bxz+67gXdeB/k/q/R0JnN12DFHAbsFAkZVdxr3BSDBv6xPtPZYoTEzXv?=
 =?us-ascii?Q?tb8lHt9V20cIloM0EEtrAd/sxCoe8dr1HuPPSBbAYI3vTnFcLW6PpR+1cMai?=
 =?us-ascii?Q?W/4jJNfA5hSEx+67yIcwO/B/bADEJSvEiABSZQHDcd7ThjY+gwbVTb8bdUy2?=
 =?us-ascii?Q?hJqv6R7pi1f+N/kvgzp6o848rq7VT/r4O/tPZvgxKkFXdXA31VEVKXy4/as3?=
 =?us-ascii?Q?Z7WJMDPvrDZQY5HqBRfrWbQt6d0jhaWCkfE8V5wmhllbj7wpQ57VuvhASuuu?=
 =?us-ascii?Q?dg6iGMgDVfAzDE2hBCPcZW8LtOXwSTgB0WRPoQTeNMyKzUgwi4Tfp/zQvn1V?=
 =?us-ascii?Q?fB6zotaNZn3YBmBrMK0+3PDgh/27u7X0eVrSb4Yhyg0aseByUgFZjDCs4kEb?=
 =?us-ascii?Q?A5IheZH3FrSD8C32JJf4pwETQwg76s7qwHaEERHBW8t3BD2r+jCWHvNPzd77?=
 =?us-ascii?Q?sduEPYNP3idOcqpYbybCCfbo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9683A36585C0A94F9DB267C3DCA6B783@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963e63e8-1ac6-4a50-8695-08d8cdad268b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 10:18:03.1730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43MM40FnS1pMm0Pm4QgOs5IiC5Z/D6QXJkX9QnJhxsSGL0tg8PPdtixJoqEzMYJ7io3XoNvUxHQqn9Quw+tvEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Would you mind adding the switchdev MRP support for the DSA driver too,
and move the code to the common ocelot library? I would like to give it
a run. I think that's only fair, since I have to keep in sync the
vsc7514 driver too for features that get added through DSA :)

On Tue, Feb 09, 2021 at 09:21:12PM +0100, Horatiu Vultur wrote:
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
>  drivers/net/ethernet/mscc/ocelot_net.c     | 154 +++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c |   6 +
>  include/soc/mscc/ocelot.h                  |   6 +
>  3 files changed, 166 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index 8f12fa45b1b5..65971403e823 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -9,7 +9,10 @@
>   */
> =20
>  #include <linux/if_bridge.h>
> +#include <linux/mrp_bridge.h>
>  #include <net/pkt_cls.h>
> +#include <soc/mscc/ocelot_vcap.h>
> +#include <uapi/linux/mrp_bridge.h>
>  #include "ocelot.h"
>  #include "ocelot_vcap.h"
> =20
> @@ -1069,6 +1072,139 @@ static int ocelot_port_obj_del_mdb(struct net_dev=
ice *dev,
>  	return ocelot_port_mdb_del(ocelot, port, mdb);
>  }
> =20
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
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
> +static int ocelot_add_mrp(struct net_device *dev,
> +			  const struct switchdev_obj_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
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
> +
> +static int ocelot_del_mrp(struct net_device *dev,
> +			  const struct switchdev_obj_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
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
> +
> +static int ocelot_add_ring_role(struct net_device *dev,
> +				const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +	struct ocelot_vcap_filter *filter;
> +	int err;
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
> +	filter =3D kzalloc(sizeof(*filter), GFP_KERNEL);
> +	if (!filter)
> +		return -ENOMEM;
> +
> +	filter->key_type =3D OCELOT_VCAP_KEY_ETYPE;
> +	filter->prio =3D 1;
> +	filter->id.cookie =3D priv->chip_port;
> +	filter->id.tc_offload =3D false;
> +	filter->block_id =3D VCAP_IS2;
> +	filter->type =3D OCELOT_VCAP_FILTER_OFFLOAD;
> +	filter->ingress_port_mask =3D BIT(priv->chip_port);
> +	*(__be16 *)filter->key.etype.etype.value =3D htons(ETH_P_MRP);
> +	*(__be16 *)filter->key.etype.etype.mask =3D htons(0xffff);
> +	filter->action.mask_mode =3D OCELOT_MASK_MODE_PERMIT_DENY;
> +	filter->action.port_mask =3D 0x0;
> +	filter->action.cpu_copy_ena =3D true;
> +	filter->action.cpu_qu_num =3D 0;
> +
> +	err =3D ocelot_vcap_filter_add(ocelot, filter, NULL);
> +	if (err)
> +		kfree(filter);
> +
> +	return err;
> +}
> +
> +static int ocelot_del_ring_role(struct net_device *dev,
> +				const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
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
> +#endif
> +

Would it make sense for this chunk of conditionally compiled code to
stay in a separate file like ocelot_mrp.c?

>  static int ocelot_port_obj_add(struct net_device *dev,
>  			       const struct switchdev_obj *obj,
>  			       struct netlink_ext_ack *extack)
> @@ -1083,6 +1219,15 @@ static int ocelot_port_obj_add(struct net_device *=
dev,
>  	case SWITCHDEV_OBJ_ID_PORT_MDB:
>  		ret =3D ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	case SWITCHDEV_OBJ_ID_MRP:
> +		ret =3D ocelot_add_mrp(dev, SWITCHDEV_OBJ_MRP(obj));
> +		break;
> +	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> +		ret =3D ocelot_add_ring_role(dev,
> +					   SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> +		break;
> +#endif

I'm not really sure why SWITCHDEV_OBJ_ID_MRP is conditionally defined.
If you look at SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING, that isn't
conditionally defined, even though it depends on CONFIG_BRIDGE_VLAN_FILTERI=
NG
at runtime.

>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -1103,6 +1248,15 @@ static int ocelot_port_obj_del(struct net_device *=
dev,
>  	case SWITCHDEV_OBJ_ID_PORT_MDB:
>  		ret =3D ocelot_port_obj_del_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	case SWITCHDEV_OBJ_ID_MRP:
> +		ret =3D ocelot_del_mrp(dev, SWITCHDEV_OBJ_MRP(obj));
> +		break;
> +	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> +		ret =3D ocelot_del_ring_role(dev,
> +					   SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> +		break;
> +#endif
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/eth=
ernet/mscc/ocelot_vsc7514.c
> index 6b6eb92149ba..96a9c9f98060 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -698,6 +698,12 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, v=
oid *arg)
>  			skb->offload_fwd_mark =3D 1;
> =20
>  		skb->protocol =3D eth_type_trans(skb, dev);
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +		if (skb->protocol =3D=3D ntohs(ETH_P_MRP) &&
> +		    (priv->dev =3D=3D ocelot->mrp_p_port ||
> +		     priv->dev =3D=3D ocelot->mrp_s_port))
> +			skb->offload_fwd_mark =3D 0;
> +#endif

I wonder if you could just reserve a certain CPUQ for trapped traffic,
and just generically check for that, instead of MRP port roles?

>  		if (!skb_defer_rx_timestamp(skb))
>  			netif_rx(skb);
>  		dev->stats.rx_bytes +=3D len;
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index d0d48e9620fb..d95c019ad84e 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -682,6 +682,12 @@ struct ocelot {
>  	/* Protects the PTP clock */
>  	spinlock_t			ptp_clock_lock;
>  	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
> +
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	u16				mrp_ring_id;
> +	struct net_device		*mrp_p_port;
> +	struct net_device		*mrp_s_port;
> +#endif
>  };
> =20
>  struct ocelot_policer {
> --=20
> 2.27.0
> =
