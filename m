Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC0E4766C1
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhLOXuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:50:46 -0500
Received: from mail-eopbgr10052.outbound.protection.outlook.com ([40.107.1.52]:8070
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229941AbhLOXuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 18:50:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbj/biBBuqs1nnIb2+CjH3xTttES8/Tm+VqknqYN3M0WiusDpP6wE7u+8kSjRu7C0p/pFzODV+QAPfpQeHZTc0fqzSjBfzw0DnyJB2hzVHRNoTG6tFQYU6dz1yyoxOvXl7dVbRHIJpj2AGuNnVP4S9q3hXJq9da5H8GI3nkZdivThNgq9ELyNKIiy7CT/QFYvMjdjGWQN7DWv/q4rPNHFskfD2rVENdTyzssz4/xptsoX3P5DI+85B1fvVDuGV+OmL3wxzx54Ugi2bRDCJSgBLBYh8KpRJnODwwDQXIk/h19SIUP8mbxHgAeYzROqJ2feg+mWB97AXliVehiW2yyOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhzlfwC9bm6Pn6m2OJQky+JPzbQxCSqtxlvOOy4u4mg=;
 b=iQHadOD1I2zdbsgGP2U9z2YI/+ToozeL/S5kT/iEgHM3iHNdjYOcdk/f3qciEOUUOSQt5W+ay9jYXjSeFVxYIol0Cm1cWr+NL/Leon9yOG0LPRWKMc88SAIMdx6WGK1ZIDMcK2f814eREBcTuTQ9cYSDq0wNujOXIXzuXxQ7eCtlfX7FbtvA7Gux0FHa5EojGsRk2mZQ4wBJs5OyMeAAAaRlNCNV8Gv4cUhgEnHDbh8UzDcEBvF8KyoKvElIC+pU5fvK9/eBaWw2Y3vYFnqNwnfEpZ1EibOR69KUSyQr14Q7dh+wzx5Lk3kuxfgqxUoACqlwfPJonxzBrvZnaE1tjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhzlfwC9bm6Pn6m2OJQky+JPzbQxCSqtxlvOOy4u4mg=;
 b=jvFhMA6ivagwEJVujagJRxMKcuXGo5Kew/y+eNFLCk1uePrXmM2TWdz0Z3s0BSa4zRvl13TKrdG/TvKm5Ru43fWe8gOH1U9V1PgQKELLSdhJO/4RburXSgK/0G8yLeQNR67iCCacURhqiQa1k9WAuxNTgQRNNtqdbofqMEtjXtA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 15 Dec
 2021 23:50:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Wed, 15 Dec 2021
 23:50:41 +0000
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
Subject: Re: [PATCH net-next v5 6/9] net: lan966x: Add support to offload the
 forwarding.
Thread-Topic: [PATCH net-next v5 6/9] net: lan966x: Add support to offload the
 forwarding.
Thread-Index: AQHX8a0Pa/IrM6hLREGrdlv7j4LDJqw0OccA
Date:   Wed, 15 Dec 2021 23:50:40 +0000
Message-ID: <20211215235040.2hfkk5nireum6cr5@skbuf>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
 <20211215121309.3669119-7-horatiu.vultur@microchip.com>
In-Reply-To: <20211215121309.3669119-7-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a785cfa2-9ba4-4652-2332-08d9c025b3be
x-ms-traffictypediagnostic: VI1PR04MB3070:EE_
x-microsoft-antispam-prvs: <VI1PR04MB30704EE6108ED920F8A2DD97E0769@VI1PR04MB3070.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B6CwK3NmdQEO1YW9S+GbkcOqTOnjEe9LR4MsmwGJE29/hCj5pvhliTPamasP62JkmC9jDC4Ney9JUCgItDps0xGTQPnltvcTfAq3Sa3r44IjDO2tRWVx70/Tuvk99eOLxgZTcmOB8dae5uD78GL2YaDJXY8w1crkS82SIo41rs2nIE8L+JKowBvsEfk3SEt0pObJ1NQ9raguHXTjONE4FOhXE+WOO9be+lwO1BVjIoysnW2dfJPIP3zE4cxtQvYBsHWmdBZDSSZbw9JV8skp59X6DtMeM8/25Wz4y/ncXqV2kffhzahkjfQ7/lWjErLrLzuIodcSJ4/GDgT5nePJMI1l4wo6lB6wTMkfgtqgrcnJ7y3lu4U2QCWdfz+NcZpLrpauatnQ78D1g1uJB+1YYnVZRLMaBqJwOyMvpNhY/g8Po2syvN+9JR49oLCQh8l5wXgRl/3JFpD26zXOkmWF8N5aUngqtehHYhNRxtR3Dl2gLxHQCNNZLsnG3YCovYmhn8Tn77DTDUueuh3FY+yU9cJ8osJ1nEa5cZvdSRH87jfJ0Y62OsmoxsqX58hfdSTv+LeBuNc9oOO9JohDCvFK4KTSCe/bbrF9KEDCITTcdU4qKX/UQ1La4Fd6BdWCxne6RgCTkbeY4dJRgaLVHK9LAg598jSZ731y3UyB4ZR1UWssoDe0le/En8u4j+xHWhbBP+mJfsxSDg2zVqYuJOP7lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(316002)(66446008)(66476007)(64756008)(122000001)(8936002)(4326008)(76116006)(66556008)(8676002)(7416002)(38100700002)(54906003)(2906002)(44832011)(91956017)(6916009)(71200400001)(86362001)(30864003)(6512007)(66946007)(9686003)(1076003)(26005)(33716001)(186003)(508600001)(83380400001)(38070700005)(6506007)(5660300002)(6486002)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?js6Ory3M8d2WZS5xrhwkQ1/Yn2oAPpAFKOpXkOXurS8RN2pt7RYmvBpO+Ylz?=
 =?us-ascii?Q?OOWzQiUN/Kh3aVt8MeL74rf4Lh4p2gJOpn1D+/NUzo4dJ4SXJ7mmW0pMEL6G?=
 =?us-ascii?Q?O+dbnrYT66lkVJ5wdmU15xPEKOHtLKDR66LTdeRQDmFBHIVH8+Lpwem6TZyK?=
 =?us-ascii?Q?2GcYHFwdNtjSgMCONhQy4uP3fnoRr+mOT/vOy4UHvxuMU0id7/sy09x7eo8J?=
 =?us-ascii?Q?jy+vTTJ9npcSeRY9aELgQV7y/HySgRrKaEL+6TOwk1OXZF/Y0aQg7l0Tyg9D?=
 =?us-ascii?Q?GoKmVhqax2YSI28DvugfrjKgmYCdOoWA7Fwoc6xiMbirt3+yfpO86lleE98N?=
 =?us-ascii?Q?wcERx9cO0JZq88vbCXIvS1raeW34q1r7Psx0X9zJvUIkFb2zMRhe8wGomK9U?=
 =?us-ascii?Q?p5oTP6qvDIkqbVKiEIPks3rFRnr2hIKALmq4h/FJk8iL0eBkUMpv4ncy+JtG?=
 =?us-ascii?Q?+G+XPzkMTfg11nq/Zb96YLulvCk0g2CSwEKUIvgIys93QqPj3IjUTXPPqByc?=
 =?us-ascii?Q?f6McjjRkWnacDr/uciXmLnCqQJ8921LAyXPL00nOHEWIb9TGkloUcX9mCU/i?=
 =?us-ascii?Q?HO3/IaPjqyu13l7KlLdBLBIJpV3uo3kW6ObmPBaratgwkS71AXCqiZp5qVFH?=
 =?us-ascii?Q?FLoT1MNIHVnLIqfJf+Juvts9iJ+s75B2vGVgLb0XFvVPjw2VI97P+27P2hzg?=
 =?us-ascii?Q?hyu0tCfKkhpfCg9XZ+1QFkwku9sAMRIBBRrKqrjp8iv1RUziblHDdMCnhMS1?=
 =?us-ascii?Q?FrSd6gMKX4ehOx9Jx6YhF69azKcAqy3yQcm6yBaclaqprIXIVNmp8uilFa/p?=
 =?us-ascii?Q?rO3xMrRKwAS1qR7ogjA8qiVnA0yG0FaJLu7j4ClCqhpnpFwcRqPwBdL2m+c+?=
 =?us-ascii?Q?jTSZ7xaIDvGBRCRZY9V2pR40oq4/zrSqqnoex+ayqCow8PZS/+GoG+wsejkC?=
 =?us-ascii?Q?pSXgOGtl/0P1I5wkJdRoPRzM4HBqOKjfy4NyKK58o2rfvIZdx5jFYLZEiArq?=
 =?us-ascii?Q?XGVIFklR6TtrUrZSkr0tLonlTjS2r0sLYABxclhVzhG+37Omhjwo4oAXHWgN?=
 =?us-ascii?Q?I8i3iDGI31epb5+z6i7bpr1899E6DuBuAdJpH2KAyUgGjVO6v+6e+lX5uz98?=
 =?us-ascii?Q?PaSfAB7E5g0sa8WUy6mvNEawpDVNZmWVgHqtjbClZySf1xLC8z8YEYZ5xi/T?=
 =?us-ascii?Q?l9E+AjVnCKv6WhjfxF3JDPaM6K6FUwQ21C0NZyDC70pulnti2vbOTHN8FL9r?=
 =?us-ascii?Q?yrpXNx9Rcq/miy8bxH17pWUqokAE+qame8qrOINGJlCKqEQQ5ikHnktqfkSp?=
 =?us-ascii?Q?9mHmrVIi2IjLYItht5ZMydARMzGInGhi2RaYUfgCAC8nGdobQTT/JCX6RNtE?=
 =?us-ascii?Q?AUh9gaKDPbXaEEhFgLmqWJ/Pk6g1H0srnpmyXiKhE+xibJVl1Dn6aw/qUAiu?=
 =?us-ascii?Q?vDtlDqrfM88ZWmiLbZBsguEMkM1dZoFTZSbGWaiqqYDjIMx4ATr5eRwt2ENS?=
 =?us-ascii?Q?//DEsZAxvjWAA+lEqUVASUODIE7389xtAoG9w0w9FVbiBfg6ucaihWT8AuO4?=
 =?us-ascii?Q?FWZfdLrKuaVYRhFK1lVBjjaqKZ04WM3c0EqamamToC9ESc4A0+77iVlXd+4v?=
 =?us-ascii?Q?S5uPB928S0bi1q16tnw42EU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD17AA72F361444182D1FF6807E22B5D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a785cfa2-9ba4-4652-2332-08d9c025b3be
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 23:50:41.0291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Ug9WHJAuu21ybxvMYdv2SMtlnkuCdXkimu+D2XTnQ+F2xwFfKtXJt9lYjzoie/ey4DTZNCsUlpFOxEL0Qaqww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 01:13:06PM +0100, Horatiu Vultur wrote:
> This patch adds basic support to offload in the HW the forwarding of the
> frames. The driver registers to the switchdev callbacks and implements
> the callbacks for attributes SWITCHDEV_ATTR_ID_PORT_STP_STATE and
> SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME.
> It is not allowed to add a lan966x port to a bridge that contains a
> different interface than lan966x.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c |  16 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  11 +
>  .../microchip/lan966x/lan966x_switchdev.c     | 393 ++++++++++++++++++
>  5 files changed, 419 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switch=
dev.c
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net=
/ethernet/microchip/lan966x/Kconfig
> index 2860a8c9923d..ac273f84b69e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Kconfig
> +++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
> @@ -2,6 +2,7 @@ config LAN966X_SWITCH
>  	tristate "Lan966x switch driver"
>  	depends on HAS_IOMEM
>  	depends on OF
> +	depends on NET_SWITCHDEV
>  	select PHYLINK
>  	select PACKING
>  	help
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/ne=
t/ethernet/microchip/lan966x/Makefile
> index 2989ba528236..974229c51f55 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -6,4 +6,4 @@
>  obj-$(CONFIG_LAN966X_SWITCH) +=3D lan966x-switch.o
> =20
>  lan966x-switch-objs  :=3D lan966x_main.o lan966x_phylink.o lan966x_port.=
o \
> -			lan966x_mac.o lan966x_ethtool.o
> +			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index dc40ac2eb246..ee453967da71 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -355,6 +355,11 @@ static const struct net_device_ops lan966x_port_netd=
ev_ops =3D {
>  	.ndo_get_port_parent_id		=3D lan966x_port_get_parent_id,
>  };
> =20
> +bool lan966x_netdevice_check(const struct net_device *dev)
> +{
> +	return dev->netdev_ops =3D=3D &lan966x_port_netdev_ops;
> +}
> +
>  static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
>  {
>  	return lan_rd(lan966x, QS_XTR_RD(grp));
> @@ -491,6 +496,9 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, v=
oid *args)
> =20
>  		skb->protocol =3D eth_type_trans(skb, dev);
> =20
> +		if (lan966x->bridge_mask & BIT(src_port))
> +			skb->offload_fwd_mark =3D 1;
> +
>  		netif_rx_ni(skb);
>  		dev->stats.rx_bytes +=3D len;
>  		dev->stats.rx_packets++;
> @@ -578,9 +586,6 @@ static int lan966x_probe_port(struct lan966x *lan966x=
, u32 p,
> =20
>  	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
> =20
> -	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
> -			  ENTRYTYPE_LOCKED);
> -
>  	port->phylink_config.dev =3D &port->dev->dev;
>  	port->phylink_config.type =3D PHYLINK_NETDEV;
>  	port->phylink_pcs.poll =3D true;
> @@ -897,6 +902,8 @@ static int lan966x_probe(struct platform_device *pdev=
)
>  		lan966x_port_init(lan966x->ports[p]);
>  	}
> =20
> +	lan966x_register_notifier_blocks(lan966x);

To be clear, "singleton" would mean that irrespective of the number of
driver instances, this function would be called once. So calling it from
lan966x_probe() isn't exactly a good choice, since every instance of the
driver "probes".

int dsa_slave_register_notifier(void)
{
	struct notifier_block *nb;
	int err;

	err =3D register_netdevice_notifier(&dsa_slave_nb);
	if (err)
		return err;

	err =3D register_switchdev_notifier(&dsa_slave_switchdev_notifier);
	if (err)
		goto err_switchdev_nb;

	nb =3D &dsa_slave_switchdev_blocking_notifier;
	err =3D register_switchdev_blocking_notifier(nb);
	if (err)
		goto err_switchdev_blocking_nb;
}

static int __init dsa_init_module(void)
{
	rc =3D dsa_slave_register_notifier();
}
module_init(dsa_init_module);

> +
>  	return 0;
> =20
>  cleanup_ports:
> @@ -915,6 +922,8 @@ static int lan966x_remove(struct platform_device *pde=
v)
>  {
>  	struct lan966x *lan966x =3D platform_get_drvdata(pdev);
> =20
> +	lan966x_unregister_notifier_blocks(lan966x);
> +
>  	lan966x_cleanup_ports(lan966x);
> =20
>  	cancel_delayed_work_sync(&lan966x->stats_work);
> @@ -922,6 +931,7 @@ static int lan966x_remove(struct platform_device *pde=
v)
>  	mutex_destroy(&lan966x->stats_lock);
> =20
>  	lan966x_mac_purge_entries(lan966x);
> +	lan966x_ext_purge_entries();

Broken with multiple lan966x driver instances - you'd erase all other
drivers' tabs keps on bridges in the system as soon as one single switch
is unbound from its driver.

> =20
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index fcd5d09a070c..3d228c9c0521 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -75,6 +75,10 @@ struct lan966x {
> =20
>  	u8 base_mac[ETH_ALEN];
> =20
> +	struct net_device *bridge;
> +	u16 bridge_mask;
> +	u16 bridge_fwd_mask;
> +
>  	struct list_head mac_entries;
>  	spinlock_t mac_lock; /* lock for mac_entries list */
> =20
> @@ -122,6 +126,11 @@ extern const struct phylink_mac_ops lan966x_phylink_=
mac_ops;
>  extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
>  extern const struct ethtool_ops lan966x_ethtool_ops;
> =20
> +bool lan966x_netdevice_check(const struct net_device *dev);
> +
> +void lan966x_register_notifier_blocks(struct lan966x *lan966x);
> +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x);
> +
>  void lan966x_stats_get(struct net_device *dev,
>  		       struct rtnl_link_stats64 *stats);
>  int lan966x_stats_init(struct lan966x *lan966x);
> @@ -157,6 +166,8 @@ int lan966x_mac_add_entry(struct lan966x *lan966x,
>  void lan966x_mac_purge_entries(struct lan966x *lan966x);
>  irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
> =20
> +void lan966x_ext_purge_entries(void);
> +
>  static inline void __iomem *lan_addr(void __iomem *base[],
>  				     int id, int tinst, int tcnt,
>  				     int gbase, int ginst,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> new file mode 100644
> index 000000000000..722ce7cb61b3
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -0,0 +1,393 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <linux/if_bridge.h>
> +#include <net/switchdev.h>
> +
> +#include "lan966x_main.h"
> +
> +static struct notifier_block lan966x_netdevice_nb __read_mostly;
> +static struct notifier_block lan966x_switchdev_nb __read_mostly;
> +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly=
;
> +
> +static LIST_HEAD(ext_entries);
> +
> +struct lan966x_ext_entry {
> +	struct list_head list;
> +	struct net_device *dev;
> +	u32 ports;
> +	struct lan966x *lan966x;
> +};
> +
> +static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < lan966x->num_phys_ports; i++) {
> +		struct lan966x_port *port =3D lan966x->ports[i];
> +		unsigned long mask =3D 0;
> +
> +		if (port && lan966x->bridge_fwd_mask & BIT(i))
> +			mask =3D lan966x->bridge_fwd_mask & ~BIT(i);
> +
> +		mask |=3D BIT(CPU_PORT);
> +
> +		lan_wr(ANA_PGID_PGID_SET(mask),
> +		       lan966x, ANA_PGID(PGID_SRC + i));
> +	}

I vaguely remember this was implemented better in previous versions of
the patch set, and the restriction to not allow multiple bridges
spanning the same switch wasn't there. Why do you keep disallowing
multiple bridges for all the Microchip hardware? There are very real use
cases that need them.

> +}
> +
> +static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 sta=
te)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	bool learn_ena =3D false;
> +
> +	if (state =3D=3D BR_STATE_FORWARDING || state =3D=3D BR_STATE_LEARNING)
> +		learn_ena =3D true;
> +
> +	if (state =3D=3D BR_STATE_FORWARDING)
> +		lan966x->bridge_fwd_mask |=3D BIT(port->chip_port);
> +	else
> +		lan966x->bridge_fwd_mask &=3D ~BIT(port->chip_port);
> +
> +	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
> +		ANA_PORT_CFG_LEARN_ENA,
> +		lan966x, ANA_PORT_CFG(port->chip_port));
> +
> +	lan966x_update_fwd_mask(lan966x);
> +}
> +
> +static void lan966x_port_ageing_set(struct lan966x_port *port,
> +				    unsigned long ageing_clock_t)
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
> +	int err =3D 0;
> +
> +	if (ctx && ctx !=3D port)
> +		return 0;
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> +		lan966x_port_stp_state_set(port, attr->u.stp_state);
> +		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> +		lan966x_port_ageing_set(port, attr->u.ageing_time);
> +		break;
> +	default:
> +		err =3D -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_port_bridge_join(struct lan966x_port *port,
> +				    struct net_device *bridge,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct net_device *dev =3D port->dev;
> +	int err;
> +
> +	if (!lan966x->bridge_mask) {
> +		lan966x->bridge =3D bridge;
> +	} else {
> +		if (lan966x->bridge !=3D bridge)

NL_SET_ERR_MSG_MOD(extack, "<excuse>");

> +			return -ENODEV;
> +	}
> +
> +	err =3D switchdev_bridge_port_offload(dev, dev, port,
> +					    &lan966x_switchdev_nb,
> +					    &lan966x_switchdev_blocking_nb,
> +					    false, extack);
> +	if (err)
> +		return err;
> +
> +	lan966x->bridge_mask |=3D BIT(port->chip_port);
> +
> +	return 0;
> +}
> +
> +static void lan966x_port_bridge_leave(struct lan966x_port *port,
> +				      struct net_device *bridge)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	lan966x->bridge_mask &=3D ~BIT(port->chip_port);
> +
> +	if (!lan966x->bridge_mask)
> +		lan966x->bridge =3D NULL;
> +
> +	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
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
> +static int lan966x_port_prechangeupper(struct net_device *dev,
> +				       struct netdev_notifier_changeupper_info *info)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +
> +	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> +		switchdev_bridge_port_unoffload(port->dev, port,
> +						&lan966x_switchdev_nb,
> +						&lan966x_switchdev_blocking_nb);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int lan966x_port_add_addr(struct net_device *dev, bool up)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	u16 vid;
> +
> +	vid =3D port->pvid;
> +
> +	if (up)
> +		lan966x_mac_cpu_learn(lan966x, dev->dev_addr, vid);
> +	else
> +		lan966x_mac_cpu_forget(lan966x, dev->dev_addr, vid);
> +
> +	return 0;
> +}
> +
> +static struct lan966x_ext_entry *lan966x_ext_find_entry(struct net_devic=
e *dev)
> +{
> +	struct lan966x_ext_entry *ext_entry;
> +
> +	list_for_each_entry(ext_entry, &ext_entries, list) {
> +		if (ext_entry->dev =3D=3D dev)
> +			return ext_entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +static bool lan966x_ext_add_entry(struct net_device *dev, void *lan966x)
> +{
> +	struct lan966x_ext_entry *ext_entry;
> +
> +	ext_entry =3D lan966x_ext_find_entry(dev);
> +	if (ext_entry) {
> +		if (ext_entry->lan966x)
> +			return false;
> +
> +		ext_entry->ports++;
> +		return true;
> +	}
> +
> +	ext_entry =3D kzalloc(sizeof(*ext_entry), GFP_KERNEL);
> +	if (!ext_entry)
> +		return false;
> +
> +	ext_entry->dev =3D dev;
> +	ext_entry->ports =3D 1;
> +	ext_entry->lan966x =3D lan966x;
> +	list_add_tail(&ext_entry->list, &ext_entries);
> +	return true;
> +}
> +
> +static void lan966x_ext_remove_entry(struct net_device *dev)
> +{
> +	struct lan966x_ext_entry *ext_entry;
> +
> +	ext_entry =3D lan966x_ext_find_entry(dev);
> +	if (!ext_entry)
> +		return;
> +
> +	ext_entry->ports--;
> +	if (!ext_entry->ports) {
> +		list_del(&ext_entry->list);
> +		kfree(ext_entry);
> +	}
> +}
> +
> +void lan966x_ext_purge_entries(void)
> +{
> +	struct lan966x_ext_entry *ext_entry, *tmp;
> +
> +	list_for_each_entry_safe(ext_entry, tmp, &ext_entries, list) {
> +		list_del(&ext_entry->list);
> +		kfree(ext_entry);
> +	}
> +}
> +
> +static int lan966x_ext_check_entry(struct net_device *dev,
> +				   unsigned long event,
> +				   void *ptr)
> +{
> +	struct netdev_notifier_changeupper_info *info;
> +
> +	if (event !=3D NETDEV_PRECHANGEUPPER)
> +		return 0;
> +
> +	info =3D ptr;
> +	if (!netif_is_bridge_master(info->upper_dev))
> +		return 0;
> +
> +	if (info->linking) {
> +		if (!lan966x_ext_add_entry(info->upper_dev, NULL))
> +			return -EOPNOTSUPP;
> +	} else {
> +		lan966x_ext_remove_entry(info->upper_dev);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static bool lan966x_port_ext_check_entry(struct net_device *dev,
> +					 struct netdev_notifier_changeupper_info *info)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct lan966x_ext_entry *entry;
> +
> +	if (!netif_is_bridge_master(info->upper_dev))
> +		return true;
> +
> +	entry =3D lan966x_ext_find_entry(info->upper_dev);

"entry" is unused in the "else" block below, so logically speaking it
could be moved inside the "if" block.

Anyway, this piece of code is objectively speaking very obscure: convoluted
(lan966x_port_ext_check_entry calls lan966x_ext_find_entry _twice_, once
here and once in lan966x_ext_add_entry ?!), no comments and poorly named
(a lan966x_ext_entry represents a _bridge_ ?! what does "ext_entry"
stand for?). Plus, with your design where the "ext_entries" list is
global, and there are two instances of the driver, each driver would do
this work twice and allocate memory twice. Although, I didn't really
understand why you need to allocate memory to keep a tab on every bridge
in the system in the first place.

If you move your check from NETDEV_PRECHANGEUPPER to NETDEV_CHANGEUPPER,
you allow the upper/lower adjacency list relationship to have formed
(allowing the use of netdev_for_each_lower_dev, and the newly joining
interface will be a lower of the bridge). But you can still reject the
bridge join.

So you can do something like this, and it should produce an equivalent
effect (not compiled, not tested, written straight in the email body):

static int lan966x_foreign_bridging_check(struct net_device *bridge,
					  struct netlink_ext_ack *extack)
{
	struct lan966x *lan966x =3D NULL;
	bool has_foreign =3D false;
	struct net_device *dev;
	struct list_head *iter;

	netdev_for_each_lower_dev(bridge, dev, iter) {
		if (lan966x_netdevice_check(dev)) {
			struct lan966x_port *port =3D netdev_priv(dev);

			if (lan996x) {
				/* Bridge already has at least one port
				 * of a lan966x switch inside it, check
				 * that it's the same instance of the
				 * driver.
				 */
				if (port->lan966x !=3D lan996x) {
					NL_SET_ERR_MSG_MOD(extack, "Bridging between multiple lan966x switches=
 disallowed");
					return -EINVAL;
				}
			} else {
				/* This is the first lan966x port inside
				 * this bridge
				 */
				lan966x =3D port->lan966x;
			}
		} else {
			has_foreign =3D true;
		}

		if (lan966x && has_foreign) {
			NL_SET_ERR_MSG_MOD(extack, "Bridging lan966x ports with foreign interfac=
es disallowed");
			return -EINVAL;
		}
	}

	return 0;
}

and call this from two distinct call paths: from the NETDEV_CHANGEUPPER
of foreign interfaces, and from the NETDEV_CHANGEUPPER of lan966x interface=
s.

Is it just me, or does this look more obvious and straightforward?

> +	if (info->linking) {
> +		if (!entry)
> +			return lan966x_ext_add_entry(info->upper_dev, lan966x);
> +
> +		if (entry->lan966x =3D=3D lan966x) {
> +			entry->ports++;
> +			return true;
> +		}
> +	} else {
> +		lan966x_ext_remove_entry(info->upper_dev);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static int lan966x_netdevice_port_event(struct net_device *dev,
> +					struct notifier_block *nb,
> +					unsigned long event, void *ptr)
> +{
> +	int err =3D 0;
> +
> +	if (!lan966x_netdevice_check(dev))
> +		return lan966x_ext_check_entry(dev, event, ptr);
> +
> +	switch (event) {
> +	case NETDEV_PRECHANGEUPPER:
> +		if (!lan966x_port_ext_check_entry(dev, ptr))
> +			return -EOPNOTSUPP;
> +
> +		err =3D lan966x_port_prechangeupper(dev, ptr);
> +		break;
> +	case NETDEV_CHANGEUPPER:
> +		err =3D lan966x_port_changeupper(dev, ptr);
> +		break;
> +	case NETDEV_PRE_UP:
> +		err =3D lan966x_port_add_addr(dev, true);
> +		break;
> +	case NETDEV_DOWN:
> +		err =3D lan966x_port_add_addr(dev, false);

Any reason why you track your own NETDEV_PRE_UP/NETDEV_DOWN and don't do
this directly in ->ndo_open/->ndo_close? Also, I don't think that the
"lan966x_port_add_addr" brings much value over "lan966x_mac_cpu_learn"
and "lan966x_mac_cpu_forget" called directly (especially if moved to
lan966x_port_open and lan966x_port_stop). And I don't see the relevance
of this change with respect to the commit title "add support to offload
the forwarding". CPU learned entries are for termination.

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
> +static int lan966x_switchdev_event(struct notifier_block *nb,
> +				   unsigned long event, void *ptr)
> +{
> +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> +	int err;
> +
> +	switch (event) {
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
> +static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> +					    unsigned long event,
> +					    void *ptr)
> +{
> +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> +	int err;
> +
> +	switch (event) {
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
> +static struct notifier_block lan966x_netdevice_nb __read_mostly =3D {
> +	.notifier_call =3D lan966x_netdevice_event,
> +};
> +
> +static struct notifier_block lan966x_switchdev_nb __read_mostly =3D {
> +	.notifier_call =3D lan966x_switchdev_event,
> +};
> +
> +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly=
 =3D {
> +	.notifier_call =3D lan966x_switchdev_blocking_event,
> +};
> +
> +void lan966x_register_notifier_blocks(struct lan966x *lan966x)
> +{
> +	register_netdevice_notifier(&lan966x_netdevice_nb);
> +	register_switchdev_notifier(&lan966x_switchdev_nb);
> +	register_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> +}
> +
> +void lan966x_unregister_notifier_blocks(struct lan966x *lan966x)
> +{
> +	unregister_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> +	unregister_switchdev_notifier(&lan966x_switchdev_nb);
> +	unregister_netdevice_notifier(&lan966x_netdevice_nb);
> +}
> --=20
> 2.33.0
>=
