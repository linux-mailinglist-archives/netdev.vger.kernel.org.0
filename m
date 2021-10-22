Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ACB437819
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhJVNjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 09:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhJVNjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 09:39:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B4EC061764;
        Fri, 22 Oct 2021 06:37:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s1so2686774plg.12;
        Fri, 22 Oct 2021 06:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2LI3Rg87znh/YWrsMVZB/NerJ145Az7sRN0w3FJgzyM=;
        b=MCHWYj57YwgAgC8lilLi0zrB4LaTxSlbEcgWpW8oW0mfPH0lbjRuyuPvNkIRVwIKYR
         txqJlEGRQcF2U9Ygey6LPL9Uabkq46lDeUFJg+Ju/L80fnv0cZvNsu88/9zyPdQd4vPk
         X8IOb+1RQ4wxtozdFpvUoglXyAErcgfWlWjfH8KdDvfcXkRy1Y/NDKZdUxWVgvJ7NtrW
         taNi28UhSw7PvIINv3JT4oDIADwqgKtqbO3rNPVdFQ+RYS3G7fUEYROe4+BZMJNc8Yug
         98J/mmccuvPQifPHu+UV4RFvOLdFtLalVbE2t68YnzjID5lgg4EAywNMzkTx5s7UnSwl
         Gb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2LI3Rg87znh/YWrsMVZB/NerJ145Az7sRN0w3FJgzyM=;
        b=VObrrFppTi2bwWUVsqh3K98qwNI2a78C4e65x2aG9yuWdMQIPTvMZ4n6ql7pQ0/87c
         eowmahHCtFwGxlAaXsu1/avurjZlT7ihP6xgnGeOJLEkWJ0IMUo2nKCckSNB4b1RhDui
         GszY6Kk8qgf3OXH+LsRNvED5HqP7lk7brGWl1wS/xbaxTfGPbeVcAv8FHnABt/Ptr7Ad
         lHQNjeWfXdnNtjfYf/e9LxDGN3pruWpxu9kCyIt8ADGdRCk3dhEqBOq6P4OjPVtHo9Zk
         3mbjCmra2d1cRHm6i0j+LdrOqytZkig38mOOFDIkz6st4cAFnXOTkhQhRbRtYFpPVT3r
         GDBg==
X-Gm-Message-State: AOAM5306c08iM3CJZyyOdXCmrq9BVL9FqAZDzsZ93wb3WZmb74Jll9rj
        HKHaBwwMav8ElCET0foYIas=
X-Google-Smtp-Source: ABdhPJw1ItNar+XEvsDKWOvVe+N9TtSxyxK5i5K9+fMlERCubaD9YGAezWWxbHcN500vQHvT3i+TFg==
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr14570970pjp.8.1634909846068;
        Fri, 22 Oct 2021 06:37:26 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:1cbf:b595:fc2c:720f])
        by smtp.gmail.com with ESMTPSA id f18sm9549296pfa.60.2021.10.22.06.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 06:37:25 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, david@redhat.com,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, rientjes@google.com,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V8.1 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call ghcb hv call out of sev code
Date:   Fri, 22 Oct 2021 09:37:20 -0400
Message-Id: <20211022133721.2123-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211021154110.3734294-6-ltykernel@gmail.com>
References: <20211021154110.3734294-6-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V needs to call ghcb hv call to write/read MSR in Isolation VM.
So expose sev_es_ghcb_hv_call() to call it in the Hyper-V code.

Hyper-V Isolation VM is unenlightened guests and run a paravisor in the
VMPL0 for communicating and GHCB pages are being allocated and set up by
that paravisor. Linux gets ghcb page pa via MSR_AMD64_SEV_ES_GHCB
from paravisor and should not change it. Add set_ghcb_msr parameter for
sev_es_ghcb_hv_call() and not set ghcb page pa when it's false.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v8:
        Fix commit in the sev_es_ghcb_hv_call().

 arch/x86/include/asm/sev.h   | 12 ++++++++++++
 arch/x86/kernel/sev-shared.c | 25 ++++++++++++++++---------
 arch/x86/kernel/sev.c        | 13 +++++++------
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..5b7f7e2b81f7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,12 +81,24 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  bool set_ghcb_msr,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
+static inline enum
+es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+			      bool set_ghcb_msr, u64 exit_code,
+			      u64 exit_info_1, u64 exit_info_2)
+{
+	return ES_VMM_ERROR;
+}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index ea9abd69237e..e1863a6d76b8 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -124,10 +124,9 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
 	return ES_VMM_ERROR;
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2)
+enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
+				   struct es_em_ctxt *ctxt, u64 exit_code,
+				   u64 exit_info_1, u64 exit_info_2)
 {
 	/* Fill in protocol and format specifiers */
 	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
@@ -137,7 +136,14 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	sev_es_wr_ghcb_msr(__pa(ghcb));
+	/*
+	 * Hyper-V unenlightened guests use a paravisor for communicating and
+	 * GHCB pages are being allocated and set up by that paravisor. Linux
+	 * should not change the GHCB page's physical address.
+	 */
+	if (set_ghcb_msr)
+		sev_es_wr_ghcb_msr(__pa(ghcb));
+
 	VMGEXIT();
 
 	return verify_exception_info(ghcb, ctxt);
@@ -417,7 +423,7 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		 */
 		sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
 		ghcb_set_sw_scratch(ghcb, sw_scratch);
-		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
+		ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_IOIO,
 					  exit_info_1, exit_info_2);
 		if (ret != ES_OK)
 			return ret;
@@ -459,7 +465,8 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 
 		ghcb_set_rax(ghcb, rax);
 
-		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
+		ret = sev_es_ghcb_hv_call(ghcb, true, ctxt,
+					  SVM_EXIT_IOIO, exit_info_1, 0);
 		if (ret != ES_OK)
 			return ret;
 
@@ -490,7 +497,7 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		/* xgetbv will cause #GP - use reset value for xcr0 */
 		ghcb_set_xcr0(ghcb, 1);
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_CPUID, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -515,7 +522,7 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a6895e440bc3..bb62a1d15d6c 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -648,7 +648,8 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		ghcb_set_rdx(ghcb, regs->dx);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_MSR,
+				  exit_info_1, 0);
 
 	if ((ret == ES_OK) && (!exit_info_1)) {
 		regs->ax = ghcb->save.rax;
@@ -867,7 +868,7 @@ static enum es_result vc_do_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
 
 	ghcb_set_sw_scratch(ghcb, ghcb_pa + offsetof(struct ghcb, shared_buffer));
 
-	return sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1, exit_info_2);
+	return sev_es_ghcb_hv_call(ghcb, true, ctxt, exit_code, exit_info_1, exit_info_2);
 }
 
 static enum es_result vc_handle_mmio_twobyte_ops(struct ghcb *ghcb,
@@ -1117,7 +1118,7 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 
 	/* Using a value of 0 for ExitInfo1 means RAX holds the value */
 	ghcb_set_rax(ghcb, val);
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_WRITE_DR7, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -1147,7 +1148,7 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
 static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
 				       struct es_em_ctxt *ctxt)
 {
-	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
+	return sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_WBINVD, 0, 0);
 }
 
 static enum es_result vc_handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
@@ -1156,7 +1157,7 @@ static enum es_result vc_handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 
 	ghcb_set_rcx(ghcb, ctxt->regs->cx);
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_RDPMC, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_RDPMC, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
@@ -1197,7 +1198,7 @@ static enum es_result vc_handle_vmmcall(struct ghcb *ghcb,
 	if (x86_platform.hyper.sev_es_hcall_prepare)
 		x86_platform.hyper.sev_es_hcall_prepare(ghcb, ctxt->regs);
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_VMMCALL, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, true, ctxt, SVM_EXIT_VMMCALL, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
-- 
2.25.1

