Return-Path: <netdev+bounces-10932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC36730B59
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12C8028115F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861CE1ACC9;
	Wed, 14 Jun 2023 23:11:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732011ACA2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:11:24 +0000 (UTC)
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F82715
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:56 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f769c37d26so1568175e87.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784227; x=1689376227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gq3+23upRKD5uMZN30YbyseaUz2qJh28nrfHnPjZvEE=;
        b=bc18+aW7qX/yHBJcnO/+SvuF5tymxFnxONUPVcnEBvLldoAT03I7jheaAxtL3l9QO+
         Wr9JRZlREi5irINBxe6iFBt5au70J4/3aa3dZ1HNbFAr0AnkAMBCVW9bNu83wSNq+02h
         zHwpw9ohavvGq66TT9qjSX32bdFGdLAgCnPOohZzYlMuW+fjPCI/4TI6OW/1qRM6R/YX
         aGSFP4Wyem3fHYpIa9AcrO48ZxnWvYod5oBVg/Y1aZGmqVXzFAdoV9PbTZSS1SVZhali
         lcY7h+vPvc9vP63HiNQnbEvJ17QtuIgobQJcypJCb+QtKkEG3TdCZSl4iTVJRvqsbRcI
         yS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784227; x=1689376227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gq3+23upRKD5uMZN30YbyseaUz2qJh28nrfHnPjZvEE=;
        b=GQWnw6AnmV2MWX29Zkm+Rnao3NBPi+A+a8QQ2knIhr7xq/SsnKMad/a+UyOoC5m9lV
         b3S8S65A7PRMjs4vZN3me7tRdDrX6tZQ3KaTd3SvA0yZmmlE3Fc4ZnKALJi9RJD1mR/K
         79WfL2H/gyQTiKQtDLyoF3+1o1fB0tVwSvdWlrA5EzEJ8+DC2bIqukYVNP6PLwMGryiq
         rpw/EXPh5Se3V1j0bVX0T9oFE/uZx+kbIP+IVXomA6OOZhuXRPrj659zwSFnd1tcuNQH
         D87Xzxu8eFEbt7r0y8YGvy2rBsBq+sZm+z0NI9B2c2+fwuNgYTKEQ6MLntpEqTlS/sQo
         bVvQ==
X-Gm-Message-State: AC+VfDyiOxhpsbdm9ksEp5JuC+IcXc6+KYL8rc+w5hWAGiAuDpqBgzJA
	Wa1KboON1lJelc2A8n/qZmja6g==
X-Google-Smtp-Source: ACHHUZ4a3zgaSmXIeeSJkx6+G0CkA1DDa0mVLI9eMVXKc0IJYGHJEEDaJJ8SuAS6OeVOYMo4vP9x/g==
X-Received: by 2002:a05:6512:3283:b0:4f7:5fa3:8b37 with SMTP id p3-20020a056512328300b004f75fa38b37mr3550662lfe.32.1686784226800;
        Wed, 14 Jun 2023 16:10:26 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:26 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v7 20/22] net/tcp: Add static_key for TCP-AO
Date: Thu, 15 Jun 2023 00:09:45 +0100
Message-Id: <20230614230947.3954084-21-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614230947.3954084-1-dima@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Similarly to TCP-MD5, add a static key to TCP-AO that is patched out
when there are no keys on a machine and dynamically enabled with the
first setsockopt(TCP_AO) adds a key on any socket. The static key is as
well dynamically disabled later when the socket is destructed.

The lifetime of enabled static key here is the same as ao_info: it is
enabled on allocation, passed over from full socket to twsk and
destructed when ao_info is scheduled for destruction.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h    |  3 +++
 include/net/tcp_ao.h |  2 ++
 net/ipv4/tcp_ao.c    | 23 +++++++++++++++++++++++
 net/ipv4/tcp_input.c | 42 ++++++++++++++++++++++++++++--------------
 4 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1d3cf13ae66b..6060513ab83d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2585,6 +2585,9 @@ static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
 	struct tcp_ao_info *ao_info;
 	struct tcp_ao_key *ao_key;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return false;
+
 	ao_info = rcu_dereference_check(tcp_sk(sk)->ao_info,
 					lockdep_sock_is_held(sk));
 	if (!ao_info)
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 49402458b69d..714a46e30f3f 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -138,6 +138,8 @@ do {									\
 
 #ifdef CONFIG_TCP_AO
 /* TCP-AO structures and functions */
+#include <linux/jump_label.h>
+extern struct static_key_false_deferred tcp_ao_needed;
 
 struct tcp4_ao_context {
 	__be32		saddr;
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 3799432a386a..2c4a31d8f177 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -17,6 +17,9 @@
 #include <net/ipv6.h>
 #include <net/icmp.h>
 
+DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_ao_needed, HZ);
+EXPORT_SYMBOL_GPL(tcp_ao_needed);
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
@@ -198,6 +204,9 @@ static struct tcp_ao_key *__tcp_ao_do_lookup(const struct sock *sk,
 	struct tcp_ao_key *key;
 	struct tcp_ao_info *ao;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return NULL;
+
 	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
 				   lockdep_sock_is_held(sk));
 	if (!ao)
@@ -292,6 +301,7 @@ void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 	}
 
 	kfree_rcu(ao, rcu);
+	static_branch_slow_dec_deferred(&tcp_ao_needed);
 }
 
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp)
@@ -1107,6 +1117,11 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 		goto free_and_exit;
 	}
 
+	if (!static_key_fast_inc_not_disabled(&tcp_ao_needed.key.key)) {
+		ret = -EUSERS;
+		goto free_and_exit;
+	}
+
 	key_head = rcu_dereference(hlist_first_rcu(&new_ao->head));
 	first_key = hlist_entry_safe(key_head, struct tcp_ao_key, node);
 
@@ -1523,6 +1538,10 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 
 	tcp_ao_link_mkt(ao_info, key);
 	if (first) {
+		if (!static_branch_inc(&tcp_ao_needed.key)) {
+			ret = -EUSERS;
+			goto err_free_sock;
+		}
 		sk_gso_disable(sk);
 		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
 	}
@@ -1788,6 +1807,10 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 	if (new_rnext)
 		WRITE_ONCE(ao_info->rnext_key, new_rnext);
 	if (first) {
+		if (!static_branch_inc(&tcp_ao_needed.key)) {
+			err = -EUSERS;
+			goto out;
+		}
 		sk_gso_disable(sk);
 		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index eed3f7631b4b..c0c18b05fd1c 100644
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
2.40.0


