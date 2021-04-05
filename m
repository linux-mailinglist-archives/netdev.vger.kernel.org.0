Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BFE354874
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242652AbhDEWF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:05:27 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45482 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbhDEWFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 18:05:23 -0400
Received: by mail-il1-f197.google.com with SMTP id x7so10366113ilp.12
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 15:05:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rE9Lgt+L6rHEa2lPaIz2LAbklGrZ/8/l6OV+XVfhjIQ=;
        b=K9pwb96B0+lO7vmtuVcdyPHyxtqdKwfXB/mS+m6FyiQpxDs/OFYKgr6DQfttn3sVrh
         zL3TGpqMFU7vvROvZh463q6ki4Orc//hcXxCtbFJIk60d/2IyavJ0lmnRhIlQVeKcdiK
         gSfCGEjrUhb2cbQSjDo1ysZHW9/W2bTUf6VVd4m3jQ+Awi8T5zjZV6zOJvNVGlg0Cmvk
         BJFTYzKOCxYV1p3Z0oUKO8QBFv16iTkfnl2i+LRjVtIp3buXIkPtYG3xqmL7qHoTQWUc
         9kXI2ntFVVWxqVA6GERMflTUy6tTmHbklHn3rVUpjW7eSgeps7xkawUHDtK1IHaUuB3t
         KxOg==
X-Gm-Message-State: AOAM530Q9nSBoozaPndBVhNdJPq5j3HMd0Nf0GXxZano4LyxyllSSSUO
        Zxm+FgyIRzyN9axnsG/3DKvn4akkMK3OazUS7XqfsoT6x1ir
X-Google-Smtp-Source: ABdhPJwsl00yvfIuD6YEyJZUif+FP4TrNvNVIATDR9q3M8i0uQFmnaAG/Sm5oszwt4k13naHE6JC49fHrNIzBfixsVl0+UduvZNv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a87:: with SMTP id k7mr19967967ilv.69.1617660316511;
 Mon, 05 Apr 2021 15:05:16 -0700 (PDT)
Date:   Mon, 05 Apr 2021 15:05:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008872ff05bf40e4db@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in tcp_bpf_update_proto
From:   syzbot <syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, anton@tuxera.com,
        ast@kernel.org, bp@alien8.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hpa@zytor.com,
        jakub@cloudflare.com, jmattson@google.com,
        john.fastabend@gmail.com, joro@8bytes.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lmb@cloudflare.com, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, rkovhaev@gmail.com,
        seanjc@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    514e1150 net: x25: Queue received packets in the drivers i..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=112a8831d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=320a3bc8d80f478c37e4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1532d711d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f44c5ed00000

The issue was bisected to:

commit 4dfe6bd94959222e18d512bdf15f6bf9edb9c27c
Author: Rustam Kovhaev <rkovhaev@gmail.com>
Date:   Wed Feb 24 20:00:30 2021 +0000

    ntfs: check for valid standard information attribute

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16207a81d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15207a81d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11207a81d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com
Fixes: 4dfe6bd94959 ("ntfs: check for valid standard information attribute")

=============================
WARNING: suspicious RCU usage
5.12.0-rc4-syzkaller #0 Not tainted
-----------------------------
include/linux/skmsg.h:286 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor383/8454:
 #0: ffff888013a99b48 (clock-AF_INET){++..}-{2:2}, at: sk_psock_drop+0x2c/0x460 net/core/skmsg.c:788

stack backtrace:
CPU: 1 PID: 8454 Comm: syz-executor383 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 sk_psock include/linux/skmsg.h:286 [inline]
 tcp_bpf_update_proto+0x530/0x5f0 net/ipv4/tcp_bpf.c:504
 sk_psock_restore_proto include/linux/skmsg.h:408 [inline]
 sk_psock_drop+0xdf/0x460 net/core/skmsg.c:789
 sk_psock_put include/linux/skmsg.h:446 [inline]
 tcp_bpf_recvmsg+0x42d/0x480 net/ipv4/tcp_bpf.c:208
 inet_recvmsg+0x11b/0x5d0 net/ipv4/af_inet.c:852
 sock_recvmsg_nosec net/socket.c:888 [inline]
 sock_recvmsg net/socket.c:906 [inline]
 sock_recvmsg net/socket.c:902 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2569
 ___sys_recvmsg+0x127/0x200 net/socket.c:2611
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2705
 __sys_recvmmsg net/socket.c:2784 [inline]
 __do_sys_recvmmsg net/socket.c:2807 [inline]
 __se_sys_recvmmsg net/socket.c:2800 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2800
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4468e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f010b0cc318 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00000000004cb4e8 RCX: 00000000004468e9
RDX: 0000000000000422 RSI: 0000000020000540 RDI: 0000000000000004
RBP: 00000000004cb4e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049b270
R13: 00007ffe3829a5bf R14: 00007f010b0cc400 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
