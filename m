Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1B417E92
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345549AbhIYAS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 20:18:59 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39617 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345448AbhIYAS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 20:18:57 -0400
Received: by mail-io1-f72.google.com with SMTP id x12-20020a056602160c00b005d61208080cso12414515iow.6
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 17:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sIwHI/hBvKJ/+qRKAKzrUtrKtYpA39mBKvzbTlmrjXE=;
        b=jSpPRCwONZqGmczZWifYoLFDJLzJqhwd78eBjjy859qK4Q62U6lLNO1N4I9DgdDE/0
         Cn7ODLCooQ7knmgVlUSQeCebT1x85w6QZhhfkMecdDQsZMxV5kdHBZIm8exkiPiq6CTp
         ql/hJIcdmjntvCcim76e9wxvlLr42o1Hq5rNaosRPrI2t8F79rmCehdCpSATXdui9AFb
         xm7p3EA1M3J+VDMCgc5wLtKOjJB3tvkcqlal46jiLpcxl2e6Lki1QJ+Psx2WhnbrnczC
         +4aG62Atxm7EWhVju3PqrHQJmbHaUL0UrtqwHyfjP0nDrVZeeUImymvw4vEp0B32pBs2
         1Xug==
X-Gm-Message-State: AOAM532v5L/qx0AFeMAZaqzVQHVJ5WQwHay3o6Gr4hbSOQiHLLBKTLN7
        FrPsecyQw5Ou5Ab/Rt2pR/voXNRdL1yfR0GVFsJETiJRArKa
X-Google-Smtp-Source: ABdhPJwWl3cWxw5jalXUXAxhT3agqTQsUtvMypSOrGpSGbJLFq+alfQld/oEfqstBn1i3kUj15Fcz8nn4RGr1388Bsfa0mOrkN5o
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1561:: with SMTP id k1mr10108118ilu.302.1632529043745;
 Fri, 24 Sep 2021 17:17:23 -0700 (PDT)
Date:   Fri, 24 Sep 2021 17:17:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bcf11005ccc6c9dc@google.com>
Subject: [syzbot] WARNING in __dev_set_promiscuity
From:   syzbot <syzbot+7a2ab2cdc14d134de553@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, gnaaman@drivenets.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, luwei32@huawei.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        wangxiongfeng2@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2fcd14d0f780 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15481d23300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
dashboard link: https://syzkaller.appspot.com/bug?extid=7a2ab2cdc14d134de553
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b96d3300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115f26d3300000

The issue was bisected to:

commit 406f42fa0d3cbcea3766c3111d79ac5afe711c5b
Author: Gilad Naaman <gnaaman@drivenets.com>
Date:   Thu Aug 19 07:17:27 2021 +0000

    net-next: When a bond have a massive amount of VLANs with IPv6 addresses, performance of changing link state, attaching a VRF, changing an IPv6 address, etc. go down dramtically.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152dbfd7300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=172dbfd7300000
console output: https://syzkaller.appspot.com/x/log.txt?x=132dbfd7300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7a2ab2cdc14d134de553@syzkaller.appspotmail.com
Fixes: 406f42fa0d3c ("net-next: When a bond have a massive amount of VLANs with IPv6 addresses, performance of changing link state, attaching a VRF, changing an IPv6 address, etc. go down dramtically.")

------------[ cut here ]------------
RTNL: assertion failed at net/core/dev.c (8535)
WARNING: CPU: 1 PID: 6856 at net/core/dev.c:8535 __dev_set_promiscuity+0x1dd/0x210 net/core/dev.c:8535
Modules linked in:
CPU: 1 PID: 6856 Comm: syz-executor296 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__dev_set_promiscuity+0x1dd/0x210 net/core/dev.c:8535
Code: 0f 85 ab fe ff ff e8 d2 53 55 fa ba 57 21 00 00 48 c7 c6 00 bd 8b 8a 48 c7 c7 40 bd 8b 8a c6 05 cb 1f 39 06 01 e8 d0 a9 d1 01 <0f> 0b e9 80 fe ff ff 4c 89 f7 e8 84 af 9c fa e9 99 fe ff ff 4c 89
RSP: 0018:ffffc9000379f258 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880195db900 RSI: ffffffff815dbd68 RDI: fffff520006f3e3d
RBP: ffff88807c4b2000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d5b0e R11: 0000000000000000 R12: 00000000ffffffff
R13: 0000000000001103 R14: ffff88807c4b20c0 R15: 0000000000000000
FS:  0000555555826300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200002c0 CR3: 000000001aa54000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __dev_set_rx_mode+0x256/0x2e0 net/core/dev.c:8678
 dev_uc_sync_multiple+0x155/0x190 net/core/dev_addr_lists.c:732
 team_set_rx_mode+0xb5/0x230 drivers/net/team/team.c:1779
 __dev_set_rx_mode+0x1e2/0x2e0 net/core/dev.c:8684
 __dev_mc_add net/core/dev_addr_lists.c:830 [inline]
 dev_mc_add+0xf4/0x110 net/core/dev_addr_lists.c:844
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:265 [inline]
 clusterip_tg_check+0x1263/0x2300 net/ipv4/netfilter/ipt_CLUSTERIP.c:517
 xt_check_target+0x26c/0x9e0 net/netfilter/x_tables.c:1038
 check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
 find_check_entry.constprop.0+0x7a9/0x9a0 net/ipv4/netfilter/ip_tables.c:553
 translate_table+0xc26/0x16a0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1135 [inline]
 do_ipt_set_ctl+0x56e/0xb80 net/ipv4/netfilter/ip_tables.c:1629
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0x3c3/0x3a60 net/ipv4/ip_sockglue.c:1435
 tcp_setsockopt+0x136/0x2530 net/ipv4/tcp.c:3632
 __sys_setsockopt+0x2db/0x610 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f35c2b6e549
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffb6707c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f35c2b6e549
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000298 R09: 0000000000f0b5ff
R10: 00000000200002c0 R11: 0000000000000246 R12: 0000000000010e0d
R13: 00007fffb6707c70 R14: 00007fffb6707c60 R15: 00007fffb6707c54


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
