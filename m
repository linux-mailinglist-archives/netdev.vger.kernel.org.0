Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57F4F5C80
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfKIApL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:45:11 -0500
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:16330
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfKIApL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:45:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eh/qOPg0B/fKzy36cQe48dFFXiCW11q9svz/3khamYjg0ov5wrXQ+i9yLTDX6Sp2wsQiAHUcQi4vKACH1h1Z04TP4A4Xcgif7K8UAQHO9oa8UUFHmQoWz2N4Mc1C+OxNnqkrmsCOyDg9bAfQ+ZrSh2tID5suzjIrdmm23Ha+gNmfiOus8e1IvaSkzAkCqK8FeIHDiJL1RuNiKenIra+5No32zeQK2h5udCl5L5ZITCgzptiruW9ZwnuCtFYNtf1W/lvGEkxwoukbyGl2B/qEpSRMJSLusA/ko+h8Bh3BXxPGtFCERsFS5zIo2/gjCdnGXCqxS6Hv/N3F2wzgD43ZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lh44w4/ObRfT70/RRZc4l+jo6CQ/PmXzOHtcLpy2JNA=;
 b=dxEByeFUER2sD4X3yH0X/jHYjDZcq6wBxI2vcH4e/B3sX9Hgm2m0MHl+j5ms7PBIq8Nn4hqZkgSpt9Fwhmm4KqY/duyEnUxmrM1I17rR8hhvCeS6GSBc3Cg0iUudC7XV0gdvw9qoX2vqrfWnLPw+0aqVd639ayj08rbZJ/LBnu40ReYWxnls/lGCiieq6Cl4cXgFtYXXT4Mkp2+jv+1vzOCbideCSrurDF9/1l8qRgSz3AzBaZ1sNzUAR86xacE03aWjA+YT/FdVc0b1xgWoDRYzX702PQcS8qvBIQ9Ikn2NHEm9iIyu8HrjUdtxic2A4PYDH4OZNCAiDY6Ech0AzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lh44w4/ObRfT70/RRZc4l+jo6CQ/PmXzOHtcLpy2JNA=;
 b=HixJkGVHsma4deKDRDw9ZOL1dxBpWWv6CaWFUD9AWcAORTsKp3IWifl5O4453g/WNp36yM+WxpEvLfVuC5X8tXrZXLhsNSrizbIXNOwK1V4Tore3oBKfYW1sjSdqqRtKlQS2jtIkEXCDAWE+4aQrFjcQ7WWCrEynDmBLeJnzoL4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6049.eurprd05.prod.outlook.com (20.178.202.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Sat, 9 Nov 2019 00:45:04 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Sat, 9 Nov 2019
 00:45:04 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
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
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAABhCAgAAItYCAAAz4AIAAJzCAgAAExhA=
Date:   Sat, 9 Nov 2019 00:45:04 +0000
Message-ID: <AM0PR05MB4866C174D5DAC301D97B8324D17A0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho> <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba> <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home> <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home> <20191109001225.GA31761@ziepe.ca>
In-Reply-To: <20191109001225.GA31761@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 91879694-1412-4d11-c473-08d764ae0f97
x-ms-traffictypediagnostic: AM0PR05MB6049:|AM0PR05MB6049:
x-ms-exchange-purlcount: 4
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6049FE5C6B228CD197C8F676D17A0@AM0PR05MB6049.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(13464003)(189003)(199004)(6306002)(66066001)(9686003)(966005)(74316002)(102836004)(229853002)(305945005)(476003)(99286004)(26005)(446003)(316002)(33656002)(14454004)(7736002)(486006)(11346002)(76176011)(86362001)(186003)(8936002)(110136005)(25786009)(256004)(7696005)(3846002)(6116002)(6246003)(478600001)(14444005)(54906003)(6506007)(81156014)(81166006)(52536014)(71190400001)(71200400001)(6436002)(66556008)(64756008)(55016002)(4326008)(76116006)(66946007)(7416002)(66446008)(8676002)(5660300002)(66476007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6049;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2LDOgNl/EsZolUs1+GCppzYBOs1I82Olmg9THQF4MzyU2VPa/KOibP08dEagLKDDuXCqZC2vMps1//AvBE6dJMnuqTxMrjOvMAaxBkqAV9psIdnjV4xW6JfTe+/u2su+uGJoYeA9Zj+TGiqbx6BhsdNvgGfvUGSi+PE0l390zIpbA9ohaiNWlyLA2o4Kb6amMLqHtHkA9z6Pol7iyCtiW5LyO9Vl4DcZSzA4vjWmxU655OO2WrKJ17lNYEv4gFag+uuWKGe4tprNo1jDV1KmOs7Qd90ztNpKL/SaPKLf43j2Y0bvegWmMXg1SHGNf0Kd6MjOXg4SOElrs1xZoDkpHdkshU/swZGIm80BY5H0tT3xOTCuHqV1sBxBtPtMgpuc1TWdJ7O7Yr8HissR/k9Dw8VHnIiQW7Sc9hcJGk32nEGrdp7AmBI2Sa0eI9s/U2mA4jSTVkp+ezo4P7sQ6EtDpgqtizwjCfNIf1L0To0E5p4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91879694-1412-4d11-c473-08d764ae0f97
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 00:45:04.3386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rCNSmIqeJwg23hPcBGr3u5gIC+NVd1hIXWIFLFjJXu2jkkiQsPmlNT7DM5ljoDlgB0mx6NPcDaPcGpBV5PYmMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
>=20
> On Fri, Nov 08, 2019 at 02:52:10PM -0700, Alex Williamson wrote:
> > > >
> > > > Unless there's some opposition, I'm intended to queue this for v5.5=
:
> > > >
> > > > https://www.spinics.net/lists/kvm/msg199613.html
> > > >
> > > > mdev has started out as tied to vfio, but at it's core, it's just
> > > > a device life cycle infrastructure with callbacks between bus
> > > > drivers and vendor devices.  If virtio is on the wrong path with
> > > > the above series, please speak up.  Thanks,
> > >
> > > Well, I think Greg just objected pretty strongly.
> > >
> > > IMHO it is wrong to turn mdev into some API multiplexor. That is
> > > what the driver core already does and AFAIK your bus type is
> > > supposed to represent your API contract to your drivers.
> > >
> > > Since the bus type is ABI, 'mdev' is really all about vfio I guess?
> > >
> > > Maybe mdev should grow by factoring the special GUID life cycle
> > > stuff into a helper library that can make it simpler to build proper
> > > API specific bus's using that lifecycle model? ie the virtio I saw
> > > proposed should probably be a mdev-virtio bus type providing this
> > > new virtio API contract using a 'struct mdev_virtio'?
> >
> > I see, the bus:API contract is more clear when we're talking about
> > physical buses and physical devices following a hardware
> > specification.
>=20
> Well, I don't think it matters, this is a software contract inside the ke=
rnel
> between the 'struct foo_device' (as provided by the foo_bus) and the 'str=
uct
> foo_driver'
>=20
> This contract is certainly easier to define when a HW specification dicta=
tes
> basically how it works.
>=20
> > But if we take PCI for example, each PCI device has it's own internal
> > API that operates on the bus API.  PCI bus drivers match devices based
> > on vendor and device ID, which defines that internal API, not the bus
> > API.
>=20
> Yes, this matching is part of the API contract between the bus and device
> driver.
>=20
> But all of the pci_* functions that accept a 'struct pci_device *' are al=
so part of
> this API contract toward the driver.
>=20
> > The bus API is pretty thin when we're talking virtual devices and
> > virtual buses though.  The bus "API" is essentially that lifecycle
> > management, so I'm having a bit of a hard time differentiating this
>=20
> But Parav just pointed out to a virtio SW API that had something like
> 20 API entry points.
>=20
> > instead?"  Essentially for virtual devices, we're dictating a bus per
> > device type, whereas it seemed like a reasonable idea at the time to
>=20
> Well, what does a driver binding to a virtual device need to know?
>=20
> The virtual device API should provide all of that information.
>=20
> I think things like vfio and virtio APIs are very reasonable bus types. v=
irtio in
> particular has a published 'hw-like' specification with some good layers =
that
> can build a bus API.
>=20
> Not so sure about the very HW specific things like the Intel driver and t=
hese SFs.
> These will really only ever bind to one driver and seem to have no
> commonalities.
>=20
> For those we either create a bus per driver-specific proprietary API (fee=
ls kind
> of wrong) or we have a generic bus essentially for managed multi-function
> hardware that uses a simple 'void *hw_data' as the driver API and some
> matching logic to support that.
>=20
Its certainly important to use generic bus approach overall at kernel level=
 so that every vendor doesn't define that own devlink flavor, id scheme, ud=
ev naming method, PM and so on.
(It is not just bus definition).

Coming to hw_data part, even if this subdev (vendor) bus is created, it can=
 still exactly follow your foo_device example.

In fact my first published RFC [1] and its specific patch [2] was doing tha=
t.

probe() routine in series [1] didn't have PCI like struct subdev *, because=
 I wanted to use the core's generic probe(),
However it still correct because probe() can reach out to foo_device using =
container_of().
And hence the *hw_data is also resolved.

So struct looks like,

struct subdev {
	struct device device;
	/* resource range */
	/* num of irq vectors */
	const char *hw_addr;
	[..]
};

struct mlx5_subdev {
	struct subdev device;
	[..];
};

I request to reconsider RFC [1] for multi-function SFs use with extension o=
f device flavour as 'virtio', 'mlx5' etc in [3].

[1] https://lkml.org/lkml/2019/3/1/19
[2] https://lore.kernel.org/patchwork/patch/1046997/#1238851
[3] https://lkml.org/lkml/2019/3/1/25

> > create a common virtual device bus, but maybe it went into the weeds
> > when trying to figure out how device drivers match to devices on that
> > bus and actually interact with them.
>=20
> I think it is important to focus on the the SW API the 'struct foo_device=
' is
> supposed to provide toward the driver that binds to it.
>=20
> It should be a sensible API covering some well defined area..
>=20
> Jason
