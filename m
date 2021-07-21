Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD943D116A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbhGUNxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:53:25 -0400
Received: from verein.lst.de ([213.95.11.211]:58979 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232825AbhGUNxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 09:53:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 089B867373; Wed, 21 Jul 2021 16:33:56 +0200 (CEST)
Date:   Wed, 21 Jul 2021 16:33:55 +0200
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
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        rppt@kernel.org, Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        ardb@kernel.org, robh@kernel.org, nramas@linux.microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com, david@redhat.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, keescook@chromium.org,
        rientjes@google.com, hannes@cmpxchg.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        anparri@microsoft.com
Subject: Re: [Resend RFC PATCH V4 09/13] x86/Swiotlb/HV: Add Swiotlb bounce
 buffer remap function for HV IVM
Message-ID: <20210721143355.GA10848@lst.de>
References: <20210707154629.3977369-1-ltykernel@gmail.com> <20210707154629.3977369-10-ltykernel@gmail.com> <20210720135437.GA13554@lst.de> <8f1a285d-4b67-8041-d326-af565b2756c0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f1a285d-4b67-8041-d326-af565b2756c0@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 06:28:48PM +0800, Tianyu Lan wrote:
> dma_mmap_attrs() and dma_get_sgtable_attrs() get input virtual address
> belonging to backing memory with struct page and returns bounce buffer
> dma physical address which is below shared_gpa_boundary(vTOM) and passed
> to Hyper-V via vmbus protocol.
>
> The new map virtual address is only to access bounce buffer in swiotlb
> code and will not be used other places. It's stored in the mem->vstart.
> So the new API set_memory_decrypted_map() in this series is only called
> in the swiotlb code. Other platforms may replace set_memory_decrypted()
> with set_memory_decrypted_map() as requested.

It seems like you are indeed not using these new helpers in
dma_direct_alloc.  How is dma_alloc_attrs/dma_alloc_coherent going to
work on these systems?
