Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5627395173
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 17:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhE3PIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhE3PIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 11:08:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84DAC061574;
        Sun, 30 May 2021 08:06:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h12so3924675plf.11;
        Sun, 30 May 2021 08:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TDI4PXumIZgxBePNd+ivE0VBcCC0VeGNDBRFqyds1eM=;
        b=UAse3Bpl0FAVPqqhfAnA0zSsTcxrZbreVrQAzodtanCUm4szgJIEyR5+ecqtW5IpAX
         wvxV8auZOSKfuO8TZ4M8rO/crEbVTyzAM6eyp3NoWTLuD78xXlOdpNL1GTvOv05hTOvw
         IJKNjFYyz12ZXEp+aAdaQoUfunooYgNvY+tYgiYWzR7jphXnzg+LZ0lYvuQrvoitNAPI
         3dFo+NHKOib8S6vhPQHgJFZuloR8beErGmtrAztyIobPte+3TQ3S9eDUgC3gZiqCjgrA
         2cjMlhmbzneoHRsMOP9QRH/YU9YL8UrYLz+ibUTPFCQMKMdfS1dZjF7iQIxOaa2us5Nb
         DDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TDI4PXumIZgxBePNd+ivE0VBcCC0VeGNDBRFqyds1eM=;
        b=XUbVj5i1uW1RwmpTlP9r3FeZ+gF1QLThiRXOpHhilrEvv8VvK40qcrouwN9bBYOkw3
         KA/FIhtRfZVbspgCrZMDy9+3zdCWzpVC+ztLVJMtb7P/QTob5kr+hl4m74q8BzUHeCnM
         UK8pH7/V5WdghhoxlVTqEld5Hx+X2IWimtptvWyfjuZc1su1cUZfFXt4Rp+YBu3NwYI5
         rncwTfADOAxqiY2tjaiE1BOqlsL+mBhyz+yAuFkQy6kc003kEGqyPbLYJiwYW5nLbN91
         nt3u1snPyyGXuJ9srXl9iShdYC+ccYhFK4G2mbG4Dkkp3UGfil/9cSzTHlqFw1f/7WZd
         CauA==
X-Gm-Message-State: AOAM5337eeyhVH91dk1XmlTwq0/1CcZUsnlknaIBkFGIFFyRhu5bP5oG
        lZy4jUv+Fsq982+efo5iU4Y=
X-Google-Smtp-Source: ABdhPJw6VTPU9WI3kHLEFrQaIMTpdWgtR9lc2XZhC9GhjxtOkcyL5lpx/QGe3K50jPAfDu6vcR2b5Q==
X-Received: by 2002:a17:90a:80c5:: with SMTP id k5mr6957940pjw.129.1622387200366;
        Sun, 30 May 2021 08:06:40 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:9:dc2d:80ab:c3f3:1524])
        by smtp.gmail.com with ESMTPSA id b15sm8679688pfi.100.2021.05.30.08.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 08:06:39 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: [RFC PATCH V3 02/11] x86/HV: Initialize shared memory boundary in the Isolation VM.
Date:   Sun, 30 May 2021 11:06:19 -0400
Message-Id: <20210530150628.2063957-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530150628.2063957-1-ltykernel@gmail.com>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V also exposes shared memory boundary via cpuid
HYPERV_CPUID_ISOLATION_CONFIG and store it in the
shared_gpa_boundary of ms_hyperv struct. This prepares
to share memory with host for SNP guest.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |  2 ++
 include/asm-generic/mshyperv.h | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 22f13343b5da..d1ca36224657 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -320,6 +320,8 @@ static void __init ms_hyperv_init_platform(void)
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

