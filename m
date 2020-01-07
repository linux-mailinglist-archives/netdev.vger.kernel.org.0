Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65550132CF7
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgAGR2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:28:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:40040 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgAGR2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:28:10 -0500
Received: by mail-il1-f200.google.com with SMTP id e4so120346ilm.7
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 09:28:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zcJOkvouZPbSRqYxxbEiilRTbfXGpDRuJVTCWHOU3cc=;
        b=KP+iou3DUDlnQAsaCbbrJJhI0syDLMnRuec5mne/XaEkGH5UaDF0jV49olakdJX4cN
         BU1TiVoonRTgqL9iVhZwJWa+vXCY0lW4C65rdCja8RLWB270zAgN81/FmKaMRUe6cRjh
         Bm4z+/h8n8PMLGuDYXkMn+vb8AEGJUmXxcd91DXqT3P+yBrBpLfqqpPrVoUnmiz783UJ
         mJbHjqxRQCeGYgewqj51MEHlGPA/M9ZsPhhN2fOTCVtVbpMyyKD0BapCZcnrKkCQyBWP
         wA4be+GGc2v64RqHboxhj3G2IsSbc329TRrKvSJDMt9MWtDBwbu3HadQWy6/7+4uKeF3
         ZcSw==
X-Gm-Message-State: APjAAAVyFhD5/estdTH+EDwbiUtaEFjLo732Flzq3WawudLsNoA/tzyV
        RVxtKq2sa4B7kG3WcoBjP87gjW+pWZ5DtyI/ftObovTJdloh
X-Google-Smtp-Source: APXvYqw6q1hvmsYoBbeSDp7ozskflEF0SobE3NYgog1aSsfBxaHfqvjZC5bqnj3Ka3vZAJBdMI18ryTdQVohc3b78aH9yEBHzYoI
MIME-Version: 1.0
X-Received: by 2002:a02:ca10:: with SMTP id i16mr613269jak.10.1578418089724;
 Tue, 07 Jan 2020 09:28:09 -0800 (PST)
Date:   Tue, 07 Jan 2020 09:28:09 -0800
In-Reply-To: <000000000000a347ef059b8ee979@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008b914b059b9019d2@google.com>
Subject: Re: general protection fault in hash_ipportnet4_uadt
From:   syzbot <syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13f4f3c1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=34bd2369d38707f3f4a7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b35ec6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13044076e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9656 Comm: syz-executor756 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_ipportnet4_uadt+0x20b/0x13e0  
net/netfilter/ipset/ip_set_hash_ipportnet.c:173
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 71 0c 00 00 4c 89  
e2 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2c
RSP: 0018:ffffc90001ee7150 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90001ee7320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867e4e78 RDI: ffff8880a7f08070
RBP: ffffc90001ee72b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 0000000000000000
R13: 0000000002000000 R14: ffffc90001ee7220 R15: ffff8880a4c3a400
FS:  0000000000e4b880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000446 CR3: 000000009e154000 CR4: 00000000001406e0
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
RIP: 0033:0x440839
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffde8ed0ad8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440839
RDX: 0000000000000002 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
R10: 000000000000204e R11: 0000000000000246 R12: 00000000004020c0
R13: 0000000000402150 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 4497e0a4dc04971d ]---
RIP: 0010:hash_ipportnet4_uadt+0x20b/0x13e0  
net/netfilter/ipset/ip_set_hash_ipportnet.c:173
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 71 0c 00 00 4c 89  
e2 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2c
RSP: 0018:ffffc90001ee7150 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90001ee7320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867e4e78 RDI: ffff8880a7f08070
RBP: ffffc90001ee72b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 0000000000000000
R13: 0000000002000000 R14: ffffc90001ee7220 R15: ffff8880a4c3a400
FS:  0000000000e4b880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000446 CR3: 000000009e154000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

