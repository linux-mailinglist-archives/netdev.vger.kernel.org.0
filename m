Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF3489009
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbiAJGMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:12:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230191AbiAJGMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:12:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641795153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bLlLjl5Uy7bEGG/f322zl5ts0Cpy9zOkUoTISjBrCFo=;
        b=h90W5SlKYDyTdRapRob3JG2oyCxdOEY5broGuHb1aP1TzDSYERx+lzN6drQhxLcg/nzcsT
        xmEC5kwpMZkRrsFEh2YP8WX3x51U1pfN054E2Slmno0/ahuBYNvLVSykHW3lRJSh/5X6/+
        HwLSx9wo17dYqhUwfbf4wvA8wCyLv+I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-CeCbdXE7P5mOB9lKwL6QvA-1; Mon, 10 Jan 2022 01:12:31 -0500
X-MC-Unique: CeCbdXE7P5mOB9lKwL6QvA-1
Received: by mail-wr1-f72.google.com with SMTP id r1-20020adfb1c1000000b001a4852a806cso3779456wra.9
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bLlLjl5Uy7bEGG/f322zl5ts0Cpy9zOkUoTISjBrCFo=;
        b=m+is0rh5WSMlRcNkkfbnD9Fn0a1IOkWm5DampZJF/mYzLMdClTmEFWPV2+16r/0jY8
         r0dUaDS08dW8xqA0mGONLfW6bDqo4LhUNEhiwi0gd84DJHz0AqRekd6eL6IcuCRNdCXq
         vzxT2FzCT3uYHcE+/ztW2m+CZFldoxSxF+f+1IdEXeRI+BEiXOU4VuLpEqJLsHPYvXsC
         gqnnM50U0YH6AECxBPDumfrzvx851iOUvxqEkt0HyzwFbjeRtJAf2uLvr5eT38Sb7lIC
         sgckfLxDvYMN/uXF/9NRI7T0rYG5BJAJBQbO2AM7YkAovp0karqbI3WXJclLEWf01nSj
         ze8g==
X-Gm-Message-State: AOAM5313Ko6jGgbk2mxgMXnB/EWCYL47riVTl/fCJJhTD18ZwQppYQhh
        HUJ0H9K5CklLRLpZDdXifLhm1vcigKHn9LmBSWqr64puVkWcajaWgHLc9cgflBZ8mq0vjob9Ar1
        EPdV5oKydSNp/0Dn8
X-Received: by 2002:adf:f84e:: with SMTP id d14mr859137wrq.109.1641795150406;
        Sun, 09 Jan 2022 22:12:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWb7tCKZUy8MLPJJX3ebPujI2JI/MgKgCveF7ei3YrFiN4Zyomya/2UZb4cUjS5oO4RsUvKw==
X-Received: by 2002:adf:f84e:: with SMTP id d14mr859120wrq.109.1641795150201;
        Sun, 09 Jan 2022 22:12:30 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id z5sm4612540wmf.25.2022.01.09.22.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:12:29 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:12:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 3/7] vDPA/ifcvf: implement device MSIX vector allocation
 helper
Message-ID: <20220110011024-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:47PM +0800, Zhu Lingshan wrote:
> This commit implements a MSIX vector allocation helper
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 6dc75ca70b37..64fc78eaa1a9 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -58,6 +58,30 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>  	ifcvf_free_irq_vectors(pdev);
>  }
>  
> +static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	u16 max_intr = 0;
> +	u16 ret = 0;

just declare these where they are inited. this = 0 is pointless.

> +
> +	/* all queues and config interrupt  */
> +	max_intr = vf->nr_vring + 1;
> +	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY);


coding style violation.

> +
> +	if (ret < 0) {
> +		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> +		return ret;
> +	}
> +
> +	if (ret < max_intr)
> +		IFCVF_INFO(pdev,
> +			   "Requested %u vectors, however only %u allocated, lower performance\n",
> +			   max_intr, ret);
> +
> +	return ret;
> +}
> +
>  static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>  {
>  	struct pci_dev *pdev = adapter->pdev;

this kind of split up does not help review. just include
it with the code that uses it.


> -- 
> 2.27.0

