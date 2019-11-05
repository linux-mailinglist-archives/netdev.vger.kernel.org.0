Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C53EFC95
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbfKELmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 06:42:12 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51783 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbfKELmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 06:42:11 -0500
Received: by mail-io1-f69.google.com with SMTP id v14so1030015iob.18
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 03:42:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=P2JalRCzbuTnz7zbGMtCjjdpNiV9T9DN4NL3TjWGrGM=;
        b=ZoSkZ2UMhvl0cGwV5HekYLqK6yPwOMfurd6kVSbEnEuwUK5Zp3qYEsY0KWuEJQqflW
         xpRsZMYqgu2YLopc/MPtm8zwa0GUQhdXzTZrPfeebcOzy6y952+AFW3zGTiLrPh0389B
         GsxvfvsGThUR4bXFRZebLqFCEz0nRal2CuI44SfKesE2EDLCZrl3kX2vVx2MC1UzfGP4
         53JgetzW4y4wZlDdq9QdhS5hKr20PA+Tf5k+UQAVe13RdFbVrXpwm3XffeLzWrkvYFBs
         tdeYS0CTDz1hpsQj8pnhGtA/hZJ2Ss64YJjvPrBHOvDQxZKzqvTFy4ZtR4PK7DnNLExy
         SkiA==
X-Gm-Message-State: APjAAAXTnp/8x1IX+VdUHlLf5lGqA+6W1IWIjnLQE0OCPArWvkEFWqBy
        t/u1F2eoY8/GrGPnEfBi61MnoPUwy8wMXJv/zPrZoG31ndSd
X-Google-Smtp-Source: APXvYqzV0ZbhlU+W8da14/m/I2tCfQgtzi3aU0RAvBeifKHjxtejylfwRZ3agYiW/L+ZVw5cgBDTEq1VIrnFCsvbZONu197m3u4H
MIME-Version: 1.0
X-Received: by 2002:a6b:fb0c:: with SMTP id h12mr19050300iog.239.1572954129411;
 Tue, 05 Nov 2019 03:42:09 -0800 (PST)
Date:   Tue, 05 Nov 2019 03:42:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000021be64059697ec8c@google.com>
Subject: KCSAN: data-race in perf_event_update_userpage / perf_event_update_userpage
From:   syzbot <syzbot+3d30a087bef7b887dd14@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        elver@google.com, jolsa@redhat.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    05f22368 x86, kcsan: Enable KCSAN for x86
git tree:       https://github.com/google/ktsan.git kcsan
console output: https://syzkaller.appspot.com/x/log.txt?x=157a35f8e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87d111955f40591f
dashboard link: https://syzkaller.appspot.com/bug?extid=3d30a087bef7b887dd14
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3d30a087bef7b887dd14@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in perf_event_update_userpage /  
perf_event_update_userpage

write to 0xffff88812403c00c of 4 bytes by task 12674 on cpu 1:
  perf_event_update_userpage+0x157/0x340 kernel/events/core.c:5405
  cpu_clock_event_add+0x3d/0x60 kernel/events/core.c:9672
  event_sched_in.isra.0.part.0+0x1d5/0x560 kernel/events/core.c:2367
  event_sched_in kernel/events/core.c:2339 [inline]
  group_sched_in+0xd1/0x2c0 kernel/events/core.c:2403
  flexible_sched_in kernel/events/core.c:3418 [inline]
  flexible_sched_in+0x399/0x540 kernel/events/core.c:3407
  visit_groups_merge+0x1d9/0x320 kernel/events/core.c:3366
  ctx_flexible_sched_in kernel/events/core.c:3455 [inline]
  ctx_sched_in+0x1b4/0x360 kernel/events/core.c:3500
  perf_event_sched_in+0x77/0xb0 kernel/events/core.c:2512
  perf_event_context_sched_in kernel/events/core.c:3540 [inline]
  __perf_event_task_sched_in+0x354/0x390 kernel/events/core.c:3579
  perf_event_task_sched_in include/linux/perf_event.h:1150 [inline]
  finish_task_switch+0x108/0x260 kernel/sched/core.c:3221
  context_switch kernel/sched/core.c:3387 [inline]
  __schedule+0x319/0x640 kernel/sched/core.c:4069
  schedule+0x47/0xd0 kernel/sched/core.c:4136
  freezable_schedule include/linux/freezer.h:172 [inline]
  futex_wait_queue_me+0x18d/0x290 kernel/futex.c:2627
  futex_wait+0x19b/0x3f0 kernel/futex.c:2733

write to 0xffff88812403c00c of 4 bytes by task 12673 on cpu 0:
  perf_event_update_userpage+0x157/0x340 kernel/events/core.c:5405
  perf_mmap+0xe00/0xeb0 kernel/events/core.c:5875
  call_mmap include/linux/fs.h:1900 [inline]
  mmap_region+0x83c/0xd50 mm/mmap.c:1806
  do_mmap+0x6d4/0xba0 mm/mmap.c:1577
  do_mmap_pgoff include/linux/mm.h:2353 [inline]
  vm_mmap_pgoff+0x12d/0x190 mm/util.c:496
  ksys_mmap_pgoff+0x2d8/0x420 mm/mmap.c:1629
  __do_sys_mmap arch/x86/kernel/sys_x86_64.c:100 [inline]
  __se_sys_mmap arch/x86/kernel/sys_x86_64.c:91 [inline]
  __x64_sys_mmap+0x91/0xc0 arch/x86/kernel/sys_x86_64.c:91
  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 12673 Comm: syz-executor.0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
