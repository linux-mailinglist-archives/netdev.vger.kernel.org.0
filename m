Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C708423827
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhJFGiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237353AbhJFGit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:38:49 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1648C06174E;
        Tue,  5 Oct 2021 23:36:57 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 187so1466586pfc.10;
        Tue, 05 Oct 2021 23:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bh3bd5GoDBhpbfFAmgtElw8PxUdj0XoUDzYAAC0vsTY=;
        b=fLptH8Yqkm4NpahJ1GHFVhxLZJHtZFK0F6kVLI3ISUSQ8UfXGk+JPgslGIoGwZ4xcJ
         escBJcxujYuLTQ3Hxbd6jMrcYzf3C3O3vORWxk0goAAiM88ULIJr/0DDLZCfYf6YH5iB
         VrzWPa/m9dND3MlydLFaZv7XPqv3SBn1kg16OAYv9Rvy2pK2eqPPqiAEu1X1ltBGkbS/
         +f1g0vlyYoZgQLesNSmRb1ijyNI1Lh2XY5txY+RL/aGLhXeXPkWntgFrRCnnxzCe1lJQ
         TTT7D/8TanAcqY5qUsTkL2JwnxxdNs5wedlX+SB8i+lJddOjZ4DUfrMyneTr++bn4JL+
         +SHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bh3bd5GoDBhpbfFAmgtElw8PxUdj0XoUDzYAAC0vsTY=;
        b=iNLVvaxx/EUfntRY19M1hFKPu+iH+AgN05PVsQfRBvdbhS4SuuvoFOpU3oROcGvQFr
         0HmV26IzKnlcCD60aRxMdWmE6GIxUSqi1DLIw3+A8/QlAQBGd/Syun5iIsJS+gGaA7Bq
         Oixh0IU8tokUc6Mq5Nj6JPjf1mMAG/tHHd7JjxDEUAg/LKKn98kVCuO59DcLkSiwleA7
         HGng3YxwkS5Sw5Xgmas+7v76DZ2PBB1Sp/fXCbRLGu1fmR84dxiEradmmzUOuLfxvIbN
         fRgUod/Pt7cjseRJJsY6+v5NiZ+bYIGkqvdTYD3f6qBrnsXc43GWWxVAOEhMM8qBfzZ6
         1n2w==
X-Gm-Message-State: AOAM531XW7RObnK9pD9f1Uikaog0TrviARQLiT6evCO91Wmv/hqQxKcJ
        /Tc6BxWQSVoT4Gb1QMoIn6o=
X-Google-Smtp-Source: ABdhPJx/z3fqh/zWot9zMGoUR83puqeeiM3sMs8T+oCWUMJeflrZTTEa3mhj27M/uhHi0bwIFNTUQw==
X-Received: by 2002:a63:df05:: with SMTP id u5mr19045461pgg.323.1633502217514;
        Tue, 05 Oct 2021 23:36:57 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:37:357b:c418:cfef:30b1])
        by smtp.gmail.com with ESMTPSA id l185sm19886413pfd.29.2021.10.05.23.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 23:36:57 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, jroedel@suse.de, brijesh.singh@amd.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V7 2/9] x86/hyperv: Initialize shared memory boundary in the Isolation VM.
Date:   Wed,  6 Oct 2021 02:36:42 -0400
Message-Id: <20211006063651.1124737-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211006063651.1124737-1-ltykernel@gmail.com>
References: <20211006063651.1124737-1-ltykernel@gmail.com>
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

