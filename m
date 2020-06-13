Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD891F8075
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFMCyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 22:54:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:38936 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgFMCyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 22:54:18 -0400
Received: by mail-il1-f199.google.com with SMTP id o12so7779055ilf.6
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 19:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2sTEwf/dIwoLKdcZR4OJH4pgPYYKC7Y9Uyd/iQYIEmc=;
        b=uGKBpj/cPWA647yJ7k83aT5gCUxs87HSs1ptge54PuNY6QAsjCnO4C6vyZK6UR9Cav
         O85PkQbV8KN/Xe8jbPLY5cbQsa0fXtQIyGhSq4CNa7HZW2CtoGXi/PWOnegOvLdV0YHJ
         d5jGt01tJe7X9nll/6rBap+NI6sP1bJ5r+Lp42tyy3DzOAVRMYl6uoOkspRwl4ZuWGF4
         F5zr0KsjbZPE19f0eLCY6JmcnERYQbh0/Q9iRG12//ehLplqfrXQYfEYeLbllmAlRGqW
         h1p+PapowizbJvt8s6EKkUTVxMgR+I+kjicz0kIyw7tF2Mrk0wo4SDCRBPl/w00xZyj0
         5nhg==
X-Gm-Message-State: AOAM530AMj06zifD/Id79fK8CPGT0MLSlsFJyLPIp8locnEPTNCijX1Z
        8/EEh62kak2qjOz2cIzszNi/aheXaMz1xrOrwqtcFrH7KgiW
X-Google-Smtp-Source: ABdhPJyTI2AmElM6YKf+llXBNJ0mP8Cc0Rmg6aWKuK96797tA+cQSAIFNoWLmJXkBJBJeC/6Cw35zYFbicZ3JZY60zs24jDyLeuq
MIME-Version: 1.0
X-Received: by 2002:a6b:8b51:: with SMTP id n78mr16520705iod.120.1592016855260;
 Fri, 12 Jun 2020 19:54:15 -0700 (PDT)
Date:   Fri, 12 Jun 2020 19:54:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022653b05a7ee4f9a@google.com>
Subject: net boot error: BUG: using smp_processor_id() in preemptible code in ext4_mb_new_blocks
From:   syzbot <syzbot+e10468d1d0662fdb7c8c@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, davem@davemloft.net, kuba@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6954a9e4 ibmvnic: Flush existing work items before device ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1367d939100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b366fd92adf6f8b4
dashboard link: https://syzkaller.appspot.com/bug?extid=e10468d1d0662fdb7c8c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e10468d1d0662fdb7c8c@syzkaller.appspotmail.com

BUG: using smp_processor_id() in preemptible [00000000] code: systemd-tmpfile/3971
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 3971 Comm: systemd-tmpfile Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 ext4_getblk+0xad/0x520 fs/ext4/inode.c:833
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:883
 ext4_append+0x153/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2757 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2802
 vfs_mkdir+0x419/0x690 fs/namei.c:3627
 do_mkdirat+0x21e/0x280 fs/namei.c:3650
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7ffa928d3687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff732d3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00005637eeaceda0 RCX: 00007ffa928d3687
RDX: 0000000000000000 RSI: 00000000000001ed RDI: 00005637eeaceda0
RBP: 00000000000001ed R08: 000000000000feff R09: 000000000000004c
R10: 00005637eeaced80 R11: 0000000000000246 R12: 0000000000000012
R13: 00005637eeacf640 R14: 0000000000000000 R15: 0000000000000000
BUG: using smp_processor_id() in preemptible [00000000] code: systemd-tmpfile/3971
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 3971 Comm: systemd-tmpfile Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 ext4_getblk+0xad/0x520 fs/ext4/inode.c:833
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:883
 ext4_append+0x153/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2757 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2802
 vfs_mkdir+0x419/0x690 fs/namei.c:3627
 do_mkdirat+0x21e/0x280 fs/namei.c:3650
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7ffa928d3687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff732d3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00005637eead0870 RCX: 00007ffa928d3687
RDX: 0000000000000000 RSI: 00000000000003ff RDI: 00005637eead0870
RBP: 00000000000003ff R08: 000000000000fec0 R09: 000000000000004c
R10: 00005637eead0840 R11: 0000000000000246 R12: 0000000000000012
R13: 00005637eead0890 R14: 0000000000000000 R15: 0000000000000000
BUG: using smp_processor_id() in preemptible [00000000] code: systemd-tmpfile/3971
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 1 PID: 3971 Comm: systemd-tmpfile Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 ext4_getblk+0xad/0x520 fs/ext4/inode.c:833
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:883
 ext4_append+0x153/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2757 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2802
 vfs_mkdir+0x419/0x690 fs/namei.c:3627
 do_mkdirat+0x21e/0x280 fs/namei.c:3650
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7ffa928d3687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff732d3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00005637eeace050 RCX: 00007ffa928d3687
RDX: 0000000000000000 RSI: 00000000000003ff RDI: 00005637eeace050
RBP: 00000000000003ff R08: 000000000000fec0 R09: 000000000000004c
R10: 00005637eeace040 R11: 0000000000000246 R12: 0000000000000012
R13: 00005637eeace070 R14: 0000000000000000 R15: 0000000000000000
BUG: using smp_processor_id() in preemptible [00000000] code: systemd-tmpfile/3971
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 3971 Comm: systemd-tmpfile Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 ext4_getblk+0xad/0x520 fs/ext4/inode.c:833
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:883
 ext4_append+0x153/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2757 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2802
 vfs_mkdir+0x419/0x690 fs/namei.c:3627
 do_mkdirat+0x21e/0x280 fs/namei.c:3650
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7ffa928d3687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff732d3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00005637eeace160 RCX: 00007ffa928d3687
RDX: 0000000000000000 RSI: 00000000000003ff RDI: 00005637eeace160
RBP: 00000000000003ff R08: 000000000000fec0 R09: 000000000000004c
R10: 00005637eeace140 R11: 0000000000000246 R12: 0000000000000012
R13: 00005637eeace180 R14: 0000000000000000 R15: 0000000000000000
BUG: using smp_processor_id() in preemptible [00000000] code: systemd-tmpfile/3971
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 3971 Comm: systemd-tmpfile Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 ext4_getblk+0xad/0x520 fs/ext4/inode.c:833
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:883
 ext4_append+0x153/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2757 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2802
 vfs_mkdir+0x419/0x690 fs/namei.c:3627
 do_mkdirat+0x21e/0x280 fs/namei.c:3650
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7ffa928d3687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff732d3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00005637eead1890 RCX: 00007ffa928d3687
RDX: 0000000000000000 RSI: 00000000000003ff RDI: 00005637eead1890
RBP: 00000000000003ff R08: 000000000000fec0 R09: 000000000000004c
R10: 00005637eead1880 R11: 0000000000000246 R12: 0000000000000012
R13: 00005637eead18b0 R14: 0000000000000000 R15: 0000000000000000
BUG: using smp_processor_id() in preemptible [00000000] code: systemd-tmpfile/3971
caller is ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
CPU: 0 PID: 3971 Comm: systemd-tmpfile Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 ext4_mb_new_blocks+0xa77/0x3b30 fs/ext4/mballoc.c:4711
 ext4_ext_map_blocks+0x2044/0x3410 fs/ext4/extents.c:4244
 ext4_map_blocks+0x4cb/0x1640 fs/ext4/inode.c:626
 ext4_getblk+0xad/0x520 fs/ext4/inode.c:833
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:883
 ext4_append+0x153/0x360 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2757 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2802
 vfs_mkdir+0x419/0x690 fs/namei.c:3627
 do_mkdirat+0x21e/0x280 fs/namei.c:3650
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7ffa928d3687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff732d3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00005637eead19a0 RCX: 00007ffa928d3687
RDX: 0000000000000000 RSI: 00000000000003ff RDI: 00005637eead19a0
RBP: 00000000000003ff R08: 000000000000fec0 R09: 000000000000004c
R10: 00005637eead1980 R11: 0000000000000246 R12: 0000000000000012
R13: 00005637eead19c0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
