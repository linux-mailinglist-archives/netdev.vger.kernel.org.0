Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113DFF16C5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 14:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbfKFNMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 08:12:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726785AbfKFNMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 08:12:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573045935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XdTny3tr4ABNNp/+zCwTPKTknb73JdloNxApkDn3UmA=;
        b=K490SRJWkOW5mndEW2546x8Wl0YDTcA0kSmp5RT6qlTzEnQwJ/MU/9+6kAPrfYnrxM54Lr
        g+qmRwvOW89oX3kwmaJ5+x8D7mNI5RUYqg0C7+F2S8yQMsWZALC/EWxcpU+R+rFXybtwR7
        kwweT1O5J+jex77DCFuWG9+GlgKWFJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-zNgOzN6XN_Wyyhw7iMVyjw-1; Wed, 06 Nov 2019 08:12:12 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B0E68017E0;
        Wed,  6 Nov 2019 13:12:08 +0000 (UTC)
Received: from [10.72.12.193] (ovpn-12-193.pek2.redhat.com [10.72.12.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 452135D9CD;
        Wed,  6 Nov 2019 13:11:21 +0000 (UTC)
Subject: Re: [PATCH V9 5/6] virtio: introduce a mdev based transport
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
References: <20191106070548.18980-1-jasowang@redhat.com>
 <20191106070548.18980-6-jasowang@redhat.com>
 <20191106120047.5bcf49c3.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <46df7afa-7543-ce19-7ede-9041907e2730@redhat.com>
Date:   Wed, 6 Nov 2019 21:11:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106120047.5bcf49c3.cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: zNgOzN6XN_Wyyhw7iMVyjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/6 =E4=B8=8B=E5=8D=887:00, Cornelia Huck wrote:
> On Wed,  6 Nov 2019 15:05:47 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> This patch introduces a new mdev transport for virtio. This is used to
>> use kernel virtio driver to drive the mediated device that is capable
>> of populating virtqueue directly.
>>
>> A new virtio-mdev driver will be registered to the mdev bus, when a
>> new virtio-mdev device is probed, it will register the device with
>> mdev based config ops. This means it is a software transport between
>> mdev driver and mdev device. The transport was implemented through
>> device specific ops which is a part of mdev_parent_ops now.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/virtio/Kconfig       |  13 ++
>>   drivers/virtio/Makefile      |   1 +
>>   drivers/virtio/virtio_mdev.c | 406 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 420 insertions(+)
>>   create mode 100644 drivers/virtio/virtio_mdev.c
>>
>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 078615cf2afc..558ac607d107 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -43,6 +43,19 @@ config VIRTIO_PCI_LEGACY
>>  =20
>>   =09  If unsure, say Y.
>>  =20
>> +config VIRTIO_MDEV
>> +=09tristate "MDEV driver for virtio devices"
>> +=09depends on VFIO_MDEV && VIRTIO
>> +=09default n
>> +=09help
>> +=09  This driver provides support for virtio based paravirtual
>> +=09  device driver over MDEV bus. This requires your environemnt
>> +=09  has appropriate virtio mdev device implementation which may
>> +=09  operate on the physical device that the datapath of virtio
>> +=09  could be offloaded to hardware.
> That sentence is a bit confusing to me... what about
>
> "For this to be useful, you need an appropriate virtio mdev device
> implementation that operates on a physical device to allow the datapath
> of virtio to be offloaded to hardware."
>
> ?
>
>> +
>> +=09  If unsure, say M
> Building this as a module should not hurt (but please add a trailing
> '.' here :)
>
>> +
>>   config VIRTIO_PMEM
>>   =09tristate "Support for virtio pmem driver"
>>   =09depends on VIRTIO
> With the changes above,
>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>

Will post V10.

Thanks

