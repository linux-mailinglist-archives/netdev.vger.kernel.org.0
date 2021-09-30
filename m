Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CA41DA80
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349559AbhI3NHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349422AbhI3NHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC994C06176A;
        Thu, 30 Sep 2021 06:05:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so6126184pgl.10;
        Thu, 30 Sep 2021 06:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oj0TByVQOdhVxnTIGPAfhUDdmcc6lgt8LdPMueUIGf4=;
        b=Fl6rX98BQScLSWVyP+EPV4/iRT+SGhMVqSDRiFZA4zbWAaGB2I5VA4J2EHbAVTPxTt
         /jlnpRrfGTPOsag2I5HjzoBye6N/S1ThtgeNKfKgteYt2N2iJIdqMmL9YrTh2nm3VQvZ
         u8hrtZ4mWwTqmyPkpkH58IfQNn/Bk97KAWRDSK4jM0MOxdq/ZogCS0CDRwmofCxZ5px7
         sxfBXYyjBD+6w0vEO2GOKWDG1HsWJmFkdSusb7lFXzsrWRzpPVGwXLSilwXAmoLhigVd
         1GfK1vw2T4L1ue2saqYDdUV5lK4sYkh5ESBQGdQoRTwNlEPflqfuPpW0Yo+hbdktnXio
         7D2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oj0TByVQOdhVxnTIGPAfhUDdmcc6lgt8LdPMueUIGf4=;
        b=ueXQ75IMa2WWptOz+Faw+1YQ4RdRI+58jacEOHtEmX0QjV0By8EKbEnTnF8/gZ4WHB
         lGz63fIkvbdKsmdoaDnsGjSYIbPIYFaL6fJHeHWOlIcXXXL2iP5ImaNIlVIJPCB2XtGo
         mcxH9W3BxdBMjpxAziWFUhBqbDlsHvJDY/RsuNJ+OKnKt/pSZKT3+H31fAN8ZS8TBsgt
         IbQ22AidpzaxE442mxfFF/U9TkdeTRlizfL+kqdNwuL4RLTSqqEDO8tMqGz5CxDjYSBk
         m069ZwRGRE+grRUQVCGrGl70Lj+U4PIob3KmnKMw5PfEGRw9oRzFYkBkBW6TfMxg9z6l
         OG/g==
X-Gm-Message-State: AOAM530VJHcc060svZjfWIv1zxeYn8PIcUyLbfHjU90CA39LC/rZU5j6
        MI9wz8YpzoYLv/smt6SLLGI=
X-Google-Smtp-Source: ABdhPJx7hblaS+W1P4WILqv44xjkJFYJOzFiL6QYIz3HKQ4/6WS8OtSYOr6T6mXn8k+GBrz1Pph2lA==
X-Received: by 2002:a63:3d0f:: with SMTP id k15mr4765753pga.269.1633007148235;
        Thu, 30 Sep 2021 06:05:48 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:a72f:86cf:2cc5:8116])
        by smtp.gmail.com with ESMTPSA id v7sm3072134pff.195.2021.09.30.06.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:05:47 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 0/8] x86/Hyper-V: Add Hyper-V Isolation VM support(First part)
Date:   Thu, 30 Sep 2021 09:05:36 -0400
Message-Id: <20210930130545.1210298-1-ltykernel@gmail.com>
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


Tianyu Lan (8):
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

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  78 ++++++--
 arch/x86/hyperv/ivm.c              | 282 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  17 ++
 arch/x86/include/asm/mshyperv.h    |  59 ++++--
 arch/x86/include/asm/sev.h         |   6 +
 arch/x86/kernel/cpu/mshyperv.c     |   5 +
 arch/x86/kernel/sev-shared.c       |  63 ++++---
 arch/x86/mm/pat/set_memory.c       |  19 +-
 drivers/hv/Kconfig                 |   1 +
 drivers/hv/channel.c               |  72 +++++---
 drivers/hv/connection.c            |  96 +++++++++-
 drivers/hv/hv.c                    |  82 +++++++--
 drivers/hv/hv_common.c             |  12 ++
 drivers/hv/hyperv_vmbus.h          |   2 +
 drivers/hv/ring_buffer.c           |  55 ++++--
 drivers/net/hyperv/hyperv_net.h    |   5 +-
 drivers/net/hyperv/netvsc.c        |  15 +-
 drivers/uio/uio_hv_generic.c       |  18 +-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  17 +-
 include/linux/hyperv.h             |  12 +-
 22 files changed, 769 insertions(+), 150 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

-- 
2.25.1

