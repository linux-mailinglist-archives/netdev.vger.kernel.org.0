Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2279D87AD
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 06:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391202AbfJPE5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 00:57:42 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:61253
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389668AbfJPE5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 00:57:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8T+CucBvoMNf/m3ur74RAwG0fkYkcW4vUFSYCvt6Z2r2J0aQeNphtvAEoaJjV5DZNYutXbTnxXQQyGzpINCVXQuc2liEYhLYsULwIv9DWRxF3aC6nyJYo7W3ki/ibE/9nxyWd8Su4WGZRTFGqZ5dL4dODAgVFFuuvi51Rb4ZitTHCEY9WpYfFOQJVgcln0jLSjnj+ok83nwRtSYcTBZicFOLR5QOZYZJ+RjlXp/RUlmXPw2G3U++2roazsZxlrRr/F2ZN/QOTkQ431HJ6LkJIJFYT+oQX0DhjfRQQICiZmdWL1OZyJWwV2f5QJXlaTANbP89xV6UFXVeWR13EiJEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FXkPJj6OxM6yPdNXA82P9xYlCgOuPdCwJjHChnm5Os=;
 b=MSLRkDvd1iR2uIgKOk0RGXskYJX2F3itMRlkfYFcnsEhKBVHv3HouKs3mGneLqCwPJxtdCIeC9y/75AOGVyDw/WBtrsp+fqWmatFbvHv6FWRGVbJ/bC9UtU4QrMNSjMBzuACaaSTQ67g1aK2utzCeHmI5jLWqYqgKF2LaB9JYKyXzp5peQbvQ/1XDwDLXelIaOcd7e4PcLKpyWGRwyZrcHmouu/G9jy9C1EKexCuuWQVapF7HrUHk8mKytjXjhJvAsaQAcIrcUHKGxAgxyfHodQTADemTxEXwXZD9NIOc7Ld77zeA59cjQDAgUOONj15GQ3xC9cQc0LLhJ1c+M9hJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FXkPJj6OxM6yPdNXA82P9xYlCgOuPdCwJjHChnm5Os=;
 b=qW9oWsnKTBf8XEWH3rAZydje1W99F4vYK0Jbhy3qAwDRTIMsb+lltyh3up+MXtZcMb98bIlCTv9TDD85cHfr9Ne9HuRRyIgt/gc929N45kzCbKsUW2MoPS4l6k0gNYnfaU2T1xV+A41oZiZj62n1MXLWvwds9b9jQSII9nN8IKM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5122.eurprd05.prod.outlook.com (20.178.17.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Wed, 16 Oct 2019 04:57:31 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2347.021; Wed, 16 Oct 2019
 04:57:31 +0000
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
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH V3 1/7] mdev: class id support
Thread-Topic: [PATCH V3 1/7] mdev: class id support
Thread-Index: AQHVgAxcSI5DY7xDNkGCgUewSafrf6dcuKbA
Date:   Wed, 16 Oct 2019 04:57:31 +0000
Message-ID: <AM0PR05MB4866481AEE614FDF766C6A25D1920@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191011081557.28302-2-jasowang@redhat.com>
In-Reply-To: <20191011081557.28302-2-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:8ddb:1e36:fbf6:de3d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48113fa1-88bb-490c-f466-08d751f559d3
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM0PR05MB5122:|AM0PR05MB5122:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5122077330D0185044C64A73D1920@AM0PR05MB5122.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(199004)(189003)(13464003)(14444005)(71200400001)(476003)(446003)(71190400001)(6506007)(4326008)(256004)(11346002)(186003)(102836004)(86362001)(64756008)(66476007)(316002)(66946007)(66446008)(53546011)(66556008)(76176011)(2501003)(30864003)(9686003)(55016002)(76116006)(7696005)(46003)(6116002)(229853002)(25786009)(5660300002)(7416002)(52536014)(2906002)(81156014)(7406005)(305945005)(7736002)(74316002)(8676002)(54906003)(99286004)(486006)(6246003)(110136005)(33656002)(478600001)(6436002)(8936002)(14454004)(2201001)(81166006)(921003)(1121003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5122;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9uNYv8NcOq1sBjqofqjusCJkx8b0KvwviYL448oWjSQ7oB67PapP/KbNi87z9qU6e754ykdJ2Jb/mJywQaZ1Zpd+FpkKoDNbB1K5nzb4Ur5K2gkn6WSEtOMiKZ4LczAqZfVmQ8oMBbQIvQdDl86vsJqUYfIHLg8tQ8TlLXRAiCPDRPVx+dRxKtcw/qr8Kp8+907MrsqaguZqR193+yKfU7EKJfoSbp5djWFGi8zMQUDjzsZW+FO4UozeDZieOJNEMLtf6bX3mFOEFZg6P1N+RGt5mdiE7IUg71pB7GFAz+f6TsTGPaiuwnOr31YqkN1B9YwWHr4AFUhjczRvkqk2kqEFr4hv66NzrMX4CRZqMoM+VQnvJNIxvgPpN0+VzqU6s/Mxl8iqEmCROX5zOJ0eRRZ8cRwE1FwuSrOHdTZaSCs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48113fa1-88bb-490c-f466-08d751f559d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 04:57:31.0775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: occQrHPjEEQLfCnEYaWHOJX0mTJZNiWy/hiKv/cbEO3Z/6DWsQlqmQY9aPOIzHHvYj/tK8OHWJnUL+GJICDg3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Friday, October 11, 2019 3:16 AM
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
> kevin.tian@intel.com; Jason Wang <jasowang@redhat.com>
> Subject: [PATCH V3 1/7] mdev: class id support
>=20
> Mdev bus only supports vfio driver right now, so it doesn't implement mat=
ch
> method. But in the future, we may add drivers other than vfio, the first
> driver could be virtio-mdev. This means we need to add device class id
> support in bus match method to pair the mdev device and mdev driver
> correctly.
>=20
> So this patch adds id_table to mdev_driver and class_id for mdev device
> with the match method for mdev bus.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst |  7 ++++++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  1 +
>  drivers/s390/cio/vfio_ccw_ops.c                   |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c                 |  1 +
>  drivers/vfio/mdev/mdev_core.c                     | 11 +++++++++++
>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>  include/linux/mdev.h                              |  8 ++++++++
>  include/linux/mod_devicetable.h                   |  8 ++++++++
>  samples/vfio-mdev/mbochs.c                        |  1 +
>  samples/vfio-mdev/mdpy.c                          |  1 +
>  samples/vfio-mdev/mtty.c                          |  1 +
>  13 files changed, 60 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..2035e48da7b2 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -102,12 +102,14 @@ structure to represent a mediated device's driver::
>        * @probe: called when new device created
>        * @remove: called when device removed
>        * @driver: device driver structure
> +      * @id_table: the ids serviced by this driver
>        */
>       struct mdev_driver {
>  	     const char *name;
>  	     int  (*probe)  (struct device *dev);
>  	     void (*remove) (struct device *dev);
>  	     struct device_driver    driver;
> +	     const struct mdev_class_id *id_table;
>       };
>=20
>  A mediated bus driver for mdev should use this structure in the function
> calls @@ -165,12 +167,15 @@ register itself with the mdev core driver::
>  	extern int  mdev_register_device(struct device *dev,
>  	                                 const struct mdev_parent_ops *ops);
>=20
> +It is also required to specify the class_id through::
> +
> +	extern int mdev_set_class(struct device *dev, u16 id);
Drop extern.
In actual API you have correct signature, i.e. struct mdev_device.
s/struct device/struct mdev_device.

> +
>  However, the mdev_parent_ops structure is not required in the function c=
all
> that a driver should use to unregister itself with the mdev core driver::
>=20
>  	extern void mdev_unregister_device(struct device *dev);
>=20
> -
>  Mediated Device Management Interface Through sysfs
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 343d79c1cb7e..17e9d4634c84 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -678,6 +678,7 @@ static int intel_vgpu_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  		     dev_name(mdev_dev(mdev)));
>  	ret =3D 0;
>=20
> +	mdev_set_class(mdev, MDEV_ID_VFIO);
>  out:
>  	return ret;
>  }
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c index f0d71ab77c50..b5d223882c6c
> 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -129,6 +129,7 @@ static int vfio_ccw_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  			   private->sch->schid.ssid,
>  			   private->sch->schid.sch_no);
>=20
> +	mdev_set_class(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
>=20
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 5c0f53c6dde7..47df1c593c35 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -343,6 +343,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>  	mutex_unlock(&matrix_dev->lock);
>=20
> +	mdev_set_class(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index b558d4cfd082..724e9b9841d8 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,6 +45,12 @@ void mdev_set_drvdata(struct mdev_device *mdev,
> void *data)  }  EXPORT_SYMBOL(mdev_set_drvdata);
>=20
> +void mdev_set_class(struct mdev_device *mdev, u16 id) {
> +	mdev->class_id =3D id;
> +}
> +EXPORT_SYMBOL(mdev_set_class);
> +
Usually with every exported symbol we have signature comment block that des=
cribes when to use an API etc.
Please add it that describes that this API must be called during create() c=
allback.

>  struct device *mdev_dev(struct mdev_device *mdev)  {
>  	return &mdev->dev;
> @@ -135,6 +141,7 @@ static int mdev_device_remove_cb(struct device
> *dev, void *data)
>   * mdev_register_device : Register a device
>   * @dev: device structure representing parent device.
>   * @ops: Parent device operation structure to be registered.
> + * @id: class id.
>   *
>   * Add device to list of registered parent devices.
>   * Returns a negative value on error, otherwise 0.
> @@ -324,6 +331,9 @@ int mdev_device_create(struct kobject *kobj,
>  	if (ret)
>  		goto ops_create_fail;
>=20
> +	if (!mdev->class_id)
> +		goto class_id_fail;
> +
>  	ret =3D device_add(&mdev->dev);
>  	if (ret)
>  		goto add_fail;
> @@ -340,6 +350,7 @@ int mdev_device_create(struct kobject *kobj,
>=20
>  sysfs_fail:
>  	device_del(&mdev->dev);
> +class_id_fail:
No need for new label. Just use add_fail label.

>  add_fail:
>  	parent->ops->remove(mdev);
>  ops_create_fail:
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c index 0d3223aee20b..b7c40ce86ee3
> 100644
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
> +		if (ids[i].id =3D=3D mdev->class_id)
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
> index 7d922950caaf..c65f436c1869 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -33,6 +33,7 @@ struct mdev_device {
>  	struct kobject *type_kobj;
>  	struct device *iommu_device;
>  	bool active;
> +	u16 class_id;
>  };
>=20
>  #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
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
static const=20

> +	{ MDEV_ID_VFIO },
I guess you don't need extra braces for each entry.
Since this enum represents MDEV class id, it better to name it as MDEV_CLAS=
S_ID_VFIO.
(Similar to  PCI_VENDOR_ID, PCI_DEVICE_ID)..

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
> 0ce30ca78db0..a7570cf13ba4 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -118,6 +118,7 @@ struct mdev_type_attribute
> mdev_type_attr_##_name =3D		\
>   * @probe: called when new device created
>   * @remove: called when device removed
>   * @driver: device driver structure
> + * @id_table: the ids serviced by this driver
>   *
>   **/
>  struct mdev_driver {
> @@ -125,12 +126,14 @@ struct mdev_driver {
>  	int  (*probe)(struct device *dev);
>  	void (*remove)(struct device *dev);
>  	struct device_driver driver;
> +	const struct mdev_class_id *id_table;
>  };
>=20
>  #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver=
)
>=20
>  void *mdev_get_drvdata(struct mdev_device *mdev);  void
> mdev_set_drvdata(struct mdev_device *mdev, void *data);
> +void mdev_set_class(struct mdev_device *mdev, u16 id);
Better to insert new API after mdev_uuid().

>  const guid_t *mdev_uuid(struct mdev_device *mdev);
>=20
>  extern struct bus_type mdev_bus_type;
> @@ -145,4 +148,9 @@ struct device *mdev_parent_dev(struct mdev_device
> *mdev);  struct device *mdev_dev(struct mdev_device *mdev);  struct
> mdev_device *mdev_from_dev(struct device *dev);
>=20
> +enum {
> +	MDEV_ID_VFIO =3D 1,
> +	/* New entries must be added here */
> +};
> +
>  #endif /* MDEV_H */
> diff --git a/include/linux/mod_devicetable.h
> b/include/linux/mod_devicetable.h index 5714fd35a83c..f32c6e44fb1a
> 100644
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
> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index ac5c8c17b1ff..fd8491e58fe2 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -561,6 +561,7 @@ static int mbochs_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mbochs_reset(mdev);
>=20
>  	mbochs_used_mbytes +=3D type->mbytes;
> +	mdev_set_class(mdev, MDEV_ID_VFIO);
>  	return 0;
>=20
>  err_mem:
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c index
> cc86bf6566e4..889472b06708 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -269,6 +269,7 @@ static int mdpy_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mdpy_reset(mdev);
>=20
>  	mdpy_count++;
> +	mdev_set_class(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
>=20
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c index
> ce84a300a4da..618810ca4331 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -755,6 +755,7 @@ static int mtty_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	list_add(&mdev_state->next, &mdev_devices_list);
>  	mutex_unlock(&mdev_list_lock);
>=20
> +	mdev_set_class(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
>=20
> --
> 2.19.1

