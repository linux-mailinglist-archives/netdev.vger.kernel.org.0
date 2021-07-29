Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5B13DA744
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhG2PNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhG2PNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:13:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D712C061765;
        Thu, 29 Jul 2021 08:13:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so16094041pjb.3;
        Thu, 29 Jul 2021 08:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=akMNdPJ4WS5nbnxgvsvMYm/zRUHwcBCfIsow9Ks6kis=;
        b=dLioqOpBl2TpGowMKGZzRjcLFx0fZ0sBHYpCjAxABGEJkW9CgwGvHYqQ7apVDck0xx
         W5FuDqVbCnNd70/DtkMCPd4nqMpezuT6upxl41IkUNtJlgdLrD+RhjExDK3z3ce7yAyi
         4T3pGiS49Fpux5+3O0k15LkGMg6tQKFB1XgNeZAHuGRcTvc6EBLKsj3eNAVBiUHKR1xX
         /CgKKN3LRKSV3ywoC91cZi4VtcHW9BdxphQdF31SCJLo1LkxTmqp53t070UtFqT4mdev
         zb6GH16wdrsVQodoRsmLapOWCa0r0OH1HB0WqtJ3jUF4EHVlDutR3ypdLueHvAxYkwe8
         3NDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akMNdPJ4WS5nbnxgvsvMYm/zRUHwcBCfIsow9Ks6kis=;
        b=Rf0LXdqe35DIX0CeL4+eXovGkojd7PyjM6TJkmS3RxQuadOe4KoRRY5esbULUo6naa
         faBGdl4gcIyjxY0Cg/TlnuqLsaar8RzKvM4U8hTbColvlAS82Puwz06b9CJ4yJ+lRvRE
         L/FGno6GhuY+tYpMQvx9MbierLOilZSdXuKrfWc7WukWQarUdLixCtBI09GQTc8mbvSb
         8PlaypJ9QIWmO4l3pffNmBLf0c2sSkS82WH04BdNZ0XbqWrBYFxF5Ncu6PKsP1uc2uoM
         dSbG68XdTpW/tL3scYwhwZPZ8X860fg0CwgbEkdJNvvieOsfxtdV80/Eby6m3YyeZUVc
         8F/A==
X-Gm-Message-State: AOAM532Qu9OdkWouio9FtnI25wpAYjCsi2W4gACDVOA3ING1q3HdoyQY
        JWTCZsUTlYmtSTmRnhKohAc=
X-Google-Smtp-Source: ABdhPJz+1u+t4XYMb612jZVRZC2eq6EVWswZWptItrWPSpDVi083nnf1kcuFDG/7rvR4ghR/eM6m5A==
X-Received: by 2002:a63:5505:: with SMTP id j5mr4265664pgb.250.1627571608984;
        Thu, 29 Jul 2021 08:13:28 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id c7sm4247137pgq.22.2021.07.29.08.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 08:13:28 -0700 (PDT)
Subject: Re: [PATCH 09/13] DMA: Add dma_map_decrypted/dma_unmap_encrypted()
 function
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-10-ltykernel@gmail.com>
Message-ID: <da69c920-c12a-b4ad-7554-68b9e99bb6ce@gmail.com>
Date:   Thu, 29 Jul 2021 23:13:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728145232.285861-10-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Christoph:
      Could you have a look at this patch and the following patch
"[PATCH 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function
for HV IVM" These two patches follows your previous comments and add 
dma_map_decrypted/dma_unmap_decrypted(). I don't add arch prefix because 
each platform may populate their callbacks into dma memory decrypted ops.

Thanks.

On 7/28/2021 10:52 PM, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> In Hyper-V Isolation VM with AMD SEV, swiotlb boucne buffer
> needs to be mapped into address space above vTOM and so
> introduce dma_map_decrypted/dma_unmap_encrypted() to map/unmap
> bounce buffer memory. The platform can populate man/unmap callback
> in the dma memory decrypted ops.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>   include/linux/dma-map-ops.h |  9 +++++++++
>   kernel/dma/mapping.c        | 22 ++++++++++++++++++++++
>   2 files changed, 31 insertions(+)
> 
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 0d53a96a3d64..01d60a024e45 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -71,6 +71,11 @@ struct dma_map_ops {
>   	unsigned long (*get_merge_boundary)(struct device *dev);
>   };
>   
> +struct dma_memory_decrypted_ops {
> +	void *(*map)(void *addr, unsigned long size);
> +	void (*unmap)(void *addr);
> +};
> +
>   #ifdef CONFIG_DMA_OPS
>   #include <asm/dma-mapping.h>
>   
> @@ -374,6 +379,10 @@ static inline void debug_dma_dump_mappings(struct device *dev)
>   }
>   #endif /* CONFIG_DMA_API_DEBUG */
>   
> +void *dma_map_decrypted(void *addr, unsigned long size);
> +int dma_unmap_decrypted(void *addr, unsigned long size);
> +
>   extern const struct dma_map_ops dma_dummy_ops;
> +extern struct dma_memory_decrypted_ops dma_memory_generic_decrypted_ops;
>   
>   #endif /* _LINUX_DMA_MAP_OPS_H */
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 2b06a809d0b9..6fb150dc1750 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -13,11 +13,13 @@
>   #include <linux/of_device.h>
>   #include <linux/slab.h>
>   #include <linux/vmalloc.h>
> +#include <asm/set_memory.h>
>   #include "debug.h"
>   #include "direct.h"
>   
>   bool dma_default_coherent;
>   
> +struct dma_memory_decrypted_ops dma_memory_generic_decrypted_ops;
>   /*
>    * Managed DMA API
>    */
> @@ -736,3 +738,23 @@ unsigned long dma_get_merge_boundary(struct device *dev)
>   	return ops->get_merge_boundary(dev);
>   }
>   EXPORT_SYMBOL_GPL(dma_get_merge_boundary);
> +
> +void *dma_map_decrypted(void *addr, unsigned long size)
> +{
> +	if (set_memory_decrypted((unsigned long)addr,
> +				 size / PAGE_SIZE))
> +		return NULL;
> +
> +	if (dma_memory_generic_decrypted_ops.map)
> +		return dma_memory_generic_decrypted_ops.map(addr, size);
> +	else
> +		return addr;
> +}
> +
> +int dma_unmap_encrypted(void *addr, unsigned long size)
> +{
> +	if (dma_memory_generic_decrypted_ops.unmap)
> +		dma_memory_generic_decrypted_ops.unmap(addr);
> +
> +	return set_memory_encrypted((unsigned long)addr, size / PAGE_SIZE);
> +}
> 
