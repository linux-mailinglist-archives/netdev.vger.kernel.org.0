Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D4152D1FF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiESMGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237656AbiESMGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:06:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E07F12619
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 05:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652961970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QsBqNx39vpBPxFkvv+icJ3IAaIG6Pb9SYJawa30470w=;
        b=DKNdSOkUmfplAE984r9yLj+aJtXb/AUJI4yGRyN9dmghFreLOLgrEFkUzLBEu6EKuR+oB6
        23XNBvwzhrqXIHFeXQ8RnECKrGVmKbU+pABaPi+/lW17BUnYzNU9NorsJQNEG7UlnE8Asw
        5+fjkGNx4isyoa1FKisERTA2qt6AI/0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-DDLeD2-ENq6vwpMI5JWUfg-1; Thu, 19 May 2022 08:06:09 -0400
X-MC-Unique: DDLeD2-ENq6vwpMI5JWUfg-1
Received: by mail-pl1-f198.google.com with SMTP id s2-20020a17090302c200b00158ea215fa2so2513201plk.3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 05:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QsBqNx39vpBPxFkvv+icJ3IAaIG6Pb9SYJawa30470w=;
        b=7DEu33RKuNWEe2NDTjqoE+mZ72esn1Hm1cms0udI/KqkHlLhq6vcRwey3oeLTLgRhg
         q7UNutX1lQBTiyhYOlO2q0KufS4ATzlN3pwIa/RVklJX5S3Z9hN/7wV9PLJ6htKopZ+c
         H2+hrNK2JDOnLVn5IktH1t5KVpb6k7ZvN2t2H0fqPLuz6VtjxVvMWmgZ8q6/tXFUOuI4
         20+Yk3+NLGuO/Fmo7mi4oGxP1Bk7Lwh2/Qc4PcciPGI/2W7/MaH8FV6z+JmfjN41GA5n
         ak34NYbXvGRewiOUrgr4gnBDgwIISnnqAN5ho1wQBmjEx54jPknAQiTRMHkMmxaff1ZN
         LXWw==
X-Gm-Message-State: AOAM533JiYVBXQ+99Qu9DqJNZdBe6QcLhuYh67QN1z/9qQax8SWm9ehl
        fuAANXhvOV1h44J0RZ3894hHJ8Uu1TmyT8uFiWCGbPf7AsZPHsaPzOaYrQqPA4/bcz/B0BMGhPI
        lgBdoqSu6vTeNPsWpuUDy6OPCj/WXM68F
X-Received: by 2002:a17:90a:f68c:b0:1df:a74d:dbe2 with SMTP id cl12-20020a17090af68c00b001dfa74ddbe2mr4850535pjb.113.1652961968280;
        Thu, 19 May 2022 05:06:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6yq0wEtUz9d6RF+48+y4DWicynbI2bKjeKek1XnIp3BlTAKzxx6Npxtg/ulMRmUApuyKT3mI3RlxB8Px9ZN4=
X-Received: by 2002:a17:90a:f68c:b0:1df:a74d:dbe2 with SMTP id
 cl12-20020a17090af68c00b001dfa74ddbe2mr4850508pjb.113.1652961967942; Thu, 19
 May 2022 05:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <20220518205924.399291-3-benjamin.tissoires@redhat.com> <20220518215951.bhurzqzytb4kxqtm@apollo.legion>
In-Reply-To: <20220518215951.bhurzqzytb4kxqtm@apollo.legion>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Thu, 19 May 2022 14:05:56 +0200
Message-ID: <CAO-hwJ+k7NjTieT6Uj1NvwGC7mxKw++U6PY5JqVQ=0=BsHVaoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 02/17] bpf/verifier: allow kfunc to return an
 allocated mem
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks a lot for the quick review of these patches.

On Wed, May 18, 2022 at 11:59 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, May 19, 2022 at 02:29:09AM IST, Benjamin Tissoires wrote:
> > When a kfunc is not returning a pointer to a struct but to a plain type,
> > we can consider it is a valid allocated memory assuming that:
> > - one of the arguments is called rdonly_buf_size
> > - or one of the arguments is called rdwr_buf_size
> > - and this argument is a const from the caller point of view
> >
> > We can then use this parameter as the size of the allocated memory.
> >
> > The memory is either read-only or read-write based on the name
> > of the size parameter.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >
> > changes in v5:
> > - updated PTR_TO_MEM comment in btf.c to match upstream
> > - make it read-only or read-write based on the name of size
> >
> > new in v4
> > ---
> >  include/linux/btf.h   |  7 +++++
> >  kernel/bpf/btf.c      | 41 +++++++++++++++++++++++-
> >  kernel/bpf/verifier.c | 72 +++++++++++++++++++++++++++++++++----------
> >  3 files changed, 102 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 2611cea2c2b6..2a4feafc083e 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -343,6 +343,13 @@ static inline struct btf_param *btf_params(const struct btf_type *t)
> >       return (struct btf_param *)(t + 1);
> >  }
> >
> > +struct bpf_reg_state;
> > +
> > +bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
> > +                            const struct btf_param *arg,
> > +                            const struct bpf_reg_state *reg,
> > +                            const char *name);
> > +
> >  #ifdef CONFIG_BPF_SYSCALL
> >  struct bpf_prog;
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 7bccaa4646e5..2d11d178807c 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6049,6 +6049,31 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
> >       return true;
> >  }
> >
> > +bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
> > +                            const struct btf_param *arg,
> > +                            const struct bpf_reg_state *reg,
> > +                            const char *name)
> > +{
> > +     int len, target_len = strlen(name);
> > +     const struct btf_type *t;
> > +     const char *param_name;
> > +
> > +     t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > +     if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> > +             return false;
> > +
> > +     param_name = btf_name_by_offset(btf, arg->name_off);
> > +     if (str_is_empty(param_name))
> > +             return false;
> > +     len = strlen(param_name);
> > +     if (len != target_len)
> > +             return false;
> > +     if (strncmp(param_name, name, target_len))
> > +             return false;
> > +
> > +     return true;
> > +}
>
> I think you don't need these checks. btf_check_kfunc_arg_match would have
> already made sure scalar arguments receive scalar. The rest is just matching on
> the argument name, which you can directly strcmp when setting up R0's type.

OK.

>
> > +
> >  static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >                                   const struct btf *btf, u32 func_id,
> >                                   struct bpf_reg_state *regs,
> > @@ -6198,7 +6223,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >                       if (reg->type == PTR_TO_BTF_ID) {
> >                               reg_btf = reg->btf;
> >                               reg_ref_id = reg->btf_id;
> > -                             /* Ensure only one argument is referenced PTR_TO_BTF_ID */
> > +                             /* Ensure only one argument is reference PTR_TO_BTF_ID or PTR_TO_MEM */
>
> But this part of the code would never be reached for PTR_TO_MEM, so the comment
> would be false?

Right, I mostly duplicated the code and the comment, so I'll drop it, thanks.

>
> >                               if (reg->ref_obj_id) {
> >                                       if (ref_obj_id) {
> >                                               bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
> > @@ -6258,6 +6283,20 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >                                       i++;
> >                                       continue;
> >                               }
> > +
> > +                             if (rel && reg->ref_obj_id) {
> > +                                     /* Ensure only one argument is referenced PTR_TO_BTF_ID or PTR_TO_MEM */
> > +                                     if (ref_obj_id) {
> > +                                             bpf_log(log,
> > +                                                     "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
> > +                                                     regno,
> > +                                                     reg->ref_obj_id,
> > +                                                     ref_obj_id);
> > +                                             return -EFAULT;
> > +                                     }
> > +                                     ref_regno = regno;
> > +                                     ref_obj_id = reg->ref_obj_id;
> > +                             }
>
> Why do we need this part? I don't see any code passing that __u8 * back into a
> release function. The only release function I see that you are adding is
> releasing a struct, which should be PTR_TO_BTF_ID and already supported.

In my mind, we should have been able to acquire/release PTR_TO_MEM in
the same way we are doing with PTR_TO_BTF_ID. But after fully writing
down the code, it was not required, so maybe we can keep
acquire/release only for PTR_TO_BTF_ID.

>
> Also acquire function should not return non-struct pointer. Can you also update
> the if (acq && !btf_type_is_ptr(t)) check in check_kfunc_call to instead check
> for btf_type_is_struct? The verbose log would be misleading now, but it was
> based on the assumption only PTR_TO_BTF_ID as return pointer is supported.

OK.

>
> >                       }
> >
> >                       resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 9b59581026f8..084319073064 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7219,13 +7219,14 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >                           int *insn_idx_p)
> >  {
> >       const struct btf_type *t, *func, *func_proto, *ptr_type;
> > -     struct bpf_reg_state *regs = cur_regs(env);
> > +     struct bpf_reg_state *reg, *regs = cur_regs(env);
> >       const char *func_name, *ptr_type_name;
> > -     u32 i, nargs, func_id, ptr_type_id;
> > +     u32 i, nargs, func_id, ptr_type_id, regno;
> >       int err, insn_idx = *insn_idx_p;
> >       const struct btf_param *args;
> >       struct btf *desc_btf;
> >       bool acq;
> > +     size_t reg_rw_size = 0, reg_ro_size = 0;
>
> Not reverse X-mas tree.

Oh, I didn't realize this was the applied convention. I'll amend
(though the code refactoring from your comment below will probably
change that hunk above).

>
> >
> >       /* skip for now, but return error when we find this in fixup_kfunc_call */
> >       if (!insn->imm)
> > @@ -7266,8 +7267,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               }
> >       }
> >
> > -     for (i = 0; i < CALLER_SAVED_REGS; i++)
> > -             mark_reg_not_init(env, regs, caller_saved[i]);
> > +     /* reset REG_0 */
> > +     mark_reg_not_init(env, regs, BPF_REG_0);
> >
> >       /* Check return type */
> >       t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
> > @@ -7277,6 +7278,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               return -EINVAL;
> >       }
> >
> > +     nargs = btf_type_vlen(func_proto);
> > +     args = btf_params(func_proto);
> > +
> >       if (btf_type_is_scalar(t)) {
> >               mark_reg_unknown(env, regs, BPF_REG_0);
> >               mark_btf_func_reg_size(env, BPF_REG_0, t->size);
> > @@ -7284,24 +7288,57 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
> >                                                  &ptr_type_id);
> >               if (!btf_type_is_struct(ptr_type)) {
> > -                     ptr_type_name = btf_name_by_offset(desc_btf,
> > -                                                        ptr_type->name_off);
> > -                     verbose(env, "kernel function %s returns pointer type %s %s is not supported\n",
> > -                             func_name, btf_type_str(ptr_type),
> > -                             ptr_type_name);
> > -                     return -EINVAL;
> > +                     /* if we have an array, look for the arguments */
> > +                     for (i = 0; i < nargs; i++) {
> > +                             regno = i + BPF_REG_1;
> > +                             reg = &regs[regno];
> > +
> > +                             /* look for any const scalar parameter of name "rdonly_buf_size"
> > +                              * or "rdwr_buf_size"
> > +                              */
> > +                             if (!check_reg_arg(env, regno, SRC_OP) &&
> > +                                 tnum_is_const(regs[regno].var_off)) {
>
> Instead of this, we should probably just check the argument that has its name as
> rdonly/rdwr_buf_size inside btf_check_kfunc_arg_match and ensure there is only
> one of those. No need for check_reg_arg, and just this tnum_is_const can also be
> enforced inside btf_check_kfunc_arg_match. You can pass a struct like so:
>
>         struct bpf_kfunc_arg_meta {
>                 u64 r0_size;
>                 bool r0_rdonly;
>         };
>
> and set its value to reg->var_off.value from inside the function in the argument
> checking loop. Then you don't have to change the mark_reg_not_init order here.
> All your code can be inside the if (btf_type_is_scalar(t)) branch.

OK. I think I get it. Not sure I'll be able to get to it by the end of
the week or next week, but I'll work on that cleanup for sure.

>
> Also, it would be nice to use this struct to signal the register that is being
> released. Right now it's done using a > 0 return value (the if (err)) which is a
> bit ugly. But up to you if you want to do that tiny cleanup.

Should be easy enough to do, yes.

>
> > +                                     if (btf_is_kfunc_arg_mem_size(desc_btf, &args[i], reg,
> > +                                                                   "rdonly_buf_size"))
> > +                                             reg_ro_size = regs[regno].var_off.value;
> > +                                     else if (btf_is_kfunc_arg_mem_size(desc_btf, &args[i], reg,
> > +                                                                        "rdwr_buf_size"))
> > +                                             reg_rw_size = regs[regno].var_off.value;
> > +                             }
> > +                     }
> > +
> > +                     if (!reg_rw_size && !reg_ro_size) {
> > +                             ptr_type_name = btf_name_by_offset(desc_btf,
> > +                                                                ptr_type->name_off);
> > +                             verbose(env,
> > +                                     "kernel function %s returns pointer type %s %s is not supported\n",
> > +                                     func_name,
> > +                                     btf_type_str(ptr_type),
> > +                                     ptr_type_name);
> > +                             return -EINVAL;
> > +                     }
> > +
> > +                     mark_reg_known_zero(env, regs, BPF_REG_0);
> > +                     regs[BPF_REG_0].type = PTR_TO_MEM;
> > +                     regs[BPF_REG_0].mem_size = reg_ro_size + reg_rw_size;
> > +
> > +                     if (reg_ro_size)
> > +                             regs[BPF_REG_0].type |= MEM_RDONLY;
> > +             } else {
> > +                     mark_reg_known_zero(env, regs, BPF_REG_0);
> > +                     regs[BPF_REG_0].type = PTR_TO_BTF_ID;
> > +                     regs[BPF_REG_0].btf = desc_btf;
> > +                     regs[BPF_REG_0].btf_id = ptr_type_id;
> > +                     mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
> >               }
> > -             mark_reg_known_zero(env, regs, BPF_REG_0);
> > -             regs[BPF_REG_0].btf = desc_btf;
> > -             regs[BPF_REG_0].type = PTR_TO_BTF_ID;
> > -             regs[BPF_REG_0].btf_id = ptr_type_id;
> > +
> >               if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
> >                                             BTF_KFUNC_TYPE_RET_NULL, func_id)) {
> >                       regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
> >                       /* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
> >                       regs[BPF_REG_0].id = ++env->id_gen;
> >               }
> > -             mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
> > +
>
> Any reason to do this call only for PTR_TO_BTF_ID and not for PTR_TO_MEM?

I must confess I am doing part of the things blindly, and it kind of
worked, passed the tests and I was fine. So no, no reasons except that
maybe at some point it broke what I was trying to do. I'll try to
re-evaluate this line in the next version.

Cheers,
Benjamin

>
> >               if (acq) {
> >                       int id = acquire_reference_state(env, insn_idx);
> >
> > @@ -7312,8 +7349,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               }
> >       } /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
> >
> > -     nargs = btf_type_vlen(func_proto);
> > -     args = (const struct btf_param *)(func_proto + 1);
> > +     for (i = 1 ; i < CALLER_SAVED_REGS; i++)
> > +             mark_reg_not_init(env, regs, caller_saved[i]);
> > +
> >       for (i = 0; i < nargs; i++) {
> >               u32 regno = i + 1;
> >
> > --
> > 2.36.1
> >
>
> --
> Kartikeya
>

