Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6082D3D9122
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhG1Oxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237193AbhG1OxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 10:53:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F810C0613C1;
        Wed, 28 Jul 2021 07:53:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so10410364pjb.3;
        Wed, 28 Jul 2021 07:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HB97a+2OhA3eQm24fC97PNoK0NDP1pJHHUMQuiKyYaM=;
        b=VtdJuUxlciBl6pJKd+T5kPRnYqd4ADa8ubLACu1CVtNEwjYJlxr6eDq4+Hgfya+Te6
         PvnGqgUHTKpdkX0DI5yBZrcTH08G9xfi8ByRylJS+rQNdBVLN52e1QC99fLLVE4Gewuk
         wsLXwPZKb9LDn1HRTpPaZXhsqfC/c04IGxbNz35Gi3i7k1h7G/XDTXWKSyXE1UaFWPY5
         onQqhH0PUc2MzGtKX+YPuIlyMYvuZmSeK3fAQ5U4fCdjCpsRy+OqjnMlxUwK/ToqunsD
         Cfb0x4z6CqpNpUexwa90vvWfcWZHgWT0i4DgoK6is5msDBDI/SrDjm3ravlTkHksJsLc
         9uYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HB97a+2OhA3eQm24fC97PNoK0NDP1pJHHUMQuiKyYaM=;
        b=sZdap3KjXNNsTJMex5AjQdhTcOdo6VczHchie1s0WkjZsYGgfS/Ak8suFhvlvww/cv
         G6GGouqmhgAi2yK4l63IfGz/r+b2+blNzabqG/9y4JnboZ3X7AkQob6RaolJcZwNV5Jh
         ti4zy2zN+BLZXUO4DFT9IbO3yDSHzaXcd8GveBCIthv3DS1/zqtv9X04lW0+thrrrSlw
         UdqX6Zv+bNwCut5zJfVnQfDQ7cY09o6q9FHzskeQ5YuacU1R01qVhQwTnm97MSXJfX0M
         0lMjv7ENWe0DdqHfKFa84fE+aifapHAUYij0wTIhbzC84jWiIyIJcBUgnJLlelJzVSGT
         fatg==
X-Gm-Message-State: AOAM531bZG3br1Z36tcM8UpgaqFX/0TNNiMx7T4PsexTTbIAEl2UkpWq
        oTbqsJ8bw9wHirnx8oD9rPQ=
X-Google-Smtp-Source: ABdhPJwJR0YDD/874EWanOoXxDHqUKtLEIWjbHNtwnsflKAdj5/12656WWege/+q5qLjYQ2qOK3pTw==
X-Received: by 2002:a63:b953:: with SMTP id v19mr228948pgo.40.1627483999761;
        Wed, 28 Jul 2021 07:53:19 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:3823:141e:6d51:f0ad])
        by smtp.gmail.com with ESMTPSA id n134sm277558pfd.89.2021.07.28.07.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:53:19 -0700 (PDT)
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
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com
Subject: [PATCH 05/13] HV: Add Write/Read MSR registers via ghcb page
Date:   Wed, 28 Jul 2021 10:52:20 -0400
Message-Id: <20210728145232.285861-6-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728145232.285861-1-ltykernel@gmail.com>
References: <20210728145232.285861-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V provides GHCB protocol to write Synthetic Interrupt
Controller MSR registers in Isolation VM with AMD SEV SNP
and these registers are emulated by hypervisor directly.
Hyper-V requires to write SINTx MSR registers twice. First
writes MSR via GHCB page to communicate with hypervisor
and then writes wrmsr instruction to talk with paravisor
which runs in VMPL0. Guest OS ID MSR also needs to be set
via GHCB.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/hv_init.c       |  16 +----
 arch/x86/hyperv/ivm.c           | 114 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h |  78 +++++++++++++++++++-
 arch/x86/include/asm/sev.h      |   4 ++
 arch/x86/kernel/cpu/mshyperv.c  |   3 +
 arch/x86/kernel/sev-shared.c    |  21 ++++--
 drivers/hv/hv.c                 | 121 ++++++++++++++++++++++----------
 include/asm-generic/mshyperv.h  |  12 +++-
 8 files changed, 307 insertions(+), 62 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index ee449c076ef4..b99f6b3930b7 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -392,7 +392,7 @@ void __init hyperv_init(void)
 		goto clean_guest_os_id;
 
 	if (hv_isolation_type_snp()) {
-		ms_hyperv.ghcb_base = alloc_percpu(void *);
+		ms_hyperv.ghcb_base = alloc_percpu(union hv_ghcb __percpu *);
 		if (!ms_hyperv.ghcb_base)
 			goto clean_guest_os_id;
 
@@ -485,6 +485,7 @@ void hyperv_cleanup(void)
 
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
+	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
 
 	/*
 	 * Reset hypercall page reference before reset the page,
@@ -558,16 +559,3 @@ bool hv_is_hyperv_initialized(void)
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
-	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
-}
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 24a58795abd8..9c30d5bb7b64 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -6,6 +6,8 @@
  *  Tianyu Lan <Tianyu.Lan@microsoft.com>
  */
 
+#include <linux/types.h>
+#include <linux/bitfield.h>
 #include <linux/hyperv.h>
 #include <linux/types.h>
 #include <linux/bitfield.h>
@@ -13,6 +15,118 @@
 #include <asm/io.h>
 #include <asm/mshyperv.h>
 
+void hv_ghcb_msr_write(u64 msr, u64 value)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
+
+	if (!ms_hyperv.ghcb_base)
+		return;
+
+	WARN_ON(in_nmi());
+
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+	hv_ghcb = (union hv_ghcb *)*ghcb_base;
+	if (!hv_ghcb) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	memset(hv_ghcb, 0x00, HV_HYP_PAGE_SIZE);
+
+	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
+	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
+	ghcb_set_rdx(&hv_ghcb->ghcb, value >> 32);
+
+	if (sev_es_ghcb_hv_call(&hv_ghcb->ghcb, NULL, SVM_EXIT_MSR, 1, 0))
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
+	if (!ms_hyperv.ghcb_base)
+		return;
+
+	WARN_ON(in_nmi());
+
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+	hv_ghcb = (union hv_ghcb *)*ghcb_base;
+	if (!hv_ghcb) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	memset(hv_ghcb, 0x00, HV_HYP_PAGE_SIZE);
+
+	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
+	if (sev_es_ghcb_hv_call(&hv_ghcb->ghcb, NULL, SVM_EXIT_MSR, 0, 0))
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
+void hv_signal_eom_ghcb(void)
+{
+	hv_sint_wrmsrl_ghcb(HV_X64_MSR_EOM, 0);
+}
+EXPORT_SYMBOL_GPL(hv_signal_eom_ghcb);
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
+EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
+
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
  *
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 68dd207c2603..3c0cafdf7309 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -30,6 +30,63 @@ static inline u64 hv_get_register(unsigned int reg)
 	return value;
 }
 
+#define hv_get_sint_reg(val, reg) {		\
+	if (hv_isolation_type_snp())		\
+		hv_get_##reg##_ghcb(&val);	\
+	else					\
+		rdmsrl(HV_X64_MSR_##reg, val);	\
+	}
+
+#define hv_set_sint_reg(val, reg) {		\
+	if (hv_isolation_type_snp())		\
+		hv_set_##reg##_ghcb(val);	\
+	else					\
+		wrmsrl(HV_X64_MSR_##reg, val);	\
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
+		rdmsrl(HV_X64_MSR_SCONTROL, val);	\
+	}
+#define hv_set_synic_state(val) {			\
+	if (hv_isolation_type_snp())			\
+		hv_set_synic_state_ghcb(val);		\
+	else						\
+		wrmsrl(HV_X64_MSR_SCONTROL, val);	\
+	}
+
+#define hv_get_vp_index(index) rdmsrl(HV_X64_MSR_VP_INDEX, index)
+
+#define hv_signal_eom() {			 \
+	if (hv_isolation_type_snp() &&		 \
+	    old_msg_type != HVMSG_TIMER_EXPIRED) \
+		hv_signal_eom_ghcb();		 \
+	else					 \
+		wrmsrl(HV_X64_MSR_EOM, 0);	 \
+	}
+
+#define hv_get_synint_state(int_num, val) {		\
+	if (hv_isolation_type_snp())			\
+		hv_get_synint_state_ghcb(int_num, &val);\
+	else						\
+		rdmsrl(HV_X64_MSR_SINT0 + int_num, val);\
+	}
+#define hv_set_synint_state(int_num, val) {		\
+	if (hv_isolation_type_snp())			\
+		hv_set_synint_state_ghcb(int_num, val);	\
+	else						\
+		wrmsrl(HV_X64_MSR_SINT0 + int_num, val);\
+	}
+
 #define hv_get_raw_timer() rdtsc_ordered()
 
 void hyperv_vector_handler(struct pt_regs *regs);
@@ -192,6 +249,25 @@ int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
 int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
 int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
 int hv_set_mem_enc(unsigned long addr, int numpages, bool enc);
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
@@ -208,9 +284,9 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 {
 	return -1;
 }
+static inline void hv_signal_eom_ghcb(void) { };
 #endif /* CONFIG_HYPERV */
 
-
 #include <asm-generic/mshyperv.h>
 
 #endif
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..4249fde0a30e 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,6 +81,10 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+				   struct es_em_ctxt *ctxt,
+				   u64 exit_code, u64 exit_info_1,
+				   u64 exit_info_2);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 773e84e134b3..46a09cdfa77a 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -332,6 +332,9 @@ static void __init ms_hyperv_init_platform(void)
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
+
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
+			static_branch_enable(&isolation_type_snp);
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 9f90f460a28c..e039e55b9c72 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -94,10 +94,10 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->ip += ctxt->insn.length;
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2)
+enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+				   struct es_em_ctxt *ctxt,
+				   u64 exit_code, u64 exit_info_1,
+				   u64 exit_info_2)
 {
 	enum es_result ret;
 
@@ -109,7 +109,16 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	sev_es_wr_ghcb_msr(__pa(ghcb));
+	/*
+	 * Hyper-V runs paravisor with SEV. Ghcb page is allocated by
+	 * paravisor and not needs to be updated in the Linux guest.
+	 * Otherwise, the ghcb page's PA reported by paravisor is above
+	 * VTOM. Hyper-V use this function with NULL for ctxt point and
+	 * skip setting ghcb page in such case.
+	 */
+	if (ctxt)
+		sev_es_wr_ghcb_msr(__pa(ghcb));
+
 	VMGEXIT();
 
 	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
@@ -120,7 +129,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 		v = info & SVM_EVTINJ_VEC_MASK;
 
 		/* Check if exception information from hypervisor is sane. */
-		if ((info & SVM_EVTINJ_VALID) &&
+		if (ctxt && (info & SVM_EVTINJ_VALID) &&
 		    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
 		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
 			ctxt->fi.vector = v;
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index e83507f49676..59f7173c4d9f 100644
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
@@ -173,10 +181,17 @@ void hv_synic_free(void)
 	for_each_present_cpu(cpu) {
 		struct hv_per_cpu_context *hv_cpu
 			= per_cpu_ptr(hv_context.cpu_context, cpu);
+		free_page((unsigned long)hv_cpu->post_msg_page);
+
+		/*
+		 * Synic message and event pages are allocated by paravisor.
+		 * Skip free these pages here.
+		 */
+		if (hv_isolation_type_snp())
+			continue;
 
 		free_page((unsigned long)hv_cpu->synic_event_page);
 		free_page((unsigned long)hv_cpu->synic_message_page);
-		free_page((unsigned long)hv_cpu->post_msg_page);
 	}
 
 	kfree(hv_context.hv_numa_map);
@@ -199,26 +214,43 @@ void hv_synic_enable_regs(unsigned int cpu)
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
@@ -233,14 +265,12 @@ void hv_synic_enable_regs(unsigned int cpu)
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
@@ -257,37 +287,50 @@ int hv_synic_init(unsigned int cpu)
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
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index aa26d24a5ca9..b0cfc25dffaa 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -23,9 +23,16 @@
 #include <linux/bitops.h>
 #include <linux/cpumask.h>
 #include <linux/nmi.h>
+#include <asm/svm.h>
+#include <asm/sev.h>
 #include <asm/ptrace.h>
+#include <asm/mshyperv.h>
 #include <asm/hyperv-tlfs.h>
 
+union hv_ghcb {
+	struct ghcb ghcb;
+} __packed __aligned(PAGE_SIZE);
+
 struct ms_hyperv_info {
 	u32 features;
 	u32 priv_high;
@@ -45,7 +52,7 @@ struct ms_hyperv_info {
 			u32 Reserved12 : 20;
 		};
 	};
-	void  __percpu **ghcb_base;
+	union hv_ghcb __percpu **ghcb_base;
 	u64 shared_gpa_boundary;
 };
 extern struct ms_hyperv_info ms_hyperv;
@@ -55,6 +62,7 @@ extern void  __percpu  **hyperv_pcpu_output_arg;
 
 extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputaddr);
 extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
+extern bool hv_isolation_type_snp(void);
 
 /* Helper functions that provide a consistent pattern for checking Hyper-V hypercall status. */
 static inline int hv_result(u64 status)
@@ -149,7 +157,7 @@ static inline void vmbus_signal_eom(struct hv_message *msg, u32 old_msg_type)
 		 * possibly deliver another msg from the
 		 * hypervisor
 		 */
-		hv_set_register(HV_REGISTER_EOM, 0);
+		hv_signal_eom();
 	}
 }
 
-- 
2.25.1

