Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8CDBBEAF
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 00:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503508AbfIWW7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 18:59:15 -0400
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:29575
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407729AbfIWW7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 18:59:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9JCBzsZNn6lAK43IVlL7CfY8vvKXJdv88wVm1k7XjJAfTXzt5hJ5Dg2tvXrA7nV3rM3UfTRdXjJ5vRNXIZSGYA2JwXiX5xKJi6P04Dy99dsRGobEM+vyWjEh7G+QR8J5bQ3ZjXKFzzC4KGjt000xHjPZe+ZA3c0/C6AdULIAbn00pNsZG9uA3P8ysCMjqQzqO4nuIOxcOrJNwOgflKQJCjq77c1PdyJOilOMZO+dQhbHRUCykJZm5NcpMHiu6YeY5iLzVY+1DpUGCd4859Am85SP54R196O0Tc9tK+aFSBb5z8pud75IbkKC/22Gkn8o0fPcTzXCNXU1cab+XV2Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpvBjoE7Lh6iGPxVem3k/E2DdftxJNe62TjlVLzJ1J8=;
 b=oe+DWsobpdUwLhZu/dXcScIbL1UHenDptIbyznWupjUSd0jZFMvPTz1BgtC5x4NlROxXFJk3e8pAIFkXLdoNG19OE87eXimFFdt/V6FeV5FrXy3hQyVaguVLj1Mg6ii63CKdazgfx0Ys6YYjS1FN3TTWw90mf0oPQRkYqCiHNVpEeLObdrSoVY5TNj9UzkUFX151HNqnCaJu46N4na40MSk2mFQ9KC4tdY078xXOPatIUZ2Oxz/fMGSjGKpW05YhxajOv0SpbqXeTyL/hUh/MKDtyQtE+7ySfHcm0ibzyPkOqSjtDjlNzFPtR/vrBPPJ+j2v6AnN5sqo5pUgdAzXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpvBjoE7Lh6iGPxVem3k/E2DdftxJNe62TjlVLzJ1J8=;
 b=NZfQDh/ufuPsgtMWXQBWFVxtXn4hNONSTnZpFybgPNgmSfncAqX+psTNy0VPDb8vyKj5rLafEi0b4PqhmWA34sV+3pG1prNdjXgL147FYAKc7MwEnfZXv23NR176ws6rCHku8o+qlDmVgmCxYmlHA5JcEfS8+mp2A2OmhipZ9nY=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6225.eurprd05.prod.outlook.com (20.178.114.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Mon, 23 Sep 2019 22:59:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 22:59:09 +0000
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
        "lulu@redhat.com" <lulu@redhat.com>
Subject: RE: [PATCH 2/6] mdev: introduce device specific ops
Thread-Topic: [PATCH 2/6] mdev: introduce device specific ops
Thread-Index: AQHVcg97F7axka9YNkeut4ZP3pfHkqc53s5w
Date:   Mon, 23 Sep 2019 22:59:08 +0000
Message-ID: <AM0PR05MB4866D870687C7EA7190A91B2D1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-3-jasowang@redhat.com>
In-Reply-To: <20190923130331.29324-3-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33e5995d-95b1-4f92-3d96-08d74079a485
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6225;
x-ms-traffictypediagnostic: AM0PR05MB6225:|AM0PR05MB6225:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB62251CD5FF90C107B58D4682D1850@AM0PR05MB6225.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39850400004)(346002)(13464003)(199004)(189003)(7736002)(102836004)(7416002)(110136005)(478600001)(53546011)(76176011)(99286004)(7696005)(316002)(186003)(2501003)(76116006)(66946007)(476003)(11346002)(66066001)(4326008)(54906003)(33656002)(6506007)(26005)(30864003)(446003)(5660300002)(8936002)(229853002)(14444005)(6116002)(3846002)(8676002)(66556008)(25786009)(55016002)(64756008)(52536014)(66446008)(74316002)(14454004)(486006)(66476007)(7406005)(71190400001)(71200400001)(6436002)(81156014)(2906002)(305945005)(6246003)(256004)(86362001)(9686003)(81166006)(2201001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6225;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OKVuI/HWyuE8TtA5rjA87PwSYgFWkKYjGQwcJZGSiobYHl0Kaiw7fszpEF8g32v91QUNoi8t9nTKmQg7Nv/8TvY9UgxHUswAM+Tl/C93s7uHQC2tKOxwZEo0a6XR2GX1XLGSQmbV7I4SZlrLZjB1S/6RbEmLtyolN3LzbyP1du5/7YiZNSNK9NhdKSho7bb58+2MLRUZZZuy5hRUypg0GhsNdonQQXKIjfCZT2Zkw8y+D1EudrOelpvtocids8M8oEIva30BNXyt4LUjc8HdtKsKNqbEJTVC4e2N2DJr2I+40FEoxpzPt6Xl5GsBnX5x4V8yLs2bSk/YHpdwe2xf8hnsJagbki8/Rv16+kEJ0f2952cOiy5MlDRjleoLnkcuG1k9bdKYRKb1m+g+cJ9K6b0tpB9nCE/sbLUVyGVsh+Q=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e5995d-95b1-4f92-3d96-08d74079a485
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 22:59:08.9061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TPNBrKCIXrsAa+EVnp/OTYJpkGTSGbjvCIPPXjdYnxmne8jU+a3l4UWNOMHz3NQGbFCI9ihe+A4PtU1jQfVj6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Monday, September 23, 2019 8:03 AM
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
> <parav@mellanox.com>; Jason Wang <jasowang@redhat.com>
> Subject: [PATCH 2/6] mdev: introduce device specific ops
>=20
> Currently, except for the create and remove. The rest of mdev_parent_ops =
is
> designed for vfio-mdev driver only and may not help for kernel mdev drive=
r.
> Follow the class id support by previous patch, this patch introduces devi=
ce
> specific ops pointer inside parent ops which points to device specific op=
s (e.g
> vfio ops). This allows the future drivers like virtio-mdev to implement i=
ts own
> device specific ops.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  4 +-
>  MAINTAINERS                                   |  1 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 15 +++---
>  drivers/s390/cio/vfio_ccw_ops.c               | 15 ++++--
>  drivers/s390/crypto/vfio_ap_ops.c             | 11 ++--
>  drivers/vfio/mdev/vfio_mdev.c                 | 31 ++++++-----
>  include/linux/mdev.h                          | 36 ++-----------
>  include/linux/vfio_mdev.h                     | 53 +++++++++++++++++++
>  samples/vfio-mdev/mbochs.c                    | 17 +++---
>  samples/vfio-mdev/mdpy.c                      | 17 +++---
>  samples/vfio-mdev/mtty.c                      | 15 ++++--
>  11 files changed, 138 insertions(+), 77 deletions(-)  create mode 100644
> include/linux/vfio_mdev.h
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 0e052072e1d8..3ab00e48212f 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -152,7 +152,9 @@ callbacks per mdev parent device, per mdev type, or
> any other categorization.
>  Vendor drivers are expected to be fully asynchronous in this respect or
> provide their own internal resource protection.)
>=20
> -The callbacks in the mdev_parent_ops structure are as follows:
> +The device specific callbacks are referred through device_ops pointer
> +in mdev_parent_ops. For vfio-mdev device, its callbacks in device_ops
> +are as follows:
>=20
>  * open: open callback of mediated device
>  * close: close callback of mediated device diff --git a/MAINTAINERS
> b/MAINTAINERS index b2326dece28e..89832b316500 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17075,6 +17075,7 @@ S:	Maintained
>  F:	Documentation/driver-api/vfio-mediated-device.rst
>  F:	drivers/vfio/mdev/
>  F:	include/linux/mdev.h
> +F:	include/linux/vfio_mdev.h
>  F:	samples/vfio-mdev/
>=20
>  VFIO PLATFORM DRIVER
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 19d51a35f019..8ea86b1e69f1 100644
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
> @@ -1600,20 +1601,22 @@ static const struct attribute_group
> *intel_vgpu_groups[] =3D {
>  	NULL,
>  };
>=20
> -static struct mdev_parent_ops intel_vgpu_ops =3D {
> -	.mdev_attr_groups       =3D intel_vgpu_groups,
> -	.create			=3D intel_vgpu_create,
> -	.remove			=3D intel_vgpu_remove,
> -
> +static struct vfio_mdev_parent_ops intel_vfio_vgpu_ops =3D {

Naming it with _dev prefix as intel_vfio_vgpu_dev_ops is better to differen=
tiate with parent_ops.

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
> +	.device_ops	        =3D &intel_vfio_vgpu_ops,
> +};
> +
>  static int kvmgt_host_init(struct device *dev, void *gvt, const void *op=
s)  {
>  	struct attribute **kvm_type_attrs;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_=
ops.c
> index 246ff0f80944..02122bbc213e 100644
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
> @@ -574,11 +575,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct
> mdev_device *mdev,
>  	}
>  }
>=20
> -static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
> -	.owner			=3D THIS_MODULE,
> -	.supported_type_groups  =3D mdev_type_groups,
> -	.create			=3D vfio_ccw_mdev_create,
> -	.remove			=3D vfio_ccw_mdev_remove,
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops =3D {
>  	.open			=3D vfio_ccw_mdev_open,
>  	.release		=3D vfio_ccw_mdev_release,
>  	.read			=3D vfio_ccw_mdev_read,
> @@ -586,6 +583,14 @@ static const struct mdev_parent_ops
> vfio_ccw_mdev_ops =3D {
>  	.ioctl			=3D vfio_ccw_mdev_ioctl,
>  };
>=20
> +static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
> +	.owner			=3D THIS_MODULE,
> +	.supported_type_groups  =3D mdev_type_groups,
> +	.create			=3D vfio_ccw_mdev_create,
> +	.remove			=3D vfio_ccw_mdev_remove,
> +	.device_ops		=3D &vfio_mdev_ops,
> +};
> +
>  int vfio_ccw_mdev_reg(struct subchannel *sch)  {
>  	return mdev_register_vfio_device(&sch->dev, &vfio_ccw_mdev_ops);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 7487fc39d2c5..4251becc7a6d 100644
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
> @@ -1280,15 +1281,19 @@ static ssize_t vfio_ap_mdev_ioctl(struct
> mdev_device *mdev,
>  	return ret;
>  }
>=20
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops =3D {
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
> +	.device_ops		=3D &vfio_mdev_ops,
>  };
>=20
>  int vfio_ap_mdev_register(void)
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index fd2a4d9a3f26..d23c9f58c84f 100644
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
> @@ -25,15 +26,16 @@ static int vfio_mdev_open(void *device_data)  {
>  	struct mdev_device *mdev =3D device_data;
>  	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops =3D parent->ops->device_ops;
>  	int ret;
>=20
> -	if (unlikely(!parent->ops->open))
> +	if (unlikely(!ops->open))
>  		return -EINVAL;
>=20
device_ops is optional and can be NULL for mdev devices which are not requi=
red to be mapped via vfio.
So please change to,

If (!ops || !ops->open)
	return -EINVAL;

and rest of the below places.

>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>=20
> -	ret =3D parent->ops->open(mdev);
> +	ret =3D ops->open(mdev);
>  	if (ret)
>  		module_put(THIS_MODULE);
>=20
> @@ -44,9 +46,10 @@ static void vfio_mdev_release(void *device_data)  {
>  	struct mdev_device *mdev =3D device_data;
>  	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops =3D parent->ops->device_ops;
>=20
> -	if (likely(parent->ops->release))
> -		parent->ops->release(mdev);
> +	if (likely(ops->release))
> +		ops->release(mdev);
>=20
>  	module_put(THIS_MODULE);
>  }
> @@ -56,11 +59,12 @@ static long vfio_mdev_unlocked_ioctl(void
> *device_data,  {
>  	struct mdev_device *mdev =3D device_data;
>  	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops =3D parent->ops->device_ops;
>=20
> -	if (unlikely(!parent->ops->ioctl))
> +	if (unlikely(!ops->ioctl))
>  		return -EINVAL;
>=20
> -	return parent->ops->ioctl(mdev, cmd, arg);
> +	return ops->ioctl(mdev, cmd, arg);
>  }
>=20
>  static ssize_t vfio_mdev_read(void *device_data, char __user *buf, @@ -6=
8,11
> +72,12 @@ static ssize_t vfio_mdev_read(void *device_data, char __user *b=
uf,
> {
>  	struct mdev_device *mdev =3D device_data;
>  	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops =3D parent->ops->device_ops;
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
, @@
> -80,22 +85,24 @@ static ssize_t vfio_mdev_write(void *device_data, const =
char
> __user *buf,  {
>  	struct mdev_device *mdev =3D device_data;
>  	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops =3D parent->ops->device_ops;
>=20
> -	if (unlikely(!parent->ops->write))
> +	if (unlikely(!ops->write))
>  		return -EINVAL;
>=20
> -	return parent->ops->write(mdev, buf, count, ppos);
> +	return ops->write(mdev, buf, count, ppos);
>  }
>=20
>  static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)=
  {
>  	struct mdev_device *mdev =3D device_data;
>  	struct mdev_parent *parent =3D mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops =3D parent->ops->device_ops;
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
> 3ebae310f599..fa167bcb81e1 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -48,30 +48,8 @@ struct device *mdev_get_iommu_device(struct device
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
> + * @device_ops:         Device specific emulation callback.
> + *
>   * Parent device that support mediated device should be registered with =
mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -83,15 +61,7 @@ struct mdev_parent_ops {
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
> +	const void *device_ops;
>  };
>=20
>  /* interface for exporting mdev supported type attributes */ diff --git
> a/include/linux/vfio_mdev.h b/include/linux/vfio_mdev.h new file mode
> 100644 index 000000000000..0c1b34f98f5d
> --- /dev/null
> +++ b/include/linux/vfio_mdev.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * VFIO Mediated device definition
> + */
> +
> +#ifndef VFIO_MDEV_H
> +#define VFIO_MDEV_H
> +
> +#include <linux/types.h>
> +#include <linux/mdev.h>
> +
> +/**
> + * struct vfio_mdev_parent_ops - Structure to be registered for each
> + * parent device to register the device to vfio-mdev module.
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
> +struct vfio_mdev_parent_ops {
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
> 71a4469be85d..107cc30d0f45 100644
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
> @@ -1418,12 +1419,7 @@ static struct attribute_group *mdev_type_groups[]
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
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops =3D {
>  	.open			=3D mbochs_open,
>  	.release		=3D mbochs_close,
>  	.read			=3D mbochs_read,
> @@ -1432,6 +1428,15 @@ static const struct mdev_parent_ops mdev_fops =3D =
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
> +	.device_ops		=3D &vfio_mdev_ops,
> +};
> +
>  static const struct file_operations vd_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c index
> d3029dd27d91..2cd2018a53f9 100644
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
> @@ -725,12 +726,7 @@ static struct attribute_group *mdev_type_groups[] =
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
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops =3D {
>  	.open			=3D mdpy_open,
>  	.release		=3D mdpy_close,
>  	.read			=3D mdpy_read,
> @@ -739,6 +735,15 @@ static const struct mdev_parent_ops mdev_fops =3D {
>  	.mmap			=3D mdpy_mmap,
>  };
>=20
> +static const struct mdev_parent_ops mdev_fops =3D {
> +	.owner			=3D THIS_MODULE,
> +	.mdev_attr_groups	=3D mdev_dev_groups,
> +	.supported_type_groups	=3D mdev_type_groups,
> +	.create			=3D mdpy_create,
> +	.remove			=3D mdpy_remove,
> +	.device_ops		=3D &vfio_mdev_ops,
> +};
> +
>  static const struct file_operations vd_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c index
> 744c88a6b22c..e427425b5daf 100644
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
> @@ -1410,6 +1411,14 @@ static struct attribute_group *mdev_type_groups[]
> =3D {
>  	NULL,
>  };
>=20
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops =3D {
> +	.open                   =3D mtty_open,
> +	.release                =3D mtty_close,
> +	.read                   =3D mtty_read,
> +	.write                  =3D mtty_write,
> +	.ioctl		        =3D mtty_ioctl,
> +};
> +
>  static const struct mdev_parent_ops mdev_fops =3D {
>  	.owner                  =3D THIS_MODULE,
>  	.dev_attr_groups        =3D mtty_dev_groups,
> @@ -1417,11 +1426,7 @@ static const struct mdev_parent_ops mdev_fops =3D =
{
>  	.supported_type_groups  =3D mdev_type_groups,
>  	.create                 =3D mtty_create,
>  	.remove			=3D mtty_remove,
> -	.open                   =3D mtty_open,
> -	.release                =3D mtty_close,
> -	.read                   =3D mtty_read,
> -	.write                  =3D mtty_write,
> -	.ioctl		        =3D mtty_ioctl,
> +	.device_ops             =3D &vfio_mdev_ops,
>  };
>=20
>  static void mtty_device_release(struct device *dev)
> --
> 2.19.1

