Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E37F5A3A64
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 01:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiH0XDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 19:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiH0XDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 19:03:31 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742371A824;
        Sat, 27 Aug 2022 16:03:29 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z8so6131472edb.0;
        Sat, 27 Aug 2022 16:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PLxGI4SbyOdiPSPxSoupr4i4Z6BqYIXWFq8Y5ah7TYw=;
        b=M943WISz8L5G0eamyek9nrgiUFBwArk5/ehe3t8C9XqdHSwA3j/reKocgFSYRCyuwG
         DVLrYcopji/G/lElOHo/wZVahk4IH6NrC5GBcb3UJFBRgt+BgJLe+ZGO1OqYMTIZll0D
         KNaKQRlJmasvHXLYsDRNgwbQdnTUtlK/2s8qvD5iBiD804Wkup8ZpN/UmbfFPWwt8a+l
         qouN9UxwhCnZLom22AMLMmc1ObEzHl73Ej17yBYJCc9jAgdYiOHmZbu9q7eL2ws+sq60
         dEONVe0iBR2z7eqy7JB2BqkVl6EA5m8O09eyMDLOAlW+HdeZ6xXkTLLkAgDnIkcsAw5X
         1eKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PLxGI4SbyOdiPSPxSoupr4i4Z6BqYIXWFq8Y5ah7TYw=;
        b=NEUeKioRhDokpnpqNUTyvlEdeKPCSvOf9aNGgMYpCj62iANz9jI8/H7GgwE8Ry8J5t
         dLI7bbDiMoEruIfdlOYHOLIi5yfRKLuBNu+Z1gYTujlxXmYv5410HSB27Ypyu3PLuGe6
         25mY61nYrZce09VYz+Kl7m/7wzGgZZr0XayCi8p8FOw4SCeFG+a8sXa8NomAlzxDLKnq
         GaFhFGCpoUGW/laGomLc0U6dRU0Y23ialY91AkouYucTQd91Ft9DnZKu0GaHrJQc66OR
         wPhU0dbnI16cmc9m7z0V9+8J1mycpNDYB1rH+PgtUsMycZQ8quzWtia6y+iOu1MY5Iqk
         UO5A==
X-Gm-Message-State: ACgBeo2eAAvPf4E4WvjThVdFrm4An6vFoScUSgOSscMgFbf1TyBMSNHE
        XLPlgO/xg631XefM9C1RXSptNJSph/GXbU3pSr8=
X-Google-Smtp-Source: AA6agR4rIml3TgH0RnuYNkLiG5s4+s69wKqOHh7QXz45zObBIqFqq5rDzYbqdy5l5Cm6wbbOn31o0qeTf+qwPJ+eIUc=
X-Received: by 2002:a05:6402:24a4:b0:440:8c0c:8d2b with SMTP id
 q36-20020a05640224a400b004408c0c8d2bmr11123111eda.311.1661641407650; Sat, 27
 Aug 2022 16:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
 <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
 <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
 <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com>
 <CAJnrk1Zmne1uDn8EKdNKJe6O-k_moU9Sryfws_J-TF2BvX2QMg@mail.gmail.com>
 <CAP01T746gvoOM7DuWY-3N2xJbEainTinTPhyqHki2Ms6E0Dk_A@mail.gmail.com>
 <CAEf4BzZYTN=gGsc88jetv-SSMBy78P7w7Y08zfwGR7cCenJPiQ@mail.gmail.com>
 <CAP01T74mbnYJkq0CfknZBqYg4T5B-OenB+SB6=gc24GvpVxA8g@mail.gmail.com>
 <CAEf4BzYpV-RJ456n0UQFPXSG6SvUPK5=jM4nS+x25z7pTkfMGQ@mail.gmail.com> <CAP01T74UojWGWk=1nbE8N=fM9-vzyJJv=qNMM5dJO7A5qO7S6g@mail.gmail.com>
In-Reply-To: <CAP01T74UojWGWk=1nbE8N=fM9-vzyJJv=qNMM5dJO7A5qO7S6g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Aug 2022 16:03:15 -0700
Message-ID: <CAEf4BzYzP_7ZR_KSpEuVHGF9V1isfoo5p-v-zQx0102z=ipciA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 11:33 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, 27 Aug 2022 at 19:22, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Aug 27, 2022 at 12:12 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > > [...]
> > > >
> > > > I think the right answer here is to not make bpf_dynptr_data() return
> > > > direct pointer of changing read-only-ness. Maybe the right answer here
> > > > is another helper, bpf_dynptr_data_rdonly(), that will return NULL for
> > > > non-read-only dynptr and PTR_TO_MEM | MEM_RDONLY if dynptr is indeed
> > > > read-only?
> > >
> > > Shouldn't it be the other way around? bpf_dynptr_data_rdonly() should
> > > work for both ro and rw dynptrs, and bpf_dynptr_data() only for rw
> > > dynptr?
> >
> > Right, that's what I proposed:
> >
> >   "bpf_dynptr_data_rdonly(), that will return NULL for non-read-only dynptr"
> >
> > so if you pass read-write dynptr, it will return NULL (because it's
> > unsafe to take writable direct pointer).
> >
> > bpf_dynptr_data_rdonly() should still work fine with both rdonly and
> > read-write dynptr.
> > bpf_dynptr_data() only works (in the sense returns non-NULL) for
> > read-write dynptr only.
> >
> >
> > >
> > > And yes, you're kind of painting yourself in a corner if you allow
> > > dynptr_data to work with statically ro dynptrs now, ascertaining the
> > > ro bit for the returned slice, and then later you plan to add dynptrs
> > > whose ro vs rw is not known to the verifier statically. Then it works
> > > well for statically known ones (returning both ro and rw slices), but
> > > has to return NULL at runtime for statically unknown read only ones,
> > > and always rw slice in verifier state for them.
> >
> > Right, will be both inconsistent and puzzling.
> >
> > >
> > > >
> > > > By saying that read-only-ness of dynptr should be statically known and
> > > > rejecting some dynptr functions at load time places us at the mercy of
> > > > verifier's complete knowledge of application logic, which is exactly
> > > > against the spirit of dynptr.
> > > >
> > >
> > > Right, that might be too restrictive if we require them to be
> > > statically read only.
> > >
> > > But it's not about forcing it to be statically ro, it is more about
> > > rejecting load when we know the program is incorrect (e.g. the types
> > > are incorrect when passed to helpers), otherwise we throw the error at
> > > runtime anyway, which seems to be the convention afaicu. But maybe I
> > > missed the memo and we gradually want to move away from such strict
> > > static checks.
> > >
> > > I view the situation here similar to if we were rejecting direct
> > > writes to PTR_TO_MEM | MEM_RDONLY at load time, but offloading as
> > > runtime check in the helper writing to it as rw memory arg. It's as if
> > > we pretend it's part of the 'type' of the register when doing direct
> > > writes, but then ignore it while matching it against the said helper's
> > > argument type.
> >
> > I disagree, it's not the same. bpf_dynptr_data/bpf_dynptr_data_rdonly
> > turns completely dynamic dynptr into static slice of memory. Only
> > after that point it makes sense for BPF verifier to reject something.
> > Until then it's not incorrect. BPF program will always have to deal
> > with some dynptr operations potentially failing. dynptr can always be
> > NULL internally, you can still call bpf_dynptr_xxx() operations on it,
> > they will just do nothing and return error. That doesn't make BPF
> > program incorrect.
>
> Let me just explain one last time why I'm unable to swallow this
> 'completely dynamic dynptr' explanation, because it is not treated as
> completely dynamic by all dynptr helpers.
>
> No pushback, but it would be great if you could further help me wrap
> my head around this, so that we're in sync for future discussions.
>
> So you say you may not know the type of dynptr (read-only, rw, local,
> ringbuf, etc.). Hence you want to treat every dynptr as 'dynamic

No, that's not what I said. I didn't talk about dynptr type (ringbuf
vs skb vs local). Type we have to track statically precisely to limit
what kind of helpers can be used on dynptrs of specific type.

But note that there are helpers that don't care about dynptr and, in
theory, should work with any dynptr. Because dynptr is an abstraction
of "logically continuous range of memory". So in some cases even types
don't matter.

But regardless, I just don't think about read-only bit as part of
dynptr types. I don't see why it has to be statically known and even
why it has to stay as read-only or read-write for the entire duration
of dynptr lifetime. Why can't we allow flipping dynptr from read-write
to read-only before passing it to some custom BPF subprog, potentially
provided from some BPF library which you don't control; just to make
sure that it cannot really modify underlying memory (even if it is
fundamentally modifiable, like with ringbuf)?

So the point I'm trying to communicate is that things that don't
**need** to be knowable statically to BPF verifier - **should not** be
knowable and should be checked at runtime only. With any dynptr helper
that is interfacing its runtime nature into static thing that verifier
enforces (which is what bpf_dynptr_data/bpf_dynptr_data_rdonly are),
it will always be "fallible" and users will have to expect that they
might return NULL or do nothing, or whatever way to deal with failure
case.


And I believe dynptr read-onliness is not something that BPF verifier
should be tracking statically. PTR_TO_MEM -- yes, dynptr -- no. That's
it. Dynptr type/kind -- yes, track statically, it's way more important
to determine what you can at all do with dynptr.


> dynptr' you know nothing about even when you do know some information
> about it statically (e.g. if it's on stack). You don't want to reject
> things early at load even if you have all the info to do so. You want
> operations on it to fail at runtime instead.
>
> If you cannot track ro vs rw in the future statically, you won't be be
> able to track local or ringbuf or skb either (since both are part of
> the type of the dynptr). If you can, you can just as well encode
> const-ness as part of the type where you declare it (e.g. in a map
> field where the value is assigned dynamically, where you say
> dynptr_ringbuf etc.). Type comprises local vs skb vs ringbuf | ro vs
> rw for me. But maybe I could be wrong.

I don't consider read-only to be a part of type. It's more like offset
and size to me, rather than type. And even if we can track constness
(e.g., we can teach BPF verifier to recognize that hypothetical
bpf_dynptr_set_read_only() makes dynptr into dynptr_rdonly, but why?)

>
> So following this line of reasoning, will you be relaxing the argument
> type of helpers like bpf_ringbuf_submit_dynptr? Right now they take
> 'dynamic dynptr' as arg, but also expect DYNPTR_TYPE_RINGBUF, so you
> reject load when it's not a ringbuf dynptr. Will it then fallback to
> checking the type at runtime when the type will not be known? But then
> it will also permit passing local or skb dynptr in the future which it
> rejects right now.

No, which is exactly why we track dynptr type statically. Because some
operations don't make sense and they have additional semantics (like
with ringbuf submit).

>
> I'm just hoping you are able to see why it's looking a bit
> inconsistent to me. If DYNPTR_TYPE_RINGBUF has to be checked, it felt
> to me like DYNPTR_RDONLY is as much part of that kind of type safety
> wrt helpers. It would be set on the dynptr when skb passed to
> dynptr_from_skb is rdonly in some program types, along with
> DYNPTR_TYPE_SKB, and expect to be matched when invoking helpers on
> such dynptrs.

I understand your view point. But you are taking "completely dynamic"
nature of dynptr too far (not tracking dynptr type) in one case, or
making it too restrictive (tracking read-only state) in another. We
can argue what substitutes "inconsistent", but I'm just leaning
towards slightly different tradeoffs. I don't see a huge value in
preventing bpf_dynptr_write() to be called on read-only dynptr
**statically**. I've ran into various cases where I'd rather BPF
verifier not pretend to be all-knowing and too helpful, because it
sometimes turns into a game of proving to BPF verifier that "I know
what I'm doing, and it's correct, so please just let me do it".

>
> It is fine to push checks to runtime, especially when you won't know
> the type, because verifier cannot reasonably track the dynptr type
> then.
>
> But right now there's still some level of state you maintain in the
> verifier about dynptrs (like it's type), and it seems to me like some
> helpers are using that state to reject things at load time, while some
> other helper will ignore it and fallback to runtime checks.

Exactly. There are helpers that can fail no matter what, and
read-onliness is just another condition they will have to check and
reject.

And some helpers really don't and shouldn't care about the nature of
dynptr (like bpf_dynptr_get_size(), for example).

>
> I hope this is a clear enough description to atleast justify why I'm
> (still) a bit confused.

I don't think you are confused, you just prefer a different tradeoff.
Hopefully I gave a few more arguments in favor of less static
treatment of dynptr where it doesn't hurt correctness.

P.S. I'm going away on vacation, so unlikely to be able to continue
this discussion in a timely manner going forward.
