Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF609BB8C
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 05:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfHXD4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 23:56:17 -0400
Received: from mail-eopbgr30050.outbound.protection.outlook.com ([40.107.3.50]:24326
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbfHXD4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 23:56:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGuimdsWOf3aTf5gYcmnirhQU18JBDm0ORRGWti4d1ZJa5Sm83IhzD2PE8TucXHOuOhLRz8ag94mArf0JHqXpqcKYegLPrGyA91jPqSA2YljJEh0Pyy0XDGvobTjtf9qiXnobjyVH4mSlBDVX/vWasdjURwiTUDrUICmukuIIcjCKHsy9LMV/f5BAGfubXacXd4MPI/2MJHhvgs0iYoRijfC5UjrkV+YJHN151CTYGKowXGb+Ea37ZJ0dfpRu/hSsa+EfWFssL6UJ6dmOljAkUnUiFqndBIImYUCUNhik/cM8EKdKPLGGSWhO7AOhuCpfTWiwSiyMA4NsEQ7z9KsNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGaDgw0q0rRQWAQGl/w0vn81dmj3K2rDWhd3A+G1C30=;
 b=fAomTLBBtKaHzgo67sFGLYlDsNItClIvctiUZMOJ3HsbDlr5GICDR0J3Msf4Qstyy4Eqpfr+zAsQAMARXdOzmQ9nQ30toVx+Dvm+MxJnr2W6zaoUsClXYeubnBpnn+5gXnUrO02571qm8MWF6cwNBQS/07paadCa1jMJcpdDKo9Y6dDoVWEGRc/bbQz3LTLBKSLhGscAaLxDeslJLCSFrHHVnz2Kw5/a6ZrZDzlP5NbSutiwu58lWX9sb5J7LuWHw6g/oRkWYHgWBcIIQUWfnSED7BJxQAytOvxbdEvswPay6u+zI4m9IDGq7Uh3JAgh8mB9SaJVvH95cubj0bjgDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGaDgw0q0rRQWAQGl/w0vn81dmj3K2rDWhd3A+G1C30=;
 b=PYGCL/uS8dUu9RxxxfDYnIVmdx4vdeBW2mLYsWMUkidesDpE+V3S2re1/eOsTWY70AyM+/fvPO4WXBR9G2W7vHkM3VUApRIY7tzqKBmBbKZx6zL4DMqchxLm2wR8hLDXbL6rZ/8JMv5+EH2jQ7WiY+T4JZfMTYfi/DhkQi4Y1To=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Sat, 24 Aug 2019 03:56:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 03:56:09 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2ACAACadAIAAFGdwgAE42YCAAABasIAAaLIAgAAC1QCAABSugIAAA+pAgAATnYCAAAO7UIAAJVKAgACGAeA=
Date:   Sat, 24 Aug 2019 03:56:08 +0000
Message-ID: <AM0PR05MB4866008B0571B90DAFFADA97D1A70@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822092903.GA2276@nanopsycho.orion>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823082820.605deb07@x1.home>
        <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823095229.210e1e84@x1.home>
        <AM0PR05MB4866E33AF7203DE47F713FAAD1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823111641.7f928917@x1.home>
        <AM0PR05MB486648FF7E6624F34842E425D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190823134337.37e4b215@x1.home>
In-Reply-To: <20190823134337.37e4b215@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3753fca0-8c12-4561-dba1-08d72846ff3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB5873;
x-ms-traffictypediagnostic: AM0PR05MB5873:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5873E536518A1DF98A817EEAD1A70@AM0PR05MB5873.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(13464003)(199004)(189003)(6916009)(66446008)(76116006)(316002)(9686003)(2906002)(6116002)(476003)(186003)(66476007)(102836004)(66556008)(55236004)(26005)(74316002)(6506007)(14444005)(64756008)(4326008)(55016002)(54906003)(5660300002)(71200400001)(71190400001)(53546011)(6436002)(81156014)(256004)(76176011)(66946007)(7696005)(86362001)(8676002)(33656002)(478600001)(8936002)(3846002)(53936002)(305945005)(99286004)(229853002)(486006)(14454004)(6246003)(11346002)(7736002)(25786009)(81166006)(66066001)(52536014)(446003)(9456002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5873;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hdlsjpNxDUsgv3utnpgQHT5VoIE8f6JShoqtOL5RzQ7JVmeksTpd+V1oSiTPzistfBTiUr+cYEoggfMIh70rtiWMJQkZ9yM/TsfXEfZBUSkxEjjUIC5mA2Z4ZU/zcz8tMAwErQJxZZ4anKyaGNbbrveTSVw599X+s31LAauJJjKwUiT/MzDV66fcILKelaLLK4UAQC4puO7euRhBhxRo8yd+qWm4eA9kFQX47cNvvUHi5tZn4pCe984aDcRYSRIH8XB/k5S10vhWRuXuzdrQVYNrPzPg1nKLprvMx4V6CDSiuGFl6i2n84iQv/9k3U/dvG7aAGPVhCNHxtMzc3PATxZ5vN5D+bciuh/AhTjHDUOpx8IZlNzr55ioVEhzDuR+hcXqLF/majZALlXLmToAnLS5RCULCgyW8TeHDWZ57Co=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3753fca0-8c12-4561-dba1-08d72846ff3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 03:56:08.9416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qOc0mRvH1SVHUE5VzD3RG82R6TdcHVa5mEO3ZeOrfV52GVEULy0YKAh1F1Xbw0FQXPaNPrA8K9eynnKgtOacw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5873
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, August 24, 2019 1:14 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David =
S . Miller
> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>; Cornelia
> Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Fri, 23 Aug 2019 18:00:30 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, August 23, 2019 10:47 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>;
> > > David S . Miller <davem@davemloft.net>; Kirti Wankhede
> > > <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
> > > kvm@vger.kernel.org; linux- kernel@vger.kernel.org; cjia
> > > <cjia@nvidia.com>; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Fri, 23 Aug 2019 16:14:04 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > > Idea is to have mdev alias as optional.
> > > > > > Each mdev_parent says whether it wants mdev_core to generate
> > > > > > an alias or not. So only networking device drivers would set it=
 to true.
> > > > > > For rest, alias won't be generated, and won't be compared
> > > > > > either during creation time. User continue to provide only uuid=
.
> > > > >
> > > > > Ok
> > > > >
> > > > > > I am tempted to have alias collision detection only within
> > > > > > children mdevs of the same parent, but doing so will always
> > > > > > mandate to prefix in netdev name. And currently we are left
> > > > > > with only 3 characters to prefix it, so that may not be good ei=
ther.
> > > > > > Hence, I think mdev core wide alias is better with 12 character=
s.
> > > > >
> > > > > I suppose it depends on the API, if the vendor driver can ask
> > > > > the mdev core for an alias as part of the device creation
> > > > > process, then it could manage the netdev namespace for all its
> > > > > devices, choosing how many characters to use, and fail the
> > > > > creation if it can't meet a uniqueness requirement.  IOW,
> > > > > mdev-core would always provide a full
> > > > > sha1 and therefore gets itself out of the uniqueness/collision as=
pects.
> > > > >
> > > > This doesn't work. At mdev core level 20 bytes sha1 are unique, so
> > > > mdev core allowed to create a mdev.
> > >
> > > The mdev vendor driver has the opportunity to fail the device
> > > creation in mdev_parent_ops.create().
> > >
> > That is not helpful for below reasons.
> > 1. vendor driver doesn't have visibility in other vendor's alias.
> > 2. Even for single vendor, it needs to maintain global list of devices =
to see
> collision.
> > 3. multiple vendors needs to implement same scheme.
> >
> > Mdev core should be the owner. Shifting ownership from one layer to a
> > lower layer in vendor driver doesn't solve the problem (if there is
> > one, which I think doesn't exist).
> >
> > > > And then devlink core chooses
> > > > only 6 bytes (12 characters) and there is collision. Things fall
> > > > apart. Since mdev provides unique uuid based scheme, it's the mdev
> > > > core's ownership to provide unique aliases.
> > >
> > > You're suggesting/contemplating multiple solutions here, 3-char
> > > prefix + 12- char sha1 vs <parent netdev> + ?-char sha1.  Also, the
> > > 15-char total limit is imposed by an external subsystem, where the
> > > vendor driver is the gateway between that subsystem and mdev.  How
> > > would mdev integrate with another subsystem that maybe only has
> > > 9-chars available?  Would the vendor driver API specify "I need an
> > > alias" or would it specify "I need an X-char length alias"?
> > Yes, Vendor driver should say how long the alias it wants.
> > However before we implement that, I suggest let such
> > vendor/user/driver arrive which needs that. Such variable length alias
> > can be added at that time and even with that alias collision can be
> > detected by single mdev module.
>=20
> If we agree that different alias lengths are possible, then I would reque=
st that
> minimally an mdev sample driver be modified to request an alias with a le=
ngth
> that can be adjusted without recompiling in order to exercise the collisi=
on path.
>=20
Yes. this can be done. But I fail to understand the need to do so.
It is not the responsibility of the mdev core to show case sha1 collision e=
fficiency/deficiency.
So why do you insist exercise it?

> If mdev-core is guaranteeing uniqueness, does this indicate that each ali=
as
> length constitutes a separate namespace?  ie. strictly a strcmp(), not a
> strncmp() to the shorter alias.
>=20
Yes.


> > > Does it make sense that mdev-core would fail creation of a device if
> > > there's a collision in the 12-char address space between different
> > > subsystems?  For example, does enm0123456789ab really
> > > collide with xyz0123456789ab?
> > I think so, because at mdev level its 12-char alias matters.
> > Choosing the prefix not adding prefix is really a user space choice.
> >
> > >  So if
> > > mdev were to provided a 40-char sha1, is it possible that the vendor
> > > driver could consume this in its create callback, truncate it to the
> > > number of chars required by the vendor driver's subsystem, and
> > > determine whether a collision exists?
> > We shouldn't shift the problem from mdev to multiple vendor drivers to
> > detect collision.
> >
> > I still think that user providing alias is better because it knows the
> > use-case system in use, and eliminates these collision issue.
>=20
> How is a user provided alias immune from collisions?  The burden is on th=
e user
> to provide both a unique uuid and a unique alias.  That makes it trivial =
to create
> a collision.
>=20
Than such collision should have occurred for other subsystem such as netdev=
 while creating vlan, macvlan, ipvlan, vxlan and more devices who are named=
 by the user.
But that isn't the case.

> > > > > > I do not understand how an extra character reduces collision,
> > > > > > if that's what you meant.
> > > > >
> > > > > If the default were for example 3-chars, we might already have
> > > > > device 'abc'.  A collision would expose one more char of the new
> > > > > device, so we might add device with alias 'abcd'.  I mentioned
> > > > > previously that this leaves an issue for userspace that we can't
> > > > > change the alias of device abc, so without additional
> > > > > information, userspace can only determine via elimination the
> > > > > mapping of alias to device, but userspace has more information
> > > > > available to it in the form of sysfs links.
> > > > > > Module options are almost not encouraged anymore with other
> > > > > > subsystems/drivers.
> > > > >
> > > > > We don't live in a world of absolutes.  I agree that the
> > > > > defaults should work in the vast majority of cases.  Requiring a
> > > > > user to twiddle module options to make things work is
> > > > > undesirable, verging on a bug.  A module option to enable some
> > > > > specific feature, unsafe condition, or test that is outside of
> > > > > the typical use case is reasonable, imo.
> > > > > > For testing collision rate, a sample user space script and
> > > > > > sample mtty is easy and get us collision count too. We
> > > > > > shouldn't put that using module option in production kernel.
> > > > > > I practically have the code ready to play with; Changing 12 to
> > > > > > smaller value is easy with module reload.
> > > > > >
> > > > > > #define MDEV_ALIAS_LEN 12
> > > > >
> > > > > If it can't be tested with a shipping binary, it probably won't
> > > > > be tested.  Thanks,
> > > > It is not the role of mdev core to expose collision
> > > > efficiency/deficiency of the sha1. It can be tested outside before
> > > > mdev choose to use it.
> > >
> > > The testing I'm considering is the user and kernel response to a
> > > collision.
> > > > I am saying we should test with 12 characters with 10,000 or more
> > > > devices and see how collision occurs. Even if collision occurs,
> > > > mdev returns EEXIST status indicating user to pick a different
> > > > UUID for those rare conditions.
> > >
> > > The only way we're going to see collision with a 12-char sha1 is if
> > > we burn the CPU cycles to find uuids that collide in that space.
> > > 10,000 devices is not remotely enough to generate a collision in
> > > that address space.  That puts a prerequisite in place that in order
> > > to test collision, someone needs to know certain magic inputs.
> > > OTOH, if we could use a shorter abbreviation, collisions are trivial
> > > to test experimentally.  Thanks,
> > Yes, and therefore a sane user who wants to create more mdevs,
> > wouldn't intentionally stress it to see failures.
>=20
> I don't understand this logic.  I'm simply asking that we have a way to t=
est the
> collision behavior without changing the binary.  The path we're driving t=
owards
> seems to be making this easier and easier.  If the vendor can request an =
alias of
> a specific length, then a sample driver with a module option to set the d=
esired
> alias length to 1-char makes it trivially easy to induce a collision. =20
Sure it is easy to test collision, but my point is - mdev core is not sha1 =
test module.
Hence adding functionality of variable alias length to test collision doesn=
't make sense.
When the actual user arrives who needs small alias, we will be able to add =
additional pieces very easily.

> It doesn't
> even need to be exposed in a real driver.  Besides, when do we ever get t=
o
> design interfaces that only worry about sane users???  Thanks,
>=20
I intent to say that a sane user who wants to create mdev's will just work =
fine with less collision.
If there is collision EEXIST is returns and sane user picks different UUID.
If user is intentionally picking UUIDs in such a way that triggers sha1 col=
lision, his intention is likely to not create mdevs for actual use.
And if interface returns error code it is still fine.

> Alex
