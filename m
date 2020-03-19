Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30DD18ABFA
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgCSFLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:11:09 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40267 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSFLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 01:11:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id i9so146697qtw.7;
        Wed, 18 Mar 2020 22:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CifRFPL7G9zhduy+K2WKQkbWfN5Wt24clk5Fo4/QKqA=;
        b=GRG+EFCldvZhznE3C8KM0R8ZPiB6QakCzOd23gxvHeqIUg/91nYFSiYbPvRlF/5MIb
         xYyJoBfXiEJbBJyUg/dLRtVB2qnRW60JVmXciWvPELH7G3gSD3kHjJ1bFLKOHEM5KEgd
         fIAUBkap8YPp4k3ACuw2Lc29ihOtm1R100OJUL3nJoBMbXzfODT86DysDNVs3cYfpfF1
         s1IYNEvlIKvQm1G65LRzrqYmnB4YTFgvjpMoZNG0LllGw2OnQocKsbOQFUPx3sfNupr9
         H8tKXpYn4F0EuUa2P7ZALIj5GYyGJNtOnYkAhZBVOYxo+gEV7TuPuKn/cPqh0NY5zDEP
         bawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CifRFPL7G9zhduy+K2WKQkbWfN5Wt24clk5Fo4/QKqA=;
        b=HDdtQ4OcTg7uei1bzT6rX3aEtjzDu9xEn6DWwpHFRr/6h7tEr9iU+gHx2e7rmsYmPg
         TpLw8AnfjoigTHgwstcAr11zIPxw3GKRw1KL13j2RXkRCxS+dQGVyIcZPhfaOxZv6kQ1
         Oi3P1TPm2vqYb7+yWP5CmSitNcnt3VwpRZRcvpyjc3eJVOZMUf0eZIBxkRoaH+7SswDK
         VkNf5d6k9yZFWv62+YVLfyIntxejsrkOt9sUXEcJPvr43nIC/x31t6Z9j3BFhNiBCp6S
         LfLzGUM37pB2BlpBjihn440ZB9F/s15fG9n6Foa9A1RsXECBkPNFzS+KDnpIjzqYyFJv
         p4PQ==
X-Gm-Message-State: ANhLgQ16CYYw5EsuHN7bcEFkA7mZc+Fj66HajLIfQsqT9M9LOt6CVfhN
        w6TQqsbuvlr9G98WD+GYA0jXqMjUqf/dAgyc9g8=
X-Google-Smtp-Source: ADFU+vu5vkoZ00IvdcwmUORyaXyf5rUDI5J5AtwELVd3n5hON/5WIx2LDdNJc+S+CRyducg2f3JQTc/GkML1ceMrvEI=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr1138688qtk.171.1584594667691;
 Wed, 18 Mar 2020 22:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200318222746.173648-1-maskray@google.com>
In-Reply-To: <20200318222746.173648-1-maskray@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Mar 2020 22:10:56 -0700
Message-ID: <CAEf4BzYJ2+y2SkjJME6f0duhG0GTo1BWqs5qdLK=F4=wBhxc9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6] bpf: Support llvm-objcopy for vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 3:27 PM Fangrui Song <maskray@google.com> wrote:
>
> Simplify gen_btf logic to make it work with llvm-objcopy. The existing
> 'file format' and 'architecture' parsing logic is brittle and does not
> work with llvm-objcopy/llvm-objdump.
> 'file format' output of llvm-objdump>=11 will match GNU objdump, but
> 'architecture' (bfdarch) may not.
>
> .BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag
> because it is part of vmlinux image used for introspection. C code can
> reference the section via linker script defined __start_BTF and
> __stop_BTF. This fixes a small problem that previous .BTF had the
> SHF_WRITE flag (objcopy -I binary -O elf* synthesized .data).
>
> Additionally, `objcopy -I binary` synthesized symbols
> _binary__btf_vmlinux_bin_start and _binary__btf_vmlinux_bin_stop (not
> used elsewhere) are replaced with more commonplace __start_BTF and
> __stop_BTF.
>
> Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
>
> We use a dd command to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
> ET_EXEC as an input file is an extremely rare GNU ld feature that lld
> does not intend to support, because this is error-prone.
>
> The output section description .BTF in include/asm-generic/vmlinux.lds.h
> avoids potential subtle orphan section placement issues and suppresses
> --orphan-handling=warn warnings.
>
> v6:
> - drop llvm-objdump from the title. We don't run objdump now
> - delete unused local variables: bin_arch, bin_format and bin_file
> - mention in the comment that lld does not allow an ET_EXEC input
> - rename BTF back to .BTF . The section name is assumed by bpftool
> - add output section description to include/asm-generic/vmlinux.lds.h
> - mention cb0cc635c7a9 ("powerpc: Include .BTF section")
>
> v5:
> - rebase on top of bpf-next/master
> - rename .BTF to BTF
>
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Fixes: cb0cc635c7a9 ("powerpc: Include .BTF section")
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Tested-by: Stanislav Fomichev <sdf@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: clang-built-linux@googlegroups.com
> ---

Thanks for detailed commit message and comments in the script, that's
very helpful. Looks good to me, I've tested with my local setup and
everything works across bpftool, selftests and my private BTF tool,
which doesn't use libbpf.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>

>  arch/powerpc/kernel/vmlinux.lds.S |  6 ------
>  include/asm-generic/vmlinux.lds.h | 15 +++++++++++++++
>  kernel/bpf/btf.c                  |  9 ++++-----
>  kernel/bpf/sysfs_btf.c            | 11 +++++------
>  scripts/link-vmlinux.sh           | 24 ++++++++++--------------
>  5 files changed, 34 insertions(+), 31 deletions(-)

[...]
