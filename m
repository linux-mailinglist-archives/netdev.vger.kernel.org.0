Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E753CC028
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhGQAgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbhGQAf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 20:35:59 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11A2C06175F;
        Fri, 16 Jul 2021 17:33:02 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y38so17659160ybi.1;
        Fri, 16 Jul 2021 17:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trg43gr1lzJ0X/y3FwsvLfzh0F08pPa216DnEY22MBQ=;
        b=VB8goqNVFOdQYJObt6Wf/wp+vKwaXJI63KPWacM51FfjJN+x0SWmkl6jD+dn5QUVo6
         hBoTC7lFkAs84KDDQHXcBjYUZXmVYQFMqDbknH1QS4ZcF8zNAZ07BL82wzlMvAaifmtD
         REM9qcAmH73VzZwamPEzmU4XoHt/1EXybJ3Np37sq2Yqjar3cMxGmqhfH/+zF1RgF6hx
         QnbmecGT3L5djnYdV43iJJCkIjmfqk548ShoNN8zzi0BDgF4jglHo0wkti8MOBr/Jf25
         c5JHW3+qOvF4W+DUAqfPeWL8nBA5bwEjXaU6D5eOQ2/i13KhShVh+JdJ3TVvWqiNolEX
         KY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trg43gr1lzJ0X/y3FwsvLfzh0F08pPa216DnEY22MBQ=;
        b=ZysBdUyKmmfvFtriwffaMYFVBZ18U8tacG+hjQdZSpOrPycBX6v/82M9soH43eWr14
         oUh4mcGZu3CMBTXtoCxVzpw3pG5dhiG/qIfy8bqSiDuXvG16pyF8AkLzcT3HEaWLI6vg
         JojN0EdSSaAXF/CsLO2PFbrcm94dPobwqnIibzPUK5zrx0mmBSv3kgPzu2YD4VPjT7hm
         ox+/MWt+3bdvCKfXC7Czc+P87nlKfyVK5y5ikpEyWRVCrpIj91ypg9FHxpEWpvFsX45G
         TUiQmPtI2ovqYnjXEgVsilnxPgClF2UOu4pxabWlhCvWW75rJ01HSrtswgPOkQlASetj
         DqSA==
X-Gm-Message-State: AOAM533NIuPIaaqYa4hG3gtHU3oawyPo82hQ0L66nDgORFyGhpxbB+7H
        oJ+qOZHfvsoYn7nK+Lb39C+48JV5Lfi8qB3u/tg=
X-Google-Smtp-Source: ABdhPJxhcRk7QZWmEG50BZRzJNegQN8FropSgiI3YJ9SQ/bXz+tQLHzUIcWh8CyhWiNpwbIWctRZ6224KUUbgldzATg=
X-Received: by 2002:a25:3787:: with SMTP id e129mr15704664yba.459.1626481981987;
 Fri, 16 Jul 2021 17:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com> <1626475617-25984-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626475617-25984-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 17:32:51 -0700
Message-ID: <CAEf4BzavQqexc_5DM0vh89ocjp0dvSMrLU4P4hTfmwt9rTsv4Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: fix compilation errors on ppc64le
 for btf dump typed data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 3:47 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Andrii reports:
>
> "ppc64le arch doesn't like the %lld:
>
>  In file included from btf_dump.c:22:
> btf_dump.c: In function 'btf_dump_type_data_check_overflow':
> libbpf_internal.h:111:22: error: format '%lld' expects argument of
> type 'long long int', but argument 3 has type '__s64' {aka 'long int'}
> [-Werror=format=]
>   111 |  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
>       |                      ^~~~~~~~~~
> libbpf_internal.h:114:27: note: in expansion of macro '__pr'
>   114 | #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
>       |                           ^~~~
> btf_dump.c:1992:3: note: in expansion of macro 'pr_warn'
>  1992 |   pr_warn("unexpected size [%lld] for id [%u]\n",
>       |   ^~~~~~~
> btf_dump.c:1992:32: note: format string is defined here
>  1992 |   pr_warn("unexpected size [%lld] for id [%u]\n",
>       |                             ~~~^
>       |                                |
>       |                                long long int
>       |                             %ld
>
> Cast to size_t and use %zu."
>

Quoting me isn't a great commit message by itself, tbh. Reworded.



> Reported-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf_dump.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 814a538..e5fbfb8 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -2011,8 +2011,8 @@ static int btf_dump_type_data_check_overflow(struct btf_dump *d,
>         __s64 size = btf__resolve_size(d->btf, id);
>
>         if (size < 0 || size >= INT_MAX) {
> -               pr_warn("unexpected size [%lld] for id [%u]\n",
> -                       size, id);
> +               pr_warn("unexpected size [%zu] for id [%u]\n",
> +                       (size_t)size, id);
>                 return -EINVAL;
>         }
>
> --
> 1.8.3.1
>
