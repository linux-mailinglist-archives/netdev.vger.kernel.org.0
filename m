Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50B3489007
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiAJGKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:10:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230191AbiAJGKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641795011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TqtX8zSHRS0ZsJAZBKWh9ecrQ0m/m7ETNTVved23oRg=;
        b=TohtNWydoSDW9mw9Fgf9H/qgUU4A1fToZecn9KCrp0C8i4Z0HRRpZdnhBZ/tnyAFjymbPT
        LQuLHwtSl3ZAuRgM2dgm+6lfnCEciOXdtTaZhFYrXRBbOtanmxaWLvDOtH0rHoqdM2Bhsr
        DGZDDjzbTQSMs9t/RttzHENgqXBqn5I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-3-sTGHgGMk6__3SYDouvKQ-1; Mon, 10 Jan 2022 01:10:09 -0500
X-MC-Unique: 3-sTGHgGMk6__3SYDouvKQ-1
Received: by mail-wm1-f69.google.com with SMTP id m15-20020a7bce0f000000b003473d477618so5817967wmc.8
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TqtX8zSHRS0ZsJAZBKWh9ecrQ0m/m7ETNTVved23oRg=;
        b=i0JdN+U9hq1ypWa+4yjnkSEK3ormKwunN86D2ruuWoOb807h5ZePX3aNCrBXo98pic
         WjthFaRu+ZbJJRQEYdWq0e99Uykpf6lcfOjIihmGhmr4qf+Byugh1toUNmaJHtw5joId
         FWq01ZpwFNaYjAkvRoxeddXtEvNa2LD1hAAd7CIdrskdFNvjmdFJ+BcSg6ThZvUFKwtu
         FBLTi6ANUygQdJEgRdvTVyCZez2zklrZA2hi87Ov4bu4W0caFJeIuuOI0mT5H3ZeY+um
         OB1rljW71oF5FkmzmEZU16kPAjcydhnWe9+/8g4q7Ynca+GYDKxZTMIM8xFxD4RKbW+q
         gs/w==
X-Gm-Message-State: AOAM531aID6gsXgNOUYBu15ew21849QYEY1ME9g6UkzmC7x2Afhcgq2d
        hyVuoGySQd8Z0ag1+wYEmhAi8Bh+7tRaV+Tonj23xx72dz+Dc0HYEQRHW70wrXllTJOy/j11C8d
        /uKUr+vCaQEuVlUyy
X-Received: by 2002:a05:600c:4e88:: with SMTP id f8mr20759261wmq.45.1641795008258;
        Sun, 09 Jan 2022 22:10:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPQIWRB8qMXF1z8iwjQpv/gtu3SQ9cd0jQPzCIKxptsCL6M/iJGaOERGoiwBRxcDZf/G3IQA==
X-Received: by 2002:a05:600c:4e88:: with SMTP id f8mr20759248wmq.45.1641795008069;
        Sun, 09 Jan 2022 22:10:08 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id j26sm6401374wms.46.2022.01.09.22.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:10:07 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:10:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] vDPA/ifcvf: implement shared irq handlers for vqs
Message-ID: <20220110010911-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-5-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-5-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:48PM +0800, Zhu Lingshan wrote:
> It has observed that a device may fail to alloc enough vectors on
> some platforms, e.g., requires 16 vectors, but only 2 or 4 vector
> slots allocated. The virt queues have to share a vector/irq under
> such circumstances.
> 
> This irq handlers has to kick every queue because it is not
> possible to tell which queue triggers the interrupt.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 64fc78eaa1a9..19e1d1cd71a3 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -37,6 +37,21 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
>  	return IRQ_HANDLED;
>  }
>  
> +static irqreturn_t ifcvf_shared_intr_handler(int irq, void *arg)
> +{
> +	struct ifcvf_hw *vf = arg;
> +	struct vring_info *vring;
> +	int i;
> +
> +	for (i = 0; i < vf->nr_vring; i++) {
> +		vring = &vf->vring[i];
> +		if (vring->cb.callback)
> +			vf->vring->cb.callback(vring->cb.private);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static void ifcvf_free_irq_vectors(void *data)
>  {
>  	pci_free_irq_vectors(data);


A static function with no caller. surprised gcc does not warn.

> -- 
> 2.27.0

