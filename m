Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8813AEA5D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFUNwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFUNwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:52:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8E0C061574;
        Mon, 21 Jun 2021 06:49:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o10-20020a17090aac0ab029016e92770073so12146pjq.5;
        Mon, 21 Jun 2021 06:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1jDp+GZOF7l5gwkQF4lqrVNesnClGcHs8kELn01Fz8=;
        b=m9r75rp8My5qvOqXske2JMVLctgKvs/QGhxOls+Gc5M01+qHg/suHCr8Nu+ytafUGP
         A0733d9IftUFdWjWtV00WJ9HuYlN6TJRK9N9TwYAnhcRb3I0Qi+2kn2C11/wPbAVrA/p
         /X3MXRsxEoUGJkFOEKkJfnESngCaooApHfNuNBKsnM7mxm3MIcUjP8PjOvRY4pN22lbk
         EdwIIO2a7DYYzXx9z8KlRWWoThDec9y3qrHlS8oR7tdvevMt7JbCb3aUPpkVqfeJIGQg
         +6GCM3MUxsfmPqTILSoNPxQrQNIUNZdDwwG09oi5O8SVUJkbk21II4ACCs9oVTTaUPcj
         /HVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1jDp+GZOF7l5gwkQF4lqrVNesnClGcHs8kELn01Fz8=;
        b=Dj/Po9RVS4TQl2+xFqzxSGV2vwfsLAtSJZa94IZrqLB2JZsZXsZqkptdaeUHYmzZ8D
         gZHe94Wc1lTwpzyveSq8+ogYImwhrgNBoGsn/n4SZM3WkSSqdyvy3TugUDDE3JpFzXjP
         47H1lpK78a+RkEDZ+SNg8eCft3rhHHchiLZqIsijsc2xZBWcE4MYDvIppkBBI+Uz2HHI
         8aBe9MFZ5RmPu0UMPf9RLfbybtJnZjHg81nA0AJ+NvRnz+S1NVbkxMOHQ3XZ0hg7fW5C
         heS9q6J51j9dRlgCD0teHfeymFUvBcfah6XYrsc2KxpOhICu1j4L/p27kR4tPc6kOADc
         e/fA==
X-Gm-Message-State: AOAM532Xy2Iu9T6BJCusdNHX1nGUnYSIKqPIDTbF+SPNg0f81MnQIsWM
        07t1dVm1StcXjpPLVtazLqg=
X-Google-Smtp-Source: ABdhPJxtULWv0iOqSvXrINHY44yy6MnF7sUCMncpWGlYtkN5PUtZPaCVbLql7wVVoWpRD34DW7wX4w==
X-Received: by 2002:a17:90a:a790:: with SMTP id f16mr38840604pjq.176.1624283390811;
        Mon, 21 Jun 2021 06:49:50 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z15sm18030311pgu.71.2021.06.21.06.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:49:50 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 04/19] staging: qlge: add qlge_* prefix to avoid namespace clashes
Date:   Mon, 21 Jun 2021 21:48:47 +0800
Message-Id: <20210621134902.83587-5-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends commit f8c047be540197ec69cde33e00e82d23961459ea
("staging: qlge: use qlge_* prefix to avoid namespace clashes with other qlogic drivers")
to add qlge_ prefix to rx_ring and tx_ring related structures.

Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h         |  40 ++++-----
 drivers/staging/qlge/qlge_ethtool.c |   4 +-
 drivers/staging/qlge/qlge_main.c    | 124 ++++++++++++++--------------
 3 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index f54d38606b78..09d5878b95f7 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -869,17 +869,17 @@ enum {
 };
 
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-#define SMALL_BUFFER_SIZE 256
-#define SMALL_BUF_MAP_SIZE SMALL_BUFFER_SIZE
+#define QLGE_SMALL_BUFFER_SIZE 256
+#define QLGE_SMALL_BUF_MAP_SIZE QLGE_SMALL_BUFFER_SIZE
 #define SPLT_SETTING  FSC_DBRST_1024
 #define SPLT_LEN 0
 #define QLGE_SB_PAD 0
 #else
-#define SMALL_BUFFER_SIZE 512
-#define SMALL_BUF_MAP_SIZE (SMALL_BUFFER_SIZE / 2)
+#define QLGE_SMALL_BUFFER_SIZE 512
+#define QLGE_SMALL_BUF_MAP_SIZE (QLGE_SMALL_BUFFER_SIZE / 2)
 #define SPLT_SETTING  FSC_SH
 #define SPLT_LEN (SPLT_HDR_EP | \
-	min(SMALL_BUF_MAP_SIZE, 1023))
+	min(QLGE_SMALL_BUF_MAP_SIZE, 1023))
 #define QLGE_SB_PAD 32
 #endif
 
@@ -1063,7 +1063,7 @@ struct tx_doorbell_context {
 };
 
 /* DATA STRUCTURES SHARED WITH HARDWARE. */
-struct tx_buf_desc {
+struct qlge_tx_buf_desc {
 	__le64 addr;
 	__le32 len;
 #define TX_DESC_LEN_MASK	0x000fffff
@@ -1101,7 +1101,7 @@ struct qlge_ob_mac_iocb_req {
 	__le32 reserved3;
 	__le16 vlan_tci;
 	__le16 reserved4;
-	struct tx_buf_desc tbd[TX_DESC_PER_IOCB];
+	struct qlge_tx_buf_desc tbd[TX_DESC_PER_IOCB];
 } __packed;
 
 struct qlge_ob_mac_iocb_rsp {
@@ -1146,7 +1146,7 @@ struct qlge_ob_mac_tso_iocb_req {
 #define OB_MAC_TRANSPORT_HDR_SHIFT 6
 	__le16 vlan_tci;
 	__le16 mss;
-	struct tx_buf_desc tbd[TX_DESC_PER_IOCB];
+	struct qlge_tx_buf_desc tbd[TX_DESC_PER_IOCB];
 } __packed;
 
 struct qlge_ob_mac_tso_iocb_rsp {
@@ -1347,7 +1347,7 @@ struct ricb {
 /* SOFTWARE/DRIVER DATA STRUCTURES. */
 
 struct qlge_oal {
-	struct tx_buf_desc oal[TX_DESC_PER_OAL];
+	struct qlge_tx_buf_desc oal[TX_DESC_PER_OAL];
 };
 
 struct map_list {
@@ -1355,19 +1355,19 @@ struct map_list {
 	DEFINE_DMA_UNMAP_LEN(maplen);
 };
 
-struct tx_ring_desc {
+struct qlge_tx_ring_desc {
 	struct sk_buff *skb;
 	struct qlge_ob_mac_iocb_req *queue_entry;
 	u32 index;
 	struct qlge_oal oal;
 	struct map_list map[MAX_SKB_FRAGS + 2];
 	int map_cnt;
-	struct tx_ring_desc *next;
+	struct qlge_tx_ring_desc *next;
 };
 
 #define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % (qdev->tx_ring_count))
 
-struct tx_ring {
+struct qlge_tx_ring {
 	/*
 	 * queue info.
 	 */
@@ -1384,7 +1384,7 @@ struct tx_ring {
 	u16 cq_id;		/* completion (rx) queue for tx completions */
 	u8 wq_id;		/* queue id for this entry */
 	u8 reserved1[3];
-	struct tx_ring_desc *q;	/* descriptor list for the queue */
+	struct qlge_tx_ring_desc *q;	/* descriptor list for the queue */
 	spinlock_t lock;
 	atomic_t tx_count;	/* counts down for every outstanding IO */
 	struct delayed_work tx_work;
@@ -1437,9 +1437,9 @@ struct qlge_bq {
 #define QLGE_BQ_CONTAINER(bq) \
 ({ \
 	typeof(bq) _bq = bq; \
-	(struct rx_ring *)((char *)_bq - (_bq->type == QLGE_SB ? \
-					  offsetof(struct rx_ring, sbq) : \
-					  offsetof(struct rx_ring, lbq))); \
+	(struct qlge_rx_ring *)((char *)_bq - (_bq->type == QLGE_SB ? \
+					  offsetof(struct qlge_rx_ring, sbq) : \
+					  offsetof(struct qlge_rx_ring, lbq))); \
 })
 
 /* Experience shows that the device ignores the low 4 bits of the tail index.
@@ -1456,7 +1456,7 @@ struct qlge_bq {
 		     (_bq)->next_to_clean); \
 })
 
-struct rx_ring {
+struct qlge_rx_ring {
 	struct cqicb cqicb;	/* The chip's completion queue init control block. */
 
 	/* Completion queue elements. */
@@ -2135,8 +2135,8 @@ struct qlge_adapter {
 	int ring_mem_size;
 	void *ring_mem;
 
-	struct rx_ring rx_ring[MAX_RX_RINGS];
-	struct tx_ring tx_ring[MAX_TX_RINGS];
+	struct qlge_rx_ring rx_ring[MAX_RX_RINGS];
+	struct qlge_tx_ring tx_ring[MAX_TX_RINGS];
 	unsigned int lbq_buf_order;
 	u32 lbq_buf_size;
 
@@ -2287,6 +2287,6 @@ void qlge_get_dump(struct qlge_adapter *qdev, void *buff);
 netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev);
 void qlge_check_lb_frame(struct qlge_adapter *qdev, struct sk_buff *skb);
 int qlge_own_firmware(struct qlge_adapter *qdev);
-int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
+int qlge_clean_lb_rx_ring(struct qlge_rx_ring *rx_ring, int budget);
 
 #endif /* _QLGE_H_ */
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index b70570b7b467..22c27b97a908 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -186,7 +186,7 @@ static const char qlge_gstrings_test[][ETH_GSTRING_LEN] = {
 static int qlge_update_ring_coalescing(struct qlge_adapter *qdev)
 {
 	int i, status = 0;
-	struct rx_ring *rx_ring;
+	struct qlge_rx_ring *rx_ring;
 	struct cqicb *cqicb;
 
 	if (!netif_running(qdev->ndev))
@@ -537,7 +537,7 @@ static int qlge_run_loopback_test(struct qlge_adapter *qdev)
 	int i;
 	netdev_tx_t rc;
 	struct sk_buff *skb;
-	unsigned int size = SMALL_BUF_MAP_SIZE;
+	unsigned int size = QLGE_SMALL_BUF_MAP_SIZE;
 
 	for (i = 0; i < 64; i++) {
 		skb = netdev_alloc_skb(qdev->ndev, size);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c91969b01bd5..77c71ae698ab 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -964,7 +964,7 @@ static struct qlge_bq_desc *qlge_get_curr_buf(struct qlge_bq *bq)
 }
 
 static struct qlge_bq_desc *qlge_get_curr_lchunk(struct qlge_adapter *qdev,
-						 struct rx_ring *rx_ring)
+						 struct qlge_rx_ring *rx_ring)
 {
 	struct qlge_bq_desc *lbq_desc = qlge_get_curr_buf(&rx_ring->lbq);
 
@@ -982,7 +982,7 @@ static struct qlge_bq_desc *qlge_get_curr_lchunk(struct qlge_adapter *qdev,
 }
 
 /* Update an rx ring index. */
-static void qlge_update_cq(struct rx_ring *rx_ring)
+static void qlge_update_cq(struct qlge_rx_ring *rx_ring)
 {
 	rx_ring->cnsmr_idx++;
 	rx_ring->curr_entry++;
@@ -992,7 +992,7 @@ static void qlge_update_cq(struct rx_ring *rx_ring)
 	}
 }
 
-static void qlge_write_cq_idx(struct rx_ring *rx_ring)
+static void qlge_write_cq_idx(struct qlge_rx_ring *rx_ring)
 {
 	qlge_write_db_reg(rx_ring->cnsmr_idx, rx_ring->cnsmr_idx_db_reg);
 }
@@ -1003,7 +1003,7 @@ static const char * const bq_type_name[] = {
 };
 
 /* return 0 or negative error */
-static int qlge_refill_sb(struct rx_ring *rx_ring,
+static int qlge_refill_sb(struct qlge_rx_ring *rx_ring,
 			  struct qlge_bq_desc *sbq_desc, gfp_t gfp)
 {
 	struct qlge_adapter *qdev = rx_ring->qdev;
@@ -1016,13 +1016,13 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
 		     "ring %u sbq: getting new skb for index %d.\n",
 		     rx_ring->cq_id, sbq_desc->index);
 
-	skb = __netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE, gfp);
+	skb = __netdev_alloc_skb(qdev->ndev, QLGE_SMALL_BUFFER_SIZE, gfp);
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, QLGE_SB_PAD);
 
 	sbq_desc->dma_addr = dma_map_single(&qdev->pdev->dev, skb->data,
-					    SMALL_BUF_MAP_SIZE,
+					    QLGE_SMALL_BUF_MAP_SIZE,
 					    DMA_FROM_DEVICE);
 	if (dma_mapping_error(&qdev->pdev->dev, sbq_desc->dma_addr)) {
 		netif_err(qdev, ifup, qdev->ndev, "PCI mapping failed.\n");
@@ -1036,7 +1036,7 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
 }
 
 /* return 0 or negative error */
-static int qlge_refill_lb(struct rx_ring *rx_ring,
+static int qlge_refill_lb(struct qlge_rx_ring *rx_ring,
 			  struct qlge_bq_desc *lbq_desc, gfp_t gfp)
 {
 	struct qlge_adapter *qdev = rx_ring->qdev;
@@ -1086,7 +1086,7 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
 /* return 0 or negative error */
 static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 {
-	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
+	struct qlge_rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
 	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct qlge_bq_desc *bq_desc;
 	int refill_count;
@@ -1141,7 +1141,7 @@ static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 	return retval;
 }
 
-static void qlge_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
+static void qlge_update_buffer_queues(struct qlge_rx_ring *rx_ring, gfp_t gfp,
 				      unsigned long delay)
 {
 	bool sbq_fail, lbq_fail;
@@ -1168,7 +1168,7 @@ static void qlge_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
 
 static void qlge_slow_refill(struct work_struct *work)
 {
-	struct rx_ring *rx_ring = container_of(work, struct rx_ring,
+	struct qlge_rx_ring *rx_ring = container_of(work, struct qlge_rx_ring,
 					       refill_work.work);
 	struct napi_struct *napi = &rx_ring->napi;
 
@@ -1189,7 +1189,7 @@ static void qlge_slow_refill(struct work_struct *work)
  * fails at some stage, or from the interrupt when a tx completes.
  */
 static void qlge_unmap_send(struct qlge_adapter *qdev,
-			    struct tx_ring_desc *tx_ring_desc, int mapped)
+			    struct qlge_tx_ring_desc *tx_ring_desc, int mapped)
 {
 	int i;
 
@@ -1232,12 +1232,12 @@ static void qlge_unmap_send(struct qlge_adapter *qdev,
  */
 static int qlge_map_send(struct qlge_adapter *qdev,
 			 struct qlge_ob_mac_iocb_req *mac_iocb_ptr,
-			 struct sk_buff *skb, struct tx_ring_desc *tx_ring_desc)
+			 struct sk_buff *skb, struct qlge_tx_ring_desc *tx_ring_desc)
 {
 	int len = skb_headlen(skb);
 	dma_addr_t map;
 	int frag_idx, err, map_idx = 0;
-	struct tx_buf_desc *tbd = mac_iocb_ptr->tbd;
+	struct qlge_tx_buf_desc *tbd = mac_iocb_ptr->tbd;
 	int frag_cnt = skb_shinfo(skb)->nr_frags;
 
 	if (frag_cnt) {
@@ -1312,13 +1312,13 @@ static int qlge_map_send(struct qlge_adapter *qdev,
 			 * of our sglist (OAL).
 			 */
 			tbd->len =
-			    cpu_to_le32((sizeof(struct tx_buf_desc) *
+			    cpu_to_le32((sizeof(struct qlge_tx_buf_desc) *
 					 (frag_cnt - frag_idx)) | TX_DESC_C);
 			dma_unmap_addr_set(&tx_ring_desc->map[map_idx], mapaddr,
 					   map);
 			dma_unmap_len_set(&tx_ring_desc->map[map_idx], maplen,
 					  sizeof(struct qlge_oal));
-			tbd = (struct tx_buf_desc *)&tx_ring_desc->oal;
+			tbd = (struct qlge_tx_buf_desc *)&tx_ring_desc->oal;
 			map_idx++;
 		}
 
@@ -1358,7 +1358,7 @@ static int qlge_map_send(struct qlge_adapter *qdev,
 
 /* Categorizing receive firmware frame errors */
 static void qlge_categorize_rx_err(struct qlge_adapter *qdev, u8 rx_err,
-				   struct rx_ring *rx_ring)
+				   struct qlge_rx_ring *rx_ring)
 {
 	struct nic_stats *stats = &qdev->nic_stats;
 
@@ -1414,7 +1414,7 @@ static void qlge_update_mac_hdr_len(struct qlge_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void qlge_process_mac_rx_gro_page(struct qlge_adapter *qdev,
-					 struct rx_ring *rx_ring,
+					 struct qlge_rx_ring *rx_ring,
 					 struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
 					 u32 length, u16 vlan_id)
 {
@@ -1460,7 +1460,7 @@ static void qlge_process_mac_rx_gro_page(struct qlge_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
-				     struct rx_ring *rx_ring,
+				     struct qlge_rx_ring *rx_ring,
 				     struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
 				     u32 length, u16 vlan_id)
 {
@@ -1471,7 +1471,7 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 	struct napi_struct *napi = &rx_ring->napi;
 	size_t hlen = ETH_HLEN;
 
-	skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
+	skb = napi_alloc_skb(&rx_ring->napi, QLGE_SMALL_BUFFER_SIZE);
 	if (!skb) {
 		rx_ring->rx_dropped++;
 		put_page(lbq_desc->p.pg_chunk.page);
@@ -1551,7 +1551,7 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void qlge_process_mac_rx_skb(struct qlge_adapter *qdev,
-				    struct rx_ring *rx_ring,
+				    struct qlge_rx_ring *rx_ring,
 				    struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
 				    u32 length, u16 vlan_id)
 {
@@ -1569,7 +1569,7 @@ static void qlge_process_mac_rx_skb(struct qlge_adapter *qdev,
 	skb_reserve(new_skb, NET_IP_ALIGN);
 
 	dma_sync_single_for_cpu(&qdev->pdev->dev, sbq_desc->dma_addr,
-				SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
+				QLGE_SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
 
 	skb_put_data(new_skb, skb->data, length);
 
@@ -1671,7 +1671,7 @@ static void qlge_realign_skb(struct sk_buff *skb, int len)
  * future, but for not it works well.
  */
 static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
-					 struct rx_ring *rx_ring,
+					 struct qlge_rx_ring *rx_ring,
 					 struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
@@ -1692,7 +1692,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 		 */
 		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
-				 SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
+				 QLGE_SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
 		skb = sbq_desc->p.skb;
 		qlge_realign_skb(skb, hdr_len);
 		skb_put(skb, hdr_len);
@@ -1723,7 +1723,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 			sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 			dma_sync_single_for_cpu(&qdev->pdev->dev,
 						sbq_desc->dma_addr,
-						SMALL_BUF_MAP_SIZE,
+						QLGE_SMALL_BUF_MAP_SIZE,
 						DMA_FROM_DEVICE);
 			skb_put_data(skb, sbq_desc->p.skb->data, length);
 		} else {
@@ -1735,7 +1735,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 			qlge_realign_skb(skb, length);
 			skb_put(skb, length);
 			dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
-					 SMALL_BUF_MAP_SIZE,
+					 QLGE_SMALL_BUF_MAP_SIZE,
 					 DMA_FROM_DEVICE);
 			sbq_desc->p.skb = NULL;
 		}
@@ -1765,7 +1765,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 			 * jumbo mtu on a non-TCP/UDP frame.
 			 */
 			lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
-			skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
+			skb = napi_alloc_skb(&rx_ring->napi, QLGE_SMALL_BUFFER_SIZE);
 			if (!skb) {
 				netif_printk(qdev, probe, KERN_DEBUG, qdev->ndev,
 					     "No skb available, drop the packet.\n");
@@ -1805,7 +1805,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 
 		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
-				 SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
+				 QLGE_SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
 		if (!(ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS)) {
 			/*
 			 * This is an non TCP/UDP IP frame, so
@@ -1848,7 +1848,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void qlge_process_mac_split_rx_intr(struct qlge_adapter *qdev,
-					   struct rx_ring *rx_ring,
+					   struct qlge_rx_ring *rx_ring,
 					   struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
 					   u16 vlan_id)
 {
@@ -1942,7 +1942,7 @@ static void qlge_process_mac_split_rx_intr(struct qlge_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
-					      struct rx_ring *rx_ring,
+					      struct qlge_rx_ring *rx_ring,
 					      struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
@@ -1993,8 +1993,8 @@ static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
 static void qlge_process_mac_tx_intr(struct qlge_adapter *qdev,
 				     struct qlge_ob_mac_iocb_rsp *mac_rsp)
 {
-	struct tx_ring *tx_ring;
-	struct tx_ring_desc *tx_ring_desc;
+	struct qlge_tx_ring *tx_ring;
+	struct qlge_tx_ring_desc *tx_ring_desc;
 
 	tx_ring = &qdev->tx_ring[mac_rsp->txq_idx];
 	tx_ring_desc = &tx_ring->q[mac_rsp->tid];
@@ -2087,14 +2087,14 @@ static void qlge_process_chip_ae_intr(struct qlge_adapter *qdev,
 	}
 }
 
-static int qlge_clean_outbound_rx_ring(struct rx_ring *rx_ring)
+static int qlge_clean_outbound_rx_ring(struct qlge_rx_ring *rx_ring)
 {
 	struct qlge_adapter *qdev = rx_ring->qdev;
 	u32 prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
 	struct qlge_ob_mac_iocb_rsp *net_rsp = NULL;
 	int count = 0;
 
-	struct tx_ring *tx_ring;
+	struct qlge_tx_ring *tx_ring;
 	/* While there are entries in the completion queue. */
 	while (prod != rx_ring->cnsmr_idx) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -2133,7 +2133,7 @@ static int qlge_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 	return count;
 }
 
-static int qlge_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
+static int qlge_clean_inbound_rx_ring(struct qlge_rx_ring *rx_ring, int budget)
 {
 	struct qlge_adapter *qdev = rx_ring->qdev;
 	u32 prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
@@ -2178,9 +2178,9 @@ static int qlge_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 
 static int qlge_napi_poll_msix(struct napi_struct *napi, int budget)
 {
-	struct rx_ring *rx_ring = container_of(napi, struct rx_ring, napi);
+	struct qlge_rx_ring *rx_ring = container_of(napi, struct qlge_rx_ring, napi);
 	struct qlge_adapter *qdev = rx_ring->qdev;
-	struct rx_ring *trx_ring;
+	struct qlge_rx_ring *trx_ring;
 	int i, work_done = 0;
 	struct intr_context *ctx = &qdev->intr_context[rx_ring->cq_id];
 
@@ -2368,7 +2368,7 @@ static void qlge_restore_vlan(struct qlge_adapter *qdev)
 /* MSI-X Multiple Vector Interrupt Handler for inbound completions. */
 static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 {
-	struct rx_ring *rx_ring = dev_id;
+	struct qlge_rx_ring *rx_ring = dev_id;
 
 	napi_schedule(&rx_ring->napi);
 	return IRQ_HANDLED;
@@ -2381,7 +2381,7 @@ static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
  */
 static irqreturn_t qlge_isr(int irq, void *dev_id)
 {
-	struct rx_ring *rx_ring = dev_id;
+	struct qlge_rx_ring *rx_ring = dev_id;
 	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct intr_context *intr_context = &qdev->intr_context[0];
 	u32 var;
@@ -2529,9 +2529,9 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct qlge_ob_mac_iocb_req *mac_iocb_ptr;
-	struct tx_ring_desc *tx_ring_desc;
+	struct qlge_tx_ring_desc *tx_ring_desc;
 	int tso;
-	struct tx_ring *tx_ring;
+	struct qlge_tx_ring *tx_ring;
 	u32 tx_ring_idx = (u32)skb->queue_mapping;
 
 	tx_ring = &qdev->tx_ring[tx_ring_idx];
@@ -2654,9 +2654,9 @@ static int qlge_alloc_shadow_space(struct qlge_adapter *qdev)
 	return -ENOMEM;
 }
 
-static void qlge_init_tx_ring(struct qlge_adapter *qdev, struct tx_ring *tx_ring)
+static void qlge_init_tx_ring(struct qlge_adapter *qdev, struct qlge_tx_ring *tx_ring)
 {
-	struct tx_ring_desc *tx_ring_desc;
+	struct qlge_tx_ring_desc *tx_ring_desc;
 	int i;
 	struct qlge_ob_mac_iocb_req *mac_iocb_ptr;
 
@@ -2673,7 +2673,7 @@ static void qlge_init_tx_ring(struct qlge_adapter *qdev, struct tx_ring *tx_ring
 }
 
 static void qlge_free_tx_resources(struct qlge_adapter *qdev,
-				   struct tx_ring *tx_ring)
+				   struct qlge_tx_ring *tx_ring)
 {
 	if (tx_ring->wq_base) {
 		dma_free_coherent(&qdev->pdev->dev, tx_ring->wq_size,
@@ -2685,7 +2685,7 @@ static void qlge_free_tx_resources(struct qlge_adapter *qdev,
 }
 
 static int qlge_alloc_tx_resources(struct qlge_adapter *qdev,
-				   struct tx_ring *tx_ring)
+				   struct qlge_tx_ring *tx_ring)
 {
 	tx_ring->wq_base =
 		dma_alloc_coherent(&qdev->pdev->dev, tx_ring->wq_size,
@@ -2696,7 +2696,7 @@ static int qlge_alloc_tx_resources(struct qlge_adapter *qdev,
 		goto pci_alloc_err;
 
 	tx_ring->q =
-		kmalloc_array(tx_ring->wq_len, sizeof(struct tx_ring_desc),
+		kmalloc_array(tx_ring->wq_len, sizeof(struct qlge_tx_ring_desc),
 			      GFP_KERNEL);
 	if (!tx_ring->q)
 		goto err;
@@ -2711,7 +2711,7 @@ static int qlge_alloc_tx_resources(struct qlge_adapter *qdev,
 	return -ENOMEM;
 }
 
-static void qlge_free_lbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
+static void qlge_free_lbq_buffers(struct qlge_adapter *qdev, struct qlge_rx_ring *rx_ring)
 {
 	struct qlge_bq *lbq = &rx_ring->lbq;
 	unsigned int last_offset;
@@ -2738,7 +2738,7 @@ static void qlge_free_lbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_
 	}
 }
 
-static void qlge_free_sbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
+static void qlge_free_sbq_buffers(struct qlge_adapter *qdev, struct qlge_rx_ring *rx_ring)
 {
 	int i;
 
@@ -2752,7 +2752,7 @@ static void qlge_free_sbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_
 		}
 		if (sbq_desc->p.skb) {
 			dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
-					 SMALL_BUF_MAP_SIZE,
+					 QLGE_SMALL_BUF_MAP_SIZE,
 					 DMA_FROM_DEVICE);
 			dev_kfree_skb(sbq_desc->p.skb);
 			sbq_desc->p.skb = NULL;
@@ -2768,7 +2768,7 @@ static void qlge_free_rx_buffers(struct qlge_adapter *qdev)
 	int i;
 
 	for (i = 0; i < qdev->rx_ring_count; i++) {
-		struct rx_ring *rx_ring = &qdev->rx_ring[i];
+		struct qlge_rx_ring *rx_ring = &qdev->rx_ring[i];
 
 		if (rx_ring->lbq.queue)
 			qlge_free_lbq_buffers(qdev, rx_ring);
@@ -2788,7 +2788,7 @@ static void qlge_alloc_rx_buffers(struct qlge_adapter *qdev)
 
 static int qlge_init_bq(struct qlge_bq *bq)
 {
-	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
+	struct qlge_rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
 	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct qlge_bq_desc *bq_desc;
 	__le64 *buf_ptr;
@@ -2816,7 +2816,7 @@ static int qlge_init_bq(struct qlge_bq *bq)
 }
 
 static void qlge_free_rx_resources(struct qlge_adapter *qdev,
-				   struct rx_ring *rx_ring)
+				   struct qlge_rx_ring *rx_ring)
 {
 	/* Free the small buffer queue. */
 	if (rx_ring->sbq.base) {
@@ -2853,7 +2853,7 @@ static void qlge_free_rx_resources(struct qlge_adapter *qdev,
  * on the values in the parameter structure.
  */
 static int qlge_alloc_rx_resources(struct qlge_adapter *qdev,
-				   struct rx_ring *rx_ring)
+				   struct qlge_rx_ring *rx_ring)
 {
 	/*
 	 * Allocate the completion queue for this rx_ring.
@@ -2878,8 +2878,8 @@ static int qlge_alloc_rx_resources(struct qlge_adapter *qdev,
 
 static void qlge_tx_ring_clean(struct qlge_adapter *qdev)
 {
-	struct tx_ring *tx_ring;
-	struct tx_ring_desc *tx_ring_desc;
+	struct qlge_tx_ring *tx_ring;
+	struct qlge_tx_ring_desc *tx_ring_desc;
 	int i, j;
 
 	/*
@@ -2949,7 +2949,7 @@ static int qlge_alloc_mem_resources(struct qlge_adapter *qdev)
  * The control block is defined as
  * "Completion Queue Initialization Control Block", or cqicb.
  */
-static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
+static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct qlge_rx_ring *rx_ring)
 {
 	struct cqicb *cqicb = &rx_ring->cqicb;
 	void *shadow_reg = qdev->rx_ring_shadow_reg_area +
@@ -3036,7 +3036,7 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
-		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
+		cqicb->sbq_buf_size = cpu_to_le16(QLGE_SMALL_BUFFER_SIZE);
 		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
 		rx_ring->sbq.next_to_use = 0;
 		rx_ring->sbq.next_to_clean = 0;
@@ -3062,7 +3062,7 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 	return err;
 }
 
-static int qlge_start_tx_ring(struct qlge_adapter *qdev, struct tx_ring *tx_ring)
+static int qlge_start_tx_ring(struct qlge_adapter *qdev, struct qlge_tx_ring *tx_ring)
 {
 	struct wqicb *wqicb = (struct wqicb *)tx_ring;
 	void __iomem *doorbell_area =
@@ -3917,8 +3917,8 @@ static void qlge_set_lb_size(struct qlge_adapter *qdev)
 static int qlge_configure_rings(struct qlge_adapter *qdev)
 {
 	int i;
-	struct rx_ring *rx_ring;
-	struct tx_ring *tx_ring;
+	struct qlge_rx_ring *rx_ring;
+	struct qlge_tx_ring *tx_ring;
 	int cpu_cnt = min_t(int, MAX_CPUS, num_online_cpus());
 
 	/* In a perfect world we have one RSS ring for each CPU
@@ -4083,8 +4083,8 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 					       *ndev)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
-	struct rx_ring *rx_ring = &qdev->rx_ring[0];
-	struct tx_ring *tx_ring = &qdev->tx_ring[0];
+	struct qlge_rx_ring *rx_ring = &qdev->rx_ring[0];
+	struct qlge_tx_ring *tx_ring = &qdev->tx_ring[0];
 	unsigned long pkts, mcast, dropped, errors, bytes;
 	int i;
 
@@ -4648,7 +4648,7 @@ netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev)
 	return qlge_send(skb, ndev);
 }
 
-int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget)
+int qlge_clean_lb_rx_ring(struct qlge_rx_ring *rx_ring, int budget)
 {
 	return qlge_clean_inbound_rx_ring(rx_ring, budget);
 }
-- 
2.32.0

