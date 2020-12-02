Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756842CB29E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgLBCFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgLBCFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 21:05:42 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7485FC0613CF;
        Tue,  1 Dec 2020 18:05:02 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id v92so206898ybi.4;
        Tue, 01 Dec 2020 18:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hgxbXV9qhOchZOi+op1XMneUAlJ/ttmy4OGLuSMcgHo=;
        b=C+ieUmEycsl9NIrqHrxBqMbhxY4wPTRVv8VdEUawYoGB3nB+qchFY3UeZ1FKuvFcQl
         Q8O2b3uiMczypDrsfXThykp76duFZNtkrlSROZr2oSaZWd80FyvkEBHbUj5+IQ2p64M8
         eR8aj7QeauqMpFiU7xMKRtq+9pWWQ6LOv3Gzmber4g6vIyuLDVxRjiNb2DJxP5xeeX9U
         xzqtOwtG4pDDnNYg5iFzNONJONqqGYfRt/nnswWmI5FNB9bTmSdEjiu7anmlClAW40FK
         dsE1MIm7aH4+DyiLDss8aaEB7MrAOsnYAG9TABVlMBrPe4X/jzUAVHLyDhsoB9TGwCoo
         4xng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hgxbXV9qhOchZOi+op1XMneUAlJ/ttmy4OGLuSMcgHo=;
        b=SaV1daRtyZCC8QfZWp9pND+8C9CT8fwfxM1GPnVaVOWvYdsch5ZZdmVG/vf6K+FxBp
         HBrdbmFcyujRUDA5hat6kaZj1/PXOdFYU+rT0LRa2rf0UK942xwMIRlGH6oaTRHZsYyn
         u6DLcVZp+lZEEyoaqQHiplzhJz+drOwZ1gnj+3reQwKB6YH6509jIWYUYkMz6saw6bVq
         f2xLb/PXMep2hRJ6thF7spII6gVuCI0eSuDOueXGnQpXgwlD9ERZD9RqIoYyox012AHw
         SsVy9NMJ4FzSslyACmWIT9tZkmx/EfRlpO3x+LVzJT/xDcO+f9uBQpA0I8wzPg9UhYOu
         eyuw==
X-Gm-Message-State: AOAM53280pMgwVhm0lJ1gg4pj+fV1huwI06Yr+uoe0BUKeOgv2yZVpQJ
        8oR0qiDVmRb7/E6Q6tslHAe0Qs1GH19N6QS32M8=
X-Google-Smtp-Source: ABdhPJxfbPM/JV4Ltlgn4bPymfnQnksoPYz/dnGJv3O7jvHMcVbr7hTQ1gxbN+mX/pd7v5uFC0FXGdodneOKnh30xzg=
X-Received: by 2002:a25:7717:: with SMTP id s23mr485353ybc.459.1606874701636;
 Tue, 01 Dec 2020 18:05:01 -0800 (PST)
MIME-Version: 1.0
References: <20201201144418.35045-1-kuniyu@amazon.co.jp> <20201201144418.35045-7-kuniyu@amazon.co.jp>
In-Reply-To: <20201201144418.35045-7-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 18:04:50 -0800
Message-ID: <CAEf4Bza2K9zPqPWTFp+yUN+najdjqY-sNtZ7T5=V=s66bqDavg@mail.gmail.com>
Subject: Re: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for BPF_PROG_TYPE_SK_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        osa-contribution-log@amazon.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 6:49 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
> check if the attached eBPF program is capable of migrating sockets.
>
> When the eBPF program is attached, the kernel runs it for socket migration
> only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> The kernel will change the behaviour depending on the returned value:
>
>   - SK_PASS with selected_sk, select it as a new listener
>   - SK_PASS with selected_sk NULL, fall back to the random selection
>   - SK_DROP, cancel the migration
>
> Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
> Suggested-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/uapi/linux/bpf.h       | 2 ++
>  kernel/bpf/syscall.c           | 8 ++++++++
>  tools/include/uapi/linux/bpf.h | 2 ++
>  3 files changed, 12 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 85278deff439..cfc207ae7782 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -241,6 +241,8 @@ enum bpf_attach_type {
>         BPF_XDP_CPUMAP,
>         BPF_SK_LOOKUP,
>         BPF_XDP,
> +       BPF_SK_REUSEPORT_SELECT,
> +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index f3fe9f53f93c..a0796a8de5ea 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
>                 if (expected_attach_type == BPF_SK_LOOKUP)
>                         return 0;
>                 return -EINVAL;
> +       case BPF_PROG_TYPE_SK_REUSEPORT:
> +               switch (expected_attach_type) {
> +               case BPF_SK_REUSEPORT_SELECT:
> +               case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
> +                       return 0;
> +               default:
> +                       return -EINVAL;
> +               }

this is a kernel regression, previously expected_attach_type wasn't
enforced, so user-space could have provided any number without an
error.

>         case BPF_PROG_TYPE_EXT:
>                 if (expected_attach_type)
>                         return -EINVAL;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 85278deff439..cfc207ae7782 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -241,6 +241,8 @@ enum bpf_attach_type {
>         BPF_XDP_CPUMAP,
>         BPF_SK_LOOKUP,
>         BPF_XDP,
> +       BPF_SK_REUSEPORT_SELECT,
> +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> --
> 2.17.2 (Apple Git-113)
>
