Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894DC654808
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 22:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiLVVrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 16:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLVVrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 16:47:09 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6E13D4E
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 13:47:08 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id o127so3473109yba.5
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 13:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IHKW/UYh8AR6b99fJnCGGe38aX1RLSFdq4cd+6sQxnU=;
        b=R5dVmWX9uznVV/vbtqSxZZhyCpGi2J4HUY07dFhPBBo7QZC64Vm582eE/BzVtryodX
         HHxK9TSnovmCQghXHIH9ASBjI4c+d9HTN1UljDEu+/2ZwFJH/TeFp5OUbVNRqE1xP6uk
         kb3w8T9255G1reCgW4ruvDZmKEcYVvJj/1UlLIexsI6J6R7AH08r/43/ITjwnvuwLnF8
         ZQRZs6g6xN0nszBQkcqPZCMk75Up0hsPxiqegme2wKe+Z8wBpQ0+IBtKZ+xPactqDHQe
         s/1Xljev1reQTBJOjDnIeb1RkoT/i6fxxndix9emWt06IC1Kh4jL1ETlw6iEJ/IcC91T
         naiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHKW/UYh8AR6b99fJnCGGe38aX1RLSFdq4cd+6sQxnU=;
        b=pJOQH5AZOKE5V4kp/9WH2zBp9/9FRspmAT0C/JaiTKUUuVryMDe9LYMqlUpuShpiMj
         /FTGfqU9WUq2GK0OCqIFiXuy9SquDXJVvYPnY+VnP8KkUcYQriJEFVgmPJhOHgxkKFwS
         8SckjIYDvnrWa0V0F6tNK4Nx7rN00qxzsRdOdvTZQ8m/Yw7jCFLWF/bNoY5margU1n8o
         nLE+Ej86W/cff9zHMRpjooIXT9UoXQLbfp8QdrP6X7ln8C+cw+4/BwcyX7TklL+MDlNu
         UgYu7R278g19UL0beI1z1oJfD2KZFD+ysMggFIL2txbcPIei+3J5NiGk2bP0iua0Y4SE
         a2Rg==
X-Gm-Message-State: AFqh2krgl9WOs3g9n3PaLFEEF2lLxmQOyA+mcuIrYQ0YxtcTERpgu8N/
        1dfUDaRxjv8smLOh3ugvKs6Wi+3l5ETaFjEPHxo=
X-Google-Smtp-Source: AMrXdXuM0vFKOz9E33an+lP9VwepId+FMAYPRCcptYUgKY/3yLZoEbWj+3bwSXPKIG9G90R5pgA/LhC1gc9KGg6jFFs=
X-Received: by 2002:a25:f03:0:b0:718:7dec:7137 with SMTP id
 3-20020a250f03000000b007187dec7137mr472898ybp.129.1671745628110; Thu, 22 Dec
 2022 13:47:08 -0800 (PST)
MIME-Version: 1.0
References: <20221221151258.25748-1-kuniyu@amazon.com> <20221221151258.25748-2-kuniyu@amazon.com>
 <95544fb4dd85d5acaca883bb8bae0e43821758bd.camel@redhat.com>
In-Reply-To: <95544fb4dd85d5acaca883bb8bae0e43821758bd.camel@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 22 Dec 2022 13:46:57 -0800
Message-ID: <CAJnrk1YcDEFhKGmpFCULfJBwf3p8Bg-D0VPzTPRdbs4HxdDbVQ@mail.gmail.com>
Subject: Re: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
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

On Thu, Dec 22, 2022 at 7:06 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-12-22 at 00:12 +0900, Kuniyuki Iwashima wrote:
> > Jiri Slaby reported regression of bind() with a simple repro. [0]
> >
> > The repro creates a TIME_WAIT socket and tries to bind() a new socket
> > with the same local address and port.  Before commit 28044fc1d495 ("net:
> > Add a bhash2 table hashed by port and address"), the bind() failed with
> > -EADDRINUSE, but now it succeeds.
> >
> > The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
> > inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
> > requests if the address is not a wildcard one.

(resending my reply because it wasn't in plaintext mode)

Thanks for adding this! I hadn't realized TIME_WAIT sockets also are
considered when checking against inet bind conflicts.

>
> How does keeping the timewait sockets inside bhash2 affect the bind
> loopup performance? I fear that could defeat completely the goal of
> 28044fc1d495, on quite busy server we could have quite a bit of tw with
> the same address/port. If so, we could even consider reverting
> 28044fc1d495.
>

Can you clarify what you mean by bind loopup?

> > [0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> >
> > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > Reported-by: Jiri Slaby <jirislaby@kernel.org>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  include/net/inet_timewait_sock.h |  2 ++
> >  include/net/sock.h               |  5 +++--
> >  net/ipv4/inet_hashtables.c       |  5 +++--
> >  net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
> >  4 files changed, 37 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> > index 5b47545f22d3..c46ed239ad9a 100644
> > --- a/include/net/inet_timewait_sock.h
> > +++ b/include/net/inet_timewait_sock.h
> > @@ -44,6 +44,7 @@ struct inet_timewait_sock {
> >  #define tw_bound_dev_if              __tw_common.skc_bound_dev_if
> >  #define tw_node                      __tw_common.skc_nulls_node
> >  #define tw_bind_node         __tw_common.skc_bind_node
> > +#define tw_bind2_node                __tw_common.skc_bind2_node
> >  #define tw_refcnt            __tw_common.skc_refcnt
> >  #define tw_hash                      __tw_common.skc_hash
> >  #define tw_prot                      __tw_common.skc_prot
> > @@ -73,6 +74,7 @@ struct inet_timewait_sock {
> >       u32                     tw_priority;
> >       struct timer_list       tw_timer;
> >       struct inet_bind_bucket *tw_tb;
> > +     struct inet_bind2_bucket        *tw_tb2;
> >  };
> >  #define tw_tclass tw_tos
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index dcd72e6285b2..aaec985c1b5b 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
> >   *   @skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
> >   *           [union with @skc_incoming_cpu]
> >   *   @skc_refcnt: reference count
> > + *   @skc_bind2_node: bind node in the bhash2 table
> >   *
> >   *   This is the minimal network layer representation of sockets, the header
> >   *   for struct sock and struct inet_timewait_sock.
> > @@ -241,6 +242,7 @@ struct sock_common {
> >               u32             skc_window_clamp;
> >               u32             skc_tw_snd_nxt; /* struct tcp_timewait_sock */
> >       };
> > +     struct hlist_node       skc_bind2_node;
>
> I *think* it would be better adding a tw_bind2_node field to the
> inet_timewait_sock struct, so that we leave unmodified the request
> socket and we don't change the struct sock binary layout. That could
> affect performances moving hot fields on different cachelines.
>
+1. The rest of this patch LGTM.

>
> Thanks,
>
> Paolo
>
