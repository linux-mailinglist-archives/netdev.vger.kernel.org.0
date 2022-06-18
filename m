Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AAD550740
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 00:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiFRWP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 18:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiFRWPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 18:15:23 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEAFDEF8
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 15:15:21 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id n12-20020a92260c000000b002d3c9fc68d6so4925734ile.19
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 15:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cExQdbV21IqFMasbKvZDPSAnWQDgKTx+CTrkWms6YdA=;
        b=o9TqOmcbnwuW/FUEAHqw4I+vMX3z+lYWpXn6MKS3v+7FBnRal9kqQP6lVecqCwgU3v
         8UcWsnAs0MiBoxeWebJQ8+yUxwR8KmKUdraA9imvVLXQ54F6BcosqN1N2lkHQUL/ve/M
         XqV4G9qooYsxPocPdiLFgrBoI39caZfk7LEISCCXHe2nNDVIUUQ/ILkme5h980wR9Qsm
         QA2/IlzPQYWJl4d9x151mKOBIHUIHOwgtatJebcZqEMw4y1cv6jdWHxPsfAX8dnY77Xg
         WelQJflHB+AYJdf6aeHPkf2o7GDF91SWsdUjA9QQfAHU8r8ucO15AqM6fs2guZj8MySl
         A9pg==
X-Gm-Message-State: AJIora8SIHYRn7BHGnEmZnNvooOUBE0sBRlsR0wk0LiaujHLOJv/IVvO
        JyWGqqgPEb+0IevgYPQOUJ3pN1GVkWHSI9/WZ8QZEB5ZD6kv
X-Google-Smtp-Source: AGRyM1sARy0g+5GkMm0W+suRvje6+JpWzSbPJ5cyjpiWIkQY8QW6Ni49id3SO+uMBASqQRfaDvMt/vImGE6pZaSeePhIv8+MtdPU
MIME-Version: 1.0
X-Received: by 2002:a6b:c985:0:b0:66c:ce19:a5b6 with SMTP id
 z127-20020a6bc985000000b0066cce19a5b6mr6874900iof.94.1655590520975; Sat, 18
 Jun 2022 15:15:20 -0700 (PDT)
Date:   Sat, 18 Jun 2022 15:15:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e57c2b05e1c03426@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in __vmalloc_node_range
From:   syzbot <syzbot+b577bc624afda52c78de@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bigeasy@linutronix.de, bpf@vger.kernel.org, brauner@kernel.org,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    35d872b9ea5b Add linux-next specific files for 20220614
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=155b0d10080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d7bf2236c6bb2403
dashboard link: https://syzkaller.appspot.com/bug?extid=b577bc624afda52c78de
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b577bc624afda52c78de@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/vmalloc.c:2980
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 30561, name: syz-executor.0
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
no locks held by syz-executor.0/30561.
Preemption disabled at:
[<ffffffff81bc76f5>] rmqueue_pcplist mm/page_alloc.c:3813 [inline]
[<ffffffff81bc76f5>] rmqueue mm/page_alloc.c:3858 [inline]
[<ffffffff81bc76f5>] get_page_from_freelist+0x455/0x3a20 mm/page_alloc.c:4293
CPU: 1 PID: 30561 Comm: syz-executor.0 Not tainted 5.19.0-rc2-next-20220614-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9823
 vm_area_alloc_pages mm/vmalloc.c:2980 [inline]
 __vmalloc_area_node mm/vmalloc.c:3025 [inline]
 __vmalloc_node_range+0x6a1/0x13b0 mm/vmalloc.c:3195
 alloc_thread_stack_node kernel/fork.c:311 [inline]
 dup_task_struct kernel/fork.c:971 [inline]
 copy_process+0x1568/0x7080 kernel/fork.c:2065
 kernel_clone+0xe7/0xab0 kernel/fork.c:2649
 __do_sys_clone+0xba/0x100 kernel/fork.c:2783
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe727a8a531
Code: 48 85 ff 74 3d 48 85 f6 74 38 48 83 ee 10 48 89 4e 08 48 89 3e 48 89 d7 4c 89 c2 4d 89 c8 4c 8b 54 24 08 b8 38 00 00 00 0f 05 <48> 85 c0 7c 13 74 01 c3 31 ed 58 5f ff d0 48 89 c7 b8 3c 00 00 00
RSP: 002b:00007ffee47acde8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fe728cb3700 RCX: 00007fe727a8a531
RDX: 00007fe728cb39d0 RSI: 00007fe728cb32f0 RDI: 00000000003d0f00
RBP: 00007ffee47ad030 R08: 00007fe728cb3700 R09: 00007fe728cb3700
R10: 00007fe728cb39d0 R11: 0000000000000206 R12: 00007ffee47ace9e
R13: 00007ffee47ace9f R14: 00007fe728cb3300 R15: 0000000000022000
 </TASK>
BUG: scheduling while atomic: syz-executor.0/30561/0x00000002
no locks held by syz-executor.0/30561.
Modules linked in:
Preemption disabled at:
[<ffffffff81bc76f5>] rmqueue_pcplist mm/page_alloc.c:3813 [inline]
[<ffffffff81bc76f5>] rmqueue mm/page_alloc.c:3858 [inline]
[<ffffffff81bc76f5>] get_page_from_freelist+0x455/0x3a20 mm/page_alloc.c:4293


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
