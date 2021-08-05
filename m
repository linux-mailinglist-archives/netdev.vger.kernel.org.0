Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27713E18E7
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbhHEP5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242750AbhHEP5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 11:57:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6431C061765;
        Thu,  5 Aug 2021 08:56:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so15936500pjs.0;
        Thu, 05 Aug 2021 08:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RCTsDCtEUr9crU7FdVukkrAFOZDkX3iu2puUZlCshpI=;
        b=QLTD+I4si6TRStW3i+byEh+1Irtr6ILej9vo4oW1Nn2U3wtKPus5Q6l0kyCkqfLQ+P
         hZ8yjDAd0Nuc6MtizkDbmXNItH98ZjFBLjtXtMxv39zNJnaZWCHW2ngj5q4Pu9jNvfq8
         bzNSavZ4ty6c8S6Sfv/hFxaTSSnUMx90F8xfVWQm9z5xV1zhBRpVu10ETufiRpOiQTD9
         RzE6mO6mQczpUPW+Q+r00eX58g42C1HasWKWfZ2UVeAFyJj+HwJU606hzf87gKJ/+ooV
         BuwmRJ98aX+tfm7YNSXUbt4iN34dCtoubVxnaF1USweLp+Vjbulgjcf9sDEiBTuejvtR
         5IZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RCTsDCtEUr9crU7FdVukkrAFOZDkX3iu2puUZlCshpI=;
        b=EHfJJozw/hQz5GwvsaCq8Iq3qEMyOZtJi0XpHavyO1KW0I5B7auRPW5tlJrZHThPYv
         kk+7dZ3hT8+2rZ8ryzNhxb8dpdcBrIqXnARc0m+08jj8SBIxy+pB5xYzTGWCBDdDft67
         3Nl84dBBsTXpduqY5o2XugHIQT2ITRoosnjR1tHKPh+u45fYF64iCO1lt6kUN0pYIUF/
         AWyQPIFO3qq3EJ29UuKCEJVgka1NGKNz3D/HXx4ZPkM3mb8oMNVMwJKc2gUb4PDu04gm
         tlELCcwPHCcn7vRVHSw4GvMtG9IHkU64YP9lqXN2bCAcI5mlybvWWRKDLDDffn1Vh2aI
         BWJA==
X-Gm-Message-State: AOAM531/PFKc26owJu55j2MRHOwuPlKSZTDd9nL5zjTMybOWj3mR/RFR
        uSEtHfLqnHjPrLcGQMBmP40=
X-Google-Smtp-Source: ABdhPJx2CcJ9YMvvKydKzMmm/L2XWhlBqcisHtQ6BBUyv1YcZ1T2Ns9MTQ4Jit08qy2zQW953vHgXw==
X-Received: by 2002:a17:902:9a46:b029:12c:9aae:daac with SMTP id x6-20020a1709029a46b029012c9aaedaacmr4504908plv.78.1628179005359;
        Thu, 05 Aug 2021 08:56:45 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id m1sm4685977pfk.84.2021.08.05.08.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 08:56:45 -0700 (PDT)
Subject: Re: [PATCH V2 10/14] DMA: Add dma_map_decrypted/dma_unmap_encrypted()
 function
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, pgonda@google.com,
        david@redhat.com, krish.sadhukhan@oracle.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, xen-devel@lists.xenproject.org,
        martin.b.radev@gmail.com, ardb@kernel.org, rientjes@google.com,
        tj@kernel.org, keescook@chromium.org,
        michael.h.kelley@microsoft.com
References: <20210804184513.512888-1-ltykernel@gmail.com>
 <20210804184513.512888-11-ltykernel@gmail.com>
Message-ID: <fc36c85f-cc34-5ad2-8f9c-06dbe85ca165@gmail.com>
Date:   Thu, 5 Aug 2021 23:56:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804184513.512888-11-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:
      Could you have a look at this patch? It adds new API 
dma_map_decrypted() to do memory decrypted and remap. It will
be used in the swiotlb code.

Thanks.

On 8/5/2021 2:45 AM, Tianyu Lan wrote:
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
