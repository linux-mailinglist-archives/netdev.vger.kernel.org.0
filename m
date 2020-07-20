Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04011226057
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGTNC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:02:26 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:38969
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727062AbgGTNC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdrUg+/Bdj1ppT9ZwodSwScuZWa4nSzrb1VFO0kEXRiOvXaGqhPARnOjC0Z24wtRpqRegKb06nfWtenlalu0X4dtAlUXsZazW4zon79dUEcxCkBQvuTAmd7YPd5TKsuJtCu3QRQYKRembVUBAWRJ3iDPCbKSyjkfuGMX8ldvOj+Iz4JLcd1YHIH/hR5x/bdFuEShm/i+gv+0cC3uQMxwP7BOwwjyNxm0FiokQo/8Uc/ygUFCwxJb/+TZCNLjcBObh5fWhhpRdArXVWKNQnJKBV/o+2IJ8azSI/nyOPN41+NBj0E7+H7zgMYSBtwgfeZplcottOs/RXbaJVFqTcBKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1lUWCsmLq7Sk91GZZdyjmEegpxrq2JnVFiG4p50dQk=;
 b=ODClDRs18ooralmCeoT28VTsUjHSvTsv3XE/CFeGR5YNl2CZxjyh6+rz0NMFNQBtUB/m+sPnscDO0r24hEfQouZwmqWkS0UDXIsBQlAHyBg1QDVhDi7Noz4tpRo0fx2X5sokdmSfL3GcSuiHn/aIQ0gShvIwJSz8f42Sv9+rwvnJIMZFoh1dAmQCfZYvby8P7KCKgszWMu9ldP/lvnaUZ1yHFMr43vkOddXEWy6yAPaAbQl0IVBevmJB4rGkTgqZl60LvREpv1Y84YPt5xR2KTRPwz9KZoLBsAkK5b6MGeuDgC2ukgvaAQRJQ/PypqyJtXk4BhEGnTAWlbBMo9/S7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1lUWCsmLq7Sk91GZZdyjmEegpxrq2JnVFiG4p50dQk=;
 b=LzhO5G3cAMf7d2DzLrn1h1UWIW2GHETHn/AbF0AkN1I6vCKq65G2fhtJp3ZpdaAkdIdUPkrmxgBg0junj+I5Q0VbRRxb3XdlpBNj1qf5yCn8qjtdiNuuiVeSvFg+DVhkgq19mUdNcp/AVu3TfRjSDTwhx60FGY+va0W/WZc2yOc=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB6061.eurprd04.prod.outlook.com
 (2603:10a6:803:f2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Mon, 20 Jul
 2020 13:02:22 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 13:02:22 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Date:   Mon, 20 Jul 2020 13:02:21 +0000
Message-ID: <VI1PR0402MB3871F35402449975F73B156BE07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGJ-0006QA-E2@rmk-PC.armlinux.org.uk>
 <VI1PR0402MB387151248ABD93EAA9C2E454E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200720124405.GT1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f290ddf9-39c7-4df7-e1c6-08d82cad242d
x-ms-traffictypediagnostic: VI1PR04MB6061:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6061F53C03BE85A866C2B199E07B0@VI1PR04MB6061.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KVD+TH0nfU0eR5E7W6Kz/dzFHsRd4pErVPHeZ4GJnqMYthDQEruGydhdawvHD+CLKUt3Em+J56/Fq/h65rg4iz96H8I7+PItj7TAE6opSD0ZxpJ5NOh/Ib8+OcDBgU4TvBLwj/6h9CP0g+ritEAwBzGXu4YsT0rHi0kpphcYJiInn8p4bKwscNhgj885vbpbRCRybje5eY7gGJBlx1x94JwpHP0gT/zK9hO6GHXStI9mLzGCkUFmtFhPMObWPCnYNUVO4SxzEfh53lyTcxjbslVmQu1XNnnc5RvO0/obRe4dPYWm2WBgQNpDv3WTxTLzfi8t+FEm9Hw4oSsz/HXjPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(316002)(5660300002)(44832011)(186003)(66446008)(53546011)(7696005)(8936002)(64756008)(6506007)(66556008)(86362001)(66476007)(66946007)(26005)(76116006)(91956017)(8676002)(54906003)(33656002)(71200400001)(6916009)(55016002)(478600001)(4326008)(2906002)(52536014)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sp5Pcr6/n2jNifwuhGeahxYdITRsX1SXvIVe9M70cpxXFJvfgjqN66C7Rc+mPOAQa99Xfvgmp20U9hc0VviUd35R2NB0CwUrfyaITsDe10z05uRRcFLdWPlMz2pPbbzinfgvp1+YgBzDOuoWOeZAw9l+MyXpXnPICAdMtzwTjPHFKGopGhFBWtTmi/LgTHH0OqUKqJsH4Ah+mxghTEgCKo7cukeOLkv2rPn15GjeaV8HNelbygtHAdjp/Or0y6BJ117pAr/NuXddF1Cj1OUqJxIyu062iCizq5iCpxNKYzju6pqUTgTh8AQpyKFuKAHH6GSLmlxo/yCEE+wkyvFXt7ZGtTnVHschtkZ1lE9qVmGweW5ImbyAQEc5vUnW+4A28af3JTAvOarWT1i/wQdVr4KT1cBs/YHqn4UltUVNCAsId1G39ghbS3oAX1LmqxOY9T5nMlkeueFy59GF8QCyLf0V06F/p/M41yhTQfzPSTI5I9LMXusPsnNDA3NdPhit
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f290ddf9-39c7-4df7-e1c6-08d82cad242d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 13:02:21.9716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y86ml6pn31Cer55mdWAivniGp/XwfBXf+f45vwESN55tCchwjZ2jd3Tn8vjOJQgfkWHfpE/vYezDKwHzfDCZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 3:44 PM, Russell King - ARM Linux admin wrote:=0A=
> On Mon, Jul 20, 2020 at 11:40:44AM +0000, Ioana Ciornei wrote:=0A=
>> On 6/30/20 5:29 PM, Russell King wrote:=0A=
>>> With PCS support, how we implement interface reconfiguration is not up=
=0A=
>>> to the job; we end up reconfiguring the PCS for an interface change=0A=
>>> while the link could potentially be up.  In order to solve this, add=0A=
>>> two additional MAC methods for interface configuration, one to prepare=
=0A=
>>> for the change, and one to finish the change.=0A=
>>>=0A=
>>> This allows mvneta and mvpp2 to shutdown what they require prior to the=
=0A=
>>> MAC and PCS configuration calls, and then restart as appropriate.=0A=
>>>=0A=
>>> This impacts ksettings_set(), which now needs to identify whether the=
=0A=
>>> change is a minor tweak to the advertisement masks or whether the=0A=
>>> interface mode has changed, and call the appropriate function for that=
=0A=
>>> update.=0A=
>>>=0A=
>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>=0A=
>>> ---=0A=
>>>    drivers/net/phy/phylink.c | 80 ++++++++++++++++++++++++++-----------=
--=0A=
>>>    include/linux/phylink.h   | 48 +++++++++++++++++++++++=0A=
>>>    2 files changed, 102 insertions(+), 26 deletions(-)=0A=
>>>=0A=
>>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
>>> index 09f4aeef15c7..a31a00fb4974 100644=0A=
>>> --- a/drivers/net/phy/phylink.c=0A=
>>> +++ b/drivers/net/phy/phylink.c=0A=
>>> @@ -433,23 +433,47 @@ static void phylink_mac_pcs_an_restart(struct phy=
link *pl)=0A=
>>>    	}=0A=
>>>    }=0A=
>>>    =0A=
>>> -static void phylink_pcs_config(struct phylink *pl, bool force_restart,=
=0A=
>>> -			       const struct phylink_link_state *state)=0A=
>>> +static void phylink_change_interface(struct phylink *pl, bool restart,=
=0A=
>>> +				     const struct phylink_link_state *state)=0A=
>>>    {=0A=
>>> -	bool restart =3D force_restart;=0A=
>>> +	int err;=0A=
>>> +=0A=
>>> +	phylink_dbg(pl, "change interface %s\n", phy_modes(state->interface))=
;=0A=
>>>    =0A=
>>> -	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,=0A=
>>> -						   pl->cur_link_an_mode,=0A=
>>> -						   state->interface,=0A=
>>> -						   state->advertising,=0A=
>>> -						   !!(pl->link_config.pause &=0A=
>>> -						      MLO_PAUSE_AN)))=0A=
>>> -		restart =3D true;=0A=
>>> +	if (pl->mac_ops->mac_prepare) {=0A=
>>> +		err =3D pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,=
=0A=
>>> +					       state->interface);=0A=
>>> +		if (err < 0) {=0A=
>>> +			phylink_err(pl, "mac_prepare failed: %pe\n",=0A=
>>> +				    ERR_PTR(err));=0A=
>>> +			return;=0A=
>>> +		}=0A=
>>> +	}=0A=
>>>    =0A=
>>>    	phylink_mac_config(pl, state);=0A=
>>>    =0A=
>>> +	if (pl->pcs_ops) {=0A=
>>> +		err =3D pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,=0A=
>>> +					      state->interface,=0A=
>>> +					      state->advertising,=0A=
>>> +					      !!(pl->link_config.pause &=0A=
>>> +						 MLO_PAUSE_AN));=0A=
>>> +		if (err < 0)=0A=
>>> +			phylink_err(pl, "pcs_config failed: %pe\n",=0A=
>>> +				    ERR_PTR(err));=0A=
>>> +		if (err > 0)=0A=
>>> +			restart =3D true;=0A=
>>> +	}=0A=
>>>    	if (restart)=0A=
>>>    		phylink_mac_pcs_an_restart(pl);=0A=
>>> +=0A=
>>> +	if (pl->mac_ops->mac_finish) {=0A=
>>> +		err =3D pl->mac_ops->mac_finish(pl->config, pl->cur_link_an_mode,=0A=
>>> +					      state->interface);=0A=
>>> +		if (err < 0)=0A=
>>> +			phylink_err(pl, "mac_prepare failed: %pe\n",=0A=
>>> +				    ERR_PTR(err));=0A=
>>> +	}=0A=
>>>    }=0A=
>>>    =0A=
>>>    /*=0A=
>>> @@ -555,7 +579,7 @@ static void phylink_mac_initial_config(struct phyli=
nk *pl, bool force_restart)=0A=
>>>    	link_state.link =3D false;=0A=
>>>    =0A=
>>>    	phylink_apply_manual_flow(pl, &link_state);=0A=
>>> -	phylink_pcs_config(pl, force_restart, &link_state);=0A=
>>> +	phylink_change_interface(pl, force_restart, &link_state);=0A=
>>>    }=0A=
>>>    =0A=
>>>    static const char *phylink_pause_to_str(int pause)=0A=
>>> @@ -674,7 +698,7 @@ static void phylink_resolve(struct work_struct *w)=
=0A=
>>>    				phylink_link_down(pl);=0A=
>>>    				cur_link_state =3D false;=0A=
>>>    			}=0A=
>>> -			phylink_pcs_config(pl, false, &link_state);=0A=
>>> +			phylink_change_interface(pl, false, &link_state);=0A=
>>>    			pl->link_config.interface =3D link_state.interface;=0A=
>>>    		} else if (!pl->pcs_ops) {=0A=
>>>    			/* The interface remains unchanged, only the speed,=0A=
>>> @@ -1450,22 +1474,26 @@ int phylink_ethtool_ksettings_set(struct phylin=
k *pl,=0A=
>>>    		return -EINVAL;=0A=
>>>    =0A=
>>>    	mutex_lock(&pl->state_mutex);=0A=
>>> -	linkmode_copy(pl->link_config.advertising, config.advertising);=0A=
>>> -	pl->link_config.interface =3D config.interface;=0A=
>>>    	pl->link_config.speed =3D config.speed;=0A=
>>>    	pl->link_config.duplex =3D config.duplex;=0A=
>>> -	pl->link_config.an_enabled =3D kset->base.autoneg !=3D=0A=
>>> -				     AUTONEG_DISABLE;=0A=
>>> -=0A=
>>> -	if (pl->cur_link_an_mode =3D=3D MLO_AN_INBAND &&=0A=
>>> -	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {=
=0A=
>>> -		/* If in 802.3z mode, this updates the advertisement.=0A=
>>> -		 *=0A=
>>> -		 * If we are in SGMII mode without a PHY, there is no=0A=
>>> -		 * advertisement; the only thing we have is the pause=0A=
>>> -		 * modes which can only come from a PHY.=0A=
>>> -		 */=0A=
>>> -		phylink_pcs_config(pl, true, &pl->link_config);=0A=
>>> +	pl->link_config.an_enabled =3D kset->base.autoneg !=3D AUTONEG_DISABL=
E;=0A=
>>> +=0A=
>>> +	if (pl->link_config.interface !=3D config.interface) {=0A=
>>=0A=
>>=0A=
>> I cannot seem to understand where in this function config.interface=0A=
>> could become different from pl->link_config.interface.=0A=
>>=0A=
>> Is there something obvious that I am missing?=0A=
> =0A=
> The validate() method is free to change the interface if required -=0A=
> there's a helper that MACs can use to achieve that for switching=0A=
> between 1000base-X and 2500base-X.  Useful if you have a FC SFP=0A=
> plugged in capable of 2500base-X, but want to communicate with a=0A=
> 1000base-X link partner.=0A=
> =0A=
=0A=
Ok, I was not aware of this possibility. Now that I looked, it's even =0A=
documented in phylink's header file.=0A=
=0A=
My confusion stems from the fact that I expected this to come from the =0A=
SFP itself requesting an interface type or the other. So the usage here =0A=
is to know what is at the other end of the line and configure the =0A=
appropriate advertisement with ethtool?=0A=
=0A=
Ioana=0A=
