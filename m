Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85462A1873
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfH2L2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:28:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36754 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfH2L2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:28:08 -0400
Received: by mail-io1-f72.google.com with SMTP id i6so3647959ioi.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 04:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Oe6dmT1xS+Z1sWXUd2cdSitlfMCmVkKBQK9rwo6kPAA=;
        b=RFs852Ar3idUbwaB1eDZhjaW5Od0ISm5yJmAPIwMRCftdNNZH3ayT98c92oKD4BQEa
         ugyBosL3fxuli3UEdT+wM84KMRzflSMjD3pv3fmOqFJOidzJ8FkvohrzLr+IuaEPi/UB
         VpX4QXv92RJyMmjzQbuYzjSCQm5c574JyOv4ty9VygnvYIq9fCOManhYeiKSPPlz3O0g
         l1N9uXqm6zhMGe69ulhlmCBlhfeJcbN4WzWJURnzWyWlxQ7Xo8RtJAbeFKv3p65lHzDy
         c91CJ54nuJ6CnUwR67qJ5l20HRfGGsntSN+WwWo1EUCjRVdlox6cFAoOzBwSIr6Z4Q/O
         n9yQ==
X-Gm-Message-State: APjAAAWkCkJRIUU7N8MfKCF+p1EBtFi2Fppjin+oxVZqr3XMkCDnjZmz
        L6xkMRVa+5p78DL460sUhq6VntS9KNglvIoPVM/vQsoDzcWg
X-Google-Smtp-Source: APXvYqwI1yHx16I9iVFRzbZegY9YZcEWdVB7Aj71PbLsjd1gGjfwRdwup/hl/9FvcC3VNTk4r/k/NK+m9jiADtXWG1wz/+gyvi8w
MIME-Version: 1.0
X-Received: by 2002:a02:23cc:: with SMTP id u195mr9959468jau.136.1567078087104;
 Thu, 29 Aug 2019 04:28:07 -0700 (PDT)
Date:   Thu, 29 Aug 2019 04:28:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7a14105913fcca8@google.com>
Subject: WARNING in __mark_chain_precision (2)
From:   syzbot <syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    47ee6e86 selftests/bpf: remove wrong nhoff in flow dissect..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16227fa6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=c8d66267fd2b5955287e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d26ebc600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127805ca600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com

------------[ cut here ]------------
verifier backtracking bug
WARNING: CPU: 0 PID: 8795 at kernel/bpf/verifier.c:1782  
__mark_chain_precision+0x197a/0x1ea0 kernel/bpf/verifier.c:1782
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8795 Comm: syz-executor439 Not tainted 5.3.0-rc3+ #101
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:219
  __warn.cold+0x20/0x4c kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:__mark_chain_precision+0x197a/0x1ea0 kernel/bpf/verifier.c:1782
Code: 08 31 ff 89 de e8 a6 9e f2 ff 84 db 0f 85 07 ff ff ff e8 59 9d f2 ff  
48 c7 c7 a0 a7 91 87 c6 05 3d c6 21 08 01 e8 1e 10 c4 ff <0f> 0b 41 bc f2  
ff ff ff e9 e8 fe ff ff 48 8b bd d8 fe ff ff e8 cd
RSP: 0018:ffff88808609f380 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c3ba6 RDI: ffffed1010c13e62
RBP: ffff88808609f4d0 R08: ffff8880a97940c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880985b6cc0 R14: ffff88808e538e80 R15: ffff88808609f468
  mark_chain_precision kernel/bpf/verifier.c:1819 [inline]
  check_cond_jmp_op+0xcd8/0x3c30 kernel/bpf/verifier.c:5841
  do_check+0x63cd/0x8a30 kernel/bpf/verifier.c:7783
  bpf_check+0x6fff/0x99b2 kernel/bpf/verifier.c:9297
  bpf_prog_load+0xe68/0x1670 kernel/bpf/syscall.c:1709
  __do_sys_bpf+0xa44/0x3350 kernel/bpf/syscall.c:2860
  __se_sys_bpf kernel/bpf/syscall.c:2819 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2819
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc52f10618 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402a9
RDX: 0000000000000048 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401b30
R13: 0000000000401bc0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
