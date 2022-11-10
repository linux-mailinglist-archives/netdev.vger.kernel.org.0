Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5CC624904
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 19:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiKJSEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 13:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiKJSE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 13:04:26 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF641262C
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:04:24 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 73B2C5C0176;
        Thu, 10 Nov 2022 13:04:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 10 Nov 2022 13:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668103461; x=1668189861; bh=WA1sq4CfcZkPRhuimpm9jgjzigIW
        mcE4loajhOLSN3Y=; b=b5vc1fZBxobAPY1rsrs4anmVHP60Ql+ElGyoZJrT+3Y1
        gXK6eDhDxSZ22bABN4neWnfS9u0SPoNEiv9+vtqKlXRzYXsZIJ5LkOVIu6fzp4OL
        rw4rkT+MDYCOY9an+tLF5hIgg9MesNbQoLJrvNJDHL75EUScJK8CRoxXPryj6IVn
        nayj5NkzRl7c7Q21goK4K4/AyG2119Em0A0ZnVtVQpQRoC0i/q8aStsy2Vn+C/k2
        OWGygTErherZXgg7lwOztMjImnNZQqtSFnLx6co6JJXqqng2hNOTmyB7+1mErPKz
        DPv9FYq01yx+P/tNQ+bg3q8q9CQvh9GgK9bpuh23tQ==
X-ME-Sender: <xms:Iz1tY9ZlibNE9hRRPY0hswbtYH1UZD5aPPPzFc6Tl1wYMH0lSQcKcg>
    <xme:Iz1tY0a8PKBd0igZ20ygSntwi2Icj_bYVkE6BZrfz3zqyGtvpfn69bHGRh8aC9OBn
    RVt_2gMMipArHg>
X-ME-Received: <xmr:Iz1tY_9l6wYDyN6QA129gZGg1TAlRGhqO8thXEsLNzbn9XJVEpRUQRKyMC9UXxdJSuy9UKOY12WdbN-3IXSaBx1Kvhc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeeggddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Iz1tY7rz1N2pcnKCVpDh97lpxGVOCcyfU_CXNtnvHcprNAsnxzwqXA>
    <xmx:Iz1tY4qmYP5Yo9CR7aoYITNzsalzqd3Sy1uJO6jvsl9sotQKM91QQw>
    <xmx:Iz1tYxSB5diR2HqsxkJw2PXn4HxBXBa0lxic6xwWgcJGPL2nW3dlkA>
    <xmx:JT1tYwLkBatc4NITwVCGfnrTbbXVeIEEYAGsYemHXt-HiBpHMK_zyw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Nov 2022 13:04:17 -0500 (EST)
Date:   Thu, 10 Nov 2022 20:04:13 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check
 return value of unregister_netdevice_notifier_net() call
Message-ID: <Y209Hb95UX3Wcb6r@shredder>
References: <20221108132208.938676-1-jiri@resnulli.us>
 <20221108132208.938676-4-jiri@resnulli.us>
 <Y2uT1AZHtL4XJ20E@shredder>
 <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
 <20221109134536.447890fb@kernel.org>
 <Y2yuK8kccunmEiYd@nanopsycho>
 <CANn89iLhbTB8kZwE7BhK76ZsLmm5aKv78q+1QYcbs7gDFCU6iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLhbTB8kZwE7BhK76ZsLmm5aKv78q+1QYcbs7gDFCU6iA@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:21:23AM -0800, Eric Dumazet wrote:
> On Wed, Nov 9, 2022 at 11:54 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Wed, Nov 09, 2022 at 10:45:36PM CET, kuba@kernel.org wrote:
> > >On Wed, 9 Nov 2022 08:26:10 -0800 Eric Dumazet wrote:
> > >> > On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:
> > >> > > From: Jiri Pirko <jiri@nvidia.com>
> > >> > >
> > >> > > As the return value is not 0 only in case there is no such notifier
> > >> > > block registered, add a WARN_ON() to yell about it.
> > >> > >
> > >> > > Suggested-by: Ido Schimmel <idosch@idosch.org>
> > >> > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> > >> >
> > >> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > >>
> > >> Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()
> > >
> > >Do you have any general guidance on when to pick WARN() vs WARN_ONCE()?
> > >Or should we always prefer _ONCE() going forward?
> >
> > Good question. If so, it should be documented or spotted by checkpatch.
> >
> > >
> > >Let me take the first 2 in, to lower the syzbot volume.
> 
> Well, I am not sure what you call 'lower syzbot volume'
> 
> netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2
> family 0 port 6081 - 0
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 41 at net/core/devlink.c:10001
> devl_port_unregister+0x2f6/0x390 net/core/devlink.c:10001

Hi Eric,

That's a different bug than the one fixed by this patchset. Should be
fixed by this patch:

https://patchwork.kernel.org/project/netdevbpf/patch/20221110085150.520800-1-idosch@nvidia.com/

> Modules linked in:
> CPU: 0 PID: 41 Comm: kworker/u4:2 Not tainted
> 6.1.0-rc3-syzkaller-00887-g0c9ef08a4d0f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 10/26/2022
> Workqueue: netns cleanup_net
> RIP: 0010:devl_port_unregister+0x2f6/0x390 net/core/devlink.c:10001
> Code: e8 3f 37 0b fa 85 ed 0f 85 7a fd ff ff e8 62 3a 0b fa 0f 0b e9
> 6e fd ff ff e8 56 3a 0b fa 0f 0b e9 53 ff ff ff e8 4a 3a 0b fa <0f> 0b
> e9 94 fd ff ff e8 ae ac 57 fa e9 78 ff ff ff e8 74 ac 57 fa
> RSP: 0018:ffffc90000b27a08 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88806ee3f810 RCX: 0000000000000000
> RDX: ffff8880175e1d40 RSI: ffffffff877177d6 RDI: 0000000000000005
> RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000000 R12: ffff88806ee3f810
> R13: ffff88806ee3f808 R14: ffff88806ee3e800 R15: ffff88806ee3f800
> FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c00023dee0 CR3: 0000000074faf000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> __nsim_dev_port_del+0x1bb/0x240 drivers/net/netdevsim/dev.c:1433
> nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1443 [inline]
> nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1660
> nsim_dev_reload_down+0x6b/0xd0 drivers/net/netdevsim/dev.c:968
> devlink_reload+0x1c4/0x6e0 net/core/devlink.c:4501
> devlink_pernet_pre_exit+0x104/0x1c0 net/core/devlink.c:12615
> ops_pre_exit_list net/core/net_namespace.c:159 [inline]
> cleanup_net+0x451/0xb10 net/core/net_namespace.c:594
> process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
> worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> kthread+0x2e4/0x3a0 kernel/kthread.c:376
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> </TASK>
