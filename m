Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AE835E29E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346601AbhDMPW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhDMPWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:22:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C63C061574;
        Tue, 13 Apr 2021 08:22:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e2so4095736plh.8;
        Tue, 13 Apr 2021 08:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+srfers9E9q4+P9qtsCb4JStuWkS4WZj6vAcaSoVbMo=;
        b=BxpjZ6O/1c8XzgIAhlhju9pI7snp8yqWAuS8roa86byjm18CBnlXvlPSDp4K9ogLCA
         md0ln4yPw4zxAALH2i/ba9zXaZ6xqI5anhWQWsKTyXcjTA4PqPlOPAz4bVVBRKUdz1dw
         tFv19azdKvuMaVlNG1M78WQRzIKeeH2Yd81Lo+4JqXIkRzd++1sVVqFjHEHAnlc2uZmg
         hcNXFAYNfdrNLJ9IdG6DrMk0dn1h0KZrWl939rgLUvGMphJGsxCbkLNsZt8n2KWAvdOh
         pTS12g3TaF9aS/Undgp9qlRJeG/Q3B5s2DllAhmLTGxzifFjsah62AIskhiq0qHFiaLJ
         lQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+srfers9E9q4+P9qtsCb4JStuWkS4WZj6vAcaSoVbMo=;
        b=HmyGXZQmtTvMQLQGxb4DSjP8l5Vix1vIWjnzNmZtkqTELoCmL4skNoNX6DMvPc3oJd
         fyTKI5b4xeT1dhkXa84H6SnJCJ3L0KE1N7B7MVobQgYCykMzSSlc6w/xNOk2jdQfkIFl
         /gEhelfl1aVCdTSC4yitwO+pSAivHuO6SdmgxdECkEIb2wzo3KkMZi42+zfawmcWi0Dp
         eMSlQpP8ItpmtTZ9zKRuUVagI8kbGysHebUXXpsC5o+KF7MaEZJdG3S/zIzeuGKOjJl1
         b0Fzi4l0+O9I8T1XspWmd7LGSqsfbuEC1R++0GkJ1rYa89l/D8m3RlSMqR1utOj9W9Ro
         cVZg==
X-Gm-Message-State: AOAM531XT9aWFkheiyqCeqwHsbm3xq8GtkvYbBSTxyEXnx3+WeXrPzed
        8QB5fB2hQk14d1rYCDj14+E=
X-Google-Smtp-Source: ABdhPJxkj7EMiqnlNwZhemaad9k8TJwF36mYJkC/cilAzSTY6lmSj1a708p3PUSfYTswP4gAS4KdrA==
X-Received: by 2002:a17:90a:5407:: with SMTP id z7mr581197pjh.228.1618327353881;
        Tue, 13 Apr 2021 08:22:33 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:5b29:fe1a:45c9:c61c])
        by smtp.gmail.com with ESMTPSA id y3sm12882026pfg.145.2021.04.13.08.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 08:22:33 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [RFC V2 PATCH 00/12] x86/Hyper-V: Add Hyper-V Isolation VM support
Date:   Tue, 13 Apr 2021 11:22:05 -0400
Message-Id: <20210413152217.3386288-1-ltykernel@gmail.com>
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
and IO stack memory. So mark vmbus channel ring buffer visible to
host.

There are two exceptions - packets sent by vmbus_sendpacket_
pagebuffer() and vmbus_sendpacket_mpb_desc(). These packets
contains IO stack memory address and host will access these memory.
So add Hyper-V DMA Ops and use DMA API in the netvsc and storvsc
drivers to allocate bounce buffer via swiotlb interface.

For SNP isolation VM, guest needs to access the shared memory via
extra address space which is specified by Hyper-V CPUID HYPERV_CPUID_
ISOLATION_CONFIG. The access physical address of the shared memory
should be bounce buffer memory GPA plus with shared_gpa_boundary
reported by CPUID.

Change since v1:
       * Add DMA API support in the netvsc and storvsc driver.
       * Add Hyper-V DMA ops.
       * Add static branch for the check of isolation type snp.
       * Fix some code style comments.

Tianyu Lan (12):
  x86/HV: Initialize GHCB page in Isolation VM
  x86/HV: Initialize shared memory boundary in Isolation VM
  x86/Hyper-V: Add new hvcall guest address host visibility support
  HV: Add Write/Read MSR registers via ghcb
  HV: Add ghcb hvcall support for SNP VM
  HV/Vmbus: Add SNP support for VMbus channel initiate message
  HV/Vmbus: Initialize VMbus ring buffer for Isolation VM
  UIO/Hyper-V: Not load UIO HV driver in the isolation VM.
  swiotlb: Add bounce buffer remap address setting function
  HV/IOMMU: Add Hyper-V dma ops support
  HV/Netvsc: Add Isolation VM support for netvsc driver
  HV/Storvsc: Add Isolation VM support for storvsc driver

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  70 +++++--
 arch/x86/hyperv/ivm.c              | 289 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  22 +++
 arch/x86/include/asm/mshyperv.h    |  90 +++++++--
 arch/x86/kernel/cpu/mshyperv.c     |   5 +
 arch/x86/kernel/pci-swiotlb.c      |   3 +-
 drivers/hv/channel.c               |  44 ++++-
 drivers/hv/connection.c            |  68 ++++++-
 drivers/hv/hv.c                    |  73 ++++++--
 drivers/hv/hyperv_vmbus.h          |   3 +
 drivers/hv/ring_buffer.c           |  83 ++++++---
 drivers/hv/vmbus_drv.c             |   3 +
 drivers/iommu/hyperv-iommu.c       | 127 +++++++++++++
 drivers/net/hyperv/hyperv_net.h    |  11 ++
 drivers/net/hyperv/netvsc.c        | 137 +++++++++++++-
 drivers/net/hyperv/rndis_filter.c  |   3 +
 drivers/scsi/storvsc_drv.c         |  67 ++++++-
 drivers/uio/uio_hv_generic.c       |   5 +
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  18 +-
 include/linux/hyperv.h             |  12 +-
 include/linux/swiotlb.h            |   5 +
 kernel/dma/swiotlb.c               |  13 +-
 mm/ioremap.c                       |   1 +
 mm/vmalloc.c                       |   1 +
 26 files changed, 1068 insertions(+), 88 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

-- 
2.25.1

