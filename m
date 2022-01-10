Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF266489006
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiAJGJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:09:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230191AbiAJGJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:09:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641794946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iep9HQuqaNQXRlydkS2utctGhyeED8H8bAPdjLcBXSg=;
        b=Yz/TDrBn4ss+lOmw6UN3L18U5X8MA1GoizLTvHVdn5atuKkp4/FTIOKBIXma7bch1QaA2j
        KaPtrh7LSBtE6BWRQIpUNh2yRvsACRI6LmfbXJeFRlvyRbZDdMTk6i+WVmJC0UPHOon8W1
        mXu3rmnHOkey8oMu6A/RqWvLkwiaCIs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-d5crQ0brNP6QVdDh77UbuQ-1; Mon, 10 Jan 2022 01:09:05 -0500
X-MC-Unique: d5crQ0brNP6QVdDh77UbuQ-1
Received: by mail-wr1-f70.google.com with SMTP id i23-20020adfaad7000000b001a6320b66b9so1909954wrc.15
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iep9HQuqaNQXRlydkS2utctGhyeED8H8bAPdjLcBXSg=;
        b=v8xObISPKt/38z3yKoFI6BNTn1HITs/cM8H8dO8+/5jF5RUG0nQbT0vuNsxnL4TXMa
         PSAIPnF/hC3ndPytl0ZwiY9aBoPAmj2yphSteP4J3eog6guIQLCNmzTRclOSR5000EE1
         4bh7g8isKT0xmeNV9GbWLZ1lt4nKpasSRyxGFb4g71+xNlO65MrjkPy5R7MzCysz6KWY
         f3UKPUnHWcgARVvVeNEU1Nt2gPj7IX0pZeip56rCaurcKWIc+mPUU/9eLdYy5GERb02P
         6E62GywK3pbv1t40XLSUQ67mKkaDn6KHBsejPK9Z987jhO9mAvDPYsJr9SlPfrfc+CM6
         E1Yw==
X-Gm-Message-State: AOAM530ByRiqJMWLzqu34s7/xfpM8sY8CAN7IcWmPxhnpy8MTAUbL4vW
        49KCmULRjw8UFV1Pyjs6XKu2JvHC1wTP9O8ToIO1zDNACDNt+G1thbyj2AMOiIEf5aM9QEKOdN2
        0xY/B47QChI8XMLsZ
X-Received: by 2002:a05:600c:1f19:: with SMTP id bd25mr20699461wmb.42.1641794944395;
        Sun, 09 Jan 2022 22:09:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiOWhCgcDAGTXMDSdIifwjm+at5gyxrIAVj6jz/icPqhYlt5fRZ5FkRBC7jBZ52ZcNgeXjqw==
X-Received: by 2002:a05:600c:1f19:: with SMTP id bd25mr20699451wmb.42.1641794944215;
        Sun, 09 Jan 2022 22:09:04 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id r1sm6314313wrz.30.2022.01.09.22.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:09:03 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:09:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 5/7] vDPA/ifcvf: irq request helpers for both shared and
 per_vq irq
Message-ID: <20220110010714-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-6-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-6-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:49PM +0800, Zhu Lingshan wrote:
> This commit implements new irq request helpers:
> ifcvf_request_shared_vq_irq() for a shared irq, in this case,
> all virtqueues would share one irq/vector. This can help the
> device work on some platforms that can not provide enough
> MSIX vectors
> 
> ifcvf_request_per_vq_irq() for per vq irqs, in this case,
> every virtqueue has its own irq/vector
> 
> ifcvf_request_vq_irq() calls either of the above two, depends on
> the number of allocated vectors.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c |  9 -----
>  drivers/vdpa/ifcvf/ifcvf_main.c | 66 +++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 696a41560eaa..fc496d10cf8d 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -349,15 +349,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>  		ifc_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
>  				     &cfg->queue_used_hi);
>  		ifc_iowrite16(hw->vring[i].size, &cfg->queue_size);
> -		ifc_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
> -
> -		if (ifc_ioread16(&cfg->queue_msix_vector) ==
> -		    VIRTIO_MSI_NO_VECTOR) {
> -			IFCVF_ERR(ifcvf->pdev,
> -				  "No msix vector for queue %u\n", i);
> -			return -EINVAL;
> -		}
> -
>  		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
>  		ifc_iowrite16(1, &cfg->queue_enable);
>  	}
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 19e1d1cd71a3..ce2fbc429fbe 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -97,6 +97,72 @@ static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
>  	return ret;
>  }
>  
> +static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	int i, vector, ret, irq;
> +
> +	for (i = 0; i < vf->nr_vring; i++) {
> +		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n", pci_name(pdev), i);
> +		vector = i;
> +		irq = pci_irq_vector(pdev, vector);
> +		ret = devm_request_irq(&pdev->dev, irq,
> +				       ifcvf_intr_handler, 0,
> +				       vf->vring[i].msix_name,
> +				       &vf->vring[i]);
> +		if (ret) {
> +			IFCVF_ERR(pdev, "Failed to request irq for vq %d\n", i);
> +			ifcvf_free_irq(adapter, i);
> +		} else {
> +			vf->vring[i].irq = irq;
> +			ifcvf_set_vq_vector(vf, i, vector);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int ifcvf_request_shared_vq_irq(struct ifcvf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	int i, vector, ret, irq;
> +
> +	vector = 0;
> +	irq = pci_irq_vector(pdev, vector);
> +	ret = devm_request_irq(&pdev->dev, irq,
> +			       ifcvf_shared_intr_handler, 0,
> +			       "ifcvf_shared_irq",
> +			       vf);
> +	if (ret) {
> +		IFCVF_ERR(pdev, "Failed to request shared irq for vf\n");
> +
> +		return ret;
> +	}
> +
> +	for (i = 0; i < vf->nr_vring; i++) {
> +		vf->vring[i].irq = irq;
> +		ifcvf_set_vq_vector(vf, i, vector);
> +	}
> +
> +	return 0;
> +
> +}
> +
> +static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter, u8 vector_per_vq)
> +{
> +	int ret;
> +
> +	if (vector_per_vq)
> +		ret = ifcvf_request_per_vq_irq(adapter);
> +	else
> +		ret = ifcvf_request_shared_vq_irq(adapter);
> +
> +	return ret;
> +}
> +
> +
>  static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>  {
>  	struct pci_dev *pdev = adapter->pdev;


this moves code from init function to static ones which
are never called. I guess until patch 7? You can't
split up patches like this, git bisect won't work if you do -
code needs to work after each patch is applied.

> -- 
> 2.27.0

