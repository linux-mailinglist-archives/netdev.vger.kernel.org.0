Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF087808
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 12:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406365AbfHIK6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 06:58:07 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:51786 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfHIK6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 06:58:07 -0400
Received: by mail-ot1-f71.google.com with SMTP id h12so67893393otn.18
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 03:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mUAdjdWVqLEji+9QaZjr6SC7lAukAXPaOBa5eBib/zQ=;
        b=RHLB3eflu30fWvSPZ/THJIyC28uuWcwydG7QajDePCNq8qLZAOoXZPe4gUYOfwEgwa
         oIi50JK8S5YUE5PLe9z9J/gOMMoLELAYl1PRa+fpZBP6zAsKaKXvpEpD/ASl6j9jP71d
         48oj9Hf7y2+p4iNA0CPMRyPMdjvJ7f63mYQ+AfWoJvo05q0AIjOkkjRe/bZVg1MvnTuD
         J2n87yHyntZlW93kL6joIqsrIBqk63dDxpuVNjC1GN9vVCNbtQeEt66y7TrzB7r4hNpf
         AJEPSHdy/s9t+NVLw3iq7H9nPEVXvGCJucYogdObJWZPWW+bwdB1fsXieXEy49edgxhi
         lFhw==
X-Gm-Message-State: APjAAAW0jBdQc6lpcSGTz7+EPkcY76Lbw948YS9bChJ/VtyILjxJ7j/R
        DGi2Z75dnWug1JFzGIwzKxKa8HnIUUvxe0HQg7mJ1k92+d+v
X-Google-Smtp-Source: APXvYqzfxc+WwHQY5PBUiXp07yIZY9T57CR+iHoYVMfbZymKTn0MCiZnMfMSJrsjUldT/7ClvmsuVvR5jWyz41ngOahYU63+uD9g
MIME-Version: 1.0
X-Received: by 2002:a5d:924e:: with SMTP id e14mr19114492iol.215.1565348286229;
 Fri, 09 Aug 2019 03:58:06 -0700 (PDT)
Date:   Fri, 09 Aug 2019 03:58:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008cf14e058fad0c41@google.com>
Subject: KASAN: null-ptr-deref Write in rxrpc_unuse_local
From:   syzbot <syzbot+20dee719a2e090427b5f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    87b983f5 Add linux-next specific files for 20190809
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=143aecee600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28eea330e11df0eb
dashboard link: https://syzkaller.appspot.com/bug?extid=20dee719a2e090427b5f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ceae36600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ebc40e600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+20dee719a2e090427b5f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in atomic_sub_return  
include/asm-generic/atomic-instrumented.h:159 [inline]
BUG: KASAN: null-ptr-deref in atomic_dec_return  
include/linux/atomic-fallback.h:455 [inline]
BUG: KASAN: null-ptr-deref in rxrpc_unuse_local+0x23/0x70  
net/rxrpc/local_object.c:405
Write of size 4 at addr 0000000000000010 by task syz-executor725/10010

CPU: 1 PID: 10010 Comm: syz-executor725 Not tainted 5.3.0-rc3-next-20190809  
#63
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  __kasan_report.cold+0x5/0x36 mm/kasan/report.c:486
  kasan_report+0x12/0x17 mm/kasan/common.c:610
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:98
  atomic_sub_return include/asm-generic/atomic-instrumented.h:159 [inline]
  atomic_dec_return include/linux/atomic-fallback.h:455 [inline]
  rxrpc_unuse_local+0x23/0x70 net/rxrpc/local_object.c:405
  rxrpc_release_sock net/rxrpc/af_rxrpc.c:904 [inline]
  rxrpc_release+0x47d/0x840 net/rxrpc/af_rxrpc.c:930
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x92f/0x2e50 kernel/exit.c:879
  do_group_exit+0x135/0x360 kernel/exit.c:983
  __do_sys_exit_group kernel/exit.c:994 [inline]
  __se_sys_exit_group kernel/exit.c:992 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:992
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43ed68
Code: Bad RIP value.
RSP: 002b:00007ffc2b7b93f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ed68
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004be568 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d0180 R14: 0000000000000000 R15: 0000000000000000
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
