Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647EC46FF93
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbhLJLQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbhLJLQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 06:16:49 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79D9C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:13:14 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so20561272ybe.3
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gp+vXI/o7ABwGXzoi8ueAdlrDulo4jgOklxQZplQ/98=;
        b=DGXd7V/OIR0+dN7iBbquGI9KUiGP9BWfnD2P5EtUdrjMRgAHCayA6j5xhwjzlWXw5K
         GDHq4Mco2rHy3mBDv9dbsGneXeKFoP/gx+to+lwA3rfsvHxoobCvrm5XmuLTQM7Y2gKE
         bo+YG7zRu7aWasiBQVH/yGvete3XhVHGdQbqhceZY2RmNyT4Q1ra9NKow7LL+Nd5JbYN
         De5JAbzmICAr1pTopuVEjnDBvSoZYhZWubXyJhgpZIf50DUZyc6PLCYKhJ74rsvkZxIr
         IwNRdNl07lm9ezURr3dv+8sDaAHDgk2QPFXo7ZFaj2n0qjsXVNWUFxHLswofDSRfvy6A
         1YBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gp+vXI/o7ABwGXzoi8ueAdlrDulo4jgOklxQZplQ/98=;
        b=X7qcMNz58UTsTWopLav5lyqkmfCoMSTPe4xf8z2Moc8SEtfb0kDF70qYu6j5SEIxcR
         EhrtgOR5O5uZ5rqOwKYFpaeJzX/E0Enq0BvNcIQxibUCihcCWAHXqFllldYS/JxTUCQR
         BOailp+DQ+n1aPkmDl84TW2lkLz58LOvzasVlHmku6f/J8PBM1sPVB/puO14xx/D+HrL
         B+o1kZjcmz7LLwgsvlq+QKqKFkZ5DcW+/jM7qzYSNkHK5GBWfPgjPw5/2I7atyKZdA8V
         XsigRMX09rS86WNxFN2XuH0R5P+KLl1Eijns0sQUq7O8cd0ZZtJJ4eDFuIS7M0sAUPC5
         jOMQ==
X-Gm-Message-State: AOAM533pBVDqptf2Gb4BFZ2z2AoqyR7GjqcKtSOfDgyeC2ajZzOsc57w
        Rij7QBA9hObNb1a2UDEzLlNahO/D+dZ2prODZzj/1w==
X-Google-Smtp-Source: ABdhPJzUnAhrnh06D/ANUlrFK3ANchhfRIAJ5sdBiHy8Xsx66eQgzZu4N/yCGaKnfJQgHgyFA1rYeKy82wT+8iqLz+A=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr14324103ybg.711.1639134793563;
 Fri, 10 Dec 2021 03:13:13 -0800 (PST)
MIME-Version: 1.0
References: <0000000000004c679505d2c8c1d4@google.com>
In-Reply-To: <0000000000004c679505d2c8c1d4@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Dec 2021 03:13:02 -0800
Message-ID: <CANn89iKJY21Y3MZMXBpVqNm6BhudgfE+c-v7EU8gMUcbEFVs+A@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in inet_csk_accept
To:     syzbot <syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 3:09 AM syzbot
<syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    2a987e65025e Merge tag 'perf-tools-fixes-for-v5.16-2021-12..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=166f73adb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=221ffc09e39ebbd1
> dashboard link: https://syzkaller.appspot.com/bug?extid=e4d843bb96a9431e6331
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16280ae5b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1000fdc5b00000
>
> The issue was bisected to:
>

Note to MPTCP maintainers, I think this issue is MPTCP one, and the
bisection result
shown here seems not relevant.

The C repro is however correct, I trigger an immediate crash.


> commit 7f700334be9aeb91d5d86ef9ad2d901b9b453e9b
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Mon Mar 29 18:39:51 2021 +0000
>
>     ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117fe575b00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=137fe575b00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=157fe575b00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com
> Fixes: 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")
>
> general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 PID: 6550 Comm: syz-executor122 Not tainted 5.16.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4897
> Code: 0f 0e 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 69 cc 0f 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b 20 75 17 8f 0f 84 52 f3 ff
> RSP: 0018:ffffc90001f2f818 EFLAGS: 00010016
> RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: 000000000000000a R12: 0000000000000000
> R13: ffff88801b98d700 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007f177cd3d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f177cd1b268 CR3: 000000001dd55000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  lock_acquire kernel/locking/lockdep.c:5637 [inline]
>  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
>  finish_wait+0xc0/0x270 kernel/sched/wait.c:400
>  inet_csk_wait_for_connect net/ipv4/inet_connection_sock.c:464 [inline]
>  inet_csk_accept+0x7de/0x9d0 net/ipv4/inet_connection_sock.c:497
>  mptcp_accept+0xe5/0x500 net/mptcp/protocol.c:2865
>  inet_accept+0xe4/0x7b0 net/ipv4/af_inet.c:739
>  mptcp_stream_accept+0x2e7/0x10e0 net/mptcp/protocol.c:3345
>  do_accept+0x382/0x510 net/socket.c:1773
>  __sys_accept4_file+0x7e/0xe0 net/socket.c:1816
>  __sys_accept4+0xb0/0x100 net/socket.c:1846
>  __do_sys_accept net/socket.c:1864 [inline]
>  __se_sys_accept net/socket.c:1861 [inline]
>  __x64_sys_accept+0x71/0xb0 net/socket.c:1861
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f177cd8b8e9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f177cd3d308 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
> RAX: ffffffffffffffda RBX: 00007f177ce13408 RCX: 00007f177cd8b8e9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007f177ce13400 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f177ce1340c
> R13: 00007f177cde1004 R14: 6d705f706374706d R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace 77ed64e4985d56c9 ]---
> RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4897
> Code: 0f 0e 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 69 cc 0f 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b 20 75 17 8f 0f 84 52 f3 ff
> RSP: 0018:ffffc90001f2f818 EFLAGS: 00010016
> RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: 000000000000000a R12: 0000000000000000
> R13: ffff88801b98d700 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007f177cd3d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f177cd1b268 CR3: 000000001dd55000 CR4: 0000000000350ee0
> ----------------
> Code disassembly (best guess):
>    0:   0f 0e                   femms
>    2:   41 be 01 00 00 00       mov    $0x1,%r14d
>    8:   0f 86 c8 00 00 00       jbe    0xd6
>    e:   89 05 69 cc 0f 0e       mov    %eax,0xe0fcc69(%rip)        # 0xe0fcc7d
>   14:   e9 bd 00 00 00          jmpq   0xd6
>   19:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   20:   fc ff df
>   23:   48 89 da                mov    %rbx,%rdx
>   26:   48 c1 ea 03             shr    $0x3,%rdx
> * 2a:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   2e:   0f 85 f3 2f 00 00       jne    0x3027
>   34:   48 81 3b 20 75 17 8f    cmpq   $0xffffffff8f177520,(%rbx)
>   3b:   0f                      .byte 0xf
>   3c:   84 52 f3                test   %dl,-0xd(%rdx)
>   3f:   ff                      .byte 0xff
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
