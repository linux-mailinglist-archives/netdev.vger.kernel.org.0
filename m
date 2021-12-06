Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A78469843
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbhLFOPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245677AbhLFOPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:15:23 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190EBC061359;
        Mon,  6 Dec 2021 06:11:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k4so7126982plx.8;
        Mon, 06 Dec 2021 06:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c94kxaesuiraty8vU1XcHdW6Y29KA3FWH99u5YD+zaQ=;
        b=Brq2mimjObX21h84ZlwsdVqoHa8seEX14RIOTL/JqSORMB6eVFY5W7i0gDlXvB8YjD
         WHM7TR4u5wkiTCGdCVj50Oz7CNCC1x5WtKYcJYfD0qUI3XSGqi0v6hZZOtQ0dWEoLu7j
         jlBBHkFsCUXW8FU9XoF1gAp7WofnCuvPPVwYav7pHZMFb/RlNTn+eurZYyb2m1O51BnI
         t051ZXODLIeL8n2gXn6atA8nsje2TCH6TG/UXxH93W+iGFDXbp0QTQ5W+VkgqLpzLhWe
         w6NTq3PUImMcceKV6Ll95jHdYRzSwOpTd1MuPSOq1oMZaTzFltgAgThST7GxVhM3B6+4
         bKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c94kxaesuiraty8vU1XcHdW6Y29KA3FWH99u5YD+zaQ=;
        b=NJvYt/wF1QXNq7dO8YB/rkwMwNqNO1GfgqU3bmGphKqNFV9IDc8B8T97SXXlXmtXBY
         6EwhgZbMV6AKHDF9T8NeRGx0/5jZmBRlweMWZxTE5QP2Qk4QjbOB48FsbAzOnR2WF9w+
         oRCjncrYC+7mXSx5iYORrNc8DpJpQRhkhBkAecbYQs5cRAqvFl5NeFH0kKrW4KBr28bz
         YXroI3mK2vKVvoT2YK+wmiE89xcQQNgJOhiaMLIUPofhZ6wqKE4IzidpyiA3hoVeDVW7
         jMkqlQmx4BcnNQUjvSa/xD2Tbb/1MzMOvWytpIcgbmXcqUh+Ji7KbY1X8WgnD6mcJ3LM
         lhiw==
X-Gm-Message-State: AOAM530AEAL9uKE9w3EDpYNERu9uqw34zSHMxaznUgX+xVX6shxnzfCq
        0PKDYsLL1ElW1aIqJtd+O/vxB7s5W6arV08v
X-Google-Smtp-Source: ABdhPJyI7RrZ8Xex/dRl/iPF/2y+DXSSDfDYcIbgrzJbuSVZS0yQeN/8Q7NmVriRLB0HNCKMZuXpLg==
X-Received: by 2002:a17:902:9f98:b0:144:e777:f88e with SMTP id g24-20020a1709029f9800b00144e777f88emr44096480plq.31.1638799914443;
        Mon, 06 Dec 2021 06:11:54 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:b5b5:3f40:cec1:40a0])
        by smtp.gmail.com with ESMTPSA id g19sm7717606pfc.145.2021.12.06.06.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 06:11:54 -0800 (PST)
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
Subject: [PATCH V5 2/5] x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
Date:   Mon,  6 Dec 2021 09:11:42 -0500
Message-Id: <20211206141145.447453-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206141145.447453-1-ltykernel@gmail.com>
References: <20211206141145.447453-1-ltykernel@gmail.com>
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
Change since v3:
	* Change code style of checking GUEST_MEM attribute in the
	  hyperv_cc_platform_has().
---
 arch/x86/kernel/cc_platform.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
index 03bb2f343ddb..7b66793c0f25 100644
--- a/arch/x86/kernel/cc_platform.c
+++ b/arch/x86/kernel/cc_platform.c
@@ -11,6 +11,7 @@
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
 
+#include <asm/mshyperv.h>
 #include <asm/processor.h>
 
 static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
@@ -58,9 +59,20 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 #endif
 }
 
+static bool hyperv_cc_platform_has(enum cc_attr attr)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
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

