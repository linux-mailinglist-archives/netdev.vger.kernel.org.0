Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235653BEB3C
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhGGPt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhGGPtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:49:18 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70FC061574;
        Wed,  7 Jul 2021 08:46:38 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y2so1287736plc.8;
        Wed, 07 Jul 2021 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XEy9MBH2xC4dZEcS/mwpFTD3phu8HJFYvRE31VHkqO4=;
        b=dVjU9z6yd+WtH5wOSKQA2aeo62Q55Ryf1sLhnW8ERHJkP5FeXEOXZo8pcwVX7GVsJl
         SONowG0KutFyHhmZBl6O3rcPAlnySVD/WytMsY0wpDvq8vddH/VhKizYx5wu4u62y6WQ
         yi5aDJkNgItUVJjPNZXit/rT1B2o9e71+ta9pdA5HqQDjq2R0RIMf5vCGZOg2KKKN+FY
         Gra8VhDU9iGdsKsuKlCK2QwTwqi7BeC/5rjtSLQKB5l3xAShMlgnGvfWh76z37tFab2R
         Y8p2fv9uiNRXN+g6vKG7/7Bq3LsuPRHd5FDg8+J0YDQp0lZbAJG5CoJxfVXOxaMhQNTT
         FXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XEy9MBH2xC4dZEcS/mwpFTD3phu8HJFYvRE31VHkqO4=;
        b=SMJ32/nRRlOWFkGzI5RgfURxG2Awmdk3VBm2VvZBSbPVeyvrGOXMJUABHfSNN9ajQs
         u5R3zTR5mkcr7XMid0bgq7yMWFhHDqBhN2/u/GmlCLyd2QSJFaxnSCCJJyEkDb+d23ch
         p9FDo3PIVmAkFN96qQ3S/6lyGy6URwGbpwEPF9F7RVSbmFcgg19eYo4K3fR3OYFPCMVx
         FoT0vTMaGahHA9MRvtBbR4mqNiprZPzYItK9YVjyU+6nPchBZcU1DIEhKe5N2gANDqpS
         RJkdvwNBHV+lW8/AY+l3vsfl7OkYJ1LGpow1I54URlIzl+8PVZyAvVgOyg/Ywop0u4nw
         SLKg==
X-Gm-Message-State: AOAM531fIuTtLnWAzTfvnD+n4TEROZYgFdcxXY6M1ogM9Vbz2kw6doaA
        Yr6PBedQOjyrXjrvKkOsBP4=
X-Google-Smtp-Source: ABdhPJwrapkvQmhsq7izULEH3/UVyZc58oEb1wOxgfRpgO104u8No2xwyPDqA0U4C/PdBpq28eDgPQ==
X-Received: by 2002:a17:902:e843:b029:129:acb4:2464 with SMTP id t3-20020a170902e843b0290129acb42464mr7506834plg.77.1625672797807;
        Wed, 07 Jul 2021 08:46:37 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:6b47:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id q18sm23093560pgj.8.2021.07.07.08.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:46:37 -0700 (PDT)
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
        Tianyu.Lan@microsoft.com, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        thomas.lendacky@amd.com, ardb@kernel.org,
        nramas@linux.microsoft.com, robh@kernel.org, keescook@chromium.org,
        martin.b.radev@gmail.com, pgonda@google.com, hannes@cmpxchg.org,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [Resend RFC PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Date:   Wed,  7 Jul 2021 11:46:14 -0400
Message-Id: <20210707154629.3977369-1-ltykernel@gmail.com>
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

Change since v3:
       - Add interface set_memory_decrypted_map() to decrypt memory and
         map bounce buffer in extra address space 
       - Remove swiotlb remap function and store the remap address
         returned by set_memory_decrypted_map() in swiotlb mem data structure.
       - Introduce hv_set_mem_enc() to make code more readable in the __set_memory_enc_dec().

Change since v2:
       - Remove not UIO driver in Isolation VM patch
       - Use vmap_pfn() to replace ioremap_page_range function in
       order to avoid exposing symbol ioremap_page_range() and
       ioremap_page_range()
       - Call hv set mem host visibility hvcall in set_memory_encrypted/decrypted()
       - Enable swiotlb force mode instead of adding Hyper-V dma map/unmap hook
       - Fix code style

Tianyu Lan (13):
  x86/HV: Initialize GHCB page in Isolation VM
  x86/HV: Initialize shared memory boundary in the Isolation VM.
  x86/HV: Add new hvcall guest address host visibility support
  HV: Mark vmbus ring buffer visible to host in Isolation VM
  HV: Add Write/Read MSR registers via ghcb page
  HV: Add ghcb hvcall support for SNP VM
  HV/Vmbus: Add SNP support for VMbus channel initiate message
  HV/Vmbus: Initialize VMbus ring buffer for Isolation VM
  x86/Swiotlb/HV: Add Swiotlb bounce buffer remap function for HV IVM
  HV/IOMMU: Enable swiotlb bounce buffer for Isolation VM
  HV/Netvsc: Add Isolation VM support for netvsc driver
  HV/Storvsc: Add Isolation VM support for storvsc driver
  x86/HV: Not set memory decrypted/encrypted during kexec alloc/free
    page in IVM

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  25 +--
 arch/x86/hyperv/ivm.c              | 299 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  18 ++
 arch/x86/include/asm/mshyperv.h    |  84 +++++++-
 arch/x86/include/asm/set_memory.h  |   2 +
 arch/x86/include/asm/sev-es.h      |   4 +
 arch/x86/kernel/cpu/mshyperv.c     |   5 +
 arch/x86/kernel/machine_kexec_64.c |   5 +-
 arch/x86/kernel/sev-es-shared.c    |  21 +-
 arch/x86/mm/pat/set_memory.c       |  34 +++-
 arch/x86/xen/pci-swiotlb-xen.c     |   3 +-
 drivers/hv/Kconfig                 |   1 +
 drivers/hv/channel.c               |  48 ++++-
 drivers/hv/connection.c            |  71 ++++++-
 drivers/hv/hv.c                    | 129 +++++++++----
 drivers/hv/hyperv_vmbus.h          |   3 +
 drivers/hv/ring_buffer.c           |  84 ++++++--
 drivers/hv/vmbus_drv.c             |   3 +
 drivers/iommu/hyperv-iommu.c       |  62 ++++++
 drivers/net/hyperv/hyperv_net.h    |   6 +
 drivers/net/hyperv/netvsc.c        | 144 +++++++++++++-
 drivers/net/hyperv/rndis_filter.c  |   2 +
 drivers/scsi/storvsc_drv.c         |  68 ++++++-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  53 ++++-
 include/linux/hyperv.h             |  16 ++
 include/linux/swiotlb.h            |   4 +
 kernel/dma/swiotlb.c               |  11 +-
 29 files changed, 1097 insertions(+), 111 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

-- 
2.25.1

