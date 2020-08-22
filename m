Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4568124E65C
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHVIUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 04:20:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10307 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbgHVIUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 04:20:08 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E9B837DAAECB4A8D3726;
        Sat, 22 Aug 2020 16:20:04 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sat, 22 Aug 2020
 16:19:55 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <arnd@arndb.de>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] sunrpc: Convert to use the preferred fallthrough macro
Date:   Sat, 22 Aug 2020 04:18:49 -0400
Message-ID: <20200822081849.41907-1-linmiaohe@huawei.com>
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
 net/sunrpc/auth_gss/gss_krb5_wrap.c |  2 +-
 net/sunrpc/clnt.c                   | 22 +++++++++++-----------
 net/sunrpc/xprt.c                   |  2 +-
 net/sunrpc/xprtrdma/verbs.c         |  2 +-
 net/sunrpc/xprtsock.c               |  8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index 90b8329fef82..8b300b74a722 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -137,7 +137,7 @@ gss_krb5_make_confounder(char *p, u32 conflen)
 	switch (conflen) {
 	case 16:
 		*q++ = i++;
-		/* fall through */
+		fallthrough;
 	case 8:
 		*q++ = i++;
 		break;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a91d1cdad9d7..62e0b6c1e8cf 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1702,7 +1702,7 @@ call_reserveresult(struct rpc_task *task)
 	switch (status) {
 	case -ENOMEM:
 		rpc_delay(task, HZ >> 2);
-		/* fall through */
+		fallthrough;
 	case -EAGAIN:	/* woken up; retry */
 		task->tk_action = call_retry_reserve;
 		return;
@@ -1759,13 +1759,13 @@ call_refreshresult(struct rpc_task *task)
 		/* Use rate-limiting and a max number of retries if refresh
 		 * had status 0 but failed to update the cred.
 		 */
-		/* fall through */
+		fallthrough;
 	case -ETIMEDOUT:
 		rpc_delay(task, 3*HZ);
-		/* fall through */
+		fallthrough;
 	case -EAGAIN:
 		status = -EACCES;
-		/* fall through */
+		fallthrough;
 	case -EKEYEXPIRED:
 		if (!task->tk_cred_retry)
 			break;
@@ -2132,7 +2132,7 @@ call_connect_status(struct rpc_task *task)
 			rpc_force_rebind(clnt);
 			goto out_retry;
 		}
-		/* fall through */
+		fallthrough;
 	case -ECONNRESET:
 	case -ECONNABORTED:
 	case -ENETDOWN:
@@ -2146,7 +2146,7 @@ call_connect_status(struct rpc_task *task)
 			break;
 		/* retry with existing socket, after a delay */
 		rpc_delay(task, 3*HZ);
-		/* fall through */
+		fallthrough;
 	case -EADDRINUSE:
 	case -ENOTCONN:
 	case -EAGAIN:
@@ -2228,7 +2228,7 @@ call_transmit_status(struct rpc_task *task)
 		 */
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
-		/* fall through */
+		fallthrough;
 	case -EBADSLT:
 	case -EAGAIN:
 		task->tk_action = call_transmit;
@@ -2247,7 +2247,7 @@ call_transmit_status(struct rpc_task *task)
 			rpc_call_rpcerror(task, task->tk_status);
 			return;
 		}
-		/* fall through */
+		fallthrough;
 	case -ECONNRESET:
 	case -ECONNABORTED:
 	case -EADDRINUSE:
@@ -2313,7 +2313,7 @@ call_bc_transmit_status(struct rpc_task *task)
 		break;
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
-		/* fall through */
+		fallthrough;
 	case -EBADSLT:
 	case -EAGAIN:
 		task->tk_status = 0;
@@ -2380,7 +2380,7 @@ call_status(struct rpc_task *task)
 		 * were a timeout.
 		 */
 		rpc_delay(task, 3*HZ);
-		/* fall through */
+		fallthrough;
 	case -ETIMEDOUT:
 		break;
 	case -ECONNREFUSED:
@@ -2391,7 +2391,7 @@ call_status(struct rpc_task *task)
 		break;
 	case -EADDRINUSE:
 		rpc_delay(task, 3*HZ);
-		/* fall through */
+		fallthrough;
 	case -EPIPE:
 	case -EAGAIN:
 		break;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 6ba9d5842629..5a8e47bbfb9f 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1623,7 +1623,7 @@ void xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	case -EAGAIN:
 		xprt_add_backlog(xprt, task);
 		dprintk("RPC:       waiting for request slot\n");
-		/* fall through */
+		fallthrough;
 	default:
 		task->tk_status = -EAGAIN;
 	}
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 75c646743df3..3f86d039875c 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -268,7 +268,7 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		pr_info("rpcrdma: removing device %s for %pISpc\n",
 			ep->re_id->device->name, sap);
-		/* fall through */
+		fallthrough;
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 		ep->re_connect_status = -ENODEV;
 		goto disconnected;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c57aef829403..554e1bb4c1c7 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -885,7 +885,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 	default:
 		dprintk("RPC:       sendmsg returned unrecognized error %d\n",
 			-status);
-		/* fall through */
+		fallthrough;
 	case -EPIPE:
 		xs_close(xprt);
 		status = -ENOTCONN;
@@ -1436,7 +1436,7 @@ static void xs_tcp_state_change(struct sock *sk)
 		xprt->connect_cookie++;
 		clear_bit(XPRT_CONNECTED, &xprt->state);
 		xs_run_error_worker(transport, XPRT_SOCK_WAKE_DISCONNECT);
-		/* fall through */
+		fallthrough;
 	case TCP_CLOSING:
 		/*
 		 * If the server closed down the connection, make sure that
@@ -2202,7 +2202,7 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 	switch (ret) {
 	case 0:
 		xs_set_srcport(transport, sock);
-		/* fall through */
+		fallthrough;
 	case -EINPROGRESS:
 		/* SYN_SENT! */
 		if (xprt->reestablish_timeout < XS_TCP_INIT_REEST_TO)
@@ -2255,7 +2255,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	default:
 		printk("%s: connect returned unhandled error %d\n",
 			__func__, status);
-		/* fall through */
+		fallthrough;
 	case -EADDRNOTAVAIL:
 		/* We're probably in TIME_WAIT. Get rid of existing socket,
 		 * and retry
-- 
2.19.1

