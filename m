Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC1F50CE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKHQPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:15:14 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45979 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfKHQPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:15:14 -0500
Received: by mail-qk1-f193.google.com with SMTP id q70so5705623qke.12
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 08:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VprtH8LpSA2C0RoW/En0kv7aKrRt2gpW6XPcJVTh2IQ=;
        b=pnVTrbURfNh6YBpyTtMajVC7W5UADZCzTJYCF8GwdQbhbC1lisCeyqWbo/6ewR7YnU
         248jRmi41ct/VEv4uoSckmnIAROqMlJ4wJ4ACJ1PHa46AWJ9hqJuO8YRX1/FbHnKlbq+
         mAuqsNaPzLx5Gdiz7iuwGkgQ7IyyEt+S0n1eI+AG5mRICtVHym6leNNPnD9mASIyYArB
         Q0X05441/Bh0z6dW0l5HADvuYZ/6VCefFTycB2jt/uYmTVXEYAXBp0ArbRejlwrIFJav
         eZsy6hiKRhZFSJjNOxI80FCeDYg2ca8WWgZxWBc60SNBYR9P7aN8Alr/4Q7Y/I1dVouU
         vULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VprtH8LpSA2C0RoW/En0kv7aKrRt2gpW6XPcJVTh2IQ=;
        b=Q4mEdRBQCGBPYBrj6JC+88mmif7FeQSAdvmaLADhOGgKUZFKfw83vsDrdBcaXhfOSM
         dnPrvA+oaFt5K3fLPri2jxJhw98cz2KAdP1FH3VFvgPyooQe5tWEDLLN9OLwEzOc+ZcA
         1UKpzxI8em5j48o70gBu3vIhda7DLKseqe/vRSxzh9fN4HJsTp0V2ffsFOm5CE9pBH3H
         iSyQzH7MLt1+6vHVcbC+aF3NSzTI62908pkwOKkbtOOHa+vyC17PVJo8MQZy8rpwUwDN
         aJCYItWZkHbgnqRdQUR98fKyNJXbeUd3jcKdjhj+8e/QeM+ThMzJ78qL0dLBZXdyNfJc
         FTlQ==
X-Gm-Message-State: APjAAAUfdY2qQ+yIK15SS4joSAigH895965w6iGZJSawyVL0CSO5CW7j
        GLP+8LyGH+1h+UHBefPddVNfBfGfDHfo49yLi9SzNg==
X-Google-Smtp-Source: APXvYqxXO3v+z8Ca7H7xAWxtQ0sQ0IOvsdL+7cUSlTtEdDZCBpgN8p4AHITNn8VZKrDo4yNrk6vQO2ClSj1w7tM5rnM=
X-Received: by 2002:a37:8e81:: with SMTP id q123mr9858170qkd.250.1573229712422;
 Fri, 08 Nov 2019 08:15:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e3a8e00596d7ca32@google.com>
In-Reply-To: <000000000000e3a8e00596d7ca32@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 8 Nov 2019 17:15:00 +0100
Message-ID: <CACT4Y+bOy+OOp2h=jNYJB8xBhQ9x_=MEgP-XcU7KHs7v1v0YPA@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in kernel_sendmsg
To:     syzbot <syzbot+4b6f070bb7a8ea5420d4@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 4:54 PM syzbot
<syzbot+4b6f070bb7a8ea5420d4@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    124037e0 kmsan: drop inlines, rename do_kmsan_task_create()
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=1648eb9d600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f03c659d0830ab8d
> dashboard link: https://syzkaller.appspot.com/bug?extid=4b6f070bb7a8ea5420d4
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+4b6f070bb7a8ea5420d4@syzkaller.appspotmail.com

I think this is:

#syz dup: KMSAN: use-after-free in rxrpc_send_keepalive

https://syzkaller.appspot.com/bug?id=428e72dc175d0f4b23a1fb9b7d3d16fad7ef2a4b

> =====================================================
> BUG: KMSAN: uninit-value in rxrpc_send_keepalive+0x2fa/0x830
> net/rxrpc/output.c:655
> CPU: 0 PID: 3367 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: krxrpcd rxrpc_peer_keepalive_worker
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>   kmsan_report+0x13a/0x2b0 mm/kmsan/kmsan_report.c:108
>   __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
>   sock_sendmsg_nosec net/socket.c:637 [inline]
>   sock_sendmsg net/socket.c:657 [inline]
>   kernel_sendmsg+0x2c9/0x440 net/socket.c:677
>   rxrpc_send_keepalive+0x2fa/0x830 net/rxrpc/output.c:655
>   rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:369 [inline]
>   rxrpc_peer_keepalive_worker+0xb82/0x1510 net/rxrpc/peer_event.c:430
>   process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
>   worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
>   kthread+0x4b5/0x4f0 kernel/kthread.c:256
>   ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355
>
> Uninit was created at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
>   kmsan_internal_poison_shadow+0x53/0x100 mm/kmsan/kmsan.c:134
>   kmsan_slab_alloc+0xaa/0x120 mm/kmsan/kmsan_hooks.c:103
>   slab_alloc_node mm/slub.c:2790 [inline]
>   slab_alloc mm/slub.c:2799 [inline]
>   kmem_cache_alloc_trace+0x8c5/0xd20 mm/slub.c:2816
>   kmalloc include/linux/slab.h:552 [inline]
>   __hw_addr_create_ex net/core/dev_addr_lists.c:30 [inline]
>   __hw_addr_add_ex net/core/dev_addr_lists.c:76 [inline]
>   __hw_addr_add net/core/dev_addr_lists.c:84 [inline]
>   dev_addr_init+0x152/0x700 net/core/dev_addr_lists.c:464
>   alloc_netdev_mqs+0x2a9/0x1650 net/core/dev.c:9150
>   rtnl_create_link+0x559/0x1190 net/core/rtnetlink.c:2931
>   __rtnl_newlink net/core/rtnetlink.c:3186 [inline]
>   rtnl_newlink+0x2757/0x38d0 net/core/rtnetlink.c:3254
>   rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5223
>   netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
>   rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5241
>   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>   netlink_unicast+0xf6c/0x1050 net/netlink/af_netlink.c:1328
>   netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
>   sock_sendmsg_nosec net/socket.c:637 [inline]
>   sock_sendmsg net/socket.c:657 [inline]
>   ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
>   __sys_sendmsg net/socket.c:2356 [inline]
>   __do_sys_sendmsg net/socket.c:2365 [inline]
>   __se_sys_sendmsg+0x305/0x460 net/socket.c:2363
>   __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2363
>   do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
>   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> =====================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e3a8e00596d7ca32%40google.com.
