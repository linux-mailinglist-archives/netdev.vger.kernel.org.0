Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E25189356
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCRA5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:57:17 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:55110 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCRA5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 20:57:17 -0400
Received: by mail-il1-f198.google.com with SMTP id m2so9390209ilb.21
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 17:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AwxUWTQVZ+/aEy1zEIo924Rdw2MHYeelIX0x8Zy9SDM=;
        b=i0nbwjuW/qcYgvbfKf+rUXXRpYFfUUs6eMappZv/VV0mWlCo1fqxjTYJDm2x1pKkT0
         0qec4OxK3reRRCjw0lPFfIkBQQ9AYuZ/NwEWjo8RM8JaN6tzC+ZAh5BtqK2SjUmZTL4f
         kZ7ntYDQYmQ9DMuVXYjYPmAcR7407HHMXFjl8FRW8v/1oWqi/Oqvy2+NUjJ4EY/GqMqW
         ltqapGYZZd+RCJWkBfRPuqE6CT8HQhtIzozAMZHnEdc4K3xxmsmOf63xzv/0NVFfqpjT
         N1LQRVTAa1Ax+QcmTg6j78osU7hkay4YUVUJ9AWnXI5oM2Ny2Z8oASWlSMHUIbkxLQ1s
         5GmQ==
X-Gm-Message-State: ANhLgQ2CsCXymrAR8scb+S08tBVt2E8UwD5WjP5M17Szt92Y2Hv081WS
        PEQEYRSY99DF/SixlkEydyKIPxCFUtHXOdtJJrWYZHMaw6Ma
X-Google-Smtp-Source: ADFU+vsBUcUjMSGR2RIVHBSQ+ZMxjiDPezE+DKLDNiIS3nDs+IwAscd82aFCKYGH8wMQd69WW6aSLHSklvEuJhbmYK7Z5QdKKKiI
MIME-Version: 1.0
X-Received: by 2002:a92:6501:: with SMTP id z1mr1563074ilb.235.1584493035534;
 Tue, 17 Mar 2020 17:57:15 -0700 (PDT)
Date:   Tue, 17 Mar 2020 17:57:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088487805a116880c@google.com>
Subject: KASAN: use-after-free Write in tcindex_change
From:   syzbot <syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fb33c651 Linux 5.6-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=177b20e5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=ba4bcf1563f90386910f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1748dfdde00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16afffdde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ba4bcf1563f90386910f@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: use-after-free in tcindex_set_parms net/sched/cls_tcindex.c:455 [inline]
BUG: KASAN: use-after-free in tcindex_change+0x1c61/0x27b0 net/sched/cls_tcindex.c:518
Write of size 16 at addr ffff8880a4765830 by task syz-executor577/8737

CPU: 1 PID: 8737 Comm: syz-executor577 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x14b/0x1c0 mm/kasan/report.c:506
 kasan_report+0x25/0x50 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:182 [inline]
 check_memory_region+0x2a5/0x2e0 mm/kasan/generic.c:192
 memcpy+0x38/0x50 mm/kasan/common.c:128
 tcindex_set_parms net/sched/cls_tcindex.c:455 [inline]
 tcindex_change+0x1c61/0x27b0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0x1490/0x2f50 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x8fb/0xd40 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f9/0x7c0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440e79
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd720b07b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a2650 RCX: 0000000000440e79
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00007ffd720b07c0 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004a2650
R13: 0000000000402410 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 4680:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:515
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x24b/0x330 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 kzalloc+0x1d/0x40 include/linux/slab.h:669
 lsm_cred_alloc security/security.c:532 [inline]
 security_prepare_creds+0x46/0x220 security/security.c:1586
 prepare_creds+0x3dc/0x590 kernel/cred.c:285
 do_faccessat+0x53/0x780 fs/open.c:360
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 4680:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 security_cred_free+0xbf/0x100 security/security.c:1580
 put_cred_rcu+0xca/0x350 kernel/cred.c:114
 put_cred include/linux/cred.h:287 [inline]
 do_faccessat+0x613/0x780 fs/open.c:439
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a4765800
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 48 bytes inside of
 192-byte region [ffff8880a4765800, ffff8880a47658c0)
The buggy address belongs to the page:
page:ffffea000291d940 refcount:1 mapcount:0 mapping:ffff8880aa400000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002a554c8 ffffea000291b188 ffff8880aa400000
raw: 0000000000000000 ffff8880a4765000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a4765700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880a4765780: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a4765800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff8880a4765880: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880a4765900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
