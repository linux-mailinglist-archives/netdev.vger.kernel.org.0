Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB103FEA50
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 09:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhIBIAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 04:00:48 -0400
Received: from verein.lst.de ([213.95.11.211]:50414 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233362AbhIBIAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 04:00:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4E9586736F; Thu,  2 Sep 2021 09:59:39 +0200 (CEST)
Date:   Thu, 2 Sep 2021 09:59:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Christoph Hellwig <hch@lst.de>, Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: Re: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Message-ID: <20210902075939.GB14986@lst.de>
References: <20210827172114.414281-1-ltykernel@gmail.com> <20210830120036.GA22005@lst.de> <MWHPR21MB15933503E7C324167CB4132CD7CC9@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR21MB15933503E7C324167CB4132CD7CC9@MWHPR21MB1593.namprd21.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 05:16:19PM +0000, Michael Kelley wrote:
> As a quick overview, I think there are four places where the
> shared_gpa_boundary must be applied to adjust the guest physical
> address that is used.  Each requires mapping a corresponding
> virtual address range.  Here are the four places:
> 
> 1)  The so-called "monitor pages" that are a core communication
> mechanism between the guest and Hyper-V.  These are two single
> pages, and the mapping is handled by calling memremap() for
> each of the two pages.  See Patch 7 of Tianyu's series.

Ah, interesting.

> 3)  The network driver send and receive buffers.  vmap_phys_range()
> should work here.

Actually it won't.  The problem with these buffers is that they are
physically non-contiguous allocations.  We really have two sensible
options:

 1) use vmap_pfn as in the current series.  But in that case I think
    we should get rid of the other mapping created by vmalloc.  I
    though a bit about finding a way to apply the offset in vmalloc
    itself, but I think it would be too invasive to the normal fast
    path.  So the other sub-option would be to allocate the pages
    manually (maybe even using high order allocations to reduce TLB
    pressure) and then remap them
 2) do away with the contiguous kernel mapping entirely.  This means
    the simple memcpy calls become loops over kmap_local_pfn.  As
    I just found out for the send side that would be pretty easy,
    but the receive side would be more work.  We'd also need to check
    the performance implications.

> 4) The swiotlb memory used for bounce buffers.  vmap_phys_range()
> should work here as well.

Or memremap if it works for 1.

> Case #2 above does unusual mapping.  The ring buffer consists of a ring
> buffer header page, followed by one or more pages that are the actual
> ring buffer.  The pages making up the actual ring buffer are mapped
> twice in succession.  For example, if the ring buffer has 4 pages
> (one header page and three ring buffer pages), the contiguous
> virtual mapping must cover these seven pages:  0, 1, 2, 3, 1, 2, 3.
> The duplicate contiguous mapping allows the code that is reading
> or writing the actual ring buffer to not be concerned about wrap-around
> because writing off the end of the ring buffer is automatically
> wrapped-around by the mapping.  The amount of data read or
> written in one batch never exceeds the size of the ring buffer, and
> after a batch is read or written, the read or write indices are adjusted
> to put them back into the range of the first mapping of the actual
> ring buffer pages.  So there's method to the madness, and the
> technique works pretty well.  But this kind of mapping is not
> amenable to using vmap_phys_range().

Hmm.  Can you point me to where this is mapped?  Especially for the
classic non-isolated case where no vmap/vmalloc mapping is involved
at all?
