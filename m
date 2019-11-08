Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026D9F57AA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbfKHTeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:34:12 -0500
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:44673
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387798AbfKHTeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 14:34:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAam43Ri4RMtygJndSsmdU8xA+u3FXxCIqz6rPMU2bkC26EKXtKQS4qLwpuWt7JFLxDhmnwTANdxPhbxzCi62FnlD83CGsypyggzsykB6RdxKBus5b0LGRhaejg86tLGOyO/vFYdoAdk5yqpIod5rcmG5pxr+P0NMzf/EiZXnCrnq0JbW1KxiKdcUWX5DhushhmABnCee3/Pl9byOg84dP8zO1dvwzCOL/4gBsgcFPgrhOZm47gl3J7KWGqXXQpeyAfgRquKU/ZouNrkl2htabw2ogNakuoIEPqa1G5177fmmApDj6z4Vo7vELe2YAfZyVp+N376Tw3BJuSqotiR0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaxm2+ju+IUCltH5L18StFiafN0q4gC6SJGKGpZa5yk=;
 b=MY4SFxh76ujiSel4XU1+Q3v0yjRxRNOpy0Jwk4bIwjzmGojhonnP3BWypJRi1WUT9hWjMpVSIhKLYfjBbt+y2ZiQii8OBIt77JLUYVn2CI3gplEa12NEx2IKH288dv+XrmNQhJl95fheKlFAe7jxZpDjgybmAfvp9lhODShB5DyKVwcjEcrJMNqpTuhycG7GftYuHJKQgY9UD59mOCFQc9hRcIqoIRd4YrOWwWgeXpfwHigVZxlBi+fB9ZrXktbPIG1o3Gj5rsI8GKn1CPkFyc3tSfYeL6nG7sLdll0fRmNyvcsGZxLDwh1acdMkOsRHh/hADEZdAm7jEByY9gs+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaxm2+ju+IUCltH5L18StFiafN0q4gC6SJGKGpZa5yk=;
 b=BfVpG5TSNm9ZuD2y5FWWikeaTz+ADH8KTX+/q68XSMTikfm/sYYpV25IRMXT79niZZsXDKsHTb9FZi1Hj5stDhHAA8MAagJtdwiYTf71BGpyj2cJehVJ5Hzw0KO7mGpphcG1ABSM2hMb8Ez/ws1ctTulKF6qdJ75ue2+ZF1mN6g=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6803.eurprd05.prod.outlook.com (10.141.190.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 19:34:07 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:34:07 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
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
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAHO0AIAAAvjQ
Date:   Fri, 8 Nov 2019 19:34:07 +0000
Message-ID: <AM0PR05MB4866B735135F667D0D512552D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho> <20191108110640.225b2724@cakuba>
In-Reply-To: <20191108110640.225b2724@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c46efb1-0e3e-4982-3f92-08d764829f1f
x-ms-traffictypediagnostic: AM0PR05MB6803:|AM0PR05MB6803:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6803286404D7A382FBCB0451D17B0@AM0PR05MB6803.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(189003)(199004)(13464003)(66066001)(33656002)(6246003)(55016002)(9686003)(99286004)(110136005)(6436002)(305945005)(54906003)(229853002)(71200400001)(14444005)(71190400001)(6116002)(7416002)(186003)(26005)(86362001)(7736002)(4326008)(74316002)(2906002)(256004)(8936002)(3846002)(14454004)(81166006)(81156014)(478600001)(66946007)(6506007)(446003)(66476007)(11346002)(64756008)(66556008)(66446008)(25786009)(5660300002)(76176011)(486006)(8676002)(52536014)(476003)(316002)(102836004)(7696005)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6803;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tKvkxpI4NMzYXMlcN4tuddpM5mwU52BiQD3h5VqhutdUWx/7pkqAcNMquPBsATyyVpS0ZvJ5SSJiVAM9eUl3p+mHylWPg6NGWyC5erhwVDq5U4vdd8ZSCpRG9TYIoiF8Z7WwNhJYZmX0HaIZwX5DOCt1tGdRXpogpn0QktpKU4LYG5gor+xgmKXcJgmdhYgXROpsbPaqVTxyKi/Cvs04WlSQw0uJLX9J1i6RJ5v4ekWoyFzB3wCtzGrlofSrDv4JzskDaDc3///2MXQxNlCA5NM/1bDjxhxyZp9GhLzSkPL4zjkKGBieBzJvYh2PWXluhxbiSquYq4XdXv08rfFYEhGw2e+yLqwXG9lcLSmrj9/8Q9r6wOxp09YPX1qS2uFkpW/HN9chKpSKae5yH3miWoMXRYAKEqGkxIRFoYgJjHEMiWGzKsU2rk5El/DcodUL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c46efb1-0e3e-4982-3f92-08d764829f1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:34:07.3576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSbuX4vvPpyKwU0bSY2rjGEb3ptH0wKKYSTyLB45ocXRwPtO1ssFVytdUej2dAsRnfMapVXBT1WdoXStkZ1k/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6803
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
=20
> On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:
> > Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote=
:
> > >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
> > >> Mellanox sub function capability allows users to create several
> > >> hundreds of networking and/or rdma devices without depending on PCI
> SR-IOV support.
> > >
> > >You call the new port type "sub function" but the devlink port
> > >flavour is mdev.
> > >
> > >As I'm sure you remember you nacked my patches exposing NFP's PCI sub
> > >functions which are just regions of the BAR without any mdev
> > >capability. Am I in the clear to repost those now? Jiri?
> >
> > Well question is, if it makes sense to have SFs without having them as
> > mdev? I mean, we discussed the modelling thoroughtly and eventually we
> > realized that in order to model this correctly, we need SFs on "a bus".
> > Originally we were thinking about custom bus, but mdev is already
> > there to handle this.
>=20
> But the "main/real" port is not a mdev in your case. NFP is like mlx4.
> It has one PCI PF for multiple ports.
>=20
> > Our SFs are also just regions of the BAR, same thing as you have.
> >
> > Can't you do the same for nfp SFs?
> > Then the "mdev" flavour is enough for all.
>=20
> Absolutely not.
>=20
Please explain what is missing in mdev.
And frankly it is too late for such a comment.
I sent out RFC patches back in March-19,=20
further discussed in netdevconf0x13,=20
further discussed several times while we introduced devlink ports,
further discussed in august with mdev alias series and phys_port_name forma=
tion for mdev.
This series shouldn't be any surprise for you at all.
Anyways.

> Why not make the main device of mlx5 a mdev, too, if that's acceptable.
> There's (a) long precedence for multiple ports on one PCI PF in networkin=
g
> devices, (b) plenty deployed software which depend on the main devices
> hanging off the PCI PF directly.
>=20
> The point of mdevs is being able to sign them to VFs or run DPDK on them =
(map
> to user space).
>=20
That can be one use case. That is not the only use case.
I clearly explained the use case scenarios in motivation section of the cov=
er letter. Please go through it again.
This series is certainly not targeting the DPDK usecase right now.

Also please read design decisions section of cover letter...

> For normal devices existing sysfs hierarchy were one device has multiple
> children of a certain class, without a bus and a separate driver is perfe=
ctly fine.
> Do you think we should also slice all serial chips into mdevs if they hav=
e
> multiple lines.
>=20
> Exactly as I predicted much confusion about what's being achieved here, h=
eh :)

We don't see confusion here. Please be specific on the point that confuses =
you.
A PCI device is sliced to multiple devices to make use of it in different w=
ays. Serial chips are not good example of it.
This is fitting in with=20
- overall kernel bus-driver model,=20
- suitable for multiple types of devices (netdev, rdma and their different =
link layers),=20
- devlink framework of bus/device notion for health reporters, ports, resou=
rces
- mapping to VM/bare-metal/container usecase.
- and more..
I don't want to further repeat the cover-letter here.. let's talk specific =
points to improve upon.

