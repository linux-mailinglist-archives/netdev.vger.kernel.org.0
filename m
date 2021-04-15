Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE536020F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhDOF4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:56:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:55733 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhDOF4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 01:56:21 -0400
IronPort-SDR: 1Ld0uAvT/uo8k8g6cXYVW38XkQ2G+qb7MTOuGND7NpQ54farzr8aoDyca7CT9uAPLcHf4Dec+n
 ew0Er1rcG5yg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="280106632"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="280106632"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 22:55:59 -0700
IronPort-SDR: cupJIMBQBcEDdz4unJTmXundCH3xLbBbjyxeTiXtI0cMSCP0hiMQChYi/IeWnTMzi8uKBrO4wB
 18ECuXEGsY4A==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="418622476"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.173]) ([10.254.209.173])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 22:55:56 -0700
Subject: Re: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for
 vDPA
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-3-lingshan.zhu@intel.com>
 <54839b05-78d2-8edf-317c-372f0ecda024@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <1a1f9f50-dc92-ced3-759d-e600abca3138@linux.intel.com>
Date:   Thu, 15 Apr 2021 13:55:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <54839b05-78d2-8edf-317c-372f0ecda024@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 11:34 AM, Jason Wang wrote:
>
> 在 2021/4/14 下午5:18, Zhu Lingshan 写道:
>> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
>> for vDPA.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 17 ++++++++++++++++-
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++++++-
>>   2 files changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 1c04cd256fa7..8b403522bf06 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -15,6 +15,7 @@
>>   #include <linux/pci_regs.h>
>>   #include <linux/vdpa.h>
>>   #include <uapi/linux/virtio_net.h>
>> +#include <uapi/linux/virtio_blk.h>
>>   #include <uapi/linux/virtio_config.h>
>>   #include <uapi/linux/virtio_pci.h>
>>   @@ -28,7 +29,12 @@
>>   #define C5000X_PL_SUBSYS_VENDOR_ID    0x8086
>>   #define C5000X_PL_SUBSYS_DEVICE_ID    0x0001
>>   -#define IFCVF_SUPPORTED_FEATURES \
>> +#define C5000X_PL_BLK_VENDOR_ID        0x1AF4
>> +#define C5000X_PL_BLK_DEVICE_ID        0x1001
>> +#define C5000X_PL_BLK_SUBSYS_VENDOR_ID    0x8086
>> +#define C5000X_PL_BLK_SUBSYS_DEVICE_ID    0x0002
>> +
>> +#define IFCVF_NET_SUPPORTED_FEATURES \
>>           ((1ULL << VIRTIO_NET_F_MAC)            | \
>>            (1ULL << VIRTIO_F_ANY_LAYOUT)            | \
>>            (1ULL << VIRTIO_F_VERSION_1)            | \
>> @@ -37,6 +43,15 @@
>>            (1ULL << VIRTIO_F_ACCESS_PLATFORM)        | \
>>            (1ULL << VIRTIO_NET_F_MRG_RXBUF))
>>   +#define IFCVF_BLK_SUPPORTED_FEATURES \
>> +        ((1ULL << VIRTIO_BLK_F_SIZE_MAX)        | \
>> +         (1ULL << VIRTIO_BLK_F_SEG_MAX)            | \
>> +         (1ULL << VIRTIO_BLK_F_BLK_SIZE)        | \
>> +         (1ULL << VIRTIO_BLK_F_TOPOLOGY)        | \
>> +         (1ULL << VIRTIO_BLK_F_MQ)            | \
>> +         (1ULL << VIRTIO_F_VERSION_1)            | \
>> +         (1ULL << VIRTIO_F_ACCESS_PLATFORM))
>
>
> I think we've discussed this sometime in the past but what's the 
> reason for such whitelist consider there's already a get_features() 
> implemention?
>
> E.g Any reason to block VIRTIO_BLK_F_WRITE_ZEROS or VIRTIO_F_RING_PACKED?
>
> Thanks
The reason is some feature bits are supported in the device but not 
supported by the driver, e.g, for virtio-net, mq & cq implementation is 
not ready in the driver.

Thanks!

>
>
>> +
>>   /* Only one queue pair for now. */
>>   #define IFCVF_MAX_QUEUE_PAIRS    1
>>   diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 99b0a6b4c227..9b6a38b798fa 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -171,7 +171,11 @@ static u64 ifcvf_vdpa_get_features(struct 
>> vdpa_device *vdpa_dev)
>>       struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>       u64 features;
>>   -    features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
>> +    if (vf->dev_type == VIRTIO_ID_NET)
>> +        features = ifcvf_get_features(vf) & 
>> IFCVF_NET_SUPPORTED_FEATURES;
>> +
>> +    if (vf->dev_type == VIRTIO_ID_BLOCK)
>> +        features = ifcvf_get_features(vf) & 
>> IFCVF_BLK_SUPPORTED_FEATURES;
>>         return features;
>>   }
>> @@ -509,6 +513,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>>                C5000X_PL_DEVICE_ID,
>>                C5000X_PL_SUBSYS_VENDOR_ID,
>>                C5000X_PL_SUBSYS_DEVICE_ID) },
>> +    { PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
>> +             C5000X_PL_BLK_DEVICE_ID,
>> +             C5000X_PL_BLK_SUBSYS_VENDOR_ID,
>> +             C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>>         { 0 },
>>   };
>

