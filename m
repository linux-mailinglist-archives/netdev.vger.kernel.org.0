Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0940A3BEACB
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhGGPhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhGGPht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:37:49 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A30C061574;
        Wed,  7 Jul 2021 08:35:07 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d12so2527790pfj.2;
        Wed, 07 Jul 2021 08:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0MmjMjO7XvUbpBRdqqPG7tGmikUa5z2pWikCp/JzIEY=;
        b=NVwj9Iuc5KEhy+VNjKuoKXzwovkub/uFAwYhE0AnnHBmasJim5Egk/ApBPBkeHElpd
         Ip4OV9iRzcuH1M98BYimUE0ATtc9OZzjxhp9kVenh+1g2GC7j0FGlwVlX76/eAv9AUy5
         9BQLpOGq8N2Gl/12RRnCeEgUIV0/g/2A0sPA+EBgMkN3+JMDARX4y7TLbUDo0GsG2/oC
         JKM5rBkRlzM/vVRtQvdfIYDxvguje020NHwrbcvP3/tBkvF9IwOH4Gv8qwl1sFaYA/rf
         CE1zyF098euLk/pqCyShxE6yRwQHIyt8iAJXiqdBMrt+jGjPdOKIVaPjsI5TtBYHsTF2
         b/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MmjMjO7XvUbpBRdqqPG7tGmikUa5z2pWikCp/JzIEY=;
        b=cWlwWndnARijmeg8jbuwrXWjFFePfkdSnLoNFy5BxQgG5NgwPcGGLBK8tFB3TUy+t2
         xo4zG2qpz1s4npHZ91yG/JGTi9F+rHcbzV+tMnH2gvL0doFfw3h4UJTBg5ZAZVNJ5FMS
         x7p2YP6oOWM7FofwrW71oKi2vYp9oMH17WtHTPm6FOHrL8MkZPNY2it6VD6aJGJumYal
         brrR1UD2R7wcKLkWVtFGjydhPrYmiC6c8McXbMIWAfQrN7mp0mtqRdM91NWynjCeOT46
         1Wp77R+KpxBZ+8QJAKI7n4d4o6K4KmP5PjjNT+5A9JzB2ZklT/aE7Tm/V4iRK29hZAPJ
         Sw/Q==
X-Gm-Message-State: AOAM530Hi6eNMh2oJ9YFujANSJzaCg86q2RnOgrPb/pFM8G2TK6rK8S0
        IyG0YzQ3yr/Ms4Jr5hftA5o=
X-Google-Smtp-Source: ABdhPJyEyO7Cyr41C6lgwYWdThy32+NVXiborZ3KnwFy57UZ1FE8H+OlybQRDClF4kF5jUwodhf1Og==
X-Received: by 2002:aa7:8e18:0:b029:2ec:a754:570e with SMTP id c24-20020aa78e180000b02902eca754570emr26014073pfr.38.1625672106748;
        Wed, 07 Jul 2021 08:35:06 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:6b7f:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id y11sm21096877pfo.160.2021.07.07.08.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:35:06 -0700 (PDT)
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
        rppt@kernel.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, ardb@kernel.org,
        nramas@linux.microsoft.com, robh@kernel.org, keescook@chromium.org,
        rientjes@google.com, pgonda@google.com, martin.b.radev@gmail.com,
        hannes@cmpxchg.org, saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [RFC PATCH V4 01/12] x86/HV: Initialize shared memory boundary in the Isolation VM.
Date:   Wed,  7 Jul 2021 11:34:42 -0400
Message-Id: <20210707153456.3976348-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707153456.3976348-1-ltykernel@gmail.com>
References: <20210707153456.3976348-1-ltykernel@gmail.com>
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

