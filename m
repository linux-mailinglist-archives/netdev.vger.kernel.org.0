Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6FD469845
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343712AbhLFOPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbhLFOPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:15:25 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F9BC0611F7;
        Mon,  6 Dec 2021 06:11:55 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j11so10587767pgs.2;
        Mon, 06 Dec 2021 06:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FlswnO/0tf48MZik9N6nEWD7pUN7KQPdPDwLH82NPGY=;
        b=nkkXE8gwlwTd7VNKG/1y4Hw9Y6hfahQ9CV6yj7y5Vu0XMeXKiGNyYC9OrUO8UUDRZL
         /2Mepwb7nzzHNYONlX9cDXW5s9yHrtLIuErNVpm2VVV65+3RkVwR/MesiBqiqnUapO1B
         FgEEHjh8PTHWoQ1tnyZK2dba/VztoCw/UvD9YWtB5V0z+icr5ZNKk8KzW5MQgJHlfKj3
         RWjtqrgG5rtg+wnXryjuOhuEd2JgxaDyN8OU6SQDzialBq6Gzf7H/NbhcFqCXmVy1Zic
         rI35McKVFhxk+N3DKkRNNSQ420Eh2lBJQuT7CmK6cDtKpWxpXHzgkYaY5/UvFSxgss0l
         b/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FlswnO/0tf48MZik9N6nEWD7pUN7KQPdPDwLH82NPGY=;
        b=xlvITt1/NpZd0903iFwS6MRWLPaqEELWMEoNnPgHflCBDymAqbkBtRTfptlomGmfmL
         8NUGtlR0iiX/rGWF3B0LC3tPx44WmSwSDHdDgDPj5yp3qGBjaLc1dH3x5kUrh5Ng0SOd
         lmqUPPhFmvsm4sNnSJqKDxOHvhJ85SY7HOffnyFLiWWNsvXmZfiF4Qpa1algmbfXY9nI
         U2RozDGOOAdzaS4p0LK1nTBtaICnsggw71wyuRigoyfOYT0NQxvesFuH7GG8bDKNbKtZ
         vCnfuHM7Wh5DADnDiVlpGJiQXTIE+c7OgWmOPpEO/MiumWzYfoB5UqkSn+w6p+ZVu3Xs
         JNmA==
X-Gm-Message-State: AOAM5335uFiStEmalADKPXu/u2poPPFrQmuQ3c5Z58g1MUfX+yXrwUD7
        k6WNOYadB618quxpD4yMFQI=
X-Google-Smtp-Source: ABdhPJy31Gmm2fqzGROEhE6zYObz60BbYyxN7Amv0942JG9FaBxwHHPRmYzrVgz+xUQ+jhelmcGClA==
X-Received: by 2002:a63:5813:: with SMTP id m19mr18611695pgb.451.1638799915428;
        Mon, 06 Dec 2021 06:11:55 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:b5b5:3f40:cec1:40a0])
        by smtp.gmail.com with ESMTPSA id g19sm7717606pfc.145.2021.12.06.06.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 06:11:55 -0800 (PST)
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
Subject: [PATCH V5 3/5] hyper-v: Enable swiotlb bounce buffer for Isolation VM
Date:   Mon,  6 Dec 2021 09:11:43 -0500
Message-Id: <20211206141145.447453-4-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206141145.447453-1-ltykernel@gmail.com>
References: <20211206141145.447453-1-ltykernel@gmail.com>
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
 arch/x86/hyperv/hv_init.c      | 10 ++++++++++
 arch/x86/kernel/cpu/mshyperv.c | 11 ++++++++++-
 include/linux/hyperv.h         |  8 ++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 24f4a06ac46a..9e18a280f89d 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -28,6 +28,7 @@
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 #include <linux/highmem.h>
+#include <linux/swiotlb.h>
 
 int hyperv_init_cpuhp;
 u64 hv_current_partition_id = ~0ull;
@@ -502,6 +503,15 @@ void __init hyperv_init(void)
 
 	/* Query the VMs extended capability once, so that it can be cached. */
 	hv_query_ext_cap(0);
+
+	/*
+	 * Swiotlb bounce buffer needs to be mapped in extra address
+	 * space. Map function doesn't work in the early place and so
+	 * call swiotlb_update_mem_attributes() here.
+	 */
+	if (hv_is_isolation_supported())
+		swiotlb_update_mem_attributes();
+
 	return;
 
 clean_guest_os_id:
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 4794b716ec79..baf3a0873552 100644
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
@@ -319,8 +320,16 @@ static void __init ms_hyperv_init_platform(void)
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
 
-		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP) {
 			static_branch_enable(&isolation_type_snp);
+			swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
+		}
+
+		/*
+		 * Enable swiotlb force mode in Isolation VM to
+		 * use swiotlb bounce buffer for dma transaction.
+		 */
+		swiotlb_force = SWIOTLB_FORCE;
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b823311eac79..1f037e114dc8 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1726,6 +1726,14 @@ int hyperv_write_cfg_blk(struct pci_dev *dev, void *buf, unsigned int len,
 int hyperv_reg_block_invalidate(struct pci_dev *dev, void *context,
 				void (*block_invalidate)(void *context,
 							 u64 block_mask));
+#if IS_ENABLED(CONFIG_HYPERV)
+int __init hyperv_swiotlb_detect(void);
+#else
+static inline int __init hyperv_swiotlb_detect(void)
+{
+	return 0;
+}
+#endif
 
 struct hyperv_pci_block_ops {
 	int (*read_block)(struct pci_dev *dev, void *buf, unsigned int buf_len,
-- 
2.25.1

