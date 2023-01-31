Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE9B682139
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjAaBEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAaBE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:04:29 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78762FCE3;
        Mon, 30 Jan 2023 17:04:27 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id m2so36789079ejb.8;
        Mon, 30 Jan 2023 17:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+332aAEh6VfnIgLs8VdJXR9YGot1Oy0yoNcw7YHS17w=;
        b=i9r+P/qb2ACP4X1Z41umnfO6HLRQcOzAtrbNe6eu6sUeJfO32da7sw7zJmwjZG0Lvv
         8//DgsudBQDXG2UooStYD4BRUvoNPACX+dpBiTSQ46zJlqH5uzCGK3cEsfAoHKpnHr0r
         oHVL47ry9Zg2eCwmK3JPNAvIFlZ3j4ToukMCKt6FTSFZVF5Qod1R1s13a8ruhVbU31mP
         R1bZeCK/IUclGeXHAL22AjhnrWal+iqD0QdxMBDgmnDKeoRSlkkw4rfvVKdFuKyjOo4Z
         blicAAQiUmzjY/HI4QWHl+++xtI9MkTFkMrDOsswdhziK86Hr8UHJqMBRTZ0LW3FkBZf
         A2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+332aAEh6VfnIgLs8VdJXR9YGot1Oy0yoNcw7YHS17w=;
        b=Wh57Y9Gfk3NmRr204m4NScmIUIWzN487SHXROJXF4E+oG0L5Cl8FF2asGI8A2mtJGT
         WGWmmTC4mrv1I0+sdMuPWCIxyktPYdhDA69ydTcLuVPKElwl9MIYfjw14gEAUd8TWCCU
         G4llBzEDrkFm6MzvQtFPW5Z6hTUmv1b3HSXmp0WiLLsv1ld+F4eeb+YDymsywMAUQUX4
         eUKyiGzsGW+1kCCmc6ctyMFU2zTpm21L6fOvXbeB9wOFaW1fo3SUWlZoQH7hPllsarZW
         zmdiDHt1A7ySUWj+9v59QgphabOi3HLYtteaYrkJPGb1cNUsC9Y5fWld5dkb2QEoNEr5
         6Lsw==
X-Gm-Message-State: AO0yUKW2UuZFUIqjhlKX0YFmceH1HP0vPGs76yzHvgqRtyHucXCf+EZl
        AcM/ngawdnNnYotmCt0uoI1yoYVI75hJPiG8KT8=
X-Google-Smtp-Source: AK7set8uRSPCBgiMVqWIP6QR6pWYu3Je5OEFbXhnBatWwY3ZsFcH8n0HJH+qRobGnqX3XwzGSyTElWtloFQRPYOhIW8=
X-Received: by 2002:a17:907:175d:b0:885:dc8a:a7c5 with SMTP id
 lf29-20020a170907175d00b00885dc8aa7c5mr2151651ejc.180.1675127066178; Mon, 30
 Jan 2023 17:04:26 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Jan 2023 17:04:14 -0800
Message-ID: <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org
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

On Mon, Jan 30, 2023 at 2:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 02:04:08PM -0800, Martin KaFai Lau wrote:
> > On 1/27/23 11:17 AM, Joanne Koong wrote:
> > > @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> > >             mark_reg_known_zero(env, regs, BPF_REG_0);
> > >             regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > >             regs[BPF_REG_0].mem_size = meta.mem_size;
> > > +           if (func_id == BPF_FUNC_dynptr_data &&
> > > +               dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > +                   bool seen_direct_write = env->seen_direct_write;
> > > +
> > > +                   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > > +                   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > > +                           regs[BPF_REG_0].type |= MEM_RDONLY;
> > > +                   else
> > > +                           /*
> > > +                            * Calling may_access_direct_pkt_data() will set
> > > +                            * env->seen_direct_write to true if the skb is
> > > +                            * writable. As an optimization, we can ignore
> > > +                            * setting env->seen_direct_write.
> > > +                            *
> > > +                            * env->seen_direct_write is used by skb
> > > +                            * programs to determine whether the skb's page
> > > +                            * buffers should be cloned. Since data slice
> > > +                            * writes would only be to the head, we can skip
> > > +                            * this.
> > > +                            */
> > > +                           env->seen_direct_write = seen_direct_write;
> > > +           }
> >
> > [ ... ]
> >
> > > @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> > >                             return ret;
> > >                     break;
> > >             case KF_ARG_PTR_TO_DYNPTR:
> > > +           {
> > > +                   enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > > +
> > >                     if (reg->type != PTR_TO_STACK &&
> > >                         reg->type != CONST_PTR_TO_DYNPTR) {
> > >                             verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> > >                             return -EINVAL;
> > >                     }
> > > -                   ret = process_dynptr_func(env, regno, insn_idx,
> > > -                                             ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > > +                   if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > > +                           dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > > +                   else
> > > +                           dynptr_arg_type |= MEM_RDONLY;
> > > +
> > > +                   ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > > +                                             meta->func_id);
> > >                     if (ret < 0)
> > >                             return ret;
> > >                     break;
> > > +           }
> > >             case KF_ARG_PTR_TO_LIST_HEAD:
> > >                     if (reg->type != PTR_TO_MAP_VALUE &&
> > >                         reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > > @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> > >                desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> > >             insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> > >             *cnt = 1;
> > > +   } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > > +           bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> >
> > Does it need to restore the env->seen_direct_write here also?
> >
> > It seems this 'seen_direct_write' saving/restoring is needed now because
> > 'may_access_direct_pkt_data(BPF_WRITE)' is not only called when it is
> > actually writing the packet. Some refactoring can help to avoid issue like
> > this.
> >
> > While at 'seen_direct_write', Alexei has also pointed out that the verifier
> > needs to track whether the (packet) 'slice' returned by bpf_dynptr_data()
> > has been written. It should be tracked in 'seen_direct_write'. Take a look
> > at how reg_is_pkt_pointer() and may_access_direct_pkt_data() are done in
> > check_mem_access(). iirc, this reg_is_pkt_pointer() part got loss somewhere
> > in v5 (or v4?) when bpf_dynptr_data() was changed to return register typed
> > PTR_TO_MEM instead of PTR_TO_PACKET.
>
> btw tc progs are using gen_prologue() approach because data/data_end are not kfuncs
> (nothing is being called by the bpf prog).
> In this case we don't need to repeat this approach. If so we don't need to
> set seen_direct_write.
> Instead bpf_dynptr_data() can call bpf_skb_pull_data() directly.
> And technically we don't need to limit it to skb head. It can handle any off/len.
> It will work for skb, but there is no equivalent for xdp_pull_data().
> I don't think we can implement xdp_pull_data in all drivers.
> That's massive amount of work, but we need to be consistent if we want
> dynptr to wrap both skb and xdp.
> We can say dynptr_data is for head only, but we've seen bugs where people
> had to switch from data/data_end to load_bytes.
>
> Also bpf_skb_pull_data is quite heavy. For progs that only want to parse
> the packet calling that in bpf_dynptr_data is a heavy hammer.
>
> It feels that we need to go back to skb_header_pointer-like discussion.
> Something like:
> bpf_dynptr_slice(const struct bpf_dynptr *ptr, u32 offset, u32 len, void *buffer)
> Whether buffer is a part of dynptr or program provided is tbd.

making it hidden within dynptr would make this approach unreliable
(memory allocations, which can fail, etc). But if we ask users to pass
it directly, then it should be relatively easy to use in practice with
some pre-allocated per-CPU buffer:


struct {
  __int(type, BPF_MAP_TYPE_PERCPU_ARRAY);
  __int(max_entries, 1);
  __type(key, int);
  __type(value, char[4096]);
} scratch SEC(".maps");


...


struct dyn_ptr *dp = bpf_dynptr_from_skb(...).
void *p, *buf;
int zero = 0;

buf = bpf_map_lookup_elem(&scratch, &zero);
if (!buf) return 0; /* can't happen */

p = bpf_dynptr_slice(dp, off, 16, buf);
if (p == NULL) {
   /* out of range */
} else {
   /* work with p directly */
}

/* if we wrote something to p and it was copied to buffer, write it back */
if (p == buf) {
    bpf_dynptr_write(dp, buf, 16);
}


We'll just need to teach verifier to make sure that buf is at least 16
byte long.


But I wonder if for simple cases when users are mostly sure that they
are going to access only header data directly we can have an option
for bpf_dynptr_from_skb() to specify what should be the behavior for
bpf_dynptr_slice():

 - either return NULL for anything that crosses into frags (no
surprising perf penalty, but surprising NULLs);
 - do bpf_skb_pull_data() if bpf_dynptr_data() needs to point to data
beyond header (potential perf penalty, but on NULLs, if off+len is
within packet).

And then bpf_dynptr_from_skb() can accept a flag specifying this
behavior and store it somewhere in struct bpf_dynptr.

Thoughts?
