Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941966E8BF
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfGSQZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:25:44 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38256 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730920AbfGSQZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:25:44 -0400
Received: by mail-io1-f67.google.com with SMTP id j6so27310932ioa.5;
        Fri, 19 Jul 2019 09:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9dRQ3FtuER9R5L/yO3M7GMUZTe4gWi4pMcABfBxn34=;
        b=CZW8Vtrb28mPKDXHAHEPRL5aQ3Rt0Vsjlr073l2LEkar/sv2kdQPYtsJKiJ3CYy1P0
         iigQ4z5FmwblWjS6PmUvT1I5SeS0lZHwoxYwA9MjYwm5RAKVJ+SEFqFAzFI1NONy6ZMB
         eLjUZEA/jxAzsLki+XHYcz0bjND3En9P82WjZi/wY+rGwPTjINVXE8cwE150AoFQxcEy
         jDOO3JEXi2maVoMIDDfBHM4FzulD672ZF3t9J03gVAmMkzis27K6aobXvztK4twOUhCD
         9yYNEURhiGl1GXD4KzmjhL0G7WMz75xBYQh8vbdosEasnO0o61hQyH3i4i1yDnp918Ag
         9rCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9dRQ3FtuER9R5L/yO3M7GMUZTe4gWi4pMcABfBxn34=;
        b=DD0t28GaQSpECoU7Umy+S4QMON/dRcAaP0MfKFYlf0kQy/78tZwgkCJkP1ufRuUuJ8
         o9FWUWUKDat8VXCqkdfyFoTfccRguz8L3I7KQwdZ528D0ypjalUOQ+k2z/ggRuHWdS/w
         HjY/oHmnROv7Bf3lTbcJO0s+qPmBl4aE7z/+yNIzcGMriTV4K3Vm3rkY0XrmEAhiLVju
         KD87XKwI1C7XUs0y2PpUVbhjH1leAvXIdOusSnEsYjNU0EuRgW0PHnjVf8c8s+NtIYRo
         pA9VtJh2Q8gsWASSQEgGzpGFtohvXIhx8iowYqOoFwuQ/pK5gf1cXhJKXxqAHzETsP/n
         Ygfw==
X-Gm-Message-State: APjAAAVBJ/AW8YLiHNGWJaG5ImqEWZul7YJ5/8qck4hSQG8DZXbsrTae
        Hh7gDBdnhemWbaAflRRJr8FPkzMIWqSWHlIuPmU=
X-Google-Smtp-Source: APXvYqzLysfnTzDFdrVPu5fDni8LuksYnckAeW4Zg0eXpeoWG7hpH0FQKAnEoRDLc3q9Tv4tzAafbgcH9TCR8DqsqRI=
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr47775196iom.287.1563553542869;
 Fri, 19 Jul 2019 09:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190719143407.20847-1-acme@kernel.org> <20190719143407.20847-2-acme@kernel.org>
In-Reply-To: <20190719143407.20847-2-acme@kernel.org>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 19 Jul 2019 09:25:07 -0700
Message-ID: <CAH3MdRXDz+Yn104Y3U0u-q_zW0cwSaH0QAPA8aWK9hpBc4hukw@mail.gmail.com>
Subject: Re: [PATCH 1/2] libbpf: Fix endianness macro usage for some compilers
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Clark Williams <williams@redhat.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 7:35 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Using endian.h and its endianness macros makes this code build in a
> wider range of compilers, as some don't have those macros
> (__BYTE_ORDER__, __ORDER_LITTLE_ENDIAN__, __ORDER_BIG_ENDIAN__),
> so use instead endian.h's macros (__BYTE_ORDER, __LITTLE_ENDIAN,
> __BIG_ENDIAN) which makes this code even shorter :-)

gcc 4.6.0 starts to support __BYTE_ORDER__, __ORDER_LITTLE_ENDIAN__, etc.
I guess those platforms with failing compilation have gcc < 4.6.0.
Agree that for libbpf, which will be used outside kernel bpf selftest should
try to compile with lower versions of gcc.

>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Fixes: 12ef5634a855 ("libbpf: simplify endianness check")
> Fixes: e6c64855fd7a ("libbpf: add btf__parse_elf API to load .BTF and .BTF.ext")
> Link: https://lkml.kernel.org/n/tip-eep5n8vgwcdphw3uc058k03u@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/lib/bpf/btf.c    | 5 +++--
>  tools/lib/bpf/libbpf.c | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 467224feb43b..d821107f55f9 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
>  /* Copyright (c) 2018 Facebook */
>
> +#include <endian.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -419,9 +420,9 @@ struct btf *btf__new(__u8 *data, __u32 size)
>
>  static bool btf_check_endianness(const GElf_Ehdr *ehdr)
>  {
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>         return ehdr->e_ident[EI_DATA] == ELFDATA2LSB;
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +#elif __BYTE_ORDER == __BIG_ENDIAN
>         return ehdr->e_ident[EI_DATA] == ELFDATA2MSB;
>  #else
>  # error "Unrecognized __BYTE_ORDER__"
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 794dd5064ae8..b1dec5b1de54 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -20,6 +20,7 @@
>  #include <inttypes.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <endian.h>
>  #include <fcntl.h>
>  #include <errno.h>
>  #include <asm/unistd.h>
> @@ -612,10 +613,10 @@ static int bpf_object__elf_init(struct bpf_object *obj)
>
>  static int bpf_object__check_endianness(struct bpf_object *obj)
>  {
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>         if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2LSB)
>                 return 0;
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +#elif __BYTE_ORDER == __BIG_ENDIAN
>         if (obj->efile.ehdr.e_ident[EI_DATA] == ELFDATA2MSB)
>                 return 0;
>  #else
> --
> 2.21.0
>
