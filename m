Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F24D3A05B
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfFHPDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:03:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44190 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfFHPDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 11:03:06 -0400
Received: by mail-io1-f71.google.com with SMTP id i133so3985429ioa.11
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 08:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0KdeUb+UfEQdipefR6pVhLY33O2S8gQ7FzwbqhitJwQ=;
        b=ZGzMmVeQDKYF0ah7mhA6yzif2XjI6w26Jyb4ZxVz3qiMu8CY5/6eIlVv6aeKGbFt8f
         h3Wxj7zB6uufaRsEUOnTQ3BCLwVIiJ7TKcAFAQk05ousc1HQ/QieylxYFQSPfQMIVxQe
         qVwK7lf21I9xuiH379kwVQ9zeu5/ZKTevkLXu7+z8aH3Ej4RGNRs7ekKt/y2e/bIDa5T
         DMpjTaz6QQBAaN+ZbUZ2A7sRtRn6IQK4PLJXqJ6IfZqXbqzLYaXqg/pRhCnR8+Vq5Y1Q
         wtQW1wWw5UHKrW+NY4t8s8h1WbcqlCJ/KzeNptXIhnenFevs92tTfu28dTIC957yX0cS
         sVTQ==
X-Gm-Message-State: APjAAAXTvFBVUp8PrRiu7G3quilWCyBVF9AMs7Ca0N4I6ufjDXuyG2eU
        YQcRjl02rwnHsRAdAVSEMyVRsZQnGwc2Uh6EqyxJLBmlKril
X-Google-Smtp-Source: APXvYqx/lCrlsM+jEGz1fCXhrjloO9MrUuiJBEEOaMD6ZjtX2UMhafC4D3ftHHGq6JELJYlkQ5H4wlsegxliTPGnmEFmQ3IQWuAD
MIME-Version: 1.0
X-Received: by 2002:a02:c95a:: with SMTP id u26mr22232424jao.15.1560006185906;
 Sat, 08 Jun 2019 08:03:05 -0700 (PDT)
Date:   Sat, 08 Jun 2019 08:03:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f00f7058ad13ec8@google.com>
Subject: KMSAN: uninit-value in bcmp
From:   syzbot <syzbot+d8b02c920ae8f3e0be75@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        petrm@mellanox.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d062d017 usb-fuzzer: main usb gadget fuzzer driver
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=119daa0ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=67ebf8b3cce62ce7
dashboard link: https://syzkaller.appspot.com/bug?extid=d8b02c920ae8f3e0be75
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14973970a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1349a4e2a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d8b02c920ae8f3e0be75@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KMSAN: uninit-value in memcmp lib/string.c:865 [inline]
BUG: KMSAN: uninit-value in bcmp+0x117/0x180 lib/string.c:887
CPU: 1 PID: 10480 Comm: syz-executor472 Not tainted 5.1.0-rc7+ #5
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:619
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  memcmp lib/string.c:865 [inline]
  bcmp+0x117/0x180 lib/string.c:887
  __hw_addr_del_ex net/core/dev_addr_lists.c:123 [inline]
  __dev_mc_del+0x16c/0x690 net/core/dev_addr_lists.c:810
  dev_mc_del+0x6d/0x80 net/core/dev_addr_lists.c:828
  ip_mc_filter_del net/ipv4/igmp.c:1142 [inline]
  __igmp_group_dropped+0x260/0x1320 net/ipv4/igmp.c:1276
  igmp_group_dropped net/ipv4/igmp.c:1306 [inline]
  ip_mc_down+0x1e7/0x3b0 net/ipv4/igmp.c:1714
  inetdev_event+0x22d/0x1df0 net/ipv4/devinet.c:1534
  notifier_call_chain kernel/notifier.c:93 [inline]
  __raw_notifier_call_chain kernel/notifier.c:394 [inline]
  raw_notifier_call_chain+0x13d/0x240 kernel/notifier.c:401
  call_netdevice_notifiers_info net/core/dev.c:1753 [inline]
  call_netdevice_notifiers_extack net/core/dev.c:1765 [inline]
  call_netdevice_notifiers net/core/dev.c:1779 [inline]
  dev_close_many+0x60d/0x9e0 net/core/dev.c:1522
  rollback_registered_many+0x94a/0x2210 net/core/dev.c:8177
  rollback_registered net/core/dev.c:8242 [inline]
  unregister_netdevice_queue+0x593/0xab0 net/core/dev.c:9289
  unregister_netdevice include/linux/netdevice.h:2658 [inline]
  __tun_detach+0x21be/0x2b10 drivers/net/tun.c:727
  tun_detach drivers/net/tun.c:744 [inline]
  tun_chr_close+0xda/0x1c0 drivers/net/tun.c:3443
  __fput+0x4d1/0xbc0 fs/file_table.c:278
  ____fput+0x37/0x40 fs/file_table.c:309
  task_work_run+0x22e/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop arch/x86/entry/common.c:166 [inline]
  prepare_exit_to_usermode+0x31d/0x420 arch/x86/entry/common.c:197
  syscall_return_slowpath+0x90/0x5c0 arch/x86/entry/common.c:268
  do_syscall_64+0xe2/0xf0 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x400f00
Code: 01 f0 ff ff 0f 83 20 0c 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d cd 17 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 f4 0b 00 00 c3 48 83 ec 08 e8 5a 01 00 00
RSP: 002b:00007fff995e0ec8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000400f00
RDX: 0000000020000c40 RSI: 0000000000008914 RDI: 0000000000000004
RBP: 00000000004a2470 R08: 0000000000000100 R09: 0000000000000100
R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000401f80
R13: 0000000000402010 R14: 0000000000000000 R15: 0000000000000000

Local variable description: ----buf.i@__igmp_group_dropped
Variable was created at:
  ip_mc_filter_del net/ipv4/igmp.c:1139 [inline]
  __igmp_group_dropped+0x170/0x1320 net/ipv4/igmp.c:1276
  igmp_group_dropped net/ipv4/igmp.c:1306 [inline]
  ip_mc_down+0x1e7/0x3b0 net/ipv4/igmp.c:1714
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
