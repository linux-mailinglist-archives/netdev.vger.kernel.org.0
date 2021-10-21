Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7A743668D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhJUPnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbhJUPnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:43:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F65C061225;
        Thu, 21 Oct 2021 08:41:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ls18so783217pjb.3;
        Thu, 21 Oct 2021 08:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ngx5jo+Jj3c2MNTpGRB/73rHcT6sBOx1capK3E8/Ok=;
        b=i+X+Eqqrev/dVrvcyvBx+xB0Cq4YhH2TLYFYF5j2kSusBdJBArEdi5KsM/yH1SOzZU
         b3XDEN1CWlhBAyTYiN9hOc/eZLdqYRvo9OEdsldJrHyCO27pieOrMm/ekw3DdBd5CFAX
         9L4TWcWp6XL6aI/8EJRQKHabxLKlwI9nNI882CMjFt0i4YtZ0iLbytZQJTgETiqu2nLI
         TCi9oAj6E0refFyPrl0m7n4+658QwExmxtJtNKzGjTPKTrhM4KEhvt+vAwXHdRDwHVbB
         SgrlsWnkvdhGMQqyEt4uWciymFMv1DF25cq53PgqevHm6Qo+e7suc92g6SfsPGb4nGti
         I7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ngx5jo+Jj3c2MNTpGRB/73rHcT6sBOx1capK3E8/Ok=;
        b=rKEPYtYuJrzxrnu9ipzUq1UW/E8G2sA3kzpv0BT/3AK8lwIc5aGC/RNR+uK4rLj18t
         YbDzTALZb/JPMKKMRx+QAhQ2+jg75KZwWMT/2MapZoOkwWjN2k9O5fmHAsiFtOHw/uUo
         nKC7KKrSj5+WDxiMY84Gi2sokkNeZB8H6SmDX5qsNgxFpqA/Xi3uZVABGSpZLNu+vbP1
         lra5Mm0wKiRT8W3W4TK1f2RneFhsVUwfLNXabxfiMw74A7UzrL4xvv6J7/WXr5YskJ7F
         ZIl/VVqh9LJPkoTV5HIqPbesboctGuWKqg/Hlg1LlH5sELhEKghmlfDdY8kX8Op6VFMP
         x6gA==
X-Gm-Message-State: AOAM530a2eOgo4urWnZ0cOgFGnq1oAZuQWp3vx0kT2xE3brg4AbpvDVJ
        woEQPS5Hxr3uW3FksOHwZUI=
X-Google-Smtp-Source: ABdhPJyHTKoyZxTU48NztOZqFaz4rllSDFSD1+Jypvm3BDhEwcZ/SZqSqt0KaS0KftHokXS1w13k8A==
X-Received: by 2002:a17:90b:1d86:: with SMTP id pf6mr1708382pjb.20.1634830885327;
        Thu, 21 Oct 2021 08:41:25 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:a76d:53a5:b89f:c2a0])
        by smtp.gmail.com with ESMTPSA id p9sm6384130pfn.7.2021.10.21.08.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:41:25 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        rientjes@google.com, pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        saravanand@fb.com, aneesh.kumar@linux.ibm.com, hannes@cmpxchg.org,
        tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V8 6/9] x86/hyperv: Add Write/Read MSR registers via ghcb page
Date:   Thu, 21 Oct 2021 11:41:06 -0400
Message-Id: <20211021154110.3734294-7-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211021154110.3734294-1-ltykernel@gmail.com>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyperv provides GHCB protocol to write Synthetic Interrupt
Controller MSR registers in Isolation VM with AMD SEV SNP
and these registers are emulated by hypervisor directly.
Hyperv requires to write SINTx MSR registers twice. First
writes MSR via GHCB page to communicate with hypervisor
and then writes wrmsr instruction to talk with paravisor
which runs in VMPL0. Guest OS ID MSR also needs to be set
via GHCB page.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v6:
	* Spilt sev-es code into separate patch
	* Add hv_get/set_register() dummy function under CONFIG_HYPERV
	  is not selected to fix compile error.

Change since v5:
	* Adjust change layout in the asm/mshyperv.h
	  to make hv_is_synic_reg(), hv_get_register()
	  and hv_set_register() ahead of the #include
	  of asm-generic/mshyperv.h
	* Remove Spurious blank line

Change since v4:
	* Remove hv_get_simp(), hv_get_siefp()  hv_get_synint_*()
	  helper function. Move the logic into hv_get/set_register().

Change since v3:
	* Pass old_msg_type to hv_signal_eom() as parameter.
	* Use HV_REGISTER_* marcro instead of HV_X64_MSR_*
	* Add hv_isolation_type_snp() weak function.
	* Add maros to set syinc register in ARM code.

Change since v1:
	* Introduce sev_es_ghcb_hv_call_simple() and share code
	  between SEV and Hyper-V code.
---
 arch/x86/hyperv/hv_init.c       |  36 +++--------
 arch/x86/hyperv/ivm.c           | 107 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h |  57 ++++++++++++-----
 drivers/hv/hv.c                 |  74 +++++++++++++++++-----
 drivers/hv/hv_common.c          |   6 ++
 include/asm-generic/mshyperv.h  |   1 +
 6 files changed, 222 insertions(+), 59 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index d57df6825527..a16a83e46a30 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(hv_current_partition_id);
 void *hv_hypercall_pg;
 EXPORT_SYMBOL_GPL(hv_hypercall_pg);
 
-void __percpu **hv_ghcb_pg;
+union hv_ghcb __percpu **hv_ghcb_pg;
 
 /* Storage to save the hypercall page temporarily for hibernation */
 static void *hv_hypercall_pg_saved;
@@ -406,7 +406,7 @@ void __init hyperv_init(void)
 	}
 
 	if (hv_isolation_type_snp()) {
-		hv_ghcb_pg = alloc_percpu(void *);
+		hv_ghcb_pg = alloc_percpu(union hv_ghcb *);
 		if (!hv_ghcb_pg)
 			goto free_vp_assist_page;
 	}
@@ -424,6 +424,9 @@ void __init hyperv_init(void)
 	guest_id = generate_guest_id(0, LINUX_VERSION_CODE, 0);
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, guest_id);
 
+	/* Hyper-V requires to write guest os id via ghcb in SNP IVM. */
+	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, guest_id);
+
 	hv_hypercall_pg = __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START,
 			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
 			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
@@ -501,6 +504,7 @@ void __init hyperv_init(void)
 
 clean_guest_os_id:
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
+	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
 	cpuhp_remove_state(cpuhp);
 free_ghcb_page:
 	free_percpu(hv_ghcb_pg);
@@ -522,6 +526,7 @@ void hyperv_cleanup(void)
 
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
+	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
 
 	/*
 	 * Reset hypercall page reference before reset the page,
@@ -592,30 +597,3 @@ bool hv_is_hyperv_initialized(void)
 	return hypercall_msr.enable;
 }
 EXPORT_SYMBOL_GPL(hv_is_hyperv_initialized);
-
-enum hv_isolation_type hv_get_isolation_type(void)
-{
-	if (!(ms_hyperv.priv_high & HV_ISOLATION))
-		return HV_ISOLATION_TYPE_NONE;
-	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
-}
-EXPORT_SYMBOL_GPL(hv_get_isolation_type);
-
-bool hv_is_isolation_supported(void)
-{
-	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
-		return false;
-
-	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
-		return false;
-
-	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
-}
-
-DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
-
-bool hv_isolation_type_snp(void)
-{
-	return static_branch_unlikely(&isolation_type_snp);
-}
-EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 79e7fb83472a..925cbc3e7601 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -6,12 +6,119 @@
  *  Tianyu Lan <Tianyu.Lan@microsoft.com>
  */
 
+#include <linux/types.h>
+#include <linux/bitfield.h>
 #include <linux/hyperv.h>
 #include <linux/types.h>
 #include <linux/bitfield.h>
 #include <linux/slab.h>
+#include <asm/svm.h>
+#include <asm/sev.h>
 #include <asm/io.h>
 #include <asm/mshyperv.h>
+#include <asm/hypervisor.h>
+
+union hv_ghcb {
+	struct ghcb ghcb;
+} __packed __aligned(HV_HYP_PAGE_SIZE);
+
+void hv_ghcb_msr_write(u64 msr, u64 value)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
+	struct es_em_ctxt ctxt;
+
+	if (!hv_ghcb_pg)
+		return;
+
+	WARN_ON(in_nmi());
+
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(hv_ghcb_pg);
+	hv_ghcb = (union hv_ghcb *)*ghcb_base;
+	if (!hv_ghcb) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
+	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
+	ghcb_set_rdx(&hv_ghcb->ghcb, upper_32_bits(value));
+
+	if (sev_es_ghcb_hv_call(&hv_ghcb->ghcb, false, &ctxt,
+				SVM_EXIT_MSR, 1, 0))
+		pr_warn("Fail to write msr via ghcb %llx.\n", msr);
+
+	local_irq_restore(flags);
+}
+
+void hv_ghcb_msr_read(u64 msr, u64 *value)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
+	struct es_em_ctxt ctxt;
+
+	/* Check size of union hv_ghcb here. */
+	BUILD_BUG_ON(sizeof(union hv_ghcb) != HV_HYP_PAGE_SIZE);
+
+	if (!hv_ghcb_pg)
+		return;
+
+	WARN_ON(in_nmi());
+
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(hv_ghcb_pg);
+	hv_ghcb = (union hv_ghcb *)*ghcb_base;
+	if (!hv_ghcb) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
+	if (sev_es_ghcb_hv_call(&hv_ghcb->ghcb, false, &ctxt,
+				SVM_EXIT_MSR, 0, 0))
+		pr_warn("Fail to read msr via ghcb %llx.\n", msr);
+	else
+		*value = (u64)lower_32_bits(hv_ghcb->ghcb.save.rax)
+			| ((u64)lower_32_bits(hv_ghcb->ghcb.save.rdx) << 32);
+	local_irq_restore(flags);
+}
+
+enum hv_isolation_type hv_get_isolation_type(void)
+{
+	if (!(ms_hyperv.priv_high & HV_ISOLATION))
+		return HV_ISOLATION_TYPE_NONE;
+	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
+}
+EXPORT_SYMBOL_GPL(hv_get_isolation_type);
+
+/*
+ * hv_is_isolation_supported - Check system runs in the Hyper-V
+ * isolation VM.
+ */
+bool hv_is_isolation_supported(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
+		return false;
+
+	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
+}
+
+DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
+
+/*
+ * hv_isolation_type_snp - Check system runs in the AMD SEV-SNP based
+ * isolation VM.
+ */
+bool hv_isolation_type_snp(void)
+{
+	return static_branch_unlikely(&isolation_type_snp);
+}
 
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index f3154ca41ac4..eb1ba33da113 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -11,25 +11,14 @@
 #include <asm/paravirt.h>
 #include <asm/mshyperv.h>
 
+union hv_ghcb;
+
 DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
 
 typedef int (*hyperv_fill_flush_list_func)(
 		struct hv_guest_mapping_flush_list *flush,
 		void *data);
 
-static inline void hv_set_register(unsigned int reg, u64 value)
-{
-	wrmsrl(reg, value);
-}
-
-static inline u64 hv_get_register(unsigned int reg)
-{
-	u64 value;
-
-	rdmsrl(reg, value);
-	return value;
-}
-
 #define hv_get_raw_timer() rdtsc_ordered()
 
 void hyperv_vector_handler(struct pt_regs *regs);
@@ -41,7 +30,7 @@ extern void *hv_hypercall_pg;
 
 extern u64 hv_current_partition_id;
 
-extern void __percpu **hv_ghcb_pg;
+extern union hv_ghcb  __percpu **hv_ghcb_pg;
 
 int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages);
 int hv_call_add_logical_proc(int node, u32 lp_index, u32 acpi_id);
@@ -193,6 +182,44 @@ int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
 		struct hv_interrupt_entry *entry);
 int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
 int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible);
+void hv_ghcb_msr_write(u64 msr, u64 value);
+void hv_ghcb_msr_read(u64 msr, u64 *value);
+
+extern bool hv_isolation_type_snp(void);
+
+static inline bool hv_is_synic_reg(unsigned int reg)
+{
+	if ((reg >= HV_REGISTER_SCONTROL) &&
+	    (reg <= HV_REGISTER_SINT15))
+		return true;
+	return false;
+}
+
+static inline u64 hv_get_register(unsigned int reg)
+{
+	u64 value;
+
+	if (hv_is_synic_reg(reg) && hv_isolation_type_snp())
+		hv_ghcb_msr_read(reg, &value);
+	else
+		rdmsrl(reg, value);
+	return value;
+}
+
+static inline void hv_set_register(unsigned int reg, u64 value)
+{
+	if (hv_is_synic_reg(reg) && hv_isolation_type_snp()) {
+		hv_ghcb_msr_write(reg, value);
+
+		/* Write proxy bit via wrmsl instruction */
+		if (reg >= HV_REGISTER_SINT0 &&
+		    reg <= HV_REGISTER_SINT15)
+			wrmsrl(reg, value | 1 << 20);
+	} else {
+		wrmsrl(reg, value);
+	}
+}
+
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
@@ -209,6 +236,8 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 {
 	return -1;
 }
+static inline void hv_set_register(unsigned int reg, u64 value) { }
+static inline u64 hv_get_register(unsigned int reg) { return 0; }
 static inline int hv_set_mem_host_visibility(unsigned long addr, int numpages,
 					     bool visible)
 {
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index e83507f49676..943392db9e8a 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -8,6 +8,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -136,17 +137,24 @@ int hv_synic_alloc(void)
 		tasklet_init(&hv_cpu->msg_dpc,
 			     vmbus_on_msg_dpc, (unsigned long) hv_cpu);
 
-		hv_cpu->synic_message_page =
-			(void *)get_zeroed_page(GFP_ATOMIC);
-		if (hv_cpu->synic_message_page == NULL) {
-			pr_err("Unable to allocate SYNIC message page\n");
-			goto err;
-		}
+		/*
+		 * Synic message and event pages are allocated by paravisor.
+		 * Skip these pages allocation here.
+		 */
+		if (!hv_isolation_type_snp()) {
+			hv_cpu->synic_message_page =
+				(void *)get_zeroed_page(GFP_ATOMIC);
+			if (hv_cpu->synic_message_page == NULL) {
+				pr_err("Unable to allocate SYNIC message page\n");
+				goto err;
+			}
 
-		hv_cpu->synic_event_page = (void *)get_zeroed_page(GFP_ATOMIC);
-		if (hv_cpu->synic_event_page == NULL) {
-			pr_err("Unable to allocate SYNIC event page\n");
-			goto err;
+			hv_cpu->synic_event_page =
+				(void *)get_zeroed_page(GFP_ATOMIC);
+			if (hv_cpu->synic_event_page == NULL) {
+				pr_err("Unable to allocate SYNIC event page\n");
+				goto err;
+			}
 		}
 
 		hv_cpu->post_msg_page = (void *)get_zeroed_page(GFP_ATOMIC);
@@ -201,16 +209,35 @@ void hv_synic_enable_regs(unsigned int cpu)
 	/* Setup the Synic's message page */
 	simp.as_uint64 = hv_get_register(HV_REGISTER_SIMP);
 	simp.simp_enabled = 1;
-	simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
-		>> HV_HYP_PAGE_SHIFT;
+
+	if (hv_isolation_type_snp()) {
+		hv_cpu->synic_message_page
+			= memremap(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
+				   HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+		if (!hv_cpu->synic_message_page)
+			pr_err("Fail to map syinc message page.\n");
+	} else {
+		simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
+			>> HV_HYP_PAGE_SHIFT;
+	}
 
 	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
 
 	/* Setup the Synic's event page */
 	siefp.as_uint64 = hv_get_register(HV_REGISTER_SIEFP);
 	siefp.siefp_enabled = 1;
-	siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
-		>> HV_HYP_PAGE_SHIFT;
+
+	if (hv_isolation_type_snp()) {
+		hv_cpu->synic_event_page =
+			memremap(siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT,
+				 HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+
+		if (!hv_cpu->synic_event_page)
+			pr_err("Fail to map syinc event page.\n");
+	} else {
+		siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
+			>> HV_HYP_PAGE_SHIFT;
+	}
 
 	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
 
@@ -257,6 +284,8 @@ int hv_synic_init(unsigned int cpu)
  */
 void hv_synic_disable_regs(unsigned int cpu)
 {
+	struct hv_per_cpu_context *hv_cpu
+		= per_cpu_ptr(hv_context.cpu_context, cpu);
 	union hv_synic_sint shared_sint;
 	union hv_synic_simp simp;
 	union hv_synic_siefp siefp;
@@ -273,14 +302,27 @@ void hv_synic_disable_regs(unsigned int cpu)
 				shared_sint.as_uint64);
 
 	simp.as_uint64 = hv_get_register(HV_REGISTER_SIMP);
+	/*
+	 * In Isolation VM, sim and sief pages are allocated by
+	 * paravisor. These pages also will be used by kdump
+	 * kernel. So just reset enable bit here and keep page
+	 * addresses.
+	 */
 	simp.simp_enabled = 0;
-	simp.base_simp_gpa = 0;
+	if (hv_isolation_type_snp())
+		memunmap(hv_cpu->synic_message_page);
+	else
+		simp.base_simp_gpa = 0;
 
 	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
 
 	siefp.as_uint64 = hv_get_register(HV_REGISTER_SIEFP);
 	siefp.siefp_enabled = 0;
-	siefp.base_siefp_gpa = 0;
+
+	if (hv_isolation_type_snp())
+		memunmap(hv_cpu->synic_event_page);
+	else
+		siefp.base_siefp_gpa = 0;
 
 	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
 
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index c0d9048a4112..1fc82d237161 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -249,6 +249,12 @@ bool __weak hv_is_isolation_supported(void)
 }
 EXPORT_SYMBOL_GPL(hv_is_isolation_supported);
 
+bool __weak hv_isolation_type_snp(void)
+{
+	return false;
+}
+EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
+
 void __weak hv_setup_vmbus_handler(void (*handler)(void))
 {
 }
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index a8ac497167d2..6d3ba902ebb0 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -54,6 +54,7 @@ extern void  __percpu  **hyperv_pcpu_output_arg;
 
 extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputaddr);
 extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
+extern bool hv_isolation_type_snp(void);
 
 /* Helper functions that provide a consistent pattern for checking Hyper-V hypercall status. */
 static inline int hv_result(u64 status)
-- 
2.25.1

