Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7FC682415
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjAaFgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAaFgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:36:11 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802E23C05;
        Mon, 30 Jan 2023 21:36:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g9so7404474pfk.13;
        Mon, 30 Jan 2023 21:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RTGwsFNaAB17iZZpmtBmv1cFUZdLw6nGtLAzTAY4jEk=;
        b=XgXgjLkexfswJBINO5ySj+qasplIFcKElJsKZRrsr6Rd7wXby2VsaQjE81XLX7gvZQ
         U7a+wZeaOH/DoeBkAJ1yhYezdMHm+gGslt4olFrg+UPH2XvCnkNvR9+TDeDV8SCdxu2p
         SPPskS+5PC9/QDd5yC7cV7mQJKqvhxg5OBoyeNxQb/Kol3VFmWSepUfKWU8ERrmvYN8h
         6/Z5Pur8+04Gh5vPvNUlza7A9GQPZPYPe4E6R9PafGfMLQBTQDk1XHezy5D9jk1WUxKK
         vw+d+4KWB1aWyrsEKR9uLIsEYR88O8jf9RxkXpfwaHlI33xWuuqvZluOhRqEARn9BE1w
         0UpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTGwsFNaAB17iZZpmtBmv1cFUZdLw6nGtLAzTAY4jEk=;
        b=E/WiaIS2pKQJVoHcdKnUXQ19BoepPkasmGWdzKqTwhmHEKZ7jql1jftbUhXc3uDjbk
         amQ1LbmJCDoGbTZNzCZxV1CfWzDZ1hTMah+3VtfSoV1YFIUmpeoRJKQf7LyG79XNaE9t
         wKpPfx9/Z2VTdqk8aSjHb0+inyWTsVlGu8akzeermfcdmpkLntsS8DNhY5d7X+Lxxp4B
         u9sJILZXZWlQkbj8/xHQmyLXGj6SfCxgv2/hN5+K4Q5L4g6GvqcQEO4TL9pq+FInRUxS
         wMD6q11WTlPFmWOVkn333EPs0DMmcjSWC/0rEbzPcOcWQKtg2HoHs9OIUZN7ny1CyfLO
         VEvA==
X-Gm-Message-State: AO0yUKWD8FC5SKRXCsg85QgfEW0csz+MsjF0B3cYTtRkAHsbkfi93I+k
        ugGBFDQR5iFo6Chv0XyjzsKRn3hDNo8=
X-Google-Smtp-Source: AK7set/hQnEMwVEBXboO86PRdDn7MkuLwenMY2ERX3xfY+ajff49K7L8PXxjLVSIsofR+AJnOwxbEw==
X-Received: by 2002:a05:6a00:d5d:b0:593:6a1f:3618 with SMTP id n29-20020a056a000d5d00b005936a1f3618mr11035562pfv.34.1675143368778;
        Mon, 30 Jan 2023 21:36:08 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:a52d])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7870f000000b0058119caa82csm8350473pfo.205.2023.01.30.21.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 21:36:08 -0800 (PST)
Date:   Mon, 30 Jan 2023 21:36:05 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com>
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com>
 <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
 <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 04:44:12PM -0800, Joanne Koong wrote:
> On Sun, Jan 29, 2023 at 3:39 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
> > > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > > benefits. One is that they allow operations on sizes that are not
> > > statically known at compile-time (eg variable-sized accesses).
> > > Another is that parsing the packet data through dynptrs (instead of
> > > through direct access of skb->data and skb->data_end) can be more
> > > ergonomic and less brittle (eg does not need manual if checking for
> > > being within bounds of data_end).
> > >
> > > For bpf prog types that don't support writes on skb data, the dynptr is
> > > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > > will return a data slice that is read-only where any writes to it will
> > > be rejected by the verifier).
> > >
> > > For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> > > interfaces, reading and writing from/to data in the head as well as from/to
> > > non-linear paged buffers is supported. For data slices (through the
> > > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > > must first call bpf_skb_pull_data() to pull the data into the linear
> > > portion.
> >
> > Looks like there is an assumption in parts of this patch that
> > linear part of skb is always writeable. That's not the case.
> > See if (ops->gen_prologue || env->seen_direct_write) in convert_ctx_accesses().
> > For TC progs it calls bpf_unclone_prologue() which adds hidden
> > bpf_skb_pull_data() in the beginning of the prog to make it writeable.
> 
> I think we can make this assumption? For writable progs (referenced in
> the may_access_direct_pkt_data() function), all of them have a
> gen_prologue that unclones the buffer (eg tc_cls_act, lwt_xmit, sk_skb
> progs) or their linear portion is okay to write into by default (eg
> xdp, sk_msg, cg_sockopt progs).

but the patch was preserving seen_direct_write in some cases.
I'm still confused.

> >
> > > Any bpf_dynptr_write() automatically invalidates any prior data slices
> > > to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> > > to data in a paged buffer, so it will need to pull the buffer first into
> > > the head. The reason it needs to be pulled instead of writing directly to
> > > the paged buffers is because they may be cloned (only the head of the skb
> > > is by default uncloned). As such, any bpf_dynptr_write() will
> > > automatically have its prior data slices invalidated, even if the write
> > > is to data in the skb head (the verifier has no way of differentiating
> > > whether the write is to the head or paged buffers during program load
> > > time).
> >
> > Could you explain the workflow how bpf_dynptr_write() invalidates other
> > pkt pointers ?
> > I expected bpf_dynptr_write() to be in bpf_helper_changes_pkt_data().
> > Looks like bpf_dynptr_write() calls bpf_skb_store_bytes() underneath,
> > but that doesn't help the verifier.
> 
> In the verifier in check_helper_call(), for the BPF_FUNC_dynptr_write
> case (line 8236) the "changes_data" variable gets set to true if the
> dynptr is an skb type. At the end of check_helper_call() on line 8474,
> since "changes_data" is true, clear_all_pkt_pointer() gets called,
> which invalidates the other packet pointers.

Ahh. I see. Thanks for explaining.

> >
> > > Please note as well that any other helper calls that change the
> > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > > slices of the skb dynptr as well. The stack trace for this is
> > > check_helper_call() -> clear_all_pkt_pointers() ->
> > > __clear_all_pkt_pointers() -> mark_reg_unknown().
> >
> > __clear_all_pkt_pointers isn't present in the tree. Typo ?
> 
> I'll update this message, clear_all_pkt_pointers() and
> __clear_all_pkt_pointers() were combined in a previous commit.
> 
> >
> > >
> > > For examples of how skb dynptrs can be used, please see the attached
> > > selftests.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  include/linux/bpf.h            |  82 +++++++++------
> > >  include/linux/filter.h         |  18 ++++
> > >  include/uapi/linux/bpf.h       |  37 +++++--
> > >  kernel/bpf/btf.c               |  18 ++++
> > >  kernel/bpf/helpers.c           |  95 ++++++++++++++---
> > >  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
> > >  net/core/filter.c              |  60 ++++++++++-
> > >  tools/include/uapi/linux/bpf.h |  37 +++++--
> > >  8 files changed, 432 insertions(+), 100 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 14a0264fac57..1ac061b64582 100644
> [...]
> > > @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> > >               mark_reg_known_zero(env, regs, BPF_REG_0);
> > >               regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > >               regs[BPF_REG_0].mem_size = meta.mem_size;
> > > +             if (func_id == BPF_FUNC_dynptr_data &&
> > > +                 dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > +                     bool seen_direct_write = env->seen_direct_write;
> > > +
> > > +                     regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > > +                     if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > > +                             regs[BPF_REG_0].type |= MEM_RDONLY;
> > > +                     else
> > > +                             /*
> > > +                              * Calling may_access_direct_pkt_data() will set
> > > +                              * env->seen_direct_write to true if the skb is
> > > +                              * writable. As an optimization, we can ignore
> > > +                              * setting env->seen_direct_write.
> > > +                              *
> > > +                              * env->seen_direct_write is used by skb
> > > +                              * programs to determine whether the skb's page
> > > +                              * buffers should be cloned. Since data slice
> > > +                              * writes would only be to the head, we can skip
> > > +                              * this.

I was talking about above comment. It reads as 'write to the head are allowed'.
But they're not. seen_direct_write is needed to do hidden pull.

> > > +                              */
> > > +                             env->seen_direct_write = seen_direct_write;
> >
> > This looks incorrect. skb head might not be writeable.
> >
> > > +             }
> > >               break;
> > >       case RET_PTR_TO_MEM_OR_BTF_ID:
> > >       {
> > > @@ -8649,6 +8744,7 @@ enum special_kfunc_type {
> > >       KF_bpf_list_pop_back,
> > >       KF_bpf_cast_to_kern_ctx,
> > >       KF_bpf_rdonly_cast,
> > > +     KF_bpf_dynptr_from_skb,
> > >       KF_bpf_rcu_read_lock,
> > >       KF_bpf_rcu_read_unlock,
> > >  };
> > > @@ -8662,6 +8758,7 @@ BTF_ID(func, bpf_list_pop_front)
> > >  BTF_ID(func, bpf_list_pop_back)
> > >  BTF_ID(func, bpf_cast_to_kern_ctx)
> > >  BTF_ID(func, bpf_rdonly_cast)
> > > +BTF_ID(func, bpf_dynptr_from_skb)
> > >  BTF_SET_END(special_kfunc_set)
> > >
> > >  BTF_ID_LIST(special_kfunc_list)
> > > @@ -8673,6 +8770,7 @@ BTF_ID(func, bpf_list_pop_front)
> > >  BTF_ID(func, bpf_list_pop_back)
> > >  BTF_ID(func, bpf_cast_to_kern_ctx)
> > >  BTF_ID(func, bpf_rdonly_cast)
> > > +BTF_ID(func, bpf_dynptr_from_skb)
> > >  BTF_ID(func, bpf_rcu_read_lock)
> > >  BTF_ID(func, bpf_rcu_read_unlock)
> > >
> > > @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> > >                               return ret;
> > >                       break;
> > >               case KF_ARG_PTR_TO_DYNPTR:
> > > +             {
> > > +                     enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > > +
> > >                       if (reg->type != PTR_TO_STACK &&
> > >                           reg->type != CONST_PTR_TO_DYNPTR) {
> > >                               verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> > >                               return -EINVAL;
> > >                       }
> > >
> > > -                     ret = process_dynptr_func(env, regno, insn_idx,
> > > -                                               ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > > +                     if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > > +                             dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > > +                     else
> > > +                             dynptr_arg_type |= MEM_RDONLY;
> > > +
> > > +                     ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > > +                                               meta->func_id);
> > >                       if (ret < 0)
> > >                               return ret;
> > >                       break;
> > > +             }
> > >               case KF_ARG_PTR_TO_LIST_HEAD:
> > >                       if (reg->type != PTR_TO_MAP_VALUE &&
> > >                           reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > > @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> > >                  desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> > >               insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> > >               *cnt = 1;
> > > +     } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > > +             bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> > > +             struct bpf_insn addr[2] = { BPF_LD_IMM64(BPF_REG_4, is_rdonly) };
> >
> > Why use 16-byte insn to pass boolean in R4 ?
> > Single 8-byte MOV would do.
> 
> Great, I'll change it to a 8-byte MOV
> 
> >
> > > +
> > > +             insn_buf[0] = addr[0];
> > > +             insn_buf[1] = addr[1];
> > > +             insn_buf[2] = *insn;
> > > +             *cnt = 3;
> > >       }
> > >       return 0;
> > >  }
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 6da78b3d381e..ddb47126071a 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -1684,8 +1684,8 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
> > >               skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
> > >  }
> > >
> > > -BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
> > > -        const void *, from, u32, len, u64, flags)
> > > +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> > > +                       u32 len, u64 flags)
> >
> > This change is just to be able to call __bpf_skb_store_bytes() ?
> > If so, it's unnecessary.
> > See:
> > BPF_CALL_4(sk_reuseport_load_bytes,
> >            const struct sk_reuseport_kern *, reuse_kern, u32, offset,
> >            void *, to, u32, len)
> > {
> >         return ____bpf_skb_load_bytes(reuse_kern->skb, offset, to, len);
> > }
> >
> 
> There was prior feedback [0] that using four underscores to call a
> helper function is confusing and makes it ungreppable

There are plenty of ungreppable funcs in the kernel.
Try finding where folio_test_dirty() is defined.
mm subsystem is full of such 'features'.
Not friendly for casual kernel code reader, but useful.

Since quadruple underscore is already used in the code base
I see no reason to sacrifice bpf_skb_load_bytes performance with extra call.
