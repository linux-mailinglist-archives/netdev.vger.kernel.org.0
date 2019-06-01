Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A38A319CE
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 08:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfFAGFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 02:05:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39830 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFAGFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 02:05:07 -0400
Received: by mail-io1-f69.google.com with SMTP id y13so7027227iol.6
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 23:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SXQQgqF/aSIlu13g8xFuBn/XDNM3CAXOv6SxuCbdpBU=;
        b=hmOx1wrw8SVdkYPMHDqoXX2OR0HIdJAOJfWzF43PxhcJHD1WTGcSfPCQ7MQh0+Brxt
         SrY6AARC/uRuJq9T4cuI2nhI4433hkPVHKzlXSLFyvB1J443+ih0+Zh/eP9dqwk/yS77
         /RsIFnK0Z+WXXfr6BQwl20J0EsQds98olTnjRQaXjHJXbYFSsyz9zf8sv7zdKnNJLwCl
         mjBOV6r7ycaRBopKZd2IxH6p8NdwtZHOuQzPJPwp5YQiSg7Ht1flYne3+4pZdJFtrRAU
         TJrlOBGrgH5AaKkEJc1uIa3coHYGEBpDaqqky/ZKYM2Llh7+ohMlbwH8uWfZkVXBNPao
         KBMA==
X-Gm-Message-State: APjAAAUddUT4T8LUlbDbIefUXaneyw4+DhvawEGlIZGnws5eLGLSfus/
        ZiOL7tPCnfOTAnOISXZhp6XaSIhiVF/U1+52+eo9jz4IX6yQ
X-Google-Smtp-Source: APXvYqy6SJ2GKwtVJS0kjybBhfdm82xPT/g8i/MTallIrAo4/fTzzlvirlc4bwrV4u3K5xmvtDvFmn5/JbicVHli2qPw2IAPBQHC
MIME-Version: 1.0
X-Received: by 2002:a02:c7c9:: with SMTP id s9mr9197824jao.82.1559369106485;
 Fri, 31 May 2019 23:05:06 -0700 (PDT)
Date:   Fri, 31 May 2019 23:05:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa7a27058a3ce9aa@google.com>
Subject: general protection fault in tcp_v6_connect
From:   syzbot <syzbot+5ee26b4e30c45930bd3c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f4aa8012 cxgb4: Make t4_get_tp_e2c_map static
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1662cb12a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d137eb988ffd93c3
dashboard link: https://syzkaller.appspot.com/bug?extid=5ee26b4e30c45930bd3c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5ee26b4e30c45930bd3c@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 17324 Comm: syz-executor.5 Not tainted 5.2.0-rc1+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:194 [inline]
RIP: 0010:rt6_get_cookie include/net/ip6_fib.h:264 [inline]
RIP: 0010:ip6_dst_store include/net/ip6_route.h:213 [inline]
RIP: 0010:tcp_v6_connect+0xfd0/0x20a0 net/ipv6/tcp_ipv6.c:298
Code: 89 e6 e8 83 a2 48 fb 45 84 e4 0f 84 90 09 00 00 e8 35 a1 48 fb 49 8d  
7e 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 57 0e 00 00 4d 8b 66 70 e8 4d 88 35 fb 31 ff 89
RSP: 0018:ffff888066547800 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff888064e839f0 RCX: ffffc90010e49000
RDX: 000000000000002b RSI: ffffffff8628033b RDI: 000000000000015f
RBP: ffff888066547980 R08: ffff8880a9412080 R09: ffffed1015d26be0
R10: ffffed1015d26bdf R11: ffff8880ae935efb R12: 0000000000000001
R13: ffff888064e82f40 R14: 00000000000000ef R15: ffff888066547de8
FS:  00007f43abb71700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc77267668 CR3: 00000000a5071000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __inet_stream_connect+0x834/0xe90 net/ipv4/af_inet.c:659
  tcp_sendmsg_fastopen net/ipv4/tcp.c:1143 [inline]
  tcp_sendmsg_locked+0x2318/0x3920 net/ipv4/tcp.c:1185
  tcp_sendmsg+0x30/0x50 net/ipv4/tcp.c:1419
  inet_sendmsg+0x141/0x5d0 net/ipv4/af_inet.c:802
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  __sys_sendto+0x262/0x380 net/socket.c:1964
  __do_sys_sendto net/socket.c:1976 [inline]
  __se_sys_sendto net/socket.c:1972 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1972
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f43abb70c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459279
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 000000000075c100 R08: 0000000020000380 R09: 000000000000001c
R10: 0000000020000000 R11: 0000000000000246 R12: 00007f43abb716d4
R13: 00000000004c6d9d R14: 00000000004dbc40 R15: 00000000ffffffff
Modules linked in:
---[ end trace c8448517bbb9ef43 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:194 [inline]
RIP: 0010:rt6_get_cookie include/net/ip6_fib.h:264 [inline]
RIP: 0010:ip6_dst_store include/net/ip6_route.h:213 [inline]
RIP: 0010:tcp_v6_connect+0xfd0/0x20a0 net/ipv6/tcp_ipv6.c:298
Code: 89 e6 e8 83 a2 48 fb 45 84 e4 0f 84 90 09 00 00 e8 35 a1 48 fb 49 8d  
7e 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 57 0e 00 00 4d 8b 66 70 e8 4d 88 35 fb 31 ff 89
RSP: 0018:ffff888066547800 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff888064e839f0 RCX: ffffc90010e49000
RDX: 000000000000002b RSI: ffffffff8628033b RDI: 000000000000015f
RBP: ffff888066547980 R08: ffff8880a9412080 R09: ffffed1015d26be0
R10: ffffed1015d26bdf R11: ffff8880ae935efb R12: 0000000000000001
R13: ffff888064e82f40 R14: 00000000000000ef R15: ffff888066547de8
FS:  00007f43abb71700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f86924a7000 CR3: 00000000a5071000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
