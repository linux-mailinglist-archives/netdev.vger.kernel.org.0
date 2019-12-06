Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E1114BC7
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 05:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfLFE6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 23:58:49 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37424 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfLFE6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 23:58:49 -0500
Received: by mail-lj1-f193.google.com with SMTP id u17so6212211lja.4
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 20:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RCKXWAYMi7T/KCr5e/l+vHB/SEuKvUyX32dA7z48pU=;
        b=kpoU7LEYtTzWxg0tkDtr76nbzrCRlDE/9QyYkzJWl/FigILZ7PSTFmfYXMcnKOIXv2
         34EEZhr7PcsFseEoslHJ9i8aGOZ0EZoxQN59yRwHLJfLzfeBJF/r/wTOMUjRviZ/SZiJ
         2B2kTxkfE2SKyuyk4t9scEuVRQYa/nztA0u7HSpG5r9ITI6c1aRCDYvHcQZM36apNHxt
         0HndnzlIVN/D2QtiHCjYfG9SbWWYcHNlO48857SiehpWR26TUcoevEY7jJfrOPAazrkx
         +rNfdWbNlbisR8a3C2wHpLET7V2Coyp2nDUINlmon4MI4WANQTdatUWy2J3le+70VIaM
         PClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RCKXWAYMi7T/KCr5e/l+vHB/SEuKvUyX32dA7z48pU=;
        b=a8Lv1LxyUWPhW2v05YQOR4MEtjisIWjnODkcwcwMz+iSzV7D6wmadCXnjUo/LdNSD4
         T/WtQ8Af5C+zM/Io5mYaq/7xwnEfMwDwkuTIYPr7eT7I36jZXEmqK0afPOWk7qrQFs/N
         HlZKce/Mgc/pBG/Kz/fcin/d8VlCFAvZz8CocXj8wI8iQsCp/vguNDMaEXAxi7VMy29Y
         5iCjgbkmZ814oe2JCavvVYp8giBVJip+fwDny+3e1uW5jky+iHmavVESm9kOsmxR+iOy
         LsfvLlz98WiMZjRIB7SNyWQ8NZ+ZwUi461+bP5/Nxd9AYIx6N7dd7EW/WYRsr7+I85Vw
         jtsQ==
X-Gm-Message-State: APjAAAVmFPm/+P+iRNIJothAwsQp2I8GsDDm+scmg+fWwiOaj1TRk6Jo
        9q5oLwTUrVnkr9zgjqFqxdT4ZjnXy0GBr2QoPkk=
X-Google-Smtp-Source: APXvYqwlWu2MiZUnOp30XBRY8mWe8zjSfjQs1aQoIJhPxOsh4s2vzx0+ZZUcoeKPnp1St7QjpWZ1g2GL1t3hS0iap9E=
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr7631995ljk.201.1575608326299;
 Thu, 05 Dec 2019 20:58:46 -0800 (PST)
MIME-Version: 1.0
References: <20191205163704.11800-1-ap420073@gmail.com> <CY4PR15MB1317AE9CF20E139CED8EEA959A5C0@CY4PR15MB1317.namprd15.prod.outlook.com>
In-Reply-To: <CY4PR15MB1317AE9CF20E139CED8EEA959A5C0@CY4PR15MB1317.namprd15.prod.outlook.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 6 Dec 2019 13:58:34 +0900
Message-ID: <CAMArcTV3CDz=M_Z3Z25yG8tkyc5r8+FeM9DCPav2rdrPwpMQ+g@mail.gmail.com>
Subject: Re: [PATCH net] tipc: fix ordering of tipc module init and exit routine
To:     Jon Maloy <jon.maloy@ericsson.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Dec 2019 at 06:11, Jon Maloy <jon.maloy@ericsson.com> wrote:
>

Hi Jon,
Thank you for your review!

> Hi Taehee,
> Why didn't you move netlink_compat_stop() too?
>

This is my mistake.
netlink_compat_sopt() should be moved too.
I will send a v2 patch.

Thank you!
Taehee Yoo

> ///jon
>
>
> > -----Original Message-----
> > From: Taehee Yoo <ap420073@gmail.com>
> > Sent: 5-Dec-19 11:37
> > To: davem@davemloft.net; Jon Maloy <jon.maloy@ericsson.com>; ying.xue@windriver.com;
> > netdev@vger.kernel.org
> > Cc: ap420073@gmail.com
> > Subject: [PATCH net] tipc: fix ordering of tipc module init and exit routine
> >
> > In order to set/get/dump, the tipc uses the generic netlink
> > infrastructure. So, when tipc module is inserted, init function
> > calls genl_register_family().
> > After genl_register_family(), set/get/dump commands are immediately
> > allowed and these callbacks internally use the net_generic.
> > net_generic is allocated by register_pernet_device() but this
> > is called after genl_register_family() in the __init function.
> > So, these callbacks would use un-initialized net_generic.
> >
> > Test commands:
> >     #SHELL1
> >     while :
> >     do
> >         modprobe tipc
> >       modprobe -rv tipc
> >     done
> >
> >     #SHELL2
> >     while :
> >     do
> >         tipc link list
> >     done
> >
> > Splat looks like:
> > [   59.616322][ T2788] kasan: CONFIG_KASAN_INLINE enabled
> > [   59.617234][ T2788] kasan: GPF could be caused by NULL-ptr deref or user memory access
> > [   59.618398][ T2788] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> > [   59.619389][ T2788] CPU: 3 PID: 2788 Comm: tipc Not tainted 5.4.0+ #194
> > [   59.620231][ T2788] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox
> > 12/01/2006
> > [   59.621428][ T2788] RIP: 0010:tipc_bcast_get_broadcast_mode+0x131/0x310 [tipc]
> > [   59.622379][ T2788] Code: c7 c6 ef 8b 38 c0 65 ff 0d 84 83 c9 3f e8 d7 a5 f2 e3 48 8d bb 38 11 00 00 48
> > b8 00 00 00 00
> > [   59.622550][ T2780] NET: Registered protocol family 30
> > [   59.624627][ T2788] RSP: 0018:ffff88804b09f578 EFLAGS: 00010202
> > [   59.624630][ T2788] RAX: dffffc0000000000 RBX: 0000000000000011 RCX: 000000008bc66907
> > [   59.624631][ T2788] RDX: 0000000000000229 RSI: 000000004b3cf4cc RDI: 0000000000001149
> > [   59.624633][ T2788] RBP: ffff88804b09f588 R08: 0000000000000003 R09: fffffbfff4fb3df1
> > [   59.624635][ T2788] R10: fffffbfff50318f8 R11: ffff888066cadc18 R12: ffffffffa6cc2f40
> > [   59.624637][ T2788] R13: 1ffff11009613eba R14: ffff8880662e9328 R15: ffff8880662e9328
> > [   59.624639][ T2788] FS:  00007f57d8f7b740(0000) GS:ffff88806cc00000(0000)
> > knlGS:0000000000000000
> > [   59.624645][ T2788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   59.625875][ T2780] tipc: Started in single node mode
> > [   59.626128][ T2788] CR2: 00007f57d887a8c0 CR3: 000000004b140002 CR4: 00000000000606e0
> > [   59.633991][ T2788] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   59.635195][ T2788] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [   59.636478][ T2788] Call Trace:
> > [   59.637025][ T2788]  tipc_nl_add_bc_link+0x179/0x1470 [tipc]
> > [   59.638219][ T2788]  ? lock_downgrade+0x6e0/0x6e0
> > [   59.638923][ T2788]  ? __tipc_nl_add_link+0xf90/0xf90 [tipc]
> > [   59.639533][ T2788]  ? tipc_nl_node_dump_link+0x318/0xa50 [tipc]
> > [   59.640160][ T2788]  ? mutex_lock_io_nested+0x1380/0x1380
> > [   59.640746][ T2788]  tipc_nl_node_dump_link+0x4fd/0xa50 [tipc]
> > [   59.641356][ T2788]  ? tipc_nl_node_reset_link_stats+0x340/0x340 [tipc]
> > [   59.642088][ T2788]  ? __skb_ext_del+0x270/0x270
> > [   59.642594][ T2788]  genl_lock_dumpit+0x85/0xb0
> > [   59.643050][ T2788]  netlink_dump+0x49c/0xed0
> > [   59.643529][ T2788]  ? __netlink_sendskb+0xc0/0xc0
> > [   59.644044][ T2788]  ? __netlink_dump_start+0x190/0x800
> > [   59.644617][ T2788]  ? __mutex_unlock_slowpath+0xd0/0x670
> > [   59.645177][ T2788]  __netlink_dump_start+0x5a0/0x800
> > [   59.645692][ T2788]  genl_rcv_msg+0xa75/0xe90
> > [   59.646144][ T2788]  ? __lock_acquire+0xdfe/0x3de0
> > [   59.646692][ T2788]  ? genl_family_rcv_msg_attrs_parse+0x320/0x320
> > [   59.647340][ T2788]  ? genl_lock_dumpit+0xb0/0xb0
> > [   59.647821][ T2788]  ? genl_unlock+0x20/0x20
> > [   59.648290][ T2788]  ? genl_parallel_done+0xe0/0xe0
> > [   59.648787][ T2788]  ? find_held_lock+0x39/0x1d0
> > [   59.649276][ T2788]  ? genl_rcv+0x15/0x40
> > [   59.649722][ T2788]  ? lock_contended+0xcd0/0xcd0
> > [   59.650296][ T2788]  netlink_rcv_skb+0x121/0x350
> > [   59.650828][ T2788]  ? genl_family_rcv_msg_attrs_parse+0x320/0x320
> > [   59.651491][ T2788]  ? netlink_ack+0x940/0x940
> > [   59.651953][ T2788]  ? lock_acquire+0x164/0x3b0
> > [   59.652449][ T2788]  genl_rcv+0x24/0x40
> > [   59.652841][ T2788]  netlink_unicast+0x421/0x600
> > [ ... ]
> >
> > Fixes: 7e4369057806 ("tipc: fix a slab object leak")
> > Fixes: a62fbccecd62 ("tipc: make subscriber server support net namespace")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  net/tipc/core.c | 27 ++++++++++++++-------------
> >  1 file changed, 14 insertions(+), 13 deletions(-)
> >
> > diff --git a/net/tipc/core.c b/net/tipc/core.c
> > index 7532a00ac73d..f5a55c225742 100644
> > --- a/net/tipc/core.c
> > +++ b/net/tipc/core.c
> > @@ -148,14 +148,6 @@ static int __init tipc_init(void)
> >       sysctl_tipc_rmem[1] = RCVBUF_DEF;
> >       sysctl_tipc_rmem[2] = RCVBUF_MAX;
> >
> > -     err = tipc_netlink_start();
> > -     if (err)
> > -             goto out_netlink;
> > -
> > -     err = tipc_netlink_compat_start();
> > -     if (err)
> > -             goto out_netlink_compat;
> > -
> >       err = tipc_register_sysctl();
> >       if (err)
> >               goto out_sysctl;
> > @@ -180,8 +172,21 @@ static int __init tipc_init(void)
> >       if (err)
> >               goto out_bearer;
> >
> > +     err = tipc_netlink_start();
> > +     if (err)
> > +             goto out_netlink;
> > +
> > +     err = tipc_netlink_compat_start();
> > +     if (err)
> > +             goto out_netlink_compat;
> > +
> >       pr_info("Started in single node mode\n");
> >       return 0;
> > +
> > +out_netlink_compat:
> > +     tipc_netlink_stop();
> > +out_netlink:
> > +     tipc_bearer_cleanup();
> >  out_bearer:
> >       unregister_pernet_subsys(&tipc_pernet_pre_exit_ops);
> >  out_register_pernet_subsys:
> > @@ -193,22 +198,18 @@ static int __init tipc_init(void)
> >  out_pernet:
> >       tipc_unregister_sysctl();
> >  out_sysctl:
> > -     tipc_netlink_compat_stop();
> > -out_netlink_compat:
> > -     tipc_netlink_stop();
> > -out_netlink:
> >       pr_err("Unable to start in single node mode\n");
> >       return err;
> >  }
> >
> >  static void __exit tipc_exit(void)
> >  {
> > +     tipc_netlink_stop();
> >       tipc_bearer_cleanup();
> >       unregister_pernet_subsys(&tipc_pernet_pre_exit_ops);
> >       unregister_pernet_device(&tipc_topsrv_net_ops);
> >       tipc_socket_stop();
> >       unregister_pernet_device(&tipc_net_ops);
> > -     tipc_netlink_stop();
> >       tipc_netlink_compat_stop();
> >       tipc_unregister_sysctl();
> >
> > --
> > 2.17.1
>
