Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE5F20C41C
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgF0UgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgF0UgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:36:07 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF7AC061794;
        Sat, 27 Jun 2020 13:36:07 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i3so10079664qtq.13;
        Sat, 27 Jun 2020 13:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QF9f+Rg1YYuEeJsfnLdQA699aX0YoszaiVUdkbqvUyA=;
        b=l2qSYlPPxLlgC2C+QFkcIrtXuiyv+/P8+5eYXssNmYZ6JJxfuhIJ5i5WuNMVoRfEiQ
         wVXDZG60QWkC++AEiY2eAuksz90jYnk1ci303IvHnzeTUCTDbXEXBEE71jq+6PqdMC5N
         7KfOtJNs9270hgOu4hAUxv+M9dcUzSvJMdoJ2/DrRvwcgbua96U7vPeMVeavJ5ssMI0S
         rFkdT/cHnwa0w+0W0rslpdP7ENKcNuSUNp3bPK1KA6eAkzbquvX/fnjz+COPRmXDtjmf
         iuzMBefUOW9msE+3Hg+tlNoyeS+QMGSR8vDG+ecHOq6b7YAEo6Nd7LPWZCguiEkTuQPH
         +GQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QF9f+Rg1YYuEeJsfnLdQA699aX0YoszaiVUdkbqvUyA=;
        b=NJMC1TYbCxE/XRfvH5j381++l/9hlpe7aq1KEoVuibzAXl9eH7pjdtXgLJ5y/pUiJ9
         kxVXHBn57F/hII396wRalhWskZpu0yGZfKZkQZ97p7Gr6HDSiYnDAQkxsPwKKDWmgS6G
         yhM+8XBsMSdUrtC3s1bYtKeBmuhC1DmIJT4smfwY4c3NUZtWkvZsYkdeXR1vBIBlxjUs
         qgfR3V5n4T0KmFh8zAEFur2S9MV0NCnFzd7fDoxNib2/HEdGpa3/8W6UY0KBW8PCdAY3
         +1z+ILZcTfMbuGBYzvuvga9tpp1ylhiA/OLwAJUPG527OMA1ugxPCWC7kEfLr13f9iOV
         mLCQ==
X-Gm-Message-State: AOAM531NZC1u5ot+pYBZQQo/F+xfTU/j5HqdHC3pIhr8KquewWqxWbso
        HdbETm+WlPhBb71cVQWYJfXnjF19QHuyj04bWqg=
X-Google-Smtp-Source: ABdhPJxsAtwdz6pVOxkxKggJEhfpff6cRTCOX2gNYQKs1fXG/B3V7AdUGWSBrutxY1dYHFbzGjJgdEIr08ZUArfKk/g=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr8949678qtp.141.1593290166497;
 Sat, 27 Jun 2020 13:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200627002609.3222870-1-songliubraving@fb.com> <20200627002609.3222870-4-songliubraving@fb.com>
In-Reply-To: <20200627002609.3222870-4-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jun 2020 13:35:55 -0700
Message-ID: <CAEf4BzbnkL3zGiDSGeOmcw2T8vA9tkuNbysky_Rc+WEF9PodGg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] bpf: introduce helper bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 5:29 PM Song Liu <songliubraving@fb.com> wrote:
>
> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
> task. This is different to bpf_get_stack(), which gets stack track of
> current task. One potential use case of bpf_get_task_stack() is to call
> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>
> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
> get_perf_callchain() for kernel stack. The benefit of this choice is that
> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
> stack trace to unsigned long array. For 32-bit systems, we need to
> translate it to u64 array.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 36 +++++++++++++++-
>  kernel/bpf/stackmap.c          | 75 ++++++++++++++++++++++++++++++++--
>  kernel/bpf/verifier.c          |  4 +-
>  kernel/trace/bpf_trace.c       |  2 +
>  scripts/bpf_helpers_doc.py     |  2 +
>  tools/include/uapi/linux/bpf.h | 36 +++++++++++++++-
>  7 files changed, 150 insertions(+), 6 deletions(-)
>

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7de98906ddf4a..b608185e1ffd5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4864,7 +4864,9 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>         if (err)
>                 return err;
>
> -       if (func_id == BPF_FUNC_get_stack && !env->prog->has_callchain_buf) {
> +       if ((func_id == BPF_FUNC_get_stack ||
> +            func_id == BPF_FUNC_get_task_stack) &&
> +           !env->prog->has_callchain_buf) {
>                 const char *err_str;
>

I'm glad it was so simple :) Thanks for checking!

[...]
