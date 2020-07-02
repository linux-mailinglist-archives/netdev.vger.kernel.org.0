Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4158211F23
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGBIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:48:44 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:44507
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725287AbgGBIso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 04:48:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6+f1v6H+C2aqKxLtJJ9v17T4tiHouseyBVMsqG9xLBcx3g7nkfkjBwhRQwlpe405tJttpgV8m0LkxZv9qrpAndWeYyuzJ8M/tgdvQ8TSAHYJCUbUsqea7dlT+xgPpj8DxOeXp0iMHwp8JUeLeexsMrfeIqUcgzBYI4fvlXQBbDwoTQklECtu7zxFvNwInQc/CX859DUql4Jwd7ujTUSNOHwfLez+3ji80iWtfWXhkrJg+s07l55fSNABOWNqoXKWNli2U4J54EOL84W9xk402YQ/hR+6wQ1L46I4o4TPO3Qpjn0+UEvhstVeOUDko7WP+UuWj/HeIih/lIU9gndVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSn+x+tNsMo3RN0SMd8/M0ssOALuXztYBBPau/ldBIM=;
 b=F3jmj1Wc61TKYY8FCRBVjdCv0rYQ9kqvES+lhmg16F2c/aL4avBodO0OKgGgYftJbUk7o9I7L9f2J/6Jsi+wwqQ4JsvWbHrs6T8swRS4YqITAX779Bv44YTtg/lpfrVQ9tqKAfQB9DZXFOx/DD9BbrU2DKVSuQeutpxB8e/h+4m+D5U9vEZ8sGJ8xzrMMCEmBsXayjnirQn9Xc9uuV4QPNqBiBjco+ZmwurAdcTLBNTblze/6qhKrFkeVUXXAeE+xcz21bi5+S4r133huwwnvP6TKgZmJ2ktCbGzeuNvV6WLwX0IQX4bJ0aGoWw5t+wlH09nea2cTsFuebV+LSFJ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSn+x+tNsMo3RN0SMd8/M0ssOALuXztYBBPau/ldBIM=;
 b=qeGL73yYFql/GthRGphr+aLYbh6RCWVUMO0QGwigPSPw8Iz4P0q6nc5WUOGKZe+AJxNEycWUgr7eQvlu+7/wevMx6FFZ8V3YCAgDoCnYCvGesrvCc1Qsd6Lipkk6a8OVb1bSe4avudEnnQfF58pbN70p5ciZGuoRPSoucy4wScI=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3469.eurprd04.prod.outlook.com
 (2603:10a6:803:d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 2 Jul
 2020 08:48:39 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3131.028; Thu, 2 Jul 2020
 08:48:39 +0000
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
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Thread-Topic: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
Thread-Index: AQHWT269YgAmGtRtDUaoEYVt8gTAOajz955A
Date:   Thu, 2 Jul 2020 08:48:38 +0000
Message-ID: <VI1PR0402MB387145B3181911668E024264E06D0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-4-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200701061233.31120-4-calvin.johnson@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f247fae-9cc2-4490-edc7-08d81e64b731
x-ms-traffictypediagnostic: VI1PR0402MB3469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34695C95855A3E71BA47AE26E06D0@VI1PR0402MB3469.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XUIFvCVmpxvkmA+eSpEs2eLZO/8c1KPtf2S2H5GHjLJUaZXoJT63qI9gQKFbIR2JhONuAVssdA4YhOLtth/zT8kNn+r0s1G0qQjoFlMlOAO6Y2YLnqk98rUlWIIgv3TK6OOnszRPnP1KzExI5dSMtPuIe+RCVWSEg0OI7T8o5NIoeBCt4riHJb95MsOrbjmHdKjs7Ne4r5mIUc5cN5d3iy0MO4JCKM2vhcCPld41ZMlct7opnuYT/+qMMs4E3DIxiKUoeBQn/noVjGsL99Nh/QFmy0iL58MxdePO7hgYUOlPRahX2wrOUQg897SvxMzYZhmOwrhjAfeOQWlUMMDTKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(86362001)(8676002)(6506007)(8936002)(478600001)(33656002)(66446008)(64756008)(66946007)(2906002)(71200400001)(83380400001)(76116006)(66556008)(66476007)(316002)(9686003)(52536014)(7416002)(26005)(4326008)(54906003)(7696005)(5660300002)(44832011)(55016002)(110136005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NuWqM3jiU9FfCTeevxavzNJPM3pXlNVdaihPKCxsb8xyh81iZPIz27So9O6vywpJIn+6EAfsMn5aK6IWSFuaGSyGLLmSW2gvKlSbXFxsavgYx9rgOWCqJl7xp9xkLO+eexeQ6DJ+LNAM3XtoBEUwV3hmCQ/JrCZJK/7P2uAzJUwKkYZxfNzcO9S3u+4l1wc1FPivz4QsW473hoPW8K//Qak4lcgwQw4jKNPER+fGfEQIzOKpLF2RD91g3J7az5/jydCVi9q34fwpUpuudBsQi6C+rDVJiBkuA5OGPX0Kh1IydwikCO09niW7tjtGHErpjhPLf9hd7awM+yMwjfNhxXt+Uj10Bm/bzsApAR/+Oax9S3gBX1WZTj5An+SIiw3XrmubFuZMlLyDkPGoqupi5c1blC9hhe2KLbjUCbTHtKR7+UBfdeER3YYhuovS5QucAvEAFV32EYCZuHKG7oOAwN08egJnzqyvlfg9pZMg/TBqiLqb9K0GhzjmBxcHCH7X
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f247fae-9cc2-4490-edc7-08d81e64b731
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 08:48:38.9921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YhOFTcd7mfZgogkTUmKWazXkO02IY6BepthyhwPvrtSiTZy1dYsUKoyl5MjJt0r0Buw1khlHzhPmDH/iXwBuzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3469
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for DPA=
A2
> MAC driver
>=20
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either DT or
> ACPI.
> Replace of_get_phy_mode with fwnode_get_phy_mode to get phy-mode for a
> dpmac_node.
> Define and use helper function find_phy_device() to find phy_dev that is =
later
> connected to mac->phylink.
>=20
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>=20
> ---
>=20
> Changes in v2:
>     - clean up dpaa2_mac_get_node()
>     - introduce find_phy_device()
>     - use acpi_find_child_device()
>=20
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 ++++++++++++-------
>  1 file changed, 50 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 3ee236c5fc37..78e8160c9b52 100644
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
> +25,46 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t
> *if_mode)  }
>=20
>  /* Caller must call of_node_put on the returned value */ -static struct
> device_node *dpaa2_mac_get_node(u16 dpmac_id)
> +static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
> +						u16 dpmac_id)
>  {
> -	struct device_node *dpmacs, *dpmac =3D NULL;
> -	u32 id;
> +	struct fwnode_handle *fsl_mc_fwnode =3D dev->parent->parent-
> >fwnode;
> +	struct fwnode_handle *dpmacs, *dpmac =3D NULL;
> +	struct device *fsl_mc =3D dev->parent->parent;
> +	struct acpi_device *adev;
>  	int err;
> +	u32 id;
>=20
> -	dpmacs =3D of_find_node_by_name(NULL, "dpmacs");
> -	if (!dpmacs)
> -		return NULL;
> -
> -	while ((dpmac =3D of_get_next_child(dpmacs, dpmac)) !=3D NULL) {
> -		err =3D of_property_read_u32(dpmac, "reg", &id);
> -		if (err)
> -			continue;
> -		if (id =3D=3D dpmac_id)
> -			break;
> +	if (is_of_node(fsl_mc_fwnode)) {
> +		dpmacs =3D device_get_named_child_node(fsl_mc, "dpmacs");
> +		if (!dpmacs)
> +			return NULL;
> +
> +		while ((dpmac =3D fwnode_get_next_child_node(dpmacs,
> dpmac))) {
> +			err =3D fwnode_property_read_u32(dpmac, "reg", &id);
> +			if (err)
> +				continue;
> +			if (id =3D=3D dpmac_id)
> +				return dpmac;
> +		}
> +	} else if (is_acpi_node(fsl_mc_fwnode)) {
> +		adev =3D acpi_find_child_device(ACPI_COMPANION(dev->parent),
> +					      dpmac_id, false);
> +		if (adev)
> +			return (&adev->fwnode);
>  	}
> -
> -	of_node_put(dpmacs);
> -

This of_node_put() on the 'dpmacs'  node still needs to happen for the OF c=
ase.

Ioana

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
> @@ -231,7 +241,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)  {
>  	struct fsl_mc_device *dpmac_dev =3D mac->mc_dev;
>  	struct net_device *net_dev =3D mac->net_dev;
> -	struct device_node *dpmac_node;
> +	struct fwnode_handle *dpmac_node =3D NULL;
> +	struct phy_device *phy_dev;
>  	struct phylink *phylink;
>  	struct dpmac_attr attr;
>  	int err;
> @@ -251,7 +262,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>=20
>  	mac->if_link_type =3D attr.link_type;
>=20
> -	dpmac_node =3D dpaa2_mac_get_node(attr.id);
> +	dpmac_node =3D dpaa2_mac_get_node(&dpmac_dev->dev, attr.id);
>  	if (!dpmac_node) {
>  		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
>  		err =3D -ENODEV;
> @@ -269,7 +280,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	 * error out if the interface mode requests them and there is no PHY
>  	 * to act upon them
>  	 */
> -	if (of_phy_is_fixed_link(dpmac_node) &&
> +	if (of_phy_is_fixed_link(to_of_node(dpmac_node)) &&
>  	    (mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
>  	     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
>  	     mac->if_mode =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)) { @@ -
> 282,7 +293,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	mac->phylink_config.type =3D PHYLINK_NETDEV;
>=20
>  	phylink =3D phylink_create(&mac->phylink_config,
> -				 of_fwnode_handle(dpmac_node), mac-
> >if_mode,
> +				 dpmac_node, mac->if_mode,
>  				 &dpaa2_mac_phylink_ops);
>  	if (IS_ERR(phylink)) {
>  		err =3D PTR_ERR(phylink);
> @@ -290,20 +301,30 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	}
>  	mac->phylink =3D phylink;
>=20
> -	err =3D phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
> +	if (is_of_node(dpmac_node))
> +		err =3D phylink_of_phy_connect(mac->phylink,
> +					     to_of_node(dpmac_node), 0);
> +	else if (is_acpi_node(dpmac_node)) {
> +		phy_dev =3D find_phy_device(dpmac_node);
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

