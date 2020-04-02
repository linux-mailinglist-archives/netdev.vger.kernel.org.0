Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE8919C05E
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388057AbgDBLpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:45:20 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44690 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDBLpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:45:20 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jJyHd-0002jH-VF; Thu, 02 Apr 2020 13:45:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 4/4] mptcp: fix "fn parameter not described" warnings
Date:   Thu,  2 Apr 2020 13:44:54 +0200
Message-Id: <20200402114454.8533-5-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402114454.8533-1-fw@strlen.de>
References: <20200402114454.8533-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Obtained with:

  $ make W=1 net/mptcp/token.o
  net/mptcp/token.c:53: warning: Function parameter or member 'req' not described in 'mptcp_token_new_request'
  net/mptcp/token.c:98: warning: Function parameter or member 'sk' not described in 'mptcp_token_new_connect'
  net/mptcp/token.c:133: warning: Function parameter or member 'conn' not described in 'mptcp_token_new_accept'
  net/mptcp/token.c:178: warning: Function parameter or member 'token' not described in 'mptcp_token_destroy_request'
  net/mptcp/token.c:191: warning: Function parameter or member 'token' not described in 'mptcp_token_destroy'

Fixes: 79c0949e9a09 (mptcp: Add key generation and token tree)
Fixes: 58b09919626b (mptcp: create msk early)
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/token.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 129a5ad1bc35..33352dd99d4d 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -40,7 +40,7 @@ static int token_used __read_mostly;
 
 /**
  * mptcp_token_new_request - create new key/idsn/token for subflow_request
- * @req - the request socket
+ * @req: the request socket
  *
  * This function is called when a new mptcp connection is coming in.
  *
@@ -80,7 +80,7 @@ int mptcp_token_new_request(struct request_sock *req)
 
 /**
  * mptcp_token_new_connect - create new key/idsn/token for subflow
- * @sk - the socket that will initiate a connection
+ * @sk: the socket that will initiate a connection
  *
  * This function is called when a new outgoing mptcp connection is
  * initiated.
@@ -125,6 +125,7 @@ int mptcp_token_new_connect(struct sock *sk)
 /**
  * mptcp_token_new_accept - insert token for later processing
  * @token: the token to insert to the tree
+ * @conn: the just cloned socket linked to the new connection
  *
  * Called when a SYN packet creates a new logical connection, i.e.
  * is not a join request.
@@ -169,7 +170,7 @@ struct mptcp_sock *mptcp_token_get_sock(u32 token)
 
 /**
  * mptcp_token_destroy_request - remove mptcp connection/token
- * @token - token of mptcp connection to remove
+ * @token: token of mptcp connection to remove
  *
  * Remove not-yet-fully-established incoming connection identified
  * by @token.
@@ -183,7 +184,7 @@ void mptcp_token_destroy_request(u32 token)
 
 /**
  * mptcp_token_destroy - remove mptcp connection/token
- * @token - token of mptcp connection to remove
+ * @token: token of mptcp connection to remove
  *
  * Remove the connection identified by @token.
  */
-- 
2.24.1

