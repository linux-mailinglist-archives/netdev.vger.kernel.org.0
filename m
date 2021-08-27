Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3EC3F9DEF
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbhH0RXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245472AbhH0RWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:22:36 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF1EC0613D9;
        Fri, 27 Aug 2021 10:21:47 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y11so6214831pfl.13;
        Fri, 27 Aug 2021 10:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6MHi30R96t1tpcfv0VvlaJ3ckWN83uvRHnkjJOo1l30=;
        b=MOcte0DoDafRZO8ZtX2XcPp/LXoS4Y8Uc+1YFSueU47Od7ILMltiJ+jU/PD2Bem9A6
         egV3QwhmmbWOrrE4pRxAPThWOWuRWBYL/V8suAXt/TOwDWJD5Txw1Ztj7UcKPNgn7b3S
         64Dl/WlPUEwgmW/EQJOhf0kinfHFaEga3IVGbbzchLUVdnE4z7oulTK6s2gwUajS0jMO
         XCFXLk3TKwWljw55q7xE/CphXl0QiV/ldYVD2VzyXCnfh4Wlnba38D0RScL2guLBekg5
         uuxnrzN988dSfELcvZBQj1oVLuif1sO8N9ozD7WDA31KjxT6WFD2rY7fqC29VP5ApsxF
         E/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6MHi30R96t1tpcfv0VvlaJ3ckWN83uvRHnkjJOo1l30=;
        b=LaZTt4+NFu6AcwKwCe/Xf1gI5/VhNB/T2GXW1HhOhD5M/wBFubA4E1hd0fnVXsVXKP
         JUSBnSyWP/+NvNPcgbn603w8xjJNdD4I4AIf6zwJIJOtozOEt+JhgadUc+slBP6QFomU
         WL9kKl8EkYpnPLzGrBtNljMtHcICCE+DHfWYgAvnLlOH48vEyDeS3kjn0dejBeKSD75s
         y01o7DHaNcLWlcRr5hVkuablqW9KnslpmnFrh38AL3BfiDXjn1hin4iwaBuX1ECZRSS0
         roH2OQfmGiWX7FJf703OQgCX/j2M1yYCIeQ7uvjw4Zle5fh/5lvezM84uySvZiij7YY9
         Zmig==
X-Gm-Message-State: AOAM530NRDnBaaf2Ec7Dhehj9hjpaSxIqsaume2b+Y/bMEKRmDoZaisG
        ORISKf5cVHd7M7wvTF6Bq9w=
X-Google-Smtp-Source: ABdhPJzQcZQUCwo3EVIginZLbkS0j6tpa+TKdpTpirJZ9GqPVodAIhLCJiwv8MK3x0NUITnBw1JqCw==
X-Received: by 2002:a63:534f:: with SMTP id t15mr8821683pgl.392.1630084906877;
        Fri, 27 Aug 2021 10:21:46 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:ef50:8fcd:44d1:eb17])
        by smtp.gmail.com with ESMTPSA id f5sm7155015pjo.23.2021.08.27.10.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:21:46 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
Date:   Fri, 27 Aug 2021 13:21:08 -0400
Message-Id: <20210827172114.414281-11-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827172114.414281-1-ltykernel@gmail.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
extra address space which is above shared_gpa_boundary
(E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
The access physical address will be original physical address +
shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
spec is called virtual top of memory(vTOM). Memory addresses below
vTOM are automatically treated as private while memory above
vTOM is treated as shared.

Use dma_map_decrypted() in the swiotlb code, store remap address returned
and use the remap address to copy data from/to swiotlb bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v1:
       * Make swiotlb_init_io_tlb_mem() return error code and return
         error when dma_map_decrypted() fails.
---
 include/linux/swiotlb.h |  4 ++++
 kernel/dma/swiotlb.c    | 32 ++++++++++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index f507e3eacbea..584560ecaa8e 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -72,6 +72,9 @@ extern enum swiotlb_force swiotlb_force;
  * @end:	The end address of the swiotlb memory pool. Used to do a quick
  *		range check to see if the memory was in fact allocated by this
  *		API.
+ * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb
+ *		memory pool may be remapped in the memory encrypted case and store
+ *		virtual address for bounce buffer operation.
  * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start and
  *		@end. For default swiotlb, this is command line adjustable via
  *		setup_io_tlb_npages.
@@ -89,6 +92,7 @@ extern enum swiotlb_force swiotlb_force;
 struct io_tlb_mem {
 	phys_addr_t start;
 	phys_addr_t end;
+	void *vaddr;
 	unsigned long nslabs;
 	unsigned long used;
 	unsigned int index;
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 1fa81c096c1d..29b6d888ef3b 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -176,7 +176,7 @@ void __init swiotlb_update_mem_attributes(void)
 	memset(vaddr, 0, bytes);
 }
 
-static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
+static int swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 				    unsigned long nslabs, bool late_alloc)
 {
 	void *vaddr = phys_to_virt(start);
@@ -194,14 +194,21 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].alloc_size = 0;
 	}
 
-	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-	memset(vaddr, 0, bytes);
+	mem->vaddr = dma_map_decrypted(vaddr, bytes);
+	if (!mem->vaddr) {
+		pr_err("Failed to decrypt memory.\n");
+		return -ENOMEM;
+	}
+
+	memset(mem->vaddr, 0, bytes);
+	return 0;
 }
 
 int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 {
 	struct io_tlb_mem *mem;
 	size_t alloc_size;
+	int ret;
 
 	if (swiotlb_force == SWIOTLB_NO_FORCE)
 		return 0;
@@ -216,7 +223,11 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 		panic("%s: Failed to allocate %zu bytes align=0x%lx\n",
 		      __func__, alloc_size, PAGE_SIZE);
 
-	swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
+	ret = swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
+	if (ret) {
+		memblock_free(__pa(mem), alloc_size);
+		return ret;
+	}
 
 	io_tlb_default_mem = mem;
 	if (verbose)
@@ -304,6 +315,8 @@ int
 swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 {
 	struct io_tlb_mem *mem;
+	int size = get_order(struct_size(mem, slots, nslabs));
+	int ret;
 
 	if (swiotlb_force == SWIOTLB_NO_FORCE)
 		return 0;
@@ -312,12 +325,15 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	if (WARN_ON_ONCE(io_tlb_default_mem))
 		return -ENOMEM;
 
-	mem = (void *)__get_free_pages(GFP_KERNEL,
-		get_order(struct_size(mem, slots, nslabs)));
+	mem = (void *)__get_free_pages(GFP_KERNEL, size);
 	if (!mem)
 		return -ENOMEM;
 
-	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
+	ret = swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
+	if (ret) {
+		free_pages((unsigned long)mem, size);
+		return ret;
+	}
 
 	io_tlb_default_mem = mem;
 	swiotlb_print_info();
@@ -360,7 +376,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
-	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
-- 
2.25.1

