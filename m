Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1CB6837DB
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjAaUsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjAaUsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:48:21 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67534AA4D;
        Tue, 31 Jan 2023 12:48:04 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id t16so19763701ybk.2;
        Tue, 31 Jan 2023 12:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O1tI1IyFJLPjJm9oh+/cE58Tw8i+0Wo3qGdQ5tLaELw=;
        b=XruJeBFtDW4aZFmJ0nwXOwgnN3CB3wzaUDKIXxsyu26rSbAI5tVs15MGjEE6cXq+fj
         8UXnFaH+fpTWtS57XkKGV9B2D/UpcZt12Ae6JTzAtlqAcjwW7/85nFg73QjEAPCAY/WF
         XN0JHtdBWKCIdXWohEfzInrcr7rREyQ/TVW8tyecpZEvhz1+Vj8OqbDctMZdUK3gTQeU
         Rb1Dcn4mTLTr53wgtkR9IfXl3W437rG7wLv+pacuWNjwkW8IyQ5DfQU1MHtB0wwOyQlv
         m7fn2rF72IhjIbpbApj/LsAtENXVK+cttz1y9k5kZriGpXgn0RhsxcawL8w7Rr0WAbAJ
         TCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O1tI1IyFJLPjJm9oh+/cE58Tw8i+0Wo3qGdQ5tLaELw=;
        b=r/nnPwYwY21wRNlC3HtmLlOQz7VtxHyOm99x6PMZJNNg0PVnMC+j7x/Lo1QFUFlZkH
         GI9dRBDU8SfrzRT7SQR2A+WI2KW9pfqD+w6QtErISmguFIYgdjygqRKAmY1sNygqTXEe
         Y9IpjeoVSL/BLG2dLXJgFpesGd3VOZBzQbaaAnSAtSNzSS9C9aBzaeOPJQUtklH3emaE
         pAlNu00qxN4DL2gv4vRz2Hxs4C0w8V1RZH6YeAC0zKpGJdnCX37t3j4hqqEd+PVBtpqV
         4qt3QZ0VzUw4s/aW/ChbQ6BD6jXSTiKnDs1R+Cf94Gfnwqj1TSnHEvwqHvv+uIW4XBaY
         NAWg==
X-Gm-Message-State: AO0yUKWcK5XfK4832fikF8EB5hBpz5h2F0qCYT+tKG/kujZ2HerKt7He
        fQj5imqwA0a84AckZ0et+1Rf1KvPiOcJPTPzBek=
X-Google-Smtp-Source: AK7set8By392iu8l3CB2RALPSoGV29DYhcYo5+oYBv+7e4PYzcR4Z28VXi0SwTFblHPW6nv9WmV/NqCKn5iI9k+oV9Q=
X-Received: by 2002:a25:6850:0:b0:802:b7a:4069 with SMTP id
 d77-20020a256850000000b008020b7a4069mr36307ybc.433.1675198083834; Tue, 31 Jan
 2023 12:48:03 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <CAJnrk1Y9jf7PQ0sHF+hfW0TD+W8r3WzJCu-pJjT3zsZCGt343w@mail.gmail.com> <CAADnVQJ9Pb10boAR=ZVaXOJwjHPkFXKn9n9RWrzXgK3GaQ1N0g@mail.gmail.com>
In-Reply-To: <CAADnVQJ9Pb10boAR=ZVaXOJwjHPkFXKn9n9RWrzXgK3GaQ1N0g@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 31 Jan 2023 12:47:52 -0800
Message-ID: <CAJnrk1a2SY5NqhibczOhd+jqL3W9U1rbTeiQpYw-oUS8_Cr1_g@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
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

On Tue, Jan 31, 2023 at 11:59 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 31, 2023 at 10:30 AM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 5:04 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jan 30, 2023 at 2:31 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Jan 30, 2023 at 02:04:08PM -0800, Martin KaFai Lau wrote:
> > > > > On 1/27/23 11:17 AM, Joanne Koong wrote:
> > > > > > @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> > > > > >             mark_reg_known_zero(env, regs, BPF_REG_0);
> > > > > >             regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > > > > >             regs[BPF_REG_0].mem_size = meta.mem_size;
> > > > > > +           if (func_id == BPF_FUNC_dynptr_data &&
> > > > > > +               dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > > > > +                   bool seen_direct_write = env->seen_direct_write;
> > > > > > +
> > > > > > +                   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > > > > > +                   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > > > > > +                           regs[BPF_REG_0].type |= MEM_RDONLY;
> > > > > > +                   else
> > > > > > +                           /*
> > > > > > +                            * Calling may_access_direct_pkt_data() will set
> > > > > > +                            * env->seen_direct_write to true if the skb is
> > > > > > +                            * writable. As an optimization, we can ignore
> > > > > > +                            * setting env->seen_direct_write.
> > > > > > +                            *
> > > > > > +                            * env->seen_direct_write is used by skb
> > > > > > +                            * programs to determine whether the skb's page
> > > > > > +                            * buffers should be cloned. Since data slice
> > > > > > +                            * writes would only be to the head, we can skip
> > > > > > +                            * this.
> > > > > > +                            */
> > > > > > +                           env->seen_direct_write = seen_direct_write;
> > > > > > +           }
> > > > >
> > > > > [ ... ]
> > > > >
> > > > > > @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> > > > > >                             return ret;
> > > > > >                     break;
> > > > > >             case KF_ARG_PTR_TO_DYNPTR:
> > > > > > +           {
> > > > > > +                   enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > > > > > +
> > > > > >                     if (reg->type != PTR_TO_STACK &&
> > > > > >                         reg->type != CONST_PTR_TO_DYNPTR) {
> > > > > >                             verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> > > > > >                             return -EINVAL;
> > > > > >                     }
> > > > > > -                   ret = process_dynptr_func(env, regno, insn_idx,
> > > > > > -                                             ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > > > > > +                   if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > > > > > +                           dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > > > > > +                   else
> > > > > > +                           dynptr_arg_type |= MEM_RDONLY;
> > > > > > +
> > > > > > +                   ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > > > > > +                                             meta->func_id);
> > > > > >                     if (ret < 0)
> > > > > >                             return ret;
> > > > > >                     break;
> > > > > > +           }
> > > > > >             case KF_ARG_PTR_TO_LIST_HEAD:
> > > > > >                     if (reg->type != PTR_TO_MAP_VALUE &&
> > > > > >                         reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > > > > > @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> > > > > >                desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> > > > > >             insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> > > > > >             *cnt = 1;
> > > > > > +   } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > > > > > +           bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> > > > >
> > > > > Does it need to restore the env->seen_direct_write here also?
> > > > >
> > > > > It seems this 'seen_direct_write' saving/restoring is needed now because
> > > > > 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is
> > > > > actually writing the packet. Some refactoring can help to avoid issue like
> > > > > this.
> > > > >
> > > > > While at 'seen_direct_write', Alexei has also pointed out that the verifier
> > > > > needs to track whether the (packet) 'slice' returned by bpf_dynptr_data()
> > > > > has been written. It should be tracked in 'seen_direct_write'. Take a look
> > > > > at how reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
> > > > > check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere
> > > > > in v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
> > > > > PTR_TO_MEM instead of PTR_TO_PACKET.
> > > >
> > > > btw tc progs are using gen_prologue() approach because data/data_end are not kfuncs
> > > > (nothing is being called by the bpf prog).
> > > > In this case we don't need to repeat this approach. If so we don't need to
> > > > set seen_direct_write.
> > > > Instead bpf_dynptr_data() can call bpf_skb_pull_data() directly.
> > > > And technically we don't need to limit it to skb head. It can handle any off/len.
> > > > It will work for skb, but there is no equivalent for xdp_pull_data().
> > > > I don't think we can implement xdp_pull_data in all drivers.
> > > > That's massive amount of work, but we need to be consistent if we want
> > > > dynptr to wrap both skb and xdp.
> > > > We can say dynptr_data is for head only, but we've seen bugs where people
> > > > had to switch from data/data_end to load_bytes.
> > > >
> > > > Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
> > > > the packet calling that in bpf_dynptr_data is a heavy hammer.
> > > >
> > > > It feels that we need to go back to skb_header_pointer-like discussion.
> > > > Something like:
> > > > bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
> > > > Whether buffer is a part of dynptr or program provided is tbd.
> > >
> > > making it hidden within dynptr would make this approach unreliable
> > > (memory allocations, which can fail, etc). But if we ask users to pass
> > > it directly, then it should be relatively easy to use in practice with
> > > some pre-allocated per-CPU buffer:
> > >
> > >
> > > struct {
> > >   __int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > >   __int(max_entries, 1);
> > >   __type(key, int);
> > >   __type(value, char[4096]);
> > > } scratch SEC(".maps");
> > >
> > >
> > > ...
> > >
> > >
> > > struct dyn_ptr *dp = bpf_dynptr_from_skb(...).
> > > void *p, *buf;
> > > int zero = 0;
> > >
> > > buf = bpf_map_lookup_elem(&scratch, &zero);
> > > if (!buf) return 0; /* can't happen */
> > >
> > > p = bpf_dynptr_slice(dp, off, 16, buf);
> > > if (p == NULL) {
> > >    /* out of range */
> > > } else {
> > >    /* work with p directly */
> > > }
> > >
> > > /* if we wrote something to p and it was copied to buffer, write it back */
> > > if (p == buf) {
> > >     bpf_dynptr_write(dp, buf, 16);
> > > }
> > >
> > >
> > > We'll just need to teach verifier to make sure that buf is at least 16
> > > byte long.
> >
> > I'm confused what the benefit of passing in the buffer is. If it's to
> > avoid the uncloning, this will still need to happen if the user writes
> > back the data to the skb (which will be the majority of cases). If
> > it's to avoid uncloning if the user only reads the data of a writable
> > prog, then we could add logic in the verifier so that we don't pull
> > the data in this case; the uncloning might still happen regardless if
> > another part of the program does a direct write. If the benefit is to
> > avoid needing to pull the data, then can't the user just use
> > bpf_dynptr_read, which takes in a buffer?
>
> There is no unclone and there is no pull in xdp.
> The main idea of this semantics of bpf_dynptr_slice is to make it
> work the same way on skb and xdp for _read_ case.
> Writes are going to be different between skb and xdp anyway.
> In some rare cases the writes can be the same for skb and xdp
> with this bpf_dynptr_slice + bpf_dynptr_write logic,
> but that's a minor feature addition of the api.

bpf_dynptr_read works the same way on skb and xdp. bpf_dynptr_read
takes in a buffer as well, so what is the added benefit of
bpf_dynptr_slice?

>
> I'd say in skb cases the progs do reads and either drop
> or forward the skb.
> Writes to skb are done from time to time too, because
> they're a pain to do correctly.
> nat is the main use case for skb rewrites.
> In xdp cases the progs do parse, drop, rewrite, xmit more or less equally.
