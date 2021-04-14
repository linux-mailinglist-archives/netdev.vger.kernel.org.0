Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E02F35F69E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349964AbhDNOus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhDNOuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:46 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A0AC061756;
        Wed, 14 Apr 2021 07:50:24 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w8so7905312plg.9;
        Wed, 14 Apr 2021 07:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LNgcA9L88xzjpALKOwngs/ZZOUv2+a7fU6REsc6ybGE=;
        b=Kat+1cK16+lA3fCdvi1QgvBekDwhFQI9zTdR95B/p5DxNaEeytnPDLuc8bIDW4qaNZ
         7MpGRgPVZJzbiZWX/2tPApbjldX4DT/yH2etG5/hd1N3IIZI8QH+wVoqgqhWp0lF9zhF
         CYGHyy10+pifT7vPIU8a1YJKBRRKjCFoFUlwqa0ZYU1zKN1P0MSOE2YG3UYx6CrVAeTs
         S/3QmZA+TgI/n5i8fooUaW/2BE5mCZdJELj+D7VrR0e2/FBSyNvZpxE7D+wE8EzB8Mu4
         JRbfzHGuUKsnRr6MReu4PWeuJtTyvI2ywUjv+b0j2IkcSFIsSs16cK++DMmmd0ZF0Exz
         D8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LNgcA9L88xzjpALKOwngs/ZZOUv2+a7fU6REsc6ybGE=;
        b=m1ZqPV7969LyKGXgpi49ZNgCF8g1xBuRJi/Cfe0k96iuE5W/jdkAu7h2WYqLShg4gW
         tA00BNRfJLBAq1ZCDmSkqQXfHZP0tIkAfG/feiZWAayXQUxSV1UUg59NNrhY6FDpUa7f
         XUuzTnJbMH5/Z8B8a7rSvH7aMohWWpK547/sahONcrv5wc2ZtAWOKWPVaadqcADUSsuC
         CeUcwIzDTNmnaCNJjPBlWo/3owVaoRPRKPaTVD5ywVfapKET4ZAC+Clw7TYtCyoOgI/9
         YStRONSlide5WATncJWlw55HTO1S3wWxOBQU8SgWe9v3X//cqZSblttuAhHCoqAuNaSN
         TNzQ==
X-Gm-Message-State: AOAM533EXra0ETr7af62DPrrAczB17AGdpUPIi4xaLJNn49L7MHlYYBU
        kAhmogn4HEWpJfmWzZNivF8=
X-Google-Smtp-Source: ABdhPJwAcY4DhPfoRZeotqpbll3PUeqlXCvJZF6LQPCij0BG2ENhkips5kIT10gOWWvPvHcpnEMIUA==
X-Received: by 2002:a17:902:f687:b029:e8:da63:6195 with SMTP id l7-20020a170902f687b02900e8da636195mr38390847plg.75.1618411824189;
        Wed, 14 Apr 2021 07:50:24 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:23 -0700 (PDT)
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
Subject: [Resend RFC PATCH V2 00/12] x86/Hyper-V: Add Hyper-V Isolation VM support
Date:   Wed, 14 Apr 2021 10:49:33 -0400
Message-Id: <20210414144945.3460554-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

"Resend all patches because someone in CC list didn't receive all
patchset. Sorry for nosy."

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

