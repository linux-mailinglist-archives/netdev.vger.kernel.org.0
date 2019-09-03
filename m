Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF43A7314
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 21:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfICTEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 15:04:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:55848 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfICTEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 15:04:08 -0400
Received: by mail-io1-f71.google.com with SMTP id i2so18535533iof.22
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 12:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TPPI8uzxfemj54xhPdOJju3aa7ss5FUtkcHUb6BoR5g=;
        b=biSkjZTVCv7nEZmb2ask9arOVTxBnXoDEMD8IG7mJyxnWt9V+uxVyaEQDGCximacB/
         rbvqidaBdizkHpT0NT2n+WS2Ch8b2XX4BQ/B9mJwRWq3Y4uEbN86OWWKqJt2NuekA0kH
         6zVW4BcxnubchEKICTIq5mw7aGgWqq1Q9ujBcfnylAO16LaVzantxcomf7m7mfEVaZRr
         d/y4nSNMiJsuoNvIPf3ulYUZtrZw8hYBbQeFxjXaQQUVfrYaKEaHlYZ2oNdyYK09bKTk
         fdgyeld3EHHI4f+7pcC4uj1xl39nv40SoJrgWDofraTF70EBir146eOWeidHHNyZ8Utw
         NDvQ==
X-Gm-Message-State: APjAAAVcl4KH50LZYUoMNU4aRlYRfr5nchkV5/alBqU4CX/pZhrKC5Aw
        VuwLjfN3guL851c0zfBOjJ+whs40omKJyrVSpSl4xj1wBZN7
X-Google-Smtp-Source: APXvYqy4Oe5AV49BontGUt2McZhESvRFkp20PxUTCbHCwzhDtyZXmAkHPkferiQ/WABtK4irg8K6+vR32uYxX/iodf8rHL9oMUFt
MIME-Version: 1.0
X-Received: by 2002:a6b:7503:: with SMTP id l3mr14088423ioh.244.1567537447420;
 Tue, 03 Sep 2019 12:04:07 -0700 (PDT)
Date:   Tue, 03 Sep 2019 12:04:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9cc9f0591aac06d@google.com>
Subject: BUG: using smp_processor_id() in preemptible [ADDR] code: mime_typevmnet0/NUM
From:   syzbot <syzbot+55acd54b57bb4b3840a4@syzkaller.appspotmail.com>
To:     allison@lohutok.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    eea17309 Merge branch 'i2c/for-current' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b0622a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5cbaa3be0b36022f
dashboard link: https://syzkaller.appspot.com/bug?extid=55acd54b57bb4b3840a4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+55acd54b57bb4b3840a4@syzkaller.appspotmail.com

Started in network mode
Own node identity ff030000000000000000000000000001, cluster identity 4711
BUG: using smp_processor_id() in preemptible [00000000] code:  
mime_typevmnet0/24282
caller is dst_cache_get+0x3d/0xb0 net/core/dst_cache.c:68
CPU: 0 PID: 24282 Comm: mime_typevmnet0 Not tainted 5.3.0-rc6+ #148
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
  debug_smp_processor_id.cold+0x87/0x9d lib/smp_processor_id.c:57
  dst_cache_get+0x3d/0xb0 net/core/dst_cache.c:68
  tipc_udp_xmit.isra.0+0xc4/0xb80 net/tipc/udp_media.c:164
  tipc_udp_send_msg+0x3ea/0x490 net/tipc/udp_media.c:241
  tipc_bearer_xmit_skb+0x17e/0x370 net/tipc/bearer.c:503
  tipc_enable_bearer+0xacf/0xd30 net/tipc/bearer.c:328
  __tipc_nl_bearer_enable+0x2de/0x3a0 net/tipc/bearer.c:899
  tipc_nl_bearer_enable+0x23/0x40 net/tipc/bearer.c:907
  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
  genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459879
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe5fe7f1c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459879
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe5fe7f26d4
R13: 00000000004c753c R14: 00000000004dcce8 R15: 00000000ffffffff
Enabled bearer <udp:syz0>, priority 8


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
