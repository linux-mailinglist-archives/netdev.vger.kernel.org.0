Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC86E1DDFB0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgEVGLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgEVGLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 02:11:46 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE421C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 23:11:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t8so3680744wmi.0
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 23:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1ZaHwFVmfk3+MEWYQpqIbTXVSxmF6XlsS1bmd/bTHo=;
        b=Q6nxtW7ZJpHAzqs4QqvWNlJpEU8N7N9UQ7XCNMqi/7LnHq2WKIP08nmeX6jAfA1ED4
         /81lhAr5H8qnTiQneuDATSqWx0hx1XzWSZSOF3e4dvUJAZ+5FzoAzn9f2EiluL9b5UFx
         ieHVw5aEZRZ4d0yCytZwmcA/jVvxYUoE2r3luq87z1oZWWmzFJdM5C3EIoXVVodbMuja
         9tAanKCP/JsInKg8cEJuwyK/weu3MOdiN9Y+VlDQtsp/n8X1U85gifX2g09P86ryh6TL
         l/h46wCbFkmASdSOGT1wfr0kCGT0kcyzVbfHC9wrpGhDNG3kdiywNxLDsqj5aKZMza3y
         FZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1ZaHwFVmfk3+MEWYQpqIbTXVSxmF6XlsS1bmd/bTHo=;
        b=a10hgYPbwuz5cXKEuVd5t5esPPQsaPzNhcaGBAIN318SBNED1j3U1sgC4evUQYbKCi
         gNFhPGYkuGBPM3XJagMtjNaA2D2fAjdc09/a3YGtRDFdekXkm6wP5wDDprVy4ab7JFTk
         PqrdxXLrjMd7lwEDoG9nNlxMj8u1Kakl1A5yePkKNPzC78M5s/eZMBMTRZhnpeBLPeUk
         gLDtC05TNvSl/R0cJG1GN5XIcTSP3Nts0n+/vAW6Y1mw2LmhZFk/w0HlTmj3mqBG7YbX
         LUbtxatFO1g/HN2t/Wzz57YKoIyQi0Sit9Hk5FAwGws7cJ3v1iMe7xWv6RBX8o6c/+yO
         m+7Q==
X-Gm-Message-State: AOAM5329qp7ngV7/i4ccROwo3r4WAo/r8FaQNuw0hUc5ouL81Q1oJSlg
        cDy4y1SdjfRmV5e3h2H/YwOa7FkOFxIl0c9GQ08=
X-Google-Smtp-Source: ABdhPJxRcJTE8FjbEGc/r2uiT08070WyRmHLGhfR4ePZMro9gW8V0zo35t6lpZERK1ZpM/7NJ8GJq+79JImqK9CyQZE=
X-Received: by 2002:a05:600c:2258:: with SMTP id a24mr11565716wmm.111.1590127904625;
 Thu, 21 May 2020 23:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200521182958.163436-1-edumazet@google.com> <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com> <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
In-Reply-To: <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 22 May 2020 14:18:36 +0800
Message-ID: <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Resend to the list in non HTML form
>
>
> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> >
> >
> > On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
> >>
> >> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
> >> >
> >> > dst_cache_get() documents it must be used with BH disabled.
> >> Interesting, I thought under rcu_read_lock() is enough, which calls
> >> preempt_disable().
> >
> >
> > rcu_read_lock() does not disable BH, never.
> >
> > And rcu_read_lock() does not necessarily disable preemption.
Then I need to think again if it's really worth using dst_cache here.

Also add tipc-discussion and Jon to CC list.

Thanks.

> >
> >
> >>
> >> have you checked other places where dst_cache_get() are used?
> >
> >
> >
> > Yes, other paths are fine.
> >
> >>
> >>
> >> >
> >> > sysbot reported :
> >> >
> >> > BUG: using smp_processor_id() in preemptible [00000000] code: /21697
> >> > caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
> >> > CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
> >> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >> > Call Trace:
> >> >  __dump_stack lib/dump_stack.c:77 [inline]
> >> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >> >  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
> >> >  debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
> >> >  dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
> >> >  tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
> >> >  tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
> >> >  tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
> >> >  tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
> >> >  __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
> >> >  tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
> >> >  genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
> >> >  genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
> >> >  genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
> >> >  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
> >> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
> >> >  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> >> >  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
> >> >  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
> >> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> >> >  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
> >> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
> >> >  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
> >> >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> >> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> >> > RIP: 0033:0x45ca29
> >> >
> >> > Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
> >> > Cc: Xin Long <lucien.xin@gmail.com>
> >> > Cc: Jon Maloy <jon.maloy@ericsson.com>
> >> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >> > Reported-by: syzbot <syzkaller@googlegroups.com>
> >> > ---
> >> >  net/tipc/udp_media.c | 6 +++++-
> >> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
> >> > index d6620ad535461a4d04ed5ba90569ce8b7df9f994..28a283f26a8dff24d613e6ed57e5e69d894dae66 100644
> >> > --- a/net/tipc/udp_media.c
> >> > +++ b/net/tipc/udp_media.c
> >> > @@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
> >> >                          struct udp_bearer *ub, struct udp_media_addr *src,
> >> >                          struct udp_media_addr *dst, struct dst_cache *cache)
> >> >  {
> >> > -       struct dst_entry *ndst = dst_cache_get(cache);
> >> > +       struct dst_entry *ndst;
> >> >         int ttl, err = 0;
> >> >
> >> > +       local_bh_disable();
> >> > +       ndst = dst_cache_get(cache);
> >> >         if (dst->proto == htons(ETH_P_IP)) {
> >> >                 struct rtable *rt = (struct rtable *)ndst;
> >> >
> >> > @@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
> >> >                                            src->port, dst->port, false);
> >> >  #endif
> >> >         }
> >> > +       local_bh_enable();
> >> >         return err;
> >> >
> >> >  tx_error:
> >> > +       local_bh_enable();
> >> >         kfree_skb(skb);
> >> >         return err;
> >> >  }
> >> > --
> >> > 2.27.0.rc0.183.gde8f92d652-goog
> >> >
