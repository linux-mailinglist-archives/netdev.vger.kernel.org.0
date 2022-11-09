Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9A6227A9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiKIJza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiKIJz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:55:28 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046E21FCEE;
        Wed,  9 Nov 2022 01:55:24 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BDC35C019D;
        Wed,  9 Nov 2022 04:55:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 09 Nov 2022 04:55:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667987724; x=1668074124; bh=FEBUzOlQTISwTrX+YypHXNXKjSCE
        ZdyAuPoqkcPkh54=; b=UQmf8i4/TLQ19RioJjDfzqjUU5C2ErSXIv4WO3Efhy79
        lBQXuoTafkPI+2eHBnqXa8rbslEL0EQ4MRLcrIniLCAYX7JxsoOMV/IMUv8SHKAi
        M9miK8Pu3jSfS8niVQlgnpkz3pTlO2GmRNlbFJaMqAX1y1c+9BUdAt54YbAFhC4X
        kit+K92s84ai0lVAfn5QRCJkOAku8w+ggUr4k2p1/eCmzta+B945dVbTnT9CJevh
        opnvf1xpUyTx3xDs+z/98vTVyEEr+YQi9XJbF9Yl0g9onvZoWBmDz+orvQKMokIp
        dE+nFuNKp4F3UCyKliVQWvz4gCyssxYkBAdbDedOqg==
X-ME-Sender: <xms:C3lrY2oAzYMlfSmJKqpEIIqtQb7EwxCx0aXQyk1jtYdGI6Q2ghprOw>
    <xme:C3lrY0qFVuL7M5iXFiT6Sh6l2tJCS01xmqgnSQtX18eC2gdBq-sHkVnN8fOqzFAST
    2f15OfvOcMg5MM>
X-ME-Received: <xmr:C3lrY7OULx6Z6rdMbg-TzcZRAP1rsNaR7AJRDA8bH04eBrnpKdK7tppXLJQC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedvgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeejgedtjedttdelvdffteeuleekkeejheduheeuffeukefhkeevjeeuheeiueet
    udenucffohhmrghinhepshihiihkrghllhgvrhdrrghpphhsphhothdrtghomhdpghhooh
    hglhgvrghpihhsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:C3lrY16Owi0BV1Az4p4F-dk6koLNQyJK33ocGWfI-X6vEBdkCRAgYw>
    <xmx:C3lrY17WqkZwbMnQRgiSpJMtE5YiUyo6n9Z-hcxgbw8bDhRcyk57FQ>
    <xmx:C3lrY1hW5DY43q2BqCPK3KGwsE3Wdox1P1aIZKKeY6aeyqPBaVS-Yw>
    <xmx:DHlrY_sPCcL6SkJFn9No4c_E89M_E7HXNNpowGpiJugCSbMz1IKDLQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 04:55:23 -0500 (EST)
Date:   Wed, 9 Nov 2022 11:55:20 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     syzbot <syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, jiri@nvidia.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] linux-next test error: WARNING in devl_port_unregister
Message-ID: <Y2t5CKkIVZMD09EA@shredder>
References: <0000000000000c56d205ece61277@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000c56d205ece61277@google.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SORTED_RECIPS,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 11:02:52AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d8e87774068a Add linux-next specific files for 20221107
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17b99fde880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=97401fe9f72601bf
> dashboard link: https://syzkaller.appspot.com/bug?extid=c2ca18f0fccdd1f09c66
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/671a9d3d5dc6/disk-d8e87774.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ef1309efbb19/vmlinux-d8e87774.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7592dabd2a3a/bzImage-d8e87774.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com
> 
> wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 11 at net/core/devlink.c:9998 devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
> Modules linked in:
> CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted 6.1.0-rc3-next-20221107-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: netns cleanup_net
> RIP: 0010:devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
> Code: e8 8f 45 fc f9 85 ed 0f 85 7a fd ff ff e8 b2 48 fc f9 0f 0b e9 6e fd ff ff e8 a6 48 fc f9 0f 0b e9 53 ff ff ff e8 9a 48 fc f9 <0f> 0b e9 94 fd ff ff e8 de f9 48 fa e9 78 ff ff ff e8 a4 f9 48 fa
> RSP: 0018:ffffc90000107a08 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888020492810 RCX: 0000000000000000
> RDX: ffff888011a33a80 RSI: ffffffff87809286 RDI: 0000000000000005
> RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000000 R12: ffff888020492810
> R13: ffff888020492808 R14: ffff888020491800 R15: ffff888020492800
> FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c00213d000 CR3: 000000007318b000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __nsim_dev_port_del+0x1bb/0x240 drivers/net/netdevsim/dev.c:1433
>  nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1443 [inline]
>  nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1660
>  nsim_dev_reload_down+0x6b/0xd0 drivers/net/netdevsim/dev.c:968
>  devlink_reload+0x1c2/0x6b0 net/core/devlink.c:4501
>  devlink_pernet_pre_exit+0x104/0x1c0 net/core/devlink.c:12609
>  ops_pre_exit_list net/core/net_namespace.c:159 [inline]
>  cleanup_net+0x451/0xb10 net/core/net_namespace.c:594
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>  worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>  kthread+0x2e4/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>

Testing the following patch. It fixes a similar issue in our regression.

commit 0cbd9cd1b4dd96f2bd446b47ccef3ece5f24759f
Author: Ido Schimmel <idosch@nvidia.com>
Date:   Wed Nov 9 11:19:55 2022 +0200

    devlink: Fix warning when unregistering a port
    
    When a devlink port is unregistered, its type is expected to be unset or
    otherwise a WARNING is generated [1]. This was supposed to be handled by
    cited commit by clearing the type upon 'NETDEV_PRE_UNINIT'.
    
    The assumption was that no other events can be generated for the netdev
    after this event, but this proved to be wrong. After the event is
    generated, netdev_wait_allrefs_any() will rebroadcast a
    'NETDEV_UNREGISTER' until its reference count drops to 1. This causes
    devlink to set the port type back to Ethernet.
    
    Fix by only setting and clearing the port type upon 'NETDEV_POST_INIT'
    and 'NETDEV_PRE_UNINIT', respectively. For all other events, preserve
    the port type.
    
    [1]
    WARNING: CPU: 0 PID: 11 at net/core/devlink.c:9998 devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
    Modules linked in:
    CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted 6.1.0-rc3-next-20221107-syzkaller #0
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
    Workqueue: netns cleanup_net
    RIP: 0010:devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
    [...]
    Call Trace:
     <TASK>
     __nsim_dev_port_del+0x1bb/0x240 drivers/net/netdevsim/dev.c:1433
     nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1443 [inline]
     nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1660
     nsim_dev_reload_down+0x6b/0xd0 drivers/net/netdevsim/dev.c:968
     devlink_reload+0x1c2/0x6b0 net/core/devlink.c:4501
     devlink_pernet_pre_exit+0x104/0x1c0 net/core/devlink.c:12609
     ops_pre_exit_list net/core/net_namespace.c:159 [inline]
     cleanup_net+0x451/0xb10 net/core/net_namespace.c:594
     process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
     worker_thread+0x665/0x1080 kernel/workqueue.c:2436
     kthread+0x2e4/0x3a0 kernel/kthread.c:376
     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
     </TASK>
    
    Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
    Reported-by: syzbot+85e47e1a08b3e159b159@syzkaller.appspotmail.com
    Reported-by: syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com
    Signed-off-by: Ido Schimmel <idosch@nvidia.com>

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6bbe230c4ec5..7f789bbcbbd7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10177,7 +10177,7 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		 * we take into account netdev pointer appearing in this
 		 * namespace.
 		 */
-		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+		__devlink_port_type_set(devlink_port, devlink_port->type,
 					netdev);
 		break;
 	case NETDEV_UNREGISTER:
@@ -10185,7 +10185,7 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		 * also during net namespace change so we need to clear
 		 * pointer to netdev that is going to another net namespace.
 		 */
-		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+		__devlink_port_type_set(devlink_port, devlink_port->type,
 					NULL);
 		break;
 	case NETDEV_PRE_UNINIT:
