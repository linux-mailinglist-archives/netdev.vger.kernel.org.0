Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C01169FF7
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBXI2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:28:38 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:43050 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBXI2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:28:15 -0500
Received: by mail-il1-f197.google.com with SMTP id o13so16941032ilf.10
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:28:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jFxjTyVtQ1y1wxhLl6u+yHn3djDe27YTjrCu1DkL3DE=;
        b=UweyS4O1gfbquJ46FY/n3XIV1CVYoqZEIJbaggp5HMsg/HG9XnXmje8VAruMwTYql0
         uahwrKFjmSxcZhOcdp51CTmkWTbB08i08HRz6uPTrl8aow10dIkRyUEsmWi0LhWr+NYl
         r98ANXGyU2i6j76ia97HFgMGas6RvOoovjhBL+xpWMEIXOn8P64gUnQbvamnWJISV4sx
         PopG+ErR47XL+KT01yvwc0bwefkKc+c4aMYVbEHhvSgmpwnKbjGzbnv3sjrzRlejYZN9
         HUEKit7nqoObJ2My5n5QCVdfmK7Mnzty/uOg3TcySzYRd3epGMWsEsPVKcchswLtsDFz
         Vhsw==
X-Gm-Message-State: APjAAAWQV855DD7KxJGP2r5NEKVs8pfoOThrxrjIn9Of4FC86czw4Npy
        HTj4pFqj+5BOQX+EjIL/ny9CNjAQcvzWgNUp8RjtB4zlwwAl
X-Google-Smtp-Source: APXvYqzNVdPLqYe8Lhyql7BRC2gHcDr9y0qa5iIMN2bsWQA9IofMC36ALNd3nziXdhY8AI3OCetEfdI8owWhwXct9YVhDdbABcCq
MIME-Version: 1.0
X-Received: by 2002:a6b:39c4:: with SMTP id g187mr49157362ioa.271.1582532893452;
 Mon, 24 Feb 2020 00:28:13 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:28:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5aedd059f4e26a2@google.com>
Subject: BUG: unable to handle kernel paging request in ethnl_update_bitset32
From:   syzbot <syzbot+7fd4ed5b4234ab1fdccd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d2eee258 Merge tag 'for-5.6-rc2-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1740c265e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=7fd4ed5b4234ab1fdccd
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e2fde9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14543a7ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7fd4ed5b4234ab1fdccd@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
BUG: unable to handle page fault for address: ffffed10192af087
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffef067 P4D 21ffef067 PUD 12fff6067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9626 Comm: syz-executor696 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ethnl_bitmap32_not_zero net/ethtool/bitset.c:112 [inline]
RIP: 0010:ethnl_compact_sanity_checks net/ethtool/bitset.c:529 [inline]
RIP: 0010:ethnl_update_bitset32.part.0+0x8be/0x1820 net/ethtool/bitset.c:572
Code: 45 85 e4 0f 84 aa 03 00 00 e8 6e 31 05 fb 48 8b 85 c8 fe ff ff 4e 8d 2c a8 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 0c 84 d2 74 08 4c
RSP: 0018:ffffc9000672f248 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: ffff8880a957843c RCX: ffffffff867055d4
RDX: 1ffff110192af087 RSI: ffffffff867055e2 RDI: 0000000000000005
RBP: ffffc9000672f3b0 R08: ffff888099244600 R09: ffffc9000672f318
R10: fffff52000ce5e68 R11: ffffc9000672f347 R12: 0000000000000010
R13: ffff8880c957843c R14: ffff8880a957844c R15: ffffc9000672f388
FS:  000000000252c940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed10192af087 CR3: 00000000a8aac000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ethnl_update_bitset32 net/ethtool/bitset.c:562 [inline]
 ethnl_update_bitset+0x4d/0x67 net/ethtool/bitset.c:734
 ethnl_update_linkmodes net/ethtool/linkmodes.c:303 [inline]
 ethnl_set_linkmodes+0x461/0xc30 net/ethtool/linkmodes.c:357
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4460a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b d2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff543f17b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004460a9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff543f17f0
R13: 0000000000000003 R14: 0000000000000004 R15: 00007fff543f18c0
Modules linked in:
CR2: ffffed10192af087
---[ end trace 4138f4d807e125a3 ]---
RIP: 0010:ethnl_bitmap32_not_zero net/ethtool/bitset.c:112 [inline]
RIP: 0010:ethnl_compact_sanity_checks net/ethtool/bitset.c:529 [inline]
RIP: 0010:ethnl_update_bitset32.part.0+0x8be/0x1820 net/ethtool/bitset.c:572
Code: 45 85 e4 0f 84 aa 03 00 00 e8 6e 31 05 fb 48 8b 85 c8 fe ff ff 4e 8d 2c a8 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 0c 84 d2 74 08 4c
RSP: 0018:ffffc9000672f248 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: ffff8880a957843c RCX: ffffffff867055d4
RDX: 1ffff110192af087 RSI: ffffffff867055e2 RDI: 0000000000000005
RBP: ffffc9000672f3b0 R08: ffff888099244600 R09: ffffc9000672f318
R10: fffff52000ce5e68 R11: ffffc9000672f347 R12: 0000000000000010
R13: ffff8880c957843c R14: ffff8880a957844c R15: ffffc9000672f388
FS:  000000000252c940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed10192af087 CR3: 00000000a8aac000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
