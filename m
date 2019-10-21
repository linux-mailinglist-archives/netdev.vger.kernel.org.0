Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6F1DE3AE
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfJUFVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:21:08 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:37943 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:21:07 -0400
Received: by mail-il1-f197.google.com with SMTP id a7so5969482iln.5
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RNA7wvEo4dZS4Zjh6nazheoAtSIOteZ88hIBmR8F1xQ=;
        b=tuXNvOcTnk0hnc+bjiFeqMGJGl54kxrCih44MB6IO1doYKEy9nYnSdcF/tIwJGgcTD
         VY+0UdxEFf0QnyUGzfrB0fLdeRQvB+zgvEa/X4vjADT/eMxurbSTUdS3w7QH90jbOmgv
         jgY3bz11mD82yMS4rzDdeKfnkPtz+vqUibE3292U5R7R80CPNvSL43vq/BUsH5t2L3xC
         P/bxvgAe5gi7f/WC7Vwi6ibGyJafQq0PhtnzYrs0hS53t1Nicgc5NBJcOV9EJhSA5STM
         SNfteOYYWY5oDlRWNY4ahi8kxeUyIoiV0r3njH6WXhnjEnPGIF+mIO5ll5mr7axOfj7u
         8Iug==
X-Gm-Message-State: APjAAAVr7shx9hAfHFmK3g5pKrIyYiASBoytiiUUhGoVIuqJM8bJFBH8
        XsLuzT8/+zVkmA8ad1DFQAM7uZdBIQvx3GvFRg/PyhHzWJBl
X-Google-Smtp-Source: APXvYqyCxl0gyCt8f14Ks5hJ2E9kauUFKQD0IBH+dz03PqnOwax24Qywyva4FwEaknsdd/yE0CqkhHO+VOHjd9NQkTK8A/cz5fxI
MIME-Version: 1.0
X-Received: by 2002:a6b:b2d5:: with SMTP id b204mr693498iof.137.1571635266901;
 Sun, 20 Oct 2019 22:21:06 -0700 (PDT)
Date:   Sun, 20 Oct 2019 22:21:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ccde8d059564d93d@google.com>
Subject: general protection fault in batadv_iv_ogm_queue_add
From:   syzbot <syzbot+7dd2da51d8ae6f990403@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    998d7551 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1702db87600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0ac4d9b35046343
dashboard link: https://syzkaller.appspot.com/bug?extid=7dd2da51d8ae6f990403
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7dd2da51d8ae6f990403@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 4256 Comm: kworker/u4:0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:batadv_iv_ogm_queue_add+0x49/0x1120  
net/batman-adv/bat_iv_ogm.c:605
Code: 48 89 75 b8 48 89 4d c0 4c 89 45 b0 44 89 4d d0 e8 fc 02 46 fa 48 8d  
7b 03 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 18 0d 00 00
RSP: 0018:ffff88805d2cfb80 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888092284000
RDX: 0000000000000000 RSI: ffffffff872d1214 RDI: 0000000000000003
RBP: ffff88805d2cfc18 R08: ffff888092284000 R09: 0000000000000001
R10: ffffed100ba59f77 R11: 0000000000000003 R12: dffffc0000000000
R13: ffffed101245080e R14: ffff888092284000 R15: 0000000100051cf6
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200002c0 CR3: 00000000a421b000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  batadv_iv_ogm_schedule+0xb0b/0xe50 net/batman-adv/bat_iv_ogm.c:813
  batadv_iv_send_outstanding_bat_ogm_packet+0x580/0x760  
net/batman-adv/bat_iv_ogm.c:1675
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 04d065842187c2b8 ]---
RIP: 0010:batadv_iv_ogm_queue_add+0x49/0x1120  
net/batman-adv/bat_iv_ogm.c:605
Code: 48 89 75 b8 48 89 4d c0 4c 89 45 b0 44 89 4d d0 e8 fc 02 46 fa 48 8d  
7b 03 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 18 0d 00 00
RSP: 0018:ffff88805d2cfb80 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888092284000
RDX: 0000000000000000 RSI: ffffffff872d1214 RDI: 0000000000000003
RBP: ffff88805d2cfc18 R08: ffff888092284000 R09: 0000000000000001
R10: ffffed100ba59f77 R11: 0000000000000003 R12: dffffc0000000000
R13: ffffed101245080e R14: ffff888092284000 R15: 0000000100051cf6
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200002c0 CR3: 00000000a421b000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
