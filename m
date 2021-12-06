Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4451846AA57
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351438AbhLFVZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356350AbhLFVZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:25:38 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4184EC061746;
        Mon,  6 Dec 2021 13:22:09 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id f186so35051892ybg.2;
        Mon, 06 Dec 2021 13:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyjTFg+m485wI5iCRdXWLc0w3JDR/ZMIRZ/MIBbHe0c=;
        b=XGMOcjFpYg1sdhWs/2LsjTSp58ZwZ4kmtYd3Nkjv85dSEvO7u66J604Ij6g7QGZgmM
         UCjNYSdbVpEGtsgTdNtd0nrXIg5oYqdPdfblG2broxawg8El9PaTBYp+shH94AlQzq96
         2B7iBB871OkiXO2pWUilm5L7lwmWhQt50U5XTQBzwEoUq4cYhP9EZ+YCFL4LHxOjYX59
         1JRCviDUF1LrGkxWm+4Lg7w6fF7N0Phmw3vJt/jE6smBltbxt08oGsI0XaWHML9MWQ7R
         IGWrS1Q9TGpFw9AxfIaG5BkCuPMh0PZ0JPK+MAQLmmkm1fKlmUGM66Bgcqu2D0kOn3py
         LH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyjTFg+m485wI5iCRdXWLc0w3JDR/ZMIRZ/MIBbHe0c=;
        b=Ulnop5yO6WiWecJ2q95cD8/KS+v1+/UIJsR1HpdXozu8Ev+0F2f0nBqVdOXzNUenWk
         0eIxwNnJ0ofGj3BXH9COHIjWUetnwl55qwLRRHUpRsCJLf/IqOtCHFANWytWDS7FBxV9
         pH8SEhQMh0dPTy0r0GQKaxhmR+4u4LkgmbdxoaaAc5pMEhMBbaURZeGAi2aOjjtcfBpk
         UiO9yPgp2ChmLirRH7rS+E3DW7AMUdCW5MbuzfpYsM+I5m8TfeB/4mbJVShyiH8gyRwr
         y10QnbMbyDES57i00iqr8cyd4X1jvZZRT/uoNCKlYaUdT7AUbgaIRurNq5aREEgrBaOp
         jcbw==
X-Gm-Message-State: AOAM532kIn5xeWzozo4QQvdEoFlu89yWNJtVZxMg3fI2pQfVOtKXxRkS
        xYG2YtvHkUeNzNh0kmh7AOZ5tvArsj4jf3d7bEs=
X-Google-Smtp-Source: ABdhPJxjZTZedEVmCrt95wMT7vKrEwEZl2arWVNbYnceKP0G1K3cCob88utjHVzJ8JD4R7B+ycOI1WIpmQd1cBfqhb0=
X-Received: by 2002:a25:84c1:: with SMTP id x1mr46408796ybm.690.1638825727881;
 Mon, 06 Dec 2021 13:22:07 -0800 (PST)
MIME-Version: 1.0
References: <20211205045041.129716-1-imagedong@tencent.com>
In-Reply-To: <20211205045041.129716-1-imagedong@tencent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 13:21:56 -0800
Message-ID: <CAEf4BzbqhccBOSiBRehnf6V35u48N+f67tmgYUR_EJhpv6HptA@mail.gmail.com>
Subject: Re: [PATCH] bpftool: add support of pin prog by name
To:     menglong8.dong@gmail.com, Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Cong Wang <cong.wang@bytedance.com>, liujian56@huawei.com,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 8:51 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> For now, the command 'bpftool prog loadall' use section name as the
> name of the pin file. However, once there are prog with the same
> section name in ELF file, this command will failed with the error
> 'File Exist'.
>
> So, add the support of pin prog by function name with the 'pinbyname'
> argument.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---

Doesn't [0] do that already?

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20211021214814.1236114-2-sdf@google.com/

>  tools/bpf/bpftool/prog.c | 7 +++++++
>  tools/lib/bpf/libbpf.c   | 5 +++++
>  tools/lib/bpf/libbpf.h   | 2 ++
>  3 files changed, 14 insertions(+)
>
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index e47e8b06cc3d..74e0aaebfefc 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1471,6 +1471,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>         unsigned int old_map_fds = 0;
>         const char *pinmaps = NULL;
>         struct bpf_object *obj;
> +       bool pinbyname = false;
>         struct bpf_map *map;
>         const char *pinfile;
>         unsigned int i, j;
> @@ -1589,6 +1590,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>                                 goto err_free_reuse_maps;
>
>                         pinmaps = GET_ARG();
> +               } else if (is_prefix(*argv, "pinbyname")) {
> +                       pinbyname = true;
> +                       NEXT_ARG();
>                 } else {
>                         p_err("expected no more arguments, 'type', 'map' or 'dev', got: '%s'?",
>                               *argv);
> @@ -1616,6 +1620,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>                                 goto err_close_obj;
>                 }
>
> +               if (pinbyname)
> +                       bpf_program__set_pinname(pos,
> +                                                (char *)bpf_program__name(pos));
>                 bpf_program__set_ifindex(pos, ifindex);
>                 bpf_program__set_type(pos, prog_type);
>                 bpf_program__set_expected_attach_type(pos, expected_attach_type);
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index f6faa33c80fa..e8fc1d0fe16e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8119,6 +8119,11 @@ void bpf_program__set_ifindex(struct bpf_program *prog, __u32 ifindex)
>         prog->prog_ifindex = ifindex;
>  }
>
> +void bpf_program__set_pinname(struct bpf_program *prog, char *name)
> +{
> +       prog->pin_name = name;

BPF maps have bpf_map__set_pin_path(), setting a full path is more
flexible approach, I think, so if we had to do something here, it's
better to add bpf_program__set_ping_path().


> +}
> +
>  const char *bpf_program__name(const struct bpf_program *prog)
>  {
>         return prog->name;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 4ec69f224342..107cf736c2bb 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -216,6 +216,8 @@ LIBBPF_API int bpf_program__set_priv(struct bpf_program *prog, void *priv,
>  LIBBPF_API void *bpf_program__priv(const struct bpf_program *prog);
>  LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
>                                          __u32 ifindex);
> +LIBBPF_API void bpf_program__set_pinname(struct bpf_program *prog,
> +                                        char *name);
>
>  LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
>  LIBBPF_API const char *bpf_program__section_name(const struct bpf_program *prog);
> --
> 2.30.2
>
