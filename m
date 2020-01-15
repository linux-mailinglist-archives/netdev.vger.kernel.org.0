Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FBC13CE48
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgAOUvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:51:14 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:46664 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgAOUvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:51:13 -0500
Received: by mail-io1-f70.google.com with SMTP id p206so11250241iod.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OqGpk3d1n93MNn3ynIn9sN0lhPXpjDGu0bKu+4j0ONc=;
        b=VnoJlhDhWPwKM/BuLNUlV+d1uD5gwuOz0EkgXVIsHxKtoog8iZx87MOC/8f0V1d7Op
         3ICilkemjaESH3/b2+jI70hHsXebZ79Ukz63m88apFOOMcYYOp53eY0zGniUvpsIDei3
         U3AlUaA4J2usqa58G8CoXDvLhulc7+ToPrau3MsEluiDFoyXV1bW35Zw9vC5lbENhVKU
         pT1YXMTpynzN63TEOaEJEmNInfyA59Vt74ZJ5YO2fGWrcADcXHshcfwYydz96YctxOx7
         +xb7aOKHdyZROxkdNbDB5dSX1QKOG7fZvlYqE8aIGQ5ItbnLu7A5oEekVRMdsFW/j7iO
         sGwQ==
X-Gm-Message-State: APjAAAXiJNgXUJ8gcAUrz9qTkNVV3Lbb3ZjIIFYqM30bRJoYZeQVQbT1
        C1ZqgnwABux18FXwr+yE9/iG4J7jWz7kQXb7RMlMx8L6RGdx
X-Google-Smtp-Source: APXvYqwnEF2vzML966Ty5Kam9J16KCLEYWZ7qUfNwB+zgu0s43zrVsFpkGVzIkDvJrlbl3v/sfs7e0WUU8z3WiAtQemQ9cPptrCj
MIME-Version: 1.0
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr11791574ior.129.1579121473020;
 Wed, 15 Jan 2020 12:51:13 -0800 (PST)
Date:   Wed, 15 Jan 2020 12:51:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074ed27059c33dedc@google.com>
Subject: general protection fault in nft_chain_parse_hook
From:   syzbot <syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4e2fa6b9 Merge branch 'bridge-add-vlan-notifications-and-r..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=142f4a21e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=156a04714799b1d480bc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 20602 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:nft_chain_parse_hook+0x386/0xa10  
net/netfilter/nf_tables_api.c:1767
Code: e8 7f ae 09 fb 41 83 fd 05 0f 87 62 05 00 00 e8 f0 ac 09 fb 49 8d 7c  
24 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e a6 05 00 00 44 89 e9 be 01 00
RSP: 0018:ffffc90001627100 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffc900016272b0 RCX: ffffc90004e59000
RDX: 0000000000000003 RSI: ffffffff866b5350 RDI: 0000000000000018
RBP: ffffc900016271f0 R08: ffff8880648b4240 R09: 0000000000000000
R10: fffff520002c4e2f R11: ffffc9000162717f R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc900016271c8
FS:  00007f0770558700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcdd829cdb8 CR3: 00000000a483c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  nf_tables_addchain.constprop.0+0x1c1/0x1520  
net/netfilter/nf_tables_api.c:1888
  nf_tables_newchain+0x1033/0x1820 net/netfilter/nf_tables_api.c:2196
  nfnetlink_rcv_batch+0xf42/0x17a0 net/netfilter/nfnetlink.c:433
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
  nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
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
RIP: 0033:0x45aff9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0770557c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f07705586d4 RCX: 000000000045aff9
RDX: 00000000040c4080 RSI: 000000002000c2c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000901 R14: 00000000004ca2fe R15: 000000000075bf2c
Modules linked in:
---[ end trace c2d6a3781de0914d ]---
RIP: 0010:nft_chain_parse_hook+0x386/0xa10  
net/netfilter/nf_tables_api.c:1767
Code: e8 7f ae 09 fb 41 83 fd 05 0f 87 62 05 00 00 e8 f0 ac 09 fb 49 8d 7c  
24 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e a6 05 00 00 44 89 e9 be 01 00
RSP: 0018:ffffc90001627100 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffc900016272b0 RCX: ffffc90004e59000
RDX: 0000000000000003 RSI: ffffffff866b5350 RDI: 0000000000000018
RBP: ffffc900016271f0 R08: ffff8880648b4240 R09: 0000000000000000
R10: fffff520002c4e2f R11: ffffc9000162717f R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc900016271c8
FS:  00007f0770558700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd461cd0000 CR3: 00000000a483c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
