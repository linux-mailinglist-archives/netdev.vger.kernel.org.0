Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41D63F2CE1
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbhHTNMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240444AbhHTNMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 09:12:09 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568A1C061575;
        Fri, 20 Aug 2021 06:11:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id x4so9113269pgh.1;
        Fri, 20 Aug 2021 06:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DumM/jSCQ5pQ9eZgFpU+0KewnSiWRI7kODNq3MVNO9E=;
        b=Lxpe8djYypSrG+rDhdI8Zj8XoAi8qqQia8zhwT4UV3xhiowgSs10jy3AgDNzKEDEyF
         2GuLbi9GVVFcjh9UlMDL9KUW8QrzZktPvIUcY7JQUGRvDt+fa7vHuxhyvZAdvey3t4ob
         hD12I6HXHDrZkRjMhWqSXBvFA8t0l/nORUqxhobI5jL9kGkFeKuaLFh4hExMg94Nn/+Y
         ZX0iJa6zVUQl4P3W+vN6fOmLG2tonMXiCheuMNI43YhxqI96dxD+FKqPHJQaTLtG54GP
         oe6y5RcUvG1ZNewnn9OX4H8s3Nmh0Ni6Kg3bG+ljwBTTlaL4sNTRBPgI879siMp4TQte
         F+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DumM/jSCQ5pQ9eZgFpU+0KewnSiWRI7kODNq3MVNO9E=;
        b=llyNHPpVpo3iir1cPeIivDcuTL3CoBNVeJ1trZDaZrDqn5wYbXJyGqVxUwHwg9JpOY
         5GrTRTcr1EeQTQujIPQXjip6HqrLCDYjCt+qYwUTSoU7K+85j2ji8gWfsbTxb4JBL5Qv
         t9H3vtHyHg7JzjFM5tlyPFnuSuhyFZHjJZKKLOotbRP0qD3WUNAojwwJBupw8jZFfzro
         +Wjl68Ompb4Dsb/i0/ju8ibMec6cAcWv0ESIjTJ00USAu2CyN2Mi4QqnwRUFnU/Mahxx
         fiWRuhWneVc5cG7B14Hm/5icG1Ht/ASra39JMRsIBk3qyvb0nRHrVbiz7mGIqksI+EYH
         rxsQ==
X-Gm-Message-State: AOAM533vlTcDF7wjP9dD1SWcb8U3JZLWmWjhRQIez0IDt/cNGGWOL36+
        FLJZ7+n6+zhJYwlJ8osFlGY=
X-Google-Smtp-Source: ABdhPJxylFQdwesAZv+5jXWctSOyZLpktCQebAX+HYEeyV7Dv3stIO/u8x8uQwcYBOXvuYmq81vLhg==
X-Received: by 2002:aa7:95a6:0:b0:3e0:efe2:83ee with SMTP id a6-20020aa795a6000000b003e0efe283eemr19334679pfk.36.1629465090875;
        Fri, 20 Aug 2021 06:11:30 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id z2sm8304603pgb.33.2021.08.20.06.11.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 06:11:30 -0700 (PDT)
Subject: Re: [PATCH V3 12/13] HV/Netvsc: Add Isolation VM support for netvsc
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
 <20210809175620.720923-13-ltykernel@gmail.com>
 <MWHPR21MB15936FE72E65A62FBA3EF4F2D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210820042151.GB26450@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <9e4d5de1-37b3-550d-9bca-4eb158e45b33@gmail.com>
Date:   Fri, 20 Aug 2021 21:11:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210820042151.GB26450@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/2021 12:21 PM, hch@lst.de wrote:
> On Thu, Aug 19, 2021 at 06:14:51PM +0000, Michael Kelley wrote:
>>> +	if (!pfns)
>>> +		return NULL;
>>> +
>>> +	for (i = 0; i < size / HV_HYP_PAGE_SIZE; i++)
>>> +		pfns[i] = virt_to_hvpfn(buf + i * HV_HYP_PAGE_SIZE)
>>> +			+ (ms_hyperv.shared_gpa_boundary >> HV_HYP_PAGE_SHIFT);
>>> +
>>> +	vaddr = vmap_pfn(pfns, size / HV_HYP_PAGE_SIZE, PAGE_KERNEL_IO);
>>> +	kfree(pfns);
>>> +
>>> +	return vaddr;
>>> +}
>>
>> This function appears to be a duplicate of hv_map_memory() in Patch 11 of this
>> series.  Is it possible to structure things so there is only one implementation?  In
> 
> So right now it it identical, but there is an important difference:
> the swiotlb memory is physically contiguous to start with, so we can
> do the simple remap using vmap_range as suggested in the last mail.
> The cases here are pretty weird in that netvsc_remap_buf is called right
> after vzalloc.  That is we create _two_ mappings in vmalloc space right
> after another, where the original one is just used for establishing the
> "GPADL handle" and freeing the memory.  In other words, the obvious thing
> to do here would be to use a vmalloc variant that allows to take the
> shared_gpa_boundary into account when setting up the PTEs.

The buffer is allocated via vmalloc(). It needs to be marked as host
visible via hyperv hvcall before being accessed via address space above
shared_gpa_boundary. The hvcall is called in the vmbus_establish_gpadl().

> 
> And here is somthing I need help from the x86 experts:  does the CPU
> actually care about this shared_gpa_boundary?  Or does it just matter
> for the generated DMA address?  Does somehow have a good pointer to
> how this mechanism works?
> 

The shared_gpa_boundary is vTOM feature of AMD SEV-SNP. Tom Lendacky
introduced the feature in previous mail. I copy it here and please have
a look.

 From Tom Lendacky:
IIUC, this is using the vTOM feature of SEV-SNP. When this feature is
enabled for a VMPL level, any physical memory addresses below vTOM are
considered private/encrypted and any physical memory addresses above vTOM
are considered shared/unencrypted. With this option, you don't need a
fully enlightened guest that sets and clears page table encryption bits.
You just need the DMA buffers to be allocated in the proper range above 
vTOM.

See the section on "Virtual Machine Privilege Levels" in
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf.
