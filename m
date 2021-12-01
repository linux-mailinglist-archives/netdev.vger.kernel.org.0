Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44646525E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 17:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351360AbhLAQGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 11:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhLAQG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 11:06:29 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A8CC061748;
        Wed,  1 Dec 2021 08:03:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1992748pjb.1;
        Wed, 01 Dec 2021 08:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+xUpMEUxrmLaLZETYGitNsZhfrMVhJB1Bk6Yp08byU=;
        b=br/8rZr5MsJhI8n1irXI1gp9Qy4y2qB0ZN5gBXyv9j4Su5bhkV81nOXq9DGZu89aNd
         1yE59r1UZL97RAiD6x+SXTYEoUeu7G0jCsBQ1cuLrPvmNB9yCPuhglIAjJYi604mfSQh
         gyy1MrYjqf6FuZtwg+yZTOfgs9SEgL6VOT93jo6Lr0hZDIeKaRrkgfgJp35M71zw1HjF
         mCa+7WRc/5GxMq2fBfHGjWIosZhHgGj4pZbJ+Vjey1HAEvVpBkgPAoLT3LqFfLNjLY2o
         qMt8D2/BJNN7vwve4krmx/83c7M5pnGp6HV82Z4b4QIdszQpO2qvXOEgIjSwmrsLY0WX
         XfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+xUpMEUxrmLaLZETYGitNsZhfrMVhJB1Bk6Yp08byU=;
        b=YQbBRiAPcMKeSHexeiuBu4amEtMPjTSrulDHwrRrNiO2FCa+7nZACzeEkgVEPaEeat
         toBiYRejdt08oFzDr9k9xbNI28rGyvHJbfiCZgY6/zPcqzEl8EHjtkBX7RK4elwdbPOe
         6NtEvAK3nFDHaQgR2TlxA+CWtWYEambAWl7I09NUgOLfNegHKTA0ar/iC7Bq7ch5Iu/V
         WYEMHBHjCIKxs9vc2N3HEFwlCUu8jyovIogF/qI4OW7eTeV1K0JOkPXKwSG2Pqwr9wIL
         ns1iSweLzCkBnNZhPbfgHwgXo9So+yS3M6W4rFNKIRbHnqOCaGj7tCalOqq5ncfx3xaM
         opUQ==
X-Gm-Message-State: AOAM532+9FeZTfsqioYl/Q2U8pHMYYsAvkAnGEpRpA+rbpNviNYgOmYd
        yt+zoPja4nCHyTMLbEziMNc=
X-Google-Smtp-Source: ABdhPJzYMUML3tqpL7gDFerbs5Ms9xF8HxCcNqwI0mV93rIMF31+44VhoYZsU5gprIBYp9oOrgPvNQ==
X-Received: by 2002:a17:902:748c:b0:142:5f2f:1828 with SMTP id h12-20020a170902748c00b001425f2f1828mr8493620pll.4.1638374588262;
        Wed, 01 Dec 2021 08:03:08 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:7fe9:3f1e:749e:5d26])
        by smtp.gmail.com with ESMTPSA id i193sm260316pfe.87.2021.12.01.08.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:03:08 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V3 2/5] x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
Date:   Wed,  1 Dec 2021 11:02:53 -0500
Message-Id: <20211201160257.1003912-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201160257.1003912-1-ltykernel@gmail.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V provides Isolation VM which has memory encrypt support. Add
hyperv_cc_platform_has() and return true for check of GUEST_MEM_ENCRYPT
attribute.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/kernel/cc_platform.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
index 03bb2f343ddb..f3bb0431f5c5 100644
--- a/arch/x86/kernel/cc_platform.c
+++ b/arch/x86/kernel/cc_platform.c
@@ -11,6 +11,7 @@
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
 
+#include <asm/mshyperv.h>
 #include <asm/processor.h>
 
 static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
@@ -58,9 +59,23 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 #endif
 }
 
+static bool hyperv_cc_platform_has(enum cc_attr attr)
+{
+#ifdef CONFIG_HYPERV
+	if (attr == CC_ATTR_GUEST_MEM_ENCRYPT)
+		return true;
+	else
+		return false;
+#else
+	return false;
+#endif
+}
 
 bool cc_platform_has(enum cc_attr attr)
 {
+	if (hv_is_isolation_supported())
+		return hyperv_cc_platform_has(attr);
+
 	if (sme_me_mask)
 		return amd_cc_platform_has(attr);
 
-- 
2.25.1

