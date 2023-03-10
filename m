Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2376B5391
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjCJV60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjCJV54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:57:56 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBD3144BED;
        Fri, 10 Mar 2023 13:54:36 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l25so6330658wrb.3;
        Fri, 10 Mar 2023 13:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678485269;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3bJthLMm7PLwaAtSy4MosMc4G3RtbCJ0FiObiZwAed4=;
        b=do/v1JGhtGAvdCFl/mvRBCvITSKqLyO7PHNuN36zDAxD6DdR1w9KP7RlbqaxAbCWdj
         QncyHAOb1Ol+b5nXhqNnaXLYZUmMjc1AySwoXT83Us/D55ZtoE38S6TdLWxs342xAk9l
         mGUhquZaKrkeHuTLCf4fNsn1ibq5HeXXHVC80egyolmrGu9IVx3kPCaU07R/FH571GAd
         23S2vgupl9z1Z5qjB/hFqSJUVtn6yjDYW4X9Z2N/e5HzO1wOjF+4lOoBusa4h6/6hxlD
         qUbkZR1RGie3fACXMe1PL2b6z1nNC+Ru6kzZKIKkZ5QTXmSQdrpGIn8/SpDtb/iiUG+0
         vQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678485269;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3bJthLMm7PLwaAtSy4MosMc4G3RtbCJ0FiObiZwAed4=;
        b=P18vScSTzjZwVjhNq+ia8Ye2wDbS/qJj75e4UAhR03PzSyGejfZdDHD4I9c4GOMyjD
         pBpWINmPsZ/ti4zNdMJqomka5VxqhC+2g7mCDd983iILfU2Q5sgESMOT/MV/A7O3IKOq
         Zzzhui++WWqCzR1g6ZvplWRs7F0u/J9/6l52sTvswNMSZBLwZ+AEj/yKw6QHcLxssdEn
         AetQqEl9cCXJYEcCNYLMByNrqsUfK7ryFXCFj6WRenqkw8BTih6Y12Tvnw0fPk6LRC/w
         AODQGRB95yFT6QBLhxtPKwkK/D0skvPSRp09mxL1t3MxODWVctG6klDKX+gcGilFJAQh
         j4pQ==
X-Gm-Message-State: AO0yUKUIc33/L9u86eVovcvTcZhZ+2JhlLJeuMx1pVzgcywZ0pkOk+zM
        ou/6IBP6tu4U5Mk7ZaCIYmM=
X-Google-Smtp-Source: AK7set9TDQg4RKjtA9zDtBnDKLGLfJxjqOA7UpkJyvhxhZ7fehzcrdspljimXH0fTqXHkdClR/5ofQ==
X-Received: by 2002:a5d:4581:0:b0:2c5:4f45:90b0 with SMTP id p1-20020a5d4581000000b002c54f4590b0mr2359734wrq.3.1678485269201;
        Fri, 10 Mar 2023 13:54:29 -0800 (PST)
Received: from localhost ([2a02:1210:74a0:3200:2fc:d4f0:c121:5e8b])
        by smtp.gmail.com with ESMTPSA id k12-20020a7bc30c000000b003dc522dd25esm980190wmj.30.2023.03.10.13.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:54:28 -0800 (PST)
Date:   Fri, 10 Mar 2023 22:54:27 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <20230310215427.ncvhj2xqvjss4uj6@apollo>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com>
 <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo>
 <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo>
 <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:29:45PM CET, Andrii Nakryiko wrote:
> On Fri, Mar 10, 2023 at 1:15 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > > >
> > > > > > I agree this is simpler, but I'm not sure it will work properly. Verifier won't
> > > > > > know when the lifetime of the buffer ends, so if we disallow spills until its
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
> > > > > > .. and then compiler decides to spill something where buf was located on stack
> > > > > > outside the for loop. The verifier can't know when buf goes out of scope to
> > > > > > unpoison the slots.
> > > > >
> > > > > You're saying the "verifier doesn't know when buf ...".
> > > > > The same applies to the compiler. It has no visibility
> > > > > into what bpf_dynptr_slice_rdwr is doing.
> > > >
> > > > That is true, it can't assume anything about the side effects. But I am talking
> > > > about the point in the program when the buffer object no longer lives. Use of
> > > > the escaped pointer to such an object any longer is UB. The compiler is well
> > > > within its rights to reuse its stack storage at that point, including for
> > > > spilling registers. Which is why "outside the for loop" in my earlier reply.
> > > >
> > > > > So it never spills into a declared C array
> > > > > as I tried to explain in the previous reply.
> > > > > Spill/fill slots are always invisible to C.
> > > > > (unless of course you do pointer arithmetic asm style)
> > > >
> > > > When the declared array's lifetime ends, it can.
> > > > https://godbolt.org/z/Ez7v4xfnv
> > > >
> > > > The 2nd call to bar as part of unrolled loop happens with fp-8, then it calls
> > > > baz, spills r0 to fp-8, and calls bar again with fp-8.
> >
> > Right. If user writes such program and does explicit store of spillable
> > pointer into a stack.
> > I was talking about compiler generated spill/fill and I still believe
> > that compiler will not be reusing variable's stack memory for them.
> >
> > > >
> > > > If such a stack slot is STACK_POISON, verifier will reject this program.
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
>
> >
> > > >
> > > > >
> > > > > > > > +       *(void **)eth = (void *)0xdeadbeef;
> > > > > > > > +       ctx = *(void **)buffer;
> > > > > > > > +       eth_proto = eth->eth_proto + ctx->len;
> > > > > > > >         if (eth_proto == bpf_htons(ETH_P_IP))
> > > > > > > >                 err = process_packet(&ptr, eth, nh_off, false, ctx);
> > > > > > > >
> > > > > > > > I think the proper fix is to treat it as a separate return type distinct from
> > > > > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* specially),
> > > > > > > > fork verifier state whenever there is a write, so that one path verifies it as
> > > > > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack ptr). I
> > > > > > > > think for the rest it's not a problem, but there are allow_ptr_leak checks
> > > > > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be rechecked.
> > > > > > > > Then we ensure that program is safe in either path.
> > > > > > > >
> > > > > > > > Also we need to fix regsafe to not consider other PTR_TO_MEMs equivalent to such
> > > > > > > > a pointer. We could also fork verifier states on return, to verify either path
> > > > > > > > separately right from the point following the call instruction.
> > > > > > >
> > > > > > > This is too complex imo.
> > > > > >
> > > > > > A better way to phrase this is to verify with R0 = PTR_TO_PACKET in one path,
> > > > > > and push_stack with R0 = buffer's reg->type + size set to len in the other path
> > > > > > for exploration later. In terms of verifier infra everything is there already,
> > > > > > it just needs to analyze both cases which fall into the regular code handling
> > > > > > the reg->type's. Probably then no adjustments to regsafe are needed either. It's
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
> > > bpf_dynptr_from_mem(), which don't have ref_obj_id, they still have ID
> > > associated with returned pointer, so can we somehow incorporate that?
> >
> > There is dynptr_id in PTR_TO_MEM that is used by destroy_if_dynptr_stack_slot(),
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
> p = bpf_dynptr_data(&dptr, 128, 16); /* get 16-byte slice into buf, at
> offset 128 */
>
> /* buf[128] through buf[128+16] are STACK_POISON */
>
> buf[128] = 123;
>
> So here is where the problem happens. Should we invalidate just p
> here? Or entire dptr? Haven't thought much about details, but
> something like that. It was getting messy when we started to think
> about this with Joanne.
>

I think there's also the option (for your particular case) to conservatively
mark the entire range a dynptr pointing to stack represents as STACK_MISC
whenever a *write* happens (through bpf_dynptr_write or pointers obtained using
bpf_dynptr_data). We do know exact memory start and length when creating the
dynptr, right?

If somebody tries to be funky, e.g. by doing a spill and then trying to
overwrite its value, the entire range becomes STACK_MISC, so reload would just
mark the reg as unknown. You can be a bit smarter when you know the exact start
and length of stack memory e.g. bpf_dynptr_data pointer points to, but I'm
unsure that will be needed.

Otherwise things work as normal, users can spill stuff to the stack if they
wants, and as long as they are not writing through the dynptr again, we don't
remark the entire range STACK_MISC. If that was the last use of dynptr and it
went out of scope, things work normally. If not, the dynptr and its buffer
should still be in scope so it won't be the compiler doing something funny
spilling stuff into it, only the user.

Due to STACK_INVALID complications over-eager remarking as STACK_MISC might only
make sense for privileged programs, but otherwise I think this is ok.

Am I missing something important?
