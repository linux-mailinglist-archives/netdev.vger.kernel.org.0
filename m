Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01DB225CD5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgGTKoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:44:17 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:56198
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728001AbgGTKoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 06:44:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hh4JczHyde96tdy4j9bYOZaUwi9r+A1pv0JZ+Pk+9+dy2DhtK8fBYxWznE2ROSg1rTN8KUiOVl/r042q+pwYLwU+q44v4RaITJfGBqmMDJNkyE1sQTFuZxMkbYz6ezOPQJXJZqi35UefLW0i6JwLNSZwMYPetVwwxWXxL1Xv3LL5gg54oGOgrG+99ViaXQ2WfUcF6FtBTfLzHYw8iZYqEoNJnE9smnVdRSZccOq7iG5FVqtX2vPURPrI/xusOr0WdgfaBXttn8VR4tqlKGCR6ycMC3Tv5Res3uNDYcM9Fgg06V1f3yPSX/y0Nbj9j7kHUYLnTCE/XkiFSEjHyLmFIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6vM80tB93XI/SIZxi/ZevK+0YtPRH//+R07M2iiYRE=;
 b=IL9/KFRtQp4orXvEPa8ADlF1V+egOGAuaEtbUvrCstjI6mzO+ig2weOZ8jIafuoxgkOAHg7ZNTqB9Bd8pKATTfKc+SOt8yTILGtQWkLf0y0ajaOc1DPFlIlYZztGcso2gIYSrJ9VLv/LnmF+9JERwum1L0nw0O5BiQ6bI1QDNKM+15qtU4gLk2KQEQvXoXfb+tZyw0F/0GC0zyIB2HWtB3tOAnrVc3CAW7soTXqUPAozrecL8lcIs9zUkmXzwW4UMHt65PZU0tgPjmWVQP+A1yt0q/gEPH0Mw1MJjEQvJsTfjQHyupCGjdOjBX6ey/K7jTwJt+9Q7KaXqB+zM7CxUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6vM80tB93XI/SIZxi/ZevK+0YtPRH//+R07M2iiYRE=;
 b=fCC6PLuUsC9EwLwcTVGpAFUwpSjmE5UZuUSGUj1gY7+LMVyqgZWht38PWGuzqKFwhDNnsCiytlagqYnVCMAjySjicsFkrMpSijzEtUQEfDzG2sz6VuY4qR+VioS8WAqNfJh59QJZAOz3DtgQh924mkwOdpxWKf0VgD6a/cmBt6E=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3872.eurprd04.prod.outlook.com
 (2603:10a6:803:22::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 10:44:11 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 10:44:11 +0000
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
Subject: Re: [PATCH RFC net-next 08/13] net: phylink: simplify phy case for
 ksettings_set method
Thread-Topic: [PATCH RFC net-next 08/13] net: phylink: simplify phy case for
 ksettings_set method
Thread-Index: AQHWTurXe7qXBKgqTkWdlw7FB8rfsA==
Date:   Mon, 20 Jul 2020 10:44:11 +0000
Message-ID: <VI1PR0402MB387177B532EF211E65341873E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHG3-0006PX-UZ@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aafa700a-d19d-4954-8960-08d82c99d6ad
x-ms-traffictypediagnostic: VI1PR0402MB3872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB387294557A0FEC9D1530092AE07B0@VI1PR0402MB3872.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7oBJW+KJJIYiXQAsvBIGwh7KrHTtGPSNKYqdp5glpic3BPjbVcKKmj4k/Pt0righw1ISTP7hlFSwHG7zMNeWMBY6RHhQ7AsbBfP7kyWcU++c5yopEzBaVB8r7Wr3qRLvtzkg5keJi3LpgVaGz6NIUixsq9PKFxATgmYXYoOGa8Z+WnAFnFb9D5bj/1YCdcymCTppCWfVgPyXE9Z25sDaa36U1XwBf0RHIDC5FjjMcRWnRiw3WBfysyRK69FeqsWev1+vg35GWND/g0mgW44+KNcKQMpky7M/HwWqB34dlPhhAL+A3FiKJZWuufhdIApOqKQfyfzbaL6+kGhtLBSxxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(8936002)(26005)(316002)(86362001)(5660300002)(2906002)(7696005)(9686003)(186003)(71200400001)(44832011)(478600001)(4326008)(110136005)(91956017)(66556008)(66476007)(33656002)(66946007)(64756008)(76116006)(66446008)(55016002)(6506007)(54906003)(83380400001)(53546011)(8676002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Fu3JJ06Q5HBIloO83hSHKcDelsnufJLKB+3YcnAZFgmmXtcNOt3Ibo6xomYvxlXZBlkhSXv3UtXKdcgfeXtQrmgbk94sP79FyhY4/B61FZ3IQOF2UK3lMR0IxmUEEc3xrJ/DQsXU/kVt3x3DCvPvJlM1UE1Gehxn87otawF0myBVD65uosP6PEDxUkWAy2AsWj6QYJujMwpIUyL6Z7i2V0gMsz/5z1WwggHm9VBNgGalEsQ12AeeNq17RkFEjO/BOI73kxZrHCtFpmSio0Ukm+v/5HXj/WMB2j4AuZ9UUO3BS5jOxyVSPfzH9a3TaspPuw1SvCTR1p/u2jUDP7kjSs8wQaSaI+K61X/G+i+Vkg507PgR09SLUl+qJV7hrP/xHWgdfyJEw+hQ1Psn3Y5FwD2wMZ3FtCDZM2GUdXSSiaGJTAiqFn/QmkM6tEbw3TnsZJLGpOnH/wY5NYzDTcPT+DN08Ijqb4CRQAuDpbdRHicScFHFHtYe945wF5dZLWdY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aafa700a-d19d-4954-8960-08d82c99d6ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 10:44:11.5021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0UL/A7rwsQoLK8uH24p5Sd5UBN3Qp4ZVS+xnrOs4nuNgfX/rmXG402qjA5vI431Fu3GlRYSSaEKxFnfhpHGOyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 5:29 PM, Russell King wrote:=0A=
> When we have a PHY attached, an ethtool ksettings_set() call only=0A=
> really needs to call through to the phylib equivalent; phylib will=0A=
> call back to us when the link changes so we can update our state.=0A=
> Therefore, we can bypass most of our ksettings_set() call for this=0A=
> case.=0A=
> =0A=
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
=0A=
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
=0A=
> ---=0A=
>   drivers/net/phy/phylink.c | 104 +++++++++++++++++---------------------=
=0A=
>   1 file changed, 47 insertions(+), 57 deletions(-)=0A=
> =0A=
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
> index 103d2a550415..967c068d16c8 100644=0A=
> --- a/drivers/net/phy/phylink.c=0A=
> +++ b/drivers/net/phy/phylink.c=0A=
> @@ -1312,13 +1312,33 @@ int phylink_ethtool_ksettings_set(struct phylink =
*pl,=0A=
>   				  const struct ethtool_link_ksettings *kset)=0A=
>   {=0A=
>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);=0A=
> -	struct ethtool_link_ksettings our_kset;=0A=
>   	struct phylink_link_state config;=0A=
>   	const struct phy_setting *s;=0A=
> -	int ret;=0A=
>   =0A=
>   	ASSERT_RTNL();=0A=
>   =0A=
> +	if (pl->phydev) {=0A=
> +		/* We can rely on phylib for this update; we also do not need=0A=
> +		 * to update the pl->link_config settings:=0A=
> +		 * - the configuration returned via ksettings_get() will come=0A=
> +		 *   from phylib whenever a PHY is present.=0A=
> +		 * - link_config.interface will be updated by the PHY calling=0A=
> +		 *   back via phylink_phy_change() and a subsequent resolve.=0A=
> +		 * - initial link configuration for PHY mode comes from the=0A=
> +		 *   last phy state updated via phylink_phy_change().=0A=
> +		 * - other configuration changes (e.g. pause modes) are=0A=
> +		 *   performed directly via phylib.=0A=
> +		 * - if in in-band mode with a PHY, the link configuration=0A=
> +		 *   is passed on the link from the PHY, and all of=0A=
> +		 *   link_config.{speed,duplex,an_enabled,pause} are not used.=0A=
> +		 * - the only possible use would be link_config.advertising=0A=
> +		 *   pause modes when in 1000base-X mode with a PHY, but in=0A=
> +		 *   the presence of a PHY, this should not be changed as that=0A=
> +		 *   should be determined from the media side advertisement.=0A=
> +		 */=0A=
> +		return phy_ethtool_ksettings_set(pl->phydev, kset);=0A=
> +	}=0A=
> +=0A=
Also tested the PHY use case, no issue encountered with changing the =0A=
advertisements, autoneg etc=0A=
=0A=
>   	linkmode_copy(support, pl->supported);=0A=
>   	config =3D pl->link_config;=0A=
>   	config.an_enabled =3D kset->base.autoneg =3D=3D AUTONEG_ENABLE;=0A=
> @@ -1365,65 +1385,35 @@ int phylink_ethtool_ksettings_set(struct phylink =
*pl,=0A=
>   		return -EINVAL;=0A=
>   	}=0A=
>   =0A=
> -	if (pl->phydev) {=0A=
> -		/* If we have a PHY, we process the kset change via phylib.=0A=
> -		 * phylib will call our link state function if the PHY=0A=
> -		 * parameters have changed, which will trigger a resolve=0A=
> -		 * and update the MAC configuration.=0A=
> -		 */=0A=
> -		our_kset =3D *kset;=0A=
> -		linkmode_copy(our_kset.link_modes.advertising,=0A=
> -			      config.advertising);=0A=
> -		our_kset.base.speed =3D config.speed;=0A=
> -		our_kset.base.duplex =3D config.duplex;=0A=
> +	/* For a fixed link, this isn't able to change any parameters,=0A=
> +	 * which just leaves inband mode.=0A=
> +	 */=0A=
> +	if (phylink_validate(pl, support, &config))=0A=
> +		return -EINVAL;=0A=
>   =0A=
> -		ret =3D phy_ethtool_ksettings_set(pl->phydev, &our_kset);=0A=
> -		if (ret)=0A=
> -			return ret;=0A=
> +	/* If autonegotiation is enabled, we must have an advertisement */=0A=
> +	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))=
=0A=
> +		return -EINVAL;=0A=
>   =0A=
> -		mutex_lock(&pl->state_mutex);=0A=
> -		/* Save the new configuration */=0A=
> -		linkmode_copy(pl->link_config.advertising,=0A=
> -			      our_kset.link_modes.advertising);=0A=
> -		pl->link_config.interface =3D config.interface;=0A=
> -		pl->link_config.speed =3D our_kset.base.speed;=0A=
> -		pl->link_config.duplex =3D our_kset.base.duplex;=0A=
> -		pl->link_config.an_enabled =3D our_kset.base.autoneg !=3D=0A=
> -					     AUTONEG_DISABLE;=0A=
> -		mutex_unlock(&pl->state_mutex);=0A=
> -	} else {=0A=
> -		/* For a fixed link, this isn't able to change any parameters,=0A=
> -		 * which just leaves inband mode.=0A=
> +	mutex_lock(&pl->state_mutex);=0A=
> +	linkmode_copy(pl->link_config.advertising, config.advertising);=0A=
> +	pl->link_config.interface =3D config.interface;=0A=
> +	pl->link_config.speed =3D config.speed;=0A=
> +	pl->link_config.duplex =3D config.duplex;=0A=
> +	pl->link_config.an_enabled =3D kset->base.autoneg !=3D=0A=
> +				     AUTONEG_DISABLE;=0A=
=0A=
Is there a specific reason why this is not just using config.an_enabled =0A=
to sync back to pl->link_config?=0A=
=0A=
> +=0A=
> +	if (pl->cur_link_an_mode =3D=3D MLO_AN_INBAND &&=0A=
> +	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {=
=0A=
> +		/* If in 802.3z mode, this updates the advertisement.=0A=
> +		 *=0A=
> +		 * If we are in SGMII mode without a PHY, there is no=0A=
> +		 * advertisement; the only thing we have is the pause=0A=
> +		 * modes which can only come from a PHY.=0A=
>   		 */=0A=
> -		if (phylink_validate(pl, support, &config))=0A=
> -			return -EINVAL;=0A=
> -=0A=
> -		/* If autonegotiation is enabled, we must have an advertisement */=0A=
> -		if (config.an_enabled &&=0A=
> -		    phylink_is_empty_linkmode(config.advertising))=0A=
> -			return -EINVAL;=0A=
> -=0A=
> -		mutex_lock(&pl->state_mutex);=0A=
> -		linkmode_copy(pl->link_config.advertising, config.advertising);=0A=
> -		pl->link_config.interface =3D config.interface;=0A=
> -		pl->link_config.speed =3D config.speed;=0A=
> -		pl->link_config.duplex =3D config.duplex;=0A=
> -		pl->link_config.an_enabled =3D kset->base.autoneg !=3D=0A=
> -					     AUTONEG_DISABLE;=0A=
> -=0A=
> -		if (pl->cur_link_an_mode =3D=3D MLO_AN_INBAND &&=0A=
> -		    !test_bit(PHYLINK_DISABLE_STOPPED,=0A=
> -			      &pl->phylink_disable_state)) {=0A=
> -			/* If in 802.3z mode, this updates the advertisement.=0A=
> -			 *=0A=
> -			 * If we are in SGMII mode without a PHY, there is no=0A=
> -			 * advertisement; the only thing we have is the pause=0A=
> -			 * modes which can only come from a PHY.=0A=
> -			 */=0A=
> -			phylink_pcs_config(pl, true, &pl->link_config);=0A=
> -		}=0A=
> -		mutex_unlock(&pl->state_mutex);=0A=
> +		phylink_pcs_config(pl, true, &pl->link_config);=0A=
>   	}=0A=
> +	mutex_unlock(&pl->state_mutex);=0A=
>   =0A=
>   	return 0;=0A=
>   }=0A=
> =0A=
=0A=
