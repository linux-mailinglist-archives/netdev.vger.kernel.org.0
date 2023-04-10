Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC196DC3CC
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 09:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjDJH04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 03:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDJH0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 03:26:55 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F823ABE
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 00:26:53 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t14so5250209lft.7
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 00:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681111612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyWMiGLiBSGrqrCSEkNM48kxRA7c0sNIDX0ddCU3Als=;
        b=haRkcXvnIecQzG4V4lkNcR39XNNAfMfrl08SRG0Mp72GPZbkLOMzKZMZ3cpmsfP+dL
         y3jYPd6Tbhcskrd0HgXYqmMwIzi/6jJK2kNuJRgkdeTpVbLssFaW6w9fY8cqbKiVzZpP
         r38zNU7G9XfHwBmB2kKcLvKTOltMr1CeZgdxn0WrGlCQ/5wCx+GD8DdDNNi2v6Oyjdqf
         n02yuf9DV14/6iy8K6GrvELlmwSbkB1SLjFDG+2uaSq58D8bT/Vej6YxVlWXVrHDkc39
         p19qxGLw1zxtvh4n6EywgCvLSeMJo8biWmDuJySOx2WLHyQ+VMFzORu+DwvdZKyZJasA
         c5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681111612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FyWMiGLiBSGrqrCSEkNM48kxRA7c0sNIDX0ddCU3Als=;
        b=RnW+osgokWjdljbuiqFoP2J9fGLk1h5LwyC40s8Mttk67ngJM+f/EI1X7ezYL2H1sh
         1unB7NZCuaZs+N/tpfXho359RvVU9EBKtj+7TokhZD6D/1qvAGWnZg0HTUvY5CEm8o7E
         lT6VXC/ANLG3iWmJHPL9jVXpH85rgwdEUsWcAMC7/cNnda0FUD+qgcrZNB2mpnRa44bJ
         ZL26XUgVGBBHAkGf43dhQa57+UKNqqWtNHCmmfUKbJ9rvzQZ7rZoiAsslkBs8gz0JzfL
         V75ud5A2GJVQbv4xw/wB49rtQv8XjYmnqrWlDjqPhWEcUcmDdkhnTJjTnSFNyiHk8aPz
         6nUw==
X-Gm-Message-State: AAQBX9fWkKgoEMzC5CjJuV83O1eHIXyEeaGygbc1vMyEDl7R3WgRtZiX
        7zHQ4ClW3ZGFfmmMTgJWQjfLkzONAJa5AukGuts=
X-Google-Smtp-Source: AKy350YGNe6yeMhHU+R4601J9hF6x+1OmQgShGb42/rG3JrrasfCI29mkmyPDhqkDq/eavJvWHQxAiO/f+Z74nHRqtI=
X-Received: by 2002:a19:7018:0:b0:4dd:9eb6:444e with SMTP id
 h24-20020a197018000000b004dd9eb6444emr2616409lfc.5.1681111611478; Mon, 10 Apr
 2023 00:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230406114825.18597-1-liangchen.linux@gmail.com>
 <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com> <CAC_iWjJ_30s898KhBQNy7jO_xNtxnz5BqgjE5OCxTzE+hQSP+g@mail.gmail.com>
In-Reply-To: <CAC_iWjJ_30s898KhBQNy7jO_xNtxnz5BqgjE5OCxTzE+hQSP+g@mail.gmail.com>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Mon, 10 Apr 2023 15:26:15 +0800
Message-ID: <CAKhg4tKo66gPNvoQuk8hEBEt+5J=DfJAgYs_8AncFmrDh1rZAQ@mail.gmail.com>
Subject: Re: [PATCH v2] skbuff: Fix a race between coalescing and releasing SKBs
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>, kuba@kernel.org,
        hawk@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 7, 2023 at 4:03=E2=80=AFPM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi all,
>
> On Thu, 6 Apr 2023 at 18:25, Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Thu, 2023-04-06 at 19:48 +0800, Liang Chen wrote:
> > > Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> > > recycling") allowed coalescing to proceed with non page pool page and
> > > page pool page when @from is cloned, i.e.
> > >
> > > to->pp_recycle    --> false
> > > from->pp_recycle  --> true
> > > skb_cloned(from)  --> true
> > >
> > > However, it actually requires skb_cloned(@from) to hold true until
> > > coalescing finishes in this situation. If the other cloned SKB is
> > > released while the merging is in process, from_shinfo->nr_frags will =
be
> > > set to 0 towards the end of the function, causing the increment of fr=
ag
> > > page _refcount to be unexpectedly skipped resulting in inconsistent
> > > reference counts. Later when SKB(@to) is released, it frees the page
> > > directly even though the page pool page is still in use, leading to
> > > use-after-free or double-free errors.
> > >
> > > So it needs to be specially handled at where the ref count may get lo=
st.
> > >
> > > The double-free error message below prompted us to investigate:
> > > BUG: Bad page state in process swapper/1  pfn:0e0d1
> > > page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
> > > index:0x2 pfn:0xe0d1
> > > flags: 0xfffffc0000000(node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> > > raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000=
000
> > > raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000=
000
> > > page dumped because: nonzero _refcount
> > >
> > > CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
> > > Call Trace:
> > >  <IRQ>
> > > dump_stack_lvl+0x32/0x50
> > > bad_page+0x69/0xf0
> > > free_pcp_prepare+0x260/0x2f0
> > > free_unref_page+0x20/0x1c0
> > > skb_release_data+0x10b/0x1a0
> > > napi_consume_skb+0x56/0x150
> > > net_rx_action+0xf0/0x350
> > > ? __napi_schedule+0x79/0x90
> > > __do_softirq+0xc8/0x2b1
> > > __irq_exit_rcu+0xb9/0xf0
> > > common_interrupt+0x82/0xa0
> > > </IRQ>
> > > <TASK>
> > > asm_common_interrupt+0x22/0x40
> > > RIP: 0010:default_idle+0xb/0x20
> > >
> > > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > > ---
> > > Changes from v1:
> > > - deal with the ref count problem instead of return back to give more=
 opportunities to coalesce skbs.
> > > ---
> > >  net/core/skbuff.c | 22 ++++++++++++++++++++--
> > >  1 file changed, 20 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 050a875d09c5..77da8ce74a1e 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5643,7 +5643,19 @@ bool skb_try_coalesce(struct sk_buff *to, stru=
ct sk_buff *from,
> > >
> > >               skb_fill_page_desc(to, to_shinfo->nr_frags,
> > >                                  page, offset, skb_headlen(from));
> > > -             *fragstolen =3D true;
> > > +
> > > +             /* When @from is pp_recycle and @to isn't, coalescing i=
s
> > > +              * allowed to proceed if @from is cloned. However if th=
e
> > > +              * execution reaches this point, @from is already trans=
itioned
> > > +              * into non-cloned because the other cloned skb is rele=
ased
> > > +              * somewhere else concurrently. In this case, we need t=
o make
> > > +              * sure the ref count is incremented, not directly stea=
ling
> > > +              * from page pool.
> > > +              */
> > > +             if (to->pp_recycle !=3D from->pp_recycle)
> > > +                     get_page(page);
> > > +             else
> > > +                     *fragstolen =3D true;
> > >       } else {
> > >               if (to_shinfo->nr_frags +
> > >                   from_shinfo->nr_frags > MAX_SKB_FRAGS)
> > > @@ -5659,7 +5671,13 @@ bool skb_try_coalesce(struct sk_buff *to, stru=
ct sk_buff *from,
> > >              from_shinfo->nr_frags * sizeof(skb_frag_t));
> > >       to_shinfo->nr_frags +=3D from_shinfo->nr_frags;
> > >
> > > -     if (!skb_cloned(from))
> > > +     /* Same situation as above where head data presents. When @from=
 is
> > > +      * pp_recycle and @to isn't, coalescing is allowed to proceed i=
f @from
> > > +      * is cloned. However @from can be transitioned into non-cloned
> > > +      * concurrently by this point. If it does happen, we need to ma=
ke sure
> > > +      * the ref count is properly incremented.
> > > +      */
> > > +     if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from)=
)
> > >               from_shinfo->nr_frags =3D 0;
> > >
> > >       /* if the skb is not cloned this does nothing
> >
> > So looking this over I believe this should resolve the issue you
> > pointed out while maintaining current functionality.
> >
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>
> Yes, this would work, but I am not sure we really want this here.
> Is coalescing page-pool-owned and slab-owned SKBs frequent to justify
> the additional overhead? If the answer is yes, the patch seems fine
>
> Thanks
> /Ilias

We did some analysis on the frequency of the case where the following
condition were met when entering the function,

to->pp_recycle    --> false
from->pp_recycle  --> true
skb_cloned(from)  --> true

with our networking setup (mtu 1500), there was no such occurrence. It
was only when we limited the packet size down to 256 bytes we started
to observe very few occurrences (less than 1%). And it was not
significant enough to show any difference in our performance test.

So it seems the performance gain does not justify the additional
overhead. Can you please consider the v1 patch instead?

Thanks,
Liang
> >
> > One follow-on that we may want to do with this would be to look at
> > consolidating the 3 spots where we are checking for our combination of
> > pp_recycle comparison and skb_cloned and maybe pass one boolean flag
> > indicating that we have to transfer everything by taking page
> > references.
> >
> > Also I think we can actually increase the number of cases where we
> > support coalescing if we were to take apart the skb_head_is_locked call
> > and move the skb_cloned check from it into your recycle check in the
> > portion where we are stealing from the header.
