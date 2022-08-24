Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEE45A045D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiHXXE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHXXEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:04:55 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6825A2E6A8;
        Wed, 24 Aug 2022 16:04:53 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o1so660698ilq.1;
        Wed, 24 Aug 2022 16:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=p44G7Wq2FLrbOC1ZrbL87IV6gV/HlG0kV9bfpQZOc5A=;
        b=nYo5sQ6pSADtCuLMLgiNj2QKAUhmg+t7uWUwBvlkGKLu8cNS0TRfsA7PfDNBKNUY+W
         HawI0bp/e3liYW9H6cm1Gp8NfD9gzDBlgRhzPg5iVI2UWMvrVMiRarz6trulWaWdGRS4
         CIh/LQDz+JXOUd4ONI2JZt1BPOVua7AJSBEButgqO/Vp3NkSXVq4tNfUEuOjMvVC1cSm
         l49TCN371BAhALkw0jp7ZZIm1UXyLQhWOZGE5/9CjvqjfqvC9l9pXC3H8WnqC6yT4VoK
         NYF1nm031v4RusNnCGIqQ1gkxHsogh2uR6iaKTAsjiZJIlPfptp307aKbqIC1DYiSAJ2
         B9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=p44G7Wq2FLrbOC1ZrbL87IV6gV/HlG0kV9bfpQZOc5A=;
        b=vIAzLQ8DGbNJXnlw/kMRdZbETHVT88rftbCZqnHN4Z2T1a/d1dzYOiSylFNe6pNdnH
         wHNpi9JP/G7wNCR80JPjdXysEUozd0Ex0xXMN0XB3uiff+IVAakEWCvikFFfHsvZJkq4
         7L1zRrtsk2UnKbuNfcG2LveY+dXt6Rxj0W+lj9kLl8MgqkMhSq6wjt/2Mu1pGkerIOSP
         SbI1Hxi3fIP0cmJPxVWhNTLZUb52tCxb5+bHfG6xf6XO2UkVj3IoKjhBU1fPm5dAMOwp
         5wNSFUWgStVpOuF05XKRrHX1fESY9f3ZitX5LEc9FqY6a5FwQjzzDzqqOTX/tpJ9PcRr
         HR+g==
X-Gm-Message-State: ACgBeo1gFzPjungOgcriTspERxLp6OFjZ8USp7ZmqKpfz6zIqDIIof4R
        042IOWLr/JlxamfyHN+OcJALCGaomThwv08yMRA=
X-Google-Smtp-Source: AA6agR5r8So3EKb9pfhIs9jUmcXd+gccoNXfVMvz6DK4H7dQNBUiFbkgBj47vYZDkoNhzb3uIl70OVFrYDeNyNvqFfY=
X-Received: by 2002:a92:ca4e:0:b0:2ea:3f77:a85 with SMTP id
 q14-20020a92ca4e000000b002ea3f770a85mr523952ilo.219.1661382292676; Wed, 24
 Aug 2022 16:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk> <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
In-Reply-To: <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 25 Aug 2022 01:04:16 +0200
Message-ID: <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
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

On Wed, 24 Aug 2022 at 20:11, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Wed, Aug 24, 2022 at 3:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Joanne Koong <joannelkoong@gmail.com> writes:
> > >> [...]
> > >> It's a bit awkward to have such a difference between xdp and skb
> > >> dynptr's read/write. I understand why it is the way it is, but it
> > >> still doesn't feel right. I'm not sure if we can reconcile the
> > >> differences, but it makes writing common code for both xdp and tc
> > >> harder as it needs to be aware of the differences (and then the flag=
s
> > >> for dynptr_write would differ too). So we're 90% there but not the
> > >> whole way...
> > >
> > > Yeah, it'd be great if the behavior for skb/xdp progs could be the
> > > same, but I'm not seeing a better solution here (unless we invalidate
> > > data slices on writes in xdp progs, just to make it match more :P).
> > >
> > > Regarding having 2 different interfaces bpf_dynptr_from_{skb/xdp}, I'=
m
> > > not convinced this is much of a problem - xdp and skb programs alread=
y
> > > have different interfaces for doing things (eg
> > > bpf_{skb/xdp}_{store/load}_bytes).
> >
> > This is true, but it's quite possible to paper over these differences
> > and write BPF code that works for both TC and XDP. Subtle semantic
> > differences in otherwise identical functions makes this harder.
> >
> > Today you can write a function like:
> >
> > static inline int parse_pkt(void *data, void* data_end)
> > {
> >         /* parse data */
> > }
> >
> > And call it like:
> >
> > SEC("xdp")
> > int parse_xdp(struct xdp_md *ctx)
> > {
> >         return parse_pkt(ctx->data, ctx->data_end);
> > }
> >
> > SEC("tc")
> > int parse_tc(struct __sk_buff *skb)
> > {
> >         return parse_pkt(skb->data, skb->data_end);
> > }
> >
> >
> > IMO the goal should be to be able to do the equivalent for dynptrs, lik=
e:
> >
> > static inline int parse_pkt(struct bpf_dynptr *ptr)
> > {
> >         __u64 *data;
> >
> >         data =3D bpf_dynptr_data(ptr, 0, sizeof(*data));
> >         if (!data)
> >                 return 0;
> >         /* parse data */
> > }
> >
> > SEC("xdp")
> > int parse_xdp(struct xdp_md *ctx)
> > {
> >         struct bpf_dynptr ptr;
> >
> >         bpf_dynptr_from_xdp(ctx, 0, &ptr);
> >         return parse_pkt(&ptr);
> > }
> >
> > SEC("tc")
> > int parse_tc(struct __sk_buff *skb)
> > {
> >         struct bpf_dynptr ptr;
> >
> >         bpf_dynptr_from_skb(skb, 0, &ptr);
> >         return parse_pkt(&ptr);
> > }
> >
>
> To clarify, this is already possible when using data slices, since the
> behavior for data slices is equivalent between xdp and tc programs for
> non-fragmented accesses. From looking through the selftests, I
> anticipate that data slices will be the main way programs interact
> with dynptrs. For the cases where the program may write into frags,
> then bpf_dynptr_write will be needed (which is where functionality
> between xdp and tc start differing) - today, we're not able to write
> common code that writes into the frags since tc uses
> bpf_skb_store_bytes and xdp uses bpf_xdp_store_bytes.

Yes, we cannot write code that just swaps those two calls right now.
The key difference is, the two above are separate functions already
and have different semantics. Here in this set you have the same
function, but with different semantics depending on ctx, which is the
point of contention.

>
> I'm more and more liking the idea of limiting xdp to match the
> constraints of skb given that both you, Kumar, and Jakub have
> mentioned that portability between xdp and skb would be useful for
> users :)
>
> What are your thoughts on this API:
>
> 1) bpf_dynptr_data()
>
> Before:
>   for skb-type progs:
>       - data slices in fragments is not supported
>
>   for xdp-type progs:
>       - data slices in fragments is supported as long as it is in a
> contiguous frag (eg not across frags)
>
> Now:
>   for skb + xdp type progs:
>       - data slices in fragments is not supported
>
>
> 2)  bpf_dynptr_write()
>
> Before:
>   for skb-type progs:
>      - all data slices are invalidated after a write
>
>   for xdp-type progs:
>      - nothing
>
> Now:
>   for skb + xdp type progs:
>      - all data slices are invalidated after a write
>

There is also the other option: failing to write until you pull skb,
which looks a lot better to me if we are adding this helper anyway...

> This will unite the functionality for skb and xdp programs across
> bpf_dyntpr_data, bpf_dynptr_write, and bpf_dynptr_read. As for whether
> we should unite bpf_dynptr_from_skb and bpf_dynptr_from_xdp into one
> common bpf_dynptr_from_packet as Jakub brought in [0], I'm leaning
> towards no because 1) if in the future there's some irreconcilable
> aspect between skb and xdp that gets added, that'll be hard to support
> since the expectation is that there is just one overall "packet
> dynptr" 2) the "packet dynptr" view is not completely accurate (eg
> bpf_dynptr_write accepts flags from skb progs and not xdp progs) 3)
> this adds some additional hardcoding in the verifier since there's no
> organic mapping between prog type -> prog ctx
>

There is, e.g. see how btf_get_prog_ctx_type is doing it (unless I
misunderstood what you meant).

I also had a different tangential question (unrelated to
'reconciliation'). Let's forget about that for a moment. I was
listening to the talk here [0]. At 12:00, I can hear someone
mentioning that you'd have a dynptr for each segment/frag.

Right now, you have a skb/xdp dynptr, which is representing
discontiguous memory, i.e. you represent all linear page + fragments
using one dynptr. This seems a bit inconsistent with the idea of a
dynptr, since it's conceptually a slice of variable length memory.
dynptr_data gives you a constant length slice into dynptr's variable
length memory (which the verifier can track bounds of statically).

So thinking about the idea in [0], one way would be to change
from_xdp/from_skb helpers to take an index (into the frags array), and
return dynptr for each frag. Or determine frag from offset + len. For
the skb case it might require kmap_atomic to access the frag dynptr,
which might need a paired kunmap_atomic call as well, and it may not
return dynptr for frags in cloned skbs, but for XDP multi-buff all
that doesn't count.

Was this approach/line of thinking considered and/or rejected? What
were the reasons? Just trying to understand the background here.

What I'm wondering is that we already have helpers to do reads and
writes that you are wrapping over in dynptr interfaces, but what we're
missing is to be able to get direct access to frags (or 'next' ctx,
essentially). When we know we can avoid pulls, it might be cheaper to
then do access this way to skb, right? Especially for a case where
just a part of the header lies in the next frag?

But I'm no expert here, so I might be missing some subtleties.

  [0]: https://www.youtube.com/watch?v=3DEZ5PDrXvs7M









>
> [0] https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmai=
l.com/T/#m1438f89152b1d0e539fe60a9376482bbc9de7b6e
>
> >
> > If the dynptr-based parse_pkt() function has to take special care to
> > figure out where the dynptr comes from, it makes it a lot more difficul=
t
> > to write reusable packet parsing functions. So I'd be in favour of
> > restricting the dynptr interface to the lowest common denominator of th=
e
> > skb and xdp interfaces even if that makes things slightly more awkward
> > in the specialised cases...
> >
> > -Toke
> >
