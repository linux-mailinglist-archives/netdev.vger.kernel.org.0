Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7518D7EE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfHNQVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:21:18 -0400
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:3775
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfHNQVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 12:21:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjEK+pY+iBt7D35f33Jkn5dFXEaAiBUHQIWiexH79Laa2PtJdLxRT6NFSvgqzXZBhO+zpEExOZ6hmyYPQOnTek7l3WEdBROH6VENIwuPuP7MLbQobNJ4VsCEboSMLrmm/xj/HcaYzUDPCda7guVhcPRmgS0GSUH7r1XGTA9YDFiraaozJ8htpqLH+Ff9kZRH0Fl51Mfdp5f501icuNtR7J6sWDqeXDkQT5uyoboVL4m1n5hoVc4lYoKUT67OyBjA5sBy0nXalYfrIAp33usyyC4O9fTzfCIXj96KTYxVJeT5IqwLUFz4nsh78f7JBWBJefOqpTBLJU1yC1PafYXe3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEkcRxHd4+AvYeoQA3kVlWM/FJuHEt16Om8wV4RvWiI=;
 b=nt18PIF4v2xh5PRV7J5kgDPJUmcpStnHOvn31I8sYtRXgwtpLikdXg4goSpeASVHaJnVGlKdhXsDfPLQHgj3ehP4oP/JmcpfdZGXkdKbu85vgU2Ccm3CL1nDDsDhGE2Cbnwy1+wcju3+z7K9Dy1RkUtjYMFrSzzk2uJ72EABAylrxCgNnN4s+jjL2cUcmX+tO+H1Nt/dxR7kY5mpjegZfc3IDEDBFXd8ZTk9Y6vOlDXCPtykgUgTCZHtpV/8Ls+y3AuYQRKWJPlNzR9KNk4c4p0HEaqSz5aXcSJClClH1b4INy4lrfjCxEywbQDfkNxmdDAfvm1p8fOkeUjAD8fzpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEkcRxHd4+AvYeoQA3kVlWM/FJuHEt16Om8wV4RvWiI=;
 b=gK1gY3iAMnZ+s/s4owMqhvTYpHwb+anuWywb6fyY0iM0bQkr3+toyWtkM6WB3XNyOfiCcItvBsTYLVOzT9ecJR76xYpWdOl+5OPSD0c5puLhRtxbPxUqhAXJFIwuafg6u8PO9sp/KAenCMaToy3aQaGdZYmXLMguysykNBiZhk8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6546.eurprd05.prod.outlook.com (20.179.32.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Wed, 14 Aug 2019 16:21:11 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 16:21:11 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcw
Date:   Wed, 14 Aug 2019 16:21:11 +0000
Message-ID: <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
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
        <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190814085746.26b5f2a3@x1.home>
In-Reply-To: <20190814085746.26b5f2a3@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3063b297-a0fa-4a3d-296d-08d720d36be0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB6546;
x-ms-traffictypediagnostic: AM0PR05MB6546:
x-ms-exchange-purlcount: 6
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6546A0E9BA661A554C49AA41D1AD0@AM0PR05MB6546.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(13464003)(51444003)(199004)(189003)(52536014)(3846002)(66066001)(9456002)(6116002)(186003)(33656002)(74316002)(305945005)(2906002)(26005)(71190400001)(316002)(7736002)(71200400001)(8676002)(30864003)(54906003)(7696005)(966005)(81156014)(66946007)(6506007)(53376002)(6246003)(53546011)(446003)(4326008)(55236004)(14454004)(102836004)(5660300002)(81166006)(11346002)(8936002)(25786009)(5024004)(256004)(14444005)(6916009)(76176011)(486006)(64756008)(66556008)(66476007)(478600001)(76116006)(6306002)(9686003)(6436002)(99286004)(55016002)(86362001)(66446008)(476003)(229853002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6546;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R23B3zmTclYepdgvoAVJpkPfEbQElPGL2LoE+Ci1783yZuav4eDkVnRJ0NSoyeG2bsOb1x274Js4aaqrXALeCWPi8HwjtyT9aM3lJvxKKvMbP6zl6a3TiqvAH++SctavSH1GDm+xQeQ44uj1ToqFU/PO2RJlEZ26yGAvADEIuDThMsx8aTTUKh+4UjZtQodllVqpPjyc2kkafL2oNGyhPq5aL+tbuHCAN3hF1JZOYT9ftnnrqTLoC+qwlewDat8saUgji5EzR30a81DFHRU5akmXXjYt+fA5D2EUZn3ID0jPWVzghXpBk/GKMn5Bjrk43C/BEjUDYkFarA6n305ahIcryD8GRLH9vxdDJzYPPxbPzRTtIe8qRoaoEIlTy67JKhn8ERXpCYIRS9MRb+fqFEu3d6u6mGhuQp8+FtlUtKw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3063b297-a0fa-4a3d-296d-08d720d36be0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 16:21:11.4706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XTnmANyaco1poVAj7icdqfX2cdhRn4be9wZWWfilNsNnEA9SGGw5rZYGhhlYAU2cY75t7rrLstdasOfQWLEVBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6546
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, August 14, 2019 8:28 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia@nvidia.com; Jiri Pirko <jiri@mellanox.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Wed, 14 Aug 2019 13:45:49 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Wednesday, August 14, 2019 6:39 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> > > <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; cjia@nvidia.com; Jiri Pirko
> > > <jiri@mellanox.com>; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Wed, 14 Aug 2019 12:27:01 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > + Jiri, + netdev
> > > > To get perspective on the ndo->phys_port_name for the representor
> > > > netdev
> > > of mdev.
> > > >
> > > > Hi Cornelia,
> > > >
> > > > > -----Original Message-----
> > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > Sent: Wednesday, August 14, 2019 1:32 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> > > > > <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > > > > kernel@vger.kernel.org; cjia@nvidia.com
> > > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >
> > > > > On Wed, 14 Aug 2019 05:54:36 +0000 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >
> > > > > > > > I get that part. I prefer to remove the UUID itself from
> > > > > > > > the structure and therefore removing this API makes lot mor=
e
> sense?
> > > > > > >
> > > > > > > Mdev and support tools around mdev are based on UUIDs
> > > > > > > because it's
> > > > > defined
> > > > > > > in the documentation.
> > > > > > When we introduce newer device naming scheme, it will update
> > > > > > the
> > > > > documentation also.
> > > > > > May be that is the time to move to .rst format too.
> > > > >
> > > > > You are aware that there are existing tools that expect a uuid
> > > > > naming scheme, right?
> > > > >
> > > > Yes, Alex mentioned too.
> > > > The good tool that I am aware of is [1], which is 4 months old.
> > > > Not sure if it is
> > > part of any distros yet.
> > > >
> > > > README also says, that it is in 'early in development. So we have
> > > > scope to
> > > improve it for non UUID names, but lets discuss that more below.
> > >
> > > The up-to-date reference for mdevctl is
> > > https://github.com/mdevctl/mdevctl. There is currently an effort to
> > > get this packaged in Fedora.
> > >
> > Awesome.
> >
> > > >
> > > > > >
> > > > > > > I don't think it's as simple as saying "voila, UUID
> > > > > > > dependencies are removed, users are free to use arbitrary
> > > > > > > strings".  We'd need to create some kind of naming policy,
> > > > > > > what characters are allows so that we can potentially expand
> > > > > > > the creation parameters as has been proposed a couple times,
> > > > > > > how do we deal with collisions and races, and why should we
> > > > > > > make such a change when a UUID is a perfectly reasonable
> > > > > > > devices name.  Thanks,
> > > > > > >
> > > > > > Sure, we should define a policy on device naming to be more rel=
axed.
> > > > > > We have enough examples in-kernel.
> > > > > > Few that I am aware of are netdev (vxlan, macvlan, ipvlan, lot
> > > > > > more), rdma
> > > > > etc which has arbitrary device names and ID based device names.
> > > > > >
> > > > > > Collisions and race is already taken care today in the mdev cor=
e.
> > > > > > Same
> > > > > unique device names continue.
> > > > >
> > > > > I'm still completely missing a rationale _why_ uuids are
> > > > > supposedly bad/restricting/etc.
> > > > There is nothing bad about uuid based naming.
> > > > Its just too long name to derive phys_port_name of a netdev.
> > > > In details below.
> > > >
> > > > For a given mdev of networking type, we would like to have
> > > > (a) representor netdevice [2]
> > > > (b) associated devlink port [3]
> > > >
> > > > Currently these representor netdevice exist only for the PCIe SR-IO=
V VFs.
> > > > It is further getting extended for mdev without SR-IOV.
> > > >
> > > > Each of the devlink port is attached to representor netdevice [4].
> > > >
> > > > This netdevice phys_port_name should be a unique derived from some
> > > property of mdev.
> > > > Udev/systemd uses phys_port_name to derive unique representor
> > > > netdev
> > > name.
> > > > This netdev name is further use by orchestration and switching
> > > > software in
> > > user space.
> > > > One such distro supported switching software is ovs [4], which
> > > > relies on the
> > > persistent device name of the representor netdevice.
> > >
> > > Ok, let me rephrase this to check that I understand this correctly.
> > > I'm not sure about some of the terms you use here (even after
> > > looking at the linked doc/code), but that's probably still ok.
> > >
> > > We want to derive an unique (and probably persistent?) netdev name
> > > so that userspace can refer to a representor netdevice. Makes sense.
> > > For generating that name, udev uses the phys_port_name (which
> > > represents the devlink port, IIUC). Also makes sense.
> > >
> > You understood it correctly.
> >
> > > >
> > > > phys_port_name has limitation to be only 15 characters long.
> > > > UUID doesn't fit in phys_port_name.
> > >
> > > Understood. But why do we need to derive the phys_port_name from the
> > > mdev device name? This netdevice use case seems to be just one use
> > > case for using mdev devices? If this is a specialized mdev type for
> > > this setup, why not just expose a shorter identifier via an extra att=
ribute?
> > >
> > Representor netdev, represents mdev's switch port (like PCI SRIOV VF's =
switch
> port).
> > So user must be able to relate this two objects in similar manner as SR=
IOV
> VFs.
> > Phys_port_name is derived from the PCI PF and VF numbering scheme.
> > Similarly mdev's such port should be derived from mdev's id/name/attrib=
ute.
> >
> > > > Longer UUID names are creating snow ball effect, not just in
> > > > networking stack
> > > but many user space tools too.
> > >
> > > This snowball effect mainly comes from the device name ->
> > > phys_port_name setup, IIUC.
> > >
> > Right.
> >
> > > > (as opposed to recently introduced mdevctl, are they more mdev
> > > > tools which has dependency on UUID name?)
> > >
> > > I am aware that people have written scripts etc. to manage their mdev=
s.
> > > Given that the mdev infrastructure has been around for quite some
> > > time, I'd say the chance of some of those scripts relying on uuid nam=
es is
> non-zero.
> > >
> > Ok. but those scripts have never managed networking devices.
> > So those scripts won't break because they will always create mdev devic=
es
> using UUID.
> > When they use these new networking devices, they need more things than
> their scripts.
> > So user space upgrade for such mixed mode case is reasonable.
>=20
> Tools like mdevctl are agnostic of the type of mdev device they're managi=
ng, it
> shouldn't matter than they've never managed a networking mdev previously,=
 it
> follows the standards of mdev management.
>=20
> > > >
> > > > Instead of mdev subsystem creating such effect, one option we are
> > > considering is to have shorter mdev names.
> > > > (Similar to netdev, rdma, nvme devices).
> > > > Such as mdev1, mdev2000 etc.
>=20
> Note that these are kernel generated names, as are the other examples.
No. I probably gave the wrong examples.
Mdev user provided names can be 'foo', 'bar', 'foo1'.

> In the case of mdev, the user is providing the UUID, which becomes the de=
vice
> name.  When a user writes to the create attribute, there needs to be
> determinism that the user can identify the device they created vs another=
 that
> may have been created concurrently.  I don't see that we can put users in=
 the
> path of managing device instance numbers.
No. Its just user provided names.

>=20
> > > > Second option I was considering is to have an optional alias for
> > > > UUID based
> > > mdev.
> > > > This name alias is given at time of mdev creation.
> > > > Devlink port's phys_port_name is derived out of this shorter mdev
> > > > name
> > > alias.
> > > > This way, mdev remains to be UUID based with optional extension.
> > > > However, I prefer first option to relax mdev naming scheme.
> > >
> > > Actually, I think that second option makes much more sense, as you
> > > avoid potentially breaking existing tooling.
> > Let's first understand of what exactly will break with existing tool
> > if they see non_uuid based device.
>=20
> Do we really want a mixed namespace of device names, some UUID, some...
> something else?  That seems like a mess.
>=20
So you prefer alias as an attribute? If so, it should be an optional additi=
onal parameter during create time,=20
because it is desired to not invent new callbacks for such attributes setti=
ng and (and rewrite them).

> > Existing tooling continue to work with UUID devices.
> > Do you have example of what can break if they see non_uuid based
> > device name? I think you are clear, but to be sure, UUID based
> > creation will continue to be there. Optionally mdev will be created
> > with alpha-numeric string, if we don't it as additional attribute.
>=20
> I'm not onboard with a UUID being just one of the possible naming strings=
 via
> which we can create mdev devices.  I think that becomes untenable for
> userspace.  I don't think a sufficient argument has been made against the=
 alias
> approach, which seems to keep the UUID as a canonical name, providing a
> consistent namespace, augmented with user or kernel provided short alias.
> Thanks,
>=20
If I understand you correctly, you prefer alias name approach to keep UUID =
naming scheme intact in mdev?

> Alex
>=20
> > > >
> > > > > We want to uniquely identify a device, across different types of
> > > > > vendor drivers. An uuid is a unique identifier and even a
> > > > > well-defined one. Tools (e.g. mdevctl) are relying on it for
> > > > > mdev devices
> > > today.
> > > > >
> > > > > What is the problem you're trying to solve?
> > > > Unique device naming is still achieved without UUID scheme by
> > > > various
> > > subsystems in kernel using alpha-numeric string.
> > > > Having such string based continue to provide unique names.
> > > >
> > > > I hope I described the problem and two solutions above.
> > > >
> > > > [1] https://github.com/awilliam/mdevctl
> > > > [2]
> > > > https://elixir.bootlin.com/linux/v5.3-rc4/source/drivers/net/ether
> > > > net/
> > > > mellanox/mlx5/core/en_rep.c [3]
> > > > http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > > [4]
> > > > https://elixir.bootlin.com/linux/v5.3-rc4/source/net/core/devlink.
> > > > c#L6
> > > > 921
> > > > [5] https://www.openvswitch.org/
> > > >
> >

