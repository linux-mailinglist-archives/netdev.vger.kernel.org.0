Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490CF221E7
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 08:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfERGwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 02:52:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:40224 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfERGwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 02:52:06 -0400
Received: by mail-io1-f72.google.com with SMTP id d24so7167626iob.7
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 23:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TwUoesgSEecXhR/vJBArd4elSaGTejiqfQvMTKi9FuM=;
        b=eJSM3bivuu8P0Esnt8JJiIi/u3JjiFQkFqOI6bn1kNFnyeHBj+23EC34zPAH/ZOcyG
         Feo9my+ufMhWmZ8v6SGbMmi15w3alt97lykRSo7kWXy0xDC38jkxVQO/LYwJgRsrL91a
         UFANZPV9hR2Z7ynXrutwQFgHtgbKMSocHfLOG+oJLXtQLUGqfvHVawRpMYwDXLtPw0Q7
         vFIbrD3YiHchDMMRKlIirndqEkbxBwDDdOU58mwZY7j1wkBznVXrgDVQb4ClTEUT+0zT
         BcNBLtL0QdYLmT6Na0cIZzOULdB7Qe6V52Y2e32AGEWWoZp/1XRgFY6ZK1JIePQu+/2S
         mRgw==
X-Gm-Message-State: APjAAAXVIHqdMIthPh8M7fJzXiHAyB9X9ut7aA5Rz8+gmCJqIU6+SVyA
        UHF5iI1iNpB7cWeBH7JWJZ662EAVDqR03pD4T4wlNCLvNtFr
X-Google-Smtp-Source: APXvYqyeKvi4NJniW+mpxjebxABk/bhxB6U3pnpaWGRmSa7da5sBiDbxf5fAnGq2tWPHJq2BcSgmmlHbIKG8W7rHe+/fY3KAqf3h
MIME-Version: 1.0
X-Received: by 2002:a6b:ef07:: with SMTP id k7mr33835519ioh.276.1558162325333;
 Fri, 17 May 2019 23:52:05 -0700 (PDT)
Date:   Fri, 17 May 2019 23:52:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e76a90058923eff3@google.com>
Subject: BUG: corrupted list in proto_register
From:   syzbot <syzbot+7bc2817ec0ed18de9079@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    532b0f7e tipc: fix modprobe tipc failed after switch order..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12665fe8a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=7bc2817ec0ed18de9079
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7bc2817ec0ed18de9079@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at lib/list_debug.c:29!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9479 Comm: syz-executor.2 Not tainted 5.1.0+ #18
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
Code: 56 ff ff ff 4c 89 e1 48 c7 c7 20 4c a3 87 e8 00 60 25 fe 0f 0b 48 89  
f2 4c 89 e1 4c 89 ee 48 c7 c7 60 4d a3 87 e8 e9 5f 25 fe <0f> 0b 48 89 f1  
48 c7 c7 e0 4c a3 87 4c 89 e6 e8 d5 5f 25 fe 0f 0b
RSP: 0018:ffff8880747afb88 EFLAGS: 00010282
RAX: 0000000000000058 RBX: ffffffff89544920 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815afbe6 RDI: ffffed100e8f5f63
RBP: ffff8880747afba0 R08: 0000000000000058 R09: ffffed1015d26011
R10: ffffed1015d26010 R11: ffff8880ae930087 R12: ffffffff89544ab0
R13: ffffffff89544ab0 R14: ffffffff89544ab0 R15: ffffffff89544a50
FS:  00000000018b2940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f88f7dac000 CR3: 0000000072fc7000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_add include/linux/list.h:60 [inline]
  list_add include/linux/list.h:79 [inline]
  proto_register+0x459/0x8e0 net/core/sock.c:3385
  tipc_socket_init+0x1c/0x70 net/tipc/socket.c:3241
  tipc_init_net+0x32a/0x5b0 net/tipc/core.c:71
  ops_init+0xb6/0x410 net/core/net_namespace.c:129
  setup_net+0x2d3/0x740 net/core/net_namespace.c:315
  copy_net_ns+0x1df/0x340 net/core/net_namespace.c:438
  create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:107
  unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:206
  ksys_unshare+0x440/0x980 kernel/fork.c:2664
  __do_sys_unshare kernel/fork.c:2732 [inline]
  __se_sys_unshare kernel/fork.c:2730 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:2730
  do_syscall_64+0x103/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b897
Code: 00 00 00 b8 63 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 ad 8d fb ff c3  
66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 8d 8d fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc2b108368 EFLAGS: 00000206 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000000073c988 RCX: 000000000045b897
RDX: 0000000000000000 RSI: 00007ffc2b108310 RDI: 0000000040000000
RBP: 00000000000000f8 R08: 0000000000000000 R09: 0000000000000005
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000414ab0
R13: 0000000000414b40 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace e4cbbfc7878b1973 ]---
RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
Code: 56 ff ff ff 4c 89 e1 48 c7 c7 20 4c a3 87 e8 00 60 25 fe 0f 0b 48 89  
f2 4c 89 e1 4c 89 ee 48 c7 c7 60 4d a3 87 e8 e9 5f 25 fe <0f> 0b 48 89 f1  
48 c7 c7 e0 4c a3 87 4c 89 e6 e8 d5 5f 25 fe 0f 0b
RSP: 0018:ffff8880747afb88 EFLAGS: 00010282
RAX: 0000000000000058 RBX: ffffffff89544920 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815afbe6 RDI: ffffed100e8f5f63
RBP: ffff8880747afba0 R08: 0000000000000058 R09: ffffed1015d26011
R10: ffffed1015d26010 R11: ffff8880ae930087 R12: ffffffff89544ab0
R13: ffffffff89544ab0 R14: ffffffff89544ab0 R15: ffffffff89544a50
FS:  00000000018b2940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe45a0c89b8 CR3: 0000000072fc7000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
