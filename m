Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4D47217F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 08:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhLMHOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 02:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbhLMHOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 02:14:25 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C641C06173F;
        Sun, 12 Dec 2021 23:14:25 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l10so2793608pgm.7;
        Sun, 12 Dec 2021 23:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IQVoqBhkMbv3k6OINJ2ThuqOwq/2RghajB/JhTjJmPQ=;
        b=Wqo7YQm2zeFPL0nGRQ/1URjIGV8BliGhkhdwTOPCx+dpnrZLSgG0HCHKgoLI9zbofo
         aV5IVmqv59n6PYoyDMvfYZndvTANTvaQ2r1FFbcM59xXA9I+6SVsk7aGhru5Ixr2ZOfk
         NPZxOHQI5ytzgfG19WNv00a0yPiz2hMK/Lk61MLyNt4pxZIXS0ZHYOS4shfjMxwFsfrP
         BK7BnsVmr9wHf2qjlrukAaSDtQqW8Ttc3ZkIUmSqdgdD5tka5pWHqCY6TUrXt7qzIgOK
         vB8iuXXW7qJ4yoGYBB/46YSezALc7eN0IH0LiDdUHJax3AuetajCPak/tRv2gnMO9IQ4
         tM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IQVoqBhkMbv3k6OINJ2ThuqOwq/2RghajB/JhTjJmPQ=;
        b=NVVrLqH6NUJi4gw5P1MykSU+PEqEOIUxahwYkMNimjdE2ozHJb8lRN1PiFKcYoITfT
         oa49/KWKABD+qFroOAvsqWnGK4t++nl7SjsXNdcvrog81lJ8H9uhsht0kp0fddGRnAre
         /ZETraRM3U61UAhBN1Eiy1pJxk0h3MVY4ZgkT3HY4iccIWgkTt8582U3dZYwxE0YI3Lf
         lgPEha9cbsgTah/b6q/aTCsvUUaTkqmuKzxtaty0jI1M8V+ROM8oOG2+GIXTeNtjRYh9
         qRpE3CJTeW2cGyrycPFRZ7Cy+PMZdokvAHOIqQVvRNn0nzO+xlGqJ/vnSccxL5SWEZsG
         pWLQ==
X-Gm-Message-State: AOAM531jl6DZqSp6+ovB0etCboLPGFw78YMsc5EDgEj3wQPfb5QOUybK
        vZI0vgfHvn8LkuAM5b1HUBU=
X-Google-Smtp-Source: ABdhPJwjAKWpKihnmAu8aWL3L+K1y3yAYsNTpxjg65IVsLLMsSna5L5XMs9r0umkWQIy2E3STqhOUQ==
X-Received: by 2002:a63:4a4b:: with SMTP id j11mr51473120pgl.580.1639379664613;
        Sun, 12 Dec 2021 23:14:24 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:a586:a4cb:7d3:4f27])
        by smtp.gmail.com with ESMTPSA id qe12sm6079401pjb.29.2021.12.12.23.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 23:14:24 -0800 (PST)
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
Subject: [PATCH V7 3/5] hyper-v: Enable swiotlb bounce buffer for Isolation VM
Date:   Mon, 13 Dec 2021 02:14:04 -0500
Message-Id: <20211213071407.314309-4-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213071407.314309-1-ltykernel@gmail.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

hyperv Isolation VM requires bounce buffer support to copy
data from/to encrypted memory and so enable swiotlb force
mode to use swiotlb bounce buffer for DMA transaction.

In Isolation VM with AMD SEV, the bounce buffer needs to be
accessed via extra address space which is above shared_gpa_boundary
(E.G 39 bit address line) reported by Hyper-V CPUID ISOLATION_CONFIG.
The access physical address will be original physical address +
shared_gpa_boundary. The shared_gpa_boundary in the AMD SEV SNP
spec is called virtual top of memory(vTOM). Memory addresses below
vTOM are automatically treated as private while memory above
vTOM is treated as shared.

Swiotlb bounce buffer code calls set_memory_decrypted()
to mark bounce buffer visible to host and map it in extra
address space via memremap. Populate the shared_gpa_boundary
(vTOM) via swiotlb_unencrypted_base variable.

The map function memremap() can't work in the early place
(e.g ms_hyperv_init_platform()) and so call swiotlb_update_mem_
attributes() in the hyperv_init().

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v6:
        * Fix compile error when swiotlb is not enabled.

Change since v4:
	* Remove Hyper-V IOMMU IOMMU_INIT_FINISH related functions
	  and set SWIOTLB_FORCE and swiotlb_unencrypted_base in the
	  ms_hyperv_init_platform(). Call swiotlb_update_mem_attributes()
	  in the hyperv_init().

Change since v3:
	* Add comment in pci-swiotlb-xen.c to explain why add
	  dependency between hyperv_swiotlb_detect() and pci_
	  xen_swiotlb_detect().
	* Return directly when fails to allocate Hyper-V swiotlb
	  buffer in the hyperv_iommu_swiotlb_init().
---
 arch/x86/hyperv/hv_init.c      | 12 ++++++++++++
 arch/x86/kernel/cpu/mshyperv.c | 15 ++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 24f4a06ac46a..749906a8e068 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -28,6 +28,7 @@
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 #include <linux/highmem.h>
+#include <linux/swiotlb.h>
 
 int hyperv_init_cpuhp;
 u64 hv_current_partition_id = ~0ull;
@@ -502,6 +503,17 @@ void __init hyperv_init(void)
 
 	/* Query the VMs extended capability once, so that it can be cached. */
 	hv_query_ext_cap(0);
+
+#ifdef CONFIG_SWIOTLB
+	/*
+	 * Swiotlb bounce buffer needs to be mapped in extra address
+	 * space. Map function doesn't work in the early place and so
+	 * call swiotlb_update_mem_attributes() here.
+	 */
+	if (hv_is_isolation_supported())
+		swiotlb_update_mem_attributes();
+#endif
+
 	return;
 
 clean_guest_os_id:
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 4794b716ec79..e3a240c5e4f5 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -18,6 +18,7 @@
 #include <linux/kexec.h>
 #include <linux/i8253.h>
 #include <linux/random.h>
+#include <linux/swiotlb.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv-tlfs.h>
@@ -319,8 +320,20 @@ static void __init ms_hyperv_init_platform(void)
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
 
-		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP) {
 			static_branch_enable(&isolation_type_snp);
+#ifdef CONFIG_SWIOTLB
+			swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
+#endif
+		}
+
+#ifdef CONFIG_SWIOTLB
+		/*
+		 * Enable swiotlb force mode in Isolation VM to
+		 * use swiotlb bounce buffer for dma transaction.
+		 */
+		swiotlb_force = SWIOTLB_FORCE;
+#endif
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
-- 
2.25.1

