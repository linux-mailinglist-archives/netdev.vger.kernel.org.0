Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C748027652B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIXAee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgIXAee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:34:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B7FC0613CE;
        Wed, 23 Sep 2020 17:34:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mn7so619961pjb.5;
        Wed, 23 Sep 2020 17:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jwJY9t7OliSFB0U6GDnxprcCnX6XVnxIKRMKuh9wJlw=;
        b=cP7H0eSLlRQkpf/xIelNn2PqyFBSdrPbsr0QmrUEmiFydRC8OO1D6svI1b81zpHZOP
         GjbuuqB5TvTUAdHpnLHAlOBgyeqOqYZAczyb1d1IH5pA2TDRSGD59xPBL/eWrEiIoUcB
         vZ/XW5xN6t1+Ribi3YOdRbFi0ppSBftqX/vliy4c9G6EuFycFyP2zmQi0uVl0N2SZFju
         DHcNLI4RzyU93RL9Ft0ZtiKo+LyOOTdNfhPuBmnoSBxQJuW3//JiEmMCw00zxorDFOza
         vNhVZThuaS31YMQEdF7/R09cXAu1pF80EJ/wr3i1GcmbIG5E1cLJiGyFTI+ozoA1tgbt
         N2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jwJY9t7OliSFB0U6GDnxprcCnX6XVnxIKRMKuh9wJlw=;
        b=DijbJgaiZGkk/Je840FepReIBThv25zRFRqxScnSxr5u8OZuwKJFYQoVqfSH+DNklv
         2pCBOXTEXpoeLylaKmShLByZFLYIeeh4S3EiXeHufxDPKrQY2BcIxagv4RKdqkZNHYJf
         bBxx6CNmbP3IVV+NEPdPEHAwFC9eCo07fI156puGFm5YF6YnMWF2bRGNAsGpwNxlOfe3
         5mX78YWMu1BHaT1aZN1nhYq/O3LqXer7odYFTrU6YOZI+yv77bxMKxvjTWcfrG8xT/JH
         m9gKl1aoHyYHMpzz9pAW8Qy8YfkE/WoqyVWBnl7CEm1iu17NDTygCW5mH/l4wbaxJ8ed
         R0/w==
X-Gm-Message-State: AOAM530xHcQqE3tT4Bow+H/Bnbh6hkKZ8imBaSWACZzvHLyE2N3uVWaP
        3pF7l5FbH8WRjiP+2YRpv5Q=
X-Google-Smtp-Source: ABdhPJwyLn4p45Re8sPvLgoWFqR9oyhktroVFR1hMRtPj0O7D5UTgfphkLbljRXEl8KdkofUV+9QPQ==
X-Received: by 2002:a17:90b:4b82:: with SMTP id lr2mr1635424pjb.184.1600907673922;
        Wed, 23 Sep 2020 17:34:33 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id gq14sm504787pjb.44.2020.09.23.17.34.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:34:32 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 01/16] mptcp: rename addr_signal and the related functions
Date:   Thu, 24 Sep 2020 08:29:47 +0800
Message-Id: <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renamed addr_signal and the related functions with the explicit
word "add".

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c  | 14 +++++++-------
 net/mptcp/pm.c       | 12 ++++++------
 net/mptcp/protocol.h | 10 +++++-----
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7fa822b55c34..ee0cb0546324 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -571,18 +571,18 @@ static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 }
 #endif
 
-static bool mptcp_established_options_addr(struct sock *sk,
-					   unsigned int *size,
-					   unsigned int remaining,
-					   struct mptcp_out_options *opts)
+static bool mptcp_established_options_add_addr(struct sock *sk,
+					       unsigned int *size,
+					       unsigned int remaining,
+					       struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct mptcp_addr_info saddr;
 	int len;
 
-	if (!mptcp_pm_should_signal(msk) ||
-	    !(mptcp_pm_addr_signal(msk, remaining, &saddr)))
+	if (!mptcp_pm_should_add_signal(msk) ||
+	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr)))
 		return false;
 
 	len = mptcp_add_addr_len(saddr.family);
@@ -640,7 +640,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 
 	*size += opt_size;
 	remaining -= opt_size;
-	if (mptcp_established_options_addr(sk, &opt_size, remaining, opts)) {
+	if (mptcp_established_options_add_addr(sk, &opt_size, remaining, opts)) {
 		*size += opt_size;
 		remaining -= opt_size;
 		ret = true;
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index a8ad20559aaa..ce12b8b26ad2 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -18,7 +18,7 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
 	msk->pm.local = *addr;
-	WRITE_ONCE(msk->pm.addr_signal, true);
+	WRITE_ONCE(msk->pm.add_addr_signal, true);
 	return 0;
 }
 
@@ -151,22 +151,22 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 /* path manager helpers */
 
-bool mptcp_pm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			  struct mptcp_addr_info *saddr)
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
+			      struct mptcp_addr_info *saddr)
 {
 	int ret = false;
 
 	spin_lock_bh(&msk->pm.lock);
 
 	/* double check after the lock is acquired */
-	if (!mptcp_pm_should_signal(msk))
+	if (!mptcp_pm_should_add_signal(msk))
 		goto out_unlock;
 
 	if (remaining < mptcp_add_addr_len(msk->pm.local.family))
 		goto out_unlock;
 
 	*saddr = msk->pm.local;
-	WRITE_ONCE(msk->pm.addr_signal, false);
+	WRITE_ONCE(msk->pm.add_addr_signal, false);
 	ret = true;
 
 out_unlock:
@@ -186,7 +186,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.local_addr_used = 0;
 	msk->pm.subflows = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
-	WRITE_ONCE(msk->pm.addr_signal, false);
+	WRITE_ONCE(msk->pm.add_addr_signal, false);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
 	msk->pm.status = 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 493bd2c13bc6..91adc9a19757 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -162,7 +162,7 @@ struct mptcp_pm_data {
 
 	spinlock_t	lock;		/*protects the whole PM data */
 
-	bool		addr_signal;
+	bool		add_addr_signal;
 	bool		server_side;
 	bool		work_pending;
 	bool		accept_addr;
@@ -438,9 +438,9 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 remote_id);
 
-static inline bool mptcp_pm_should_signal(struct mptcp_sock *msk)
+static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 {
-	return READ_ONCE(msk->pm.addr_signal);
+	return READ_ONCE(msk->pm.add_addr_signal);
 }
 
 static inline unsigned int mptcp_add_addr_len(int family)
@@ -450,8 +450,8 @@ static inline unsigned int mptcp_add_addr_len(int family)
 	return TCPOLEN_MPTCP_ADD_ADDR6;
 }
 
-bool mptcp_pm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			  struct mptcp_addr_info *saddr);
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
+			      struct mptcp_addr_info *saddr);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
-- 
2.17.1

