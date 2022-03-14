Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12CE4D7D82
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbiCNIXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiCNIXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:23:43 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691DD3F331
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:22:34 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id q1-20020a4a7d41000000b003211b63eb7bso19132369ooe.6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8vQvcGyy0rYgftx2Yc2XT0ACGiuR9Ihxe6RDNdNUfwc=;
        b=PjqrIeT55pkgaDGrJFtDFNm1BV+gY0tiKCY44bf81YF9E5HmgxfigjJ1D5teDB6Zer
         o3MR/iuP1UCvqSXGwD/OVKb0A3qO4cf2knVrLg6L1CQn5xdroz2YZc8t1Yjrs/TcF/Y7
         WdUGa/8G7442N+Oe7LKJqZ6G2Wt/szuJugRic4rq3iqAgtAHNxvayecGVgq1VUHkALwz
         N7BbKs8cGmMcaUgUO2qOYN95iN+pmsGql+ITow3SNsFRBwq+P4IQeYLj1naoJGWI46OA
         D7neZ1VUDT+bmdemAvQBU9OmP1sg3iXyDsB6/2zd2Z97iP1WYkh7Te598CX9j4vnlAwz
         bP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8vQvcGyy0rYgftx2Yc2XT0ACGiuR9Ihxe6RDNdNUfwc=;
        b=G1Y4FqKymVFdomwvbZV8f9QIwxfPOeeIJ76PtVJFTm9e+O8vkozbUGWB6GY25SckBQ
         SG/gJ/TCEcJ2I8/+m6xEEtXbwwQqelCmrjP2dTQ/rvmdSqT28i97/i8SYiEz5d8TMNtr
         D0YC7GGVqE0bVGPnUYgxE08GPKiS0863n2b3LtSTrlDKKBB9ZQn4IoAnlxQ5FnLn5UMo
         fDdaD8q24Hy5QBqWhzxFtfLKmoG7Hv8WsfiIwicIH1B+lvJKUd+zfsQgQk4wYGWcaXwI
         CuRRcW0A8RcbfAJNyS6nBS0VJh7sRpSF7ZFgdwv4blB46pWMwJ177AFJySheVCV/9q2V
         +9Dw==
X-Gm-Message-State: AOAM533WUIhBiLv6dQu7E8Se/gpknOZACgm5bEgNOBD/ZygjraJCxdfw
        TFIq/P2N8Ac39CzekGCpxktNw5UU22Ym0EbPHuTRUw==
X-Google-Smtp-Source: ABdhPJz0UxEmWlSuhZ60ezH0GRVg2JGo08gwnzrMt1/E0BNBdoaDgSQ5ZC75HqIKpPbr8+cMq/2KyiB+UTmAfKi44ik=
X-Received: by 2002:a05:6870:d254:b0:db:12b5:da3 with SMTP id
 h20-20020a056870d25400b000db12b50da3mr1871730oac.211.1647246153379; Mon, 14
 Mar 2022 01:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008ec53005da294fe9@google.com>
In-Reply-To: <0000000000008ec53005da294fe9@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 14 Mar 2022 09:22:22 +0100
Message-ID: <CACT4Y+YXzBGuj4mn2fnBWw4szbb4MsAvNScbyNXi1S21MXm8ig@mail.gmail.com>
Subject: Re: [syzbot] kernel panic: corrupted stack end in rtnl_newlink
To:     syzbot <syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 at 09:17, syzbot
<syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0966d385830d riscv: Fix auipc+jalr relocation range checks
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> console output: https://syzkaller.appspot.com/x/log.txt?x=17fe80c5700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6295d67591064921
> dashboard link: https://syzkaller.appspot.com/bug?extid=0600986d88e2d4d7ebb8
> compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: riscv64

+linux-riscv

Riscv needs to increase stack size under KASAN.
I will send a patch.

> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com
>
> Kernel panic - not syncing: corrupted stack end detected inside scheduler
> CPU: 0 PID: 2049 Comm: syz-executor.0 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
> Hardware name: riscv-virtio,qemu (DT)
> Call Trace:
> [<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
> [<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
> [<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
> [<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
> [<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
> [<ffffffff83166fa8>] panic+0x24a/0x634 kernel/panic.c:233
> [<ffffffff831a688a>] schedule_debug kernel/sched/core.c:5541 [inline]
> [<ffffffff831a688a>] schedule+0x0/0x14c kernel/sched/core.c:6187
> [<ffffffff831a6b00>] preempt_schedule_common+0x4e/0xde kernel/sched/core.c:6462
> [<ffffffff831a6bc4>] preempt_schedule+0x34/0x36 kernel/sched/core.c:6487
> [<ffffffff831afd78>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
> [<ffffffff831afd78>] _raw_spin_unlock_irqrestore+0x8c/0x98 kernel/locking/spinlock.c:194
> [<ffffffff80b09fdc>] __debug_check_no_obj_freed lib/debugobjects.c:1002 [inline]
> [<ffffffff80b09fdc>] debug_check_no_obj_freed+0x14c/0x24a lib/debugobjects.c:1023
> [<ffffffff80410994>] free_pages_prepare mm/page_alloc.c:1358 [inline]
> [<ffffffff80410994>] free_pcp_prepare+0x24e/0x45e mm/page_alloc.c:1404
> [<ffffffff804142fe>] free_unref_page_prepare mm/page_alloc.c:3325 [inline]
> [<ffffffff804142fe>] free_unref_page+0x6a/0x31e mm/page_alloc.c:3404
> [<ffffffff8041471e>] free_the_page mm/page_alloc.c:706 [inline]
> [<ffffffff8041471e>] __free_pages+0xe2/0x112 mm/page_alloc.c:5474
> [<ffffffff8046d728>] __free_slab+0x122/0x27c mm/slub.c:2028
> [<ffffffff8046d8ce>] free_slab mm/slub.c:2043 [inline]
> [<ffffffff8046d8ce>] discard_slab+0x4c/0x7a mm/slub.c:2049
> [<ffffffff8046deec>] __unfreeze_partials+0x16a/0x18e mm/slub.c:2536
> [<ffffffff8046e006>] put_cpu_partial+0xf6/0x162 mm/slub.c:2612
> [<ffffffff8046d0ec>] __slab_free+0x166/0x29c mm/slub.c:3378
> [<ffffffff8047258c>] do_slab_free mm/slub.c:3497 [inline]
> [<ffffffff8047258c>] ___cache_free+0x17c/0x354 mm/slub.c:3516
> [<ffffffff8047692e>] qlink_free mm/kasan/quarantine.c:157 [inline]
> [<ffffffff8047692e>] qlist_free_all+0x7c/0x132 mm/kasan/quarantine.c:176
> [<ffffffff80476ed4>] kasan_quarantine_reduce+0x14c/0x1c8 mm/kasan/quarantine.c:283
> [<ffffffff804742b2>] __kasan_slab_alloc+0x5c/0x98 mm/kasan/common.c:446
> [<ffffffff8046fa8a>] kasan_slab_alloc include/linux/kasan.h:260 [inline]
> [<ffffffff8046fa8a>] slab_post_alloc_hook mm/slab.h:732 [inline]
> [<ffffffff8046fa8a>] slab_alloc_node mm/slub.c:3230 [inline]
> [<ffffffff8046fa8a>] slab_alloc mm/slub.c:3238 [inline]
> [<ffffffff8046fa8a>] __kmalloc+0x156/0x318 mm/slub.c:4420
> [<ffffffff82bde908>] kmalloc include/linux/slab.h:586 [inline]
> [<ffffffff82bde908>] kzalloc include/linux/slab.h:715 [inline]
> [<ffffffff82bde908>] fib_create_info+0xade/0x2d8e net/ipv4/fib_semantics.c:1464
> [<ffffffff82becedc>] fib_table_insert+0x1a0/0xebe net/ipv4/fib_trie.c:1224
> [<ffffffff82bd1222>] fib_magic+0x3f4/0x438 net/ipv4/fib_frontend.c:1087
> [<ffffffff82bd6178>] fib_add_ifaddr+0xd2/0x2e2 net/ipv4/fib_frontend.c:1109
> [<ffffffff82bd66ea>] fib_netdev_event+0x362/0x4b0 net/ipv4/fib_frontend.c:1466
> [<ffffffff800aac84>] notifier_call_chain+0xb8/0x188 kernel/notifier.c:84
> [<ffffffff800aad7e>] raw_notifier_call_chain+0x2a/0x38 kernel/notifier.c:392
> [<ffffffff8271d086>] call_netdevice_notifiers_info+0x9e/0x10c net/core/dev.c:1919
> [<ffffffff827422c8>] call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
> [<ffffffff827422c8>] call_netdevice_notifiers net/core/dev.c:1945 [inline]
> [<ffffffff827422c8>] __dev_notify_flags+0x108/0x1fa net/core/dev.c:8179
> [<ffffffff827436f6>] dev_change_flags+0x9c/0xba net/core/dev.c:8215
> [<ffffffff82767e16>] do_setlink+0x5d6/0x21c4 net/core/rtnetlink.c:2729
> [<ffffffff8276a6a2>] __rtnl_newlink+0x99e/0xfa0 net/core/rtnetlink.c:3412
> [<ffffffff8276ad04>] rtnl_newlink+0x60/0x8c net/core/rtnetlink.c:3527
> [<ffffffff8276b46c>] rtnetlink_rcv_msg+0x338/0x9a0 net/core/rtnetlink.c:5592
> [<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
> [<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
> [<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
> [<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
> [<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
> [<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
> [<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
> [<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
> [<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
> [<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
> [<ffffffff80005716>] ret_from_syscall+0x0/0x2
> SMP: stopping secondary CPUs
> Rebooting in 86400 seconds..
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
