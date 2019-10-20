Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1424DE143
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfJTXmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 19:42:04 -0400
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:48982
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbfJTXmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 19:42:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoFrs1A/4MGorRQKssuCqvrZasv31QyiI2cfdGwEJq4LYHaNSAkcLoBXLTLnOpURRRGI+xaKrFK7FQnZ5zJrxEoiuhS1C9PDoNr5Xgk4/O+MFUm2JKuW4aJx+Im3IEsXmVO0MTWSIM8CifdH9EemrosXXbM+0JO3GWj29CsqPL6EnO5V4zF0NwO2voIfkb2dqeHKm6iZ3Uhj5wkcMNK0llyS8abtqhZtbeV9CNtbipXfH2gk7Q1OYf631/VsvjH0K1sE90/PfvWDkmnJKQCEjyQHuRZwRT2d5CPxiTgdxvjxDaD20gPLy/00UnE2vVtpwLy/KgiHQcI1ivN7GTKfDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jbpo7Uv2pOFfNEwrEM/Td1I0s9Jn48KfWL6WRkdX54c=;
 b=a5s8HooNAuIGb58bv00bQUgu14msZ1P6nDyxHelbWm8AidH7FyUTzSQ6IosGHNT8SulthSgxpd/AE9PGoXAQF/46h+jNApuE8egu6el0BRgBt7XTPV3QLns0ZnU3q7Q1AySKvldQw8rE2ISttp6moqKFywU/D7H/MEflRYkoY+RgxA5p3jteW/LzGRbzuCLsfh6uhfjQHUzSRY9teXd8+yzLNeFR7yM0G21LctrcLy6acDkaU8U6RnlzD6gDQEOjFeXHIFRpWHFF1b1Zdkzi7vHpKlkqAMVEZSZtD4bMOS2Xisd29rMllR9ZUqUMdtFZRAB/1PkdF6SfvWpvYyhO7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jbpo7Uv2pOFfNEwrEM/Td1I0s9Jn48KfWL6WRkdX54c=;
 b=nv+WQWp52G6fnTdcHQAAyiF+FrMvbc/nsFjwx4f4WUVK4KScRtrrfIkzLfXcmgiVVaOK7Hn1eYxCCzuHZCHaMtz1AhnN9QR23/jgluITtPRqWuuODI+V5AR5ce8AIikfd8CSdzBsM+FRDj6n6ahtDAkqqVA6ZLM1AB+l03NMs8s=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5955.eurprd05.prod.outlook.com (20.178.202.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Sun, 20 Oct 2019 23:41:53 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2347.028; Sun, 20 Oct 2019
 23:41:53 +0000
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
Subject: RE: [PATCH V4 3/6] mdev: introduce device specific ops
Thread-Topic: [PATCH V4 3/6] mdev: introduce device specific ops
Thread-Index: AQHVhNjF8VyWNucdc0mE547egMy6CKdkMudA
Date:   Sun, 20 Oct 2019 23:41:53 +0000
Message-ID: <AM0PR05MB48666BF4DE14169E05557A6ED16E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
 <20191017104836.32464-4-jasowang@redhat.com>
In-Reply-To: <20191017104836.32464-4-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:4571:4eb1:2e3a:4d72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edf7ff0c-b2b3-4921-468c-08d755b71640
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM0PR05MB5955:|AM0PR05MB5955:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB59554E393E884463A7C1734DD16E0@AM0PR05MB5955.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0196A226D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(13464003)(199004)(189003)(52536014)(11346002)(99286004)(76116006)(102836004)(53546011)(66476007)(66556008)(64756008)(66446008)(6506007)(186003)(476003)(486006)(66946007)(71190400001)(71200400001)(46003)(54906003)(2501003)(316002)(8676002)(76176011)(7696005)(110136005)(8936002)(446003)(5660300002)(30864003)(81166006)(81156014)(33656002)(55016002)(6116002)(25786009)(9686003)(4326008)(6436002)(6246003)(2201001)(86362001)(2906002)(478600001)(229853002)(256004)(14444005)(14454004)(7416002)(7406005)(74316002)(7736002)(305945005)(921003)(1121003)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5955;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ixW2yvzP9MDrL+oEmeGjB+G+BWqHvwpgPs4Sb5WfqBOo5k4Oi/+wGi5F/OvzMBVfa6RtbHvWvfxUBQrSNKDF5E5/nxYWbxZ8D1gW7ELhibiznOFnFTsdvlvntae8oAIyyJie6EkObCfh/YXUFndnpOw/01nIaaQxTtNJinqbbybgmHJaso9ROhQivUApjmwrQouIG4gsI6CB6m67L4AC5vLbxXwIeqQeDBHzE5UswKzTaEOHUaOFE/wvpwhqIpEsBhaBa0QjPeIN4PRyrHJrtDh5fdU9b9kXS+Rp5dTJ5s8TIRIk68DjJ3zNQBKF0L4oyd7GCh8g7J1EduJaOfFV0YNk37NW33a4uDtFYnb5JCEHrHvyXg2owIpNEgXRs3Aj8tEMHFyu6N3kVdP1xz9tvvqyt0kVKyK6xtHWXC+UCw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf7ff0c-b2b3-4921-468c-08d755b71640
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2019 23:41:53.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pgVXmaV6znOGUnXPwD8/NYyh5xqnHSfkZ1uoSiro5YSNclFHafGMOZo5rfqlWk/29y7QvBuxN93ByoYwradSNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5955
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Thursday, October 17, 2019 5:49 AM
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
> Subject: [PATCH V4 3/6] mdev: introduce device specific ops
>=20
> Currently, except for the create and remove, the rest of mdev_parent_ops =
is
> designed for vfio-mdev driver only and may not help for kernel mdev drive=
r.
> With the help of class id, this patch introduces device specific callback=
s
> inside mdev_device structure. This allows different set of callback to be=
 used
> by vfio-mdev and virtio-mdev.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       | 25 +++++----
>  MAINTAINERS                                   |  1 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
>  drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
>  drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
>  drivers/vfio/mdev/mdev_core.c                 | 18 +++++--
>  drivers/vfio/mdev/mdev_private.h              |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>  include/linux/mdev.h                          | 45 ++++------------
>  include/linux/vfio_mdev.h                     | 52 +++++++++++++++++++
>  samples/vfio-mdev/mbochs.c                    | 20 ++++---
>  samples/vfio-mdev/mdpy.c                      | 20 ++++---
>  samples/vfio-mdev/mtty.c                      | 18 ++++---
>  13 files changed, 184 insertions(+), 103 deletions(-)  create mode 10064=
4
> include/linux/vfio_mdev.h
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index f9a78d75a67a..0cca84d19603 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -152,11 +152,22 @@ callbacks per mdev parent device, per mdev type,
> or any other categorization.
>  Vendor drivers are expected to be fully asynchronous in this respect or
> provide their own internal resource protection.)
>=20
> -The callbacks in the mdev_parent_ops structure are as follows:
> -
> -* open: open callback of mediated device
> -* close: close callback of mediated device
> -* ioctl: ioctl callback of mediated device
> +As multiple types of mediated devices may be supported, the device must
> +set up the class id and the device specific callbacks in create()
> +callback. E.g for vfio-mdev device it needs to be done through:
> +
> +    int mdev_set_vfio_ops(struct mdev_device *mdev,
> +                          const struct vfio_mdev_ops *vfio_ops);
> +
> +The class id (set to MDEV_CLASS_ID_VFIO) is used to match a device with
> +an mdev driver via its id table. The device specific callbacks
> +(specified in *ops) are obtainable via mdev_get_dev_ops() (for use by
> +the mdev bus driver). A vfio-mdev device (class id MDEV_CLASS_ID_VFIO)
> +uses the following device-specific ops:
> +
> +* open: open callback of vfio mediated device
> +* close: close callback of vfio mediated device
> +* ioctl: ioctl callback of vfio mediated device
>  * read : read emulation callback
>  * write: write emulation callback
>  * mmap: mmap emulation callback
> @@ -167,10 +178,6 @@ register itself with the mdev core driver::
>  	extern int  mdev_register_device(struct device *dev,
>  	                                 const struct mdev_parent_ops *ops);
>=20
> -It is also required to specify the class_id in create() callback through=
::
> -
> -	int mdev_set_class(struct mdev_device *mdev, u16 id);
> -
>  However, the mdev_parent_ops structure is not required in the function c=
all
> that a driver should use to unregister itself with the mdev core driver::
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8824f61cd2c0..3d196a023b5e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17127,6 +17127,7 @@ S:	Maintained
>  F:	Documentation/driver-api/vfio-mediated-device.rst
>  F:	drivers/vfio/mdev/
>  F:	include/linux/mdev.h
> +F:	include/linux/vfio_mdev.h
>  F:	samples/vfio-mdev/
>=20
>  VFIO PLATFORM DRIVER
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 6420f0dbd31b..306f934c7857 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -42,6 +42,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/vfio.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev.h>
>  #include <linux/debugfs.h>
>=20
>  #include <linux/nospec.h>
> @@ -643,6 +644,8 @@ static void kvmgt_put_vfio_device(void *vgpu)
>  	vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);  }
>=20
> +static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops;
> +
>  static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *m=
dev)
> {
>  	struct intel_vgpu *vgpu =3D NULL;
> @@ -678,7 +681,7 @@ static int intel_vgpu_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  		     dev_name(mdev_dev(mdev)));
>  	ret =3D 0;
>=20
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &intel_vfio_vgpu_dev_ops);
>  out:
>  	return ret;
>  }
> @@ -1599,20 +1602,21 @@ static const struct attribute_group
> *intel_vgpu_groups[] =3D {
>  	NULL,
>  };
>=20
> -static struct mdev_parent_ops intel_vgpu_ops =3D {
> -	.mdev_attr_groups       =3D intel_vgpu_groups,
> -	.create			=3D intel_vgpu_create,
> -	.remove			=3D intel_vgpu_remove,
> -
> +static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops =3D {
>  	.open			=3D intel_vgpu_open,
>  	.release		=3D intel_vgpu_release,
> -
>  	.read			=3D intel_vgpu_read,
>  	.write			=3D intel_vgpu_write,
>  	.mmap			=3D intel_vgpu_mmap,
>  	.ioctl			=3D intel_vgpu_ioctl,
>  };
>=20
> +static struct mdev_parent_ops intel_vgpu_ops =3D {
> +	.mdev_attr_groups       =3D intel_vgpu_groups,
> +	.create			=3D intel_vgpu_create,
> +	.remove			=3D intel_vgpu_remove,
> +};
> +
>  static int kvmgt_host_init(struct device *dev, void *gvt, const void *op=
s)  {
>  	struct attribute **kvm_type_attrs;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c index cf2c013ae32f..6e606cdb1aa9 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -12,6 +12,7 @@
>=20
>  #include <linux/vfio.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev.h>
>  #include <linux/nospec.h>
>  #include <linux/slab.h>
>=20
> @@ -110,6 +111,8 @@ static struct attribute_group *mdev_type_groups[] =3D
> {
>  	NULL,
>  };
>=20
> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
> +
>  static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device
> *mdev)  {
>  	struct vfio_ccw_private *private =3D
> @@ -129,7 +132,7 @@ static int vfio_ccw_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  			   private->sch->schid.ssid,
>  			   private->sch->schid.sch_no);
>=20
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>  	return 0;
>  }
>=20
> @@ -575,11 +578,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct
> mdev_device *mdev,
>  	}
>  }
>=20
> -static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
> -	.owner			=3D THIS_MODULE,
> -	.supported_type_groups  =3D mdev_type_groups,
> -	.create			=3D vfio_ccw_mdev_create,
> -	.remove			=3D vfio_ccw_mdev_remove,
> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>  	.open			=3D vfio_ccw_mdev_open,
>  	.release		=3D vfio_ccw_mdev_release,
>  	.read			=3D vfio_ccw_mdev_read,
> @@ -587,6 +586,13 @@ static const struct mdev_parent_ops
> vfio_ccw_mdev_ops =3D {
>  	.ioctl			=3D vfio_ccw_mdev_ioctl,
>  };
>=20
> +static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
> +	.owner			=3D THIS_MODULE,
> +	.supported_type_groups  =3D mdev_type_groups,
> +	.create			=3D vfio_ccw_mdev_create,
> +	.remove			=3D vfio_ccw_mdev_remove,
> +};
> +
>  int vfio_ccw_mdev_reg(struct subchannel *sch)  {
>  	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops); diff -
> -git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 07c31070afeb..195c8f4c6f10 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -16,6 +16,7 @@
>  #include <linux/bitops.h>
>  #include <linux/kvm_host.h>
>  #include <linux/module.h>
> +#include <linux/vfio_mdev.h>
>  #include <asm/kvm.h>
>  #include <asm/zcrypt.h>
>=20
> @@ -321,6 +322,8 @@ static void vfio_ap_matrix_init(struct ap_config_info
> *info,
>  	matrix->adm_max =3D info->apxa ? info->Nd : 15;  }
>=20
> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
> +
>  static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device
> *mdev)  {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -343,7 +346,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>  	mutex_unlock(&matrix_dev->lock);
>=20
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>  	return 0;
>  }
>=20
> @@ -1281,15 +1284,18 @@ static ssize_t vfio_ap_mdev_ioctl(struct
> mdev_device *mdev,
>  	return ret;
>  }
>=20
> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
> +	.open			=3D vfio_ap_mdev_open,
> +	.release		=3D vfio_ap_mdev_release,
> +	.ioctl			=3D vfio_ap_mdev_ioctl,
> +};
> +
>  static const struct mdev_parent_ops vfio_ap_matrix_ops =3D {
>  	.owner			=3D THIS_MODULE,
>  	.supported_type_groups	=3D vfio_ap_mdev_type_groups,
>  	.mdev_attr_groups	=3D vfio_ap_mdev_attr_groups,
>  	.create			=3D vfio_ap_mdev_create,
>  	.remove			=3D vfio_ap_mdev_remove,
> -	.open			=3D vfio_ap_mdev_open,
> -	.release		=3D vfio_ap_mdev_release,
> -	.ioctl			=3D vfio_ap_mdev_ioctl,
>  };
>=20
>  int vfio_ap_mdev_register(void)
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index 3a9c52d71b4e..d0f3113c8071 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,15 +45,23 @@ void mdev_set_drvdata(struct mdev_device *mdev,
> void *data)  }  EXPORT_SYMBOL(mdev_set_drvdata);
>=20
> -/* Specify the class for the mdev device, this must be called during
> - * create() callback.
> +/* Specify the VFIO device ops for the mdev device, this
> + * must be called during create() callback for VFIO mdev device.
>   */
> -void mdev_set_class(struct mdev_device *mdev, u16 id)
I think you should keep the mdev_set_class API and let mdev_set_vfio_ops ca=
ll it. Even though its two line function.
The reason to avoid a code churn in short time with mlx5_core patch which w=
ill only call mdev_set_class(), as it doesn't have any ops yet.

> +void mdev_set_vfio_ops(struct mdev_device *mdev,
> +		       const struct vfio_mdev_device_ops *vfio_ops)
>  {
>  	WARN_ON(mdev->class_id);
> -	mdev->class_id =3D id;
> +	mdev->class_id =3D MDEV_CLASS_ID_VFIO;
> +	mdev->device_ops =3D vfio_ops;
>  }
> -EXPORT_SYMBOL(mdev_set_class);
> +EXPORT_SYMBOL(mdev_set_vfio_ops);
> +
> +const void *mdev_get_dev_ops(struct mdev_device *mdev) {
> +	return mdev->device_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_dev_ops);
>=20
>  struct device *mdev_dev(struct mdev_device *mdev)  { diff --git
> a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index c65f436c1869..b666805f0b1f 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -34,6 +34,7 @@ struct mdev_device {
>  	struct device *iommu_device;
>  	bool active;
>  	u16 class_id;
> +	const void *device_ops;
Instead of void *, this should be union vfio_ops and virtio_ops.
>  };
>=20
>  #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index cb701cd646f0..6b6b92011436 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/vfio.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev.h>
>=20
>  #include "mdev_private.h"
>=20
> @@ -24,16 +25,16 @@
>  static int vfio_mdev_open(void *device_data)  {
>  	struct mdev_device *mdev =3D device_data;
> -	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_device_ops *ops =3D
> mdev_get_dev_ops(mdev);
>  	int ret;
>=20
> -	if (unlikely(!parent->ops->open))
> +	if (unlikely(!ops->open))
>  		return -EINVAL;
>=20
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>=20
> -	ret =3D parent->ops->open(mdev);
> +	ret =3D ops->open(mdev);
>  	if (ret)
>  		module_put(THIS_MODULE);
>=20
> @@ -43,10 +44,10 @@ static int vfio_mdev_open(void *device_data)  static
> void vfio_mdev_release(void *device_data)  {
>  	struct mdev_device *mdev =3D device_data;
> -	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_device_ops *ops =3D
> mdev_get_dev_ops(mdev);
>=20
> -	if (likely(parent->ops->release))
> -		parent->ops->release(mdev);
> +	if (likely(ops->release))
> +		ops->release(mdev);
>=20
>  	module_put(THIS_MODULE);
>  }
> @@ -55,47 +56,47 @@ static long vfio_mdev_unlocked_ioctl(void
> *device_data,
>  				     unsigned int cmd, unsigned long arg)  {
>  	struct mdev_device *mdev =3D device_data;
> -	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_device_ops *ops =3D
> mdev_get_dev_ops(mdev);
>=20
> -	if (unlikely(!parent->ops->ioctl))
> +	if (unlikely(!ops->ioctl))
>  		return -EINVAL;
>=20
> -	return parent->ops->ioctl(mdev, cmd, arg);
> +	return ops->ioctl(mdev, cmd, arg);
>  }
>=20
>  static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
>  			      size_t count, loff_t *ppos)
>  {
>  	struct mdev_device *mdev =3D device_data;
> -	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_device_ops *ops =3D
> mdev_get_dev_ops(mdev);
>=20
> -	if (unlikely(!parent->ops->read))
> +	if (unlikely(!ops->read))
>  		return -EINVAL;
>=20
> -	return parent->ops->read(mdev, buf, count, ppos);
> +	return ops->read(mdev, buf, count, ppos);
>  }
>=20
>  static ssize_t vfio_mdev_write(void *device_data, const char __user *buf=
,
>  			       size_t count, loff_t *ppos)
>  {
>  	struct mdev_device *mdev =3D device_data;
> -	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_device_ops *ops =3D
> mdev_get_dev_ops(mdev);
>=20
> -	if (unlikely(!parent->ops->write))
> +	if (unlikely(!ops->write))
>  		return -EINVAL;
>=20
> -	return parent->ops->write(mdev, buf, count, ppos);
> +	return ops->write(mdev, buf, count, ppos);
>  }
>=20
>  static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
> {
>  	struct mdev_device *mdev =3D device_data;
> -	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_device_ops *ops =3D
> mdev_get_dev_ops(mdev);
>=20
> -	if (unlikely(!parent->ops->mmap))
> +	if (unlikely(!ops->mmap))
>  		return -EINVAL;
>=20
> -	return parent->ops->mmap(mdev, vma);
> +	return ops->mmap(mdev, vma);
>  }
>=20
>  static const struct vfio_device_ops vfio_mdev_dev_ops =3D { diff --git
> a/include/linux/mdev.h b/include/linux/mdev.h index
> 78b69d09eb54..3d29e09e20c9 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,7 +10,13 @@
>  #ifndef MDEV_H
>  #define MDEV_H
>=20
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/mdev.h>
> +#include <uapi/linux/uuid.h>
> +
>  struct mdev_device;
> +struct vfio_mdev_device_ops;
>=20
>  /*
>   * Called by the parent device driver to set the device which represents=
 @@
> -48,30 +54,7 @@ struct device *mdev_get_iommu_device(struct device
> *dev);
>   *			@mdev: mdev_device device structure which is being
>   *			       destroyed
>   *			Returns integer: success (0) or error (< 0)
> - * @open:		Open mediated device.
> - *			@mdev: mediated device.
> - *			Returns integer: success (0) or error (< 0)
> - * @release:		release mediated device
> - *			@mdev: mediated device.
> - * @read:		Read emulation callback
> - *			@mdev: mediated device structure
> - *			@buf: read buffer
> - *			@count: number of bytes to read
> - *			@ppos: address.
> - *			Retuns number on bytes read on success or error.
> - * @write:		Write emulation callback
> - *			@mdev: mediated device structure
> - *			@buf: write buffer
> - *			@count: number of bytes to be written
> - *			@ppos: address.
> - *			Retuns number on bytes written on success or error.
> - * @ioctl:		IOCTL callback
> - *			@mdev: mediated device structure
> - *			@cmd: ioctl command
> - *			@arg: arguments to ioctl
> - * @mmap:		mmap callback
> - *			@mdev: mediated device structure
> - *			@vma: vma structure
> + *
>   * Parent device that support mediated device should be registered with
> mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -83,15 +66,6 @@ struct mdev_parent_ops {
>=20
>  	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>  	int     (*remove)(struct mdev_device *mdev);
> -	int     (*open)(struct mdev_device *mdev);
> -	void    (*release)(struct mdev_device *mdev);
> -	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
> -			size_t count, loff_t *ppos);
> -	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
> -			 size_t count, loff_t *ppos);
> -	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> -			 unsigned long arg);
> -	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct
> *vma);
>  };
>=20
>  /* interface for exporting mdev supported type attributes */ @@ -133,8
> +107,11 @@ struct mdev_driver {
>=20
>  void *mdev_get_drvdata(struct mdev_device *mdev);  void
> mdev_set_drvdata(struct mdev_device *mdev, void *data);
> +
Unrelated line change for this patch. Please remove.

>  const guid_t *mdev_uuid(struct mdev_device *mdev); -void
> mdev_set_class(struct mdev_device *mdev, u16 id);
> +void mdev_set_vfio_ops(struct mdev_device *mdev,
> +		       const struct vfio_mdev_device_ops *vfio_ops); const
> void
> +*mdev_get_dev_ops(struct mdev_device *mdev);
>=20
Since you have the set_vfio_ops, its better to have get_vfio_ops() and simi=
larly get_virtio_ops.

>  extern struct bus_type mdev_bus_type;
>=20
> diff --git a/include/linux/vfio_mdev.h b/include/linux/vfio_mdev.h new fi=
le
> mode 100644 index 000000000000..3907c5371c2b
> --- /dev/null
> +++ b/include/linux/vfio_mdev.h
This file name is confusing.
vfio_mdev_ops.h is more accurate name of what it intends to achieve.
If you see this file expanding scope beyond ops, this file name looks fine.

> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * VFIO Mediated device definition
> + */
> +
> +#ifndef VFIO_MDEV_H
> +#define VFIO_MDEV_H
> +
> +#include <linux/mdev.h>
> +
> +/**
> + * struct vfio_mdev_device_ops - Structure to be registered for each
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
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 115bc5074656..37abdf1b27a8 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -30,6 +30,7 @@
>  #include <linux/iommu.h>
>  #include <linux/sysfs.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev.h>
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
>  	const struct mbochs_type *type =3D mbochs_find_type(kobj); @@ -
> 561,7 +564,7 @@ static int mbochs_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mbochs_reset(mdev);
>=20
>  	mbochs_used_mbytes +=3D type->mbytes;
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>  	return 0;
>=20
>  err_mem:
> @@ -1419,12 +1422,7 @@ static struct attribute_group
> *mdev_type_groups[] =3D {
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
> @@ -1433,6 +1431,14 @@ static const struct mdev_parent_ops mdev_fops =3D
> {
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
> 665614574d50..f21c795c40e4 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -26,6 +26,7 @@
>  #include <linux/iommu.h>
>  #include <linux/sysfs.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev.h>
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
> @@ -726,12 +729,7 @@ static struct attribute_group *mdev_type_groups[]
> =3D {
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
> 90da12ff7fd9..b829f33b98f5 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -27,6 +27,7 @@
>  #include <linux/ctype.h>
>  #include <linux/file.h>
>  #include <linux/mdev.h>
> +#include <linux/vfio_mdev.h>
>  #include <linux/pci.h>
>  #include <linux/serial.h>
>  #include <uapi/linux/serial_reg.h>
> @@ -708,6 +709,8 @@ static ssize_t mdev_access(struct mdev_device
> *mdev, u8 *buf, size_t count,
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
> @@ -1388,6 +1391,14 @@ static struct attribute_group
> *mdev_type_groups[] =3D {
>  	NULL,
>  };
>=20
> +static const struct vfio_mdev_device_ops vfio_dev_ops =3D {
> +	.open                   =3D mtty_open,
> +	.release                =3D mtty_close,
> +	.read                   =3D mtty_read,
> +	.write                  =3D mtty_write,
> +	.ioctl		        =3D mtty_ioctl,
> +};
> +
Since hunk shows that vfio_dev_ops added new here, it is better to drop the=
 extra white space mixed with tab alignment.
Just have single white space like below.

	.open =3D mtty_open,
	.release =3D mtty_close,
	.read =3D mtty_read,
	.write =3D mtty_write,
	.ioctl =3D mtty_ioctl

>  static const struct mdev_parent_ops mdev_fops =3D {
>  	.owner                  =3D THIS_MODULE,
>  	.dev_attr_groups        =3D mtty_dev_groups,
> @@ -1395,11 +1406,6 @@ static const struct mdev_parent_ops mdev_fops =3D
> {
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

