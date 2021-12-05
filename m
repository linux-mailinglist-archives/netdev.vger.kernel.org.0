Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5D4689EA
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhLEIVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhLEIVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:21:45 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D051FC061751;
        Sun,  5 Dec 2021 00:18:18 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p13so7227024pfw.2;
        Sun, 05 Dec 2021 00:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dfM94A9YIlyVB8rT/Fyc0cGVK5U5XvE0VXTSezF6RKs=;
        b=XjtWZ4TQugWlqSvIgCkbqi7HQ5b8zuwuwua6IwpffcpwfAyDaobtNwXYuWcvpbBFE4
         9WcjLsStsKid77+RD2YC7kd02/pHapke3O37ldqGjOQxX3qpaITr2seyiQsoxB3w7Wc0
         p/CMzw4L9gQcgza+P0xpVKrvTkJmfwAcQbe9cdQN/96UJkevU198ptb2fql3Nl42vmjo
         z6E4jbyPJsG1mpx5G3qbcemu+YT6WaxTXXHQPNWZTvdAzgx2cPqLhcMeWwsECq7ROn0S
         jdr1XwQiTJQJh0m1FBJbpNlLwobl8Bf+uppKRO+fqeRzV4k1EfksDNQY4LqGbBl9E3qY
         gIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dfM94A9YIlyVB8rT/Fyc0cGVK5U5XvE0VXTSezF6RKs=;
        b=zuWuoX2NbwIId9oicoa/ugoU9x+2YE/KDTe4Z2x3pZQKJrMpU/CTlCn6zzltx+LXp5
         sMLAp8WDeuE1vqsxHyLNxD2OuIjsrYvvFtQ0j/eAc8lU6NT1BG0nJpgm3X9pv+pzcKzE
         n5JYnfOzFNdjI4ueBBYmXpP6W5z+/eeqwKuMhbtv4hZcL+MFvwzbabLpfqyoThuk7jC3
         HSuW6/n9P91byfrLLwus6cDidw3QgrtHnGc7MU4CUgTo7/wxkFHKHybShalZt5UF8xap
         4ftDRdJYOc7bUGglLQTKG5S9DpIg+yOr724HnON4iSv9IEOfG0KW1tmUZlu1FVHVJVEp
         IV2Q==
X-Gm-Message-State: AOAM532nedNMOz57s7JsgaPDtX0ZMBmXo8o3fvIScNWcSshw/2vRoERF
        l8ZtKFtx3hElOjDn4z9lM5Y=
X-Google-Smtp-Source: ABdhPJx1nL+30YTsDOKE6LJfYcCpMeKCOeoz9AVpsf63uFFgijhWvJ6bOiQ0k+V3CXM4JXAEUKtCKw==
X-Received: by 2002:aa7:8755:0:b0:494:67a6:1c84 with SMTP id g21-20020aa78755000000b0049467a61c84mr28292360pfo.26.1638692297989;
        Sun, 05 Dec 2021 00:18:17 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:87aa:e334:f070:ebca])
        by smtp.gmail.com with ESMTPSA id s8sm6439905pgl.77.2021.12.05.00.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 00:18:17 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 0/5] x86/Hyper-V: Add Hyper-V Isolation VM support(Second part)
Date:   Sun,  5 Dec 2021 03:18:08 -0500
Message-Id: <20211205081815.129276-1-ltykernel@gmail.com>
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
  hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
  scsi: storvsc: Add Isolation VM support for storvsc driver
  hv_netvsc: Add Isolation VM support for netvsc driver

 arch/x86/hyperv/ivm.c             |  28 ++++++
 arch/x86/kernel/cc_platform.c     |  12 +++
 arch/x86/xen/pci-swiotlb-xen.c    |  12 ++-
 drivers/hv/hv_common.c            |  11 +++
 drivers/hv/vmbus_drv.c            |   4 +
 drivers/iommu/hyperv-iommu.c      |  58 +++++++++++++
 drivers/net/hyperv/hyperv_net.h   |   5 ++
 drivers/net/hyperv/netvsc.c       | 136 +++++++++++++++++++++++++++++-
 drivers/net/hyperv/netvsc_drv.c   |   1 +
 drivers/net/hyperv/rndis_filter.c |   2 +
 drivers/scsi/storvsc_drv.c        |  37 ++++----
 include/asm-generic/mshyperv.h    |   2 +
 include/linux/hyperv.h            |  14 +++
 include/linux/swiotlb.h           |   6 ++
 kernel/dma/swiotlb.c              |  43 +++++++++-
 15 files changed, 349 insertions(+), 22 deletions(-)

-- 
2.25.1

