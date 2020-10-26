Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0929962F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783338AbgJZS5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:57:06 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:32870
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1783214AbgJZS5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWg4YA6SkSrreyUuZSz7fIJfOYy4JywRnxfqD74PMjvveWM9mtnwqtORbwugLIrKSJ9/tA+accRFneL7YoW2hIg7eQQB5qmE71E+RWPy7kBEdK2v3YTKZ+TVkhB1T/gERyh8xkZjXeaX4FyGRajCam1H07JXgiazQSbiLAg+CidmC8ASoXgA3OyJc6olPiWj6tG38ndunFSf1HU+MOKeY8s6p9icNnu7diHX3mjeHiHTim+guwKFsvHWkEJHeEQz0AaVzceAuPxTzz2zQiey0tZOF/hp2nPLW/rdwbl7hO2DRXk6JYuf40/t+3ISZ3nESHsBngLrombrDhya/Erw9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JhOpitdYtZfFpTzoizHI2wPBNlRfNW0JuBV2J198pw=;
 b=Ao0gXfpqAJka94qUNuqxRSGSQEnDrEJrF+WKAoFfLSDahdJ5jF1L9yICWDKMSMBhnOSEo751/BO1rLm6zfMBxT5I0VQJh0tqvbGL6AaYd6oXsfqGL4kjJMw3kO8r2BAl4Dp/ItXhLpzWNt9iaZ+cgGKEGA5++61t4gt606oCux9zp+mSKWiEu4NxeNTXlwiagIMk7iITEYw2VnLpLvOLEwAuVsWq88q7izlib6a1uEh0QOSWP+H+5XtiPHoU+6Wivm+FuLOvK8syPBt2SbVkoznRt7N4fVpIdE1Osf6itX/J11e2BlAXrOpwkKgyjJbcamLODvpoe0KT/Ops/DC66g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JhOpitdYtZfFpTzoizHI2wPBNlRfNW0JuBV2J198pw=;
 b=rg2FEPemoBTvKQ77Ie/WA9XSX9sNYHwX/DeJeb0d7FuspzEpHk8WicBknKrbHZ/tL/uyG3z0OPkF8FG90gjI+fAYwr7uIxE7uHbCQlOX7NCpMAZKhKo51JkWOPEvhS51vknA3joYppAtNKshTkIAuO2NWUPCGHmjjOrBfx4GvHs=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by BYAPR02MB4421.namprd02.prod.outlook.com (2603:10b6:a03:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 26 Oct
 2020 18:57:01 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::65d9:9ba5:d17:35db]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::65d9:9ba5:d17:35db%7]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 18:57:01 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Michal Simek <michals@xilinx.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY for
 1000BaseX mode
Thread-Topic: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY
 for 1000BaseX mode
Thread-Index: AQHWq8E+sKa6qx9r90iNR/QS92jA7KmqOwzg
Date:   Mon, 26 Oct 2020 18:57:00 +0000
Message-ID: <BYAPR02MB56382BA3CB100008FC02B02BC7190@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <20201026175535.1332222-1-robert.hancock@calian.com>
In-Reply-To: <20201026175535.1332222-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: calian.com; dkim=none (message not signed)
 header.d=none;calian.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [47.8.123.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0ce8633-d68f-457d-5525-08d879e0ec25
x-ms-traffictypediagnostic: BYAPR02MB4421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB442158D49191D956487EC635C7190@BYAPR02MB4421.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tJRGvwYYI0Sh3nbhrCSJIWLw3YJ5p+NGJPkkn9Me4i+9Mpw+Nwu1WAlbbTtr7zePdGX9l83jEzT6pDVk22FavZTAMIQeiUyua+Yfviy6YAygQrSpT77wEJzE8Q176vkIQ8Gp1eRWh0OGnt+Vqlcr6D8eh9qac8BSiDtEu2p/sWIB6WvMjPpQwJS8iJ9ZRJhBvupSLWrG5eRZq4AWHU8e82xqU1PUd7rVBIyGNrhTxiZdWf9+2k0fqlaE1878KP6f9q/wMyqg3aw+Fo8TOXi21K07bKQY000Fmmm8E/AwYL0lx+GwwX1YTdF/4DZTWWTIS46WWohYryKkIvfFAoONCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(52536014)(66556008)(64756008)(7696005)(5660300002)(66946007)(76116006)(2906002)(478600001)(6506007)(53546011)(66476007)(33656002)(9686003)(26005)(186003)(4326008)(66446008)(86362001)(71200400001)(110136005)(54906003)(55016002)(8936002)(316002)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KA8aE/iz8HJI+BcLI7l8Xwf21v3vGsWpEJDUtHDNbRhLG+Enqlq+lhKPM3X7lYK3DxlaSXI2bUTUxACTJgDir1SMfnsLZuPY3bN3yi4BlaO8I8k9rCr1hfvp1uV7PAtaL5d6+4pnJheXt6eDwPRDgOV2rWaHY9DJzhn7BXwMhhTiCESynbw0eIoq9+ncaq1lx3xKSJsiyD42sLpIY3WNvQW1/9WWsLB4wdsVJf+CS5z/cnF5EKxF818uWWcC53Vn34LvQh5gnJ9YTtKKET4wozWdJi5Krr6U3IXU4aPUpyoKX+aYRBCBAZwDlqjJB+kuNyOizxqXDPfiHiKfZ3csRhy1qvYRjiHcWBIZd0fmx1sEEJWxbtn4yytaaEaYPoYcS/aCUpgU4JZzPN1lsWtM8KJN8aXmyTifHLVJBicMCQNuRT1eYuYvRtsAqp9zvf5ZaRAmkd/K/2KJRWtzF7QkXCwAS5I5L4l14gcRZ42HLx9OMh/NOOEBiJwAnJV3ZIkSJ2cANi0WPRyQgnV1hYdmPjB5UEOvpPOlpt20wqSWDHbXm0Hop8RiC/jF+JsHnD0o1D9UEyQA1dEXKIeAM1YIegoQ9M163E2qSursZ/jSQK0y//G3RGWW29yGvkDEmWxx9fjmJ+S5CC27toXVnPQ0UA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ce8633-d68f-457d-5525-08d879e0ec25
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 18:57:01.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0jTi63f8taV4VNnpUTnO5cCeVi5/rkWGnhY/E2y7UAQVPCAdIliDz5qXvGeZIxkz7cRNq1XVpEhdKtNH4Vs0Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4421
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch.

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Monday, October 26, 2020 11:26 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org
> Cc: Michal Simek <michals@xilinx.com>; linux@armlinux.org.uk;
> andrew@lunn.ch; netdev@vger.kernel.org; Robert Hancock
> <robert.hancock@calian.com>
> Subject: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY fo=
r
> 1000BaseX mode
>=20
> Update the axienet driver to properly support the Xilinx PCS/PMA PHY
> component which is used for 1000BaseX and SGMII modes, including
> properly configuring the auto-negotiation mode of the PHY and reading
> the negotiated state from the PHY.
>=20
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>=20
> Resubmit of v2 tagged for net-next.
>=20
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  |  3 +
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 96 ++++++++++++++-----
>  2 files changed, 73 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index f34c7903ff52..7326ad4d5e1c 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -419,6 +419,9 @@ struct axienet_local {
>  	struct phylink *phylink;
>  	struct phylink_config phylink_config;
>=20
> +	/* Reference to PCS/PMA PHY if used */
> +	struct mdio_device *pcs_phy;
> +
>  	/* Clock for AXI bus */
>  	struct clk *clk;
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 9aafd3ecdaa4..f46595ef2822 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1517,10 +1517,29 @@ static void axienet_validate(struct
> phylink_config *config,
>=20
>  	phylink_set(mask, Asym_Pause);
>  	phylink_set(mask, Pause);
> -	phylink_set(mask, 1000baseX_Full);
> -	phylink_set(mask, 10baseT_Full);
> -	phylink_set(mask, 100baseT_Full);
> -	phylink_set(mask, 1000baseT_Full);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_NA:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		phylink_set(mask, 1000baseX_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		if (state->interface =3D=3D PHY_INTERFACE_MODE_1000BASEX)
> +			break;

100BaseT and 10BaseT can be set in PHY_INTERFACE_MODE_MII if we=20
allow fallthrough here.
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 10baseT_Full);
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 10baseT_Full);
> +	default:
> +		break;
> +	}
>=20
>  	bitmap_and(supported, supported, mask,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> @@ -1533,38 +1552,46 @@ static void axienet_mac_pcs_get_state(struct
> phylink_config *config,
>  {
>  	struct net_device *ndev =3D to_net_dev(config->dev);
>  	struct axienet_local *lp =3D netdev_priv(ndev);
> -	u32 emmc_reg, fcc_reg;
> -
> -	state->interface =3D lp->phy_mode;
>=20
> -	emmc_reg =3D axienet_ior(lp, XAE_EMMC_OFFSET);
> -	if (emmc_reg & XAE_EMMC_LINKSPD_1000)
> -		state->speed =3D SPEED_1000;
> -	else if (emmc_reg & XAE_EMMC_LINKSPD_100)
> -		state->speed =3D SPEED_100;
> -	else
> -		state->speed =3D SPEED_10;
> -
> -	state->pause =3D 0;
> -	fcc_reg =3D axienet_ior(lp, XAE_FCC_OFFSET);
> -	if (fcc_reg & XAE_FCC_FCTX_MASK)
> -		state->pause |=3D MLO_PAUSE_TX;
> -	if (fcc_reg & XAE_FCC_FCRX_MASK)
> -		state->pause |=3D MLO_PAUSE_RX;
> -
> -	state->an_complete =3D 0;
> -	state->duplex =3D 1;
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		phylink_mii_c22_pcs_get_state(lp->pcs_phy, state);
> +		break;
> +	default:
> +		break;
> +	}
>  }
>=20
>  static void axienet_mac_an_restart(struct phylink_config *config)
>  {
> -	/* Unsupported, do nothing */
> +	struct net_device *ndev =3D to_net_dev(config->dev);
> +	struct axienet_local *lp =3D netdev_priv(ndev);
> +
> +	phylink_mii_c22_pcs_an_restart(lp->pcs_phy);

Is this phylink.._an_restart only called for 1000BaseX/SGMII?
>  }
>=20
>  static void axienet_mac_config(struct phylink_config *config, unsigned i=
nt
> mode,
>  			       const struct phylink_link_state *state)
>  {
> -	/* nothing meaningful to do */
> +	struct net_device *ndev =3D to_net_dev(config->dev);
> +	struct axienet_local *lp =3D netdev_priv(ndev);
> +	int ret;
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		ret =3D phylink_mii_c22_pcs_config(lp->pcs_phy, mode,
> +						 state->interface,
> +						 state->advertising);
> +		if (ret < 0)
> +			netdev_warn(ndev, "Failed to configure PCS: %d\n",
> +				    ret);
> +		break;
> +
> +	default:
> +		break;
> +	}
>  }
>=20
>  static void axienet_mac_link_down(struct phylink_config *config,
> @@ -1999,6 +2026,20 @@ static int axienet_probe(struct platform_device
> *pdev)
>  			dev_warn(&pdev->dev,
>  				 "error registering MDIO bus: %d\n", ret);
>  	}

Minor nit - There is already a check for phy_node at L1882. Maybe we
can refactor and use it.
if (!lp->phy_node) {
	if (lp->phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII  || BASEX)
		//error handing
} else {
	//existing code
}

> +	if (lp->phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII ||
> +	    lp->phy_mode =3D=3D PHY_INTERFACE_MODE_1000BASEX) {
> +		if (!lp->phy_node) {
> +			dev_err(&pdev->dev, "phy-handle required for
> 1000BaseX/SGMII\n");
> +			ret =3D -EINVAL;
> +			goto free_netdev;
> +		}
> +		lp->pcs_phy =3D of_mdio_find_device(lp->phy_node);
> +		if (!lp->pcs_phy) {
> +			ret =3D -EPROBE_DEFER;

Are we assuming the error is always EPROBE_DEFER?
> +			goto free_netdev;
> +		}
> +		lp->phylink_config.pcs_poll =3D true;
> +	}
>=20
>  	lp->phylink_config.dev =3D &ndev->dev;
>  	lp->phylink_config.type =3D PHYLINK_NETDEV;
> @@ -2036,6 +2077,9 @@ static int axienet_remove(struct platform_device
> *pdev)
>  	if (lp->phylink)
>  		phylink_destroy(lp->phylink);
>=20
> +	if (lp->pcs_phy)
> +		put_device(&lp->pcs_phy->dev);
> +
>  	axienet_mdio_teardown(lp);
>=20
>  	clk_disable_unprepare(lp->clk);
> --
> 2.18.4

