Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B794A3BB691
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 07:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhGEFHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 01:07:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhGEFHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 01:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625461462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDMmAEK+dhpeMI8ETaJVArjrnaSTT4gcPjmGTBH0vjo=;
        b=UXf0mJBJH9UFzJiJN14sQrgTkjKQI0URhN4Wo0AqflbtPhFZ0lbJs0R4RTO/9EVmgZn+8x
        RloCFoA30Fj2SOFiNavKyQOYaGZBtcSwlmrmKW6LVX8zrXSlBXgZNXsqp5mZD2B9Wb13qC
        T2tdGrH/74CmlKbU3gcBGwUxVlUoN/g=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-zBw49C6gMGySH3TtX0emvQ-1; Mon, 05 Jul 2021 01:04:21 -0400
X-MC-Unique: zBw49C6gMGySH3TtX0emvQ-1
Received: by mail-pj1-f72.google.com with SMTP id x2-20020a17090ab002b029016e8b858193so9124930pjq.3
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 22:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CDMmAEK+dhpeMI8ETaJVArjrnaSTT4gcPjmGTBH0vjo=;
        b=sEcPMKYk7cv+46B7OV7fjUzrRml//m/3PoFcylbImriIilaTitV8u3/rW7IYKCSzLD
         /hXZxF4bvaBndMh6tcjSSM3+M/WrwHgjNlETSwlfiOCX3sTpspQhk45O1un64H0mmuMv
         CYdJB/+hMMTIOISeZ33A0DveM9g7zK9ONwHR0z5ekoZUUmcMAbFUqTNIBMXQiteUT+aL
         kOrF/gajPfDK3QjfnnNzzykcsXn7fMTqbab1RYa1DFNoNm3dcOFBE3Gz/Pj2G7FjiR8M
         aYzCKxwNA69Qxt9Yo1N16TM3mzV2ZrmnAvVCiUuTTfxdQDKr4CbyBuhrSeYu5mZ74/dv
         iolw==
X-Gm-Message-State: AOAM531BcuRlt++F/sXHT9ewcuq/C4kWJs/aWLb01KcNCfjhxUP2Nswu
        ppLyg8eHc2LGJcafABZ9VoE/nGkVprx8zCXC5pKeY3ay7BAD5knla1CQQTN434Wd43DDD9t0WB2
        RoDWr2Mlem+99R9r1
X-Received: by 2002:a17:902:f784:b029:ef:8e2f:430e with SMTP id q4-20020a170902f784b02900ef8e2f430emr11114440pln.28.1625461460342;
        Sun, 04 Jul 2021 22:04:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8V/lTNcXrByvwpOEoWgzbOd4v9xn8O/vXDHb/0Gp3pEzjnM+iXbmKBKvZ/cgl1NOIJw2Imw==
X-Received: by 2002:a17:902:f784:b029:ef:8e2f:430e with SMTP id q4-20020a170902f784b02900ef8e2f430emr11114389pln.28.1625461459558;
        Sun, 04 Jul 2021 22:04:19 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm6159983pjl.15.2021.07.04.22.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 22:04:19 -0700 (PDT)
Subject: Re: [PATCH 2/3] vDPA/ifcvf: implement management netlink framework
 for ifcvf
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
 <20210630082145.5729-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1ebb3dc8-5416-f718-2837-8371e78dd3d0@redhat.com>
Date:   Mon, 5 Jul 2021 13:04:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630082145.5729-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/30 ÏÂÎç4:21, Zhu Lingshan Ð´µÀ:
> This commit implments the management netlink framework for ifcvf,
> including register and add / remove a device
>
> It works with iprouter2:
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
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |   6 ++
>   drivers/vdpa/ifcvf/ifcvf_main.c | 156 ++++++++++++++++++++++++--------
>   2 files changed, 126 insertions(+), 36 deletions(-)
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
> index 5f70ab1283a0..7c2f64ca2163 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
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
> @@ -515,7 +507,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	ret = ifcvf_init_hw(vf, pdev);
>   	if (ret) {
>   		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
> -		goto err;
> +		return ret;
>   	}
>   
>   	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
> @@ -523,9 +515,94 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	vf->hw_features = ifcvf_get_hw_features(vf);
>   
> -	ret = vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
> +	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
> +	ret = _vdpa_register_device(&adapter->vdpa, IFCVF_MAX_QUEUE_PAIRS * 2);
>   	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");
> +		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
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
> +	struct ifcvf_adapter *adapter;


adapter is not used.


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
>   		goto err;
>   	}
>   
> @@ -533,14 +610,21 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   err:
>   	put_device(&adapter->vdpa.dev);
> +	kfree(ifcvf_mgmt_dev);
>   	return ret;
>   }
>   
>   static void ifcvf_remove(struct pci_dev *pdev)
>   {
> -	struct ifcvf_adapter *adapter = pci_get_drvdata(pdev);
> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
> +	struct ifcvf_adapter *adapter;
> +
> +	ifcvf_mgmt_dev = pci_get_drvdata(pdev);
> +	adapter = ifcvf_mgmt_dev->adapter;
> +	if (adapter)
> +		vdpa_unregister_device(&adapter->vdpa);
>   
> -	vdpa_unregister_device(&adapter->vdpa);
> +	kfree(ifcvf_mgmt_dev);
>   }


Let's use vdpa_mgmtdev_register() to be more safe.

Thanks


>   
>   static struct pci_device_id ifcvf_pci_ids[] = {

