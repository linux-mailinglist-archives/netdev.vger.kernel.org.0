Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBC96B7AA7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCMOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjCMOm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:42:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D7B738AA;
        Mon, 13 Mar 2023 07:41:39 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id fd5so15776089edb.7;
        Mon, 13 Mar 2023 07:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678718498;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R9HmhrxN6pA3fd71iaBz79eXpJQ82z8NdDMi/vqsVdY=;
        b=p6PJWIrWprIcKB58MA0MINAq3ltlP/h8pQucsKmzuDe6qRVYLIvIXxgG1ux8X2dm5n
         A0MesG3sEnVoMjUkS4T8AnwCK6p46leh5KoITydMhrK71DFqVOo8JRZ7n1xkOyFkbkWV
         sZltepDfOCCjlZ9JbsQyMFtGvkPO5Vu7bzJxdCU+09xzh3pJsMqjxnev5NbBjNPVd1wN
         qY97Rw+T09GU/LVNXlHromJnxZI1tMJrfHBTMGQWfly7CWRjQdGvIxveKDgg2jxfeflO
         kG83L1S9zJHGgAM49jGo2xv4uR0VlXRLnQgMNVnj53bvrk7bis3orxuLAS2S4/kzUbEW
         eDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678718498;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9HmhrxN6pA3fd71iaBz79eXpJQ82z8NdDMi/vqsVdY=;
        b=VhNiCm67lwutWIgQAqSju4UrgLU3GIyu9S0Odvn61KzZkNlZ4i19gMlDovC7hlhHPS
         q2hIZBDUPg/pqNu83N6ScMVJFNKY241MLmbIvAfSXXzKlGQJ6qyLj0LugMZTbC5oYPuS
         IrmFdkS852hSayfT88ehzFwK+Q4PeL3QZpL24NSv4bYfGwZyVeSKFLFvKOj4gY0htZqQ
         OaTJIL7EiEd1YwNtz9+hY+GrFiAQZ95tbmu/46FdTRqAMqalgXdJPX4r2i2fJFhiDrHC
         hEPkNrppcIstd20bwaZBcP/JpdnOmbKwfHGhplecv5zelwMNleoV9/NHCca1pA19+Pgs
         +/Ow==
X-Gm-Message-State: AO0yUKWgx76tcPBNfLFJgNZhrOy9g2Kflg1CHdOuHPU5binRoWu4HNVt
        leIKfSKtWVvumnTxONd1F0IbbTz1u595qg==
X-Google-Smtp-Source: AK7set/pH/u0tMsj5ZDkoUu99wUMiDC85D3hnzSQR5AwmCjvG7n4K/S2EQNc2ZERgHhquI5RlAH8GA==
X-Received: by 2002:a05:6402:135a:b0:4c8:2a1d:5086 with SMTP id y26-20020a056402135a00b004c82a1d5086mr31632221edw.8.1678718497696;
        Mon, 13 Mar 2023 07:41:37 -0700 (PDT)
Received: from localhost ([2001:620:618:580:2:80b3:0:6d0])
        by smtp.gmail.com with ESMTPSA id u15-20020a50c04f000000b004fc920655basm1141493edd.54.2023.03.13.07.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 07:41:37 -0700 (PDT)
Date:   Mon, 13 Mar 2023 15:41:35 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230313144135.5xvgdfvfknb4liwh@apollo>
References: <20230306071006.73t5vtmxrsykw4zu@apollo>
 <CAADnVQJ=wzztviB73jBy3+OYxUKhAX_jTGpS8Xv45vUVTDY-ZA@mail.gmail.com>
 <20230307102233.bemr47x625ity26z@apollo>
 <CAADnVQ+xOrCSwgxGQXNM5wHfOwV+x0csHfNyDYBHgyGVXgc2Ow@mail.gmail.com>
 <20230307173529.gi2crls7fktn6uox@apollo>
 <CAEf4Bza4N6XtXERkL+41F+_UsTT=T4B3gt0igP5mVVrzr9abXw@mail.gmail.com>
 <20230310211541.schh7iyrqgbgfaay@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzYo-8ckyi-aogvW9HijNh+Z81CE__mWtmVJtCzuY+oECA@mail.gmail.com>
 <CAADnVQLBDNqqfoNOV=mPxvsMdXLJCK_g1qmHjqxo=PED_vbhuw@mail.gmail.com>
 <CAJnrk1YCbLxcKT_FY_UdO9YBOz9fTyFQFTB8P0_2swPc39egvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1YCbLxcKT_FY_UdO9YBOz9fTyFQFTB8P0_2swPc39egvg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:31:03AM CET, Joanne Koong wrote:
> On Fri, Mar 10, 2023 at 1:55 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Mar 10, 2023 at 1:30 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Mar 10, 2023 at 1:15 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Mar 07, 2023 at 04:01:28PM -0800, Andrii Nakryiko wrote:
> > > > > > > >
> > > > > > > > I agree this is simpler, but I'm not sure it will work properly. Verifier won't
> > > > > > > > know when the lifetime of the buffer ends, so if we disallow spills until its
> > > > > > > > written over it's going to be a pain for users.
> > > > > > > >
> > > > > > > > Something like:
> > > > > > > >
> > > > > > > > for (...) {
> > > > > > > >         char buf[64];
> > > > > > > >         bpf_dynptr_slice_rdwr(..., buf, 64);
> > > > > > > >         ...
> > > > > > > > }
> > > > > > > >
> > > > > > > > .. and then compiler decides to spill something where buf was located on stack
> > > > > > > > outside the for loop. The verifier can't know when buf goes out of scope to
> > > > > > > > unpoison the slots.
> > > > > > >
> > > > > > > You're saying the "verifier doesn't know when buf ...".
> > > > > > > The same applies to the compiler. It has no visibility
> > > > > > > into what bpf_dynptr_slice_rdwr is doing.
> > > > > >
> > > > > > That is true, it can't assume anything about the side effects. But I am talking
> > > > > > about the point in the program when the buffer object no longer lives. Use of
> > > > > > the escaped pointer to such an object any longer is UB. The compiler is well
> > > > > > within its rights to reuse its stack storage at that point, including for
> > > > > > spilling registers. Which is why "outside the for loop" in my earlier reply.
> > > > > >
> > > > > > > So it never spills into a declared C array
> > > > > > > as I tried to explain in the previous reply.
> > > > > > > Spill/fill slots are always invisible to C.
> > > > > > > (unless of course you do pointer arithmetic asm style)
> > > > > >
> > > > > > When the declared array's lifetime ends, it can.
> > > > > > https://godbolt.org/z/Ez7v4xfnv
> > > > > >
> > > > > > The 2nd call to bar as part of unrolled loop happens with fp-8, then it calls
> > > > > > baz, spills r0 to fp-8, and calls bar again with fp-8.
> > > >
> > > > Right. If user writes such program and does explicit store of spillable
> > > > pointer into a stack.
> > > > I was talking about compiler generated spill/fill and I still believe
> > > > that compiler will not be reusing variable's stack memory for them.
> > > >
> > > > > >
> > > > > > If such a stack slot is STACK_POISON, verifier will reject this program.
> > > >
> > > > Yes and I think it's an ok trade-off.
> > > > The user has to specifically code such program to hit this issue.
> > > > I don't think we will see this in practice.
> > > > If we do we can consider a more complex fix.
> > >
> > > I was just debugging (a completely unrelated) issue where two
> > > completely independent functions, with different local variables, were
> > > reusing the same stack slots just because of them being inlined in
> > > parent functions. So stack reuse happens all the time, unfortunately.
> > > It's not always obvious or malicious.
> >
> > Right. Stack reuse happens for variables all the time.
> > I'm still arguing that compile internal spill/fill is coming
> > from different slots.
> >
> > When clang compiles the kernel it prints:
> > ../kernel/bpf/verifier.c:18017:5: warning: stack frame size (2296)
> > exceeds limit (2048) in 'bpf_check' [-Wframe-larger-than]
> > int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
> >     ^
> > 572/2296 (24.91%) spills, 1724/2296 (75.09%) variables
> >
> > spills and variables are different areas.
> >
> > > >
> > > > > >
> > > > > > >
> > > > > > > > > > +       *(void **)eth = (void *)0xdeadbeef;
> > > > > > > > > > +       ctx = *(void **)buffer;
> > > > > > > > > > +       eth_proto = eth->eth_proto + ctx->len;
> > > > > > > > > >         if (eth_proto == bpf_htons(ETH_P_IP))
> > > > > > > > > >                 err = process_packet(&ptr, eth, nh_off, false, ctx);
> > > > > > > > > >
> > > > > > > > > > I think the proper fix is to treat it as a separate return type distinct from
> > > > > > > > > > PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* specially),
> > > > > > > > > > fork verifier state whenever there is a write, so that one path verifies it as
> > > > > > > > > > PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack ptr). I
> > > > > > > > > > think for the rest it's not a problem, but there are allow_ptr_leak checks
> > > > > > > > > > applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be rechecked.
> > > > > > > > > > Then we ensure that program is safe in either path.
> > > > > > > > > >
> > > > > > > > > > Also we need to fix regsafe to not consider other PTR_TO_MEMs equivalent to such
> > > > > > > > > > a pointer. We could also fork verifier states on return, to verify either path
> > > > > > > > > > separately right from the point following the call instruction.
> > > > > > > > >
> > > > > > > > > This is too complex imo.
> > > > > > > >
> > > > > > > > A better way to phrase this is to verify with R0 = PTR_TO_PACKET in one path,
> > > > > > > > and push_stack with R0 = buffer's reg->type + size set to len in the other path
> > > > > > > > for exploration later. In terms of verifier infra everything is there already,
> > > > > > > > it just needs to analyze both cases which fall into the regular code handling
> > > > > > > > the reg->type's. Probably then no adjustments to regsafe are needed either. It's
> > > > > > > > like exploring branch instructions.
> > > > > > >
> > > > > > > I still don't like it. There is no reason to go a complex path
> > > > > > > when much simpler suffices.
> > > > >
> > > > > This issue you are discussing is the reason we don't support
> > > > > bpf_dynptr_from_mem() taking PTR_TO_STACK (which is a pity, but we
> > > > > postponed it initially).
> > > > >
> > > > > I've been thinking about something along the lines of STACK_POISON,
> > > > > but remembering associated id/ref_obj_id. When ref is released, turn
> > > > > STACK_POISON to STACK_MISC. If it's bpf_dynptr_slice_rdrw() or
> > > > > bpf_dynptr_from_mem(), which don't have ref_obj_id, they still have ID
> > > > > associated with returned pointer, so can we somehow incorporate that?
> > > >
> > > > There is dynptr_id in PTR_TO_MEM that is used by destroy_if_dynptr_stack_slot(),
> > > > but I don't see how we can use it to help this case.
> > > > imo plain STACK_POISON that is overwriteable by STACK_MISC/STACK_ZERO
> > > > should be good enough in practice.
> > >
> > > That's basically what I'm proposing, except when this overwrite
> > > happens we have to go and invalidate all the PTR_TO_MEM references
> > > that are pointing to that stack slot. E.g., in the below case
> > > (assuming we allow LOCAL dynptr to be constructed from stack)
> > >
> > > char buf[256], *p;
> > > struct bpf_dynptr dptr;
> > >
> > > bpf_dynptr_from_mem(buf, buf+256, &dptr);
> > >
> > > p = bpf_dynptr_data(&dptr, 128, 16); /* get 16-byte slice into buf, at
> > > offset 128 */
> > >
> > > /* buf[128] through buf[128+16] are STACK_POISON */
> > >
> > > buf[128] = 123;
> > >
> > > So here is where the problem happens. Should we invalidate just p
> > > here? Or entire dptr? Haven't thought much about details, but
> > > something like that. It was getting messy when we started to think
> > > about this with Joanne.
> >
> > Let's table dynptr_from_mem for a second and solve
> > bpf_dynptr_slice_rdrw first, since I'm getting confused.
> >
> > For bpf_dynptr_slice_rdrw we can mark buffer[] in stack as
> > poisoned with dynptr_id == R0's PTR_TO_MEM dynptr_id.
> > Then as soon as first spillable reg touches that poisoned stack area
> > we can invalidate all PTR_TO_MEM's with that dynptr_id.
>
> Okay, this makes sense to me. are you already currently working or
> planning to work on a fix for this Kumar, or should i take a stab at
> it?

I'm not planning to do so, so go ahead. One more thing I noticed just now is
that we probably need to update regsafe to perform a check_ids comparison for
dynptr_id for dynptr PTR_TO_MEMs? It was not a problem back when f8064ab90d66
("bpf: Invalidate slices on destruction of dynptrs on stack") was added but
567da5d253cd ("bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP_BUFFER}")
added PTR_TO_MEM in the switch statement.
