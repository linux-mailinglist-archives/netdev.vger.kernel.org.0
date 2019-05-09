Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB318A22
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEIM5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:57:21 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53284 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfEIM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 08:57:20 -0400
Received: by mail-it1-f193.google.com with SMTP id m141so1984925ita.3
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 05:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImpFUcj1sbAmF1sHM6OBuuAs+TYL2za9I31j7f+5eVM=;
        b=aP18OQHK3kyx41xc77adG6/qGdQSMP7LR02mwxSAanfqix8qsoWeKQPYq8uWPQQV86
         t/4fb+ttI3F1MjBjSuBDv9DMVby4lRFKywKoPy9DzwwedydtYFTLjpVHmx+79i99TNLW
         liNpbQtQU/EGKv7UykWnuiBgABR/t45+IWU4dx0B69piQpvphzL1l+y6SDQeGywb3b5y
         mn3ghQmCw5X5+7vhOf99B+6AFgoG4SM7o754JoTBYLtajcIsL3PIECDF12qo5I5B+yUd
         RKkuk1ETatzaO7INRGOsqZjv+Rer8+qICmUvS+QCSndNQbxpC2LdQkJHhf8Ngk/KPCLv
         2MsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImpFUcj1sbAmF1sHM6OBuuAs+TYL2za9I31j7f+5eVM=;
        b=Zmzlun0SaqEmLZiUDhbyVJT8dlRwrQWyUx0hiqIDzLMlcEUsITdsWmG3IScDOcyu1A
         p/FmZSIyRLxqaX5mHVgQhEGgg8SXlPlgu3lxuoAMH44S16NjINWdrjqYyA9ExDlgeba2
         FAqfo2nKq7It7aCOb0gLxp9aUKWCN4S6Krj5HcY/vO4StW0JQv4uY9+S4f25axqE0MPZ
         V67czmaK8QzOIoC1ly45Ztlm18lNtU2+HGngYPTknd0wtzKpCrw2GSJvRjPBsnz+4/d1
         Fp6Du4uO3ecXujazJSHV11lp682iKRIlrsMAQ159ZzGK5ABpmTtdRcnj1zSwesMBs62T
         Mm5A==
X-Gm-Message-State: APjAAAXA9qYf7ba7BLyBcz1m/zhZyKjX2Pp2a9I364D+utDaE5vza5yO
        j01j4vZVbsrkHwP7RRRPoqL3qVVLsO3L25uIh2h45g==
X-Google-Smtp-Source: APXvYqzLnKlwZHZCSb/sOFmYlkiDws+MA7LZD1dIzqkXE8NT47zQez1ubp/laj5UpgEDvm3fA+w8g+s1g1aeL8IeJgE=
X-Received: by 2002:a02:c043:: with SMTP id u3mr2999790jam.35.1557406639568;
 Thu, 09 May 2019 05:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000d31dc05702e5bb1@google.com>
In-Reply-To: <0000000000000d31dc05702e5bb1@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 May 2019 14:57:08 +0200
Message-ID: <CACT4Y+Z8JyiBV6E6=XESMnqCURcUS7-rkSLMZisj+wB+bKXG+Q@mail.gmail.com>
Subject: Re: WARNING: locking bug in register_lock_class
To:     syzbot <syzbot+892f961d5cef6601aaf7@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: syzbot <syzbot+892f961d5cef6601aaf7@syzkaller.appspotmail.com>
Date: Wed, Jul 4, 2018 at 5:48 PM
To: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
<syzkaller-bugs@googlegroups.com>, <yoshfuji@linux-ipv6.org>

> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    1904148a361a Merge tag 'powerpc-4.18-3' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13ea3924400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a63be0c83e84d370
> dashboard link: https://syzkaller.appspot.com/bug?extid=892f961d5cef6601aaf7
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=10b0a434400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1360b160400000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+892f961d5cef6601aaf7@syzkaller.appspotmail.com
>
> WARNING: CPU: 0 PID: 25919 at kernel/locking/lockdep.c:704
> arch_local_save_flags arch/x86/include/asm/paravirt.h:778 [inline]
> WARNING: CPU: 0 PID: 25919 at kernel/locking/lockdep.c:704
> look_up_lock_class kernel/locking/lockdep.c:695 [inline]
> WARNING: CPU: 0 PID: 25919 at kernel/locking/lockdep.c:704
> register_lock_class+0xce6/0x2650 kernel/locking/lockdep.c:754
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 25919 Comm: syz-executor677 Not tainted 4.18.0-rc2+ #123
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
>   panic+0x238/0x4e7 kernel/panic.c:184
>   __warn.cold.8+0x163/0x1ba kernel/panic.c:536
>   report_bug+0x252/0x2d0 lib/bug.c:186
>   fixup_bug arch/x86/kernel/traps.c:178 [inline]
>   do_error_trap+0x1fc/0x4d0 arch/x86/kernel/traps.c:296
>   do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:316
>   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:992
> RIP: 0010:arch_local_save_flags arch/x86/include/asm/paravirt.h:778 [inline]
> RIP: 0010:look_up_lock_class kernel/locking/lockdep.c:695 [inline]
> RIP: 0010:register_lock_class+0xce6/0x2650 kernel/locking/lockdep.c:754
> Code: f9 ff ff 4c 89 ff 44 89 85 68 fc ff ff 89 8d 70 fc ff ff e8 cc 99 5b
> 00 44 8b 85 68 fc ff ff 8b 8d 70 fc ff ff e9 6f f9 ff ff <0f> 0b e9 c8 f6
> ff ff 48 8d 50 01 48 89 15 28 22 22 09 48 8d 14 80
> RSP: 0018:ffff8801b0b7ee08 EFLAGS: 00010083
> RAX: 0000000000000004 RBX: ffffffff8a5c01b0 RCX: 0000000000000000
> RDX: ffffffff887db060 RSI: ffffffff886d1ee0 RDI: 1ffffffff154956c
> RBP: ffff8801b0b7f210 R08: 0000000000000000 R09: dffffc0000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 1ffff1003616fdd1
> R13: 0000000000000003 R14: 0000000000000000 R15: ffff8801b81f7920
>   __lock_acquire+0x1bd/0x5020 kernel/locking/lockdep.c:3323
>   lock_acquire+0x1e4/0x540 kernel/locking/lockdep.c:3924
>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>   _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
>   spin_lock_bh include/linux/spinlock.h:315 [inline]
>   lock_sock_nested+0x46/0x120 net/core/sock.c:2834
>   lock_sock include/net/sock.h:1474 [inline]

#syz dup: WARNING: locking bug in lock_sock_nested
https://syzkaller.appspot.com/bug?id=a9f61ee7d10b848190610b0fe298bd9030a8288c

>   do_ipv6_setsockopt.isra.9+0x5ba/0x4680 net/ipv6/ipv6_sockglue.c:167
>   ipv6_setsockopt+0xbd/0x170 net/ipv6/ipv6_sockglue.c:922
>   udpv6_setsockopt+0x62/0xa0 net/ipv6/udp.c:1472
>   sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3040
>   __sys_setsockopt+0x1c5/0x3b0 net/socket.c:1911
>   __do_sys_setsockopt net/socket.c:1922 [inline]
>   __se_sys_setsockopt net/socket.c:1919 [inline]
>   __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1919
>   do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x447c59
> Code: e8 bc bd 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 eb 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f4e66aa9db8 EFLAGS: 00000297 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00000000006e39fc RCX: 0000000000447c59
> RDX: 0000000000000037 RSI: 0000000000000029 RDI: 0000000000000006
> RBP: 00000000006e39f8 R08: 0000000000000010 R09: 0000000000000000
> R10: 0000000020000000 R11: 0000000000000297 R12: 0000000000000000
> R13: 00007ffcd170ce8f R14: 00007f4e66aaa9c0 R15: 0000000000000008
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000000d31dc05702e5bb1%40google.com.
> For more options, visit https://groups.google.com/d/optout.
