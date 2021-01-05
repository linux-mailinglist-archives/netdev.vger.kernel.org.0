Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB462EB4C5
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbhAEVQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbhAEVQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 16:16:30 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532CFC061793;
        Tue,  5 Jan 2021 13:15:50 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id y128so801911ybf.10;
        Tue, 05 Jan 2021 13:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w5hGfSXanSnbWWKzhU6Q+sifQHt8eVg1Q5S3F04rIN4=;
        b=A1XSoqJjnriEMm5bbm2X3i6gIAz6lK3t/alX6FLKk4m0CUJbPOJQDQxJ1ETCbJOc5K
         b2nmQ/aLiNAZeaux2Gou3iWF9Rep1IqxxEqPdJ2LfXg92f8ore5NvUGOV7+1sfPb+hQK
         01WJau6uiXZlbrlI1xhFPgvNA4P6L2XWNBJJXFqdcz+f+8CU1qydFbxNIlef4znYWuvc
         MKc8lMXodtatpdo1W0gBBJkJFkQPGEi6s4QJWFZ6Cn5bBjElrVtOLlPGkEbMmCkY/hgk
         oYImzTGmyIHWkPXt/K6bHgCvnI1dx7fpiHyvKDp9u9/L6BYCD+XjSF3/xN+2Vh/R4WvN
         3XqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w5hGfSXanSnbWWKzhU6Q+sifQHt8eVg1Q5S3F04rIN4=;
        b=WH0aG7+P7y4Y0C2GuM8MJqBLPADgnuGFkkQGxY13WuFEUhTDQFnmzxv76q1oescurO
         VHk5IdJyc1NXtV+/YcJXMGfSZjNgewWyvUoi0AtkbXrIEHjXztwSLwODj4criRsKeCRI
         0GBAyQOvV8ROA/NEBeeGLdh1z3X7+1Y0OkutB5yckQd0u5/TuHVvKQAca+N73NSAzye+
         lFJtRmgT/qSaYGagipXhy8sa9TKPBFGFUQtN3wLgLTCioD8M7mP9BuTgUCGsw6rVfHZu
         kDcxWkrBUdmeDVl7oOfHj+dVlD+5+9z4v61E7wLXPwIb9AstSwXecPyKbe9+R2G05bqG
         cKYQ==
X-Gm-Message-State: AOAM530Z02O01uABIxFbZDaYGBNqNlLllWjy36T/tacJQdcSNXd9a28k
        6gWnt6ncEOPrEYMVK7ufqJI7qdsYQ97+pIFP4D0=
X-Google-Smtp-Source: ABdhPJzyVrXqh+HaRZwy5rwJEzyPovNNbTsl7xLYckqjEE4TsKgeUjH+90uld35+1QtX+1EaXPoeDvW7xvs+FamNFbo=
X-Received: by 2002:a25:854a:: with SMTP id f10mr1834142ybn.510.1609881349682;
 Tue, 05 Jan 2021 13:15:49 -0800 (PST)
MIME-Version: 1.0
References: <20210105153944.951019-1-jolsa@kernel.org>
In-Reply-To: <20210105153944.951019-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jan 2021 13:15:39 -0800
Message-ID: <CAEf4Bzb95cyrku5g+SvOmAWCV6kRhqJAFayp4fdzT31dMjjVXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Warn when having multiple
 IDs for single type
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 7:41 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The kernel image can contain multiple types (structs/unions)
> with the same name. This causes distinct type hierarchies in
> BTF data and makes resolve_btfids fail with error like:
>
>   BTFIDS  vmlinux
> FAILED unresolved symbol udp6_sock
>
> as reported by Qais Yousef [1].
>
> This change adds warning when multiple types of the same name
> are detected:
>
>   BTFIDS  vmlinux
> WARN: multiple IDs found for 'file' (526, 113351)
> WARN: multiple IDs found for 'sk_buff' (2744, 113958)
>
> We keep the lower ID for the given type instance and let the
> build continue.
>
> [1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
> Reported-by: Qais Yousef <qais.yousef@arm.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

see comments below, but otherwise lgtm

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/resolve_btfids/main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index e3ea569ee125..36a3b1024cdc 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -139,6 +139,8 @@ int eprintf(int level, int var, const char *fmt, ...)
>  #define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
>  #define pr_err(fmt, ...) \
>         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_info(fmt, ...) \
> +       eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)

how is it different from pr_err? Did you forget to update verboseness
levels or it's intentional?

>
>  static bool is_btf_id(const char *name)
>  {
> @@ -526,8 +528,13 @@ static int symbols_resolve(struct object *obj)
>
>                 id = btf_id__find(root, str);
>                 if (id) {
> -                       id->id = type_id;
> -                       (*nr)--;
> +                       if (id->id) {
> +                               pr_info("WARN: multiple IDs found for '%s' (%d, %d)\n",
> +                                       str, id->id, type_id);
> +                       } else {
> +                               id->id = type_id;
> +                               (*nr)--;

btw, there is a nasty shadowing of nr variable, which is used both for
the for() loop condition (as int) and as `int *` inside the loop body.
It's better to rename inner (or outer) nr, it's extremely confusing as
is.

> +                       }
>                 }
>         }
>
> --
> 2.26.2
>
