Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6323D9140
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhG1OyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237421AbhG1Oxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 10:53:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF21C0617B1;
        Wed, 28 Jul 2021 07:53:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so5495772pjv.3;
        Wed, 28 Jul 2021 07:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ot9NJwgdtSwny3Hz0sW1NmpmwSF9uMUFojPkk0oFEg8=;
        b=S9fynuTeK9vSXvNUDeY4KnRGKPztyWj8Fnz9B9pB5BahJ6cJS+RVcWxVYle9dJnAIB
         DXvmJ5t+++ZA0+T/R07cFZjYEvWfOBk5aAnD8gwRqttsKg4OchtPTc7bNT+bkFxS0q+T
         TS/EMh8f7+QSBU3kGVcPuPs8WY7W8CHJzLzI6CjPe3REMSyY+WNgH2eXqZDMnV2ZtFhz
         G26GNjCWgJtPCYIYclclGs7MF/0fcsoDjy+ziedykVSkxHQCeVHQSN/W73Qf/d3uXzjp
         f3+qF0i9dOE+cA2voQSGgplfosvRU8qjFeC6hKdER1BDhuJIhBrZI5zNDfVR9HgknOBd
         oryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ot9NJwgdtSwny3Hz0sW1NmpmwSF9uMUFojPkk0oFEg8=;
        b=n3YMyTkqbWBVPdxpt1u7thtdXU3h9LH6Drv4XCKVsd8zqyHOjrwFqY3I9bEXlpoopf
         Sh4EYJOAA8hJgfvp+Y61xPIx9eN5gMHkr8t5pOga8bwUrY48Dv3VA7WZKakBPS0oJM2H
         jLoUeA+WdkD0o08RP/aUmXK0RxCoB5K1LA0NrKtnrBWoeu1p4vAVMy0Bqbh/u0ukDe3I
         X3qD5opgBIMHe7vyEKI+hUzqj6EMRBB07wv9UDAn9/XGhFwOkIVjisf/RVETj+CqqQiD
         Hcrr1csf3u6WYdSu8iPCzGN1kRtt/O53pTodA7Fi+SzLep5irZJ1lWjom5D8V1qXRhuN
         r4Bg==
X-Gm-Message-State: AOAM531Zm6xC481w0ZnPIFlaePuoJuEgHD6VtT6hS47ncW8672hRTXGF
        sl7JY1VCoH3J7naej2KdoHs=
X-Google-Smtp-Source: ABdhPJwWvL5ltGyV4xAnV2PomvPFPoswsA8DVwzJ1kj0bPYDH6cusQ3v3SJ1R0nnIFdc7ySbf7Z6SQ==
X-Received: by 2002:a17:90a:19db:: with SMTP id 27mr10213457pjj.216.1627484012282;
        Wed, 28 Jul 2021 07:53:32 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:3823:141e:6d51:f0ad])
        by smtp.gmail.com with ESMTPSA id n134sm277558pfd.89.2021.07.28.07.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:53:32 -0700 (PDT)
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
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com
Subject: [PATCH 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
Date:   Wed, 28 Jul 2021 10:52:25 -0400
Message-Id: <20210728145232.285861-11-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728145232.285861-1-ltykernel@gmail.com>
References: <20210728145232.285861-1-ltykernel@gmail.com>
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
 include/linux/swiotlb.h |  4 ++++
 kernel/dma/swiotlb.c    | 11 ++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

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
index 1fa81c096c1d..6866e5784b53 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -194,8 +194,13 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].alloc_size = 0;
 	}
 
-	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-	memset(vaddr, 0, bytes);
+	mem->vaddr = dma_map_decrypted(vaddr, bytes);
+	if (!mem->vaddr) {
+		pr_err("Failed to decrypt memory.\n");
+		return;
+	}
+
+	memset(mem->vaddr, 0, bytes);
 }
 
 int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -360,7 +365,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
-	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
-- 
2.25.1

