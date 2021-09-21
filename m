Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5221413DB1
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhIUWsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhIUWsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:48:50 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76133C061574;
        Tue, 21 Sep 2021 15:47:21 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id 73so2991142qki.4;
        Tue, 21 Sep 2021 15:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icUDq7yFAgoxtClEq9BzJleCGFHjv8CWE//EUmwZv/s=;
        b=mvflz6aAVuoL+oqgbPaTIQE8j+IbwTBTbQZMTejcfiZHxea2sRhOfg3xqsV4BATrTh
         VGlxYTjm0vXSSFMc2qBQtRtB0Ua4CzB4i24DIFgne8FF84Gkk6/aPYfLjDZCusluvrIK
         tQWSq2zF+gECM/Xy0oohpfnE/GCFmWzNsyaxldo276iwdAxUvNF5tPu2HQAz3a1h8oRC
         tN2Vkn70xx5ZUnkhVoq8zZPzAVNvNTNMbQfeyuz3UW5swpkB6EvLQ+9haG3BhL1HuvY0
         G3t/Vgw1HxdQfwYsvBgUWYMODV0oiA9+W8WIvVfLFX/w54h55IPW6UHQTsR/18NT/Epk
         lE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icUDq7yFAgoxtClEq9BzJleCGFHjv8CWE//EUmwZv/s=;
        b=m8+ADhMHj7tN2yMZzM/lEQHuawtTteCp8LuO3bvWODTgpt/veCqg6GYy5zjYlUkN/b
         b9Kqj9bBoMH5mmljALqb5LZjX9spX7lLdi8+VgrCiqXXGesPI9L4w+vLhqldlM3PkcwU
         CG4iqP3UtZylP+K3D8VU45sG9MjmxZM5OMEIrgzST/gR420rJ9m3qAo5RSuUJRD0g/mB
         HbiJj3uJ9NnvgrF1UqtC+ZHqa1aCLR07PT1ed/t1tWmAzohva2IP2ZbXF0tE5k1vR8rr
         pIFS/K6emxY2A+pp42fXHz7gB26GjCSFISXPp75ZUMPdijI4rb5/GpKhnW2xWtmcpDm4
         7V/w==
X-Gm-Message-State: AOAM533cDQcjetOLjA1JsJftXVJXx5olbxzNUYYRsi5jP8GFEtYZP1kt
        C248nK1R4Lk9cPBXMmdA3syMxKr6vHUyuBcr6Xk=
X-Google-Smtp-Source: ABdhPJx+ZK8jWMoDMASIKZHi+32yylyHwYm0WLrfp7lCXA2CyIsMIG3EjB2HkdSr+jz/aGamJ1/Kv4iBB/QRLYF8kNM=
X-Received: by 2002:a25:1bc5:: with SMTP id b188mr40821289ybb.267.1632264440592;
 Tue, 21 Sep 2021 15:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-8-memxor@gmail.com>
In-Reply-To: <20210920141526.3940002-8-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 15:47:09 -0700
Message-ID: <CAEf4BzbQ47A9KNbKG6CEXuiubnHL+hsjqk=pD6J1j7_yL=hPbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 07/11] libbpf: Resolve invalid weak kfunc
 calls with imm = 0, off = 0
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Preserve these calls as it allows verifier to succeed in loading the
> program if they are determined to be unreachable after dead code
> elimination during program load. If not, the verifier will fail at
> runtime. This is done for ext->is_weak symbols similar to the case for
> variable ksyms.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

Looks good with few nits below

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3049dfc6088e..3c195eaadf56 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3413,11 +3413,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>                                 return -ENOTSUP;
>                         }
>                 } else if (strcmp(sec_name, KSYMS_SEC) == 0) {
> -                       if (btf_is_func(t) && ext->is_weak) {
> -                               pr_warn("extern weak function %s is unsupported\n",
> -                                       ext->name);
> -                               return -ENOTSUP;
> -                       }
>                         ksym_sec = sec;
>                         ext->type = EXT_KSYM;
>                         skip_mods_and_typedefs(obj->btf, t->type,
> @@ -5366,8 +5361,12 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                 case RELO_EXTERN_FUNC:
>                         ext = &obj->externs[relo->sym_off];
>                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
> -                       insn[0].imm = ext->ksym.kernel_btf_id;
> -                       insn[0].off = ext->ksym.offset;
> +                       if (ext->is_set) {
> +                               insn[0].imm = ext->ksym.kernel_btf_id;
> +                               insn[0].off = ext->ksym.offset;
> +                       } else { /* unresolved weak kfunc */
> +                               insn[0].imm = insn[0].off = 0;

it's a bit too easy to miss this, please write as two separate statements

> +                       }
>                         break;
>                 case RELO_SUBPROG_ADDR:
>                         if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
> @@ -6768,8 +6767,10 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
>
>         kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
>                                     &kern_btf, &kern_btf_fd);
> -       if (kfunc_id < 0) {
> -               pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
> +       if (kfunc_id == -ESRCH && ext->is_weak) {
> +               return 0;
> +       } else if (kfunc_id < 0) {

nit: there is return above, no need for "else if", please drop that
part. It would be nice if you could clean this up in
bpf_object__resolve_ksym_var_btf_id() as well. Thanks!

> +               pr_warn("extern (func ksym) '%s': not found in kernel or module BTFs\n",
>                         ext->name);
>                 return kfunc_id;
>         }
> --
> 2.33.0
>
