Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B126AD498
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 03:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCGCXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 21:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGCXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 21:23:40 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E20619B;
        Mon,  6 Mar 2023 18:23:38 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i34so46755148eda.7;
        Mon, 06 Mar 2023 18:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678155817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXH5bqhBGFual7LWqjNOqjuqz53XSx2QJ9I0G731fE4=;
        b=R78gyucmMZ+pWv4ygmxSpGFyXh4yZchxUvibXw7E8smZSeDlaHWbMJazxPL2+gzYE7
         o070ASq5TUyZj/kzij/EVs+bIasb7Ja6m/zp9f5jFNqx78yAvQu2vjRPQ1fKmrRxmf1+
         /fO4Ra93Ngaqe/MnDis9URaJps47i0Fjo9hMMuMWiUPiL4gjFv2xPIq3vCFedvwxJzUV
         UyJv6gUbhVBvqAeFmx44hbpAt9M16bX8CZ/B3JyWluKjY79BonUW/PsCni+njTLn1Ox9
         0R8POKGBguqYLG80PRqXMyT3UzVCvUewAs1J6RAVpnGAvk0ZQ5O8zUQZwTBIJRGfm2ry
         a+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678155817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xXH5bqhBGFual7LWqjNOqjuqz53XSx2QJ9I0G731fE4=;
        b=Qve17u/DykIJPMxFWlCgfUeVzVyhSAXAoFyLkKp22fK1GhFg/Xz/deiF1E5rwxLACn
         pDwpf10VdeeBFB+1VfO3h8rRtUhWlYKdeLJi9oid+qrcnS1LFaRWEz5LbSePOOb5/KB+
         ZnkQpl2N569Hjy3jkxdxukAb1sq7dyb65w/I93e4RJWBpZJqu1UP3eRF2A/gkgVU8/jl
         TPYFvfoqk61LqhkUtyb1jF6k3LdbqFJYxIXC+OQMDk0KlTT9vA4ySWI5VfBC0m1EgXno
         l9H9GARmFhfbccjCiNdfx8JJzwhK746OZUjHKpSDAdklCRMIPalkXRUXIGYGy9ROfj24
         syow==
X-Gm-Message-State: AO0yUKU86DjGv5ZR9LHq/FyR66tYzG7FB1QDRD1mpprC49+n/l3FO1Zc
        U9+2CXFApjePmA4KrASDNZ/YXaJCLj6fLr8ec3ub/bE7C7Y=
X-Google-Smtp-Source: AK7set9XnPIU5VOQcX3Jw9B5TwY3gEvbucpFjuSffZEJ6Vl1TicvNgZPJQJExMOm2T7AoimhW8yQl6P9F2CPZkIy0hA=
X-Received: by 2002:a17:906:747:b0:87b:dce7:c245 with SMTP id
 z7-20020a170906074700b0087bdce7c245mr5672200ejb.3.1678155816983; Mon, 06 Mar
 2023 18:23:36 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com> <20230306071006.73t5vtmxrsykw4zu@apollo>
In-Reply-To: <20230306071006.73t5vtmxrsykw4zu@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 6 Mar 2023 18:23:25 -0800
Message-ID: <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
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

On Sun, Mar 5, 2023 at 11:10=E2=80=AFPM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Mar 01, 2023 at 04:49:52PM CET, Joanne Koong wrote:
> > Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
> > The user must pass in a buffer to store the contents of the data slice
> > if a direct pointer to the data cannot be obtained.
> >
> > For skb and xdp type dynptrs, these two APIs are the only way to obtain
> > a data slice. However, for other types of dynptrs, there is no
> > difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.
> >
> > For skb type dynptrs, the data is copied into the user provided buffer
> > if any of the data is not in the linear portion of the skb. For xdp typ=
e
> > dynptrs, the data is copied into the user provided buffer if the data i=
s
> > between xdp frags.
> >
> > If the skb is cloned and a call to bpf_dynptr_data_rdwr is made, then
> > the skb will be uncloned (see bpf_unclone_prologue()).
> >
> > Please note that any bpf_dynptr_write() automatically invalidates any p=
rior
> > data slices of the skb dynptr. This is because the skb may be cloned or
> > may need to pull its paged buffer into the head. As such, any
> > bpf_dynptr_write() will automatically have its prior data slices
> > invalidated, even if the write is to data in the skb head of an unclone=
d
> > skb. Please note as well that any other helper calls that change the
> > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > slices of the skb dynptr as well, for the same reasons.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
>
> Sorry for chiming in late.
>
> I see one potential hole in bpf_dynptr_slice_rdwr. If the returned pointe=
r is
> actually pointing to the stack (but verified as a PTR_TO_MEM in verifier =
state),
> we won't reflect changes to the stack state in the verifier for writes ha=
ppening
> through it.
>
> For the worst case scenario, this will basically allow overwriting values=
 of
> spilled pointers and doing arbitrary kernel memory reads/writes. This is =
only an
> issue when bpf_dynptr_slice_rdwr at runtime returns a pointer to the supp=
lied
> buffer residing on program stack. To verify, by forcing the memcpy to buf=
fer for
> skb_header_pointer I was able to make it dereference a garbage value for
> l4lb_all selftest.
>
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -2253,7 +2253,13 @@ __bpf_kfunc void *bpf_dynptr_slice(const struct bp=
f_dynptr_kern *ptr, u32 offset
>         case BPF_DYNPTR_TYPE_RINGBUF:
>                 return ptr->data + ptr->offset + offset;
>         case BPF_DYNPTR_TYPE_SKB:
> -               return skb_header_pointer(ptr->data, ptr->offset + offset=
, len, buffer);
> +       {
> +               void *p =3D skb_header_pointer(ptr->data, ptr->offset + o=
ffset, len, buffer);
> +               if (p =3D=3D buffer)
> +                       return p;
> +               memcpy(buffer, p, len);
> +               return buffer;
> +       }
>
> --- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
> +++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
> @@ -470,7 +470,10 @@ int balancer_ingress(struct __sk_buff *ctx)
>         eth =3D bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
>         if (!eth)
>                 return TC_ACT_SHOT;
> -       eth_proto =3D eth->eth_proto;
> +       *(void **)buffer =3D ctx;

Great catch.
To fix the issue I think we should simply disallow such
stack abuse. The compiler won't be spilling registers
into C array on the stack.
This manual spill/fill is exploiting verifier logic.
After bpf_dynptr_slice_rdwr() we can mark all slots of the
buffer as STACK_POISON or some better name and
reject spill into such slots.

> +       *(void **)eth =3D (void *)0xdeadbeef;
> +       ctx =3D *(void **)buffer;
> +       eth_proto =3D eth->eth_proto + ctx->len;
>         if (eth_proto =3D=3D bpf_htons(ETH_P_IP))
>                 err =3D process_packet(&ptr, eth, nh_off, false, ctx);
>
> I think the proper fix is to treat it as a separate return type distinct =
from
> PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* specia=
lly),
> fork verifier state whenever there is a write, so that one path verifies =
it as
> PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack ptr).=
 I
> think for the rest it's not a problem, but there are allow_ptr_leak check=
s
> applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be recheck=
ed.
> Then we ensure that program is safe in either path.
>
> Also we need to fix regsafe to not consider other PTR_TO_MEMs equivalent =
to such
> a pointer. We could also fork verifier states on return, to verify either=
 path
> separately right from the point following the call instruction.

This is too complex imo.
