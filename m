Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC591878F9
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgCQFJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:09:25 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42474 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgCQFJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:09:24 -0400
Received: by mail-qk1-f194.google.com with SMTP id e11so30436030qkg.9;
        Mon, 16 Mar 2020 22:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ioTZr5nsJG3HFizDxsGwRshIWndCqjqQER0RaugL3L8=;
        b=PPx+NJdHygj257ZbMXduTiKasHi4manKnYEq+k9yf6OGc2GmJuIqIdX5FISUSdeCdn
         sjvGorhk/PIvmieYYQl8noFyVgnDcELyiv1k+M4VtFb25AQczZckCbsrpdG+s4I+U/FW
         Lw6nvbJuxdTRCe9R5TecAH4YyKNc2BoBJSfE2FdRMfG0WNpiLA9svpgEQfQz26+arisd
         Q9aZcU5AnZqOoujjR/PQYQNLmIcGCY/PXwZZrnfUxmasur09grnjMiHBd4nW9cQOZkyB
         1W9vgI4LmWhQuHTSQNsYoZhzgkaDtIWyps3Vmqj7VL5nZluRH0uaPOIWIHURfZIf3pgV
         GXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ioTZr5nsJG3HFizDxsGwRshIWndCqjqQER0RaugL3L8=;
        b=HOsOGhzYayxKAM7mm3UbkA6+n8wNdO8AUCQqTwW10Bw9o32AxBgVLdrNH8wNmjCpqa
         8282dHO0mj2J8Z6WUl3UdxqpW/Wew8x0epeWB+AVrc5rr4mraXA+mQOtrGRlsQIUPnII
         ZgJfvz7GpFINpwU1wNer+IRou2Ndojq8PVMwj+OTvbAfsCWeJIYVS/nayr4lRBT23/HQ
         CoPXC4GFdTxJsEmD5tdkYLkDiamN8+KvucoXGIpUoSPYrmQqNTgT+KkAN8zxdvm+SAJQ
         NPX+8ZeUOJWI5pxA2zegWU4vOeGFcWyW/KW0uZwNXcDaUfbGqI3XbCBQEGQe9xLSeFdb
         0X4g==
X-Gm-Message-State: ANhLgQ3YySXoyTxAFC60o6642oOlXudtJHZaAYkWEBGn2TUkwk5DxlHb
        cBNX31BGwIz766cKD1prjexKpaR+RiKv59q8MRU=
X-Google-Smtp-Source: ADFU+vsObjY46cgRCG0SveVJO26y2xkuT75EZ4lIZG+1Z/6zXEYZwdC6cE17to6SmQFoNAMxiEO1P79dYYsbTyHXVCs=
X-Received: by 2002:a37:9104:: with SMTP id t4mr3307894qkd.449.1584421763202;
 Mon, 16 Mar 2020 22:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200317011654.zkx5r7so53skowlc@google.com> <CAEf4BzYTJqWU++QnQupxFBWGSMPfGt6r-5u9jbeLnEF2ipw+Mw@mail.gmail.com>
 <20200317033701.w7jwos7mvfnde2t2@google.com>
In-Reply-To: <20200317033701.w7jwos7mvfnde2t2@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Mar 2020 22:09:12 -0700
Message-ID: <CAEf4BzYyimAo2_513kW6hrDWwmzSDhNjTYksjy01ugKKTPt+qA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
 vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 8:37 PM Fangrui Song <maskray@google.com> wrote:
>
> On 2020-03-16, Andrii Nakryiko wrote:
> >On Mon, Mar 16, 2020 at 6:17 PM Fangrui Song <maskray@google.com> wrote:
> >>
> >> Simplify gen_btf logic to make it work with llvm-objcopy and
> >> llvm-objdump.  We just need to retain one section .BTF. To do so, we can
> >> use a simple objcopy --only-section=.BTF instead of jumping all the
> >> hoops via an architecture-less binary file.
> >>
> >> We use a dd comment to change the e_type field in the ELF header from
> >> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o will be accepted by lld.
> >>
> >> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> >> Cc: Stanislav Fomichev <sdf@google.com>
> >> Cc: Nick Desaulniers <ndesaulniers@google.com>
> >> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> >> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> >> Signed-off-by: Fangrui Song <maskray@google.com>
> >> ---
> >>  scripts/link-vmlinux.sh | 13 ++-----------
> >>  1 file changed, 2 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> >> index dd484e92752e..84be8d7c361d 100755
> >> --- a/scripts/link-vmlinux.sh
> >> +++ b/scripts/link-vmlinux.sh
> >> @@ -120,18 +120,9 @@ gen_btf()
> >>
> >>         info "BTF" ${2}
> >>         vmlinux_link ${1}
> >> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> >
> >Is it really tested? Seems like you just dropped .BTF generation step
> >completely...
>
> Sorry, dropped the whole line:/
> I don't know how to test .BTF . I can only check readelf -S...
>
> Attached the new patch.
>
>
>  From 02afb9417d4f0f8d2175c94fc3797a94a95cc248 Mon Sep 17 00:00:00 2001
> From: Fangrui Song <maskray@google.com>
> Date: Mon, 16 Mar 2020 18:02:31 -0700
> Subject: [PATCH bpf v2] bpf: Support llvm-objcopy and llvm-objdump for
>   vmlinux BTF
>
> Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
> We use a dd comment to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o can be accepted by lld.
>
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>
> ---
>   scripts/link-vmlinux.sh | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index dd484e92752e..b23313944c89 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -120,18 +120,10 @@ gen_btf()
>
>         info "BTF" ${2}
>         vmlinux_link ${1}
> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> +       ${PAHOLE} -J ${1}

I'm not sure why you are touching this line at all. LLVM_OBJCOPY part
is necessary, pahole assumes llvm-objcopy by default, but that can
(and should for objcopy) be overridden with LLVM_OBJCOPY.

>
> -       # dump .BTF section into raw binary file to link with final vmlinux
> -       bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> -               cut -d, -f1 | cut -d' ' -f2)
> -       bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> -               awk '{print $4}')
> -       ${OBJCOPY} --change-section-address .BTF=0 \
> -               --set-section-flags .BTF=alloc -O binary \
> -               --only-section=.BTF ${1} .btf.vmlinux.bin
> -       ${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> -               --rename-section .data=.BTF .btf.vmlinux.bin ${2}
> +       # Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
> +       ${OBJCOPY} --only-section=.BTF ${1} ${2} && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
>   }
>
>   # Create ${2} .o file with all symbols from the ${1} object file
> --
> 2.25.1.481.gfbce0eb801-goog
>
