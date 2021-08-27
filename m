Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F43F9DDF
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbhH0RWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbhH0RW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:22:26 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D228C0613CF;
        Fri, 27 Aug 2021 10:21:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u1so557288plq.5;
        Fri, 27 Aug 2021 10:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NMiinD0nrj/EF3wgWQrIIkzlaXeB4tTcwG2tHfq+6xA=;
        b=HEMUb+m3PpeyyOUVvXxqrhCKc8yNo0qk6PhsQs+IJBPiTP6RP0arkruBZb43WdICFI
         Opt0KQO05G/P+dvT3/I2EtVoIj2z/t0Onlp8WMG8/SDfpZ4HsuWD8pLq+FRSm5hnmv98
         kTr99DM48/h8mox3SbNbKGQV848ahDDQX6aLPPLgsA0r2CqGr2e7jjWJPb9IsNx0+bZi
         pCQNofp5g9EwyyoP0FRQwSKLyr5wwS9+nYS1BQCL0La8qA4WkZNeUBaczLjfBKK63WO0
         /Z8ImFpLV2BFTmLWM0JExERaQT0cf0JM8895jzqTvQFHwSV30HV6bxSVbnMng9gfq7ev
         sPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NMiinD0nrj/EF3wgWQrIIkzlaXeB4tTcwG2tHfq+6xA=;
        b=Pm1X4YsH6sufZG/D5dp/C8blqFfr4XFcgNrLYADf5cd6XdUbKQx3IXPvEYBb8TLZ+t
         lUj8Hf9NZdK3dR34PbPJ1Ajmob8yYudTm8KwCoeKUPeHCAY8c+3izijgcslkQZQWLfZm
         aKs+McjfpUGhQIcmdO61Bby1EMZKpfYwc2Y4tuakVRMuA1Skv3mqqbTwPsxTA/7gKez1
         YKw5wurywWgAH9dM03IPdro2PmCqgbxDyXo1LQ2EAIKfojyQ9Qu4/FPqE9aC6wr4ugQv
         jRbh8J8v4J81kMjNExF9FBJlYrjKr2Apws4RNa5H04pPEHkFrXCNosrAv2qYmEctFZj8
         XiTA==
X-Gm-Message-State: AOAM533vjoIZZCTWdgdd/f6lKaDElQYK5xM2xrNas2EobKGnc21FOFzG
        IqpIK4QmmVQnT6Ll2fERjNU=
X-Google-Smtp-Source: ABdhPJzcsGWVF3pnUTc6cPdQZbAUQkeXvTpHWigo9Q+d4201ZV50lMmSLv171RQVlz5hiqe27/lyMw==
X-Received: by 2002:a17:90a:ad7:: with SMTP id r23mr9357066pje.184.1630084893483;
        Fri, 27 Aug 2021 10:21:33 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:ef50:8fcd:44d1:eb17])
        by smtp.gmail.com with ESMTPSA id f5sm7155015pjo.23.2021.08.27.10.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:21:32 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 05/13] hyperv: Add Write/Read MSR registers via ghcb page
Date:   Fri, 27 Aug 2021 13:21:03 -0400
Message-Id: <20210827172114.414281-6-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827172114.414281-1-ltykernel@gmail.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
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
Change since v1:
         * Introduce sev_es_ghcb_hv_call_simple() and share code
           between SEV and Hyper-V code.
Change since v3:
         * Pass old_msg_type to hv_signal_eom() as parameter.
	 * Use HV_REGISTER_* marcro instead of HV_X64_MSR_*
	 * Add hv_isolation_type_snp() weak function.
	 * Add maros to set syinc register in ARM code.
---
 arch/arm64/include/asm/mshyperv.h |  23 ++++++
 arch/x86/hyperv/hv_init.c         |  36 ++--------
 arch/x86/hyperv/ivm.c             | 112 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h   |  80 ++++++++++++++++++++-
 arch/x86/include/asm/sev.h        |   3 +
 arch/x86/kernel/sev-shared.c      |  63 ++++++++++-------
 drivers/hv/hv.c                   | 112 ++++++++++++++++++++----------
 drivers/hv/hv_common.c            |   6 ++
 include/asm-generic/mshyperv.h    |   4 +-
 9 files changed, 345 insertions(+), 94 deletions(-)

diff --git a/arch/arm64/include/asm/mshyperv.h b/arch/arm64/include/asm/mshyperv.h
index 20070a847304..ced83297e009 100644
--- a/arch/arm64/include/asm/mshyperv.h
+++ b/arch/arm64/include/asm/mshyperv.h
@@ -41,6 +41,29 @@ static inline u64 hv_get_register(unsigned int reg)
 	return hv_get_vpreg(reg);
 }
 
+#define hv_get_simp(val)	{ val = hv_get_register(HV_REGISTER_SIMP); }
+#define hv_set_simp(val)	hv_set_register(HV_REGISTER_SIMP, val)
+
+#define hv_get_siefp(val)	{ val = hv_get_register(HV_REGISTER_SIEFP); }
+#define hv_set_siefp(val)	hv_set_register(HV_REGISTER_SIEFP, val)
+
+#define hv_get_synint_state(int_num, val) {			\
+	val = hv_get_register(HV_REGISTER_SINT0 + int_num);	\
+	}
+
+#define hv_set_synint_state(int_num, val)			\
+	hv_set_register(HV_REGISTER_SINT0 + int_num, val)
+
+#define hv_get_synic_state(val) {			\
+	val = hv_get_register(HV_REGISTER_SCONTROL);	\
+	}
+
+#define hv_set_synic_state(val)			\
+	hv_set_register(HV_REGISTER_SCONTROL, val)
+
+#define hv_signal_eom(old_msg_type)		 \
+	hv_set_register(HV_REGISTER_EOM, 0)
+
 /* SMCCC hypercall parameters */
 #define HV_SMCCC_FUNC_NUMBER	1
 #define HV_FUNC_ID	ARM_SMCCC_CALL_VAL(			\
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b1aa42f60faa..be6210a3fd2f 100644
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
-		return 0;
-
-	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
-		return 0;
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
index a069c788ce3c..f56fe4f73000 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -6,13 +6,125 @@
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
 
+union hv_ghcb {
+	struct ghcb ghcb;
+} __packed __aligned(HV_HYP_PAGE_SIZE);
+
+void hv_ghcb_msr_write(u64 msr, u64 value)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
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
+	if (sev_es_ghcb_hv_call_simple(&hv_ghcb->ghcb, SVM_EXIT_MSR, 1, 0))
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
+	if (sev_es_ghcb_hv_call_simple(&hv_ghcb->ghcb, SVM_EXIT_MSR, 0, 0))
+		pr_warn("Fail to read msr via ghcb %llx.\n", msr);
+	else
+		*value = (u64)lower_32_bits(hv_ghcb->ghcb.save.rax)
+			| ((u64)lower_32_bits(hv_ghcb->ghcb.save.rdx) << 32);
+	local_irq_restore(flags);
+}
+
+void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value)
+{
+	hv_ghcb_msr_read(msr, value);
+}
+EXPORT_SYMBOL_GPL(hv_sint_rdmsrl_ghcb);
+
+void hv_sint_wrmsrl_ghcb(u64 msr, u64 value)
+{
+	hv_ghcb_msr_write(msr, value);
+
+	/* Write proxy bit vua wrmsrl instruction. */
+	if (msr >= HV_X64_MSR_SINT0 && msr <= HV_X64_MSR_SINT15)
+		wrmsrl(msr, value | 1 << 20);
+}
+EXPORT_SYMBOL_GPL(hv_sint_wrmsrl_ghcb);
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
+
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
  *
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index ffb2af079c6b..b77f4caee3ee 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -11,6 +11,8 @@
 #include <asm/paravirt.h>
 #include <asm/mshyperv.h>
 
+union hv_ghcb;
+
 DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
 
 typedef int (*hyperv_fill_flush_list_func)(
@@ -30,6 +32,61 @@ static inline u64 hv_get_register(unsigned int reg)
 	return value;
 }
 
+#define hv_get_sint_reg(val, reg) {		\
+	if (hv_isolation_type_snp())		\
+		hv_get_##reg##_ghcb(&val);	\
+	else					\
+		rdmsrl(HV_REGISTER_##reg, val);	\
+	}
+
+#define hv_set_sint_reg(val, reg) {		\
+	if (hv_isolation_type_snp())		\
+		hv_set_##reg##_ghcb(val);	\
+	else					\
+		wrmsrl(HV_REGISTER_##reg, val);	\
+	}
+
+
+#define hv_get_simp(val) hv_get_sint_reg(val, SIMP)
+#define hv_get_siefp(val) hv_get_sint_reg(val, SIEFP)
+
+#define hv_set_simp(val) hv_set_sint_reg(val, SIMP)
+#define hv_set_siefp(val) hv_set_sint_reg(val, SIEFP)
+
+#define hv_get_synic_state(val) {			\
+	if (hv_isolation_type_snp())			\
+		hv_get_synic_state_ghcb(&val);		\
+	else						\
+		rdmsrl(HV_REGISTER_SCONTROL, val);	\
+	}
+#define hv_set_synic_state(val) {			\
+	if (hv_isolation_type_snp())			\
+		hv_set_synic_state_ghcb(val);		\
+	else						\
+		wrmsrl(HV_REGISTER_SCONTROL, val);	\
+	}
+
+#define hv_signal_eom(old_msg_type) {		 \
+	if (hv_isolation_type_snp() &&		 \
+	    old_msg_type != HVMSG_TIMER_EXPIRED) \
+		hv_sint_wrmsrl_ghcb(HV_REGISTER_EOM, 0); \
+	else						\
+		wrmsrl(HV_REGISTER_EOM, 0);		\
+	}
+
+#define hv_get_synint_state(int_num, val) {		\
+	if (hv_isolation_type_snp())			\
+		hv_get_synint_state_ghcb(int_num, &val);\
+	else						\
+		rdmsrl(HV_REGISTER_SINT0 + int_num, val);\
+	}
+#define hv_set_synint_state(int_num, val) {		\
+	if (hv_isolation_type_snp())			\
+		hv_set_synint_state_ghcb(int_num, val);	\
+	else						\
+		wrmsrl(HV_REGISTER_SINT0 + int_num, val);\
+	}
+
 #define hv_get_raw_timer() rdtsc_ordered()
 
 void hyperv_vector_handler(struct pt_regs *regs);
@@ -41,7 +98,7 @@ extern void *hv_hypercall_pg;
 
 extern u64 hv_current_partition_id;
 
-extern void __percpu **hv_ghcb_pg;
+extern union hv_ghcb  __percpu **hv_ghcb_pg;
 
 int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages);
 int hv_call_add_logical_proc(int node, u32 lp_index, u32 acpi_id);
@@ -195,6 +252,25 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
 int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
 			   enum hv_mem_host_visibility visibility);
 int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible);
+void hv_sint_wrmsrl_ghcb(u64 msr, u64 value);
+void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
+void hv_signal_eom_ghcb(void);
+void hv_ghcb_msr_write(u64 msr, u64 value);
+void hv_ghcb_msr_read(u64 msr, u64 *value);
+
+#define hv_get_synint_state_ghcb(int_num, val)			\
+	hv_sint_rdmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
+#define hv_set_synint_state_ghcb(int_num, val) \
+	hv_sint_wrmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
+
+#define hv_get_SIMP_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SIMP, val)
+#define hv_set_SIMP_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SIMP, val)
+
+#define hv_get_SIEFP_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SIEFP, val)
+#define hv_set_SIEFP_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SIEFP, val)
+
+#define hv_get_synic_state_ghcb(val) hv_sint_rdmsrl_ghcb(HV_X64_MSR_SCONTROL, val)
+#define hv_set_synic_state_ghcb(val) hv_sint_wrmsrl_ghcb(HV_X64_MSR_SCONTROL, val)
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
@@ -211,9 +287,9 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 {
 	return -1;
 }
+static inline void hv_signal_eom_ghcb(void) { };
 #endif /* CONFIG_HYPERV */
 
-
 #include <asm-generic/mshyperv.h>
 
 #endif
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..81beb2a8031b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,6 +81,9 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
+				   u64 exit_code, u64 exit_info_1,
+				   u64 exit_info_2);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 9f90f460a28c..dd7f37de640b 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->ip += ctxt->insn.length;
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2)
+enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
+				   u64 exit_code, u64 exit_info_1,
+				   u64 exit_info_2)
 {
 	enum es_result ret;
 
@@ -109,29 +108,45 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	sev_es_wr_ghcb_msr(__pa(ghcb));
 	VMGEXIT();
 
-	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
-		u64 info = ghcb->save.sw_exit_info_2;
-		unsigned long v;
-
-		info = ghcb->save.sw_exit_info_2;
-		v = info & SVM_EVTINJ_VEC_MASK;
-
-		/* Check if exception information from hypervisor is sane. */
-		if ((info & SVM_EVTINJ_VALID) &&
-		    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
-		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
-			ctxt->fi.vector = v;
-			if (info & SVM_EVTINJ_VALID_ERR)
-				ctxt->fi.error_code = info >> 32;
-			ret = ES_EXCEPTION;
-		} else {
-			ret = ES_VMM_ERROR;
-		}
-	} else {
+	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1)
+		ret = ES_VMM_ERROR;
+	else
 		ret = ES_OK;
+
+	return ret;
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+				   struct es_em_ctxt *ctxt,
+				   u64 exit_code, u64 exit_info_1,
+				   u64 exit_info_2)
+{
+	unsigned long v;
+	enum es_result ret;
+	u64 info;
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+
+	ret = sev_es_ghcb_hv_call_simple(ghcb, exit_code, exit_info_1,
+					 exit_info_2);
+	if (ret == ES_OK)
+		return ret;
+
+	info = ghcb->save.sw_exit_info_2;
+	v = info & SVM_EVTINJ_VEC_MASK;
+
+	/* Check if exception information from hypervisor is sane. */
+	if ((info & SVM_EVTINJ_VALID) &&
+	    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
+	    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
+		ctxt->fi.vector = v;
+		if (info & SVM_EVTINJ_VALID_ERR)
+			ctxt->fi.error_code = info >> 32;
+		ret = ES_EXCEPTION;
+	} else {
+		ret = ES_VMM_ERROR;
 	}
 
 	return ret;
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index e83507f49676..97b21256a9db 100644
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
@@ -199,26 +207,43 @@ void hv_synic_enable_regs(unsigned int cpu)
 	union hv_synic_scontrol sctrl;
 
 	/* Setup the Synic's message page */
-	simp.as_uint64 = hv_get_register(HV_REGISTER_SIMP);
+	hv_get_simp(simp.as_uint64);
 	simp.simp_enabled = 1;
-	simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
-		>> HV_HYP_PAGE_SHIFT;
 
-	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
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
+
+	hv_set_simp(simp.as_uint64);
 
 	/* Setup the Synic's event page */
-	siefp.as_uint64 = hv_get_register(HV_REGISTER_SIEFP);
+	hv_get_siefp(siefp.as_uint64);
 	siefp.siefp_enabled = 1;
-	siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
-		>> HV_HYP_PAGE_SHIFT;
 
-	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
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
+	hv_set_siefp(siefp.as_uint64);
 
 	/* Setup the shared SINT. */
 	if (vmbus_irq != -1)
 		enable_percpu_irq(vmbus_irq, 0);
-	shared_sint.as_uint64 = hv_get_register(HV_REGISTER_SINT0 +
-					VMBUS_MESSAGE_SINT);
+	hv_get_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	shared_sint.vector = vmbus_interrupt;
 	shared_sint.masked = false;
@@ -233,14 +258,12 @@ void hv_synic_enable_regs(unsigned int cpu)
 #else
 	shared_sint.auto_eoi = 0;
 #endif
-	hv_set_register(HV_REGISTER_SINT0 + VMBUS_MESSAGE_SINT,
-				shared_sint.as_uint64);
+	hv_set_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	/* Enable the global synic bit */
-	sctrl.as_uint64 = hv_get_register(HV_REGISTER_SCONTROL);
+	hv_get_synic_state(sctrl.as_uint64);
 	sctrl.enable = 1;
-
-	hv_set_register(HV_REGISTER_SCONTROL, sctrl.as_uint64);
+	hv_set_synic_state(sctrl.as_uint64);
 }
 
 int hv_synic_init(unsigned int cpu)
@@ -257,37 +280,50 @@ int hv_synic_init(unsigned int cpu)
  */
 void hv_synic_disable_regs(unsigned int cpu)
 {
+	struct hv_per_cpu_context *hv_cpu
+		= per_cpu_ptr(hv_context.cpu_context, cpu);
 	union hv_synic_sint shared_sint;
 	union hv_synic_simp simp;
 	union hv_synic_siefp siefp;
 	union hv_synic_scontrol sctrl;
 
-	shared_sint.as_uint64 = hv_get_register(HV_REGISTER_SINT0 +
-					VMBUS_MESSAGE_SINT);
-
+	hv_get_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 	shared_sint.masked = 1;
+	hv_set_synint_state(VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
+
 
 	/* Need to correctly cleanup in the case of SMP!!! */
 	/* Disable the interrupt */
-	hv_set_register(HV_REGISTER_SINT0 + VMBUS_MESSAGE_SINT,
-				shared_sint.as_uint64);
+	hv_get_simp(simp.as_uint64);
 
-	simp.as_uint64 = hv_get_register(HV_REGISTER_SIMP);
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
 
-	hv_set_register(HV_REGISTER_SIMP, simp.as_uint64);
+	hv_set_simp(simp.as_uint64);
 
-	siefp.as_uint64 = hv_get_register(HV_REGISTER_SIEFP);
+	hv_get_siefp(siefp.as_uint64);
 	siefp.siefp_enabled = 0;
-	siefp.base_siefp_gpa = 0;
 
-	hv_set_register(HV_REGISTER_SIEFP, siefp.as_uint64);
+	if (hv_isolation_type_snp())
+		memunmap(hv_cpu->synic_event_page);
+	else
+		siefp.base_siefp_gpa = 0;
+
+	hv_set_siefp(siefp.as_uint64);
 
 	/* Disable the global synic bit */
-	sctrl.as_uint64 = hv_get_register(HV_REGISTER_SCONTROL);
+	hv_get_synic_state(sctrl.as_uint64);
 	sctrl.enable = 0;
-	hv_set_register(HV_REGISTER_SCONTROL, sctrl.as_uint64);
+	hv_set_synic_state(sctrl.as_uint64);
 
 	if (vmbus_irq != -1)
 		disable_percpu_irq(vmbus_irq);
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
index aa55447b9700..04a687d95eac 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -24,6 +24,7 @@
 #include <linux/cpumask.h>
 #include <linux/nmi.h>
 #include <asm/ptrace.h>
+#include <asm/mshyperv.h>
 #include <asm/hyperv-tlfs.h>
 
 struct ms_hyperv_info {
@@ -54,6 +55,7 @@ extern void  __percpu  **hyperv_pcpu_output_arg;
 
 extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputaddr);
 extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
+extern bool hv_isolation_type_snp(void);
 
 /* Helper functions that provide a consistent pattern for checking Hyper-V hypercall status. */
 static inline int hv_result(u64 status)
@@ -148,7 +150,7 @@ static inline void vmbus_signal_eom(struct hv_message *msg, u32 old_msg_type)
 		 * possibly deliver another msg from the
 		 * hypervisor
 		 */
-		hv_set_register(HV_REGISTER_EOM, 0);
+		hv_signal_eom(old_msg_type);
 	}
 }
 
-- 
2.25.1

