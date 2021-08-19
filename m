Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE53F1235
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 06:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhHSEKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 00:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229575AbhHSEKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 00:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629346175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=845M9dCu0BBwxxguLiM0h6US9TVl5Oo1nvahLbWOs4I=;
        b=AaRMURkrSydV/aJck6iZvyuGawHcmo3QpExpD8wr/fsw+L/AXKvX7Ei1ZptlHsPVxfNW88
        0mDpx7c+jhKkT++TpG9k11LlRuVMuaYbOwB91mihH6+dtbtUA13xjCdKCqM903mlNv0cEW
        ilwd++2shW+36sDhBBfZCoCGST48OOA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-WBt8SA6dNma6pTQpm14_9w-1; Thu, 19 Aug 2021 00:09:28 -0400
X-MC-Unique: WBt8SA6dNma6pTQpm14_9w-1
Received: by mail-pg1-f200.google.com with SMTP id d1-20020a630e010000b029023afa459291so2738730pgl.11
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 21:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=845M9dCu0BBwxxguLiM0h6US9TVl5Oo1nvahLbWOs4I=;
        b=UIz+YeITXDM5BWE8mO3l63LGTPMoIg5yL6FG6xuO/c6XHM+Dft2RKjc3o+Ys4UzmWu
         WzXTSbLkFstnO73YzPfYz7NLNqK6WDJeJIJf875bG9WK1V/iMhK+ArzdzhLNvqRG/enw
         c3kV9Pr+u/xoLU8b4m3HqzNOMyWkZuCmVUChguIDaOCvvs9Jg2YTAYw0GI7Nf2g/FONU
         vLHNLiEeSCtWXNuYEbMQvk2sBys0PFCaKZYVe8nUR9A6tnUsKLfwnSUQZx4m4N1m3deX
         S9AXvGdS9dzf6JGPxeZ5wEGm8t6oN5Tk8y73yhlzXDpJVTIzXyhx7yvQkBuaHIt3Sq0v
         VNbA==
X-Gm-Message-State: AOAM5329LlZPMVgjZmIOHI9KI53PZ3z/dJjt7fljnrzjCcjHoRE9J77E
        aTuhP0gQOVwttTqak/LuIlDkjGg7K5lmhTVLDBg9+eFO1dHoUKjLwRvhqHT4/8JyjBFqT+D1rlu
        PvMtjvXqqPoKhxH8K
X-Received: by 2002:a65:51c7:: with SMTP id i7mr11985380pgq.300.1629346167446;
        Wed, 18 Aug 2021 21:09:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdDjel8iMgCuyVB7vKLugcmk5D1NVeufi9kRNTtKpFwx5blvUXV+sVKfFzR0MS5E4wBrhB6A==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr11985360pgq.300.1629346167179;
        Wed, 18 Aug 2021 21:09:27 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p34sm1355587pfh.172.2021.08.18.21.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 21:09:26 -0700 (PDT)
Subject: Re: [PATCH 1/2] vDPA/ifcvf: detect and use the onboard number of
 queues directly
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
 <20210818095714.3220-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <78c25559-0423-7ef6-9cdd-d2b81df111ca@redhat.com>
Date:   Thu, 19 Aug 2021 12:09:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818095714.3220-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/8/18 ÏÂÎç5:57, Zhu Lingshan Ð´µÀ:
> To enable this multi-queue feature for ifcvf, this commit
> intends to detect and use the onboard number of queues
> directly than IFCVF_MAX_QUEUE_PAIRS = 1 (removed)
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 10 ++++------
>   drivers/vdpa/ifcvf/ifcvf_main.c | 21 ++++++++++++---------
>   3 files changed, 21 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 6e197fe0fcf9..2808f1ba9f7b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -158,7 +158,9 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>   		return -EIO;
>   	}
>   
> -	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +	hw->nr_vring = ifc_ioread16(&hw->common_cfg->num_queues);
> +
> +	for (i = 0; i < hw->nr_vring; i++) {
>   		ifc_iowrite16(i, &hw->common_cfg->queue_select);
>   		notify_off = ifc_ioread16(&hw->common_cfg->queue_notify_off);
>   		hw->vring[i].notify_addr = hw->notify_base +
> @@ -304,7 +306,7 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
>   	u32 q_pair_id;
>   
>   	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
> -	q_pair_id = qid / (IFCVF_MAX_QUEUE_PAIRS * 2);
> +	q_pair_id = qid / hw->nr_vring;
>   	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
>   	last_avail_idx = ifc_ioread16(avail_idx_addr);
>   
> @@ -318,7 +320,7 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>   	u32 q_pair_id;
>   
>   	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
> -	q_pair_id = qid / (IFCVF_MAX_QUEUE_PAIRS * 2);
> +	q_pair_id = qid / hw->nr_vring;
>   	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
>   	hw->vring[qid].last_avail_idx = num;
>   	ifc_iowrite16(num, avail_idx_addr);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 1601e87870da..97d9019a3ec0 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -31,8 +31,8 @@
>   		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
>   		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
>   
> -/* Only one queue pair for now. */
> -#define IFCVF_MAX_QUEUE_PAIRS	1
> +/* Max 8 data queue pairs(16 queues) and one control vq for now. */
> +#define IFCVF_MAX_QUEUES	17


While at it, I wonder if we can get rid of this.

Other than this,

Acked-by: Jason Wang <jasowang@redhat.com>


>   
>   #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
>   #define IFCVF_QUEUE_MAX		32768
> @@ -51,8 +51,6 @@
>   #define ifcvf_private_to_vf(adapter) \
>   	(&((struct ifcvf_adapter *)adapter)->vf)
>   
> -#define IFCVF_MAX_INTR (IFCVF_MAX_QUEUE_PAIRS * 2 + 1)
> -
>   struct vring_info {
>   	u64 desc;
>   	u64 avail;
> @@ -83,7 +81,7 @@ struct ifcvf_hw {
>   	u32 dev_type;
>   	struct virtio_pci_common_cfg __iomem *common_cfg;
>   	void __iomem *net_cfg;
> -	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
> +	struct vring_info vring[IFCVF_MAX_QUEUES];
>   	void __iomem * const *base;
>   	char config_msix_name[256];
>   	struct vdpa_callback config_cb;
> @@ -103,7 +101,7 @@ struct ifcvf_vring_lm_cfg {
>   
>   struct ifcvf_lm_cfg {
>   	u8 reserved[IFCVF_LM_RING_STATE_OFFSET];
> -	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUE_PAIRS];
> +	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUES];
>   };
>   
>   struct ifcvf_vdpa_mgmt_dev {
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4b623253f460..e34c2ec2b69b 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -63,9 +63,13 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   	struct pci_dev *pdev = adapter->pdev;
>   	struct ifcvf_hw *vf = &adapter->vf;
>   	int vector, i, ret, irq;
> +	u16 max_intr;
>   
> -	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> -				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> +	/* all queues and config interrupt  */
> +	max_intr = vf->nr_vring + 1;
> +
> +	ret = pci_alloc_irq_vectors(pdev, max_intr,
> +				    max_intr, PCI_IRQ_MSIX);
>   	if (ret < 0) {
>   		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
>   		return ret;
> @@ -83,7 +87,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   		return ret;
>   	}
>   
> -	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +	for (i = 0; i < vf->nr_vring; i++) {
>   		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
>   			 pci_name(pdev), i);
>   		vector = i + IFCVF_MSI_QUEUE_OFF;
> @@ -112,7 +116,6 @@ static int ifcvf_start_datapath(void *private)
>   	u8 status;
>   	int ret;
>   
> -	vf->nr_vring = IFCVF_MAX_QUEUE_PAIRS * 2;
>   	ret = ifcvf_start_hw(vf);
>   	if (ret < 0) {
>   		status = ifcvf_get_status(vf);
> @@ -128,7 +131,7 @@ static int ifcvf_stop_datapath(void *private)
>   	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
>   	int i;
>   
> -	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
> +	for (i = 0; i < vf->nr_vring; i++)
>   		vf->vring[i].cb.callback = NULL;
>   
>   	ifcvf_stop_hw(vf);
> @@ -141,7 +144,7 @@ static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
>   	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
>   	int i;
>   
> -	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +	for (i = 0; i < vf->nr_vring; i++) {
>   		vf->vring[i].last_avail_idx = 0;
>   		vf->vring[i].desc = 0;
>   		vf->vring[i].avail = 0;
> @@ -227,7 +230,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>   	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) &&
>   	    !(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
>   		ifcvf_stop_datapath(adapter);
> -		ifcvf_free_irq(adapter, IFCVF_MAX_QUEUE_PAIRS * 2);
> +		ifcvf_free_irq(adapter, vf->nr_vring);
>   	}
>   
>   	if (status == 0) {
> @@ -526,13 +529,13 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
>   		goto err;
>   	}
>   
> -	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
> +	for (i = 0; i < vf->nr_vring; i++)
>   		vf->vring[i].irq = -EINVAL;
>   
>   	vf->hw_features = ifcvf_get_hw_features(vf);
>   
>   	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
> -	ret = _vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
> +	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
>   	if (ret) {
>   		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
>   		goto err;

