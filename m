Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619FC41DA88
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349964AbhI3NHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349581AbhI3NHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4509C06176A;
        Thu, 30 Sep 2021 06:05:52 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s55so3870273pfw.4;
        Thu, 30 Sep 2021 06:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bh3bd5GoDBhpbfFAmgtElw8PxUdj0XoUDzYAAC0vsTY=;
        b=IaFusPs1SrrWHh5qPhnz5hMwfF7HQgdev6yycDp8csrtoV431IAg75JVIUuW8t/MdP
         eLo7gcXTFkgcE4YrnD/WKT3rHaqUa7DUMr1ypc08o4r3DsahJ7PzXUwtjle+cbicu9E7
         WkDKZMm2/VkKRK4KU5JWdCmxlATHWxK+jTz4eZZxEhTdAEwmc0ZvdiVbgq3gXkmiX/Zk
         JCfXqYZvXQw/+j6914cIwtGBIDB8rSnKZ/dQ3f+AWWKOot1/wYRaYwwsOD7ToXB95lmQ
         BGfbx9i4lkWGns+lYDvlkCtUc13h2CM610nfgUnla3M4+9jpLfSnmB/zqvz/xIRHLauA
         fwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bh3bd5GoDBhpbfFAmgtElw8PxUdj0XoUDzYAAC0vsTY=;
        b=lYofZfn/02UPfYq7ZKO9J8xsezEYKDfvSgA13CCkvrztjox2ar+WmIt0Ik2kHpnxir
         qo73qTw5XAcp0i103waJkY/WASAfvB+1jcYri05tsvNFxOyqUMgVTDziKgzKQPyNi2ic
         FzEHCW8o18A788wAEhhD9vH9OF/MwThnFlmL5RIE/HIlNR29KbL27rUGHjcj5tacnS7y
         fcXtv0zWfzyWvk0UE3z8epjY9fT2Y7bYJd0SmPln1m0DB/Xlo9StjAX0JECQ6CJ84AQ0
         z+PvmN6OviSVB3RnlY7NBEsFXimhi9Zdx4NSnM1Kl1ykvbQ7Wdy9EwI5MMtA0Ez0DNQ/
         IjIw==
X-Gm-Message-State: AOAM531leOEI40Y9gKtHvehuSmlLd4NOdS7zhgVsev3itXVdXBko5d2J
        7XAGsjoOqISjbr0Z+lWlx9o=
X-Google-Smtp-Source: ABdhPJxgq8GMDliebLBl8yV1J8ZS46oOYaNwzW9SvYIp+JmuWQemO1JG79xprnbj0RNgBnclWnTy2Q==
X-Received: by 2002:a05:6a00:22cd:b0:43c:9b41:e650 with SMTP id f13-20020a056a0022cd00b0043c9b41e650mr4259994pfj.60.1633007152285;
        Thu, 30 Sep 2021 06:05:52 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:a72f:86cf:2cc5:8116])
        by smtp.gmail.com with ESMTPSA id v7sm3072134pff.195.2021.09.30.06.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:05:51 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 2/8] x86/hyperv: Initialize shared memory boundary in the Isolation VM.
Date:   Thu, 30 Sep 2021 09:05:38 -0400
Message-Id: <20210930130545.1210298-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930130545.1210298-1-ltykernel@gmail.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
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
index 2a709010f53d..ebe3727e1eb8 100644
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

