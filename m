Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBB730D274
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhBCESa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbhBCERl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:17:41 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B4C061786;
        Tue,  2 Feb 2021 20:17:00 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id w8so25386679oie.2;
        Tue, 02 Feb 2021 20:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Nog2NOlla9fFB2+XCVhJkcq2aHweemJtQThwh2rknc=;
        b=LJ93Olw3H8vzpCeEh52kogcl6MAUqT3hZJ/5xc66emGywBDmLbJetM5pc59oqC18S1
         qSRlt2ak5/ljhnMRUAbFN0I5y5MFOqYj6fJ6MoiaRzkL7iwH4xHIm8OMMhV/fITgViBL
         rc09iuNI+lfyZLkJy4A9sDpne0cFIdUZpwbLWFG0M0VcW4vktlwUfY7aFUp6Z88s9Kkw
         J6UeIGqAr2jZanD2rTeQpiTXO9T3MLpbCTs7PFV59XQvm1mAkhIgYi/tsUVDYovsbAzj
         fqCVZNON98khQXU/Ts2ZC8bUH3hwIBQ4Cci7dfFoFoC7i3ji7pzH6vcOQZuzaH0AH7hp
         OQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Nog2NOlla9fFB2+XCVhJkcq2aHweemJtQThwh2rknc=;
        b=Ih6dDDW60XmZ9gZbGc/Ff86n6GS1RZIX1LIYadIKwatVFVEAiZnrmbue9vYY2d2LRV
         DXb0RgUk3VB9pGcsO33P3Omi6qqzPAFUkQRrsbsdBKPsLzparAUJy0Y4CjraNEI5kjAU
         6WicMsXy2mc0mWwWmHQpAPd8zKznBYnuQnSyIWk7Xe6JBgMFldpeN8aNAnC69GhSDkwT
         Ss0mnhOBZp403XsC7UK5ao10LfSIzasEI2jzplH7XRO2lHTEJF1040dGijC8uh7eel3/
         nDePaIUxTDbrZWd/X8YLCWkjsHH3cEPmwBepVK73v/Abi1tp6KljlDURnktyE4btKh+y
         3TYw==
X-Gm-Message-State: AOAM533KQqJ5/r5n3kR77uxSPEOnurIRHcHUi4CrvuqVlzUxWHAmV5Qf
        8MuDXht7FNdra5VvQLREiu+4S+ZkDenwKA==
X-Google-Smtp-Source: ABdhPJxIRxRpag2bZDk3accj3WFyvY97GWd09VPbMdNPqBFzJk0WXmgeREjULu4opOUBOCsRQEtYDg==
X-Received: by 2002:aca:c704:: with SMTP id x4mr845814oif.24.1612325819717;
        Tue, 02 Feb 2021 20:16:59 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:16:59 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 04/19] sock_map: rename skb_parser and skb_verdict
Date:   Tue,  2 Feb 2021 20:16:21 -0800
Message-Id: <20210203041636.38555-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

These two ebpf programs are tied to BPF_SK_SKB_STREAM_PARSER
and BPF_SK_SKB_STREAM_VERDICT, rename them to reflect the fact
they are currently used for TCP. And save the generic name
skb_verdict for general use.

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
index e212b0d1ba35..218566ac4fa1 100644
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
@@ -426,8 +426,8 @@ static inline int psock_replace_prog(struct bpf_prog **pprog,
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
index 2b5b8f05187a..51446fe63be5 100644
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
@@ -807,7 +807,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		return __SK_DROP;
 
 	rcu_read_lock();
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		/* We skip full set_owner_r here because if we do a SK_PASS
 		 * or SK_DROP we can skip skb memory accounting and use the
@@ -883,7 +883,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -906,7 +906,7 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 	int ret = skb->len;
 
 	rcu_read_lock();
-	prog = READ_ONCE(psock->progs.skb_parser);
+	prog = READ_ONCE(psock->progs.stream_parser);
 	if (likely(prog)) {
 		skb->sk = psock->sk;
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -965,7 +965,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		goto out;
 	}
 
-	prog = READ_ONCE(psock->progs.skb_verdict);
+	prog = READ_ONCE(psock->progs.stream_verdict);
 	if (likely(prog)) {
 		skb_bpf_ext_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 7b70fa290836..521663582982 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -148,9 +148,9 @@ static void sock_map_del_link(struct sock *sk,
 			struct bpf_map *map = link->map;
 			struct bpf_stab *stab = container_of(map, struct bpf_stab,
 							     map);
-			if (psock->bpf_running && stab->progs.skb_parser)
+			if (psock->bpf_running && stab->progs.stream_parser)
 				strp_stop = true;
-			if (psock->bpf_running && stab->progs.skb_verdict)
+			if (psock->bpf_running && stab->progs.stream_verdict)
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
-	if (skb_parser && skb_verdict && !psock->bpf_running) {
+	if (stream_parser && stream_verdict && !psock->bpf_running) {
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret)
 			goto out_unlock_drop;
-		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
-		psock_set_prog(&psock->progs.skb_parser, skb_parser);
+		psock_set_prog(&psock->progs.stream_verdict, stream_verdict);
+		psock_set_prog(&psock->progs.stream_parser, stream_parser);
 		sk_psock_start_strp(sk, psock);
-	} else if (!skb_parser && skb_verdict && !psock->bpf_running) {
-		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
+	} else if (!stream_parser && stream_verdict && !psock->bpf_running) {
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
 
@@ -1462,10 +1462,10 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 		pprog = &progs->msg_parser;
 		break;
 	case BPF_SK_SKB_STREAM_PARSER:
-		pprog = &progs->skb_parser;
+		pprog = &progs->stream_parser;
 		break;
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

