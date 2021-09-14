Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541C040AF28
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhINNky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhINNks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:40:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C952C061764;
        Tue, 14 Sep 2021 06:39:31 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso2028342pjb.3;
        Tue, 14 Sep 2021 06:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUwTqwYZOOkMzYqyDRP5u7DXlTVFM/o7xmj81RyBU+U=;
        b=Zy+W6lLKWmt7luEwpTRuKO/55L+1pJhM+U2Y08JCjUl/Sx3GrJY7QhjVoeYU8XS0sZ
         VYkNN1yYSgJpcM/oeMCO+0ImLroJ2E6tKqOy3G3BQc+A+XteLhWOhUNt04iKCz4oLukL
         ZXdeQ2jx1nvY0B/yoIhbppgpWtNXrdn1B8PukHkeaXer6DbeBQQ6LMeN6zIn0UbmFUqA
         XFkU1p/3fDU6Rv88cbsucwIK2FeuA5bSFEOuD0P01iDmKeSieEZM0MwidbNyW+kC5LvM
         reTUrry6bD4yBiSWg+2gSNkw7hmnvgvjy6KZtQZkdkIbi9CfdzA5mje9Mgsm1Myh/rpm
         yczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUwTqwYZOOkMzYqyDRP5u7DXlTVFM/o7xmj81RyBU+U=;
        b=R4ZIwQ7OUXdj76y5+s93DXtskif2fjVhKpKd1gKvOhvdFkiv3yKplluqoa1SR9GYHo
         4V+BP3WSKnPNvKYotpA7TbjVYgZXh+jIpfzdRuYKFCuO0fEgmRVPErE2FtNdDgmngMtt
         4DHOJJ1z84i+JTlGvFe9SQ3nqevNnCxIq2gzzkN9cmpWEe8vw8deV/+rD6G2I+n3vhnB
         2tE1uwPJY27/sb4Ab2RSUOfJTpVU0+e8DAquwtQ14A572KovuEaogl7lO6Cv0jTBTlXT
         lJxhXyUKYf+DJc/2njJp4WEwO/SanT5zvNFmoeGO4hSPwyCSr48MGD5j1af4bsze3nw1
         WQYw==
X-Gm-Message-State: AOAM533pqqFeqz4IdBJ5pstOcWNOkpsyt1nozkVt9AP6uO/AUZ/x1A+D
        XZne8Dqq2dqcEsbJ+t+e9JU=
X-Google-Smtp-Source: ABdhPJx44lS4Ai2yXXn8V591ghM4am9GxTdD+xMKN2ARZV8UrnEqqpomOlRQvCNWc6041rvSAnTYOg==
X-Received: by 2002:a17:90a:9404:: with SMTP id r4mr2180743pjo.240.1631626769029;
        Tue, 14 Sep 2021 06:39:29 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:6ea2:a529:4af3:5057])
        by smtp.gmail.com with ESMTPSA id v13sm10461234pfm.16.2021.09.14.06.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:39:28 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, sfr@canb.auug.org.au, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V5 02/12] x86/hyperv: Initialize shared memory boundary in the Isolation VM.
Date:   Tue, 14 Sep 2021 09:39:03 -0400
Message-Id: <20210914133916.1440931-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914133916.1440931-1-ltykernel@gmail.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
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
index 0924bbd8458e..e04efb87fee5 100644
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

