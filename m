Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E979C31C699
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhBPGot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhBPGoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 01:44:30 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EADDC06178A;
        Mon, 15 Feb 2021 22:43:01 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q186so6251464oig.12;
        Mon, 15 Feb 2021 22:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EELt/9En+krp5tdbLLUGrLl9x1Y0TKQm9+APsbeCR6E=;
        b=tGN368Wp2/3/JuFIMLx+3CUF8mGwFdg5qZgYVe/YKjQtCLn/s4ddXmhHTQp3EUvXiJ
         52eAkFDxgY0q6xq3C60Ic2LOtHNoIPQv1Kua6aBx5btb0773LuMnLpWqCgWXYkjOIMfe
         7yUZHaa2zQixhoecK7e87pWczVP0QOoF5UDhtQSVFQIxkOO6eCljZDwDDJzomiV9/ncx
         x6/X5GdGte8smYZV9ak81hOVWqDU75UkXc3G5F3bs4Y99+CPws13JaCyRN8V7fPnAjvk
         N8ubBe5E17rNuNW0pEznLlWDXW4GAH0IJYed5E62Xtn1UE0HawQRH3PrhlQGNzukd2JJ
         YOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EELt/9En+krp5tdbLLUGrLl9x1Y0TKQm9+APsbeCR6E=;
        b=Y30IJ1YFaGekQHqvGWpb0xykC278odKo2VcYWZmtclnRCSW22MdR2qtWKvjVXVGYaj
         wAhMCYKHqO9NaTdEMIoBC+RF+pllXqPkSJSJoABU2+DkW62v1iv4To4jZvooI/VePp1x
         VzmHcHREzQLuU+rCw+yekeyMjdowoZMd+zx35Pufu8XoohfkqupZYNHC6DNaIuD2sXs6
         rElYPPIZso4a4Z3x4VYBTh2EVB/mFZa+xsDsr7v4coyQsi6OLtHGyrwNyYpZRKz3sbnN
         MHhpRF8y3VGyVqg3iNcVwazErXKirVKkJJ0S2GnDuFyo6KuVT1vlCd+Vp3ttdfVLgF9p
         1hBA==
X-Gm-Message-State: AOAM533wR7PIfkvV9rY4hDeznhIEfAQl92fYK+mcXWahRht9VyNK8dPV
        Bf4fKcLcxhTw7+FvjpAu+X9QooUp+v0+7w==
X-Google-Smtp-Source: ABdhPJzWRwHueJiAqpM/JdaQMtt2j3ITKzMuTZzyVM+1nDRAp5Nbuh2cNcp3TnQ3A2rfP6+QRMjmOw==
X-Received: by 2002:aca:4ac1:: with SMTP id x184mr1703296oia.147.1613457780338;
        Mon, 15 Feb 2021 22:43:00 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id i23sm4274467oik.10.2021.02.15.22.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 22:43:00 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v4 5/5] sock_map: rename skb_parser and skb_verdict
Date:   Mon, 15 Feb 2021 22:42:50 -0800
Message-Id: <20210216064250.38331-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
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

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h                         |  8 +--
 net/core/skmsg.c                              | 14 ++---
 net/core/sock_map.c                           | 60 +++++++++----------
 .../selftests/bpf/prog_tests/sockmap_listen.c |  8 +--
 .../selftests/bpf/progs/test_sockmap_listen.c |  4 +-
 5 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index fc234d507fd7..ab3f3f2c426f 100644
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
@@ -447,8 +447,8 @@ static inline int psock_replace_prog(struct bpf_prog **pprog,
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
index 05b5af09ff42..dbb176427c14 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -690,9 +690,9 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
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
@@ -802,7 +802,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	int ret = __SK_PASS;
 
 	rcu_read_lock();
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		/* We skip full set_owner_r here because if we do a SK_PASS
 		 * or SK_DROP we can skip skb memory accounting and use the
@@ -894,7 +894,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		goto out;
 	}
 	skb_set_owner_r(skb, sk);
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
@@ -918,7 +918,7 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 	int ret = skb->len;
 
 	rcu_read_lock();
-	prog = READ_ONCE(psock->progs.skb_parser);
+	prog = READ_ONCE(psock->progs.stream_parser);
 	if (likely(prog)) {
 		skb->sk = psock->sk;
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -981,7 +981,7 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 void sk_psock_done_strp(struct sk_psock *psock)
 {
 	/* Parser has been stopped */
-	if (psock->progs.skb_parser)
+	if (psock->progs.stream_parser)
 		strp_done(&psock->strp);
 }
 #endif
@@ -1010,7 +1010,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		goto out;
 	}
 	skb_set_owner_r(skb, sk);
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index dbfcd7006338..69785070f02d 100644
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
 
@@ -1459,11 +1459,11 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
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

