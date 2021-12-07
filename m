Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C7046B4CD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhLGH7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhLGH7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:59:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3401C061746;
        Mon,  6 Dec 2021 23:56:07 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so8899505plp.0;
        Mon, 06 Dec 2021 23:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/5M9gOfMUisREUkN0oMDl3d5AgAs/rybQfOBV8c7GG0=;
        b=iqMBIlwZ0cRMihL7ebFJzQtnX9gzY8f/Gm2aKiyj/dGxhCyKv5GRhzBpl9NhhQf5Ki
         YauW6iCaVM+V7sWtMpLOPLmOPjg9/BIMvQ0b1wuOkR8TcY3WEujZIqbGpF5f3cw6/06b
         69V2kLpNyPwzybu2vn5o9cRG5Uz6RHC0HwESSGM/r1HIN1AhaPbIGU47hRZ5nwiWWg1e
         gQkfLpRIm3z+OYUAqzGEkm1vChWfc7flJlcj2dBpJlByKd9vDfOLtQflSeYO/abZs5WR
         MCL34gCWxwnyzqBxdthcCJ4C+T8SL3YtulbJgNv6i00TgK+w0a6w+YEtDPbvfTlzg2y3
         wbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/5M9gOfMUisREUkN0oMDl3d5AgAs/rybQfOBV8c7GG0=;
        b=aKDdf2NmaG+iEfqzzSzcWySHal3HzeEM98DUSEttMBSphfMtSf7I5QdnjHt83bkP8V
         OAjM9LDWrHoziyVlt+AAVKFcNetGnprkSiTd5OfV1zX6la+Gn4JFEypG2/+ajOCxUVj5
         ylAk5Vu6tMcFGDQH35zoAf96URKbMMuU8BURDJ6chodN+iPUYnC352lnt862MI9wNcbl
         1LDcZIUmEoN4kvCTddBbYowqAy+3kyOP/hdtYWc1GCF5G0BMlUq5fk6NPbRIihAZARaW
         bQKkm7fVVnuG0bZWbzUyCU9S2WQmzqQQpqrqW1RfyzrulRvgpE7KO9jO0Hgsevh0kq+W
         aJ6A==
X-Gm-Message-State: AOAM533veuVn/BJmtuR3MPFvPkh4mkHwJKVmXab3YyPQa8FxUx/ktlOu
        K7x9v/KcShngVSpWv0XGcCs=
X-Google-Smtp-Source: ABdhPJzmSQygtcV32AiUSqniemv899Kpepc9kNHnUv4WZ8zdPUOplc9hqggQY5r9lcsEO2Agyr2q0Q==
X-Received: by 2002:a17:90a:6a82:: with SMTP id u2mr4795405pjj.105.1638863767382;
        Mon, 06 Dec 2021 23:56:07 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:a463:d753:723:c3a9])
        by smtp.gmail.com with ESMTPSA id n15sm1794353pgs.59.2021.12.06.23.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:56:07 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 2/5] x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
Date:   Tue,  7 Dec 2021 02:55:58 -0500
Message-Id: <20211207075602.2452-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207075602.2452-1-ltykernel@gmail.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
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
 arch/x86/kernel/cc_platform.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
index 03bb2f343ddb..47db88c275d5 100644
--- a/arch/x86/kernel/cc_platform.c
+++ b/arch/x86/kernel/cc_platform.c
@@ -11,6 +11,7 @@
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
 
+#include <asm/mshyperv.h>
 #include <asm/processor.h>
 
 static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
@@ -58,9 +59,16 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 #endif
 }
 
+static bool hyperv_cc_platform_has(enum cc_attr attr)
+{
+	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
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

