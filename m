Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E210616100
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiKBKhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiKBKhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:37:12 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C8229835
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 03:36:50 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id n1-20020a6b7701000000b006d1f2c2850aso6679646iom.0
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 03:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B+5G9YOyBZC5keBKXNouF3ZVV7nJu79PwBan1THF9vc=;
        b=t8bXbxwi0VC8pC+/PqW+rkAb/hSB6UWR4wzuCgp+aLac8vuzUz5tjeHWQQb5G5UQnn
         o0vcLDp3nXVn6/cX45cY/TcD62jjSCbPI6EwY25NeFYQupT3N4zfw4fUGBsGoPLpD1/W
         moNGZQe6tYcXXIFzm9K824UZLsoblz7ilrxfcG2Wq7R/weF5PVluom7af9PMHT8GlnfX
         6I8NpsOOG3zcH4uOQ9xQuIvPJ0j+uNAzpmTQ0WnlcpaVDtYTqC5SqNL+ypUHVt54GjUb
         5N+wWOAXgu0Cp9IKEQ7jmrBhUx5TwDh8jx6Jud94p7kLNBL4hEYuZCfqMWrZDpEQKS7I
         NAbg==
X-Gm-Message-State: ACrzQf35fA0FQJf1tvSRI8GSTh4W0kJi5nm864pX/cjCvCkZQvMxDJwN
        DWGWeeaVvOEVKXiYX7zBnrDaBoApAvIR9doL3iVJVo/hHe+O
X-Google-Smtp-Source: AMsMyM7DbXv4ATlq24ddfaVIMDBbLcjX+mGxk+stBiORoQta7jBCFXoyG5BIL82qGy0WhIVRaPUfJVdPo99VfaVAKDF+btLN65oY
MIME-Version: 1.0
X-Received: by 2002:a92:c102:0:b0:300:cf38:1743 with SMTP id
 p2-20020a92c102000000b00300cf381743mr1801992ile.114.1667385409487; Wed, 02
 Nov 2022 03:36:49 -0700 (PDT)
Date:   Wed, 02 Nov 2022 03:36:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009483d05ec7a6b93@google.com>
Subject: [syzbot] possible deadlock in static_key_slow_inc (2)
From:   syzbot <syzbot+c39682e86c9d84152f93@syzkaller.appspotmail.com>
To:     cgroups@vger.kernel.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a2c65a9d0568 net: dsa: fall back to default tagger if we c..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10cfb046880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
dashboard link: https://syzkaller.appspot.com/bug?extid=c39682e86c9d84152f93
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159ad4fc880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159d8591880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c43fc9428e96/disk-a2c65a9d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef96432b3e62/vmlinux-a2c65a9d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ee926615bbfc/bzImage-a2c65a9d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c39682e86c9d84152f93@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.1.0-rc2-syzkaller-00201-ga2c65a9d0568 #0 Not tainted
------------------------------------------------------
syz-executor229/3606 is trying to acquire lock:
ffffffff8be35130 (cpu_hotplug_lock){++++}-{0:0}, at: static_key_slow_inc+0xe/0x20 kernel/jump_label.c:158

but task is already holding lock:
ffffffff8bfda0c8 (freezer_mutex){+.+.}-{3:3}, at: freezer_change_state kernel/cgroup/legacy_freezer.c:387 [inline]
ffffffff8bfda0c8 (freezer_mutex){+.+.}-{3:3}, at: freezer_write+0x98/0xa50 kernel/cgroup/legacy_freezer.c:426

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (freezer_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       freezer_attach+0x70/0x1f0 kernel/cgroup/legacy_freezer.c:163
       cgroup_migrate_execute+0xbcf/0x1230 kernel/cgroup/cgroup.c:2615
       cgroup_attach_task+0x41c/0x870 kernel/cgroup/cgroup.c:2906
       __cgroup1_procs_write.constprop.0+0x3be/0x4b0 kernel/cgroup/cgroup-v1.c:523
       cgroup_file_write+0x1de/0x770 kernel/cgroup/cgroup.c:4057
       kernfs_fop_write_iter+0x3f8/0x610 fs/kernfs/file.c:330
       call_write_iter include/linux/fs.h:2191 [inline]
       new_sync_write fs/read_write.c:491 [inline]
       vfs_write+0x9e9/0xdd0 fs/read_write.c:584
       ksys_write+0x127/0x250 fs/read_write.c:637
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (cgroup_threadgroup_rwsem){++++}-{0:0}:
       percpu_down_write+0x4f/0x390 kernel/locking/percpu-rwsem.c:227
       cgroup_attach_lock kernel/cgroup/cgroup.c:2431 [inline]
       cgroup_procs_write_start+0x151/0x630 kernel/cgroup/cgroup.c:2935
       __cgroup_procs_write+0xd7/0x650 kernel/cgroup/cgroup.c:5135
       cgroup_procs_write+0x22/0x50 kernel/cgroup/cgroup.c:5171
       cgroup_file_write+0x1de/0x770 kernel/cgroup/cgroup.c:4057
       kernfs_fop_write_iter+0x3f8/0x610 fs/kernfs/file.c:330
       call_write_iter include/linux/fs.h:2191 [inline]
       new_sync_write fs/read_write.c:491 [inline]
       vfs_write+0x9e9/0xdd0 fs/read_write.c:584
       ksys_write+0x127/0x250 fs/read_write.c:637
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (cpu_hotplug_lock){++++}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
       lock_acquire kernel/locking/lockdep.c:5668 [inline]
       lock_acquire+0x1df/0x630 kernel/locking/lockdep.c:5633
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       cpus_read_lock+0x3e/0x140 kernel/cpu.c:310
       static_key_slow_inc+0xe/0x20 kernel/jump_label.c:158
       freezer_apply_state+0x1e1/0x260 kernel/cgroup/legacy_freezer.c:353
       freezer_change_state kernel/cgroup/legacy_freezer.c:398 [inline]
       freezer_write+0x571/0xa50 kernel/cgroup/legacy_freezer.c:426
       cgroup_file_write+0x1de/0x770 kernel/cgroup/cgroup.c:4057
       kernfs_fop_write_iter+0x3f8/0x610 fs/kernfs/file.c:330
       call_write_iter include/linux/fs.h:2191 [inline]
       new_sync_write fs/read_write.c:491 [inline]
       vfs_write+0x9e9/0xdd0 fs/read_write.c:584
       ksys_write+0x127/0x250 fs/read_write.c:637
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

Chain exists of:
  cpu_hotplug_lock --> cgroup_threadgroup_rwsem --> freezer_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(freezer_mutex);
                               lock(cgroup_threadgroup_rwsem);
                               lock(freezer_mutex);
  lock(cpu_hotplug_lock);

 *** DEADLOCK ***

4 locks held by syz-executor229/3606:
 #0: ffff888079bc2460 (sb_writers#10){.+.+}-{0:0}, at: ksys_write+0x127/0x250 fs/read_write.c:637
 #1: ffff88801fa91c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x28c/0x610 fs/kernfs/file.c:321
 #2: ffff888145b99a00 (kn->active#56){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2b0/0x610 fs/kernfs/file.c:322
 #3: ffffffff8bfda0c8 (freezer_mutex){+.+.}-{3:3}, at: freezer_change_state kernel/cgroup/legacy_freezer.c:387 [inline]
 #3: ffffffff8bfda0c8 (freezer_mutex){+.+.}-{3:3}, at: freezer_write+0x98/0xa50 kernel/cgroup/legacy_freezer.c:426

stack backtrace:
CPU: 0 PID: 3606 Comm: syz-executor229 Not tainted 6.1.0-rc2-syzkaller-00201-ga2c65a9d0568 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1df/0x630 kernel/locking/lockdep.c:5633
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 cpus_read_lock+0x3e/0x140 kernel/cpu.c:310
 static_key_slow_inc+0xe/0x20 kernel/jump_label.c:158
 freezer_apply_state+0x1e1/0x260 kernel/cgroup/legacy_freezer.c:353
 freezer_change_state kernel/cgroup/legacy_freezer.c:398 [inline]
 freezer_write+0x571/0xa50 kernel/cgroup/legacy_freezer.c:426
 cgroup_file_write+0x1de/0x770 kernel/cgroup/cgroup.c:4057
 kernfs_fop_write_iter+0x3f8/0x610 fs/kernfs/file.c:330
 call_write_iter include/linux/fs.h:2191 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9e9/0xdd0 fs/read_write.c:584
 ksys_write+0x127/0x250 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe89501f769
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 81 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff9816df18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fe89501f769
RDX: 0000000000000007 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00007fff9816df40 R09: 00007fff9816df40
R10: 00007fff9816df40 R11: 0000000000000246 R12: 00007fff9816df3c
R13: 00007fff9816df50 R14: 00007fff9816df90 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
