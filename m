Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C112D3BEAE2
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhGGPiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhGGPhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:37:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659FAC061574;
        Wed,  7 Jul 2021 08:35:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso3953562pjb.3;
        Wed, 07 Jul 2021 08:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+XJfA3AqCHkXuREWq5JYX1SJ1GS8dmwfVs7cs/uDyzo=;
        b=bui63f9RbeyQ+PjA944VL6eRYVLBMCTgOcLfL7xQd4MV+TGtlZkSCA8rNshpLHozV7
         EDzApfYSVdzgDBhHovaSMLT5NdnaVwtG4C1pbdo7Q08juYDuuI3z2tDDwrE3ko8nbycA
         bmcYDWSgYMR600u1g5+fy2uvqUffuDtVadjxcABOrsUHXRidIjPqqFGjuzQY8ChUFFp7
         IAXd5yOEalFiSg3IZmkvTq6kg0rbxMFNSKHHbwwuHqkbyN1eHbPo1jJaSMwX8vsUtnyr
         T2tqSkyBsX9X2+b02CuW2rweA2SgzcxtUt/E0fnHHNmW0W+cmQBpS8190Rui6bzRjt+3
         C71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+XJfA3AqCHkXuREWq5JYX1SJ1GS8dmwfVs7cs/uDyzo=;
        b=F2ZtGi1r3r1jCYWbIWTzF9dvrpoWErI3k5WHJAswJrukKE5I73PtopPwJzb0x/MEHK
         A+oeKsmSa0hILa4GyFmVZGYDnpif3P0F7qP3LbinzYgp5LxIBJaygl+ghLgQRqueDiJf
         94B+xgLrfHc1P6IxrbwTNSy1OLZ+GmjygtOEE5L8WaLX/fmEH0jq6G1K0mZgdpa0/8tB
         tWdT1POOIZhwI3UfcQs9FM6j18BSrHL9wuc/PsTS5ZrmGRT45PQQQxxObgcvjheugCUZ
         o7d6CZggXYoqTNssiKv23R0jwG1rkyLbJC6NRhxQ3y5ERBe13/TAQkhtXisNcIHoPRw8
         fvNg==
X-Gm-Message-State: AOAM532x9hFgOpkwp2NthwHViYBdSgqpT9mWoxrRVJTAsBKr5lrDwsBs
        nJb5+gYPPrED59/NPUrjal8=
X-Google-Smtp-Source: ABdhPJzfU3YRfZk3nkyd7QDC0TVwR1zYpPvF6PjFltyPDJmrt5nAGFOniT/ucBwrM64vLDEXGYARhg==
X-Received: by 2002:a17:902:c78a:b029:129:7777:18c6 with SMTP id w10-20020a170902c78ab0290129777718c6mr17383657pla.36.1625672111967;
        Wed, 07 Jul 2021 08:35:11 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:6b7f:cf3e:bbf2:d229])
        by smtp.gmail.com with ESMTPSA id y11sm21096877pfo.160.2021.07.07.08.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:35:11 -0700 (PDT)
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
Subject: [RFC PATCH V4 03/12] HV: Mark vmbus ring buffer visible to host in Isolation VM
Date:   Wed,  7 Jul 2021 11:34:44 -0400
Message-Id: <20210707153456.3976348-4-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707153456.3976348-1-ltykernel@gmail.com>
References: <20210707153456.3976348-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Mark vmbus ring buffer visible with set_memory_decrypted() when
establish gpadl handle.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/channel.c   | 38 ++++++++++++++++++++++++++++++++++++--
 include/linux/hyperv.h | 10 ++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index f3761c73b074..01048bb07082 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -17,6 +17,7 @@
 #include <linux/hyperv.h>
 #include <linux/uio.h>
 #include <linux/interrupt.h>
+#include <linux/set_memory.h>
 #include <asm/page.h>
 #include <asm/mshyperv.h>
 
@@ -465,7 +466,7 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	struct list_head *curr;
 	u32 next_gpadl_handle;
 	unsigned long flags;
-	int ret = 0;
+	int ret = 0, index;
 
 	next_gpadl_handle =
 		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
@@ -474,6 +475,13 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	if (ret)
 		return ret;
 
+	ret = set_memory_decrypted((unsigned long)kbuffer,
+				   HVPFN_UP(size));
+	if (ret) {
+		pr_warn("Failed to set host visibility.\n");
+		return ret;
+	}
+
 	init_completion(&msginfo->waitevent);
 	msginfo->waiting_channel = channel;
 
@@ -539,6 +547,15 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle = gpadlmsg->gpadl;
 
+	if (type == HV_GPADL_BUFFER)
+		index = 0;
+	else
+		index = channel->gpadl_range[1].gpadlhandle ? 2 : 1;
+
+	channel->gpadl_range[index].size = size;
+	channel->gpadl_range[index].buffer = kbuffer;
+	channel->gpadl_range[index].gpadlhandle = *gpadl_handle;
+
 cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
@@ -549,6 +566,11 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	}
 
 	kfree(msginfo);
+
+	if (ret)
+		set_memory_encrypted((unsigned long)kbuffer,
+				     HVPFN_UP(size));
+
 	return ret;
 }
 
@@ -811,7 +833,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
 	unsigned long flags;
-	int ret;
+	int ret, i;
 
 	info = kzalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
@@ -859,6 +881,18 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(info);
+
+	/* Find gpadl buffer virtual address and size. */
+	for (i = 0; i < VMBUS_GPADL_RANGE_COUNT; i++)
+		if (channel->gpadl_range[i].gpadlhandle == gpadl_handle)
+			break;
+
+	if (set_memory_encrypted((unsigned long)channel->gpadl_range[i].buffer,
+			HVPFN_UP(channel->gpadl_range[i].size)))
+		pr_warn("Fail to set mem host visibility.\n");
+
+	channel->gpadl_range[i].gpadlhandle = 0;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2e859d2f9609..06eccaba10c5 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -809,6 +809,14 @@ struct vmbus_device {
 
 #define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
 
+struct vmbus_gpadl_range {
+	u32 gpadlhandle;
+	u32 size;
+	void *buffer;
+};
+
+#define VMBUS_GPADL_RANGE_COUNT		3
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -829,6 +837,8 @@ struct vmbus_channel {
 	struct completion rescind_event;
 
 	u32 ringbuffer_gpadlhandle;
+	/* GPADL_RING and Send/Receive GPADL_BUFFER. */
+	struct vmbus_gpadl_range gpadl_range[VMBUS_GPADL_RANGE_COUNT];
 
 	/* Allocated memory for ring buffer */
 	struct page *ringbuffer_page;
-- 
2.25.1

