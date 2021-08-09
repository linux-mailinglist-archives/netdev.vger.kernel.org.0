Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFAC3E4B96
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhHIR5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbhHIR5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:57:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB55C061799;
        Mon,  9 Aug 2021 10:56:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so46358pjn.4;
        Mon, 09 Aug 2021 10:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6MHi30R96t1tpcfv0VvlaJ3ckWN83uvRHnkjJOo1l30=;
        b=f2d7PoNR8S7BEFglYtlqZtTOq+7/Zs/CVzt8i5RvVJDSFyxSwvYW1cOzneFqHOp8lD
         YMayERjWFFRhQeM38VR0PnUgeZ4+MajNuTyUjodTxOjIuzEiz+L+TWPs2rA8SMr1Ves2
         yOXnyzfpVfIywNSDtsAM8unnE5zMtaNsA4EvH6Y2v9ClOXNrj9xcmYJgXlAuLbm1bK5w
         FLQDvym+rVXEDkiCLuW7wIcGd8BSk3ksYaG10QtZ6PF40JGfna+XstaK9mwW6X+rF7wQ
         r9Jmq1n1T1qx8fU02X6Mw1Fol3fZN+g8Y5pzN1daGR8DFMGa+fGiIrtwkT/EtwugpgeD
         85AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6MHi30R96t1tpcfv0VvlaJ3ckWN83uvRHnkjJOo1l30=;
        b=OIZuPZZfUhFMIMgAyRNfwKn//qP2v0QDyQQsuFYx5mxmtKG80t2hJBLa7pRniBgE5t
         X/jTXCly8niUwOR/jMSGiKGoZGNlsSi/Y6kGzI4CbvZk7GlIlFKaKRPbgDlcGAZX1UrM
         zOyXz8zY3OfjOBCmVVcpqPhdZH0fi+IvM7NI0W8dyDjsB+bWmqIeSv+O3MH624ENbRU7
         CB4Yaww/+WlN9FLezfFg/QiYaqTsa7y5JX4wedrOqMJJDUWWiH8Gf3aM3m63YwKEnapE
         5i+Y/k86C9ZGI/GZ+VAVPA+wEUi2pL7OmQdjRim/zdQuSlaohTH55Hvhj8JdNcSMGZjH
         Bjsw==
X-Gm-Message-State: AOAM530i+F8oLxanP4wZi08KvBk65OBRwGvVJcOIHHN+/6rkPfQ2WygO
        lVm6+mnNKZK0MCEZbw+SJZY=
X-Google-Smtp-Source: ABdhPJwZPb3xQnBafX3Cc2UkFC3rKhBp0t6gAaOR3aj31uj5J0E3RaO5UtzNWHxWMFeWPLraJz/3VA==
X-Received: by 2002:a63:e605:: with SMTP id g5mr687714pgh.124.1628531808948;
        Mon, 09 Aug 2021 10:56:48 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:2:106e:6ed1:5da1:2ac4])
        by smtp.gmail.com with ESMTPSA id x14sm20589708pfa.127.2021.08.09.10.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 10:56:48 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
Date:   Mon,  9 Aug 2021 13:56:14 -0400
Message-Id: <20210809175620.720923-11-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809175620.720923-1-ltykernel@gmail.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
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

