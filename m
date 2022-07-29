Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D07C584E17
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiG2Jfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiG2Jf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:35:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7E73B977
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659087326; x=1690623326;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BWr3Nyz07ICJ0sJvRQzisjYWIj+bdWIWvjkrX2zs2bk=;
  b=IAe0RtBlEpC5UCTkrN6WuylC70LovAJsi+iz1SN7dP6azjk7klX4l/D+
   NXIIaJb9oO/Wolu/3V6R4VeF5J+F6WsqMJzBLfue6WmUcxd7oErVuuGj1
   HOMhb4fsgdlqSPtUcEvOfxsOsPtMsYSuxw2G1Cf/P4+tV8YaDKFnCGK++
   aELToQQL7195Gp+CtZPQJb2i2HyuyZg5sJVux1Ona02ANo7jyBxTbP79S
   F9XDYVHlEdB1mDsQ0uFJ/BeIOXiY9bC6BPzzFPBPe2DyLkm6IGDljFl6o
   ghdLWYuYBnNoTgrJ0VNsi8boQXLtGgiqfmoAywuY0zJ5Uu0w72Da12OlM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="287486234"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="287486234"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 02:35:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="660166078"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.175.200]) ([10.249.175.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 02:35:11 -0700
Message-ID: <05bf4c84-28dd-4956-4719-3a5361d151d8@intel.com>
Date:   Fri, 29 Jul 2022 17:35:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <20220729045039-mutt-send-email-mst@kernel.org>
 <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
 <20220729051119-mutt-send-email-mst@kernel.org>
 <50b4e7ba-3e49-24b7-5c23-d8a76c61c924@intel.com>
 <20220729052149-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220729052149-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/2022 5:23 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 29, 2022 at 05:20:17PM +0800, Zhu, Lingshan wrote:
>>
>> On 7/29/2022 5:17 PM, Michael S. Tsirkin wrote:
>>> On Fri, Jul 29, 2022 at 05:07:11PM +0800, Zhu, Lingshan wrote:
>>>> On 7/29/2022 4:53 PM, Michael S. Tsirkin wrote:
>>>>> On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
>>>>>> This commit fixes spars warnings: cast to restricted __le16
>>>>>> in function vdpa_dev_net_config_fill() and
>>>>>> vdpa_fill_stats_rec()
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>     drivers/vdpa/vdpa.c | 6 +++---
>>>>>>     1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>>>> index 846dd37f3549..ed49fe46a79e 100644
>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>> @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>>>     		    config.mac))
>>>>>>     		return -EMSGSIZE;
>>>>>> -	val_u16 = le16_to_cpu(config.status);
>>>>>> +	val_u16 = __virtio16_to_cpu(true, config.status);
>>>>>>     	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>>     		return -EMSGSIZE;
>>>>>> -	val_u16 = le16_to_cpu(config.mtu);
>>>>>> +	val_u16 = __virtio16_to_cpu(true, config.mtu);
>>>>>>     	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>     		return -EMSGSIZE;
>>>>> Wrong on BE platforms with legacy interface, isn't it?
>>>>> We generally don't handle legacy properly in VDPA so it's
>>>>> not a huge deal, but maybe add a comment at least?
>>>> Sure, I can add a comment here: this is for modern devices only.
>>>>
>>>> Thanks,
>>>> Zhu Lingshan
>>> Hmm. what "this" is for modern devices only here?
>> this cast, for LE modern devices.
> I think status existed in legacy for sure, and it's possible that
> some legacy devices backported mtu and max_virtqueue_pairs otherwise
> we would have these fields as __le not as __virtio, right?
yes, that's the reason why it is virtio_16 than just le16.

I may find a better solution to detect whether it is LE, or BE without a 
virtio_dev structure.
Check whether vdpa_device->get_device_features() has VIRTIO_F_VERISON_1. 
If the device offers _F_VERSION_1, then it is a LE device,
or it is a BE device, then we use __virtio16_to_cpu(false, config.status).

Does this look good?

>
>>>>>> @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
>>>>>>     	}
>>>>>>     	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>> -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
>>>>>> +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>>>>>     	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>>>>>>     		return -EMSGSIZE;
>>>>>> -- 
>>>>>> 2.31.1

