Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9015556B2BC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiGHGVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiGHGVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:21:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C092CDC0
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657261264; x=1688797264;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XBXi1qyOk24yCoBgZacud8aZXtqMUCt0EwnZ9lt9vMg=;
  b=loGcCXFUi8cnBn787tkEIHerHo9V4MyoUFBHrGlI2sWO4NPLxfNFHwHn
   NMnQxpGOiRbYNHHut9YGI03Nockh9E5l9EJizVe3zCQ3w99GSGM3fSFC4
   Yfc+dUzY3hm8FRlfF6ceZ14N1V6soWuFf9QnfiecNm+8wjf7C9JgSZ3rV
   Zd2IBDN2STXzV7aMMjXl/jjWNrdZsBev+/eswhe6q/rAaZIbTShhg0eKR
   LdyDIIw4IbT3ScCQIbDBiH2FPI8ZBRLhe75nFjjiGGh/fm4iW5azzmdwp
   Ey2wE4lq9vgDdxCeMeQ3SxDclBheM9ljIiH8O47eN5UOh2pzlW0+LowKc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="348187561"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="348187561"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:21:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="920885298"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.210.36]) ([10.254.210.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:21:02 -0700
Message-ID: <ef1c42e8-2350-dd9c-c6c0-2e9bbe85adb4@intel.com>
Date:   Fri, 8 Jul 2022 14:21:00 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/2022 6:07 AM, Parav Pandit wrote:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 1, 2022 9:28 AM
>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
>> when userspace querying queue pair numbers, it should return mq=1 than
>> zero.
>>
>> Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
>> devices, so that it should call vdpa_dev_net_mq_config_fill() so the
>> parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
>> feature_driver for the vDPA devices themselves
>>
>> Before this change, when MQ = 0, iproute2 output:
>> $vdpa dev config show vdpa0
>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
>> mtu 1500
>>
> The fix belongs to user space.
> When a feature bit _MQ is not negotiated, vdpa kernel space will not add attribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
> When such attribute is not returned by kernel, max_vq_pairs should not be shown by the iproute2.
I think userspace tool does not need to care whether MQ is offered or 
negotiated, it just needs to read the number of queues
there, so if no MQ, it is not "not any queues", there are still 1 queue 
pair to be a virtio-net device, means two queues.

If not, how can you tell the user there are only 2 queues? The end users 
may don't know this is default. They may misunderstand this
as an error or defects.
>
> We have many config space fields that depend on the feature bits and some of them do not have any defaults.
> To keep consistency of existence of config space fields among all, we don't want to show default like below.
>
> Please fix the iproute2 to not print max_vq_pairs when it is not returned by the kernel.
>   
>> After applying this commit, when MQ = 0, iproute2 output:
>> $vdpa dev config show vdpa0
>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
>> mtu 1500
>>
>> Fixes: a64917bc2e9b (vdpa: Provide interface to read driver features)
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>> d76b22b2f7ae..846dd37f3549 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
>> vdpa_device *vdev,
>>   	u16 val_u16;
>>
>>   	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>> -		return 0;
>> +		val_u16 = 1;
>> +	else
>> +		val_u16 = __virtio16_to_cpu(true, config-
>>> max_virtqueue_pairs);
>> -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>   	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
>> val_u16);  }
>>
>> @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
>> vdpa_device *vdev, struct sk_buff *ms
>>   			      VDPA_ATTR_PAD))
>>   		return -EMSGSIZE;
>>
>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>> &config);
>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
>> +&config);
>>   }
>>
>>   static int
>> --
>> 2.31.1

