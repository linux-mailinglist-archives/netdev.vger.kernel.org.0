Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477033B3545
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhFXSKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhFXSKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E45C061766
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:53 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a193-20020a3766ca0000b02903a9be00d619so7891033qkc.12
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7bQ5OVwkk5s0lb6AJYZII5AnTuLxlphh1KDCr7ssUQY=;
        b=bzG+kRQGXAFsJqs/gLMrvfzjnpUGwrYiusm/y3LsuO+K10DXm7/EVDKaO4vaEY8s6E
         mR4EbzBOQ6l/kfE96sYf53LBvS+fMJGme5acJpz097y2Cci5+Mg/mXRuoAlvCzP0gt+w
         c2+ggnTwWqxETMCeQUNbFaXH7ck2I3d8U1ZVOpYa1wIiRXp4e502aHF4u0UNsosQ0GQN
         du6W7+NVv21e54Me1g4orun1fV82pJloKmHgUaJ+Mw686FDSf9uowM982aJUjNbxD9B4
         5Oif28HZ0PgPwAaoQZOXY6ChXAyULijKlo1tE3IWITMlsCUFqdMKeX+F+A/fBVu/cGlY
         qrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7bQ5OVwkk5s0lb6AJYZII5AnTuLxlphh1KDCr7ssUQY=;
        b=IKkR4Fc5985FfS/SaqxicTgsql0vmy0uViy9P4f7/aGxWuVP+ZB1Vhq3x0DPaZTw1u
         cT/hXeicsSfTGIb73VvNtqXpKpmSAEvf0jtStryOVjwoxXw86k0jw4mKL8Cy6n/IDAVM
         9NL+ZzdnuqBp9N9bM+zJkY9kbeaedUcLRLUb8zJPzxno84LuvWkZZyEcwJjFr1mNNzBT
         lHE2e+KDApcO4tpl4fZRi8eI6AiX0TUE7G1LkpvINDsRRKy9iIHdzxbWZ/peKp0T/lyj
         bGL2wqp930/9kB/F2hTWQWZjfbp0wP3K3PlehvuVB5k2HfOYnleI5go1lX85iVDWIT7+
         QBTg==
X-Gm-Message-State: AOAM5319/pG6JDQiZAA6s5/B6UE1t4eoIi9tJyO6hajYdWHG7zgyRd95
        DrDzJIqt+9s17ULyY/7gSEyROKw=
X-Google-Smtp-Source: ABdhPJwkkuC2acpI+e+5Js8vDq4ohBPsPPWbjJSDX1fPJhfBVC64K/0ZtYTHggSk1rYZVSvkfjvToAg=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:ad4:54f2:: with SMTP id k18mr6631119qvx.32.1624558073013;
 Thu, 24 Jun 2021 11:07:53 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:26 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-11-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 10/16] gve: Add DQO fields for core data structures
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Add new DQO datapath structures:
  - `gve_rx_buf_queue_dqo`
  - `gve_rx_compl_queue_dqo`
  - `gve_rx_buf_state_dqo`
  - `gve_tx_desc_dqo`
  - `gve_tx_pending_packet_dqo`

- Incorporate these into the existing ring data structures:
  - `gve_rx_ring`
  - `gve_tx_ring`

Noteworthy mentions:

- `gve_rx_buf_state` represents an RX buffer which was posted to HW.
  Each RX queue has an array of these objects and the index into the
  array is used as the buffer_id when posted to HW.

- `gve_tx_pending_packet_dqo` is treated similarly for TX queues. The
  completion_tag is the index into the array.

- These two structures have links for linked lists which are represented
  by 16b indexes into a contiguous array of these structures.
  This reduces memory footprint compared to 64b pointers.

- We use unions for the writeable datapath structures to reduce cache
  footprint. GQI specific members will renamed like DQO members in a
  future patch.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h | 262 ++++++++++++++++++++++++--
 1 file changed, 251 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index e32730f50bf9..5bfab1ac20d1 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -13,6 +13,7 @@
 #include <linux/u64_stats_sync.h>
 
 #include "gve_desc.h"
+#include "gve_desc_dqo.h"
 
 #ifndef PCI_VENDOR_ID_GOOGLE
 #define PCI_VENDOR_ID_GOOGLE	0x1ae0
@@ -80,17 +81,117 @@ struct gve_rx_data_queue {
 
 struct gve_priv;
 
-/* An RX ring that contains a power-of-two sized desc and data ring. */
+/* RX buffer queue for posting buffers to HW.
+ * Each RX (completion) queue has a corresponding buffer queue.
+ */
+struct gve_rx_buf_queue_dqo {
+	struct gve_rx_desc_dqo *desc_ring;
+	dma_addr_t bus;
+	u32 head; /* Pointer to start cleaning buffers at. */
+	u32 tail; /* Last posted buffer index + 1 */
+	u32 mask; /* Mask for indices to the size of the ring */
+};
+
+/* RX completion queue to receive packets from HW. */
+struct gve_rx_compl_queue_dqo {
+	struct gve_rx_compl_desc_dqo *desc_ring;
+	dma_addr_t bus;
+
+	/* Number of slots which did not have a buffer posted yet. We should not
+	 * post more buffers than the queue size to avoid HW overrunning the
+	 * queue.
+	 */
+	int num_free_slots;
+
+	/* HW uses a "generation bit" to notify SW of new descriptors. When a
+	 * descriptor's generation bit is different from the current generation,
+	 * that descriptor is ready to be consumed by SW.
+	 */
+	u8 cur_gen_bit;
+
+	/* Pointer into desc_ring where the next completion descriptor will be
+	 * received.
+	 */
+	u32 head;
+	u32 mask; /* Mask for indices to the size of the ring */
+};
+
+/* Stores state for tracking buffers posted to HW */
+struct gve_rx_buf_state_dqo {
+	/* The page posted to HW. */
+	struct gve_rx_slot_page_info page_info;
+
+	/* The DMA address corresponding to `page_info`. */
+	dma_addr_t addr;
+
+	/* Last offset into the page when it only had a single reference, at
+	 * which point every other offset is free to be reused.
+	 */
+	u32 last_single_ref_offset;
+
+	/* Linked list index to next element in the list, or -1 if none */
+	s16 next;
+};
+
+/* `head` and `tail` are indices into an array, or -1 if empty. */
+struct gve_index_list {
+	s16 head;
+	s16 tail;
+};
+
+/* Contains datapath state used to represent an RX queue. */
 struct gve_rx_ring {
 	struct gve_priv *gve;
-	struct gve_rx_desc_queue desc;
-	struct gve_rx_data_queue data;
+	union {
+		/* GQI fields */
+		struct {
+			struct gve_rx_desc_queue desc;
+			struct gve_rx_data_queue data;
+
+			/* threshold for posting new buffs and descs */
+			u32 db_threshold;
+		};
+
+		/* DQO fields. */
+		struct {
+			struct gve_rx_buf_queue_dqo bufq;
+			struct gve_rx_compl_queue_dqo complq;
+
+			struct gve_rx_buf_state_dqo *buf_states;
+			u16 num_buf_states;
+
+			/* Linked list of gve_rx_buf_state_dqo. Index into
+			 * buf_states, or -1 if empty.
+			 */
+			s16 free_buf_states;
+
+			/* Linked list of gve_rx_buf_state_dqo. Indexes into
+			 * buf_states, or -1 if empty.
+			 *
+			 * This list contains buf_states which are pointing to
+			 * valid buffers.
+			 *
+			 * We use a FIFO here in order to increase the
+			 * probability that buffers can be reused by increasing
+			 * the time between usages.
+			 */
+			struct gve_index_list recycled_buf_states;
+
+			/* Linked list of gve_rx_buf_state_dqo. Indexes into
+			 * buf_states, or -1 if empty.
+			 *
+			 * This list contains buf_states which have buffers
+			 * which cannot be reused yet.
+			 */
+			struct gve_index_list used_buf_states;
+		} dqo;
+	};
+
 	u64 rbytes; /* free-running bytes received */
 	u64 rpackets; /* free-running packets received */
 	u32 cnt; /* free-running total number of completed packets */
 	u32 fill_cnt; /* free-running total number of descs and buffs posted */
 	u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
-	u32 db_threshold; /* threshold for posting new buffs and descs */
 	u64 rx_copybreak_pkt; /* free-running count of copybreak packets */
 	u64 rx_copied_pkt; /* free-running total number of copied packets */
 	u64 rx_skb_alloc_fail; /* free-running count of skb alloc fails */
@@ -141,23 +242,161 @@ struct gve_tx_fifo {
 	struct gve_queue_page_list *qpl; /* QPL mapped into this FIFO */
 };
 
-/* A TX ring that contains a power-of-two sized desc ring and a FIFO buffer */
+/* TX descriptor for DQO format */
+union gve_tx_desc_dqo {
+	struct gve_tx_pkt_desc_dqo pkt;
+	struct gve_tx_tso_context_desc_dqo tso_ctx;
+	struct gve_tx_general_context_desc_dqo general_ctx;
+};
+
+enum gve_packet_state {
+	/* Packet is in free list, available to be allocated.
+	 * This should always be zero since state is not explicitly initialized.
+	 */
+	GVE_PACKET_STATE_UNALLOCATED,
+	/* Packet is expecting a regular data completion or miss completion */
+	GVE_PACKET_STATE_PENDING_DATA_COMPL,
+	/* Packet has received a miss completion and is expecting a
+	 * re-injection completion.
+	 */
+	GVE_PACKET_STATE_PENDING_REINJECT_COMPL,
+	/* No valid completion received within the specified timeout. */
+	GVE_PACKET_STATE_TIMED_OUT_COMPL,
+};
+
+struct gve_tx_pending_packet_dqo {
+	struct sk_buff *skb; /* skb for this packet */
+
+	/* 0th element corresponds to the linear portion of `skb`, should be
+	 * unmapped with `dma_unmap_single`.
+	 *
+	 * All others correspond to `skb`'s frags and should be unmapped with
+	 * `dma_unmap_page`.
+	 */
+	struct gve_tx_dma_buf bufs[MAX_SKB_FRAGS + 1];
+	u16 num_bufs;
+
+	/* Linked list index to next element in the list, or -1 if none */
+	s16 next;
+
+	/* Linked list index to prev element in the list, or -1 if none.
+	 * Used for tracking either outstanding miss completions or prematurely
+	 * freed packets.
+	 */
+	s16 prev;
+
+	/* Identifies the current state of the packet as defined in
+	 * `enum gve_packet_state`.
+	 */
+	u8 state;
+
+	/* If packet is an outstanding miss completion, then the packet is
+	 * freed if the corresponding re-injection completion is not received
+	 * before kernel jiffies exceeds timeout_jiffies.
+	 */
+	unsigned long timeout_jiffies;
+};
+
+/* Contains datapath state used to represent a TX queue. */
 struct gve_tx_ring {
 	/* Cacheline 0 -- Accessed & dirtied during transmit */
-	struct gve_tx_fifo tx_fifo;
-	u32 req; /* driver tracked head pointer */
-	u32 done; /* driver tracked tail pointer */
+	union {
+		/* GQI fields */
+		struct {
+			struct gve_tx_fifo tx_fifo;
+			u32 req; /* driver tracked head pointer */
+			u32 done; /* driver tracked tail pointer */
+		};
+
+		/* DQO fields. */
+		struct {
+			/* Linked list of gve_tx_pending_packet_dqo. Index into
+			 * pending_packets, or -1 if empty.
+			 *
+			 * This is a consumer list owned by the TX path. When it
+			 * runs out, the producer list is stolen from the
+			 * completion handling path
+			 * (dqo_compl.free_pending_packets).
+			 */
+			s16 free_pending_packets;
+
+			/* Cached value of `dqo_compl.hw_tx_head` */
+			u32 head;
+			u32 tail; /* Last posted buffer index + 1 */
+
+			/* Index of the last descriptor with "report event" bit
+			 * set.
+			 */
+			u32 last_re_idx;
+		} dqo_tx;
+	};
 
 	/* Cacheline 1 -- Accessed & dirtied during gve_clean_tx_done */
-	__be32 last_nic_done ____cacheline_aligned; /* NIC tail pointer */
+	union {
+		/* GQI fields */
+		struct {
+			/* NIC tail pointer */
+			__be32 last_nic_done;
+		};
+
+		/* DQO fields. */
+		struct {
+			u32 head; /* Last read on compl_desc */
+
+			/* Tracks the current gen bit of compl_q */
+			u8 cur_gen_bit;
+
+			/* Linked list of gve_tx_pending_packet_dqo. Index into
+			 * pending_packets, or -1 if empty.
+			 *
+			 * This is the producer list, owned by the completion
+			 * handling path. When the consumer list
+			 * (dqo_tx.free_pending_packets) is runs out, this list
+			 * will be stolen.
+			 */
+			atomic_t free_pending_packets;
+
+			/* Last TX ring index fetched by HW */
+			atomic_t hw_tx_head;
+
+			/* List to track pending packets which received a miss
+			 * completion but not a corresponding reinjection.
+			 */
+			struct gve_index_list miss_completions;
+
+			/* List to track pending packets that were completed
+			 * before receiving a valid completion because they
+			 * reached a specified timeout.
+			 */
+			struct gve_index_list timed_out_completions;
+		} dqo_compl;
+	} ____cacheline_aligned;
 	u64 pkt_done; /* free-running - total packets completed */
 	u64 bytes_done; /* free-running - total bytes completed */
 	u64 dropped_pkt; /* free-running - total packets dropped */
 	u64 dma_mapping_error; /* count of dma mapping errors */
 
 	/* Cacheline 2 -- Read-mostly fields */
-	union gve_tx_desc *desc ____cacheline_aligned;
-	struct gve_tx_buffer_state *info; /* Maps 1:1 to a desc */
+	union {
+		/* GQI fields */
+		struct {
+			union gve_tx_desc *desc;
+
+			/* Maps 1:1 to a desc */
+			struct gve_tx_buffer_state *info;
+		};
+
+		/* DQO fields. */
+		struct {
+			union gve_tx_desc_dqo *tx_ring;
+			struct gve_tx_compl_desc *compl_ring;
+
+			struct gve_tx_pending_packet_dqo *pending_packets;
+			s16 num_pending_packets;
+
+			u32 complq_mask; /* complq size is complq_mask + 1 */
+		} dqo;
+	} ____cacheline_aligned;
 	struct netdev_queue *netdev_txq;
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
 	struct device *dev;
@@ -171,6 +410,7 @@ struct gve_tx_ring {
 	u32 ntfy_id; /* notification block index */
 	dma_addr_t bus; /* dma address of the descr ring */
 	dma_addr_t q_resources_bus; /* dma address of the queue resources */
+	dma_addr_t complq_bus_dqo; /* dma address of the dqo.compl_ring */
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
 } ____cacheline_aligned;
 
-- 
2.32.0.288.g62a8d224e6-goog

