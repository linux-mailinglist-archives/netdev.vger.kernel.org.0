Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146751C630F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgEEV3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728737AbgEEV3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:29:20 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8872AC061A0F;
        Tue,  5 May 2020 14:29:20 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k12so3384555qtm.4;
        Tue, 05 May 2020 14:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q5y6wSZrPYeT5Tn8QEDzVFrDmjHP6VBbR44zyDeHrzc=;
        b=lPBE1psPjy6Bwb4vxGWEqn1DljS9jR78QxQSlD/Xd6i//S8l89VPav9aJmPR407ZSL
         R05oc+nKPtjyIrut0wn1LfOzxmliNCX17i1CEKl4AhO5DCJnXgkDdHx3KZMzybPzTeOk
         GjM8ZmovFm6KyRgwYmZwWKuRqAXzQwkcw298RkR6lFh9JZWF33yCpfTeTZGtb5P3bbrn
         5HTd/bFtyvmurtIKP9Z2kn9LaRJen+nKNs0kpZoNGSlUQsbgz5Jv1Y+aIljJQ/+5nGEC
         /Ow3F+3N7S/bU4LVjN92e1BVplbXSUi03DzejnqmN2rPl7q1Zx/QAqMhRDOcLOWGEmaL
         As7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q5y6wSZrPYeT5Tn8QEDzVFrDmjHP6VBbR44zyDeHrzc=;
        b=cSlBfm2S3DLQHoFOshmfr2JJ4GyBqT2PkcYdG6t+YEXzOHhlbwYg4ZxgNbhJe0D8CS
         ZQXuFpnjN7wW017OjTPRSmzxUZuedOdCS9LNqmxkqh//rcD0ei/CzsC/aOVM/9DwRxtz
         +S4v4hxtISZyDGbl6PqrK377bnkvV0riTnoxTCoBYnZczEH+kf4N7jUrHLlXPRjUXB50
         mqmY1FuKz0C9XLXiK2B5s3tywEjc2yRx0myX2eNXLAxETIrS/w32o8COrw3+ai3zSMKC
         SnOYiG0mC3UeAHMNPH/dlqTAmzhNh5uthk2RGJQXvcKNQ+oyP93/ydE7Lj8lV7WgbWvZ
         e81w==
X-Gm-Message-State: AGi0PuaH35ZrG/HADTurhdZIu7gVg8lgKjLzfn20A1fGBkEDRG6Idg2t
        k0ddessWFv+sshWobhrvavc9ShtleQNgybngbPpjDw==
X-Google-Smtp-Source: APiQypLIDRFMwJCOfKBbhOCHZHAh8cCTGQPAmk9QJy7tmbmIDmAju1P78M0ftzNJ4vlMwUFOGTo65hEI0zSq8NGrFhY=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr4616126qtj.93.1588714159580;
 Tue, 05 May 2020 14:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062548.2047454-1-yhs@fb.com>
In-Reply-To: <20200504062548.2047454-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:29:08 -0700
Message-ID: <CAEf4BzY456K4YJt6JhGD4y0uDfdwmzJvHDjze=Cct9Akf1-9gA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/20] bpf: allow loading of a bpf_iter program
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

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> A bpf_iter program is a tracing program with attach type
> BPF_TRACE_ITER. The load attribute
>   attach_btf_id
> is used by the verifier against a particular kernel function,
> which represents a target, e.g., __bpf_iter__bpf_map
> for target bpf_map which is implemented later.
>
> The program return value must be 0 or 1 for now.
>   0 : successful, except potential seq_file buffer overflow
>       which is handled by seq_file reader.
>   1 : request to restart the same object

This bit is interesting. Is the idea that if BPF program also wants to
send something over, say, perf_buffer, but fails, it can "request"
same execution again? I wonder if typical libc fread() implementation
would handle EAGAIN properly, it seems more driven towards
non-blocking I/O?

On the other hand, following start/show/next logic for seq_file
iteration, requesting skipping element seems useful. It would allow
(in some cases) to "speculatively" generate output and at some point
realize that this is not an element we actually want in the output and
request to ignore that output.

Don't know how useful the latter is going to be in practice, but just
something to keep in mind for the future, I guess...

>
> In the future, other return values may be used for filtering or
> teminating the iterator.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |  3 +++
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/bpf_iter.c          | 30 ++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 21 +++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  5 files changed, 56 insertions(+)
>

[...]


> +
> +bool bpf_iter_prog_supported(struct bpf_prog *prog)
> +{
> +       const char *attach_fname = prog->aux->attach_func_name;
> +       u32 prog_btf_id = prog->aux->attach_btf_id;
> +       const char *prefix = BPF_ITER_FUNC_PREFIX;
> +       struct bpf_iter_target_info *tinfo;
> +       int prefix_len = strlen(prefix);
> +       bool supported = false;
> +
> +       if (strncmp(attach_fname, prefix, prefix_len))
> +               return false;
> +
> +       mutex_lock(&targets_mutex);
> +       list_for_each_entry(tinfo, &targets, list) {
> +               if (tinfo->btf_id && tinfo->btf_id == prog_btf_id) {
> +                       supported = true;
> +                       break;
> +               }
> +               if (!strcmp(attach_fname + prefix_len, tinfo->target)) {
> +                       tinfo->btf_id = prog->aux->attach_btf_id;

This target_info->btf_id caching here is a bit subtle and easy to
miss, it would be nice to have a code calling this out explicitly.
Thanks!

> +                       supported = true;
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&targets_mutex);
> +
> +       return supported;
> +}
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 70ad009577f8..d725ff7d11db 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
>                         return 0;
>                 range = tnum_const(0);
>                 break;
> +       case BPF_PROG_TYPE_TRACING:
> +               if (env->prog->expected_attach_type != BPF_TRACE_ITER)
> +                       return 0;

Commit message mentions enforcing [0, 1], shouldn't it be done here?


> +               break;
>         default:
>                 return 0;
>         }

[...]
