Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C184535F3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbhKPPm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbhKPPm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:42:27 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9524C061570;
        Tue, 16 Nov 2021 07:39:29 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so17965232pga.1;
        Tue, 16 Nov 2021 07:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ytk8p6TdYJp6Y0bV41yrFTfo+pk8rHAune+7pZw0P98=;
        b=BXz0KFtLleSQa3skiYw7QDE1dXPqvkgmZsVeu4fLM5Yo+p5BS9ZqK8GmlqMk8KB2Jd
         MbFA1Sdyl8HeuFhTjRLnnl3I6jVDF41fuFlW3H6A+W4gc2Uds+KPsc9KT7JcuhVGbq/t
         XAcYRH7ZrHrS/7eajwuW1ku+LBiQ4Qc+oXHnk0LQfeobjP2mtKBjazQ5Ojyz1ZP9PGUs
         KqRxaCIQx43OP4enShtmT5F7s37Tk9u+0bvcviYRxBqU7AdqBL5xPuBzLRr/J69QC52x
         9+z78bSAAsg3A9UtUTA6eQyj+jhqQGR/7QgyARigUS1/lv1vKxm9S0dnSLpOzn5YgjJU
         DsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ytk8p6TdYJp6Y0bV41yrFTfo+pk8rHAune+7pZw0P98=;
        b=ZLcVKwGnspGtceEcGpeDPJORKyliPJ8hDKkWE6QOk83DiNWKS2u3lcWwHsROLptgum
         WnjYWp50EUZPlL1NUrIGoR/9quP6r5IFzkAqFskWkiOn6fye1K94OGlqHI1j3tuyu5HG
         uxRI48W06U4qj2JC5yPoA0WfSHG7SCLr0rDJqqzZZch9jLK4JpLpG6dy0nAcs3y6rucL
         /ueYqGd8NtysaA/qrnDnbTADPSqxKE91YLXK4AkvCNPpdkkLYFIQcbC8QmHOmvyYDrc3
         6taKyo+hcvfqPrqNF0c11q9RFpD3zA9OhU5n225wC/hswbcB1J+i+ABiZShD3BP+2C1q
         CA/g==
X-Gm-Message-State: AOAM5317EGmJMaLbcPRnyWezQ1Im0Kfcsps9EULUV0YJQ61aH8r30vUw
        mCupLe2IqLsgnd4y7qiJDjI=
X-Google-Smtp-Source: ABdhPJwz59YenP80sWYPo5tTasO7qod/XFwabISMwdQ71s0CE7pvGan1FvjN3qeawYe/WCw9pDZXgA==
X-Received: by 2002:a62:5215:0:b0:49f:a996:b724 with SMTP id g21-20020a625215000000b0049fa996b724mr40917927pfb.3.1637077166648;
        Tue, 16 Nov 2021 07:39:26 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:3:57e4:b776:c854:76dd])
        by smtp.gmail.com with ESMTPSA id x64sm1981948pfd.151.2021.11.16.07.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:39:25 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
Subject: [PATCH 0/5] x86/Hyper-V: Add Hyper-V Isolation VM support(Second part)
Date:   Tue, 16 Nov 2021 10:39:18 -0500
Message-Id: <20211116153923.196763-1-ltykernel@gmail.com>
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
in Isolation VM. Add Hyper-V dma ops and provide dma_alloc/free_
noncontiguous and vmap/vunmap_noncontiguous callback. Allocate
rx/tx ring via dma_alloc_noncontiguous() and map them into extra
address space via dma_vmap_noncontiguous().

Tianyu Lan (5):
  x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
  dma-mapping: Add vmap/vunmap_noncontiguous() callback in dma ops
  hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
  net: netvsc: Add Isolation VM support for netvsc driver
  scsi: storvsc: Add Isolation VM support for storvsc driver

 arch/x86/mm/mem_encrypt.c         |   4 +-
 arch/x86/xen/pci-swiotlb-xen.c    |   3 +-
 drivers/hv/Kconfig                |   1 +
 drivers/hv/vmbus_drv.c            |   6 +
 drivers/iommu/hyperv-iommu.c      | 164 +++++++++++++++++++++++++
 drivers/net/hyperv/hyperv_net.h   |   5 +
 drivers/net/hyperv/netvsc.c       | 192 +++++++++++++++++++++++++++---
 drivers/net/hyperv/rndis_filter.c |   2 +
 drivers/scsi/storvsc_drv.c        |  37 +++---
 include/linux/dma-map-ops.h       |   3 +
 include/linux/hyperv.h            |  17 +++
 include/linux/swiotlb.h           |   6 +
 kernel/dma/mapping.c              |  18 ++-
 kernel/dma/swiotlb.c              |  75 ++++++++++--
 14 files changed, 488 insertions(+), 45 deletions(-)

-- 
2.25.1

