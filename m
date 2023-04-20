Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D30B6E9C6A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 21:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjDTTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 15:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjDTTV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 15:21:26 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FC7468A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:21:21 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-5ef6e0f9d5aso10298626d6.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682018480; x=1684610480;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9npk5YQDBCNlXjsgQNwQMdnv2HADGt2porgvPQiGRo=;
        b=VQPAzX8XXS1tIKrBskYQRNP9EMhO64Foaer4Uvs/jA8T1XhEjGZr46zlpz8PLsIRGo
         dbHZdpZYaoLqRYYsNlsIq11DvA0nDgv21Xtkl8QTH/p5IDGn58hdWSOKn1Any+opnzeh
         t2Dd8Da3vUMqcatuL9Xcn661vP/OlwZPZczAgRQTqUDu50aSHNOofUgQxfxWvwNlYDN+
         bvYdM/g6SfeKs3ponhukhqml/FU577sVWW6JxqxPZcCU0SffgHWqxtntzG+bVHtwMdqm
         DOC69iEfS7iN4BOBuAlyTdulQmoIxVYJX9U0Xr3Hy3zoNwmlI+y6EiYl0Hro6GPm5pG6
         pX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682018480; x=1684610480;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m9npk5YQDBCNlXjsgQNwQMdnv2HADGt2porgvPQiGRo=;
        b=F8H5gD4X2QGtofvbOnFOEr8wiXyJ2J23UX6NzuqucQZ/StPmNfa3vMa9MVa0VTNgMt
         1S8FHWQYmAfiPmnh+yKHvZn5rfvsVQ5C6UtF818+2C1domAam6yibFVJxy512hfEW1GR
         uM0yf9ibPPGTLtmYHVK8+LNngo7xd0k6AKhmFZLTe2uQBOThNjzcLnpN/TFH8RplXaCV
         4ucyXQS7WjdFld7r1yPNXuNRdiaVdNjuhM/J/nr2CqzbXszD7yb+VcunukaITgG5lVsM
         hn5UKJVGOHjN8PDGOJIHYQJiU4PDbp8p6zyEF1oi8gwD1j1GwecZsncQbV4mOEg/iX7L
         nosg==
X-Gm-Message-State: AAQBX9fzu4l1uXqpVtaXGaGdI7tqeTkypMmjt8iu5AfKcvX3XuJk8W7R
        Nc1GVu9nMiFUEWdeoXHxfek=
X-Google-Smtp-Source: AKy350bm3+riQ3lplXD4QZG6PQdKTf8lDxA2+thqbB3DSqo2w0LGMJo0ZBYlbk2MsM3QMjt6HUV7aw==
X-Received: by 2002:a05:6214:1c8d:b0:5ef:4655:192e with SMTP id ib13-20020a0562141c8d00b005ef4655192emr3001267qvb.36.1682018480348;
        Thu, 20 Apr 2023 12:21:20 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id t11-20020a0cde0b000000b005dd8b934579sm597684qvk.17.2023.04.20.12.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 12:21:19 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:21:19 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Message-ID: <644190af7652e_5eb3529467@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230420180434.10861-1-kuniyu@amazon.com>
References: <20230420180434.10861-1-kuniyu@amazon.com>
Subject: RE: [PATCH v3 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kuniyuki Iwashima wrote:
> syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> skbs.  We can reproduce the problem with these sequences:
> 
>   sk = socket(AF_INET, SOCK_DGRAM, 0)
>   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
>   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
>   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
>   sk.close()
> 
> sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> the socket's error queue with the TX timestamp.
> 
> When the original skb is received locally, skb_copy_ubufs() calls
> skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> This additional count is decremented while freeing the skb, but struct
> ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> not called.
> 
> The last refcnt is not released unless we retrieve the TX timestamped
> skb by recvmsg().  Since we clear the error queue in inet_sock_destruct()
> after the socket's refcnt reaches 0, there is a circular dependency.
> If we close() the socket holding such skbs, we never call sock_put()
> and leak the count, sk, and skb.
> 
> TCP has the same problem, and commit e0c8bccd40fc ("net: stream:
> purge sk_error_queue in sk_stream_kill_queues()") tried to fix it
> by calling skb_queue_purge() during close().  However, there is a
> small chance that skb queued in a qdisc or device could be put
> into the error queue after the skb_queue_purge() call.

I'd remove this part. If there is an issue in TCP, it is a separate
issue and deserves a separate patch.

The UDP part looks great to me. Thanks for fixing that.

> In __skb_tstamp_tx(), the cloned skb should not have a reference
> to the ubuf to remove the circular dependency, but skb_clone() does
> not call skb_copy_ubufs() for zerocopy skb.  So, we need to call
> skb_orphan_frags_rx() for the cloned skb to call skb_copy_ubufs().
>
> [0]:
> BUG: memory leak
> unreferenced object 0xffff88800c6d2d00 (size 1152):
>   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 cd af e8 81 00 00 00 00  ................
>     02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
>   backtrace:
>     [<0000000055636812>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:2024
>     [<0000000054d77b7a>] sk_alloc+0x3b/0x800 net/core/sock.c:2083
>     [<0000000066f3c7e0>] inet_create net/ipv4/af_inet.c:319 [inline]
>     [<0000000066f3c7e0>] inet_create+0x31e/0xe40 net/ipv4/af_inet.c:245
>     [<000000009b83af97>] __sock_create+0x2ab/0x550 net/socket.c:1515
>     [<00000000b9b11231>] sock_create net/socket.c:1566 [inline]
>     [<00000000b9b11231>] __sys_socket_create net/socket.c:1603 [inline]
>     [<00000000b9b11231>] __sys_socket_create net/socket.c:1588 [inline]
>     [<00000000b9b11231>] __sys_socket+0x138/0x250 net/socket.c:1636
>     [<000000004fb45142>] __do_sys_socket net/socket.c:1649 [inline]
>     [<000000004fb45142>] __se_sys_socket net/socket.c:1647 [inline]
>     [<000000004fb45142>] __x64_sys_socket+0x73/0xb0 net/socket.c:1647
>     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff888017633a00 (size 240):
>   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 2d 6d 0c 80 88 ff ff  .........-m.....
>   backtrace:
>     [<000000002b1c4368>] __alloc_skb+0x229/0x320 net/core/skbuff.c:497
>     [<00000000143579a6>] alloc_skb include/linux/skbuff.h:1265 [inline]
>     [<00000000143579a6>] sock_omalloc+0xaa/0x190 net/core/sock.c:2596
>     [<00000000be626478>] msg_zerocopy_alloc net/core/skbuff.c:1294 [inline]
>     [<00000000be626478>] msg_zerocopy_realloc+0x1ce/0x7f0 net/core/skbuff.c:1370
>     [<00000000cbfc9870>] __ip_append_data+0x2adf/0x3b30 net/ipv4/ip_output.c:1037
>     [<0000000089869146>] ip_make_skb+0x26c/0x2e0 net/ipv4/ip_output.c:1652
>     [<00000000098015c2>] udp_sendmsg+0x1bac/0x2390 net/ipv4/udp.c:1253
>     [<0000000045e0e95e>] inet_sendmsg+0x10a/0x150 net/ipv4/af_inet.c:819
>     [<000000008d31bfde>] sock_sendmsg_nosec net/socket.c:714 [inline]
>     [<000000008d31bfde>] sock_sendmsg+0x141/0x190 net/socket.c:734
>     [<0000000021e21aa4>] __sys_sendto+0x243/0x360 net/socket.c:2117
>     [<00000000ac0af00c>] __do_sys_sendto net/socket.c:2129 [inline]
>     [<00000000ac0af00c>] __se_sys_sendto net/socket.c:2125 [inline]
>     [<00000000ac0af00c>] __x64_sys_sendto+0xe1/0x1c0 net/socket.c:2125
>     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v3:
>   * Call skb_orphan_frags_rx() instead of adding locking rule and skb_queue_purge()
> 
> v2: https://lore.kernel.org/netdev/20230418180832.81430-1-kuniyu@amazon.com/
>   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
>   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
>   * Add Fixes tag for TCP
> 
> v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.com/
> ---
>  net/core/skbuff.c | 3 +++
>  net/core/stream.c | 6 ------
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4c0879798eb8..2f9bb98170ab 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5162,6 +5162,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  			skb = alloc_skb(0, GFP_ATOMIC);
>  	} else {
>  		skb = skb_clone(orig_skb, GFP_ATOMIC);
> +
> +		if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
> +			return;
>  	}
>  	if (!skb)
>  		return;
> diff --git a/net/core/stream.c b/net/core/stream.c
> index 434446ab14c5..e6dd1a68545f 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -196,12 +196,6 @@ void sk_stream_kill_queues(struct sock *sk)
>  	/* First the read buffer. */
>  	__skb_queue_purge(&sk->sk_receive_queue);
>  
> -	/* Next, the error queue.
> -	 * We need to use queue lock, because other threads might
> -	 * add packets to the queue without socket lock being held.
> -	 */
> -	skb_queue_purge(&sk->sk_error_queue);
> -

Why include this?

>  	/* Next, the write queue. */
>  	WARN_ON_ONCE(!skb_queue_empty(&sk->sk_write_queue));
>  
> -- 
> 2.30.2
> 


