Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE682E2EF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfE2RN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:13:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43617 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfE2RN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:13:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so3496311qtj.10;
        Wed, 29 May 2019 10:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8w9wsu+KYuXsgQvCEuAcdE5zdMVTz0mKJysd28Lmbo=;
        b=kgQVJ1bqvKM7QgCMT5UaTAOs9bZaZ2rUckqFitJSB/O+/FY4+YBlw+/NfqHe5uF+hN
         5eNXZ4Cpe4/dhBjyollly95KqYwivcqz5BhExv79FYGwYo5AeD2NapM9iNHNJWQBQokm
         miVOnE0RNOnaN6tp096ako2yw446PCb0uQIeJ2tWh20FmxU2sQYYdvLplIdKU4eUN+M/
         bnVUwdL4XntesVTIYVhrvd+8CcATVNRI6BlSGdLpwivifteSrReahRRdkq4QmsCqI5lo
         Jyajdu33UkXW4Rhs3AMZZGDSzH4UVzZvxIXrbPbGi16DfuzKW/ikb2eWidFG4FNai1xS
         sX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8w9wsu+KYuXsgQvCEuAcdE5zdMVTz0mKJysd28Lmbo=;
        b=ukVvFMjPkcslEBgjwElnGleiMhUNxTv3ecuCz2epoY7XsO3gYkoIPOpj7fO+Tve4W/
         vSnSjUnqvKkbRUIJafMWHoq7qlIcPsXiI5BRaBs2eVsjK4exrML+2jBRHI35ixgmSWEH
         9hMrR1PuMcdR5fDg9146E3OHCD9MPT2qSEfFir9xepinG0sBGua4JXNt5IOaPpL6nj6I
         AQiRH2II3rHYCYYP9amq7+p5pi/utsK2E9n83Ii3wgoGQnnAxVV17p8pBtFVk0Nh3dcP
         X+ERRkEEJegKNGbA7bT5JUJm7zNlmFnYn7RQMdRjgVxnmydnTTEaECXMTYGv9d5wW2zV
         lKQQ==
X-Gm-Message-State: APjAAAUdZhkED9p0i38ts4mk1jt4uvM8zLacOnIw4vI2+4gegi26qnt0
        NpPD59RCIkHZqC6lYZh/u3VSf2ux6Ro20pjT85M=
X-Google-Smtp-Source: APXvYqxNfjlx2IrJby4BJuA9+7aBTgl1rTpCkQ3FymoigL7YOQvMWKJ+2Jy8EydOlsCVjcuDxnZKmalhjX0YbMXaqbE=
X-Received: by 2002:aed:3b66:: with SMTP id q35mr19559470qte.118.1559150004425;
 Wed, 29 May 2019 10:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-6-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-6-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:13:13 -0700
Message-ID: <CAPhsuW7jQgcKezWJ+5oBev+VsdFf=bFJBFSLMh_Pe00h78q5tA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] libbpf: fix error code returned on corrupted ELF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> All of libbpf errors are negative, except this one. Fix it.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7abe71ee507a..9c45856e7fd6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1221,7 +1221,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>
>         if (!obj->efile.strtabidx || obj->efile.strtabidx >= idx) {
>                 pr_warning("Corrupted ELF file: index of strtab invalid\n");
> -               return LIBBPF_ERRNO__FORMAT;
> +               return -LIBBPF_ERRNO__FORMAT;
>         }
>         if (btf_data) {
>                 obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
> --
> 2.17.1
>
