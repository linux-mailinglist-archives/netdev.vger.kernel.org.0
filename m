Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB22653213E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiEXCqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiEXCqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:46:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C53911175
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653360374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BYJFy+Y4pkEYziHYoAeekoD+3Bc8Qu3A80VyOZfUR80=;
        b=aTVL06TeGTbwRnkWpt/s3Xfh6fNe5Jiiisi3yF2OydlK1hzagVVgW7t8QfJyIQpVT62L+B
        BVWE72ObN5KoufZsC0oRAj08RX2LNSnFkwGIg7073mhOwO8pbPPBpcQmvytl7kZe6RPa2S
        B1qL03s+uPiOjSp4bbSGqpQGlQzIudA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-FHJ3wVe5NP2Onr-_QZnyzg-1; Mon, 23 May 2022 22:46:13 -0400
X-MC-Unique: FHJ3wVe5NP2Onr-_QZnyzg-1
Received: by mail-pl1-f199.google.com with SMTP id p16-20020a170902e75000b00161d96620c4so7658107plf.14
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BYJFy+Y4pkEYziHYoAeekoD+3Bc8Qu3A80VyOZfUR80=;
        b=aYBe0fiSfEpKA4dRIQk11l4dKWazBeTfhT2zEfXu5zMjlze4Q6w2TX6IJygEeUzim6
         PWNGe2hoTjZFG6Oq2UpKdEcYTZXFI3H2t1odgg7Xf/sy+x27scSqju4n0tqIgw3eJi46
         VvrljgGYW54hWRo59Vrac9VR1DYupMHQ4tlJwOUIry4A38qSotX+gZ/wVQSn1hEX/AHL
         +gGScjcSox+dOZYdwuyAHYAMLEQRyjTguL5NdoAo155SogD5jbbvX2CmOx4En67ING5V
         DtPPENNXWEc6ENymWLA4U+1x1RGA1ICu22AYoLMblXjTNo/pJ53hVuyrOC7b6ilApz64
         3d5Q==
X-Gm-Message-State: AOAM530HTkLoM4EYiPegttnJ8iOVRPvaQPH0zTSYwrKmyxC/EVwQa3TB
        uL+zgjSdOWz07b3HKEck9+IIoUaM0Wi9uEeH8dGTEAd2RU3fO2k0mlPyu3oddjZ/sDm29qhwjIm
        p4KbB3aG7Hg67jNYX
X-Received: by 2002:a17:903:246:b0:153:87f0:a93e with SMTP id j6-20020a170903024600b0015387f0a93emr25486842plh.171.1653360372500;
        Mon, 23 May 2022 19:46:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuBiLXA4Wufa9VWmoox3iYH6eOe66WEUcrf0/HzhdQBGhqcNjN4ti96gSnG5cETtgP3NLFXw==
X-Received: by 2002:a17:903:246:b0:153:87f0:a93e with SMTP id j6-20020a170903024600b0015387f0a93emr25486789plh.171.1653360372044;
        Mon, 23 May 2022 19:46:12 -0700 (PDT)
Received: from [10.72.12.128] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090aaa8900b001cd4989fec6sm417537pjq.18.2022.05.23.19.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 19:46:08 -0700 (PDT)
Message-ID: <333e957d-af84-24fb-6636-843a9dcfc1e2@redhat.com>
Date:   Tue, 24 May 2022 10:45:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
 <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
 <4de97962-cf7e-c334-5874-ba739270c705@oracle.com>
 <9f68802c-2692-7321-f916-670ee0abfc40@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <9f68802c-2692-7321-f916-670ee0abfc40@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/24 08:01, Si-Wei Liu 写道:
>
>
> On 5/23/2022 4:54 PM, Si-Wei Liu wrote:
>>
>>
>> On 5/23/2022 12:20 PM, Eugenio Perez Martin wrote:
>>> On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> 
>>> wrote:
>>>>
>>>>
>>>> On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
>>>>> This operation is optional: It it's not implemented, backend 
>>>>> feature bit
>>>>> will not be exposed.
>>>>>
>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>> ---
>>>>>    include/linux/vdpa.h | 6 ++++++
>>>>>    1 file changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>>>> index 15af802d41c4..ddfebc4e1e01 100644
>>>>> --- a/include/linux/vdpa.h
>>>>> +++ b/include/linux/vdpa.h
>>>>> @@ -215,6 +215,11 @@ struct vdpa_map_file {
>>>>>     * @reset:                  Reset device
>>>>>     *                          @vdev: vdpa device
>>>>>     *                          Returns integer: success (0) or 
>>>>> error (< 0)
>>>>> + * @stop:                    Stop or resume the device (optional, 
>>>>> but it must
>>>>> + *                           be implemented if require device stop)
>>>>> + *                           @vdev: vdpa device
>>>>> + *                           @stop: stop (true), not stop (false)
>>>>> + *                           Returns integer: success (0) or 
>>>>> error (< 0)
>>>> Is this uAPI meant to address all use cases described in the full 
>>>> blown
>>>> _F_STOP virtio spec proposal, such as:
>>>>
>>>> --------------%<--------------
>>>>
>>>> ...... the device MUST finish any in flight
>>>> operations after the driver writes STOP.  Depending on the device, it
>>>> can do it
>>>> in many ways as long as the driver can recover its normal operation 
>>>> if it
>>>> resumes the device without the need of resetting it:
>>>>
>>>> - Drain and wait for the completion of all pending requests until a
>>>>     convenient avail descriptor. Ignore any other posterior 
>>>> descriptor.
>>>> - Return a device-specific failure for these descriptors, so the 
>>>> driver
>>>>     can choose to retry or to cancel them.
>>>> - Mark them as done even if they are not, if the kind of device can
>>>>     assume to lose them.
>>>> --------------%<--------------
>>>>
>>> Right, this is totally underspecified in this series.
>>>
>>> I'll expand on it in the next version, but that text proposed to
>>> virtio-comment was complicated and misleading. I find better to get
>>> the previous version description. Would the next description work?
>>>
>>> ```
>>> After the return of ioctl, the device MUST finish any pending 
>>> operations like
>>> in flight requests. It must also preserve all the necessary state (the
>>> virtqueue vring base plus the possible device specific states)
>> Hmmm, "possible device specific states" is a bit vague. Does it 
>> require the device to save any device internal state that is not 
>> defined in the virtio spec - such as any failed in-flight requests to 
>> resubmit upon resume? Or you would lean on SVQ to intercept it in 
>> depth and save it with some other means? I think network device also 
>> has internal state such as flow steering state that needs bookkeeping 
>> as well.
> Noted that I understand you may introduce additional feature call 
> similar to VHOST_USER_GET_INFLIGHT_FD for (failed) in-flight request, 
> but since that's is a get interface, I assume the actual state 
> preserving should still take place in this STOP call.
>

Yes, I think so.


> -Siwei
>
>>
>> A follow-up question is what is the use of the `stop` argument of 
>> false, does it require the device to support resume? 


Yes, this is required by the hypervisor e.g for Qemu it supports vm 
stop/resume.


>> I seem to recall this is something to abandon in favor of device 
>> reset plus setting queue base/addr after. Or it's just a optional 
>> feature that may be device specific (if one can do so in simple way).


Rest is more like a workarond consider we don't have a stop API. 
Consider we don't add stop at the beginning, it can only be an optional 
feature.

Thanks


>>
>> -Siwei
>>
>>>   that is required
>>> for restoring in the future.
>>>
>>> In the future, we will provide features similar to 
>>> VHOST_USER_GET_INFLIGHT_FD
>>> so the device can save pending operations.
>>> ```
>>>
>>> Thanks for pointing it out!
>>>
>>>
>>>
>>>
>>>
>>>> E.g. do I assume correctly all in flight requests are flushed after
>>>> return from this uAPI call? Or some of pending requests may be subject
>>>> to loss or failure? How does the caller/user specify these various
>>>> options (if there are) for device stop?
>>>>
>>>> BTW, it would be nice to add the corresponding support to vdpa_sim_blk
>>>> as well to demo the stop handling. To just show it on vdpa-sim-net 
>>>> IMHO
>>>> is perhaps not so convincing.
>>>>
>>>> -Siwei
>>>>
>>>>>     * @get_config_size: Get the size of the configuration space 
>>>>> includes
>>>>>     *                          fields that are conditional on 
>>>>> feature bits.
>>>>>     *                          @vdev: vdpa device
>>>>> @@ -316,6 +321,7 @@ struct vdpa_config_ops {
>>>>>        u8 (*get_status)(struct vdpa_device *vdev);
>>>>>        void (*set_status)(struct vdpa_device *vdev, u8 status);
>>>>>        int (*reset)(struct vdpa_device *vdev);
>>>>> +     int (*stop)(struct vdpa_device *vdev, bool stop);
>>>>>        size_t (*get_config_size)(struct vdpa_device *vdev);
>>>>>        void (*get_config)(struct vdpa_device *vdev, unsigned int 
>>>>> offset,
>>>>>                           void *buf, unsigned int len);
>>
>

