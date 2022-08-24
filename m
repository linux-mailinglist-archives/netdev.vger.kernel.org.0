Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EC85A011F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbiHXSLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240099AbiHXSLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:11:08 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EAD5073A;
        Wed, 24 Aug 2022 11:11:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ca13so23810115ejb.9;
        Wed, 24 Aug 2022 11:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=rWonn27X8z4bD7y6AZPySRDF0YykDyNgB3LwIkCxAPQ=;
        b=bMCdEhNHwXRoPUd/gRiKo1pTlPZWbRhIgwV4ucpT7GFjCLcZYX8n6nFFDwejvuNTkW
         kSPCIrR/Gm7/wGF96Ms3/mLsoJBCk9li0A4orNKu5z1L4PMfDfw2a5YSNTaRtMw1E30y
         EiblcL7hgIcJ+Srviy+j3b117E+Jj662qd+CPGvZI0JnaQxubfJYiV6JTn8xztVCKGPq
         37JJHVQW03P9Rn5bzku5RQghrbUriXNjY9RenM5evNRsw1U4HJwk05dgB9cFD4YCiXaC
         eska4pBuATF9sAO3s8bQw8uYXOH6TJd8thYSwoaiklQgpA5TUlTvVxpWpqrKCHvHIt5D
         suUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=rWonn27X8z4bD7y6AZPySRDF0YykDyNgB3LwIkCxAPQ=;
        b=jGvkhGhjBTF/jpEfAVL4MRXTxOgM2aHGxo11suqLuaikD4tEx66er0hyksBUSpcm1e
         jtyc7cZt1sqCGAnxH+a536HMgA4T060HINMlGTZiPuXmArbg6iLWi7/9X+vRELXGjRko
         so7Sj2NGC1awj8J8HRmo9ZKj6Vxg1pQdNGXXvFr2Db23SDG04QluUAOpLg52xkkIs9HH
         T7FBLnVreIAJdIHYlN0llA2lK1gQnwSy4wAJKAkuaTJTVnIN04nwt2tN2qaO+Sv3jOut
         HiXBykVDFBmK1Yrs2E85AKP4qOZ2g4Y/RmaK57LunECdaVHhQIt9fK1NRI+1kJ/4HMbH
         71YA==
X-Gm-Message-State: ACgBeo0krWVbSOMbl5n7ol+Sfw+yG6/b65i8/DfNlrnih0awWmg8Cl7a
        WWaR71MiZ8meG9Sz3EDazDZ/A8QBz0bmZpx0VyVslMuch5s=
X-Google-Smtp-Source: AA6agR6hOPCsLEczOX5tFZt0ywqQPzsnEHEpPUf9Nc/2Ci26LSvRjw1e3uX2F2gMi400atvKfaXaVjrpYKsBnpLoDts=
X-Received: by 2002:a17:907:a408:b0:73d:6696:50af with SMTP id
 sg8-20020a170907a40800b0073d669650afmr97326ejc.369.1661364665342; Wed, 24 Aug
 2022 11:11:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com> <878rnehqnd.fsf@toke.dk>
In-Reply-To: <878rnehqnd.fsf@toke.dk>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 24 Aug 2022 11:10:54 -0700
Message-ID: <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org,
        "brouer@redhat.com" <brouer@redhat.com>, lorenzo@kernel.org
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

On Wed, Aug 24, 2022 at 3:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Joanne Koong <joannelkoong@gmail.com> writes:
>
> > On Mon, Aug 22, 2022 at 7:31 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> >>
> >> +Cc XDP folks
> >>
> >> On Tue, 23 Aug 2022 at 02:12, Joanne Koong <joannelkoong@gmail.com> wr=
ote:
> >> >
> >> > Add xdp dynptrs, which are dynptrs whose underlying pointer points
> >> > to a xdp_buff. The dynptr acts on xdp data. xdp dynptrs have two mai=
n
> >> > benefits. One is that they allow operations on sizes that are not
> >> > statically known at compile-time (eg variable-sized accesses).
> >> > Another is that parsing the packet data through dynptrs (instead of
> >> > through direct access of xdp->data and xdp->data_end) can be more
> >> > ergonomic and less brittle (eg does not need manual if checking for
> >> > being within bounds of data_end).
> >> >
> >> > For reads and writes on the dynptr, this includes reading/writing
> >> > from/to and across fragments. For data slices, direct access to
> >>
> >> It's a bit awkward to have such a difference between xdp and skb
> >> dynptr's read/write. I understand why it is the way it is, but it
> >> still doesn't feel right. I'm not sure if we can reconcile the
> >> differences, but it makes writing common code for both xdp and tc
> >> harder as it needs to be aware of the differences (and then the flags
> >> for dynptr_write would differ too). So we're 90% there but not the
> >> whole way...
> >
> > Yeah, it'd be great if the behavior for skb/xdp progs could be the
> > same, but I'm not seeing a better solution here (unless we invalidate
> > data slices on writes in xdp progs, just to make it match more :P).
> >
> > Regarding having 2 different interfaces bpf_dynptr_from_{skb/xdp}, I'm
> > not convinced this is much of a problem - xdp and skb programs already
> > have different interfaces for doing things (eg
> > bpf_{skb/xdp}_{store/load}_bytes).
>
> This is true, but it's quite possible to paper over these differences
> and write BPF code that works for both TC and XDP. Subtle semantic
> differences in otherwise identical functions makes this harder.
>
> Today you can write a function like:
>
> static inline int parse_pkt(void *data, void* data_end)
> {
>         /* parse data */
> }
>
> And call it like:
>
> SEC("xdp")
> int parse_xdp(struct xdp_md *ctx)
> {
>         return parse_pkt(ctx->data, ctx->data_end);
> }
>
> SEC("tc")
> int parse_tc(struct __sk_buff *skb)
> {
>         return parse_pkt(skb->data, skb->data_end);
> }
>
>
> IMO the goal should be to be able to do the equivalent for dynptrs, like:
>
> static inline int parse_pkt(struct bpf_dynptr *ptr)
> {
>         __u64 *data;
>
>         data =3D bpf_dynptr_data(ptr, 0, sizeof(*data));
>         if (!data)
>                 return 0;
>         /* parse data */
> }
>
> SEC("xdp")
> int parse_xdp(struct xdp_md *ctx)
> {
>         struct bpf_dynptr ptr;
>
>         bpf_dynptr_from_xdp(ctx, 0, &ptr);
>         return parse_pkt(&ptr);
> }
>
> SEC("tc")
> int parse_tc(struct __sk_buff *skb)
> {
>         struct bpf_dynptr ptr;
>
>         bpf_dynptr_from_skb(skb, 0, &ptr);
>         return parse_pkt(&ptr);
> }
>

To clarify, this is already possible when using data slices, since the
behavior for data slices is equivalent between xdp and tc programs for
non-fragmented accesses. From looking through the selftests, I
anticipate that data slices will be the main way programs interact
with dynptrs. For the cases where the program may write into frags,
then bpf_dynptr_write will be needed (which is where functionality
between xdp and tc start differing) - today, we're not able to write
common code that writes into the frags since tc uses
bpf_skb_store_bytes and xdp uses bpf_xdp_store_bytes.

I'm more and more liking the idea of limiting xdp to match the
constraints of skb given that both you, Kumar, and Jakub have
mentioned that portability between xdp and skb would be useful for
users :)

What are your thoughts on this API:

1) bpf_dynptr_data()

Before:
  for skb-type progs:
      - data slices in fragments is not supported

  for xdp-type progs:
      - data slices in fragments is supported as long as it is in a
contiguous frag (eg not across frags)

Now:
  for skb + xdp type progs:
      - data slices in fragments is not supported


2)  bpf_dynptr_write()

Before:
  for skb-type progs:
     - all data slices are invalidated after a write

  for xdp-type progs:
     - nothing

Now:
  for skb + xdp type progs:
     - all data slices are invalidated after a write

This will unite the functionality for skb and xdp programs across
bpf_dyntpr_data, bpf_dynptr_write, and bpf_dynptr_read. As for whether
we should unite bpf_dynptr_from_skb and bpf_dynptr_from_xdp into one
common bpf_dynptr_from_packet as Jakub brought in [0], I'm leaning
towards no because 1) if in the future there's some irreconcilable
aspect between skb and xdp that gets added, that'll be hard to support
since the expectation is that there is just one overall "packet
dynptr" 2) the "packet dynptr" view is not completely accurate (eg
bpf_dynptr_write accepts flags from skb progs and not xdp progs) 3)
this adds some additional hardcoding in the verifier since there's no
organic mapping between prog type -> prog ctx


[0] https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.=
com/T/#m1438f89152b1d0e539fe60a9376482bbc9de7b6e

>
> If the dynptr-based parse_pkt() function has to take special care to
> figure out where the dynptr comes from, it makes it a lot more difficult
> to write reusable packet parsing functions. So I'd be in favour of
> restricting the dynptr interface to the lowest common denominator of the
> skb and xdp interfaces even if that makes things slightly more awkward
> in the specialised cases...
>
> -Toke
>
