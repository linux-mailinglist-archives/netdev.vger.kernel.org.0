Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98646BD864
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCPS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCPSz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:55:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B8FD7C37;
        Thu, 16 Mar 2023 11:55:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h8so11503924ede.8;
        Thu, 16 Mar 2023 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678992952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rF0o/+fpOOb8To8P6K3AzveD/fPreXR+dKa+n40IsM=;
        b=KIFe8Z8TafSeXMsmbTg/MuTqTFADabtH9LvJ1YXFcw58NoOwNM5ZhHx2ENgzH6cw71
         78w0FiaO9jMd8zt/drV548L7ZWSgJeMfP13tjhK+cO78ChLnscsMzMDHxZmpEeulS7N+
         m/+zlSqwRxTdHGXoe49WvwTtgEesl1NyYl34Q5UUqne42YktjhEF/dCUP2Vp7LGFzJ+l
         w0jXI6/PlIetGZmarbHxlkyeD8DF7zLM/hG9LcDjCfLxBFDOmg833W85ZvZZcLJv/cx7
         HeBYEUZBQuFyo6crkANQByNA515pxmh695wGBjWZTDgBr5mXq1TuOe4haXWHlbeJaZdp
         1wxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678992952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rF0o/+fpOOb8To8P6K3AzveD/fPreXR+dKa+n40IsM=;
        b=3Q2yneZSLk7iVNaWEPsWiaI6uO2KBmGRr3SijtZCC717sHqN0PJpvo0WCZSxcnTZSN
         z1tdzsfOmcewQSWQUdsZF6VemsGngGZOILzR6zxcLuPanSHcq6K7tiut4HkeTdJULEPh
         bi3X6gdZHY3heGe4sSoTktlT0hKGjsnnWxxhmtaZjNlPmwbZqUCzBrKa7u0LeTnfB4ON
         mTx79IAw/Laea/4eR9SYIHSFVtZBhR8ulIFPUY81yFXxjK5fBp9BLOG+MbN1k0eLM09c
         Y6Xq9rqhDyGJku/oUCyK6umVE4IuS6UZnEI61382I3xL/6tjMeSIi0FTVF0Rz9b6SCWB
         Hs+g==
X-Gm-Message-State: AO0yUKXuJxqaz90Z/9jtnRpfiHaeTxAopAmFiri5bxNZ9sX2IoFKp7p6
        WCIR/+/2N8wIA6gezQuyWq6gQAfaoYfL2hjulQOyrUPi
X-Google-Smtp-Source: AK7set8seDo6EXEUsskxAguzx7zODRaK1rQHKvoXesWL9OstOL6wxgllKrjMU0o+J3KHVDplhGe1H0070jZDZDu0gbU=
X-Received: by 2002:a50:9314:0:b0:4fb:dc5e:6501 with SMTP id
 m20-20020a509314000000b004fbdc5e6501mr363471eda.1.1678992951994; Thu, 16 Mar
 2023 11:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230306071006.73t5vtmxrsykw4zu@apollo> <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
 <CAADnVQLBDNqqfoNOV=mPxvsMdXLJCK_g1qmHjqxo=PED_vbhuw@mail.gmail.com>
 <CAJnrk1YCbLxcKT_FY_UdO9YBOz9fTyFQFTB8P0_2swPc39egvg@mail.gmail.com> <20230313144135.5xvgdfvfknb4liwh@apollo>
In-Reply-To: <20230313144135.5xvgdfvfknb4liwh@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Mar 2023 11:55:39 -0700
Message-ID: <CAEf4BzacF6pj7wHJ4NH3GBe4rtkaLSZUU1xahhQ37892Ds2ZmA@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 7:41=E2=80=AFAM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Mon, Mar 13, 2023 at 07:31:03AM CET, Joanne Koong wrote:
> > On Fri, Mar 10, 2023 at 1:55=E2=80=AFPM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Mar 10, 2023 at 1:30=E2=80=AFPM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Mar 10, 2023 at 1:15=E2=80=AFPM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > > > > > >
> > > > > > > > > I agree this is simpler, but I'm not sure it will work pr=
operly. Verifier won't
> > > > > > > > > know when the lifetime of the buffer ends, so if we disal=
low spills until its
> > > > > > > > > written over it's going to be a pain for users.
> > > > > > > > >
> > > > > > > > > Something like:
> > > > > > > > >
> > > > > > > > > for (...) {
> > > > > > > > >         char buf[64];
> > > > > > > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > > > > > > >         ...
> > > > > > > > > }
> > > > > > > > >
> > > > > > > > > .. and then compiler decides to spill something where buf=
 was located on stack
> > > > > > > > > outside the for loop. The verifier can't know when buf go=
es out of scope to
> > > > > > > > > unpoison the slots.
> > > > > > > >
> > > > > > > > You're saying the "verifier doesn't know when buf ...".
> > > > > > > > The same applies to the compiler. It has no visibility
> > > > > > > > into what bpf_dynptr_slice_rdwr is doing.
> > > > > > >
> > > > > > > That is true, it can't assume anything about the side effects=
. But I am talking
> > > > > > > about the point in the program when the buffer object no long=
er lives. Use of
> > > > > > > the escaped pointer to such an object any longer is UB. The c=
ompiler is well
> > > > > > > within its rights to reuse its stack storage at that point, i=
ncluding for
> > > > > > > spilling registers. Which is why "outside the for loop" in my=
 earlier reply.
> > > > > > >
> > > > > > > > So it never spills into a declared C array
> > > > > > > > as I tried to explain in the previous reply.
> > > > > > > > Spill/fill slots are always invisible to C.
> > > > > > > > (unless of course you do pointer arithmetic asm style)
> > > > > > >
> > > > > > > When the declared array's lifetime ends, it can.
> > > > > > > https://godbolt.org/z/Ez7v4xfnv
> > > > > > >
> > > > > > > The 2nd call to bar as part of unrolled loop happens with fp-=
8, then it calls
> > > > > > > baz, spills r0 to fp-8, and calls bar again with fp-8.
> > > > >
> > > > > Right. If user writes such program and does explicit store of spi=
llable
> > > > > pointer into a stack.
> > > > > I was talking about compiler generated spill/fill and I still bel=
ieve
> > > > > that compiler will not be reusing variable's stack memory for the=
m.
> > > > >
> > > > > > >
> > > > > > > If such a stack slot is STACK_POISON, verifier will reject th=
is program.
> > > > >
> > > > > Yes and I think it's an ok trade-off.
> > > > > The user has to specifically code such program to hit this issue.
> > > > > I don't think we will see this in practice.
> > > > > If we do we can consider a more complex fix.
> > > >
> > > > I was just debugging (a completely unrelated) issue where two
> > > > completely independent functions, with different local variables, w=
ere
> > > > reusing the same stack slots just because of them being inlined in
> > > > parent functions. So stack reuse happens all the time, unfortunatel=
y.
> > > > It's not always obvious or malicious.
> > >
> > > Right. Stack reuse happens for variables all the time.
> > > I'm still arguing that compile internal spill/fill is coming
> > > from different slots.
> > >
> > > When clang compiles the kernel it prints:
> > > ../kernel/bpf/verifier.c:18017:5: warning: stack frame size (2296)
> > > exceeds limit (2048) in 'bpf_check' [-Wframe-larger-than]
> > > int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t =
uattr)
> > >     ^
> > > 572/2296 (24.91%) spills, 1724/2296 (75.09%) variables
> > >
> > > spills and variables are different areas.
> > >
> > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > > > > +       *(void **)eth =3D (void *)0xdeadbeef;
> > > > > > > > > > > +       ctx =3D *(void **)buffer;
> > > > > > > > > > > +       eth_proto =3D eth->eth_proto + ctx->len;
> > > > > > > > > > >         if (eth_proto =3D=3D bpf_htons(ETH_P_IP))
> > > > > > > > > > >                 err =3D process_packet(&ptr, eth, nh_=
off, false, ctx);
> > > > > > > > > > >
> > > > > > > > > > > I think the proper fix is to treat it as a separate r=
eturn type distinct from
> > > > > > > > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_M=
EM | DYNPTR_* specially),
> > > > > > > > > > > fork verifier state whenever there is a write, so tha=
t one path verifies it as
> > > > > > > > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buff=
er was a stack ptr). I
> > > > > > > > > > > think for the rest it's not a problem, but there are =
allow_ptr_leak checks
> > > > > > > > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that=
 needs to be rechecked.
> > > > > > > > > > > Then we ensure that program is safe in either path.
> > > > > > > > > > >
> > > > > > > > > > > Also we need to fix regsafe to not consider other PTR=
_TO_MEMs equivalent to such
> > > > > > > > > > > a pointer. We could also fork verifier states on retu=
rn, to verify either path
> > > > > > > > > > > separately right from the point following the call in=
struction.
> > > > > > > > > >
> > > > > > > > > > This is too complex imo.
> > > > > > > > >
> > > > > > > > > A better way to phrase this is to verify with R0 =3D PTR_=
TO_PACKET in one path,
> > > > > > > > > and push_stack with R0 =3D buffer's reg->type + size set =
to len in the other path
> > > > > > > > > for exploration later. In terms of verifier infra everyth=
ing is there already,
> > > > > > > > > it just needs to analyze both cases which fall into the r=
egular code handling
> > > > > > > > > the reg->type's. Probably then no adjustments to regsafe =
are needed either. It's
> > > > > > > > > like exploring branch instructions.
> > > > > > > >
> > > > > > > > I still don't like it. There is no reason to go a complex p=
ath
> > > > > > > > when much simpler suffices.
> > > > > >
> > > > > > This issue you are discussing is the reason we don't support
> > > > > > bpf_dynptr_from_mem() taking PTR_TO_STACK (which is a pity, but=
 we
> > > > > > postponed it initially).
> > > > > >
> > > > > > I've been thinking about something along the lines of STACK_POI=
SON,
> > > > > > but remembering associated id/ref_obj_id. When ref is released,=
 turn
> > > > > > STACK_POISON to STACK_MISC. If it's bpf_dynptr_slice_rdrw() or
> > > > > > bpf_dynptr_from_mem(), which don't have ref_obj_id, they still =
have ID
> > > > > > associated with returned pointer, so can we somehow incorporate=
 that?
> > > > >
> > > > > There is dynptr_id in PTR_TO_MEM that is used by destroy_if_dynpt=
r_stack_slot(),
> > > > > but I don't see how we can use it to help this case.
> > > > > imo plain STACK_POISON that is overwriteable by STACK_MISC/STACK_=
ZERO
> > > > > should be good enough in practice.
> > > >
> > > > That's basically what I'm proposing, except when this overwrite
> > > > happens we have to go and invalidate all the PTR_TO_MEM references
> > > > that are pointing to that stack slot. E.g., in the below case
> > > > (assuming we allow LOCAL dynptr to be constructed from stack)
> > > >
> > > > char buf[256], *p;
> > > > struct bpf_dynptr dptr;
> > > >
> > > > bpf_dynptr_from_mem(buf, buf+256, &dptr);
> > > >
> > > > p =3D bpf_dynptr_data(&dptr, 128, 16); /* get 16-byte slice into bu=
f, at
> > > > offset 128 */
> > > >
> > > > /* buf[128] through buf[128+16] are STACK_POISON */
> > > >
> > > > buf[128] =3D 123;
> > > >
> > > > So here is where the problem happens. Should we invalidate just p
> > > > here? Or entire dptr? Haven't thought much about details, but
> > > > something like that. It was getting messy when we started to think
> > > > about this with Joanne.
> > >
> > > Let's table dynptr_from_mem for a second and solve
> > > bpf_dynptr_slice_rdrw first, since I'm getting confused.
> > >
> > > For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
> > > poisoned with dynptr_id =3D=3D R0's PTR_TO_MEM dynptr_id.
> > > Then as soon as first spillable reg touches that poisoned stack area
> > > we can invalidate all PTR_TO_MEM's with that dynptr_id.
> >
> > Okay, this makes sense to me. are you already currently working or
> > planning to work on a fix for this Kumar, or should i take a stab at
> > it?
>
> I'm not planning to do so, so go ahead. One more thing I noticed just now=
 is
> that we probably need to update regsafe to perform a check_ids comparison=
 for
> dynptr_id for dynptr PTR_TO_MEMs? It was not a problem back when f8064ab9=
0d66
> ("bpf: Invalidate slices on destruction of dynptrs on stack") was added b=
ut
> 567da5d253cd ("bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP_BUFFE=
R}")
> added PTR_TO_MEM in the switch statement.

I can take care of this. But I really would like to avoid these
special cases of extra dynptr_id, exactly for reasons like this
omitted check.

What do people think about generalizing current ref_obj_id to be more
like "lifetime id" (to borrow Rust terminology a bit), which would be
an object (which might or might not be a tracked reference) defining
the scope/lifetime of the current register (whatever it represents).

I haven't looked through code much, but I've been treating ref_obj_id
as that already in my thinking before, and it seems to be a better
approach than having a special-case of dynptr_id.

Thoughts?
