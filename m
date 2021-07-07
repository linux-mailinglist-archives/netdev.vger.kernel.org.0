Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702BA3BEAEE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhGGPiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhGGPiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:38:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03EFC061574;
        Wed,  7 Jul 2021 08:35:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d12so2528618pfj.2;
        Wed, 07 Jul 2021 08:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XbGhpS5yStXGWn3Ym/sECphkTnEdMSaFIpokEER49XU=;
        b=BtC8kdX2uIAXjsaHTdfZ3FZO+N9En6asx9AqhqBPqzz4yoUQnDknn819wfUH7ezd2p
         szndynSEmvQctwLw1nuFyxQHD2Dn6g4fxu85DeZxhAJmC823C/auEHp7CuPVW4JmKWPC
         +tLWV4Ub6Kt226chChhJxWigDi9zgY+gB1sip+rQGrKRyCoNohwasHCqxATli+kEBh11
         UAE5z21Wd+jPm91+hFX8Ue7a1zEAL53PiQuV+JBupHHxKpCxYNAWhV6faTjvx4/AvCpz
         z6ABnzr83wHK8D6bniKnHvLPW036vFU3jco8xhNqC0r/NaySaI0fJ184Z8ld4h0GYEYr
         ZLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XbGhpS5yStXGWn3Ym/sECphkTnEdMSaFIpokEER49XU=;
        b=TNFJLrZ04AzIHbQ2d9BmFLx8Vpq87cMj6T85YrZMRLsrjIWzOFY18boM0XrmsUfbi3
         i0CO6mFaeLW9r1ewkspqrasL42bc0cwSkr+/vIzG2vz+QZ6AMfRaNokiDLt0sn6A+c2P
         W7TCLeZx841GzABR4xTgcxJsGHcpqu9tWDNzoBaqK7bN72Xnj+Gj1Ur9RxhnDg402MD9
         LacU3jTKT4CHyTDlmIvUsEQKglchovsygEI9Yd2zkN8dJGbu2QwlL0PjksFmnix1W7zt
         Uzbpftnvh8j4LJ3tvxa/hlw5EKHyYkA1fI5pHw8xRxwj5YZwlIr5qR5woHIJ/GbFJN02
         bMlQ==
X-Gm-Message-State: AOAM533dGqIXRDvZ1xPlaTdzg8YsnPrpkvAp5/wqBjfZgJ8gr6oCuvOw
        i5Lgz2tUt02cFvnVZHj3fTw=
X-Google-Smtp-Source: ABdhPJy77j4/OHtCtQz0cn9ku774dx02+q+pAFp0Fnosh6xARArR8grx/YZvqPCQ4ZIgKqBL1CVqwQ==
X-Received: by 2002:a05:6a00:1709:b029:308:747d:b7be with SMTP id h9-20020a056a001709b0290308747db7bemr26526754pfc.41.1625672123297;
        Wed, 07 Jul 2021 08:35:23 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:6b7f:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id y11sm21096877pfo.160.2021.07.07.08.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:35:22 -0700 (PDT)
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
        rppt@kernel.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, ardb@kernel.org,
        nramas@linux.microsoft.com, robh@kernel.org, keescook@chromium.org,
        rientjes@google.com, pgonda@google.com, martin.b.radev@gmail.com,
        hannes@cmpxchg.org, saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, anparri@microsoft.com
Subject: [RFC PATCH V4 07/12] HV/Vmbus: Initialize VMbus ring buffer for Isolation VM
Date:   Wed,  7 Jul 2021 11:34:48 -0400
Message-Id: <20210707153456.3976348-8-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707153456.3976348-1-ltykernel@gmail.com>
References: <20210707153456.3976348-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

VMbus ring buffer are shared with host and it's need to
be accessed via extra address space of Isolation VM with
SNP support. This patch is to map the ring buffer
address in extra address space via ioremap(). HV host
visibility hvcall smears data in the ring buffer and
so reset the ring buffer memory to zero after calling
visibility hvcall.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/Kconfig        |  1 +
 drivers/hv/channel.c      | 10 +++++
 drivers/hv/hyperv_vmbus.h |  2 +
 drivers/hv/ring_buffer.c  | 84 ++++++++++++++++++++++++++++++---------
 4 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 66c794d92391..a8386998be40 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -7,6 +7,7 @@ config HYPERV
 	depends on X86 && ACPI && X86_LOCAL_APIC && HYPERVISOR_GUEST
 	select PARAVIRT
 	select X86_HV_CALLBACK_VECTOR
+	select VMAP_PFN
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 01048bb07082..7350da9dbe97 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -707,6 +707,16 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	if (err)
 		goto error_clean_ring;
 
+	err = hv_ringbuffer_post_init(&newchannel->outbound,
+				      page, send_pages);
+	if (err)
+		goto error_free_gpadl;
+
+	err = hv_ringbuffer_post_init(&newchannel->inbound,
+				      &page[send_pages], recv_pages);
+	if (err)
+		goto error_free_gpadl;
+
 	/* Create and init the channel open message */
 	open_info = kzalloc(sizeof(*open_info) +
 			   sizeof(struct vmbus_channel_open_channel),
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 40bc0eff6665..15cd23a561f3 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -172,6 +172,8 @@ extern int hv_synic_cleanup(unsigned int cpu);
 /* Interface */
 
 void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
+int hv_ringbuffer_post_init(struct hv_ring_buffer_info *ring_info,
+		struct page *pages, u32 page_cnt);
 
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 2aee356840a2..d4f93fca1108 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -17,6 +17,8 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/prefetch.h>
+#include <linux/io.h>
+#include <asm/mshyperv.h>
 
 #include "hyperv_vmbus.h"
 
@@ -179,43 +181,89 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *channel)
 	mutex_init(&channel->outbound.ring_buffer_mutex);
 }
 
-/* Initialize the ring buffer. */
-int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
+int hv_ringbuffer_post_init(struct hv_ring_buffer_info *ring_info,
+		       struct page *pages, u32 page_cnt)
 {
+	u64 physic_addr = page_to_pfn(pages) << PAGE_SHIFT;
+	unsigned long *pfns_wraparound;
+	void *vaddr;
 	int i;
-	struct page **pages_wraparound;
 
-	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
+	if (!hv_isolation_type_snp())
+		return 0;
+
+	physic_addr += ms_hyperv.shared_gpa_boundary;
 
 	/*
 	 * First page holds struct hv_ring_buffer, do wraparound mapping for
 	 * the rest.
 	 */
-	pages_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
+	pfns_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(unsigned long),
 				   GFP_KERNEL);
-	if (!pages_wraparound)
+	if (!pfns_wraparound)
 		return -ENOMEM;
 
-	pages_wraparound[0] = pages;
+	pfns_wraparound[0] = physic_addr >> PAGE_SHIFT;
 	for (i = 0; i < 2 * (page_cnt - 1); i++)
-		pages_wraparound[i + 1] = &pages[i % (page_cnt - 1) + 1];
-
-	ring_info->ring_buffer = (struct hv_ring_buffer *)
-		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
-
-	kfree(pages_wraparound);
+		pfns_wraparound[i + 1] = (physic_addr >> PAGE_SHIFT) +
+			i % (page_cnt - 1) + 1;
 
-
-	if (!ring_info->ring_buffer)
+	vaddr = vmap_pfn(pfns_wraparound, page_cnt * 2 - 1, PAGE_KERNEL_IO);
+	kfree(pfns_wraparound);
+	if (!vaddr)
 		return -ENOMEM;
 
-	ring_info->ring_buffer->read_index =
-		ring_info->ring_buffer->write_index = 0;
+	/* Clean memory after setting host visibility. */
+	memset((void *)vaddr, 0x00, page_cnt * PAGE_SIZE);
+
+	ring_info->ring_buffer = (struct hv_ring_buffer *)vaddr;
+	ring_info->ring_buffer->read_index = 0;
+	ring_info->ring_buffer->write_index = 0;
 
 	/* Set the feature bit for enabling flow control. */
 	ring_info->ring_buffer->feature_bits.value = 1;
 
+	return 0;
+}
+
+/* Initialize the ring buffer. */
+int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
+		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
+{
+	int i;
+	struct page **pages_wraparound;
+
+	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
+
+	if (!hv_isolation_type_snp()) {
+		/*
+		 * First page holds struct hv_ring_buffer, do wraparound mapping for
+		 * the rest.
+		 */
+		pages_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
+					   GFP_KERNEL);
+		if (!pages_wraparound)
+			return -ENOMEM;
+
+		pages_wraparound[0] = pages;
+		for (i = 0; i < 2 * (page_cnt - 1); i++)
+			pages_wraparound[i + 1] = &pages[i % (page_cnt - 1) + 1];
+
+		ring_info->ring_buffer = (struct hv_ring_buffer *)
+			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
+
+		kfree(pages_wraparound);
+
+		if (!ring_info->ring_buffer)
+			return -ENOMEM;
+
+		ring_info->ring_buffer->read_index =
+			ring_info->ring_buffer->write_index = 0;
+
+		/* Set the feature bit for enabling flow control. */
+		ring_info->ring_buffer->feature_bits.value = 1;
+	}
+
 	ring_info->ring_size = page_cnt << PAGE_SHIFT;
 	ring_info->ring_size_div10_reciprocal =
 		reciprocal_value(ring_info->ring_size / 10);
-- 
2.25.1

