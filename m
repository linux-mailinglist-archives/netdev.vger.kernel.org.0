Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B46181004
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCKF0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:26:25 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44406 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgCKF0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:26:24 -0400
Received: by mail-oi1-f196.google.com with SMTP id d62so658967oia.11;
        Tue, 10 Mar 2020 22:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8W+zYa184ZyKxjkQJutCEVqgw5AXS9GRHt9fLMAGBdg=;
        b=PzcLRaRey6wdIFrAxa/AOcg4B2xWVVZmbG1mpCZyFXf5IqLuchpXUiBr5XxLysTbGG
         Nduh2x8Vh+mPg82HyQygL8gT/+xM4cNz6kPLliUkbabGH2tr+4SxgSZkNZTsLr+PDmG0
         OctjLStigR7j4pN0qY2Yik5ewCsyklaO1lee58MuymVbMHU1ZGEiM7cmIKYJRsSz+gN3
         k6XU4UnweZ1cFFmekHZlfd7IMhdlCR2iRwpMbX9w80oOejDcoPJwbwFcWifvzGrsQWOa
         RXtzaADFYvA8O9WeG1w39hXRzTgldFS336zYt9JGWFUUBF8ha5F5Jed4OJ9nHqtgUvYJ
         Z8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8W+zYa184ZyKxjkQJutCEVqgw5AXS9GRHt9fLMAGBdg=;
        b=YabYhOjnS5Xknna6NNJhGnHCQ/PfdL7DFTA1ibCIH+rw32q1qsBc5hX1w1jjyoAZq4
         yfYwL2ZlZezVVih9wQObXjgFFaMfXvh2wZhZU0zISm1S593Mt7cvD0QXYwUkWKPq8ZBD
         BCtgyXrmyswmn4BYKmbWK/cMNTBmq5qmvLhk0VFXgbSZa3+5O3gDqKUY7sRzlAHmE9BW
         PPmdpxEO85/el6z6ILkqkOe8T5zC9UX3WfyhDdtif1Shqs//M45j1lluZUBMw+GZubRx
         OU2FEevjZM61gT1jX/7OtmrSX7Buza8aIbg9g/dIm+T86P/iAoe64Ch7EhOUlc8SmS14
         mIVg==
X-Gm-Message-State: ANhLgQ0kfliF19NDSV47m7ecB3M0liqqC2rNG+O5/RnPtTeufq0mGGtR
        P11719e29lHeU4YhYDrMU5WfsbW6qbfjccJHavO3AZuw
X-Google-Smtp-Source: ADFU+vu2XzxOxIEDf398NgTJGxQ8XLZbmiljOOXSim5zUgskWKUT3HnDcVnhOeqdxyBeQPERi7ieZdnjTaO3jmhsy6I=
X-Received: by 2002:aca:d489:: with SMTP id l131mr804061oig.5.1583904383212;
 Tue, 10 Mar 2020 22:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bf5ff105a01fef33@google.com> <20200306064428.16776-1-hdanton@sina.com>
In-Reply-To: <20200306064428.16776-1-hdanton@sina.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Mar 2020 22:26:11 -0700
Message-ID: <CAM_iQpXMZ9r_mPVVNuP6rU3=sBDkB=XoYyywD7HmTQF92fWapQ@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in tcf_queue_work
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 10:44 PM Hillf Danton <hdanton@sina.com> wrote:
>
>
> On Thu, 05 Mar 2020 10:45:10 -0800
> > syzbot found the following crash on:
> >
> > HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10535e45e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9c2df9fd5e9445b74e01
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168c4839e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10587419e00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
> > WARNING: CPU: 0 PID: 9599 at lib/debugobjects.c:485 debug_print_object+0x168/0x250 lib/debugobjects.c:485
> > Kernel panic - not syncing: panic_on_warn set ...
> > CPU: 0 PID: 9599 Comm: syz-executor772 Not tainted 5.6.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x197/0x210 lib/dump_stack.c:118
> >  panic+0x2e3/0x75c kernel/panic.c:221
> >  __warn.cold+0x2f/0x3e kernel/panic.c:582
> >  report_bug+0x289/0x300 lib/bug.c:195
> >  fixup_bug arch/x86/kernel/traps.c:174 [inline]
> >  fixup_bug arch/x86/kernel/traps.c:169 [inline]
> >  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
> >  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
> >  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> > RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:485
> > Code: dd 00 e7 91 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48 8b 14 dd 00 e7 91 88 48 c7 c7 60 dc 91 88 e8 07 6e 9f fd <0f> 0b 83 05 03 6c ff 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
> > RSP: 0018:ffffc90005cd70b0 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff815ebe46 RDI: fffff52000b9ae08
> > RBP: ffffc90005cd70f0 R08: ffff888093472400 R09: fffffbfff16a3370
> > R10: fffffbfff16a336f R11: ffffffff8b519b7f R12: 0000000000000001
> > R13: ffffffff89bac220 R14: 0000000000000000 R15: 1ffff92000b9ae24
> >  debug_object_activate+0x346/0x470 lib/debugobjects.c:652
> >  debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
> >  __call_rcu kernel/rcu/tree.c:2597 [inline]
> >  call_rcu+0x2f/0x700 kernel/rcu/tree.c:2683
> >  queue_rcu_work+0x8a/0xa0 kernel/workqueue.c:1742
> >  tcf_queue_work+0xd3/0x110 net/sched/cls_api.c:206
> >  route4_change+0x19e8/0x2250 net/sched/cls_route.c:550
> >  tc_new_tfilter+0xb82/0x2480 net/sched/cls_api.c:2103
> >  rtnetlink_rcv_msg+0x824/0xaf0 net/core/rtnetlink.c:5427
> >  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
> >  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5454
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> >  netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
> >  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xd7/0x130 net/socket.c:672
> >  ____sys_sendmsg+0x753/0x880 net/socket.c:2343
> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
> >  __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
> >  __do_sys_sendmsg net/socket.c:2439 [inline]
> >  __se_sys_sendmsg net/socket.c:2437 [inline]
> >  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
> >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Add a put callback for cls_route4_ops in an attempt to pair with get.

This does not look like a refcnt pairing issue, it seems to be a
double "free", more precisely, we call call_rcu() twice on the same
object. I guess for some reason 'fold' is still visible even after
it is scheduled to be freed by rcu work.

I will take a deeper look tomorrow.

Thanks.
