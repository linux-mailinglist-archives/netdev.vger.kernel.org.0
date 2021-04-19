Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161FC3639AE
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 05:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbhDSDRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 23:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233179AbhDSDRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 23:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618802211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ngjLvfqraclHl1dSfqaoWbo+wa4rNwfdo8glbMm71to=;
        b=IYOtNGHRyLbDvHybmBtmp/B8btZHfSyjSVIEO0Ic8JlHkmRhw020ROzNtzbeb3t0qpg7un
        GT9jIze/CiuaheJ9bkXschThDD37JcbceWt3F/NuqulLX2T5D+scURuKyIBXWYMOAwVfi3
        dDO9PaSpfAIcoW2+5WnOpP3x9ghEPU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-x3xdpjwoMEGg9q0LOEIJaA-1; Sun, 18 Apr 2021 23:16:47 -0400
X-MC-Unique: x3xdpjwoMEGg9q0LOEIJaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 751CB18B63A8;
        Mon, 19 Apr 2021 03:16:46 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A51C219809;
        Mon, 19 Apr 2021 03:16:40 +0000 (UTC)
Subject: Re: [PATCH V3 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block
 for vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
 <20210416071628.4984-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4cce68b5-9cca-1ccd-f219-fb66c50a4f75@redhat.com>
Date:   Mon, 19 Apr 2021 11:16:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416071628.4984-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/16 ÏÂÎç3:16, Zhu Lingshan Ð´µÀ:
> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
> for vDPA.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  8 +++++++-
>   drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
>   2 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 1c04cd256fa7..0111bfdeb342 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -15,6 +15,7 @@
>   #include <linux/pci_regs.h>
>   #include <linux/vdpa.h>
>   #include <uapi/linux/virtio_net.h>
> +#include <uapi/linux/virtio_blk.h>
>   #include <uapi/linux/virtio_config.h>
>   #include <uapi/linux/virtio_pci.h>
>   
> @@ -28,7 +29,12 @@
>   #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
>   #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>   
> -#define IFCVF_SUPPORTED_FEATURES \
> +#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
> +#define C5000X_PL_BLK_DEVICE_ID		0x1001
> +#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
> +#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
> +
> +#define IFCVF_NET_SUPPORTED_FEATURES \
>   		((1ULL << VIRTIO_NET_F_MAC)			| \
>   		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
>   		 (1ULL << VIRTIO_F_VERSION_1)			| \
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 469a9b5737b7..376b2014916a 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -168,10 +168,23 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
>   
>   static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
>   {
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +
>   	u64 features;
>   
> -	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
> +	switch (vf->dev_type) {
> +	case VIRTIO_ID_NET:
> +		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
> +		break;
> +	case VIRTIO_ID_BLOCK:
> +		features = ifcvf_get_features(vf);
> +		break;
> +	default:
> +		features = 0;
> +		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
> +	}
>   
>   	return features;
>   }
> @@ -517,6 +530,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>   			 C5000X_PL_DEVICE_ID,
>   			 C5000X_PL_SUBSYS_VENDOR_ID,
>   			 C5000X_PL_SUBSYS_DEVICE_ID) },
> +	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
> +			 C5000X_PL_BLK_DEVICE_ID,
> +			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
> +			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>   
>   	{ 0 },
>   };

