Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361023E4D90
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhHIUDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhHIUDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:03:20 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B3FC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 13:02:59 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id p145so31732745ybg.6
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 13:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i0JLRWL5TMbvRtNonUz9cvKcT9d8NfVwxgykhHbRSe4=;
        b=dTtY5Fo2Wsvwaj3N0X2s8QdS420KSsH21JOjitzrd1ch126vipr5yaDU2g8GGRNXxW
         COPAbunb+Ae1PmS6cS/U8JrkF3ShPI2I1IjdxHoEaFTYxDJCNQMhsDoOhYPVg3W24Q+e
         jq1OAtRCcS+20CvDgMN//hihL92FyUNJEZDE44D47zV8RLeNFres5F7gbf/nJkg27cqs
         /urOQ/1XFJ9gT5QbxDGGxOWIP9f7QB4QlOpigj9LI/WVSnE+0aJxoPc0MERu4psx9v2J
         xRU3ZuKVKyD+8H+jyQeZ4nvfDKUWTlvass7KTNbstlwXjxqLS3e/wVvbS8ew4cL84RMe
         Ivqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i0JLRWL5TMbvRtNonUz9cvKcT9d8NfVwxgykhHbRSe4=;
        b=f2WOFBMS6k+0btkJRrNxefBsPfJw0ixuTcFo2G6DKSZYrYUl/xmelIWvR+OXZGWPn7
         rwGrhn+w2unTHdFJVUjOIealW4LP3C8YYtBhfhBf7aOo6vE/9ZBvoBZNvM3apoNq2+6T
         vawT14Fnd4wEfOixaSfxzhgldGYSiM7WQ8zN1ZxHmCtmvAkD4rJ8oYJBVwmd2icg+pYq
         a7iCerN001a5SXnT3JZseygafS1pj6D+AyUYFE99yxKjGkzW4ogwnHddijAIsLAuy5RE
         QG61yTVLLUOWYKF0ZDSwgbh7cLzxp33N7jua+j8ZUjkQG4KgFoCZPqSd4/d+anTWVTe5
         KoMg==
X-Gm-Message-State: AOAM532/P9DmWPs8Wqt6wFO57fa345i64THFuvK1ecMdI2hRVvDUZRcE
        MslKS0BTE60HQnQVUcPuYncu+ZIiKAsVAmflFH6czA==
X-Google-Smtp-Source: ABdhPJxJ/nHBDov7UvrFPFw6R7l5EhqUnNV+vwBpoVjQUC2j/dG8YrEjwErH6ii2PNQrbX+EmCtAbQarlkVX+3G8SYc=
X-Received: by 2002:a25:69d3:: with SMTP id e202mr35228164ybc.132.1628539378019;
 Mon, 09 Aug 2021 13:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006bd0b305c914c3dc@google.com> <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com> <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
In-Reply-To: <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Aug 2021 22:02:46 +0200
Message-ID: <CANn89iKcSvJ5U37q1Jz2gVYxVS=_ydNmDuTRZuAW=YvB+jGChg@mail.gmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in _copy_to_iter
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        jamorris@linux.microsoft.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 9:40 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>
>
> On 8/9/21 12:21 PM, Dmitry Vyukov wrote:
> > On Mon, 9 Aug 2021 at 21:16, Shoaib Rao <rao.shoaib@oracle.com> wrote:
> >> On 8/9/21 11:06 AM, Dmitry Vyukov wrote:
> >>> On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote=
:
> >>>> This seems like a false positive. 1) The function will not sleep bec=
ause
> >>>> it only calls copy routine if the byte is present. 2). There is no
> >>>> difference between this new call and the older calls in
> >>>> unix_stream_read_generic().
> >>> Hi Shoaib,
> >>>
> >>> Thanks for looking into this.
> >>> Do you have any ideas on how to fix this tool's false positive? Tools
> >>> with false positives are order of magnitude less useful than tools w/=
o
> >>> false positives. E.g. do we turn it off on syzbot? But I don't
> >>> remember any other false positives from "sleeping function called fro=
m
> >>> invalid context" checker...
> >> Before we take any action I would like to understand why the tool does
> >> not single out other calls to recv_actor in unix_stream_read_generic()=
.
> >> The context in all cases is the same. I also do not understand why the
> >> code would sleep, Let's assume the user provided address is bad, the
> >> code will return EFAULT, it will never sleep,
> > I always assumed that it's because if user pages are swapped out, it
> > may need to read them back from disk.
>
> Page faults occur all the time, the page may not even be in the cache or
> the mapping is not there (mmap), so I would not consider this a bug. The
> code should complain about all other calls as they are also copying  to
> user pages. I must not be following some semantics for the code to be
> triggered but I can not figure that out. What is the recommended
> interface to do user copy from kernel?

Are you aware of the difference between a mutex and a spinlock ?

When copying data from/to user, you can not hold a spinlock.


>
> Shoaib
>
> >
> >> if the kernel provided
> >> address is bad the system will panic. The only difference I see is tha=
t
> >> the new code holds 2 locks while the previous code held one lock, but
> >> the locks are acquired before the call to copy.
> >>
> >> So please help me understand how the tool works. Even though I have
> >> evaluated the code carefully, there is always a possibility that the
> >> tool is correct.
> >>
> >> Shoaib
> >>
> >>>
> >>>
> >>>> On 8/8/21 4:38 PM, syzbot wrote:
> >>>>> Hello,
> >>>>>
> >>>>> syzbot found the following issue on:
> >>>>>
> >>>>> HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb ove=
rride
> >>>>> git tree:       net-next
> >>>>> console output: https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/log.txt?x=3D12e3a69e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93=
iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHEdQcWD$
> >>>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/.config?x=3Daba0c23f8230e048__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU=
93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPLGp1-Za$
> >>>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/bug?extid=3D8760ca6c1ee783ac4abd__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6y=
rU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPCORTNOH$
> >>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU =
Binutils for Debian) 2.35.1
> >>>>> syz repro:      https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/repro.syz?x=3D15c5b104300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU=
93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPAjhi2yc$
> >>>>> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/repro.c?x=3D10062aaa300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93=
iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNzAjzQJ$
> >>>>>
> >>>>> The issue was bisected to:
> >>>>>
> >>>>> commit 314001f0bf927015e459c9d387d62a231fe93af3
> >>>>> Author: Rao Shoaib <rao.shoaib@oracle.com>
> >>>>> Date:   Sun Aug 1 07:57:07 2021 +0000
> >>>>>
> >>>>>        af_unix: Add OOB support
> >>>>>
> >>>>> bisection log:  https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/bisect.txt?x=3D10765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yr=
U93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPK2iWt2r$
> >>>>> final oops:     https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/report.txt?x=3D12765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yr=
U93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKAb0dft$
> >>>>> console output: https://urldefense.com/v3/__https://syzkaller.appsp=
ot.com/x/log.txt?x=3D14765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93=
iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNlW_w-u$
> >>>>>
> >>>>> IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> >>>>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
> >>>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> >>>>>
> >>>>> BUG: sleeping function called from invalid context at lib/iov_iter.=
c:619
> >>>>> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: =
syz-executor700
> >>>>> 2 locks held by syz-executor700/8443:
> >>>>>     #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_=
read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
> >>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock incl=
ude/linux/spinlock.h:354 [inline]
> >>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_re=
ad_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
> >>>>> Preemption disabled at:
> >>>>> [<0000000000000000>] 0x0
> >>>>> CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzka=
ller #0
> >>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 01/01/2011
> >>>>> Call Trace:
> >>>>>     __dump_stack lib/dump_stack.c:88 [inline]
> >>>>>     dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
> >>>>>     ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
> >>>>>     __might_fault+0x6e/0x180 mm/memory.c:5258
> >>>>>     _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
> >>>>>     copy_to_iter include/linux/uio.h:139 [inline]
> >>>>>     simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
> >>>>>     __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
> >>>>>     skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
> >>>>>     skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
> >>>>>     unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
> >>>>>     unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
> >>>>>     unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
> >>>>>     unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
> >>>>>     sock_recvmsg_nosec net/socket.c:944 [inline]
> >>>>>     sock_recvmsg net/socket.c:962 [inline]
> >>>>>     sock_recvmsg net/socket.c:958 [inline]
> >>>>>     ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
> >>>>>     ___sys_recvmsg+0x127/0x200 net/socket.c:2664
> >>>>>     do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
> >>>>>     __sys_recvmmsg net/socket.c:2837 [inline]
> >>>>>     __do_sys_recvmmsg net/socket.c:2860 [inline]
> >>>>>     __se_sys_recvmmsg net/socket.c:2853 [inline]
> >>>>>     __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
> >>>>>     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>>>>     do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >>>>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>>> RIP: 0033:0x43ef39
> >>>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 4=
8 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=
 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> >>>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
12b
> >>>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
> >>>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
> >>>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
> >>>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
> >>>>> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> >>>>>
> >>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >>>>> [ BUG: Invalid wait context ]
> >>>>> 5.14.0-rc3-syzkaller #0 Tainted: G        W
> >>>>> -----------------------------
> >>>>> syz-executor700/8443 is trying to lock:
> >>>>> ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+=
0xa3/0x180 mm/memory.c:5260
> >>>>> other info that might help us debug this:
> >>>>> context-{4:4}
> >>>>> 2 locks held by syz-executor700/8443:
> >>>>>     #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_=
read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
> >>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock incl=
ude/linux/spinlock.h:354 [inline]
> >>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_re=
ad_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
> >>>>> stack backtrace:
> >>>>> CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         =
5.14.0-rc3-syzkaller #0
> >>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 01/01/2011
> >>>>> Call Trace:
> >>>>>     __dump_stack lib/dump_stack.c:88 [inline]
> >>>>>     dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
> >>>>>     print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [=
inline]
> >>>>>     check_wait_context kernel/locking/lockdep.c:4727 [inline]
> >>>>>     __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
> >>>>>     lock_acquire kernel/locking/lockdep.c:5625 [inline]
> >>>>>     lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
> >>>>>     __might_fault mm/memory.c:5261 [inline]
> >>>>>     __might_fault+0x106/0x180 mm/memory.c:5246
> >>>>>     _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
> >>>>>     copy_to_iter include/linux/uio.h:139 [inline]
> >>>>>     simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
> >>>>>     __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
> >>>>>     skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
> >>>>>     skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
> >>>>>     unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
> >>>>>     unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
> >>>>>     unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
> >>>>>     unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
> >>>>>     sock_recvmsg_nosec net/socket.c:944 [inline]
> >>>>>     sock_recvmsg net/socket.c:962 [inline]
> >>>>>     sock_recvmsg net/socket.c:958 [inline]
> >>>>>     ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
> >>>>>     ___sys_recvmsg+0x127/0x200 net/socket.c:2664
> >>>>>     do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
> >>>>>     __sys_recvmmsg net/socket.c:2837 [inline]
> >>>>>     __do_sys_recvmmsg net/socket.c:2860 [inline]
> >>>>>     __se_sys_recvmmsg net/socket.c:2853 [inline]
> >>>>>     __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
> >>>>>     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>>>>     do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >>>>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>>> RIP: 0033:0x43ef39
> >>>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 4=
8 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=
 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> >>>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
12b
> >>>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
> >>>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
> >>>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
> >>>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000
> >>>>>
> >>>>>
> >>>>> ---
> >>>>> This report is generated by a bot. It may contain errors.
> >>>>> See https://urldefense.com/v3/__https://goo.gl/tpsmEJ__;!!ACWV5N9M2=
RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPG1UhbpZ$  f=
or more information about syzbot.
> >>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
> >>>>>
> >>>>> syzbot will keep track of this issue. See:
> >>>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*status__;Iw!!ACWV=
5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKlEx5v=
1$  for how to communicate with syzbot.
> >>>>> For information about bisection process see: https://urldefense.com=
/v3/__https://goo.gl/tpsmEJ*bisection__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6y=
rU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPJk7KaIr$
> >>>>> syzbot can test patches for this issue, for details see:
> >>>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*testing-patches__=
;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6J=
KlPMhq2hD3$
> >>>> --
> >>>> You received this message because you are subscribed to the Google G=
roups "syzkaller-bugs" group.
> >>>> To unsubscribe from this group and stop receiving emails from it, se=
nd an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> >>>> To view this discussion on the web visit https://urldefense.com/v3/_=
_https://groups.google.com/d/msgid/syzkaller-bugs/0c106e6c-672f-474e-5815-9=
7b65596139d*40oracle.com__;JQ!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_D=
PjyVIgQuZWyQbCo5IRkAzvYs6JKlPHjmYAGZ$ .
