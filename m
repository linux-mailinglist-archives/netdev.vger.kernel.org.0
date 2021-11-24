Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8C45C7AE
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353745AbhKXOoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352652AbhKXOoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:44:17 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E07BC21B32C;
        Wed, 24 Nov 2021 06:07:52 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id v19so1944287plo.7;
        Wed, 24 Nov 2021 06:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=syp/sAx1WBqbnIsfqrbBbnU7pLQsZBgXpQdqrXqrl38=;
        b=iecLeo1CCg8zt+sCXUOh364DhRhAV/Ar/v0CTPnIw92trVIyH4qvDLyLNdAiBMXH4T
         y+0BfWQ61+rOjIQbdKy9swqEYsMOae4eIFV1313ZNnDT1Lbv+aQO2IbYTdrbWOvmPEQu
         KlSl5yD8YP31w1z8kq/HaASDcSvcnIEnzDtL5YgUuswZfXpPxYfhz71mw789p88NP4MI
         rs74u4gMJh8nMwRq/chOwPKzLo9eH4bM7b5lm+1o85GlnoBeIlU+U2qG0z31u0KruJlF
         tO4ST89te9GQQvoWvoAHX2ms15JvNlQ1QJuyCl7nZWEUc1aTjDEBcKPhZNHdIMGNmbVg
         pbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=syp/sAx1WBqbnIsfqrbBbnU7pLQsZBgXpQdqrXqrl38=;
        b=Ag6Yl8hpV9brJYG+Mys3gb67IeSpKZDk3pOxtslLyxIffGTjrXq3Rrn6ufYq+DP/Nj
         CnVB1jq+vQ4E7Q+ZCijXcinR5fmqZQY/RFRbSgjsBinMorEKGHYbN1YFyZWfI3TeWSPL
         6R6C8jtV8nRmHsDHiHPBXN77u6u3T7VUQyBg7VAFmCR4KMo3tJSI9Z3/QtK31BhiX+Af
         vQg2X9TxYvScHPrOarOyrI+X0taQaaCiJkLGc3qdOIbGct/MLAcZhLi5oyUpttMtSN6n
         qm/n47eS93r75oS4lVHRMv6ttpl2bjNmA06u54RKeg4VP57Kzc09niCxDmI6Kk2mrhWL
         r+TA==
X-Gm-Message-State: AOAM531zn9W9BNZt9ywX1sao2mN/EEJPi4ZKcGwellsoPod2jrG6ov5W
        ZV8S0BP6K3EPbx+hiYwSIK3HeyVUUgUZ6g==
X-Google-Smtp-Source: ABdhPJxcvy1hEASS+ae7P9Zr40fMPVIge5ooMequB2zH2fg19BpSdiMXmZRAmprhgB5OLHpbaYCO2A==
X-Received: by 2002:a17:902:b581:b0:144:e601:de7 with SMTP id a1-20020a170902b58100b00144e6010de7mr19054433pls.71.1637762871786;
        Wed, 24 Nov 2021 06:07:51 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id g5sm4694513pjt.15.2021.11.24.06.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 06:07:51 -0800 (PST)
Message-ID: <887d57bc-8b1a-48ab-be72-17144791334a@gmail.com>
Date:   Wed, 24 Nov 2021 22:07:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH V2 1/6] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
References: <20211123143039.331929-1-ltykernel@gmail.com>
 <20211123143039.331929-2-ltykernel@gmail.com>
 <MWHPR21MB1593169593AD833A91DF553FD7609@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <MWHPR21MB1593169593AD833A91DF553FD7609@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael:
	Thanks for your review.

On 11/24/2021 1:15 AM, Michael Kelley (LINUX) wrote:
>> @@ -172,7 +200,14 @@ void __init swiotlb_update_mem_attributes(void)
>>   	vaddr = phys_to_virt(mem->start);
>>   	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
>>   	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
>> -	memset(vaddr, 0, bytes);
>> +
>> +	mem->vaddr = swiotlb_mem_remap(mem, bytes);
>> +	if (!mem->vaddr) {
>> +		pr_err("Fail to remap swiotlb mem.\n");
>> +		return;
>> +	}
>> +
>> +	memset(mem->vaddr, 0, bytes);
>>   }


> In the error case, do you want to leave mem->vaddr as NULL?  Or is it
> better to leave it as the virtual address of mem-start?  Your code leaves it
> as NULL.
> 
> The interaction between swiotlb_update_mem_attributes() and the helper
> function swiotlb_memo_remap() seems kind of clunky.  phys_to_virt() gets called
> twice, for example, and two error messages are printed.  The code would be
> more straightforward by just putting the helper function inline:
> 
> mem->vaddr = phys_to_virt(mem->start);
> bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
> set_memory_decrypted((unsigned long)(mem->vaddr), bytes >> PAGE_SHIFT);
> 
> if (swiotlb_unencrypted_base) {
> 	phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
> 
> 	mem->vaddr = memremap(paddr, bytes, MEMREMAP_WB);
> 	if (!mem->vaddr) {
> 		pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
> 			       paddr, bytes);
> 		return;
> 	}
> }
> 
> memset(mem->vaddr, 0, bytes);
> 
> (This version also leaves mem->vaddr as NULL in the error case.)

 From Christoph's previous suggestion, there should be a well-documented 
wrapper to explain the remap option and so I split the code. leaving the 
virtual address of mem-start is better.

https://lkml.org/lkml/2021/9/28/51

> 
>>   static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>> @@ -196,7 +231,18 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>>   		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
>>   		mem->slots[i].alloc_size = 0;
>>   	}
>> +
>> +	/*
>> +	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
>> +	 * be remapped and cleared in swiotlb_update_mem_attributes.
>> +	 */
>> +	if (swiotlb_unencrypted_base)
>> +		return;
>> +
>> +	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
> Prior to this patch, and here in the new version as well, the return value from
> set_memory_decrypted() is ignored in several places in this file.  As previously
> discussed, swiotlb_init_io_tlb_mem() is a void function, so there's no place to
> return an error. Is that OK?

Yes, the original code doesn't check the return value and so keep the 
rule。

Christoph, Could you help to check which way do you prefer?


