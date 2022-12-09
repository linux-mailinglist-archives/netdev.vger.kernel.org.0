Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14949648397
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiLIORY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLIORE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:17:04 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63247723D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 06:16:48 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id o127so5658036yba.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 06:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7LlfAQWpPNLuhOgcUZ4tUXnEA1fFuup+0DIajKdSqk=;
        b=fGQBPTJJzLXlXiBSV/dp2MY0Y7S9JALxm7neMKI6NAPPeM6sjCXwJ97CJkvftDVqQV
         j+pwbzD7mmLknkWlCNQWgJZWPtwuGSynrExWnipZNN4LoqH+/6cLgBTbdR4Sgzs9ih9N
         t0gCEBt2YbnKHbwmYcMjgg8eiaqEn80lNuxOplx8uaDb1+5Cl1p+mrjbWOpHo31LlJxP
         dRojfE15wK7U3RFp21T7t8aOOGRWQrARkBHNukcMpjxcNonLxmx4ycHxEI3PeXV+mhFH
         /rGYeLD+SbM2OdTR7UcFAGJLChheMYK0iuNnrWipVZFEE7QssIW1TweRD6nHyB1QjtRK
         uiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7LlfAQWpPNLuhOgcUZ4tUXnEA1fFuup+0DIajKdSqk=;
        b=JA4gBDpOBsmK4qXH8yj7FORYksltanVuzTXZJ6+InOR34osy6Key0DvMlnxY5PzJef
         J/CLPgiMYS2P4lIIkrNfl6WwPaECz/kUQCicklTlKHEKYO8LHd+iix8cWP1Cpn8UKmri
         j4PcMs9VkpQx9bgBmaJn/jVey0Alefhj3w7hQv+iovaEeuV+3Y66Q0XLzqScPxCE09kV
         gM2xApvPQ9zIl9iazXYYs3R5AKPycUOqQkyF7+Wg8eULc27xuXV/lhyAa2LJ9yvJqIY4
         B/rIwT00Woi0Y+pvenc+JGL9/34xjZcdLCcBErVx9iALzHRdI6Xfg29fscGDt6GC11Ch
         tqUQ==
X-Gm-Message-State: ANoB5pnBiNPz6EDqJ8xoFSovHw9o6WdjUlehC+ubFGGX8l0aIIhhK2EQ
        hCdJLOFVqj3VjH2YH4KuNGYT4iLGu2UrZ9lwOcibAA==
X-Google-Smtp-Source: AA0mqf6tHhXvuN6Qou0YdVkyqknrQqaBGj9FXVdmscxICIC5lyIJ3FMEDDhoEvcVbc2GOYJsZULXeCdD53vc/PC4oB4=
X-Received: by 2002:a25:445:0:b0:703:657f:9c91 with SMTP id
 66-20020a250445000000b00703657f9c91mr9904740ybe.387.1670595407569; Fri, 09
 Dec 2022 06:16:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1669036433.git.bcodding@redhat.com> <d9041e542ade6af472c7be14b5a28856692815cf.1669036433.git.bcodding@redhat.com>
 <dd5260c621d3cf8733fab6287a8182b821c937c5.camel@redhat.com>
In-Reply-To: <dd5260c621d3cf8733fab6287a8182b821c937c5.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Dec 2022 15:16:36 +0100
Message-ID: <CANn89iKx041Sdfk2q5GHW6FBsj17zzmqPBZVFJchziNyzc0XSQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] net: Introduce sk_use_task_frag in struct sock.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Benjamin Coddington <bcodding@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Menglong Dong <imagedong@tencent.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 9, 2022 at 1:09 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-11-21 at 08:35 -0500, Benjamin Coddington wrote:
> > From: Guillaume Nault <gnault@redhat.com>
> >
> > Sockets that can be used while recursing into memory reclaim, like
> > those used by network block devices and file systems, mustn't use
> > current->task_frag: if the current process is already using it, then
> > the inner memory reclaim call would corrupt the task_frag structure.
> >
> > To avoid this, sk_page_frag() uses ->sk_allocation to detect sockets
> > that mustn't use current->task_frag, assuming that those used during
> > memory reclaim had their allocation constraints reflected in
> > ->sk_allocation.
> >
> > This unfortunately doesn't cover all cases: in an attempt to remove all
> > usage of GFP_NOFS and GFP_NOIO, sunrpc stopped setting these flags in
> > ->sk_allocation, and used memalloc_nofs critical sections instead.
> > This breaks the sk_page_frag() heuristic since the allocation
> > constraints are now stored in current->flags, which sk_page_frag()
> > can't read without risking triggering a cache miss and slowing down
> > TCP's fast path.
> >
> > This patch creates a new field in struct sock, named sk_use_task_frag,
> > which sockets with memory reclaim constraints can set to false if they
> > can't safely use current->task_frag. In such cases, sk_page_frag() now
> > always returns the socket's page_frag (->sk_frag). The first user is
> > sunrpc, which needs to avoid using current->task_frag but can keep
> > ->sk_allocation set to GFP_KERNEL otherwise.
> >
> > Eventually, it might be possible to simplify sk_page_frag() by only
> > testing ->sk_use_task_frag and avoid relying on the ->sk_allocation
> > heuristic entirely (assuming other sockets will set ->sk_use_task_frag
> > according to their constraints in the future).
> >
> > The new ->sk_use_task_frag field is placed in a hole in struct sock and
> > belongs to a cache line shared with ->sk_shutdown. Therefore it should
> > be hot and shouldn't have negative performance impacts on TCP's fast
> > path (sk_shutdown is tested just before the while() loop in
> > tcp_sendmsg_locked()).
> >
> > Link: https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  include/net/sock.h | 11 +++++++++--
> >  net/core/sock.c    |  1 +
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index d08cfe190a78..ffba9e95470d 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -318,6 +318,9 @@ struct sk_filter;
> >    *  @sk_stamp: time stamp of last packet received
> >    *  @sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
> >    *  @sk_tsflags: SO_TIMESTAMPING flags
> > +  *  @sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
> > +                        Sockets that can be used under memory reclaim should
> > +                        set this to false.
> >    *  @sk_bind_phc: SO_TIMESTAMPING bind PHC index of PTP virtual clock
> >    *                for timestamping
> >    *  @sk_tskey: counter to disambiguate concurrent tstamp requests
> > @@ -504,6 +507,7 @@ struct sock {
> >  #endif
> >       u16                     sk_tsflags;
> >       u8                      sk_shutdown;
> > +     bool                    sk_use_task_frag;
> >       atomic_t                sk_tskey;
> >       atomic_t                sk_zckey;
>
> I think the above should be fine from a data locality PoV, as the used
> cacheline should be hot at sk_page_frag_refill() usage time, as
> sk_tsflags has been accessed just before.
>
> @Eric, does the above fit with the planned sock fields reordering?

Do not worry about that, this can be handled later if needed.

>
> Jakub noted we could use a bitfield here to be future proof for
> additional flags addition. I think in this specific case a bool is
> preferable, because we actually wont to discourage people to add more
> of such flags, and the search for holes (or the bool -> bitflag
> conversion) should give to such eventual future changes some additional
> thoughts.
>
> Thanks!
>
> Paolo
>
