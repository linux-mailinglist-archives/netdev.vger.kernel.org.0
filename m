Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E113C6C27
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhGMIrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:47:09 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39807 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbhGMIrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:47:09 -0400
Received: by mail-io1-f70.google.com with SMTP id v2-20020a5d94020000b02905058dc6c376so13787230ion.6
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SGLaUEdsHJ7M1Mbgv1zRM9qX7kbvyDf+IXJqA4OGQ3I=;
        b=Qyi0n4O6YpuSmj/gUU5/4nyLMqy6LlPZwpBCvXll7xvhnIZMjBshJnQHp83aRoD4Uw
         KJE2pXT8zFUESZHxGnm3tLXegUdeLvUiqYgES4gA2fGplxaczyi6hEHhmo2VzC7ybQ5I
         TRaMPi+ns/3hU5/TZuNw2ChRzJ72ugu1lUx/b7CTfmmeC09xKcXdvzdXdiI+pA/9Y9ct
         /7tPW7dxwjA84yJM6yyFt/o+PNckTfLWjvYkS1ZOhqljTIHRShA0BsBcVHcGfPIBIJS8
         qurX59mmx5lKFo8oKC8UWafng1tPvYQd0WSIepKFl7u5TwDXt3k+1ycM3hi+Q6e6pjyd
         e3SA==
X-Gm-Message-State: AOAM530kvUSDlln5q3N59EnGBfLZUyvA+W6L9+JhkedWtgATOL0MRMPT
        GxbM4FpKS8OVZ+HB9UF3Tg6rccD1+S3DUi8kS9GvthB2DeKb
X-Google-Smtp-Source: ABdhPJxlsaMGSc1NrME54Q5bqRcojRJndj3bNuyYQWKcMiYwf7Qaf94IHcuOzxIV4m1s7DpY9YrPQh9fYGiGezWjeT2A8u9ulcbu
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:120e:: with SMTP id a14mr2254280ilq.88.1626165859761;
 Tue, 13 Jul 2021 01:44:19 -0700 (PDT)
Date:   Tue, 13 Jul 2021 01:44:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ac33305c6fd3ed7@google.com>
Subject: [syzbot] net test error: BUG: sleeping function called from invalid
 context in stack_depot_save
From:   syzbot <syzbot+cb62a9d937430bacc247@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    67a9c943 net: validate lwtstate->data before returning fro..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16191402300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51ea6c9df4ed04c4
dashboard link: https://syzkaller.appspot.com/bug?extid=cb62a9d937430bacc247

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb62a9d937430bacc247@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8435, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffff814406db>] copy_process+0x1e1b/0x74c0 kernel/fork.c:2061
softirqs last  enabled at (0): [<ffffffff8144071c>] copy_process+0x1e5c/0x74c0 kernel/fork.c:2065
softirqs last disabled at (0): [<0000000000000000>] 0x0
CPU: 1 PID: 8435 Comm: syz-fuzzer Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9153
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5179
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 __vmalloc+0x69/0x80 mm/vmalloc.c:3010
 snd_dma_alloc_pages+0x433/0x590 sound/core/memalloc.c:150
 do_alloc_pages+0x9b/0x160 sound/core/pcm_memory.c:43
 snd_pcm_lib_malloc_pages+0x3f6/0x880 sound/core/pcm_memory.c:404
 snd_pcm_hw_params+0x1408/0x1990 sound/core/pcm_native.c:705
 snd_pcm_kernel_ioctl+0xd1/0x240 sound/core/pcm_native.c:3332
 snd_pcm_oss_change_params_locked+0x1958/0x3990 sound/core/oss/pcm_oss.c:947
 snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1090 [inline]
 snd_pcm_oss_make_ready+0xe7/0x1b0 sound/core/oss/pcm_oss.c:1149
 snd_pcm_oss_sync+0x1de/0x800 sound/core/oss/pcm_oss.c:1714
 snd_pcm_oss_release+0x276/0x300 sound/core/oss/pcm_oss.c:2556
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af19b
Code: fb ff eb bd e8 a6 b6 fb ff e9 61 ff ff ff cc e8 9b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
RSP: 002b:000000c0000db430 EFLAGS: 00000206 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000c00001e800 RCX: 00000000004af19b
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 000000c0000db470 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 000000000000013e
R13: 000000000000013d R14: 0000000000000200 R15: 000000c00045a000
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
