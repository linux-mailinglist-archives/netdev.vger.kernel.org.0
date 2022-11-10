Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC806624D37
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiKJVmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKJVmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:42:54 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886E1554F1;
        Thu, 10 Nov 2022 13:42:53 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b2so8455983eja.6;
        Thu, 10 Nov 2022 13:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OdSD6Zb2uCuXxZEM10wkiH4hogYGjAp4wTcYzGl4Id0=;
        b=omd6xd2XMp0Z5FKUTseArwLYDpkh+XkgNIN8nMbl4drnnQKA/Y6LS5uetuN+cMOub7
         cSqKek2dpNuhJPPwocmUjk73hAO4IR38aCkkfREKh3O3X+UIPJfVY59tXiGWdqSEQhFC
         8Buz8rhNE3rdjzXF4DUM1cX8HP5BnECxU7UvJiWcbw/TC5STTuiFNP+QH2jwiXQEMCVt
         DSX5LZDOMlVV2DJfcTlqUlJHxzoT8o2E02PQi23csvcqns+AOzzkZ/wjl+V6bRxZTMko
         iYgrLTVXQ4KL4SaCgqOH5dBzJYL0GV+lxwZTKos9WLNRaLA7rARJ9/8MmX/r69hvYNmV
         dqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OdSD6Zb2uCuXxZEM10wkiH4hogYGjAp4wTcYzGl4Id0=;
        b=LTgr6IJB7uaBTeI5+ppQjM+0wm1zFtzrgZ20WwGJSqMYVbRB9Am61CUchooy7P1Asj
         XWLu/LiAldKh5ll3Z+nz5i5ANlwU4wZDFGhfqFSZ6L6SpEhrdafsoSL16Frj/V0tixJH
         a5OXjwQiBXlneWoSDBcnOyvWDBBNOT+D9QZwGavigNXtEp1+dEpOLTDw2dTnVoOJhQfw
         YZCnLJLIkNSqkPPAWPpI9K9x8L/kJhrBfo85UMPSYOvQDNKfEfHzrwY4mMr9PMahxSws
         JtLwPlABHDFbIDbWjdUkp9HZZ25BbyJuTQQrqDP8QPuVC7pKkGcWPHrj/3p/TZagWjZC
         FUQQ==
X-Gm-Message-State: ANoB5plNSYX+hjSf984tL/PM970Ck4YDsOB73ossLf/H8e2HjLATGkOM
        QJ0CrO0hzhV4HYphNxtgY9FXpZ3DzhU4XF4hzk0=
X-Google-Smtp-Source: AA0mqf4pmY8VnTieBZ3o3a/xOznIbJLyoYSVm/KZ+CUBORqAZtaMRZIA/K0QInGVK2914o08DaP9v6cVmtmqAdV/L2M=
X-Received: by 2002:a17:907:8dc8:b0:7ae:6450:c620 with SMTP id
 tg8-20020a1709078dc800b007ae6450c620mr3426927ejc.270.1668116571949; Thu, 10
 Nov 2022 13:42:51 -0800 (PST)
MIME-Version: 1.0
References: <CAJnrk1bNPyb=hb2f6rSeusSon_3=vgQz6+OiJOyuuAwVqjS=wQ@mail.gmail.com>
 <20221110203432.97668-1-kuniyu@amazon.com>
In-Reply-To: <20221110203432.97668-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 10 Nov 2022 13:42:40 -0800
Message-ID: <CAJnrk1bRisbp56U6k5S_yPdSv14ydXhqRDfycfhjyeELTDVCjg@mail.gmail.com>
Subject: Re: [PATCH v1 net] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     acme@mandriva.com, davem@davemloft.net, dccp@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, martin.lau@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, william.xuanziyang@huawei.com,
        yoshfuji@linux-ipv6.org
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

On Thu, Nov 10, 2022 at 12:34 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Thu, 10 Nov 2022 10:59:43 -0800
> >  hOn Sun, Nov 6, 2022 at 5:15 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Joanne Koong <joannelkoong@gmail.com>
> > > Date:   Sun, 6 Nov 2022 11:18:44 -0800
> > > > On Thu, Nov 3, 2022 at 10:24 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > When connect() is called on a socket bound to the wildcard address,
> > > > > we change the socket's saddr to a local address.  If the socket
> > > > > fails to connect() to the destination, we have to reset the saddr.
> > > > >
> > > > > However, when an error occurs after inet_hash6?_connect() in
> > > > > (dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
> > > > > the socket bound to the address.
> > > > >
> > > > > From the user's point of view, whether saddr is reset or not varies
> > > > > with errno.  Let's fix this inconsistent behaviour.
> > > > >
> > > > > Note that with this patch, the repro [0] will trigger the WARN_ON()
> > > > > in inet_csk_get_port() again, but this patch is not buggy and rather
> > > > > fixes a bug papering over the bhash2's bug [1] for which we need
> > > > > another fix.
> > > > >
> > > > > For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
> > > > > by this sequence:
> > > > >
> > > > >   s1 = socket()
> > > > >   s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > > > >   s1.bind(('127.0.0.1', 10000))
> > > > >   s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
> > > > >   # or s1.connect(('127.0.0.1', 10000))
> > > > >
> > > > >   s2 = socket()
> > > > >   s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > > > >   s2.bind(('0.0.0.0', 10000))
> > > > >   s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL
> > > > >
> > > > >   s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
> > > > >
> > > > > [0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
> > > > > [1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
> > > > >
> > > > > Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> > > > > Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > ---
> > > > >  net/dccp/ipv4.c     | 2 ++
> > > > >  net/dccp/ipv6.c     | 2 ++
> > > > >  net/ipv4/tcp_ipv4.c | 2 ++
> > > > >  net/ipv6/tcp_ipv6.c | 2 ++
> > > > >  4 files changed, 8 insertions(+)
> > > > >
> > > > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > > > index 713b7b8dad7e..40640c26680e 100644
> > > > > --- a/net/dccp/ipv4.c
> > > > > +++ b/net/dccp/ipv4.c
> > > > > @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > > > >          * This unhashes the socket and releases the local port, if necessary.
> > > > >          */
> > > > >         dccp_set_state(sk, DCCP_CLOSED);
> > > > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > > > +               inet_reset_saddr(sk);
> > > > >         ip_rt_put(rt);
> > > > >         sk->sk_route_caps = 0;
> > > > >         inet->inet_dport = 0;
> > > > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > > > index e57b43006074..626166cb6d7e 100644
> > > > > --- a/net/dccp/ipv6.c
> > > > > +++ b/net/dccp/ipv6.c
> > > > > @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > > > >
> > > > >  late_failure:
> > > > >         dccp_set_state(sk, DCCP_CLOSED);
> > > > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > > > +               inet_reset_saddr(sk);
> > > > >         __sk_dst_reset(sk);
> > > > >  failure:
> > > > >         inet->inet_dport = 0;
> > > > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > > > index 87d440f47a70..6a3a732b584d 100644
> > > > > --- a/net/ipv4/tcp_ipv4.c
> > > > > +++ b/net/ipv4/tcp_ipv4.c
> > > > > @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > > > >          * if necessary.
> > > > >          */
> > > > >         tcp_set_state(sk, TCP_CLOSE);
> > > > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > > > +               inet_reset_saddr(sk);
> > > > >         ip_rt_put(rt);
> > > > >         sk->sk_route_caps = 0;
> > > > >         inet->inet_dport = 0;
> > > > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > > > index 2a3f9296df1e..81b396e5cf79 100644
> > > > > --- a/net/ipv6/tcp_ipv6.c
> > > > > +++ b/net/ipv6/tcp_ipv6.c
> > > > > @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > > > >
> > > > >  late_failure:
> > > > >         tcp_set_state(sk, TCP_CLOSE);
> > > > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > > > +               inet_reset_saddr(sk);
> > > > >  failure:
> > > > >         inet->inet_dport = 0;
> > > > >         sk->sk_route_caps = 0;
> > > > > --
> > > > > 2.30.2
> > > > >
> > > >
> > > > inet_reset_saddr() sets both inet_saddr and inet_rcv_saddr to 0, but I
> > > > think there are some edge cases where when dccp/tcp_v4/6_connect() is
> > > > called, inet_saddr is 0 but inet_rcv_saddr is not, which means we'd
> > > > need to reset inet_rcv_saddr to its original value. The example case
> > > > I'm looking at is  __inet_bind() where if the request is to bind to a
> > > > multicast address,
> > > >
> > > >     inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
> > > >     if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
> > > >         inet->inet_saddr = 0;  /* Use device */
> > >
> > > Thanks for reviewing.
> > >
> > > We have to take care of these two error paths.
> > >
> > >   * (dccp|tcp)_v[46]_coonnect()
> > >   * __inet_stream_connect()
> > >
> > > In __inet_stream_connect(), we call ->disconnect(), which already has the
> > > same logic in this patch.
> > >
> > > In your edge case, once (dccp|tcp)_v[46]_coonnect() succeeds, both of
> > > inet->inet_saddr and sk_rcv_saddr are non-zero.  If connect() fails after
> > > that, in ->disconnect(), we cannot know if we should restore sk_rcv_saddr
> > > only.  Also, we don't have the previous address there.
> > >
> > > For these reasons, we reset both addresses only if the sk was bound to
> > > INADDR_ANY, which we can detect by the SOCK_BINDADDR_LOCK flag.
> > >
> > > As you mentinoed, we can restore sk_rcv_saddr for the edge case in
> > > (dccp|tcp)_v[46]_coonnect() but cannot in __inet_stream_connect().
> > >
> > > If we do so, we need another flag for the case and another member to save
> > > the old multicast/broadcast address. (+ where we need rehash for bhash2)
> > >
> > > What do you think ?
> >
> > Sorry for the late reply Kuniyuki, I didn't see your email in my inbox
> > until Paolo resurfaced it.
> >
> > I think this error case (eg multicast address) will be very rare +
> > have minimal side-effects, and isn't worth accounting for in
> > __inet_stream_connect().
>
> Agreed.
>
>
> > In (dccp|tcp)_v[46]_coonnect(), it seems
> > simple to address because we already track the previous sk address in
> > the "prev_sk_rcv_saddr" variable.
> >
> > ALso, as a side-note, I think we'll need an additional patch to fix an
> > existing bug that's related to resetting saddrs, where we'll need to
> > first check whether there's a bind conflict in the bhash/bhash2 table
> > before we can reset its saddr back to 0
> > (https://lore.kernel.org/netdev/CAJnrk1Z1UFmJ2_-7G6sdNHYy0jfjbJjWiCmAzqtLN9dkJ_g+vA@mail.gmail.com/
> > has some more info). I don't think that issue blocks this patch
> > though.
>
> For better issue overview, I'll repost this patch with another patch
> to fix bhash2 bucket when resetting saddr.  After that, let's fix
> another issue for checking conflict before resetting sk_rcv_saddr.

Sounds great!
