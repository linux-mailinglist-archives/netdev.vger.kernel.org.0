Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF12209ADF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390456AbgFYH7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 03:59:25 -0400
Received: from mail-vi1eur05on2051.outbound.protection.outlook.com ([40.107.21.51]:6120
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726930AbgFYH7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 03:59:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsR5da5cV+CD4PcNYVY2aJZ8h2S8yJU2XZv2tFgAUWiK/zKLn5Y85jJVcDvt/Q2PKs+Ozl1dDjxCWroikKvfuRPUhBu9a9RVb4eD0Y/J4gbdfx+U5vylb2lJBF5WscWT9VwkpfjWhbc3KtunjqKefaTLgSgTfrGmjwihPl62+0eOlIjHCBcrsVKxr7/iug8PGLbZW0ACNUfRqqvfiChH7jjTpIuAmU5iBxHgQczUdFPXxictYMjUqT0OZn7l+HNpNkBH8X829hPNz7wAj+k62BylTux0JZdgod9qEOh/cc5l992B4qqa9SabNAr4utY+4Aey0PQiUxHI6HPmJx15PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m84o8PIr09bq8SqR+P8G6huyn4J0oyEbBvi/1qfX9HI=;
 b=mqrgJBfmyqkOCoK84H8NYXpahSJcNv86cwAMrZT45EXjFzz0CaHgP6EpkLKWvTQSZ7UeG9zqFcgjvHeuOctk47Bsb9LBwMQKdzsKQvB5RV7C0Ttx5ZsElMYIeDKJD0uDG53snaEoT362Q6jnawuNhxs2Fzdlm1ZxU0AM2WcNEq+F6b/tIqSzlBuBPFDONOy0QjcC8uRriH7/KzSkdZQOtxobC/PDzM4Him8YHiYxrHdOtoFuxv7Cqd6OT25iQ95Rk5/po47qU0sOi0Jvf93K5+HYUcvyTMsv9r/GpoEScgAIe63wYYGYnaNuY0SHU2saMjQijxn8RXPFUy8bvJS8Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m84o8PIr09bq8SqR+P8G6huyn4J0oyEbBvi/1qfX9HI=;
 b=De97Nzn8ycZPUsFZWpdwpRxLySWXapy/p2lObE9SXXxhR/mlJgA/oSQPcjCAVFH16m6k4l/y6zlIaV0Y40Q6mLT0+7UVp0S+oh0a/9YFdsqomZUS3MKyMxx/WqnyxjXwuY6HoLvGRN5jb5uS0iaAMEygQzTwwrBM7Q9xgJMyb+Q=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2944.eurprd04.prod.outlook.com
 (2603:10a6:800:ad::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 07:59:19 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 07:59:19 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Thread-Topic: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Thread-Index: AQHWSqolmMlF7SH9WEOFLZfmLn4KCKjo9MVQ
Date:   Thu, 25 Jun 2020 07:59:19 +0000
Message-ID: <VI1PR0402MB3871BFA3098D784FB940759EE0920@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d01bfe9c-17af-4eaa-e06d-08d818ddaa3a
x-ms-traffictypediagnostic: VI1PR0402MB2944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2944E3BC799BE1261F7581F2E0920@VI1PR0402MB2944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yzuozpCN9TMqwuD6GcDefpuZFaUf9LuaKsFAYiyAtZ3EbpRi07PJ+I6k8bj15aAEkYgzsWqERYo/BjJBVUGGhxu2fjUxD8/cYYBs8KfOt07zYz65slBqsCKs+KbZ1VCyIahYCqgeBJabZomYKIRAYG1OX4p0S8JJEYxmY67KWvan3g5tkMGDrhhT3f0D/6UBYIQ0I7IoSLcNBB5n18WDDfaZmTDrqNcNISIDsVBpYmz6r7mVE7XTSkg6qFWS2jokQDaDaowhQe20uwHnZbYTdlf75gHPoB6+vtdq89V4LPemop4RS73S9/uWIvNkwzVizUZYwDTwpmLS1dGkg98p+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(9686003)(52536014)(8936002)(7696005)(8676002)(71200400001)(86362001)(5660300002)(44832011)(83380400001)(478600001)(26005)(2906002)(55016002)(33656002)(4326008)(186003)(6506007)(66556008)(316002)(76116006)(66476007)(54906003)(64756008)(110136005)(66446008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KCjns2cO8OzrtZHMOSPUrFNaIl2LxYeV6XM4eddU83k89rFRx4MnY0JZVh0yBORe6JEnAn2VhRcpTCclvpfi9OpuH6umwtVGN3Pq2zT4+RuOa4Vui8H80nMjjBRn4HQbnCQi8Z73+KedxYMXEnBhiT6VfnScHSxmQKZuO9WZH0p7FomSWSvoH0SJ4ccG2zU8iHYLnxnta3/+xo3qIQPZCwKsSm8NX0TwQZnQYro1jEwiIae+iKYoXrEJrAhT+Vw1p3I9hNufsVMSkBtfQRFsJ/SJdLsXTvNU4qQqxdZJdju/abhfY+pV6MJYKDsdOtCmZbQ3VGPWeJogDOdXOWftR2C8UvOd+mia1mO6Bvpr+V8UCpuDweIfZsPm9J1V9Gjck30t2y91WNaLyH086NtOkeYuhnYuldpdch8ZO7OwB04mneIvHTBeC0QlVtI2IA+ycLBQZqyP6Y84sqnlXqvpogGONjncjbuV7uZLebplDWg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01bfe9c-17af-4eaa-e06d-08d818ddaa3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 07:59:19.4310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /iAd78RYIUV7XWaiZ1MK3yT9JzzN74qOkLkYBXBSd6bRTgczzX4lvUpJXBThtkrONBetTfG6HF3yEA7b/kF+OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2944
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2 M=
AC
> driver
>=20
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either DT or
> ACPI.
> Replace of_get_phy_mode() with fwnode_get_phy_mode() to get phy-mode for
> a dpmac_node.
> Define and use helper function dpaa2_find_phy_device() to find phy_dev th=
at is
> later connected to mac->phylink.
>=20
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>=20
> ---
>=20
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 114 +++++++++++++-----
>  1 file changed, 86 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 3ee236c5fc37..163da735ab29 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -3,6 +3,8 @@
>=20
>  #include "dpaa2-eth.h"
>  #include "dpaa2-mac.h"
> +#include <linux/acpi.h>
> +#include <linux/platform_device.h>
>=20
>  #define phylink_to_dpaa2_mac(config) \
>  	container_of((config), struct dpaa2_mac, phylink_config) @@ -23,38
> +25,54 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t
> *if_mode)  }
>=20
>  /* Caller must call of_node_put on the returned value */ -static struct
> device_node *dpaa2_mac_get_node(u16 dpmac_id)
> +static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
> +						u16 dpmac_id)
>  {
> -	struct device_node *dpmacs, *dpmac =3D NULL;
> -	u32 id;
> +	struct fwnode_handle *dpmacs, *dpmac =3D NULL;
> +	unsigned long long adr;
> +	acpi_status status;
>  	int err;
> +	u32 id;
>=20
> -	dpmacs =3D of_find_node_by_name(NULL, "dpmacs");
> -	if (!dpmacs)
> -		return NULL;
> +	if (is_of_node(dev->parent->fwnode)) {
> +		dpmacs =3D device_get_named_child_node(dev->parent,
> "dpmacs");
> +		if (!dpmacs)
> +			return NULL;


Hi Calvin,

Unfortunately, this is breaking the OF use case.

[    4.236045] fsl_dpaa2_eth dpni.0 (unnamed net_device) (uninitialized): N=
o dpmac@17 node found.             =20
[    4.245646] fsl_dpaa2_eth dpni.0 (unnamed net_device) (uninitialized): E=
rror connecting to the MAC endpoint=20
[    4.331921] fsl_dpaa2_eth dpni.0: fsl_mc_driver_probe failed: -19       =
                                   =20

You replaced of_find_node_by_name() which searches the entire DTS
file (hence the NULL first parameter) with device_get_named_child_node(dev-=
>parent, ..)
which only searches starting with the dev->parent device. In this case, the
parent device is dprc.1 (the root container) which is not probing on the
device tree so the associated fwnode_handle is NULL.

Regards,
Ioana

> +
> +		while ((dpmac =3D fwnode_get_next_child_node(dpmacs,
> dpmac))) {
> +			err =3D fwnode_property_read_u32(dpmac, "reg", &id);
> +			if (err)
> +				continue;
> +			if (id =3D=3D dpmac_id)
> +				return dpmac;
> +		}
>=20
> -	while ((dpmac =3D of_get_next_child(dpmacs, dpmac)) !=3D NULL) {
> -		err =3D of_property_read_u32(dpmac, "reg", &id);
> -		if (err)
> -			continue;
> -		if (id =3D=3D dpmac_id)
> -			break;
> +	} else if (is_acpi_node(dev->parent->fwnode)) {
> +		device_for_each_child_node(dev->parent, dpmac) {
> +			status =3D
> acpi_evaluate_integer(ACPI_HANDLE_FWNODE(dpmac),
> +						       "_ADR", NULL, &adr);
> +			if (ACPI_FAILURE(status)) {
> +				dev_info(dev, "_ADR returned status 0x%x\n",
> status);
> +				continue;
> +			} else {
> +				id =3D (u32)adr;
> +				if (id =3D=3D dpmac_id)
> +					return dpmac;
> +			}
> +		}
>  	}
> -
> -	of_node_put(dpmacs);
> -
> -	return dpmac;
> +	return NULL;
>  }
>=20
> -static int dpaa2_mac_get_if_mode(struct device_node *node,
> +static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
>  				 struct dpmac_attr attr)
>  {
>  	phy_interface_t if_mode;
>  	int err;
>=20
> -	err =3D of_get_phy_mode(node, &if_mode);
> -	if (!err)
> -		return if_mode;
> +	err =3D fwnode_get_phy_mode(dpmac_node);
> +	if (err > 0)
> +		return err;
>=20
>  	err =3D phy_mode(attr.eth_if, &if_mode);
>  	if (!err)
> @@ -227,11 +245,41 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device
> *dpmac_dev,
>  	return fixed;
>  }
>=20
> +static struct phy_device *dpaa2_find_phy_device(struct fwnode_handle
> +*fwnode) {
> +	struct fwnode_reference_args args;
> +	struct platform_device *pdev;
> +	struct mii_bus *mdio;
> +	struct device *dev;
> +	acpi_status status;
> +	int addr;
> +	int err;
> +
> +	status =3D acpi_node_get_property_reference(fwnode, "mdio-handle",
> +						  0, &args);
> +
> +	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> +		return NULL;
> +
> +	dev =3D bus_find_device_by_fwnode(&platform_bus_type, args.fwnode);
> +	if (IS_ERR_OR_NULL(dev))
> +		return NULL;
> +	pdev =3D  to_platform_device(dev);
> +	mdio =3D platform_get_drvdata(pdev);
> +
> +	err =3D fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> +	if (err < 0 || addr < 0 || addr >=3D PHY_MAX_ADDR)
> +		return NULL;
> +
> +	return mdiobus_get_phy(mdio, addr);
> +}
> +
>  int dpaa2_mac_connect(struct dpaa2_mac *mac)  {
>  	struct fsl_mc_device *dpmac_dev =3D mac->mc_dev;
>  	struct net_device *net_dev =3D mac->net_dev;
> -	struct device_node *dpmac_node;
> +	struct fwnode_handle *dpmac_node =3D NULL;
> +	struct phy_device *phy_dev;
>  	struct phylink *phylink;
>  	struct dpmac_attr attr;
>  	int err;
> @@ -251,7 +299,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>=20
>  	mac->if_link_type =3D attr.link_type;
>=20
> -	dpmac_node =3D dpaa2_mac_get_node(attr.id);
> +	dpmac_node =3D dpaa2_mac_get_node(&dpmac_dev->dev, attr.id);
>  	if (!dpmac_node) {
>  		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
>  		err =3D -ENODEV;
> @@ -269,7 +317,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	 * error out if the interface mode requests them and there is no PHY
>  	 * to act upon them
>  	 */
> -	if (of_phy_is_fixed_link(dpmac_node) &&
> +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
>  	    (mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
>  	     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
>  	     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)) { @@ -
> 282,7 +330,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	mac->phylink_config.type =3D PHYLINK_NETDEV;
>=20
>  	phylink =3D phylink_create(&mac->phylink_config,
> -				 of_fwnode_handle(dpmac_node), mac-
> >if_mode,
> +				 dpmac_node, mac->if_mode,
>  				 &dpaa2_mac_phylink_ops);
>  	if (IS_ERR(phylink)) {
>  		err =3D PTR_ERR(phylink);
> @@ -290,20 +338,30 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	}
>  	mac->phylink =3D phylink;
>=20
> -	err =3D phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +	if (is_of_node(dpmac_node))
> +		err =3D phylink_of_phy_connect(mac->phylink,
> +					     to_of_node(dpmac_node), 0);
> +	else if (is_acpi_node(dpmac_node)) {
> +		phy_dev =3D dpaa2_find_phy_device(dpmac_node);
> +		if (IS_ERR(phy_dev))
> +			goto err_phylink_destroy;
> +		err =3D phylink_connect_phy(mac->phylink, phy_dev);
> +	}
>  	if (err) {
> -		netdev_err(net_dev, "phylink_of_phy_connect() =3D %d\n", err);
> +		netdev_err(net_dev, "phylink_fwnode_phy_connect() =3D %d\n",
> err);
>  		goto err_phylink_destroy;
>  	}
>=20
> -	of_node_put(dpmac_node);
> +	if (is_of_node(dpmac_node))
> +		of_node_put(to_of_node(dpmac_node));
>=20
>  	return 0;
>=20
>  err_phylink_destroy:
>  	phylink_destroy(mac->phylink);
>  err_put_node:
> -	of_node_put(dpmac_node);
> +	if (is_of_node(dpmac_node))
> +		of_node_put(to_of_node(dpmac_node));
>  err_close_dpmac:
>  	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
>  	return err;
> --
> 2.17.1

