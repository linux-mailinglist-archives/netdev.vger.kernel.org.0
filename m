Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83194374DD4
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 05:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhEFDMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 23:12:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:36219 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhEFDMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 23:12:40 -0400
IronPort-SDR: mRvMXsoBxE+05dHRknEuSHO3Bxz49gUtSD+aMYVuaNM8yLpCzwPfSIptQ/MSN3Q7xlV+0xI5L8
 1hgzH32tXBDw==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="197999382"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="197999382"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 20:11:41 -0700
IronPort-SDR: ud5s9b3VcWvCVf93UfKRxL2GW59wh8d2FKeG6xK+FOzLX8BnG9ofQo8FgD040JaPNg4ehydTAx
 Jr32T1v3TE3g==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469246591"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.97]) ([10.254.209.97])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 20:11:39 -0700
Subject: Re: [PATCH V4 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block
 for vDPA
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, lulu@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
 <20210419063326.3748-3-lingshan.zhu@intel.com>
 <20210503043801-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <bb4b9fe1-3a4e-f88a-5258-c9b2c63ed203@intel.com>
Date:   Thu, 6 May 2021 11:11:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503043801-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2021 4:47 PM, Michael S. Tsirkin wrote:
> On Mon, Apr 19, 2021 at 02:33:25PM +0800, Zhu Lingshan wrote:
>> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
>> for vDPA.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
>>   2 files changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 1c04cd256fa7..0111bfdeb342 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -15,6 +15,7 @@
>>   #include <linux/pci_regs.h>
>>   #include <linux/vdpa.h>
>>   #include <uapi/linux/virtio_net.h>
>> +#include <uapi/linux/virtio_blk.h>
>>   #include <uapi/linux/virtio_config.h>
>>   #include <uapi/linux/virtio_pci.h>
>>   
>> @@ -28,7 +29,12 @@
>>   #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
>>   #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>>   
>> -#define IFCVF_SUPPORTED_FEATURES \
>> +#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
>
> Come on this is just PCI_VENDOR_ID_REDHAT_QUMRANET right?
Hi Michael,

I will re-use the predefined macro in next patches

#define C5000X_PL_BLK_VENDOR_ID	  PCI_VENDOR_ID_REDHAT_QUMRANET
#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	VIRTIO_ID_BLOCK?

to keep the readabilities in probe().

>
>
>
>> +#define C5000X_PL_BLK_DEVICE_ID		0x1001
> 0x1001 is a transitional blk device from virtio spec too right? Let's add these to virtio_ids.h?
will update virtio_ids.h in next patchset.

Thanks
Zhu Lingshan
>
>> +#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
>> +#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
> VIRTIO_ID_BLOCK?
>
>> +
>> +#define IFCVF_NET_SUPPORTED_FEATURES \
>>   		((1ULL << VIRTIO_NET_F_MAC)			| \
>>   		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
>>   		 (1ULL << VIRTIO_F_VERSION_1)			| \
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 66927ec81fa5..9a4a6df91f08 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -168,10 +168,23 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
>>   
>>   static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
>>   {
>> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> +	struct pci_dev *pdev = adapter->pdev;
>> +
>>   	u64 features;
>>   
>> -	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
>> +	switch (vf->dev_type) {
>> +	case VIRTIO_ID_NET:
>> +		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
>> +		break;
>> +	case VIRTIO_ID_BLOCK:
>> +		features = ifcvf_get_features(vf);
>> +		break;
>> +	default:
>> +		features = 0;
>> +		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>> +	}
>>   
>>   	return features;
>>   }
>> @@ -514,6 +527,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>>   			 C5000X_PL_DEVICE_ID,
>>   			 C5000X_PL_SUBSYS_VENDOR_ID,
>>   			 C5000X_PL_SUBSYS_DEVICE_ID) },
>> +	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
>> +			 C5000X_PL_BLK_DEVICE_ID,
>> +			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
>> +			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>>   
>>   	{ 0 },
>>   };
>> -- 
>> 2.27.0

