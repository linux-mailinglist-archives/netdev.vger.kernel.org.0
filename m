Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEC610293D
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfKSQWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:22:51 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:39618
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbfKSQWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 11:22:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAoJR0OQDWD4m62vM0hLJFWXQWUqqTSZb/hxWRvpBRvMYwmCsrBB9JjrfV+aU3IRdOaluvA/Bq28T1s08ttaE1TXWsLrlUFX7h+hHrLzNXkfYv0PjoMKLUrPaKNbOraQFlPV1fy0zaoKdiOANrC9SA25fXyqetIP8pW1YnYkE5pcGt3zCOYSPCbiibWeaiyMzmwf0H7MEudTsWWfbhurEtNAW8V4guIuwec/ZccH4JDaA3qaKb9jWDyOuPL+srGwRmjb7yU2rUbTSb6hD/CxNAKPQs2u0olSk+d6lSDikdiL06JgSjR0fJE0OHs31DxQjHkshxmZ6GsQ31hBOH9vMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HotoZLUYNrivJIElFjP3TnpBWDHcXVA/Nw1q669yljs=;
 b=UQ3096w3OIm73jIh7wWRUsppEFMlOohzCxUFcRQG6R6xN0FLruVP+QTJxu8W+LQemY9GAHRa2QwGpb6uoLqkAbRv4e3KrdLZiktD1TMKtl4NKLbS3PaBKLOojBuMG4/X+jMBZJMO5yDx2ay81jug9/G2riG9/6BoIbO8z8+hgJ7E3SrfhJzy4SqGcI9vfbnDGUJpOIlNYAd8GvOmallTWGHSvbYWBzHHOpawsOnRTAn+Azren3vEoOayGqIxog5j7cmxQleMEILEvpZUvjZYXaZ8PuqKJAh/EnS+KPZtwEzF71bvTwwood3knnQccNiepHP6TmYaOVYCkq9Z3jMM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HotoZLUYNrivJIElFjP3TnpBWDHcXVA/Nw1q669yljs=;
 b=rP3PwN0z9pLjAOKnQ99rCLDBI+MglsLXgb+9XkZb5F+KyN0debEXHaTECxqi+QUakpqHZxi1L4yAEhmp350QQWs5el4aAlxVqE4oTVo1YXmOi8j+B8F+1fcGIwcgxBdNVuLvkYQTp4onA1PZ3ml8rpps2b1YXCaC3+V+ws4wUr4=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3456.eurprd04.prod.outlook.com (52.134.3.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 16:22:46 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2451.031; Tue, 19 Nov
 2019 16:22:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Topic: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Index: AQHVj3h7g+hWYcwKLkqG42rM2PClg6ePpQ+AgAMXBaA=
Date:   Tue, 19 Nov 2019 16:22:46 +0000
Message-ID: <VI1PR0402MB2800DAE9E3951704B7F643FAE04C0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
 <20191117161351.GH1344@shell.armlinux.org.uk>
In-Reply-To: <20191117161351.GH1344@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 454d5f0c-96ff-489b-9095-08d76d0cb6a7
x-ms-traffictypediagnostic: VI1PR0402MB3456:|VI1PR0402MB3456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34568E4931DFD3C36877E054E04C0@VI1PR0402MB3456.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(199004)(189003)(305945005)(9686003)(6116002)(81156014)(5024004)(256004)(14444005)(71190400001)(33656002)(55016002)(486006)(26005)(81166006)(6246003)(44832011)(476003)(99286004)(25786009)(76176011)(71200400001)(54906003)(76116006)(102836004)(64756008)(6436002)(2906002)(6506007)(7736002)(8936002)(11346002)(229853002)(66476007)(5660300002)(3846002)(7696005)(316002)(4326008)(66556008)(6916009)(66946007)(14454004)(52536014)(74316002)(86362001)(478600001)(66066001)(446003)(186003)(66446008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3456;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eNblCG+uHC8rHh89CDUFtqZD2H5ofvfTN5kW+2HlYPCjYKkla+BB/vKvYFas5vJ1O5L8CorYq9US+DfDgSzSXB7rgon7exUQJ7MDVuEEgIZNRS6KFIapLJZE0huwHJqCwsl7RtQ/g7tpFT+h5cFtCAdx06GC68kiBxOmScXJtd+YOtk/ij7ry4e22Hra3KAgBq4nzqTOfj00gUFyQkrfnocjn3zOD8gJBjpBD3TNGVPJ2l5lFmKuXcxsEgMrsCAGa2PGLu0AgnfEPBvk7ldhri+tdEFN9Z8cgAYKwbcjjYWfRZS+zlVLn/U+HggTtwtrogtgLpSFP1ZUKpfV6nVC3MH2lNC/LV3DEDWoUHAx27TNTsV4YuLak0qur9+Gg++FOI80nmAHvPpigtRbkt8vnPh9EsBWt8pjNsLL9qNj76eoXWnlCTG1BW9mybG5jwEv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454d5f0c-96ff-489b-9095-08d76d0cb6a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 16:22:46.7074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h2s/X8AuddsES+RX+PVJUrGFtuXjsAJRS+vscwuXluoyAA4H/Ngr34hgN7p2TQZPyRNy+PcgBXN/O3IA3wjXtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support
> through phylink
>=20
> On Thu, Oct 31, 2019 at 01:18:31AM +0200, Ioana Ciornei wrote:
> > The dpaa2-eth driver now has support for connecting to its associated
> > PHY device found through standard OF bindings.
> >
> > This happens when the DPNI object (that the driver probes on) gets
> > connected to a DPMAC. When that happens, the device tree is looked up
> > by the DPMAC ID, and the associated PHY bindings are found.
> >
> > The old logic of handling the net device's link state by hand still
> > needs to be kept, as the DPNI can be connected to other devices on the
> > bus than a DPMAC: other DPNI, DPSW ports, etc. This logic is only
> > engaged when there is no DPMAC (and therefore no phylink instance)
> > attached.
> >
> > The MC firmware support multiple type of DPMAC links: TYPE_FIXED,
> > TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC
> management
> > from Linux side, and as such, the driver will not handle such a DPMAC.
> >
> > Although PHYLINK typically handles SFP cages and in-band AN modes, for
> > the moment the driver only supports the RGMII interfaces found on the
> > LX2160A. Support for other modes will come later.
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> ...
>=20
> > @@ -3363,6 +3425,13 @@ static irqreturn_t dpni_irq0_handler_thread(int
> irq_num, void *arg)
> >  	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
> >  		set_mac_addr(netdev_priv(net_dev));
> >  		update_tx_fqids(priv);
> > +
> > +		rtnl_lock();
> > +		if (priv->mac)
> > +			dpaa2_eth_disconnect_mac(priv);
> > +		else
> > +			dpaa2_eth_connect_mac(priv);
> > +		rtnl_unlock();
>=20
> Sorry, but this locking is deadlock prone.
>=20
> You're taking rtnl_lock().
> dpaa2_eth_connect_mac() calls dpaa2_mac_connect().
> dpaa2_mac_connect() calls phylink_create().
> phylink_create() calls phylink_register_sfp().
> phylink_register_sfp() calls sfp_bus_add_upstream().
> sfp_bus_add_upstream() calls rtnl_lock() *** DEADLOCK ***.

I recently discovered this also when working on adding support for SFPs.

>=20
> Neither phylink_create() nor phylink_destroy() may be called holding the =
rtnl
> lock.
>=20

Just to summarise:

* phylink_create() and phylink_destroy() should NOT be called with the rtnl=
 lock held
* phylink_disconnect_phy() should be called with the lock
* depending on when the netdev is registered the phylink_of_phy_connect()
may be called with or without the rtnl lock

I'll have to move the lock and unlock around the actual _connect() and _dis=
connect_phy()
calls so that even the case where the DPMAC is connected at runtime
(the EVENT_ENDPOINT_CHANGED referred above) is treated correctly.

Thanks,
Ioana



