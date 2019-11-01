Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F04EC947
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 20:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKATzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 15:55:19 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:46337
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfKATzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 15:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFMorDuJeF0BjXmCiXsnNGQkq/+Q9n35U6eZUteEcuR35czKu2N6LW6TnbXl386n7bXFUJngUEoI2Ckk0wxt5o7T7IPo2iqWtg0yVqghAPaFxDO6C4F0WWhDRQz9+rNvAcUQZYHgY+BI7cOCPCmqEynM30OShMHNxnC1zWAfWjqX8Y87wWw0ekTfEsYepW7ZRUt3dsYNf+5KxJ1RLe7PMX8mNF0Oj1BK2cF+ombdwNgKy0p73ZEIQC24xoaJUhG4gloR4mNbrvSAIb1zZ2TYB0VbBbXBzjnBRsaG27F1omwkC+A9yf2XAlRVIdpAY6PNGICVVIxxA/IT/n9eRc0Idw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB3DTF5kN4EM4BulyxImLm/PczaCHSttekXKc8J1TP4=;
 b=Ps5prY6fU60yOKhcrTU+XiNn7JAtdh+KbyvIVeiv+WqWhdpXM/pmR1DNTSos9SAkXiCdC9gpLa0YjeA7PGWaJN++AytgJeMnroBRFa0ToIvGEC2MvsZhu3VhLxeQXS5tacFOz+iz5pVHAAW//gPPLtQBsljl4EwodXEQ0sOvcYYOe0rPz3vGsAv0jZ/VymY3MBwDuRbdkmcXeToS5Qf2w7NUygJjfJjJ6ngaX5ND3V766SN1T1CwU+K43U2az9sI0qtjA2v+YFEbmatolZIY55ko8O3bj6Udcpel82zCr4dljMucP0EpwEU7Wj+HsYrSaSU0KP85CLWx+usJwWqwug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB3DTF5kN4EM4BulyxImLm/PczaCHSttekXKc8J1TP4=;
 b=hrFsLAgcc9YPb9mYormx5l0cKSRUsJxUfGTmmYyPz1WtEpp8ZK91OESVvIesKgyFTgqoTv0AQDIIo4etiLQmLBC9yPCoSIJL6cqz/e3FDL6DzNFQLapBJ3TXYcSowc5lULhNEuJ2U771sDXTeAyUPeElCKILBaAG1+xMoiFCga8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6547.eurprd05.prod.outlook.com (20.179.33.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Fri, 1 Nov 2019 19:55:08 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 19:55:07 +0000
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
Subject: RE: [PATCH V6 1/6] mdev: class id support
Thread-Topic: [PATCH V6 1/6] mdev: class id support
Thread-Index: AQHVju2yGvQTvqp5E0i6CNNjQ6wmVad2vnxA
Date:   Fri, 1 Nov 2019 19:55:07 +0000
Message-ID: <AM0PR05MB486655EC2CC3EDA9D8C9C8E3D1620@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191030064444.21166-1-jasowang@redhat.com>
 <20191030064444.21166-2-jasowang@redhat.com>
In-Reply-To: <20191030064444.21166-2-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e10740a-c974-4194-eabd-08d75f056588
x-ms-traffictypediagnostic: AM0PR05MB6547:|AM0PR05MB6547:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB65479326219D06C64CF3345ED1620@AM0PR05MB6547.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(199004)(189003)(13464003)(71190400001)(71200400001)(66556008)(5660300002)(66476007)(64756008)(66446008)(76116006)(86362001)(66946007)(186003)(6506007)(2201001)(2906002)(7696005)(102836004)(6116002)(53546011)(3846002)(110136005)(446003)(305945005)(11346002)(54906003)(81166006)(81156014)(7736002)(8676002)(26005)(486006)(6246003)(478600001)(99286004)(7406005)(7416002)(2501003)(476003)(74316002)(229853002)(6436002)(316002)(66066001)(33656002)(52536014)(256004)(76176011)(14454004)(8936002)(9686003)(30864003)(14444005)(4326008)(55016002)(25786009)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6547;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ley2WbDfJG4Z+yszxUFyvp1CoHBaD0QtNoMmFJSBukU0BkjypSxSHiav9ZwwDm/qPyLzP1exNYx5B+Wv4DiVu5p8ib67zlZw1u2NCmu/cGi/0LyFNWfQ2KxaXSa5ZH9Jr5scsN8dIEYnZhXd8UtKETMv8FY9NfRrpHsj/6ySFhIKkcTcP1RwPVxQJHoFvqJJbSHtPS5MqD0OsdZpm30NM9VuJZLAA4pjNli/gVMrmQ5OENbjL8TQjigEBPrwSewx3JNRlD3FfN9S1n6AmihQkYz6Xvi42zDlAgfLwYhVmT+47mc2ca2uHShGzts5ALggK4rRVOAeZxDz4P01kMyz8DegwHYl6FBzG7zpnAQCsKWtO4OdWp09/wUs3Ov5snGZvPGD8UFq5N4aWMrcxDN74Sb199Sw/BaOOhUH34n9S8lMfXkH854Yn+SjXXDbQpOr
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e10740a-c974-4194-eabd-08d75f056588
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 19:55:07.7222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VXhlroZdhIg86pEbqMVZUdT61jgSmfnEKwMOhEpAymFgp7IdHYrWCibv+PKwZjKAoTaAnGKajjVX7e4LvRemhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6547
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Jason Wang
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
> Subject: [PATCH V6 1/6] mdev: class id support
>=20
> Mdev bus only supports vfio driver right now, so it doesn't implement mat=
ch
> method. But in the future, we may add drivers other than vfio, the first =
driver
> could be virtio-mdev. This means we need to add device class id support i=
n bus
> match method to pair the mdev device and mdev driver correctly.
>=20
> So this patch adds id_table to mdev_driver and class_id for mdev device w=
ith
> the match method for mdev bus.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  5 ++++
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  1 +
>  drivers/s390/cio/vfio_ccw_ops.c               |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c             |  1 +
>  drivers/vfio/mdev/mdev_core.c                 | 16 ++++++++++++
>  drivers/vfio/mdev/mdev_driver.c               | 25 +++++++++++++++++++
>  drivers/vfio/mdev/mdev_private.h              |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                 |  6 +++++
>  include/linux/mdev.h                          |  8 ++++++
>  include/linux/mod_devicetable.h               |  8 ++++++
>  samples/vfio-mdev/mbochs.c                    |  1 +
>  samples/vfio-mdev/mdpy.c                      |  1 +
>  samples/vfio-mdev/mtty.c                      |  1 +
>  13 files changed, 75 insertions(+)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..6709413bee29 100644
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
>  A mediated bus driver for mdev should use this structure in the function=
 calls
> @@ -170,6 +172,9 @@ that a driver should use to unregister itself with th=
e
> mdev core driver::
>=20
>  	extern void mdev_unregister_device(struct device *dev);
>=20
> +It is also required to specify the class_id in create() callback through=
::
> +
> +	int mdev_set_class(struct mdev_device *mdev, u16 id);
>=20
>  Mediated Device Management Interface Through sysfs
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 343d79c1cb7e..6420f0dbd31b 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -678,6 +678,7 @@ static int intel_vgpu_create(struct kobject *kobj, st=
ruct
> mdev_device *mdev)
>  		     dev_name(mdev_dev(mdev)));
>  	ret =3D 0;
>=20
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>  out:
>  	return ret;
>  }
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_=
ops.c
> index f0d71ab77c50..cf2c013ae32f 100644
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
> index b558d4cfd082..d23ca39e3be6 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,6 +45,16 @@ void mdev_set_drvdata(struct mdev_device *mdev, void
> *data)  }  EXPORT_SYMBOL(mdev_set_drvdata);
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
> @@ -324,6 +334,12 @@ int mdev_device_create(struct kobject *kobj,
>  	if (ret)
>  		goto ops_create_fail;
>=20
> +	if (!mdev->class_id) {
> +		ret =3D -EINVAL;
> +		dev_warn(dev, "mdev vendor driver failed to specify device
> class\n");
> +		goto add_fail;
> +	}
> +
>  	ret =3D device_add(&mdev->dev);
>  	if (ret)
>  		goto add_fail;
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c index 0d3223aee20b..ed06433693e8
> 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -69,8 +69,33 @@ static int mdev_remove(struct device *dev)
>  	return 0;
>  }
>=20
> +static int mdev_match(struct device *dev, struct device_driver *drv) {
> +	unsigned int i;
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
> +	struct mdev_driver *mdrv =3D to_mdev_driver(drv);
> +	const struct mdev_class_id *ids =3D mdrv->id_table;
> +
> +	if (!ids)
> +		return 0;
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
> index 30964a4e0a28..38431e9ef7f5 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -120,10 +120,16 @@ static void vfio_mdev_remove(struct device *dev)
>  	vfio_del_group_dev(dev);
>  }
>=20
> +static const struct mdev_class_id vfio_id_table[] =3D {
> +	{ MDEV_CLASS_ID_VFIO },
> +	{ 0 },
> +};
> +
>  static struct mdev_driver vfio_mdev_driver =3D {
>  	.name	=3D "vfio_mdev",
>  	.probe	=3D vfio_mdev_probe,
>  	.remove	=3D vfio_mdev_remove,
> +	.id_table =3D vfio_id_table,
>  };
>=20
>  static int __init vfio_mdev_init(void)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h index
> 0ce30ca78db0..78b69d09eb54 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -118,6 +118,7 @@ struct mdev_type_attribute mdev_type_attr_##_name
> =3D		\
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
> mdev_device *mdev);  void mdev_set_drvdata(struct mdev_device *mdev, void
> *data);  const guid_t *mdev_uuid(struct mdev_device *mdev);
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
> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c inde=
x
> ac5c8c17b1ff..115bc5074656 100644
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
