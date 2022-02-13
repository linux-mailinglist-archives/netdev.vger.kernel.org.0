Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD584B3CC5
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiBMSM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:12:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiBMSM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:12:27 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD05323
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:12:19 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 124so11781497ybn.11
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nb9r9llavvtBuF98wHugSZxvhUvNOxfcCsB7CTv8gs4=;
        b=hUOEazReMnKhnR9f/9x+huE6l2RTkmIlns9iehBc7w/7M0mCYDd1XZL3whs66aazpM
         YT1FEp4eoNyLSVRmPVa/Y/ysmhY4dDDbS79+AI+hnEHNwwBWRAi1om2A61jbKoTXcLvw
         hCKgxRB9kv7ZVoiRF0mNhqMxgC9wykpPI5mTc+2O0qHyO5l6VXbbfxrnFHWuBN7Lm9zZ
         WSv4h04SvZEnmYaCTjLLwjTdlLBCJl5Sw4qvaB9o8KR8zeqOxOvTCjrpUqauXQpVNR4/
         RLs2yl3tUS1E/6QnrcdMei7WNo4z68zpvaH/PWp6A0wCQgZlU7EBlM8exegQshYI/q7c
         LurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nb9r9llavvtBuF98wHugSZxvhUvNOxfcCsB7CTv8gs4=;
        b=8LFtCwDdjqXIaosqiFF4lrnUSwtN+1Ow0rf+5XDPPm7CtQKHPh6569Kee7/ifC/7a6
         zpkQakGfTwmygZ0JGncI8ftN2KOG6T+DNQtFTqIgApzIRzhAeNZOStCtXexrZSd7gTrM
         9IOVTdSHgKFMe0HLv+uUm/mIH/zWCdJ3Zhj2e+dbOkenVg/IYHDMtVZ4nw9f03ZZ6Ia3
         9VQBjOTepbqYtaI/4Rm2htUmpKzFdyPiA/2wsVhLHeJ8gDY1ZxG/XXuS+/Wqp7fgwcQt
         Zx5UUt8BmlXra/H4MlleNXYBcbO+FEUJAehq0qa70PbbwiP6GUVlNLu78H20+igvKXjf
         /IiA==
X-Gm-Message-State: AOAM5301mbOxOW3rmtjkoe//GL2JrtsKEJX+mnDx5mdZwQJY375VygDA
        ux+nb9ViOp9wKp/jDFodDN33/KQVrE2ZOcKBTLOp2Q==
X-Google-Smtp-Source: ABdhPJw5M0L8/mFRWhEw27lm5lZKh6XCIYqg3B8fhjmULSHihJYGhTyMsr1Hsw+andByIelIu483Kk8oLVEAaK/f/Tg=
X-Received: by 2002:a25:8885:: with SMTP id d5mr9203772ybl.383.1644775938414;
 Sun, 13 Feb 2022 10:12:18 -0800 (PST)
MIME-Version: 1.0
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
 <20220210214231.2420942-3-eric.dumazet@gmail.com> <YglIbVmIqFqHiiZ3@shredder>
In-Reply-To: <YglIbVmIqFqHiiZ3@shredder>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 13 Feb 2022 10:12:07 -0800
Message-ID: <CANn89iLLUwWGhQD9+LjQcaOMZ8c0Km+UcLenBamH0ftbKk=Gyg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] ipv6: give an IPv6 dev to blackhole_netdev
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 10:05 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Feb 10, 2022 at 01:42:29PM -0800, Eric Dumazet wrote:
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 4f402bc38f056e08f3761e63a7bc7a51e54e9384..02d31d4fcab3b3d529c4fe3260216ecee1108e82 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -372,7 +372,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
> >
> >       ASSERT_RTNL();
> >
> > -     if (dev->mtu < IPV6_MIN_MTU)
> > +     if (dev->mtu < IPV6_MIN_MTU && dev != blackhole_netdev)
> >               return ERR_PTR(-EINVAL);
> >
> >       ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
> > @@ -400,21 +400,22 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
> >       /* We refer to the device */
> >       dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);
> >
> > -     if (snmp6_alloc_dev(ndev) < 0) {
> > -             netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
> > -                        __func__);
> > -             neigh_parms_release(&nd_tbl, ndev->nd_parms);
> > -             dev_put_track(dev, &ndev->dev_tracker);
> > -             kfree(ndev);
> > -             return ERR_PTR(err);
> > -     }
> > +     if (dev != blackhole_netdev) {
> > +             if (snmp6_alloc_dev(ndev) < 0) {
> > +                     netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
> > +                                __func__);
> > +                     neigh_parms_release(&nd_tbl, ndev->nd_parms);
> > +                     dev_put_track(dev, &ndev->dev_tracker);
> > +                     kfree(ndev);
> > +                     return ERR_PTR(err);
> > +             }
>
> Hi,
>
> Our regression machines crashed with the following splat [1]. Can be
> reproduced with:
>
> # ./fib_nexthops.sh -t ipv6_torture
>
> From tools/testing/selftests/net
>
> Only had a couple of minutes (need to leave), but looks like the
> following patch helps [2]. I can continue working on it tomorrow
> morning, but wanted to mention it now in case you have a better idea /
> someone else bumps into the same issue.
>
> Thanks
>
> [1]
> [  210.313674] ==================================================================
> [  210.314672] BUG: KASAN: null-ptr-deref in __ip6_make_skb+0x17fb/0x20a0
> [  210.315410] Write of size 8 at addr 0000000000000c00 by task ping/290
> [  210.316183]
> [  210.316359] CPU: 2 PID: 290 Comm: ping Not tainted 5.17.0-rc3-custom-02030-g17b65b552bb5 #1215
> [  210.317335] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
> [  210.318318] Call Trace:
> [  210.318618]  <TASK>
> [  210.318876]  dump_stack_lvl+0x8b/0xb3
> [  210.319803]  kasan_report.cold+0x116/0x11b
> [  210.320876]  kasan_check_range+0xf5/0x1d0
> [  210.321348]  __ip6_make_skb+0x17fb/0x20a0
> [  210.323985]  ip6_push_pending_frames+0xcd/0x110
> [  210.324628]  rawv6_sendmsg+0x29f5/0x37f0
> [  210.329150]  inet_sendmsg+0x9e/0xe0
> [  210.329596]  __sys_sendto+0x23d/0x360
> [  210.333029]  __x64_sys_sendto+0xe1/0x1b0
> [  210.334542]  do_syscall_64+0x35/0x80
> [  210.334975]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  210.335632] RIP: 0033:0x7f2d8cd2f3aa
> [  210.336041] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89
> [  210.338299] RSP: 002b:00007ffe1a5ec768 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> [  210.339345] RAX: ffffffffffffffda RBX: 0000000000000038 RCX: 00007f2d8cd2f3aa
> [  210.340207] RDX: 0000000000000040 RSI: 00007f2d8cfbb320 RDI: 0000000000000004
> [  210.341284] RBP: 00007ffe1a5ec7f0 R08: 00007ffe1a5efee4 R09: 000000000000001c
> [  210.342212] R10: 0000000000000800 R11: 0000000000000246 R12: 00007f2d8cebb480
> [  210.343008] R13: 00007f2d8cea7f3d R14: 00007f2d8cea0c00 R15: 00007f2d8cebaa70
> [  210.343785]  </TASK>
> [  210.344344] ==================================================================
>
> (gdb) l *(__ip6_make_skb+0x17fb)
> 0xffffffff8389fb5b is in __ip6_make_skb (./arch/x86/include/asm/atomic64_64.h:88).
> 83       *
> 84       * Atomically increments @v by 1.
> 85       */
> 86      static __always_inline void arch_atomic64_inc(atomic64_t *v)
> 87      {
> 88              asm volatile(LOCK_PREFIX "incq %0"
> 89                           : "=m" (v->counter)
> 90                           : "m" (v->counter) : "memory");
> 91      }
> 92      #define arch_atomic64_inc arch_atomic64_inc
>
> [2]
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 02d31d4fcab3..57fbd6f03ff8 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -400,16 +400,16 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
>         /* We refer to the device */
>         dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);
>
> -       if (dev != blackhole_netdev) {
> -               if (snmp6_alloc_dev(ndev) < 0) {
> -                       netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
> -                                  __func__);
> -                       neigh_parms_release(&nd_tbl, ndev->nd_parms);
> -                       dev_put_track(dev, &ndev->dev_tracker);
> -                       kfree(ndev);
> -                       return ERR_PTR(err);
> -               }
> +       if (snmp6_alloc_dev(ndev) < 0) {
> +               netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
> +                          __func__);
> +               neigh_parms_release(&nd_tbl, ndev->nd_parms);
> +               dev_put_track(dev, &ndev->dev_tracker);
> +               kfree(ndev);
> +               return ERR_PTR(err);
> +       }
>
> +       if (dev != blackhole_netdev) {
>                 if (snmp6_register_dev(ndev) < 0) {
>                         netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
>                                    __func__, dev->name);
>
> >
> > -     if (snmp6_register_dev(ndev) < 0) {
> > -             netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
> > -                        __func__, dev->name);
> > -             goto err_release;
> > +             if (snmp6_register_dev(ndev) < 0) {
> > +                     netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
> > +                                __func__, dev->name);
> > +                     goto err_release;
> > +             }
> >       }
> > -
> >       /* One reference from device. */
> >       refcount_set(&ndev->refcnt, 1);
> >
> > @@ -445,25 +446,28 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
> >
> >       ipv6_mc_init_dev(ndev);
> >       ndev->tstamp = jiffies;
> > -     err = addrconf_sysctl_register(ndev);
> > -     if (err) {
> > -             ipv6_mc_destroy_dev(ndev);
> > -             snmp6_unregister_dev(ndev);
> > -             goto err_release;
> > +     if (dev != blackhole_netdev) {
> > +             err = addrconf_sysctl_register(ndev);
> > +             if (err) {
> > +                     ipv6_mc_destroy_dev(ndev);
> > +                     snmp6_unregister_dev(ndev);
> > +                     goto err_release;
> > +             }
> >       }
> >       /* protected by rtnl_lock */
> >       rcu_assign_pointer(dev->ip6_ptr, ndev);
> >
> > -     /* Join interface-local all-node multicast group */
> > -     ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
> > +     if (dev != blackhole_netdev) {
> > +             /* Join interface-local all-node multicast group */
> > +             ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
> >
> > -     /* Join all-node multicast group */
> > -     ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
> > -
> > -     /* Join all-router multicast group if forwarding is set */
> > -     if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
> > -             ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
> > +             /* Join all-node multicast group */
> > +             ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
> >
> > +             /* Join all-router multicast group if forwarding is set */
> > +             if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
> > +                     ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
> > +     }
> >       return ndev;
> >
> >  err_release:

Hi Ido

I was coming to a similar conclusion, with an internal syzbot report.

Thanks.
