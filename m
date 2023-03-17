Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8076BED74
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjCQP4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjCQP4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:56:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BDCD5A7E
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e11-20020a5b004b000000b00b37118ce5a7so5726002ybp.10
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jUfZ193GE05uLOqvWnwFJu4kepuDL/Ep0R0Kgh9ECe0=;
        b=VVC7kh4h4Dt9gdNHAZfDUwml8eTklUS65Ibq2R3quBqyfWSQMrAYHvHUQL0NR++TzU
         G0HH/rlhRmmSuFiTztAK62+Z1YnLlUFy/j2P7ID1aG3/U0HwmDhxbGkSBn8Qfla25Nwj
         Hh8h43dP2KMeuLXLG4H1IGnmHy+zIeQePkVRAwcyhX37wtyXtoyQ1SOl+WJS/O9nJj4p
         tcORjDZW94KFIT6RYtBlgSIykJ02dkMoEYEd7+x05oW6RMIOzpEjjX4wMhHXQciZxm4t
         TfgJ55PEXcbXTm7U9oFx6Frg1B9irSMu+kljhQi5yW9YwONBmCosGq7tsXOs3ah4+jrE
         Nt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUfZ193GE05uLOqvWnwFJu4kepuDL/Ep0R0Kgh9ECe0=;
        b=2UWOrj7q5QaCQYKWeGdktV/fbTiVzNW6+vnmkVXCSkxtCRKKVrwQ0diUenZ5oyozK9
         ESt7TaLFJo54F8+F/5q1FOH4IS73Cg8haYtngXkFArfibTJDL5vz9d59DDpd5PnHpvwA
         GTGEDokA5sMiLFfYOpVeX8xR+IGUqDRf9G7uyNXu4CHeJEmX3er7lI21nAPB7HCUJ6RJ
         lU1XuqddmhJBvoDXpyonP9jKe+Mx2RDc5jW8RMQI2a5a4oXIRnidmlAlxnoF67UeE20O
         RejCu3kvzv1TJYYo2EYmDmSF27PruzoPSUtCNgZiNbt6Dw8WAQd17325x69LUy/G92b5
         YMsA==
X-Gm-Message-State: AO0yUKVFHyesTgTM+IJNWtNlbnKDgmLVSQzLuuxyGBo9wybMHDJ1s0SQ
        o4hxbIFsS3VHW13tiOnu7g/XAMAp53Nxzw==
X-Google-Smtp-Source: AK7set+/EN6/+Y9+yEc45lmygOUb7/w81WMhVR7COMRMfgYeEQb4J24JygUQWUB3gnJpKUrTKT0B+zeN4UMH4Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:511:b0:b2e:f387:b428 with SMTP
 id x17-20020a056902051100b00b2ef387b428mr56631ybs.5.1679068555996; Fri, 17
 Mar 2023 08:55:55 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:38 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-10-edumazet@google.com>
Subject: [PATCH net-next 09/10] mptcp: preserve const qualifier in mptcp_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can change mptcp_sk() to propagate its argument const qualifier,
thanks to container_of_const().

We need to change few things to avoid build errors:

mptcp_set_datafin_timeout() and mptcp_rtx_head() have to accept
non-const sk pointers.

@msk local variable in mptcp_pending_tail() must be const.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 2 +-
 net/mptcp/protocol.h | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3005a5adf715e8d147c119b0b4c13fcc58fe99f6..8c6b6d2643311b1e30f681e2ae843350342ca6e6 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -459,7 +459,7 @@ static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
 	return false;
 }
 
-static void mptcp_set_datafin_timeout(const struct sock *sk)
+static void mptcp_set_datafin_timeout(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	u32 retransmits;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 61fd8eabfca2028680e04558b4baca9f48bbaaaa..4ed8ffffb1ca473179217e640a23bc268742628d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -333,10 +333,7 @@ static inline void msk_owned_by_me(const struct mptcp_sock *msk)
 	sock_owned_by_me((const struct sock *)msk);
 }
 
-static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
-{
-	return (struct mptcp_sock *)sk;
-}
+#define mptcp_sk(ptr) container_of_const(ptr, struct mptcp_sock, sk.icsk_inet.sk)
 
 /* the msk socket don't use the backlog, also account for the bulk
  * free memory
@@ -370,7 +367,7 @@ static inline struct mptcp_data_frag *mptcp_send_next(struct sock *sk)
 
 static inline struct mptcp_data_frag *mptcp_pending_tail(const struct sock *sk)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
+	const struct mptcp_sock *msk = mptcp_sk(sk);
 
 	if (!msk->first_pending)
 		return NULL;
@@ -381,7 +378,7 @@ static inline struct mptcp_data_frag *mptcp_pending_tail(const struct sock *sk)
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
-static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
+static inline struct mptcp_data_frag *mptcp_rtx_head(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-- 
2.40.0.rc2.332.ga46443480c-goog

