Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D785110B5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 07:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357878AbiD0F76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 01:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiD0F75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 01:59:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3DE92B1A8
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 22:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651039005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9qeULQ41fQcQFOy0CY9Heuj/JvDE2+huvj1l00MURAI=;
        b=hHqGFtTSHxBCJWqB7umqmZXlKNkLA8XmKEblGgaQellpB+Bk0n6oq4MsOry9RLExu6qqUC
        dfmYc/X6k5DlFjnBEPXo6wFIoKc4k7TZup2M7VHe+xebsMdGiBVP5Roh6/0nhUhljOmHOJ
        lHaiN1ZsAt4CXGNFpatmi9f7hyVLK1I=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-Os6V5G-eOE-me_OqgxyPJA-1; Wed, 27 Apr 2022 01:56:42 -0400
X-MC-Unique: Os6V5G-eOE-me_OqgxyPJA-1
Received: by mail-pg1-f199.google.com with SMTP id z18-20020a631912000000b003a392265b64so449034pgl.2
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 22:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9qeULQ41fQcQFOy0CY9Heuj/JvDE2+huvj1l00MURAI=;
        b=x4ER9JDlc3IcXoByd3xf+pQycPFh54j28EP46gmDogJ1z2hYrjguiQ2J4eACzB1WLk
         9EDsIktizTYgvukSqpP7J8GYi2WjauTpj6orpqTCedX78MWvIoIPwvZsa70HFKE+tw1g
         iPZu6HSgipZD7YCY4fDuHXKiHhDdQEJN++Hsx9AunHjMKysBZqKyYJfz+3OGfZaO2LKN
         HLOhctYOTCc0P4ZIdhr+bo2va5W03Ov5KSNZCQJyKKQbb9msmBJ2XlhPAuQoZ4F6JHuD
         WmsaB05bHtu+AhSb47tIfe2qnj3sEnDnY+6Myw+DbGJarYzpVQjxoA8Q0n8AgP8iyvGV
         TXBQ==
X-Gm-Message-State: AOAM532jmJj3srWdsQlJkavVBhS5oERSWfDCWvLRkFYvh+MmPMnEtdCT
        iXwLTd2CoA2Fln8VdxPEQKwkGyJ0FGuFrZGTKQb/RkcZhjywToI/gY584OhT9X5SGm4oN5XvLR7
        ssk7UFERdMz4f3jSd
X-Received: by 2002:a62:b60f:0:b0:508:2a61:2c8b with SMTP id j15-20020a62b60f000000b005082a612c8bmr28370673pff.2.1651039001281;
        Tue, 26 Apr 2022 22:56:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiiea0IwzZ22wAsh+sUDv5wKE8S6Fn4TlE5ivWn54gAuceV6BckQLQRjvue0imRQT6365j+g==
X-Received: by 2002:a62:b60f:0:b0:508:2a61:2c8b with SMTP id j15-20020a62b60f000000b005082a612c8bmr28370650pff.2.1651039000929;
        Tue, 26 Apr 2022 22:56:40 -0700 (PDT)
Received: from [10.72.12.60] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16-20020a621410000000b0050aca5f79f5sm17592732pfu.97.2022.04.26.22.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 22:56:40 -0700 (PDT)
Message-ID: <d36fbb4e-c848-3a06-6a81-8cd1b219a6d4@redhat.com>
Date:   Wed, 27 Apr 2022 13:56:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH V2] vDPA/ifcvf: allow userspace to suspend a queue
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220424113321.7176-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220424113321.7176-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/24 19:33, Zhu Lingshan 写道:
> Formerly, ifcvf driver has implemented a lazy-initialization mechanism
> for the virtqueues, it would store all virtqueue config fields that
> passed down from the userspace, then load them to the virtqueues and
> enable the queues upon DRIVER_OK.
>
> To allow the userspace to suspend a virtqueue,
> this commit passes queue_enable to the virtqueue directly through
> set_vq_ready().
>
> This feature requires and this commits implementing all virtqueue
> ops(set_vq_addr, set_vq_num and set_vq_ready) to take immediate
> actions than lazy-initialization, so ifcvf_hw_enable() is retired.
>
> set_features() should take immediate actions as well.
>
> ifcvf_add_status() is retierd because we should not add
> status like FEATURES_OK by ifcvf's decision, this driver should
> only set device status upon vdpa_ops.set_status()
>
> To avoid losing virtqueue configurations caused by multiple
> rounds of reset(), this commit also refactors thed evice reset
> routine, now it simply reset the config handler and the virtqueues,
> and only once device-reset().


It looks like the patch tries to do too many things at one run. I'd 
suggest to split them:


1) on-the-fly set via set_vq_ready(), but I don't see a reason why we 
need to change other lazy stuffs, since setting queue_enable to 1 before 
DRIVER_OK won't start the virtqueue anyhow
2) if necessary, converting the lazy stuffs
3) the synchornize_irq() fixes
4) other stuffs

Thanks


>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 150 +++++++++++++++++++-------------
>   drivers/vdpa/ifcvf/ifcvf_base.h |  16 ++--
>   drivers/vdpa/ifcvf/ifcvf_main.c |  81 +++--------------
>   3 files changed, 111 insertions(+), 136 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 48c4dadb0c7c..bbc9007a6f34 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -179,20 +179,7 @@ void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
>   
>   void ifcvf_reset(struct ifcvf_hw *hw)
>   {
> -	hw->config_cb.callback = NULL;
> -	hw->config_cb.private = NULL;
> -
>   	ifcvf_set_status(hw, 0);
> -	/* flush set_status, make sure VF is stopped, reset */
> -	ifcvf_get_status(hw);
> -}
> -
> -static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
> -{
> -	if (status != 0)
> -		status |= ifcvf_get_status(hw);
> -
> -	ifcvf_set_status(hw, status);
>   	ifcvf_get_status(hw);
>   }
>   
> @@ -213,7 +200,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw)
>   	return features;
>   }
>   
> -u64 ifcvf_get_features(struct ifcvf_hw *hw)
> +u64 ifcvf_get_device_features(struct ifcvf_hw *hw)
>   {
>   	return hw->hw_features;
>   }
> @@ -280,7 +267,7 @@ void ifcvf_write_dev_config(struct ifcvf_hw *hw, u64 offset,
>   		vp_iowrite8(*p++, hw->dev_cfg + offset + i);
>   }
>   
> -static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
> +void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
>   {
>   	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>   
> @@ -289,22 +276,22 @@ static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
>   
>   	vp_iowrite32(1, &cfg->guest_feature_select);
>   	vp_iowrite32(features >> 32, &cfg->guest_feature);
> +
> +	vp_ioread32(&cfg->guest_feature);
>   }
>   
> -static int ifcvf_config_features(struct ifcvf_hw *hw)
> +u64 ifcvf_get_features(struct ifcvf_hw *hw)
>   {
> -	struct ifcvf_adapter *ifcvf;
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +	u64 features;
>   
> -	ifcvf = vf_to_adapter(hw);
> -	ifcvf_set_features(hw, hw->req_features);
> -	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
> +	vp_iowrite32(0, &cfg->device_feature_select);
> +	features = vp_ioread32(&cfg->device_feature);
>   
> -	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
> -		IFCVF_ERR(ifcvf->pdev, "Failed to set FEATURES_OK status\n");
> -		return -EIO;
> -	}
> +	vp_iowrite32(1, &cfg->device_feature_select);
> +	features |= ((u64)vp_ioread32(&cfg->guest_feature) << 32);
>   
> -	return 0;
> +	return features;
>   }
>   
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
> @@ -331,68 +318,111 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>   	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
>   	q_pair_id = qid / hw->nr_vring;
>   	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
> -	hw->vring[qid].last_avail_idx = num;
>   	vp_iowrite16(num, avail_idx_addr);
>   
>   	return 0;
>   }
>   
> -static int ifcvf_hw_enable(struct ifcvf_hw *hw)
> +void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num)
>   {
> -	struct virtio_pci_common_cfg __iomem *cfg;
> -	u32 i;
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>   
> -	cfg = hw->common_cfg;
> -	for (i = 0; i < hw->nr_vring; i++) {
> -		if (!hw->vring[i].ready)
> -			break;
> +	vp_iowrite16(qid, &cfg->queue_select);
> +	vp_iowrite16(num, &cfg->queue_size);
> +}
>   
> -		vp_iowrite16(i, &cfg->queue_select);
> -		vp_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
> -				     &cfg->queue_desc_hi);
> -		vp_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
> -				      &cfg->queue_avail_hi);
> -		vp_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
> -				     &cfg->queue_used_hi);
> -		vp_iowrite16(hw->vring[i].size, &cfg->queue_size);
> -		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
> -		vp_iowrite16(1, &cfg->queue_enable);
> -	}
> +int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
> +			 u64 driver_area, u64 device_area)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +
> +	vp_iowrite16(qid, &cfg->queue_select);
> +	vp_iowrite64_twopart(desc_area, &cfg->queue_desc_lo,
> +			     &cfg->queue_desc_hi);
> +	vp_iowrite64_twopart(driver_area, &cfg->queue_avail_lo,
> +			     &cfg->queue_avail_hi);
> +	vp_iowrite64_twopart(device_area, &cfg->queue_used_lo,
> +			     &cfg->queue_used_hi);
>   
>   	return 0;
>   }
>   
> -static void ifcvf_hw_disable(struct ifcvf_hw *hw)
> +void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready)
>   {
> -	u32 i;
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +
> +	vp_iowrite16(qid, &cfg->queue_select);
> +	/* write 0 to queue_enable will suspend a queue*/
> +	vp_iowrite16(ready, &cfg->queue_enable);
> +}
> +
> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +	bool queue_enable;
> +
> +	vp_iowrite16(qid, &cfg->queue_select);
> +	queue_enable = vp_ioread16(&cfg->queue_enable);
> +
> +	return (bool)queue_enable;
> +}
> +
> +static void synchronize_per_vq_irq(struct ifcvf_hw *hw)
> +{
> +	int i;
>   
> -	ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
>   	for (i = 0; i < hw->nr_vring; i++) {
> -		ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
> +		if (hw->vring[i].irq != -EINVAL)
> +			synchronize_irq(hw->vring[i].irq);
>   	}
>   }
>   
> -int ifcvf_start_hw(struct ifcvf_hw *hw)
> +static void synchronize_vqs_reused_irq(struct ifcvf_hw *hw)
>   {
> -	ifcvf_reset(hw);
> -	ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> -	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
> +	if (hw->vqs_reused_irq != -EINVAL)
> +		synchronize_irq(hw->vqs_reused_irq);
> +}
>   
> -	if (ifcvf_config_features(hw) < 0)
> -		return -EINVAL;
> +static void synchronize_vq_irq(struct ifcvf_hw *hw)
> +{
> +	u8 status = hw->msix_vector_status;
>   
> -	if (ifcvf_hw_enable(hw) < 0)
> -		return -EINVAL;
> +	if (status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
> +		synchronize_per_vq_irq(hw);
> +	else
> +		synchronize_vqs_reused_irq(hw);
> +}
>   
> -	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
> +static void synchronize_config_irq(struct ifcvf_hw *hw)
> +{
> +	if (hw->config_irq != -EINVAL)
> +		synchronize_irq(hw->config_irq);
> +}
>   
> -	return 0;
> +static void ifcvf_reset_vring(struct ifcvf_hw *hw)
> +{
> +	int i;
> +
> +	for (i = 0; i < hw->nr_vring; i++) {
> +		synchronize_vq_irq(hw);
> +		hw->vring[i].cb.callback = NULL;
> +		hw->vring[i].cb.private = NULL;
> +		ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
> +	}
> +}
> +
> +static void ifcvf_reset_config_handler(struct ifcvf_hw *hw)
> +{
> +	synchronize_config_irq(hw);
> +	hw->config_cb.callback = NULL;
> +	hw->config_cb.private = NULL;
> +	ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
>   }
>   
>   void ifcvf_stop_hw(struct ifcvf_hw *hw)
>   {
> -	ifcvf_hw_disable(hw);
> -	ifcvf_reset(hw);
> +	ifcvf_reset_vring(hw);
> +	ifcvf_reset_config_handler(hw);
>   }
>   
>   void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 115b61f4924b..f3dce0d795cb 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -49,12 +49,6 @@
>   #define MSIX_VECTOR_DEV_SHARED			3
>   
>   struct vring_info {
> -	u64 desc;
> -	u64 avail;
> -	u64 used;
> -	u16 size;
> -	u16 last_avail_idx;
> -	bool ready;
>   	void __iomem *notify_addr;
>   	phys_addr_t notify_pa;
>   	u32 irq;
> @@ -76,7 +70,6 @@ struct ifcvf_hw {
>   	phys_addr_t notify_base_pa;
>   	u32 notify_off_multiplier;
>   	u32 dev_type;
> -	u64 req_features;
>   	u64 hw_features;
>   	struct virtio_pci_common_cfg __iomem *common_cfg;
>   	void __iomem *dev_cfg;
> @@ -123,7 +116,7 @@ u8 ifcvf_get_status(struct ifcvf_hw *hw);
>   void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
>   void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
>   void ifcvf_reset(struct ifcvf_hw *hw);
> -u64 ifcvf_get_features(struct ifcvf_hw *hw);
> +u64 ifcvf_get_device_features(struct ifcvf_hw *hw);
>   u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>   int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
> @@ -131,6 +124,13 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>   int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
> +int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
> +			 u64 driver_area, u64 device_area);
>   u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
>   u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
> +void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num);
> +void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready);
> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid);
> +void ifcvf_set_features(struct ifcvf_hw *hw, u64 features);
> +u64 ifcvf_get_features(struct ifcvf_hw *hw);
>   #endif /* _IFCVF_H_ */
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4366320fb68d..0257ba98cffe 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -358,53 +358,6 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   	return 0;
>   }
>   
> -static int ifcvf_start_datapath(void *private)
> -{
> -	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
> -	u8 status;
> -	int ret;
> -
> -	ret = ifcvf_start_hw(vf);
> -	if (ret < 0) {
> -		status = ifcvf_get_status(vf);
> -		status |= VIRTIO_CONFIG_S_FAILED;
> -		ifcvf_set_status(vf, status);
> -	}
> -
> -	return ret;
> -}
> -
> -static int ifcvf_stop_datapath(void *private)
> -{
> -	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
> -	int i;
> -
> -	for (i = 0; i < vf->nr_vring; i++)
> -		vf->vring[i].cb.callback = NULL;
> -
> -	ifcvf_stop_hw(vf);
> -
> -	return 0;
> -}
> -
> -static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
> -{
> -	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
> -	int i;
> -
> -	for (i = 0; i < vf->nr_vring; i++) {
> -		vf->vring[i].last_avail_idx = 0;
> -		vf->vring[i].desc = 0;
> -		vf->vring[i].avail = 0;
> -		vf->vring[i].used = 0;
> -		vf->vring[i].ready = 0;
> -		vf->vring[i].cb.callback = NULL;
> -		vf->vring[i].cb.private = NULL;
> -	}
> -
> -	ifcvf_reset(vf);
> -}
> -
>   static struct ifcvf_adapter *vdpa_to_adapter(struct vdpa_device *vdpa_dev)
>   {
>   	return container_of(vdpa_dev, struct ifcvf_adapter, vdpa);
> @@ -426,7 +379,7 @@ static u64 ifcvf_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
>   	u64 features;
>   
>   	if (type == VIRTIO_ID_NET || type == VIRTIO_ID_BLOCK)
> -		features = ifcvf_get_features(vf);
> +		features = ifcvf_get_device_features(vf);
>   	else {
>   		features = 0;
>   		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
> @@ -444,7 +397,7 @@ static int ifcvf_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 feat
>   	if (ret)
>   		return ret;
>   
> -	vf->req_features = features;
> +	ifcvf_set_features(vf, features);
>   
>   	return 0;
>   }
> @@ -453,7 +406,7 @@ static u64 ifcvf_vdpa_get_driver_features(struct vdpa_device *vdpa_dev)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	return vf->req_features;
> +	return ifcvf_get_features(vf);
>   }
>   
>   static u8 ifcvf_vdpa_get_status(struct vdpa_device *vdpa_dev)
> @@ -486,11 +439,6 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>   			ifcvf_set_status(vf, status);
>   			return;
>   		}
> -
> -		if (ifcvf_start_datapath(adapter) < 0)
> -			IFCVF_ERR(adapter->pdev,
> -				  "Failed to set ifcvf vdpa  status %u\n",
> -				  status);
>   	}
>   
>   	ifcvf_set_status(vf, status);
> @@ -509,12 +457,10 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
>   	if (status_old == 0)
>   		return 0;
>   
> -	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
> -		ifcvf_stop_datapath(adapter);
> -		ifcvf_free_irq(adapter);
> -	}
> +	ifcvf_stop_hw(vf);
> +	ifcvf_free_irq(adapter);
>   
> -	ifcvf_reset_vring(adapter);
> +	ifcvf_reset(vf);
>   
>   	return 0;
>   }
> @@ -554,14 +500,17 @@ static void ifcvf_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev,
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	vf->vring[qid].ready = ready;
> +	ifcvf_set_vq_ready(vf, qid, ready);
>   }
>   
>   static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	bool ready;
> +
> +	ready = ifcvf_get_vq_ready(vf, qid);
>   
> -	return vf->vring[qid].ready;
> +	return ready;
>   }
>   
>   static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
> @@ -569,7 +518,7 @@ static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	vf->vring[qid].size = num;
> +	ifcvf_set_vq_num(vf, qid, num);
>   }
>   
>   static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
> @@ -578,11 +527,7 @@ static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	vf->vring[qid].desc = desc_area;
> -	vf->vring[qid].avail = driver_area;
> -	vf->vring[qid].used = device_area;
> -
> -	return 0;
> +	return ifcvf_set_vq_address(vf, qid, desc_area, driver_area, device_area);
>   }
>   
>   static void ifcvf_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)

