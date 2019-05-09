Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B204418A18
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEIMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:52:36 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:54325 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfEIMwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 08:52:36 -0400
Received: by mail-it1-f193.google.com with SMTP id a190so3311368ite.4
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 05:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sD/4d5nN7WRBU0Y3WW7mkSq3V4OLzWNzOx10r/GN1Sw=;
        b=gVTdX/+ADY2e/AY2qKiWjxssWkzkc66M9+Jya4DDPYaGIv+JnssZMv8ehXAp14owq9
         6MFl/8xnX41wJpZHTqQJ8xGnox0S8qFvDGkD2+qzy3ktig1Kp1peEkZGsapJRJDweNx7
         2+qZmL3DyytrzDgriEzORxijA/YXnrXtRHu+ZRYUNELgPK2cW6aXmGYrHPLjGM+bhmyK
         OAmQ1NtMKcb9P54ZSIMZmfXX9Y+1bl34fSA7gtTt7oz3B6LjFFBx1rPDGKrjcjaC7UWa
         CicmRvmGBrr8/uIHjG+RYafGwvrIgsvwawCA9R36JXTGGIig/idBIqTdf/G4zJ0bSvtj
         37nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sD/4d5nN7WRBU0Y3WW7mkSq3V4OLzWNzOx10r/GN1Sw=;
        b=NnOT/NHaadQKmN2dMgRWNnKJ9p9J0koGON03/IDeJnbeqNN4DwGDWITNM1KAwvKkip
         8+7V2kLNGDMx9GG5t+Y2d5d8VLjm0qtUFlxN9x8DF5Wrvb54RVy/T+SYpjlvH8UNAU/z
         Gljtuu/VmbAfwrmsuKN4EIErjqLJlNxbqvZOUMR5xajmfZVq4FNkY4l7Jj5Rf+utZ1mz
         bWaCuWo9v79VoWUbl/ATAEq6cuD/ge6Jc2CnLXru72xc9kafgXo6Wb5GKcaiD4zhmkQY
         tLIr0nK7beQci67LhxPq5lpCRI9zxUEQ7ntvKKumnjy5yo8BHlAoSwTzI2tazMqGE52Y
         EhBw==
X-Gm-Message-State: APjAAAWNBlrr+RHaobcWn8+G6yZPm4ROfx2Fw1E2E2Xkz0KRdSQFZDMf
        sA2buJh92CrH0Jeh9dmkjvE6gQOtKCG0po6DhT02NQ==
X-Google-Smtp-Source: APXvYqxJzo6davw/GDhhNkyeCq6Qq7aeKZ4SiKMNerQ2IXXU3EL+sSf/hWC+gdl+DSmf4UswMlpUR7Q4FUKN7+wltMo=
X-Received: by 2002:a05:660c:10f:: with SMTP id w15mr2554328itj.166.1557406355048;
 Thu, 09 May 2019 05:52:35 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f10885058873bf83@google.com>
In-Reply-To: <000000000000f10885058873bf83@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 May 2019 14:52:23 +0200
Message-ID: <CACT4Y+a+deH-8WsR74bG+WJifzyR2ZD1cYhh951H9WNwaB63eQ@mail.gmail.com>
Subject: Re: BUG: unable to handle page fault for address: ADDR
To:     syzbot <syzbot+208b9694ae6aee1c7197@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: syzbot <syzbot+208b9694ae6aee1c7197@syzkaller.appspotmail.com>
Date: Thu, May 9, 2019 at 2:40 PM
To: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
<syzkaller-bugs@googlegroups.com>, <yoshfuji@linux-ipv6.org>

> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    80f23212 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=112de0d8a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=40a58b399941db7e
> dashboard link: https://syzkaller.appspot.com/bug?extid=208b9694ae6aee1c7197
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+208b9694ae6aee1c7197@syzkaller.appspotmail.com

Kernel has changed format of crash messages, but otherwise this is

#syz dup: BUG: unable to handle kernel paging request in iptunnel_xmit

https://syzkaller.appspot.com/bug?extid=61816a2458fec4918227
https://groups.google.com/forum/#!msg/syzkaller-bugs/dOzIJi3RjfY/buHkKqxgEgAJ

Reported in December, still happens.


> New replicast peer: 172.20.20.187
> BUG: unable to handle page fault for address: ffffde202758ca0b
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 17591 Comm: syz-executor.3 Not tainted 5.1.0+ #3
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:iptunnel_xmit_stats include/net/ip_tunnels.h:444 [inline]
> RIP: 0010:iptunnel_xmit+0x6e5/0x970 net/ipv4/ip_tunnel_core.c:94
> Code: c1 e9 03 80 3c 11 00 0f 85 72 02 00 00 48 03 1c c5 60 70 6e 88 48 b8
> 00 00 00 00 00 fc ff df 48 8d 7b 18 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f
> 85 5d 02 00 00 48 8d 7b 10 4d 63 e4 48 b8 00 00 00
> RSP: 0018:ffff8880a0fb7008 EFLAGS: 00010a02
> RAX: dffffc0000000000 RBX: ffff11013ac65040 RCX: 1ffffffff10dce0c
> RDX: 1fffe2202758ca0b RSI: ffffffff83344b4c RDI: ffff11013ac65058
> RBP: ffff8880a0fb7068 R08: ffff888059df8140 R09: ffffed1015d06be0
> R10: ffffed1015d06bdf R11: ffff8880ae835efb R12: 00000000000000fc
> R13: ffff88806bbfec40 R14: ffff88806a6a3714 R15: ffff8880a097a8c0
> FS:  00007fcf84ffc700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffde202758ca0b CR3: 00000000970bb000 CR4: 00000000001406f0
> Call Trace:
>   udp_tunnel_xmit_skb+0x236/0x310 net/ipv4/udp_tunnel.c:191
>   tipc_udp_xmit.isra.0+0x805/0xcc0 net/tipc/udp_media.c:181
>   tipc_udp_send_msg+0x295/0x4a0 net/tipc/udp_media.c:247
>   tipc_bearer_xmit_skb+0x172/0x360 net/tipc/bearer.c:503
>   tipc_enable_bearer+0xac4/0xd20 net/tipc/bearer.c:328
>   __tipc_nl_bearer_enable+0x2de/0x3a0 net/tipc/bearer.c:899
>   tipc_nl_bearer_enable+0x23/0x40 net/tipc/bearer.c:907
>   genl_family_rcv_msg+0x753/0xf90 net/netlink/genetlink.c:629
>   genl_rcv_msg+0xca/0x16c net/netlink/genetlink.c:654
>   netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2486
>   genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
>   netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
>   netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1337
>   netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
>   sock_sendmsg_nosec net/socket.c:660 [inline]
>   sock_sendmsg+0x12e/0x170 net/socket.c:671
>   ___sys_sendmsg+0x81d/0x960 net/socket.c:2292
>   __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
>   __do_sys_sendmsg net/socket.c:2339 [inline]
>   __se_sys_sendmsg net/socket.c:2337 [inline]
>   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
>   do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x458da9
> Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fcf84ffbc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fcf84ffc6d4
> R13: 00000000004c6449 R14: 00000000004dad18 R15: 00000000ffffffff
> Modules linked in:
> CR2: ffffde202758ca0b
> ---[ end trace 7b8973c639719d58 ]---
> RIP: 0010:iptunnel_xmit_stats include/net/ip_tunnels.h:444 [inline]
> RIP: 0010:iptunnel_xmit+0x6e5/0x970 net/ipv4/ip_tunnel_core.c:94
> Code: c1 e9 03 80 3c 11 00 0f 85 72 02 00 00 48 03 1c c5 60 70 6e 88 48 b8
> 00 00 00 00 00 fc ff df 48 8d 7b 18 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f
> 85 5d 02 00 00 48 8d 7b 10 4d 63 e4 48 b8 00 00 00
> RSP: 0018:ffff8880a0fb7008 EFLAGS: 00010a02
> RAX: dffffc0000000000 RBX: ffff11013ac65040 RCX: 1ffffffff10dce0c
> RDX: 1fffe2202758ca0b RSI: ffffffff83344b4c RDI: ffff11013ac65058
> RBP: ffff8880a0fb7068 R08: ffff888059df8140 R09: ffffed1015d06be0
> R10: ffffed1015d06bdf R11: ffff8880ae835efb R12: 00000000000000fc
> R13: ffff88806bbfec40 R14: ffff88806a6a3714 R15: ffff8880a097a8c0
> FS:  00007fcf84ffc700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffde202758ca0b CR3: 00000000970bb000 CR4: 00000000001406f0
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000f10885058873bf83%40google.com.
> For more options, visit https://groups.google.com/d/optout.
