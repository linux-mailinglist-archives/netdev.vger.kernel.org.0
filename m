Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5C3CC092
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 03:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhGQBpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 21:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhGQBpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 21:45:06 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D530C06175F;
        Fri, 16 Jul 2021 18:42:11 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id v189so17831178ybg.3;
        Fri, 16 Jul 2021 18:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lWv8W7IFc+a2CnOV8gMR6VMz6xdeyuN4PkKvoPSBlHg=;
        b=arzUIJBxXc79w4urqNEHl2DGZ7km83bSmiaot8JVicMdLObWxpiKPiORMDNjMoJGV9
         XvFibhkQ34l6HYckcO3djh7CMKX9kYdHPWnPJ7tN3bMW0H8L3BJseTnIwRW2rMCP0LM+
         lD59YG7nkw3ZQbFS+pzgunC8ySlw3+lr1ZTirZE8B48uF66878+zHNyGXt5J8CCsakfU
         K2xjKgEsQiyvgFCCxUOMCYry5Nepoew3sATygPlHkYKxgQTAU+QhBdCT7gGeSBi5FXOO
         y98uBLXiP55H+3m5gH9eA9hyFq5mEf/q9+z05EEHwEZl7uTx6Z7Dm6n6ByS82Hpu63cL
         Wy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lWv8W7IFc+a2CnOV8gMR6VMz6xdeyuN4PkKvoPSBlHg=;
        b=pQ85rs8CAcbqFcR1WNOIVQL82qqjYLUanH725/62K28TotVY/0nphTTLc9DIPELxQB
         lcJPJhMrUTOOWB6VadXenHqk98F5+uGaqz01ky2nxwqUqicGICYIMhduuSywt2rDedLk
         UPIiScAAEapot2bwv7ZdxWEW8pBJnHW4H02p2ZCKmsTcRr821vI2TTYUx6Ml0hahSefg
         aQrl0tHHDLF5LfeoGDMUepYAcT0rtujkTPuRvOyMkRjEP/MOCejx3R4MayVz1A9U1LC8
         a9XM+0PqxAZ0eeAzqR7rdor+lQCFb97lEJkLkxfCq85y6khzGBIhDawJ6XzpYIaGq4O1
         ndOA==
X-Gm-Message-State: AOAM531A5I9AOtFNNZOCnlSDmPpYnmny3WsCTAhQ5h00NllFH6GrfQIL
        PWYGlUjeXlSLaZ3EeRCBYuUa4QH6Y7wpHKihTro=
X-Google-Smtp-Source: ABdhPJy6HfYoPPKD0E8AFvv4QzCicUsLwx37ZqbF+QvVYpJIxqOBajuG7xTcNGu7Ih+Uk+SElO/SPDAeViKBKO5IMGA=
X-Received: by 2002:a25:b203:: with SMTP id i3mr16618078ybj.260.1626486130413;
 Fri, 16 Jul 2021 18:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210714094400.396467-1-jolsa@kernel.org> <20210714094400.396467-7-jolsa@kernel.org>
In-Reply-To: <20210714094400.396467-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 18:41:59 -0700
Message-ID: <CAEf4Bzbk-nyenpc86jtEShset_ZSkapvpy3fG2gYKZEOY7uAQg@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 6/8] libbpf: Add bpf_program__attach_kprobe_opts
 function
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 2:45 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding bpf_program__attach_kprobe_opts that does the same
> as bpf_program__attach_kprobe, but takes opts argument.
>
> Currently opts struct holds just retprobe bool, but we will
> add new field in following patch.
>
> The function is not exported, so there's no need to add
> size to the struct bpf_program_attach_kprobe_opts for now.

Why not exported? Please use a proper _opts struct just like others
(e.g., bpf_object_open_opts) and add is as a public API, it's a useful
addition. We are going to have a similar structure for attach_uprobe,
btw. Please send a follow up patch.

>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 88b99401040c..d93a6f9408d1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10346,19 +10346,24 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
>         return pfd;
>  }
>
> -struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> -                                           bool retprobe,
> -                                           const char *func_name)
> +struct bpf_program_attach_kprobe_opts {

when you make it part of libbpf API, let's call it something shorter,
like bpf_kprobe_opts, maybe? And later we'll have bpf_uprobe_opts for
uprobes. Short and unambiguous.

> +       bool retprobe;
> +};
> +
> +static struct bpf_link*
> +bpf_program__attach_kprobe_opts(struct bpf_program *prog,
> +                               const char *func_name,
> +                               struct bpf_program_attach_kprobe_opts *opts)
>  {
>         char errmsg[STRERR_BUFSIZE];
>         struct bpf_link *link;
>         int pfd, err;
>

[...]
