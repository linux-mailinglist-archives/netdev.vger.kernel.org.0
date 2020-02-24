Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6316A02D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgBXIiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:38:22 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:42491 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgBXIiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:38:15 -0500
Received: by mail-il1-f200.google.com with SMTP id s13so17093591ili.9
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:38:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3WkGp776rjNoea1vK9yfhMXoCBX1yurWcAfuIjmGFOk=;
        b=CSIguOPbwpeTrvPrJvF+2S/0uVXGKh0ot3/x/wj9Cp5T98S9P8atF7zAzwF/7of3CG
         jwkfLXKaopkeiMPAQI1ejW4+Dd6rIP5vWXLVdbASdrvynSkTNncIC6qrGq+aIYew5lS0
         +xLJG9dAn4B2CufcT2OQB6sSJGQyZtJ5wOQn6aK8F3fjqk38JFrLXo6Cwx3MIVeSZU+i
         QeZehM9SmmqRPe9wxMoidd7JlDId9Lsy7pN0p+1U+U5O59mJ+51mA86zhcXsoRaSeAMB
         ZTPBYIdc30pHdwwk+8Ec8WSJ1qWgsRxmyjT56HkmNp5e9kA5cFH6uw+y4AYkO3xFcMmX
         bCkg==
X-Gm-Message-State: APjAAAXJMrazlar1Pe8YuERb58NNQ1xovXKYjJYkc7tvr7ZsFng8X2nI
        mdK9CxcJ9wRPR9pIylVgJhI863272QlOOOaaWltj/5lA0LG+
X-Google-Smtp-Source: APXvYqyaStUMB+rYBCxbRCOneJhwVYiXFUGqwOrOtAbLfzdoyzK4EssBfdxqQV2ZAlL4ncJzam/8XdcTCdGoW8l19i/qOX7yx5WE
MIME-Version: 1.0
X-Received: by 2002:a92:dac3:: with SMTP id o3mr59526952ilq.237.1582533493502;
 Mon, 24 Feb 2020 00:38:13 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:38:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9b7d4059f4e4ac7@google.com>
Subject: general protection fault in rds_ib_add_one
From:   syzbot <syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b0dd1eb2 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13db9de9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6001be4097ab13c
dashboard link: https://syzkaller.appspot.com/bug?extid=274094e62023782eeb17
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ad6a7ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13da7a29e00000

Bisection is inconclusive: the first bad commit could be any of:

20cf4e02 rdma: Enable ib_alloc_cq to spread work over a device's comp_vectors
31d0e6c1 mlx5: Fix formats with line continuation whitespace
7a63b31e RDMA/hns: Remove not used UAR assignment
05bb411a RDMA/core: Introduce ratelimited ibdev printk functions
b2567ebb RDMA/hns: remove set but not used variable 'irq_num'
cfa1f5f2 RDMA/efa: Rate limit admin queue error prints
d129e3f4 RDMA/mlx5: Remove DEBUG ODP code
1dc55892 RDMA/core: fix spelling mistake "Nelink" -> "Netlink"
72a7720f RDMA: Introduce ib_port_phys_state enum
691f380d RDMA/cxgb3: Use ib_device_set_netdev()
cb560f5f infiniband: Remove dev_err() usage after platform_get_irq()
16e9111e RDMA/efa: Expose device statistics
4929116b RDMA/core: Add common iWARP query port
bda9045a IB/bnxt_re: Do not notifify GID change event
d8d5cfac RDMA/{cxgb3, cxgb4, i40iw}: Remove common code
525a2c65 Merge branch 'wip/dl-for-rc' into wip/dl-for-next
a3e2d4c7 RDMA/hns: remove obsolete Kconfig comment
3e1f000f IB/mlx5: Support per device q counters in switchdev mode
cc95b23c RDMA/hns: Encapsulate some lines for setting sq size in user mode
5dcecbc9 IB/mlx5: Refactor code for counters allocation
8ea417ff RDMA/hns: Optimize hns_roce_modify_qp function
0058eb58 qed*: Change dpi_addr to be denoted with __iomem
ece9c205 RDMA/hns: Update the prompt message for creating and destroy qp
2288b3b3 RDMA/hns: Remove unnessary init for cmq reg
8b38c538 IB/mlx5: Add CREATE_PSV/DESTROY_PSV for devx interface
1d2fedd8 RDMA/core: Support netlink commands in non init_net net namespaces
b5c229dc RDMA/hns: Clean up unnecessary initial assignment
6def7de6 RDMA/hns: Update some comments style
913df8c3 RDMA/mlx4: Annotate boolean arguments as bool and not int
089b645d RDMA/mlx4: Separate creation of RWQ and QP
0e20ebf8 RDMA/hns: Handling the error return value of hem function
4f96061b IB/usnic: Use dev_get_drvdata
e7f40440 RDMA/hns: Split bool statement and assign statement
39289bfc RDMA: Make most headers compile stand alone
bebdb83f RDMA/hns: Refactor irq request code
4b42d05d RDMA/hns: Remove unnecessary kzalloc
cf167e5e RDMA/qedr: Remove Unneeded variable rc
260c3b34 RDMA/hns: Refactor hns_roce_v2_set_hem for hip08
4cc315c5 RDMA/qib: Unneeded variable ret
249f2f92 RDMA/hns: Remove redundant print in hns_roce_v2_ceq_int()
33db6f94 RDMA/hns: Refactor eq table init for hip08
d7019c0f RDMA/hns: Refactor hem table mhop check and calculation
d967e262 RDMA/hns: Disable alw_lcl_lpbk of SSU
3ee0e170 RDMA/hns: Package for hns_roce_rereg_user_mr function
db50077b RDMA/hns: Use the new APIs for printing log
749b9eef Merge remote-tracking branch 'mlx5-next/mlx5-next' into wip/dl-for-next
89b4b70b RDMA/hns: Optimize hns_roce_mhop_alloc function.
972d7560 IB/mlx5: Add legacy events to DEVX list
99441ab5 RDMA/hns: optimize the duplicated code for qpc setting flow
8293a598 IB/mlx5: Expose XRQ legacy commands over the DEVX interface
947441ea RDMA/hns: Use a separated function for setting extend sge paramters
606bf89e RDMA/hns: Refactor for hns_roce_v2_modify_qp function
9dc4cfff RDMA/mlx5: Annotate lock dependency in bind/unbind slave port
0e1aa6f0 RDMA/hns: Logic optimization of wc_flags
2a2f1887 RDMA/hns: Refactor the code of creating srq
4f8f0d5e RDMA/hns: Package the flow of creating cq
76827087 RDMA/hns: Bugfix for creating qp attached to srq
a5c9c299 IB/mlx5: Avoid unnecessary typecast
d7e5ca88 RDMA/hns: Modify pi vlaue when cq overflows
56594ae1 RDMA/core: Annotate destroy of mutex to ensure that it is released as unlocked
9bba3f0c RDMA/hns: Bugfix for slab-out-of-bounds when unloading hip08 driver
a511f822 RDMA/hns: Fix comparison of unsigned long variable 'end' with less than zero
bf8c02f9 RDMA/hns: bugfix for slab-out-of-bounds when loading hip08 driver
77905379 RDMA/hns: Remove unuseful member
ecc53f8a RDMA/mlx4: Untag user pointers in mlx4_get_umem_mr
795130b3 IB/hfi1: Remove unused define
a7325af7 RDMA/hns: Fix some white space check_mtu_validate()
b2299e83 RDMA: Delete DEBUG code
b2590bdd IB/hfi1: Do not update hcrc for a KDETH packet during fault injection
868df536 Merge branch 'odp_fixes' into rdma.git for-next

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1542127ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+274094e62023782eeb17@syzkaller.appspotmail.com

batman_adv: batadv0: Interface activated: batadv_slave_1
infiniband syz1: set active
infiniband syz1: added vlan0
general protection fault, probably for non-canonical address 0xdffffc0000000086: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000430-0x0000000000000437]
CPU: 0 PID: 8852 Comm: syz-executor043 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dev_to_node include/linux/device.h:663 [inline]
RIP: 0010:rds_ib_add_one+0x81/0xe50 net/rds/ib.c:140
Code: b7 a8 06 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 0e e4 1d fa bb 30 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 f0 0a 00 00 8b 1b 48 c7 c0 28 0c 09 89 48
RSP: 0018:ffffc90003087298 EFLAGS: 00010202
RAX: 0000000000000086 RBX: 0000000000000430 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffffc900030872f0 R08: ffffffff87964c3c R09: ffffed1014fd109c
R10: ffffed1014fd109c R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880a7e886a8 R15: ffff8880a7e88000
FS:  0000000000c3d880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0318ed0000 CR3: 00000000a3167000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 add_client_context+0x482/0x660 drivers/infiniband/core/device.c:681
 enable_device_and_get+0x15b/0x370 drivers/infiniband/core/device.c:1316
 ib_register_device+0x124d/0x15b0 drivers/infiniband/core/device.c:1382
 rxe_register_device+0x3f6/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:1231
 rxe_add+0x1373/0x14f0 drivers/infiniband/sw/rxe/rxe.c:302
 rxe_net_add+0x79/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:539
 rxe_newlink+0x31/0x90 drivers/infiniband/sw/rxe/rxe.c:318
 nldev_newlink+0x403/0x4a0 drivers/infiniband/core/nldev.c:1538
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x701/0xa20 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x443499
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdacfaf488 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443499
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00007ffdacfaf4a0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000404a30 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 542f2d063f2edc54 ]---
RIP: 0010:dev_to_node include/linux/device.h:663 [inline]
RIP: 0010:rds_ib_add_one+0x81/0xe50 net/rds/ib.c:140
Code: b7 a8 06 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 0e e4 1d fa bb 30 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 f0 0a 00 00 8b 1b 48 c7 c0 28 0c 09 89 48
RSP: 0018:ffffc90003087298 EFLAGS: 00010202
RAX: 0000000000000086 RBX: 0000000000000430 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffffc900030872f0 R08: ffffffff87964c3c R09: ffffed1014fd109c
R10: ffffed1014fd109c R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880a7e886a8 R15: ffff8880a7e88000
FS:  0000000000c3d880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0318ed0000 CR3: 00000000a3167000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
