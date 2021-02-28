Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375663272BE
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhB1PFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhB1PEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:04:54 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB63C06174A;
        Sun, 28 Feb 2021 07:04:12 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u18so2055505plc.12;
        Sun, 28 Feb 2021 07:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dvx8sVFIDRwA8HVv8xs6M9vOFGJJY4qZU9vG5iVcN/Y=;
        b=YsLAgDSNMyIOu25iL5HDcBHtEXYrJHnLmdyiqj1AARPg/PfsaJRNxva/ZmUaVRdoHv
         rLkWgBcdz1Yrs/KlgNnltALdC4XAmlJUO2eW3dZuSTOvJgoo7TutGtB7KMtcvhKlkk4D
         YAi7rWCAedue4X5LMIe/VeMgG1eKG5toeZARu1a6Cov0xPzJlSFtI+7JlZGwqxWjk7UO
         /9Y4RXC1tJZQ6aH44tBe4XGScQbMLQJyWuVd15aQ58fCSXCqGm0XH4w79CcNAG2EJkJV
         SQpQK5Z9SyaL1SCQOI78U01EW4Q3Myc/0sx6HjYIAR12WdeSidWSmehInifKRV7ROz4p
         u3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dvx8sVFIDRwA8HVv8xs6M9vOFGJJY4qZU9vG5iVcN/Y=;
        b=OOfBU7ePH+U0995OjVNzGlfeWgsDPrCg27Hhu/peuniZLuwExuh3s/+oCWMm7jI1u+
         WFYwkbkBeSkBsbMbpZaqlhe53AYNx/V5VfGyNMaXbj2kg7BvS7w8W6bIySCMHyRahwit
         +AZeMcx49u/OPtlawECwFAdf6u4qWn5uchGeO1eTWtrfgRRyFY0OHQcuPuMMJnm+XZQo
         s6E74pjYLOHwpkvl0QMQb6OhTPy1/aSOgEzQN0jzSlTPF2NIrA0N1JiuXyDDrNFhtueJ
         XVrRR/LqjwBzXDsr2oHTscy+fqd5S/G1me4JUlFXDNKkzuXkbM8gSkg/ikzV1R1m5myD
         pZbQ==
X-Gm-Message-State: AOAM532A7l62AJ+pBvlKGh3N5+KrfsFwAm1tXtrtTfOkXEe+q8Kl4gqs
        9vwJN62DXCwmqBIbUZyJexo=
X-Google-Smtp-Source: ABdhPJx9/Zp+U49TtzTJQxCqHd5e6WrN5zxO4e73fPvqhTp4oeAJQVgJ5GrOQDMc7rVs1BQ0aBf5RA==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr11255886pjn.151.1614524651791;
        Sun, 28 Feb 2021 07:04:11 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:561f:afde:af07:8820])
        by smtp.gmail.com with ESMTPSA id 142sm8391331pfz.196.2021.02.28.07.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 07:04:11 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [RFC PATCH 00/12] x86/Hyper-V: Add Hyper-V Isolation VM support    
Date:   Sun, 28 Feb 2021 10:03:03 -0500
Message-Id: <20210228150315.2552437-1-ltykernel@gmail.com>
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

Tianyu Lan (12):
  x86/Hyper-V: Add visibility parameter for vmbus_establish_gpadl()
  x86/Hyper-V: Add new hvcall guest address host visibility support
  x86/HV: Initialize GHCB page and shared memory boundary
  HV: Add Write/Read MSR registers via ghcb
  HV: Add ghcb hvcall support for SNP VM
  HV/Vmbus: Add SNP support for VMbus channel initiate message
  hv/vmbus: Initialize VMbus ring buffer for Isolation VM
  x86/Hyper-V: Initialize bounce buffer page cache and list
  x86/Hyper-V: Add new parameter for
    vmbus_sendpacket_pagebuffer()/mpb_desc()
  HV: Add bounce buffer support for Isolation VM
  HV/Netvsc: Add Isolation VM support for netvsc driver
  HV/Storvsc: Add bounce buffer support for Storvsc

 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |  70 +++-
 arch/x86/hyperv/ivm.c              | 257 ++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  22 +
 arch/x86/include/asm/mshyperv.h    |  26 +-
 arch/x86/kernel/cpu/mshyperv.c     |   2 +
 drivers/hv/Makefile                |   2 +-
 drivers/hv/channel.c               | 103 ++++-
 drivers/hv/channel_mgmt.c          |  30 +-
 drivers/hv/connection.c            |  68 +++-
 drivers/hv/hv.c                    | 196 ++++++---
 drivers/hv/hv_bounce.c             | 619 +++++++++++++++++++++++++++++
 drivers/hv/hyperv_vmbus.h          |  42 ++
 drivers/hv/ring_buffer.c           |  83 +++-
 drivers/net/hyperv/hyperv_net.h    |   5 +
 drivers/net/hyperv/netvsc.c        | 111 +++++-
 drivers/scsi/storvsc_drv.c         |  46 ++-
 drivers/uio/uio_hv_generic.c       |  13 +-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |  24 +-
 include/linux/hyperv.h             |  46 ++-
 mm/ioremap.c                       |   1 +
 mm/vmalloc.c                       |   1 +
 23 files changed, 1614 insertions(+), 156 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c
 create mode 100644 drivers/hv/hv_bounce.c

-- 
2.25.1

