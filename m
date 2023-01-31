Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892BE683A4A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 00:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjAaXRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 18:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjAaXRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 18:17:22 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7E6DBF3;
        Tue, 31 Jan 2023 15:17:20 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-510476ee20aso116339527b3.3;
        Tue, 31 Jan 2023 15:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1QZIWu+S3IL0uO52dkW1EAX7wvgMtkM7k3R5LyfG9ts=;
        b=BLK4ORFksXP4oyCjFzYjRzNYZsziuPfwpw3zXUPc20M+tz1DG+d2oh3VwCQDGFl8Ou
         FPBfhI+T4yfUjLUZBITfxvQF6tlj/f8G0UAuM/sZdbxfk0seV/SiHGELCYxJl/2/unQu
         GGrGB71q19rNUMVVtFzS9Kd5067EbQ/xsjy0zNnq1lgjKqNgKtBn2kX20sO3T4rTxBuv
         AaLM/biMiXdzBs+HWbtrx8+whDtraO3i8+k9cjInscWVaV0xWFuB4nhn9c65UJbuLdDn
         J2DLEZUK6nuXaUp23ZP7cFTZa6dxnTTF8SbJcdeOb2zhAq5WjAmBhUXeVjQA/0qRuJVy
         3/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1QZIWu+S3IL0uO52dkW1EAX7wvgMtkM7k3R5LyfG9ts=;
        b=b6pGIi6LrS8RRaK0G3bBkKk/wigDZ06upwaIgSmYnLsfGvdnzGNL2w9v2Mdbknj8Z0
         tjLe7c/oVefnY3yAO8DDgYRZFKAyOlrvKMePKxxyTORTNHOe+50wQru7qD8+lJ5Ekmls
         8lvBqPZOJN/xgo0biYWjVJw3EaGSX7bZ2ESDOvDevMBtpiig9xs7FKhZnDykyxKPF46q
         i3H7wZboju1M1WrvNKeV2ZL5OfDowZFGoMq3OQGnJwfAp++XDk04B3amIgcPssT0X7/e
         +4vgpFjfXCs//WVnisTk+UekouzTj4gXwbxd06qIlJFgE1lb/WoRXf4wyMc/B3P1O9FO
         ooEg==
X-Gm-Message-State: AO0yUKVEqW5qnPXSJvebBGTvOEV2izRmkaQseNEe2QMBUWxATyJ4S2uz
        FZ3e+W3XuKUlYSwxwS+7f7pcAkqMBY9dUlxokfaN7BF1FZAciQ==
X-Google-Smtp-Source: AK7set9ngzTV+T4W9WeFQDXsMl9hBEUWsFZAK9cqFFw04reu8btRvNvlUQ7kK7lCgbtdSfEo1U2su7jXNaku0qeGYg4=
X-Received: by 2002:a05:690c:941:b0:507:6399:8ea6 with SMTP id
 cc1-20020a05690c094100b0050763998ea6mr9100ywb.362.1675207039618; Tue, 31 Jan
 2023 15:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev> <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 31 Jan 2023 15:17:08 -0800
Message-ID: <CAJnrk1bF+g_2SQ8HaNx0Fb+E42HBi3XJa3M=+y71=XHN1_wdrg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, bpf@vger.kernel.org
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

 oOn Mon, Jan 30, 2023 at 9:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 08:43:47PM -0800, Andrii Nakryiko wrote:
> > On Mon, Jan 30, 2023 at 5:49 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> > >
> > > On 1/30/23 5:04 PM, Andrii Nakryiko wrote:
> > > > On Mon, Jan 30, 2023 at 2:31 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > >>
> > > >> On Mon, Jan 30, 2023 at 02:04:08PM -0800, Martin KaFai Lau wrote:
> > > >>> On 1/27/23 11:17 AM, Joanne Koong wrote:
> > > >>>> @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> > > >>>>              mark_reg_known_zero(env, regs, BPF_REG_0);
> > > >>>>              regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > > >>>>              regs[BPF_REG_0].mem_size = meta.mem_size;
> > > >>>> +           if (func_id == BPF_FUNC_dynptr_data &&
> > > >>>> +               dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > >>>> +                   bool seen_direct_write = env->seen_direct_write;
> > > >>>> +
> > > >>>> +                   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > > >>>> +                   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > > >>>> +                           regs[BPF_REG_0].type |= MEM_RDONLY;
> > > >>>> +                   else
> > > >>>> +                           /*
> > > >>>> +                            * Calling may_access_direct_pkt_data() will set
> > > >>>> +                            * env->seen_direct_write to true if the skb is
> > > >>>> +                            * writable. As an optimization, we can ignore
> > > >>>> +                            * setting env->seen_direct_write.
> > > >>>> +                            *
> > > >>>> +                            * env->seen_direct_write is used by skb
> > > >>>> +                            * programs to determine whether the skb's page
> > > >>>> +                            * buffers should be cloned. Since data slice
> > > >>>> +                            * writes would only be to the head, we can skip
> > > >>>> +                            * this.
> > > >>>> +                            */
> > > >>>> +                           env->seen_direct_write = seen_direct_write;
> > > >>>> +           }
> > > >>>
> > > >>> [ ... ]
> > > >>>
> > > >>>> @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> > > >>>>                              return ret;
> > > >>>>                      break;
> > > >>>>              case KF_ARG_PTR_TO_DYNPTR:
> > > >>>> +           {
> > > >>>> +                   enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > > >>>> +
> > > >>>>                      if (reg->type != PTR_TO_STACK &&
> > > >>>>                          reg->type != CONST_PTR_TO_DYNPTR) {
> > > >>>>                              verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> > > >>>>                              return -EINVAL;
> > > >>>>                      }
> > > >>>> -                   ret = process_dynptr_func(env, regno, insn_idx,
> > > >>>> -                                             ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > > >>>> +                   if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > > >>>> +                           dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > > >>>> +                   else
> > > >>>> +                           dynptr_arg_type |= MEM_RDONLY;
> > > >>>> +
> > > >>>> +                   ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > > >>>> +                                             meta->func_id);
> > > >>>>                      if (ret < 0)
> > > >>>>                              return ret;
> > > >>>>                      break;
> > > >>>> +           }
> > > >>>>              case KF_ARG_PTR_TO_LIST_HEAD:
> > > >>>>                      if (reg->type != PTR_TO_MAP_VALUE &&
> > > >>>>                          reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > > >>>> @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> > > >>>>                 desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> > > >>>>              insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> > > >>>>              *cnt = 1;
> > > >>>> +   } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > > >>>> +           bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> > > >>>
> > > >>> Does it need to restore the env->seen_direct_write here also?
> > > >>>
> > > >>> It seems this 'seen_direct_write' saving/restoring is needed now because
> > > >>> 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is
> > > >>> actually writing the packet. Some refactoring can help to avoid issue like
> > > >>> this.
> > > >>>
> > > >>> While at 'seen_direct_write', Alexei has also pointed out that the verifier
> > > >>> needs to track whether the (packet) 'slice' returned by bpf_dynptr_data()
> > > >>> has been written. It should be tracked in 'seen_direct_write'. Take a look
> > > >>> at how reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
> > > >>> check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere
> > > >>> in v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
> > > >>> PTR_TO_MEM instead of PTR_TO_PACKET.
> > > >>
> > > >> btw tc progs are using gen_prologue() approach because data/data_end are not kfuncs
> > > >> (nothing is being called by the bpf prog).
> > > >> In this case we don't need to repeat this approach. If so we don't need to
> > > >> set seen_direct_write.
> > > >> Instead bpf_dynptr_data() can call bpf_skb_pull_data() directly.
> > > >> And technically we don't need to limit it to skb head. It can handle any off/len.
> > > >> It will work for skb, but there is no equivalent for xdp_pull_data().
> > > >> I don't think we can implement xdp_pull_data in all drivers.
> > > >> That's massive amount of work, but we need to be consistent if we want
> > > >> dynptr to wrap both skb and xdp.
> > > >> We can say dynptr_data is for head only, but we've seen bugs where people
> > > >> had to switch from data/data_end to load_bytes.
> > > >>
> > > >> Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
> > > >> the packet calling that in bpf_dynptr_data is a heavy hammer.
> > > >>
> > > >> It feels that we need to go back to skb_header_pointer-like discussion.
> > > >> Something like:
> > > >> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
> > > >> Whether buffer is a part of dynptr or program provided is tbd.
> > > >
> > > > making it hidden within dynptr would make this approach unreliable
> > > > (memory allocations, which can fail, etc). But if we ask users to pass
> > > > it directly, then it should be relatively easy to use in practice with
> > > > some pre-allocated per-CPU buffer:
>
> bpf_skb_pull_data() is even more unreliable, since it's a bigger allocation.
> I like preallocated approach more, so we're in agreement here.
>
> > > >
> > > >
> > > > struct {
> > > >    __int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > > >    __int(max_entries, 1);
> > > >    __type(key, int);
> > > >    __type(value, char[4096]);
> > > > } scratch SEC(".maps");
> > > >
> > > >
> > > > ...
> > > >
> > > >
> > > > struct dyn_ptr *dp = bpf_dynptr_from_skb(...).
> > > > void *p, *buf;
> > > > int zero = 0;
> > > >
> > > > buf = bpf_map_lookup_elem(&scratch, &zero);
> > > > if (!buf) return 0; /* can't happen */
> > > >
> > > > p = bpf_dynptr_slice(dp, off, 16, buf);
> > > > if (p == NULL) {
> > > >     /* out of range */
> > > > } else {
> > > >     /* work with p directly */
> > > > }
> > > >
> > > > /* if we wrote something to p and it was copied to buffer, write it back */
> > > > if (p == buf) {
> > > >      bpf_dynptr_write(dp, buf, 16);
> > > > }
> > > >
> > > >
> > > > We'll just need to teach verifier to make sure that buf is at least 16
> > > > byte long.
> > >
> > > A fifth __sz arg may do:
> > > bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void
> > > *buffer, u32 buffer__sz);
> >
> > We'll need to make sure that buffer__sz is >= len (or preferably not
> > require extra size at all). We can check that at runtime, of course,
> > but rejecting too small buffer at verification time would be a better
> > experience.
>
> I don't follow. Why two equivalent 'len' args ?
> Just to allow 'len' to be a variable instead of constant ?
> It's unusual for the verifier to have 'len' before 'buffer',
> but this is fixable.
>
> How about adding 'rd_only vs rdwr' flag ?
> Then MEM_RDONLY for ret value of bpf_dynptr_slice can be set by the verifier
> and in run-time bpf_dynptr_slice() wouldn't need to check for skb->cloned.
> if (rd_only) return skb_header_pointer()
> if (rdwr) bpf_try_make_writable(); return skb->data + off;
> and final bpf_dynptr_write() is not needed.
>
> But that doesn't work for xdp, since there is no pull.
>
> It's not clear how to deal with BPF_F_RECOMPUTE_CSUM though.
> Expose __skb_postpull_rcsum/__skb_postpush_rcsum as kfuncs?
> But that defeats Andrii's goal to use dynptr as a generic wrapper.
> skb is quite special.

If it's the common case that skbs use the same flag across writes in
their bpf prog, then we can have bpf_dynptr_from_skb take in
BPF_F_RECOMPUTE_CSUM/BPF_F_INVALIDATE_HASH in its flags arg and then
always apply this when the skb does a write to packet data.

>
> Maybe something like:
> void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len,
>                        void *buffer, u32 buffer__sz)
> {
>   if (skb_cloned()) {
>     skb_copy_bits(skb, offset, buffer, len);
>     return buffer;
>   }
>   return skb_header_pointer(...);
> }
>
> When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> No need for rdonly flag, but extra copy is there in case of cloned which
> could have been avoided with extra rd_only flag.

We're able to track in the verifier whether the slice gets written to
or not, so if it does get written to in the skb case, can't we just
add in a call to bpf_try_make_writable() as a post-processing fixup
that gets called before bpf_dynptr_slice? Then bpf_dynptr_slice() can
just return a directly writable ptr and avoid the extra memcpy

>
> In case of xdp it will be:
> void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len,
>                        void *buffer, u32 buffer__sz)
> {
>    ptr = bpf_xdp_pointer(xdp, offset, len);
>    if (ptr)
>       return ptr;
>    bpf_xdp_copy_buf(xdp, offset, buffer, len, false); /* copy into buf */
>    return buffer;
> }
>
> bpf_dynptr_write will use bpf_xdp_copy_buf(,true); /* copy into xdp */
>
> > >
> > > The bpf prog usually has buffer in the stack for the common small header parsing.
> >
> > sure, that would work for small chunks
> >
> > >
> > > One side note is the bpf_dynptr_slice() still needs to check if the skb is
> > > cloned or not even the off/len is within the head range.
[...]
