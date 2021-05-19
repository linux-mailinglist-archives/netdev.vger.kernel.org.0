Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885AC3896FE
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhESTu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhESTu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:50:28 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13D5C061760
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 12:49:07 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id v18so7424041qvx.10
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 12:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x553GgwQKaofcNpaBiACRQKsb0OQqbXpuDWI9o8R+5o=;
        b=U2JOCePyF9dZ1bAQjvBXDA2RVqSJKE5ggujFUiWY6ZL1Csp7DB2UoVUu4gLSoaUqsI
         o3XVqKkCW8Yc50rKjUXDy2p5DrY4kBclF02LosDjULEBVOYxE2pPKaSy/rHxOBV7mqGe
         WcEWN0QynP53FeyLp/H3s7YUzRl1mxqRKhn3Q8wj33fZdtuUzScdp6JkSc+2aJBARGjn
         sTzoeTtyVm/WlmOEwg3DxV321RqlzK8Rdzu2tQ0TkUC5FlEDeOEgrK61yLp3d3n9SO7l
         1H3pXKr0/UiCyqnPPpDJ4TaHjmX1W0TkWX/773/IdGkTYKt6hQOUudqp7ToOeC+QGzLl
         VGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x553GgwQKaofcNpaBiACRQKsb0OQqbXpuDWI9o8R+5o=;
        b=OGlSqUP17lcl/4srZtBJxGK13exXpr2C1zDw1ekKWZIzO51IFTcC7SXckjMbi3Ru4y
         DDhk7mocW+R0/TUNfbefii2aaz/PyMbQ0ReGdvORNX0bcSoNU+z6HUv9di0DoYmy/ja1
         UL/19668pjR33wm2zpFEcz2JVMtEFx+FBg9j66wIk9LWkDbNYHcaadB0bXQ+X0v2TeI8
         ib0oeihbZSBedDc2Ojz6fHiI8Q8E4ek4RwgOdlDVpN7n0lKEfZvcX4ddBSE0T6IzsZvl
         4txXF/LZMPFIPM5H0XlFDQiu8uHNYNPLq/Cyp0hnXXqFAO4K9fh0uGUFPdaoYo13om0c
         MEMA==
X-Gm-Message-State: AOAM533BedF9+IFIYyK0pMsDWTM0cPvf0CO98f2UYbwTUs3DfBTs0iCi
        NrAo+v5r1zPyEVzIP2VqgFCKSoFISHeRqeVXMnM9YA==
X-Google-Smtp-Source: ABdhPJyBY3kKYWcls4L2Vfe7GKCY8SDCqG2snzu+sRtfz1Lp2Jexzz+rhM9XdRkDpl+n8C0HPHxtJeX6kFmDYVk2cmE=
X-Received: by 2002:a0c:f883:: with SMTP id u3mr1179641qvn.44.1621453746524;
 Wed, 19 May 2021 12:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000003687bd05c2b2401d@google.com>
In-Reply-To: <0000000000003687bd05c2b2401d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 19 May 2021 21:48:55 +0200
Message-ID: <CACT4Y+YJDGFN4q-aTPritnjjHEXiFovOm9eO6Ay4xC1YOa5z3w@mail.gmail.com>
Subject: Re: [syzbot] BUG: MAX_LOCKDEP_KEYS too low! (2)
To:     syzbot <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 7:35 PM syzbot
<syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    b81ac784 net: cdc_eem: fix URL to CDC EEM 1.0 spec
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=15a257c3d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5b86a12e0d1933b5
> dashboard link: https://syzkaller.appspot.com/bug?extid=a70a6358abd2c3f9550f
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com
>
> BUG: MAX_LOCKDEP_KEYS too low!


What config controls this? I don't see "MAX_LOCKDEP_KEYS too low" in
any of the config descriptions...
Here is what syzbot used:

CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=16
CONFIG_LOCKDEP_CHAINS_BITS=17
CONFIG_LOCKDEP_STACK_TRACE_BITS=20
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12

We already bumped most of these.
The log contains dump of the lockdep debug files, is there any offender?

Also looking at the log I noticed a memory safety bug in lockdep implementation:

[ 2023.605505][ T6807]
==================================================================
[ 2023.613589][ T6807] BUG: KASAN: global-out-of-bounds in
print_name+0x1b0/0x1d0
[ 2023.624553][ T6807] Read of size 8 at addr ffffffff90225cb0 by task cat/6807
[ 2023.631765][ T6807]
[ 2023.634096][ T6807] CPU: 1 PID: 6807 Comm: cat Not tainted
5.12.0-syzkaller #0
[ 2023.641488][ T6807] Hardware name: Google Google Compute
Engine/Google Compute Engine, BIOS Google 01/01/2011
[ 2023.651745][ T6807] Call Trace:
[ 2023.655031][ T6807]  dump_stack+0x141/0x1d7
[ 2023.659375][ T6807]  ? print_name+0x1b0/0x1d0
[ 2023.663890][ T6807]  print_address_description.constprop.0.cold+0x5/0x2f8
[ 2023.670895][ T6807]  ? print_name+0x1b0/0x1d0
[ 2023.675413][ T6807]  ? print_name+0x1b0/0x1d0
[ 2023.679948][ T6807]  kasan_report.cold+0x7c/0xd8
[ 2023.684725][ T6807]  ? print_name+0x1b0/0x1d0
[ 2023.689248][ T6807]  print_name+0x1b0/0x1d0
[ 2023.694196][ T6807]  ? lockdep_stats_show+0xa20/0xa20
[ 2023.699940][ T6807]  ? seq_file_path+0x30/0x30
[ 2023.704721][ T6807]  ? mutex_lock_io_nested+0xf70/0xf70
[ 2023.710118][ T6807]  ? lock_acquire+0x58a/0x740
[ 2023.715156][ T6807]  ? kasan_unpoison+0x3c/0x60
[ 2023.719843][ T6807]  lc_show+0x10a/0x210
[ 2023.723924][ T6807]  seq_read_iter+0xb66/0x1220
[ 2023.728617][ T6807]  proc_reg_read_iter+0x1fb/0x2d0
[ 2023.733651][ T6807]  new_sync_read+0x41e/0x6e0
[ 2023.738272][ T6807]  ? ksys_lseek+0x1b0/0x1b0
[ 2023.742784][ T6807]  ? lock_acquire+0x58a/0x740
[ 2023.747563][ T6807]  vfs_read+0x35c/0x570
[ 2023.751737][ T6807]  ksys_read+0x12d/0x250
[ 2023.756003][ T6807]  ? vfs_write+0xa30/0xa30
[ 2023.760429][ T6807]  ? syscall_enter_from_user_mode+0x27/0x70
[ 2023.766335][ T6807]  do_syscall_64+0x3a/0xb0
[ 2023.770764][ T6807]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 2023.776685][ T6807] RIP: 0033:0x7f99856e2910
[ 2023.781104][ T6807] Code: b6 fe ff ff 48 8d 3d 0f be 08 00 48 83 ec
08 e8 06 db 01 00 66 0f 1f 44 00 00 83 3d f9 2d 2c 00 00 75 10 b8 00
00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 de 9b 01 00
48 89 04 24
[ 2023.800719][ T6807] RSP: 002b:00007ffee7328628 EFLAGS: 00000246
ORIG_RAX: 0000000000000000
[ 2023.809169][ T6807] RAX: ffffffffffffffda RBX: 0000000000020000
RCX: 00007f99856e2910
[ 2023.817150][ T6807] RDX: 0000000000020000 RSI: 0000564290b2a000
RDI: 0000000000000003
[ 2023.825123][ T6807] RBP: 0000564290b2a000 R08: 0000000000000003
R09: 0000000000021010
[ 2023.833107][ T6807] R10: 0000000000000002 R11: 0000000000000246
R12: 0000564290b2a000
[ 2023.841091][ T6807] R13: 0000000000000003 R14: 0000000000020000
R15: 0000000000001000
[ 2023.849074][ T6807]
[ 2023.851408][ T6807] The buggy address belongs to the variable:
[ 2023.857388][ T6807]  lock_classes_in_use+0x410/0x420
[ 2023.862510][ T6807]
[ 2023.864826][ T6807] Memory state around the buggy address:
[ 2023.870450][ T6807]  ffffffff90225b80: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[ 2023.878511][ T6807]  ffffffff90225c00: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[ 2023.886572][ T6807] >ffffffff90225c80: 00 00 00 00 f9 f9 f9 f9 00
00 00 00 00 00 00 00
[ 2023.894628][ T6807]                                      ^
[ 2023.900256][ T6807]  ffffffff90225d00: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[ 2023.908317][ T6807]  ffffffff90225d80: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[ 2023.916377][ T6807]
==================================================================





> turning off the locking correctness validator.
> CPU: 0 PID: 5917 Comm: syz-executor.4 Not tainted 5.12.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  register_lock_class.cold+0x14/0x19 kernel/locking/lockdep.c:1281
>  __lock_acquire+0x102/0x5230 kernel/locking/lockdep.c:4781
>  lock_acquire kernel/locking/lockdep.c:5512 [inline]
>  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
>  flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2786
>  drain_workqueue+0x1a5/0x3c0 kernel/workqueue.c:2951
>  destroy_workqueue+0x71/0x800 kernel/workqueue.c:4382
>  alloc_workqueue+0xc40/0xef0 kernel/workqueue.c:4343
>  wg_newlink+0x43d/0x9e0 drivers/net/wireguard/device.c:335
>  __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3452
>  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
>  rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4665d9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb25febe188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000056c0b0 RCX: 00000000004665d9
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
> RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c0b0
> R13: 00007fff30a5021f R14: 00007fb25febe300 R15: 0000000000022000
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
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000003687bd05c2b2401d%40google.com.
