Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D776A584DD1
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiG2JHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbiG2JHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:07:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB71584EEA
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659085636; x=1690621636;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+xTRbwrM/+sDoe0LaZiRYKYMp/06kLRrtj5E821wKHY=;
  b=KEoIWwp087GGcmpFNkufzUCn1t9voIgRld1bAkHIJuHbBl3Zq5iwYLtk
   IbyYt1/CFg57Fwr1s2ZLWMbWdNE28eorWiExHeLcRxJCOCd7MxMpXRhGP
   IGNqnLG57QR2OQskH9i8EBKXHL1tz+9UVLTwBmy5mp/V6RWJGc5VQMEKk
   tkLW4bvy5eCEKPTf/5SfXErTZCmhg1OXVItKNpD9MgoTO3RpIRHrvm7gq
   Lnvm896hhcaNEis9VjNiMuGZcr7kdfpkzgY2D+GwkRBPSPql9txJWbolB
   l4wwEl+dzv3mgpGOAqQbpeY6ZfweUOK6U81buB1k828DWIpTyP656u24P
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="352727386"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="352727386"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 02:07:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="660158823"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.175.200]) ([10.249.175.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 02:07:14 -0700
Message-ID: <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
Date:   Fri, 29 Jul 2022 17:07:11 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220729045039-mutt-send-email-mst@kernel.org>
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



On 7/29/2022 4:53 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
>> This commit fixes spars warnings: cast to restricted __le16
>> in function vdpa_dev_net_config_fill() and
>> vdpa_fill_stats_rec()
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index 846dd37f3549..ed49fe46a79e 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
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
> Wrong on BE platforms with legacy interface, isn't it?
> We generally don't handle legacy properly in VDPA so it's
> not a huge deal, but maybe add a comment at least?
Sure, I can add a comment here: this is for modern devices only.

Thanks,
Zhu Lingshan
>
>
>> @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
>>   	}
>>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>   
>> -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
>> +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>>   		return -EMSGSIZE;
>>   
>> -- 
>> 2.31.1

