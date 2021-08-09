Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06E23E412B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 09:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhHIHyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 03:54:45 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54985 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhHIHyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 03:54:43 -0400
Received: by mail-io1-f71.google.com with SMTP id 81-20020a6b02540000b02905824a68848bso11384753ioc.21
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 00:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8QI5/Ow9wqoi4wS1cgAAg/FGKAVs9yNR1XeA3INMSiI=;
        b=Ea1m+IyVv2295oVEqJd5xCOggCeDVI6TyXUJ/A/fu+ceFu2cXdsnJ2rltSZYJwHULf
         7SSjfSZjUQMMtggosme/LrFVFaB3cFBsM+uGNmQ2RMtbnWIYSDmKqa8wiCH+XzkvparN
         V6n2feL4K+t2WbtV4escFm+bbyolK21BECkObqDfnWs+7X8QKb1it7BuyzWbewFIEXjY
         tfUYxBx3TXoYseDy7rpzNxWV1xltAwkcj2F4g8zhr9gH+hd5ItcostVEY9iqVaHNuEoA
         /ITQDEam23M3sPaLrZWxXnDUZLvT/aZoGCw3dh01E11vcBoXaajythfjXidzW0dJfh3D
         WnBg==
X-Gm-Message-State: AOAM533aV/0cn0ZlUSavEm+Prur44oJ1VeDNXgURSMz5xdUC7CRUwF5Y
        xfGI9dbx0Jn1G/CKq2+NcIf+/zfVFaSiSgasinFdPABFY6bu
X-Google-Smtp-Source: ABdhPJzDTxXN99MnJc7AwyZ3LSbWPzB44Tpctll5ZoYah9KsWRfMfr1x8ws3pfWMST+ETOzo7j30x+Y7r2qnja6UlBgBeNp8RmeT
MIME-Version: 1.0
X-Received: by 2002:a92:da4a:: with SMTP id p10mr138371ilq.290.1628495662787;
 Mon, 09 Aug 2021 00:54:22 -0700 (PDT)
Date:   Mon, 09 Aug 2021 00:54:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007faf7505c91bb19d@google.com>
Subject: [syzbot] general protection fault in hwsim_new_edge_nl
From:   syzbot <syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1226099a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
dashboard link: https://syzkaller.appspot.com/bug?extid=fafb46da3f65fdbacd16
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 1403 Comm: syz-executor.2 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:hwsim_new_edge_nl+0xf4/0x8c0 drivers/net/ieee802154/mac802154_hwsim.c:425
Code: 00 0f 85 76 07 00 00 4d 85 ed 48 8b 5b 10 0f 84 5e 05 00 00 e8 0d f2 40 fc 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 87
RSP: 0018:ffffc90009a47568 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000dd59000
RDX: 0000000000000000 RSI: ffffffff8534ab43 RDI: ffff88801c2b44d0
RBP: ffffc90009a47678 R08: 0000000000000001 R09: ffffc90009a476a8
R10: fffff52001348ed6 R11: 0000000000000000 R12: ffffc90009a47698
R13: ffff888025945c14 R14: ffff888071f0cdc0 R15: 0000000000000000
FS:  00007f8448923700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000032f4708 CR3: 0000000033eed000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8448923188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 0000000020001ac0 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffd8ac8e60f R14: 00007f8448923300 R15: 0000000000022000
Modules linked in:
---[ end trace d1679fe789931133 ]---
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:hwsim_new_edge_nl+0xf4/0x8c0 drivers/net/ieee802154/mac802154_hwsim.c:425
Code: 00 0f 85 76 07 00 00 4d 85 ed 48 8b 5b 10 0f 84 5e 05 00 00 e8 0d f2 40 fc 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 87
RSP: 0018:ffffc90009a47568 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000dd59000
RDX: 0000000000000000 RSI: ffffffff8534ab43 RDI: ffff88801c2b44d0
RBP: ffffc90009a47678 R08: 0000000000000001 R09: ffffc90009a476a8
R10: fffff52001348ed6 R11: 0000000000000000 R12: ffffc90009a47698
R13: ffff888025945c14 R14: ffff888071f0cdc0 R15: 0000000000000000
FS:  00007f8448923700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bb2ea2f160 CR3: 0000000033eed000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
