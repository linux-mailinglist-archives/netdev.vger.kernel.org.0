Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803102845CD
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgJFGJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:09:04 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:63975
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbgJFGJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 02:09:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvH12UkQpl2h9T5ADN72kDm3Lz+DOeLzHliNi0pWb4cVKr/GMzSSnpHzFn41J/5Nvf9XBDCd7SA3zkwpbGzhY7gYCQO3/adzcPvtJhTyFMyZLfnP1k/NXgWtRwZk+jdYYiLIGbWcetDuC6Thl5yQcan1SVq+pUTjJOT9amKB/MblYDyAH5JhW7BkxNxJ6PdlKCO9opmWkh6VLCTLFiK4bQyTc9E98FNnLApSkz5n7E+pofn+GWPUI1nWFdweYHWd4QIAQTlR3HGUJJSjwS+x8HIkFjxQUINygfgJfuj+VDs+3Z2UZwogzZZN5BoZyAwkHbLRNcLYifC05gp/sZ9vrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XP3kQMTFSvnEJdB5jz2ZI/IzZYf7A7ta/EZIYfy0C6A=;
 b=RJHpy78b07ls3Yb4B12cxe2crF6UNGnnWsAnF2PPrD7SpidNnEERnJiWv9qVzRlGp2L4shtq1gSXjmfasMPWU7VZs3seMk4hsV8jebMP8W0/Ch0EtqJhfE5MdXUjJEQOf/ASEUjeU7IyaktdJThaidcAb+zndgZE0P3exhrfr9lsGMK4NiKidqUciwzT0aOMBuyQIg6jc/mHKFGN9SKTBrDtTPEq74Sbzte29hyvifMif8s9aLacjaLJWPSTwleafLA8oRKAGRjlkj7s6g4XS+zN/MhzR6n7Q2BY5XawEMDqp4nF5/bpUKcG00YSzpcmIhh/Lvv2Ir3tpEFbVkdbZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XP3kQMTFSvnEJdB5jz2ZI/IzZYf7A7ta/EZIYfy0C6A=;
 b=rQaRc/1q8RR8bb1zMMdZbrGJq5yBwAnBROJc/hbvl5bA/44bTKRSsRg4bfbQm+h171tWbv7TVWE3/laLIklNC2C+g+f9GRBd7SOHji7U0tAOJYIkleHJ+iNOa9kL9r9Db/XpDqnkjrk9lA4cYdGfNqOF82LS6mCcaprGVnPPOrA=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4509.eurprd04.prod.outlook.com
 (2603:10a6:803:6e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.42; Tue, 6 Oct
 2020 06:09:00 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 06:09:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Thread-Topic: [PATCH net-next 4/4] enetc: Migrate to PHYLINK and PCS_LYNX
Thread-Index: AQHWmyPbsk//RQOVZ0uUHq8aKKI9qqmKGBSA
Date:   Tue, 6 Oct 2020 06:09:00 +0000
Message-ID: <20201006060859.hapkjgcv4pwzhkrv@skbuf>
References: <20201005142818.15110-1-claudiu.manoil@nxp.com>
 <20201005142818.15110-5-claudiu.manoil@nxp.com>
In-Reply-To: <20201005142818.15110-5-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9f45dec7-39f8-43c5-f988-08d869be515c
x-ms-traffictypediagnostic: VI1PR04MB4509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB450952C770E5835DFEB77A60E00D0@VI1PR04MB4509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3S142SY7JraCJguSKgilNNw3s9ZmSQLKMPgAsG8PPP8BX35QfeiqepyJ8OaXpSsvzTKSGR2xmF+sU2hejO/kDQdwtq/KpeTBgjDmXxYHatG2rDgwp8+cObWa/BABB/HnYwtoCznSC9IJxeDRPqUvYFxWC8xA5HWLLBeWp6CtCMpknLMzGompN3veFvQM0SrMQPki+emKw4syvW7jIQP4zW1w+rjVjL3dpROnUzRw00cbtQWSlxZZqCoG2jvga5tOjA+Mm8KDuE4GoKdgJQXf1TekmlVEP5L75bSjXUKfs8o2NdcUFzN3UEe6kJc3w6H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39860400002)(346002)(376002)(136003)(366004)(8676002)(6512007)(71200400001)(9686003)(44832011)(4326008)(6486002)(54906003)(316002)(33716001)(478600001)(6636002)(86362001)(6862004)(66946007)(66476007)(76116006)(83380400001)(64756008)(66446008)(66556008)(1076003)(8936002)(6506007)(186003)(5660300002)(26005)(91956017)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: y0VIuFyyxmTYCiOoV6BK0BavIKiXecxZoAJm6h85ijDp/X+A1jZQ0tdRHUxIzY8NbvOmEBdfJUqlPuBuBxMIYLkWQJ1cErIPOWDvaweWcbggsrJbPkFlv5kKaK3UptidKe+ivWuMvxu8vbhktuGy/7zxvALXZ5YglwN4JSuWbCwEkYBrk2sWREu3ddVbIFnrivkMYv+Hpe/8HoLeQElXXhqNmCa5GEYXJZs1oGqCt1Z34yL3OMgTCO0U3UXwZKq+swzqPv02pxyeMMJcybINRFq2NGCy+cF82Ol4Xj0LGl7B9SJEVZLgNZr2Os7Hk7BdL/2wBB4QE8Mijm9TaPRyUnlE+K3SDeOD3NGqRXwQEUA3Pn+cAkEQBdBz7umCmv7BB1gpCN93QEAeK0ruDZVhmEpfrlJAKu4h/L37FZcWVtt/rZOl3i+yEuvCqHI6e0snGHIcDEKST4ep15CZFYVQs9lBH65k/L7Z/cDa4kYQSlzzcvN2y2Z9qRAe7K8Q2Ignp0wXsdmYeRZMeHSxrzQ24upP+HG8WHol7QQlzVlkMVLvvAIe/o+RMVOnPUcwH4RGp/oBrVBhmjLMevl4sDrHUYbRShQtDbk8+7E8r+RY25yGkTpMQbVD0M79YKCBFPnuVOLFnuYnHAhMemfkBo125w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7515E51E80B5047A68E6F042C810D79@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f45dec7-39f8-43c5-f988-08d869be515c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 06:09:00.1736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AhQe5ynfVdMIzO4u6I6tLlw00ly0406xaVota12cR5RLBolIp6LrQoxbVg88Oxcp3SarJy7zbR4jq70/RjymLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 05:28:18PM +0300, Claudiu Manoil wrote:
> This is a methodical transition of the driver from phylib
> to phylink, following the guidelines from sfp-phylink.rst.
> The MAC register configurations based on interface mode
> were moved from the probing path to the mac_config() hook.
> MAC enable and disable commands (enabling Rx and Tx paths
> at MAC level) were also extracted and assigned to their
> corresponding phylink hooks.
> As part of the migration to phylink, the serdes configuration
> from the driver was offloaded to the PCS_LYNX module,
> introduced in commit 0da4c3d393e4 ("net: phy: add Lynx PCS module"),
> the PCS_LYNX module being a mandatory component required to
> make the enetc driver work with phylink.
>=20
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/Kconfig  |   5 +-
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  53 ++--
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   9 +-
>  .../ethernet/freescale/enetc/enetc_ethtool.c  |  26 +-
>  .../net/ethernet/freescale/enetc/enetc_pf.c   | 246 +++++++++---------
>  .../net/ethernet/freescale/enetc/enetc_pf.h   |   8 +-
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |   9 +-
>  7 files changed, 190 insertions(+), 166 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/e=
thernet/freescale/enetc/Kconfig
> index 37b804f8bd76..0fa18b00c49b 100644
> --- a/drivers/net/ethernet/freescale/enetc/Kconfig
> +++ b/drivers/net/ethernet/freescale/enetc/Kconfig

(...)

> @@ -922,61 +889,118 @@ static void enetc_mdiobus_destroy(struct enetc_pf =
*pf)
>  	enetc_imdio_remove(pf);
>  }
> =20
> -static void enetc_configure_sgmii(struct phy_device *pcs)
> +static void enetc_pl_mac_validate(struct phylink_config *config,
> +				  unsigned long *supported,
> +				  struct phylink_link_state *state)
>  {
> -	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
> -	 * for the MAC PCS in order to acknowledge the AN.
> -	 */
> -	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII | ADVERTISE_LPACK);
> +	struct enetc_pf *pf =3D phylink_to_enetc_pf(config);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> +
> +	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> +	    state->interface !=3D pf->if_mode) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> =20
> -	phy_write(pcs, ENETC_PCS_IF_MODE,
> -		  ENETC_PCS_IF_MODE_SGMII_EN |
> -		  ENETC_PCS_IF_MODE_USE_SGMII_AN);
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 1000baseT_Half);
> +	phylink_set(mask, 1000baseT_Full);
> +
> +	if (state->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL ||
> +	    state->interface =3D=3D PHY_INTERFACE_MODE_2500BASEX ||
> +	    state->interface =3D=3D PHY_INTERFACE_MODE_USXGMII) {
> +		phylink_set(mask, 2500baseT_Full);
> +		phylink_set(mask, 2500baseX_Full);
> +	}

Shouldn't the driver reject any interface mode which it does not
support? Either here in the validate callback or directly
where the pf->if_mode is set.

> =20
> -	/* Adjust link timer for SGMII */
> -	phy_write(pcs, ENETC_PCS_LINK_TIMER1, ENETC_PCS_LINK_TIMER1_VAL);
> -	phy_write(pcs, ENETC_PCS_LINK_TIMER2, ENETC_PCS_LINK_TIMER2_VAL);
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> =20

(...)

> =20
> -static void enetc_configure_serdes(struct enetc_pf *pf)
> +static const struct phylink_mac_ops enetc_mac_phylink_ops =3D {
> +	.validate =3D enetc_pl_mac_validate,
> +	.mac_config =3D enetc_pl_mac_config,
> +	.mac_link_up =3D enetc_pl_mac_link_up,
> +	.mac_link_down =3D enetc_pl_mac_link_down,
> +};
> +
> +static int enetc_phylink_create(struct enetc_ndev_priv *priv)
>  {
> -	switch (pf->if_mode) {
> -	case PHY_INTERFACE_MODE_SGMII:
> -		enetc_configure_sgmii(pf->pcs);
> -		break;
> -	case PHY_INTERFACE_MODE_2500BASEX:
> -		enetc_configure_2500basex(pf->pcs);
> -		break;
> -	case PHY_INTERFACE_MODE_USXGMII:
> -		enetc_configure_usxgmii(pf->pcs);
> -		break;
> -	default:
> -		dev_dbg(&pf->si->pdev->dev, "Unsupported link mode %s\n",
> -			phy_modes(pf->if_mode));
> +	struct enetc_pf *pf =3D enetc_si_priv(priv->si);
> +	struct device *dev =3D &pf->si->pdev->dev;
> +	struct phylink *phylink;
> +	int err;
> +
> +	pf->phylink_config.dev =3D &priv->ndev->dev;
> +	pf->phylink_config.type =3D PHYLINK_NETDEV;
> +	if (enetc_port_has_pcs(pf))
> +		pf->phylink_config.pcs_poll =3D true;
> +

There is no need for the pcs_poll to be set by the driver, the lynx PCS
module will set it up for you.

Ioana=
