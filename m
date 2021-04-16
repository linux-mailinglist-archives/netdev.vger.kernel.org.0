Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12863617A5
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbhDPCoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:44:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:7733 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhDPCoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:44:05 -0400
IronPort-SDR: jE2WNDS9srrLZglIrCFm/1f0LXvSRhVVmwx/RyJD+F7tC/Lf+EO8JjhRh7Fr/045CWnYa/4rdg
 NEkM1/M1KArA==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="192852609"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="192852609"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 19:43:41 -0700
IronPort-SDR: 6GxEtXwgEAtpkepcSiuf1DxP30dHWpucxPN9l9actHwMAx6xuF7bzbP6NBM3SE61sW2hLHjwcr
 cxbAVprL5Hqw==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="418971669"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.208.190]) ([10.254.208.190])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 19:43:39 -0700
Subject: Re: [PATCH V2 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block
 for vDPA
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210415095336.4792-1-lingshan.zhu@intel.com>
 <20210415095336.4792-3-lingshan.zhu@intel.com>
 <20210415134148.q53glknhktbjwtzz@steredhat>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <27f143ba-72dc-9bcb-c537-277bb382996d@linux.intel.com>
Date:   Fri, 16 Apr 2021 10:43:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415134148.q53glknhktbjwtzz@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 9:41 PM, Stefano Garzarella wrote:
> On Thu, Apr 15, 2021 at 05:53:35PM +0800, Zhu Lingshan wrote:
>> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
>> for vDPA.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>> drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
>> drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++++++-
>> 2 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 1c04cd256fa7..0111bfdeb342 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -15,6 +15,7 @@
>> #include <linux/pci_regs.h>
>> #include <linux/vdpa.h>
>> #include <uapi/linux/virtio_net.h>
>> +#include <uapi/linux/virtio_blk.h>
>> #include <uapi/linux/virtio_config.h>
>> #include <uapi/linux/virtio_pci.h>
>>
>> @@ -28,7 +29,12 @@
>> #define C5000X_PL_SUBSYS_VENDOR_ID    0x8086
>> #define C5000X_PL_SUBSYS_DEVICE_ID    0x0001
>>
>> -#define IFCVF_SUPPORTED_FEATURES \
>> +#define C5000X_PL_BLK_VENDOR_ID        0x1AF4
>> +#define C5000X_PL_BLK_DEVICE_ID        0x1001
>> +#define C5000X_PL_BLK_SUBSYS_VENDOR_ID    0x8086
>> +#define C5000X_PL_BLK_SUBSYS_DEVICE_ID    0x0002
>> +
>> +#define IFCVF_NET_SUPPORTED_FEATURES \
>>         ((1ULL << VIRTIO_NET_F_MAC)            | \
>>          (1ULL << VIRTIO_F_ANY_LAYOUT)            | \
>>          (1ULL << VIRTIO_F_VERSION_1)            | \
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 469a9b5737b7..cea1313b1a3f 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -171,7 +171,11 @@ static u64 ifcvf_vdpa_get_features(struct 
>> vdpa_device *vdpa_dev)
>>     struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>     u64 features;
>>
>> -    features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
>> +    if (vf->dev_type == VIRTIO_ID_NET)
>> +        features = ifcvf_get_features(vf) & 
>> IFCVF_NET_SUPPORTED_FEATURES;
>> +
>> +    if (vf->dev_type == VIRTIO_ID_BLOCK)
>> +        features = ifcvf_get_features(vf);
>>
>
> Should we put a warning here too otherwise feature could be seen 
> unassigned?
Thanks, it will be a switch code block too.
>
> Thanks,
> Stefano
>
>>     return features;
>> }
>> @@ -517,6 +521,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>>              C5000X_PL_DEVICE_ID,
>>              C5000X_PL_SUBSYS_VENDOR_ID,
>>              C5000X_PL_SUBSYS_DEVICE_ID) },
>> +    { PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
>> +             C5000X_PL_BLK_DEVICE_ID,
>> +             C5000X_PL_BLK_SUBSYS_VENDOR_ID,
>> +             C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>>
>>     { 0 },
>> };
>> -- 
>> 2.27.0
>>
>

