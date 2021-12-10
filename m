Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194BB470B86
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbhLJUNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:13:51 -0500
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:21857
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243165AbhLJUNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6uQV+56DO4KyB2kf7YiuF8/v/GCYX2HJSl1An8YKAWk1/dRcrh+3DQB5MsuWA0WPCgiurIvgMUD1WrE1eMuxgnuEFpEwFr7OEOTTfSvK4XAQQHkE6c68YvQaY7oHCplJsNHle7ENdnNi8SsUeBXfeK8xT3d8CUTHPh8q6RAHhdKOxOOcz16RSYPTlwbNI3banEU2mxn1bw6MyvRncKsjNoFlSet1KLDNKLgoYm3FF1dFneso0ZeuiiKOwosBC3UUD0Aoxp02Fpy3OTRHLnoGCG6m9ogGoNLpR9AB+F5oRASp+4Q70gntKczk5omiqjiE321KAJ5v22ucZlDN1xYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJaHJlq7yQckOFHbtt3FfLJZ6mqXs7oyCyah+rzyccs=;
 b=XDGXxOCBuaK6jcQ+WueQ8DDhN7kOTQf2/YpfjZI0X5da0QYCyGWpqpV62lXQodFuSQOdPdPf4vpxB/2AvXuzhVcGzsZF6e9RNvW/uaCFLCIUGrlYTtOExRQX+7haD3298x3Sw66ib9arvjFUAUNNMX+avaw7FTpEycaB2RKzKJ0N3Mm5kjkB6SbiMxp/1XILu4sE8F0WTCe2/5o/VmTMzdPMZU6/TqMUCxTX/IV44ZtXfpAJxI+PiEvnFKCVA1uYXkLWg5+ElQ5dwiVxygwJtQRt9ire9NwZhvwWcle9GzlJVpsV7p2nDEtjtJbOh5AbACgmtHhXosP+Mvbw+K4jQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJaHJlq7yQckOFHbtt3FfLJZ6mqXs7oyCyah+rzyccs=;
 b=QOIgRnAbCLc0h2XbD4XKaT3ufAGXlOrw0c0Y96JgEKnmgTCN2ZC4EumG8KqBZ9gYNnHC3HgdcCws3XAfovMSwuNenL+o2Z/UI45uFh3qg/INElTUYQcuy4QIfmVvs9e9Xn5me8xwADa79tFZ0wPrhPZF6D4ki4+REdWTtwGSz1U=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 20:10:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 20:10:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 1/4] net: dsa: provide switch operations
 for tracking the master state
Thread-Topic: [RFC PATCH v2 net-next 1/4] net: dsa: provide switch operations
 for tracking the master state
Thread-Index: AQHX7SPAYyQApKEMQ0CLLnS9CBt2l6wsKY8A
Date:   Fri, 10 Dec 2021 20:10:05 +0000
Message-ID: <20211210201004.ysxelsshgtumk67g@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <20211209173927.4179375-2-vladimir.oltean@nxp.com>
In-Reply-To: <20211209173927.4179375-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55168f69-1eef-4cf0-a470-08d9bc190e85
x-ms-traffictypediagnostic: VI1PR04MB5343:EE_
x-microsoft-antispam-prvs: <VI1PR04MB53432DF320911FC5AA6094FAE0719@VI1PR04MB5343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFGtBAXxLonZX9YfKmfLG/SNo4xwfGRalIb1c9QJG0tv/xvY/hXKGfbqCqHJseosZ2KtxLzycrbYmVGSylOoST6WrxeKtw69byIghKUiJmvPhQj2FjnOxUbmqJrPRHaPZRsd3N3/b/rOul1YFGwbm3vuexz1yA5bjmVVs4/SSoTHPhrPxzDKpGS9wYzYdZteRy8UD3sHfyzaIeQx28/Ku4EsfbcQl5hSsRxGtKImr/7wM879k4DljFQy3k2+wjF0jxxtHrl0aLhE/WeomcuHSk64HvAGOo+uZ21jc+d8qwmD080HgTPT7djzrcpDex4sk2/3SALSzfHPgNnHsQG1DmgRF6yVy4RfImykRrSjxMoN/Qgi65g4VJXR73NjBFO/UzsSC0OxvomkasnxXo1NlPMqDMjNduQgxrZrP3GobFujKDrmJU9cxPhr4TDNkHRXSWy6bVk8QE8I6bmUe7xR1L9NsxjFVjW3DBK3yvE0MAusL+v/0BHy4kaQIS0/seYReK2KAmIBoNo4h9UMPKrzbq5JanltIZAUQXj36/BCoS3a7pNjiNvUJzFQLXjMn6NWpnJC6Om9F5FcMb+kUnqzoAqtafF/D8jCs2WQIEvfvHJVph4GSCkg+JhETtwylDcNvyeWTT6rfn+K9hvP2WXtr1jtowFdMlHMO6N1FnbjNt4PJSlDmzPqIRorLb7pw81hYl9QXey1qQvnUUjq/AwnSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(54906003)(38100700002)(316002)(6506007)(83380400001)(66946007)(76116006)(64756008)(66476007)(91956017)(26005)(33716001)(4326008)(86362001)(71200400001)(6486002)(508600001)(186003)(1076003)(66446008)(9686003)(6512007)(8936002)(44832011)(8676002)(2906002)(38070700005)(66556008)(6916009)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lPtH9Lxv4UZEjcJpaju6uIvcZ9rtvxpTsrjR/QqerdMHK9xmey0H6C9DYLDy?=
 =?us-ascii?Q?VZWljad1g0XY75fBdTp9rv37XUF2I6mO06AZWx2FEO6OITdvvNAoMxPU6Ocx?=
 =?us-ascii?Q?R1EFAu63ee9iIj71lkXHF+AZfSNK95nOuQhleFMORuEa8qvTG+TiXmaeOn3Q?=
 =?us-ascii?Q?H9cXOmo41/O/0b/XoNgLg4zA8VLJ6Qe4kjxbclK378JKzdWLHUjIPHkLAFcE?=
 =?us-ascii?Q?r7GoI3Dj3/seq9Uo4nQZpcx5rhhTMELscLCGpanSQY5GwB5ZUJ4gx8XdcrEQ?=
 =?us-ascii?Q?DPe70SxUcfIhto93GhcQz8ZY6fxy6y8XNPcY7sq5fyJ0V0cFu0wm7OwJvBU3?=
 =?us-ascii?Q?Kz36CWGAiMZ0uxavfHsbeFUlXdQBKgWoBLUsuwzm6ucJ5/W8FpV3lZhw990f?=
 =?us-ascii?Q?wLTBu8OW00FPcpG2yol6ur0PUmW5gxjgc7V8RaRguwphle5CShUpcmCI5v5M?=
 =?us-ascii?Q?d+t+oCMZUI+airGAsyArSaDEUELAlqCF11O7Wdk9NiQkS+jIh5vQO61kSisu?=
 =?us-ascii?Q?7zvYWFtV7B7XwwPte+ibflWdOiJutB71BZc4AGS6i8oMoz5A86BdDjKkQ974?=
 =?us-ascii?Q?imeW/sUWLib/p7ZMI7Y6+LQQlqIRfwM2FXyI300kiitNRMC+/vosQJ7WWpyH?=
 =?us-ascii?Q?hQU26zj5LHWqDmrLmCmNKoWQmYSxj1EBsk36TkmDh7nv7hYZPYzH1YbyoUrY?=
 =?us-ascii?Q?BsgUoxyrJY2slWVtoxLnaTE3L77imWpZ2y0Jiev0Lb9vPeYVLYjvwMgvyZlP?=
 =?us-ascii?Q?1hqUHYdCxQmcnY3UCbg/nDDy6uAsppSkRDrv9q3k3HtNznqiSwmD32iMJ/f0?=
 =?us-ascii?Q?GbMrqaac41HEkyFZ+k8W+JSPXZNTit7zmWzi6sy/uC1p0MJaTeiqDWYnvcPI?=
 =?us-ascii?Q?6SXDl18YSpxEGb4heVdYJ0LW6KPgOfSnayLUthalxyE04qgAdeOToHoI2rYb?=
 =?us-ascii?Q?vz9NJJxzk7GKApMPDpTil1YXote99XFDK9Exc9RDTogWgRK1DZZuuDRjvgud?=
 =?us-ascii?Q?6VwuWmgVO401wCmsPr2/8AFPMEVcPEh1sKPF4k+L83nXHAm06cniiVyFJln1?=
 =?us-ascii?Q?Ibdd0sAh+Pny8CTqRy42Z7VHLn5lVMitgaTYF7Zs3dTypt9/u+jkuCJgE1ew?=
 =?us-ascii?Q?m8y5HRLiyBWGlfmMMI9YAZyGfBL0lnnrlClqxvhYL9QY5vKV7R44ywddAs7e?=
 =?us-ascii?Q?ylp9CrWK9K2bl3iB3WOnKXRI7ZvYFbjga7i4Vvwh4lfwAx6HsMuPHMt2hqhi?=
 =?us-ascii?Q?XxfNQqq/91/N0Xfy89bMhR0oAviwmDhbRtzGJOMWD8/HEZX7XTa2wPqlYGcq?=
 =?us-ascii?Q?YR4QX0+0LWs5pQTp5RqeXNkcth7fwyMpSmQf511KJm7QA/pnBVzun7ZcXj+v?=
 =?us-ascii?Q?F7oTq68xPzoyHv9EJlxI9589hNcQZ0hegiJnyXFV7xXSSzzYQ0+zwfRYnmFE?=
 =?us-ascii?Q?DX5QmwA5qzo0qKKF31r49ZPL2O7eUyU2Yv0GXknv9Y2tfl7gvj0LZaw6DJGr?=
 =?us-ascii?Q?2b98TO+X235IaEBFseNT2hbBtdP9BeyGX+pi2Gvg0eLE/q5BJfNA5fT8dBA8?=
 =?us-ascii?Q?0CRpxu+CH5kj6bWh2h0tGCd56UlaQzFdvcoLPoEqo49eBKw5mj5sHsCZxG/5?=
 =?us-ascii?Q?FtYZyVr5pBY/tyQ6vfEo/6w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E775DFD9AD82EC458667365EB9BA2778@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55168f69-1eef-4cf0-a470-08d9bc190e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 20:10:05.2698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WetJM5mItdGwcBdgUBu+5APEU7qPNHkj3019+oRCRUdz5EWrT+/SrAECdVmIbLliNxopDivEwT1qz+rUccdLjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 07:39:24PM +0200, Vladimir Oltean wrote:
> Certain drivers may need to send management traffic to the switch for
> things like register access, FDB dump, etc, to accelerate what their
> slow bus (SPI, I2C, MDIO) can already do.
>=20
> Ethernet is faster (especially in bulk transactions) but is also more
> unreliable, since the user may decide to bring the DSA master down (or
> not bring it up), therefore severing the link between the host and the
> attached switch.
>=20
> Drivers needing Ethernet-based register access already should have
> fallback logic to the slow bus if the Ethernet method fails, but that
> fallback may be based on a timeout, and the I/O to the switch may slow
> down to a halt if the master is down, because every Ethernet packet will
> have to time out. The driver also doesn't have the option to turn off
> Ethernet-based I/O momentarily, because it wouldn't know when to turn it
> back on.
>=20
> Which is where this change comes in. By tracking NETDEV_CHANGE,
> NETDEV_UP and NETDEV_GOING_DOWN events on the DSA master, we should know
> the exact interval of time during which this interface is reliably
> available for traffic. Provide this information to switches so they can
> use it as they wish.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/dsa.h  | 11 +++++++++++
>  net/dsa/dsa2.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa_priv.h | 13 +++++++++++++
>  net/dsa/slave.c    | 27 +++++++++++++++++++++++++++
>  net/dsa/switch.c   | 15 +++++++++++++++
>  5 files changed, 112 insertions(+)
>=20
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index bdf308a5c55e..8690b9c6d674 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -296,6 +296,10 @@ struct dsa_port {
>  	struct list_head	fdbs;
>  	struct list_head	mdbs;
> =20
> +	/* Master state bits, valid only on CPU ports */
> +	u8 master_admin_up:1,
> +	   master_oper_up:1;
> +
>  	bool setup;
>  };
> =20
> @@ -1011,6 +1015,13 @@ struct dsa_switch_ops {
>  	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
>  				      u16 flags);
>  	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
> +
> +	/*
> +	 * DSA master tracking operations
> +	 */
> +	void	(*master_state_change)(struct dsa_switch *ds,
> +				       const struct net_device *master,
> +				       bool operational);
>  };
> =20
>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 8814fa0e44c8..a6cb3470face 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -1187,6 +1187,52 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tr=
ee *dst,
>  	return err;
>  }
> =20
> +static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
> +					 struct net_device *master)
> +{
> +	struct dsa_notifier_master_state_info info;
> +	struct dsa_port *cpu_dp =3D master->dsa_ptr;
> +
> +	info.master =3D master;
> +	info.operational =3D cpu_dp->master_admin_up && cpu_dp->master_oper_up;
> +
> +	dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
> +}
> +
> +void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
> +					struct net_device *master,
> +					bool up)
> +{
> +	struct dsa_port *cpu_dp =3D master->dsa_ptr;
> +	bool notify =3D false;
> +
> +	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=3D
> +	    (up && cpu_dp->master_oper_up))
> +		notify =3D true;
> +
> +	cpu_dp->master_admin_up =3D up;
> +
> +	if (notify)
> +		dsa_tree_master_state_change(dst, master);
> +}
> +
> +void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
> +				       struct net_device *master,
> +				       bool up)
> +{
> +	struct dsa_port *cpu_dp =3D master->dsa_ptr;
> +	bool notify =3D false;
> +
> +	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=3D
> +	    (cpu_dp->master_admin_up && up))
> +		notify =3D true;
> +
> +	cpu_dp->master_oper_up =3D up;
> +
> +	if (notify)
> +		dsa_tree_master_state_change(dst, master);
> +}
> +
>  static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
>  {
>  	struct dsa_switch_tree *dst =3D ds->dst;
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 38ce5129a33d..c47864446adc 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -43,6 +43,7 @@ enum {
>  	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
>  	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
>  	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
> +	DSA_NOTIFIER_MASTER_STATE_CHANGE,
>  };
> =20
>  /* DSA_NOTIFIER_AGEING_TIME */
> @@ -126,6 +127,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
>  	u16 vid;
>  };
> =20
> +/* DSA_NOTIFIER_MASTER_STATE_CHANGE */
> +struct dsa_notifier_master_state_info {
> +	const struct net_device *master;
> +	bool operational;
> +};
> +
>  struct dsa_switchdev_event_work {
>  	struct dsa_switch *ds;
>  	int port;
> @@ -506,6 +513,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree=
 *dst,
>  			      struct net_device *master,
>  			      const struct dsa_device_ops *tag_ops,
>  			      const struct dsa_device_ops *old_tag_ops);
> +void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
> +					struct net_device *master,
> +					bool up);
> +void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
> +				       struct net_device *master,
> +				       bool up);
>  unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int=
 max);
>  void dsa_bridge_num_put(const struct net_device *bridge_dev,
>  			unsigned int bridge_num);
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 2b153b366118..9f3b25c08c13 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2349,6 +2349,31 @@ static int dsa_slave_netdevice_event(struct notifi=
er_block *nb,
>  		err =3D dsa_port_lag_change(dp, info->lower_state_info);
>  		return notifier_from_errno(err);
>  	}
> +	case NETDEV_CHANGE: {
> +		if (netdev_uses_dsa(dev)) {
> +			struct dsa_port *cpu_dp =3D dev->dsa_ptr;
> +			struct dsa_switch_tree *dst =3D cpu_dp->ds->dst;
> +
> +			dsa_tree_master_oper_state_change(dst, dev,
> +							  netif_oper_up(dev));

must also add a call here to change the admin state, due to the fact
that linkwatch_do_dev may call netdev_state_change() after dev_activate().
So it seems that "case NETDEV_CHANGE" and "case NETDEV_UP" may share the
same implementation, like this:

	case NETDEV_CHANGE:
	case UP:
		if (netdev_uses_dsa(dev)) {
			struct dsa_port *cpu_dp =3D dev->dsa_ptr;
			struct dsa_switch_tree *dst =3D cpu_dp->ds->dst;

			dsa_tree_master_admin_state_change(dst, dev,
							   qdisc_tx_is_noop(dev));
			dsa_tree_master_oper_state_change(dst, dev,
							  netif_oper_up(dev));

			return NOTIFY_OK;
		}

		return NOTIFY_DONE;
	}

Would be good to also add some comments.

> +
> +			return NOTIFY_OK;
> +		}
> +
> +		return NOTIFY_DONE;
> +	}
> +	case NETDEV_UP: {
> +		if (netdev_uses_dsa(dev)) {
> +			struct dsa_port *cpu_dp =3D dev->dsa_ptr;
> +			struct dsa_switch_tree *dst =3D cpu_dp->ds->dst;
> +
> +			dsa_tree_master_admin_state_change(dst, dev, true);

s/true/qdisc_tx_is_noop(dev)/

> +
> +			return NOTIFY_OK;
> +		}
> +
> +		return NOTIFY_DONE;
> +	}
>  	case NETDEV_GOING_DOWN: {
>  		struct dsa_port *dp, *cpu_dp;
>  		struct dsa_switch_tree *dst;
> @@ -2360,6 +2385,8 @@ static int dsa_slave_netdevice_event(struct notifie=
r_block *nb,
>  		cpu_dp =3D dev->dsa_ptr;
>  		dst =3D cpu_dp->ds->dst;
> =20
> +		dsa_tree_master_admin_state_change(dst, dev, false);
> +
>  		list_for_each_entry(dp, &dst->ports, list) {
>  			if (!dsa_port_is_user(dp))
>  				continue;
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 9c92edd96961..78816a6805c8 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -699,6 +699,18 @@ dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
>  	return 0;
>  }
> =20
> +static int
> +dsa_switch_master_state_change(struct dsa_switch *ds,
> +			       struct dsa_notifier_master_state_info *info)
> +{
> +	if (!ds->ops->master_state_change)
> +		return 0;
> +
> +	ds->ops->master_state_change(ds, info->master, info->operational);
> +
> +	return 0;
> +}
> +
>  static int dsa_switch_event(struct notifier_block *nb,
>  			    unsigned long event, void *info)
>  {
> @@ -784,6 +796,9 @@ static int dsa_switch_event(struct notifier_block *nb=
,
>  	case DSA_NOTIFIER_TAG_8021Q_VLAN_DEL:
>  		err =3D dsa_switch_tag_8021q_vlan_del(ds, info);
>  		break;
> +	case DSA_NOTIFIER_MASTER_STATE_CHANGE:
> +		err =3D dsa_switch_master_state_change(ds, info);
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> --=20
> 2.25.1
>=
