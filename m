Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE3488E8E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiAJCE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbiAJCE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:04:57 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E22C06173F;
        Sun,  9 Jan 2022 18:04:57 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id y70so15641344iof.2;
        Sun, 09 Jan 2022 18:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8l1Nw+9feNI9I+xJlgSlKIK03FhT3WbqUTtWCf+KU4M=;
        b=HOix9AIWi8jjOngrlgdZ3U68ALIGoDnhP9YJAqHM+iv7BtmYDllTlm5M3QPfIwbaX6
         Q8swj8e+C1eOPJ+PZ668u4TqG3p7pJeENl7nTRcZ5zc4mQKMroAC60pTzkZ3ZiC0HiZk
         8VDnEwe5/dC0h8u8Uz8RGXkS4TPUP3wvYztqSged8D/Ohn6i7yFak22fA5JCLfxGnhQD
         +Ai9kiVWaH1Q3mx3XH+ot7r1oe5oPu2iNlu0jzd70X3Jw/RUyzj4lIXgXL8JuFtSFICG
         ilzz12BW1V/hkAOyEej51KI3vWA6OxBdpbXkNcbptXK8HtK1XefMF6N0i5RxyIwvXC7A
         9u4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8l1Nw+9feNI9I+xJlgSlKIK03FhT3WbqUTtWCf+KU4M=;
        b=s4Xbvyf+q/u4iDrBLYC+iaqYsveBcFl8taO+K6gBxAyMw5Lj/Pwy5brfuk/9lM9Nba
         74zv3oClc/Rj78YI7RKY4SItnMl1qztvqvIqjPnHQjpDPIiRPqsbdfe/T26Jed/2gcTl
         z7WZgBILshh4UI1HUU91qhRHqTpG7QE52uBXvmZopYMSoQFFNCTXcf0msbqHDtOvVTtD
         w+EHBqNfP4Gs4AoDLYM/2mD2YKrm0waBeUPx3kzU7HheWUEgUFXLViX4QeCsmowtXHv5
         jcWRFvTRuZDdu4bMLsIqKVoQSVQDtB3p4wKpwN1CaaGzmuOzEYmuw3J6uJZZ9fNL1M56
         mIwg==
X-Gm-Message-State: AOAM531NGsOqcVJGb20nbCI7qwtppICDY5Vv+Mhb6tQinEAqX8mnBT0B
        iWsMDW8nrtgnoDj8Wr538B9gO5mmZ1qXUZ6xWSc=
X-Google-Smtp-Source: ABdhPJwTugb7dC8k7QyTRBDp2qZlid1PnqdNY/KFNAbtHPKpliHovRCOoZJdvH2tbwbxBwNHuWJ8AjphI0vCD7Noc/k=
X-Received: by 2002:a05:6638:1193:: with SMTP id f19mr34798572jas.237.1641780296933;
 Sun, 09 Jan 2022 18:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20220108084008.1053111-1-fuweid89@gmail.com>
In-Reply-To: <20220108084008.1053111-1-fuweid89@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 9 Jan 2022 18:04:45 -0800
Message-ID: <CAEf4Bzag+qQOs86t2ESmYvTY8xCip+_GTKqXa0m7MQWjDMO5Mg@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpf: only set obj->skeleton without err
To:     Wei Fu <fuweid89@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 8, 2022 at 12:40 AM Wei Fu <fuweid89@gmail.com> wrote:
>
> After `bpftool gen skeleton`, the ${bpf_app}.skel.h will provide that
> ${bpf_app_name}__open helper to load bpf. If there is some error
> like ENOMEM, the ${bpf_app_name}__open will rollback(free) the allocated
> object, including `bpf_object_skeleton`.
>
> Since the ${bpf_app_name}__create_skeleton set the obj->skeleton first
> and not rollback it when error, it will cause double-free in
> ${bpf_app_name}__destory at ${bpf_app_name}__open. Therefore, we should
> set the obj->skeleton before return 0;
>
> Signed-off-by: Wei Fu <fuweid89@gmail.com>
> ---
>  tools/bpf/bpftool/gen.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

Great catch! Added (please add it yourself in the future):

Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside
skeleton")

Also reworded the subject a bit. Pushed to bpf-next.

> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 5c18351290f0..e61e08f524da 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -928,7 +928,6 @@ static int do_skeleton(int argc, char **argv)
>                         s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));\n\
>                         if (!s)                                             \n\
>                                 goto err;                                   \n\
> -                       obj->skeleton = s;                                  \n\
>                                                                             \n\
>                         s->sz = sizeof(*s);                                 \n\
>                         s->name = \"%1$s\";                                 \n\
> @@ -1001,6 +1000,8 @@ static int do_skeleton(int argc, char **argv)
>                                                                             \n\
>                         s->data = (void *)%2$s__elf_bytes(&s->data_sz);     \n\
>                                                                             \n\
> +                       obj->skeleton = s;                                  \n\
> +                                                                           \n\
>                         return 0;                                           \n\
>                 err:                                                        \n\
>                         bpf_object__destroy_skeleton(s);                    \n\
> --
> 2.25.1
>
