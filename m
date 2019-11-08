Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA669F5873
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfKHUUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:20:52 -0500
Received: from mail-eopbgr150088.outbound.protection.outlook.com ([40.107.15.88]:20775
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727699AbfKHUUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:20:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1i6vY7CzoF/YMx1RuEFHI9NkN86Sa5GEmhSj0+JVdeoXRa2Ek39QQWE14z4M7w5rFVvtGF+Q+Gow7EZ0xEwvkQt5bIAOuG86UBJulVrw9MEEewHlkctCBEt75lZuSBgb9RjGlPWCThp/qcgUcNbHTBLWN1WXHSJ7ghOgoIA1k26FOXpLKwfCAkaDvWZVcNPaS2M8CF8MrUFNUL7ESPV4URS2eKOD2IpvhT+KF4Att+2h7kmx3BuvDOQSsZjzwn2TyTHUKJBD915MKZ2+j8wIZxOEe3UF7i+9dWwguE6DpOW8UNZ3yHemruwNJo8OzDKLEyDxUUXppeFnZigZZ1AMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rg+yx7gxpSP07kUM1lTXNurjYSHyuQU9Izz5oGQ8lVY=;
 b=nVNs0YayLHMXQEi0mVhf5yreHfjqOd2YINs4+ucCjkxWmtBkJY0S2qfth80D2DvtpUa4EzWKSvKnswFFkQWrsPAYfnGwy8MLsGWAnXK1uH7vdCePPTtYX8vuoyuioJfRRRzfdIIKzlRRpRBnC0k7FKT4yquisxolxpotZnXUOZP+kU4QC/4X54h8+Als0N+Fgg2VjfhxwZfjaVUx6WJ4VOFFZvhuZOKusagL38RQbEWHOR31knCPL1dxs7Q7glWadYyt12n3BT+DexcgiMk+8B23BOpHZYWlQDsln0vOami7ONFZwCizKZwAA+14nU4SnkI4ovLJRmOmRTQi/tJ3vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rg+yx7gxpSP07kUM1lTXNurjYSHyuQU9Izz5oGQ8lVY=;
 b=GSFYWhmfUQLFcmtvY3S5sSDMcqYYyKx7PZ4lST7rkdoFOmyBTGMMlf2QXkb3s/V4IkoThKbRCWKlIsaB6uRFqoKJ+bMTC1KgjLGY7FTQfrlQUoFEx/eGFCn01uj/5W3PvioRZ8yFiqV1LLR+1yUIw5+0xJRH3hGdVJBNjX+SBn4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6433.eurprd05.prod.outlook.com (20.179.35.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 20:20:44 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 20:20:44 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@resnulli.us>, David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAAAUQQ
Date:   Fri, 8 Nov 2019 20:20:43 +0000
Message-ID: <AM0PR05MB4866299C3AE2448C8226DC00D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho> <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba> <20191108201253.GE10956@ziepe.ca>
In-Reply-To: <20191108201253.GE10956@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10fdbdb5-4029-4fdc-53ce-08d764892277
x-ms-traffictypediagnostic: AM0PR05MB6433:|AM0PR05MB6433:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6433D8D9097065B6A5F7A0B7D17B0@AM0PR05MB6433.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(199004)(13464003)(189003)(51444003)(102836004)(316002)(4326008)(86362001)(6246003)(76176011)(99286004)(7416002)(81166006)(6306002)(8676002)(55016002)(9686003)(66946007)(66556008)(81156014)(7696005)(54906003)(110136005)(229853002)(76116006)(66446008)(64756008)(6436002)(5660300002)(486006)(2906002)(71200400001)(305945005)(7736002)(6116002)(3846002)(66476007)(74316002)(66066001)(478600001)(186003)(14454004)(5024004)(26005)(33656002)(11346002)(476003)(8936002)(256004)(71190400001)(25786009)(966005)(6506007)(446003)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6433;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ErQCSM2qiQiENaxdocThcb8dyD9AO09JLpAuznHFFDku6H0kb18jdpYVz/uUNyXFLocLxgsMzYRhBvvWgsjQhKaSkBxmVleJJq5ZwgGsWLFRe6+0p3G3+6/LvYZQowXtzRAHnuoklrUjQh00foPPong2+qYAAV4wMNwHUN5myhiEREnjRDvpO7MhuP32U4f9h8kHtf0NujHZlmau+LcmLEznLrDi3aHDokmH3pJgLG/x4/bCnf0GrnfsZsHB3B++sVHQHsiuVgpwxROUQEFXOrOU0JzHqOnD6eXxfs6u+cYd/RDRM3E4cP49Sgj/YmCfwsNs8GBpCbxOemY/EscSs/fVw/p1SUqLFvZGUwsyg1xU8UTXMlMPKI5V+zTlQ/YOfZgWmmshBjIonohpF/mK5wCT0PaTm0isty9hsI6B4rybM4PjtOJ6ft0IkE/BdS4cUW7JzjrDOC6jJq+5SC4Wt4QJIlOn7tCQ5D/DDri/pjE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10fdbdb5-4029-4fdc-53ce-08d764892277
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 20:20:44.4948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tH4acM2HX9+OtVgb0ZEsZrd1PrP+VjP9R2l8n/PHQ9Euy4h+qnPrAH+FUG4pzKoqDR04ebpqUZNhjkjR8JD5og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6433
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
> > > > The new intel driver has been having a very similar discussion
> > > > about how to model their 'multi function device' ie to bind RDMA
> > > > and other drivers to a shared PCI function, and I think that discus=
sion
> settled on adding a new bus?
> > > >
> > > > Really these things are all very similar, it would be nice to have
> > > > a clear methodology on how to use the device core if a single PCI
> > > > device is split by software into multiple different functional
> > > > units and attached to different driver instances.
> > > >
> > > > Currently there is alot of hacking in this area.. And a consistent
> > > > scheme might resolve the ugliness with the dma_ops wrappers.
> > > >
> > > > We already have the 'mfd' stuff to support splitting platform
> > > > devices, maybe we need to create a 'pci-mfd' to support splitting P=
CI
> devices?
> > > >
> > > > I'm not really clear how mfd and mdev relate, I always thought
> > > > mdev was strongly linked to vfio.
> > > >
> > >
> > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > above it is addressing more use case.
> > >
> > > I observed that discussion, but was not sure of extending mdev furthe=
r.
> > >
> > > One way to do for Intel drivers to do is after series [9].
> > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO RDMA driver
> > > mdev_register_driver(), matches on it and does the probe().
> >
> > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > muddying the purpose of mdevs is not a clear trade off.
>=20
> IMHO, mdev has amdev_parent_ops structure clearly intended to link it to =
vfio,
> so using a mdev for something not related to vfio seems like a poor choic=
e.
>=20
Splitting mdev_parent_ops{} is already in works for larger use case in seri=
es [1] for virtio.

[1] https://patchwork.kernel.org/patch/11233127/
