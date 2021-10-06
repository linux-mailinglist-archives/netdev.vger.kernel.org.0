Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8262242381D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhJFGir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhJFGiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:38:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FC4C061749;
        Tue,  5 Oct 2021 23:36:54 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 145so1465198pfz.11;
        Tue, 05 Oct 2021 23:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FSSJsaAue0bJ7Jr5rl4WGX9cfhE+Ody0IkbTmbu98MA=;
        b=CmV2LnWutQCUDBPZtcW0r4stuHb2pAj7F0Athoo9Bvyl8A01LzKUcGBo+b8XRoUSBw
         sn4a/mZ6Q9Hg54LbL4lZHVI+Ciwkc3ZWCPMzx1Rm6wcbEAmZNRDsR0f3Pf8k+805P74T
         XEVW44Mj8mM0Qi3nl6E7q1jT9CxYKLtlSz+fyuvH5E4I+KRvy/nMyXkwfzBAGm+8TcnG
         OcRtKugyS1scBTAabwhPgRCSKEol7ey5F51n6WghDPV0+6lH8z+RJaANXHXEVBxChv4L
         83i7cNXWhNRNUkIX20h0am9znIDUX7RhbSXA+crR4meB5nR6GpYHbLEZk+JH/s0GdX2J
         dqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FSSJsaAue0bJ7Jr5rl4WGX9cfhE+Ody0IkbTmbu98MA=;
        b=AAA0GmZw9Xz5SLFT5ILGc9ROJtE4U48jZKxA3hfP4XgtPvPTt0oHNprAzbZEjgtKjW
         xHvjrDhBGcBp644DhuV4+zNHwewEqEXLl+j4ejeUB51IP0H21777YDWLZgCwr0mOp2lu
         kcMfDR5DZF1XynwROmXZeca0vgjOACMivfnjIT/Vs9hzAGlgAjVi9AO+gnanzf53EXWN
         3TXeyC/SmhTJLAzPxXZHW0Ad8y19w+K0QQmwdpP1yidwqkuhb7PoeeuTT8ffP/mzg5hC
         v91gWuVifGtsg7flAc6fS9+3PG0V2YmkfXl7TwxL41MrxOvA6eniZWjO1KnVhvCslynB
         Xl4Q==
X-Gm-Message-State: AOAM531OQn7rKEbSGbRmbokpa/mOOGCpl8P+kQFmjsHx456oLXHporH+
        dggAPQDT12yVn8JsINUNgVs=
X-Google-Smtp-Source: ABdhPJyhrj2cCy3Ka1wEPZfnmRJ1YyHrDgNfMHUUiWd5iSWpvMQbOZPh4Gif1Hp/DKQleigfahImBQ==
X-Received: by 2002:a63:dc42:: with SMTP id f2mr19054887pgj.152.1633502213935;
        Tue, 05 Oct 2021 23:36:53 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:37:357b:c418:cfef:30b1])
        by smtp.gmail.com with ESMTPSA id l185sm19886413pfd.29.2021.10.05.23.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 23:36:53 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, jroedel@suse.de, brijesh.singh@amd.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V7 0/9] x86/Hyper-V: Add Hyper-V Isolation VM support(First part)
Date:   Wed,  6 Oct 2021 02:36:40 -0400
Message-Id: <20211006063651.1124737-1-ltykernel@gmail.com>
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

For SNP isolation VM, guest needs to access the shared memory via
extra address space which is specified by Hyper-V CPUID HYPERV_CPUID_
ISOLATION_CONFIG. The access physical address of the shared memory
should be bounce buffer memory GPA plus with shared_gpa_boundary
reported by CPUID.

This patchset is rebased on the commit 02d5e016 of Linux mainline tree.

Change since v6
	- Add hv_set_mem_host_visibility() when CONFIG_HYPERV is no.
	  Fix compile error.
	- Add comment to describe __set_memory_enc_pgtable().
	- Split SEV change into patch "Expose __sev_es_ghcb_hv_call()
	  to call ghcb hv call out of sev code"
 	- Add comment about calling memunmap() in the non-snp IVM.

Change since v5
	- Replace HVPFN_UP() with PFN_UP() in the __vmbus_establish_gpadl()
	- Remove unused variable gpadl in the __vmbus_open() and vmbus_close_
	  internal()
	- Clean gpadl_handle in the vmbus_teardown_gpadl().
	- Adjust change layout in the asm/mshyperv.h to make
	  hv_is_synic_reg(), hv_get_register() and hv_set_register()
	  ahead of the #include of asm-generic/mshyperv.h
	- Change vmbus_connection.monitor_pages_pa type from unsigned
	  long to phys_addr_t

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

Tianyu Lan (9):
  x86/hyperv: Initialize GHCB page in Isolation VM
  x86/hyperv: Initialize shared memory boundary in the Isolation VM.
  x86/hyperv: Add new hvcall guest address host visibility  support
  Drivers: hv: vmbus: Mark vmbus ring buffer visible to host in
    Isolation VM
  x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb hv call out of
    sev code
  x86/hyperv: Add Write/Read MSR registers via ghcb page
  x86/hyperv: Add ghcb hvcall support for SNP VM
  Drivers: hv: vmbus: Add SNP support for VMbus channel initiate 
    message
  Drivers: hv : vmbus: Initialize VMbus ring buffer for Isolation VM

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  78 ++++++--
 arch/x86/hyperv/ivm.c              | 282 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  17 ++
 arch/x86/include/asm/mshyperv.h    |  64 +++++--
 arch/x86/include/asm/sev.h         |  10 +
 arch/x86/kernel/cpu/mshyperv.c     |   5 +
 arch/x86/kernel/sev-shared.c       |  43 +++--
 arch/x86/mm/pat/set_memory.c       |  23 ++-
 drivers/hv/Kconfig                 |   1 +
 drivers/hv/channel.c               |  72 +++++---
 drivers/hv/connection.c            | 101 ++++++++++-
 drivers/hv/hv.c                    |  82 +++++++--
 drivers/hv/hv_common.c             |  12 ++
 drivers/hv/hyperv_vmbus.h          |   2 +
 drivers/hv/ring_buffer.c           |  55 ++++--
 drivers/net/hyperv/hyperv_net.h    |   5 +-
 drivers/net/hyperv/netvsc.c        |  15 +-
 drivers/uio/uio_hv_generic.c       |  18 +-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  20 +-
 include/linux/hyperv.h             |  12 +-
 22 files changed, 783 insertions(+), 137 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

-- 
2.25.1

