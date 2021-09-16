Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB240D807
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhIPK64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236506AbhIPK6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 06:58:55 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D45C061766;
        Thu, 16 Sep 2021 03:57:35 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so5780569pgc.6;
        Thu, 16 Sep 2021 03:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zetJ5G0LMyibhhBY6/35VWLw2vAGWh3kCNdD5BxkSZI=;
        b=Iq+3mvGj2jY0H1hK5L2+2LJkiT3nS6liFloV8Frq8+FJ3Y0LxB2A38VNCla7awjuhj
         Q3Cl5qmmvoV1YWOZQweI486bIgofq+t3jwjAQ3GGQ1BTx00wXTwDzZt3wO26vvMZXlEU
         Srw78VlxUG3ClRIenDB9DS9KklBz8Gy2Kt0AIAheRW83PteD9N403WMbpA39HXJuq8IF
         JiYUmg4zDGjeRBVLjEF25+aPcjKe8oOTUL3KuuMaaLo1G4aP3SLUOfZT+6b94AvHMe5Q
         tcf8/9xlWcz7WQzaFSNkMRaXjJszFIpx0K2ojEu+E4bzhBM/xSgQmOnlb5Oz/8Q8cN9d
         Qp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zetJ5G0LMyibhhBY6/35VWLw2vAGWh3kCNdD5BxkSZI=;
        b=br+0t4HTIaRXvbi/MyqqC1WP2c9YNEHk7+0kVyBddZW5IY4kVPvnRykS2XchYZFTow
         qpJAcHbbY2mjgE1kNSxkkyUsvyzXI2p2o7zMItlHSV6fjaEixx78O/fDlw5qIYg3IV3a
         Z8lGsY0KAL8b+46f70EiSW/s7nT8V2IkamszMzmFKAyrdLia8h+GEXqx9mmB5DwrZYdz
         wcWdaK3t0WGwQFMWnvXRq0KPOJZvWNkBu/FmFt+We/eiNFjVdtzpLTKksrA3YHNkBj1W
         KC0K+ztkHx8GVwAuGjwm+J7cW0+/WXSPKa0Qg4pLvCOESOy/P9PNynmUkr5ydIz9+9Qm
         MmvA==
X-Gm-Message-State: AOAM531g+Z5KNhWe+8bef32XQ6LZ/HAE9LelXkeroLV8YO/i4K7fuMIG
        m7+xHB72+j1ya69qE6fDwLA=
X-Google-Smtp-Source: ABdhPJyJnHqPNf+opjGA7LpPgHFY6nzsERWLwilu6XCHi7kaSPNw+MpELyJKztS12zzhPWoDpdap2Q==
X-Received: by 2002:aa7:959a:0:b0:43b:adeb:ef58 with SMTP id z26-20020aa7959a000000b0043badebef58mr4426857pfj.19.1631789854486;
        Thu, 16 Sep 2021 03:57:34 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id n141sm2856237pfd.90.2021.09.16.03.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 03:57:34 -0700 (PDT)
Subject: Re: [PATCH V5 09/12] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-10-ltykernel@gmail.com>
 <MWHPR21MB159349234C15D0F04F87845CD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <3f6a6407-b8fd-803b-e4fe-ea9a873a5840@gmail.com>
Date:   Thu, 16 Sep 2021 18:57:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB159349234C15D0F04F87845CD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/2021 11:42 PM, Michael Kelley wrote:
>> @@ -196,13 +199,34 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>>   		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
>>   		mem->slots[i].alloc_size = 0;
>>   	}
>> +
>> +	if (set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT))
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * Map memory in the unencrypted physical address space when requested
>> +	 * (e.g. for Hyper-V AMD SEV-SNP Isolation VMs).
>> +	 */
>> +	if (swiotlb_unencrypted_base) {
>> +		phys_addr_t paddr = __pa(vaddr) + swiotlb_unencrypted_base;
> Nit:  Use "start" instead of "__pa(vaddr)" since "start" is already the needed
> physical address.


Yes, "start" should be used here.

> 
>> @@ -304,7 +332,7 @@ int
>>   swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>>   {
>>   	struct io_tlb_mem *mem = &io_tlb_default_mem;
>> -	unsigned long bytes = nslabs << IO_TLB_SHIFT;
>> +	int ret;
>>
>>   	if (swiotlb_force == SWIOTLB_NO_FORCE)
>>   		return 0;
>> @@ -318,8 +346,9 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>>   	if (!mem->slots)
>>   		return -ENOMEM;
>>
>> -	set_memory_decrypted((unsigned long)tlb, bytes >> PAGE_SHIFT);
>> -	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
>> +	ret = swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
>> +	if (ret)
> Before returning the error, free the pages obtained from the earlier call
> to __get_free_pages()?
> 

Yes, will fix.

Thanks.
