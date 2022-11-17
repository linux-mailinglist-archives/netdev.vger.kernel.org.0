Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E486462CFE1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiKQAnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiKQAnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:43:39 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C023FAF6;
        Wed, 16 Nov 2022 16:43:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f18so1296759ejz.5;
        Wed, 16 Nov 2022 16:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G0JZgfmoTRJ9qki/8BmeWQL1Plg/Ovwl2c/+gVPN6Ig=;
        b=fiH0kEJH5/gtDC+r4Uwg4VlxxUtSJgxWmLI2vEOaIzEvSjO85/NsIAMrNxJYh4dQTE
         f25jE9lyu8cLKbD+CdtJvPiytu9zzZcXPJKTRCNLMm0CexQsK6nbelEOeNTYO8idQ6zE
         fUCDIcCMHZIJV5j2LUGwb04X20fzXvhSoC9wiXvQRAs7pkE82wF096WJ1es3SpRwy7Sg
         YeBTuVsIO96PClber0an5a7mAbcf16Wd0TrB2lAFgxKpAVGPTuEkh2pBlmpB9a52ThgF
         kM0JsO274TGKhE/8lgNZtQDhIAch0U2p8mjq4a8mjqXXatkQwDz7yYDu72Aa8LA1mKn0
         zhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G0JZgfmoTRJ9qki/8BmeWQL1Plg/Ovwl2c/+gVPN6Ig=;
        b=hzpsHcOmTfJNrainSI8dzuSUt1oe+KE4KOetgbqtL2WYZCqhxL4jBA+2H0vot+vXcr
         PC77f4tgVzv0RmO9zh6+758aKy+m94gMboFnKM34w9bDdv7SU/Ni2L9tZoB+T7tBWU8y
         /TkzZGFwYzar+B0N8WZltJXZeE4O/fqgq3Ayt1g551AFnGzfUPspMTGj6lMKb0WB9oV3
         NvQDgtxtdO8iB7hmqewQYzlxHZ/kjEnBjb2hSYYit404WlxCIOEBhkZ+NYtSvmD3WIUs
         hB4SBp10jdFP64lTsm/rmANJAUTGmrW3WDtQWvem2ysJa2ndpRjzNXTiFfJNV/3IJ2xF
         4AzA==
X-Gm-Message-State: ANoB5plgBlir9T83FHKy1a5TJlJmcvjEFOoMCvBmM+JbsMugNuPEm0Uj
        SIGZLoPF+RqGLxGrxyZU4GoP78VKZGAXmQa8YrY=
X-Google-Smtp-Source: AA0mqf451mHT07+xk42knksjpt8i+OeirT/pIIILE+JNzJoxdHGAKBoUQkY15/lms0TxasFCBZxLmAT1xSpjI4n2J2U=
X-Received: by 2002:a17:906:2614:b0:7ad:934e:95d3 with SMTP id
 h20-20020a170906261400b007ad934e95d3mr242184ejc.393.1668645814333; Wed, 16
 Nov 2022 16:43:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJnrk1YOfyGQ2Vic9xkoSj+uv7fuYAwh4wFLv1cBJ5LPiHsEvw@mail.gmail.com>
 <20221117002010.72675-1-kuniyu@amazon.com>
In-Reply-To: <20221117002010.72675-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 16 Nov 2022 16:43:23 -0800
Message-ID: <CAJnrk1a5tBLmyVwCq6utOs-c5DBO4QhCNJ0V4LwZXUW20n_ZMg@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/4] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     acme@mandriva.com, davem@davemloft.net, dccp@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, martin.lau@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, pengfei.xu@intel.com,
        stephen@networkplumber.org, william.xuanziyang@huawei.com,
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

On Wed, Nov 16, 2022 at 4:20 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Wed, 16 Nov 2022 16:11:21 -0800
> > On Wed, Nov 16, 2022 at 2:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > When connect() is called on a socket bound to the wildcard address,
> > > we change the socket's saddr to a local address.  If the socket
> > > fails to connect() to the destination, we have to reset the saddr.
> > >
> > > However, when an error occurs after inet_hash6?_connect() in
> > > (dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
> > > the socket bound to the address.
> > >
> > > From the user's point of view, whether saddr is reset or not varies
> > > with errno.  Let's fix this inconsistent behaviour.
> > >
> > > Note that after this patch, the repro [0] will trigger the WARN_ON()
> > > in inet_csk_get_port() again, but this patch is not buggy and rather
> > > fixes a bug papering over the bhash2's bug for which we need another
> > > fix.
> > >
> > > For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
> > > by this sequence:
> > >
> > >   s1 = socket()
> > >   s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > >   s1.bind(('127.0.0.1', 10000))
> > >   s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
> > >   # or s1.connect(('127.0.0.1', 10000))
> > >
> > >   s2 = socket()
> > >   s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> > >   s2.bind(('0.0.0.0', 10000))
> > >   s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL
> > >
> > >   s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
> > >
> > > [0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
> > >
> > > Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> > > Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> >
> > LGTM. Btw, the 4th patch in this series overwrites these changes by
> > moving this logic into the new inet_bhash2_reset_saddr() function you
> > added, so we could also drop this patch from the series. OTOH, this
> > commit message in this patch has some good background context. So I
> > don't have a preference either way :)
> >
> > Acked-by: Joanne Koong <joannelkoong@gmail.com>
>
> Thanks for reviewing!
>
> Yes, these changes are overwritten later, but only this patch can be
> backported to other stable versions, so I kept this separated.
>

Gotcha, that makes sense! I will try to get my review of the other 2
patches by tomorrow or Friday.

Thanks for your work on this!

>
> > > ---
> > >  net/dccp/ipv4.c     | 2 ++
> > >  net/dccp/ipv6.c     | 2 ++
> > >  net/ipv4/tcp_ipv4.c | 2 ++
> > >  net/ipv6/tcp_ipv6.c | 2 ++
> > >  4 files changed, 8 insertions(+)
> > >
> > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > index 713b7b8dad7e..40640c26680e 100644
> > > --- a/net/dccp/ipv4.c
> > > +++ b/net/dccp/ipv4.c
> > > @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >          * This unhashes the socket and releases the local port, if necessary.
> > >          */
> > >         dccp_set_state(sk, DCCP_CLOSED);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >         ip_rt_put(rt);
> > >         sk->sk_route_caps = 0;
> > >         inet->inet_dport = 0;
> > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > index e57b43006074..626166cb6d7e 100644
> > > --- a/net/dccp/ipv6.c
> > > +++ b/net/dccp/ipv6.c
> > > @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >
> > >  late_failure:
> > >         dccp_set_state(sk, DCCP_CLOSED);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >         __sk_dst_reset(sk);
> > >  failure:
> > >         inet->inet_dport = 0;
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index 87d440f47a70..6a3a732b584d 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > >          * if necessary.
> > >          */
> > >         tcp_set_state(sk, TCP_CLOSE);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >         ip_rt_put(rt);
> > >         sk->sk_route_caps = 0;
> > >         inet->inet_dport = 0;
> > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > index 2a3f9296df1e..81b396e5cf79 100644
> > > --- a/net/ipv6/tcp_ipv6.c
> > > +++ b/net/ipv6/tcp_ipv6.c
> > > @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > >
> > >  late_failure:
> > >         tcp_set_state(sk, TCP_CLOSE);
> > > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > > +               inet_reset_saddr(sk);
> > >  failure:
> > >         inet->inet_dport = 0;
> > >         sk->sk_route_caps = 0;
> > > --
> > > 2.30.2
