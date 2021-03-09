Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E08331EC5
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 06:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhCIFvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 00:51:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:26342 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhCIFup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 00:50:45 -0500
IronPort-SDR: zTsIF8QdPj/DEcmjbc4Grobmt5IhBDiQ2eMDYURy43MZ48yW6Ha2K1qu4/bvozjGyUGa8c/oQz
 8EJxKuRjQuQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188211755"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="188211755"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 21:50:44 -0800
IronPort-SDR: eBfZNne6GFYr0HVLC5ATPoAVGAgEzKJ8YYJ4noZ2rarbc2fN4gbwEvvNKaVjtkHN9azhPg4kKw
 0rxeOXHMlf0A==
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="447383043"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.31.165]) ([10.255.31.165])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 21:50:42 -0800
Subject: Re: [PATCH V2 2/4] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for
 vDPA
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-3-lingshan.zhu@intel.com>
 <d37ea3f4-1c18-087b-a444-0d4e1ebbe417@redhat.com>
 <93aabf0c-3ea0-72d7-e7d7-1d503fe6cc75@intel.com>
 <91c08fdd-0a36-ddca-5b8c-ef2eef7cddc2@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <0e72009d-60af-980d-a43e-495733f6f6f7@intel.com>
Date:   Tue, 9 Mar 2021 13:50:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <91c08fdd-0a36-ddca-5b8c-ef2eef7cddc2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/2021 10:42 AM, Jason Wang wrote:
>
> On 2021/3/9 10:28 上午, Zhu, Lingshan wrote:
>>
>>
>> On 3/9/2021 10:23 AM, Jason Wang wrote:
>>>
>>> On 2021/3/8 4:35 下午, Zhu Lingshan wrote:
>>>> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
>>>> for vDPA
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 5 +++++
>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>>>>   2 files changed, 10 insertions(+)
>>>>
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> index 64696d63fe07..75d9a8052039 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> @@ -23,6 +23,11 @@
>>>>   #define IFCVF_SUBSYS_VENDOR_ID    0x8086
>>>>   #define IFCVF_SUBSYS_DEVICE_ID    0x001A
>>>>   +#define C5000X_PL_VENDOR_ID        0x1AF4
>>>> +#define C5000X_PL_DEVICE_ID        0x1000
>>>> +#define C5000X_PL_SUBSYS_VENDOR_ID    0x8086
>>>> +#define C5000X_PL_SUBSYS_DEVICE_ID    0x0001
>>>
>>>
>>> I just notice that the device is a transtitional one. Any reason for 
>>> doing this?
>>>
>>> Note that IFCVF is a moden device anyhow (0x1041). Supporting legacy 
>>> drive may bring many issues (e.g the definition is non-nomartive). 
>>> One example is the support of VIRTIO_F_IOMMU_PLATFORM, legacy driver 
>>> may assume the device can bypass IOMMU.
>>>
>>> Thanks
>> Hi Jason,
>>
>> This device will support virtio1.0 by default, so has 
>> VIRTIO_F_IOMMU_PLATFORM by default.
>
>
> If you device want to force VIRTIO_F_IOMMU_PLATFORM you probably need 
> to do what has been done by mlx5 (verify_min_features).
>
> According to the spec, if VIRTIO_F_IOMMU_PLATFORM is not mandatory, 
> when it's not negotiated, device needs to disable or bypass IOMMU:
>
>
> "
>
> If this feature bit is set to 0, then the device has same access to 
> memory addresses supplied to it as the driver has. In particular, the 
> device will always use physical addresses matching addresses used by 
> the driver (typically meaning physical addresses used by the CPU) and 
> not translated further, and can access any address supplied to it by 
> the driver.
>
> "
sure, I can implement code to check the feature bits.
>
>
>> Transitional device gives the software a chance to fall back to 
>> virtio 0.95.
>
>
> This only applies if you want to passthrough the card to guest 
> directly without the help of vDPA.
>
> If we go with vDPA, it doesn't hlep. For virtio-vdpa, we know it will 
> negotiated IOMMU_PLATFORM. For vhost-vdpa, Qemu can provide a legacy 
> or transitional device on top of a modern vDPA device.
>
> Thanks
For some cases, users may run quite out of date OS does not have vDPA 
nor virtio 1.0 support, transitional characters give them a chance to 
use the devices.

Thanks
Zhu Lingshan
>
>
>> ifcvf drives this device in virtio 1.0 mode, set features 
>> VIRTIO_F_IOMMU_PLATFORM successfully.
>>
>> Thanks,
>> Zhu Lingshan
>>>
>>>
>>>> +
>>>>   #define IFCVF_SUPPORTED_FEATURES \
>>>>           ((1ULL << VIRTIO_NET_F_MAC)            | \
>>>>            (1ULL << VIRTIO_F_ANY_LAYOUT) | \
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> index e501ee07de17..26a2dab7ca66 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> @@ -484,6 +484,11 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>>>>           IFCVF_DEVICE_ID,
>>>>           IFCVF_SUBSYS_VENDOR_ID,
>>>>           IFCVF_SUBSYS_DEVICE_ID) },
>>>> +    { PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>>>> +             C5000X_PL_DEVICE_ID,
>>>> +             C5000X_PL_SUBSYS_VENDOR_ID,
>>>> +             C5000X_PL_SUBSYS_DEVICE_ID) },
>>>> +
>>>>       { 0 },
>>>>   };
>>>>   MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
>>>
>>
>

