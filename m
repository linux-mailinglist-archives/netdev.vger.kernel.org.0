Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D255F3D91
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfKHBo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:44:59 -0500
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:5782
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbfKHBo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 20:44:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQCWYJg1P2lrI9a8Xd/rY0a0Qp6D01QVQZJVSrDSn774TUWbwSTYlghaqoQHM2RLxR62KsfGNg9weg6FM8XS7olmWV3Ge2GgpXnzPriK0ak+Dkkmpr7O1LXgERfRVruoZEBBRYZMuSmXkZhIHrCB9abV/rLJUp5UuPyW6zaIqRdARK6fB6c5cipT9ZUvmm2XPP5mylplTupJqluW9174Tny9H0Dkc6RcfOUWyyiTJyoqQFOqwA0SwbdsK/uPqjENCrrNwv1I4URrAzfLYXMZpgHGBSSazWBsp/wCv8XvLYN2aTMp2MU7aO5mzlF0EWjcZXopSkwBmPI7FLwL0VvXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLFeuXeXcpeKU+QC6hnlYaCqiQt9dKr0rftNTY/oHHI=;
 b=i+RWZjASJt83q5dSt5hGVjj34CRD/7ZTSiCP1V/vjqh1aEP4HdscIyVvptAHHGLCKTlls9yRjoA0x2fe+PFb0ucwDKm2Pj7rWYAxImHvkRJX67FQ6/Qwsz4y+wcmxOvG8Bsw77rakxClaTNC4wkrmq22/p+QIloVFhhJziCSO0zU82RIpV29EV2KRxjFJOuAJogJ+Vw43G/F57Nfm2cP9umIlZZSmrFuUl5dIFzwLIBGkXvs4WCp6xVlqqYTnkFDZgdwoZ6YreX37NLx0VcMz1zCBu89u1CXQwUN65iPRr+I3oQj6jALPYhd4VYCtxl+QJj7Bh74cfltfEAXbF6r/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLFeuXeXcpeKU+QC6hnlYaCqiQt9dKr0rftNTY/oHHI=;
 b=g1CPh6eB7tVp6C4TGXITlDzTgiaKJyqDY/xhcXdehVXwA41iXk0zNCCLPk4ADAvYKyQXU2je1994WDdrGQjOJamDMisjg+o5CwaeW9Vya8KfmoGQcwi9EauluEOyZN0WA+UV9aP/U8Z0Wcxl8TALGwq4EscB+Vq10okkVmy5LwA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4642.eurprd05.prod.outlook.com (52.133.57.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 01:44:53 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 01:44:53 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Topic: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+g
Date:   Fri, 8 Nov 2019 01:44:53 +0000
Message-ID: <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-12-parav@mellanox.com>
        <20191107153836.29c09400@cakuba.netronome.com>
        <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
In-Reply-To: <20191107201750.6ac54aed@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:4df9:9131:e74:fff7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ff03bb7b-e24e-4587-acb4-08d763ed4054
x-ms-traffictypediagnostic: AM0PR05MB4642:|AM0PR05MB4642:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4642EA7C483C214D35FDEB5CD17B0@AM0PR05MB4642.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(13464003)(189003)(199004)(316002)(71200400001)(6116002)(52536014)(478600001)(74316002)(25786009)(71190400001)(305945005)(81166006)(81156014)(7736002)(8676002)(2906002)(55016002)(99286004)(6436002)(11346002)(5660300002)(186003)(8936002)(14454004)(6506007)(6916009)(446003)(6246003)(76176011)(86362001)(33656002)(9686003)(486006)(7696005)(76116006)(66946007)(53546011)(4326008)(476003)(64756008)(54906003)(102836004)(66476007)(66446008)(229853002)(66556008)(46003)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4642;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ykiqZ9bdIpy6QQR1SJ9rdX7K/RpJiJ/P3FaXkgaPjIDg7OIHtIju7zOl0TyMJJ5z+Br7abqqnJF/B3fezOcOCjQsTcNs4BlDYB4LoR++s0dT7C8sX+oN2TSlEZRpSDqCHjfoRM7E0JQzkOx2+YFmj9ZTtqbLcPrER9Aw1OTlu4UzZ9rXUrtzCcpID4f0PoRyewME/bE+1VQvOmWXmQwJfQiRCxXScMV+HXoQXPM+r/dWndzAne/u5DMWZFdmlPHaFKkOdzysuAJlwqHH6OTbaZyYl2deYUlI2K2IKeRC07dmwl0cf/P7wSyJV+gHziQQl+EF9GvPLEnpOrwGTtrtItUENCS0mLrfRbQd1ZownxZKY91xZcRU4jYjNXoq94vmOS47zBd/CSEtc6mvO+NbV7v1EfHu3NI9AivOV446lUSaHN8xKZSXV/JU+6v+esE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff03bb7b-e24e-4587-acb4-08d763ed4054
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 01:44:53.2255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gOwX4rjebEfNQXlYMzR/skHbcXEZd/aiDS/oJXvg1K3ezcfPoM4Pv47B2bAYLExWLa9fc6y3SrFtysyH3ezSmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4642
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, November 7, 2019 7:18 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>=20
> On Thu, 7 Nov 2019 21:03:09 +0000, Parav Pandit wrote:
> > > Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port
> > > flavour
> > >
> > > On Thu,  7 Nov 2019 10:08:27 -0600, Parav Pandit wrote:
> > > > Introduce a new mdev port flavour for mdev devices.
> > > > PF.
> > > > Prepare such port's phys_port_name using unique mdev alias.
> > > >
> > > > An example output for eswitch ports with one physical port and one
> > > > mdev port:
> > > >
> > > > $ devlink port show
> > > > pci/0000:06:00.0/65535: type eth netdev p0 flavour physical port 0
> > > > pci/0000:06:00.0/32768: type eth netdev p1b0348cf880a flavour mdev
> > > > alias 1b0348cf880a
> > >
> > > Surely those devices are anchored in on of the PF (or possibly VFs)
> > > that should be exposed here from the start.
> > >
> > They are anchored to PCI device in this implementation and all mdev
> device has their parent device too.
> > However mdev devices establishes their unique identity at system level
> using unique UUID.
> > So prefixing it with pf0, will shorten the remaining phys_port_name let=
ter
> we get to use.
> > Since we get unique 12 letters alias in a system for each mdev, prefixi=
ng it
> with pf/vf is redundant.
> > In case of VFs, given the VF numbers can repeat among multiple PFs, and
> representor can be over just one eswitch instance, it was necessary to pr=
efix.
> > Mdev's devices parent PCI device is clearly seen in the PCI sysfs hiera=
rchy,
> so don't prefer to duplicate it.
>=20
> I'm talking about netlink attributes. I'm not suggesting to sprintf it al=
l into
> the phys_port_name.
>
I didn't follow your comment. For devlink port show command output you said=
,

"Surely those devices are anchored in on of the PF (or possibly VFs) that s=
hould be exposed here from the start."
=20
So I was trying to explain why we don't expose PF/VF detail in the port att=
ributes which contains=20
(a) flavour
(b) netdev representor (name derived from phys_port_name)
(c) mdev alias

Can you please describe which netlink attribute I missed?

> > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > >
> > > > @@ -6649,6 +6678,9 @@ static int
> > > __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
> > > >  		n =3D snprintf(name, len, "pf%uvf%u",
> > > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
> > > >  		break;
> > > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
> > > > +		n =3D snprintf(name, len, "p%s", attrs->mdev.mdev_alias);
> > >
> > > Didn't you say m$alias in the cover letter? Not p$alias?
> > >
> > In cover letter I described the naming scheme for the netdevice of the
> > mdev device (not the representor). Representor follows current unique
> > phys_port_name method.
>=20
> So we're reusing the letter that normal ports use?
>
I initially had 'm' as prefix to make it easy to recognize as mdev's port, =
instead of 'p', but during internal review Jiri's input was to just use 'p'=
.
=20
> Why does it matter to name the virtualized device? In case of other reprs=
 its
> the repr that has the canonical name, in case of containers and VMs they
> will not care at all what hypervisor identifier the device has.
>=20
Well, many orchestration framework probably won't care of what name is pick=
ed up.
And such name will likely get renamed to eth0 in VM or container.
Unlike vxlan, macvlan interfaces, user explicitly specify the netdevice nam=
e, and when newlink() netlink command completes with success, user know the=
 device to use.
If we don't have persistent name for mdev, if a random name ethX is picked =
up, user needs refer to sysfs device hierarchy to know its netdev.
Its super easy to do refer that, but having persistent name based out of al=
ias makes things aligned like naming device on PCI bus.
This way devices can be used without VM/container use cases too, for exampl=
e user is interested in only 4 or 8 mdev devices in system and its setup is=
 done through systemd.service.



> > > > +		break;
> > > >  	}
> > > >
> > > >  	if (n >=3D len)
