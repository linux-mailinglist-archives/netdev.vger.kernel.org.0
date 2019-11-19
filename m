Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB64102AF6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfKSRuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:50:02 -0500
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:25851
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfKSRuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 12:50:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNO2wWC1ldmXuemzECYIsZNkcxTNI6ENeJFgcRABEWxr6rD88JwY3bw0HdWEwa9rwul8eWlkvYpGo/xqg9oco+ShazuKWL3GytqljUEEbsKWQltBzv8BrHwXB4je7w2i9zZha70+QG1K9GBh20X0ROzhh8PhjcIidSj4XbvyeYh7UJe988s7fUJCc9BIfTMNX1MyR4UOxoMKIIEgEsxyJfDuUMdKu6oCoioeSL8S/UobiOIGftr5EUSCz9bS8TKtS0AabjpbLHjNaMQmGYzyc8a1ywv2Q6om/Y3xH0lrYpX3aTtYuMjPhn6DfMNZoAmeWdp6hOpzW3JWtS/9jo3KHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvf/HBhA3O2DfORXPe2WOmPJijpx7Yw/xpvy5oBeuj4=;
 b=Utn8Hvx5cg2TCHGDiLW1LXogbfsISyM0DFdhGFEnJPMsksbQtl/LwtBkW0UfL6sGfhHINfzQObT/UAKGsOd/UYwx7zHala4OzmO0+Apn0XsJ8xLoGJZQbJaYgMJC7Ckt8g/oKEXabJZ0h2O3K6jepinJV857h6r5sFTlUTQc5qo+MEP1vC0LwHXCbC57BCswPQKq/BeWgFL/r1zvkKAKhO3j9Ad7m7hVyp5WV4flluff1cEt0rCmp+9Vt0lfovoBKPqTi/A3hx1bb/wQfaKARpqc/Y5IofFMePMgWfeipICGDWrEBfA4Dzg92CdBa/08op04hGx7WEianHl2EmxXXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvf/HBhA3O2DfORXPe2WOmPJijpx7Yw/xpvy5oBeuj4=;
 b=dhY7yZBBRA06fHivRHWd9P4yiMHNt/2gTes6CeSFdw+mgiDqh1fzMjzao4FSQH0dBSadnOAw4xngwEAANNU25GSkChg2Srs1smk1h7c4S1e0xLd8yrxRluF48j3sJEIRTMSpn4d1u9bzJs73f/TPImb4ZTQYOH2bQ+SApK5PBug=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3567.eurprd04.prod.outlook.com (52.134.6.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 17:49:17 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2451.031; Tue, 19 Nov
 2019 17:49:17 +0000
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
Thread-Index: AQHVj3h7g+hWYcwKLkqG42rM2PClg6ePpQ+AgAMXBaCAAB6jgIAAA0cw
Date:   Tue, 19 Nov 2019 17:49:17 +0000
Message-ID: <VI1PR0402MB280076D1651847E832609FA6E04C0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
 <20191117161351.GH1344@shell.armlinux.org.uk>
 <VI1PR0402MB2800DAE9E3951704B7F643FAE04C0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20191119171441.GE25745@shell.armlinux.org.uk>
In-Reply-To: <20191119171441.GE25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a3e9de1-2aad-4954-d6a7-08d76d18ccc6
x-ms-traffictypediagnostic: VI1PR0402MB3567:|VI1PR0402MB3567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3567D2BBC9FC2EA4B0A59880E04C0@VI1PR0402MB3567.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(6916009)(478600001)(14454004)(76116006)(4326008)(3846002)(6116002)(99286004)(229853002)(305945005)(7696005)(5660300002)(66066001)(86362001)(44832011)(486006)(7736002)(76176011)(476003)(74316002)(446003)(11346002)(186003)(71200400001)(6436002)(316002)(54906003)(81166006)(81156014)(66556008)(66446008)(256004)(66476007)(66946007)(52536014)(102836004)(14444005)(2906002)(8936002)(6246003)(8676002)(26005)(71190400001)(55016002)(9686003)(6506007)(33656002)(25786009)(64756008)(5024004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3567;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NOaA57IEv5E4wrR8IkI0A/EtU+LcUpn3dvx2fZiaxnD6FMaORJxo4aA+V5CLRJ404W4ihjrqS/o6pOKlPuYQx3OiSIhe2gwVdEyrGFCjbpFqvCpCylIKaHQV6TPS7r6uwCltDCVLhzJDxPjHR+9n5d4ACGSJVzFa6Ww8WFYGLyhviGWlGiRn/zQPjytoXTuO99VNcAcfym4d7bc+QJG2ZpI7tTNCvKEXiqlMxkfc6adVawDPHqLF8aMJaDSt9Xwrv/+xqJ0+DQ+KhOD3bOZG+TX1A0ec1GaW3sD6t01bRBIQgh7DR4l4XfuSTopzJ5xaRHdVd5+IhVVxaT89zXTHLRN5rt+QKLidvq8KAMYNdaSPdhqdNg03k6Qwl/bngn6Bc7wPh1g2R8CpH31cKy8PbajQ7q3dLPD9tVgsB1YhNc2ZhCpKrU9Eh9HvB5gTVxA9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3e9de1-2aad-4954-d6a7-08d76d18ccc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 17:49:17.7380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOAPrY90gFJNIJ90f1HDwBx21DW2gpl2HXRrj10TlysojnhIalBQ86xBseVJotn4SHj3Gj02hvb8IB5WbazmUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3567
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support
> through phylink
>=20
> On Tue, Nov 19, 2019 at 04:22:46PM +0000, Ioana Ciornei wrote:
> > > Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support
> > > through phylink
> > >
> > > On Thu, Oct 31, 2019 at 01:18:31AM +0200, Ioana Ciornei wrote:
> > > > The dpaa2-eth driver now has support for connecting to its
> > > > associated PHY device found through standard OF bindings.
> > > >
> > > > This happens when the DPNI object (that the driver probes on) gets
> > > > connected to a DPMAC. When that happens, the device tree is looked
> > > > up by the DPMAC ID, and the associated PHY bindings are found.
> > > >
> > > > The old logic of handling the net device's link state by hand
> > > > still needs to be kept, as the DPNI can be connected to other
> > > > devices on the bus than a DPMAC: other DPNI, DPSW ports, etc. This
> > > > logic is only engaged when there is no DPMAC (and therefore no
> > > > phylink instance) attached.
> > > >
> > > > The MC firmware support multiple type of DPMAC links: TYPE_FIXED,
> > > > TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC
> > > management
> > > > from Linux side, and as such, the driver will not handle such a DPM=
AC.
> > > >
> > > > Although PHYLINK typically handles SFP cages and in-band AN modes,
> > > > for the moment the driver only supports the RGMII interfaces found
> > > > on the LX2160A. Support for other modes will come later.
> > > >
> > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > >
> > > ...
> > >
> > > > @@ -3363,6 +3425,13 @@ static irqreturn_t
> > > > dpni_irq0_handler_thread(int
> > > irq_num, void *arg)
> > > >  	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
> > > >  		set_mac_addr(netdev_priv(net_dev));
> > > >  		update_tx_fqids(priv);
> > > > +
> > > > +		rtnl_lock();
> > > > +		if (priv->mac)
> > > > +			dpaa2_eth_disconnect_mac(priv);
> > > > +		else
> > > > +			dpaa2_eth_connect_mac(priv);
> > > > +		rtnl_unlock();
> > >
> > > Sorry, but this locking is deadlock prone.
> > >
> > > You're taking rtnl_lock().
> > > dpaa2_eth_connect_mac() calls dpaa2_mac_connect().
> > > dpaa2_mac_connect() calls phylink_create().
> > > phylink_create() calls phylink_register_sfp().
> > > phylink_register_sfp() calls sfp_bus_add_upstream().
> > > sfp_bus_add_upstream() calls rtnl_lock() *** DEADLOCK ***.
> >
> > I recently discovered this also when working on adding support for SFPs=
.
> >
> > >
> > > Neither phylink_create() nor phylink_destroy() may be called holding
> > > the rtnl lock.
> > >
> >
> > Just to summarise:
> >
> > * phylink_create() and phylink_destroy() should NOT be called with the
> > rtnl lock held
>=20
> Correct.  However, they are only intended to be called from paths where t=
he
> netdev is *not* registered.
>=20
> > * phylink_disconnect_phy() should be called with the lock
>=20
> Correct.
>=20
> > * depending on when the netdev is registered the
> > phylink_of_phy_connect() may be called with or without the rtnl lock
>=20
> Correct - if it is called _before_ the netdev has been published, then it=
 is safe
> to add the PHY to phylink.  If the netdev has been published, userspace o=
r
> the kernel can manipulate its state, and that's where races can occur - s=
o the
> rtnl lock must be held.
>=20
> > I'll have to move the lock and unlock around the actual _connect() and
> > _disconnect_phy() calls so that even the case where the DPMAC is
> > connected at runtime (the EVENT_ENDPOINT_CHANGED referred above)
> is treated correctly.
>=20
> I am extremely concerned about this, because it appears that you are call=
ing
> phylink_create() and phylink_destroy() for a net device that is published=
.
> That scenario is not in the design scope of phylink.
>=20
> phylink is designed such that it is created before the network device is
> published, and it persists until the network device is destroyed.
> It was never intended to be dynamically created and removed with the
> network device published.

Ok, but is there a limitation which dictates that this cannot be supported?
I am asking this because the 'ls-addni dpmac.17' script that you mentioned
in another email uses dynamic creation and configuration of the DPAA2
resources which would exactly trigger that EVENT.=20

>=20
> Isn't it also true that there isn't a 1:1 mapping between dpni devices an=
d
> dpmac devices?=20

Yes, that is true. There can be more DPNIs (network interfaces) than
DPMACs (physical ports - MAC instances) and also not always the DPMACs
will be connected to DPNIs. More details below.

> In a virtualised setup, isn't it true that each VM can have its
> own dpni device which is connected to a single dpmac device?=20

Yes, it's true. DPNI devices (network interfaces) assigned to a VM can be
connected to DPMAC devices. They also can be connected to other another
DPNI (which would be a veth pair, but offloaded) or to DPSW ports.

> Isn't it also
> true that a single dpni device can be connected to a vitual switch which =
itself
> is connected to several dpmac devices?

First of all, the DPAA2 DPSW object is not a virtual switch but rather WRIO=
P
resources are used in such a way that an offloaded switch is created and co=
nfigured.
Secondly, there is no restriction when it comes to the number of DPNIs
connected to DPSW ports. You can have all DPSW ports connected only to DPNI=
s
assigned to VMs and then you'll have bridging between all VMs but not the e=
xterior.

> An example of that can be seen in Figure 41 of the LX2160A BSP v0.5
> document, where we see an example of two DPMAC objects connected to a
> single DPSW (switch) object, which are then connected to two DPNI objects
> (which are our ethernet interfaces.)  Another example is Figure 49 which =
is
> even more complex.
>=20

In Figure 41 it's described a 4 port switch: 2 of its switch ports are conn=
ected to
physical interfaces (the DPMACs) and the other 2 switch ports are connect t=
o
2 DPNI which are exported to the Linux as network interfaces.
L2 switching happens between all 4 ports.

All in all, I know that DPAA2's flexibility in configuration is a burden so=
metimes,
please let me know if you have any other questions.

Ioana
