Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A266634317
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiKVR4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiKVRzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:55:46 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A848DB5;
        Tue, 22 Nov 2022 09:54:37 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3a4c2c83300so55977427b3.13;
        Tue, 22 Nov 2022 09:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L0rPPoMf/BQcnP7OVRdbz7eh/i+6Gf4OOaHX2I41UhU=;
        b=d5VW+1b1VGIj13TRqpfUbm9lLtaM1CtTAtbQ1RHvN0H9yd6uo1BpMvacToZcZFyzx3
         mQVjzGPGlrTVWDfBiXXxeBlRrQDYIEtzyJAcj5x6UXF8wq2+nIGL0TgNkMkYM/6ZBhLE
         0c/0eFFu6uFJpNaehRs/89T3C+109cH6rH8OxLRyTCErkOB6+VrUOnrH8KdiyuIFrN2r
         z6v7qGm09vuHS/rFVDHOcj7vw+7NRYDPWDgr2i3Ut6Uzk4/oDZSxLGN5Wt/RE/fr2blY
         x1IZLZ3mM6pzIHyMuyLn2InX6z3+9vPyLUZBGEB6V47GOZ49n73GSWqTPca53SHMvh9O
         CcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L0rPPoMf/BQcnP7OVRdbz7eh/i+6Gf4OOaHX2I41UhU=;
        b=SSKBPtb11B0AhJQOr+no/rGQiQ6uuaro/zFDCjYMbE4BFAckmjqKPOdu0xNHK1PxMq
         mlm0opSBVYgRcjgWC7gjiX0ZPN+uCo2HCPtKUkK+wiS1XeZg0DmQc9oTzpji1NIiJhVt
         Rz2xzN/6opqbzquwa+ghwReukOACY7N/Hd2ASFK5+hfOyo+0BB4bC/RIIp5/Pu+Ri1Iw
         f6uXMgxak0l9/E/lXe2kFK/mG/5bfuk3RuAfRvCi9Zu8kwc7Fe5K1qMBr/CqNKI+Rtti
         4M3kEb6Jnstu7+JcHEkX4QDvNQI5f1U+cnQdwmgRoYW3g4CTB+P1MIVKg3GvNguxCVwb
         Ofkg==
X-Gm-Message-State: ANoB5pl7t8+0oULQVEpGheIjyfFDtjI4POQKJnbbzMZSs6J/mAQUKJOz
        ai/o2uPTVcNLOBijQVp5gOZ4E420jdXYvb0byII=
X-Google-Smtp-Source: AA0mqf7+udcH8F5ou6EBnqpzxPoJ7Sn8opE9LMmn0RU+R8gjos9Cxgw6UcypmHl1cUNGp6GSPUPn1vr95GiFH8GNwR0=
X-Received: by 2002:a81:9145:0:b0:36c:ada0:8ae8 with SMTP id
 i66-20020a819145000000b0036cada08ae8mr4625148ywg.513.1669139676417; Tue, 22
 Nov 2022 09:54:36 -0800 (PST)
MIME-Version: 1.0
References: <CAJnrk1YUNuJKvdYDp6Ye2rXgVzr8KViq65P0EGrh5W4WeoQkDA@mail.gmail.com>
 <20221122005050.56912-1-kuniyu@amazon.com>
In-Reply-To: <20221122005050.56912-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 22 Nov 2022 09:54:24 -0800
Message-ID: <CAJnrk1b+bMdNW=wBe0fQ-bPuxQUA9GAeQ4RiNoCccrFuB8OOAQ@mail.gmail.com>
Subject: Re: [PATCH v4 net 4/4] dccp/tcp: Fixup bhash2 bucket when connect() fails.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     acme@mandriva.com, davem@davemloft.net, dccp@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, martin.lau@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, pengfei.xu@intel.com,
        stephen@networkplumber.org, syzkaller@googlegroups.com,
        william.xuanziyang@huawei.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 4:51 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Mon, 21 Nov 2022 15:41:43 -0800
> > On Fri, Nov 18, 2022 at 5:51 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > If a socket bound to a wildcard address fails to connect(), we
> > > only reset saddr and keep the port.  Then, we have to fix up the
> > > bhash2 bucket; otherwise, the bucket has an inconsistent address
> > > in the list.
> > >
> > > Also, listen() for such a socket will fire the WARN_ON() in
> > > inet_csk_get_port(). [0]
> > >
> > > Note that when a system runs out of memory, we give up fixing the
> > > bucket and unlink sk from bhash and bhash2 by inet_put_port().
> > >
> > > [0]:
> > > WARNING: CPU: 0 PID: 207 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> > > Modules linked in:
> > > CPU: 0 PID: 207 Comm: bhash2_prev_rep Not tainted 6.1.0-rc3-00799-gc8421681c845 #63
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
> > > RIP: 0010:inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> > > Code: 74 a7 eb 93 48 8b 54 24 18 0f b7 cb 4c 89 e6 4c 89 ff e8 48 b2 ff ff 49 8b 87 18 04 00 00 e9 32 ff ff ff 0f 0b e9 34 ff ff ff <0f> 0b e9 42 ff ff ff 41 8b 7f 50 41 8b 4f 54 89 fe 81 f6 00 00 ff
> > > RSP: 0018:ffffc900003d7e50 EFLAGS: 00010202
> > > RAX: ffff8881047fb500 RBX: 0000000000004e20 RCX: 0000000000000000
> > > RDX: 000000000000000a RSI: 00000000fffffe00 RDI: 00000000ffffffff
> > > RBP: ffffffff8324dc00 R08: 0000000000000001 R09: 0000000000000001
> > > R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> > > R13: 0000000000000001 R14: 0000000000004e20 R15: ffff8881054e1280
> > > FS:  00007f8ac04dc740(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000020001540 CR3: 00000001055fa003 CR4: 0000000000770ef0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > PKRU: 55555554
> > > Call Trace:
> > >  <TASK>
> > >  inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
> > >  inet_listen (net/ipv4/af_inet.c:228)
> > >  __sys_listen (net/socket.c:1810)
> > >  __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
> > >  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> > >  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> > > RIP: 0033:0x7f8ac051de5d
> > > Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
> > > RSP: 002b:00007ffc1c177248 EFLAGS: 00000206 ORIG_RAX: 0000000000000032
> > > RAX: ffffffffffffffda RBX: 0000000020001550 RCX: 00007f8ac051de5d
> > > RDX: ffffffffffffff80 RSI: 0000000000000000 RDI: 0000000000000004
> > > RBP: 00007ffc1c177270 R08: 0000000000000018 R09: 0000000000000007
> > > R10: 0000000020001540 R11: 0000000000000206 R12: 00007ffc1c177388
> > > R13: 0000000000401169 R14: 0000000000403e18 R15: 00007f8ac0723000
> > >  </TASK>
> > >
> > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> >
> > Acked-by: Joanne Koong <joannelkoong@gmail.com>
>
> Thanks for all your help!
>
>
> > > ---
> > >  include/net/inet_hashtables.h |  1 +
> > >  net/dccp/ipv4.c               |  3 +--
> > >  net/dccp/ipv6.c               |  3 +--
> > >  net/dccp/proto.c              |  3 +--
> > >  net/ipv4/inet_hashtables.c    | 38 +++++++++++++++++++++++++++++++----
> > >  net/ipv4/tcp.c                |  3 +--
> > >  net/ipv4/tcp_ipv4.c           |  3 +--
> > >  net/ipv6/tcp_ipv6.c           |  3 +--
> > >  8 files changed, 41 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > > index ba06e8b52264..69174093078f 100644
> > > --- a/include/net/inet_hashtables.h
> > > +++ b/include/net/inet_hashtables.h
> > > @@ -282,6 +282,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
> > >   * rcv_saddr field should already have been updated when this is called.
> > >   */
> > >  int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
> > > +void inet_bhash2_reset_saddr(struct sock *sk);
> > >
> > >  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> > >                     struct inet_bind2_bucket *tb2, unsigned short port);
> > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > index 95e376e3b911..b780827f5e0a 100644
> > > --- a/net/dccp/ipv4.c
> > > +++ b/net/dccp/ipv4.c
> > > @@ -143,8 +143,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >          * This unhashes the socket and releases the local port, if necessary.
> > >          */
> > >         dccp_set_state(sk, DCCP_CLOSED);
> > > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -               inet_reset_saddr(sk);
> > > +       inet_bhash2_reset_saddr(sk);
> > >         ip_rt_put(rt);
> > >         sk->sk_route_caps = 0;
> > >         inet->inet_dport = 0;
> > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > index 94c101ed57a9..602f3432d80b 100644
> > > --- a/net/dccp/ipv6.c
> > > +++ b/net/dccp/ipv6.c
> > > @@ -970,8 +970,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >
> > >  late_failure:
> > >         dccp_set_state(sk, DCCP_CLOSED);
> > > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -               inet_reset_saddr(sk);
> > > +       inet_bhash2_reset_saddr(sk);
> > >         __sk_dst_reset(sk);
> > >  failure:
> > >         inet->inet_dport = 0;
> > > diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> > > index c548ca3e9b0e..85e35c5e8890 100644
> > > --- a/net/dccp/proto.c
> > > +++ b/net/dccp/proto.c
> > > @@ -279,8 +279,7 @@ int dccp_disconnect(struct sock *sk, int flags)
> > >
> > >         inet->inet_dport = 0;
> > >
> > > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -               inet_reset_saddr(sk);
> > > +       inet_bhash2_reset_saddr(sk);
> > >
> > >         sk->sk_shutdown = 0;
> > >         sock_reset_flag(sk, SOCK_DONE);
> > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > index 18ef370af113..3cec471a2cd2 100644
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -871,7 +871,7 @@ static void inet_update_saddr(struct sock *sk, void *saddr, int family)
> > >  #endif
> > >  }
> > >
> > > -int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > > +static int __inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family, bool reset)
> > >  {
> > >         struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
> > >         struct inet_bind_hashbucket *head, *head2;
> > > @@ -883,7 +883,11 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >
> > >         if (!inet_csk(sk)->icsk_bind2_hash) {
> > >                 /* Not bind()ed before. */
> > > -               inet_update_saddr(sk, saddr, family);
> > > +               if (reset)
> > > +                       inet_reset_saddr(sk);
> > > +               else
> > > +                       inet_update_saddr(sk, saddr, family);
> > > +
> > >                 return 0;
> > >         }
> > >
> > > @@ -892,8 +896,19 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >          * allocation fails.
> > >          */
> > >         new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
> > > -       if (!new_tb2)
> > > +       if (!new_tb2) {
> > > +               if (reset) {
> > > +                       /* The (INADDR_ANY, port) bucket might have already
> > > +                        * been freed, then we cannot fixup icsk_bind2_hash,
> > > +                        * so we give up and unlink sk from bhash/bhash2 not
> > > +                        * to leave inconsistency in bhash2.
> > > +                        */
> > > +                       inet_put_port(sk);
> > > +                       inet_reset_saddr(sk);
> > > +               }
> >
> > nit: I think this is better placed in the dccp/tcp_ipv4/6 layer, to
> > make it clear / more obvious that the sk gets unbinded in this edge
> > case.
>
> But it duplicates 2 calls (and a comment) across 6 places.
>
> or we can move it to inet_bhash2_reset_saddr() like
>
> void inet_bhash2_reset_saddr(struct sock *sk)
> {
>         if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK) &&
>             __inet_bhash2_update_saddr(sk, NULL, 0, true) {
>                 inet_put_port(sk);
>                 inet_reset_saddr(sk);
>         }
> }
> EXPORT_SYMBOL_GPL(inet_bhash2_reset_saddr);
>
> I'm fine with whichever, which do you like ?
>
> Or we can go as is and post a follow-up.
>

I'm fine with whichever too. I think it being in
inet_bhash2_reset_saddr() would be clearer than it being within
__inet_bhash2_update_saddr().

Thanks for your work on this!

>
> >
> > > +
> > >                 return -ENOMEM;
> > > +       }
> > >
> > >         bhash = inet_bhashfn(net, port, hinfo->bhash_size);
> > >         head = &hinfo->bhash[bhash];
> > > @@ -909,7 +924,10 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >         inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
> > >         spin_unlock(&head2->lock);
> > >
> > > -       inet_update_saddr(sk, saddr, family);
> > > +       if (reset)
> > > +               inet_reset_saddr(sk);
> > > +       else
> > > +               inet_update_saddr(sk, saddr, family);
> > >
> > >         head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > >
> > > @@ -930,8 +948,20 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > >
> > >         return 0;
> > >  }
> > > +
> > > +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > > +{
> > > +       return __inet_bhash2_update_saddr(sk, saddr, family, false);
> > > +}
> > >  EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
> > >
> > > +void inet_bhash2_reset_saddr(struct sock *sk)
> > > +{
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               __inet_bhash2_update_saddr(sk, NULL, 0, true);
> > > +}
> > > +EXPORT_SYMBOL_GPL(inet_bhash2_reset_saddr);
> >
> > > +
> > >  /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
> > >   * Note that we use 32bit integers (vs RFC 'short integers')
> > >   * because 2^16 is not a multiple of num_ephemeral and this
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index 54836a6b81d6..4f2205756cfe 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -3114,8 +3114,7 @@ int tcp_disconnect(struct sock *sk, int flags)
> > >
> > >         inet->inet_dport = 0;
> > >
> > > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -               inet_reset_saddr(sk);
> > > +       inet_bhash2_reset_saddr(sk);
> > >
> > >         sk->sk_shutdown = 0;
> > >         sock_reset_flag(sk, SOCK_DONE);
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index 23dd7e9df2d5..da46357f501b 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -331,8 +331,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >          * if necessary.
> > >          */
> > >         tcp_set_state(sk, TCP_CLOSE);
> > > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -               inet_reset_saddr(sk);
> > > +       inet_bhash2_reset_saddr(sk);
> > >         ip_rt_put(rt);
> > >         sk->sk_route_caps = 0;
> > >         inet->inet_dport = 0;
> > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > index 2f3ca3190d26..f0548dbcabd2 100644
> > > --- a/net/ipv6/tcp_ipv6.c
> > > +++ b/net/ipv6/tcp_ipv6.c
> > > @@ -346,8 +346,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >
> > >  late_failure:
> > >         tcp_set_state(sk, TCP_CLOSE);
> > > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > -               inet_reset_saddr(sk);
> > > +       inet_bhash2_reset_saddr(sk);
> > >  failure:
> > >         inet->inet_dport = 0;
> > >         sk->sk_route_caps = 0;
> > > --
> > > 2.30.2
