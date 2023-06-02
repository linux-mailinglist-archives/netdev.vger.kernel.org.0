Return-Path: <netdev+bounces-7408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF534720133
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3ABD2818D0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB2418C27;
	Fri,  2 Jun 2023 12:11:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C13C18C1B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:11:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9178E1AD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685707905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jBqXisssxSy08laXqA4j2X5BRqq3rkPi2c6BRIFiiB0=;
	b=NfN/yfXupyyIUVbB+n8Pc1jyQ3Hu/3UXh/jnKTHPJY+g1PoxxaQnHzSaQk1hbRAQ2921e4
	qG4tEvnljDqHtQ0PQZRERKVguNRtixpcblUUkH9mC/EWi7dGjzEnr6i2QAETPF/igK8gRl
	oIkDvULjy4b3tulgVFsmyCjfb0th7M8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-vJCHPUZSMS6jOiChN016UQ-1; Fri, 02 Jun 2023 08:11:42 -0400
X-MC-Unique: vJCHPUZSMS6jOiChN016UQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4edc7406cbaso1481056e87.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 05:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685707901; x=1688299901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBqXisssxSy08laXqA4j2X5BRqq3rkPi2c6BRIFiiB0=;
        b=i8HXYcmBG1c8rWQ7UOZy9ORdaIPTwothybR19zlM0kGeI8DI/tBJia7OEkEM1C/q70
         iTJKZNPCBSnfUmxjYhPkrVxWGqkCXvUcLt1K9REPZBoQC9aQPH0jIwHVRdua8MLu3CHC
         TfIwLn9+e65uQQiQh5cdr6ND4okMwgXEiGCGSGv6IEDLf9lMFO5dELviaX/87vWbDoc0
         TB/uSvRmKG7ZIj8+hh0vvwbN04HWlx+ayWPyzHuCIK1bRl6i+z3lchnTJLloj+tHviji
         A4fXUyO6bpR1jHBwJ0obPsnKbaQ1tKgYl5uWYfWnwNra2C15urhwuFmyx5GQxvMHfseW
         OOiw==
X-Gm-Message-State: AC+VfDwjZ1wjWsgHomH6tAQPDmAI1S+vRMs5ML2rgqmKgC1rsruT0d8X
	V2gYQgoSl2MHmTnZei6/aVq+3TQCfKOZ4M5J+HgUGpkimDij0GfItlMCy1ULOrMwj+Z/SBJmD92
	jPnd4uhxvavTH5dpY
X-Received: by 2002:ac2:5d49:0:b0:4f3:b242:aa90 with SMTP id w9-20020ac25d49000000b004f3b242aa90mr1515717lfd.35.1685707901333;
        Fri, 02 Jun 2023 05:11:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6IVeiUNG0peGHBMQ2vc4eUrkOSQnaTk3Irclc1ESd8zyAftY8Hs9kbez88ioB4Hh+4W4z+RQ==
X-Received: by 2002:ac2:5d49:0:b0:4f3:b242:aa90 with SMTP id w9-20020ac25d49000000b004f3b242aa90mr1515704lfd.35.1685707900929;
        Fri, 02 Jun 2023 05:11:40 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id n2-20020a5d4c42000000b00306415ac69asm1519978wrt.15.2023.06.02.05.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 05:11:40 -0700 (PDT)
Date: Fri, 2 Jun 2023 08:11:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Nanyong Sun <sunnanyong@huawei.com>
Cc: joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
	jasowang@redhat.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <20230602081114-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207120843.1580403-1-sunnanyong@huawei.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> From: Rong Wang <wangrong68@huawei.com>
> 
> Once enable iommu domain for one device, the MSI
> translation tables have to be there for software-managed MSI.
> Otherwise, platform with software-managed MSI without an
> irq bypass function, can not get a correct memory write event
> from pcie, will not get irqs.
> The solution is to obtain the MSI phy base address from
> iommu reserved region, and set it to iommu MSI cookie,
> then translation tables will be created while request irq.


OK this one seems to be going nowhere I untagged it.

> Change log
> ----------
> 
> v1->v2:
> - add resv iotlb to avoid overlap mapping.
> 
> Signed-off-by: Rong Wang <wangrong68@huawei.com>
> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> ---
>  drivers/iommu/iommu.c |  1 +
>  drivers/vhost/vdpa.c  | 59 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 5f6a85aea501..af9c064ad8b2 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>  	if (ops->get_resv_regions)
>  		ops->get_resv_regions(dev, list);
>  }
> +EXPORT_SYMBOL(iommu_get_resv_regions);
>  
>  /**
>   * iommu_put_resv_regions - release resered regions
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f785dfde..a58979da8acd 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -49,6 +49,7 @@ struct vhost_vdpa {
>  	struct completion completion;
>  	struct vdpa_device *vdpa;
>  	struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
> +	struct vhost_iotlb resv_iotlb;
>  	struct device dev;
>  	struct cdev cdev;
>  	atomic_t opened;
> @@ -216,6 +217,8 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>  
>  	v->in_batch = 0;
>  
> +	vhost_iotlb_reset(&v->resv_iotlb);
> +
>  	return vdpa_reset(vdpa);
>  }
>  
> @@ -1013,6 +1016,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>  	    msg->iova + msg->size - 1 > v->range.last)
>  		return -EINVAL;
>  
> +	if (vhost_iotlb_itree_first(&v->resv_iotlb, msg->iova,
> +					msg->iova + msg->size - 1))
> +		return -EINVAL;
> +
>  	if (vhost_iotlb_itree_first(iotlb, msg->iova,
>  				    msg->iova + msg->size - 1))
>  		return -EEXIST;
> @@ -1103,6 +1110,45 @@ static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
>  	return vhost_chr_write_iter(dev, from);
>  }
>  
> +static int vhost_vdpa_resv_iommu_region(struct iommu_domain *domain, struct device *dma_dev,
> +	struct vhost_iotlb *resv_iotlb)
> +{
> +	struct list_head dev_resv_regions;
> +	phys_addr_t resv_msi_base = 0;
> +	struct iommu_resv_region *region;
> +	int ret = 0;
> +	bool with_sw_msi = false;
> +	bool with_hw_msi = false;
> +
> +	INIT_LIST_HEAD(&dev_resv_regions);
> +	iommu_get_resv_regions(dma_dev, &dev_resv_regions);
> +
> +	list_for_each_entry(region, &dev_resv_regions, list) {
> +		ret = vhost_iotlb_add_range_ctx(resv_iotlb, region->start,
> +				region->start + region->length - 1,
> +				0, 0, NULL);
> +		if (ret) {
> +			vhost_iotlb_reset(resv_iotlb);
> +			break;
> +		}
> +
> +		if (region->type == IOMMU_RESV_MSI)
> +			with_hw_msi = true;
> +
> +		if (region->type == IOMMU_RESV_SW_MSI) {
> +			resv_msi_base = region->start;
> +			with_sw_msi = true;
> +		}
> +	}
> +
> +	if (!ret && !with_hw_msi && with_sw_msi)
> +		ret = iommu_get_msi_cookie(domain, resv_msi_base);
> +
> +	iommu_put_resv_regions(dma_dev, &dev_resv_regions);
> +
> +	return ret;
> +}
> +
>  static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  {
>  	struct vdpa_device *vdpa = v->vdpa;
> @@ -1128,11 +1174,16 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  
>  	ret = iommu_attach_device(v->domain, dma_dev);
>  	if (ret)
> -		goto err_attach;
> +		goto err_alloc_domain;
>  
> -	return 0;
> +	ret = vhost_vdpa_resv_iommu_region(v->domain, dma_dev, &v->resv_iotlb);
> +	if (ret)
> +		goto err_attach_device;
>  
> -err_attach:
> +	return 0;
> +err_attach_device:
> +	iommu_detach_device(v->domain, dma_dev);
> +err_alloc_domain:
>  	iommu_domain_free(v->domain);
>  	return ret;
>  }
> @@ -1385,6 +1436,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>  		goto err;
>  	}
>  
> +	vhost_iotlb_init(&v->resv_iotlb, 0, 0);
> +
>  	r = dev_set_name(&v->dev, "vhost-vdpa-%u", minor);
>  	if (r)
>  		goto err;
> -- 
> 2.25.1


