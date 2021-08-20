Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E064B3F25E6
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhHTEdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:33:22 -0400
Received: from verein.lst.de ([213.95.11.211]:39666 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhHTEdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:33:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0B8C66736F; Fri, 20 Aug 2021 06:32:38 +0200 (CEST)
Date:   Fri, 20 Aug 2021 06:32:37 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
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
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: Re: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for
 storvsc driver
Message-ID: <20210820043237.GC26450@lst.de>
References: <20210809175620.720923-1-ltykernel@gmail.com> <20210809175620.720923-14-ltykernel@gmail.com> <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 06:17:40PM +0000, Michael Kelley wrote:
> > +#define storvsc_dma_map(dev, page, offset, size, dir) \
> > +	dma_map_page(dev, page, offset, size, dir)
> > +
> > +#define storvsc_dma_unmap(dev, dma_range, dir)		\
> > +		dma_unmap_page(dev, dma_range.dma,	\
> > +			       dma_range.mapping_size,	\
> > +			       dir ? DMA_FROM_DEVICE : DMA_TO_DEVICE)
> > +
> 
> Each of these macros is used only once.  IMHO, they don't
> add a lot of value.  Just coding dma_map/unmap_page()
> inline would be fine and eliminate these lines of code.

Yes, I had the same thought when looking over the code.  Especially
as macros tend to further obsfucate the code (compared to actual helper
functions).

> > +				for (i = 0; i < request->hvpg_count; i++)
> > +					storvsc_dma_unmap(&device->device,
> > +						request->dma_range[i],
> > +						request->vstor_packet.vm_srb.data_in == READ_TYPE);
> 
> I think you can directly get the DMA direction as request->cmd->sc_data_direction.

Yes.

> > 
> > @@ -1824,6 +1848,13 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
> >  		payload->range.len = length;
> >  		payload->range.offset = offset_in_hvpg;
> > 
> > +		cmd_request->dma_range = kcalloc(hvpg_count,
> > +				 sizeof(*cmd_request->dma_range),
> > +				 GFP_ATOMIC);
> 
> With this patch, it appears that storvsc_queuecommand() is always
> doing bounce buffering, even when running in a non-isolated VM.
> The dma_range is always allocated, and the inner loop below does
> the dma mapping for every I/O page.  The corresponding code in
> storvsc_on_channel_callback() that does the dma unmap allows for
> the dma_range to be NULL, but that never happens.

Maybe I'm missing something in the hyperv code, but I don't think
dma_map_page would bounce buffer for the non-isolated case.  It
will just return the physical address.

> > +		if (!cmd_request->dma_range) {
> > +			ret = -ENOMEM;
> 
> The other memory allocation failure in this function returns
> SCSI_MLQUEUE_DEVICE_BUSY.   It may be debatable as to whether
> that's the best approach, but that's a topic for a different patch.  I
> would suggest being consistent and using the same return code
> here.

Independent of if SCSI_MLQUEUE_DEVICE_BUSY is good (it it a common
pattern in SCSI drivers), ->queuecommand can't return normal
negative errnos.  It must return the SCSI_MLQUEUE_* codes or 0.
We should probably change the return type of the method definition
to a suitable enum to make this more clear.

> > +				if (offset_in_hvpg) {
> > +					payload->range.offset = dma & ~HV_HYP_PAGE_MASK;
> > +					offset_in_hvpg = 0;
> > +				}
> 
> I'm not clear on why payload->range.offset needs to be set again.
> Even after the dma mapping is done, doesn't the offset in the first
> page have to be the same?  If it wasn't the same, Hyper-V wouldn't
> be able to process the PFN list correctly.  In fact, couldn't the above
> code just always set offset_in_hvpg = 0?

Careful.  DMA mapping is supposed to keep the offset in the page, but
for that the DMA mapping code needs to know what the device considers a
"page".  For that the driver needs to set the min_align_mask field in
struct device_dma_parameters.

> 
> The whole approach here is to do dma remapping on each individual page
> of the I/O buffer.  But wouldn't it be possible to use dma_map_sg() to map
> each scatterlist entry as a unit?  Each scatterlist entry describes a range of
> physically contiguous memory.  After dma_map_sg(), the resulting dma
> address must also refer to a physically contiguous range in the swiotlb
> bounce buffer memory.   So at the top of the "for" loop over the scatterlist
> entries, do dma_map_sg() if we're in an isolated VM.  Then compute the
> hvpfn value based on the dma address instead of sg_page().  But everything
> else is the same, and the inner loop for populating the pfn_arry is unmodified.
> Furthermore, the dma_range array that you've added is not needed, since
> scatterlist entries already have a dma_address field for saving the mapped
> address, and dma_unmap_sg() uses that field.

Yes, I think dma_map_sg is the right thing to use here, probably even
for the non-isolated case so that we can get the hv drivers out of their
little corner and into being more like a normal kernel driver.  That
is, use the scsi_dma_map/scsi_dma_unmap helpers, and then iterate over
the dma addresses one page at a time using for_each_sg_dma_page.

> 
> One thing:  There's a maximum swiotlb mapping size, which I think works
> out to be 256 Kbytes.  See swiotlb_max_mapping_size().  We need to make
> sure that we don't get a scatterlist entry bigger than this size.  But I think
> this already happens because you set the device->dma_mask field in
> Patch 11 of this series.  __scsi_init_queue checks for this setting and
> sets max_sectors to limits transfers to the max mapping size.

Indeed.
