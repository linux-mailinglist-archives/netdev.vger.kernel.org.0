Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CBC278BBB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgIYPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgIYPBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:01:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA4CC0613CE;
        Fri, 25 Sep 2020 08:01:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so3448017pff.6;
        Fri, 25 Sep 2020 08:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9SapnTkN1pVv9pY0ehp3UOR6C6TcWwI6L3FgoHPm9oY=;
        b=lNuY5wIinVeT4XEufmi5XK5E7qz/4K/6f0XJ9PGvrSsg/kBAC0Dcj1NEquhIeCHxUd
         zuK4ijDClRtArN307YONM9ve1QDW7j2emhovfF77Gk9Xd7xItPLbpm3wpzUNfIdMmeno
         KO7N+SycM0eKMSIQmS1lQGbKjDgat3e7mbZvyRiMHbi96VP0hRbngTRnhT9OBD8CdXKa
         K8hKF+F+aQbdBkQpINZHO46YBsAZmTAKENegcEOEnjMqrNX+IkDgMPHUWzD10MO0xQ25
         0+/QPjGBroO/X/z/fpprtBuy2aoUl78p+nIibXiIofcGPmtx275aFeJzMvCNOg3R/30D
         +Zug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9SapnTkN1pVv9pY0ehp3UOR6C6TcWwI6L3FgoHPm9oY=;
        b=FgsO6W9ZRoVBRmGBm4PZ/4Nydoufb6GATJtDfVi10Aj9Lx8UJgcwrkTn5GvgSaeyIR
         GbClAytjkazEQsnlluRmiM9GO1JpeImJKH3QL7SoupFPuY4Zc5+wheWd/tIbd3jE1xMg
         dypRUKncUPY52YSyKGknTpXowgepDoWrTrJn/Po7VlTMghddVOlQsLuOvgxc36T6BvKx
         YFv8tKm3vJSZWYJQh5TXeUhR1lBhpJ06Btw0JBPGFy+HYpSklEF69mmdHdrpfjggg+mh
         8954h/yI6Q2LDtHBg3KMH0ukDO5BLikBsHL4/HLU69iH8IXAW4YgnbzvscbRBBVczqDR
         fGmg==
X-Gm-Message-State: AOAM531NWP1yRPsS34D4cw1UMOKSXikST45aQVZ0LrUxQGqwEHzJaekf
        Ie8+9g9farI4d0+L3r3eVlCBo8hd0enPxRNcHSk=
X-Google-Smtp-Source: ABdhPJwO85jJfFdM8Un00PE4z/GUPCaggR0e5D8oat743cFWTiB+DR37c4jQIgM5E2EE3pZJGQNJWfaX2+xt51RKhsY=
X-Received: by 2002:a63:2e42:: with SMTP id u63mr403875pgu.292.1601046077984;
 Fri, 25 Sep 2020 08:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a821aa05b0246452@google.com>
In-Reply-To: <000000000000a821aa05b0246452@google.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 25 Sep 2020 17:01:06 +0200
Message-ID: <CAJ8uoz0uGupnd8dqu_X17QE5iV-81n7-CLkL5xES7zkvS_eHdQ@mail.gmail.com>
Subject: Re: general protection fault in xsk_release
To:     syzbot <syzbot+ddc7b4944bc61da19b81@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@chromium.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 4:47 PM syzbot
<syzbot+ddc7b4944bc61da19b81@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    3fc826f1 Merge branch 'net-dsa-bcm_sf2-Additional-DT-chang..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=158f8009900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=51fb40e67d1e3dec
> dashboard link: https://syzkaller.appspot.com/bug?extid=ddc7b4944bc61da19b81
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16372c81900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100bd2c3900000
>
> The issue was bisected to:
>
> commit 1c1efc2af158869795d3334a12fed2afd9c51539
> Author: Magnus Karlsson <magnus.karlsson@intel.com>
> Date:   Fri Aug 28 08:26:17 2020 +0000
>
>     xsk: Create and free buffer pool independently from umem

Thanks. On it.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=157a3103900000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=177a3103900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=137a3103900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ddc7b4944bc61da19b81@syzkaller.appspotmail.com
> Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
>
> RAX: ffffffffffffffda RBX: 00007fff675613c0 RCX: 0000000000443959
> RDX: 0000000000000030 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
> R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> R13: 0000000000000007 R14: 0000000000000000 R15: 0000000000000000
> general protection fault, probably for non-canonical address 0xdffffc00000000ad: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000568-0x000000000000056f]
> CPU: 0 PID: 6888 Comm: syz-executor811 Not tainted 5.9.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:dev_put include/linux/netdevice.h:3899 [inline]
> RIP: 0010:xsk_unbind_dev net/xdp/xsk.c:521 [inline]
> RIP: 0010:xsk_release+0x63f/0x7d0 net/xdp/xsk.c:591
> Code: 00 00 48 c7 85 c8 04 00 00 00 00 00 00 e8 29 a0 47 fe 48 8d bb 68 05 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 66 01 00 00 48 8b 83 68 05 00 00 65 ff 08 e9 54
> RSP: 0018:ffffc90005707c90 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff815b9de2
> RDX: 00000000000000ad RSI: ffffffff882d2317 RDI: 0000000000000568
> RBP: ffff888091aae000 R08: 0000000000000001 R09: ffffffff8d0ffaaf
> R10: fffffbfff1a1ff55 R11: 0000000000000000 R12: ffff888091aae5f8
> R13: ffff888091aae4c8 R14: dffffc0000000000 R15: 1ffff11012355cb5
> FS:  0000000000000000(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004c8b88 CR3: 0000000093ea3000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __sock_release+0xcd/0x280 net/socket.c:596
>  sock_close+0x18/0x20 net/socket.c:1277
>  __fput+0x285/0x920 fs/file_table.c:281
>  task_work_run+0xdd/0x190 kernel/task_work.c:141
>  exit_task_work include/linux/task_work.h:25 [inline]
>  do_exit+0xb7d/0x29f0 kernel/exit.c:806
>  do_group_exit+0x125/0x310 kernel/exit.c:903
>  __do_sys_exit_group kernel/exit.c:914 [inline]
>  __se_sys_exit_group kernel/exit.c:912 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x442588
> Code: Bad RIP value.
> RSP: 002b:00007fff67561328 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000442588
> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
> RBP: 00000000004c8b50 R08: 00000000000000e7 R09: ffffffffffffffd0
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000006dd280 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 9742ad575ae08359 ]---
> RIP: 0010:dev_put include/linux/netdevice.h:3899 [inline]
> RIP: 0010:xsk_unbind_dev net/xdp/xsk.c:521 [inline]
> RIP: 0010:xsk_release+0x63f/0x7d0 net/xdp/xsk.c:591
> Code: 00 00 48 c7 85 c8 04 00 00 00 00 00 00 e8 29 a0 47 fe 48 8d bb 68 05 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 66 01 00 00 48 8b 83 68 05 00 00 65 ff 08 e9 54
> RSP: 0018:ffffc90005707c90 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff815b9de2
> RDX: 00000000000000ad RSI: ffffffff882d2317 RDI: 0000000000000568
> RBP: ffff888091aae000 R08: 0000000000000001 R09: ffffffff8d0ffaaf
> R10: fffffbfff1a1ff55 R11: 0000000000000000 R12: ffff888091aae5f8
> R13: ffff888091aae4c8 R14: dffffc0000000000 R15: 1ffff11012355cb5
> FS:  0000000000000000(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004c8b88 CR3: 0000000093ea3000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
