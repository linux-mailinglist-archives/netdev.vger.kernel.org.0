Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE4227A8FC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgI1HsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:48:20 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:54734 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgI1HsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:48:18 -0400
Received: by mail-io1-f80.google.com with SMTP id q6so122896iod.21
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sHiwNxX8GC1iKEEamqk3dO6J+qVxnmSiPqyG59sC93I=;
        b=ZdJPfo/x4RFSIq632sGnfArVLdZmO1WwOUzlSUNu+zzqwKSCg/6IcC9GKBd8LEAW/4
         gWbBgs0Lt6Uuhp8Y231f5NExSNru1NW0KKnFWUjGmXdVab28Y6I2Uh813VvWcGvKvb3O
         1ulkOK+lXl5MorLha2z9uT/X8uGrrjwFkQXybnavHK92WV87aH3WkFs80ALG5ANgACQZ
         b8AYU2ubR3P1TejWATqfRSBGdeuvqqsylcxk2JCpVQN3FY32thP7TTwYG6sQLcbTC51M
         GU4urjWmZkcs49NIWe8Wvbc/DdFvBqdxhVyQG12jsmL7fXxy6GtjX1z7rtmCAkevjhKb
         Apkw==
X-Gm-Message-State: AOAM5301eMk2uzlXmIoKdAQK+A/9+oRLkfN/N6Gaz5Meic+0O1pLKlav
        ynVSYivsgKSMNRykFzLMHQ4sCuvtW6oIJcDN5JeYEBhEyEXf
X-Google-Smtp-Source: ABdhPJyjO1G66Y8IGOQ4OulAJXnyxM9C8oWnultlHOEp/oty93a35SqQt3u6ALJmNKtvL8Z0ecHzXlurH2LdXehP2sEgdF17mab4
MIME-Version: 1.0
X-Received: by 2002:a02:8802:: with SMTP id r2mr183105jai.75.1601279297711;
 Mon, 28 Sep 2020 00:48:17 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:48:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9f2ac05b05ae349@google.com>
Subject: WARNING: proc registration bug in afs_manage_cell
From:   syzbot <syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        hchunhui@mail.ustc.edu.cn, ja@ssi.bg, jmorris@namei.org,
        kaber@trash.net, kuznet@ms2.inr.ac.ru,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c9c9e6a4 Merge tag 'trace-v5.9-rc5-2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a34b1d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=b994ecf2b023f14832c1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164ee99b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165dd5c5900000

The issue was bisected to:

commit 0e7bbcc104baaade4f64205e9706b7d43c46db7d
Author: Julian Anastasov <ja@ssi.bg>
Date:   Wed Jul 27 06:56:50 2016 +0000

    neigh: allow admin to set NUD_STALE

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16850bab900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15850bab900000
console output: https://syzkaller.appspot.com/x/log.txt?x=11850bab900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com
Fixes: 0e7bbcc104ba ("neigh: allow admin to set NUD_STALE")

------------[ cut here ]------------
proc_dir_entry 'afs/^]$[+.](%{' already registered
WARNING: CPU: 1 PID: 2468 at fs/proc/generic.c:371 proc_register+0x34c/0x700 fs/proc/generic.c:371
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 2468 Comm: kworker/1:2 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: afs afs_manage_cell
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:proc_register+0x34c/0x700 fs/proc/generic.c:371
Code: df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 5d 03 00 00 48 8b 44 24 28 48 c7 c7 60 61 9a 88 48 8b b0 d8 00 00 00 e8 46 1b 5d ff <0f> 0b 48 c7 c7 60 f6 1e 8a e8 76 78 3d 06 48 8b 4c 24 38 48 b8 00
RSP: 0018:ffffc90008387ac8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880a06f0540 RSI: ffffffff815f5985 RDI: fffff52001070f4b
RBP: ffff8880a8237c50 R08: 0000000000000001 R09: ffff8880ae5318e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888086ce9d98
R13: ffff888086ce9c40 R14: dffffc0000000000 R15: 000000000000000a
 proc_mkdir_data+0x140/0x1a0 fs/proc/generic.c:487
 proc_net_mkdir include/linux/proc_fs.h:201 [inline]
 afs_proc_cell_setup+0xb2/0x1f0 fs/afs/proc.c:620
 afs_activate_cell fs/afs/cell.c:615 [inline]
 afs_manage_cell+0x56a/0x11c0 fs/afs/cell.c:697
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
