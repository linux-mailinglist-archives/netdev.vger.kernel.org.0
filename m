Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56ADF58C1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbfKHUky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:40:54 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:57314
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728371AbfKHUkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:40:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFPZfOpDBhxi96B8TvaABixBNR10zATb7ZfICBq1EPTXDzantcy1NaFKeYzHI5ODfspbYPeLtP0a63IpmBQgYjpX0jLpvyeKQMTcTT9JySC3MY3csRI5r9w4CrEhwRxf1SsoNhkqT8IGPpPyROVmtV9NWhsxeHFBiFjTNP5gljDTNYoVZkYZx74JIszZNJP/3aamInM/h+SovBsZSPNx2zp/T4/4JrOyhEjDDOB+4sf5lFGYSHdQC7WRJ96lbDngP4mB1gfsVkvbNJaUaXejdXC7p/Se2sBqwvmjfZm3cKeG00thpr0UJdLVVY5yJvobFs+CGzaLyNfwYiUqbb6tDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqMkVco1mioqpQUzo/SqdWaL1ban0D2VCEXu/RdRlu0=;
 b=TSPFu37MO50bC3diwtN/e0f/PJ4D0IZdAPLIxJ+iInrZ4sVVQE8aJa4STPFY8Zk1rDZy9AAZCJ9J0jxI7tn95aXov8q9VBaJtKDZsHbgvFtz3s4ySU6EMQjANR1YI14b3lI6lvnHQI7hglj80vSTyciTZyYN/jIDjGq6FiroM9zmzAeZe5dQs4aVYiEwzVvXaAyVETg5E+mnACtJCWViBIrAj1PX2NHnmd2wekB+taYa4sqE+klqUOK9NILXADybaeiZJ6RUpgr/tUKyfsgXYNRdAUB/NeGO0g9RayZTupjOyoo3IdkzM/Y8aEGtsZuD23uorslLdBgqsF6knQ+klA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqMkVco1mioqpQUzo/SqdWaL1ban0D2VCEXu/RdRlu0=;
 b=SCoTcvs2ub9V/MhPMGA7FQ9ePjjBOBVjT/9UfjQ/0wOYEtmVTzieVbm84LhsDGvLZluWf6saYsuGgrDCSejZOoM4/j3gtqtz5G6pXDOvAKfRKUOsFoMgzJgy0YHmkOzfMtgWPejB4B82gtypWHwSKGx3xr7hc1A181Ly3rYSLco=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6273.eurprd05.prod.outlook.com (20.179.35.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 20:40:46 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 20:40:46 +0000
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
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAHO0AIAACa0AgAADgBA=
Date:   Fri, 8 Nov 2019 20:40:46 +0000
Message-ID: <AM0PR05MB48666B8475EF12809FE31059D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho> <20191108110640.225b2724@cakuba>
 <20191108194118.GY6990@nanopsycho>
In-Reply-To: <20191108194118.GY6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 42f2b5e1-7b0d-4943-c2ec-08d7648bee9c
x-ms-traffictypediagnostic: AM0PR05MB6273:|AM0PR05MB6273:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB627344F51F0FEC3F286D04D3D17B0@AM0PR05MB6273.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(13464003)(102836004)(11346002)(7696005)(71200400001)(486006)(71190400001)(6246003)(14454004)(110136005)(4326008)(478600001)(52536014)(256004)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(25786009)(55016002)(33656002)(6116002)(6506007)(229853002)(3846002)(8936002)(186003)(6436002)(81156014)(26005)(8676002)(446003)(7416002)(14444005)(74316002)(2906002)(76176011)(305945005)(99286004)(7736002)(9686003)(66066001)(81166006)(476003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6273;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DgNL+uryIDjbii/XBxQCZV2SJI7+KT3ZPKhHpkKe3AY4mP4SVfdQCFTO0SbDkLVaZvbH2ts53UN8hgFX3BQr+PjhKAP+AR2g0AZHztGw2BOTyF4odWwFhNsgPYkN/pK3yJ2Xuag/u4GC6ey3YrWhwYlyy1MVju0Ztq25As63FC4b2iP6AnDNsUrZveTpRiBxOVxUP2e04KEKvTpHpVdTcwNUB2LSpuxFuHOlIX7cnGXdl1zqJYQsOe4bjpo3p5awgymHepEUCCvwGTTE0WQbxnBVHbVmeZnxKKQjayy8m1mQPNBRQD+Wdn0JrBqLcHSPOmNRT5uZGwuDoa6N2FEd0WbWjMVahPMCWx5LdA1SG2BcRt5HuLoMhptd7ZHDRpZZAECg6bZ9/qxRGLYwGwDQzzK8GSTM5DIVnkltnMevAsw22tGzyR2Um2XIG/k76dn7
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f2b5e1-7b0d-4943-c2ec-08d7648bee9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 20:40:46.1068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nam1WP/EN9YIw9x9GjFHt4NTWuIUJhgi2UMKN5aRpMTdiyNvkIPx6urxxa9KCQv9DwU8SDejbmKmBO+oe7enFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6273
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
>=20
> Fri, Nov 08, 2019 at 08:06:40PM CET, jakub.kicinski@netronome.com wrote:
> >On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:
> >> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com
> wrote:
> >> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
> >> >> Mellanox sub function capability allows users to create several
> >> >> hundreds of networking and/or rdma devices without depending on PCI
> SR-IOV support.
> >> >
> >> >You call the new port type "sub function" but the devlink port
> >> >flavour is mdev.
> >> >
> >> >As I'm sure you remember you nacked my patches exposing NFP's PCI
> >> >sub functions which are just regions of the BAR without any mdev
> >> >capability. Am I in the clear to repost those now? Jiri?
> >>
> >> Well question is, if it makes sense to have SFs without having them
> >> as mdev? I mean, we discussed the modelling thoroughtly and
> >> eventually we realized that in order to model this correctly, we need =
SFs on
> "a bus".
> >> Originally we were thinking about custom bus, but mdev is already
> >> there to handle this.
> >
> >But the "main/real" port is not a mdev in your case. NFP is like mlx4.
> >It has one PCI PF for multiple ports.
>=20
> I don't see how relevant the number of PFs-vs-uplink_ports is.
>=20
>=20
> >
> >> Our SFs are also just regions of the BAR, same thing as you have.
> >>
> >> Can't you do the same for nfp SFs?
> >> Then the "mdev" flavour is enough for all.
> >
> >Absolutely not.
> >
> >Why not make the main device of mlx5 a mdev, too, if that's acceptable.
> >There's (a) long precedence for multiple ports on one PCI PF in
> >networking devices, (b) plenty deployed software which depend on the
> >main devices hanging off the PCI PF directly.
> >
> >The point of mdevs is being able to sign them to VFs or run DPDK on
> >them (map to user space).
> >
> >For normal devices existing sysfs hierarchy were one device has
> >multiple children of a certain class, without a bus and a separate
> >driver is perfectly fine. Do you think we should also slice all serial
> >chips into mdevs if they have multiple lines.
> >
> >Exactly as I predicted much confusion about what's being achieved here,
> >heh :)
>=20
> Please let me understand how your device is different.
> Originally Parav didn't want to have mlx5 subfunctions as mdev. He wanted=
 to
> have them tight to the same pci device as the pf. No difference from what=
 you
> describe you want.
> However while we thought about how to fit things in, how to
> handle na phys_port_name, how to see things in sysfs we came up with an i=
dea
> of a dedicated bus. We took it upstream and people suggested to use mdev =
bus
> for this.
>=20
You are right. We considered multiple ports approach, followed by subdevice=
s and mfd.
Around that time mdev was being proposed that can address current and futur=
e VM/userspace usecases using one way to lifecycle the devices.

> Parav, please correct me if I'm wrong but I don't think where is a plan t=
o push
> SFs into VM or to userspace as Jakub expects, right?
With this series - certainly not.
In future, if mdev to be used by via vfio/VM framework, why should we preve=
nt it (ofcourse after implementing necessary isolation method)?

