Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78A35F6CD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352090AbhDNOvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351955AbhDNOuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:51 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48EBC06138C;
        Wed, 14 Apr 2021 07:50:28 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w8so7905465plg.9;
        Wed, 14 Apr 2021 07:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4uHLDXPTV0NPaJIPR0JcU4jnzokfZP+lvBQuVxSWxeo=;
        b=nz98yTtMltCvc8Lxfq4xMqWxGfuacMv6r1QxoLnhLqwEJVXhV14zOJuZJk+Qpe6Eh2
         LQBFybrZrRrAPeV5c9jwoCQhjUxuCzEm2HyA8UpdL1ZyGqunpDdxSoB0bpWpXHgydWm0
         NP4ZYbte8Cj2Mm9o9A9JalIHNGFbQjKvuhzRjxaq+5eoYjMr5ZkXSrl8kP7EPsWrZXv4
         fbIcXezTUHFNuiEl/leuLsb4nTDN3g/iZi6bXSfF/uijSv9wY/FGr+K5QwCHGra8knj3
         5NUoOm6VqALCqxQJMX9YpAL3igLtgbiNMoNPGHEOz4kiZ0AW4E3sQ4LJgr4FIkNSG9Xh
         EBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4uHLDXPTV0NPaJIPR0JcU4jnzokfZP+lvBQuVxSWxeo=;
        b=gz9uFWl6bW1rH4r/mwXE6hp9M477Lj7Odakmu6CcvmUezM4tqs+pICNfZ/gXxQo0yq
         Ltzm6O2Fs0ltsKpI4Es/l3BnDFCrjhVuBUazcDocKOHi/wA1+G9NEFRwdPQ8XRReF/Hh
         N8lhejf8iWQuh7vMFEO4VOFAirPCsp0/TpkCfHiYGq5bjPh557NCaJtk5nPpNxbL5l+Y
         kAB+GzxK4+4Cgayx7rqM8l9TH/iyUQibS9o84Ag1CGI9MAlN4wmkD0+KZ+DzlRxt62yx
         zmqFlByXEyFGiVWR6QvHgBeey6YuZef1lOy07HNc4AaGE7ZIygl69OGcsEbnOCFFVQN1
         WqmA==
X-Gm-Message-State: AOAM533FI855UKGZEmAmkunjDXn9Q1P0Q/ktak7q+9UzCU/JcE4KDfYr
        bYMcYXEmED+1Wo2pQjH2+sI=
X-Google-Smtp-Source: ABdhPJxNEHJsldB9/l9DrcCPvmaCi5un8TIOv2g6d7WPnLPy6fp1j7ZtGlaVow6yyJCqbdyXmxus9A==
X-Received: by 2002:a17:90a:5907:: with SMTP id k7mr4219377pji.197.1618411828425;
        Wed, 14 Apr 2021 07:50:28 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:28 -0700 (PDT)
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
Subject: [Resend RFC PATCH V2 04/12]  HV: Add Write/Read MSR registers via ghcb
Date:   Wed, 14 Apr 2021 10:49:37 -0400
Message-Id: <20210414144945.3460554-5-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V provides GHCB protocol to write Synthetic Interrupt
Controller MSR registers and these registers are emulated by
Hypervisor rather than paravisor.

Hyper-V requests to write SINTx MSR registers twice(once via
GHCB and once via wrmsr instruction including the proxy bit 21)
Guest OS ID MSR also needs to be set via GHCB.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/hv_init.c       |  18 +----
 arch/x86/hyperv/ivm.c           | 130 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h |  87 +++++++++++++++++----
 arch/x86/kernel/cpu/mshyperv.c  |   3 +
 drivers/hv/hv.c                 |  65 +++++++++++-----
 include/asm-generic/mshyperv.h  |   4 +-
 6 files changed, 261 insertions(+), 46 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 90e65fbf4c58..87b1dd9c84d6 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -475,6 +475,9 @@ void __init hyperv_init(void)
 
 		ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
 		*ghcb_base = ghcb_va;
+
+		/* Hyper-V requires to write guest os id via ghcb in SNP IVM. */
+		hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, guest_id);
 	}
 
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
@@ -561,6 +564,7 @@ void hyperv_cleanup(void)
 
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
+	hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
 
 	/*
 	 * Reset hypercall page reference before reset the page,
@@ -668,17 +672,3 @@ bool hv_is_hibernation_supported(void)
 	return !hv_root_partition && acpi_sleep_state_supported(ACPI_STATE_S4);
 }
 EXPORT_SYMBOL_GPL(hv_is_hibernation_supported);
-
-enum hv_isolation_type hv_get_isolation_type(void)
-{
-	if (!(ms_hyperv.features_b & HV_ISOLATION))
-		return HV_ISOLATION_TYPE_NONE;
-	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
-}
-EXPORT_SYMBOL_GPL(hv_get_isolation_type);
-
-bool hv_is_isolation_supported(void)
-{
-	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
-}
-EXPORT_SYMBOL_GPL(hv_is_isolation_supported);
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index a5950b7a9214..2ec64b367aaf 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -6,12 +6,139 @@
  *  Tianyu Lan <Tianyu.Lan@microsoft.com>
  */
 
+#include <linux/types.h>
+#include <linux/bitfield.h>
 #include <linux/hyperv.h>
 #include <linux/types.h>
 #include <linux/bitfield.h>
 #include <asm/io.h>
+#include <asm/svm.h>
+#include <asm/sev-es.h>
 #include <asm/mshyperv.h>
 
+union hv_ghcb {
+	struct ghcb ghcb;
+} __packed __aligned(PAGE_SIZE);
+
+void hv_ghcb_msr_write(u64 msr, u64 value)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
+
+	if (!ms_hyperv.ghcb_base)
+		return;
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
+	hv_ghcb->ghcb.protocol_version = 1;
+	hv_ghcb->ghcb.ghcb_usage = 0;
+
+	ghcb_set_sw_exit_code(&hv_ghcb->ghcb, SVM_EXIT_MSR);
+	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
+	ghcb_set_rax(&hv_ghcb->ghcb, lower_32_bits(value));
+	ghcb_set_rdx(&hv_ghcb->ghcb, value >> 32);
+	ghcb_set_sw_exit_info_1(&hv_ghcb->ghcb, 1);
+	ghcb_set_sw_exit_info_2(&hv_ghcb->ghcb, 0);
+
+	VMGEXIT();
+
+	if ((hv_ghcb->ghcb.save.sw_exit_info_1 & 0xffffffff) == 1)
+		pr_warn("Fail to write msr via ghcb.\n.");
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(hv_ghcb_msr_write);
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
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+	hv_ghcb = (union hv_ghcb *)*ghcb_base;
+	if (!hv_ghcb) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	memset(hv_ghcb, 0x00, PAGE_SIZE);
+	hv_ghcb->ghcb.protocol_version = 1;
+	hv_ghcb->ghcb.ghcb_usage = 0;
+
+	ghcb_set_sw_exit_code(&hv_ghcb->ghcb, SVM_EXIT_MSR);
+	ghcb_set_rcx(&hv_ghcb->ghcb, msr);
+	ghcb_set_sw_exit_info_1(&hv_ghcb->ghcb, 0);
+	ghcb_set_sw_exit_info_2(&hv_ghcb->ghcb, 0);
+
+	VMGEXIT();
+
+	if ((hv_ghcb->ghcb.save.sw_exit_info_1 & 0xffffffff) == 1)
+		pr_warn("Fail to write msr via ghcb.\n.");
+	else
+		*value = (u64)lower_32_bits(hv_ghcb->ghcb.save.rax)
+			| ((u64)lower_32_bits(hv_ghcb->ghcb.save.rdx) << 32);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(hv_ghcb_msr_read);
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
+inline void hv_signal_eom_ghcb(void)
+{
+	hv_sint_wrmsrl_ghcb(HV_X64_MSR_EOM, 0);
+}
+EXPORT_SYMBOL_GPL(hv_signal_eom_ghcb);
+
+enum hv_isolation_type hv_get_isolation_type(void)
+{
+	if (!(ms_hyperv.features_b & HV_ISOLATION))
+		return HV_ISOLATION_TYPE_NONE;
+	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
+}
+EXPORT_SYMBOL_GPL(hv_get_isolation_type);
+
+bool hv_is_isolation_supported(void)
+{
+	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
+}
+EXPORT_SYMBOL_GPL(hv_is_isolation_supported);
+
+DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
+
+bool hv_isolation_type_snp(void)
+{
+	return static_branch_unlikely(&isolation_type_snp);
+}
+EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
+
 /*
  * hv_set_mem_host_visibility - Set host visibility for specified memory.
  */
@@ -22,6 +149,9 @@ int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)
 	u64 *pfn_array;
 	int ret = 0;
 
+	if (!hv_is_isolation_supported())
+		return 0;
+
 	pfn_array = vzalloc(HV_HYP_PAGE_SIZE);
 	if (!pfn_array)
 		return -ENOMEM;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index d9437f096ce5..73501dbbc240 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -10,6 +10,8 @@
 #include <asm/nospec-branch.h>
 #include <asm/paravirt.h>
 
+DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
+
 typedef int (*hyperv_fill_flush_list_func)(
 		struct hv_guest_mapping_flush_list *flush,
 		void *data);
@@ -19,24 +21,64 @@ typedef int (*hyperv_fill_flush_list_func)(
 #define hv_init_timer_config(timer, val) \
 	wrmsrl(HV_X64_MSR_STIMER0_CONFIG + (2*timer), val)
 
-#define hv_get_simp(val) rdmsrl(HV_X64_MSR_SIMP, val)
-#define hv_set_simp(val) wrmsrl(HV_X64_MSR_SIMP, val)
+#define hv_get_sint_reg(val, reg) {		\
+	if (hv_isolation_type_snp())		\
+		hv_get_##reg##_ghcb(&val);		\
+	else					\
+		rdmsrl(HV_X64_MSR_##reg, val);	\
+	}
+
+#define hv_set_sint_reg(val, reg) {		\
+	if (hv_isolation_type_snp())		\
+		hv_set_##reg##_ghcb(val);		\
+	else					\
+		wrmsrl(HV_X64_MSR_##reg, val);	\
+	}
+
 
-#define hv_get_siefp(val) rdmsrl(HV_X64_MSR_SIEFP, val)
-#define hv_set_siefp(val) wrmsrl(HV_X64_MSR_SIEFP, val)
+#define hv_get_simp(val) hv_get_sint_reg(val, SIMP)
+#define hv_get_siefp(val) hv_get_sint_reg(val, SIEFP)
 
-#define hv_get_synic_state(val) rdmsrl(HV_X64_MSR_SCONTROL, val)
-#define hv_set_synic_state(val) wrmsrl(HV_X64_MSR_SCONTROL, val)
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
 
 #define hv_get_vp_index(index) rdmsrl(HV_X64_MSR_VP_INDEX, index)
 
-#define hv_signal_eom() wrmsrl(HV_X64_MSR_EOM, 0)
+#define hv_signal_eom() {			 \
+	if (hv_isolation_type_snp() &&		 \
+	    old_msg_type != HVMSG_TIMER_EXPIRED) \
+		hv_signal_eom_ghcb();		 \
+	else					 \
+		wrmsrl(HV_X64_MSR_EOM, 0);	 \
+	}
 
-#define hv_get_synint_state(int_num, val) \
-	rdmsrl(HV_X64_MSR_SINT0 + int_num, val)
-#define hv_set_synint_state(int_num, val) \
-	wrmsrl(HV_X64_MSR_SINT0 + int_num, val)
-#define hv_recommend_using_aeoi() \
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
+#define hv_recommend_using_aeoi()				\
 	(!(ms_hyperv.hints & HV_DEPRECATING_AEOI_RECOMMENDED))
 
 #define hv_get_crash_ctl(val) \
@@ -271,6 +313,25 @@ int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
 
 int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility);
 int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
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
@@ -289,9 +350,9 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 {
 	return -1;
 }
+static inline void hv_signal_eom_ghcb(void) { };
 #endif /* CONFIG_HYPERV */
 
-
 #include <asm-generic/mshyperv.h>
 
 #endif
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index aeafd4017c89..6eaa0891c0f7 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -333,6 +333,9 @@ static void __init ms_hyperv_init_platform(void)
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
+
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
+			static_branch_enable(&isolation_type_snp);
 	}
 
 	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index f202ac7f4b3d..069530eeb7c6 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -99,17 +99,24 @@ int hv_synic_alloc(void)
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
@@ -136,10 +143,17 @@ void hv_synic_free(void)
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
@@ -161,20 +175,36 @@ void hv_synic_enable_regs(unsigned int cpu)
 	union hv_synic_sint shared_sint;
 	union hv_synic_scontrol sctrl;
 
-	/* Setup the Synic's message page */
+
+	/* Setup the Synic's message. */
 	hv_get_simp(simp.as_uint64);
 	simp.simp_enabled = 1;
-	simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
-		>> HV_HYP_PAGE_SHIFT;
+
+	if (hv_isolation_type_snp()) {
+		hv_cpu->synic_message_page
+			= ioremap_cache(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
+					HV_HYP_PAGE_SIZE);
+		if (!hv_cpu->synic_message_page)
+			pr_err("Fail to map syinc message page.\n");
+	} else {
+		simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
+			>> HV_HYP_PAGE_SHIFT;
+	}
 
 	hv_set_simp(simp.as_uint64);
 
 	/* Setup the Synic's event page */
 	hv_get_siefp(siefp.as_uint64);
 	siefp.siefp_enabled = 1;
-	siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
-		>> HV_HYP_PAGE_SHIFT;
-
+	if (hv_isolation_type_snp()) {
+		hv_cpu->synic_event_page = ioremap_cache(
+			 siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT, HV_HYP_PAGE_SIZE);
+		if (!hv_cpu->synic_event_page)
+			pr_err("Fail to map syinc event page.\n");
+	} else {
+		siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
+			>> HV_HYP_PAGE_SHIFT;
+	}
 	hv_set_siefp(siefp.as_uint64);
 
 	/* Setup the shared SINT. */
@@ -188,7 +218,6 @@ void hv_synic_enable_regs(unsigned int cpu)
 	/* Enable the global synic bit */
 	hv_get_synic_state(sctrl.as_uint64);
 	sctrl.enable = 1;
-
 	hv_set_synic_state(sctrl.as_uint64);
 }
 
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index b73e201abc70..59777377e641 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -23,6 +23,7 @@
 #include <linux/bitops.h>
 #include <linux/cpumask.h>
 #include <asm/ptrace.h>
+#include <asm/mshyperv.h>
 #include <asm/hyperv-tlfs.h>
 
 struct ms_hyperv_info {
@@ -52,7 +53,7 @@ extern struct ms_hyperv_info ms_hyperv;
 
 extern u64 hv_do_hypercall(u64 control, void *inputaddr, void *outputaddr);
 extern u64 hv_do_fast_hypercall8(u16 control, u64 input8);
-
+extern bool hv_isolation_type_snp(void);
 
 /* Generate the guest OS identifier as described in the Hyper-V TLFS */
 static inline  __u64 generate_guest_id(__u64 d_info1, __u64 kernel_version,
@@ -186,6 +187,7 @@ bool hv_is_hyperv_initialized(void);
 bool hv_is_hibernation_supported(void);
 enum hv_isolation_type hv_get_isolation_type(void);
 bool hv_is_isolation_supported(void);
+bool hv_isolation_type_snp(void);
 void hyperv_cleanup(void);
 #else /* CONFIG_HYPERV */
 static inline bool hv_is_hyperv_initialized(void) { return false; }
-- 
2.25.1

