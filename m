Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F2227FDAB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732109AbgJAKtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:49:06 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA0C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 03:49:04 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id w16so4724411qkj.7
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 03:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MhtaHYvememZ4rvJmJfpq+OiKpk7hwdBKC/+1lxZP9g=;
        b=Q5+ja/HHS3afIn1efpLSAnOb/UgOqnShksna+KJbh4xxD6Zpy0MZitkfZOm3lLQ+80
         JWYryVmm1K8gHaFcS6oRy/CoOdOPWdQVbOciEpsXAh9jIjiu8/Xy0pDubZmdilIZBv1i
         6X9yPRr9GZ+inosASTZjAPCQPDXo6kZLsISGwVcsAr7dhmawGu7ski6EMzpW3KBe69v5
         89+sfY9KBprFYt/tZOeGGW6cuFXDMuwi1jMDKCPWLeqwDmS5xgpfM0EvBtVobeQQf6VU
         wOq1O1cJzp7U5knPLp59UJyOP8R/JVK0yJJwDv/zMcdgWIoYnIF7MHbqmV2GYwpjk8uG
         cFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MhtaHYvememZ4rvJmJfpq+OiKpk7hwdBKC/+1lxZP9g=;
        b=W9d4DGAy4RmUwSWvuIGpp/fpBDML3YovzShRadDIaL+A1+P7N5uC1kHZJc5rSKfUnX
         If4PlL1yvgtlNWyURwyR8CC4a5oegUulZZITXjTmk62Ly+SgyWU3QBE4M4cRfHoPUM7Z
         ufAiXjnFDq3AWrMUhMuB9OnggnWaWFeQX6i/WbijOE2LWI/EQ7btpsdY2hVrsLZ2Q4le
         RPRB5arZTAdMgFgQDWXXcwh70S/o8GHmUWNH5rxjle7tqMmkY6suJTgienhc2bNgdXvu
         GV6kofcpYxmi7iDbDj9ZWyMhHDc2Zzqg/ODVW+2kTWCZGaBqWuP+69Hd10JIXhIT55mh
         TXgA==
X-Gm-Message-State: AOAM531G2/YpIBywv94x1MpUTJNDNX9DVTsMANq21KavLh6VwDdtcVoP
        pYYq969pwbqI5TqxdAEH555v6MXd9tcb8E/2jGZjiQ==
X-Google-Smtp-Source: ABdhPJxBZa2JHmBQ+mmFyUCkkOli1nAXMt9u84WWTXJZ2g7FTJuO/3Ljb+AR9KpejYSByzfAIbL0tmNJH+2i08ZzBv8=
X-Received: by 2002:a37:9c4f:: with SMTP id f76mr7127532qke.250.1601549343333;
 Thu, 01 Oct 2020 03:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fb885a05b0997c54@google.com>
In-Reply-To: <000000000000fb885a05b0997c54@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 1 Oct 2020 12:48:52 +0200
Message-ID: <CACT4Y+Z5pdgzT1-Oead4Gnn-SpPinm1_MuRYD-35sDZ5TwzkZA@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in batadv_nc_worker
To:     syzbot <syzbot+da9194708de785081f11@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        David Miller <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev <netdev@vger.kernel.org>,
        Sven Eckelmann <sven@narfation.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 12:29 PM syzbot
<syzbot+da9194708de785081f11@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5edb1df2 kmsan: drop the _nosanitize string functions
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=10cc55a7900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4991d22eb136035c
> dashboard link: https://syzkaller.appspot.com/bug?extid=da9194708de785081f11
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+da9194708de785081f11@syzkaller.appspotmail.com

It's somewhat unobvious how this can happen (or not?).

But may be related to:
INFO: rcu detected stall in batadv_nc_worker (3)
https://syzkaller.appspot.com/bug?id=6dba9b6476dd536c17afa799a72f265e448ff820

which happens with low frequency for the past 300 days, 21 stalls in total.

If we imagine the list somehow ends up uninitialized, occasional
infinite loops make perfect sense.



> =====================================================
> BUG: KMSAN: uninit-value in batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
> BUG: KMSAN: uninit-value in batadv_nc_worker+0x1c0/0x1d70 net/batman-adv/network-coding.c:718
> CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.9.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: bat_events batadv_nc_worker
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x21c/0x280 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:201
>  batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
>  batadv_nc_worker+0x1c0/0x1d70 net/batman-adv/network-coding.c:718
>  process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
>  worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
>  kthread+0x551/0x590 kernel/kthread.c:293
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:143 [inline]
>  kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:126
>  kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
>  slab_alloc_node mm/slub.c:2907 [inline]
>  slab_alloc mm/slub.c:2916 [inline]
>  __kmalloc+0x2bb/0x4b0 mm/slub.c:3982
>  kmalloc_array+0x90/0x140 include/linux/slab.h:594
>  batadv_hash_new+0x129/0x530 net/batman-adv/hash.c:52
>  batadv_originator_init+0x9b/0x370 net/batman-adv/originator.c:211
>  batadv_mesh_init+0x4dc/0x9d0 net/batman-adv/main.c:204
>  batadv_softif_init_late+0x6d8/0xa30 net/batman-adv/soft-interface.c:857
>  register_netdevice+0xbbc/0x37d0 net/core/dev.c:9760
>  __rtnl_newlink net/core/rtnetlink.c:3454 [inline]
>  rtnl_newlink+0x2e77/0x3ed0 net/core/rtnetlink.c:3500
>  rtnetlink_rcv_msg+0x142b/0x18c0 net/core/rtnetlink.c:5563
>  netlink_rcv_skb+0x6d7/0x7e0 net/netlink/af_netlink.c:2470
>  rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5581
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x11c8/0x1490 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x173a/0x1840 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  __sys_sendto+0x9dc/0xc80 net/socket.c:1992
>  __do_sys_sendto net/socket.c:2004 [inline]
>  __se_sys_sendto+0x107/0x130 net/socket.c:2000
>  __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> =====================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000fb885a05b0997c54%40google.com.
