Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A372F5443D7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiFIGef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiFIGeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FFF2FFD8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso8656156pjk.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=66EdC7/JGy2H2xFnuQqp5vgFdI8PL+EsBB1vb5TBCso=;
        b=JT93uofFNR9zTsGDR9FhhpalfY0RofLtsLsn6RrilTSkhVQHCiHbEP34gNggdQHsuK
         JaBETh8IfrFjmPbqT9EhxaUbw3CjAHrbRuRAsd3igsHm3CxZh2s6vY9tJMjesz6EYcNb
         3a0AbVuQH05nxYHa4+eZyxqVXto491dVnOckd3wI4tGvI1DODQT9HSCY7gDkzf9kgc5Q
         aG8LLDNPrFjFV+YhUsmrQTMVIP7qOyB5zMsgqYC+2852c8LHtJp/DBlYMiR5rsKBo74u
         Yw4YThg97dqk+gezXWd+aza+M6WHdFSbNmySHwXR7SkUIiSaCXNNKChaT2U8hmzykkyk
         LWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66EdC7/JGy2H2xFnuQqp5vgFdI8PL+EsBB1vb5TBCso=;
        b=b62mUgpsZJ0R/QHtNDO/lAxyolCUVVzOnohyJnDS49SW8Skv5Kz3V6MwywLZSsNPZF
         S0fmko0jAyJoJg7xcHc+fOy07/NHVsAgNIbQ5mqAC3NNhgx3f0p1mUyXl+7odMjHzySH
         Gi2x6CbmG89+fzEnpsZXbshqO0JN7s9CEz76nnTN86JSPXGk1U/+pbnIU4+lcejUbkWj
         qc3O8yKx0fNML5L6+fR7b3oCLPObBak1Nv5rOsfx4rIwlk8Er3s+hSyMpwpYMmJdpFpk
         U/jwAoL5xHLC8/0K9R5GE6LtObpUVwSuBe2csCAceMqNsYYQJG5qOyClVXNJUeX7xfXv
         WPvQ==
X-Gm-Message-State: AOAM530GJBqsiuoIhIprK1mV8KASnOGNrh9DKDXEXCThW/5sHIHjepdH
        iBDqm2jauaMx9nvojbWq0UEWhujhl1A=
X-Google-Smtp-Source: ABdhPJxdwp+Q7Jbo95DhOyiX+Wo34gKz1fYIeyfsTxcN95WW76tn0wBM0RG36j3DSP95Ws1TRE3GFQ==
X-Received: by 2002:a17:90b:1a8d:b0:1e8:a809:af4b with SMTP id ng13-20020a17090b1a8d00b001e8a809af4bmr1931721pjb.76.1654756463872;
        Wed, 08 Jun 2022 23:34:23 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:23 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
Date:   Wed,  8 Jun 2022 23:34:09 -0700
Message-Id: <20220609063412.2205738-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We plan keeping sk->sk_forward_alloc as small as possible
in future patches.

This means we are going to call sk_memory_allocated_add()
and sk_memory_allocated_sub() more often.

Implement a per-cpu cache of +1/-1 MB, to reduce number
of changes to sk->sk_prot->memory_allocated, which
would otherwise be cause of false sharing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 825f8cbf791f02d798f17dd4f7a2659cebb0e98a..59040fee74e7de8d63fbf719f46e172906c134bb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1397,22 +1397,48 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	return !!*sk->sk_prot->memory_pressure;
 }
 
+static inline long
+proto_memory_allocated(const struct proto *prot)
+{
+	return max(0L, atomic_long_read(prot->memory_allocated));
+}
+
 static inline long
 sk_memory_allocated(const struct sock *sk)
 {
-	return atomic_long_read(sk->sk_prot->memory_allocated);
+	return proto_memory_allocated(sk->sk_prot);
 }
 
+/* 1 MB per cpu, in page units */
+#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
+
 static inline long
 sk_memory_allocated_add(struct sock *sk, int amt)
 {
-	return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
+	int local_reserve;
+
+	preempt_disable();
+	local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
+	if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
+		__this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
+		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
+	}
+	preempt_enable();
+	return sk_memory_allocated(sk);
 }
 
 static inline void
 sk_memory_allocated_sub(struct sock *sk, int amt)
 {
-	atomic_long_sub(amt, sk->sk_prot->memory_allocated);
+	int local_reserve;
+
+	preempt_disable();
+	local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
+	if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
+		__this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
+		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
+	}
+	preempt_enable();
 }
 
 #define SK_ALLOC_PERCPU_COUNTER_BATCH 16
@@ -1441,12 +1467,6 @@ proto_sockets_allocated_sum_positive(struct proto *prot)
 	return percpu_counter_sum_positive(prot->sockets_allocated);
 }
 
-static inline long
-proto_memory_allocated(struct proto *prot)
-{
-	return atomic_long_read(prot->memory_allocated);
-}
-
 static inline bool
 proto_memory_pressure(struct proto *prot)
 {
-- 
2.36.1.255.ge46751e96f-goog

