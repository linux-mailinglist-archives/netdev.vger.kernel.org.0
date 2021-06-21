Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3F23AEA7A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFUNyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhFUNyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:54:12 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF40C06175F;
        Mon, 21 Jun 2021 06:51:58 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m17so5413044plx.7;
        Mon, 21 Jun 2021 06:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CzTn4Xgtstg1K+676euDxy0Tn/X8cl4RaZRYaImsaO4=;
        b=YLzVte0fuyu74sfSrjAYeoQ7ZSR04nfSu0FK5oTdV1/XuYne/AEBHDRF7T9vrWWQe/
         l5td5wG4BcleFG6dBB7pxtWqeXcQPeaaWRko7tz9xNp03YoMyF/9hlySkWdVvJeJqrgS
         L1qjDNqt+HBmhUMc/YTKEFHaLHNEzaEV0pW62t7YxCA3gjYPdD906DnJA93lRRq0zCzS
         4jIREY/8m2NIaW+ErhsBh4qkmZQv6XKx1dYgvXoraNJfV1cNzjBZ7PVNUO0XgIItPJZE
         GQQsAczGbezjrl4G7Y3CbcOW6oXQhNjY1gVBf06u7rBFgT+43CmjkeyQ3sqMUc4VBirQ
         AcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CzTn4Xgtstg1K+676euDxy0Tn/X8cl4RaZRYaImsaO4=;
        b=DuoWNqVX7h4MZZhA/sOwi1lVrkteuyUQWuuGqDRH4/jVpBigJZk30urRrr9VqwCan/
         EJzQ+w/aBxsH3Ki1KogcbjKaT4oXp1zsyg2hksQ+qosJh/5p3ftq/4zvEGd09VbiHbX6
         +D0vosbmCBLAsrrEsZiyM0tEQVlxgw81PgLZC5dXbOuQdtjnnhOnDkIVOykMpS4eJVx7
         KG2nhvF7IuYdHWyj3vlT7nPPe1DyHts36UDCjUH9fNZzSnmeiKTid9eaPv7wpu86ibkm
         aP8gVFSExLTuOuoPMI1edwTiydHfCkkafANNXD0O5/5sqZoyQ5lJ0u0aQ7qngEamTQ11
         HBvw==
X-Gm-Message-State: AOAM5335H8ZPIpqOeauJ/sWMNrjqLB4hnoaFMTHIP8HoGL2vRDt5n72Z
        PTA5N5iXxSQIvToWkct8VlY=
X-Google-Smtp-Source: ABdhPJwX9uPz0oOExUW9zt2aeG0/c1DLxYAleX6HTTvFQDLzvS5/fZdIKtnIm4UL+gzUialOuil3RQ==
X-Received: by 2002:a17:902:e8c2:b029:123:25ba:e443 with SMTP id v2-20020a170902e8c2b029012325bae443mr10425855plg.29.1624283517719;
        Mon, 21 Jun 2021 06:51:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b18sm1147766pjq.2.2021.06.21.06.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:51:57 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org (open list),
        clang-built-linux@googlegroups.com (open list:CLANG/LLVM BUILD SUPPORT)
Subject: [RFC 17/19] staging: qlge: fix weird line wrapping
Date:   Mon, 21 Jun 2021 21:49:00 +0800
Message-Id: <20210621134902.83587-18-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits fix weird line wrapping based on "clang-format
drivers/staging/qlge/qlge_main.c"

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO        |   2 -
 drivers/staging/qlge/qlge_main.c | 106 +++++++++++++++----------------
 2 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 0f96186ed77c..b8def0c70614 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -1,7 +1,5 @@
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
 * remove duplicate and useless comments
-* fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
-  qlge_set_multicast_list()).
 * fix weird indentation (all over, ex. the for loops in qlge_get_stats())
 * fix checkpatch issues
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index e560006225ca..21fb942c2595 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -442,8 +442,7 @@ static int qlge_set_mac_addr(struct qlge_adapter *qdev, int set)
 	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = qlge_set_mac_addr_reg(qdev, (u8 *)addr,
-				       MAC_ADDR_TYPE_CAM_MAC,
+	status = qlge_set_mac_addr_reg(qdev, (u8 *)addr, MAC_ADDR_TYPE_CAM_MAC,
 				       qdev->func * MAX_CQ);
 	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
@@ -524,8 +523,8 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
 		{
 			value = RT_IDX_DST_DFLT_Q | /* dest */
 				RT_IDX_TYPE_NICQ | /* type */
-				(RT_IDX_IP_CSUM_ERR_SLOT <<
-				RT_IDX_IDX_SHIFT); /* index */
+			(RT_IDX_IP_CSUM_ERR_SLOT
+			 << RT_IDX_IDX_SHIFT); /* index */
 			break;
 		}
 	case RT_IDX_TU_CSUM_ERR: /* Pass up TCP/UDP CSUM error frames. */
@@ -554,7 +553,8 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
 		{
 			value = RT_IDX_DST_DFLT_Q |	/* dest */
 			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_MCAST_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
+			(RT_IDX_MCAST_MATCH_SLOT
+			 << RT_IDX_IDX_SHIFT); /* index */
 			break;
 		}
 	case RT_IDX_RSS_MATCH:	/* Pass up matched RSS frames. */
@@ -648,15 +648,15 @@ static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset, __le32 *d
 {
 	int status = 0;
 	/* wait for reg to come ready */
-	status = qlge_wait_reg_rdy(qdev,
-				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev, FLASH_ADDR, FLASH_ADDR_RDY,
+				   FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* set up for reg read */
 	qlge_write32(qdev, FLASH_ADDR, FLASH_ADDR_R | offset);
 	/* wait for reg to come ready */
-	status = qlge_wait_reg_rdy(qdev,
-				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev, FLASH_ADDR, FLASH_ADDR_RDY,
+				   FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* This data is stored on flash as an array of
@@ -792,8 +792,8 @@ static int qlge_write_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 data)
 {
 	int status;
 	/* wait for reg to come ready */
-	status = qlge_wait_reg_rdy(qdev,
-				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
+				   XGMAC_ADDR_XME);
 	if (status)
 		return status;
 	/* write the data to the data reg */
@@ -811,15 +811,15 @@ int qlge_read_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 *data)
 {
 	int status = 0;
 	/* wait for reg to come ready */
-	status = qlge_wait_reg_rdy(qdev,
-				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
+				   XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 	/* set up for reg read */
 	qlge_write32(qdev, XGMAC_ADDR, reg | XGMAC_ADDR_R);
 	/* wait for reg to come ready */
-	status = qlge_wait_reg_rdy(qdev,
-				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
+				   XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 	/* get the data */
@@ -1067,8 +1067,8 @@ static int qlge_refill_lb(struct qlge_rx_ring *rx_ring,
 
 	lbq_desc->p.pg_chunk = *master_chunk;
 	lbq_desc->dma_addr = rx_ring->chunk_dma_addr;
-	*lbq_desc->buf_ptr = cpu_to_le64(lbq_desc->dma_addr +
-					 lbq_desc->p.pg_chunk.offset);
+	*lbq_desc->buf_ptr =
+		cpu_to_le64(lbq_desc->dma_addr + lbq_desc->p.pg_chunk.offset);
 
 	/* Adjust the master page chunk for next
 	 * buffer get.
@@ -1233,7 +1233,8 @@ static void qlge_unmap_send(struct qlge_adapter *qdev,
  */
 static int qlge_map_send(struct qlge_adapter *qdev,
 			 struct qlge_ob_mac_iocb_req *mac_iocb_ptr,
-			 struct sk_buff *skb, struct qlge_tx_ring_desc *tx_ring_desc)
+			 struct sk_buff *skb,
+			 struct qlge_tx_ring_desc *tx_ring_desc)
 {
 	int len = skb_headlen(skb);
 	dma_addr_t map;
@@ -1295,7 +1296,8 @@ static int qlge_map_send(struct qlge_adapter *qdev,
 			 *      etc...
 			 */
 			/* Tack on the OAL in the eighth segment of IOCB. */
-			map = dma_map_single(&qdev->pdev->dev, &tx_ring_desc->oal,
+			map = dma_map_single(&qdev->pdev->dev,
+					     &tx_ring_desc->oal,
 					     sizeof(struct qlge_oal),
 					     DMA_TO_DEVICE);
 			err = dma_mapping_error(&qdev->pdev->dev, map);
@@ -1405,8 +1407,7 @@ static void qlge_update_mac_hdr_len(struct qlge_adapter *qdev,
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) {
 		tags = (u16 *)page;
 		/* Look for stacked vlan tags in ethertype field */
-		if (tags[6] == ETH_P_8021Q &&
-		    tags[8] == ETH_P_8021Q)
+		if (tags[6] == ETH_P_8021Q && tags[8] == ETH_P_8021Q)
 			*len += 2 * VLAN_HLEN;
 		else
 			*len += VLAN_HLEN;
@@ -1442,8 +1443,7 @@ static void qlge_process_mac_rx_gro_page(struct qlge_adapter *qdev,
 	prefetch(lbq_desc->p.pg_chunk.va);
 	__skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
 			     lbq_desc->p.pg_chunk.page,
-			     lbq_desc->p.pg_chunk.offset,
-			     length);
+			     lbq_desc->p.pg_chunk.offset, length);
 
 	skb->len += length;
 	skb->data_len += length;
@@ -2264,8 +2264,8 @@ static int __qlge_vlan_rx_add_vid(struct qlge_adapter *qdev, u16 vid)
 	u32 enable_bit = MAC_ADDR_E;
 	int err;
 
-	err = qlge_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
-				    MAC_ADDR_TYPE_VLAN, vid);
+	err = qlge_set_mac_addr_reg(qdev, (u8 *)&enable_bit, MAC_ADDR_TYPE_VLAN,
+				    vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init vlan address.\n");
@@ -2295,8 +2295,8 @@ static int __qlge_vlan_rx_kill_vid(struct qlge_adapter *qdev, u16 vid)
 	u32 enable_bit = 0;
 	int err;
 
-	err = qlge_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
-				    MAC_ADDR_TYPE_VLAN, vid);
+	err = qlge_set_mac_addr_reg(qdev, (u8 *)&enable_bit, MAC_ADDR_TYPE_VLAN,
+				    vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to clear vlan address.\n");
@@ -2400,8 +2400,8 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 		netif_err(qdev, intr, qdev->ndev,
 			  "Got MPI processor interrupt.\n");
 		qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
-		queue_delayed_work_on(smp_processor_id(),
-				      qdev->workqueue, &qdev->mpi_work, 0);
+		queue_delayed_work_on(smp_processor_id(), qdev->workqueue,
+				      &qdev->mpi_work, 0);
 		work_done++;
 	}
 
@@ -2730,8 +2730,7 @@ static void qlge_free_sbq_buffers(struct qlge_adapter *qdev, struct qlge_rx_ring
 		}
 		if (sbq_desc->p.skb) {
 			dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
-					 QLGE_SMALL_BUF_MAP_SIZE,
-					 DMA_FROM_DEVICE);
+					 QLGE_SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(sbq_desc->p.skb);
 			sbq_desc->p.skb = NULL;
 		}
@@ -2824,9 +2823,8 @@ static void qlge_free_cq_resources(struct qlge_adapter *qdev,
 
 	/* Free the completion queue. */
 	if (cq->cq_base) {
-		dma_free_coherent(&qdev->pdev->dev,
-				  cq->cq_size,
-				  cq->cq_base, cq->cq_base_dma);
+		dma_free_coherent(&qdev->pdev->dev, cq->cq_size, cq->cq_base,
+				  cq->cq_base_dma);
 		cq->cq_base = NULL;
 	}
 }
@@ -3128,8 +3126,8 @@ static void qlge_enable_msix(struct qlge_adapter *qdev)
 		for (i = 0; i < qdev->intr_count; i++)
 			qdev->msi_x_entry[i].entry = i;
 
-		err = pci_enable_msix_range(qdev->pdev, qdev->msi_x_entry,
-					    1, qdev->intr_count);
+		err = pci_enable_msix_range(qdev->pdev, qdev->msi_x_entry, 1,
+					    qdev->intr_count);
 		if (err < 0) {
 			kfree(qdev->msi_x_entry);
 			qdev->msi_x_entry = NULL;
@@ -3509,8 +3507,8 @@ static int qlge_route_initialize(struct qlge_adapter *qdev)
 		}
 	}
 
-	status = qlge_set_routing_reg(qdev, RT_IDX_CAM_HIT_SLOT,
-				      RT_IDX_CAM_HIT, 1);
+	status = qlge_set_routing_reg(qdev, RT_IDX_CAM_HIT_SLOT, RT_IDX_CAM_HIT,
+				      1);
 	if (status)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init routing register for CAM packets.\n");
@@ -3713,8 +3711,8 @@ static void qlge_display_dev_info(struct net_device *ndev)
 		   qdev->chip_rev_id >> 4 & 0x0000000f,
 		   qdev->chip_rev_id >> 8 & 0x0000000f,
 		   qdev->chip_rev_id >> 12 & 0x0000000f);
-	netif_info(qdev, probe, qdev->ndev,
-		   "MAC address %pM\n", ndev->dev_addr);
+	netif_info(qdev, probe, qdev->ndev, "MAC address %pM\n",
+		   ndev->dev_addr);
 }
 
 static int qlge_wol(struct qlge_adapter *qdev)
@@ -4119,8 +4117,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	 */
 	if (ndev->flags & IFF_PROMISC) {
 		if (!test_bit(QL_PROMISCUOUS, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_PROMISCUOUS_SLOT,
+						 RT_IDX_VALID, 1)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to set promiscuous mode.\n");
 			} else {
@@ -4129,8 +4127,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	} else {
 		if (test_bit(QL_PROMISCUOUS, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 0)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_PROMISCUOUS_SLOT,
+						 RT_IDX_VALID, 0)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to clear promiscuous mode.\n");
 			} else {
@@ -4146,8 +4144,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	if ((ndev->flags & IFF_ALLMULTI) ||
 	    (netdev_mc_count(ndev) > MAX_MULTICAST_ENTRIES)) {
 		if (!test_bit(QL_ALLMULTI, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_ALLMULTI_SLOT, RT_IDX_MCAST, 1)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_ALLMULTI_SLOT,
+						 RT_IDX_MCAST, 1)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to set all-multi mode.\n");
 			} else {
@@ -4156,8 +4154,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	} else {
 		if (test_bit(QL_ALLMULTI, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_ALLMULTI_SLOT, RT_IDX_MCAST, 0)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_ALLMULTI_SLOT,
+						 RT_IDX_MCAST, 0)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to clear all-multi mode.\n");
 			} else {
@@ -4182,8 +4180,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 			i++;
 		}
 		qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
-		if (qlge_set_routing_reg
-		    (qdev, RT_IDX_MCAST_MATCH_SLOT, RT_IDX_MCAST_MATCH, 1)) {
+		if (qlge_set_routing_reg(qdev, RT_IDX_MCAST_MATCH_SLOT,
+					 RT_IDX_MCAST_MATCH, 1)) {
 			netif_err(qdev, hw, qdev->ndev,
 				  "Failed to set multicast match mode.\n");
 		} else {
@@ -4458,8 +4456,8 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	/*
 	 * Set up the operating parameters.
 	 */
-	qdev->workqueue = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
-						  ndev->name);
+	qdev->workqueue =
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, ndev->name);
 	if (!qdev->workqueue) {
 		err = -ENOMEM;
 		goto err_free_mpi_coredump;
@@ -4702,8 +4700,8 @@ static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
-		dev_err(&pdev->dev,
-			"%s: pci_channel_io_perm_failure.\n", __func__);
+		dev_err(&pdev->dev, "%s: pci_channel_io_perm_failure.\n",
+			__func__);
 		del_timer_sync(&qdev->timer);
 		qlge_eeh_close(ndev);
 		set_bit(QL_EEH_FATAL, &qdev->flags);
-- 
2.32.0

