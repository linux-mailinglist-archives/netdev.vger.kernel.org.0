Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5E3CC023
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhGQAfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhGQAfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 20:35:54 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F85BC06175F;
        Fri, 16 Jul 2021 17:32:59 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id c16so10881064ybl.9;
        Fri, 16 Jul 2021 17:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vtojRO5UJ8UAUBsB6lQ6JUBMPaoQT8f0SvpKgkRdtgQ=;
        b=J1ciRSyVQtuFajXvLrR03KkmF9sB2q/vA7YqnUi3UpBX6rppX/XFQoLHuFayJCpiD4
         5U+Q+Ow4Fv8zOcPBp0HjBUAlTHIB5FY51KlOSaTf5WqOEg44iHtG9htBracH/GyG65rL
         gKEGCMpk2NMctdw9lhwLE0puEoyFfM86+eRyJhxnIFuW55Qt/hRgH6VZym8YK5wL7ONI
         I5PCSkZMvJw4YwmJExYUmG8Xm5qWDbpJ6ci7CMTDV6pqsYNTbYcbkYeXYRyxh2VMAX4I
         UyOxlTxcbsferaO2sxq1wzQ9f/ljO+4oamLxKN1OaJJInWvyfKrJErJVkm4oiTNgvW/A
         MtWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vtojRO5UJ8UAUBsB6lQ6JUBMPaoQT8f0SvpKgkRdtgQ=;
        b=YTcel4GkbEuSOQjuncaPN2D6zxzyfVhKWTD14Ezm6YFL14+pt/BnBor7hZVl/PKyC7
         4OgA5+YyGoLKE6r8BwV6erFgTmPu18bV+3V4o4NnqB9VtmEsKNg3uN18LEFn0Cp3qAAL
         5ky+hh3NXJujDt71QC0hMV/o+zAF42VSiViArc845vv+YcHILo2xeu64AARAa5EjjH8o
         Pgs08I4dW47fIb0G8zZctbEAph6EGKvfPAVnTpPkTkr3pKdlqnRGLGjEKVkoJ8Wpurrv
         cyAwsnLkOwr8x4MZrir96wpw8q6xOfEOu34nXHLjfERVzDBXfe46sgRnUzSF2by+Lvf6
         N0pA==
X-Gm-Message-State: AOAM530WesV0K1eo7mGCvQ24Sx0Wx3nfHl20mFe5/jz/A8YwuTsSyUWg
        fR99bJAraWMfujk4DyCnqFmLsJ129uM649UiYt4=
X-Google-Smtp-Source: ABdhPJyaC5cCpRpQgYHAVh6ikYNKXPg+la+Y7VHYi50DTR2TPZXkCYDzwFoGQTcxio0pbGW/S8QV4nP//IFW1GgD+x0=
X-Received: by 2002:a25:b203:: with SMTP id i3mr16325406ybj.260.1626481978333;
 Fri, 16 Jul 2021 17:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com> <1626475617-25984-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626475617-25984-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 17:32:47 -0700
Message-ID: <CAEf4BzbXNK0bb_7Wa6=y2BsQjmQ_ynYT1YNhO4eP0uT4nwJmpg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: clarify/fix unaligned data issues
 for btf typed dump
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
> If data is packed, data structures can store it outside of usual
> boundaries.  For example a 4-byte int can be stored on a unaligned
> boundary in a case like this:
>
> struct s {
>         char f1;
>         int f2;
> } __attribute((packed));
>
> ...the int is stored at an offset of one byte.  Some platforms have
> problems dereferencing data that is not aligned with its size, and
> code exists to handle most cases of this for BTF typed data display.
> However pointer display was missed, and a simple function to test if
> "ptr_is_aligned(data, data_sz)" would help clarify this code.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf_dump.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 929cf93..814a538 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -1654,6 +1654,11 @@ static int btf_dump_base_type_check_zero(struct btf_dump *d,
>         return 0;
>  }
>
> +static bool ptr_is_aligned(const void *data, int data_sz)
> +{
> +       return ((uintptr_t)data) % data_sz == 0;
> +}
> +
>  static int btf_dump_int_data(struct btf_dump *d,
>                              const struct btf_type *t,
>                              __u32 type_id,
> @@ -1672,7 +1677,7 @@ static int btf_dump_int_data(struct btf_dump *d,
>         /* handle packed int data - accesses of integers not aligned on
>          * int boundaries can cause problems on some platforms.
>          */
> -       if (((uintptr_t)data) % sz)
> +       if (!ptr_is_aligned(data, sz))
>                 return btf_dump_bitfield_data(d, t, data, 0, 0);
>
>         switch (sz) {
> @@ -1739,7 +1744,7 @@ static int btf_dump_float_data(struct btf_dump *d,
>         int sz = t->size;
>
>         /* handle unaligned data; copy to local union */
> -       if (((uintptr_t)data) % sz) {
> +       if (!ptr_is_aligned(data, sz)) {
>                 memcpy(&fl, data, sz);
>                 flp = &fl;
>         }
> @@ -1892,12 +1897,29 @@ static int btf_dump_struct_data(struct btf_dump *d,
>         return err;
>  }
>
> +union ptr_data {
> +       unsigned int p;
> +       unsigned long lp;

long can be 32-bit on 4-byte architectures, plus %llx implies long
long (or we'll get another annoying warning from the compiler)

> +};
> +
>  static int btf_dump_ptr_data(struct btf_dump *d,
>                               const struct btf_type *t,
>                               __u32 id,
>                               const void *data)
>  {
> -       btf_dump_type_values(d, "%p", *(void **)data);
> +       bool ptr_sz_matches = d->ptr_sz == sizeof(void *);

used just once and clear what it does, I inlined this, no point in
separate variable


> +
> +       if (ptr_sz_matches && ptr_is_aligned(data, d->ptr_sz)) {
> +               btf_dump_type_values(d, "%p", *(void **)data);
> +       } else {
> +               union ptr_data pt;
> +
> +               memcpy(&pt, data, d->ptr_sz);
> +               if (d->ptr_sz == 4)
> +                       btf_dump_type_values(d, "0x%x", pt.p);
> +               else
> +                       btf_dump_type_values(d, "0x%llx", pt.lp);
> +       }
>         return 0;
>  }
>
> @@ -1910,7 +1932,7 @@ static int btf_dump_get_enum_value(struct btf_dump *d,
>         int sz = t->size;
>
>         /* handle unaligned enum value */
> -       if (((uintptr_t)data) % sz) {
> +       if (!ptr_is_aligned(data, sz)) {
>                 *value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
>                 return 0;
>         }
> --
> 1.8.3.1
>
