Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392003D9109
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhG1OxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhG1OxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 10:53:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F835C061757;
        Wed, 28 Jul 2021 07:53:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id k1so2962372plt.12;
        Wed, 28 Jul 2021 07:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ra70YmOoKyUigRxssc8bdLw9SZJrXLPE0YQ4dcYNGVo=;
        b=LmKHehSzb54ioqXz1ez6t1x7O5R86K81v+pIequaacef/tO9BDCzSjcgHS6hGrhQv2
         qzARLAfbJyE6sHuqTHz9vyy6kXmEQNBaebh5fDgBK43+147na/gMGQQWfTHnt9bMZGW3
         PI/xSNfASsbrpBOIlGaXrQ5YMH8qB1cvo0ozOtA0lboOZTSaOrbYcfC4Zr/MGizHIj4K
         UQn2qOIx7n+NsKeHbyzbGo6c8gE+9TdBheq0rWZ1PelrbCELqStjq++WLQ17f+9YCPDK
         xG/Aw0FLnS5tr9GZTkXJZ/H6BWgFhS32PFT431EJh1q4PAKHp3O/cbydxcbUBibmcfx9
         Kdig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ra70YmOoKyUigRxssc8bdLw9SZJrXLPE0YQ4dcYNGVo=;
        b=pitx1pgtCp8nO0tl48fjTYeKWr66mOOU6q2tlI7Dql4DJr1I7fAtE+fPJLJmEAzODO
         2AcM33CFxkJbvOxMMMDIOYDfd60oSEHIjF6TqvWQ6EurtOkqRF97zEKErD5YpPXNJAyH
         YA2PZ1EichWrq5DOfyw3rf1yUwDi6Vtv9PE0or+ThQYCabRAJWtEigL67FvCfex41Fh+
         lX3ilj4rXIbdzIWhTdgT9VgaP0L9WSD8jJGl/GPthAXL6p3j1BPqQTeydr/PgFJNTxL/
         02hYttjtdumVMKDncy3fmaGg8j/sQ7IgUe00XdwyDoAerc7c5AXtabJJhIBtwVIkUuu0
         0bvw==
X-Gm-Message-State: AOAM533ZYfba16w56wN6brTOA385CjA07/spvZewoFr6oC0FvGJB9Qn6
        b/ZvKDVkOtDEyznmxMNceok=
X-Google-Smtp-Source: ABdhPJzsXb8YMbXnD2VQ8NxmDIMRNHMhIgP2MCg4JalE3hBkOx0ET9j7WaB1NV2mPcJTuLhWN1sM8A==
X-Received: by 2002:a17:90a:ce02:: with SMTP id f2mr9955691pju.232.1627483988220;
        Wed, 28 Jul 2021 07:53:08 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:3823:141e:6d51:f0ad])
        by smtp.gmail.com with ESMTPSA id n134sm277558pfd.89.2021.07.28.07.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:53:07 -0700 (PDT)
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
Subject: [PATCH 01/13] x86/HV: Initialize GHCB page in Isolation VM
Date:   Wed, 28 Jul 2021 10:52:16 -0400
Message-Id: <20210728145232.285861-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728145232.285861-1-ltykernel@gmail.com>
References: <20210728145232.285861-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V exposes GHCB page via SEV ES GHCB MSR for SNP guest
to communicate with hypervisor. Map GHCB page for all
cpus to read/write MSR register and submit hvcall request
via GHCB.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/hv_init.c       | 73 +++++++++++++++++++++++++++++++--
 arch/x86/include/asm/mshyperv.h |  2 +
 include/asm-generic/mshyperv.h  |  2 +
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 4a643a85d570..ee449c076ef4 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -20,6 +20,7 @@
 #include <linux/kexec.h>
 #include <linux/version.h>
 #include <linux/vmalloc.h>
+#include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/hyperv.h>
 #include <linux/slab.h>
@@ -42,6 +43,26 @@ static void *hv_hypercall_pg_saved;
 struct hv_vp_assist_page **hv_vp_assist_page;
 EXPORT_SYMBOL_GPL(hv_vp_assist_page);
 
+static int hyperv_init_ghcb(void)
+{
+	u64 ghcb_gpa;
+	void *ghcb_va;
+	void **ghcb_base;
+
+	if (!ms_hyperv.ghcb_base)
+		return -EINVAL;
+
+	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
+	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+	if (!ghcb_va)
+		return -ENOMEM;
+
+	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+	*ghcb_base = ghcb_va;
+
+	return 0;
+}
+
 static int hv_cpu_init(unsigned int cpu)
 {
 	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
@@ -75,6 +96,8 @@ static int hv_cpu_init(unsigned int cpu)
 		wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE, val);
 	}
 
+	hyperv_init_ghcb();
+
 	return 0;
 }
 
@@ -167,6 +190,31 @@ static int hv_cpu_die(unsigned int cpu)
 {
 	struct hv_reenlightenment_control re_ctrl;
 	unsigned int new_cpu;
+	unsigned long flags;
+	void **input_arg;
+	void *pg;
+	void **ghcb_va = NULL;
+
+	local_irq_save(flags);
+	input_arg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
+	pg = *input_arg;
+	*input_arg = NULL;
+
+	if (hv_root_partition) {
+		void **output_arg;
+
+		output_arg = (void **)this_cpu_ptr(hyperv_pcpu_output_arg);
+		*output_arg = NULL;
+	}
+
+	if (ms_hyperv.ghcb_base) {
+		ghcb_va = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+		if (*ghcb_va)
+			memunmap(*ghcb_va);
+		*ghcb_va = NULL;
+	}
+
+	local_irq_restore(flags);
 
 	hv_common_cpu_die(cpu);
 
@@ -340,9 +388,22 @@ void __init hyperv_init(void)
 			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
 			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
 			__builtin_return_address(0));
-	if (hv_hypercall_pg == NULL) {
-		wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
-		goto remove_cpuhp_state;
+	if (hv_hypercall_pg == NULL)
+		goto clean_guest_os_id;
+
+	if (hv_isolation_type_snp()) {
+		ms_hyperv.ghcb_base = alloc_percpu(void *);
+		if (!ms_hyperv.ghcb_base)
+			goto clean_guest_os_id;
+
+		if (hyperv_init_ghcb()) {
+			free_percpu(ms_hyperv.ghcb_base);
+			ms_hyperv.ghcb_base = NULL;
+			goto clean_guest_os_id;
+		}
+
+		/* Hyper-V requires to write guest os id via ghcb in SNP IVM. */
+		hv_ghcb_msr_write(HV_X64_MSR_GUEST_OS_ID, guest_id);
 	}
 
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
@@ -403,7 +464,8 @@ void __init hyperv_init(void)
 	hv_query_ext_cap(0);
 	return;
 
-remove_cpuhp_state:
+clean_guest_os_id:
+	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	cpuhp_remove_state(cpuhp);
 free_vp_assist_page:
 	kfree(hv_vp_assist_page);
@@ -431,6 +493,9 @@ void hyperv_cleanup(void)
 	 */
 	hv_hypercall_pg = NULL;
 
+	if (ms_hyperv.ghcb_base)
+		free_percpu(ms_hyperv.ghcb_base);
+
 	/* Reset the hypercall page */
 	hypercall_msr.as_uint64 = 0;
 	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index adccbc209169..6627cfd2bfba 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -11,6 +11,8 @@
 #include <asm/paravirt.h>
 #include <asm/mshyperv.h>
 
+DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
+
 typedef int (*hyperv_fill_flush_list_func)(
 		struct hv_guest_mapping_flush_list *flush,
 		void *data);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index c1ab6a6e72b5..4269f3174e58 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -36,6 +36,7 @@ struct ms_hyperv_info {
 	u32 max_lp_index;
 	u32 isolation_config_a;
 	u32 isolation_config_b;
+	void  __percpu **ghcb_base;
 };
 extern struct ms_hyperv_info ms_hyperv;
 
@@ -237,6 +238,7 @@ bool hv_is_hyperv_initialized(void);
 bool hv_is_hibernation_supported(void);
 enum hv_isolation_type hv_get_isolation_type(void);
 bool hv_is_isolation_supported(void);
+bool hv_isolation_type_snp(void);
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
 #else /* CONFIG_HYPERV */
-- 
2.25.1

