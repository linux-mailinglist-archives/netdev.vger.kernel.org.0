Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0527D6B5394
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjCJV6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCJV6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:58:33 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0939013E0BF;
        Fri, 10 Mar 2023 13:55:13 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s11so26170855edy.8;
        Fri, 10 Mar 2023 13:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678485304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1S62jwxbgpIp0Z7Ot0lYOjKjt2pwmwo0RK4RBJDuwoY=;
        b=ob/dNqU5yZqyyOE1m2kUzhfrQVymCZ2azoZQ/pSj4gUUKOWv6D/A9foEGjesoOrnP+
         jZwLyT4WlXQKxNw/2U3yVA0eZOt6mPa+hCESpEjKaMb78GTUmM+8biWi1f5ZkMYAZi2U
         V1/udCLzlX8gLa8IzQPRQh4U07GpM68LEsbhjfTIQKtcgn2IS+nPPNhPFmz9bAEPB8Mr
         zf9GlbreBjj1uClRCmUek2c3Uenb1Zi9kKOFwUTVZTgi1f8Ek9fT0cqvuCQSSH1ZxI/X
         ufQfFesmQI0mpXOgFeqFFwFnN9OquEttXovt9kqX6GkWfqRsGHW4dGmAlWht8IypjiCm
         jgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678485304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1S62jwxbgpIp0Z7Ot0lYOjKjt2pwmwo0RK4RBJDuwoY=;
        b=JtPy4LVg0sp3ySziitw97E4MjP5tNTpjgqq4G3ZmOmYs8tJxdiAYouSvFKW9eUyE6O
         GUy6FyQEmGbeVG18+Lqcltbr6bAu45dPTX5W7RHxQ5XQJxBpObeN2cy7c/kp6t0raHxQ
         hd3eh/uUHp5NYXsEhcAiVziPQOfOugNu1cnxMskH75yTbvtpv+I2TCkqMRrN42xkFFn/
         iJXUp58zMsUu6/KNop/11tEctnV/iqiMAHb7hs2x8X5JGoFMY3BV4OLm8Vj64InIFytU
         68wG6Mv2IEDxCpypGSK9LiF2N3CDZk7psyupMwdP2AMJ9CdimiD18Et+sI0aL2rlFV79
         d1Zg==
X-Gm-Message-State: AO0yUKWtdlppu9GxDrUTp3rbvdV+YnVN/yHUfpZ0c7Or4yhl+gq56Arx
        WAuChsdqy2XCSeeqid1693QB+vwulu420gmQt/N/1pUI29Y=
X-Google-Smtp-Source: AK7set+3go0O5fZrIUK2G2W7RfSgbEe9i42YtZQYcFEFv8vgkY5J9Cn1y4z5wlb8blF1E7u9rJfeLRA2V1eOkaydtKw=
X-Received: by 2002:a17:907:20b8:b0:914:5659:593 with SMTP id
 pw24-20020a17090720b800b0091456590593mr8357182ejb.3.1678485304241; Fri, 10
 Mar 2023 13:55:04 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com> <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo> <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com> <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
In-Reply-To: <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Mar 2023 13:54:52 -0800
Message-ID: <CAADnVQLBDNqqfoNOV=mPxvsMdXLJCK_g1qmHjqxo=PED_vbhuw@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Mar 10, 2023 at 1:30=E2=80=AFPM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Mar 10, 2023 at 1:15=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > > >
> > > > > > I agree this is simpler, but I'm not sure it will work properly=
. Verifier won't
> > > > > > know when the lifetime of the buffer ends, so if we disallow sp=
ills until its
> > > > > > written over it's going to be a pain for users.
> > > > > >
> > > > > > Something like:
> > > > > >
> > > > > > for (...) {
> > > > > >         char buf[64];
> > > > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > > > >         ...
> > > > > > }
> > > > > >
> > > > > > .. and then compiler decides to spill something where buf was l=
ocated on stack
> > > > > > outside the for loop. The verifier can't know when buf goes out=
 of scope to
> > > > > > unpoison the slots.
> > > > >
> > > > > You're saying the "verifier doesn't know when buf ...".
> > > > > The same applies to the compiler. It has no visibility
> > > > > into what bpf_dynptr_slice_rdwr is doing.
> > > >
> > > > That is true, it can't assume anything about the side effects. But =
I am talking
> > > > about the point in the program when the buffer object no longer liv=
es. Use of
> > > > the escaped pointer to such an object any longer is UB. The compile=
r is well
> > > > within its rights to reuse its stack storage at that point, includi=
ng for
> > > > spilling registers. Which is why "outside the for loop" in my earli=
er reply.
> > > >
> > > > > So it never spills into a declared C array
> > > > > as I tried to explain in the previous reply.
> > > > > Spill/fill slots are always invisible to C.
> > > > > (unless of course you do pointer arithmetic asm style)
> > > >
> > > > When the declared array's lifetime ends, it can.
> > > > https://godbolt.org/z/Ez7v4xfnv
> > > >
> > > > The 2nd call to bar as part of unrolled loop happens with fp-8, the=
n it calls
> > > > baz, spills r0 to fp-8, and calls bar again with fp-8.
> >
> > Right. If user writes such program and does explicit store of spillable
> > pointer into a stack.
> > I was talking about compiler generated spill/fill and I still believe
> > that compiler will not be reusing variable's stack memory for them.
> >
> > > >
> > > > If such a stack slot is STACK_POISON, verifier will reject this pro=
gram.
> >
> > Yes and I think it's an ok trade-off.
> > The user has to specifically code such program to hit this issue.
> > I don't think we will see this in practice.
> > If we do we can consider a more complex fix.
>
> I was just debugging (a completely unrelated) issue where two
> completely independent functions, with different local variables, were
> reusing the same stack slots just because of them being inlined in
> parent functions. So stack reuse happens all the time, unfortunately.
> It's not always obvious or malicious.

Right. Stack reuse happens for variables all the time.
I'm still arguing that compile internal spill/fill is coming
from different slots.

When clang compiles the kernel it prints:
../kernel/bpf/verifier.c:18017:5: warning: stack frame size (2296)
exceeds limit (2048) in 'bpf_check' [-Wframe-larger-than]
int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
    ^
572/2296 (24.91%) spills, 1724/2296 (75.09%) variables

spills and variables are different areas.

> >
> > > >
> > > > >
> > > > > > > > +       *(void **)eth =3D (void *)0xdeadbeef;
> > > > > > > > +       ctx =3D *(void **)buffer;
> > > > > > > > +       eth_proto =3D eth->eth_proto + ctx->len;
> > > > > > > >         if (eth_proto =3D=3D bpf_htons(ETH_P_IP))
> > > > > > > >                 err =3D process_packet(&ptr, eth, nh_off, f=
alse, ctx);
> > > > > > > >
> > > > > > > > I think the proper fix is to treat it as a separate return =
type distinct from
> > > > > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | D=
YNPTR_* specially),
> > > > > > > > fork verifier state whenever there is a write, so that one =
path verifies it as
> > > > > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was=
 a stack ptr). I
> > > > > > > > think for the rest it's not a problem, but there are allow_=
ptr_leak checks
> > > > > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs=
 to be rechecked.
> > > > > > > > Then we ensure that program is safe in either path.
> > > > > > > >
> > > > > > > > Also we need to fix regsafe to not consider other PTR_TO_ME=
Ms equivalent to such
> > > > > > > > a pointer. We could also fork verifier states on return, to=
 verify either path
> > > > > > > > separately right from the point following the call instruct=
ion.
> > > > > > >
> > > > > > > This is too complex imo.
> > > > > >
> > > > > > A better way to phrase this is to verify with R0 =3D PTR_TO_PAC=
KET in one path,
> > > > > > and push_stack with R0 =3D buffer's reg->type + size set to len=
 in the other path
> > > > > > for exploration later. In terms of verifier infra everything is=
 there already,
> > > > > > it just needs to analyze both cases which fall into the regular=
 code handling
> > > > > > the reg->type's. Probably then no adjustments to regsafe are ne=
eded either. It's
> > > > > > like exploring branch instructions.
> > > > >
> > > > > I still don't like it. There is no reason to go a complex path
> > > > > when much simpler suffices.
> > >
> > > This issue you are discussing is the reason we don't support
> > > bpf_dynptr_from_mem() taking PTR_TO_STACK (which is a pity, but we
> > > postponed it initially).
> > >
> > > I've been thinking about something along the lines of STACK_POISON,
> > > but remembering associated id/ref_obj_id. When ref is released, turn
> > > STACK_POISON to STACK_MISC. If it's bpf_dynptr_slice_rdrw() or
> > > bpf_dynptr_from_mem(), which don't have ref_obj_id, they still have I=
D
> > > associated with returned pointer, so can we somehow incorporate that?
> >
> > There is dynptr_id in PTR_TO_MEM that is used by destroy_if_dynptr_stac=
k_slot(),
> > but I don't see how we can use it to help this case.
> > imo plain STACK_POISON that is overwriteable by STACK_MISC/STACK_ZERO
> > should be good enough in practice.
>
> That's basically what I'm proposing, except when this overwrite
> happens we have to go and invalidate all the PTR_TO_MEM references
> that are pointing to that stack slot. E.g., in the below case
> (assuming we allow LOCAL dynptr to be constructed from stack)
>
> char buf[256], *p;
> struct bpf_dynptr dptr;
>
> bpf_dynptr_from_mem(buf, buf+256, &dptr);
>
> p =3D bpf_dynptr_data(&dptr, 128, 16); /* get 16-byte slice into buf, at
> offset 128 */
>
> /* buf[128] through buf[128+16] are STACK_POISON */
>
> buf[128] =3D 123;
>
> So here is where the problem happens. Should we invalidate just p
> here? Or entire dptr? Haven't thought much about details, but
> something like that. It was getting messy when we started to think
> about this with Joanne.

Let's table dynptr_from_mem for a second and solve
bpf_dynptr_slice_rdrw first, since I'm getting confused.

For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
poisoned with dynptr_id =3D=3D R0's PTR_TO_MEM dynptr_id.
Then as soon as first spillable reg touches that poisoned stack area
we can invalidate all PTR_TO_MEM's with that dynptr_id.
