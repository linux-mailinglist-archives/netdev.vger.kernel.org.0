Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74771B9F5E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 11:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgD0JIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 05:08:17 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:45265 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgD0JIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 05:08:14 -0400
Received: by mail-io1-f72.google.com with SMTP id y4so19503222ioy.12
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 02:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZVmhnIuphgg49v7nKDffjwnQJQxBAzs6KUl/FwnAIgY=;
        b=VlwveaNwZBySf37LAlz/ASJdqze9EBxnJZQPePHdPnWv2GoE1r32VQAqvEEQ5CIRtc
         6lFQVKU03tdhQJnuUfxlJMzqrejsVgC3DjueEwfZu4qxAbLvcjekBmIHmjy0HOX4XLdc
         Qe5h8FhlA/pP2mDTOilvCQogsW4gzawxzk55eAlshRMjER6fZRn2mQuKDtnEZxXBsQLt
         F/zKNQmwJQN2Zgcp+0xC1lDTz1Rp1vqqnj8fdYSs0w5ZNXVyfnoEDVIqS0FnUu+6NJU3
         cUXa+hUkgrg5b1W/YddPp8mQCXLSXtD4QMFFVyPt76zLNAzMirTSyHcjelFK5SRanIvj
         2I7Q==
X-Gm-Message-State: AGi0PubVx7PIya4Ky1OdrloSa3SIJS2y9QbuDH/Al4qpDdCDDSE0gQt0
        aQ/nSBVZbFA0fDoAFR2Wx3QF3x2WQLrfzP1+ZSr00lhOnwZu
X-Google-Smtp-Source: APiQypLzT1R83Qckum7M7Skre96oCEUz/ygCc/mtwqK/j45LlZHLvubwB2mOuXXf4kCyb6t2ED1dfqcyZkA5OEZbd/fG7uTuO6YT
MIME-Version: 1.0
X-Received: by 2002:a02:6ccf:: with SMTP id w198mr3972270jab.8.1587978493150;
 Mon, 27 Apr 2020 02:08:13 -0700 (PDT)
Date:   Mon, 27 Apr 2020 02:08:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fed01105a4420d11@google.com>
Subject: WARNING: locking bug in inet_dgram_connect (2)
From:   syzbot <syzbot+02446910ced9f8b60c06@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c578ddb3 Merge tag 'linux-kselftest-5.7-rc3' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f1d330100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78a7d8adda44b4b
dashboard link: https://syzkaller.appspot.com/bug?extid=02446910ced9f8b60c06
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14083ecfe00000

Bisection is inconclusive: the first bad commit could be any of:

9211bfbf netfilter: add missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to header-file.
47e640af netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
a1b2f04e netfilter: add missing includes to a number of header-files.
0abc8bf4 netfilter: add missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to some header-files.
bd96b4c7 netfilter: inline four headers files into another one.
43dd16ef netfilter: nf_tables: store data in offload context registers
78458e3e netfilter: add missing IS_ENABLED(CONFIG_NETFILTER) checks to some header-files.
20a9379d netfilter: remove "#ifdef __KERNEL__" guards from some headers.
bd8699e9 netfilter: nft_bitwise: add offload support
2a475c40 kbuild: remove all netfilter headers from header-test blacklist.
7e59b3fe netfilter: remove unnecessary spaces
1b90af29 ipvs: Improve robustness to the ipvs sysctl
5785cf15 netfilter: nf_tables: add missing prototypes.
0a30ba50 netfilter: nf_nat_proto: make tables static
e84fb4b3 netfilter: conntrack: use shared sysctl constants
10533343 netfilter: connlabels: prefer static lock initialiser
8c0bb787 netfilter: synproxy: rename mss synproxy_options field
c162610c Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15410074100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+02446910ced9f8b60c06@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 7534 at kernel/locking/lockdep.c:873 look_up_lock_class+0x207/0x280 kernel/locking/lockdep.c:863
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7534 Comm: syz-executor.0 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:look_up_lock_class+0x207/0x280 kernel/locking/lockdep.c:863
Code: 3d 91 8b 12 08 00 0f 85 35 ff ff ff 31 db 48 c7 c7 19 59 e5 88 48 c7 c6 c3 e9 e6 88 31 c0 e8 c0 17 ec ff 0f 0b e9 7b ff ff ff <0f> 0b e9 74 ff ff ff 48 c7 c1 30 6d 55 8b 80 e1 07 80 c1 03 38 c1
RSP: 0018:ffffc9000268fa98 EFLAGS: 00010002
RAX: ffffffff8ab07460 RBX: ffffffff8ad69a68 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a83b40a0
RBP: ffff8880a83b40b8 R08: 0000000000000001 R09: 0000000000000000
R10: fffffbfff12d772d R11: 0000000000000000 R12: 1ffff11015076814
R13: ffffffff89063e89 R14: ffff8880a83b40a0 R15: dffffc0000000000
 register_lock_class+0x97/0x10d0 kernel/locking/lockdep.c:1220
 __lock_acquire+0x102/0x2c30 kernel/locking/lockdep.c:4234
 lock_acquire+0x169/0x480 kernel/locking/lockdep.c:4934
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:358 [inline]
 lock_sock_nested+0x43/0x110 net/core/sock.c:2959
 lock_sock include/net/sock.h:1574 [inline]
 inet_autobind net/ipv4/af_inet.c:179 [inline]
 inet_dgram_connect+0x1a7/0x360 net/ipv4/af_inet.c:569
 __sys_connect_file net/socket.c:1859 [inline]
 __sys_connect+0x2da/0x360 net/socket.c:1876
 __do_sys_connect net/socket.c:1887 [inline]
 __se_sys_connect net/socket.c:1884 [inline]
 __x64_sys_connect+0x76/0x80 net/socket.c:1884
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f47444d9c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00000000004dabc0 RCX: 000000000045c829
RDX: 000000000000001c RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000084 R14: 00000000004c31c2 R15: 00007f47444da6d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
