Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAFA97157
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 07:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfHUFCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 01:02:06 -0400
Received: from mail-eopbgr20086.outbound.protection.outlook.com ([40.107.2.86]:52302
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfHUFCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 01:02:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gveo5S3d2O6L30BaHOX8kVQHhcLgLymUW1NVbA504VYrIdev0twTTx7n5Yn+DOfwuqjmMMxGSCxbi4J0AQvAsAO7T8hen0MlbfQStcateN5ZJN43erXfuPsk+75iF6A7PtoG0/HzKfAMSABV2BXA/nWWENxs5xYOd0uXzbCYWPfZv8opQXSYBwP3FNeLMC5Zc3gHBf/UnmGBOkQAa5znrhh0Oq4JipiRtd//+WQzisyjkET2d4MDHK/tu3F8ZYXnoe/pvRx6zFWCW1Gxyio1V0bepeGu+0KLoaZrr8TlTRKw+h1gLVpT79PAtJOlKMTtnewkwzdp9rKjNqfT2FAYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iodz282orxI/xMGpLcM6O4Mj8OyBlnmxfX41b8iKEnA=;
 b=VX7Hw9fIwu6AUtRqhCq3q18FER1tAc8tGvqQdBeGvLFOLne3J3HQn1dQqJVvxc+LJP3khxL6WEKWbbf/gnmYHd9vuJpI9yYvU8bMzJXCWXYNs3P1UXjx3b2XFikiUnouVt+494xsX6/KaHMQu38TEhDHOx+wb+QuUzcgooN5fVb/s3oadE3rb/zOQsEZbmF2XCwLIDfbWWWVNd4LNan6NHkcU4Jz3SdkXmvNoVe5T5iEqYw3vAird74ybF5v327zdeAtuqU1pCZo156lL+xM1BNhgDLrsEcwi9sw0KsP6QsE65ROc2Q5qEAvKkIR8XR/DVBLj/zW9nvOw7hy66p/6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iodz282orxI/xMGpLcM6O4Mj8OyBlnmxfX41b8iKEnA=;
 b=kwzS3fnjLqCTPxRos1gbDwoMCB/7I1sQrWBAm4rbeoJGuO/jBATQ0xiYvWHC6JDTkOqt2mwCWuNWWynKj/JAy2BM2zX6p/4ikrK7MuHMb3Ww2vxXIOoFW7dM8bTpluWsrwc0jN1Gn7LyCYL0zo1bxJvCrfGVkJwrcrqAIGBzc9Y=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6402.eurprd05.prod.outlook.com (20.179.35.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Wed, 21 Aug 2019 05:01:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 05:01:52 +0000
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
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrA=
Date:   Wed, 21 Aug 2019 05:01:52 +0000
Message-ID: <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
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
        <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820225722.237a57d2@x1.home>
In-Reply-To: <20190820225722.237a57d2@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8e482df-d5b0-403a-8cfc-08d725f4aea4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB6402;
x-ms-traffictypediagnostic: AM0PR05MB6402:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6402C0DB01EC40A8F13DA81ED1AA0@AM0PR05MB6402.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(189003)(199004)(13464003)(66946007)(305945005)(30864003)(6436002)(4326008)(5660300002)(7736002)(9686003)(74316002)(229853002)(6246003)(55016002)(86362001)(14454004)(486006)(476003)(2906002)(53936002)(6506007)(25786009)(64756008)(52536014)(99286004)(478600001)(66476007)(53546011)(33656002)(66446008)(66556008)(7696005)(561944003)(71200400001)(55236004)(102836004)(76176011)(76116006)(71190400001)(446003)(186003)(26005)(9456002)(8936002)(316002)(6116002)(6916009)(54906003)(256004)(3846002)(11346002)(66066001)(81156014)(81166006)(14444005)(8676002)(473944003)(414714003)(357404004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6402;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rHVXoTAUjNB1dZD8vwPuxpOM8EtKjLiEEiVCL9fJacGIsFc1G9pNOCjKyCOaDiGps/oUZoJg2HV1NbtRRUfcXjS7kYS3w+GggisEWsMijpvQ7/kS8Kczty9Wc6RFsLFg7r76ZZQt+3OhEfmbvRLrrpM5t792Iq1xorNWx9iEqIy0hcKrKGcAiinaGAmOdB4UJvFqiS9/k+hyHGZiAz/PqUmDHAGlS0N+ARNqgYEQwVPPAkAAGexBFTgsyfryTGR9Ywafd74hALjY70c2Mjgct1uxR4+/efNmHA636UzNrIMreATAGU3JjAj8cYgttqbG7C7GW4lr4i8gdT0H3KlftdmiCQbuxk9a29u5f0V/8kKs7ysoVhUOLC6j1PFTbOkWl54wwKnZS3BMsbepJXjYBT/oFRtep4JhY1vPrU+ZZhE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e482df-d5b0-403a-8cfc-08d725f4aea4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 05:01:52.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EKmo70FJd0FpaLB9Q+FwrYMDIMma106xqbxqJVbR1pdwBpbhUX/PfiJzixS/cfmsVJqoOZMf0tqA7ejBS8xCkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, August 21, 2019 10:27 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller <davem@davemloft.net=
>;
> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
> <cohuck@redhat.com>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Wed, 21 Aug 2019 04:40:15 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, August 21, 2019 9:51 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > > <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> > > Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Wed, 21 Aug 2019 03:42:25 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Tuesday, August 20, 2019 10:49 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > > > > <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> > > > > Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
> > > > > linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
> > > > > netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >
> > > > > On Tue, 20 Aug 2019 08:58:02 +0000 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >
> > > > > > + Dave.
> > > > > >
> > > > > > Hi Jiri, Dave, Alex, Kirti, Cornelia,
> > > > > >
> > > > > > Please provide your feedback on it, how shall we proceed?
> > > > > >
> > > > > > Short summary of requirements.
> > > > > > For a given mdev (mediated device [1]), there is one
> > > > > > representor netdevice and devlink port in switchdev mode
> > > > > > (similar to SR-IOV VF), And there is one netdevice for the actu=
al mdev
> when mdev is probed.
> > > > > >
> > > > > > (a) representor netdev and devlink port should be able derive
> > > > > > phys_port_name(). So that representor netdev name can be built
> > > > > > deterministically across reboots.
> > > > > >
> > > > > > (b) for mdev's netdevice, mdev's device should have an attribut=
e.
> > > > > > This attribute can be used by udev rules/systemd or something
> > > > > > else to rename netdev name deterministically.
> > > > > >
> > > > > > (c) IFNAMSIZ of 16 bytes is too small to fit whole UUID.
> > > > > > A simple grep IFNAMSIZ in stack hints hundreds of users of
> > > > > > IFNAMSIZ in drivers, uapi, netlink, boot config area and more.
> > > > > > Changing IFNAMSIZ for a mdev bus doesn't really look
> > > > > > reasonable option
> > > to me.
> > > > >
> > > > > How many characters do we really have to work with?  Your
> > > > > examples below prepend various characters, ex. option-1 results
> > > > > in ens2f0_m10 or enm10.  Do the extra 8 or 3 characters in these =
count
> against IFNAMSIZ?
> > > > >
> > > > Maximum 15. Last is null termination.
> > > > Some udev rules setting by user prefix the PF netdev interface. I
> > > > took such
> > > example below where ens2f0 netdev named is prefixed.
> > > > Some prefer not to prefix.
> > > >
> > > > > > Hence, I would like to discuss below options.
> > > > > >
> > > > > > Option-1: mdev index
> > > > > > Introduce an optional mdev index/handle as u32 during mdev
> > > > > > create time. User passes mdev index/handle as input.
> > > > > >
> > > > > > phys_port_name=3DmIndex=3Dm%u
> > > > > > mdev_index will be available in sysfs as mdev attribute for
> > > > > > udev to name the mdev's netdev.
> > > > > >
> > > > > > example mdev create command:
> > > > > > UUID=3D$(uuidgen)
> > > > > > echo $UUID index=3D10
> > > > > > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/cr
> > > > > > > eate
> > > > >
> > > > > Nit, IIRC previous discussions of additional parameters used
> > > > > comma separators, ex. echo $UUID,index=3D10 >...
> > > > >
> > > > Yes, ok.
> > > >
> > > > > > > example netdevs:
> > > > > > repnetdev=3Dens2f0_m10	/*ens2f0 is parent PF's netdevice */
> > > > >
> > > > > Is the parent really relevant in the name?
> > > > No. I just picked one udev example who prefixed the parent netdev n=
ame.
> > > > But there are users who do not prefix it.
> > > >
> > > > > Tools like mdevctl are meant to
> > > > > provide persistence, creating the same mdev devices on the same
> > > > > parent, but that's simply the easiest policy decision.  We can
> > > > > also imagine that multiple parent devices might support a
> > > > > specified mdev type and policies factoring in proximity,
> > > > > load-balancing, power consumption, etc might be weighed such
> > > > > that we really don't want to promote userspace creating dependenc=
ies
> on the parent association.
> > > > >
> > > > > > mdev_netdev=3Denm10
> > > > > >
> > > > > > Pros:
> > > > > > 1. mdevctl and any other existing tools are unaffected.
> > > > > > 2. netdev stack, ovs and other switching platforms are unaffect=
ed.
> > > > > > 3. achieves unique phys_port_name for representor netdev 4.
> > > > > > achieves unique mdev eth netdev name for the mdev using
> > > > > > udev/systemd
> > > extension.
> > > > > > 5. Aligns well with mdev and netdev subsystem and similar to
> > > > > > existing sriov bdf's.
> > > > >
> > > > > A user provided index seems strange to me.  It's not really an
> > > > > index, just a user specified instance number.  Presumably you
> > > > > have the user providing this because if it really were an index,
> > > > > then the value depends on the creation order and persistence is
> > > > > lost.  Now the user needs to both avoid uuid collision as well as=
 "index"
> > > > > number collision.  The uuid namespace is large enough to mostly
> > > > > ignore
> > > this, but this is not.  This seems like a burden.
> > > > >
> > > > I liked the term 'instance number', which is lot better way to say
> > > > than
> > > index/handle.
> > > > Yes, user needs to avoid both the collision.
> > > > UUID collision should not occur in most cases, they way UUID are
> generated.
> > > > So practically users needs to pick unique 'instance number',
> > > > similar to how it
> > > picks unique netdev names.
> > > >
> > > > Burden to user comes from the requirement to get uniqueness.
> > > >
> > > > > > Option-2: shorter mdev name
> > > > > > Extend mdev to have shorter mdev device name in addition to UUI=
D.
> > > > > > such as 'foo', 'bar'.
> > > > > > Mdev will continue to have UUID.
> > > > > > phys_port_name=3Dmdev_name
> > > > > >
> > > > > > Pros:
> > > > > > 1. All same as option-1, except mdevctl needs upgrade for newer
> usage.
> > > > > > It is common practice to upgrade iproute2 package along with
> > > > > > the kernel. Similar practice to be done with mdevctl.
> > > > > > 2. Newer users of mdevctl who wants to work with non_UUID
> > > > > > names, will use newer mdevctl/tools. Cons:
> > > > > > 1. Dual naming scheme of mdev might affect some of the existing
> tools.
> > > > > > It's unclear how/if it actually affects.
> > > > > > mdevctl [2] is very recently developed and can be enhanced for
> > > > > > dual naming scheme.
> > > > >
> > > > > I think we've already nak'ed this one, the device namespace
> > > > > becomes meaningless if the name becomes just a string where a
> > > > > uuid might be an example string.  mdevs are named by uuid.
> > > > >
> > > > > > Option-3: mdev uuid alias
> > > > > > Instead of shorter mdev name or mdev index, have alpha-numeric
> > > > > > name alias. Alias is an optional mdev sysfs attribute such as '=
foo',
> 'bar'.
> > > > > > example mdev create command:
> > > > > > UUID=3D$(uuidgen)
> > > > > > echo $UUID alias=3Dfoo
> > > > > > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/cr
> > > > > > > eate
> > > > > > > example netdevs:
> > > > > > examle netdevs:
> > > > > > repnetdev =3D ens2f0_mfoo
> > > > > > mdev_netdev=3Denmfoo
> > > > > >
> > > > > > Pros:
> > > > > > 1. All same as option-1.
> > > > > > 2. Doesn't affect existing mdev naming scheme.
> > > > > > Cons:
> > > > > > 1. Index scheme of option-1 is better which can number large
> > > > > > number of mdevs with fewer characters, simplifying the
> > > > > > management
> > > tool.
> > > > >
> > > > > No better than option-1, simply a larger secondary namespace,
> > > > > but still requires the user to come up with two independent
> > > > > names for the
> > > device.
> > > > >
> > > > > > Option-4: extend IFNAMESZ to be 64 bytes Extended IFNAMESZ
> > > > > > from 16 to
> > > > > > 64 bytes phys_port_name=3Dmdev_UUID_string
> > > mdev_netdev_name=3DenmUUID
> > > > > >
> > > > > > Pros:
> > > > > > 1. Doesn't require mdev extension
> > > > > > Cons:
> > > > > > 1. netdev stack, driver, uapi, user space, boot config wide cha=
nges 2.
> > > > > > Possible user space extensions who assumed name size being 16
> > > > > > characters 3. Single device type demands namesize change for
> > > > > > all netdev types
> > > > >
> > > > > What about an alias based on the uuid?  For example, we use
> > > > > 160-bit sha1s daily with git (uuids are only 128-bit), but we
> > > > > generally don't reference git commits with the full 20 character =
string.
> > > > > Generally 12 characters is recommended to avoid ambiguity.
> > > > > Could mdev automatically create an
> > >
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > abbreviated sha1 alias for the device?  If so, how many
> > > > > characters should we
> > >     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > use and what do we do on collision?  The colliding device could
> > > > > add enough alias characters to disambiguate (we likely couldn't
> > > > > re-alias the existing device to disambiguate, but I'm not sure
> > > > > it matters, userspace has sysfs to associate aliases).  Ex.
> > > > >
> > > > > UUID=3D$(uuidgen)
> > > > > ALIAS=3D$(echo $UUID | sha1sum | colrm 13)
> > > > >
> > > > I explained in previous reply to Cornelia, we should set UUID and
> > > > ALIAS at the
> > > same time.
> > > > Setting is via different sysfs attribute is lot code burden with no=
 extra
> benefit.
> > >
> > > Just an example of the alias, not proposing how it's set.  In fact,
> > > proposing that the user does not set it, mdev-core provides one
> automatically.
> > >
> > > > > Since there seems to be some prefix overhead, as I ask about
> > > > > above in how many characters we actually have to work with in
> > > > > IFNAMESZ, maybe we start with 8 characters (matching your
> > > > > "index" namespace) and expand as necessary for disambiguation.
> > > > > If we can eliminate overhead in IFNAMESZ, let's start with 12.
> > > > > Thanks,
> > > > >
> > > > If user is going to choose the alias, why does it have to be limite=
d to sha1?
> > > > Or you just told it as an example?
> > > >
> > > > It can be an alpha-numeric string.
> > >
> > > No, I'm proposing a different solution where mdev-core creates an
> > > alias based on an abbreviated sha1.  The user does not provide the al=
ias.
> > >
> > > > Instead of mdev imposing number of characters on the alias, it
> > > > should be best
> > > left to the user.
> > > > Because in future if netdev improves on the naming scheme, mdev
> > > > will be
> > > limiting it, which is not right.
> > > > So not restricting alias size seems right to me.
> > > > User configuring mdev for networking devices in a given kernel
> > > > knows what
> > > user is doing.
> > > > So user can choose alias name size as it finds suitable.
> > >
> > > That's not what I'm proposing, please read again.  Thanks,
> >
> > I understood your point. But mdev doesn't know how user is going to use
> udev/systemd to name the netdev.
> > So even if mdev chose to pick 12 characters, it could result in collisi=
on.
> > Hence the proposal to provide the alias by the user, as user know the b=
est
> policy for its use case in the environment its using.
> > So 12 character sha1 method will still work by user.
>=20
> Haven't you already provided examples where certain drivers or subsystems
> have unique netdev prefixes?  If mdev provides a unique alias within the
> subsystem, couldn't we simply define a netdev prefix for the mdev subsyst=
em
> and avoid all other collisions?  I'm not in favor of the user providing b=
oth a uuid
> and an alias/instance.  Thanks,
>=20
For a given prefix, say ens2f0, can two UUID->sha1 first 9 characters have =
collision?
