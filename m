Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BEC17B57D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 05:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCFE3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 23:29:00 -0500
Received: from mail-yw1-f49.google.com ([209.85.161.49]:44790 "EHLO
        mail-yw1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgCFE25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 23:28:57 -0500
Received: by mail-yw1-f49.google.com with SMTP id t141so1054549ywc.11
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 20:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cPx9b7g31UL87sIPFTXqcHoJpnS3MZvZXw5GBIQE91k=;
        b=btdO8ZVIgM9tY+vKPAJV3QWnfgdxXWWH0DtUplAWzOD0GpqxigMLwpYkXIV8pT4Oqm
         D+JNykGrNYKDNuNbc9ts7zxCMbGA/dh+yR1BGOOx6NHMIW9Zlc7gPOX2s6WmTuzB9U/m
         o2UlIQ0He4qDlntL5k7bXtKURsCgEwBSyk+g2B3bOyK58hmnQN5leGlMwnQFFrEwQzed
         xlCKsFIthtA29AVrt6tRbVuUKgEIGV3bB3rfAaKyI7q1rCKvDhZisk2g06SVpd4UM0Jh
         MBBezEDYv2yho0/FhWNpQW1elV1TDqa+sgWNOaKW+i7WbdR7DkwKtulUAF50XL0Cwt6z
         vYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cPx9b7g31UL87sIPFTXqcHoJpnS3MZvZXw5GBIQE91k=;
        b=SaVNO6L8MxfU27PYAI/C0BI3SeMtM+5dGWWywakAXQEZNl4wBUg97vTSfUuFcGyjRc
         Rw5hy7FijHH3fRavO3LXGm8+cGn6vNSBRS3hVImWkLmp5A0GH4fixKff/UXv/3CxhK8+
         Nd4ZCqCeUZRhcVpt1pA30zPacwFdNQ/0/KAF5aBsZY/1iVP/iTUNZq8SrUjrd1ZMF9oW
         6abfzuXPdUcbiE6v6WsudFY0itaG5c/ixkWi+REarbCeRqEzj/WMFvdY9mZQSLinblXV
         in4NHOzN4fObIFkRrZvc3O0IBCL5ReUs+n3S3IF083WpqF8ZMoHDEekNFQNNLxeGr6MH
         8psA==
X-Gm-Message-State: ANhLgQ1Y9/IftTZaNhqOq/VXq1klR6VUxN2Uoy0SPstjOZkqWoQqEA80
        r/yAGrUA9WT2xb46wSGMSud1zOgR090=
X-Google-Smtp-Source: ADFU+vtYAG7qB/A7y+ybqoaMjkk6dBwB/Q0WbF7jnCoD1sipjUHX3UOd0iXmG4nehMpPhK3gmN4pJQ==
X-Received: by 2002:a25:bd0a:: with SMTP id f10mr1894998ybk.173.1583468934222;
        Thu, 05 Mar 2020 20:28:54 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm12581836ywa.32.2020.03.05.20.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 20:28:53 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/17] soc: qcom: ipa: GSI transactions
Date:   Thu,  5 Mar 2020 22:28:23 -0600
Message-Id: <20200306042831.17827-10-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
References: <20200306042831.17827-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements GSI transactions.  A GSI transaction is a
structure that represents a single request (consisting of one or
more TREs) sent to the GSI hardware.  The last TRE in a transaction
includes a flag requesting that the GSI interrupt the AP to notify
that it has completed.

TREs are executed and completed strictly in order.  For this reason,
the completion of a single TRE implies that all previous TREs (in
particular all of those "earlier" in a transaction) have completed.

Whenever there is a need to send a request (a set of TREs) to the
IPA, a GSI transaction is allocated, specifying the number of TREs
that will be required.  Details of the request (e.g. transfer offsets
and length) are represented by in a Linux scatterlist array that is
incorporated in the transaction structure.

Once all commands (TREs) are added to a transaction it is committed.
When the hardware signals that the request has completed, a callback
function allows for cleanup or followup activity to be performed
before the transaction is freed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 786 ++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/gsi_trans.h | 226 +++++++++++
 2 files changed, 1012 insertions(+)
 create mode 100644 drivers/net/ipa/gsi_trans.c
 create mode 100644 drivers/net/ipa/gsi_trans.h

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
new file mode 100644
index 000000000000..2fd21d75367d
--- /dev/null
+++ b/drivers/net/ipa/gsi_trans.c
@@ -0,0 +1,786 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/bits.h>
+#include <linux/bitfield.h>
+#include <linux/refcount.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-direction.h>
+
+#include "gsi.h"
+#include "gsi_private.h"
+#include "gsi_trans.h"
+#include "ipa_gsi.h"
+#include "ipa_data.h"
+#include "ipa_cmd.h"
+
+/**
+ * DOC: GSI Transactions
+ *
+ * A GSI transaction abstracts the behavior of a GSI channel by representing
+ * everything about a related group of IPA commands in a single structure.
+ * (A "command" in this sense is either a data transfer or an IPA immediate
+ * command.)  Most details of interaction with the GSI hardware are managed
+ * by the GSI transaction core, allowing users to simply describe commands
+ * to be performed.  When a transaction has completed a callback function
+ * (dependent on the type of endpoint associated with the channel) allows
+ * cleanup of resources associated with the transaction.
+ *
+ * To perform a command (or set of them), a user of the GSI transaction
+ * interface allocates a transaction, indicating the number of TREs required
+ * (one per command).  If sufficient TREs are available, they are reserved
+ * for use in the transaction and the allocation succeeds.  This way
+ * exhaustion of the available TREs in a channel ring is detected
+ * as early as possible.  All resources required to complete a transaction
+ * are allocated at transaction allocation time.
+ *
+ * Commands performed as part of a transaction are represented in an array
+ * of Linux scatterlist structures.  This array is allocated with the
+ * transaction, and its entries are initialized using standard scatterlist
+ * functions (such as sg_set_buf() or skb_to_sgvec()).
+ *
+ * Once a transaction's scatterlist structures have been initialized, the
+ * transaction is committed.  The caller is responsible for mapping buffers
+ * for DMA if necessary, and this should be done *before* allocating
+ * the transaction.  Between a successful allocation and commit of a
+ * transaction no errors should occur.
+ *
+ * Committing transfers ownership of the entire transaction to the GSI
+ * transaction core.  The GSI transaction code formats the content of
+ * the scatterlist array into the channel ring buffer and informs the
+ * hardware that new TREs are available to process.
+ *
+ * The last TRE in each transaction is marked to interrupt the AP when the
+ * GSI hardware has completed it.  Because transfers described by TREs are
+ * performed strictly in order, signaling the completion of just the last
+ * TRE in the transaction is sufficient to indicate the full transaction
+ * is complete.
+ *
+ * When a transaction is complete, ipa_gsi_trans_complete() is called by the
+ * GSI code into the IPA layer, allowing it to perform any final cleanup
+ * required before the transaction is freed.
+ */
+
+/* Hardware values representing a transfer element type */
+enum gsi_tre_type {
+	GSI_RE_XFER	= 0x2,
+	GSI_RE_IMMD_CMD	= 0x3,
+};
+
+/* An entry in a channel ring */
+struct gsi_tre {
+	__le64 addr;		/* DMA address */
+	__le16 len_opcode;	/* length in bytes or enum IPA_CMD_* */
+	__le16 reserved;
+	__le32 flags;		/* TRE_FLAGS_* */
+};
+
+/* gsi_tre->flags mask values (in CPU byte order) */
+#define TRE_FLAGS_CHAIN_FMASK	GENMASK(0, 0)
+#define TRE_FLAGS_IEOB_FMASK	GENMASK(8, 8)
+#define TRE_FLAGS_IEOT_FMASK	GENMASK(9, 9)
+#define TRE_FLAGS_BEI_FMASK	GENMASK(10, 10)
+#define TRE_FLAGS_TYPE_FMASK	GENMASK(23, 16)
+
+int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
+			u32 max_alloc)
+{
+	void *virt;
+
+#ifdef IPA_VALIDATE
+	if (!size || size % 8)
+		return -EINVAL;
+	if (count < max_alloc)
+		return -EINVAL;
+	if (!max_alloc)
+		return -EINVAL;
+#endif /* IPA_VALIDATE */
+
+	/* By allocating a few extra entries in our pool (one less
+	 * than the maximum number that will be requested in a
+	 * single allocation), we can always satisfy requests without
+	 * ever worrying about straddling the end of the pool array.
+	 * If there aren't enough entries starting at the free index,
+	 * we just allocate free entries from the beginning of the pool.
+	 */
+	virt = kcalloc(count + max_alloc - 1, size, GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+
+	pool->base = virt;
+	/* If the allocator gave us any extra memory, use it */
+	pool->count = ksize(pool->base) / size;
+	pool->free = 0;
+	pool->max_alloc = max_alloc;
+	pool->size = size;
+	pool->addr = 0;		/* Only used for DMA pools */
+
+	return 0;
+}
+
+void gsi_trans_pool_exit(struct gsi_trans_pool *pool)
+{
+	kfree(pool->base);
+	memset(pool, 0, sizeof(*pool));
+}
+
+/* Allocate the requested number of (zeroed) entries from the pool */
+/* Home-grown DMA pool.  This way we can preallocate and use the tre_count
+ * to guarantee allocations will succeed.  Even though we specify max_alloc
+ * (and it can be more than one), we only allow allocation of a single
+ * element from a DMA pool.
+ */
+int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
+			    size_t size, u32 count, u32 max_alloc)
+{
+	size_t total_size;
+	dma_addr_t addr;
+	void *virt;
+
+#ifdef IPA_VALIDATE
+	if (!size || size % 8)
+		return -EINVAL;
+	if (count < max_alloc)
+		return -EINVAL;
+	if (!max_alloc)
+		return -EINVAL;
+#endif /* IPA_VALIDATE */
+
+	/* Don't let allocations cross a power-of-two boundary */
+	size = __roundup_pow_of_two(size);
+	total_size = (count + max_alloc - 1) * size;
+
+	/* The allocator will give us a power-of-2 number of pages.  But we
+	 * can't guarantee that, so request it.  That way we won't waste any
+	 * memory that would be available beyond the required space.
+	 */
+	total_size = get_order(total_size) << PAGE_SHIFT;
+
+	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+
+	pool->base = virt;
+	pool->count = total_size / size;
+	pool->free = 0;
+	pool->size = size;
+	pool->max_alloc = max_alloc;
+	pool->addr = addr;
+
+	return 0;
+}
+
+void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool)
+{
+	dma_free_coherent(dev, pool->size, pool->base, pool->addr);
+	memset(pool, 0, sizeof(*pool));
+}
+
+/* Return the byte offset of the next free entry in the pool */
+static u32 gsi_trans_pool_alloc_common(struct gsi_trans_pool *pool, u32 count)
+{
+	u32 offset;
+
+	/* assert(count > 0); */
+	/* assert(count <= pool->max_alloc); */
+
+	/* Allocate from beginning if wrap would occur */
+	if (count > pool->count - pool->free)
+		pool->free = 0;
+
+	offset = pool->free * pool->size;
+	pool->free += count;
+	memset(pool->base + offset, 0, count * pool->size);
+
+	return offset;
+}
+
+/* Allocate a contiguous block of zeroed entries from a pool */
+void *gsi_trans_pool_alloc(struct gsi_trans_pool *pool, u32 count)
+{
+	return pool->base + gsi_trans_pool_alloc_common(pool, count);
+}
+
+/* Allocate a single zeroed entry from a DMA pool */
+void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr)
+{
+	u32 offset = gsi_trans_pool_alloc_common(pool, 1);
+
+	*addr = pool->addr + offset;
+
+	return pool->base + offset;
+}
+
+/* Return the pool element that immediately follows the one given.
+ * This only works done if elements are allocated one at a time.
+ */
+void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element)
+{
+	void *end = pool->base + pool->count * pool->size;
+
+	/* assert(element >= pool->base); */
+	/* assert(element < end); */
+	/* assert(pool->max_alloc == 1); */
+	element += pool->size;
+
+	return element < end ? element : pool->base;
+}
+
+/* Map a given ring entry index to the transaction associated with it */
+static void gsi_channel_trans_map(struct gsi_channel *channel, u32 index,
+				  struct gsi_trans *trans)
+{
+	/* Note: index *must* be used modulo the ring count here */
+	channel->trans_info.map[index % channel->tre_ring.count] = trans;
+}
+
+/* Return the transaction mapped to a given ring entry */
+struct gsi_trans *
+gsi_channel_trans_mapped(struct gsi_channel *channel, u32 index)
+{
+	/* Note: index *must* be used modulo the ring count here */
+	return channel->trans_info.map[index % channel->tre_ring.count];
+}
+
+/* Return the oldest completed transaction for a channel (or null) */
+struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel)
+{
+	return list_first_entry_or_null(&channel->trans_info.complete,
+					struct gsi_trans, links);
+}
+
+/* Move a transaction from the allocated list to the pending list */
+static void gsi_trans_move_pending(struct gsi_trans *trans)
+{
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	list_move_tail(&trans->links, &trans_info->pending);
+
+	spin_unlock_bh(&trans_info->spinlock);
+}
+
+/* Move a transaction and all of its predecessors from the pending list
+ * to the completed list.
+ */
+void gsi_trans_move_complete(struct gsi_trans *trans)
+{
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct list_head list;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	/* Move this transaction and all predecessors to completed list */
+	list_cut_position(&list, &trans_info->pending, &trans->links);
+	list_splice_tail(&list, &trans_info->complete);
+
+	spin_unlock_bh(&trans_info->spinlock);
+}
+
+/* Move a transaction from the completed list to the polled list */
+void gsi_trans_move_polled(struct gsi_trans *trans)
+{
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	list_move_tail(&trans->links, &trans_info->polled);
+
+	spin_unlock_bh(&trans_info->spinlock);
+}
+
+/* Reserve some number of TREs on a channel.  Returns true if successful */
+static bool
+gsi_trans_tre_reserve(struct gsi_trans_info *trans_info, u32 tre_count)
+{
+	int avail = atomic_read(&trans_info->tre_avail);
+	int new;
+
+	do {
+		new = avail - (int)tre_count;
+		if (unlikely(new < 0))
+			return false;
+	} while (!atomic_try_cmpxchg(&trans_info->tre_avail, &avail, new));
+
+	return true;
+}
+
+/* Release previously-reserved TRE entries to a channel */
+static void
+gsi_trans_tre_release(struct gsi_trans_info *trans_info, u32 tre_count)
+{
+	atomic_add(tre_count, &trans_info->tre_avail);
+}
+
+/* Allocate a GSI transaction on a channel */
+struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
+					  u32 tre_count,
+					  enum dma_data_direction direction)
+{
+	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct gsi_trans_info *trans_info;
+	struct gsi_trans *trans;
+
+	/* assert(tre_count <= gsi_channel_trans_tre_max(gsi, channel_id)); */
+
+	trans_info = &channel->trans_info;
+
+	/* We reserve the TREs now, but consume them at commit time.
+	 * If there aren't enough available, we're done.
+	 */
+	if (!gsi_trans_tre_reserve(trans_info, tre_count))
+		return NULL;
+
+	/* Allocate and initialize non-zero fields in the the transaction */
+	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
+	trans->gsi = gsi;
+	trans->channel_id = channel_id;
+	trans->tre_count = tre_count;
+	init_completion(&trans->completion);
+
+	/* Allocate the scatterlist and (if requested) info entries. */
+	trans->sgl = gsi_trans_pool_alloc(&trans_info->sg_pool, tre_count);
+	sg_init_marker(trans->sgl, tre_count);
+
+	trans->direction = direction;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	list_add_tail(&trans->links, &trans_info->alloc);
+
+	spin_unlock_bh(&trans_info->spinlock);
+
+	refcount_set(&trans->refcount, 1);
+
+	return trans;
+}
+
+/* Free a previously-allocated transaction (used only in case of error) */
+void gsi_trans_free(struct gsi_trans *trans)
+{
+	struct gsi_trans_info *trans_info;
+
+	if (!refcount_dec_and_test(&trans->refcount))
+		return;
+
+	trans_info = &trans->gsi->channel[trans->channel_id].trans_info;
+
+	spin_lock_bh(&trans_info->spinlock);
+
+	list_del(&trans->links);
+
+	spin_unlock_bh(&trans_info->spinlock);
+
+	ipa_gsi_trans_release(trans);
+
+	/* Releasing the reserved TREs implicitly frees the sgl[] and
+	 * (if present) info[] arrays, plus the transaction itself.
+	 */
+	gsi_trans_tre_release(trans_info, trans->tre_count);
+}
+
+/* Add an immediate command to a transaction */
+void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
+		       dma_addr_t addr, enum dma_data_direction direction,
+		       enum ipa_cmd_opcode opcode)
+{
+	struct ipa_cmd_info *info;
+	u32 which = trans->used++;
+	struct scatterlist *sg;
+
+	/* assert(which < trans->tre_count); */
+
+	/* Set the page information for the buffer.  We also need to fill in
+	 * the DMA address for the buffer (something dma_map_sg() normally
+	 * does).
+	 */
+	sg = &trans->sgl[which];
+
+	sg_set_buf(sg, buf, size);
+	sg_dma_address(sg) = addr;
+
+	info = &trans->info[which];
+	info->opcode = opcode;
+	info->direction = direction;
+}
+
+/* Add a page transfer to a transaction.  It will fill the only TRE. */
+int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
+		       u32 offset)
+{
+	struct scatterlist *sg = &trans->sgl[0];
+	int ret;
+
+	/* assert(trans->tre_count == 1); */
+	/* assert(!trans->used); */
+
+	sg_set_page(sg, page, size, offset);
+	ret = dma_map_sg(trans->gsi->dev, sg, 1, trans->direction);
+	if (!ret)
+		return -ENOMEM;
+
+	trans->used++;	/* Transaction now owns the (DMA mapped) page */
+
+	return 0;
+}
+
+/* Add an SKB transfer to a transaction.  No other TREs will be used. */
+int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb)
+{
+	struct scatterlist *sg = &trans->sgl[0];
+	u32 used;
+	int ret;
+
+	/* assert(trans->tre_count == 1); */
+	/* assert(!trans->used); */
+
+	/* skb->len will not be 0 (checked early) */
+	ret = skb_to_sgvec(skb, sg, 0, skb->len);
+	if (ret < 0)
+		return ret;
+	used = ret;
+
+	ret = dma_map_sg(trans->gsi->dev, sg, used, trans->direction);
+	if (!ret)
+		return -ENOMEM;
+
+	trans->used += used;	/* Transaction now owns the (DMA mapped) skb */
+
+	return 0;
+}
+
+/* Compute the length/opcode value to use for a TRE */
+static __le16 gsi_tre_len_opcode(enum ipa_cmd_opcode opcode, u32 len)
+{
+	return opcode == IPA_CMD_NONE ? cpu_to_le16((u16)len)
+				      : cpu_to_le16((u16)opcode);
+}
+
+/* Compute the flags value to use for a given TRE */
+static __le32 gsi_tre_flags(bool last_tre, bool bei, enum ipa_cmd_opcode opcode)
+{
+	enum gsi_tre_type tre_type;
+	u32 tre_flags;
+
+	tre_type = opcode == IPA_CMD_NONE ? GSI_RE_XFER : GSI_RE_IMMD_CMD;
+	tre_flags = u32_encode_bits(tre_type, TRE_FLAGS_TYPE_FMASK);
+
+	/* Last TRE contains interrupt flags */
+	if (last_tre) {
+		/* All transactions end in a transfer completion interrupt */
+		tre_flags |= TRE_FLAGS_IEOT_FMASK;
+		/* Don't interrupt when outbound commands are acknowledged */
+		if (bei)
+			tre_flags |= TRE_FLAGS_BEI_FMASK;
+	} else {	/* All others indicate there's more to come */
+		tre_flags |= TRE_FLAGS_CHAIN_FMASK;
+	}
+
+	return cpu_to_le32(tre_flags);
+}
+
+static void gsi_trans_tre_fill(struct gsi_tre *dest_tre, dma_addr_t addr,
+			       u32 len, bool last_tre, bool bei,
+			       enum ipa_cmd_opcode opcode)
+{
+	struct gsi_tre tre;
+
+	tre.addr = cpu_to_le64(addr);
+	tre.len_opcode = gsi_tre_len_opcode(opcode, len);
+	tre.reserved = 0;
+	tre.flags = gsi_tre_flags(last_tre, bei, opcode);
+
+	/* ARM64 can write 16 bytes as a unit with a single instruction.
+	 * Doing the assignment this way is an attempt to make that happen.
+	 */
+	*dest_tre = tre;
+}
+
+/**
+ * __gsi_trans_commit() - Common GSI transaction commit code
+ * @trans:	Transaction to commit
+ * @ring_db:	Whether to tell the hardware about these queued transfers
+ *
+ * Formats channel ring TRE entries based on the content of the scatterlist.
+ * Maps a transaction pointer to the last ring entry used for the transaction,
+ * so it can be recovered when it completes.  Moves the transaction to the
+ * pending list.  Finally, updates the channel ring pointer and optionally
+ * rings the doorbell.
+ */
+static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
+{
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+	struct gsi_ring *ring = &channel->tre_ring;
+	enum ipa_cmd_opcode opcode = IPA_CMD_NONE;
+	bool bei = channel->toward_ipa;
+	struct ipa_cmd_info *info;
+	struct gsi_tre *dest_tre;
+	struct scatterlist *sg;
+	u32 byte_count = 0;
+	u32 avail;
+	u32 i;
+
+	/* assert(trans->used > 0); */
+
+	/* Consume the entries.  If we cross the end of the ring while
+	 * filling them we'll switch to the beginning to finish.
+	 * If there is no info array we're doing a simple data
+	 * transfer request, whose opcode is IPA_CMD_NONE.
+	 */
+	info = trans->info ? &trans->info[0] : NULL;
+	avail = ring->count - ring->index % ring->count;
+	dest_tre = gsi_ring_virt(ring, ring->index);
+	for_each_sg(trans->sgl, sg, trans->used, i) {
+		bool last_tre = i == trans->used - 1;
+		dma_addr_t addr = sg_dma_address(sg);
+		u32 len = sg_dma_len(sg);
+
+		byte_count += len;
+		if (!avail--)
+			dest_tre = gsi_ring_virt(ring, 0);
+		if (info)
+			opcode = info++->opcode;
+
+		gsi_trans_tre_fill(dest_tre, addr, len, last_tre, bei, opcode);
+		dest_tre++;
+	}
+	ring->index += trans->used;
+
+	if (channel->toward_ipa) {
+		/* We record TX bytes when they are sent */
+		trans->len = byte_count;
+		trans->trans_count = channel->trans_count;
+		trans->byte_count = channel->byte_count;
+		channel->trans_count++;
+		channel->byte_count += byte_count;
+	}
+
+	/* Associate the last TRE with the transaction */
+	gsi_channel_trans_map(channel, ring->index - 1, trans);
+
+	gsi_trans_move_pending(trans);
+
+	/* Ring doorbell if requested, or if all TREs are allocated */
+	if (ring_db || !atomic_read(&channel->trans_info.tre_avail)) {
+		/* Report what we're handing off to hardware for TX channels */
+		if (channel->toward_ipa)
+			gsi_channel_tx_queued(channel);
+		gsi_channel_doorbell(channel);
+	}
+}
+
+/* Commit a GSI transaction */
+void gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
+{
+	if (trans->used)
+		__gsi_trans_commit(trans, ring_db);
+	else
+		gsi_trans_free(trans);
+}
+
+/* Commit a GSI transaction and wait for it to complete */
+void gsi_trans_commit_wait(struct gsi_trans *trans)
+{
+	if (!trans->used)
+		goto out_trans_free;
+
+	refcount_inc(&trans->refcount);
+
+	__gsi_trans_commit(trans, true);
+
+	wait_for_completion(&trans->completion);
+
+out_trans_free:
+	gsi_trans_free(trans);
+}
+
+/* Commit a GSI transaction and wait for it to complete, with timeout */
+int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
+				  unsigned long timeout)
+{
+	unsigned long timeout_jiffies = msecs_to_jiffies(timeout);
+	unsigned long remaining = 1;	/* In case of empty transaction */
+
+	if (!trans->used)
+		goto out_trans_free;
+
+	refcount_inc(&trans->refcount);
+
+	__gsi_trans_commit(trans, true);
+
+	remaining = wait_for_completion_timeout(&trans->completion,
+						timeout_jiffies);
+out_trans_free:
+	gsi_trans_free(trans);
+
+	return remaining ? 0 : -ETIMEDOUT;
+}
+
+/* Process the completion of a transaction; called while polling */
+void gsi_trans_complete(struct gsi_trans *trans)
+{
+	/* If the entire SGL was mapped when added, unmap it now */
+	if (trans->direction != DMA_NONE)
+		dma_unmap_sg(trans->gsi->dev, trans->sgl, trans->used,
+			     trans->direction);
+
+	ipa_gsi_trans_complete(trans);
+
+	complete(&trans->completion);
+
+	gsi_trans_free(trans);
+}
+
+/* Cancel a channel's pending transactions */
+void gsi_channel_trans_cancel_pending(struct gsi_channel *channel)
+{
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct gsi_trans *trans;
+	bool cancelled;
+
+	/* channel->gsi->mutex is held by caller */
+	spin_lock_bh(&trans_info->spinlock);
+
+	cancelled = !list_empty(&trans_info->pending);
+	list_for_each_entry(trans, &trans_info->pending, links)
+		trans->cancelled = true;
+
+	list_splice_tail_init(&trans_info->pending, &trans_info->complete);
+
+	spin_unlock_bh(&trans_info->spinlock);
+
+	/* Schedule NAPI polling to complete the cancelled transactions */
+	if (cancelled)
+		napi_schedule(&channel->napi);
+}
+
+/* Issue a command to read a single byte from a channel */
+int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
+{
+	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct gsi_ring *ring = &channel->tre_ring;
+	struct gsi_trans_info *trans_info;
+	struct gsi_tre *dest_tre;
+
+	trans_info = &channel->trans_info;
+
+	/* First reserve the TRE, if possible */
+	if (!gsi_trans_tre_reserve(trans_info, 1))
+		return -EBUSY;
+
+	/* Now fill the the reserved TRE and tell the hardware */
+
+	dest_tre = gsi_ring_virt(ring, ring->index);
+	gsi_trans_tre_fill(dest_tre, addr, 1, true, false, IPA_CMD_NONE);
+
+	ring->index++;
+	gsi_channel_doorbell(channel);
+
+	return 0;
+}
+
+/* Mark a gsi_trans_read_byte() request done */
+void gsi_trans_read_byte_done(struct gsi *gsi, u32 channel_id)
+{
+	struct gsi_channel *channel = &gsi->channel[channel_id];
+
+	gsi_trans_tre_release(&channel->trans_info, 1);
+}
+
+/* Initialize a channel's GSI transaction info */
+int gsi_channel_trans_init(struct gsi *gsi, u32 channel_id)
+{
+	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct gsi_trans_info *trans_info;
+	u32 tre_max;
+	int ret;
+
+	/* Ensure the size of a channel element is what's expected */
+	BUILD_BUG_ON(sizeof(struct gsi_tre) != GSI_RING_ELEMENT_SIZE);
+
+	/* The map array is used to determine what transaction is associated
+	 * with a TRE that the hardware reports has completed.  We need one
+	 * map entry per TRE.
+	 */
+	trans_info = &channel->trans_info;
+	trans_info->map = kcalloc(channel->tre_count, sizeof(*trans_info->map),
+				  GFP_KERNEL);
+	if (!trans_info->map)
+		return -ENOMEM;
+
+	/* We can't use more TREs than there are available in the ring.
+	 * This limits the number of transactions that can be oustanding.
+	 * Worst case is one TRE per transaction (but we actually limit
+	 * it to something a little less than that).  We allocate resources
+	 * for transactions (including transaction structures) based on
+	 * this maximum number.
+	 */
+	tre_max = gsi_channel_tre_max(channel->gsi, channel_id);
+
+	/* Transactions are allocated one at a time. */
+	ret = gsi_trans_pool_init(&trans_info->pool, sizeof(struct gsi_trans),
+				  tre_max, 1);
+	if (ret)
+		goto err_kfree;
+
+	/* A transaction uses a scatterlist array to represent the data
+	 * transfers implemented by the transaction.  Each scatterlist
+	 * element is used to fill a single TRE when the transaction is
+	 * committed.  So we need as many scatterlist elements as the
+	 * maximum number of TREs that can be outstanding.
+	 *
+	 * All TREs in a transaction must fit within the channel's TLV FIFO.
+	 * A transaction on a channel can allocate as many TREs as that but
+	 * no more.
+	 */
+	ret = gsi_trans_pool_init(&trans_info->sg_pool,
+				  sizeof(struct scatterlist),
+				  tre_max, channel->tlv_count);
+	if (ret)
+		goto err_trans_pool_exit;
+
+	/* Finally, the tre_avail field is what ultimately limits the number
+	 * of outstanding transactions and their resources.  A transaction
+	 * allocation succeeds only if the TREs available are sufficient for
+	 * what the transaction might need.  Transaction resource pools are
+	 * sized based on the maximum number of outstanding TREs, so there
+	 * will always be resources available if there are TREs available.
+	 */
+	atomic_set(&trans_info->tre_avail, tre_max);
+
+	spin_lock_init(&trans_info->spinlock);
+	INIT_LIST_HEAD(&trans_info->alloc);
+	INIT_LIST_HEAD(&trans_info->pending);
+	INIT_LIST_HEAD(&trans_info->complete);
+	INIT_LIST_HEAD(&trans_info->polled);
+
+	return 0;
+
+err_trans_pool_exit:
+	gsi_trans_pool_exit(&trans_info->pool);
+err_kfree:
+	kfree(trans_info->map);
+
+	dev_err(gsi->dev, "error %d initializing channel %u transactions\n",
+		ret, channel_id);
+
+	return ret;
+}
+
+/* Inverse of gsi_channel_trans_init() */
+void gsi_channel_trans_exit(struct gsi_channel *channel)
+{
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+
+	gsi_trans_pool_exit(&trans_info->sg_pool);
+	gsi_trans_pool_exit(&trans_info->pool);
+	kfree(trans_info->map);
+}
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
new file mode 100644
index 000000000000..1477fc15b30a
--- /dev/null
+++ b/drivers/net/ipa/gsi_trans.h
@@ -0,0 +1,226 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+#ifndef _GSI_TRANS_H_
+#define _GSI_TRANS_H_
+
+#include <linux/types.h>
+#include <linux/refcount.h>
+#include <linux/completion.h>
+#include <linux/dma-direction.h>
+
+#include "ipa_cmd.h"
+
+struct scatterlist;
+struct device;
+struct sk_buff;
+
+struct gsi;
+struct gsi_trans;
+struct gsi_trans_pool;
+
+/**
+ * struct gsi_trans - a GSI transaction
+ *
+ * Most fields in this structure for internal use by the transaction core code:
+ * @links:	Links for channel transaction lists by state
+ * @gsi:	GSI pointer
+ * @channel_id: Channel number transaction is associated with
+ * @cancelled:	If set by the core code, transaction was cancelled
+ * @tre_count:	Number of TREs reserved for this transaction
+ * @used:	Number of TREs *used* (could be less than tre_count)
+ * @len:	Total # of transfer bytes represented in sgl[] (set by core)
+ * @data:	Preserved but not touched by the core transaction code
+ * @sgl:	An array of scatter/gather entries managed by core code
+ * @info:	Array of command information structures (command channel)
+ * @direction:	DMA transfer direction (DMA_NONE for commands)
+ * @refcount:	Reference count used for destruction
+ * @completion:	Completed when the transaction completes
+ * @byte_count:	TX channel byte count recorded when transaction committed
+ * @trans_count: Channel transaction count when committed (for BQL accounting)
+ *
+ * The size used for some fields in this structure were chosen to ensure
+ * the full structure size is no larger than 128 bytes.
+ */
+struct gsi_trans {
+	struct list_head links;		/* gsi_channel lists */
+
+	struct gsi *gsi;
+	u8 channel_id;
+
+	bool cancelled;			/* true if transaction was cancelled */
+
+	u8 tre_count;			/* # TREs requested */
+	u8 used;			/* # entries used in sgl[] */
+	u32 len;			/* total # bytes across sgl[] */
+
+	void *data;
+	struct scatterlist *sgl;
+	struct ipa_cmd_info *info;	/* array of entries, or null */
+	enum dma_data_direction direction;
+
+	refcount_t refcount;
+	struct completion completion;
+
+	u64 byte_count;			/* channel byte_count when committed */
+	u64 trans_count;		/* channel trans_count when committed */
+};
+
+/**
+ * gsi_trans_pool_init() - Initialize a pool of structures for transactions
+ * @gsi:	GSI pointer
+ * @size:	Size of elements in the pool
+ * @count:	Minimum number of elements in the pool
+ * @max_alloc:	Maximum number of elements allocated at a time from pool
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
+			u32 max_alloc);
+
+/**
+ * gsi_trans_pool_alloc() - Allocate one or more elements from a pool
+ * @pool:	Pool pointer
+ * @count:	Number of elements to allocate from the pool
+ *
+ * @Return:	Virtual address of element(s) allocated from the pool
+ */
+void *gsi_trans_pool_alloc(struct gsi_trans_pool *pool, u32 count);
+
+/**
+ * gsi_trans_pool_exit() - Inverse of gsi_trans_pool_init()
+ * @pool:	Pool pointer
+ */
+void gsi_trans_pool_exit(struct gsi_trans_pool *pool);
+
+/**
+ * gsi_trans_pool_init_dma() - Initialize a pool of DMA-able structures
+ * @dev:	Device used for DMA
+ * @pool:	Pool pointer
+ * @size:	Size of elements in the pool
+ * @count:	Minimum number of elements in the pool
+ * @max_alloc:	Maximum number of elements allocated at a time from pool
+ *
+ * @Return:	0 if successful, or a negative error code
+ *
+ * Structures in this pool reside in DMA-coherent memory.
+ */
+int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
+			    size_t size, u32 count, u32 max_alloc);
+
+/**
+ * gsi_trans_pool_alloc_dma() - Allocate an element from a DMA pool
+ * @pool:	DMA pool pointer
+ * @addr:	DMA address "handle" associated with the allocation
+ *
+ * @Return:	Virtual address of element allocated from the pool
+ *
+ * Only one element at a time may be allocated from a DMA pool.
+ */
+void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr);
+
+/**
+ * gsi_trans_pool_exit() - Inverse of gsi_trans_pool_init()
+ * @pool:	Pool pointer
+ */
+void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool);
+
+/**
+ * gsi_channel_trans_alloc() - Allocate a GSI transaction on a channel
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel the transaction is associated with
+ * @tre_count:	Number of elements in the transaction
+ * @direction:	DMA direction for entire SGL (or DMA_NONE)
+ *
+ * @Return:	A GSI transaction structure, or a null pointer if all
+ *		available transactions are in use
+ */
+struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
+					  u32 tre_count,
+					  enum dma_data_direction direction);
+
+/**
+ * gsi_trans_free() - Free a previously-allocated GSI transaction
+ * @trans:	Transaction to be freed
+ */
+void gsi_trans_free(struct gsi_trans *trans);
+
+/**
+ * gsi_trans_cmd_add() - Add an immediate command to a transaction
+ * @trans:	Transaction
+ * @buf:	Buffer pointer for command payload
+ * @size:	Number of bytes in buffer
+ * @addr:	DMA address for payload
+ * @direction:	Direction of DMA transfer (or DMA_NONE if none required)
+ * @opcode:	IPA immediate command opcode
+ */
+void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
+		       dma_addr_t addr, enum dma_data_direction direction,
+		       enum ipa_cmd_opcode opcode);
+
+/**
+ * gsi_trans_page_add() - Add a page transfer to a transaction
+ * @trans:	Transaction
+ * @page:	Page pointer
+ * @size:	Number of bytes (starting at offset) to transfer
+ * @offset:	Offset within page for start of transfer
+ */
+int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
+		       u32 offset);
+
+/**
+ * gsi_trans_skb_add() - Add a socket transfer to a transaction
+ * @trans:	Transaction
+ * @skb:	Socket buffer for transfer (outbound)
+ *
+ * @Return:	0, or -EMSGSIZE if socket data won't fit in transaction.
+ */
+int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb);
+
+/**
+ * gsi_trans_commit() - Commit a GSI transaction
+ * @trans:	Transaction to commit
+ * @ring_db:	Whether to tell the hardware about these queued transfers
+ */
+void gsi_trans_commit(struct gsi_trans *trans, bool ring_db);
+
+/**
+ * gsi_trans_commit_wait() - Commit a GSI transaction and wait for it
+ *			     to complete
+ * @trans:	Transaction to commit
+ */
+void gsi_trans_commit_wait(struct gsi_trans *trans);
+
+/**
+ * gsi_trans_commit_wait_timeout() - Commit a GSI transaction and wait for
+ *				     it to complete, with timeout
+ * @trans:	Transaction to commit
+ * @timeout:	Timeout period (in milliseconds)
+ */
+int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
+				  unsigned long timeout);
+
+/**
+ * gsi_trans_read_byte() - Issue a single byte read TRE on a channel
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel on which to read a byte
+ * @addr:	DMA address into which to transfer the one byte
+ *
+ * This is not a transaction operation at all.  It's defined here because
+ * it needs to be done in coordination with other transaction activity.
+ */
+int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr);
+
+/**
+ * gsi_trans_read_byte_done() - Clean up after a single byte read TRE
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel on which byte was read
+ *
+ * This function needs to be called to signal that the work related
+ * to reading a byte initiated by gsi_trans_read_byte() is complete.
+ */
+void gsi_trans_read_byte_done(struct gsi *gsi, u32 channel_id);
+
+#endif /* _GSI_TRANS_H_ */
-- 
2.20.1

