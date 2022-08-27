Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E385A34DB
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 07:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiH0FhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 01:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH0FhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 01:37:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40187B1F4;
        Fri, 26 Aug 2022 22:37:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id p16so3418339ejb.9;
        Fri, 26 Aug 2022 22:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tKwqz0sDlnw2ueYv9YoTgT3Z6+OAaDoWq+5FyVcidtA=;
        b=ARbrHVBfQ50jqKD9U8iWwHqL2VY2iyOg8JPwslEIsO1XAuWARs1ZZDE/dLg0VY0Xof
         l4SeBpGCw+jUbA06Yk7yifLK8zKfqE4e2T/BOoSVvk/dwq1eOdyJW/ZBtVvVQUhMPD2q
         MefLY2QXWTuiBo6ZjA4RJD1zC786j1SEjnjP56uZ/NbJGRX+un6LIdc5Q9Ur8ACSMNeS
         EuaCY/vt0xQRLyDgOp9xRaKtYWUG2erzBeIU+MQ9BBPKFCGvwK7xQBTfWj/uIKGM9aFA
         NSDtvS08/FZSqgmSqiFd/5jaCYDuCFjp2o/n4liGFKY+9+sVnhH/zfgXFJf3nZkU9tii
         yjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tKwqz0sDlnw2ueYv9YoTgT3Z6+OAaDoWq+5FyVcidtA=;
        b=3+EI1/VttR43FKmDCsFH8yx60IV4E67aH3HK3GxT2KzwltvHY/1ygjfgeERjWrqXGe
         K9VC8RHqd/HAjB9X6fPcUcRoTfUdpP2ZjetpPXrNIX/NAVsJ/kSwoKJ/ud32nxlMc1CS
         +znC4ZmzwOcu6/BMXKnEIh1UJmQjIkzZ8/kMCxCTeAP72wsTXfa1Nmn43Enmub7ufQsc
         Hzg6a6mBL4ZXDCtf2TVmsfgpsY0lO9UpHj4rFzIsx5tlxgJo8GsLouvZm01JMOVasU8c
         fGv0M6u2FI63MdAWajw/227VxvsVocH0I1Rm74OWRnjkR/LmPIKw4E3E3bqSDZm4v1Ni
         NIFQ==
X-Gm-Message-State: ACgBeo18LB2Y8Z3Lf3ZmK5ujhnWdxAmy4p0CHlfBuuq0OX/gh9la+D/F
        ja0A4+eeAGDdYOuTHOx851RA1qs3qOFlp9N4VJ4=
X-Google-Smtp-Source: AA6agR7caLFlKZdtkOHf910e2OkgJmZe3nQZSKDEs2DxVMoJj2puKp8EKofgXzh1bYGU7fhd0vXrvlLgeje5D876KDA=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr7012564ejn.302.1661578629356; Fri, 26
 Aug 2022 22:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
 <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
 <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
 <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com>
 <CAJnrk1Zmne1uDn8EKdNKJe6O-k_moU9Sryfws_J-TF2BvX2QMg@mail.gmail.com> <CAP01T746gvoOM7DuWY-3N2xJbEainTinTPhyqHki2Ms6E0Dk_A@mail.gmail.com>
In-Reply-To: <CAP01T746gvoOM7DuWY-3N2xJbEainTinTPhyqHki2Ms6E0Dk_A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Aug 2022 22:36:57 -0700
Message-ID: <CAEf4BzZYTN=gGsc88jetv-SSMBy78P7w7Y08zfwGR7cCenJPiQ@mail.gmail.com>
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

On Fri, Aug 26, 2022 at 1:54 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, 26 Aug 2022 at 21:49, Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Fri, Aug 26, 2022 at 11:52 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Fri, 26 Aug 2022 at 20:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > On Thu, Aug 25, 2022 at 5:19 PM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > On Thu, 25 Aug 2022 at 23:02, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > > > [...]
> > > > > > >
> > > > > > > Related question, it seems we know statically if dynptr is read only
> > > > > > > or not, so why even do all this hidden parameter passing and instead
> > > > > > > just reject writes directly? You only need to be able to set
> > > > > > > MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
> > > > > > > dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
> > > > > > > seems simpler than checking it at runtime. Verifier already handles
> > > > > > > MEM_RDONLY generically, you only need to add the guard for
> > > > > > > check_packet_acces (and check_helper_mem_access for meta->raw_mode
> > > > > > > under pkt case), and rejecting dynptr_write seems like a if condition.
> > > > > >
> > > > > > There will be other helper functions that do writes (eg memcpy to
> > > > > > dynptrs, strncpy to dynptrs, probe read user to dynptrs, hashing
> > > > > > dynptrs, ...) so it's more scalable if we reject these at runtime
> > > > > > rather than enforce these at the verifier level. I also think it's
> > > > > > cleaner to keep the verifier logic as simple as possible and do the
> > > > > > checking in the helper.
> > > > >
> > > > > I won't be pushing this further, since you know what you plan to add
> > > > > in the future better, but I still disagree.
> > > > >
> > > > > I'm guessing there might be dynptrs where this read only property is
> > > > > set dynamically at runtime, which is why you want to go this route?
> > > > > I.e. you might not know statically whether dynptr is read only or not?
> > > > >
> > > > > My main confusion is the inconsistency here.
> > > > >
> > > > > Right now the patch implicitly relies on may_access_direct_pkt_data to
> > > > > protect slices returned from dynptr_data, instead of setting
> > > > > MEM_RDONLY on the returned PTR_TO_PACKET. Which is fine, it's not
> > > > > needed. So indirectly, you are relying on knowing statically whether
> > > > > the dynptr is read only or not. But then you also set this bit at
> > > > > runtime.
> > > > >
> > > > > So you reject some cases at load time, and the rest of them only at
> > > > > runtime. Direct writes to dynptr slice fails load, writes through
> > > > > helper does not (only fails at runtime).
> > > > >
> > > > > Also, dynptr_data needs to know whether dynptr is read only
> > > > > statically, to protect writes to its returned pointer, unless you
> > > > > decide to introduce another helper for the dynamic rdonly bit case
> > > > > (like dynptr_data_rdonly). Then you have a mismatch, where dynptr_data
> > > > > works for some rdonly dynptrs (known to be rdonly statically, like
> > > > > this skb one), but not for others.
> > > > >
> > > > > I also don't agree about the complexity or scalability part, all the
> > > > > infra and precedence is already there. We already have similar checks
> > > > > for meta->raw_mode where we reject writes to read only pointers in
> > > > > check_helper_mem_access.
> > > >
> > > > My point about scalability is that if we reject bpf_dynptr_write() at
> > > > load time, then we must reject any future dynptr helper that does any
> > > > writing at load time as well, to be consistent.
> > > >
> > > > I don't feel strongly about whether we reject at load time or run
> > > > time. Rejecting at load time instead of runtime doesn't seem that
> > > > useful to me, but there's a good chance I'm wrong here since Martin
> > > > stated that he prefers rejecting at load time as well.
> > > >
> > > > As for the added complexity part, what I mean is that we'll need to
> > > > keep track of some more stuff to support this, such as whether the
> > > > dynptr is read only and which helper functions need to check whether
> > > > the dynptr is read only or not.
> > >
> > > What I'm trying to understand is how dynptr_data is supposed to work
> > > if this dynptr read only bit is only known at runtime. Or will it be
> > > always known statically so that it can set returned pointer as read
> > > only? Because then it doesn't seem it is required or useful to track
> > > the readonly bit at runtime.
> >
> > I think it'll always be known statically whether the dynptr is
> > read-only or not. If we make all writable dynptr helper functions
> > reject read-only dynptrs at load time instead of run time, then yes we
> > can remove the read-only bit in the bpf_dynptr_kern struct.
> >
> > There's also the question of whether this constraint (eg all read-only
> > writes are rejected at load time) is too rigid - for example, what if
> > in the future we want to add a helper function where if a certain
> > condition is met, then we write some number of bytes, else we read
> > some number of bytes? This would be not possible to add then, since
> > we'll only know at runtime whether the condition is met.
> >
> > I personally lean towards rejecting helper function writes at runtime,
> > but if you think it's a non-trivial benefit to reject at load time
> > instead, I'm fine going with that.
> >
>
> My personal opinion is this:
>
> When I am working with a statically known read only dynptr, it is like
> declaring a variable const. Every function expecting it to be
> non-const should fail compilation, and trying to mutate the variables
> through writes should also fail compilation. For BPF compilation is
> analogous to program load.
>
> It might be that said variable is not const, then those operations may
> fail at runtime due to some other reason. Being dynamically read-only
> is then a runtime failure condition, which will cause failure at
> runtime. Both are distinct cases in my mind, and it is fine to fail at
> runtime when we don't know. In general, you save a lot of time of the
> user in my opinion (esp. people new to things) if you reject known
> incorrectness as early as possible.
>
> E.g. load a dynptr from a map, where the field accepts storing both
> read only and non-read only ones. Then it is expected that writes may
> fail at runtime. That also allows you to switch read-only ness at
> runtime back to rw. But if the field only expects rdonly dynptr,
> verifier knows that the type is const statically, so it triggers
> failures for writes at load time instead.
>
> Taking this a step further, you may even store rw dynptr to a map
> field expecting rdonly dynptr. That's like returning a const pointer
> from a function for a rw memory, where you want to limit access of the
> user, even better if you do it statically. Then functions trying to
> write to dynptr loaded from said map field will fail load itself,
> while others having access to rw dynptr can do it just fine.
>
> When the verifier does not know, it does not know. There will be such
> cases when you make const-ness a runtime property.
>
> > >
> > > It is fine if _everything_ checks it at runtime, but that doesn't seem
> > > possible, hence the question. We would need a new slice helper that
> > > only returns read-only slices, because dynptr_data can return rw
> > > slices currently and it is already UAPI so changing that is not
> > > possible anymore.
> >
> > I don't agree that if bpf_dynptr_write() is checked at runtime, then
> > bpf_dynptr_data must also be checked at runtime to be consistent. I
> > think it's fine if writes through helper functions are rejected at
> > runtime, and writes through direct access are rejected at load time.
> > That doesn't seem inconsistent to me.
>
> My point was more that dynptr_data cannot propagate runtime
> read-only-ness to its returned pointer. The verifier has to know
> statically, at which point I don't see why we can't just reject other
> cases at load anyway.

I think the right answer here is to not make bpf_dynptr_data() return
direct pointer of changing read-only-ness. Maybe the right answer here
is another helper, bpf_dynptr_data_rdonly(), that will return NULL for
non-read-only dynptr and PTR_TO_MEM | MEM_RDONLY if dynptr is indeed
read-only?

By saying that read-only-ness of dynptr should be statically known and
rejecting some dynptr functions at load time places us at the mercy of
verifier's complete knowledge of application logic, which is exactly
against the spirit of dynptr.

It's only slightly tangential, but I still dread my experience proving
to BPF verifier that some value is strictly greater than zero for BPF
helper that expected ARG_CONST_SIZE (not ARG_CONST_SIZE_OR_ZERO).
There were also cases were absolutely correct program had to be
mangled just to prove to BPF verifier that it indeed can return just 0
or 1, etc. This is not to bash BPF verifier, but just to point out
that sometimes unnecessary strictness adds nothing but unnecessary
pain to user. So, let's not reject anything at load, we can check all
that at runtime and return NULL.

But bpf_dynptr_data_rdonly() seems useful for cases where we know we
are not going to write

>
> When we have dynptrs which have const-ness as a runtime property, it
> is ok to support that by failing at runtime (but then you'll have a
> hard time deciding how you want dynptr_data to work, most likely
> you'll need another helper which returns only a rdonly slice, when it
> fails, we call dynptr_data for rw slice).
>
> But as I said before, I don't know how dynptr is going to evolve in
> the future, so you'll have a better idea, and I'll leave it up to you
> decide how you want to design its API. Enough words exchanged about
> this :).

directionally, dynptr is about offloading decisions to runtime, so I
think avoiding unnecessary restrictions at verification time is the
right trade off
