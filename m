Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C93225CF0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgGTKxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:53:01 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:60998
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbgGTKxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 06:53:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvEgbpodvKX7DLJHl1oVEZzp7asVwdgyNluaMdNkIXSabrnR97RtPqD2IzsYgM+Uw/7kBBsZ0CxAJHAgj4Hf/FPVt/woEilZre97pL3OdrRhxIGsAsN31ZhrbaGmRPXj18XCOekZTP8/ipbcPsvZv2VcWuUDR+qQuOItXAPJ4SrbGVhcbDZXxYtPnUzqHHFa1zaDDirtuDi2YgQhJx8/m9QF+MDFx7Vck1zMfTcaHh9zkk1jcMHcwPOCoxyKz4FB2nb9RnUm8JVBZ2pvgCTOMkegt92toCdEEVk76SOuZwEIybF2Fi7wSIgh00CFgFKGqu6U2VUA1Na7ra2CvTYVQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67WaJ5AUlryqJYMJcYQT6I1+Bg/UCWqUE8SSbiAcqlY=;
 b=I8MIyWd4n73v98wqioyqSu79cgsali/432p2VeKrDQwdkFjqtJ06GkeLui1A6I9tEgBoZbwtxOqnnFz08hNcjx9ZheOjTofnTS9RgaDMheXPOiV6SKtRfX6YbwajNimi10JLH3dIS8uxozpCfzEY3d8Kz5T4w7jTs8joE+qdv69Le5D8uNtYu5VOLGbsHhyse9yBCHeaNRLUOUOLxLMNLJAm9QXItMRIoePVelnFcSUdPyN3yfPvlCObcfPefyQssn0sGK+FAzzJQ5WcUsO6BJ2hls6+5qINTob+khpJLWh/q9jqY41aScZ4ShmfsZ2z36ffdyhONqIZ9taQFsNAYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67WaJ5AUlryqJYMJcYQT6I1+Bg/UCWqUE8SSbiAcqlY=;
 b=MViOBM/P2Qd6BvE0SCqR3EwykIxDfeZmEcWek2N7XONMv1FvtUpy/PwvInbJNlOwJ4r3zQbJLZK9tlW4NvNix/jpHq3+F24CqgC7psI2vqrA1XQaTL2Rt/Pdp5F8LYVTOne3VLo5N4izuA/pgP/pXT7Ae3U4WRCiDZxSvXTv8is=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5886.eurprd04.prod.outlook.com
 (2603:10a6:803:ea::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Mon, 20 Jul
 2020 10:52:57 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 10:52:57 +0000
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
Subject: Re: [PATCH RFC net-next 09/13] net: phylink: simplify fixed-link case
 for ksettings_set method
Thread-Topic: [PATCH RFC net-next 09/13] net: phylink: simplify fixed-link
 case for ksettings_set method
Thread-Index: AQHWTurYmUkrEiwZy0GOnuteczCAmw==
Date:   Mon, 20 Jul 2020 10:52:56 +0000
Message-ID: <VI1PR0402MB38719CABD380FD58CA113DC2E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHG9-0006Pj-2J@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d15d000e-9d77-4d2f-7dae-08d82c9b0fdf
x-ms-traffictypediagnostic: VI1PR04MB5886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5886E2AE8106109A686225AAE07B0@VI1PR04MB5886.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GLy201V7lm3Fym8so6kES82ZWITb6e2XSdBJ/5RB7MOovbBZXNasQyFZOyy8uskDverct5MWVONI+041uVLJmbhy/MBwRBJjsuiKQedIswYq1wKyOqjh084a27bjbx73JgXDO6psqNI5lnOPZikk6cczIvpgkt388zNA0fPC09g2vvPb6Y50mxCGUcjQz7Xsw+RYxVX38gfLTjiG66CCjObP49iO4/AJUy481wS6mL2pF6WysL7h0afJ8sCFJXhQKNbC/e203xDtIGEmpdLrHQFWPXQs7T5kD3ilF1Zk/x1RA1ZH9jETBeLN5itwULDXeG7UqsXkkvrL1H/t7+wd8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(8676002)(110136005)(66946007)(478600001)(66446008)(66556008)(71200400001)(64756008)(66476007)(8936002)(53546011)(55016002)(2906002)(4326008)(33656002)(44832011)(54906003)(9686003)(52536014)(6506007)(83380400001)(186003)(5660300002)(26005)(76116006)(7696005)(316002)(91956017)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: onvZ3kYO2pMkHI0t5RR27LwEowQ7egIv/z4OOjdeWQMyKdPFtxaj+7RkA3g5ul6uxPXC6yMPfiRwC0m1+Rvmi6anUsG9M1ly+ADhehEC1P9VByKsBzQT+ccs0Whg55tD75MmQmtYQ7AcyOYYjLR5iaZg4pMQf8HPyaIVVgqRla0OthyyBafSVSD61MIDOcniOBZdiuDYznNRgVxs8ADkZ1nsXRnl0g9Raq726AoKPQpy5uu/U6ouYGSpm4x2bTU3CiZXZse4Fg9dTJsanI0xy4h6YrsKG2PrSCzWu6qEvmroXil91ysVP7NJJhbL/FGCnQ+8gzb6kZacl+PPvrUC5oD6vfZEPgUT7POftIhTILv3dYYi4BLbpJJkDvO7KRN+HVpOMzVhfuczG6VXr/K70STP7qTnB06+9q9/L1KD4fkHFtA1si9Yi62bJPy+npR4TErqggI9DGc+XhKL735u3UD8fZe6VNEyV8AvmSufnIE1lzvcPfX8m850q479liVT
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d15d000e-9d77-4d2f-7dae-08d82c9b0fdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 10:52:56.8824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T7leVi20iyMB0JPJkGODQYh3cnkktMqz09rE2AA8bPePuPBMqKse6al1EDaYRw3K/NqBFdPf4QWksJsWZahoVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5886
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 5:29 PM, Russell King wrote:=0A=
> For fixed links, we only allow the current settings, so this should be=0A=
> a matter of merely rejecting an attempt to change the settings.  If the=
=0A=
> settings agree, then there is nothing more we need to do.=0A=
> =0A=
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
=0A=
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
=0A=
> ---=0A=
>   drivers/net/phy/phylink.c | 31 ++++++++++++++++++++-----------=0A=
>   1 file changed, 20 insertions(+), 11 deletions(-)=0A=
> =0A=
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
> index 967c068d16c8..b91151062cdc 100644=0A=
> --- a/drivers/net/phy/phylink.c=0A=
> +++ b/drivers/net/phy/phylink.c=0A=
> @@ -1360,22 +1360,31 @@ int phylink_ethtool_ksettings_set(struct phylink =
*pl,=0A=
>   		if (!s)=0A=
>   			return -EINVAL;=0A=
>   =0A=
> -		/* If we have a fixed link (as specified by firmware), refuse=0A=
> -		 * to change link parameters.=0A=
> +		/* If we have a fixed link, refuse to change link parameters.=0A=
> +		 * If the link parameters match, accept them but do nothing.=0A=
>   		 */=0A=
> -		if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED &&=0A=
> -		    (s->speed !=3D pl->link_config.speed ||=0A=
> -		     s->duplex !=3D pl->link_config.duplex))=0A=
> -			return -EINVAL;=0A=
> +		if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED) {=0A=
> +			if (s->speed !=3D pl->link_config.speed ||=0A=
> +			    s->duplex !=3D pl->link_config.duplex)=0A=
> +				return -EINVAL;=0A=
> +			return 0;=0A=
> +		}=0A=
>   =0A=
>   		config.speed =3D s->speed;=0A=
>   		config.duplex =3D s->duplex;=0A=
>   		break;=0A=
>   =0A=
>   	case AUTONEG_ENABLE:=0A=
> -		/* If we have a fixed link, refuse to enable autonegotiation */=0A=
> -		if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED)=0A=
> -			return -EINVAL;=0A=
> +		/* If we have a fixed link, allow autonegotiation (since that=0A=
> +		 * is our default case) but do not allow the advertisement to=0A=
> +		 * be changed. If the advertisement matches, simply return.=0A=
> +		 */=0A=
> +		if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED) {=0A=
> +			if (!linkmode_equal(config.advertising,=0A=
> +					    pl->link_config.advertising))=0A=
> +				return -EINVAL;=0A=
> +			return 0;=0A=
> +		}=0A=
>   =0A=
>   		config.speed =3D SPEED_UNKNOWN;=0A=
>   		config.duplex =3D DUPLEX_UNKNOWN;=0A=
> @@ -1385,8 +1394,8 @@ int phylink_ethtool_ksettings_set(struct phylink *p=
l,=0A=
>   		return -EINVAL;=0A=
>   	}=0A=
>   =0A=
> -	/* For a fixed link, this isn't able to change any parameters,=0A=
> -	 * which just leaves inband mode.=0A=
> +	/* We have ruled out the case with a PHY attached, and the=0A=
> +	 * fixed-link cases.  All that is left are in-band links.=0A=
>   	 */=0A=
>   	if (phylink_validate(pl, support, &config))=0A=
>   		return -EINVAL;=0A=
> =0A=
=0A=
