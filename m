Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6EA6E5425
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDQVxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDQVxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:53:36 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEC0213D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:53:34 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id ff18so4540130qtb.13
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681768414; x=1684360414;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRatN7e+3UdMUc32AkqQgMd7dLBrNHmWYJ7ITc7rfIw=;
        b=mC4ym8rTtZQ3rG+gmm65N7zLFRjISG5xGQb7exG5XivZ7pHYGK8Th/zn4H7A/cfMvN
         9eSu5i8Dj0TUbFVD5bwEBvrkq7BYwcIsBYjD7RKHAogKdq/yKhye8+EMPL3V1ve5U3ba
         0YwMXBD39A3BmGK9Slm8/1JJy00ib4W+1xHr+2N4U0PeAfOPzGIP5EpsRB/CRXdmgEF+
         F3SqAHtJLa97hzgwNwzcNjIedyPG51zvg/L9Ffdj/2BrKwZLIXWIXzQXi6L4nw6Y+wcd
         nnzjpI2keflJ+OFekIjbNCynKNK3NqIUWq1CjkUnSSUQX5UikOp/8taXJ19gEGmkHxf2
         BiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681768414; x=1684360414;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zRatN7e+3UdMUc32AkqQgMd7dLBrNHmWYJ7ITc7rfIw=;
        b=Okplw2GcSbYq/px404qLIZXGORkVX6pHtyeN/rB5ddnlumH8JmaaE+td4BbWn4hRdT
         2kPBYyAj3EQBdYp5/VYKZ2rMC1p4U8CZydty/MRTxy8erpOIzhmAn3l+I8+fGOd9PAVV
         CAReRFmVaPGzXtL2d63xAq2OhGvQSPLyLUNgclWsLXSnZkN41155W+kDeMipRWLY2dR7
         bRNO1tFpTCXcICqdXh/O92uPVYBGz/yhnocJhkERzGgVVxHEQw9Eo459m3iyF0sx4aDh
         ufK5yDbdLaiiRgqLyDtlkiZh7KmgDv7sSA0RzgEDDBNY7b+uWAaDGxl1xZSfmJxkV1jl
         oUXQ==
X-Gm-Message-State: AAQBX9cCDBM8mq+CXe5DDoa4GKo/ut8jKqdiKSIstCk9uDikiN++hFGb
        DqoRigO9nn1KJ4VKV4Lv6Ac=
X-Google-Smtp-Source: AKy350bN8R3h+iatSXAbgpal51W5wVN3wAJg1WiBtDBk2zAwgAYF9pi4hG0wsDBpwQdk/Ke7Wr8aYw==
X-Received: by 2002:a05:6214:410:b0:56c:13cc:d21f with SMTP id z16-20020a056214041000b0056c13ccd21fmr20212638qvx.50.1681768413890;
        Mon, 17 Apr 2023 14:53:33 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 70-20020a370649000000b0074df1d74841sm1097804qkg.72.2023.04.17.14.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 14:53:33 -0700 (PDT)
Date:   Mon, 17 Apr 2023 17:53:33 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller@googlegroups.com, willemb@google.com
Message-ID: <643dbfdd431ac_2d6665294a0@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230417212658.51343-1-kuniyu@amazon.com>
References: <643dadc434cac_2d31fb2945@willemb.c.googlers.com.notmuch>
 <20230417212658.51343-1-kuniyu@amazon.com>
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
> From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date:   Mon, 17 Apr 2023 16:36:20 -0400
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
> > > skb by recvmsg().  When we close() the socket holding such skb, we
> > > never call sock_put() and leak the count, skb, and sk.
> > > 
> > > To avoid this problem, we must call skb_queue_purge() while we close()
> > > UDP sockets.
> > > 
> > > Note that TCP does not have this problem because skb_queue_purge() is
> > > called by sk_stream_kill_queues() during close().
> > 
> > Thanks for the clear description.
> > 
> > So the issue is that the tx timestamp notification is still queued on
> > the error queue and this is not freed on socket destruction.
> > 
> > That surprises me. The error definitely needs to be purged on socket
> > destruction. And it is, called in inet_sock_destruct, which is called
> > udp_destruct_sock.
> > 
> > The issue here is that there is a circular dependency, where the
> > sk_destruct is not called until the ref count drops to zero?
> 
> Yes, right.
> 
> > 
> > sk_stream_kill_queues is called from inet_csk_destroy_sock, from
> > __tcp_close (and thus tcp_prot.close) among others.
> > 
> > purging the error queue for other sockets on .close rather than
> > .destroy sounds good to me.
> > 
> > But SOF_TIMESTAMPING_TX_SOFTWARE and MSG_ZEROCOPY are not limited to
> > TCP and UDP. So we probably need this in a more protocol independent
> > close.
> 
> At least, we limit SO_ZEROCOPY to TCP, UDP and RDS for now.  Also, RDS
> seems to just use TCP. [0]
> 
> ---8<---
> 	case SO_ZEROCOPY:
> 		if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
> 			if (!(sk_is_tcp(sk) ||
> 			      (sk->sk_type == SOCK_DGRAM &&
> 			       sk->sk_protocol == IPPROTO_UDP)))
> 				ret = -EOPNOTSUPP;
> 		} else if (sk->sk_family != PF_RDS) {
> 			ret = -EOPNOTSUPP;
> 		}
> 		if (!ret) {
> 			if (val < 0 || val > 1)
> 				ret = -EINVAL;
> 			else
> 				sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
> 		}
> 		break;
> ---8<---
> 
> [0]: https://lore.kernel.org/netdev/cover.1518718761.git.sowmini.varadhan@oracle.com/

Good point, thanks. I used to experiment with more protocols, as can
be seen from msg_zerocopy.c. But those are thankfully not relevant.
> 
> Thanks,
> Kuniyuki
> 
> 
> > 
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
> > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  include/net/udp.h | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > index de4b528522bb..b9182f166b2f 100644
> > > --- a/include/net/udp.h
> > > +++ b/include/net/udp.h
> > > @@ -195,6 +195,11 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
> > >  
> > >  static inline void udp_lib_close(struct sock *sk, long timeout)
> > >  {
> > > +	/* A zerocopy skb has a refcnt of sk and may be
> > > +	 * put into sk_error_queue with TX timestamp
> > > +	 */
> > > +	skb_queue_purge(&sk->sk_error_queue);
> > > +
> > >  	sk_common_release(sk);
> > >  }

Does this leave a race, where another completion may be queued between
skb_queue_purge and the eventual sock_put in sk_common_release?

Unfortunately even the sock_set_flag(sk, SOCK_DEAD) is not sufficient
to ensure that no tx completions are subsequently queued for packets
that are in transmission. sk_common_release has a comment

         * receive queue, but transmitted packets will delay socket destruction
         * until the last reference will be released.
         */

This should equally apply to TCP. Evidentlly it is not a problem
there. I don't entirely follow yet how this is avoided.

MSG_ZEROCOPY notifications are not queued if SOCK_DEAD (first branch
in __msg_zerocopy_callback). Perhaps we need the same in
sock_queue_err_skb?



