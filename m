Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E996183B78
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgCLVhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:37:13 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:57327 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCLVhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:37:12 -0400
Received: by mail-io1-f69.google.com with SMTP id d13so4857941ioo.23
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=otDTyif1JxNxdhkmFkrhZBBAigUQx1pxkqJwd5II138=;
        b=WYkCHMEUO8tHSusdXKO/H8hc2jbXfpNf6WHh9wyYCQwsXEOJjHsIdBm5mXeT11v46J
         /ptk/TZdZFajAG8+IK2eKUSfrNI+50RNhwlH3Kd9sRIaADLqLrQESghAZvHJBDbJ+y4X
         AUQyLrVm3LNATKBzqrFh5+DylCcwIof0qEFPrqkTGDZgGwQeP4T0gG/YS8iCu3swEtmX
         Es4fCXu7I+uiIBJDN1aKbRj0r6oco5mn7OH4nkvi/dQRTKGuFBWYXdza9d9EMoM5mXUC
         Hd6U1yfy0cweTCzgrh2mUCMMpYwdBryea9RxUALKVzGrlqgE7wulLZVQD//WrONZWftB
         42gA==
X-Gm-Message-State: ANhLgQ37Tz1sWSMGPefgysTR46Adec+HiYKGkM1kGj7u1YZVYpjpu3Jy
        BdxbUNEdeH6zW6xdURfFpgIFae5oyi7Ip5aqVnb0/7t7sZyK
X-Google-Smtp-Source: ADFU+vvqMDGrrjUv2iUkYwJaB5U6vfSQvaKwU93+Tw2aJqefc794DfGTD3jwIErkI2rFXjwv1VXusTuBATT4bD+0PhjI6HGU4hCI
MIME-Version: 1.0
X-Received: by 2002:a92:5b56:: with SMTP id p83mr10329254ilb.70.1584049032035;
 Thu, 12 Mar 2020 14:37:12 -0700 (PDT)
Date:   Thu, 12 Mar 2020 14:37:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dc81b705a0af279c@google.com>
Subject: WARNING in bpf_check (3)
From:   syzbot <syzbot+245129539c27fecf099a@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    13fac1d8 bpf: Fix trampoline generation for fmod_ret progr..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=167ba061e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=888f81f5410adfa2
dashboard link: https://syzkaller.appspot.com/bug?extid=245129539c27fecf099a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ba39c3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bbb981e00000

The bug was bisected to:

commit 94dacdbd5d2dfa2cffd308f128d78c99f855f5be
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Feb 24 14:01:32 2020 +0000

    bpf: Tighten the requirements for preallocated hash maps

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1300a2b1e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1080a2b1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1700a2b1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+245129539c27fecf099a@syzkaller.appspotmail.com
Fixes: 94dacdbd5d2d ("bpf: Tighten the requirements for preallocated hash maps")

------------[ cut here ]------------
trace type BPF program uses run-time allocation
WARNING: CPU: 1 PID: 9523 at kernel/bpf/verifier.c:8187 check_map_prog_compatibility kernel/bpf/verifier.c:8187 [inline]
WARNING: CPU: 1 PID: 9523 at kernel/bpf/verifier.c:8187 replace_map_fd_with_map_ptr kernel/bpf/verifier.c:8282 [inline]
WARNING: CPU: 1 PID: 9523 at kernel/bpf/verifier.c:8187 bpf_check+0x6dcb/0xa49b kernel/bpf/verifier.c:10112
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9523 Comm: syz-executor700 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:check_map_prog_compatibility kernel/bpf/verifier.c:8187 [inline]
RIP: 0010:replace_map_fd_with_map_ptr kernel/bpf/verifier.c:8282 [inline]
RIP: 0010:bpf_check+0x6dcb/0xa49b kernel/bpf/verifier.c:10112
Code: ff 48 8b bd 20 fe ff ff e8 02 56 2c 00 e9 bc cf ff ff e8 88 a0 ef ff 48 c7 c7 c0 8c 11 88 c6 05 c0 c7 de 08 01 e8 bd b3 c1 ff <0f> 0b e9 f3 ae ff ff c7 85 c0 fe ff ff f4 ff ff ff e9 d3 c6 ff ff
RSP: 0018:ffffc90001ec7990 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bfd81 RDI: fffff520003d8f24
RBP: ffffc90001ec7b90 R08: ffff88809ae22380 R09: ffffed1015ce45c9
R10: ffffed1015ce45c8 R11: ffff8880ae722e43 R12: 0000000000000002
R13: ffffc90000d36048 R14: ffff88809a7d4800 R15: dffffc0000000000
 bpf_prog_load+0xd92/0x15f0 kernel/bpf/syscall.c:2105
 __do_sys_bpf+0x16f2/0x4020 kernel/bpf/syscall.c:3594
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440539
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdd65517e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440539
RDX: 0000000000000014 RSI: 0000000020fed000 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401dc0
R13: 0000000000401e50 R14: 0000000000000000 R15: 0000000000000000
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
