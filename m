Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884B53BEAC0
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhGGPhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhGGPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:37:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65455C061574;
        Wed,  7 Jul 2021 08:35:04 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w22so2508366pff.5;
        Wed, 07 Jul 2021 08:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jkolUPwi5vmrrny8Lv1Ra8OVYttbBuLIiyALxAjfV3U=;
        b=uMrytKrdPPAXlONXoKnZbDo6E2aSYBoFVoQVDqkbtkCONIx0wfe5zboS/QgKGbqPlK
         HS7DtVjHbxLaSrJiY3p/LKmA3t54P4RWelPEkaOkO8stQ7CAdvAy7zQxCEhobAKO24Uc
         yzBRueqU/xom01Q9hKCy71J3KiVnkJ5uKwhY48+BfUMU4AbwU4AHP4T0qES8oolzCvTS
         TR/u5P+44atse+4WTf8EAqCmkpOdPJMPQcSu8WGo5Hw7d5AOnMUTkIvh5Nho1JiSvb7Y
         Ull2Bm5sux8+oXfXdMFGsGaeiQSo5wus3T4DkOI5mIPdsA0acl20F6nCBoK1W6wpKLxn
         8ZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jkolUPwi5vmrrny8Lv1Ra8OVYttbBuLIiyALxAjfV3U=;
        b=CUMj9W3aL8lU2QnQkjLQZXa/8d3NKOx8Vh9Bg3H1+ZhelrN2msyf0holaYSdJkWL3c
         XKPg9559X/e07MfY1rHPQPXYvyVE3w2IIAWMnzbOOzxm71TOBwgxyXsgYAY4/zkYEDCs
         FhwRjNpfi4RUvlNWx0BdmrR6B6x7w/JQM5Y3LuFwgksJfFqYhSgV/cL7vr+0751X3MR0
         7ocE1glg1s6b7C8Aky+2eGDwd0XYo2S6o0gzvxdtTEP+f5FULn65mcL//lyYoXfwbcP3
         e/HtssXnGG1deHOl9vDrBn6judlm+G/Vw36eS9ogxHqBQNHi8V87+AavZHMFEBLZNw7x
         7qGQ==
X-Gm-Message-State: AOAM533yZlmQ26bFPPMC0okqHj6LLmMxubzZ79nC0LNqofszEsNagUlS
        xWc8t8m/o3sRGbjsgoofSl0=
X-Google-Smtp-Source: ABdhPJyD+VDToE/d2GDA5bL79Z5IjrRMQN05lni8aQ82HOiaAKMvr6K+0cHHIUktpTxzsCLuEpzwiw==
X-Received: by 2002:a62:5547:0:b029:2ec:8f20:4e2 with SMTP id j68-20020a6255470000b02902ec8f2004e2mr26077347pfb.71.1625672103921;
        Wed, 07 Jul 2021 08:35:03 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:6b7f:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id y11sm21096877pfo.160.2021.07.07.08.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:35:03 -0700 (PDT)
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
Subject: [RFC PATCH V4 00/12] x86/Hyper-V: Add Hyper-V Isolation VM support
Date:   Wed,  7 Jul 2021 11:34:41 -0400
Message-Id: <20210707153456.3976348-1-ltykernel@gmail.com>
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

Tianyu Lan (12):
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

