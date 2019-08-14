Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DD08D30B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfHNM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:27:06 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:39557
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbfHNM1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 08:27:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjKqaZec+++GCyadpv4haadvTNtbMIK+cx/Ev8GBINdm0kGXEYNSDntlqCTueW9MZ6EBrlIYGgxUcVnE90CZgenvm2tzfQL1pIXX/7hPpq9KmN1co7vKJCj7s9+cGM8U7832KBO+OtjnN3qVTftbrbnLyEULqKEr3UixVLzmxopsihgNTW2Qr9tDdBnyK7YFqzQ3dUzAAlk6x5L3rPsXBezYGeT9MdJ3IA0aK2f0C0zrg661v23zQSOlSAIqXa959VLTdDjjOoGAyt3mUBa7tK67+2JwMCzafsOcaNGU8lGIyBCNiz2aw6nCrn/vouLTxYaIyoCyGgk1/m0WxfFOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikttV7Z3xUdlf4A2pFSvIml7n1WUx8qqqhD+aktOHas=;
 b=Dlpq0zOQ1KSifrSM31AfURp7jmdxLusjnwEDeJiCoXzUvaURTeRUO0+/UwDXe2LmUrHHVeKe2OQGPV7ilHjHm/GAqOVu6rRIe9NMRqmEK1/M4+wgc5y+58fOa/cS76xmA2eHqONhiHipIG23AhBFXJisTT3fau2EspGKcROykz/Ci45g2WSbNhCHQoYGAbRi4v+mnGUypIpuurseFPMPEUl4yFYUf5/L1qO4+YgGoeYQT0+pmwqr3dg9YSbzXvNAVeCOYBdsrjmRLkJxJ8H/HKFFyL41h9Oob5d4KTIVIOlygryPgsR7o2hrs8mDxwy+1YHx7ghzPzsU+I9IY103CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikttV7Z3xUdlf4A2pFSvIml7n1WUx8qqqhD+aktOHas=;
 b=MTH8STcYsDXsw34xhZOd9sgb8QvOGHNm0N/ql07j4Rcdsi0ZRo6EQBgEJTa0umTDeG2pfE2F7BQO8m6n+Nkg7z9uc0qGJbdXUr98x3FJRz8Tfax/le19ILulXossX1E9Mv8hmdKd+R9Upz87NEqjt5gTQRzsHxQNBHlThAhl5Kk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5731.eurprd05.prod.outlook.com (20.178.115.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Wed, 14 Aug 2019 12:27:01 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 12:27:01 +0000
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
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQA==
Date:   Wed, 14 Aug 2019 12:27:01 +0000
Message-ID: <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>     <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190814100135.1f60aa42.cohuck@redhat.com>
In-Reply-To: <20190814100135.1f60aa42.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5733d9ca-2c7f-4756-fa10-08d720b2b53e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB5731;
x-ms-traffictypediagnostic: AM0PR05MB5731:
x-ms-exchange-purlcount: 5
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5731FFC5EB92A22C821372E3D1AD0@AM0PR05MB5731.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(13464003)(199004)(189003)(54906003)(6306002)(6436002)(486006)(6116002)(4326008)(446003)(316002)(478600001)(11346002)(55016002)(14454004)(6246003)(71190400001)(476003)(71200400001)(186003)(25786009)(9686003)(2906002)(3846002)(53936002)(256004)(5024004)(966005)(14444005)(26005)(53376002)(81156014)(81166006)(8936002)(5660300002)(74316002)(52536014)(66066001)(305945005)(7736002)(86362001)(9456002)(6916009)(53546011)(6506007)(229853002)(55236004)(33656002)(64756008)(66476007)(8676002)(76116006)(102836004)(66446008)(66946007)(66556008)(99286004)(7696005)(76176011)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5731;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NXFWb0G0O9FKe+GyGlAXRg7qVr3dOQPRE/tqaU1xL6tQw75DeK6nhHHUaHB2x493iYv0P2XEkSw5hf9qPVE343NxeALIQK6CiL4B+h95i6lsQc+x7eMJ76oGoMIsErYQPw+u50y7COIF7lIEyelxg0+E/qB4lm9fbadfYB8lilMA1QLuTycg7fMSlMTwT5OR7VGmFG2a4RfMVw/87n5wwPusz4Y9+qZR6Zm6XL0Ft+QVCN29FLdfcek9kr8fKAMY4KrcF+9kSfVruVA3hP3nJHuioNS1eB7rtzLo0gOSLDikeR8zUbSlyxe7hViTZQvYi/VU9tUxsPaiIjmmC+HKndl3GtCFHV/G4OSXxmR3sMjyviRSBdkE7tm1+vjmrV+NMKYbshfFUrX6CIsiyI18zOzNhX4uP89CVZCRWP0R4Ek=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5733d9ca-2c7f-4756-fa10-08d720b2b53e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 12:27:01.2076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nz3wiugbjL56ViAqT1cVScrcsNFpKWXWQcZTlGPtgBUrfALX+F3DJ5nBXZrWZ5xLDxjpae+1S/dDZqw7nc9Grg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Jiri, + netdev=20
To get perspective on the ndo->phys_port_name for the representor netdev of=
 mdev.

Hi Cornelia,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Wednesday, August 14, 2019 1:32 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia@nvidia.com
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Wed, 14 Aug 2019 05:54:36 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > > I get that part. I prefer to remove the UUID itself from the
> > > > structure and therefore removing this API makes lot more sense?
> > >
> > > Mdev and support tools around mdev are based on UUIDs because it's
> defined
> > > in the documentation.
> > When we introduce newer device naming scheme, it will update the
> documentation also.
> > May be that is the time to move to .rst format too.
>=20
> You are aware that there are existing tools that expect a uuid naming sch=
eme,
> right?
>=20
Yes, Alex mentioned too.
The good tool that I am aware of is [1], which is 4 months old. Not sure if=
 it is part of any distros yet.

README also says, that it is in 'early in development. So we have scope to =
improve it for non UUID names, but lets discuss that more below.

> >
> > > I don't think it's as simple as saying "voila, UUID dependencies are
> > > removed, users are free to use arbitrary strings".  We'd need to
> > > create some kind of naming policy, what characters are allows so
> > > that we can potentially expand the creation parameters as has been
> > > proposed a couple times, how do we deal with collisions and races,
> > > and why should we make such a change when a UUID is a perfectly
> > > reasonable devices name.  Thanks,
> > >
> > Sure, we should define a policy on device naming to be more relaxed.
> > We have enough examples in-kernel.
> > Few that I am aware of are netdev (vxlan, macvlan, ipvlan, lot more), r=
dma
> etc which has arbitrary device names and ID based device names.
> >
> > Collisions and race is already taken care today in the mdev core. Same
> unique device names continue.
>=20
> I'm still completely missing a rationale _why_ uuids are supposedly
> bad/restricting/etc.
There is nothing bad about uuid based naming.
Its just too long name to derive phys_port_name of a netdev.
In details below.

For a given mdev of networking type, we would like to have=20
(a) representor netdevice [2]=20
(b) associated devlink port [3]

Currently these representor netdevice exist only for the PCIe SR-IOV VFs.
It is further getting extended for mdev without SR-IOV.

Each of the devlink port is attached to representor netdevice [4].

This netdevice phys_port_name should be a unique derived from some property=
 of mdev.
Udev/systemd uses phys_port_name to derive unique representor netdev name.
This netdev name is further use by orchestration and switching software in =
user space.
One such distro supported switching software is ovs [4], which relies on th=
e persistent device name of the representor netdevice.

phys_port_name has limitation to be only 15 characters long.
UUID doesn't fit in phys_port_name.
Longer UUID names are creating snow ball effect, not just in networking sta=
ck but many user space tools too.
(as opposed to recently introduced mdevctl, are they more mdev tools which =
has dependency on UUID name?)

Instead of mdev subsystem creating such effect, one option we are consideri=
ng is to have shorter mdev names.
(Similar to netdev, rdma, nvme devices).
Such as mdev1, mdev2000 etc.

Second option I was considering is to have an optional alias for UUID based=
 mdev.
This name alias is given at time of mdev creation.
Devlink port's phys_port_name is derived out of this shorter mdev name alia=
s.
This way, mdev remains to be UUID based with optional extension.
However, I prefer first option to relax mdev naming scheme.

> We want to uniquely identify a device, across different
> types of vendor drivers. An uuid is a unique identifier and even a well-d=
efined
> one. Tools (e.g. mdevctl) are relying on it for mdev devices today.
>=20
> What is the problem you're trying to solve?
Unique device naming is still achieved without UUID scheme by various subsy=
stems in kernel using alpha-numeric string.
Having such string based continue to provide unique names.

I hope I described the problem and two solutions above.

[1] https://github.com/awilliam/mdevctl
[2] https://elixir.bootlin.com/linux/v5.3-rc4/source/drivers/net/ethernet/m=
ellanox/mlx5/core/en_rep.c
[3] http://man7.org/linux/man-pages/man8/devlink-port.8.html
[4] https://elixir.bootlin.com/linux/v5.3-rc4/source/net/core/devlink.c#L69=
21
[5] https://www.openvswitch.org/

