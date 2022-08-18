Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92C7597D4E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243224AbiHREVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbiHREUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:20:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC404DF1F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 21:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660796341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYWlkkzE7xxMeYBh4itiv4iOWQQiRrOeuKQlAfKIHV0=;
        b=hjW+5/NSj9EYAV0Y8QwOdqY7TWW0DfhKZIe+dRJ6HeoVwgu+61yl3/An77mU795zlY1b5V
        q0teiW77QeTOn6zP3lxzqHmTqToivo7QyljpLvc/YzYck1eL/qEka/mCa/NxRLYwSaY/f9
        a6/tveDPV/5AT2lBytZimYQ0mCtKYNU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-war1yUyZNIWotbZE4Yaxcw-1; Thu, 18 Aug 2022 00:18:55 -0400
X-MC-Unique: war1yUyZNIWotbZE4Yaxcw-1
Received: by mail-pl1-f198.google.com with SMTP id s18-20020a170902ea1200b0016f11bfefe4so411171plg.14
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 21:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uYWlkkzE7xxMeYBh4itiv4iOWQQiRrOeuKQlAfKIHV0=;
        b=aNXZb0ncG4fm7eqPx26zTcqKJUihNq7gberSIQw56mW6/lNiNZ6mqdrGhnRpAWIxA8
         644A4Lps+Xr8yRq4/0A/2KpSILygU8hocFKPR2e4kde77rNz5y0sYFN3jExNP9jjJE/j
         BjY94BQJNeg1zH3qk/ozo5AwcbMq8hv00m1iXewR2IfSEJQWXcBEdQE5gEOT7fyyiKz7
         VRKWRn9U1qIrHu/Fo5w6fFTr7fVFs52djpTffH/kAq8ODUjStgzCZ8Nl4iFgJ7NtRdi7
         2npcHFQhI5/r9LdC/+7Gp18dQKJbuXWWiQ4ITFGTkDZKegeJ1ZFOVoC+KfNh03nTt7zf
         DOHA==
X-Gm-Message-State: ACgBeo3bzrLBou9Uy0+rJoAYZq0Yd6DWJqkpGk7UV3QzCCCZE2M4W443
        urFmDEE/SLISjTwOyLbAQOupuMF8M9kBvHkO6R2QSCgvNPfA2VwNfopLIaleiFfYimwCO/RnoQf
        1MqyxrzYbhhv8RMQB
X-Received: by 2002:a65:6e49:0:b0:429:cae6:aac6 with SMTP id be9-20020a656e49000000b00429cae6aac6mr1107535pgb.268.1660796334399;
        Wed, 17 Aug 2022 21:18:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7utG6cFgFfhElFJDW75wYZfFPKrrZXbuG793cuXP6Cp63b+DOuExLDT7LDHhIbNR2mtvrGQA==
X-Received: by 2002:a65:6e49:0:b0:429:cae6:aac6 with SMTP id be9-20020a656e49000000b00429cae6aac6mr1107511pgb.268.1660796334091;
        Wed, 17 Aug 2022 21:18:54 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bn20-20020a056a02031400b00419ab8f8d2csm322046pgb.20.2022.08.17.21.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 21:18:53 -0700 (PDT)
Message-ID: <df2bab2d-2bc1-c3c2-f87c-dcc6bdc5737d@redhat.com>
Date:   Thu, 18 Aug 2022 12:18:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
 <PH0PR12MB5481EBA9E08963DEF0743063DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220816170753-mutt-send-email-mst@kernel.org>
 <352e9533-8ab1-cec0-0141-ce0735ee39f5@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <352e9533-8ab1-cec0-0141-ce0735ee39f5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/17 10:03, Zhu, Lingshan 写道:
>
>
> On 8/17/2022 5:09 AM, Michael S. Tsirkin wrote:
>> On Tue, Aug 16, 2022 at 09:02:17PM +0000, Parav Pandit wrote:
>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Tuesday, August 16, 2022 12:19 AM
>>>>
>>>>
>>>> On 8/16/2022 10:32 AM, Parav Pandit wrote:
>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Sent: Monday, August 15, 2022 5:27 AM
>>>>>>
>>>>>> Some fields of virtio-net device config space are conditional on the
>>>>>> feature bits, the spec says:
>>>>>>
>>>>>> "The mac address field always exists
>>>>>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>>>>>
>>>>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
>>>>>> VIRTIO_NET_F_RSS is set"
>>>>>>
>>>>>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>>>>>
>>>>>> so we should read MTU, MAC and MQ in the device config space only
>>>>>> when these feature bits are offered.
>>>>> Yes.
>>>>>
>>>>>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are not set,
>>>> the
>>>>>> virtio device should have one queue pair as default value, so when
>>>>>> userspace querying queue pair numbers, it should return mq=1 than 
>>>>>> zero.
>>>>> No.
>>>>> No need to treat mac and max_qps differently.
>>>>> It is meaningless to differentiate when field exist/not-exists vs 
>>>>> value
>>>> valid/not valid.
>>>> as we discussed before, MQ has a default value 1, to be a 
>>>> functional virtio-
>>>> net device, while MAC has no default value, if no VIRTIO_NET_F_MAC 
>>>> set,
>>>> the driver should generate a random MAC.
>>>>>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read MTU from
>>>>>> the device config sapce.
>>>>>> RFC894 <A Standard for the Transmission of IP Datagrams over 
>>>>>> Ethernet
>>>>>> Networks> says:"The minimum length of the data field of a packet 
>>>>>> sent
>>>>>> Networks> over
>>>>>> an Ethernet is 1500 octets, thus the maximum length of an IP 
>>>>>> datagram
>>>>>> sent over an Ethernet is 1500 octets.  Implementations are 
>>>>>> encouraged
>>>>>> to support full-length packets"
>>>>> This line in the RFC 894 of 1984 is wrong.
>>>>> Errata already exists for it at [1].
>>>>>
>>>>> [1] https://www.rfc-editor.org/errata_search.php?rfc=894&rec_status=0
>>>> OK, so I think we should return nothing if _F_MTU not set, like 
>>>> handling the
>>>> MAC
>>>>>> virtio spec says:"The virtio network device is a virtual ethernet
>>>>>> card", so the default MTU value should be 1500 for virtio-net.
>>>>>>
>>>>> Practically I have seen 1500 and highe mtu.
>>>>> And this derivation is not good of what should be the default mtu 
>>>>> as above
>>>> errata exists.
>>>>> And I see the code below why you need to work so hard to define a 
>>>>> default
>>>> value so that _MQ and _MTU can report default values.
>>>>> There is really no need for this complexity and such a long commit
>>>> message.
>>>>> Can we please expose feature bits as-is and report config space 
>>>>> field which
>>>> are valid?
>>>>> User space will be querying both.
>>>> I think MAC and MTU don't have default values, so return nothing if 
>>>> the
>>>> feature bits not set,
>>>> for MQ, it is still max_vq_paris == 1 by default.
>>> I have stressed enough to highlight the fact that we don’t want to 
>>> start digging default/no default, valid/no-valid part of the spec.
>>> I prefer kernel to reporting fields that _exists_ in the config 
>>> space and are valid.
>>> I will let MST to handle the maintenance nightmare that this kind of 
>>> patch brings in without any visible gain to user space/orchestration 
>>> apps.
>>>
>>> A logic that can be easily build in user space, should be written in 
>>> user space.
>>> I conclude my thoughts here for this discussion.
>>>
>>> I will let MST to decide how he prefers to proceed.
>>>
>>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>>>>>> +        val_u16 = 1500;
>>>>>> +    else
>>>>>> +        val_u16 = __virtio16_to_cpu(true, config->mtu);
>>>>>> +
>>>>> Need to work hard to find default values and that too turned out had
>>>> errata.
>>>>> There are more fields that doesn’t have default values.
>>>>>
>>>>> There is no point in kernel doing this guess work, that user space 
>>>>> can figure
>>>> out of what is valid/invalid.
>>>> It's not guest work, when guest finds no feature bits set, it can 
>>>> decide what
>>>> to do.
>>> Above code of doing 1500 was probably an honest attempt to find a 
>>> legitimate default value, and we saw that it doesn’t work.
>>> This is second example after _MQ that we both agree should not 
>>> return default.
>>>
>>> And there are more fields coming in this area.
>>> Hence, I prefer to not avoid returning such defaults for MAC, MTU, 
>>> MQ and rest all fields which doesn’t _exists_.
>>>
>>> I will let MST to decide how he prefers to proceed for every field 
>>> to come next.
>>> Thanks.
>>>
>>
>> If MTU does not return a value without _F_MTU, and MAC does not return
>> a value without _F_MAC then IMO yes, number of queues should not return
>> a value without _F_MQ.
> sure I can do this, but may I ask whether it is a final decision, I 
> remember you supported max_queue_paris = 1 without _F_MQ before


I think we just need to be consistent:

Either

1) make field conditional to align with spec

or

2) always return a value even if the feature is not set

It seems to me 1) is easier.

Thanks


>
> Thanks
>>
>>
>

