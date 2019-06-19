Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C9A4BF1A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfFSQ6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:58:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56026 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSQ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:58:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so214327wmj.5
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 09:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=crbc1MXXHacDGNZIKG20gZBgJ1sAT/RHKsBTKupPChI=;
        b=jEw2YNBs2oDoSxv0AP2aaZdbAl5p4Gy3C2mM1raoRRmBJrphmfQC7Ius06p+zOyJBH
         d1xtFsdXEpXDVfuNPXWe1l6oQL6rUVbABjrOyAdeXGhRrlDBMyEpTc2y+H1rnGRjQNFe
         XRmoqMcmWi+j6+dZdViP7xuIjJUwz4eF1kIb+J123LG2Vl+IIaXHzFn6ajC0AOOhVaMZ
         yE9gfYUH8Cwph90Er8RoklYThXb/m1OtkPYC7lc7PE/fuwRdP0MWCmGaeYa2Y3h0+ovA
         0YwDyOvUa2/oi+vM7ljelFmJxcoCMigetIqEBJLb9wYeZz6oE0tAMWI+JDcrNjQpxt1M
         Zvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=crbc1MXXHacDGNZIKG20gZBgJ1sAT/RHKsBTKupPChI=;
        b=YoSGc1J25LEKadbUkueDcCB1is/kG4uvJVFe5RojZ0FzRbr/k5OkmLE/aOYbpW9Q6I
         nf6XjD0hK5SnIwpsZ9oK6r7Z22t/mAQtfMpHjCAxBMHIceTD8mxFydJJnZnt66SZRkw7
         ZSSp7G7LSzkSHh6Y1KdLe4J9Q4Z6+eJAD0YnuJTgMeQcKMzoSuqJVbxSlJFzXzHvOtDu
         6vDcI5mOZ7I3jYT0eqCfwu0Ms+x/PuYP2y3zv/K5eULOkLhyZMlOSxm4WAXqypH+Fm46
         z/2z3EcfhTndwy5xYjVdzCiFYO2FDqSOvijLyj2Ls4V1ZjdDAYU3WG9mE2DMtxwgXS/9
         dVrA==
X-Gm-Message-State: APjAAAUkrxS4Spv0mligGSiETsSyb68u5cj7zF2CDm7PbtvVBF0bqqzP
        +MiN7AwLKS47wFeVEc3Y8vNyhfkLaIi4bTSgT5K3XQ==
X-Google-Smtp-Source: APXvYqwLmcQsqlu88Kkj0A+vMZDD8kUcP2GV8JTi6CSz/Q38syZ+vfb7OSUoOFcxJlHmR+Oak3p+x5eXDTIJpq/JWV0=
X-Received: by 2002:a1c:7304:: with SMTP id d4mr9001316wmb.39.1560963513875;
 Wed, 19 Jun 2019 09:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190619163838.150971-1-edumazet@google.com> <CACSApvZvMis6mpaR5raaXw6i9ojrf=E1XyCY_5_1a4FAEFtqVQ@mail.gmail.com>
In-Reply-To: <CACSApvZvMis6mpaR5raaXw6i9ojrf=E1XyCY_5_1a4FAEFtqVQ@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 19 Jun 2019 09:57:57 -0700
Message-ID: <CAK6E8=cXWVgTKY2tVOdMgAKGv4eE-6H4WVrDPw_3QfnVH9t_3Q@mail.gmail.com>
Subject: Re: [PATCH net] inet: clear num_timeout reqsk_alloc()
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 9:46 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Wed, Jun 19, 2019 at 12:38 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > KMSAN caught uninit-value in tcp_create_openreq_child() [1]
> > This is caused by a recent change, combined by the fact
> > that TCP cleared num_timeout, num_retrans and sk fields only
> > when a request socket was about to be queued.
> >
> > Under syncookie mode, a temporary request socket is used,
> > and req->num_timeout could contain garbage.
> >
> > Lets clear these three fields sooner, there is really no
> > point trying to defer this and risk other bugs.
> >
> > [1]
> >
> > BUG: KMSAN: uninit-value in tcp_create_openreq_child+0x157f/0x1cc0 net/ipv4/tcp_minisocks.c:526
> > CPU: 1 PID: 13357 Comm: syz-executor591 Not tainted 5.2.0-rc4+ #3
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
> >  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan.c:611
> >  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:304
> >  tcp_create_openreq_child+0x157f/0x1cc0 net/ipv4/tcp_minisocks.c:526
> >  tcp_v6_syn_recv_sock+0x761/0x2d80 net/ipv6/tcp_ipv6.c:1152
> >  tcp_get_cookie_sock+0x16e/0x6b0 net/ipv4/syncookies.c:209
> >  cookie_v6_check+0x27e0/0x29a0 net/ipv6/syncookies.c:252
> >  tcp_v6_cookie_check net/ipv6/tcp_ipv6.c:1039 [inline]
> >  tcp_v6_do_rcv+0xf1c/0x1ce0 net/ipv6/tcp_ipv6.c:1344
> >  tcp_v6_rcv+0x60b7/0x6a30 net/ipv6/tcp_ipv6.c:1554
> >  ip6_protocol_deliver_rcu+0x1433/0x22f0 net/ipv6/ip6_input.c:397
> >  ip6_input_finish net/ipv6/ip6_input.c:438 [inline]
> >  NF_HOOK include/linux/netfilter.h:305 [inline]
> >  ip6_input+0x2af/0x340 net/ipv6/ip6_input.c:447
> >  dst_input include/net/dst.h:439 [inline]
> >  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
> >  NF_HOOK include/linux/netfilter.h:305 [inline]
> >  ipv6_rcv+0x683/0x710 net/ipv6/ip6_input.c:272
> >  __netif_receive_skb_one_core net/core/dev.c:4981 [inline]
> >  __netif_receive_skb net/core/dev.c:5095 [inline]
> >  process_backlog+0x721/0x1410 net/core/dev.c:5906
> >  napi_poll net/core/dev.c:6329 [inline]
> >  net_rx_action+0x738/0x1940 net/core/dev.c:6395
> >  __do_softirq+0x4ad/0x858 kernel/softirq.c:293
> >  do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1052
> >  </IRQ>
> >  do_softirq kernel/softirq.c:338 [inline]
> >  __local_bh_enable_ip+0x199/0x1e0 kernel/softirq.c:190
> >  local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
> >  rcu_read_unlock_bh include/linux/rcupdate.h:682 [inline]
> >  ip6_finish_output2+0x213f/0x2670 net/ipv6/ip6_output.c:117
> >  ip6_finish_output+0xae4/0xbc0 net/ipv6/ip6_output.c:150
> >  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
> >  ip6_output+0x5d3/0x720 net/ipv6/ip6_output.c:167
> >  dst_output include/net/dst.h:433 [inline]
> >  NF_HOOK include/linux/netfilter.h:305 [inline]
> >  ip6_xmit+0x1f53/0x2650 net/ipv6/ip6_output.c:271
> >  inet6_csk_xmit+0x3df/0x4f0 net/ipv6/inet6_connection_sock.c:135
> >  __tcp_transmit_skb+0x4076/0x5b40 net/ipv4/tcp_output.c:1156
> >  tcp_transmit_skb net/ipv4/tcp_output.c:1172 [inline]
> >  tcp_write_xmit+0x39a9/0xa730 net/ipv4/tcp_output.c:2397
> >  __tcp_push_pending_frames+0x124/0x4e0 net/ipv4/tcp_output.c:2573
> >  tcp_send_fin+0xd43/0x1540 net/ipv4/tcp_output.c:3118
> >  tcp_close+0x16ba/0x1860 net/ipv4/tcp.c:2403
> >  inet_release+0x1f7/0x270 net/ipv4/af_inet.c:427
> >  inet6_release+0xaf/0x100 net/ipv6/af_inet6.c:470
> >  __sock_release net/socket.c:601 [inline]
> >  sock_close+0x156/0x490 net/socket.c:1273
> >  __fput+0x4c9/0xba0 fs/file_table.c:280
> >  ____fput+0x37/0x40 fs/file_table.c:313
> >  task_work_run+0x22e/0x2a0 kernel/task_work.c:113
> >  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
> >  exit_to_usermode_loop arch/x86/entry/common.c:168 [inline]
> >  prepare_exit_to_usermode+0x39d/0x4d0 arch/x86/entry/common.c:199
> >  syscall_return_slowpath+0x90/0x5c0 arch/x86/entry/common.c:279
> >  do_syscall_64+0xe2/0xf0 arch/x86/entry/common.c:305
> >  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > RIP: 0033:0x401d50
> > Code: 01 f0 ff ff 0f 83 40 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d dd 8d 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 14 0d 00 00 c3 48 83 ec 08 e8 7a 02 00 00
> > RSP: 002b:00007fff1cf58cf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> > RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000401d50
> > RDX: 000000000000001c RSI: 0000000000000000 RDI: 0000000000000003
> > RBP: 00000000004a9050 R08: 0000000020000040 R09: 000000000000001c
> > R10: 0000000020004004 R11: 0000000000000246 R12: 0000000000402ef0
> > R13: 0000000000402f80 R14: 0000000000000000 R15: 0000000000000000
> >
> > Uninit was created at:
> >  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:201 [inline]
> >  kmsan_internal_poison_shadow+0x53/0xa0 mm/kmsan/kmsan.c:160
> >  kmsan_kmalloc+0xa4/0x130 mm/kmsan/kmsan_hooks.c:177
> >  kmem_cache_alloc+0x534/0xb00 mm/slub.c:2781
> >  reqsk_alloc include/net/request_sock.h:84 [inline]
> >  inet_reqsk_alloc+0xa8/0x600 net/ipv4/tcp_input.c:6384
> >  cookie_v6_check+0xadb/0x29a0 net/ipv6/syncookies.c:173
> >  tcp_v6_cookie_check net/ipv6/tcp_ipv6.c:1039 [inline]
> >  tcp_v6_do_rcv+0xf1c/0x1ce0 net/ipv6/tcp_ipv6.c:1344
> >  tcp_v6_rcv+0x60b7/0x6a30 net/ipv6/tcp_ipv6.c:1554
> >  ip6_protocol_deliver_rcu+0x1433/0x22f0 net/ipv6/ip6_input.c:397
> >  ip6_input_finish net/ipv6/ip6_input.c:438 [inline]
> >  NF_HOOK include/linux/netfilter.h:305 [inline]
> >  ip6_input+0x2af/0x340 net/ipv6/ip6_input.c:447
> >  dst_input include/net/dst.h:439 [inline]
> >  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
> >  NF_HOOK include/linux/netfilter.h:305 [inline]
> >  ipv6_rcv+0x683/0x710 net/ipv6/ip6_input.c:272
> >  __netif_receive_skb_one_core net/core/dev.c:4981 [inline]
> >  __netif_receive_skb net/core/dev.c:5095 [inline]
> >  process_backlog+0x721/0x1410 net/core/dev.c:5906
> >  napi_poll net/core/dev.c:6329 [inline]
> >  net_rx_action+0x738/0x1940 net/core/dev.c:6395
> >  __do_softirq+0x4ad/0x858 kernel/softirq.c:293
> >  do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1052
> >  do_softirq kernel/softirq.c:338 [inline]
> >  __local_bh_enable_ip+0x199/0x1e0 kernel/softirq.c:190
> >  local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
> >  rcu_read_unlock_bh include/linux/rcupdate.h:682 [inline]
> >  ip6_finish_output2+0x213f/0x2670 net/ipv6/ip6_output.c:117
> >  ip6_finish_output+0xae4/0xbc0 net/ipv6/ip6_output.c:150
> >  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
> >  ip6_output+0x5d3/0x720 net/ipv6/ip6_output.c:167
> >  dst_output include/net/dst.h:433 [inline]
> >  NF_HOOK include/linux/netfilter.h:305 [inline]
> >  ip6_xmit+0x1f53/0x2650 net/ipv6/ip6_output.c:271
> >  inet6_csk_xmit+0x3df/0x4f0 net/ipv6/inet6_connection_sock.c:135
> >  __tcp_transmit_skb+0x4076/0x5b40 net/ipv4/tcp_output.c:1156
> >  tcp_transmit_skb net/ipv4/tcp_output.c:1172 [inline]
> >  tcp_write_xmit+0x39a9/0xa730 net/ipv4/tcp_output.c:2397
> >  __tcp_push_pending_frames+0x124/0x4e0 net/ipv4/tcp_output.c:2573
> >  tcp_send_fin+0xd43/0x1540 net/ipv4/tcp_output.c:3118
> >  tcp_close+0x16ba/0x1860 net/ipv4/tcp.c:2403
> >  inet_release+0x1f7/0x270 net/ipv4/af_inet.c:427
> >  inet6_release+0xaf/0x100 net/ipv6/af_inet6.c:470
> >  __sock_release net/socket.c:601 [inline]
> >  sock_close+0x156/0x490 net/socket.c:1273
> >  __fput+0x4c9/0xba0 fs/file_table.c:280
> >  ____fput+0x37/0x40 fs/file_table.c:313
> >  task_work_run+0x22e/0x2a0 kernel/task_work.c:113
> >  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
> >  exit_to_usermode_loop arch/x86/entry/common.c:168 [inline]
> >  prepare_exit_to_usermode+0x39d/0x4d0 arch/x86/entry/common.c:199
> >  syscall_return_slowpath+0x90/0x5c0 arch/x86/entry/common.c:279
> >  do_syscall_64+0xe2/0xf0 arch/x86/entry/common.c:305
> >  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> >
> > Fixes: 336c39a03151 ("tcp: undo init congestion window on false SYNACK timeout")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Yuchung Cheng <ycheng@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> Thank you for the fix!

Acked-by: Yuchung Cheng <ycheng@google.com>
Thanks for fixing it!

>
> > ---
> >  include/net/request_sock.h      | 3 +++
> >  net/ipv4/inet_connection_sock.c | 4 ----
> >  net/ipv4/tcp_fastopen.c         | 4 ----
> >  3 files changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> > index b3ea21f2732ef509d47bfcecc38f78d9178a3d5c..fd178d58fa84e7ae7abdeff5be2ba7b1ec790889 100644
> > --- a/include/net/request_sock.h
> > +++ b/include/net/request_sock.h
> > @@ -97,6 +97,9 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
> >         sk_node_init(&req_to_sk(req)->sk_node);
> >         sk_tx_queue_clear(req_to_sk(req));
> >         req->saved_syn = NULL;
> > +       req->num_timeout = 0;
> > +       req->num_retrans = 0;
> > +       req->sk = NULL;
> >         refcount_set(&req->rsk_refcnt, 0);
> >
> >         return req;
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 13ec7c3a9c49f02ed359f3f941c8ff70f4699695..7fd6db3fe3664b02fa0279a6aef08144588de6e4 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -752,10 +752,6 @@ static void reqsk_timer_handler(struct timer_list *t)
> >  static void reqsk_queue_hash_req(struct request_sock *req,
> >                                  unsigned long timeout)
> >  {
> > -       req->num_retrans = 0;
> > -       req->num_timeout = 0;
> > -       req->sk = NULL;
> > -
> >         timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
> >         mod_timer(&req->rsk_timer, jiffies + timeout);
> >
> > diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
> > index 018a484773551f8e67fe20be97b04f6d02104a56..f5a45e1e118224966e336725de71d3636b207892 100644
> > --- a/net/ipv4/tcp_fastopen.c
> > +++ b/net/ipv4/tcp_fastopen.c
> > @@ -221,10 +221,6 @@ static struct sock *tcp_fastopen_create_child(struct sock *sk,
> >         struct sock *child;
> >         bool own_req;
> >
> > -       req->num_retrans = 0;
> > -       req->num_timeout = 0;
> > -       req->sk = NULL;
> > -
> >         child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb, req, NULL,
> >                                                          NULL, &own_req);
> >         if (!child)
> > --
> > 2.22.0.410.gd8fdbe21b5-goog
> >
