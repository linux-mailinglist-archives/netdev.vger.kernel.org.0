Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D273341087
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 23:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhCRWyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 18:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhCRWxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 18:53:50 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18D6C06174A;
        Thu, 18 Mar 2021 15:53:49 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l14so3726512ybe.2;
        Thu, 18 Mar 2021 15:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=anRum5mOt5i2VLc6m203uyVxxtKSdeNIEcBgmDlniVQ=;
        b=RQlV2ieHQo1Y5Ck7/52sQifTXlw9uj22m312+iXhKuOcbVSxFGXujrlKslQzhrtp/K
         4DWSG8k3nT6LzTPn10Q5ggO6pQ9f+TUaOV32UEI23WHlNYiEqr/phq67YzFqwjJ1KKBe
         hFRWUVZsoBv4K/sJzSJJzJ/qluWNJCZRgGKa3gHqdc1BXxiSoeMJec4fw1/EZvc+aAgC
         1n+rUj7/GclrFxNb6u4zfLZCX4nN7C4Y/7Pl3vb5MGzMXTpdAjCJfkJF/xARYjW/HMpd
         bA6FOPl7NfvAvTmVMnUDIokOF2Ts+1X4QslxkK4JcH7iNTVuvXuHm/9pVgKjhjOJYT6+
         ZbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=anRum5mOt5i2VLc6m203uyVxxtKSdeNIEcBgmDlniVQ=;
        b=IyTrPNZmj9bDm1QJzB8Vo7IzwtaiDpNsQZCln2oSWkFnAeNff2jda1eSVhoVamDoAm
         gxX8xBV2BHtpFpKh6eOhp1CKmj1orzJejldAQK9pPv3BKNizsQic6trYOWsCtmga/xM1
         pbEqfM2PUW4Ultk6wQ/I2yZIvmfnTkz7w0i+iZc9WqpKo2Op7VaLgNjwWVim7FRAWmlK
         VIU0dw1qC10xnc01MUqwz4vvx7kPxskVe+GcrV9uiI6khH3QXRvvU2x9gUuky2X1wxOx
         Sp+sqsgXdM1rrTWNyfnG8ssPCfAM2n4BaWEb5Sj08L2WJ5JJ7TIndI4UQq4ZDydDkTRt
         Ukig==
X-Gm-Message-State: AOAM531SCvvt5LOKY8y7dwRp44d4+hk1AD6IjjC6qEnOybVPZ0Y+f/lQ
        oCOl4OWYeiF2Divs0O9HRzpA5HewobPUew1Rv4U=
X-Google-Smtp-Source: ABdhPJyOxYYdyjPyXsvQzu+dA9zE3mCR+nDJSeR4lstPfZvI55OYKqkvk6BYalKKGrISUvGGctfV1+GYCm9YhneYM/E=
X-Received: by 2002:a25:9942:: with SMTP id n2mr2292895ybo.230.1616108029085;
 Thu, 18 Mar 2021 15:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011348.4175708-1-kafai@fb.com>
In-Reply-To: <20210316011348.4175708-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 15:53:38 -0700
Message-ID: <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch makes BTF verifier to accept extern func. It is used for
> allowing bpf program to call a limited set of kernel functions
> in a later patch.
>
> When writing bpf prog, the extern kernel function needs
> to be declared under a ELF section (".ksyms") which is
> the same as the current extern kernel variables and that should
> keep its usage consistent without requiring to remember another
> section name.
>
> For example, in a bpf_prog.c:
>
> extern int foo(struct sock *) __attribute__((section(".ksyms")))
>
> [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
>         '(anon)' type_id=18
> [25] FUNC 'foo' type_id=24 linkage=extern
> [ ... ]
> [33] DATASEC '.ksyms' size=0 vlen=1
>         type_id=25 offset=0 size=0
>
> LLVM will put the "func" type into the BTF datasec ".ksyms".
> The current "btf_datasec_check_meta()" assumes everything under
> it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> The non-zero size check is not true for "func".  This patch postpones the
> "!vsi-size" test from "btf_datasec_check_meta()" to
> "btf_datasec_resolve()" which has all types collected to decide
> if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> differently.
>
> If the datasec only has "func", its "t->size" could be zero.
> Thus, the current "!t->size" test is no longer valid.  The
> invalid "t->size" will still be caught by the later
> "last_vsi_end_off > t->size" check.   This patch also takes this
> chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> "vsi->size > t->size", and "t->size < sum") into the existing
> "last_vsi_end_off > t->size" test.
>
> The LLVM will also put those extern kernel function as an extern
> linkage func in the BTF:
>
> [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
>         '(anon)' type_id=18
> [25] FUNC 'foo' type_id=24 linkage=extern
>
> This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> Also extern kernel function declaration does not
> necessary have arg name. Another change in btf_func_check() is
> to allow extern function having no arg name.
>
> The btf selftest is adjusted accordingly.  New tests are also added.
>
> The required LLVM patch: https://reviews.llvm.org/D93563
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

High-level question about EXTERN functions in DATASEC. Does kernel
need to see them under DATASEC? What if libbpf just removed all EXTERN
funcs from under DATASEC and leave them as "free-floating" EXTERN
FUNCs in BTF.

We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
it's .kconfig or .ksym or other type of externs. Does kernel need to
care?

>  kernel/bpf/btf.c                             |  52 ++++---
>  tools/testing/selftests/bpf/prog_tests/btf.c | 154 ++++++++++++++++++-
>  2 files changed, 178 insertions(+), 28 deletions(-)
>

[...]

> @@ -3611,9 +3594,28 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
>                 u32 var_type_id = vsi->type, type_id, type_size = 0;
>                 const struct btf_type *var_type = btf_type_by_id(env->btf,
>                                                                  var_type_id);
> -               if (!var_type || !btf_type_is_var(var_type)) {
> +               if (!var_type) {
> +                       btf_verifier_log_vsi(env, v->t, vsi,
> +                                            "type not found");
> +                       return -EINVAL;
> +               }
> +
> +               if (btf_type_is_func(var_type)) {
> +                       if (vsi->size || vsi->offset) {
> +                               btf_verifier_log_vsi(env, v->t, vsi,
> +                                                    "Invalid size/offset");
> +                               return -EINVAL;
> +                       }
> +                       continue;
> +               } else if (btf_type_is_var(var_type)) {
> +                       if (!vsi->size) {
> +                               btf_verifier_log_vsi(env, v->t, vsi,
> +                                                    "Invalid size");
> +                               return -EINVAL;
> +                       }
> +               } else {
>                         btf_verifier_log_vsi(env, v->t, vsi,
> -                                            "Not a VAR kind member");
> +                                            "Neither a VAR nor a FUNC");
>                         return -EINVAL;

can you please structure it as follow (I think it is bit easier to
follow the logic then):

if (btf_type_is_func()) {
   ...
   continue; /* no extra checks */
}

if (!btf_type_is_var()) {
   /* bad, complain, exit */
   return -EINVAL;
}

/* now we deal with extra checks for variables */

That way variable checks are kept all in one place.

Also a question: is that ok to enable non-extern functions under
DATASEC? Maybe, but that wasn't explicitly mentioned.

>                 }
>
> @@ -3849,9 +3851,11 @@ static int btf_func_check(struct btf_verifier_env *env,
>         const struct btf_param *args;
>         const struct btf *btf;
>         u16 nr_args, i;
> +       bool is_extern;
>
>         btf = env->btf;
>         proto_type = btf_type_by_id(btf, t->type);
> +       is_extern = btf_type_vlen(t) == BTF_FUNC_EXTERN;

using btf_type_vlen(t) for getting func linkage is becoming more and
more confusing. Would it be terrible to have btf_func_linkage(t)
helper instead?

>
>         if (!proto_type || !btf_type_is_func_proto(proto_type)) {
>                 btf_verifier_log_type(env, t, "Invalid type_id");
> @@ -3861,7 +3865,7 @@ static int btf_func_check(struct btf_verifier_env *env,
>         args = (const struct btf_param *)(proto_type + 1);
>         nr_args = btf_type_vlen(proto_type);
>         for (i = 0; i < nr_args; i++) {
> -               if (!args[i].name_off && args[i].type) {
> +               if (!is_extern && !args[i].name_off && args[i].type) {
>                         btf_verifier_log_type(env, t, "Invalid arg#%u", i + 1);
>                         return -EINVAL;
>                 }

[...]
