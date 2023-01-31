Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9678A68345C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjAaRzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjAaRzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:55:13 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4124A1D6;
        Tue, 31 Jan 2023 09:55:04 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id o187so2681112ybg.3;
        Tue, 31 Jan 2023 09:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KIF4ZdeaCeKjYQdmIsFHXDu+2Z1GY+nWSgWFl8nS/YA=;
        b=RLF+cyB7m4HGu+APfhye7KrE1xi5ilw7MyG8uPHVmSgUWvoWbLjpbpH+b577q+L3uJ
         3NUR3S1bouDTcJ337rffvNf0PUZSE2thMlzSUz58b9PvqGoimedY6Dg9tZdYI9Ip6u5s
         inmYBt/YdwCl2KciPPKInJx2knfqKlO6MtYdUNIYlYaFBJ8UtjtxQBcoq4JB7X3Cs1Rd
         JGBL5fTWqJcaIYo1yz+VuYZyC/YVAaFu/JsCBJqsD8IoHhfkL2Utyiu51LbDhz9Ju2g9
         odIrji9+x/F8IN5VuT5cqs9/V6D8ljPOugolzx7d9JDggvZOrm6CfEvxSXDUyBYQY9VT
         anuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KIF4ZdeaCeKjYQdmIsFHXDu+2Z1GY+nWSgWFl8nS/YA=;
        b=pygI1aycdPJGGMQnRneJ/JBcoc9uOpoTCvC2Z110Nn6FBRznyytuNA4rABZvr1lToB
         MQt7Ii5BqlVIVwEDBNq777UkNvkKPmMQLeQgoXkJWunApAGXQPT1Twv+qF7HDm9WM4ZV
         c6mImCSyydUZsT+/HQxSQrZFUAzCkVsHD6LLVeL8Z2wXa9VtVtjw6QhH1oFjDU8Je/tT
         plbgAUkGQMqRM+jLCdzAtKnbVJqtnUhR2K1LX+4CyWt91GOLKZBzyqBe2cSh+puX5LPm
         KtJ5qM5Af3xTYwD5kLQ5rKzty2PZ7H+hu2eur1pfSju/FjB5O5NgdRN3HSfliVcZvwqv
         6AqQ==
X-Gm-Message-State: AFqh2kp1+wU8jZ9tuDEsZW1U65FJvQQreCELPMeYGc40enqQCyCd+Mzb
        bJ+uOv5tKwyA0A46FoKhd36QC7ecfAnJxFVZJjCwcs70K2daTg==
X-Google-Smtp-Source: AMrXdXvYkX+Q+2Nq55Xtg9CBe63p3xz5VxdUcBvFY/u+fBAokjlVxygj4lWCa8/kosL9wcm/BURlq06iUrN4nhNhtKw=
X-Received: by 2002:a25:7d45:0:b0:802:b7a:4069 with SMTP id
 y66-20020a257d45000000b008020b7a4069mr4671719ybc.433.1675187703400; Tue, 31
 Jan 2023 09:55:03 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <20230129233928.f3wf6dd6ep75w4vz@MacBook-Pro-6.local>
 <CAJnrk1ap0dsdEzR31x0=9hTaA=4xUU+yvgT8=Ur3tEUYur=Edw@mail.gmail.com> <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230131053605.g7o75yylku6nusnp@macbook-pro-6.dhcp.thefacebook.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 31 Jan 2023 09:54:52 -0800
Message-ID: <CAJnrk1Z_GB_ynL5kEaVQaxYsPFjad+3dk8JWKqDfvb1VHHavwg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
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

On Mon, Jan 30, 2023 at 9:36 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jan 30, 2023 at 04:44:12PM -0800, Joanne Koong wrote:
> > On Sun, Jan 29, 2023 at 3:39 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Jan 27, 2023 at 11:17:01AM -0800, Joanne Koong wrote:
> > > > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > > > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > > > benefits. One is that they allow operations on sizes that are not
> > > > statically known at compile-time (eg variable-sized accesses).
> > > > Another is that parsing the packet data through dynptrs (instead of
> > > > through direct access of skb->data and skb->data_end) can be more
> > > > ergonomic and less brittle (eg does not need manual if checking for
> > > > being within bounds of data_end).
> > > >
> > > > For bpf prog types that don't support writes on skb data, the dynptr is
> > > > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > > > will return a data slice that is read-only where any writes to it will
> > > > be rejected by the verifier).
> > > >
> > > > For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
> > > > interfaces, reading and writing from/to data in the head as well as from/to
> > > > non-linear paged buffers is supported. For data slices (through the
> > > > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > > > must first call bpf_skb_pull_data() to pull the data into the linear
> > > > portion.
> > >
> > > Looks like there is an assumption in parts of this patch that
> > > linear part of skb is always writeable. That's not the case.
> > > See if (ops->gen_prologue || env->seen_direct_write) in convert_ctx_accesses().
> > > For TC progs it calls bpf_unclone_prologue() which adds hidden
> > > bpf_skb_pull_data() in the beginning of the prog to make it writeable.
> >
> > I think we can make this assumption? For writable progs (referenced in
> > the may_access_direct_pkt_data() function), all of them have a
> > gen_prologue that unclones the buffer (eg tc_cls_act, lwt_xmit, sk_skb
> > progs) or their linear portion is okay to write into by default (eg
> > xdp, sk_msg, cg_sockopt progs).
>
> but the patch was preserving seen_direct_write in some cases.
> I'm still confused.

seen_direct_write is used to determine whether to actually unclone or
not in the program's prologue function (eg tc_cls_act_prologue() ->
bpf_unclone_prologue() where in bpf_unclone_prologue(), if
direct_write was not true, then it can skip doing the actual
uncloning).

I think the part of the patch you're talking about regarding
seen_direct_write is this in check_helper_call():

+ if (func_id == BPF_FUNC_dynptr_data &&
+    dynptr_type == BPF_DYNPTR_TYPE_SKB) {
+   bool seen_direct_write = env->seen_direct_write;
+
+   regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
+   if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
+     regs[BPF_REG_0].type |= MEM_RDONLY;
+   else
+     /*
+     * Calling may_access_direct_pkt_data() will set
+     * env->seen_direct_write to true if the skb is
+     * writable. As an optimization, we can ignore
+     * setting env->seen_direct_write.
+     *
+     * env->seen_direct_write is used by skb
+     * programs to determine whether the skb's page
+     * buffers should be cloned. Since data slice
+     * writes would only be to the head, we can skip
+     * this.
+     */
+     env->seen_direct_write = seen_direct_write;
+ }

If the data slice for a skb dynptr is writable, then seen_direct_write
gets set to true (done internally in may_access_direct_pkt_data()) so
that the skb is actually uncloned, whereas if it's read-only, then
env->seen_direct_write gets reset to its original value (since the
may_access_direct_pkt_data() call will have set env->seen_direct_write
to true)

>
> > >
> > > > Any bpf_dynptr_write() automatically invalidates any prior data slices
> > > > to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> > > > to data in a paged buffer, so it will need to pull the buffer first into
> > > > the head. The reason it needs to be pulled instead of writing directly to
> > > > the paged buffers is because they may be cloned (only the head of the skb
> > > > is by default uncloned). As such, any bpf_dynptr_write() will
> > > > automatically have its prior data slices invalidated, even if the write
> > > > is to data in the skb head (the verifier has no way of differentiating
> > > > whether the write is to the head or paged buffers during program load
> > > > time).
> > >
> > > Could you explain the workflow how bpf_dynptr_write() invalidates other
> > > pkt pointers ?
> > > I expected bpf_dynptr_write() to be in bpf_helper_changes_pkt_data().
> > > Looks like bpf_dynptr_write() calls bpf_skb_store_bytes() underneath,
> > > but that doesn't help the verifier.
> >
> > In the verifier in check_helper_call(), for the BPF_FUNC_dynptr_write
> > case (line 8236) the "changes_data" variable gets set to true if the
> > dynptr is an skb type. At the end of check_helper_call() on line 8474,
> > since "changes_data" is true, clear_all_pkt_pointer() gets called,
> > which invalidates the other packet pointers.
>
> Ahh. I see. Thanks for explaining.
>
> > >
> > > > Please note as well that any other helper calls that change the
> > > > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > > > slices of the skb dynptr as well. The stack trace for this is
> > > > check_helper_call() -> clear_all_pkt_pointers() ->
> > > > __clear_all_pkt_pointers() -> mark_reg_unknown().
> > >
> > > __clear_all_pkt_pointers isn't present in the tree. Typo ?
> >
> > I'll update this message, clear_all_pkt_pointers() and
> > __clear_all_pkt_pointers() were combined in a previous commit.
> >
> > >
> > > >
> > > > For examples of how skb dynptrs can be used, please see the attached
> > > > selftests.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  include/linux/bpf.h            |  82 +++++++++------
> > > >  include/linux/filter.h         |  18 ++++
> > > >  include/uapi/linux/bpf.h       |  37 +++++--
> > > >  kernel/bpf/btf.c               |  18 ++++
> > > >  kernel/bpf/helpers.c           |  95 ++++++++++++++---
> > > >  kernel/bpf/verifier.c          | 185 ++++++++++++++++++++++++++-------
> > > >  net/core/filter.c              |  60 ++++++++++-
> > > >  tools/include/uapi/linux/bpf.h |  37 +++++--
> > > >  8 files changed, 432 insertions(+), 100 deletions(-)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 14a0264fac57..1ac061b64582 100644
> > [...]
> > > > @@ -8243,6 +8316,28 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> > > >               mark_reg_known_zero(env, regs, BPF_REG_0);
> > > >               regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > > >               regs[BPF_REG_0].mem_size = meta.mem_size;
> > > > +             if (func_id == BPF_FUNC_dynptr_data &&
> > > > +                 dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > > +                     bool seen_direct_write = env->seen_direct_write;
> > > > +
> > > > +                     regs[BPF_REG_0].type |= DYNPTR_TYPE_SKB;
> > > > +                     if (!may_access_direct_pkt_data(env, NULL, BPF_WRITE))
> > > > +                             regs[BPF_REG_0].type |= MEM_RDONLY;
> > > > +                     else
> > > > +                             /*
> > > > +                              * Calling may_access_direct_pkt_data() will set
> > > > +                              * env->seen_direct_write to true if the skb is
> > > > +                              * writable. As an optimization, we can ignore
> > > > +                              * setting env->seen_direct_write.
> > > > +                              *
> > > > +                              * env->seen_direct_write is used by skb
> > > > +                              * programs to determine whether the skb's page
> > > > +                              * buffers should be cloned. Since data slice
> > > > +                              * writes would only be to the head, we can skip
> > > > +                              * this.
>
> I was talking about above comment. It reads as 'write to the head are allowed'.
> But they're not. seen_direct_write is needed to do hidden pull.
>

I will remove this line, I agree that it is confusing.

> > > > +                              */
> > > > +                             env->seen_direct_write = seen_direct_write;
> > >
> > > This looks incorrect. skb head might not be writeable.
> > >
> > > > +             }
> > > >               break;
> > > >       case RET_PTR_TO_MEM_OR_BTF_ID:
> > > >       {
> > > > @@ -8649,6 +8744,7 @@ enum special_kfunc_type {
> > > >       KF_bpf_list_pop_back,
> > > >       KF_bpf_cast_to_kern_ctx,
> > > >       KF_bpf_rdonly_cast,
> > > > +     KF_bpf_dynptr_from_skb,
> > > >       KF_bpf_rcu_read_lock,
> > > >       KF_bpf_rcu_read_unlock,
> > > >  };
> > > > @@ -8662,6 +8758,7 @@ BTF_ID(func, bpf_list_pop_front)
> > > >  BTF_ID(func, bpf_list_pop_back)
> > > >  BTF_ID(func, bpf_cast_to_kern_ctx)
> > > >  BTF_ID(func, bpf_rdonly_cast)
> > > > +BTF_ID(func, bpf_dynptr_from_skb)
> > > >  BTF_SET_END(special_kfunc_set)
> > > >
> > > >  BTF_ID_LIST(special_kfunc_list)
> > > > @@ -8673,6 +8770,7 @@ BTF_ID(func, bpf_list_pop_front)
> > > >  BTF_ID(func, bpf_list_pop_back)
> > > >  BTF_ID(func, bpf_cast_to_kern_ctx)
> > > >  BTF_ID(func, bpf_rdonly_cast)
> > > > +BTF_ID(func, bpf_dynptr_from_skb)
> > > >  BTF_ID(func, bpf_rcu_read_lock)
> > > >  BTF_ID(func, bpf_rcu_read_unlock)
> > > >
> > > > @@ -9263,17 +9361,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
> > > >                               return ret;
> > > >                       break;
> > > >               case KF_ARG_PTR_TO_DYNPTR:
> > > > +             {
> > > > +                     enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
> > > > +
> > > >                       if (reg->type != PTR_TO_STACK &&
> > > >                           reg->type != CONST_PTR_TO_DYNPTR) {
> > > >                               verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
> > > >                               return -EINVAL;
> > > >                       }
> > > >
> > > > -                     ret = process_dynptr_func(env, regno, insn_idx,
> > > > -                                               ARG_PTR_TO_DYNPTR | MEM_RDONLY);
> > > > +                     if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
> > > > +                             dynptr_arg_type |= MEM_UNINIT | DYNPTR_TYPE_SKB;
> > > > +                     else
> > > > +                             dynptr_arg_type |= MEM_RDONLY;
> > > > +
> > > > +                     ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type,
> > > > +                                               meta->func_id);
> > > >                       if (ret < 0)
> > > >                               return ret;
> > > >                       break;
> > > > +             }
> > > >               case KF_ARG_PTR_TO_LIST_HEAD:
> > > >                       if (reg->type != PTR_TO_MAP_VALUE &&
> > > >                           reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
> > > > @@ -15857,6 +15964,14 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> > > >                  desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
> > > >               insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
> > > >               *cnt = 1;
> > > > +     } else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
> > > > +             bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> > > > +             struct bpf_insn addr[2] = { BPF_LD_IMM64(BPF_REG_4, is_rdonly) };
> > >
> > > Why use 16-byte insn to pass boolean in R4 ?
> > > Single 8-byte MOV would do.
> >
> > Great, I'll change it to a 8-byte MOV
> >
> > >
> > > > +
> > > > +             insn_buf[0] = addr[0];
> > > > +             insn_buf[1] = addr[1];
> > > > +             insn_buf[2] = *insn;
> > > > +             *cnt = 3;
> > > >       }
> > > >       return 0;
> > > >  }
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 6da78b3d381e..ddb47126071a 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -1684,8 +1684,8 @@ static inline void bpf_pull_mac_rcsum(struct sk_buff *skb)
> > > >               skb_postpull_rcsum(skb, skb_mac_header(skb), skb->mac_len);
> > > >  }
> > > >
> > > > -BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
> > > > -        const void *, from, u32, len, u64, flags)
> > > > +int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
> > > > +                       u32 len, u64 flags)
> > >
> > > This change is just to be able to call __bpf_skb_store_bytes() ?
> > > If so, it's unnecessary.
> > > See:
> > > BPF_CALL_4(sk_reuseport_load_bytes,
> > >            const struct sk_reuseport_kern *, reuse_kern, u32, offset,
> > >            void *, to, u32, len)
> > > {
> > >         return ____bpf_skb_load_bytes(reuse_kern->skb, offset, to, len);
> > > }
> > >
> >
> > There was prior feedback [0] that using four underscores to call a
> > helper function is confusing and makes it ungreppable
>
> There are plenty of ungreppable funcs in the kernel.
> Try finding where folio_test_dirty() is defined.
> mm subsystem is full of such 'features'.
> Not friendly for casual kernel code reader, but useful.
>
> Since quadruple underscore is already used in the code base
> I see no reason to sacrifice bpf_skb_load_bytes performance with extra call.

I don't have a preference either way, I'll change it to use the
quadruple underscore in the next version
