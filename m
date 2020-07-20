Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5D6226AEB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgGTQhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:37:48 -0400
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:39264
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730889AbgGTPvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROas/K7Lvfo9kSAy08ALe24Ap/x8L2ubyuUqFaoYBCfisbDO18C8YpHfdJ/wUYDXUIEL2H7eWXp/6hAGSqQ4qEjiTQjgFSfefvHe2biw/AgN006fvJz55bQL0GsbbEuuwkNjRQZJKUjpQRtV3cNaMXm/KAF/xtrmwy1zm2gOke2CLYTWJUijUm3gtYT23d7l5pCw/HrT0SPohbbASPG4Ee+Wtk9OwvzGcWh08FWCuv7JvqBL+Au3OhZ8VBwO5o/AH3Z+dMBvPavTi/QJFu9/XS0LKHhEGS/yf+SL/An1FcGS8fA5SeuoZ4yiumQ4XYO4ZkflWLf/R8nwPldW/rqqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyHUPZcrL+RE9jOZd+jkv0xpn39entjEtyquDtpCYiY=;
 b=VALNn2lxdM7i9juXokjL/vPUGpEHz3U9Qvb5s2esaDd6ZBwpToPY5D1+55EVBEifZ/k4iGUGDlHN18WqJx0Z3D++S8+qdvlTPmEcXGTM2SEANjS0f8haW71N2G/yOsQFPNPvVXEqxInUGxsMJHsi77oqQdlNu0/yS01uFzXsEygXAmpkDxTVNBDseWx6k/vkszc2Ht6t/IGSn9maSWl7UYpNdY9UqzXys62NR2wsYDs6jitvgovlLKI6u/5H6pY9FLdp2e7MhYY0uzUBMClTqsJc2w/CkqZcYw8m6qXN1ckWK4rpAzq4VjJCnDxCDy1WK81TIlaO8P/K3+uan8mxmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyHUPZcrL+RE9jOZd+jkv0xpn39entjEtyquDtpCYiY=;
 b=ib1rxf+XMhmtRnicL1LZQBli2o6U+J/E9k9aXSDV5R/cWj5QnUNTBQWOPBWaQXXkI8rthq2nSEwVTlHlNzT0BGRjp9IpPI50n89k9M79kgn5UaVfZSNhRZ46ZNpulOJni16SStrKFxkC4h0Su2IWHdJbp6V+9ZqsId3un0fr5Ls=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5005.eurprd04.prod.outlook.com
 (2603:10a6:803:57::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 15:50:57 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 15:50:57 +0000
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
Subject: Re: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
Thread-Topic: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
Thread-Index: AQHWTuri0oj85lgbdkeFoRazHWzWkQ==
Date:   Mon, 20 Jul 2020 15:50:57 +0000
Message-ID: <VI1PR0402MB3871010E01CD0C6BADC04520E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ee0549f-b9cc-4c5e-49ba-08d82cc4b186
x-ms-traffictypediagnostic: VI1PR04MB5005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB50055BD86ECBE3DF27244248E07B0@VI1PR04MB5005.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTrT+PvA5iewLQx1CcXIt0+RGwZ0PVHHNBA197OCMAh8LgqFSeHONVFSE5kjxn4l6fyRYGxJYu1OOs6potOBlubwKhUzm4PX2EkJzGf/XIbgfO5QXyhrdbk2gQauaCHRgOh3cMOZBlwWDEO5oJnk1w4soDHO81Fko3oWoWkM0qynWgpwKHSqhZNtC4VGcjGgbW7wa7bcPJER1HAiTN+cvcHi2OMRM8Z6FpNjlHKwcaBxMUqKTTuA6OYE9hf5qjpl6srnmTohjRxzqOIOq4wJhAjx4OPy+q9n1nLEqNyR0vZrQZt8F5f6sutYHLq86mtESN7IsX61PMh0aPwwBf+2eQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(52536014)(33656002)(5660300002)(71200400001)(8936002)(9686003)(55016002)(4326008)(8676002)(478600001)(186003)(83380400001)(53546011)(316002)(26005)(2906002)(54906003)(110136005)(44832011)(91956017)(66556008)(76116006)(66446008)(64756008)(66476007)(66946007)(7696005)(6506007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: yFR5Aoll5VByBgAC4VRXuq9H4MF1ihrIvIRV9zs+DOdg/ddC7x5RtIjed/a9hhA7kpE9TojaoCyfj99ElGX8q36+XYBPtIVaIWsgtWHhr1fVXmw3Z8nmvWthajV8MMKW+jBi83sUDwlEQqxvvxSkC/WywaJfR4kELAs3ol5PZLfKzcYM5PjH1zj/Y5Cs1PYeYrVYaoWhHHdPLlqTeNcvYFSIIpWbiPreR0cUDCq/sKMExTICwV0mf5juCxqFlsXrNqeOF0Ci4CGxS+u9v4iPwfzF2mXNaq07tQ7YpR108e6L3gaZpvcOqOj/gabT6OpgCZmK8sptDfDBKwv5K4rhMgmYwW3QnJ15YQigeX67GPUZxWBsNwWC0grryUHquG3vjIMDfAy+TB8Vhgu0RwrmFCpT06KZQBoTWWCgsyJmU9IWQOUhi9d9UA5zoIpPwARrapupMaowAVur99ggLrf/6H1b+RhDnNBObbblQPskE1E0VfoUk/Tvd/XHc1Qyiohc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee0549f-b9cc-4c5e-49ba-08d82cc4b186
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 15:50:57.5036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ooObc7iinvrgsNTMVT608ZE+rbzeYx1AaipCLokjs4+wrDDYWIyOL0ZLmzYnlCH/cREdtVSW6eXhF2W63yi/DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 5:29 PM, Russell King wrote:=0A=
> Add a way for MAC PCS to have private data while keeping independence=0A=
> from struct phylink_config, which is used for the MAC itself. We need=0A=
> this independence as we will have stand-alone code for PCS that is=0A=
> independent of the MAC.  Introduce struct phylink_pcs, which is=0A=
> designed to be embedded in a driver private data structure.=0A=
> =0A=
> This structure does not include a mdio_device as there are PCS=0A=
> implementations such as the Marvell DSA and network drivers where this=0A=
> is not necessary.=0A=
> =0A=
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
=0A=
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
=0A=
I integrated and used the phylink_pcs structure into the Lynx PCS just =0A=
to see how everything fits. Pasting below the main parts so that we can =0A=
catch early any possible different opinions on how to integrate this:=0A=
=0A=
The basic Lynx structure looks like below and the main idea is just to =0A=
encapsulate the phylink_pcs structure and the mdio device (which in some =
=0A=
other cases might not be needed).=0A=
=0A=
struct lynx_pcs {=0A=
        struct phylink_pcs pcs;=0A=
        struct mdio_device *mdio;=0A=
        phy_interface_t interface;=0A=
};=0A=
=0A=
The lynx_pcs structure is requested by the MAC driver with:=0A=
=0A=
struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)=0A=
{=0A=
(...)=0A=
        lynx_pcs->mdio =3D mdio;=0A=
        lynx_pcs->pcs.ops =3D &lynx_pcs_phylink_ops;=0A=
        lynx_pcs->pcs.poll =3D true;=0A=
=0A=
        return lynx_pcs;=0A=
}=0A=
=0A=
And then passed to phylink with something like:=0A=
=0A=
phylink_set_pcs(pl, &lynx_pcs->pcs);=0A=
=0A=
=0A=
For DSA it's a bit less straightforward because the .setup() callback =0A=
from the dsa_switch_ops is run before any phylink structure has been =0A=
created internally. For this, a new DSA helper can be created that just =0A=
stores the phylink_pcs structure per port:=0A=
=0A=
void dsa_port_phylink_set_pcs(struct dsa_switch *ds, int port,=0A=
                              struct phylink_pcs *pcs)=0A=
{=0A=
        struct dsa_port *dp =3D dsa_to_port(ds, port);=0A=
=0A=
        dp->pcs =3D pcs;                                         but I do=
=0A=
}=0A=
=0A=
and at the appropriate time, from dsa_slave_setup, it can really install =
=0A=
the phylink_pcs with phylink_set_pcs.=0A=
The other option would be to add a new dsa_switch ops that requests the =0A=
phylink_pcs for a specific port - something like phylink_get_pcs.=0A=
=0A=
Ioana=0A=
=0A=
=0A=
> ---=0A=
>   drivers/net/phy/phylink.c | 25 ++++++++++++++++------=0A=
>   include/linux/phylink.h   | 45 ++++++++++++++++++++++++++-------------=
=0A=
>   2 files changed, 48 insertions(+), 22 deletions(-)=0A=
> =0A=
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
> index a31a00fb4974..fbc8591b474b 100644=0A=
> --- a/drivers/net/phy/phylink.c=0A=
> +++ b/drivers/net/phy/phylink.c=0A=
> @@ -43,6 +43,7 @@ struct phylink {=0A=
>   	const struct phylink_mac_ops *mac_ops;=0A=
>   	const struct phylink_pcs_ops *pcs_ops;=0A=
>   	struct phylink_config *config;=0A=
> +	struct phylink_pcs *pcs;=0A=
>   	struct device *dev;=0A=
>   	unsigned int old_link_state:1;=0A=
>   =0A=
> @@ -427,7 +428,7 @@ static void phylink_mac_pcs_an_restart(struct phylink=
 *pl)=0A=
>   	    phy_interface_mode_is_8023z(pl->link_config.interface) &&=0A=
>   	    phylink_autoneg_inband(pl->cur_link_an_mode)) {=0A=
>   		if (pl->pcs_ops)=0A=
> -			pl->pcs_ops->pcs_an_restart(pl->config);=0A=
> +			pl->pcs_ops->pcs_an_restart(pl->pcs);=0A=
>   		else=0A=
>   			pl->mac_ops->mac_an_restart(pl->config);=0A=
>   	}=0A=
> @@ -453,7 +454,7 @@ static void phylink_change_interface(struct phylink *=
pl, bool restart,=0A=
>   	phylink_mac_config(pl, state);=0A=
>   =0A=
>   	if (pl->pcs_ops) {=0A=
> -		err =3D pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,=0A=
> +		err =3D pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,=0A=
>   					      state->interface,=0A=
>   					      state->advertising,=0A=
>   					      !!(pl->link_config.pause &=0A=
> @@ -533,7 +534,7 @@ static void phylink_mac_pcs_get_state(struct phylink =
*pl,=0A=
>   	state->link =3D 1;=0A=
>   =0A=
>   	if (pl->pcs_ops)=0A=
> -		pl->pcs_ops->pcs_get_state(pl->config, state);=0A=
> +		pl->pcs_ops->pcs_get_state(pl->pcs, state);=0A=
>   	else=0A=
>   		pl->mac_ops->mac_pcs_get_state(pl->config, state);=0A=
>   }=0A=
> @@ -604,7 +605,7 @@ static void phylink_link_up(struct phylink *pl,=0A=
>   	pl->cur_interface =3D link_state.interface;=0A=
>   =0A=
>   	if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)=0A=
> -		pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,=0A=
> +		pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,=0A=
>   					 pl->cur_interface,=0A=
>   					 link_state.speed, link_state.duplex);=0A=
>   =0A=
> @@ -863,11 +864,19 @@ struct phylink *phylink_create(struct phylink_confi=
g *config,=0A=
>   }=0A=
>   EXPORT_SYMBOL_GPL(phylink_create);=0A=
>   =0A=
> -void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *o=
ps)=0A=
> +/**=0A=
> + * phylink_set_pcs() - set the current PCS for phylink to use=0A=
> + * @pl: a pointer to a &struct phylink returned from phylink_create()=0A=
> + * @pcs: a pointer to the &struct phylink_pcs=0A=
> + *=0A=
> + * Bind the MAC PCS to phylink.=0A=
> + */=0A=
> +void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)=0A=
>   {=0A=
> -	pl->pcs_ops =3D ops;=0A=
> +	pl->pcs =3D pcs;=0A=
> +	pl->pcs_ops =3D pcs->ops;=0A=
>   }=0A=
> -EXPORT_SYMBOL_GPL(phylink_add_pcs);=0A=
> +EXPORT_SYMBOL_GPL(phylink_set_pcs);=0A=
>   =0A=
>   /**=0A=
>    * phylink_destroy() - cleanup and destroy the phylink instance=0A=
> @@ -1212,6 +1221,8 @@ void phylink_start(struct phylink *pl)=0A=
>   		break;=0A=
>   	case MLO_AN_INBAND:=0A=
>   		poll |=3D pl->config->pcs_poll;=0A=
> +		if (pl->pcs)=0A=
> +			poll |=3D pl->pcs->poll;=0A=
>   		break;=0A=
>   	}=0A=
>   	if (poll)=0A=
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h=0A=
> index 2f1315f32113..057f78263a46 100644=0A=
> --- a/include/linux/phylink.h=0A=
> +++ b/include/linux/phylink.h=0A=
> @@ -321,6 +321,21 @@ void mac_link_up(struct phylink_config *config, stru=
ct phy_device *phy,=0A=
>   		 int speed, int duplex, bool tx_pause, bool rx_pause);=0A=
>   #endif=0A=
>   =0A=
> +struct phylink_pcs_ops;=0A=
> +=0A=
> +/**=0A=
> + * struct phylink_pcs - PHYLINK PCS instance=0A=
> + * @ops: a pointer to the &struct phylink_pcs_ops structure=0A=
> + * @poll: poll the PCS for link changes=0A=
> + *=0A=
> + * This structure is designed to be embedded within the PCS private data=
,=0A=
> + * and will be passed between phylink and the PCS.=0A=
> + */=0A=
> +struct phylink_pcs {=0A=
> +	const struct phylink_pcs_ops *ops;=0A=
> +	bool poll;=0A=
> +};=0A=
> +=0A=
>   /**=0A=
>    * struct phylink_pcs_ops - MAC PCS operations structure.=0A=
>    * @pcs_get_state: read the current MAC PCS link state from the hardwar=
e.=0A=
> @@ -330,21 +345,21 @@ void mac_link_up(struct phylink_config *config, str=
uct phy_device *phy,=0A=
>    *               (where necessary).=0A=
>    */=0A=
>   struct phylink_pcs_ops {=0A=
> -	void (*pcs_get_state)(struct phylink_config *config,=0A=
> +	void (*pcs_get_state)(struct phylink_pcs *pcs,=0A=
>   			      struct phylink_link_state *state);=0A=
> -	int (*pcs_config)(struct phylink_config *config, unsigned int mode,=0A=
> +	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,=0A=
>   			  phy_interface_t interface,=0A=
>   			  const unsigned long *advertising,=0A=
>   			  bool permit_pause_to_mac);=0A=
> -	void (*pcs_an_restart)(struct phylink_config *config);=0A=
> -	void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,=
=0A=
> +	void (*pcs_an_restart)(struct phylink_pcs *pcs);=0A=
> +	void (*pcs_link_up)(struct phylink_pcs *pcs, unsigned int mode,=0A=
>   			    phy_interface_t interface, int speed, int duplex);=0A=
>   };=0A=
>   =0A=
>   #if 0 /* For kernel-doc purposes only. */=0A=
>   /**=0A=
>    * pcs_get_state() - Read the current inband link state from the hardwa=
re=0A=
> - * @config: a pointer to a &struct phylink_config.=0A=
> + * @pcs: a pointer to a &struct phylink_pcs.=0A=
>    * @state: a pointer to a &struct phylink_link_state.=0A=
>    *=0A=
>    * Read the current inband link state from the MAC PCS, reporting the=
=0A=
> @@ -357,12 +372,12 @@ struct phylink_pcs_ops {=0A=
>    * When present, this overrides mac_pcs_get_state() in &struct=0A=
>    * phylink_mac_ops.=0A=
>    */=0A=
> -void pcs_get_state(struct phylink_config *config,=0A=
> +void pcs_get_state(struct phylink_pcs *pcs,=0A=
>   		   struct phylink_link_state *state);=0A=
>   =0A=
>   /**=0A=
>    * pcs_config() - Configure the PCS mode and advertisement=0A=
> - * @config: a pointer to a &struct phylink_config.=0A=
> + * @pcs: a pointer to a &struct phylink_pcs.=0A=
>    * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.=0A=
>    * @interface: interface mode to be used=0A=
>    * @advertising: adertisement ethtool link mode mask=0A=
> @@ -382,21 +397,21 @@ void pcs_get_state(struct phylink_config *config,=
=0A=
>    *=0A=
>    * For most 10GBASE-R, there is no advertisement.=0A=
>    */=0A=
> -int (*pcs_config)(struct phylink_config *config, unsigned int mode,=0A=
> -		  phy_interface_t interface, const unsigned long *advertising);=0A=
> +int pcs_config(struct phylink_pcs *pcs, unsigned int mode,=0A=
> +	       phy_interface_t interface, const unsigned long *advertising);=0A=
>   =0A=
>   /**=0A=
>    * pcs_an_restart() - restart 802.3z BaseX autonegotiation=0A=
> - * @config: a pointer to a &struct phylink_config.=0A=
> + * @pcs: a pointer to a &struct phylink_pcs.=0A=
>    *=0A=
>    * When PCS ops are present, this overrides mac_an_restart() in &struct=
=0A=
>    * phylink_mac_ops.=0A=
>    */=0A=
> -void (*pcs_an_restart)(struct phylink_config *config);=0A=
> +void pcs_an_restart(struct phylink_pcs *pcs);=0A=
>   =0A=
>   /**=0A=
>    * pcs_link_up() - program the PCS for the resolved link configuration=
=0A=
> - * @config: a pointer to a &struct phylink_config.=0A=
> + * @pcs: a pointer to a &struct phylink_pcs.=0A=
>    * @mode: link autonegotiation mode=0A=
>    * @interface: link &typedef phy_interface_t mode=0A=
>    * @speed: link speed=0A=
> @@ -407,14 +422,14 @@ void (*pcs_an_restart)(struct phylink_config *confi=
g);=0A=
>    * mode without in-band AN needs to be manually configured for the link=
=0A=
>    * and duplex setting. Otherwise, this should be a no-op.=0A=
>    */=0A=
> -void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,=0A=
> -		    phy_interface_t interface, int speed, int duplex);=0A=
> +void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,=0A=
> +		 phy_interface_t interface, int speed, int duplex);=0A=
>   #endif=0A=
>   =0A=
>   struct phylink *phylink_create(struct phylink_config *, struct fwnode_h=
andle *,=0A=
>   			       phy_interface_t iface,=0A=
>   			       const struct phylink_mac_ops *mac_ops);=0A=
> -void phylink_add_pcs(struct phylink *, const struct phylink_pcs_ops *ops=
);=0A=
> +void phylink_set_pcs(struct phylink *, struct phylink_pcs *pcs);=0A=
>   void phylink_destroy(struct phylink *);=0A=
>   =0A=
>   int phylink_connect_phy(struct phylink *, struct phy_device *);=0A=
> =0A=
=0A=
