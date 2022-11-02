Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692306156CE
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKBA5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKBA5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:57:15 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EA01EEE8
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 17:57:13 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id d26so41352442eje.10
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 17:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QQMyneVlInu+hiSAQW7mAyB866pX2mTK+T4SHb+XFa4=;
        b=EhTbSLh2Wju8b8OfMGtKclpkj6DttCwIMp1DOAQW0k/9IdP4hz60FiTXu+BZIpOxPa
         DBLFXST5dcuAKgC7uKHaaWEW3fc92/rQHOEqF3tORMJu++9EUpCiBh7WxtkTULkJNq7j
         WzoMG8daWaOdr+Qb+AyQtFqWT7VZA8Ro3+XYpLFQVa9Bg2GOIuHaYbtgn++kdXlu2coQ
         ELMI1amaJeUGX992RETyPEnryP8zDs3y5eMJi6xM5DvpExTUcaedgtxJWV/MkNF8K7rB
         +q2uEwrOau1E0xbji/zQ9gPypoqm4lGAmVtnvwjDCclZ/oVMfObUe8CSXXkEjqeKdhIn
         X5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQMyneVlInu+hiSAQW7mAyB866pX2mTK+T4SHb+XFa4=;
        b=lLG9kYAPZIjx7i7X9RVtdGPGxpQO/oZwXUNSgFBV4b4pGZjupN9b/ZoIM9C5P03HsI
         NuOs2WEjINjCAbsA2F3Rgu/CMx6ocoAf0Rmnt2ltdRIy4mA7UH9grq3BeXbwxvonJRQC
         KdSe5GFoMAtVAn9XDIND+trb+M+hyY9IW9dW9hZasTpqnV9gEjXrrQoeX1lVesfilv0x
         /4FrvJwrX7mLu4tPPZkBxYf3fkH9LmsCN4vgKX+wmTXOnjjZ+BJOMVQblHBV54OLxEtz
         6ndLKvJgFil1wGzFmUtVcYhLdJctSEosvEcawMIECt209Z4H5IJX11/h2dYVHzZJFrHg
         gyBw==
X-Gm-Message-State: ACrzQf3RbdcR7YrZ5F53ZzZ+VGwARMuRZ1JdZqs9w5XdhFmBFF2pQZJa
        2Av9Lb1T4vwFUyJcwDKPCXZMhJlCVUc2kvWn8uAr1piSDU4=
X-Google-Smtp-Source: AMsMyM5dkeJa6N5iIKOxwyUmzws+0TnRSYd870ukI8pDzJXBJ/VNd/T2UxbYTRhlz1kNLDnHiKrby7FZ/BTtqYZ9Xpw=
X-Received: by 2002:a17:907:a4e:b0:77d:94d:8148 with SMTP id
 be14-20020a1709070a4e00b0077d094d8148mr20070138ejc.607.1667350632225; Tue, 01
 Nov 2022 17:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20221029001249.86337-1-kuniyu@amazon.com> <7083e3fc-a3dd-4b3a-22bf-b68d22494898@linux.dev>
In-Reply-To: <7083e3fc-a3dd-4b3a-22bf-b68d22494898@linux.dev>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 2 Nov 2022 00:57:00 +0000
Message-ID: <CAJnrk1b6=BBEAZTtMPvkqzqjrJrcDo7-dfFvJiYg_Tdd+uShLA@mail.gmail.com>
Subject: Re: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
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

On Tue, Nov 1, 2022 at 11:29 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 10/28/22 5:12 PM, Kuniyuki Iwashima wrote:
> > Hi,
> >
> > I want to discuss bhash2 and WARN_ON() being fired every day this month
> > on my syzkaller instance without repro.
> >
> >    WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> >    ...
> >    inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
> >    inet_listen (net/ipv4/af_inet.c:228)
> >    __sys_listen (net/socket.c:1810)
> >    __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
> >    do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> >    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> >
> > For the very first implementation of bhash2, there was a similar report
> > hitting the same WARN_ON().  The fix was to update the bhash2 bucket when
> > the kernel changes sk->sk_rcv_saddr from INADDR_ANY.  Then, syzbot has a
> > repro, so we can indeed confirm that it no longer triggers the warning on
> > the latest kernel.
> >
> >    https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
> >
> > However, Mat reported at that time that there were at least two variants,
> > the latter being the same as mine.
> >
> >    https://lore.kernel.org/netdev/4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com/
> >    https://lore.kernel.org/netdev/23d8e9f4-016-7de1-9737-12c3146872ca@linux.intel.com/
> >
> > This week I started looking into this issue and finally figured out
> > why we could not catch all cases with a single repro.
> >
> > Please see the source addresses of s2/s3 below after connect() fails.
> > The s2 case is another variant of the first syzbot report, which has
> > been already _fixed_.  And the s3 case is a repro for the issue that
> > Mat and I saw.
> >
> >    # sysctl -w net.ipv4.tcp_syn_retries=1
> >    net.ipv4.tcp_syn_retries = 1
> >    # python3
> >    >>> from socket import *
> >    >>>
> >    >>> s1 = socket()
> >    >>> s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> >    >>> s1.bind(('0.0.0.0', 10000))
> >    >>> s1.connect(('127.0.0.1', 10000))
> >    >>>
> >    >>> s2 = socket()
> >    >>> s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> >    >>> s2.bind(('0.0.0.0', 10000))
> >    >>> s2
> >    <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> >    >>>
> >    >>> s2.connect(('127.0.0.1', 10000))
> >    Traceback (most recent call last):
> >      File "<stdin>", line 1, in <module>
> >    OSError: [Errno 99] Cannot assign requested address
> >    >>>
> >    >>> s2
> >    <socket.socket fd=4, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('127.0.0.1', 10000)>
> >                                                                                                     ^^^ ???
> >    >>> s3 = socket()
> >    >>> s3.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> >    >>> s3.bind(('0.0.0.0', 10000))
> >    >>> s3
> >    <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> >    >>>
> >    >>> s3.connect(('0.0.0.1', 1))
> >    Traceback (most recent call last):
> >      File "<stdin>", line 1, in <module>
> >    TimeoutError: [Errno 110] Connection timed out
> >    >>>
> >    >>> s3
> >    <socket.socket fd=5, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> >
> > We can fire the WARN_ON() by s3.listen().
> >
> >    >>> s3.listen()
> >    [ 1096.845905] ------------[ cut here ]------------
> >    [ 1096.846290] WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port+0x6bb/0x9e0
> >
> > In the s3 case, connect() resets sk->sk_rcv_saddr to INADDR_ANY without
> > updating the bhash2 bucket; OTOH sk has the correct non-NULL bhash bucket.
> > So, when we call listen() for s3, inet_csk_get_port() does not call
> > inet_bind_hash() and the WARN_ON() for bhash2 fires.
> >
> >    if (!inet_csk(sk)->icsk_bind_hash)
> >       inet_bind_hash(sk, tb, tb2, port);
> >    WARN_ON(inet_csk(sk)->icsk_bind_hash != tb);
> >    WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
> >
> > Here I think the s2 case also _should_ trigger WARN_ON().  The issue
> > seems to be fixed, but it's just because we forgot to _fix_ the source
> > address in error paths after inet6?_hash_connect() in tcp_v[46]_connect().
> > (Of course, DCCP as well).
> >
> > In the s3 case, connect() falls into a different path.  We reach the
> > sock_error label in __inet_stream_connect() and call sk_prot->disconnect(),
> > which resets sk->sk_rcv_saddr.
> >
> > Then, there could be two subsequent issues.
> >
> >    * listen() leaks a newly allocated bhash2 bucket
> >
> >    * In inet_put_port(), inet_bhashfn_portaddr() computes a wrong hash for
> >      inet_csk(sk)->icsk_bind2_hash, resulting in list corruption.
> >
> > We can fix these easily but it still leaves inconsistent sockets in bhash2,
> > so we need to fix the root cause.
> >
> > As a side note, this issue only happens when we bind() only port before
> > connect().  If we do not bind() port, tcp_set_state(sk, TCP_CLOSE) calls
> > inet_put_port() and unhashes the sk from bhash2.
> >
> >
> > At first, I applied the patch below so that both sk2 and sk3 trigger
> > WARN_ON().  Then, I tried two approaches:
> >
> >    * Fix up the bhash2 entry when calling sk_rcv_saddr
> >
> >    * Change the bhash2 entry only when connect() succeeds
> >
> > The former does not work when we run out of memory.  When we change saddr
> > from INADDR_ANY, inet_bhash2_update_saddr() could free (INADDR_ANY, port)
> > bhash2 bucket.  Then, we possibly could not allocate it again when
> > restoring saddr in the failure path.
> >
> > The latter does not work when a sk is in non-blocking mode.  In this case,
> > a user might not call the second connect() to fix up the bhash2 bucket.
> >
> >    >>> s4 = socket()
> >    >>> s4.bind(('0.0.0.0', 10000))
> >    >>> s4.setblocking(False)
> >    >>> s4
> >    <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> >
> >    >>> s4.connect(('0.0.0.1', 1))
> >    Traceback (most recent call last):
> >      File "<stdin>", line 1, in <module>
> >    BlockingIOError: [Errno 115] Operation now in progress
> >    >>> s4
> >    <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('10.0.2.15', 10000)>
> >
> > Also, the former approach does not work for the non-blocking case.  Let's
> > say the second connect() fails.  What if we fail to allocate an INADDR_ANY
> > bhash2 bucket?  We have to change saddr to INADDR_ANY but cannot.... but
> > the connect() actually failed....??
> >
> >    >>> s4.connect(('0.0.0.1', 1))
> >    Traceback (most recent call last):
> >      File "<stdin>", line 1, in <module>
> >    ConnectionRefusedError: [Errno 111] Connection refused
> >    >>> s4
> >    <socket.socket fd=3, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 10000)>
> >
> >
> > Now, I'm thinking bhash2 bucket needs a refcnt not to be freed while
> > refcnt is greater than 1.  And we need to change the conflict logic
> > so that the kernel ignores empty bhash2 bucket.  Such changes could
> > be big for the net tree, but the next LTS will likely be v6.1 which
> > has bhash2.
> >
> > What do you think is the best way to fix the issue?
>
> Thanks for the repro script and the detailed analysis on the issue.  iiuc, this
> is limited to the sk that was bind() to ADDR_ANY:port-1234 (or
> !SOCK_BINDADDR_LOCK).  Does it make sense to avoid adding the sk with
> ADDR_ANY:port-1234 to bhash2 at all?  From inet_use_bhash2_on_bind(), it does
> not seem ADDR_ANY will use bhash2.  or I have missed some cases?
>

Thanks for your analysis and your repro instructions, Kuniyuki. And
apologies for being absent from bhash2 these past ~6 weeks, I've been
on PTO traveling and should have communicated that better. Thanks
Martin for taking care of bhash2 during this time.

For avoiding adding sockets with ADDR_ANY to the bhash2 hashtable, I
think the issue is that other sockets need to detect whether there's a
bind conflict against an ADDR_ANY socket on that port, so if ADDR_ANY
is not hashed to bhash2, then on binds, we would have to iterate
through the regular bhash table to check against ADDR_ANY, where the
bhash table could be very long if there are many sockets bound to that
port.

I intend to look deeply into this issue this weekend when I fly back
home and have my dev environment accessible. Kuniyuki, you mentioned
that the next LTS will likely be v6.1 which has bhash2 - do you know
what the deadline for this is for getting the fix in by?
