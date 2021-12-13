Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4BA47217D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhLMHO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 02:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhLMHOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 02:14:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED6C06173F;
        Sun, 12 Dec 2021 23:14:23 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so13959670pjb.5;
        Sun, 12 Dec 2021 23:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LTLz7GgAX11MfClfWm4VByenkQJ5cwVcinYkI0CYydg=;
        b=eIBO98gr6cqdhEubdZxn7qJbRXcsGJcQJKCTBTWQMyIeHrNp5xrHWYdAoKYNVGEidJ
         LFwP3LjGoL5tFuzB2FoB5YpZg5bwVmowqjbEIb8AsmhZerCmxw86+voMBrO3FdsH4LZ1
         v8oAohgYKdqLsMvZ/GTDqezGmPqe06lPPdMYJ8kKDtdDCRGI+T2u1D6j25qAwdvo7zlI
         679EHAHUZ/Q7woRuLMzvvmv9YQOH/DT1Dkg52bG9+CtfhWhBq/5McohZ6K/5TT2Unmva
         iRnNz4FNW2NV5wXk4ssnY1Wipt5DNixWOWnYmq/MRnkkFwLm0dKEKvTE3IQj4PHbr8gx
         d9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LTLz7GgAX11MfClfWm4VByenkQJ5cwVcinYkI0CYydg=;
        b=vZGaqqu7ea7Ea3vNtiv0X7mx2IcN99tqz/kdBxfWE4Jy5LsxMGtNwS3QRMY8Ld/HEn
         hLmAtbo1pgqWlpEKge2+rhxzLXgYfvqyvTCnIJW/qGYPbxOgAqWftpR7eRGijf/zrHbq
         3X/unmaOpep8JCrbZaV+OCwNYULp4nftKMp+I/bkDgy1lbMS91/hOUUH7WXhclXTtwCR
         O3QTWnNeKChhlShkdnQ1Evw79GnYlDFqGGHnqXYDobyuojpv/AwZaxqsrbE9LP+K/joJ
         kn5pBpXYV1BOiPbnDPRMKUEbZYPQcutNZaalTRq/rN9Ga95agsQbee0VHKhrHHUWJ4wx
         8N5Q==
X-Gm-Message-State: AOAM531QVeqLGvaSclXqYY5EL4sbBrNO5VFwGiXSLPQ1r7eU/Jq8WdlV
        RwqZVOSlrkdXFq6HgENU/m0=
X-Google-Smtp-Source: ABdhPJwyUng+IRJS7MH80C/GEuQWaWTRNRKCx4z2HRH688KUyKHYm7NSiU3shK/X0mt0z+tL2buWiw==
X-Received: by 2002:a17:902:c947:b0:141:e7f6:d688 with SMTP id i7-20020a170902c94700b00141e7f6d688mr92839450pla.56.1639379663188;
        Sun, 12 Dec 2021 23:14:23 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:a586:a4cb:7d3:4f27])
        by smtp.gmail.com with ESMTPSA id qe12sm6079401pjb.29.2021.12.12.23.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 23:14:22 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V7 2/5] x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
Date:   Mon, 13 Dec 2021 02:14:03 -0500
Message-Id: <20211213071407.314309-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213071407.314309-1-ltykernel@gmail.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V provides Isolation VM for confidential computing support and
guest memory is encrypted in it. Places checking cc_platform_has()
with GUEST_MEM_ENCRYPT attr should return "True" in Isolation vm. e.g,
swiotlb bounce buffer size needs to adjust according to memory size
in the sev_setup_arch(). Add GUEST_MEM_ENCRYPT check for Hyper-V Isolation
VM.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v6:
	* Change the order in the cc_platform_has() and check sev first.

Change since v3:
	* Change code style of checking GUEST_MEM attribute in the
	  hyperv_cc_platform_has().
---
 arch/x86/kernel/cc_platform.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
index 03bb2f343ddb..6cb3a675e686 100644
--- a/arch/x86/kernel/cc_platform.c
+++ b/arch/x86/kernel/cc_platform.c
@@ -11,6 +11,7 @@
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
 
+#include <asm/mshyperv.h>
 #include <asm/processor.h>
 
 static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
@@ -58,12 +59,19 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 #endif
 }
 
+static bool hyperv_cc_platform_has(enum cc_attr attr)
+{
+	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
+}
 
 bool cc_platform_has(enum cc_attr attr)
 {
 	if (sme_me_mask)
 		return amd_cc_platform_has(attr);
 
+	if (hv_is_isolation_supported())
+		return hyperv_cc_platform_has(attr);
+
 	return false;
 }
 EXPORT_SYMBOL_GPL(cc_platform_has);
-- 
2.25.1

