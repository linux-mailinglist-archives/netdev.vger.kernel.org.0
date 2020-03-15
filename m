Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B451118609F
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 00:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgCOXvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 19:51:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33175 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbgCOXvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 19:51:17 -0400
Received: by mail-io1-f71.google.com with SMTP id b4so10666312iok.0
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 16:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XFune3Nh7INWLVShwbwpLH/8tU9WYmcocUnNPcwte9c=;
        b=N1P3jFCUbMjDpqcXyISLqV5xVfCQqJtRkFz1aN9h+nqeI/P0z2kJXpXeVLuq/uvhnw
         rJGUFGCzH+MbZISnzchCnBzIi7iv9UQf6dhYZAHd7F6RyCxWD18tVY+kJsPR4VYDtSKp
         WOdMwVYUXBMMwSPpVjmK7lZpWSXODsN25NCEXFNVb6UoYsGOGwFUK6sfNttFmwlmajAK
         gjiaTHa91vVOHIqykLHBuwfBiQm5SQp8qb2yn4VhloxpT/u6tKocrir2neUVjw+cweDX
         snu4hG3ClSitUKkOVs4k6RzorrmjKli5XbktmeASmyYtTvtH5PO4iqqGEVpbx7AL3KTD
         7mMg==
X-Gm-Message-State: ANhLgQ2H+G6xZ0efTuOMmoXNmyfkp4/Fy7/bCyRTzxrlN8juuEOuKNgN
        BNwbUR/knkcgghqxywfpoxmntjswlWeTh06uygeZIKqhF3pn
X-Google-Smtp-Source: ADFU+vvj1uMVlMX8J08YQZzfP6DiYsntASdjPiD+68J2r/EfLAEkCc0q/yICtOgqS/EPyozL5s42hyIBdR216JZD7NxY7Qjt1r7Y
MIME-Version: 1.0
X-Received: by 2002:a92:9f1b:: with SMTP id u27mr25436039ili.173.1584316274477;
 Sun, 15 Mar 2020 16:51:14 -0700 (PDT)
Date:   Sun, 15 Mar 2020 16:51:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c08f2005a0ed60d4@google.com>
Subject: general protection fault in erspan_netlink_parms
From:   syzbot <syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0fda7600 geneve: move debug check after netdev unregister
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=134e9555e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=1b4ebf4dae4e510dd219
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1627f955e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111ac52de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com

netlink: 4 bytes leftover after parsing attributes in process `syz-executor042'.
general protection fault, probably for non-canonical address 0xdffffc0000000016: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000b0-0x00000000000000b7]
CPU: 0 PID: 9887 Comm: syz-executor042 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:erspan_netlink_parms.isra.0+0x5c/0x420 net/ipv4/ip_gre.c:1172
Code: 6a 03 d6 fa 45 85 e4 0f 85 f0 00 00 00 e8 ec 01 d6 fa 48 8d bb b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 37 03 00 00 4c 8b ab b0 00 00 00 4d 85 ed 0f 84
RSP: 0018:ffffc90001f17080 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff869c13c6
RDX: 0000000000000016 RSI: ffffffff869c13d4 RDI: 00000000000000b0
RBP: ffff888090c0a000 R08: ffff88809a4f6240 R09: ffffc90001f170f0
R10: fffff520003e2e24 R11: 0000000000000003 R12: 0000000000000000
R13: ffffc90001f170e0 R14: 0000000000000000 R15: ffffc90001f17428
FS:  0000000001941880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000284 CR3: 000000009e80a000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 erspan_newlink+0x106/0x140 net/ipv4/ip_gre.c:1341
 __rtnl_newlink+0xf18/0x1590 net/core/rtnetlink.c:3319
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5436
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffc0fc1f58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402e9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000006e61 R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401b70
R13: 0000000000401c00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 895543aaa6ca5250 ]---
RIP: 0010:erspan_netlink_parms.isra.0+0x5c/0x420 net/ipv4/ip_gre.c:1172
Code: 6a 03 d6 fa 45 85 e4 0f 85 f0 00 00 00 e8 ec 01 d6 fa 48 8d bb b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 37 03 00 00 4c 8b ab b0 00 00 00 4d 85 ed 0f 84
RSP: 0018:ffffc90001f17080 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff869c13c6
RDX: 0000000000000016 RSI: ffffffff869c13d4 RDI: 00000000000000b0
RBP: ffff888090c0a000 R08: ffff88809a4f6240 R09: ffffc90001f170f0
R10: fffff520003e2e24 R11: 0000000000000003 R12: 0000000000000000
R13: ffffc90001f170e0 R14: 0000000000000000 R15: ffffc90001f17428
FS:  0000000001941880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000284 CR3: 000000009e80a000 CR4: 00000000001406f0
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
