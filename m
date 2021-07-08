Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F37B3BF2C2
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhGHARP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhGHARN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 20:17:13 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A1EC061574;
        Wed,  7 Jul 2021 17:14:31 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i4so6095959ybe.2;
        Wed, 07 Jul 2021 17:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TV4IBy3K4kRRCEUuP5BtJwmx3v4JDVXF/6/PhYrC6oU=;
        b=jJT2/U2G5rByIMIwDUAt1hIu3W/Fm1etNJkm5dGiku2USIivzIsR/jddfLz/yBkr7M
         wlW3k8oKLBfNOKY7DvdbzeThmTUIKFZ6y9q8uJBcgoLpySt08A0xJakFlfb2lMOdd+ZN
         eAeP1sHfgQwuSLt4UnOsorNRQ7iVoZ3LgJ6vfyAOgZNwCtzZHKYK0YmAbH80qmh+Y0ZC
         k0A9acRQrjr8gpTzOpLd4wOqc2Pj1uO6tqG5WuDz9Q+LnVDUZUEHOpEPiSlTaaQwUibS
         2WyTyhVGv2EvZQbHaCnWPBNRACGQixjFlaeiHVeQGnm5tXdhBtjRMeMMEeEjBFIT6xH1
         uClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TV4IBy3K4kRRCEUuP5BtJwmx3v4JDVXF/6/PhYrC6oU=;
        b=mV4jkeWIkQqZItFTCtjAk8T8mx6X4vm54CXHGQ8Sb7LFRvwE9TSFQp5pcSUebGlk1W
         rf1SApDWEWAY02S77ZXgD0+dBNyuZAAgBML+QGnUpoFO9VelHbXGsS0LxggT2HKJppRi
         bzudvq0mA3iK98aQ1uVN2kK3XWT6rc4OBVzqMr61flNLZU2G5Oesq7W3BsHsVvGsUeMJ
         uZoyPm1PROS9+xVovRSKHMK/l+3Bmbto5gMO3p03bJ3mmumZbkltF41GIhNKzCaWISJv
         ANZqMdRVv4eO3arbCo1Qp9DaWPT6sSu68QUrbqM4aYcXtyoyquqA2zTYp6Cgw9/JDZvV
         0fqA==
X-Gm-Message-State: AOAM531WVd1GbZoos694x7+m7+UzBVHkBD4ke6sM/TPCiqkGUuOv3oYV
        RFfwuyQ6bFpuN4qc9pPjGqKsTi+SvrcoCHBU+qY=
X-Google-Smtp-Source: ABdhPJy5KA6tN4+mFs1HcVZief9nO10nnvQMxw67Fhud5QwqvJkhOOBHUKIOpIPd6n5ExIuDwhby6ctWwsFL6meOxTg=
X-Received: by 2002:a25:b203:: with SMTP id i3mr35505412ybj.260.1625703271096;
 Wed, 07 Jul 2021 17:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210707214751.159713-1-jolsa@kernel.org> <20210707214751.159713-7-jolsa@kernel.org>
In-Reply-To: <20210707214751.159713-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 17:14:20 -0700
Message-ID: <CAEf4BzbBk+0OHawjkCQdr2PNntEnfU-uov0fr=hk7jYokNrSDA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 6/7] libbpf: allow specification of "kprobe/function+offset"
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

On Wed, Jul 7, 2021 at 2:54 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> From: Alan Maguire <alan.maguire@oracle.com>
>
> kprobes can be placed on most instructions in a function, not
> just entry, and ftrace and bpftrace support the function+offset
> notification for probe placement.  Adding parsing of func_name
> into func+offset to bpf_program__attach_kprobe() allows the
> user to specify
>
> SEC("kprobe/bpf_fentry_test5+0x6")
>
> ...for example, and the offset can be passed to perf_event_open_probe()
> to support kprobe attachment.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce724240..60c9e3e77684 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10309,11 +10309,25 @@ struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
>                                             const char *func_name)

I think we should add bpf_program__attach_kprobe_opts instead for the
programmatic API instead of parsing it here from func_name. It's a
cumbersome API.

Parsing SEC() is fine, of course, but then it has to call into
bpf_program__attach_kprobe_opts() internally.

>  {
>         char errmsg[STRERR_BUFSIZE];
> +       char func[BPF_OBJ_NAME_LEN];
> +       unsigned long offset = 0;
>         struct bpf_link *link;
> -       int pfd, err;
> +       int pfd, err, n;
> +
> +       n = sscanf(func_name, "%[a-zA-Z0-9_.]+%lx", func, &offset);
> +       if (n < 1) {
> +               err = -EINVAL;
> +               pr_warn("kprobe name is invalid: %s\n", func_name);
> +               return libbpf_err_ptr(err);
> +       }
> +       if (retprobe && offset != 0) {
> +               err = -EINVAL;
> +               pr_warn("kretprobes do not support offset specification\n");
> +               return libbpf_err_ptr(err);
> +       }
>
> -       pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> -                                   0 /* offset */, -1 /* pid */);
> +       pfd = perf_event_open_probe(false /* uprobe */, retprobe, func,
> +                                   offset, -1 /* pid */);
>         if (pfd < 0) {
>                 pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
>                         prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
> --
> 2.31.1
>
