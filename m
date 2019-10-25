Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5302CE4148
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 03:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389497AbfJYByz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 21:54:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51914 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389371AbfJYByz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 21:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571968493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lId+Mx+j4QJ3bY5bKs+Ns5CL0DHAeK04qirPnQJqIDY=;
        b=I0QNPE4CRFoquX8ijcNBAGiCUlLwhNSx+bFzKpqgFRa9IAKYcXYnDi6hN6K9oKuVj+6igQ
        BL+A7C+6VQjzXXXAODa+gyYjO1DuUS2pyQcy3ocnGxhvhoNfpQhMTbxk/7b82fa6LZVx1s
        f5EbXShA2ankz27xpZMCw44/0O82sOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-PnVYUqqAP2WgscN-9uAj2g-1; Thu, 24 Oct 2019 21:54:50 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76A611005500;
        Fri, 25 Oct 2019 01:54:46 +0000 (UTC)
Received: from [10.72.12.158] (ovpn-12-158.pek2.redhat.com [10.72.12.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1028F5D70E;
        Fri, 25 Oct 2019 01:54:21 +0000 (UTC)
Subject: Re: [PATCH V5 4/6] mdev: introduce virtio device and its device ops
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191023130752.18980-1-jasowang@redhat.com>
 <20191023130752.18980-5-jasowang@redhat.com>
 <20191023155728.2a55bc71@x1.home>
 <1699cc4e-7d52-b2dc-8016-358a36a4f4ea@redhat.com>
 <20191024144449.626d560b@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d1a1b65e-75b4-2e04-2484-cd0a305cef7e@redhat.com>
Date:   Fri, 25 Oct 2019 09:54:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024144449.626d560b@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: PnVYUqqAP2WgscN-9uAj2g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/25 =E4=B8=8A=E5=8D=884:44, Alex Williamson wrote:
> On Thu, 24 Oct 2019 11:51:35 +0800
> Jason Wang<jasowang@redhat.com>  wrote:
>
>> On 2019/10/24 =E4=B8=8A=E5=8D=885:57, Alex Williamson wrote:
>>> On Wed, 23 Oct 2019 21:07:50 +0800
>>> Jason Wang<jasowang@redhat.com>  wrote:
>>>  =20
>>>> This patch implements basic support for mdev driver that supports
>>>> virtio transport for kernel virtio driver.
>>>>
>>>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>>>> ---
>>>>    drivers/vfio/mdev/mdev_core.c    |  20 ++++
>>>>    drivers/vfio/mdev/mdev_private.h |   2 +
>>>>    include/linux/mdev.h             |   6 ++
>>>>    include/linux/virtio_mdev_ops.h  | 159 ++++++++++++++++++++++++++++=
+++
>>>>    4 files changed, 187 insertions(+)
>>>>    create mode 100644 include/linux/virtio_mdev_ops.h
>>>>
>>>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_co=
re.c
>>>> index 555bd61d8c38..9b00c3513120 100644
>>>> --- a/drivers/vfio/mdev/mdev_core.c
>>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>>> @@ -76,6 +76,26 @@ const struct vfio_mdev_device_ops *mdev_get_vfio_op=
s(struct mdev_device *mdev)
>>>>    }
>>>>    EXPORT_SYMBOL(mdev_get_vfio_ops);
>>>>   =20
>>>> +/* Specify the virtio device ops for the mdev device, this
>>>> + * must be called during create() callback for virtio mdev device.
>>>> + */
>>>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>>>> +=09=09=09 const struct virtio_mdev_device_ops *virtio_ops)
>>>> +{
>>>> +=09mdev_set_class(mdev, MDEV_CLASS_ID_VIRTIO);
>>>> +=09mdev->virtio_ops =3D virtio_ops;
>>>> +}
>>>> +EXPORT_SYMBOL(mdev_set_virtio_ops);
>>>> +
>>>> +/* Get the virtio device ops for the mdev device. */
>>>> +const struct virtio_mdev_device_ops *
>>>> +mdev_get_virtio_ops(struct mdev_device *mdev)
>>>> +{
>>>> +=09WARN_ON(mdev->class_id !=3D MDEV_CLASS_ID_VIRTIO);
>>>> +=09return mdev->virtio_ops;
>>>> +}
>>>> +EXPORT_SYMBOL(mdev_get_virtio_ops);
>>>> +
>>>>    struct device *mdev_dev(struct mdev_device *mdev)
>>>>    {
>>>>    =09return &mdev->dev;
>>>> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev=
_private.h
>>>> index 0770410ded2a..7b47890c34e7 100644
>>>> --- a/drivers/vfio/mdev/mdev_private.h
>>>> +++ b/drivers/vfio/mdev/mdev_private.h
>>>> @@ -11,6 +11,7 @@
>>>>    #define MDEV_PRIVATE_H
>>>>   =20
>>>>    #include <linux/vfio_mdev_ops.h>
>>>> +#include <linux/virtio_mdev_ops.h>
>>>>   =20
>>>>    int  mdev_bus_register(void);
>>>>    void mdev_bus_unregister(void);
>>>> @@ -38,6 +39,7 @@ struct mdev_device {
>>>>    =09u16 class_id;
>>>>    =09union {
>>>>    =09=09const struct vfio_mdev_device_ops *vfio_ops;
>>>> +=09=09const struct virtio_mdev_device_ops *virtio_ops;
>>>>    =09};
>>>>    };
>>>>   =20
>>>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>>>> index 4625f1a11014..9b69b0bbebfd 100644
>>>> --- a/include/linux/mdev.h
>>>> +++ b/include/linux/mdev.h
>>>> @@ -17,6 +17,7 @@
>>>>   =20
>>>>    struct mdev_device;
>>>>    struct vfio_mdev_device_ops;
>>>> +struct virtio_mdev_device_ops;
>>>>   =20
>>>>    /*
>>>>     * Called by the parent device driver to set the device which repre=
sents
>>>> @@ -112,6 +113,10 @@ void mdev_set_class(struct mdev_device *mdev, u16=
 id);
>>>>    void mdev_set_vfio_ops(struct mdev_device *mdev,
>>>>    =09=09       const struct vfio_mdev_device_ops *vfio_ops);
>>>>    const struct vfio_mdev_device_ops *mdev_get_vfio_ops(struct mdev_de=
vice *mdev);
>>>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>>>> +=09=09=09 const struct virtio_mdev_device_ops *virtio_ops);
>>>> +const struct virtio_mdev_device_ops *
>>>> +mdev_get_virtio_ops(struct mdev_device *mdev);
>>>>   =20
>>>>    extern struct bus_type mdev_bus_type;
>>>>   =20
>>>> @@ -127,6 +132,7 @@ struct mdev_device *mdev_from_dev(struct device *d=
ev);
>>>>   =20
>>>>    enum {
>>>>    =09MDEV_CLASS_ID_VFIO =3D 1,
>>>> +=09MDEV_CLASS_ID_VIRTIO =3D 2,
>>>>    =09/* New entries must be added here */
>>>>    };
>>>>   =20
>>>> diff --git a/include/linux/virtio_mdev_ops.h b/include/linux/virtio_md=
ev_ops.h
>>>> new file mode 100644
>>>> index 000000000000..d417b41f2845
>>>> --- /dev/null
>>>> +++ b/include/linux/virtio_mdev_ops.h
>>>> @@ -0,0 +1,159 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>> +/*
>>>> + * Virtio mediated device driver
>>>> + *
>>>> + * Copyright 2019, Red Hat Corp.
>>>> + *     Author: Jason Wang<jasowang@redhat.com>
>>>> + */
>>>> +#ifndef _LINUX_VIRTIO_MDEV_H
>>>> +#define _LINUX_VIRTIO_MDEV_H
>>>> +
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/mdev.h>
>>>> +#include <uapi/linux/vhost.h>
>>>> +
>>>> +#define VIRTIO_MDEV_DEVICE_API_STRING=09=09"virtio-mdev"
>>>> +#define VIRTIO_MDEV_F_VERSION_1 0x1
>>>> +
>>>> +struct virtio_mdev_callback {
>>>> +=09irqreturn_t (*callback)(void *data);
>>>> +=09void *private;
>>>> +};
>>>> +
>>>> +/**
>>>> + * struct vfio_mdev_device_ops - Structure to be registered for each
>>>> + * mdev device to register the device for virtio/vhost drivers.
>>>> + *
>>>> + * The device ops that is supported by VIRTIO_MDEV_F_VERSION_1, the
>>>> + * callbacks are mandatory unless explicity mentioned.
>>> If the version of the callbacks is returned by a callback within the
>>> structure defined by the version... isn't that a bit circular?  This
>>> seems redundant to me versus the class id.  The fact that the parent
>>> driver defines the device as MDEV_CLASS_ID_VIRTIO should tell us this
>>> already.  If it was incremented, we'd need an MDEV_CLASS_ID_VIRTIOv2,
>>> which the virtio-mdev bus driver could add to its id table and handle
>>> differently.
>> My understanding is versions are only allowed to increase monotonically,
>> this seems less flexible than features. E.g we have features A, B, C,
>> mdev device can choose to support only a subset. E.g when mdev device
>> can support dirty page logging, it can add a new feature bit for driver
>> to know that it support new device ops. MDEV_CLASS_ID_VIRTIOv2 may only
>> be useful when we will invent a complete new API.
> But this interface rather conflates features and versions by returning
> a version as a feature.  If we simply want to say that there are no
> additional features, then get_mdev_features() should return an empty
> set.  If dirty page logging is a feature, then I'd expect a bit in the
> get_mdev_features() return value to identify that feature.
>
> However, I've been under the impression (perhaps wrongly) that the
> class-id has a 1:1 correlation to the device-ops exposed to the bus
> driver, so if dirty page logging requires extra callbacks, that would
> imply a new device-ops, which requires a new class-id.  In that case
> virtio-mdev would claim both class-ids and would need some way to
> differentiate them.  But I also see that such a solution can become
> unmanageable as the set of class-ids would need to encompass every
> combination of features.
>
> So I think what's suggested by this is that the initial struct
> virtio_mdev_device_ops is a base set of callbacks which would be
> extended via features?


Yes.


> But then why does get_generation() not make use
> of this?  And if we can define get_generation() as optional and simply
> test if it's implemented, then it seems we don't need any feature bits
> to extend the structure (unless we're looking at binary compatibility).


I think the mapping between ops and features is N:1. We start with a=20
base feature like VIRTIO_MDEV_VERSION_1, this allows us to do simply=20
checking during probe without the need to checking the existence of each=20
op. Testing the existence of a specific op should work but less=20
convenient when a feature requires several new ops. For the case of=20
get_generation(), it works because the bus driver have workaround when=20
parent doesn't provide that. This may not work for a real feature.


> So maybe get_mdev_features() is meant to expose underlying features
> unrelated to the callbacks?  Which is not in line with the description?


At least not for current virtio-mdev/vhost-mdev. Virtio specific=20
features should be done via get_features().


> Hopefully you can see my confusion in what we're trying to do here.


I think I get you and hope my answer make sense. Suggestions are welcomed.

Thanks


> Thanks,
>
> Alex
>

