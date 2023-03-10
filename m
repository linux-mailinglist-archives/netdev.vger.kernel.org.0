Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448436B52E3
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjCJVao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjCJVaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:30:17 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4339524BE8;
        Fri, 10 Mar 2023 13:30:00 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ec29so25969593edb.6;
        Fri, 10 Mar 2023 13:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678483798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZ0s8gjUFPxIfG2G29b8+19vW1FL5pCSINNtGY1nwoQ=;
        b=LNlbDQJJKmsrOS5yvDSMCOHzeP3P7vcZQzPA44QsNB8Ev28/TLps3k+8TGtm7kmVHx
         beK1sDN/SGISK11GiGeRBVTz8VDfdcoqsaWBG/X71UXAP0by44BJV6abQXlyx3VTaPjO
         ta5kV/tA83wYC0lxF8Cf+AZv/TOBomEZwkp6ApfaqjZrkA6HaSlZQAlHm2sp3FLzwWOr
         SGU/Ff5UGY9tKtgPCoAMQ6C+DjA0btn2yYrLvoy0HUI/42rvI7ZQwbZn1btEbhKa62m5
         DIt6SuFAyPv6IPDmitlhyBvCntimp6veWrzh1IzRTagLwmVhUTKbNK4XMKuvbMk2gSOC
         z0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678483798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZ0s8gjUFPxIfG2G29b8+19vW1FL5pCSINNtGY1nwoQ=;
        b=cFYwKohtlD0llaW+JTs7cPbhL6cbyVk3o8abnWfrJ0Mo3yhvVLalz9BUVHalvp9zKR
         nfMrSK9byaRcIidTzRAgkruSawDl6ggNwbVFSH80qjvDk74TS+CzSXFPDWFRd09ZMKPI
         0tuefvNJnkTDgt1F1LjE6vgoIwYuscun3OFs33nh7sLrmO8+4whEV3SkUIt382n7IB0j
         6XEM1WDdEOpYaYfNwxsp/jnSy9/YHKak1qlfKd+T1mM8B+M1LE1Nkfalu549Cbt/JInk
         EVaDXe5T1T7thF3kcrTXOCR/TRkEx2s4jUnEYzQ1KwQ+QhfiQ8CoUKIa2oplzX62W1f8
         2sBw==
X-Gm-Message-State: AO0yUKXFXo+aAsxLD+ArxSiSHQOjHBwo9uWI0KbNVmRQE/XTIUBcprGs
        zNHsYiKSo7XlZFzEinU+Y2MpoPbtq0bW8PB3WdKS2BdG
X-Google-Smtp-Source: AK7set/ZaeztZ4WAGh0k7iEzUu9m6CtWZ12yWy6r5oXeI+ISMmw06LIUxcI1ulmwr4YpnBelzzdj0/QKjVVDor2kkLs=
X-Received: by 2002:a17:906:328c:b0:8b1:79ef:6923 with SMTP id
 12-20020a170906328c00b008b179ef6923mr12768496ejw.15.1678483798523; Fri, 10
 Mar 2023 13:29:58 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com> <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Mar 2023 13:29:45 -0800
Message-ID: <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 1:15=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > >
> > > > > I agree this is simpler, but I'm not sure it will work properly. =
Verifier won't
> > > > > know when the lifetime of the buffer ends, so if we disallow spil=
ls until its
> > > > > written over it's going to be a pain for users.
> > > > >
> > > > > Something like:
> > > > >
> > > > > for (...) {
> > > > >         char buf[64];
> > > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > > >         ...
> > > > > }
> > > > >
> > > > > .. and then compiler decides to spill something where buf was loc=
ated on stack
> > > > > outside the for loop. The verifier can't know when buf goes out o=
f scope to
> > > > > unpoison the slots.
> > > >
> > > > You're saying the "verifier doesn't know when buf ...".
> > > > The same applies to the compiler. It has no visibility
> > > > into what bpf_dynptr_slice_rdwr is doing.
> > >
> > > That is true, it can't assume anything about the side effects. But I =
am talking
> > > about the point in the program when the buffer object no longer lives=
. Use of
> > > the escaped pointer to such an object any longer is UB. The compiler =
is well
> > > within its rights to reuse its stack storage at that point, including=
 for
> > > spilling registers. Which is why "outside the for loop" in my earlier=
 reply.
> > >
> > > > So it never spills into a declared C array
> > > > as I tried to explain in the previous reply.
> > > > Spill/fill slots are always invisible to C.
> > > > (unless of course you do pointer arithmetic asm style)
> > >
> > > When the declared array's lifetime ends, it can.
> > > https://godbolt.org/z/Ez7v4xfnv
> > >
> > > The 2nd call to bar as part of unrolled loop happens with fp-8, then =
it calls
> > > baz, spills r0 to fp-8, and calls bar again with fp-8.
>
> Right. If user writes such program and does explicit store of spillable
> pointer into a stack.
> I was talking about compiler generated spill/fill and I still believe
> that compiler will not be reusing variable's stack memory for them.
>
> > >
> > > If such a stack slot is STACK_POISON, verifier will reject this progr=
am.
>
> Yes and I think it's an ok trade-off.
> The user has to specifically code such program to hit this issue.
> I don't think we will see this in practice.
> If we do we can consider a more complex fix.

I was just debugging (a completely unrelated) issue where two
completely independent functions, with different local variables, were
reusing the same stack slots just because of them being inlined in
parent functions. So stack reuse happens all the time, unfortunately.
It's not always obvious or malicious.

>
> > >
> > > >
> > > > > > > +       *(void **)eth =3D (void *)0xdeadbeef;
> > > > > > > +       ctx =3D *(void **)buffer;
> > > > > > > +       eth_proto =3D eth->eth_proto + ctx->len;
> > > > > > >         if (eth_proto =3D=3D bpf_htons(ETH_P_IP))
> > > > > > >                 err =3D process_packet(&ptr, eth, nh_off, fal=
se, ctx);
> > > > > > >
> > > > > > > I think the proper fix is to treat it as a separate return ty=
pe distinct from
> > > > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYN=
PTR_* specially),
> > > > > > > fork verifier state whenever there is a write, so that one pa=
th verifies it as
> > > > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a=
 stack ptr). I
> > > > > > > think for the rest it's not a problem, but there are allow_pt=
r_leak checks
> > > > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs t=
o be rechecked.
> > > > > > > Then we ensure that program is safe in either path.
> > > > > > >
> > > > > > > Also we need to fix regsafe to not consider other PTR_TO_MEMs=
 equivalent to such
> > > > > > > a pointer. We could also fork verifier states on return, to v=
erify either path
> > > > > > > separately right from the point following the call instructio=
n.
> > > > > >
> > > > > > This is too complex imo.
> > > > >
> > > > > A better way to phrase this is to verify with R0 =3D PTR_TO_PACKE=
T in one path,
> > > > > and push_stack with R0 =3D buffer's reg->type + size set to len i=
n the other path
> > > > > for exploration later. In terms of verifier infra everything is t=
here already,
> > > > > it just needs to analyze both cases which fall into the regular c=
ode handling
> > > > > the reg->type's. Probably then no adjustments to regsafe are need=
ed either. It's
> > > > > like exploring branch instructions.
> > > >
> > > > I still don't like it. There is no reason to go a complex path
> > > > when much simpler suffices.
> >
> > This issue you are discussing is the reason we don't support
> > bpf_dynptr_from_mem() taking PTR_TO_STACK (which is a pity, but we
> > postponed it initially).
> >
> > I've been thinking about something along the lines of STACK_POISON,
> > but remembering associated id/ref_obj_id. When ref is released, turn
> > STACK_POISON to STACK_MISC. If it's bpf_dynptr_slice_rdrw() or
> > bpf_dynptr_from_mem(), which don't have ref_obj_id, they still have ID
> > associated with returned pointer, so can we somehow incorporate that?
>
> There is dynptr_id in PTR_TO_MEM that is used by destroy_if_dynptr_stack_=
slot(),
> but I don't see how we can use it to help this case.
> imo plain STACK_POISON that is overwriteable by STACK_MISC/STACK_ZERO
> should be good enough in practice.

That's basically what I'm proposing, except when this overwrite
happens we have to go and invalidate all the PTR_TO_MEM references
that are pointing to that stack slot. E.g., in the below case
(assuming we allow LOCAL dynptr to be constructed from stack)

char buf[256], *p;
struct bpf_dynptr dptr;

bpf_dynptr_from_mem(buf, buf+256, &dptr);

p =3D bpf_dynptr_data(&dptr, 128, 16); /* get 16-byte slice into buf, at
offset 128 */

/* buf[128] through buf[128+16] are STACK_POISON */

buf[128] =3D 123;

So here is where the problem happens. Should we invalidate just p
here? Or entire dptr? Haven't thought much about details, but
something like that. It was getting messy when we started to think
about this with Joanne.

>
> We can potentially do some liveness trick. When PTR_TO_MEM with dynptr_id=
 becomes
> REG_LIVE_DONE we can convert STACK_POISON. But I'd go with the simplest a=
pproach first.
