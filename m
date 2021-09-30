Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619C641DA9D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350027AbhI3NIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349956AbhI3NHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:45 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D34AC06176A;
        Thu, 30 Sep 2021 06:06:03 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g184so6149033pgc.6;
        Thu, 30 Sep 2021 06:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cUs+nJBemKyqHW1/+tBNnIBzfXId6r+3EciJyXUHzJs=;
        b=RZFctd5dW0a89iRZZHRCFcKcJLA39/1742Yt377tcbISa2AmPIQs/DjEDMQtgx9oPz
         6su24OUlHIBQgZmzUKUjnzaA9sS0rLvEI9bcDuNnrG1wLxTmk2EcqlLQYP6kLHdqBE0g
         YLrO1nP5qpZXh3D4HXnEW6LnXFKY0igXNlQ+gFPCEJpQkJM8U5lNfLO1Bay8BxIo1/lB
         uTTrj54p6kP4agB/klOYj939bScMyZrJYbKKVyMteybe9G4GTPDJ/iE0fMumPjSncwXy
         uIrQfXdd41HCzXKW7lBzdvkZoyb4tYVqL8hUeM9mZ9IYWPjM5xY0siFjoJdBI5BPkXka
         b4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cUs+nJBemKyqHW1/+tBNnIBzfXId6r+3EciJyXUHzJs=;
        b=D/cqqm7Fs71Z50WcskG/myBSriWCZbJ1jExfgD+E1g7fIlmc4faccvx6BBuwQWDwuc
         qs1AVqNtqDXujQc+V5ptCIty2z7TNeU1HshDO1t5YI5MNJuOnY+vuuA9ZydvGeEmD8hd
         5CaF+GQvDgZP1VKGGuhTymD79RduWAUpnQT3+elUVxUvqUZT/9AmI4ytdiCz2E30evPa
         ejiz3WMYkPUC7va8BDRqurGnGv014qqqzFUDtnCxjMjeg6q7eVrsuYubPp44GjUZakQ4
         FmYYF9CYYC4BZSuAjId+e80yRNGAnOtgsUZQM5U1eFJhjQyZcbRr0Ozvd7lOhREpqJU8
         K48A==
X-Gm-Message-State: AOAM531elyuNZHf5QV7eG9aYtSMkZlmq3uBNMBWaLjSvsgZtDT4YPRcH
        kph9UbF83re3iRalMp0uDqc=
X-Google-Smtp-Source: ABdhPJwywRGGJxi2nc9fSfsDiR0aFN3t3Vo1LUIV4bB1PcT2E2cayprbxTpBi9lfROrxbbqnOvUGcA==
X-Received: by 2002:a63:4457:: with SMTP id t23mr4858978pgk.354.1633007162966;
        Thu, 30 Sep 2021 06:06:02 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:a72f:86cf:2cc5:8116])
        by smtp.gmail.com with ESMTPSA id v7sm3072134pff.195.2021.09.30.06.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:06:02 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 8/8] Drivers: hv : vmbus: Initialize VMbus ring buffer for Isolation VM
Date:   Thu, 30 Sep 2021 09:05:44 -0400
Message-Id: <20210930130545.1210298-9-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930130545.1210298-1-ltykernel@gmail.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

VMbus ring buffer are shared with host and it's need to
be accessed via extra address space of Isolation VM with
AMD SNP support. This patch is to map the ring buffer
address in extra address space via vmap_pfn(). Hyperv set
memory host visibility hvcall smears data in the ring buffer
and so reset the ring buffer memory to zero after mapping.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v4:
	* Use PFN_DOWN instead of HVPFN_DOWN in the hv_ringbuffer_init()

Change since v3:
	* Remove hv_ringbuffer_post_init(), merge map
	operation for Isolation VM into hv_ringbuffer_init()
	* Call hv_ringbuffer_init() after __vmbus_establish_gpadl().
---
 drivers/hv/Kconfig       |  1 +
 drivers/hv/channel.c     | 19 +++++++-------
 drivers/hv/ring_buffer.c | 55 ++++++++++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index d1123ceb38f3..dd12af20e467 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -8,6 +8,7 @@ config HYPERV
 		|| (ARM64 && !CPU_BIG_ENDIAN))
 	select PARAVIRT
 	select X86_HV_CALLBACK_VECTOR if X86
+	select VMAP_PFN
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index b37ff4a39224..dc5c35210c16 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -683,15 +683,6 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	if (!newchannel->max_pkt_size)
 		newchannel->max_pkt_size = VMBUS_DEFAULT_MAX_PKT_SIZE;
 
-	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages, 0);
-	if (err)
-		goto error_clean_ring;
-
-	err = hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
-				 recv_pages, newchannel->max_pkt_size);
-	if (err)
-		goto error_clean_ring;
-
 	/* Establish the gpadl for the ring buffer */
 	newchannel->ringbuffer_gpadlhandle.gpadl_handle = 0;
 
@@ -703,6 +694,16 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	if (err)
 		goto error_clean_ring;
 
+	err = hv_ringbuffer_init(&newchannel->outbound,
+				 page, send_pages, 0);
+	if (err)
+		goto error_free_gpadl;
+
+	err = hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
+				 recv_pages, newchannel->max_pkt_size);
+	if (err)
+		goto error_free_gpadl;
+
 	/* Create and init the channel open message */
 	open_info = kzalloc(sizeof(*open_info) +
 			   sizeof(struct vmbus_channel_open_channel),
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 314015d9e912..931802ae985c 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -17,6 +17,8 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/prefetch.h>
+#include <linux/io.h>
+#include <asm/mshyperv.h>
 
 #include "hyperv_vmbus.h"
 
@@ -183,8 +185,10 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *channel)
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
 {
-	int i;
 	struct page **pages_wraparound;
+	unsigned long *pfns_wraparound;
+	u64 pfn;
+	int i;
 
 	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
 
@@ -192,23 +196,48 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	 * First page holds struct hv_ring_buffer, do wraparound mapping for
 	 * the rest.
 	 */
-	pages_wraparound = kcalloc(page_cnt * 2 - 1, sizeof(struct page *),
-				   GFP_KERNEL);
-	if (!pages_wraparound)
-		return -ENOMEM;
+	if (hv_isolation_type_snp()) {
+		pfn = page_to_pfn(pages) +
+			PFN_DOWN(ms_hyperv.shared_gpa_boundary);
+
+		pfns_wraparound = kcalloc(page_cnt * 2 - 1,
+			sizeof(unsigned long), GFP_KERNEL);
+		if (!pfns_wraparound)
+			return -ENOMEM;
+
+		pfns_wraparound[0] = pfn;
+		for (i = 0; i < 2 * (page_cnt - 1); i++)
+			pfns_wraparound[i + 1] = pfn + i % (page_cnt - 1) + 1;
 
-	pages_wraparound[0] = pages;
-	for (i = 0; i < 2 * (page_cnt - 1); i++)
-		pages_wraparound[i + 1] = &pages[i % (page_cnt - 1) + 1];
+		ring_info->ring_buffer = (struct hv_ring_buffer *)
+			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
+				 PAGE_KERNEL);
+		kfree(pfns_wraparound);
 
-	ring_info->ring_buffer = (struct hv_ring_buffer *)
-		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP, PAGE_KERNEL);
+		if (!ring_info->ring_buffer)
+			return -ENOMEM;
+
+		/* Zero ring buffer after setting memory host visibility. */
+		memset(ring_info->ring_buffer, 0x00, PAGE_SIZE * page_cnt);
+	} else {
+		pages_wraparound = kcalloc(page_cnt * 2 - 1,
+					   sizeof(struct page *),
+					   GFP_KERNEL);
+
+		pages_wraparound[0] = pages;
+		for (i = 0; i < 2 * (page_cnt - 1); i++)
+			pages_wraparound[i + 1] =
+				&pages[i % (page_cnt - 1) + 1];
 
-	kfree(pages_wraparound);
+		ring_info->ring_buffer = (struct hv_ring_buffer *)
+			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
+				PAGE_KERNEL);
 
+		kfree(pages_wraparound);
+		if (!ring_info->ring_buffer)
+			return -ENOMEM;
+	}
 
-	if (!ring_info->ring_buffer)
-		return -ENOMEM;
 
 	ring_info->ring_buffer->read_index =
 		ring_info->ring_buffer->write_index = 0;
-- 
2.25.1

