Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5674AF5B4B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfKHWsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:48:52 -0500
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:10823
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfKHWsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 17:48:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPMlYuCpyUXagM2wayBG9bVizARjstJhQjT8J7omlXaP1lm0cgCU6usS7ijPEUAkGM65AgcOC33NEmOgVtj4X/H6BPVwLOvvAvlLrswVCS4KtmPs3FZ2OBRFIlpiWHe30j0vM8L8LVFvA6BcizaklZ/yh1CYRP7ddRA5dShcNnhKfnJbgN+iqTzsZ9YCUHMBdHAmAtY19ePBycO/onCTTMPjiGNTT5jWZnL89ZjaROQZGjvye0zUveci6/fPWwG84l/6W5JKqDEvTkPbvYwFLHVA3Ue4UQqMRSACfs4HZem1pKh3ZwC4G4g4LZMekFs9SxlrfZ9Yh9laWHAZds2yYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PElxMs7iYcrVUataBRvaZWO2WTXkb9v7d8x6TtyJWx0=;
 b=UQXliRpR/ejFmG3NKNxd46F6JaIiHoMoVlGDWsLa7V9kWjrX5+l9DYr3eaLwD9ELZ+e91X+CLrKO1cX2ZdAPxnDJVhcrLpT1U1ZkCPvegjqj+Kh9pVTs6H48e9WBD6uzPDxijgFx2dee4XFSyqC6GiRlDp8I3dc8WPBEnlVfCVJOz4nRK2zRQUoNJ/aarCNO2y6cDk+8H+Pw0zPYxn72ROtkdbi3EkJxjkTKyi1Y8q3QH6o3Uek6Ap0UMZewsTc5lqyD4Ai/B90/godgCl9mDu+isbsgHJb4NvjnyJFPrDYmc3eMb/Nzwioha3t3I4+70f3dA9l6n39m3uDrGtvubQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PElxMs7iYcrVUataBRvaZWO2WTXkb9v7d8x6TtyJWx0=;
 b=N8dF3O1BEjQuv+FfGhtyMuRz0MvNRl3eDcQWpQBaZTdAaiGf7h9FjRzzY/GExYkRbQwQ5lgbHnq32HyJGi4nYLIigPPBHWCbS50bUs54Gw9SFMTaCyafknLqtvDg9swSVbSxCyOllh6ckCMzYGM3pW9o7KAC3p4VwQYQJqxx/ng=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4532.eurprd05.prod.outlook.com (52.133.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 22:48:31 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 22:48:31 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAABhCAgAAItYCAAAz4AIAABs2Q
Date:   Fri, 8 Nov 2019 22:48:31 +0000
Message-ID: <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>      <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>        <20191108201253.GE10956@ziepe.ca>
        <20191108133435.6dcc80bd@x1.home>       <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
In-Reply-To: <20191108145210.7ad6351c@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 834ded30-1d04-4704-ad12-08d7649dc77e
x-ms-traffictypediagnostic: AM0PR05MB4532:|AM0PR05MB4532:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB45321D793840B62EF7BCFFA5D17B0@AM0PR05MB4532.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(13464003)(199004)(189003)(71190400001)(71200400001)(316002)(66476007)(110136005)(966005)(476003)(25786009)(14454004)(478600001)(7416002)(26005)(7736002)(66446008)(66946007)(66556008)(64756008)(76116006)(3846002)(5024004)(256004)(446003)(14444005)(102836004)(81166006)(76176011)(11346002)(486006)(6116002)(7696005)(81156014)(6506007)(8936002)(74316002)(99286004)(4326008)(186003)(33656002)(305945005)(5660300002)(2906002)(54906003)(6246003)(52536014)(55016002)(6306002)(86362001)(66066001)(9686003)(8676002)(6436002)(229853002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4532;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UQ4kp3nA8/H3O4JAK5pnE5hfknQjIMw1d7vEd8atUw7zvNQaU1Uohs/hc3+/DsxTuozkjNCnXaH+fuw++bajnZdDbcjfzZBuyLzD0LOu2lh7/+NzZ7N/ktNOPInPjc8sXlIquzHrwm7OYx7J1HD0qWexMxIKiOJ/ogK1chooWX/P0MTpPLWMIlB8haa72qrldoxRRANG+N+9JuUtRdJUZ8kgLYsbGhFG/aULZ1rjLXNdki4YMWFGlRbBDK4TrfRB6lTg+Exx6gIeZcesjbjKYRUPiOY+9Ik64lerlfi/Vq9yVyyOAheZfCOWgKkm4DVCC/YAnaVUGZ9w/tRxhULsXpcphDnqguc3aQokUrV4SOA0cc0CJL67PSMxRauLqT5ny/0nOk8qykv0zdhDUGdsIhZIHD+WI48StN1Rv+xu7Ls6Wtqd1Tn3lhAV2+zkiIKk4OO70NBrzuUqkE4HmDBE6gxjuibQFCXDTGt+wtObllI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834ded30-1d04-4704-ad12-08d7649dc77e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 22:48:31.4626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9FHcxZteOT3eNE+sN5xnc/p+UrtnecIOuXQeSsYj8OxIrwgFm9VeEg9n+KN8sS/OAaONqlyV+WkpCVQ2rvpRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4532
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg, Jason,

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
>=20
> On Fri, 8 Nov 2019 17:05:45 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> > On Fri, Nov 08, 2019 at 01:34:35PM -0700, Alex Williamson wrote:
> > > On Fri, 8 Nov 2019 16:12:53 -0400
> > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > > On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > > > > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
> > > > > > > The new intel driver has been having a very similar
> > > > > > > discussion about how to model their 'multi function device'
> > > > > > > ie to bind RDMA and other drivers to a shared PCI function, a=
nd I
> think that discussion settled on adding a new bus?
> > > > > > >
> > > > > > > Really these things are all very similar, it would be nice
> > > > > > > to have a clear methodology on how to use the device core if
> > > > > > > a single PCI device is split by software into multiple
> > > > > > > different functional units and attached to different driver i=
nstances.
> > > > > > >
> > > > > > > Currently there is alot of hacking in this area.. And a
> > > > > > > consistent scheme might resolve the ugliness with the dma_ops
> wrappers.
> > > > > > >
> > > > > > > We already have the 'mfd' stuff to support splitting
> > > > > > > platform devices, maybe we need to create a 'pci-mfd' to supp=
ort
> splitting PCI devices?
> > > > > > >
> > > > > > > I'm not really clear how mfd and mdev relate, I always
> > > > > > > thought mdev was strongly linked to vfio.
> > > > > > >
> > > > > >
> > > > > > Mdev at beginning was strongly linked to vfio, but as I
> > > > > > mentioned above it is addressing more use case.
> > > > > >
> > > > > > I observed that discussion, but was not sure of extending mdev
> further.
> > > > > >
> > > > > > One way to do for Intel drivers to do is after series [9].
> > > > > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > > > > > RDMA driver mdev_register_driver(), matches on it and does the
> probe().
> > > > >
> > > > > Yup, FWIW to me the benefit of reusing mdevs for the Intel case v=
s
> > > > > muddying the purpose of mdevs is not a clear trade off.
> > > >
> > > > IMHO, mdev has amdev_parent_ops structure clearly intended to link
> > > > it to vfio, so using a mdev for something not related to vfio
> > > > seems like a poor choice.
> > >
> > > Unless there's some opposition, I'm intended to queue this for v5.5:
> > >
> > > https://www.spinics.net/lists/kvm/msg199613.html
> > >
> > > mdev has started out as tied to vfio, but at it's core, it's just a
> > > device life cycle infrastructure with callbacks between bus drivers
> > > and vendor devices.  If virtio is on the wrong path with the above
> > > series, please speak up.  Thanks,
> >
> > Well, I think Greg just objected pretty strongly.
> >
> > IMHO it is wrong to turn mdev into some API multiplexor. That is what
> > the driver core already does and AFAIK your bus type is supposed to
> > represent your API contract to your drivers.
> >
> > Since the bus type is ABI, 'mdev' is really all about vfio I guess?
> >
> > Maybe mdev should grow by factoring the special GUID life cycle stuff
> > into a helper library that can make it simpler to build proper API
> > specific bus's using that lifecycle model? ie the virtio I saw
> > proposed should probably be a mdev-virtio bus type providing this new
> > virtio API contract using a 'struct mdev_virtio'?
>=20
> I see, the bus:API contract is more clear when we're talking about physic=
al
> buses and physical devices following a hardware specification.
> But if we take PCI for example, each PCI device has it's own internal API=
 that
> operates on the bus API.  PCI bus drivers match devices based on vendor a=
nd
> device ID, which defines that internal API, not the bus API.  The bus API=
 is pretty
> thin when we're talking virtual devices and virtual buses though.  The bu=
s "API"
> is essentially that lifecycle management, so I'm having a bit of a hard t=
ime
> differentiating this from saying "hey, that PCI bus is nice, but we can't=
 have
> drivers using their own API on the same bus, so can we move the config sp=
ace,
> reset, hotplug, etc, stuff into helpers and come up with an (ex.) mlx5_bu=
s
> instead?"  Essentially for virtual devices, we're dictating a bus per dev=
ice type,
> whereas it seemed like a reasonable idea at the time to create a common
> virtual device bus, but maybe it went into the weeds when trying to figur=
e out
> how device drivers match to devices on that bus and actually interact wit=
h
> them.
>=20
> > I only looked briefly but mdev seems like an unusual way to use the
> > driver core. *generally* I would expect that if a driver wants to
> > provide a foo_device (on a foo bus, providing the foo API contract) it
> > looks very broadly like:
> >
> >   struct foo_device {
> >        struct device dev;
> >        const struct foo_ops *ops;
> >   };
> >   struct my_foo_device {
> >       struct foo_device fdev;
> >   };
> >
> >   foo_device_register(&mydev->fdev);
> >
If I understood Greg's direction on using bus and Jason's suggestion of 'md=
ev-virtio' example,

User has one of the three use cases as I described in cover letter.
i.e. create a sub device and configure it.
once its configured,
Based on the use case, map it to right bus driver.
1. mdev-vfio (no demux business)
2. virtio (new bus)
3. mlx5_bus (new bus)

We should be creating 3 different buses, instead of mdev bus being de-multi=
plexer of that?

Hence, depending the device flavour specified, create such device on right =
bus?

For example,
$ devlink create subdev pci/0000:05:00.0 flavour virtio name foo subdev_id =
1
$ devlink create subdev pci/0000:05:00.0 flavour mdev <uuid> subdev_id 2
$ devlink create subdev pci/0000:05:00.0 flavour mlx5 id 1 subdev_id 3

$ devlink subdev pci/0000:05:00.0/<subdev_id> config <params>
$ echo <respective_device_id> <sysfs_path>/bind

Implement power management callbacks also on all above 3 buses?
Abstract out mlx5_bus into more generic virtual bus (vdev bus?) so that mul=
tiple vendors can reuse?
