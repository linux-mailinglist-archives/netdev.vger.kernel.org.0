Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE533D324B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhGWDC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbhGWDC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 23:02:29 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49045C061575;
        Thu, 22 Jul 2021 20:43:02 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k65so237451yba.13;
        Thu, 22 Jul 2021 20:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/5wFHJEYYmg3UVxQegWN5AsD0dJEwij1lU8O3PVKE0=;
        b=AxuwMOcPmleiwgARP9WLjx9bAsX5biNduyDESqMWmeCJcUHe2BbEit/IxeVW81lbMv
         NGvbVthnmvY+u7HhuXqI8Lxp3MNpIE4JCGuilYzl03OtYkFNSz9t/tfOyUHSqVAFuxgK
         qdb0FY3aOxfpRi3NV96wL/jqw76GIh8tviFNKPXniDaPapotcz1KtCvNMc5Wav0lYBbv
         Z2Cz3gt1TAgy962+HyK4dKgzNyWZ8cQzT9huBJAySI1tHkdHGbrxRs+GNTeO8ZUszDeW
         4d5pShWbEYuIfcfJc8Vpo4umP2M6KXeFd1zHzMy0NLkSQri95/gi6navWN/iWlnZf4Nt
         /eTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/5wFHJEYYmg3UVxQegWN5AsD0dJEwij1lU8O3PVKE0=;
        b=gXUfwFAR9eiQ5BF4/ZhfXJJNOqAwlS6tJcEYzV8cJbaP72ouSLWpUUqUCmlG8mrdCZ
         Jxy8Er/+EPo0tDN/kzw9hIAXPy2kl9lf2ZTSA1mnDuBuHe8FEedqDDyHx1Okz7KG1/v8
         PFtSCY6VBawQCMJQJTzxDp1sDxgju/iMLqH5Qzo1TV6u30P2uCaODPZZwkcpXR8olVF0
         u/5VPNMVm6mNiZ9tLkCF+eq01/fFKCahWuifR+WrJcYcN6K1RTbNeIoWsYbVTtXTi3dw
         3/11yfT2x59QwnB9o80pzAQO+382/9HJ70bN0Trt5vpcF4ECczQGpoyZQMGDo0eKCzrq
         v4cg==
X-Gm-Message-State: AOAM530WfIwqrvFkkDVNE5EvkIF9PXuUpUD+fSCl7k3kMnk/FxbLq6/C
        UJ6hSgNdWiIv0LzsHbk7tH9rXGn/H6QN8lbpnCw=
X-Google-Smtp-Source: ABdhPJwvFrzpfRk8XlKAK0ZufnbWjh+isdEBbrzaTSrwn1Nbl1WwexXk10ebiFprArNuIfKQRE8uxFIqWcGiUEz5zMA=
X-Received: by 2002:a25:bd09:: with SMTP id f9mr3829646ybk.27.1627011781592;
 Thu, 22 Jul 2021 20:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210721212833.701342-1-memxor@gmail.com> <20210721212833.701342-4-memxor@gmail.com>
In-Reply-To: <20210721212833.701342-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 20:42:50 -0700
Message-ID: <CAEf4BzZEHLp=4H4RjTvFVLWaVdJTyRXRAoxNmJW+VcwbQKVSHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/8] samples: bpf: Add BPF support for XDP
 samples helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 2:28 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> These eBPF tracepoint programs export data that is consumed by the
> helpers added in the previous commit.
>
> Also add support int the Makefile to generate a vmlinux.h header that
> would be used by other bpf.c files in later commits.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  samples/bpf/Makefile         |  25 ++++
>  samples/bpf/xdp_sample.bpf.c | 215 +++++++++++++++++++++++++++++++++++
>  samples/bpf/xdp_sample.bpf.h |  57 ++++++++++
>  3 files changed, 297 insertions(+)
>  create mode 100644 samples/bpf/xdp_sample.bpf.c
>  create mode 100644 samples/bpf/xdp_sample.bpf.h
>

[...]

> +
> +SEC("tp_btf/xdp_cpumap_kthread")
> +int BPF_PROG(tp_xdp_cpumap_kthread, int map_id, unsigned int processed,
> +            unsigned int drops, int sched, struct xdp_cpumap_stats *xdp_stats)
> +{
> +       // Using xdp_stats directly fails verification

nit: C++ style comment

> +       u32 cpu = bpf_get_smp_processor_id();
> +       struct datarec *rec;
> +
> +       if (cpu < MAX_CPUS) {

tip: if you invert condition and exit early, the rest of your logic
will be less nested (same in few other places)

> +               rec = &sample_data.cpumap_kthread_cnt[cpu];
> +
> +               ATOMIC_ADD_NORMW(rec->processed, processed);
> +               ATOMIC_ADD_NORMW(rec->dropped, drops);
> +               ATOMIC_ADD_NORMW(rec->xdp_pass, xdp_stats->pass);
> +               ATOMIC_ADD_NORMW(rec->xdp_drop, xdp_stats->drop);
> +               ATOMIC_ADD_NORMW(rec->xdp_redirect, xdp_stats->redirect);
> +               /* Count times kthread yielded CPU via schedule call */
> +               if (sched)
> +                       ATOMIC_INC_NORMW(rec->issue);
> +       }
> +       return 0;
> +}
> +

[...]
