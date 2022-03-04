Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237924CE0AE
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiCDXM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiCDXMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:21 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611827C505;
        Fri,  4 Mar 2022 15:11:31 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id r11so6523745ioh.10;
        Fri, 04 Mar 2022 15:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tu3PDx8g7KdqKYGH/ad44ha7i36AbBBCjLin1LUtj1g=;
        b=FynEEowqc8uoDpDdddzAibcLbLStzYJHCWwKsfNr/6PtYz6QEFqM1WMRsQvWUSGbfH
         TH3sYevrcBTp9bpR/VZjug2TCAqwmxUpnmhzxYXHq1PoWp6cHTIas68hBVRqTizWncjf
         vU1JS8K5LNSFIW2ozc638Uq2R4lOdewq0sY9kMzUEHfBDFjrbJbvFeB9J6FCSUMYGreh
         Ir23r28bd9EzjkZRi8uhQJHqJS016tlsiVEe0B2C+yy5RMYGI6wHu86IhO5xy9hmv5x/
         eNSyJoqjGt4fVT78rLnx83P1AUKruYeSSZumwSEd8I3L8BfjgiwzyIRG4Y0H4vXAbtLw
         sPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tu3PDx8g7KdqKYGH/ad44ha7i36AbBBCjLin1LUtj1g=;
        b=SaFZUU/kUJsvDB8rW87Kit6w0FDwvn5WEql58PV6+4tv8CYXMTzen5AMYHzfqu6NGz
         x0ge/wacfml8A9uc/2E6zOORI5NGiwKkj+HkZl3C49wlAsKWafPofIaXaP/CMPzM+haP
         WBO3Jduaq/CSuqaC0Pq1XJXhBCmXQ8Ax2LYb5nNIFzWiXjii2ox7tx1g5eE8yIBLP9Or
         2c4+HNqnOQ8HPKeJiRv7/lXRahbebAN5P4dRl5Kp6UjN0eX6d9Ug6Z1LIJi9aVQNVYAl
         m6cUp5rwlQ3aZcpCnWe9aQltK0WaT+f/7hOJ9Hu8hdA6CGTbvkic2FAMOgRDvdEMGnKQ
         HPjw==
X-Gm-Message-State: AOAM533Uvx9b68oUdoC1cR0yj0095q8JEMbq3suSLqIGjtpHmx/m3oSw
        xI8R0P4AgAWCTlv5VCwjH7XUYvFjqZvjjmBrNWk=
X-Google-Smtp-Source: ABdhPJznjZfiBNK5ZHPfKBI8524+/bgYpVoCyN5zO7+bYe9J/XEB3rNkFgl0pVm5jHQun53FctBUCiauBfgboAk2/kk=
X-Received: by 2002:a5e:c648:0:b0:640:bc31:cbec with SMTP id
 s8-20020a5ec648000000b00640bc31cbecmr707642ioo.79.1646435490885; Fri, 04 Mar
 2022 15:11:30 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-9-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:19 -0800
Message-ID: <CAEf4Bza0qRAzA7WmtPD4US4Kur3qf3X+LC5uowr_H3Y-_pLfCA@mail.gmail.com>
Subject: Re: [PATCH 08/10] libbpf: Add bpf_program__attach_kprobe_opts support
 for multi kprobes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Yucong Sun <fallentree@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to bpf_program__attach_kprobe_opts to attach kprobes
> to multiple functions.
>
> If the kprobe program has BPF_TRACE_KPROBE_MULTI as expected_attach_type
> it will use the new kprobe_multi link to attach the program. In this case
> it will use 'func_name' as pattern for functions to attach.
>
> Adding also new section types 'kprobe.multi' and kretprobe.multi'
> that allows to specify wildcards (*?) for functions, like:
>
>   SEC("kprobe.multi/bpf_fentry_test*")
>   SEC("kretprobe.multi/bpf_fentry_test?")
>
> This will set kprobe's expected_attach_type to BPF_TRACE_KPROBE_MULTI,
> and attach it to functions provided by the function pattern.
>
> Using glob_match from selftests/bpf/test_progs.c and adding support to
> match '?' based on original perf code.
>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Yucong Sun <fallentree@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 130 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 125 insertions(+), 5 deletions(-)
>

[...]

> +static struct bpf_link *
> +attach_kprobe_multi_opts(const struct bpf_program *prog,
> +                  const char *func_pattern,
> +                  const struct bpf_kprobe_opts *kopts)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);

nit: just LIBBPF_OPTS


> +       struct kprobe_multi_resolve res = {
> +               .name = func_pattern,
> +       };
> +       struct bpf_link *link = NULL;
> +       char errmsg[STRERR_BUFSIZE];
> +       int err, link_fd, prog_fd;
> +       bool retprobe;
> +
> +       err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);

hm... I think as a generic API we should support three modes of
specifying attachment target:


1. glob-based (very convenient, I agree)
2. array of function names (very convenient when I know specific set
of functions)
3. array of addresses (advanced use case, so probably will be rarely used).



So I wonder if it's better to have a separate
bpf_program__attach_kprobe_multi() API for this, instead of doing both
inside bpf_program__attach_kprobe()...

In such case bpf_program__attach_kprobe() could either fail if
expected attach type is BPF_TRACE_KPROBE_MULTI or it can redirect to
attach_kprobe_multi with func_name as a pattern or just single
function (let's think which one makes more sense)

Let's at least think about this


> +       if (err)
> +               goto error;
> +       if (!res.cnt) {
> +               err = -ENOENT;
> +               goto error;
> +       }
> +
> +       retprobe = OPTS_GET(kopts, retprobe, false);
> +
> +       opts.kprobe_multi.addrs = ptr_to_u64(res.addrs);
> +       opts.kprobe_multi.cnt = res.cnt;
> +       opts.flags = retprobe ? BPF_F_KPROBE_MULTI_RETURN : 0;

this should be opts.kprobe_multi.flags

> +
> +       link = calloc(1, sizeof(*link));
> +       if (!link) {
> +               err = -ENOMEM;
> +               goto error;
> +       }
> +       link->detach = &bpf_link__detach_fd;
> +
> +       prog_fd = bpf_program__fd(prog);
> +       link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
> +       if (link_fd < 0) {
> +               err = -errno;
> +               pr_warn("prog '%s': failed to attach to %s: %s\n",

"to attach multi-kprobe for '%s': %s" ?

> +                       prog->name, res.name,
> +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               goto error;
> +       }
> +       link->fd = link_fd;
> +       free(res.addrs);
> +       return link;
> +
> +error:
> +       free(link);
> +       free(res.addrs);
> +       return libbpf_err_ptr(err);
> +}
> +
>  struct bpf_link *
>  bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
>                                 const char *func_name,
> @@ -10054,6 +10163,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
>         if (!OPTS_VALID(opts, bpf_kprobe_opts))
>                 return libbpf_err_ptr(-EINVAL);
>
> +       if (prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI)
> +               return attach_kprobe_multi_opts(prog, func_name, opts);
> +
>         retprobe = OPTS_GET(opts, retprobe, false);
>         offset = OPTS_GET(opts, offset, 0);
>         pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);

see how you don't support cookies (plural) and this offset doesn't
make sense for multi-kprobe. Separate API is necessary to expose all
the possibilities and functionality.

> @@ -10122,19 +10234,27 @@ struct bpf_link *bpf_program__attach_kprobe(const struct bpf_program *prog,
>  static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
> +       const char *func_name = NULL;
>         unsigned long offset = 0;
>         struct bpf_link *link;
> -       const char *func_name;
>         char *func;
>         int n, err;
>
> -       opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe/");
> -       if (opts.retprobe)
> +       opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe");
> +
> +       if (str_has_pfx(prog->sec_name, "kretprobe/"))
>                 func_name = prog->sec_name + sizeof("kretprobe/") - 1;
> -       else
> +       else if (str_has_pfx(prog->sec_name, "kprobe/"))
>                 func_name = prog->sec_name + sizeof("kprobe/") - 1;
> +       else if (str_has_pfx(prog->sec_name, "kretprobe.multi/"))
> +               func_name = prog->sec_name + sizeof("kretprobe.multi/") - 1;
> +       else if (str_has_pfx(prog->sec_name, "kprobe.multi/"))
> +               func_name = prog->sec_name + sizeof("kprobe.multi/") - 1;

starts to feel that we should find '/' and then do strcmp(), instead
of this duplication of strings?

> +
> +       if (!func_name)
> +               return libbpf_err_ptr(-EINVAL);
>
> -       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> +       n = sscanf(func_name, "%m[a-zA-Z0-9_.*?]+%li", &func, &offset);

'*' and '?' are still invalid for non-multi-kprobe...


>         if (n < 1) {
>                 err = -EINVAL;
>                 pr_warn("kprobe name is invalid: %s\n", func_name);
> --
> 2.35.1
>
