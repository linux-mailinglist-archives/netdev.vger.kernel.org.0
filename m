Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7316133
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfEGJkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:40:07 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:43605 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfEGJkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:40:06 -0400
Received: by mail-it1-f197.google.com with SMTP id v7so14110907itf.8
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=M+r1dDE8p2pZ1Gb6K0q/nd2z9VfNJGEaSacktrDrGiE=;
        b=ieNHg8W95y1npdQ9unAbjwyytaY8ow536ZIMAFMYHUaQOjC8zu2lg1STfmpKf7lmbB
         wcpfgUE274+Gl3E/F05JYeUqu4JXQsL3tQXXz+AYjhArzVw6TJH7FXtPC5vC8SoPq0fb
         pe0HM48gabBQMND986SpvZmQZijRQlaFDwn9FRNlRnfoc5iHGXEcfWlcNg9oyvywWydq
         6mqeUEjcbzX2AAvMaxryK/HtYqILFyHciV4u6PCLzvBQTn514f1dVlLfllseRKvAOma3
         ZykxztAwyfxSGbxWLLqUeGPb2LwkoI8f8PWtipYycLp6VLDc8s/ZgQx/6HngQfqWMdFv
         hsAw==
X-Gm-Message-State: APjAAAWBFRqrGSvJ1vZoVyVZLwvsb9cLsx3KCLwc2NFsInjLY2NFrxae
        NCYgoEkwSj2BQiru2J45nMw5NrvkAO8fAap6Js3o33vFPASo
X-Google-Smtp-Source: APXvYqwRADDuYNGX3Y7wDUsoO/ls6z/INnziGesI/Q40aER2KXJo4Xe68NwqOHF0E9x1LanGkDBhQDSgSqNmGas1uSblsCD++5Vo
MIME-Version: 1.0
X-Received: by 2002:a02:7122:: with SMTP id n34mr22853517jac.73.1557222005928;
 Tue, 07 May 2019 02:40:05 -0700 (PDT)
Date:   Tue, 07 May 2019 02:40:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007ffeda0588490086@google.com>
Subject: general protection fault in rfcomm_dlc_open
From:   syzbot <syzbot+7cd22aae14e82bcf8379@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gustavo@embeddedor.com,
        johan.hedberg@gmail.com, keescook@chromium.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tiny.windzz@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd86972a Merge branch 'tcp-undo-congestion'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=127331dca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=429a5a550a968ac7
dashboard link: https://syzkaller.appspot.com/bug?extid=7cd22aae14e82bcf8379
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7cd22aae14e82bcf8379@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 31668 Comm: syz-executor.5 Not tainted 5.1.0-rc6+ #163
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rfcomm_dlc_get net/bluetooth/rfcomm/core.c:360 [inline]
RIP: 0010:__rfcomm_dlc_open net/bluetooth/rfcomm/core.c:396 [inline]
RIP: 0010:rfcomm_dlc_open+0x28a/0xd60 net/bluetooth/rfcomm/core.c:431
Code: 9d 50 ff ff ff 74 67 e8 14 b6 16 fb 48 8d bb 44 01 00 00 48 b9 00 00  
00 00 00 fc ff df 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 08 38  
d0 7f 08 84 c0 0f 85 e6 09 00 00 0f b6 b3 44 01 00
RSP: 0018:ffff888068067c88 EFLAGS: 00010206
RAX: 0620fbe76423b6ea RBX: 3107df3b211db60f RCX: dffffc0000000000
RDX: 0000000000000003 RSI: ffffffff8659d70c RDI: 3107df3b211db753
RBP: ffff888068067d60 R08: ffff8880a7f1e3c0 R09: fffffbfff12898a5
R10: ffff888068067c78 R11: ffffffff8944c527 R12: ffff888085e7f0c0
R13: ffff88809b3b2300 R14: 1ffff1100d00cf97 R15: 000000008659d603
FS:  00007f9e3b56f700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000073c000 CR3: 000000006895d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  rfcomm_sock_connect+0x38a/0x4b0 net/bluetooth/rfcomm/sock.c:416
  __sys_connect+0x266/0x330 net/socket.c:1828
  __do_sys_connect net/socket.c:1839 [inline]
  __se_sys_connect net/socket.c:1836 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1836
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9e3b56ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 000000000000000e RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9e3b56f6d4
R13: 00000000004bf18a R14: 00000000004d0218 R15: 00000000ffffffff
Modules linked in:
---[ end trace cac206debc49dd35 ]---
RIP: 0010:rfcomm_dlc_get net/bluetooth/rfcomm/core.c:360 [inline]
RIP: 0010:__rfcomm_dlc_open net/bluetooth/rfcomm/core.c:396 [inline]
RIP: 0010:rfcomm_dlc_open+0x28a/0xd60 net/bluetooth/rfcomm/core.c:431
Code: 9d 50 ff ff ff 74 67 e8 14 b6 16 fb 48 8d bb 44 01 00 00 48 b9 00 00  
00 00 00 fc ff df 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 08 38  
d0 7f 08 84 c0 0f 85 e6 09 00 00 0f b6 b3 44 01 00
RSP: 0018:ffff888068067c88 EFLAGS: 00010206
RAX: 0620fbe76423b6ea RBX: 3107df3b211db60f RCX: dffffc0000000000
RDX: 0000000000000003 RSI: ffffffff8659d70c RDI: 3107df3b211db753
RBP: ffff888068067d60 R08: ffff8880a7f1e3c0 R09: fffffbfff12898a5
R10: ffff888068067c78 R11: ffffffff8944c527 R12: ffff888085e7f0c0
R13: ffff88809b3b2300 R14: 1ffff1100d00cf97 R15: 000000008659d603
FS:  00007f9e3b56f700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000006895d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
