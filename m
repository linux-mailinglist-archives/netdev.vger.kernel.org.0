Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63D05A1BAD
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243848AbiHYVxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiHYVxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:53:17 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAF231208;
        Thu, 25 Aug 2022 14:53:15 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gb36so42028981ejc.10;
        Thu, 25 Aug 2022 14:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=EPW36v+KKVb++L701fPjwAZ4hbL6ZeWJo4xueuWRqYs=;
        b=RRDYTrvj90kKr6iXZUKIQ7/ANfKXZdLV4YPMBId4Xv7bzZTcmOxI4BTE9NOX8hWzWy
         1mdn0Z/3vgTzpjXJEDtybtuDxiqTnvzkXCW8yRbB90vffDvzVbSbPgpHQUYdgXIjrceZ
         TrWSOUcYNNqoK+4mO9PiFiFJ+MuPpI5g7qAFsFCgK+wIGvnXV4heSs5ycsvII1hNwRnZ
         jJQhKBq9oWXiamlRJ5/n2B5EkkzioZid88ZrwDOntdLxiJuZpfJYxyWQMO6HerRVGt5R
         zL8a08FAI+b6rTOMKRjRiIkcHs/Uix9fiqNUA5wXaeklngmZ5pnE4J8xMeZ82F5YNiLE
         xjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=EPW36v+KKVb++L701fPjwAZ4hbL6ZeWJo4xueuWRqYs=;
        b=dsogKaBnb0RK/4apTWgHLSDt2gDLhyWMULLBA+ZEFpJ4o1y1hq8297mJFNZ4G1j0V1
         IhHvRdDP3CEPUagOgIMiZAEGgCu824qHSE51ZGLr5VQXuQ7J8E5TiZrbw3MalIb4eQov
         ZRsypxbs0JS4EtZo2ZEyFcfOmdHKqHfvbV/2dSIGo8VjACQuzDa3bA12Gtogk0MYYzVs
         S6IYQ9Dp6mACYRrqv7sJAkPbk50srDWVF4Q3ojNnzLW9+wlQ9d9nDm4n5HTs0Y5AZPfL
         t6xuMGreY47ai8qzsLldmNzmnFkTjTTWJt34C8Xpvowj9Kr9l67uE7h6gwfaodZjQZF8
         xvFg==
X-Gm-Message-State: ACgBeo2c8fSGfZ5Gl4x1f1ONJFj/XHiFpTpjrNPo2nVShPOg3o2BBHd/
        kKvGXET7lVKuQ88v7U9WuWbP42WrVYShW378+Gm3UiGW
X-Google-Smtp-Source: AA6agR5ldV6ksNF0rFY4Q8s22mqylTDe7ye3TFIgF88gI5VacLxXBWf3seCg57pAvT3TBNKHVEd5Xx20YjzIxH7C+C4=
X-Received: by 2002:a17:907:6096:b0:73d:9d12:4b04 with SMTP id
 ht22-20020a170907609600b0073d9d124b04mr3739872ejc.745.1661464393545; Thu, 25
 Aug 2022 14:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk> <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
 <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
In-Reply-To: <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Aug 2022 14:53:02 -0700
Message-ID: <CAEf4BzbbDk_+QHoX-jJpz7Oov7H-Lhke_ZeLXp41Ay9cuYWt-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, "brouer@redhat.com" <brouer@redhat.com>,
        lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 4:04 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, 24 Aug 2022 at 20:11, Joanne Koong <joannelkoong@gmail.com> wrote=
:
> >
> > On Wed, Aug 24, 2022 at 3:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > Joanne Koong <joannelkoong@gmail.com> writes:
> > > >> [...]
> > > >> It's a bit awkward to have such a difference between xdp and skb
> > > >> dynptr's read/write. I understand why it is the way it is, but it
> > > >> still doesn't feel right. I'm not sure if we can reconcile the
> > > >> differences, but it makes writing common code for both xdp and tc
> > > >> harder as it needs to be aware of the differences (and then the fl=
ags
> > > >> for dynptr_write would differ too). So we're 90% there but not the
> > > >> whole way...
> > > >
> > > > Yeah, it'd be great if the behavior for skb/xdp progs could be the
> > > > same, but I'm not seeing a better solution here (unless we invalida=
te
> > > > data slices on writes in xdp progs, just to make it match more :P).
> > > >
> > > > Regarding having 2 different interfaces bpf_dynptr_from_{skb/xdp}, =
I'm
> > > > not convinced this is much of a problem - xdp and skb programs alre=
ady
> > > > have different interfaces for doing things (eg
> > > > bpf_{skb/xdp}_{store/load}_bytes).
> > >
> > > This is true, but it's quite possible to paper over these differences
> > > and write BPF code that works for both TC and XDP. Subtle semantic
> > > differences in otherwise identical functions makes this harder.
> > >
> > > Today you can write a function like:
> > >
> > > static inline int parse_pkt(void *data, void* data_end)
> > > {
> > >         /* parse data */
> > > }
> > >
> > > And call it like:
> > >
> > > SEC("xdp")
> > > int parse_xdp(struct xdp_md *ctx)
> > > {
> > >         return parse_pkt(ctx->data, ctx->data_end);
> > > }
> > >
> > > SEC("tc")
> > > int parse_tc(struct __sk_buff *skb)
> > > {
> > >         return parse_pkt(skb->data, skb->data_end);
> > > }
> > >
> > >
> > > IMO the goal should be to be able to do the equivalent for dynptrs, l=
ike:
> > >
> > > static inline int parse_pkt(struct bpf_dynptr *ptr)
> > > {
> > >         __u64 *data;
> > >
> > >         data =3D bpf_dynptr_data(ptr, 0, sizeof(*data));
> > >         if (!data)
> > >                 return 0;
> > >         /* parse data */
> > > }
> > >
> > > SEC("xdp")
> > > int parse_xdp(struct xdp_md *ctx)
> > > {
> > >         struct bpf_dynptr ptr;
> > >
> > >         bpf_dynptr_from_xdp(ctx, 0, &ptr);
> > >         return parse_pkt(&ptr);
> > > }
> > >
> > > SEC("tc")
> > > int parse_tc(struct __sk_buff *skb)
> > > {
> > >         struct bpf_dynptr ptr;
> > >
> > >         bpf_dynptr_from_skb(skb, 0, &ptr);
> > >         return parse_pkt(&ptr);
> > > }
> > >
> >
> > To clarify, this is already possible when using data slices, since the
> > behavior for data slices is equivalent between xdp and tc programs for
> > non-fragmented accesses. From looking through the selftests, I
> > anticipate that data slices will be the main way programs interact
> > with dynptrs. For the cases where the program may write into frags,
> > then bpf_dynptr_write will be needed (which is where functionality
> > between xdp and tc start differing) - today, we're not able to write
> > common code that writes into the frags since tc uses
> > bpf_skb_store_bytes and xdp uses bpf_xdp_store_bytes.
>
> Yes, we cannot write code that just swaps those two calls right now.
> The key difference is, the two above are separate functions already
> and have different semantics. Here in this set you have the same
> function, but with different semantics depending on ctx, which is the
> point of contention.

bpf_dynptr_{read,write}() are effectively virtual methods of dynptr
and we have few different implementations of dynptr, depending on what
data they are wrapping, so having different semantics depending on ctx
makes sense, if they are dictated by good reasons (like good
performance for skb and xdp).

>
> >
> > I'm more and more liking the idea of limiting xdp to match the
> > constraints of skb given that both you, Kumar, and Jakub have
> > mentioned that portability between xdp and skb would be useful for
> > users :)
> >
> > What are your thoughts on this API:
> >
> > 1) bpf_dynptr_data()
> >
> > Before:
> >   for skb-type progs:
> >       - data slices in fragments is not supported
> >
> >   for xdp-type progs:
> >       - data slices in fragments is supported as long as it is in a
> > contiguous frag (eg not across frags)
> >
> > Now:
> >   for skb + xdp type progs:
> >       - data slices in fragments is not supported
> >
> >
> > 2)  bpf_dynptr_write()
> >
> > Before:
> >   for skb-type progs:
> >      - all data slices are invalidated after a write
> >
> >   for xdp-type progs:
> >      - nothing
> >
> > Now:
> >   for skb + xdp type progs:
> >      - all data slices are invalidated after a write
> >
>
> There is also the other option: failing to write until you pull skb,
> which looks a lot better to me if we are adding this helper anyway...

Wouldn't this kill performance for typical cases when writes don't go
into frags?

>
> > This will unite the functionality for skb and xdp programs across
> > bpf_dyntpr_data, bpf_dynptr_write, and bpf_dynptr_read. As for whether
> > we should unite bpf_dynptr_from_skb and bpf_dynptr_from_xdp into one
> > common bpf_dynptr_from_packet as Jakub brought in [0], I'm leaning
> > towards no because 1) if in the future there's some irreconcilable
> > aspect between skb and xdp that gets added, that'll be hard to support
> > since the expectation is that there is just one overall "packet
> > dynptr" 2) the "packet dynptr" view is not completely accurate (eg
> > bpf_dynptr_write accepts flags from skb progs and not xdp progs) 3)
> > this adds some additional hardcoding in the verifier since there's no
> > organic mapping between prog type -> prog ctx
> >
>
> There is, e.g. see how btf_get_prog_ctx_type is doing it (unless I
> misunderstood what you meant).
>
> I also had a different tangential question (unrelated to
> 'reconciliation'). Let's forget about that for a moment. I was
> listening to the talk here [0]. At 12:00, I can hear someone
> mentioning that you'd have a dynptr for each segment/frag.

One of those people was me :) I think what you are referring to was an
idea that for frags we might end a special iterator function that will
call a callback for each linear frag. And in such case linear frag
will be presented to callback as dynptr (just as an interface to
statically unknown memory region, it will be DYNPTR_LOCAL at that
point, probably).

It's different from DYNPTR_SKB that Joanne is adding here, though.

>
> Right now, you have a skb/xdp dynptr, which is representing
> discontiguous memory, i.e. you represent all linear page + fragments
> using one dynptr. This seems a bit inconsistent with the idea of a
> dynptr, since it's conceptually a slice of variable length memory.
> dynptr_data gives you a constant length slice into dynptr's variable
> length memory (which the verifier can track bounds of statically).

All the data in skb is conceptually a slice of variable length memory
with no gaps in between. It's just physically discontiguous, but there
is still a linear offset addressing (conceptually). So I think it
makes sense to represent skb data as a whole as one SKB dynptr. There
are technical restrictions on direct memory access through
bpf_dynptr_data(), inevitablly.


>
> So thinking about the idea in [0], one way would be to change
> from_xdp/from_skb helpers to take an index (into the frags array), and
> return dynptr for each frag. Or determine frag from offset + len. For
> the skb case it might require kmap_atomic to access the frag dynptr,
> which might need a paired kunmap_atomic call as well, and it may not
> return dynptr for frags in cloned skbs, but for XDP multi-buff all
> that doesn't count.

We could do something like bpf_dynptr_from_skb_frag(skb, N) and get
access to frag #N (where we can special case 0 being linear skb data),
but that would be DYNPTR_LOCAL at that point, probably? And it's a
separate extension in addition to DYNPTR_SKB. Having generic
bpf_dynptr_{read,write}() working over entire skb range is very
useful, while this per-frag dynptr would prevent this. So let's keep
those two separate.

>
> Was this approach/line of thinking considered and/or rejected? What
> were the reasons? Just trying to understand the background here.
>
> What I'm wondering is that we already have helpers to do reads and
> writes that you are wrapping over in dynptr interfaces, but what we're
> missing is to be able to get direct access to frags (or 'next' ctx,
> essentially). When we know we can avoid pulls, it might be cheaper to
> then do access this way to skb, right? Especially for a case where
> just a part of the header lies in the next frag?
>
> But I'm no expert here, so I might be missing some subtleties.
>
>   [0]: https://www.youtube.com/watch?v=3DEZ5PDrXvs7M
>
>
>
>
>
>
>
>
>
> >
> > [0] https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gm=
ail.com/T/#m1438f89152b1d0e539fe60a9376482bbc9de7b6e
> >
> > >
> > > If the dynptr-based parse_pkt() function has to take special care to
> > > figure out where the dynptr comes from, it makes it a lot more diffic=
ult
> > > to write reusable packet parsing functions. So I'd be in favour of
> > > restricting the dynptr interface to the lowest common denominator of =
the
> > > skb and xdp interfaces even if that makes things slightly more awkwar=
d
> > > in the specialised cases...
> > >
> > > -Toke
> > >
