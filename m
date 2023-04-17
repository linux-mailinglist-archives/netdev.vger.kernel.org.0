Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF406E51E8
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDQUgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjDQUgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:36:23 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D100D1FDE
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:36:21 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id ej15so14450859qtb.7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681763781; x=1684355781;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vfoDt+Xk0SPHxWQ2K34f6O/gopIuUh7nIqxFpUMhEc=;
        b=hH9PbygNYvqCC8RHHlUQrBSIaxZhJyKaKCKlIjyFCS9WUykEme2a+MvQUZ1EzfVNww
         q8bgo6IIRYW+YG0tndNyQLLN4xIB0Dlt7eX7s7acdlzTTZ2sVvtNdV4MiL22k7H7AMSM
         N9/cOG4Zs+vNQ03bHj195usEhnYMBhHl1jWgOK52qC0IL+h1d0pM05Yjswh0f/nmiuv4
         fEieJzS0rykZ7V/naFtLMg2e2PS3BxQk70NB18M0zBnukCFq+b5NiM7SmMQH1gQZOJzL
         Jv+MoXU2InMgZ45Vz21so2o8A35g4NFTKDMCrisr41l5P1f3BIBekwdB9ZX8g4/VImVb
         rvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681763781; x=1684355781;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3vfoDt+Xk0SPHxWQ2K34f6O/gopIuUh7nIqxFpUMhEc=;
        b=VL4ixsX6GyMOVHqCF8zlivcYXJiqjVznqgLcmeAd73oKVRvV8oTH90JtPF/lIqC23G
         JhAsnAjq7EokUxUjqjMy3uoiAZ2pGliFp0NlJEWrQFQIuS0ib3291TSRWrV31TQgq9am
         SOYwlEmHp+NxR2CFSzQdgxxbyrCv0fdyMk+qyTE2OaqZTi5egDl/Wjj4cdWT8/T2a8bl
         rH4BJJOkyE0E4XMlryN4UQDJGK82BvLqLAB0kp5GF7g//KYJuSHGX5Ig5kNHiw0jaBjg
         hPXR/wNk1+XsDLWPwXJZzGd0z5zUqApX44pwSYkEZGUQ3bVfD3oS7REFLeuQFyUX+exf
         Mlhw==
X-Gm-Message-State: AAQBX9cZzHf1YUg1pKyx54Kg9s1lWJ6qmQe9YacRT9jd30dyw2cFVSUc
        NdnGcg2o5+pOeCkpd8pTb8Q=
X-Google-Smtp-Source: AKy350bMcO6BWTvxVh2vOEOM4aFQ6CFS8bNt6TMysLx/404u5Jl68+FFCizUeosOQkxYZiKPUfS/kQ==
X-Received: by 2002:a05:6214:d4c:b0:5ef:877d:c0be with SMTP id 12-20020a0562140d4c00b005ef877dc0bemr4929177qvr.37.1681763780838;
        Mon, 17 Apr 2023 13:36:20 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 142-20020a370694000000b0074d60b697a6sm1675289qkg.12.2023.04.17.13.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 13:36:20 -0700 (PDT)
Date:   Mon, 17 Apr 2023 16:36:20 -0400
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
Message-ID: <643dadc434cac_2d31fb2945@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230417171155.22916-1-kuniyu@amazon.com>
References: <20230417171155.22916-1-kuniyu@amazon.com>
Subject: RE: [PATCH v1 net] udp: Fix memleaks of sk and zerocopy skbs with TX
 timestamp.
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
> skb by recvmsg().  When we close() the socket holding such skb, we
> never call sock_put() and leak the count, skb, and sk.
> 
> To avoid this problem, we must call skb_queue_purge() while we close()
> UDP sockets.
> 
> Note that TCP does not have this problem because skb_queue_purge() is
> called by sk_stream_kill_queues() during close().

Thanks for the clear description.

So the issue is that the tx timestamp notification is still queued on
the error queue and this is not freed on socket destruction.

That surprises me. The error definitely needs to be purged on socket
destruction. And it is, called in inet_sock_destruct, which is called
udp_destruct_sock.

The issue here is that there is a circular dependency, where the
sk_destruct is not called until the ref count drops to zero?

sk_stream_kill_queues is called from inet_csk_destroy_sock, from
__tcp_close (and thus tcp_prot.close) among others.

purging the error queue for other sockets on .close rather than
.destroy sounds good to me.

But SOF_TIMESTAMPING_TX_SOFTWARE and MSG_ZEROCOPY are not limited to
TCP and UDP. So we probably need this in a more protocol independent
close.

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
> Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/udp.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index de4b528522bb..b9182f166b2f 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -195,6 +195,11 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
>  
>  static inline void udp_lib_close(struct sock *sk, long timeout)
>  {
> +	/* A zerocopy skb has a refcnt of sk and may be
> +	 * put into sk_error_queue with TX timestamp
> +	 */
> +	skb_queue_purge(&sk->sk_error_queue);
> +
>  	sk_common_release(sk);
>  }
>  
> -- 
> 2.30.2
> 


