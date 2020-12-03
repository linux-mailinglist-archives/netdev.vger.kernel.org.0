Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06AA2CDB76
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgLCQnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgLCQnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 11:43:47 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0A7C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 08:43:07 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id o8so2737725ioh.0
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 08:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SNo5GJuMpFLQs7AHm08/krS1qXhCMvpmFpsQ8ALd4rI=;
        b=Q9A1pAvrtcTQgfC5VsLb86iMlI1OW74d+Orz9VfLqThry56eyqc5UBlSpETr26IbZk
         jft5kO7jFMcaMiuITL1CH5CRgftBs8sG4v9MnHhpNNFuToTkSyGcDevrSEPnwDDpilta
         NqfVrQLLUyZbk/9wlZSj6lUsDIo7TYlJNkvGXifer567svocaecqgxlk0MPSt1dKG8Dz
         ZW1r8SOaSvrkQeskx1HnHjRHRN6smspaepvd/bFAhzFUXc9I1a5Rn7F099SVTuDTLsd1
         huXwHfX7hAs55Mmd53DWD+DCh5vu/cCeurbDkl/aky7a5N92DFLg/h55RPf0RBq0inyX
         z8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SNo5GJuMpFLQs7AHm08/krS1qXhCMvpmFpsQ8ALd4rI=;
        b=Nj+X89pjAR69i9KaB9tWpRpZDaV8xAHtdlVS1/NMNFWhDhBL3A5Hr7GfGrM+MH7I+o
         4DskUodHqNLuvYDc4oWPHYXa8Y1sIIQuPW1b3YGG43WyLYOhAK8+FgU4uOiV20oEDOjZ
         sOA3WvIUvstaEqJYxoQsp1RkL9Nal8pxlVaSOIH5mSlOUk63rH/iCnldusQRD3ouhB6v
         aa6IgYPpCx3l0Mqjm7HeAjYgqyJHGsreIpkWanUkpdYnc+8skajkVmBc7h3iS92R0l3h
         utYHD+b+L8EvHbNqGMAcWtkrdPvl5xZrf3XrJ/MigywFyyLLgWGDfhwSNjKhfjcISxRv
         qM4w==
X-Gm-Message-State: AOAM531VAIlxbymH9Sq5Gc3rHJm7+qaqrMcaGPouUXM+1TVspbPgoPVy
        KU0eas1CmGEEv1VdF6XXqvdiCy22oHFzOLf4l7NhfnXSIsjAXHgc
X-Google-Smtp-Source: ABdhPJxY9wwty7iOybffshV/Jnh9deiZ98su7ihtxzLAJduk6yyn9Ip7JSB47ZAZ/4+WaKWBrYtIfKJGQPGYGeEhkWU=
X-Received: by 2002:a6b:6418:: with SMTP id t24mr3814893iog.145.1607013786217;
 Thu, 03 Dec 2020 08:43:06 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b4862805b54ef573@google.com> <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com> <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
In-Reply-To: <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Dec 2020 17:42:54 +0100
Message-ID: <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
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

On Thu, Dec 3, 2020 at 5:34 PM Marco Elver <elver@google.com> wrote:
>
> On Thu, 3 Dec 2020 at 17:27, Eric Dumazet <edumazet@google.com> wrote:
> > On Thu, Dec 3, 2020 at 4:58 PM Marco Elver <elver@google.com> wrote:
> > >
> > > On Mon, Nov 30, 2020 at 12:40AM -0800, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    6147c83f Add linux-next specific files for 20201126
> > > > git tree:       linux-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=117c9679500000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=9b91566da897c24f
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=7b99aafdcc2eedea6178
> > > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103bf743500000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167c60c9500000
> > > >
> > > > The issue was bisected to:
> > > >
> > > > commit 145cd60fb481328faafba76842aa0fd242e2b163
> > > > Author: Alexander Potapenko <glider@google.com>
> > > > Date:   Tue Nov 24 05:38:44 2020 +0000
> > > >
> > > >     mm, kfence: insert KFENCE hooks for SLUB
> > > >
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13abe5b3500000
> > > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=106be5b3500000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17abe5b3500000
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
> > > > Fixes: 145cd60fb481 ("mm, kfence: insert KFENCE hooks for SLUB")
> > > >
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 0 PID: 11307 at net/core/stream.c:207 sk_stream_kill_queues+0x3c3/0x530 net/core/stream.c:207
> > > [...]
> > > > Call Trace:
> > > >  inet_csk_destroy_sock+0x1a5/0x490 net/ipv4/inet_connection_sock.c:885
> > > >  __tcp_close+0xd3e/0x1170 net/ipv4/tcp.c:2585
> > > >  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2597
> > > >  inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
> > > >  __sock_release+0xcd/0x280 net/socket.c:596
> > > >  sock_close+0x18/0x20 net/socket.c:1255
> > > >  __fput+0x283/0x920 fs/file_table.c:280
> > > >  task_work_run+0xdd/0x190 kernel/task_work.c:140
> > > >  exit_task_work include/linux/task_work.h:30 [inline]
> > > >  do_exit+0xb89/0x29e0 kernel/exit.c:823
> > > >  do_group_exit+0x125/0x310 kernel/exit.c:920
> > > >  get_signal+0x3ec/0x2010 kernel/signal.c:2770
> > > >  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
> > > >  handle_signal_work kernel/entry/common.c:144 [inline]
> > > >  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > > >  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
> > > >  syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > I've been debugging this and I think enabling KFENCE uncovered that some
> > > code is assuming that the following is always true:
> > >
> > >         ksize(kmalloc(S)) == ksize(kmalloc(S))
> > >
> >
> >
> > I do not think we make this assumption.
> >
> > Each skb tracks the 'truesize' which is populated from __alloc_skb()
> > using ksize(allocated head) .
> >
> > So if ksize() decides to give us random data, it should be still fine,
> > because we use ksize(buff) only once at alloc skb time, and record the
> > value in skb->truesize
> >  (only the socket buffer accounting would be off)
>
> Good, thanks for clarifying. So something else must be off then.

Actually we might have the following assumption :

buff = kmalloc(size, GFP...)
if (buff)
   ASSERT(ksize(buff) >= size)

So obviously ksize() should not be completely random ;)
