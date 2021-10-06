Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9EE423829
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbhJFGjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbhJFGiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:38:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2FCC061762;
        Tue,  5 Oct 2021 23:36:59 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m21so1558683pgu.13;
        Tue, 05 Oct 2021 23:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glSXNuAzDqEIH2q2SUGbvFQPVTW3GChplfWchKPoUKQ=;
        b=TFM1cSFRf9ULjEz5LSeoI7+w3/TCvjSRDV+uHOLFdAWQSG9QpvrTPosPk98fRxDQcv
         qHdn97ye9tB13IWzlhDsQvIjCGZYn9hQPpfPTLEKDp0DU1I0GIW3kVRo+rbOFfrYqN3M
         28gURjvvdrlbDWwoFapQaKtPI0tnsbB+mXi9CHUxbdPqsijSOImFLjJEKupx/MsFxgsz
         1Lo6b/skstTywblcomDjtOLVHACWmrjY/rlZUIhUAZ/xFdUPCr/IGjNKc79txUaqxmda
         moYk8lEYmN9r+Sw+Bz1TUsXeZmYA/LFRhRUKgDkMq1h2TkL4L5FFPmukaejHnVbWtBFr
         jHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glSXNuAzDqEIH2q2SUGbvFQPVTW3GChplfWchKPoUKQ=;
        b=G3LM4n2OCoP6Qc6/oVE7hAdnaXmXJSMUWzyOrPkc8WTNPXgeTwlcP52t7Q+QXwDfVS
         SMArWtHxzilidcShYBHKwcqRuG1nmg4ExTxIc7MksE0c45hobPGrZ2PgCOj99l28h8ae
         ZxcMlzsKRLDHysWPP1NZl6OwblHYAAU+Biz6MG6CLbVLgrhI3JDWRdXkpRz9FyNVGzc2
         wm5SrsfpW5Ivx4JuvQV5xvMQuEgTaO46CVO8nNJdeHeJP82R9pVt331e9KwksHePJi3h
         9riLYdsu2Ek7SdrltISxV6bEP3aTcwCUMhtO3vxagjGrrNe0VXrhPiktMr9znE7dIP47
         yWHw==
X-Gm-Message-State: AOAM533KWtCnU3Iids+PvygCH4FuSrXc7Xoah8PjRgvWJwWgkA8ClZen
        jZZPhxmVm0K778voI4VWY2k=
X-Google-Smtp-Source: ABdhPJzYSBp3C4cfmCAXq8yKZnSQCdO8m2pF73PaMdIF60Kl72lq9y+a7mgyDmJzej5Q5oL6PgI/Nw==
X-Received: by 2002:a63:7d05:: with SMTP id y5mr19255257pgc.80.1633502218991;
        Tue, 05 Oct 2021 23:36:58 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:37:357b:c418:cfef:30b1])
        by smtp.gmail.com with ESMTPSA id l185sm19886413pfd.29.2021.10.05.23.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 23:36:58 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, jroedel@suse.de, brijesh.singh@amd.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V7 3/9] x86/hyperv: Add new hvcall guest address host visibility  support
Date:   Wed,  6 Oct 2021 02:36:43 -0400
Message-Id: <20211006063651.1124737-4-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211006063651.1124737-1-ltykernel@gmail.com>
References: <20211006063651.1124737-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Add new hvcall guest address host visibility support to mark
memory visible to host. Call it inside set_memory_decrypted
/encrypted(). Add HYPERVISOR feature check in the
hv_is_isolation_supported() to optimize in non-virtualization
environment.

Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v6:
	* Add hv_set_mem_host_visibility() when CONFIG_HYPERV is no.
	  Fix compile error.
	* Add comment to describe __set_memory_enc_pgtable().

Change since v4:
        * Fix typo in the comment
	* Make hv_mark_gpa_visibility() to be a static function
	* Merge __hv_set_mem_host_visibility() and hv_set_mem_host_visibility()

Change since v3:
	* Fix error code handle in the __hv_set_mem_host_visibility().
	* Move HvCallModifySparseGpaPageHostVisibility near to enum
	  hv_mem_host_visibility.

Change since v2:
       * Rework __set_memory_enc_dec() and call Hyper-V and AMD function
         according to platform check.

Change since v1:
       * Use new staic call x86_set_memory_enc to avoid add Hyper-V
         specific check in the set_memory code.
---
 arch/x86/hyperv/Makefile           |   2 +-
 arch/x86/hyperv/hv_init.c          |   6 ++
 arch/x86/hyperv/ivm.c              | 105 +++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h |  17 +++++
 arch/x86/include/asm/mshyperv.h    |   7 +-
 arch/x86/mm/pat/set_memory.c       |  23 +++++--
 include/asm-generic/hyperv-tlfs.h  |   1 +
 include/asm-generic/mshyperv.h     |   1 +
 8 files changed, 155 insertions(+), 7 deletions(-)
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
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index a7e922755ad1..d57df6825527 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -603,6 +603,12 @@ EXPORT_SYMBOL_GPL(hv_get_isolation_type);
 
 bool hv_is_isolation_supported(void)
 {
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
+		return false;
+
 	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
 }
 
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
new file mode 100644
index 000000000000..79e7fb83472a
--- /dev/null
+++ b/arch/x86/hyperv/ivm.c
@@ -0,0 +1,105 @@
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
+ * In Isolation VM, all guest memory is encrypted from host and guest
+ * needs to set memory visible to host via hvcall before sharing memory
+ * with host.
+ */
+static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
+			   enum hv_mem_host_visibility visibility)
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
+	if (hv_result_success(hv_status))
+		return 0;
+	else
+		return -EFAULT;
+}
+
+/*
+ * hv_set_mem_host_visibility - Set specified memory visible to host.
+ *
+ * In Isolation VM, all guest memory is encrypted from host and guest
+ * needs to set memory visible to host via hvcall before sharing memory
+ * with host. This function works as wrap of hv_mark_gpa_visibility()
+ * with memory base and size.
+ */
+int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visible)
+{
+	enum hv_mem_host_visibility visibility = visible ?
+			VMBUS_PAGE_VISIBLE_READ_WRITE : VMBUS_PAGE_NOT_VISIBLE;
+	u64 *pfn_array;
+	int ret = 0;
+	int i, pfn;
+
+	if (!hv_is_isolation_supported() || !hv_hypercall_pg)
+		return 0;
+
+	pfn_array = kmalloc(HV_HYP_PAGE_SIZE, GFP_KERNEL);
+	if (!pfn_array)
+		return -ENOMEM;
+
+	for (i = 0, pfn = 0; i < pagecount; i++) {
+		pfn_array[pfn] = virt_to_hvpfn((void *)kbuffer + i * HV_HYP_PAGE_SIZE);
+		pfn++;
+
+		if (pfn == HV_MAX_MODIFY_GPA_REP_COUNT || i == pagecount - 1) {
+			ret = hv_mark_gpa_visibility(pfn, pfn_array,
+						     visibility);
+			if (ret)
+				goto err_free_pfn_array;
+			pfn = 0;
+		}
+	}
+
+ err_free_pfn_array:
+	kfree(pfn_array);
+	return ret;
+}
diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 2322d6bd5883..381e88122a5f 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -276,6 +276,23 @@ enum hv_isolation_type {
 #define HV_X64_MSR_TIME_REF_COUNT	HV_REGISTER_TIME_REF_COUNT
 #define HV_X64_MSR_REFERENCE_TSC	HV_REGISTER_REFERENCE_TSC
 
+/* Hyper-V memory host visibility */
+enum hv_mem_host_visibility {
+	VMBUS_PAGE_NOT_VISIBLE		= 0,
+	VMBUS_PAGE_VISIBLE_READ_ONLY	= 1,
+	VMBUS_PAGE_VISIBLE_READ_WRITE	= 3
+};
+
+/* HvCallModifySparseGpaPageHostVisibility hypercall */
+#define HV_MAX_MODIFY_GPA_REP_COUNT	((PAGE_SIZE / sizeof(u64)) - 2)
+struct hv_gpa_range_for_visibility {
+	u64 partition_id;
+	u32 host_visibility:2;
+	u32 reserved0:30;
+	u32 reserved1;
+	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
+} __packed;
+
 /*
  * Declare the MSR used to setup pages used to communicate with the hypervisor.
  */
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 37739a277ac6..f3154ca41ac4 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -192,7 +192,7 @@ struct irq_domain *hv_create_pci_msi_domain(void);
 int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
 		struct hv_interrupt_entry *entry);
 int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
-
+int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible);
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
@@ -209,6 +209,11 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 {
 	return -1;
 }
+static inline int hv_set_mem_host_visibility(unsigned long addr, int numpages,
+					     bool visible)
+{
+	return -1;
+}
 #endif /* CONFIG_HYPERV */
 
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ad8a5c586a35..525f682ab150 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -29,6 +29,8 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/hyperv-tlfs.h>
+#include <asm/mshyperv.h>
 
 #include "../mm_internal.h"
 
@@ -1980,15 +1982,15 @@ int set_memory_global(unsigned long addr, int numpages)
 				    __pgprot(_PAGE_GLOBAL), 0);
 }
 
-static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
+/*
+ * __set_memory_enc_pgtable() is used for the hypervisors that get
+ * informed about "encryption" status via page tables.
+ */
+static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 {
 	struct cpa_data cpa;
 	int ret;
 
-	/* Nothing to do if memory encryption is not active */
-	if (!mem_encrypt_active())
-		return 0;
-
 	/* Should not be working on unaligned addresses */
 	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
 		addr &= PAGE_MASK;
@@ -2023,6 +2025,17 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	return ret;
 }
 
+static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
+{
+	if (hv_is_isolation_supported())
+		return hv_set_mem_host_visibility(addr, numpages, !enc);
+
+	if (mem_encrypt_active())
+		return __set_memory_enc_pgtable(addr, numpages, enc);
+
+	return 0;
+}
+
 int set_memory_encrypted(unsigned long addr, int numpages)
 {
 	return __set_memory_enc_dec(addr, numpages, true);
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 56348a541c50..8ed6733d5146 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_RETARGET_INTERRUPT		0x007e
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
+#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
 
 /* Extended hypercalls */
 #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index ebe3727e1eb8..f176d740c4d7 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -271,6 +271,7 @@ bool hv_query_ext_cap(u64 cap_query);
 static inline bool hv_is_hyperv_initialized(void) { return false; }
 static inline bool hv_is_hibernation_supported(void) { return false; }
 static inline void hyperv_cleanup(void) {}
+static inline bool hv_is_isolation_supported(void) { return false; }
 #endif /* CONFIG_HYPERV */
 
 #endif
-- 
2.25.1

