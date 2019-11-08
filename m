Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24FF4FF3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfKHPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:40:27 -0500
Received: from mail-eopbgr20068.outbound.protection.outlook.com ([40.107.2.68]:36599
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfKHPk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:40:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeMtBT2tffJ7ot31XPiAPVc6GR408jtTKJMurEiK9Zw+qKRSG4K1qUddZt6fdcsCEj9xNsWut3rmNWUljtI3LVyhgjAPKqQku3wDX6Lv5C+QK1Hmkh78e4Ox6JE+CSyZh9evcvCeKvTsYpdeKzoOT9W2paBJwyjzpEMAbn4K3qQOlmH+JeZNnUJJzP6O0VKm00oJs+88Ymh1rIrUrMCqwoQ7B5/WmOGK6NUDKC0edqS5owmVUTzjmdDavbEjKq75kLDBL9F561IS5fv7yLQhPUBbutpS2ppKOD2RCqJgYNsMy2eNaxUlO10oQjOyHR5KWPgtThprCFSgXNXOVGYHZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9k9Z7hz5ZrxTbbfxvPk8feUHyZguRcdHhRzUF3AX/Nk=;
 b=Vg5Rx7yi7UWHu7zDk6H10K42DIoOmEVOthDg45ECjJlIGSndO4dThKe8jgW2nj6dR+b+WELfUkeX2mJWk4oLFC29fbkx+qlSEsqX7VoJZKhZ7nA24owQ8hsgHhFHm1PO4PZmyQH31J9UBBnmC0vYZS9GD6dBLYMifK8osahpMoYjiHGzjhw1SiurWc6Q0xMOZn99QmE5EHY+hRg4/EWncnY1cMFJKPchP1rHT9dmHulU0joNYfHUsh2tzoeYEyDLSRIyhpLgUhAWMlpBtTmlNePA+v6k9E2asweCNL4lFB/cYCY2IHzDW2uWALRoUdhp2nLTmpAVTfIpdRnTcrrZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9k9Z7hz5ZrxTbbfxvPk8feUHyZguRcdHhRzUF3AX/Nk=;
 b=GGUwjoRnqGM8iPeYyJg8JKjazp+MIlLq5a/UVsLp41ZKvStCOKJFwf1iSrjJHhvRz3ZEnpyuokuZo64Se9Txfz0bsPlSmuAi9++JMO5ju4NE6Ao5WtknhOwChmkVKh51FesfAryWP9WFfuemPhNBkOn6m+X0ZiFfeQPbD+n29Wk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5140.eurprd05.prod.outlook.com (20.178.19.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 15:40:22 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:40:22 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>,
        "Ertman@ziepe.ca" <Ertman@ziepe.ca>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnA
Date:   Fri, 8 Nov 2019 15:40:22 +0000
Message-ID: <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho> <20191108144054.GC10956@ziepe.ca>
In-Reply-To: <20191108144054.GC10956@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a688eac-78e2-4299-7564-08d76461f76c
x-ms-traffictypediagnostic: AM0PR05MB5140:|AM0PR05MB5140:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB514075217593CE5A46AEC043D17B0@AM0PR05MB5140.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(51444003)(189003)(13464003)(199004)(305945005)(53546011)(8676002)(9686003)(6506007)(316002)(81166006)(81156014)(102836004)(99286004)(25786009)(8936002)(52536014)(186003)(476003)(110136005)(6436002)(66446008)(64756008)(66476007)(54906003)(4326008)(66946007)(5024004)(5660300002)(55016002)(6306002)(66556008)(229853002)(76116006)(14444005)(256004)(6116002)(7736002)(7696005)(74316002)(6246003)(76176011)(14454004)(11346002)(33656002)(46003)(478600001)(2501003)(7416002)(486006)(966005)(2906002)(71190400001)(86362001)(71200400001)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5140;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZNdTgPu/a7NZ+mGpjpSsQxxgTc+4AgmWOQ0wbHpm9gb82LtyQrcraLVfk42soCOnmkOoDr8EmnEHO9gYwgWCfHhxWsQottY+CBYtlFbUxr8BCXy78T9Fhz3qEp489Bd7M8+Q2dLr9cU/zdijC/HXcCMkD+SWZR2twxJWGKhMEBIXNUr5gSFBfK3B/35UW5/DdZ3PkRvIgVlqg9bEx72gYdnMhIiAdkwbADfKCiugo+xcZigcPJlgVZV4ob1BPVXAxbhbKoZ+Nt+4tY5vF3Ze3SMO+5mSuCjPXhW1NEZlmSXys34/xeoVAVfDbLvooMEcdOcaCk17M0yPEHW0qQzLBWAnx99iS4wZfM5U2ezha9Esg1NqUZ7+GPE1QLDHXy23KfXEOLg14ea07Rx3s0pasFkf97liDUgMwC+/pqc1o80waOgq+lniOOoQHGFRL/lG3dnVM3APwaaUKlczgZ7/SoltadgD2dQD4J/77kcgoQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a688eac-78e2-4299-7564-08d76461f76c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:40:22.0231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34ObVi3fTt28IAGwc8YobwQYcK1r0Utcl7LfxZIDtMlWQPlkZ6MFUdAT8/rgQdtuAL7W6GgRMfWmwyMPUHnYhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

+ Greg

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, November 8, 2019 8:41 AM
> To: Jiri Pirko <jiri@resnulli.us>; Ertman@ziepe.ca; David M
> <david.m.ertman@intel.com>; gregkh@linuxfoundation.org
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>; Parav Pandit
> <parav@mellanox.com>; alex.williamson@redhat.com;
> davem@davemloft.net; kvm@vger.kernel.org; netdev@vger.kernel.org;
> Saeed Mahameed <saeedm@mellanox.com>; kwankhede@nvidia.com;
> leon@kernel.org; cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux=
-
> rdma@vger.kernel.org; Or Gerlitz <gerlitz.or@gmail.com>
> Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
>=20
> On Fri, Nov 08, 2019 at 01:12:33PM +0100, Jiri Pirko wrote:
> > Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com
> wrote:
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
> Did anyone consult Greg on this?
>=20
Back when I started with subdev bus in March, we consulted Greg and mdev ma=
intainers.
After which we settled on extending mdev for wider use case, more below.
It is extended for multiple users for example for virtio too in addition to=
 vfio and mlx5_core.

> The new intel driver has been having a very similar discussion about how =
to
> model their 'multi function device' ie to bind RDMA and other drivers to =
a
> shared PCI function, and I think that discussion settled on adding a new =
bus?
>=20
> Really these things are all very similar, it would be nice to have a clea=
r
> methodology on how to use the device core if a single PCI device is split=
 by
> software into multiple different functional units and attached to differe=
nt
> driver instances.
>=20
> Currently there is alot of hacking in this area.. And a consistent scheme
> might resolve the ugliness with the dma_ops wrappers.
>=20
> We already have the 'mfd' stuff to support splitting platform devices, ma=
ybe
> we need to create a 'pci-mfd' to support splitting PCI devices?
>=20
> I'm not really clear how mfd and mdev relate, I always thought mdev was
> strongly linked to vfio.
>=20
Mdev at beginning was strongly linked to vfio, but as I mentioned above it =
is addressing more use case.

I observed that discussion, but was not sure of extending mdev further.

One way to do for Intel drivers to do is after series [9].
Where PCI driver says, MDEV_CLASS_ID_I40_FOO
RDMA driver mdev_register_driver(), matches on it and does the probe().

> At the very least if it is agreed mdev should be the vehicle here, then i=
t
> should also be able to solve the netdev/rdma hookup problem too.
>=20
> Jason

[9] https://patchwork.ozlabs.org/patch/1190425

