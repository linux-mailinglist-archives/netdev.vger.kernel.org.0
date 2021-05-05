Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238D6374828
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhEESq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbhEESq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:46:26 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E7AC061574;
        Wed,  5 May 2021 11:45:29 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id e190so3983510ybb.10;
        Wed, 05 May 2021 11:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsndVLEjExynmF5y+I8VPPu8kM+YFPUfsGJirIMwSTA=;
        b=c7AcGP4J85XixSfyOnSK/KUebnruNUT59GYprfYw+UprsKh9XIW1sVriE2j9yHbGQS
         wDHZmPz7U3mz++AHtrLC441n2xE3aH48wLtXLNkecYH5ToeSVtbwnbw6bHZ62Fv0yzjL
         sYz//bLezUXbogEMKFZR2bkK6CDQjVJJ0+BPWmhzyQEktJEvmalPzWsx/BQmtnhNHQup
         5bO95TBj+jaNoSkyL/47QiyDz5cQHxYRa1N2quD+iYfsXWoQhk/jVD4a6PiU42HSoXJa
         e4f7fm4+lbeN4UkTI3KHzCGxKktc8SBy0dlplsCQPX7NlKzbDsmNYACFt3pqPWjPWvgM
         adkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsndVLEjExynmF5y+I8VPPu8kM+YFPUfsGJirIMwSTA=;
        b=TCEob7F+p92EUkccM4rIQrckCLltaVPlQz9SYHPR/eL3AhEOqoKw1itwFNvPzsgntq
         nWrRq6jENe4pC+c5HA53324oVL9tvC5y544hMrvw+L/r22BMwSJGEyn6Tek5PdojvYS4
         jSm3+x7tgQOeILmH6zrFVQjrsyH3EKFaWyDQEfZZH6rsTp2bmRt496hwZ156G98vBmw8
         /JuF7Au5iq7DuSBY/I+e09zh8WSCfWa3W3oU9BzEqZZm4WB/MweeATK1vQTCz3cD+f2f
         8F0/D0p+V5uva++M0uldDrs5Fqw3h/PwPqW4fwzmo8UgVW6L00Yh2YMxrqoSKuxWjRzz
         XRhg==
X-Gm-Message-State: AOAM533LIq9oGqQrfsL30QQobIn7Em1buIyQtDR7xW24TgbxKP1pg5oj
        eyiBBGy90/WBW6Xpt1lnyLsbUmJ/uTs/XYfNxEg=
X-Google-Smtp-Source: ABdhPJyy9CNsu30l+dNSfn+J7Gf2sDm2Fw4sZNkYodDQwxk/JrQNOAtzD8TrxhnQ+oLtDAGEEJcjN/fKY2iWu4z6o+k=
X-Received: by 2002:a25:3357:: with SMTP id z84mr237685ybz.260.1620240328981;
 Wed, 05 May 2021 11:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210505132529.401047-1-jolsa@kernel.org>
In-Reply-To: <20210505132529.401047-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 May 2021 11:45:17 -0700
Message-ID: <CAEf4BzazQgrPVqKOGP8z=MPZhjZHCZDdcWQB0xBuudXbxXwaXg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Forbid trampoline attach for functions with variable arguments
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 6:42 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We can't currently allow to attach functions with variable arguments.
> The problem is that we should save all the registers for arguments,
> which is probably doable, but if caller uses more than 6 arguments,
> we need stack data, which will be wrong, because of the extra stack
> frame we do in bpf trampoline, so we could crash.
>
> Also currently there's malformed trampoline code generated for such
> functions at the moment as described in:
>   https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/btf.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 0600ed325fa0..161511bb3e51 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -5206,6 +5206,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>         m->ret_size = ret;
>
>         for (i = 0; i < nargs; i++) {
> +               if (i == nargs - 1 && args[i].type == 0) {
> +                       bpf_log(log,
> +                               "The function %s with variable args is unsupported.\n",
> +                               tname);
> +                       return -EINVAL;
> +
> +               }
>                 ret = __get_type_size(btf, args[i].type, &t);
>                 if (ret < 0) {
>                         bpf_log(log,
> @@ -5213,6 +5220,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>                                 tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
>                         return -EINVAL;
>                 }
> +               if (ret == 0) {
> +                       bpf_log(log,
> +                               "The function %s has malformed void argument.\n",
> +                               tname);
> +                       return -EINVAL;
> +               }
>                 m->arg_size[i] = ret;
>         }
>         m->nr_args = nargs;
> --
> 2.30.2
>
