Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FCF59FF83
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiHXQaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiHXQaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:30:17 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228582879;
        Wed, 24 Aug 2022 09:30:15 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id f21so17587080pjt.2;
        Wed, 24 Aug 2022 09:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BaBBgLiAjQSX07OyatMm+1aCsnoFfhVQFjxdDpSP0rU=;
        b=FUIPSSV3O2DbYdGt8cCSMAUmSORBDltKgCZX++TjnDj9Fku52vzDLDGM7s9pgaVbWA
         K8gOxnwWqHpt9etWw6m6W3taNtsNamaaaP+qciHyv2h5S9OiK3+Hh/00hqZbSMabIvFc
         2lQYv2zucKljZ9zQskiGghJ31CqP9UPh//HAfW46bU+vyFFqmMw1d2K4xAW9m/1e0cd4
         yz098JBz2GKn+43FJMVwUIJsYf7ZxjpVIFx3+Ma7NyaM+66rpA+WG0ibqtgMSFt0Pg1v
         w/tEAYmRH0/2oFJd2uroVAWqo21oVATd7hxFlnvp6QqMHYJtvTXsTz8pNBdWhzmvjPSI
         V4GQ==
X-Gm-Message-State: ACgBeo18Ml5gRVKeWfMynEVeqvz+M+V2YkbPEybNw9v4peQ0/jk4QuyE
        Rw6lk5B9RcqRnUZ3HVYXIbrATeIavZ+P7ANz
X-Google-Smtp-Source: AA6agR5yZVdMWRf6pVqa1P+gGDupFDiMscrPidJ6F+MNqv2PYU5hP6Aoj++4CNocjAKCWNlHnHgVBA==
X-Received: by 2002:a17:902:d051:b0:172:fa4d:dffa with SMTP id l17-20020a170902d05100b00172fa4ddffamr10063745pll.39.1661358614985;
        Wed, 24 Aug 2022 09:30:14 -0700 (PDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com. [209.85.210.170])
        by smtp.gmail.com with ESMTPSA id mg24-20020a17090b371800b001fb6c6ebaafsm1624262pjb.25.2022.08.24.09.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 09:30:13 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id y15so12998848pfr.9;
        Wed, 24 Aug 2022 09:30:13 -0700 (PDT)
X-Received: by 2002:a63:6406:0:b0:42b:1580:4c16 with SMTP id
 y6-20020a636406000000b0042b15804c16mr3781804pgb.531.1661358613436; Wed, 24
 Aug 2022 09:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ce327f05d537ebf7@google.com> <1959174.1661183147@warthog.procyon.org.uk>
In-Reply-To: <1959174.1661183147@warthog.procyon.org.uk>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Wed, 24 Aug 2022 13:30:01 -0300
X-Gmail-Original-Message-ID: <CAB9dFdv5cTtBTOTHRxsD4Kk0MXivik6uMsb_3NEDKa_Pb-ALhg@mail.gmail.com>
Message-ID: <CAB9dFdv5cTtBTOTHRxsD4Kk0MXivik6uMsb_3NEDKa_Pb-ALhg@mail.gmail.com>
Subject: Re: [syzbot] WARNING: bad unlock balance in rxrpc_do_sendmsg
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot <syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 12:46 PM David Howells <dhowells@redhat.com> wrote:
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git master
>
> rxrpc: Fix locking in rxrpc's sendmsg
>
> Fix three bugs in the rxrpc's sendmsg implementation:
>
>  (1) rxrpc_new_client_call() should release the socket lock when returning
>      an error from rxrpc_get_call_slot().
>
>  (2) rxrpc_wait_for_tx_window_intr() will return without the call mutex
>      held in the event that we're interrupted by a signal whilst waiting
>      for tx space on the socket or relocking the call mutex afterwards.
>
>      Fix this by: (a) moving the unlock/lock of the call mutex up to
>      rxrpc_send_data() such that the lock is not held around all of
>      rxrpc_wait_for_tx_window*() and (b) indicating to higher callers
>      whether we're return with the lock dropped.  Note that this means
>      recvmsg() will not block on this call whilst we're waiting.
>
>  (3) After dropping and regaining the call mutex, rxrpc_send_data() needs
>      to go and recheck the state of the tx_pending buffer and the
>      tx_total_len check in case we raced with another sendmsg() on the same
>      call.
>
> Thinking on this some more, it might make sense to have different locks for
> sendmsg() and recvmsg().  There's probably no need to make recvmsg() wait
> for sendmsg().  It does mean that recvmsg() can return MSG_EOR indicating
> that a call is dead before a sendmsg() to that call returns - but that can
> currently happen anyway.
>
> Without fix (2), something like the following can be induced:
>
>         WARNING: bad unlock balance detected!
>         5.16.0-rc6-syzkaller #0 Not tainted
>         -------------------------------------
>         syz-executor011/3597 is trying to release lock (&call->user_mutex) at:
>         [<ffffffff885163a3>] rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
>         but there are no more locks to release!
>
>         other info that might help us debug this:
>         no locks held by syz-executor011/3597.
>         ...
>         Call Trace:
>          <TASK>
>          __dump_stack lib/dump_stack.c:88 [inline]
>          dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>          print_unlock_imbalance_bug include/trace/events/lock.h:58 [inline]
>          __lock_release kernel/locking/lockdep.c:5306 [inline]
>          lock_release.cold+0x49/0x4e kernel/locking/lockdep.c:5657
>          __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:900
>          rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
>          rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:561
>          sock_sendmsg_nosec net/socket.c:704 [inline]
>          sock_sendmsg+0xcf/0x120 net/socket.c:724
>          ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
>          ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>          __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
>          do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>          do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>          entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> [Thanks to Hawkins Jiawei and Khalid Masum for their attempts to fix this]
>
> Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporarily ignore signals")
> Reported-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
> cc: Hawkins Jiawei <yin31149@gmail.com>
> cc: Khalid Masum <khalid.masum.92@gmail.com>
> cc: Dan Carpenter <dan.carpenter@oracle.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> ---
>  net/rxrpc/call_object.c |    4 +-
>  net/rxrpc/sendmsg.c     |   92 ++++++++++++++++++++++++++++--------------------
>  2 files changed, 57 insertions(+), 39 deletions(-)
>
> diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
> index 84d0a4109645..6401cdf7a624 100644
> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -285,8 +285,10 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
>         _enter("%p,%lx", rx, p->user_call_ID);
>
>         limiter = rxrpc_get_call_slot(p, gfp);
> -       if (!limiter)
> +       if (!limiter) {
> +               release_sock(&rx->sk);
>                 return ERR_PTR(-ERESTARTSYS);
> +       }
>
>         call = rxrpc_alloc_client_call(rx, srx, gfp, debug_id);
>         if (IS_ERR(call)) {
> diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
> index 1d38e279e2ef..3c3a626459de 100644
> --- a/net/rxrpc/sendmsg.c
> +++ b/net/rxrpc/sendmsg.c
> @@ -51,10 +51,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
>                         return sock_intr_errno(*timeo);
>
>                 trace_rxrpc_transmit(call, rxrpc_transmit_wait);
> -               mutex_unlock(&call->user_mutex);
>                 *timeo = schedule_timeout(*timeo);
> -               if (mutex_lock_interruptible(&call->user_mutex) < 0)
> -                       return sock_intr_errno(*timeo);
>         }
>  }
>
> @@ -290,37 +287,48 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
>  static int rxrpc_send_data(struct rxrpc_sock *rx,
>                            struct rxrpc_call *call,
>                            struct msghdr *msg, size_t len,
> -                          rxrpc_notify_end_tx_t notify_end_tx)
> +                          rxrpc_notify_end_tx_t notify_end_tx,
> +                          bool *_dropped_lock)
>  {
>         struct rxrpc_skb_priv *sp;
>         struct sk_buff *skb;
>         struct sock *sk = &rx->sk;
> +       enum rxrpc_call_state state;
>         long timeo;
> -       bool more;
> -       int ret, copied;
> +       bool more = msg->msg_flags & MSG_MORE;
> +       int ret, copied = 0;
>
>         timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>
>         /* this should be in poll */
>         sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
>
> +reload:
> +       ret = -EPIPE;
>         if (sk->sk_shutdown & SEND_SHUTDOWN)
> -               return -EPIPE;
> -
> -       more = msg->msg_flags & MSG_MORE;
> -
> +               goto maybe_error;
> +       state = READ_ONCE(call->state);
> +       ret = -ESHUTDOWN;
> +       if (state >= RXRPC_CALL_COMPLETE)
> +               goto maybe_error;
> +       ret = -EPROTO;
> +       if (state != RXRPC_CALL_CLIENT_SEND_REQUEST &&
> +           state != RXRPC_CALL_SERVER_ACK_REQUEST &&
> +           state != RXRPC_CALL_SERVER_SEND_REPLY)
> +               goto maybe_error;
> +
> +       ret = -EMSGSIZE;
>         if (call->tx_total_len != -1) {
> -               if (len > call->tx_total_len)
> -                       return -EMSGSIZE;
> -               if (!more && len != call->tx_total_len)
> -                       return -EMSGSIZE;
> +               if (len - copied > call->tx_total_len)
> +                       goto maybe_error;
> +               if (!more && len - copied != call->tx_total_len)
> +                       goto maybe_error;
>         }
>
>         skb = call->tx_pending;
>         call->tx_pending = NULL;
>         rxrpc_see_skb(skb, rxrpc_skb_seen);
>
> -       copied = 0;
>         do {
>                 /* Check to see if there's a ping ACK to reply to. */
>                 if (call->ackr_reason == RXRPC_ACK_PING_RESPONSE)
> @@ -331,16 +339,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
>
>                         _debug("alloc");
>
> -                       if (!rxrpc_check_tx_space(call, NULL)) {
> -                               ret = -EAGAIN;
> -                               if (msg->msg_flags & MSG_DONTWAIT)
> -                                       goto maybe_error;
> -                               ret = rxrpc_wait_for_tx_window(rx, call,
> -                                                              &timeo,
> -                                                              msg->msg_flags & MSG_WAITALL);
> -                               if (ret < 0)
> -                                       goto maybe_error;
> -                       }
> +                       if (!rxrpc_check_tx_space(call, NULL))
> +                               goto wait_for_space;
>
>                         /* Work out the maximum size of a packet.  Assume that
>                          * the security header is going to be in the padded
> @@ -468,6 +468,27 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
>  efault:
>         ret = -EFAULT;
>         goto out;
> +
> +wait_for_space:
> +       ret = -EAGAIN;
> +       if (msg->msg_flags & MSG_DONTWAIT)
> +               goto maybe_error;
> +       mutex_unlock(&call->user_mutex);
> +       *_dropped_lock = true;
> +       ret = rxrpc_wait_for_tx_window(rx, call, &timeo,
> +                                      msg->msg_flags & MSG_WAITALL);
> +       if (ret < 0)
> +               goto maybe_error;
> +       if (call->interruptibility == RXRPC_INTERRUPTIBLE) {
> +               if (mutex_lock_interruptible(&call->user_mutex) < 0) {
> +                       ret = sock_intr_errno(timeo);
> +                       goto maybe_error;
> +               }
> +       } else {
> +               mutex_lock(&call->user_mutex);
> +       }
> +       *_dropped_lock = false;
> +       goto reload;
>  }
>
>  /*
> @@ -629,6 +650,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
>         enum rxrpc_call_state state;
>         struct rxrpc_call *call;
>         unsigned long now, j;
> +       bool dropped_lock = false;
>         int ret;
>
>         struct rxrpc_send_params p = {
> @@ -737,21 +759,13 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
>                         ret = rxrpc_send_abort_packet(call);
>         } else if (p.command != RXRPC_CMD_SEND_DATA) {
>                 ret = -EINVAL;
> -       } else if (rxrpc_is_client_call(call) &&
> -                  state != RXRPC_CALL_CLIENT_SEND_REQUEST) {
> -               /* request phase complete for this client call */
> -               ret = -EPROTO;
> -       } else if (rxrpc_is_service_call(call) &&
> -                  state != RXRPC_CALL_SERVER_ACK_REQUEST &&
> -                  state != RXRPC_CALL_SERVER_SEND_REPLY) {
> -               /* Reply phase not begun or not complete for service call. */
> -               ret = -EPROTO;
>         } else {
> -               ret = rxrpc_send_data(rx, call, msg, len, NULL);
> +               ret = rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
>         }
>
>  out_put_unlock:
> -       mutex_unlock(&call->user_mutex);
> +       if (!dropped_lock)
> +               mutex_unlock(&call->user_mutex);
>  error_put:
>         rxrpc_put_call(call, rxrpc_call_put);
>         _leave(" = %d", ret);
> @@ -779,6 +793,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
>                            struct msghdr *msg, size_t len,
>                            rxrpc_notify_end_tx_t notify_end_tx)
>  {
> +       bool dropped_lock = false;
>         int ret;
>
>         _enter("{%d,%s},", call->debug_id, rxrpc_call_states[call->state]);
> @@ -796,7 +811,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
>         case RXRPC_CALL_SERVER_ACK_REQUEST:
>         case RXRPC_CALL_SERVER_SEND_REPLY:
>                 ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
> -                                     notify_end_tx);
> +                                     notify_end_tx, &dropped_lock);
>                 break;
>         case RXRPC_CALL_COMPLETE:
>                 read_lock_bh(&call->state_lock);
> @@ -810,7 +825,8 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
>                 break;
>         }
>
> -       mutex_unlock(&call->user_mutex);
> +       if (!dropped_lock)
> +               mutex_unlock(&call->user_mutex);
>         _leave(" = %d", ret);
>         return ret;
>  }

Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Marc
