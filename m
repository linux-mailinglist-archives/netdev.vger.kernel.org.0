Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECF241DA83
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349472AbhI3NHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349642AbhI3NHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72DDC06176A;
        Thu, 30 Sep 2021 06:05:50 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y8so4926982pfa.7;
        Thu, 30 Sep 2021 06:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kG33NGlR27DKb8jpoc/dkA/H+bZZ/MhEkG0T0crPWIM=;
        b=liq1p3EhfeajypECFHwVDCrT1SGFX6n3Lego5IBk5jY6vh+l5YgSqXABeQ2Rr0GPCV
         O7yQyCe86Z0LIjX8NLDPpcjZv1wTKib0bdmUaRnrSz2BeclZrOwnQH1a1fR951Piiv58
         R3fyjIKjbCx8KRaoFfJLBvdqiil2fD/MSLMcBriS4/1U1n+6RwjsBi0++/WKddAIZyAV
         J5IlG47fA23+w30YfdkAl/xxj1Zn3qX5iczjbjipsh1OxCis4xWlGmqnTFxqqlIRW3/C
         iVi9r2nGEm+Rc4BaIpZEtlnDgcRRXx0b226wBU4hH61FU3BhBb5TFFtXnxiIiD8GGbvg
         qFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kG33NGlR27DKb8jpoc/dkA/H+bZZ/MhEkG0T0crPWIM=;
        b=tWODnMXa1jUTkNeAjRbY2dpas8nDCw7xxhp7LNIsgDVpsw8q8RM+K0DeyjBcLKTGNv
         6ARRPpr7Fp7guHDGNJsbrSOM6z/1f+7bXp74LsjD3ghVHDbUYaf0qzQ4bY2j4+luO4P7
         oLtwCw4TpyrEy77P7J/pRtD+h5gdpLr8aSEOkn88/AizLKXuvzICbnzURgG8u3xKlee3
         O4JhYvOCyw+fxfMW9xgcAisjLqpSQFgFFzcb++bOwPNND1DJq1qSGReE1kDb3fMqSEaL
         DXY0ygwXdrk1AAp6ZVPMydXAAxnQiOULJDxvn25Jpi0McB28/z8mD0VLWOlq7wi33Qvu
         4mIg==
X-Gm-Message-State: AOAM532svg8AKzHsLoaOypbd8U9q5fUs1WOs1Tqt7KkLNFrlFxZmHbhb
        Xx4T8x5rlV9rBygZcnHezvo=
X-Google-Smtp-Source: ABdhPJz+cSguTWyAyIfOQQ2Xu/6h2T9KagOEA3X4NnhuNw9NyghLlYYsyrIRlk136QyJBTr2K63F2w==
X-Received: by 2002:a63:3d8f:: with SMTP id k137mr4895550pga.21.1633007150448;
        Thu, 30 Sep 2021 06:05:50 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:a72f:86cf:2cc5:8116])
        by smtp.gmail.com with ESMTPSA id v7sm3072134pff.195.2021.09.30.06.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:05:49 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 1/8] x86/hyperv: Initialize GHCB page in Isolation VM
Date:   Thu, 30 Sep 2021 09:05:37 -0400
Message-Id: <20210930130545.1210298-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930130545.1210298-1-ltykernel@gmail.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyperv exposes GHCB page via SEV ES GHCB MSR for SNP guest
to communicate with hypervisor. Map GHCB page for all
cpus to read/write MSR register and submit hvcall request
via ghcb page.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v4:
	* Fix typo comment

Chagne since v3:
        * Rename ghcb_base to hv_ghcb_pg and move it out of
	  struct ms_hyperv_info.
	* Allocate hv_ghcb_pg before cpuhp_setup_state() and leverage
	  hv_cpu_init() to initialize ghcb page.
---
 arch/x86/hyperv/hv_init.c       | 68 +++++++++++++++++++++++++++++----
 arch/x86/include/asm/mshyperv.h |  4 ++
 arch/x86/kernel/cpu/mshyperv.c  |  3 ++
 include/asm-generic/mshyperv.h  |  1 +
 4 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 708a2712a516..a7e922755ad1 100644
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
@@ -36,12 +37,42 @@ EXPORT_SYMBOL_GPL(hv_current_partition_id);
 void *hv_hypercall_pg;
 EXPORT_SYMBOL_GPL(hv_hypercall_pg);
 
+void __percpu **hv_ghcb_pg;
+
 /* Storage to save the hypercall page temporarily for hibernation */
 static void *hv_hypercall_pg_saved;
 
 struct hv_vp_assist_page **hv_vp_assist_page;
 EXPORT_SYMBOL_GPL(hv_vp_assist_page);
 
+static int hyperv_init_ghcb(void)
+{
+	u64 ghcb_gpa;
+	void *ghcb_va;
+	void **ghcb_base;
+
+	if (!hv_isolation_type_snp())
+		return 0;
+
+	if (!hv_ghcb_pg)
+		return -EINVAL;
+
+	/*
+	 * GHCB page is allocated by paravisor. The address
+	 * returned by MSR_AMD64_SEV_ES_GHCB is above shared
+	 * memory boundary and map it here.
+	 */
+	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
+	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+	if (!ghcb_va)
+		return -ENOMEM;
+
+	ghcb_base = (void **)this_cpu_ptr(hv_ghcb_pg);
+	*ghcb_base = ghcb_va;
+
+	return 0;
+}
+
 static int hv_cpu_init(unsigned int cpu)
 {
 	union hv_vp_assist_msr_contents msr = { 0 };
@@ -85,7 +116,7 @@ static int hv_cpu_init(unsigned int cpu)
 		}
 	}
 
-	return 0;
+	return hyperv_init_ghcb();
 }
 
 static void (*hv_reenlightenment_cb)(void);
@@ -177,6 +208,14 @@ static int hv_cpu_die(unsigned int cpu)
 {
 	struct hv_reenlightenment_control re_ctrl;
 	unsigned int new_cpu;
+	void **ghcb_va;
+
+	if (hv_ghcb_pg) {
+		ghcb_va = (void **)this_cpu_ptr(hv_ghcb_pg);
+		if (*ghcb_va)
+			memunmap(*ghcb_va);
+		*ghcb_va = NULL;
+	}
 
 	hv_common_cpu_die(cpu);
 
@@ -366,10 +405,16 @@ void __init hyperv_init(void)
 		goto common_free;
 	}
 
+	if (hv_isolation_type_snp()) {
+		hv_ghcb_pg = alloc_percpu(void *);
+		if (!hv_ghcb_pg)
+			goto free_vp_assist_page;
+	}
+
 	cpuhp = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/hyperv_init:online",
 				  hv_cpu_init, hv_cpu_die);
 	if (cpuhp < 0)
-		goto free_vp_assist_page;
+		goto free_ghcb_page;
 
 	/*
 	 * Setup the hypercall page and enable hypercalls.
@@ -383,10 +428,8 @@ void __init hyperv_init(void)
 			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
 			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
 			__builtin_return_address(0));
-	if (hv_hypercall_pg == NULL) {
-		wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
-		goto remove_cpuhp_state;
-	}
+	if (hv_hypercall_pg == NULL)
+		goto clean_guest_os_id;
 
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 	hypercall_msr.enable = 1;
@@ -456,8 +499,11 @@ void __init hyperv_init(void)
 	hv_query_ext_cap(0);
 	return;
 
-remove_cpuhp_state:
+clean_guest_os_id:
+	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	cpuhp_remove_state(cpuhp);
+free_ghcb_page:
+	free_percpu(hv_ghcb_pg);
 free_vp_assist_page:
 	kfree(hv_vp_assist_page);
 	hv_vp_assist_page = NULL;
@@ -559,3 +605,11 @@ bool hv_is_isolation_supported(void)
 {
 	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
 }
+
+DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
+
+bool hv_isolation_type_snp(void)
+{
+	return static_branch_unlikely(&isolation_type_snp);
+}
+EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index adccbc209169..37739a277ac6 100644
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
@@ -39,6 +41,8 @@ extern void *hv_hypercall_pg;
 
 extern u64 hv_current_partition_id;
 
+extern void __percpu **hv_ghcb_pg;
+
 int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages);
 int hv_call_add_logical_proc(int node, u32 lp_index, u32 acpi_id);
 int hv_call_create_vp(int node, u64 partition_id, u32 vp_index, u32 flags);
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index e095c28d27ae..b09ade389040 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -316,6 +316,9 @@ static void __init ms_hyperv_init_platform(void)
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
+
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
+			static_branch_enable(&isolation_type_snp);
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index d3eae6cdbacb..2a709010f53d 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -254,6 +254,7 @@ bool hv_is_hyperv_initialized(void);
 bool hv_is_hibernation_supported(void);
 enum hv_isolation_type hv_get_isolation_type(void);
 bool hv_is_isolation_supported(void);
+bool hv_isolation_type_snp(void);
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
 #else /* CONFIG_HYPERV */
-- 
2.25.1

