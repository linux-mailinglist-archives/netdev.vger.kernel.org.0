Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC371297DF9
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 20:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763804AbgJXSPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 14:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762940AbgJXSPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 14:15:18 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B58F24650;
        Sat, 24 Oct 2020 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603563317;
        bh=hTHylvJInlhIshidRIoPG6FnbQIEujKIvKVJhi95JTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UH5i3t4LoHB4nVC+RsKRlTvYbef1xoseWjnN9vkblzyIf0rFfWSLVUwgHDwDiKrmq
         gNKd4NlJX4eFnBbMWeQGkVWhz4dAFvOSltEA706hvy1PpOlpp2t7/R6T5hgjilXqFL
         VRV15DjWafg/19Ib6CrJnRC0n8lgugJYyQdnGeP8=
Date:   Sat, 24 Oct 2020 11:15:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com>
Cc:     christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
        hch@lst.de, iommu@lists.linux-foundation.org,
        linaro-mm-sig-owner@lists.linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        netdev@vger.kernel.org, robin.murphy@arm.com,
        sumit.semwal@linaro.org, syzkaller-bugs@googlegroups.com,
        linux-rdma@vger.kernel.org
Subject: Re: WARNING in dma_map_page_attrs
Message-ID: <20201024111516.59abc9ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <000000000000a0f8a305b261fe4a@google.com>
References: <000000000000335adc05b23300f6@google.com>
        <000000000000a0f8a305b261fe4a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: rdma, looks like rdma from the stack trace

On Fri, 23 Oct 2020 20:07:17 -0700 syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    3cb12d27 Merge tag 'net-5.10-rc1' of git://git.kernel.org/..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=13125390500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=46c6fea3eb827ae1
> dashboard link: https://syzkaller.appspot.com/bug?extid=34dc2fea3478e659af01
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16858664500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f402ef900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com
> 
> netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
> infiniband syz2: set active
> infiniband syz2: added macvlan0
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8488 at kernel/dma/mapping.c:149 dma_map_page_attrs+0x493/0x700 kernel/dma/mapping.c:149
> Modules linked in:
> CPU: 1 PID: 8488 Comm: syz-executor144 Not tainted 5.9.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:dma_map_page_attrs+0x493/0x700 kernel/dma/mapping.c:149
> Code: 80 3c 10 00 0f 85 ed 01 00 00 48 8b 1d 86 38 e9 0c e9 2d fc ff ff 48 89 c3 e9 d1 fd ff ff e8 04 11 12 00 0f 0b e8 fd 10 12 00 <0f> 0b 49 c7 c4 ff ff ff ff e9 d5 fd ff ff e8 ea 10 12 00 48 8d 7b
> RSP: 0018:ffffc90000fdec68 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffffff894d1060 RCX: ffffffff815df1e3
> RDX: ffff8880208c1a40 RSI: ffffffff815df5b3 RDI: ffff8880196f8b00
> RBP: ffff88801412d800 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000000 R12: ffffea0000504b40
> R13: ffff8880196f86e8 R14: 00000000000008b8 R15: 0000000000000002
> FS:  0000000001b26880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200002c0 CR3: 0000000022446000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  dma_map_single_attrs include/linux/dma-mapping.h:279 [inline]
>  ib_dma_map_single include/rdma/ib_verbs.h:3967 [inline]
>  ib_mad_post_receive_mads+0x23f/0xd60 drivers/infiniband/core/mad.c:2715
>  ib_mad_port_start drivers/infiniband/core/mad.c:2862 [inline]
>  ib_mad_port_open drivers/infiniband/core/mad.c:3016 [inline]
>  ib_mad_init_device+0x72b/0x1400 drivers/infiniband/core/mad.c:3092
>  add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:680
>  enable_device_and_get+0x1d5/0x3c0 drivers/infiniband/core/device.c:1301
>  ib_register_device drivers/infiniband/core/device.c:1376 [inline]
>  ib_register_device+0x7a7/0xa40 drivers/infiniband/core/device.c:1335
>  rxe_register_device+0x46d/0x570 drivers/infiniband/sw/rxe/rxe_verbs.c:1182
>  rxe_add+0x12fe/0x16d0 drivers/infiniband/sw/rxe/rxe.c:247
>  rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:507
>  rxe_newlink drivers/infiniband/sw/rxe/rxe.c:269 [inline]
>  rxe_newlink+0xb7/0xe0 drivers/infiniband/sw/rxe/rxe.c:250
>  nldev_newlink+0x30e/0x540 drivers/infiniband/core/nldev.c:1555
>  rdma_nl_rcv_msg+0x367/0x690 drivers/infiniband/core/netlink.c:195
>  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>  rdma_nl_rcv+0x2f2/0x440 drivers/infiniband/core/netlink.c:259
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x443699
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 0d fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc067db418 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443699
> RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000003
> RBP: 00007ffc067db420 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc067db430
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> 

