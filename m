Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BDF468A04
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhLEIWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhLEIVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:21:48 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84147C061751;
        Sun,  5 Dec 2021 00:18:21 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id z6so7197650pfe.7;
        Sun, 05 Dec 2021 00:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4R1/x5dPl8v2bhM1Wqw8GMKwcXKdEyhlm+eRit5majU=;
        b=a199mwwb41SK+3g5nwV1xKmU5gwizT35AAVUi8EUk8s8aLOnPfOSMZ+DMLR46xQuuT
         MqpKzZctmq0YmBBHMP3tAH2eroIBBD8cjLj9PwaEnB2C+snyDUEO0j82lTDGHRmYP/Ig
         bOlyN98YpBfGN+bx8S2gYeEnhpOJjbcYfo8JrVl6Zu9l3rXzJxaFYHM8Fh6XecuDTX9k
         5k2jwAETpzg9EPf0K2t1k+SG8YOophQYDcE2OtnxPueV/d+iE6faWflgKeHhF2CU0RAD
         qzeN6hrSJXIMDWCljoYMoMo+3fsMt5kyd2hroMZAspPvmtkNm8//oYiJKnc/mtxPyMW4
         vQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4R1/x5dPl8v2bhM1Wqw8GMKwcXKdEyhlm+eRit5majU=;
        b=2xCWRLqixvEYa1BGmIIQsJGTRkbOavMNoSBX+6Vj+pNN9yP5djxOHgzrpbpLipDzDH
         mDzMSevsmHXTcNYpnjeyzBDjNP6/Y0FsXe2XVRerVGQyRqBhbOr5+oYxdm45TaI2tudF
         eUecVmiraBC/v/6+S9wCBsyO2/RkBaUTwO8SQwcVVQDtqXlSFAZgPOTj5FQvRiVRflv6
         /reqLmCEP7sB/G+9O8yxZV0xoISi7KnN2sZQQATfZ5QSadqL2iiIiRSD1AYJyCtdxYty
         /X9Ydx69TMPrez/pVcYV05IRxFbClxYnIQxGQVu5aTcRosF/3MoHWqS8+yk65Xcj1Sb3
         bUcA==
X-Gm-Message-State: AOAM532lipi8SmODYwk8kPcc89S4n20BBhMsyWJmkThVlqMEo5FeG3IG
        AmRWicLMO9S2dx7etA2NqQk=
X-Google-Smtp-Source: ABdhPJwjVr/PR4pWsnzxcrhE9ySNvBZumxc7tiGS3XuTHA+biQhguZE4c/ixNuJ3guQaZnB9mhHD+w==
X-Received: by 2002:a05:6a00:1741:b0:4ad:55e0:55b with SMTP id j1-20020a056a00174100b004ad55e0055bmr3973425pfc.58.1638692301062;
        Sun, 05 Dec 2021 00:18:21 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:87aa:e334:f070:ebca])
        by smtp.gmail.com with ESMTPSA id s8sm6439905pgl.77.2021.12.05.00.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 00:18:20 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 2/5] x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
Date:   Sun,  5 Dec 2021 03:18:10 -0500
Message-Id: <20211205081815.129276-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205081815.129276-1-ltykernel@gmail.com>
References: <20211205081815.129276-1-ltykernel@gmail.com>
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
index 03bb2f343ddb..27c06b32e7c4 100644
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
+#ifdef CONFIG_HYPERV
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

