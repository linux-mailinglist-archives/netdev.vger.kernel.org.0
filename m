Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91646B39E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhLGHX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLGHX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:23:28 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29948C061746;
        Mon,  6 Dec 2021 23:19:59 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso1275031pji.0;
        Mon, 06 Dec 2021 23:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmCJousBiElqFxBD882RvdjUoER5eWaaA/AcR3+2s20=;
        b=jvXy/qEEGUVhwk2LesdeaJruWME4aYe5K71QK5NRhK6dCeU9GgnEKConYha8eBuyEJ
         1nDlG1+ZagPJyMvmbN229WnQUQ87ZbJKCNQLQrfRdGY3ous9SD15ovaIUajbxGyEe3XS
         TYwC1iMCAdXATo5GAkB11kXU7/YwWefAguseuGmPpdDUv29bkuADs0Xfa4WTKwU0P8ZC
         qBkzm1mFoNqevQPfTH1SPFjQiu9TxQ9nHj4nIPhVsvYaI+qQCntZ0O9TZSFHnvKFhkkx
         /4GYzCkbqym+KOBpPAIZ16J2vQwQC42RA0VC+5W4QLkT5QYCKmo4GSPUg06Q2mgTkz9y
         oB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmCJousBiElqFxBD882RvdjUoER5eWaaA/AcR3+2s20=;
        b=3YghvpNQQEtV24crrCxqtTvaioLtMltfmLmgZPPvizHKeP0d6OevtENCD3VovY/tnq
         mfX47HKASeWd9l3zgYuuejesm9/acqWtdtnn/HtaZQgWleszE9/5XqiQyNcWSdGDI/52
         8NmtwYtwACAGctsq+7HkG3GbLlcCAbuXPOsBewF68Jq3y5fDx76mhGs/NVrvASgMVFHP
         67CeskIgTmcC1L1uaxDRsFHGGLQPR2KU/b2oGZwZitF2xNZV9vRUe6EO5tc1OxW8+eiq
         EcYfGoIglqz87Nnr+ygl+2yM/d7drrN7TdqO4NxQsF6Zhho00iZS06pdPig7cYRJBFHV
         dFog==
X-Gm-Message-State: AOAM530NAHMKzBorBFi/zY+V1UxiSGk+aepJmb8dd9z4885oHx3WvyTG
        84PCJUigkbvUNiIv4jagLpU=
X-Google-Smtp-Source: ABdhPJwe1/gINLAOESVQ6X2sTbkgnfIkJgbnqrwCw/dWkrMSrVUoHcUaAUKcCTI2ec6EvxeEh7UNog==
X-Received: by 2002:a17:90a:be0f:: with SMTP id a15mr4450397pjs.243.1638861598583;
        Mon, 06 Dec 2021 23:19:58 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:e747:5b78:1904:a4ed])
        by smtp.gmail.com with ESMTPSA id u12sm2081789pfk.71.2021.12.06.23.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:19:58 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 0/5] x86/Hyper-V: Add Hyper-V Isolation VM support(Second part)
Date:   Tue,  7 Dec 2021 02:19:36 -0500
Message-Id: <20211207071942.472442-1-ltykernel@gmail.com>
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

This patchset is to enable swiotlb bounce buffer for netvsc/storvsc
in Isolation VM.

This version follows Michael Kelley suggestion in the following link.
https://lkml.org/lkml/2021/11/24/2044

Change sicne v5:
        * Modify "Swiotlb" to "swiotlb" in commit log.
	* Remove CONFIG_HYPERV check in the hyperv_cc_platform_has()

Change since v4:
	* Remove Hyper-V IOMMU IOMMU_INIT_FINISH related functions
	  and set SWIOTLB_FORCE and swiotlb_unencrypted_base in the
	  ms_hyperv_init_platform(). Call swiotlb_update_mem_attributes()
	  in the hyperv_init().

Change since v3:
	* Fix boot up failure on the host with mem_encrypt=on.
	  Move calloing of set_memory_decrypted() back from
	  swiotlb_init_io_tlb_mem to swiotlb_late_init_with_tbl()
	  and rmem_swiotlb_device_init().
	* Change code style of checking GUEST_MEM attribute in the
	  hyperv_cc_platform_has().
	* Add comment in pci-swiotlb-xen.c to explain why add
	  dependency between hyperv_swiotlb_detect() and pci_
	  xen_swiotlb_detect().
	* Return directly when fails to allocate Hyper-V swiotlb
	  buffer in the hyperv_iommu_swiotlb_init().

Change since v2:
	* Remove Hyper-V dma ops and dma_alloc/free_noncontiguous. Add
	  hv_map/unmap_memory() to map/umap netvsc rx/tx ring into extra
	  address space.
	* Leave mem->vaddr in swiotlb code with phys_to_virt(mem->start)
	  when fail to remap swiotlb memory.

Change since v1:
	* Add Hyper-V Isolation support check in the cc_platform_has()
	  and return true for guest memory encrypt attr.
	* Remove hv isolation check in the sev_setup_arch()

Tianyu Lan (5):
  swiotlb: Add swiotlb bounce buffer remap function for HV IVM
  x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
  hyper-v: Enable swiotlb bounce buffer for Isolation VM
  scsi: storvsc: Add Isolation VM support for storvsc driver
  net: netvsc: Add Isolation VM support for netvsc driver

 arch/x86/hyperv/hv_init.c         |  10 +++
 arch/x86/hyperv/ivm.c             |  28 ++++++
 arch/x86/kernel/cc_platform.c     |   8 ++
 arch/x86/kernel/cpu/mshyperv.c    |  11 ++-
 drivers/hv/hv_common.c            |  11 +++
 drivers/hv/vmbus_drv.c            |   4 +
 drivers/net/hyperv/hyperv_net.h   |   5 ++
 drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
 drivers/net/hyperv/netvsc_drv.c   |   1 +
 drivers/net/hyperv/rndis_filter.c |   2 +
 drivers/scsi/storvsc_drv.c        |  37 ++++----
 include/asm-generic/mshyperv.h    |   2 +
 include/linux/hyperv.h            |  14 +++
 include/linux/swiotlb.h           |   6 ++
 kernel/dma/swiotlb.c              |  43 +++++++++-
 15 files changed, 296 insertions(+), 22 deletions(-)

-- 
2.25.1

