Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFE045A5D8
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhKWOkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbhKWOkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:40:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97812C061574;
        Tue, 23 Nov 2021 06:36:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so2242196pjc.4;
        Tue, 23 Nov 2021 06:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+xUpMEUxrmLaLZETYGitNsZhfrMVhJB1Bk6Yp08byU=;
        b=AlKcv7Y4VFkVezS6aJXAds/NWYnLHTHgFDawHsIGURkEQw1ZQprC+xxgttepVcIQUM
         5T5M0RL+DPFTteQFgNGSjajmwgRX1J2Y5QsSwTqvWdVg1A+EWhpdaWNqmbKB24YbhnwY
         VTf6iEPD2bD9xmmRrEK7FLp6gAd4SMfhDEAaTdaySH6ygkl9daOZYS/EkqwnTKSZglAK
         egCsNvtL8/Q16NYzGtBDx6YW50D+dp/CauiDtizCo8lfzW3y900HzjaUttJ2TmSaJV4N
         ShJbzW4YSovU0kpEhKAaY2ps0ZKmQFzKQmxGR0raTUS1hPCogFjcj1BjeQYlXNYc4eIF
         EFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+xUpMEUxrmLaLZETYGitNsZhfrMVhJB1Bk6Yp08byU=;
        b=ELqLV6Z9DQ25LDup3VgIbH5W9Nf2V8It8IZMxmVhKvJjoQMwXTUVnlNAfRsCj1T5q8
         MAi9PXB/3v87s8PotIEfqkPSv3VT7S3LXPcdGChikojpY+YZ5KLAOve1+fYGxRQzvMlG
         joUWUmYgcJGF/HcX6y1dA3STn1ACrr8ztDSWbUFIIINs5N4qAfsFeMF7XPKTWyJhfsFK
         /tGuDuXP+YDyQ4No+7sE/Ygl8fRe5IAw6OW1Qa3/3yB8Zwx/j8Ui1c0fGgJcohSPiWZo
         89OVr5EhSFK/cag2JcaA+25S9ftwIy2SFm5nkf7WMsXtWCTkpBpwxxgb1O8CUps5STi0
         zCTQ==
X-Gm-Message-State: AOAM530itaNe8ko+TQOw3e+UH6g/MKMkbBMyB6Y4HFjRVq/G0LgYk4yP
        bTNE8mFO3zvt1hRgBW1adtM=
X-Google-Smtp-Source: ABdhPJwRbhdcFhTlrcl5ARyO8E5M5xT/1VQMfqX2FgiEinsxJqYW1NtlXEltffF5Oag+q0rt470N+g==
X-Received: by 2002:a17:90b:180b:: with SMTP id lw11mr3650766pjb.108.1637678218159;
        Tue, 23 Nov 2021 06:36:58 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:af65:c3d4:6df:5a8b])
        by smtp.gmail.com with ESMTPSA id j13sm11926127pfc.151.2021.11.23.06.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:36:57 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        xen-devel@lists.xenproject.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V2 3/6] x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
Date:   Tue, 23 Nov 2021 09:30:34 -0500
Message-Id: <20211123143039.331929-4-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123143039.331929-1-ltykernel@gmail.com>
References: <20211123143039.331929-1-ltykernel@gmail.com>
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

