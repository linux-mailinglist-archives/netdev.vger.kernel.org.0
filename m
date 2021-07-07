Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4333BEB8D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhGGPu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbhGGPt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:49:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FE1C061760;
        Wed,  7 Jul 2021 08:47:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 17so2553873pfz.4;
        Wed, 07 Jul 2021 08:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84IEbLNgJNomBqMgxBtrETy72H72EvXAGdQ00eQF2Mc=;
        b=YNnohj4Chb9T3B9ZYxiBv9YVqoi0X5lB74SQ7L1EnVYnuQ7j+Sylm+oTEpclLAr4Rp
         QMdcSRfsEpsNu8h57gAfWgW+S7FmRK+lRz16mOIVQB9v19q7vKIS/3imFU7L8I+a+CoW
         4CZ1ji2QtUkrwbieeV7oza4eciyEFAW2B4m/iegyGFZxo9emMHECDfkYKuchj9BUm6ka
         +lt0qfR+AlSO/jWbQhKgOe0W6mJ6vX8d+oS1VyY2+/m2yXPG+YkyAhEMSZLvHoK3AYA2
         aynhmc1FnAYYAolwJfs0NpD2mwngTXdQQx4mA0KgjhyurE1FSWmq2vOFbfaVKW7EnbvH
         tEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84IEbLNgJNomBqMgxBtrETy72H72EvXAGdQ00eQF2Mc=;
        b=RBOipSOSv5tIz/Gk4W4BIiEyQA4EiqvYo/gVVveJuzu8R9RDP3wx8KJPcpbKuiiAfM
         gO8K5Ro1IYr7jTxj62Iq1FAztX/uvA5750N0s1zFvd6lENAlPPOn5kIwkLuU+yELgw5S
         Q20p+9hifAIUT0dpaFEU2HsZHxt8j5uDN8e5jR3nFZgN5N6EZBtDFGIHfmMKG3nquHjc
         yQVJP4Kd53851+ZlvnNv//3pk86x8txsubzprzhmUoL3FXicHuDJ7OJxUH6G7Fc0jlmB
         MfFvxk4enYduZY2FhR8TFQ4Swx1B2gSJJWJvqR2c3jXR9Md7dnlBxfQrwnYs3M4hgGzn
         4Xhw==
X-Gm-Message-State: AOAM5339SOa3QKlYkPCSk7/8tJblfX2Nh34Q5hBNpJDzzgnfejXMwVRX
        aNTDoH0mr1CESg11D+BePXc=
X-Google-Smtp-Source: ABdhPJwc0xo238tlV5y9FHemJmnwVdI1QKXmzxerVDS/ZE3a5qm/V6a2aCdYF88RGalmD6tecULCLg==
X-Received: by 2002:a63:1601:: with SMTP id w1mr26556927pgl.116.1625672836292;
        Wed, 07 Jul 2021 08:47:16 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:6b47:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id q18sm23093560pgj.8.2021.07.07.08.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:47:15 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        rppt@kernel.org, Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        ardb@kernel.org, robh@kernel.org, nramas@linux.microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com, david@redhat.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, keescook@chromium.org,
        rientjes@google.com, hannes@cmpxchg.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [Resend RFC PATCH V4 13/13] x86/HV: Not set memory decrypted/encrypted during kexec alloc/free page in IVM
Date:   Wed,  7 Jul 2021 11:46:27 -0400
Message-Id: <20210707154629.3977369-14-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707154629.3977369-1-ltykernel@gmail.com>
References: <20210707154629.3977369-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V Isolation VM reuses set_memory_decrypted/encrypted function
and not needs to decrypted/encrypted in arch_kexec_post_alloc(pre_free)
_pages just likes AMD SEV VM. So skip them.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/kernel/machine_kexec_64.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index c078b0d3ab0e..0cadc64b6873 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -26,6 +26,7 @@
 #include <asm/kexec-bzimage64.h>
 #include <asm/setup.h>
 #include <asm/set_memory.h>
+#include <asm/mshyperv.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -598,7 +599,7 @@ void arch_kexec_unprotect_crashkres(void)
  */
 int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages, gfp_t gfp)
 {
-	if (sev_active())
+	if (sev_active() || hv_is_isolation_supported())
 		return 0;
 
 	/*
@@ -611,7 +612,7 @@ int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages, gfp_t gfp)
 
 void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
 {
-	if (sev_active())
+	if (sev_active() || hv_is_isolation_supported())
 		return;
 
 	/*
-- 
2.25.1

