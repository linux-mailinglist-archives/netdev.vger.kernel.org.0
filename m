Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D2A101276
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfKSEcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:32:05 -0500
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:36711
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727217AbfKSEcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 23:32:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imYYZNZ/C3MtJ/sz6rY6EGL/Arej7CxKcbBi+0s+m7m/xl1DMmQ3BWDjoD7rfBDBv8JlAQ3j82qHvgzkQlVwe8+zQeV8GHMj1nNsqJJKCcIXC/sdMeFNhpruN3cjHFXxqld/mM74be6ki0/bI2YemXtAuKjx3xblciOKfDhiyrfVaB6nbb37MWALy2Mj+8GQvm2qkFLePrqgU4rFdEZd8N6xazOxvQqysPIcz2yBxhpjmQ9Hc8vQTh02hx/nc43F9qjFnu4VaTB/A6kvtvsLnRCP6UTpDnVRii2Ep/gfMhPWNgUvAGcJ7rD5bZtmYnpVCEyDzEipXm5HXQ7+2VdBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6+gxzBvn7owbSD7oHtiI2SDDALt3gY1Qb0B6KupjQ4=;
 b=aMidblUjyBi0T6BlnKT23SA4ZttMP7JVBflGRue3DzCHMhkiwDzLhTrIwuD5ahV6/VDqUS7pMVn3B+r5ZwAlbsQVmiH+ISWjKO/HfO4DWhqNZDibs6csaq17oqDf3JXD91cdjF+p9AzREp5FiTjrNJrEOby3iyz9kEl16nhMygnHGw/zmkT9tK/mYvaJ1UbRJivp3yV0EbF9dhGdfo8jorl0hI9ENhLf464TqkDhDYS1tYBhL73f8Heepg5Jqy0oisH0cWDJd1vpUMQt55pPX4bdDn5miRmXN/5iXN/QWSc8483TpcVIcN7nkJe93JD+kNeoD4u1Wuqu6nfIbSqlnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6+gxzBvn7owbSD7oHtiI2SDDALt3gY1Qb0B6KupjQ4=;
 b=Pw8IBYs0Dua/21tWoMaAbOt8zl1kTqBfUvkq1TLJIcmvpRIa2rI9NbtxNRXZVrvToKv38zd9IXKEnoUpT+GM0yuLn6du9DKGQzs7HN4C/nV7sDYEPY9Xml2/Xj95fUk8oanPRIUIevIOzBfiJtjFr3CvERMQXVQbQ6kVq0NX8FY=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4354.eurprd05.prod.outlook.com (52.134.90.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Tue, 19 Nov 2019 04:31:56 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 04:31:56 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     "Ertman, David M" <david.m.ertman@intel.com>,
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
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAUOWwCAAAVvMA==
Date:   Tue, 19 Nov 2019 04:31:56 +0000
Message-ID: <AM0PR05MB4866169E38D7F157F0B4DC49D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B301493@ORSMSX101.amr.corp.intel.com>
In-Reply-To: <2B0E3F215D1AB84DA946C8BEE234CCC97B301493@ORSMSX101.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 07e2358e-3807-4491-b312-08d76ca96936
x-ms-traffictypediagnostic: AM0PR05MB4354:
x-microsoft-antispam-prvs: <AM0PR05MB4354C7EF11722945284100D8D14C0@AM0PR05MB4354.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(13464003)(189003)(199004)(486006)(55016002)(33656002)(76176011)(9686003)(52536014)(54906003)(25786009)(4326008)(7696005)(2201001)(229853002)(476003)(66446008)(64756008)(66556008)(66476007)(53546011)(6506007)(2501003)(110136005)(2906002)(6116002)(74316002)(316002)(6246003)(7416002)(66066001)(3846002)(8936002)(6436002)(71190400001)(71200400001)(76116006)(11346002)(99286004)(5024004)(256004)(446003)(14444005)(186003)(14454004)(305945005)(86362001)(7736002)(478600001)(5660300002)(8676002)(81156014)(102836004)(66946007)(26005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4354;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6PE7KL6TihrxgBv0pbSteVYNCAvvpN7va3MmxFFq6ps3Mu8SnBRDoz7BwJTC6rZhABUp8M02jtHRIfnEDCIkCpj2xFhx+gzPYCoGY7/0V1Jz2MAONiKznhH1fMVFsqFv9wmpuHij4PmzLTWVE3i8I6F+IZk1bffuU6nAtoAx424JpFm3QP3tZMJCf8a19ZpPg4dStzfLtdK26x+p8JDytFsHQgiuYOHpD3O4JUNrSlTbV8iUhd+rVsh0f2UunnA/YIvWR5iJiqS9rS/bpKymYP/qvOsMzDJRTRvTSiR8EpVCsYC433Ag0LOrAuIaFw4NJSrW+Xdq4/uF+7CMAEXhNML5yLF/PxbUFSuBXIeA7vdGpclHS9Kp6e1vEIPL8kviwd36B7XTrQyOH2n/r6+yfS7a9iLTzD1Ibred1p5lqMgdkxucK+FIJU2sItrmn9N0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e2358e-3807-4491-b312-08d76ca96936
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 04:31:56.5670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5FU+eDrIaUsbkRyzqbN6qxQJM7jFauVhoHkYACOwtANzpwlEq8t/1W3AmPM2TbEnaM9es5BtmHIfx0cRE3r3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> From: Ertman, David M <david.m.ertman@intel.com>
> Sent: Monday, November 18, 2019 9:59 PM
> Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
>=20
> > -----Original Message-----
> > From: Parav Pandit <parav@mellanox.com>
> > Sent: Friday, November 15, 2019 3:26 PM
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> > davem@davemloft.net; gregkh@linuxfoundation.org
> > Cc: Ertman, David M <david.m.ertman@intel.com>;
> > netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil, Kiran
> > <kiran.patil@intel.com>
> > Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual
> > Bus
> >
> > Hi Jeff,
> >
> > > From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > > Sent: Friday, November 15, 2019 4:34 PM
> > >
> > > From: Dave Ertman <david.m.ertman@intel.com>
> > >
> > > This is the initial implementation of the Virtual Bus,
> > > virtbus_device and virtbus_driver.  The virtual bus is a software
> > > based bus intended to support lightweight devices and drivers and
> > > provide matching between them and probing of the registered drivers.
> > >
> > > The primary purpose of the virual bus is to provide matching
> > > services and to pass the data pointer contained in the
> > > virtbus_device to the virtbus_driver during its probe call.  This
> > > will allow two separate kernel objects to match up and start
> communication.
> > >
> > It is fundamental to know that rdma device created by virtbus_driver
> > will be anchored to which bus for an non abusive use.
> > virtbus or parent pci bus?
> > I asked this question in v1 version of this patch.
>=20
> The model we will be using is a PCI LAN driver that will allocate and reg=
ister a
> virtbus_device.  The virtbus_device will be anchored to the virtual bus, =
not the
> PCI bus.
o.k.

>=20
> The virtbus does not have a requirement that elements registering with it=
 have
> any association with another outside bus or device.
>=20
This is what I want to capture in cover letter and documentation.

> RDMA is not attached to any bus when it's init is called.  The virtbus_dr=
iver that
> it will create will be attached to the virtual bus.
>=20
> The RDMA driver will register a virtbus_driver object.  Its probe will ac=
cept the
> data pointer from the virtbus_device that the PCI LAN driver created.
>=20
What I am saying that RDMA device created by the irdma driver or mlx5_ib dr=
iver should be anchored to the PCI device and not the virtbus device.

struct ib_device.dev.parent =3D &pci_dev->dev;

if this is not done, and if it is,

struct ib_device.dev.parent =3D &virtbus_dev->dev;

Than we are inviting huge burden as below.
(a) user compatibility with several tools, orchestration etc is broken, bec=
ause rdma cannot be reached back to its PCI device as before.
This is some internal kernel change for 'better code handling', which is su=
rfacing to rdma device name changing - systemd/udev broken, until all distr=
os upgrade and implement this virtbus naming scheme.
Even with that orchestration tools shipped outside of distro are broken.

(b) virtbus must extend iommu support in intel, arm, amd, ppc systems other=
wise straight away rdma is broken in those environments with this 'internal=
 code restructure'.
These iommu doesn't support non PCI buses.

(c) anchoring on virtbus brings challenge to get unique id for persistent n=
aming when irdma/mlx5_ib device is not created by 'user'.

This improvement by bus matching service !=3D 'ethX to ens2f0 improvement o=
f netdevs happened few years back'.
Hence, my input is,

irdma_virtubus_probe() {
	struct ib_device.dev.parent =3D &pci_dev->dev;
	ib_register_driver();
}

> >
> > Also since it says - 'to support lightweight devices', documenting
> > that information is critical to avoid ambiguity.
> >
> > Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1]
> > whatever we want to call it, it overlaps with your comment about 'to
> > support lightweight devices'.
> > Hence let's make things crystal clear weather the purpose is 'only
> > matching service' or also 'lightweight devices'.
> > If this is only matching service, lets please remove lightweight device=
s part..
> >
>=20
> This is only for matching services for kernel objects, I will work on phr=
asing this
> clearer.
>=20

Ok. Great. Due to above two fundamental points, we clearly write up the mat=
ching service.
Not sure naming virtbus to 'virbus_service' in bus_type is an extreme way t=
o make this clear.

> > You additionally need modpost support for id table integration to
> > modifo, modprobe and other tools.
> > A small patch similar to this one [2] is needed.
> > Please include in the series.
> >
>=20
> modpost support added - thanks for that catch!
>=20
> > [..]
> >
> > > +static const
> > > +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id =
*id,
> > > +					struct virtbus_device *vdev)
> > > +{
> > > +	while (id->name[0]) {
> > > +		if (!strcmp(vdev->name, id->name)) {
> > > +			vdev->dev_id =3D id;
> > Matching function shouldn't be modifying the id.
>=20
> This is not the main id of the virtbus_device.  This is copying the eleme=
nt in the
> driver id_table that was matched into the virtbus_device struct, so that =
when
> the virtbus_device struct is passed to the virtbus_driver's probe, it can=
 access
> the correct driver_data.
>=20
> I chose a poor name for this field, I will change the name of this part o=
f the
> struct to matched_element and include a comment on what is going on here.
>=20
When virtbus_device is created, its class_id or device_id identifying the d=
evice is decided.
So it should be set in the create() routine.
