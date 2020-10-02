Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53E281F79
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgJBX7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBX7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:59:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B9BC0613D0;
        Fri,  2 Oct 2020 16:59:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d9so2475787pfd.3;
        Fri, 02 Oct 2020 16:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=eXtPjqFBjHO4kg9zTxJUMDfFhIefX9wKnSvEHA9hRBg=;
        b=m1vDUDgfk1i05GRx47xu1Pz3U4BKqiFxZcf1oOQl404KJi0PVdPsI3Xt/vxPCXcYDa
         J0I9Bp9+j34LGWdKGQEy6+oaqYDXwowBgjS/6yZlkXcsbwJl2hd/3pkSDXj/S1lmtziq
         gw+I7FivoTCj0GIMzWEFGOLuNONZsEpwO+szwH9zH0wQ/Zg1xqyXSesbXjZ78vfdCQC7
         KwaCDJ4MccTmK6UfL9VI7qSzwk6mkX/QwIalUs+/Fj9r1mQ1eKWfwhTFaCRbWBpuXtl2
         evaeYavv/j1WY89DyuJCmbWI4+GJv5uq+7/cNLSf4gtF0V5GtDvw9G4bFxHbjXQQhRBv
         xQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=eXtPjqFBjHO4kg9zTxJUMDfFhIefX9wKnSvEHA9hRBg=;
        b=sF9oijOG7iYrGHJXVvILW0djvfqluWJZxzm0yyF9lHtEuwF2jEQfru/Irhgkd8K6gU
         QUl43xTDiMAdmly8j6Ifj0Dw1LzomCA3WBpRSxR/LgVP5VpEBkCBHm3Qc6G1Dey3QUSD
         9xRrDeo4cW5xpvLCJ46vFMnGTLjpaS4NV5IzfSYG8Qi2PrLDNztgP0WVfiT3Yx5d2ZPf
         fQAoPM6ORkrJIGSdOl5mrzYvXKVvH27nz0Zf+xtWngBn5dwb+GK9oZRm7/AlL/Bs9i3O
         l6ahJ1j6HDIaSnPGUZcYftYlq9upXseBrdoXteGYx0afFEpjli04uXk3DozYLtJfzkaC
         qP5g==
X-Gm-Message-State: AOAM533r48mMR8H7owF+/5PKzb5TVjrdZbGhD5+tLUhdk3pgT1kib4BF
        yQVQqmgJP0gILfxlx9if1r8pgH6Fv0vLULYC
X-Google-Smtp-Source: ABdhPJzAosvNtew2O/e969wqYFjHl4uqs1hEeTyQIWhY7ldGWqTA1RKqWxJXdDv/PDTVCUGEPDq5AQ==
X-Received: by 2002:a63:6782:: with SMTP id b124mr4621696pgc.308.1601683187354;
        Fri, 02 Oct 2020 16:59:47 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id 134sm2755383pgf.55.2020.10.02.16.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 16:59:46 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] staging: qlge: fix build breakage with dumping enabled
Date:   Sat,  3 Oct 2020 07:59:41 +0800
Message-Id: <20201002235941.77062-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
Reply-To: 20200902140031.203374-1-coiby.xu@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes commit 0107635e15ac
("staging: qlge: replace pr_err with netdev_err") which introduced an
build breakage of missing `struct ql_adapter *qdev` for some functions
and a warning of type mismatch with dumping enabled, i.e.,

$ make CFLAGS_MODULE="-DQL_ALL_DUMP -DQL_OB_DUMP -DQL_CB_DUMP \
    -DQL_IB_DUMP -DQL_REG_DUMP -DQL_DEV_DUMP" M=drivers/staging/qlge

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

Note that now ql_dump_rx_ring/ql_dump_tx_ring won't check if the passed
parameter is a null pointer.

Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h      | 20 ++++++++++----------
 drivers/staging/qlge/qlge_dbg.c  | 28 ++++++++++++++++++----------
 drivers/staging/qlge/qlge_main.c |  8 ++++----
 3 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 48f346503979..b295990e361b 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2337,21 +2337,21 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id);
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
index a55bf0b3e9dc..42fd13990f3a 100644
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
@@ -1632,8 +1635,8 @@ void ql_dump_wqicb(struct wqicb *wqicb)

 void ql_dump_tx_ring(struct tx_ring *tx_ring)
 {
-	if (!tx_ring)
-		return;
+	struct ql_adapter *qdev = tx_ring->qdev;
+
 	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
 		   tx_ring->wq_id);
 	netdev_err(qdev->ndev, "tx_ring->base = %p\n", tx_ring->wq_base);
@@ -1657,6 +1660,8 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 void ql_dump_ricb(struct ricb *ricb)
 {
 	int i;
+	struct ql_adapter *qdev =
+		container_of(ricb, struct ql_adapter, ricb);

 	netdev_err(qdev->ndev, "===================== Dumping ricb ===============\n");
 	netdev_err(qdev->ndev, "Dumping ricb stuff...\n");
@@ -1686,6 +1691,9 @@ void ql_dump_ricb(struct ricb *ricb)

 void ql_dump_cqicb(struct cqicb *cqicb)
 {
+	struct rx_ring *rx_ring = container_of(cqicb, struct rx_ring, cqicb);
+	struct ql_adapter *qdev = rx_ring->qdev;
+
 	netdev_err(qdev->ndev, "Dumping cqicb stuff...\n");

 	netdev_err(qdev->ndev, "cqicb->msix_vect = %d\n", cqicb->msix_vect);
@@ -1725,8 +1733,8 @@ static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)

 void ql_dump_rx_ring(struct rx_ring *rx_ring)
 {
-	if (!rx_ring)
-		return;
+	struct ql_adapter *qdev = rx_ring->qdev;
+
 	netdev_err(qdev->ndev,
 		   "===================== Dumping rx_ring %d ===============\n",
 		   rx_ring->cq_id);
@@ -1816,7 +1824,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 #endif

 #ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct tx_buf_desc *tbd)
+void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd)
 {
 	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
 		   le64_to_cpu((u64)tbd->addr));
@@ -1843,7 +1851,7 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 		   tbd->len & TX_DESC_E ? "E" : ".");
 }

-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
+void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac_iocb)
 {
 	struct ob_mac_tso_iocb_req *ob_mac_tso_iocb =
 	    (struct ob_mac_tso_iocb_req *)ob_mac_iocb;
@@ -1886,10 +1894,10 @@ void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
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
@@ -1906,7 +1914,7 @@ void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp)
 #endif

 #ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
+void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	netdev_err(qdev->ndev, "%s\n", __func__);
 	netdev_err(qdev->ndev, "opcode         = 0x%x\n", ib_mac_rsp->opcode);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 154c2ca35079..27da386f9d87 100644
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
@@ -2592,7 +2592,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
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

