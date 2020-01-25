Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427C914923C
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbgAYAET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:04:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:45732 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729367AbgAYAES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 19:04:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 16:04:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="251447334"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.22.36])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2020 16:04:18 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, edumazet@google.com
Subject: [PATCH net-next 2/2] mptcp: Fix code formatting
Date:   Fri, 24 Jan 2020 16:04:03 -0800
Message-Id: <20200125000403.251894-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
References: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch.pl had a few complaints in the last set of MPTCP patches:

ERROR: code indent should use tabs where possible
+^I         subflow, sk->sk_family, icsk->icsk_af_ops, target, mapped);$

CHECK: Comparison to NULL could be written "!new_ctx"
+	if (new_ctx == NULL) {

ERROR: "foo * bar" should be "foo *bar"
+static const struct proto_ops * tcp_proto_ops(struct sock *sk)

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 2 +-
 net/mptcp/subflow.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 41d49126d29a..39fdca79ce90 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -26,7 +26,7 @@
 
 static void __mptcp_close(struct sock *sk, long timeout);
 
-static const struct proto_ops * tcp_proto_ops(struct sock *sk)
+static const struct proto_ops *tcp_proto_ops(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8cfa1d29d59c..1662e1178949 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -592,7 +592,7 @@ void mptcp_handle_ipv6_mapped(struct sock *sk, bool mapped)
 	target = mapped ? &subflow_v6m_specific : subflow_default_af_ops(sk);
 
 	pr_debug("subflow=%p family=%d ops=%p target=%p mapped=%d",
-	         subflow, sk->sk_family, icsk->icsk_af_ops, target, mapped);
+		 subflow, sk->sk_family, icsk->icsk_af_ops, target, mapped);
 
 	if (likely(icsk->icsk_af_ops == target))
 		return;
@@ -773,7 +773,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	}
 
 	new_ctx = subflow_create_ctx(newsk, priority);
-	if (new_ctx == NULL) {
+	if (!new_ctx) {
 		subflow_ulp_fallback(newsk, old_ctx);
 		return;
 	}
-- 
2.25.0

