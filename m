Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB07D6549C2
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbiLWAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLWAZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:25:23 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2CCE024
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:25:22 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3b56782b3f6so47018547b3.13
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WF2KWOmtSK4+z7TybanBM+Q5rZ8GXnQ+OLGt11mjxKk=;
        b=SN9OQEfsZFurF8gUeY5Oa9Tfo5IC1tAXY490oHQywK+DYsJZwFZHwHPEf9yNTQK4ju
         tT0RSuS0S/GBjPvWYtVD4b16BDIaQ4WH0Nf268tVWJXQGJxdG/R5FtWGw9o/K5rrCxKK
         xjpQDDgE6gJGGiMEb7EuGckIPEwBFIPnYJcdi7btSeEH04v32Pi5yHcHfcR5pt935HwX
         V5G+uTC2euZ2FwNFrwZgQ/wPJ29HDFAA2AcnqCRtgglJtMAtXgxcc/ago6z9akz3TQ5n
         X2CpUInxs22TZ6MsyCLAEDT/6L8kUPry9lXdTKD0ySvH1tvxX+uOohuNGwUhg+zmKVg9
         gmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WF2KWOmtSK4+z7TybanBM+Q5rZ8GXnQ+OLGt11mjxKk=;
        b=gcOtrx8ta86M7GjXAmNdKgzh2eTLmcHVbnK9PYZlxTd6khuxQfQpkKGQKxqFMPywxr
         3JKNBDr2e43ZLWXTPtvLFbzwUgPvTvYyE/04rjSroBBu6FMM/w/YC/igMnhxybQL1J+b
         HtocuarqmtsW5LR+iE51DEoS9MZKWF1mQSgwttR/R5Tj7MX5M9pk7n8148eMBXDyyn9a
         k59CdUuGgrx/hhguMkZdVRP00vFp6pLKyBorAPZg75T20Ge16XJHHbnhVAI724FUHhM6
         xwLpK5ldcT9HhHGo9UVO3EnJA+E85XxEqsgQOu0eYfQO7RyKtGqlF06ZkQkimOqQ2tTp
         N8YA==
X-Gm-Message-State: AFqh2koS1LJJLM1vfU6kKKZ9PBFEYZ5FFks6VyhgvrV9uOExAAZI7GGy
        hrFApfji4mrPy4g2QVztS9ipMHdnPKSlmS6tlDU=
X-Google-Smtp-Source: AMrXdXvub34p4sFeUenLbN5cBjvl2XbiLPhS921Yb2xFgscmkKEgRCUPhhSFbQMLLL1nfLbq7Jd+PlyAJFg61FYKLDc=
X-Received: by 2002:a0d:eb49:0:b0:460:8f19:5ea9 with SMTP id
 u70-20020a0deb49000000b004608f195ea9mr787675ywe.21.1671755121199; Thu, 22 Dec
 2022 16:25:21 -0800 (PST)
MIME-Version: 1.0
References: <CAJnrk1YcDEFhKGmpFCULfJBwf3p8Bg-D0VPzTPRdbs4HxdDbVQ@mail.gmail.com>
 <20221222232647.95259-1-kuniyu@amazon.com>
In-Reply-To: <20221222232647.95259-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 22 Dec 2022 16:25:10 -0800
Message-ID: <CAJnrk1bRxatMSZMjzBAkw7cptU0sBwTz4k7ut8ivdyzWiPBshg@mail.gmail.com>
Subject: Re: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, jirislaby@kernel.org,
        kuba@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org,
        pabeni@redhat.com
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

On Thu, Dec 22, 2022 at 3:27 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Thu, 22 Dec 2022 13:46:57 -0800
> > On Thu, Dec 22, 2022 at 7:06 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > On Thu, 2022-12-22 at 00:12 +0900, Kuniyuki Iwashima wrote:
> > > > Jiri Slaby reported regression of bind() with a simple repro. [0]
> > > >
> > > > The repro creates a TIME_WAIT socket and tries to bind() a new socket
> > > > with the same local address and port.  Before commit 28044fc1d495 ("net:
> > > > Add a bhash2 table hashed by port and address"), the bind() failed with
> > > > -EADDRINUSE, but now it succeeds.
> > > >
> > > > The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
> > > > inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
> > > > requests if the address is not a wildcard one.
> >
> > (resending my reply because it wasn't in plaintext mode)
> >
> > Thanks for adding this! I hadn't realized TIME_WAIT sockets also are
> > considered when checking against inet bind conflicts.
> >
> > >
> > > How does keeping the timewait sockets inside bhash2 affect the bind
> > > loopup performance? I fear that could defeat completely the goal of
> > > 28044fc1d495, on quite busy server we could have quite a bit of tw with
> > > the same address/port. If so, we could even consider reverting
> > > 28044fc1d495.
>
> It will slow down along the number of twsk, but I think it's still faster
> than bhash if we listen() on multiple IP.  If we don't, bhash is always
> faster because of bhash2's additional locking.  However, this is the
> nature of bhash2 from the beginning.
>
>
> > >
> >
> > Can you clarify what you mean by bind loopup?
>
> I think it means just bhash2 traversal.  (s/loopup/lookup/)
>
> >
> > > > [0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> > > >
> > > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > > Reported-by: Jiri Slaby <jirislaby@kernel.org>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  include/net/inet_timewait_sock.h |  2 ++
> > > >  include/net/sock.h               |  5 +++--
> > > >  net/ipv4/inet_hashtables.c       |  5 +++--
> > > >  net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
> > > >  4 files changed, 37 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> > > > index 5b47545f22d3..c46ed239ad9a 100644
> > > > --- a/include/net/inet_timewait_sock.h
> > > > +++ b/include/net/inet_timewait_sock.h
> > > > @@ -44,6 +44,7 @@ struct inet_timewait_sock {
> > > >  #define tw_bound_dev_if              __tw_common.skc_bound_dev_if
> > > >  #define tw_node                      __tw_common.skc_nulls_node
> > > >  #define tw_bind_node         __tw_common.skc_bind_node
> > > > +#define tw_bind2_node                __tw_common.skc_bind2_node
> > > >  #define tw_refcnt            __tw_common.skc_refcnt
> > > >  #define tw_hash                      __tw_common.skc_hash
> > > >  #define tw_prot                      __tw_common.skc_prot
> > > > @@ -73,6 +74,7 @@ struct inet_timewait_sock {
> > > >       u32                     tw_priority;
> > > >       struct timer_list       tw_timer;
> > > >       struct inet_bind_bucket *tw_tb;
> > > > +     struct inet_bind2_bucket        *tw_tb2;
> > > >  };
> > > >  #define tw_tclass tw_tos
> > > >
> > > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > > index dcd72e6285b2..aaec985c1b5b 100644
> > > > --- a/include/net/sock.h
> > > > +++ b/include/net/sock.h
> > > > @@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
> > > >   *   @skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
> > > >   *           [union with @skc_incoming_cpu]
> > > >   *   @skc_refcnt: reference count
> > > > + *   @skc_bind2_node: bind node in the bhash2 table
> > > >   *
> > > >   *   This is the minimal network layer representation of sockets, the header
> > > >   *   for struct sock and struct inet_timewait_sock.
> > > > @@ -241,6 +242,7 @@ struct sock_common {
> > > >               u32             skc_window_clamp;
> > > >               u32             skc_tw_snd_nxt; /* struct tcp_timewait_sock */
> > > >       };
> > > > +     struct hlist_node       skc_bind2_node;
> > >
> > > I *think* it would be better adding a tw_bind2_node field to the
> > > inet_timewait_sock struct, so that we leave unmodified the request
> > > socket and we don't change the struct sock binary layout. That could
> > > affect performances moving hot fields on different cachelines.
> > >
> > +1. The rest of this patch LGTM.
>
> Then we can't use sk_for_each_bound_bhash2(), or we have to guarantee this.
>
>   BUILD_BUG_ON(offsetof(struct sock, sk_bind2_node),
>                offsetof(struct inet_timewait_sock, tw_bind2_node))
>
> Considering the number of members in struct sock, at least we have
> to move sk_bind2_node forward.
>
> Another option is to have another TIME_WAIT list in inet_bind2_bucket like
> tb2->deathrow or something.  sk_for_each_bound_bhash2() is used only in
> inet_bhash2_conflict(), so I think this is feasible.

Oh I see, thanks for clarifying!

I think we could also check sk_state (which is in __sk_common already)
and if it's TCP_TIME_WAIT, then we know sk is at offsetof(struct
inet_timewait_sock, tw_bind2_node), whereas otherwise it's at
offsetof(struct sock, sk_bind2_node). This seems simpler/cleaner to me
than the other approaches. What are your thoughts?
