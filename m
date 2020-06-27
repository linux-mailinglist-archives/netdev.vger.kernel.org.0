Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198C820C296
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgF0O7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 10:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgF0O72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 10:59:28 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7718FC061794;
        Sat, 27 Jun 2020 07:59:28 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y18so5395643plr.4;
        Sat, 27 Jun 2020 07:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gx8o55Wdb5ol/E0krJqispeFXBptvAJDe+BnLnqSQhc=;
        b=LVfYXS/D6+Z+fZ4qypDEFbWyl36NPTj5b8Wn1axZu1FQcgYSjO4TsUHNQIUvOgg7Og
         29OctO9i8f9MX2FH2pHY04b/A9I01ZoRWL11bZ3C3FcvFNo3wM4yF92dhdu+dCpzPs6P
         uVVL/xdWqTKX11aQnLJfbJL9tAe4fn2YBaSXs4rx4UizVDOKeDrxyP2bMhkGQz8WpKSi
         EJ4MOf9a+z21SLgrr3dfbHQu+0Ycu/g803g5/qubt0o99aE1EQvt0SZNsXhdYZCwb15s
         6QR42PO+ACMr3Q99UW1gT0s+/LU/4vOrSHYWLEyr+BY3ZznjZyoU+rf+hWwqkH4XBUFE
         C4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gx8o55Wdb5ol/E0krJqispeFXBptvAJDe+BnLnqSQhc=;
        b=iinCL4rFkgj1flVzq2npPS3Wk5gz+33iyNifoflpjuhdAjbtB/EkUUxjnwXJOc2ON6
         oK1fZNhwILyYvNmaRvYHa349UPz2tPZXgkzzEp4aOb3k6UfP9/dbX8NpAR9y2d40Pn22
         0WOiuTyD5xTNi/3zmwNBeYNrAfZHGgn3ZXNtbcAd17rH+VU1enGt1kbMjfcxsR0e3Aed
         dU9VJGFGPZeNbGOyH2fUxVrHNa4OGAlTISXBNdPDc1qzwXAFBI8+NFdLwOhOfdgsy3OF
         EhKoSlUF1H+CVnu6Oc2xB/aT2RjRNqAg6GE57lhHn4xK/qpwr/mk1YgG83YeFf1hKR5A
         33qA==
X-Gm-Message-State: AOAM533iVBRIpmD9QuhioFXPZSZractD60HDXsCpiSvYyN6BFc9vxbje
        YNMUqZzs6/VjeyBtqIaz2RSUhbM7i0drRtSK
X-Google-Smtp-Source: ABdhPJzXy6QmqRLe3d8p7XVopE7eKtiL6FdLzLnhtmEEyme/kqeZOxn6DMA0fLv8YWtyeAspkFwPDw==
X-Received: by 2002:a17:90a:f206:: with SMTP id bs6mr8931831pjb.48.1593269967682;
        Sat, 27 Jun 2020 07:59:27 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id w24sm28481852pfn.11.2020.06.27.07.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 07:59:27 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     joe@perches.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/4] staging: qlge: replace pr_err with netdev_err
Date:   Sat, 27 Jun 2020 22:58:57 +0800
Message-Id: <20200627145857.15926-5-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200627145857.15926-1-coiby.xu@gmail.com>
References: <20200627145857.15926-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace all pr_errs with netdev_err.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 568 ++++++++++++++++----------------
 1 file changed, 289 insertions(+), 279 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 63e965966ced..32fbd30a6a2e 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -647,7 +647,7 @@ static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
 			max_offset = MAC_ADDR_MAX_MGMT_TU_DP_WCOUNT;
 			break;
 		default:
-			pr_err("Bad type!!! 0x%08x\n", type);
+			netdev_err(qdev->ndev, "Bad type!!! 0x%08x\n", type);
 			max_index = 0;
 			max_offset = 0;
 			break;
@@ -1335,9 +1335,8 @@ static void ql_dump_intr_states(struct ql_adapter *qdev)
 	for (i = 0; i < qdev->intr_count; i++) {
 		ql_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
 		value = ql_read32(qdev, INTR_EN);
-		pr_err("%s: Interrupt %d is %s\n",
-		       qdev->ndev->name, i,
-		       (value & INTR_EN_EN ? "enabled" : "disabled"));
+		netdev_err(qdev->ndev, "Interrupt %d is %s\n", i,
+			   (value & INTR_EN_EN ? "enabled" : "disabled"));
 	}
 }

@@ -1345,13 +1344,14 @@ static void ql_dump_intr_states(struct ql_adapter *qdev)
 do {								\
 	u32 data;						\
 	ql_read_xgmac_reg(qdev, reg, &data);			\
-	pr_err("%s: %s = 0x%.08x\n", qdev->ndev->name, #reg, data); \
+	netdev_err(qdev->ndev, "%s = 0x%.08x\n", #reg, data); \
 } while (0)

 void ql_dump_xgmac_control_regs(struct ql_adapter *qdev)
 {
 	if (ql_sem_spinlock(qdev, qdev->xg_sem_mask)) {
-		pr_err("%s: Couldn't get xgmac sem\n", __func__);
+		netdev_err(qdev->ndev, "%s: Couldn't get xgmac sem\n",
+			   __func__);
 		return;
 	}
 	DUMP_XGMAC(qdev, PAUSE_SRC_LO);
@@ -1388,25 +1388,28 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 		return;
 	for (i = 0; i < 4; i++) {
 		if (ql_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_CAM_MAC, i, value)) {
-			pr_err("%s: Failed read of mac index register\n",
-			       __func__);
+			netdev_err(qdev->ndev,
+				   "%s: Failed read of mac index register\n",
+				   __func__);
 			break;
 		}
 		if (value[0])
-			pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
-			       qdev->ndev->name, i, value[1], value[0],
-			       value[2]);
+			netdev_err(qdev->ndev,
+				   "CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
+				   i, value[1], value[0], value[2]);
 	}
 	for (i = 0; i < 32; i++) {
 		if (ql_get_mac_addr_reg
 		    (qdev, MAC_ADDR_TYPE_MULTI_MAC, i, value)) {
-			pr_err("%s: Failed read of mac index register\n",
-			       __func__);
+			netdev_err(qdev->ndev,
+				   "%s: Failed read of mac index register\n",
+				   __func__);
 			break;
 		}
 		if (value[0])
-			pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
-			       qdev->ndev->name, i, value[1], value[0]);
+			netdev_err(qdev->ndev,
+				   "MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
+				   i, value[1], value[0]);
 	}
 	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 }
@@ -1422,23 +1425,25 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 	for (i = 0; i < 16; i++) {
 		value = 0;
 		if (ql_get_routing_reg(qdev, i, &value)) {
-			pr_err("%s: Failed read of routing index register\n",
-			       __func__);
+			netdev_err(qdev->ndev,
+				   "%s: Failed read of routing index register\n",
+				   __func__);
 			break;
 		}
 		if (value)
-			pr_err("%s: Routing Mask %d = 0x%.08x\n",
-			       qdev->ndev->name, i, value);
+			netdev_err(qdev->ndev,
+				   "%s: Routing Mask %d = 0x%.08x\n",
+				   i, value);
 	}
 	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
 }

 #define DUMP_REG(qdev, reg)			\
-	pr_err("%-32s= 0x%x\n", #reg, ql_read32(qdev, reg))
+	netdev_err(qdev->ndev, "%-32s= 0x%x\n", #reg, ql_read32(qdev, reg))

 void ql_dump_regs(struct ql_adapter *qdev)
 {
-	pr_err("reg dump for function #%d\n", qdev->func);
+	netdev_err(qdev->ndev, "reg dump for function #%d\n", qdev->func);
 	DUMP_REG(qdev, SYS);
 	DUMP_REG(qdev, RST_FO);
 	DUMP_REG(qdev, FSC);
@@ -1503,11 +1508,12 @@ void ql_dump_regs(struct ql_adapter *qdev)
 #ifdef QL_STAT_DUMP

 #define DUMP_STAT(qdev, stat)	\
-	pr_err("%s = %ld\n", #stat, (unsigned long)(qdev)->nic_stats.stat)
+	netdev_err(qdev->ndev, "%s = %ld\n", #stat,  \
+		   (unsigned long)(qdev)->nic_stats.stat)

 void ql_dump_stat(struct ql_adapter *qdev)
 {
-	pr_err("%s: Enter\n", __func__);
+	netdev_err(qdev->ndev, "%s: Enter\n", __func__);
 	DUMP_STAT(qdev, tx_pkts);
 	DUMP_STAT(qdev, tx_bytes);
 	DUMP_STAT(qdev, tx_mcast_pkts);
@@ -1556,11 +1562,12 @@ void ql_dump_stat(struct ql_adapter *qdev)
 #ifdef QL_DEV_DUMP

 #define DUMP_QDEV_FIELD(qdev, type, field)		\
-	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->field)
+	netdev_err(qdev->ndev, "qdev->%-24s = " type "\n", #field, (qdev)->field)
 #define DUMP_QDEV_DMA_FIELD(qdev, field)		\
-	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
+	netdev_err(qdev->ndev, "qdev->%-24s = %llx\n", #field, \
+		   (unsigned long long)qdev->field)
 #define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
-	pr_err("%s[%d].%s = " type "\n",		 \
+	netdev_err(qdev->ndev, "%s[%d].%s = " type "\n",		 \
 	       #array, index, #field, (qdev)->array[index].field)
 void ql_dump_qdev(struct ql_adapter *qdev)
 {
@@ -1611,99 +1618,100 @@ void ql_dump_qdev(struct ql_adapter *qdev)
 #ifdef QL_CB_DUMP
 void ql_dump_wqicb(struct wqicb *wqicb)
 {
-	pr_err("Dumping wqicb stuff...\n");
-	pr_err("wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
-	pr_err("wqicb->flags = %x\n", le16_to_cpu(wqicb->flags));
-	pr_err("wqicb->cq_id_rss = %d\n",
-	       le16_to_cpu(wqicb->cq_id_rss));
-	pr_err("wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
-	pr_err("wqicb->wq_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(wqicb->addr));
-	pr_err("wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
+	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
+	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
+	netdev_err(qdev->ndev, "wqicb->flags = %x\n",
+		   le16_to_cpu(wqicb->flags));
+	netdev_err(qdev->ndev, "wqicb->cq_id_rss = %d\n",
+		   le16_to_cpu(wqicb->cq_id_rss));
+	netdev_err(qdev->ndev, "wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
+	netdev_err(qdev->ndev, "wqicb->wq_addr = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(wqicb->addr));
+	netdev_err(qdev->ndev, "wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
 }

 void ql_dump_tx_ring(struct tx_ring *tx_ring)
 {
 	if (!tx_ring)
 		return;
-	pr_err("===================== Dumping tx_ring %d ===============\n",
-	       tx_ring->wq_id);
-	pr_err("tx_ring->base = %p\n", tx_ring->wq_base);
-	pr_err("tx_ring->base_dma = 0x%llx\n",
-	       (unsigned long long)tx_ring->wq_base_dma);
-	pr_err("tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
-	       tx_ring->cnsmr_idx_sh_reg,
-	       tx_ring->cnsmr_idx_sh_reg
+	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
+		   tx_ring->wq_id);
+	netdev_err(qdev->ndev, "tx_ring->base = %p\n", tx_ring->wq_base);
+	netdev_err(qdev->ndev, "tx_ring->base_dma = 0x%llx\n",
+		   (unsigned long long)tx_ring->wq_base_dma);
+	netdev_err(qdev->ndev, "tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
+		   tx_ring->cnsmr_idx_sh_reg,
+		   tx_ring->cnsmr_idx_sh_reg
 			? ql_read_sh_reg(tx_ring->cnsmr_idx_sh_reg) : 0);
-	pr_err("tx_ring->size = %d\n", tx_ring->wq_size);
-	pr_err("tx_ring->len = %d\n", tx_ring->wq_len);
-	pr_err("tx_ring->prod_idx_db_reg = %p\n", tx_ring->prod_idx_db_reg);
-	pr_err("tx_ring->valid_db_reg = %p\n", tx_ring->valid_db_reg);
-	pr_err("tx_ring->prod_idx = %d\n", tx_ring->prod_idx);
-	pr_err("tx_ring->cq_id = %d\n", tx_ring->cq_id);
-	pr_err("tx_ring->wq_id = %d\n", tx_ring->wq_id);
-	pr_err("tx_ring->q = %p\n", tx_ring->q);
-	pr_err("tx_ring->tx_count = %d\n", atomic_read(&tx_ring->tx_count));
+	netdev_err(qdev->ndev, "tx_ring->size = %d\n", tx_ring->wq_size);
+	netdev_err(qdev->ndev, "tx_ring->len = %d\n", tx_ring->wq_len);
+	netdev_err(qdev->ndev, "tx_ring->prod_idx_db_reg = %p\n", tx_ring->prod_idx_db_reg);
+	netdev_err(qdev->ndev, "tx_ring->valid_db_reg = %p\n", tx_ring->valid_db_reg);
+	netdev_err(qdev->ndev, "tx_ring->prod_idx = %d\n", tx_ring->prod_idx);
+	netdev_err(qdev->ndev, "tx_ring->cq_id = %d\n", tx_ring->cq_id);
+	netdev_err(qdev->ndev, "tx_ring->wq_id = %d\n", tx_ring->wq_id);
+	netdev_err(qdev->ndev, "tx_ring->q = %p\n", tx_ring->q);
+	netdev_err(qdev->ndev, "tx_ring->tx_count = %d\n", atomic_read(&tx_ring->tx_count));
 }

 void ql_dump_ricb(struct ricb *ricb)
 {
 	int i;

-	pr_err("===================== Dumping ricb ===============\n");
-	pr_err("Dumping ricb stuff...\n");
-
-	pr_err("ricb->base_cq = %d\n", ricb->base_cq & 0x1f);
-	pr_err("ricb->flags = %s%s%s%s%s%s%s%s%s\n",
-	       ricb->base_cq & RSS_L4K ? "RSS_L4K " : "",
-	       ricb->flags & RSS_L6K ? "RSS_L6K " : "",
-	       ricb->flags & RSS_LI ? "RSS_LI " : "",
-	       ricb->flags & RSS_LB ? "RSS_LB " : "",
-	       ricb->flags & RSS_LM ? "RSS_LM " : "",
-	       ricb->flags & RSS_RI4 ? "RSS_RI4 " : "",
-	       ricb->flags & RSS_RT4 ? "RSS_RT4 " : "",
-	       ricb->flags & RSS_RI6 ? "RSS_RI6 " : "",
-	       ricb->flags & RSS_RT6 ? "RSS_RT6 " : "");
-	pr_err("ricb->mask = 0x%.04x\n", le16_to_cpu(ricb->mask));
+	netdev_err(qdev->ndev, "===================== Dumping ricb ===============\n");
+	netdev_err(qdev->ndev, "Dumping ricb stuff...\n");
+
+	netdev_err(qdev->ndev, "ricb->base_cq = %d\n", ricb->base_cq & 0x1f);
+	netdev_err(qdev->ndev, "ricb->flags = %s%s%s%s%s%s%s%s%s\n",
+		   ricb->base_cq & RSS_L4K ? "RSS_L4K " : "",
+		   ricb->flags & RSS_L6K ? "RSS_L6K " : "",
+		   ricb->flags & RSS_LI ? "RSS_LI " : "",
+		   ricb->flags & RSS_LB ? "RSS_LB " : "",
+		   ricb->flags & RSS_LM ? "RSS_LM " : "",
+		   ricb->flags & RSS_RI4 ? "RSS_RI4 " : "",
+		   ricb->flags & RSS_RT4 ? "RSS_RT4 " : "",
+		   ricb->flags & RSS_RI6 ? "RSS_RI6 " : "",
+		   ricb->flags & RSS_RT6 ? "RSS_RT6 " : "");
+	netdev_err(qdev->ndev, "ricb->mask = 0x%.04x\n", le16_to_cpu(ricb->mask));
 	for (i = 0; i < 16; i++)
-		pr_err("ricb->hash_cq_id[%d] = 0x%.08x\n", i,
-		       le32_to_cpu(ricb->hash_cq_id[i]));
+		netdev_err(qdev->ndev, "ricb->hash_cq_id[%d] = 0x%.08x\n", i,
+			   le32_to_cpu(ricb->hash_cq_id[i]));
 	for (i = 0; i < 10; i++)
-		pr_err("ricb->ipv6_hash_key[%d] = 0x%.08x\n", i,
-		       le32_to_cpu(ricb->ipv6_hash_key[i]));
+		netdev_err(qdev->ndev, "ricb->ipv6_hash_key[%d] = 0x%.08x\n", i,
+			   le32_to_cpu(ricb->ipv6_hash_key[i]));
 	for (i = 0; i < 4; i++)
-		pr_err("ricb->ipv4_hash_key[%d] = 0x%.08x\n", i,
-		       le32_to_cpu(ricb->ipv4_hash_key[i]));
+		netdev_err(qdev->ndev, "ricb->ipv4_hash_key[%d] = 0x%.08x\n", i,
+			   le32_to_cpu(ricb->ipv4_hash_key[i]));
 }

 void ql_dump_cqicb(struct cqicb *cqicb)
 {
-	pr_err("Dumping cqicb stuff...\n");
-
-	pr_err("cqicb->msix_vect = %d\n", cqicb->msix_vect);
-	pr_err("cqicb->flags = %x\n", cqicb->flags);
-	pr_err("cqicb->len = %d\n", le16_to_cpu(cqicb->len));
-	pr_err("cqicb->addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->addr));
-	pr_err("cqicb->prod_idx_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->prod_idx_addr));
-	pr_err("cqicb->pkt_delay = 0x%.04x\n",
-	       le16_to_cpu(cqicb->pkt_delay));
-	pr_err("cqicb->irq_delay = 0x%.04x\n",
-	       le16_to_cpu(cqicb->irq_delay));
-	pr_err("cqicb->lbq_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->lbq_addr));
-	pr_err("cqicb->lbq_buf_size = 0x%.04x\n",
-	       le16_to_cpu(cqicb->lbq_buf_size));
-	pr_err("cqicb->lbq_len = 0x%.04x\n",
-	       le16_to_cpu(cqicb->lbq_len));
-	pr_err("cqicb->sbq_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->sbq_addr));
-	pr_err("cqicb->sbq_buf_size = 0x%.04x\n",
-	       le16_to_cpu(cqicb->sbq_buf_size));
-	pr_err("cqicb->sbq_len = 0x%.04x\n",
-	       le16_to_cpu(cqicb->sbq_len));
+	netdev_err(qdev->ndev, "Dumping cqicb stuff...\n");
+
+	netdev_err(qdev->ndev, "cqicb->msix_vect = %d\n", cqicb->msix_vect);
+	netdev_err(qdev->ndev, "cqicb->flags = %x\n", cqicb->flags);
+	netdev_err(qdev->ndev, "cqicb->len = %d\n", le16_to_cpu(cqicb->len));
+	netdev_err(qdev->ndev, "cqicb->addr = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(cqicb->addr));
+	netdev_err(qdev->ndev, "cqicb->prod_idx_addr = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(cqicb->prod_idx_addr));
+	netdev_err(qdev->ndev, "cqicb->pkt_delay = 0x%.04x\n",
+		   le16_to_cpu(cqicb->pkt_delay));
+	netdev_err(qdev->ndev, "cqicb->irq_delay = 0x%.04x\n",
+		   le16_to_cpu(cqicb->irq_delay));
+	netdev_err(qdev->ndev, "cqicb->lbq_addr = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(cqicb->lbq_addr));
+	netdev_err(qdev->ndev, "cqicb->lbq_buf_size = 0x%.04x\n",
+		   le16_to_cpu(cqicb->lbq_buf_size));
+	netdev_err(qdev->ndev, "cqicb->lbq_len = 0x%.04x\n",
+		   le16_to_cpu(cqicb->lbq_len));
+	netdev_err(qdev->ndev, "cqicb->sbq_addr = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(cqicb->sbq_addr));
+	netdev_err(qdev->ndev, "cqicb->sbq_buf_size = 0x%.04x\n",
+		   le16_to_cpu(cqicb->sbq_buf_size));
+	netdev_err(qdev->ndev, "cqicb->sbq_len = 0x%.04x\n",
+		   le16_to_cpu(cqicb->sbq_len));
 }

 static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)
@@ -1720,71 +1728,73 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 {
 	if (!rx_ring)
 		return;
-	pr_err("===================== Dumping rx_ring %d ===============\n",
-	       rx_ring->cq_id);
-	pr_err("Dumping rx_ring %d, type = %s\n", rx_ring->cq_id,
-	       qlge_rx_ring_type_name(rx_ring));
-	pr_err("rx_ring->cqicb = %p\n", &rx_ring->cqicb);
-	pr_err("rx_ring->cq_base = %p\n", rx_ring->cq_base);
-	pr_err("rx_ring->cq_base_dma = %llx\n",
-	       (unsigned long long)rx_ring->cq_base_dma);
-	pr_err("rx_ring->cq_size = %d\n", rx_ring->cq_size);
-	pr_err("rx_ring->cq_len = %d\n", rx_ring->cq_len);
-	pr_err("rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
-	       rx_ring->prod_idx_sh_reg,
-	       rx_ring->prod_idx_sh_reg
-			? ql_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
-	pr_err("rx_ring->prod_idx_sh_reg_dma = %llx\n",
-	       (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
-	pr_err("rx_ring->cnsmr_idx_db_reg = %p\n",
-	       rx_ring->cnsmr_idx_db_reg);
-	pr_err("rx_ring->cnsmr_idx = %d\n", rx_ring->cnsmr_idx);
-	pr_err("rx_ring->curr_entry = %p\n", rx_ring->curr_entry);
-	pr_err("rx_ring->valid_db_reg = %p\n", rx_ring->valid_db_reg);
-
-	pr_err("rx_ring->lbq.base = %p\n", rx_ring->lbq.base);
-	pr_err("rx_ring->lbq.base_dma = %llx\n",
-	       (unsigned long long)rx_ring->lbq.base_dma);
-	pr_err("rx_ring->lbq.base_indirect = %p\n",
-	       rx_ring->lbq.base_indirect);
-	pr_err("rx_ring->lbq.base_indirect_dma = %llx\n",
-	       (unsigned long long)rx_ring->lbq.base_indirect_dma);
-	pr_err("rx_ring->lbq = %p\n", rx_ring->lbq.queue);
-	pr_err("rx_ring->lbq.prod_idx_db_reg = %p\n",
-	       rx_ring->lbq.prod_idx_db_reg);
-	pr_err("rx_ring->lbq.next_to_use = %d\n", rx_ring->lbq.next_to_use);
-	pr_err("rx_ring->lbq.next_to_clean = %d\n", rx_ring->lbq.next_to_clean);
-
-	pr_err("rx_ring->sbq.base = %p\n", rx_ring->sbq.base);
-	pr_err("rx_ring->sbq.base_dma = %llx\n",
-	       (unsigned long long)rx_ring->sbq.base_dma);
-	pr_err("rx_ring->sbq.base_indirect = %p\n",
-	       rx_ring->sbq.base_indirect);
-	pr_err("rx_ring->sbq.base_indirect_dma = %llx\n",
-	       (unsigned long long)rx_ring->sbq.base_indirect_dma);
-	pr_err("rx_ring->sbq = %p\n", rx_ring->sbq.queue);
-	pr_err("rx_ring->sbq.prod_idx_db_reg addr = %p\n",
-	       rx_ring->sbq.prod_idx_db_reg);
-	pr_err("rx_ring->sbq.next_to_use = %d\n", rx_ring->sbq.next_to_use);
-	pr_err("rx_ring->sbq.next_to_clean = %d\n", rx_ring->sbq.next_to_clean);
-	pr_err("rx_ring->cq_id = %d\n", rx_ring->cq_id);
-	pr_err("rx_ring->irq = %d\n", rx_ring->irq);
-	pr_err("rx_ring->cpu = %d\n", rx_ring->cpu);
-	pr_err("rx_ring->qdev = %p\n", rx_ring->qdev);
+	netdev_err(qdev->ndev,
+		   "===================== Dumping rx_ring %d ===============\n",
+		   rx_ring->cq_id);
+	netdev_err(qdev->ndev,
+		   "Dumping rx_ring %d, type = %s\n", rx_ring->cq_id,
+		   qlge_rx_ring_type_name(rx_ring));
+	netdev_err(qdev->ndev, "rx_ring->cqicb = %p\n", &rx_ring->cqicb);
+	netdev_err(qdev->ndev, "rx_ring->cq_base = %p\n", rx_ring->cq_base);
+	netdev_err(qdev->ndev, "rx_ring->cq_base_dma = %llx\n",
+		   (unsigned long long)rx_ring->cq_base_dma);
+	netdev_err(qdev->ndev, "rx_ring->cq_size = %d\n", rx_ring->cq_size);
+	netdev_err(qdev->ndev, "rx_ring->cq_len = %d\n", rx_ring->cq_len);
+	netdev_err(qdev->ndev,
+		   "rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
+		   rx_ring->prod_idx_sh_reg,
+		   rx_ring->prod_idx_sh_reg ? ql_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
+	netdev_err(qdev->ndev, "rx_ring->prod_idx_sh_reg_dma = %llx\n",
+		   (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
+	netdev_err(qdev->ndev, "rx_ring->cnsmr_idx_db_reg = %p\n",
+		   rx_ring->cnsmr_idx_db_reg);
+	netdev_err(qdev->ndev, "rx_ring->cnsmr_idx = %d\n", rx_ring->cnsmr_idx);
+	netdev_err(qdev->ndev, "rx_ring->curr_entry = %p\n", rx_ring->curr_entry);
+	netdev_err(qdev->ndev, "rx_ring->valid_db_reg = %p\n", rx_ring->valid_db_reg);
+
+	netdev_err(qdev->ndev, "rx_ring->lbq.base = %p\n", rx_ring->lbq.base);
+	netdev_err(qdev->ndev, "rx_ring->lbq.base_dma = %llx\n",
+		   (unsigned long long)rx_ring->lbq.base_dma);
+	netdev_err(qdev->ndev, "rx_ring->lbq.base_indirect = %p\n",
+		   rx_ring->lbq.base_indirect);
+	netdev_err(qdev->ndev, "rx_ring->lbq.base_indirect_dma = %llx\n",
+		   (unsigned long long)rx_ring->lbq.base_indirect_dma);
+	netdev_err(qdev->ndev, "rx_ring->lbq = %p\n", rx_ring->lbq.queue);
+	netdev_err(qdev->ndev, "rx_ring->lbq.prod_idx_db_reg = %p\n",
+		   rx_ring->lbq.prod_idx_db_reg);
+	netdev_err(qdev->ndev, "rx_ring->lbq.next_to_use = %d\n", rx_ring->lbq.next_to_use);
+	netdev_err(qdev->ndev, "rx_ring->lbq.next_to_clean = %d\n", rx_ring->lbq.next_to_clean);
+
+	netdev_err(qdev->ndev, "rx_ring->sbq.base = %p\n", rx_ring->sbq.base);
+	netdev_err(qdev->ndev, "rx_ring->sbq.base_dma = %llx\n",
+		   (unsigned long long)rx_ring->sbq.base_dma);
+	netdev_err(qdev->ndev, "rx_ring->sbq.base_indirect = %p\n",
+		   rx_ring->sbq.base_indirect);
+	netdev_err(qdev->ndev, "rx_ring->sbq.base_indirect_dma = %llx\n",
+		   (unsigned long long)rx_ring->sbq.base_indirect_dma);
+	netdev_err(qdev->ndev, "rx_ring->sbq = %p\n", rx_ring->sbq.queue);
+	netdev_err(qdev->ndev, "rx_ring->sbq.prod_idx_db_reg addr = %p\n",
+		   rx_ring->sbq.prod_idx_db_reg);
+	netdev_err(qdev->ndev, "rx_ring->sbq.next_to_use = %d\n", rx_ring->sbq.next_to_use);
+	netdev_err(qdev->ndev, "rx_ring->sbq.next_to_clean = %d\n", rx_ring->sbq.next_to_clean);
+	netdev_err(qdev->ndev, "rx_ring->cq_id = %d\n", rx_ring->cq_id);
+	netdev_err(qdev->ndev, "rx_ring->irq = %d\n", rx_ring->irq);
+	netdev_err(qdev->ndev, "rx_ring->cpu = %d\n", rx_ring->cpu);
+	netdev_err(qdev->ndev, "rx_ring->qdev = %p\n", rx_ring->qdev);
 }

 void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 {
 	void *ptr;

-	pr_err("%s: Enter\n", __func__);
+	netdev_err(qdev->ndev, "%s: Enter\n", __func__);

 	ptr = kmalloc(size, GFP_ATOMIC);
 	if (!ptr)
 		return;

 	if (ql_write_cfg(qdev, ptr, size, bit, q_id)) {
-		pr_err("%s: Failed to upload control block!\n", __func__);
+		netdev_err(qdev->ndev, "%s: Failed to upload control block!\n", __func__);
 		goto fail_it;
 	}
 	switch (bit) {
@@ -1798,7 +1808,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 		ql_dump_ricb((struct ricb *)ptr);
 		break;
 	default:
-		pr_err("%s: Invalid bit value = %x\n", __func__, bit);
+		netdev_err(qdev->ndev, "%s: Invalid bit value = %x\n", __func__, bit);
 		break;
 	}
 fail_it:
@@ -1809,29 +1819,29 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 #ifdef QL_OB_DUMP
 void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 {
-	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
-	pr_err("tbd->len   = %d\n",
-	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	pr_err("tbd->flags = %s %s\n",
-	       tbd->len & TX_DESC_C ? "C" : ".",
-	       tbd->len & TX_DESC_E ? "E" : ".");
+	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
+		   le64_to_cpu((u64)tbd->addr));
+	netdev_err(qdev->ndev, "tbd->len   = %d\n",
+		   le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
+	netdev_err(qdev->ndev, "tbd->flags = %s %s\n",
+		   tbd->len & TX_DESC_C ? "C" : ".",
+		   tbd->len & TX_DESC_E ? "E" : ".");
 	tbd++;
-	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
-	pr_err("tbd->len   = %d\n",
-	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	pr_err("tbd->flags = %s %s\n",
-	       tbd->len & TX_DESC_C ? "C" : ".",
-	       tbd->len & TX_DESC_E ? "E" : ".");
+	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
+		   le64_to_cpu((u64)tbd->addr));
+	netdev_err(qdev->ndev, "tbd->len   = %d\n",
+		   le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
+	netdev_err(qdev->ndev, "tbd->flags = %s %s\n",
+		   tbd->len & TX_DESC_C ? "C" : ".",
+		   tbd->len & TX_DESC_E ? "E" : ".");
 	tbd++;
-	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
-	pr_err("tbd->len   = %d\n",
-	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	pr_err("tbd->flags = %s %s\n",
-	       tbd->len & TX_DESC_C ? "C" : ".",
-	       tbd->len & TX_DESC_E ? "E" : ".");
+	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
+		   le64_to_cpu((u64)tbd->addr));
+	netdev_err(qdev->ndev, "tbd->len   = %d\n",
+		   le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
+	netdev_err(qdev->ndev, "tbd->flags = %s %s\n",
+		   tbd->len & TX_DESC_C ? "C" : ".",
+		   tbd->len & TX_DESC_E ? "E" : ".");
 }

 void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
@@ -1841,39 +1851,39 @@ void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
 	struct tx_buf_desc *tbd;
 	u16 frame_len;

-	pr_err("%s\n", __func__);
-	pr_err("opcode         = %s\n",
-	       (ob_mac_iocb->opcode == OPCODE_OB_MAC_IOCB) ? "MAC" : "TSO");
-	pr_err("flags1          = %s %s %s %s %s\n",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_OI ? "OI" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_I ? "I" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_D ? "D" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP4 ? "IP4" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP6 ? "IP6" : "");
-	pr_err("flags2          = %s %s %s\n",
-	       ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_LSO ? "LSO" : "",
-	       ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_UC ? "UC" : "",
-	       ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_TC ? "TC" : "");
-	pr_err("flags3          = %s %s %s\n",
-	       ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_IC ? "IC" : "",
-	       ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_DFP ? "DFP" : "",
-	       ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_V ? "V" : "");
-	pr_err("tid = %x\n", ob_mac_iocb->tid);
-	pr_err("txq_idx = %d\n", ob_mac_iocb->txq_idx);
-	pr_err("vlan_tci      = %x\n", ob_mac_tso_iocb->vlan_tci);
+	netdev_err(qdev->ndev, "%s\n", __func__);
+	netdev_err(qdev->ndev, "opcode         = %s\n",
+		   (ob_mac_iocb->opcode == OPCODE_OB_MAC_IOCB) ? "MAC" : "TSO");
+	netdev_err(qdev->ndev, "flags1          = %s %s %s %s %s\n",
+		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_OI ? "OI" : "",
+		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_I ? "I" : "",
+		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_D ? "D" : "",
+		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP4 ? "IP4" : "",
+		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP6 ? "IP6" : "");
+	netdev_err(qdev->ndev, "flags2          = %s %s %s\n",
+		   ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_LSO ? "LSO" : "",
+		   ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_UC ? "UC" : "",
+		   ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_TC ? "TC" : "");
+	netdev_err(qdev->ndev, "flags3          = %s %s %s\n",
+		   ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_IC ? "IC" : "",
+		   ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_DFP ? "DFP" : "",
+		   ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_V ? "V" : "");
+	netdev_err(qdev->ndev, "tid = %x\n", ob_mac_iocb->tid);
+	netdev_err(qdev->ndev, "txq_idx = %d\n", ob_mac_iocb->txq_idx);
+	netdev_err(qdev->ndev, "vlan_tci      = %x\n", ob_mac_tso_iocb->vlan_tci);
 	if (ob_mac_iocb->opcode == OPCODE_OB_MAC_TSO_IOCB) {
-		pr_err("frame_len      = %d\n",
-		       le32_to_cpu(ob_mac_tso_iocb->frame_len));
-		pr_err("mss      = %d\n",
-		       le16_to_cpu(ob_mac_tso_iocb->mss));
-		pr_err("prot_hdr_len   = %d\n",
-		       le16_to_cpu(ob_mac_tso_iocb->total_hdrs_len));
-		pr_err("hdr_offset     = 0x%.04x\n",
-		       le16_to_cpu(ob_mac_tso_iocb->net_trans_offset));
+		netdev_err(qdev->ndev, "frame_len      = %d\n",
+			   le32_to_cpu(ob_mac_tso_iocb->frame_len));
+		netdev_err(qdev->ndev, "mss      = %d\n",
+			   le16_to_cpu(ob_mac_tso_iocb->mss));
+		netdev_err(qdev->ndev, "prot_hdr_len   = %d\n",
+			   le16_to_cpu(ob_mac_tso_iocb->total_hdrs_len));
+		netdev_err(qdev->ndev, "hdr_offset     = 0x%.04x\n",
+			   le16_to_cpu(ob_mac_tso_iocb->net_trans_offset));
 		frame_len = le32_to_cpu(ob_mac_tso_iocb->frame_len);
 	} else {
-		pr_err("frame_len      = %d\n",
-		       le16_to_cpu(ob_mac_iocb->frame_len));
+		netdev_err(qdev->ndev, "frame_len      = %d\n",
+			   le16_to_cpu(ob_mac_iocb->frame_len));
 		frame_len = le16_to_cpu(ob_mac_iocb->frame_len);
 	}
 	tbd = &ob_mac_iocb->tbd[0];
@@ -1882,98 +1892,98 @@ void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)

 void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp)
 {
-	pr_err("%s\n", __func__);
-	pr_err("opcode         = %d\n", ob_mac_rsp->opcode);
-	pr_err("flags          = %s %s %s %s %s %s %s\n",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_OI ? "OI" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_I ? "I" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_E ? "E" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_S ? "S" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_L ? "L" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_P ? "P" : ".",
-	       ob_mac_rsp->flags2 & OB_MAC_IOCB_RSP_B ? "B" : ".");
-	pr_err("tid = %x\n", ob_mac_rsp->tid);
+	netdev_err(qdev->ndev, "%s\n", __func__);
+	netdev_err(qdev->ndev, "opcode         = %d\n", ob_mac_rsp->opcode);
+	netdev_err(qdev->ndev, "flags          = %s %s %s %s %s %s %s\n",
+		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_OI ?
+			"OI" : ".", ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_I ? "I" : ".",
+		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_E ? "E" : ".",
+		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_S ? "S" : ".",
+		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_L ? "L" : ".",
+		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_P ? "P" : ".",
+		   ob_mac_rsp->flags2 & OB_MAC_IOCB_RSP_B ? "B" : ".");
+	netdev_err(qdev->ndev, "tid = %x\n", ob_mac_rsp->tid);
 }
 #endif

 #ifdef QL_IB_DUMP
 void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
 {
-	pr_err("%s\n", __func__);
-	pr_err("opcode         = 0x%x\n", ib_mac_rsp->opcode);
-	pr_err("flags1 = %s%s%s%s%s%s\n",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_OI ? "OI " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_I ? "I " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_TE ? "TE " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_NU ? "NU " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_IE ? "IE " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_B ? "B " : "");
+	netdev_err(qdev->ndev, "%s\n", __func__);
+	netdev_err(qdev->ndev, "opcode         = 0x%x\n", ib_mac_rsp->opcode);
+	netdev_err(qdev->ndev, "flags1 = %s%s%s%s%s%s\n",
+		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_OI ? "OI " : "",
+		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_I ? "I " : "",
+		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_TE ? "TE " : "",
+		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_NU ? "NU " : "",
+		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_IE ? "IE " : "",
+		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_B ? "B " : "");

 	if (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK)
-		pr_err("%s%s%s Multicast\n",
-		       (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-		       IB_MAC_IOCB_RSP_M_HASH ? "Hash" : "",
-		       (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-		       IB_MAC_IOCB_RSP_M_REG ? "Registered" : "",
-		       (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-		       IB_MAC_IOCB_RSP_M_PROM ? "Promiscuous" : "");
-
-	pr_err("flags2 = %s%s%s%s%s\n",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_P) ? "P " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) ? "V " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) ? "U " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) ? "T " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_FO) ? "FO " : "");
+		netdev_err(qdev->ndev, "%s%s%s Multicast\n",
+			   (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
+			   IB_MAC_IOCB_RSP_M_HASH ? "Hash" : "",
+			   (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
+			   IB_MAC_IOCB_RSP_M_REG ? "Registered" : "",
+			   (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
+			   IB_MAC_IOCB_RSP_M_PROM ? "Promiscuous" : "");
+
+	netdev_err(qdev->ndev, "flags2 = %s%s%s%s%s\n",
+		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_P) ? "P " : "",
+		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) ? "V " : "",
+		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) ? "U " : "",
+		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) ? "T " : "",
+		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_FO) ? "FO " : "");

 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK)
-		pr_err("%s%s%s%s%s error\n",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_OVERSIZE ? "oversize" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_UNDERSIZE ? "undersize" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_PREAMBLE ? "preamble" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_FRAME_LEN ? "frame length" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_CRC ? "CRC" : "");
-
-	pr_err("flags3 = %s%s\n",
-	       ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS ? "DS " : "",
-	       ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL ? "DL " : "");
+		netdev_err(qdev->ndev, "%s%s%s%s%s error\n",
+			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
+			   IB_MAC_IOCB_RSP_ERR_OVERSIZE ? "oversize" : "",
+			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
+			   IB_MAC_IOCB_RSP_ERR_UNDERSIZE ? "undersize" : "",
+			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
+			   IB_MAC_IOCB_RSP_ERR_PREAMBLE ? "preamble" : "",
+			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
+			   IB_MAC_IOCB_RSP_ERR_FRAME_LEN ? "frame length" : "",
+			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
+			   IB_MAC_IOCB_RSP_ERR_CRC ? "CRC" : "");
+
+	netdev_err(qdev->ndev, "flags3 = %s%s\n",
+		   ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS ? "DS " : "",
+		   ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL ? "DL " : "");

 	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
-		pr_err("RSS flags = %s%s%s%s\n",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_IPV4) ? "IPv4 RSS" : "",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_IPV6) ? "IPv6 RSS " : "",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_TCP_V4) ? "TCP/IPv4 RSS" : "",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_TCP_V6) ? "TCP/IPv6 RSS" : "");
-
-	pr_err("data_len	= %d\n",
-	       le32_to_cpu(ib_mac_rsp->data_len));
-	pr_err("data_addr    = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(ib_mac_rsp->data_addr));
+		netdev_err(qdev->ndev, "RSS flags = %s%s%s%s\n",
+			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
+			    IB_MAC_IOCB_RSP_M_IPV4) ? "IPv4 RSS" : "",
+			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
+			    IB_MAC_IOCB_RSP_M_IPV6) ? "IPv6 RSS " : "",
+			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
+			    IB_MAC_IOCB_RSP_M_TCP_V4) ? "TCP/IPv4 RSS" : "",
+			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
+			    IB_MAC_IOCB_RSP_M_TCP_V6) ? "TCP/IPv6 RSS" : "");
+
+	netdev_err(qdev->ndev, "data_len	= %d\n",
+		   le32_to_cpu(ib_mac_rsp->data_len));
+	netdev_err(qdev->ndev, "data_addr    = 0x%llx\n",
+		   (unsigned long long)le64_to_cpu(ib_mac_rsp->data_addr));
 	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
-		pr_err("rss    = %x\n",
-		       le32_to_cpu(ib_mac_rsp->rss));
+		netdev_err(qdev->ndev, "rss    = %x\n",
+			   le32_to_cpu(ib_mac_rsp->rss));
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V)
-		pr_err("vlan_id    = %x\n",
-		       le16_to_cpu(ib_mac_rsp->vlan_id));
+		netdev_err(qdev->ndev, "vlan_id    = %x\n",
+			   le16_to_cpu(ib_mac_rsp->vlan_id));

-	pr_err("flags4 = %s%s%s\n",
-	       ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV ? "HV " : "",
-		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS ? "HS " : "",
-		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HL ? "HL " : "");
+	netdev_err(qdev->ndev, "flags4 = %s%s%s\n",
+		   ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV ? "HV " : "",
+		   ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS ? "HS " : "",
+		   ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HL ? "HL " : "");

 	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
-		pr_err("hdr length	= %d\n",
-		       le32_to_cpu(ib_mac_rsp->hdr_len));
-		pr_err("hdr addr    = 0x%llx\n",
-		       (unsigned long long)le64_to_cpu(ib_mac_rsp->hdr_addr));
+		netdev_err(qdev->ndev, "hdr length	= %d\n",
+			   le32_to_cpu(ib_mac_rsp->hdr_len));
+		netdev_err(qdev->ndev, "hdr addr    = 0x%llx\n",
+			   (unsigned long long)le64_to_cpu(ib_mac_rsp->hdr_addr));
 	}
 }
 #endif
--
2.27.0

