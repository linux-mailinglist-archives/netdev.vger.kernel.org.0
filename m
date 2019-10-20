Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2365FDE121
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 01:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJTXZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 19:25:22 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:10723
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbfJTXZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 19:25:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQtm8DT0e+HeYuU1HtcWLul6qRsbNauplBStxxxJ01V/ria4K6cSm8rh/5xh1co3rWax3zKDUBTkr78ETYJCkM0KHibulGNIzCToELfEY27V1P5QBuuOIfgL1F3ijVIS0Bs4QfHaurVc1d5QDaahpCRk5E8Oyl2Rs1CByuknEItT3WOOfFxYSEeNTP0tLcXBgEZCWkS2DzaibZP0joW0n+crSNziONHaA5SeoCcT8AiNPuoOTPDR7fPmBGpZdCpWg7FysC57qrLe/s/7iATKDbtwAnLEwNe8Ipf1ek/KQxy3IQS2ouNKCiAEMhw6kZSrIR8Qsw0HkbH1VFSRjJdWdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cBWo6NICT4O2SuiroqHIGJx5UkHaMiyCusr2VQx5nY=;
 b=KNMHP1UHhSvDIOL+8xPYmWqJmcd257LjUZnPUuoKSuLVaJmOPUrr7GI0+RFsLm9xpTtLokmB0eRd5iifRfzAJG0Tsglinw2EE4d48889GReNa9OpnqfDBs2ES5bqXIeJD564nW/ID7elZ09RGbK+DVm+Gp4L9SMTgpCWlhl1V8mElmabuejABH5B0PrVx20jv1TLcbbcfJf8ipupBJ6g0zkOX9SGlex08Xut8aoPl62cVCM2j9G+TbARRWcjzaT75A7v2ErwDx9leVkRHt1Zg8C0BvJYOUbHENPsKFheeB4NQLy2rmcGU4fjXFY0sQ+Y16ba0AjoaOo/hBnRy5MeZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cBWo6NICT4O2SuiroqHIGJx5UkHaMiyCusr2VQx5nY=;
 b=YwJixZWmQkhP2Ps3xkJo1dmNFfCDnjHj5tQTxXPfh7gprLV4ZaPIe3BHsPBVOdKQgOV6RfYK/IrFwtCUWvAN8Z3x+HzF6GyrVdJy6gbKyXRskZap1eiGePFw7xexrPvGqQbacYKt+Hl2/GmEezfdAhi1xYUlJmswtfti2F2OnLE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4690.eurprd05.prod.outlook.com (52.133.55.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Sun, 20 Oct 2019 23:25:10 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2347.028; Sun, 20 Oct 2019
 23:25:10 +0000
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
Subject: RE: [PATCH V4 1/6] mdev: class id support
Thread-Topic: [PATCH V4 1/6] mdev: class id support
Thread-Index: AQHVhNihA4sP4YVmsUyna1D6ZbH+RadkMX5A
Date:   Sun, 20 Oct 2019 23:25:10 +0000
Message-ID: <AM0PR05MB4866949E4E7C9F3FDB65EF40D16E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
 <20191017104836.32464-2-jasowang@redhat.com>
In-Reply-To: <20191017104836.32464-2-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:4571:4eb1:2e3a:4d72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4b4b11c-1cc7-45bd-f223-08d755b4c020
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM0PR05MB4690:|AM0PR05MB4690:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4690FDCE6A88F22B0C1CA4F2D16E0@AM0PR05MB4690.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0196A226D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(39850400004)(366004)(13464003)(199004)(189003)(86362001)(14454004)(33656002)(55016002)(2201001)(446003)(476003)(256004)(14444005)(7406005)(316002)(7416002)(478600001)(11346002)(229853002)(486006)(9686003)(6436002)(74316002)(7736002)(305945005)(2501003)(110136005)(54906003)(71190400001)(71200400001)(5660300002)(102836004)(6506007)(53546011)(6116002)(66946007)(99286004)(30864003)(8936002)(76176011)(7696005)(8676002)(25786009)(66556008)(46003)(52536014)(64756008)(66446008)(186003)(4326008)(66476007)(81166006)(6246003)(81156014)(2906002)(76116006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4690;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F8gtjOJ4zhBweDPnEw29HxvdG7vPNXoOKNZPs3dOWt2p9bJQIAy5W3inWjsxq6m/UQzvnwTx1ic2RgaeFU0zl/Oug8XPSxuTpLdoJy3/onV+Hut2PJdI2HJMfZtQZnKKHEjNEkCDD7SCezT1sskOWasgMGWFabqstA1PXvGf8j8bcIZT+1ZkyjZtQS3fj2ZTKPk0mwmeF/YScrHOZjfREYCKeVv0yzSnMq7z2we78y9faeZIZYygv5/cCKfUVbDBOYpw4LnjsVxPwE5+7NuKrNIHlzYMGhJxxyN9gqk73csGecqhfh6jlA4mzTBx9GQH8+fOwBjCMAjEjDxUvdaO98QNwW+KvMjcrgsNphv+L5CGIl4hnkG+A8x9qk8VGGJ5xlD+JkXMBHNsbB1N1LfKBqgfNzFbSOni38C/hufQpCM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b4b11c-1cc7-45bd-f223-08d755b4c020
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2019 23:25:10.0304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZNNadezaomdJSH9LF6l2ch+fBjIKnsf1jklagZV6encAa3UZNJTulZOQDC3hDPTuZSAp/iqipEbMFFHQx0alLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4690
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Jason Wang
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
> Subject: [PATCH V4 1/6] mdev: class id support
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
>  .../driver-api/vfio-mediated-device.rst       |  7 +++++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  1 +
>  drivers/s390/cio/vfio_ccw_ops.c               |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c             |  1 +
>  drivers/vfio/mdev/mdev_core.c                 | 18 +++++++++++++++
>  drivers/vfio/mdev/mdev_driver.c               | 22 +++++++++++++++++++
>  drivers/vfio/mdev/mdev_private.h              |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                 |  6 +++++
>  include/linux/mdev.h                          |  8 +++++++
>  include/linux/mod_devicetable.h               |  8 +++++++
>  samples/vfio-mdev/mbochs.c                    |  1 +
>  samples/vfio-mdev/mdpy.c                      |  1 +
>  samples/vfio-mdev/mtty.c                      |  1 +
>  13 files changed, 75 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..f9a78d75a67a 100644
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
> +It is also required to specify the class_id in create() callback through=
::
> +
> +	int mdev_set_class(struct mdev_device *mdev, u16 id);
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
> index 343d79c1cb7e..6420f0dbd31b 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -678,6 +678,7 @@ static int intel_vgpu_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  		     dev_name(mdev_dev(mdev)));
>  	ret =3D 0;
>=20
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  out:
>  	return ret;
>  }
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c index f0d71ab77c50..cf2c013ae32f 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -129,6 +129,7 @@ static int vfio_ccw_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  			   private->sch->schid.ssid,
>  			   private->sch->schid.sch_no);
>=20
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  	return 0;
>  }
>=20
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 5c0f53c6dde7..07c31070afeb 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -343,6 +343,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>  	mutex_unlock(&matrix_dev->lock);
>=20
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  	return 0;
>  }
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index b558d4cfd082..3a9c52d71b4e 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,6 +45,16 @@ void mdev_set_drvdata(struct mdev_device *mdev,
> void *data)  }  EXPORT_SYMBOL(mdev_set_drvdata);
>=20
> +/* Specify the class for the mdev device, this must be called during
> + * create() callback.
> + */
> +void mdev_set_class(struct mdev_device *mdev, u16 id) {
> +	WARN_ON(mdev->class_id);
> +	mdev->class_id =3D id;
> +}
> +EXPORT_SYMBOL(mdev_set_class);
> +
>  struct device *mdev_dev(struct mdev_device *mdev)  {
>  	return &mdev->dev;
> @@ -135,6 +145,7 @@ static int mdev_device_remove_cb(struct device
> *dev, void *data)
>   * mdev_register_device : Register a device
>   * @dev: device structure representing parent device.
>   * @ops: Parent device operation structure to be registered.
> + * @id: class id.
>   *
>   * Add device to list of registered parent devices.
>   * Returns a negative value on error, otherwise 0.
> @@ -324,6 +335,13 @@ int mdev_device_create(struct kobject *kobj,
>  	if (ret)
>  		goto ops_create_fail;
>=20
> +	if (!mdev->class_id) {
> +		ret =3D -EINVAL;
> +		WARN(1, "class id must be specified for device %s\n",
> +		     dev_name(dev));
> +		goto add_fail;
> +	}
> +
>  	ret =3D device_add(&mdev->dev);
>  	if (ret)
>  		goto add_fail;
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c index 0d3223aee20b..319d886ffaf7
> 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -69,8 +69,30 @@ static int mdev_remove(struct device *dev)
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
> +static int mdev_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
> +
> +	return add_uevent_var(env, "MODALIAS=3Dmdev:c%02X", mdev-
> >class_id); }
> +
>  struct bus_type mdev_bus_type =3D {
>  	.name		=3D "mdev",
> +	.match		=3D mdev_match,
> +	.uevent		=3D mdev_uevent,
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
> index 30964a4e0a28..7b24ee9cb8dd 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -120,10 +120,16 @@ static void vfio_mdev_remove(struct device *dev)
>  	vfio_del_group_dev(dev);
>  }
>=20
> +static const struct mdev_class_id id_table[] =3D {
> +	{ MDEV_CLASS_ID_VFIO },
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
> 0ce30ca78db0..78b69d09eb54 100644
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
> @@ -125,6 +126,7 @@ struct mdev_driver {
>  	int  (*probe)(struct device *dev);
>  	void (*remove)(struct device *dev);
>  	struct device_driver driver;
> +	const struct mdev_class_id *id_table;
>  };
>=20
>  #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver=
)
> @@ -132,6 +134,7 @@ struct mdev_driver {  void *mdev_get_drvdata(struct
> mdev_device *mdev);  void mdev_set_drvdata(struct mdev_device *mdev,
> void *data);  const guid_t *mdev_uuid(struct mdev_device *mdev);
> +void mdev_set_class(struct mdev_device *mdev, u16 id);
>=20
>  extern struct bus_type mdev_bus_type;
>=20
> @@ -145,4 +148,9 @@ struct device *mdev_parent_dev(struct mdev_device
> *mdev);  struct device *mdev_dev(struct mdev_device *mdev);  struct
> mdev_device *mdev_from_dev(struct device *dev);
>=20
> +enum {
> +	MDEV_CLASS_ID_VFIO =3D 1,
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
> index ac5c8c17b1ff..115bc5074656 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -561,6 +561,7 @@ static int mbochs_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mbochs_reset(mdev);
>=20
>  	mbochs_used_mbytes +=3D type->mbytes;
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  	return 0;
>=20
>  err_mem:
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c index
> cc86bf6566e4..665614574d50 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -269,6 +269,7 @@ static int mdpy_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mdpy_reset(mdev);
>=20
>  	mdpy_count++;
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  	return 0;
>  }
>=20
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c index
> ce84a300a4da..90da12ff7fd9 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -755,6 +755,7 @@ static int mtty_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	list_add(&mdev_state->next, &mdev_devices_list);
>  	mutex_unlock(&mdev_list_lock);
>=20
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  	return 0;
>  }
>=20
> --
> 2.19.1
Reviewed-by: Parav Pandit <parav@mellanox.com>

