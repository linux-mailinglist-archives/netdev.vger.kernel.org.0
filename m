Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C8A33E82E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 05:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCQD6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 23:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhCQD5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615953471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9laViWHXxg7PRqj/pmoMOkbiM/RKp8I4VgNFTiTAsQ=;
        b=Jmx951VWyPhYcAidgz3rg302yURmY/iTQNAlRANJy6Exnv6cEPO8bDVz0ngR4qkzorjDpg
        CCNvAPwK5Wj/RK2pv19/1l3seVAAA8xkqiXdfr38q+xBKZa4/oSJGKErmrccREJDehSf+q
        Se+ZxrRqEGXKKhjf8PGEgAOiXvia9PE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-_DWUUqDrOBy6mp4INC2e9Q-1; Tue, 16 Mar 2021 23:57:49 -0400
X-MC-Unique: _DWUUqDrOBy6mp4INC2e9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22EAE363A1;
        Wed, 17 Mar 2021 03:57:48 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60E2560C13;
        Wed, 17 Mar 2021 03:57:41 +0000 (UTC)
Subject: Re: [PATCH V4 5/7] vDPA/ifcvf: fetch device feature bits when probe
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
 <20210315074501.15868-6-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9ab3f888-2201-54de-1390-6bc181316453@redhat.com>
Date:   Wed, 17 Mar 2021 11:57:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315074501.15868-6-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç3:44, Zhu Lingshan Ð´µÀ:
> This commit would read and store device feature
> bits when probe.
>
> rename ifcvf_get_features() to ifcvf_get_hw_features(),
> it reads and stores features of the probed device.
>
> new ifcvf_get_features() simply returns stored
> feature bits.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++--
>   drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
>   drivers/vdpa/ifcvf/ifcvf_main.c |  2 ++
>   3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index f2a128e56de5..ea6a78791c9b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -202,10 +202,11 @@ static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
>   	ifcvf_get_status(hw);
>   }
>   
> -u64 ifcvf_get_features(struct ifcvf_hw *hw)
> +u64 ifcvf_get_hw_features(struct ifcvf_hw *hw)
>   {
>   	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>   	u32 features_lo, features_hi;
> +	u64 features;
>   
>   	ifc_iowrite32(0, &cfg->device_feature_select);
>   	features_lo = ifc_ioread32(&cfg->device_feature);
> @@ -213,7 +214,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
>   	ifc_iowrite32(1, &cfg->device_feature_select);
>   	features_hi = ifc_ioread32(&cfg->device_feature);
>   
> -	return ((u64)features_hi << 32) | features_lo;
> +	features = ((u64)features_hi << 32) | features_lo;
> +
> +	return features;
> +}
> +
> +u64 ifcvf_get_features(struct ifcvf_hw *hw)
> +{
> +	return hw->hw_features;
>   }
>   
>   void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 794d1505d857..dbb8c10aa3b1 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -83,6 +83,7 @@ struct ifcvf_hw {
>   	void __iomem *notify_base;
>   	u32 notify_off_multiplier;
>   	u64 req_features;
> +	u64 hw_features;
>   	struct virtio_pci_common_cfg __iomem *common_cfg;
>   	void __iomem *net_cfg;
>   	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
> @@ -121,6 +122,7 @@ void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
>   void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
>   void ifcvf_reset(struct ifcvf_hw *hw);
>   u64 ifcvf_get_features(struct ifcvf_hw *hw);
> +u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index c34e1eec6b6c..25fb9dfe23f0 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -458,6 +458,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
>   		vf->vring[i].irq = -EINVAL;
>   
> +	vf->hw_features = ifcvf_get_hw_features(vf);
> +
>   	ret = vdpa_register_device(&adapter->vdpa);
>   	if (ret) {
>   		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");

