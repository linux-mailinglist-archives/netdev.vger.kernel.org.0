Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398B143961D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhJYMYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbhJYMXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:23:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E1CC061745;
        Mon, 25 Oct 2021 05:21:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m26so10590844pff.3;
        Mon, 25 Oct 2021 05:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZdmN+tkx79fwis7eS+XRuIwj8hA3a++/fJHMeaiCPUI=;
        b=LHZfmnqJbYkxZqeBLfuMe1x636+SKK8Tw6EC941O8sWLa65vYkRZSLRlS7yLr57Fh0
         kFM4e0u0zDGuuDBC888/NS8vKaV7N7YlBYn8nh35+1IgRUKDDEWNv/GdC9VDRX1derN7
         OM4OdEuQmJtBOO20tvrn7uYiySCM9ZZFA9gkDEaXDHzML5qHqjecE5p/3842cW5dQhIM
         VFvx5LY5e2NJiM2adRrl59MkOco195JZj566gdqoPmX6Pji+xze/ipHxlQ179BiEUOJ5
         zFTT56MhY/ZXCr3FD/dThiXNRJfdBbcuxiucjoZMQZ5a7UwTkQoBAqvcnIbxCEeFAR1B
         k6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZdmN+tkx79fwis7eS+XRuIwj8hA3a++/fJHMeaiCPUI=;
        b=tDa5TD65v+4OKaxDwjEQThDLf989+lGlycHzEYagy1LW9Dqr1TdDXxjnAmCM2sgTwo
         U7v6kFK3FNSaDDVjoRFLoszqXHJuS1WUJntJFDOY2mMxvchUqC0fbok1I5ydq/BSkklR
         KhYYhaZUunDdYQ1a+ELS4cFrPpZrqsBgLBJhppemeDuL+lkDofHg189Ua+yiZYcQV743
         v9xgCpHanmhuGxMs1rknIZqfwJ4V0P7vNI6OgAksb+pQ6uDpaohOyM0XIcm9hGodWGtV
         qV4HXa7QvXniinZNR+EQ2wMY+U4TE4jMzdRS0zODvv6mT8cYJ8BumTGx/4YMZGER803D
         PUEg==
X-Gm-Message-State: AOAM530VJwOiXSVdi3Y5t/h2ZiNLe41Z+Us/aNeuJPxj3WQPiQBv3QF5
        VyMEU0y6jzOb+0U5FlO38sA=
X-Google-Smtp-Source: ABdhPJzfwe2Ak5EVlDSmQyKOmqwsHB9cN5HuW8F40nvpw2lzNMFB73OXyvR08BHTcjpS77UKvgnwZg==
X-Received: by 2002:a63:334c:: with SMTP id z73mr13566286pgz.160.1635164482577;
        Mon, 25 Oct 2021 05:21:22 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:bcf6:9813:137f:2b6])
        by smtp.gmail.com with ESMTPSA id mi11sm2786166pjb.5.2021.10.25.05.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 05:21:22 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        mikelley@microsoft.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, sfr@canb.auug.org.au, david@redhat.com,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V9 2/9] x86/hyperv: Initialize shared memory boundary in the Isolation VM.
Date:   Mon, 25 Oct 2021 08:21:07 -0400
Message-Id: <20211025122116.264793-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025122116.264793-1-ltykernel@gmail.com>
References: <20211025122116.264793-1-ltykernel@gmail.com>
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

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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

