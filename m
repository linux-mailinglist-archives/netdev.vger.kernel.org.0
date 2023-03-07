Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46126AE52B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjCGPpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjCGPp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:45:28 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F4D29E2D;
        Tue,  7 Mar 2023 07:45:27 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s11so54011758edy.8;
        Tue, 07 Mar 2023 07:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678203926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=277q2V+lY8OBSvMhlgAtku8Kf4ubYKKddk6o8q89oYY=;
        b=bzr5gfqT3t2uS7nPD9rE876ItTBtQK2df7AJkSRTaezmgmRY6YCV7JO4ptMameVymU
         rt2Q7lMWvhzP2coAH0YE5zXIBtDXDkI1vYC2l3TmSuSxFSwQMby4KGMy/srtW4O1lLwB
         x7zcvN8/fQZ9unbnCX0DDwHHBe9RFkIrWsH1PDaUA33R/qHYJeAvZ9pnyMaycPFhQtlh
         iFGq+ZffrkDga1pq8iGcyKktPHC1P1gni7DojfKyae6rsv/9r7dr92M3K860bYgGSoz3
         Eh4DiBbq7p2F2AYqpV6UimUlj7eZFV47K5eWZSyCeN1YZnMCxlbqsOVSgbYq+yP4nIpA
         x1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=277q2V+lY8OBSvMhlgAtku8Kf4ubYKKddk6o8q89oYY=;
        b=BVImjJhvM5i4wG1tX3Y7jca2Vi0Fuhx9sYp5Gi5zvq3XokainQC2WLzQqXSFMau5sK
         sKIWGNq3dUp0TX1oIdgY16qeOQmrr+G6MdpFf7qwtIwlFQ1kOpMN0gZRufSaQOAZzXrf
         BnmYXPa9HdZ99O7uZJMHIxE5Y2dYPYqByG+QXEdVFdFaBc2L0NOWVcJxY25x+SkaYn+O
         DiO8owO+DYt3luzHm4gN4gqaRMFZMdXBsZgPoCAlluKtoRQJ80BaQAgTs+DGA4c80Kbn
         zCJp5i8YZ580TW5ZvSFIjJaORQvfQEoJizEEAMpKDs1Qvlqb5P9Qvh9Hiy2/SnF4vTMH
         zQCQ==
X-Gm-Message-State: AO0yUKWv7g6GV2D4+GN6AP2J++zOwmgAN7bwuLJnDEaI8Ohiafk68MNx
        q9IvTzJ1iVFstQ78f1Px1921ZYKf96WQaeWoK7w=
X-Google-Smtp-Source: AK7set9VmWNhoK2WmbWREy3v2d9xaYAuWuBONaFPmQWuhaCeRhr3D30kCD5AibujLdnFbgmw3OHx8CK2xX4HzUA2hVc=
X-Received: by 2002:a50:9f26:0:b0:4c0:1cfa:bfe1 with SMTP id
 b35-20020a509f26000000b004c01cfabfe1mr8243289edf.6.1678203925530; Tue, 07 Mar
 2023 07:45:25 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com> <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com> <20230307102233.bemr47x625ity26z@apollo>
In-Reply-To: <20230307102233.bemr47x625ity26z@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Mar 2023 07:45:14 -0800
Message-ID: <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf <bpf@vger.kernel.org>,
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

On Tue, Mar 7, 2023 at 2:22=E2=80=AFAM Kumar Kartikeya Dwivedi <memxor@gmai=
l.com> wrote:
>
> On Tue, Mar 07, 2023 at 03:23:25AM CET, Alexei Starovoitov wrote:
> > On Sun, Mar 5, 2023 at 11:10=E2=80=AFPM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Wed, Mar 01, 2023 at 04:49:52PM CET, Joanne Koong wrote:
> > > > Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice_rdw=
r.
> > > > The user must pass in a buffer to store the contents of the data sl=
ice
> > > > if a direct pointer to the data cannot be obtained.
> > > >
> > > > For skb and xdp type dynptrs, these two APIs are the only way to ob=
tain
> > > > a data slice. However, for other types of dynptrs, there is no
> > > > difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.
> > > >
> > > > For skb type dynptrs, the data is copied into the user provided buf=
fer
> > > > if any of the data is not in the linear portion of the skb. For xdp=
 type
> > > > dynptrs, the data is copied into the user provided buffer if the da=
ta is
> > > > between xdp frags.
> > > >
> > > > If the skb is cloned and a call to bpf_dynptr_data_rdwr is made, th=
en
> > > > the skb will be uncloned (see bpf_unclone_prologue()).
> > > >
> > > > Please note that any bpf_dynptr_write() automatically invalidates a=
ny prior
> > > > data slices of the skb dynptr. This is because the skb may be clone=
d or
> > > > may need to pull its paged buffer into the head. As such, any
> > > > bpf_dynptr_write() will automatically have its prior data slices
> > > > invalidated, even if the write is to data in the skb head of an unc=
loned
> > > > skb. Please note as well that any other helper calls that change th=
e
> > > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any d=
ata
> > > > slices of the skb dynptr as well, for the same reasons.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > >
> > > Sorry for chiming in late.
> > >
> > > I see one potential hole in bpf_dynptr_slice_rdwr. If the returned po=
inter is
> > > actually pointing to the stack (but verified as a PTR_TO_MEM in verif=
ier state),
> > > we won't reflect changes to the stack state in the verifier for write=
s happening
> > > through it.
> > >
> > > For the worst case scenario, this will basically allow overwriting va=
lues of
> > > spilled pointers and doing arbitrary kernel memory reads/writes. This=
 is only an
> > > issue when bpf_dynptr_slice_rdwr at runtime returns a pointer to the =
supplied
> > > buffer residing on program stack. To verify, by forcing the memcpy to=
 buffer for
> > > skb_header_pointer I was able to make it dereference a garbage value =
for
> > > l4lb_all selftest.
> > >
> > > --- a/kernel/bpf/helpers.c
> > > +++ b/kernel/bpf/helpers.c
> > > @@ -2253,7 +2253,13 @@ __bpf_kfunc void *bpf_dynptr_slice(const struc=
t bpf_dynptr_kern *ptr, u32 offset
> > >         case BPF_DYNPTR_TYPE_RINGBUF:
> > >                 return ptr->data + ptr->offset + offset;
> > >         case BPF_DYNPTR_TYPE_SKB:
> > > -               return skb_header_pointer(ptr->data, ptr->offset + of=
fset, len, buffer);
> > > +       {
> > > +               void *p =3D skb_header_pointer(ptr->data, ptr->offset=
 + offset, len, buffer);
> > > +               if (p =3D=3D buffer)
> > > +                       return p;
> > > +               memcpy(buffer, p, len);
> > > +               return buffer;
> > > +       }
> > >
> > > --- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
> > > @@ -470,7 +470,10 @@ int balancer_ingress(struct __sk_buff *ctx)
> > >         eth =3D bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer)=
);
> > >         if (!eth)
> > >                 return TC_ACT_SHOT;
> > > -       eth_proto =3D eth->eth_proto;
> > > +       *(void **)buffer =3D ctx;
> >
> > Great catch.
> > To fix the issue I think we should simply disallow such
> > stack abuse. The compiler won't be spilling registers
> > into C array on the stack.
> > This manual spill/fill is exploiting verifier logic.
> > After bpf_dynptr_slice_rdwr() we can mark all slots of the
> > buffer as STACK_POISON or some better name and
> > reject spill into such slots.
> >
>
> I agree this is simpler, but I'm not sure it will work properly. Verifier=
 won't
> know when the lifetime of the buffer ends, so if we disallow spills until=
 its
> written over it's going to be a pain for users.
>
> Something like:
>
> for (...) {
>         char buf[64];
>         bpf_dynptr_slice_rdwr(..., buf, 64);
>         ...
> }
>
> .. and then compiler decides to spill something where buf was located on =
stack
> outside the for loop. The verifier can't know when buf goes out of scope =
to
> unpoison the slots.

You're saying the "verifier doesn't know when buf ...".
The same applies to the compiler. It has no visibility
into what bpf_dynptr_slice_rdwr is doing.
So it never spills into a declared C array
as I tried to explain in the previous reply.
Spill/fill slots are always invisible to C.
(unless of course you do pointer arithmetic asm style)

> > > +       *(void **)eth =3D (void *)0xdeadbeef;
> > > +       ctx =3D *(void **)buffer;
> > > +       eth_proto =3D eth->eth_proto + ctx->len;
> > >         if (eth_proto =3D=3D bpf_htons(ETH_P_IP))
> > >                 err =3D process_packet(&ptr, eth, nh_off, false, ctx)=
;
> > >
> > > I think the proper fix is to treat it as a separate return type disti=
nct from
> > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* sp=
ecially),
> > > fork verifier state whenever there is a write, so that one path verif=
ies it as
> > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack p=
tr). I
> > > think for the rest it's not a problem, but there are allow_ptr_leak c=
hecks
> > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be rec=
hecked.
> > > Then we ensure that program is safe in either path.
> > >
> > > Also we need to fix regsafe to not consider other PTR_TO_MEMs equival=
ent to such
> > > a pointer. We could also fork verifier states on return, to verify ei=
ther path
> > > separately right from the point following the call instruction.
> >
> > This is too complex imo.
>
> A better way to phrase this is to verify with R0 =3D PTR_TO_PACKET in one=
 path,
> and push_stack with R0 =3D buffer's reg->type + size set to len in the ot=
her path
> for exploration later. In terms of verifier infra everything is there alr=
eady,
> it just needs to analyze both cases which fall into the regular code hand=
ling
> the reg->type's. Probably then no adjustments to regsafe are needed eithe=
r. It's
> like exploring branch instructions.

I still don't like it. There is no reason to go a complex path
when much simpler suffices.
