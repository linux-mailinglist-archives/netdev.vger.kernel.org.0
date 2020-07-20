Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29114225C95
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgGTKYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:24:53 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:18304
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728001AbgGTKYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 06:24:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThRvkM9GtnvWpvE9qOtCc6AnPPHGcLFXNW7VF6hVFbzKiCE2A+PYLgyLBG4+wj92wiUWr4T991mZ79mGVVp1IVSmtND0PcqIrItFFVo0kMYkoCQhnhVzSgsaQ0xdtXNNqUblCs4H8PlkmrZQi4B+3UxfNoeC+JUu0cpsOoxQSvr/jMc348ccdGR+Np1Loc64Cm0NYuRjNtKIlnc1zajg9KYXx2NvikK5iwfyxfWwOfCVipjuFTxG2EYOBDRKiWj1h5WJg2o5p3E+60xQRdur02aWdLNfuxl2sObG6BezwMQFWA6EDBBcRhGY78zfKagvxzS7hw0a+xu1MV4o3LpoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbSFW5jdGRWjGJOi8ykjKnE40Z3/h2z+DlveN7yAEvc=;
 b=j0cUlQQqQd/OAaw6SQrhxMYxGG+Ezt72ZcPhe+S8fhzOMQ3o2FKCyWA4dZd126+tA+X5QUPOIHV10ATfMVIwsjHLXN7V0N1lIb33B4uko71QKKCuQDX44jpIt+Ov0Te2ARCWxUSRPDD1zTvP9oWNhMQLzmcAlIefCPfWDWKnciuAhlc/ljK+jMPzLLTTsWly1z7k8kF3XZSgeCBF9/DKWRqwWLqaj7+/wz2fctzODv5gTL/rCsSuNXLw1MlQmGbLipd/jq6/ISRZfpfpCF+3COlsDYd66tO2a3oMVm7NQBRw5S140P8O6f6Nx3OtxefPtYcoXg33LXEuMwNgtZZmPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbSFW5jdGRWjGJOi8ykjKnE40Z3/h2z+DlveN7yAEvc=;
 b=rWvOWLSg62POZcuC3iSjHHZH4a5TqKzYLABJW4012JEuug3Yx22Vg8GLjk15iGXI4hr/UdJ8B4jTgJhh0FdkiJqfbzqOQUp9MiKZNTsw24z7yxNmriUVlH7QY93uksWyDbRTy3RL4ZZ6ogQFAmO7vgkU7YJuyGPqBX9ssCRPQNM=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4575.eurprd04.prod.outlook.com
 (2603:10a6:803:6b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Mon, 20 Jul
 2020 10:24:49 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 10:24:49 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 07/13] net: phylink: simplify ksettings_set()
 implementation
Thread-Topic: [PATCH RFC net-next 07/13] net: phylink: simplify
 ksettings_set() implementation
Thread-Index: AQHWTurTrXDuddPqJkCjV+8Whq/gbQ==
Date:   Mon, 20 Jul 2020 10:24:49 +0000
Message-ID: <VI1PR0402MB3871B35587375E9EFE155611E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHFy-0006PK-Qd@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a57382a-8a39-47b1-36fc-08d82c9721d1
x-ms-traffictypediagnostic: VI1PR04MB4575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB45754165E4E3414B0B777183E07B0@VI1PR04MB4575.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fhBigBHPK+/PZcWnlcE5a/Z82ImrXBy4WpZMITLXYBAbxSb0gVX2sFinDcUmFwOg9u6D/SB3dZJietEu1c49DRf8naXG2LVMPOmqJoZ59HIzMm9mMNaH9j6yMLZmti2kgHWe4CERRdDdPn79faZXpOcGfOcqww+Qd7Bg0yVnS88D9UIA2NeRnMbzf6W/rDi7KBOEr+7aquCuz/YJEz451+dqK3/a+3NnZkVfGKBFonaeNxh1BzJ+NOiFpVtVxTG8NTRIjlDd8+cR/93L3T9Okduf4TTL2ppx8KQvuWDI+pyrxFlnkM995zCSw7uuJrYzyI+0Gf3QO4pVKkWWILeheA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(8676002)(66946007)(316002)(76116006)(66446008)(83380400001)(66556008)(33656002)(91956017)(52536014)(66476007)(64756008)(110136005)(2906002)(5660300002)(4326008)(8936002)(9686003)(53546011)(55016002)(54906003)(6506007)(7696005)(26005)(44832011)(186003)(86362001)(71200400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wiUq5HC3JSEJUAwWpbPIuvHDb1iA5oAZSFeHclvTGUcb1/ZTcqeXY8SSxeEQ+TtJ5BWwhiS4f8NPMmW3vsvgx2Dss5Fp7srPmYcj46ge0UhbKcDNwlXGvN/kLmX5W1k91p3J3ugOfb4RWJjH6YdtXW36a6nrjaMeW2zS0WfgQ1PJbN9kIYanbZ2vYQT7lh9mFGe1XmzGeh0ju7ZXVt7xGv8jmj9MsLJadfQGyHHir/Pjyu4vQRNtNAyiPhtVkAq21Syfbv+SjlBa5JBnPTiPlvnEwAE2Bc8kGIBlwuCB3iHUMtqrmJB9kir2vA73F8o1yP/kMYBv2RHp/G++kgHFaxsOOQtfE1rjuTxoiaJfSX0FEhfF8Edic+JUsUPn/BFnbAgZy9J/sDcBCzNgpadoWnrMqmwBg2XQ9xBx5c/1IdwmHfu4NhjH5BET5Sz0vdc30VlzkSPZ8KdWcUfCygYYjnODQKSdBwlA9Yhem6P48si0N7oQQ39ywkEIiBefRft0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a57382a-8a39-47b1-36fc-08d82c9721d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 10:24:49.0589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RT5Bn5P9kWqtTpbpU39eFq6jhkNuHS8oG3mUtefh3+/2Hi8x74B0fu1s04TFP8MFzKeACKlMEnMTlQZqO4sdhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4575
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 5:29 PM, Russell King wrote:=0A=
> Simplify the ksettings_set() implementation to look more like phylib's=0A=
> implementation; use a switch() for validating the autoneg setting, and=0A=
> use the linkmode_modify() helper to set the autoneg bit in the=0A=
> advertisement mask.=0A=
> =0A=
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
=0A=
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
=0A=
> ---=0A=
>   drivers/net/phy/phylink.c | 25 ++++++++++++-------------=0A=
>   1 file changed, 12 insertions(+), 13 deletions(-)=0A=
> =0A=
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
> index 424a927d7889..103d2a550415 100644=0A=
> --- a/drivers/net/phy/phylink.c=0A=
> +++ b/drivers/net/phy/phylink.c=0A=
> @@ -1314,25 +1314,24 @@ int phylink_ethtool_ksettings_set(struct phylink =
*pl,=0A=
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);=0A=
>   	struct ethtool_link_ksettings our_kset;=0A=
>   	struct phylink_link_state config;=0A=
> +	const struct phy_setting *s;=0A=
>   	int ret;=0A=
>   =0A=
>   	ASSERT_RTNL();=0A=
>   =0A=
> -	if (kset->base.autoneg !=3D AUTONEG_DISABLE &&=0A=
> -	    kset->base.autoneg !=3D AUTONEG_ENABLE)=0A=
> -		return -EINVAL;=0A=
> -=0A=
>   	linkmode_copy(support, pl->supported);=0A=
>   	config =3D pl->link_config;=0A=
> +	config.an_enabled =3D kset->base.autoneg =3D=3D AUTONEG_ENABLE;=0A=
>   =0A=
> -	/* Mask out unsupported advertisements */=0A=
> +	/* Mask out unsupported advertisements, and force the autoneg bit */=0A=
>   	linkmode_and(config.advertising, kset->link_modes.advertising,=0A=
>   		     support);=0A=
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising,=0A=
> +			 config.an_enabled);=0A=
>   =0A=
>   	/* FIXME: should we reject autoneg if phy/mac does not support it? */=
=0A=
> -	if (kset->base.autoneg =3D=3D AUTONEG_DISABLE) {=0A=
> -		const struct phy_setting *s;=0A=
> -=0A=
> +	switch (kset->base.autoneg) {=0A=
> +	case AUTONEG_DISABLE:=0A=
>   		/* Autonegotiation disabled, select a suitable speed and=0A=
>   		 * duplex.=0A=
>   		 */=0A=
> @@ -1351,19 +1350,19 @@ int phylink_ethtool_ksettings_set(struct phylink =
*pl,=0A=
>   =0A=
>   		config.speed =3D s->speed;=0A=
>   		config.duplex =3D s->duplex;=0A=
> -		config.an_enabled =3D false;=0A=
> +		break;=0A=
>   =0A=
> -		__clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);=0A=
> -	} else {=0A=
> +	case AUTONEG_ENABLE:=0A=
>   		/* If we have a fixed link, refuse to enable autonegotiation */=0A=
>   		if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED)=0A=
>   			return -EINVAL;=0A=
>   =0A=
>   		config.speed =3D SPEED_UNKNOWN;=0A=
>   		config.duplex =3D DUPLEX_UNKNOWN;=0A=
> -		config.an_enabled =3D true;=0A=
> +		break;=0A=
>   =0A=
> -		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising);=0A=
> +	default:=0A=
> +		return -EINVAL;=0A=
>   	}=0A=
>   =0A=
>   	if (pl->phydev) {=0A=
> =0A=
=0A=
