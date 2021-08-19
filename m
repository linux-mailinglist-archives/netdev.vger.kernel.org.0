Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3053F1595
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 10:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhHSIuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 04:50:35 -0400
Received: from verein.lst.de ([213.95.11.211]:36611 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhHSIud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 04:50:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9B4F767357; Thu, 19 Aug 2021 10:49:51 +0200 (CEST)
Date:   Thu, 19 Aug 2021 10:49:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, kys@microsoft.com,
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
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
Message-ID: <20210819084951.GA10461@lst.de>
References: <20210809175620.720923-1-ltykernel@gmail.com> <20210809175620.720923-11-ltykernel@gmail.com> <20210812122741.GC19050@lst.de> <d18ae061-6fc2-e69e-fc2c-2e1a1114c4b4@gmail.com> <890e5e21-714a-2db6-f68a-6211a69bebb9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <890e5e21-714a-2db6-f68a-6211a69bebb9@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 10:50:26PM +0800, Tianyu Lan wrote:
> Hi Christoph:
>       Sorry to bother you.Please double check with these two patches
> " [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function 
> for HV IVM" and "[PATCH V3 09/13] DMA: Add dma_map_decrypted/dma_
> unmap_encrypted() function".

Do you have a git tree somewhere to look at the whole tree?

>       The swiotlb bounce buffer in the isolation VM are allocated in the
> low end memory and these memory has struct page backing. All dma address
> returned by swiotlb/DMA API are low end memory and this is as same as what 
> happen in the traditional VM.

Indeed.

>       The API dma_map_decrypted() introduced in the patch 9 is to map the 
> bounce buffer in the extra space and these memory in the low end space are 
> used as DMA memory in the driver. Do you prefer these APIs
> still in the set_memory.c? I move the API to dma/mapping.c due to the
> suggested name arch_dma_map_decrypted() in the previous mail
> (https://lore.kernel.org/netdev/20210720135437.GA13554@lst.de/).

Well, what would help is a clear description of the semantics.
