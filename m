Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767432CDB31
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgLCQ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgLCQ17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 11:27:59 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46513C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 08:27:19 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id t13so2473589ilp.2
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 08:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cOQxk743ljCBxb7kE7j4bu/7hb7YV+trjyBCFiVsJYM=;
        b=WwCX2nfAUKU80kW+GxDa45X29jAbFTPCHGimVTXC0aJJqoQaHy95iVuXZZ7gvpoCMb
         zPk9vF5LDoCraov0cJaDPKZBqAcQa70G4hmWAWzMtK3iAWA0zX4o4q8La40T15ajxA4u
         SqgjiGqYTpahb1uSXRLRiXnQ5AzA3VhlFfMdopRd0n0+tDskQawcixxFz1vczy7FbRRE
         bwIodnpe1HRrbT1r6DPWCg5+gDDxlwGsw2itknHvMpObi+uHZLgIXD42SBm8JTlrA+sE
         Wzpzw/a2NVhIAXustBuO6OZ729SDJz2Ss6e6BKZzNkY7e+6W4whToe0rhHCdEISd9LWy
         rX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cOQxk743ljCBxb7kE7j4bu/7hb7YV+trjyBCFiVsJYM=;
        b=ReC8Lk7Lihh74dolvDefDye8tAwU33AXYHSgVxIQSQrJt4QnJqa6uxELpoYG92FeBF
         2UlJsuW0JP9GfGEKUvhq+lsQI75cAf8fHFyqYNaEDlO517O3UC/C2pnzdLuFDQPZsnzi
         Hd/SmkdbKi67QvP5yPDGfJIMHbkR3D9DqWVmGAMXI4wj6q1mq2irHefMYqbAibb4DlFW
         muw/045hOzPDLcAUVLdaHAeIKrWzotn4lXz9+Kl8mPqaLOuj0vgUMTtZ+UJqfw/G1y/8
         nPpzVxrtz4rYrpcQIAL6HaAxWMXGKftVk4JuAT5LpgWlCanxpWibBSmB0t5wTNS1YQpP
         cr7g==
X-Gm-Message-State: AOAM533xZUd6ZBd3oLNkOelklkp/RX9I8FhiUFQuBTAUsl5fUk91Oop4
        R8L1So+DpF2HDMc1NzFEzKGliPkxDjFLnn4uFxsGYg==
X-Google-Smtp-Source: ABdhPJyWLzZJq3sOkXWzdJxtYaoW1bhaBO6nHUPjKbN8HQGy8koap5do8P8inn/HiIovMIoCY7IHFk2TXKYiRLnj0ro=
X-Received: by 2002:a92:358e:: with SMTP id c14mr3509419ilf.69.1607012838185;
 Thu, 03 Dec 2020 08:27:18 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b4862805b54ef573@google.com> <X8kLG5D+j4rT6L7A@elver.google.com>
In-Reply-To: <X8kLG5D+j4rT6L7A@elver.google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Dec 2020 17:27:06 +0100
Message-ID: <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
To:     Marco Elver <elver@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 4:58 PM Marco Elver <elver@google.com> wrote:
>
> On Mon, Nov 30, 2020 at 12:40AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    6147c83f Add linux-next specific files for 20201126
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=117c9679500000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9b91566da897c24f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=7b99aafdcc2eedea6178
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103bf743500000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167c60c9500000
> >
> > The issue was bisected to:
> >
> > commit 145cd60fb481328faafba76842aa0fd242e2b163
> > Author: Alexander Potapenko <glider@google.com>
> > Date:   Tue Nov 24 05:38:44 2020 +0000
> >
> >     mm, kfence: insert KFENCE hooks for SLUB
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13abe5b3500000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=106be5b3500000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17abe5b3500000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
> > Fixes: 145cd60fb481 ("mm, kfence: insert KFENCE hooks for SLUB")
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 11307 at net/core/stream.c:207 sk_stream_kill_queues+0x3c3/0x530 net/core/stream.c:207
> [...]
> > Call Trace:
> >  inet_csk_destroy_sock+0x1a5/0x490 net/ipv4/inet_connection_sock.c:885
> >  __tcp_close+0xd3e/0x1170 net/ipv4/tcp.c:2585
> >  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2597
> >  inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
> >  __sock_release+0xcd/0x280 net/socket.c:596
> >  sock_close+0x18/0x20 net/socket.c:1255
> >  __fput+0x283/0x920 fs/file_table.c:280
> >  task_work_run+0xdd/0x190 kernel/task_work.c:140
> >  exit_task_work include/linux/task_work.h:30 [inline]
> >  do_exit+0xb89/0x29e0 kernel/exit.c:823
> >  do_group_exit+0x125/0x310 kernel/exit.c:920
> >  get_signal+0x3ec/0x2010 kernel/signal.c:2770
> >  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
> >  handle_signal_work kernel/entry/common.c:144 [inline]
> >  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> >  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
> >  syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> I've been debugging this and I think enabling KFENCE uncovered that some
> code is assuming that the following is always true:
>
>         ksize(kmalloc(S)) == ksize(kmalloc(S))
>


I do not think we make this assumption.

Each skb tracks the 'truesize' which is populated from __alloc_skb()
using ksize(allocated head) .

So if ksize() decides to give us random data, it should be still fine,
because we use ksize(buff) only once at alloc skb time, and record the
value in skb->truesize
 (only the socket buffer accounting would be off)


> but I don't think this assumption can be made (with or without KFENCE).
>
> With KFENCE, we actually end up testing no code assumes this, because
> KFENCE's ksize() always returns the exact size S.
>
> I have narrowed it down to sk_wmem_queued becoming <0 in
> sk_wmem_free_skb().
>
> The skb passed to sk_wmem_free_skb() and whose truesize causes
> sk_wmem_queued to become negative is always allocated in:
>
>  | kmem_cache_alloc_node+0x140/0x400 mm/slub.c:2939
>  | __alloc_skb+0x6d/0x710 net/core/skbuff.c:198
>  | alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
>  | sk_stream_alloc_skb+0x109/0xc30 net/ipv4/tcp.c:888
>  | tso_fragment net/ipv4/tcp_output.c:2124 [inline]
>  | tcp_write_xmit+0x1dbf/0x5ce0 net/ipv4/tcp_output.c:2674
>  | __tcp_push_pending_frames+0xaa/0x390 net/ipv4/tcp_output.c:2866
>  | tcp_push_pending_frames include/net/tcp.h:1864 [inline]
>  | tcp_data_snd_check net/ipv4/tcp_input.c:5374 [inline]
>  | tcp_rcv_established+0x8c9/0x1eb0 net/ipv4/tcp_input.c:5869
>  | tcp_v4_do_rcv+0x5d1/0x870 net/ipv4/tcp_ipv4.c:1668
>  | sk_backlog_rcv include/net/sock.h:1011 [inline]
>  | __release_sock+0x134/0x3a0 net/core/sock.c:2523
>  | release_sock+0x54/0x1b0 net/core/sock.c:3053
>  | sk_wait_data+0x177/0x450 net/core/sock.c:2565
>  | tcp_recvmsg+0x17ea/0x2aa0 net/ipv4/tcp.c:2181
>  | inet_recvmsg+0x11b/0x5d0 net/ipv4/af_inet.c:848
>  | sock_recvmsg_nosec net/socket.c:885 [inline]
>  | sock_recvmsg net/socket.c:903 [inline]
>  | sock_recvmsg net/socket.c:899 [inline]
>  | ____sys_recvmsg+0x2c4/0x600 net/socket.c:2563
>  | ___sys_recvmsg+0x127/0x200 net/socket.c:2605
>  | __sys_recvmsg+0xe2/0x1a0 net/socket.c:2641
>  | do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  | entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> I used the code below to add some warnings that helped narrow it down.
>
> Does any of this help explain the problem?

Not yet :)


tso_fragment() transfers some payload from one skb to another, and
properly shifts this amount from src skb to dst skb (@buff) :

sk_wmem_queued_add(sk, buff->truesize);
buff->truesize += nlen;
skb->truesize -= nlen;

>
> Thanks,
> -- Marco
>
> ------ >8 ------
>
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index e8d958ef3ea0..ef4837f3aba4 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -35,6 +35,7 @@
>  #ifndef _SOCK_H
>  #define _SOCK_H
>
> +#include <linux/kfence.h>
>  #include <linux/hardirq.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
> @@ -1534,7 +1535,15 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
>  DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
>  static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
>  {
> +       bool bad = false;
> +
>         sk_wmem_queued_add(sk, -skb->truesize);
> +
> +       if (WARN_ON(READ_ONCE(sk->sk_wmem_queued) == -384)) {
> +               pr_info("wmem_queued=%d truesize=%u\n", sk->sk_wmem_queued, skb->truesize);
> +               bad = true;
> +       }
> +
>         sk_mem_uncharge(sk, skb->truesize);
>         if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
>             !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
> @@ -1544,6 +1553,9 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
>                 return;
>         }
>         __kfree_skb(skb);
> +
> +       if (bad)
> +               (void)READ_ONCE(skb->truesize); /* UAF to let KASAN show where it was allocated */
>  }
>
>  static inline void sock_release_ownership(struct sock *sk)
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ffe3dcc0ebea..f365495819ee 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -208,6 +208,19 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>         size = SKB_DATA_ALIGN(size);
>         size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>         data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> +
> +       if (is_kfence_address(data))
> +               pr_info("kfence's ksize: %zu\n", ksize(data));
> +       /*
> +        *                              BUG BUG
> +        * Hypothesis: The problem is that some code assumes that:
> +        *
> +        *      ksize(kmalloc(S)) == ksize(kmalloc(S))
> +        *
> +        * Note: If we force no KFENCE allocation for @data above, the warnings
> +        * disappear. KFENCE's ksize() always returns the exact size S.
> +        */
> +
>         if (!data)
>                 goto nodata;
>         /* kmalloc(size) might give us more room than requested.
