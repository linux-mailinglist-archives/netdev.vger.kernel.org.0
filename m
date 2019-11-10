Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E4F6B29
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKJTsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:48:37 -0500
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:8377
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbfKJTsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 14:48:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl7bzarWbxTI8ZKFU9NfdsVDFUTEUTDHk34DsiWI/WRbszhN8Mksnl7H4AusSMIyHwfX82x1SSOB2yTuGyH5Cf/4PHiT+KlK6Eo7bo/tdOYG161Akjyr7q4T9PNTPGX0EQN0HklZhoKd6TxiuIjhtjS88U3FoWritIWtmoGw6dWgOws9j/sAqU1RftVGopDNRuDO+vzAL4jkhTTtoXXIq4gkhnGb1fzFsFofF+cONcACfk6/bPkNOvvQ38npXD0N9FCYruT20myPb3b6Mon9VJ8sUrnceMvYqOj6lNoK83O7nxtlqd1jLsF6kFJczf07oWsMODoNUan07nzZZyJAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+T/jzAyymCsrGD907TUMLizJrpqxm9bz9GMYFaXki8g=;
 b=XbJytrLOgd9dyo9vk+x48iivIY4UpPyUYSY/17fQXVzxoB4VZgw+oGgMti4smdXrzT4VaIUZsY8MBUQv/wh24TALXcT8oSaD10Y1C8IOk3r4kgT2gUqpD+WSk8GPrb7Q3nYcn693rAOe9bEoVzG5S75H+xbL6a/2RaUa6aUlnSIilCwTt1wiaEm6ijLxQ8WAgi/TuI3fbFfeBvs58npglbRbJaU3B2XUVWqVwQN9aSc4hd1ANZIWnVLpBSn6GKi9rgBNWYcTrN/AFBfPIOkvyV/SeDvgyZwdE6EuIYzJKHsEbdrS9ZCL2xM8l1hJDX+zkdZ1h6vwEQWvJtCbgLLpaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+T/jzAyymCsrGD907TUMLizJrpqxm9bz9GMYFaXki8g=;
 b=ctW2ADr5/6zfMwc04AhlAPuTEpbwh83K+Iu7WiQshO/mxYbBYqcUugtH3M6rTFDJoWKOdAabaLY9WsvTdF94OGMdkge799CYJpAENKZkWs1fJdijz7wfNlOUzitpXtLksgh5RPS/HbJyNBGAshDIDEwHOmw+lU1Tpyr2Qkz5BK4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6676.eurprd05.prod.outlook.com (10.186.174.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Sun, 10 Nov 2019 19:48:32 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.023; Sun, 10 Nov 2019
 19:48:31 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAABhCAgAAItYCAAAz4AIAABs2QgAAs4QCAAsNGMA==
Date:   Sun, 10 Nov 2019 19:48:31 +0000
Message-ID: <AM0PR05MB48660E49342EC2CD6AB825F8D1750@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho> <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba> <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home> <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191109005708.GC31761@ziepe.ca>
In-Reply-To: <20191109005708.GC31761@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 953c336c-8c0a-4fc3-9ad9-08d76616f738
x-ms-traffictypediagnostic: AM0PR05MB6676:|AM0PR05MB6676:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB66767A1D1E0951B4CCA217B8D1750@AM0PR05MB6676.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02176E2458
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(189003)(199004)(5660300002)(54906003)(8936002)(305945005)(256004)(2906002)(86362001)(7736002)(81156014)(81166006)(76116006)(66066001)(8676002)(7416002)(4326008)(52536014)(6246003)(55016002)(71200400001)(71190400001)(6916009)(99286004)(9686003)(33656002)(478600001)(6116002)(3846002)(476003)(229853002)(11346002)(446003)(26005)(74316002)(486006)(186003)(102836004)(6436002)(76176011)(6506007)(25786009)(14454004)(316002)(66946007)(66476007)(7696005)(66446008)(64756008)(66556008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6676;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ktojAUy3QBU4dIllHOrmLkB0aQU/DjQkyshM7unAUxO2rbZPrz4cRjgrkyNLqxezlM/CfWZme8WWs3bZx0dSjMC6CVcVHpOssewQJrzSlyrxX49KnbwV7fwwZauhQVHRs6i+9WCjf5XzLWGdpcLEJT+4jpSohJERVaqfkVnKMbyZlJ3wSwqXWYM1PebL/Y8ry0pTbda3ATiiFkAwFt7rtS8YBJizEKDwxJO2dnja08+yhkVIS57Ct6OMX0QpPK1AP7SI+flXFu5vsQi8kKfAtbO3hA7W3BG16hsoWgXM7ZvZv5ttrEUC940DIVIwXPyThhEMKD5mQXTM/7BCsTsdZc0a8KpqnttZIMg5wqqIbuZU1NFSL2NUpuIQskM8R/LlQAHSPoT649pd9CxCnv5LAmFJ9ydB7EUCyoQlxGyn172NLk2df4IK4DTzR+8d87K0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953c336c-8c0a-4fc3-9ad9-08d76616f738
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2019 19:48:31.7890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q0bMP9kKjLWBFoQYQ7cPmQbii5GI1T1RhiqEINkmsTrhkJrIZ8Kyw4ywYZOw4bn4Y2k61yw30Fs/PbOv5bLlZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6676
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, November 8, 2019 6:57 PM
> > We should be creating 3 different buses, instead of mdev bus being de-
> multiplexer of that?
> >
> > Hence, depending the device flavour specified, create such device on ri=
ght
> bus?
> >
> > For example,
> > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo
> > subdev_id 1 $ devlink create subdev pci/0000:05:00.0 flavour mdev
> > <uuid> subdev_id 2 $ devlink create subdev pci/0000:05:00.0 flavour
> > mlx5 id 1 subdev_id 3
>=20
> I like the idea of specifying what kind of interface you want at sub devi=
ce
> creation time. It fits the driver model pretty well and doesn't require a=
busing
> the vfio mdev for binding to a netdev driver.
>=20
> > $ devlink subdev pci/0000:05:00.0/<subdev_id> config <params> $ echo
> > <respective_device_id> <sysfs_path>/bind
>=20
> Is explicit binding really needed?
No.

> If you specify a vfio flavour why shouldn't
> the vfio driver autoload and bind to it right away? That is kind of the p=
oint
> of the driver model...
>=20
It some configuration is needed that cannot be passed at device creation ti=
me, explicit bind later can be used.

> (kind of related, but I don't get while all that GUID and lifecycle stuff=
 in mdev
> should apply for something like a SF)
>=20
GUID is just the name of the device.
But lets park this aside for a moment.

> > Implement power management callbacks also on all above 3 buses?
> > Abstract out mlx5_bus into more generic virtual bus (vdev bus?) so
> > that multiple vendors can reuse?
>=20
> In this specific case, why does the SF in mlx5 mode even need a bus?
> Is it only because of devlink? That would be unfortunate
>
Devlink is one part due to identifying using bus/dev.
How do we refer to its devlink instance of SF without bus/device?
Can we extend devlink_register() to accept optionally have sf_id?

If we don't have a bus, creating sub function (a device), without a 'struct=
 device' which will have BAR, resources, etc is odd.

Now if we cannot see 'struct device' in sysfs, how do we persistently name =
them?
Are we ok to add /sys/class/net/sf_netdev/subdev_id
And
/sys/class/infiniband/<rdma_dev>/subdev_id

So that systemd/udev can rename them as en<X?><subdev_id> and roce<X><subde=
v_id>
If so, what will be X without a bus type?

This route without a bus is certainly helpful to overcome the IOMMU limitat=
ion where IOMMU only listens to pci bus type for DMAR setup,=20
dmar_register_bus_notifier(), and in=20
intel_iommu_init()-> bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
and other IOMMU doing similar PCI/AMBA binding.
This is currently overcome using WA dma_ops.
