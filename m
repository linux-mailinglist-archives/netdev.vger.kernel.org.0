Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8102F33E24
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfFDFBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:01:06 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36896 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfFDFBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:01:06 -0400
Received: by mail-io1-f69.google.com with SMTP id j18so15576068ioj.4
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:01:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A4yfKrNSVnkTK0Cf/TTluXfNnZtEW8Q1ZWKjTfgslK8=;
        b=Owub37DdY9K1V2g3ZoFLYswjgIn4TrbSmxnJyKBJUJDm3rM3srdA8IWWbE3XD+nuPL
         wukP8Io2Z3lSw2eHpj2DfQ9HQlXudiuyjoieUNPDQpMwdhW2TEbHKwLgMA1KPctKG+rz
         DHrVWnPxejT+JGuE6eKmIjg5nXmUUwRFIjlFcMhrA6aRdJL7mYhTX/YhSq7+Mtn+fS0V
         aSGzvGTtNbeyEtsDahddCAvNXC00YuuQpF35PJP3RrzB9cw4TKrnAj3q4iQ+xx4soVjW
         qth3qnD12HIlROeTTxX4DL4lQyO9RArw4Bsxlah70Zl+rv4HfnIXUw5FmhboKgFtshnY
         GkjA==
X-Gm-Message-State: APjAAAX4htCbUW3tBF2TYZMxvJ+BUk21iat9V68hkvMej4RG+lmCFtsx
        a8BmhlbTwGSCMKoev9KvtvnCrAD+13l/PJq057nDC6MluKhZ
X-Google-Smtp-Source: APXvYqxvBtoBnpGZ176bCjqPOCoQQLbnMDyZv7dGlOFR9r0pi0+wg0kLQgXx5LvYnz50XFrPpJNtK2NuJD4frwys3GDrSWAQc0eR
MIME-Version: 1.0
X-Received: by 2002:a24:da83:: with SMTP id z125mr8336026itg.126.1559624465476;
 Mon, 03 Jun 2019 22:01:05 -0700 (PDT)
Date:   Mon, 03 Jun 2019 22:01:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f73d9058a785eec@google.com>
Subject: KASAN: user-memory-access Write in fib6_purge_rt (2)
From:   syzbot <syzbot+420d3f70afb5d69d5a96@syzkaller.appspotmail.com>
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

HEAD commit:    58e8b370 Merge branch 'net-phy-dp83867-add-some-fixes'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17bb8b9aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=420d3f70afb5d69d5a96
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+420d3f70afb5d69d5a96@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: user-memory-access in fib6_drop_pcpu_from  
net/ipv6/ip6_fib.c:925 [inline]
BUG: KASAN: user-memory-access in fib6_purge_rt+0x1b3/0x5e0  
net/ipv6/ip6_fib.c:937
Write of size 8 at addr 000000000000ebb4 by task syz-executor.3/14149

CPU: 0 PID: 14149 Comm: syz-executor.3 Not tainted 5.2.0-rc1+ #33
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  __kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
  kasan_check_write+0x14/0x20 mm/kasan/common.c:100
  fib6_drop_pcpu_from net/ipv6/ip6_fib.c:925 [inline]
  fib6_purge_rt+0x1b3/0x5e0 net/ipv6/ip6_fib.c:937
  fib6_del_route net/ipv6/ip6_fib.c:1812 [inline]
  fib6_del+0xac2/0x10a0 net/ipv6/ip6_fib.c:1843
  fib6_clean_node+0x3a5/0x590 net/ipv6/ip6_fib.c:2005
  fib6_walk_continue+0x4a9/0x8e0 net/ipv6/ip6_fib.c:1927
  fib6_walk+0x9d/0x100 net/ipv6/ip6_fib.c:1975
  fib6_clean_tree+0xe0/0x120 net/ipv6/ip6_fib.c:2054
  __fib6_clean_all+0x118/0x2a0 net/ipv6/ip6_fib.c:2070
  fib6_clean_all+0x2b/0x40 net/ipv6/ip6_fib.c:2081
  rt6_sync_down_dev+0x134/0x150 net/ipv6/route.c:4169
  rt6_disable_ip+0x27/0x5f0 net/ipv6/route.c:4174
  addrconf_ifdown+0xa2/0x1220 net/ipv6/addrconf.c:3709
  addrconf_notify+0x5db/0x2270 net/ipv6/addrconf.c:3634
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
  call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1753
  call_netdevice_notifiers_extack net/core/dev.c:1765 [inline]
  call_netdevice_notifiers net/core/dev.c:1779 [inline]
  __dev_notify_flags+0x1e9/0x2c0 net/core/dev.c:7628
  dev_change_flags+0x10d/0x170 net/core/dev.c:7664
  devinet_ioctl+0x138a/0x1c50 net/ipv4/devinet.c:1104
  inet_ioctl+0x1f4/0x340 net/ipv4/af_inet.c:952
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
RSP: 002b:00007f79b318dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000020000080 RSI: 0000000000008914 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f79b318e6d4
R13: 00000000004c4c76 R14: 00000000004d89b8 R15: 00000000ffffffff
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
