Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14269B608
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404857AbfHWSAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:00:38 -0400
Received: from mail-eopbgr10056.outbound.protection.outlook.com ([40.107.1.56]:14051
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388081AbfHWSAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 14:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayB6HMr0lRtd+ltQTuR/Se+0ZgD+7OWjY8CwOUgy4oX/63WO27bk8NRQKViUHxRYQ8dQ3BlQgtmjW75pcz/AattVX2on2o3J6rIDd5AhjY0SneXnSKURwo7QbZME1vprzUPye+jhhBodInY3JjnM2/1NY47b1Vr7sYTW7fRLWwfwTD66rOsMUCi1aMH82hqNbktveAfnCbP92xXIFzVdVblCs5/bM8ULrAnqUxG/GRoFayqi1mjkkni9orMrFvipAM/SY0zQussEfd0i1AjuCuYTxnSrCUie8cJ2O4gJnP5zgHcQRVtCZJ+hEapu+mKLRrhF/Gq4B00o/LFUmFMUdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkCRh1iLfRtRER938V9Tfm5pNlTf25cSGJ94BH4zPvU=;
 b=j3Z854E6DQGu8AfqybzysMpqURVHiiPPfwpbggGVvVuOVeTQvTz/TSCbePQdnQoxd/1ENVNLehAAfd1P9U+mvTxiswFkNI7MTE31vR3EhG62C0naA2KS94eKy4QRBvt06Au3Rpdk0g8QBEpcROVEx5r7og3HYqTFW7uOtkiqvkHK9If9UNssKQbLsmY47uC9jLtmIS///tzuqeO2CZnZ9R4ocLJH19FDap8BWh+iXmkzg8mkdSHHPA1/4P5T2/cOnkkslIM78r8hHDQMHa3MOyrMHUYy931U3JTDQYtG4t2jLxo24kZo+NgHBFc/FbIaAj2CapyDriWm7JGAKgRVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkCRh1iLfRtRER938V9Tfm5pNlTf25cSGJ94BH4zPvU=;
 b=kl/q1/cyOa/weU+MLBtzks3Ou0fNNUYzn7ScZl5vScyAOun+xdAvwp5T+i7I1ZGoWT1rw9EcMDeTI0VyOgJ/WPW6xJy9tkG4iQIK4MMLhQ2ktNUekTlFZH6CzYUSNx5B72z4jiUG2KzHGB5Bdm5TTniD81xKs+7rcwblewvwnLM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6002.eurprd05.prod.outlook.com (20.178.118.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 18:00:31 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 18:00:31 +0000
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
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2ACAACadAIAAFGdwgAE42YCAAABasIAAaLIAgAAC1QCAABSugIAAA+pAgAATnYCAAAO7UA==
Date:   Fri, 23 Aug 2019 18:00:30 +0000
Message-ID: <AM0PR05MB486648FF7E6624F34842E425D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820232622.164962d3@x1.home>
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
In-Reply-To: <20190823111641.7f928917@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2407b127-ee14-4b66-958e-08d727f3c9be
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6002;
x-ms-traffictypediagnostic: AM0PR05MB6002:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6002142809E16ED5FC5E8FB6D1A40@AM0PR05MB6002.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(13464003)(189003)(199004)(55016002)(9456002)(5660300002)(54906003)(66946007)(186003)(26005)(74316002)(446003)(4326008)(64756008)(66556008)(66446008)(66476007)(6916009)(229853002)(476003)(11346002)(76176011)(99286004)(55236004)(6506007)(53546011)(7696005)(52536014)(33656002)(316002)(66066001)(478600001)(86362001)(25786009)(81156014)(7736002)(81166006)(53936002)(8936002)(6246003)(102836004)(305945005)(8676002)(76116006)(3846002)(71200400001)(71190400001)(6436002)(2906002)(14444005)(256004)(486006)(6116002)(9686003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6002;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /tJc/98lJ6D2FTUv0tOEmJkke31iwW+L86K2J8fFhsRnqdKBWcmxz8JCzOpgTXDat053u8t2mMHXkkA36flzDN1JASkWrkoFP/woocBMYx23iLVDaH2Apq8qAkomcpMTR7t8abGEt6ZjaAA3DHe/AUO2oiNK/EvfQwUMcAEalCslORA2w9kNgFBzazhAhHnwBXw39N5lOHklntzit93rQ4F/aYx9OVuUAanT/iff4pA6ohWOdpmZHfTLAkWqWz4kiIc6A1VANpPxHdZ4RqW/MKf/EBT6DUgSgkDU1D4C8nystsyZq+8KQXOmCQh7+Ynj/PFVGv7DdQ0yN2STZqBBRV6siJ52NzjxtoGv8yVBhJAfQhXxCotQlSr2VZQzj0CPNAnXP6M5Q1Zpztp15Kb9aBsFzwhEZA7VDmbK+w7q2M8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2407b127-ee14-4b66-958e-08d727f3c9be
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 18:00:31.0161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVaJOs8WRSqE42DCctCb9mb/xB+JLn+oKDhSKMmlHsYIiV4at0ov6mKSDTHvcBrKWoaIdVDCv9Feef17oSL0gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6002
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 23, 2019 10:47 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David =
S . Miller
> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>; Cornelia
> Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Fri, 23 Aug 2019 16:14:04 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > > Idea is to have mdev alias as optional.
> > > > Each mdev_parent says whether it wants mdev_core to generate an
> > > > alias or not. So only networking device drivers would set it to tru=
e.
> > > > For rest, alias won't be generated, and won't be compared either
> > > > during creation time. User continue to provide only uuid.
> > >
> > > Ok
> > >
> > > > I am tempted to have alias collision detection only within
> > > > children mdevs of the same parent, but doing so will always
> > > > mandate to prefix in netdev name. And currently we are left with
> > > > only 3 characters to prefix it, so that may not be good either.
> > > > Hence, I think mdev core wide alias is better with 12 characters.
> > >
> > > I suppose it depends on the API, if the vendor driver can ask the
> > > mdev core for an alias as part of the device creation process, then
> > > it could manage the netdev namespace for all its devices, choosing
> > > how many characters to use, and fail the creation if it can't meet a
> > > uniqueness requirement.  IOW, mdev-core would always provide a full
> > > sha1 and therefore gets itself out of the uniqueness/collision aspect=
s.
> > >
> > This doesn't work. At mdev core level 20 bytes sha1 are unique, so
> > mdev core allowed to create a mdev.
>=20
> The mdev vendor driver has the opportunity to fail the device creation in
> mdev_parent_ops.create().
>=20
That is not helpful for below reasons.
1. vendor driver doesn't have visibility in other vendor's alias.
2. Even for single vendor, it needs to maintain global list of devices to s=
ee collision.
3. multiple vendors needs to implement same scheme.

Mdev core should be the owner. Shifting ownership from one layer to a lower=
 layer in vendor driver doesn't solve the problem
(if there is one, which I think doesn't exist).

> > And then devlink core chooses
> > only 6 bytes (12 characters) and there is collision. Things fall
> > apart. Since mdev provides unique uuid based scheme, it's the mdev
> > core's ownership to provide unique aliases.
>=20
> You're suggesting/contemplating multiple solutions here, 3-char prefix + =
12-
> char sha1 vs <parent netdev> + ?-char sha1.  Also, the 15-char total limi=
t is
> imposed by an external subsystem, where the vendor driver is the gateway
> between that subsystem and mdev.  How would mdev integrate with another
> subsystem that maybe only has 9-chars available?  Would the vendor driver=
 API
> specify "I need an alias" or would it specify "I need an X-char length al=
ias"?
Yes, Vendor driver should say how long the alias it wants.
However before we implement that, I suggest let such vendor/user/driver arr=
ive which needs that.
Such variable length alias can be added at that time and even with that ali=
as collision can be detected by single mdev module.

> Does it make sense that mdev-core would fail creation of a device if ther=
e's a
> collision in the 12-char address space between different subsystems?  For
> example, does enm0123456789ab really collide with xyz0123456789ab?=20
I think so, because at mdev level its 12-char alias matters.
Choosing the prefix not adding prefix is really a user space choice.

>  So if
> mdev were to provided a 40-char sha1, is it possible that the vendor driv=
er
> could consume this in its create callback, truncate it to the number of c=
hars
> required by the vendor driver's subsystem, and determine whether a collis=
ion
> exists?
We shouldn't shift the problem from mdev to multiple vendor drivers to dete=
ct collision.

I still think that user providing alias is better because it knows the use-=
case system in use, and eliminates these collision issue.

>=20
> > > > I do not understand how an extra character reduces collision, if
> > > > that's what you meant.
> > >
> > > If the default were for example 3-chars, we might already have
> > > device 'abc'.  A collision would expose one more char of the new
> > > device, so we might add device with alias 'abcd'.  I mentioned
> > > previously that this leaves an issue for userspace that we can't
> > > change the alias of device abc, so without additional information,
> > > userspace can only determine via elimination the mapping of alias to
> > > device, but userspace has more information available to it in the
> > > form of sysfs links.
> > > > Module options are almost not encouraged anymore with other
> > > > subsystems/drivers.
> > >
> > > We don't live in a world of absolutes.  I agree that the defaults
> > > should work in the vast majority of cases.  Requiring a user to
> > > twiddle module options to make things work is undesirable, verging
> > > on a bug.  A module option to enable some specific feature, unsafe
> > > condition, or test that is outside of the typical use case is
> > > reasonable, imo.
> > > > For testing collision rate, a sample user space script and sample
> > > > mtty is easy and get us collision count too. We shouldn't put that
> > > > using module option in production kernel. I practically have the
> > > > code ready to play with; Changing 12 to smaller value is easy with
> > > > module reload.
> > > >
> > > > #define MDEV_ALIAS_LEN 12
> > >
> > > If it can't be tested with a shipping binary, it probably won't be
> > > tested.  Thanks,
> > It is not the role of mdev core to expose collision
> > efficiency/deficiency of the sha1. It can be tested outside before
> > mdev choose to use it.
>=20
> The testing I'm considering is the user and kernel response to a collisio=
n.
>=20
> > I am saying we should test with 12 characters with 10,000 or more
> > devices and see how collision occurs. Even if collision occurs, mdev
> > returns EEXIST status indicating user to pick a different UUID for
> > those rare conditions.
>=20
> The only way we're going to see collision with a 12-char sha1 is if we bu=
rn the
> CPU cycles to find uuids that collide in that space.  10,000 devices is n=
ot
> remotely enough to generate a collision in that address space.  That puts=
 a
> prerequisite in place that in order to test collision, someone needs to k=
now
> certain magic inputs.  OTOH, if we could use a shorter abbreviation, coll=
isions
> are trivial to test experimentally.  Thanks,
>=20
Yes, and therefore a sane user who wants to create more mdevs, wouldn't int=
entionally stress it to see failures.

> Alex
