Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2032A5D8
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 19:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfEYRiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 13:38:20 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:32877 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfEYRiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 13:38:06 -0400
Received: by mail-it1-f199.google.com with SMTP id 15so7626264ita.0
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 10:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=daCvjD3J7wMyiJrWqqsu0uiaOYAVZbEq3QSXAOr1WXw=;
        b=Pl+mVCgM5vXfRSLpT9Uz5a+spQGbV1wQFd5qsrXFyd7R5xd/1a+dSwf726KAcMaoMC
         ezHhFj0s+8fC0XGPOqwATrUHGZ9wr4ibGQmUjz5esgJIbrJXXUgy66Iboi7Qv8Q+hX2T
         RWCdvmnuTVAQ518HR1YSsnBcxzfYMcsHAYIblbL1Em1IA5Fc3seaGRNvToCYIUAFUDdn
         fAkvWHMrunJJqWaQnl37pIhiEjBrP8LEi0ZSi+tPep1twGlISa4sYHVM5aBmODLTNtKm
         Z1Uswp3arsuaM/fIc+jj923awFOn77a9MZclkywENb++IyyC5WmSjjRakTFV49FYSYtH
         xM+Q==
X-Gm-Message-State: APjAAAV0X93LpH+e9yhicE3AM3RlWeY3JdF+2Bu77uFOQMPNGEAdlFgK
        G8vPYlFKWqcLCyy2m61w5axrDhs038i32GLwUxrDpaYOkhgj
X-Google-Smtp-Source: APXvYqzq6J2zKPiYBmhNgYgxVXGNgSLl9jCqWbQ4eJlvEEIoaaVoiii7pTHvpU8vtGOm/EI7tUcV7dliZUXxXdazaYTJd+9DF8nn
MIME-Version: 1.0
X-Received: by 2002:a05:660c:7cd:: with SMTP id e13mr21734037itl.40.1558805885654;
 Sat, 25 May 2019 10:38:05 -0700 (PDT)
Date:   Sat, 25 May 2019 10:38:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000016cb560589b9c7c4@google.com>
Subject: KASAN: slab-out-of-bounds Read in class_equal
From:   syzbot <syzbot+3d04999521633dceb439@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    af5136f9 selftests/net: SO_TXTIME with ETF and FQ
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13164ee4a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=3d04999521633dceb439
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1661b6e4a00000

Bisection is inconclusive: the first bad commit could be any of:

7c00e8ae Merge tag 'armsoc-soc' of  
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
a2b7ab45 Merge tag 'linux-watchdog-4.18-rc1' of  
git://www.linux-watchdog.org/linux-watchdog
721afaa2 Merge tag 'armsoc-dt' of  
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1062daaaa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3d04999521633dceb439@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in class_equal+0x40/0x50  
kernel/locking/lockdep.c:1527
Read of size 8 at addr ffff8880813cdab0 by task syz-executor.0/9147

CPU: 0 PID: 9147 Comm: syz-executor.0 Not tainted 5.2.0-rc1+ #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:

Allocated by task 2266519551:
------------[ cut here ]------------
kernel BUG at mm/slab.c:4178!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9147 Comm: syz-executor.0 Not tainted 5.2.0-rc1+ #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__check_heap_object+0xa5/0xb3 mm/slab.c:4178
Code: 2b 48 c7 c7 4d fc 61 88 e8 28 ad 07 00 5d c3 41 8b 91 04 01 00 00 48  
29 c7 48 39 d7 77 bd 48 01 d0 48 29 c8 4c 39 c0 72 b2 c3 <0f> 0b 48 c7 c7  
4d fc 61 88 e8 3c b2 07 00 44 89 e1 48 c7 c7 08 fd
RSP: 0018:ffff8880813cd370 EFLAGS: 00010046
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 000000000000000c
RDX: ffff8880813cc340 RSI: 0000000000000000 RDI: ffff8880813cd468
RBP: ffff8880813cd3c0 R08: 0000000000000001 R09: ffff8880aa594c40
R10: 0000000000000f23 R11: 0000000000000000 R12: ffff8880813cd468
R13: ffffea000204f300 R14: ffff8880813cd469 R15: 0000000000000001
FS:  00005555564e1940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff8c046bd8 CR3: 000000009a952000 CR4: 00000000001406f0
Call Trace:
Modules linked in:
---[ end trace e78aeeb619bc791b ]---
RIP: 0010:__check_heap_object+0xa5/0xb3 mm/slab.c:4178
Code: 2b 48 c7 c7 4d fc 61 88 e8 28 ad 07 00 5d c3 41 8b 91 04 01 00 00 48  
29 c7 48 39 d7 77 bd 48 01 d0 48 29 c8 4c 39 c0 72 b2 c3 <0f> 0b 48 c7 c7  
4d fc 61 88 e8 3c b2 07 00 44 89 e1 48 c7 c7 08 fd
RSP: 0018:ffff8880813cd370 EFLAGS: 00010046
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 000000000000000c
RDX: ffff8880813cc340 RSI: 0000000000000000 RDI: ffff8880813cd468
RBP: ffff8880813cd3c0 R08: 0000000000000001 R09: ffff8880aa594c40
R10: 0000000000000f23 R11: 0000000000000000 R12: ffff8880813cd468
R13: ffffea000204f300 R14: ffff8880813cd469 R15: 0000000000000001
FS:  00005555564e1940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff8c046bd8 CR3: 000000009a952000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
