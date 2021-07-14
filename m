Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6233C8943
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhGNREd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:04:33 -0400
Received: from mail-eopbgr1400133.outbound.protection.outlook.com ([40.107.140.133]:51936
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229610AbhGNREc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 13:04:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3TJwEf9iOAC1rVB4zDDtlGnTbFZexCLElGGlBc2Tr0NidaWeb4QdkG4sN7BRW+Lu8XtebPw8oWDPP/JltL4syDvKrDCoZ11e+E9eNWDFtdWW/z/1FU1qhjG730wNAeAolSBibQ8oYcqMctSiBdlKl5XuQWgI9oWYwTN/PCWssHmVzDWCurDSduqRh/mQWWa1NNaqYipfsL/E4RJxUAqHAcGP81hlHLnA8MuKNclOJyWZzrDl7e0yGAocbMYmAZQOfkUcU94ZbyrYJFvjYKP9BHjjbAEEpBcbts18FvXwyUAexI3nJX7+qvoaeaMUejYEeCFGb5Gx0+qwdtgEJqV6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBf05wDxTPLx7OoeMMnoZ5eZFE2JAliVbrbQbpSt5Hs=;
 b=g9o1e+cs6zFAeP6jhHZ7M8KTl8d9Sea2UTVAVj4FkuxFnvimWugWIplPQ63xJvaHhV/M7Uv67AaAL6rYBsbP1buaQlDs5DstyN3kVl1nKTapVjWEkgwWobiuc0BLWaoLWQYk7Y0UBtSnYBaGCu6j3JpWmyxYO1pUh1x7H/csTzxd5Eg3FBa7XffdoKUGhLxvmylKy1VDWUBpoWOvLLoagFGlbdUEm4msrAdP1RBCjWoIfr9FmSaw9JF3+kSs7B0mNGF8Y9aZHVYRBOi3a7r4SWzzBrYmr0hoQ4O+/FSRrLIUy4V8itdJgMfZsmPeL8i88k1tAuyJqMzAqQjOhyLb7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBf05wDxTPLx7OoeMMnoZ5eZFE2JAliVbrbQbpSt5Hs=;
 b=LihMiQ7IAbDZQ+wh9vMhS3jIRgQRAsxOBF36CidJhCEm44a2bvTevatJKkD+a06RHgoOltmOGTUYySrcBIs7qYgqHOUy4p7XPE+R5e06dfVIZN7f4x3TYXV10rh17r4+jK7p7pVCF+XNPxtQEVP0IX+NW8xhYNlDA3eGltyhNO8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2801.jpnprd01.prod.outlook.com (2603:1096:603:3b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 14 Jul
 2021 17:01:35 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4331.021; Wed, 14 Jul 2021
 17:01:34 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Thread-Topic: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Thread-Index: AQHXeMAjAlRFQ0Sz3UilaOpIkkO4q6tCoagAgAAN46A=
Date:   Wed, 14 Jul 2021 17:01:34 +0000
Message-ID: <OS0PR01MB59225983D7FB35F82213911686139@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-3-biju.das.jz@bp.renesas.com> <YO8KeCg8bQPjI/a5@lunn.ch>
In-Reply-To: <YO8KeCg8bQPjI/a5@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4927768f-fa63-4751-92bf-08d946e90965
x-ms-traffictypediagnostic: OSAPR01MB2801:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2801DAA0E6837A504124EF2E86139@OSAPR01MB2801.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w9HbP8xQIO3g/f0yJXC5vMpOa82L3A4FpPFkmpnTWog1HXPb/a7FbtXPCPkkTFPAmh5s59xvUjGpn2VNaWi6+DYaKouRZGCIS5skBKfQEXgUlitvHmlyo48tVTKsohS2R1l2DRWXtTAPhvn79OqZiZKbJTE2hfnpLx2g0CkM4zxu91wbdr0How8Hu+X+qBkrqWCypuSX8MTR4eoe4P0z8RYFIg+7rlWGVpOTkzcr97TelbZg2GEiPD10JIXtjdm4Z3ktZUjqPlucHeyxP7MKxaS1p/pRcTgixFBpIrUIQfuzO0gtgsorsot7p1i/uTOizgfv/n7BaY61BhDsIyiyhVKXtdKkTknMRm8hQsPuWPl0HkmFZU5R+x6MVtegq2tXea3I8mC5NyZTHaFD2bdDlxt11hYilxvmnkzaAbSbDDuoWp9P2/tJHITSNxuYh8WnD3iEfm32I7ZEfpzu8O5br2RqJrDeolNLnLVbnNybJn4yIRfOqWA7Nf+w6K89rnhVqKm9rgkybqaU2vXdhlHQyxw5ftDfVWuFQ4e0rD612dUmWbiqny5/ud322Ya50rvrGSFBfUjhcX/6acd5NqbEOEOV7Ah6BfJdSOer+bngjL4AgopJR1Fso3AEZdlwdUevQ7WQE3wcYOkXq35ex8gPL1jma7fGJMMfpgjbOMXxCjLi4RLwNcro/tSZd0OORwB4TaCofpliOGH4K4KtRIVsDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(136003)(376002)(39850400004)(346002)(396003)(366004)(76116006)(66446008)(66946007)(64756008)(33656002)(66556008)(6506007)(122000001)(71200400001)(7416002)(66476007)(2906002)(26005)(38100700002)(4326008)(186003)(6916009)(478600001)(8936002)(8676002)(55016002)(52536014)(5660300002)(54906003)(86362001)(9686003)(107886003)(7696005)(316002)(83380400001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vFEfAwPsa3cAM5rB54jyNDYR4eNvvc0CFyjtJJTlVcaUaWfYKTE8W3QJ2ZZ/?=
 =?us-ascii?Q?qaEOJwLnhMtwIFGgXrXQ9pKERPAgdKovuP8zSu6ts/i2yIK/4bVHGIBi8V1x?=
 =?us-ascii?Q?M/89ocBUWUXpFlJ2tmNt3g3d0mk+yyDKJ4Ov2cf7q4JUxNcI5kCV/cwqEUHu?=
 =?us-ascii?Q?jzpCujLqAvfQtmSnPjYmq6dKt1nKNmi5fgDwCAa5yalQkf6nRSMmkYjek3YL?=
 =?us-ascii?Q?rNi8DEm1/aCz5GKVhWC4eJqiyftjMcZC8mAKDI3zjXf0lAaj9AvuuoMNQ8sn?=
 =?us-ascii?Q?PtQVPVG6zyY7ItH9cFlkl5FOApSFMhgcwwo6emMIMQPjMRyY9Q2xDpf9lOMv?=
 =?us-ascii?Q?S8qKLgEvIU2zNrlShOwzKuAKI95GP5l7Zq6aUEAbpFLW47eFujYxDd2Hdcen?=
 =?us-ascii?Q?GZkcFzE3eckwjEcy+nrPLleWjqvyQjFsaAEToVwuFbk9erI1mcoDvT0wzJV6?=
 =?us-ascii?Q?xvNHhElUuKQ76z3X9x/6OgMMUtJ3Q1sHkwHthYd2cJMjblYYKIja/hsP97hE?=
 =?us-ascii?Q?xIrIB3ME3THFqsPL2LXbwBizWUyeawbO97LMz/i0yTX5aJnJY7heP1eSptnQ?=
 =?us-ascii?Q?ShI9nu0UkErns5iHgsoWKSW1KjjP4xW7dBUWSMcW6Q0VBYYqIFiYbirD3em/?=
 =?us-ascii?Q?3PJYwoKrTS++IF0/w/SVRo4/b9rGUXOd40S4JKzKSSfxsXy5O2M93acS6+pq?=
 =?us-ascii?Q?OhPLJzyPhGthYPdKFefHlqqk+b7glf000dOLuiuliridil3D3BiWAJTVXgOO?=
 =?us-ascii?Q?kLC3/LumQ8cwN0TnbfjA4vaPe++xr0Qc0lxu+346MnCViyqqOI2C4bryHibG?=
 =?us-ascii?Q?sSg1s75o44np9XSrEfppmCUaywMwr3A5BQAevWzqiBq0JRU82aT7BQw3ErEX?=
 =?us-ascii?Q?XvwK1tpjR+C1NvYIo75zDrbCwdAjflebliAFsSdd7Ml3WIyQpiacpyYv+RET?=
 =?us-ascii?Q?B4jUTpa5kV1h4RiVVDY+hOoWHPNoW5D+NynY9i8ycMoVv2NKwbeXsqA+6v+L?=
 =?us-ascii?Q?VW9UNIFNyL6qF0QcSZfCOich8YVBfIipFNcdiFYFpJvhl0HPqLgq7GRD0Xk7?=
 =?us-ascii?Q?/su6OJUTTQgWpUzjYMkWWcXLuvYjpLLIBSF5E1+84HSr5nPIY+JCKslwPYRw?=
 =?us-ascii?Q?jldXByRuqP+fMkmH9jwlr2nRfh5RqAatBZuqh8xJ23r2SIk2OPgHVQ/fX3HA?=
 =?us-ascii?Q?0lbBXEvWVqvC3ij/DPys1Pqxgx0OqwoQD4Bxm1Ojfl2jFObV6QOLkotM++KM?=
 =?us-ascii?Q?tt39oLnldWYOB09D9+a3Eo1aeLWzpntYwi4bEPF0ZVA3dKVR4Mbtjm9O1hKb?=
 =?us-ascii?Q?GCAMiqZhtcpAzSW69h7glpNR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4927768f-fa63-4751-92bf-08d946e90965
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2021 17:01:34.6441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DT2SYY+KSWz8PUX31L6FmBBi9lVKaksPG9HwHtdTFMfx6Lk1fr2MATHPWCsZlj9zghhaoGRRat+K6zYCarpmKGrzduOudqnp8aDPD3mMJi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2801
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew Lunn,

Thanks for the feedback.

> Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
>=20
> > +	if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID) {
> > +		ravb_write(ndev, ravb_read(ndev, CXR31)
> > +			 | CXR31_SEL_LINK0, CXR31);
> > +	} else {
> > +		ravb_write(ndev, ravb_read(ndev, CXR31)
> > +			 & ~CXR31_SEL_LINK0, CXR31);
> > +	}
>=20
> You need to be very careful here. What value is passed to the PHY?

PHY_INTERFACE_MODE_RGMII is the value passed to PHY.

The below code is used only by R-Car3, where MAC supports internal delay.

>=20
> There is some funky code:
>=20
>        /* Fall back to legacy rgmii-*id behavior */
>         if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
>             priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID) {
>                 priv->rxcidm =3D 1;
>                 priv->rgmii_override =3D 1;
>         }
>=20
>         if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
>             priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID) {
>                 if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
>                           "phy-mode %s requires TX clock internal delay
> mode which is not supported by this hardware revision. Please update
> device tree",
>                           phy_modes(priv->phy_interface))) {
>                         priv->txcidm =3D 1;
>                         priv->rgmii_override =3D 1;
>                 }
>         }
> ...
>=20
>         iface =3D priv->rgmii_override ? PHY_INTERFACE_MODE_RGMII
>                                      : priv->phy_interface;
>         phydev =3D of_phy_connect(ndev, pn, ravb_adjust_link, 0, iface);
>=20
> So it looks like, with PHY_INTERFACE_MODE_RGMII_ID,
> PHY_INTERFACE_MODE_RGMII_TXID, PHY_INTERFACE_MODE_RGMII_RXID the PHY is
> passed PHY_INTERFACE_MODE_RGMII, with the assumption the MAC is adding th=
e
> delay. But it looks like you are only adding a delay for
> PHY_INTERFACE_MODE_RGMII_ID. So this appears wrong.

This SoC family doesn't use that code and doesn't support MAC internal dela=
y.=20
It is applicable only for R-Car Gen3 whet it sets "priv->rgmii_override"
For other SoC's it is just priv->phy_interface.

>=20
> > @@ -1082,15 +1440,23 @@ static int ravb_phy_init(struct net_device
> *ndev)
> >  		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
> >  	}
> >
> > -	/* 10BASE, Pause and Asym Pause is not supported */
> > -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> > -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> > -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
> > -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
> > +	if (priv->chip_id =3D=3D RZ_G2L) {
> > +		if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
> > +			ravb_write(ndev, ravb_read(ndev, CXR35) |
> CXR35_SEL_MODIN, CXR35);
> > +		else if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII)
> > +			ravb_write(ndev, 0x3E80000, CXR35);
>=20
> This is not obviously correct. What about the other two RGMII modes?
>=20
> > @@ -1348,6 +1741,21 @@ static const struct ethtool_ops ravb_ethtool_ops
> =3D {
> >  	.set_wol		=3D ravb_set_wol,
> >  };
> >
> > +static const struct ethtool_ops rgeth_ethtool_ops =3D {
> > +	.nway_reset		=3D phy_ethtool_nway_reset,
> > +	.get_msglevel		=3D ravb_get_msglevel,
> > +	.set_msglevel		=3D ravb_set_msglevel,
> > +	.get_link		=3D ethtool_op_get_link,
> > +	.get_strings		=3D ravb_get_strings,
> > +	.get_ethtool_stats	=3D ravb_get_ethtool_stats,
> > +	.get_sset_count		=3D ravb_get_sset_count,
> > +	.get_ringparam		=3D ravb_get_ringparam,
> > +	.set_ringparam		=3D ravb_set_ringparam,
> > +	.get_ts_info		=3D ravb_get_ts_info,
> > +	.get_link_ksettings	=3D phy_ethtool_get_link_ksettings,
> > +	.set_link_ksettings	=3D phy_ethtool_set_link_ksettings,
> > +};
>=20
> It is not obvious why you need a seperate ethtool_ops structure? Does it
> not support WOL?

Yes,WOL is supported by WAKE_PHY. As per HW manual MAGIC packet detection i=
s not supported.
OK I will add wol. Also it supports eee which we are planning to add later =
stage.


>=20

> > +static const struct net_device_ops rgeth_netdev_ops =3D {
> > +	.ndo_open               =3D ravb_open,
> > +	.ndo_stop               =3D ravb_close,
> > +	.ndo_start_xmit         =3D ravb_start_xmit,
> > +	.ndo_select_queue       =3D ravb_select_queue,
> > +	.ndo_get_stats          =3D ravb_get_stats,
> > +	.ndo_set_rx_mode        =3D ravb_set_rx_mode,
> > +	.ndo_tx_timeout         =3D ravb_tx_timeout,
> > +	.ndo_do_ioctl           =3D ravb_do_ioctl,
> > +	.ndo_validate_addr      =3D eth_validate_addr,
> > +	.ndo_set_mac_address    =3D eth_mac_addr,
> > +	.ndo_set_features       =3D rgeth_set_features,
>=20
> It seems like .ndo_set_features is the only difference. Maybe handle that
> in actual function?

OK will do.

>=20
> > @@ -1965,6 +2446,7 @@ static const struct of_device_id
> ravb_match_table[] =3D {
> >  	{ .compatible =3D "renesas,etheravb-rcar-gen2", .data =3D (void
> *)RCAR_GEN2 },
> >  	{ .compatible =3D "renesas,etheravb-r8a7795", .data =3D (void
> *)RCAR_GEN3 },
> >  	{ .compatible =3D "renesas,etheravb-rcar-gen3", .data =3D (void
> > *)RCAR_GEN3 },
> > +	{ .compatible =3D "renesas,rzg2l-gether", .data =3D (void *)RZ_G2L },
> >  	{ }
> >  };
>=20
> Please document the new compatible string in the DT binding.

OK. Will do

Thanks,
Biju
>=20
>        Andrew
