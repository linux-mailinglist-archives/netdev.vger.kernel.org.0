Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BE030307A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732714AbhAYXsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:48:23 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:37630 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbhAYVOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:14:54 -0500
Received: by mail-io1-f72.google.com with SMTP id d15so16898649ioh.4
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:14:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5two7q/jQViPfMzjfYYBiWhjgEhntyhQrt/LvBiQkQk=;
        b=EOOTEi/giJGKNipaNKT4Yj0IiB0Yv2v8dQylzATvnlQu2NTsEguMwCAoLhblBM4lRM
         cT5SXVfU+Z5+isrOHb/zmwR3muUojToDPORmV9+6/uUPWtxwZcWW9zZaU52XoAHpusbg
         ZfuMIrEODNuiuEmBOzrlHr/zN9yqEIp/JE1QgsTfWZx3ZxN4W3ytpcmkYBMFPU00ZgL/
         +1SnRugWCxFzCXoVnt2vZc5XR+kFWfnC+lNSBHFkc2pPKm1dicFxzpIuWpMHQh78amRV
         X2FvriUJqDfiOfoBVCHD3UflGyizT2ftbO7FOFb8MxYq7oe8ZXDN7obxB5DPw5PVnGPk
         eORQ==
X-Gm-Message-State: AOAM533bio7vrEwb1Cql1bmWdwVQezy2pU8nsJ87VGb+63sIinTPBeVH
        ghKJcL07SPeuRvtH8GqAxjh6CkSCl8STDdqV2tJnrpWkf8J3
X-Google-Smtp-Source: ABdhPJwlNFQz2I94k61tkKqfr745uZD/G0fgwStqqE9WW8YG/sboY77KeUygvfjNF6IenJ8LLnCze65w5v1Te12JARMxmbxghUtm
MIME-Version: 1.0
X-Received: by 2002:a92:96c3:: with SMTP id g186mr2054432ilh.180.1611609253204;
 Mon, 25 Jan 2021 13:14:13 -0800 (PST)
Date:   Mon, 25 Jan 2021 13:14:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000dd83d05b9c005cf@google.com>
Subject: KASAN: global-out-of-bounds Write in record_print_text
From:   syzbot <syzbot+db1faa35484efb6a54ea@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, john.fastabend@gmail.com,
        john.ogness@linutronix.de, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pmladek@suse.com, rafael@kernel.org, sergey.senozhatsky@gmail.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bc085f8f Add linux-next specific files for 20210121
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17a726a4d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1224bbf217b0bec8
dashboard link: https://syzkaller.appspot.com/bug?extid=db1faa35484efb6a54ea
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1173b294d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1035c13b500000

The issue was bisected to:

commit f0e386ee0c0b71ea6f7238506a4d0965a2dbef11
Author: John Ogness <john.ogness@linutronix.de>
Date:   Thu Jan 14 17:04:12 2021 +0000

    printk: fix buffer overflow potential for print_text()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11671b84d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13671b84d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15671b84d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+db1faa35484efb6a54ea@syzkaller.appspotmail.com
Fixes: f0e386ee0c0b ("printk: fix buffer overflow potential for print_text()")

netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
==================================================================
BUG: KASAN: global-out-of-bounds in record_print_text+0x33f/0x380 kernel/printk/printk.c:1401
Write of size 1 at addr ffffffff8f09f144 by task kworker/u4:0/9

CPU: 1 PID: 9 Comm: kworker/u4:0 Not tainted 5.11.0-rc4-next-20210121-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:397 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:414
 record_print_text+0x33f/0x380 kernel/printk/printk.c:1401
 console_unlock+0x318/0xbb0 kernel/printk/printk.c:2555
 vprintk_emit+0x189/0x490 kernel/printk/printk.c:2092
 dev_vprintk_emit+0x36e/0x3b2 drivers/base/core.c:4358
 dev_printk_emit+0xba/0xf1 drivers/base/core.c:4369
 __netdev_printk+0x1c6/0x27a net/core/dev.c:11073
 netdev_info+0xd7/0x109 net/core/dev.c:11128
 nsim_udp_tunnel_unset_port.cold+0x95/0xb8 drivers/net/netdevsim/udp_tunnels.c:64
 udp_tunnel_nic_device_sync_one net/ipv4/udp_tunnel_nic.c:225 [inline]
 udp_tunnel_nic_device_sync_by_port net/ipv4/udp_tunnel_nic.c:246 [inline]
 __udp_tunnel_nic_device_sync.part.0+0xa4c/0xcb0 net/ipv4/udp_tunnel_nic.c:289
 __udp_tunnel_nic_device_sync net/ipv4/udp_tunnel_nic.c:283 [inline]
 udp_tunnel_nic_flush+0x2b4/0x5e0 net/ipv4/udp_tunnel_nic.c:668
 udp_tunnel_nic_unregister net/ipv4/udp_tunnel_nic.c:869 [inline]
 udp_tunnel_nic_netdevice_event+0x65c/0x19a0 net/ipv4/udp_tunnel_nic.c:909
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 rollback_registered_many+0x92e/0x14c0 net/core/dev.c:9513
 rollback_registered net/core/dev.c:9558 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10734
 unregister_netdevice include/linux/netdevice.h:2853 [inline]
 nsim_destroy+0x35/0x70 drivers/net/netdevsim/netdev.c:338
 __nsim_dev_port_del+0x144/0x1e0 drivers/net/netdevsim/dev.c:967
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:980 [inline]
 nsim_dev_reload_destroy+0xff/0x1e0 drivers/net/netdevsim/dev.c:1158
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:725
 devlink_reload+0x15a/0x5e0 net/core/devlink.c:3191
 devlink_pernet_pre_exit+0x154/0x220 net/core/devlink.c:10329
 ops_pre_exit_list net/core/net_namespace.c:177 [inline]
 cleanup_net+0x451/0xb10 net/core/net_namespace.c:592
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the variable:
 dmesg_restrict+0x24/0x40

Memory state around the buggy address:
 ffffffff8f09f000: f9 f9 f9 f9 01 f9 f9 f9 f9 f9 f9 f9 00 f9 f9 f9
 ffffffff8f09f080: f9 f9 f9 f9 01 f9 f9 f9 f9 f9 f9 f9 00 f9 f9 f9
>ffffffff8f09f100: f9 f9 f9 f9 04 f9 f9 f9 f9 f9 f9 f9 00 00 00 00
                                           ^
 ffffffff8f09f180: 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 00 00 00 00
 ffffffff8f09f200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
