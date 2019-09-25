Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F15BDDF7
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405657AbfIYMOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405619AbfIYMOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 08:14:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 952791918644;
        Wed, 25 Sep 2019 12:14:44 +0000 (UTC)
Received: from [10.72.12.148] (ovpn-12-148.pek2.redhat.com [10.72.12.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E60E600C8;
        Wed, 25 Sep 2019 12:13:58 +0000 (UTC)
Subject: Re: [PATCH V2 2/8] mdev: class id support
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Bie, Tiwei" <tiwei.bie@intel.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
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
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "idos@mellanox.com" <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-3-jasowang@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F6AE@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c7e8a56a-d805-7cf4-2704-dc891dd23713@redhat.com>
Date:   Wed, 25 Sep 2019 20:13:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F6AE@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Wed, 25 Sep 2019 12:14:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/25 下午4:28, Tian, Kevin wrote:
>> From: Jason Wang
>> Sent: Tuesday, September 24, 2019 9:53 PM
>>
>> Mdev bus only supports vfio driver right now, so it doesn't implement
>> match method. But in the future, we may add drivers other than vfio,
>> the first driver could be virtio-mdev. This means we need to add
>> device class id support in bus match method to pair the mdev device
>> and mdev driver correctly.
>>
>> So this patch adds id_table to mdev_driver and class_id for mdev
>> parent with the match method for mdev bus.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  Documentation/driver-api/vfio-mediated-device.rst |  3 +++
>>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  1 +
>>  drivers/s390/cio/vfio_ccw_ops.c                   |  1 +
>>  drivers/s390/crypto/vfio_ap_ops.c                 |  1 +
>>  drivers/vfio/mdev/mdev_core.c                     |  7 +++++++
>>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>>  include/linux/mdev.h                              |  8 ++++++++
>>  include/linux/mod_devicetable.h                   |  8 ++++++++
>>  samples/vfio-mdev/mbochs.c                        |  1 +
>>  samples/vfio-mdev/mdpy.c                          |  1 +
>>  samples/vfio-mdev/mtty.c                          |  1 +
>>  13 files changed, 53 insertions(+)
>>
>> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
>> b/Documentation/driver-api/vfio-mediated-device.rst
>> index 25eb7d5b834b..a5bdc60d62a1 100644
>> --- a/Documentation/driver-api/vfio-mediated-device.rst
>> +++ b/Documentation/driver-api/vfio-mediated-device.rst
>> @@ -102,12 +102,14 @@ structure to represent a mediated device's
>> driver::
>>        * @probe: called when new device created
>>        * @remove: called when device removed
>>        * @driver: device driver structure
>> +      * @id_table: the ids serviced by this driver
>>        */
>>       struct mdev_driver {
>>  	     const char *name;
>>  	     int  (*probe)  (struct device *dev);
>>  	     void (*remove) (struct device *dev);
>>  	     struct device_driver    driver;
>> +	     const struct mdev_class_id *id_table;
>>       };
>>
>>  A mediated bus driver for mdev should use this structure in the function
>> calls
>> @@ -165,6 +167,7 @@ register itself with the mdev core driver::
>>  	extern int  mdev_register_device(struct device *dev,
>>  	                                 const struct mdev_parent_ops *ops);
>>
>> +
>>  However, the mdev_parent_ops structure is not required in the function
>> call
>>  that a driver should use to unregister itself with the mdev core driver::
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index 23aa3e50cbf8..f793252a3d2a 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -678,6 +678,7 @@ static int intel_vgpu_create(struct kobject *kobj,
>> struct mdev_device *mdev)
>>  		     dev_name(mdev_dev(mdev)));
>>  	ret = 0;
>>
>> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>>  out:
>>  	return ret;
>>  }
>> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
>> b/drivers/s390/cio/vfio_ccw_ops.c
>> index f0d71ab77c50..d258ef1fedb9 100644
>> --- a/drivers/s390/cio/vfio_ccw_ops.c
>> +++ b/drivers/s390/cio/vfio_ccw_ops.c
>> @@ -129,6 +129,7 @@ static int vfio_ccw_mdev_create(struct kobject
>> *kobj, struct mdev_device *mdev)
>>  			   private->sch->schid.ssid,
>>  			   private->sch->schid.sch_no);
>>
>> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>>  	return 0;
>>  }
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 5c0f53c6dde7..2cfd96112aa0 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -343,6 +343,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj,
>> struct mdev_device *mdev)
>>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>>  	mutex_unlock(&matrix_dev->lock);
>>
>> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>>  	return 0;
>>  }
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c
>> b/drivers/vfio/mdev/mdev_core.c
>> index b558d4cfd082..8764cf4a276d 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -45,6 +45,12 @@ void mdev_set_drvdata(struct mdev_device *mdev,
>> void *data)
>>  }
>>  EXPORT_SYMBOL(mdev_set_drvdata);
>>
>> +void mdev_set_class_id(struct mdev_device *mdev, u16 id)
>> +{
>> +	mdev->class_id = id;
>> +}
>> +EXPORT_SYMBOL(mdev_set_class_id);
>> +
>>  struct device *mdev_dev(struct mdev_device *mdev)
>>  {
>>  	return &mdev->dev;
>> @@ -135,6 +141,7 @@ static int mdev_device_remove_cb(struct device
>> *dev, void *data)
>>   * mdev_register_device : Register a device
>>   * @dev: device structure representing parent device.
>>   * @ops: Parent device operation structure to be registered.
>> + * @id: device id.
> class id.


Right, will fix.

Thanks

