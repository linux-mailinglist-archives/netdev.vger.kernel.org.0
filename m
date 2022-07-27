Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50BE581FB5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiG0GCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiG0GCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:02:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A452A735
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658901763; x=1690437763;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=anNk6jyB5Zf8QIKWeNRLIowoJFxjttqszIprTqeBi3M=;
  b=jto/DCSe9o7m1VzabJHv812sKwj1jT2w7671+tqXAfjzm11Px3eGDJQ6
   6aWgYrpaGqRPat+0U7L2szxZ7ME3S2bK1QzKxm6YBnJeKBZrqtWrNQ3+E
   ZPgOdUzGnTCFMRKK6X4BXKZ5nyelPHMldEyE2x3G+jdoDhelBCVzHxJOH
   m5rOfJo/vgfAEhYYOlnLAY2dom+IteQxMXAezZHgJnJmW4zXkEJDwZzHt
   x532w+psJ1VfCFt4OqaHNPA378bHNh18VOcIXfRBv+HSQ9SOMVhfybDTq
   dJ8fUy0gPLS8qUfFQopHK1Y9nTRvM1wlWaU62lNxaQCzCyp20nd256Q4H
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="374452994"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="374452994"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 23:02:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="659050038"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.153]) ([10.249.171.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 23:02:27 -0700
Message-ID: <9e27b28c-f88b-87c4-d869-d4984ece2066@intel.com>
Date:   Wed, 27 Jul 2022 14:02:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <6dc2229c-f2f3-017f-16fa-4611e53c774e@intel.com>
 <PH0PR12MB5481D9BBC9C249840E4CDF7EDC929@PH0PR12MB5481.namprd12.prod.outlook.com>
 <9d9d6022-5d49-6f6e-a1ff-562d088ad03c@intel.com>
 <PH0PR12MB548133788748EF91F959C143DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB548133788748EF91F959C143DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/2022 7:06 PM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Tuesday, July 26, 2022 7:03 AM
>>
>> On 7/24/2022 11:21 PM, Parav Pandit wrote:
>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Saturday, July 23, 2022 7:24 AM
>>>>
>>>>
>>>> On 7/22/2022 9:12 PM, Parav Pandit wrote:
>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Sent: Friday, July 22, 2022 7:53 AM
>>>>>>
>>>>>> This commit adds a new vDPA netlink attribution
>>>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can
>> query
>>>> features
>>>>>> of vDPA devices through this new attr.
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>     drivers/vdpa/vdpa.c       | 13 +++++++++----
>>>>>>     include/uapi/linux/vdpa.h |  1 +
>>>>>>     2 files changed, 10 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>> ebf2f363fbe7..9b0e39b2f022 100644
>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct
>>>>>> vdpa_device *vdev,  static int vdpa_dev_net_config_fill(struct
>>>>>> vdpa_device *vdev, struct sk_buff *msg)  {
>>>>>>     	struct virtio_net_config config = {};
>>>>>> -	u64 features;
>>>>>> +	u64 features_device, features_driver;
>>>>>>     	u16 val_u16;
>>>>>>
>>>>>>     	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)); @@
>>>>>> -
>>>>>> 832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct
>>>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>>>     	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>     		return -EMSGSIZE;
>>>>>>
>>>>>> -	features = vdev->config->get_driver_features(vdev);
>>>>>> -	if (nla_put_u64_64bit(msg,
>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>> +	features_driver = vdev->config->get_driver_features(vdev);
>>>>>> +	if (nla_put_u64_64bit(msg,
>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>>>> +			      VDPA_ATTR_PAD))
>>>>>> +		return -EMSGSIZE;
>>>>>> +
>>>>>> +	features_device = vdev->config->get_device_features(vdev);
>>>>>> +	if (nla_put_u64_64bit(msg,
>>>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
>>>>>> +features_device,
>>>>>>     			      VDPA_ATTR_PAD))
>>>>>>     		return -EMSGSIZE;
>>>>>>
>>>>>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>>>>>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>>>>>> +&config);
>>>>>>     }
>>>>>>
>>>>>>     static int
>>>>>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>>>>>> index
>>>>>> 25c55cab3d7c..39f1c3d7c112 100644
>>>>>> --- a/include/uapi/linux/vdpa.h
>>>>>> +++ b/include/uapi/linux/vdpa.h
>>>>>> @@ -47,6 +47,7 @@ enum vdpa_attr {
>>>>>>     	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>>>>>>     	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>>>>>>     	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
>>>>>> +	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
>>>>>>
>>>>> I have answered in previous emails.
>>>>> I disagree with the change.
>>>>> Please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES.
>>>> I believe we have already discussed this before in the V3 thread.
>>>> I have told you that reusing this attr will lead to a new race condition.
>>>>
>>> Returning attribute cannot lead to any race condition.
>> Please refer to our discussion in the V3 series, I have explained if re-use this
>> attr, it will be a multiple consumers and multiple produces model, it is a
>> typical racing condition.
> I read the emails with subject = " Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA device"
> I couldn’t find multiple consumers multiple producers working on same nla message.
If this attr is reused, then there can be multiple iproute2 instances or 
other applications querying feature bits of the management device and 
the vDPA device simultaneously,
and both kernel side management feature bits filler function and vDPA 
device feature bits filler function can write the NLA message at the 
same time. That's the multiple
consumers and producers, and no locks

