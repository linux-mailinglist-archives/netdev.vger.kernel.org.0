Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01438DE3D1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfJUFhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:37:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725843AbfJUFhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571636250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tE5uTCurAopRyTHOj2V6FdY3SscvJMRhHjElCkCREn4=;
        b=IqV3/p4BZR97uCK2aub+XqX2z4qvhO2ay37iqpEzBvjFBR57s/itzcUiA3UOjlZTkwtOS9
        iMQxcafoEG4g7bj4KNxMBmgsp02pFRb+iVI1hglF5gxEz2LGiCnMV9dzz6ZQpFqtjFa5qT
        ZFYzjVhpxxnQC4zwf3ZhDN0lcCHGpe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-e3ln3-26PuSaJTQN-5zngA-1; Mon, 21 Oct 2019 01:37:26 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E079107AD31;
        Mon, 21 Oct 2019 05:37:22 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B9D360BE2;
        Mon, 21 Oct 2019 05:36:21 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] mdev: introduce virtio device and its device ops
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
 <20191017104836.32464-5-jasowang@redhat.com>
 <20191018114614.6f1e79dc.cohuck@redhat.com>
 <733c0cfe-064f-c8ba-6bf8-165db88d7e07@redhat.com>
 <20191018153042.3516cde1.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4a34d071-2e78-c37c-1046-7f9f6bb9e67f@redhat.com>
Date:   Mon, 21 Oct 2019 13:36:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191018153042.3516cde1.cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: e3ln3-26PuSaJTQN-5zngA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/18 =E4=B8=8B=E5=8D=889:30, Cornelia Huck wrote:
> On Fri, 18 Oct 2019 18:55:02 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2019/10/18 =E4=B8=8B=E5=8D=885:46, Cornelia Huck wrote:
>>> On Thu, 17 Oct 2019 18:48:34 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>> + * @get_vendor_id:=09=09Get virtio vendor id
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09Returns u32: virtio vendor id
>>> How is the vendor id defined? As for normal virtio-pci devices?
>>
>> The vendor that provides this device. So something like this
>>
>> I notice that MMIO also had this so it looks to me it's not pci specific=
.
> Ok. Would be good to specify this more explicitly.


Ok.


>
>>
>>>  =20
>>>> + * @get_status: =09=09Get the device status
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09Returns u8: virtio device status
>>>> + * @set_status: =09=09Set the device status
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09@status: virtio device status
>>>> + * @get_config: =09=09Read from device specific configuration space
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09@offset: offset from the beginning of
>>>> + *=09=09=09=09configuration space
>>>> + *=09=09=09=09@buf: buffer used to read to
>>>> + *=09=09=09=09@len: the length to read from
>>>> + *=09=09=09=09configration space
>>>> + * @set_config: =09=09Write to device specific configuration space
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09@offset: offset from the beginning of
>>>> + *=09=09=09=09configuration space
>>>> + *=09=09=09=09@buf: buffer used to write from
>>>> + *=09=09=09=09@len: the length to write to
>>>> + *=09=09=09=09configration space
>>>> + * @get_mdev_features:=09=09Get the feature of virtio mdev device
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09Returns the mdev features (API) support by
>>>> + *=09=09=09=09the device.
>>> What kind of 'features' are supposed to go in there? Are these bits,
>>> like you defined for VIRTIO_MDEV_F_VERSION_1 above?
>>
>> It's the API or mdev features other than virtio features. It could be
>> used by driver to determine the capability of the mdev device. Besides
>> _F_VERSION_1, we may add dirty page tracking etc which means we need new
>> device ops.
> Ok, so that's supposed to be distinct bits that can be or'ed together?


Yes.


> Makes sense, but probably needs some more documentation somewhere.


Let me add some doc above this helper.


>
>>
>>>  =20
>>>> + * @get_generation:=09=09Get device generaton
>>>> + *=09=09=09=09@mdev: mediated device
>>>> + *=09=09=09=09Returns u32: device generation
>>> Is that callback mandatory?
>>
>> I think so, it's hard to emulate that completely in virtio-mdev transpor=
t.
> IIRC, the generation stuff is not mandatory in the current version of
> virtio, as not all transports have that concept.


It looks to me we can have workaround as what has been done by virtio.c.=20
Return 0 if this helper is not provided.


>
> Generally, are any of the callbacks optional, or are all of them
> mandatory? From what I understand, you plan to add new things that
> depend on features... would that mean non-mandatory callbacks?


Yes, not all of them were mandatory, I will explicit explain which are=20
mandatory and which are not.

Thanks


