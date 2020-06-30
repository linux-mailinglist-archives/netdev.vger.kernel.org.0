Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1561220EB1A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgF3Bwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgF3Bwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:52:34 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC17C061755;
        Mon, 29 Jun 2020 18:52:34 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id u8so8587608qvj.12;
        Mon, 29 Jun 2020 18:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zinwh6Q+aU3BsWBVkjp6vwm2ClzpKYtyCEu88ue5mfA=;
        b=WwZjDQ9rOLI/aiwISmGtNBqmv1o0gpCX1LLClNWzCWZbO6XlA31WXKT2lK/s3h18Bi
         mNOWqBbUjaIqGoQtldDqxTFYu66yFSl38+K51MNJFtjeY6UhCFHSauy9opLWiQax8qJ5
         /rv6BxHgfQMvH2Mg3ZptAcHdHvySUSCymTUQp7GLfkUjfmiWAp+5g5nYGj1v0MS+BD1Y
         wrXGJKVmSWs4p2x4s6xOnejm4TJQ9PKPdxBGf5uW37jSFoGaOzw1CuZX9s7mEv7ijuzR
         WOtzP7H/jZkI7+iqIAEbOZ/ZPQPW1kgdwTrHfYcP/hNzbTTivzr+zgQi7qcgFP7JtbVR
         1guA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zinwh6Q+aU3BsWBVkjp6vwm2ClzpKYtyCEu88ue5mfA=;
        b=BCw5p12oCgEVIz3bZ/WCvcElEjTUk+3jv7HhaPw18AoFkgYKiYKdD+SRvfN2/wLNw9
         em/KNg89FX4egsLabnnpVUAIrtPuZ1gPXCqE1z2op3M65eDY/WM84nyuNf1zWfM0yQpT
         Boi6OfLEa3aQoJakcOMNoCAa5D8BacM4nziDAEZdpeymQvg0EOmmHNISVGpy+5/J/mvL
         wAVLw03u3gFUfgq5nRvEwKvB3epFmepVUHXaT17pslNlJyFysZIplfCxNz/7G1ey5usB
         PTKlpxTh6knD9GRgtFy5vq+N3Efw3U5z+ecP01YzJM/mLhZ6igIVpf1kZSZaNXJONjIN
         xHrQ==
X-Gm-Message-State: AOAM532hgDa3Aj/I5hQM2ltaqm6+D+aMk3TzhmQghMiYom6kF2JFfWD4
        tr2ggZVNIxHJ3GOd6OJ+8a3c/G+AN8rkL6LMPyk=
X-Google-Smtp-Source: ABdhPJxyxkZk+naSEKIlFxsL+QxSpwCTsGGe/nN3pBCNSRExo82R9CIe34dLKRKIy0nVbuXgPjnaTeydl+M8fV9x8Cg=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr18478923qvv.163.1593481953350;
 Mon, 29 Jun 2020 18:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-8-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 18:52:21 -0700
Message-ID: <CAEf4Bzb+Oey2pQMJvBpRR6dVqFDeV+OtyQVoCvk-1rmvb6XYPA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/14] bpf: Allow nested BTF object to be
 refferenced by BTF object + offset
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_address function that takes 2 BTF objects
> and offset as arguments and checks whether object A is nested
> in object B on given offset.
>
> This function will be used when checking the helper function
> PTR_TO_BTF_ID arguments. If the argument has an offset value,
> the btf_struct_address will check if the final address is
> the expected BTF ID.
>
> This way we can access nested BTF objects under PTR_TO_BTF_ID
> pointer type and pass them to helpers, while they still point
> to valid kernel BTF objects.
>
> Using btf_struct_access to implement new btf_struct_address
> function, because it already walks down the given BTF object.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

This logic is very hard to follow. Each type I try to review it, I get
lost very fast. TBH, this access_data struct is not just not helpful,
but actually just complicates everything.

I'll get to this tomorrow morning with fresh brains and will try to do
another pass.

[...]

>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>                           const struct bpf_func_proto *fn, int arg)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7de98906ddf4..da7351184295 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3808,6 +3808,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
>         enum bpf_reg_type expected_type, type = reg->type;
>         enum bpf_arg_type arg_type = fn->arg_type[arg];
> +       const struct btf_type *btf_type;
>         int err = 0;
>
>         if (arg_type == ARG_DONTCARE)
> @@ -3887,24 +3888,34 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                 expected_type = PTR_TO_BTF_ID;
>                 if (type != expected_type)
>                         goto err_type;
> -               if (!fn->check_btf_id) {
> -                       if (reg->btf_id != meta->btf_id) {
> -                               verbose(env, "Helper has type %s got %s in R%d\n",
> +               if (reg->off) {


This non-zero offset only logic looks fishy, tbh. What if the struct
you are trying to access is at offset zero? E.g., bpf_link is pretty
much always a first field of whatever specific link struct it is
contained within. The fact that we allow only non-zero offsets for
such use case looks like an arbitrary limitation.

> +                       btf_type = btf_type_by_id(btf_vmlinux, reg->btf_id);
> +                       if (btf_struct_address(&env->log, btf_type, reg->off, meta->btf_id)) {
> +                               verbose(env, "Helper has type %s got %s in R%d, off %d\n",
>                                         kernel_type_name(meta->btf_id),
> +                                       kernel_type_name(reg->btf_id), regno, reg->off);
> +                               return -EACCES;
> +                       }

[...]
