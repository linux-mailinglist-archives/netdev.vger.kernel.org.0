Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A86B6EACE1
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjDUO3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjDUO3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:29:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F91187
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682087309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gh2FKDIw04E1Y2danPvwRc3umx0NY4oLoGalTyKkosA=;
        b=bDyTg0cm2eUs/tUKqL+haN1CEqvXh5XnPqYJRAZ9kFSpOp7TTRyMS8X2VwItDHoQOBhcEN
        zBddQzP+qHjwo/aee2hqJwfNm5/YhGkLIZQE/zwTJaJahZwLkrthRHObBJG1UJc4Wvgomp
        f8WQ/3QJl27ZxmV5jywqfKAoArgBu9s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-gToPFlIiNMmobDwMQ3Dsdw-1; Fri, 21 Apr 2023 10:28:26 -0400
X-MC-Unique: gToPFlIiNMmobDwMQ3Dsdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF57838123CC;
        Fri, 21 Apr 2023 14:28:25 +0000 (UTC)
Received: from [10.39.208.29] (unknown [10.39.208.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C80E2C08492;
        Fri, 21 Apr 2023 14:28:23 +0000 (UTC)
Message-ID: <88a24206-b576-efc6-1bce-7f5075024c63@redhat.com>
Date:   Fri, 21 Apr 2023 16:28:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, xieyongji@bytedance.com
Cc:     mst@redhat.com, david.marchand@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        Peter Xu <peterx@redhat.com>
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com>
 <d7530c13-f1a1-311e-7d5e-8e65f3bc2e50@redhat.com>
 <CACGkMEuWpHokhwvJ5cF41_C=ezqFhoOyUOposdZ5+==A642OmQ@mail.gmail.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
In-Reply-To: <CACGkMEuWpHokhwvJ5cF41_C=ezqFhoOyUOposdZ5+==A642OmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/23 07:51, Jason Wang wrote:
> On Thu, Apr 20, 2023 at 10:16 PM Maxime Coquelin
> <maxime.coquelin@redhat.com> wrote:
>>
>>
>>
>> On 4/20/23 06:34, Jason Wang wrote:
>>> On Wed, Apr 19, 2023 at 9:43 PM Maxime Coquelin
>>> <maxime.coquelin@redhat.com> wrote:
>>>>
>>>> This small series enables virtio-net device type in VDUSE.
>>>> With it, basic operation have been tested, both with
>>>> virtio-vdpa and vhost-vdpa using DPDK Vhost library series
>>>> adding VDUSE support [0] using split rings layout.
>>>>
>>>> Control queue support (and so multiqueue) has also been
>>>> tested, but require a Kernel series from Jason Wang
>>>> relaxing control queue polling [1] to function reliably.
>>>>
>>>> Other than that, we have identified a few gaps:
>>>>
>>>> 1. Reconnection:
>>>>    a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
>>>>       index, even after the virtqueue has already been
>>>>       processed. Is that expected? I have tried instead to
>>>>       get the driver's avail index directly from the avail
>>>>       ring, but it does not seem reliable as I sometimes get
>>>>       "id %u is not a head!\n" warnings. Also such solution
>>>>       would not be possible with packed ring, as we need to
>>>>       know the wrap counters values.
>>>
>>> Looking at the codes, it only returns the value that is set via
>>> set_vq_state(). I think it is expected to be called before the
>>> datapath runs.
>>>
>>> So when bound to virtio-vdpa, it is expected to return 0. But we need
>>> to fix the packed virtqueue case, I wonder if we need to call
>>> set_vq_state() explicitly in virtio-vdpa before starting the device.
>>>
>>> When bound to vhost-vdpa, Qemu will call VHOST_SET_VRING_BASE which
>>> will end up a call to set_vq_state(). Unfortunately, it doesn't
>>> support packed ring which needs some extension.
>>>
>>>>
>>>>    b. Missing IOCTLs: it would be handy to have new IOCTLs to
>>>>       query Virtio device status,
>>>
>>> What's the use case of this ioctl? It looks to me userspace is
>>> notified on each status change now:
>>>
>>> static int vduse_dev_set_status(struct vduse_dev *dev, u8 status)
>>> {
>>>           struct vduse_dev_msg msg = { 0 };
>>>
>>>           msg.req.type = VDUSE_SET_STATUS;
>>>           msg.req.s.status = status;
>>>
>>>           return vduse_dev_msg_sync(dev, &msg);
>>> }
>>
>> The idea was to be able to query the status at reconnect time, and
>> neither having to assume its value nor having to store its value in a
>> file (the status could change while the VDUSE application is stopped,
>> but maybe it would receive the notification at reconnect).
> 
> I see.
> 
>>
>> I will prototype using a tmpfs file to save needed information, and see
>> if it works.
> 
> It might work but then the API is not self contained. Maybe it's
> better to have a dedicated ioctl.
> 
>>
>>>> and retrieve the config
>>>>       space set at VDUSE_CREATE_DEV time.
>>>
>>> In order to be safe, VDUSE avoids writable config space. Otherwise
>>> drivers could block on config writing forever. That's why we don't do
>>> it now.
>>
>> The idea was not to make the config space writable, but just to be able
>> to fetch what was filled at VDUSE_CREATE_DEV time.
>>
>> With the tmpfs file, we can avoid doing that and just save the config
>> space there.
> 
> Same as the case for status.

I have cooked a DPDK patch to support reconnect with a tmpfs file as
suggested by Yongji:

https://gitlab.com/mcoquelin/dpdk-next-virtio/-/commit/53913f2b1155b02c44d5d3d298aafd357e7a8c48

That's still rough around the edges, but it seems to work reliably
for the testing I have done so far. We'll certainly want to use the
tmpfs memory to directly store available indexes and wrap counters to
avoid introducing overhead in the datapath. The tricky part will be to
manage NUMA affinity.

Regards,
Maxime

> 
> Thanks
> 
>>
>>> We need to harden the config write before we can proceed to this I think.
>>>
>>>>
>>>> 2. VDUSE application as non-root:
>>>>     We need to run the VDUSE application as non-root. There
>>>>     is some race between the time the UDEV rule is applied
>>>>     and the time the device starts being used. Discussing
>>>>     with Jason, he suggested we may have a VDUSE daemon run
>>>>     as root that would create the VDUSE device, manages its
>>>>     rights and then pass its file descriptor to the VDUSE
>>>>     app. However, with current IOCTLs, it means the VDUSE
>>>>     daemon would need to know several information that
>>>>     belongs to the VDUSE app implementing the device such
>>>>     as supported Virtio features, config space, etc...
>>>>     If we go that route, maybe we should have a control
>>>>     IOCTL to create the device which would just pass the
>>>>     device type. Then another device IOCTL to perform the
>>>>     initialization. Would that make sense?
>>>
>>> I think so. We can hear from others.
>>>
>>>>
>>>> 3. Coredump:
>>>>     In order to be able to perform post-mortem analysis, DPDK
>>>>     Vhost library marks pages used for vrings and descriptors
>>>>     buffers as MADV_DODUMP using madvise(). However with
>>>>     VDUSE it fails with -EINVAL. My understanding is that we
>>>>     set VM_DONTEXPAND flag to the VMAs and madvise's
>>>>     MADV_DODUMP fails if it is present. I'm not sure to
>>>>     understand why madvise would prevent MADV_DODUMP if
>>>>     VM_DONTEXPAND is set. Any thoughts?
>>>
>>> Adding Peter who may know the answer.
>>
>> Thanks!
>> Maxime
>>
>>> Thanks
>>>
>>>>
>>>> [0]: https://patchwork.dpdk.org/project/dpdk/list/?series=27594&state=%2A&archive=both
>>>> [1]: https://lore.kernel.org/lkml/CACGkMEtgrxN3PPwsDo4oOsnsSLJfEmBEZ0WvjGRr3whU+QasUg@mail.gmail.com/T/
>>>>
>>>> Maxime Coquelin (2):
>>>>     vduse: validate block features only with block devices
>>>>     vduse: enable Virtio-net device type
>>>>
>>>>    drivers/vdpa/vdpa_user/vduse_dev.c | 11 +++++++----
>>>>    1 file changed, 7 insertions(+), 4 deletions(-)
>>>>
>>>> --
>>>> 2.39.2
>>>>
>>>
>>
> 

