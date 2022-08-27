Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467515A3A82
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 01:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiH0Xrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 19:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiH0Xrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 19:47:47 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655A03F32D;
        Sat, 27 Aug 2022 16:47:46 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r141so3955797iod.4;
        Sat, 27 Aug 2022 16:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=U/4062rbYIaJiHy0UcDh7DWvTq1Fe6ZO+Q5wKfiFyqk=;
        b=pA7ZHGr1oxabj4+AhumzXlEmENOo8sfoQ9JQAlPzOtEbaEfQnlUFlOWgRNsdJjbhzP
         euy9yfTF3AtY1pjmClL1iTAemWfA3pTZo+V0xmdXwugy/qZBLkgQfgwbhpFbnxSxiGI2
         jOmRyrLUMFD0i/BtiyaSp18Ww5yF/QrJdGTd0LylMJActq8WjpHm48R0QJCJTR8n17L3
         GabVyjoO+2JyqbfZoTsgxSJqJFDo6Nscn5ol211qhYVSy//1aVKMXTLB90iIiyrSchi0
         Iabx4443aNYZ721LwCueJ6Rckr3oZoJnnx8GW9CZJ+kYdzJLnpsz8Sgbs7GFzh0VQrAs
         UYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=U/4062rbYIaJiHy0UcDh7DWvTq1Fe6ZO+Q5wKfiFyqk=;
        b=azhhizzrjlGnqxAOuu7hugcYhdZWgxakfDaLSxcwBJ0pRcpZdwWHKJW0lsvfo9kiU+
         DllLcz2VsAJs2v/ZBMlGbtKzZ/XPc6cqqpoZuQta2oULX1A+KqeJSXxquqdc4euZbPsc
         4pMnhKVHZz6jTYWwaWIqvPE4nphm+ZsDZ3JtTKwW4BSPCD+YMFR66uDxw2AYM2Te+F4w
         47OrGyXugNWOP9AIGBZ9OFPwTYt0n40NsZxNUkf9NHq2GM40+vqv5pQjn3Bl3DKaQEuv
         tXS7Hah8A7qWNp1ERvaxWTUOKpU+YFXUheEjp5Kx6UHBVopE9ZLV/YLPfC278LQSGPuJ
         eGdg==
X-Gm-Message-State: ACgBeo3hiH59edBdeVElqUTGqioMQ33vjSjRpagOU15efGdX7cV/Ke6t
        rZb9M7AtClZnznAvHRcLCqh79SbJP5f+8otGmak=
X-Google-Smtp-Source: AA6agR4CHS53HU118KLWrztDUDe5Gl1aCyp6uCklfdVlIjg5r6qLBxs0ccIG8psOzUr1hQL8pACoiCXJfnbeSM4yBQ8=
X-Received: by 2002:a5e:dc46:0:b0:689:94f6:fa3e with SMTP id
 s6-20020a5edc46000000b0068994f6fa3emr6288036iop.110.1661644065687; Sat, 27
 Aug 2022 16:47:45 -0700 (PDT)
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
 <CAEf4BzYpV-RJ456n0UQFPXSG6SvUPK5=jM4nS+x25z7pTkfMGQ@mail.gmail.com>
 <CAP01T74UojWGWk=1nbE8N=fM9-vzyJJv=qNMM5dJO7A5qO7S6g@mail.gmail.com> <CAEf4BzYzP_7ZR_KSpEuVHGF9V1isfoo5p-v-zQx0102z=ipciA@mail.gmail.com>
In-Reply-To: <CAEf4BzYzP_7ZR_KSpEuVHGF9V1isfoo5p-v-zQx0102z=ipciA@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sun, 28 Aug 2022 01:47:09 +0200
Message-ID: <CAP01T74icBDXOM=ckxYVPK90QLcU4n4VRBjON_+v74dQwJfZvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Sun, 28 Aug 2022 at 01:03, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Aug 27, 2022 at 11:33 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sat, 27 Aug 2022 at 19:22, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Sat, Aug 27, 2022 at 12:12 AM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > > [...]
> > > > >
> > > > > I think the right answer here is to not make bpf_dynptr_data() return
> > > > > direct pointer of changing read-only-ness. Maybe the right answer here
> > > > > is another helper, bpf_dynptr_data_rdonly(), that will return NULL for
> > > > > non-read-only dynptr and PTR_TO_MEM | MEM_RDONLY if dynptr is indeed
> > > > > read-only?
> > > >
> > > > Shouldn't it be the other way around? bpf_dynptr_data_rdonly() should
> > > > work for both ro and rw dynptrs, and bpf_dynptr_data() only for rw
> > > > dynptr?
> > >
> > > Right, that's what I proposed:
> > >
> > >   "bpf_dynptr_data_rdonly(), that will return NULL for non-read-only dynptr"
> > >
> > > so if you pass read-write dynptr, it will return NULL (because it's
> > > unsafe to take writable direct pointer).
> > >
> > > bpf_dynptr_data_rdonly() should still work fine with both rdonly and
> > > read-write dynptr.
> > > bpf_dynptr_data() only works (in the sense returns non-NULL) for
> > > read-write dynptr only.
> > >
> > >
> > > >
> > > > And yes, you're kind of painting yourself in a corner if you allow
> > > > dynptr_data to work with statically ro dynptrs now, ascertaining the
> > > > ro bit for the returned slice, and then later you plan to add dynptrs
> > > > whose ro vs rw is not known to the verifier statically. Then it works
> > > > well for statically known ones (returning both ro and rw slices), but
> > > > has to return NULL at runtime for statically unknown read only ones,
> > > > and always rw slice in verifier state for them.
> > >
> > > Right, will be both inconsistent and puzzling.
> > >
> > > >
> > > > >
> > > > > By saying that read-only-ness of dynptr should be statically known and
> > > > > rejecting some dynptr functions at load time places us at the mercy of
> > > > > verifier's complete knowledge of application logic, which is exactly
> > > > > against the spirit of dynptr.
> > > > >
> > > >
> > > > Right, that might be too restrictive if we require them to be
> > > > statically read only.
> > > >
> > > > But it's not about forcing it to be statically ro, it is more about
> > > > rejecting load when we know the program is incorrect (e.g. the types
> > > > are incorrect when passed to helpers), otherwise we throw the error at
> > > > runtime anyway, which seems to be the convention afaicu. But maybe I
> > > > missed the memo and we gradually want to move away from such strict
> > > > static checks.
> > > >
> > > > I view the situation here similar to if we were rejecting direct
> > > > writes to PTR_TO_MEM | MEM_RDONLY at load time, but offloading as
> > > > runtime check in the helper writing to it as rw memory arg. It's as if
> > > > we pretend it's part of the 'type' of the register when doing direct
> > > > writes, but then ignore it while matching it against the said helper's
> > > > argument type.
> > >
> > > I disagree, it's not the same. bpf_dynptr_data/bpf_dynptr_data_rdonly
> > > turns completely dynamic dynptr into static slice of memory. Only
> > > after that point it makes sense for BPF verifier to reject something.
> > > Until then it's not incorrect. BPF program will always have to deal
> > > with some dynptr operations potentially failing. dynptr can always be
> > > NULL internally, you can still call bpf_dynptr_xxx() operations on it,
> > > they will just do nothing and return error. That doesn't make BPF
> > > program incorrect.
> >
> > Let me just explain one last time why I'm unable to swallow this
> > 'completely dynamic dynptr' explanation, because it is not treated as
> > completely dynamic by all dynptr helpers.
> >
> > No pushback, but it would be great if you could further help me wrap
> > my head around this, so that we're in sync for future discussions.
> >
> > So you say you may not know the type of dynptr (read-only, rw, local,
> > ringbuf, etc.). Hence you want to treat every dynptr as 'dynamic
>
> No, that's not what I said. I didn't talk about dynptr type (ringbuf
> vs skb vs local). Type we have to track statically precisely to limit
> what kind of helpers can be used on dynptrs of specific type.
>
> But note that there are helpers that don't care about dynptr and, in
> theory, should work with any dynptr. Because dynptr is an abstraction
> of "logically continuous range of memory". So in some cases even types
> don't matter.
>
> But regardless, I just don't think about read-only bit as part of
> dynptr types. I don't see why it has to be statically known and even
> why it has to stay as read-only or read-write for the entire duration
> of dynptr lifetime. Why can't we allow flipping dynptr from read-write
> to read-only before passing it to some custom BPF subprog, potentially
> provided from some BPF library which you don't control; just to make
> sure that it cannot really modify underlying memory (even if it is
> fundamentally modifiable, like with ringbuf)?
>
> So the point I'm trying to communicate is that things that don't
> **need** to be knowable statically to BPF verifier - **should not** be
> knowable and should be checked at runtime only. With any dynptr helper
> that is interfacing its runtime nature into static thing that verifier
> enforces (which is what bpf_dynptr_data/bpf_dynptr_data_rdonly are),
> it will always be "fallible" and users will have to expect that they
> might return NULL or do nothing, or whatever way to deal with failure
> case.
>
>
> And I believe dynptr read-onliness is not something that BPF verifier
> should be tracking statically. PTR_TO_MEM -- yes, dynptr -- no. That's
> it. Dynptr type/kind -- yes, track statically, it's way more important
> to determine what you can at all do with dynptr.
>

Understood, it's more clear now how you're thinking about this :),
especially that you don't consider read-only bit to be a property of
dynptr type. I think that was the main point I was not following.

And yes, I guess it's about different tradeoffs. Taking your BPF
library example, my idea would be that we will anyway be verifying the
global or static subprog in the library by the BTF of its function
prototype. The verifier has to verify safety of the subprog by setting
up argument types if it is global.

There, I find it more appropriate for global ones to declare const
bpf_dynptr * as the argument type if the intent is to not write to the
dynptr. Then user can safely pass both rw and ro dynptrs to it,
without having to flip it each time at runtime just to ensure safety.
If it is static it will also be able to catch incorrect writes for
callers.

But indeed there may be cases where you want to control this at
runtime, IMPO that should be orthogonal to type level const-ness.
Those will be rw at the type level but may change const-ness at
runtime, then operations start failing at runtime.

Anyway, I guess we are done here. Again, thanks for sticking along and
taking the time to describe it in detail :).

>
> [...]
