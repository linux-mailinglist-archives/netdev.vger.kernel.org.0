Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427353CC094
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 03:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhGQBpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 21:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhGQBpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 21:45:12 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB878C06175F;
        Fri, 16 Jul 2021 18:42:16 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r132so17816173yba.5;
        Fri, 16 Jul 2021 18:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XaI4Sevy4rmeomslDz9L3SbX88X7A1/njpOmXYRxXTc=;
        b=jyyAYR4I23gQbT9eNARXvU6NOhBWz/Z08wl1a0VkMB3sO/NHC6cxo0EWrVKQ351MGh
         um2j++Ml29AF41l+GreBSrSmJHqAlLPW+Z++R+LGdlgPLhly0d0gKqsrACdI0B5eXH5g
         Hg8PUaA4Z+lm3A0UmrQCeYoz432BF6krh58VEvmHbxopULXFLjHG3gXOv5oXCNB6OJyp
         ztlpgF2YdVIXJpV+LNe6LKxf5YS1KSCL1n168+x73VZC2njnXNgKikGlZd451waREvUo
         vPu+aX2LS+caQbTd8mzqMMmXYjqpWiB4uXQt51NanRHPYyezASCFPyXL1R7AvZt8xbp7
         Y55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XaI4Sevy4rmeomslDz9L3SbX88X7A1/njpOmXYRxXTc=;
        b=Yk7enSLOkAGk71EyDO+7HWWunnZzHJM85s/hYcAN5yXDdgwC/XU11gY4B4IfFAlvfe
         wEDM/CIKBnH0GZ1fm/JhTPDnwbR/NMTPslwr/YjVaf8T7skzX2JXe09p7RbW5h946pAB
         JcrmlmOtOFYmFdYnMRoAiayO2SlndC6lNZoPQyTsvvkT34Qmo3UnstIcgIuR8uOQ8ymo
         Yt7pgEfUzLO5pBvpBk8fdfSno8pBADg+/NBSDvwP/vK6SnbNTkg5d2PGeIH7YM8jE4fc
         rLgpm32f18xeI9W3IREFKqLyh3ONqyRtHK6zNI+3bQFxd+G4LPujkCkccYe8IKlalOpN
         NbKg==
X-Gm-Message-State: AOAM531zEFnCu0PcBRdU4yvDozuX+4+T1QbxMBBleoMo32bZI1zUvJHy
        SE6/WvfomMfgj77ZoCv38tvVg/ITwCBAXYYDoiE=
X-Google-Smtp-Source: ABdhPJxx2xJ5WMG214Nr6e1aeM0d5Af+dOrLYUU0iM17J5ilqI0VDPoZrUy8sw1XdEqYKP2AZoQ2nA7kxvOIRx69wWo=
X-Received: by 2002:a25:3787:: with SMTP id e129mr15981599yba.459.1626486136165;
 Fri, 16 Jul 2021 18:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210714094400.396467-1-jolsa@kernel.org> <20210714094400.396467-8-jolsa@kernel.org>
In-Reply-To: <20210714094400.396467-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 18:42:05 -0700
Message-ID: <CAEf4BzYELMgTv_RhW7qWNgOYc_mCyh8-VX0FUYabi_TU3OiGKw@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 7/8] libbpf: Allow specification of "kprobe/function+offset"
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
> [jolsa: changed original code to use bpf_program__attach_kprobe_opts
> and use dynamic allocation in sscanf]
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index d93a6f9408d1..abe6d4842bb0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10348,6 +10348,7 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
>
>  struct bpf_program_attach_kprobe_opts {
>         bool retprobe;
> +       unsigned long offset;
>  };
>
>  static struct bpf_link*
> @@ -10360,7 +10361,7 @@ bpf_program__attach_kprobe_opts(struct bpf_program *prog,
>         int pfd, err;
>
>         pfd = perf_event_open_probe(false /* uprobe */, opts->retprobe, func_name,
> -                                   0 /* offset */, -1 /* pid */);
> +                                   opts->offset, -1 /* pid */);
>         if (pfd < 0) {
>                 pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
>                         prog->name, opts->retprobe ? "kretprobe" : "kprobe", func_name,
> @@ -10394,12 +10395,31 @@ static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
>                                       struct bpf_program *prog)
>  {
>         struct bpf_program_attach_kprobe_opts opts;
> +       unsigned long offset = 0;
> +       struct bpf_link *link;
>         const char *func_name;
> +       char *func;
> +       int n, err;
>
>         func_name = prog->sec_name + sec->len;
>         opts.retprobe = strcmp(sec->sec, "kretprobe/") == 0;
>
> -       return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
> +       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%lx", &func, &offset);

could have used %li here to support both +0xabc and +123 forms

> +       if (n < 1) {
> +               err = -EINVAL;
> +               pr_warn("kprobe name is invalid: %s\n", func_name);
> +               return libbpf_err_ptr(err);
> +       }
> +       if (opts.retprobe && offset != 0) {
> +               err = -EINVAL;

leaking func here


> +               pr_warn("kretprobes do not support offset specification\n");
> +               return libbpf_err_ptr(err);
> +       }
> +
> +       opts.offset = offset;
> +       link = bpf_program__attach_kprobe_opts(prog, func, &opts);
> +       free(func);
> +       return link;
>  }
>
>  struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
> --
> 2.31.1
>
