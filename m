Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054503FECDA
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 13:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbhIBLWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 07:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbhIBLWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 07:22:31 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D540C061757;
        Thu,  2 Sep 2021 04:21:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 8so1555916pga.7;
        Thu, 02 Sep 2021 04:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uvXbklsYzxIxtTfrV32ffa9Nuwizcf2v49dwd36P0II=;
        b=l3pHshNaH16SxCRdn9z7Xh25o4zr254bVE4gj2gcLe03eGaxqkakkGTJFxJqfTpw1V
         mgl7jhuQxVjIwW/UeX7ktsAfn4KtTM1QiXhueAKmpi1umldFhOhm/opbthWUVENXfmXz
         sByuEIse1tA9cQPTkGsfIdaE+UkFVQTBoS0K+F+XP4S1/PfM9AjDF1PXXeVM/2D0/+Wg
         GFVcsUwXqGqAsvdSyylORw5dpuBcJnKleE7Htyj6/Iy7J3TtLZUSPSx2JgomTUK9XCbK
         tkwtRAK0M+aqYoU4ijzQ2mRPYIgBubcVFek78cQ2L31j1R5JU4P5nO/87EvlyqPdofPx
         bNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uvXbklsYzxIxtTfrV32ffa9Nuwizcf2v49dwd36P0II=;
        b=WZbksE7b07f64CHLut5tSDP3DDRjRp+pMquyfQy+UYrd7OqldYY4IKA7ylQp618A6d
         3IveHo6rrEFSl91VTl4v3UioEiInylDC3TWCgEh+2BdJRz/0or7754Wo5G7w9ac147ZB
         X3sXpuVE5yym8MBYauOLmVpogSyivldv0PoEtrDyMPPdydpajvbu1XOou/mFQZw0NJS0
         kW+6UO4sBMx6gNhiOT+ZSbFZJ5bIPqos12M1jRCs6o5/1wdD6qdBVIN69syBwaKMmlVq
         6xQNTAIcRreM4BsGjllzMZFo9/TTiF6M7vZo3/qLiRksMsN61ioXh1aDLKC2LDkqGP+p
         Gi8A==
X-Gm-Message-State: AOAM533zE6OWbbn50yKRn0cL5IOQ601LbTCNmXE28ze4pFw0kpYCeLpF
        MNij6O0DmWafLbPZY+XPc+8=
X-Google-Smtp-Source: ABdhPJxldFu1U8M2V5yK1yTHMDs9K9anELSSV02bNY0qtLdwF/4+Etf8R4JVmeL3O1gUAcLcNnmdKQ==
X-Received: by 2002:a63:5b08:: with SMTP id p8mr2815838pgb.28.1630581692705;
        Thu, 02 Sep 2021 04:21:32 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id j6sm2394666pgq.0.2021.09.02.04.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 04:21:32 -0700 (PDT)
Subject: Re: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
To:     Christoph Hellwig <hch@lst.de>,
        Michael Kelley <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
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
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210830120036.GA22005@lst.de>
 <MWHPR21MB15933503E7C324167CB4132CD7CC9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210902075939.GB14986@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <dc124c3d-a316-d36e-3ae4-21674280f55d@gmail.com>
Date:   Thu, 2 Sep 2021 19:21:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210902075939.GB14986@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2021 3:59 PM, Christoph Hellwig wrote:
> On Tue, Aug 31, 2021 at 05:16:19PM +0000, Michael Kelley wrote:
>> As a quick overview, I think there are four places where the
>> shared_gpa_boundary must be applied to adjust the guest physical
>> address that is used.  Each requires mapping a corresponding
>> virtual address range.  Here are the four places:
>>
>> 1)  The so-called "monitor pages" that are a core communication
>> mechanism between the guest and Hyper-V.  These are two single
>> pages, and the mapping is handled by calling memremap() for
>> each of the two pages.  See Patch 7 of Tianyu's series.
> 
> Ah, interesting.
> 
>> 3)  The network driver send and receive buffers.  vmap_phys_range()
>> should work here.
> 
> Actually it won't.  The problem with these buffers is that they are
> physically non-contiguous allocations.  We really have two sensible
> options:
> 
>   1) use vmap_pfn as in the current series.  But in that case I think
>      we should get rid of the other mapping created by vmalloc.  I
>      though a bit about finding a way to apply the offset in vmalloc
>      itself, but I think it would be too invasive to the normal fast
>      path.  So the other sub-option would be to allocate the pages
>      manually (maybe even using high order allocations to reduce TLB
>      pressure) and then remap them

Agree. In such case, the map for memory below shared_gpa_boundary is not 
necessary. allocate_pages() is limited by MAX_ORDER and needs to be 
called repeatedly to get enough memory.

>   2) do away with the contiguous kernel mapping entirely.  This means
>      the simple memcpy calls become loops over kmap_local_pfn.  As
>      I just found out for the send side that would be pretty easy,
>      but the receive side would be more work.  We'd also need to check
>      the performance implications.

kmap_local_pfn() requires pfn with backing struct page and this doesn't 
work pfn above shared_gpa_boundary.
> 
>> 4) The swiotlb memory used for bounce buffers.  vmap_phys_range()
>> should work here as well.
> 
> Or memremap if it works for 1.

Now use vmap_pfn() and the hv map function is reused in the netvsc driver.

> 
>> Case #2 above does unusual mapping.  The ring buffer consists of a ring
>> buffer header page, followed by one or more pages that are the actual
>> ring buffer.  The pages making up the actual ring buffer are mapped
>> twice in succession.  For example, if the ring buffer has 4 pages
>> (one header page and three ring buffer pages), the contiguous
>> virtual mapping must cover these seven pages:  0, 1, 2, 3, 1, 2, 3.
>> The duplicate contiguous mapping allows the code that is reading
>> or writing the actual ring buffer to not be concerned about wrap-around
>> because writing off the end of the ring buffer is automatically
>> wrapped-around by the mapping.  The amount of data read or
>> written in one batch never exceeds the size of the ring buffer, and
>> after a batch is read or written, the read or write indices are adjusted
>> to put them back into the range of the first mapping of the actual
>> ring buffer pages.  So there's method to the madness, and the
>> technique works pretty well.  But this kind of mapping is not
>> amenable to using vmap_phys_range().
> 
> Hmm.  Can you point me to where this is mapped?  Especially for the
> classic non-isolated case where no vmap/vmalloc mapping is involved
> at all?
> 

This is done via vmap() in the hv_ringbuffer_init()

182/* Initialize the ring buffer. */
183int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
184                       struct page *pages, u32 page_cnt, u32 
max_pkt_size)
185{
186        int i;
187        struct page **pages_wraparound;
188
189        BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
190
191        /*
192         * First page holds struct hv_ring_buffer, do wraparound 
mapping for
193         * the rest.
194         */
195        pages_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(struct 
page *),
196                                   GFP_KERNEL);
197        if (!pages_wraparound)
198                return -ENOMEM;
199
/* prepare to wrap page array */
200        pages_wraparound[0] = pages;
201        for (i = 0; i < 2 * (page_cnt - 1); i++)
202                pages_wraparound[i + 1] = &pages[i % (page_cnt - 1) + 1];
203
/* map */
204        ring_info->ring_buffer = (struct hv_ring_buffer *)
205                vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, 
PAGE_KERNEL);
206
207        kfree(pages_wraparound);
208
209
210        if (!ring_info->ring_buffer)
211                return -ENOMEM;
212
213        ring_info->ring_buffer->read_index =
214                ring_info->ring_buffer->write_index = 0;


