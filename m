Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB82C46B3AE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhLGHXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhLGHXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:23:31 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0774C061746;
        Mon,  6 Dec 2021 23:20:01 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id q17so8787876plr.11;
        Mon, 06 Dec 2021 23:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/5M9gOfMUisREUkN0oMDl3d5AgAs/rybQfOBV8c7GG0=;
        b=HQHILh0xfC+iio9HXP69cg5B0dsEbz8x0SgxiL8EZOWUxKe6Ml6IwPDIHHaNOYrcA1
         Xxvzo2aLk6XNd843SAFKVx1Dfou84UVuugLsqXZeTUDDctogYBzWrIGSmK415TugOxuy
         fYdJ9D/jc82SQXAHeSye2vTPxLZSWB5ptOmKVXHtmi2TfuDes14mH+msFJYGnR78L+Y0
         LCioRvoUtQhcvkrYfuHIryPrZE4eTO7N2JuqU2XNKLwk8LEQhj48TJZP6ywFHHRuNYax
         q2TWgArPWgAg4RXVBaPnCD53dqA79mOKKFB5cL7wxyoMc4w1z/2kiA9dDR7KEgFiUG/5
         LEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/5M9gOfMUisREUkN0oMDl3d5AgAs/rybQfOBV8c7GG0=;
        b=EbGQR7FBHLwAD7Y602vnX0UKG5FZVIff3RI0b1HswfyCAEi2PGDOg0MmMqG/2ImTn9
         wX5z+d8reoj8uMn0TdfEduvT1lK80tKKWvU1i74nGFFc1XVhLQS8LyTQEbkplO3uyDD8
         nsz8C/6t+09h+K3ou8xN86TsaKYKFPp8muj7pENHyW3V7OVn2jdhY/+jgdIBRMsD0bfI
         CgDqS0iO8zqPKCUc/t45S/tdlfTGpHrsYQ5qhtS0dVeZlrL3utfdL+tUKbvu8UquXUoG
         06ExZQPLaeOb2eWQfqvZzipmNK2lpkJkFwrwaAGB3vHsXNaxa4Lx/pj9YoYtnpWDh7j9
         X1vw==
X-Gm-Message-State: AOAM530uhhZlG3SASvYC2yESiFYZM00QGM+nT0fumGTPGHN4cnXOFY1i
        vaV/q8JFs1ETAzAr29fzh+9Zuu9TtvKO54K6
X-Google-Smtp-Source: ABdhPJy/mQHIDBNoBo1q+GH/lMBNnM+gLAlWH9a0/39dNkp3kkA+Nzc597FxFq/ZQE4xMfrbxf8ZSQ==
X-Received: by 2002:a17:902:82c9:b0:142:401f:dc9 with SMTP id u9-20020a17090282c900b00142401f0dc9mr50143445plz.43.1638861601201;
        Mon, 06 Dec 2021 23:20:01 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:e747:5b78:1904:a4ed])
        by smtp.gmail.com with ESMTPSA id u12sm2081789pfk.71.2021.12.06.23.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:20:00 -0800 (PST)
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
Date:   Tue,  7 Dec 2021 02:19:38 -0500
Message-Id: <20211207071942.472442-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207071942.472442-1-ltykernel@gmail.com>
References: <20211207071942.472442-1-ltykernel@gmail.com>
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

