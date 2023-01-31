Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5216D68237B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjAaEoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjAaEoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:44:03 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A88A76;
        Mon, 30 Jan 2023 20:44:01 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mc11so15685036ejb.10;
        Mon, 30 Jan 2023 20:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hDhEO9nXYlzavDvaS5B48Z4s/QeP4lqi/g8+HXmfGyI=;
        b=FnuPTOW7OKHzV0KacKT2dlVAXkA04FSQN/CpIIzFdzw/GpT+xzWYjSAkKd2NsEbcyq
         6/n+p3QmnTgOUygGehbYv/YBjvqYwJMJlvUwB7qKgWL1gzs2zv4cx0vLCZvlqR3scFbx
         EbnD8FyyJ9t3czPKsDjuLNfGe8pUdtcn7SG57mAwqXIuv+XcyNvRJDcbnTeVBh8ttHX+
         LPs2G4XONtLCzVdYaIw6yjtgYDGv3rKnOv4jr9M/UlDK9nhODurZhBukeLIGiFHraSRR
         4XKZP58qZcq9WKM84f3A4tn8bkK/wn5pijeRjevKoKRvkpnnzmaRb/zHCUgISqhVY7rr
         pHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDhEO9nXYlzavDvaS5B48Z4s/QeP4lqi/g8+HXmfGyI=;
        b=thYUJQfoqD2KNZtZO0ZvykC9/OshtDzQ3hz0PL7RSq5Mea6S54hPutDbL5CY3FBpXJ
         wQIHtMW8+ZUuIAkE/z47gyrjPBEsOzG6XbN2bLWyCKRQLaA9ztkVhqkRLbOjjpyAT+As
         cNzAmy3x0mnFimK4Mq3/MeOs4eZQ46hFzGm8LZW1EvmNFYmG2uyvnIwQqY5XPyXwztjB
         fgGMJr6Fq9QXuB7EdSJiNXlNetde/kAKBukibP3jrGY8P72PZfsvVsVgUzqQJjCe4O7B
         /nAYh77Fcg1g475RQlPSHQo/51a31v9jDe94z5hFOIsnphJ8Du+TvqHC2yVqrLhJWtPd
         2xog==
X-Gm-Message-State: AO0yUKWtSJoxZAmxx8x1SdHPAmUWvXqF0E+GZClEoo1dWLF8H2y47EA0
        o3x/vu7r5vDPOFSgRFshkg77XsXCNfE1iXTdgV8C1Chp
X-Google-Smtp-Source: AK7set/9kFWyA0T/+/5inDvbBmwgnctLRa0H884zjgy2KvkWUGOKf+0caxASQDKLNnYG+ZB7Ov1Frd6mocsDkwGWB5I=
X-Received: by 2002:a17:906:46d3:b0:888:1f21:4424 with SMTP id
 k19-20020a17090646d300b008881f214424mr1988244ejs.141.1675140239608; Mon, 30
 Jan 2023 20:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com> <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev>
In-Reply-To: <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Jan 2023 20:43:47 -0800
Message-ID: <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 5:49 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 1/30/23 5:04 PM, Andrii Nakryiko wrote:
> > On Mon, Jan 30, 2023 at 2:31 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Mon, Jan 30, 2023 at 02:04:08PM -0800, Martin KaFai Lau wrote:
> >>> On 1/27/23 11:17 AM, Joanne Koong wrote:
> >>>> @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >>>>              mark_reg_known_zero(env, regs, BPF_REG_0);
> >>>>              regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> >>>>              regs[BPF_REG_0].mem_size = meta.mem_size;
> >>>> +           if (func_id == BPF_FUNC_dynptr_data &&
> >>>> +               dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> >>>> +                   bool seen_direct_write = env->seen_direct_write;
> >>>> +
> >>>> +                   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> >>>> +                   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> >>>> +                           regs[BPF_REG_0].type |= MEM_RDONLY;
> >>>> +                   else
> >>>> +                           /*
> >>>> +                            * Calling may_access_direct_pkt_data() will set
> >>>> +                            * env->seen_direct_write to true if the skb is
> >>>> +                            * writable. As an optimization, we can ignore
> >>>> +                            * setting env->seen_direct_write.
> >>>> +                            *
> >>>> +                            * env->seen_direct_write is used by skb
> >>>> +                            * programs to determine whether the skb's page
> >>>> +                            * buffers should be cloned. Since data slice
> >>>> +                            * writes would only be to the head, we can skip
> >>>> +                            * this.
> >>>> +                            */
> >>>> +                           env->seen_direct_write = seen_direct_write;
> >>>> +           }
> >>>
> >>> [ ... ]
> >>>
> >>>> @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> >>>>                              return ret;
> >>>>                      break;
> >>>>              case KF_ARG_PTR_TO_DYNPTR:
> >>>> +           {
> >>>> +                   enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> >>>> +
> >>>>                      if (reg->type != PTR_TO_STACK &&
> >>>>                          reg->type != CONST_PTR_TO_DYNPTR) {
> >>>>                              verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> >>>>                              return -EINVAL;
> >>>>                      }
> >>>> -                   ret = process_dynptr_func(env, regno, insn_idx,
> >>>> -                                             ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> >>>> +                   if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> >>>> +                           dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> >>>> +                   else
> >>>> +                           dynptr_arg_type |= MEM_RDONLY;
> >>>> +
> >>>> +                   ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> >>>> +                                             meta->func_id);
> >>>>                      if (ret < 0)
> >>>>                              return ret;
> >>>>                      break;
> >>>> +           }
> >>>>              case KF_ARG_PTR_TO_LIST_HEAD:
> >>>>                      if (reg->type != PTR_TO_MAP_VALUE &&
> >>>>                          reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> >>>> @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >>>>                 desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> >>>>              insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> >>>>              *cnt = 1;
> >>>> +   } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> >>>> +           bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> >>>
> >>> Does it need to restore the env->seen_direct_write here also?
> >>>
> >>> It seems this 'seen_direct_write' saving/restoring is needed now because
> >>> 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is
> >>> actually writing the packet. Some refactoring can help to avoid issue like
> >>> this.
> >>>
> >>> While at 'seen_direct_write', Alexei has also pointed out that the verifier
> >>> needs to track whether the (packet) 'slice' returned by bpf_dynptr_data()
> >>> has been written. It should be tracked in 'seen_direct_write'. Take a look
> >>> at how reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
> >>> check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere
> >>> in v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
> >>> PTR_TO_MEM instead of PTR_TO_PACKET.
> >>
> >> btw tc progs are using gen_prologue() approach because data/data_end are not kfuncs
> >> (nothing is being called by the bpf prog).
> >> In this case we don't need to repeat this approach. If so we don't need to
> >> set seen_direct_write.
> >> Instead bpf_dynptr_data() can call bpf_skb_pull_data() directly.
> >> And technically we don't need to limit it to skb head. It can handle any off/len.
> >> It will work for skb, but there is no equivalent for xdp_pull_data().
> >> I don't think we can implement xdp_pull_data in all drivers.
> >> That's massive amount of work, but we need to be consistent if we want
> >> dynptr to wrap both skb and xdp.
> >> We can say dynptr_data is for head only, but we've seen bugs where people
> >> had to switch from data/data_end to load_bytes.
> >>
> >> Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
> >> the packet calling that in bpf_dynptr_data is a heavy hammer.
> >>
> >> It feels that we need to go back to skb_header_pointer-like discussion.
> >> Something like:
> >> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
> >> Whether buffer is a part of dynptr or program provided is tbd.
> >
> > making it hidden within dynptr would make this approach unreliable
> > (memory allocations, which can fail, etc). But if we ask users to pass
> > it directly, then it should be relatively easy to use in practice with
> > some pre-allocated per-CPU buffer:
> >
> >
> > struct {
> >    __int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> >    __int(max_entries, 1);
> >    __type(key, int);
> >    __type(value, char[4096]);
> > } scratch SEC(".maps");
> >
> >
> > ...
> >
> >
> > struct dyn_ptr *dp = bpf_dynptr_from_skb(...).
> > void *p, *buf;
> > int zero = 0;
> >
> > buf = bpf_map_lookup_elem(&scratch, &zero);
> > if (!buf) return 0; /* can't happen */
> >
> > p = bpf_dynptr_slice(dp, off, 16, buf);
> > if (p == NULL) {
> >     /* out of range */
> > } else {
> >     /* work with p directly */
> > }
> >
> > /* if we wrote something to p and it was copied to buffer, write it back */
> > if (p == buf) {
> >      bpf_dynptr_write(dp, buf, 16);
> > }
> >
> >
> > We'll just need to teach verifier to make sure that buf is at least 16
> > byte long.
>
> A fifth __sz arg may do:
> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void
> *buffer, u32 buffer__sz);

We'll need to make sure that buffer__sz is >= len (or preferably not
require extra size at all). We can check that at runtime, of course,
but rejecting too small buffer at verification time would be a better
experience.

>
> The bpf prog usually has buffer in the stack for the common small header parsing.

sure, that would work for small chunks

>
> One side note is the bpf_dynptr_slice() still needs to check if the skb is
> cloned or not even the off/len is within the head range.

yep, and the above snippet will still do the right thing with
bpf_dynptr_write(), right? bpf_dynptr_write() will have to pull
anyways, if I understand correctly?

>
> > But I wonder if for simple cases when users are mostly sure that they
> > are going to access only header data directly we can have an option
> > for bpf_dynptr_from_skb() to specify what should be the behavior for
> > bpf_dynptr_slice():
> >
> >   - either return NULL for anything that crosses into frags (no
> > surprising perf penalty, but surprising NULLs);
> >   - do bpf_skb_pull_data() if bpf_dynptr_data() needs to point to data
> > beyond header (potential perf penalty, but on NULLs, if off+len is
> > within packet).
> >
> > And then bpf_dynptr_from_skb() can accept a flag specifying this
> > behavior and store it somewhere in struct bpf_dynptr.
>
> xdp does not have the bpf_skb_pull_data() equivalent, so xdp prog will still
> need the write back handling.
>

Sure, unfortunately, can't have everything. I'm just thinking how to
make bpf_dynptr_data() generically usable. Think about some common BPF
routine that calculates hash for all bytes pointed to by dynptr,
regardless of underlying dynptr type; it can iterate in small chunks,
get memory slice, if possible, but fallback to generic
bpf_dynptr_read() if doesn't. This will work for skb, xdp, LOCAL,
RINGBUF, any other dynptr type.
