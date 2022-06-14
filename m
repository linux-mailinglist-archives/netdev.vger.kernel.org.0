Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08C54A70E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352984AbiFNCwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354554AbiFNCw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:52:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025715EBC9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 19:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655174025; x=1686710025;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gvxkc06xn5TgEAPETeiWJqvs/ZM0egKM0nEBGVJghAY=;
  b=NDSJkr6LVKrkoTDUzPk1fleCkVJiJUNwECd9TEtuvx8a1e9ZiiqvjEye
   XYtIoHwUWbozSqpQJKsqlMy6anXLsyQNrVVga/29cP3zb4D40xjFhjiZq
   qYZopbgRvb8jQqdXyktn6KIv5gvRDDPAzw6ew2gNk8cckdV+ig93G79ar
   MF6tSLsPafj1+DbeeITbOYkxw/VZiU0WfLmDAa9Js30WcirOVqbkKT6jE
   /POfONIr5vWosmtsU2WRGg+kBeE59kcB1213DJSbzrgU809je/d586FkM
   HIZqelxs7sUVqpzPbNdOpAadGMxFG6PdH+h+78ECZsQ3po9wzWweYO38g
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="276012212"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="276012212"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:33:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="910717135"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.211.167]) ([10.254.211.167])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:33:31 -0700
Message-ID: <05c09bdd-278c-af18-e087-d74a511a4305@intel.com>
Date:   Tue, 14 Jun 2022 10:33:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
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
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
 <20220613101652.195216-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481D2A01569549281D01411DCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481D2A01569549281D01411DCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/2022 4:36 AM, Parav Pandit wrote:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Monday, June 13, 2022 6:17 AM
>> To: jasowang@redhat.com; mst@redhat.com
>> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; Parav
>> Pandit <parav@nvidia.com>; xieyongji@bytedance.com;
>> gautam.dawar@amd.com; Zhu Lingshan <lingshan.zhu@intel.com>
>> Subject: [PATCH V2 5/6] vDPA: answer num of queue pairs = 1 to userspace
>> when VIRTIO_NET_F_MQ == 0
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
> Max_vq_pairs should not be printed when _MQ feature is not negotiated.
> Existing code that returns 0 is correct following this line of the spec.
>
> " The following driver-read-only field, max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or VIRTIO_-
> NET_F_RSS is set."
> The field doesn't exist when _MQ is not there. Hence, it should not be printed.
> Is _RSS offered and is that why you see it?
>
> If not a fix in the iproute2/vdpa should be done.
IMHO, The spec says:
The following driver-read-only field, max_virtqueue_pairs only exists if 
VIRTIO_NET_F_MQ is *set*

The spec doesn't say:
The following driver-read-only field, max_virtqueue_pairs only exists if 
VIRTIO_NET_F_MQ is *negotiated*

If a device is capable of of multi-queues, this capability does not 
depend on the driver. We are querying the device, not the driver.

If there is MQ, we print the onboard implemented total number of the 
queue pairs.
If MQ is not set, we will not read the onboard mq number, because it is 
not there as the spec says.
But there should be at least one queue pair to be a functional 
virtio-net, so 1 is printed.

Thanks,
Zhu Lingshan

>
>
>> After applying this commit, when MQ = 0, iproute2 output:
>> $vdpa dev config show vdpa0
>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
>> mtu 1500
>>
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

