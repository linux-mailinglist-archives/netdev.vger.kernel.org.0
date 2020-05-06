Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489A01C678E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEFFoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgEFFoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:44:32 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77995C061A0F;
        Tue,  5 May 2020 22:44:30 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j2so432706qtr.12;
        Tue, 05 May 2020 22:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iuXQC6UATbUhdTWUBQYNdBX+Tj6TKYe03Ph3Iuc5xS8=;
        b=vC0MqmhpGX5tfqbt3vJKdMy+ZAgEOE/dbahj2eS71QozT77eCLdLf3BRIz754DLiPw
         YLTAtPCLBaLPDk5oO3H99qTyY61uvj2yWQQUSijrRLy+DWJTfB25hmnxIjv/ApIn8JDI
         kg0j5EYQNjhbCCdfLKz55M/G5ewMGoro3jnCoivOCwPOQfoFkHh43/hSLcZv/mNdh0Pj
         JKp80beVdCtA1Oit1Q24QIQkiGDtugqSfTD8IK2HN1yFBtNoTUv7gZSkHYHb+yNsXG4q
         dasMn0q9hvpFcYMfENUBAEq99wN7965fWjhN7Aj0jZbg5v1FxkENGN+T2koGKke9EC2u
         d8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iuXQC6UATbUhdTWUBQYNdBX+Tj6TKYe03Ph3Iuc5xS8=;
        b=s1gxxGY7XwlKx92J++132hcZujGp+VVaN/mAWeBNCLkXppsYmaxTdz1e1rTXjoZ+W5
         JTmeKE3ZcPX0Z0G5XcJtMURC0jEkJak1rdU03rXB2CbbaqAWXFB5eLPqW5K2QzrrfqNB
         0yYWwG1zw7M30GW2ew0OFkPwGFS0EeqfAERFaCe7hhS7CB3Y6kBGUPREtZ6je6v02vZN
         sNgXRU+G3yROkYKZhFb6f0qkNZRz6n8ox7A3BBVcbs/+uUahYTSTBT2q1c5Nokk9MFwo
         XySt4QwtGToB/sOKogZVeZVL1oE/4biFFmQ5el7nbrJxZPMAXR+tRpkmJQTH7lX9iRLD
         hIXQ==
X-Gm-Message-State: AGi0PubShZlGsh/QZLxP80WAobFfVCuXjM6NQ98xW6hItCza5+69qNgc
        Gd+gzmzfHvoSr+rs05FhBqnWtO6yDjvU53wIAT8=
X-Google-Smtp-Source: APiQypJhAcvQO0yuzZqPexR8C/tid+RjFe6SPEXB56tr6+Si3+O1VYaQrcIY2mhwL3XOql4PXyJdT2dedVdCDggCBx0=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr6351490qtd.117.1588743869521;
 Tue, 05 May 2020 22:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062605.2048882-1-yhs@fb.com>
In-Reply-To: <20200504062605.2048882-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 22:44:18 -0700
Message-ID: <CAEf4BzbWVtiyCk12jxtG=N-b1bwvt1NNUrAxJ9LgHU8Ki9F1gw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 16/20] tools/libbpf: add bpf_iter support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:27 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two new libbpf APIs are added to support bpf_iter:
>   - bpf_program__attach_iter
>     Given a bpf program and additional parameters, which is
>     none now, returns a bpf_link.
>   - bpf_iter_create
>     syscall level API to create a bpf iterator.
>
> The macro BPF_SEQ_PRINTF are also introduced. The format
> looks like:
>   BPF_SEQ_PRINTF(seq, "task id %d\n", pid);
>
> This macro can help bpf program writers with
> nicer bpf_seq_printf syntax similar to the kernel one.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks great! Just few nits.

>  tools/lib/bpf/bpf.c         | 11 +++++++++
>  tools/lib/bpf/bpf.h         |  2 ++
>  tools/lib/bpf/bpf_tracing.h | 16 +++++++++++++
>  tools/lib/bpf/libbpf.c      | 45 +++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h      |  9 ++++++++
>  tools/lib/bpf/libbpf.map    |  2 ++
>  6 files changed, 85 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 43322f0d6c7f..1756ae47ddf2 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -619,6 +619,17 @@ int bpf_link_update(int link_fd, int new_prog_fd,
>         return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
>  }
>
> +int bpf_iter_create(int link_fd, unsigned int flags)

As discussed in previous thread, given we don't anticipate needing
anything beyond link_fd, let's do bpf_iter_create(int link_fd), nice
and simple. Once we need to add any extensibility, we can add
bpf_iter_create_xattr() variant with opts.

> +{
> +       union bpf_attr attr;
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.iter_create.link_fd = link_fd;
> +       attr.iter_create.flags = flags;
> +
> +       return sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
> +}
> +

[...]

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 977add1b73e2..93355a257405 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6629,6 +6629,9 @@ static const struct bpf_sec_def section_defs[] = {
>                 .is_attach_btf = true,
>                 .expected_attach_type = BPF_LSM_MAC,
>                 .attach_fn = attach_lsm),
> +       SEC_DEF("iter/", TRACING,
> +               .expected_attach_type = BPF_TRACE_ITER,
> +               .is_attach_btf = true),

Another nit. As discussed, I think auto-attach is a nice feature,
which, if user doesn't want/need, can be skipped.

>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> @@ -6891,6 +6894,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
>

[...]

>
> +struct bpf_link *
> +bpf_program__attach_iter(struct bpf_program *prog,
> +                        const struct bpf_iter_attach_opts *opts)
> +{
> +       enum bpf_attach_type attach_type;
> +       char errmsg[STRERR_BUFSIZE];
> +       struct bpf_link *link;
> +       int prog_fd, link_fd;
> +
> +       if (!OPTS_VALID(opts, bpf_iter_attach_opts))
> +               return ERR_PTR(-EINVAL);
> +
> +       prog_fd = bpf_program__fd(prog);
> +       if (prog_fd < 0) {
> +               pr_warn("program '%s': can't attach before loaded\n",
> +                       bpf_program__title(prog, false));
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       link = calloc(1, sizeof(*link));
> +       if (!link)
> +               return ERR_PTR(-ENOMEM);
> +       link->detach = &bpf_link__detach_fd;
> +
> +       attach_type = BPF_TRACE_ITER;
> +       link_fd = bpf_link_create(prog_fd, 0, attach_type, NULL);

nit: attach_type variable doesn't seem to be necessary

> +       if (link_fd < 0) {
> +               link_fd = -errno;
> +               free(link);
> +               pr_warn("program '%s': failed to attach to iterator: %s\n",
> +                       bpf_program__title(prog, false),
> +                       libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(link_fd);
> +       }
> +       link->fd = link_fd;
> +       return link;
> +}
> +

[...]
