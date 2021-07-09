Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996593C1D88
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhGICkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhGICkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625798249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+J9Lnw5DVtWJKPf6tEyqz5oiUm5AxvYYKjyiKxoR3zk=;
        b=iIWtC7f+Jv2y4AKNkWfN1pMCF+YqyDa/+WerFKnS4nJ7vVBagDB9vKPh9lQm0AiOChyZgu
        YY0gJ6kvolTTD9NKBZO1/mSyeI5rx3vG9xrdGL94X560wz9tIeCpEWMq/YKYhOG8LBj3o7
        uIBa4WG9on5Ox6uxnJk3vsiR8u8UxZ4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-XfhXxdcPNFGKkHKReQcmSw-1; Thu, 08 Jul 2021 22:37:25 -0400
X-MC-Unique: XfhXxdcPNFGKkHKReQcmSw-1
Received: by mail-pj1-f71.google.com with SMTP id ls11-20020a17090b350bb0290172c224979cso5499109pjb.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 19:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+J9Lnw5DVtWJKPf6tEyqz5oiUm5AxvYYKjyiKxoR3zk=;
        b=oVVrRi6/UmBos0Vze85HBf3mHVa9wDTjVFsB8hHGaKt2CUEPlX1H/CtnCkiL5q4DvQ
         g/Xj+k8Y84WRU7cVnZEGV8QOjQcseSkz4zmN7xYnpMJWAAbFO/ZwGKAOLzt2+LDOZL86
         LKgmJlSiOL4sCb3G8+E+DYYwbiie6+lPa3lxDNOHVuYDE1caaPW/N2WDs9sr6Voe9z6I
         7x12+Rt/rymw8NnMDTj9gPydUbONTL1XKQ3HoFoZIvlEidLkkuOJnziz+7cThloAPorH
         S+01Y7qc2eBVdl2QHtX3eWsCvMvcrXjyL6JIvzBTqCDg/4JdNoGTmFJbl51kIGj/6N6H
         3rlg==
X-Gm-Message-State: AOAM533AGPVJKVW7q6bD8Rs0guy5mfHIPAQ9Yht4xP8BABzuw61hZH9c
        +fQgCtz35lW4slFcyb9a5b06QXXfbB+eTF5yfnk7p/kE0CawKYpO9LH7iqpl0/XRAZdkkNvQSSC
        0anF7lyzyg406V2PI
X-Received: by 2002:a65:5b0f:: with SMTP id y15mr35436069pgq.263.1625798244830;
        Thu, 08 Jul 2021 19:37:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW1VzzGMbGReLBmXJmIGxaq1O7VrIc2ROGTJpNodFzrGiyhKCxtsCzrfwEi9MUAlff62XWmg==
X-Received: by 2002:a65:5b0f:: with SMTP id y15mr35436050pgq.263.1625798244629;
        Thu, 08 Jul 2021 19:37:24 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lb13sm10506564pjb.5.2021.07.08.19.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 19:37:24 -0700 (PDT)
Subject: Re: [PATCH V3 2/2] vDPA/ifcvf: implement management netlink framework
 for ifcvf
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210706023649.23360-1-lingshan.zhu@intel.com>
 <20210706023649.23360-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d965cd00-387e-3610-6c9c-50f99574438e@redhat.com>
Date:   Fri, 9 Jul 2021 10:37:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706023649.23360-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/6 ÉÏÎç10:36, Zhu Lingshan Ð´µÀ:
> This commit implements the management netlink framework for ifcvf,
> including register and add / remove a device
>
> It works with iproute2:
> [root@localhost lszhu]# vdpa mgmtdev show -jp
> {
>      "mgmtdev": {
>          "pci/0000:01:00.5": {
>              "supported_classes": [ "net" ]
>          },
>          "pci/0000:01:00.6": {
>              "supported_classes": [ "net" ]
>          }
>      }
> }
>
> [root@localhost lszhu]# vdpa dev add mgmtdev pci/0000:01:00.5 name vdpa0
> [root@localhost lszhu]# vdpa dev add mgmtdev pci/0000:01:00.6 name vdpa1
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |   6 ++
>   drivers/vdpa/ifcvf/ifcvf_main.c | 154 ++++++++++++++++++++++++--------
>   2 files changed, 124 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index ded1b1b5fb13..e5251fcbb200 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -104,6 +104,12 @@ struct ifcvf_lm_cfg {
>   	struct ifcvf_vring_lm_cfg vring_lm_cfg[IFCVF_MAX_QUEUE_PAIRS];
>   };
>   
> +struct ifcvf_vdpa_mgmt_dev {
> +	struct vdpa_mgmt_dev mdev;
> +	struct ifcvf_adapter *adapter;
> +	struct pci_dev *pdev;
> +};
> +
>   int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
>   int ifcvf_start_hw(struct ifcvf_hw *hw);
>   void ifcvf_stop_hw(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 5f70ab1283a0..c72d9b36e4a0 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -218,7 +218,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>   	int ret;
>   
>   	vf  = vdpa_to_vf(vdpa_dev);
> -	adapter = dev_get_drvdata(vdpa_dev->dev.parent);
> +	adapter = vdpa_to_adapter(vdpa_dev);
>   	status_old = ifcvf_get_status(vf);
>   
>   	if (status_old == status)
> @@ -442,6 +442,16 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
>   };
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
>   static u32 get_dev_type(struct pci_dev *pdev)
>   {
>   	u32 dev_type;
> @@ -462,48 +472,30 @@ static u32 get_dev_type(struct pci_dev *pdev)
>   	return dev_type;
>   }
>   
> -static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name)
>   {
> -	struct device *dev = &pdev->dev;
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>   	struct ifcvf_adapter *adapter;
> +	struct pci_dev *pdev;
>   	struct ifcvf_hw *vf;
> +	struct device *dev;
>   	int ret, i;
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
>   	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> -				    dev, &ifc_vdpa_ops, NULL);
> -	if (adapter == NULL) {
> +				    dev, &ifc_vdpa_ops, name);
> +	if (!adapter) {
>   		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>   		return -ENOMEM;
>   	}
>   
> -	pci_set_master(pdev);
> -	pci_set_drvdata(pdev, adapter);
> +	ifcvf_mgmt_dev->adapter = adapter;
> +	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
>   
>   	vf = &adapter->vf;
>   	vf->dev_type = get_dev_type(pdev);
> @@ -523,9 +515,10 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	vf->hw_features = ifcvf_get_hw_features(vf);
>   
> -	ret = vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
> +	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
> +	ret = _vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
>   	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");
> +		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
>   		goto err;
>   	}
>   
> @@ -536,11 +529,100 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	return ret;
>   }
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
>   static void ifcvf_remove(struct pci_dev *pdev)
>   {
> -	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>   
> -	vdpa_unregister_device(&adapter->vdpa);
> +	ifcvf_mgmt_dev = pci_get_drvdata(pdev);
> +	vdpa_mgmtdev_unregister(&ifcvf_mgmt_dev->mdev);
> +	kfree(ifcvf_mgmt_dev);
>   }
>   
>   static struct pci_device_id ifcvf_pci_ids[] = {

