Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9064049BC42
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiAYThd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:37:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbiAYTgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643139378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OTQ4mdS7TZuENfBoyB8K2lauO/+f3s/CNFZ8+QrcxlM=;
        b=RRFAKglpMqr9SsI9xXhUQi7dp4sBRA0dO51DHhAfqbP3k6WphOFLMDF7HpRr1KY1ITARUA
        X8EWlQiGH42pX3G85VxBPkcKURAl4BpCG/1RmAhM9hNlf3Vux9GdMmu8b5wM/XiRlax0tn
        7IrZXBzJ7qz+HW51lmKdckAuAdzVUxw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-jgWaEM_ZP5uM3NWy4zWYbw-1; Tue, 25 Jan 2022 14:36:16 -0500
X-MC-Unique: jgWaEM_ZP5uM3NWy4zWYbw-1
Received: by mail-ej1-f72.google.com with SMTP id h22-20020a1709060f5600b006b11a2d3dcfso3869555ejj.4
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:36:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OTQ4mdS7TZuENfBoyB8K2lauO/+f3s/CNFZ8+QrcxlM=;
        b=o7VnS+GjonryZFSFAYTrNfl6xQ5jsBhqOlLPm8HkBRlkNvl2f6vI301gEgZ9GPa1XD
         G+BDk5zPtOymuZaEhMfmyiAdCvnH6GhPtWcq/DG7TD002xJ2nhrZGvVnTgaaS72UJ2S5
         htgAwxHMuK2MpnA7YDKehiKT/IJiujmOcauYTI56vi9ijy/Cuw+PkuGD3UGnes+xtmgf
         YtpwrHIDdol8unkSloJTOX0YLR4okQIf3zSgY8LIUD33FJ4p2qtOidh8OGX+eS58UPR/
         jU9xvXk2Y0LuMJHzWYUNCefarPzH+VRQS/zTJl2ZlVHt4dE0j+Wg8ScTH4psGCwdCpUc
         +2cA==
X-Gm-Message-State: AOAM533RDyBvcznDfQ1G6dRgdqwQIn8kfu6ijl+AML0IgKwWsUvPhQoT
        SloT0G+/YXzOlEThtPvaSPxhGC3GKEkpEIRtglCaUvW10/f1uylJs82+dooHWbdpCFLTGH2vPHW
        d2OZsMi5SCfVsZGHw
X-Received: by 2002:a05:6402:2994:: with SMTP id eq20mr21736137edb.281.1643139374857;
        Tue, 25 Jan 2022 11:36:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlVE9Pz77RC+rOZa7S9uRx5aXKFXFEbpDJMUq2Xe969xw3jJJ0tHzapo3icoqzMKN2HqeMfA==
X-Received: by 2002:a05:6402:2994:: with SMTP id eq20mr21736119edb.281.1643139374622;
        Tue, 25 Jan 2022 11:36:14 -0800 (PST)
Received: from redhat.com ([176.12.185.204])
        by smtp.gmail.com with ESMTPSA id qw3sm6602956ejc.128.2022.01.25.11.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:36:14 -0800 (PST)
Date:   Tue, 25 Jan 2022 14:36:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 2/4] vDPA/ifcvf: implement device MSIX vector allocator
Message-ID: <20220125143254-mutt-send-email-mst@kernel.org>
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
 <20220125091744.115996-3-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125091744.115996-3-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 05:17:42PM +0800, Zhu Lingshan wrote:
> This commit implements a MSIX vector allocation helper
> for vqs and config interrupts.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index d1a6b5ab543c..7e2af2d2aaf5 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -58,14 +58,40 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>  	ifcvf_free_irq_vectors(pdev);
>  }
>  
> +static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)


So the helper returns an int...

> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	u16 max_intr, ret;
> +
> +	/* all queues and config interrupt  */
> +	max_intr = vf->nr_vring + 1;
> +	ret = pci_alloc_irq_vectors(pdev, 1, max_intr, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
> +
> +	if (ret < 0) {
> +		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> +		return ret;


which is negative on error...

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
>  	struct ifcvf_hw *vf = &adapter->vf;
>  	int vector, i, ret, irq;
> -	u16 max_intr;
> +	u16 nvectors, max_intr;
> +
> +	nvectors = ifcvf_alloc_vectors(adapter);

which you proceed to stash into an unsigned int ...

> +	if (!(nvectors > 0))

and then compare to zero ...

> +		return nvectors;
>

correct error handling is unlikely as a result.

  
> -	/* all queues and config interrupt  */
>  	max_intr = vf->nr_vring + 1;
>  
>  	ret = pci_alloc_irq_vectors(pdev, max_intr,


As long as you are introducing a helper, document it's return
type and behaviour and then use correctly.

> -- 
> 2.27.0

