Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB521CC05
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgGLXPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbgGLXPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPR-QP; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 08/20] net: llc: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:04 +0200
Message-Id: <20200712231516.1139335-9-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/llc/af_llc.c    | 1 -
 net/llc/llc_conn.c  | 7 ++++---
 net/llc/llc_input.c | 1 +
 net/llc/llc_pdu.c   | 2 +-
 net/llc/llc_sap.c   | 3 +++
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 54fb8d452a7b..a7e5d23df5e7 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -980,7 +980,6 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
  *	llc_ui_getname - return the address info of a socket
  *	@sock: Socket to get address of.
  *	@uaddr: Address structure to return information.
- *	@uaddrlen: Length of address structure.
  *	@peer: Does user want local or remote address information.
  *
  *	Return the address information of a socket.
diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 7b620acaca9e..1144cda2a0fc 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -284,8 +284,8 @@ out:;
 /**
  *	llc_conn_remove_acked_pdus - Removes acknowledged pdus from tx queue
  *	@sk: active connection
- *	nr: NR
- *	how_many_unacked: size of pdu_unack_q after removing acked pdus
+ *	@nr: NR
+ *	@how_many_unacked: size of pdu_unack_q after removing acked pdus
  *
  *	Removes acknowledged pdus from transmit queue (pdu_unack_q). Returns
  *	the number of pdus that removed from queue.
@@ -906,6 +906,7 @@ static void llc_sk_init(struct sock *sk)
 
 /**
  *	llc_sk_alloc - Allocates LLC sock
+ *	@net: network namespace
  *	@family: upper layer protocol family
  *	@priority: for allocation (%GFP_KERNEL, %GFP_ATOMIC, etc)
  *
@@ -951,7 +952,7 @@ void llc_sk_stop_all_timers(struct sock *sk, bool sync)
 
 /**
  *	llc_sk_free - Frees a LLC socket
- *	@sk - socket to free
+ *	@sk: - socket to free
  *
  *	Frees a LLC socket
  */
diff --git a/net/llc/llc_input.c b/net/llc/llc_input.c
index 82cb93f66b9b..c309b72a5877 100644
--- a/net/llc/llc_input.c
+++ b/net/llc/llc_input.c
@@ -144,6 +144,7 @@ static inline int llc_fixup_skb(struct sk_buff *skb)
  *	@skb: received pdu
  *	@dev: device that receive pdu
  *	@pt: packet type
+ *	@orig_dev: the original receive net device
  *
  *	When the system receives a 802.2 frame this function is called. It
  *	checks SAP and connection of received pdu and passes frame to
diff --git a/net/llc/llc_pdu.c b/net/llc/llc_pdu.c
index 2e6cb79196bb..792d195c8bae 100644
--- a/net/llc/llc_pdu.c
+++ b/net/llc/llc_pdu.c
@@ -25,7 +25,7 @@ void llc_pdu_set_cmd_rsp(struct sk_buff *skb, u8 pdu_type)
 
 /**
  *	pdu_set_pf_bit - sets poll/final bit in LLC header
- *	@pdu_frame: input frame that p/f bit must be set into it.
+ *	@skb: Frame to set bit in
  *	@bit_value: poll/final bit (0 or 1).
  *
  *	This function sets poll/final bit in LLC header (based on type of PDU).
diff --git a/net/llc/llc_sap.c b/net/llc/llc_sap.c
index be419062e19a..6805ce43a055 100644
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -37,6 +37,7 @@ static int llc_mac_header_len(unsigned short devtype)
 
 /**
  *	llc_alloc_frame - allocates sk_buff for frame
+ *	@sk:  socket to allocate frame to
  *	@dev: network device this skb will be sent over
  *	@type: pdu type to allocate
  *	@data_size: data size to allocate
@@ -273,6 +274,7 @@ void llc_build_and_send_xid_pkt(struct llc_sap *sap, struct sk_buff *skb,
  *	llc_sap_rcv - sends received pdus to the sap state machine
  *	@sap: current sap component structure.
  *	@skb: received frame.
+ *	@sk:  socket to associate to frame
  *
  *	Sends received pdus to the sap state machine.
  */
@@ -379,6 +381,7 @@ static void llc_do_mcast(struct llc_sap *sap, struct sk_buff *skb,
  * 	llc_sap_mcast - Deliver multicast PDU's to all matching datagram sockets.
  *	@sap: SAP
  *	@laddr: address of local LLC (MAC + SAP)
+ *	@skb: PDU to deliver
  *
  *	Search socket list of the SAP and finds connections with same sap.
  *	Deliver clone to each.
-- 
2.27.0.rc2

