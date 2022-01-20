Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE79495218
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 17:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376832AbiATQNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 11:13:33 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:24650
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347315AbiATQNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 11:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQcxCE4nmkb7YZzqOSetY67keOr/tngvAqIYsZrnsywhoNg5lUllmfIE8T8hgPWbEj7Azo8CR2beoYqXNETMzMcQdDgwCXDLR0bMJAVzHl+gKLg1hBtet95GOWSfaWMnwjREMchZeDeieKcUwI3TNtBkQ4sWJL8TicELOFdTNtGdH08m4gyOi+A9MKwcxMQMrCxH6eCihR4TX1PSdmrxwTDTpHughZy7B01PaVdgQk8vjCeGqTowXbPSQP8rFYHvnhdSWIF/P1CvBu15unPWt5JueEZAGg/awBGIzQtPtQoEOQvSKsRQicpOab5Wgapr5mNd6opeSCbx99XJVLakng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Z8erYZxbdl6oNJl2YAmpKfW9PIalfAb3MUG+br4cWk=;
 b=SRDIzwcgWakHB3cos37SDkd3mnafbj0YH+G6W2njXgoc8dFgXER/1A/VmQZzXdP/9HQ2Ep4HgQ6qv1boi0su4ilD4qdfoJXS/VoEJcznBAz5Un9tmV6CRe4fwbWCRewrQbEkhG/XZaklBVPvKapzRi8HByfNu7SgPVN0k9CynfbRpqx3ynTZv6zttTOh5y/skbmGyRDrCfEWm98ANIgSEnZHCwDQ3jl8Ns+ic0th3J6dz9Ql847Ymdc4XGrQgmYoy4NCzlyK9l/2xBLgC0m8lVHDoDVxvzz4emeP/rx4lZy/Wjsp4xnU5MsWykuq8WZDRk8UmMoF363DPFidIADE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Z8erYZxbdl6oNJl2YAmpKfW9PIalfAb3MUG+br4cWk=;
 b=RkQyBFetqRctsgUL/gFulfrq+LtZ05VObgIpgO6CVRlgZ99Rq+pHK50iXuvCJtjoGamGq9QLh6KH7blcf1yg4N+4l2xQH2y6vUI/mUc3gE2NDYtM24O3+2i+fH0+eDdiO/46zUKKDKbC06MxfMAoJnAtycPEHHq4t8I6f4Fzajw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7611.eurprd04.prod.outlook.com (2603:10a6:10:1f4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 20 Jan
 2022 16:13:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 16:13:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH RFC V1 net-next 1/4] net: ethtool: Refactor identical
 get_ts_info implementations.
Thread-Topic: [PATCH RFC V1 net-next 1/4] net: ethtool: Refactor identical
 get_ts_info implementations.
Thread-Index: AQHYAPlFvlt8L++r9US5MwpcK3ucvKxsL2CA
Date:   Thu, 20 Jan 2022 16:13:29 +0000
Message-ID: <20220120161329.fbniou5kzn2x4rp7@skbuf>
References: <20220103232555.19791-2-richardcochran@gmail.com>
In-Reply-To: <20220103232555.19791-2-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 639c1f6e-eb8b-4dcc-42ba-08d9dc2fcc40
x-ms-traffictypediagnostic: DBBPR04MB7611:EE_
x-microsoft-antispam-prvs: <DBBPR04MB761103EE5815633A06386A6EE05A9@DBBPR04MB7611.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q4/r7hXbZCk9MDcL/sFzjUKK9sxgaRKqE4fp5a1xeIPENZeGd4ovZgT42awiCnp4nJ0zZu9MrV+8XKEotK5CIbAg8iFG6OK7q8Kxu0gfn3t4MLdy9U320REQH35MrBx7ZwjmqrUQnE54gsPqmNjsJdIY4C7TkcP7yGaH7/LNjVeqAlHhUsQYDfIQWm+PbR5SBL9HtFW2umRwGQf+ACRc+99reliM2v5bujfSZKeJqV872joT2eHYyriBtWxay2dLGv2TjLuvXhys7WNh8plIkiRck2jyifa4w+XKPnzueU5otz9BB1bQT/APWmgullUQudHxRgucKzl779TjT5lxxt3DdIwolDtHlaLLUDr/i6psZdz0E7d7r3Gnm/9+n8ib8mMG5zibx8+18am+2sCGJYy7NbNvnKwwbxO+4VpHGJYD4BBmO6LyNrg5mPAMN2QKcZXF5nqacWiRMw1YgQxwN7HcP8k3ZWHd2dz/Ydzf6Ks1VpOjN6fx9wvXVSCyx5tx6oGVUrJmD3NW8D53/BKmArs0ZOqceL5CHOdUmsSYGpb0Mq1WpqDjRoLDQVHhs1GjgukO2o62oyaNatpKlZ71qKzRnaBrGNqs+mAbn7FINVigxy4rtUlh3Rnl3xbS+lLnYNlHyDigKI9XnJdlrYT8PUw+ZDfO2oDO1Zfvb+OS/Ci0UgUbg4FeRCw2n/oYajK3yCFKyYzOEy4yA33xjQnVOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6506007)(122000001)(508600001)(7416002)(38070700005)(33716001)(316002)(8676002)(71200400001)(54906003)(6916009)(9686003)(86362001)(8936002)(44832011)(5660300002)(66556008)(6512007)(38100700002)(4326008)(1076003)(66476007)(2906002)(6486002)(66946007)(83380400001)(76116006)(26005)(64756008)(66446008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ft/nXqmOZdksjU4josB34tMDhjfY3oKQmN3y/i/+5gX+40I6zPDlCeulBERa?=
 =?us-ascii?Q?OsGO+iuJsJwzxcwCpvoYkWO3hyp1mlby3FM9IEoc8XgVbByM5EqqRlNH7b5q?=
 =?us-ascii?Q?THIzkNrjDmn07T/vB0zp5yafn3jJQsmwd1xxFRRjdFLZPYQtHB1XxZMQlnX2?=
 =?us-ascii?Q?O2Bs+ZuXpH7ElMt/oDJlhgoPZQcAdA1bmdzc72yDkkV2rSmbsCN3AXr/jzQN?=
 =?us-ascii?Q?xTb7MPu1b2bVfilFNOgxvulKhEYwrBYVtl/Z03HW5cc/iinke/+cvxz+DJ3c?=
 =?us-ascii?Q?oaRnwwqVBZR0Uwqk1Awsp6Ml3dJydHYFYGYD9VhzlBKfNkXIqlvVZzvjWmbt?=
 =?us-ascii?Q?TvhzJlQOUzteroqlPCqka9O9gLLkHF5x+MtMWzIPVr2Qx5uLYeCU1Wvlhm8F?=
 =?us-ascii?Q?p+5qhIbqnTLJrDsqJOAa2/9JeFkC77+T17EahZxSYLSqd+2RecY2c9ahclfh?=
 =?us-ascii?Q?JJCB/6EsU6GRMmD1apPanfgDz0nG135uwwYTAQcudAUb467NTs6Mw/W/kYcz?=
 =?us-ascii?Q?GBjaPGRKYlR9dBQM0EurwQZtElARM9YCI6cMQl6PpKdWL970xnmvF7IAoxoa?=
 =?us-ascii?Q?WbKTc5bN6Iq1f4+A7ZdREyVwCGJNxzxWLNHIzJFFQXfSK2Q9SH5GeuJr+A+p?=
 =?us-ascii?Q?g/v8T4NBFgoLRJCFX3vcuw8cAgvvy+x/XkXGP+EXeSgMoqgvgKif25BWP85V?=
 =?us-ascii?Q?EJPcevi2GWELEYb/L2eZUDmDzrVCok78JNxbGPK7OiPXpiGnKruIyJk5jnVb?=
 =?us-ascii?Q?tbqzC0Fh5x7fEdqHjWgBuo/xB+64F++LwMJ8VKiGhTkqSboecHcYJYeT86Hg?=
 =?us-ascii?Q?RGK7SdbGbDP5yIzcyGX++SuvovzWJJSsspkrlkU/GMv2ya9Z09sJbX70ArD7?=
 =?us-ascii?Q?gpejWLWqMbtoGGwt4aC3WaW+3QsCKhgcrrNotv/W5KN7A+2Hg9rCSuJhbjDY?=
 =?us-ascii?Q?oWBIt5SoOKo5RvnIp0wGZFFZBLW8IKbD1YT0R7lTI7dOFaCZGbscRj1vW2rk?=
 =?us-ascii?Q?bE/ugZuQk32tkR8px6zCl0KeeobLANLNtq8kTMgEFqJcPmNQbOB3B/s94AeV?=
 =?us-ascii?Q?NZinOwJogWASGl6V4+d5tv4YjZk0TK+02O5qDP9kdRUQXwUhly/CRh13M4iU?=
 =?us-ascii?Q?xZRBE+i2r7iw1r69Uv5GQwW8R3Uw12RrDqL/NY2NJQ2nfX4OOW01bhvrR+wR?=
 =?us-ascii?Q?qWm0aFKsprFHacPaMVZ4fwTmaGL0uMLX+lTR/jPxGxsMj6C2kPV6uBam9Vzs?=
 =?us-ascii?Q?eQoa2vf1JF204DptDgQoIqEq78Nd/HVDbauVaE1kV/2rTHeOh9Fzp4sqI0nl?=
 =?us-ascii?Q?FlFAuOxLGxdPBZicJx5Rc92XThjD43Io4kO+4rBKBlQNIGlxeYm4HWG71E2P?=
 =?us-ascii?Q?OJvoPhIvAvxQ/P4dOi3631bbdY323ZIua9zAwQt+rFyH2IhDFZq28dLAP1pn?=
 =?us-ascii?Q?j18QYq3eH6VPy0d6Mq5AKWWoGNTLYXAXv25FP09WmFvGdT+4Ws4wwJ3grGoS?=
 =?us-ascii?Q?j++v8sv2aQPx2Iyaki9Uqdf8SYEFL8YQRZNQaIyyBs+bQ1uPBw7Qfqlgybhd?=
 =?us-ascii?Q?O5IVOEjDxssiBsbqs0tDxDpj1UuLA0wuK4dxXgFBNXZNMsG+8zuMxYQimcm5?=
 =?us-ascii?Q?FaLL80Vb4hiQZmKSE6qZtio=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF37F859A02BC742A34B072FD5430A0A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639c1f6e-eb8b-4dcc-42ba-08d9dc2fcc40
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 16:13:29.6410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: THYvRsuH7cjeD8inDVI43lorkWsqdhKQbIE4y7lEcBRjWjgnYU5KsEhlRmBW8+JjmPkBKOPcyw2ZhTBPp7gHyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 03:25:52PM -0800, Richard Cochran wrote:
> Both the vlan and the bonding drivers call their "real" device driver
> in order to report the time stamping capabilities.  Provide a core
> ethtool helper function to avoid copy/paste in the stack.
>=20
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/bonding/bond_main.c | 14 ++------------
>  include/linux/ethtool.h         |  8 ++++++++
>  net/8021q/vlan_dev.c            | 15 +--------------
>  net/ethtool/common.c            |  6 ++++++
>  4 files changed, 17 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
> index b60e22f6394a..f28b88b67b9e 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5353,23 +5353,13 @@ static int bond_ethtool_get_ts_info(struct net_de=
vice *bond_dev,
>  				    struct ethtool_ts_info *info)
>  {
>  	struct bonding *bond =3D netdev_priv(bond_dev);
> -	const struct ethtool_ops *ops;
>  	struct net_device *real_dev;
> -	struct phy_device *phydev;
> =20
>  	rcu_read_lock();
>  	real_dev =3D bond_option_active_slave_get_rcu(bond);
>  	rcu_read_unlock();

Side note: I'm a bit confused about this rcu_read_lock() ->
rcu_dereference_protected() -> rcu_read_unlock() pattern, and use of the
real_dev outside the RCU critical section. Isn't ->get_ts_info()
protected by the rtnl_mutex? Shouldn't there be a
bond_option_active_slave_get() which uses rtnl_dereference()?
I see the code has been recently added by Hangbin Liu.

> -	if (real_dev) {
> -		ops =3D real_dev->ethtool_ops;
> -		phydev =3D real_dev->phydev;
> -
> -		if (phy_has_tsinfo(phydev)) {
> -			return phy_ts_info(phydev, info);
> -		} else if (ops->get_ts_info) {
> -			return ops->get_ts_info(real_dev, info);
> -		}
> -	}
> +	if (real_dev)
> +		return ethtool_get_ts_info_by_layer(real_dev, info);
> =20
>  	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>  				SOF_TIMESTAMPING_SOFTWARE;
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index a26f37a27167..1d72344493bb 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -824,6 +824,14 @@ ethtool_params_from_link_mode(struct ethtool_link_ks=
ettings *link_ksettings,
>   */
>  int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
> =20
> +/**
> + * ethtool_get_ts_info_by_layer - Obtains time stamping capabilities fro=
m the MAC or PHY layer.
> + * @dev: pointer to net_device structure
> + * @info: buffer to hold the result
> + * Returns zero on sauces, non-zero otherwise.
> + */
> +int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_=
ts_info *info);
> +
>  /**
>   * ethtool_sprintf - Write formatted string to ethtool string data
>   * @data: Pointer to start of string to update
> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> index 26d031a43cc1..c645d7c46d78 100644
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -679,20 +679,7 @@ static int vlan_ethtool_get_ts_info(struct net_devic=
e *dev,
>  				    struct ethtool_ts_info *info)
>  {
>  	const struct vlan_dev_priv *vlan =3D vlan_dev_priv(dev);
> -	const struct ethtool_ops *ops =3D vlan->real_dev->ethtool_ops;
> -	struct phy_device *phydev =3D vlan->real_dev->phydev;
> -
> -	if (phy_has_tsinfo(phydev)) {
> -		return phy_ts_info(phydev, info);
> -	} else if (ops->get_ts_info) {
> -		return ops->get_ts_info(vlan->real_dev, info);
> -	} else {
> -		info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
> -			SOF_TIMESTAMPING_SOFTWARE;
> -		info->phc_index =3D -1;
> -	}
> -
> -	return 0;
> +	return ethtool_get_ts_info_by_layer(vlan->real_dev, info);
>  }
> =20
>  static void vlan_dev_get_stats64(struct net_device *dev,
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 0c5210015911..651d18eef589 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -569,6 +569,12 @@ int ethtool_get_phc_vclocks(struct net_device *dev, =
int **vclock_index)
>  }
>  EXPORT_SYMBOL(ethtool_get_phc_vclocks);
> =20
> +int ethtool_get_ts_info_by_layer(struct net_device *dev, struct ethtool_=
ts_info *info)
> +{
> +	return __ethtool_get_ts_info(dev, info);
> +}
> +EXPORT_SYMBOL(ethtool_get_ts_info_by_layer);

I would probably replace all __ethtool_get_ts_info() function name
occurrences with ethtool_get_ts_info_by_layer() (since it isn't a bad
name) to make it absolutely clear that it's recursive for VLAN and bond
interfaces. But maybe that's just me.

> +
>  const struct ethtool_phy_ops *ethtool_phy_ops;
> =20
>  void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops)
> --=20
> 2.20.1
>=
