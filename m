Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9F44B4210
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 07:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiBNGoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 01:44:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiBNGoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 01:44:16 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC374D62F
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 22:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644821049; x=1676357049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h7uqGHg0mdDVVrdjwV8gP/W7pg8dKWm2LeDFWTZnsPg=;
  b=LVNT+tNY5pFXYDLyYrgxkUerEPPhRetlbKH+Ew/RdEI/Tw44+WWa0/SJ
   rCN30xc/eKLdW1bpWMDRfqD4k4i78lqUApiA08G5EIA/Ck9VG1d8HyP1A
   KjKEiXPOmbmzQD20R2omtKzlQmXUOKIB3l0G5n2npks5ma97d+u5FfpaY
   kWPGJPI3sXFrJL1ZkNzqq8KO5gpIu28Omu5/VGAOl/hjGTbSSMEkLTCF+
   SqpSZRuwwRY5LwPN6tpv01+q9bokiKKn7oAzQmuenSvKfgfWYg3KY6FmQ
   RIxH65zVsA9b+sxjOTvARcdSGFp++g79PpmvHmRAPMgdtqqM0J5BJz5Kk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="247621224"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="247621224"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 22:44:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="543239376"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.175.112]) ([10.249.175.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 22:44:07 -0800
Message-ID: <1e5af9e7-1311-3fa2-17bf-246a011f52e7@intel.com>
Date:   Mon, 14 Feb 2022 14:43:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.1
Subject: Re: [PATCH V4 1/4] vDPA/ifcvf: implement IO read/write helpers in the
 header file
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220203072735.189716-1-lingshan.zhu@intel.com>
 <20220203072735.189716-2-lingshan.zhu@intel.com>
 <5b9e287a-08bd-10b9-4159-5b36f192a387@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <5b9e287a-08bd-10b9-4159-5b36f192a387@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2022 2:15 PM, Jason Wang wrote:
>
> 在 2022/2/3 下午3:27, Zhu Lingshan 写道:
>> re-implement IO read/write helpers in the header file, so that
>> they can be utilized among modules.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>
>
> I wonder if we can simply use include/linux/virtio_pci_modern.h.
>
> The accessors vp_ioreadX/writeX() there were decoupled from the 
> virtio_pci_modern_device structure.
>
> Thanks
sure, can do.

Thanks
>
>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 36 --------------------------------
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 37 +++++++++++++++++++++++++++++++++
>>   2 files changed, 37 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index 7d41dfe48ade..397692ae671c 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -10,42 +10,6 @@
>>     #include "ifcvf_base.h"
>>   -static inline u8 ifc_ioread8(u8 __iomem *addr)
>> -{
>> -    return ioread8(addr);
>> -}
>> -static inline u16 ifc_ioread16 (__le16 __iomem *addr)
>> -{
>> -    return ioread16(addr);
>> -}
>> -
>> -static inline u32 ifc_ioread32(__le32 __iomem *addr)
>> -{
>> -    return ioread32(addr);
>> -}
>> -
>> -static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
>> -{
>> -    iowrite8(value, addr);
>> -}
>> -
>> -static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
>> -{
>> -    iowrite16(value, addr);
>> -}
>> -
>> -static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
>> -{
>> -    iowrite32(value, addr);
>> -}
>> -
>> -static void ifc_iowrite64_twopart(u64 val,
>> -                  __le32 __iomem *lo, __le32 __iomem *hi)
>> -{
>> -    ifc_iowrite32((u32)val, lo);
>> -    ifc_iowrite32(val >> 32, hi);
>> -}
>> -
>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
>>   {
>>       return container_of(hw, struct ifcvf_adapter, vf);
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index c486873f370a..949b4fb9d554 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -42,6 +42,43 @@
>>   #define ifcvf_private_to_vf(adapter) \
>>       (&((struct ifcvf_adapter *)adapter)->vf)
>>   +static inline u8 ifc_ioread8(u8 __iomem *addr)
>> +{
>> +    return ioread8(addr);
>> +}
>> +
>> +static inline u16 ifc_ioread16(__le16 __iomem *addr)
>> +{
>> +    return ioread16(addr);
>> +}
>> +
>> +static inline u32 ifc_ioread32(__le32 __iomem *addr)
>> +{
>> +    return ioread32(addr);
>> +}
>> +
>> +static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
>> +{
>> +    iowrite8(value, addr);
>> +}
>> +
>> +static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
>> +{
>> +    iowrite16(value, addr);
>> +}
>> +
>> +static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
>> +{
>> +    iowrite32(value, addr);
>> +}
>> +
>> +static inline void ifc_iowrite64_twopart(u64 val,
>> +                  __le32 __iomem *lo, __le32 __iomem *hi)
>> +{
>> +    ifc_iowrite32((u32)val, lo);
>> +    ifc_iowrite32(val >> 32, hi);
>> +}
>> +
>>   struct vring_info {
>>       u64 desc;
>>       u64 avail;
>

