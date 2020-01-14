Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7310B13B507
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgANWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:04:13 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:46298 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbgANWEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:04:13 -0500
Received: by mail-io1-f72.google.com with SMTP id p206so9053703iod.13
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OMN3C/VoYyKIvwTqw2B7b50mrKvNUjoFBtsQzpL17pw=;
        b=WOJqWWTtjPIgPjxi7Zz7m0zwCdqd7EPkpA6fDP3Uqi1OD9vybocpSj/l4sxPlaDUqJ
         bpyAA7l5TIEMMcmPd6hLuYvegzLLi9mFjpbgXv7Ll873PvfyXBmDQyc6VrbI57NBTYNe
         Al+N9zPdnNZYmoOkLVO92Go09nRHJRGMiZt4RDE0DjW6gGGVG3yOHm0PAIOc4eLSQOGk
         ggX62N9u6ci4BFRh16WqEZUfnQ8Ql3+2qN9gJY/CFZmP4S0X/ebXgM2xe6ezo2oNgAk9
         rH4GZeIftJ0+W+e9WvmLNvR/hfrA8O/AaafW0Q5vD9kvUJs8dT5yDshyb0Fq0XaelX1x
         Blcg==
X-Gm-Message-State: APjAAAVjYiT2hQWg+R3NwhI7D+k+b561AIJHTATISkvSpxgxRlhBXpwK
        4FlqbWa9dTYXNjBp8F6+pn6HSjiC8V3JAOYAT1S0LEzK5iwc
X-Google-Smtp-Source: APXvYqwT5gXgVOW2dudlVYr3OrjQUlenltw3HdN1hwCoQje3ZeeWmf8prgS/U+Qse+oz3HaCUTBqLCpufZngjUDXwJlPy1cnd1QE
MIME-Version: 1.0
X-Received: by 2002:a92:cd07:: with SMTP id z7mr583436iln.124.1579039452376;
 Tue, 14 Jan 2020 14:04:12 -0800 (PST)
Date:   Tue, 14 Jan 2020 14:04:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a539c1059c20c5aa@google.com>
Subject: WARNING: refcount bug in free_nsproxy (2)
From:   syzbot <syzbot+a98eee31f5df4261d88c@syzkaller.appspotmail.com>
To:     allison@lohutok.net, armijn@tjaldur.nl, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, jiri@resnulli.us, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, xiyou.wangcong@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6c09d7db Add linux-next specific files for 20200110
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=102b2156e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7dc7ab9739654fbe
dashboard link: https://syzkaller.appspot.com/bug?extid=a98eee31f5df4261d88c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162f16aee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13457571e00000

The bug was bisected to:

commit 14215108a1fd7e002c0a1f9faf8fbaf41fdda50d
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Feb 21 05:37:42 2019 +0000

     net_sched: initialize net pointer inside tcf_exts_init()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1063da9ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1263da9ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1463da9ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a98eee31f5df4261d88c@syzkaller.appspotmail.com
Fixes: 14215108a1fd ("net_sched: initialize net pointer inside  
tcf_exts_init()")

R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 9780 at lib/refcount.c:28  
refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9780 Comm: syz-executor174 Not tainted  
5.5.0-rc5-next-20200110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:176 [inline]
  fixup_bug arch/x86/kernel/traps.c:171 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:269
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:288
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
Code: e9 d8 fe ff ff 48 89 df e8 b1 a6 13 fe e9 85 fe ff ff e8 47 6e d5 fd  
48 c7 c7 80 64 91 88 c6 05 4f 5b 00 07 01 e8 e3 f5 a5 fd <0f> 0b e9 ac fe  
ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 55 48
RSP: 0018:ffffc90005fd7cf8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e8546 RDI: fffff52000bfaf91
RBP: ffffc90005fd7d08 R08: ffff8880a65ee500 R09: ffffed1015d26659
R10: ffffed1015d26658 R11: ffff8880ae9332c7 R12: 0000000000000003
R13: ffff88809aff6040 R14: ffff88809aff6044 R15: 00000000000002bc
  refcount_sub_and_test include/linux/refcount.h:261 [inline]
  refcount_dec_and_test include/linux/refcount.h:281 [inline]
  put_net include/net/net_namespace.h:259 [inline]
  free_nsproxy+0x2eb/0x330 kernel/nsproxy.c:180
  switch_task_namespaces+0xb3/0xd0 kernel/nsproxy.c:225
  exit_task_namespaces+0x18/0x20 kernel/nsproxy.c:230
  do_exit+0xbc6/0x2f70 kernel/exit.c:800
  do_group_exit+0x135/0x360 kernel/exit.c:899
  __do_sys_exit_group kernel/exit.c:910 [inline]
  __se_sys_exit_group kernel/exit.c:908 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:908
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441228
Code: 74 20 63 6f 64 65 20 62 61 73 65 2e 00 00 00 00 00 00 72 73 79 73 6c  
6f 67 64 3a 20 24 41 62 6f 72 74 4f 6e 55 6e 63 6c 65 61 <6e> 43 6f 6e 66  
69 67 20 69 73 20 73 65 74 2c 20 61 6e 64 20 63 6f
RSP: 002b:00007ffedb54aa88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000441228
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 00000000004c79d0 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006daa80 R14: 0000000000000000 R15: 0000000000000000
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
