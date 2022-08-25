Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795AF5A1A1E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbiHYUPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243088AbiHYUPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:15:10 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666E9A3D2E;
        Thu, 25 Aug 2022 13:15:08 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lx1so5242139ejb.12;
        Thu, 25 Aug 2022 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Lq/r+Bw2f+S5t9wt/C9Vth8MmBQwk6ZJR81xJ1GWMbg=;
        b=Jdu4vOZ9iYnPWMavC4kRq1HIWVkHtG7zcbiqkRlacmIiBjcqUOAVSWv0uxgjIjzm5i
         qUiPKSH3lrWjhu+VG8xi+HtB4KrKh6nRFXTVSvsQzTLAFW5UDGvGOGZ8wu6LVTC8Px1C
         +jYmgfQ6Xu+44UzK4vmJNCK3n1iACihW6Ai0t0/7IudIQmMLs2Jq3fQZCvuOifZprqoc
         ODWcGGN7T0+HBlGM6/SNGjXvZ4xy2XkBc5edG8xWUyBM93IuEk6rznU6EmiMvh0rxnmx
         Az0E/gIcJ9xT3xp0HTIaFgQqM1Cq14ueRdko5Sl8Xhnr+x9l9QCSea/ZDUg90NhoFYrM
         ARVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=Lq/r+Bw2f+S5t9wt/C9Vth8MmBQwk6ZJR81xJ1GWMbg=;
        b=tXHWfKX7zCZWQSa9KJBdklD8ChlJQHi3SDKOJeUickQe8jbLsDI6gSeLv+p6pk8LAc
         vSBPjIPBJ6eD9232voy6P7AGGgbW9Ij5kQ683Lwd5MFYH2tt2y9LJgQHYIYc/pYSbUkl
         FgXS61RMkvRoYI4KGGo0PaWmP+qHzC2lcU+czfyUgofQZYQlz+0opJ+WKjrhUuSrqnPn
         Di7QbBAbuWhBOi6maL4UEJ4/WKufcqcIhHvTKokrjYuKMcQ/1WefxDqY0lS9cP12QP9I
         cXrwgVT9j95bjpCImtHVDJHqj5JyIT8WlSIAY0TI7YzhMPS7KrXVVvw6JWC/8NtYWnm6
         bPDg==
X-Gm-Message-State: ACgBeo2I3rKQS4vy+WYzr3tfWpcqzgDa77jh4frGetvxhjSzan2yvtTR
        5Ds5OsSKe+xRiLYS+/CNOKxWVqUJXpaUTRx0f6k=
X-Google-Smtp-Source: AA6agR42hT5g1DbKP3bQVgwb+XAbJJ041YoL/0WFozoftDsVasmhkDxQN7Vut7N3wuFIsrNQ2hwEjynxOTil4JFhD6Q=
X-Received: by 2002:a17:907:b013:b0:73d:c708:3f22 with SMTP id
 fu19-20020a170907b01300b0073dc7083f22mr3364047ejc.608.1661458506855; Thu, 25
 Aug 2022 13:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk> <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
 <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
In-Reply-To: <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 25 Aug 2022 13:14:55 -0700
Message-ID: <CAJnrk1Z4a+5Wo9N+HUr-JyeZ-Qbzxb9OWePZ+w0cOMpDmmAu9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

This was also previously discussed in [0].

After using skb dynptrs for the test_cls_redirect_dynptr.c selftest
[1], I'm convinced that allowing bpf_dynptr_writes into frags is the
correct way to go. There are instances where the data is probably in
head with a slight off-chance that it's in a fragment - being able to
call bpf_dynptr_write makes it super easy whereas the alternative is
either 1) always pulling, which in most cases will be unnecessary or
2) adding special casing for the case where the bpf_dynptr_write
fails. As well, failing to write until you pull the skb will hurt
being able to write common code that both xdp/skb can use.


[0] https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.=
com/T/#md6c17d9916f5937a9ae9dfca11e815e4b89009fb

[1] https://lore.kernel.org/bpf/20220822235649.2218031-4-joannelkoong@gmail=
.com/

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

Cool, that should be pretty straightforwarwd then; from what it looks
like, btf_get_prog_ctx_type() + 1 will give the btf id and then from
that use btf_type_by_id() to get the corresponding struct btf_type,
then use btf_type->name_off to check whether the name corresponds to
"__sk_buff" or "xdp_md"

>
> I also had a different tangential question (unrelated to
> 'reconciliation'). Let's forget about that for a moment. I was
> listening to the talk here [0]. At 12:00, I can hear someone
> mentioning that you'd have a dynptr for each segment/frag.
>
> Right now, you have a skb/xdp dynptr, which is representing
> discontiguous memory, i.e. you represent all linear page + fragments
> using one dynptr. This seems a bit inconsistent with the idea of a
> dynptr, since it's conceptually a slice of variable length memory.
> dynptr_data gives you a constant length slice into dynptr's variable
> length memory (which the verifier can track bounds of statically).
>
> So thinking about the idea in [0], one way would be to change
> from_xdp/from_skb helpers to take an index (into the frags array), and
> return dynptr for each frag. Or determine frag from offset + len. For
> the skb case it might require kmap_atomic to access the frag dynptr,
> which might need a paired kunmap_atomic call as well, and it may not
> return dynptr for frags in cloned skbs, but for XDP multi-buff all
> that doesn't count.
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

Imo, having a separate dynptr for each frag is confusing for users. My
intuition is that in the majority of cases, the user doesn't care how
it's laid out at the frag level, they just want to write some data at
some offset and length. If every frag is a separate dynptr, then the
user needs to be aware whether they're crossing frag (and thus dynptr)
boundaries. In cases where the user doesn't know if the data is across
head/frag or across frags, then their prog code will need to be more
complex to handle these different scenarios. There's the additional
issue as well that this doesn't work for cloned skb frags - now users
need to know whether the skb is cloned or uncloned to know whether to
pull first. Imo it makes the interface more confusing. I'm still not
sure what is gained by having separate dynptrs for separate frags.

If the goal is to avoid pulls, then we're able to do that without
having separate dynptrs. If a write is to an uncloned frag, then
bpf_dynptr_write() can kmap, write the data, and kunmap (though it's
still unclear as to whether this should be done, since maybe it's
faster to pull and do large numbers of writes instead of multiple
kmap/kunmap calls).

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
