Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DE65AF6C6
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiIFV1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiIFV1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A9DB532F;
        Tue,  6 Sep 2022 14:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3855DB81A66;
        Tue,  6 Sep 2022 21:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE84DC43470;
        Tue,  6 Sep 2022 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662499650;
        bh=NZMrwcSzGA4znMiz2FVtpIwnQwSI8uTD1oMOBAoSvLY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kxeVJ5gy6n3/gd9y7kI0R04jXlNnNekbo9u76M/yXGDdI/PFNZpB86MOZD8jkea6k
         3vXz7ZKfr22YLX2d7BvmJhC0JhCzvAdowkYdcCc8oPp8TrwDLZep7fJ/bJYGAj7rjE
         N9oGool4wSAsDG8Uh2L3oF+t38uc/ffdS8uB5dw3ZcOOlNGTqhd7OeUkMFDXeT92f4
         tSj3rjzIBpnfXB2ih35MqlR7Su8SdpSvrgzHjhWNF9YfgoiPwQs+UtfrnI7YfWhAdF
         I5UqKDkG7n08feIZVy53LenDwK0IZ9co5UDASXqWTO2RkJWk1lOsoNs1/79gjuJRjO
         Re1+73hHp9Xmg==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-11ee4649dfcso31493904fac.1;
        Tue, 06 Sep 2022 14:27:30 -0700 (PDT)
X-Gm-Message-State: ACgBeo1Jm/1ZkTjvjczD3D0kWGCoOOKGC9P0+AUKTmgH5PX/DtCEcprc
        f/Ya0nm6K0q939E/3nXjdXvCr4VpmBMtY4WDwms=
X-Google-Smtp-Source: AA6agR74NAhAZh7IzqNaTsoV3GzaWjEzpeP384dQW+qhbb74QfKR2GH/MEDeiKMlzDLKdnS48xOdgScQwq7/xPtUlwY=
X-Received: by 2002:a05:6808:195:b0:342:ed58:52b5 with SMTP id
 w21-20020a056808019500b00342ed5852b5mr185298oic.22.1662499649983; Tue, 06 Sep
 2022 14:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <dfb859a6b76a9234baa194e795ae89cb7ca5694b.1662383493.git.lorenzo@kernel.org>
In-Reply-To: <dfb859a6b76a9234baa194e795ae89cb7ca5694b.1662383493.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 14:27:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5vx+JVBwpmU=fM0PerC_s_v=BfOj0-80W=p6YYbPem_A@mail.gmail.com>
Message-ID: <CAPhsuW5vx+JVBwpmU=fM0PerC_s_v=BfOj0-80W=p6YYbPem_A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: Add support for per-parameter
 trusted args
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 6:15 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Similar to how we detect mem, size pairs in kfunc, teach verifier to
> treat __ref suffix on argument name to imply that it must be a trusted
> arg when passed to kfunc, similar to the effect of KF_TRUSTED_ARGS flag
> but limited to the specific parameter. This is required to ensure that
> kfunc that operate on some object only work on acquired pointers and not
> normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> walking. Release functions need not specify such suffix on release
> arguments as they are already expected to receive one referenced
> argument.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

LGTM:

Acked-by: Song Liu <song@kernel.org>

PS: IIUC, we use "refcounted" and "trusted" for the same concept. Shall we
just use __trusted? Pardon me if this has been discussed before.

Thanks,
Song

> ---
>  Documentation/bpf/kfuncs.rst | 18 +++++++++++++++++
>  kernel/bpf/btf.c             | 39 ++++++++++++++++++++++++------------
>  net/bpf/test_run.c           |  9 +++++++--
>  3 files changed, 51 insertions(+), 15 deletions(-)
>
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 781731749e55..a9d77d12fd0c 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -72,6 +72,24 @@ argument as its size. By default, without __sz annotation, the size of the type
>  of the pointer is used. Without __sz annotation, a kfunc cannot accept a void
>  pointer.
>
> +2.2.2 __ref Annotation
> +----------------------
> +
> +This annotation is used to indicate that the argument is trusted, i.e. it will
> +be a pointer from an acquire function (defined later), and its offset will be
> +zero. This annotation has the same effect as the KF_TRUSTED_ARGS kfunc flag but
> +only on the parameter it is applied to. An example is shown below::
> +
> +        void bpf_task_send_signal(struct task_struct *task__ref, int signal)
> +        {
> +        ...
> +        }
> +
> +Here, bpf_task_send_signal will only act on trusted task_struct pointers, and
> +cannot be used on pointers obtained using pointer walking. This ensures that
> +caller always calls this kfunc on a task whose lifetime is guaranteed for the
> +duration of the call.
> +
>  .. _BPF_kfunc_nodef:
>
>  2.3 Using an existing kernel function
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 903719b89238..7e273f949ee8 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6140,18 +6140,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
>         return true;
>  }
>
> -static bool is_kfunc_arg_mem_size(const struct btf *btf,
> -                                 const struct btf_param *arg,
> -                                 const struct bpf_reg_state *reg)
> +static bool btf_param_match_suffix(const struct btf *btf,
> +                                  const struct btf_param *arg,
> +                                  const char *suffix)
>  {
> -       int len, sfx_len = sizeof("__sz") - 1;
> -       const struct btf_type *t;
> +       int len, sfx_len = strlen(suffix);
>         const char *param_name;
>
> -       t = btf_type_skip_modifiers(btf, arg->type, NULL);
> -       if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> -               return false;
> -
>         /* In the future, this can be ported to use BTF tagging */
>         param_name = btf_name_by_offset(btf, arg->name_off);
>         if (str_is_empty(param_name))
> @@ -6160,10 +6155,26 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
>         if (len < sfx_len)
>                 return false;
>         param_name += len - sfx_len;
> -       if (strncmp(param_name, "__sz", sfx_len))
> +       return !strncmp(param_name, suffix, sfx_len);
> +}
> +
> +static bool is_kfunc_arg_ref(const struct btf *btf,
> +                            const struct btf_param *arg)
> +{
> +       return btf_param_match_suffix(btf, arg, "__ref");
> +}
> +
> +static bool is_kfunc_arg_mem_size(const struct btf *btf,
> +                                 const struct btf_param *arg,
> +                                 const struct bpf_reg_state *reg)
> +{
> +       const struct btf_type *t;
> +
> +       t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +       if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
>                 return false;
>
> -       return true;
> +       return btf_param_match_suffix(btf, arg, "__sz");
>  }
>
>  static int btf_check_func_arg_match(struct bpf_verifier_env *env,
> @@ -6173,7 +6184,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                                     u32 kfunc_flags)
>  {
>         enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
> -       bool rel = false, kptr_get = false, trusted_arg = false;
> +       bool rel = false, kptr_get = false, kf_trusted_args = false;
>         bool sleepable = false;
>         struct bpf_verifier_log *log = &env->log;
>         u32 i, nargs, ref_id, ref_obj_id = 0;
> @@ -6211,7 +6222,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                 /* Only kfunc can be release func */
>                 rel = kfunc_flags & KF_RELEASE;
>                 kptr_get = kfunc_flags & KF_KPTR_GET;
> -               trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
> +               kf_trusted_args = kfunc_flags & KF_TRUSTED_ARGS;
>                 sleepable = kfunc_flags & KF_SLEEPABLE;
>         }
>
> @@ -6222,6 +6233,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                 enum bpf_arg_type arg_type = ARG_DONTCARE;
>                 u32 regno = i + 1;
>                 struct bpf_reg_state *reg = &regs[regno];
> +               bool trusted_arg = false;
>
>                 t = btf_type_skip_modifiers(btf, args[i].type, NULL);
>                 if (btf_type_is_scalar(t)) {
> @@ -6240,6 +6252,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                 /* Check if argument must be a referenced pointer, args + i has
>                  * been verified to be a pointer (after skipping modifiers).
>                  */
> +               trusted_arg = kf_trusted_args || is_kfunc_arg_ref(btf, args + i);
>                 if (is_kfunc && trusted_arg && !reg->ref_obj_id) {
>                         bpf_log(log, "R%d must be referenced\n", regno);
>                         return -EINVAL;
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 25d8ecf105aa..b735accf8750 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -691,7 +691,11 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
>  {
>  }
>
> -noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
> +noinline void bpf_kfunc_call_test_trusted(struct prog_test_ref_kfunc *p)
> +{
> +}
> +
> +noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p__ref)
>  {
>  }
>
> @@ -722,7 +726,8 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
> -BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_kfunc_call_test_trusted, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
>  BTF_SET8_END(test_sk_check_kfunc_ids)
>
> --
> 2.37.3
>
