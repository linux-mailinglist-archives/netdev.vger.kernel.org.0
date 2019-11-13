Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F3AF9FCA
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKMBDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:03:48 -0500
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:8676
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726977AbfKMBDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:03:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l38CnyihxYTyGkGvu2piJwReAiGuX6wyKmCvK//zDhrXrAb8V9eWEo+kEPjZfo0vClpgnwiMXhgv96eYL+ajHNAxSTLIViXmZg28FsSeoslttVt11ogLjOMu3a+l9Qv7rAjwokMnTKQen/Ezvnc7A++P1i71IYAyGkHfNtX3Wqw22HCH9r9duvrYVypeAYs/3uJ8rPIwZRerFYU7VJurc148uygTGokxjbU20beh7cXujB0vfJYYP5ztcljMiZ9RD5FH+YzeTLjpCoHN4lLNUg3AWqMz3Z/3TlUOGeYj+jPk/mb4CPMkSZVou3u8Wd8bDaywlgELkYZfS2VSdy7kew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg+0/hjnDbN5wZsg8yarxNzEhJp1M9PMSR67apqe3og=;
 b=F5+3pjwO/MkL4PU/AIUlalrZzN2bA4WabJoHQJ9Bb6tsisia6++SVklLMMxwVa1zxGlU9Q99X1K7/z9u1CH8LRx7h4ST8D2m9fVcfKHCg+KFkYtJZ6noJ+99uFeVHbzouwzgy1UYSQ4mpEJGvX9FOcedW5MvL6myx88HQ/4QloQs+481Wnw+b6jThZzA7yRkmYg7xqChd4u92PeaGT4DvCn8+OaKeaOY041JwM+tSOAoct0Bm9aJtiLAiu/MzvMbeiH2WBvgWorSPy0I8tlJyN9UNiCn6xfaH/OWP+MWmyl99ZpFH+pxupW9mG7dH8+XUMRFkSsATV6LKiI8SoseZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg+0/hjnDbN5wZsg8yarxNzEhJp1M9PMSR67apqe3og=;
 b=NrQdwrkWI0p64mk5BSHgXa0XLuOlUx8isUVutxBSxSww/kZx4esbItgcjEd7D52AVk1mGFKA32oMz2cco1YNpvvL7eO5TuNbba4YPP2fJA9swinY8wezx6FaFFWi0aooZhCTkfZF1yQjPcPlSk2ZSjUqOgVWxw2E6XEr8U1TU9E=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5665.eurprd05.prod.outlook.com (20.178.112.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 01:03:44 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 01:03:44 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>
Subject: RE: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVmMVkwGO915shK0y7Ue5RV91ix6eIDrEAgAAsrICAAA5rUA==
Date:   Wed, 13 Nov 2019 01:03:44 +0000
Message-ID: <AM0PR05MB48662DEDDE4750D399B8181ED1760@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
 <20191112212826.GA1837470@kroah.com> <20191113000819.GB19615@ziepe.ca>
In-Reply-To: <20191113000819.GB19615@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2600:387:a:15::81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cff8bdfe-cb49-416d-839e-08d767d554bf
x-ms-traffictypediagnostic: AM0PR05MB5665:
x-microsoft-antispam-prvs: <AM0PR05MB566518E5A573C846650A28A3D1760@AM0PR05MB5665.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(189003)(199004)(486006)(476003)(66476007)(14444005)(11346002)(446003)(256004)(64756008)(66556008)(8936002)(6506007)(102836004)(81166006)(186003)(46003)(7696005)(76176011)(8676002)(33656002)(81156014)(66946007)(66446008)(5660300002)(52536014)(76116006)(71190400001)(71200400001)(2906002)(6116002)(229853002)(6436002)(86362001)(55016002)(110136005)(316002)(99286004)(54906003)(14454004)(7416002)(9686003)(478600001)(25786009)(305945005)(7736002)(6246003)(74316002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5665;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uq1nsNRUS3Wt1UEZ6nfPCxtngWpYJ0A0BJqTxCFj/KQg7P1fFwvJThL0PsWJV/GQutGumIKIAxRI36DNpwDiirztUGJ2W6YH9A2sFkY9muxmUbO1AnS6iLRwyP2Ws5I6uFKxa/J4j08BhtubRXx/gF5tYVea7QNU/M4j7nLm2l+p/VIG8erc1duFMPXOuKDH3v7EEDZFqGhlW8a2d/PxZ1gOPdmf/aHgRPLSJlckHSP3LKdDkRgsybsQDhNL0qoddSEPSdArldGl9Aapv2slrH613x6qMl1LRjVClHJLvB4zXSZfTSzjOi+EXlnxq/SNdCtqOQUvsPC17p8xfLMBLNgE33QMB5CxfLHYLLRzq92lcRp2kHgUk0X6Kls583ZcKsSOTvbcXR/gASHtZYDfFrgUgzJYiQlpoRQPYjPMTB695SevF8/M8uk11vKnEDWM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff8bdfe-cb49-416d-839e-08d767d554bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 01:03:44.2697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2bX/cuiuK9q33AN+1XAQ6hjgu7k5qg7SDcIL7sdb24Qlxggm9563vwd6bEXpiJFyp0sIc+eWyOJJT7PmnUwlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5665
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, November 12, 2019 6:08 PM
>=20
> On Tue, Nov 12, 2019 at 10:28:26PM +0100, Greg KH wrote:
>=20
> > > + */
> > > +struct virtbus_device {
> > > +	const char			*name;
> > > +	int				id;
> > > +	const struct virtbus_dev_id	*dev_id;
> > > +	struct device			dev;
> > > +	void				*data;
> > > +};
> > > +
> > > +struct virtbus_driver {
> > > +	int (*probe)(struct virtbus_device *);
> > > +	int (*remove)(struct virtbus_device *);
> > > +	void (*shutdown)(struct virtbus_device *);
> > > +	int (*suspend)(struct virtbus_device *, pm_message_t state);
> > > +	int (*resume)(struct virtbus_device *);
> > > +	struct device_driver driver;
> > > +	const struct virtbus_dev_id *id_table; };
> > > +
> > > +#define virtbus_get_dev_id(vdev)	((vdev)->id_entry)
> > > +#define virtbus_get_devdata(dev)	((dev)->devdata)
> >
> > What are these for?
>=20
> As far as I can see, the scheme here, using the language from the most
> recent discussion is:
>=20
>    // in core or netdev module
>    int mlx5_core_create()
>    {
>       struct mlx5_core_dev *core =3D kzalloc(..)
>=20
>       [..]
>=20
>       core->vdev =3D virtbus_dev_alloc("mlx5_core", core);
>    }
>=20
>=20
>    // in rdma module
>    static int mlx5_rdma_probe(struct virtbus_device *dev)
>    {
>         // Get the value passed to virtbus_dev_alloc()
> 	struct mlx5_core_dev *core =3D virtbus_get_devdata(dev)
>=20
> 	// Use the huge API surrounding struct mlx5_core_dev
> 	qp =3D mlx5_core_create_qp(core, ...);
>    }
>=20
>    static struct virtbus_driver mlx5_rdma_driver =3D {
>       .probe =3D mlx5_rdma_probe,
>       .match =3D {"mlx5_core"}
>    }
>=20
> Drivers that match "mlx5_core" know that the opaque
> 'virtbus_get_devdata()' is a 'struct mlx5_core_dev *' and use that access=
 the
> core driver.
>=20
> A "ice_core" would know it is some 'struct ice_core_dev *' for Intel and =
uses
> that pointer, etc.
>=20
> ie it is just a way to a pass a 'void *' from one module to another while=
 using
> the driver core to manage module autoloading and binding.

A small improvement below, because get_drvdata() and set_drvdata() is suppo=
sed to be called by the bus driver, not its creator.
And below data structure achieve strong type checks, no void* casts, and ex=
actly achieves the foo_device example.
Isn't it better?

mlx5_virtbus_device {
	struct virtbus_device dev;
	struct mlx5_core_dev *dev;
};

mlx5_core_create(const struct mlx5_core_dev *coredev)
{
	struct mlx5_virtbus_device *dev;

	dev =3D virtdev_alloc(sizeof(*dev));
	dev->core =3D coredev;	/* this should not be stored in drvdata */
	virtdev_register(dev);
}

mlx5_rdma_probe(struct virtbus_device *dev)
{
	struct mlx5_core_dev *coredev;
	struct mlx5_virtdev *virtdev;
	struct mlx5_ib_dev *ibdev;

	virtdev =3D container_of(virtdev, struct mlx5_virtdev, dev);
	coredev =3D virtdev->coredev;
	ibdev =3D ib_alloc_dev();
	if (!bdev)
		return -ENOMEM;
	virtdev_set_drvdata(dev, ibdev);
	/* setup.. */
	return 0;=09
}

mlx5_rdma_remove(struct virtbus_device *dev)
{
	struct mlx5_ib_dev *ibdev;

	ibdev =3D virtdev_get_drvdata(dev);
	/* previous load failed */
	if(!ibdev)
		return;
	[..]
	/* mirror of probe */
}
