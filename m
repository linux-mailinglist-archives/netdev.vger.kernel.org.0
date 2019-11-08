Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF048F5091
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfKHQGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:06:21 -0500
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:37347
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfKHQGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:06:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9+PDpf7CRI0ZTGwZMVk4+eQKCgFx6Q0IN+C/YOD8HgdMNR8enPtozLUAgHaYmlxGBMXC6mcKqRYq/LXjadqgXv/5Cm6vnOg7iDLzdNnv6q9xjDg/2LsxXIGgiSzE1F93Lb0ijLo8lREER6tD5ZX3C9vw5CK3KmVb/CWiVsdoHVzpHFStS78rbvo2x1z2zjyI8XSXSm1ovq/wZ5onKoHtQk93h2E2zhtsY5jPwFzz5/yfJWirnGgNR3Wfbjws9yMfMExxh9gNPdY/3YkWcyZWJpx/KKz9ytg9X72e4J4XlizkJwyik0Tldux2t5wb5MTwUx4cFkkucjXfvL6YmYnUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOX3WpmQtDPui4YruPYoec/EV47Vo5Zb2D76Mk3qv64=;
 b=l/wgbV/9Hi1zHbQBL5OiWfRkCk5RtcTJ1UPJxlOpBSm53ZTT1oHInnJ0BIoK3a957/AmM5VDNJTVrbxIjfYjIRGWaooBxm1GkASXmZS5H5wQ3xDY6fAmKxp4AYYia09ufB8H8v/4B+NXy015SqgQUbdz6DusUVYgTYXBfYPyL1nuivN73DRf/PM6mp+subVwGLh9XvfyyGL1v+LZqcmwm1YQ8B6Q3CAo7mIy+WE5xrC6FDTZL/LYtwEqMuaLHhnvc/7aUqz/l0BLcJ99a+DwTc+58F/VM+MOdUVe6I8edxwestcgFmgRenSJQikcrFfEnkpIA3ag/c65P9CHBtkp8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOX3WpmQtDPui4YruPYoec/EV47Vo5Zb2D76Mk3qv64=;
 b=QJ4/LhWFFaYu8V0VHH42EKFfMDL12ewLlGxw6FHywAdh0No4XCOqu9KfxOx8wp4bdnfPT7swcQvR/MPr2LR6G8t3UmC2dAF+O4U4M63SdA8sxdLCB2nWsIbw6Y2f4Tc3nUzm9qUzvtEa6VzgxxGornwripT+On1hhLvX6NuLmYw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4129.eurprd05.prod.outlook.com (52.134.125.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 16:06:16 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 16:06:16 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAEDxgA==
Date:   Fri, 8 Nov 2019 16:06:16 +0000
Message-ID: <AM0PR05MB48667670B88B06C8A2401F97D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
In-Reply-To: <20191108121233.GJ6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c8117ab-ffce-4a28-c163-08d7646595df
x-ms-traffictypediagnostic: AM0PR05MB4129:|AM0PR05MB4129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB41297BAAFBEDD6E7B5A4F1F4D17B0@AM0PR05MB4129.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(199004)(189003)(13464003)(71190400001)(52536014)(71200400001)(14454004)(2906002)(25786009)(229853002)(316002)(99286004)(7416002)(66446008)(54906003)(6436002)(66946007)(64756008)(110136005)(66556008)(66476007)(76116006)(74316002)(8676002)(5660300002)(46003)(81156014)(476003)(81166006)(8936002)(6116002)(486006)(53546011)(55016002)(6246003)(6506007)(7736002)(33656002)(9686003)(76176011)(14444005)(102836004)(7696005)(305945005)(4326008)(86362001)(446003)(11346002)(256004)(186003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4129;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F5HMsTQ1EmDlaFwMgUJ5LXPXOem/2GqDuJfqoZ1q9xQ83ZsOdxe1LiUhe1ownAKjb38zqt8S22cKdrK97HGi5tgnaPWG6YOHh2aBRkrT2aXSyga6qkqDJcfTgIZG/ks6M41B93Biy0pKsDD7rpGw8j+9mZqcvOuAXNLkfL7/FWVwD2ArGYFcGjwTBfu5irKsnldr3bZVqbcH+hZfSat3CdgTBj6d8f+6b38JVUV1P5GzwPPg3l2dH6rg/Kj0VNTFqZu1z/0m7vCwJJKojadRjylfAk0ZTTxnQleYrZL3ZQvsVpupXEBe5IujjA+bzfnXhw9Ox9C8+KTLUhMMevGv4Xd7PForuf0bBKPTh0j4/8VpCulyzLioEoAZVh/oPcq6WELWtUwRLycLHQ5TT22IF9dR+yia9y/at5pQLAM5ecyhU8OvfO3Yf9PWH3OGAc2G
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8117ab-ffce-4a28-c163-08d7646595df
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 16:06:16.3859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zS9ePGDTGd6i7XEKtkjkobBpN7uQ36sZGAkioBl3RiCHfJ+cZux34ZkMCU3MeBHvMZMjSEDmQfWGwFHxhq1cUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 6:13 AM
> To: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Parav Pandit <parav@mellanox.com>; alex.williamson@redhat.com;
> davem@davemloft.net; kvm@vger.kernel.org; netdev@vger.kernel.org;
> Saeed Mahameed <saeedm@mellanox.com>; kwankhede@nvidia.com;
> leon@kernel.org; cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux=
-
> rdma@vger.kernel.org; Or Gerlitz <gerlitz.or@gmail.com>
> Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
>=20
> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:
> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
> >> Mellanox sub function capability allows users to create several
> >> hundreds of networking and/or rdma devices without depending on PCI
> SR-IOV support.
> >
> >You call the new port type "sub function" but the devlink port flavour
> >is mdev.
> >
> >As I'm sure you remember you nacked my patches exposing NFP's PCI sub
> >functions which are just regions of the BAR without any mdev
> >capability. Am I in the clear to repost those now? Jiri?
>=20
> Well question is, if it makes sense to have SFs without having them as md=
ev?
> I mean, we discussed the modelling thoroughtly and eventually we realized
> that in order to model this correctly, we need SFs on "a bus".
> Originally we were thinking about custom bus, but mdev is already there t=
o
> handle this.
>=20
> Our SFs are also just regions of the BAR, same thing as you have.
>=20
> Can't you do the same for nfp SFs?
> Then the "mdev" flavour is enough for all.
>=20
>=20
> >
> >> Overview:
> >> ---------
> >> Mellanox ConnectX sub functions are exposed to user as a mediated
> >> device (mdev) [2] as discussed in RFC [3] and further during
> >> netdevconf0x13 at [4].
> >>
> >> mlx5 mediated device (mdev) enables users to create multiple
> >> netdevices and/or RDMA devices from single PCI function.
> >>
> >> Each mdev maps to a mlx5 sub function.
> >> mlx5 sub function is similar to PCI VF. However it doesn't have its
> >> own PCI function and MSI-X vectors.
> >>
> >> mlx5 mdevs share common PCI resources such as PCI BAR region, MSI-X
> >> interrupts.
> >>
> >> Each mdev has its own window in the PCI BAR region, which is
> >> accessible only to that mdev and applications using it.
> >>
> >> Each mlx5 sub function has its own resource namespace for RDMA
> resources.
> >>
> >> mdevs are supported when eswitch mode of the devlink instance is in
> >> switchdev mode described in devlink documentation [5].
> >
> >So presumably the mdevs don't spawn their own devlink instance today,
> >but once mapped via VIRTIO to a VM they will create one?
>=20
> I don't think it is needed for anything. Maybe one day if there is a need=
 to
> create devlink instance for VF or SF, we can add it. But currently, I don=
't see
> the need.
>=20
>=20
> >
> >It could be useful to specify.
> >
> >> Network side:
> >> - By default the netdevice and the rdma device of mlx5 mdev cannot
> >> send or receive any packets over the network or to any other mlx5 mdev=
.
> >
> >Does this mean the frames don't fall back to the repr by default?
>=20
> That would be the sane default. If I up the representor, I should see pac=
kets
> coming in from SF/VF and I should be able to send packets back.

It is similar to VF. I clarified in previous email.
Wil update the cover letter to update the description.
