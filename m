Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30A18D539
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfHNNp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:45:56 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:57091
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727273AbfHNNpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 09:45:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfACSUTabUl+zEBQrsjPqB6O8VV5czZMysozluYWcv6/uhZVqeyJ9XWz7l+zMODt9DDLy9WDOW9Xqd1bevN/Gg4BM58yecmDonE/xZnob3S8eaZ14iMXjN0+sZHtAs66NM2ZMDNQTZIHMdtxXHQ4XFgR5fBVeD1yiMCJ9zln1RaAc5r0QefWYpQY1PcxmmwodT14MTm22CiW10LWk80pYUo4HbO1QHNYosbrPcUk4Hpy/7Qs0C3cQdMX0NHzeSziYI72Q6W6PEpKQHclLzNJw0wqDE5X4g5Fq3GYx+4tXlp3cdYc/EDxAMqvzLDfKdCRuZmXIKx81ltHN+4f+lxtQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WbovAU8ZzvSQ42b6Z5ZRVm8ibp+YeAmr/cFPLLZv40=;
 b=NnbiPfljHuwK5Cp68Bm/OsqstJ1yKF6RS5Q803AVz+8BsjcD+zMxWKFWRMB8LefTz8uVfyiXn1VlSghqSnZ5CnNGJBAt3NKfYFR70ReliKVNjr3n8G+rqkkBBvPI5fbxAwhxed+1n1PdkzYEWv7LwqaGgej/FGqsJUL4UhswbBWyy7v+rAxI+4hoHvksFvEtWCJ+FjzIKy5u/ssQISq0PoY4zpl8b8Rmuye608Gv/leyrAGoywlfFNclVDOV4YQ9/wmnN9StuUuYCeSJT5/fldiHnsEPtFw/OrAVmRYnjcXRFUpgTgklBg8oPo33XiaCONrQYUyskzHYrw0NuOCQ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WbovAU8ZzvSQ42b6Z5ZRVm8ibp+YeAmr/cFPLLZv40=;
 b=TnZdG0+A0Th1klbo31pMR7yJFjw7KzDh5sWCRKCpao3iUCVQmc8v97hdYJfn8SrfxE7yxkm3NusqwD5xQKUx3pj32VlJ08hBY0Lrymp910UUZ9LjkwVlMcOWGu5xkqt6/vYrBIvyew9Eq8N8Ou446i9BTGXLAoTdfvxDZk87b7g=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6034.eurprd05.prod.outlook.com (20.178.119.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Wed, 14 Aug 2019 13:45:49 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 13:45:49 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNA=
Date:   Wed, 14 Aug 2019 13:45:49 +0000
Message-ID: <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>     <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814100135.1f60aa42.cohuck@redhat.com>
        <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190814150911.296da78c.cohuck@redhat.com>
In-Reply-To: <20190814150911.296da78c.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d5fa842-a929-4403-f7d8-08d720bdb7b8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6034;
x-ms-traffictypediagnostic: AM0PR05MB6034:
x-ms-exchange-purlcount: 6
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6034E56569A54F0A95D29BF4D1AD0@AM0PR05MB6034.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(13464003)(51444003)(7736002)(186003)(74316002)(6916009)(305945005)(33656002)(26005)(7696005)(102836004)(76176011)(476003)(966005)(478600001)(99286004)(446003)(229853002)(6506007)(11346002)(486006)(66066001)(14454004)(316002)(8676002)(256004)(81166006)(8936002)(81156014)(9456002)(53936002)(4326008)(53546011)(14444005)(25786009)(5660300002)(53376002)(54906003)(6246003)(9686003)(3846002)(71190400001)(71200400001)(55016002)(6306002)(55236004)(66946007)(66556008)(66476007)(64756008)(5024004)(6436002)(76116006)(52536014)(2906002)(86362001)(6116002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6034;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z1MEsHliGbb8+k7+6Fc69pP8tBFevasveC6LXWhAmSHQ+BJyv8Cu8F9z5E7FJdQyhtJEJIznCeTu7Jb9fmxN6ZRtdXTe+Vt4yWFU6GDdMQvvowUAdsTiOHmN5zALIRwzcZZdv9BzmSlP2xcXCEL8CGxnrZHpo8KcZWIekMOKBJChrpwvP1yacObAQnZpC9ddaXGT+tBt3D5v+vTjk3xBrb5u20wVjZJluw4VSmspHk8x9zrB7xdC2ixoTP1wFphUIyzkwO75Gy/k24p6IE2Y+7JuZIuTxRPLsjW3E4pi2Sc2OqYp53Jh15hlgsNRsbaJEWSAZlnGWVgatee6fLYx6A2y4f8dZqwRh4bacm7eqdhg4ZkLO/vzTDSeB6ZHfy+rRo+aBiRH6onBDOLM6l0oBTLK9eXBNst2kdRtxPA9BbQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5fa842-a929-4403-f7d8-08d720bdb7b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 13:45:49.7805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DJUfzHia/liSHnTZWW+ZooRUEncxuI8o4e9YtBhsaqeJRRidENIC6gF6PHW41qm4KN8Aqftg24DmstwWfiTP0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Wednesday, August 14, 2019 6:39 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia@nvidia.com; Jiri Pirko <jiri@mellanox.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Wed, 14 Aug 2019 12:27:01 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > + Jiri, + netdev
> > To get perspective on the ndo->phys_port_name for the representor netde=
v
> of mdev.
> >
> > Hi Cornelia,
> >
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Wednesday, August 14, 2019 1:32 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> > > <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; cjia@nvidia.com
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Wed, 14 Aug 2019 05:54:36 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > > I get that part. I prefer to remove the UUID itself from the
> > > > > > structure and therefore removing this API makes lot more sense?
> > > > >
> > > > > Mdev and support tools around mdev are based on UUIDs because
> > > > > it's
> > > defined
> > > > > in the documentation.
> > > > When we introduce newer device naming scheme, it will update the
> > > documentation also.
> > > > May be that is the time to move to .rst format too.
> > >
> > > You are aware that there are existing tools that expect a uuid
> > > naming scheme, right?
> > >
> > Yes, Alex mentioned too.
> > The good tool that I am aware of is [1], which is 4 months old. Not sur=
e if it is
> part of any distros yet.
> >
> > README also says, that it is in 'early in development. So we have scope=
 to
> improve it for non UUID names, but lets discuss that more below.
>=20
> The up-to-date reference for mdevctl is
> https://github.com/mdevctl/mdevctl. There is currently an effort to get t=
his
> packaged in Fedora.
>=20
Awesome.

> >
> > > >
> > > > > I don't think it's as simple as saying "voila, UUID dependencies
> > > > > are removed, users are free to use arbitrary strings".  We'd
> > > > > need to create some kind of naming policy, what characters are
> > > > > allows so that we can potentially expand the creation parameters
> > > > > as has been proposed a couple times, how do we deal with
> > > > > collisions and races, and why should we make such a change when
> > > > > a UUID is a perfectly reasonable devices name.  Thanks,
> > > > >
> > > > Sure, we should define a policy on device naming to be more relaxed=
.
> > > > We have enough examples in-kernel.
> > > > Few that I am aware of are netdev (vxlan, macvlan, ipvlan, lot
> > > > more), rdma
> > > etc which has arbitrary device names and ID based device names.
> > > >
> > > > Collisions and race is already taken care today in the mdev core.
> > > > Same
> > > unique device names continue.
> > >
> > > I'm still completely missing a rationale _why_ uuids are supposedly
> > > bad/restricting/etc.
> > There is nothing bad about uuid based naming.
> > Its just too long name to derive phys_port_name of a netdev.
> > In details below.
> >
> > For a given mdev of networking type, we would like to have
> > (a) representor netdevice [2]
> > (b) associated devlink port [3]
> >
> > Currently these representor netdevice exist only for the PCIe SR-IOV VF=
s.
> > It is further getting extended for mdev without SR-IOV.
> >
> > Each of the devlink port is attached to representor netdevice [4].
> >
> > This netdevice phys_port_name should be a unique derived from some
> property of mdev.
> > Udev/systemd uses phys_port_name to derive unique representor netdev
> name.
> > This netdev name is further use by orchestration and switching software=
 in
> user space.
> > One such distro supported switching software is ovs [4], which relies o=
n the
> persistent device name of the representor netdevice.
>=20
> Ok, let me rephrase this to check that I understand this correctly. I'm n=
ot sure
> about some of the terms you use here (even after looking at the linked
> doc/code), but that's probably still ok.
>=20
> We want to derive an unique (and probably persistent?) netdev name so tha=
t
> userspace can refer to a representor netdevice. Makes sense.
> For generating that name, udev uses the phys_port_name (which represents
> the devlink port, IIUC). Also makes sense.
>=20
You understood it correctly.

> >
> > phys_port_name has limitation to be only 15 characters long.
> > UUID doesn't fit in phys_port_name.
>=20
> Understood. But why do we need to derive the phys_port_name from the mdev
> device name? This netdevice use case seems to be just one use case for us=
ing
> mdev devices? If this is a specialized mdev type for this setup, why not =
just
> expose a shorter identifier via an extra attribute?
>=20
Representor netdev, represents mdev's switch port (like PCI SRIOV VF's swit=
ch port).
So user must be able to relate this two objects in similar manner as SRIOV =
VFs.
Phys_port_name is derived from the PCI PF and VF numbering scheme.
Similarly mdev's such port should be derived from mdev's id/name/attribute.

> > Longer UUID names are creating snow ball effect, not just in networking=
 stack
> but many user space tools too.
>=20
> This snowball effect mainly comes from the device name -> phys_port_name
> setup, IIUC.
>=20
Right.

> > (as opposed to recently introduced mdevctl, are they more mdev tools
> > which has dependency on UUID name?)
>=20
> I am aware that people have written scripts etc. to manage their mdevs.
> Given that the mdev infrastructure has been around for quite some time, I=
'd
> say the chance of some of those scripts relying on uuid names is non-zero=
.
>=20
Ok. but those scripts have never managed networking devices.
So those scripts won't break because they will always create mdev devices u=
sing UUID.
When they use these new networking devices, they need more things than thei=
r scripts.
So user space upgrade for such mixed mode case is reasonable.

> >
> > Instead of mdev subsystem creating such effect, one option we are
> considering is to have shorter mdev names.
> > (Similar to netdev, rdma, nvme devices).
> > Such as mdev1, mdev2000 etc.
> >
> > Second option I was considering is to have an optional alias for UUID b=
ased
> mdev.
> > This name alias is given at time of mdev creation.
> > Devlink port's phys_port_name is derived out of this shorter mdev name
> alias.
> > This way, mdev remains to be UUID based with optional extension.
> > However, I prefer first option to relax mdev naming scheme.
>=20
> Actually, I think that second option makes much more sense, as you avoid
> potentially breaking existing tooling.
Let's first understand of what exactly will break with existing tool if the=
y see non_uuid based device.
>=20
Existing tooling continue to work with UUID devices.
Do you have example of what can break if they see non_uuid based device nam=
e?
I think you are clear, but to be sure, UUID based creation will continue to=
 be there. Optionally mdev will be created with alpha-numeric string, if we=
 don't it as additional attribute.

> >
> > > We want to uniquely identify a device, across different types of
> > > vendor drivers. An uuid is a unique identifier and even a
> > > well-defined one. Tools (e.g. mdevctl) are relying on it for mdev dev=
ices
> today.
> > >
> > > What is the problem you're trying to solve?
> > Unique device naming is still achieved without UUID scheme by various
> subsystems in kernel using alpha-numeric string.
> > Having such string based continue to provide unique names.
> >
> > I hope I described the problem and two solutions above.
> >
> > [1] https://github.com/awilliam/mdevctl
> > [2]
> > https://elixir.bootlin.com/linux/v5.3-rc4/source/drivers/net/ethernet/
> > mellanox/mlx5/core/en_rep.c [3]
> > http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > [4]
> > https://elixir.bootlin.com/linux/v5.3-rc4/source/net/core/devlink.c#L6
> > 921
> > [5] https://www.openvswitch.org/
> >

