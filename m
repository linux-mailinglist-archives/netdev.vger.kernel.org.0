Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F243A4766FC
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhLPAoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:44:21 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:62949
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231771AbhLPAoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 19:44:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLYGXFxX+JAYB2oQqtjUWp/hPslywugZJTH86ozM9EBVHsGRp4T24rmIBSBITHVlIFNv4CE90IP7fniQZMqXKGV9/B/l8qNev78QBsCGoRrKaDu+yPIRNZi3e0m18XHjK3H7J6YXxNqWjanGVUXwrgnA4owj84OWo8Le0vSng4IMPvMUxEg/x6nj/BQcT1nJY1uBimcR7tGp/E1UVFxuf6kZ5KIPb0ydj1KDl9OQeVNy3R1KWj4CgapwShazkUf4rSKUxTeICwbN+mWU5lNLNuAwSCCCjVBvZgCMzPRR7avItxvkEQZwViEeiuQLYxfh+TwhZWO0Ck4LhUXGTWv46g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FM2tgh+Ly/rA35qtFxmIiwRBUH60dCTiennatDdn8/w=;
 b=L4p3d8AH4TmpkSQjFqyQGta3uxaNFpqpCPwOc/QqUESEkSfmSl1A3r2ZdwccIEs4xgIZ46lI2Xn328mObZelsWeCA9j50b7yB2/wKciXUKUl2xKzCRJcSuOrwVTYAq90ARFuWA7d1CL9X7Z6HBVb1fe7z0dF+EADDH2XD98v4gXUKFfA/3NYY0pBOZ5DHit36SW5Zdv0+wIfVKMhWEn/XJxvnhjdTS6JzeWP5w1kkMOscacurlYeCRC0Ts6hC9Re2vPfJEf+O//0odY5bIACapQUHIGuIvBkxYSgakdrdbmySilOkWnmRLpCTKn35w0eWnkdbuAA5OUgPvqzkGn1pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FM2tgh+Ly/rA35qtFxmIiwRBUH60dCTiennatDdn8/w=;
 b=JzhqcVzcBwnejF4bCXHbtAA3m4C4x8/b47ceFf/9nPZlyOkeWCGrkyw3mpqtp4ay4BDG6BG/DbTjNj+CYIyO2i5s7D8wijSeOcYiDmOtK0psQAV8PfQGm9mx111ESIu+fFw8RZ5H7NBNLEcQxn4Mik32AS9Aj9HBIJjZiOtvSgk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6510.eurprd04.prod.outlook.com (2603:10a6:803:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 00:44:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Thu, 16 Dec 2021
 00:44:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v5 7/9] net: lan966x: Add vlan support.
Thread-Topic: [PATCH net-next v5 7/9] net: lan966x: Add vlan support.
Thread-Index: AQHX8a0RGYtZnTAufEqbE4DRZFNX+6w0SL+A
Date:   Thu, 16 Dec 2021 00:44:16 +0000
Message-ID: <20211216004415.zfypa3b35vgmlgk5@skbuf>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
 <20211215121309.3669119-8-horatiu.vultur@microchip.com>
In-Reply-To: <20211215121309.3669119-8-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9caee93-0fc5-4b1f-8167-08d9c02d307b
x-ms-traffictypediagnostic: VE1PR04MB6510:EE_
x-microsoft-antispam-prvs: <VE1PR04MB6510766DA89326C9C5E31017E0779@VE1PR04MB6510.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZZZi20bcwLVQ9BKkD0AMtPme31bVfCZujTd+vW5ED137oNCBWU2nd3j6qHHhrw1qDVc4G2JZh0zci5FD5juFG6lzI4TqXQt36/4qSmm1ZZNq7CTUQft6tQx/5wKpnM9OvE4CaJ+tRzy0E+8XczsiGaNJUiXLiQIrSujrd3AlCtYoWqXZbHFjYqihB6Ve0k1YRIy5yQdu3m1PlXHzvKvCMDSH/dDqQCJ/EVItPnJJ4eBDO+bvdkyzJ2VnaCVy5qr2/9FZ2woa4B1cc5hc2Ok8/yq0+c9V7uY6PmHVeE+UpJlb0EK9rC0ZglTVVoqtRm1zgW2Im3vHWvaYK8qRdhXo6Cl6h3LYgduf/MJTJLI5E5FZkBdaagmqS3Pu95O3KEyXq/IxItInc0IeUCVjMkaiASvt+cJYI1lLWs6bTPTLyQhEuK7fFnWDLtxVe88P1rzDAPo9ixIp5zrSI/oedfLyYYtaDiNYrdEQL5iKxGF72D4fC20JbjZG9IwF8a4stKfNFWUqN9TBefx6RZvV01G+878Vc1J4bXTPmbs0/neE9AzEIadSgyn09GKe+bnIOCMOPJeEHJzKb89nAPl2qXJq/JCU+vahUCpygIhx4BjXVs3bis8tBZszrd684MyQhsgDXjGx4VBKhaeMEnR0q+TyNb6SS9K/FW/fO3k3biySozzcNxzNYMVSKERVYpOPa0X+TWTyB0ZoVfay/jyxwCeNWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66476007)(66446008)(76116006)(2906002)(83380400001)(54906003)(5660300002)(33716001)(9686003)(64756008)(38100700002)(86362001)(122000001)(44832011)(6506007)(66946007)(4326008)(91956017)(6486002)(508600001)(26005)(66556008)(1076003)(316002)(71200400001)(6916009)(8676002)(8936002)(38070700005)(30864003)(7416002)(6512007)(186003)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hs7MKoByxo9ZNMejuWsniYhEWGeC9udX3qW+iAoDEM/VRZh7XQ3q/iXzU86p?=
 =?us-ascii?Q?WAwq05IRH9ALPVLKAyPFZ0ehZHWfkwk2WK1U75K+6DRj+V/CLcW1s3Es0NGs?=
 =?us-ascii?Q?pD7vFu3FWlC7AjFkkx7tdmW85KxesMqd7e1VEsH9coCzCczPnEjn/v/ZuLhr?=
 =?us-ascii?Q?N7Rdj4MsDb5iSUNhSKIfuOo+9iaJGFOg8hjYCJva9+bQsmrcLy2Ew7yNv/kx?=
 =?us-ascii?Q?76MbAicaZcMOZTscYznhpORiLS70Gc+XgRyPvYDgpUlPVKzBaxYedGwB8+/B?=
 =?us-ascii?Q?SOeDETX0c+WKSA0dC2IU8gQQRSsSdQ+iNO0+tCP/kVIkxr3th1mg4tjSrZr6?=
 =?us-ascii?Q?l8kEEX3VRi5CnES7FyZ1bsX2gbqIcZf2ttDRiRchNk3dEwwZxBG5kGJ8bNQW?=
 =?us-ascii?Q?Tk0vjifQLdzdQeRP+bT2aao7HR9xW3RB5DC1BTY8nTej1ORjnMwTKKgVBodQ?=
 =?us-ascii?Q?EaaHuz6EnD1SVHdLWQVuFmVekkvCihYmAbpxgpD7CEfLe0CSR36IM3tXhh67?=
 =?us-ascii?Q?CpI1EdNQ5mxXaLweSYv33JSMvY5oDMYWPbWMb0IAujSmmBwPgtAKreGZjDsJ?=
 =?us-ascii?Q?xI6mXL92AdOlNBWqrq3e1Xfj7BpMWWpWCtIgh+WytJWZk8Z2V92jUjegC8UJ?=
 =?us-ascii?Q?ykIKIAKo2bNZMtYw6aasMsa7Fw65o2U+GPnaibPAVbvPljkFtXeJHvZ7S6yp?=
 =?us-ascii?Q?8vrXjg6jVuQRGQIaik2rdxjw5gzjBrnxzVkEMGFMnqdjDUBKG036YoI5jAM7?=
 =?us-ascii?Q?VSF77y1XJj6S35X/hF1CWfgprvrsxAmqSq8Js89N/oGybwgP1rx2kjS5NmC0?=
 =?us-ascii?Q?6lTTgWTmqCaKAsFfL9AGu/t9tCoVkNMV78wk1JKw6JcoOv5cehaBhZeMNlP/?=
 =?us-ascii?Q?MGY5kdlTotG7s112RC2eSYaeiYJSk7bFYSxy1KqSNuObwig0mVEtkG60eDyQ?=
 =?us-ascii?Q?I2s1csuaYtuCimA3LFHArCMadGWfaPZMYrTK8sosp7osIw/sT7/giMxj4kzv?=
 =?us-ascii?Q?5Kemlo2rwbG4GKe1noQG5webIiDGPNoWZjG220yP18mC4faRHI3jRAQSH0h9?=
 =?us-ascii?Q?joqjUyDpUyRSYiyAUwJ2cGYTBQbAdRGSgD0sHc5+QboZukEM1f0Jzhb4Z5S7?=
 =?us-ascii?Q?KWIrjDs7zxTSMXJat8ErE2DWQWsJv58sQl36RaJqWXag0hlGke/epVm+YC96?=
 =?us-ascii?Q?/myUY/XuSaYXo6KfAx0R8u/G2dpb5X6B01mVuz1hsMVCc8AiyTcneO3k2wL/?=
 =?us-ascii?Q?HKaHSTCkNcNnOUeyh/GSKJM/mM+00K0561M0TV5X4QV6/1TU2bBj06EmKAOk?=
 =?us-ascii?Q?8TwqjKoR6bVwdsp46y46Yvy4oJit0feuQMH68D1dB/nwcWe1sQjiuUWpq9j1?=
 =?us-ascii?Q?dFEsMX1/4TDAbnP2wCTh0AwoesYThRx6BQfBp6KABsvV0UG5cGGYATs6Ryl9?=
 =?us-ascii?Q?RZaMQNx5wCwhPb1TqM9MWAvGxnebG/7mBpdkDqVK9j310CdXSYRwUlmfbdQ8?=
 =?us-ascii?Q?ko8Ab4LVfDwQ3/+9jL8SJiS9te+ThnzXH23t5WTeh+4li/il8/XiMCtJLYFw?=
 =?us-ascii?Q?zhLYvAscwQHyjqIWrBW44Rjdb9o56Kfnk5T0VUlZnf1aMdUyReHDbBYcU23E?=
 =?us-ascii?Q?SurckDe0dEqloUe0YI1gXzE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E067CA885AAA4741BC357BEB91052D34@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9caee93-0fc5-4b1f-8167-08d9c02d307b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 00:44:16.7378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kYj0EgC401Knmdp549LbpjxOuNtVMkxtX+sblAIRMZV5/WqGCGXIS3/SJ8k7hEoSgHmiKfSk88hflaqdomYilw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 01:13:07PM +0100, Horatiu Vultur wrote:
> Extend the driver to support vlan filtering  by implementing the
> switchdev calls SWITCHDEV_OBJ_ID_PORT_VLAN and
> SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING.

And the VLAN RX filtering net device ops.

>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c |  39 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  40 +-
>  .../microchip/lan966x/lan966x_switchdev.c     | 113 ++++-
>  .../ethernet/microchip/lan966x/lan966x_vlan.c | 444 ++++++++++++++++++
>  5 files changed, 632 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/ne=
t/ethernet/microchip/lan966x/Makefile
> index 974229c51f55..d82e896c2e53 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -6,4 +6,5 @@
>  obj-$(CONFIG_LAN966X_SWITCH) +=3D lan966x-switch.o
> =20
>  lan966x-switch-objs  :=3D lan966x_main.o lan966x_phylink.o lan966x_port.=
o \
> -			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
> +			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
> +			lan966x_vlan.o
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index ee453967da71..881c1678f3e9 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -103,17 +103,18 @@ static int lan966x_create_targets(struct platform_d=
evice *pdev,
>  static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
>  {
>  	struct lan966x_port *port =3D netdev_priv(dev);
> +	u16 pvid =3D lan966x_vlan_port_get_pvid(port);
>  	struct lan966x *lan966x =3D port->lan966x;
>  	const struct sockaddr *addr =3D p;
>  	int ret;
> =20
>  	/* Learn the new net device MAC address in the mac table. */
> -	ret =3D lan966x_mac_cpu_learn(lan966x, addr->sa_data, port->pvid);
> +	ret =3D lan966x_mac_cpu_learn(lan966x, addr->sa_data, pvid);

Logically speaking, there is a divide of responsibility. The bridge
emits switchdev FDB events for local MAC addresses, with a VID of 0
(corresponding to VLAN-unaware bridging) as well as for each installed
VLAN. Bridge VLAN 0 is equivalent to your UNAWARE_PVID macro. And the
driver is solely responsible for the MAC address in the HOST_PVID VLAN.
When the ndo_set_mac_address is called, you should just update the entry
learned in the HOST_PVID. The bridge will get an NETDEV_CHANGEADDR event
and update its local MAC addresses too, in the VLANs it handles.
Otherwise, if you just learn in the pvid that the port is currently in,
then RX filtering will be broken if you change your MAC address while
you're under a bridge, then you leave that bridge and become standalone.
So you need to re-learn the dev_addr in lan966x_port_bridge_leave, which
makes the implementation a bit more complicated than it needs to be
(unless I'm missing something about CPU-learned MAC addresses in VLANs
that aren't currently active, you seem to be avoiding that even though
it makes the driver keep a lot more state).

>  	if (ret)
>  		return ret;
> =20
>  	/* Then forget the previous one. */
> -	ret =3D lan966x_mac_cpu_forget(lan966x, dev->dev_addr, port->pvid);
> +	ret =3D lan966x_mac_cpu_forget(lan966x, dev->dev_addr, pvid);
>  	if (ret)
>  		return ret;
> =20
> @@ -283,6 +284,12 @@ static void lan966x_ifh_set_ipv(void *ifh, u64 bypas=
s)
>  		IFH_POS_IPV, IFH_LEN * 4, PACK, 0);
>  }
> =20
> +static void lan966x_ifh_set_vid(void *ifh, u64 vid)
> +{
> +	packing(ifh, &vid, IFH_POS_TCI + IFH_WID_TCI - 1,
> +		IFH_POS_TCI, IFH_LEN * 4, PACK, 0);
> +}
> +
>  static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev=
)
>  {
>  	struct lan966x_port *port =3D netdev_priv(dev);
> @@ -294,6 +301,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, str=
uct net_device *dev)
>  	lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
>  	lan966x_ifh_set_qos_class(ifh, skb->priority >=3D 7 ? 0x7 : skb->priori=
ty);
>  	lan966x_ifh_set_ipv(ifh, skb->priority >=3D 7 ? 0x7 : skb->priority);
> +	lan966x_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
> =20
>  	return lan966x_port_ifh_xmit(skb, ifh, dev);
>  }
> @@ -343,6 +351,18 @@ static int lan966x_port_get_parent_id(struct net_dev=
ice *dev,
>  	return 0;
>  }
> =20
> +static int lan966x_port_set_features(struct net_device *dev,
> +				     netdev_features_t features)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	netdev_features_t changed =3D dev->features ^ features;
> +
> +	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
> +		lan966x_vlan_mode(port, features);
> +
> +	return 0;
> +}
> +
>  static const struct net_device_ops lan966x_port_netdev_ops =3D {
>  	.ndo_open			=3D lan966x_port_open,
>  	.ndo_stop			=3D lan966x_port_stop,
> @@ -353,6 +373,9 @@ static const struct net_device_ops lan966x_port_netde=
v_ops =3D {
>  	.ndo_get_stats64		=3D lan966x_stats_get,
>  	.ndo_set_mac_address		=3D lan966x_port_set_mac_address,
>  	.ndo_get_port_parent_id		=3D lan966x_port_get_parent_id,
> +	.ndo_set_features		=3D lan966x_port_set_features,
> +	.ndo_vlan_rx_add_vid		=3D lan966x_vlan_rx_add_vid,
> +	.ndo_vlan_rx_kill_vid		=3D lan966x_vlan_rx_kill_vid,

Do you have any particular use case for NETIF_F_HW_VLAN_CTAG_FILTER on
non-bridged ports? I find the fact that you implement these very strange
and likely bogus: you set port->vlan_aware =3D false when a port leaves a
bridge, yet you install VLANs to its RX filter as if those VLANs were to
actually match on any VLAN-tagged packet... which they won't because
lan966x_vlan_port_apply() clears ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) when
port->vlan_aware isn't set. So you end up being "filtering" but not "aware"
- all packets get classified to the same VLAN, which isn't dropped.

>  };
> =20
>  bool lan966x_netdevice_check(const struct net_device *dev)
> @@ -575,13 +598,16 @@ static int lan966x_probe_port(struct lan966x *lan96=
6x, u32 p,
>  	port->dev =3D dev;
>  	port->lan966x =3D lan966x;
>  	port->chip_port =3D p;
> -	port->pvid =3D PORT_PVID;
>  	lan966x->ports[p] =3D port;
> =20
>  	dev->max_mtu =3D ETH_MAX_MTU;
> =20
>  	dev->netdev_ops =3D &lan966x_port_netdev_ops;
>  	dev->ethtool_ops =3D &lan966x_ethtool_ops;
> +	dev->hw_features |=3D NETIF_F_HW_VLAN_CTAG_FILTER;
> +	dev->features |=3D NETIF_F_HW_VLAN_CTAG_FILTER |
> +			 NETIF_F_HW_VLAN_CTAG_TX |
> +			 NETIF_F_HW_VLAN_STAG_TX;
>  	dev->needed_headroom =3D IFH_LEN * sizeof(u32);
> =20
>  	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
> @@ -625,6 +651,10 @@ static int lan966x_probe_port(struct lan966x *lan966=
x, u32 p,
>  		return err;
>  	}
> =20
> +	lan966x_vlan_port_set_vlan_aware(port, 0);
> +	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> +	lan966x_vlan_port_apply(port);
> +
>  	return 0;
>  }
> =20
> @@ -635,6 +665,9 @@ static void lan966x_init(struct lan966x *lan966x)
>  	/* MAC table initialization */
>  	lan966x_mac_init(lan966x);
> =20
> +	/* Vlan initialization */
> +	lan966x_vlan_init(lan966x);

Curious how the lan966x_ext_entry stuff doesn't have any comment and
lan966x_vlan_init has such a trivial one?!

> +
>  	/* Flush queues */
>  	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
>  	       GENMASK(1, 0),
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 3d228c9c0521..6d0d922617ae 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -4,6 +4,7 @@
>  #define __LAN966X_MAIN_H__
> =20
>  #include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
>  #include <linux/jiffies.h>
>  #include <linux/phy.h>
>  #include <linux/phylink.h>
> @@ -22,7 +23,8 @@
>  #define PGID_SRC			80
>  #define PGID_ENTRIES			89
> =20
> -#define PORT_PVID			0
> +#define UNAWARE_PVID			0
> +#define HOST_PVID			4095
> =20
>  /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
>  #define QSYS_Q_RSRV			95
> @@ -82,6 +84,9 @@ struct lan966x {
>  	struct list_head mac_entries;
>  	spinlock_t mac_lock; /* lock for mac_entries list */
> =20
> +	u16 vlan_mask[VLAN_N_VID];
> +	DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
> +
>  	/* stats */
>  	const struct lan966x_stat_layout *stats_layout;
>  	u32 num_stats;
> @@ -113,6 +118,8 @@ struct lan966x_port {
> =20
>  	u8 chip_port;
>  	u16 pvid;
> +	u16 vid;
> +	u8 vlan_aware;

bool

> =20
>  	struct phylink_config phylink_config;
>  	struct phylink_pcs phylink_pcs;
> @@ -168,6 +175,37 @@ irqreturn_t lan966x_mac_irq_handler(struct lan966x *=
lan966x);
> =20
>  void lan966x_ext_purge_entries(void);
> =20
> +void lan966x_vlan_init(struct lan966x *lan966x);
> +void lan966x_vlan_port_apply(struct lan966x_port *port);
> +
> +int lan966x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vi=
d);
> +int lan966x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 v=
id);
> +
> +void lan966x_vlan_mode(struct lan966x_port *port, netdev_features_t feat=
ures);
> +u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port);
> +
> +bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 =
vid);
> +void lan966x_vlan_cpu_add_cpu_vlan_mask(struct lan966x *lan966x, u16 vid=
);
> +bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid);
> +
> +void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port);
> +void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
> +				      bool vlan_aware);
> +int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
> +			      bool pvid, bool untagged);
> +int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
> +			       u16 vid,
> +			       bool pvid,
> +			       bool untagged);
> +int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
> +			       u16 vid);
> +int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
> +			      struct net_device *dev,
> +			      u16 vid);
> +int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
> +			      struct net_device *dev,
> +			      u16 vid);
> +
>  static inline void __iomem *lan_addr(void __iomem *base[],
>  				     int id, int tinst, int tcnt,
>  				     int gbase, int ginst,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> index 722ce7cb61b3..61f9e906cf80 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -82,6 +82,11 @@ static int lan966x_port_attr_set(struct net_device *de=
v, const void *ctx,
>  	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
>  		lan966x_port_ageing_set(port, attr->u.ageing_time);
>  		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> +		lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
> +		lan966x_vlan_port_apply(port);
> +		lan966x_vlan_cpu_set_vlan_aware(port);
> +		break;
>  	default:
>  		err =3D -EOPNOTSUPP;
>  		break;
> @@ -127,7 +132,12 @@ static void lan966x_port_bridge_leave(struct lan966x=
_port *port,
>  	if (!lan966x->bridge_mask)
>  		lan966x->bridge =3D NULL;
> =20
> -	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
> +	/* Set the port back to host mode */
> +	lan966x_vlan_port_set_vlan_aware(port, false);
> +	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> +	lan966x_vlan_port_apply(port);
> +
> +	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);
>  }
> =20
>  static int lan966x_port_changeupper(struct net_device *dev,
> @@ -169,7 +179,7 @@ static int lan966x_port_add_addr(struct net_device *d=
ev, bool up)
>  	struct lan966x *lan966x =3D port->lan966x;
>  	u16 vid;
> =20
> -	vid =3D port->pvid;
> +	vid =3D lan966x_vlan_port_get_pvid(port);
> =20
>  	if (up)
>  		lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> @@ -348,6 +358,95 @@ static int lan966x_switchdev_event(struct notifier_b=
lock *nb,
>  	return NOTIFY_DONE;
>  }
> =20
> +static int lan966x_handle_port_vlan_add(struct lan966x_port *port,
> +					const struct switchdev_obj *obj)
> +{
> +	const struct switchdev_obj_port_vlan *v =3D SWITCHDEV_OBJ_PORT_VLAN(obj=
);
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	/* When adding a port to a vlan, we get a callback for the port but
> +	 * also for the bridge. When get the callback for the bridge just bail
> +	 * out. Then when the bridge is added to the vlan, then we get a
> +	 * callback here but in this case the flags has set:
> +	 * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
> +	 * port is added to the vlan, so the broadcast frames and unicast frame=
s
> +	 * with dmac of the bridge should be foward to CPU.
> +	 */
> +	if (netif_is_bridge_master(obj->orig_dev) &&
> +	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
> +		return 0;
> +
> +	if (!netif_is_bridge_master(obj->orig_dev))
> +		return lan966x_vlan_port_add_vlan(port, v->vid,
> +						  v->flags & BRIDGE_VLAN_INFO_PVID,
> +						  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
> +
> +	if (netif_is_bridge_master(obj->orig_dev))

"else" will suffice.

> +		return lan966x_vlan_cpu_add_vlan(lan966x, obj->orig_dev, v->vid);
> +
> +	return 0;
> +}
> +
> +static int lan966x_handle_port_obj_add(struct net_device *dev, const voi=
d *ctx,
> +				       const struct switchdev_obj *obj,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	int err;
> +
> +	if (ctx && ctx !=3D port)
> +		return 0;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		err =3D lan966x_handle_port_vlan_add(port, obj);
> +		break;
> +	default:
> +		err =3D -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_handle_port_vlan_del(struct lan966x_port *port,
> +					const struct switchdev_obj *obj)
> +{
> +	const struct switchdev_obj_port_vlan *v =3D SWITCHDEV_OBJ_PORT_VLAN(obj=
);
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	/* In case the physical port gets called */
> +	if (!netif_is_bridge_master(obj->orig_dev))
> +		return lan966x_vlan_port_del_vlan(port, v->vid);
> +
> +	/* In case the bridge gets called */
> +	if (netif_is_bridge_master(obj->orig_dev))

likewise.

> +		return lan966x_vlan_cpu_del_vlan(lan966x, obj->orig_dev, v->vid);
> +
> +	return 0;
> +}
> +
> +static int lan966x_handle_port_obj_del(struct net_device *dev, const voi=
d *ctx,
> +				       const struct switchdev_obj *obj)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	int err;
> +
> +	if (ctx && ctx !=3D port)
> +		return 0;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		err =3D lan966x_handle_port_vlan_del(port, obj);
> +		break;
> +	default:
> +		err =3D -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
>  static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
>  					    unsigned long event,
>  					    void *ptr)
> @@ -356,6 +455,16 @@ static int lan966x_switchdev_blocking_event(struct n=
otifier_block *nb,
>  	int err;
> =20
>  	switch (event) {
> +	case SWITCHDEV_PORT_OBJ_ADD:
> +		err =3D switchdev_handle_port_obj_add(dev, ptr,
> +						    lan966x_netdevice_check,
> +						    lan966x_handle_port_obj_add);
> +		return notifier_from_errno(err);
> +	case SWITCHDEV_PORT_OBJ_DEL:
> +		err =3D switchdev_handle_port_obj_del(dev, ptr,
> +						    lan966x_netdevice_check,
> +						    lan966x_handle_port_obj_del);
> +		return notifier_from_errno(err);
>  	case SWITCHDEV_PORT_ATTR_SET:
>  		err =3D switchdev_handle_port_attr_set(dev, ptr,
>  						     lan966x_netdevice_check,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> new file mode 100644
> index 000000000000..e8ff95bb65fa
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> @@ -0,0 +1,444 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include "lan966x_main.h"
> +
> +#define VLANACCESS_CMD_IDLE		0
> +#define VLANACCESS_CMD_READ		1
> +#define VLANACCESS_CMD_WRITE		2
> +#define VLANACCESS_CMD_INIT		3
> +
> +static int lan966x_vlan_get_status(struct lan966x *lan966x)
> +{
> +	return lan_rd(lan966x, ANA_VLANACCESS);
> +}
> +
> +static int lan966x_vlan_wait_for_completion(struct lan966x *lan966x)
> +{
> +	u32 val;
> +
> +	return readx_poll_timeout(lan966x_vlan_get_status,
> +		lan966x, val,
> +		(val & ANA_VLANACCESS_VLAN_TBL_CMD) =3D=3D
> +		VLANACCESS_CMD_IDLE,
> +		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
> +}
> +
> +static int lan966x_vlan_set_mask(struct lan966x *lan966x, u16 vid)
> +{
> +	u16 mask =3D lan966x->vlan_mask[vid];
> +	bool cpu_dis;
> +
> +	cpu_dis =3D !(mask & BIT(CPU_PORT));
> +
> +	/* Set flags and the VID to configure */
> +	lan_rmw(ANA_VLANTIDX_VLAN_PGID_CPU_DIS_SET(cpu_dis) |
> +		ANA_VLANTIDX_V_INDEX_SET(vid),
> +		ANA_VLANTIDX_VLAN_PGID_CPU_DIS |
> +		ANA_VLANTIDX_V_INDEX,
> +		lan966x, ANA_VLANTIDX);
> +
> +	/* Set the vlan port members mask */
> +	lan_rmw(ANA_VLAN_PORT_MASK_VLAN_PORT_MASK_SET(mask),
> +		ANA_VLAN_PORT_MASK_VLAN_PORT_MASK,
> +		lan966x, ANA_VLAN_PORT_MASK);
> +
> +	/* Issue a write command */
> +	lan_rmw(ANA_VLANACCESS_VLAN_TBL_CMD_SET(VLANACCESS_CMD_WRITE),
> +		ANA_VLANACCESS_VLAN_TBL_CMD,
> +		lan966x, ANA_VLANACCESS);
> +
> +	return lan966x_vlan_wait_for_completion(lan966x);

If you're not going to propagate the return code anywhere, at least
return void and print an error here. Otherwise it's totally silent.

> +}
> +
> +void lan966x_vlan_init(struct lan966x *lan966x)
> +{
> +	u16 port, vid;
> +
> +	/* Clear VLAN table, by default all ports are members of all VLANS */
> +	lan_rmw(ANA_VLANACCESS_VLAN_TBL_CMD_SET(VLANACCESS_CMD_INIT),
> +		ANA_VLANACCESS_VLAN_TBL_CMD,
> +		lan966x, ANA_VLANACCESS);
> +	lan966x_vlan_wait_for_completion(lan966x);

Again no error checking.

> +
> +	for (vid =3D 1; vid < VLAN_N_VID; vid++) {
> +		lan966x->vlan_mask[vid] =3D 0;
> +		lan966x_vlan_set_mask(lan966x, vid);
> +	}
> +
> +	/* Set all the ports + cpu to be part of HOST_PVID and UNAWARE_PVID */
> +	lan966x->vlan_mask[HOST_PVID] =3D
> +		GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
> +	lan966x_vlan_set_mask(lan966x, HOST_PVID);
> +
> +	lan966x->vlan_mask[UNAWARE_PVID] =3D
> +		GENMASK(lan966x->num_phys_ports - 1, 0) | BIT(CPU_PORT);
> +	lan966x_vlan_set_mask(lan966x, UNAWARE_PVID);
> +
> +	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, UNAWARE_PVID);
> +
> +	/* Configure the CPU port to be vlan aware */
> +	lan_wr(ANA_VLAN_CFG_VLAN_VID_SET(0) |
> +	       ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) |
> +	       ANA_VLAN_CFG_VLAN_POP_CNT_SET(1),
> +	       lan966x, ANA_VLAN_CFG(CPU_PORT));
> +
> +	/* Set vlan ingress filter mask to all ports */
> +	lan_wr(GENMASK(lan966x->num_phys_ports, 0),
> +	       lan966x, ANA_VLANMASK);
> +
> +	for (port =3D 0; port < lan966x->num_phys_ports; port++) {
> +		lan_wr(0, lan966x, REW_PORT_VLAN_CFG(port));
> +		lan_wr(0, lan966x, REW_TAG_CFG(port));
> +	}
> +}
> +
> +static int lan966x_vlan_port_add_vlan_mask(struct lan966x_port *port, u1=
6 vid)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u8 p =3D port->chip_port;
> +
> +	lan966x->vlan_mask[vid] |=3D BIT(p);
> +	return lan966x_vlan_set_mask(lan966x, vid);
> +}
> +
> +static int lan966x_vlan_port_del_vlan_mask(struct lan966x_port *port, u1=
6 vid)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u8 p =3D port->chip_port;
> +
> +	lan966x->vlan_mask[vid] &=3D ~BIT(p);
> +	return lan966x_vlan_set_mask(lan966x, vid);
> +}
> +
> +static bool lan966x_vlan_port_member_vlan_mask(struct lan966x_port *port=
, u16 vid)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u8 p =3D port->chip_port;
> +
> +	return lan966x->vlan_mask[vid] & BIT(p);
> +}
> +
> +bool lan966x_vlan_port_any_vlan_mask(struct lan966x *lan966x, u16 vid)
> +{
> +	return !!(lan966x->vlan_mask[vid] & ~BIT(CPU_PORT));
> +}
> +
> +static int lan966x_vlan_cpu_add_vlan_mask(struct lan966x *lan966x, u16 v=
id)
> +{
> +	lan966x->vlan_mask[vid] |=3D BIT(CPU_PORT);
> +	return lan966x_vlan_set_mask(lan966x, vid);
> +}
> +
> +static int lan966x_vlan_cpu_del_vlan_mask(struct lan966x *lan966x, u16 v=
id)
> +{
> +	lan966x->vlan_mask[vid] &=3D ~BIT(CPU_PORT);
> +	return lan966x_vlan_set_mask(lan966x, vid);
> +}
> +
> +void lan966x_vlan_cpu_add_cpu_vlan_mask(struct lan966x *lan966x, u16 vid=
)
> +{
> +	set_bit(vid, lan966x->cpu_vlan_mask);

Since these are all serialized by the rtnl_mutex, I think it's safe to
replace with __set_bit which is non-atomic and thus cheaper.

> +}
> +
> +static void lan966x_vlan_cpu_del_cpu_vlan_mask(struct lan966x *lan966x, =
u16 vid)
> +{
> +	clear_bit(vid, lan966x->cpu_vlan_mask);
> +}
> +
> +bool lan966x_vlan_cpu_member_cpu_vlan_mask(struct lan966x *lan966x, u16 =
vid)
> +{
> +	return test_bit(vid, lan966x->cpu_vlan_mask);
> +}
> +
> +u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	if (!(lan966x->bridge_mask & BIT(port->chip_port)))
> +		return HOST_PVID;
> +
> +	return port->vlan_aware ? port->pvid : UNAWARE_PVID;
> +}
> +
> +int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
> +			      bool pvid, bool untagged)

If you were to summarize what this function does, what would that be?

> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	/* Egress vlan classification */
> +	if (untagged && port->vid !=3D vid) {
> +		if (port->vid) {
> +			dev_err(lan966x->dev,
> +				"Port already has a native VLAN: %d\n",
> +				port->vid);
> +			return -EBUSY;
> +		}
> +		port->vid =3D vid;
> +	}
> +
> +	/* Default ingress vlan classification */
> +	if (pvid)
> +		port->pvid =3D vid;
> +
> +	return 0;
> +}
> +
> +static int lan966x_vlan_port_remove_vid(struct lan966x_port *port, u16 v=
id)
> +{
> +	if (port->pvid =3D=3D vid)
> +		port->pvid =3D 0;
> +
> +	if (port->vid =3D=3D vid)
> +		port->vid =3D 0;
> +
> +	return 0;
> +}
> +
> +void lan966x_vlan_port_set_vlan_aware(struct lan966x_port *port,
> +				      bool vlan_aware)
> +{
> +	port->vlan_aware =3D vlan_aware;
> +}
> +
> +void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_port *port)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	if (!port->vlan_aware) {
> +		/* In case of vlan unaware, all the ports will be set in
> +		 * UNAWARE_PVID and have their PVID set to this PVID
> +		 * The CPU doesn't need to be added because it is always part of
> +		 * that vlan, it is required just to add entries in the MAC
> +		 * table for the front port and the CPU
> +		 */
> +		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> +		lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr,
> +				      UNAWARE_PVID);
> +
> +		lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
> +		lan966x_vlan_port_apply(port);
> +	} else {
> +		/* In case of vlan aware, just clear what happened when changed
> +		 * to vlan unaware
> +		 */
> +		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> +		lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr,
> +				       UNAWARE_PVID);
> +
> +		lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
> +		lan966x_vlan_port_apply(port);
> +	}
> +}
> +
> +void lan966x_vlan_port_apply(struct lan966x_port *port)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u16 pvid;
> +	u32 val;
> +
> +	pvid =3D lan966x_vlan_port_get_pvid(port);
> +
> +	/* Ingress clasification (ANA_PORT_VLAN_CFG) */
> +	/* Default vlan to casify for untagged frames (may be zero) */

classify

> +	val =3D ANA_VLAN_CFG_VLAN_VID_SET(pvid);
> +	if (port->vlan_aware)
> +		val |=3D ANA_VLAN_CFG_VLAN_AWARE_ENA_SET(1) |
> +		       ANA_VLAN_CFG_VLAN_POP_CNT_SET(1);
> +
> +	lan_rmw(val,
> +		ANA_VLAN_CFG_VLAN_VID | ANA_VLAN_CFG_VLAN_AWARE_ENA |
> +		ANA_VLAN_CFG_VLAN_POP_CNT,
> +		lan966x, ANA_VLAN_CFG(port->chip_port));
> +
> +	/* Drop frames with multicast source address */
> +	val =3D ANA_DROP_CFG_DROP_MC_SMAC_ENA_SET(1);
> +	if (port->vlan_aware && !pvid)
> +		/* If port is vlan-aware and tagged, drop untagged and priority
> +		 * tagged frames.
> +		 */
> +		val |=3D ANA_DROP_CFG_DROP_UNTAGGED_ENA_SET(1) |
> +		       ANA_DROP_CFG_DROP_PRIO_S_TAGGED_ENA_SET(1) |
> +		       ANA_DROP_CFG_DROP_PRIO_C_TAGGED_ENA_SET(1);
> +
> +	lan_wr(val, lan966x, ANA_DROP_CFG(port->chip_port));
> +
> +	/* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q */
> +	val =3D REW_TAG_CFG_TAG_TPID_CFG_SET(0);
> +	if (port->vlan_aware) {
> +		if (port->vid)
> +			/* Tag all frames except when VID =3D=3D DEFAULT_VLAN */
> +			val |=3D REW_TAG_CFG_TAG_CFG_SET(1);
> +		else
> +			val |=3D REW_TAG_CFG_TAG_CFG_SET(3);
> +	}
> +
> +	/* Update only some bits in the register */
> +	lan_rmw(val,
> +		REW_TAG_CFG_TAG_TPID_CFG | REW_TAG_CFG_TAG_CFG,
> +		lan966x, REW_TAG_CFG(port->chip_port));
> +
> +	/* Set default VLAN and tag type to 8021Q */
> +	lan_rmw(REW_PORT_VLAN_CFG_PORT_TPID_SET(ETH_P_8021Q) |
> +		REW_PORT_VLAN_CFG_PORT_VID_SET(port->vid),
> +		REW_PORT_VLAN_CFG_PORT_TPID |
> +		REW_PORT_VLAN_CFG_PORT_VID,
> +		lan966x, REW_PORT_VLAN_CFG(port->chip_port));
> +}
> +
> +int lan966x_vlan_port_add_vlan(struct lan966x_port *port,
> +			       u16 vid,
> +			       bool pvid,
> +			       bool untagged)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	/* If the CPU(br) is already part of the vlan then add the MAC
> +	 * address of the device in MAC table to copy the frames to the
> +	 * CPU(br). If the CPU(br) is not part of the vlan then it would
> +	 * just drop the frames.
> +	 */
> +	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
> +		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
> +		lan966x_mac_cpu_learn(lan966x, lan966x->bridge->dev_addr, vid);

Doesn't the bridge notify you of all the addresses you need to learn on
the CPU port? What is the benefit of the added complexity of only
learning the addresses when the CPU joins the VLAN? Doesn't the CPU_DIS
bit work if an entry is present in the MAC table?

> +		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
> +	}
> +
> +	lan966x_vlan_port_set_vid(port, vid, pvid, untagged);
> +	lan966x_vlan_port_add_vlan_mask(port, vid);
> +	lan966x_vlan_port_apply(port);
> +
> +	return 0;
> +}
> +
> +int lan966x_vlan_port_del_vlan(struct lan966x_port *port,
> +			       u16 vid)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	/* In case the CPU(br) is part of the vlan then remove the MAC entry
> +	 * because frame doesn't need to reach to CPU
> +	 */
> +	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid))
> +		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, vid);
> +
> +	lan966x_vlan_port_remove_vid(port, vid);
> +	lan966x_vlan_port_del_vlan_mask(port, vid);
> +	lan966x_vlan_port_apply(port);
> +
> +	/* In case there are no other ports in vlan then remove the CPU from
> +	 * that vlan but still keep it in the mask because it may be needed
> +	 * again then another port gets added in tha vlan

s/tha/that/

> +	 */
> +	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
> +		lan966x_mac_cpu_forget(lan966x, lan966x->bridge->dev_addr, vid);
> +		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
> +	}
> +
> +	return 0;
> +}
> +
> +int lan966x_vlan_cpu_add_vlan(struct lan966x *lan966x,
> +			      struct net_device *dev,
> +			      u16 vid)
> +{
> +	int p;
> +
> +	/* Iterate over the ports and see which ones are part of the
> +	 * vlan and for those ports add entry in the MAC table to
> +	 * copy the frames to the CPU
> +	 */
> +	for (p =3D 0; p < lan966x->num_phys_ports; p++) {
> +		struct lan966x_port *port =3D lan966x->ports[p];
> +
> +		if (!port ||
> +		    !lan966x_vlan_port_member_vlan_mask(port, vid))
> +			continue;
> +
> +		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
> +	}
> +
> +	/* Add an entry in the MAC table for the CPU
> +	 * Add the CPU part of the vlan only if there is another port in that
> +	 * vlan otherwise all the broadcast frames in that vlan will go to CPU
> +	 * even if none of the ports are in the vlan and then the CPU will just
> +	 * need to discard these frames. It is required to store this
> +	 * information so when a front port is added then it would add also the
> +	 * CPU port.
> +	 */
> +	if (lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
> +		lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> +		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
> +	}
> +
> +	lan966x_vlan_cpu_add_cpu_vlan_mask(lan966x, vid);
> +
> +	return 0;
> +}
> +
> +int lan966x_vlan_cpu_del_vlan(struct lan966x *lan966x,
> +			      struct net_device *dev,
> +			      u16 vid)
> +{
> +	int p;
> +
> +	/* Iterate over the ports and see which ones are part of the
> +	 * vlan and for those ports remove entry in the MAC table to
> +	 * copy the frames to the CPU
> +	 */
> +	for (p =3D 0; p < lan966x->num_phys_ports; p++) {
> +		struct lan966x_port *port =3D lan966x->ports[p];
> +
> +		if (!port ||
> +		    !lan966x_vlan_port_member_vlan_mask(port, vid))
> +			continue;
> +
> +		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, vid);
> +	}
> +
> +	/* Remove an entry in the MAC table for the CPU */
> +	lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
> +
> +	/* Remove the CPU part of the vlan */
> +	lan966x_vlan_cpu_del_cpu_vlan_mask(lan966x, vid);
> +	lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
> +
> +	return 0;
> +}
> +
> +int lan966x_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vi=
d)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +
> +	lan966x_vlan_port_set_vid(port, vid, false, false);
> +	lan966x_vlan_port_add_vlan_mask(port, vid);
> +	lan966x_vlan_port_apply(port);
> +
> +	return 0;
> +}
> +
> +int lan966x_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> +			     u16 vid)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +
> +	lan966x_vlan_port_remove_vid(port, vid);
> +	lan966x_vlan_port_del_vlan_mask(port, vid);
> +	lan966x_vlan_port_apply(port);
> +
> +	return 0;
> +}
> +
> +void lan966x_vlan_mode(struct lan966x_port *port,
> +		       netdev_features_t features)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u32 val;
> +
> +	/* Filtering */
> +	val =3D lan_rd(lan966x, ANA_VLANMASK);
> +	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
> +		val |=3D BIT(port->chip_port);
> +	else
> +		val &=3D ~BIT(port->chip_port);
> +	lan_wr(val, lan966x, ANA_VLANMASK);
> +}
> --=20
> 2.33.0
>=
