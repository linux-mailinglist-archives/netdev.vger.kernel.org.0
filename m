Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC31E439612
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhJYMXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhJYMXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:23:41 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85C2C061220;
        Mon, 25 Oct 2021 05:21:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i5so7795001pla.5;
        Mon, 25 Oct 2021 05:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dLLKItC7FJu7DzJkO6gr5HZ4zqC5MTkAAgVJ19/8B+w=;
        b=V+a3mi8UwVO2EcZtMdvR/agwMP60yr6EHScXG7imE2PVTqdp1CoqbWYlFnUeJ2v0Wb
         7WtEfKCtAjsYrqf+GT9RSQBl5E8+n8Jni+4PSXPuE2LQaPCJRkLzgueH5VBpMHUDYX4I
         CD/lXhVcCaUn+VFeYLF3aZHtWHAyYJsUwtijZmkLEMZ/LgbYIQ3FGXdri9FXUE5/h53K
         KXaAprk/fLyKTsGtHt3J+i3XNnlgCUbeih+IChvtzCXr4oUY6GON6XVZziMUH559F7tU
         MkTRqbPxwAiEySGs++yEeoH943QUD08xYInpAGPW4524eiUchYG+t04bsU+lsuXkGc0Y
         J0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dLLKItC7FJu7DzJkO6gr5HZ4zqC5MTkAAgVJ19/8B+w=;
        b=nllu+ktI/XbQSl8u05ZDzJZQvW0oHu0pmpcFrRV96UetoY4/4U1e0akf5qkfIMOLNc
         IrERGgE0GGXhvatxiKV02GcqP3jkMFZRiO4x4yzU4hJ3Sr0OdI/teQw6oDo7521hwL1f
         m32hRmMFZW7sbPEyrMeUvn6nNZ1TRJ/RJpeI7GIZHKRZKsgAnRvDUOZMv0/v6JBdACUx
         S9G66o0LH5Df1aIMlPK4EU6kBRrehp1HlYKYwB7LWVwxUw2mINcIs+7D5NhruzYMRbWp
         8oEqtycLbao2+VJ8tMEqQl+kkRYGWCA7pS0Iu7cBEPMRxVZJA2BaeVDrq8OB2SqhLS8g
         5LRg==
X-Gm-Message-State: AOAM5321d9gHNRZEaU0m4xFs9RxkJH4/EqYQ1qr0eshjlvsN7FvBD/7M
        lb8BxsRUDzSjOrcDwzG5jT8=
X-Google-Smtp-Source: ABdhPJwLApssT12J7nzjBoEV6nnMpHAInbtP1EyhuYNxE3A+huPjA16wU0ZOPueujc4qLImbf+0jbQ==
X-Received: by 2002:a17:90a:a88e:: with SMTP id h14mr23101946pjq.41.1635164479273;
        Mon, 25 Oct 2021 05:21:19 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:bcf6:9813:137f:2b6])
        by smtp.gmail.com with ESMTPSA id mi11sm2786166pjb.5.2021.10.25.05.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 05:21:18 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com,
        sfr@canb.auug.org.au, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V9 0/9] x86/Hyper-V: Add Hyper-V Isolation VM support(First part)
Date:   Mon, 25 Oct 2021 08:21:05 -0400
Message-Id: <20211025122116.264793-1-ltykernel@gmail.com>
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

This patchset is rebased on the commit d9abdee of Linux mainline tree
and plus clean up patch from Borislav Petkov(https://lore.kernel.org/r/
YWRwxImd9Qcls/Yy@zn.tnic)


Change since v8
        - Fix compile issue in the patch "  x86/sev-es: Expose sev_es_ghcb_hv_call()
	  to call ghcb hv call out of sev code via adding check AMD SEV option
          in the ivm.c and not compile the ghcb related function when the option
	  is not selected.

Change since v7
	- Rework sev_es_ghcb_hv_call() and export it for Hyper-V
	  according to suggestion from Borislav Petkov.

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
  x86/sev-es: Expose sev_es_ghcb_hv_call() to call ghcb hv call out of
    sev code
  x86/hyperv: Add Write/Read MSR registers via ghcb page
  x86/hyperv: Add ghcb hvcall support for SNP VM
  Drivers: hv: vmbus: Add SNP support for VMbus channel initiate 
    message
  Drivers: hv : vmbus: Initialize VMbus ring buffer for Isolation VM

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  78 ++++++--
 arch/x86/hyperv/ivm.c              | 291 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  17 ++
 arch/x86/include/asm/mshyperv.h    |  70 +++++--
 arch/x86/include/asm/sev.h         |   5 +
 arch/x86/kernel/cpu/mshyperv.c     |   5 +
 arch/x86/kernel/sev-shared.c       |  25 ++-
 arch/x86/kernel/sev.c              |  13 +-
 arch/x86/mm/pat/set_memory.c       |  23 ++-
 drivers/hv/Kconfig                 |   1 +
 drivers/hv/channel.c               |  72 ++++---
 drivers/hv/connection.c            | 101 +++++++++-
 drivers/hv/hv.c                    |  82 ++++++--
 drivers/hv/hv_common.c             |  12 ++
 drivers/hv/hyperv_vmbus.h          |   2 +
 drivers/hv/ring_buffer.c           |  55 ++++--
 drivers/net/hyperv/hyperv_net.h    |   5 +-
 drivers/net/hyperv/netvsc.c        |  15 +-
 drivers/uio/uio_hv_generic.c       |  18 +-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  20 +-
 include/linux/hyperv.h             |  12 +-
 23 files changed, 786 insertions(+), 139 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

-- 
2.25.1

