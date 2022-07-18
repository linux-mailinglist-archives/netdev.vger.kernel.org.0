Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7A578662
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbiGRP2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbiGRP2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:28:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B16F42983B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658158107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uJIggZCNpgwvaFQynG/gLraji0AFGkTGy1p5k+g0Igg=;
        b=F3uBGlq5yOq1PR+Tu0K1jEIXrOmhncSJV/wGbQDiaa0AUQ3bbJFCrY7vgYCCHuMF9EeQR1
        VSrrUU3KJuAE+TgZi4tJBfiSK6ymTrNxhFBHHRznpHTS7NdlhYt8ytDzmcTILfUTzJXhgP
        reLvYt7cAFMTPRFr/g7/8TRzD6hKXy8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-nkBXf4-yPJuQpKI0cMDrtQ-1; Mon, 18 Jul 2022 11:28:20 -0400
X-MC-Unique: nkBXf4-yPJuQpKI0cMDrtQ-1
Received: by mail-pg1-f200.google.com with SMTP id x71-20020a63314a000000b00419699fc9afso5745029pgx.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJIggZCNpgwvaFQynG/gLraji0AFGkTGy1p5k+g0Igg=;
        b=MOGC/Ubii7eY0Se2eavddXOzMLMZKTCsabF4ScU6GhH8IJ300MYcuf9j+3HsoCDcDu
         IvwiaIgU1vaPF2qVoiYg3Rg6NAPQqCVewCMro9obq2B8ohEhNcDOSmWZpj/EMci0zDcL
         /gYIktyi0CrZQRscfKGNPZFU2yB3FbdoOfLPiZw+x7MlqAvkN74WofqqoJHekj3KxC6j
         BT1QwguA4tLd6pfcs7dkT5+2dbpmShpZeprx8xQl80y2fuvIW+Y7ckBPJcb4gDPtDnL8
         5K7lrhYkyJQQ+D5IKsrxcfaFWx6R9xNlqGkXEOcKfadvcNXzvxEwACJQOqe+ejfUH7Sw
         SZeg==
X-Gm-Message-State: AJIora+BnQ7rKon8jl76ePGPUOantcACT82QE/D4P7SgOtI99C1r/497
        TBDjfSSXo8Wyt3lH+KxOv4t52qM8P73v7mCL2BaIRLXk8QfvEYNoDiBzo8yXOqftZUkt/fqAall
        9Po++EbL+8plDW/O17G7FFP/kMz62p3vX
X-Received: by 2002:a17:90a:be0c:b0:1ef:accb:23a5 with SMTP id a12-20020a17090abe0c00b001efaccb23a5mr32798450pjs.113.1658158099101;
        Mon, 18 Jul 2022 08:28:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s+Ciz742ji5v49qH2+CaRtPsbm4puQ49n/bD7wRBglNUoM2l/vpF6LbwM0y/LI3T+C+zgJdk/B++iZfksG+MQ=
X-Received: by 2002:a17:90a:be0c:b0:1ef:accb:23a5 with SMTP id
 a12-20020a17090abe0c00b001efaccb23a5mr32798384pjs.113.1658158098672; Mon, 18
 Jul 2022 08:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-6-benjamin.tissoires@redhat.com> <CAP01T77nCee6R9DL_gHJCrkVgcoJH9n52McKA87KqE3Ud8qwTg@mail.gmail.com>
In-Reply-To: <CAP01T77nCee6R9DL_gHJCrkVgcoJH9n52McKA87KqE3Ud8qwTg@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 18 Jul 2022 17:28:07 +0200
Message-ID: <CAO-hwJ+OvU_cn9zUY_4VuhZVLB566DpYmvr2TT+WmgChnfb7+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 05/23] bpf/verifier: allow kfunc to return an
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 10:33 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, 12 Jul 2022 at 17:03, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > When a kfunc is not returning a pointer to a struct but to a plain type,
> > we can consider it is a valid allocated memory assuming that:
> > - one of the arguments is either called rdonly_buf_size or
> >   rdwr_buf_size
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
> > changes in v6:
> > - code review from Kartikeya:
> >   - remove comment change that had no reasons to be
> >   - remove handling of PTR_TO_MEM with kfunc releases
> >   - introduce struct bpf_kfunc_arg_meta
> >   - do rdonly/rdwr_buf_size check in btf_check_kfunc_arg_match
> >   - reverted most of the changes in verifier.c
> >   - make sure kfunc acquire is using a struct pointer, not just a plain
> >     pointer
> >   - also forward ref_obj_id to PTR_TO_MEM in kfunc to not use after free
> >     the allocated memory
> >
> > changes in v5:
> > - updated PTR_TO_MEM comment in btf.c to match upstream
> > - make it read-only or read-write based on the name of size
> >
> > new in v4
> > ---
> >  include/linux/bpf.h   | 10 ++++++-
> >  include/linux/btf.h   | 12 ++++++++
> >  kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
> >  kernel/bpf/verifier.c | 49 +++++++++++++++++++++++--------
> >  4 files changed, 121 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 2b21f2a3452f..5b8eadb6e7bc 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1916,12 +1916,20 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
> >                            const char *func_name,
> >                            struct btf_func_model *m);
> >
> > +struct bpf_kfunc_arg_meta {
> > +       u64 r0_size;
> > +       bool r0_rdonly;
> > +       int ref_obj_id;
> > +       bool multiple_ref_obj_id;
> > +};
> > +
> >  struct bpf_reg_state;
> >  int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >                                 struct bpf_reg_state *regs);
> >  int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
> >                               const struct btf *btf, u32 func_id,
> > -                             struct bpf_reg_state *regs);
> > +                             struct bpf_reg_state *regs,
> > +                             struct bpf_kfunc_arg_meta *meta);
> >  int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
> >                           struct bpf_reg_state *reg);
> >  int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 1bfed7fa0428..31da4273c2ec 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -420,4 +420,16 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
> >  }
> >  #endif
> >
> > +static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
> > +{
> > +       /* t comes in already as a pointer */
> > +       t = btf_type_by_id(btf, t->type);
> > +
> > +       /* allow const */
> > +       if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
> > +               t = btf_type_by_id(btf, t->type);
>
> Any specific reason to not allow any other modifiers apart from const?
> volatile, restrict, typedef..?
> If not, just use btf_type_skip_modifiers instead.

Good point. Fixed locally

>
> > +
> > +       return btf_type_is_struct(t);
> > +}
> > +
> >  #endif
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 4423045b8ff3..552d7bc05a0c 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6168,10 +6168,36 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
> >         return true;
> >  }
> >
> > +static bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
> > +                                     const struct btf_param *arg,
> > +                                     const struct bpf_reg_state *reg,
> > +                                     const char *name)
>
> It would be nicer if we could reuse some code from
> is_kfunc_arg_mem_size, the only difference is matching suffix vs full
> string. But don't feel too strongly about it.

I'll see what I can do. There is indeed a lot of code duplication, but
I wasn't sure how I could express the differences while making it
obvious.

>
> > +{
> > +       int len, target_len = strlen(name);
> > +       const struct btf_type *t;
> > +       const char *param_name;
> > +
> > +       t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > +       if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> > +               return false;
> > +
> > +       param_name = btf_name_by_offset(btf, arg->name_off);
> > +       if (str_is_empty(param_name))
> > +               return false;
> > +       len = strlen(param_name);
> > +       if (len != target_len)
> > +               return false;
> > +       if (strncmp(param_name, name, target_len))
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> >  static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >                                     const struct btf *btf, u32 func_id,
> >                                     struct bpf_reg_state *regs,
> > -                                   bool ptr_to_mem_ok)
> > +                                   bool ptr_to_mem_ok,
> > +                                   struct bpf_kfunc_arg_meta *kfunc_meta)
> >  {
> >         enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
> >         struct bpf_verifier_log *log = &env->log;
> > @@ -6225,6 +6251,30 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >
> >                 t = btf_type_skip_modifiers(btf, args[i].type, NULL);
> >                 if (btf_type_is_scalar(t)) {
> > +                       if (is_kfunc && kfunc_meta) {
> > +                               bool is_buf_size = false;
> > +
> > +                               /* check for any const scalar parameter of name "rdonly_buf_size"
> > +                                * or "rdwr_buf_size"
> > +                                */
> > +                               if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> > +                                                             "rdonly_buf_size")) {
> > +                                       kfunc_meta->r0_rdonly = true;
> > +                                       is_buf_size = true;
> > +                               } else if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> > +                                                                    "rdwr_buf_size"))
> > +                                       is_buf_size = true;
> > +
> > +                               if (is_buf_size) {
> > +                                       if (kfunc_meta->r0_size) {
> > +                                               bpf_log(log, "2 or more rdonly/rdwr_buf_size parameters for kfunc");
> > +                                               return -EINVAL;
> > +                                       }
> > +
> > +                                       kfunc_meta->r0_size = reg->var_off.value;
>
> As Yonghong pointed out, you need to ensure the register holds a
> constant value, by using tnum_is_const(reg->var_off), and giving an
> error otherwise, because we need a constant size to be set for R0.

Thanks for the hint on how to solve this. It saved me from doing
searches in the archives :)

As mentioned to Yonghong, I had it in a previous version, but the
refactoring dropped it :(

>
> > +                               }
> > +                       }
> > +
> >                         if (reg->type == SCALAR_VALUE)
> >                                 continue;
> >                         bpf_log(log, "R%d is not a scalar\n", regno);
> > @@ -6246,6 +6296,14 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >                 if (ret < 0)
> >                         return ret;
> >
> > +               /* kptr_get is only valid for kfunc */
>
> Invalid comment

oops

>
> > +               if (kfunc_meta && reg->ref_obj_id) {
> > +                       /* check for any one ref_obj_id to keep track of memory */
> > +                       if (kfunc_meta->ref_obj_id)
> > +                               kfunc_meta->multiple_ref_obj_id = true;
>
> Why not just return the error here itself? And then no need to keep
> the multiple_ref_obj_id member.
> When you return the error here, you can move a similar check in the if
> (reg->type == PTR_TO_BTF_ID) block to this place so that we don't do
> it twice.

Good point. I extracted the block from (reg->type == PTR_TO_BTF_ID)
here, and at the end did a small "if (kfunc_meta && ref_obj_id)
kfunc_meta->ref_obj_id = ref_obj_id"

This way this path is done only once for all cases.

Cheers,
Benjamin

>
> > +                       kfunc_meta->ref_obj_id = reg->ref_obj_id;
> > +               }
> > +
> >                 /* kptr_get is only true for kfunc */
> >                 if (i == 0 && kptr_get) {
> >                         struct bpf_map_value_off_desc *off_desc;
> > @@ -6441,7 +6499,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >                 return -EINVAL;
> >
> >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > -       err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
> > +       err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
> >
> >         /* Compiler optimizations can remove arguments from static functions
> >          * or mismatched type can be passed into a global function.
> > @@ -6454,9 +6512,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >
> >  int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
> >                               const struct btf *btf, u32 func_id,
> > -                             struct bpf_reg_state *regs)
> > +                             struct bpf_reg_state *regs,
> > +                             struct bpf_kfunc_arg_meta *meta)
> >  {
> > -       return btf_check_func_arg_match(env, btf, func_id, regs, true);
> > +       return btf_check_func_arg_match(env, btf, func_id, regs, true, meta);
> >  }
> >
> >  /* Convert BTF of a function into bpf_reg_state if possible
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 3adcc0d123af..77556132db15 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7561,6 +7561,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >  {
> >         const struct btf_type *t, *func, *func_proto, *ptr_type;
> >         struct bpf_reg_state *regs = cur_regs(env);
> > +       struct bpf_kfunc_arg_meta meta = { 0 };
> >         const char *func_name, *ptr_type_name;
> >         u32 i, nargs, func_id, ptr_type_id;
> >         int err, insn_idx = *insn_idx_p;
> > @@ -7592,7 +7593,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >                                         BTF_KFUNC_TYPE_ACQUIRE, func_id);
> >
> >         /* Check the arguments */
> > -       err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
> > +       err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, &meta);
> >         if (err < 0)
> >                 return err;
> >         /* In case of release function, we get register number of refcounted
> > @@ -7613,7 +7614,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >         /* Check return type */
> >         t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
> >
> > -       if (acq && !btf_type_is_ptr(t)) {
> > +       if (acq && !btf_type_is_struct_ptr(desc_btf, t)) {
> >                 verbose(env, "acquire kernel function does not return PTR_TO_BTF_ID\n");
> >                 return -EINVAL;
> >         }
> > @@ -7625,17 +7626,41 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >                 ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
> >                                                    &ptr_type_id);
> >                 if (!btf_type_is_struct(ptr_type)) {
> > -                       ptr_type_name = btf_name_by_offset(desc_btf,
> > -                                                          ptr_type->name_off);
> > -                       verbose(env, "kernel function %s returns pointer type %s %s is not supported\n",
> > -                               func_name, btf_type_str(ptr_type),
> > -                               ptr_type_name);
> > -                       return -EINVAL;
> > +                       if (!meta.r0_size) {
> > +                               ptr_type_name = btf_name_by_offset(desc_btf,
> > +                                                                  ptr_type->name_off);
> > +                               verbose(env,
> > +                                       "kernel function %s returns pointer type %s %s is not supported\n",
> > +                                       func_name,
> > +                                       btf_type_str(ptr_type),
> > +                                       ptr_type_name);
> > +                               return -EINVAL;
> > +                       }
> > +
> > +                       if (meta.multiple_ref_obj_id) {
> > +                               verbose(env,
> > +                                       "kernel function %s has multiple memory tracked objects\n",
> > +                                       func_name);
> > +                               return -EINVAL;
> > +                       }
> > +
> > +                       mark_reg_known_zero(env, regs, BPF_REG_0);
> > +                       regs[BPF_REG_0].type = PTR_TO_MEM;
> > +                       regs[BPF_REG_0].mem_size = meta.r0_size;
> > +
> > +                       if (meta.r0_rdonly)
> > +                               regs[BPF_REG_0].type |= MEM_RDONLY;
> > +
> > +                       /* Ensures we don't access the memory after a release_reference() */
> > +                       if (meta.ref_obj_id)
> > +                               regs[BPF_REG_0].ref_obj_id = meta.ref_obj_id;
> > +               } else {
> > +                       mark_reg_known_zero(env, regs, BPF_REG_0);
> > +                       regs[BPF_REG_0].btf = desc_btf;
> > +                       regs[BPF_REG_0].type = PTR_TO_BTF_ID;
> > +                       regs[BPF_REG_0].btf_id = ptr_type_id;
> >                 }
> > -               mark_reg_known_zero(env, regs, BPF_REG_0);
> > -               regs[BPF_REG_0].btf = desc_btf;
> > -               regs[BPF_REG_0].type = PTR_TO_BTF_ID;
> > -               regs[BPF_REG_0].btf_id = ptr_type_id;
> > +
> >                 if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
> >                                               BTF_KFUNC_TYPE_RET_NULL, func_id)) {
> >                         regs[BPF_REG_0].type |= PTR_MAYBE_NULL;
> > --
> > 2.36.1
> >
>

