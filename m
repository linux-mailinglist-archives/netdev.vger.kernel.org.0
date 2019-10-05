Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6502ACC88F
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 09:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfJEHQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 03:16:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53399 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfJEHQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 03:16:07 -0400
Received: by mail-io1-f70.google.com with SMTP id w8so17200538iol.20
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 00:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f6t/rs5xQhCT1Gu3lBp2UYzdFdG5BM97A92TtuPqnUo=;
        b=UTyMr66qdS1IgE3+TxLzZFJ4tmua/z7POiUSXzcw6i5qDJG5mwSTkK7yOCr7PUtcIo
         Su0rWWmQLS/gWWboW/gN5JfolFyARGsCJWRVKsbu4qui2sMDY445BLRlfw/vDNmYO1bv
         sEaZkE8+RYbYTeTMBFlNIx+8wJqZVpIKvHQMm1cuvtuz3n8YonBs3QdLgqjfcEo05SEx
         ydPE3RsEDKyCKUN2txoBKagfms51FhlKetghJ2N3uOaP4OAa0ouAH05ou5Bc9TUfdfZv
         Le3vYKb6NFq5PMDEfoZamiiFg0M5WxGhc/TVV/9na4gdf1KqVXb5+CmlqqWOewl5+qX0
         wGwA==
X-Gm-Message-State: APjAAAXj5oLFKe1YsP5Lu9RHKD94GXaMt5EG/3LrFlyQE+sd7uv0lq+h
        3YbJRvC6j6/8i7fVyCP9JTYkTCXTTXbbB8b/sYJz+GXfoDaq
X-Google-Smtp-Source: APXvYqwhoIFNTht4WEgQkbOFbVOomWljZZis7DUFvj+mYjxRcaqAVfGIR+c8M2y2ub561Kgr1xFVTaKeywQy+wipdN0ZbBDj414x
MIME-Version: 1.0
X-Received: by 2002:a92:8c86:: with SMTP id s6mr3580973ill.298.1570259766123;
 Sat, 05 Oct 2019 00:16:06 -0700 (PDT)
Date:   Sat, 05 Oct 2019 00:16:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090a62605942497af@google.com>
Subject: WARNING: refcount bug in sctp_transport_put (2)
From:   syzbot <syzbot+6cad8d7f75ebce50a44d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    311ef88a Add linux-next specific files for 20191004
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1688f6fb600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db2e4361e48662f4
dashboard link: https://syzkaller.appspot.com/bug?extid=6cad8d7f75ebce50a44d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6cad8d7f75ebce50a44d@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 23726 at lib/refcount.c:190  
refcount_sub_and_test_checked lib/refcount.c:190 [inline]
WARNING: CPU: 0 PID: 23726 at lib/refcount.c:190  
refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 23726 Comm: syz-executor.4 Not tainted 5.4.0-rc1-next-20191004  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:220
  __warn.cold+0x2f/0x3c kernel/panic.c:581
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:refcount_sub_and_test_checked lib/refcount.c:190 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Code: 1d 9d a9 7f 06 31 ff 89 de e8 6c 0d 31 fe 84 db 75 94 e8 23 0c 31 fe  
48 c7 c7 a0 6e e6 87 c6 05 7d a9 7f 06 01 e8 28 51 02 fe <0f> 0b e9 75 ff  
ff ff e8 04 0c 31 fe e9 6e ff ff ff 48 89 df e8 47
RSP: 0018:ffff8880ae809bc8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815cb526 RDI: ffffed1015d0136b
RBP: ffff8880ae809c60 R08: ffff888097c901c0 R09: fffffbfff14edb4a
R10: fffffbfff14edb49 R11: ffffffff8a76da4f R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff8880ae809c38 R15: 0000000000000000
  refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
  sctp_transport_put+0x1e/0x130 net/sctp/transport.c:325
  sctp_generate_heartbeat_event+0x2cf/0x450 net/sctp/sm_sideeffect.c:401
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:__sanitizer_cov_trace_pc+0x44/0x50 kernel/kcov.c:109
Code: 48 8b 75 08 75 2b 8b 90 00 13 00 00 83 fa 02 75 20 48 8b 88 08 13 00  
00 8b 80 04 13 00 00 48 8b 11 48 83 c2 01 48 39 d0 76 07 <48> 89 34 d1 48  
89 11 5d c3 0f 1f 00 65 4c 8b 04 25 40 fe 01 00 65
RSP: 0018:ffff88805f30f4e0 EFLAGS: 00000216 ORIG_RAX: ffffffffffffff13
RAX: 0000000000040000 RBX: 0000000000000008 RCX: ffffc9000e9aa000
RDX: 0000000000021364 RSI: ffffffff830d569e RDI: 0000000000000001
RBP: ffff88805f30f4e0 R08: ffff888097c901c0 R09: ffffed100be61eb3
R10: ffffed100be61eb2 R11: 0000000000000000 R12: ffff8880a858e780
R13: 0000000000000010 R14: 00000000000002d0 R15: 0000000000000000
  tomoyo_domain_quota_is_ok+0x2fe/0x540 security/tomoyo/util.c:1069
  tomoyo_supervisor+0x2e8/0xef0 security/tomoyo/common.c:2087
  tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
  tomoyo_path_permission security/tomoyo/file.c:587 [inline]
  tomoyo_path_permission+0x263/0x360 security/tomoyo/file.c:573
  tomoyo_check_open_permission+0x372/0x3f0 security/tomoyo/file.c:780
  tomoyo_file_open security/tomoyo/tomoyo.c:325 [inline]
  tomoyo_file_open+0x106/0x150 security/tomoyo/tomoyo.c:317
  security_file_open+0x71/0x300 security/security.c:1497
  do_dentry_open+0x373/0x1250 fs/open.c:784
  vfs_open+0xa0/0xd0 fs/open.c:914
  do_last fs/namei.c:3412 [inline]
  path_openat+0x10e9/0x4720 fs/namei.c:3529
  do_filp_open+0x1a1/0x280 fs/namei.c:3559
  do_sys_open+0x3fe/0x5d0 fs/open.c:1097
  ksys_open include/linux/syscalls.h:1386 [inline]
  __do_sys_creat fs/open.c:1155 [inline]
  __se_sys_creat fs/open.c:1153 [inline]
  __x64_sys_creat+0x61/0x80 fs/open.c:1153
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459a59
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007faa895c7c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 0000000000459a59
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000040
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007faa895c86d4
R13: 00000000004c00fd R14: 00000000004d2430 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
