Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14B41F960
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 04:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhJBC3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 22:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhJBC3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 22:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DDD7617E1;
        Sat,  2 Oct 2021 02:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633141641;
        bh=i/v52bw905Lf1siKoS70/S2xBhOq5dZCW6/HgWzBgRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DMQ4v2+3Rkjr2SDVF5yHxpXzi/BwjXZM4zM4zswO+fFaYG9I9AsNSFN3U4s6GkMTR
         5gFeVz/pnpuScoolpxF2kEgdGjMGbiP66lONDET12pzhKp1K0ELBIFqPuEPJBYcMJ3
         2YQgtFi+b9IxsxB0ubKQGeLw4KQe2HWZBesGF7NdAxhxLUug6iwIZzPTQW8RFwIGHW
         yihdYVsQWP2c3ehJBe120wqr+swUJRoQcPteVJDw/qF6ZvR8Do3pnJvRayFB9aZzBG
         q4hX2Javi3/fWucNrvsvr1+yHT3Fratr9sLMwKPtNGuxXkRDw00wGyFq3YwRdG3pri
         SF9g7HLTqxbbg==
Date:   Sat, 2 Oct 2021 05:27:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     syzbot <syzbot+e51ead0112c2cb8d1b45@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] net-next test error: WARNING in devlink_nl_region_notify
Message-ID: <YVfDhYFjI+RAIosi@unreal>
References: <00000000000030283d05cd540908@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000030283d05cd540908@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 05:48:18PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7fec4d39198b gve: Use kvcalloc() instead of kvzalloc()
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1302aebb300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
> dashboard link: https://syzkaller.appspot.com/bug?extid=e51ead0112c2cb8d1b45
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e51ead0112c2cb8d1b45@syzkaller.appspotmail.com
> 
> batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
> device hsr_slave_0 entered promiscuous mode
> device hsr_slave_1 entered promiscuous mode
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 6534 at net/core/devlink.c:5158 devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
> Modules linked in:
> CPU: 1 PID: 6534 Comm: syz-executor.0 Not tainted 5.15.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
> Code: 38 41 b8 c0 0c 00 00 31 d2 48 89 ee 4c 89 e7 e8 72 1a 26 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e e9 01 bb 41 fa e8 fc ba 41 fa <0f> 0b e9 f7 fe ff ff e8 f0 ba 41 fa 0f 0b eb da 4c 89 e7 e8 c4 16
> RSP: 0018:ffffc90002b8f658 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88807872b900 RSI: ffffffff87345094 RDI: 0000000000000003
> RBP: ffff888073785e00 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff87344f8a R11: 0000000000000000 R12: ffff888025299000
> R13: 0000000000000000 R14: 000000000000002c R15: ffff888025299070
> FS:  00005555561e0400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f286d3ee000 CR3: 000000006885e000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  devlink_region_create+0x39f/0x4c0 net/core/devlink.c:10327
>  nsim_dev_dummy_region_init drivers/net/netdevsim/dev.c:481 [inline]
>  nsim_dev_probe+0x5f6/0x1150 drivers/net/netdevsim/dev.c:1479
>  call_driver_probe drivers/base/dd.c:517 [inline]
>  really_probe+0x245/0xcc0 drivers/base/dd.c:596
>  __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
>  driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
>  __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
>  bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
>  __device_attach+0x228/0x4a0 drivers/base/dd.c:969
>  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
>  device_add+0xc35/0x21b0 drivers/base/core.c:3359
>  nsim_bus_dev_new drivers/net/netdevsim/bus.c:435 [inline]
>  new_device_store+0x48b/0x770 drivers/net/netdevsim/bus.c:302
>  bus_attr_store+0x72/0xa0 drivers/base/bus.c:122
>  sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
>  kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
>  call_write_iter include/linux/fs.h:2163 [inline]
>  new_sync_write+0x429/0x660 fs/read_write.c:507
>  vfs_write+0x7cf/0xae0 fs/read_write.c:594
>  ksys_write+0x12d/0x250 fs/read_write.c:647
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f2677dce3ef
> Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
> RSP: 002b:00007ffe549b8fe0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2677dce3ef
> RDX: 0000000000000003 RSI: 00007ffe549b9030 RDI: 0000000000000004
> RBP: 0000000000000004 R08: 0000000000000000 R09: 00007ffe549b8f80
> R10: 0000000000000000 R11: 0000000000000293 R12: 00007f2677e75971
> R13: 00007ffe549b9030 R14: 0000000000000000 R15: 00007ffe549b9700
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

#syz fix: devlink: Add missed notifications iterators
