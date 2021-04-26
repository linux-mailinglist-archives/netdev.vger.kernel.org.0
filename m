Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8D36B738
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhDZQwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZQwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:52:23 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB192C061574;
        Mon, 26 Apr 2021 09:51:41 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z1so65672962ybf.6;
        Mon, 26 Apr 2021 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gmabQfmpCoCpN6QcluH7NmxJIEkvx+GscjJi0gkIe+U=;
        b=Kg6PvH6iCYktA4b9MSIhCJHofevgMN7dQHJDiUrabR9iZr5ankTbtUMy9TSBUIzdtD
         fh/ZmT6MHTlssjtqtEi16tsuraEdorglZw837bYPSfbnbtOt3J5ykUfPGFyUz0ZQ0QCp
         O6AFCUSmhMs7PMCUTkhdIH6TPtJ/sMehlu9jF9i/Z9WTOtA5O3DCxJipanNKcRw3UaGd
         24AjGCAWazH/UcWKjMAf1bDO0TaDwOUhTk6bHrkknbmqcOwpqoAOGpZo6GSGqGz5cXhH
         PCcCZ+CncPGvef8ibUDefDEQ+f1xxoBek0/EH36aqA3s/BXSRfkKaqBj17FeofBBxl/7
         +K1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gmabQfmpCoCpN6QcluH7NmxJIEkvx+GscjJi0gkIe+U=;
        b=htwRvheQblhZ2ZpLzJ9wH9c/3rtpQkHugi+Hz2X0YlHMVJTpnAbrwOe90CczHP2fjo
         7HSGvxKV7eJMG6l3N8R0eYvhFc7tWb0qVKnW4HJxGhn7bcM1g9V5Rz9ygqqmnp/oCYk8
         80XhVls3TTolNay4YUlv0KYUfEhkaZo/8w8iMIPfYPEv4e/6o9dl88KfXUe2ymMxAe+o
         0xTXHpQDeWZ5DaYbY3AOWY5GO6SMUSsAPwZfvnAf2ah0vjK6IRrXcnHpTR4VXXIoPoqf
         bMkeMEJKsIIMeXGAhyBhIYZDZFbtjOn/tQnmIoFDXTq/GodDZnpR0jMWOFNQpS8u5tW7
         RAUg==
X-Gm-Message-State: AOAM532wCZ7UgCtNeXMssB0pL72D2P1Camr2TOPu9nDg8+yeJO9FnBwo
        Z5HqVfDcnlOPp/0TnXrQ0XZEg7AJgCFWkTtb3p0=
X-Google-Smtp-Source: ABdhPJxZXypkBbrHMcisJjLOigy+ASsJUbEDuCE1QDqy8OuvaPPdUxXqR0MVsHgYu9I/PkuRui7+bHFjFzFX5s2UTek=
X-Received: by 2002:a25:2a0a:: with SMTP id q10mr24348745ybq.403.1619455901115;
 Mon, 26 Apr 2021 09:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 09:51:30 -0700
Message-ID: <CAEf4BzY5BrSOWj8zc+hBd5jm_p4OaH7gzR5voEwOwvQFPvBcPw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 01/16] bpf: Introduce bpf_sys_bpf() helper and
 program type.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add placeholders for bpf_sys_bpf() helper and new program type.
>
> v1->v2:
> - check that expected_attach_type is zero
> - allow more helper functions to be used in this program type, since they will
>   only execute from user context via bpf_prog_test_run.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM, see minor comments below.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf.h            | 10 +++++++
>  include/linux/bpf_types.h      |  2 ++
>  include/uapi/linux/bpf.h       |  8 +++++
>  kernel/bpf/syscall.c           | 54 ++++++++++++++++++++++++++++++++++
>  net/bpf/test_run.c             | 43 +++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  8 +++++
>  6 files changed, 125 insertions(+)
>

[...]

> +
> +const struct bpf_func_proto * __weak
> +tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +

extra empty line

> +       return bpf_base_func_proto(func_id);
> +}
> +
> +static const struct bpf_func_proto *
> +syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +       switch (func_id) {
> +       case BPF_FUNC_sys_bpf:
> +               return &bpf_sys_bpf_proto;
> +       default:
> +               return tracing_prog_func_proto(func_id, prog);
> +       }
> +}
> +

[...]

> +       if (ctx_size_in) {
> +               ctx = kzalloc(ctx_size_in, GFP_USER);
> +               if (!ctx)
> +                       return -ENOMEM;
> +               if (copy_from_user(ctx, ctx_in, ctx_size_in)) {
> +                       err = -EFAULT;
> +                       goto out;
> +               }
> +       }
> +       retval = bpf_prog_run_pin_on_cpu(prog, ctx);
> +
> +       if (copy_to_user(&uattr->test.retval, &retval, sizeof(u32)))
> +               err = -EFAULT;

is there a point in trying to do another copy_to_user if this fails?
I.e., why not goto out here?

> +       if (ctx_size_in)
> +               if (copy_to_user(ctx_in, ctx, ctx_size_in)) {
> +                       err = -EFAULT;
> +                       goto out;
> +               }
> +out:
> +       kfree(ctx);
> +       return err;
> +}

[...]
