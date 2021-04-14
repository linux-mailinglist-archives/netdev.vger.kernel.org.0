Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F423D35F6C5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352066AbhDNOvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350003AbhDNOut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB474C061574;
        Wed, 14 Apr 2021 07:50:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so12659772pjh.1;
        Wed, 14 Apr 2021 07:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iz6kQKmaAStJz2j939/tUEj2NIuTRDYIEtDill+C7IA=;
        b=D2taYVTe0z905CX87qYISBKtJJpcQncx/+jlzFtm+dqJ1FQrZXjYZ180oWEO28Y5y7
         hlj6+yRPwjy4zDBc0qTSTOI4n3R9lkebe1U3i+D2ckp00qt3mqEM+7XERpL1KMDNXJn4
         7wjSfLucr+uk3vZczBhcDhkKTijEPUzFZEFYwB9fuw000bOFSdkhpR5X452OAoNmDZSB
         6R6DV6d3gKGUbhWxGXR8WhVAEQ7hP4x7wYAWlA87Le8gNxzh+cepaPjZjUSKkvMtMjhr
         s43ZTcJK8Kv06ThNFTuC2wlW97YulfZnT+41LKU+KQPRORDoo8Bg8JSixilt/nL1ihKW
         mQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iz6kQKmaAStJz2j939/tUEj2NIuTRDYIEtDill+C7IA=;
        b=AATid6iZ/MaYVrgV5BoG0WktjMso1ISqO5MoNS+tQbKPR+vO7ctXEfwOs62LltuWec
         EhkeF8jvT1QO+Giuxp5RBX5GEG0AEjH+1MpxQno6D2Vf+HGhRoKGr4lpfZ1PSif2PxFg
         BQaofx9SUuHql05ukc9qeLsJxJJLvhQfeJd5hb9ep0grRimZ94hjFRZbiKymm2xxLl+N
         HyMhB7yHjsNl07PTAAA+AqZ3ykYXnYMSNRcauxgYa/751zGRYa/7R/R/kyP7vF7EpWtM
         qsXt+ngr0+PJmO7DPsfBgHdsPF+vJk0gjV1DRJJqG7VSy/GwESvtuJbU4IXLokdHVRvh
         PTMQ==
X-Gm-Message-State: AOAM530VU/uagLS7AtplvH2xozMVyB67rp3ZxaaYCq48Pors8+v57ojh
        0gL6w4WNg5UiH6hRni06zDo=
X-Google-Smtp-Source: ABdhPJwoWQUtM+Kmo2QdePpZgHK8I2K8arUG2KPZ/TVvHugCh22W4iDEwoDeLZUiglDRWNvFY5wZBA==
X-Received: by 2002:a17:90a:bf17:: with SMTP id c23mr4103212pjs.12.1618411826429;
        Wed, 14 Apr 2021 07:50:26 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:26 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [Resend RFC PATCH V2 02/12] x86/HV: Initialize shared memory boundary in Isolation VM
Date:   Wed, 14 Apr 2021 10:49:35 -0400
Message-Id: <20210414144945.3460554-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V exposes shared memory boundary via cpuid HYPERV_
CPUID_ISOLATION_CONFIG and store it in the shared_gpa_
boundary of ms_hyperv struct. This prepares to share
memory with host for AMD SEV SNP guest.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |  2 ++
 include/asm-generic/mshyperv.h | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index e88bc296afca..aeafd4017c89 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -328,6 +328,8 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.features_b & HV_ISOLATION) {
 		ms_hyperv.isolation_config_a = cpuid_eax(HYPERV_CPUID_ISOLATION_CONFIG);
 		ms_hyperv.isolation_config_b = cpuid_ebx(HYPERV_CPUID_ISOLATION_CONFIG);
+		ms_hyperv.shared_gpa_boundary =
+			(u64)1 << ms_hyperv.shared_gpa_boundary_bits;
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index c6f4c5c20fb8..b73e201abc70 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -34,8 +34,19 @@ struct ms_hyperv_info {
 	u32 max_vp_index;
 	u32 max_lp_index;
 	u32 isolation_config_a;
-	u32 isolation_config_b;
+	union
+	{
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

