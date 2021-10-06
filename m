Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BAC423729
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 06:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhJFEnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 00:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhJFEnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 00:43:32 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E3BC061749;
        Tue,  5 Oct 2021 21:41:40 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id n65so2457558ybb.7;
        Tue, 05 Oct 2021 21:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JtifTLSQRiZokG2dcCEgLv5sHvS/tOj2YIKa4/TP5No=;
        b=Oqo3FvkQW4lY9i+w/ruzt3M1Rf6RCSF+uYVM7uXofPLdVZ/AXqmBRYa6pyLTxrTtT5
         N4MYOiFFo1Y7+G5ApZs7sCRGtJ5P3miS1qKHTJlBkF8HclieskZPn5hc2oSGZ2g+q6HW
         +PkcyGAb/oN2bumkJyhBYsWL1qhBO6IuSdCpWPxYWBm3/T4pmm4h57LdQ5F8QxKRO+j3
         hEC4UOB1Ll0stJZhysxbycrhqqob3eyyy4kMSrMaL0klQZBezGkCakM8caEQDqbrtE21
         W1GxAOOdrrJhOmgiBh93np3X7RlOFIYvMJmgptX5TMb+AU45joZ38UrZaxgSEKc/j2AY
         6gfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JtifTLSQRiZokG2dcCEgLv5sHvS/tOj2YIKa4/TP5No=;
        b=lq3/SsAySGGsG7TzUXQVYhCejoo7/PwteWB4OA8Mmbku/RARYDrFLDHcznD7xrayYT
         1IaEnGgeYA3bn5saP1VQWloXg1RgrRkEK08FPky1J8MyV2Pwr7HIXzEB9JbXt8InyLR2
         XTVrOiXZckHnImj1nrgxD75PJrs7hKX4I33LfT25M2phpgPPHCl5RbTGuZ7I0TpVgkS0
         itsmtpIvCMxIdO11LF8CxNo2RKCarNzNdJdRTyvNilaUsquSUlQVJ4N7oveesmd4Jv8G
         EOJAxWUw6emaVwW9haQYc1l5gY7OzMJklNKFErnn0DkdW5DKxrSUdqRDoGsVAw0r3O5g
         iLVg==
X-Gm-Message-State: AOAM5332MJieFqK83/Kw+D7oQbopSbjJuUr8DEr5zw6eqWvu/qbk13rO
        iOBcyWS1tRdQMYtftlgBf72VebbEQBRN7H+eXhc=
X-Google-Smtp-Source: ABdhPJyeXAS8INuPnrxw1ix3Pxtrn0Bxm1v2Alito3scuwrENgw816eIAtNOP3jA+HQsniVhQywPrMXV28tEMHad9M0=
X-Received: by 2002:a25:24c1:: with SMTP id k184mr27587196ybk.2.1633495300082;
 Tue, 05 Oct 2021 21:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-4-memxor@gmail.com>
In-Reply-To: <20211006002853.308945-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Oct 2021 21:41:29 -0700
Message-ID: <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
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

On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> Since the code assumes in various places that BTF fd for modules is
> never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
> fd 0 being free for allocation is usually an application error, it is
> still possible that we end up getting fd 0 if the application explicitly
> closes its stdin. Deal with this by getting a new fd using dup and
> closing fd 0.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index d286dec73b5f..3e5e460fe63e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
>                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
>                         return err;
>                 }
> +               /* Make sure module BTF fd is never 0, as kernel depends on it
> +                * being > 0 to distinguish between vmlinux and module BTFs,
> +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
> +                */
> +               if (!fd) {
> +                       fd = dup(0);

This is not the only place where we make assumptions that fd > 0 but
technically can get fd == 0. Instead of doing such a check in every
such place, would it be possible to open (cheaply) some FD (/dev/null
or whatever, don't know what's the best file to open), if we detect
that FD == 0 is not allocated? Can we detect that fd 0 is not
allocated?

Doing something like that in bpf_object__open() or bpf_object__load()
would make everything much simpler and we'll have a guarantee that fd
== 0 is not going to be allocated (unless someone accidentally or not
accidentally does close(0), but that's entirely different story).

> +                       if (fd < 0) {
> +                               err = -errno;
> +                               pr_warn("failed to dup BTF object #%d FD 0 to FD > 0: %d\n", id, err);
> +                               close(0);
> +                               return err;
> +                       }
> +                       close(0);
> +               }
>
>                 len = sizeof(info);
>                 memset(&info, 0, sizeof(info));
> --
> 2.33.0
>
