Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD6C16389D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgBSAhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:37:14 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39330 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgBSAhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:37:14 -0500
Received: by mail-il1-f200.google.com with SMTP id c24so18559145ila.6
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 16:37:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=G0UMOdy6Hx8tmKoct5pIw4vcRna5accTPF/IPfYBhh8=;
        b=uF9zrzUvBbuvdbFohRjyN27rL5ehWriL0XcVx0L9K9Vj5tepWHgfu7r9F7CMyG+LH/
         TX+6DpV7eMzj/rZIIaSM50UzRcpYj/q8lkhcLONd7ZVYQaNdgUkriXshPoXKLnv3nHjc
         6UykGCXih0rIVrTAn3rwaiol7QB574cFJHpwRVnqqJdH1L9k/ymMGl/4tB+RoFHS+Z6T
         ApOctAlHECOMa6cx9rWbWomBkzv9W/LhiLMhpUj1v6hq1G/TsTUfCfY0kqe88HdwBklD
         MECjgcqN8h6dc/p+r/se0FffgBnMxSoLXYq2cLr9bo1A/KWx4Bb3iUV6/6qka/J1Y8Lk
         BTgg==
X-Gm-Message-State: APjAAAUcyeAHdrpYrwNzfk7lkHS0bNifl7EHu8alPIZBARPUMExP8EHq
        voeW6m4PPvcEV7lv66ZMD8ezx+CEX5R41NbgGnnWVYuf1Waq
X-Google-Smtp-Source: APXvYqxOg5ZusHJNKTp/6eLXbbdM4Rp9vPcRFhbcxm0I2XjrAgydk5UUE1yoPNaa6Fjw6Hh2aQjFeU4NrVNqHINA9iSJrgBj5SuJ
MIME-Version: 1.0
X-Received: by 2002:a6b:e411:: with SMTP id u17mr18784050iog.39.1582072633265;
 Tue, 18 Feb 2020 16:37:13 -0800 (PST)
Date:   Tue, 18 Feb 2020 16:37:13 -0800
In-Reply-To: <0000000000000973ee059eaf4de6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000509454059ee2fd96@google.com>
Subject: Re: possible deadlock in bpf_lru_push_free
From:   syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, hdanton@sina.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    e20d3a05 bpf, offload: Replace bitwise AND by logical AND ..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1491c481e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7d35de59001df38
dashboard link: https://syzkaller.appspot.com/bug?extid=122b5421d14e68f29cd1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ca6c45e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134bae29e00000

Bisection is inconclusive: the first bad commit could be any of:

36a375c6 mailmap: add entry for Tiezhu Yang
95c472ff Documentation/ko_KR/howto: Update a broken link
ff1e81a7 Documentation: build warnings related to missing blank lines after explicit markups has been fixed
5549c202 Documentation/ko_KR/howto: Update broken web addresses
599e6f8d Documentation: changes.rst: update several outdated project URLs
4bfdebd6 docs/locking: Fix outdated section names
d1c9038a Allow git builds of Sphinx
41dcd67e Merge tag 'docs-5.6-2' of git://git.lwn.net/linux

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c6c36ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
======================================================
WARNING: possible circular locking dependency detected
5.5.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor198/9748 is trying to acquire lock:
ffffe8ffffc49158 (&l->lock){....}, at: bpf_lru_list_push_free kernel/bpf/bpf_lru_list.c:313 [inline]
ffffe8ffffc49158 (&l->lock){....}, at: bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:532 [inline]
ffffe8ffffc49158 (&l->lock){....}, at: bpf_lru_push_free+0xe5/0x5b0 kernel/bpf/bpf_lru_list.c:555

but task is already holding lock:
ffff88809f6c3b60 (&htab->buckets[i].lock){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&htab->buckets[i].lock){....}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
       __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220 [inline]
       __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:266
       bpf_percpu_lru_pop_free kernel/bpf/bpf_lru_list.c:416 [inline]
       bpf_lru_pop_free+0xa9f/0x1670 kernel/bpf/bpf_lru_list.c:497
       prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
       __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
       bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
       bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
       map_update_elem kernel/bpf/syscall.c:1089 [inline]
       __do_sys_bpf+0x3163/0x41e0 kernel/bpf/syscall.c:3384
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&l->lock){....}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       bpf_lru_list_push_free kernel/bpf/bpf_lru_list.c:313 [inline]
       bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:532 [inline]
       bpf_lru_push_free+0xe5/0x5b0 kernel/bpf/bpf_lru_list.c:555
       __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
       htab_lru_percpu_map_lookup_and_delete_batch+0x37/0x40 kernel/bpf/hashtab.c:1474
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&htab->buckets[i].lock);
                               lock(&l->lock);
                               lock(&htab->buckets[i].lock);
  lock(&l->lock);

 *** DEADLOCK ***

2 locks held by syz-executor198/9748:
 #0: ffffffff89bac200 (rcu_read_lock){....}, at: __htab_map_lookup_and_delete_batch+0x54b/0x1540 kernel/bpf/hashtab.c:1308
 #1: ffff88809f6c3b60 (&htab->buckets[i].lock){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322

stack backtrace:
CPU: 0 PID: 9748 Comm: syz-executor198 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
 bpf_lru_list_push_free kernel/bpf/bpf_lru_list.c:313 [inline]
 bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:532 [inline]
 bpf_lru_push_free+0xe5/0x5b0 kernel/bpf/bpf_lru_list.c:555
 __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
 htab_lru_percpu_map_lookup_and_delete_batch+0x37/0x40 kernel/bpf/hashtab.c:1474
 bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
 __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
 __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
 __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440c09
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff14512e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004a2390 RCX: 0000000000440c09
RDX: 0000000000000038 RSI: 0000000020000100 RDI: 0000000000000019
RBP: 00000000006cb018 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 0000000000402110
R13: 00000000004021a0 R14: 0000000000000000 R15: 0000000000000000

