Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF22225D94
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgGTLku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:40:50 -0400
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:15588
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728553AbgGTLkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 07:40:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxob5XsZuRcEpgIjHuCl/Wm6V03iZe7GXCHeS4KmV8Ct1s5O241bCy8faLpC/chTrmu5KWP6mktmfQ3mLUeod7mjL3SnSh0PEX3kERCAiS8Xa/NHpDJkYQPQnIuWw/f1tmZgPNGxt+m/J9v3VZiwrczxEajdK0gPL8ksp8e4mGFe6x/gI8GXpBbqodLqY14QuvUM1rTucyDY7KkdXTAndJLf07CNCdW+j6ZB3fK/kIVmxu6ybD/7YPB7y2R1LjhqDJt7+dzU62bqwzzv1pFEevQoLUxNujR99g/vTO01CIeefD9bfK9wAlp0v6+nVMO67kqgClFJIVMxnpNBnCMiHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te7o+oC0vTClWwsQJ+CBd2+D8qqVUME721XNvoUQ2Qg=;
 b=cXVsi6HuMZ5LUSjLRWsBZ+L6+h8Cp+TkW3s+1cIQ8nVNLf4p9cY3oCvktXACWheUAcaHCY7Kowqqs0cGWvUABBqThCvHev7HTFCoQZfWAOp74VzQEk9a7l/dHEjRzO/x7p7J6rZKLqBRHxX4QW+PKXWWQxb5AWD8uWxHUxvRolA73f65DcswA9l0Ty+SIIG7//EVI2X4gNeGd+gFjtwfOb2vYUnhAKq0aWanfR90I6ifhZIxyyc4ELIGx74RunDUajofRtSquq9BV6zhv0cwQQ3T0v7Ht2hLcK+zwKaNt/ALo07H1Jn6rYcjeV2o3CirG2BBhECqee50v4EOY6/ZIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te7o+oC0vTClWwsQJ+CBd2+D8qqVUME721XNvoUQ2Qg=;
 b=Wfs5wG1hvBUay+/Vvs/T2NnS07uBrqUCPOPCUp/72U5E6ijSc7Q5xTKnAIdyr0LJomRkesQz0umlFbVKqPOC8lTN7c+mgL4GfiYr8/Fkrp5q4d+8/bxKH+tybdE4dgXHWcWeW06z3+Zm1cSmYG60E/0fC1Z4ZxgQwJ6YHOdlT+o=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4766.eurprd04.prod.outlook.com
 (2603:10a6:803:55::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Mon, 20 Jul
 2020 11:40:44 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 11:40:44 +0000
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
Subject: Re: [PATCH RFC net-next 11/13] net: phylink: re-implement interface
 configuration with PCS
Thread-Topic: [PATCH RFC net-next 11/13] net: phylink: re-implement interface
 configuration with PCS
Thread-Index: AQHWTurffmUZwd98306xAi8yZ2DQag==
Date:   Mon, 20 Jul 2020 11:40:44 +0000
Message-ID: <VI1PR0402MB387151248ABD93EAA9C2E454E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGJ-0006QA-E2@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eaac0bd9-6d5f-4567-d85c-08d82ca1bcd0
x-ms-traffictypediagnostic: VI1PR04MB4766:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB47661B253A3EA991E4E52C04E07B0@VI1PR04MB4766.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmTAjvDWGXii7B4I1sB/0zn+/tgEKf7pgbRGbBOHgpj4fi8iyVZo05xEYs1hmXjkTnk/XQvYrqn9HXO3DdlXS7Poma1MI20XDZUEiwrOzHIZhl8uJaq7fWAavumfeJ+z+IAQf5TVTllxhFKUfQaJccFp0nwZPFVrvdL1TyRLwoSoVWha65gnEZ1WfZ97unXwwug5Ck7a7DH3tKdjSll18tESpuqzN2W721/xoD0DGnAnsN4lmAraI38FsJxWBRUvw/Wyuei4oMFhRAOh0uSUqbcaW5UyYpBYtTHm5SlaiQmeUD8kQmmslZ/KB1h7LLWU4HZxKu5w/4ZA8jVd0nWUoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(33656002)(83380400001)(5660300002)(8676002)(6506007)(53546011)(55016002)(7696005)(8936002)(86362001)(478600001)(44832011)(316002)(110136005)(186003)(9686003)(4326008)(71200400001)(54906003)(66946007)(52536014)(76116006)(91956017)(66446008)(64756008)(66556008)(66476007)(26005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: X1aLLDqdQqqBygk+ms/n7JRj9TuFzITShCoBHESBCFp6GDCd4SpL5C6LR4Gy/0maigLJ85OK87cnJcmGldAI9qJoUD937ZKFAPIngr4Bj8a+up6SPtw1Ci002aQTEplRbtGvbS2Yc7CI3dx7hkYCbzq6r9vwY/U6C5y+flOd0SmrRo6MnyNxTde2tFznJ5ifha8zHuj1yFdygi9Wn72I2n9d79XEss0YTkwkv6Y6L5WxNZgF3R0jNnOZlWh0POvm98O2YElokBFsmgwXRYbSCpqt0zq6YT50m3ishSpEaJKMmVefhjlJEjKlqMV8EjKUAy9BGNe50amSmRtdg3m8IMrwbat6SsdHbQsJ+ge0WxZhevksgXwoiQ2fLjPn9sHPArxcwWVncj+aLu1mop0LD8W3Jb8/8KbeGdo4MfKKuGrhaCizLr3vhhqqM7z4JRoKR/qQpkzn31xlLYDbLIUmRLAf3MWWUsz+iMUwLFQCQ7lCMK74HVHq7VdKnVPyzAtM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaac0bd9-6d5f-4567-d85c-08d82ca1bcd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 11:40:44.0926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i5fsxMCpeRh/VfFb6H0GyO9/ewZDfnyGyIwlKTQhCXA7mSZxLF3oUKjE/2N8+oRiMJhDQ1sgtdvbEIj+s+R0Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4766
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 5:29 PM, Russell King wrote:=0A=
> With PCS support, how we implement interface reconfiguration is not up=0A=
> to the job; we end up reconfiguring the PCS for an interface change=0A=
> while the link could potentially be up.  In order to solve this, add=0A=
> two additional MAC methods for interface configuration, one to prepare=0A=
> for the change, and one to finish the change.=0A=
> =0A=
> This allows mvneta and mvpp2 to shutdown what they require prior to the=
=0A=
> MAC and PCS configuration calls, and then restart as appropriate.=0A=
> =0A=
> This impacts ksettings_set(), which now needs to identify whether the=0A=
> change is a minor tweak to the advertisement masks or whether the=0A=
> interface mode has changed, and call the appropriate function for that=0A=
> update.=0A=
> =0A=
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
> ---=0A=
>   drivers/net/phy/phylink.c | 80 ++++++++++++++++++++++++++-------------=
=0A=
>   include/linux/phylink.h   | 48 +++++++++++++++++++++++=0A=
>   2 files changed, 102 insertions(+), 26 deletions(-)=0A=
> =0A=
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
> index 09f4aeef15c7..a31a00fb4974 100644=0A=
> --- a/drivers/net/phy/phylink.c=0A=
> +++ b/drivers/net/phy/phylink.c=0A=
> @@ -433,23 +433,47 @@ static void phylink_mac_pcs_an_restart(struct phyli=
nk *pl)=0A=
>   	}=0A=
>   }=0A=
>   =0A=
> -static void phylink_pcs_config(struct phylink *pl, bool force_restart,=
=0A=
> -			       const struct phylink_link_state *state)=0A=
> +static void phylink_change_interface(struct phylink *pl, bool restart,=
=0A=
> +				     const struct phylink_link_state *state)=0A=
>   {=0A=
> -	bool restart =3D force_restart;=0A=
> +	int err;=0A=
> +=0A=
> +	phylink_dbg(pl, "change interface %s\n", phy_modes(state->interface));=
=0A=
>   =0A=
> -	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,=0A=
> -						   pl->cur_link_an_mode,=0A=
> -						   state->interface,=0A=
> -						   state->advertising,=0A=
> -						   !!(pl->link_config.pause &=0A=
> -						      MLO_PAUSE_AN)))=0A=
> -		restart =3D true;=0A=
> +	if (pl->mac_ops->mac_prepare) {=0A=
> +		err =3D pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,=0A=
> +					       state->interface);=0A=
> +		if (err < 0) {=0A=
> +			phylink_err(pl, "mac_prepare failed: %pe\n",=0A=
> +				    ERR_PTR(err));=0A=
> +			return;=0A=
> +		}=0A=
> +	}=0A=
>   =0A=
>   	phylink_mac_config(pl, state);=0A=
>   =0A=
> +	if (pl->pcs_ops) {=0A=
> +		err =3D pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,=0A=
> +					      state->interface,=0A=
> +					      state->advertising,=0A=
> +					      !!(pl->link_config.pause &=0A=
> +						 MLO_PAUSE_AN));=0A=
> +		if (err < 0)=0A=
> +			phylink_err(pl, "pcs_config failed: %pe\n",=0A=
> +				    ERR_PTR(err));=0A=
> +		if (err > 0)=0A=
> +			restart =3D true;=0A=
> +	}=0A=
>   	if (restart)=0A=
>   		phylink_mac_pcs_an_restart(pl);=0A=
> +=0A=
> +	if (pl->mac_ops->mac_finish) {=0A=
> +		err =3D pl->mac_ops->mac_finish(pl->config, pl->cur_link_an_mode,=0A=
> +					      state->interface);=0A=
> +		if (err < 0)=0A=
> +			phylink_err(pl, "mac_prepare failed: %pe\n",=0A=
> +				    ERR_PTR(err));=0A=
> +	}=0A=
>   }=0A=
>   =0A=
>   /*=0A=
> @@ -555,7 +579,7 @@ static void phylink_mac_initial_config(struct phylink=
 *pl, bool force_restart)=0A=
>   	link_state.link =3D false;=0A=
>   =0A=
>   	phylink_apply_manual_flow(pl, &link_state);=0A=
> -	phylink_pcs_config(pl, force_restart, &link_state);=0A=
> +	phylink_change_interface(pl, force_restart, &link_state);=0A=
>   }=0A=
>   =0A=
>   static const char *phylink_pause_to_str(int pause)=0A=
> @@ -674,7 +698,7 @@ static void phylink_resolve(struct work_struct *w)=0A=
>   				phylink_link_down(pl);=0A=
>   				cur_link_state =3D false;=0A=
>   			}=0A=
> -			phylink_pcs_config(pl, false, &link_state);=0A=
> +			phylink_change_interface(pl, false, &link_state);=0A=
>   			pl->link_config.interface =3D link_state.interface;=0A=
>   		} else if (!pl->pcs_ops) {=0A=
>   			/* The interface remains unchanged, only the speed,=0A=
> @@ -1450,22 +1474,26 @@ int phylink_ethtool_ksettings_set(struct phylink =
*pl,=0A=
>   		return -EINVAL;=0A=
>   =0A=
>   	mutex_lock(&pl->state_mutex);=0A=
> -	linkmode_copy(pl->link_config.advertising, config.advertising);=0A=
> -	pl->link_config.interface =3D config.interface;=0A=
>   	pl->link_config.speed =3D config.speed;=0A=
>   	pl->link_config.duplex =3D config.duplex;=0A=
> -	pl->link_config.an_enabled =3D kset->base.autoneg !=3D=0A=
> -				     AUTONEG_DISABLE;=0A=
> -=0A=
> -	if (pl->cur_link_an_mode =3D=3D MLO_AN_INBAND &&=0A=
> -	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {=
=0A=
> -		/* If in 802.3z mode, this updates the advertisement.=0A=
> -		 *=0A=
> -		 * If we are in SGMII mode without a PHY, there is no=0A=
> -		 * advertisement; the only thing we have is the pause=0A=
> -		 * modes which can only come from a PHY.=0A=
> -		 */=0A=
> -		phylink_pcs_config(pl, true, &pl->link_config);=0A=
> +	pl->link_config.an_enabled =3D kset->base.autoneg !=3D AUTONEG_DISABLE;=
=0A=
> +=0A=
> +	if (pl->link_config.interface !=3D config.interface) {=0A=
=0A=
=0A=
I cannot seem to understand where in this function config.interface =0A=
could become different from pl->link_config.interface.=0A=
=0A=
Is there something obvious that I am missing?=0A=
=0A=
Ioana=0A=
=0A=
> +		/* The interface changed, e.g. 1000base-X <-> 2500base-X */=0A=
> +		/* We need to force the link down, then change the interface */=0A=
> +		if (pl->old_link_state) {=0A=
> +			phylink_link_down(pl);=0A=
> +			pl->old_link_state =3D false;=0A=
> +		}=0A=
> +		if (!test_bit(PHYLINK_DISABLE_STOPPED,=0A=
> +			      &pl->phylink_disable_state))=0A=
> +			phylink_change_interface(pl, false, &config);=0A=
> +		pl->link_config.interface =3D config.interface;=0A=
> +		linkmode_copy(pl->link_config.advertising, config.advertising);=0A=
> +	} else if (!linkmode_equal(pl->link_config.advertising,=0A=
> +				   config.advertising)) {=0A=
> +		linkmode_copy(pl->link_config.advertising, config.advertising);=0A=
> +		phylink_change_inband_advert(pl);=0A=
>   	}=0A=
>   	mutex_unlock(&pl->state_mutex);=0A=
>   =0A=
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h=0A=
> index d9913d8e6b91..2f1315f32113 100644=0A=
> --- a/include/linux/phylink.h=0A=
> +++ b/include/linux/phylink.h=0A=
> @@ -76,7 +76,9 @@ struct phylink_config {=0A=
>    * struct phylink_mac_ops - MAC operations structure.=0A=
>    * @validate: Validate and update the link configuration.=0A=
>    * @mac_pcs_get_state: Read the current link state from the hardware.=
=0A=
> + * @mac_prepare: prepare for a major reconfiguration of the interface.=
=0A=
>    * @mac_config: configure the MAC for the selected mode and state.=0A=
> + * @mac_finish: finish a major reconfiguration of the interface.=0A=
>    * @mac_an_restart: restart 802.3z BaseX autonegotiation.=0A=
>    * @mac_link_down: take the link down.=0A=
>    * @mac_link_up: allow the link to come up.=0A=
> @@ -89,8 +91,12 @@ struct phylink_mac_ops {=0A=
>   			 struct phylink_link_state *state);=0A=
>   	void (*mac_pcs_get_state)(struct phylink_config *config,=0A=
>   				  struct phylink_link_state *state);=0A=
> +	int (*mac_prepare)(struct phylink_config *config, unsigned int mode,=0A=
> +			   phy_interface_t iface);=0A=
>   	void (*mac_config)(struct phylink_config *config, unsigned int mode,=
=0A=
>   			   const struct phylink_link_state *state);=0A=
> +	int (*mac_finish)(struct phylink_config *config, unsigned int mode,=0A=
> +			  phy_interface_t iface);=0A=
>   	void (*mac_an_restart)(struct phylink_config *config);=0A=
>   	void (*mac_link_down)(struct phylink_config *config, unsigned int mode=
,=0A=
>   			      phy_interface_t interface);=0A=
> @@ -145,6 +151,31 @@ void validate(struct phylink_config *config, unsigne=
d long *supported,=0A=
>   void mac_pcs_get_state(struct phylink_config *config,=0A=
>   		       struct phylink_link_state *state);=0A=
>   =0A=
> +/**=0A=
> + * mac_prepare() - prepare to change the PHY interface mode=0A=
> + * @config: a pointer to a &struct phylink_config.=0A=
> + * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.=0A=
> + * @iface: interface mode to switch to=0A=
> + *=0A=
> + * phylink will call this method at the beginning of a full initialisati=
on=0A=
> + * of the link, which includes changing the interface mode or at initial=
=0A=
> + * startup time. It may be called for the current mode. The MAC driver=
=0A=
> + * should perform whatever actions are required, e.g. disabling the=0A=
> + * Serdes PHY.=0A=
> + *=0A=
> + * This will be the first call in the sequence:=0A=
> + * - mac_prepare()=0A=
> + * - mac_config()=0A=
> + * - pcs_config()=0A=
> + * - possible pcs_an_restart()=0A=
> + * - mac_finish()=0A=
> + *=0A=
> + * Returns zero on success, or negative errno on failure which will be=
=0A=
> + * reported to the kernel log.=0A=
> + */=0A=
> +int mac_prepare(struct phylink_config *config, unsigned int mode,=0A=
> +		phy_interface_t iface);=0A=
> +=0A=
>   /**=0A=
>    * mac_config() - configure the MAC for the selected mode and state=0A=
>    * @config: a pointer to a &struct phylink_config.=0A=
> @@ -220,6 +251,23 @@ void mac_pcs_get_state(struct phylink_config *config=
,=0A=
>   void mac_config(struct phylink_config *config, unsigned int mode,=0A=
>   		const struct phylink_link_state *state);=0A=
>   =0A=
> +/**=0A=
> + * mac_finish() - finish a to change the PHY interface mode=0A=
> + * @config: a pointer to a &struct phylink_config.=0A=
> + * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.=0A=
> + * @iface: interface mode to switch to=0A=
> + *=0A=
> + * phylink will call this if it called mac_prepare() to allow the MAC to=
=0A=
> + * complete any necessary steps after the MAC and PCS have been configur=
ed=0A=
> + * for the @mode and @iface. E.g. a MAC driver may wish to re-enable the=
=0A=
> + * Serdes PHY here if it was previously disabled by mac_prepare().=0A=
> + *=0A=
> + * Returns zero on success, or negative errno on failure which will be=
=0A=
> + * reported to the kernel log.=0A=
> + */=0A=
> +int mac_finish(struct phylink_config *config, unsigned int mode,=0A=
> +		phy_interface_t iface);=0A=
> +=0A=
>   /**=0A=
>    * mac_an_restart() - restart 802.3z BaseX autonegotiation=0A=
>    * @config: a pointer to a &struct phylink_config.=0A=
> =0A=
=0A=
