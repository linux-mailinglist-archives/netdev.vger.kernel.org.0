Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3F9132AB9
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgAGQEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:04:15 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:55661 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbgAGQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:04:09 -0500
Received: by mail-il1-f198.google.com with SMTP id p8so23750836ilp.22
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 08:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rdGPfCkKkhNUunHh3gmPvvJbquc5bXUoSXXo3J+pcgE=;
        b=j+NFBSsi35Me0aVTjR+zKv+5g3qUcncu8BtmchmY6ft+7prbmM5V8a5HdWi2DagTvs
         sDz/Gbn+AKa2Jh6SyzBIyi8eK/kDUbv+j878q0xF5DGTmzoRBs5BpmBMF7W9XadSD205
         GIZrKbTqJzqjzcgil5dTQIiyuApqxT2ix/agaqX9Q8Jjc6690PbzKq9bk2RHqDoDsHtB
         4gde8r1CEFgS90uRyPKwgiRFd50vF694sBIhUFwwd8BAD7NXyaH6oBLjpjhRCvp7MWbj
         bsi3oqkL/D18/RxrBNsIOgBfypqa63ghHaNRk7DUaVcMU8ZoVJ1HxtnJ/5BPgeWuMPoT
         K/tw==
X-Gm-Message-State: APjAAAUuQN4391abw5WjWM5uhpKWtx09liXuTXDDbROA1XRBd55hb/8g
        7+180hDqNQHdNp7hbSxD0dYpcYBMrsZ3yQYSvfUhhkdRyweR
X-Google-Smtp-Source: APXvYqzryiqJcGjAxETkLKXnGsXfp/ftpHdq9yn80JNmZNpHmYvyMY+K6iChE5pZ0MoO0XqPK5L3Da+nDl4P9eAdjzyKQBjTVk1c
MIME-Version: 1.0
X-Received: by 2002:a6b:be84:: with SMTP id o126mr74090824iof.269.1578413048756;
 Tue, 07 Jan 2020 08:04:08 -0800 (PST)
Date:   Tue, 07 Jan 2020 08:04:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001483d7059b8eed67@google.com>
Subject: general protection fault in hash_mac4_uadt
From:   syzbot <syzbot+cabfabc5c6bf63369d04@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=130000d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=cabfabc5c6bf63369d04
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14896eb9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139ed115e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cabfabc5c6bf63369d04@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9502 Comm: syz-executor627 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_mac4_uadt+0x1bc/0x470  
net/netfilter/ipset/ip_set_hash_mac.c:104
Code: 11 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85 5c 02 00 00 4c  
89 f2 8b 48 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 1a
RSP: 0018:ffffc90001fbf1b0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90001fbf320 RCX: 0000000008000000
RDX: 0000000000000000 RSI: ffffffff867f8cc5 RDI: ffff8880978db904
RBP: ffffc90001fbf2b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a4894d00
R13: 1ffff920003f7e3a R14: 0000000000000000 R15: ffffc90001fbf200
FS:  0000000002661880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000f98 CR3: 000000009074a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg net/socket.c:2424 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440b89
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd28ae8658 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440b89
RDX: 0000000000000800 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 00000000006cb018 R08: 0000000000000009 R09: 00000000004002c8
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000402410
R13: 00000000004024a0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 0178b58b9257a57d ]---
RIP: 0010:hash_mac4_uadt+0x1bc/0x470  
net/netfilter/ipset/ip_set_hash_mac.c:104
Code: 11 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85 5c 02 00 00 4c  
89 f2 8b 48 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 1a
RSP: 0018:ffffc90001fbf1b0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90001fbf320 RCX: 0000000008000000
RDX: 0000000000000000 RSI: ffffffff867f8cc5 RDI: ffff8880978db904
RBP: ffffc90001fbf2b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a4894d00
R13: 1ffff920003f7e3a R14: 0000000000000000 R15: ffffc90001fbf200
FS:  0000000002661880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000f98 CR3: 000000009074a000 CR4: 00000000001406e0
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
