Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC85A049B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiHXX0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiHXX0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:26:30 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3809481E4;
        Wed, 24 Aug 2022 16:26:28 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h8so5735536ili.11;
        Wed, 24 Aug 2022 16:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4DtSuFmeHUObCD5eRg7i5V6xy48JNioy5DBVx1Wrttw=;
        b=fC456US7saT8DwJTRMTrXMjo7Uw5VWPP8G/w7erIsZ3qY/XNgapAzTZp6H+4Zod6ab
         eFIS8n+haS9Mr3RIpyAd049yWQCtJw+IWlOz8Fbr+b6+Ya+0jTuHaMxTuBZ140ImrzdE
         XJlashnChi32SUn5FOTnxkqTurGxj3+atLEifZBO1SzWNWjuDuc+Ab6hn8kHBuerfDJz
         15d8QbUR2R+wbiuUr2tnJQLwOIgniBiqqtMupSwEW8Vegxz7xW4dKdIgvQ6BvvFSClB8
         FVItRaeCU0ZXHPiTcP/kRo6oT48vTWNsVE+yheLQfE0P162Gk0YHbFbNgt1Ix01d3xgJ
         I1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4DtSuFmeHUObCD5eRg7i5V6xy48JNioy5DBVx1Wrttw=;
        b=qpu9Mu4F7tdOs/qANogM1Qj31cHQp/atdoMHUVrrB9NfRPMu+h5uUe8JOoUH0Thcxv
         BpVR20S87XWGy77vZZTvuzpqhyjqEPjhjSy8NDr7oL7QnOgclhh5U7AOWEqKVr+YUJ8D
         9OyPiT+oUSM64OpCrako9eJvb1fPsFIBT6uz0qaBKvstNnmtZHj2n1UnrLOsoTHT/2XX
         BSY2EJFs9fxQxP+Lp/D0B8H2u1FyokrVCON3P0WpwInORRIJpp7tvWFiZ/ulC7/KqIWX
         99oygJEmT7RdxJYC+TRIbBUvAbmxNFA5OClUjPgaONCqoV4zQQN0vMuPiM0x+Rvh1m7g
         vjrg==
X-Gm-Message-State: ACgBeo1EOp8EWahsi6wzBLAva3VZE8OE9fYuQ+KFWptn+YpiqbOg8lEa
        A5OXy48jZjd9J4Mvt2sRfZdxBhpw2C2pxgsAdoE=
X-Google-Smtp-Source: AA6agR4CovdhnarcZeAmZg2Ho9Oc2uBFInTH4dGJKjXV87gmm4+fp8Zl7+HTWCtoiyDrQKBsN1rfS5d3LrByzXRf884=
X-Received: by 2002:a92:ca07:0:b0:2e9:7f3d:4df5 with SMTP id
 j7-20020a92ca07000000b002e97f3d4df5mr601024ils.216.1661383587817; Wed, 24 Aug
 2022 16:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
In-Reply-To: <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 25 Aug 2022 01:25:51 +0200
Message-ID: <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 at 20:42, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 22, 2022 at 4:57 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > Add skb dynptrs, which are dynptrs whose underlying pointer points
> > to a skb. The dynptr acts on skb data. skb dynptrs have two main
> > benefits. One is that they allow operations on sizes that are not
> > statically known at compile-time (eg variable-sized accesses).
> > Another is that parsing the packet data through dynptrs (instead of
> > through direct access of skb->data and skb->data_end) can be more
> > ergonomic and less brittle (eg does not need manual if checking for
> > being within bounds of data_end).
> >
> > For bpf prog types that don't support writes on skb data, the dynptr is
> > read-only. For reads and writes through the bpf_dynptr_read() and
> > bpf_dynptr_write() interfaces, this supports reading and writing into
> > data in the non-linear paged buffers. For data slices (through the
> > bpf_dynptr_data() interface), if the data is in a paged buffer, the user
> > must first call bpf_skb_pull_data() to pull the data into the linear
> > portion. The returned data slice from a call to bpf_dynptr_data() is of
> > reg type PTR_TO_PACKET | PTR_MAYBE_NULL.
> >
> > Any bpf_dynptr_write() automatically invalidates any prior data slices
> > to the skb dynptr. This is because a bpf_dynptr_write() may be writing
> > to data in a paged buffer, so it will need to pull the buffer first into
> > the head. The reason it needs to be pulled instead of writing directly to
> > the paged buffers is because they may be cloned (only the head of the skb
> > is by default uncloned). As such, any bpf_dynptr_write() will
> > automatically have its prior data slices invalidated, even if the write
> > is to data in the skb head (the verifier has no way of differentiating
> > whether the write is to the head or paged buffers during program load
> > time). Please note as well that any other helper calls that change the
> > underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> > slices of the skb dynptr as well. Whenever such a helper call is made,
> > the verifier marks any PTR_TO_PACKET reg type (which includes skb dynptr
> > slices since they are PTR_TO_PACKETs) as unknown. The stack trace for
> > this is check_helper_call() -> clear_all_pkt_pointers() ->
> > __clear_all_pkt_pointers() -> mark_reg_unknown()
> >
> > For examples of how skb dynptrs can be used, please see the attached
> > selftests.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/bpf.h            | 83 +++++++++++++++++-----------
> >  include/linux/filter.h         |  4 ++
> >  include/uapi/linux/bpf.h       | 40 ++++++++++++--
> >  kernel/bpf/helpers.c           | 81 +++++++++++++++++++++++++---
> >  kernel/bpf/verifier.c          | 99 ++++++++++++++++++++++++++++------
> >  net/core/filter.c              | 53 ++++++++++++++++--
> >  tools/include/uapi/linux/bpf.h | 40 ++++++++++++--
> >  7 files changed, 335 insertions(+), 65 deletions(-)
> >
>
> [...]
>
> > @@ -1521,9 +1532,19 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, struct bpf_dynptr_kern *, src
> >         if (err)
> >                 return err;
> >
> > -       memcpy(dst, src->data + src->offset + offset, len);
> > +       type = bpf_dynptr_get_type(src);
> >
> > -       return 0;
> > +       switch (type) {
> > +       case BPF_DYNPTR_TYPE_LOCAL:
> > +       case BPF_DYNPTR_TYPE_RINGBUF:
> > +               memcpy(dst, src->data + src->offset + offset, len);
> > +               return 0;
> > +       case BPF_DYNPTR_TYPE_SKB:
> > +               return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
> > +       default:
> > +               WARN(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
>
> nit: probably better to WARN_ONCE?
>
> > +               return -EFAULT;
> > +       }
> >  }
> >
> >  static const struct bpf_func_proto bpf_dynptr_read_proto = {
> > @@ -1540,18 +1561,32 @@ static const struct bpf_func_proto bpf_dynptr_read_proto = {
> >  BPF_CALL_5(bpf_dynptr_write, struct bpf_dynptr_kern *, dst, u32, offset, void *, src,
> >            u32, len, u64, flags)
> >  {
> > +       enum bpf_dynptr_type type;
> >         int err;
> >
> > -       if (!dst->data || flags || bpf_dynptr_is_rdonly(dst))
> > +       if (!dst->data || bpf_dynptr_is_rdonly(dst))
> >                 return -EINVAL;
> >
> >         err = bpf_dynptr_check_off_len(dst, offset, len);
> >         if (err)
> >                 return err;
> >
> > -       memcpy(dst->data + dst->offset + offset, src, len);
> > +       type = bpf_dynptr_get_type(dst);
> >
> > -       return 0;
> > +       switch (type) {
> > +       case BPF_DYNPTR_TYPE_LOCAL:
> > +       case BPF_DYNPTR_TYPE_RINGBUF:
> > +               if (flags)
> > +                       return -EINVAL;
> > +               memcpy(dst->data + dst->offset + offset, src, len);
> > +               return 0;
> > +       case BPF_DYNPTR_TYPE_SKB:
> > +               return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
> > +                                            flags);
> > +       default:
> > +               WARN(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
>
> ditto about WARN_ONCE
>
> > +               return -EFAULT;
> > +       }
> >  }
> >
> >  static const struct bpf_func_proto bpf_dynptr_write_proto = {
>
> [...]
>
> > +static enum bpf_dynptr_type stack_slot_get_dynptr_info(struct bpf_verifier_env *env,
> > +                                                      struct bpf_reg_state *reg,
> > +                                                      int *ref_obj_id)
> >  {
> >         struct bpf_func_state *state = func(env, reg);
> >         int spi = get_spi(reg->off);
> >
> > -       return state->stack[spi].spilled_ptr.id;
> > +       if (ref_obj_id)
> > +               *ref_obj_id = state->stack[spi].spilled_ptr.id;
> > +
> > +       return state->stack[spi].spilled_ptr.dynptr.type;
> >  }
> >
> >  static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> > @@ -6056,7 +6075,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >                         case DYNPTR_TYPE_RINGBUF:
> >                                 err_extra = "ringbuf ";
> >                                 break;
> > -                       default:
> > +                       case DYNPTR_TYPE_SKB:
> > +                               err_extra = "skb ";
> >                                 break;
> >                         }
> >
> > @@ -7149,6 +7169,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >  {
> >         enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
> >         const struct bpf_func_proto *fn = NULL;
> > +       enum bpf_dynptr_type dynptr_type;
>
> compiler technically can complain about use of uninitialized
> dynptr_type, maybe initialize it to BPF_DYNPTR_TYPE_INVALID ?
>
> >         enum bpf_return_type ret_type;
> >         enum bpf_type_flag ret_flag;
> >         struct bpf_reg_state *regs;
> > @@ -7320,24 +7341,43 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >                         }
> >                 }
> >                 break;
> > -       case BPF_FUNC_dynptr_data:
> > -               for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
> > -                       if (arg_type_is_dynptr(fn->arg_type[i])) {
> > -                               if (meta.ref_obj_id) {
> > -                                       verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
> > -                                       return -EFAULT;
> > -                               }
> > -                               /* Find the id of the dynptr we're tracking the reference of */
> > -                               meta.ref_obj_id = stack_slot_get_id(env, &regs[BPF_REG_1 + i]);
> > -                               break;
> > -                       }
> > +       case BPF_FUNC_dynptr_write:
> > +       {
> > +               struct bpf_reg_state *reg;
> > +
> > +               reg = get_dynptr_arg_reg(fn, regs);
> > +               if (!reg) {
> > +                       verbose(env, "verifier internal error: no dynptr in bpf_dynptr_data()\n");
>
> s/bpf_dynptr_data/bpf_dynptr_write/
>
> > +                       return -EFAULT;
> >                 }
> > -               if (i == MAX_BPF_FUNC_REG_ARGS) {
> > +
> > +               /* bpf_dynptr_write() for skb-type dynptrs may pull the skb, so we must
> > +                * invalidate all data slices associated with it
> > +                */
> > +               if (stack_slot_get_dynptr_info(env, reg, NULL) == BPF_DYNPTR_TYPE_SKB)
> > +                       changes_data = true;
> > +
> > +               break;
> > +       }
> > +       case BPF_FUNC_dynptr_data:
> > +       {
> > +               struct bpf_reg_state *reg;
> > +
> > +               reg = get_dynptr_arg_reg(fn, regs);
> > +               if (!reg) {
> >                         verbose(env, "verifier internal error: no dynptr in bpf_dynptr_data()\n");
> >                         return -EFAULT;
> >                 }
> > +
> > +               if (meta.ref_obj_id) {
> > +                       verbose(env, "verifier internal error: meta.ref_obj_id already set\n");
> > +                       return -EFAULT;
> > +               }
> > +
> > +               dynptr_type = stack_slot_get_dynptr_info(env, reg, &meta.ref_obj_id);
> >                 break;
> >         }
> > +       }
> >
> >         if (err)
> >                 return err;
> > @@ -7397,8 +7437,15 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >                 break;
> >         case RET_PTR_TO_ALLOC_MEM:
> >                 mark_reg_known_zero(env, regs, BPF_REG_0);
> > -               regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > -               regs[BPF_REG_0].mem_size = meta.mem_size;
> > +
> > +               if (func_id == BPF_FUNC_dynptr_data &&
> > +                   dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > +                       regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
> > +                       regs[BPF_REG_0].range = meta.mem_size;
> > +               } else {
> > +                       regs[BPF_REG_0].type = PTR_TO_MEM | ret_flag;
> > +                       regs[BPF_REG_0].mem_size = meta.mem_size;
> > +               }
> >                 break;
> >         case RET_PTR_TO_MEM_OR_BTF_ID:
> >         {
> > @@ -14141,6 +14188,24 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> >                         goto patch_call_imm;
> >                 }
> >
> > +               if (insn->imm == BPF_FUNC_dynptr_from_skb) {
> > +                       bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
> > +
> > +                       insn_buf[0] = BPF_MOV32_IMM(BPF_REG_4, is_rdonly);
> > +                       insn_buf[1] = *insn;
> > +                       cnt = 2;
>
> This might have been discussed before, sorry if I missed it. But why
> this special rewrite to provide read-only flag vs having two
> implementations of bpf_dynptr_from_skb() depending on program types?
> If program type allows read+write access, return
> bpf_dynptr_from_skb_rdwr(), for those that have read-only access -
> bpf_dynptr_from_skb_rdonly(), and for others return NULL proto
> (disable helper)?
>
> You can then use it very similarly for bpf_dynptr_from_skb_meta().
>

Related question, it seems we know statically if dynptr is read only
or not, so why even do all this hidden parameter passing and instead
just reject writes directly? You only need to be able to set
MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
seems simpler than checking it at runtime. Verifier already handles
MEM_RDONLY generically, you only need to add the guard for
check_packet_acces (and check_helper_mem_access for meta->raw_mode
under pkt case), and rejecting dynptr_write seems like a if condition.
