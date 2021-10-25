Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3521439629
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhJYMYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhJYMXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:23:49 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECD4C061229;
        Mon, 25 Oct 2021 05:21:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 187so10550099pfc.10;
        Mon, 25 Oct 2021 05:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+7pz2foD/4GwcDIE39vmWSuWuTwJleRXg4SRKQkhN+E=;
        b=AESlPeorHAIJn0wVvqn0Bv4CDXtMzlW0FjCvNlhqyF6ZeJf+jeKMOmkK+zhgQmYum7
         5S4GI+yN/Vh7C0riiXRyi9TtNa11cdhW1GRp7+7Xj0CY2j439Sfkrhp40j0QFxX5p3P9
         HQ1lCyM78JM0ZBe/PYgl/cK+1otfq5zUJ0vT12ouw5B8Fx8Z5HFuy5GBj/DpZlIzQQwi
         nbJiPo2UDd/Rwwqygf4r1IBggqUBj08RQhdkGYRxWEOVDdQNPUtViERVRClxmHS7KgQd
         pIgkDPzRFbG51vCat99NTMtSpzk/xQP6QUzGtRKIyEgdYZVwn7u39uGzkoKZxqsDPv/F
         7L8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+7pz2foD/4GwcDIE39vmWSuWuTwJleRXg4SRKQkhN+E=;
        b=cA7nWL02hf3seGyj2LOu+6GzI7V81cYPnEYXRU+e6UthpchJwkOcK8zz03QjA777e3
         TQBA5LS+XNsDr1ISHwzWtDudCYwxVWepLlQwn/kpXDRl5AjNHS5Mzarc6KLD+4suhqkZ
         ENZwQDyMJl9M66sxMZeMlefKi7VToW29BjR5mK4jEWlXpWn3mqjFgGFkuqXEjMjZ4MhB
         KUs/dqKIfdyCexVwXkkd3//zfylFosVOfawqHWyVzQhpv1lWbJnxmEsIHJUTgnRp/kao
         hBH1QYTpkNcxLqgPEoK9O1ZKJBJ3S/IiNhUG9yi9A7JhOjwdpk3+x2yIquxW0siQNr4Y
         byOQ==
X-Gm-Message-State: AOAM532jk1oESXBlMy1bo/o3Xk4SRDIy7PvsppHXB2LZSP0jtFqrjEbD
        U7Hx2tinF7xl/MOf78TjB8s=
X-Google-Smtp-Source: ABdhPJxiQwKVDxPVQectkbll0gJHvEm/RE73L9RH9DkEJqD9OrwlNI/ZgmMNTcozf3GE7ND4UQUXsA==
X-Received: by 2002:a62:5304:0:b0:44c:719c:a2c with SMTP id h4-20020a625304000000b0044c719c0a2cmr17538108pfb.13.1635164486657;
        Mon, 25 Oct 2021 05:21:26 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:bcf6:9813:137f:2b6])
        by smtp.gmail.com with ESMTPSA id mi11sm2786166pjb.5.2021.10.25.05.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 05:21:26 -0700 (PDT)
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
Subject: [PATCH V9 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call ghcb hv call out of sev code
Date:   Mon, 25 Oct 2021 08:21:10 -0400
Message-Id: <20211025122116.264793-6-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025122116.264793-1-ltykernel@gmail.com>
References: <20211025122116.264793-1-ltykernel@gmail.com>
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

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v8:
	- Remove sev_es_ghcb_hv_call() stub function.

 arch/x86/include/asm/sev.h   |  5 +++++
 arch/x86/kernel/sev-shared.c | 25 ++++++++++++++++---------
 arch/x86/kernel/sev.c        | 13 +++++++------
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..e3576916215d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,6 +81,11 @@ static __always_inline void sev_es_nmi_complete(void)
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

