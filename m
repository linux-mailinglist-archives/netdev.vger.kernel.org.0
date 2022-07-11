Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA8B56D2FC
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 04:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiGKC3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 22:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKC3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 22:29:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCEA1837C
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 19:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657506586; x=1689042586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nh+SoZIouIQFEg2bpcDQn80SMIdoW1yIfjCCpHX60Vo=;
  b=f+GPixqn0qUqMs+K56AxfIhMXQRR5H8uJAe5VzpmWf578a0VLRmYEUrN
   NScwlwB50LtUbdnR0CPtm1LF6DkgM27wGegkeuxxyQgYu/dXpvWrUpC+Y
   d0u0sUBe8VLsB46FZYwa1ihkYLBEcErEA4nWcOvuEv5+y8OkfH9EZh2Aa
   uecnLjA/Rr5aUCa/Z+H0+iNL5Nzplm99Rkx0drJJSC4qJOP84GfGGlX2M
   yssdlnZWaf8J1vor130DgVlPwGWw6pLMQGUfI9QjcZsJUvxEdD/JJoIfz
   xXmqnIHiNR3N3ea47gzwUmo3majGmE47s9d25e5rIFaRA1CYpdGF/wxb/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="348543426"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="348543426"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 19:29:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="544842000"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.215.78]) ([10.254.215.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 19:29:44 -0700
Message-ID: <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
Date:   Mon, 11 Jul 2022 10:29:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
 <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481FF0AE64F3BB24FF8A869DC829@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2022 12:23 AM, Parav Pandit wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 8, 2022 2:21 AM
>>
>>
>> On 7/2/2022 6:07 AM, Parav Pandit wrote:
>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue
>>>> pair, so when userspace querying queue pair numbers, it should return
>>>> mq=1 than zero.
>>>>
>>>> Function vdpa_dev_net_config_fill() fills the attributions of the
>>>> vDPA devices, so that it should call vdpa_dev_net_mq_config_fill() so
>>>> the parameter in vdpa_dev_net_mq_config_fill() should be
>>>> feature_device than feature_driver for the vDPA devices themselves
>>>>
>>>> Before this change, when MQ = 0, iproute2 output:
>>>> $vdpa dev config show vdpa0
>>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs
>>>> 0 mtu 1500
>>>>
>>> The fix belongs to user space.
>>> When a feature bit _MQ is not negotiated, vdpa kernel space will not add
>> attribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
>>> When such attribute is not returned by kernel, max_vq_pairs should not
>> be shown by the iproute2.
>> I think userspace tool does not need to care whether MQ is offered or
>> negotiated, it just needs to read the number of queues there, so if no MQ, it
>> is not "not any queues", there are still 1 queue pair to be a virtio-net device,
>> means two queues.
>>
>> If not, how can you tell the user there are only 2 queues? The end users may
>> don't know this is default. They may misunderstand this as an error or
>> defects.
> When max_vq_pairs is not shown, it means that device didn’t expose MAX_VQ_PAIRS attribute to its guest users.
> (Because _MQ was not negotiated).
> It is not error or defect.
> It precisely shows what is exposed.
>
> User space will care when it wants to turn off/on _MQ feature bits and MAX_QP values.
>
> Showing max_vq_pairs of 1 even when _MQ is not negotiated, incorrectly says that max_vq_pairs is exposed to the guest, but it is not offered.
>
> So, please fix the iproute2 to not print max_vq_pairs when it is not returned by the kernel.
iproute2 can report whether there is MQ feature in the device / driver 
feature bits.
I think iproute2 only queries the number of max queues here.

max_vq_pairs shows how many queue pairs there, this attribute's existence does not depend on MQ,
if no MQ, there are still one queue pair, so just show one.

>
>>> We have many config space fields that depend on the feature bits and
>> some of them do not have any defaults.
>>> To keep consistency of existence of config space fields among all, we don't
>> want to show default like below.
>>> Please fix the iproute2 to not print max_vq_pairs when it is not returned
>> by the kernel.
>>>> After applying this commit, when MQ = 0, iproute2 output:
>>>> $vdpa dev config show vdpa0
>>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs
>>>> 1 mtu 1500
>>>>
>>>> Fixes: a64917bc2e9b (vdpa: Provide interface to read driver features)
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>    drivers/vdpa/vdpa.c | 7 ++++---
>>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>> d76b22b2f7ae..846dd37f3549 100644
>>>> --- a/drivers/vdpa/vdpa.c
>>>> +++ b/drivers/vdpa/vdpa.c
>>>> @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
>>>> vdpa_device *vdev,
>>>>    	u16 val_u16;
>>>>
>>>>    	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>>> -		return 0;
>>>> +		val_u16 = 1;
>>>> +	else
>>>> +		val_u16 = __virtio16_to_cpu(true, config-
>>>>> max_virtqueue_pairs);
>>>> -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>>    	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
>> val_u16);
>>>> }
>>>>
>>>> @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>    			      VDPA_ATTR_PAD))
>>>>    		return -EMSGSIZE;
>>>>
>>>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>>>> &config);
>>>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
>>>> +&config);
>>>>    }
>>>>
>>>>    static int
>>>> --
>>>> 2.31.1

