Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB36B529F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjCJVPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjCJVPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:15:46 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A279A117593;
        Fri, 10 Mar 2023 13:15:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so6336677pjg.4;
        Fri, 10 Mar 2023 13:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678482945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1VeKBB9LXz0SxxpvEhNV6fs3PgX+6E7nHslq9r1l7fg=;
        b=LP7sgqeedf0ZHyNF/fE26R0JW/zdyxjS5VHMwTcPsxbbCsuiZ0CQ4AaN+QfxPUGHxi
         KHSKaqi9fPX3AdLLlSgry8LwjjvRuTKiO7DNeQAQxKeKrDRiWLE02JwKkGTm8vlP8WYs
         K85f+4rga7NFL9DhZnFzl00PlZ2iuuoeZtMAnE80jHTBSxxuxnQl2o9jpLm2PsIpabKW
         mm/n4/e9+O//Wuv7AD/MopXtx597ic3GPC5gObzmjdUs2zqCEPZDoOtGktBwk8cJcDO6
         bt7KrfXEhWvIrGhtd5dAeQ5nLRpfbpwPviVomI7AbodJnk+erhqYpUG2w/+Qpto8jQ2G
         y0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678482945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1VeKBB9LXz0SxxpvEhNV6fs3PgX+6E7nHslq9r1l7fg=;
        b=d1KQwvbPLnLHTBPNdrhKp85y12oCe1mTjxv6k/1Kv9S2bDBiKsqpqdH5XVJsyGbyIb
         AANs/tHUjpicSyMbK9wB9O/y+CXrZzY+B3Zkn31MPc9RyWqn9ZEQQrYQ6XaZGVT0Do0/
         nGEGiX3QtZMBJAkrgFn2eOBtczrzk4kUL9D3wPmNvQveOIsmyWsgDqcgJhPGIcgDpRQ1
         czg8c5Mc11B/GrdOEelgfGvmP2IKUF7ncRApsc8TRTawXtDa78RMpnzEDpBunU19gvrW
         0vuGArCgDA1Q5Izp8HxyjectxqNTKyJo99SxrEYyFX1kOXhQk/cNOHwgCpFGlq3esDOR
         hKfg==
X-Gm-Message-State: AO0yUKU7Tt+APHUuUcSCwiqPLkUayoTmQRgKt/h3G/djHoFmCCmWhiDr
        d2SKguDtF96jw8Z98pbr7fc=
X-Google-Smtp-Source: AK7set9iOlhaNxjEqfuE8DhjwQ3+GnX5S2KcP6txAZH845LVCCUR96QrTD+Z/r5cg8RwX9qaDkB7/w==
X-Received: by 2002:a17:902:ab8a:b0:19c:d559:8661 with SMTP id f10-20020a170902ab8a00b0019cd5598661mr21855483plr.38.1678482944976;
        Fri, 10 Mar 2023 13:15:44 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:5c0c])
        by smtp.gmail.com with ESMTPSA id kj5-20020a17090306c500b0019c2cf12d15sm410939plb.116.2023.03.10.13.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:15:44 -0800 (PST)
Date:   Fri, 10 Mar 2023 13:15:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com>
 <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo>
 <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo>
 <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > >
> > > > I agree this is simpler, but I'm not sure it will work properly. Verifier won't
> > > > know when the lifetime of the buffer ends, so if we disallow spills until its
> > > > written over it's going to be a pain for users.
> > > >
> > > > Something like:
> > > >
> > > > for (...) {
> > > >         char buf[64];
> > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > >         ...
> > > > }
> > > >
> > > > .. and then compiler decides to spill something where buf was located on stack
> > > > outside the for loop. The verifier can't know when buf goes out of scope to
> > > > unpoison the slots.
> > >
> > > You're saying the "verifier doesn't know when buf ...".
> > > The same applies to the compiler. It has no visibility
> > > into what bpf_dynptr_slice_rdwr is doing.
> >
> > That is true, it can't assume anything about the side effects. But I am talking
> > about the point in the program when the buffer object no longer lives. Use of
> > the escaped pointer to such an object any longer is UB. The compiler is well
> > within its rights to reuse its stack storage at that point, including for
> > spilling registers. Which is why "outside the for loop" in my earlier reply.
> >
> > > So it never spills into a declared C array
> > > as I tried to explain in the previous reply.
> > > Spill/fill slots are always invisible to C.
> > > (unless of course you do pointer arithmetic asm style)
> >
> > When the declared array's lifetime ends, it can.
> > https://godbolt.org/z/Ez7v4xfnv
> >
> > The 2nd call to bar as part of unrolled loop happens with fp-8, then it calls
> > baz, spills r0 to fp-8, and calls bar again with fp-8.

Right. If user writes such program and does explicit store of spillable
pointer into a stack.
I was talking about compiler generated spill/fill and I still believe
that compiler will not be reusing variable's stack memory for them.

> >
> > If such a stack slot is STACK_POISON, verifier will reject this program.

Yes and I think it's an ok trade-off.
The user has to specifically code such program to hit this issue.
I don't think we will see this in practice.
If we do we can consider a more complex fix.

> >
> > >
> > > > > > +       *(void **)eth = (void *)0xdeadbeef;
> > > > > > +       ctx = *(void **)buffer;
> > > > > > +       eth_proto = eth->eth_proto + ctx->len;
> > > > > >         if (eth_proto == bpf_htons(ETH_P_IP))
> > > > > >                 err = process_packet(&ptr, eth, nh_off, false, ctx);
> > > > > >
> > > > > > I think the proper fix is to treat it as a separate return type distinct from
> > > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* specially),
> > > > > > fork verifier state whenever there is a write, so that one path verifies it as
> > > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack ptr). I
> > > > > > think for the rest it's not a problem, but there are allow_ptr_leak checks
> > > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be rechecked.
> > > > > > Then we ensure that program is safe in either path.
> > > > > >
> > > > > > Also we need to fix regsafe to not consider other PTR_TO_MEMs equivalent to such
> > > > > > a pointer. We could also fork verifier states on return, to verify either path
> > > > > > separately right from the point following the call instruction.
> > > > >
> > > > > This is too complex imo.
> > > >
> > > > A better way to phrase this is to verify with R0 = PTR_TO_PACKET in one path,
> > > > and push_stack with R0 = buffer's reg->type + size set to len in the other path
> > > > for exploration later. In terms of verifier infra everything is there already,
> > > > it just needs to analyze both cases which fall into the regular code handling
> > > > the reg->type's. Probably then no adjustments to regsafe are needed either. It's
> > > > like exploring branch instructions.
> > >
> > > I still don't like it. There is no reason to go a complex path
> > > when much simpler suffices.
> 
> This issue you are discussing is the reason we don't support
> bpf_dynptr_from_mem() taking PTR_TO_STACK (which is a pity, but we
> postponed it initially).
> 
> I've been thinking about something along the lines of STACK_POISON,
> but remembering associated id/ref_obj_id. When ref is released, turn
> STACK_POISON to STACK_MISC. If it's bpf_dynptr_slice_rdrw() or
> bpf_dynptr_from_mem(), which don't have ref_obj_id, they still have ID
> associated with returned pointer, so can we somehow incorporate that?

There is dynptr_id in PTR_TO_MEM that is used by destroy_if_dynptr_stack_slot(),
but I don't see how we can use it to help this case.
imo plain STACK_POISON that is overwriteable by STACK_MISC/STACK_ZERO
should be good enough in practice.

We can potentially do some liveness trick. When PTR_TO_MEM with dynptr_id becomes
REG_LIVE_DONE we can convert STACK_POISON. But I'd go with the simplest approach first.
