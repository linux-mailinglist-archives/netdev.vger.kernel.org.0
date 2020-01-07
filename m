Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9779131F81
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 06:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgAGFsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 00:48:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44365 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgAGFsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 00:48:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id az3so22734294plb.11
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 21:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBdcBUa9neWrNycYPg6Xn0JWlrsGRPiALO7TyZJ27r4=;
        b=OBuUT/c7eH2sNBiwbWKpCm0EvCU+le18qBEhJRO7vm1Hy3Kkqd3b5ODS334pOOFELQ
         5vZMxskS26ZUL+PGn+FmV/s3Aar0P0QpR1O7NZ+DVcKtCVgvXPOMbaFLlMCEMnNXVoPO
         6/GClz7F0z23CCf9dqL2+WisKR+e3zKdX7yGrMDtF6WOcOzi4AgUHCGvg+mgsEKOGjPt
         mQZuxq/Dp3tGjQesb2FIrx1jsdC4h9WLORMWCkEysLMJ6EGc0RaNIOuzCIz6kIDx8mn1
         SkhQjTsqbKWyhauWm7Ib/SeJU7Ggr2ZXMooQRjYdb/3J0JYZEPuPehuLenEN/k4Pn4EU
         4+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBdcBUa9neWrNycYPg6Xn0JWlrsGRPiALO7TyZJ27r4=;
        b=sP0GSLHfmtzo13+akWM6z6JXG8kika0i8hIDXXZmIK/HcOYJEpHhsBbKLE7BN/y5Uf
         MCz6lwx4z4PgUdyicuAsMaYZl8D5to4mDqeK6PkDPMItjo83ACtB1Hk4mon8zLCcvRIX
         tTLAmON0oG5DtPOpiO3c3C5fePNdEfV+FCzqdCoEt8wjjm4Fjxp9El/tRajc5PzbKA3A
         Zub3J7+ZAqW1T8t/OZCouxGGGFWMxo/SdjYAKs8+ajRBt5D6dZ3aCbPVvtdj+PxUUbWS
         b+ZpEoEF2fJrbaH0CB/33Lm7bSGa4+hGcpr6TEeFt/oPcs74Fan6xU3uZfJVMfgamqVa
         KFUw==
X-Gm-Message-State: APjAAAU1na2/ASrGn3bqItv7a5/IzMR0GG2EX41eoN+H+B9CFznGxh/Y
        0ZST6V8/fY3de+jK7yaewpQa9g==
X-Google-Smtp-Source: APXvYqzapVe65+YM76oisi5LeUPXFisQpAfqpgAqDCGAc2BVKQ+14xuTG6BZuHx3KfMhQBZmS1dSKA==
X-Received: by 2002:a17:90a:a596:: with SMTP id b22mr680943pjq.28.1578376082555;
        Mon, 06 Jan 2020 21:48:02 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id k21sm67129177pfa.63.2020.01.06.21.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 21:48:02 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 5/5] net: qrtr: Remove receive worker
Date:   Mon,  6 Jan 2020 21:47:13 -0800
Message-Id: <20200107054713.3909260-6-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
References: <20200107054713.3909260-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than enqueuing messages and scheduling a worker to deliver them
to the individual sockets we can now, thanks to the previous work, move
this directly into the endpoint callback.

This saves us a context switch per incoming message and removes the
possibility of an opportunistic suspend to happen between the message is
coming from the endpoint until it ends up in the socket's receive
buffer.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v2:
- None

 net/qrtr/qrtr.c | 57 +++++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 40 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index aae24c1d8531..c94240d7c89f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -119,7 +119,6 @@ static DEFINE_MUTEX(qrtr_port_lock);
  * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
  * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
  * @rx_queue: receive queue
- * @work: scheduled work struct for recv work
  * @item: list item for broadcast list
  */
 struct qrtr_node {
@@ -132,7 +131,6 @@ struct qrtr_node {
 	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
 
 	struct sk_buff_head rx_queue;
-	struct work_struct work;
 	struct list_head item;
 };
 
@@ -157,6 +155,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 			      int type, struct sockaddr_qrtr *from,
 			      struct sockaddr_qrtr *to);
+static struct qrtr_sock *qrtr_port_lookup(int port);
+static void qrtr_port_put(struct qrtr_sock *ipc);
 
 /* Release node resources and free the node.
  *
@@ -178,7 +178,6 @@ static void __qrtr_node_release(struct kref *kref)
 	list_del(&node->item);
 	mutex_unlock(&qrtr_node_lock);
 
-	cancel_work_sync(&node->work);
 	skb_queue_purge(&node->rx_queue);
 
 	/* Free tx flow counters */
@@ -418,6 +417,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	struct qrtr_node *node = ep->node;
 	const struct qrtr_hdr_v1 *v1;
 	const struct qrtr_hdr_v2 *v2;
+	struct qrtr_sock *ipc;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
 	unsigned int size;
@@ -482,8 +482,20 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	skb_put_data(skb, data + hdrlen, size);
 
-	skb_queue_tail(&node->rx_queue, skb);
-	schedule_work(&node->work);
+	qrtr_node_assign(node, cb->src_node);
+
+	if (cb->type == QRTR_TYPE_RESUME_TX) {
+		qrtr_tx_resume(node, skb);
+	} else {
+		ipc = qrtr_port_lookup(cb->dst_port);
+		if (!ipc)
+			goto err;
+
+		if (sock_queue_rcv_skb(&ipc->sk, skb))
+			goto err;
+
+		qrtr_port_put(ipc);
+	}
 
 	return 0;
 
@@ -518,40 +530,6 @@ static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt)
 	return skb;
 }
 
-static struct qrtr_sock *qrtr_port_lookup(int port);
-static void qrtr_port_put(struct qrtr_sock *ipc);
-
-/* Handle and route a received packet.
- *
- * This will auto-reply with resume-tx packet as necessary.
- */
-static void qrtr_node_rx_work(struct work_struct *work)
-{
-	struct qrtr_node *node = container_of(work, struct qrtr_node, work);
-	struct sk_buff *skb;
-
-	while ((skb = skb_dequeue(&node->rx_queue)) != NULL) {
-		struct qrtr_sock *ipc;
-		struct qrtr_cb *cb = (struct qrtr_cb *)skb->cb;
-
-		qrtr_node_assign(node, cb->src_node);
-
-		if (cb->type == QRTR_TYPE_RESUME_TX) {
-			qrtr_tx_resume(node, skb);
-		} else {
-			ipc = qrtr_port_lookup(cb->dst_port);
-			if (!ipc) {
-				kfree_skb(skb);
-			} else {
-				if (sock_queue_rcv_skb(&ipc->sk, skb))
-					kfree_skb(skb);
-
-				qrtr_port_put(ipc);
-			}
-		}
-	}
-}
-
 /**
  * qrtr_endpoint_register() - register a new endpoint
  * @ep: endpoint to register
@@ -571,7 +549,6 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	if (!node)
 		return -ENOMEM;
 
-	INIT_WORK(&node->work, qrtr_node_rx_work);
 	kref_init(&node->ref);
 	mutex_init(&node->ep_lock);
 	skb_queue_head_init(&node->rx_queue);
-- 
2.24.0

