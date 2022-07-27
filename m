Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37771581D5D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 03:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiG0B4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 21:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiG0B4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 21:56:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4670101F8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 18:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658886967; x=1690422967;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MIEHBiASYXLGENaJG3oskK+gRIPXftMG9Znz/M3tFB4=;
  b=YdLXNCUnGLrBMv08f9iyGEY44KpZye/QqpwTsd+Ywy+t/rmgNMsaVOXi
   BIOTsWWkFmQbYEu8mRlzB28mGspxnFIEB+4CdxzbwFiDv8sUDyCxx3Ejl
   f4ja72xLUS1dxUdqVn8T4TkDGiAGvf9zpumDnRoHqhP3Qjj4HtwYhRcr3
   4ltHUw7uESgdtYtlCqDDP5OlT4Ia5OwDn93HAQsZqTf52sYMqQUsy/JGB
   bGipE/w0Pgb6K4ETXv3jYUjj7Bxkc5LlsX9pJ8IS7ihFpUwVAG8caULl4
   l7ZhZbpVSG5YL7l35Tj/TBAYDrUt51HDdkOvGK2zdblLK/JG74oSzaz8g
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="285669049"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="285669049"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 18:56:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="658973352"
Received: from zhigaoch-mobl1.ccr.corp.intel.com (HELO [10.249.171.153]) ([10.249.171.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 18:56:05 -0700
Message-ID: <5a3b5fff-371a-840f-e2fb-260353c426f9@intel.com>
Date:   Wed, 27 Jul 2022 09:56:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220713011631-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481BE59EDF381F5C0849C08DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220726154704-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811EB71F4D9C32DA2D6F02DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54811EB71F4D9C32DA2D6F02DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 4:53 AM, Parav Pandit wrote:
>> From: Michael S. Tsirkin <mst@redhat.com>
>> Sent: Tuesday, July 26, 2022 3:49 PM
>>
>> On Tue, Jul 26, 2022 at 03:54:06PM +0000, Parav Pandit wrote:
>>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>> Sent: Wednesday, July 13, 2022 1:27 AM
>>>>
>>>> On Fri, Jul 01, 2022 at 10:07:59PM +0000, Parav Pandit wrote:
>>>>>
>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Sent: Friday, July 1, 2022 9:28 AM If VIRTIO_NET_F_MQ == 0, the
>>>>>> virtio device should have one queue pair, so when userspace
>>>>>> querying queue pair numbers, it should return mq=1 than zero.
>>>>>>
>>>>>> Function vdpa_dev_net_config_fill() fills the attributions of
>>>>>> the vDPA devices, so that it should call
>>>>>> vdpa_dev_net_mq_config_fill() so the parameter in
>>>>>> vdpa_dev_net_mq_config_fill() should be feature_device than
>>>>>> feature_driver for the vDPA devices themselves
>>>>>>
>>>>>> Before this change, when MQ = 0, iproute2 output:
>>>>>> $vdpa dev config show vdpa0
>>>>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false
>>>>>> max_vq_pairs 0 mtu 1500
>>>>>>
>>>>> The fix belongs to user space.
>>>>> When a feature bit _MQ is not negotiated, vdpa kernel space will
>>>>> not add
>>>> attribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
>>>>> When such attribute is not returned by kernel, max_vq_pairs should
>>>>> not be
>>>> shown by the iproute2.
>>>>> We have many config space fields that depend on the feature bits
>>>>> and
>>>> some of them do not have any defaults.
>>>>> To keep consistency of existence of config space fields among all,
>>>>> we don't
>>>> want to show default like below.
>>>>> Please fix the iproute2 to not print max_vq_pairs when it is not
>>>>> returned by
>>>> the kernel.
>>>>
>>>> Parav I read the discussion and don't get your argument. From
>>>> driver's POV _MQ with 1 VQ pair and !_MQ are exactly functionally
>> equivalent.
>>> But we are talking from user POV here.
>>  From spec POV there's just driver and device, user would be part of driver here.
> User space application still need to inspect the _MQ bit to

>>>> It's true that iproute probably needs to be fixed too, to handle old kernels.
>>>> But iproute is not the only userspace, why not make it's life easier
>>>> by fixing the kernel?
>>> Because it cannot be fixed for other config space fields which are control by
>> feature bits those do not have any defaults.
>>> So better to treat all in same way from user POV.
>> Consistency is good for sure. What are these other fields though?
>> Can you give examples so I understand please?
> speed only exists if VIRTIO_NET_F_SPEED_DUPLEX.
> rss_max_key_size exists only if VIRTIO_NET_F_RSS exists.
That's different cases from the MQ case.

There are no default values for speed and rss_max_key_size. And 
processing speed without VIRTIO_NET_F_SPEED_DUPLEX, or rss_max_key_size 
exists without VIRTIO_NET_F_RSS are meaningless.
But for MQ, if without MQ, we know it has to be 1 queue pair to be a 
functional virtio-net, and only one queue pair. This is meaningful.

