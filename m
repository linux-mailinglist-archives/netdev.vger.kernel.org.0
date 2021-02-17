Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F320931D83A
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhBQL0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:26:30 -0500
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:58074
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231613AbhBQLYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 06:24:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6aUPJe3Sr8PFbIeXPUwth+eulVQvMNrkEoGvH2FWgsH+qqDHLarv5GN+fF1hcAVgRUvq/cIkohhIoczVedzmRiCnVA4VoEPxGNaEs9RDaFzD2Vo+NMJFOl4sMKI57criMBmGukgp3Voxp29YPqbPyGj8nCDRfaStEtPWajQsSWCyoyUDRWy2OId2mvqpiOZS3VNoNVxZjJAySH+8GsfNX62LJ0usLRhNNZkUvUBj+eoP/Im7fh5ECXlQ353U8ugnsdnnN3Puw1IWeawGrdzhsss9JIegvb/qCH4hlkqM4JyxZoTi5K2tz81jwRsISnPh42TQx9x0v1KniEdOkeUsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/aEXQUbrqih7fnqkYtmslFp1Hhl40QN2oBHbhyz044=;
 b=HQSdjgiuFQXk/4NNvtvjm+/lEtM9O2OsDd9yufuKhr2KvD4xMczzk6XaUR2lqeU2YiAidJXHcMPRNMgYb3JhSp+Y3e4w6HSwptmsRMy1gMWGMCYeYv/VBOyW6EvNOmjCsk82SOkDy9MCF73abRgGETJ1ikhywi3lu7BH6JYb8QVyATZUbBVMLWhp1FUGntw5MUPqvOsIYZVzc2XNPV5xRcfN+Qzo9/uijJSWkwsvynGYjLm3SVMr3eSzq+892ci+BbKlIVIpc6BM43ThanciHpMBggVUtGtTgZ4nqoAKIqmtGkyk1gZDfev7Sd+UHVhJojhzQRpngkymWgfMMBGvUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/aEXQUbrqih7fnqkYtmslFp1Hhl40QN2oBHbhyz044=;
 b=FWm0HRA8bDUCAEf9DQYiBKIEQjzXjkPB8husP1K6w0dsMJluIAb4RKzL1f5GqzYQZLo45OZr6WDOsQBMdVJ3vHkoPd02un5w1CEZEwXTBushWrVnwiBWb32iFz4AMt7eQaRDhnjjVwRF7gUu0aBMd3RF14u1/XBm5f1RpulZd1Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3711.eurprd04.prod.outlook.com (2603:10a6:803:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.36; Wed, 17 Feb
 2021 11:23:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 11:23:42 +0000
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
Subject: Re: [PATCH net-next v4 7/8] net: dsa: add MRP support
Thread-Topic: [PATCH net-next v4 7/8] net: dsa: add MRP support
Thread-Index: AQHXBKzLl00K3/1pHkaPz14zGny+PqpcNVUA
Date:   Wed, 17 Feb 2021 11:23:42 +0000
Message-ID: <20210217112340.xxdfvwp3mw52isse@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-8-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-8-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e23bb99-1df8-4a4d-2f6e-08d8d3367b84
x-ms-traffictypediagnostic: VI1PR0402MB3711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37119494E35A740A14ADD84BE0869@VI1PR0402MB3711.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2KFKbtUWZ1l5yVt+jRkQCcDXvlxEuEQn+aNzrjcVwCPThYJn7VeH/1nTrgfN3UzqpLczw6iHzQ43dffwIhXhy2bca7wHvaY/o/mZ6dD/BMmru2v3pM7zlYVEi7BYsmSWSIvEApYrWj6V5u41m9xA7OqHfX36SLMEJKKPD7AO7uryPU+yQLB4wRbhwgYn2tbMKXMa1ONWUp27IC8TunlHCk0QV2JwngZcbIA7xDuv68ylMkxGX3xAJ1QIJoZKGsSQMji36jVyeLm7mMbWEC47r07UewYXEzrQfpyCxS7Q3V5BfsugoHjQ9DFiU/fHTKPHCuA2Vqmj0pWK9qZGn0oIrqW6bIiqLLuBfBeDUcj82PjmItuXlLMxqM2hW4XsBiUhC7v7T0Lxj7ye8e1KpOiAPCIdp/z0fjOiEqcO0rr4g/ewdnxrWfX0Xn+fDnzb6f5vYV0xAJkZntVXjGR1v/Uf/qUXp+8ff9CxJ0tuZkOdbwoYV2+lbioK9yGMEMfeoHci6tZzwDi3lEq5gulTc9s4XQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(4326008)(478600001)(83380400001)(54906003)(6506007)(76116006)(2906002)(66946007)(33716001)(91956017)(6916009)(8676002)(5660300002)(26005)(186003)(64756008)(6486002)(66476007)(8936002)(66556008)(66446008)(6512007)(44832011)(86362001)(71200400001)(9686003)(7416002)(1076003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uKGb9tdlJUDGwtcd0foGOSTXEgf4x3DfUeIeFTzsaQwavGjlRtuH7ivm8wTT?=
 =?us-ascii?Q?igx1cOgFGMX8uhJWv0FVPOTX+MEzDPQPOr2vSkFORgqYlzHbo9Gp4Zo9/Llz?=
 =?us-ascii?Q?iY5Rvr1/3XdXS0oQVDpM4ShqFewcBOrbuOTWnctIf1utiSS+8orc8y7HjuCg?=
 =?us-ascii?Q?unwjS/311Y1m7fqAN7oYKtJmk+mG5Ua2g8Bbvw14WXij7UVEPR0nGVqlfE9U?=
 =?us-ascii?Q?1Ay/8/3nO7+wPvaepAwqSW69p7BAkPgW2VnvNZNERt98pq6DbtaxbjUHovoY?=
 =?us-ascii?Q?07RZfMvOj9quLGY5l8foTrq5D4/bcf3tabS9+9Ec2CzK5Jryfh1HgAfzCyZn?=
 =?us-ascii?Q?78EprG2cfK0IvstMoYGhNse3ZtfIHDGWIoZrLseWgsS7zV7YPPmSUSa1hQkI?=
 =?us-ascii?Q?/YpLRoZ7wR8mqtCg2Y92hDxMuPdzbjLLCdSLa1HQU9wDhmjvaJfHzmZWM2VU?=
 =?us-ascii?Q?UL7gMF8xWH7uUxgAaAoj/ZJBUiOR4+G6E9vD1ti5UuYmJU1NqeR6GwUMQSSZ?=
 =?us-ascii?Q?9kbjM0SlaaMX42Ymm6EuKikuzh55ShztzXdf6Cbf5I1AJfUENMQsMGruhnwh?=
 =?us-ascii?Q?7CssEL34/rrgXR04sOIFRJ9NY93zYLQoDO+XxLyb9UfyXQxg5A6kZRzU/hbF?=
 =?us-ascii?Q?A8voutqlrb+fdY6o0XVBr9+bVbVX77+1Zkb8L+wKG4pCCB5BuLE3kAW9ekYQ?=
 =?us-ascii?Q?JyNV9nDTsW99TLndzWFp7ssqRfkZgpRKZ1GZuuCLjdLkvFNzu9vnuK9k8CoV?=
 =?us-ascii?Q?yLg9Ore6BqkARGB50oN1H/5+8vofAL3KcW5OStghRRiRuIxhDFccJK3xo38E?=
 =?us-ascii?Q?fSzIfu8KVRWxYKN28ntyMs62U2+SJloNYg364kdQrFbCKuOWQYofXDUr0BO9?=
 =?us-ascii?Q?/GETvxyI+YNFSv+xEgfsI+KMXUgysWwUWFc5Xq9LuG9aDBswoZiJ8mCPueRJ?=
 =?us-ascii?Q?jVlstxQ9q3os2IOJxvMc7srwj/9CBhRt7VEz+cOZCP50Av07Evca5Yec8y1P?=
 =?us-ascii?Q?CWEdFI1dkzIw3LReFJ7uiFg0AbuomvzKV8hcHbJxRTFaFhJPWS38M134Q9sR?=
 =?us-ascii?Q?83KadxJEjiC3XLKdaDbc4sD49vgjTvoLzUuMTJJ5HTbTEmf/F4SsjvdSxVn0?=
 =?us-ascii?Q?nDbd9W3LrX94W0RDZDjgrHBqOjcn6FpamdOoLQNdnrmXHheJ1vkRqCd5X4yP?=
 =?us-ascii?Q?Ac17ai9J4OHn4LsLz5Bn8E+CKJbNRinHEDTfMwvWp2qILufV3vq+ouLsngwP?=
 =?us-ascii?Q?xbEEnAukALip0V92psgJynH4hrmgHlODH1W8nkpsZRNVZHAH97uY/FVbt87u?=
 =?us-ascii?Q?1rldhqP1EV6St53vZdu/miU/?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <370D995BDD149F42963C905A96EF2249@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e23bb99-1df8-4a4d-2f6e-08d8d3367b84
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 11:23:42.5860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ArDNLg7FmknLYHb6zwqY53uoh0hBD+8zHh/HdtKaZREnhBdbYrQpGKGegkd00bbcoy3tAceAUsp1mcL6qNTywQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:42:04PM +0100, Horatiu Vultur wrote:
> Add support for offloading MRP in HW. Currently implement the switchdev
> calls 'SWITCHDEV_OBJ_ID_MRP', 'SWITCHDEV_OBJ_ID_RING_ROLE_MRP',
> to allow to create MRP instances and to set the role of these instances.
>=20
> Add DSA_NOTIFIER_MRP_ADD/DEL and DSA_NOTIFIER_MRP_ADD/DEL_RING_ROLE
> which calls to .port_mrp_add/del and .port_mrp_add/del_ring_role in the
> DSA driver for the switch.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/net/dsa.h  |  12 ++++++
>  net/dsa/dsa_priv.h |  26 +++++++++++
>  net/dsa/port.c     |  48 +++++++++++++++++++++
>  net/dsa/slave.c    |  22 ++++++++++
>  net/dsa/switch.c   | 105 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 213 insertions(+)
>=20
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 68f8159564a3..83a933e563fe 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -792,6 +792,18 @@ struct dsa_switch_ops {
>  				 struct net_device *hsr);
>  	int	(*port_hsr_leave)(struct dsa_switch *ds, int port,
>  				  struct net_device *hsr);
> +
> +	/*
> +	 * MRP integration
> +	 */
> +	int	(*port_mrp_add)(struct dsa_switch *ds, int port,
> +				const struct switchdev_obj_mrp *mrp);
> +	int	(*port_mrp_del)(struct dsa_switch *ds, int port,
> +				const struct switchdev_obj_mrp *mrp);
> +	int	(*port_mrp_add_ring_role)(struct dsa_switch *ds, int port,
> +					  const struct switchdev_obj_ring_role_mrp *mrp);
> +	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
> +					  const struct switchdev_obj_ring_role_mrp *mrp);
>  };
> =20
>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index e9d1e76c42ba..2eeaa42f2e08 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -31,6 +31,10 @@ enum {
>  	DSA_NOTIFIER_VLAN_DEL,
>  	DSA_NOTIFIER_MTU,
>  	DSA_NOTIFIER_TAG_PROTO,
> +	DSA_NOTIFIER_MRP_ADD,
> +	DSA_NOTIFIER_MRP_DEL,
> +	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
> +	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
>  };
> =20
>  /* DSA_NOTIFIER_AGEING_TIME */
> @@ -91,6 +95,20 @@ struct dsa_notifier_tag_proto_info {
>  	const struct dsa_device_ops *tag_ops;
>  };
> =20
> +/* DSA_NOTIFIER_MRP_* */
> +struct dsa_notifier_mrp_info {
> +	const struct switchdev_obj_mrp *mrp;
> +	int sw_index;
> +	int port;
> +};
> +
> +/* DSA_NOTIFIER_MRP_* */
> +struct dsa_notifier_mrp_ring_role_info {
> +	const struct switchdev_obj_ring_role_mrp *mrp;
> +	int sw_index;
> +	int port;
> +};
> +
>  struct dsa_switchdev_event_work {
>  	struct dsa_switch *ds;
>  	int port;
> @@ -198,6 +216,14 @@ int dsa_port_vlan_add(struct dsa_port *dp,
>  		      struct netlink_ext_ack *extack);
>  int dsa_port_vlan_del(struct dsa_port *dp,
>  		      const struct switchdev_obj_port_vlan *vlan);
> +int dsa_port_mrp_add(const struct dsa_port *dp,
> +		     const struct switchdev_obj_mrp *mrp);
> +int dsa_port_mrp_del(const struct dsa_port *dp,
> +		     const struct switchdev_obj_mrp *mrp);
> +int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
> +			       const struct switchdev_obj_ring_role_mrp *mrp);
> +int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
> +			       const struct switchdev_obj_ring_role_mrp *mrp);
>  int dsa_port_link_register_of(struct dsa_port *dp);
>  void dsa_port_link_unregister_of(struct dsa_port *dp);
>  int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 14a1d0d77657..c9c6d7ab3f47 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -564,6 +564,54 @@ int dsa_port_vlan_del(struct dsa_port *dp,
>  	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
>  }
> =20
> +int dsa_port_mrp_add(const struct dsa_port *dp,
> +		     const struct switchdev_obj_mrp *mrp)
> +{
> +	struct dsa_notifier_mrp_info info =3D {
> +		.sw_index =3D dp->ds->index,
> +		.port =3D dp->index,
> +		.mrp =3D mrp,
> +	};
> +
> +	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD, &info);
> +}
> +
> +int dsa_port_mrp_del(const struct dsa_port *dp,
> +		     const struct switchdev_obj_mrp *mrp)
> +{
> +	struct dsa_notifier_mrp_info info =3D {
> +		.sw_index =3D dp->ds->index,
> +		.port =3D dp->index,
> +		.mrp =3D mrp,
> +	};
> +
> +	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL, &info);
> +}
> +
> +int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
> +			       const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct dsa_notifier_mrp_ring_role_info info =3D {
> +		.sw_index =3D dp->ds->index,
> +		.port =3D dp->index,
> +		.mrp =3D mrp,
> +	};
> +
> +	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD_RING_ROLE, &info);
> +}
> +
> +int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
> +			       const struct switchdev_obj_ring_role_mrp *mrp)
> +{
> +	struct dsa_notifier_mrp_ring_role_info info =3D {
> +		.sw_index =3D dp->ds->index,
> +		.port =3D dp->index,
> +		.mrp =3D mrp,
> +	};
> +
> +	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL_RING_ROLE, &info);
> +}
> +
>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>  			       const struct dsa_device_ops *tag_ops)
>  {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 5ecb43a1b6e0..491e3761b5f4 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -404,6 +404,17 @@ static int dsa_slave_port_obj_add(struct net_device =
*dev,
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>  		err =3D dsa_slave_vlan_add(dev, obj, extack);
>  		break;
> +	case SWITCHDEV_OBJ_ID_MRP:
> +		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
> +			return -EOPNOTSUPP;
> +		err =3D dsa_port_mrp_add(dp, SWITCHDEV_OBJ_MRP(obj));
> +		break;
> +	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> +		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
> +			return -EOPNOTSUPP;
> +		err =3D dsa_port_mrp_add_ring_role(dp,
> +						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> @@ -461,6 +472,17 @@ static int dsa_slave_port_obj_del(struct net_device =
*dev,
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>  		err =3D dsa_slave_vlan_del(dev, obj);
>  		break;
> +	case SWITCHDEV_OBJ_ID_MRP:
> +		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
> +			return -EOPNOTSUPP;
> +		err =3D dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
> +		break;
> +	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
> +		if (!dsa_port_offloads_netdev(dp, obj->orig_dev))
> +			return -EOPNOTSUPP;
> +		err =3D dsa_port_mrp_del_ring_role(dp,
> +						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index db2a9b221988..4b5da89dc27a 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -372,6 +372,99 @@ static int dsa_switch_change_tag_proto(struct dsa_sw=
itch *ds,
>  	return 0;
>  }
> =20
> +static bool dsa_switch_mrp_match(struct dsa_switch *ds, int port,
> +				 struct dsa_notifier_mrp_info *info)
> +{
> +	if (ds->index =3D=3D info->sw_index && port =3D=3D info->port)
> +		return true;
> +
> +	if (dsa_is_dsa_port(ds, port))
> +		return true;
> +
> +	return false;
> +}
> +
> +static int dsa_switch_mrp_add(struct dsa_switch *ds,
> +			      struct dsa_notifier_mrp_info *info)
> +{
> +	int err =3D 0;
> +	int port;
> +
> +	if (!ds->ops->port_mrp_add)
> +		return -EOPNOTSUPP;
> +
> +	for (port =3D 0; port < ds->num_ports; port++) {
> +		if (dsa_switch_mrp_match(ds, port, info)) {
> +			err =3D ds->ops->port_mrp_add(ds, port, info->mrp);
> +			if (err)
> +				break;
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +static int dsa_switch_mrp_del(struct dsa_switch *ds,
> +			      struct dsa_notifier_mrp_info *info)
> +{
> +	if (!ds->ops->port_mrp_del)
> +		return -EOPNOTSUPP;
> +
> +	if (ds->index =3D=3D info->sw_index)
> +		return ds->ops->port_mrp_del(ds, info->port, info->mrp);
> +
> +	return 0;
> +}
> +

Why not use dsa_switch_mrp_match here too? (question valid for the ring
role below too)

> +static bool
> +dsa_switch_mrp_ring_role_match(struct dsa_switch *ds, int port,
> +			       struct dsa_notifier_mrp_ring_role_info *info)
> +{
> +	if (ds->index =3D=3D info->sw_index && port =3D=3D info->port)
> +		return true;
> +
> +	if (dsa_is_dsa_port(ds, port))
> +		return true;
> +
> +	return false;
> +}
> +
> +static int
> +dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
> +			     struct dsa_notifier_mrp_ring_role_info *info)
> +{
> +	int err =3D 0;
> +	int port;
> +
> +	if (!ds->ops->port_mrp_add)
> +		return -EOPNOTSUPP;
> +
> +	for (port =3D 0; port < ds->num_ports; port++) {
> +		if (dsa_switch_mrp_ring_role_match(ds, port, info)) {
> +			err =3D ds->ops->port_mrp_add_ring_role(ds, port,
> +							      info->mrp);
> +			if (err)
> +				break;
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +static int
> +dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
> +			     struct dsa_notifier_mrp_ring_role_info *info)
> +{
> +	if (!ds->ops->port_mrp_del)
> +		return -EOPNOTSUPP;
> +
> +	if (ds->index =3D=3D info->sw_index)
> +		return ds->ops->port_mrp_del_ring_role(ds, info->port,
> +						       info->mrp);
> +
> +	return 0;
> +}
> +
>  static int dsa_switch_event(struct notifier_block *nb,
>  			    unsigned long event, void *info)
>  {
> @@ -427,6 +520,18 @@ static int dsa_switch_event(struct notifier_block *n=
b,
>  	case DSA_NOTIFIER_TAG_PROTO:
>  		err =3D dsa_switch_change_tag_proto(ds, info);
>  		break;
> +	case DSA_NOTIFIER_MRP_ADD:
> +		err =3D dsa_switch_mrp_add(ds, info);
> +		break;
> +	case DSA_NOTIFIER_MRP_DEL:
> +		err =3D dsa_switch_mrp_del(ds, info);
> +		break;
> +	case DSA_NOTIFIER_MRP_ADD_RING_ROLE:
> +		err =3D dsa_switch_mrp_add_ring_role(ds, info);
> +		break;
> +	case DSA_NOTIFIER_MRP_DEL_RING_ROLE:
> +		err =3D dsa_switch_mrp_del_ring_role(ds, info);
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> --=20
> 2.27.0
> =
