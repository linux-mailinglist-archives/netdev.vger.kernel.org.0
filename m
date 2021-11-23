Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C645A5AD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbhKWOdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbhKWOdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:33:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC13C061714;
        Tue, 23 Nov 2021 06:30:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id iq11so16743311pjb.3;
        Tue, 23 Nov 2021 06:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bsx4hw5NbHCVF2W/NeRmzNghpOYrhv8l8EVf1kn67w=;
        b=cvvJrI1QX3F1CXlrV/8eUkgWUDHfoWCFWFkSOpXBjzB6SsWy2BUpETC33HUCl3JzTF
         kIURt3zkpyvrRd5BJrEeSEm/UeNRI0jzQJP0m2xbAh8qArEft0zYP0V+cQBtcAs7BgXe
         hubXmlepTZ1/aixT1F0M57MbeLtKiw9eZqaaKWVLz4jMeIT5j4lV5bD107ayuaXbeECP
         rtuzlbe5kcIN2LU3rSq94rECq16TEjPrQ9ly9dNq7guAar0qlH4KasIVmcb4DLprmlVi
         Ps4+1+L6gpTnOxtdD/M0ImoIgHwuJ6I7ONj72SCZBB3ifD4OS0vdnWkEqF1QPkouSXf+
         SJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bsx4hw5NbHCVF2W/NeRmzNghpOYrhv8l8EVf1kn67w=;
        b=lt08ogWPaIitCbbBBHLokMSfYqAdE/TGvoM6jFVZyiF57syxcVLx8jMITydRrK9GPx
         6TpB2mo/3xsZXx8Ayk6nrcC5gkqfJzuNFFsTSPCIKyyqtS7RfUlyB3p/tpEuJDznODki
         rg7cFrtAdwfr5IMS10gbR24Fepo4gk6h833nxxAW/IiHNJNHr7w4AcMQayWnrEkuggI7
         tf8lDz/j2A8I6IZJPc6jLJ6j6gNkHErx63+vohypX2WOXgONsLTmMDxWRkkJS1ZfiQYI
         0a1s+2CJPrATJK0EuSpv0PbCoKl1XyH+uR/Ird/BILpDV0AEqRR+lnn4CI/B5ZRvYHew
         ME6g==
X-Gm-Message-State: AOAM532G1kw2JgKE5vL1cllWslxD5gMgS4SLMwZKAJj3bDHcESPxdjMP
        LIqwZ8jma+9cWAylsqc6deY=
X-Google-Smtp-Source: ABdhPJynwRwiHm1UVLqQsERKisSlFY0WvQFTxlH3IfWaqqHV5AmDuFLcHWKC+Om+8FB9dQD/WFJFWg==
X-Received: by 2002:a17:902:a60b:b0:142:7621:be0b with SMTP id u11-20020a170902a60b00b001427621be0bmr7298513plq.58.1637677841802;
        Tue, 23 Nov 2021 06:30:41 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:af65:c3d4:6df:5a8b])
        by smtp.gmail.com with ESMTPSA id j13sm11926127pfc.151.2021.11.23.06.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:30:41 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        xen-devel@lists.xenproject.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V2 0/6] x86/Hyper-V: Add Hyper-V Isolation VM support(Second part)
Date:   Tue, 23 Nov 2021 09:30:31 -0500
Message-Id: <20211123143039.331929-1-ltykernel@gmail.com>
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

Change since v1:
     * Add Hyper-V Isolation support check in the cc_platform_has()
       and return true for guest memory encrypt attr.
     * Remove hv isolation check in the sev_setup_arch()

Tianyu Lan (6):
  Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM
  dma-mapping: Add vmap/vunmap_noncontiguous() callback in dma ops
  x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
  hyperv/IOMMU: Enable swiotlb bounce buffer for Isolation VM
  net: netvsc: Add Isolation VM support for netvsc driver
  scsi: storvsc: Add Isolation VM support for storvsc driver

 arch/x86/kernel/cc_platform.c     |  15 +++
 arch/x86/mm/mem_encrypt.c         |   1 +
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
 kernel/dma/swiotlb.c              |  53 ++++++++-
 15 files changed, 482 insertions(+), 41 deletions(-)

-- 
2.25.1

