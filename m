Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193823E4BD6
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhHISGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhHISGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:06:40 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DCBC061799
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:06:19 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id t68so19378329qkf.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 11:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CGmEoCtBX+aMJQ4a81RMibRVxxMCeoipo6oy6wjvfSQ=;
        b=jRV0H6Z2ydK10xOgbktUO/i/wkll9LyxEjGa5LjNWcliEDU8ZsvmcJ+Gc/hqQvpyXj
         B6bCrJs/He3A61egpX3Ah1n5Ip0SSwnmSxOVmA+OO2tSg4gUMj6SZdXBCRBUA8+EacfI
         895Y6N7YVtjuPR15arE9vULuRy5Q9Yd6+5OkQhDW5PK11e9u7JIfSwOvrj6PsiFPl2e2
         7iMK4eTy5udO0c27wrYr4MbA4RA3rdkt3Fa/j47kXwY+d+NFV3+I7l0c4PCVXmmjop59
         gi6iFz8TnfJNPsPvW25iD6QP1BmZzRSM4NZu4vKjPNag+tbB9MHK9b7rd+clVPaPnYAm
         4O6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CGmEoCtBX+aMJQ4a81RMibRVxxMCeoipo6oy6wjvfSQ=;
        b=NFcJuyCF+ldkagntx7MGaC/6MFLF62r/yTTyWrvVVcTYgQal3cn12B57cpZHQAU/M/
         sagVhDpsPPXpK3buEFMPtHPb5TNJARsBP/Yinh8g3id2KEhlS5+n/cF441mz6N1Q4VIp
         PKHiWiyRsEqDSD4Rt1LuMfKqOquBRjkWql8fMfEDYADSVcGvgJf/1oiSHXzMCGr2gW4A
         CY0Vl0AUDRmfUuI1vnKi5hlAaKb2b9iS0f162cSE7ak6T45tZF70YfhzRU+vhqGUz3Mp
         yas8nKr8MKdU7U8QQgad3TngcLmGgNe2KARPbRoksvZ4116bh6XUCpUyLvPXKh8VvG28
         EM8w==
X-Gm-Message-State: AOAM531WDFoax9hXlCThsPST+LOu5H44/FSjwi1VLAg+S2oaLZp/ZjTX
        evpfYlBC88ymwneB6EqpcBVUoZy3v2esEHtebQjZhw==
X-Google-Smtp-Source: ABdhPJy0sRwnoX2TrDLzLvLmgEYmEH0OEZngM0N3qvIsUY0vMGaZL3Qvv8ZLyhSQZB20TWM1tctSbAPyMh4yHQFKMXI=
X-Received: by 2002:a05:620a:811:: with SMTP id s17mr7321838qks.350.1628532378369;
 Mon, 09 Aug 2021 11:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006bd0b305c914c3dc@google.com> <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
In-Reply-To: <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 9 Aug 2021 20:06:06 +0200
Message-ID: <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in _copy_to_iter
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>
> This seems like a false positive. 1) The function will not sleep because
> it only calls copy routine if the byte is present. 2). There is no
> difference between this new call and the older calls in
> unix_stream_read_generic().

Hi Shoaib,

Thanks for looking into this.
Do you have any ideas on how to fix this tool's false positive? Tools
with false positives are order of magnitude less useful than tools w/o
false positives. E.g. do we turn it off on syzbot? But I don't
remember any other false positives from "sleeping function called from
invalid context" checker...



> On 8/8/21 4:38 PM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12e3a69e300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8760ca6c1ee783ac4abd
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c5b104300000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10062aaa300000
> >
> > The issue was bisected to:
> >
> > commit 314001f0bf927015e459c9d387d62a231fe93af3
> > Author: Rao Shoaib <rao.shoaib@oracle.com>
> > Date:   Sun Aug 1 07:57:07 2021 +0000
> >
> >      af_unix: Add OOB support
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10765f8e300000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=12765f8e300000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14765f8e300000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
> > Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> >
> > BUG: sleeping function called from invalid context at lib/iov_iter.c:619
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: syz-executor700
> > 2 locks held by syz-executor700/8443:
> >   #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
> >   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> >   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
> > Preemption disabled at:
> > [<0000000000000000>] 0x0
> > CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:88 [inline]
> >   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
> >   ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
> >   __might_fault+0x6e/0x180 mm/memory.c:5258
> >   _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
> >   copy_to_iter include/linux/uio.h:139 [inline]
> >   simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
> >   __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
> >   skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
> >   skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
> >   unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
> >   unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
> >   unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
> >   unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
> >   sock_recvmsg_nosec net/socket.c:944 [inline]
> >   sock_recvmsg net/socket.c:962 [inline]
> >   sock_recvmsg net/socket.c:958 [inline]
> >   ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
> >   ___sys_recvmsg+0x127/0x200 net/socket.c:2664
> >   do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
> >   __sys_recvmmsg net/socket.c:2837 [inline]
> >   __do_sys_recvmmsg net/socket.c:2860 [inline]
> >   __se_sys_recvmmsg net/socket.c:2853 [inline]
> >   __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
> >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x43ef39
> > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> > RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
> > RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
> > RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
> > R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
> > R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> >
> > =============================
> > [ BUG: Invalid wait context ]
> > 5.14.0-rc3-syzkaller #0 Tainted: G        W
> > -----------------------------
> > syz-executor700/8443 is trying to lock:
> > ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5260
> > other info that might help us debug this:
> > context-{4:4}
> > 2 locks held by syz-executor700/8443:
> >   #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
> >   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> >   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
> > stack backtrace:
> > CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         5.14.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:88 [inline]
> >   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
> >   print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [inline]
> >   check_wait_context kernel/locking/lockdep.c:4727 [inline]
> >   __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
> >   lock_acquire kernel/locking/lockdep.c:5625 [inline]
> >   lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
> >   __might_fault mm/memory.c:5261 [inline]
> >   __might_fault+0x106/0x180 mm/memory.c:5246
> >   _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
> >   copy_to_iter include/linux/uio.h:139 [inline]
> >   simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
> >   __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
> >   skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
> >   skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
> >   unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
> >   unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
> >   unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
> >   unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
> >   sock_recvmsg_nosec net/socket.c:944 [inline]
> >   sock_recvmsg net/socket.c:962 [inline]
> >   sock_recvmsg net/socket.c:958 [inline]
> >   ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
> >   ___sys_recvmsg+0x127/0x200 net/socket.c:2664
> >   do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
> >   __sys_recvmmsg net/socket.c:2837 [inline]
> >   __do_sys_recvmmsg net/socket.c:2860 [inline]
> >   __se_sys_recvmmsg net/socket.c:2853 [inline]
> >   __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
> >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x43ef39
> > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> > RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
> > RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
> > RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
> > R10: 0000000000000007 R11: 0000000000000246 R12: 0000
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0c106e6c-672f-474e-5815-97b65596139d%40oracle.com.
