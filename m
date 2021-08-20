Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83143F311F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhHTQIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhHTQHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:07:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00F5C0613D9;
        Fri, 20 Aug 2021 09:01:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so14132164pjr.1;
        Fri, 20 Aug 2021 09:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6hkf/wZhCtR6vOr1rFs7j4PHAMzvx+pV5RifX8vz64w=;
        b=ulVBu2T5KowwVfB0c+Pj7D1x6UX3lrEW4q5gi1uKDrhDSOEEvgFJc2iatc2+TtU876
         3YWisMvf4eMwCoOLCeYGsB+uOF346PhOTgb7zUh3Lb2nRH2KW0qeY+hbTn7tvtD1DnY9
         nXFdSFR98f4JZ8VDtEW33Rhy+blxF8OQ86t/6hll5TaD7Nx6ZojSMKSKhJ1hw75OGNdF
         5QNgQa+RekCcy2Frgo3cicRVsfzQQTPJ8j4hT1RZJLSBFG3QWfgIWg3k//uuKSre7T/2
         8VzMqDr1DEa04OHtgJG2gbhoc3+6h476DmYqCtJSetNKMXlb2f0pfPhwPy8bR4VO+w7L
         lnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6hkf/wZhCtR6vOr1rFs7j4PHAMzvx+pV5RifX8vz64w=;
        b=qykLPKE4fzfxLE7nItA8Iy2EGWC8VBFHGRVYo1dNiCrPp+1yt+WjAAZDOyI2E2ZCE4
         mhnEOxo/VG2r4NeGZiG18OD6AWIEmQryym5QPbjPkfU5pf6fJZTKZC8IMmwtADh8JJFx
         /JYhS+lQpporlZGIpdCbDM+cXCK0M0MN5z8GYdCplKRwwIPyWRMbyXE2bmF0yl92c5X0
         X16jjPyAJZnANB1X2f9PhhYPLSSSR771vbihCdZj9flUBlxSR1kESjzlhu0FqTkWO9j5
         MwSN6t5BX++zzpw21+a7foo0AS30MmHZ2nu1FJITtZt7kfh2I8Ey6JVIsgKWmCWbYQyd
         duYQ==
X-Gm-Message-State: AOAM531bNAy9E2mYxco+Xg29rr+qdH/jS4fX0dU4rRCRuiCC0HTRIuEe
        jiIIK1R9nmZ9qRiK4IIz2D4=
X-Google-Smtp-Source: ABdhPJwR1RVJYLKe/MVCnk4GrQZc0dmrh9f2+p51nJ6B5j1MzX30pZi4Z2P9kd3FIw+73ti2bZhlVQ==
X-Received: by 2002:a17:90a:c88:: with SMTP id v8mr5330712pja.197.1629475287515;
        Fri, 20 Aug 2021 09:01:27 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id d13sm7231479pfn.136.2021.08.20.09.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 09:01:27 -0700 (PDT)
Subject: Re: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for storvsc
 driver
To:     "hch@lst.de" <hch@lst.de>, Michael Kelley <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
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
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-14-ltykernel@gmail.com>
 <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210820043237.GC26450@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <011eb875-ced7-1e98-f09a-ee83699854e4@gmail.com>
Date:   Sat, 21 Aug 2021 00:01:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210820043237.GC26450@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/2021 12:32 PM, hch@lst.de wrote:
> On Thu, Aug 19, 2021 at 06:17:40PM +0000, Michael Kelley wrote:
>>> +#define storvsc_dma_map(dev, page, offset, size, dir) \
>>> +	dma_map_page(dev, page, offset, size, dir)
>>> +
>>> +#define storvsc_dma_unmap(dev, dma_range, dir)		\
>>> +		dma_unmap_page(dev, dma_range.dma,	\
>>> +			       dma_range.mapping_size,	\
>>> +			       dir ? DMA_FROM_DEVICE : DMA_TO_DEVICE)
>>> +
>>
>> Each of these macros is used only once.  IMHO, they don't
>> add a lot of value.  Just coding dma_map/unmap_page()
>> inline would be fine and eliminate these lines of code.
> 
> Yes, I had the same thought when looking over the code.  Especially
> as macros tend to further obsfucate the code (compared to actual helper
> functions).
> 
>>> +				for (i = 0; i < request->hvpg_count; i++)
>>> +					storvsc_dma_unmap(&device->device,
>>> +						request->dma_range[i],
>>> +						request->vstor_packet.vm_srb.data_in == READ_TYPE);
>>
>> I think you can directly get the DMA direction as request->cmd->sc_data_direction.
> 
> Yes.
> 
>>>
>>> @@ -1824,6 +1848,13 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>>>   		payload->range.len = length;
>>>   		payload->range.offset = offset_in_hvpg;
>>>
>>> +		cmd_request->dma_range = kcalloc(hvpg_count,
>>> +				 sizeof(*cmd_request->dma_range),
>>> +				 GFP_ATOMIC);
>>
>> With this patch, it appears that storvsc_queuecommand() is always
>> doing bounce buffering, even when running in a non-isolated VM.
>> The dma_range is always allocated, and the inner loop below does
>> the dma mapping for every I/O page.  The corresponding code in
>> storvsc_on_channel_callback() that does the dma unmap allows for
>> the dma_range to be NULL, but that never happens.
> 
> Maybe I'm missing something in the hyperv code, but I don't think
> dma_map_page would bounce buffer for the non-isolated case.  It
> will just return the physical address.

Yes, the swiotlb_force mode isn't enabled in non-isolated VM and so
dma_page_page() returns the physical address directly.

> 
>>> +		if (!cmd_request->dma_range) {
>>> +			ret = -ENOMEM;
>>
>> The other memory allocation failure in this function returns
>> SCSI_MLQUEUE_DEVICE_BUSY.   It may be debatable as to whether
>> that's the best approach, but that's a topic for a different patch.  I
>> would suggest being consistent and using the same return code
>> here.
> 
> Independent of if SCSI_MLQUEUE_DEVICE_BUSY is good (it it a common
> pattern in SCSI drivers), ->queuecommand can't return normal
> negative errnos.  It must return the SCSI_MLQUEUE_* codes or 0.
> We should probably change the return type of the method definition
> to a suitable enum to make this more clear.

Yes, will update. Thanks.

> 
>>> +				if (offset_in_hvpg) {
>>> +					payload->range.offset = dma & ~HV_HYP_PAGE_MASK;
>>> +					offset_in_hvpg = 0;
>>> +				}
>>
>> I'm not clear on why payload->range.offset needs to be set again.
>> Even after the dma mapping is done, doesn't the offset in the first
>> page have to be the same?  If it wasn't the same, Hyper-V wouldn't
>> be able to process the PFN list correctly.  In fact, couldn't the above
>> code just always set offset_in_hvpg = 0?
> 
> Careful.  DMA mapping is supposed to keep the offset in the page, but
> for that the DMA mapping code needs to know what the device considers a
> "page".  For that the driver needs to set the min_align_mask field in
> struct device_dma_parameters.

The default allocate unit of swiotlb bounce is IO_TLB_SIZE(2k).
Otherwise, I find some scsi request cmd's length is less than 100byte.
Keep a small unit can avoid wasting bounce buffer and just need to
update the offset.


> 
>>
>> The whole approach here is to do dma remapping on each individual page
>> of the I/O buffer.  But wouldn't it be possible to use dma_map_sg() to map
>> each scatterlist entry as a unit?  Each scatterlist entry describes a range of
>> physically contiguous memory.  After dma_map_sg(), the resulting dma
>> address must also refer to a physically contiguous range in the swiotlb
>> bounce buffer memory.   So at the top of the "for" loop over the scatterlist
>> entries, do dma_map_sg() if we're in an isolated VM.  Then compute the
>> hvpfn value based on the dma address instead of sg_page().  But everything
>> else is the same, and the inner loop for populating the pfn_arry is unmodified.
>> Furthermore, the dma_range array that you've added is not needed, since
>> scatterlist entries already have a dma_address field for saving the mapped
>> address, and dma_unmap_sg() uses that field.
> 
> Yes, I think dma_map_sg is the right thing to use here, probably even
> for the non-isolated case so that we can get the hv drivers out of their
> little corner and into being more like a normal kernel driver.  That
> is, use the scsi_dma_map/scsi_dma_unmap helpers, and then iterate over
> the dma addresses one page at a time using for_each_sg_dma_page.
> 

I wonder whether we may introduce a new API scsi_dma_map_with_callback. 
Caller provides a callback and run callback in sg loop of 
dma_direct_map_sg(). Caller need to update some data structure in the sg 
loop. Here is such case that driver needs to populate 
payload->range.pfn_array[]. This is why I don't use dma_map_sg() here.


>>
>> One thing:  There's a maximum swiotlb mapping size, which I think works
>> out to be 256 Kbytes.  See swiotlb_max_mapping_size().  We need to make
>> sure that we don't get a scatterlist entry bigger than this size.  But I think
>> this already happens because you set the device->dma_mask field in
>> Patch 11 of this series.  __scsi_init_queue checks for this setting and
>> sets max_sectors to limits transfers to the max mapping size.
> 
> Indeed.
> 
