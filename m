Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D053E4B5D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhHIR47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbhHIR4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:56:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595E8C06179C;
        Mon,  9 Aug 2021 10:56:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j3so17318325plx.4;
        Mon, 09 Aug 2021 10:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WJ8Qj60FdMGjOsTL0G9bdAidXdjqOzX7Q2WO2gNuvy8=;
        b=kCOSzGmSmj2pkcs1y/QfkWI/Rb7FWu5Rt4HurHSycKb+4UJ6Aawe7iIjpLCK57NZvg
         WiKFB2lpA+UNPjQlXnkCjTyoLNfzfD6exWmoaSXwOTH3P5K09H7X97U+U6AERK1MWKDZ
         Uf9gBLdRp3afuP7JcZ7KvCly3MyakdtS0qQtW8YXpaZpP2oaIZuXn8AWr8r0q7m5PL19
         tGreCVJAddF2G7xYeJM4tw24jIsggOxYdQF69HhvqJzxkbw7sa2z7MLBTUyIBYEQNqtI
         yiQt/exmEXhRuDLkVp63WhMYXTqisSEe9mzIC1qRRU8DWNDpsvO5gCpWRZsGVSmFCKkw
         sUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJ8Qj60FdMGjOsTL0G9bdAidXdjqOzX7Q2WO2gNuvy8=;
        b=qzp9xn46NHhTrMe+dvIRhF0qGVtOBLrA6uFaeJTU1zYKav7RRsAlSiKYm7oIm3Ov8I
         RhW0XauiwZJgFH7ZGeBFkMY87IhT04Ok4avindz17tPqs4jpmFvHJIY9FCpf+LReykBU
         xjobERBU1zEMdBYTboYSFrNEdjp9HB3+3P913zVu6yv0n2p+qmuHONRQfsFnRNFSrb0m
         OFei3k8ya3fDie450Xq76hH42DLdf7iAzq5HlrSwnpsloWFA/PZ9Nk76j1NZDIpc7TmO
         NwnpXlqfRBvIZEZRQLHhWtZ7BsHtR+iaLYlanNEg8GAKKYSE5YFCc13i8DRNqeM7n6NH
         2+4Q==
X-Gm-Message-State: AOAM5324zkOMPffvGYDmduiJZ0wQs9dpwIp+S/4rmh5oT+GgnOAri2rM
        k/l4O/R6N27ZnUpIO+X8haw=
X-Google-Smtp-Source: ABdhPJxmwF3scgEEjXrYinjzLnwHVvcE27E2cso3ne1oTy5d8B/iiqwH78j0wxYg/3jFPvSCO0RgTg==
X-Received: by 2002:a62:1c42:0:b029:3c3:59ee:6068 with SMTP id c63-20020a621c420000b02903c359ee6068mr19584222pfc.72.1628531788936;
        Mon, 09 Aug 2021 10:56:28 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:2:106e:6ed1:5da1:2ac4])
        by smtp.gmail.com with ESMTPSA id x14sm20589708pfa.127.2021.08.09.10.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 10:56:28 -0700 (PDT)
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
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V3 02/13] x86/HV: Initialize shared memory boundary in the Isolation VM.
Date:   Mon,  9 Aug 2021 13:56:06 -0400
Message-Id: <20210809175620.720923-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809175620.720923-1-ltykernel@gmail.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
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
index 6b5835a087a3..2b7f396ef1a5 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -313,6 +313,8 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.priv_high & HV_ISOLATION) {
 		ms_hyperv.isolation_config_a = cpuid_eax(HYPERV_CPUID_ISOLATION_CONFIG);
 		ms_hyperv.isolation_config_b = cpuid_ebx(HYPERV_CPUID_ISOLATION_CONFIG);
+		ms_hyperv.shared_gpa_boundary =
+			(u64)1 << ms_hyperv.shared_gpa_boundary_bits;
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index 4269f3174e58..aa26d24a5ca9 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -35,8 +35,18 @@ struct ms_hyperv_info {
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

