Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9C423834
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbhJFGjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbhJFGiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:38:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748BC061749;
        Tue,  5 Oct 2021 23:37:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m14so1473704pfc.9;
        Tue, 05 Oct 2021 23:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E5RtjNys6VGTf0MZaL1sYef8/Qw6a8TMNGwYWZN0cn0=;
        b=IWREb6qQRbkMxb2v7yomXQPwttG3MnvijOnZnxyP6MR/PBEZAE9LjgHJqnqo9ayUeP
         mGF1G/5SmV9BkoiIPaGWB2f6KsXPqN5YDJIkWjrWn+NBCZuXao0cAwB0zaI+HRugo+Z9
         isKyxqMStblipFEYWBKL575FVA3tdvtxDmmIH6WET3pWgaEhOrh5GgqW0KbMxSgHbCHB
         VbGQMPfgrdNLcoqMfZS7cY6vMOVltI6pe7emLBNi8mznEcE503O4qTS6n3eD8aEL+IV0
         fpPKcUYWJO4d9K5Mcqh5wakkhn1ag3fMrXQ8fsyxdhGnmplZx8CZEfhAzlAXrJqfpMnS
         KHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5RtjNys6VGTf0MZaL1sYef8/Qw6a8TMNGwYWZN0cn0=;
        b=UdbLIyi2+0BTGE+ioC60bz2IRKGSnggqFoTRPDoHH7KE2ZwfZU18TnIvyauTwI75GU
         Uj1eUcKR8Vp4X/BwbHsJjePfh5v8T+Rb5L+RoOFFvFgftKibMprc9j23tWS9Uo2hRYT7
         8nSBoYJ1BZVQ23J1xPCOdyvxIUWabh4aEgZ4fj542TbPk9b8nhFNB4K+rFSp3S9f/0Qe
         t4jvo8oLujEKmEMinpjBmwXZPHg/KL1xo9hAKX9TyTv+bWiM1i31R4JFaD/Mv09x0wkO
         LMb1by+AVHS4vVwcCAKC4d3IxyrQ25HqEp4lUeU9K2EMgO2voZyJaeLZfMMLliWeUQQV
         Lmug==
X-Gm-Message-State: AOAM532fk9Tfua83ooxdfkc+926ee9m1sJaEuP9uA5TKHac461oDn6GB
        xF1P/fsy1iUqUmMIC0srG/ApSNGcRRgClBsr
X-Google-Smtp-Source: ABdhPJwmVdChskFJqfnY3yj1KK+02XvTjVMJRz1HmU6oj1vrTsGmT/wSC5ctUQwvw3mP7mkxGDisKw==
X-Received: by 2002:a62:29c7:0:b0:424:e840:47ef with SMTP id p190-20020a6229c7000000b00424e84047efmr35019459pfp.72.1633502222294;
        Tue, 05 Oct 2021 23:37:02 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:37:357b:c418:cfef:30b1])
        by smtp.gmail.com with ESMTPSA id l185sm19886413pfd.29.2021.10.05.23.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 23:37:02 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, jroedel@suse.de, brijesh.singh@amd.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V7 5/9] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb hv call out of sev code
Date:   Wed,  6 Oct 2021 02:36:45 -0400
Message-Id: <20211006063651.1124737-6-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211006063651.1124737-1-ltykernel@gmail.com>
References: <20211006063651.1124737-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V also needs to call ghcb hv call to write/read MSR in Isolation VM.
So expose __sev_es_ghcb_hv_call() to call it in the Hyper-V code.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/sev.h   | 10 +++++++++
 arch/x86/kernel/sev-shared.c | 43 +++++++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..2e96869f3e9b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,12 +81,22 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					    u64 exit_code, u64 exit_info_1,
+					    u64 exit_info_2);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
+static inline enum es_result
+__sev_es_ghcb_hv_call(struct ghcb *ghcb,
+		      u64 exit_code, u64 exit_info_1,
+		      u64 exit_info_2)
+{
+	return ES_VMM_ERROR;
+}
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 9f90f460a28c..946c203be08c 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -94,10 +94,13 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
 	ctxt->regs->ip += ctxt->insn.length;
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2)
+/*
+ * __sev_es_ghcb_hv_call() is also used in the other platform code(e.g
+ * Hyper-V).
+ */
+enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
+				     u64 exit_code, u64 exit_info_1,
+				     u64 exit_info_2)
 {
 	enum es_result ret;
 
@@ -109,15 +112,33 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	sev_es_wr_ghcb_msr(__pa(ghcb));
 	VMGEXIT();
 
+	if (ghcb->save.sw_exit_info_1 & 0xffffffff)
+		ret = ES_VMM_ERROR;
+	else
+		ret = ES_OK;
+
+	return ret;
+}
+
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	enum es_result ret;
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+
+	ret = __sev_es_ghcb_hv_call(ghcb, exit_code, exit_info_1,
+					 exit_info_2);
+	if (ret == ES_OK)
+		return ret;
+
 	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
 		u64 info = ghcb->save.sw_exit_info_2;
-		unsigned long v;
-
-		info = ghcb->save.sw_exit_info_2;
-		v = info & SVM_EVTINJ_VEC_MASK;
+		unsigned long v = info & SVM_EVTINJ_VEC_MASK;
 
 		/* Check if exception information from hypervisor is sane. */
 		if ((info & SVM_EVTINJ_VALID) &&
@@ -127,11 +148,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 			if (info & SVM_EVTINJ_VALID_ERR)
 				ctxt->fi.error_code = info >> 32;
 			ret = ES_EXCEPTION;
-		} else {
-			ret = ES_VMM_ERROR;
 		}
-	} else {
-		ret = ES_OK;
 	}
 
 	return ret;
-- 
2.25.1

