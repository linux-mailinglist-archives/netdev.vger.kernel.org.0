Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA113BEB48
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhGGPtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbhGGPtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:49:24 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE20C061574;
        Wed,  7 Jul 2021 08:46:44 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y4so183099pgl.10;
        Wed, 07 Jul 2021 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0MmjMjO7XvUbpBRdqqPG7tGmikUa5z2pWikCp/JzIEY=;
        b=UW7L39XXXA0lFLWgWURoFcPlCEh4S4Z8KGVwXPdNWOZ1uC97xNL/QzrnRe932i5Zpl
         v+us9x+QqUCVOJR7NW0cti8Dlvz3ntW5JBnk3T8mrXTQQXScCfMHjoOC5qWs78n+WXHy
         l0/TBbeXhFNdgxncs8vmuBc0rOiOjaE2C0pPG29QKAwWxzv4x0ZxqdciLaEAszX0ad2L
         rytLK20HtdLSd1w9TyUEPQIWBcbAQAlFIoL9atuDdZLes8JZJ04ezb04sQO7vSDnJg/s
         lgt8L6SFaYrDfbO40RdC74i07ap4lhvqEU/pQl2wDRJfhNq+GPC5XQGz2XIiVhjZjRsT
         5j1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MmjMjO7XvUbpBRdqqPG7tGmikUa5z2pWikCp/JzIEY=;
        b=HNTWjxXBityWTHSjLjYbqk4oxtKG6VLY4fLw1zWxhNYc463u+xUaekzXPd2qzaNSWM
         CUSL+dV62VwIyinomwZ/kmzvPtjrsQmXhcB+TOKObaND7ulEcFZOoM9wUxfgEgaJRtUU
         cxH+jcqPQIay9rMcr2nn7EXxgGqAnU2WiPu3cL88ZND6lcPfmqI1yVfhS18KwPFVRpXj
         cYmp0K8xH/Q9du3lYYiV3w/BSEhvs1N7UIFDzGJLSz9USpf9rdpAzeE1clAIOClMBFAc
         yyk0iFEldosUMUBoigEhIxo/seZv2UMEFvDd0AsMRaTvbyuwkYmmsC9wBR4/G+2Zh1TE
         d95Q==
X-Gm-Message-State: AOAM533ou6EfeR4gydZbPEPBRwmr59WF+F7V9UomQXWa2EUWwko16Nq5
        cy3kW8ylMPs2cU/nLVyCngQ=
X-Google-Smtp-Source: ABdhPJyAY8zlw6ShjL9q8KFDuhfqbUuaIuxnQh2fAt/BqNVogHlUsHJh8B4rAjBi+hH2uyVONxd4RA==
X-Received: by 2002:a05:6a00:8c4:b029:2b4:8334:ed4d with SMTP id s4-20020a056a0008c4b02902b48334ed4dmr25950524pfu.36.1625672804218;
        Wed, 07 Jul 2021 08:46:44 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:6b47:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id q18sm23093560pgj.8.2021.07.07.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:46:43 -0700 (PDT)
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
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        rppt@kernel.org, Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        ardb@kernel.org, robh@kernel.org, nramas@linux.microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com, david@redhat.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, keescook@chromium.org,
        rientjes@google.com, hannes@cmpxchg.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [Resend RFC PATCH V4 02/13] x86/HV: Initialize shared memory boundary in the Isolation VM.
Date:   Wed,  7 Jul 2021 11:46:16 -0400
Message-Id: <20210707154629.3977369-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707154629.3977369-1-ltykernel@gmail.com>
References: <20210707154629.3977369-1-ltykernel@gmail.com>
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
 arch/x86/kernel/cpu/mshyperv.c |  2 ++
 include/asm-generic/mshyperv.h | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 10b2a8c10cb6..8aed689db621 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -334,6 +334,8 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.priv_high & HV_ISOLATION) {
 		ms_hyperv.isolation_config_a = cpuid_eax(HYPERV_CPUID_ISOLATION_CONFIG);
 		ms_hyperv.isolation_config_b = cpuid_ebx(HYPERV_CPUID_ISOLATION_CONFIG);
+		ms_hyperv.shared_gpa_boundary =
+			(u64)1 << ms_hyperv.shared_gpa_boundary_bits;
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index 3ae56a29594f..2914e27b0429 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -34,8 +34,18 @@ struct ms_hyperv_info {
 	u32 max_vp_index;
 	u32 max_lp_index;
 	u32 isolation_config_a;
-	u32 isolation_config_b;
+	union {
+		u32 isolation_config_b;
+		struct {
+			u32 cvm_type : 4;
+			u32 Reserved11 : 1;
+			u32 shared_gpa_boundary_active : 1;
+			u32 shared_gpa_boundary_bits : 6;
+			u32 Reserved12 : 20;
+		};
+	};
 	void  __percpu **ghcb_base;
+	u64 shared_gpa_boundary;
 };
 extern struct ms_hyperv_info ms_hyperv;
 
-- 
2.25.1

