Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EBAA101A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 05:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfH2D6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 23:58:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53122 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfH2D6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 23:58:07 -0400
Received: by mail-io1-f71.google.com with SMTP id q5so2328111iof.19
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 20:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tadFVeIOZOH0yr8dBxtTfxDdH48rZZJcwvhVqN0Ob+0=;
        b=aAu4IBYAULZnAOr3U2gEHXzz22QxiA/GHVG43eJr+QYftBdD3qe3g+oGXIpsGeDXnt
         FvX3rc1XHYtVVbS7y4fjMw0MfsdV8ranainubJPwAi5BUWLWUGmbtgWN4MEYg5uca4tq
         mBYIphsJRU8KJtOa2BVKWzrB1XtON7+jpOIIRcvrPDjPmOI7xXBOHMusmBIKQORtWdzL
         P7z1eQV9SpkLuvSJyTLwrNz7z32Vb6/Eedz2QLeDmtiDGSaqsE08bINltGraH8y70d3g
         zrBiNv8M8DpYBx47Ft4TAnrM9qACnbjnC1Rorr57Zl3MsBp5TKBJje5ha9tSvHnIroVv
         lcoQ==
X-Gm-Message-State: APjAAAUK0GLZLFF8WGi6udj2jjd0Q1wv6sWGny8Lx9X5F1xM7bSEhRIv
        YLS9aKwP67IgnIpt9AusBEZQtMi+1sk4jF1OohHT7RhUbGf+
X-Google-Smtp-Source: APXvYqwMqjrkCA5Nz6C2Kl02P75sJtglRiLadVdDvvfuuKk8pEhv2NYmmL67pWiPfKlP4Or+i1JX1rFE7KWTCJNFZgk3BFutjz7a
MIME-Version: 1.0
X-Received: by 2002:a5e:c301:: with SMTP id a1mr2303953iok.1.1567051086634;
 Wed, 28 Aug 2019 20:58:06 -0700 (PDT)
Date:   Wed, 28 Aug 2019 20:58:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005d2a1e0591398391@google.com>
Subject: BUG: corrupted list in p9_fd_cancelled (2)
From:   syzbot <syzbot+1d26c4ed77bc6c5ed5e6@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    36146921 Merge tag 'hyperv-fixes-signed' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169f691e600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6919752cc1b760b4
dashboard link: https://syzkaller.appspot.com/bug?extid=1d26c4ed77bc6c5ed5e6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d03ba6600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1d26c4ed77bc6c5ed5e6@syzkaller.appspotmail.com

list_del corruption, ffff88808ecdbfb0->next is LIST_POISON1  
(dead000000000100)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:45!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 20174 Comm: syz-executor.1 Not tainted 5.3.0-rc5+ #125
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_del_entry_valid.cold+0x23/0x4f lib/list_debug.c:45
Code: e8 d5 06 1e fe 0f 0b 4c 89 f6 48 c7 c7 e0 26 c6 87 e8 c4 06 1e fe 0f  
0b 4c 89 ea 4c 89 f6 48 c7 c7 20 26 c6 87 e8 b0 06 1e fe <0f> 0b 4c 89 e2  
4c 89 f6 48 c7 c7 80 26 c6 87 e8 9c 06 1e fe 0f 0b
RSP: 0018:ffff8880994076d8 EFLAGS: 00010286
RAX: 000000000000004e RBX: 1ffff11013280ee9 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c2526 RDI: ffffed1013280ecd
RBP: ffff8880994076f0 R08: 000000000000004e R09: ffffed1015d060d1
R10: ffffed1015d060d0 R11: ffff8880ae830687 R12: dead000000000122
R13: dead000000000100 R14: ffff88808ecdbfb0 R15: ffff88808ecdbfb8
FS:  00007fb2aca54700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffee6574f58 CR3: 00000000a8e6d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_del_entry include/linux/list.h:131 [inline]
  list_del include/linux/list.h:139 [inline]
  p9_fd_cancelled+0x3c/0x1c0 net/9p/trans_fd.c:710
  p9_client_flush+0x1b7/0x1f0 net/9p/client.c:674
  p9_client_rpc+0x112f/0x12a0 net/9p/client.c:781
  p9_client_version net/9p/client.c:952 [inline]
  p9_client_create+0xb7f/0x1430 net/9p/client.c:1052
  v9fs_session_init+0x1e7/0x18c0 fs/9p/v9fs.c:406
  v9fs_mount+0x7d/0x920 fs/9p/vfs_super.c:120
  legacy_get_tree+0x108/0x220 fs/fs_context.c:661
  vfs_get_tree+0x8e/0x390 fs/super.c:1413
  do_new_mount fs/namespace.c:2791 [inline]
  do_mount+0x13b3/0x1c30 fs/namespace.c:3111
  ksys_mount+0xdb/0x150 fs/namespace.c:3320
  __do_sys_mount fs/namespace.c:3334 [inline]
  __se_sys_mount fs/namespace.c:3331 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3331
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459879
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb2aca53c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000459879
RDX: 00000000200002c0 RSI: 0000000020000040 RDI: 0000000000000000
RBP: 000000000075bfc8 R08: 0000000020000400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb2aca546d4
R13: 00000000004c5e2f R14: 00000000004da930 R15: 00000000ffffffff
Modules linked in:
---[ end trace c76f5f29f0af3347 ]---
RIP: 0010:__list_del_entry_valid.cold+0x23/0x4f lib/list_debug.c:45
Code: e8 d5 06 1e fe 0f 0b 4c 89 f6 48 c7 c7 e0 26 c6 87 e8 c4 06 1e fe 0f  
0b 4c 89 ea 4c 89 f6 48 c7 c7 20 26 c6 87 e8 b0 06 1e fe <0f> 0b 4c 89 e2  
4c 89 f6 48 c7 c7 80 26 c6 87 e8 9c 06 1e fe 0f 0b
RSP: 0018:ffff8880994076d8 EFLAGS: 00010286
RAX: 000000000000004e RBX: 1ffff11013280ee9 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c2526 RDI: ffffed1013280ecd
RBP: ffff8880994076f0 R08: 000000000000004e R09: ffffed1015d060d1
R10: ffffed1015d060d0 R11: ffff8880ae830687 R12: dead000000000122
R13: dead000000000100 R14: ffff88808ecdbfb0 R15: ffff88808ecdbfb8
FS:  00007fb2aca54700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffee6574f58 CR3: 00000000a8e6d000 CR4: 00000000001406f0
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
