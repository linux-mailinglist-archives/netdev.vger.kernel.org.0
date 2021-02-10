Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312B7315D40
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhBJC1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhBJCZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:25:24 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C386BC06178A;
        Tue,  9 Feb 2021 18:22:02 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id u66so395857oig.9;
        Tue, 09 Feb 2021 18:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QlibuZ71felyDzaN3vHB7sIWy06/K7x+E7ndnNveynA=;
        b=dyy3zBpxcy+xePajt6kKapcxjsUWacBjRKpcZ5rwD3vN0bz6arnMJ6NIPWgzQvL5D2
         mqwCTIS6kI8OjuNS9eo38SI4cImuBD7kLrKaS5gMWAnquIYtfB5RLqUUUeI1P3qfmznV
         ze5CO0ocR7GaG8KpDzL+uZcREVw5ZJ2ntFo1ojQ228DpBU2TyJULRJkQKantTncS5Do9
         fBI7S6bLi6n3wxcT/DEhaCEhl2Ny/6q/TEK9pPo7baO3HApaU+700ty6bB8azwtQDljX
         CTadbWdIVdMfRUgsrL1NUWD5D/bXdyaFdirvOEk8mduqyz1oTbqF/VNB698JGFybNMn2
         9aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QlibuZ71felyDzaN3vHB7sIWy06/K7x+E7ndnNveynA=;
        b=LLZzztbAHPAsNP3JSalbrSM/GeekVnu1tNUzdpr5sxFeU/5wEf7otepmbgFR9X6ian
         IfAkSTXLsDFYicCBd4ubhSbreugRAcFFg6oKUGkAtMd+iJ+3Wkub3uTJRZZrMjBlPLHl
         NwKXZEyqFNBig586SRB+qQzTWf0eykgWj6uiFAZ8vC0SA6unHYqnn9JtzA3ns0HLHNbm
         9PojhE9kmrIXJzUmPOYGai+CJXPbzyxZ+8sZ4JUKCQnq2wRpltlone4PblSe1l7GwdnL
         SzdfnJeDMoOO7h6dV/eFrtZTAk1B+o6KnR7d04IOcDE41nvGsxa9W70H8kdSw7yFwSbG
         Y1zQ==
X-Gm-Message-State: AOAM531Y8/gsZqtRBKOav3mlskF7CQiEb1V+So4zPd969ugRzGwuYctd
        X0uilRRvmatfmLiH0WqOUsRttm+OBBaYHQ==
X-Google-Smtp-Source: ABdhPJyGd0gO1bhdJzG3MnjV/bc6UZAonuosyByjAS0446HRLQ2Lxm60PhetnTAResLkz0tpr/SNIA==
X-Received: by 2002:aca:cfd0:: with SMTP id f199mr597784oig.64.1612923722088;
        Tue, 09 Feb 2021 18:22:02 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:58b0:eb39:33aa:5355])
        by smtp.gmail.com with ESMTPSA id z20sm101051oth.55.2021.02.09.18.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 18:22:01 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 5/5] sock_map: rename skb_parser and skb_verdict
Date:   Tue,  9 Feb 2021 18:21:36 -0800
Message-Id: <20210210022136.146528-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

These two eBPF programs are tied to BPF_SK_SKB_STREAM_PARSER
and BPF_SK_SKB_STREAM_VERDICT, rename them to reflect the fact
they are only used for TCP. And save the name 'skb_verdict' for
general use later.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h                         |  8 +--
 net/core/skmsg.c                              | 14 ++---
 net/core/sock_map.c                           | 60 +++++++++----------
 .../selftests/bpf/prog_tests/sockmap_listen.c |  8 +--
 .../selftests/bpf/progs/test_sockmap_listen.c |  4 +-
 5 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 31546577ba06..e22e6e52fa42 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -56,8 +56,8 @@ struct sk_msg {
 
 struct sk_psock_progs {
 	struct bpf_prog			*msg_parser;
-	struct bpf_prog			*skb_parser;
-	struct bpf_prog			*skb_verdict;
+	struct bpf_prog			*stream_parser;
+	struct bpf_prog			*stream_verdict;
 };
 
 enum sk_psock_state_bits {
@@ -440,8 +440,8 @@ static inline int psock_replace_prog(struct bpf_prog **pprog,
 static inline void psock_progs_drop(struct sk_psock_progs *progs)
 {
 	psock_set_prog(&progs->msg_parser, NULL);
-	psock_set_prog(&progs->skb_parser, NULL);
-	psock_set_prog(&progs->skb_verdict, NULL);
+	psock_set_prog(&progs->stream_parser, NULL);
+	psock_set_prog(&progs->stream_verdict, NULL);
 }
 
 int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9a96e4a7d5d1..55b3dac31864 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -653,7 +653,7 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	/* No sk_callback_lock since already detached. */
 
 	/* Parser has been stopped */
-	if (psock->progs.skb_parser)
+	if (psock->progs.stream_parser)
 		strp_done(&psock->strp);
 
 	cancel_work_sync(&psock->work);
@@ -686,9 +686,9 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_psock_restore_proto(sk, psock);
 	rcu_assign_sk_user_data(sk, NULL);
-	if (psock->progs.skb_parser)
+	if (psock->progs.stream_parser)
 		sk_psock_stop_strp(sk, psock);
-	else if (psock->progs.skb_verdict)
+	else if (psock->progs.stream_verdict)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
@@ -801,7 +801,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		return __SK_DROP;
 
 	rcu_read_lock();
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		/* We skip full set_owner_r here because if we do a SK_PASS
 		 * or SK_DROP we can skip skb memory accounting and use the
@@ -895,7 +895,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -918,7 +918,7 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 	int ret = skb->len;
 
 	rcu_read_lock();
-	prog = READ_ONCE(psock->progs.skb_parser);
+	prog = READ_ONCE(psock->progs.stream_parser);
 	if (likely(prog)) {
 		skb->sk = psock->sk;
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -1009,7 +1009,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		goto out;
 	}
 
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e9f2a17fb665..0a4437f60041 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -148,9 +148,9 @@ static void sock_map_del_link(struct sock *sk,
 			struct bpf_map *map = link->map;
 			struct bpf_stab *stab = container_of(map, struct bpf_stab,
 							     map);
-			if (psock->saved_data_ready && stab->progs.skb_parser)
+			if (psock->saved_data_ready && stab->progs.stream_parser)
 				strp_stop = true;
-			if (psock->saved_data_ready && stab->progs.skb_verdict)
+			if (psock->saved_data_ready && stab->progs.stream_verdict)
 				verdict_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
@@ -224,23 +224,23 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 			 struct sock *sk)
 {
-	struct bpf_prog *msg_parser, *skb_parser, *skb_verdict;
+	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict;
 	struct sk_psock *psock;
 	int ret;
 
-	skb_verdict = READ_ONCE(progs->skb_verdict);
-	if (skb_verdict) {
-		skb_verdict = bpf_prog_inc_not_zero(skb_verdict);
-		if (IS_ERR(skb_verdict))
-			return PTR_ERR(skb_verdict);
+	stream_verdict = READ_ONCE(progs->stream_verdict);
+	if (stream_verdict) {
+		stream_verdict = bpf_prog_inc_not_zero(stream_verdict);
+		if (IS_ERR(stream_verdict))
+			return PTR_ERR(stream_verdict);
 	}
 
-	skb_parser = READ_ONCE(progs->skb_parser);
-	if (skb_parser) {
-		skb_parser = bpf_prog_inc_not_zero(skb_parser);
-		if (IS_ERR(skb_parser)) {
-			ret = PTR_ERR(skb_parser);
-			goto out_put_skb_verdict;
+	stream_parser = READ_ONCE(progs->stream_parser);
+	if (stream_parser) {
+		stream_parser = bpf_prog_inc_not_zero(stream_parser);
+		if (IS_ERR(stream_parser)) {
+			ret = PTR_ERR(stream_parser);
+			goto out_put_stream_verdict;
 		}
 	}
 
@@ -249,7 +249,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		msg_parser = bpf_prog_inc_not_zero(msg_parser);
 		if (IS_ERR(msg_parser)) {
 			ret = PTR_ERR(msg_parser);
-			goto out_put_skb_parser;
+			goto out_put_stream_parser;
 		}
 	}
 
@@ -261,8 +261,8 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 
 	if (psock) {
 		if ((msg_parser && READ_ONCE(psock->progs.msg_parser)) ||
-		    (skb_parser  && READ_ONCE(psock->progs.skb_parser)) ||
-		    (skb_verdict && READ_ONCE(psock->progs.skb_verdict))) {
+		    (stream_parser  && READ_ONCE(psock->progs.stream_parser)) ||
+		    (stream_verdict && READ_ONCE(psock->progs.stream_verdict))) {
 			sk_psock_put(sk, psock);
 			ret = -EBUSY;
 			goto out_progs;
@@ -283,15 +283,15 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		goto out_drop;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	if (skb_parser && skb_verdict && !psock->saved_data_ready) {
+	if (stream_parser && stream_verdict && !psock->saved_data_ready) {
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret)
 			goto out_unlock_drop;
-		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
-		psock_set_prog(&psock->progs.skb_parser, skb_parser);
+		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
+		psock_set_prog(&psock->progs.stream_parser, stream_parser);
 		sk_psock_start_strp(sk, psock);
-	} else if (!skb_parser && skb_verdict && !psock->saved_data_ready) {
-		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
+	} else if (!stream_parser && stream_verdict && !psock->saved_data_ready) {
+		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
 		sk_psock_start_verdict(sk,psock);
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -303,12 +303,12 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 out_progs:
 	if (msg_parser)
 		bpf_prog_put(msg_parser);
-out_put_skb_parser:
-	if (skb_parser)
-		bpf_prog_put(skb_parser);
-out_put_skb_verdict:
-	if (skb_verdict)
-		bpf_prog_put(skb_verdict);
+out_put_stream_parser:
+	if (stream_parser)
+		bpf_prog_put(stream_parser);
+out_put_stream_verdict:
+	if (stream_verdict)
+		bpf_prog_put(stream_verdict);
 	return ret;
 }
 
@@ -1463,11 +1463,11 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 		break;
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 	case BPF_SK_SKB_STREAM_PARSER:
-		pprog = &progs->skb_parser;
+		pprog = &progs->stream_parser;
 		break;
 #endif
 	case BPF_SK_SKB_STREAM_VERDICT:
-		pprog = &progs->skb_verdict;
+		pprog = &progs->stream_verdict;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index d7d65a700799..c26e6bf05e49 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1014,8 +1014,8 @@ static void test_skb_redir_to_connected(struct test_sockmap_listen *skel,
 					struct bpf_map *inner_map, int family,
 					int sotype)
 {
-	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
-	int parser = bpf_program__fd(skel->progs.prog_skb_parser);
+	int verdict = bpf_program__fd(skel->progs.prog_stream_verdict);
+	int parser = bpf_program__fd(skel->progs.prog_stream_parser);
 	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
 	int sock_map = bpf_map__fd(inner_map);
 	int err;
@@ -1125,8 +1125,8 @@ static void test_skb_redir_to_listening(struct test_sockmap_listen *skel,
 					struct bpf_map *inner_map, int family,
 					int sotype)
 {
-	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
-	int parser = bpf_program__fd(skel->progs.prog_skb_parser);
+	int verdict = bpf_program__fd(skel->progs.prog_stream_verdict);
+	int parser = bpf_program__fd(skel->progs.prog_stream_parser);
 	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
 	int sock_map = bpf_map__fd(inner_map);
 	int err;
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
index a3a366c57ce1..fa221141e9c1 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
@@ -31,13 +31,13 @@ struct {
 static volatile bool test_sockmap; /* toggled by user-space */
 
 SEC("sk_skb/stream_parser")
-int prog_skb_parser(struct __sk_buff *skb)
+int prog_stream_parser(struct __sk_buff *skb)
 {
 	return skb->len;
 }
 
 SEC("sk_skb/stream_verdict")
-int prog_skb_verdict(struct __sk_buff *skb)
+int prog_stream_verdict(struct __sk_buff *skb)
 {
 	unsigned int *count;
 	__u32 zero = 0;
-- 
2.25.1

