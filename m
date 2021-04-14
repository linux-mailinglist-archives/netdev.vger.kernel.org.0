Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0113B35F6D6
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352136AbhDNOv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351974AbhDNOuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:54 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F89DC06138C;
        Wed, 14 Apr 2021 07:50:33 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id l76so14569079pga.6;
        Wed, 14 Apr 2021 07:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SNYshAOIhIfYWplCoKI3GKQhqu3xrQdJgtDgLoPsrVY=;
        b=gibuXI9Xv7PARINSU43+2rKSBQQrekXZwe4JwQ/fSldoGkdBytnFZKjdh1uWMusUxb
         BgQY9KiYPHHhszJbeOVJvpB162ge6nEZtamVklk/8VdVGikS2QFEHa3d9VbIgsDYtERj
         U1OSC2tKMrST6MfaGv0Wb6lLasokI084S8I+7JWirTDKYvAwF3mlQNItQCfKFGXibXmC
         7VRGkERZJV1hiFl4tiD76EFkxRAk795i6uHAAHh8lY4jJ7szOhMfztnOyTsBNuY9Oyph
         VepV73vkdDvoHqf5lLhBskr9fBJmbsLOV+hZuDDGaRYdMEzhtsR6nl0UPEAno8awUema
         iuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SNYshAOIhIfYWplCoKI3GKQhqu3xrQdJgtDgLoPsrVY=;
        b=WyFm8hdhyNdU97kPaXyUYnTAyEeTNBbPcnO+TJ8Fg8FokWcMho+yuus+ZxLFrKzOOf
         mXm2ziEPweDCnvXSTpKGc+mdGCu4Ytde9/pcm1LQ1A+SzuIpFwgQ55yAmvp4IVXT1tEV
         02sjV4+dEbIVhfGMujaDxwox+prMTvBwGaefNL5KiXOoYNtRkWGylRZMNIWg1qQzBb33
         G130oX2DHCbfSCZy+GNIsiolIT3wPMtUoTpfhVAVNaeUZX+YU+7bp1GF9hxSp6r/bhES
         gZXKsH1OsCB3b5cHuBxdwWR0+vSdUPk+n1hB9jNUxegmlN+rC8D/xSi0SPVnfgKGIt8G
         imJw==
X-Gm-Message-State: AOAM532ap4JHEYp+4mHyATGPmV0XBUm0s2ZgwOHEU00PTQux3r/P/1bQ
        c2lQV4VuY6eT37CF79xnZsA=
X-Google-Smtp-Source: ABdhPJwnbnl089PfsrvpvokDoexGwlHUvaiFWcLBnccsg7u15LM3+for4Cf+c0I1NoLoEZ/CfdV9tg==
X-Received: by 2002:a63:c741:: with SMTP id v1mr37348049pgg.207.1618411832810;
        Wed, 14 Apr 2021 07:50:32 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:32 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [Resend RFC PATCH V2 09/12] swiotlb: Add bounce buffer remap address setting function
Date:   Wed, 14 Apr 2021 10:49:42 -0400
Message-Id: <20210414144945.3460554-10-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

For Hyper-V isolation VM with AMD SEV SNP, the bounce buffer(shared memory)
needs to be accessed via extra address space(e.g address above bit39).
Hyper-V code may remap extra address space outside of swiotlb. swiotlb_bounce()
needs to use remap virtual address to copy data from/to bounce buffer. Add
new interface swiotlb_set_bounce_remap() to do that.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/linux/swiotlb.h |  5 +++++
 kernel/dma/swiotlb.c    | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index d9c9fc9ca5d2..3ccd08116683 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -82,8 +82,13 @@ unsigned int swiotlb_max_segment(void);
 size_t swiotlb_max_mapping_size(struct device *dev);
 bool is_swiotlb_active(void);
 void __init swiotlb_adjust_size(unsigned long new_size);
+void swiotlb_set_bounce_remap(unsigned char *vaddr);
 #else
 #define swiotlb_force SWIOTLB_NO_FORCE
+static inline void swiotlb_set_bounce_remap(unsigned char *vaddr)
+{
+}
+
 static inline bool is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return false;
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 7c42df6e6100..5fd2db6aa149 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -94,6 +94,7 @@ static unsigned int io_tlb_index;
  * not be bounced (unless SWIOTLB_FORCE is set).
  */
 static unsigned int max_segment;
+static unsigned char *swiotlb_bounce_remap_addr;
 
 /*
  * We need to save away the original address corresponding to a mapped entry
@@ -421,6 +422,11 @@ void __init swiotlb_exit(void)
 	swiotlb_cleanup();
 }
 
+void swiotlb_set_bounce_remap(unsigned char *vaddr)
+{
+	swiotlb_bounce_remap_addr = vaddr;
+}
+
 /*
  * Bounce: copy the swiotlb buffer from or back to the original dma location
  */
@@ -428,7 +434,12 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 			   size_t size, enum dma_data_direction dir)
 {
 	unsigned long pfn = PFN_DOWN(orig_addr);
-	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned char *vaddr;
+
+	if (swiotlb_bounce_remap_addr)
+		vaddr = swiotlb_bounce_remap_addr + tlb_addr - io_tlb_start;
+	else
+		vaddr = phys_to_virt(tlb_addr);
 
 	if (PageHighMem(pfn_to_page(pfn))) {
 		/* The buffer does not have a mapping.  Map it in and copy */
-- 
2.25.1

