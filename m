Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724FF368671
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbhDVSRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhDVSRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:17:35 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92E9C06174A;
        Thu, 22 Apr 2021 11:17:00 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c195so52561260ybf.9;
        Thu, 22 Apr 2021 11:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J54oNWzG3ZvpElznYo87N3/GL0PDi/5GMV/a3wu8Llg=;
        b=us7Ulv40lbE7EiPU9q9aFpMMRbnOcyBm/U4Kf4Ws4POMWSV57P2xXx1D2/421P6EjC
         ZPgWNikQz2nyCxrExyhE6XR3BCIj9v3MAtvbJY6GRZlEXy9zjd7uqwo6RaJHWEnV56fO
         z+j+wLxrE2QlffFtEAwIX7EnPvVL6E4bFhxbPJJx5whIPaTUXQ/EKyGiUqp8XqQCz1gf
         Ky+YikRFgmdoM04H3sJQ76xIuBqDRNmjiThWqHoHviR1QqM/KY8p24BdbES1rvWSndzv
         TtCI47Ye+McT4a1uo+qtuW4Q64ecvET8jN9HVzNx0K0Qe83Q0+MX9QBgX9skh99h+/MV
         RI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J54oNWzG3ZvpElznYo87N3/GL0PDi/5GMV/a3wu8Llg=;
        b=cLYTgffYYXu0edF/7Au67E95tQU3GNF2FNDxXjYN01FkkVbkXH6CethB7ANFAm1JVK
         xEDuh/LyqTLKCwPouRWalAC+WWupnb5Ot+IjZy/hj+LVivOyaXd5x5rQJa/QWvyOOlSr
         FLR+9/41Jo/Y3kUXGkkEM2tBx/z+HdK9eM31holKO230Bwh7t/UOFhWPaYKxpk8P2yQs
         TjTviYRgZFq3iuWXcAwqXAabd2PHvJvrLb1LT7hZMwB99h4TTbklbMXCZgB+GPmouo+C
         Q3/HVhZ/DOFwf4OYLGyoXojDVqV//fKqcVR+P4CbKy+CepJR8KKiIHwYnVnS583kU11p
         Ls7A==
X-Gm-Message-State: AOAM531ZywKnF2D0FkujlkYxpqb8RPlwwQnVnRCjw3oxWoZJOlVkR3Hu
        FZm8+s8IlE3I8zd+j8g6A65RjATr7fQT6kW1ttCYkUL1
X-Google-Smtp-Source: ABdhPJwkniUpqRQEdebwPIExhZbGJdUQpCC9xYDfd34sTcxtihxHDkCEf9Ptdtx+Gql2Ub+Y9EJNDVP6IYzPwcpOgTI=
X-Received: by 2002:a25:d70f:: with SMTP id o15mr6320314ybg.403.1619115419240;
 Thu, 22 Apr 2021 11:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-8-andrii@kernel.org>
 <6fb105a3-ffc3-1970-8833-429e5b624e31@fb.com>
In-Reply-To: <6fb105a3-ffc3-1970-8833-429e5b624e31@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:16:48 -0700
Message-ID: <CAEf4BzZWA+sPoHYBNK6+3yWcAUBd4KJuiUGOsMbbs0wSBvjcKw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 07/17] libbpf: factor out symtab and relos
 sanity checks
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 9:06 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> > Factor out logic for sanity checking SHT_SYMTAB and SHT_REL sections into
> > separate sections. They are already quite extensive and are suffering from too
> > deep indentation. Subsequent changes will extend SYMTAB sanity checking
> > further, so it's better to factor each into a separate function.
> >
> > No functional changes are intended.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with a minor suggestion below.
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   tools/lib/bpf/linker.c | 233 ++++++++++++++++++++++-------------------
> >   1 file changed, 127 insertions(+), 106 deletions(-)
> >

[...]

> >
> > -                     /* .rel<secname> -> <secname> pattern is followed */
> > -                     if (strncmp(sec->sec_name, ".rel", sizeof(".rel") - 1) != 0
> > -                         || strcmp(sec->sec_name + sizeof(".rel") - 1, link_sec->sec_name) != 0) {
> > -                             pr_warn("ELF relo section #%zu name has invalid name in %s\n",
> > -                                     sec->sec_idx, obj->filename);
> > +     n = sec->shdr->sh_size / sec->shdr->sh_entsize;
> > +     sym = sec->data->d_buf;
> > +     for (i = 0; i < n; i++, sym++) {
> > +             if (sym->st_shndx
> > +                 && sym->st_shndx < SHN_LORESERVE
> > +                 && sym->st_shndx >= obj->sec_cnt) {
> > +                     pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
> > +                             i, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
> > +                     return -EINVAL;
> > +             }
> > +             if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
> > +                     if (sym->st_value != 0)
> >                               return -EINVAL;
> > -                     }
> > +                     continue;
>
> I think this "continue" is not necessary.
>

yes, but I wanted to make it clear that there should be no more logic
handling STT_SECTION afterwards, if/when we extend the logic of this
loop. We have similar patterns with goto to keep logic more modular
and easily extensible:


    if (something) {
        err = -EINVAL;
        goto err_out;
    }


err_out:
    return err;


So let's keep it as is.

> > +             }
> > +     }
> >
> > -                     /* don't further validate relocations for ignored sections */
> > -                     if (link_sec->skipped)
> > -                             break;
> > +     return 0;
> > +}
> >
> > -                     /* relocatable section is data or instructions */
> > -                     if (link_sec->shdr->sh_type != SHT_PROGBITS
> > -                         && link_sec->shdr->sh_type != SHT_NOBITS) {
> > -                             pr_warn("ELF relo section #%zu points to invalid section #%zu in %s\n",
> > -                                     sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
> > -                             return -EINVAL;
> > -                     }
> [...]
