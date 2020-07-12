Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EE021CC0A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgGLXPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgGLXPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPM-NV; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Paul Moore <paul@paul-moore.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 06/20] net: ipv4: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:02 +0200
Message-Id: <20200712231516.1139335-7-andrew@lunn.ch>
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

Cc: Paul Moore <paul@paul-moore.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv4/cipso_ipv4.c | 6 ++++--
 net/ipv4/ipmr.c       | 3 +++
 net/ipv4/tcp_input.c  | 1 -
 net/ipv4/tcp_output.c | 2 ++
 net/ipv4/tcp_timer.c  | 2 +-
 net/ipv4/udp.c        | 6 +++---
 6 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 0f1b9065c0a6..2eb71579f4d2 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -283,7 +283,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 
 /**
  * cipso_v4_cache_add - Add an entry to the CIPSO cache
- * @skb: the packet
+ * @cipso_ptr: pointer to CIPSO IP option
  * @secattr: the packet's security attributes
  *
  * Description:
@@ -1535,6 +1535,7 @@ unsigned char *cipso_v4_optptr(const struct sk_buff *skb)
 
 /**
  * cipso_v4_validate - Validate a CIPSO option
+ * @skb: the packet
  * @option: the start of the option, on error it is set to point to the error
  *
  * Description:
@@ -2066,7 +2067,7 @@ void cipso_v4_sock_delattr(struct sock *sk)
 
 /**
  * cipso_v4_req_delattr - Delete the CIPSO option from a request socket
- * @reg: the request socket
+ * @req: the request socket
  *
  * Description:
  * Removes the CIPSO option from a request socket, if present.
@@ -2158,6 +2159,7 @@ int cipso_v4_sock_getattr(struct sock *sk, struct netlbl_lsm_secattr *secattr)
 /**
  * cipso_v4_skbuff_setattr - Set the CIPSO option on a packet
  * @skb: the packet
+ * @doi_def: the DOI structure
  * @secattr: the security attributes
  *
  * Description:
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f5c7a58844a4..678639c01e48 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -636,7 +636,10 @@ static int call_ipmr_mfc_entry_notifiers(struct net *net,
 
 /**
  *	vif_delete - Delete a VIF entry
+ *	@mrt: Table to delete from
+ *	@vifi: VIF identifier to delete
  *	@notify: Set to 1, if the caller is a notifier_call
+ *	@head: if unregistering the VIF, place it on this queue
  */
 static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 		      struct list_head *head)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc77309ea15b..620829065e70 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4448,7 +4448,6 @@ static void tcp_sack_remove(struct tcp_sock *tp)
 /**
  * tcp_try_coalesce - try to merge skb to prior one
  * @sk: socket
- * @dest: destination queue
  * @to: prior buffer
  * @from: buffer to add in queue
  * @fragstolen: pointer to boolean
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 04b70fe31fa2..846dc3992708 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3335,6 +3335,8 @@ int tcp_send_synack(struct sock *sk)
  * sk: listener socket
  * dst: dst entry attached to the SYNACK
  * req: request_sock pointer
+ * foc: cookie for tcp fast open
+ * synack_type: Type of synback to prepare
  *
  * Allocate one skb and build a SYNACK packet.
  * @dst is consumed : Caller should not use it again.
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index ada046f425d2..0c08c420fbc2 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -314,7 +314,7 @@ void tcp_delack_timer_handler(struct sock *sk)
 
 /**
  *  tcp_delack_timer() - The TCP delayed ACK timeout handler
- *  @data:  Pointer to the current socket. (gets casted to struct sock *)
+ *  @t:  Pointer to the timer. (gets casted to struct sock *)
  *
  *  This function gets (indirectly) called when the kernel timer for a TCP packet
  *  of this socket expires. Calls tcp_delack_timer_handler() to do the actual work.
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 31530129f137..073d346f515c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2743,9 +2743,9 @@ int compat_udp_getsockopt(struct sock *sk, int level, int optname,
 #endif
 /**
  * 	udp_poll - wait for a UDP event.
- *	@file - file struct
- *	@sock - socket
- *	@wait - poll table
+ *	@file: - file struct
+ *	@sock: - socket
+ *	@wait: - poll table
  *
  *	This is same as datagram poll, except for the special case of
  *	blocking sockets. If application is using a blocking fd
-- 
2.27.0.rc2

