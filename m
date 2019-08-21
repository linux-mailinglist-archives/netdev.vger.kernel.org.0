Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B5297137
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfHUEkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:40:36 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23466
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbfHUEkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 00:40:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcY4CGGT9fCN+ECIutoqzCg+UUUNqZc62IBszP8XrBDBiL6pRSswsR6tiCUHe2OIs8he+WxA2MClPnSc7W5B7OUZkx05D8krLlHPINKt8rTiYikHKdekxVwSm7kKbIv3e784QLPZegcu0akMO/1/7jfjqLRJ7gUnKzkUkA0s4zHE8p0BorFaVZg8UOWyOS9dwMpLsMgeGGc6cPcNX2YrvOI3DERvPQhnyS9pzmMjjRQdtILvJrjKEpUJPSqNWFXR2XO3a+7z0ATdXL1LiyewM4sO1sb5NjPo/8uuzTbkNgaBsAlvvUWeLDonWwLkAcp9LtG0LXDiaVutzunZzb2gWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aicJKgXfqRECW8Ebenc0TU+4lodfX4GypeKPfCT46Nc=;
 b=OwkzmniiJnvCp+vr9wSyGVtCN9BoUNYANT8gevRvagZubJoRf7SBALjNEDOBvk63tPwuHdIID/I0Citrx4QEkg+jb4z3lRhRAn7PIkwoc6v8pgjkHT/gbZhl2Y2BJGkcLUdXnbLGwKmTaeGXLfKSC9MyCmPVS5hE6feuC7/2WzYkRSv3nvWiY2+9rQawM2jzSOdv8L6SKCEcTVlpWu47Z6FlUb87j04wBU4Noh9EZpTgFPUSBLWERrlUW2PQkk3I4qMTAED+/NPjLFHgEh/1R/rRgZazVjkWAd/iVf6DKV0/eHeUeUTZ+JxtxyuSi7XCV5uUrORA/hr+11rghAKbXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aicJKgXfqRECW8Ebenc0TU+4lodfX4GypeKPfCT46Nc=;
 b=JBiUgcpMttqUML0pRlI07LrvazZ6VO8MRL4mJlpEgUINrvTG1HxTm8yp2OVSH45/VZ9EbiHmKjKIzZwE+LDJt9lSgG1E82AmZM76mRUjXE+GMyo1FeRx56MAq47Yq5OAhn2SpwWummpeBLaqG7u6ChcBl6f5JxDm/knRLO38aN0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4705.eurprd05.prod.outlook.com (52.133.54.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 04:40:16 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 04:40:15 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgA==
Date:   Wed, 21 Aug 2019 04:40:15 +0000
Message-ID: <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
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
        <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820111904.75515f58@x1.home>
        <AM0PR05MB486686D3C311F3C61BE0997DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820222051.7aeafb69@x1.home>
In-Reply-To: <20190820222051.7aeafb69@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 863e64fa-ae3d-4dd9-ac27-08d725f1a9a4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4705;
x-ms-traffictypediagnostic: AM0PR05MB4705:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB47053BB7A9262D8BA1E68EBED1AA0@AM0PR05MB4705.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(13464003)(189003)(199004)(7696005)(9456002)(52536014)(5660300002)(6436002)(6916009)(30864003)(55016002)(6116002)(2906002)(8936002)(3846002)(8676002)(9686003)(81156014)(81166006)(6506007)(446003)(54906003)(186003)(26005)(55236004)(476003)(102836004)(76116006)(76176011)(53936002)(71200400001)(71190400001)(6246003)(66446008)(64756008)(66556008)(66476007)(14454004)(66066001)(256004)(478600001)(229853002)(33656002)(4326008)(14444005)(25786009)(561944003)(99286004)(53546011)(86362001)(305945005)(11346002)(74316002)(486006)(316002)(66946007)(7736002)(473944003)(414714003)(357404004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4705;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q6UMmIvBBvWWsk/OONnysH0Crn6BrXXJyuBzQNCk+Nq8WN9NdFGFaHwM3Dn5rIfA7xhXy3c71lkxjyYetf1OMnxyEmMHJnKEj/kX/yvWZI5vYL/9sr9mIVo9U3V82ixHSfKmJhIghNzzX0voObd52gCxVJAxDHoz8l8TEimvR45DNlMswtKldNjW/knc26kTBNmwCu/kdUNeaYHMCACg+ojJlURvrjkoabxMGTY3+FQYKbR+33ZfdoE4+7dl2Dew7YGz6zTEpqevVXei75HMdFlS/j0g9VKsQIvzxSwH7S5LuLdqBBfOUsxGB+fPVMlWunwIqoqDErnBtC+JHWIDKP/Oqn2etzGrLF49FTFsmtY2qP+kd9KL/FU52IyRQ0ZkaJdUpOnRMZfQLlVvQqcckw9meSLMKuiOfdIkOVNHnDk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863e64fa-ae3d-4dd9-ac27-08d725f1a9a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 04:40:15.8352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iRpH2+hQEuZKLFbXC8kqNWPqYJbgpUcmXfmRRQgLS20t/OEROb0RDaQ8JUJwM5k+AohvqAldChdJQzXpGV2OlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4705
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, August 21, 2019 9:51 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller <davem@davemloft.net=
>;
> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> <cohuck@redhat.com>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Wed, 21 Aug 2019 03:42:25 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, August 20, 2019 10:49 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > > <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> > > Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Tue, 20 Aug 2019 08:58:02 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > + Dave.
> > > >
> > > > Hi Jiri, Dave, Alex, Kirti, Cornelia,
> > > >
> > > > Please provide your feedback on it, how shall we proceed?
> > > >
> > > > Short summary of requirements.
> > > > For a given mdev (mediated device [1]), there is one representor
> > > > netdevice and devlink port in switchdev mode (similar to SR-IOV
> > > > VF), And there is one netdevice for the actual mdev when mdev is pr=
obed.
> > > >
> > > > (a) representor netdev and devlink port should be able derive
> > > > phys_port_name(). So that representor netdev name can be built
> > > > deterministically across reboots.
> > > >
> > > > (b) for mdev's netdevice, mdev's device should have an attribute.
> > > > This attribute can be used by udev rules/systemd or something else
> > > > to rename netdev name deterministically.
> > > >
> > > > (c) IFNAMSIZ of 16 bytes is too small to fit whole UUID.
> > > > A simple grep IFNAMSIZ in stack hints hundreds of users of
> > > > IFNAMSIZ in drivers, uapi, netlink, boot config area and more.
> > > > Changing IFNAMSIZ for a mdev bus doesn't really look reasonable opt=
ion
> to me.
> > >
> > > How many characters do we really have to work with?  Your examples
> > > below prepend various characters, ex. option-1 results in ens2f0_m10
> > > or enm10.  Do the extra 8 or 3 characters in these count against IFNA=
MSIZ?
> > >
> > Maximum 15. Last is null termination.
> > Some udev rules setting by user prefix the PF netdev interface. I took =
such
> example below where ens2f0 netdev named is prefixed.
> > Some prefer not to prefix.
> >
> > > > Hence, I would like to discuss below options.
> > > >
> > > > Option-1: mdev index
> > > > Introduce an optional mdev index/handle as u32 during mdev create
> > > > time. User passes mdev index/handle as input.
> > > >
> > > > phys_port_name=3DmIndex=3Dm%u
> > > > mdev_index will be available in sysfs as mdev attribute for udev
> > > > to name the mdev's netdev.
> > > >
> > > > example mdev create command:
> > > > UUID=3D$(uuidgen)
> > > > echo $UUID index=3D10
> > > > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > >
> > > Nit, IIRC previous discussions of additional parameters used comma
> > > separators, ex. echo $UUID,index=3D10 >...
> > >
> > Yes, ok.
> >
> > > > > example netdevs:
> > > > repnetdev=3Dens2f0_m10	/*ens2f0 is parent PF's netdevice */
> > >
> > > Is the parent really relevant in the name?
> > No. I just picked one udev example who prefixed the parent netdev name.
> > But there are users who do not prefix it.
> >
> > > Tools like mdevctl are meant to
> > > provide persistence, creating the same mdev devices on the same
> > > parent, but that's simply the easiest policy decision.  We can also
> > > imagine that multiple parent devices might support a specified mdev
> > > type and policies factoring in proximity, load-balancing, power
> > > consumption, etc might be weighed such that we really don't want to
> > > promote userspace creating dependencies on the parent association.
> > >
> > > > mdev_netdev=3Denm10
> > > >
> > > > Pros:
> > > > 1. mdevctl and any other existing tools are unaffected.
> > > > 2. netdev stack, ovs and other switching platforms are unaffected.
> > > > 3. achieves unique phys_port_name for representor netdev 4.
> > > > achieves unique mdev eth netdev name for the mdev using udev/system=
d
> extension.
> > > > 5. Aligns well with mdev and netdev subsystem and similar to
> > > > existing sriov bdf's.
> > >
> > > A user provided index seems strange to me.  It's not really an
> > > index, just a user specified instance number.  Presumably you have
> > > the user providing this because if it really were an index, then the
> > > value depends on the creation order and persistence is lost.  Now
> > > the user needs to both avoid uuid collision as well as "index"
> > > number collision.  The uuid namespace is large enough to mostly ignor=
e
> this, but this is not.  This seems like a burden.
> > >
> > I liked the term 'instance number', which is lot better way to say than
> index/handle.
> > Yes, user needs to avoid both the collision.
> > UUID collision should not occur in most cases, they way UUID are genera=
ted.
> > So practically users needs to pick unique 'instance number', similar to=
 how it
> picks unique netdev names.
> >
> > Burden to user comes from the requirement to get uniqueness.
> >
> > > > Option-2: shorter mdev name
> > > > Extend mdev to have shorter mdev device name in addition to UUID.
> > > > such as 'foo', 'bar'.
> > > > Mdev will continue to have UUID.
> > > > phys_port_name=3Dmdev_name
> > > >
> > > > Pros:
> > > > 1. All same as option-1, except mdevctl needs upgrade for newer usa=
ge.
> > > > It is common practice to upgrade iproute2 package along with the
> > > > kernel. Similar practice to be done with mdevctl.
> > > > 2. Newer users of mdevctl who wants to work with non_UUID names,
> > > > will use newer mdevctl/tools. Cons:
> > > > 1. Dual naming scheme of mdev might affect some of the existing too=
ls.
> > > > It's unclear how/if it actually affects.
> > > > mdevctl [2] is very recently developed and can be enhanced for
> > > > dual naming scheme.
> > >
> > > I think we've already nak'ed this one, the device namespace becomes
> > > meaningless if the name becomes just a string where a uuid might be
> > > an example string.  mdevs are named by uuid.
> > >
> > > > Option-3: mdev uuid alias
> > > > Instead of shorter mdev name or mdev index, have alpha-numeric
> > > > name alias. Alias is an optional mdev sysfs attribute such as 'foo'=
, 'bar'.
> > > > example mdev create command:
> > > > UUID=3D$(uuidgen)
> > > > echo $UUID alias=3Dfoo
> > > > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > > > > example netdevs:
> > > > examle netdevs:
> > > > repnetdev =3D ens2f0_mfoo
> > > > mdev_netdev=3Denmfoo
> > > >
> > > > Pros:
> > > > 1. All same as option-1.
> > > > 2. Doesn't affect existing mdev naming scheme.
> > > > Cons:
> > > > 1. Index scheme of option-1 is better which can number large
> > > > number of mdevs with fewer characters, simplifying the management
> tool.
> > >
> > > No better than option-1, simply a larger secondary namespace, but
> > > still requires the user to come up with two independent names for the
> device.
> > >
> > > > Option-4: extend IFNAMESZ to be 64 bytes Extended IFNAMESZ from 16
> > > > to
> > > > 64 bytes phys_port_name=3Dmdev_UUID_string
> mdev_netdev_name=3DenmUUID
> > > >
> > > > Pros:
> > > > 1. Doesn't require mdev extension
> > > > Cons:
> > > > 1. netdev stack, driver, uapi, user space, boot config wide changes=
 2.
> > > > Possible user space extensions who assumed name size being 16
> > > > characters 3. Single device type demands namesize change for all
> > > > netdev types
> > >
> > > What about an alias based on the uuid?  For example, we use 160-bit
> > > sha1s daily with git (uuids are only 128-bit), but we generally
> > > don't reference git commits with the full 20 character string.
> > > Generally 12 characters is recommended to avoid ambiguity.  Could
> > > mdev automatically create an
>                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > abbreviated sha1 alias for the device?  If so, how many characters
> > > should we
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > use and what do we do on collision?  The colliding device could add
> > > enough alias characters to disambiguate (we likely couldn't re-alias
> > > the existing device to disambiguate, but I'm not sure it matters,
> > > userspace has sysfs to associate aliases).  Ex.
> > >
> > > UUID=3D$(uuidgen)
> > > ALIAS=3D$(echo $UUID | sha1sum | colrm 13)
> > >
> > I explained in previous reply to Cornelia, we should set UUID and ALIAS=
 at the
> same time.
> > Setting is via different sysfs attribute is lot code burden with no ext=
ra benefit.
>=20
> Just an example of the alias, not proposing how it's set.  In fact, propo=
sing that
> the user does not set it, mdev-core provides one automatically.
>=20
> > > Since there seems to be some prefix overhead, as I ask about above
> > > in how many characters we actually have to work with in IFNAMESZ,
> > > maybe we start with 8 characters (matching your "index" namespace)
> > > and expand as necessary for disambiguation.  If we can eliminate
> > > overhead in IFNAMESZ, let's start with 12.  Thanks,
> > >
> > If user is going to choose the alias, why does it have to be limited to=
 sha1?
> > Or you just told it as an example?
> >
> > It can be an alpha-numeric string.
>=20
> No, I'm proposing a different solution where mdev-core creates an alias b=
ased
> on an abbreviated sha1.  The user does not provide the alias.
>=20
> > Instead of mdev imposing number of characters on the alias, it should b=
e best
> left to the user.
> > Because in future if netdev improves on the naming scheme, mdev will be
> limiting it, which is not right.
> > So not restricting alias size seems right to me.
> > User configuring mdev for networking devices in a given kernel knows wh=
at
> user is doing.
> > So user can choose alias name size as it finds suitable.
>=20
> That's not what I'm proposing, please read again.  Thanks,

I understood your point. But mdev doesn't know how user is going to use ude=
v/systemd to name the netdev.
So even if mdev chose to pick 12 characters, it could result in collision.
Hence the proposal to provide the alias by the user, as user know the best =
policy for its use case in the environment its using.
So 12 character sha1 method will still work by user.
