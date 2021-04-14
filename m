Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFEE35F6BE
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352044AbhDNOvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhDNOus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81F7C06175F;
        Wed, 14 Apr 2021 07:50:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p16so6280186plf.12;
        Wed, 14 Apr 2021 07:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OsFA5UjGBBz+WpI+wHtQ7Mb2J7cYrRLymhsyTS1f9mI=;
        b=dvEn7FiJ1SLom9xWKqMrGFlIo/UlMk3c6iQjeTXBfWODS9IhMJsyMTZ4T1MWyHKk/4
         Ix8pR/zj8RdUuVlBI3ZAcfvK7Y1vkv8B0grJfNVMiycDAw1nN84wKIiCCHarKZnTpAAd
         yRsIqVkNTbfLqBTAPuU56Fk8Fjkp13hnLsMXR0yNyxBPTC3F5CL4ste7XhqNfOHBeRiH
         lRHYGYH7S/xtunirGgYHazOMlHl8Xt//vGYTB2KCLdGA8YGV4X4SWLPOTMNUNjHdh2L6
         FHWlGTxK7iHLx+Wwh2HdefoSlQe/4ZwhjFfZyz6JAP50pp7EB0eC+OEONvK82+QyrEBc
         F3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OsFA5UjGBBz+WpI+wHtQ7Mb2J7cYrRLymhsyTS1f9mI=;
        b=REEBFLfp8c5/yU7luB6xFF0wfRdNc1cOs3gtSpZyPhvvFazLPukCz1UFoBaJxPQKut
         CwumnnGbVvXiyVcJ+GQjTZEHyprenTnz2v2k/BSM2Pj9HsthRq2azDUfxP7Jr9s8EHH4
         QTBOIaiIm4GeHYKxlVKTibeV4q2qp8f3hDMi9Wbkhk65QVfEbXSwzueYsE9g6op3dOx6
         LtzntidU8g9DCvqSgEHfUcLYhNfMrUtdW73LKWgq3seD4QPThrctwQ4ih7sTQ9nxJgj+
         INfIKVuK8zn7vjaZCVIaPck57fa6ebamqmxjf1snTyKMeIKvPZ+RvxjdtMouXs1h09LO
         MMiA==
X-Gm-Message-State: AOAM5327cDwfNYp1OVm1J5uq5DxanN/2zJzyoPQwH3HedFweRxj/GMNA
        yUqWgT1mYr1bDsf5clIkACc=
X-Google-Smtp-Source: ABdhPJxOQSk6nZAoLefZfe857h19ZUVboJUlPFq4tkSU5Klpf/RhVEGVnYRpm3ZLMAu1mlXfBJ+M3Q==
X-Received: by 2002:a17:902:e784:b029:e9:997a:6a27 with SMTP id cp4-20020a170902e784b02900e9997a6a27mr33074259plb.9.1618411825427;
        Wed, 14 Apr 2021 07:50:25 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:25 -0700 (PDT)
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
Subject: [Resend RFC PATCH V2 01/12] x86/HV: Initialize GHCB page in Isolation VM
Date:   Wed, 14 Apr 2021 10:49:34 -0400
Message-Id: <20210414144945.3460554-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
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
 arch/x86/hyperv/hv_init.c      | 52 +++++++++++++++++++++++++++++++---
 include/asm-generic/mshyperv.h |  1 +
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 0db5137d5b81..90e65fbf4c58 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -82,6 +82,9 @@ static int hv_cpu_init(unsigned int cpu)
 	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
 	void **input_arg;
 	struct page *pg;
+	u64 ghcb_gpa;
+	void *ghcb_va;
+	void **ghcb_base;
 
 	/* hv_cpu_init() can be called with IRQs disabled from hv_resume() */
 	pg = alloc_pages(irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL, hv_root_partition ? 1 : 0);
@@ -128,6 +131,17 @@ static int hv_cpu_init(unsigned int cpu)
 		wrmsrl(HV_X64_MSR_VP_ASSIST_PAGE, val);
 	}
 
+	if (ms_hyperv.ghcb_base) {
+		rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
+
+		ghcb_va = ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
+		if (!ghcb_va)
+			return -ENOMEM;
+
+		ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+		*ghcb_base = ghcb_va;
+	}
+
 	return 0;
 }
 
@@ -223,6 +237,7 @@ static int hv_cpu_die(unsigned int cpu)
 	unsigned long flags;
 	void **input_arg;
 	void *pg;
+	void **ghcb_va = NULL;
 
 	local_irq_save(flags);
 	input_arg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
@@ -236,6 +251,13 @@ static int hv_cpu_die(unsigned int cpu)
 		*output_arg = NULL;
 	}
 
+	if (ms_hyperv.ghcb_base) {
+		ghcb_va = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+		if (*ghcb_va)
+			iounmap(*ghcb_va);
+		*ghcb_va = NULL;
+	}
+
 	local_irq_restore(flags);
 
 	free_pages((unsigned long)pg, hv_root_partition ? 1 : 0);
@@ -372,6 +394,9 @@ void __init hyperv_init(void)
 	u64 guest_id, required_msrs;
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 	int cpuhp, i;
+	u64 ghcb_gpa;
+	void *ghcb_va;
+	void **ghcb_base;
 
 	if (x86_hyper_type != X86_HYPER_MS_HYPERV)
 		return;
@@ -432,9 +457,24 @@ void __init hyperv_init(void)
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
+		rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
+		ghcb_va = ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
+		if (!ghcb_va) {
+			free_percpu(ms_hyperv.ghcb_base);
+			ms_hyperv.ghcb_base = NULL;
+			goto clean_guest_os_id;
+		}
+
+		ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+		*ghcb_base = ghcb_va;
 	}
 
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
@@ -499,7 +539,8 @@ void __init hyperv_init(void)
 
 	return;
 
-remove_cpuhp_state:
+clean_guest_os_id:
+	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	cpuhp_remove_state(cpuhp);
 free_vp_assist_page:
 	kfree(hv_vp_assist_page);
@@ -528,6 +569,9 @@ void hyperv_cleanup(void)
 	 */
 	hv_hypercall_pg = NULL;
 
+	if (ms_hyperv.ghcb_base)
+		free_percpu(ms_hyperv.ghcb_base);
+
 	/* Reset the hypercall page */
 	hypercall_msr.as_uint64 = 0;
 	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index dff58a3db5d5..c6f4c5c20fb8 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -35,6 +35,7 @@ struct ms_hyperv_info {
 	u32 max_lp_index;
 	u32 isolation_config_a;
 	u32 isolation_config_b;
+	void  __percpu **ghcb_base;
 };
 extern struct ms_hyperv_info ms_hyperv;
 
-- 
2.25.1

