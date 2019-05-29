Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8B92E2DD
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfE2RJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:09:45 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45233 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2RJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:09:45 -0400
Received: by mail-qt1-f193.google.com with SMTP id t1so3484995qtc.12;
        Wed, 29 May 2019 10:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/vPyb/weYDgUvhZvoDfV2jI0RMOjFs7RPyYnsfVXMzY=;
        b=c5OOj1/bl+OFg3Eu//NBS63TGa4en1WCthRGDYjq56M4aHJP0fLm/scCjg+jyNWCX3
         k0RyI7Dbl7FE4Qq/sNKlx6QcuSEllb1kY3+KNlzRLjg4iJhfW0MH3VFPkZKvcZO1limX
         jXb6Ah6nd5ydZl0X0AasHROzV0SyNsT6dQhixGOg/3T+H6LPbNE8/eMe+2gUWDMSyhYn
         6oyko3szAbJKUcIDmJT6ej8fAxhzib+3e3hQrCkhdkRANDMMDn+LlbSegOahbdeaKUJb
         Idtad7TUGJO2JSjRtD60Lx8YtYU2npPv6OAwDZtuENEAhb+b5UW13K+tH7ugC82mU7P4
         FckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/vPyb/weYDgUvhZvoDfV2jI0RMOjFs7RPyYnsfVXMzY=;
        b=AMj7ymzOdPuTSeVRjxr4fpcy5U+ZPH5dq3ylwFyQY7rtIXgThTE/A6yqRWTpk8JRKZ
         uo4YcwNWj5dUy1gyNsaUjEknYfn+KGqqym4O45bz+ffxVp8ZBlQWD9P1xhaOD5dGzhBv
         DLnyDy056jB+4Fu8HdRX7Fymr6LowXogJTFAavXLS/7LtJqSVx0W046tSJnh6xSpCLa9
         1OxSMvZ0cA68ZR63cbuMuw3CZEVn38hTnrGnBA0WDWRLzBHFzLmkmkIJD5S84W6wcKq/
         hWk+ZlTUfAkyt6dG1g5bWtmRmu16EqJYjn5KuRwYHYEtRKOPmeNU+MxEpjVjr2HJ2yAk
         OTrw==
X-Gm-Message-State: APjAAAU10RE+T05gymC4JrUxj4Nk6rCPb5K61mH2IdaqlrNK6mX+N6D0
        vvhJFaR0VYBNA5RQt9QKRFNz1r4/t8v6B1YSh+8=
X-Google-Smtp-Source: APXvYqy1xoYTvufZJ2P25p70emZgnj7KFWdrfg2RDM0QekSzLNL2YrguC2WuGXbUKPA8iEClsbfhsk+EKqXckdHx4AY=
X-Received: by 2002:aed:3b66:: with SMTP id q35mr19540850qte.118.1559149782745;
 Wed, 29 May 2019 10:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-4-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-4-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:09:31 -0700
Message-ID: <CAPhsuW7Zmds01cQ6KjLgTEnmnkV61DUCjDenTiLFeQonEZNg4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] libbpf: simplify endianness check
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
> Rewrite endianness check to use "more canonical" way, using
> compiler-defined macros, similar to few other places in libbpf. It also
> is more obvious and shorter.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 37 ++++++++++++-------------------------
>  1 file changed, 12 insertions(+), 25 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7b80b9ae8a1f..c98f9942fba4 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -607,31 +607,18 @@ static int bpf_object__elf_init(struct bpf_object *obj)
>         return err;
>  }
>
> -static int
> -bpf_object__check_endianness(struct bpf_object *obj)
> -{
> -       static unsigned int const endian = 1;
> -
> -       switch (obj->efile.ehdr.e_ident[EI_DATA]) {
> -       case ELFDATA2LSB:
> -               /* We are big endian, BPF obj is little endian. */
> -               if (*(unsigned char const *)&endian != 1)
> -                       goto mismatch;
> -               break;
> -
> -       case ELFDATA2MSB:
> -               /* We are little endian, BPF obj is big endian. */
> -               if (*(unsigned char const *)&endian != 0)
> -                       goto mismatch;
> -               break;
> -       default:
> -               return -LIBBPF_ERRNO__ENDIAN;
> -       }
> -
> -       return 0;
> -
> -mismatch:
> -       pr_warning("Error: endianness mismatch.\n");
> +static int bpf_object__check_endianness(struct bpf_object *obj)
> +{
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +       if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2LSB)
> +               return 0;
> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +       if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2MSB)
> +               return 0;
> +#else
> +# error "Unrecognized __BYTE_ORDER__"
> +#endif
> +       pr_warning("endianness mismatch.\n");
>         return -LIBBPF_ERRNO__ENDIAN;
>  }
>
> --
> 2.17.1
>
