Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB43257859B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiGROgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbiGROga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:36:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 510B81183F
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658154988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rFQMscdcwUkaTGb2PKaBiEdNVFGKZ4TJiBENKOnBRwk=;
        b=aNeRvGo34Pr6uxgRcdw1yr3cFO3FGyIRdpH99AgztO4sNnVFO7HOnMH2wIxpzyxfg5z32y
        ohzcGNcjApEhur7Nj3Rk0b4TkXIpvYWh8AHoh/uzGZ9Jt4po/gTp39GLnbyDyJ3iw/Zxg6
        977Gujz8ZknQBBXTwixb9kJdMbNAQlc=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-aG1uS1IdOxqSAdv9ir_WUw-1; Mon, 18 Jul 2022 10:36:16 -0400
X-MC-Unique: aG1uS1IdOxqSAdv9ir_WUw-1
Received: by mail-pl1-f197.google.com with SMTP id d13-20020a170903230d00b0016c1efef9ecso6818537plh.6
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rFQMscdcwUkaTGb2PKaBiEdNVFGKZ4TJiBENKOnBRwk=;
        b=jRQ6Wi6EXcfs4vFCGk/AjM7tABxGvXZtXhyFvmB8jBLYxercEdQwJR54Kna4+sMSfo
         itagGTlt4AmQOKruZQNmo3HuXEfZHuH8Y0Rwc1lgfAVyB4fMbTHwI4Qydh1PnrMHu4bS
         Y5MCVpU+Er6x8VHxfadMUFDbu2vetMJ97xmIzcMRQ3g7BFp8WNKkXTuxTCnHOWbvsZsY
         YHr6GBXdc6tj9cwfCb+82hGNnP5RV7hX44zQkVBFE4VNq6DeMPW6wpUcMTNBy4WJN45j
         aSx80Wvt8cfBjYtMh2F3E1/3y8vUVt8hSP1ZCyVe3BFVnZWf+ugBbC3a+DfvxCLKAnQm
         XDRw==
X-Gm-Message-State: AJIora/BLTnX4LGv5NDQxxJbu1YhBqTLGbnmoLV25BOGrzcGvzZn0D/E
        lYs77ivB75Kgc0vEBhhmYEaciYcncbRAfFBuqSfFskgwXK9Vam9bRZ78jfaQhDryZjaNnUPlxn5
        y31Tiew9IWRfyIYIe6LHvBQdIc54omxYL
X-Received: by 2002:a17:90b:4a08:b0:1ef:f36b:18e1 with SMTP id kk8-20020a17090b4a0800b001eff36b18e1mr39392475pjb.246.1658154975485;
        Mon, 18 Jul 2022 07:36:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uGK9T6cOVFp659SW1DdrZP3gQ+n6vI6T88el9GhA+lj4mOmIFGxU6jOUkfisaABLvRHaU8Fp6cYg+cPkG0fuk=
X-Received: by 2002:a17:90b:4a08:b0:1ef:f36b:18e1 with SMTP id
 kk8-20020a17090b4a0800b001eff36b18e1mr39392441pjb.246.1658154975155; Mon, 18
 Jul 2022 07:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-6-benjamin.tissoires@redhat.com> <7fc49373-55df-c7fd-4a73-c2cf8a62748d@fb.com>
In-Reply-To: <7fc49373-55df-c7fd-4a73-c2cf8a62748d@fb.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 18 Jul 2022 16:36:03 +0200
Message-ID: <CAO-hwJKwX2LW8wuFzQbWm-ttwqocNBc-evgpn2An-D-92osw0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 05/23] bpf/verifier: allow kfunc to return an
 allocated mem
To:     Yonghong Song <yhs@fb.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
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

On Sat, Jul 16, 2022 at 6:29 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> > When a kfunc is not returning a pointer to a struct but to a plain type,
> > we can consider it is a valid allocated memory assuming that:
> > - one of the arguments is either called rdonly_buf_size or
> >    rdwr_buf_size
> > - and this argument is a const from the caller point of view
> >
> > We can then use this parameter as the size of the allocated memory.
> >
> > The memory is either read-only or read-write based on the name
> > of the size parameter.
>
> If I understand correctly, this permits a kfunc like
>     int *kfunc(..., int rdonly_buf_size);
>     ...
>     int *p = kfunc(..., 20);
> so the 'p' points to a memory buffer with size 20.

Yes, exactly.

>
> This looks like a strange interface although probably there
> is a valid reason for this as I didn't participated in
> earlier discussions.

Well, the point is I need to be able to access a memory region that
was allocated dynamically. For drivers, the incoming data can not
usually be bound to a static value, and so we can not have the data
statically defined in the matching struct.
So this allows defining a kfunc to return any memory properly
allocated and owned by the device.

>
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >
> > changes in v6:
> > - code review from Kartikeya:
> >    - remove comment change that had no reasons to be
> >    - remove handling of PTR_TO_MEM with kfunc releases
> >    - introduce struct bpf_kfunc_arg_meta
> >    - do rdonly/rdwr_buf_size check in btf_check_kfunc_arg_match
> >    - reverted most of the changes in verifier.c
> >    - make sure kfunc acquire is using a struct pointer, not just a plain
> >      pointer
> >    - also forward ref_obj_id to PTR_TO_MEM in kfunc to not use after free
> >      the allocated memory
> >
> > changes in v5:
> > - updated PTR_TO_MEM comment in btf.c to match upstream
> > - make it read-only or read-write based on the name of size
> >
> > new in v4
> > ---
> >   include/linux/bpf.h   | 10 ++++++-
> >   include/linux/btf.h   | 12 ++++++++
> >   kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
> >   kernel/bpf/verifier.c | 49 +++++++++++++++++++++++--------
> >   4 files changed, 121 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 2b21f2a3452f..5b8eadb6e7bc 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1916,12 +1916,20 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
> >                          const char *func_name,
> >                          struct btf_func_model *m);
> >
> > +struct bpf_kfunc_arg_meta {
> > +     u64 r0_size;
> > +     bool r0_rdonly;
> > +     int ref_obj_id;
> > +     bool multiple_ref_obj_id;
> > +};
> > +
> >   struct bpf_reg_state;
> >   int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >                               struct bpf_reg_state *regs);
> >   int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
> >                             const struct btf *btf, u32 func_id,
> > -                           struct bpf_reg_state *regs);
> > +                           struct bpf_reg_state *regs,
> > +                           struct bpf_kfunc_arg_meta *meta);
> >   int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
> >                         struct bpf_reg_state *reg);
> >   int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index 1bfed7fa0428..31da4273c2ec 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -420,4 +420,16 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
> >   }
> >   #endif
> >
> > +static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
> > +{
> > +     /* t comes in already as a pointer */
> > +     t = btf_type_by_id(btf, t->type);
> > +
> > +     /* allow const */
> > +     if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
> > +             t = btf_type_by_id(btf, t->type);
> > +
> > +     return btf_type_is_struct(t);
> > +}
> > +
> >   #endif
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 4423045b8ff3..552d7bc05a0c 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6168,10 +6168,36 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
> >       return true;
> >   }
> >
> > +static bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
> > +                                   const struct btf_param *arg,
> > +                                   const struct bpf_reg_state *reg,
> > +                                   const char *name)
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
>
> strcmp(param_name, name) is enough. len == target_len and both len and
> target_len is computed from strlen(...).

Ack, fixed locally

>
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> >   static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >                                   const struct btf *btf, u32 func_id,
> >                                   struct bpf_reg_state *regs,
> > -                                 bool ptr_to_mem_ok)
> > +                                 bool ptr_to_mem_ok,
> > +                                 struct bpf_kfunc_arg_meta *kfunc_meta)
> >   {
> >       enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
> >       struct bpf_verifier_log *log = &env->log;
> > @@ -6225,6 +6251,30 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >
> >               t = btf_type_skip_modifiers(btf, args[i].type, NULL);
> >               if (btf_type_is_scalar(t)) {
> > +                     if (is_kfunc && kfunc_meta) {
> > +                             bool is_buf_size = false;
> > +
> > +                             /* check for any const scalar parameter of name "rdonly_buf_size"
> > +                              * or "rdwr_buf_size"
> > +                              */
> > +                             if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> > +                                                           "rdonly_buf_size")) {
> > +                                     kfunc_meta->r0_rdonly = true;
> > +                                     is_buf_size = true;
> > +                             } else if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> > +                                                                  "rdwr_buf_size"))
> > +                                     is_buf_size = true;
> > +
> > +                             if (is_buf_size) {
> > +                                     if (kfunc_meta->r0_size) {
> > +                                             bpf_log(log, "2 or more rdonly/rdwr_buf_size parameters for kfunc");
> > +                                             return -EINVAL;
> > +                                     }
> > +
> > +                                     kfunc_meta->r0_size = reg->var_off.value;
>
> Did we check 'reg' is a constant somewhere?

I used to check for it in the previous version, but I think it got
dropped in this revision. Re-adding this thanks to Kumar's help :)

Cheers,
Benjamin

>
> > +                             }
> > +                     }
> > +
> >                       if (reg->type == SCALAR_VALUE)
> >                               continue;
> >                       bpf_log(log, "R%d is not a scalar\n", regno);
> > @@ -6246,6 +6296,14 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> >               if (ret < 0)
> >                       return ret;
> >
> > +             /* kptr_get is only valid for kfunc */
> > +             if (kfunc_meta && reg->ref_obj_id) {
> > +                     /* check for any one ref_obj_id to keep track of memory */
> > +                     if (kfunc_meta->ref_obj_id)
> > +                             kfunc_meta->multiple_ref_obj_id = true;
> > +                     kfunc_meta->ref_obj_id = reg->ref_obj_id;
> > +             }
> > +
> >               /* kptr_get is only true for kfunc */
> >               if (i == 0 && kptr_get) {
> >                       struct bpf_map_value_off_desc *off_desc;
> > @@ -6441,7 +6499,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >               return -EINVAL;
> >
> >       is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > -     err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
> > +     err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
> >
> >       /* Compiler optimizations can remove arguments from static functions
> >        * or mismatched type can be passed into a global function.
> [...]
>

