Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A1A3F2938
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 11:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhHTJdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 05:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbhHTJdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 05:33:12 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E138C061575;
        Fri, 20 Aug 2021 02:32:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o2so8571522pgr.9;
        Fri, 20 Aug 2021 02:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/INelQk2As+/GtcCaMtJ+YzY5fXWvqQ9IG9ehmEJG8=;
        b=NOsRg08JE9vqoPHWkIYlLgvhL+MicNH2byE8RBT270hR7Y34lewYGmzCG7ZiSOPfst
         hHwY77aZbHyaZy74ak1zDkDcJThEyYHT+phdATRZfrBFvdCFxZDPgNsT5HA2ACIGOssj
         5flQeCaYSnsS7x235BGVvDlZVJfoVF2viLSRLpv9bgZw/C28yjBIhSKVFmgAWxO0RwLs
         SqRSs/9c3L856W6LO84v1LhAxpS7IpBUWCu4vR1ZWSmuRYMsAqASRYQzmnl0WEeB+EGQ
         v8cJErq4KMIgeGnBvkCcPfJfi85pvA0P+J4N0lc0Qhk1awxXio8YvgLwIqm9BpqqWqJj
         KSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/INelQk2As+/GtcCaMtJ+YzY5fXWvqQ9IG9ehmEJG8=;
        b=rMtsF+QGUp5drnz5DEzx92ESwG2lVeehtmHgXgebbn9DWpKd10X1hVLAetRbdR831K
         7F/8E6cLz88oDH+DjKGSyuhDc+9MppljHQQhMgASwRdtSjxdaYJ3EiKoKPyZDXs58lGg
         rhhSZJE1+Ve8TDPp3xPAfwG4g+Ho7Hp0vK8LRtXnMGeFpxoC40wQwVIo8bP86x9zMAou
         4X5TPFPrmuyVSJnMjD8dUjLQb3kuhdaNqlGzlRH3hE6pUOao5lOAQv4IYfyLzOkc8Gsh
         IV0dNxG9Hyh5WmB2EI8C+GvcOgpMkEw0+yd0wh9y0bUuKnBGDGEKw95GJsehI84urXs7
         mtOg==
X-Gm-Message-State: AOAM532IL8cvcpm73pASbWfQURLATeNMESX/FjpoJml+CHBp1N5Khav4
        wBWq2g5P7X5zoNgJhMN4lXY=
X-Google-Smtp-Source: ABdhPJyMzC9zZ4t/lY/N9LWV+o+9MRA4tnKQgAYkkUeEh5Y8L6QkAwqXlqjG86qeQ0htTXLK/F9JXQ==
X-Received: by 2002:a63:1a46:: with SMTP id a6mr17708253pgm.226.1629451955046;
        Fri, 20 Aug 2021 02:32:35 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id x42sm6108890pfh.205.2021.08.20.02.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 02:32:34 -0700 (PDT)
Subject: Re: [PATCH V3 11/13] HV/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
To:     Michael Kelley <mikelley@microsoft.com>,
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
        "tj@kernel.org" <tj@kernel.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-12-ltykernel@gmail.com>
 <MWHPR21MB159315B335EB0B064B0B0F23D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <e933f7e3-5573-bb8a-c313-75884d59235c@gmail.com>
Date:   Fri, 20 Aug 2021 17:32:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB159315B335EB0B064B0B0F23D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/2021 2:11 AM, Michael Kelley wrote:
>>   }
>> +
>> +/*
>> + * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
>> + */
>> +void *hv_map_memory(void *addr, unsigned long size)
>> +{
>> +	unsigned long *pfns = kcalloc(size / HV_HYP_PAGE_SIZE,
>> +				      sizeof(unsigned long), GFP_KERNEL);
>> +	void *vaddr;
>> +	int i;
>> +
>> +	if (!pfns)
>> +		return NULL;
>> +
>> +	for (i = 0; i < size / HV_HYP_PAGE_SIZE; i++)
>> +		pfns[i] = virt_to_hvpfn(addr + i * HV_HYP_PAGE_SIZE) +
>> +			(ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
>> +
>> +	vaddr = vmap_pfn(pfns, size / HV_HYP_PAGE_SIZE,	PAGE_KERNEL_IO);
>> +	kfree(pfns);
>> +
>> +	return vaddr;
>> +}
> This function is manipulating page tables in the guest VM.  It is not involved
> in communicating with Hyper-V, or passing PFNs to Hyper-V.  The pfn array
> contains guest PFNs, not Hyper-V PFNs.  So it should use PAGE_SIZE
> instead of HV_HYP_PAGE_SIZE, and similarly PAGE_SHIFT and virt_to_pfn().
> If this code were ever to run on ARM64 in the future with PAGE_SIZE other
> than 4 Kbytes, the use of PAGE_SIZE is correct choice.

OK. Will update with PAGE_SIZE.


> 
>> +void __init hyperv_iommu_swiotlb_init(void)
>> +{
>> +	unsigned long bytes;
>> +
>> +	/*
>> +	 * Allocate Hyper-V swiotlb bounce buffer at early place
>> +	 * to reserve large contiguous memory.
>> +	 */
>> +	hyperv_io_tlb_size = 256 * 1024 * 1024;
> A hard coded size here seems problematic.   The memory size of
> Isolated VMs can vary by orders of magnitude.  I see that
> xen_swiotlb_init() uses swiotlb_size_or_default(), which at least
> pays attention to the value specified on the kernel boot line.
> 
> Another example is sev_setup_arch(), which in the native case sets
> the size to 6% of main memory, with a max of 1 Gbyte.  This is
> the case that's closer to Isolated VMs, so doing something
> similar could be a good approach.
> 

Yes, agree. It's better to keep bounce buffer size with AMD SEV.
