Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542CC253AA5
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 01:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHZX1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 19:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgHZX1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 19:27:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE70C061574;
        Wed, 26 Aug 2020 16:27:40 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so1999301pgf.0;
        Wed, 26 Aug 2020 16:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gVT36AtST2vFgbBRTvOdcrq7/R6hAIp4iUlni64LMQ4=;
        b=CG1CfGukhCZm64p5Hdfxwi/e4xPtB6D/lCa1370WKfbW+WalCOk+4zqfYLWFK9y3GS
         DVkLNt0cjUBpJV9u7H4R4HUHwBqnGAGSz7KmmyrRpEis04auSDypL4CJyoCFTIr4NK3i
         6Z1Y5LnYUnU6s/YlMWL2+LMzflfZBLpGOyLHUDNO+RJ1YC5J+QGtCWKCBM7t3F7hluSX
         ZXkgHGj/nwMmMdKD4FD8q/SHGbP+lOCushbhYxxBfv0ZCS5NKz2zvievqQ8YPtx1Q0o/
         sehpFxnKyGwl7NtBqWJ7xMatwqqwmjpeWEzgtsegB8qEMMRatod7SHs36bf7AgHVdrul
         rmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gVT36AtST2vFgbBRTvOdcrq7/R6hAIp4iUlni64LMQ4=;
        b=nlBTChzTimd+QiHgbgKXpDpKvoA4U3dVhIe+sFxy3QOLC0G5ntJgWjkHHe8wtPksW7
         F5X7JZTXhlRg20Sdga8D3le5jDFZRy+M01Y+HF+v+qjON/cEHrVeTsbqpL1zsrTcbmNI
         M3Eg+niVmKnZflMuwTFhdY2autbZlWL2X7cpaJT+SG8am6FNPUnF2Z29NDdUVslk97QE
         r3vD5yDbrbP8fke4aGutWdyyJXvcO69TWydQrdD3aP6ykbuEsMHuJ/Jfr6Z07XuOh5kF
         v4YoaHyuNFo058/5plDQj3vgIuWszGqsFXhzN68LYd1vmZSys3WeWCJru9wNvoFGQQOv
         yiPg==
X-Gm-Message-State: AOAM531X3cKIF0ZsPLzzYA7ooI2kQkEQKr5TrH9RwDmYJ5ln2q7qehWk
        9knlynrUhIH910pssxdK1AU=
X-Google-Smtp-Source: ABdhPJzaK5PWJGlUZ/GXS6b7DE0bsx5ccKhtg9OvR5V3GLjL1SOSxJMpt3hMCBrN0P+p2Q3G0CSD3Q==
X-Received: by 2002:a63:d812:: with SMTP id b18mr11829864pgh.353.1598484459908;
        Wed, 26 Aug 2020 16:27:39 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id nu14sm175340pjb.19.2020.08.26.16.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 16:27:39 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] staging: qlge: fix build breakage with dumping enabled
Date:   Thu, 27 Aug 2020 07:27:34 +0800
Message-Id: <20200826232735.104077-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes commit 0107635e15ac
("staging: qlge: replace pr_err with netdev_err") which introduced an
build breakage of missing `struct ql_adapter *qdev` for some functions
and a warning of type mismatch with dumping enabled, i.e.,

$ make CFLAGS_MODULE="QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 \
  QL_IB_DUMP=1 QL_REG_DUMP=1 QL_DEV_DUMP=1" M=drivers/staging/qlge

qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
 2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
      |             ^~~~
qlge_dbg.c: In function ‘ql_dump_routing_entries’:
qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
 1435 |        "%s: Routing Mask %d = 0x%.08x\n",
      |         ~^
      |          |
      |          char *
      |         %d
 1436 |        i, value);
      |        ~
      |        |
      |        int
qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
 1435 |        "%s: Routing Mask %d = 0x%.08x\n",
      |                                 ~~~~^
      |                                     |
      |                                     unsigned int

Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h      | 20 ++++++++++----------
 drivers/staging/qlge/qlge_dbg.c  | 24 ++++++++++++++++++------
 drivers/staging/qlge/qlge_main.c |  8 ++++----
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 483ce04789ed..7f6798b223ef 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2338,21 +2338,21 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id);
 #endif

 #ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct tx_buf_desc *tbd);
-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb);
-void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp);
-#define QL_DUMP_OB_MAC_IOCB(ob_mac_iocb) ql_dump_ob_mac_iocb(ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(ob_mac_rsp) ql_dump_ob_mac_rsp(ob_mac_rsp)
+void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd);
+void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac_iocb);
+void ql_dump_ob_mac_rsp(struct ql_adapter *qdev, struct ob_mac_iocb_rsp *ob_mac_rsp);
+#define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb) ql_dump_ob_mac_iocb(qdev, ob_mac_iocb)
+#define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp) ql_dump_ob_mac_rsp(qdev, ob_mac_rsp)
 #else
-#define QL_DUMP_OB_MAC_IOCB(ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(ob_mac_rsp)
+#define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb)
+#define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp)
 #endif

 #ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp);
-#define QL_DUMP_IB_MAC_RSP(ib_mac_rsp) ql_dump_ib_mac_rsp(ib_mac_rsp)
+void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_rsp);
+#define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp) ql_dump_ib_mac_rsp(qdev, ib_mac_rsp)
 #else
-#define QL_DUMP_IB_MAC_RSP(ib_mac_rsp)
+#define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp)
 #endif

 #ifdef	QL_ALL_DUMP
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index a55bf0b3e9dc..e62ee4e2f118 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1431,7 +1431,7 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 		}
 		if (value)
 			netdev_err(qdev->ndev,
-				   "%s: Routing Mask %d = 0x%.08x\n",
+				   "Routing Mask %d = 0x%.08x\n",
 				   i, value);
 	}
 	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
@@ -1617,6 +1617,9 @@ void ql_dump_qdev(struct ql_adapter *qdev)
 #ifdef QL_CB_DUMP
 void ql_dump_wqicb(struct wqicb *wqicb)
 {
+	struct tx_ring *tx_ring = container_of(wqicb, struct tx_ring, wqicb);
+	struct ql_adapter *qdev = tx_ring->qdev;
+
 	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
 	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
 	netdev_err(qdev->ndev, "wqicb->flags = %x\n",
@@ -1632,6 +1635,8 @@ void ql_dump_wqicb(struct wqicb *wqicb)

 void ql_dump_tx_ring(struct tx_ring *tx_ring)
 {
+	struct ql_adapter *qdev = tx_ring->qdev;
+
 	if (!tx_ring)
 		return;
 	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
@@ -1657,6 +1662,8 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 void ql_dump_ricb(struct ricb *ricb)
 {
 	int i;
+	struct ql_adapter *qdev =
+		container_of(ricb, struct ql_adapter, ricb);

 	netdev_err(qdev->ndev, "===================== Dumping ricb ===============\n");
 	netdev_err(qdev->ndev, "Dumping ricb stuff...\n");
@@ -1686,6 +1693,9 @@ void ql_dump_ricb(struct ricb *ricb)

 void ql_dump_cqicb(struct cqicb *cqicb)
 {
+	struct rx_ring *rx_ring = container_of(cqicb, struct rx_ring, cqicb);
+	struct ql_adapter *qdev = rx_ring->qdev;
+
 	netdev_err(qdev->ndev, "Dumping cqicb stuff...\n");

 	netdev_err(qdev->ndev, "cqicb->msix_vect = %d\n", cqicb->msix_vect);
@@ -1725,6 +1735,8 @@ static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)

 void ql_dump_rx_ring(struct rx_ring *rx_ring)
 {
+	struct ql_adapter *qdev = rx_ring->qdev;
+
 	if (!rx_ring)
 		return;
 	netdev_err(qdev->ndev,
@@ -1816,7 +1828,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 #endif

 #ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct tx_buf_desc *tbd)
+void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd)
 {
 	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
 		   le64_to_cpu((u64)tbd->addr));
@@ -1843,7 +1855,7 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 		   tbd->len & TX_DESC_E ? "E" : ".");
 }

-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
+void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac_iocb)
 {
 	struct ob_mac_tso_iocb_req *ob_mac_tso_iocb =
 	    (struct ob_mac_tso_iocb_req *)ob_mac_iocb;
@@ -1886,10 +1898,10 @@ void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
 		frame_len = le16_to_cpu(ob_mac_iocb->frame_len);
 	}
 	tbd = &ob_mac_iocb->tbd[0];
-	ql_dump_tx_desc(tbd);
+	ql_dump_tx_desc(qdev, tbd);
 }

-void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp)
+void ql_dump_ob_mac_rsp(struct ql_adapter *qdev, struct ob_mac_iocb_rsp *ob_mac_rsp)
 {
 	netdev_err(qdev->ndev, "%s\n", __func__);
 	netdev_err(qdev->ndev, "opcode         = %d\n", ob_mac_rsp->opcode);
@@ -1906,7 +1918,7 @@ void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp)
 #endif

 #ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
+void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	netdev_err(qdev->ndev, "%s\n", __func__);
 	netdev_err(qdev->ndev, "opcode         = 0x%x\n", ib_mac_rsp->opcode);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 2028458bea6f..b351a7eb7a89 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1856,7 +1856,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;

-	QL_DUMP_IB_MAC_RSP(ib_mac_rsp);
+	QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp);

 	skb = ql_build_rx_skb(qdev, rx_ring, ib_mac_rsp);
 	if (unlikely(!skb)) {
@@ -1954,7 +1954,7 @@ static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
 			((le16_to_cpu(ib_mac_rsp->vlan_id) &
 			IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;

-	QL_DUMP_IB_MAC_RSP(ib_mac_rsp);
+	QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp);

 	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
 		/* The data and headers are split into
@@ -2001,7 +2001,7 @@ static void ql_process_mac_tx_intr(struct ql_adapter *qdev,
 	struct tx_ring *tx_ring;
 	struct tx_ring_desc *tx_ring_desc;

-	QL_DUMP_OB_MAC_RSP(mac_rsp);
+	QL_DUMP_OB_MAC_RSP(qdev, mac_rsp);
 	tx_ring = &qdev->tx_ring[mac_rsp->txq_idx];
 	tx_ring_desc = &tx_ring->q[mac_rsp->tid];
 	ql_unmap_send(qdev, tx_ring_desc, tx_ring_desc->map_cnt);
@@ -2593,7 +2593,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 		tx_ring->tx_errors++;
 		return NETDEV_TX_BUSY;
 	}
-	QL_DUMP_OB_MAC_IOCB(mac_iocb_ptr);
+	QL_DUMP_OB_MAC_IOCB(qdev, mac_iocb_ptr);
 	tx_ring->prod_idx++;
 	if (tx_ring->prod_idx == tx_ring->wq_len)
 		tx_ring->prod_idx = 0;
--
2.28.0

