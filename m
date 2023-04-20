Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF9A6E9EA7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjDTWQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjDTWQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:16:30 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8552D42
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:16:21 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-74ab718c344so364277185a.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682028981; x=1684620981;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0T2bxRlVzkCKS5Qui/pcj2CTnlTY3nXrinkD0W9AAw=;
        b=MqJoU+n1xLT7PIUbpDgPHNcO+OKR6AOjvw1BQaOvXjMGqGSRB6ulrYfMm05TGSU7Ei
         M9XjHdG27olkA91UN0tAaoe1K8QhkDY1oRrADVBzrXnqSdp5vfONHjQ4lV76KLPHyYRn
         4MNDiJn5o0cyiBNYevjvNAH53dGDGS5hOHOs/5qbQN4hcrecoIcaUlGui542jU1XMdc/
         HzfvjY/H0xfOKIhf3KvNkQLCy0ei9Jk3H0Uxc99bmcKmNzHUPylWxr2Bw0mE/LDC6QFj
         EyZXRSe+5E3L0PpKj5El5CIwaf/pyX3kps3ivz5x/mS2CciIBGLMmQW/hdzrNfwo18nP
         I+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682028981; x=1684620981;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x0T2bxRlVzkCKS5Qui/pcj2CTnlTY3nXrinkD0W9AAw=;
        b=NIMJhFnP3sI0LB5x4ZtoiwmaIlIi719vjA8PWTPnGDeERZj91axB2BDYTP2iWVeUTD
         c8Y1XGAKyOBAaZP063UGL6cpW6F+8BrQ/Yxy7fjZFBuhEvqaXvTUiGRvuRrVi1CduXEA
         iMMDfcqo/Cu9Jle/pWddyba8XfoAyZU3IvZnBEQVukNB2YvK2yVM6QZ1tFdfKDvfpk1G
         CM2ZdPrYvPxqElrkpGt6aKyHifTTEczl8efS+7UbYBlL758pMy3ShRli0KDgkFa9hZoa
         z1aSrPVsyl2op8MQQlH7RcH3irzT/Y01fQ/WY16qxOPViDi7m657za8NZOGNXxbVByN7
         tPhA==
X-Gm-Message-State: AAQBX9c8XoVg2t5tm15/vh+UEL4qx+DwXSPeMSMoH3MPQL4Q3rkG6+Rw
        5yGaHPGTQJSucuC6EjBFXew=
X-Google-Smtp-Source: AKy350ZY0SsaApE3u2bnY2ycUZFfekXz/0rT2tcP/ZGI9TcAazK3o6pThjQRV+qOq3z3hvI53ZS1VA==
X-Received: by 2002:a05:6214:5289:b0:5f1:6aa8:cd2d with SMTP id kj9-20020a056214528900b005f16aa8cd2dmr5199866qvb.22.1682028980879;
        Thu, 20 Apr 2023 15:16:20 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id v15-20020a0ce1cf000000b005ef451995f5sm698650qvl.30.2023.04.20.15.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 15:16:20 -0700 (PDT)
Date:   Thu, 20 Apr 2023 18:16:20 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller@googlegroups.com, willemb@google.com
Message-ID: <6441b9b432255_c03e8294d@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230420215407.48720-1-kuniyu@amazon.com>
References: <644190af7652e_5eb3529467@willemb.c.googlers.com.notmuch>
 <20230420215407.48720-1-kuniyu@amazon.com>
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
> From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date:   Thu, 20 Apr 2023 15:21:19 -0400
> > Kuniyuki Iwashima wrote:
> > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > skbs.  We can reproduce the problem with these sequences:
> > > 
> > >   sk = socket(AF_INET, SOCK_DGRAM, 0)
> > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
> > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > >   sk.close()
> > > 
> > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > the socket's error queue with the TX timestamp.
> > > 
> > > When the original skb is received locally, skb_copy_ubufs() calls
> > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> > > This additional count is decremented while freeing the skb, but struct
> > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> > > not called.
> > > 
> > > The last refcnt is not released unless we retrieve the TX timestamped
> > > skb by recvmsg().  Since we clear the error queue in inet_sock_destruct()
> > > after the socket's refcnt reaches 0, there is a circular dependency.
> > > If we close() the socket holding such skbs, we never call sock_put()
> > > and leak the count, sk, and skb.
> > > 
> > > TCP has the same problem, and commit e0c8bccd40fc ("net: stream:
> > > purge sk_error_queue in sk_stream_kill_queues()") tried to fix it
> > > by calling skb_queue_purge() during close().  However, there is a
> > > small chance that skb queued in a qdisc or device could be put
> > > into the error queue after the skb_queue_purge() call.
> > 
> > I'd remove this part. If there is an issue in TCP, it is a separate
> > issue and deserves a separate patch.
> 
> I don't think it's a separate issue.  The issue resides in the common
> zerocopy infra, and each blamed commit introduces the issue to each
> protocol.
> 
> 
> > 
> > The UDP part looks great to me. Thanks for fixing that.
> > 
> > > In __skb_tstamp_tx(), the cloned skb should not have a reference
> > > to the ubuf to remove the circular dependency, but skb_clone() does
> > > not call skb_copy_ubufs() for zerocopy skb.  So, we need to call
> > > skb_orphan_frags_rx() for the cloned skb to call skb_copy_ubufs().
> > >
> > > [0]:
> > > BUG: memory leak
> > > unreferenced object 0xffff88800c6d2d00 (size 1152):
> > >   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
> > >   hex dump (first 32 bytes):
> > >     00 00 00 00 00 00 00 00 cd af e8 81 00 00 00 00  ................
> > >     02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
> > >   backtrace:
> > >     [<0000000055636812>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:2024
> > >     [<0000000054d77b7a>] sk_alloc+0x3b/0x800 net/core/sock.c:2083
> > >     [<0000000066f3c7e0>] inet_create net/ipv4/af_inet.c:319 [inline]
> > >     [<0000000066f3c7e0>] inet_create+0x31e/0xe40 net/ipv4/af_inet.c:245
> > >     [<000000009b83af97>] __sock_create+0x2ab/0x550 net/socket.c:1515
> > >     [<00000000b9b11231>] sock_create net/socket.c:1566 [inline]
> > >     [<00000000b9b11231>] __sys_socket_create net/socket.c:1603 [inline]
> > >     [<00000000b9b11231>] __sys_socket_create net/socket.c:1588 [inline]
> > >     [<00000000b9b11231>] __sys_socket+0x138/0x250 net/socket.c:1636
> > >     [<000000004fb45142>] __do_sys_socket net/socket.c:1649 [inline]
> > >     [<000000004fb45142>] __se_sys_socket net/socket.c:1647 [inline]
> > >     [<000000004fb45142>] __x64_sys_socket+0x73/0xb0 net/socket.c:1647
> > >     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
> > >     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > 
> > > BUG: memory leak
> > > unreferenced object 0xffff888017633a00 (size 240):
> > >   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
> > >   hex dump (first 32 bytes):
> > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >     00 00 00 00 00 00 00 00 00 2d 6d 0c 80 88 ff ff  .........-m.....
> > >   backtrace:
> > >     [<000000002b1c4368>] __alloc_skb+0x229/0x320 net/core/skbuff.c:497
> > >     [<00000000143579a6>] alloc_skb include/linux/skbuff.h:1265 [inline]
> > >     [<00000000143579a6>] sock_omalloc+0xaa/0x190 net/core/sock.c:2596
> > >     [<00000000be626478>] msg_zerocopy_alloc net/core/skbuff.c:1294 [inline]
> > >     [<00000000be626478>] msg_zerocopy_realloc+0x1ce/0x7f0 net/core/skbuff.c:1370
> > >     [<00000000cbfc9870>] __ip_append_data+0x2adf/0x3b30 net/ipv4/ip_output.c:1037
> > >     [<0000000089869146>] ip_make_skb+0x26c/0x2e0 net/ipv4/ip_output.c:1652
> > >     [<00000000098015c2>] udp_sendmsg+0x1bac/0x2390 net/ipv4/udp.c:1253
> > >     [<0000000045e0e95e>] inet_sendmsg+0x10a/0x150 net/ipv4/af_inet.c:819
> > >     [<000000008d31bfde>] sock_sendmsg_nosec net/socket.c:714 [inline]
> > >     [<000000008d31bfde>] sock_sendmsg+0x141/0x190 net/socket.c:734
> > >     [<0000000021e21aa4>] __sys_sendto+0x243/0x360 net/socket.c:2117
> > >     [<00000000ac0af00c>] __do_sys_sendto net/socket.c:2129 [inline]
> > >     [<00000000ac0af00c>] __se_sys_sendto net/socket.c:2125 [inline]
> > >     [<00000000ac0af00c>] __x64_sys_sendto+0xe1/0x1c0 net/socket.c:2125
> > >     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
> > >     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > 
> > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > > v3:
> > >   * Call skb_orphan_frags_rx() instead of adding locking rule and skb_queue_purge()
> > > 
> > > v2: https://lore.kernel.org/netdev/20230418180832.81430-1-kuniyu@amazon.com/
> > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
> > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
> > >   * Add Fixes tag for TCP
> > > 
> > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.com/
> > > ---
> > >  net/core/skbuff.c | 3 +++
> > >  net/core/stream.c | 6 ------
> > >  2 files changed, 3 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 4c0879798eb8..2f9bb98170ab 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5162,6 +5162,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> > >  			skb = alloc_skb(0, GFP_ATOMIC);
> > >  	} else {
> > >  		skb = skb_clone(orig_skb, GFP_ATOMIC);
> > > +
> > > +		if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
> > > +			return;
> > >  	}
> > >  	if (!skb)
> > >  		return;
> > > diff --git a/net/core/stream.c b/net/core/stream.c
> > > index 434446ab14c5..e6dd1a68545f 100644
> > > --- a/net/core/stream.c
> > > +++ b/net/core/stream.c
> > > @@ -196,12 +196,6 @@ void sk_stream_kill_queues(struct sock *sk)
> > >  	/* First the read buffer. */
> > >  	__skb_queue_purge(&sk->sk_receive_queue);
> > >  
> > > -	/* Next, the error queue.
> > > -	 * We need to use queue lock, because other threads might
> > > -	 * add packets to the queue without socket lock being held.
> > > -	 */
> > > -	skb_queue_purge(&sk->sk_error_queue);
> > > -
> > 
> > Why include this?
> 
> As mentioned in 24bcbe1cc69f ("net: stream: don't purge sk_error_queue in
> sk_stream_kill_queues()"), we don't need this, but e0c8bccd40fc ("net:
> stream: purge sk_error_queue in sk_stream_kill_queues()") added it back
> to avoid the same issue.  It's most likely to remove the issue, but we
> concluded this way was insufficient.
> 
> Now we have the proper fix and should remove the workaround.

I don't that removing a fix should go to net. Even if the fix is now
superfluous.

Just one opinion, but I'd send this separately to net-next.
 


