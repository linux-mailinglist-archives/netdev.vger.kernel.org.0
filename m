Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CCC2DBACE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgLPFku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:40:50 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:22998 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPFku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 00:40:50 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd99db90000>; Wed, 16 Dec 2020 13:40:09 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 05:40:08 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 05:40:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lD7jlrhup9kgdl2+R6CmXq5VfoEjSjryL4QQ4LVY7NJSuMHeelbCf6ugjjy0REICLzRJUKKoYAGLWlEDHsyVT+IjbSHX/KDv+hzdGV9Txx1EsMjvYx2i9GvfW07CYsQKWf6GnMWrtlwt2cCSwl+Pk33MY4ejfxI1VkWprE1AW2JTNUylxZEtRy2lrlxdY188xt2MHejToXmQCrXGBd6UQAejDj6uqIa0mey/fkALRNp84xd9k2opQKzILfmy8jWL6ALgYWDh86hdGauj9YWIqd9YZ+7Jz5gZWlstwmugQwoXxPvhYW1aaJZjaf+muth+IhJsNDTJHLxLWsjdLhJMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+ttK5TnepA77BsGcXieuKVNfrsDiBKLG0O7ycjwlvc=;
 b=N+HOh11FN4UDxzDQnuY38NKqqnrdNb0HQ577xmerdE3hlznF4S2wDSOrIJBK8loTTz+u74I4KWkAaUMHDKcdAV4CXn2+qavLyFPflMoyvyR500Bry+f2dL6LfYoeE6zB+yI6t7Ft2jEBcUaZ6OQMsQoR2k0yi9y6EgBF367U+SmDueTHL75TNYjj8veaQhJ+Yv2R6gzGM/ovemobsk0batwuUcJA2qnj9r6LAQkuatEn3upex7q9QpUHB1xK+njVaWVX/3xdH7g2wcSoVW0eS+slT3MUG1HVvgxtRAatQbq6mVAjjPqp1D+Q2885VkgTaXmqKN4n58JFyg2oezsjHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4760.namprd12.prod.outlook.com (2603:10b6:a03:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.25; Wed, 16 Dec
 2020 05:40:05 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 05:40:05 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 13/15] devlink: Add devlink port documentation
Thread-Topic: [net-next v5 13/15] devlink: Add devlink port documentation
Thread-Index: AQHW0sFsX8axjEgXGkSRbUiFh5LRw6n453oAgABMkCA=
Date:   Wed, 16 Dec 2020 05:40:05 +0000
Message-ID: <BY5PR12MB4322AC71674FB8DB605404C5DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-14-saeed@kernel.org>
 <20201215165758.4ff58f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215165758.4ff58f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68dcdbad-9498-48a5-163e-08d8a1850aab
x-ms-traffictypediagnostic: BYAPR12MB4760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB476072FC882A2A3AF1B9A736DCC50@BYAPR12MB4760.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkosjRrw8vHY00i6KyFHTN1pvqtjlDOM0wr4D3dKhR8Xiq5IbFGKSk6CHv75UPgQLhQK6lgTzhPN/ZdsU/5iXSkjilrFd2tClWRk0AAxPrueYt2buUwALkBm/ZrMBS556G3/LMl9Lb31JZ/6txVHCoH/6BibmYQpEVW5po7kpGmvbhMjpo6v+fWtcplWAznKf2iDKESdMw5l5sC9WB3w7ThCq7NyTN2T/e9ncP8cpX7UJ5hDgA+VDdnYJHJck051HeABPBXkBTQ48ULpwVXZ2+qcTPA/6FsCfDLhRR9+0fv3HYlJgn3srCRm+hm9X3nX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(366004)(376002)(396003)(66446008)(5660300002)(52536014)(7416002)(186003)(76116006)(478600001)(107886003)(64756008)(66556008)(66946007)(4326008)(66476007)(86362001)(316002)(8936002)(9686003)(110136005)(33656002)(26005)(55016002)(54906003)(55236004)(6506007)(8676002)(7696005)(2906002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MJ9Pt3SGHedlkNSs5fKVWHQJpXo6Knpq2Re/nrtfG/U7PqkT2+7y8Jrr+5UF?=
 =?us-ascii?Q?Eu5Qtq06x1fI69M9RoK6NNxTeOQyFUnSgXVmRyGs/p1GQWjaYes0cVjxLvBK?=
 =?us-ascii?Q?9tvJSaTg7o5U/c2s01s8MlAyPvg+bqhQn+ITMgHSDB6+uQ65UcZR/CLpwgMh?=
 =?us-ascii?Q?KE4xDNEWWPGip0oUvOBLEMhGuvnTQQJkaINgm35FkR1+LzeQO9P/f6kf/On9?=
 =?us-ascii?Q?7Py4+6qkiRVmjSYMigM/UMrbGUnD+o7fbrrqU1otbnWxXiSoqj5DDfdEZMtp?=
 =?us-ascii?Q?PZy32NF4f22Nx3BebZgzJKD7pTMO3MdxxPICtCDJi50WFstHtRtMzvgo4lOS?=
 =?us-ascii?Q?zFhsrXIiy5KTO9J03l9SQlruMZNOIk7sdnZiqEiOubh0HFZQcSr8Dj3eQ0Pu?=
 =?us-ascii?Q?SPqvQViXDceDulMCDDSiu4as44DpC6s8KB8tyNsZQSs6vgfPn1YMx+AweyoI?=
 =?us-ascii?Q?+5rpddMGmhv+ngBz/KLRYw80nP9AWR77lc9sWXr+DF0vuQYnReI0du/kN6BK?=
 =?us-ascii?Q?dtZlNjrqSUP+HkeooUOYeG3Fxe3SxhA6+ZpbeF+1N42C8pJuuoPZ0houGuB0?=
 =?us-ascii?Q?oKvDmQ4aSc8vcXxtib7S6BqNYBEouwrEPckYCYsMSscZyaCFITYeDzgflgyt?=
 =?us-ascii?Q?87BomSrpvV141YAwkTPmZuCJpTec1SWV81FAcIP1DM1ljEIwLCMph+jMmNHs?=
 =?us-ascii?Q?ayb7lC3vAc+2BQhqKuLeYQnwjIGgKudmBiwWjixXu1MN0uuuNHs/8NLSixKk?=
 =?us-ascii?Q?eBOb3uqXMyKcdBxMXV62R52DbxPPV549F+v3o/YjcNi42K2IGxvoQlBjTJ49?=
 =?us-ascii?Q?Zbu5IbPchPWHdpjxFI5vZoia6X/EzCDmyfNsHiWK7+tNOz7BCxnJM22npG6g?=
 =?us-ascii?Q?nMoMLDWEhwx1Dm1ATjydacPBCF8GjRY0tJl29U4nW7rUhea5WJ8FN9V9AqPO?=
 =?us-ascii?Q?wd6EAARjtk8+rVtwi/GRz2X+obnbMnDzQlfQsQl1YFc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dcdbad-9498-48a5-163e-08d8a1850aab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 05:40:05.3058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EarhnJA8/oluEsLHg0eAxoI6XTPrFFh5cV/YtNcYaYGXRSUz/KFPSnyChdAhCRHl4h82SEvXoIPHoIHy+GlRVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4760
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608097209; bh=J+ttK5TnepA77BsGcXieuKVNfrsDiBKLG0O7ycjwlvc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=mfRPEs9FLPN9Vjm7pmbp8gd1Y/zM714M1ucBwTEE5sljI/6zXGGPFQ7mDGDwj82cb
         ZiEMT7awPgPoAm4vcoNXRdtTgaTcs6HwNb8YqkhV5JuIWUOEPhhV5JsQquzdqEONJE
         7UE0jdZ41CpXmWF7UTYXTkEyFDEoPeOGLe/wgSfeo2sj10DYIjfAJu41BCb22JQs3M
         zvJey43y/hZNc863DUYSANBhOt/jBcudJLC/xkhbkBgUUJDr3J7S0s3tEoZu0G1xqX
         Po4ytvlDuVeALEQETaky1ywawQYBIF+h6p+5c0D4wE5I3BFf+rz4aCyy2lchhlf61Q
         u7EeWbc21VZXw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 6:28 AM
>=20
> On Tue, 15 Dec 2020 01:03:56 -0800 Saeed Mahameed wrote:
> > +PCI controllers
> > +---------------
> > +In most cases a PCI device has only one controller. A controller
> > +consists of potentially multiple physical and virtual functions. Such
> > +PCI function consists of one or more ports.
>=20
> s/Such//
>
Ack.
=20
> you say consists in two consecutive sentences.
>=20
> > This port of the function is represented by the devlink eswitch port.
>=20
First sentence describe controller. Second sentence describe function.
So what is wrong in that?

> "This port of the function"? Why not just "Each port"?
>=20
That's fine too. Will simplify.

> > +A PCI Device connected to multiple CPUs or multiple PCI root
> > +complexes or
>=20
> Why is device capitalized all of the sudden?
>
Will fix.
=20
> > +SmartNIC, however, may have multiple controllers. For a device with
> > +multiple
>=20
> a SmartNIC or SmartNICs
>=20
> > +controllers, each controller is distinguished by a unique controller
> number.
> > +An eswitch on the PCI device support ports of multiple controllers.
>=20
> eswitch is on a PCI device?
>
Will change.
=20
> > +An example view of a system with two controllers::
> > +
> > +                 -----------------------------------------------------=
----
> > +                 |                                                    =
   |
> > +                 |           --------- ---------         ------- -----=
-- |
> > +    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s=
)| |
> > +    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/-=
-- |
> > +    | pci rc  |=3D=3D=3D | pf0 |______/________/       | pf1 |___/____=
___/     |
> > +    | connect |  | -------                       -------              =
   |
> > +    -----------  |     | controller_num=3D1 (no eswitch)              =
     |
> > +                 ------|----------------------------------------------=
----
> > +                 (internal wire)
> > +                       |
> > +                 -----------------------------------------------------=
----
> > +                 | devlink eswitch ports and reps                     =
   |
> > +                 | ---------------------------------------------------=
-- |
> > +                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0=
 | |
> > +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN=
 | |
> > +                 | ---------------------------------------------------=
-- |
> > +                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1=
 | |
> > +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN=
 | |
> > +                 | ---------------------------------------------------=
-- |
> > +                 |                                                    =
   |
> > +                 |                                                    =
   |
> > +    -----------  |           --------- ---------         ------- -----=
-- |
> > +    | smartNIC|  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s=
)| |
> > +    | pci rc  |=3D=3D| -------   ----/---- ---/----- ------- ---/--- -=
--/--- |
> > +    | connect |  | | pf0 |______/________/       | pf1 |___/_______/  =
   |
> > +    -----------  | -------                       -------              =
   |
> > +                 |                                                    =
   |
> > +                 |  local controller_num=3D0 (eswitch)                =
     |
> > +
> > + ---------------------------------------------------------
> > +
> > +In above example, external controller (identified by controller
> > +number =3D 1) doesn't have eswitch. Local controller (identified by
> > +controller number =3D 0) has the eswitch. Devlink instance on local
> > +controller has eswitch devlink ports representing ports for both the
> controllers.
> > +
> > +Port function configuration
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > +
> > +A user can configure the port function attribute before enumerating
> > +the
>=20
> s/A user/User/
>=20
> /port function attribute/$something_meaningful/
>=20
May be just say function attribute?

> > +PCI function. Usually it means, user should configure port function
> > +attribute
>=20
> attributes, plural
>=20
Yes, but at present there is only one i.e. mac address, so didn't use plura=
l.
