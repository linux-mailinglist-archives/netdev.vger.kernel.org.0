Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E5276579
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIXA5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgIXA5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:57:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BF0C0613CE;
        Wed, 23 Sep 2020 17:57:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f1so674560plo.13;
        Wed, 23 Sep 2020 17:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=3VrDWtatZfxTdzKYSOmqRvVjUsbi1PmxFqMeFPI99Jg=;
        b=vLpmGshJvJQr1RMp3xy5cUu4C9bc7nrooQIbuMwxVrLekNbuueIFsvT+z/YWsGT7Cv
         eLQulYM+BKeNyUesAGLXksMEXCoQKJ8wR6ZYR/SFfiHLF8QEdBq6g+K3guTu/YAmSHwt
         JepDZ21HWK2M83RZDYcCr4YbmOIoNtKl7bccbZZ8qX8hJqPXfxRSB9DJeC1GZiZXOAsK
         zhkpl+PGEbFYABn1wu+no+C6ggSd8fncTjUheSLK+HvCNffFz2oFrkTSioR+Q18iNdUN
         oZNelp/+fJYrLSn0lQkj6XaDSx5InFB1TuKrza3vsftfjBw5fxDIWSkf8Ffptq3fCP3k
         B9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=3VrDWtatZfxTdzKYSOmqRvVjUsbi1PmxFqMeFPI99Jg=;
        b=q0ebl1VMy1yqiZW8ynv78Fe2GxwmtykQN5RWX4Co30xUgS0uTQV84vnuDIkGhMYqvA
         RKcmAjvxATrAgOs9hAzv454+7Pysmjmjqjy/Hcc5bdjX3FuK2opBoJ8lEXCmSpxnEb5O
         HUdNlvPHDRbWmJiViLWpxmANl7oXNx1DwaSL4KlQArUpsCWkPKEoihlyegwUSYNVFw5Z
         HodWRVqlhqhxIIi9rOiFrqrRnZFbc1YFc1BnuZ62mkDkO5uO9LcOjJueDLICtow4amJx
         ZQyZbINDvmAIg0hE4ihaClt8Ogo/YEGaCqMXdFCCouL72K1+v6GruEY0pKDjEaSMWwXw
         es6A==
X-Gm-Message-State: AOAM533RYuD1mMdZ8yUNgSgGBq6xg+LPM0aEqNUY4dHLWrE/EOmVKR1G
        CItEQ0AELlcz5anp80lAjY0=
X-Google-Smtp-Source: ABdhPJxbZcx5iSndPyFMLVzx1MLiZP3Ff2mUoGDeMEfPtoIgu0QfaFK2kW6gk5/JpF47ovHdTuACTg==
X-Received: by 2002:a17:90a:d246:: with SMTP id o6mr1735537pjw.211.1600909021281;
        Wed, 23 Sep 2020 17:57:01 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id e19sm895986pgt.43.2020.09.23.17.56.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:57:00 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 11/16] mptcp: add mptcp_destroy_common helper
Date:   Thu, 24 Sep 2020 08:29:57 +0800
Message-Id: <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com> <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com> <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com> <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com> <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com> <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added a new helper named mptcp_destroy_common containing the
shared code between mptcp_destroy() and mptcp_sock_destruct().

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/protocol.c | 11 ++++++++---
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  4 +---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b53e55826975..34c037731f35 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2128,16 +2128,21 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	return newsk;
 }
 
+void mptcp_destroy_common(struct mptcp_sock *msk)
+{
+	skb_rbtree_purge(&msk->out_of_order_queue);
+	mptcp_token_destroy(msk);
+	mptcp_pm_free_anno_list(msk);
+}
+
 static void mptcp_destroy(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	skb_rbtree_purge(&msk->out_of_order_queue);
-	mptcp_token_destroy(msk);
 	if (msk->cached_ext)
 		__skb_ext_put(msk->cached_ext);
 
-	mptcp_pm_free_anno_list(msk);
+	mptcp_destroy_common(msk);
 	sk_sockets_allocated_dec(sk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index df6cc94df1f7..db1e5de2fee7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -408,6 +408,7 @@ bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq);
+void mptcp_destroy_common(struct mptcp_sock *msk);
 
 void __init mptcp_token_init(void);
 static inline void mptcp_token_init_request(struct request_sock *req)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a1fefc965e17..ac2b19993f1a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -435,9 +435,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 		sock_orphan(sk);
 	}
 
-	skb_rbtree_purge(&mptcp_sk(sk)->out_of_order_queue);
-	mptcp_token_destroy(mptcp_sk(sk));
-	mptcp_pm_free_anno_list(mptcp_sk(sk));
+	mptcp_destroy_common(mptcp_sk(sk));
 	inet_sock_destruct(sk);
 }
 
-- 
2.17.1

