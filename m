Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D229DCEB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgJ2AdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:33:23 -0400
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:62784
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730465AbgJ1WVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:21:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ey0PmBG1BPYplVB26M0Ws6Ml/xQHC49l4zua5DlJLvXKT2N6afIi0lVAFILI26dJifNkU72nfWrb5SLuN+SYw6sn5cmGe5s5itXFRRZyR3zLz2FrJVhUEXSTOiA+1orMRdveM4z6FIeJLL9mntFUDcQACIXKmAe8KwbrFyqszuXF9QibAjih6gOzGexNttowEvovF/YlEfcOo3Atsxj3chWRREWCImEfUc+LfLtP/k0BoaoBDqAR6HHn46BL+N20F/+d4MDVItQp0cBOPFCoWf8Xw7KzNXH/ngticddPmMABoCj2BLLGxJRyfUekFqv0kVRqNAnuGW+BcQhh89st0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXb+YpG1hb3ieegPs9RkAwvQtX6e7wfh2Do+Ep8/co4=;
 b=Jg6gvYXTTMS7ayhbYYKjyJqzpbHlnjikd+xXpwhHAXcVIj3g2X/jvN1uRbke/Fqh5Vm+3uhUPvggbRlFd0Kot+nhys8DGoTqGQAErMjr9qd6iOqrUFDJ/DRMTTCF+3vt5O3CbJBLr4FT8WhQ50xpQvuEKwnabRu1KlUlOcyZTpi6AyIooIJPM+m7dLWB2M/Tn+60AdSdkgQ0YGPBRYo1woiqEctw7eUxecUKV62ssCJ4l7LQSuoexLdgJshj90eQlz3Kj4rBR7OSVY2TP8k5V6eiVSYWQXT5MJWAQXW9MQS16IkeQ/xWJVfVcfE6XMc7VHigbKzrZ/zy/y1Rph0rRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXb+YpG1hb3ieegPs9RkAwvQtX6e7wfh2Do+Ep8/co4=;
 b=GdQ/yno6GAyFNNPnDbjegibONuwkwL3WNIwa+YBZDWaZDgAPxCMXUv97tu4/HVuW8cwph5Z1UsK0Mefr3Waaq+cINB8qnhh2txyqOxPbi6vo/Wqla4CE6MMAW0wJzPXd+Ne75q7txPPQwXVo15PX/z0RiCDE9j9vz8H0RUa9+Dw=
Received: from SN6PR02MB5646.namprd02.prod.outlook.com (2603:10b6:805:ed::20)
 by SN6PR02MB5295.namprd02.prod.outlook.com (2603:10b6:805:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 28 Oct
 2020 17:49:40 +0000
Received: from SN6PR02MB5646.namprd02.prod.outlook.com
 ([fe80::3d34:15b:db84:401]) by SN6PR02MB5646.namprd02.prod.outlook.com
 ([fe80::3d34:15b:db84:401%7]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 17:49:39 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Michal Simek <michals@xilinx.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v3] net: axienet: Properly handle PCS/PMA PHY for
 1000BaseX mode
Thread-Topic: [PATCH net-next v3] net: axienet: Properly handle PCS/PMA PHY
 for 1000BaseX mode
Thread-Index: AQHWrU3ap0yo6rOgmk+ywdOyHbF31KmtSnsQ
Date:   Wed, 28 Oct 2020 17:49:39 +0000
Message-ID: <SN6PR02MB56460D7AACA73840DF048A8CC7170@SN6PR02MB5646.namprd02.prod.outlook.com>
References: <20201028171429.1699922-1-robert.hancock@calian.com>
In-Reply-To: <20201028171429.1699922-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: calian.com; dkim=none (message not signed)
 header.d=none;calian.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [47.9.101.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d033d27-8e9c-4cbc-fcca-08d87b69d7c1
x-ms-traffictypediagnostic: SN6PR02MB5295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR02MB5295FD58D9DDF6FE96F15E3FC7170@SN6PR02MB5295.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WYMCzCWuH+rYLCkweM76O7oLxpk3Wk8HYpD147uD5Zi9u8u3fUknRycQMxQiPzHshsIURt6joNGC/f4gRUm0mPak0+thyOzFq5no5pxTWy6dRLjDMN+3GgLuQe5/Sz6Wy7GSQGpWZslxsWDd01xcmU3m4GRG92yq64yO+62iT1DUEpkpjl5pLu6TBd7Lz9pWQy2yldkdPxn1KahouDASTzwzq5Fi02EVyxh7HhmMOfcmjmHNYJbXmQ/njz/QHJ9gllzQ7+F4yixMCl5PtPty5r5NM/0S2kqZoM3kHQsakzmSdT8XVtAYmf30jWXBXDZDdwuj64kpOAAx0uqFY/xQ6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR02MB5646.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(54906003)(26005)(110136005)(52536014)(316002)(186003)(76116006)(66476007)(64756008)(66946007)(66556008)(33656002)(5660300002)(55016002)(66446008)(2906002)(8936002)(83380400001)(86362001)(7696005)(478600001)(71200400001)(9686003)(4326008)(53546011)(6506007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: w5D/ecMUR8eQXyQImZDiaCR65DXAZLf8yyxRN55wMsx60z3elEyCQ3WK1BaqzouM4hF7USVSj2r/kyJ/rTFdbCxgInJrdSb2ZgloZHdsQPOKCzRN6hvnWY/q1hsSimwKc3i4RTENc1HS989bP9Y4VgLcoORMNggnikS1DQ3VEkGn2ttEZZXwyqaheNi9DQNi6K2NGxXrqU56vYWtjlfL90APgJMWjpRNCRBihzuW+S8+bbZZQ0smFhzRdNNwPpJQuoa9bRhxUA5PDJSJJ5KK/WWion9lYei4gXw/NfA0tpcwpB6mA3xO5IQrrD1xO4yHFmAl9iUGrzct8dl1pD45zpz0d8iRdx/STPoDFKl4sLWbtYvxBGz9SbEfXaADWgYNWzHn1IGZGoiscjhX70UMElxVHkaV22TMwxNfpoANxjpfradFHhRdcuZH7k58E8RsgScE2uNZ5qkXzZT4X8AKujU/Ul16r2sHFCWIFuC88zFRNdESQKtwK/8rJmt/sZcCntfbeA4XUKK+aDvykHmg6EsYMOYrJPutfnr/jnIdnf1T3EzlghZTnjhhXAZdievzvtTbc4QCQnQvGPMMek2iggdneIh7F48JEOBGTix93Dxz3gfnf4N+igf+rXyCMssbc+VVEIrm5vnClLvluqXkxA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB5646.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d033d27-8e9c-4cbc-fcca-08d87b69d7c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 17:49:39.3053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XuHTPrzDWtoyVQAeRpp40LNCYd9fa+9ateiQ3kcOi+Uqa7FvdFFfAG+5XA5dlJiEdt9tOKFljs1kegTqyutH+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Wednesday, October 28, 2020 10:44 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org
> Cc: Michal Simek <michals@xilinx.com>; linux@armlinux.org.uk;
> andrew@lunn.ch; netdev@vger.kernel.org; Robert Hancock
> <robert.hancock@calian.com>
> Subject: [PATCH net-next v3] net: axienet: Properly handle PCS/PMA PHY fo=
r
> 1000BaseX mode
>=20
> Update the axienet driver to properly support the Xilinx PCS/PMA PHY
> component which is used for 1000BaseX and SGMII modes, including
> properly configuring the auto-negotiation mode of the PHY and reading the
> negotiated state from the PHY.
>=20
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Thanks!

> ---
>=20
> Changed since v2: Removed some duplicate code in axienet_validate using
> fallthrough.
>=20
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  |  3 +
> .../net/ethernet/xilinx/xilinx_axienet_main.c | 94 ++++++++++++++-----
>  2 files changed, 71 insertions(+), 26 deletions(-)
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
> index 9aafd3ecdaa4..529c167cd5a6 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1517,10 +1517,27 @@ static void axienet_validate(struct
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
> +		fallthrough;
> +	case PHY_INTERFACE_MODE_MII:
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 10baseT_Full);
> +	default:
> +		break;
> +	}
>=20
>  	bitmap_and(supported, supported, mask,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> @@ -1533,38 +1550,46 @@ static void axienet_mac_pcs_get_state(struct
> phylink_config *config,  {
>  	struct net_device *ndev =3D to_net_dev(config->dev);
>  	struct axienet_local *lp =3D netdev_priv(ndev);
> -	u32 emmc_reg, fcc_reg;
> -
> -	state->interface =3D lp->phy_mode;
> -
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
>=20
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
>  static void axienet_mac_an_restart(struct phylink_config *config)  {
> -	/* Unsupported, do nothing */
> +	struct net_device *ndev =3D to_net_dev(config->dev);
> +	struct axienet_local *lp =3D netdev_priv(ndev);
> +
> +	phylink_mii_c22_pcs_an_restart(lp->pcs_phy);
>  }
>=20
>  static void axienet_mac_config(struct phylink_config *config, unsigned i=
nt
> mode,
>  			       const struct phylink_link_state *state)  {
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
>  static void axienet_mac_link_down(struct phylink_config *config, @@ -
> 1999,6 +2024,20 @@ static int axienet_probe(struct platform_device *pdev)
>  			dev_warn(&pdev->dev,
>  				 "error registering MDIO bus: %d\n", ret);
>  	}
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
> +			goto free_netdev;
> +		}
> +		lp->phylink_config.pcs_poll =3D true;
> +	}
>=20
>  	lp->phylink_config.dev =3D &ndev->dev;
>  	lp->phylink_config.type =3D PHYLINK_NETDEV; @@ -2036,6 +2075,9
> @@ static int axienet_remove(struct platform_device *pdev)
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

