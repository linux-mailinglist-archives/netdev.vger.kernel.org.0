Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F641A284E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 20:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgDHSN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 14:13:56 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:55266
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728772AbgDHSN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 14:13:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCZz4mHkAnubF/rXVibxMpHC/v978KOvIMpM/1ZoMIWsZmavd2Dc5vrWQ4TvaESevpo35/tiG8IHp3OXyJWVQVZ5abG13fmhSzTZGevTYzdI1sErTd74WfkLHXziO1BD0wkxwsq8za2XrLbenIYsAmefXIg9uSUyJZXF/YXTPMgUXrjZWrVAqBnYpsXX8MmYW/K/mJ8a1M/UMR78NwjOg6vSrcL32rSyAVC1L6ITR3jKIVCOOk6bXV1kAKigx5hho9DREtJCkYZEVvR3tqrYmqc1hYW7noeVp7iEqh4n9Xz5zMs0TU+6zsEIQkcQz+kA4dgNyuMupK2odZ3ViTHJrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sduqnRhD+XhXqcM0eFOEB9esUW9oXe46klJbYckCmTw=;
 b=WuMUPLVa8Kja/rhhAv5o/9JwHbVEx1YiZ/9FVVJh0WLAhfBGnqmeP+s50WNYrxb2V0+syEke9UyHTF5vuf+wtyC9nOCj/HaT3C1F7lE7Hk/XOwoQ29az5HQnXm5vgL+xXPsrptHlySLU+zHyx0+mWNpYE8HTHBD5D6s3+r20GpiMkavSZeAcABOVdl7kFprbPU/ppE+2WIJ3wFYhRAGf+Yfbf8fCLG3IDiXSjwJoECYOwpNs7LH4ZJZ9R20htnDd7XMxE9EbfrU1UJrC9Rv8zzGJri28XzmQ3jP5vS1CAfkD3SBwzogDODQcXZMaVDTpWjidCFwzObciPgPsC263eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sduqnRhD+XhXqcM0eFOEB9esUW9oXe46klJbYckCmTw=;
 b=rVpy14k5/qfqkzgkUL6T7CAaG3df16OV04H6Y+GnK/qcW/CEfoFzzYM5FPlcYi0p5D1hZLgu7fbmO10pjI8/zs+1JVh7kuoAeEY/i7JpLiHCzqc5GWb09j479AEQCnKPf8lu/HKOnL44pdS5uCWRjYRke/c2yMJ5Wfsux+X75z8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB5764.eurprd05.prod.outlook.com (2603:10a6:208:11c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Wed, 8 Apr
 2020 18:13:50 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 18:13:50 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: RE: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9ACAAMW/gIAAy84AgACkCICAAOhGEIAA1qaAgAoCRuCAAMgLAIAACeFQ
Date:   Wed, 8 Apr 2020 18:13:50 +0000
Message-ID: <AM0PR05MB4866BDC1A2CB2218E2F3D056D1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
        <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200327074736.GJ11304@nanopsycho.orion>
        <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
        <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
        <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
        <AM0PR05MB4866B13FF6B672469BDF4A3FD1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20200408095914.772dfdf3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200408095914.772dfdf3@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2dd91643-c7a5-4e25-aab2-08d7dbe896be
x-ms-traffictypediagnostic: AM0PR05MB5764:|AM0PR05MB5764:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB57640C50CDA2FD0BC3CD50EFD1C00@AM0PR05MB5764.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(39840400004)(396003)(9686003)(5660300002)(55236004)(186003)(478600001)(71200400001)(86362001)(81166007)(26005)(55016002)(4326008)(6506007)(66556008)(66476007)(316002)(66946007)(76116006)(6916009)(2906002)(52536014)(7416002)(7696005)(54906003)(8936002)(8676002)(81156014)(33656002)(64756008)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G40dd9NtIy6zhoycSiXDc97sao0SPpIczbm/1mXRcnpYiwsHpnrGwfAVQ0isu5Kd7JxNKo7Id9i70xWrzj6NTjPhsEBneWiBr3up8ilbN8v0MnhSBXRvQtE3KCbeDhlhTIjvsqcweRpsmzwFfeEmRLDFbJNkSdGigJwGxJIwDZaQUIObBz6M09jdbET8kVPPHnt5WFjYFbiKPDXcY7NCx5nmAJqJjx/A5fz6asAb6cOUO0sBCSKlNBH/OBeIFQb4mj4vFnVzNmlfnMUXYiFB3hb/GgDZWIDvyS2XkExKZs62QmcDDB2DKko3dwGdt25HvXPYU2QFWsqUAiPY35T6zTDXk5Wd+m4YMi77+bv1mUDy/yph9LXnmSPAhYScL43agQGZAYxzXeT4dMtJ3ui2LiSYKZvU6GRnfyQQWuvwH3CO/1H2NDK65jMg2/SbFB42
x-ms-exchange-antispam-messagedata: YyMTtTNA1YY15o05BVwVYBNkxHOIFcpUULzE27DDhK6GYjYH16i1tdzy9tMV20I2lEpb4vPdM1NxvTkD3JKdSun8EBvzzSirvlge0/N5ZuuZjZvHAXHF4W5mAjv1hGr7JeSTJ2mMWUrl6uGjt4AcWA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd91643-c7a5-4e25-aab2-08d7dbe896be
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 18:13:50.2489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pp1y6RIBlIiYpm8u2zAVFl/M/1x1ZOfVf2nmYhAfhpN+PkpDEaTXojXL01GaK5yf7NMcHuG6ZWZ+dsOL8qSuMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5764
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
>=20
> On Wed, 8 Apr 2020 05:07:04 +0000 Parav Pandit wrote:
> > > > > > 3. In future at eswitch pci port, I will be adding dpipe
> > > > > > support for the internal flow tables done by the driver.
> > > > > > 4. There were inconsistency among vendor drivers in
> > > > > > using/abusing phys_port_name of the eswitch ports. This is
> > > > > > consolidated via devlink port in core. This provides
> > > > > > consistent view among all vendor drivers.
> > > > > >
> > > > > > So PCI eswitch side ports are useful regardless of slice.
> > > > > >
> > > > > > >> Additionally devlink port object doesn't go through the
> > > > > > >> same state machine as that what slice has to go through.
> > > > > > >> So its weird that some devlink port has state machine and
> > > > > > >> some doesn't.
> > > > > > >
> > > > > > > You mean for VFs? I think you can add the states to the API.
> > > > > > >
> > > > > > As we agreed above that eswitch side objects (devlink port and
> > > > > > representor netdev) should not be used for 'portion of
> > > > > > device',
> > > > >
> > > > > We haven't agreed, I just explained how we differ.
> > > >
> > > > You mentioned that " Right, in my mental model representor _is_ a
> > > > port of the eswitch, so repr would not make sense to me."
> > > >
> > > > With that I infer that 'any object that is directly and _always_
> > > > linked to eswitch and represents an eswitch port is out of
> > > > question, this includes devlink port of eswitch and netdev
> > > > representor. Hence, the comment 'we agree conceptually' to not
> > > > involve devlink port of eswitch and representor netdev to represent
> 'portion of the device'.
> > >
> > > I disagree, repr is one to one with eswitch port. Just because repr
> > > is associated with a devlink port doesn't mean devlink port must be
> > > associated with a repr or a netdev.
> > Devlink port which is on eswitch side is registered with switch_id and =
also
> linked to the rep netdev.
> > From this port phys_port_name is derived.
> > This eswitch port shouldn't represent 'portion of the device'.
>=20
> switch_id is per port, so it's perfectly fine for a devlink port not to h=
ave one, or
> for two ports of the same device to have a different ID.
>=20
> The phys_port_name argument I don't follow. How does that matter in the
> "should we create another object" debate?
>=20
Its very clear in net/core/devlink.c code that a devlink port with a switch=
_id belongs to switch side and linked to eswitch representor netdev.
It just cannot/should not be overloaded to drive host side attributes.

> IMO introducing the slice if it's 1:1 with ports is a no-go.=20
I disagree.
With that argument devlink port for eswitch should not have existed and net=
dev should have been self-describing.
But it is not done that way for 3 reasons I described already in this threa=
d.
Please get rid of devlink eswitch port and put all of it in representor net=
dev, after that 1:1 no-go point make sense. :-)

Also we already discussed that its not 1:1. A slice might not have devlink =
port.
We don't want to start with lowest denominator and narrow use case.

I also described you that slice runs through state machine which devlink po=
rt doesn't.
We don't want to overload devlink port object.

> I also don't like how
> creating a slice implicitly creates a devlink port in your design. If tho=
se objects
> are so strongly linked that creating one implies the other they should ju=
st be
> merged.
I disagree.
When netdev representor is created, its multiple health reporters (strongly=
 linked) are created implicitly.
We didn't merge and user didn't explicitly created them for right reasons.

A slice as described represents 'portion of a device'. As described in RFC,=
 it's the master object for which other associated sub-objects gets created=
.
Like an optional devlink port, representor, health reporters, resources.
Again, it is not 1:1.

As Jiri described and you acked that devlink slice need not have to have a =
devlink port.

There are enough examples in devlink subsystem today where 1:1 and non 1:1 =
objects can be related.
Shared buffers, devlink ports, health reporters, representors have such map=
ping with each other.
>=20
> I'm also concerned that the slice is basically a non-networking port.
What is the concern?
How is shared-buffer, health reporter is attributed as networking object?

> I bet some of the things we add there will one day be useful for networki=
ng or
> DSA ports.
>=20
I think this is mis-interpretation of a devlink slice object.
All things we intent to do in devlink slice is useful for networking and no=
n-networking use.
So saying 'devlink slice is non networking port, hence it cannot be used fo=
r networking' -> is a wrong interpretation.

I do not understand DSA port much, but what blocks users to use slice if it=
 fits the need in future.

How is shared buffer, health reporter are 'networking' object which exists =
under devlink, but not strictly under devlink port?

> So I'd suggest to maybe step back from the SmartNIC scenario and try to f=
igure
> out how slices are useful on their own.
I already went through the requirements, scenario, examples and use model i=
n the RFC extension that describes=20
(a) how slice fits smartnic and non smartnic both cases.
(b) how user gets same experience and commands regardless of use cases.

A 'good' in-kernel example where one object is overloaded to do multiple th=
ings would support a thought to overload devlink port.
For example merge macvlan and vlan driver object to do both functionalities=
.
An overloaded recently introduced qdisc to multiple things as another.
