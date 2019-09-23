Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA60BBD74
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 22:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502870AbfIWU6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 16:58:30 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:24428
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388316AbfIWU63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 16:58:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpxpcjCGsZddb4pfUxQ64HjsegxjeJI6meT3RDZZ/nScFKB+d3yeSIFBlbtRWjHDa8PZt8BRq4iP3nr6/NftXxj3cTxV8rSp/GGPir/DBkqoSszo7Mv+w/tqtNXTypgdK3CQgXnstbCYJwXKKiIq3uBFC9svOhkwq9aVc8vwzBSSXqSoREbthNbnksIwI/MzNU0PkV+QdjtgSG2WvwukFLtH41FfrjnRViI7zNEwzpLeJNgXzTwmJSwPafN3mbGXCPL8h5JW/nYlBXqNcCs2XH9n52bu1OiC0HM4se7RKFY+V7SfCuLi6fdHmeHjN8gb5ZjtlODx2CT4cQqgP4ZP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVkxhu9tUp5nHccp4sKhb0inq7nf7MQbQRZIFYmlb68=;
 b=IcLAtsIfDxAvg0a6w/qnBBoASmiFQwj3lIng+84X9Ela1eGuMU0coubER6GrrBGIaDlwRceNTGMG5+Q0reRY43QrgSWpHYITlW1s5cZeqzXrFXS70Bvhd0wsridp+QpxuPQ54Awvc2H0FYUlVTBodI4itzqnYcQrJgUqTrtMfSLmG8WKc+7Xud8ZLT++TUlbFpV85rmMQmCdQZzLWWo2wKj0d7/8P4xr8LrmofbXhWOx3a6gdT1Es/YuNVxbKVuFddRRWt3CRmAW6Wx5bMRSCtZyPSFeZkgJ7bG4XquzeZXKdi9Q455mLPXwiJndgX9apmhJ+zOukjoxGnHptxEJnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVkxhu9tUp5nHccp4sKhb0inq7nf7MQbQRZIFYmlb68=;
 b=nRc/OTL0MnK9r5aSP+HKfiXiDqoh7ukKWWNbmCBmgfX81QRizLep9SsHuu6Hlo1UVlZ5EdKxs/ypvnbLLKqSFCc1/5cDaJkIgaHkxkRGDGd3dEWq3Qu5cRw94vvF2XffXiUPeXxiSNiyxug4AEkLBMSnJpi801y0BCrVImmKsnk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5153.eurprd05.prod.outlook.com (20.178.19.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Mon, 23 Sep 2019 20:58:08 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 20:58:08 +0000
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
Subject: RE: [PATCH 1/6] mdev: class id support
Thread-Topic: [PATCH 1/6] mdev: class id support
Thread-Index: AQHVcg9tP+s325DFukm8x3s6EiJzu6c5utWA
Date:   Mon, 23 Sep 2019 20:58:08 +0000
Message-ID: <AM0PR05MB486675D15C5C25F689BFB77AD1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-2-jasowang@redhat.com>
In-Reply-To: <20190923130331.29324-2-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5efd3656-321f-41de-ed33-08d74068bcf1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5153;
x-ms-traffictypediagnostic: AM0PR05MB5153:|AM0PR05MB5153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB515370B3093D0A66E3EE2372D1850@AM0PR05MB5153.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39850400004)(376002)(366004)(136003)(189003)(199004)(13464003)(66066001)(71190400001)(81166006)(6116002)(305945005)(2906002)(71200400001)(186003)(25786009)(54906003)(53546011)(33656002)(7696005)(66946007)(64756008)(11346002)(66556008)(76116006)(446003)(30864003)(478600001)(9686003)(74316002)(7736002)(6506007)(316002)(476003)(2501003)(52536014)(66446008)(486006)(7416002)(7406005)(76176011)(110136005)(5660300002)(86362001)(66476007)(8676002)(6246003)(55016002)(256004)(229853002)(14454004)(99286004)(3846002)(2201001)(81156014)(4326008)(26005)(8936002)(6436002)(102836004)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5153;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1PwdRqfR5AlyD7gwLxs15XkhwCi5V1RUZOhppKLDjhs93bYCsdO9aSlP32GRYRjf8XA4eei96iK17z4CTUcWf0tnyuSxYt+mc10NBAzsuSRj1fadqzVOWy5SZiOpQ4NUEa8Wb4cjWrOCqaSSjnmkcZQc4Sk3iGeiLK2aFA9lhlGFETzR1hoY0cuR7WD13Nyo/avE+Uf+kCleNctZzsbh2sLkrxnDhnMJaDXR39UUgRBRo9ubAKWd/Ar0ZqD0Uo9T8H4RIVSnmst9z7rBtCDU0WB2/Yb+AmI/TFjHZW9yYBio4+Pin2x4oPQPMYuVIRV+hU63se993pcMuBOgAzmDHEwUiN8L2TpEMi8ig1DKjSlfVcXX95xim0PXVF58k3xy69wwmL7tDs71XG5CUo03JQE3d3lRpIMzrBP/2KtByCM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5efd3656-321f-41de-ed33-08d74068bcf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 20:58:08.4713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPV8qC+QTk8wojesZ7IYRalDiyckxFywafjiJhp++BeMkd2hoQAqgh4SkziHoV/kkXSgxDZYCLgN4UkYNKH8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

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
> Subject: [PATCH 1/6] mdev: class id support
>=20
> Mdev bus only supports vfio driver right now, so it doesn't implement mat=
ch
> method. But in the future, we may add drivers other than vfio, one exampl=
e is
> virtio-mdev[1] driver. This means we need to add device class id support =
in bus
> match method to pair the mdev device and mdev driver correctly.
>=20
> So this patch adds id_table to mdev_driver and class_id for mdev parent w=
ith
> the match method for mdev bus.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst |  7 +++++--
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  2 +-
>  drivers/s390/cio/vfio_ccw_ops.c                   |  2 +-
>  drivers/s390/crypto/vfio_ap_ops.c                 |  3 ++-
>  drivers/vfio/mdev/mdev_core.c                     | 14 ++++++++++++--
>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>  include/linux/mdev.h                              |  7 ++++++-
>  include/linux/mod_devicetable.h                   |  8 ++++++++
>  samples/vfio-mdev/mbochs.c                        |  2 +-
>  samples/vfio-mdev/mdpy.c                          |  2 +-
>  samples/vfio-mdev/mtty.c                          |  2 +-
>  13 files changed, 59 insertions(+), 11 deletions(-)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..0e052072e1d8 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -102,12 +102,14 @@ structure to represent a mediated device's driver::
>        * @probe: called when new device created
>        * @remove: called when device removed
>        * @driver: device driver structure
> +      * @id_table: the ids serviced by this driver.
No full stop at the end.

>        */
>       struct mdev_driver {
>  	     const char *name;
>  	     int  (*probe)  (struct device *dev);
>  	     void (*remove) (struct device *dev);
>  	     struct device_driver    driver;
> +	     const struct mdev_class_id *id_table;
>       };
>=20
>  A mediated bus driver for mdev should use this structure in the function=
 calls
> @@ -116,7 +118,7 @@ to register and unregister itself with the core drive=
r:
>  * Register::
>=20
>      extern int  mdev_register_driver(struct mdev_driver *drv,
> -				   struct module *owner);
> +                                     struct module *owner);
>=20
Unrelated change in this patch.

>  * Unregister::
>=20
> @@ -163,7 +165,8 @@ A driver should use the mdev_parent_ops structure in
> the function call to  register itself with the mdev core driver::
>=20
>  	extern int  mdev_register_device(struct device *dev,
> -	                                 const struct mdev_parent_ops *ops);
> +	                                 const struct mdev_parent_ops *ops,
> +	                                 u8 class_id);
>=20
Cover letter from Change-V2 says that it class_id changed from " use u16 in=
stead u8 for class id"
But it is still u8 here?

>  However, the mdev_parent_ops structure is not required in the function c=
all
> that a driver should use to unregister itself with the mdev core driver::
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 23aa3e50cbf8..19d51a35f019 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1625,7 +1625,7 @@ static int kvmgt_host_init(struct device *dev, void
> *gvt, const void *ops)
>  		return -EFAULT;
>  	intel_vgpu_ops.supported_type_groups =3D kvm_vgpu_type_groups;
>=20
> -	return mdev_register_device(dev, &intel_vgpu_ops);
> +	return mdev_register_vfio_device(dev, &intel_vgpu_ops);
>  }
>=20
>  static void kvmgt_host_exit(struct device *dev) diff --git
> a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c index
> f0d71ab77c50..246ff0f80944 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -588,7 +588,7 @@ static const struct mdev_parent_ops
> vfio_ccw_mdev_ops =3D {
>=20
>  int vfio_ccw_mdev_reg(struct subchannel *sch)  {
> -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
> +	return mdev_register_vfio_device(&sch->dev, &vfio_ccw_mdev_ops);
>  }
>=20
>  void vfio_ccw_mdev_unreg(struct subchannel *sch) diff --git
> a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 5c0f53c6dde7..7487fc39d2c5 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1295,7 +1295,8 @@ int vfio_ap_mdev_register(void)  {
>  	atomic_set(&matrix_dev->available_instances,
> MAX_ZDEV_ENTRIES_EXT);
>=20
> -	return mdev_register_device(&matrix_dev->device,
> &vfio_ap_matrix_ops);
> +	return mdev_register_vfio_device(&matrix_dev->device,
> +					 &vfio_ap_matrix_ops);
>  }
>=20
>  void vfio_ap_mdev_unregister(void)
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index b558d4cfd082..a02c256a3514 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -135,11 +135,14 @@ static int mdev_device_remove_cb(struct device
> *dev, void *data)
>   * mdev_register_device : Register a device
>   * @dev: device structure representing parent device.
>   * @ops: Parent device operation structure to be registered.
> + * @id: device id.
>   *
It device id here, but in below its class_id. Please make them uniform.

>   * Add device to list of registered parent devices.
>   * Returns a negative value on error, otherwise 0.
>   */
> -int mdev_register_device(struct device *dev, const struct mdev_parent_op=
s
> *ops)
> +int mdev_register_device(struct device *dev,
> +			 const struct mdev_parent_ops *ops,
> +			 u8 class_id)
>  {
u16 class_id?

>  	int ret;
>  	struct mdev_parent *parent;
> @@ -175,6 +178,7 @@ int mdev_register_device(struct device *dev, const
> struct mdev_parent_ops *ops)
>=20
>  	parent->dev =3D dev;
>  	parent->ops =3D ops;
> +	parent->class_id =3D class_id;
>=20
>  	if (!mdev_bus_compat_class) {
>  		mdev_bus_compat_class =3D
> class_compat_register("mdev_bus");
> @@ -208,7 +212,13 @@ int mdev_register_device(struct device *dev, const
> struct mdev_parent_ops *ops)
>  		put_device(dev);
>  	return ret;
>  }
> -EXPORT_SYMBOL(mdev_register_device);
> +
> +int mdev_register_vfio_device(struct device *dev,
> +			      const struct mdev_parent_ops *ops) {
> +	return mdev_register_device(dev, ops, MDEV_ID_VFIO); }
> +EXPORT_SYMBOL(mdev_register_vfio_device);
>=20
>  /*
>   * mdev_unregister_device : Unregister a parent device diff --git
> a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c index
> 0d3223aee20b..b70bbebc9dd3 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -69,8 +69,22 @@ static int mdev_remove(struct device *dev)
>  	return 0;
>  }
>=20
> +static int mdev_match(struct device *dev, struct device_driver *drv) {
> +	unsigned int i;
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
> +	struct mdev_driver *mdrv =3D to_mdev_driver(drv);
> +	const struct mdev_class_id *ids =3D mdrv->id_table;
> +
> +	for (i =3D 0; ids[i].id; i++)
> +		if (ids[i].id =3D=3D mdev->parent->class_id)
> +			return 1;
> +	return 0;
> +}
> +
>  struct bus_type mdev_bus_type =3D {
>  	.name		=3D "mdev",
> +	.match		=3D mdev_match,
>  	.probe		=3D mdev_probe,
>  	.remove		=3D mdev_remove,
>  };
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf..e58b07c866b1 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -22,6 +22,7 @@ struct mdev_parent {
>  	struct list_head type_list;
>  	/* Synchronize device creation/removal with parent unregistration */
>  	struct rw_semaphore unreg_sem;
> +	u8 class_id;
>  };
>=20
>  struct mdev_device {
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index 30964a4e0a28..fd2a4d9a3f26 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -120,10 +120,16 @@ static void vfio_mdev_remove(struct device *dev)
>  	vfio_del_group_dev(dev);
>  }
>=20
> +static struct mdev_class_id id_table[] =3D {
> +	{ MDEV_ID_VFIO },
> +	{ 0 },
> +};
> +
>  static struct mdev_driver vfio_mdev_driver =3D {
>  	.name	=3D "vfio_mdev",
>  	.probe	=3D vfio_mdev_probe,
>  	.remove	=3D vfio_mdev_remove,
> +	.id_table =3D id_table,
>  };
>=20
>  static int __init vfio_mdev_init(void)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h index
> 0ce30ca78db0..3ebae310f599 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -118,6 +118,7 @@ struct mdev_type_attribute mdev_type_attr_##_name
> =3D		\
>   * @probe: called when new device created
>   * @remove: called when device removed
>   * @driver: device driver structure
> + * @id_table: the ids serviced by this driver.
>   *
>   **/
>  struct mdev_driver {
> @@ -125,6 +126,7 @@ struct mdev_driver {
>  	int  (*probe)(struct device *dev);
>  	void (*remove)(struct device *dev);
>  	struct device_driver driver;
> +	const struct mdev_class_id *id_table;
>  };
>=20
>  #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver=
)
> @@ -135,7 +137,8 @@ const guid_t *mdev_uuid(struct mdev_device *mdev);
>=20
>  extern struct bus_type mdev_bus_type;
>=20
> -int mdev_register_device(struct device *dev, const struct mdev_parent_op=
s
> *ops);
> +int mdev_register_vfio_device(struct device *dev,
> +			      const struct mdev_parent_ops *ops);
>  void mdev_unregister_device(struct device *dev);
>=20
>  int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
> @@ -145,4 +148,6 @@ struct device *mdev_parent_dev(struct mdev_device
> *mdev);  struct device *mdev_dev(struct mdev_device *mdev);  struct
> mdev_device *mdev_from_dev(struct device *dev);
>=20
> +#define MDEV_ID_VFIO 1 /* VFIO device */
> +
Instead of define, please put them as enum=20

enum mdev_class/device_id {
	MDEV_ID_VFIO =3D 1,
	/* New entries must be added here */
};

>  #endif /* MDEV_H */
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_deviceta=
ble.h
> index 5714fd35a83c..f32c6e44fb1a 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -821,4 +821,12 @@ struct wmi_device_id {
>  	const void *context;
>  };
>=20
> +/**
> + * struct mdev_class_id - MDEV device class identifier
> + * @id: Used to identify a specific class of device, e.g vfio-mdev devic=
e.
> + */
> +struct mdev_class_id {
> +	__u16 id;
> +};
This is u16 as I guess you wanted as opposed to u8 in other places in patch=
.

> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c inde=
x
> ac5c8c17b1ff..71a4469be85d 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1468,7 +1468,7 @@ static int __init mbochs_dev_init(void)
>  	if (ret)
>  		goto failed2;
>=20
> -	ret =3D mdev_register_device(&mbochs_dev, &mdev_fops);
> +	ret =3D mdev_register_vfio_device(&mbochs_dev, &mdev_fops);
>  	if (ret)
>  		goto failed3;
>=20
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c index
> cc86bf6566e4..d3029dd27d91 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -775,7 +775,7 @@ static int __init mdpy_dev_init(void)
>  	if (ret)
>  		goto failed2;
>=20
> -	ret =3D mdev_register_device(&mdpy_dev, &mdev_fops);
> +	ret =3D mdev_register_vfio_device(&mdpy_dev, &mdev_fops);
>  	if (ret)
>  		goto failed3;
>=20
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c index
> 92e770a06ea2..744c88a6b22c 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1468,7 +1468,7 @@ static int __init mtty_dev_init(void)
>  	if (ret)
>  		goto failed2;
>=20
> -	ret =3D mdev_register_device(&mtty_dev.dev, &mdev_fops);
> +	ret =3D mdev_register_vfio_device(&mtty_dev.dev, &mdev_fops);
>  	if (ret)
>  		goto failed3;
>=20
> --
> 2.19.1

