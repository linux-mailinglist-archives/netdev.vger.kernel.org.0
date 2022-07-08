Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756BA56B2AE
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbiGHGZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiGHGZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:25:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684412E6BE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657261513; x=1688797513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UVQ+R76tdh2zCME0atabhXNAtCZpCgJKgLiQb0cIXtQ=;
  b=mPfuKVYTROfaNbTSi9HwJHcG9FFVtLBc7bnY++WWkrhj8GO9AJInWKrM
   AFZEQondM1Jmzk0iM2t/0AfxCPItC/5qpwbHxn2+SoPSPSMj+rOih8nBb
   +guPRKRJmRKE5AXTK6ioHoyC/0yN1IYCYC2O3SGJrd1TL8bOZJ3mVICRW
   L4yV5n3VGlAZvxxJSKBk0hYIGm24Dq7WbqstBo2NAt/kV3HbyLwKuZA0M
   copoWL47kabgZVfMZvCazOfX91yz0Fz++2bkmZFRRui2eN2klrOt7ZHwj
   +BZo7DcR+4rmwoOE7GW8/LxqFEV2mCdrJxmoK1nG3Qhbq8Nx9VHmgjCX5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="370517051"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="370517051"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:25:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="920886254"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.210.36]) ([10.254.210.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:25:11 -0700
Message-ID: <dea8be07-bc25-192c-ecd7-636cbdb2a629@intel.com>
Date:   Fri, 8 Jul 2022 14:25:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
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
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <PH0PR12MB5481D4D77EAC336BA68E85AADCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481D4D77EAC336BA68E85AADCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
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



On 7/2/2022 6:18 AM, Parav Pandit wrote:
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 1, 2022 9:28 AM
>>
>> This commit fixes spars warnings: cast to restricted __le16 in function
>> vdpa_dev_net_config_fill() and
>> vdpa_fill_stats_rec()
>>
> Missing fixes tag.
I am not sure whether this deserve a fix tag, I will look into it.
>   
> But I fail to understand the warning.
> config.status is le16, and API used is to convert le16 to cpu.
> What is the warning about, can you please explain?
The warnings are:
drivers/vdpa/vdpa.c:828:19: warning: cast to restricted __le16
drivers/vdpa/vdpa.c:828:19: warning: cast from restricted __virtio16
>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>> 846dd37f3549..ed49fe46a79e 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct
>> vdpa_device *vdev, struct sk_buff *ms
>>   		    config.mac))
>>   		return -EMSGSIZE;
>>
>> -	val_u16 = le16_to_cpu(config.status);
>> +	val_u16 = __virtio16_to_cpu(true, config.status);
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>   		return -EMSGSIZE;
>>
>> -	val_u16 = le16_to_cpu(config.mtu);
>> +	val_u16 = __virtio16_to_cpu(true, config.mtu);
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>   		return -EMSGSIZE;
>>
>> @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device
>> *vdev, struct sk_buff *msg,
>>   	}
>>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>
>> -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
>> +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
>> max_vqp))
>>   		return -EMSGSIZE;
>>
>> --
>> 2.31.1

