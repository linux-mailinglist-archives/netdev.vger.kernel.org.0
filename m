Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51C9CFF4
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732188AbfHZNA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:00:28 -0400
Received: from mail-eopbgr150055.outbound.protection.outlook.com ([40.107.15.55]:11681
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731275AbfHZNA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 09:00:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyOrpkq7CaEz5SZy/mgtWUaKGsvfaHjX4Q4eq0DZB9SYdElmIv+CNkNEglesArWLJB2z20pvQTpygmbRLYkLDCsLrEbO9XL5IFaqIs0H3It+Rz/XiwUeePMq0rcPMq2Dc9wuOjkuGPW05f5SRXsfq7YrfsQp0YkTOwq/DLsQ8xBQcIb8utJq+J1tNcT/Yc8G3cxHgx1M5/VFm33kILbf9R1xpylgIof8FLcPn7o5IWpbn2TCEAQ4xhuDdmmZbfIxxLPdk1inQFi4HXWYTillTtqySrWfRmnQoNCQynkKu+trJ1cj8sA0x4TrdDkr0yN80CWrG+shSvrE7GQH1nmWdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws+sg4D0Awl4MWnZSwaqZlmhNbUxqMCEmKHca2uJj3c=;
 b=fkkdQ0g3A1fSdt/iqyWaSq6g9EuXjlXS7EhvSgaZN/4dLzQKHsSc4TK6zsd5DasFxigQ0/DNwLq2DKIIcOtM7Wr85NE95WqGnozeO7WAvBS0WPBba4RX8De8A3FZ65W0DNz95BMqWVRyM4ydQYJAr5epJvd1xNfacOTWHZGSoaPDjNm/MJ6gBS2fw6+FEpOpUg8jotf+D3a2LiiMnO+3rFA/w61PV1Hfbdm1K1ic/uK5Ag5PBiZsX+Pgw1Ukw64KmS8WDZ/rYZseqHyIa3MDBpwGXMmZ8HMJ/tf9JebfVKZF3g/1zmYGPbuZSP0u/a2dnlKePMJMQNsI3QhCCVn6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws+sg4D0Awl4MWnZSwaqZlmhNbUxqMCEmKHca2uJj3c=;
 b=M/1jlKFI2rJMszGh+wkajQeFahLP/hRJSfn9vy4GYTnaXN/jIcJzfjaoFQgIrh78tI8qJgjMM8jg0O2vpLeLdASry/3+fBaRHvy9Seo4Scu73cNjQbpLUKLHEU6Gt+ZtCDkHbYCE6uYeu9pOp7HGemU7+zcZshtIAkuLDY8JrWY=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.176.215.215) by
 AM0PR04MB6196.eurprd04.prod.outlook.com (20.179.34.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 13:00:22 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d%2]) with mapi id 15.20.2157.022; Mon, 26 Aug 2019
 13:00:22 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next] dpaa2-eth: Add pause frame support
Thread-Topic: [PATCH net-next] dpaa2-eth: Add pause frame support
Thread-Index: AQHVWcYvVcGOz2IwmU+YIPjENETybqcI7KOAgARXeoA=
Date:   Mon, 26 Aug 2019 13:00:22 +0000
Message-ID: <AM0PR04MB49944F03886D8E147485947394A10@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <1566573579-9940-1-git-send-email-ruxandra.radulescu@nxp.com>
 <20190823163037.GA19727@lunn.ch>
In-Reply-To: <20190823163037.GA19727@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [82.144.34.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3635fab-9198-449e-c093-08d72a255af6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR04MB6196;
x-ms-traffictypediagnostic: AM0PR04MB6196:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB61968877DB85DCBD43E9D49794A10@AM0PR04MB6196.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(189003)(199004)(13464003)(3846002)(6116002)(6916009)(99286004)(229853002)(102836004)(6506007)(53546011)(478600001)(186003)(26005)(4326008)(54906003)(316002)(25786009)(55016002)(71200400001)(71190400001)(6246003)(446003)(11346002)(476003)(486006)(53936002)(66066001)(86362001)(9686003)(66556008)(64756008)(66446008)(81156014)(81166006)(8936002)(76116006)(8676002)(7736002)(52536014)(305945005)(2906002)(6436002)(74316002)(7696005)(76176011)(14454004)(256004)(66476007)(14444005)(66946007)(33656002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6196;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H1SUXcUsumKa/TFzGMwKNCa75ZxmQtQ3snIhhrvrHKxd46E5Hg7yi1WhPIpj4TMTDA1TNQiXfsPF2w/NLw4ovfXm8rbc+rVZzkYXfdq/h1tbnvemwHOXaw9d19y9wLrg0F15lBI6zkGkOUG3W5j9ZWtLWbsHg86Tns2fI7+6wVJMyVv5Fr/Iie2qx7blC9sv58fvzJE0vc8hrYLX1nMaPrb1PwZEGCJix1yItcmcy5G4UmcZknsEIjs5HuGbuOzX+PHMvzfEnr6V+qwx1qnMmLNZMFZiZH5+9qrvzXiLkJnEalCS25C4q6dMGDE9ZKD2lSLPMIUCk38GIAg2m3bcwQbYkmixKaGgeXrGbEnMRF0ua7jKt6TAEIiAFH/zbVmcMjPGV+fcBFF3bMUFdrqlGu+x+ZUJN/t2W7jZILhhMWQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3635fab-9198-449e-c093-08d72a255af6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 13:00:22.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: siBYjU3q+V1FB4qoWS4MW6O01ZCUKtX/GkSrNyM6Td7MeymD+DrUyy9rLws2412IlXbOX9jBZ4steyQwoLgkh0JsnG4tXt2UlwTXBy+dBg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, August 23, 2019 7:31 PM
> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; Ioana Ciornei
> <ioana.ciornei@nxp.com>
> Subject: Re: [PATCH net-next] dpaa2-eth: Add pause frame support
>=20
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > @@ -78,29 +78,20 @@ static int
> >  dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
> >  			     struct ethtool_link_ksettings *link_settings)
> >  {
> > -	struct dpni_link_state state =3D {0};
> > -	int err =3D 0;
> >  	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> >
> > -	err =3D dpni_get_link_state(priv->mc_io, 0, priv->mc_token, &state);
> > -	if (err) {
> > -		netdev_err(net_dev, "ERROR %d getting link state\n", err);
> > -		goto out;
> > -	}
> > -
> >  	/* At the moment, we have no way of interrogating the DPMAC
> >  	 * from the DPNI side - and for that matter there may exist
> >  	 * no DPMAC at all. So for now we just don't report anything
> >  	 * beyond the DPNI attributes.
> >  	 */
> > -	if (state.options & DPNI_LINK_OPT_AUTONEG)
> > +	if (priv->link_state.options & DPNI_LINK_OPT_AUTONEG)
> >  		link_settings->base.autoneg =3D AUTONEG_ENABLE;
> > -	if (!(state.options & DPNI_LINK_OPT_HALF_DUPLEX))
> > +	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))
> >  		link_settings->base.duplex =3D DUPLEX_FULL;
> > -	link_settings->base.speed =3D state.rate;
> > +	link_settings->base.speed =3D priv->link_state.rate;
> >
> > -out:
> > -	return err;
> > +	return 0;
>=20
> Hi Ioana
>=20
> I think this patch can be broken up a bit, to help review.
>=20
> It looks like this change to report state via priv->link_state should
> be a separate patch. I think this change can be made without the pause
> changes. That then makes the pause changes themselves simpler.

Agree, will change in v2

>=20
> > +static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
> > +				     struct ethtool_pauseparam *pause)
> > +{
> > +	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> > +	u64 link_options =3D priv->link_state.options;
> > +
> > +	pause->rx_pause =3D !!(link_options & DPNI_LINK_OPT_PAUSE);
> > +	pause->tx_pause =3D pause->rx_pause ^
> > +			  !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);
>=20
> Since you don't support auto-neg, you should set pause->autoneg to
> false. It probably already is set to false, by a memset, but setting
> it explicitly is a form of documentation, this hardware only supports
> forced pause configuration.
>=20

Ok.

> > +}
> > +
> > +static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
> > +				    struct ethtool_pauseparam *pause)
> > +{
> > +	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> > +	struct dpni_link_cfg cfg =3D {0};
> > +	int err;
> > +
> > +	if (!dpaa2_eth_has_pause_support(priv)) {
> > +		netdev_info(net_dev, "No pause frame support for DPNI
> version < %d.%d\n",
> > +			    DPNI_PAUSE_VER_MAJOR,
> DPNI_PAUSE_VER_MINOR);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (pause->autoneg)
> > +		netdev_err(net_dev, "Pause frame autoneg not supported\n");
>=20
> And here you should return -EOPNOTSUPP. No need for an netdev_err. It
> is not an error, you simply don't support it.

Ok

>=20
> There is also the issue of what is the PHY doing? It would not be good
> if the MAC is configured one way, but the PHY is advertising something
> else. So it appears you have no control over the PHY. But i assume you
> know what the PHY is actually doing? Does it advertise pause/asym
> pause?
>=20
> It might be, to keep things consistent, we only accept pause
> configuration when auto-neg in general is disabled.

Ah, this is an area in our driver that's a bit messy and complicated.
Like you said, we don't control the PHY, actually we only support
fixed-link PHYs for now. General autoneg should really be reported as
always off.

We're working to add proper support in this area, but until we manage
to do it I think it's best we just remove the possibility of users
changing the link settings via ethtool - it's code that shouldn't be
there (and firmware doesn't allow it anyway). I'll include this cleanup
in the next version.

Thanks a lot for the feedback,
Ioana
