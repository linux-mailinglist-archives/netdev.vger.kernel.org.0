Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F369B469834
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343526AbhLFOP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245563AbhLFOPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:15:21 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37ECC0613F8;
        Mon,  6 Dec 2021 06:11:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y7so7174758plp.0;
        Mon, 06 Dec 2021 06:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOa51ZsDfD/a3LfzEsL1n3T8x3Gl4yCrM9nrL7Ngsao=;
        b=bbYwtI1PKtuXo07qYCzbL+ZPmXStNRRsWw9nrijJlC8mjhWffbv5vNxomApjcSr++D
         BWoM4Xhej1DbD2NfJCC1Dw8Fn171DefJGFtM3qoLji59SDTUpwXt2qyvnI+VhbJpCcPg
         xCsKJwCyk2h4+eT5f7qVFbUs7t4Vrd3tpfjH+UTv3tCgTr6HwvJ8sxUOCHka22BsuJkE
         C5nIXAHhtIlclruyBaLg7Hi8voqhRnX/f7uSM6KPp9wPQEMOs64pVuJQnYfuApdFeVjn
         pexpXOLTxSgLaMKF+yqEXJKhJsbOKXZOP4kOuqyyDYyClO4rZIjkP1aA222/gZPrjTCu
         Qzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOa51ZsDfD/a3LfzEsL1n3T8x3Gl4yCrM9nrL7Ngsao=;
        b=jQXnwy5Aptio/5zUYHF5zW04g7G9akG0Jn5ayv2Bu40N5GOl60vHikWh5mY/AqlXsP
         mFADWwoRIyOSUfmqLg5Fu8BG1yQEhd7RmG0BpYF0ObAJ/KRoWu5Eguc2nSn+7vFLfMLC
         KcBnRcMIWjeF1Ceo73W2/uck3zFU3oh5XWeYnS1/Z1jecFyjWsYa2BV0NLZNvNzxMHCG
         JwELRjBBOjpa85cgpAtaH2dDLiCeTULhLn+9OoXqKtfPaz5/BrofC4/plqgIgxkCDXy8
         fonLO0fLLzch2XnuRjKxgHeAuzmOBll03UAQo3951WKC2jNQ/jBz6iQ6UJOs5hk8kGb/
         7xYw==
X-Gm-Message-State: AOAM531f065l8/wY0OC9FMFadxEGE6RUIshA5fMALRD9o2T/gw4qRHQW
        FHy9BTKw/Mvr8lE0qpgfbas=
X-Google-Smtp-Source: ABdhPJzk5BxxTOGWKCKDgcaVhhzjutSnYjYXejJlg686Z/NJ2+PhkAB62LK6hSzlzjRoY+shBhcH7Q==
X-Received: by 2002:a17:902:aa43:b0:143:e20b:f37f with SMTP id c3-20020a170902aa4300b00143e20bf37fmr43409374plr.65.1638799911973;
        Mon, 06 Dec 2021 06:11:51 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:b5b5:3f40:cec1:40a0])
        by smtp.gmail.com with ESMTPSA id g19sm7717606pfc.145.2021.12.06.06.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 06:11:51 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V5 0/5] x86/Hyper-V: Add Hyper-V Isolation VM support(Second part)
Date:   Mon,  6 Dec 2021 09:11:40 -0500
Message-Id: <20211206141145.447453-1-ltykernel@gmail.com>
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
  Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
  x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
  hyper-v: Enable swiotlb bounce buffer for Isolation VM
  scsi: storvsc: Add Isolation VM support for storvsc driver
  net: netvsc: Add Isolation VM support for netvsc driver

 arch/x86/hyperv/hv_init.c         |  10 +++
 arch/x86/hyperv/ivm.c             |  28 ++++++
 arch/x86/kernel/cc_platform.c     |  12 +++
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
 15 files changed, 300 insertions(+), 22 deletions(-)

-- 
2.25.1

