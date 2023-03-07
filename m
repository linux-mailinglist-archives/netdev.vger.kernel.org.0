Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706FE6ADBBA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCGKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCGKWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:22:39 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2869B6A437;
        Tue,  7 Mar 2023 02:22:36 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id j11so30673474edq.4;
        Tue, 07 Mar 2023 02:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678184555;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W7I8VYoRHwVvwNfsff/RYaOA483668vWgpIglz/Ab4k=;
        b=TfmOXaPll0mE4BY6gbG2M32Su6Q+9Em7OgkOEvFezViwrKjuK3Mfkjs9fh3gBbyVtN
         j55PR4jkiy9jtZWN7XMZjR3wVy6rAE4LbG3QY+DSNeNqD3UCDHYftUd6gWjrp/T9FSdf
         yg3tg5RuLSVOkiIHm0/QUb6DecGOQtlETkq/nNxlKDaGJpZQ1KA1zORbenhdYfZYJAo5
         QGpZc06ARD5LeHq1WNLPtBjGa0AFnKMIVL/EtCKwM5udQzcGm3se9CyBZmFiwXWxUbHd
         6Y3NGW7M6S5uC61q6RGluWCSPvmGSk6b/mpTmZcDwvIlsuwMldT/J6J0jNuSjboHQp1O
         DHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678184555;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7I8VYoRHwVvwNfsff/RYaOA483668vWgpIglz/Ab4k=;
        b=VgkOu1cmyVvesknuEDzldSJjklIJSyPmSX7Fhc5zlDKBLpjbeo8tJU0keuqEydD47m
         Vg4EPrOltGHtE2Cgewdaedup6787S2pE/tXzbhYf1uqmD5B594/BqBUaLl5XoujRA0Y3
         aXXF9MdounmX9WT7z6X/HK+q95Wn3IaerlK9W63iiYZyTFpO5JfdY5W8T6iJG+nJBQfX
         P9pZXyftUSYS8CJIKYUAoYBzUiRe0ocBkNPF0NLiUYWuB7rYF8bzGJV6a6aEEvmY4ts3
         09DxljsBTfGTWSxOPB0RBqoc9WLAJK0vb0uL3feocKzG0eZtJKjSzB+y2VJasItGjwLg
         JaPg==
X-Gm-Message-State: AO0yUKU0Riixc8XVzhgqfpBWMVlf1NObmnQPJR5MRaJcm98bFdC2vVkI
        OMbFK/XJzif70rbi/R/S0yc=
X-Google-Smtp-Source: AK7set/p1TAfnwSaiXp+HnQFFWGQB0OhgFX7Kj3C0KHqxeuj6MEvmR1D4l/+N904HtYDpVfyEElhlg==
X-Received: by 2002:aa7:d84f:0:b0:4ae:eb0f:4273 with SMTP id f15-20020aa7d84f000000b004aeeb0f4273mr13720545eds.15.1678184555112;
        Tue, 07 Mar 2023 02:22:35 -0800 (PST)
Received: from localhost ([2001:620:618:580:2:80b3:0:830])
        by smtp.gmail.com with ESMTPSA id y26-20020a170906519a00b008e53874f8d8sm5864061ejk.180.2023.03.07.02.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 02:22:34 -0800 (PST)
Date:   Tue, 7 Mar 2023 11:22:33 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230307102233.bemr47x625ity26z@apollo>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com>
 <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 03:23:25AM CET, Alexei Starovoitov wrote:
> On Sun, Mar 5, 2023 at 11:10 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Wed, Mar 01, 2023 at 04:49:52PM CET, Joanne Koong wrote:
> > > Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
> > > The user must pass in a buffer to store the contents of the data slice
> > > if a direct pointer to the data cannot be obtained.
> > >
> > > For skb and xdp type dynptrs, these two APIs are the only way to obtain
> > > a data slice. However, for other types of dynptrs, there is no
> > > difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.
> > >
> > > For skb type dynptrs, the data is copied into the user provided buffer
> > > if any of the data is not in the linear portion of the skb. For xdp type
> > > dynptrs, the data is copied into the user provided buffer if the data is
> > > between xdp frags.
> > >
> > > If the skb is cloned and a call to bpf_dynptr_data_rdwr is made, then
> > > the skb will be uncloned (see bpf_unclone_prologue()).
> > >
> > > Please note that any bpf_dynptr_write() automatically invalidates any prior
> > > data slices of the skb dynptr. This is because the skb may be cloned or
> > > may need to pull its paged buffer into the head. As such, any
> > > bpf_dynptr_write() will automatically have its prior data slices
> > > invalidated, even if the write is to data in the skb head of an uncloned
> > > skb. Please note as well that any other helper calls that change the
> > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > > slices of the skb dynptr as well, for the same reasons.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> >
> > Sorry for chiming in late.
> >
> > I see one potential hole in bpf_dynptr_slice_rdwr. If the returned pointer is
> > actually pointing to the stack (but verified as a PTR_TO_MEM in verifier state),
> > we won't reflect changes to the stack state in the verifier for writes happening
> > through it.
> >
> > For the worst case scenario, this will basically allow overwriting values of
> > spilled pointers and doing arbitrary kernel memory reads/writes. This is only an
> > issue when bpf_dynptr_slice_rdwr at runtime returns a pointer to the supplied
> > buffer residing on program stack. To verify, by forcing the memcpy to buffer for
> > skb_header_pointer I was able to make it dereference a garbage value for
> > l4lb_all selftest.
> >
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -2253,7 +2253,13 @@ __bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset
> >         case BPF_DYNPTR_TYPE_RINGBUF:
> >                 return ptr->data + ptr->offset + offset;
> >         case BPF_DYNPTR_TYPE_SKB:
> > -               return skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
> > +       {
> > +               void *p = skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
> > +               if (p == buffer)
> > +                       return p;
> > +               memcpy(buffer, p, len);
> > +               return buffer;
> > +       }
> >
> > --- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
> > +++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
> > @@ -470,7 +470,10 @@ int balancer_ingress(struct __sk_buff *ctx)
> >         eth = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
> >         if (!eth)
> >                 return TC_ACT_SHOT;
> > -       eth_proto = eth->eth_proto;
> > +       *(void **)buffer = ctx;
>
> Great catch.
> To fix the issue I think we should simply disallow such
> stack abuse. The compiler won't be spilling registers
> into C array on the stack.
> This manual spill/fill is exploiting verifier logic.
> After bpf_dynptr_slice_rdwr() we can mark all slots of the
> buffer as STACK_POISON or some better name and
> reject spill into such slots.
>

I agree this is simpler, but I'm not sure it will work properly. Verifier won't
know when the lifetime of the buffer ends, so if we disallow spills until its
written over it's going to be a pain for users.

Something like:

for (...) {
	char buf[64];
	bpf_dynptr_slice_rdwr(..., buf, 64);
	...
}

.. and then compiler decides to spill something where buf was located on stack
outside the for loop. The verifier can't know when buf goes out of scope to
unpoison the slots.

> > +       *(void **)eth = (void *)0xdeadbeef;
> > +       ctx = *(void **)buffer;
> > +       eth_proto = eth->eth_proto + ctx->len;
> >         if (eth_proto == bpf_htons(ETH_P_IP))
> >                 err = process_packet(&ptr, eth, nh_off, false, ctx);
> >
> > I think the proper fix is to treat it as a separate return type distinct from
> > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* specially),
> > fork verifier state whenever there is a write, so that one path verifies it as
> > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack ptr). I
> > think for the rest it's not a problem, but there are allow_ptr_leak checks
> > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be rechecked.
> > Then we ensure that program is safe in either path.
> >
> > Also we need to fix regsafe to not consider other PTR_TO_MEMs equivalent to such
> > a pointer. We could also fork verifier states on return, to verify either path
> > separately right from the point following the call instruction.
>
> This is too complex imo.

A better way to phrase this is to verify with R0 = PTR_TO_PACKET in one path,
and push_stack with R0 = buffer's reg->type + size set to len in the other path
for exploration later. In terms of verifier infra everything is there already,
it just needs to analyze both cases which fall into the regular code handling
the reg->type's. Probably then no adjustments to regsafe are needed either. It's
like exploring branch instructions.
