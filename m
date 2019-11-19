Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7652101292
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKSEkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:40:04 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:55822
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbfKSEkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 23:40:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljhO1cYVnnHi4mBlHHuJryYOOsWTlx/LNQveQa2mzYFuOg+U23QTFAq9HrCfp6FsudB3Kpr+BJkVxOVDu3Ce+jVeSJ9eIOlok6GK+1U9G1oJh2CH8fSO9Qb2h+joatQxhhdaGeexJPtNg9405miZYoT4pHliV95S5ArzmwuhBDDwIQ6G+gmT6KxV6hPOWPv+XcjqxdYtVCWNcD36512jBIwdneF3SJZZSY0AZQfymqyUrzEmGX2UWBVd23tNm3yJPbAo/1QxD5hIIWTxB8SWFvr+hukw0bw7BFwfvPgMwgGXZWai+qaxlwj4+XTX1dJt1RV0X3Bl6QrKwPQHGNhKOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYpvAXqKU/5GR3HRAwte09bGZcBoNoyP/GFqTjeN6U8=;
 b=hK6mUOt5trQYkDECnoinbfp45JVYk9N1F4scyz6gBGJ/3JptAW3f422QT6t/MpZBGXUJH92RQYSoF6U3+BPgquTRZDTsvJtJCV+/XtokwrGiH1JH5aKNeQPSBkXnKSZO40wROSTmU9/9JRjhRmLue5dm65Is6WEsT83rCBAjltYgSF0jI7hgq/VzDU8bWLO7eX+hLSe7gQkktQ3Y5fgL285k65jt+zUk5iRZmzaOVMICx8W6RwtyK6oC7Qtv8EEuRlhrWHBTANAn8z4+/29HhNuET8kKMA8HnE3a7clUnSU9konxP4q2D8ZgWxPnZkKDlbXWI7O2e9gh7a+zzS4qlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYpvAXqKU/5GR3HRAwte09bGZcBoNoyP/GFqTjeN6U8=;
 b=Rf3T5C2PlQLz5GE4m/8pbrgtIDKiYbfOGK+DBIN7jenLhEKZ/YS8Jvq7hziIYouebW87wu29Pgj4/ShjsRopZhkAcHIAc1+v1FgMAg0jnqSOfsS9kIvFXo3WbxSU6nqAqxnGSWl2gKdfo413IGR1M9SH0PIsjIcoNjmNlzqBBN0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5716.eurprd05.prod.outlook.com (20.178.113.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Tue, 19 Nov 2019 04:39:58 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 04:39:58 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAUOWwCAAAVvMIAABUSw
Date:   Tue, 19 Nov 2019 04:39:57 +0000
Message-ID: <AM0PR05MB486682813F89233048FCB3D1D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B301493@ORSMSX101.amr.corp.intel.com>
 <AM0PR05MB4866169E38D7F157F0B4DC49D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866169E38D7F157F0B4DC49D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3896b9c2-a05d-4512-d228-08d76caa8831
x-ms-traffictypediagnostic: AM0PR05MB5716:|AM0PR05MB5716:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB57169ACDC2D7ACA44E74FCEAD14C0@AM0PR05MB5716.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(189003)(199004)(13464003)(2906002)(305945005)(11346002)(256004)(4326008)(7736002)(6246003)(81156014)(81166006)(102836004)(66066001)(6506007)(2940100002)(53546011)(2201001)(26005)(76116006)(186003)(8936002)(66946007)(446003)(9686003)(66446008)(316002)(76176011)(25786009)(99286004)(66556008)(14444005)(52536014)(66476007)(64756008)(14454004)(5024004)(2501003)(55016002)(229853002)(7416002)(86362001)(5660300002)(8676002)(71190400001)(71200400001)(54906003)(110136005)(3846002)(33656002)(7696005)(6436002)(478600001)(476003)(486006)(6116002)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5716;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zVRV8qfGWrb+mqdave+Q+TuoYSbrGZyaeTaHI7ieZMByMUFvGyAIZjzdTeR1Ha8Nv3yDhQtymn8Aa9k6wjr7WhqjjsXyzYDJs3ZgddgtsnUwpoMBIhvu9DjHnqnVjJ9MEHI7w/5g9/EkRTAG0LnTznkvYSXqRHm/k//srPiOqJUE6hRlP+RYeL7PhBrpWE0CC1cDyNxpuQagSaXHD/HbeqagstYtcaoinUb/PJQLOXL0KdQGK2tTBo9Ua6Owb/7hC+p4oLzRQ8V5ZbUpSXm3l9hF+QYgjF1xAB96KXfm7ZzxypZ3mFN89Pzj6JxI+IIK2nAkoPapdiCEKzFEo5A7slGzfFgbpAykdFHGn0cq7A21vUfsTRvHA59PZ6drH3zOlSWZnyCF01GQhJ84bd06czetELTaCG34UsoSKvdX5KQg7PiSJoHkt9QQ7gf92/D6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3896b9c2-a05d-4512-d228-08d76caa8831
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 04:39:58.0021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/G3EuM1a/jMD6cUFKHojtWplWL+YjOhBCRx0XJC+B/rqe+7DRkzZdplThiMChWId9d4eIzpMIFrW7H7WjiP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> Sent: Monday, November 18, 2019 10:32 PM
> To: Ertman, David M <david.m.ertman@intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> gregkh@linuxfoundation.org
> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
>=20
> Hi David,
>=20
> > From: Ertman, David M <david.m.ertman@intel.com>
> > Sent: Monday, November 18, 2019 9:59 PM
> > Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual
> > Bus
> >
> > > -----Original Message-----
> > > From: Parav Pandit <parav@mellanox.com>
> > > Sent: Friday, November 15, 2019 3:26 PM
> > > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> > > davem@davemloft.net; gregkh@linuxfoundation.org
> > > Cc: Ertman, David M <david.m.ertman@intel.com>;
> > > netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil, Kiran
> > > <kiran.patil@intel.com>
> > > Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of
> > > Virtual Bus
> > >
> > > Hi Jeff,
> > >
> > > > From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > > > Sent: Friday, November 15, 2019 4:34 PM
> > > >
> > > > From: Dave Ertman <david.m.ertman@intel.com>
> > > >
> > > > This is the initial implementation of the Virtual Bus,
> > > > virtbus_device and virtbus_driver.  The virtual bus is a software
> > > > based bus intended to support lightweight devices and drivers and
> > > > provide matching between them and probing of the registered drivers=
.
> > > >
> > > > The primary purpose of the virual bus is to provide matching
> > > > services and to pass the data pointer contained in the
> > > > virtbus_device to the virtbus_driver during its probe call.  This
> > > > will allow two separate kernel objects to match up and start
> > communication.
> > > >
> > > It is fundamental to know that rdma device created by virtbus_driver
> > > will be anchored to which bus for an non abusive use.
> > > virtbus or parent pci bus?
> > > I asked this question in v1 version of this patch.
> >
> > The model we will be using is a PCI LAN driver that will allocate and
> > register a virtbus_device.  The virtbus_device will be anchored to the
> > virtual bus, not the PCI bus.
> o.k.
>=20
> >
> > The virtbus does not have a requirement that elements registering with
> > it have any association with another outside bus or device.
> >
> This is what I want to capture in cover letter and documentation.
>=20
> > RDMA is not attached to any bus when it's init is called.  The
> > virtbus_driver that it will create will be attached to the virtual bus.
> >
> > The RDMA driver will register a virtbus_driver object.  Its probe will
> > accept the data pointer from the virtbus_device that the PCI LAN driver
> created.
> >
> What I am saying that RDMA device created by the irdma driver or mlx5_ib
> driver should be anchored to the PCI device and not the virtbus device.
>=20
> struct ib_device.dev.parent =3D &pci_dev->dev;
>=20
> if this is not done, and if it is,
>=20
> struct ib_device.dev.parent =3D &virtbus_dev->dev;
>=20
> Than we are inviting huge burden as below.
> (a) user compatibility with several tools, orchestration etc is broken, b=
ecause
> rdma cannot be reached back to its PCI device as before.
> This is some internal kernel change for 'better code handling', which is
> surfacing to rdma device name changing - systemd/udev broken, until all
> distros upgrade and implement this virtbus naming scheme.
> Even with that orchestration tools shipped outside of distro are broken.
>=20
> (b) virtbus must extend iommu support in intel, arm, amd, ppc systems
> otherwise straight away rdma is broken in those environments with this
> 'internal code restructure'.
> These iommu doesn't support non PCI buses.
>=20
> (c) anchoring on virtbus brings challenge to get unique id for persistent=
 naming
> when irdma/mlx5_ib device is not created by 'user'.
>=20
> This improvement by bus matching service !=3D 'ethX to ens2f0 improvement=
 of
> netdevs happened few years back'.
> Hence, my input is,
>=20
> irdma_virtubus_probe() {
> 	struct ib_device.dev.parent =3D &pci_dev->dev;
> 	ib_register_driver();
> }
>=20
With this, I forgot to mention that, virtbus doesn't need PM callbacks, bec=
ause PM core layer works on suspend/resume devices in reverse order of thei=
r creation.
Given that protocol devices (like rdma and netdev) devices shouldn't be anc=
hored on virtbus, it doesn't need PM callbacks.
Please remove them.

suspend() will be called first on rdma device (because it was created last)=
.
