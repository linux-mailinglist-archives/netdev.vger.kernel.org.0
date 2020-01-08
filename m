Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E798133E04
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgAHJOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:14:14 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:56521 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbgAHJON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 04:14:13 -0500
Received: by mail-il1-f197.google.com with SMTP id i68so1617218ill.23
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 01:14:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hSRS9RfwObBsbx/Nc6C6teGoTik7hL43psKyWtf/A/M=;
        b=Ni212U8Hn1+cTMlmEGs4px2CQjU1PM0G5TDpRSzm3fNFTdFWF7naJXbX77ooavHDNv
         VP6JELd2XGvHCK79cuiLD5wf5xvzKNOXsW59eBR8mWcIsso119cshNKfYC6XQ+kgeKrj
         I4ykE4TLG6JMyZV+43SLAqFX68+JQmSQ/UyyUpK40NgEjMohp/ZDYA3Nz0cbRf9jV8VD
         bO/n0cRBpXVXiAbXB62GzDkVoryqKqywa5H96Qd3EG4Z8enS1Ioq94j4xY2sF5CfnEIP
         oyxTp9na3ysxTol0TuG2dX6P/rG6kZ4VeFcLD9wkKtmrUONzzI1zGW26s0GJ4dT8o4Zf
         zvJw==
X-Gm-Message-State: APjAAAUgP+vrZAQAY0rZE3vV7ZpS+BF8W0B/4aZOWqM+oYj3fq91XJU3
        3zPYH4iboFaMaUyIvPIGuKJGoJ5Ea8y1cQR32hxPOOWzsZ2C
X-Google-Smtp-Source: APXvYqziCKc8rF9f1jQoBPqDjlag/xvMb7rqSmht/vD5K9aTc2JbRGKk1AOPxskMXaJiwUbd45Er269r9UMu84zEjO43FCAQjDto
MIME-Version: 1.0
X-Received: by 2002:a92:860a:: with SMTP id g10mr2926695ild.280.1578474853067;
 Wed, 08 Jan 2020 01:14:13 -0800 (PST)
Date:   Wed, 08 Jan 2020 01:14:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e77578059b9d5096@google.com>
Subject: general protection fault in hash_ipport4_uadt
From:   syzbot <syzbot+f35ea63f7eb0be42fa5d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c8c29ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=f35ea63f7eb0be42fa5d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1195293ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f35ea63f7eb0be42fa5d@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9567 Comm: syz-executor.0 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_ipport4_uadt+0x1f6/0xc20  
net/netfilter/ipset/ip_set_hash_ipport.c:116
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 45 09 00 00 4c 89  
ea 45 8b 76 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e7
RSP: 0018:ffffc90002037170 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90002037320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867c0973 RDI: ffff8880978a4444
RBP: ffffc900020372b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffffc90002037220
R13: 0000000000000000 R14: 0000000001040000 R15: ffff8880a01ed200
FS:  00007fb62049b700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000a219b000 CR4: 00000000001406f0
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
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb62049ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 000000000000000a
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb62049b6d4
R13: 00000000004c9e62 R14: 00000000004e2e98 R15: 00000000ffffffff
Modules linked in:
---[ end trace 6310016b54e639bc ]---
RIP: 0010:hash_ipport4_uadt+0x1f6/0xc20  
net/netfilter/ipset/ip_set_hash_ipport.c:116
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 45 09 00 00 4c 89  
ea 45 8b 76 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e7
RSP: 0018:ffffc90002037170 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90002037320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867c0973 RDI: ffff8880978a4444
RBP: ffffc900020372b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffffc90002037220
R13: 0000000000000000 R14: 0000000001040000 R15: ffff8880a01ed200
FS:  00007fb62049b700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000a219b000 CR4: 00000000001406f0
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
