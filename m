Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559A1EC965
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfKAULh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:11:37 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:21063
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfKAULh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:11:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9c5jmLCRkkrZ0yR/IKrF1+ewdArAsI2MtXXYPB2/KIUx28+yjtP4yVDzmp15RQJuAexHsUYyHQdlowp55qBpKjtw6MRz0EGosiCvICk3RIQGxF5/d9TphWG83v8lCze0qqRGjYB2yBkf5nX1hpcv00r3trvNv1qBFevlT54FSIi9HVr7EPFhNIOpOuryF8Z0ZDfPsQLGADgCjVwP1dsqGULEjjMn9i9KkaAVbAcRfIlSAp8Y0dZsjI+GlulJtf75lLDITWv5W/B0aGV5wlow4PSQ8NE0SgML93KKBYuvw8d/n0pKmc6JAEYyOTrFPNhnyA8q26Md8nJzwO1mgWiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5MgvGOAx/HfUZj2RnveEiLcK9cxzl/d30370nKYdAU=;
 b=jQG0Mu8nTNgT6JwkoR71MJJP+pvwkI/pThHq9bLW6LsfEnNS5tVz/D2BYfNKzV4nmoS4B177ir1niY8iYovrAYD955CkrAV7MQTe8KtCcNGUL2Gc+ojWiCRal0LcU9H2Csf3upSS4jpclEeWE5X+zONQk3I3ZfAZcNg0lPJB6SyNbkipsPwdBu1b1uPtsWzOrPCpA06G7TWGPkrBCMVVse9Udptt9zJtOivOe/iiaUsLdiLNDg1lnt2MwP6e48LpWs6v0kwTZ10vxoegOwM8aRsmboct33/ctG30yqbvhiqgoB/P548Go9JJ+YzhRpZVmDP7eWL0V2I3cJgpGVLfcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5MgvGOAx/HfUZj2RnveEiLcK9cxzl/d30370nKYdAU=;
 b=XMvYgdJ6jp3kVnbfQS0HzXcbSkQ6At4h8hbWPmXYOdqQQb4KSFhPKnO3oGRl1qJ+XDoXRHmcr0jUUBbGBmQSmgu386c1GJQXQe8CNNKnWCa1erwk9XW+e+zzENnA5pCfx78PVdRDByJ4G/MTzFRb+P0tFe7LNi8XMHVfZYnIm1Q=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5665.eurprd05.prod.outlook.com (20.178.112.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 20:11:29 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 20:11:29 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "rodrigo.vivi@intel.com" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        Ido Shamay <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>
Subject: RE: [PATCH V6 3/6] mdev: introduce device specific ops
Thread-Topic: [PATCH V6 3/6] mdev: introduce device specific ops
Thread-Index: AQHVju3ug3yiMO78q0axXkP5igJmr6d2wYnQ
Date:   Fri, 1 Nov 2019 20:11:28 +0000
Message-ID: <AM0PR05MB4866E91139617C9F2380BBAFD1620@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191030064444.21166-1-jasowang@redhat.com>
 <20191030064444.21166-4-jasowang@redhat.com>
In-Reply-To: <20191030064444.21166-4-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 138b56cc-818d-4114-4cd4-08d75f07ae7a
x-ms-traffictypediagnostic: AM0PR05MB5665:|AM0PR05MB5665:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5665BDDBAA2337B5A52F0FBDD1620@AM0PR05MB5665.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(189003)(199004)(13464003)(4326008)(99286004)(316002)(6116002)(55016002)(476003)(2906002)(229853002)(9686003)(3846002)(53546011)(110136005)(66946007)(14454004)(25786009)(66476007)(2501003)(54906003)(66066001)(64756008)(66556008)(486006)(11346002)(446003)(76116006)(81156014)(7696005)(74316002)(2201001)(76176011)(7416002)(7406005)(305945005)(33656002)(7736002)(52536014)(26005)(66446008)(5660300002)(86362001)(102836004)(6506007)(6246003)(81166006)(6436002)(71200400001)(71190400001)(8676002)(8936002)(478600001)(14444005)(256004)(186003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5665;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bv/wZtxh1hquQLapEfoP1sjVlYC3HofuASHTlCDx4m9dhxcBOqiHYEYv4rRo7EHFjCgJZfWdIl8mprQUk04nN9GLhoOiZcDnNQ4vUJCm1x4wB7YRHlJ+4ILk8UnUSRk/SuGp1NAyph1/KQ9HiQvgWNHy9Cw6pF6ESb/XaJyxPPgYITN9IX14KmTE1j7V5QA33ZvDh0HNZ14RSysK/wbEcw2iHDPvXaoM0gFqwXt0YEU1MNlFHArqYTm44cx9T7AV6G0rmUnB8OC9l2MqBuqB0Gk6fmotXzvp0+YYkXaBmTQ6BqAxZb3k8np7upqvKJbc4rknSa27KT496ouPMWiw7HNAzwh+8kWXJKIILNCAEEmKLCdLoqRpyN22SUwgyxtsHeRGK4Hdxq9ICM9tN9yPa8QmpcNjZCaMIOO2oDXE74N9H17kjDecmswI1Kt7pfsu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138b56cc-818d-4114-4cd4-08d75f07ae7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 20:11:29.0456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fOgp+ASMgUu+x5Y5uts7uk6VxHVNawaggp2GYSihgQOFo1NKConiaqp0Rebvsi6pEi34wUTIg6KpCrPQbR8v2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5665
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Wednesday, October 30, 2019 1:45 AM
> To: kvm@vger.kernel.org; linux-s390@vger.kernel.org; linux-
> kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; intel-
> gfx@lists.freedesktop.org; intel-gvt-dev@lists.freedesktop.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; mst@redhat.com;
> tiwei.bie@intel.com
> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org;
> cohuck@redhat.com; maxime.coquelin@redhat.com;
> cunming.liang@intel.com; zhihong.wang@intel.com;
> rob.miller@broadcom.com; xiao.w.wang@intel.com;
> haotian.wang@sifive.com; zhenyuw@linux.intel.com; zhi.a.wang@intel.com;
> jani.nikula@linux.intel.com; joonas.lahtinen@linux.intel.com;
> rodrigo.vivi@intel.com; airlied@linux.ie; daniel@ffwll.ch;
> farman@linux.ibm.com; pasic@linux.ibm.com; sebott@linux.ibm.com;
> oberpar@linux.ibm.com; heiko.carstens@de.ibm.com; gor@linux.ibm.com;
> borntraeger@de.ibm.com; akrowiak@linux.ibm.com; freude@linux.ibm.com;
> lingshan.zhu@intel.com; Ido Shamay <idos@mellanox.com>;
> eperezma@redhat.com; lulu@redhat.com; Parav Pandit
> <parav@mellanox.com>; christophe.de.dinechin@gmail.com;
> kevin.tian@intel.com; stefanha@redhat.com; Jason Wang
> <jasowang@redhat.com>
> Subject: [PATCH V6 3/6] mdev: introduce device specific ops
>=20
> Currently, except for the create and remove, the rest of mdev_parent_ops =
is
> designed for vfio-mdev driver only and may not help for kernel mdev drive=
r.
> With the help of class id, this patch introduces device specific callback=
s inside
> mdev_device structure. This allows different set of callback to be used b=
y vfio-
> mdev and virtio-mdev.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
[ ..]

> diff --git a/include/linux/vfio_mdev_ops.h b/include/linux/vfio_mdev_ops.=
h
> new file mode 100644 index 000000000000..3907c5371c2b
> --- /dev/null
> +++ b/include/linux/vfio_mdev_ops.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * VFIO Mediated device definition
> + */
> +
> +#ifndef VFIO_MDEV_H
> +#define VFIO_MDEV_H
> +
I should have noticed this before. :-(
APIs exposed are by the mdev module and named with mdev_ prefix.
And file name is _ops.h,

We should name this file as mdev_vfio_ops.h

And #define should be MDEV_VFIO_OPS_H

> +#include <linux/mdev.h>
> +
> +/**
> + * struct vfio_mdev_device_ops - Structure to be registered for each
s/vfio_mdev_device_ops/mdev_vfio_device_ops/

Similarly for virtio in future patches.

> + * mdev device to register the device to vfio-mdev module.
> + *
> + * @open:		Open mediated device.
> + *			@mdev: mediated device.
> + *			Returns integer: success (0) or error (< 0)
> + * @release:		release mediated device
> + *			@mdev: mediated device.
> + * @read:		Read emulation callback
> + *			@mdev: mediated device structure
> + *			@buf: read buffer
> + *			@count: number of bytes to read
> + *			@ppos: address.
> + *			Retuns number on bytes read on success or error.
> + * @write:		Write emulation callback
> + *			@mdev: mediated device structure
> + *			@buf: write buffer
> + *			@count: number of bytes to be written
> + *			@ppos: address.
> + *			Retuns number on bytes written on success or error.
> + * @ioctl:		IOCTL callback
> + *			@mdev: mediated device structure
> + *			@cmd: ioctl command
> + *			@arg: arguments to ioctl
> + * @mmap:		mmap callback
> + *			@mdev: mediated device structure
> + *			@vma: vma structure
> + */
> +struct vfio_mdev_device_ops {
> +	int     (*open)(struct mdev_device *mdev);
> +	void    (*release)(struct mdev_device *mdev);
> +	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
> +			size_t count, loff_t *ppos);
> +	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
> +			 size_t count, loff_t *ppos);
> +	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> +			 unsigned long arg);
> +	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct
> *vma);
> +};
> +
> +#endif
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c inde=
x
> 115bc5074656..1afec20bf0c5 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -30,6 +30,7 @@
>  #include <linux/iommu.h>
>  #include <linux/sysfs.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev_ops.h>
>  #include <linux/pci.h>
>  #include <linux/dma-buf.h>
>  #include <linux/highmem.h>
> @@ -516,6 +517,8 @@ static int mbochs_reset(struct mdev_device *mdev)
>  	return 0;
>  }
>=20
> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
> +
>  static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)=
  {
>  	const struct mbochs_type *type =3D mbochs_find_type(kobj); @@ -561,7
> +564,7 @@ static int mbochs_create(struct kobject *kobj, struct mdev_devi=
ce
> *mdev)
>  	mbochs_reset(mdev);
>=20
>  	mbochs_used_mbytes +=3D type->mbytes;
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>  	return 0;
>=20
>  err_mem:
> @@ -1419,12 +1422,7 @@ static struct attribute_group *mdev_type_groups[]
> =3D {
>  	NULL,
>  };
>=20
> -static const struct mdev_parent_ops mdev_fops =3D {
> -	.owner			=3D THIS_MODULE,
> -	.mdev_attr_groups	=3D mdev_dev_groups,
> -	.supported_type_groups	=3D mdev_type_groups,
> -	.create			=3D mbochs_create,
> -	.remove			=3D mbochs_remove,
> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>  	.open			=3D mbochs_open,
>  	.release		=3D mbochs_close,
>  	.read			=3D mbochs_read,
> @@ -1433,6 +1431,14 @@ static const struct mdev_parent_ops mdev_fops =3D =
{
>  	.mmap			=3D mbochs_mmap,
>  };
>=20
> +static const struct mdev_parent_ops mdev_fops =3D {
> +	.owner			=3D THIS_MODULE,
> +	.mdev_attr_groups	=3D mdev_dev_groups,
> +	.supported_type_groups	=3D mdev_type_groups,
> +	.create			=3D mbochs_create,
> +	.remove			=3D mbochs_remove,
> +};
> +
>  static const struct file_operations vd_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c index
> 665614574d50..d571fb65f50f 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -26,6 +26,7 @@
>  #include <linux/iommu.h>
>  #include <linux/sysfs.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev_ops.h>
>  #include <linux/pci.h>
>  #include <drm/drm_fourcc.h>
>  #include "mdpy-defs.h"
> @@ -226,6 +227,8 @@ static int mdpy_reset(struct mdev_device *mdev)
>  	return 0;
>  }
>=20
> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
> +
>  static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)  =
{
>  	const struct mdpy_type *type =3D mdpy_find_type(kobj); @@ -269,7
> +272,7 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device
> *mdev)
>  	mdpy_reset(mdev);
>=20
>  	mdpy_count++;
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>  	return 0;
>  }
>=20
> @@ -726,12 +729,7 @@ static struct attribute_group *mdev_type_groups[] =
=3D {
>  	NULL,
>  };
>=20
> -static const struct mdev_parent_ops mdev_fops =3D {
> -	.owner			=3D THIS_MODULE,
> -	.mdev_attr_groups	=3D mdev_dev_groups,
> -	.supported_type_groups	=3D mdev_type_groups,
> -	.create			=3D mdpy_create,
> -	.remove			=3D mdpy_remove,
> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>  	.open			=3D mdpy_open,
>  	.release		=3D mdpy_close,
>  	.read			=3D mdpy_read,
> @@ -740,6 +738,14 @@ static const struct mdev_parent_ops mdev_fops =3D {
>  	.mmap			=3D mdpy_mmap,
>  };
>=20
> +static const struct mdev_parent_ops mdev_fops =3D {
> +	.owner			=3D THIS_MODULE,
> +	.mdev_attr_groups	=3D mdev_dev_groups,
> +	.supported_type_groups	=3D mdev_type_groups,
> +	.create			=3D mdpy_create,
> +	.remove			=3D mdpy_remove,
> +};
> +
>  static const struct file_operations vd_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c index
> 90da12ff7fd9..4048b242c636 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -27,6 +27,7 @@
>  #include <linux/ctype.h>
>  #include <linux/file.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev_ops.h>
>  #include <linux/pci.h>
>  #include <linux/serial.h>
>  #include <uapi/linux/serial_reg.h>
> @@ -708,6 +709,8 @@ static ssize_t mdev_access(struct mdev_device *mdev,
> u8 *buf, size_t count,
>  	return ret;
>  }
>=20
> +static const struct vfio_mdev_device_ops vfio_dev_ops;
> +
>  static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)  =
{
>  	struct mdev_state *mdev_state;
> @@ -755,7 +758,7 @@ static int mtty_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	list_add(&mdev_state->next, &mdev_devices_list);
>  	mutex_unlock(&mdev_list_lock);
>=20
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_dev_ops);
>  	return 0;
>  }
>=20
> @@ -1388,6 +1391,14 @@ static struct attribute_group *mdev_type_groups[]
> =3D {
>  	NULL,
>  };
>=20
> +static const struct vfio_mdev_device_ops vfio_dev_ops =3D {
> +	.open		=3D mtty_open,
> +	.release	=3D mtty_close,
> +	.read		=3D mtty_read,
> +	.write		=3D mtty_write,
> +	.ioctl		=3D mtty_ioctl,
> +};
> +
>  static const struct mdev_parent_ops mdev_fops =3D {
>  	.owner                  =3D THIS_MODULE,
>  	.dev_attr_groups        =3D mtty_dev_groups,
> @@ -1395,11 +1406,6 @@ static const struct mdev_parent_ops mdev_fops =3D =
{
>  	.supported_type_groups  =3D mdev_type_groups,
>  	.create                 =3D mtty_create,
>  	.remove			=3D mtty_remove,
> -	.open                   =3D mtty_open,
> -	.release                =3D mtty_close,
> -	.read                   =3D mtty_read,
> -	.write                  =3D mtty_write,
> -	.ioctl		        =3D mtty_ioctl,
>  };
>=20
>  static void mtty_device_release(struct device *dev)
> --
> 2.19.1
With above small nit changes to rename the fields and file,

Reviewed-by: Parav Pandit <parav@mellanox.com>
