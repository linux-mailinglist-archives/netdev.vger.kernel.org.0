Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF6926792
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 17:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfEVP6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 11:58:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38149 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbfEVP6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 11:58:06 -0400
Received: by mail-io1-f72.google.com with SMTP id w3so2102545iot.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 08:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5Hr379J3S70SDLimvqANTCJFSy9HvkPiX4L0pXQUQPE=;
        b=t4bwBXt2oiBPsa2Y9HSYG8tvyNkK0m5qd7lenSvP/ccNdaiynGdyMPBvNVE3rvU026
         Yu69DbVcpHB9AY+4lGaIrKyILbo6KqeSW2QBkt5C3vFHjw/FpgDuYK1lMpubTtxI4T46
         FK/zc0mNRiIdIdlufXN+djmIg9D2ldJdppWKQ/C1pQMdp5vSmfjzH60owSYKzbux8frj
         ohOZDYdYcITkGIlxg8qqsjlUG/nFo2DASauvHbPGUMjGxrQ7VKXTxdP4VOHlirKqCA0j
         aBCMBDC6WG2K6A2kyprGzX4wHlOiuYW0mpLEyMoVGzDoJgkJ77sqpW4vY4i9u0j1rJSN
         Ix+w==
X-Gm-Message-State: APjAAAWpz/1IY6qs94wKy78/UCa2xdOBb8GQ5EwQI33sRuUH5lynuTa+
        XzC7XHcvleHF/7uD/j10WW19mWBty+EJ9l7KjpyZz7w1En71
X-Google-Smtp-Source: APXvYqw2ILsEQGMKI0i0kUvvP0mRSGTA0PmVYsQpzG63pXcAcbsE3e5J2VwW5rXWO4+GVVG5fIi7xKynqBTJCPI7oziYwaQWAIBA
MIME-Version: 1.0
X-Received: by 2002:a24:4d87:: with SMTP id l129mr8806701itb.80.1558540685939;
 Wed, 22 May 2019 08:58:05 -0700 (PDT)
Date:   Wed, 22 May 2019 08:58:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f41cd905897c075e@google.com>
Subject: kernel BUG at include/linux/scatterlist.h:LINE!
From:   syzbot <syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        vakul.garg@nxp.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    af8f3fb7 net: stmmac: dma channel control register need to..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17c2d418a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=df0d4ec12332661dd1f9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b53ce4a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b0aa52a00000

The bug was bisected to:

commit f295b3ae9f5927e084bd5decdff82390e3471801
Author: Vakul Garg <vakul.garg@nxp.com>
Date:   Wed Mar 20 02:03:36 2019 +0000

     net/tls: Add support of AES128-CCM based ciphers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16915282a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15915282a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11915282a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")

------------[ cut here ]------------
kernel BUG at include/linux/scatterlist.h:97!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8868 Comm: syz-executor428 Not tainted 5.2.0-rc1+ #21
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:sg_assign_page include/linux/scatterlist.h:97 [inline]
RIP: 0010:sg_set_page include/linux/scatterlist.h:119 [inline]
RIP: 0010:sk_msg_page_add include/linux/skmsg.h:246 [inline]
RIP: 0010:tls_sw_do_sendpage net/tls/tls_sw.c:1171 [inline]
RIP: 0010:tls_sw_sendpage+0xd63/0xf50 net/tls/tls_sw.c:1230
Code: c6 c0 38 0d 88 4c 89 ef e8 aa 4c 89 fb 0f 0b e8 73 38 61 fb 4d 8d 6c  
24 ff e9 92 f8 ff ff e8 64 38 61 fb 0f 0b e8 5d 38 61 fb <0f> 0b 45 31 ed  
e9 bc fe ff ff e8 4e 38 61 fb 83 85 c4 fe ff ff 01
RSP: 0018:ffff888091caf8f8 EFLAGS: 00010293
RAX: ffff8880a659e640 RBX: dffffc0000000000 RCX: ffffffff860f65b3
RDX: 0000000000000000 RSI: ffffffff860f6c13 RDI: 0000000000000007
RBP: ffff888091cafa48 R08: ffff8880a659e640 R09: fffff940004cac97
R10: fffff940004cac96 R11: ffffea00026564b7 R12: 0000000000000004
R13: 0000000000000001 R14: ffff8880a44f4e88 R15: ffff8880a57a6d00
FS:  000055555579e880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000009b335000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  inet_sendpage+0x168/0x630 net/ipv4/af_inet.c:819
  kernel_sendpage+0x92/0xf0 net/socket.c:3648
  sock_sendpage+0x8b/0xc0 net/socket.c:946
  pipe_to_sendpage+0x296/0x360 fs/splice.c:448
  splice_from_pipe_feed fs/splice.c:499 [inline]
  __splice_from_pipe+0x38c/0x7d0 fs/splice.c:623
  splice_from_pipe+0x108/0x170 fs/splice.c:658
  generic_splice_sendpage+0x3c/0x50 fs/splice.c:828
  do_splice_from fs/splice.c:847 [inline]
  do_splice+0x708/0x1410 fs/splice.c:1154
  __do_sys_splice fs/splice.c:1424 [inline]
  __se_sys_splice fs/splice.c:1404 [inline]
  __x64_sys_splice+0x2c6/0x330 fs/splice.c:1404
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4413e9


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
