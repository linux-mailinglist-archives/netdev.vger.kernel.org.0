Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0918233E32
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFDFKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:10:16 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:57008 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfFDFKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:10:08 -0400
Received: by mail-it1-f198.google.com with SMTP id l124so17023451itg.6
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ubebD8Dlw2vYsWiQ4jFXTP6i4/qba8bg2GOFYk+v9F0=;
        b=qCTn1rApsdWuSVvnd1tbzglHS1zsH7+aTkoMDtKKiDeRQdV+SidRF4+Z1i51ETWpgS
         uhzR5HFGu2ePnwpsv6RkTP6GtgFFWgLSB064FpbVufv2Pq0EanWbSlbMju3PEJ5J4Ojn
         wZu+/Kbijn3Z3+oE+qXjU2AUV9U6VAIzrLGb+r8pbnbt1GE1exRPtrqDL8pXUdm0piW9
         GgelhQ5oiXm1nDP2BkZIz+aFwU55ewSOwt+gl+WRL8WZEM0YeJ+1L29sxzbxpn/WYgFy
         pSO3X36TJD1c4uxaXfSdlcxPZqmgwxQoTJamCWfm/Qna2A9HeBZgz9D3367Dcbcf2hLs
         Tgag==
X-Gm-Message-State: APjAAAUt5lCzNJAUlqjjCDlI41dwx9FgO8YLpMwFVVRBgyo9sgWSTW9l
        FElt2NbbOf3mMdXRPuKkou05zEqOUYdkYU63+oZD5ylZwZRQ
X-Google-Smtp-Source: APXvYqyeuu1orXSJBK3MjqNrEH9fHJIO4KzFsfOnYXLF5M2dvEV9mn9tcY8adBLpmK9b34aHEE8R6MOHpncTMa4gmDnOABT0A8v7
MIME-Version: 1.0
X-Received: by 2002:a5e:da47:: with SMTP id o7mr3152275iop.83.1559625007552;
 Mon, 03 Jun 2019 22:10:07 -0700 (PDT)
Date:   Mon, 03 Jun 2019 22:10:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ee293058a787e2d@google.com>
Subject: general protection fault in fib6_nh_init
From:   syzbot <syzbot+1b2927fda48c5bf2e931@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c1e9e01d Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1319e05aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7b54c66298f8420
dashboard link: https://syzkaller.appspot.com/bug?extid=1b2927fda48c5bf2e931
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1b2927fda48c5bf2e931@syzkaller.appspotmail.com

general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 4498 Comm: syz-executor.4 Not tainted 5.2.0-rc2+ #10
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:ipv6_addr_any include/net/ipv6.h:626 [inline]
RIP: 0010:ip6_route_check_nh_onlink net/ipv6/route.c:2910 [inline]
RIP: 0010:ip6_validate_gw net/ipv6/route.c:3013 [inline]
RIP: 0010:fib6_nh_init+0x47e/0x1c80 net/ipv6/route.c:3121
Code: 89 de e8 45 9f 4e fb 48 85 db 0f 84 fb 10 00 00 e8 97 9d 4e fb 48 8d  
7b 40 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 bf 16 00 00 48 8d 7b 48 48 8b 4b 40 48 b8 00 00
RSP: 0018:ffff888060e277c0 EFLAGS: 00010a02
RAX: dffffc0000000000 RBX: ff8880a43d5cc000 RCX: ffffc90012a9f000
RDX: 1ff1101487ab9808 RSI: ffffffff86220829 RDI: ff8880a43d5cc040
RBP: ffff888060e27840 R08: ffff8880659d2400 R09: ffffed1015d06be8
R10: ffffed1015d06be7 R11: ffff8880ae835f3b R12: ffff88809d123d3f
R13: ffff888060e279b0 R14: ffff888085b9f6d8 R15: ffff888060e279c4
FS:  00007f350a07c700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000606ed8 CR3: 0000000092f12000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip6_route_info_create+0x922/0x1240 net/ipv6/route.c:3313
  ip6_route_add+0x27/0xc0 net/ipv6/route.c:3349
  ipv6_route_ioctl+0x2b9/0x360 net/ipv6/route.c:3875
  inet6_ioctl+0x17c/0x1c0 net/ipv6/af_inet6.c:553
  sock_do_ioctl+0xd8/0x2f0 net/socket.c:1049
  sock_ioctl+0x3ed/0x780 net/socket.c:1200
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f350a07bc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000020000000 RSI: 000000000000890b RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f350a07c6d4
R13: 00000000004c4e0b R14: 00000000004d8b50 R15: 00000000ffffffff
Modules linked in:
---[ end trace 72dad8f57a5b777a ]---
RIP: 0010:ipv6_addr_any include/net/ipv6.h:626 [inline]
RIP: 0010:ip6_route_check_nh_onlink net/ipv6/route.c:2910 [inline]
RIP: 0010:ip6_validate_gw net/ipv6/route.c:3013 [inline]
RIP: 0010:fib6_nh_init+0x47e/0x1c80 net/ipv6/route.c:3121
Code: 89 de e8 45 9f 4e fb 48 85 db 0f 84 fb 10 00 00 e8 97 9d 4e fb 48 8d  
7b 40 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 bf 16 00 00 48 8d 7b 48 48 8b 4b 40 48 b8 00 00
RSP: 0018:ffff888060e277c0 EFLAGS: 00010a02
RAX: dffffc0000000000 RBX: ff8880a43d5cc000 RCX: ffffc90012a9f000
RDX: 1ff1101487ab9808 RSI: ffffffff86220829 RDI: ff8880a43d5cc040
RBP: ffff888060e27840 R08: ffff8880659d2400 R09: ffffed1015d06be8
R10: ffffed1015d06be7 R11: ffff8880ae835f3b R12: ffff88809d123d3f
R13: ffff888060e279b0 R14: ffff888085b9f6d8 R15: ffff888060e279c4
FS:  00007f350a07c700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000625208 CR3: 0000000092f12000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
