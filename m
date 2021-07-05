Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50543BC2A6
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhGESdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 14:33:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhGESdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 14:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625509824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g99cAC1EqGLpuFXeNRpicbnlN6CA7H9jiKu7Hd/LXNo=;
        b=VX5c5WUkLxUwGlo7NL/Ai243D+va2c5v9aNUTFOrPDtqu588o7zjxA2iIPEDwBBB7mcLzY
        Ed27JGd4RBAanr4lolgcTZYDOy5pO+wFAVUtvB/ne1ga2MxAxjt0YjmyU2vURIgfkYO10A
        fOCur7K5YCX2UJHlvBSp/8HI2gH/dms=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-3AjkYf84Oc-uxwTVskMU8A-1; Mon, 05 Jul 2021 14:30:21 -0400
X-MC-Unique: 3AjkYf84Oc-uxwTVskMU8A-1
Received: by mail-ed1-f72.google.com with SMTP id y17-20020a0564023591b02903951740fab5so9515581edc.23
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 11:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g99cAC1EqGLpuFXeNRpicbnlN6CA7H9jiKu7Hd/LXNo=;
        b=pSA+RbsIC3hswH3G6R8/rsLXCwPRu3Lum/Ye99tGGC2dIZrSi+Olpa40dB+V1PJbtN
         1gYoTKw6sMXHb2EDXqWp3Dahx6cQuwgsddc75dcEQj+Rbn9w9joeGdH3b6nqxAxzBj4h
         yfugW1ZI6D8YWqQ/YlAF+6RZYFjOEzA3o9jmONFsVa0sybZZYfUyga86geV1J+n5ihXK
         8D3TWssFj3ILd9mtqr4UWJF8Fq4oddVVoz9sD7Ejan4oLLW0kerY2X2A42pz3Fw0iFQj
         ONyxgdyb31i02/vdj8YTMO0P7VAX2g+9pWIibwIPavLrE9LYXKtmi+AdZw8/TLq8m6hc
         Dmpw==
X-Gm-Message-State: AOAM531Evawt8ta0yVTHzXPtzX99jJ0qyW8zFJDeHCVuHYJhA1cVtChr
        ODXoO9Ik3olrloBt1e0oXmB+8WFJMCHpeeyuIf4hQLdN/PEIcDxqWFT88PM6daZywaFaowYE5qV
        WYD0yavxX6ZRyNNwJ
X-Received: by 2002:a17:906:6d97:: with SMTP id h23mr14409851ejt.467.1625509820373;
        Mon, 05 Jul 2021 11:30:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxrSChJF68iOfzGKJU54aJxhgYw63mD0CKZbvFzDlEKlYd3LAcQ1+5MlvRrHTR2dK4+EuJOw==
X-Received: by 2002:a17:906:6d97:: with SMTP id h23mr14409836ejt.467.1625509820146;
        Mon, 05 Jul 2021 11:30:20 -0700 (PDT)
Received: from redhat.com ([2.55.8.91])
        by smtp.gmail.com with ESMTPSA id p23sm5845689edt.71.2021.07.05.11.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:30:19 -0700 (PDT)
Date:   Mon, 5 Jul 2021 14:30:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V2 2/2] vDPA/ifcvf: implement management netlink
 framework for ifcvf
Message-ID: <20210705142750-mutt-send-email-mst@kernel.org>
References: <20210705141333.9262-1-lingshan.zhu@intel.com>
 <20210705141333.9262-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705141333.9262-3-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 10:13:33PM +0800, Zhu Lingshan wrote:
> This commit implments the management netlink framework for ifcvf,

implements

> including register and add / remove a device
> 
> It works with iprouter2:

I am guessing iproute2?

> [root@localhost lszhu]# vdpa mgmtdev show -jp
> {
>     "mgmtdev": {
>         "pci/0000:01:00.5": {
>             "supported_classes": [ "net" ]
>         },
>         "pci/0000:01:00.6": {
>             "supported_classes": [ "net" ]
>         }
>     }
> }
> 
> [root@localhost lszhu]# vdpa dev add mgmtdev pci/0000:01:00.5 name vdpa0
> [root@localhost lszhu]# vdpa dev add mgmtdev pci/0000:01:00.6 name vdpa1
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.h |   6 ++
>  drivers/vdpa/ifcvf/ifcvf_main.c | 154 ++++++++++++++++++++++++--------
>  2 files changed, 124 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index ded1b1b5fb13..e5251fcbb200 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -104,6 +104,12 @@ struct ifcvf_lm_cfg {
>  	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUE_PAIRS];
>  };
>  
> +struct ifcvf_vdpa_mgmt_dev {
> +	struct vdpa_mgmt_dev mdev;
> +	struct ifcvf_adapter *adapter;
> +	struct pci_dev *pdev;
> +};
> +
>  int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
>  int ifcvf_start_hw(struct ifcvf_hw *hw);
>  void ifcvf_stop_hw(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 5f70ab1283a0..c72d9b36e4a0 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -218,7 +218,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>  	int ret;
>  
>  	vf  = vdpa_to_vf(vdpa_dev);
> -	adapter = dev_get_drvdata(vdpa_dev->dev.parent);
> +	adapter = vdpa_to_adapter(vdpa_dev);
>  	status_old = ifcvf_get_status(vf);
>  
>  	if (status_old == status)
> @@ -442,6 +442,16 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>  	.set_config_cb  = ifcvf_vdpa_set_config_cb,
>  };
>  
> +static struct virtio_device_id id_table_net[] = {
> +	{VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
> +	{0},
> +};
> +
> +static struct virtio_device_id id_table_blk[] = {
> +	{VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID},
> +	{0},
> +};
> +
>  static u32 get_dev_type(struct pci_dev *pdev)
>  {
>  	u32 dev_type;
> @@ -462,48 +472,30 @@ static u32 get_dev_type(struct pci_dev *pdev)
>  	return dev_type;
>  }
>  
> -static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
>  {
> -	struct device *dev = &pdev->dev;
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>  	struct ifcvf_adapter *adapter;
> +	struct pci_dev *pdev;
>  	struct ifcvf_hw *vf;
> +	struct device *dev;
>  	int ret, i;
>  
> -	ret = pcim_enable_device(pdev);
> -	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to enable device\n");
> -		return ret;
> -	}
> -
> -	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
> -				 IFCVF_DRIVER_NAME);
> -	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
> -		return ret;
> -	}
> -
> -	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> -	if (ret) {
> -		IFCVF_ERR(pdev, "No usable DMA configuration\n");
> -		return ret;
> -	}
> -
> -	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
> -	if (ret) {
> -		IFCVF_ERR(pdev,
> -			  "Failed for adding devres for freeing irq vectors\n");
> -		return ret;
> -	}
> +	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
> +	if (ifcvf_mgmt_dev->adapter)
> +		return -EOPNOTSUPP;
>  
> +	pdev = ifcvf_mgmt_dev->pdev;
> +	dev = &pdev->dev;
>  	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> -				    dev, &ifc_vdpa_ops, NULL);
> -	if (adapter == NULL) {
> +				    dev, &ifc_vdpa_ops, name);
> +	if (!adapter) {
>  		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>  		return -ENOMEM;
>  	}
>  
> -	pci_set_master(pdev);
> -	pci_set_drvdata(pdev, adapter);
> +	ifcvf_mgmt_dev->adapter = adapter;
> +	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
>  
>  	vf = &adapter->vf;
>  	vf->dev_type = get_dev_type(pdev);
> @@ -523,9 +515,10 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	vf->hw_features = ifcvf_get_hw_features(vf);
>  
> -	ret = vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
> +	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
> +	ret = _vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
>  	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");
> +		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
>  		goto err;
>  	}
>  
> @@ -536,11 +529,100 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	return ret;
>  }
>  
> +static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
> +{
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
> +
> +	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
> +	_vdpa_unregister_device(dev);
> +	ifcvf_mgmt_dev->adapter = NULL;
> +}
> +
> +static const struct vdpa_mgmtdev_ops ifcvf_vdpa_mgmt_dev_ops = {
> +	.dev_add = ifcvf_vdpa_dev_add,
> +	.dev_del = ifcvf_vdpa_dev_del
> +};
> +
> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
> +	struct device *dev = &pdev->dev;
> +	u32 dev_type;
> +	int ret;
> +
> +	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
> +	if (!ifcvf_mgmt_dev) {
> +		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev_type = get_dev_type(pdev);
> +	switch (dev_type) {
> +	case VIRTIO_ID_NET:
> +		ifcvf_mgmt_dev->mdev.id_table = id_table_net;
> +		break;
> +	case VIRTIO_ID_BLOCK:
> +		ifcvf_mgmt_dev->mdev.id_table = id_table_blk;
> +		break;
> +	default:
> +		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", dev_type);
> +		ret = -EOPNOTSUPP;
> +		goto err;
> +	}
> +
> +	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
> +	ifcvf_mgmt_dev->mdev.device = dev;
> +	ifcvf_mgmt_dev->pdev = pdev;
> +
> +	ret = pcim_enable_device(pdev);
> +	if (ret) {
> +		IFCVF_ERR(pdev, "Failed to enable device\n");
> +		goto err;
> +	}
> +
> +	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
> +				 IFCVF_DRIVER_NAME);
> +	if (ret) {
> +		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
> +		goto err;
> +	}
> +
> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		IFCVF_ERR(pdev, "No usable DMA configuration\n");
> +		goto err;
> +	}
> +
> +	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
> +	if (ret) {
> +		IFCVF_ERR(pdev,
> +			  "Failed for adding devres for freeing irq vectors\n");
> +		goto err;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
> +	if (ret) {
> +		IFCVF_ERR(pdev,
> +			  "Failed to initialize the management interfaces\n");
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	kfree(ifcvf_mgmt_dev);
> +	return ret;
> +}
> +
>  static void ifcvf_remove(struct pci_dev *pdev)
>  {
> -	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>  
> -	vdpa_unregister_device(&adapter->vdpa);
> +	ifcvf_mgmt_dev = pci_get_drvdata(pdev);
> +	vdpa_mgmtdev_unregister(&ifcvf_mgmt_dev->mdev);
> +	kfree(ifcvf_mgmt_dev);
>  }
>  
>  static struct pci_device_id ifcvf_pci_ids[] = {
> -- 
> 2.27.0

