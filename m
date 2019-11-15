Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3438FE89F
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfKOX1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:27:33 -0500
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:8023
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbfKOX1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 18:27:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQ4Z3oUt7RQQ557D0Z8cIMOMJhzi4Q2S9YIz3ZT5AAfSm286vnq4Peh8lv+MIHQ9Xnmi6F4p0Jt6H3m6dPsyMEdqcFEQUpTAgPA1DI57aSsxzJs0w0gS6erhk6D+OElR+XXvqD3/azxdCkH5X4oVg5WSOfR3+jpHucj94KPjUVJHnIt09pZiMEgI8foiiJAeRT7JVcH+z1g505JT621ritZI2Aks4AD6hUiTZjmflWL1jLHS+Lke4vjNLehfcmlxnSfFFlgRstBd6fqd2q1bUCfkL/ji5KeZQzA2/xJfO2y9Lgo5GJJjdJtTJRFP4vWhB5dgzSADguadojJ8LR6K7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03njZm9rcGNI9puGGDMyJKjIVI+jgrwJEsrbLjRGJpM=;
 b=cH2OnaOjShpixFVCulz3Ud3ztyVN5gp+8Lh0rNrX4DUwC1lkpZOAzrpPuw0Gtu1n0Zv/51F+RYylKnLNHjtnyWi9lL8U+68gxnVhnGhw35gHHCo78WJuYVNOVcYmgtQk6M1AsGPX2uDuoAQ6E1xHY6a4gN84/MKzo3kQZzCjTgqv45UDXhmyQfux5QjqMukdikJj21DIMHoBBLY/znx3Uh6V691tcJUIRkqo/XIizAzCMW9dIcDs4MqhfBJD5Y4vF7iyHwmvAoLOCGGLx5S84hqfn7qWXJUZUb2wnKVjnm+Pnk9jW1eXhy2XzPjynO+ll7sbocmpdbYFQ43eZPz1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03njZm9rcGNI9puGGDMyJKjIVI+jgrwJEsrbLjRGJpM=;
 b=l+hbWgAItQ90f02codQwAGqwC/rfyABeL95DYjk4ejUU2YlqDoJznix5qAHyTG2y3WXnRr7onnmN7BxpIbnIML1WOAA3cy/1fg8T8atkthsuJDlnyvTRT8J0FU9iDGxTjs3Egq5WXine4vt1VRlupdGPuf4h1GHxUCo4Nk+OEM4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6146.eurprd05.prod.outlook.com (20.178.115.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Fri, 15 Nov 2019 23:25:47 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 23:25:47 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrA
Date:   Fri, 15 Nov 2019 23:25:47 +0000
Message-ID: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7280ef6-1a10-4efe-6f43-08d76a232528
x-ms-traffictypediagnostic: AM0PR05MB6146:
x-microsoft-antispam-prvs: <AM0PR05MB6146CC0492D429100806AB0AD1700@AM0PR05MB6146.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(189003)(199004)(66946007)(7416002)(4326008)(8936002)(81156014)(8676002)(229853002)(55016002)(6116002)(3846002)(2906002)(6306002)(6436002)(9686003)(11346002)(52536014)(478600001)(66476007)(66446008)(64756008)(66556008)(316002)(305945005)(81166006)(76116006)(74316002)(54906003)(110136005)(33656002)(6246003)(99286004)(71200400001)(7736002)(5660300002)(446003)(14444005)(256004)(25786009)(966005)(6506007)(71190400001)(26005)(76176011)(86362001)(186003)(102836004)(2201001)(476003)(2501003)(7696005)(486006)(66066001)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6146;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHY4wgohmg2J/JK7CiPewMfksdlpubL9wY5J28v2l4bk1/xS79zE+of/om3AJXnFhjhiykgz44wQ8xv9SikD/5+gCgT6zdyDq4FBA2kpjxe6iBOqlQCRMwNEYoqfTAZ1ZyKh5imNimF6WejjpuNPsxt4rsxcYsZ8a3jma5EuTgJ9K9wVhLmZcapuEr3kUziWKKx9ev1a8065wrjGWJLDlZiyiH63lFpH754kbW4AtAZVneHu4DSN6UXTPvDUxEE56GtKBqAEyDwAsNrmDRyWvqz36q7jnZ3FAsw1uc3s3fAwljeN9pYKwRXOyl/UUTQH+7CefAZX+yxf87mu48i9Wpn4rTZ47bq4AErhvZN19EN+7S5Y9tBd8d1kyOwhs/EK0IwoPKyClfha0/hCoqlIBZZwLrmyFtifjRpPgDdiQPInv8qR9uP7Q/t2iLcVqjmb
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7280ef6-1a10-4efe-6f43-08d76a232528
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 23:25:47.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ftPYAISO+pNcep5vlp9/82ZGjFWVbbamaaTFSPs4qMyBWW3qACGyBtWBVGZNFu6WrSNCaxEjKg2UGBzg/C3L3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeff,

> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Sent: Friday, November 15, 2019 4:34 PM
>=20
> From: Dave Ertman <david.m.ertman@intel.com>
>=20
> This is the initial implementation of the Virtual Bus, virtbus_device and
> virtbus_driver.  The virtual bus is a software based bus intended to supp=
ort
> lightweight devices and drivers and provide matching between them and
> probing of the registered drivers.
>=20
> The primary purpose of the virual bus is to provide matching services and=
 to
> pass the data pointer contained in the virtbus_device to the virtbus_driv=
er
> during its probe call.  This will allow two separate kernel objects to ma=
tch up
> and start communication.
>=20
It is fundamental to know that rdma device created by virtbus_driver will b=
e anchored to which bus for an non abusive use.
virtbus or parent pci bus?
I asked this question in v1 version of this patch.

Also since it says - 'to support lightweight devices', documenting that inf=
ormation is critical to avoid ambiguity.

Since for a while I am working on the subbus/subdev_bus/xbus/mdev [1] whate=
ver we want to call it, it overlaps with your comment about 'to support lig=
htweight devices'.
Hence let's make things crystal clear weather the purpose is 'only matching=
 service' or also 'lightweight devices'.
If this is only matching service, lets please remove lightweight devices pa=
rt..

You additionally need modpost support for id table integration to modifo, m=
odprobe and other tools.
A small patch similar to this one [2] is needed.
Please include in the series.

[..]

> +static const
> +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *id,
> +					struct virtbus_device *vdev)
> +{
> +	while (id->name[0]) {
> +		if (!strcmp(vdev->name, id->name)) {
> +			vdev->dev_id =3D id;
Matching function shouldn't be modifying the id.

> +			return id;
> +		}
> +		id++;
> +	}
> +	return NULL;
> +}
> +
> +#define to_virtbus_dev(x)	(container_of((x), struct virtbus_device, dev)=
)
> +#define to_virtbus_drv(x)	(container_of((x), struct virtbus_driver, \
> +				 driver))
> +
> +/**
> + * virtbus_match - bind virtbus device to virtbus driver
> + * @dev: device
> + * @drv: driver
> + *
> + * Virtbus device IDs are always in "<name>.<instance>" format.
We might have to change this scheme depending on the first question I asked=
 in the email about device anchoring.

> +
> +struct bus_type virtual_bus_type =3D {
> +	.name		=3D "virtbus",
> +	.match		=3D virtbus_match,
> +	.probe		=3D virtbus_probe,
> +	.remove		=3D virtbus_remove,
> +	.shutdown	=3D virtbus_shutdown,
> +	.suspend	=3D virtbus_suspend,
> +	.resume		=3D virtbus_resume,
> +};
Drop the tab alignment.

> +
> +/**
> + * virtbus_dev_register - add a virtual bus device
> + * @vdev: virtual bus device to add
> + */
> +int virtbus_dev_register(struct virtbus_device *vdev) {
> +	int ret;
> +
> +	if (!vdev)
> +		return -EINVAL;
No need for this check.
Driver shouldn't be called null device registration.

> +
> +	device_initialize(&vdev->dev);
> +
> +	vdev->dev.bus =3D &virtual_bus_type;
> +	/* All device IDs are automatically allocated */
> +	ret =3D ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
> +
This is bug, once device_initialize() is done, it must do put_device() and =
follow the release sequence.

> +	vdev->id =3D ret;
> +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
> +
> +	dev_dbg(&vdev->dev, "Registering VirtBus device '%s'\n",
I think 'virtbus' naming is better instead of 'VirtBus' all over. We don't =
do "Pci' in prints etc.

> +		dev_name(&vdev->dev));
> +
> +	ret =3D device_add(&vdev->dev);
> +	if (!ret)
> +		return ret;
> +
> +	/* Error adding virtual device */
> +	device_del(&vdev->dev);
> +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> +	vdev->id =3D VIRTBUS_DEVID_NONE;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtbus_dev_register);
> +
> +/**
> + * virtbus_dev_unregister - remove a virtual bus device
> + * vdev: virtual bus device we are removing  */ void
> +virtbus_dev_unregister(struct virtbus_device *vdev) {
> +	if (!IS_ERR_OR_NULL(vdev)) {
> +		device_del(&vdev->dev);
> +
> +		ida_simple_remove(&virtbus_dev_ida, vdev->id);
I believe this should be done in the release() because above device_del() m=
ay not ensure that all references to the devices are dropped.

> +		vdev->id =3D VIRTBUS_DEVID_NONE;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(virtbus_dev_unregister);
> +
> +struct virtbus_object {
> +	struct virtbus_device vdev;
> +	char name[];
> +};
> +
This shouldn't be needed once. More below.

> +/**
> + * virtbus_dev_release - Destroy a virtbus device
> + * @vdev: virtual device to release
> + *
> + * Note that the vdev->data which is separately allocated needs to be
> + * separately freed on it own.
> + */
> +static void virtbus_dev_release(struct device *dev) {
> +	struct virtbus_object *vo =3D container_of(dev, struct virtbus_object,
> +						 vdev.dev);
> +
> +	kfree(vo);
> +}
> +
> +/**
> + * virtbus_dev_alloc - allocate a virtbus device
> + * @name: name to associate with the vdev
> + * @data: pointer to data to be associated with this device  */ struct
> +virtbus_device *virtbus_dev_alloc(const char *name, void *data) {
> +	struct virtbus_object *vo;
> +
Data should not be used.
Caller needs to give a size of the object to allocate.
I discussed the example in detail with Jason in v1 of this patch. Please re=
fer in that email.
It should be something like this.

/* size =3D sizeof(struct i40_virtbus_dev), and it is the first member */
virtbus_dev_alloc(size)
{
	[..]
}

struct i40_virtbus_dev {
	struct virbus_dev virtdev;
	/*... more fields that you want to share with other driver and to use in p=
robe() */
};

irdma_probe(..)
{
	struct i40_virtbus_dev dev =3D container_of(dev, struct i40_virtbus_dev, d=
ev);
}

[..]

> diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h ne=
w file
> mode 100644 index 000000000000..b6f2406180f8
> --- /dev/null
> +++ b/include/linux/virtual_bus.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * virtual_bus.h - lightweight software bus
> + *
> + * Copyright (c) 2019-20 Intel Corporation
> + *
> + * Please see Documentation/driver-api/virtual_bus.rst for more
> +information  */
> +
> +#ifndef _VIRTUAL_BUS_H_
> +#define _VIRTUAL_BUS_H_
> +
> +#include <linux/device.h>
> +
> +#define VIRTBUS_DEVID_NONE	(-1)
> +#define VIRTBUS_NAME_SIZE	20
> +
> +struct virtbus_dev_id {
> +	char name[VIRTBUS_NAME_SIZE];
> +	u64 driver_data;
> +};
> +
> +struct virtbus_device {
> +	const char			*name;
> +	int				id;
> +	const struct virtbus_dev_id	*dev_id;
> +	struct device			dev;
Drop the tab based alignment and just please follow format of virtbus_drive=
r you did below.
> +	void				*data;
Please drop data. we need only wrapper API virtbus_get/set_drvdata().
> +};

[1] https://lore.kernel.org/linux-rdma/20191107160448.20962-1-parav@mellano=
x.com/
[2] https://lore.kernel.org/patchwork/patch/1046991/
