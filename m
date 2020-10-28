Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C944F29DA86
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbgJ1XKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:10:43 -0400
Received: from mail-pg1-f198.google.com ([209.85.215.198]:36263 "EHLO
        mail-pg1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731130AbgJ1XJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:09:03 -0400
Received: by mail-pg1-f198.google.com with SMTP id c16so631900pgn.3
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MqjoSdva1wfK+hQdS37oMwtOGGifvUM6vcpSTQxQdrQ=;
        b=HQ9Bue713yqLef1A00u8OHbGJ1GyaosCiUoQxSF+9sWutI7MOjy9gVVEzWBr4T0Nd4
         R0WMyMWk27s1KXIAaXdlybYkJDykSGkWBGSAMFFz0Nntn1uGE2dH7fvubPGfPXeBWpaf
         uEAdzUED6XqiTmGrckl5ktMhE/bSFfU+qC7Dpez4QwhsGMo3adS/Nqt6z3erh/OcTjAm
         fHEx5qSz0yyYuWcM+Xxt2k8+ZoPmluWJAXb9KXPkqMgcSqdanxscg+u5VlFtWaKgeuTw
         lAMEEyOthgBbFmNll9WNtDtPQJ5N8O6M2AbDmS58CHDIStJt/sMTL+z8G+DEjaKnVGPo
         B2OA==
X-Gm-Message-State: AOAM532y7TiavMQW+6/PkYGiLAq7Wf2ALirBzhMvVe43CstJqzrtl/h8
        hLfHgpNX0MQYz+/xV48kknYyLngrHMGnesYpZ7mPSjxj9bbs
X-Google-Smtp-Source: ABdhPJx2SIcqpONqSHWatP8dAS6iVcIj+SrI5NXPfmppkaaJMp/6HoiWQcW951WoP33zEbBBiRzemuMy6VQGpaQx5te6qm3H04OY
MIME-Version: 1.0
X-Received: by 2002:a92:d709:: with SMTP id m9mr6503546iln.226.1603899197532;
 Wed, 28 Oct 2020 08:33:17 -0700 (PDT)
Date:   Wed, 28 Oct 2020 08:33:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ecb1de05b2bce118@google.com>
Subject: WARNING in ovs_dp_cmd_new
From:   syzbot <syzbot+d35e01f2daf3cee35470@syzkaller.appspotmail.com>
To:     amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, rui.zhang@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3cb12d27 Merge tag 'net-5.10-rc1' of git://git.kernel.org/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=155125b0500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46c6fea3eb827ae1
dashboard link: https://syzkaller.appspot.com/bug?extid=d35e01f2daf3cee35470
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144916df900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14eee964500000

The issue was bisected to:

commit 1ce50e7d408ef2bdc8ca021363fd46d1b8bfad00
Author: Daniel Lezcano <daniel.lezcano@linaro.org>
Date:   Mon Jul 6 10:55:37 2020 +0000

    thermal: core: genetlink support for events/cmd/sampling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14d64554500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16d64554500000
console output: https://syzkaller.appspot.com/x/log.txt?x=12d64554500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d35e01f2daf3cee35470@syzkaller.appspotmail.com
Fixes: 1ce50e7d408e ("thermal: core: genetlink support for events/cmd/sampling")

netlink: 44 bytes leftover after parsing attributes in process `syz-executor235'.
------------[ cut here ]------------
Dropping previously announced user features
WARNING: CPU: 1 PID: 8534 at net/openvswitch/datapath.c:1587 ovs_dp_reset_user_features net/openvswitch/datapath.c:1587 [inline]
WARNING: CPU: 1 PID: 8534 at net/openvswitch/datapath.c:1587 ovs_dp_cmd_new+0xca7/0xec0 net/openvswitch/datapath.c:1725
Modules linked in:
CPU: 1 PID: 8534 Comm: syz-executor235 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ovs_dp_reset_user_features net/openvswitch/datapath.c:1587 [inline]
RIP: 0010:ovs_dp_cmd_new+0xca7/0xec0 net/openvswitch/datapath.c:1725
Code: 2a 0f b6 04 02 84 c0 74 04 3c 03 7e 21 c7 43 68 00 00 00 00 e9 17 fe ff ff e8 05 86 d6 f8 48 c7 c7 a0 fa 6a 8a e8 89 f2 11 00 <0f> 0b eb be 4c 89 e7 e8 4d fb 17 f9 eb d5 e8 e6 fa 17 f9 e9 3f ff
RSP: 0018:ffffc9000162f510 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888025989300 RCX: 0000000000000000
RDX: ffff88801fcb1a40 RSI: ffffffff8158ce35 RDI: fffff520002c5e94
RBP: ffff88801cd87100 R08: 0000000000000001 R09: ffff8880b9f2005b
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888025989368
R13: 0000000000000006 R14: ffff8880188d9ff8 R15: ffff888027e1b3c0
FS:  0000000001138880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055600d8b5628 CR3: 0000000020260000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4419b9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe494aefa8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004419b9
RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000003
RBP: 0000000000015d76 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000402760
R13: 00000000004027f0 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
