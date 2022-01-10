Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DEC489001
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiAJGHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:07:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233139AbiAJGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:07:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641794827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RirKwTlZyn6rdcGGnA71xBWoTMpVJqPFaQo0tXydwi8=;
        b=EpsP5OQEY31EWvEENVSdqoNmQKRYqDVT/fAA/mwkHh1opHVNRCmkJUFqBQAooY7V4GIhT6
        eDZkJdv9DWQeo4EsprQFWSmFKfGtvZ1jVpCECwt4Ku6d9fpBYB/R/TADrmnVYa3jZ5UwFz
        3FFXssXSHqB8zur6ykg3lTNLTFTqoG0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-it-cGQ3hN66uBdKLtprSdQ-1; Mon, 10 Jan 2022 01:07:06 -0500
X-MC-Unique: it-cGQ3hN66uBdKLtprSdQ-1
Received: by mail-wm1-f69.google.com with SMTP id b2-20020a7bc242000000b00348639aed88so554079wmj.8
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RirKwTlZyn6rdcGGnA71xBWoTMpVJqPFaQo0tXydwi8=;
        b=EwvjNO5BEDfugqgwQvQIup93FKeKpkCfBsX1goPh1MjO+E3bvzeKNqumf5WvxVkyio
         iVSbvCHAV/udG6vu75/29sCurdXKV9hBRhuNJyGQ9WffxSkSkHy1eFVGR+6M1M0Vxs2E
         OWDjcgm3SDtnoL3Z8kHaI9M+/SmUhUZZIajZ3WibZzBfFZgEJI7REQZDtskcgxRhYhcp
         eTXOlTgCvxyxBlxOqQDUQQILweF8Enyfxiol32xl6jFeI79XLzZ4nuW3oU5z5K6pMBAe
         z9j5f9cZWYRDgip29iMussYTyQkdQASXxXaH4gx1InQDmUlgubS5NxvgsE4LYIbvOFbS
         Wdpg==
X-Gm-Message-State: AOAM530QCKFRYi+DJLDDGNVkEUFVie/eNi8pPiXdx2EREIxWkvls3gHZ
        jeE6apE9JK6OWhBKhsxIhhjRIasVZftO8kl+/HiMtRD6ETvRd5SFwwnoed6AVBssbYDaVBkIdAu
        xZTJ2cuNVk3RdFPit
X-Received: by 2002:a05:6000:c8:: with SMTP id q8mr1385108wrx.611.1641794824879;
        Sun, 09 Jan 2022 22:07:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWh3vBwI/e0fA7luLEGS7w6JNs+0cWV5D9OstdqCiCBxY6N48uI0WuKYBwrivlqmtPlQfnCQ==
X-Received: by 2002:a05:6000:c8:: with SMTP id q8mr1385101wrx.611.1641794824717;
        Sun, 09 Jan 2022 22:07:04 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id k33sm5830370wms.21.2022.01.09.22.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:07:04 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:07:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 6/7] vDPA/ifcvf: implement config interrupt request helper
Message-ID: <20220110010548-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-7-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-7-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:50PM +0800, Zhu Lingshan wrote:
> This commit implements new helper to request config interrupt by
> a given MSIX vector.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c |  6 ------
>  drivers/vdpa/ifcvf/ifcvf_main.c | 26 ++++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index fc496d10cf8d..38f91dc6481f 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -330,12 +330,6 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>  
>  	ifcvf = vf_to_adapter(hw);
>  	cfg = hw->common_cfg;
> -	ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
> -
> -	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
> -		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
> -		return -EINVAL;
> -	}
>  
>  	for (i = 0; i < hw->nr_vring; i++) {
>  		if (!hw->vring[i].ready)


this drops code presumably breaking it. I guess follow up patch
restores it back? pls squash there.

> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ce2fbc429fbe..414b5dfd04ca 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -162,6 +162,32 @@ static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter, u8 vector_per_vq)
>  	return ret;
>  }
>  
> +static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_vector)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	int ret;
> +
> +	if (!config_vector) {
> +		IFCVF_INFO(pdev, "No config interrupt because of no vectors\n");
> +		vf->config_irq = -EINVAL;
> +		return 0;
> +	}
> +
> +	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
> +		 pci_name(pdev));
> +	vf->config_irq = pci_irq_vector(pdev, config_vector);
> +	ret = devm_request_irq(&pdev->dev, vf->config_irq,
> +			       ifcvf_config_changed, 0,
> +			       vf->config_msix_name, vf);
> +	if (ret) {
> +		IFCVF_ERR(pdev, "Failed to request config irq\n");
> +		return ret;
> +	}
> +		ifcvf_set_config_vector(vf, config_vector);
> +
> +	return 0;
> +}
>  

So this adds a static function with no caller, I guess the
caller is in the next patch - pls squash there.

>  static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>  {
> -- 
> 2.27.0

