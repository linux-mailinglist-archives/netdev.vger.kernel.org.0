Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A93FDE926
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfJUKNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:13:44 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbfJUKNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571652822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X10UFs7tuPUPd3D+40Rh0JtzksdyNoor8tHqygg664s=;
        b=VzqovNX1kVyNEwPu5L4CM2VOP8igO0KlQYVs3lnk4BhYL26zxXUVbVBKMCHB0dLvuwWFGa
        kUjeqO3cT1wqtG86g5HYOt+qxEdBbokRKINfA2KmLI4lTx2ZLEIzF/ozdAnXtlYwyBUUAl
        FFpb4zmKpPfk/X9jNeuCIQVPVcHcAv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-L7NxpIXqPOmlWs4WJm5E6w-1; Mon, 21 Oct 2019 06:13:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE1ED800D49;
        Mon, 21 Oct 2019 10:13:34 +0000 (UTC)
Received: from [10.72.12.22] (ovpn-12-22.pek2.redhat.com [10.72.12.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A0AB5D70E;
        Mon, 21 Oct 2019 10:13:03 +0000 (UTC)
Subject: Re: [PATCH V4 5/6] virtio: introduce a mdev based transport
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191017104836.32464-1-jasowang@redhat.com>
 <20191017104836.32464-6-jasowang@redhat.com>
 <20191018162007.31631039.cohuck@redhat.com>
 <2bb5645b-5c46-9cae-0571-65c302f51cf2@redhat.com>
 <20191021113607.16b26d9d.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1aa59fea-cae5-6303-4a94-51493d5748ba@redhat.com>
Date:   Mon, 21 Oct 2019 18:13:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021113607.16b26d9d.cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: L7NxpIXqPOmlWs4WJm5E6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/21 =E4=B8=8B=E5=8D=885:36, Cornelia Huck wrote:
> On Mon, 21 Oct 2019 13:59:23 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2019/10/18 =E4=B8=8B=E5=8D=8810:20, Cornelia Huck wrote:
>>> On Thu, 17 Oct 2019 18:48:35 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>  =20
>>>> This patch introduces a new mdev transport for virtio. This is used to
>>>> use kernel virtio driver to drive the mediated device that is capable
>>>> of populating virtqueue directly.
>>>>
>>>> A new virtio-mdev driver will be registered to the mdev bus, when a
>>>> new virtio-mdev device is probed, it will register the device with
>>>> mdev based config ops. This means it is a software transport between
>>>> mdev driver and mdev device. The transport was implemented through
>>>> device specific ops which is a part of mdev_parent_ops now.
>>>>
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>> ---
>>>>    drivers/virtio/Kconfig       |   7 +
>>>>    drivers/virtio/Makefile      |   1 +
>>>>    drivers/virtio/virtio_mdev.c | 409 ++++++++++++++++++++++++++++++++=
+++
>>>>    3 files changed, 417 insertions(+)
>>> (...)
>>>  =20
>>>> +static int virtio_mdev_probe(struct device *dev)
>>>> +{
>>>> +=09struct mdev_device *mdev =3D mdev_from_dev(dev);
>>>> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(mdev=
);
>>>> +=09struct virtio_mdev_device *vm_dev;
>>>> +=09int rc;
>>>> +
>>>> +=09vm_dev =3D devm_kzalloc(dev, sizeof(*vm_dev), GFP_KERNEL);
>>>> +=09if (!vm_dev)
>>>> +=09=09return -ENOMEM;
>>>> +
>>>> +=09vm_dev->vdev.dev.parent =3D dev;
>>>> +=09vm_dev->vdev.dev.release =3D virtio_mdev_release_dev;
>>>> +=09vm_dev->vdev.config =3D &virtio_mdev_config_ops;
>>>> +=09vm_dev->mdev =3D mdev;
>>>> +=09INIT_LIST_HEAD(&vm_dev->virtqueues);
>>>> +=09spin_lock_init(&vm_dev->lock);
>>>> +
>>>> +=09vm_dev->version =3D ops->get_mdev_features(mdev);
>>>> +=09if (vm_dev->version !=3D VIRTIO_MDEV_F_VERSION_1) {
>>>> +=09=09dev_err(dev, "VIRTIO_MDEV_F_VERSION_1 is mandatory\n");
>>>> +=09=09return -ENXIO;
>>>> +=09}
>>> Hm, so how is that mdev features interface supposed to work? If
>>> VIRTIO_MDEV_F_VERSION_1 is a bit, I would expect this code to test for
>>> its presence, and not for identity.
>>
>> This should be used by driver to detect the which sets of functions and
>> their semantics that could be provided by the device. E.g when driver
>> support both version 2 and version 1 but device only support version 1,
>> driver can switch to use version 1. Btw, Is there a easy way for to test
>> its presence or do you mean doing sanity testing on existence of the
>> mandatory ops that provided by the device?
> What I meant was something like:
>
> features =3D ops->get_mdev_features(mdev);
> if (features & VIRTIO_MDEV_F_VERSION_1)
> =09vm_dev->version =3D 1;
> else
> =09//moan about missing support for version 1
>
> Can there be class id specific extra features, or is this only for core
> features? If the latter, maybe also do something like
>
> supported_features =3D ORED_LIST_OF_FEATURES;
> if (features & ~supported_features)
> =09//moan about extra feature bits


Consider driver can claim to support a list of ids, so I this it's former.

Will do as what you proposed.

Thanks


>
>>
>>> What will happen if we come up with a version 2? If this is backwards
>>> compatible, will both version 2 and version 1 be set?
>>
>> Yes, I think so, and version 2 should be considered as some extensions
>> of version 1. If it's completely, it should use a new class id.
> Ok, that makes sense.
>

