Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DD23BEACE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhGGPh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhGGPhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:37:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC69C06175F;
        Wed,  7 Jul 2021 08:35:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g24so1762017pji.4;
        Wed, 07 Jul 2021 08:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wbx/GDjQo5wf+q3MZtzwwUpSNi9ocBIpEvvl5wWSUuY=;
        b=e7uo+5Ivoc5v4lyVfzL5PJWG8DO2FVVvKVNLIP/JelHKqVQ3+/2ZYpapkBrb8LUFVC
         7qYGdaZxlntgy7UeV5pBsyBFqfO+9KN/V/vM4nPx2R0eLL9hzQmmf/tE41W+P0WBh1At
         K1Sp01WjqX2lAHavP/bYmMTQcIFW2bLY9Zr4o1smOkXa1eA2/B3W1FLG5w/rAY9GRB6T
         gUDQxan/h/L61nWFKR325fMENtL6sQZbbso2hLKeW0W8/J9m3ZedU3U7l3Ps2GvH8BvV
         0kvRsrTpIaE6ywUD5UHWtgCI4m2WoruEmTg8eGudyANQCG9ZEAxRyVEJzlSzFrr6JYOn
         VueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wbx/GDjQo5wf+q3MZtzwwUpSNi9ocBIpEvvl5wWSUuY=;
        b=Tqu2XWzFZOQNNW/CecfQx6iIhSr7SHVP7adkjbQWKMDm9qVlhwt1qwMYu1G9Z9x0Mo
         URS0d4CbNC3fUAxD1og014vNIo9yy84hG+tWFfVduY0OxGrsMhO6LGCMaRztzWDjOdOU
         wrn0XxrSqo6rxua2owczv6yEPPKvW4+pIa0ebPl2Bo/QcmEEsUmTuqSuIHtB3dHA2GE4
         3O73IV9fmBHrm+MjVzuLNYs3f/wqUterpj+029woKCyS+GYi2kbFyv3mj2zai1Ko4Dc6
         wJvFOfr09hhRbro7Q/pve5ie/YuN2381lEGnw7E3QAy4h+HitdJqKrYRg5TYBi2TjugJ
         O8vg==
X-Gm-Message-State: AOAM532iIp6G9zBmgp4M3hoL/zTIF9XC583VPLVqixxTFUEAHzxNe3xE
        H5Ink/caTdH1uKw5hjpLkmI=
X-Google-Smtp-Source: ABdhPJzZTP+ads7LHHVospaj5MKCgPFde65N1bwnkO2O7gsx4XoJNrVJZzIIqkRlDyplTSDsm44ULQ==
X-Received: by 2002:a17:902:da85:b029:129:b7a8:6ef8 with SMTP id j5-20020a170902da85b0290129b7a86ef8mr5932578plx.77.1625672108933;
        Wed, 07 Jul 2021 08:35:08 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:6b7f:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id y11sm21096877pfo.160.2021.07.07.08.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:35:08 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        rppt@kernel.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, ardb@kernel.org,
        nramas@linux.microsoft.com, robh@kernel.org, keescook@chromium.org,
        rientjes@google.com, pgonda@google.com, martin.b.radev@gmail.com,
        hannes@cmpxchg.org, saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [RFC PATCH V4 02/12] x86/HV: Add new hvcall guest address host visibility support
Date:   Wed,  7 Jul 2021 11:34:43 -0400
Message-Id: <20210707153456.3976348-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707153456.3976348-1-ltykernel@gmail.com>
References: <20210707153456.3976348-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Add new hvcall guest address host visibility support to mark
memory visible to host. Call it inside set_memory_decrypted
/encrypted().

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/ivm.c              | 112 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  18 +++++
 arch/x86/include/asm/mshyperv.h    |   3 +-
 arch/x86/mm/pat/set_memory.c       |   6 +-
 include/asm-generic/hyperv-tlfs.h  |   1 +
 6 files changed, 139 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/hyperv/ivm.c

diff --git a/arch/x86/hyperv/Makefile b/arch/x86/hyperv/Makefile
index 48e2c51464e8..5d2de10809ae 100644
--- a/arch/x86/hyperv/Makefile
+++ b/arch/x86/hyperv/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y			:= hv_init.o mmu.o nested.o irqdomain.o
+obj-y			:= hv_init.o mmu.o nested.o irqdomain.o ivm.o
 obj-$(CONFIG_X86_64)	+= hv_apic.o hv_proc.o
 
 ifdef CONFIG_X86_64
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
new file mode 100644
index 000000000000..24a58795abd8
--- /dev/null
+++ b/arch/x86/hyperv/ivm.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hyper-V Isolation VM interface with paravisor and hypervisor
+ *
+ * Author:
+ *  Tianyu Lan <Tianyu.Lan@microsoft.com>
+ */
+
+#include <linux/hyperv.h>
+#include <linux/types.h>
+#include <linux/bitfield.h>
+#include <linux/slab.h>
+#include <asm/io.h>
+#include <asm/mshyperv.h>
+
+/*
+ * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
+ *
+ * In Isolation VM, all guest memory is encripted from host and guest
+ * needs to set memory visible to host via hvcall before sharing memory
+ * with host.
+ */
+int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)
+{
+	struct hv_gpa_range_for_visibility **input_pcpu, *input;
+	u16 pages_processed;
+	u64 hv_status;
+	unsigned long flags;
+
+	/* no-op if partition isolation is not enabled */
+	if (!hv_is_isolation_supported())
+		return 0;
+
+	if (count > HV_MAX_MODIFY_GPA_REP_COUNT) {
+		pr_err("Hyper-V: GPA count:%d exceeds supported:%lu\n", count,
+			HV_MAX_MODIFY_GPA_REP_COUNT);
+		return -EINVAL;
+	}
+
+	local_irq_save(flags);
+	input_pcpu = (struct hv_gpa_range_for_visibility **)
+			this_cpu_ptr(hyperv_pcpu_input_arg);
+	input = *input_pcpu;
+	if (unlikely(!input)) {
+		local_irq_restore(flags);
+		return -EINVAL;
+	}
+
+	input->partition_id = HV_PARTITION_ID_SELF;
+	input->host_visibility = visibility;
+	input->reserved0 = 0;
+	input->reserved1 = 0;
+	memcpy((void *)input->gpa_page_list, pfn, count * sizeof(*pfn));
+	hv_status = hv_do_rep_hypercall(
+			HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY, count,
+			0, input, &pages_processed);
+	local_irq_restore(flags);
+
+	if (!(hv_status & HV_HYPERCALL_RESULT_MASK))
+		return 0;
+
+	return hv_status & HV_HYPERCALL_RESULT_MASK;
+}
+EXPORT_SYMBOL(hv_mark_gpa_visibility);
+
+/*
+ * hv_set_mem_host_visibility - Set specified memory visible to host.
+ *
+ * In Isolation VM, all guest memory is encrypted from host and guest
+ * needs to set memory visible to host via hvcall before sharing memory
+ * with host. This function works as wrap of hv_mark_gpa_visibility()
+ * with memory base and size.
+ */
+static int hv_set_mem_host_visibility(void *kbuffer, size_t size, u32 visibility)
+{
+	int pagecount = size >> HV_HYP_PAGE_SHIFT;
+	u64 *pfn_array;
+	int ret = 0;
+	int i, pfn;
+
+	if (!hv_is_isolation_supported() || !ms_hyperv.ghcb_base)
+		return 0;
+
+	pfn_array = kzalloc(HV_HYP_PAGE_SIZE, GFP_KERNEL);
+	if (!pfn_array)
+		return -ENOMEM;
+
+	for (i = 0, pfn = 0; i < pagecount; i++) {
+		pfn_array[pfn] = virt_to_hvpfn(kbuffer + i * HV_HYP_PAGE_SIZE);
+		pfn++;
+
+		if (pfn == HV_MAX_MODIFY_GPA_REP_COUNT || i == pagecount - 1) {
+			ret |= hv_mark_gpa_visibility(pfn, pfn_array, visibility);
+			pfn = 0;
+
+			if (ret)
+				goto err_free_pfn_array;
+		}
+	}
+
+ err_free_pfn_array:
+	kfree(pfn_array);
+	return ret;
+}
+
+int hv_set_mem_enc(unsigned long addr, int numpages, bool enc)
+{
+	return hv_set_mem_host_visibility((void *)addr,
+			numpages * HV_HYP_PAGE_SIZE,
+			enc ? VMBUS_PAGE_NOT_VISIBLE
+			: VMBUS_PAGE_VISIBLE_READ_WRITE);
+}
diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 606f5cc579b2..68826fbf92ca 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -262,6 +262,11 @@ enum hv_isolation_type {
 #define HV_X64_MSR_TIME_REF_COUNT	HV_REGISTER_TIME_REF_COUNT
 #define HV_X64_MSR_REFERENCE_TSC	HV_REGISTER_REFERENCE_TSC
 
+/* Hyper-V GPA map flags */
+#define	VMBUS_PAGE_NOT_VISIBLE		0
+#define	VMBUS_PAGE_VISIBLE_READ_ONLY	1
+#define	VMBUS_PAGE_VISIBLE_READ_WRITE	3
+
 /*
  * Declare the MSR used to setup pages used to communicate with the hypervisor.
  */
@@ -561,4 +566,17 @@ enum hv_interrupt_type {
 
 #include <asm-generic/hyperv-tlfs.h>
 
+/* All input parameters should be in single page. */
+#define HV_MAX_MODIFY_GPA_REP_COUNT		\
+	((PAGE_SIZE / sizeof(u64)) - 2)
+
+/* HvCallModifySparseGpaPageHostVisibility hypercall */
+struct hv_gpa_range_for_visibility {
+	u64 partition_id;
+	u32 host_visibility:2;
+	u32 reserved0:30;
+	u32 reserved1;
+	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
+} __packed;
+
 #endif
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index aeacca7c4da8..2172493dc881 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -194,7 +194,8 @@ struct irq_domain *hv_create_pci_msi_domain(void);
 int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
 		struct hv_interrupt_entry *entry);
 int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
-
+int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
+int hv_set_mem_enc(unsigned long addr, int numpages, bool enc);
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 156cd235659f..6cc83c57383d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -29,6 +29,8 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/hyperv-tlfs.h>
+#include <asm/mshyperv.h>
 
 #include "../mm_internal.h"
 
@@ -1986,7 +1988,9 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	int ret;
 
 	/* Nothing to do if memory encryption is not active */
-	if (!mem_encrypt_active())
+	if (hv_is_isolation_supported())
+		return hv_set_mem_enc(addr, numpages, enc);
+	else if (!mem_encrypt_active())
 		return 0;
 
 	/* Should not be working on unaligned addresses */
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 515c3fb06ab3..8a0219255545 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_RETARGET_INTERRUPT		0x007e
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
+#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
 
 /* Extended hypercalls */
 #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
-- 
2.25.1

