Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCE3279C6C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgIZUsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:48:17 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:54286 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIZUsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 16:48:16 -0400
Received: by mail-il1-f206.google.com with SMTP id f4so5209054ilk.21
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 13:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LM/7fcHB+LSBwRcKiIRcDVmi/2c7SXH6clQmuTap8yI=;
        b=oIbDTXj3jtRQzijgbgXWI6UWQ+nq1AVUWJcDA5FYRAToqHXrSjy0EsvZzLEpSvq2t/
         d8N9FaHYvTz/peYeW4gQGAkQ7eezvsbNjRMA00fyxfAZXC7Yvlw2gzM3EIUIzm7s1gqX
         h11AN3XzFeP74wUwqrFu5DbejvtokcJu6QH2lFxVazy/QVRh4CTsphGgJ5U2XxkRmh6I
         M/S2EkWfH6gBENSGot98mFlEkG3u4YZrr1jbmYpQiSeWzZJzXdoz0XdQeevS8O06HMW7
         gUczGTUb+8B4Je1Rso8VdHAdnjzdjuzGA+/uJhygEsPahMA6Pqp24YfqA7tuweIr31ow
         fnWw==
X-Gm-Message-State: AOAM533iAaiXYX5zJWzyc81yZFbZ+A3LftwwfYK/N9t6fskBjLEYTWL9
        scasehG6AVY5cQkk4otJhlzcAAgwogxrFZ/lX+RD7eWRAgdX
X-Google-Smtp-Source: ABdhPJyhVCo0cwhMlBliXmWsy52Cr2sz6xqQfoDOyoHXRAcwSr9wd8hb1kMJx8u0L1o3vic4kFpY/qKEYODal/Xpc0Efz7hJEMAA
MIME-Version: 1.0
X-Received: by 2002:a92:c301:: with SMTP id n1mr4410021ilg.247.1601153295431;
 Sat, 26 Sep 2020 13:48:15 -0700 (PDT)
Date:   Sat, 26 Sep 2020 13:48:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000067becf05b03d8dd6@google.com>
Subject: BUG: unable to handle kernel paging request in dqput
From:   syzbot <syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com>
To:     adi@adirat.com, alsa-devel@alsa-project.org,
        coreteam@netfilter.org, davem@davemloft.net, jack@suse.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        perex@perex.cz, syzkaller-bugs@googlegroups.com, tiwai@suse.com,
        tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    98477740 Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17930875900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af502ec9a451c9fc
dashboard link: https://syzkaller.appspot.com/bug?extid=f816042a7ae2225f25ba
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133783ab900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bb5973900000

The issue was bisected to:

commit 1d0f953086f090a022f2c0e1448300c15372db46
Author: Ioan-Adrian Ratiu <adi@adirat.com>
Date:   Wed Jan 4 22:37:46 2017 +0000

    ALSA: usb-audio: Fix irq/process data synchronization

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=133362c3900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10b362c3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=173362c3900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com
Fixes: 1d0f953086f0 ("ALSA: usb-audio: Fix irq/process data synchronization")

EXT4-fs (loop0): mounted filesystem without journal. Opts: ,errors=continue
Quota error (device loop0): qtree_write_dquot: Error -1622674347 occurred while creating quota
Quota error (device loop0): dq_insert_tree: Quota tree root isn't allocated!
Quota error (device loop0): qtree_write_dquot: Error -5 occurred while creating quota
BUG: unable to handle page fault for address: fffffbfff3e8feac
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffe5067 P4D 21ffe5067 PUD 21ffe4067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 6845 Comm: syz-executor636 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:91 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:108 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:134 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:165 [inline]
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:183 [inline]
RIP: 0010:check_memory_region+0x80/0x2f0 mm/kasan/generic.c:192
Code: 01 00 00 00 00 fc ff df 4d 01 ea 4d 89 d6 4d 29 ce 49 83 fe 10 7f 2d 4d 85 f6 0f 84 ab 01 00 00 4c 89 cb 4c 29 d3 0f 1f 40 00 <45> 0f b6 19 45 84 db 0f 85 f3 01 00 00 49 ff c1 48 ff c3 75 eb e9
RSP: 0018:ffffc90001fdf9d0 EFLAGS: 00010293
RAX: 2234ff0efb3ccc01 RBX: fffffffffffffffe RCX: ffffffff81e00c97
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffff9f47f565
RBP: ffffffff9f47f455 R08: dffffc0000000000 R09: fffffbfff3e8feac
R10: fffffbfff3e8feae R11: 0000000000000000 R12: 1ffffffff3e8feac
R13: dffffc0000000001 R14: 0000000000000002 R15: ffffffff9f47f565
FS:  00000000009ac880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3e8feac CR3: 000000009f30a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 dqput+0x77/0x770 fs/quota/dquot.c:770
 dqput_all fs/quota/dquot.c:397 [inline]
 __dquot_initialize+0x9e6/0xc30 fs/quota/dquot.c:1530
 ext4_xattr_set+0x9b/0x300 fs/ext4/xattr.c:2474
 __vfs_setxattr+0x3be/0x400 fs/xattr.c:177
 __vfs_setxattr_noperm+0x11e/0x4b0 fs/xattr.c:208
 vfs_setxattr+0xde/0x270 fs/xattr.c:283
 setxattr+0x167/0x350 fs/xattr.c:548
 path_setxattr+0x109/0x1c0 fs/xattr.c:567
 __do_sys_setxattr fs/xattr.c:582 [inline]
 __se_sys_setxattr fs/xattr.c:578 [inline]
 __x64_sys_setxattr+0xb7/0xd0 fs/xattr.c:578
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4447e9
Code: 8d d7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b d7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcd4905408 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00000000004447e9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000200000c0
RBP: 00000000006cf018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004023d0
R13: 0000000000402460 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: fffffbfff3e8feac
---[ end trace a52409661d306995 ]---
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:91 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:108 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:134 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:165 [inline]
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:183 [inline]
RIP: 0010:check_memory_region+0x80/0x2f0 mm/kasan/generic.c:192
Code: 01 00 00 00 00 fc ff df 4d 01 ea 4d 89 d6 4d 29 ce 49 83 fe 10 7f 2d 4d 85 f6 0f 84 ab 01 00 00 4c 89 cb 4c 29 d3 0f 1f 40 00 <45> 0f b6 19 45 84 db 0f 85 f3 01 00 00 49 ff c1 48 ff c3 75 eb e9
RSP: 0018:ffffc90001fdf9d0 EFLAGS: 00010293
RAX: 2234ff0efb3ccc01 RBX: fffffffffffffffe RCX: ffffffff81e00c97
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffff9f47f565
RBP: ffffffff9f47f455 R08: dffffc0000000000 R09: fffffbfff3e8feac
R10: fffffbfff3e8feae R11: 0000000000000000 R12: 1ffffffff3e8feac
R13: dffffc0000000001 R14: 0000000000000002 R15: ffffffff9f47f565
FS:  00000000009ac880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3e8feac CR3: 000000009f30a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
