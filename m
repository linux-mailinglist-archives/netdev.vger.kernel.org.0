Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793AE3DFF4D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhHDKSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbhHDKSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:18:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97841C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 03:18:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDyK-00048E-0z
        for netdev@vger.kernel.org; Wed, 04 Aug 2021 12:18:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 99CF76607A4
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:17:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 84BE8660798;
        Wed,  4 Aug 2021 10:17:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id eae05cdc;
        Wed, 4 Aug 2021 10:17:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 2/5] can: j1939: rename J1939_ERRQUEUE_* to J1939_ERRQUEUE_TX_*
Date:   Wed,  4 Aug 2021 12:17:50 +0200
Message-Id: <20210804101753.23826-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804101753.23826-1-mkl@pengutronix.de>
References: <20210804101753.23826-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

Prepare the world for the J1939_ERRQUEUE_RX_ version

Link: https://lore.kernel.org/r/20210707094854.30781-2-o.rempel@pengutronix.de
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/j1939-priv.h | 6 +++---
 net/can/j1939/socket.c     | 6 +++---
 net/can/j1939/transport.c  | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
index 12369b604ce9..93b8ad7f7d04 100644
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -20,9 +20,9 @@
 
 struct j1939_session;
 enum j1939_sk_errqueue_type {
-	J1939_ERRQUEUE_ACK,
-	J1939_ERRQUEUE_SCHED,
-	J1939_ERRQUEUE_ABORT,
+	J1939_ERRQUEUE_TX_ACK,
+	J1939_ERRQUEUE_TX_SCHED,
+	J1939_ERRQUEUE_TX_ABORT,
 };
 
 /* j1939 devices */
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index b904c06ab0cf..6f3b10472f7f 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -964,7 +964,7 @@ void j1939_sk_errqueue(struct j1939_session *session,
 	serr = SKB_EXT_ERR(skb);
 	memset(serr, 0, sizeof(*serr));
 	switch (type) {
-	case J1939_ERRQUEUE_ACK:
+	case J1939_ERRQUEUE_TX_ACK:
 		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK)) {
 			kfree_skb(skb);
 			return;
@@ -975,7 +975,7 @@ void j1939_sk_errqueue(struct j1939_session *session,
 		serr->ee.ee_info = SCM_TSTAMP_ACK;
 		state = "ACK";
 		break;
-	case J1939_ERRQUEUE_SCHED:
+	case J1939_ERRQUEUE_TX_SCHED:
 		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED)) {
 			kfree_skb(skb);
 			return;
@@ -986,7 +986,7 @@ void j1939_sk_errqueue(struct j1939_session *session,
 		serr->ee.ee_info = SCM_TSTAMP_SCHED;
 		state = "SCH";
 		break;
-	case J1939_ERRQUEUE_ABORT:
+	case J1939_ERRQUEUE_TX_ABORT:
 		serr->ee.ee_errno = session->err;
 		serr->ee.ee_origin = SO_EE_ORIGIN_LOCAL;
 		serr->ee.ee_info = J1939_EE_INFO_TX_ABORT;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index a7f91db24f0e..801e700eaba6 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -261,9 +261,9 @@ static void __j1939_session_drop(struct j1939_session *session)
 static void j1939_session_destroy(struct j1939_session *session)
 {
 	if (session->err)
-		j1939_sk_errqueue(session, J1939_ERRQUEUE_ABORT);
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
 	else
-		j1939_sk_errqueue(session, J1939_ERRQUEUE_ACK);
+		j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ACK);
 
 	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
 
@@ -1044,7 +1044,7 @@ static int j1939_simple_txnext(struct j1939_session *session)
 	if (ret)
 		goto out_free;
 
-	j1939_sk_errqueue(session, J1939_ERRQUEUE_SCHED);
+	j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_SCHED);
 	j1939_sk_queue_activate_next(session);
 
  out_free:
@@ -1438,7 +1438,7 @@ j1939_xtp_rx_cts_one(struct j1939_session *session, struct sk_buff *skb)
 		if (session->transmission) {
 			if (session->pkt.tx_acked)
 				j1939_sk_errqueue(session,
-						  J1939_ERRQUEUE_SCHED);
+						  J1939_ERRQUEUE_TX_SCHED);
 			j1939_session_txtimer_cancel(session);
 			j1939_tp_schedule_txtimer(session, 0);
 		}
-- 
2.30.2


