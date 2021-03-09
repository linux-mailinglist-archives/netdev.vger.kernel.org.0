Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C44A331D10
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhCICmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:42:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229764AbhCICmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615257731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3NcIctlEacedKnvWxLBPKXMEmj3VYiIJnpjJRUyQZE=;
        b=Y440atiw9hsYBdv9mKWAvhDbMhPubhPja/G1LmlsYlpBUFBhvo/xZSRNRq4XhTuis9mLh6
        hb8q1hcLB+bdiwZO2reXUfixirbpd0B8K78+JRS+ZP1b6qOMiZtfaXsw9iVouOTS93rKX9
        X3A+q3vvM2TGENvUkz3R1UmOufXBWSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-o4boJwIyOoqeBNKvt6YJ-g-1; Mon, 08 Mar 2021 21:42:10 -0500
X-MC-Unique: o4boJwIyOoqeBNKvt6YJ-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DB1B814313;
        Tue,  9 Mar 2021 02:42:09 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B23C5D6D7;
        Tue,  9 Mar 2021 02:42:03 +0000 (UTC)
Subject: Re: [PATCH V2 2/4] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for
 vDPA
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-3-lingshan.zhu@intel.com>
 <d37ea3f4-1c18-087b-a444-0d4e1ebbe417@redhat.com>
 <93aabf0c-3ea0-72d7-e7d7-1d503fe6cc75@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <91c08fdd-0a36-ddca-5b8c-ef2eef7cddc2@redhat.com>
Date:   Tue, 9 Mar 2021 10:42:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <93aabf0c-3ea0-72d7-e7d7-1d503fe6cc75@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/9 10:28 上午, Zhu, Lingshan wrote:
>
>
> On 3/9/2021 10:23 AM, Jason Wang wrote:
>>
>> On 2021/3/8 4:35 下午, Zhu Lingshan wrote:
>>> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
>>> for vDPA
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 5 +++++
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>>>   2 files changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> index 64696d63fe07..75d9a8052039 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> @@ -23,6 +23,11 @@
>>>   #define IFCVF_SUBSYS_VENDOR_ID    0x8086
>>>   #define IFCVF_SUBSYS_DEVICE_ID    0x001A
>>>   +#define C5000X_PL_VENDOR_ID        0x1AF4
>>> +#define C5000X_PL_DEVICE_ID        0x1000
>>> +#define C5000X_PL_SUBSYS_VENDOR_ID    0x8086
>>> +#define C5000X_PL_SUBSYS_DEVICE_ID    0x0001
>>
>>
>> I just notice that the device is a transtitional one. Any reason for 
>> doing this?
>>
>> Note that IFCVF is a moden device anyhow (0x1041). Supporting legacy 
>> drive may bring many issues (e.g the definition is non-nomartive). 
>> One example is the support of VIRTIO_F_IOMMU_PLATFORM, legacy driver 
>> may assume the device can bypass IOMMU.
>>
>> Thanks
> Hi Jason,
>
> This device will support virtio1.0 by default, so has 
> VIRTIO_F_IOMMU_PLATFORM by default.


If you device want to force VIRTIO_F_IOMMU_PLATFORM you probably need to 
do what has been done by mlx5 (verify_min_features).

According to the spec, if VIRTIO_F_IOMMU_PLATFORM is not mandatory, when 
it's not negotiated, device needs to disable or bypass IOMMU:


"

If this feature bit is set to 0, then the device has same access to 
memory addresses supplied to it as the driver has. In particular, the 
device will always use physical addresses matching addresses used by the 
driver (typically meaning physical addresses used by the CPU) and not 
translated further, and can access any address supplied to it by the driver.

"


> Transitional device gives the software a chance to fall back to virtio 
> 0.95.


This only applies if you want to passthrough the card to guest directly 
without the help of vDPA.

If we go with vDPA, it doesn't hlep. For virtio-vdpa, we know it will 
negotiated IOMMU_PLATFORM. For vhost-vdpa, Qemu can provide a legacy or 
transitional device on top of a modern vDPA device.

Thanks


> ifcvf drives this device in virtio 1.0 mode, set features 
> VIRTIO_F_IOMMU_PLATFORM successfully.
>
> Thanks,
> Zhu Lingshan
>>
>>
>>> +
>>>   #define IFCVF_SUPPORTED_FEATURES \
>>>           ((1ULL << VIRTIO_NET_F_MAC)            | \
>>>            (1ULL << VIRTIO_F_ANY_LAYOUT)            | \
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index e501ee07de17..26a2dab7ca66 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -484,6 +484,11 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>>>           IFCVF_DEVICE_ID,
>>>           IFCVF_SUBSYS_VENDOR_ID,
>>>           IFCVF_SUBSYS_DEVICE_ID) },
>>> +    { PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>>> +             C5000X_PL_DEVICE_ID,
>>> +             C5000X_PL_SUBSYS_VENDOR_ID,
>>> +             C5000X_PL_SUBSYS_DEVICE_ID) },
>>> +
>>>       { 0 },
>>>   };
>>>   MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
>>
>

