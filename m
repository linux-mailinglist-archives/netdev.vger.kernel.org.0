Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD824E64D
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgHVIKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 04:10:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10306 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727087AbgHVIJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 04:09:57 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C5B774E86E6268C52B1D;
        Sat, 22 Aug 2020 16:09:52 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sat, 22 Aug 2020
 16:09:46 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <gerrit@erg.abdn.ac.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <grandmaster@al2klimov.de>
CC:     <dccp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] net: dccp: Convert to use the preferred fallthrough macro
Date:   Sat, 22 Aug 2020 04:08:27 -0400
Message-ID: <20200822080827.33935-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/dccp/ccids/ccid3.c |  2 +-
 net/dccp/feat.c        |  3 ++-
 net/dccp/input.c       | 10 +++++-----
 net/dccp/options.c     |  2 +-
 net/dccp/output.c      |  8 ++++----
 net/dccp/proto.c       |  8 ++++----
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index aef72f6a2829..b9ee1a4a8955 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -608,7 +608,7 @@ static void ccid3_hc_rx_send_feedback(struct sock *sk,
 		 */
 		if (hc->rx_x_recv > 0)
 			break;
-		/* fall through */
+		fallthrough;
 	case CCID3_FBACK_PERIODIC:
 		delta = ktime_us_delta(now, hc->rx_tstamp_last_feedback);
 		if (delta <= 0)
diff --git a/net/dccp/feat.c b/net/dccp/feat.c
index afc071ea1271..788dd629c420 100644
--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -1407,7 +1407,8 @@ int dccp_feat_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 	 *	Negotiation during connection setup
 	 */
 	case DCCP_LISTEN:
-		server = true;			/* fall through */
+		server = true;
+		fallthrough;
 	case DCCP_REQUESTING:
 		switch (opt) {
 		case DCCPO_CHANGE_L:
diff --git a/net/dccp/input.c b/net/dccp/input.c
index bd9cfdb67436..2cbb757a894f 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -64,7 +64,7 @@ static int dccp_rcv_close(struct sock *sk, struct sk_buff *skb)
 		 */
 		if (dccp_sk(sk)->dccps_role != DCCP_ROLE_CLIENT)
 			break;
-		/* fall through */
+		fallthrough;
 	case DCCP_REQUESTING:
 	case DCCP_ACTIVE_CLOSEREQ:
 		dccp_send_reset(sk, DCCP_RESET_CODE_CLOSED);
@@ -76,7 +76,7 @@ static int dccp_rcv_close(struct sock *sk, struct sk_buff *skb)
 		queued = 1;
 		dccp_fin(sk, skb);
 		dccp_set_state(sk, DCCP_PASSIVE_CLOSE);
-		/* fall through */
+		fallthrough;
 	case DCCP_PASSIVE_CLOSE:
 		/*
 		 * Retransmitted Close: we have already enqueued the first one.
@@ -113,7 +113,7 @@ static int dccp_rcv_closereq(struct sock *sk, struct sk_buff *skb)
 		queued = 1;
 		dccp_fin(sk, skb);
 		dccp_set_state(sk, DCCP_PASSIVE_CLOSEREQ);
-		/* fall through */
+		fallthrough;
 	case DCCP_PASSIVE_CLOSEREQ:
 		sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
 	}
@@ -530,7 +530,7 @@ static int dccp_rcv_respond_partopen_state_process(struct sock *sk,
 	case DCCP_PKT_DATA:
 		if (sk->sk_state == DCCP_RESPOND)
 			break;
-		/* fall through */
+		fallthrough;
 	case DCCP_PKT_DATAACK:
 	case DCCP_PKT_ACK:
 		/*
@@ -684,7 +684,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Step 8: if using Ack Vectors, mark packet acknowledgeable */
 		dccp_handle_ackvec_processing(sk, skb);
 		dccp_deliver_input_to_ccids(sk, skb);
-		/* fall through */
+		fallthrough;
 	case DCCP_RESPOND:
 		queued = dccp_rcv_respond_partopen_state_process(sk, skb,
 								 dh, len);
diff --git a/net/dccp/options.c b/net/dccp/options.c
index 51aaba7a5d45..d24cad05001e 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -225,7 +225,7 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 			 * interested. The RX CCID need not parse Ack Vectors,
 			 * since it is only interested in clearing old state.
 			 */
-			/* fall through */
+			fallthrough;
 		case DCCPO_MIN_TX_CCID_SPECIFIC ... DCCPO_MAX_TX_CCID_SPECIFIC:
 			if (ccid_hc_tx_parse_options(dp->dccps_hc_tx_ccid, sk,
 						     pkt_type, opt, value, len))
diff --git a/net/dccp/output.c b/net/dccp/output.c
index 6433187a5cc4..50e6d5699bb2 100644
--- a/net/dccp/output.c
+++ b/net/dccp/output.c
@@ -62,7 +62,7 @@ static int dccp_transmit_skb(struct sock *sk, struct sk_buff *skb)
 		switch (dcb->dccpd_type) {
 		case DCCP_PKT_DATA:
 			set_ack = 0;
-			/* fall through */
+			fallthrough;
 		case DCCP_PKT_DATAACK:
 		case DCCP_PKT_RESET:
 			break;
@@ -72,12 +72,12 @@ static int dccp_transmit_skb(struct sock *sk, struct sk_buff *skb)
 			/* Use ISS on the first (non-retransmitted) Request. */
 			if (icsk->icsk_retransmits == 0)
 				dcb->dccpd_seq = dp->dccps_iss;
-			/* fall through */
+			fallthrough;
 
 		case DCCP_PKT_SYNC:
 		case DCCP_PKT_SYNCACK:
 			ackno = dcb->dccpd_ack_seq;
-			/* fall through */
+			fallthrough;
 		default:
 			/*
 			 * Set owner/destructor: some skbs are allocated via
@@ -481,7 +481,7 @@ struct sk_buff *dccp_ctl_make_reset(struct sock *sk, struct sk_buff *rcv_skb)
 	case DCCP_RESET_CODE_PACKET_ERROR:
 		dhr->dccph_reset_data[0] = rxdh->dccph_type;
 		break;
-	case DCCP_RESET_CODE_OPTION_ERROR:	/* fall through */
+	case DCCP_RESET_CODE_OPTION_ERROR:
 	case DCCP_RESET_CODE_MANDATORY_ERROR:
 		memcpy(dhr->dccph_reset_data, dcb->dccpd_reset_data, 3);
 		break;
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index d148ab1530e5..6d705d90c614 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -101,7 +101,7 @@ void dccp_set_state(struct sock *sk, const int state)
 		if (inet_csk(sk)->icsk_bind_hash != NULL &&
 		    !(sk->sk_userlocks & SOCK_BINDPORT_LOCK))
 			inet_put_port(sk);
-		/* fall through */
+		fallthrough;
 	default:
 		if (oldstate == DCCP_OPEN)
 			DCCP_DEC_STATS(DCCP_MIB_CURRESTAB);
@@ -834,7 +834,7 @@ int dccp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		case DCCP_PKT_CLOSEREQ:
 			if (!(flags & MSG_PEEK))
 				dccp_finish_passive_close(sk);
-			/* fall through */
+			fallthrough;
 		case DCCP_PKT_RESET:
 			dccp_pr_debug("found fin (%s) ok!\n",
 				      dccp_packet_name(dh->dccph_type));
@@ -960,7 +960,7 @@ static void dccp_terminate_connection(struct sock *sk)
 	case DCCP_PARTOPEN:
 		dccp_pr_debug("Stop PARTOPEN timer (%p)\n", sk);
 		inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);
-		/* fall through */
+		fallthrough;
 	case DCCP_OPEN:
 		dccp_send_close(sk, 1);
 
@@ -969,7 +969,7 @@ static void dccp_terminate_connection(struct sock *sk)
 			next_state = DCCP_ACTIVE_CLOSEREQ;
 		else
 			next_state = DCCP_CLOSING;
-		/* fall through */
+		fallthrough;
 	default:
 		dccp_set_state(sk, next_state);
 	}
-- 
2.19.1

