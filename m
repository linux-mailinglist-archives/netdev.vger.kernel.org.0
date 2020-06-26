Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E77B20AF72
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgFZKOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:14:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726553AbgFZKOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593166438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jK/UL9xbFXmK/e9pghgmI9RKuM/fEnAsV6toqDW6KYY=;
        b=gEvsSFlKw0/R5OLVSy86cLzi8JGtQN3HauM+FdXZXZnCKZxjp8Dre0vP1pUk09s6vqUZCw
        VQDB5kVg8zl0qBO01/DfLMsapbgEEXFM/kIsHTGC2BJbaAWvSAM43qVR42q40kuclxVxHX
        MueD+8SQfG6nY555jpRhEtTugfV1AvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-OS0fZky_NF-KNLnexJU4wA-1; Fri, 26 Jun 2020 06:13:56 -0400
X-MC-Unique: OS0fZky_NF-KNLnexJU4wA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 595F61005512;
        Fri, 26 Jun 2020 10:13:54 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 332D65D9C5;
        Fri, 26 Jun 2020 10:13:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/4] mptcp: add __init annotation on setup functions
Date:   Fri, 26 Jun 2020 12:12:46 +0200
Message-Id: <37cfccea23f199a5e11497a11373786b0f3e078a.1593159603.git.pabeni@redhat.com>
In-Reply-To: <cover.1593159603.git.pabeni@redhat.com>
References: <cover.1593159603.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing annotation in some setup-only
functions.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/pm.c         |  2 +-
 net/mptcp/pm_netlink.c |  2 +-
 net/mptcp/protocol.c   |  4 ++--
 net/mptcp/protocol.h   | 10 +++++-----
 net/mptcp/subflow.c    |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 977d9c8b1453..7de09fdd42a3 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -234,7 +234,7 @@ void mptcp_pm_close(struct mptcp_sock *msk)
 		sock_put((struct sock *)msk);
 }
 
-void mptcp_pm_init(void)
+void __init mptcp_pm_init(void)
 {
 	pm_wq = alloc_workqueue("pm_wq", WQ_UNBOUND | WQ_MEM_RECLAIM, 8);
 	if (!pm_wq)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b78edf237ba0..c8820c4156e6 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -851,7 +851,7 @@ static struct pernet_operations mptcp_pm_pernet_ops = {
 	.size = sizeof(struct pm_nl_pernet),
 };
 
-void mptcp_pm_nl_init(void)
+void __init mptcp_pm_nl_init(void)
 {
 	if (register_pernet_subsys(&mptcp_pm_pernet_ops) < 0)
 		panic("Failed to register MPTCP PM pernet subsystem.\n");
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3980fbb6f31e..9163a05b9e46 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2077,7 +2077,7 @@ static struct inet_protosw mptcp_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-void mptcp_proto_init(void)
+void __init mptcp_proto_init(void)
 {
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
 
@@ -2139,7 +2139,7 @@ static struct inet_protosw mptcp_v6_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-int mptcp_proto_v6_init(void)
+int __init mptcp_proto_v6_init(void)
 {
 	int err;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 482f53aed30a..571d39a1a17c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -337,7 +337,7 @@ mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
 
 int mptcp_is_enabled(struct net *net);
 bool mptcp_subflow_data_available(struct sock *sk);
-void mptcp_subflow_init(void);
+void __init mptcp_subflow_init(void);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, int ifindex,
@@ -355,9 +355,9 @@ static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
 }
 
-void mptcp_proto_init(void);
+void __init mptcp_proto_init(void);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-int mptcp_proto_v6_init(void);
+int __init mptcp_proto_v6_init(void);
 #endif
 
 struct sock *mptcp_sk_clone(const struct sock *sk,
@@ -394,7 +394,7 @@ static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
-void mptcp_pm_init(void);
+void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
 void mptcp_pm_close(struct mptcp_sock *msk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side);
@@ -428,7 +428,7 @@ bool mptcp_pm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			  struct mptcp_addr_info *saddr);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
-void mptcp_pm_nl_init(void);
+void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
 void mptcp_pm_nl_fully_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3838a0b3a21f..c2389ba2d4ee 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1255,7 +1255,7 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 	return 0;
 }
 
-void mptcp_subflow_init(void)
+void __init mptcp_subflow_init(void)
 {
 	subflow_request_sock_ops = tcp_request_sock_ops;
 	if (subflow_ops_init(&subflow_request_sock_ops) != 0)
-- 
2.26.2

