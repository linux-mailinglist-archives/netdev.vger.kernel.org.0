Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6087584995
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 04:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiG2CHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 22:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiG2CHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 22:07:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B87932DA6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 19:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659060437; x=1690596437;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xD51ePbmkxfIdGmilOR9DiDmqtLFHZytmIPQ6lDncZE=;
  b=aMaLWcFnTjBnVXc3PxXhPCp0HlgEKZ5ZqwiZxjGH/TXGKW8n6oU4aDO1
   tnupr4mypXogmU5686g45jQ48ouR4kwlDTKgUoimJxMPi6vb0qs75cFOk
   M+7z+Wg9+nusm0s8uhLdpGjnChX4xkPuXN5XJbeecobj5QkEzWUzMiMjP
   SGBKxLRVmoTpytfsuxuyf7qPNwxfvuc4YXmoB41+OUZQ2kN4V9H7LIMS+
   p6U/u1cFgjCn9OYp5rPgsxC6nrSrkHp0NUlKOJfZkK/vBKu17yQhL4ylI
   gkHi0pi7MhvGABJC4jPvZNSLY3QzsbTN4Vvfo9N8WNIj4Hc4BJm6czdNG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="269052354"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="269052354"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:07:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="629186716"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.175.200]) ([10.249.175.200])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:07:15 -0700
Message-ID: <76d6ff6e-b6a4-c069-6d4a-097faacbf9f4@intel.com>
Date:   Fri, 29 Jul 2022 10:07:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
 <20220727050102-mutt-send-email-mst@kernel.org>
 <6d5b03ee-5362-8534-5881-a34c9ea626f0@oracle.com>
 <939bc589-b3ad-d317-8b1d-6da58e4670c0@intel.com>
 <e546e6c0-37bd-ee3e-76e5-def63a33f432@oracle.com>
 <685241b9-3487-489c-2784-2a2209f660ad@intel.com>
 <41ae3d6a-664a-0264-0c60-a6743c233f19@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <41ae3d6a-664a-0264-0c60-a6743c233f19@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/2022 5:54 AM, Si-Wei Liu wrote:
>
>
> On 7/27/2022 7:44 PM, Zhu, Lingshan wrote:
>>
>>
>> On 7/28/2022 9:41 AM, Si-Wei Liu wrote:
>>>
>>>
>>> On 7/27/2022 4:54 AM, Zhu, Lingshan wrote:
>>>>
>>>>
>>>> On 7/27/2022 6:09 PM, Si-Wei Liu wrote:
>>>>>
>>>>>
>>>>> On 7/27/2022 2:01 AM, Michael S. Tsirkin wrote:
>>>>>> On Wed, Jul 27, 2022 at 12:50:33AM -0700, Si-Wei Liu wrote:
>>>>>>>
>>>>>>> On 7/26/2022 11:01 PM, Michael S. Tsirkin wrote:
>>>>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
>>>>>>>>>>
>>>>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>>>>>>>>>
>>>>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>>>>>>>>>> When the user space which invokes netlink commands, 
>>>>>>>>>>>>>>> detects that
>>>>>>>>>>>> _MQ
>>>>>>>>>>>>>> is not supported, hence it takes max_queue_pair = 1 by 
>>>>>>>>>>>>>> itself.
>>>>>>>>>>>>>> I think the kernel module have all necessary information 
>>>>>>>>>>>>>> and it is
>>>>>>>>>>>>>> the only one which have precise information of a device, 
>>>>>>>>>>>>>> so it
>>>>>>>>>>>>>> should answer precisely than let the user space guess. 
>>>>>>>>>>>>>> The kernel
>>>>>>>>>>>>>> module should be reliable than stay silent, leave the 
>>>>>>>>>>>>>> question to
>>>>>>>>>>>>>> the user space
>>>>>>>>>>>> tool.
>>>>>>>>>>>>> Kernel is reliable. It doesn’t expose a config space field 
>>>>>>>>>>>>> if the
>>>>>>>>>>>>> field doesn’t
>>>>>>>>>>>> exist regardless of field should have default or no default.
>>>>>>>>>>>> so when you know it is one queue pair, you should answer 
>>>>>>>>>>>> one, not try
>>>>>>>>>>>> to guess.
>>>>>>>>>>>>> User space should not guess either. User space gets to see 
>>>>>>>>>>>>> if _MQ
>>>>>>>>>>>> present/not present. If _MQ present than get reliable data 
>>>>>>>>>>>> from kernel.
>>>>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
>>>>>>>>>>>> it is still a guess, right? And all user space tools 
>>>>>>>>>>>> implemented this
>>>>>>>>>>>> feature need to guess
>>>>>>>>>>> No. it is not a guess.
>>>>>>>>>>> It is explicitly checking the _MQ feature and deriving the 
>>>>>>>>>>> value.
>>>>>>>>>>> The code you proposed will be present in the user space.
>>>>>>>>>>> It will be uniform for _MQ and 10 other features that are 
>>>>>>>>>>> present now and
>>>>>>>>>> in the future.
>>>>>>>>>> MQ and other features like RSS are different. If there is no 
>>>>>>>>>> _RSS_XX, there
>>>>>>>>>> are no attributes like max_rss_key_size, and there is not a 
>>>>>>>>>> default value.
>>>>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
>>>>>>>>> "we" = user space.
>>>>>>>>> To keep the consistency among all the config space fields.
>>>>>>>> Actually I looked and the code some more and I'm puzzled:
>>>>>>>>
>>>>>>>>
>>>>>>>>     struct virtio_net_config config = {};
>>>>>>>>     u64 features;
>>>>>>>>     u16 val_u16;
>>>>>>>>
>>>>>>>>     vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>>>>
>>>>>>>>     if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, 
>>>>>>>> sizeof(config.mac),
>>>>>>>>             config.mac))
>>>>>>>>         return -EMSGSIZE;
>>>>>>>>
>>>>>>>>
>>>>>>>> Mac returned even without VIRTIO_NET_F_MAC
>>>>>>>>
>>>>>>>>
>>>>>>>>     val_u16 = le16_to_cpu(config.status);
>>>>>>>>     if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>>>>         return -EMSGSIZE;
>>>>>>>>
>>>>>>>>
>>>>>>>> status returned even without VIRTIO_NET_F_STATUS
>>>>>>>>
>>>>>>>>     val_u16 = le16_to_cpu(config.mtu);
>>>>>>>>     if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>>>         return -EMSGSIZE;
>>>>>>>>
>>>>>>>>
>>>>>>>> MTU returned even without VIRTIO_NET_F_MTU
>>>>>>>>
>>>>>>>>
>>>>>>>> What's going on here?
>>>>>>>>
>>>>>>>>
>>>>>>> I guess this is spec thing (historical debt), I vaguely recall 
>>>>>>> these fields
>>>>>>> are always present in config space regardless the existence of 
>>>>>>> corresponding
>>>>>>> feature bit.
>>>>>>>
>>>>>>> -Siwei
>>>>>> Nope:
>>>>>>
>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>
>>>>>> ...
>>>>>>
>>>>>> For optional configuration space fields, the driver MUST check 
>>>>>> that the corresponding feature is offered
>>>>>> before accessing that part of the configuration space.
>>>>> Well, this is driver side of requirement. As this interface is for 
>>>>> host admin tool to query or configure vdpa device, we don't have 
>>>>> to wait until feature negotiation is done on guest driver to 
>>>>> extract vdpa attributes/parameters, say if we want to replicate 
>>>>> another vdpa device with the same config on migration destination. 
>>>>> I think what may need to be fix is to move off from using 
>>>>> .vdpa_get_config_unlocked() which depends on feature negotiation. 
>>>>> And/or expose config space register values through another set of 
>>>>> attributes.
>>>> Yes, we don't have to wait for FEATURES_OK. In another patch in 
>>>> this series, I have added a new netlink attr to report the device 
>>>> features, and removed the blocker. So the LM orchestration SW can 
>>>> query the device features of the devices at the destination 
>>>> cluster, and pick a proper one, even mask out some features to meet 
>>>> the LM requirements.
>>> For that end, you'd need to move off from using 
>>> vdpa_get_config_unlocked() which depends on feature negotiation. 
>>> Since this would slightly change the original semantics of each 
>>> field that "vdpa dev config" shows, it probably need another netlink 
>>> command and new uAPI.
>> why not show both device_features and driver_features in "vdpa dev 
>> config show"?
>>
> As I requested in the other email, I'd like to see the proposed 'vdpa 
> dev config ...' example output for various phases in feature 
> negotiation, and the specific use case (motivation) for this proposed 
> output. I am having difficulty to match what you want to do with the 
> patch posted.
The features bits of a device don't depend on the phases, and the 
driver_features only has meaningful values when FEATURES_OK.

Thanks
>
> -Siwei
>
>>>
>>> -Siwei
>>>
>>>
>>>>
>>>> Thanks,
>>>> Zhu Lingshan
>>>>> -Siwei
>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>
>>
>

