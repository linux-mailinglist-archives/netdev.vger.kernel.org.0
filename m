Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8D1267E8C
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgIMISZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:18:25 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:33843 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgIMISN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599985088; x=1631521088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ly9ED+mEoltJ+AJrasYVtmoP/mM3Ax6EjrvsIHHo0Rk=;
  b=ro3w4PRA3cKNJM+DxzkN94RStf8Ag3OdJpD86xVBVo8uAp00PDaa7uDp
   a5lp9p4ndCZ1hkjE/djpwtei2Wkr9L8O9U1Ol6lCMvGhDT8ip93IqsUQ3
   dZeFDqS1KmFthcGpi6MNexWJoOddDNGhgEDm8dhuoGz7w7iNRSII2zhZI
   g=;
X-IronPort-AV: E=Sophos;i="5.76,421,1592870400"; 
   d="scan'208";a="67489143"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 13 Sep 2020 08:18:03 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id D3B57A1C69;
        Sun, 13 Sep 2020 08:18:01 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.145) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Sep 2020 08:17:51 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Amit Bernstein <amitbern@amazon.com>
Subject: [PATCH V1 net-next 4/8] net: ena: Capitalize all log strings and improve code readability
Date:   Sun, 13 Sep 2020 11:16:36 +0300
Message-ID: <20200913081640.19560-5-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200913081640.19560-1-shayagr@amazon.com>
References: <20200913081640.19560-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Capitalize all log strings printed by the ena driver to make their
format uniform across it.

Also fix indentation, spelling mistakes and comments to improve code
readability. This also includes adding comments to macros/enums whose
purpose might be difficult to understand.
Separate some code into functions to make it easier to understand the
purpose of these lines.

Signed-off-by: Amit Bernstein <amitbern@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  53 +++---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 176 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_com.h     |   2 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  28 +--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   4 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  64 ++++---
 7 files changed, 176 insertions(+), 153 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 94877eb32704..a41949df16f4 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -28,6 +28,7 @@ enum ena_admin_aq_completion_status {
 	ENA_ADMIN_RESOURCE_BUSY                     = 7,
 };
 
+/* subcommands for the set/get feature admin commands */
 enum ena_admin_aq_feature_id {
 	ENA_ADMIN_DEVICE_ATTRIBUTES                 = 1,
 	ENA_ADMIN_MAX_QUEUES_NUM                    = 2,
@@ -168,7 +169,7 @@ struct ena_admin_acq_common_desc {
 	u16 extended_status;
 
 	/* indicates to the driver which AQ entry has been consumed by the
-	 *    device and could be reused
+	 * device and could be reused
 	 */
 	u16 sq_head_indx;
 };
@@ -213,8 +214,8 @@ struct ena_admin_aq_create_sq_cmd {
 	 */
 	u8 sq_caps_3;
 
-	/* associated completion queue id. This CQ must be created prior to
-	 *    SQ creation
+	/* associated completion queue id. This CQ must be created prior to SQ
+	 * creation
 	 */
 	u16 cq_idx;
 
@@ -353,7 +354,7 @@ struct ena_admin_aq_get_stats_cmd {
 	u16 queue_idx;
 
 	/* device id, value 0xFFFF means mine. only privileged device can get
-	 *    stats of other device
+	 * stats of other device
 	 */
 	u16 device_id;
 };
@@ -448,7 +449,9 @@ struct ena_admin_device_attr_feature_desc {
 
 	u32 device_version;
 
-	/* bitmap of ena_admin_aq_feature_id */
+	/* bitmap of ena_admin_aq_feature_id, which represents supported
+	 * subcommands for the set/get feature admin commands.
+	 */
 	u32 supported_features;
 
 	u32 reserved3;
@@ -534,32 +537,30 @@ struct ena_admin_feature_llq_desc {
 
 	u32 max_llq_depth;
 
-	/*  specify the header locations the device supports. bitfield of
-	 *    enum ena_admin_llq_header_location.
+	/*  specify the header locations the device supports. bitfield of enum
+	 * ena_admin_llq_header_location.
 	 */
 	u16 header_location_ctrl_supported;
 
 	/* the header location the driver selected to use. */
 	u16 header_location_ctrl_enabled;
 
-	/* if inline header is specified - this is the size of descriptor
-	 *    list entry. If header in a separate ring is specified - this is
-	 *    the size of header ring entry. bitfield of enum
-	 *    ena_admin_llq_ring_entry_size. specify the entry sizes the device
-	 *    supports
+	/* if inline header is specified - this is the size of descriptor list
+	 * entry. If header in a separate ring is specified - this is the size
+	 * of header ring entry. bitfield of enum ena_admin_llq_ring_entry_size.
+	 * specify the entry sizes the device supports
 	 */
 	u16 entry_size_ctrl_supported;
 
 	/* the entry size the driver selected to use. */
 	u16 entry_size_ctrl_enabled;
 
-	/* valid only if inline header is specified. First entry associated
-	 *    with the packet includes descriptors and header. Rest of the
-	 *    entries occupied by descriptors. This parameter defines the max
-	 *    number of descriptors precedding the header in the first entry.
-	 *    The field is bitfield of enum
-	 *    ena_admin_llq_num_descs_before_header and specify the values the
-	 *    device supports
+	/* valid only if inline header is specified. First entry associated with
+	 * the packet includes descriptors and header. Rest of the entries
+	 * occupied by descriptors. This parameter defines the max number of
+	 * descriptors precedding the header in the first entry. The field is
+	 * bitfield of enum ena_admin_llq_num_descs_before_header and specify
+	 * the values the device supports
 	 */
 	u16 desc_num_before_header_supported;
 
@@ -567,7 +568,7 @@ struct ena_admin_feature_llq_desc {
 	u16 desc_num_before_header_enabled;
 
 	/* valid only if inline was chosen. bitfield of enum
-	 *    ena_admin_llq_stride_ctrl
+	 * ena_admin_llq_stride_ctrl
 	 */
 	u16 descriptors_stride_ctrl_supported;
 
@@ -602,8 +603,8 @@ struct ena_admin_queue_ext_feature_fields {
 
 	u32 max_tx_header_size;
 
-	/* Maximum Descriptors number, including meta descriptor, allowed for
-	 * a single Tx packet
+	/* Maximum Descriptors number, including meta descriptor, allowed for a
+	 * single Tx packet
 	 */
 	u16 max_per_packet_tx_descs;
 
@@ -626,8 +627,8 @@ struct ena_admin_queue_feature_desc {
 
 	u32 max_header_size;
 
-	/* Maximum Descriptors number, including meta descriptor, allowed for
-	 *    a single Tx packet
+	/* Maximum Descriptors number, including meta descriptor, allowed for a
+	 * single Tx packet
 	 */
 	u16 max_packet_tx_descs;
 
@@ -1015,7 +1016,7 @@ struct ena_admin_set_feat_resp {
 struct ena_admin_aenq_common_desc {
 	u16 group;
 
-	u16 syndrom;
+	u16 syndrome;
 
 	/* 0 : phase
 	 * 7:1 : reserved - MBZ
@@ -1039,7 +1040,7 @@ enum ena_admin_aenq_group {
 	ENA_ADMIN_AENQ_GROUPS_NUM                   = 5,
 };
 
-enum ena_admin_aenq_notification_syndrom {
+enum ena_admin_aenq_notification_syndrome {
 	ENA_ADMIN_SUSPEND                           = 0,
 	ENA_ADMIN_RESUME                            = 1,
 	ENA_ADMIN_UPDATE_HINTS                      = 2,
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index a37d9fdc1398..6a24c9a337b2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -72,7 +72,7 @@ static int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
 {
 	if ((addr & GENMASK_ULL(ena_dev->dma_addr_bits - 1, 0)) != addr) {
 		dev_err(ena_dev->dmadev,
-			"dma address has more bits that the device supports\n");
+			"DMA address has more bits that the device supports\n");
 		return -EINVAL;
 	}
 
@@ -82,17 +82,17 @@ static int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
 	return 0;
 }
 
-static int ena_com_admin_init_sq(struct ena_com_admin_queue *queue)
+static int ena_com_admin_init_sq(struct ena_com_admin_queue *admin_queue)
 {
-	struct ena_com_dev *ena_dev = queue->ena_dev;
-	struct ena_com_admin_sq *sq = &queue->sq;
-	u16 size = ADMIN_SQ_SIZE(queue->q_depth);
+	struct ena_com_dev *ena_dev = admin_queue->ena_dev;
+	struct ena_com_admin_sq *sq = &admin_queue->sq;
+	u16 size = ADMIN_SQ_SIZE(admin_queue->q_depth);
 
-	sq->entries = dma_alloc_coherent(queue->q_dmadev, size, &sq->dma_addr,
-					 GFP_KERNEL);
+	sq->entries = dma_alloc_coherent(admin_queue->q_dmadev, size,
+					 &sq->dma_addr, GFP_KERNEL);
 
 	if (!sq->entries) {
-		dev_err(ena_dev->dmadev, "memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -105,17 +105,17 @@ static int ena_com_admin_init_sq(struct ena_com_admin_queue *queue)
 	return 0;
 }
 
-static int ena_com_admin_init_cq(struct ena_com_admin_queue *queue)
+static int ena_com_admin_init_cq(struct ena_com_admin_queue *admin_queue)
 {
-	struct ena_com_dev *ena_dev = queue->ena_dev;
-	struct ena_com_admin_cq *cq = &queue->cq;
-	u16 size = ADMIN_CQ_SIZE(queue->q_depth);
+	struct ena_com_dev *ena_dev = admin_queue->ena_dev;
+	struct ena_com_admin_cq *cq = &admin_queue->cq;
+	u16 size = ADMIN_CQ_SIZE(admin_queue->q_depth);
 
-	cq->entries = dma_alloc_coherent(queue->q_dmadev, size, &cq->dma_addr,
-					 GFP_KERNEL);
+	cq->entries = dma_alloc_coherent(admin_queue->q_dmadev, size,
+					 &cq->dma_addr, GFP_KERNEL);
 
 	if (!cq->entries) {
-		dev_err(ena_dev->dmadev, "memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -125,20 +125,20 @@ static int ena_com_admin_init_cq(struct ena_com_admin_queue *queue)
 	return 0;
 }
 
-static int ena_com_admin_init_aenq(struct ena_com_dev *dev,
+static int ena_com_admin_init_aenq(struct ena_com_dev *ena_dev,
 				   struct ena_aenq_handlers *aenq_handlers)
 {
-	struct ena_com_aenq *aenq = &dev->aenq;
+	struct ena_com_aenq *aenq = &ena_dev->aenq;
 	u32 addr_low, addr_high, aenq_caps;
 	u16 size;
 
-	dev->aenq.q_depth = ENA_ASYNC_QUEUE_DEPTH;
+	ena_dev->aenq.q_depth = ENA_ASYNC_QUEUE_DEPTH;
 	size = ADMIN_AENQ_SIZE(ENA_ASYNC_QUEUE_DEPTH);
-	aenq->entries = dma_alloc_coherent(dev->dmadev, size, &aenq->dma_addr,
-					   GFP_KERNEL);
+	aenq->entries = dma_alloc_coherent(ena_dev->dmadev, size,
+					   &aenq->dma_addr, GFP_KERNEL);
 
 	if (!aenq->entries) {
-		dev_err(dev->dmadev, "memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -148,18 +148,18 @@ static int ena_com_admin_init_aenq(struct ena_com_dev *dev,
 	addr_low = ENA_DMA_ADDR_TO_UINT32_LOW(aenq->dma_addr);
 	addr_high = ENA_DMA_ADDR_TO_UINT32_HIGH(aenq->dma_addr);
 
-	writel(addr_low, dev->reg_bar + ENA_REGS_AENQ_BASE_LO_OFF);
-	writel(addr_high, dev->reg_bar + ENA_REGS_AENQ_BASE_HI_OFF);
+	writel(addr_low, ena_dev->reg_bar + ENA_REGS_AENQ_BASE_LO_OFF);
+	writel(addr_high, ena_dev->reg_bar + ENA_REGS_AENQ_BASE_HI_OFF);
 
 	aenq_caps = 0;
-	aenq_caps |= dev->aenq.q_depth & ENA_REGS_AENQ_CAPS_AENQ_DEPTH_MASK;
+	aenq_caps |= ena_dev->aenq.q_depth & ENA_REGS_AENQ_CAPS_AENQ_DEPTH_MASK;
 	aenq_caps |= (sizeof(struct ena_admin_aenq_entry)
 		      << ENA_REGS_AENQ_CAPS_AENQ_ENTRY_SIZE_SHIFT) &
 		     ENA_REGS_AENQ_CAPS_AENQ_ENTRY_SIZE_MASK;
-	writel(aenq_caps, dev->reg_bar + ENA_REGS_AENQ_CAPS_OFF);
+	writel(aenq_caps, ena_dev->reg_bar + ENA_REGS_AENQ_CAPS_OFF);
 
 	if (unlikely(!aenq_handlers)) {
-		dev_err(dev->dmadev, "aenq handlers pointer is NULL\n");
+		dev_err(ena_dev->dmadev, "AENQ handlers pointer is NULL\n");
 		return -EINVAL;
 	}
 
@@ -175,34 +175,34 @@ static void comp_ctxt_release(struct ena_com_admin_queue *queue,
 	atomic_dec(&queue->outstanding_cmds);
 }
 
-static struct ena_comp_ctx *get_comp_ctxt(struct ena_com_admin_queue *queue,
+static struct ena_comp_ctx *get_comp_ctxt(struct ena_com_admin_queue *admin_queue,
 					  u16 command_id, bool capture)
 {
-	if (unlikely(command_id >= queue->q_depth)) {
-		dev_err(queue->ena_dev->dmadev,
-			"command id is larger than the queue size. cmd_id: %u queue size %d\n",
-			command_id, queue->q_depth);
+	if (unlikely(command_id >= admin_queue->q_depth)) {
+		dev_err(admin_queue->ena_dev->dmadev,
+			"Command id is larger than the queue size. cmd_id: %u queue size %d\n",
+			command_id, admin_queue->q_depth);
 		return NULL;
 	}
 
-	if (unlikely(!queue->comp_ctx)) {
-		dev_err(queue->ena_dev->dmadev,
+	if (unlikely(!admin_queue->comp_ctx)) {
+		dev_err(admin_queue->ena_dev->dmadev,
 			"Completion context is NULL\n");
 		return NULL;
 	}
 
-	if (unlikely(queue->comp_ctx[command_id].occupied && capture)) {
-		dev_err(queue->ena_dev->dmadev,
+	if (unlikely(admin_queue->comp_ctx[command_id].occupied && capture)) {
+		dev_err(admin_queue->ena_dev->dmadev,
 			"Completion context is occupied\n");
 		return NULL;
 	}
 
 	if (capture) {
-		atomic_inc(&queue->outstanding_cmds);
-		queue->comp_ctx[command_id].occupied = true;
+		atomic_inc(&admin_queue->outstanding_cmds);
+		admin_queue->comp_ctx[command_id].occupied = true;
 	}
 
-	return &queue->comp_ctx[command_id];
+	return &admin_queue->comp_ctx[command_id];
 }
 
 static struct ena_comp_ctx *__ena_com_submit_admin_cmd(struct ena_com_admin_queue *admin_queue,
@@ -223,7 +223,7 @@ static struct ena_comp_ctx *__ena_com_submit_admin_cmd(struct ena_com_admin_queu
 	/* In case of queue FULL */
 	cnt = (u16)atomic_read(&admin_queue->outstanding_cmds);
 	if (cnt >= admin_queue->q_depth) {
-		dev_dbg(admin_queue->ena_dev->dmadev, "admin queue is full.\n");
+		dev_dbg(admin_queue->ena_dev->dmadev, "Admin queue is full.\n");
 		admin_queue->stats.out_of_space++;
 		return ERR_PTR(-ENOSPC);
 	}
@@ -263,21 +263,22 @@ static struct ena_comp_ctx *__ena_com_submit_admin_cmd(struct ena_com_admin_queu
 	return comp_ctx;
 }
 
-static int ena_com_init_comp_ctxt(struct ena_com_admin_queue *queue)
+static int ena_com_init_comp_ctxt(struct ena_com_admin_queue *admin_queue)
 {
-	struct ena_com_dev *ena_dev = queue->ena_dev;
-	size_t size = queue->q_depth * sizeof(struct ena_comp_ctx);
+	struct ena_com_dev *ena_dev = admin_queue->ena_dev;
+	size_t size = admin_queue->q_depth * sizeof(struct ena_comp_ctx);
 	struct ena_comp_ctx *comp_ctx;
 	u16 i;
 
-	queue->comp_ctx = devm_kzalloc(queue->q_dmadev, size, GFP_KERNEL);
-	if (unlikely(!queue->comp_ctx)) {
-		dev_err(ena_dev->dmadev, "memory allocation failed\n");
+	admin_queue->comp_ctx =
+		devm_kzalloc(admin_queue->q_dmadev, size, GFP_KERNEL);
+	if (unlikely(!admin_queue->comp_ctx)) {
+		dev_err(ena_dev->dmadev, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < queue->q_depth; i++) {
-		comp_ctx = get_comp_ctxt(queue, i, false);
+	for (i = 0; i < admin_queue->q_depth; i++) {
+		comp_ctx = get_comp_ctxt(admin_queue, i, false);
 		if (comp_ctx)
 			init_completion(&comp_ctx->wait_event);
 	}
@@ -343,7 +344,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		}
 
 		if (!io_sq->desc_addr.virt_addr) {
-			dev_err(ena_dev->dmadev, "memory allocation failed\n");
+			dev_err(ena_dev->dmadev, "Memory allocation failed\n");
 			return -ENOMEM;
 		}
 	}
@@ -370,7 +371,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 
 		if (!io_sq->bounce_buf_ctrl.base_buffer) {
 			dev_err(ena_dev->dmadev,
-				"bounce buffer memory allocation failed\n");
+				"Bounce buffer memory allocation failed\n");
 			return -ENOMEM;
 		}
 
@@ -430,7 +431,7 @@ static int ena_com_init_io_cq(struct ena_com_dev *ena_dev,
 	}
 
 	if (!io_cq->cdesc_addr.virt_addr) {
-		dev_err(ena_dev->dmadev, "memory allocation failed\n");
+		dev_err(ena_dev->dmadev, "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -509,7 +510,7 @@ static int ena_com_comp_status_to_errno(struct ena_com_admin_queue *admin_queue,
 {
 	if (unlikely(comp_status != 0))
 		dev_err(admin_queue->ena_dev->dmadev,
-			"admin command failed[%u]\n", comp_status);
+			"Admin command failed[%u]\n", comp_status);
 
 	switch (comp_status) {
 	case ENA_ADMIN_SUCCESS:
@@ -856,7 +857,7 @@ static u32 ena_com_reg_bar_read32(struct ena_com_dev *ena_dev, u16 offset)
 
 	if (unlikely(i == timeout)) {
 		dev_err(ena_dev->dmadev,
-			"reading reg failed for timeout. expected: req id[%hu] offset[%hu] actual: req id[%hu] offset[%hu]\n",
+			"Reading reg failed for timeout. expected: req id[%hu] offset[%hu] actual: req id[%hu] offset[%hu]\n",
 			mmio_read->seq_num, offset, read_resp->req_id,
 			read_resp->reg_off);
 		ret = ENA_MMIO_READ_TIMEOUT;
@@ -923,7 +924,7 @@ static int ena_com_destroy_io_sq(struct ena_com_dev *ena_dev,
 					    sizeof(destroy_resp));
 
 	if (unlikely(ret && (ret != -ENODEV)))
-		dev_err(ena_dev->dmadev, "failed to destroy io sq error: %d\n",
+		dev_err(ena_dev->dmadev, "Failed to destroy io sq error: %d\n",
 			ret);
 
 	return ret;
@@ -1034,7 +1035,7 @@ static int ena_com_get_feature_ex(struct ena_com_dev *ena_dev,
 				   &get_cmd.control_buffer.address,
 				   control_buf_dma_addr);
 	if (unlikely(ret)) {
-		dev_err(ena_dev->dmadev, "memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 
@@ -1157,7 +1158,7 @@ static int ena_com_indirect_table_allocate(struct ena_com_dev *ena_dev,
 	if ((get_resp.u.ind_table.min_size > log_size) ||
 	    (get_resp.u.ind_table.max_size < log_size)) {
 		dev_err(ena_dev->dmadev,
-			"indirect table size doesn't fit. requested size: %d while min is:%d and max %d\n",
+			"Indirect table size doesn't fit. requested size: %d while min is:%d and max %d\n",
 			1 << log_size, 1 << get_resp.u.ind_table.min_size,
 			1 << get_resp.u.ind_table.max_size);
 		return -EINVAL;
@@ -1250,7 +1251,7 @@ static int ena_com_create_io_sq(struct ena_com_dev *ena_dev,
 					   &create_cmd.sq_ba,
 					   io_sq->desc_addr.phys_addr);
 		if (unlikely(ret)) {
-			dev_err(ena_dev->dmadev, "memory address set failed\n");
+			dev_err(ena_dev->dmadev, "Memory address set failed\n");
 			return ret;
 		}
 	}
@@ -1280,7 +1281,7 @@ static int ena_com_create_io_sq(struct ena_com_dev *ena_dev,
 			cmd_completion.llq_descriptors_offset);
 	}
 
-	dev_dbg(ena_dev->dmadev, "created sq[%u], depth[%u]\n", io_sq->idx,
+	dev_dbg(ena_dev->dmadev, "Created sq[%u], depth[%u]\n", io_sq->idx,
 		io_sq->q_depth);
 
 	return ret;
@@ -1429,7 +1430,7 @@ int ena_com_create_io_cq(struct ena_com_dev *ena_dev,
 			(u32 __iomem *)((uintptr_t)ena_dev->reg_bar +
 			cmd_completion.numa_node_register_offset);
 
-	dev_dbg(ena_dev->dmadev, "created cq[%u], depth[%u]\n", io_cq->idx,
+	dev_dbg(ena_dev->dmadev, "Created cq[%u], depth[%u]\n", io_cq->idx,
 		io_cq->q_depth);
 
 	return ret;
@@ -1626,7 +1627,7 @@ int ena_com_validate_version(struct ena_com_dev *ena_dev)
 		return -ETIME;
 	}
 
-	dev_info(ena_dev->dmadev, "ena device version: %d.%d\n",
+	dev_info(ena_dev->dmadev, "ENA device version: %d.%d\n",
 		 (ver & ENA_REGS_VERSION_MAJOR_VERSION_MASK) >>
 			 ENA_REGS_VERSION_MAJOR_VERSION_SHIFT,
 		 ver & ENA_REGS_VERSION_MINOR_VERSION_MASK);
@@ -1656,6 +1657,19 @@ int ena_com_validate_version(struct ena_com_dev *ena_dev)
 	return 0;
 }
 
+static void
+ena_com_free_ena_admin_queue_comp_ctx(struct ena_com_dev *ena_dev,
+				      struct ena_com_admin_queue *admin_queue)
+
+{
+	if (!admin_queue->comp_ctx)
+		return;
+
+	devm_kfree(ena_dev->dmadev, admin_queue->comp_ctx);
+
+	admin_queue->comp_ctx = NULL;
+}
+
 void ena_com_admin_destroy(struct ena_com_dev *ena_dev)
 {
 	struct ena_com_admin_queue *admin_queue = &ena_dev->admin_queue;
@@ -1664,9 +1678,8 @@ void ena_com_admin_destroy(struct ena_com_dev *ena_dev)
 	struct ena_com_aenq *aenq = &ena_dev->aenq;
 	u16 size;
 
-	if (admin_queue->comp_ctx)
-		devm_kfree(ena_dev->dmadev, admin_queue->comp_ctx);
-	admin_queue->comp_ctx = NULL;
+	ena_com_free_ena_admin_queue_comp_ctx(ena_dev, admin_queue);
+
 	size = ADMIN_SQ_SIZE(admin_queue->q_depth);
 	if (sq->entries)
 		dma_free_coherent(ena_dev->dmadev, size, sq->entries,
@@ -1946,6 +1959,7 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 
 	memcpy(&get_feat_ctx->dev_attr, &get_resp.u.dev_attr,
 	       sizeof(get_resp.u.dev_attr));
+
 	ena_dev->supported_features = get_resp.u.dev_attr.supported_features;
 
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
@@ -2024,10 +2038,10 @@ void ena_com_admin_q_comp_intr_handler(struct ena_com_dev *ena_dev)
 /* ena_handle_specific_aenq_event:
  * return the handler that is relevant to the specific event group
  */
-static ena_aenq_handler ena_com_get_specific_aenq_cb(struct ena_com_dev *dev,
+static ena_aenq_handler ena_com_get_specific_aenq_cb(struct ena_com_dev *ena_dev,
 						     u16 group)
 {
-	struct ena_aenq_handlers *aenq_handlers = dev->aenq.aenq_handlers;
+	struct ena_aenq_handlers *aenq_handlers = ena_dev->aenq.aenq_handlers;
 
 	if ((group < ENA_MAX_HANDLERS) && aenq_handlers->handlers[group])
 		return aenq_handlers->handlers[group];
@@ -2039,11 +2053,11 @@ static ena_aenq_handler ena_com_get_specific_aenq_cb(struct ena_com_dev *dev,
  * handles the aenq incoming events.
  * pop events from the queue and apply the specific handler
  */
-void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
+void ena_com_aenq_intr_handler(struct ena_com_dev *ena_dev, void *data)
 {
 	struct ena_admin_aenq_entry *aenq_e;
 	struct ena_admin_aenq_common_desc *aenq_common;
-	struct ena_com_aenq *aenq  = &dev->aenq;
+	struct ena_com_aenq *aenq  = &ena_dev->aenq;
 	u64 timestamp;
 	ena_aenq_handler handler_cb;
 	u16 masked_head, processed = 0;
@@ -2063,14 +2077,14 @@ void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
 		dma_rmb();
 
 		timestamp = (u64)aenq_common->timestamp_low |
-			    ((u64)aenq_common->timestamp_high << 32);
+			((u64)aenq_common->timestamp_high << 32);
 
-		dev_dbg(dev->dmadev,
-			"AENQ! Group[%x] Syndrom[%x] timestamp: [%llus]\n",
-			aenq_common->group, aenq_common->syndrom, timestamp);
+		dev_dbg(ena_dev->dmadev,
+			"AENQ! Group[%x] Syndrome[%x] timestamp: [%llus]\n",
+			aenq_common->group, aenq_common->syndrome, timestamp);
 
 		/* Handle specific event*/
-		handler_cb = ena_com_get_specific_aenq_cb(dev,
+		handler_cb = ena_com_get_specific_aenq_cb(ena_dev,
 							  aenq_common->group);
 		handler_cb(data, aenq_e); /* call the actual event handler*/
 
@@ -2095,7 +2109,8 @@ void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
 
 	/* write the aenq doorbell after all AENQ descriptors were read */
 	mb();
-	writel_relaxed((u32)aenq->head, dev->reg_bar + ENA_REGS_AENQ_HEAD_DB_OFF);
+	writel_relaxed((u32)aenq->head,
+		       ena_dev->reg_bar + ENA_REGS_AENQ_HEAD_DB_OFF);
 }
 
 int ena_com_dev_reset(struct ena_com_dev *ena_dev,
@@ -2485,7 +2500,7 @@ int ena_com_set_hash_ctrl(struct ena_com_dev *ena_dev)
 				   &cmd.control_buffer.address,
 				   rss->hash_ctrl_dma_addr);
 	if (unlikely(ret)) {
-		dev_err(ena_dev->dmadev, "memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 	cmd.control_buffer.length = sizeof(*hash_ctrl);
@@ -2548,7 +2563,7 @@ int ena_com_set_default_hash_ctrl(struct ena_com_dev *ena_dev)
 				hash_ctrl->supported_fields[i].fields;
 		if (available_fields != hash_ctrl->selected_fields[i].fields) {
 			dev_err(ena_dev->dmadev,
-				"hash control doesn't support all the desire configuration. proto %x supported %x selected %x\n",
+				"Hash control doesn't support all the desire configuration. proto %x supported %x selected %x\n",
 				i, hash_ctrl->supported_fields[i].fields,
 				hash_ctrl->selected_fields[i].fields);
 			return -EOPNOTSUPP;
@@ -2587,7 +2602,7 @@ int ena_com_fill_hash_ctrl(struct ena_com_dev *ena_dev,
 	supported_fields = hash_ctrl->supported_fields[proto].fields;
 	if ((hash_fields & supported_fields) != hash_fields) {
 		dev_err(ena_dev->dmadev,
-			"proto %d doesn't support the required fields %x. supports only: %x\n",
+			"Proto %d doesn't support the required fields %x. supports only: %x\n",
 			proto, hash_fields, supported_fields);
 	}
 
@@ -2653,7 +2668,7 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 				   &cmd.control_buffer.address,
 				   rss->rss_ind_tbl_dma_addr);
 	if (unlikely(ret)) {
-		dev_err(ena_dev->dmadev, "memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 
@@ -2767,8 +2782,7 @@ int ena_com_allocate_debug_area(struct ena_com_dev *ena_dev,
 
 	host_attr->debug_area_virt_addr =
 		dma_alloc_coherent(ena_dev->dmadev, debug_area_size,
-				   &host_attr->debug_area_dma_addr,
-				   GFP_KERNEL);
+				   &host_attr->debug_area_dma_addr, GFP_KERNEL);
 	if (unlikely(!host_attr->debug_area_virt_addr)) {
 		host_attr->debug_area_size = 0;
 		return -ENOMEM;
@@ -2825,7 +2839,7 @@ int ena_com_set_host_attributes(struct ena_com_dev *ena_dev)
 				   &cmd.u.host_attr.debug_ba,
 				   host_attr->debug_area_dma_addr);
 	if (unlikely(ret)) {
-		dev_err(ena_dev->dmadev, "memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 
@@ -2833,7 +2847,7 @@ int ena_com_set_host_attributes(struct ena_com_dev *ena_dev)
 				   &cmd.u.host_attr.os_info_ba,
 				   host_attr->host_info_dma_addr);
 	if (unlikely(ret)) {
-		dev_err(ena_dev->dmadev, "memory address set failed\n");
+		dev_err(ena_dev->dmadev, "Memory address set failed\n");
 		return ret;
 	}
 
@@ -2959,7 +2973,7 @@ int ena_com_config_dev_mode(struct ena_com_dev *ena_dev,
 
 	if (unlikely(ena_dev->tx_max_header_size == 0)) {
 		dev_err(ena_dev->dmadev,
-			"the size of the LLQ entry is smaller than needed\n");
+			"The size of the LLQ entry is smaller than needed\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index ffd2137e59b9..38898ae5442e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -509,7 +509,7 @@ void ena_com_admin_q_comp_intr_handler(struct ena_com_dev *ena_dev);
  * This method goes over the async event notification queue and calls the proper
  * aenq handler.
  */
-void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data);
+void ena_com_aenq_intr_handler(struct ena_com_dev *ena_dev, void *data);
 
 /* ena_com_abort_admin_commands - Abort all the outstanding admin commands.
  * @ena_dev: ENA communication layer struct
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 2814a712318b..b21b7c04f8f4 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -18,8 +18,9 @@ static struct ena_eth_io_rx_cdesc_base *ena_com_get_next_rx_cdesc(
 	cdesc = (struct ena_eth_io_rx_cdesc_base *)(io_cq->cdesc_addr.virt_addr
 			+ (head_masked * io_cq->cdesc_entry_size_in_bytes));
 
-	desc_phase = (READ_ONCE(cdesc->status) & ENA_ETH_IO_RX_CDESC_BASE_PHASE_MASK) >>
-			ENA_ETH_IO_RX_CDESC_BASE_PHASE_SHIFT;
+	desc_phase = (READ_ONCE(cdesc->status) &
+		      ENA_ETH_IO_RX_CDESC_BASE_PHASE_MASK) >>
+		     ENA_ETH_IO_RX_CDESC_BASE_PHASE_SHIFT;
 
 	if (desc_phase != expected_phase)
 		return NULL;
@@ -64,7 +65,7 @@ static int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
 
 		io_sq->entries_in_tx_burst_left--;
 		dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"decreasing entries_in_tx_burst_left of queue %d to %d\n",
+			"Decreasing entries_in_tx_burst_left of queue %d to %d\n",
 			io_sq->qid, io_sq->entries_in_tx_burst_left);
 	}
 
@@ -104,13 +105,13 @@ static int ena_com_write_header_to_bounce(struct ena_com_io_sq *io_sq,
 	if (unlikely((header_offset + header_len) >
 		     llq_info->desc_list_entry_size)) {
 		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"trying to write header larger than llq entry can accommodate\n");
+			"Trying to write header larger than llq entry can accommodate\n");
 		return -EFAULT;
 	}
 
 	if (unlikely(!bounce_buffer)) {
 		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"bounce buffer is NULL\n");
+			"Bounce buffer is NULL\n");
 		return -EFAULT;
 	}
 
@@ -129,7 +130,7 @@ static void *get_sq_desc_llq(struct ena_com_io_sq *io_sq)
 
 	if (unlikely(!bounce_buffer)) {
 		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"bounce buffer is NULL\n");
+			"Bounce buffer is NULL\n");
 		return NULL;
 	}
 
@@ -246,8 +247,9 @@ static u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 
 		ena_com_cq_inc_head(io_cq);
 		count++;
-		last = (READ_ONCE(cdesc->status) & ENA_ETH_IO_RX_CDESC_BASE_LAST_MASK) >>
-			ENA_ETH_IO_RX_CDESC_BASE_LAST_SHIFT;
+		last = (READ_ONCE(cdesc->status) &
+			ENA_ETH_IO_RX_CDESC_BASE_LAST_MASK) >>
+		       ENA_ETH_IO_RX_CDESC_BASE_LAST_SHIFT;
 	} while (!last);
 
 	if (last) {
@@ -401,7 +403,7 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 
 	if (unlikely(header_len > io_sq->tx_max_header_size)) {
 		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"header size is too large %d max header: %d\n",
+			"Header size is too large %d max header: %d\n",
 			header_len, io_sq->tx_max_header_size);
 		return -EINVAL;
 	}
@@ -420,7 +422,7 @@ int ena_com_prepare_tx(struct ena_com_io_sq *io_sq,
 	rc = ena_com_create_and_store_tx_meta_desc(io_sq, ena_tx_ctx, &have_meta);
 	if (unlikely(rc)) {
 		dev_err(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"failed to create and store tx meta desc\n");
+			"Failed to create and store tx meta desc\n");
 		return rc;
 	}
 
@@ -614,9 +616,9 @@ int ena_com_add_single_rx_desc(struct ena_com_io_sq *io_sq,
 	desc->length = ena_buf->len;
 
 	desc->ctrl = ENA_ETH_IO_RX_DESC_FIRST_MASK |
-		ENA_ETH_IO_RX_DESC_LAST_MASK |
-		(io_sq->phase & ENA_ETH_IO_RX_DESC_PHASE_MASK) |
-		ENA_ETH_IO_RX_DESC_COMP_REQ_MASK;
+		     ENA_ETH_IO_RX_DESC_LAST_MASK |
+		     ENA_ETH_IO_RX_DESC_COMP_REQ_MASK |
+		     (io_sq->phase & ENA_ETH_IO_RX_DESC_PHASE_MASK);
 
 	desc->req_id = req_id;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 8fc67592b637..6ab35ab16460 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -141,7 +141,7 @@ static inline bool ena_com_is_doorbell_needed(struct ena_com_io_sq *io_sq,
 	}
 
 	dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-		"queue: %d num_descs: %d num_entries_needed: %d\n", io_sq->qid,
+		"Queue: %d num_descs: %d num_entries_needed: %d\n", io_sq->qid,
 		num_descs, num_entries_needed);
 
 	return num_entries_needed > io_sq->entries_in_tx_burst_left;
@@ -160,7 +160,7 @@ static inline int ena_com_write_sq_doorbell(struct ena_com_io_sq *io_sq)
 
 	if (is_llq_max_tx_burst_exists(io_sq)) {
 		dev_dbg(ena_com_io_sq_to_ena_dev(io_sq)->dmadev,
-			"reset available entries in tx burst for queue %d to %d\n",
+			"Reset available entries in tx burst for queue %d to %d\n",
 			io_sq->qid, max_entries_in_tx_burst);
 		io_sq->entries_in_tx_burst_left = max_entries_in_tx_burst;
 	}
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 91339c165ab4..3b2cd28f962d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -939,7 +939,7 @@ static void ena_dump_stats_ex(struct ena_adapter *adapter, u8 *buf)
 				   GFP_ATOMIC);
 	if (!strings_buf) {
 		netif_err(adapter, drv, netdev,
-			  "failed to alloc strings_buf\n");
+			  "Failed to allocate strings_buf\n");
 		return;
 	}
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d0121aaafa38..cab83a9de651 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -112,7 +112,7 @@ static int ena_change_mtu(struct net_device *dev, int new_mtu)
 
 	ret = ena_com_set_dev_mtu(adapter->ena_dev, new_mtu);
 	if (!ret) {
-		netif_dbg(adapter, drv, dev, "set MTU to %d\n", new_mtu);
+		netif_dbg(adapter, drv, dev, "Set MTU to %d\n", new_mtu);
 		update_rx_ring_mtu(adapter, new_mtu);
 		dev->mtu = new_mtu;
 	} else {
@@ -151,7 +151,7 @@ static int ena_xmit_common(struct net_device *dev,
 	 */
 	if (unlikely(rc)) {
 		netif_err(adapter, tx_queued, dev,
-			  "failed to prepare tx bufs\n");
+			  "Failed to prepare tx bufs\n");
 		u64_stats_update_begin(&ring->syncp);
 		ring->tx_stats.prepare_ctx_err++;
 		u64_stats_update_end(&ring->syncp);
@@ -265,7 +265,7 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
 	u64_stats_update_begin(&xdp_ring->syncp);
 	xdp_ring->tx_stats.dma_mapping_err++;
 	u64_stats_update_end(&xdp_ring->syncp);
-	netif_warn(adapter, tx_queued, adapter->netdev, "failed to map xdp buff\n");
+	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map xdp buff\n");
 
 	xdp_return_frame_rx_napi(tx_info->xdpf);
 	tx_info->xdpf = NULL;
@@ -537,7 +537,7 @@ static int ena_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf)
 
 		if (!old_bpf_prog)
 			netif_info(adapter, drv, adapter->netdev,
-				   "xdp program set, changing the max_mtu from %d to %d",
+				   "XDP program is set, changing the max_mtu from %d to %d",
 				   prev_mtu, netdev->max_mtu);
 
 	} else if (rc == ENA_XDP_CURRENT_MTU_TOO_LARGE) {
@@ -956,7 +956,7 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 		return -EIO;
 	}
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
-		  "alloc page %p, rx_info %p\n", page, rx_info);
+		  "Allocate page %p, rx_info %p\n", page, rx_info);
 
 	rx_info->page = page;
 	rx_info->page_offset = 0;
@@ -1006,7 +1006,7 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 				       GFP_ATOMIC | __GFP_COMP);
 		if (unlikely(rc < 0)) {
 			netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
-				   "failed to alloc buffer for rx queue %d\n",
+				   "Failed to allocate buffer for rx queue %d\n",
 				   rx_ring->qid);
 			break;
 		}
@@ -1015,7 +1015,7 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 						req_id);
 		if (unlikely(rc)) {
 			netif_warn(rx_ring->adapter, rx_status, rx_ring->netdev,
-				   "failed to add buffer for rx queue %d\n",
+				   "Failed to add buffer for rx queue %d\n",
 				   rx_ring->qid);
 			break;
 		}
@@ -1028,7 +1028,7 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 		rx_ring->rx_stats.refil_partial++;
 		u64_stats_update_end(&rx_ring->syncp);
 		netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
-			   "refilled rx qid %d with only %d buffers (from %d)\n",
+			   "Refilled rx qid %d with only %d buffers (from %d)\n",
 			   rx_ring->qid, i, num);
 	}
 
@@ -1070,7 +1070,7 @@ static void ena_refill_all_rx_bufs(struct ena_adapter *adapter)
 
 		if (unlikely(rc != bufs_num))
 			netif_warn(rx_ring->adapter, rx_status, rx_ring->netdev,
-				   "refilling Queue %d failed. allocated %d buffers from: %d\n",
+				   "Refilling Queue %d failed. allocated %d buffers from: %d\n",
 				   i, rc, bufs_num);
 	}
 }
@@ -1129,12 +1129,12 @@ static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 
 		if (print_once) {
 			netif_notice(tx_ring->adapter, ifdown, tx_ring->netdev,
-				     "free uncompleted tx skb qid %d idx 0x%x\n",
+				     "Free uncompleted tx skb qid %d idx 0x%x\n",
 				     tx_ring->qid, i);
 			print_once = false;
 		} else {
 			netif_dbg(tx_ring->adapter, ifdown, tx_ring->netdev,
-				  "free uncompleted tx skb qid %d idx 0x%x\n",
+				  "Free uncompleted tx skb qid %d idx 0x%x\n",
 				  tx_ring->qid, i);
 		}
 
@@ -1387,7 +1387,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 			return NULL;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
-			  "rx allocated small packet. len %d. data_len %d\n",
+			  "RX allocated small packet. len %d. data_len %d\n",
 			  skb->len, skb->data_len);
 
 		/* sync this buffer for CPU use */
@@ -1424,7 +1424,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		rx_info->page_offset = 0;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
-			  "rx skb updated. len %d. data_len %d\n",
+			  "RX skb updated. len %d. data_len %d\n",
 			  skb->len, skb->data_len);
 
 		rx_info->page = NULL;
@@ -1631,6 +1631,11 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 					 &next_to_clean);
 
 		if (unlikely(!skb)) {
+			/* The page might not actually be freed here since the
+			 * page reference count is incremented in
+			 * ena_xdp_xmit_buff(), and it will be decreased only
+			 * when send completion was received from the device
+			 */
 			if (xdp_verdict == XDP_TX)
 				ena_free_rx_page(rx_ring,
 						 &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id]);
@@ -1758,6 +1763,7 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->tx_stats.unmask_interrupt++;
 	u64_stats_update_end(&tx_ring->syncp);
+
 	/* It is a shared MSI-X.
 	 * Tx and Rx CQ have pointer to it.
 	 * So we use one of them to reach the intr reg
@@ -1975,7 +1981,7 @@ static int ena_enable_msix(struct ena_adapter *adapter)
 	/* Reserved the max msix vectors we might need */
 	msix_vecs = ENA_MAX_MSIX_VEC(adapter->max_num_io_queues);
 	netif_dbg(adapter, probe, adapter->netdev,
-		  "trying to enable MSI-X, vectors %d\n", msix_vecs);
+		  "Trying to enable MSI-X, vectors %d\n", msix_vecs);
 
 	irq_cnt = pci_alloc_irq_vectors(adapter->pdev, ENA_MIN_MSIX_VEC,
 					msix_vecs, PCI_IRQ_MSIX);
@@ -1988,7 +1994,7 @@ static int ena_enable_msix(struct ena_adapter *adapter)
 
 	if (irq_cnt != msix_vecs) {
 		netif_notice(adapter, probe, adapter->netdev,
-			     "enable only %d MSI-X (out of %d), reduce the number of queues\n",
+			     "Enable only %d MSI-X (out of %d), reduce the number of queues\n",
 			     irq_cnt, msix_vecs);
 		adapter->num_io_queues = irq_cnt - ENA_ADMIN_MSIX_VEC;
 	}
@@ -2058,12 +2064,12 @@ static int ena_request_mgmnt_irq(struct ena_adapter *adapter)
 			 irq->data);
 	if (rc) {
 		netif_err(adapter, probe, adapter->netdev,
-			  "failed to request admin irq\n");
+			  "Failed to request admin irq\n");
 		return rc;
 	}
 
 	netif_dbg(adapter, probe, adapter->netdev,
-		  "set affinity hint of mgmnt irq.to 0x%lx (irq vector: %d)\n",
+		  "Set affinity hint of mgmnt irq.to 0x%lx (irq vector: %d)\n",
 		  irq->affinity_hint_mask.bits[0], irq->vector);
 
 	irq_set_affinity_hint(irq->vector, &irq->affinity_hint_mask);
@@ -2096,7 +2102,7 @@ static int ena_request_io_irq(struct ena_adapter *adapter)
 		}
 
 		netif_dbg(adapter, ifup, adapter->netdev,
-			  "set affinity hint of irq. index %d to 0x%lx (irq vector: %d)\n",
+			  "Set affinity hint of irq. index %d to 0x%lx (irq vector: %d)\n",
 			  i, irq->affinity_hint_mask.bits[0], irq->vector);
 
 		irq_set_affinity_hint(irq->vector, &irq->affinity_hint_mask);
@@ -2943,7 +2949,7 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->tx_stats.dma_mapping_err++;
 	u64_stats_update_end(&tx_ring->syncp);
-	netif_warn(adapter, tx_queued, adapter->netdev, "failed to map skb\n");
+	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map skb\n");
 
 	tx_info->skb = NULL;
 
@@ -3353,7 +3359,7 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
 	rc = ena_com_mmio_reg_read_request_init(ena_dev);
 	if (rc) {
-		dev_err(dev, "failed to init mmio read less\n");
+		dev_err(dev, "Failed to init mmio read less\n");
 		return rc;
 	}
 
@@ -3371,7 +3377,7 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 
 	rc = ena_com_validate_version(ena_dev);
 	if (rc) {
-		dev_err(dev, "device version is too low\n");
+		dev_err(dev, "Device version is too low\n");
 		goto err_mmio_read_less;
 	}
 
@@ -3440,7 +3446,7 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 	rc = ena_set_queues_placement_policy(pdev, ena_dev, &get_feat_ctx->llq,
 					     &llq_config);
 	if (rc) {
-		dev_err(&pdev->dev, "ena device init failed\n");
+		dev_err(dev, "ENA device init failed\n");
 		goto err_admin_init;
 	}
 
@@ -3781,7 +3787,7 @@ static void check_for_empty_rx_ring(struct ena_adapter *adapter)
 				u64_stats_update_end(&rx_ring->syncp);
 
 				netif_err(adapter, drv, adapter->netdev,
-					  "trigger refill for ring %d\n", i);
+					  "Trigger refill for ring %d\n", i);
 
 				napi_schedule(rx_ring->napi);
 				rx_ring->empty_rx_queue = 0;
@@ -4182,7 +4188,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					pci_resource_start(pdev, ENA_REG_BAR),
 					pci_resource_len(pdev, ENA_REG_BAR));
 	if (!ena_dev->reg_bar) {
-		dev_err(&pdev->dev, "failed to remap regs bar\n");
+		dev_err(&pdev->dev, "Failed to remap regs bar\n");
 		rc = -EFAULT;
 		goto err_free_region;
 	}
@@ -4193,7 +4199,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
 	if (rc) {
-		dev_err(&pdev->dev, "ena device init failed\n");
+		dev_err(&pdev->dev, "ENA device init failed\n");
 		if (rc == -ETIME)
 			rc = -EPROBE_DEFER;
 		goto err_free_region;
@@ -4201,7 +4207,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
 	if (rc) {
-		dev_err(&pdev->dev, "ena llq bar mapping failed\n");
+		dev_err(&pdev->dev, "ENA llq bar mapping failed\n");
 		goto err_free_ena_dev;
 	}
 
@@ -4466,7 +4472,7 @@ static int __maybe_unused ena_suspend(struct device *dev_d)
 	rtnl_lock();
 	if (unlikely(test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
 		dev_err(&pdev->dev,
-			"ignoring device reset request as the device is being suspended\n");
+			"Ignoring device reset request as the device is being suspended\n");
 		clear_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
 	}
 	ena_destroy_device(adapter, true);
@@ -4585,7 +4591,7 @@ static void ena_notification(void *adapter_data,
 	     aenq_e->aenq_common_desc.group,
 	     ENA_ADMIN_NOTIFICATION);
 
-	switch (aenq_e->aenq_common_desc.syndrom) {
+	switch (aenq_e->aenq_common_desc.syndrome) {
 	case ENA_ADMIN_UPDATE_HINTS:
 		hints = (struct ena_admin_ena_hw_hints *)
 			(&aenq_e->inline_data_w4);
@@ -4594,7 +4600,7 @@ static void ena_notification(void *adapter_data,
 	default:
 		netif_err(adapter, drv, adapter->netdev,
 			  "Invalid aenq notification link state %d\n",
-			  aenq_e->aenq_common_desc.syndrom);
+			  aenq_e->aenq_common_desc.syndrome);
 	}
 }
 
-- 
2.17.1

