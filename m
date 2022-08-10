Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451AD58E4E7
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 04:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiHJCkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 22:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiHJCkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 22:40:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F8BDC9
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 19:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660099239; x=1691635239;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3j0Q7/PgmnqAwyZDeqYybJq0gPgxTSeGKsqOzCDhMUw=;
  b=b8O5yEqQn37GQ3iUrWlMLeDv7PpmF/8xEj7e7Ya0OoAF7lfZ3p2yTTd4
   nQ7eP5bwKcwfNtyrern9n7k9L6aJkkRAvvVEmEbu55kKq5DFb8b51K8/F
   52FCTclOp3fb3STdkbo2YIfiQ4OdCTRBbe9t3p15zDcoNpkLBlzUGqgxF
   KdmQsDz1xVy+Oc3wLFyCB7tAwovHeDJOiSfYKYrn458ZUCr1ox9uBrDZ9
   4D8aGxjB/kZbr8ihOWLcCC7xkAWHxOjnRMRMeeZsqcBtNSXAzL5kehKOq
   ES4zRwWWKxirpJo1SbOFFgCQwpWDAmqF1BR0h/kuD+4lBxYoMyn3j4WI1
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="270754998"
X-IronPort-AV: E=Sophos;i="5.93,226,1654585200"; 
   d="scan'208";a="270754998"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 19:40:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,226,1654585200"; 
   d="scan'208";a="581049798"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.172.33]) ([10.249.172.33])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 19:40:36 -0700
Message-ID: <3752774e-7ced-3837-6445-7791a50d0198@intel.com>
Date:   Wed, 10 Aug 2022 10:40:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220809152457-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220809152457-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2022 3:36 AM, Michael S. Tsirkin wrote:
> On Fri, Jul 22, 2022 at 01:14:42PM +0000, Parav Pandit wrote:
>>
>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Sent: Friday, July 22, 2022 7:53 AM
>>>
>>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
>>> when userspace querying queue pair numbers, it should return mq=1 than
>>> zero.
>>>
>>> Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
>>> devices, so that it should call vdpa_dev_net_mq_config_fill() so the
>>> parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
>>> feature_driver for the vDPA devices themselves
>>>
>>> Before this change, when MQ = 0, iproute2 output:
>>> $vdpa dev config show vdpa0
>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
>>> mtu 1500
>>>
>>> After applying this commit, when MQ = 0, iproute2 output:
>>> $vdpa dev config show vdpa0
>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
>>> mtu 1500
>>>
>> No. We do not want to diverge returning values of config space for fields which are not present as discussed in previous versions.
>> Please drop this patch.
>> Nack on this patch.
> Wrt this patch as far as I'm concerned you guys are bikeshedding.
>
> Parav generally don't send nacks please they are not helpful.
>
> Zhu Lingshan please always address comments in some way.  E.g. refer to
> them in the commit log explaining the motivation and the alternatives.
> I know you don't agree with Parav but ghosting isn't nice.
I can work out a better commit message, currently I have an example on
how to process MQ = 0. I will handle all conditional fields(MTC, MAC...) 
here.
So I will explain them both in general and details for every field.

Thanks,
Zhu Lingshan
>
> I still feel what we should have done is
> not return a value, as long as we do return it we might
> as well return something reasonable, not 0.
>
> And I like it that this fixes sparse warning actually:
> max_virtqueue_pairs it tagged as __virtio, not __le.
>
> However, I am worried there is another bug here:
> this is checking driver features. But really max vqs
> should not depend on that, it depends on device
> features, no?
We have this fix in this patch below:

return vdpa_dev_net_mq_config_fill(vdev, msg, features_device, &config);

this checks device features.

Thanks,
Zhu Lingshan

>
>
>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/vdpa.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>> d76b22b2f7ae..846dd37f3549 100644
>>> --- a/drivers/vdpa/vdpa.c
>>> +++ b/drivers/vdpa/vdpa.c
>>> @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
>>> vdpa_device *vdev,
>>>   	u16 val_u16;
>>>
>>>   	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>> -		return 0;
>>> +		val_u16 = 1;
>>> +	else
>>> +		val_u16 = __virtio16_to_cpu(true, config-
>>>> max_virtqueue_pairs);
>>> -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>   	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
>>> val_u16);  }
>>>
>>> @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
>>> vdpa_device *vdev, struct sk_buff *ms
>>>   			      VDPA_ATTR_PAD))
>>>   		return -EMSGSIZE;
>>>
>>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>>> &config);
>>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
>>> +&config);
>>>   }
>>>
>>>   static int
>>> --
>>> 2.31.1

