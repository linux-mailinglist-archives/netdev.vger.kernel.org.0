Return-Path: <netdev+bounces-4490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A565B70D1DA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C2C1C20C22
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2155D6FA6;
	Tue, 23 May 2023 02:56:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F336ADC;
	Tue, 23 May 2023 02:56:25 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683C4CD;
	Mon, 22 May 2023 19:56:23 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d41d8bc63so2752737b3a.0;
        Mon, 22 May 2023 19:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810583; x=1687402583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYY6gCktLyS2evy87Xcih8x5aN4rar4oFOrscwwNY2s=;
        b=lZC/2SgJcMrs0jGe/tCzNuQn36XzL0xjCopwy2crblttCbMf0EYSFrztwwgZwG9dy0
         v7cjKoTQTBwjyXOwDXAZwLiJZiERvH9og582MRSQpNJg0ge9+mr2vCqXgVbURcFTYwat
         JdJUwL5Ae56UhoN4q8ArfyYdz8cHJ0hLSaoWmmIenVFe1+WQXbmn2WRbdj09BaHjhkfH
         874RQtWLmxlsUTUxGdKmhE2n+fVZOo6JHK7AqcG8g404AtA7BjpVnf2mlgDvH1wYXA7U
         In4zZiVCU0sckPePxkO7emaRM8cZ6kLyAsFU07rAF66m/oH2KLMuni2LNM9hCm6EWdTo
         dRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810583; x=1687402583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WYY6gCktLyS2evy87Xcih8x5aN4rar4oFOrscwwNY2s=;
        b=QokV6MlEvwavAWotGmIz73l5vB7/w4W+O//S6v5TGLwEC+REv8tKKrkpZ+dAjUM962
         6ac6VCKt6EhSHe4aUvCkbujWdc9J8fTMticQiuBYgn/dGhiZXNvPpm/9weTovPN7thv4
         bHBrvkBYWMas/O24t2a36Aa46MYnAg9zB/gTdeTAIL0L+zigEEKTrdd1Gq7nAy/KxHij
         eSOYQh5Mh5gYohSa3KhKEgPYhKyJLZlWJQWwkl1378mHB4JG/QdGhDB67l0loizrudbf
         YDk0mUxIVydxcRcRbREsFdY1w6Y/3j4Cvu59Bb27QDKWFR1OJfIVt2QY8fZfXUPrybqI
         iWtA==
X-Gm-Message-State: AC+VfDxPzG5wo1vuz3CPJXE4Td6999GGVSlAuK3HqyOAQtENM17dYvjz
	qaGzIwfnA93Crs7P9eNXnTQBG5iWLFw=
X-Google-Smtp-Source: ACHHUZ7ALlnpYpfhmdUufnqoRSewxcjYtitmRObweRuZZqY/7JnrqSnUFBSZpImg3W68sTmoKYZWhQ==
X-Received: by 2002:a17:902:d511:b0:1ab:7c4:eb24 with SMTP id b17-20020a170902d51100b001ab07c4eb24mr16548053plg.22.1684810582844;
        Mon, 22 May 2023 19:56:22 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:22 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v10 01/14] bpf: sockmap, pass skb ownership through read_skb
Date: Mon, 22 May 2023 19:56:05 -0700
Message-Id: <20230523025618.113937-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The read_skb hook calls consume_skb() now, but this means that if the
recv_actor program wants to use the skb it needs to inc the ref cnt
so that the consume_skb() doesn't kfree the sk_buff.

This is problematic because in some error cases under memory pressure
we may need to linearize the sk_buff from sk_psock_skb_ingress_enqueue().
Then we get this,

 skb_linearize()
   __pskb_pull_tail()
     pskb_expand_head()
       BUG_ON(skb_shared(skb))

Because we incremented users refcnt from sk_psock_verdict_recv() we
hit the bug on with refcnt > 1 and trip it.

To fix lets simply pass ownership of the sk_buff through the skb_read
call. Then we can drop the consume from read_skb handlers and assume
the verdict recv does any required kfree.

Bug found while testing in our CI which runs in VMs that hit memory
constraints rather regularly. William tested TCP read_skb handlers.

[  106.536188] ------------[ cut here ]------------
[  106.536197] kernel BUG at net/core/skbuff.c:1693!
[  106.536479] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  106.536726] CPU: 3 PID: 1495 Comm: curl Not tainted 5.19.0-rc5 #1
[  106.537023] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.16.0-1 04/01/2014
[  106.537467] RIP: 0010:pskb_expand_head+0x269/0x330
[  106.538585] RSP: 0018:ffffc90000138b68 EFLAGS: 00010202
[  106.538839] RAX: 000000000000003f RBX: ffff8881048940e8 RCX: 0000000000000a20
[  106.539186] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8881048940e8
[  106.539529] RBP: ffffc90000138be8 R08: 00000000e161fd1a R09: 0000000000000000
[  106.539877] R10: 0000000000000018 R11: 0000000000000000 R12: ffff8881048940e8
[  106.540222] R13: 0000000000000003 R14: 0000000000000000 R15: ffff8881048940e8
[  106.540568] FS:  00007f277dde9f00(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
[  106.540954] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.541227] CR2: 00007f277eeede64 CR3: 000000000ad3e000 CR4: 00000000000006e0
[  106.541569] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  106.541915] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  106.542255] Call Trace:
[  106.542383]  <IRQ>
[  106.542487]  __pskb_pull_tail+0x4b/0x3e0
[  106.542681]  skb_ensure_writable+0x85/0xa0
[  106.542882]  sk_skb_pull_data+0x18/0x20
[  106.543084]  bpf_prog_b517a65a242018b0_bpf_skskb_http_verdict+0x3a9/0x4aa9
[  106.543536]  ? migrate_disable+0x66/0x80
[  106.543871]  sk_psock_verdict_recv+0xe2/0x310
[  106.544258]  ? sk_psock_write_space+0x1f0/0x1f0
[  106.544561]  tcp_read_skb+0x7b/0x120
[  106.544740]  tcp_data_queue+0x904/0xee0
[  106.544931]  tcp_rcv_established+0x212/0x7c0
[  106.545142]  tcp_v4_do_rcv+0x174/0x2a0
[  106.545326]  tcp_v4_rcv+0xe70/0xf60
[  106.545500]  ip_protocol_deliver_rcu+0x48/0x290
[  106.545744]  ip_local_deliver_finish+0xa7/0x150

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Reported-by: William Findlay <will@isovalent.com>
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c                        | 2 --
 net/ipv4/tcp.c                          | 1 -
 net/ipv4/udp.c                          | 7 ++-----
 net/unix/af_unix.c                      | 7 ++-----
 net/vmw_vsock/virtio_transport_common.c | 5 +----
 5 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f81883759d38..4a3dc8d27295 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1183,8 +1183,6 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	int ret = __SK_DROP;
 	int len = skb->len;
 
-	skb_get(skb);
-
 	rcu_read_lock();
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a..e914e3446377 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1773,7 +1773,6 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
 		tcp_flags = TCP_SKB_CB(skb)->tcp_flags;
 		used = recv_actor(sk, skb);
-		consume_skb(skb);
 		if (used < 0) {
 			if (!copied)
 				copied = used;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa32afd871ee..9482def1f310 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1818,7 +1818,7 @@ EXPORT_SYMBOL(__skb_recv_udp);
 int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct sk_buff *skb;
-	int err, copied;
+	int err;
 
 try_again:
 	skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
@@ -1837,10 +1837,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	}
 
 	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
-	copied = recv_actor(sk, skb);
-	kfree_skb(skb);
-
-	return copied;
+	return recv_actor(sk, skb);
 }
 EXPORT_SYMBOL(udp_read_skb);
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cc695c9f09ec..e7728b57a8c7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2553,7 +2553,7 @@ static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb;
-	int err, copied;
+	int err;
 
 	mutex_lock(&u->iolock);
 	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
@@ -2561,10 +2561,7 @@ static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (!skb)
 		return err;
 
-	copied = recv_actor(sk, skb);
-	kfree_skb(skb);
-
-	return copied;
+	return recv_actor(sk, skb);
 }
 
 /*
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e4878551f140..b769fc258931 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1441,7 +1441,6 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	struct sock *sk = sk_vsock(vsk);
 	struct sk_buff *skb;
 	int off = 0;
-	int copied;
 	int err;
 
 	spin_lock_bh(&vvs->rx_lock);
@@ -1454,9 +1453,7 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	if (!skb)
 		return err;
 
-	copied = recv_actor(sk, skb);
-	kfree_skb(skb);
-	return copied;
+	return recv_actor(sk, skb);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
 
-- 
2.33.0


