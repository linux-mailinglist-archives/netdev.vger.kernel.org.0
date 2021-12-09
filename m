Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0EF46E939
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhLINjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:39:55 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:57581
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231810AbhLINjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 08:39:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEd6+PH/wrAobmiqmBrfftfOXFNenbIbLFjA1hpqErgKzgeheL23lYLgZ2fpnVx6SqQDs7RiqIW3xyqGnSvt9oLTjXpzmVLnhk5t8wiZOMknZUC1UEX4nx5rtUvHXp1woGTAl0rFB7h3fRB5pMuQKg5Rf9wZOSfG0A8esNZ5KnX0kDgpfwUzixCwplXqbL5ftrRUaw+IOB89lcacCPgMs+bEm3QUzEy1aUx1/6KgSM/8sRrEFDRJAB+cVnvh2T4bdISXYbUwXqacjhp6UVG6xRok31w624dDAjKoTowXTxIwvp+ketmSFkJ82+ykpkagA2EMcwPrDZ3mbGaIkVsbDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+C0F0hwyPd1jIwlB3Xem/AJ7EVgBQ+ZT7bMQkq/imu0=;
 b=eENltXpdfRf/nnFStH6Ndq195vq5uTxxpJxKDVJuE3EK+h+axB7s7/ld8ASVtgT2Pt18VQ3K/C7tBDKTlE1cNBkQzjxS1Az7FH2VMbVUdtSGRD8M+eb92ovzP/8IUVE4mqF6psEUsry51frs9ni6F0sq2Lgb7oJpSJ4Hb3ZVtPmYcx0agT/0W8H0pN5lp0F2F0kQ9vaKZgf9JL0eJTKNYwvc5+fDHGwUVlzsEPUWYouPTz5tyrvbuI2TSWqodABKRErObLOrb11yMRqaW8WRet15zyA/0OgXOiul6V7i/gGS2ALi+wKtZJtzU+Z9u0ucDFKvZWMK1lM4LXcIM6UAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+C0F0hwyPd1jIwlB3Xem/AJ7EVgBQ+ZT7bMQkq/imu0=;
 b=Kwk9uTlYMSWETJ09eNN3gudZDJ6bfbU6mJT1qElxx9iVz0gjE3mdB+9E2CB3BvOHygUCtfIWwfLbW2bCwL4mJwv7m14Er+WS5X6jkJXFEr5sbYJE326TTiH+2Hp/d1S7Xth5R5PX2RLR2ti13GuS7CfruLyH9zl+n20gO6fD0eM=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8225.eurprd04.prod.outlook.com (2603:10a6:20b:3e7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 13:36:17 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 13:36:17 +0000
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
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Topic: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcA
Date:   Thu, 9 Dec 2021 13:36:17 +0000
Message-ID: <20211209133616.2kii2xfz5rioii4o@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
In-Reply-To: <20211209094615.329379-7-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 480a48f0-a119-40d3-8736-08d9bb18e0ec
x-ms-traffictypediagnostic: AM9PR04MB8225:EE_
x-microsoft-antispam-prvs: <AM9PR04MB8225464D8AA73AA4AEC66A55E0709@AM9PR04MB8225.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JuSpsIf9ZeJZxN4fp4FLw2nc9aCbLvt0JJo2EOvmpmTjwECNn2tOfG0SInAH5VQ/ho8aY8LSdOnylIaVGk/0spHXVVC7I7y6ID0R0Gh3rnEhbEin5MGXnJKWNeAVnGmUfzYd+UDl36U+I+Ds7oa6Hg5F2wLO9K3FozdQVO2Op9lKSjz2KVRcD/6n58Egofl2jUzPZAjBRL68PsuMHrZvYLlnKFkYAi4YyTBeFKZEwjFNrL2IwWJUd4fcjvuiw3hkMfVpIWTvyYL1q15UuZfGC5fEyuC37TlqHZyUz0u+dBCAD3zjLDWiOj1/R4hapqDV29d4NUit6mpkegP4+ame3oQWXKAyFN3rwQVhCwskhIghkyCyj0d2Q93qxkgSYrIb3qtMzgbQV74osoZ47zmtn2tVRTgKNsltPJ9PIbM8mBMx0MdoudCvZzp/PjDulV42iBFORrjB4c/4ZbNuqa7n0TeUUK629fXUJSih9i/3bTHt/T/efBUCz2PL7s5CvVMuyY9MdnqcMClv/LuKtbGYBPkY9NRExLMgQuqwuA+svYYntpaFRLx+iOoqeKQ3CmFsS1vmqXs2wVyuX8wmfDpvdGtdOwtSARxcVECeDX07kpcRRFaIHsJhzbSs0HlrSdfdrhPDvZs58qZ//u6rQd1ZKktYNi+vDhdFRlXqtG2WZ5zepGPiHDJSymkcUd+Xv172kWzhjyio6zr8DvRusN6CgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(86362001)(7416002)(5660300002)(71200400001)(508600001)(33716001)(2906002)(9686003)(8676002)(1076003)(26005)(122000001)(6506007)(30864003)(6512007)(6916009)(6486002)(8936002)(54906003)(4326008)(64756008)(66476007)(66946007)(66556008)(76116006)(91956017)(66446008)(316002)(44832011)(83380400001)(38070700005)(38100700002)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YiZdGL9o1WjqbtuCjl7Zgh9wCnkmvj3N9tmdVtvdK88PEzY6ow++MCRAilMu?=
 =?us-ascii?Q?A1a8Lz5PEpVl8sAP6tXYDTpys7WchecjU5CdB6pU2M/NNwTJOVXYA3RRIR3u?=
 =?us-ascii?Q?Elfw/UW5cBeXm3ELGRYilY/dnZtrCEXTw0Seg4OvCOjlkEKZW2KZvnp4Ts5C?=
 =?us-ascii?Q?XcMtSSEflhKazm4639U4taDyMbanHER7oxd+xAUcX8lL8YCUR3pJDDgRNafK?=
 =?us-ascii?Q?tQCHXUvsXKx7Ul6xSkqRH4LQiWqeu+aEPWSnLcNlr+YI0xq7U5sCPpbRpg5E?=
 =?us-ascii?Q?Ap7V0d86Z5CnBLrOse79P8IOhYXQDcKU9jKbC9uDmQbd19/3rV+gYcn8vizq?=
 =?us-ascii?Q?2c/1Ju18e99gSpLgYMLBykk20oYyuju8DPbo7KMmHob06Kesu1z6GWkXF9sZ?=
 =?us-ascii?Q?xPoaXxTsXXWjpME2t+VPp65Ak5EKKgjOwXEsTNI1g2DS28au1P94A/AukaFv?=
 =?us-ascii?Q?8yFcYDu8b1zUibfVY5ZiSdRAhk5+AP8o3Qv+uCaPC+4HnbGR5l6X23p0UY8K?=
 =?us-ascii?Q?n48f8hVqtj8nE+sLeBvs0BoKP2EwZakoK/XGdYyArkegmC+CXeIu/fU5IGsP?=
 =?us-ascii?Q?J8n8nkI1y3DO/m2bJd/omBrd2FllmcAbFKa+Sy1WxzhdPEG8C+f9hcptBv7I?=
 =?us-ascii?Q?6KeQIc7Ey6cmM8wqbNQ0RkVienvnjIbNVis7tCadf7V5ORqG88bio1HpZ4ys?=
 =?us-ascii?Q?GkNll7jkWQjpbb6UtU+JH6+guPB7C24TOMU66SZ/R8cErzeGlcDsmxMUBOHr?=
 =?us-ascii?Q?GQ14Va50CYxOEspHQrpn0/ypqSh0hvFacClLfOGl8iOlLHX6V/rx5vp16/Cf?=
 =?us-ascii?Q?EkpppCChq1/cGocL6W4X8V36IJyapdhPUxri8z+2uQOSXK6kmOr0VsBmHufO?=
 =?us-ascii?Q?1YEFUbVBbevy6SdPU/DYXrfoxp5dp2mfI/sCtLNwPIn9DdsNfKnDVGvMiT0k?=
 =?us-ascii?Q?VOrXjrDh7g+b/tat7sUf7SDQ2hkzotM5OkAYMYZ0YB89aT49s3o+zzYlXThd?=
 =?us-ascii?Q?N1omJRKIfGMls+sms+X7qSei6Z8ACpopl93vqTqHirOa0Lg3xMQu4Myw4bdH?=
 =?us-ascii?Q?hwdFjff00bFeLMu/EH8K5jVlQA/1qihMK5SJggnY3iGIf7sddfHGDF9oO6ZH?=
 =?us-ascii?Q?5xB4chHKk6A3vULf60hzC0/xnawDtk4jQ6ePytgBqBzwu4HI/DhBZnmnt8Hm?=
 =?us-ascii?Q?aRPP5tFgcJwsPty/CSj2fzdW6t1o+dpHsEf2pc/6NEWmxvhh9vuZsZvrY3dO?=
 =?us-ascii?Q?3pgASLwEzcXbnyM6Ukjq27B/QQm9VKQggVX6m0qxOPdA/gaBsELWS4qCoqAd?=
 =?us-ascii?Q?0iBbIWDMWE/EMPVH/WLkDdjMHY5VN7/UAfQ7re6s/EDcJGP4+wG4r323bXjS?=
 =?us-ascii?Q?iW7IpXvOZ3r6meeKIxQhhP7DtDTR2i4NnYlcpyhHFRL2Hsq73R72O1a4qUOZ?=
 =?us-ascii?Q?oWjUaddXKJK8XRp81/juymiE09DinIp0r31SgUXnXklm0ZSkb51q/fObZRTs?=
 =?us-ascii?Q?sfsoJuGLR80MKP6lZZb8Wce/82Pbw5lL4jXlqE8jAUiB1DpNyh0Z44D6jSSS?=
 =?us-ascii?Q?76rL5ZjKzQKbg434ml3rSndhRi6frFjAgXtxOeet+ewLm9jsLqafrxDVfmZm?=
 =?us-ascii?Q?yShYUWaOM4yNH/qbG3kCoi0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6F7576C19180F42BF1D46F4427764A9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480a48f0-a119-40d3-8736-08d9bb18e0ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 13:36:17.5373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f02UQxmz7nNpNe6UerqNwcZWlFubLufal1tLLwotbG/TArK42F9vpHmKYz/eo7y8sb0YU5x2v7yVZRwQ82qmsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 10:46:15AM +0100, Horatiu Vultur wrote:
> This adds support for switchdev in lan966x.
> It offloads to the HW basic forwarding and vlan filtering. To be able to
> offload this to the HW, it is required to disable promisc mode for ports
> that are part of the bridge.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c |  41 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  18 +
>  .../microchip/lan966x/lan966x_switchdev.c     | 548 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_vlan.c |  12 +-
>  5 files changed, 610 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switch=
dev.c
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/ne=
t/ethernet/microchip/lan966x/Makefile
> index f7e6068a91cb..d82e896c2e53 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -6,4 +6,5 @@
>  obj-$(CONFIG_LAN966X_SWITCH) +=3D lan966x-switch.o
> =20
>  lan966x-switch-objs  :=3D lan966x_main.o lan966x_phylink.o lan966x_port.=
o \
> -			lan966x_mac.o lan966x_ethtool.o lan966x_vlan.o
> +			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
> +			lan966x_vlan.o
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 1b4c7e6b4f85..aee36c1cfa17 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -306,7 +306,7 @@ static int lan966x_port_xmit(struct sk_buff *skb, str=
uct net_device *dev)
>  	return lan966x_port_ifh_xmit(skb, ifh, dev);
>  }
> =20
> -static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
> +void lan966x_set_promisc(struct lan966x_port *port, bool enable)
>  {
>  	struct lan966x *lan966x =3D port->lan966x;
> =20

My documentation of CPU_SRC_COPY_ENA says:

If set, all frames received on this port are
copied to the CPU extraction queue given by
CPUQ_CFG.CPUQ_SRC_COPY.

I think it was established a while ago that this isn't what promiscuous
mode is about? Instead it is about accepting packets on a port
regardless of whether the MAC DA is in their RX filter or not.

Hence the oddity of your change. I understand what it intends to do:
if this is a standalone port you support IFF_UNICAST_FLT, so you drop
frames with unknown MAC DA. But if IFF_PROMISC is set, then why do you
copy all frames to the CPU? Why don't you just put the CPU in the
unknown flooding mask? There's a difference between "force a packet to
get copied to the CPU" and "copy it to the CPU only if it may have
business there". Then this change would be compatible with bridge mode.
You want the bridge to receive unknown traffic too, it may need to
forward it in software.

> @@ -318,14 +318,18 @@ static void lan966x_set_promisc(struct lan966x_port=
 *port, bool enable)
>  static void lan966x_port_change_rx_flags(struct net_device *dev, int fla=
gs)
>  {
>  	struct lan966x_port *port =3D netdev_priv(dev);
> +	bool enable;
> =20
>  	if (!(flags & IFF_PROMISC))
>  		return;
> =20
> -	if (dev->flags & IFF_PROMISC)
> -		lan966x_set_promisc(port, true);
> -	else
> -		lan966x_set_promisc(port, false);
> +	enable =3D dev->flags & IFF_PROMISC ? true : false;
> +	port->promisc =3D enable;
> +
> +	if (port->bridge)
> +		return;
> +
> +	lan966x_set_promisc(port, enable);
>  }
> =20
>  static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
> @@ -340,7 +344,7 @@ static int lan966x_port_change_mtu(struct net_device =
*dev, int new_mtu)
>  	return 0;
>  }
> =20
> -static int lan966x_mc_unsync(struct net_device *dev, const unsigned char=
 *addr)
> +int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
>  {
>  	struct lan966x_port *port =3D netdev_priv(dev);
>  	struct lan966x *lan966x =3D port->lan966x;
> @@ -348,7 +352,7 @@ static int lan966x_mc_unsync(struct net_device *dev, =
const unsigned char *addr)
>  	return lan966x_mac_forget(lan966x, addr, port->pvid, ENTRYTYPE_LOCKED);
>  }
> =20
> -static int lan966x_mc_sync(struct net_device *dev, const unsigned char *=
addr)
> +int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
>  {
>  	struct lan966x_port *port =3D netdev_priv(dev);
>  	struct lan966x *lan966x =3D port->lan966x;
> @@ -401,6 +405,11 @@ static const struct net_device_ops lan966x_port_netd=
ev_ops =3D {
>  	.ndo_vlan_rx_kill_vid		=3D lan966x_vlan_rx_kill_vid,
>  };
> =20
> +bool lan966x_netdevice_check(const struct net_device *dev)
> +{
> +	return dev && (dev->netdev_ops =3D=3D &lan966x_port_netdev_ops);

Can "dev" ever be NULL?

> +}
> +
>  static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
>  {
>  	return lan_rd(lan966x, QS_XTR_RD(grp));
> @@ -537,6 +546,11 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, =
void *args)
> =20
>  		skb->protocol =3D eth_type_trans(skb, dev);
> =20
> +#ifdef CONFIG_NET_SWITCHDEV
> +		if (lan966x->ports[src_port]->bridge)
> +			skb->offload_fwd_mark =3D 1;
> +#endif
> +
>  		netif_rx_ni(skb);
>  		dev->stats.rx_bytes +=3D len;
>  		dev->stats.rx_packets++;
> @@ -619,13 +633,16 @@ static int lan966x_probe_port(struct lan966x *lan96=
6x, u32 p,
> =20
>  	dev->netdev_ops =3D &lan966x_port_netdev_ops;
>  	dev->ethtool_ops =3D &lan966x_ethtool_ops;
> +	dev->hw_features |=3D NETIF_F_HW_VLAN_CTAG_FILTER |
> +			    NETIF_F_RXFCS;
> +	dev->features |=3D NETIF_F_HW_VLAN_CTAG_FILTER |
> +			 NETIF_F_HW_VLAN_CTAG_TX |
> +			 NETIF_F_HW_VLAN_STAG_TX;
> +	dev->priv_flags |=3D IFF_UNICAST_FLT;

Too many changes in one patch. IFF_UNICAST_FLT and the handling of
promiscuous mode have nothing to do with switchdev. Neither VLAN
filtering via dev->features (should have been part of the previous
patch), or RXFCS. It seems that each one of these changes was previously
missed and is now snuck in without the explanation it deserves.

>  	dev->needed_headroom =3D IFH_LEN * sizeof(u32);
> =20
>  	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
> =20
> -	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
> -			  ENTRYTYPE_LOCKED);
> -

Why is this deleted? If the port uses IFF_UNICAST_FLT and isn't
promiscuous, how does it get the unicast traffic it needs?
I may be not realizing something because the changes aren't properly
split.

>  	port->phylink_config.dev =3D &port->dev->dev;
>  	port->phylink_config.type =3D PHYLINK_NETDEV;
>  	port->phylink_pcs.poll =3D true;
> @@ -949,6 +966,8 @@ static int lan966x_probe(struct platform_device *pdev=
)
>  		lan966x_port_init(lan966x->ports[p]);
>  	}
> =20
> +	lan966x_register_notifier_blocks(lan966x);
> +
>  	return 0;
> =20
>  cleanup_ports:
> @@ -967,6 +986,8 @@ static int lan966x_remove(struct platform_device *pde=
v)
>  {
>  	struct lan966x *lan966x =3D platform_get_drvdata(pdev);
> =20
> +	lan966x_unregister_notifier_blocks(lan966x);
> +
>  	lan966x_cleanup_ports(lan966x);
> =20
>  	cancel_delayed_work_sync(&lan966x->stats_work);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index ec3eccf634b3..4a0988087167 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -80,6 +80,11 @@ struct lan966x {
>  	struct list_head mac_entries;
>  	spinlock_t mac_lock; /* lock for mac_entries list */
> =20
> +	/* Notifiers */
> +	struct notifier_block netdevice_nb;
> +	struct notifier_block switchdev_nb;
> +	struct notifier_block switchdev_blocking_nb;
> +
>  	u16 vlan_mask[VLAN_N_VID];
>  	DECLARE_BITMAP(cpu_vlan_mask, VLAN_N_VID);
> =20
> @@ -112,6 +117,10 @@ struct lan966x_port {
>  	struct net_device *dev;
>  	struct lan966x *lan966x;
> =20
> +	struct net_device *bridge;
> +	u8 stp_state;
> +	u8 promisc;
> +
>  	u8 chip_port;
>  	u16 pvid;
>  	u16 vid;
> @@ -129,6 +138,14 @@ extern const struct phylink_mac_ops lan966x_phylink_=
mac_ops;
>  extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
>  extern const struct ethtool_ops lan966x_ethtool_ops;
> =20
> +int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)=
;
> +int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr);
> +
> +bool lan966x_netdevice_check(const struct net_device *dev);
> +
> +int lan966x_register_notifier_blocks(struct lan966x *lan966x);
> +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x);
> +
>  void lan966x_stats_get(struct net_device *dev,
>  		       struct rtnl_link_stats64 *stats);
>  int lan966x_stats_init(struct lan966x *lan966x);
> @@ -139,6 +156,7 @@ void lan966x_port_status_get(struct lan966x_port *por=
t,
>  			     struct phylink_link_state *state);
>  int lan966x_port_pcs_set(struct lan966x_port *port,
>  			 struct lan966x_port_config *config);
> +void lan966x_set_promisc(struct lan966x_port *port, bool enable);
>  void lan966x_port_init(struct lan966x_port *port);
> =20
>  int lan966x_mac_learn(struct lan966x *lan966x, int port,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> new file mode 100644
> index 000000000000..ed6ec78d2d9a
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -0,0 +1,548 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <linux/if_bridge.h>
> +#include <net/switchdev.h>
> +
> +#include "lan966x_main.h"
> +
> +static struct workqueue_struct *lan966x_owq;
> +
> +struct lan966x_fdb_event_work {
> +	struct work_struct work;
> +	struct switchdev_notifier_fdb_info fdb_info;
> +	struct net_device *dev;
> +	struct lan966x *lan966x;
> +	unsigned long event;
> +};
> +
> +static void lan966x_port_attr_bridge_flags(struct lan966x_port *port,
> +					   struct switchdev_brport_flags flags)
> +{
> +	u32 val =3D lan_rd(port->lan966x, ANA_PGID(PGID_MC));
> +
> +	val =3D ANA_PGID_PGID_GET(val);
> +
> +	if (flags.mask & BR_MCAST_FLOOD) {
> +		if (flags.val & BR_MCAST_FLOOD)
> +			val |=3D BIT(port->chip_port);
> +		else
> +			val &=3D ~BIT(port->chip_port);
> +	}
> +
> +	lan_rmw(ANA_PGID_PGID_SET(val),
> +		ANA_PGID_PGID,
> +		port->lan966x, ANA_PGID(PGID_MC));
> +}
> +
> +static u32 lan966x_get_fwd_mask(struct lan966x_port *port)
> +{
> +	struct net_device *bridge =3D port->bridge;
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u8 ingress_src =3D port->chip_port;
> +	u32 mask =3D 0;
> +	int p;
> +
> +	if (port->stp_state !=3D BR_STATE_FORWARDING)
> +		goto skip_forwarding;
> +
> +	for (p =3D 0; p < lan966x->num_phys_ports; p++) {
> +		port =3D lan966x->ports[p];
> +
> +		if (!port)
> +			continue;
> +
> +		if (port->stp_state =3D=3D BR_STATE_FORWARDING &&
> +		    port->bridge =3D=3D bridge)
> +			mask |=3D BIT(p);
> +	}
> +
> +skip_forwarding:
> +	mask &=3D ~BIT(ingress_src);
> +
> +	return mask;
> +}
> +
> +static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> +{
> +	int p;
> +
> +	for (p =3D 0; p < lan966x->num_phys_ports; p++) {
> +		struct lan966x_port *port =3D lan966x->ports[p];
> +		unsigned long mask =3D 0;
> +
> +		if (port->bridge)
> +			mask =3D lan966x_get_fwd_mask(port);
> +
> +		mask |=3D BIT(CPU_PORT);
> +
> +		lan_wr(ANA_PGID_PGID_SET(mask),
> +		       lan966x, ANA_PGID(PGID_SRC + p));
> +	}
> +}
> +
> +static void lan966x_attr_stp_state_set(struct lan966x_port *port,
> +				       u8 state)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	bool learn_ena =3D 0;
> +
> +	port->stp_state =3D state;
> +
> +	if (state =3D=3D BR_STATE_FORWARDING || state =3D=3D BR_STATE_LEARNING)
> +		learn_ena =3D 1;

Please use true/false for bool types.

> +
> +	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
> +		ANA_PORT_CFG_LEARN_ENA,
> +		lan966x, ANA_PORT_CFG(port->chip_port));
> +
> +	lan966x_update_fwd_mask(lan966x);
> +}
> +
> +static void lan966x_port_attr_ageing_set(struct lan966x_port *port,
> +					 unsigned long ageing_clock_t)
> +{
> +	unsigned long ageing_jiffies =3D clock_t_to_jiffies(ageing_clock_t);
> +	u32 ageing_time =3D jiffies_to_msecs(ageing_jiffies) / 1000;
> +
> +	lan966x_mac_set_ageing(port->lan966x, ageing_time);
> +}
> +
> +static int lan966x_port_attr_set(struct net_device *dev, const void *ctx=
,
> +				 const struct switchdev_attr *attr,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
> +		lan966x_port_attr_bridge_flags(port, attr->u.brport_flags);
> +		break;

no SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS? I think it doesn't even work
if you don't handle that?

br_switchdev_set_port_flag():

	attr.id =3D SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS;
	attr.u.brport_flags.val =3D flags;
	attr.u.brport_flags.mask =3D mask;

	/* We run from atomic context here */
	err =3D call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
				       &info.info, extack);
	err =3D notifier_to_errno(err);
	if (err =3D=3D -EOPNOTSUPP)
		return 0;

Anyway, a big blob of "switchdev support" is hard to follow and review.
If you add bridge port flags you could as well add more comprehensive
support for them, but in a separate change please. Forwarding domain is
one thing, FDB/MDB is another, VLAN is another.

> +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> +		lan966x_attr_stp_state_set(port, attr->u.stp_state);
> +		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> +		lan966x_port_attr_ageing_set(port, attr->u.ageing_time);
> +		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
> +		lan966x_vlan_port_set_vlan_aware(port, attr->u.vlan_filtering);
> +		lan966x_vlan_port_apply(port);
> +		lan966x_vlan_cpu_set_vlan_aware(port);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int lan966x_port_bridge_join(struct lan966x_port *port,
> +				    struct net_device *bridge,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct net_device *dev =3D port->dev;
> +	int err;
> +
> +	err =3D switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
> +					    false, extack);
> +	if (err)
> +		return err;
> +
> +	port->bridge =3D bridge;
> +
> +	/* Port enters in bridge mode therefor don't need to copy to CPU
> +	 * frames for multicast in case the bridge is not requesting them
> +	 */
> +	__dev_mc_unsync(dev, lan966x_mc_unsync);

Why is there a need to unsync the addresses, though? A driver that
supports proper MAC table isolation between standalone ports and
VLAN-unaware bridge ports should use separate pvids for the two modes of
operation (if it doesn't support other isolation mechanisms apart from VLAN=
,
which it looks like lan966x does not). I see that your driver even does
this in lan966x_vlan_port_get_pvid(). So the non-bridge multicast
addresses could sit there even when the port is in a bridge.

> +
> +	/* make sure that the promisc is disabled when entering under the bridg=
e
> +	 * because we don't want all the frames to come to CPU
> +	 */
> +	lan966x_set_promisc(port, false);

What's the story here? Why don't other switchdev drivers handle promisc
in this way (copy all frames to the CPU)?

> +
> +	return 0;
> +}
> +
> +static void lan966x_port_bridge_leave(struct lan966x_port *port,
> +				      struct net_device *bridge)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	switchdev_bridge_port_unoffload(port->dev, NULL, NULL, NULL);

The bridge offers a facility to sync and unsync the host addresses on
joins and leaves. For this to work, the switchdev_bridge_port_unoffload
call should be during the NETDEV_PRECHANGEUPPER notifier event.

> +	port->bridge =3D NULL;
> +
> +	/* Set the port back to host mode */
> +	lan966x_vlan_port_set_vlan_aware(port, 0);

s/0/false/

> +	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> +	lan966x_vlan_port_apply(port);
> +
> +	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);
> +
> +	/* Port enters in host more therefore restore mc list */
> +	__dev_mc_sync(port->dev, lan966x_mc_sync, lan966x_mc_unsync);
> +
> +	/* Restore back the promisc as it was before the interfaces was added t=
o
> +	 * the bridge
> +	 */
> +	lan966x_set_promisc(port, port->promisc);
> +}
> +
> +static int lan966x_port_changeupper(struct net_device *dev,
> +				    struct netdev_notifier_changeupper_info *info)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	struct netlink_ext_ack *extack;
> +	int err =3D 0;
> +
> +	extack =3D netdev_notifier_info_to_extack(&info->info);
> +
> +	if (netif_is_bridge_master(info->upper_dev)) {
> +		if (info->linking)
> +			err =3D lan966x_port_bridge_join(port, info->upper_dev,
> +						       extack);
> +		else
> +			lan966x_port_bridge_leave(port, info->upper_dev);
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_port_add_addr(struct net_device *dev, bool up)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u16 vid;
> +
> +	vid =3D lan966x_vlan_port_get_pvid(port);
> +
> +	if (up)
> +		lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> +	else
> +		lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);

For which uppers is this intended? The bridge? Because the bridge
notifies you of all the entries it needs, if you also consider the
replayed events and provide non-NULL pointers to
switchdev_bridge_port_offload.

> +
> +	return 0;
> +}
> +
> +static int lan966x_netdevice_port_event(struct net_device *dev,
> +					struct notifier_block *nb,
> +					unsigned long event, void *ptr)
> +{
> +	int err =3D 0;
> +
> +	if (!lan966x_netdevice_check(dev))
> +		return 0;
> +
> +	switch (event) {
> +	case NETDEV_CHANGEUPPER:
> +		err =3D lan966x_port_changeupper(dev, ptr);
> +		break;
> +	case NETDEV_PRE_UP:
> +		err =3D lan966x_port_add_addr(dev, true);
> +		break;
> +	case NETDEV_DOWN:
> +		err =3D lan966x_port_add_addr(dev, false);
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_netdevice_event(struct notifier_block *nb,
> +				   unsigned long event, void *ptr)
> +{
> +	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
> +	int ret;
> +
> +	ret =3D lan966x_netdevice_port_event(dev, nb, event, ptr);
> +
> +	return notifier_from_errno(ret);
> +}
> +
> +static void lan966x_fdb_event_work(struct work_struct *work)
> +{
> +	struct lan966x_fdb_event_work *fdb_work =3D
> +		container_of(work, struct lan966x_fdb_event_work, work);
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +	struct net_device *dev =3D fdb_work->dev;
> +	struct lan966x_port *port;
> +	struct lan966x *lan966x;
> +
> +	rtnl_lock();

rtnl_lock() shouldn't be needed.

> +
> +	fdb_info =3D &fdb_work->fdb_info;
> +	lan966x =3D fdb_work->lan966x;
> +
> +	if (lan966x_netdevice_check(dev)) {
> +		port =3D netdev_priv(dev);
> +
> +		switch (fdb_work->event) {
> +		case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +			if (!fdb_info->added_by_user)
> +				break;

If you get notified of a MAC address dynamically learned by the software
bridge on a lan966x port, you will have allocated memory for the work
item, and scheduled it, for nothing. Please try to exit unnecessary work
early.

> +			lan966x_mac_add_entry(lan966x, port, fdb_info->addr,
> +					      fdb_info->vid);
> +			break;
> +		case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +			if (!fdb_info->added_by_user)
> +				break;
> +			lan966x_mac_del_entry(lan966x, fdb_info->addr, fdb_info->vid);
> +			break;
> +		}
> +	} else {
> +		if (!netif_is_bridge_master(dev))
> +			goto out;
> +
> +		/* If the CPU is not part of the vlan then there is no point
> +		 * to copy the frames to the CPU because they will be dropped
> +		 */
> +		if (!lan966x_vlan_cpu_member_vlan_mask(lan966x, fdb_info->vid))
> +			goto out;

It isn't part of the VLAN now, but what about later? I don't see that
you keep these FDB entries anywhere and restore them when a port joins
that VLAN.

> +
> +		/* In case the bridge is called */
> +		switch (fdb_work->event) {
> +		case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +			/* If there is no front port in this vlan, there is no
> +			 * point to copy the frame to CPU because it would be
> +			 * just dropped at later point. So add it only if
> +			 * there is a port
> +			 */
> +			if (!lan966x_vlan_port_any_vlan_mask(lan966x, fdb_info->vid))
> +				break;
> +
> +			lan966x_mac_cpu_learn(lan966x, fdb_info->addr, fdb_info->vid);

Does the lan966x_mac_cpu_learn() operation trigger interrupts, or only
the dynamic learning process? How do you handle migration of an FDB
entry pointing towards the CPU, towards one pointing towards a port?

> +			break;
> +		case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +			/* It is OK to always forget the entry it */

Forget the entry it?

> +			lan966x_mac_cpu_forget(lan966x, fdb_info->addr, fdb_info->vid);
> +			break;
> +		}
> +	}
> +
> +out:
> +	rtnl_unlock();
> +	kfree(fdb_work->fdb_info.addr);
> +	kfree(fdb_work);
> +	dev_put(dev);
> +}
> +
> +static int lan966x_switchdev_event(struct notifier_block *nb,
> +				   unsigned long event, void *ptr)
> +{
> +	struct lan966x *lan966x =3D container_of(nb, struct lan966x, switchdev_=
nb);
> +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +	struct switchdev_notifier_info *info =3D ptr;
> +	struct lan966x_fdb_event_work *fdb_work;
> +	int err;
> +
> +	switch (event) {
> +	case SWITCHDEV_PORT_ATTR_SET:
> +		err =3D switchdev_handle_port_attr_set(dev, ptr,
> +						     lan966x_netdevice_check,
> +						     lan966x_port_attr_set);
> +		return notifier_from_errno(err);
> +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +		fallthrough;

"fallthrough;" not needed here.

> +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +		fdb_work =3D kzalloc(sizeof(*fdb_work), GFP_ATOMIC);
> +		if (!fdb_work)
> +			return NOTIFY_BAD;
> +
> +		fdb_info =3D container_of(info,
> +					struct switchdev_notifier_fdb_info,
> +					info);
> +
> +		fdb_work->dev =3D dev;
> +		fdb_work->lan966x =3D lan966x;
> +		fdb_work->event =3D event;
> +		INIT_WORK(&fdb_work->work, lan966x_fdb_event_work);
> +		memcpy(&fdb_work->fdb_info, ptr, sizeof(fdb_work->fdb_info));
> +		fdb_work->fdb_info.addr =3D kzalloc(ETH_ALEN, GFP_ATOMIC);
> +		if (!fdb_work->fdb_info.addr)
> +			goto err_addr_alloc;
> +
> +		ether_addr_copy((u8 *)fdb_work->fdb_info.addr, fdb_info->addr);
> +		dev_hold(dev);
> +
> +		queue_work(lan966x_owq, &fdb_work->work);
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +err_addr_alloc:
> +	kfree(fdb_work);
> +	return NOTIFY_BAD;
> +}
> +
> +static int lan966x_handle_port_vlan_add(struct net_device *dev,
> +					struct notifier_block *nb,
> +					const struct switchdev_obj_port_vlan *v)
> +{
> +	struct lan966x_port *port;
> +	struct lan966x *lan966x;
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
> +	if (netif_is_bridge_master(dev) &&
> +	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
> +		return 0;
> +
> +	lan966x =3D container_of(nb, struct lan966x, switchdev_blocking_nb);
> +
> +	/* In case the port gets called */
> +	if (!(netif_is_bridge_master(dev))) {
> +		if (!lan966x_netdevice_check(dev))
> +			return -EOPNOTSUPP;
> +
> +		port =3D netdev_priv(dev);
> +		return lan966x_vlan_port_add_vlan(port, v->vid,
> +						  v->flags & BRIDGE_VLAN_INFO_PVID,
> +						  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
> +	}
> +
> +	/* In case the bridge gets called */
> +	if (netif_is_bridge_master(dev))
> +		return lan966x_vlan_cpu_add_vlan(lan966x, dev, v->vid);
> +
> +	return 0;
> +}
> +
> +static int lan966x_handle_port_obj_add(struct net_device *dev,
> +				       struct notifier_block *nb,
> +				       struct switchdev_notifier_port_obj_info *info)
> +{
> +	const struct switchdev_obj *obj =3D info->obj;
> +	int err;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		err =3D lan966x_handle_port_vlan_add(dev, nb,
> +						   SWITCHDEV_OBJ_PORT_VLAN(obj));
> +		break;
> +	default:
> +		err =3D -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	info->handled =3D true;
> +	return err;
> +}
> +
> +static int lan966x_handle_port_vlan_del(struct net_device *dev,
> +					struct notifier_block *nb,
> +					const struct switchdev_obj_port_vlan *v)
> +{
> +	struct lan966x_port *port;
> +	struct lan966x *lan966x;
> +
> +	lan966x =3D container_of(nb, struct lan966x, switchdev_blocking_nb);
> +
> +	/* In case the physical port gets called */
> +	if (!netif_is_bridge_master(dev)) {
> +		if (!lan966x_netdevice_check(dev))
> +			return -EOPNOTSUPP;
> +
> +		port =3D netdev_priv(dev);
> +		return lan966x_vlan_port_del_vlan(port, v->vid);
> +	}
> +
> +	/* In case the bridge gets called */
> +	if (netif_is_bridge_master(dev))
> +		return lan966x_vlan_cpu_del_vlan(lan966x, dev, v->vid);
> +
> +	return 0;
> +}
> +
> +static int lan966x_handle_port_obj_del(struct net_device *dev,
> +				       struct notifier_block *nb,
> +				       struct switchdev_notifier_port_obj_info *info)
> +{
> +	const struct switchdev_obj *obj =3D info->obj;
> +	int err;
> +
> +	switch (obj->id) {
> +	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> +		err =3D lan966x_handle_port_vlan_del(dev, nb,
> +						   SWITCHDEV_OBJ_PORT_VLAN(obj));
> +		break;
> +	default:
> +		err =3D -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	info->handled =3D true;
> +	return err;
> +}
> +
> +static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> +					    unsigned long event,
> +					    void *ptr)
> +{
> +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> +	int err;
> +
> +	switch (event) {
> +	case SWITCHDEV_PORT_OBJ_ADD:
> +		err =3D lan966x_handle_port_obj_add(dev, nb, ptr);
> +		return notifier_from_errno(err);
> +	case SWITCHDEV_PORT_OBJ_DEL:
> +		err =3D lan966x_handle_port_obj_del(dev, nb, ptr);
> +		return notifier_from_errno(err);
> +	case SWITCHDEV_PORT_ATTR_SET:
> +		err =3D switchdev_handle_port_attr_set(dev, ptr,
> +						     lan966x_netdevice_check,
> +						     lan966x_port_attr_set);
> +		return notifier_from_errno(err);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +int lan966x_register_notifier_blocks(struct lan966x *lan966x)
> +{
> +	int err;
> +
> +	lan966x->netdevice_nb.notifier_call =3D lan966x_netdevice_event;
> +	err =3D register_netdevice_notifier(&lan966x->netdevice_nb);
> +	if (err)
> +		return err;
> +
> +	lan966x->switchdev_nb.notifier_call =3D lan966x_switchdev_event;
> +	err =3D register_switchdev_notifier(&lan966x->switchdev_nb);
> +	if (err)
> +		goto err_switchdev_nb;
> +
> +	lan966x->switchdev_blocking_nb.notifier_call =3D lan966x_switchdev_bloc=
king_event;
> +	err =3D register_switchdev_blocking_notifier(&lan966x->switchdev_blocki=
ng_nb);
> +	if (err)
> +		goto err_switchdev_blocking_nb;
> +
> +	lan966x_owq =3D alloc_ordered_workqueue("lan966x_order", 0);
> +	if (!lan966x_owq) {
> +		err =3D -ENOMEM;
> +		goto err_switchdev_blocking_nb;
> +	}

These should be singleton objects, otherwise things get problematic if
you have more than one switch device instantiated in the system.

> +
> +	return 0;
> +
> +err_switchdev_blocking_nb:
> +	unregister_switchdev_notifier(&lan966x->switchdev_nb);
> +err_switchdev_nb:
> +	unregister_netdevice_notifier(&lan966x->netdevice_nb);
> +
> +	return err;
> +}
> +
> +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x)
> +{
> +	destroy_workqueue(lan966x_owq);
> +
> +	unregister_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb)=
;
> +	unregister_switchdev_notifier(&lan966x->switchdev_nb);
> +	unregister_netdevice_notifier(&lan966x->netdevice_nb);
> +}
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> index e47552775d06..26644503b4e6 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
> @@ -155,6 +155,9 @@ static bool lan966x_vlan_cpu_member_cpu_vlan_mask(str=
uct lan966x *lan966x, u16 v
> =20
>  u16 lan966x_vlan_port_get_pvid(struct lan966x_port *port)
>  {
> +	if (!port->bridge)
> +		return HOST_PVID;
> +
>  	return port->vlan_aware ? port->pvid : UNAWARE_PVID;
>  }
> =20
> @@ -210,6 +213,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_p=
ort *port)
>  		 * table for the front port and the CPU
>  		 */
>  		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> +		lan966x_mac_cpu_learn(lan966x, port->bridge->dev_addr,
> +				      UNAWARE_PVID);
> =20
>  		lan966x_vlan_port_add_vlan_mask(port, UNAWARE_PVID);
>  		lan966x_vlan_port_apply(port);
> @@ -218,6 +223,8 @@ void lan966x_vlan_cpu_set_vlan_aware(struct lan966x_p=
ort *port)
>  		 * to vlan unaware
>  		 */
>  		lan966x_mac_cpu_forget(lan966x, port->dev->dev_addr, UNAWARE_PVID);
> +		lan966x_mac_cpu_forget(lan966x, port->bridge->dev_addr,
> +				       UNAWARE_PVID);
> =20
>  		lan966x_vlan_port_del_vlan_mask(port, UNAWARE_PVID);
>  		lan966x_vlan_port_apply(port);
> @@ -293,6 +300,7 @@ int lan966x_vlan_port_add_vlan(struct lan966x_port *p=
ort,
>  	 */
>  	if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x, vid)) {
>  		lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, vid);
> +		lan966x_mac_cpu_learn(lan966x, port->bridge->dev_addr, vid);
>  		lan966x_vlan_cpu_add_vlan_mask(lan966x, vid);
>  	}
> =20
> @@ -322,8 +330,10 @@ int lan966x_vlan_port_del_vlan(struct lan966x_port *=
port,
>  	 * that vlan but still keep it in the mask because it may be needed
>  	 * again then another port gets added in tha vlan
>  	 */
> -	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid))
> +	if (!lan966x_vlan_port_any_vlan_mask(lan966x, vid)) {
> +		lan966x_mac_cpu_forget(lan966x, port->bridge->dev_addr, vid);
>  		lan966x_vlan_cpu_del_vlan_mask(lan966x, vid);
> +	}
> =20
>  	return 0;
>  }
> --=20
> 2.33.0
>=
