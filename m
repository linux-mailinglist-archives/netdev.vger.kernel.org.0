Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C870711E8DD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfLMRCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:02:32 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43673 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbfLMRCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:02:31 -0500
Received: by mail-qv1-f67.google.com with SMTP id p2so15803qvo.10;
        Fri, 13 Dec 2019 09:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUE8AEfpv1Je3ytswJ2t5UjmrKOaLm5nTOW/OGZXKqs=;
        b=LiRgSKsEotztqVrsicsLsNUDrDyYeIVpc5+lRgzqczvL62rsuBj4Sa8kv7CHVoxoXH
         EWf2/4n/6YSz0KEDVyfYtJTpb8F7EmGyVJR+ZshuzOr+rwiewODBxJsSOOlq9GFzmfmR
         xbyfqPPoFwYCGFYTbxa0kspoKBUFBP8SWqe6HFH220EKZNVz5tnRGO45bF6o7uPDCsYs
         c/oZxItM/SELe7rS2ok8whcpRv0BeIPcwpH6Sy1KO9LukZKVfqv3oXFTjiNf3iXIc7hr
         s0ZkR9IY00n1vFjE/biRCTww+E0EzM7oNaqT4yRiQqb5w4dqYj9TQmRdhnkZeug5/rJe
         984Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUE8AEfpv1Je3ytswJ2t5UjmrKOaLm5nTOW/OGZXKqs=;
        b=i/PV790HYbbvudLmDWf7VeKvmG1ePspD27a+IMIMZ3DpDa1qMe8Zw061+8PGJQ4giM
         4WPr2OeTBmJxN+IIQ986kVmtx2K1k61N4Sil/J9ZZLVJVQel7ErR45KEkQxWF5lE1onX
         /osmbNozDQKQ3DO7TLI6wGLxZgsuqPZdxhrXFhU33K3GNtNaL53MdTbYz+Y8JOJ4lZ+j
         QrD2Xb7U+tuN3kV/Y2f/2/qsYbR4K05HxuwFR0MwhwSfu87QOsIXvOpyp+Wc/lMBnDds
         E8Fb0siqBFqKETUrHMtowLYQxwTgifSkBiN+Jldev6vOC2lgYhIbpSfsg/DDb4bsHth1
         xi9Q==
X-Gm-Message-State: APjAAAVTrboTUMk5PcmDTh3SbpeO+d5s45o6lnF3rRD1FIWAnewgFK2W
        YODPgxPTgtAN9zxYfltV8nuhuTO62omAxnnlkY8=
X-Google-Smtp-Source: APXvYqxSHgQ7tT0FFNjw0FMOJb3XsIngDsE1kSkmcHPlEmXgbqA8EhfpMfQEZmwNFjBDUp4xDIjV8uTmvi+wnxrkb7A=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr14796667qvb.163.1576256550460;
 Fri, 13 Dec 2019 09:02:30 -0800 (PST)
MIME-Version: 1.0
References: <20191201195728.4161537-1-aurelien@aurel32.net>
 <87zhgbe0ix.fsf@mpe.ellerman.id.au> <20191202093752.GA1535@localhost.localdomain>
 <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com>
 <20191210222553.GA4580@calabresa> <CAFxkdAp6Up0qSyp0sH0O1yD+5W3LvY-+-iniBrorcz2pMV+y-g@mail.gmail.com>
 <20191211160133.GB4580@calabresa> <CAFxkdAp9OGjJS1Sdny+TiG2+zU4n0Nj+ZVrZt5J6iVsS_zqqcw@mail.gmail.com>
 <20191213101114.GA3986@calabresa>
In-Reply-To: <20191213101114.GA3986@calabresa>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Dec 2019 09:02:19 -0800
Message-ID: <CAEf4BzY-JP+vYNjwShhgMs6sJ+Bdqc8FEd19BVf8uf+jSnX1Jw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix readelf output parsing for Fedora
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <kafai@fb.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 2:11 AM Thadeu Lima de Souza Cascardo
<cascardo@canonical.com> wrote:
>
> Fedora binutils has been patched to show "other info" for a symbol at the
> end of the line. This was done in order to support unmaintained scripts
> that would break with the extra info. [1]
>
> [1] https://src.fedoraproject.org/rpms/binutils/c/b8265c46f7ddae23a792ee8306fbaaeacba83bf8
>
> This in turn has been done to fix the build of ruby, because of checksec.
> [2] Thanks Michael Ellerman for the pointer.
>
> [2] https://bugzilla.redhat.com/show_bug.cgi?id=1479302
>
> As libbpf Makefile is not unmaintained, we can simply deal with either
> output format, by just removing the "other info" field, as it always comes
> inside brackets.
>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Fixes: 3464afdf11f9 (libbpf: Fix readelf output parsing on powerpc with recent binutils)
> Reported-by: Justin Forbes <jmforbes@linuxtx.org>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---

I was briefly playing with it and trying to make it use nm to dump
symbols, instead of parsing more human-oriented output of readelf, but
somehow nm doesn't output symbols with @@LIBBPF.* suffix at the end,
so I just gave up. So I think this one is good.

This should go through bpf-next tree.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/lib/bpf/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index defae23a0169..23ae06c43d08 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -147,6 +147,7 @@ TAGS_PROG := $(if $(shell which etags 2>/dev/null),etags,ctags)
>
>  GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>                            cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
> +                          sed 's/\[.*\]//' | \
>                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                            sort -u | wc -l)
>  VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
> @@ -213,6 +214,7 @@ check_abi: $(OUTPUT)libbpf.so
>                      "versioned in $(VERSION_SCRIPT)." >&2;              \
>                 readelf -s --wide $(BPF_IN_SHARED) |                     \
>                     cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |   \
> +                   sed 's/\[.*\]//' |                                   \
>                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
>                 readelf -s --wide $(OUTPUT)libbpf.so |                   \
> --
> 2.24.0
>
