Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A834724CE66
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgHUHDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHUHDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:03:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540FCC061385;
        Fri, 21 Aug 2020 00:03:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kr4so428267pjb.2;
        Fri, 21 Aug 2020 00:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KoWHzi4jQh/WrJaINhrAshP9mUhGSBVyi8SEYgaYkFQ=;
        b=U9xd2xFyGvRA2RucDuoIZUC3oR+nYSMIrphn8ushugIJA3mk04foPXPC7bGDV9Atpr
         WNksE7EOX+zAX7SAQoHmXkiDjjQmKLyRTcuC6F2viVneYeKY9GeZVa2h3G5fyg9Ka4xD
         gGmgtfbcNC4CuhVYwfll20bb9QLiI62pWATK8DJM/dGqrRoodwpH9nA6+QRHoIZtRswo
         EGH9GFIXzkHnCj4ATahf8BxHyc9DJxq6F3Sma/vR5X5TRon3c7MNnJJq+dBdIRtNKbtY
         ijIO1/dybMhTIC1CFJWFlNNTzCsdwpa8eEmHncCOEKcS/xnO38Nqu+HnAOTk0nUZEc03
         mP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KoWHzi4jQh/WrJaINhrAshP9mUhGSBVyi8SEYgaYkFQ=;
        b=WcfTMZ2wcm50l29JhPOM22slcGhjcQJxTn4l4vqhAXbww4Fz8oJMRIAyFV+GjOtJSq
         FQcYDNIdfVhg6A4tKq0IsCbbKfTCncAoq9UjdCjXikuHACoYQZ0RVz3qB7bgp/L1HcjJ
         RefBzPT7UaN0SZXHKa79OxMZxJHPSTqO09NtSfJkCPfdp1RNiaUbmDIt/TNZFzXGUE+E
         MT/f7OVjmqdic0XHUwI0tf3pXMPij4cD2SOGgYU4eXiAk83soCI5biHtbv0Uysno7fqd
         vaMePwdIsz8F4tMqYIx6yQeN74ILiy1ld8N8NkKfIMem0eW8KE1RXeUmnCR84VK17Tcp
         WySw==
X-Gm-Message-State: AOAM530Zc5TE3BsHSeCm4UR2N9NRZ1irto60FJ64GeRt0gYxGPPq5GBj
        PucuAMSVBJgzOh0h2Vfgxr4CvCMFvHxrssxWmGI=
X-Google-Smtp-Source: ABdhPJwXfBiUuRiz9yVqT5L4bjaSRqqPvv7pgp6YdCrm4Pio0ZU8DeyKGR0RuyGqp9p2mt9wiOgG6Q==
X-Received: by 2002:a17:902:7401:: with SMTP id g1mr1272521pll.137.1597993427845;
        Fri, 21 Aug 2020 00:03:47 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id f18sm1429248pfj.35.2020.08.21.00.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:03:47 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: qlge: fix build breakage with dumping enabled
Date:   Fri, 21 Aug 2020 15:03:34 +0800
Message-Id: <20200821070334.738358-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes commit 0107635e15ac
("staging: qlge: replace pr_err with netdev_err") which introduced an
build breakage with dumping enabled, i.e.,

    $ QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 QL_REG_DUMP=1 \
      QL_IB_DUMP=1 QL_DEV_DUMP=1 make M=drivers/staging/qlge

Fixes: 0107635e15ac ("taging: qlge: replace pr_err with netdev_err")
Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h      | 42 ++++++++++++++++----------------
 drivers/staging/qlge/qlge_dbg.c  | 36 +++++++++++++--------------
 drivers/staging/qlge/qlge_main.c |  4 +--
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 483ce04789ed..c72c1d2a00a8 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2315,37 +2315,37 @@ void ql_dump_qdev(struct ql_adapter *qdev);
 #endif
 
 #ifdef QL_CB_DUMP
-void ql_dump_wqicb(struct wqicb *wqicb);
-void ql_dump_tx_ring(struct tx_ring *tx_ring);
-void ql_dump_ricb(struct ricb *ricb);
-void ql_dump_cqicb(struct cqicb *cqicb);
-void ql_dump_rx_ring(struct rx_ring *rx_ring);
+void ql_dump_wqicb(struct ql_adapter *qdev, struct wqicb *wqicb);
+void ql_dump_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring);
+void ql_dump_ricb(struct ql_adapter *qdev, struct ricb *ricb);
+void ql_dump_cqicb(struct ql_adapter *qdev, struct cqicb *cqicb);
+void ql_dump_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring);
 void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id);
-#define QL_DUMP_RICB(ricb) ql_dump_ricb(ricb)
-#define QL_DUMP_WQICB(wqicb) ql_dump_wqicb(wqicb)
-#define QL_DUMP_TX_RING(tx_ring) ql_dump_tx_ring(tx_ring)
-#define QL_DUMP_CQICB(cqicb) ql_dump_cqicb(cqicb)
-#define QL_DUMP_RX_RING(rx_ring) ql_dump_rx_ring(rx_ring)
+#define QL_DUMP_RICB(qdev, ricb) ql_dump_ricb(qdev, ricb)
+#define QL_DUMP_WQICB(qdev, wqicb) ql_dump_wqicb(qdev, wqicb)
+#define QL_DUMP_TX_RING(qdev, tx_ring) ql_dump_tx_ring(qdev, tx_ring)
+#define QL_DUMP_CQICB(qdev, cqicb) ql_dump_cqicb(qdev, cqicb)
+#define QL_DUMP_RX_RING(qdev, rx_ring) ql_dump_rx_ring(qdev, rx_ring)
 #define QL_DUMP_HW_CB(qdev, size, bit, q_id) \
 		ql_dump_hw_cb(qdev, size, bit, q_id)
 #else
-#define QL_DUMP_RICB(ricb)
-#define QL_DUMP_WQICB(wqicb)
-#define QL_DUMP_TX_RING(tx_ring)
-#define QL_DUMP_CQICB(cqicb)
-#define QL_DUMP_RX_RING(rx_ring)
+#define QL_DUMP_RICB(qdev, ricb)
+#define QL_DUMP_WQICB(qdev, wqicb)
+#define QL_DUMP_TX_RING(qdev, tx_ring)
+#define QL_DUMP_CQICB(qdev, cqicb)
+#define QL_DUMP_RX_RING(qdev, rx_ring)
 #define QL_DUMP_HW_CB(qdev, size, bit, q_id)
 #endif
 
 #ifdef QL_OB_DUMP
 void ql_dump_tx_desc(struct tx_buf_desc *tbd);
-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb);
-void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp);
-#define QL_DUMP_OB_MAC_IOCB(ob_mac_iocb) ql_dump_ob_mac_iocb(ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(ob_mac_rsp) ql_dump_ob_mac_rsp(ob_mac_rsp)
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
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index a55bf0b3e9dc..123d3f7475ae 100644
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
@@ -1615,7 +1615,7 @@ void ql_dump_qdev(struct ql_adapter *qdev)
 #endif
 
 #ifdef QL_CB_DUMP
-void ql_dump_wqicb(struct wqicb *wqicb)
+void ql_dump_wqicb(struct ql_adapter *qdev, struct wqicb *wqicb)
 {
 	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
 	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
@@ -1630,7 +1630,7 @@ void ql_dump_wqicb(struct wqicb *wqicb)
 		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
 }
 
-void ql_dump_tx_ring(struct tx_ring *tx_ring)
+void ql_dump_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 {
 	if (!tx_ring)
 		return;
@@ -1654,7 +1654,7 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 	netdev_err(qdev->ndev, "tx_ring->tx_count = %d\n", atomic_read(&tx_ring->tx_count));
 }
 
-void ql_dump_ricb(struct ricb *ricb)
+void ql_dump_ricb(struct ql_adapter *qdev, struct ricb *ricb)
 {
 	int i;
 
@@ -1684,7 +1684,7 @@ void ql_dump_ricb(struct ricb *ricb)
 			   le32_to_cpu(ricb->ipv4_hash_key[i]));
 }
 
-void ql_dump_cqicb(struct cqicb *cqicb)
+void ql_dump_cqicb(struct ql_adapter *qdev, struct cqicb *cqicb)
 {
 	netdev_err(qdev->ndev, "Dumping cqicb stuff...\n");
 
@@ -1723,7 +1723,7 @@ static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)
 		return "TX COMPLETION";
 };
 
-void ql_dump_rx_ring(struct rx_ring *rx_ring)
+void ql_dump_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 {
 	if (!rx_ring)
 		return;
@@ -1798,13 +1798,13 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 	}
 	switch (bit) {
 	case CFG_DRQ:
-		ql_dump_wqicb((struct wqicb *)ptr);
+		ql_dump_wqicb(qdev, (struct wqicb *)ptr);
 		break;
 	case CFG_DCQ:
-		ql_dump_cqicb((struct cqicb *)ptr);
+		ql_dump_cqicb(qdev, (struct cqicb *)ptr);
 		break;
 	case CFG_DR:
-		ql_dump_ricb((struct ricb *)ptr);
+		ql_dump_ricb(qdev, (struct ricb *)ptr);
 		break;
 	default:
 		netdev_err(qdev->ndev, "%s: Invalid bit value = %x\n", __func__, bit);
@@ -1816,7 +1816,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 #endif
 
 #ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct tx_buf_desc *tbd)
+void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd)
 {
 	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
 		   le64_to_cpu((u64)tbd->addr));
@@ -1843,7 +1843,7 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 		   tbd->len & TX_DESC_E ? "E" : ".");
 }
 
-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
+void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac_iocb)
 {
 	struct ob_mac_tso_iocb_req *ob_mac_tso_iocb =
 	    (struct ob_mac_tso_iocb_req *)ob_mac_iocb;
@@ -1886,10 +1886,10 @@ void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
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
@@ -1906,7 +1906,7 @@ void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp)
 #endif
 
 #ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
+void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	netdev_err(qdev->ndev, "%s\n", __func__);
 	netdev_err(qdev->ndev, "opcode         = 0x%x\n", ib_mac_rsp->opcode);
@@ -1995,12 +1995,12 @@ void ql_dump_all(struct ql_adapter *qdev)
 	QL_DUMP_REGS(qdev);
 	QL_DUMP_QDEV(qdev);
 	for (i = 0; i < qdev->tx_ring_count; i++) {
-		QL_DUMP_TX_RING(&qdev->tx_ring[i]);
-		QL_DUMP_WQICB((struct wqicb *)&qdev->tx_ring[i]);
+		QL_DUMP_TX_RING(qdev, &qdev->tx_ring[i]);
+		QL_DUMP_WQICB(qdev, (struct wqicb *)&qdev->tx_ring[i]);
 	}
 	for (i = 0; i < qdev->rx_ring_count; i++) {
-		QL_DUMP_RX_RING(&qdev->rx_ring[i]);
-		QL_DUMP_CQICB((struct cqicb *)&qdev->rx_ring[i]);
+		QL_DUMP_RX_RING(qdev, &qdev->rx_ring[i]);
+		QL_DUMP_CQICB(qdev, (struct cqicb *)&qdev->rx_ring[i]);
 	}
 }
 #endif
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 2028458bea6f..61b4abf7b8ae 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
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

