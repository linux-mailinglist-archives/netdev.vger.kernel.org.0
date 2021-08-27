Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4233F9DC0
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbhH0RW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238836AbhH0RWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:22:16 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09420C061796;
        Fri, 27 Aug 2021 10:21:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m4so4386000pll.0;
        Fri, 27 Aug 2021 10:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QeAoBJVxLuEqjhstpPPHRrsV4aYneiblS47oqHVJx+4=;
        b=I7NUV++ybJ+PeLzq7nvmvC/fUa1MzSPBVMWympCWggjJfdGIagT64paurWTr4ufYmh
         iyifKSagK7g0dfWSGenf+VOn1hz4bUmTah6emDjZ7Foz5yleN2+WsDzCIuDF9ckq2p8q
         hFjrwh845yHhH4sTpGEnOYuYp+n6e3PBkeMtpDD2gYyYmLb/pNE98ycigf1ahWeak5Ds
         119NB5Pug3TLpnQ/Feznsq48O//rxAT/a4sTQ52sT7LMmBNKIHmPmUv4Wo2l0yZEYlky
         QLNWAslMK29qAA7pi1dHujT6sJotapiAiz0QzHw0Xdhri/P7a9oV3kQamXq3XVGl03mc
         qYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QeAoBJVxLuEqjhstpPPHRrsV4aYneiblS47oqHVJx+4=;
        b=PXsPbSnwIih+0U8WeZlScXaC/Dn5qw0Al6N3PcUHZp1PqGmKO6IHm6/1HDNGVAPOrZ
         lebtgePjs6YIJl1jVtkWY48E3sd9JvD2vYjOduqKtP1yrN3VsEax5OcXLl7Y7Je/kYng
         fPggb7WtiRUyhBLLRlJ5Xem/5Px/EbP47xL6cAjFvQ4U6ogNEd/fupS1PpvltHLAP2dU
         FESU+TmOqiyHnMW+Vp/RNhvkjTknlxavOV70bL4IpZL5jLy3d2HfhyNUfbYwZCF2flqY
         6q6Duza+94RYYCUZT7lvtF5lEb9XBdsG5WNLTc+hoRI3Bco/dVsOZJCkgk3CC5MVfhn1
         BCBQ==
X-Gm-Message-State: AOAM5315IeON+AU9VEyhObjKdOQtO+03tQj6439b/hx9vO14lc3x45qN
        960EuMq3X2ehcYVHnh0Bt7M=
X-Google-Smtp-Source: ABdhPJygO/uJNLRxEGKep6uevI66uTYM1Cjltj7n7K2J5FM1lDlOoUIpLG2da+nKpVHYkSugQbym8Q==
X-Received: by 2002:a17:902:70cb:b0:132:6a68:af90 with SMTP id l11-20020a17090270cb00b001326a68af90mr9716504plt.56.1630084886558;
        Fri, 27 Aug 2021 10:21:26 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:ef50:8fcd:44d1:eb17])
        by smtp.gmail.com with ESMTPSA id f5sm7155015pjo.23.2021.08.27.10.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:21:26 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 02/13] x86/hyperv: Initialize shared memory boundary in the Isolation VM.
Date:   Fri, 27 Aug 2021 13:21:00 -0400
Message-Id: <20210827172114.414281-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827172114.414281-1-ltykernel@gmail.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
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
Change since v3:
	* user BIT_ULL to get shared_gpa_boundary
	* Rename field Reserved* to reserved
---
 arch/x86/kernel/cpu/mshyperv.c |  2 ++
 include/asm-generic/mshyperv.h | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 20557a9d6e25..8bb001198316 100644
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
index 0924bbd8458e..7537ae1db828 100644
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
+			u32 reserved11 : 1;
+			u32 shared_gpa_boundary_active : 1;
+			u32 shared_gpa_boundary_bits : 6;
+			u32 reserved12 : 20;
+		};
+	};
+	u64 shared_gpa_boundary;
 };
 extern struct ms_hyperv_info ms_hyperv;
 
-- 
2.25.1

