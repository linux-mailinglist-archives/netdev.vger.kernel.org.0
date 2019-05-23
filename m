Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4C273F6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfEWB2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:28:05 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33236 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbfEWB2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:28:05 -0400
Received: by mail-io1-f70.google.com with SMTP id s24so3396449iot.0
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 18:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Fl1AYilgXbXs+F9PHNE28XGBtd52ShtQBXn8a0buXtM=;
        b=qbt/pf5S939/pxVTspmzjDlslEw9k/l03AWD06NmAvG64ez9w7t5azllY4UimDAGsg
         gVFG/55F62q1YLL5NT1DQWgUvAnFwd9VN6HiML/UnfUErJFKhD7bkwUiSl81vaZn+sVx
         YiLjZZUNno9T9WeOpXGLldQ9cpduzyn2FFgCuCBb2Qcbjs6Bn1uaM46xTR/EiI9fWM+x
         1gA9TYR5w1J5aEKF4XPCx2t/taxgrnn0DGkKy9Cny5mcg9ijwrO7Fzth8axojavXH3Bd
         ReJlkCNM10ELA5RCkEGITIFqy6Lvp8eH8vSEyW2/BvGE5rD43UFb8W43rdl8hy7XJZ7O
         tLVQ==
X-Gm-Message-State: APjAAAXUfzZP+rJbNATIlbaoK3KwDQ9C4bBYxJJ53uHo7FfAyTYD5e1D
        t1gBXCreZVxwAneR4cRxcDvEdok2xc8sbgtIrgQaWKU44NT9
X-Google-Smtp-Source: APXvYqzX0h3gT6teKiHansNya0jnKEok1GtoBkOvu5aNPuUWBhoqjBYyEEdOXS+1Y+vmss07bHjSRq/fWzWtDf2XHMQ8srObdKET
MIME-Version: 1.0
X-Received: by 2002:a05:660c:2c5:: with SMTP id j5mr10636325itd.41.1558574884698;
 Wed, 22 May 2019 18:28:04 -0700 (PDT)
Date:   Wed, 22 May 2019 18:28:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005bc340058983fe8e@google.com>
Subject: memory leak in new_inode_pseudo
From:   syzbot <syzbot+111cb28d9f583693aefa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12dccd9ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=111cb28d9f583693aefa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1587839ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fdb38ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+111cb28d9f583693aefa@syzkaller.appspotmail.com

e list of known hosts.
executing program
BUG: memory leak
unreferenced object 0xffff888121bdfd00 (size 632):
   comm "syz-executor073", pid 7035, jiffies 4294943279 (age 8.130s)
   hex dump (first 32 bytes):
     01 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
     80 1e b6 1f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000088b15f0d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000088b15f0d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000088b15f0d>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000088b15f0d>] kmem_cache_alloc+0x134/0x270 mm/slab.c:3488
     [<000000001a541de3>] sock_alloc_inode+0x1d/0xe0 net/socket.c:252
     [<00000000226aca0e>] alloc_inode+0x2c/0xe0 fs/inode.c:226
     [<0000000054963a4b>] new_inode_pseudo+0x18/0x70 fs/inode.c:915
     [<00000000a577ddf0>] sock_alloc+0x1c/0x90 net/socket.c:575
     [<000000000e50448f>] __sock_create+0x8f/0x250 net/socket.c:1394
     [<00000000248d5219>] sock_create_kern+0x3b/0x50 net/socket.c:1499
     [<0000000081cd440d>] io_uring_get_fd fs/io_uring.c:2997 [inline]
     [<0000000081cd440d>] io_uring_create fs/io_uring.c:3080 [inline]
     [<0000000081cd440d>] io_uring_setup+0x4ea/0x990 fs/io_uring.c:3128
     [<00000000b95ec5c9>] __do_sys_io_uring_setup fs/io_uring.c:3141 [inline]
     [<00000000b95ec5c9>] __se_sys_io_uring_setup fs/io_uring.c:3138 [inline]
     [<00000000b95ec5c9>] __x64_sys_io_uring_setup+0x1a/0x20  
fs/io_uring.c:3138
     [<0000000072749d9e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<0000000053106e40>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811fb61e80 (size 64):
   comm "syz-executor073", pid 7035, jiffies 4294943279 (age 8.130s)
   hex dump (first 32 bytes):
     00 00 00 00 81 88 ff ff 88 1e b6 1f 81 88 ff ff  ................
     88 1e b6 1f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000008c8eddf3>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000008c8eddf3>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000008c8eddf3>] slab_alloc mm/slab.c:3326 [inline]
     [<000000008c8eddf3>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000005afcf70e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000005afcf70e>] sock_alloc_inode+0x44/0xe0 net/socket.c:255
     [<00000000226aca0e>] alloc_inode+0x2c/0xe0 fs/inode.c:226
     [<0000000054963a4b>] new_inode_pseudo+0x18/0x70 fs/inode.c:915
     [<00000000a577ddf0>] sock_alloc+0x1c/0x90 net/socket.c:575
     [<000000000e50448f>] __sock_create+0x8f/0x250 net/socket.c:1394
     [<00000000248d5219>] sock_create_kern+0x3b/0x50 net/socket.c:1499
     [<0000000081cd440d>] io_uring_get_fd fs/io_uring.c:2997 [inline]
     [<0000000081cd440d>] io_uring_create fs/io_uring.c:3080 [inline]
     [<0000000081cd440d>] io_uring_setup+0x4ea/0x990 fs/io_uring.c:3128
     [<00000000b95ec5c9>] __do_sys_io_uring_setup fs/io_uring.c:3141 [inline]
     [<00000000b95ec5c9>] __se_sys_io_uring_setup fs/io_uring.c:3138 [inline]
     [<00000000b95ec5c9>] __x64_sys_io_uring_setup+0x1a/0x20  
fs/io_uring.c:3138
     [<0000000072749d9e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<0000000053106e40>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811dd21c08 (size 56):
   comm "syz-executor073", pid 7035, jiffies 4294943279 (age 8.130s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     30 fd bd 21 81 88 ff ff 20 1c d2 1d 81 88 ff ff  0..!.... .......
   backtrace:
     [<0000000088b15f0d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000088b15f0d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000088b15f0d>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000088b15f0d>] kmem_cache_alloc+0x134/0x270 mm/slab.c:3488
     [<00000000dec41212>] kmem_cache_zalloc include/linux/slab.h:732 [inline]
     [<00000000dec41212>] lsm_inode_alloc security/security.c:523 [inline]
     [<00000000dec41212>] security_inode_alloc+0x33/0xb0  
security/security.c:876
     [<0000000093ac97c3>] inode_init_always+0x108/0x200 fs/inode.c:168
     [<000000006cedb4e8>] alloc_inode+0x49/0xe0 fs/inode.c:233
     [<0000000054963a4b>] new_inode_pseudo+0x18/0x70 fs/inode.c:915
     [<00000000a577ddf0>] sock_alloc+0x1c/0x90 net/socket.c:575
     [<000000000e50448f>] __sock_create+0x8f/0x250 net/socket.c:1394
     [<00000000248d5219>] sock_create_kern+0x3b/0x50 net/socket.c:1499
     [<0000000081cd440d>] io_uring_get_fd fs/io_uring.c:2997 [inline]
     [<0000000081cd440d>] io_uring_create fs/io_uring.c:3080 [inline]
     [<0000000081cd440d>] io_uring_setup+0x4ea/0x990 fs/io_uring.c:3128
     [<00000000b95ec5c9>] __do_sys_io_uring_setup fs/io_uring.c:3141 [inline]
     [<00000000b95ec5c9>] __se_sys_io_uring_setup fs/io_uring.c:3138 [inline]
     [<00000000b95ec5c9>] __x64_sys_io_uring_setup+0x1a/0x20  
fs/io_uring.c:3138
     [<0000000072749d9e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<0000000053106e40>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
