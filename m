Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B06E40AF13
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhINNkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhINNkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:40:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4194FC061574;
        Tue, 14 Sep 2021 06:39:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 17so12756397pgp.4;
        Tue, 14 Sep 2021 06:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BHnwRGLPqH2A09ZXeDyMyxAcljYFX6n5VugCn85EoaM=;
        b=pjWLs+F/UNZaQ69Ds31Zi6HGFXPIFegbFqnIPgAg/e7eumR7muKpnjQsK4h4ATjgb2
         by7YiKtMcGNpi+ZXill2CZ9odlQEVqCHILMVlph6YQFKC8hHwp1QpE3r+RuSLxydvPYZ
         eGAqVhTH+xBk/V/LWNCB2iXK6oGjpeCm6U1nP3C+AFVZg+TFR+itqQRDs0wgk7bN3jJj
         IMVP9rnCIplN4weSfeBPFdD9eNEmq4L1JXa8SxhKOq/LaXmZsBWdbgaymudmjb7zfL2E
         DKrQ17H/rltwz4VcgDwdq+noncaSP4fVO9efd8m4H7efVZrJSaN580PDrm6EaBFxrg5t
         ohzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BHnwRGLPqH2A09ZXeDyMyxAcljYFX6n5VugCn85EoaM=;
        b=3gSnxo2ywCJ9jmEjDd0490TDd9ZqWUV+vFcBXeWQVBu1rntGP1jByHGh545hcnXHQ6
         EjFIAycaecmdXw3EKfMthZqC3vaNeuywYTr9sqavGLUkOPnT4jVyUlSXi+t+rwclm0Wy
         3ErhNkGFnFuX8O4eTv4kVBjJHvpqMmz56rgoBVDlb8eneIo/+QswljwYKvUvk8sht7F9
         KDqE8vyRRVxS+hA3JHQuM5WEM/S8SKZwTHX72ZXtEU4ByWHX8zSI4AI4oCQgqL5bMxc1
         sKZpIir7LkigGrfA7Tm2rzJhl4L7RjIX9RVAGWcMF6ImFrLFnAUIE1xuf5LmgXhN/4Hg
         rm1g==
X-Gm-Message-State: AOAM530HU1uO3emh1ae48BrHvATo95aEjRhFhtD52nYvCMFfByZKRS+O
        F/VtfPfnCCg8Vakw/2BLU1k=
X-Google-Smtp-Source: ABdhPJysSi/ePEIpmop1TOOZL/EDUeVswpP9kBW06aQK1cw/R5aOGjFREOrMllhH8ENnzQcpU6ys4A==
X-Received: by 2002:a63:3d4a:: with SMTP id k71mr15619461pga.276.1631626762730;
        Tue, 14 Sep 2021 06:39:22 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:6ea2:a529:4af3:5057])
        by smtp.gmail.com with ESMTPSA id v13sm10461234pfm.16.2021.09.14.06.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:39:22 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, sfr@canb.auug.org.au, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V5 00/12] x86/Hyper-V: Add Hyper-V Isolation VM support
Date:   Tue, 14 Sep 2021 09:39:01 -0400
Message-Id: <20210914133916.1440931-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V provides two kinds of Isolation VMs. VBS(Virtualization-based
security) and AMD SEV-SNP unenlightened Isolation VMs. This patchset
is to add support for these Isolation VM support in Linux.

The memory of these vms are encrypted and host can't access guest
memory directly. Hyper-V provides new host visibility hvcall and
the guest needs to call new hvcall to mark memory visible to host
before sharing memory with host. For security, all network/storage
stack memory should not be shared with host and so there is bounce
buffer requests.

Vmbus channel ring buffer already plays bounce buffer role because
all data from/to host needs to copy from/to between the ring buffer
and IO stack memory. So mark vmbus channel ring buffer visible.

There are two exceptions - packets sent by vmbus_sendpacket_
pagebuffer() and vmbus_sendpacket_mpb_desc(). These packets
contains IO stack memory address and host will access these memory.
So add allocation bounce buffer support in vmbus for these packets.

For SNP isolation VM, guest needs to access the shared memory via
extra address space which is specified by Hyper-V CPUID HYPERV_CPUID_
ISOLATION_CONFIG. The access physical address of the shared memory
should be bounce buffer memory GPA plus with shared_gpa_boundary
reported by CPUID.

This patchset is based on the 5.15-rc1.

Change since v4:
	- Hide hv_mark_gpa_visibility() and set memory visibility via
	  set_memory_encrypted/decrypted() 
	- Change gpadl handle in netvsc and uio driver from u32 to
	  struct vmbus_gpadl.
	- Change vmbus_establish_gpadl()'s gpadl_handle parameter
	  to vmbus_gpadl data structure.
	- Remove hv_get_simp(), hv_get_siefp()  hv_get_synint_*()
	  helper function. Move the logic into hv_get/set_register().
	- Use scsi_dma_map/unmap() instead of dma_map/unmap_sg() in storvsc driver.
	- Allocate rx/tx ring buffer via alloc_pages() in Isolation VM  

Change since V3:
	- Initalize GHCB page in the cpu init callbac.
	- Change vmbus_teardown_gpadl() parameter in order to
	  mask the memory back to non-visible to host.
	- Merge hv_ringbuffer_post_init() into hv_ringbuffer_init().
	- Keep Hyper-V bounce buffer size as same as AMD SEV VM
	- Use dma_map_sg() instead of dm_map_page() in the storvsc driver.

Change since V2:
       - Drop x86_set_memory_enc static call and use platform check
         in the __set_memory_enc_dec() to run platform callback of
	 set memory encrypted or decrypted.

Change since V1:
       - Introduce x86_set_memory_enc static call and so platforms can
         override __set_memory_enc_dec() with their implementation
       - Introduce sev_es_ghcb_hv_call_simple() and share code
         between SEV and Hyper-V code.
       - Not remap monitor pages in the non-SNP isolation VM
       - Make swiotlb_init_io_tlb_mem() return error code and return
         error when dma_map_decrypted() fails.

Change since RFC V4:
       - Introduce dma map decrypted function to remap bounce buffer
          and provide dma map decrypted ops for platform to hook callback.        
       - Split swiotlb and dma map decrypted change into two patches
       - Replace vstart with vaddr in swiotlb changes.

Change since RFC v3:
       - Add interface set_memory_decrypted_map() to decrypt memory and
         map bounce buffer in extra address space
       - Remove swiotlb remap function and store the remap address
         returned by set_memory_decrypted_map() in swiotlb mem data structure.
       - Introduce hv_set_mem_enc() to make code more readable in the __set_memory_enc_dec().

Change since RFC v2:
       - Remove not UIO driver in Isolation VM patch
       - Use vmap_pfn() to replace ioremap_page_range function in
       order to avoid exposing symbol ioremap_page_range() and
       ioremap_page_range()
       - Call hv set mem host visibility hvcall in set_memory_encrypted/decrypted()
       - Enable swiotlb force mode instead of adding Hyper-V dma map/unmap hook
       - Fix code style

Tianyu Lan (12):
  x86/hyperv: Initialize GHCB page in Isolation VM
  x86/hyperv: Initialize shared memory boundary in the Isolation VM.
  x86/hyperv: Add new hvcall guest address host visibility  support
  Drivers: hv: vmbus: Mark vmbus ring buffer visible to host in
    Isolation VM
  x86/hyperv: Add Write/Read MSR registers via ghcb page
  x86/hyperv: Add ghcb hvcall support for SNP VM
  Drivers: hv: vmbus: Add SNP support for VMbus channel initiate 
    message
  Drivers: hv : vmbus: Initialize VMbus ring buffer for Isolation VM
  x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
  hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
  scsi: storvsc: Add Isolation VM support for storvsc driver
  net: netvsc: Add Isolation VM support for netvsc driver

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  78 ++++++--
 arch/x86/hyperv/ivm.c              | 282 ++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  17 ++
 arch/x86/include/asm/mshyperv.h    |  62 ++++--
 arch/x86/include/asm/sev.h         |   6 +
 arch/x86/kernel/cpu/mshyperv.c     |   5 +
 arch/x86/kernel/sev-shared.c       |  63 +++---
 arch/x86/mm/mem_encrypt.c          |   3 +-
 arch/x86/mm/pat/set_memory.c       |  19 +-
 arch/x86/xen/pci-swiotlb-xen.c     |   3 +-
 drivers/hv/Kconfig                 |   1 +
 drivers/hv/channel.c               |  73 ++++---
 drivers/hv/connection.c            |  96 ++++++++-
 drivers/hv/hv.c                    |  85 ++++++--
 drivers/hv/hv_common.c             |  12 ++
 drivers/hv/hyperv_vmbus.h          |   2 +
 drivers/hv/ring_buffer.c           |  55 ++++--
 drivers/hv/vmbus_drv.c             |   4 +
 drivers/iommu/hyperv-iommu.c       |  60 ++++++
 drivers/net/hyperv/hyperv_net.h    |  12 +-
 drivers/net/hyperv/netvsc.c        | 304 +++++++++++++++++++++++++++--
 drivers/net/hyperv/netvsc_drv.c    |   1 +
 drivers/net/hyperv/rndis_filter.c  |   2 +
 drivers/scsi/storvsc_drv.c         |  24 ++-
 drivers/uio/uio_hv_generic.c       |  20 +-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  17 +-
 include/linux/hyperv.h             |  19 +-
 include/linux/swiotlb.h            |   6 +
 kernel/dma/swiotlb.c               |  41 +++-
 31 files changed, 1204 insertions(+), 171 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

-- 
2.25.1

