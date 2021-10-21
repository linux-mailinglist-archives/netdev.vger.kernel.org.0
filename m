Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA5843667E
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhJUPni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhJUPnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:43:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5C4C061764;
        Thu, 21 Oct 2021 08:41:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ls18so782980pjb.3;
        Thu, 21 Oct 2021 08:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nPmGrLtDkKne+Kxzs4l26xSiBaVw17KkF8YRLryQASU=;
        b=q0CWaVVwxVCfhKqhL0Fke5u4tv1uTMbLmRyjBSoxY3qaLHEjg21Neq26AXBhDTP1aC
         TtkwSLRhk5FlkXt/w87x9i8xYG2EkvtnxcNerOywf/oQMKhcJq+B3gziXIWLgNg0S4L4
         oPpe98dQwA+UK5HaDWRfNcvdKZxjN4HPdwQj3AGhR6xeMolPgPJ0DbAad8HXboU26hOQ
         dVLQY5hCHcv3UvjpmYfC3raE/vmIQ/HWu/WKpTMYDr+IGTcktSZGwPUJWL6qS4bOGJaY
         VG4df3ZvFK4tYm3LGX4e8qc65TOulCcz8tOHviiqWGaZPKMm5CcxXzTk1buwaVzSXBrW
         wZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nPmGrLtDkKne+Kxzs4l26xSiBaVw17KkF8YRLryQASU=;
        b=iJk9MSFrEswLGY1/LJQtele4SzvK2sMiEI/nJLrrpME8Yg2UMTavcPhix9v5E0lrIh
         JMNE7Z0Z1bviYP3N4bWpzwhkKRkJy0+uZCHLikwH5SA2Vx5FVtkI0Gu6laCAQSIhPCYG
         qZfKWTXGG5tQoYqSR9VJlKBvu08kXR8SMBiHEK6AmTQudhKLvwlqQjTdihHh3HYnG3oU
         osEcVGMlaS3V5QRpt2Iw0Axwipejrt8L4+Eq4wIhQKQuXEEFhfMIN6eVY1b115oobEVS
         qQ/48Lotxg5nMwa+5YBXO1A82qipCYJmcXVbK4/TUDdh6vf2ZPhy8yzUoW0Vl3xGpZd0
         /Vmw==
X-Gm-Message-State: AOAM530dvVr8lIx86eTGG44AOWnjDXsl0p2jlAhv9HWdT71Qj/MaYa0l
        WO5h8gTuZ2YKXrE2pV69CMo=
X-Google-Smtp-Source: ABdhPJxzALconG8olzzr6RUMuicH54P4fwSsTen2zayqwhtAk3ZNZsgSy0nU11/befwFYubHmgs8FA==
X-Received: by 2002:a17:90a:e010:: with SMTP id u16mr7565326pjy.217.1634830878827;
        Thu, 21 Oct 2021 08:41:18 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:a76d:53a5:b89f:c2a0])
        by smtp.gmail.com with ESMTPSA id p9sm6384130pfn.7.2021.10.21.08.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:41:18 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        rientjes@google.com, pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        saravanand@fb.com, aneesh.kumar@linux.ibm.com, hannes@cmpxchg.org,
        tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V8 2/9] x86/hyperv: Initialize shared memory boundary in the Isolation VM.
Date:   Thu, 21 Oct 2021 11:41:02 -0400
Message-Id: <20211021154110.3734294-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211021154110.3734294-1-ltykernel@gmail.com>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V exposes shared memory boundary via cpuid
HYPERV_CPUID_ISOLATION_CONFIG and store it in the
shared_gpa_boundary of ms_hyperv struct. This prepares
to share memory with host for SNP guest.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v4:
	* Rename reserve field.

Change since v3:
	* user BIT_ULL to get shared_gpa_boundary
	* Rename field Reserved* to reserved
---
 arch/x86/kernel/cpu/mshyperv.c |  2 ++
 include/asm-generic/mshyperv.h | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index b09ade389040..4794b716ec79 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -313,6 +313,8 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.priv_high & HV_ISOLATION) {
 		ms_hyperv.isolation_config_a = cpuid_eax(HYPERV_CPUID_ISOLATION_CONFIG);
 		ms_hyperv.isolation_config_b = cpuid_ebx(HYPERV_CPUID_ISOLATION_CONFIG);
+		ms_hyperv.shared_gpa_boundary =
+			BIT_ULL(ms_hyperv.shared_gpa_boundary_bits);
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index 2d88aa855f7e..a8ac497167d2 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -35,7 +35,17 @@ struct ms_hyperv_info {
 	u32 max_vp_index;
 	u32 max_lp_index;
 	u32 isolation_config_a;
-	u32 isolation_config_b;
+	union {
+		u32 isolation_config_b;
+		struct {
+			u32 cvm_type : 4;
+			u32 reserved1 : 1;
+			u32 shared_gpa_boundary_active : 1;
+			u32 shared_gpa_boundary_bits : 6;
+			u32 reserved2 : 20;
+		};
+	};
+	u64 shared_gpa_boundary;
 };
 extern struct ms_hyperv_info ms_hyperv;
 
-- 
2.25.1

