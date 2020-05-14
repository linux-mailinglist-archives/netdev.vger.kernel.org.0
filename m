Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC73C1D407C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgENWGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgENWGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:06:13 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEDAC061A0C;
        Thu, 14 May 2020 15:06:13 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id t25so302428qtc.0;
        Thu, 14 May 2020 15:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckfBHrfjRkNbazznJgQdJg25aWGLlrD5iE8Qkmuzz8U=;
        b=n6JzfrSjAz8AOXj5gc+KHxO3/967eEszvUmfVgJsNqVcPzxCNdel8CxWVgyZ/23SXM
         od8i/pKG2Lf99/icAcqo6gKNaKTnAk9a5EXa+uYHKkQqfJI9N00m9G3iSEKiu1jQGF0P
         HL0Puer8J36uaR1tvutjJmBImaUBo78RwcAm7M6gGMCuqZyjXYfNhA7E3//lJoDOu28Q
         MGFTIqDj9mS5xPdfLtKPmcYnbxQxRs7Gjo2y8ht+1V1wHvTl38JPMzIAiAdaAgEBlH6k
         7lu8u5yaTwTIP/PQKVrabrCijW5cwRSkWq7rqTjOQIRFRoRqlb4aazUurXWWuLMoh1mV
         ZTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckfBHrfjRkNbazznJgQdJg25aWGLlrD5iE8Qkmuzz8U=;
        b=T91LUP0t2nRWmyrqcua9z3sZw7lJHhQQUKLRZKkswmxayjeg/LJqMJ/tSb901CI8Yi
         NCDu8Hup7UpW0oxf/fcvGnpPusHe2X8cgkQyvxr7K05PVFeD2uLw+1LBLKtd4wbxO62M
         dzF+wsDWRvTOwXE65sohO0WZudtFJhUeWN6usS7E2sd1961UkqjL4XjHrA34YkP98YQC
         iehVos0pAeKYw4VYxCyL2vUCaIW4jXw6oM8C2QnlgKuOVjEKwHtbSqYRkp4nL5GF1tZx
         gWKENtoIjhdyzAH48nZ4ailkzMxm78MgbaM/EkPvvl90u/oiN0FF+kU/2+HAriR5YTmK
         H0yA==
X-Gm-Message-State: AOAM5305jLFbvnFjP4D1joocCAOEw3By+Z+saHFxevE3IEvM9cXjdfLC
        Dqaxvc3Fc/1xapJom2NvnApTtnHCSZcvCJV9brk=
X-Google-Smtp-Source: ABdhPJxpLxW5ruHrhFc9yxVFWxLImiUxhcKJLBDq0piYrLBJliV93f1WRTVgKq7cyo91eX+1rW6OvXqjX/3aHxhc75U=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr344999qtc.93.1589493972293;
 Thu, 14 May 2020 15:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-2-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 15:06:01 -0700
Message-ID: <CAEf4BzaiTFasYEnj-N100=mxQN5R70xKbF4Z2xJcWHaaYN4_ag@mail.gmail.com>
Subject: Re: [PATCH 1/9] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path
> for give 'struct path' object, which needs to be the
> kernel BTF 'path' object.
>
> The helper calls directly d_path function.
>
> Updating also bpf.h tools uapi header and adding
> 'path' to bpf_helpers_doc.py script.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 14 +++++++++++++-
>  kernel/trace/bpf_trace.c       | 31 +++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 14 +++++++++++++-
>  4 files changed, 59 insertions(+), 2 deletions(-)
>

[...]

>
> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> +{
> +       char *p = d_path(path, buf, sz - 1);
> +       int len;
> +
> +       if (IS_ERR(p)) {
> +               len = PTR_ERR(p);
> +       } else {
> +               len = strlen(p);
> +               if (len && p != buf) {
> +                       memmove(buf, p, len);
> +                       buf[len] = 0;
> +               }
> +       }
> +
> +       return len;
> +}
> +
> +static u32 bpf_d_path_btf_ids[3];

Using shorter than 5 element array is "unconventional", but seems like
btf_distill_func_proto will never access elements that are not
ARG_PTR_TO_BTF_ID, so it's fine. But than again, if we are saving
space, why not just 1-element array? :)


> +static const struct bpf_func_proto bpf_d_path_proto = {
> +       .func           = bpf_d_path,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE,
> +       .btf_id         = bpf_d_path_btf_ids,
> +};
> +

[...]

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index b3643e27e264..bc13cad27872 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3068,6 +3068,17 @@ union bpf_attr {
>   *             See: clock_gettime(CLOCK_BOOTTIME)
>   *     Return
>   *             Current *ktime*.
> + *
> + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> + *     Description
> + *             Return full path for given 'struct path' object, which
> + *             needs to be the kernel BTF 'path' object. The path is
> + *             returned in buffer provided 'buf' of size 'sz'.
> + *

Please specify if it's always zero-terminated string (especially on truncation).

> + *     Return
> + *             length of returned string on success, or a negative
> + *             error in case of failure
> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3195,7 +3206,8 @@ union bpf_attr {
>         FN(get_netns_cookie),           \
>         FN(get_current_ancestor_cgroup_id),     \
>         FN(sk_assign),                  \
> -       FN(ktime_get_boot_ns),
> +       FN(ktime_get_boot_ns),          \
> +       FN(d_path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> --
> 2.25.4
>
