Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6D69838B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjBOSgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjBOSfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:35:43 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9793E09E
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:20 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id z13so14022400wmp.2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1FPQF1rXG4A/jQd/fcwDAUZHBiYXUCKbXLzG2fc0O0=;
        b=Et7AtUUbRO/Xw7WCuAirQIo9xegKW/u1xg1kzH6wy61oO+XbTefzV3XE5gahI+FJa0
         w9ylBEopCWZwXrnML1c0eD3oEwIYTxq6vM5gM8N21hHWhyuCUmvAiC2JHZB9tr20sDgm
         9vONNF8OaMv3eTyTp1Bk4PeUwzPBGraCjCzOurVCojhpptwW5hwCEej1ofP2g+00Dns4
         sevoLJZSCCRzlGSg6M60JGihs8ek5MXcs4qdp42IXBI7fQbmh0F8QhB1n4q4JBBU0sEm
         9DVPoN20n7gTaBdqhEUyunZHmpN7kCbeRL111YjBghHwJQQljipU4w6837yRXQHEo054
         TpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1FPQF1rXG4A/jQd/fcwDAUZHBiYXUCKbXLzG2fc0O0=;
        b=zPGeHIy50u7ySEEyXw1jpDEGXSoSb04DDLITClbkdxphfAmYTDc6HODrg6keUK1f+V
         e/ZBR/0ZqStUFA5HPVQlkyeBkJ3JYFEmGNgk43BLHJaeFLDx5tRSw3RGqF4PB6/SApfZ
         OwcFGPind4Wy1szdojBksnO1l89ViqIMRuYpy1yaunrQG9u5kO7KbHl+IyfmjeskhahV
         KP2d0Lboe8IwMcjmQu9S+0A/9IeDGS8zBojmiLs6LLt/SWWQvUWb5zlhlddM9EfBZfTW
         JPxfxMNJR6XaR4o77B/JyzcSI5xK/Vvn9pp1ypU7of0cix92T9LtCJqtdkPAd8/ic8+X
         1cLg==
X-Gm-Message-State: AO0yUKUIKULWqU7TxJl9cVzGKbww2rFJ3CCxDFVwBtiZtvTaEcMvE1AT
        yHdBbKTTDTLPHy9IY7Jh0cloWQ==
X-Google-Smtp-Source: AK7set93rTIM8qwwjULLBamnBHxDqE2tF5W14lVEubw1JuOeFBC7NA3ID38FUydivAcdzfZAL/Dlyw==
X-Received: by 2002:a05:600c:5024:b0:3df:fcbd:3159 with SMTP id n36-20020a05600c502400b003dffcbd3159mr2597578wmr.3.1676486059627;
        Wed, 15 Feb 2023 10:34:19 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:18 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH v4 20/21] net/tcp-ao: Add static_key for TCP-AO
Date:   Wed, 15 Feb 2023 18:33:34 +0000
Message-Id: <20230215183335.800122-21-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to TCP-MD5, add a static key to TCP-AO that is patched out
when there are no keys on a machine and dynamically enabled with the
first setsockopt(TCP_AO) adds a key on any socket. The static key is as
well dynamically disabled later when the socket is destructed.

The lifetime of enabled static key here is the same as ao_info: it is
enabled on allocation, passed over from full socket to twsk and
destructed when ao_info is scheduled for destruction.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |  2 ++
 net/ipv4/tcp_ao.c    | 17 +++++++++++++++++
 net/ipv4/tcp_input.c | 42 ++++++++++++++++++++++++++++--------------
 3 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 04e3bcee05f7..253cf2719aed 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -131,6 +131,8 @@ do {									\
 
 #ifdef CONFIG_TCP_AO
 /* TCP-AO structures and functions */
+#include <linux/jump_label.h>
+extern struct static_key_false_deferred tcp_ao_needed;
 
 struct tcp4_ao_context {
 	__be32		saddr;
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 2c38e991ecbd..adb25e42f64a 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -17,6 +17,9 @@
 #include <net/ipv6.h>
 #include <net/icmp.h>
 
+DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_ao_needed, HZ);
+EXPORT_SYMBOL(tcp_ao_needed);
+
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len)
 {
@@ -58,6 +61,9 @@ bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
 	struct tcp_ao_info *ao;
 	bool ignore_icmp = false;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return false;
+
 	/* RFC5925, 7.8:
 	 * >> A TCP-AO implementation MUST default to ignore incoming ICMPv4
 	 * messages of Type 3 (destination unreachable), Codes 2-4 (protocol
@@ -196,6 +202,9 @@ struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 	struct tcp_ao_key *key;
 	struct tcp_ao_info *ao;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return NULL;
+
 	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
 				   lockdep_sock_is_held(sk));
 	if (!ao)
@@ -283,6 +292,7 @@ void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 	}
 
 	kfree_rcu(ao, rcu);
+	static_branch_slow_dec_deferred(&tcp_ao_needed);
 }
 
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp)
@@ -1052,6 +1062,11 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 		goto free_and_exit;
 	}
 
+	if (!static_key_fast_inc_not_disabled(&tcp_ao_needed.key.key)) {
+		ret = -EUSERS;
+		goto free_and_exit;
+	}
+
 	key_head = rcu_dereference(hlist_first_rcu(&new_ao->head));
 	first_key = hlist_entry_safe(key_head, struct tcp_ao_key, node);
 
@@ -1607,6 +1622,8 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 
 	tcp_ao_link_mkt(ao_info, key);
 	if (first) {
+		if (!static_branch_inc(&tcp_ao_needed.key))
+			goto err_free_sock;
 		sk_gso_disable(sk);
 		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9f23cab1e835..dd9ff507bbc9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3524,17 +3524,14 @@ static inline bool tcp_may_update_window(const struct tcp_sock *tp,
 		(ack_seq == tp->snd_wl1 && nwin > tp->snd_wnd);
 }
 
-/* If we update tp->snd_una, also update tp->bytes_acked */
-static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
+static void tcp_snd_sne_update(struct tcp_sock *tp, u32 ack)
 {
-	u32 delta = ack - tp->snd_una;
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao;
-#endif
 
-	sock_owned_by_me((struct sock *)tp);
-	tp->bytes_acked += delta;
-#ifdef CONFIG_TCP_AO
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return;
+
 	ao = rcu_dereference_protected(tp->ao_info,
 				       lockdep_sock_is_held((struct sock *)tp));
 	if (ao) {
@@ -3543,20 +3540,27 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 		ao->snd_sne_seq = ack;
 	}
 #endif
+}
+
+/* If we update tp->snd_una, also update tp->bytes_acked */
+static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
+{
+	u32 delta = ack - tp->snd_una;
+
+	sock_owned_by_me((struct sock *)tp);
+	tp->bytes_acked += delta;
+	tcp_snd_sne_update(tp, ack);
 	tp->snd_una = ack;
 }
 
-/* If we update tp->rcv_nxt, also update tp->bytes_received */
-static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
+static void tcp_rcv_sne_update(struct tcp_sock *tp, u32 seq)
 {
-	u32 delta = seq - tp->rcv_nxt;
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao;
-#endif
 
-	sock_owned_by_me((struct sock *)tp);
-	tp->bytes_received += delta;
-#ifdef CONFIG_TCP_AO
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return;
+
 	ao = rcu_dereference_protected(tp->ao_info,
 				       lockdep_sock_is_held((struct sock *)tp));
 	if (ao) {
@@ -3565,6 +3569,16 @@ static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 		ao->rcv_sne_seq = seq;
 	}
 #endif
+}
+
+/* If we update tp->rcv_nxt, also update tp->bytes_received */
+static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
+{
+	u32 delta = seq - tp->rcv_nxt;
+
+	sock_owned_by_me((struct sock *)tp);
+	tp->bytes_received += delta;
+	tcp_rcv_sne_update(tp, seq);
 	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
-- 
2.39.1

