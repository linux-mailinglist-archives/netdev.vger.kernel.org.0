Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1FA439619
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhJYMYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbhJYMXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:23:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0876C061227;
        Mon, 25 Oct 2021 05:21:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id om14so8129483pjb.5;
        Mon, 25 Oct 2021 05:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6fqCJ0TGhcCVUYrERKD/Wb/8KgAvSWuOBvIt3/+Maws=;
        b=T/nCu4c0rq48qmNumw+ERJFf6058pmskkgoH31HfR1NMPfk8diK0pO69d+I0/82NBs
         6Lm0b31NOwuQL52dmVBzPlybs7jhaBug+qdFd9gOO69i8CmlHPFXnn2TtBwmZeVb9/XV
         BQ6U3/b/zQsffaVVIhPeK5frKp5GmSi+4HW7g/2bSmRPu/kfSuNXNaOQUAKaq7lbsZ1r
         Y1Pc2oly1DDvsNr0I0fdv0mdipfgb+sLFSInYNQpb7FstzFXiez11sVjYwxr7kze6EwD
         hiCm7hGoEo9rwnvRd3C2s8GGd4PFPSwVk35q5TR8GLKl605wRwQp/mg3EpLgnr3bgB91
         EyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6fqCJ0TGhcCVUYrERKD/Wb/8KgAvSWuOBvIt3/+Maws=;
        b=r7OiYjd42GUvonz6SN8BNl/0Ss/pnhfBNnkI7og6py2N9ag2YyEJlvIk1retYGzBKf
         RyQCdOzDyKm7qCNBl8Rs0Lwh4QpZS/CP9Qs1bPBsJTERQBAm9+1C51DSOsUe8JS3FFRe
         9ZsyPQGxmWkCC+JlbjKQn9Q1Sf06Rt5amRskrabx0aRfpSTJaq6qKhJdFG7ipAe04LjB
         dtdX+Xlx40U4Z/LEZeaESIW18A28ZVKCiTHGMtKGQN2ycG8fICQoJ/OETN0jRQ6CNkCP
         NX7FWxkylOWHgumxhNSQfrYkX6GUDM4F/nKRzlIk0QYprN0axViGM9XH0iF/DuaGTu+U
         CMvA==
X-Gm-Message-State: AOAM532w8xNNTQvDkQbyfXYozrLKDOHUMOg8ox6ArjmIrHW6loQESKme
        ifBglzlP6123FgY4UnlZzBA=
X-Google-Smtp-Source: ABdhPJwL6guu5wJCRVMiIQw+lBYm1dcHyHHB3hqVqoziV6uzmJy3Gqjuu4iZFBoQFlj3ueJ0d7gRwA==
X-Received: by 2002:a17:90b:4b48:: with SMTP id mi8mr1238858pjb.94.1635164481236;
        Mon, 25 Oct 2021 05:21:21 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:bcf6:9813:137f:2b6])
        by smtp.gmail.com with ESMTPSA id mi11sm2786166pjb.5.2021.10.25.05.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 05:21:20 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        mikelley@microsoft.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, sfr@canb.auug.org.au, david@redhat.com,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V9 1/9] x86/hyperv: Initialize GHCB page in Isolation VM
Date:   Mon, 25 Oct 2021 08:21:06 -0400
Message-Id: <20211025122116.264793-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025122116.264793-1-ltykernel@gmail.com>
References: <20211025122116.264793-1-ltykernel@gmail.com>
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

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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
 include/asm-generic/mshyperv.h  |  6 +++
 4 files changed, 74 insertions(+), 7 deletions(-)

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
index d3eae6cdbacb..2d88aa855f7e 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -254,12 +254,18 @@ bool hv_is_hyperv_initialized(void);
 bool hv_is_hibernation_supported(void);
 enum hv_isolation_type hv_get_isolation_type(void);
 bool hv_is_isolation_supported(void);
+bool hv_isolation_type_snp(void);
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
 #else /* CONFIG_HYPERV */
 static inline bool hv_is_hyperv_initialized(void) { return false; }
 static inline bool hv_is_hibernation_supported(void) { return false; }
 static inline void hyperv_cleanup(void) {}
+static inline bool hv_is_isolation_supported(void) { return false; }
+static inline enum hv_isolation_type hv_get_isolation_type(void)
+{
+	return HV_ISOLATION_TYPE_NONE;
+}
 #endif /* CONFIG_HYPERV */
 
 #endif
-- 
2.25.1

