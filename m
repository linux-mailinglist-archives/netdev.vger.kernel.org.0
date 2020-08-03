Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04B239D44
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 03:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHCBkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 21:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHCBkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 21:40:39 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFB0C06174A;
        Sun,  2 Aug 2020 18:40:38 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id u43so6088021ybi.11;
        Sun, 02 Aug 2020 18:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIvJdyOzuGLb+Zojh+U9lDyJFRxoHNP9AKVQhedhbfs=;
        b=qo3krC/5s4se8mCR1BLNwK4VWaSmC1IDxpIbGXvDCjhFlk0KqS/GR81ZROtr0QWflT
         0uClIyx4QCNjAbYOqcjm0+3uxQB2P24lhicg7VtB2rLlMShDuKr/YO8Kqj0KrdOHpLnz
         W+jzNLTp/pAfCKbqrXss7BSRs321el1o7PsD1ImI1jnIGfP00c2z3TuOKFSMcUDXjBJN
         6Dq4wiaKzq0WPvPkr7Rh0Qob9KRsYYlRgbjizRf7q7bMDZnnmO6SHlLgUPt+M7mN0y22
         4CTEX/pA2EmqpkUzzUbqgzEoMTGhgz+SxZu14G0TzabihVL9IBSFGlVwxdEDs5MHud47
         CTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIvJdyOzuGLb+Zojh+U9lDyJFRxoHNP9AKVQhedhbfs=;
        b=A3H+VjF6cgQM8L5095hV5QoZgW4zXYY1kuAVg2eiJJE5TmGSAtf6e2rPglgocKJ0s2
         l4S3CBTYhRVol9CmRZg8N0B04EVkdHPaN6xrWZl6w8FbTKZre+YStlOZsGizelKNn/1Y
         d/BsPPWefr1odKi4I5Pkx+1Jktz2Exkz/O5+tIusB2oyeiLhF1fMQv4KULmPpH+g5EE7
         j5juM/DuPwCST7G7AAvOFbJuoiwjdoapmqEk6g8PXXdThGibFq3G3x/Dd1AQmTGtYl5A
         GywEVTRJYYraSyHuBupdbxaVpRP63ITsJAKUfUXD9tVZJlQoNFcPM2XbFExA606IgBuD
         UBcA==
X-Gm-Message-State: AOAM533xcRzCV7rnrfJU9HS/OkXTmi7qDKdIle4UY6rG2Sk1YyQZupDt
        OolFyTThevXWlyTqIGdeleeLVP+btjbNTVy/jYs5CQ==
X-Google-Smtp-Source: ABdhPJx+CRJvFSjRrIr/OeivdlP3UZ772kyYEHNvys7X6RDyFK0aTNJT37ZEGv3rYJOdXUVWEif247nqio4Z2bgkRdw=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr22817105ybm.425.1596418838070;
 Sun, 02 Aug 2020 18:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com> <20200801084721.1812607-3-songliubraving@fb.com>
In-Reply-To: <20200801084721.1812607-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 18:40:27 -0700
Message-ID: <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>
> Add cpu_plus to bpf_prog_test_run_attr. Add BPF_PROG_SEC "user" for
> BPF_PROG_TYPE_USER programs.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/lib/bpf/bpf.c           | 1 +
>  tools/lib/bpf/bpf.h           | 3 +++
>  tools/lib/bpf/libbpf.c        | 1 +
>  tools/lib/bpf/libbpf_probes.c | 1 +
>  4 files changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index e1bdf214f75fe..b28c3daa9c270 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -693,6 +693,7 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
>         attr.test.ctx_size_in = test_attr->ctx_size_in;
>         attr.test.ctx_size_out = test_attr->ctx_size_out;
>         attr.test.repeat = test_attr->repeat;
> +       attr.test.cpu_plus = test_attr->cpu_plus;
>
>         ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
>         test_attr->data_size_out = attr.test.data_size_out;
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 6d367e01d05e9..0c799740df566 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -205,6 +205,9 @@ struct bpf_prog_test_run_attr {
>         void *ctx_out;      /* optional */
>         __u32 ctx_size_out; /* in: max length of ctx_out
>                              * out: length of cxt_out */
> +       __u32 cpu_plus;     /* specify which cpu to run the test with
> +                            * cpu_plus = cpu_id + 1.
> +                            * If cpu_plus = 0, run on current cpu */

We can't do this due to ABI guarantees. We'll have to add a new API
using OPTS arguments.

>  };
>
>  LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b9f11f854985b..9ce175a486214 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] = {
>         BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
>         BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
>         BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOCAL),
> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),

let's do "user/" for consistency with most other prog types (and nice
separation between prog type and custom user name)


>         BPF_APROG_SEC("cgroup_skb/ingress",     BPF_PROG_TYPE_CGROUP_SKB,
>                                                 BPF_CGROUP_INET_INGRESS),
>         BPF_APROG_SEC("cgroup_skb/egress",      BPF_PROG_TYPE_CGROUP_SKB,
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index 5a3d3f0784081..163013084000e 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -112,6 +112,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
>         case BPF_PROG_TYPE_STRUCT_OPS:
>         case BPF_PROG_TYPE_EXT:
>         case BPF_PROG_TYPE_LSM:
> +       case BPF_PROG_TYPE_USER:
>         default:
>                 break;
>         }
> --
> 2.24.1
>
