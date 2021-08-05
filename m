Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216553E1903
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242870AbhHEQC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242864AbhHEQBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:01:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD7EC061765;
        Thu,  5 Aug 2021 09:01:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso6855772pjb.5;
        Thu, 05 Aug 2021 09:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WRaE9XH9PPGoXiSu1dW4fjpmpf14LbZ6tQkVM+U7n10=;
        b=GSFXT25Y8QFtHBJ7Qb7q4VAwsUY5K+kxxL51Vu7CUSo5Qr1zNOx1q3QBVMAXPj3OPQ
         nRzVQ/kqGDl0c3sX8BA4DeG6jz2z6/KdrVccWpUVxhYmIvAzsnIFt1YmISLVMXqFIu91
         dAtETqrNQzV7k0/ax431VOxHYRC135stzFHs6xKJXt0iHtd61HjXiMV+1RfNH9dz3DeD
         w9sm9eSvfkn60dEVJBG7O7kJfoVZgFZTqzV/wvTe5KFCplBsPqryD0Xx9PW7GhBoU1Mb
         kWugm3Jdhw3Swvy6AN/blHN6qhz7yNnjqVCRHrf0cSvt4KeuXGIyjoBEYwPv3aLNvNvX
         tRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WRaE9XH9PPGoXiSu1dW4fjpmpf14LbZ6tQkVM+U7n10=;
        b=DsOEzym+tbJtYzgVuS3XRH9LSjoLEqRWV+4h6aooOU5tC15fT9JlRfsEi8K2E3skcL
         zOpimKqmntkGv5qkRM840IVEOYfC1oFqEmRMgiubkhJ1XC66+CboamxqXunYQxbGrp/L
         FAkhTyApXwzGw5LPHzpF52bfjSGlHJu6wXrV3Tom/OnhmPEgAw3TWNSCoY9lt9TjYeDA
         z/bSk3fxrmuhNflNFVkLNURwxdaDf4MFp60mCuE5Y3bEw760V3TRfSyNv4gflWi7KBl3
         Ue02T5dsSP+Mg5dKOUtsu9IBYI4Vo4PnoHcxdecJEA/k3oMRJD4KKUh3VF6+1sb3NTgP
         CEYw==
X-Gm-Message-State: AOAM533lUbA85o6FjP1EIKjY4DHVv/C6mwPwhB/ah0XJcFZPCBjvE6hN
        NNes4MrvQeh2y63MJXsp+hQ=
X-Google-Smtp-Source: ABdhPJwoNGkEzz3DrJnTKb2SFzGjUTk2Tk5DdSuGsTxsp/IyxTQK1MeB89eXdy5AjPBJiBI0XRW7Ag==
X-Received: by 2002:a63:d458:: with SMTP id i24mr1081624pgj.289.1628179292003;
        Thu, 05 Aug 2021 09:01:32 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id gw4sm6494737pjb.1.2021.08.05.09.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 09:01:31 -0700 (PDT)
Subject: Re: [PATCH V2 11/14] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
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
 <20210804184513.512888-12-ltykernel@gmail.com>
Message-ID: <9b1815bd-9019-360f-f648-5c99211a3474@gmail.com>
Date:   Fri, 6 Aug 2021 00:01:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804184513.512888-12-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Konrad:
      Could you have a look at this new version? The change since v1 is 
make swiotlb_init_io_tlb_mem() return error code when 
dma_map_decrypted() fails according your previous comment. If this 
change is ok, could you give your ack and this series needs to be merged 
via Hyper-V next tree.

Thanks.

On 8/5/2021 2:45 AM, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
> extra address space which is above shared_gpa_boundary
> (E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
> The access physical address will be original physical address +
> shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
> spec is called virtual top of memory(vTOM). Memory addresses below
> vTOM are automatically treated as private while memory above
> vTOM is treated as shared.
> 
> Use dma_map_decrypted() in the swiotlb code, store remap address returned
> and use the remap address to copy data from/to swiotlb bounce buffer.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v1:
>         * Make swiotlb_init_io_tlb_mem() return error code and return
>           error when dma_map_decrypted() fails.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>   include/linux/swiotlb.h |  4 ++++
>   kernel/dma/swiotlb.c    | 32 ++++++++++++++++++++++++--------
>   2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index f507e3eacbea..584560ecaa8e 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -72,6 +72,9 @@ extern enum swiotlb_force swiotlb_force;
>    * @end:	The end address of the swiotlb memory pool. Used to do a quick
>    *		range check to see if the memory was in fact allocated by this
>    *		API.
> + * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb
> + *		memory pool may be remapped in the memory encrypted case and store
> + *		virtual address for bounce buffer operation.
>    * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start and
>    *		@end. For default swiotlb, this is command line adjustable via
>    *		setup_io_tlb_npages.
> @@ -89,6 +92,7 @@ extern enum swiotlb_force swiotlb_force;
>   struct io_tlb_mem {
>   	phys_addr_t start;
>   	phys_addr_t end;
> +	void *vaddr;
>   	unsigned long nslabs;
>   	unsigned long used;
>   	unsigned int index;
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 1fa81c096c1d..29b6d888ef3b 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -176,7 +176,7 @@ void __init swiotlb_update_mem_attributes(void)
>   	memset(vaddr, 0, bytes);
>   }
>   
> -static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
> +static int swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>   				    unsigned long nslabs, bool late_alloc)
>   {
>   	void *vaddr = phys_to_virt(start);
> @@ -194,14 +194,21 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>   		mem->slots[i].alloc_size = 0;
>   	}
>   
> -	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
> -	memset(vaddr, 0, bytes);
> +	mem->vaddr = dma_map_decrypted(vaddr, bytes);
> +	if (!mem->vaddr) {
> +		pr_err("Failed to decrypt memory.\n");
> +		return -ENOMEM;
> +	}
> +
> +	memset(mem->vaddr, 0, bytes);
> +	return 0;
>   }
>   
>   int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>   {
>   	struct io_tlb_mem *mem;
>   	size_t alloc_size;
> +	int ret;
>   
>   	if (swiotlb_force == SWIOTLB_NO_FORCE)
>   		return 0;
> @@ -216,7 +223,11 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>   		panic("%s: Failed to allocate %zu bytes align=0x%lx\n",
>   		      __func__, alloc_size, PAGE_SIZE);
>   
> -	swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
> +	ret = swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
> +	if (ret) {
> +		memblock_free(__pa(mem), alloc_size);
> +		return ret;
> +	}
>   
>   	io_tlb_default_mem = mem;
>   	if (verbose)
> @@ -304,6 +315,8 @@ int
>   swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>   {
>   	struct io_tlb_mem *mem;
> +	int size = get_order(struct_size(mem, slots, nslabs));
> +	int ret;
>   
>   	if (swiotlb_force == SWIOTLB_NO_FORCE)
>   		return 0;
> @@ -312,12 +325,15 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>   	if (WARN_ON_ONCE(io_tlb_default_mem))
>   		return -ENOMEM;
>   
> -	mem = (void *)__get_free_pages(GFP_KERNEL,
> -		get_order(struct_size(mem, slots, nslabs)));
> +	mem = (void *)__get_free_pages(GFP_KERNEL, size);
>   	if (!mem)
>   		return -ENOMEM;
>   
> -	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
> +	ret = swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
> +	if (ret) {
> +		free_pages((unsigned long)mem, size);
> +		return ret;
> +	}
>   
>   	io_tlb_default_mem = mem;
>   	swiotlb_print_info();
> @@ -360,7 +376,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
>   	phys_addr_t orig_addr = mem->slots[index].orig_addr;
>   	size_t alloc_size = mem->slots[index].alloc_size;
>   	unsigned long pfn = PFN_DOWN(orig_addr);
> -	unsigned char *vaddr = phys_to_virt(tlb_addr);
> +	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
>   	unsigned int tlb_offset;
>   
>   	if (orig_addr == INVALID_PHYS_ADDR)
> 
