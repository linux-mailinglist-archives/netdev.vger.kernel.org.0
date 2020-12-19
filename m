Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCD22DEDC8
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 08:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgLSH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 02:56:50 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:56425 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgLSH4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 02:56:49 -0500
Received: by mail-io1-f70.google.com with SMTP id e14so3544634iow.23
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 23:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=s7h6mFvDc/Ce4O+16ifiHi7SJvQ+hFCpQ5/hLq9F0WE=;
        b=NwBthns4pjuihxxcntCZEjP3mMMAQHlTeP5N4usnnxnxDIVLcGLYT+aOkSa4u1uHdw
         8sRIPjZfK8rqpG8UXnvh8aB91VoAwyMtEDS/sGQ09fFpu5Si7EAWqLPFmlzwKwyPEDfC
         ZGFkM9ppc/kBMvIpD2rRDUvsH+aSorGqTxOoopVAxkVQkfyqPKPIHzr0DnDdSKtvmiJe
         fivSsMFyBkBKcNuvDgbitguSHoScmQMq8jInTnSeaWPy3ZBkvdSmK2Yu9XVzArK00jt8
         8rveNCqP0QlFCltFysm8utfFIRkWhbiX6ns+K2zcS0f4ueDGV66go2AfdlQAdsd85jHE
         CvkQ==
X-Gm-Message-State: AOAM533bcCxrq0U0ZKH0m20WZQuf9s2g9/wp281k6PPVDXOGoROk6tZG
        Lk9p+IW/lseHEuzmODHTjHo3sQBTFHtTexYEhhpkTvwy2rdZ
X-Google-Smtp-Source: ABdhPJyL6kaL6yC7lhDapNwEFM/IpUCqIzxIKUgqIy+Z9+eiXOgO14e7Ej7292RRBChagRerhZVj6Ug9ir22pzfgCemOP0usSCWv
MIME-Version: 1.0
X-Received: by 2002:a92:c206:: with SMTP id j6mr7819867ilo.189.1608364568409;
 Fri, 18 Dec 2020 23:56:08 -0800 (PST)
Date:   Fri, 18 Dec 2020 23:56:08 -0800
In-Reply-To: <000000000000e2852705ac9cfd73@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4fd0405b6cc8e53@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in lock_sock_nested
From:   syzbot <syzbot+9a0875bc1b2ca466b484@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a409ed15 Merge tag 'gpio-v5.11-1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=174778a7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20efebc728efc8ff
dashboard link: https://syzkaller.appspot.com/bug?extid=9a0875bc1b2ca466b484
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a4445b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a0875bc1b2ca466b484@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __lock_acquire+0x3da6/0x54b0 kernel/locking/lockdep.c:4702
Read of size 8 at addr ffff88801938c0a0 by task kworker/1:1/34

CPU: 1 PID: 34 Comm: kworker/1:1 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 __lock_acquire+0x3da6/0x54b0 kernel/locking/lockdep.c:4702
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x29d/0x750 kernel/locking/lockdep.c:5402
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
 l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xbc/0xaa0 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 11222:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3659 [inline]
 __kmalloc+0x18b/0x340 mm/slab.c:3668
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 tomoyo_get_name+0x22b/0x4c0 security/tomoyo/memory.c:173
 tomoyo_parse_name_union+0xbc/0x160 security/tomoyo/util.c:260
 tomoyo_update_path_acl security/tomoyo/file.c:395 [inline]
 tomoyo_write_file+0x4c0/0x7f0 security/tomoyo/file.c:1022
 tomoyo_write_domain2+0x116/0x1d0 security/tomoyo/common.c:1152
 tomoyo_add_entry security/tomoyo/common.c:2042 [inline]
 tomoyo_supervisor+0xbee/0xf20 security/tomoyo/common.c:2103
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
 tomoyo_path_perm+0x37c/0x3f0 security/tomoyo/file.c:838
 tomoyo_path_symlink+0x94/0xe0 security/tomoyo/tomoyo.c:200
 security_path_symlink+0xdf/0x150 security/security.c:1111
 do_symlinkat+0x123/0x2c0 fs/namei.c:3985
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88801938c000
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 32 bytes to the right of
 128-byte region [ffff88801938c000, ffff88801938c080)
The buggy address belongs to the page:
page:00000000b7b67fec refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1938c
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00004e6508 ffffea0000a5cf48 ffff888010840400
raw: 0000000000000000 ffff88801938c000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801938bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801938c000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88801938c080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                               ^
 ffff88801938c100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801938c180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

