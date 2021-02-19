Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA4D31F420
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 04:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhBSDMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 22:12:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhBSDMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 22:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613704263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eP2axzNlhzKcGsgpxzxoIxCrLLwqvlbRtVBmxSLwQiQ=;
        b=Noj54tVLyR/79WNZXrRrrCPobGSY0m2jsDH1YOMa9CxZbfnyhjA7A9/8EA/nkECfJRNEVR
        9gPf/0Y8fyZOec0GoBlx3dOKah8ePmuZ+FegWPhjH1PAA38pr0hMATRtb/ZUMGSENyC0Yk
        s8EUzSCv2EmHLlkpGV5dbWi1eEQVpxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-K9zKQWvTMqeeATTCwGPmEw-1; Thu, 18 Feb 2021 22:11:00 -0500
X-MC-Unique: K9zKQWvTMqeeATTCwGPmEw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE66F80196C;
        Fri, 19 Feb 2021 03:10:59 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8B485D9C2;
        Fri, 19 Feb 2021 03:10:52 +0000 (UTC)
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
 <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
 <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
 <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
 <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
 <740b4f73-c668-5e0e-5af2-ebea7528d7a2@redhat.com>
 <9243c03b-8490-523c-2b78-928d1bcb0ddd@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b2d18964-8cd6-6bb1-1995-5b966207046d@redhat.com>
Date:   Fri, 19 Feb 2021 11:10:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9243c03b-8490-523c-2b78-928d1bcb0ddd@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/18 8:43 下午, Si-Wei Liu wrote:
>
>
> On 2/17/2021 8:44 PM, Jason Wang wrote:
>>
>> On 2021/2/10 下午4:59, Si-Wei Liu wrote:
>>>
>>>
>>> On 2/9/2021 7:53 PM, Jason Wang wrote:
>>>>
>>>> On 2021/2/10 上午10:30, Si-Wei Liu wrote:
>>>>>
>>>>>
>>>>> On 2/8/2021 10:37 PM, Jason Wang wrote:
>>>>>>
>>>>>> On 2021/2/9 下午2:12, Eli Cohen wrote:
>>>>>>> On Tue, Feb 09, 2021 at 11:20:14AM +0800, Jason Wang wrote:
>>>>>>>> On 2021/2/8 下午6:04, Eli Cohen wrote:
>>>>>>>>> On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
>>>>>>>>>> On 2021/2/8 下午2:37, Eli Cohen wrote:
>>>>>>>>>>> On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrote:
>>>>>>>>>>>> On 2021/2/6 上午7:07, Si-Wei Liu wrote:
>>>>>>>>>>>>> On 2/3/2021 11:36 PM, Eli Cohen wrote:
>>>>>>>>>>>>>> When a change of memory map occurs, the hardware 
>>>>>>>>>>>>>> resources are destroyed
>>>>>>>>>>>>>> and then re-created again with the new memory map. In 
>>>>>>>>>>>>>> such case, we need
>>>>>>>>>>>>>> to restore the hardware available and used indices. The 
>>>>>>>>>>>>>> driver failed to
>>>>>>>>>>>>>> restore the used index which is added here.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Also, since the driver also fails to reset the available 
>>>>>>>>>>>>>> and used
>>>>>>>>>>>>>> indices upon device reset, fix this here to avoid 
>>>>>>>>>>>>>> regression caused by
>>>>>>>>>>>>>> the fact that used index may not be zero upon device reset.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for 
>>>>>>>>>>>>>> supported mlx5
>>>>>>>>>>>>>> devices")
>>>>>>>>>>>>>> Signed-off-by: Eli Cohen<elic@nvidia.com>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>> v0 -> v1:
>>>>>>>>>>>>>> Clear indices upon device reset
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>      drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 
>>>>>>>>>>>>>> ++++++++++++++++++
>>>>>>>>>>>>>>      1 file changed, 18 insertions(+)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>>> index 88dde3455bfd..b5fe6d2ad22f 100644
>>>>>>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>>> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>>>>>>>>>>>>>>          u64 device_addr;
>>>>>>>>>>>>>>          u64 driver_addr;
>>>>>>>>>>>>>>          u16 avail_index;
>>>>>>>>>>>>>> +    u16 used_index;
>>>>>>>>>>>>>>          bool ready;
>>>>>>>>>>>>>>          struct vdpa_callback cb;
>>>>>>>>>>>>>>          bool restore;
>>>>>>>>>>>>>> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>>>>>>>>>>>>>>          u32 virtq_id;
>>>>>>>>>>>>>>          struct mlx5_vdpa_net *ndev;
>>>>>>>>>>>>>>          u16 avail_idx;
>>>>>>>>>>>>>> +    u16 used_idx;
>>>>>>>>>>>>>>          int fw_state;
>>>>>>>>>>>>>>            /* keep last in the struct */
>>>>>>>>>>>>>> @@ -804,6 +806,7 @@ static int create_virtqueue(struct 
>>>>>>>>>>>>>> mlx5_vdpa_net
>>>>>>>>>>>>>> *ndev, struct mlx5_vdpa_virtque
>>>>>>>>>>>>>>            obj_context = 
>>>>>>>>>>>>>> MLX5_ADDR_OF(create_virtio_net_q_in, in,
>>>>>>>>>>>>>> obj_context);
>>>>>>>>>>>>>>          MLX5_SET(virtio_net_q_object, obj_context, 
>>>>>>>>>>>>>> hw_available_index,
>>>>>>>>>>>>>> mvq->avail_idx);
>>>>>>>>>>>>>> +    MLX5_SET(virtio_net_q_object, obj_context, 
>>>>>>>>>>>>>> hw_used_index,
>>>>>>>>>>>>>> mvq->used_idx);
>>>>>>>>>>>>>>          MLX5_SET(virtio_net_q_object, obj_context,
>>>>>>>>>>>>>> queue_feature_bit_mask_12_3,
>>>>>>>>>>>>>> get_features_12_3(ndev->mvdev.actual_features));
>>>>>>>>>>>>>>          vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, 
>>>>>>>>>>>>>> obj_context,
>>>>>>>>>>>>>> virtio_q_context);
>>>>>>>>>>>>>> @@ -1022,6 +1025,7 @@ static int connect_qps(struct 
>>>>>>>>>>>>>> mlx5_vdpa_net
>>>>>>>>>>>>>> *ndev, struct mlx5_vdpa_virtqueue *m
>>>>>>>>>>>>>>      struct mlx5_virtq_attr {
>>>>>>>>>>>>>>          u8 state;
>>>>>>>>>>>>>>          u16 available_index;
>>>>>>>>>>>>>> +    u16 used_index;
>>>>>>>>>>>>>>      };
>>>>>>>>>>>>>>        static int query_virtqueue(struct mlx5_vdpa_net 
>>>>>>>>>>>>>> *ndev, struct
>>>>>>>>>>>>>> mlx5_vdpa_virtqueue *mvq,
>>>>>>>>>>>>>> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct
>>>>>>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>>>>>>>>>>>>>>          memset(attr, 0, sizeof(*attr));
>>>>>>>>>>>>>>          attr->state = MLX5_GET(virtio_net_q_object, 
>>>>>>>>>>>>>> obj_context, state);
>>>>>>>>>>>>>>          attr->available_index = 
>>>>>>>>>>>>>> MLX5_GET(virtio_net_q_object,
>>>>>>>>>>>>>> obj_context, hw_available_index);
>>>>>>>>>>>>>> +    attr->used_index = MLX5_GET(virtio_net_q_object, 
>>>>>>>>>>>>>> obj_context,
>>>>>>>>>>>>>> hw_used_index);
>>>>>>>>>>>>>>          kfree(out);
>>>>>>>>>>>>>>          return 0;
>>>>>>>>>>>>>>      @@ -1535,6 +1540,16 @@ static void 
>>>>>>>>>>>>>> teardown_virtqueues(struct
>>>>>>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>>>>>>          }
>>>>>>>>>>>>>>      }
>>>>>>>>>>>>>>      +static void clear_virtqueues(struct mlx5_vdpa_net 
>>>>>>>>>>>>>> *ndev)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +    int i;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>>>>>>>>>>>>>> +        ndev->vqs[i].avail_idx = 0;
>>>>>>>>>>>>>> +        ndev->vqs[i].used_idx = 0;
>>>>>>>>>>>>>> +    }
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>      /* TODO: cross-endian support */
>>>>>>>>>>>>>>      static inline bool mlx5_vdpa_is_little_endian(struct 
>>>>>>>>>>>>>> mlx5_vdpa_dev
>>>>>>>>>>>>>> *mvdev)
>>>>>>>>>>>>>>      {
>>>>>>>>>>>>>> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct
>>>>>>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>>>>>>>>>>>>>>              return err;
>>>>>>>>>>>>>>            ri->avail_index = attr.available_index;
>>>>>>>>>>>>>> +    ri->used_index = attr.used_index;
>>>>>>>>>>>>>>          ri->ready = mvq->ready;
>>>>>>>>>>>>>>          ri->num_ent = mvq->num_ent;
>>>>>>>>>>>>>>          ri->desc_addr = mvq->desc_addr;
>>>>>>>>>>>>>> @@ -1654,6 +1670,7 @@ static void 
>>>>>>>>>>>>>> restore_channels_info(struct
>>>>>>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>>>>>>                  continue;
>>>>>>>>>>>>>>                mvq->avail_idx = ri->avail_index;
>>>>>>>>>>>>>> +        mvq->used_idx = ri->used_index;
>>>>>>>>>>>>>>              mvq->ready = ri->ready;
>>>>>>>>>>>>>>              mvq->num_ent = ri->num_ent;
>>>>>>>>>>>>>>              mvq->desc_addr = ri->desc_addr;
>>>>>>>>>>>>>> @@ -1768,6 +1785,7 @@ static void 
>>>>>>>>>>>>>> mlx5_vdpa_set_status(struct
>>>>>>>>>>>>>> vdpa_device *vdev, u8 status)
>>>>>>>>>>>>>>          if (!status) {
>>>>>>>>>>>>>>              mlx5_vdpa_info(mvdev, "performing device 
>>>>>>>>>>>>>> reset\n");
>>>>>>>>>>>>>>              teardown_driver(ndev);
>>>>>>>>>>>>>> +        clear_virtqueues(ndev);
>>>>>>>>>>>>> The clearing looks fine at the first glance, as it aligns 
>>>>>>>>>>>>> with the other
>>>>>>>>>>>>> state cleanups floating around at the same place. However, 
>>>>>>>>>>>>> the thing is
>>>>>>>>>>>>> get_vq_state() is supposed to be called right after to get 
>>>>>>>>>>>>> sync'ed with
>>>>>>>>>>>>> the latest internal avail_index from device while vq is 
>>>>>>>>>>>>> stopped. The
>>>>>>>>>>>>> index was saved in the driver software at vq suspension, 
>>>>>>>>>>>>> but before the
>>>>>>>>>>>>> virtq object is destroyed. We shouldn't clear the 
>>>>>>>>>>>>> avail_index too early.
>>>>>>>>>>>> Good point.
>>>>>>>>>>>>
>>>>>>>>>>>> There's a limitation on the virtio spec and vDPA framework 
>>>>>>>>>>>> that we can not
>>>>>>>>>>>> simply differ device suspending from device reset.
>>>>>>>>>>>>
>>>>>>>>>>> Are you talking about live migration where you reset the 
>>>>>>>>>>> device but
>>>>>>>>>>> still want to know how far it progressed in order to 
>>>>>>>>>>> continue from the
>>>>>>>>>>> same place in the new VM?
>>>>>>>>>> Yes. So if we want to support live migration at we need:
>>>>>>>>>>
>>>>>>>>>> in src node:
>>>>>>>>>> 1) suspend the device
>>>>>>>>>> 2) get last_avail_idx via get_vq_state()
>>>>>>>>>>
>>>>>>>>>> in the dst node:
>>>>>>>>>> 3) set last_avail_idx via set_vq_state()
>>>>>>>>>> 4) resume the device
>>>>>>>>>>
>>>>>>>>>> So you can see, step 2 requires the device/driver not to 
>>>>>>>>>> forget the
>>>>>>>>>> last_avail_idx.
>>>>>>>>>>
>>>>>>>>> Just to be sure, what really matters here is the used index. 
>>>>>>>>> Becuase the
>>>>>>>>> vriqtueue itself is copied from the src VM to the dest VM. The 
>>>>>>>>> available
>>>>>>>>> index is alreay there and we know the hardware reads it from 
>>>>>>>>> there.
>>>>>>>>
>>>>>>>> So for "last_avail_idx" I meant the hardware internal avail 
>>>>>>>> index. It's not
>>>>>>>> stored in the virtqueue so we must migrate it from src to dest 
>>>>>>>> and set them
>>>>>>>> through set_vq_state(). Then in the destination, the virtqueue 
>>>>>>>> can be
>>>>>>>> restarted from that index.
>>>>>>>>
>>>>>>> Consider this case: driver posted buffers till avail index 
>>>>>>> becomes the
>>>>>>> value 50. Hardware is executing but made it till 20 when 
>>>>>>> virtqueue was
>>>>>>> suspended due to live migration - this is indicated by hardware 
>>>>>>> used
>>>>>>> index equal 20.
>>>>>>
>>>>>>
>>>>>> So in this case the used index in the virtqueue should be 20? 
>>>>>> Otherwise we need not sync used index itself but all the used 
>>>>>> entries that is not committed to the used ring.
>>>>>
>>>>> In other word, for mlx5 vdpa there's no such internal 
>>>>> last_avail_idx stuff maintained by the hardware, right? 
>>>>
>>>>
>>>> For each device it should have one otherwise it won't work 
>>>> correctly during stop/resume. See the codes 
>>>> mlx5_vdpa_get_vq_state() which calls query_virtqueue() that build 
>>>> commands to query "last_avail_idx" from the hardware:
>>>>
>>>>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, 
>>>> MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
>>>>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, 
>>>> MLX5_OBJ_TYPE_VIRTIO_NET_Q);
>>>>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
>>>>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, 
>>>> ndev->mvdev.res.uid);
>>>>     err = mlx5_cmd_exec(ndev->mvdev.mdev, in, sizeof(in), out, 
>>>> outlen);
>>>>     if (err)
>>>>         goto err_cmd;
>>>>
>>>>     obj_context = MLX5_ADDR_OF(query_virtio_net_q_out, out, 
>>>> obj_context);
>>>>     memset(attr, 0, sizeof(*attr));
>>>>     attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>>>>     attr->available_index = MLX5_GET(virtio_net_q_object, 
>>>> obj_context, hw_available_index);
>>>>
>>> Eli should be able to correct me, but this hw_available_index might 
>>> just be a cached value of virtqueue avail_index in the memory from 
>>> the most recent sync. 
>>
>>
>> It should not, otherwise it will be a bug.
> The hw_available_index not showing the correct last_avail_index value 
> is technically a firmware bug, as Eli alluded to. That's why I had the 
> original question for how this entire synchronization scheme could 
> work if just saving and restoring this cached value. In my 
> observation, the hw_available_index was seen far off from the 
> hw_used_index post vq suspension, I just pointed out the fact that 
> this hardware value is neither last_avail_idx nor last_used_idx that 
> is useful to represent vq state.
>
> However, the core question I'm having is should we care about fixing 
> this in the firmware interface level (actually, the hardware 
> implementation), or rather, just as said, some devices e.g. network 
> device could live with the simplified form of assumption (used_idx ==  
> last_used_idx  == last_avail_idx) where pending requests can be 
> drained and completed before device is stopped or suspended. Despite 
> of what device behavior would be expected or defined in the virtio 
> spec, the get/set_vq_state() API should have very clear semantics: 
> whether both forms (i.e. restore either one of used_idx or 
> last_avail_idx is fine) are acceptable, or it needs to be religious to 
> restore vq state via last_avail_idx only. In the latter case, both the 
> mlx5 vdpa net driver and the firmware interface needs to be fixed to 
> accommodate the stricter API requirement.
>
> FWIW I don't think network (Ethernet) device should always assume 
> (used_idx ==  last_used_idx  == last_avail_idx) while being stopped 
> (were there virtio RDMA device in reality this assumption would break): 


Right, it's the choice of device and it would be more complicated if we 
had devices without this assumption. The main issue is whther or not we 
need to wait for the drain of the request and if such darining can only 
take reasonable time to finish.


> it could well follow the golden rules in virtio S/W implementation to 
> have separate last_used_idx and last_avail_idx in the hardware, then 
> it'll be 100% API compliant.. But we know that such implementation is 
> unnecessarily complicated for Ethernet device. Hence I thought there 
> could be sort of reliefs for some driver/device and it's totally up to 
> the device/driver to choose the implementation.


Yes, the current API leaves the room for last_used_idx but we may still 
need to migrate the indices (as I mentioned below).


>
>>
>>
>>> I doubt it's the one you talked about in software implementation.
>>
>>
>> Actually not, it's a virtio general issue:
>>
>> Consider there's not indices wrap. And:
>> - used_idx is the used index in the virtqueue
>> - last_used_idx is the used index maintained by the device, it points 
>> to the location where to put the next done requests to the used_ring
>> - avail_idx is the available index in the virtqueue
>> - last_avail_idx is the index maintained by the device, it points to 
>> the location where device need to read from the available.
>>
>> So bascially, from device POV, it only cares the buffer that belong 
>> to itself which are [used_idx, avail_idx). So we have:
>>
>> [used_idx, last_used_idx) The requests that have been completed by 
>> the device but not completed to the used ring (or at least used_idx 
>> is not updated).
>> [last_used_idx, last_avail_idx) The requests that are being processed 
>> by the device.
>> [last_avail_idx, avail_idx) The requests that are made available by 
>> the driver but not processed by the device.
>>
>> During device stop/suspend, the device should:
>>
>> - stop reading new request from available ring (or read until the end 
>> of descriptor chain)
>> - sync used_idx with last_used_idx. Otherwise we need a complicated 
>> but not necessary API to sync last_used_idx and the indices that are 
>> not committed to used ring (since device may complete the request out 
>> of order)
>>
>> So we know used_idx == last_used_idx in this case, so we have:
>>
>> [used_idx/last_used_idx, last_avail_idx) The requests that are being 
>> processed.
>> [last_avail_idx, avail_idx) The requests that are available for the 
>> driver but not yet processed.
>>
>> For networking device, it's sufficient to think the requests are 
>> completed when TX/RX DMA are finished. So there's no requests that 
>> are being processed after the stop. In this case we had: used_idx == 
>> last_used_idx == last_avail_idx. Then we only had:
>>
>> [used_idx/last_used_idx/last_avail_idx, avail_idx] The requests that 
>> are made available by the driver but not processed by the device. 
>> That's why you may think only used_idx matters here.
>>
>> For block device, the completion of the request might require the 
>> communication with the remote backend, so we can't assume 
>> last_used_idx is equal to the last_avail_idx. Whether or not to wait 
>> for the drain the request is still being discussed[1].
> I guess this requirement is very subject to the specific storage setup 
> (networked v.s. local) including the guest app/configuration (retry 
> v.s. time out). IMHO there shouldn't be a definite yes-or-no answer 
> here. But in general, for req-ack type of request if the completion 
> (ack) cannot simply replicate across live migration, it should wait 
> until the pending requests are completely drained.


Yes, and qemu may fail the migartion if the pending requets takes too 
long to be drained, that's why an asynchornous API is introduced in [1].


>
>>
>> So you can see, for all the cases, what really matters is the 
>> last_avail_idx. The device should know where it need to start reading 
>> for the next request, and it is not necessarily equal to 
>> last_used_idx or used_idx. What makes things a little bit easier is 
>> the networking device whose last_used_idx is equal to last_avail_idx.
>>
>>
>>> If I understand Eli correctly, hardware will always reload the 
>>> latest avail_index from memory whenever it's being sync'ed again.
>>>
>>> <quote>
>>> The hardware always goes to read the available index from memory. 
>>> The requirement to configure it when creating a new object is still 
>>> a requirement defined by the interface so I must not violate 
>>> interface requirments.
>>> </quote>
>>>
>>> If the hardware does everything perfectly that is able to flush 
>>> pending requests, update descriptors, rings plus used indices all at 
>>> once before the suspension, there's no need for hardware to maintain 
>>> a separate internal index than the h/w used_index. The hardware can 
>>> get started from the saved used_index upon resuming. I view this is 
>>> of (hardware) implementation choices and thought it does not violate 
>>> the virtio spec?
>>
>>
>> Yes, but as you said, it has a lot of assumptions which may not work 
>> for other type of devices. So what I refer "last_avail_idx" is 
>> probably the "used_idx" in your description here. It might be the 
>> same in this case for networking device.
>>
>>
>>>
>>>
>>>>
>>>>
>>>>
>>>>> And the used_idx in the virtqueue is always in sync with the 
>>>>> hardware used_index, and hardware is supposed to commit pending 
>>>>> used buffers to the ring while bumping up the hardware used_index 
>>>>> (and also committed to memory) altogether prior to suspension, is 
>>>>> my understanding correct here? Double checking if this is the 
>>>>> expected semantics of what 
>>>>> modify_virtqueue(MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND) should 
>>>>> achieve.
>>>>>
>>>>> If the above is true, then it looks to me for mlx5 vdpa we should 
>>>>> really return h/w used_idx rather than the last_avail_idx through 
>>>>> get_vq_state(), in order to reconstruct the virt queue state post 
>>>>> live migration. For the set_map case, the internal last_avail_idx 
>>>>> really doesn't matter, although both indices are saved and 
>>>>> restored transparently as-is.
>>>>
>>>>
>>>> Right, a subtle thing here is that: for the device that might have 
>>>> can't not complete all virtqueue requests during vq suspending, the 
>>>> "last_avail_idx" might not be equal to the hardware used_idx. Thing 
>>>> might be true for the storage devices that needs to connect to a 
>>>> remote backend. But this is not the case of networking device, so 
>>>> last_avail_idx should be equal to hardware used_idx here. 
>>> Eli, since it's your hardware, does it work this way? i.e. does the 
>>> firmware interface see a case where virtqueue requests can't be 
>>> completed before suspending vq?
>>
>>
>> For storage device, I think it can happen.
>>
>>
>>>
>>>> But using the "last_avail_idx" or hardware avail_idx should always 
>>>> be better in this case since it's guaranteed to correct and will 
>>>> have less confusion. We use this convention in other types of vhost 
>>>> backends (vhost-kernel, vhost-user).
>>>>
>>>> So looking at mlx5_set_vq_state(), it probably won't work since it 
>>>> doesn't not set either hardware avail_idx or hardware used_idx:
>>> The saved mvq->avail_idx will be used to recreate hardware virtq 
>>> object and the used index in create_virtqueue(), once status 
>>> DRIVER_OK is set. I suspect we should pass the index to 
>>> mvq->used_idx in mlx5_vdpa_set_vq_state() below instead.
>>>
>>
>> It depends on what did mvq->used_idx meant? If it's last_used_idx, it 
>> should be the same with mvq->avail_idx for networking device.
> It's the last_used_idx. Note, Eli already posted a patch ("vdpa/mlx5: 
> Fix suspend/resume index restoration") to repurpose set_vq_state() to 
> restore both used_idx and avail_idx (both indices should be 
> conceptually equal in that device model) across reset. 


Will check, burried by mails :(


> Which implies the simplified assumption I mentioned earlier. The 
> requirement of set_vq_state() API should make it clear if this kind of 
> assumption is acceptable.


Right now the value is exposed to userspace via GET_VRING_BASE, so only 
last_avail_idx is synced. If we need sync last_used_idx, we should also 
sync pending indices which requires more thoughts.

Thanks


>
>
> Thanks,
> -Siwei
>
>
>>
>> Thanks
>>
>>
>>>
>>> Thanks,
>>> -Siwei
>>>>
>>>> static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>>>>                   const struct vdpa_vq_state *state)
>>>> {
>>>>     struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>>>     struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>>>     struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[idx];
>>>>
>>>>     if (mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY) {
>>>>         mlx5_vdpa_warn(mvdev, "can't modify available index\n");
>>>>         return -EINVAL;
>>>>     }
>>>>
>>>>     mvq->avail_idx = state->avail_index;
>>>>     return 0;
>>>> }
>>>>
>>>> Depends on the hardware, we should either set hardware used_idx or 
>>>> hardware avail_idx here.
>>>>
>>>> I think we need to clarify how device is supposed to work in the 
>>>> virtio spec.
>>>>
>>>> Thanks
>>>>
>>>>
>>>>>
>>>>> -Siwei
>>>>>
>>>>>>
>>>>>>
>>>>>>> Now the vritqueue is copied to the new VM and the
>>>>>>> hardware now has to continue execution from index 20. We need to 
>>>>>>> tell
>>>>>>> the hardware via configuring the last used_index.
>>>>>>
>>>>>>
>>>>>> If the hardware can not sync the index from the virtqueue, the 
>>>>>> driver can do the synchronization by make the last_used_idx 
>>>>>> equals to used index in the virtqueue.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>>   So why don't we
>>>>>>> restore the used index?
>>>>>>>
>>>>>>>>> So it puzzles me why is set_vq_state() we do not communicate 
>>>>>>>>> the saved
>>>>>>>>> used index.
>>>>>>>>
>>>>>>>> We don't do that since:
>>>>>>>>
>>>>>>>> 1) if the hardware can sync its internal used index from the 
>>>>>>>> virtqueue
>>>>>>>> during device, then we don't need it
>>>>>>>> 2) if the hardware can not sync its internal used index, the 
>>>>>>>> driver (e.g as
>>>>>>>> you did here) can do that.
>>>>>>>>
>>>>>>>> But there's no way for the hardware to deduce the internal 
>>>>>>>> avail index from
>>>>>>>> the virtqueue, that's why avail index is sycned.
>>>>>>>>
>>>>>>>> Thanks
>>>>>>>>
>>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>

