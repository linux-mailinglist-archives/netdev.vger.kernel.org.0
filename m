Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E473F68CF
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhHXSJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:09:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhHXSJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629828521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wf/taVlZFNs0ougRCLlTYVmNw738QSiSdoCHx8OR6ig=;
        b=OaBhncK3OkMt0iQW1wbKSWlrzuyIK4RzdLEEyCOnADDe3fZMcr0Znmr9gTeNX+qdzHGCUD
        isQ96y/EyQfvQgIIc+2/XmjMkJbJWtKDq2aOr9nuZzoqSKk49+kZzeBnujzedBG7NszFI5
        g8HQ9CwLSe2ibjWvIjh7UEILuTWngCM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-CGvhgctSNWSufrCL2e-oXg-1; Tue, 24 Aug 2021 14:08:39 -0400
X-MC-Unique: CGvhgctSNWSufrCL2e-oXg-1
Received: by mail-wr1-f71.google.com with SMTP id a9-20020a0560000509b029015485b95d0cso6013757wrf.5
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 11:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wf/taVlZFNs0ougRCLlTYVmNw738QSiSdoCHx8OR6ig=;
        b=TjlKdbyQVDssnwnyMAppzmEQcINSqIt9XGeOMbN9uGYfcSd1wue/9t711i5pucU5TM
         l1vYSYZ6pkLj/Mbng86k12i6Cw+lvql96yo/ThJ5R1rU32YCZlbBj93RIn50XYRZE/qS
         2huCpVEsLP7/TQat2A07J8OcNgYs9RoP/C4Wz+BuaLFruJhm/aOecd6Pbcs7hFwFqgGa
         3hYr5Mw1JjA4TPV3S4V5qJ1UlK9OV9BuC+VIN9W1OQ5+Kf8sbE5zPCMSCCU1JDVOk7DT
         pf+KK4hXWnbHjDaxPOkAWhluZPpOkBOtXyapc7/EmmI66fKV/O5EOLVSsJ7Pw4jSSAMJ
         Y5jQ==
X-Gm-Message-State: AOAM530dlZT4ftuTStKh2HYeDoYaNwuJIdkUFL3x/wlH6LFW22iZxPRt
        Rd8AmhWwJajce+276oIgmm/MKGAweid8U/FVTvIx5BcHvjlhRIaMeg5ZUGBPtMHdOatOdUiU14U
        nrvAeSZFsAo/v3jHs
X-Received: by 2002:adf:f541:: with SMTP id j1mr20290129wrp.180.1629828518661;
        Tue, 24 Aug 2021 11:08:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfDkwHQb1CTI5AdZfg7DL+P9GYpcylznvSa7+7v+ifINTac25O0lU3KK9ol/wm7Mi5FZusQw==
X-Received: by 2002:adf:f541:: with SMTP id j1mr20290112wrp.180.1629828518469;
        Tue, 24 Aug 2021 11:08:38 -0700 (PDT)
Received: from redhat.com ([212.116.168.114])
        by smtp.gmail.com with ESMTPSA id l187sm327519wml.39.2021.08.24.11.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 11:08:37 -0700 (PDT)
Date:   Tue, 24 Aug 2021 14:08:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v11 01/12] iova: Export alloc_iova_fast() and
 free_iova_fast()
Message-ID: <20210824140758-mutt-send-email-mst@kernel.org>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-2-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818120642.165-2-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 08:06:31PM +0800, Xie Yongji wrote:
> Export alloc_iova_fast() and free_iova_fast() so that
> some modules can make use of the per-CPU cache to get
> rid of rbtree spinlock in alloc_iova() and free_iova()
> during IOVA allocation.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


This needs ack from iommu maintainers. Guys?

> ---
>  drivers/iommu/iova.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b6cf5f16123b..3941ed6bb99b 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -521,6 +521,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>  
>  	return new_iova->pfn_lo;
>  }
> +EXPORT_SYMBOL_GPL(alloc_iova_fast);
>  
>  /**
>   * free_iova_fast - free iova pfn range into rcache
> @@ -538,6 +539,7 @@ free_iova_fast(struct iova_domain *iovad, unsigned long pfn, unsigned long size)
>  
>  	free_iova(iovad, pfn);
>  }
> +EXPORT_SYMBOL_GPL(free_iova_fast);
>  
>  #define fq_ring_for_each(i, fq) \
>  	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)
> -- 
> 2.11.0

