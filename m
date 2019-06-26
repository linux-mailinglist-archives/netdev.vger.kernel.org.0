Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F7F5710D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfFZSx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:53:29 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35213 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZSx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:53:28 -0400
Received: by mail-pl1-f202.google.com with SMTP id bb9so1939863plb.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6TjRHwGGj/wSfJxbo3qzM+CiUT8QqHK4w7BrpJc8wAw=;
        b=CXw+hmCm41wXorztni1MEXKfIAx/vQPDinijFPX5PIgYzQavtpXlz3krMAEP2XKVkB
         NgoiHKei058reJOTCKGH6va0n/S5XwLPH0Bdl8LFO6bOjTrQx1PDBp3pxGs+/tCxOADa
         3YRauU7JAmFtk+NKs5Votm7wLjdHbmRjtDcGP8lsTX7KhIVb4o6SMjnUhMnFHdXKcEWo
         c8bnJCeJhJcIvM3ENQmmdLwL6HraUe9qqt0NtkvEe30OCqY4MBnG3IkW4XCmvvcxXFrj
         AhNXr9dp5rnCvaa0+/eYkfYKrvO2y6GbuCCVDilyb3PsKKs0ph4UwcxQhLlt/NUPnvbV
         p+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6TjRHwGGj/wSfJxbo3qzM+CiUT8QqHK4w7BrpJc8wAw=;
        b=bDqWfqXtXTFqIMaSKpqZ/+T6tHbKGnbpIZtgfwVAJ8gvyBbxHK1VgPBByleFdsC9yz
         0RQXfT1j3fbI6FevqaSrtNJBjeqj6RueZXJXEI9rnOYTLYbYuBSL1qE9twj+U8hGpuOC
         udElKV7YcRe9yuV6D6c0AQrLGXbtbIDdTZeqOwXOLsKY1Up00b9ZlTI+Sw2bHewm0z6j
         zJOjOzZUcCVBazaN6KBlVtzWKiOzhTV69MFdVne22Ueu1kl9wPwdX9crSpnYjUSjxNml
         1dj+vTH1ZI42PnmPot9dL1OrTJINBPXpTp04lp++jvJAK74xqKsnIlZL8Algs6lCNPw5
         q2xg==
X-Gm-Message-State: APjAAAWJcfsw/DMQDtfCHNZql8QTvaPhQAR9OeUgiODv+PRKTHyVTqT4
        VirXvE48Q1cx9TgrlXcpXQ8GgdrYanNuLFou1NPkC/LeAJOQQTVSpKpUyFWwso7fM9o86j5yuJ3
        bCMhgsyZ0hY26HVCQPwZz2+POUDcnNfadgHnz2Dc3OFyehAL5ibabEpEWgAu/Hw==
X-Google-Smtp-Source: APXvYqxOhgE15zehQIov+ER0sOj7mlDMT9JOBR1QmxCa01qJxwIv8R2BsRPWQftCHx08C2UKXOEPFBIyFOw=
X-Received: by 2002:a63:f349:: with SMTP id t9mr4219491pgj.296.1561575206325;
 Wed, 26 Jun 2019 11:53:26 -0700 (PDT)
Date:   Wed, 26 Jun 2019 11:52:49 -0700
In-Reply-To: <20190626185251.205687-1-csully@google.com>
Message-Id: <20190626185251.205687-3-csully@google.com>
Mime-Version: 1.0
References: <20190626185251.205687-1-csully@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [net-next 2/4] gve: Add transmit and receive support
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for passing traffic.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Jon Olson <jonolson@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Luigi Rizzo <lrizzo@google.com>
---
 .../networking/device_drivers/google/gve.rst  |  30 +
 drivers/net/ethernet/google/gve/Makefile      |   2 +-
 drivers/net/ethernet/google/gve/gve.h         | 257 +++++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  | 138 +++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  82 +++
 drivers/net/ethernet/google/gve/gve_desc.h    | 118 ++++
 drivers/net/ethernet/google/gve/gve_main.c    | 565 ++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      | 442 +++++++++++++
 drivers/net/ethernet/google/gve/gve_tx.c      | 584 ++++++++++++++++++
 9 files changed, 2213 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/google/gve/gve_desc.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_rx.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_tx.c

diff --git a/Documentation/networking/device_drivers/google/gve.rst b/Documentation/networking/device_drivers/google/gve.rst
index 7397c82f4c8f..df8974fb3270 100644
--- a/Documentation/networking/device_drivers/google/gve.rst
+++ b/Documentation/networking/device_drivers/google/gve.rst
@@ -42,6 +42,8 @@ The driver interacts with the device in the following ways:
     - See description below
  - Interrupts
     - See supported interrupts below
+ - Transmit and Receive Queues
+    - See description below
 
 Registers
 ---------
@@ -80,3 +82,31 @@ Notification Block Interrupts
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 The notification block interrupts are used to tell the driver to poll
 the queues associated with that interrupt.
+
+The handler for these irqs schedule the napi for that block to run
+and poll the queues.
+
+Traffic Queues
+--------------
+gVNIC's queues are composed of a descriptor ring and a buffer and are
+assigned to a notification block.
+
+The descriptor rings are power-of-two-sized ring buffers consisting of
+fixed-size descriptors. They advance their head pointer using a __be32
+doorbell located in Bar2. The tail pointers are advanced by consuming
+descriptors in-order and updating a __be32 counter. Both the doorbell
+and the counter overflow to zero.
+
+Each queue's buffers must be registered in advance with the device as a
+queue page list, and packet data can only be put in those pages.
+
+Transmit
+~~~~~~~~
+gve maps the buffers for transmit rings into a FIFO and copies the packets
+into the FIFO before sending them to the NIC.
+
+Receive
+~~~~~~~
+The buffers for receive rings are put into a data ring that is the same
+length as the descriptor ring and the head and tail pointers advance over
+the rings together.
diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
index cec03ee6d931..a1890c93705b 100644
--- a/drivers/net/ethernet/google/gve/Makefile
+++ b/drivers/net/ethernet/google/gve/Makefile
@@ -1,4 +1,4 @@
 # Makefile for the Google virtual Ethernet (gve) driver
 
 obj-$(CONFIG_GVE) += gve.o
-gve-objs := gve_main.o gve_adminq.o
+gve-objs := gve_main.o gve_tx.o gve_rx.o gve_adminq.o
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 47fb86e5aeff..ff47b01f1944 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -10,6 +10,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include "gve_desc.h"
 
 #ifndef PCI_VENDOR_ID_GOOGLE
 #define PCI_VENDOR_ID_GOOGLE	0x1ae0
@@ -20,18 +21,150 @@
 #define GVE_REGISTER_BAR	0
 #define GVE_DOORBELL_BAR	2
 
-/* 1 for management */
+/* Driver can alloc up to 2 segments for the header and 2 for the payload. */
+#define GVE_TX_MAX_IOVEC	4
+/* 1 for management, 1 for rx, 1 for tx */
 #define GVE_MIN_MSIX 3
 
+/* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
+struct gve_rx_desc_queue {
+	struct gve_rx_desc *desc_ring; /* the descriptor ring */
+	dma_addr_t bus; /* the bus for the desc_ring */
+	u32 cnt; /* free-running total number of completed packets */
+	u32 fill_cnt; /* free-running total number of descriptors posted */
+	u32 mask; /* masks the cnt to the size of the ring */
+	u8 seqno; /* the next expected seqno for this desc*/
+};
+
+/* The page info for a single slot in the RX data queue */
+struct gve_rx_slot_page_info {
+	struct page *page;
+	void *page_address;
+	u32 page_offset; /* offset to write to in page */
+};
+
+/* A list of pages registered with the device during setup and used by a queue
+ * as buffers
+ */
+struct gve_queue_page_list {
+	u32 id; /* unique id */
+	u32 num_entries;
+	struct page **pages; /* list of num_entries pages */
+	dma_addr_t *page_buses; /* the dma addrs of the pages */
+};
+
+/* Each slot in the data ring has a 1:1 mapping to a slot in the desc ring */
+struct gve_rx_data_queue {
+	struct gve_rx_data_slot *data_ring; /* read by NIC */
+	dma_addr_t data_bus; /* dma mapping of the slots */
+	struct gve_rx_slot_page_info *page_info; /* page info of the buffers */
+	struct gve_queue_page_list *qpl; /* qpl assigned to this queue */
+	u32 mask; /* masks the cnt to the size of the ring */
+	u32 cnt; /* free-running total number of completed packets */
+};
+
+struct gve_priv;
+
+/* An RX ring that contains a power-of-two sized desc and data ring. */
+struct gve_rx_ring {
+	struct gve_priv *gve;
+	struct gve_rx_desc_queue desc;
+	struct gve_rx_data_queue data;
+	u64 rbytes; /* free-running bytes received */
+	u64 rpackets; /* free-running packets received */
+	u32 q_num; /* queue index */
+	u32 ntfy_id; /* notification block index */
+	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
+	dma_addr_t q_resources_bus; /* dma address for the queue resources */
+};
+
+/* A TX desc ring entry */
+union gve_tx_desc {
+	struct gve_tx_pkt_desc pkt; /* first desc for a packet */
+	struct gve_tx_seg_desc seg; /* subsequent descs for a packet */
+};
+
+/* Tracks the memory in the fifo occupied by a segment of a packet */
+struct gve_tx_iovec {
+	u32 iov_offset; /* offset into this segment */
+	u32 iov_len; /* length */
+	u32 iov_padding; /* padding associated with this segment */
+};
+
+/* Tracks the memory in the fifo occupied by the skb. Mapped 1:1 to a desc
+ * ring entry but only used for a pkt_desc not a seg_desc
+ */
+struct gve_tx_buffer_state {
+	struct sk_buff *skb; /* skb for this pkt */
+	struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
+};
+
+/* A TX buffer - each queue has one */
+struct gve_tx_fifo {
+	void *base; /* address of base of FIFO */
+	u32 size; /* total size */
+	atomic_t available; /* how much space is still available */
+	u32 head; /* offset to write at */
+	struct gve_queue_page_list *qpl; /* QPL mapped into this FIFO */
+};
+
+/* A TX ring that contains a power-of-two sized desc ring and a FIFO buffer */
+struct gve_tx_ring {
+	/* Cacheline 0 -- Accessed & dirtied during transmit */
+	struct gve_tx_fifo tx_fifo;
+	u32 req; /* driver tracked head pointer */
+	u32 done; /* driver tracked tail pointer */
+
+	/* Cacheline 1 -- Accessed & dirtied during gve_clean_tx_done */
+	__be32 last_nic_done ____cacheline_aligned; /* NIC tail pointer */
+	u64 pkt_done; /* free-running - total packets completed */
+	u64 bytes_done; /* free-running - total bytes completed */
+
+	/* Cacheline 2 -- Read-mostly fields */
+	union gve_tx_desc *desc ____cacheline_aligned;
+	struct gve_tx_buffer_state *info; /* Maps 1:1 to a desc */
+	struct netdev_queue *netdev_txq;
+	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
+	u32 mask; /* masks req and done down to queue size */
+
+	/* Slow-path fields */
+	u32 q_num ____cacheline_aligned; /* queue idx */
+	u32 stop_queue; /* count of queue stops */
+	u32 wake_queue; /* count of queue wakes */
+	u32 ntfy_id; /* notification block index */
+	dma_addr_t bus; /* dma address of the descr ring */
+	dma_addr_t q_resources_bus; /* dma address of the queue resources */
+} ____cacheline_aligned;
+
+/* Wraps the info for one irq including the napi struct and the queues
+ * associated with that irq.
+ */
 struct gve_notify_block {
 	__be32 irq_db_index; /* idx into Bar2 - set by device, must be 1st */
 	char name[IFNAMSIZ + 16]; /* name registered with the kernel */
 	struct napi_struct napi; /* kernel napi struct for this block */
 	struct gve_priv *priv;
+	struct gve_tx_ring *tx; /* tx rings on this block */
+	struct gve_rx_ring *rx; /* rx rings on this block */
 } ____cacheline_aligned;
 
+/* Tracks allowed and current queue settings */
+struct gve_queue_config {
+	u16 max_queues;
+	u16 num_queues; /* current */
+};
+
+/* Tracks the available and used qpl IDs */
+struct gve_qpl_config {
+	u32 qpl_map_size; /* map memory size */
+	unsigned long *qpl_id_map; /* bitmap of used qpl ids */
+};
+
 struct gve_priv {
 	struct net_device *dev;
+	struct gve_tx_ring *tx; /* array of tx_cfg.num_queues */
+	struct gve_rx_ring *rx; /* array of rx_cfg.num_queues */
+	struct gve_queue_page_list *qpls; /* array of num qpls */
 	struct gve_notify_block *ntfy_blocks; /* array of num_ntfy_blks */
 	dma_addr_t ntfy_block_bus;
 	struct msix_entry *msix_vectors; /* array of num_ntfy_blks + 1 */
@@ -41,7 +174,18 @@ struct gve_priv {
 	dma_addr_t counter_array_bus;
 
 	u16 num_event_counters;
+	u16 tx_desc_cnt; /* num desc per ring */
+	u16 rx_desc_cnt; /* num desc per ring */
+	u16 tx_pages_per_qpl; /* tx buffer length */
+	u16 rx_pages_per_qpl; /* rx buffer length */
+	u64 max_registered_pages;
+	u64 num_registered_pages; /* num pages registered with NIC */
+	u32 rx_copybreak; /* copy packets smaller than this */
+	u16 default_num_queues; /* default num queues to set up */
 
+	struct gve_queue_config tx_cfg;
+	struct gve_queue_config rx_cfg;
+	struct gve_qpl_config qpl_cfg; /* map used QPL ids */
 	u32 num_ntfy_blks; /* spilt between TX and RX so must be even */
 
 	struct gve_registers __iomem *reg_bar0; /* see gve_register.h */
@@ -49,6 +193,9 @@ struct gve_priv {
 	u32 msg_enable;	/* level for netif* netdev print macros	*/
 	struct pci_dev *pdev;
 
+	/* metrics */
+	u32 tx_timeo_cnt;
+
 	/* Admin queue - see gve_adminq.h*/
 	union gve_adminq_command *adminq;
 	dma_addr_t adminq_bus_addr;
@@ -132,4 +279,112 @@ static inline __be32 __iomem *gve_irq_doorbell(struct gve_priv *priv,
 {
 	return &priv->db_bar2[be32_to_cpu(block->irq_db_index)];
 }
+
+/* Returns the index into ntfy_blocks of the given tx ring's block
+ */
+static inline u32 gve_tx_idx_to_ntfy(struct gve_priv *priv, u32 queue_idx)
+{
+	return queue_idx;
+}
+
+/* Returns the index into ntfy_blocks of the given rx ring's block
+ */
+static inline u32 gve_rx_idx_to_ntfy(struct gve_priv *priv, u32 queue_idx)
+{
+	return (priv->num_ntfy_blks / 2) + queue_idx;
+}
+
+/* Returns the number of tx queue page lists
+ */
+static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
+{
+	return priv->tx_cfg.num_queues;
+}
+
+/* Returns the number of rx queue page lists
+ */
+static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
+{
+	return priv->rx_cfg.num_queues;
+}
+
+/* Returns a pointer to the next available tx qpl in the list of qpls
+ */
+static inline
+struct gve_queue_page_list *gve_assign_tx_qpl(struct gve_priv *priv)
+{
+	int id = find_first_zero_bit(priv->qpl_cfg.qpl_id_map,
+				     priv->qpl_cfg.qpl_map_size);
+
+	/* we are out of tx qpls */
+	if (id >= gve_num_tx_qpls(priv))
+		return NULL;
+
+	set_bit(id, priv->qpl_cfg.qpl_id_map);
+	return &priv->qpls[id];
+}
+
+/* Returns a pointer to the next available rx qpl in the list of qpls
+ */
+static inline
+struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv)
+{
+	int id = find_next_zero_bit(priv->qpl_cfg.qpl_id_map,
+				    priv->qpl_cfg.qpl_map_size,
+				    gve_num_tx_qpls(priv));
+
+	/* we are out of rx qpls */
+	if (id == priv->qpl_cfg.qpl_map_size)
+		return NULL;
+
+	set_bit(id, priv->qpl_cfg.qpl_id_map);
+	return &priv->qpls[id];
+}
+
+/* Unassigns the qpl with the given id
+ */
+static inline void gve_unassign_qpl(struct gve_priv *priv, int id)
+{
+	clear_bit(id, priv->qpl_cfg.qpl_id_map);
+}
+
+/* Returns the correct dma direction for tx and rx qpls
+ */
+static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
+						      int id)
+{
+	if (id < gve_num_tx_qpls(priv))
+		return DMA_TO_DEVICE;
+	else
+		return DMA_FROM_DEVICE;
+}
+
+/* Returns true if the max mtu allows page recycling */
+static inline bool gve_can_recycle_pages(struct net_device *dev)
+{
+	/* We can't recycle the pages if we can't fit a packet into half a
+	 * page.
+	 */
+	return dev->max_mtu <= PAGE_SIZE / 2;
+}
+
+/* buffers */
+int gve_alloc_page(struct device *dev, struct page **page, dma_addr_t *dma,
+		   enum dma_data_direction);
+void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
+		   enum dma_data_direction);
+/* tx handling */
+netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
+bool gve_tx_poll(struct gve_notify_block *block, int budget);
+int gve_tx_alloc_rings(struct gve_priv *priv);
+void gve_tx_free_rings(struct gve_priv *priv);
+__be32 gve_tx_load_event_counter(struct gve_priv *priv,
+				 struct gve_tx_ring *tx);
+/* rx handling */
+void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx);
+bool gve_rx_poll(struct gve_notify_block *block, int budget);
+int gve_rx_alloc_rings(struct gve_priv *priv);
+void gve_rx_free_rings(struct gve_priv *priv);
+bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
+		       netdev_features_t feat);
 #endif /* _GVE_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 346c468ac77b..a67e8c88ef9f 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -192,6 +192,72 @@ int gve_adminq_deconfigure_device_resources(struct gve_priv *priv)
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
 
+int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
+{
+	struct gve_tx_ring *tx = &priv->tx[queue_index];
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
+	cmd.create_tx_queue = (struct gve_adminq_create_tx_queue) {
+		.queue_id = cpu_to_be32(queue_index),
+		.reserved = 0,
+		.queue_resources_addr = cpu_to_be64(tx->q_resources_bus),
+		.tx_ring_addr = cpu_to_be64(tx->bus),
+		.queue_page_list_id = cpu_to_be32(tx->tx_fifo.qpl->id),
+		.ntfy_id = cpu_to_be32(tx->ntfy_id),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
+int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
+{
+	struct gve_rx_ring *rx = &priv->rx[queue_index];
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
+	cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
+		.queue_id = cpu_to_be32(queue_index),
+		.index = cpu_to_be32(queue_index),
+		.reserved = 0,
+		.ntfy_id = cpu_to_be32(rx->ntfy_id),
+		.queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
+		.rx_desc_ring_addr = cpu_to_be64(rx->desc.bus),
+		.rx_data_ring_addr = cpu_to_be64(rx->data.data_bus),
+		.queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
+int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESTROY_TX_QUEUE);
+	cmd.destroy_tx_queue = (struct gve_adminq_destroy_tx_queue) {
+		.queue_id = cpu_to_be32(queue_index),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
+int gve_adminq_destroy_rx_queue(struct gve_priv *priv, u32 queue_index)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESTROY_RX_QUEUE);
+	cmd.destroy_rx_queue = (struct gve_adminq_destroy_rx_queue) {
+		.queue_id = cpu_to_be32(queue_index),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
 	struct gve_device_descriptor *descriptor;
@@ -217,6 +283,25 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	if (err)
 		goto free_device_descriptor;
 
+	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
+	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < PAGE_SIZE) {
+		netif_err(priv, drv, priv->dev, "Tx desc count %d too low\n",
+			  priv->tx_desc_cnt);
+		err = -EINVAL;
+		goto free_device_descriptor;
+	}
+	priv->rx_desc_cnt = be16_to_cpu(descriptor->rx_queue_entries);
+	if (priv->rx_desc_cnt * sizeof(priv->rx->desc.desc_ring[0])
+	    < PAGE_SIZE ||
+	    priv->rx_desc_cnt * sizeof(priv->rx->data.data_ring[0])
+	    < PAGE_SIZE) {
+		netif_err(priv, drv, priv->dev, "Rx desc count %d too low\n",
+			  priv->rx_desc_cnt);
+		err = -EINVAL;
+		goto free_device_descriptor;
+	}
+	priv->max_registered_pages =
+				be64_to_cpu(descriptor->max_registered_pages);
 	mtu = be16_to_cpu(descriptor->mtu);
 	if (mtu < ETH_MIN_MTU) {
 		netif_err(priv, drv, priv->dev, "MTU %d below minimum MTU\n",
@@ -229,6 +314,14 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	ether_addr_copy(priv->dev->dev_addr, descriptor->mac);
 	mac = descriptor->mac;
 	netif_info(priv, drv, priv->dev, "MAC addr: %pM\n", mac);
+	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
+	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
+	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
+		netif_err(priv, drv, priv->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
+			  priv->rx_pages_per_qpl);
+		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
+	}
+	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
 
 free_device_descriptor:
 	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
@@ -236,6 +329,51 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	return err;
 }
 
+int gve_adminq_register_page_list(struct gve_priv *priv,
+				  struct gve_queue_page_list *qpl)
+{
+	struct device *hdev = &priv->pdev->dev;
+	u32 num_entries = qpl->num_entries;
+	u32 size = num_entries * sizeof(qpl->page_buses[0]);
+	union gve_adminq_command cmd;
+	dma_addr_t page_list_bus;
+	__be64 *page_list;
+	int err;
+	int i;
+
+	memset(&cmd, 0, sizeof(cmd));
+	page_list = dma_alloc_coherent(hdev, size, &page_list_bus, GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	for (i = 0; i < num_entries; i++)
+		page_list[i] = cpu_to_be64(qpl->page_buses[i]);
+
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_REGISTER_PAGE_LIST);
+	cmd.reg_page_list = (struct gve_adminq_register_page_list) {
+		.page_list_id = cpu_to_be32(qpl->id),
+		.num_pages = cpu_to_be32(num_entries),
+		.page_address_list_addr = cpu_to_be64(page_list_bus),
+	};
+
+	err = gve_adminq_execute_cmd(priv, &cmd);
+	dma_free_coherent(hdev, size, page_list, page_list_bus);
+	return err;
+}
+
+int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_UNREGISTER_PAGE_LIST);
+	cmd.unreg_page_list = (struct gve_adminq_unregister_page_list) {
+		.page_list_id = cpu_to_be32(page_list_id),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu)
 {
 	union gve_adminq_command cmd;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index dd9fc11eb205..a8772ede8974 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -13,6 +13,12 @@
 enum gve_adminq_opcodes {
 	GVE_ADMINQ_DESCRIBE_DEVICE		= 0x1,
 	GVE_ADMINQ_CONFIGURE_DEVICE_RESOURCES	= 0x2,
+	GVE_ADMINQ_REGISTER_PAGE_LIST		= 0x3,
+	GVE_ADMINQ_UNREGISTER_PAGE_LIST		= 0x4,
+	GVE_ADMINQ_CREATE_TX_QUEUE		= 0x5,
+	GVE_ADMINQ_CREATE_RX_QUEUE		= 0x6,
+	GVE_ADMINQ_DESTROY_TX_QUEUE		= 0x7,
+	GVE_ADMINQ_DESTROY_RX_QUEUE		= 0x8,
 	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
 	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
 };
@@ -89,6 +95,69 @@ struct gve_adminq_configure_device_resources {
 
 GVE_ASSERT_SIZE(struct, gve_adminq_configure_device_resources, 32);
 
+struct gve_adminq_register_page_list {
+	__be32 page_list_id;
+	__be32 num_pages;
+	__be64 page_address_list_addr;
+};
+
+GVE_ASSERT_SIZE(struct, gve_adminq_register_page_list, 16);
+
+struct gve_adminq_unregister_page_list {
+	__be32 page_list_id;
+};
+
+GVE_ASSERT_SIZE(struct, gve_adminq_unregister_page_list, 4);
+
+struct gve_adminq_create_tx_queue {
+	__be32 queue_id;
+	__be32 reserved;
+	__be64 queue_resources_addr;
+	__be64 tx_ring_addr;
+	__be32 queue_page_list_id;
+	__be32 ntfy_id;
+};
+
+GVE_ASSERT_SIZE(struct, gve_adminq_create_tx_queue, 32);
+
+struct gve_adminq_create_rx_queue {
+	__be32 queue_id;
+	__be32 index;
+	__be32 reserved;
+	__be32 ntfy_id;
+	__be64 queue_resources_addr;
+	__be64 rx_desc_ring_addr;
+	__be64 rx_data_ring_addr;
+	__be32 queue_page_list_id;
+};
+
+GVE_ASSERT_SIZE(struct, gve_adminq_create_rx_queue, 48);
+
+/* Queue resources that are shared with the device */
+struct gve_queue_resources {
+	union {
+		struct {
+			__be32 db_index;	/* Device -> Guest */
+			__be32 counter_index;	/* Device -> Guest */
+		};
+		u8 reserved[64];
+	};
+};
+
+GVE_ASSERT_SIZE(struct, gve_queue_resources, 64);
+
+struct gve_adminq_destroy_tx_queue {
+	__be32 queue_id;
+};
+
+GVE_ASSERT_SIZE(struct, gve_adminq_destroy_tx_queue, 4);
+
+struct gve_adminq_destroy_rx_queue {
+	__be32 queue_id;
+};
+
+GVE_ASSERT_SIZE(struct, gve_adminq_destroy_rx_queue, 4);
+
 /* GVE Set Driver Parameter Types */
 enum gve_set_driver_param_types {
 	GVE_SET_PARAM_MTU	= 0x1,
@@ -108,7 +177,13 @@ union gve_adminq_command {
 		union {
 			struct gve_adminq_configure_device_resources
 						configure_device_resources;
+			struct gve_adminq_create_tx_queue create_tx_queue;
+			struct gve_adminq_create_rx_queue create_rx_queue;
+			struct gve_adminq_destroy_tx_queue destroy_tx_queue;
+			struct gve_adminq_destroy_rx_queue destroy_rx_queue;
 			struct gve_adminq_describe_device describe_device;
+			struct gve_adminq_register_page_list reg_page_list;
+			struct gve_adminq_unregister_page_list unreg_page_list;
 			struct gve_adminq_set_driver_parameter set_driver_param;
 		};
 	};
@@ -129,5 +204,12 @@ int gve_adminq_configure_device_resources(struct gve_priv *priv,
 					  dma_addr_t db_array_bus_addr,
 					  u32 num_ntfy_blks);
 int gve_adminq_deconfigure_device_resources(struct gve_priv *priv);
+int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_destroy_rx_queue(struct gve_priv *priv, u32 queue_id);
+int gve_adminq_register_page_list(struct gve_priv *priv,
+				  struct gve_queue_page_list *qpl);
+int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
 #endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
new file mode 100644
index 000000000000..1e866c67f143
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_desc.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+/* GVE Transmit Descriptor formats */
+
+#ifndef _GVE_DESC_H_
+#define _GVE_DESC_H_
+
+#include "gve_size_assert.h"
+
+/* A note on seg_addrs
+ *
+ * Base addresses encoded in seg_addr are not assumed to be physical
+ * addresses. The ring format assumes these come from some linear address
+ * space. This could be physical memory, kernel virtual memory, user virtual
+ * memory. gVNIC uses lists of registered pages. Each queue is assumed
+ * to be associated with a single such linear address space to ensure a
+ * consistent meaning for seg_addrs posted to its rings.
+ */
+
+struct gve_tx_pkt_desc {
+	u8	type_flags;  /* desc type is lower 4 bits, flags upper */
+	u8	l4_csum_offset;  /* relative offset of L4 csum word */
+	u8	l4_hdr_offset;  /* Offset of start of L4 headers in packet */
+	u8	desc_cnt;  /* Total descriptors for this packet */
+	__be16	len;  /* Total length of this packet (in bytes) */
+	__be16	seg_len;  /* Length of this descriptor's segment */
+	__be64	seg_addr;  /* Base address (see note) of this segment */
+} __packed;
+
+struct gve_tx_seg_desc {
+	u8	type_flags;	/* type is lower 4 bits, flags upper	*/
+	u8	l3_offset;	/* TSO: 2 byte units to start of IPH	*/
+	__be16	reserved;
+	__be16	mss;		/* TSO MSS				*/
+	__be16	seg_len;
+	__be64	seg_addr;
+} __packed;
+
+/* GVE Transmit Descriptor Types */
+#define	GVE_TXD_STD		(0x0 << 4) /* Std with Host Address	*/
+#define	GVE_TXD_TSO		(0x1 << 4) /* TSO with Host Address	*/
+#define	GVE_TXD_SEG		(0x2 << 4) /* Seg with Host Address	*/
+
+/* GVE Transmit Descriptor Flags for Std Pkts */
+#define	GVE_TXF_L4CSUM	BIT(0)	/* Need csum offload */
+#define	GVE_TXF_TSTAMP	BIT(2)	/* Timestamp required */
+
+/* GVE Transmit Descriptor Flags for TSO Segs */
+#define	GVE_TXSF_IPV6	BIT(1)	/* IPv6 TSO */
+
+/* GVE Receive Packet Descriptor */
+/* The start of an ethernet packet comes 2 bytes into the rx buffer.
+ * gVNIC adds this padding so that both the DMA and the L3/4 protocol header
+ * access is aligned.
+ */
+#define GVE_RX_PAD 2
+
+struct gve_rx_desc {
+	u8	padding[48];
+	__be32	rss_hash;  /* Receive-side scaling hash (Toeplitz for gVNIC) */
+	__be16	mss;
+	__be16	reserved;  /* Reserved to zero */
+	u8	hdr_len;  /* Header length (L2-L4) including padding */
+	u8	hdr_off;  /* 64-byte-scaled offset into RX_DATA entry */
+	__be16	csum;  /* 1's-complement partial checksum of L3+ bytes */
+	__be16	len;  /* Length of the received packet */
+	__be16	flags_seq;  /* Flags [15:3] and sequence number [2:0] (1-7) */
+} __packed;
+GVE_ASSERT_SIZE(struct, gve_rx_desc, 64);
+
+/* As with the Tx ring format, the qpl_offset entries below are offsets into an
+ * ordered list of registered pages.
+ */
+struct gve_rx_data_slot {
+	/* byte offset into the rx registered segment of this slot */
+	__be64 qpl_offset;
+};
+
+/* GVE Recive Packet Descriptor Seq No */
+
+#ifdef __LITTLE_ENDIAN
+#define GVE_SEQNO(x) ((((__force u16)x) >> 8) & 0x7)
+#else
+#define	GVE_SEQNO(x) ((__force u16)(x) & 0x7)
+#endif
+
+/* GVE Recive Packet Descriptor Flags */
+#define GVE_RXFLG(x)	cpu_to_be16(1 << (3 + (x)))
+#define	GVE_RXF_FRAG	GVE_RXFLG(3)	/* IP Fragment			*/
+#define	GVE_RXF_IPV4	GVE_RXFLG(4)	/* IPv4				*/
+#define	GVE_RXF_IPV6	GVE_RXFLG(5)	/* IPv6				*/
+#define	GVE_RXF_TCP	GVE_RXFLG(6)	/* TCP Packet			*/
+#define	GVE_RXF_UDP	GVE_RXFLG(7)	/* UDP Packet			*/
+#define	GVE_RXF_ERR	GVE_RXFLG(8)	/* Packet Error Detected	*/
+
+/* GVE IRQ */
+#define GVE_IRQ_ACK	BIT(31)
+#define GVE_IRQ_MASK	BIT(30)
+#define GVE_IRQ_EVENT	BIT(29)
+
+static inline bool gve_needs_rss(__be16 flag)
+{
+	if (flag & GVE_RXF_FRAG)
+		return false;
+	if (flag & (GVE_RXF_IPV4 | GVE_RXF_IPV6))
+		return true;
+	return false;
+}
+
+static inline u8 gve_next_seqno(u8 seq)
+{
+	return (seq + 1) == 8 ? 1 : seq + 1;
+}
+#endif /* _GVE_DESC_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index aa0428efb13b..966bcee1db58 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -16,6 +16,8 @@
 #include "gve_adminq.h"
 #include "gve_register.h"
 
+#define GVE_DEFAULT_RX_COPYBREAK	(256)
+
 #define DEFAULT_MSG_LEVEL	(NETIF_MSG_DRV | NETIF_MSG_LINK)
 #define GVE_VERSION		"1.0.0"
 #define GVE_VERSION_PREFIX	"GVE-"
@@ -23,6 +25,25 @@
 const char gve_version_str[] = GVE_VERSION;
 const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
+static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	int ring;
+
+	if (priv->rx) {
+		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
+			s->rx_packets += priv->rx[ring].rpackets;
+			s->rx_bytes += priv->rx[ring].rbytes;
+		}
+	}
+	if (priv->tx) {
+		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
+			s->tx_packets += priv->tx[ring].pkt_done;
+			s->tx_bytes += priv->tx[ring].bytes_done;
+		}
+	}
+}
+
 static int gve_alloc_counter_array(struct gve_priv *priv)
 {
 	priv->counter_array =
@@ -52,9 +73,50 @@ static irqreturn_t gve_mgmnt_intr(int irq, void *arg)
 
 static irqreturn_t gve_intr(int irq, void *arg)
 {
+	struct gve_notify_block *block = arg;
+	struct gve_priv *priv = block->priv;
+
+	writel(cpu_to_be32(GVE_IRQ_MASK), gve_irq_doorbell(priv, block));
+	napi_schedule_irqoff(&block->napi);
 	return IRQ_HANDLED;
 }
 
+int gve_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct gve_notify_block *block;
+	__be32 __iomem *irq_doorbell;
+	bool reschedule = false;
+	struct gve_priv *priv;
+
+	block = container_of(napi, struct gve_notify_block, napi);
+	priv = block->priv;
+
+	if (block->tx)
+		reschedule |= gve_tx_poll(block, budget);
+	if (block->rx)
+		reschedule |= gve_rx_poll(block, budget);
+
+	if (reschedule)
+		return budget;
+
+	napi_complete(napi);
+	irq_doorbell = gve_irq_doorbell(priv, block);
+	writel(cpu_to_be32(GVE_IRQ_ACK | GVE_IRQ_EVENT), irq_doorbell);
+
+	/* Double check we have no extra work.
+	 * Ensure unmask synchronizes with checking for work.
+	 */
+	dma_rmb();
+	if (block->tx)
+		reschedule |= gve_tx_poll(block, -1);
+	if (block->rx)
+		reschedule |= gve_rx_poll(block, -1);
+	if (reschedule && napi_reschedule(napi))
+		writel(cpu_to_be32(GVE_IRQ_MASK), irq_doorbell);
+
+	return 0;
+}
+
 static int gve_alloc_notify_blocks(struct gve_priv *priv)
 {
 	int num_vecs_requested = priv->num_ntfy_blks + 1;
@@ -79,10 +141,23 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		goto abort_with_msix_vectors;
 	}
 	if (vecs_enabled != num_vecs_requested) {
-		priv->num_ntfy_blks = (vecs_enabled - 1) & ~0x1;
+		int new_num_ntfy_blks = (vecs_enabled - 1) & ~0x1;
+		int vecs_per_type = new_num_ntfy_blks / 2;
+		int vecs_left = new_num_ntfy_blks % 2;
+
+		priv->num_ntfy_blks = new_num_ntfy_blks;
+		priv->tx_cfg.max_queues = min_t(int, priv->tx_cfg.max_queues,
+						vecs_per_type);
+		priv->rx_cfg.max_queues = min_t(int, priv->rx_cfg.max_queues,
+						vecs_per_type + vecs_left);
 		dev_err(&priv->pdev->dev,
-			"Only received %d msix. Lowering number of notification blocks to %d\n",
-			vecs_enabled, priv->num_ntfy_blks);
+			"Could not enable desired msix, only enabled %d, adjusting tx max queues to %d, and rx max queues to %d\n",
+			vecs_enabled, priv->tx_cfg.max_queues,
+			priv->rx_cfg.max_queues);
+		if (priv->tx_cfg.num_queues > priv->tx_cfg.max_queues)
+			priv->tx_cfg.num_queues = priv->tx_cfg.max_queues;
+		if (priv->rx_cfg.num_queues > priv->rx_cfg.max_queues)
+			priv->rx_cfg.num_queues = priv->rx_cfg.max_queues;
 	}
 	/* Half the notification blocks go to TX and half to RX */
 	active_cpus = min_t(int, priv->num_ntfy_blks / 2, num_online_cpus());
@@ -219,6 +294,464 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 	gve_clear_device_resources_ok(priv);
 }
 
+void gve_add_napi(struct gve_priv *priv, int ntfy_idx)
+{
+	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+	netif_napi_add(priv->dev, &block->napi, gve_napi_poll,
+		       NAPI_POLL_WEIGHT);
+}
+
+void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
+{
+	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+	netif_napi_del(&block->napi);
+}
+
+static int gve_register_qpls(struct gve_priv *priv)
+{
+	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int err;
+	int i;
+
+	for (i = 0; i < num_qpls; i++) {
+		err = gve_adminq_register_page_list(priv, &priv->qpls[i]);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "failed to register queue page list %d\n",
+				  priv->qpls[i].id);
+			return err;
+		}
+	}
+	return 0;
+}
+
+static int gve_unregister_qpls(struct gve_priv *priv)
+{
+	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int err;
+	int i;
+
+	for (i = 0; i < num_qpls; i++) {
+		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to unregister queue page list %d\n",
+				  priv->qpls[i].id);
+			return err;
+		}
+	}
+	return 0;
+}
+
+static int gve_create_rings(struct gve_priv *priv)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		err = gve_adminq_create_tx_queue(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev, "failed to create tx queue %d\n",
+				  i);
+			return err;
+		}
+		netif_dbg(priv, drv, priv->dev, "created tx queue %d\n", i);
+	}
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		err = gve_adminq_create_rx_queue(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev, "failed to create rx queue %d\n",
+				  i);
+			return err;
+		}
+		/* Rx data ring has been prefilled with packet buffers at
+		 * queue allocation time.
+		 * Write the doorbell to provide descriptor slots and packet
+		 * buffers to the NIC.
+		 */
+		gve_rx_write_doorbell(priv, &priv->rx[i]);
+		netif_dbg(priv, drv, priv->dev, "created rx queue %d\n", i);
+	}
+
+	return 0;
+}
+
+static int gve_alloc_rings(struct gve_priv *priv)
+{
+	int ntfy_idx;
+	int err;
+	int i;
+
+	/* Setup tx rings */
+	priv->tx = kvzalloc(priv->tx_cfg.num_queues * sizeof(*priv->tx),
+			    GFP_KERNEL);
+	if (!priv->tx)
+		return -ENOMEM;
+	err = gve_tx_alloc_rings(priv);
+	if (err)
+		goto free_tx;
+	/* Setup rx rings */
+	priv->rx = kvzalloc(priv->rx_cfg.num_queues * sizeof(*priv->rx),
+			    GFP_KERNEL);
+	if (!priv->rx) {
+		err = -ENOMEM;
+		goto free_tx_queue;
+	}
+	err = gve_rx_alloc_rings(priv);
+	if (err)
+		goto free_rx;
+	/* Add tx napi */
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
+		gve_add_napi(priv, ntfy_idx);
+	}
+	/* Add rx napi */
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		ntfy_idx = gve_rx_idx_to_ntfy(priv, i);
+		gve_add_napi(priv, ntfy_idx);
+	}
+
+	return 0;
+
+free_rx:
+	kfree(priv->rx);
+free_tx_queue:
+	gve_tx_free_rings(priv);
+free_tx:
+	kfree(priv->tx);
+	return err;
+}
+
+static int gve_destroy_rings(struct gve_priv *priv)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		err = gve_adminq_destroy_tx_queue(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "failed to destroy tx queue %d\n",
+				  i);
+			return err;
+		}
+		netif_dbg(priv, drv, priv->dev, "destroyed tx queue %d\n", i);
+	}
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		err = gve_adminq_destroy_rx_queue(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "failed to destroy rx queue %d\n",
+				  i);
+			return err;
+		}
+		netif_dbg(priv, drv, priv->dev, "destroyed rx queue %d\n", i);
+	}
+	return 0;
+}
+
+static void gve_free_rings(struct gve_priv *priv)
+{
+	int ntfy_idx;
+	int i;
+
+	if (priv->tx) {
+		for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+			ntfy_idx = gve_tx_idx_to_ntfy(priv, i);
+			gve_remove_napi(priv, ntfy_idx);
+		}
+		gve_tx_free_rings(priv);
+		kfree(priv->tx);
+	}
+	if (priv->rx) {
+		for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+			ntfy_idx = gve_rx_idx_to_ntfy(priv, i);
+			gve_remove_napi(priv, ntfy_idx);
+		}
+		gve_rx_free_rings(priv);
+		kfree(priv->rx);
+	}
+}
+
+int gve_alloc_page(struct device *dev, struct page **page, dma_addr_t *dma,
+		   enum dma_data_direction dir)
+{
+	*page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	*dma = dma_map_page(dev, *page, 0, PAGE_SIZE, dir);
+	if (dma_mapping_error(dev, *dma)) {
+		put_page(*page);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
+				     int pages)
+{
+	struct gve_queue_page_list *qpl = &priv->qpls[id];
+	int err;
+	int i;
+
+	if (pages + priv->num_registered_pages > priv->max_registered_pages) {
+		netif_err(priv, drv, priv->dev,
+			  "Reached max number of registered pages %llu > %llu\n",
+			  pages + priv->num_registered_pages,
+			  priv->max_registered_pages);
+		return -EINVAL;
+	}
+
+	qpl->id = id;
+	qpl->num_entries = pages;
+	qpl->pages = kvzalloc(pages * sizeof(*qpl->pages), GFP_KERNEL);
+	/* caller handles clean up */
+	if (!qpl->pages)
+		return -ENOMEM;
+	qpl->page_buses = kvzalloc(pages * sizeof(*qpl->page_buses),
+				   GFP_KERNEL);
+	/* caller handles clean up */
+	if (!qpl->page_buses)
+		return -ENOMEM;
+
+	for (i = 0; i < pages; i++) {
+		err = gve_alloc_page(&priv->pdev->dev, &qpl->pages[i],
+				     &qpl->page_buses[i],
+				     gve_qpl_dma_dir(priv, id));
+		/* caller handles clean up */
+		if (err)
+			return -ENOMEM;
+	}
+	priv->num_registered_pages += pages;
+
+	return 0;
+}
+
+void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
+		   enum dma_data_direction dir)
+{
+	if (!dma_mapping_error(dev, dma))
+		dma_unmap_page(dev, dma, PAGE_SIZE, dir);
+	if (page)
+		put_page(page);
+}
+
+static void gve_free_queue_page_list(struct gve_priv *priv,
+				     int id)
+{
+	struct gve_queue_page_list *qpl = &priv->qpls[id];
+	int i;
+
+	if (!qpl->pages)
+		return;
+	if (!qpl->page_buses)
+		goto free_pages;
+
+	for (i = 0; i < qpl->num_entries; i++)
+		gve_free_page(&priv->pdev->dev, qpl->pages[i],
+			      qpl->page_buses[i], gve_qpl_dma_dir(priv, id));
+
+	kfree(qpl->page_buses);
+free_pages:
+	kfree(qpl->pages);
+	priv->num_registered_pages -= qpl->num_entries;
+}
+
+static int gve_alloc_qpls(struct gve_priv *priv)
+{
+	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int i, j;
+	int err;
+
+	priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
+	if (!priv->qpls)
+		return -ENOMEM;
+
+	for (i = 0; i < gve_num_tx_qpls(priv); i++) {
+		err = gve_alloc_queue_page_list(priv, i,
+						priv->tx_pages_per_qpl);
+		if (err)
+			goto free_qpls;
+	}
+	for (; i < num_qpls; i++) {
+		err = gve_alloc_queue_page_list(priv, i,
+						priv->rx_pages_per_qpl);
+		if (err)
+			goto free_qpls;
+	}
+
+	priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(num_qpls) *
+				     sizeof(unsigned long) * BITS_PER_BYTE;
+	priv->qpl_cfg.qpl_id_map = kvzalloc(BITS_TO_LONGS(num_qpls) *
+					    sizeof(unsigned long), GFP_KERNEL);
+	if (!priv->qpl_cfg.qpl_id_map)
+		goto free_qpls;
+
+	return 0;
+
+free_qpls:
+	for (j = 0; j <= i; j++)
+		gve_free_queue_page_list(priv, j);
+	kfree(priv->qpls);
+	return err;
+}
+
+static void gve_free_qpls(struct gve_priv *priv)
+{
+	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
+	int i;
+
+	kfree(priv->qpl_cfg.qpl_id_map);
+
+	for (i = 0; i < num_qpls; i++)
+		gve_free_queue_page_list(priv, i);
+
+	kfree(priv->qpls);
+}
+
+static int gve_change_mtu(struct net_device *dev, int new_mtu)
+{
+	dev->mtu = new_mtu;
+	return 0;
+}
+
+static void gve_turndown(struct gve_priv *priv);
+static void gve_turnup(struct gve_priv *priv);
+
+static int gve_open(struct net_device *dev)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	int err;
+
+	err = gve_alloc_qpls(priv);
+	if (err)
+		return err;
+	err = gve_alloc_rings(priv);
+	if (err)
+		goto free_qpls;
+
+	err = netif_set_real_num_tx_queues(dev, priv->tx_cfg.num_queues);
+	if (err)
+		goto free_rings;
+	err = netif_set_real_num_rx_queues(dev, priv->rx_cfg.num_queues);
+	if (err)
+		goto free_rings;
+
+	err = gve_register_qpls(priv);
+	if (err)
+		return err;
+	err = gve_create_rings(priv);
+	if (err)
+		return err;
+	gve_set_device_rings_ok(priv);
+
+	gve_turnup(priv);
+	netif_carrier_on(dev);
+	return 0;
+
+free_rings:
+	gve_free_rings(priv);
+free_qpls:
+	gve_free_qpls(priv);
+	return err;
+}
+
+static int gve_close(struct net_device *dev)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	int err;
+
+	netif_carrier_off(dev);
+	if (gve_get_device_rings_ok(priv)) {
+		gve_turndown(priv);
+		err = gve_destroy_rings(priv);
+		if (err)
+			return err;
+		err = gve_unregister_qpls(priv);
+		if (err)
+			return err;
+		gve_clear_device_rings_ok(priv);
+	}
+
+	gve_free_rings(priv);
+	gve_free_qpls(priv);
+	return 0;
+}
+
+static void gve_turndown(struct gve_priv *priv)
+{
+	int idx;
+
+	if (netif_carrier_ok(priv->dev))
+		netif_carrier_off(priv->dev);
+
+	if (!gve_get_napi_enabled(priv))
+		return;
+
+	/* Disable napi to prevent more work from coming in */
+	for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+		int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
+		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+		napi_disable(&block->napi);
+	}
+	for (idx = 0; idx < priv->rx_cfg.num_queues; idx++) {
+		int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
+		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+		napi_disable(&block->napi);
+	}
+
+	/* Stop tx queues */
+	netif_tx_disable(priv->dev);
+
+	gve_clear_napi_enabled(priv);
+}
+
+static void gve_turnup(struct gve_priv *priv)
+{
+	int idx;
+
+	/* Start the tx queues */
+	netif_tx_start_all_queues(priv->dev);
+
+	/* Enable napi and unmask interrupts for all queues */
+	for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+		int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
+		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+		napi_enable(&block->napi);
+		writel(cpu_to_be32(0), gve_irq_doorbell(priv, block));
+	}
+	for (idx = 0; idx < priv->rx_cfg.num_queues; idx++) {
+		int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
+		struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+		napi_enable(&block->napi);
+		writel(cpu_to_be32(0), gve_irq_doorbell(priv, block));
+	}
+
+	gve_set_napi_enabled(priv);
+}
+
+static void gve_tx_timeout(struct net_device *dev)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+
+	priv->tx_timeo_cnt++;
+}
+
+static const struct net_device_ops gve_netdev_ops = {
+	.ndo_start_xmit		=	gve_tx,
+	.ndo_open		=	gve_open,
+	.ndo_stop		=	gve_close,
+	.ndo_get_stats64	=	gve_get_stats,
+	.ndo_change_mtu		=	gve_change_mtu,
+	.ndo_tx_timeout         =       gve_tx_timeout,
+};
+
 static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 {
 	int num_ntfy;
@@ -264,12 +797,33 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		goto err;
 	}
 
+	priv->num_registered_pages = 0;
+	priv->rx_copybreak = GVE_DEFAULT_RX_COPYBREAK;
 	/* gvnic has one Notification Block per MSI-x vector, except for the
 	 * management vector
 	 */
 	priv->num_ntfy_blks = (num_ntfy - 1) & ~0x1;
 	priv->mgmt_msix_idx = priv->num_ntfy_blks;
 
+	priv->tx_cfg.max_queues =
+		min_t(int, priv->tx_cfg.max_queues, priv->num_ntfy_blks / 2);
+	priv->rx_cfg.max_queues =
+		min_t(int, priv->rx_cfg.max_queues, priv->num_ntfy_blks / 2);
+
+	priv->tx_cfg.num_queues = priv->tx_cfg.max_queues;
+	priv->rx_cfg.num_queues = priv->rx_cfg.max_queues;
+	if (priv->default_num_queues > 0) {
+		priv->tx_cfg.num_queues = min_t(int, priv->default_num_queues,
+						priv->tx_cfg.num_queues);
+		priv->rx_cfg.num_queues = min_t(int, priv->default_num_queues,
+						priv->rx_cfg.num_queues);
+	}
+
+	netif_info(priv, drv, priv->dev, "TX queues %d, RX queues %d\n",
+		   priv->tx_cfg.num_queues, priv->rx_cfg.num_queues);
+	netif_info(priv, drv, priv->dev, "Max TX queues %d, Max RX queues %d\n",
+		   priv->tx_cfg.max_queues, priv->rx_cfg.max_queues);
+
 setup_device:
 	err = gve_setup_device_resources(priv);
 	if (!err)
@@ -336,6 +890,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	reg_bar = pci_iomap(pdev, GVE_REGISTER_BAR, 0);
 	if (!reg_bar) {
+		dev_err(&pdev->dev, "Failed to map pci bar!\n");
 		err = -ENOMEM;
 		goto abort_with_pci_region;
 	}
@@ -359,6 +914,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	pci_set_drvdata(pdev, dev);
+	dev->netdev_ops = &gve_netdev_ops;
 	/* advertise features */
 	dev->hw_features = NETIF_F_HIGHDMA;
 	dev->hw_features |= NETIF_F_SG;
@@ -369,6 +925,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_RXHASH;
 	dev->features = dev->hw_features;
+	dev->watchdog_timeo = 5 * HZ;
 	dev->min_mtu = ETH_MIN_MTU;
 	netif_carrier_off(dev);
 
@@ -379,6 +936,8 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->reg_bar0 = reg_bar;
 	priv->db_bar2 = db_bar;
 	priv->state_flags = 0x0;
+	priv->tx_cfg.max_queues = max_tx_queues;
+	priv->rx_cfg.max_queues = max_rx_queues;
 
 	err = gve_init_priv(priv, false);
 	if (err)
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
new file mode 100644
index 000000000000..5bcf2508d929
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#include "gve.h"
+#include "gve_adminq.h"
+#include <linux/etherdevice.h>
+
+void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
+{
+	struct gve_notify_block *block =
+			&priv->ntfy_blocks[gve_rx_idx_to_ntfy(priv, queue_idx)];
+
+	block->rx = NULL;
+}
+
+static void gve_rx_free_ring(struct gve_priv *priv, int idx)
+{
+	struct gve_rx_ring *rx = &priv->rx[idx];
+	struct device *dev = &priv->pdev->dev;
+	size_t bytes;
+	u32 slots;
+
+	gve_rx_remove_from_block(priv, idx);
+
+	bytes = sizeof(struct gve_rx_desc) * priv->rx_desc_cnt;
+	dma_free_coherent(dev, bytes, rx->desc.desc_ring, rx->desc.bus);
+	rx->desc.desc_ring = NULL;
+
+	dma_free_coherent(dev, sizeof(*rx->q_resources),
+			  rx->q_resources, rx->q_resources_bus);
+	rx->q_resources = NULL;
+
+	gve_unassign_qpl(priv, rx->data.qpl->id);
+	rx->data.qpl = NULL;
+	kfree(rx->data.page_info);
+
+	slots = rx->data.mask + 1;
+	bytes = sizeof(*rx->data.data_ring) * slots;
+	dma_free_coherent(dev, bytes, rx->data.data_ring,
+			  rx->data.data_bus);
+	rx->data.data_ring = NULL;
+	netif_dbg(priv, drv, priv->dev, "freed rx ring %d\n", idx);
+}
+
+static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
+				struct gve_rx_data_slot *slot,
+				dma_addr_t addr, struct page *page)
+{
+	page_info->page = page;
+	page_info->page_offset = 0;
+	page_info->page_address = page_address(page);
+	slot->qpl_offset = cpu_to_be64(addr);
+}
+
+static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
+{
+	struct gve_priv *priv = rx->gve;
+	u32 slots, size;
+	int i;
+
+	/* Allocate one page per Rx queue slot. Each page is split into two
+	 * packet buffers, when possible we "page flip" between the two.
+	 */
+	slots = rx->data.mask + 1;
+	size = slots * PAGE_SIZE;
+
+	rx->data.page_info = kvzalloc(slots *
+				      sizeof(*rx->data.page_info), GFP_KERNEL);
+	if (!rx->data.page_info)
+		return -ENOMEM;
+
+	rx->data.qpl = gve_assign_rx_qpl(priv);
+
+	for (i = 0; i < slots; i++) {
+		struct page *page = rx->data.qpl->pages[i];
+		dma_addr_t addr = i * PAGE_SIZE;
+
+		gve_setup_rx_buffer(&rx->data.page_info[i],
+				    &rx->data.data_ring[i], addr, page);
+	}
+
+	return slots;
+}
+
+static void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
+{
+	u32 ntfy_idx = gve_rx_idx_to_ntfy(priv, queue_idx);
+	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+	struct gve_rx_ring *rx = &priv->rx[queue_idx];
+
+	block->rx = rx;
+	rx->ntfy_id = ntfy_idx;
+}
+
+static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
+{
+	struct gve_rx_ring *rx = &priv->rx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	u32 slots, npages, gve_desc_per_page;
+	size_t bytes;
+	int err;
+
+	netif_dbg(priv, drv, priv->dev, "allocating rx ring\n");
+	/* Make sure everything is zeroed to start with */
+	memset(rx, 0, sizeof(*rx));
+
+	rx->gve = priv;
+	rx->q_num = idx;
+
+	slots = priv->rx_pages_per_qpl;
+	rx->data.mask = slots - 1;
+
+	/* alloc rx data ring */
+	bytes = sizeof(*rx->data.data_ring) * slots;
+	rx->data.data_ring = dma_alloc_coherent(hdev, bytes,
+						&rx->data.data_bus,
+						GFP_KERNEL);
+	if (!rx->data.data_ring)
+		return -ENOMEM;
+	rx->desc.fill_cnt = gve_prefill_rx_pages(rx);
+	if (rx->desc.fill_cnt < 0) {
+		rx->desc.fill_cnt = 0;
+		err = -ENOMEM;
+		goto abort_with_slots;
+	}
+	/* Ensure data ring slots (packet buffers) are visible. */
+	dma_wmb();
+
+	/* Alloc gve_queue_resources */
+	rx->q_resources =
+		dma_alloc_coherent(hdev,
+				   sizeof(*rx->q_resources),
+				   &rx->q_resources_bus,
+				   GFP_KERNEL);
+	if (!rx->q_resources) {
+		err = -ENOMEM;
+		goto abort_filled;
+	}
+	netif_dbg(priv, drv, priv->dev, "rx[%d]->data.data_bus=%lx\n", idx,
+		  (unsigned long)rx->data.data_bus);
+
+	/* alloc rx desc ring */
+	gve_desc_per_page = PAGE_SIZE / sizeof(struct gve_rx_desc);
+	bytes = sizeof(struct gve_rx_desc) * priv->rx_desc_cnt;
+	npages = bytes / PAGE_SIZE;
+	if (npages * PAGE_SIZE != bytes) {
+		err = -EIO;
+		goto abort_with_q_resources;
+	}
+
+	rx->desc.desc_ring = dma_alloc_coherent(hdev, bytes, &rx->desc.bus,
+						GFP_KERNEL);
+	if (!rx->desc.desc_ring) {
+		err = -ENOMEM;
+		goto abort_with_q_resources;
+	}
+	rx->desc.mask = slots - 1;
+	rx->desc.cnt = 0;
+	rx->desc.seqno = 1;
+	gve_rx_add_to_block(priv, idx);
+
+	return 0;
+
+abort_with_q_resources:
+	dma_free_coherent(hdev, sizeof(*rx->q_resources),
+			  rx->q_resources, rx->q_resources_bus);
+	rx->q_resources = NULL;
+abort_filled:
+	kfree(rx->data.page_info);
+abort_with_slots:
+	bytes = sizeof(*rx->data.data_ring) * slots;
+	dma_free_coherent(hdev, bytes, rx->data.data_ring, rx->data.data_bus);
+	rx->data.data_ring = NULL;
+
+	return err;
+}
+
+int gve_rx_alloc_rings(struct gve_priv *priv)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		err = gve_rx_alloc_ring(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to alloc rx ring=%d: err=%d\n",
+				  i, err);
+			break;
+		}
+	}
+	/* Unallocate if there was an error */
+	if (err) {
+		int j;
+
+		for (j = 0; j < i; j++)
+			gve_rx_free_ring(priv, j);
+	}
+	return err;
+}
+
+void gve_rx_free_rings(struct gve_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->rx_cfg.num_queues; i++)
+		gve_rx_free_ring(priv, i);
+}
+
+void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx)
+{
+	u32 db_idx = be32_to_cpu(rx->q_resources->db_index);
+
+	writel(cpu_to_be32(rx->desc.fill_cnt), &priv->db_bar2[db_idx]);
+}
+
+static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
+{
+	if (likely(pkt_flags & (GVE_RXF_TCP | GVE_RXF_UDP)))
+		return PKT_HASH_TYPE_L4;
+	if (pkt_flags & (GVE_RXF_IPV4 | GVE_RXF_IPV6))
+		return PKT_HASH_TYPE_L3;
+	return PKT_HASH_TYPE_L2;
+}
+
+static struct sk_buff *gve_rx_copy(struct net_device *dev,
+				   struct napi_struct *napi,
+				   struct gve_rx_slot_page_info *page_info,
+				   u16 len)
+{
+	struct sk_buff *skb = napi_alloc_skb(napi, len);
+	void *va = page_info->page_address + GVE_RX_PAD +
+		   page_info->page_offset;
+
+	if (unlikely(!skb))
+		return NULL;
+
+	__skb_put(skb, len);
+
+	skb_copy_to_linear_data(skb, va, len);
+
+	skb->protocol = eth_type_trans(skb, dev);
+	return skb;
+}
+
+static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
+					struct napi_struct *napi,
+					struct gve_rx_slot_page_info *page_info,
+					u16 len)
+{
+	struct sk_buff *skb = napi_get_frags(napi);
+
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_add_rx_frag(skb, 0, page_info->page,
+			page_info->page_offset +
+			GVE_RX_PAD, len, PAGE_SIZE / 2);
+
+	return skb;
+}
+
+static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
+			     struct gve_rx_data_slot *data_ring)
+{
+	u64 addr = be64_to_cpu(data_ring->qpl_offset);
+
+	page_info->page_offset ^= PAGE_SIZE / 2;
+	addr ^= PAGE_SIZE / 2;
+	data_ring->qpl_offset = cpu_to_be64(addr);
+}
+
+static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
+		   netdev_features_t feat)
+{
+	struct gve_rx_slot_page_info *page_info;
+	struct gve_priv *priv = rx->gve;
+	struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
+	struct net_device *dev = priv->dev;
+	struct sk_buff *skb;
+	int pagecount;
+	u16 len;
+	u32 idx;
+
+	/* drop this packet */
+	if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR))
+		return true;
+
+	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
+	idx = rx->data.cnt & rx->data.mask;
+	page_info = &rx->data.page_info[idx];
+
+	/* gvnic can only receive into registered segments. If the buffer
+	 * can't be recycled, our only choice is to copy the data out of
+	 * it so that we can return it to the device.
+	 */
+
+#if PAGE_SIZE == 4096
+	if (len <= priv->rx_copybreak) {
+		/* Just copy small packets */
+		skb = gve_rx_copy(dev, napi, page_info, len);
+		goto have_skb;
+	}
+	if (unlikely(!gve_can_recycle_pages(dev))) {
+		skb = gve_rx_copy(dev, napi, page_info, len);
+		goto have_skb;
+	}
+	pagecount = page_count(page_info->page);
+	if (pagecount == 1) {
+		/* No part of this page is used by any SKBs; we attach
+		 * the page fragment to a new SKB and pass it up the
+		 * stack.
+		 */
+		skb = gve_rx_add_frags(dev, napi, page_info, len);
+		if (!skb)
+			return true;
+		/* Make sure the kernel stack can't release the page */
+		get_page(page_info->page);
+		/* "flip" to other packet buffer on this page */
+		gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
+	} else if (pagecount >= 2) {
+		/* We have previously passed the other half of this
+		 * page up the stack, but it has not yet been freed.
+		 */
+		skb = gve_rx_copy(dev, napi, page_info, len);
+	} else {
+		WARN(pagecount < 1, "Pagecount should never be < 1");
+		return false;
+	}
+#else
+	skb = gve_rx_copy(dev, napi, page_info, len);
+#endif
+
+have_skb:
+	if (!skb)
+		return true;
+
+	rx->data.cnt++;
+
+	if (likely(feat & NETIF_F_RXCSUM)) {
+		/* NIC passes up the partial sum */
+		if (rx_desc->csum)
+			skb->ip_summed = CHECKSUM_COMPLETE;
+		else
+			skb->ip_summed = CHECKSUM_NONE;
+		skb->csum = rx_desc->csum;
+	}
+
+	/* parse flags & pass relevant info up */
+	if (likely(feat & NETIF_F_RXHASH) &&
+	    gve_needs_rss(rx_desc->flags_seq))
+		skb_set_hash(skb, be32_to_cpu(rx_desc->rss_hash),
+			     gve_rss_type(rx_desc->flags_seq));
+
+	if (skb_is_nonlinear(skb))
+		napi_gro_frags(napi);
+	else
+		napi_gro_receive(napi, skb);
+	return true;
+}
+
+static bool gve_rx_work_pending(struct gve_rx_ring *rx)
+{
+	struct gve_rx_desc *desc;
+	u16 flags_seq;
+	u32 next_idx;
+
+	next_idx = rx->desc.cnt & rx->desc.mask;
+	desc = rx->desc.desc_ring + next_idx;
+
+	flags_seq = desc->flags_seq;
+	/* Make sure we have synchronized the seq no with the device */
+	smp_rmb();
+
+	return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
+}
+
+bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
+		       netdev_features_t feat)
+{
+	struct gve_priv *priv = rx->gve;
+	struct gve_rx_desc *desc;
+	u32 cnt = rx->desc.cnt;
+	u32 idx = cnt & rx->desc.mask;
+	u32 work_done = 0;
+	u64 bytes = 0;
+
+	desc = rx->desc.desc_ring + idx;
+	while ((GVE_SEQNO(desc->flags_seq) == rx->desc.seqno) &&
+	       work_done < budget) {
+		netif_info(priv, rx_status, priv->dev,
+			   "[%d] idx=%d desc=%p desc->flags_seq=0x%x\n",
+			   rx->q_num, idx, desc, desc->flags_seq);
+		netif_info(priv, rx_status, priv->dev,
+			   "[%d] seqno=%d rx->desc.seqno=%d\n",
+			   rx->q_num, GVE_SEQNO(desc->flags_seq),
+			   rx->desc.seqno);
+		bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
+		if (!gve_rx(rx, desc, feat))
+			return false;
+		cnt++;
+		idx = cnt & rx->desc.mask;
+		desc = rx->desc.desc_ring + idx;
+		rx->desc.seqno = gve_next_seqno(rx->desc.seqno);
+		work_done++;
+	}
+
+	if (!work_done)
+		return false;
+
+	rx->rpackets += work_done;
+	rx->rbytes += bytes;
+	rx->desc.cnt = cnt;
+	rx->desc.fill_cnt += work_done;
+
+	/* restock desc ring slots */
+	dma_wmb();	/* Ensure descs are visible before ringing doorbell */
+	gve_rx_write_doorbell(priv, rx);
+	return gve_rx_work_pending(rx);
+}
+
+bool gve_rx_poll(struct gve_notify_block *block, int budget)
+{
+	struct gve_rx_ring *rx = block->rx;
+	netdev_features_t feat;
+	bool repoll = false;
+
+	feat = block->napi.dev->features;
+
+	/* If budget is 0, do all the work */
+	if (budget == 0)
+		budget = INT_MAX;
+
+	if (budget > 0)
+		repoll |= gve_clean_rx_done(rx, budget, feat);
+	else
+		repoll |= gve_rx_work_pending(rx);
+	return repoll;
+}
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
new file mode 100644
index 000000000000..221a2e7d04fb
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -0,0 +1,584 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#include "gve.h"
+#include "gve_adminq.h"
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/vmalloc.h>
+#include <linux/skbuff.h>
+
+static inline void gve_tx_put_doorbell(struct gve_priv *priv,
+				       struct gve_queue_resources *q_resources,
+				       __be32 val)
+{
+	writel(val, &priv->db_bar2[be32_to_cpu(q_resources->db_index)]);
+}
+
+/* gvnic can only transmit from a Registered Segment.
+ * We copy skb payloads into the registered segment before writing Tx
+ * descriptors and ringing the Tx doorbell.
+ *
+ * gve_tx_fifo_* manages the Registered Segment as a FIFO - clients must
+ * free allocations in the order they were allocated.
+ */
+
+static int gve_tx_fifo_init(struct gve_priv *priv, struct gve_tx_fifo *fifo)
+{
+	fifo->base = vmap(fifo->qpl->pages, fifo->qpl->num_entries, VM_MAP,
+			  PAGE_KERNEL);
+	if (unlikely(!fifo->base)) {
+		netif_err(priv, drv, priv->dev, "Failed to vmap fifo, qpl_id = %d\n",
+			  fifo->qpl->id);
+		return -ENOMEM;
+	}
+
+	fifo->size = fifo->qpl->num_entries * PAGE_SIZE;
+	atomic_set(&fifo->available, fifo->size);
+	fifo->head = 0;
+	return 0;
+}
+
+static void gve_tx_fifo_release(struct gve_priv *priv, struct gve_tx_fifo *fifo)
+{
+	WARN(atomic_read(&fifo->available) != fifo->size,
+	     "Releasing non-empty fifo");
+
+	vunmap(fifo->base);
+}
+
+static int gve_tx_fifo_pad_alloc_one_frag(struct gve_tx_fifo *fifo,
+					  size_t bytes)
+{
+	return (fifo->head + bytes < fifo->size) ? 0 : fifo->size - fifo->head;
+}
+
+static bool gve_tx_fifo_can_alloc(struct gve_tx_fifo *fifo, size_t bytes)
+{
+	return (atomic_read(&fifo->available) <= bytes) ? false : true;
+}
+
+/* gve_tx_alloc_fifo - Allocate fragment(s) from Tx FIFO
+ * @fifo: FIFO to allocate from
+ * @bytes: Allocation size
+ * @iov: Scatter-gather elements to fill with allocation fragment base/len
+ *
+ * Returns number of valid elements in iov[] or negative on error.
+ *
+ * Allocations from a given FIFO must be externally synchronized but concurrent
+ * allocation and frees are allowed.
+ */
+static int gve_tx_alloc_fifo(struct gve_tx_fifo *fifo, size_t bytes,
+			     struct gve_tx_iovec iov[2])
+{
+	size_t overflow, padding;
+	u32 aligned_head;
+	int nfrags = 0;
+
+	if (!bytes)
+		return 0;
+
+	/* This check happens before we know how much padding is needed to
+	 * align to a cacheline boundary for the payload, but that is fine,
+	 * because the FIFO head always start aligned, and the FIFO's boundaries
+	 * are aligned, so if there is space for the data, there is space for
+	 * the padding to the next alignment.
+	 */
+	WARN(!gve_tx_fifo_can_alloc(fifo, bytes),
+	     "Reached %s when there's not enough space in the fifo", __func__);
+
+	nfrags++;
+
+	iov[0].iov_offset = fifo->head;
+	iov[0].iov_len = bytes;
+	fifo->head += bytes;
+
+	if (fifo->head > fifo->size) {
+		/* If the allocation did not fit in the tail fragment of the
+		 * FIFO, also use the head fragment.
+		 */
+		nfrags++;
+		overflow = fifo->head - fifo->size;
+		iov[0].iov_len -= overflow;
+		iov[1].iov_offset = 0;	/* Start of fifo*/
+		iov[1].iov_len = overflow;
+
+		fifo->head = overflow;
+	}
+
+	/* Re-align to a cacheline boundary */
+	aligned_head = L1_CACHE_ALIGN(fifo->head);
+	padding = aligned_head - fifo->head;
+	iov[nfrags - 1].iov_padding = padding;
+	atomic_sub(bytes + padding, &fifo->available);
+	fifo->head = aligned_head;
+
+	if (fifo->head == fifo->size)
+		fifo->head = 0;
+
+	return nfrags;
+}
+
+/* gve_tx_free_fifo - Return space to Tx FIFO
+ * @fifo: FIFO to return fragments to
+ * @bytes: Bytes to free
+ */
+static void gve_tx_free_fifo(struct gve_tx_fifo *fifo, size_t bytes)
+{
+	atomic_add(bytes, &fifo->available);
+}
+
+static void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx)
+{
+	struct gve_notify_block *block =
+			&priv->ntfy_blocks[gve_tx_idx_to_ntfy(priv, queue_idx)];
+
+	block->tx = NULL;
+}
+
+static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
+			     u32 to_do, bool try_to_wake);
+
+void gve_tx_free_ring(struct gve_priv *priv, int idx)
+{
+	struct gve_tx_ring *tx = &priv->tx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	size_t bytes;
+	u32 slots;
+
+	gve_tx_remove_from_block(priv, idx);
+	slots = tx->mask + 1;
+	gve_clean_tx_done(priv, tx, tx->req, false);
+	netdev_tx_reset_queue(tx->netdev_txq);
+
+	dma_free_coherent(hdev, sizeof(*tx->q_resources),
+			  tx->q_resources, tx->q_resources_bus);
+	tx->q_resources = NULL;
+
+	gve_tx_fifo_release(priv, &tx->tx_fifo);
+	gve_unassign_qpl(priv, tx->tx_fifo.qpl->id);
+	tx->tx_fifo.qpl = NULL;
+
+	bytes = sizeof(*tx->desc) * slots;
+	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
+	tx->desc = NULL;
+
+	vfree(tx->info);
+	tx->info = NULL;
+
+	netif_dbg(priv, drv, priv->dev, "freed tx queue %d\n", idx);
+}
+
+static void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx)
+{
+	int ntfy_idx = gve_tx_idx_to_ntfy(priv, queue_idx);
+	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+	struct gve_tx_ring *tx = &priv->tx[queue_idx];
+
+	block->tx = tx;
+	tx->ntfy_id = ntfy_idx;
+}
+
+static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
+{
+	struct gve_tx_ring *tx = &priv->tx[idx];
+	struct device *hdev = &priv->pdev->dev;
+	u32 slots = priv->tx_desc_cnt;
+	size_t bytes;
+
+	/* Make sure everything is zeroed to start */
+	memset(tx, 0, sizeof(*tx));
+	tx->q_num = idx;
+
+	tx->mask = slots - 1;
+
+	/* alloc metadata */
+	tx->info = vzalloc(sizeof(*tx->info) * slots);
+	if (!tx->info)
+		return -ENOMEM;
+
+	/* alloc tx queue */
+	bytes = sizeof(*tx->desc) * slots;
+	tx->desc = dma_alloc_coherent(hdev, bytes, &tx->bus, GFP_KERNEL);
+	if (!tx->desc)
+		goto abort_with_info;
+
+	tx->tx_fifo.qpl = gve_assign_tx_qpl(priv);
+
+	/* map Tx FIFO */
+	if (gve_tx_fifo_init(priv, &tx->tx_fifo))
+		goto abort_with_desc;
+
+	tx->q_resources =
+		dma_alloc_coherent(hdev,
+				   sizeof(*tx->q_resources),
+				   &tx->q_resources_bus,
+				   GFP_KERNEL);
+	if (!tx->q_resources)
+		goto abort_with_fifo;
+
+	netif_dbg(priv, drv, priv->dev, "tx[%d]->bus=%lx\n", idx,
+		  (unsigned long)tx->bus);
+	tx->netdev_txq = netdev_get_tx_queue(priv->dev, idx);
+	gve_tx_add_to_block(priv, idx);
+
+	return 0;
+
+abort_with_fifo:
+	gve_tx_fifo_release(priv, &tx->tx_fifo);
+abort_with_desc:
+	dma_free_coherent(hdev, bytes, tx->desc, tx->bus);
+	tx->desc = NULL;
+abort_with_info:
+	vfree(tx->info);
+	tx->info = NULL;
+	return -ENOMEM;
+}
+
+int gve_tx_alloc_rings(struct gve_priv *priv)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		err = gve_tx_alloc_ring(priv, i);
+		if (err) {
+			netif_err(priv, drv, priv->dev,
+				  "Failed to alloc tx ring=%d: err=%d\n",
+				  i, err);
+			break;
+		}
+	}
+	/* Unallocate if there was an error */
+	if (err) {
+		int j;
+
+		for (j = 0; j < i; j++)
+			gve_tx_free_ring(priv, j);
+	}
+	return err;
+}
+
+void gve_tx_free_rings(struct gve_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->tx_cfg.num_queues; i++)
+		gve_tx_free_ring(priv, i);
+}
+
+/* gve_tx_avail - Calculates the number of slots available in the ring
+ * @tx: tx ring to check
+ *
+ * Returns the number of slots available
+ *
+ * The capacity of the queue is mask + 1. We don't need to reserve an entry.
+ **/
+static inline u32 gve_tx_avail(struct gve_tx_ring *tx)
+{
+	return tx->mask + 1 - (tx->req - tx->done);
+}
+
+static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
+					      struct sk_buff *skb)
+{
+	int pad_bytes, align_hdr_pad;
+	int bytes;
+	int hlen;
+
+	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) +
+				 tcp_hdrlen(skb) : skb_headlen(skb);
+
+	pad_bytes = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo,
+						   hlen);
+	/* We need to take into account the header alignment padding. */
+	align_hdr_pad = L1_CACHE_ALIGN(hlen) - hlen;
+	bytes = align_hdr_pad + pad_bytes + skb->len;
+
+	return bytes;
+}
+
+/* The most descriptors we could need are 3 - 1 for the headers, 1 for
+ * the beginning of the payload at the end of the FIFO, and 1 if the
+ * payload wraps to the beginning of the FIFO.
+ */
+#define MAX_TX_DESC_NEEDED	3
+
+/* Check if sufficient resources (descriptor ring space, FIFO space) are
+ * available to transmit the given number of bytes.
+ */
+static inline bool gve_can_tx(struct gve_tx_ring *tx, int bytes_required)
+{
+	return (gve_tx_avail(tx) >= MAX_TX_DESC_NEEDED &&
+		gve_tx_fifo_can_alloc(&tx->tx_fifo, bytes_required));
+}
+
+/* Stops the queue if the skb cannot be transmitted. */
+static int gve_maybe_stop_tx(struct gve_tx_ring *tx, struct sk_buff *skb)
+{
+	int bytes_required;
+
+	bytes_required = gve_skb_fifo_bytes_required(tx, skb);
+	if (likely(gve_can_tx(tx, bytes_required)))
+		return 0;
+
+	/* No space, so stop the queue */
+	tx->stop_queue++;
+	netif_tx_stop_queue(tx->netdev_txq);
+	smp_mb();	/* sync with restarting queue in gve_clean_tx_done() */
+
+	/* Now check for resources again, in case gve_clean_tx_done() freed
+	 * resources after we checked and we stopped the queue after
+	 * gve_clean_tx_done() checked.
+	 *
+	 * gve_maybe_stop_tx()			gve_clean_tx_done()
+	 *   nsegs/can_alloc test failed
+	 *					  gve_tx_free_fifo()
+	 *					  if (tx queue stopped)
+	 *					    netif_tx_queue_wake()
+	 *   netif_tx_stop_queue()
+	 *   Need to check again for space here!
+	 */
+	if (likely(!gve_can_tx(tx, bytes_required)))
+		return -EBUSY;
+
+	netif_tx_start_queue(tx->netdev_txq);
+	tx->wake_queue++;
+	return 0;
+}
+
+static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
+				 struct sk_buff *skb, bool is_gso,
+				 int l4_hdr_offset, u32 desc_cnt,
+				 u16 hlen, u64 addr)
+{
+	/* l4_hdr_offset and csum_offset are in units of 16-bit words */
+	if (is_gso) {
+		pkt_desc->pkt.type_flags = GVE_TXD_TSO | GVE_TXF_L4CSUM;
+		pkt_desc->pkt.l4_csum_offset = skb->csum_offset >> 1;
+		pkt_desc->pkt.l4_hdr_offset = l4_hdr_offset >> 1;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		pkt_desc->pkt.type_flags = GVE_TXD_STD | GVE_TXF_L4CSUM;
+		pkt_desc->pkt.l4_csum_offset = skb->csum_offset >> 1;
+		pkt_desc->pkt.l4_hdr_offset = l4_hdr_offset >> 1;
+	} else {
+		pkt_desc->pkt.type_flags = GVE_TXD_STD;
+		pkt_desc->pkt.l4_csum_offset = 0;
+		pkt_desc->pkt.l4_hdr_offset = 0;
+	}
+	pkt_desc->pkt.desc_cnt = desc_cnt;
+	pkt_desc->pkt.len = cpu_to_be16(skb->len);
+	pkt_desc->pkt.seg_len = cpu_to_be16(hlen);
+	pkt_desc->pkt.seg_addr = cpu_to_be64(addr);
+}
+
+static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
+				 struct sk_buff *skb, bool is_gso,
+				 u16 len, u64 addr)
+{
+	seg_desc->seg.type_flags = GVE_TXD_SEG;
+	if (is_gso) {
+		if (skb_is_gso_v6(skb))
+			seg_desc->seg.type_flags |= GVE_TXSF_IPV6;
+		seg_desc->seg.l3_offset = skb_network_offset(skb) >> 1;
+		seg_desc->seg.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
+	}
+	seg_desc->seg.seg_len = cpu_to_be16(len);
+	seg_desc->seg.seg_addr = cpu_to_be64(addr);
+}
+
+static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
+{
+	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
+	union gve_tx_desc *pkt_desc, *seg_desc;
+	struct gve_tx_buffer_state *info;
+	bool is_gso = skb_is_gso(skb);
+	u32 idx = tx->req & tx->mask;
+	int payload_iov = 2;
+	int copy_offset;
+	u32 next_idx;
+	int i;
+
+	info = &tx->info[idx];
+	pkt_desc = &tx->desc[idx];
+
+	l4_hdr_offset = skb_checksum_start_offset(skb);
+	/* If the skb is gso, then we want the tcp header in the first segment
+	 * otherwise we want the linear portion of the skb (which will contain
+	 * the checksum because skb->csum_start and skb->csum_offset are given
+	 * relative to skb->head) in the first segment.
+	 */
+	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
+			skb_headlen(skb);
+
+	info->skb =  skb;
+	/* We don't want to split the header, so if necessary, pad to the end
+	 * of the fifo and then put the header at the beginning of the fifo.
+	 */
+	pad_bytes = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo, hlen);
+	hdr_nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, hlen + pad_bytes,
+				       &info->iov[0]);
+	WARN(!hdr_nfrags, "hdr_nfrags should never be 0!");
+	payload_nfrags = gve_tx_alloc_fifo(&tx->tx_fifo, skb->len - hlen,
+					   &info->iov[payload_iov]);
+
+	gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
+			     1 + payload_nfrags, hlen,
+			     info->iov[hdr_nfrags - 1].iov_offset);
+
+	skb_copy_bits(skb, 0,
+		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
+		      hlen);
+	copy_offset = hlen;
+
+	for (i = payload_iov; i < payload_nfrags + payload_iov; i++) {
+		next_idx = (tx->req + 1 + i - payload_iov) & tx->mask;
+		seg_desc = &tx->desc[next_idx];
+
+		gve_tx_fill_seg_desc(seg_desc, skb, is_gso,
+				     info->iov[i].iov_len,
+				     info->iov[i].iov_offset);
+
+		skb_copy_bits(skb, copy_offset,
+			      tx->tx_fifo.base + info->iov[i].iov_offset,
+			      info->iov[i].iov_len);
+		copy_offset += info->iov[i].iov_len;
+	}
+
+	return 1 + payload_nfrags;
+}
+
+netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
+{
+	struct gve_priv *priv = netdev_priv(dev);
+	struct gve_tx_ring *tx;
+	int nsegs;
+
+	WARN(skb_get_queue_mapping(skb) > priv->tx_cfg.num_queues,
+	     "skb queue index out of range");
+	tx = &priv->tx[skb_get_queue_mapping(skb)];
+	if (unlikely(gve_maybe_stop_tx(tx, skb))) {
+		/* We need to ring the txq doorbell -- we have stopped the Tx
+		 * queue for want of resources, but prior calls to gve_tx()
+		 * may have added descriptors without ringing the doorbell.
+		 */
+
+		/* Ensure tx descs from a prior gve_tx are visible before
+		 * ringing doorbell.
+		 */
+		dma_wmb();
+		gve_tx_put_doorbell(priv, tx->q_resources,
+				    cpu_to_be32(tx->req));
+		return NETDEV_TX_BUSY;
+	}
+	nsegs = gve_tx_add_skb(tx, skb);
+
+	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
+	skb_tx_timestamp(skb);
+
+	/* give packets to NIC */
+	tx->req += nsegs;
+
+	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
+		return NETDEV_TX_OK;
+
+	/* Ensure tx descs are visible before ringing doorbell */
+	dma_wmb();
+	gve_tx_put_doorbell(priv, tx->q_resources,
+			    cpu_to_be32(tx->req));
+	return NETDEV_TX_OK;
+}
+
+#define GVE_TX_START_THRESH	PAGE_SIZE
+
+static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
+			     u32 to_do, bool try_to_wake)
+{
+	struct gve_tx_buffer_state *info;
+	u64 pkts = 0, bytes = 0;
+	size_t space_freed = 0;
+	struct sk_buff *skb;
+	int i, j;
+	u32 idx;
+
+	for (j = 0; j < to_do; j++) {
+		idx = tx->done & tx->mask;
+		netif_info(priv, tx_done, priv->dev,
+			   "[%d] %s: idx=%d (req=%u done=%u)\n",
+			   tx->q_num, __func__, idx, tx->req, tx->done);
+		info = &tx->info[idx];
+		skb = info->skb;
+
+		/* Mark as free */
+		if (skb) {
+			info->skb = NULL;
+			bytes += skb->len;
+			pkts++;
+			dev_consume_skb_any(skb);
+			/* FIFO free */
+			for (i = 0; i < ARRAY_SIZE(info->iov); i++) {
+				space_freed += info->iov[i].iov_len +
+					       info->iov[i].iov_padding;
+				info->iov[i].iov_len = 0;
+				info->iov[i].iov_padding = 0;
+			}
+		}
+		tx->done++;
+	}
+
+	gve_tx_free_fifo(&tx->tx_fifo, space_freed);
+	tx->bytes_done += bytes;
+	tx->pkt_done += pkts;
+	netdev_tx_completed_queue(tx->netdev_txq, pkts, bytes);
+
+	/* start the queue if we've stopped it */
+#ifndef CONFIG_BQL
+	/* Make sure that the doorbells are synced */
+	smp_mb();
+#endif
+	if (try_to_wake && netif_tx_queue_stopped(tx->netdev_txq) &&
+	    likely(gve_can_tx(tx, GVE_TX_START_THRESH))) {
+		tx->wake_queue++;
+		netif_tx_wake_queue(tx->netdev_txq);
+	}
+
+	return pkts;
+}
+
+__be32 gve_tx_load_event_counter(struct gve_priv *priv,
+				 struct gve_tx_ring *tx)
+{
+	u32 counter_index = be32_to_cpu((tx->q_resources->counter_index));
+
+	return READ_ONCE(priv->counter_array[counter_index]);
+}
+
+bool gve_tx_poll(struct gve_notify_block *block, int budget)
+{
+	struct gve_priv *priv = block->priv;
+	struct gve_tx_ring *tx = block->tx;
+	bool repoll = false;
+	u32 nic_done;
+	u32 to_do;
+
+	/* If budget is 0, do all the work */
+	if (budget == 0)
+		budget = INT_MAX;
+
+	/* Find out how much work there is to be done */
+	tx->last_nic_done = gve_tx_load_event_counter(priv, tx);
+	nic_done = be32_to_cpu(tx->last_nic_done);
+	if (budget > 0) {
+		/* Do as much work as we have that the budget will
+		 * allow
+		 */
+		to_do = min_t(u32, (nic_done - tx->done), budget);
+		gve_clean_tx_done(priv, tx, to_do, true);
+	}
+	/* If we still have work we want to repoll */
+	repoll |= (nic_done != tx->done);
+	return repoll;
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

