Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC0F32CE62
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhCDI0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:26:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236667AbhCDIZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614846274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6IclWwaawMHCNvxX8I+oUb0tVcPL3WS0YV84m0Vq1gk=;
        b=BCTSpy8JoHlecnkoXZl5i6K+PYLiprzsiqog6Gc3OXh1KwxGNtvKg3vafuAsyw+EBowyG1
        6y7r6StAl5cxZnhhSC9gXSIzr8fClcNnJtqTioQCtpdMaH7VnWv1IEVdaQfcz+PubkKil/
        3eOt+SEcNXWdi1iYlw2DwwOmYtXx1us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-bdUaXeI-Oi2FndwzEeR6Cw-1; Thu, 04 Mar 2021 03:24:31 -0500
X-MC-Unique: bdUaXeI-Oi2FndwzEeR6Cw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24ABC107AFDF;
        Thu,  4 Mar 2021 08:24:30 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 093815D9C6;
        Thu,  4 Mar 2021 08:24:17 +0000 (UTC)
Subject: Re: [virtio-dev] Re: [PATCH] vdpa/mlx5: set_features should allow
 reset to zero
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
References: <20210223041740-mutt-send-email-mst@kernel.org>
 <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
 <20210223110430.2f098bc0.cohuck@redhat.com>
 <bbb0a09e-17e1-a397-1b64-6ce9afe18e44@redhat.com>
 <20210223115833.732d809c.cohuck@redhat.com>
 <8355f9b3-4cda-cd2e-98df-fed020193008@redhat.com>
 <20210224121234.0127ae4b.cohuck@redhat.com>
 <be6713d3-ac98-bbbf-1dc1-a003ed06a156@redhat.com>
 <20210225135229-mutt-send-email-mst@kernel.org>
 <0f8eb381-cc98-9e05-0e35-ccdb1cbd6119@redhat.com>
 <20210228162306-mutt-send-email-mst@kernel.org>
 <cdd72199-ac7b-cc8d-2c40-81e43162c532@redhat.com>
 <20210302130812.6227f176.cohuck@redhat.com>
 <5f6972fe-7246-b622-958d-9cab8dd98e21@redhat.com>
 <20210303092905.677eb66c.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1b5b3f9b-41d7-795c-c677-c45f1d5a774e@redhat.com>
Date:   Thu, 4 Mar 2021 16:24:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303092905.677eb66c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/3 4:29 下午, Cornelia Huck wrote:
> On Wed, 3 Mar 2021 12:01:01 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2021/3/2 8:08 下午, Cornelia Huck wrote:
>>> On Mon, 1 Mar 2021 11:51:08 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>   
>>>> On 2021/3/1 5:25 上午, Michael S. Tsirkin wrote:
>>>>> On Fri, Feb 26, 2021 at 04:19:16PM +0800, Jason Wang wrote:
>>>>>> On 2021/2/26 2:53 上午, Michael S. Tsirkin wrote:
>>>>>>> Confused. What is wrong with the above? It never reads the
>>>>>>> field unless the feature has been offered by device.
>>>>>> So the spec said:
>>>>>>
>>>>>> "
>>>>>>
>>>>>> The following driver-read-only field, max_virtqueue_pairs only exists if
>>>>>> VIRTIO_NET_F_MQ is set.
>>>>>>
>>>>>> "
>>>>>>
>>>>>> If I read this correctly, there will be no max_virtqueue_pairs field if the
>>>>>> VIRTIO_NET_F_MQ is not offered by device? If yes the offsetof() violates
>>>>>> what spec said.
>>>>>>
>>>>>> Thanks
>>>>> I think that's a misunderstanding. This text was never intended to
>>>>> imply that field offsets change beased on feature bits.
>>>>> We had this pain with legacy and we never wanted to go back there.
>>>>>
>>>>> This merely implies that without VIRTIO_NET_F_MQ the field
>>>>> should not be accessed. Exists in the sense "is accessible to driver".
>>>>>
>>>>> Let's just clarify that in the spec, job done.
>>>> Ok, agree. That will make things more eaiser.
>>> Yes, that makes much more sense.
>>>
>>> What about adding the following to the "Basic Facilities of a Virtio
>>> Device/Device Configuration Space" section of the spec:
>>>
>>> "If an optional configuration field does not exist, the corresponding
>>> space is still present, but reserved."
>>
>> This became interesting after re-reading some of the qemu codes.
>>
>> E.g in virtio-net.c we had:
>>
>> *static VirtIOFeature feature_sizes[] = {
>>       {.flags = 1ULL << VIRTIO_NET_F_MAC,
>>        .end = endof(struct virtio_net_config, mac)},
>>       {.flags = 1ULL << VIRTIO_NET_F_STATUS,
>>        .end = endof(struct virtio_net_config, status)},
>>       {.flags = 1ULL << VIRTIO_NET_F_MQ,
>>        .end = endof(struct virtio_net_config, max_virtqueue_pairs)},
>>       {.flags = 1ULL << VIRTIO_NET_F_MTU,
>>        .end = endof(struct virtio_net_config, mtu)},
>>       {.flags = 1ULL << VIRTIO_NET_F_SPEED_DUPLEX,
>>        .end = endof(struct virtio_net_config, duplex)},
>>       {.flags = (1ULL << VIRTIO_NET_F_RSS) | (1ULL <<
>> VIRTIO_NET_F_HASH_REPORT),
>>        .end = endof(struct virtio_net_config, supported_hash_types)},
>>       {}
>> };*
>>
>> *It has a implict dependency chain. E.g MTU doesn't presnet if
>> DUPLEX/RSS is not offered ...
>> *
> But I think it covers everything up to the relevant field, no? So MTU
> is included if we have the feature bit, even if we don't have
> DUPLEX/RSS.
>
> Given that a config space may be shorter (but must not collapse
> non-existing fields), maybe a better wording would be:
>
> "If an optional configuration field does not exist, the corresponding
> space will still be present if it is not at the end of the
> configuration space (i.e., further configuration fields exist.)


This should work but I think we need to define the end of configuration 
space first?


> This
> implies that a given field, if it exists, is always at the same offset
> from the beginning of the configuration space."
>
>
>>> (Do we need to specify what a device needs to do if the driver tries to
>>> access a non-existing field? We cannot really make assumptions about
>>> config space accesses; virtio-ccw can just copy a chunk of config space
>>> that contains non-existing fields...
>>
>> Right, it looks to me ccw doesn't depends on config len which is kind of
>> interesting. I think the answer depends on the implementation of both
>> transport and device:
> (virtio-ccw is a bit odd, because channel I/O does not have the concept
> of a config space and I needed to come up with something)


Ok.


>
>> Let's take virtio-net-pci as an example, it fills status unconditionally
>> in virtio_net_set_config() even if VIRTIO_NET_F_STATUS is not
>> negotiated. So with the above feature_sizes:
>>
>> 1) if one of the MQ, MTU, DUPLEX or RSS is implemented, driver can still
>> read status in this case
>> 2) if none of the above four is negotied, driver can only read a 0xFF
>> (virtio_config_readb())
>>
>>
>>> I guess the device could ignore
>>> writes and return zeroes on read?)
>>
>> So consider the above, it might be too late to fix/clarify that in the
>> spec on the expected behaviour of reading/writing non-exist fields.
> We could still advise behaviour via SHOULD, though I'm not sure it adds
> much at this point in time.
>
> It really feels a bit odd that a driver can still read and write fields
> for features that it did not negotiate, but I fear we're stuck with it.


Yes, since the device (at least virtio-pci) implment thing like this.

Thanks


>
>> Thanks
>>
>>
>>> I've opened https://github.com/oasis-tcs/virtio-spec/issues/98 for the
>>> spec issues.
>>>   
>
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
>

