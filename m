Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602E246761D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380357AbhLCLXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380358AbhLCLXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:23:42 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEEAC06173E;
        Fri,  3 Dec 2021 03:20:18 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k4so1866770plx.8;
        Fri, 03 Dec 2021 03:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7XsAJ2cZU1lppUyPBmVsEbXy/GKDAj/Ht+i8uHD7lok=;
        b=fQI0WyY3dvLwdv22bT+tWb115e4Q95jD6vrbYcmPVcwOyogr9umcIO0a/KZzkZF0rU
         qjv+YjbgPRKUi57eJSOspJ/nc9Xx0y6B+ShA6u79dQDpjAliXRhyzyFFhlcxT7Mkch1K
         q1Htr6xBNQmACCzFHpqEJQ4IFR5KLc5Up09f0yDbrMAL2dGNIoDCk2kVY9vf7H/OqfTF
         vj7WVjaYIRG9InmQYKKZoLEcnyr9fnCfLZMJ00mCUyXKJGM6wmAKtV6BkqeDbPJtqzHZ
         wVggDDSxJtPp+HclUV3H9xLVWitco7xUeWkf/kzzWR666KG5ZxHBXQifzIXarMd5G5hy
         YahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7XsAJ2cZU1lppUyPBmVsEbXy/GKDAj/Ht+i8uHD7lok=;
        b=MoY2sjpAMgyYkYKSyl3yTrmDha4s9ftXhU1G3vwTsPLx5CqephRZGkTxOeBcMa00Hw
         x/7TjGxpLH/vsUpAClAgDG0VbYb1ToTO+7yQ1+/0ykGNSOxPaEJXywKMnNZ9gkHWgNGB
         2c769oup5WeP09lET6ayHH6o6pPJvzN6S4qyGv8/wRy2v0B0PPk9s2MKXUTC8WFbBZzQ
         YHwGCeT+gmmIJZLI4AuuOpY8bdCmQX1j6LZYgBPdaCWC864oAQlc+bok2q8wofXduq3+
         +OJ7CLGfdD6kN9anQqdSzLPDfOp9rJyeo0XLpJnXYXcfaO8SR2br2fRuoGeqoHw6to7N
         oyVQ==
X-Gm-Message-State: AOAM53378jPICPHynxcaCHHo5EK8+5kH1DdhVZwJ9daWFoAXaTzAf4AR
        VFbSbOrUAin+FhaeabDvAq8Erol6TmpDvw==
X-Google-Smtp-Source: ABdhPJwyiDbpHGaLzHTehq+eMK96rnMASx0J/gnS2CYK1pGpGeM2FntwySwLQ6ehw5HLLx+8am9Xvw==
X-Received: by 2002:a17:90b:3447:: with SMTP id lj7mr13390043pjb.112.1638530418013;
        Fri, 03 Dec 2021 03:20:18 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id q32sm2126609pja.4.2021.12.03.03.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 03:20:17 -0800 (PST)
Message-ID: <e78ba239-2dad-d48f-671e-f76a943052f1@gmail.com>
Date:   Fri, 3 Dec 2021 19:20:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V3 1/5] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-2-ltykernel@gmail.com>
 <41bb0a87-9fdb-4c67-a903-9e87d092993a@amd.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <41bb0a87-9fdb-4c67-a903-9e87d092993a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2021 10:42 PM, Tom Lendacky wrote:
> On 12/1/21 10:02 AM, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
>> extra address space which is above shared_gpa_boundary (E.G 39 bit
>> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
>> physical address will be original physical address + shared_gpa_boundary.
>> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
>> memory(vTOM). Memory addresses below vTOM are automatically treated as
>> private while memory above vTOM is treated as shared.
>>
>> Expose swiotlb_unencrypted_base for platforms to set unencrypted
>> memory base offset and platform calls swiotlb_update_mem_attributes()
>> to remap swiotlb mem to unencrypted address space. memremap() can
>> not be called in the early stage and so put remapping code into
>> swiotlb_update_mem_attributes(). Store remap address and use it to copy
>> data from/to swiotlb bounce buffer.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> This patch results in the following stack trace during a bare-metal boot
> on my EPYC system with SME active (e.g. mem_encrypt=on):
> 
> [    0.123932] BUG: Bad page state in process swapper  pfn:108001
> [    0.123942] page:(____ptrval____) refcount:0 mapcount:-128 
> mapping:0000000000000000 index:0x0 pfn:0x108001
> [    0.123946] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
> [    0.123952] raw: 0017ffffc0000000 ffff88904f2d5e80 ffff88904f2d5e80 
> 0000000000000000
> [    0.123954] raw: 0000000000000000 0000000000000000 00000000ffffff7f 
> 0000000000000000
> [    0.123955] page dumped because: nonzero mapcount
> [    0.123957] Modules linked in:
> [    0.123961] CPU: 0 PID: 0 Comm: swapper Not tainted 
> 5.16.0-rc3-sos-custom #2
> [    0.123964] Hardware name: AMD Corporation
> [    0.123967] Call Trace:
> [    0.123971]  <TASK>
> [    0.123975]  dump_stack_lvl+0x48/0x5e
> [    0.123985]  bad_page.cold+0x65/0x96
> [    0.123990]  __free_pages_ok+0x3a8/0x410
> [    0.123996]  memblock_free_all+0x171/0x1dc
> [    0.124005]  mem_init+0x1f/0x14b
> [    0.124011]  start_kernel+0x3b5/0x6a1
> [    0.124016]  secondary_startup_64_no_verify+0xb0/0xbb
> [    0.124022]  </TASK>
> 
> I see ~40 of these traces, each for different pfns.
> 
> Thanks,
> Tom

Hi Tom:
       Thanks for your test. Could you help to test the following patch 
and check whether it can fix the issue.


diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 569272871375..f6c3638255d5 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
   * @end:       The end address of the swiotlb memory pool. Used to do 
a quick
   *             range check to see if the memory was in fact allocated 
by this
   *             API.
+ * @vaddr:     The vaddr of the swiotlb memory pool. The swiotlb memory 
pool
+ *             may be remapped in the memory encrypted case and store 
virtual
+ *             address for bounce buffer operation.
   * @nslabs:    The number of IO TLB blocks (in groups of 64) between 
@start and
   *             @end. For default swiotlb, this is command line 
adjustable via
   *             setup_io_tlb_npages.
@@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
  struct io_tlb_mem {
         phys_addr_t start;
         phys_addr_t end;
+       void *vaddr;
         unsigned long nslabs;
         unsigned long used;
         unsigned int index;
@@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct 
device *dev)
  }
  #endif /* CONFIG_DMA_RESTRICTED_POOL */

+extern phys_addr_t swiotlb_unencrypted_base;
+
  #endif /* __LINUX_SWIOTLB_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8e840fbbed7c..34e6ade4f73c 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -50,6 +50,7 @@
  #include <asm/io.h>
  #include <asm/dma.h>

+#include <linux/io.h>
  #include <linux/init.h>
  #include <linux/memblock.h>
  #include <linux/iommu-helper.h>
@@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;

  struct io_tlb_mem io_tlb_default_mem;

+phys_addr_t swiotlb_unencrypted_base;
+
  /*
   * Max segment that we can provide which (if pages are contingous) will
   * not be bounced (unless SWIOTLB_FORCE is set).
@@ -155,6 +158,27 @@ static inline unsigned long nr_slots(u64 val)
         return DIV_ROUND_UP(val, IO_TLB_SIZE);
  }

+/*
+ * Remap swioltb memory in the unencrypted physical address space
+ * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
+ * Isolation VMs).
+ */
+void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
+{
+       void *vaddr = NULL;
+
+       if (swiotlb_unencrypted_base) {
+               phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
+
+               vaddr = memremap(paddr, bytes, MEMREMAP_WB);
+               if (!vaddr)
+                       pr_err("Failed to map the unencrypted memory 
%llx size %lx.\n",
+                              paddr, bytes);
+       }
+
+       return vaddr;
+}
+
  /*
   * Early SWIOTLB allocation may be too early to allow an architecture to
   * perform the desired operations.  This function allows the 
architecture to
@@ -172,7 +196,12 @@ void __init swiotlb_update_mem_attributes(void)
         vaddr = phys_to_virt(mem->start);
         bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
         set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-       memset(vaddr, 0, bytes);
+
+       mem->vaddr = swiotlb_mem_remap(mem, bytes);
+       if (!mem->vaddr)
+               mem->vaddr = vaddr;
+
+       memset(mem->vaddr, 0, bytes);
  }

  static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, 
phys_addr_t start,
@@ -196,7 +225,17 @@ static void swiotlb_init_io_tlb_mem(struct 
io_tlb_mem *mem, phys_addr_t start,
                 mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
                 mem->slots[i].alloc_size = 0;
         }
+
+       /*
+        * If swiotlb_unencrypted_base is set, the bounce buffer memory will
+        * be remapped and cleared in swiotlb_update_mem_attributes.
+        */
+       if (swiotlb_unencrypted_base)
+               return;
+
         memset(vaddr, 0, bytes);
+       mem->vaddr = vaddr;
+       return;
  }

  int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int 
verbose)
@@ -371,7 +410,7 @@ static void swiotlb_bounce(struct device *dev, 
phys_addr_t tlb_addr, size_t size
         phys_addr_t orig_addr = mem->slots[index].orig_addr;
         size_t alloc_size = mem->slots[index].alloc_size;
         unsigned long pfn = PFN_DOWN(orig_addr);
-       unsigned char *vaddr = phys_to_virt(tlb_addr);
+       unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
         unsigned int tlb_offset, orig_addr_offset;

         if (orig_addr == INVALID_PHYS_ADDR)


Thanks.

