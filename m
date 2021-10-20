Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBD434519
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhJTGZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 02:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhJTGZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 02:25:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE70C06161C;
        Tue, 19 Oct 2021 23:23:30 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id oa4so1741116pjb.2;
        Tue, 19 Oct 2021 23:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AS3THJKxv0JL37o2aLKkOBmpQLeWF9n67xbjGYeiXl8=;
        b=pFVISFxCrmv9oA/r8AkteD5HRSPspcaow+A7VF+W/84o2P2yQ2dIQ8aPyA/X8CEOE2
         k+hwl+1pqEIpuK2w7oS4OsGtL9mDXBvBKTx7r0JIkOnWQnOnGjyWkn29YQVOGRh28XTU
         5+3zngVjfx8xmeMJaA21XbQ0bAUQFd0cl8RoYb23hOjxpXTNa2Wf1iyY5OdR0qidsoNB
         KuyYVyTDi2TnRKcsu26JZMKG18IyRnwTOVm40DIMey8NerrLM47XnKmM4sZ4Zv9Sp8yj
         NL6m5MA+gWOYPWd51U0K6tfM6gyVcne23J3UzQnvxsa3P5vBzacrrJm8p7Ags50ZNTCu
         Wj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AS3THJKxv0JL37o2aLKkOBmpQLeWF9n67xbjGYeiXl8=;
        b=mozOvPS4zfpnNZwydWl3JnJLQGGeQMsMAEyytvaRR5kHXr40LGmSksaqWUrcPmMb9M
         +H6Zitrg+Lc2HcLOk/wr2WGA6NhcUA90gZ/EKyR3aMMqFRcwU/l9x5h4nTzsgD1W2egU
         EKHBYyuD2bmIWWyYzaXrhIJpD4w7LsJjlkwhwsevM1vhBqe1CEiAYSZyW3Ptx6A18hP3
         dni08XiRhA/I+b0O6/WOlgTWcNY6AJoW/7PpfP/fmxMRHGNG09055UQ0AWE8/ITcAAMg
         hSxnVPaVtmXRAoKIibjUYtrU852zK1zrwnD7bpBetzUQaET3Hn+dI2os7WcG8hpxJQzQ
         KtfA==
X-Gm-Message-State: AOAM532/ryr0WoTImeOcoHNlUwxKQpWvC6biRBCEzPqpw354UCs3Og7B
        LIxoZ7wMnLlBMQcnbI3cYiA=
X-Google-Smtp-Source: ABdhPJxrpjBZRgLXHF0IC6ZBiZedOwvYyZvMQeeICCM2fEbazI782zWH2QfhI1nAK6SF4oDgwy4P9Q==
X-Received: by 2002:a17:90b:3b85:: with SMTP id pc5mr5215312pjb.74.1634711009746;
        Tue, 19 Oct 2021 23:23:29 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:f8a6:5db8:3270:8932])
        by smtp.gmail.com with ESMTPSA id c4sm1284498pfv.144.2021.10.19.23.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 23:23:29 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     bp@alien8.de
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb hv call out of sev code
Date:   Wed, 20 Oct 2021 02:23:16 -0400
Message-Id: <20211020062321.3581158-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
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
 arch/x86/include/asm/sev.h   | 11 +++++++++++
 arch/x86/kernel/sev-shared.c | 24 +++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..295c847c3cd4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,12 +81,23 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					    struct es_em_ctxt *ctxt,
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
index ea9abd69237e..08c97cb057fa 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -124,10 +124,14 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
 	return ES_VMM_ERROR;
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
+				     struct es_em_ctxt *ctxt,
+				     u64 exit_code, u64 exit_info_1,
+				     u64 exit_info_2)
 {
 	/* Fill in protocol and format specifiers */
 	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
@@ -137,12 +141,22 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
 	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
 
-	sev_es_wr_ghcb_msr(__pa(ghcb));
 	VMGEXIT();
 
 	return verify_exception_info(ghcb, ctxt);
 }
 
+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+					  struct es_em_ctxt *ctxt,
+					  u64 exit_code, u64 exit_info_1,
+					  u64 exit_info_2)
+{
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+
+	return __sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1,
+				     exit_info_2);
+}
+
 /*
  * Boot VC Handler - This is the first VC handler during boot, there is no GHCB
  * page yet, so it only supports the MSR based communication with the
-- 
2.25.1

