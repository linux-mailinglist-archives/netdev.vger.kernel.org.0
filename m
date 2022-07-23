Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E763B57EF06
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiGWLYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 07:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237274AbiGWLYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 07:24:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA564198B
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658575479; x=1690111479;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yHqxhxjUu6Mf6EKy/YnOhssEdeIYmC2eBhbCJGIIFNc=;
  b=Q7NKmeudY5wMYrrLbtcQWSF2nbys5c50V+1OIfTAke+phc5fvYMbw8sR
   Th8Mnmi2FqvP/zdC/dxFvRKuwGxccMdx5VXPvgC4cB4v31aGIWOgEvBl9
   bo/4YXnUq9m/OO8F6auAlQICF6IhCNXc+ExvR/F4S/fK1XzKSSyiJJvxz
   nU83VYjz6ZLxRSpyucBLsTpmTf3WIBG7nxNruTAfOyiuqrXucJjA3DyaQ
   kjP+dgMM6AhqIvKH9lFMPlnj/QLLQF5Pl5JAOWoMJYONV31Siqvoqeeti
   EqcVYlKjiF9Xt/GgYg3O3ER1fDoWnK1LtQfYEUZRJppzpFT1C01+Yrlgp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="288642057"
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="288642057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 04:24:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="657529934"
Received: from qianyuwa-mobl2.ccr.corp.intel.com (HELO [10.249.169.178]) ([10.249.169.178])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 04:24:37 -0700
Message-ID: <fb6ff4da-e3b8-b8dd-1566-9e394d99afea@intel.com>
Date:   Sat, 23 Jul 2022 19:24:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
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
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/2022 9:14 PM, Parav Pandit wrote:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 22, 2022 7:53 AM
>>
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
>> After applying this commit, when MQ = 0, iproute2 output:
>> $vdpa dev config show vdpa0
>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
>> mtu 1500
>>
> No. We do not want to diverge returning values of config space for fields which are not present as discussed in previous versions.
> Please drop this patch.
> Nack on this patch.
I believe MST has replied to you in the V3 thread, did you miss that?
>
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

