Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C487348D54A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiAMJzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 04:55:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233612AbiAMJzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:55:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642067701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rmo7egwCx0YlVKrKNiUmBis4BpB0kgjL7adUitRYllA=;
        b=JZgnj5l1ON6ZHuVa9tX3eGva70I7jkiEuKsZUEd6Buob8Kv0t0AmRPu/WVf/z1OpZTpKDN
        8W2uDgj29gL82wsJPUwEKEKRjQsDSozmgwS7r9eBbSbiXe2iKcNFDntvverx0J6i2A9Zca
        sVVl9Y9B1PwlR+wBaYGYI9hA9PxoGoI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-GIRU35xCNpyt_RsGKPdF6Q-1; Thu, 13 Jan 2022 04:55:00 -0500
X-MC-Unique: GIRU35xCNpyt_RsGKPdF6Q-1
Received: by mail-ed1-f69.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso4892458edb.7
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 01:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rmo7egwCx0YlVKrKNiUmBis4BpB0kgjL7adUitRYllA=;
        b=Ir7OwakjTv9uRo0k/ewLdr19quGdAOpixrmKMwvw3sbb/NeA2X4W5lKMHW5iWW91rl
         RYhFA02Yv5eM2/blh6y1ZW9ZSlN0CPfcEdE+fchyAIIkZ5UjFEv4Iokv6Qd00yEGiDJL
         7icP2h+YMjh3Nx+E8s8MSfdNh5kofsClKNbl0qjpSwKtjPCj5/5wyc8zQUOSmPlJqJ4F
         a6NVAiu2UdWqRHSHJsX+1jluc9MF8OAODitFA7nkF4MN8kaaK5OgML/RMEdWhE2Ya5yU
         7bV2QlZ91JdLljOgprcyHMpq+R7wpCQ5CBe1sNPsO4nsf5VBJ/7/6HfwDv5B+uJQHbZj
         BW3Q==
X-Gm-Message-State: AOAM531owkwNYfIhiOcimFYdKZbiktLIa0rDM54UeL/9yRzlw2g77tix
        hb02/oZuu8G7kWV+NuLHUQP19N/wYE9lwxAMQ3Jj5Zttq6NEWes2fr+iCBbq00rg1RvFVkn5/0/
        aeah9VcxwplGblXoF
X-Received: by 2002:a05:6402:2685:: with SMTP id w5mr3414369edd.151.1642067699496;
        Thu, 13 Jan 2022 01:54:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg6RI8IlrbR1c7E3u4h4goxHhOv9DQTD9YLdRIl6On31v2zFvCLwML3MX+pJXiydEnCVfs1g==
X-Received: by 2002:a05:6402:2685:: with SMTP id w5mr3414360edd.151.1642067699286;
        Thu, 13 Jan 2022 01:54:59 -0800 (PST)
Received: from redhat.com ([2.55.6.51])
        by smtp.gmail.com with ESMTPSA id h11sm943753edb.59.2022.01.13.01.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 01:54:58 -0800 (PST)
Date:   Thu, 13 Jan 2022 04:54:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] vDPA/ifcvf: improve irq requester, to handle
 per_vq/shared/config irq
Message-ID: <20220113045312-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-8-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-8-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:51PM +0800, Zhu Lingshan wrote:
> This commit expends irq requester abilities to handle per vq irq,
> shared irq and config irq.
> 
> On some platforms, the device can not get enough vectors for every
> virtqueue and config interrupt, the device needs to work under such
> circumstances.
> 
> Normally a device can get enough vectors, so every virtqueue and
> config interrupt can have its own vector/irq. If the total vector
> number is less than all virtqueues + 1(config interrupt), all
> virtqueues need to share a vector/irq and config interrupt is
> enabled. If the total vector number < 2, all vitequeues share
> a vector/irq, and config interrupt is disabled.

disabling config interrupt breaks link status updates and announcement
support. looks like link will never go up.

> Otherwise it will
> fail if allocation for vectors fails.
> 
> This commit also made necessary chages to the irq cleaner to
> free per vq irq/shared irq and config irq.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.h |  6 +--
>  drivers/vdpa/ifcvf/ifcvf_main.c | 78 +++++++++++++++------------------
>  2 files changed, 38 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 1d5431040d7d..1d0afb63f06c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -27,8 +27,6 @@
>  
>  #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
>  #define IFCVF_QUEUE_MAX		32768
> -#define IFCVF_MSI_CONFIG_OFF	0
> -#define IFCVF_MSI_QUEUE_OFF	1
>  #define IFCVF_PCI_MAX_RESOURCE	6
>  
>  #define IFCVF_LM_CFG_SIZE		0x40
> @@ -102,11 +100,13 @@ struct ifcvf_hw {
>  	u8 notify_bar;
>  	/* Notificaiton bar address */
>  	void __iomem *notify_base;
> +	u8 vector_per_vq;
> +	u16 padding;
>  	phys_addr_t notify_base_pa;
>  	u32 notify_off_multiplier;
> +	u32 dev_type;
>  	u64 req_features;
>  	u64 hw_features;
> -	u32 dev_type;
>  	struct virtio_pci_common_cfg __iomem *common_cfg;
>  	void __iomem *net_cfg;
>  	struct vring_info vring[IFCVF_MAX_QUEUES];
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 414b5dfd04ca..ec76e342bd7e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -17,6 +17,8 @@
>  #define DRIVER_AUTHOR   "Intel Corporation"
>  #define IFCVF_DRIVER_NAME       "ifcvf"
>  
> +static struct vdpa_config_ops ifc_vdpa_ops;
> +
>  static irqreturn_t ifcvf_config_changed(int irq, void *arg)
>  {
>  	struct ifcvf_hw *vf = arg;
> @@ -63,13 +65,20 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>  	struct ifcvf_hw *vf = &adapter->vf;
>  	int i;
>  
> +	if (vf->vector_per_vq)
> +		for (i = 0; i < queues; i++) {
> +			devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> +			vf->vring[i].irq = -EINVAL;
> +		}
> +	else
> +		devm_free_irq(&pdev->dev, vf->vring[0].irq, vf);
>  
> -	for (i = 0; i < queues; i++) {
> -		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> -		vf->vring[i].irq = -EINVAL;
> +
> +	if (vf->config_irq != -EINVAL) {
> +		devm_free_irq(&pdev->dev, vf->config_irq, vf);
> +		vf->config_irq = -EINVAL;
>  	}
>  
> -	devm_free_irq(&pdev->dev, vf->config_irq, vf);
>  	ifcvf_free_irq_vectors(pdev);
>  }
>  
> @@ -191,52 +200,35 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_ve
>  
>  static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>  {
> -	struct pci_dev *pdev = adapter->pdev;
>  	struct ifcvf_hw *vf = &adapter->vf;
> -	int vector, i, ret, irq;
> -	u16 max_intr;
> +	u16 nvectors, max_vectors;
> +	int config_vector, ret;
>  
> -	/* all queues and config interrupt  */
> -	max_intr = vf->nr_vring + 1;
> +	nvectors = ifcvf_alloc_vectors(adapter);
> +	if (nvectors < 0)
> +		return nvectors;
>  
> -	ret = pci_alloc_irq_vectors(pdev, max_intr,
> -				    max_intr, PCI_IRQ_MSIX);
> -	if (ret < 0) {
> -		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> -		return ret;
> -	}
> +	vf->vector_per_vq = true;
> +	max_vectors = vf->nr_vring + 1;
> +	config_vector = vf->nr_vring;
>  
> -	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
> -		 pci_name(pdev));
> -	vector = 0;
> -	vf->config_irq = pci_irq_vector(pdev, vector);
> -	ret = devm_request_irq(&pdev->dev, vf->config_irq,
> -			       ifcvf_config_changed, 0,
> -			       vf->config_msix_name, vf);
> -	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to request config irq\n");
> -		return ret;
> +	if (nvectors < max_vectors) {
> +		vf->vector_per_vq = false;
> +		config_vector = 1;
> +		ifc_vdpa_ops.get_vq_irq = NULL;
>  	}
>  
> -	for (i = 0; i < vf->nr_vring; i++) {
> -		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> -			 pci_name(pdev), i);
> -		vector = i + IFCVF_MSI_QUEUE_OFF;
> -		irq = pci_irq_vector(pdev, vector);
> -		ret = devm_request_irq(&pdev->dev, irq,
> -				       ifcvf_intr_handler, 0,
> -				       vf->vring[i].msix_name,
> -				       &vf->vring[i]);
> -		if (ret) {
> -			IFCVF_ERR(pdev,
> -				  "Failed to request irq for vq %d\n", i);
> -			ifcvf_free_irq(adapter, i);
> +	if (nvectors < 2)
> +		config_vector = 0;
>  
> -			return ret;
> -		}
> +	ret = ifcvf_request_vq_irq(adapter, vf->vector_per_vq);
> +	if (ret)
> +		return ret;
>  
> -		vf->vring[i].irq = irq;
> -	}
> +	ret = ifcvf_request_config_irq(adapter, config_vector);
> +
> +	if (ret)
> +		return ret;
>  
>  	return 0;
>  }
> @@ -573,7 +565,7 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
>   * IFCVF currently does't have on-chip IOMMU, so not
>   * implemented set_map()/dma_map()/dma_unmap()
>   */
> -static const struct vdpa_config_ops ifc_vdpa_ops = {
> +static struct vdpa_config_ops ifc_vdpa_ops = {
>  	.get_features	= ifcvf_vdpa_get_features,
>  	.set_features	= ifcvf_vdpa_set_features,
>  	.get_status	= ifcvf_vdpa_get_status,
> -- 
> 2.27.0

