Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F48DDE446
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 08:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfJUGCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 02:02:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726149AbfJUGCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 02:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571637770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CPGuw063jsNcZTAsHwspNx9T8P5nC+7RyLijO85Jffo=;
        b=acDJMjLXOR2WKgnug88hxliJec+d038BAhIifiWnyq7dQsznr0EjTIQPR+kUDgaUZmRVF/
        WGufTvxw47i+j1GAdrEYpzaA/oANkwWdhYmxa4WrkId91J2nyLblu9dUetH88xFGGjAYtx
        X5+SwAQMQNwq6fp56A38pyVQY5LT/0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-OPRieHucN2OuRZVLAOYDow-1; Mon, 21 Oct 2019 02:02:47 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 945F6800D41;
        Mon, 21 Oct 2019 06:02:42 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6D2810027A1;
        Mon, 21 Oct 2019 06:02:05 +0000 (UTC)
Subject: Re: [PATCH V4 3/6] mdev: introduce device specific ops
To:     Parav Pandit <parav@mellanox.com>,
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
Cc:     "virtualization@lists.linux-foundation.org" 
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
References: <20191017104836.32464-1-jasowang@redhat.com>
 <20191017104836.32464-4-jasowang@redhat.com>
 <AM0PR05MB48666BF4DE14169E05557A6ED16E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b5c5ef13-6876-088d-9f15-a4469bbd9ad7@redhat.com>
Date:   Mon, 21 Oct 2019 14:02:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB48666BF4DE14169E05557A6ED16E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: OPRieHucN2OuRZVLAOYDow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/21 =E4=B8=8A=E5=8D=887:41, Parav Pandit wrote:
>
>> -----Original Message-----
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Thursday, October 17, 2019 5:49 AM
>> To: kvm@vger.kernel.org; linux-s390@vger.kernel.org; linux-
>> kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; intel-
>> gfx@lists.freedesktop.org; intel-gvt-dev@lists.freedesktop.org;
>> kwankhede@nvidia.com; alex.williamson@redhat.com; mst@redhat.com;
>> tiwei.bie@intel.com
>> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org;
>> cohuck@redhat.com; maxime.coquelin@redhat.com;
>> cunming.liang@intel.com; zhihong.wang@intel.com;
>> rob.miller@broadcom.com; xiao.w.wang@intel.com;
>> haotian.wang@sifive.com; zhenyuw@linux.intel.com; zhi.a.wang@intel.com;
>> jani.nikula@linux.intel.com; joonas.lahtinen@linux.intel.com;
>> rodrigo.vivi@intel.com; airlied@linux.ie; daniel@ffwll.ch;
>> farman@linux.ibm.com; pasic@linux.ibm.com; sebott@linux.ibm.com;
>> oberpar@linux.ibm.com; heiko.carstens@de.ibm.com; gor@linux.ibm.com;
>> borntraeger@de.ibm.com; akrowiak@linux.ibm.com; freude@linux.ibm.com;
>> lingshan.zhu@intel.com; Ido Shamay <idos@mellanox.com>;
>> eperezma@redhat.com; lulu@redhat.com; Parav Pandit
>> <parav@mellanox.com>; christophe.de.dinechin@gmail.com;
>> kevin.tian@intel.com; stefanha@redhat.com; Jason Wang
>> <jasowang@redhat.com>
>> Subject: [PATCH V4 3/6] mdev: introduce device specific ops
>>
>> Currently, except for the create and remove, the rest of mdev_parent_ops=
 is
>> designed for vfio-mdev driver only and may not help for kernel mdev driv=
er.
>> With the help of class id, this patch introduces device specific callbac=
ks
>> inside mdev_device structure. This allows different set of callback to b=
e used
>> by vfio-mdev and virtio-mdev.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   .../driver-api/vfio-mediated-device.rst       | 25 +++++----
>>   MAINTAINERS                                   |  1 +
>>   drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
>>   drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
>>   drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
>>   drivers/vfio/mdev/mdev_core.c                 | 18 +++++--
>>   drivers/vfio/mdev/mdev_private.h              |  1 +
>>   drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>>   include/linux/mdev.h                          | 45 ++++------------
>>   include/linux/vfio_mdev.h                     | 52 +++++++++++++++++++
>>   samples/vfio-mdev/mbochs.c                    | 20 ++++---
>>   samples/vfio-mdev/mdpy.c                      | 20 ++++---
>>   samples/vfio-mdev/mtty.c                      | 18 ++++---
>>   13 files changed, 184 insertions(+), 103 deletions(-)  create mode 100=
644
>> include/linux/vfio_mdev.h
>>
>> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
>> b/Documentation/driver-api/vfio-mediated-device.rst
>> index f9a78d75a67a..0cca84d19603 100644
>> --- a/Documentation/driver-api/vfio-mediated-device.rst
>> +++ b/Documentation/driver-api/vfio-mediated-device.rst
>> @@ -152,11 +152,22 @@ callbacks per mdev parent device, per mdev type,
>> or any other categorization.
>>   Vendor drivers are expected to be fully asynchronous in this respect o=
r
>> provide their own internal resource protection.)
>>
>> -The callbacks in the mdev_parent_ops structure are as follows:
>> -
>> -* open: open callback of mediated device
>> -* close: close callback of mediated device
>> -* ioctl: ioctl callback of mediated device
>> +As multiple types of mediated devices may be supported, the device must
>> +set up the class id and the device specific callbacks in create()
>> +callback. E.g for vfio-mdev device it needs to be done through:
>> +
>> +    int mdev_set_vfio_ops(struct mdev_device *mdev,
>> +                          const struct vfio_mdev_ops *vfio_ops);
>> +
>> +The class id (set to MDEV_CLASS_ID_VFIO) is used to match a device with
>> +an mdev driver via its id table. The device specific callbacks
>> +(specified in *ops) are obtainable via mdev_get_dev_ops() (for use by
>> +the mdev bus driver). A vfio-mdev device (class id MDEV_CLASS_ID_VFIO)
>> +uses the following device-specific ops:
>> +
>> +* open: open callback of vfio mediated device
>> +* close: close callback of vfio mediated device
>> +* ioctl: ioctl callback of vfio mediated device
>>   * read : read emulation callback
>>   * write: write emulation callback
>>   * mmap: mmap emulation callback
>> @@ -167,10 +178,6 @@ register itself with the mdev core driver::
>>   =09extern int  mdev_register_device(struct device *dev,
>>   =09                                 const struct mdev_parent_ops *ops)=
;
>>
>> -It is also required to specify the class_id in create() callback throug=
h::
>> -
>> -=09int mdev_set_class(struct mdev_device *mdev, u16 id);
>> -
>>   However, the mdev_parent_ops structure is not required in the function=
 call
>> that a driver should use to unregister itself with the mdev core driver:=
:
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 8824f61cd2c0..3d196a023b5e 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17127,6 +17127,7 @@ S:=09Maintained
>>   F:=09Documentation/driver-api/vfio-mediated-device.rst
>>   F:=09drivers/vfio/mdev/
>>   F:=09include/linux/mdev.h
>> +F:=09include/linux/vfio_mdev.h
>>   F:=09samples/vfio-mdev/
>>
>>   VFIO PLATFORM DRIVER
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index 6420f0dbd31b..306f934c7857 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -42,6 +42,7 @@
>>   #include <linux/kvm_host.h>
>>   #include <linux/vfio.h>
>>   #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>   #include <linux/debugfs.h>
>>
>>   #include <linux/nospec.h>
>> @@ -643,6 +644,8 @@ static void kvmgt_put_vfio_device(void *vgpu)
>>   =09vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);  }
>>
>> +static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops;
>> +
>>   static int intel_vgpu_create(struct kobject *kobj, struct mdev_device =
*mdev)
>> {
>>   =09struct intel_vgpu *vgpu =3D NULL;
>> @@ -678,7 +681,7 @@ static int intel_vgpu_create(struct kobject *kobj,
>> struct mdev_device *mdev)
>>   =09=09     dev_name(mdev_dev(mdev)));
>>   =09ret =3D 0;
>>
>> -=09mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>> +=09mdev_set_vfio_ops(mdev, &intel_vfio_vgpu_dev_ops);
>>   out:
>>   =09return ret;
>>   }
>> @@ -1599,20 +1602,21 @@ static const struct attribute_group
>> *intel_vgpu_groups[] =3D {
>>   =09NULL,
>>   };
>>
>> -static struct mdev_parent_ops intel_vgpu_ops =3D {
>> -=09.mdev_attr_groups       =3D intel_vgpu_groups,
>> -=09.create=09=09=09=3D intel_vgpu_create,
>> -=09.remove=09=09=09=3D intel_vgpu_remove,
>> -
>> +static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops =3D {
>>   =09.open=09=09=09=3D intel_vgpu_open,
>>   =09.release=09=09=3D intel_vgpu_release,
>> -
>>   =09.read=09=09=09=3D intel_vgpu_read,
>>   =09.write=09=09=09=3D intel_vgpu_write,
>>   =09.mmap=09=09=09=3D intel_vgpu_mmap,
>>   =09.ioctl=09=09=09=3D intel_vgpu_ioctl,
>>   };
>>
>> +static struct mdev_parent_ops intel_vgpu_ops =3D {
>> +=09.mdev_attr_groups       =3D intel_vgpu_groups,
>> +=09.create=09=09=09=3D intel_vgpu_create,
>> +=09.remove=09=09=09=3D intel_vgpu_remove,
>> +};
>> +
>>   static int kvmgt_host_init(struct device *dev, void *gvt, const void *=
ops)  {
>>   =09struct attribute **kvm_type_attrs;
>> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
>> b/drivers/s390/cio/vfio_ccw_ops.c index cf2c013ae32f..6e606cdb1aa9 10064=
4
>> --- a/drivers/s390/cio/vfio_ccw_ops.c
>> +++ b/drivers/s390/cio/vfio_ccw_ops.c
>> @@ -12,6 +12,7 @@
>>
>>   #include <linux/vfio.h>
>>   #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>   #include <linux/nospec.h>
>>   #include <linux/slab.h>
>>
>> @@ -110,6 +111,8 @@ static struct attribute_group *mdev_type_groups[] =
=3D
>> {
>>   =09NULL,
>>   };
>>
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
>> +
>>   static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_devi=
ce
>> *mdev)  {
>>   =09struct vfio_ccw_private *private =3D
>> @@ -129,7 +132,7 @@ static int vfio_ccw_mdev_create(struct kobject *kobj=
,
>> struct mdev_device *mdev)
>>   =09=09=09   private->sch->schid.ssid,
>>   =09=09=09   private->sch->schid.sch_no);
>>
>> -=09mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>> +=09mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>>   =09return 0;
>>   }
>>
>> @@ -575,11 +578,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct
>> mdev_device *mdev,
>>   =09}
>>   }
>>
>> -static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
>> -=09.owner=09=09=09=3D THIS_MODULE,
>> -=09.supported_type_groups  =3D mdev_type_groups,
>> -=09.create=09=09=09=3D vfio_ccw_mdev_create,
>> -=09.remove=09=09=09=3D vfio_ccw_mdev_remove,
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>>   =09.open=09=09=09=3D vfio_ccw_mdev_open,
>>   =09.release=09=09=3D vfio_ccw_mdev_release,
>>   =09.read=09=09=09=3D vfio_ccw_mdev_read,
>> @@ -587,6 +586,13 @@ static const struct mdev_parent_ops
>> vfio_ccw_mdev_ops =3D {
>>   =09.ioctl=09=09=09=3D vfio_ccw_mdev_ioctl,
>>   };
>>
>> +static const struct mdev_parent_ops vfio_ccw_mdev_ops =3D {
>> +=09.owner=09=09=09=3D THIS_MODULE,
>> +=09.supported_type_groups  =3D mdev_type_groups,
>> +=09.create=09=09=09=3D vfio_ccw_mdev_create,
>> +=09.remove=09=09=09=3D vfio_ccw_mdev_remove,
>> +};
>> +
>>   int vfio_ccw_mdev_reg(struct subchannel *sch)  {
>>   =09return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops); diff -
>> -git a/drivers/s390/crypto/vfio_ap_ops.c
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 07c31070afeb..195c8f4c6f10 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -16,6 +16,7 @@
>>   #include <linux/bitops.h>
>>   #include <linux/kvm_host.h>
>>   #include <linux/module.h>
>> +#include <linux/vfio_mdev.h>
>>   #include <asm/kvm.h>
>>   #include <asm/zcrypt.h>
>>
>> @@ -321,6 +322,8 @@ static void vfio_ap_matrix_init(struct ap_config_inf=
o
>> *info,
>>   =09matrix->adm_max =3D info->apxa ? info->Nd : 15;  }
>>
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
>> +
>>   static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_devic=
e
>> *mdev)  {
>>   =09struct ap_matrix_mdev *matrix_mdev;
>> @@ -343,7 +346,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj,
>> struct mdev_device *mdev)
>>   =09list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>>   =09mutex_unlock(&matrix_dev->lock);
>>
>> -=09mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>> +=09mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>>   =09return 0;
>>   }
>>
>> @@ -1281,15 +1284,18 @@ static ssize_t vfio_ap_mdev_ioctl(struct
>> mdev_device *mdev,
>>   =09return ret;
>>   }
>>
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>> +=09.open=09=09=09=3D vfio_ap_mdev_open,
>> +=09.release=09=09=3D vfio_ap_mdev_release,
>> +=09.ioctl=09=09=09=3D vfio_ap_mdev_ioctl,
>> +};
>> +
>>   static const struct mdev_parent_ops vfio_ap_matrix_ops =3D {
>>   =09.owner=09=09=09=3D THIS_MODULE,
>>   =09.supported_type_groups=09=3D vfio_ap_mdev_type_groups,
>>   =09.mdev_attr_groups=09=3D vfio_ap_mdev_attr_groups,
>>   =09.create=09=09=09=3D vfio_ap_mdev_create,
>>   =09.remove=09=09=09=3D vfio_ap_mdev_remove,
>> -=09.open=09=09=09=3D vfio_ap_mdev_open,
>> -=09.release=09=09=3D vfio_ap_mdev_release,
>> -=09.ioctl=09=09=09=3D vfio_ap_mdev_ioctl,
>>   };
>>
>>   int vfio_ap_mdev_register(void)
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core=
.c
>> index 3a9c52d71b4e..d0f3113c8071 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -45,15 +45,23 @@ void mdev_set_drvdata(struct mdev_device *mdev,
>> void *data)  }  EXPORT_SYMBOL(mdev_set_drvdata);
>>
>> -/* Specify the class for the mdev device, this must be called during
>> - * create() callback.
>> +/* Specify the VFIO device ops for the mdev device, this
>> + * must be called during create() callback for VFIO mdev device.
>>    */
>> -void mdev_set_class(struct mdev_device *mdev, u16 id)
> I think you should keep the mdev_set_class API and let mdev_set_vfio_ops =
call it. Even though its two line function.
> The reason to avoid a code churn in short time with mlx5_core patch which=
 will only call mdev_set_class(), as it doesn't have any ops yet.


That sounds good, will do.


>> +void mdev_set_vfio_ops(struct mdev_device *mdev,
>> +=09=09       const struct vfio_mdev_device_ops *vfio_ops)
>>   {
>>   =09WARN_ON(mdev->class_id);
>> -=09mdev->class_id =3D id;
>> +=09mdev->class_id =3D MDEV_CLASS_ID_VFIO;
>> +=09mdev->device_ops =3D vfio_ops;
>>   }
>> -EXPORT_SYMBOL(mdev_set_class);
>> +EXPORT_SYMBOL(mdev_set_vfio_ops);
>> +
>> +const void *mdev_get_dev_ops(struct mdev_device *mdev) {
>> +=09return mdev->device_ops;
>> +}
>> +EXPORT_SYMBOL(mdev_get_dev_ops);
>>
>>   struct device *mdev_dev(struct mdev_device *mdev)  { diff --git
>> a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
>> index c65f436c1869..b666805f0b1f 100644
>> --- a/drivers/vfio/mdev/mdev_private.h
>> +++ b/drivers/vfio/mdev/mdev_private.h
>> @@ -34,6 +34,7 @@ struct mdev_device {
>>   =09struct device *iommu_device;
>>   =09bool active;
>>   =09u16 class_id;
>> +=09const void *device_ops;
> Instead of void *, this should be union vfio_ops and virtio_ops.


Ok.


>>   };
>>
>>   #define to_mdev_device(dev)=09container_of(dev, struct mdev_device, de=
v)
>> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev=
.c
>> index cb701cd646f0..6b6b92011436 100644
>> --- a/drivers/vfio/mdev/vfio_mdev.c
>> +++ b/drivers/vfio/mdev/vfio_mdev.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/vfio.h>
>>   #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>
>>   #include "mdev_private.h"
>>
>> @@ -24,16 +25,16 @@
>>   static int vfio_mdev_open(void *device_data)  {
>>   =09struct mdev_device *mdev =3D device_data;
>> -=09struct mdev_parent *parent =3D mdev->parent;
>> +=09const struct vfio_mdev_device_ops *ops =3D
>> mdev_get_dev_ops(mdev);
>>   =09int ret;
>>
>> -=09if (unlikely(!parent->ops->open))
>> +=09if (unlikely(!ops->open))
>>   =09=09return -EINVAL;
>>
>>   =09if (!try_module_get(THIS_MODULE))
>>   =09=09return -ENODEV;
>>
>> -=09ret =3D parent->ops->open(mdev);
>> +=09ret =3D ops->open(mdev);
>>   =09if (ret)
>>   =09=09module_put(THIS_MODULE);
>>
>> @@ -43,10 +44,10 @@ static int vfio_mdev_open(void *device_data)  static
>> void vfio_mdev_release(void *device_data)  {
>>   =09struct mdev_device *mdev =3D device_data;
>> -=09struct mdev_parent *parent =3D mdev->parent;
>> +=09const struct vfio_mdev_device_ops *ops =3D
>> mdev_get_dev_ops(mdev);
>>
>> -=09if (likely(parent->ops->release))
>> -=09=09parent->ops->release(mdev);
>> +=09if (likely(ops->release))
>> +=09=09ops->release(mdev);
>>
>>   =09module_put(THIS_MODULE);
>>   }
>> @@ -55,47 +56,47 @@ static long vfio_mdev_unlocked_ioctl(void
>> *device_data,
>>   =09=09=09=09     unsigned int cmd, unsigned long arg)  {
>>   =09struct mdev_device *mdev =3D device_data;
>> -=09struct mdev_parent *parent =3D mdev->parent;
>> +=09const struct vfio_mdev_device_ops *ops =3D
>> mdev_get_dev_ops(mdev);
>>
>> -=09if (unlikely(!parent->ops->ioctl))
>> +=09if (unlikely(!ops->ioctl))
>>   =09=09return -EINVAL;
>>
>> -=09return parent->ops->ioctl(mdev, cmd, arg);
>> +=09return ops->ioctl(mdev, cmd, arg);
>>   }
>>
>>   static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
>>   =09=09=09      size_t count, loff_t *ppos)
>>   {
>>   =09struct mdev_device *mdev =3D device_data;
>> -=09struct mdev_parent *parent =3D mdev->parent;
>> +=09const struct vfio_mdev_device_ops *ops =3D
>> mdev_get_dev_ops(mdev);
>>
>> -=09if (unlikely(!parent->ops->read))
>> +=09if (unlikely(!ops->read))
>>   =09=09return -EINVAL;
>>
>> -=09return parent->ops->read(mdev, buf, count, ppos);
>> +=09return ops->read(mdev, buf, count, ppos);
>>   }
>>
>>   static ssize_t vfio_mdev_write(void *device_data, const char __user *b=
uf,
>>   =09=09=09       size_t count, loff_t *ppos)
>>   {
>>   =09struct mdev_device *mdev =3D device_data;
>> -=09struct mdev_parent *parent =3D mdev->parent;
>> +=09const struct vfio_mdev_device_ops *ops =3D
>> mdev_get_dev_ops(mdev);
>>
>> -=09if (unlikely(!parent->ops->write))
>> +=09if (unlikely(!ops->write))
>>   =09=09return -EINVAL;
>>
>> -=09return parent->ops->write(mdev, buf, count, ppos);
>> +=09return ops->write(mdev, buf, count, ppos);
>>   }
>>
>>   static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vm=
a)
>> {
>>   =09struct mdev_device *mdev =3D device_data;
>> -=09struct mdev_parent *parent =3D mdev->parent;
>> +=09const struct vfio_mdev_device_ops *ops =3D
>> mdev_get_dev_ops(mdev);
>>
>> -=09if (unlikely(!parent->ops->mmap))
>> +=09if (unlikely(!ops->mmap))
>>   =09=09return -EINVAL;
>>
>> -=09return parent->ops->mmap(mdev, vma);
>> +=09return ops->mmap(mdev, vma);
>>   }
>>
>>   static const struct vfio_device_ops vfio_mdev_dev_ops =3D { diff --git
>> a/include/linux/mdev.h b/include/linux/mdev.h index
>> 78b69d09eb54..3d29e09e20c9 100644
>> --- a/include/linux/mdev.h
>> +++ b/include/linux/mdev.h
>> @@ -10,7 +10,13 @@
>>   #ifndef MDEV_H
>>   #define MDEV_H
>>
>> +#include <linux/types.h>
>> +#include <linux/device.h>
>> +#include <linux/mdev.h>
>> +#include <uapi/linux/uuid.h>
>> +
>>   struct mdev_device;
>> +struct vfio_mdev_device_ops;
>>
>>   /*
>>    * Called by the parent device driver to set the device which represen=
ts @@
>> -48,30 +54,7 @@ struct device *mdev_get_iommu_device(struct device
>> *dev);
>>    *=09=09=09@mdev: mdev_device device structure which is being
>>    *=09=09=09       destroyed
>>    *=09=09=09Returns integer: success (0) or error (< 0)
>> - * @open:=09=09Open mediated device.
>> - *=09=09=09@mdev: mediated device.
>> - *=09=09=09Returns integer: success (0) or error (< 0)
>> - * @release:=09=09release mediated device
>> - *=09=09=09@mdev: mediated device.
>> - * @read:=09=09Read emulation callback
>> - *=09=09=09@mdev: mediated device structure
>> - *=09=09=09@buf: read buffer
>> - *=09=09=09@count: number of bytes to read
>> - *=09=09=09@ppos: address.
>> - *=09=09=09Retuns number on bytes read on success or error.
>> - * @write:=09=09Write emulation callback
>> - *=09=09=09@mdev: mediated device structure
>> - *=09=09=09@buf: write buffer
>> - *=09=09=09@count: number of bytes to be written
>> - *=09=09=09@ppos: address.
>> - *=09=09=09Retuns number on bytes written on success or error.
>> - * @ioctl:=09=09IOCTL callback
>> - *=09=09=09@mdev: mediated device structure
>> - *=09=09=09@cmd: ioctl command
>> - *=09=09=09@arg: arguments to ioctl
>> - * @mmap:=09=09mmap callback
>> - *=09=09=09@mdev: mediated device structure
>> - *=09=09=09@vma: vma structure
>> + *
>>    * Parent device that support mediated device should be registered wit=
h
>> mdev
>>    * module with mdev_parent_ops structure.
>>    **/
>> @@ -83,15 +66,6 @@ struct mdev_parent_ops {
>>
>>   =09int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>>   =09int     (*remove)(struct mdev_device *mdev);
>> -=09int     (*open)(struct mdev_device *mdev);
>> -=09void    (*release)(struct mdev_device *mdev);
>> -=09ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
>> -=09=09=09size_t count, loff_t *ppos);
>> -=09ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
>> -=09=09=09 size_t count, loff_t *ppos);
>> -=09long=09(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>> -=09=09=09 unsigned long arg);
>> -=09int=09(*mmap)(struct mdev_device *mdev, struct vm_area_struct
>> *vma);
>>   };
>>
>>   /* interface for exporting mdev supported type attributes */ @@ -133,8
>> +107,11 @@ struct mdev_driver {
>>
>>   void *mdev_get_drvdata(struct mdev_device *mdev);  void
>> mdev_set_drvdata(struct mdev_device *mdev, void *data);
>> +
> Unrelated line change for this patch. Please remove.


Sure.


>
>>   const guid_t *mdev_uuid(struct mdev_device *mdev); -void
>> mdev_set_class(struct mdev_device *mdev, u16 id);
>> +void mdev_set_vfio_ops(struct mdev_device *mdev,
>> +=09=09       const struct vfio_mdev_device_ops *vfio_ops); const
>> void
>> +*mdev_get_dev_ops(struct mdev_device *mdev);
>>
> Since you have the set_vfio_ops, its better to have get_vfio_ops() and si=
milarly get_virtio_ops.


Ok.


>
>>   extern struct bus_type mdev_bus_type;
>>
>> diff --git a/include/linux/vfio_mdev.h b/include/linux/vfio_mdev.h new f=
ile
>> mode 100644 index 000000000000..3907c5371c2b
>> --- /dev/null
>> +++ b/include/linux/vfio_mdev.h
> This file name is confusing.
> vfio_mdev_ops.h is more accurate name of what it intends to achieve.
> If you see this file expanding scope beyond ops, this file name looks fin=
e.
>
>> @@ -0,0 +1,52 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * VFIO Mediated device definition
>> + */
>> +
>> +#ifndef VFIO_MDEV_H
>> +#define VFIO_MDEV_H
>> +
>> +#include <linux/mdev.h>
>> +
>> +/**
>> + * struct vfio_mdev_device_ops - Structure to be registered for each
>> + * mdev device to register the device to vfio-mdev module.
>> + *
>> + * @open:=09=09Open mediated device.
>> + *=09=09=09@mdev: mediated device.
>> + *=09=09=09Returns integer: success (0) or error (< 0)
>> + * @release:=09=09release mediated device
>> + *=09=09=09@mdev: mediated device.
>> + * @read:=09=09Read emulation callback
>> + *=09=09=09@mdev: mediated device structure
>> + *=09=09=09@buf: read buffer
>> + *=09=09=09@count: number of bytes to read
>> + *=09=09=09@ppos: address.
>> + *=09=09=09Retuns number on bytes read on success or error.
>> + * @write:=09=09Write emulation callback
>> + *=09=09=09@mdev: mediated device structure
>> + *=09=09=09@buf: write buffer
>> + *=09=09=09@count: number of bytes to be written
>> + *=09=09=09@ppos: address.
>> + *=09=09=09Retuns number on bytes written on success or error.
>> + * @ioctl:=09=09IOCTL callback
>> + *=09=09=09@mdev: mediated device structure
>> + *=09=09=09@cmd: ioctl command
>> + *=09=09=09@arg: arguments to ioctl
>> + * @mmap:=09=09mmap callback
>> + *=09=09=09@mdev: mediated device structure
>> + *=09=09=09@vma: vma structure
>> + */
>> +struct vfio_mdev_device_ops {
>> +=09int     (*open)(struct mdev_device *mdev);
>> +=09void    (*release)(struct mdev_device *mdev);
>> +=09ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
>> +=09=09=09size_t count, loff_t *ppos);
>> +=09ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
>> +=09=09=09 size_t count, loff_t *ppos);
>> +=09long=09(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>> +=09=09=09 unsigned long arg);
>> +=09int=09(*mmap)(struct mdev_device *mdev, struct vm_area_struct
>> *vma);
>> +};
>> +
>> +#endif
>> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
>> index 115bc5074656..37abdf1b27a8 100644
>> --- a/samples/vfio-mdev/mbochs.c
>> +++ b/samples/vfio-mdev/mbochs.c
>> @@ -30,6 +30,7 @@
>>   #include <linux/iommu.h>
>>   #include <linux/sysfs.h>
>>   #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>   #include <linux/pci.h>
>>   #include <linux/dma-buf.h>
>>   #include <linux/highmem.h>
>> @@ -516,6 +517,8 @@ static int mbochs_reset(struct mdev_device *mdev)
>>   =09return 0;
>>   }
>>
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
>> +
>>   static int mbochs_create(struct kobject *kobj, struct mdev_device *mde=
v)  {
>>   =09const struct mbochs_type *type =3D mbochs_find_type(kobj); @@ -
>> 561,7 +564,7 @@ static int mbochs_create(struct kobject *kobj, struct
>> mdev_device *mdev)
>>   =09mbochs_reset(mdev);
>>
>>   =09mbochs_used_mbytes +=3D type->mbytes;
>> -=09mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>> +=09mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>>   =09return 0;
>>
>>   err_mem:
>> @@ -1419,12 +1422,7 @@ static struct attribute_group
>> *mdev_type_groups[] =3D {
>>   =09NULL,
>>   };
>>
>> -static const struct mdev_parent_ops mdev_fops =3D {
>> -=09.owner=09=09=09=3D THIS_MODULE,
>> -=09.mdev_attr_groups=09=3D mdev_dev_groups,
>> -=09.supported_type_groups=09=3D mdev_type_groups,
>> -=09.create=09=09=09=3D mbochs_create,
>> -=09.remove=09=09=09=3D mbochs_remove,
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>>   =09.open=09=09=09=3D mbochs_open,
>>   =09.release=09=09=3D mbochs_close,
>>   =09.read=09=09=09=3D mbochs_read,
>> @@ -1433,6 +1431,14 @@ static const struct mdev_parent_ops mdev_fops =3D
>> {
>>   =09.mmap=09=09=09=3D mbochs_mmap,
>>   };
>>
>> +static const struct mdev_parent_ops mdev_fops =3D {
>> +=09.owner=09=09=09=3D THIS_MODULE,
>> +=09.mdev_attr_groups=09=3D mdev_dev_groups,
>> +=09.supported_type_groups=09=3D mdev_type_groups,
>> +=09.create=09=09=09=3D mbochs_create,
>> +=09.remove=09=09=09=3D mbochs_remove,
>> +};
>> +
>>   static const struct file_operations vd_fops =3D {
>>   =09.owner=09=09=3D THIS_MODULE,
>>   };
>> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c index
>> 665614574d50..f21c795c40e4 100644
>> --- a/samples/vfio-mdev/mdpy.c
>> +++ b/samples/vfio-mdev/mdpy.c
>> @@ -26,6 +26,7 @@
>>   #include <linux/iommu.h>
>>   #include <linux/sysfs.h>
>>   #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>   #include <linux/pci.h>
>>   #include <drm/drm_fourcc.h>
>>   #include "mdpy-defs.h"
>> @@ -226,6 +227,8 @@ static int mdpy_reset(struct mdev_device *mdev)
>>   =09return 0;
>>   }
>>
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops;
>> +
>>   static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)=
  {
>>   =09const struct mdpy_type *type =3D mdpy_find_type(kobj); @@ -269,7
>> +272,7 @@ static int mdpy_create(struct kobject *kobj, struct mdev_devic=
e
>> *mdev)
>>   =09mdpy_reset(mdev);
>>
>>   =09mdpy_count++;
>> -=09mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>> +=09mdev_set_vfio_ops(mdev, &vfio_mdev_ops);
>>   =09return 0;
>>   }
>>
>> @@ -726,12 +729,7 @@ static struct attribute_group *mdev_type_groups[]
>> =3D {
>>   =09NULL,
>>   };
>>
>> -static const struct mdev_parent_ops mdev_fops =3D {
>> -=09.owner=09=09=09=3D THIS_MODULE,
>> -=09.mdev_attr_groups=09=3D mdev_dev_groups,
>> -=09.supported_type_groups=09=3D mdev_type_groups,
>> -=09.create=09=09=09=3D mdpy_create,
>> -=09.remove=09=09=09=3D mdpy_remove,
>> +static const struct vfio_mdev_device_ops vfio_mdev_ops =3D {
>>   =09.open=09=09=09=3D mdpy_open,
>>   =09.release=09=09=3D mdpy_close,
>>   =09.read=09=09=09=3D mdpy_read,
>> @@ -740,6 +738,14 @@ static const struct mdev_parent_ops mdev_fops =3D {
>>   =09.mmap=09=09=09=3D mdpy_mmap,
>>   };
>>
>> +static const struct mdev_parent_ops mdev_fops =3D {
>> +=09.owner=09=09=09=3D THIS_MODULE,
>> +=09.mdev_attr_groups=09=3D mdev_dev_groups,
>> +=09.supported_type_groups=09=3D mdev_type_groups,
>> +=09.create=09=09=09=3D mdpy_create,
>> +=09.remove=09=09=09=3D mdpy_remove,
>> +};
>> +
>>   static const struct file_operations vd_fops =3D {
>>   =09.owner=09=09=3D THIS_MODULE,
>>   };
>> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c index
>> 90da12ff7fd9..b829f33b98f5 100644
>> --- a/samples/vfio-mdev/mtty.c
>> +++ b/samples/vfio-mdev/mtty.c
>> @@ -27,6 +27,7 @@
>>   #include <linux/ctype.h>
>>   #include <linux/file.h>
>>   #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>   #include <linux/pci.h>
>>   #include <linux/serial.h>
>>   #include <uapi/linux/serial_reg.h>
>> @@ -708,6 +709,8 @@ static ssize_t mdev_access(struct mdev_device
>> *mdev, u8 *buf, size_t count,
>>   =09return ret;
>>   }
>>
>> +static const struct vfio_mdev_device_ops vfio_dev_ops;
>> +
>>   static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)=
  {
>>   =09struct mdev_state *mdev_state;
>> @@ -755,7 +758,7 @@ static int mtty_create(struct kobject *kobj, struct
>> mdev_device *mdev)
>>   =09list_add(&mdev_state->next, &mdev_devices_list);
>>   =09mutex_unlock(&mdev_list_lock);
>>
>> -=09mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
>> +=09mdev_set_vfio_ops(mdev, &vfio_dev_ops);
>>   =09return 0;
>>   }
>>
>> @@ -1388,6 +1391,14 @@ static struct attribute_group
>> *mdev_type_groups[] =3D {
>>   =09NULL,
>>   };
>>
>> +static const struct vfio_mdev_device_ops vfio_dev_ops =3D {
>> +=09.open                   =3D mtty_open,
>> +=09.release                =3D mtty_close,
>> +=09.read                   =3D mtty_read,
>> +=09.write                  =3D mtty_write,
>> +=09.ioctl=09=09        =3D mtty_ioctl,
>> +};
>> +
> Since hunk shows that vfio_dev_ops added new here, it is better to drop t=
he extra white space mixed with tab alignment.
> Just have single white space like below.
>
> =09.open =3D mtty_open,
> =09.release =3D mtty_close,
> =09.read =3D mtty_read,
> =09.write =3D mtty_write,
> =09.ioctl =3D mtty_ioctl


Will do.

Thanks


>
>>   static const struct mdev_parent_ops mdev_fops =3D {
>>   =09.owner                  =3D THIS_MODULE,
>>   =09.dev_attr_groups        =3D mtty_dev_groups,
>> @@ -1395,11 +1406,6 @@ static const struct mdev_parent_ops mdev_fops =3D
>> {
>>   =09.supported_type_groups  =3D mdev_type_groups,
>>   =09.create                 =3D mtty_create,
>>   =09.remove=09=09=09=3D mtty_remove,
>> -=09.open                   =3D mtty_open,
>> -=09.release                =3D mtty_close,
>> -=09.read                   =3D mtty_read,
>> -=09.write                  =3D mtty_write,
>> -=09.ioctl=09=09        =3D mtty_ioctl,
>>   };
>>
>>   static void mtty_device_release(struct device *dev)
>> --
>> 2.19.1

