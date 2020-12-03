Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E582CDB56
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgLCQf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgLCQf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 11:35:26 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F28C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 08:34:45 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id w3so1663816otp.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 08:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XVteGchHtOzmJFepcy5/WYyW5Kf5SWgDk/ILWoFEap4=;
        b=M6WU7PhdKVNtphS9zBoZIPiQ9X09Cab4bw6GF/kD126Ah8eOwLtJ/dfGqD601vuEDZ
         FLU67qHGxNbWKTvzSWWDH/3kC2hBiiwLgNr9njKC3JcJ8PirVn3XJI5Fd+Yfyju+sv30
         ecEDVj3ZsUB/OphoQ1nmtwL/zAbECDu2hpIp0pYMufpeOUjWWg66tZo2A/RjIQglLGjd
         FcAf36la0kGLFA8BiwcPEQ54pXO43+kWdMAHRppb09bLAS3NBYM1RDazD6cNepweQ0sh
         cDOfFXb2GR+ZN69Oun5vU4189oUOG7N/BKL49DPc+GAbBThDfXEapdlAdAIjOyTO8sNw
         MCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XVteGchHtOzmJFepcy5/WYyW5Kf5SWgDk/ILWoFEap4=;
        b=ouMtQl/0sTyb9ZQ780XCy+y/2Cg2Ms0hz/ovs5Kw0kpT+Zzb/X043p6ZzIi9mixsVL
         i7m8+EuJme/EBeoCnqp9RJ9xpR6ppZ2lPMFbs8DKT4U4oeqJNmDrjXZ7fAlZVOpKOyhe
         1x5qFM9lNIbqKS+H1YGHiPJKOzhQntzeNlF+9hOltO5/7ZcrJK+Ws9ytc4awvl/GZuXq
         P1sN7aqDWE3/WW4PTmW6eSFDdb0mKBcQ7H0no4yD1fLxX2wsWIpuA3R7Vh4PC+opdxPU
         jdZYVCGlmtfexQ2A8mspwsLky65EgY81lKa42sOUmq1ALO9aVNs1XTEj0BnzQppZdrF2
         RZbw==
X-Gm-Message-State: AOAM5317gzp0LORbAATMzAS26yGCEIdjDYyD0rQ+Z/KFWt1O7UQAYwfM
        ofsvdJxN2Whw3wKZhkk0Ecewwj0HiqIbj0ge4Hxsi7mi6F2HZg==
X-Google-Smtp-Source: ABdhPJxcfQzo79JcYjYqftweBA4FlftG0Fwb7cfbuQRae0E3wBV/5z1g58WAeZWFikKws+6MKiMcpCp1aHWkZPhD9uc=
X-Received: by 2002:a9d:7d92:: with SMTP id j18mr2637985otn.17.1607013284854;
 Thu, 03 Dec 2020 08:34:44 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b4862805b54ef573@google.com> <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
In-Reply-To: <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 3 Dec 2020 17:34:33 +0100
Message-ID: <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
To:     Eric Dumazet <edumazet@google.com>
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

On Thu, 3 Dec 2020 at 17:27, Eric Dumazet <edumazet@google.com> wrote:
> On Thu, Dec 3, 2020 at 4:58 PM Marco Elver <elver@google.com> wrote:
> >
> > On Mon, Nov 30, 2020 at 12:40AM -0800, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    6147c83f Add linux-next specific files for 20201126
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=117c9679500000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=9b91566da897c24f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=7b99aafdcc2eedea6178
> > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103bf743500000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167c60c9500000
> > >
> > > The issue was bisected to:
> > >
> > > commit 145cd60fb481328faafba76842aa0fd242e2b163
> > > Author: Alexander Potapenko <glider@google.com>
> > > Date:   Tue Nov 24 05:38:44 2020 +0000
> > >
> > >     mm, kfence: insert KFENCE hooks for SLUB
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13abe5b3500000
> > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=106be5b3500000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=17abe5b3500000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
> > > Fixes: 145cd60fb481 ("mm, kfence: insert KFENCE hooks for SLUB")
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 11307 at net/core/stream.c:207 sk_stream_kill_queues+0x3c3/0x530 net/core/stream.c:207
> > [...]
> > > Call Trace:
> > >  inet_csk_destroy_sock+0x1a5/0x490 net/ipv4/inet_connection_sock.c:885
> > >  __tcp_close+0xd3e/0x1170 net/ipv4/tcp.c:2585
> > >  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2597
> > >  inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
> > >  __sock_release+0xcd/0x280 net/socket.c:596
> > >  sock_close+0x18/0x20 net/socket.c:1255
> > >  __fput+0x283/0x920 fs/file_table.c:280
> > >  task_work_run+0xdd/0x190 kernel/task_work.c:140
> > >  exit_task_work include/linux/task_work.h:30 [inline]
> > >  do_exit+0xb89/0x29e0 kernel/exit.c:823
> > >  do_group_exit+0x125/0x310 kernel/exit.c:920
> > >  get_signal+0x3ec/0x2010 kernel/signal.c:2770
> > >  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
> > >  handle_signal_work kernel/entry/common.c:144 [inline]
> > >  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > >  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
> > >  syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > I've been debugging this and I think enabling KFENCE uncovered that some
> > code is assuming that the following is always true:
> >
> >         ksize(kmalloc(S)) == ksize(kmalloc(S))
> >
>
>
> I do not think we make this assumption.
>
> Each skb tracks the 'truesize' which is populated from __alloc_skb()
> using ksize(allocated head) .
>
> So if ksize() decides to give us random data, it should be still fine,
> because we use ksize(buff) only once at alloc skb time, and record the
> value in skb->truesize
>  (only the socket buffer accounting would be off)

Good, thanks for clarifying. So something else must be off then.

> > but I don't think this assumption can be made (with or without KFENCE).
> >
> > With KFENCE, we actually end up testing no code assumes this, because
> > KFENCE's ksize() always returns the exact size S.
> >
> > I have narrowed it down to sk_wmem_queued becoming <0 in
> > sk_wmem_free_skb().
> >
> > The skb passed to sk_wmem_free_skb() and whose truesize causes
> > sk_wmem_queued to become negative is always allocated in:
> >
> >  | kmem_cache_alloc_node+0x140/0x400 mm/slub.c:2939
> >  | __alloc_skb+0x6d/0x710 net/core/skbuff.c:198
> >  | alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
> >  | sk_stream_alloc_skb+0x109/0xc30 net/ipv4/tcp.c:888
> >  | tso_fragment net/ipv4/tcp_output.c:2124 [inline]
> >  | tcp_write_xmit+0x1dbf/0x5ce0 net/ipv4/tcp_output.c:2674
> >  | __tcp_push_pending_frames+0xaa/0x390 net/ipv4/tcp_output.c:2866
> >  | tcp_push_pending_frames include/net/tcp.h:1864 [inline]
> >  | tcp_data_snd_check net/ipv4/tcp_input.c:5374 [inline]
> >  | tcp_rcv_established+0x8c9/0x1eb0 net/ipv4/tcp_input.c:5869
> >  | tcp_v4_do_rcv+0x5d1/0x870 net/ipv4/tcp_ipv4.c:1668
> >  | sk_backlog_rcv include/net/sock.h:1011 [inline]
> >  | __release_sock+0x134/0x3a0 net/core/sock.c:2523
> >  | release_sock+0x54/0x1b0 net/core/sock.c:3053
> >  | sk_wait_data+0x177/0x450 net/core/sock.c:2565
> >  | tcp_recvmsg+0x17ea/0x2aa0 net/ipv4/tcp.c:2181
> >  | inet_recvmsg+0x11b/0x5d0 net/ipv4/af_inet.c:848
> >  | sock_recvmsg_nosec net/socket.c:885 [inline]
> >  | sock_recvmsg net/socket.c:903 [inline]
> >  | sock_recvmsg net/socket.c:899 [inline]
> >  | ____sys_recvmsg+0x2c4/0x600 net/socket.c:2563
> >  | ___sys_recvmsg+0x127/0x200 net/socket.c:2605
> >  | __sys_recvmsg+0xe2/0x1a0 net/socket.c:2641
> >  | do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  | entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > I used the code below to add some warnings that helped narrow it down.
> >
> > Does any of this help explain the problem?
>
> Not yet :)

Damn...

> tso_fragment() transfers some payload from one skb to another, and
> properly shifts this amount from src skb to dst skb (@buff) :
>
> sk_wmem_queued_add(sk, buff->truesize);
> buff->truesize += nlen;
> skb->truesize -= nlen;

Any other stacktraces that might help?

Thanks,
-- Marco
