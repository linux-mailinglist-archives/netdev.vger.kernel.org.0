Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBBD6AFAD5
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCHABy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjCHABp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:01:45 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1571BABB34;
        Tue,  7 Mar 2023 16:01:42 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s11so59227424edy.8;
        Tue, 07 Mar 2023 16:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678233700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hWyr1y9BDVDXdSu1/qq3ONF6NdiP3kQ4hj/kmPCadA=;
        b=hUEcetOY/sYkl3Aj5/Tg2D9QlXfw6zVhBP+NW68haGJblUWFRVOEpqiX/RELZgown2
         8q7Bt5BzruTKgzRCaltlj0F2Al3WOdNh3wTuShSlBfKfGn3PXsJ02xuyLyS/OFxklX5/
         ygp0FSZ4vC86RTtqe7OZd3gQzqxtKWha/DDuXuTp4vneJ582LzvsY003fqzHEUy0Bv0b
         ixrz8vPU/Yprhbf4hyWoIIBZ5rEekX0u2mNu4ZMwqbDAhvKhhReNAWb1cVcuQnYuJJx+
         iupWtKMpPiByhPt9JP1awxueMh2UWe+q7f4j6QkR2SLRVuCg/yioLPRewkQNJ1R4FK6a
         FEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678233700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hWyr1y9BDVDXdSu1/qq3ONF6NdiP3kQ4hj/kmPCadA=;
        b=bBqMjVzOh5HlyGZx6hy3/fd+PWRoyOEyus95boTspD3cEc6VLWhYyVo+Oel2cuVtCy
         KofGCWTfbcSrilZeCBEXQiSWw018RNvv0FT20SjP3RpXFUJ5ENfu6Vj8R8JzKKFGSOXU
         46Cau0x4oexzisEcTmJrCT29YdFisjhgYK5Gmb1xcmlQb1XXKiLWGpYXeYECm6Dmfsqn
         FYW4wSOMWlLyoKCxBVV6P/AKPVLjmRJRJEKBgoMjIDziMe3Dx6kqU8f1UnmW3u1djonn
         GC5JMaueJk9wsDGWxciQSnMj2lw64ebN8NP6d+rkTeE49IvIgKghgYBfu3m5+/AUcFPo
         C1BQ==
X-Gm-Message-State: AO0yUKVSDhDL/+/XEQEBNObER5ZcbG6bM7ipzQoLT/2p52N93v3bA+eX
        RyYzS7A7imFCcLeI7/cwBSDDaTTF+Tc9XvWua7Y/JOrb
X-Google-Smtp-Source: AK7set/chJjWtNbsQ7wa64cmVEWxF70eQ8mjRP6cWXrjxhPcaLNs9WOMRtYTOfVQZI4Bu74l9Q5J2BGup7EG/k7EZ3M=
X-Received: by 2002:a50:c057:0:b0:4c1:b5de:b72d with SMTP id
 u23-20020a50c057000000b004c1b5deb72dmr9122712edd.5.1678233700481; Tue, 07 Mar
 2023 16:01:40 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com> <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo> <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo>
In-Reply-To: <20230307173529.gi2crls7fktn6uox@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Mar 2023 16:01:28 -0800
Message-ID: <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Tue, Mar 7, 2023 at 9:35=E2=80=AFAM Kumar Kartikeya Dwivedi <memxor@gmai=
l.com> wrote:
>
> On Tue, Mar 07, 2023 at 04:45:14PM CET, Alexei Starovoitov wrote:
> > On Tue, Mar 7, 2023 at 2:22=E2=80=AFAM Kumar Kartikeya Dwivedi <memxor@=
gmail.com> wrote:
> > >
> > > On Tue, Mar 07, 2023 at 03:23:25AM CET, Alexei Starovoitov wrote:
> > > > On Sun, Mar 5, 2023 at 11:10=E2=80=AFPM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > On Wed, Mar 01, 2023 at 04:49:52PM CET, Joanne Koong wrote:
> > > > > > Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice=
_rdwr.
> > > > > > The user must pass in a buffer to store the contents of the dat=
a slice
> > > > > > if a direct pointer to the data cannot be obtained.
> > > > > >
> > > > > > For skb and xdp type dynptrs, these two APIs are the only way t=
o obtain
> > > > > > a data slice. However, for other types of dynptrs, there is no
> > > > > > difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.
> > > > > >
> > > > > > For skb type dynptrs, the data is copied into the user provided=
 buffer
> > > > > > if any of the data is not in the linear portion of the skb. For=
 xdp type
> > > > > > dynptrs, the data is copied into the user provided buffer if th=
e data is
> > > > > > between xdp frags.
> > > > > >
> > > > > > If the skb is cloned and a call to bpf_dynptr_data_rdwr is made=
, then
> > > > > > the skb will be uncloned (see bpf_unclone_prologue()).
> > > > > >
> > > > > > Please note that any bpf_dynptr_write() automatically invalidat=
es any prior
> > > > > > data slices of the skb dynptr. This is because the skb may be c=
loned or
> > > > > > may need to pull its paged buffer into the head. As such, any
> > > > > > bpf_dynptr_write() will automatically have its prior data slice=
s
> > > > > > invalidated, even if the write is to data in the skb head of an=
 uncloned
> > > > > > skb. Please note as well that any other helper calls that chang=
e the
> > > > > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates a=
ny data
> > > > > > slices of the skb dynptr as well, for the same reasons.
> > > > > >
> > > > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > > > ---
> > > > >
> > > > > Sorry for chiming in late.
> > > > >
> > > > > I see one potential hole in bpf_dynptr_slice_rdwr. If the returne=
d pointer is
> > > > > actually pointing to the stack (but verified as a PTR_TO_MEM in v=
erifier state),
> > > > > we won't reflect changes to the stack state in the verifier for w=
rites happening
> > > > > through it.
> > > > >
> > > > > For the worst case scenario, this will basically allow overwritin=
g values of
> > > > > spilled pointers and doing arbitrary kernel memory reads/writes. =
This is only an
> > > > > issue when bpf_dynptr_slice_rdwr at runtime returns a pointer to =
the supplied
> > > > > buffer residing on program stack. To verify, by forcing the memcp=
y to buffer for
> > > > > skb_header_pointer I was able to make it dereference a garbage va=
lue for
> > > > > l4lb_all selftest.
> > > > >
> > > > > --- a/kernel/bpf/helpers.c
> > > > > +++ b/kernel/bpf/helpers.c
> > > > > @@ -2253,7 +2253,13 @@ __bpf_kfunc void *bpf_dynptr_slice(const s=
truct bpf_dynptr_kern *ptr, u32 offset
> > > > >         case BPF_DYNPTR_TYPE_RINGBUF:
> > > > >                 return ptr->data + ptr->offset + offset;
> > > > >         case BPF_DYNPTR_TYPE_SKB:
> > > > > -               return skb_header_pointer(ptr->data, ptr->offset =
+ offset, len, buffer);
> > > > > +       {
> > > > > +               void *p =3D skb_header_pointer(ptr->data, ptr->of=
fset + offset, len, buffer);
> > > > > +               if (p =3D=3D buffer)
> > > > > +                       return p;
> > > > > +               memcpy(buffer, p, len);
> > > > > +               return buffer;
> > > > > +       }
> > > > >
> > > > > --- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr=
.c
> > > > > +++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr=
.c
> > > > > @@ -470,7 +470,10 @@ int balancer_ingress(struct __sk_buff *ctx)
> > > > >         eth =3D bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buf=
fer));
> > > > >         if (!eth)
> > > > >                 return TC_ACT_SHOT;
> > > > > -       eth_proto =3D eth->eth_proto;
> > > > > +       *(void **)buffer =3D ctx;
> > > >
> > > > Great catch.
> > > > To fix the issue I think we should simply disallow such
> > > > stack abuse. The compiler won't be spilling registers
> > > > into C array on the stack.
> > > > This manual spill/fill is exploiting verifier logic.
> > > > After bpf_dynptr_slice_rdwr() we can mark all slots of the
> > > > buffer as STACK_POISON or some better name and
> > > > reject spill into such slots.
> > > >
> > >
> > > I agree this is simpler, but I'm not sure it will work properly. Veri=
fier won't
> > > know when the lifetime of the buffer ends, so if we disallow spills u=
ntil its
> > > written over it's going to be a pain for users.
> > >
> > > Something like:
> > >
> > > for (...) {
> > >         char buf[64];
> > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > >         ...
> > > }
> > >
> > > .. and then compiler decides to spill something where buf was located=
 on stack
> > > outside the for loop. The verifier can't know when buf goes out of sc=
ope to
> > > unpoison the slots.
> >
> > You're saying the "verifier doesn't know when buf ...".
> > The same applies to the compiler. It has no visibility
> > into what bpf_dynptr_slice_rdwr is doing.
>
> That is true, it can't assume anything about the side effects. But I am t=
alking
> about the point in the program when the buffer object no longer lives. Us=
e of
> the escaped pointer to such an object any longer is UB. The compiler is w=
ell
> within its rights to reuse its stack storage at that point, including for
> spilling registers. Which is why "outside the for loop" in my earlier rep=
ly.
>
> > So it never spills into a declared C array
> > as I tried to explain in the previous reply.
> > Spill/fill slots are always invisible to C.
> > (unless of course you do pointer arithmetic asm style)
>
> When the declared array's lifetime ends, it can.
> https://godbolt.org/z/Ez7v4xfnv
>
> The 2nd call to bar as part of unrolled loop happens with fp-8, then it c=
alls
> baz, spills r0 to fp-8, and calls bar again with fp-8.
>
> If such a stack slot is STACK_POISON, verifier will reject this program.
>
> >
> > > > > +       *(void **)eth =3D (void *)0xdeadbeef;
> > > > > +       ctx =3D *(void **)buffer;
> > > > > +       eth_proto =3D eth->eth_proto + ctx->len;
> > > > >         if (eth_proto =3D=3D bpf_htons(ETH_P_IP))
> > > > >                 err =3D process_packet(&ptr, eth, nh_off, false, =
ctx);
> > > > >
> > > > > I think the proper fix is to treat it as a separate return type d=
istinct from
> > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_=
* specially),
> > > > > fork verifier state whenever there is a write, so that one path v=
erifies it as
> > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a sta=
ck ptr). I
> > > > > think for the rest it's not a problem, but there are allow_ptr_le=
ak checks
> > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be=
 rechecked.
> > > > > Then we ensure that program is safe in either path.
> > > > >
> > > > > Also we need to fix regsafe to not consider other PTR_TO_MEMs equ=
ivalent to such
> > > > > a pointer. We could also fork verifier states on return, to verif=
y either path
> > > > > separately right from the point following the call instruction.
> > > >
> > > > This is too complex imo.
> > >
> > > A better way to phrase this is to verify with R0 =3D PTR_TO_PACKET in=
 one path,
> > > and push_stack with R0 =3D buffer's reg->type + size set to len in th=
e other path
> > > for exploration later. In terms of verifier infra everything is there=
 already,
> > > it just needs to analyze both cases which fall into the regular code =
handling
> > > the reg->type's. Probably then no adjustments to regsafe are needed e=
ither. It's
> > > like exploring branch instructions.
> >
> > I still don't like it. There is no reason to go a complex path
> > when much simpler suffices.

This issue you are discussing is the reason we don't support
bpf_dynptr_from_mem() taking PTR_TO_STACK (which is a pity, but we
postponed it initially).

I've been thinking about something along the lines of STACK_POISON,
but remembering associated id/ref_obj_id. When ref is released, turn
STACK_POISON to STACK_MISC. If it's bpf_dynptr_slice_rdrw() or
bpf_dynptr_from_mem(), which don't have ref_obj_id, they still have ID
associated with returned pointer, so can we somehow incorporate that?
